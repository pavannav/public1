# 07 VPC Private Connectivity

<details open>
<summary><b>07 VPC Private Connectivity (CL-KK-Terminal)</b></summary>

**Table of Contents**
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [VPC Peering Architecture and Connectivity](#vpc-peering-architecture-and-connectivity)
  - [Gateway Endpoints for AWS Services](#gateway-endpoints-for-aws-services)
  - [Interface Endpoints for Private AWS Access](#interface-endpoints-for-private-aws-access)
  - [Network Traffic Flow and Routing Tables](#network-traffic-flow-and-routing-tables)
  - [Security Layers in Private Connectivity](#security-layers-in-private-connectivity)
- [Configuration and Setup](#configuration-and-setup)
- [Lab Demonstrations](#lab-demonstrations)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview

This session covers VPC private connectivity options in AWS, focusing on Module 2 of the networking course. It builds on Module 1 (VPC basics, subnetting, IGW, and NAT Gateway) by exploring how VPCs within the same AWS account and region can communicate privately without traversing the public internet. The instructor discusses VPC peering for direct VPC-to-VPC connectivity, gateway endpoints for accessing S3 and DynamoDB via the AWS backbone, and interface endpoints for other AWS services using private links. Key topics include network traffic patterns, route table configurations, security considerations, and preparation for Module 2 lab scenarios.

> [!IMPORTANT]
> Private connectivity in AWS enables secure communication between resources within the cloud infrastructure without exposing traffic to external networks or the public internet.

## Key Concepts and Deep Dive

### VPC Peering Architecture and Connectivity

VPC peering enables private communication between Virtual Private Clouds (VPCs) within the same AWS region or across regions. This is achieved through a logical connection that allows resources in one VPC to communicate with resources in another VPC as if they were on the same network. Under the hood, AWS deploys Layer 3 routers (invisible to the user) that establish connectivity via the AWS backbone network.

**Key Characteristics:**
- Peering operates at the network layer and does not require internet gateways
- Traffic remains within AWS infrastructure, ensuring high security and low latency
- Peering connections are not transitive (direct routing only between peered VPCs)
- Maximum of 125 active VPC peering connections per VPC (this is an AWS architectural limit, though actual usage is typically much lower)

```
graph TD
    A[VPC A - 10.1.1.0/24] -->|Peer Connection| C[VPC Peering Gateway]
    B[VPC B - 10.1.2.0/24] -->|Peer Connection| C
    
    C -->|Router Level Forwarding| D[(AWS Backbone Network)]
    
    D -->|Route to Dest. Subnet| E[VPC A Subnet Routes]
    D -->|Route to Dest. Subnet| F[VPC B Subnet Routes]
    
    G[VM in VPC A Subnet] -->|Local Routing| E
    H[VM in VPC B Subnet] -->|Local Routing| F
```

**Subnetting Example from Transcript:**

| VPC | Original /24 Range | Divided /28 Subnets | Purpose |
|-----|-------------------|---------------------|---------|
| VPC A | 10.1.1.0/24 | 10.1.1.0/28<br>10.1.1.16/28 | Private subnets (A1, A2) |
| VPC B | 10.1.2.0/24 | 10.1.2.0/26<br>10.1.2.64/26 | Private subnets (A1, A2) |

**Calculations:**
- /28 subnet: 16 total IPs, 11 usable IPs (AWS reserves 5: network, broadcast, +3 for AWS services)
- Increment: 16 (2^4 = 16)
- /26 subnet: 64 total IPs, 59 usable IPs (AWS reserves 5: network address, broadcast, +3 for AWS services)

> [!NOTE]
> AWS automatically reserves 5 IP addresses from each subnet: network address, VPC router, DNS server, future use, and broadcast address. This affects IP availability calculations.

### Gateway Endpoints for AWS Services

Gateway endpoints provide private access to specific AWS services (currently S3 and DynamoDB) via the AWS backbone network. Unlike internet gateway routing, gateway endpoints ensure traffic never leaves AWS infrastructure, improving security and reducing bandwidth costs.

**How It Works:**
- Deployed as a logical router in a specific VPC subnet
- Route table entries point to the gateway endpoint instead of an IGW
- Services have dual network interfaces: public (internet-facing) and private (AWS backbone)
- No visibility into the endpoint's actual IP addresses or underlying infrastructure

```diff
+ Traffic via Gateway Endpoint:
  - Leaves VM → Hits gateway endpoint → Routes through AWS backbone → Hits service private interface
  - No internet exposure, no packet inspection risk, reduced costs

- Traffic via IGW:
  - Leaves VM → Internet Gateway → Public internet → Service provider → Risks of man-in-the-middle attacks
```

**Supported Services:**
- Amazon S3 (bucket storage)
- Amazon DynamoDB (NoSQL database)

> [!IMPORTANT]
> Gateway endpoints are routable but not visible in the AWS console at the EC2 level - they appear only in route table configurations with "vpce-" prefix in Next Hop entries.

### Interface Endpoints for Private AWS Access

Interface endpoints use AWS PrivateLink to enable private connectivity to most AWS services (excluding S3/DynamoDB). Unlike gateway endpoints, these create Elastic Network Interfaces (ENIs) in your VPC subnets, either public or private.

**Architecture:**
- PrivateLink establishes secure, scalable connections via unique ports
- ENIs are automatically created and attached to your subnet
- More expensive than gateway endpoints (charged per hour of ENI availability + data transfer)
- Traffic flows: VM → Interface endpoint ENI → AWS PrivateLink → Service

```diff
+ Advantages of Interface Endpoints:
  + Supports nearly all AWS services privately
  + Scalable elastic network interfaces
  + Fine-grained security control

- Disadvantages of Interface Endpoints:
  - Higher cost structure (ENI hourly + data charges)
  - More complex management
  - Route table complexity increases
```

**Cost Structure Comparison:**

| Endpoint Type | Hourly Charge | Data Transfer Charge | Supported Services |
|---------------|---------------|----------------------|-------------------|
| Gateway | Free | Yes | S3, DynamoDB |
| Interface | Yes | Yes | All other AWS services |

### Network Traffic Flow and Routing Tables

VPC peering relies entirely on route table configurations. Default behavior is no connectivity - explicit routes must be added pointing to the peering connection.

**Traffic Flow Sequence:**
1. Packet leaves AWS instance → Hits VPC route table
2. Route table looks for destination IP range match (e.g., 10.1.2.0/24)
3. If match found and Next Hop = peering connection ID → Forward to peering gateway
4. Peering gateway establishes direct routing via AWS backbone
5. Destination VPC route table routes to correct subnet

**Route Table Example (Custom Route Table):**

| Destination | Target | Status | Propagated |
|-------------|--------|--------|------------|
| 10.1.1.0/24 | local | Active | No |
| 10.1.2.0/24 | pcx-xxxxxxxxxxxxxxxxx (peering ID) | Active | No |
| 0.0.0.0/0 | igw-xxxxxxxxxxxxxxxxx | Active | No |

> [!NOTE]
> Peering connections use peering connection IDs (pcx-) as the next hop target in route tables, not IP addresses.

### Security Layers in Private Connectivity

Traffic filtering occurs at multiple levels in AWS networking:

1. **Security Groups** (Stateful, instance-level)
2. **Network ACLs** (Stateless, subnet-level) 
3. **Route Tables** (Directing traffic flow)
4. **Instance-level Firewalls** (If configured)

**Security Groups Default Policy:**
- Inbound: Deny all traffic by default
- Outbound: Allow all traffic by default

**Network ACL Default Policy:**
- Inbound: Allow all traffic
- Outbound: Allow all traffic

> [!CAUTION]
> Route tables determine reachability, but security groups and NACLs control allowability. A route table may permit traffic flow, but security groups can still block it at the instance level.

```diff
- Common Pitfall: Assuming route table success means connectivity works
+ Best Practice: Verify all three layers - routes, security groups, and NACLs
```

## Configuration and Setup

**Creating a VPC Peering Connection:**
```bash
# AWS CLI example (not executed in lab)
aws ec2 create-vpc-peering-connection \
  --vpc-id vpc-xxxxxxxxxxxxxxxxx \
  --peer-vpc-id vpc-xxxxxxxxxxxxxxxxx \
  --peer-region us-east-1
```

**Accepting a VPC Peering Connection:**
```bash
aws ec2 accept-vpc-peering-connection \
  --vpc-peering-connection-id pcx-xxxxxxxxxxxxxxxxx
```

**Adding Routes to Route Table:**
```bash
aws ec2 create-route \
  --route-table-id rtb-xxxxxxxxxxxxxxxxx \
  --destination-cidr-block 10.1.2.0/24 \
  --vpc-peering-connection-id pcx-xxxxxxxxxxxxxxxxx
```

**Creating Gateway Endpoint:**
```bash
aws ec2 create-vpc-endpoint \
  --vpc-id vpc-xxxxxxxxxxxxxxxxx \
  --service-name com.amazonaws.us-east-1.s3 \
  --vpc-endpoint-type Gateway
```

## Lab Demonstrations

The transcript discusses preparation for Lab 2 (Module 2) which will cover:
- NAT Gateway implementation (building on Module 1)
- Bastion host for private subnet access
- VPC peering scenarios across multiple requirements
- Gateway and interface endpoint deployments
- Security group and NACL configurations

Lab 2 will include three different scenarios:
1. Full subnet-to-subnet connectivity via VPC peering
2. Specific subnet-to-subnet restrictions using route tables
3. Fine-grained instance-level restrictions using security groups

**Lab Access Notes:**
- Labs are available 24/7 with booking through shared Excel sheet
- Two lab environments available (second activating Monday)
- 2-hour per session per member limit
- Best practice: Delete unused bookings promptly

## Summary

### Key Takeaways

```diff
+ VPC Peering enables private connectivity between VPCs within the same region or across regions using AWS backbone infrastructure without internet exposure
+ Gateway endpoints provide secure S3 and DynamoDB access through dedicated routers, with no data leaving AWS networks
+ Interface endpoints use ENIs and PrivateLink for secure access to most other AWS services, offering scalability but higher costs
+ Route tables are essential for traffic direction, but security groups and NACLs control traffic allowability at different levels
+ Peering connections are not transitive - each VPC pair requires explicit peering configuration
+ AWS reserves 5 IP addresses per subnet, affecting IP availability calculations
- Never assume connectivity works based on route tables alone - always verify security groups and NACLs
- Gateway endpoints don't provide public IP visibility - they appear only in console route table configurations
```

### Quick Reference

**Important IP Calculations:**
- /28 subnet: 16 total IPs, 11 usable (after AWS reserves 5)
- /26 subnet: 64 total IPs, 59 usable (after AWS reserves 5)
- Subnet increments: /28 = +16, /26 = +64

**Cost Factors:**
- Gateway endpoints: Data transfer only (free hourly)
- Interface endpoints: ENI hourly charge + data transfer
- VPC peering: Free within same region

### Expert Insight

**Real-world Application:** In production environments, VPC peering is commonly used for application architectures with multiple VPCs per application tier (web, application, database) or separate environments (development, staging, production). Gateway endpoints are mandatory for secure S3 bucket access in regulated industries like healthcare and finance to prevent data exfiltration through IGW routing.

**Expert Path:** Master subnetting calculations to design efficient network architectures. Focus on route table design patterns and security group hierarchies. For complex architectures with 50+ VPCs, consider Transit Gateway instead of peering connections. Study AWS documentation for interface endpoint regional availability and pricing updates.

**Common Pitfalls:** Over-reliance on default security configurations leads to accidental exposure. Underestimating ENI costs for interface endpoints can result in unexpected cloud bills. Failing to document peering connections in diagrams causes troubleshooting difficulties during incidents. Not reserving adequate IP address space during initial architecture design leads to re-subnetting efforts later.

</details>
