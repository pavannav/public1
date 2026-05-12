# Section 11: Introduction to Hybrid networking

<details open>
<summary><b>Section 11: Introduction to Hybrid networking (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [11.1 Introduction to Hybrid networking](#111-introduction-to-hybrid-networking)
- [11.2 Static Routing vs Dynamic Routing](#112-static-routing-vs-dynamic-routing)
- [11.3 How Border Gateway Protocol (BGP) works](#113-how-border-gateway-protocol-bgp-works)
- [11.4 BGP Route selection - ASPATH, LOCAL_PREF, MED](#114-bgp-route-selection---aspath-local_pref-med)

## 11.1 Introduction to Hybrid networking

### Overview
This module introduces the fundamental concept of hybrid networking in AWS, focusing on connecting on-premise data centers to AWS cloud infrastructure. It establishes the importance of hybrid networking for AWS certification exams and outlines the key AWS services used for secure connectivity between on-premise and cloud environments. The lecture sets the foundation for understanding Site-to-Site VPN, Client VPN, and AWS Direct Connect as primary options for hybrid networking implementations.

### Key Concepts

#### Hybrid Networking Architecture
- **VPC Focus to Hybrid Connectivity**: Transition from intra-AWS networking (VPC endpoints, peering, Transit Gateway) to connecting on-premise data centers to AWS VPCs
- **Private vs Public Access**: Enabling resources in connected networks to communicate using private IP addresses instead of public IPs
- **Direct Connectivity Options**: Three main approaches for hybrid connectivity

#### AWS Service Options

##### AWS Site-to-Site VPN
- **Architecture**: Virtual Private Gateway (VGW) attached to VPC + IPSec tunnel over internet
- **Traffic Flow**: Secure encrypted communication between networks
- **Limitations**: Internet dependency introduces potential bandwidth, jitter, and latency issues

##### Client VPN (Client-to-Site VPN)
- **Use Case**: Individual users working from home needing access to company AWS network
- **Connection Method**: User machines connect to AWS Client VPN endpoint
- **Access Level**: Direct access to VPC resources using private IPs

##### AWS Direct Connect
- **Physical Connectivity**: Dedicated fiber connection from data center to AWS
- **Reliability**: Consistent network performance without internet dependency
- **Enterprise Requirement**: Recommended for organizations requiring guaranteed bandwidth and low latency

#### Prerequisites and Dependencies
- **Routing Fundamentals**: Emphasized need to understand static vs dynamic routing before Direct Connect
- **BGP Protocol**: Critical understanding of Border Gateway Protocol for advanced networking
- **Routing Attributes**: BGP route selection based on ASPATH, LOCAL_PREF, and MED attributes

## 11.2 Static Routing vs Dynamic Routing

### Overview
This module explains the fundamental difference between static and dynamic routing approaches in VPN connections, using practical network topology examples. It introduces the concept of Autonomous Systems (AS) and ASN (Autonomous System Number) as unique network identifiers. The lecture demonstrates how static routing requires manual configuration while dynamic routing enables automatic route propagation, setting the stage for BGP-enabled hybrid networking in AWS.

### Key Concepts

#### Autonomous Systems (AS)
- **Definition**: Unique network identifier allowing routers to exchange routing information
- **ASN Assignment**: Two types:
  - **Public ASN**: Assigned by IANA (Internet Assigned Numbers Authority), ranges 0-65535
  - **Private ASN**: Designated range 64512-65534 for internal network use
- **AWS Integration**: AWS assigns default private ASN for VPC-to-on-premise connections

#### Static Routing
- **Manual Configuration**: Network administrators must manually add route entries to routing tables
- **Network Expansion Issues**:
  ```diff
  - Problem: New network connections require manual route table modifications
  - Example: Network A (10.10.0.0/16) connecting to Network C (10.30.0.0/16) via Network B requires updating route tables in all three locations
  ```
- **Route Table Structure**:
  - Destination CIDR block
  - Next hop router IP
  - Local route entries for source network

```bash
# Static Route Example
# Network A Route Table:
# Destination: 10.20.0.0/16 → Next Hop: Router B IP (192.168.1.2)
# Network B Route Table:
# Destination: 10.10.0.0/16 → Next Hop: Router A IP (192.168.1.1)
```

#### Dynamic Routing
- **Automatic Propagation**: Routing information automatically shared between connected networks
- **Protocol Dependency**: Relies on protocols like BGP to exchange route information
- **Topology Change Adaptation**: New network connections automatically discovered and routed

> [!NOTE]
> Dynamic routing solves static routing's scalability limitations by eliminating manual route table management for network topology changes.

## 11.3 How Border Gateway Protocol (BGP) works

### Overview
This comprehensive module explores BGP (Border Gateway Protocol) as the foundation for internet routing and AWS hybrid networking implementations. BGP enables dynamic route exchange between Autonomous Systems using path-vector routing protocol. The lecture explains iBGP (internal BGP) and eBGP (external BGP) operations, demonstrating how routing information propagates through network topologies and enables resilient, failover-capable connectivity.

### Key Concepts

#### BGP Fundamentals
- **Path-Vector Protocol**: Exchanges routing information including complete path sequence to destinations
- **Autonomous System Focus**: Each network segment identified by unique ASN
- **Internet Backbone**: BGP forms the backbone of internet routing infrastructure

#### BGP Types
- **iBGP (Internal BGP)**: Routing within single Autonomous System
- **eBGP (External BGP)**: Routing between different Autonomous Systems (focus for hybrid networking)

#### BGP Route Exchange
- **BGP Table Structure**:
  - **Destination**: Target network CIDR
  - **Next Hop**: IP address of adjacent BGP peer
  - **AS PATH**: Sequence of AS numbers traversed to reach destination

```yaml
# Example BGP Route Table Entries
routes:
  - destination: "10.10.0.0/16"  # Local AS
    next_hop: "0.0.0.0"
    as_path: "I"
  - destination: "10.20.0.0/16"  # Adjacent AS
    next_hop: "10.20.0.1"
    as_path: "200,I"
  - destination: "10.30.0.0/16"  # Multiple paths available
    next_hop: "10.40.0.1"
    as_path: "400,I"
```

#### Multi-Path Benefits
- **Redundancy**: Multiple routes to same destination enable automatic failover
- **Dynamic Updates**: New network connections automatically propagated to all BGP peers
- **Resilient Networking**: Maintains connectivity even during link failures

## 11.4 BGP Route selection - ASPATH, LOCAL_PREF, MED

### Overview
This advanced module focuses on BGP route selection criteria and how administrators can influence routing decisions using BGP attributes. AS PATH prepending, Local Preference, and Multi-Exit Discriminator (MED) are explored as tools for traffic engineering and optimizing network performance. The lecture demonstrates practical scenarios where these attributes help select optimal paths based on bandwidth, latency, and administrative preferences rather than default shortest-path algorithms.

### Key Concepts

#### Route Selection Hierarchy
BGP route selection follows specific priority order (highest weight not covered as Cisco-specific):

1. **Highest Local Preference** (within AS, default: 100)
2. **Shortest AS PATH** (AS hop count)
3. **Lowest MED value** (between AS peers, default: 0)
4. **Additional criteria** (BGP attributes and route origin)

#### ASPATH Attribute
- **Purpose**: Influence outbound traffic path selection based on path "length"
- **Mechanism**: Prepend own ASN multiple times to make path appear longer
- **Use Case**: Force traffic through higher-bandwidth routes despite shorter direct paths

```diff
+ Scenario: Direct 2Mbps link vs 10Mbps path via intermediate AS
+ Action: Prepend ASPATH on direct link (AS200, AS200, AS200, AS200 assuming source AS100)
+ Result: Traffic routes through AS400 intermediary for better bandwidth
- Default Behavior: BGP selects direct 2Mbps link due to shorter path length (lower hop count)
```

#### Local Preference (LOCAL_PREF)
- **Scope**: Internal to Autonomous System only
- **Function**: Direct outbound traffic through preferred exit points within source network
- **Default Value**: 100 (higher values take precedence)
- **Exchange**: Not shared with external BGP peers

##### Example Network Topology
```yaml
source_as:
  router_A:
    next_hop: "AS400 → AS300"
    local_pref: 200  # Higher preference
  router_B:
    next_hop: "AS200 → AS300"
    local_pref: 100  # Default preference
```
✅ **Traffic Flow**: Source router selects Router A for AS300 traffic due to higher LOCAL_PREF

#### Multi-Exit Discriminator (MED)
- **Scope**: Between external Autonomous Systems
- **Function**: Influence inbound traffic from neighboring AS when multiple entry points exist
- **Decision Factor**: Lowest MED value preferred when ASPATH and LOCAL_PREF are equal
- **Use Case**: Optimize incoming traffic patterns between interconnected networks

##### Multi-Exit Scenario
```diff
+ AS100 (Source) has two connections to AS400 (Target)
+ Connection 1: Direct link, MED value = 2
+ Connection 2: Alternate link, MED value = 5
+ Result: AS100 routes traffic through first connection due to lower MED
```

## Summary

### Key Takeaways
```diff
+ Hybrid networking enables seamless connectivity between on-premise data centers and AWS VPCs
+ AWS Site-to-Site VPN provides encrypted tunnels over internet but affected by bandwidth limitations
+ Direct Connect delivers consistent performance through dedicated fiber connections
+ BGP serves as the routing protocol backbone for dynamic route exchange in hybrid environments
+ BGP attributes (ASPATH, LOCAL_PREF, MED) allow traffic engineering and path optimization
+ Static routing requires manual configuration while dynamic routing automates route propagation
- Manual route management in static routing leads to scalability challenges in growing networks
- Internet-based VPN connections may encounter reliability issues with bandwidth and latency
- BGP complexity requires thorough understanding for effective hybrid networking implementation
```

### Quick Reference
#### BGP Route Selection Order:
1. **Weight** (Cisco-specific, not AWS focus)
2. **LOCAL_PREF** (> value = preferred)
3. **AS PATH** (shorter = preferred)
4. **MED** (< value = preferred)

#### Common Commands:
```bash
# View BGP neighbors
show ip bgp neighbors

# Show BGP route table
show ip bgp summary

# BGP configuration example
router bgp [ASN]
 neighbor [peer-ip] remote-as [peer-ASN]
```

### Expert Insight

#### Real-world Application
In enterprise environments, hybrid networking serves critical infrastructure needs. Financial institutions implement Direct Connect for sub-millisecond latency trading applications. Healthcare organizations use Site-to-Site VPN for secure patient data synchronization between hospital data centers and AWS analytics platforms. Manufacturing companies establish BGP-based hybrid connectivity for IoT device management, ensuring real-time production monitoring with automatic failover capabilities.

#### Expert Path
Master BGP implementation fundamentals through AWS console-based labs, focusing on Transit Gateway route propagation. Study real-world TCP/IP packet flows using tools like Wireshark to visualize BGP update messages. Implement complex routing scenarios involving multiple attachments and understand the interaction between LOCAL_PREF values across interconnected VPCs.

#### Common Pitfalls
Misconfigured BGP attributes leading to traffic blackholing due to asymmetric routing. Failing to account for BGP route dampening causing instability after network outages. Not implementing proper network monitoring, missing critical link failures and path performance degradation.

#### Lesser-Known Facts
BGP convergence times can take up to several minutes in large networks, significantly different from dynamic routing protocols like OSPF's sub-second convergence. AWS assigns private ASN 64512 by default to Virtual Private Gateways, but organizations can request public ASNs for specific<large> requirements.

</details>