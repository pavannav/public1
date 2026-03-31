# Session 83: Star Topology in Network Connectivity Center GCP Part 2

## Table of Contents
- [Mesh vs. Star Topology Introduction](#mesh-vs-star-topology-introduction)
- [Star Topology Overview](#star-topology-overview)
- [When to Choose Star Topology](#when-to-choose-star-topology)
- [Groups in Star Topology](#groups-in-star-topology)
- [Limitations and Restrictions](#limitations-and-restrictions)
- [Demo: Configuring Star Topology Hub](#demo-configuring-star-topology-hub)
- [Demo: Adding Edge Spokes](#demo-adding-edge-spokes)
- [Demo: Testing Edge-to-Edge Communication](#demo-testing-edge-to-edge-communication)
- [Demo: Adding Center Spokes](#demo-adding-center-spokes)
- [Demo: Testing Connectivity Across Groups](#demo-testing-connectivity-across-groups)
- [Summary](#summary)

> [!NOTE]  
> Corrections made to transcript: "Mass topology" corrected to "Mesh topology", "meain" to "maintain", "bpc" to "VPC", "reputations" to "configurations" (contextual assumption), "htting" not present but minor typos like "seet" to "subnet", "vhp" not in transcript. Misspelled words like "comm" to "cannot communicate", "meain" to "maintain", "bpc" to "VPC".

## Mesh vs. Star Topology Introduction
### Overview
This session continues from Part 1, focusing on Star topology in Google Cloud's Network Connectivity Center. Mesh topology allows all VPCs to communicate with each other, whereas Star topology introduces segmentation by categorizing spokes into Edge and Center groups. Star topology enables controlled connectivity where Edge spokes can only reach Center spokes, enforcing security and separation of duties, while Centers can communicate with all other spokes.

### Key Concepts/Deep Dive
- **Mesh Topology Recap**: In Mesh, every VPC spoke communicates with every other VPC spoke, promoting full interconnectivity.
- **Star Topology Contrast**: Only supported with VPC spokes (not hybrid or Producer spokes). Uses a hub-and-spoke model with groups:
  - **Edge Spokes**: Limited connectivity to designated Center spokes only.
  - **Center Spokes**: Can reach all other spokes, including other Centers and Edges.
- **Connectivity Rules**:
  - Edge VPC A can connect to Center VPC B and Center VPC C.
  - Edge VPC D can connect to Center VPC A and Center VPC B.
  - Edges cannot communicate with each other.
- **Benefits**:
  - Ensures segmentation and connectivity separation.
  - Useful for maintaining separation of duties while allowing centralized access.

> [!IMPORTANT]  
> Star topology prevents lateral movement across Edge VPCs, enhancing security by funneling traffic through Centers.

## Star Topology Overview
### Overview
Star topology is designed for scenarios where workloads in different VPC networks need access to shared services but not to each other. It uses groups (Edge and Center) to define connectivity policies automatically created when the hub is set up.

### Key Concepts/Deep Dive
- **Supported Types**: VPC spokes only. No support for on-premises connectivity via hybrid spokes (e.g., Cloud VPN, Cloud Interconnect, Router appliance).
- **Groups**:
  - **Edge Group**: Spokes here can only reach Center groups.
  - **Center Group**: Spokes here can reach Edges and other Centers.
- **Routing**: Centered on routing tables that include routes to all reachable IPs based on group membership.
- **Configuration Details**:
  - Each VPC spoke belongs to one group at a time.
  - Groups are auto-created when the hub is created in the console.

![Star Topology Diagram](mermaid-diagram-for-star-topology)

```mermaid
graph TD
    subgraph "Edge VPC A"
    EA[Edge Spoke A]
    end
    subgraph "Center VPC B"
    CB[Center Spoke B]
    end
    subgraph "Center VPC C"
    CC[Center Spoke C]
    end
    subgraph "Edge VPC D"
    ED[Edge Spoke D]
    end
    EA --> CB
    EA --> CC
    ED --> CB
    ED --> CC
    CB --> CC  # Centers can communicate with each other
    CB --> ED
    CC --> EA
    style EA fill:#f9f
    style ED fill:#f9f
    style CB fill:#bfb
    style CC fill:#bfb
```

- **Connectivity Matrix**:
  | From/To | Edge VPC A | Edge VPC D | Center VPC B | Center VPC C |
  |---------|------------|------------|--------------|--------------|
  | Edge VPC A | ❌ | ❌ | ✅ | ✅ |
  | Edge VPC D | ❌ | ❌ | ✅ | ✅ |
  | Center VPC B | ✅ | ✅ | ✅ | ✅ |
  | Center VPC C | ✅ | ✅ | ✅ | ✅ |

## When to Choose Star Topology
### Overview
Star topology is ideal when you need controlled access to centralized resources without allowing direct communication between peripheral workloads. It's commonly used for multi-tenant environments or security-hardened architectures where traffic must pass through intermediary appliances.

### Key Concepts/Deep Dive
- **Use Cases**:
  - Workloads in different VPC networks require access to central shared services but not each other.
  - Enforce security controls where traffic passes through centralized network virtual appliances (e.g., NVAs).
- **Examples**:
  - Departmental VPCs accessing a central database or authentication service.
  - All traffic routed through a security NVA in the Center for inspection.
- **Advantages**:
  - **Segmentation**: Prevents unauthorized lateral traffic.
  - **Centralization**: Simplifies policy enforcement at the Center.
  - **Scalability**: Scale thousands of Edge VPCs all connecting to limited Center VPCs.

> [!NOTE]  
> Contrast with Mesh: Choose Star for security-first designs; Mesh for full collaboration.

## Groups in Star Topology
### Overview
Groups automate connectivity rules. Edge groups isolate spokes, Center groups act as hubs. A spoke can belong to only one group.

### Key Concepts/Deep Dive
- **Automatic Creation**: Groups are created with the hub.
- **Membership Rules**:
  - Edge: Outbound only to Centers.
  - Center: Bidirectional to all.
- **Examples**:
  - 1 Edge can connect to 10 Centers.
  - 1,000 Edges connect only to Centers, not each other.

## Limitations and Restrictions
### Overview
Star topology has specific restrictions compared to Mesh, primarily excluding on-premises integrations.

### Key Concepts/Deep Dive
- **Unsupported Features**:
  - Hybrid spokes or dynamic route exchange (e.g., BGP exchange with Cloud Interconnect, Cloud VPN, or Router appliance).
  - Producer spokes.
- **Subnet Rules**: Follow same rules as Mesh: No overlapping subnets across spokes in the same hub.
- **Explicit Limitations**:
  > [!WARNING]
  > Like Mesh, ensure no subnet overlaps. Routes are automatically propagated based on group rules.

## Demo: Configuring Star Topology Hub
### Overview
In this demo, create a new hub with Star topology and explore auto-created groups.

### Lab Demos
1. Navigate to Network Connectivity Center in Google Cloud Console.
2. Click "Create Hub".
3. Provide a name, e.g., `starhub`.
4. Select "Star" for topology (vs. Mesh).
5. Skip adding spokes initially for demonstration.
6. Click "Create".
7. View hub details: Observe auto-created "Center" and "Edge" groups.
8. Edit hub: Enable auto-accept for projects if desired (specify project IDs).

```bash
# Commands for hub creation (console-based, no CLI shown)
echo "Hub created with groups: Center, Edge"
```

## Demo: Adding Edge Spokes
### Overview
Add VPC spokes and assign them to Edge groups, demonstrating restricted connectivity.

### Lab Demos
1. Go to Spokes in the hub.
2. Click "Add Spoke".
3. Select VPC network (e.g., from Project 1, with subnet 192.168.3.0).
4. Choose hub `starhub`.
5. Provide spoke name.
6. Assign to "Edge" group.
7. Add project and create.
8. For second project: Repeat, assign to "Edge" group, and accept if auto-accept not set.
9. Observe in Routes: Edge group shows no routes (since Edges don't connect to each other).

```yaml
# Example spoke configuration (dummy YAML for clarity)
spoke:
  name: "vpc1-spoke"
  group: "edge"
  vpc_network: "vpc1"
  project_id: "project-1"
```

## Demo: Testing Edge-to-Edge Communication
### Overview
Verify that Edge spokes cannot communicate with each other, enforcing segmentation.

### Lab Demos
1. Create VMs in each Edge VPC (e.g., Project 1 VPC1 and Project 2 VPC1).
2. Ping between VMs in Edge spokes.
3. Result: Connectivity fails (no routes between Edges).
4. Check route table: Edge group routes = 0.

```bash
# From VM in Project 1 Edge VPC
ping <project-2-edge-vm-ip>  # Fails: No route
```

## Demo: Adding Center Spokes
### Overview
Add spokes to Center groups and observe expanded routing.

### Lab Demos
1. Add spoke to Center group (e.g., Project 1 VPC2, subnet 192.168.5.0).
2. Repeat for Project 2 VPC2 (subnet 192.168.4.0-6.0).
3. View route tables:
   - Center group: Routes include Edge subnets (3.0, 21.0) and other Centers.
   - Edge group: Routes include Center subnets (5.0, 4.0, 6.0).

```bash
# Ping from Center VM to Edge VMs
ping <edge-vm1-ip>  # Succeeds
ping <edge-vm2-ip>  # Succeeds
```

## Demo: Testing Connectivity Across Groups
### Overview
Demonstrate that Center spokes can reach all others, while Edges remain isolated.

### Lab Demos
1. From Center VM, ping both Edge VMs: Succeeds.
2. From Edge VM1 to Center: Succeeds.
3. From Edge VM1 to Edge VM2: Fails.

```diff
! Connectivity Summary:
+ Center → Edge: ✅
+ Center → Center: ✅
+ Edge → Center: ✅
- Edge → Edge: ❌
! Security enforced by group segregation.
```

## Summary

### Key Takeaways
```diff
+ Star topology enforces controlled connectivity with Edge/Center groups.
+ Edge spokes connect only to Centers; Centers connect everywhere.
+ Ideal for security-focused designs with centralized services.
+ Groups auto-created; spokes assigned manually.
+ No hybrid spoke support, unlike Mesh.
+ Demos show routing tables reflect group rules.
- Avoid Star if needing full mesh interconnectivity.
- Test subnet overlaps and update auto-accept project lists.
! Use for production environments requiring segmentation.
```

### Expert Insight
- **Real-world Application**: In production, deploy NVAs in Center VPCs for traffic inspection (e.g., firewall rules). Scale to thousands of Edges connecting to few Centers for cost-efficient security.
- **Expert Path**: Master by designing multi-project architectures, automating spoke assignments via Terraform. Study routing policies and integrate with VPC Service Controls.
- **Common Pitfalls**: Forgetting subnet overlaps leading to route conflicts; assigning wrong groups causing unintended isolation. Cache route tables and monitor via logs.
- **Common Issues & Resolution**: Route propagation delays—wait 5-10 mins post-creation; connectivity fails—verify group assignment and subnets. Avoid: Assuming Edges can communicate; not enabling auto-accept for prod scaling.
- **Lesser Known Things**: Groups can be edited post-creation for dynamic re-assignment; expos conditional routing based on spoke attributes; integrates with GCP Identity for cross-project hubs.

```bash
echo "Session complete. Model ID: CL-KK-Terminal"
```
