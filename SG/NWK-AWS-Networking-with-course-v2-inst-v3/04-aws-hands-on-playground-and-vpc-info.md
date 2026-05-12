<details open>
<summary><b>Session 4: AWS Hands On Playground and VPC Info (KK-CS45-script-v2-Inst-v3)</b></summary>

# Session 4: AWS Hands On Playground and VPC Info

## Table of Contents
- [Overview](#overview)
- [Key Concepts / Deep Dive](#key-concepts--deep-dive)
  - [Lab Access and Sandbox Setup](#lab-access-and-sandbox-setup)
  - [AWS Account Creation and IAM](#aws-account-creation-and-iam)
  - [VPC Fundamentals](#vpc-fundamentals)
  - [Default vs. Custom VPC Architecture](#default-vs-custom-vpc-architecture)
  - [Subnet Design and IP Management](#subnet-design-and-ip-management)
  - [Route Table Configuration](#route-table-configuration)
  - [Internet Gateway Setup](#internet-gateway-setup)
  - [EC2 Instance Networking](#ec2-instance-networking)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview

This session introduces hands-on AWS networking through sandbox environments. Students learn VPC (Virtual Private Cloud) fundamentals, comparing AWS networking models with legacy data center concepts. The focus is on practical setup of sandbox access, AWS Free Tier usage, and building a complete VPC infrastructure with public/private subnets for secure VM connectivity.

🎯 **Target Audience**: Beginners to intermediate AWS learners needing practical VPC deployment skills.

---

## Key Concepts / Deep Dive

### Lab Access and Sandbox Setup

AWS sandboxes provide temporary environments for hands-on experimentation without production costs.

**Key Elements:**
- **Access Methods**: Individual user accounts with shared subscription limits
- **Time Limits**: 4-hour sandbox validity, recommended 2-hour usage cycles
- **Resource Management**: Delete resources after labs to avoid charges
- **Collaboration**: WhatsApp groups for lab scheduling and coordination

**Time Zone Coordination:**
```bash
# Lab scheduling across time zones
Monday: 10:00 AM IST (6:30 AM US EST)
Friday: Post-office hours across regions
Saturday/Sunday: Free for extended practice
```

### AWS Account Creation and IAM

**Account Setup Process:**
1. Navigate to AWS Management Console
2. Choose "Create AWS Account"
3. Provide Gmail-based email (avoid company domains for MFA)
4. Verify email and set password
5. Optional credit card (charges blocked if no resources used)

**IAM (Identity and Access Management):**
- Acts as AD (Active Directory) in cloud
- Groups contain privileges inherited by users
- Users assigned to groups for access control

### VPC Fundamentals

VPC represents your logical data center in AWS cloud with complete isolation.

> [!IMPORTANT]
> A VPC isolates your resources in a private section of AWS cloud, similar to data center with firewalls, routers, and VLANs.

**Comparison with Legacy Networking:**
```
Legacy Data Center        | AWS VPC Equivalent
--------------------------|-------------------
Physical Firewall         | Security Groups + NACLs
Router/Switches/VLANs     | Route Tables + Subnets
Server Room/Data Center   | Availability Zones + Regions
Corporate Network         | VPN Gateway + Direct Connect
```

### Default vs. Custom VPC Architecture

**Default VPC:**
- Exists in every AWS region
- IP Range: `172.31.0.0/16`
- Includes: Route Table, NACL, Security Groups, **Internet Gateway**
- Available in all 6 availability zones

**Custom VPC Components:**
- **Main Route Table**: Automatically attached to new subnets
- **Network ACL (NACL)**: Stateless packet filtering
- **Security Groups**: State-aware instance-level firewall
- **Internet Gateway (IGW)**: Required for internet access (**must be added separately**)
- **VPN Gateway (VGW)**: For site-to-site VPN connections

**Key Differences:**
```diff
+ Default VPC: IGW pre-configured, ready for internet access
- Custom VPC: IGW must be manually created and attached
+ Default VPC: Single per region
- Custom VPC: Multiple VPCs supported with proper planning
```

### Subnet Design and IP Management

**IP Management Rules:**
- VPC range defines total address space
- Five IPs reserved per subnet (network, gateway, DNS x2, broadcast)
- remainder = `2^(32 - CIDR) - 5`

**CIDR Calculation Example:**
```
VPC: 10.1.1.0/24
Private Subnet: 10.1.1.0/27 (32 IPs total, 27 usable)
Public Subnet: 10.1.1.32/27 (32 IPs total, 27 usable)
Unused: 10.1.1.64-10.1.1.255
```

**Public vs. Private Subnets:**
```diff
+ Public Subnet: VMs get public IP, direct internet access
- Private Subnet: VMs only private IPs, no direct internet (requires NAT)
+ Route Table: Points to Internet Gateway (IGW)
- Route Table: No IGW route
```

### Route Table Configuration

**Rule Processing:**
- Checked by source subnet's associated route table
- Most specific route matches first
- No match = packet dropped

**Private Route Table:**
- Local route for VPC internal traffic only
- No default gateway (0.0.0.0/0) entry

**Public Route Table:**
```
Destination    | Target            | Description
---------------|-------------------|-------------
10.1.1.0/27    | local            | VPC internal
0.0.0.0/0      | igw-[id]         | Internet via IGW
```

### Internet Gateway Setup

**IGW Characteristics:**
- Regional resource (spans all AZs)
- **One IGW per VPC** (enforced by AWS)
- Provides static NAT (SNAT/DNAT) translation
- Public IP maintained, private IP translated

**Attachment Process:**
```bash
# IGW ↔ VPC relationship
One IGW attaches to exactly one VPC
VPC can access internet only through attached IGW
IGW routes unknown traffic to AWS backbone
```

### EC2 Instance Networking

**Network Configuration:**
- **Security Groups**: Instance-attached firewalls
- **Subnets**: IP allocation source (public/private IP)
- **Auto-assign Public IP**: Subnet-level setting
- **Elastic IP**: Static public IP assignment

**SSH Access Setup:**
```bash
# Generate key pair locally
ssh-keygen -t rsa -b 2048 -f networking-key

# Set permissions
chmod 400 networking-key.pem

# Connect to instance
ssh -i networking-key.pem ec2-user@public-ip
```

**Outbound Security Group Rules:**
```diff
+ Default: Allow all outbound traffic
- Production: Restrict sources and ports
! SSH: TCP 22 from specific IPs or anywhere (for labs)
```

## Lab Demos

### Lab 1: Sandbox Access Setup
1. Access sandbox via provided URL
2. Login with IAM username and password
3. Verify AWS region and services access
4. Remove unused resources to save credits

### Lab 2: Custom VPC Creation
```bash
# VPC Creation Parameters
Name: networking-VPC
IPv4 CIDR: 10.1.1.0/24
Tenancy: Default
IPv6: Not enabled (optional)
```

### Lab 3: Subnet Architecture
```bash
# Private Subnet (No public access)
Name: networking-subnet-privateA
VPC: networking-VPC
CIDR: 10.1.1.0/27
AZ: us-east-1a

# Public Subnet (Internet-accessible)
Name: networking-subnet-publicB
VPC: networking-VPC
CIDR: 10.1.1.32/27
AZ: us-east-1a
Auto-assign Public IP: Yes
```

### Lab 4: Route Table Separation
```bash
# Private Route Table
Name: networking-RTB-private
Routes: Local only (no IGW)

# Public Route Table
Name: networking-RTB-public
Routes: Local + 0.0.0.0/0 → IGW
```

### Lab 5: Internet Gateway Deployment
```bash
# Create IGW
Name: networking-IGW-prod
Attach to VPC: networking-VPC

# Update Public Route Table
Edit Routes → Add 0.0.0.0/0 → networking-IGW-prod
```

### Lab 6: EC2 Instance Networking
```bash
# Instance Configuration
AMI: Amazon Linux 2
Instance Type: t2.micro (Free tier)
Network: Default VPC
Subnet: networking-subnet-publicB
Auto-assign Public IP: Enable
Security Group: Allow SSH (22) from anywhere
Key Pair: networking-key
```

### Lab 7: VM Access Verification
```bash
# Install PuTTY/powershell terminal
# Load private key (.pem file)
# Connect to EC2 instance
ssh -i networking-key.pem ec2-user@AUTO-ASSIGNED-PUBLIC-IP

# Verify networking
hostname -i  # Shows private IP: 10.1.1.XX
curl ifconfig.me  # Shows public IP via IGW
host google.com  # DNS resolution working
```

## Summary

### Key Takeaways
```diff
+ VPC provides isolated network environment in AWS cloud
+ Default VPC includes IGW; custom VPC requires manual IGW attachment
+ Public subnets access internet via IGW; private subnets require NAT
+ Security Groups are stateful; NACLs are stateless
+ Route tables determine traffic flow at subnet level
+ Five IPs reserved per subnet (network/gateway/DNS/broadcast/reserved)
```

### Quick Reference
```
Component        | Purpose                    | Key Points
-----------------|----------------------------|-------------
VPC              | Logical DC container       | 10.1.1.0/24 range
Subnet           | IP allocation segment      | /27 = 32 total, 27 usable
IGW              | Internet connectivity      | One per VPC, regional
Route Table      | Traffic routing rules      | One per subnet
Security Group   | Instance firewall          | State-aware, allow by default
NACL             | Subnet firewall            | Stateless, deny by default
EC2 Instance     | Virtual machine            | AMI + Instance Type + Networking
```

### Expert Insight

#### Real-World Application
```diff
+ Production VPCs use /16 or larger CIDR blocks
- Avoid 0.0.0.0/0 in inbound rules (security risk)
+ Use bastion hosts instead of direct SSH access
+ Implement proper subnetting for multi-tier applications
+ Reserve IP space for growth across availability zones
```

#### Expert Path
> 🧠 **Master VPC Architecture**: Study AWS Well-Architected Framework for VPC design patterns. Focus on hub-and-spoke models, transit gateways, and network segmentation best practices.

#### Common Pitfalls
> ⚠️ **Overlooking IGW Requirement**: Custom VPCs without IGW cannot reach internet
> 🚨 **Broad Security Rules**: "Allow all" inbound rules expose instances to attacks
> 🔒 **Single AZ Deployment**: All resources in one AZ risk total outage
> 💸 **Resource Cleanup**: Forgotten resources generate unexpected charges

#### Lesser-Known Facts
- IGW maintains consistent 1:1 NAT mapping regardless of stop/start cycles
- Default VPC exists in every region but differs from account defaults
- Network ACL modifications apply immediately without restart requirements
- AWS reserves `172.31.0.0/16` across all accounts for default VPC usageCounty

**AWS Free Tier Limits:**
- 750 hours EC2 t2.micro per month
- Must be terminated, not stopped to avoid charges
- 5GB storage, 15GB transfer included

**Hands-On Practice Recommendation:**
> 📝 Dedicate 4-6 hours weekly on sandbox environments. Master VPC creation, subnet design, and networking troubleshooting before advanced modules.
```

</details>