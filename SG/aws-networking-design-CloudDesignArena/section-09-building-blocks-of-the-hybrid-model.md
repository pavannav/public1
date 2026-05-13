# Section 9: Building Blocks of the Hybrid Model

<details open>
<summary><b>Section 9: Building Blocks of the Hybrid Model (KK-CS45-script-v2)</b></summary>

## Table of Contents

- [9.1 Building Blocks of the Hybrid Model](#91-building-blocks-of-the-hybrid-model)
- [9.2 Virtual Private Gateway (VGW)](#92-virtual-private-gateway-vgw)
- [9.3 Direct Connect Gateway (DXGW)](#93-direct-connect-gateway-dxgw)
- [9.4 AWS Transit Gateway (TGW) Part 1](#94-aws-transit-gateway-tgw-part-1)
- [9.5 AWS Transit Gateway (TGW) Part 2](#95-aws-transit-gateway-tgw-part-2)
- [Summary](#summary)

## 9.1 Building Blocks of the Hybrid Model

### Overview
This section introduces the hybrid model and hybrid architecture in AWS networking, focusing on advanced connectivity design decisions. The approach simplifies complex connectivity options by breaking them down into building blocks as individual components, then examining how they work together in various combinations. Design considerations, use cases, and recommendations for different service combinations are covered extensively.

### Key Concepts/Deep Dive

#### Building Blocks Approach
The hybrid connectivity is analyzed through three main building blocks:
- **AWS Network Service Endpoints**
- **Network Connection Options**
- **Customer Gateway Devices**

#### AWS Network Service Endpoints
These are the AWS service termination points for hybrid connectivity. Multiple options exist within each building block category, and combinations can be mixed based on specific requirements.

#### Network Connection Options
Various connectivity options are available, with detailed analysis of when to use each option versus others, including design scenarios and recommendations.

#### Customer Gateway Devices
While not heavily emphasized in design discussions, these devices require specific capabilities when using Direct Connect or IPsec VPN tunnels. AWS console generates device configurations, but documentation should be referenced for exact specifications during deployment.

#### Design Expansion
The course expands beyond basic AWS networking to include:
- **On-Premises Design**: Designing on-premises networks to achieve specific connectivity models
- **Connectivity Models**: Active-active, active-standby, load sharing configurations
- **Advanced Scenarios**: Interest scenarios covering different hybrid connectivity approaches

## 9.2 Virtual Private Gateway (VGW)

### Overview
The Virtual Private Gateway (VGW) is a regional logical object and highly available service that acts as a VPC gateway for terminating connections to external networks. It's part of AWS software-defined networking infrastructure and provides redundant connectivity across multiple Availability Zones.

### Key Concepts/Deep Dive

#### VGW Characteristics
- **Regional Component**: Exists at AWS region level
- **High Availability**: Built-in redundancy across multiple Availability Zones
- **Distributed IP Routing**: Performs IP forwarding at VPC level
- **Connection Termination**: Gateway for VPC to communicate with other networks (VPCs or on-premises)

#### Supported Connections
- **VPN Connections**: Terminates IPsec VPN tunnels
- **Direct Connect Connections**: Terminates Direct Connect links (with same-region requirement)

#### Route Propagation and Management

##### Route Table Integration
```diff
! VGW Route Propagation Process
```
- Propagates learned routes from remote networks into VPC route tables
- Supports both static and dynamic (BGP) route propagation
- Allows static route configuration targeting VGW

##### Route Priority at VGW Level
Route selection follows IP routing principles with specific AWS ordering:

1. **Longest Prefix Match**: Most specific subnet mask always takes precedence
2. **Tie-Breaker for Equal Length Prefixes**:
   - BGP route from Direct Connect connection (preferred)
   - Static route from VPN connection
   - BGP route propagated via VPN connection (least preferred)

#### Route Selection Examples

##### Example 1: Same Prefix via VPN and Direct Connect
When VGW receives identical IP prefix (same subnet length) over both VPN and Direct Connect:
```diff
+ Route Preference: Direct Connect BGP route selected over VPN routes
- Traffic Flow: All traffic to that prefix routes through Direct Connect connection
```

##### Example 2: Different Prefix Lengths
When receiving varying prefix lengths:
- Traffic to most specific prefix (192.168.1.0/24): Routes through VPN connection (longest match)
- Traffic to less specific prefixes: Uses BGP session over Direct Connect

#### Design Implications
Understanding VGW route priorities enables complex traffic engineering scenarios involving:
- Multi-path connectivity
- Traffic steering based on prefix specificity
- Load balancing and failover designs
- Quality of Service routing decisions

## 9.3 Direct Connect Gateway (DXGW)

### Overview
The Direct Connect Gateway (DXGW) is a globally available AWS resource that simplifies connecting on-premises networks to multiple AWS regions through a single Direct Connect connection. It enables centralized management of Direct Connect connectivity across regions while maintaining isolation between different AWS accounts and VPCs.

### Key Concepts/Deep Dive

#### DXGW Functionality
- **Global Resource**: Not bound to specific AWS region
- **Multi-Region Connectivity**: Connect single Direct Connect connection to VPCs in multiple regions
- **Account Isolation**: Maintains network isolation between different AWS accounts
- **Centralized Management**: Single point of management for cross-region Direct Connect connectivity

#### DXGW Capabilities
- Creates **Virtual Interfaces (VIFs)** to connect to VPCs
- Supports up to 10 VIFs (and prefixes) per gateway
- Allows connection to VPCs across different regions through one physical connection
- Enables **hybrid connectivity patterns** between on-premises infrastructure and multiple AWS regions

#### Key Concepts and Operations

##### Virtual Interfaces (VIFs)
DXGW creates dedicated virtual interfaces for each VPC connection, providing isolated connectivity.

##### Prefix Management
Supports multiple IP prefixes (up to 10) associated with different VPCs, enabling flexible routing configurations.

##### Cross-Region Routing
Facilitates efficient data transfer between on-premises networks and AWS resources spanning multiple geographic regions.

#### Use Cases and Benefits

##### Multi-Region Deployments
Organizations with workloads distributed across multiple AWS regions can leverage DXGW for simplified connectivity management.

##### Centralized Connectivity Model
```diff
! DXGW Benefits
+ Consolidated: Single Direct Connect connection serves multiple regions
+ Cost-Effective: Reduces need for multiple physical connections
+ Simplified Management: Centralized control and monitoring
+ Scalable: Easy to add new regions without additional physical infrastructure
```

##### AWS Account Segmentation
Different AWS accounts can connect to the same DXGW while maintaining complete network isolation between them.

#### Design Considerations
- **Prefix Limits**: Maximum of 10 VIFs/prefixes per DXGW
- **VPC Association**: Each VPC connects via dedicated VIF
- **Billing Structure**: Billing is account-based, not DXGW unit-based
- **Global Reach**: Enables truly global AWS infrastructure connectivity

#### Practical Applications
DXGW is commonly used in scenarios involving:
- Enterprise customers with multi-region AWS deployments
- Complex hybrid cloud architectures
- Organizations requiring centralized Direct Connect management
- Cross-account shared connectivity models

## 9.4 AWS Transit Gateway (TGW) Part 1

### Overview
AWS Transit Gateway (TGW) is a regional service that simplifies network connectivity between VPCs, on-premises networks, and other AWS services. It acts as a network transit hub, enabling customers to easily manage complex network topologies with attachments for VPCs, VPN connections, Direct Connect gateways, and peer transit gateways.

### Key Concepts/Deep Dive

#### TGW Core Functionality
- **Regional Service**: Deployed per AWS region
- **Network Transit Hub**: Central hub for network routing
- **Simplified Management**: Reduces complexity compared to VPC peering models
- **Scalable Architecture**: Supports thousands of attachments

#### TGW Attachments
TGW supports multiple types of network attachments:

- **VPC Attachments**: Connect VPCs to TGW
- **VPN Attachments**: Connect on-premises networks via VPN
- **Direct Connect Gateway (DXGW) Attachments**: Connect via Direct Connect
- **TGW Peer Attachments**: Connect TGWs across regions
- **Connect Attachments**: For SD-WAN connectivity

#### Route Tables in TGW

##### TGW Route Table Structure
- **Attachments**: Represent network connections (VPCs, VPNs, DXGWs, etc.)
- **TGW Route Tables**: Control routing between attachments
- **Route Propagation**: Automatic route learning from dynamic routing protocols
- **Route Associations**: Static associations between attachments and route tables

##### Key Route Table Features
- **Multiple Route Tables**: Support for complex routing architectures
- **Route Propagation**: Automatic BGP route learning from attachments
- **Route Associations**: Explicit mapping of attachments to route tables
- **Blackhole Routes**: For traffic filtering

#### Connectivity Patterns with TGW
Complex network architectures are simplified through TGW hub-and-spoke model:

- **Hub-and-Spoke**: TGW as central hub with spokes connecting different networks
- **Full Mesh**: All-to-all connectivity between attached networks
- **Custom Routing**: Flexible routing through multiple route tables

#### TGW Design Patterns

##### Pattern 1: Multi-VPC Connectivity
Connect multiple VPCs through single TGW for simplified inter-VPC communication.

##### Pattern 2: Hybrid Connectivity
Integrate on-premises networks with cloud workloads through TGW.

##### Pattern 3: Cross-Region Routing
Connect TGWs in different regions for global network architectures.

## 9.5 AWS Transit Gateway (TGW) Part 2

### Overview
This continuation explores advanced TGW concepts including appliance mode, security integrations, billing considerations, and design patterns for various networking scenarios.

### Key Concepts/Deep Dive

#### Advanced TGW Features

##### Appliance Mode
- **Traffic Inspection**: Routes traffic through middlebox appliances for security
- **Network Appliances**: Supports firewalls, IDS/IPS, and other security tools
- **Stateful Inspection**: Maintains connection state for complex security policies
- **Direct Traffic Flow**:/routes data through security appliances in VPCs

##### Appliance Mode Configuration
```diff
! Appliance Mode Characteristics
+ Sequential Processing: Traffic flows through appliances in order
- Asymmetric Routing: Potential asymmetric traffic paths
+ High Availability: Supports redundant appliance deployments
- Performance Impact: Additional latency from appliance processing
```

#### TGW Security Features

##### Reference: Careful Sharing
Implement resource-based policies for controlled TGW sharing across AWS accounts.

##### Route Domain Isolation
Multiple TGW route tables provide logical separation between different network segments.

##### Network Segmentation
```diff
+ Security Benefits
+ Isolation: Network segments completely isolated
+ Controlled Access: Granular routing policies
+ Compliance: Supports security and compliance requirements
+ Multi-Tenancy: Safe sharing of TGW infrastructure
```

#### TGW Billing and Costs
Transparent pricing based on usage:

- **Per GB Processed**: Data transfer costs
- **Per Hour Active**: TGW hourly costs
- **Attachment-Based**: Costs vary by attachment type
- **Regional Pricing**: Different costs per region

#### TGW Use Cases and Design Patterns

##### Use Case 1: SD-WAN Integration
Connect SD-WAN appliances through Connect attachments for hybrid cloud deployments.

##### Use Case 2: Global Network Architectures
Use TGW peering for cross-region connectivity in multi-region AWS deployments.

##### Use Case 3: Centralized Security
Implement security appliances with appliance mode for comprehensive traffic inspection.

##### Use Case 4: Migration and Disaster Recovery
Support complex migration scenarios with isolated network segments.

#### Advanced TGW Design Considerations

##### Performance Optimization
- **BGP Routing**: Optimize routing protocols for performance
- **Route Tables**: Design efficient route table associations
- **Monitoring**: Implement comprehensive TGW monitoring

##### Scalability Patterns
- **Thousands of VPCs**: Support for large-scale deployments
- **Global Routing**: Cross-region connectivity capabilities
- **Automated Management**: Supporting infrastructure as code

##### Network Resilience
```diff
+ TGW Resilience Features
+ Regional Redundancy: Built-in regional resiliency
+ Multi-AZ Design: Distributed across availability zones
+ Peering Options: Multiple connectivity paths
+ Monitoring Integration: CloudWatch integration for health monitoring
```

## Summary

### Key Takeaways
```diff
+ Building Blocks Approach: Hybrid connectivity simplified through AWS service endpoints, connection options, and gateway devices
+ VGW Route Priorities: Longest prefix match first, then Direct Connect BGP > VPN Static > VPN BGP for equal prefixes
+ DXGW Benefits: Connect single Direct Connect to multiple regions with simplified management and account isolation
+ TGW Hub Model: Centralized routing hub supporting VPCs, VPNs, Direct Connect, and cross-region connectivity
+ TGW Appliance Mode: Enables stateful traffic inspection through security appliances
+ TGW Security: Resource-based sharing and route domain isolation for secure multi-account architectures
+ TGW Billing: Transparent per-GB and per-hour pricing across all attachment types
+ Design Patterns: Hub-and-spoke, full mesh, and custom routing for various connectivity scenarios
```

### Quick Reference

#### VGW Route Selection Priority
1. Longest prefix match
2. Direct Connect BGP routes
3. VPN static routes
4. VPN BGP propagated routes

#### TGW Attachment Types
- VPC attachments
- VPN attachments
- Direct Connect Gateway attachments
- Connect attachments (for SD-WAN)
- TGW peer attachments

#### DXGW Limits
- Up to 10 VIFs per gateway
- Supports multiple regions from single connection
- Account-based billing and isolation

### Expert Insight

**Real-world Application**: In enterprise environments, TGW enables building network backbones that connect thousands of VPCs across global regions while maintaining security through route table isolation and appliance mode. DXGW simplifies hybrid connectivity for organizations with multi-region AWS presence, reducing complexity from managing multiple Direct Connect connections.

**Expert Path**: Master route prioritization logic across AWS networking services. Understand TGW route table design patterns for complex architectures. Practice designing hybrid connectivity with cost optimization and security first principles.

**Common Pitfalls**:
```diff
- Ignoring route priorities leading to suboptimal traffic paths
- Not planning TGW route table associations causing connectivity issues
- Overlooking appliance mode configuration for security requirements
- Assuming DXGW billing is gateway-based rather than account-based
- Failing to implement TGW monitoring and observability
```

**Lesser-Known Facts**: TGW can support transit peering for cross-region traffic, enabling global network architectures without requiring Direct Connect circuits between every region. DXGW enables "Direct Connect as a Service" models where connectivity services can be shared across multiple accounts while maintaining complete billing and operational separation.

</details>