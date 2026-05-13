# Section 10: Connectivity Overview

<details open>
<summary><b>Section 10: Connectivity Overview (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [10.1 Connectivity Overview](#101-connectivity-overview)
- [10.2 VPN with VGW Part 1](#102-vpn-with-vgw-part-1)
- [10.3 VPN with VGW Part 2](#103-vpn-with-vgw-part-2)
- [10.4 VPN with TGW](#104-vpn-with-tgw)
- [10.5 VPN Design Considerations](#105-vpn-design-considerations)
- [10.6 TGW Vs. CloudHub VPN](#106-tgw-vs-cloudhub-vpn)
- [10.7 Customer Managed VPN](#107-customer-managed-vpn)
- [10.9 When to use SDWAN](#109-when-to-use-sdwan)
- [Summary](#summary)

## 10.1 Connectivity Overview

**Overview:**
This module introduces the concept of connectivity in hybrid networking architectures, focusing on the two primary connection types: VPN and Direct Connect. It emphasizes the importance of secure communication between AWS VPCs and on-premises networks using site-to-site VPN, which can operate over untrusted networks like the public internet or trusted transports such as MPLS. The module covers how VPN enables communication between VPCs in different regions and on-premises data centers or branch sites.

**Key Concepts/Deep Dive:**

### VPN Fundamentals
- **Definition**: VPN (Virtual Private Network) creates secure connections between separate networks over another transport network.
- **Site-to-Site VPN**: Enables secure communication between AWS VPCs and on-premises networks.
- **Managed vs. Customer-Managed VPN**:
  - **Managed VPN**: AWS provides infrastructure, software, and SLA using either Virtual Private Gateway (VGW) or AWS Transit Gateway.
  - **Customer-Managed VPN**: Customer provisions and manages VPN software on EC2 instances or virtual appliances from AWS Marketplace.

### Connectivity Types
- **Primary Types**: VPN and Direct Connect as main components of hybrid connectivity building blocks.
- **Use Cases**: Communication between VPCs across regions, VPC-to-on-premises data center, VPC-to-branch offices.

```diff
+ Key Benefit: Secure encrypted tunnels enable hybrid architectures.
- Limitation: Public internet-based VPN may introduce latency depending on geography.
```

## 10.2 VPN with VGW Part 1

**Overview:**
This module dives into AWS managed VPN solutions using Virtual Private Gateway (VGW), detailing IPsec tunnel configuration, routing options, and design considerations. It covers customer gateway setup, IPsec tunnel establishment, BGP routing over VPN connections, and optimization techniques for routing behavior and redundancy.

**Key Concepts/Deep Dive:**

### IPsec Components
- **IPsec Protocol Suite**: Secures IP communications by authenticating and encrypting data packets.
- **VPN Connection**: Consists of two IPsec tunnels for redundancy.
- **Tunnel Specifications**: Each tunnel provides ~1.2 Gbps bandwidth, terminates in different availability zones.

### Customer Gateway
- **Definition**: AWS logical resource representing on-premises VPN device (CPE/CPE router/firewall).
- **Configuration**: Must enable IPsec site-to-site VPN and support static/BGP routing.

### Tunnel Establishment
- **Public IPs Required**: For IPsec tunnel establishment over internet.
- **Tunnel IPs**: Use private ranges (169.254.x.x/30) for internal communication.
- **BGP Sessions**: Established over tunnel IPs for dynamic routing.
- **Example Tunnel Flow**:
  ```
  On-Premises Device → Public IP Routing → IPsec Encapsulation → AWS VGW → BGP Session over Private IPs
  ```

### Routing Options
- **Static Routing**: Manually defined routes with VGW as next-hop.
- **Dynamic Routing (BGP)**: Automatically propagates routing information.
- **Routing Asymmetry**: Occurs when tunnels use different paths, potentially causing stateful firewall issues.

### Certificate-Based Authentication
- **AWS Certificate Manager**: Enable certificate-based IKE authentication instead of pre-shared keys.
- **Benefits**: No need to specify IP addresses for customer gateway, allows IP address updates without reconfiguring VPN.

### VGW Routing Behavior
- **Static Route Limitations**: Can lead to asymmetrical routing if multiple tunnels active.
- **BGP Incentives**: Use BGP attributes for deterministic routing.
- **BGP Attributes for Optimization**:
  - **AS-Path Prepending**: Fewer AS numbers preferred for path selection.
  - **Multi-Exit Discriminator (MED)**: Similar to link cost, prefers lower values.
  - **Most Specific Route**: Longest prefix match always wins.

### Single Connection Design
- **Two Tunnels**: Both active, VGW selects one for outbound traffic.
- **Routing Challenges**: Asymmetrical routing potential with stateful devices.

### Dual Connection Design
- **Multiple VPN Connections**: Each with pair of tunnels.
- **Static + BGP Combination**: Not optimal due to mixed routing mechanisms.
- **Dual Static Routes**: Non-deterministic tunnel selection, asymmetrical routing.

💡 **Pro Tip**: Always prefer BGP over static routing for better control and deterministic routing.

## 10.3 VPN with VGW Part 2

**Overview:**
Building on the previous module, this section explains BGP routing attributes in simplified terms, optimal design patterns using BGP for symmetric routing, and VPN Cloud Hub architectures. It covers how to influence route selection using BGP attributes, design recommendations for high availability, and integration with Direct Connect in hub-and-spoke models.

**Key Concepts/Deep Dive:**

### BGP Path Selection Simplified
- **AS-Path Prepending**: Route with fewer AS numbers in path is preferred.
- **Rule of Thumb**: Shorter AS path = higher preference.
- **MED Consideration**: When AS paths equal, lower MED value preferred.

### Design Recommendations Using BGP
- **Symmetric Routing**: Use BGP to control path preference deterministically.
- **Longest Prefix Matching**: Advertise more specific routes to influence path selection.
- **BGP Influence Techniques**:
  - Advertise /24 subnets instead of /16 summary routes.
  - Use AS-path prepending to make certain paths less attractive.
  - Set appropriate MED values for link preference.

### Multi-Site VPN Scenarios
- **VPN Cloud Hub**: Enables communication between remote sites through AWS VGW.
- **Hub-and-Spoke Topology**: Multiple branch offices connect through central AWS hub.
- **Use Cases**: Convenient low-cost connectivity for small branch infrastructures.

### Cloud Hub Architecture
- **VPN Connections**: Multiple site-to-site VPNs terminating on same VGW.
- **Inter-Site Communication**: Sites can communicate through AWS without direct connections.
- **With/Without VPC**: Cloud Hub works with or without VPC attachment.

### Direct Connect Integration
- **Private Virtual Interface**: Direct Connect attached to VGW supports Cloud Hub.
- **VPN-to-Direct Connect Hub**: Sites using Direct Connect can participate in Cloud Hub with VPN sites.

> [!NOTE]
> Cloud Hub is suitable for small-to-medium architectures with multiple branch offices using internet connectivity.

## 10.4 VPN with TGW

**Overview:**
This module explores using AWS Transit Gateway as the VPN termination point, highlighting its advantages over VGW for scalability, redundancy, and advanced routing features. It covers equal cost multipathing (ECMP), accelerated VPN, and routing priority considerations when combining VPN with other connectivity types.

**Key Concepts/Deep Dive:**

### TGW VPN Advantages
- **Managed Service**: Inherits TGW high availability and reliability.
- **Dynamic/Static Routing**: Both supported, BGP preferred for flexibility.
- **ECMP Support**: Aggregate bandwidth using multiple VPN tunnels.

### Per-Tunnel Bandwidth
- **Single Tunnel**: 1.25 Gbps (up to 1.2 Gbps effective throughput).
- **ECMP Configuration**: Aggregate bandwidth across tunnels.
- **Flow-Based Routing**: Each traffic flow hashed to single tunnel, limited by tunnel capacity.

### Routing Priorities in TGW
1. Longest prefix match always preferred.
2. **Route Source Priority** (if equal prefix length):
   - Static routes
   - VPC CIDR blocks
   - Direct Connect Gateway propagated routes
   - VPN propagated routes
3. **Same Type/Path Distribution**: ECMP across equal-cost paths with BGP.

### Accelerated VPN
- **AWS Global Accelerator Integration**: Optimizes network path by routing traffic through closest edge location.
- **Use Case**: Improves performance for geographically distant connections.
- **Implementation**: Creates accelerator endpoints for each VPN tunnel's public IPs.

### Design Considerations
- **BGP Requirement for ECMP**: Dynamic routing required for traffic aggregation.
- **TGW High Availability**: Automated redundancy and failover built-in.
- **Integration Flexibility**: Supports complex multi-VPC architectures.

```diff
+ Recommendation: Use TGW for VPN when requiring ECMP and multi-VPC connectivity.
- Limitation: Per-flow limitation still applies (flows cannot exceed single tunnel capacity).
```

## 10.5 VPN Design Considerations

⚠ **Note**: The transcript file for this section appears to be unavailable or empty. Based on context from other sections, key VPN design considerations include:

- Evaluating redundancy requirements
- Bandwidth capacity planning (1.25 Gbps per tunnel)
- Routing protocol selection (BGP vs. static)
- High availability strategy
- Asymmetric routing avoidance
- Certificate vs. pre-shared key authentication

> [!IMPORTANT]
> Always refer to AWS documentation for current VPN quotas and limits.

## 10.6 TGW Vs. CloudHub VPN

**Overview:**
This comparison module clarifies when to use Transit Gateway vs. VPN Cloud Hub, helping architects make informed decisions based on scale, routing requirements, and future growth. It emphasizes Transit Gateway's superior scalability and capabilities compared to the simpler Hub-and-Spoke Cloud Hub model.

**Key Concepts/Deep Dive:**

### VPN Cloud Hub Characteristics
- **Simple Hub-and-Spoke**: Remote sites communicate through AWS hub.
- **VPC Optional**: Works with or without VPC attachment.
- **Use Cases**: Multiple branch offices, low-cost internet-based connectivity.
- **Direct Connect Integration**: PVI-connected Direct Connect can participate in Cloud Hub.

### Transit Gateway VPN Advantages
- **Scale**: Supports thousands of VPCs/transit attachments.
- **Advanced Routing**: Flexible route tables, security controls.
- **ECMP Support**: Aggregated bandwidth across tunnels.
- **Multi-Region**: Global network connectivity.
- **SD-WAN Integration**: Baseline for advanced network overlays.
- **Accelerated VPN**: Performance optimization.

### Comparison Table

| Feature | VPN Cloud Hub | Transit Gateway VPN |
|---------|---------------|-------------------|
| Scale | Small/medium | Large enterprise |
| VPC Support | Limited (1-2 typically) | 5000+ VPCs per TGW |
| Routing | Basic | Advanced controls |
| Bandwidth | Single tunnel limits | ECMP aggregation |
| Multi-region | No | Yes |
| SD-WAN Friendly | No | Yes |

### Selection Criteria
- **Choose Cloud Hub**: Small organizations, few branch offices, cost-sensitive.
- **Choose TGW**: Enterprise scale, complex routing, multi-VPC architectures.
- **Future-Proofing**: Consider 1-2 year growth projections.

📝 **Best Practice**: Design for expected future requirements, not just current needs.

## 10.7 Customer Managed VPN

**Overview:**
This section explores customer-managed VPN solutions deployed on EC2 instances or virtual appliances, including SD-WAN integration with Transit Gateway. It covers deployment options, scaling considerations, performance limitations, and advanced routing capabilities offered by SD-WAN solutions.

**Key Concepts/Deep Dive:**

### Customer-Managed VPN Types
- **EC2-based VPN Software**: Run VPN software on EC2 instances.
- **Marketplace Appliances**: Third-party virtual appliances with automated provisioning.
- **SD-WAN Solutions**: Software-defined WAN overlay networks.

### Single VPC Design
- **IPsec Tunnels**: Terminate on VPC VGWs or instances.
- **Direct Connect Integration**: Combine Direct Connect with VPN for backup/encryption.
- **Limitations**: Manual management, licensing costs, patch management responsibility.

### Transit VPC Pattern
- **Hub VPC**: VPN appliances act as transit nodes.
- **Connectivity**: IPsec tunnels from transit VPC to other VPCs via VGWs.
- **Scaling Challenges**: Complex routing, management overhead.

### TGW Integration for Scaling
- **TGW Attachment**: Replace complex IPsec mesh with clean TGW connectivity.
- **Improved Management**: Centralized routing control, VPC segregation.
- **Performance Benefits**: Higher bandwidth, better fault isolation.

### SD-WAN with TGW
- **Connect Attachment**: VPC containing SD-WAN appliances.
- **GRE Tunnels**: Data plane between appliances and TGW.
- **BGP Control Plane**: Routing information exchange.

### Performance Specifications
- **TGW VPC Attachment**: Up to 50 Gbps throughput.
- **Connect Attachment**: Supports multiple connect attachments.
- **Connect Peering**: Up to 5 Gbps per GRE tunnel.
- **ECMP Aggregation**: Up to 20 Gbps with 4 tunnels, scalable.

### Routing Considerations
- **Route Limits**: Appliance sends 1000/receives 5000 routes.
- **BGP Multihop**: Required for overlay routing (TTL=2).
- **ECMP Requirements**:
  - Same prefix length advertisement
  - Matching AS-path and AS numbers
  - Identical MED values

```bash
# Example BGP configuration for SD-WAN appliance
router bgp <local-asn>
 neighbor <tgw-ip> remote-as 64512
 neighbor <tgw-ip> ebgp-multihop 2
 neighbor <tgw-ip> update-source Loopback0
```

## 10.9 When to use SDWAN

**Overview:**
This concluding module provides guidance on selecting customer-managed SD-WAN solutions over AWS managed VPN, focusing on business and technical drivers. It covers investment protection, encryption requirements, advanced routing needs, and transport-independent routing capabilities.

**Key Concepts/Deep Dive:**

### Business Drivers
- **Investment Protection**: Integrate existing SD-WAN infrastructure with cloud.
- **Avoid Operational Overhead**: Skip AWS managed VPN if hardware/software already invested.
- **Licensing/Man Vendor Lock-in**: Preserve existing vendor relationships.

### Technical Requirements
- **Direct Connect Encryption**: Mandatory encryption over private connections.
- **Advanced Routing**: Application-based routing, custom policies.
- **Transport Independence**: Unified routing across internet, MPLS, Direct Connect.
- **Multi-Site Connectivity**: Global branch interconnectivity.

### SD-WAN Architectural Benefits
- **Overlay Management**: Simplified VPN connectivity management.
- **Scalable Controls**: Route limit higher than Direct Connect alternatives.
- **Vendor Flexibility**: Choose SD-WAN based on required capabilities.

### Decision Framework
1. **Assess Requirements**: Bandwidth, routes, routing complexity, encryption needs.
2. **Evaluate Existing Investment**: Hardware, software, team skills.
3. **Technical Feasibility**: Check AWS integration capabilities.
4. **Business Priorities**: Cost, time-to-implement, future-proofing.

> [!IMPORTANT]
> Validate that SD-WAN solution integrates with AWS Transit Gateway and supports required BGP peering.

```diff
+ SD-WAN Selection Criteria: Investment protection, advanced routing, transport independence.
- Avoid Over-Engineering: Don't choose SD-WAN if AWS managed VPN meets requirements.
```

## Summary

### Key Takeaways
```diff
+ VPN enables secure hybrid connectivity between AWS and on-premises networks
- Public internet-based VPN may introduce performance issues without acceleration
+ Transit Gateway offers superior scalability and ECMP for enterprise VPN needs
+ BGP routing provides deterministic path selection and symmetric routing
+ SD-WAN solutions suit organizations with existing investments or advanced routing needs
+ Choose connectivity type based on scale, cost, and future requirements
+ Always prefer managed AWS solutions unless business constraints dictate otherwise
+ Direct Connect integration enhances VPN architectures for production workloads
```

### Quick Reference

#### VPN Connection Types
| Type | Management | Use Case |
|------|------------|----------|
| AWS Managed | AWS Infrastructure/SLA | Standard hybrid connectivity |
| Customer Managed | Customer EC2/Appliances | Advanced routing, investment protection |

#### Routing Options
- **Static**: Simple, may cause asymmetric routing
- **BGP**: Preferred for control and symmetry
- **ECMP**: Aggregate bandwidth across tunnels

#### Key Commands
```bash
# Check VPN tunnel status
aws ec2 describe-vpn-connections

# View TGW route table
aws ec2 get-transit-gateway-route-table --transit-gateway-route-table-id <id>
```

### Expert Insight

#### Real-World Application:
In production environments, combine VPN with Direct Connect for hybrid connectivity: use VPN as backup path and Direct Connect as primary connection. Implement health monitoring and automated failover using CloudWatch and Lambda to ensure high availability.

#### Expert Path:
Master BGP routing in AWS contexts - understand AS-path manipulation, MED usage, and community tagging. Practice designing hub-and-spoke architectures with Transit Gateway, including route isolation and security controls.

#### Common Pitfalls:
- Ignoring geographical impact on public VPN performance (mitigate with Accelerated VPN)
- Over-relying on static routes causing routing asymmetry
- Underestimating bandwidth per-flow limitations in ECMP designs
- Not accounting for route advertisement limits in SD-WAN implementations

#### Lesser-Known Facts:
- AWS VPN tunnels support certificate-based authentication without requiring stable public IPs
- FGWs "learn" routes from TGW attachments, enabling seamless VPC integration
- SD-WAN overlay can exchange more routes than Direct Connect Gateway limits (20 vs. 5000 routes)

</details>