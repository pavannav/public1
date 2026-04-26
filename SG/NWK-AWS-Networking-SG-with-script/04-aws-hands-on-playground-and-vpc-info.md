# AWS Hands On Playground and VPC Info

<details open>
<summary><b>AWS Hands On Playground and VPC Info (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Lab Environment Setup](#lab-environment-setup)
- [AWS Account Creation](#aws-account-creation)
- [AWS VPC Fundamentals](#aws-vpc-fundamentals)
- [Creating a Custom VPC](#creating-a-custom-vpc)
- [Network Components and Security](#network-components-and-security)
- [EC2 Instance Deployment](#ec2-instance-deployment)
- [Lab Demonstration](#lab-demonstration)
- [Summary](#summary)

## Overview

This session covers hands-on setup for AWS lab environments including account creation, lab access management, and fundamental VPC (Virtual Private Cloud) concepts. We explore default VPC architecture, custom VPC creation with subnets, route tables, internet gateways, and security configurations, culminating in deploying and connecting to an EC2 instance in a public subnet. The session emphasizes practical network deployment in AWS with security considerations for production environments.

## Lab Environment Setup

### AWS Lab Access and Scheduling

The lab environment uses a cloud-based sandbox accessible for 4 hours maximum, with 2-hour usage per session to manage resources efficiently. Students share access via shared accounts with specific restrictions:

- URL and credentials (username, password, access key ID) distributed to authorized users
- Access limited to AWS, Azure and Google Cloud platforms (monitoring enforced for compliance)
- Resource cleanup critical to avoid charges beyond 4-hour window
- Excel tracking system for 2-hour session bookings with timezone considerations (IST, US, European)
- 12 available sessions daily with first-come-first-served access for non-scheduled slots
- Dedicated time slots available (e.g., 8 AM - 10 AM IST, with corresponding US evening hours)

**Key Points:**
- Active monitoring dashboard prevents unauthorized platform usage
- Non-dedicated time slots follow first-come-first-served policy
- Active WhatsApp group communication required for slot management
- Weekends offer single-user access due to limited student activity

### Session Management Rules

```bash
ls -la ~/
# Navigate to lab environment after receiving credentials
# Strictly adhere to 2-hour per session rule
# Delete sandbox after completion to clear resources
# Post-completion pickup: complete labs within 30 minutes on next session
```

## AWS Account Creation

### Creating a Free Tier Account

Follow these steps for AWS account signup:

1. Navigate to management console login page (search "AWS Management Console")
2. Click "Create an AWS Account" (not sign-in)
3. Provide verified email address and root account name
4. Set strong password for root user recovery purposes
5. Verify email receipt and complete account registration
6. For billing verification, enter valid credit/debit card details
7. Note: Free tier eligible services prevent unexpected charges

> [!IMPORTANT]
> Use personal Gmail for account creation (not company email to avoid 2FA complications). Accounts include 12 months of free tier services with clear billing notifications.

### Free Tier Service Awareness

AWS provides extensive free tier services (750+ hours EC2, storage, etc.) but requires active resource monitoring. Key cost-aware services include:

- EC2 instances (t2.micro, t3.micro)
- S3 storage, Lambda functions
- Amazon SageMaker notebook instances

## AWS VPC Fundamentals

### VPC as a Data Center Analogy

Virtual Private Cloud (VPC) represents your logical cloud data center, encompassing:
- Physical firewalls (Security Groups, NACLs)
- Network switches (Route Tables, Subnets) 
- Routing infrastructure (Internet Gateway, NAT Gateway)
- VM compute resources (EC2 instances)
- Network segmentation capabilities

### Default VPC Architecture

Upon AWS account creation, each region receives a default VPC with:
- CIDR range: 172.31.0.0/16
- Dedicated subnets per availability zone
- Internet Gateway (IGW) attached
- Default main route table
- Default security groups
- Network ACL configurations

**IP Allocation Notes:**
- Default VPC reserves specific IP ranges per region
- First available IP for default VPC: 172.31.0.0/16
- Reserved IPs: Network (x.x.x.0), Gateway (x.x.x.1), DNS (x.x.x.2), Future use (x.x.x.3), Broadcast (x.x.x.255)

### Availability Zones and Regions

- **Region**: Geographical AWS data center cluster
- **Availability Zone (AZ)**: Isolated DC within region (100km separation for redundancy)
- **North Virginia (us-east-1)**: Contains 6+ Availability Zones
- Fault tolerance: Multi-AZ deployment ensures 99.99% uptime

## Creating a Custom VPC

### Client Requirements Scenario

Create production VPC with overlapping avoidance for future on-premises migration, implementing separated public/private subnets with distinct routing.

**Requirements:**
- VPC CIDR: 10.1.1.0/24 (non-overlapping with on-premises 10.1.2.0/24)
- Private Subnet: 10.1.1.0/28 for internal workloads (32 IP addresses available)
- Public Subnet: 10.1.1.16/28 for internet-accessible resources
- Separate route tables: Private RTB and Public RTB
- Custom Internet Gateway (IGW)
- Demo EC2 instance deployment with internet access verification

### VPC Creation Process

```bash
# Navigate to VPC Console
# Services → VPC & Internet → VPC → Create VPC

VPC Name: networking-VPC
IPV4 CIDR: 10.1.1.0/24
Tenancy: Default (shared hardware)
```

**VPC Properties:**
- Automatic generation of main route table and default ACL
- No IGW attached (requires separate creation)
- Security group creation possible post-deployment

### Subnet Deployment

**Private Subnet Creation:**
```bash
# Subnet Name: networking-private-subnetA
# VPC ID: [Your VPC ID]
# Availability Zone: us-east-1a (or auto-selected)
# CIDR Block: 10.1.1.0/28
# Available IPs: 11 (15 total - 4 reserved)
```

**Public Subnet Creation:**
```bash
# Subnet Name: networking-public-subnetB  
# VPC ID: [Your VPC ID]
# CIDR Block: 10.1.1.16/28
# Available IPs: 11 (15 total - 4 reserved)
# Enable Auto-assign public IPv4 addresses: YES
```

### Route Table Configuration

**Private Route Table (Material RTB):**
- VPC CIDR route (local routing only)
- No internet access routes

**Public Route Table (Public RTB):**
- Requires IGW attachment for internet access
- Core routes include local VPC traffic + internet gateway

### Internet Gateway Setup

```bash
# Internet Gateway Name: networking-IGW-prod
# Attach to VPC: networking-VPC
```

**Route Addition for Public Subnet:**
```
Destination: 0.0.0.0/0
Target: igw-[YOUR-IGW-ID]
```

**Subnet Association:**
- Private Subnet → Private RTB
- Public Subnet → Public RTB

## Network Components and Security

### Security Group Configuration

**Default Behavior:**
- Created automatically with each VPC
- Allow VPC internal traffic (inbound/output rules)
- Inbound SSH (TCP 22) allowed for demo purposes

**Rule Modifications:**
```bash
# Allow SSH access for PoC
Type: SSH
Protocol: TCP 
Port: 22
Source: 0.0.0.0/0 (restrict to specific IP in production)
```

**Key Characteristics:**
- Per-NIC/per-VM binding flexibility
- Allows intra-VPC communication by default
- Stateful filtering (matching request/response pairs)
- Destination implicit (applies to bound resources)

### Network ACL (NACL) Features

**Default Properties:**
- Auto-generated with VPC (stateless filtering)
- Rule numbers determine evaluation order
- Permit all inbound/outbound traffic initially
- Applied per-subnet basis

**Rule Examples:**
```
Rule #: 100
Type: ALL Traffic
Protocol: ALL
Port Range: ALL
Source: 0.0.0.0/0
Allow/Deny: ALLOW
```

### VPC Component Limits

- **IGW per VPC**: 1 (one-to-one attachment)
- **VGW (VPN Gateway) per VPC**: 1 
- **NAT Gateway per AZ**: 1 for redundancy
- **Security Groups per VPC**: Unlimited
- **NACLs per VPC**: Unlimited

## EC2 Instance Deployment

### Instance Configuration

**Instance Type Selection:**
- AMI: Amazon Linux 2 (Free Tier eligible)
- Instance Type: t2.micro (1 vCPU, 1 GB RAM)
- Storage: 8 GB gp2 (general purpose SSD)

**Networking Setup:**
```
VPC: networking-VPC
Subnet: networking-public-subnetB (with auto-assign IPv4 enabled)
Auto-assign Public IP: Enable
IAM Profile: None
Security Group: networking-sg (with SSH rule)
```

**SSH Key Pair:**
```
Key Pair Name: networking-keypair
Key Pair Type: RSA
Private Key Format: .pem
```

### Connection Methods

**PuTTY SSH Setup:**
1. Convert .pem to .ppk using PuTTYgen
2. Load private key in PuTTY authentication
3. Host: Public IPv4 address
4. Username: ec2-user
5. Port: 22

**Alternative: EC2 Instance Connect**
- Browser-based access (requires IAM permissions)
- Session Manager (requires SSM agent)

## Lab Demonstration

### Complete VPC Cycle

1. **VPC Creation:** networking-VPC (10.1.1.0/24)
2. **IGW Setup:** networking-IGW-prod attached
3. **Subnet Configuration:**
   - Private: 10.1.1.0/28 → networking-RTB-private
   - Public: 10.1.1.16/28 → networking-RTB-public
4. **Route Table Updates:**
   - Public RTB: 0.0.0.0/0 → IGW
5. **Security Group:** SSH enabled
6. **EC2 Deployment:** Public subnet with auto-assigned IPs
7. **Connectivity Test:** SSH access and internet verification

### Internet Access Verification

```bash
# After SSH connection
curl -I https://www.google.com
# Expected: HTTP/1.1 200 OK response

hostname -I
# Verify assigned IPv4 addresses (private + public)
```

### Resource Cleanup Strategy

**Critical for Cost Management:**
- Terminate EC2 instances
- Detach/Delete IGW
- Delete subnets
- Delete route tables (main one retained)
- Delete VPC (removes associated resources)

## Summary

### Key Takeaways
```diff
+ VPC foundation: Logical data center with networking isolation
- Default VPC limitation: Pre-configured for quick starts, customize for production
+ Public Subnet = IGW access + auto-assigned public IPs
- Private Subnet = No direct internet, internal-only communication
+ Security Groups: Stateful per-resource ACLs (allow-focused)
+ NACLs: Stateless subnet-level filtering (explicit rules)
! Route Tables: Network traffic direction controllers
```

### Quick Reference
**VPC Range Calculation:**
- /16 block: 65,536 total IPs, 65,536 - 256 = ~65,000 usable
- /24 block: 256 total IPs, 256 - 5 = 251 usable (reserved: .0,.1,.2,.3,.255)
- /28 block: 16 total IPs, 16 - 4 = 12 usable

**Connectivity Test Commands:**
```bash
# SSH connection
ssh -i networking-keypair.pem ec2-user@<PUBLIC_IP>

# Verify internet access
ping -c 3 google.com

# Check interface details  
ip addr show
```

**Common VPC IDs to Remember:**
```
VPC-ID: vpc-xxxxxxxx (your custom VPC)
IGW-ID: igw-xxxxxxxx  
RTB-ID: rtb-xxxxxxxx (private/public)
SG-ID: sg-xxxxxxxx
NACL-ID: acl-xxxxxxxx
```

### Expert Insight

#### Real-world Application
Enterprise VPC architectures separate environments using multi-VPC setups with VPC peering, transit gateways, and cross-account networking. Production deployments implement least-privilege security with specific CIDR ranges, endpoint policies, and flow logging for compliance monitoring and threat detection.

#### Expert Path  
- Master subnetting calculations for optimal IP allocation
- Design hub-spoke VPC architectures with AWS Resource Access Manager
- Implement VPN/Direct Connect connectivity with on-premises networks
- Configure Network Firewall and VPC endpoints for secure communication
- Utilize Lambda@Edge and CloudFront for global content distribution

#### Common Pitfalls
- Avoiding overlapping CIDR ranges when planning hybrid cloud migrations
- Over-provisioning public IPs in public subnets increases exposure surface
- Neglecting security group least-privilege (0.0.0.0/0 SSH allowed in lab only)
- Forgetting resource cleanup leading to unexpected billing beyond free tier
- Misconfiguring route tables causing traffic blackhole scenarios

</details>
