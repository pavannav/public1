<details open>
<summary><b>05 Customized VPC & Private subnet.txt (KK-CS45-script-v2-Inst-v3)</b></summary>

# Session 5: Customized VPC & Private Subnet

## Table of Contents
- [Client Requirements Overview](#client-requirements-overview)
- [NAT Gateway vs Internet Gateway](#nat-gateway-vs-internet-gateway)
- [Elastic IP vs Dynamic Public IP](#elastic-ip-vs-dynamic-public-ip)
- [VPC Creation](#vpc-creation)
- [Subnet Creation](#subnet-creation)
- [Internet Gateway Setup](#internet-gateway-setup)
- [Route Table Concepts](#route-table-concepts)
- [VM Deployment Planning](#vm-deployment-planning)

## Client Requirements Overview

### Overview
This session focuses on implementing a client's specific network architecture requirements within AWS. The scenario involves creating a customized VPC with both public and private subnets, implementing proper routing for internet access, and understanding the differences between various AWS networking components.

### Key Concepts / Deep Dive

**Client Specifications:**
- Create a custom VPC (not default)
- VPC name: "Networking King VPC"
- IP range: 10.0.0.0/16 (managed by AWS IPAM)
- Two subnets required:
  - Networking Subnet A: 10.1.0.0/28 (private subnet)
  - Networking Subnet B: 10.1.16.0/28 (public subnet)

**Testing Requirements:**
- Spin up 1 VM in private subnet with internet access
- Spin up 1 VM in public subnet with internet access
- Use NAT Gateway for private subnet internet access
- Utilize Elastic IP for public subnet

### Implementation Flow
```diff
+ Step 1: Delete default VPC (start clean)
+ Step 2: Create custom VPC with specified IP range
+ Step 3: Create required subnets with proper AZ placement
+ Step 4: Set up Internet Gateway and NAT Gateway
+ Step 5: Configure route tables (public/private)
+ Step 6: Deploy VMs and test connectivity
```

## NAT Gateway vs Internet Gateway

### Overview
Understanding the fundamental differences between NAT (Network Address Translation) Gateway and Internet Gateway is crucial for designing secure network architectures. Each serves different purposes in AWS networking.

### Key Concepts / Deep Dive

**Nat Gateway Characteristics:**
- Provides **one-way communication** (outbound only)
- Allows private subnet resources to access internet
- Prevents inbound traffic from internet to private resources
- Requires placement in **public subnet**
- Uses public IP for outbound connections
- Provides source NAT for private subnet traffic

**Internet Gateway Characteristics:**
- Provides **two-way communication** (bidirectional)
- Enables both inbound and outbound internet access
- Allows external resources to initiate connections to public resources
- Performs static NAT (1:1 mapping) for public subnets

### Communication Patterns

| Component | Direction | Use Case | Security |
|-----------|-----------|----------|-----------|
| NAT Gateway | Outbound only | Private subnet → Internet | ✅ High (inbound blocked) |
| Internet Gateway | Bidirectional | Internet ↔ Public subnet | ⚠️ Medium (requires security groups) |

### Lab Demo: Packet Flow Illustration

**Private Subnet VM → Internet (via NAT Gateway):**
```
VM (10.1.0.10) → Security Group → ENI → Local Router → VPC Router → NAT Gateway → IGW → Internet
```

**Public Subnet VM ↔ Internet (via IGW):**
```
VM (10.1.16.20) → Security Group → ENI → Local Router → VPC Router → IGW → Internet
```

> [!IMPORTANT]
> NAT Gateway provides outgoing internet access for private resources while maintaining inbound isolation. IGW enables full bidirectional communication but requires additional security controls.

## Elastic IP vs Dynamic Public IP

### Overview
AWS offers two types of public IP addresses for EC2 instances: temporary dynamic IPs and persistent elastic IPs. Understanding when to use each type is essential for production deployments.

### Key Concepts / Deep Dive

**Dynamic Public IP:**
- Assigned by AWS when instance starts
- Changes when instance is stopped/started
- Free of charge (included with instance)
- Suitable for temporary/development environments
- AWS DHCP server holds lease for ~30 days

**Elastic IP:**
- Permanent public IP allocation
- Retains IP across instance stop/start cycles
- Charged when allocated but not used
- Enable/disable auto-assignment per instance or subnet
- Limited to 5 per region (soft limit, can be increased)

### Cost Implications

| IP Type | Charging Mechanism | Cost Structure |
|---------|-------------------|----------------|
| Dynamic | Included in instance pricing | No additional cost |
| Elastic | Hourly charge when allocated | $0.005/hour when not in use and associated |

### Client Decision Point
The client specifically requested to **avoid purchasing additional public IPs**, opting to use AWS-provided elastic IPs instead of bring-your-own-IP (BYOIP).

> [!NOTE]
> Bring Your Own IP (BYOIP) is technically feasible in AWS but requires coordination with AWS support and is not commonly used for typical deployments.

## VPC Creation

### Overview
Creating a customized VPC provides complete control over your network architecture, security boundaries, and routing policies. Unlike default VPCs, custom VPCs require manual configuration of all network components.

### Key Concepts / Deep Dive

**VPC Components Architecture:**
```
VPC (10.0.0.0/16)
├── Main Route Table (auto-created)
├── Security Groups (will inherit from VPC)
├── Network ACLs (VPC-level)
├── Subnets (within VPC IP range)
└── Gateways (IGW, NAT Gateway)
```

### Configuration Parameters

| Parameter | Value | Notes |
|-----------|-------|-------|
| Name | Networking King VPC | As per client requirement |
| IPv4 Cidr Block | 10.0.0.0/16 | Managed by AWS IPAM system |
| IPv6 | Disabled | Not required for this implementation |
| Tenancy | Default | Cost-effective, shared hardware |
| Tags | Auto-assigned | VPC identifier for management |

### Lab Demo: VPC Setup

**CLI Configuration:**
```bash
aws ec2 create-vpc \
  --cidr-block 10.0.0.0/16 \
  --instance-tenancy default \
  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=Networking King VPC}]'
```

**Verification:**
```bash
aws ec2 describe-vpcs --filters Name=tag:Name,Values="Networking King VPC"
```

> [!WARNING]
> Always delete the default VPC when working with custom requirements. The default VPC may interfere with your network design and create unintended connectivity.

## Subnet Creation

### Overview
Subnets divide your VPC into smaller, manageable network segments. Each subnet resides in a specific Availability Zone and inherits security policies from the VPC while maintaining its own access controls.

### Key Concepts / Deep Dive

**Subnet Design Principles:**
- Divide VPC into isolated network segments
- Each subnet gets first 4 IPs reserved by AWS
- Last IP reserved for broadcast (in /28 subnets)
- Available IPs per /28 subnet: 11 (out of 16 total)

**Reserved IP Allocation:**
```
10.1.0.0/28 Subnet:
- 10.1.0.0: Network address
- 10.1.0.1: VPC Router (gateway)
- 10.1.0.2: AWS DNS
- 10.1.0.3: Future AWS use
- 10.1.0.15: Broadcast address
- Available: 10.1.0.4-10.1.0.14 (11 IPs)
```

### Lab Demo: Subnet Setup

**Public Subnet (Networking Subnet B):**
```bash
aws ec2 create-subnet \
  --vpc-id vpc-12345678 \
  --cidr-block 10.1.16.0/28 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Networking Subnet B}]'
```

**Private Subnet (Networking Subnet A):**
```bash
aws ec2 create-subnet \
  --vpc-id vpc-12345678 \
  --cidr-block 10.1.0.0/28 \
  --availability-zone us-east-1b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Networking Subnet A}]'
```

> [!NOTE]
> Place subnets in different Availability Zones for high availability. Public subnets typically need internet access, while private subnets use NAT Gateway.

## Internet Gateway Setup

### Overview
Internet Gateway acts as the bridge between your VPC and the public internet. It's a regional component that requires explicit attachment to VPCs and manual route table configuration.

### Key Concepts / Deep Dive

**IGW Functionality:**
- Translates private IP addresses to public IPs (and vice versa)
- Enables bidirectional internet communication
- Must be attached to VPC before use
- Regional resource (not AZ-specific)
- No additional cost for data transfer

**Attachment Process:**
```diff
+ Create IGW → Attach to VPC → Configure Route Tables → Test Connectivity
```

### Lab Demo: IGW Configuration

**Create Internet Gateway:**
```bash
aws ec2 create-internet-gateway \
  --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=Prod IGW}]'
```

**Attach to VPC:**
```bash
aws ec2 attach-internet-gateway \
  --internet-gateway-id igw-12345678 \
  --vpc-id vpc-87654321
```

**Verify Attachment:**
```bash
aws ec2 describe-internet-gateways --internet-gateway-ids igw-12345678
```

> [!IMPORTANT]
> IGW attachment to VPC does NOT automatically add routes. You must manually configure route table entries to direct traffic through IGW.

## Route Table Concepts

### Overview
Route tables contain routing rules that determine how network traffic flows within your VPC. Understanding the relationship between main route tables, custom route tables, and subnet associations is crucial for proper network isolation.

### Key Concepts / Deep Dive

**Route Table Hierarchy:**
- **Main Route Table**: Auto-created per VPC, default for all subnets
- **Custom Route Tables**: User-created for specific traffic patterns
- **Subnet Association**: Explicit binding between subnets and route tables

**Router Architecture:**
```
Subnet Router → VPC Main Router → IGW/NAT Gateway
```

**Route Entry Types:**
- **Local**: VPC internal communication (auto-managed)
- **IGW**: Public internet access (0.0.0.0/0 → igw-xxxxx)
- **NAT Gateway**: Outbound private traffic (0.0.0.0/0 → nat-xxxxx)

### Deep Routing Concepts

**Packet Flow Architecture:**
Each subnet has its own virtual router that connects to the VPC's main router. The main router maintains connectivity to all gateways and knows how to route traffic between components.

**Route Table Behavior:**
```diff
! Subnet Router: Checks local rules, forwards to VPC router if needed
! VPC Router: Maintains connectivity to IGW and NAT gateways
! IGW/NAT: Translates between private and public IP spaces
```

### Lab Demo: Route Table Setup

**Create Public Route Table:**
```bash
aws ec2 create-route-table \
  --vpc-id vpc-12345678 \
  --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=Public Route Table}]'
```

**Add IGW Route:**
```bash
aws ec2 create-route \
  --route-table-id rtb-87654321 \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id igw-12345678
```

**Associate with Public Subnet:**
```bash
aws ec2 associate-route-table \
  --subnet-id subnet-12345678 \
  --route-table-id rtb-87654321
```

## VM Deployment Planning

### Overview
Strategic VM placement ensures proper security boundaries and connectivity. Public subnet VMs can receive inbound internet traffic, while private subnet VMs require NAT Gateway for outbound access only.

### Key Concepts / Deep Dive

**VM Placement Strategy:**
- **Public Subnet**: Internet-facing applications, load balancers, bastion hosts
- **Private Subnet**: Application servers, databases, internal services

**Required Components by VM Location:**
| VM Location | IGW Required | NAT Gateway Required | Route Table Configuration |
|------------|-------------|-------------------|-------------------------|
| Public Subnet | ✅ Yes | ❌ No | Default route to IGW |
| Private Subnet | ❌ No | ✅ Yes | Default route to NAT Gateway |

**Security Considerations:**
- Public VMs require Security Groups and NACLs
- Private VMs rely on NAT Gateway for outbound (no inbound direct access)
- Both types need proper security policies

### Deployment Checklist
```diff
+ Prerequisites:
! ✅ VPC created and configured
! ✅ Subnets created in different AZs
! ✅ IGW created and attached
! ✅ NAT Gateway created in public subnet
! ✅ Route tables configured and associated
! ✅ Security groups planned
+ VM Deployment:
! ✅ 1 VM in public subnet (with Elastic IP)
! ✅ 1 VM in private subnet
! ✅ Test internet connectivity from both
```

## Summary

### Key Takeaways
```diff
+ NAT Gateway: One-way communication, outbound internet for private subnets
- Internet Gateway: Two-way communication, bidirectional internet access
+ Elastic IP: Persistent public IP, survives instance stop/start cycles
- Dynamic IP: Temporary AWS-assigned IP, changes on stop/start
! Route tables control traffic flow: Each subnet needs explicit routing rules
! Subnet isolation: Private subnets use NAT Gateway, public subnets use IGW
+ VPC foundation: All networking components build upon VPC design principles
```

### Quick Reference

**VPC Components Check:**
```bash
# Verify VPC and subnets
aws ec2 describe-vpcs --filters Name=tag:Name,Values="Networking King VPC"
aws ec2 describe-subnets --filters Name=vpc-id,Values=vpc-xxxxx

# Check routing
aws ec2 describe-route-tables --filters Name=vpc-id,Values=vpc-xxxxx
aws ec2 describe-internet-gateways --filters Name=attachment.vpc-id,Values=vpc-xxxxx

# NAT Gateway status
aws ec2 describe-nat-gateways --filter Name=vpc-id,Values=vpc-xxxxx
```

**Connectivity Testing:**
```bash
# From public VM
ping 8.8.8.8  # Should work
curl ifconfig.me  # Should return public IP

# From private VM
ping 8.8.8.8  # Should work (via NAT Gateway)
curl ifconfig.me  # Should return NAT Gateway's public IP
```

**Port/Protocol Reference:**
- **VM Access**: SSH (port 22), RDP (port 3389)
- **NAT Gateway**: All outbound protocols supported
- **IGW**: All inbound/outbound protocols supported

### Expert Insight

#### Real-world Application
Implement this architecture for multi-tier applications where web servers need public access while application and database servers remain private. Use NAT Gateway for software updates, API calls, and logging to external services while maintaining security isolation.

#### Expert Path
Master VPC peering and VPC endpoints for complex architectures. Learn about Transit Gateway for multi-VPC connectivity across regions. Practice designing hybrid cloud topologies with on-premises connectivity via Direct Connect or VPN.

#### Common Pitfalls
- **Forgetting IGW routes**: Always manually add 0.0.0.0/0 → igw-id to public route tables
- **NAT Gateway placement**: Must be in public subnet for internet connectivity
- **Security group overlap**: Private instances can't be directly accessed from internet
- **AZ mismatch**: NAT Gateway and private subnets can be in different AZs, but cross-AZ traffic incurs charges

#### Lesser-Known Facts
- Route tables can have multiple associations but each subnet associates with only one route table
- AWS reserves 5 IPs per subnet (network + router + DNS + future + broadcast)
- NAT Gateway provides redundancy across AZs automatically
- Elastic IP charges continue even when instance is stopped

#### Advantages and Disadvantages

| Component | Advantages | Disadvantages |
|-----------|------------|--------------|
| NAT Gateway | - Secure outbound only<br>- High availability<br>- No IP management | - Additional cost<br>- No inbound access<br>- Single point of failure concern |
| Internet Gateway | - Full bidirectional access<br>- Cost-free<br>- High performance | - Security exposure<br>- Requires careful NACL/SG design<br>- No NAT functionality |
| Custom VPC | - Complete control<br>- Security isolation<br>- Compliance-ready | - Complex setup<br>- Manual configuration<br>- Learning curve |

</details>