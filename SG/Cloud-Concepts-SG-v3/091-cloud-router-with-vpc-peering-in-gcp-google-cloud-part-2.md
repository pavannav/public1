# Session 091: Cloud Router with VPC Peering in GCP - Part 2

<details open>
<summary><b>Cloud Router with VPC Peering in GCP - Part 2 (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [VPC Peering with VPN Networks](#vpc-peering-with-vpn-networks)
  - [Route Exchange in Peering](#route-exchange-in-peering)
  - [Cloud Router Custom Advertisement](#cloud-router-custom-advertisement)
  - [Regional vs Global Routing](#regional-vs-global-routing)
- [Lab Demo: Configuring VPC Peering with Route Advertisement](#lab-demo-configuring-vpc-peering-with-route-advertisement)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview

This session explores how VPC peering interacts with Cloud Router and VPN connections in Google Cloud. It demonstrates how to enable traffic flow between peered VPC networks that need access to on-premises networks through VPN, focusing on route advertisement and import/export configurations that are essential for proper connectivity.

## Key Concepts and Deep Dive

### VPC Peering with VPN Networks

When multiple VPC networks need access to the same on-premises network via VPN, creating individual VPN connections for each VPC can become cost-prohibitive. VPC peering provides an efficient alternative by allowing networks to share VPN connectivity through a peered connection.

The scenario involves:
- **Network A**: A VPC that needs access to on-premises resources
- **Network B**: A VPC connected to on-premises via VPN
- **Goal**: Allow Network A to reach on-premises through Network B's VPN connection

```
graph TD
    A[Network A] --> P[VPC Peering]
    B[Network B] --> P
    B --> V[VPN to On-Premises]
    V --> O[On-Premises Network]
    
    P -.->|Routes must be exchanged| A
    V -.->|Traffic flows| A
```

### Route Exchange in Peering

For traffic to flow bidirectionally in a VPC peering setup, both networks must explicitly exchange routes:

- **Local VPC Network Administrator**: Enable *custom route export* to share VPN-acquired routes with the peer network
- **Peer VPC Network Administrator**: Enable *custom route import* to accept and use the shared routes

This export/import mechanism allows dynamic routing information (learned from on-premises) to propagate across the peering connection.

### Cloud Router Custom Advertisement

By default, Cloud Router does not advertise routes received through VPC peering, even when using the default "advertise all routes" mode. This creates an asymmetric routing issue where traffic can reach peered networks but cannot return due to missing reverse route advertisements.

**Solution**: Configure Cloud Router to use *custom advertisement mode* that includes:
- All local subnet ranges visible to Cloud Router
- Specific peering route ranges that need advertisement to on-premises

The custom advertisement configuration requires specifying each IP range that should be advertised, ensuring precise control over what external networks can reach internal peered resources.

### Regional vs Global Routing

Cloud Router operates regionally by default, which affects how peering routes are handled:

- **Regional Cloud Router**: Only shares routes within the same region (e.g., `asia-south1`)
- **Global Routing**: When VPC is configured for global dynamic routing, it enables cross-region route propagation

This regional limitation means that:
- Peered subnets in the same region as the VPN connection work automatically
- Cross-region peered subnets require explicit custom advertisement configuration
- Traffic asymmetry occurs if return paths aren't properly advertised

## Lab Demo: Configuring VPC Peering with Route Advertisement

### Step 1: Create VPC Peering Connections

```bash
# Navigate to VPC Network > VPC network peering
# Create connection for Network A -> Network B
Name: network-a-to-b
Local VPC: network-a
Peer VPC: network-b
Exchange custom routes: Enable export

# Create reverse connection for bidirectional peering
Name: network-b-to-a  
Local VPC: network-b
Peer VPC: network-a
Exchange custom routes: Enable import
```

### Step 2: Configure Cloud Router Custom Advertisement

```bash
# Edit Cloud Router in the VPC with VPN connection
# Click "Advertise routes" section
# Change from "Default" to "Create custom routes"

# Configure advertisement settings:
- Advertise all subnets visible to the Cloud Router: Yes
- Custom advertisement ranges:
  - 10.128.0.0/16  # Peer subnet range - asia-south1
  - 10.160.0.0/16  # Peer subnet range - us-central1

# Save configuration
```

### Step 3: Verify Route Propagation and Connectivity

```bash
# Check route tables in VPC Networks > Routes
# Filter by destination IP to verify imported routes

# Test connectivity from peered VPC VM
ping <peer-vm-internal-ip>

# Verify Cloud Router learned routes
# Cloud Router > Learned routes (should show peer ranges)
```

### Troubleshooting Traffic Flow Issues

1. **Routes visible but ping fails**: Check Cloud Router advertisement configuration
2. **Asymmetric routing**: Verify custom ranges include all peered subnet ranges
3. **Regional connectivity issues**: Confirm VPC dynamic routing mode (regional vs global)
4. **Missing routes**: Ensure both export and import checkboxes are enabled in peering

## Summary

### Key Takeaways

```diff
+ VPC peering shares VPN connectivity without creating multiple expensive VPN tunnels
+ Custom route exchange must be explicitly enabled for peered networks to share VPN routes
- Cloud Router default mode does not advertise peering routes to external networks
+ Custom advertisement mode required to share peered subnet ranges with on-premises
+ Regional Cloud Router limitations affect cross-region peered network connectivity
- Missing custom advertisements cause asymmetric routing and dropped return traffic
+ Step-by-step troubleshooting checklist: routing mode → peering exchange → router advertisement
```

### Quick Reference

**Peering Setup Commands:**
```bash
gcloud compute networks peerings create [PEERING-NAME] \
    --network=[LOCAL-NETWORK] \
    --peer-network=[PEER-NETWORK] \
    --export-custom-routes \
    --import-custom-routes
```

**Custom Advertisement Configuration:**
```yaml
# cloud_router_advertisement_config.yaml
advertiseMode: CUSTOM
groups:
  - includeAllSubnets: true
  - ipRanges:
    - range: 10.128.0.0/16
      description: peered-network-subnet-a
    - range: 10.160.0.0/16  
      description: peered-network-subnet-b
```

**Connectivity Test Commands:**
```bash
# From peered VM, test connectivity
ping [TARGET-VM-IP]

# Verify routes are learned
gcloud compute routers get-status [ROUTER-NAME] --region=[REGION]
```

### Expert Insight

**Real-world Application**: In enterprise GCP environments with hub-and-spoke topologies, use VPC peering with Cloud Router custom advertisement to centralize VPN infrastructure while maintaining regional isolation. This pattern reduces costs by 60-80% compared to individual VPN connections per VPC.

**Expert Path**: Master BGP session overrides for finer-grained route control. Combine peering with Network Connectivity Center for advanced multi-cloud connectivity, focusing on route priority and traffic engineering across peered and VPN-connected networks.

**Common Pitfalls**: 
- Forgetting to enable custom advertisement after VPC peering results in unreachable peered subnets
- Misconfigured regional/global routing modes causing unexpected connectivity failures
- Over-advertising routes without proper security group controls, potentially exposing internal services to external networks

</details>
