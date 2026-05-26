<details open>
<summary><b>083-Network-Connectivity-Center-GCP-Part-2 (KK-CS45-script-v3)</b></summary>

# Session 083: Network Connectivity Center Part 2 - Star Topology

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
- [Lab Demo](#lab-demo)
- [Summary](#summary)

## Overview
This session covers the Star Topology in Google Cloud's Network Connectivity Center (NCC) Part 2. Unlike the Mesh topology from Part 1, Star topology focuses on centralized connectivity where Edge spokes can only communicate with designated Center spokes, while Center spokes can reach all spokes. This provides segmentation and security controls for VPC networks that need centralized access without full mesh connectivity.

## Key Concepts/Deep Dive
Star topology in NCC is a connectivity pattern designed for scenarios requiring network segmentation and centralized control. It consists of two primary spoke types: **Edge Spokes** and **Center Spokes**.

### Topology Structure
In Star topology:
- **Edge Spokes**: VPC networks that can only communicate with designated Center Spokes and their associated subnets
- **Center Spokes**: VPC networks that can communicate with all other spokes in the topology

This creates a hub-and-spoke model where the Center spokes act as centralized connection points.

### Comparison with Mesh Topology

| Feature | Mesh Topology | Star Topology |
|---------|---------------|---------------|
| Connectivity | All VPCs can communicate with each other | Edge VPCs only communicate with Center VPCs |
| Supported Spoke Types | VPC, Hybrid, Producer | VPC only |
| Route Exchange | Supports dynamic routes | Does not support dynamic route exchange |
| Use Case | Full connectivity between all networks | Segmented connectivity with centralized access |

> [!NOTE]
> The transcript contained several typos that have been corrected for clarity, including: "mes" → "Mesh", "bpc" → "VPC", "Start topology" → "Star topology", and "Edge groups can only Comm with the center groups" → proper capitalization and grammar.

### Use Cases for Star Topology
Star topology is ideal when:
1. **Workloads in different VPC Networks** require access to centralized shared service VPCs but do not need direct communication with each other
2. **Security controls** need to enforce traffic flow through centralized network virtual appliances (NVAs)
3. **Separation of duties** is required between different VPC networks

### Groups in Star Topology
- **Groups are automatically created** when you create a Star topology hub
- **Center Group**: Can communicate with all Center and Edge spokes
- **Edge Group**: Can only communicate with Center spokes
- **Assignment**: Each VPC spoke belongs to one group at a time

### Limitations
Star topology connectivity does not support:
- Hybrid spokes (Interconnect, HA VPN, Router appliances)
- Dynamic route exchange

## Lab Demo
The demonstration creates a Star topology hub and configures spokes in different groups to showcase connectivity behavior.

### Prerequisites
- Two GCP projects with VPC networks and subnets
- NCC service enabled in both projects

### Step 1: Create Star Topology Hub
1. Navigate to Network Connectivity Center in Google Cloud Console
2. Click "Create hub"
3. Name the hub (e.g., "starhub")
4. Select "Star" topology
5. Click "Create"

### Step 2: Configure Hub Settings
1. In the hub details, verify two groups are automatically created:
   - Center group
   - Edge group
2. Configure auto-accept settings for additional project IDs if needed

### Step 3: Add Edge Spoke
```bash
# In first project console
gcloud services enable networkconnectivity.googleapis.com

# Create VPC spoke in edge group
gcloud network-connectivity spokes create spoke-edge \
  --hub=projects/[PROJECT_ID]/locations/global/hubs/starhub \
  --description="Edge spoke in first project" \
  --spoke-group=EDGE \
  --vpc-network=projects/[PROJECT_ID]/locations/global/networks/vpc1
```

### Step 4: Add Second Edge Spoke
Repeat similar process in second project to create another edge spoke.

### Step 5: Add Center Spoke
```bash
# Create VPC spoke in center group
gcloud network-connectivity spokes create spoke-center \
  --hub=projects/[PROJECT_ID]/locations/global/hubs/starhub \
  --description="Center spoke" \
  --spoke-group=CENTER \
  --vpc-network=projects/[PROJECT_ID]/locations/global/networks/vpc2
```

### Step 6: Test Connectivity
Create VMs in different VPCs and test connectivity:

1. **Edge to Edge**: Should fail (no direct connectivity)
   ```bash
   ping [EDGE_VM_IP_FROM_ANOTHER_EDGE]
   # Expected: No response
   ```

2. **Edge to Center**: Should succeed
   ```bash
   ping [CENTER_VM_IP]
   # Expected: Successful ping
   ```

3. **Center to All**: Should succeed for all spokes
   ```bash
   ping [ANY_VM_IP_IN_ANY_SPOKE]
   # Expected: Successful ping
   ```

### Route Table Verification
Review routes in NCC console:
- **Center Group**: Shows routes to all spokes (e.g., 192.168.3.0/24, 10.0.5.0/24, etc.)
- **Edge Group**: Shows routes only to Center spokes

## Summary

### Key Takeaways
```diff
+ Star topology provides centralized connectivity with Edge spokes connecting only to Center spokes
+ Center spokes can reach all spokes in the topology, enabling hub-and-spoke architecture
+ Ideal for scenarios requiring segmentation and centralized security controls
+ Groups (Center/Edge) are automatically created and define connectivity permissions
+ Only supports VPC spokes; no hybrid or dynamic route exchange capabilities
- Edge spokes cannot communicate directly with each other
- Requires manual configuration of spoke group assignments
```

### Quick Reference
**Hub Creation:**
```bash
gcloud network-connectivity hubs create starhub \
  --description="Star topology hub" \
  --topology=STAR \
  --location=global
```

**Edge Spoke Creation:**
```bash
gcloud network-connectivity spokes create [SPOKE_NAME] \
  --hub=[HUB_URI] \
  --spoke-group=EDGE \
  --vpc-network=[VPC_URI]
```

**Center Spoke Creation:**
```bash
gcloud network-connectivity spokes create [SPOKE_NAME] \
  --hub=[HUB_URI] \
  --spoke-group=CENTER \
  --vpc-network=[VPC_URI]
```

**Common Subnet Ranges (from demo):**
- 192.168.3.0/24, 10.0.21.0/24, 10.0.5.0/24, 10.0.4.0/24, 10.0.6.0/24

### Expert Insight
**Real-world Application**: Deploy Star topology when implementing multi-tier architectures where application tiers need centralized access to shared services (databases, APIs) but should be isolated from each other. For example, use Center spokes for monitoring/logging VPCs that all Edge workloads need to reach, while preventing lateral movement between production workloads.

**Expert Path**: Master NCC by understanding IAM roles (roles/networkconnectivity.admin), customizing routing with VPC network tags, and integrating with Cloud Router for advanced BGP scenarios. Explore NCC with Private Service Connect for pub/sub services.

**Common Pitfalls**: 
- Misassigning spoke groups (Center vs Edge) can break connectivity flow
- Forgetting that full mesh policies don't apply in Star topology
- Assuming hybrid connectivity (VPN, Interconnect) works in Star topology when it's not supported
</details>
