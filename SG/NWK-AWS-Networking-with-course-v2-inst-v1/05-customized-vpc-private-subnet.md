# Session 5: Customized VPC & Private Subnet

<details open>
<summary><b>Customized VPC & Private Subnet (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts & Deep Dive](#key-concepts--deep-dive)
  - [Client Requirements Analysis](#client-requirements-analysis)
  - [NAT Gateway vs Internet Gateway](#nat-gateway-vs-internet-gateway)
  - [Elastic IP vs Dynamic Public IP](#elastic-ip-vs-dynamic-public-ip)
  - [VPC Architecture Components](#vpc-architecture-components)
  - [Route Table Behavior](#route-table-behavior)
- [Lab Demo](#lab-demo)
  - [Creating a Customized VPC](#creating-a-customized-vpc)
  - [Configuring Subnets](#configuring-subnets)
  - [Internet Gateway Setup](#internet-gateway-setup)
  - [Route Table Configuration](#route-table-configuration)
- [Summary](#summary)

## Overview

This session focuses on implementing a customized Virtual Private Cloud (VPC) in AWS with both private and public subnets. The lesson covers client requirements for creating a multi-subnet VPC architecture, understanding gateway differences, and implementing proper routing configurations for secure cloud networking.

**Learning Objectives:**
- Design and implement customized VPC with multiple subnets
- Configure Internet Gateway and NAT Gateway for different access patterns
- Understand route table associations and traffic flow
- Differentiate between elastic and dynamic public IPs

**Key Technologies:** AWS VPC, Subnets, Route Tables, Internet Gateway, NAT Gateway, Elastic IP

## Key Concepts & Deep Dive

### Client Requirements Analysis

The session begins with analyzing specific client requirements for a customized VPC implementation:

**Client Specifications:**
- **VPC Range:** `10.1.0.0/24` (inherited from on-premises network `10.1.2.0/24`)
- **Subnet Requirements:**
  - Networking Subnet A (Private): `10.1.0.0/28`
  - Networking Subnet B (Public): `10.1.16.0/28`
- **VM Deployment:**
  - 1 VM in private subnet (internet access via NAT Gateway)
  - 2 VMs in public subnet (direct internet access via IGW)
- **Routing:** Separate route tables for private and public subnets

> [!IMPORTANT]
> Always analyze client requirements thoroughly before implementation. Customized VPCs require manual configuration of all components unlike default VPCs.

### NAT Gateway vs Internet Gateway

**Core Difference: One-way vs Two-way Communication**

#### NAT Gateway (Network Address Translation Gateway)
- **Purpose:** Enables private subnet VMs to access internet while preventing inbound connections
- **Communication Flow:** One-way (outbound only)
- **Location:** Must be placed in a public subnet
- **IP Translation:** Many-to-one NAT (entire private subnet maps to single public IP)

#### Internet Gateway (IGW)
- **Purpose:** Enables bidirectional communication between VPC resources and internet
- **Communication Flow:** Two-way (inbound and outbound)
- **Location:** Attached to VPC (not a subnet)
- **IP Translation:** One-to-one NAT (each public IP maps to specific private IP)

**Traffic Flow Comparison:**

| Scenario | Source | NAT Gateway | Internet Gateway |
|----------|--------|-------------|------------------|
| VM → Internet | Private subnet VM | ✓ Allowed | ✓ Allowed |
| Internet → VM | External user | ✗ Blocked | ✓ Allowed |

**Security Implication:**
- Private subnet VMs can download updates but cannot be accessed externally
- Public subnet VMs can be reached from anywhere on the internet

### Elastic IP vs Dynamic Public IP

#### Elastic IP Address
- **Characteristics:** Static, retainable, survives instance reboots
- **Purpose:** Provides consistent public IP for long-term services
- **Cost:** Free when associated with running instance; charged when allocated but unassociated
- **Use Case:** Production servers requiring fixed IP addresses

#### Dynamic Public IP
- **Characteristics:** Ephemeral, changes on instance reboot
- **Purpose:** Temporary internet access for short-term needs
- **Cost:** No additional charge
- **Use Case:** Development/testing environments

**Key Distinction:**
> Dynamic IPs are returned to AWS pool when instance stops, preventing external connections. Elastic IPs remain with account and can be reassociated.

**Client Consideration:**
When client specifies "own public IP," they typically mean using an elastic IP rather than bringing their own IP range (BYOIP), which requires special AWS approval.

### VPC Architecture Components

#### VPC Router
- **Function:** Central routing intelligence for the VPC
- **Location:** Virtual component associated with VPC
- **Capabilities:**
  - Routes traffic between subnets
  - Connects to gateways (IGW, NAT Gateway)
  - Maintains local routing within VPC range

#### Main Route Table
- **Creation:** Automatically created with VPC
- **Default Behavior:** All subnets associate with main route table unless explicitly reassigned
- **Initial Entry:** `local` route for VPC CIDR block

#### Custom Route Tables
- **Purpose:** Segregate routing for different subnet types
- **Association:** Manually associated with specific subnets
- **Configuration:**
  - **Public Route Table:** Route `0.0.0.0/0` to IGW
  - **Private Route Table:** Route `0.0.0.0/0` to NAT Gateway

#### Subnet Router Concept
Each subnet has its own virtual router that:
- Handles first-hop routing for VMs in that subnet
- Forwards traffic to VPC router when destination is outside local subnet
- Uses associated route table for decision making

### Route Table Behavior

**Key Principle:** Traffic always flows through VPC router, even when custom route tables are configured.

**Packet Flow Analysis:**

1. **Intra-VPC Communication:**
   - VM sends packet to default gateway (`.1` IP of subnet)
   - Subnet router checks route table association
   - If no custom route table → uses main route table
   - Main route table has `local` entry for VPC CIDR
   - Packet routed directly to destination subnet

2. **Internet-Bound Traffic (Public Subnet):**
   - VM → Subnet router → Custom route table → IGW route exists
   - Packet forwarded to VPC router
   - VPC router has direct connection to IGW
   - Packet translated and sent to internet

3. **Internet-Bound Traffic (Private Subnet):**
   - VM → Subnet router → Custom route table → NAT Gateway route
   - Packet forwarded to VPC router
   - VPC router routes to NAT Gateway (in public subnet)
   - NAT Gateway performs PAT (Port Address Translation)
   - Packet sent to internet with source NAT

**Table: Route Table Types and Associations**

| Route Table Type | Default Routes | Subnet Association | Internet Access |
|------------------|---------------|-------------------|------------------|
| Main Route Table | `local` (VPC CIDR) | Automatic (all subnets) | None |
| Public Route Table | `0.0.0.0/0 → IGW` | Explicit (public subnets) | Direct |
| Private Route Table | `0.0.0.0/0 → NAT GW` | Explicit (private subnets) | Via NAT |

## Lab Demo

### Creating a Customized VPC

**Step 1: VPC Creation**
```bash
# VPC Configuration
Name: networking-kings-VPC
IPv4 CIDR: 10.1.0.0/24
IPv6 CIDR: None
Tenancy: Default
DNS Hostnames: Enabled
DNS Resolution: Enabled
Tags: Name=networking-kings-VPC
```

**VPC Creation Commands:**
```bash
aws ec2 create-vpc \
  --cidr-block 10.1.0.0/24 \
  --instance-tenancy default \
  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=networking-kings-VPC}]'
```

### Configuring Subnets

**Step 2: Create Two Subnets**

*Networking Subnet A (Private):*
```bash
Name: networking-subnet-A
VPC: networking-kings-VPC
CIDR: 10.1.0.0/28
Availability Zone: us-east-1a
Tags: Name=networking-subnet-A
```

*Networking Subnet B (Public):*
```bash
Name: networking-subnet-B
VPC: networking-kings-VPC
CIDR: 10.1.16.0/28
Availability Zone: us-east-1b (or client-specified zone)
Tags: Name=networking-subnet-B
```

**Available IP Addresses per Subnet:**
- /28 subnet = 16 total IPs
- Reserved IPs: 5 (network, gateway, DNS, broadcast)
- Usable IPs: 11 per subnet

**Subnet Creation Commands:**
```bash
# Private Subnet A
aws ec2 create-subnet \
  --vpc-id vpc-xxxxxxxx \
  --cidr-block 10.1.0.0/28 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=networking-subnet-A}]'

# Public Subnet B
aws ec2 create-subnet \
  --vpc-id vpc-xxxxxxxx \
  --cidr-block 10.1.16.0/28 \
  --availability-zone us-east-1b \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=networking-subnet-B}]'
```

### Internet Gateway Setup

**Step 3: Create and Attach Internet Gateway**

```bash
# Create IGW
Name: prod-IGW
Type: Internet Gateway

# Attach to VPC
VPC: networking-kings-VPC
```

**IGW Commands:**
```bash
# Create IGW
aws ec2 create-internet-gateway \
  --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=prod-IGW}]'

# Attach IGW to VPC
aws ec2 attach-internet-gateway \
  --internet-gateway-id igw-xxxxxxxx \
  --vpc-id vpc-xxxxxxxxxxxxxxxxx
```

**Important Notes:**
- IGW attachment modifies main route table with `0.0.0.0/0 → igw-xxxxxxxx` route
- This enables internet access for any subnet still using main route table

### Route Table Configuration

**Step 4: Create Public Route Table**

```bash
# Route Table Configuration
Name: public-route-table
VPC: networking-kings-VPC

# Add Route
Destination: 0.0.0.0/0
Target: igw-xxxxxxxx (prod-IGW)

# Subnet Association
Associate with: networking-subnet-B
```

**Public Route Table Commands:**
```bash
# Create route table
aws ec2 create-route-table \
  --vpc-id vpc-xxxxxxxxxxxxxxxxx \
  --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=public-route-table}]'

# Add internet route
aws ec2 create-route \
  --route-table-id rtb-xxxxxxxxxxxxxxxxx \
  --destination-cidr-block 0.0.0.0/0 \
  --gateway-id igw-xxxxxxxx

# Associate with public subnet
aws ec2 associate-route-table \
  --route-table-id rtb-xxxxxxxxxxxxxxxxx \
  --subnet-id subnet-xxxxxxxxxxxxxxxxx
```

**Step 5: Create Private Route Table (for NAT Gateway)**

*Note: NAT Gateway creation would follow here, then private route table configuration:*

```bash
# Route Table Configuration
Name: private-route-table
VPC: networking-kings-VPC

# Add Route (after NAT Gateway creation)
Destination: 0.0.0.0/0
Target: nat-xxxxxxxx (NAT Gateway in public subnet)

# Subnet Association
Associate with: networking-subnet-A
```

## Summary

### Key Takeaways

```diff
+ PUBLIC SUBNET VMs get direct internet access through Internet Gateway
+ PRIVATE SUBNET VMs access internet only through NAT Gateway (outbound only)
- PRIVATE SUBNET VMs cannot be directly accessed from the internet
- INTERNET GATEWAY enables two-way communication
- NAT GATEWAY provides one-way communication for private subnets
+ ELASTIC IPs remain static across instance reboots
- DYNAMIC IPs change on instance reboot and are returned to AWS pool
+ CUSTOM ROUTE TABLES provide traffic isolation between subnets
+ VPC ROUTER is the central routing component for all traffic flow
```

### Quick Reference

**VPC Creation:**
```yaml
Name: networking-kings-VPC
CIDR: 10.1.0.0/24
Subnets:
  - Private: 10.1.0.0/28 (Networking Subnet A)
  - Public: 10.1.16.0/28 (Networking Subnet B)
```

**Route Table Configurations:**
```yaml
Public Route Table:
  - 10.1.0.0/24 → local
  - 0.0.0.0/0 → igw-xxxxxxxx

Private Route Table:
  - 10.1.0.0/24 → local
  - 0.0.0.0/0 → nat-xxxxxxxx
```

**Security Groups Required:**
```yaml
Web Server (Public Subnet):
  - SSH (22) from 0.0.0.0/0
  - HTTP (80) from 0.0.0.0/0
  - HTTPS (443) from 0.0.0.0/0

Application Server (Private Subnet):
  - SSH (22) from Public Subnet CIDR
  - Application ports from Load Balancer Security Group
```

### Expert Insight

**Real-world Application:**
Customized VPCs are essential for enterprise workloads requiring:
- Multi-tier application architectures (web, application, database layers)
- Hybrid cloud connectivity with on-premises networks
- Regulatory compliance with network segmentation
- Cost optimization through appropriate gateway selection

**Expert Path:**
1. Master VPC design patterns for different application architectures
2. Understand AWS networking limits per region/account
3. Learn advanced networking: VPC peering, Transit Gateway, Direct Connect
4. Study network security: Security Groups, NACLs, VPC Flow Logs
5. Practice multi-AZ, multi-region architectures

**Common Pitfalls:**
- ❌ Forgetting to associate subnets with custom route tables
- ❌ Placing NAT Gateway in private subnet (will fail)
- ❌ Using IGW for private subnets (exposes VMs to internet)
- ❌ Not reserving elastic IPs in production (dynamic IPs change)
- ❌ Ignoring Security Groups (network-level traffic control)

</details>