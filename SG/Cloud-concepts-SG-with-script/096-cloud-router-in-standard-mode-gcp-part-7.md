# Session 096: BGP Route Selection Process in Standard Mode (GCP)

## Table of Contents
- [Introduction to Standard Mode](#introduction-to-standard-mode)
- [Why Use Standard Mode](#why-use-standard-mode)
- [Configuration Options in Standard Mode](#configuration-options-in-standard-mode)
- [BGP Path Selection Process](#bgp-path-selection-process)
- [Lab Demos](#lab-demos)
- [Summary](#summary)
- [Expert Insight](#expert-insight)

## Background
This session covers the BGP route selection process when using Cloud Router in standard mode within Google Cloud Platform (GCP). It explains the advantages over legacy mode, key configuration options, and demonstrates practical implementations through command-line operations and console interactions. The instructor demonstrates path selection using AS path prepending, MED comparison across routers, and inter-region cost considerations, highlighting how to achieve traffic engineering in a Cloud environment.

## Introduction to Standard Mode

### Overview
In GCP Cloud Router, BGP (Border Gateway Protocol) operates in two main modes: legacy mode and standard mode. Standard mode provides closer adherence to RFC 4271, enhancing BGP functionality and flexibility. Legacy mode is Google's default recommendation but lacks full BGP feature support, making standard mode preferable for network engineers requiring advanced BGP capabilities like traffic engineering through AS path prepending and fine-tuned route ranking.

### Key Differences from Legacy Mode
- **Consistent AS Path-Based Routing**: Standard mode considers AS path information across all Cloud Routers in the VPC, enabling traffic flow influence via AS path prepending.
- **Enhanced Customization**: Offers better control over BGP prefix ranking, community usage, and dynamic route prioritization over static routes.
- **RFC Compliance**: Fully implements BGP standards, ensuring predictable and configurable behavior.

> **Note**: Legacy mode may not properly apply configurations like AS path prepending, leading to unexpected traffic routing despite correct setup.

## Why Use Standard Mode

### Benefits for Network Engineers
Standard mode is ideal for scenarios requiring full BGP feature set:

- **Traffic Engineering**: Manipulate route preferences across multiple Cloud Routers using AS path prepending, MED comparison, and dynamic routing policies.
- **Scalability**: Supports complex multi-router VPC setups with consistent path selection.
- **Diagnostic Capabilities**: Provides better visibility into route advertisements and learned routes.

Google recommends legacy mode for basic setups but advises standard mode for production environments needing BGP-specific controls.

### Common Use Cases
- Multi-region deployments requiring specific traffic paths.
- Load balancing across redundant VPN tunnels.
- Implementing routing policies for hybrid cloud architectures.

## Configuration Options in Standard Mode

### Compare MED Values
MED (Multi-Exit Discriminator) comparison determines route preference based on configured values. Standard mode offers three main options:

- **Default (No Comparison)**: Compares MED values only across sessions within a single Cloud Router. Routes from different routers remain isolated, preventing cross-router optimization.
- **Always Compare**: Evaluates MED values across all Cloud Routers in the VPC. The route with the lowest MED (after AS path checks) becomes primary, regardless of originating router.
- **Conditional Compare**: Groups prefixes by originating AS; then ranks based on MED within those groups.

### Add Region to Inter-Region Cost
This option incorporates inter-region network costs (latency and distance factors) into MED calculations:

- Automatically adjusts MED values for cross-region traffic.
- Prevents suboptimal routing by preferring intra-region paths unless explicitly configured otherwise.
- Enables intelligent cost-based routing without manual MED adjustments.

### Examples of Traffic Engineering
```diff
! Default MED Comparison: Within single router only
+ Always Compare: Optimizes across all routers in VPC
- Legacy Mode: May ignore preconfigured preferences
```

## BGP Path Selection Process

### Step-by-Step Algorithm
BGP path selection in standard mode follows RFC 4271-compliant logic, processed sequentially across all eligible routes:

1. **Shortest AS Path Length**: Routes are sorted by AS path length (number of AS hops). Shorter paths are preferred; ineligible routes are eliminated.
2. **Origin Type Comparison**: Prioritizes routes by their origin (IGP > EGP > Incomplete). Removes routes of lower origin types.
3. **Neighbor ASN Check**: Evaluates the ASN of the announcing neighbor for tie-breaking.
4. **MED Comparison**: Based on configuration (always/compare within router/conditional), lower MED values win. Incorporates any configured inter-region costs.
5. **Subsequent Steps** (if ties remain): Considers additional attributes like eBGP vs iBGP, router ID, and internal metrics (not detailed in session).

### Visualization
```mermaid
graph TD
    A[All Routes Available] --> B[Sort by Shortest AS Path Length]
    B --> C[Filter by Origin Type: IGP > EGP > Incomplete]
    C --> D[Check Neighbor ASN]
    D --> E[Compare MED (per configuration)]
    E --> F[Selected Best Path]
```

## Lab Demos

### Demo 1: AS Path Prepending and Mode Switching
**Objective**: Demonstrate how AS path prepending only functions in standard mode, enabling traffic engineering between VPN tunnels.

**Setup Prerequisites**:
- Two VPCs with Cloud Routers (e.g., Project1 and Project2).
- VPN tunnels connecting regions (e.g., Europe VM, Mumbai VMs).
- GCP Console/Cloud Shell access.

**Steps**:

1. **Initial Verification in Legacy Mode**:
   - Navigate to Cloud Router console for each VPC.
   - Confirm "Path Selection Mode" is set to "Legacy".
   - Ping between VMs (e.g., from Europe VM to Mumbai VM at 10.10.1.x).
   - Review logs in Cloud Logging to confirm tunnel usage (e.g., via query: `destination.instance.address = "10.10.0.0/24"`).
   - Observe: Traffic uses default tunnel despite AS path policies.

2. **Create BGP Route Policy**:
   - Use Cloud Shell to create an export policy for AS path prepending:
     ```bash
     gcloud compute routers add-route-policy ROUTER_NAME \
         --policy=asp_path_prepend_policy \
         --description="Add AS path prepend for priority control" \
         --region=REGION \
         --set-priority=100 \
         --set-description="Export policy for 10.10.0.0/24"
     ```
   - Add a policy term to prepend AS path:
     ```bash
     gcloud compute routers add-route-policy-term asp_path_prepend_policy \
         --priority=200 \
         --match-range=10.10.0.0/24 \
         --action-add-aspath="64512" \
         --region=REGION
     ```
   - Attach policy to target BGP session:
     ```bash
     gcloud compute routers update-bgp-peer ROUTER_NAME \
         --peer-name=BGP_SESSION_NAME \
         --export-route-policy=asp_path_prepend_policy
     ```

3. **Verify Policy Attachment**:
   - Refresh BGP Route Policies in console.
   - Check advertised routes: Confermed AS path shows prepended values (e.g., 64512 64512).
   - Re-check logs: Confirm traffic still uses original tunnel (prepending ineffective in legacy mode).

4. **Switch to Standard Mode**:
   - Edit Cloud Router settings in VPC where traffic is received.
   - Change "Path Selection Mode" to "Standard".
   - Save and wait for propagation.

5. **Post-Switch Verification**:
   - Re-execute ping and review logs: Confirm traffic shifts to secondary tunnel.
   - Check BGP sessions and best routes: Preferred path now reflects prepended AS path.

### Demo 2: MED Comparison Across Routers
**Objective**: Show how "Always Compare MED" enables optimization across multiple Cloud Routers, even in different regions.

**Setup Prerequisites**:
- Existing setup with VPN tunnels in Asia and new tunnel in US Central region.
- MED values configured (e.g., Asia: 649, US: 403 via BGP peer settings).

**Steps**:

1. **Initial MED Check**:
   - Review advertised routes in Cloud Routers.
   - Confirm "Always Compare MED" is unchecked in standard mode.
   - Ping target IP and observe logs: Traffic uses Asia-based router despite US having lower MED.

2. **Enable Cross-Router Comparison**:
   - Edit VPC settings and check "Always Compare MED".
   - Save and await updates.

3. **Post-Enable Verification**:
   - Refresh Cloud Router best routes: Lower MED (403) from US appears.
   - Re-execute ping: Logs show traffic routing via US tunnel.

### Demo 3: Inter-Region Cost Integration
**Objective**: Illustrate how enabling inter-region cost preferences local routing by penalizing cross-region paths.

**Steps**:

1. **Enable Inter-Region Cost**:
   - In VPC settings, select "Add inter-region cost to MED".
   - Save changes.

2. **Observe Route Priority Changes**:
   - Check suppressed routes: US tunnel priority increases (e.g., to 65537 due to added cost).
   - Confirm best routes favor Asia-based local router despite MED differences.
   - Logs show restoration of local traffic flow.

**Configuration Table**:

| Option | Behavior | Use Case |
|--------|----------|----------|
| Always Compare MED | Compares MED across all Cloud Routers | Multi-region traffic optimization |
| Conditional Compare | Compares MED within AS groups | Hierarchical routing setups |
| Add Inter-Region Cost | Penalizes cross-region routes in MED | Prefer intra-region for latency |

## Summary

```diff
+ Standard Mode: Enables full BGP RFC 4271 compliance for advanced traffic engineering (AS path prepending, global MED comparison)
- Legacy Mode: Limited BGP features; requires mode switch for policies like AS path modification to take effect
! Configuration Options: Customize MED comparison and inter-region cost based on deployment needs
💡 Use standard mode for hybrid clouds or complex multi-builder setups requiring fine-grained control
📝 Ensure VPC-wide consistency when enabling cross-router MED comparison
⚠ Common Mistake: Forgetting to switch receiving VPC to standard mode after applying AS path policies
```

Mistake Corrections Notified:
- "BPC" corrected to "BGP" (appears multiple times as "BPC" in transcript, assumed typo).
- "BGB" corrected to "BGP".
- "aspart" corrected to "AS path".
- "mad" corrected to "MED".
- "Always compare MD" corrected to "Always compare MED".
- Minor contractions and spacing standardized for clarity.

## Expert Insight

- **Real-World Application**: In enterprise GCP deployments, standard mode facilitates cost-effective global traffic distribution. For instance, use AS path prepending to direct customer traffic through cheaper regions while maintaining redundancy via fallback tunnels. Pair with GCP Interconnect for low-latency BGP peering.

- **Expert Path**: Start with legacy mode for basic setups, then migrate to standard mode. Master RFC 4271 details (AS path attributes, MED semantics) and practice with GCP console simulations. Experiment with communities for advanced policy matching.

- **Common Pitfalls**: 
  - Incorrect policy attachment leads to unapplied rules. Always verify via console refreshes.
  - Overlooking mode synchronization between VPCs; policies fail if sender/receiver modes mismatch.
  - Inter-region cost calculates dynamically; monitor with Cloud Logging for unexpected suppressions.
  - Forgetting static routes take priority over dynamic; adjust MED to compensate.

Lesser-Known Aspects: Standard mode supports BGP communities for custom route tagging, enabling automated tagging-based routing. It also offers finer granular control via route policies, allowing regex-based matching on prefixes for complex traffic shaping. In multi-tenant environments, use conditional MED compare to isolate routing decisions per-AS group, preventing cross-tenant interference.
