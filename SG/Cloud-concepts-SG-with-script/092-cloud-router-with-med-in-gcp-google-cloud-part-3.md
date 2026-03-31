# Session 03: Cloud Router with MED in GCP

## Table of Contents
- [BGP Best Path Selection in Legacy Mode](#bgp-best-path-selection-in-legacy-mode)
- [Multi-Exit Discriminator (MED) Concept](#multi-exit-discriminator-med-concept)
- [Region-to-Region Costs and Base Priority](#region-to-region-costs-and-base-priority)
- [Demo: Configuring Cloud Router for MED](#demo-configuring-cloud-router-for-med)
- [Summary](#summary)

## BGP Best Path Selection in Legacy Mode

### Overview
In Google Cloud Platform (GCP), Cloud Router uses BGP (Border Gateway Protocol) to exchange routing information between networks. In legacy mode (the default mode), BGP employs a deterministic best path selection algorithm to choose the optimal route for traffic. This process ensures reliable connectivity by prioritizing routes based on specific criteria, preventing routing loops, and optimizing performance. The selection focuses on three primary methods: AS path length, origin type, and Multi-Exit Discriminator (MED) value. Understanding this process is crucial for beginners to avoid misconfigurations that can lead to suboptimal routing or traffic blackholing.

### Key Concepts/Deep Dive
BGP best path selection works by sorting available routes (next hops) from multiple tunnels or peers and eliminating lower-priority options step by step. Here are the three key methods used in legacy mode:

1. **Shortest AS Path Length**:  
   BGP first prioritizes routes with the shortest AS (Autonomous System) path length. ASNs (Autonomous System Numbers) form a sequence in the path, and shorter sequences are preferred as they indicate fewer network hops. BGP sorts next hops by AS path length (shortest to longest) and removes all except the shortest. For example:
   - Path 1: 3 ASNs (e.g., 64513 64514 64515)  
   - Path 2: 5 ASNs (e.g., 64513 64514 64515 64516 64517)  
   BGP would discard the 5-ASN path and proceed with the 3-ASN path. If paths are equal, selection moves to origin type.

2. **Origin Type Preference**:  
   Routes are categorized by their origin attribute: IGP (Interior Gateway Protocol, highest preference), EGP (Exterior Gateway Protocol), or Incomplete (lowest preference, often from static routes or direct connections not via proper IGP/BGP). BGP prefers IGP over EGP over Incomplete. If at least one next hop has IGP origin, all EGP and Incomplete hops are removed. Otherwise, EGP beats Incomplete. In demonstrations where no proper IGP is configured, routes often show "Incomplete" origin, limiting full testing.

3. **Smallest MED Value**:  
   MED (Multi-Exit Discriminator) is used to influence path selection for active/passive setups or load balancing. It's a metric advertised by peers to indicate preference. BGP sorts routes by increasing MED value (smallest first) and removes non-smallest options. Lower MED values indicate higher preference. In GCP, this creates primary (low MED) and backup (high MED) paths. If not specified, default is 100 for Cloud VPN tunnels or Cloud Interconnect attachments.

> **Note**: These steps apply before considering other factors like router ID or IP address. Equal paths may lead to load balancing or ECMP (Equal Cost Multi-Path).

### Code/Config Blocks
In GCP Console, configure BGP sessions under Cloud Router:

```bash
# Example BGP session configuration (via gcloud CLI)
gcloud compute routers add-interface ROUTER_NAME \
  --interface-name INTERFACE_NAME \
  --bgp-peer-name PEER_NAME \
  --bgp-peer-asn PEER_ASN \
  --region REGION

# Set advertise priority (MED) for a BGP peer
gcloud compute routers update-bgp-peer ROUTER_NAME \
  --peer-name PEER_NAME \
  --advertised-route-priority PRIORITY \
  --region REGION
```

For Terraform:

```hcl
resource "google_compute_router_bgp_peer" "peer" {
  name     = "peer-name"
  router   = google_compute_router.router.name
  region   = google_compute_router.router.region
  peer_ip_address = "169.254.1.1"
  peer_asn   = 64514
  advertised_route_priority = 100  # MED value
}
```

### Tables
| Method | Description | Preference Order | Notes |
|--------|-------------|------------------|-------|
| AS Path Length | Shorter sequences preferred | Shortest → Longest | Eliminates longer paths first |
| Origin Type | Protocol-based preference | IGP > EGP > Incomplete | Common in on-prem setups |
| MED Value | Advertiser-chosen metric | Smallest → Largest | Used for active/passive config |

## Multi-Exit Discriminator (MED) Concept

### Overview
The Multi-Exit Discriminator (MED) is a BGP attribute that helps create active/passive relationships between multiple connections to the same network. By setting MED values, network engineers can steer traffic toward preferred paths (e.g., Cloud VPN tunnels) while keeping others as backups. In GCP, MED is controlled via the "advertised route priority" (base priority) in Cloud Router BGP sessions, ranging from 0 (highest) to 65,535 (lowest), defaulting to 100. This allows fine-grained control over routing decisions, essential for redundancy and cost optimization.

### Key Concepts/Deep Dive
- **Active/Passive Setup**: Assign lower MED values to primary tunnels (e.g., 100 via direct Cloud VPN) and higher to backups (e.g., 500 via higher-cost interconnect). GCP adds region-to-region costs to MED for cross-region routes, inflating the final priority.
- **GCP Mechanics**: Cloud Router advertises routes with MED values; BGP selects the lowest combined MED (route priority + region cost). For example, a base priority of 100 plus a 458 region-to-region cost results in a total MED of 558.
- **Examples**:
  - Two VPN tunnels: Primary MED 200, Backup MED 500. Traffic prefers 200 unless it fails.
  - Cross-region: US Central (base 100) to Europe West (region cost 300) = MED 400; US West (350 cost) = MED 450. Traffic takes the lower MED path.
- **Topology Control**: Use base priorities from 0-200 for active paths (as region costs range from 201-499 in some regions). Set values like 10,200+ for permanent backups to avoid unintentional overrides.

> **Important**: Base priorities inadvertently set above 200 might get overridden by region-to-region costs, causing unexpected traffic routing.

### Code/Config Blocks
Set MED via GCP Console or CLI:

```bash
# Change BGP advertised route priority
gcloud compute routers update-bgp-peer ROUTER_NAME \
  --peer-name PEER_NAME \
  --advertised-route-priority 200 \
  --region REGION
```

## Region-to-Region Costs and Base Priority

### Overview
GCP applies region-to-region costs to route priorities when advertising routes across regions. These costs range from 200-499 inclusive (not configurable) and are added to base priorities to determine final MED. This affects inter-region traffic flow, where lower combined values are preferred. Recommended base priorities are 0-200 per region to ensure active paths aren't accidentally demoted to backup.

### Key Concepts/Deep Dive
- **Cost Calculation**: Total MED = Base Priority + Region-to-Region Cost. Example: Route from Asia to US Central (cost 458) with base 100 = MED 558.
- **Recommendations**: Keep base priorities ≤200. Values >200 may cause paths to be superseded if region costs are invariant.
- **Examples**:
  - Scenario 1: On-prem connects to two cloud routers. Lowest MED (considering base + local costs) wins.
  - Scenario 2: VM in Europe prefers US Central path (cost 300) over direct European path if local base drives higher MED.
- **Factor Awareness**: Costs depend on geographic distance/latency; monitor via GCP Console or logs, as they fluctuate.

> **Note**: Cloud Router in standard mode (via VPC networks flag) ignores region-to-region costs for egress; legacy mode includes them.

### Lab Demos
1. **Observing Route Priorities**:
   - Create Cloud Router with BGP sessions (default MED 100).
   - View learned routes: Mumbai region → 100; US Central region → 558 (100 base + 458 cost).
   - Ping VM in Mumbai; logs show traffic via primary tunnel with lowest MED.

2. **Changing Backup to Primary**:
   - Edit BGP session; set advertised route priority to 200.
   - Routes refresh: Selected session MED increases to 658.
   - Other session remains 100/558.
   - Ping again; traffic shifts to the now-lower-MED tunnel.
   - Observe suppressed routes: Higher-MED paths marked suppressed, not deleted, unless sessions fail.

3. **Multi-Region Demo**:
   - Configure second VPN gateway in US Central.
   - Add cloud router with MED 100.
   - Compare routes: New router MED 100 (US) vs. 558 (Asia).
   - Traffic from Europe VM prefers MED 100 path (US Central tunnel).
   - Enable VPC global peering to connect regions.
   - Adjust MED to 900; routes suppress, promoting original tunnel.

## Summary

### Key Takeaways
```diff
+ BGP best path selection uses AS path length, origin type, then MED for optimal routing.
+ MED helps create active/passive configurations via advertised route priorities.
+ Region-to-region costs add to base priorities; keep base <200 for active paths.
+ Suppressed routes stay available as backups if primary paths fail.
+ Demo highlights dynamic MED changes for traffic steering.
```

### Expert Insight
- **Real-world Application**: Use MED for hybrid cloud setups, directing traffic via cost-effective tunnels (e.g., Cloud VPN) and keeping Interconnect as backup. Monitor with Cloud Logging for route changes.
- **Expert Path**: Master BGP by practicing in GCP Console/CLI, then advancing to BGP route policies for custom filters. Explore GCP standard mode for modern networks.
- **Common Pitfalls**: Setting base priorities >200 leads to demotion; forgetting suppressed routes exist can cause confusion. Issues like incomplete origins inhibit full path control—resolve via proper IGP/BGP. Connections timeouts if BGP sessions flap; mitigate with keepalives.
- **Common Issues and Resolution**: Misconfigurations like wrong ASN or IP duplicates cause flapping—check `gcloud routers describe` and logs. Latency spikes suppress routes unexpectedly; adjust MED based on monitoring. Lesser-known: GCP internal metrics (like 117 MED in demos) override explicit MED if region costs apply differently for egress. Routes aren't permanently deleted; use `--no-suppress` for visibility but watch for loops. 

(Note: Transcribed typos corrected, e.g., "air path" to "AS path", "hoop" to "hop", "BGP task" to "BGP best path selection", "ME" to "MED", "croud" to "Cloud").
