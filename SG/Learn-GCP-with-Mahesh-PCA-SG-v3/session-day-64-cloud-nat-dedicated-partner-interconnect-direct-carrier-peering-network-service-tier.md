# Session 64: Cloud NAT, Dedicated & Partner Interconnect, Direct & Carrier Peering, Network Service Tier

## Table of Contents
- [Cloud NAT Overview](#cloud-nat-overview)
- [Cloud NAT Key Concepts and Deep Dive](#cloud-nat-key-concepts-and-deep-dive)
- [Cloud NAT Lab Demo](#cloud-nat-lab-demo)
- [Dedicated & Partner Interconnect Overview](#dedicated--partner-interconnect-overview)
- [Dedicated & Partner Interconnect Key Concepts](#dedicated--partner-interconnect-key-concepts)
- [Dedicated & Partner Interconnect Lab Demo](#dedicated--partner-interconnect-lab-demo)
- [Direct & Carrier Peering Overview](#direct--carrier-peering-overview)
- [Direct & Carrier Peering Key Concepts](#direct--carrier-peering-key-concepts)
- [VPC Flow Logs Overview](#vpc-flow-logs-overview)
- [VPC Flow Logs Key Concepts](#vpc-flow-logs-key-concepts)
- [VPC Flow Logs Lab Demo](#vpc-flow-logs-lab-demo)
- [Network Service Tier Overview](#network-service-tier-overview)
- [Network Service Tier Key Concepts](#network-service-tier-key-concepts)
- [Summary](#summary)

## Cloud NAT Overview
Cloud NAT (Network Address Translation) is a Google Cloud service that enables outbound internet connectivity for VMs and Kubernetes clusters without requiring external IP addresses. It translates private IP addresses to public IP addresses for outbound traffic, providing secure and cost-effective internet access while blocking inbound unsolicited traffic. This session covers the fundamentals of Cloud NAT, including its purpose, workings, regional scope, and integration with other GCP services, building on previous discussions like VPN and firewall rules.

## Cloud NAT Key Concepts and Deep Dive
### Purpose of Cloud NAT
Traditional VMs often require external IP addresses for internet access, but this introduces security risks. Cloud NAT solves this by allowing outbound traffic using shared public IPs, while inbound connections are only allowed for established responses. Key requirements for internet access include a default internet gateway route (automatically created with VPCs), egress firewall rules (typically open by default), and either external IPs or NAT for private IPs.

### How Cloud NAT Works
Cloud NAT performs Source Network Address Translation (SNAT) for outbound traffic and Destination Network Address Translation (DNAT) for inbound responses. For VMs with private IPs, source IPs are translated to NAT IPs, ensuring privacy. Example: A VM at `10.5.4.2` accessing MongoDB appears as the NAT IP (e.g., `35.45.65.1`). This allows secure outbound access while masking internal addresses.

| Concept              | Description                                                                 |
|----------------------|-----------------------------------------------------------------------------|
| SNAT                 | Translates source IP from private to public for outbound packets.          |
| DNAT                 | Translates destination IP for established inbound response packets.        |
| Outbound Only        | Inbound unsolicited traffic is blocked; only responses to initiated flows. |
| Encryption           | Unencrypted by default, as traffic stays within Google network.            |

NAT operates at the VPC router level and is a regional resource. It uses Static IP allocations for whitelisting or Automatic for dynamic scaling, with logging options for troubleshooting. Private NAT (introduced ~1.5 years ago) extends this to VPC-to-VPC traffic with overlapping IPs.

### VPN Context
This session assumes familiarity with VPN (Classic and HA). NAT complements VPN by handling IP address conflicts in peered networks, enabling direct connectivity without complex routing.

### Differences: NAT vs. No NAT
- ✅ Without NAT: Requires external IPs, increases attack surface.
- ❌ With NAT: Secure outbound, external IPs masked, reduced costs.

## Cloud NAT Lab Demo
### Prerequisites and VPC Setup
Ensure a custom VPC with subnets and private Google access enabled. Avoid overlapping CIDRs in peered VPCs.

1. **Create VPC and Subnets**:
   ```bash
   gcloud compute networks create custom-vpc-03 --subnet-mode=custom
   # Note: This creates the default internet gateway route implicitly.
   ```

2. **Create Subnets**:
   ```bash
   gcloud compute networks subnets create subnet-us-central --network=custom-vpc-03 --region=us-central1 --range=10.5.5.0/24 --enable-private-ip-google-access
   gcloud compute networks subnets create subnet-mumbai --network=custom-vpc-03 --region=asia-south1 --range=172.16.0.0/24 --enable-private-ip-google-access
   ```

3. **Delete Unnecessary Peering**:
   Manually remove any existing peering via UI to avoid overlaps.

### Create VMs Without External IPs
4. **Create VMs with Private IPs**:
   ```bash
   gcloud compute instances create vm-us-01 --network=custom-vpc-03 --subnet=subnet-us-central --zone=us-central1-a --no-address
   gcloud compute instances create vm-mumbai-01 --network=custom-vpc-03 --subnet=subnet-mumbai --zone=asia-south1-a --no-address
   # Use full service account for access (e.g., Compute Engine default service account).
   ```

### Configure Cloud NAT
5. **Create Cloud Router**:
   ```bash
   gcloud compute routers create cloud-router-us --network=custom-vpc-03 --region=us-central1
   ```

6. **Create Cloud NAT**:
   ```bash
   gcloud compute routers nats create cloud-nat-us --router=cloud-router-us --region=us-central1 --nat-external-ip-pool=auto --auto-allocate-ips --enable-logging --log-filter=ALL
   ```
   - This applies to all subnets in the region.
   - For manual IPs: Reserve a static IP first via `gcloud compute addresses create`.

### Verification and Logging
7. **Test Connectivity**:
   - SSH into VMs: VMs can access Google services (e.g., GCS via `gsutil list`) due to private Google access. Without NAT, external sites like Bing fail.
   - With NAT enabled: Ping external sites succeeds; logs capture NAT IP translations.

8. **View NAT Logs**:
   - In VPC > Cloud NAT > cloud-nat-us > Logs tab.
   - Sample log entry:
     ```
     2024-XX-XX: Source-IP: 10.5.5.2, Destination-IP: 8.8.8.8, NAT-IP: 35.45.65.1, Traffic: Outbound (Query)
     ```

### Advanced: Private NAT for VPC Peering
- Create another VPC with overlapping CIDR (e.g., 10.5.4.0/24).
- For transparency, private NAT allows peering by translating IPs, mitigating overlaps.
- Demo: Attempt peering without private NAT (fails); enable private NAT and retry.
- Note: As of latest, private NAT for peering is in beta; confirm via UI.

9. **Cleanup**:
   - Delete VMs: IPs scale down automatically in auto mode.
   - Manual IPs persist; delete separately.

> [!NOTE]
> Auto-allocation scales dynamically, ideal for variable loads. Manual provides static IPs for whitelisting.

## Dedicated & Partner Interconnect Overview
Interconnect provides high-bandwidth (Mbps to Gbps), low-latency connections between on-premises networks and GCP, leveraging Google’s global network. Unlike VPNs (up to 3 Gbps/tunnel), Interconnect offers direct physical links for enterprise workloads needing high throughput, such as data migration or hybrid cloud setups.

## Dedicated & Partner Interconnect Key Concepts
### Dedicated Interconnect
Connects on-premises directly to Google's PoP (Point of Presence) via fiber optics. Bandwidth ranges from 10 Gbps (multiples of 10) to 200 Gbps (100/200). It's unencrypted, regional, and requires physical infrastructure.

| Feature                  | Dedicated Interconnect |
|--------------------------|------------------------|
| Bandwidth               | 10-200 Gbps           |
| Latency                 | Low (direct link)     |
| Setup Time              | ~5 business days      |
| Cost                     | High                  |
| Encryption              | Optional (VPN over)   |
| SLA                     | Full (99.9%+)         |

### Partner Interconnect
Leverages service providers (e.g., ISPs) for connections not reaching Google's PoP. Bandwidth: 50 Mbps to 50 Gbps. No infrastructure purchase needed; redundancy via providers.

| Feature                  | Partner Interconnect  |
|--------------------------|------------------------|
| Bandwidth               | 50 Mbps-50 Gbps       |
| Latency                 | Variable              |
| Setup Time              | Faster (provider)     |
| Cost                     | Medium                |
| Encryption              | Optional (VPN over)   |
| SLA                     | Provider-dependent    |

### Cross-Cloud & Carrier Peering
- Cross-Cloud: Extends to AWS/Azure (up to 200 Gbps).
- Direct Peering: Connects business networks to Google Workspace using public IPs; cost-effective for latency-insensitive traffic.
- Carrier Peering: For failed direct peering requests; relies on carriers.

### VPN vs. Interconnect
- 🚀 Quick Setup: VPN (minutes).
- 🚫 High Speed: Interconnect.
- Use VPN first; upgrade to Interconnect for bandwidth needs.

> [!WARNING]
> Interconnect requires physical reach to PoP; not feasible for all locations.

## Dedicated & Partner Interconnect Lab Demo
### Dedicated Interconnect Setup
1. **Order Connection**:
   - Network > Hybrid Connectivity > Cloud Interconnect.
   - Choose Dedicated Interconnect > Order new connection.
   - Select Location (e.g., Tata Mumbai IC GPX).
   - Specify 10 Gbps (minimum), redundancy for SLA.

2. **Provide Details**:
   - Letter of Authority (LOA) emailed post-order (fax/scanned if needed).
   - Hand over to on-premises team for physical connection.

### Partner Interconnect Setup
3. **Partner Selection**:
   - Check GCP Partner Directory (e.g., Airtel, Tata).
   - Request LOA; providers handle cabling.

4. **VLAN and Router**:
   - Create Cloud Router: `gcloud compute routers create my-router --network=my-vpc --region=us-central1`.
   - Attach VLAN: Link to Partner Interconnect.

5. **Test and Route**:
   - Advertise on-premises routes via BGP.
   - Verify: Ping GCP instances; latency should be minimal.

> [!IMPORTANT]
> Examine costs; dedicated is premium for mission-critical apps.

## Direct & Carrier Peering Overview
Direct Peering connects business networks directly to Google's edge using public IPs, bypassing private networks. Ideal for Google Workspace access; carrier peering as fallback via ISPs.

## Direct & Carrier Peering Key Concepts
### Direct Peering
- Uses public IPs; free/low-cost setup if conditions met.
- Submit request at peering.google.com; Google reviews.
- Bandwidth: Up to 10 Gbps; unencrypted, public.

| Feature       | Direct Peering |
|---------------|---------------|
| IPs           | Public        |
| Cost          | Low/Free      |
| Bandwidth    | Up to 10 Gbps |
| Encryption    | None          |
| Use Case      | Workspace/Light Traffic |

### Carrier Peering
- Via ISPs if direct fails.
- Higher cost; broader reach.

> [!NOTE]
> Prefer VPN/Interconnect for secure, private connections.

## VPC Flow Logs Overview
VPC Flow Logs capture network traffic between VMs in a VPC, aiding security analysis, cost optimization, and troubleshooting.

## VPC Flow Logs Key Concepts
- Enabled per subnet; samples traffic (e.g., 50% rate).
- Fields: Source/Destination IPs, ports, bytes, VPC info.
- Filters: Exclude zero-byte packets to reduce noise.
- Integration: Export to BigQuery for analytics.

## VPC Flow Logs Lab Demo
1. **Enable Logs**:
   ```bash
   gcloud compute networks subnets update subnet-us-central --zone=us-central1 --enable-flow-logs --flow-logging-sampling=0.5 --flow-logging-home=INTERVAL_5_SEC
   ```

2. **Generate Traffic**:
   - Ping between VMs: `ping 10.5.5.3`.

3. **View Logs**:
   - Logs Explorer > Resource: VPC Flow Logs.
   - Filter: `source_ip == "10.5.5.2" AND bytes_sent > 0`.

4. **Analyze**:
   - Block egress with firewall rule: Traffic stops; logs reflect.

## Network Service Tier Overview
Google Cloud offers Premium (low-latency) and Standard (cost-effective) network tiers for internet access.

## Network Service Tier Key Concepts
- **Premium**: Direct via Google's global network; higher cost, low latency.
- **Standard**: Best-effort via public internet; cheaper, higher hops.
- Applicable to VMs, Load Balancers with external IPs.

| Tier      | Cost | Latency | Routing |
|-----------|------|---------|---------|
| Premium   | High | Low     | Google Backbone |
| Standard  | Low  | Higher  | Public/Partner |

## Summary
### Key Takeaways
```diff
+ Cloud NAT enables secure outbound internet access for private IPs, regional resource.
- Avoid external IPs without NAT; leads to no internet connectivity.
! Interconnect for high-bandwidth needs; VPN for quick private connections.
! Peering suits public IP traffic; prioritize security over cost savings.
+ VPC Flow Logs help monitor and optimize network traffic at subnet level.
- Use Premium Tier for latency-sensitive apps; Standard for cost efficiency.
```
### Quick Reference
- **NAT Creation**: `gcloud compute routers nats create nat-name --router=router --auto-allocate-ips`.
- **Interconnect Redundancy**: Add 99%+ SLA with second link.
- **Flow Logs Filter**: `bytes_sent > 0 AND source_ip="vm-ip"`.
- **Network Tier Check**: VPC > Network services > Network Service Tier.

### Expert Insight
**Real-world Application**: Use NAT for containerized apps in GKE to access external APIs securely without exposing clusters. Combine with VPN for hybrid setups.  
**Expert Path**: Master BGP routing for Interconnects; certify in GCP Networking for complex designs.  
**Common Pitfalls**: Overlooking regional NAT limits in multi-region VPCs; forgetting to configure egress rules for logs.  
**Lesser-Known Facts**: Auto NAT IPs scale down to zero cost after VM deletion; premium tier reduces global latency by ~25%.  
**Advantages and Disadvantages**: NAT secures traffic but blocks unsolicited inbound; Interconnect excels in scale but requires physical setup.
