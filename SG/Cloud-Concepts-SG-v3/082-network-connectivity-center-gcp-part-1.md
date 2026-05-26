# Session 82: Network Connectivity Center GCP - Part 1

<details open>
<summary><b>Session 82: Network Connectivity Center GCP - Part 1 (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Network Connectivity Center (NCC) Fundamentals](#network-connectivity-center-ncc-fundamentals)
  - [Hub Architecture](#hub-architecture)
  - [Spoke Types](#spoke-types)
  - [Mesh Topology](#mesh-topology)
  - [VPC Spokes](#vpc-spokes)
  - [Route Management](#route-management)
  - [Export and Import Filters](#export-and-import-filters)
  - [Overlapping Subnets](#overlapping-subnets)
- [Lab Demos](#lab-demos)
  - [Creating a Mesh Hub](#creating-a-mesh-hub)
  - [Adding VPC Spokes](#adding-vpc-spokes)
  - [Cross-Project Connectivity](#cross-project-connectivity)
  - [Exclude Filters Demo](#exclude-filters-demo)
  - [Overlapping Subnets Resolution](#overlapping-subnets-resolution)
- [Summary](#summary)

## Overview

This session introduces Google Cloud's Network Connectivity Center (NCC) as a centralized framework for managing complex network connectivity at scale. Focuses on VPC Spokes in mesh topology, demonstrating how to connect multiple VPC networks across projects and organizations using a hub-and-spoke model. Covers practical implementation, route management, filters, and collision resolution strategies.

## Key Concepts and Deep Dive

### Network Connectivity Center (NCC) Fundamentals

Network Connectivity Center (NCC) is Google's enterprise-grade framework for simplifying network connectivity management across Google Cloud resources. It operates on a **hub-and-spoke model** where:

- **Hub**: A global resource that acts as a central connectivity point
- **Spokes**: Network resources (VPC networks, Cloud VPN tunnels, Cloud Interconnect) that connect to the hub

**Key Benefits:**
- Reduces operational complexity of managing individual VPC network pairings
- Enables inter-VPC connectivity at scale
- Provides centralized route management
- Supports secure, internal IP-based communication without internet exposure

### Hub Architecture

A hub in NCC is a **global resource** that can contain spokes from:
- Same project
- Different projects within the same organization
- Different organizations

**Hub Characteristics:**
- Global scope (not tied to a specific region)
- Manages a centralized route table
- Supports auto-acceptance policies for trusted projects
- Topology types: Mesh (default) and Star
- Topology cannot be changed after creation

### Spoke Types

NCC supports three spoke types:

1. **VPC Spokes**: Connect VPC networks for inter-VPC connectivity
2. **Hybrid Spokes**: Connect on-premises or other cloud networks via:
   - Cloud VPN
   - Cloud Interconnect (Dedicated/Partner)
   - Router Appliances (VMs for SD-WAN)
3. **Producer VPC Spokes**: Connect to Google Cloud services (currently in preview)

Each spoke type has different supported topologies and use cases.

### Mesh Topology

In mesh topology, **all spokes communicate with each other** through the hub. This creates a fully interconnected network where:

- Every VPC spoke can reach every other VPC spoke
- Subnets within connected VPCs are fully reachable (unless filtered)
- All spokes belong to a single default group
- Traffic flows through Google's internal network

**Use Case:** Large enterprises needing full connectivity between multiple networks without complex pairing management.

### VPC Spokes

VPC Spokes enable **internal IP-based communication** between VPC networks:

- **Connectivity Scope**: Same project, different projects, different organizations
- **Hub Limit**: Each VPC spoke connects to one hub only
- **Route Exchange**: Spokes export and import all subnet routes (configurable via filters)
- **Traffic Path**: Inter-VPC traffic stays within Google Network
- **Security**: Does not bypass VPC firewall rules or network policies

**Comparison: VPC Spokes vs VPC Network Peering:**

| Aspect | VPC Spokes | VPC Network Peering |
|--------|------------|-------------------|
| Scale | Large enterprises with many networks | Small setups (2-3 networks) |
| Management | Centralized via NCC Hub | Individual pairing management |
| Route Control | Advanced filters and topology control | Simple full-mesh pairing |
| Performance | Optimized through hub routing | Direct connection |

### Route Management

The hub maintains a **centralized route table** that:

- Imports routes from all connected spokes
- Exports routes to enable cross-spoke communication
- Handles route prioritization and conflict resolution
- Supports IPv4 and IPv6 routes

**Route Table Dynamics:**
```
Hub Route Table Example:
- 192.168.10.0/24 → VPC Spoke A
- 10.0.1.0/24 → VPC Spoke B
- 172.16.0.0/16 → VPC Spoke C
```

All spokes receive the complete route table for connectivity.

### Export and Import Filters

Filters control **which subnet routes are shared** between spokes:

**Include/Export Ranges:**
```yaml
# Export specific private IP ranges
export_ranges:
  - 10.0.0.0/8      # Include all private IPs
  - 192.168.0.0/16  # Include specific ranges

# Export only custom ranges
export_ranges:
  - 10.100.0.0/16   # Include only this CIDR block
```

**Exclude Filters:**
```yaml
# Exclude sensitive subnets from sharing
exclude_ranges:
  - 10.0.5.0/24    # Do not share critical subnet
  - 10.0.10.0/24   # Exclude confidential resources
```

> [!NOTE]
> Filters apply at the spoke level and affect route table population
> Exclusion cannot be more granular than existing subnet boundaries

### Overlapping Subnets

**Overlapping subnets create routing conflicts** and must be resolved:

- NCC detects overlapping ranges during spoke approval
- **Resolution Strategies:**
  - Exclude overlapping ranges from both spokes
  - Restructure VPC subnets to eliminate overlap
  - Use different address spaces

> [!IMPORTANT]
> Routes must be unique in the hub's route table
> Sometimes rewritten as overlapping subnet collision prevents connectivity

## Lab Demos

### Creating a Mesh Hub

```bash
# Navigate to Network Connectivity Center in Google Cloud Console
# 1. Go to your project
# 2. Search for "Network Connectivity Center"
# 3. Click "Create Hub"

# Hub Configuration:
# - Name: test-hub
# - Topology: Mesh (default)
# - Optional: Add project IDs for auto-acceptance

# After creation, hub appears in the hub list
```

**Key Points from Demo:**
- Hub creation is region-agnostic
- Default topology is mesh
- Can add spokes immediately or add later

### Adding VPC Spokes

```bash
# Demo: Creating VPC Networks First

# In Second Project:
# 1. Go to VPC Networks → Create VPC network
# 2. Name: second-project-vpc1
# 3. Subnet: subnet1, Region: asia-south1, IP Range: 10.0.2.0/24

# Add Spoke in First Project:
# 1. Network Connectivity Center → Add Spoke
# 2. Type: VPC spoke
# 3. Name: first-project-vpc1
# 4. Select VPC: first-project-vpc1
# 5. Export Ranges: All private IP ranges

# Console Steps:
Go to Network Connectivity Center → Hubs → test-hub → Add spokes
```

### Cross-Project Connectivity

```bash
# In Second Project (another project's hub):
# 1. Network Connectivity Center → Add spokes
# 2. On another project → Paste project ID → Hub name: test-hub
# 3. Name: second-project-vpc1
# 4. Select VPC Network: second-project-vpc1
# 5. No filters (export all ranges)

# Spoke Status Initially: Pending Review (requires approval)
# In Hub Project: Hubs → test-hub → Spokes → Go to details → Accept

# Verification:
# VM in first VPC (192.168.1.2) ping VM in second VPC (10.0.2.100)
# Success: Connectivity established via NCC hub
```

**Route Table Verification:**
```
# After acceptance, view routes:
Hub → Routes → Select region → View subnet routes
- 192.168.1.0/24 (first project)
- 10.0.2.0/24 (second project)
```

### Exclude Filters Demo

```bash
# Create VPC with multiple subnets:
# VPC: first-project-vpc2
# Subnets:
# - subnet1: 10.0.4.0/24 (shareable)
# - subnet2: 10.0.5.0/24 (sensitive - exclude)

# Add Spoke with Exclude Filter:
# 1. Network Connectivity Center → Add spokes
# 2. Type: VPC spoke
# 3. Name: first-project-vpc2
# 4. VPC: first-project-vpc2
# 5. Export Ranges: All private IP ranges
# 6. Exclude Ranges: Add 10.0.5.0/24

# Route Table After Creation:
# - Shows only 10.0.4.0/24
# - 10.0.5.0/24 excluded (not advertised)
```

### Overlapping Subnets Resolution

```bash
# Situation: Two VPCs both using 10.0.4.0/24 range
# Attempt to add second VPC: Results in rejection

# Error Message:
# "The request cannot be accepted because the exported IP ranges of the spoke 
# second-project-vpc2 overlap with existing spokes in the hub."

# Resolution: Exclude from both sides

# In Second Project:
# 1. Add spoke with exclude filter: 10.0.4.0/24
# 2. Submit for approval: May still conflict if other spoke advertises same range

# Correct Approach:
# 1. Delete conflicting spoke
# 2. Add new spoke with exclude filter: 10.0.4.0/24
# 3. In first project: Delete current spoke
# 4. Recreate spoke with exclude filter: 10.0.4.0/20 (same range)

# Result:
# - Both projects exclude 10.0.4.0/24 from NCC routing
# - Range remains isolated within each VPC
# - No route collision
```

> [!IMPORTANT]
> Exclude filters must be applied symmetrically across conflicting spokes
> Once spoke is created with filters, cannot modify (must delete/rec.create)

## Summary

### Key Takeaways

```diff
+ NCC provides enterprise-scale network connectivity management
+ Hub-and-spoke model simplifies complex multisite connectivity
+ Mesh topology enables full interconnectivity between VPCs
+ Route filters provide granular control over shared subnets
+ Overlapping subnets must be excluded from both sides to resolve conflicts
- VPC spokes cannot be attached to multiple hubs simultaneously
- Topology cannot be changed after hub creation
- Cannot exclude partial subnet ranges - filters work at CIDR boundaries
- Overlapping subnets are critical and prevent hub acceptance
- Cost charged per VPC spoke per hour plus data transfer
```

### Quick Reference

**Common Commands:**
```bash
# No CLI commands shown in demo - all console operations
# For CLI operations:
gcloud network-connectivity hubs create test-hub
gcloud network-connectivity spokes create vpc-spoke \
  --hub=test-hub \
  --vpc-network=projects/my-project/global/networks/my-vpc
```

**Hub Creation Checklist:**
- [ ] Choose appropriate topology (Mesh for full connectivity)
- [ ] Configure auto-acceptance for trusted projects
- [ ] Plan VPC subnets to avoid overlaps

**Spoke Configuration Options:**
```yaml
# Include all private ranges
export_ranges: ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]

# Include specific range
export_ranges: ["10.100.0.0/16"]

# Exclude sensitive ranges
exclude_ranges: ["10.100.5.0/24"]
```

**Troubleshooting:**
- Check spoke status: Active, Pending Review, or Failed
- Review route table for missing subnets
- Validate firewall rules (NCC doesn't bypass them)
- Use auto-acceptance carefully in production

### Expert Insight

**Real-world Application**: Enterprises with complex multisite architectures use NCC for centralizing network management, reducing configuration drift across hundreds of VPC peering connections. Financial services leverage exclude filters to isolate sensitive subnets (PCI compliance zones) while enabling connectivity to shared services in designated subnets.

**Expert Path**: Master NCC by progressing through: 1) VPC spokes in mesh topology, 2) Star topology for hierarchical networks, 3) Hybrid spokes for on-premises connectivity, 4) Router appliances for SD-WAN integration, 5) Private Service Connect for Google service integration.

**Common Pitfalls**: 
- Assuming topology can be changed post-creation (requires hub recreation)
- Creating overlapping subnets across VPCs without exclusion plans  
- Overly restrictive auto-acceptance settings leading to manual approval bottlenecks
- Neglecting firewall rules - NCC doesn't bypass them
- Underestimating costs in large-scale deployments with hundreds of VPCs

</details>
