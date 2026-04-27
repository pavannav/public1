# Session 05: Customized VPC & Private Subnet

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [Client Requirements Analysis](#client-requirements-analysis)
  - [NAT Gateway vs Internet Gateway (IGW)](#nat-gateway-vs-internet-gateway-igw)
  - [Network Traffic Flow and Communication](#network-traffic-flow-and-communication)
  - [Elastic IP vs Dynamic Public IP](#elastic-ip-vs-dynamic-public-ip)
  - [Bring Your Own Public IP (BYOIP)](#bring-your-own-public-ip-byoip)
- [Lab Demo: Building the Customized VPC](#lab-demo-building-the-customized-vpc)
  - [Clean Up Default Resources](#clean-up-default-resources)
  - [Create the Networking Kings VPC](#create-the-networking-kings-vpc)
  - [Create Subnets](#create-subnets)
  - [Create and Attach Internet Gateway (IGW)](#create-and-attach-internet-gateway-igw)
  - [Create Route Tables](#create-route-tables)
- [Summary](#summary)

## Overview
This session covers the fundamental concepts of creating a customized VPC in AWS with proper network segmentation using public and private subnets. The instructor explains key networking components including Internet Gateway (IGW), NAT Gateway, route tables, and their roles in enabling secure network communication. The lab demonstrates building a production-ready VPC architecture following a client's specific requirements for network isolation and controlled internet access. Advanced topics include traffic flow patterns, different IP allocation strategies, and the feasibility of bringing your own public IPs into AWS.

## Key Concepts/Deep Dive

### Client Requirements Analysis
The client requires creation of a customized VPC with the following specifications:
- **VPC Network**: 10.1.2.0 (converted to VPC range 10.1.0.0/24)
- **Two Subnets**:
  - Networking Subnet A: 10.1.0.0/28 (private subnet)
  - Networking Subnet B: 10.1.16.0/28 (public subnet)
- **Components Required**:
  - Internet Gateway (IGW) for public internet access
  - NAT Gateway for private subnet outbound internet access
  - Two separate route tables (public and private)
  - EC2 instances in both subnets
  - Public IP retention using Elastic IP

### NAT Gateway vs Internet Gateway (IGW)

#### Key Differences:
NAT Gateway provides **one-way** communication allowing private subnet VMs to access the internet, but preventing external access to those VMs.

> [!NOTE]
> NAT Gateway enables outbound-only internet connectivity from private subnets

IGW provides **two-way** communication allowing VMs in public subnets to both access the internet and receive external connections.

#### Technical Implementation:
- **NAT Gateway**: Deployed in public subnet, requires public IP (Elastic IP or AWS-assigned)
- **IGW**: Regional service attached to VPC, enables public IP assignment to instances in public subnets

#### Traffic Flow Example:
When a VM in private subnet (10.1.1.10) accesses `8.8.8.8`:
`VM → Private Route Table → NAT Gateway → IGW → Internet`

Return traffic flows: `Internet → IGW → NAT Gateway → Private Route Table → VM`

When external traffic attempts to reach the NAT Gateway public IP:
`Internet → IGW → NAT Gateway → Packet dropped` (only outbound traffic allowed)

### Network Traffic Flow and Communication

#### Security Layer Sequence:
```linear
VM Request → Security Group → Route Table → IGW/NAT Gateway → Internet
```

#### Public Subnet Communication:
1. VM initiates request (e.g., 10.1.17.20 → 8.8.8.8)
2. Security Group validation
3. Route table checks entry for `0.0.0.0/0` → IGW
4. IGW performs NAT (10.1.17.20 → Elastic IP or dynamic public IP)
5. Packet routed to internet service provider

#### Private Subnet Communication:
1. VM initiates request (e.g., 10.1.1.10 → 8.8.8.8)
2. Security Group validation
3. Route table checks entry for `0.0.0.0/0` → NAT Gateway
4. NAT Gateway performs network address translation
5. Packet forwarded to IGW for routing to destination
6. Return traffic processed through reverse NAT

#### Key Architecture Points:
- Each subnet has its own virtual router
- Public subnets require IGW for 1:1 NAT
- Private subnets use NAT Gateway for many:1 NAT
- All routing decisions captured in route tables

### Elastic IP vs Dynamic Public IP

#### Elastic IP Characteristics:
- **Retention**: IP address persists when instance restarts
- **Source**: Provided by AWS (despite name)
- **Usage**: Can be assigned to EC2 instances, Network Interface Cards (ENI)
- **Type**: Customer-owned but managed by AWS

```linear
Instance Reboot → Elastic IP Retained ✓
Instance Reboot → Dynamic IP Changes ✗
```

#### AWS IP Pool Management:
Public IPs exist in regional pools. When instances terminate:
- Dynamic IP released and can be reassigned to other instances
- Elastic IP returns to customer's reserved pool

#### Use Cases:
- Production applications requiring consistent public endpoint
- DNS management with fixed IPs
- Load balancers and NAT gateways

### Bring Your Own Public IP (BYOIP)

#### Concept Overview:
- Customer brings their purchased public IP ranges into AWS
- Enables use of own IP addresses for NAT Gateway or Elastic IPs
- Subject to technical feasibility reviews with AWS teams

#### Prerequisites:
- Public IP range must be owned by the customer
- Regional availability and compliance verification required
- AWS technical consultation may be needed

#### Feasibility Assessment:
While theoretically possible, practical implementation requires:
- AWS technical team validation
- Compliance with AWS service limitations
- Potential service-specific constraints (e.g., IGW cannot use BYOIP)

> [!IMPORTANT]
> Bring Your Own Public IP is feasible but requires AWS technical consultation. Not all AWS services support customer-owned IP ranges (e.g., Internet Gateway typically uses AWS-managed IPs).

## Lab Demo: Building the Customized VPC

### Clean Up Default Resources
1. Navigate to VPC dashboard
2. Locate default VPC
3. Delete default VPC and verify removal of:
   - Default subnets
   - Internet Gateway
   - Default route tables
   - Security groups
   - Network ACLs
   - Elastic IPs (if any)

> [!NOTE]
> Customized VPCs do not include default IGW or route table entries for internet access

### Create the Networking Kings VPC
1. Click "Create VPC"
2. Configure settings:
   - **Name tag**: Network Kings VPC
   - **IPv4 CIDR block**: 10.1.0.0/24
   - **IPv6 block**: None
   - **Tenancy**: Default (default is fine)
3. Create VPC and verify:
   - VPC ID (e.g., vpc-XXXXXXXX)
   - Main route table created with local route entry
   - No internet access route by default

### Create Subnets
1. Create **Networking Subnet A** (Private):
   - **Name**: Networking Subnet A
   - **VPC**: Network Kings VPC
   - **Availability Zone**: us-east-1a (or client-preferred)
   - **CIDR block**: 10.1.0.0/28 (11 available IPs)
   - **Purpose**: Private subnet for isolation

2. Create **Networking Subnet B** (Public):
   - **Name**: Networking Subnet B
   - **VPC**: Network Kings VPC
   - **Availability Zone**: us-east-1b (different AZ preferred)
   - **CIDR block**: 10.1.16.0/28 (11 available IPs)
   - **Purpose**: Public subnet for internet-facing resources

### Create and Attach Internet Gateway (IGW)
1. Navigate to Internet Gateways section
2. Click "Create Internet Gateway"
3. Configure:
   - **Name**: Network Kings IGW
4. Create IGW
5. Attach to VPC:
   - Select the created IGW
   - Attach to Network Kings VPC
   - Verify attachment status

> [!NOTE]
> IGW attachment automatically updates the main route table's routes section, but manual route table entries are still required

### Create Route Tables
1. Public Route Table:
   - **Name**: Public Route Table
   - Add route entry:
     - **Destination**: 0.0.0.0/0
     - **Target**: igw-XXXXXXXX (Network Kings IGW)
   - Associate with Networking Subnet B

2. Private Route Table:
   - **Name**: Private Route Table
   - Add route entry (when NAT Gateway is created):
     - **Destination**: 0.0.0.0/0
     - **Target**: nat-XXXXXXXX (NAT Gateway ID)
   - Associate with Networking Subnet A

> [!NOTE]
> Route entry for IGW is manual - AWS does not automatically add routes when attaching IGW to VPC

## Summary

### Key Takeaways
```diff
+ VPC is the foundation of AWS networking - build components on top of solid VPC knowledge
+ NAT Gateway: One-way communication (private subnet access internet)
+ IGW: Two-way communication (public subnet full internet access)
+ Each subnet has its own virtual router processing routing decisions
+ Elastic IP provides IP persistence across instance reboots
+ Route tables determine traffic flow - main route table vs custom route tables
+ Bring Your Own Public IP is feasible but requires AWS technical validation
+ Private subnets use NAT Gateway for controlled internet access
+ Traffic flow follows: VM → Security Group → Route Table → Gateway → Internet
```

### Expert Insight

#### Real-world Application
In enterprise environments, this architecture powers multi-tier applications where:
- Web servers reside in public subnets with direct internet access
- Application and database servers isolate in private subnets
- NAT Gateways provide controlled outbound access for updates/patches
- Security groups provide defense-in-depth beyond network isolation
- Route table design enables future integration with services like VPN, Direct Connect

#### Expert Path
✅ **Foundation**: Master VPC components (IGW, NAT Gateway, Route Tables, Subnets)
✅ **Advanced Study**: AWS networking services (VPC Peering, Direct Connect, Transit Gateway)
✅ **Hands-on**: Build multi-VPC architectures with cross-region connectivity
✅ **Certifications**: AWS Solutions Architect Associate/PCP focus on network design
✅ **Specialization**: Study hybrid cloud networking with on-premises integration

#### Common Pitfalls
❌ **Skipping IGW Creation**: Assuming default VPC behavior applies to custom VPCs
❌ **Wrong Route Table Association**: Forgetting to associate route tables with specific subnets
❌ **NAT Gateway in Wrong Subnet**: Placing NAT Gateway in private subnet instead of public
❌ **Security Group Configuration**: Not planning rules before EC2 instance creation
❌ **IP Planning**: Overlooking AWS IP reservation (first 4 IP addresses unusable)

#### Lesser Known Things
💡 **Regional Services**: NAT Gateway must reside in Availability Zone with redundancy provided automatically
💡 **Pricing Model**: NAT Gateway charges apply to both ingress and egress traffic (contrary to common belief)
💡 **IP Limitation**: AWS VPC resource limits apply per region and across all VPCs in account
💡 **Broadcast Domain**: Each subnet represents its own broadcast domain with implicit routing decisions
💡 **VPC Router Intelligence**: The main VPC router maintains connectivity to all attached components via private IP addresses
