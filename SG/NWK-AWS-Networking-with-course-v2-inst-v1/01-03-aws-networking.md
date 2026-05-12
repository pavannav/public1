# Session 1: AWS Networking Fundamentals

<details open>
<summary><b>Session 1: AWS Networking Fundamentals (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [Overview](#overview)
- [AWS Console Introduction](#aws-console-introduction)
- [AWS Services Overview](#aws-services-overview)
- [Networking Fundamentals](#networking-fundamentals)
- [VPC Components and Architecture](#vpc-components-and-architecture)
- [Course Modules and Structure](#course-modules-and-structure)
- [Lab Environment Setup](#lab-environment-setup)
- [Summary](#summary)

## Overview
This inaugural session introduces participants to AWS networking fundamentals, covering basic networking concepts, AWS console navigation, VPC architecture, and the comprehensive course roadmap. The instructor establishes the interactive learning environment, introduces course participants, and lays the foundation for hands-on AWS networking training.

## AWS Console Introduction

### Accessing AWS Management Console
The AWS Management Console serves as the primary web-based interface for managing AWS services. Key access points include:

- **Login Methods**: Username/password authentication or IAM user credentials
- **Account Information**: Account ID, IAM username, and role permissions displayed in the console header
- **Dashboard Customization**: Ability to customize the dashboard layout and frequently used services

### Console Navigation Basics
- **Services Menu**: Centralized access to all AWS services organized by categories:
  - Compute (EC2, Lambda, etc.)
  - Storage (S3, EBS, etc.)
  - Networking & Content Delivery (VPC, CloudFront, Route 53, etc.)
- **Region Selection**: Services are region-specific, with default and custom VPCs available per region
- **Resource Management**: Region-based resource organization and management

## AWS Services Overview

### Core Networking Services
The AWS networking ecosystem includes several critical services:

| Service | Purpose | Key Features |
|---------|---------|-------------|
| **VPC** | Virtual Private Cloud | Isolated network environment in AWS |
| **Route 53** | DNS Service | Domain name resolution and management |
| **CloudFront** | CDN Service | Global content distribution |
| **Direct Connect** | Physical connectivity | Dedicated network connection to AWS |
| **Global Accelerator** | Traffic optimization | Improved application performance |

### Compute and Storage Integration
While networking is the focus, understanding integration with other services is crucial:
- **EC2 Instances**: Virtual machines requiring networking components
- **Elastic Load Balancing**: Traffic distribution across multiple instances
- **Security Services**: Integration with networking for comprehensive security

## Networking Fundamentals

### IP Address Classes
Understanding IP address classes forms the foundation of subnetting and network design:

| Class | Range | Default Subnet Mask | Network Bits | Host Bits | Max Networks | Max Hosts/Network |
|-------|-------|---------------------|--------------|-----------|--------------|-------------------|
| A | 1-126 | 255.0.0.0 (/8) | 8 | 24 | 126 | 16,777,214 |
| B | 128-191 | 255.255.0.0 (/16) | 16 | 16 | 16,384 | 65,534 |
| C | 192-223 | 255.255.255.0 (/24) | 24 | 8 | 2,097,152 | 254 |

### Special IP Ranges
- **127.0.0.0/8**: Reserved for loopback (localhost)
- **10.0.0.0/8**: Private Class A range
- **172.16.0.0/12**: Private Class B range
- **192.168.0.0/16**: Private Class C range

### Subnetting Fundamentals
Key subnetting concepts covered include:

- **CIDR Notation**: Network/prefix format (e.g., 10.0.0.0/16)
- **Subnet Mask Calculation**: Binary conversion and boundary determination
- **Magic Number**: 256 - subnet mask value for increment calculation
- **Network Boundaries**: First IP (network), last IP (broadcast), usable range

### Practical Subnetting Example
For a requirement of 14 usable IPs:
- Required hosts: 14
- Network bits needed: 4 (16 total IPs: 2^4 = 16)
- Subnet mask: 255.255.255.240 (/28)
- Network increment: 16 (256 - 240)
- Usable IPs: 14 (16 - 2 for network/broadcast)

## VPC Components and Architecture

### VPC Core Components

#### 1. Route Tables
Route tables define network traffic paths within the VPC:
- **Function**: Determine next-hop destinations for traffic routing
- **Components**: Destination networks and associated targets (IGW, NAT Gateway, VPC endpoints)
- **Default Behavior**: Local routing within VPC automatically configured

#### 2. Security Groups (Layer 4)
Security groups provide instance-level security:
- **Stateful Filtering**: Automatic return traffic allowance
- **Rules**: Allow/deny based on source/destination, protocol, and port ranges
- **Attachment**: Applied at Elastic Network Interface (ENI) level
- **Scope**: Controls instance-to-instance and external communications

#### 3. Network Access Control Lists (NACLs) (Layer 3)
NACLs provide subnet-level security:
- **Stateless Filtering**: Manual configuration for return traffic
- **Rules**: Numbered rules processed in order
- **Scope**: Applied at subnet level
- **Default**: Allow all inbound/outbound unless explicitly denied

#### 4. Internet Gateway (IGW)
IGW enables internet connectivity for VPC resources:
- **Function**: Bidirectional traffic translation between private and public addresses
- **Attachment**: Attached to VPC (not individual subnets)
- **NAT Functionality**: Source NAT for outbound, destination NAT for inbound

### VPC Types

#### Default VPC
AWS automatically creates default VPCs in each region:
- **CIDR Block**: 172.31.0.0/16
- **Components**: Pre-configured route table, IGW, security group, and NACL
- **Purpose**: Immediate resource deployment without custom networking setup
- **Limitations**: Fixed configuration, not suitable for complex architectures

#### Custom VPC
User-defined VPCs for specific requirements:
- **Custom CIDR**: Flexible IP address ranges
- **Component Control**: Manual configuration of all networking components
- **Best Practices**: Follow AWS subnetting recommendations (/16 to /28 ranges)

### NAT Gateway vs. NAT Instance
Two approaches for private subnet internet access:

#### NAT Gateway (Recommended)
```bash
# AWS CLI command to create NAT Gateway
aws ec2 create-nat-gateway \
    --subnet-id subnet-12345678 \
    --allocation-id eipalloc-12345678
```
- Managed service by AWS
- High availability within AZ
- Automatic scaling
- No instance management required

#### NAT Instance (Legacy)
- EC2 instance configured as NAT device
- Manual configuration required
- Single point of failure unless configured for redundancy

## Course Modules and Structure

### Comprehensive Module Overview

#### Module 1: VPC Fundamentals and Features
- VPC creation and configuration
- Subnet design and implementation
- Route table management
- Security group and NACL configuration
- Internet Gateway and NAT Gateway setup

#### Module 2: VPC Private Connectivity
- VPC Peering for inter-VPC communication
- VPC Gateway Endpoints for AWS service access
- VPC Interface Endpoints for private AWS API access
- AWS PrivateLink for service sharing

#### Module 3: AWS Transit Gateway
- Multi-VPC connectivity management
- Hybrid network architectures
- Transit Gateway attachments and route tables
- VPN and Direct Connect integration

#### Module 4: Hybrid Networking
- Site-to-Site VPN configuration
- AWS Direct Connect setup
- Client VPN for remote access
- Multi-region connectivity patterns

#### Module 5: Advanced Services
- AWS Cloud WAN for global networking
- Route 53 for DNS management
- CloudFront CDN configuration
- Global Accelerator for performance optimization

#### Module 6-22: Additional Modules
- VPC traffic monitoring and troubleshooting
- Network security services
- Container networking (EKS)
- Governance and management
- Performance optimization

### Lab Environment Setup

#### Accessing Sandbox Environment
```bash
# Navigate to sandbox environment
# 1. Access cloud platform URL
# 2. Use provided credentials:
#    Username: cloud_user
#    Password: [provided via secure channel]
#    URL: [lab environment URL]
```

#### Lab Access Guidelines
- **Duration**: 4-hour lab sessions with automatic cleanup
- **Scheduling**: Slot-based access (6 slots per 24-hour period)
- **Resource Management**: Important cleanup practices:
  - Stop instances to avoid charges
  - Terminate unused resources
  - Monitor resource usage

#### Free Tier Account Setup
```bash
# Create AWS Free Tier Account
# 1. Visit aws.amazon.com/free
# 2. Complete registration process
# 3. Set up billing alerts
# 4. Enable MFA for root account
# 5. Create IAM users for daily operations
```

### Course Administration
- **Communication**: WhatsApp group for course coordination
- **Homework Submission**: Screenshot submissions for lab completion verification
- **24/7 Lab Access**: Extended access for completing assignments
- **Certification Support**: Exam tips and practice materials

## Summary

### Key Takeaways
```diff
+ Core AWS networking foundation established through VPC components understanding
+ Practical subnetting skills developed with IP address class mastery
+ AWS console navigation proficiency achieved for service management
+ Comprehensive course roadmap provides clear advanced networking path
+ Hands-on lab environment configured for practical AWS networking learning
- Legacy networking knowledge alone insufficient - requires cloud-specific understanding
- Default VPC configurations may not meet production security requirements
- Improper resource cleanup can lead to unexpected AWS charges
```

### Quick Reference
**Key AWS Networking Services:**
- **VPC**: Virtual Private Cloud for network isolation
- **IGW**: Internet Gateway for public connectivity
- **NAT Gateway**: Managed NAT service for private subnet internet access
- **Security Groups**: Instance-level stateful firewalls
- **NACLs**: Subnet-level stateless firewalls
- **Route Tables**: Define traffic routing paths

**Essential Commands:**
```bash
# Check AWS CLI configuration
aws configure list

# List VPCs
aws ec2 describe-vpcs

# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16
```

**IP Address Classes:**
- Class A: 1-126 (/8)
- Class B: 128-191 (/16)
- Class C: 192-223 (/24)

### Expert Insights

#### Real-world Application
> [!IMPORTANT]
> Enterprise network architects leverage these VPC fundamentals to design scalable, secure cloud infrastructures. Organizations migrating from on-premises to AWS must understand VPC components to maintain security compliance while enabling application connectivity. The transit gateway concept becomes crucial for managing complex multi-account, multi-region architectures common in large enterprises.

#### Expert Path
Systematic progression through AWS networking certification path:
1. **Foundation**: Master basic subnetting and VPC components
2. **Hands-on Practice**: Complete all 22 module labs thoroughly
3. **Hybrid Networking**: Focus on VPN, Direct Connect, and transit gateway implementations
4. **Advanced Services**: Deep dive into Cloud WAN, Route 53, and global networking services
5. **Production Experience**: Apply knowledge in real AWS environments with monitoring and troubleshooting

#### Common Pitfalls
> [!NOTE]
- **Resource Cost Management**: Forgetting to terminate lab resources leads to unexpected charges - always clean up after sessions
- **Security Group Misconfiguration**: Overly permissive rules can expose resources to unauthorized access
- **Subnet Planning**: Poor subnet design can limit future scalability and complicate network management
- **Route Table Complexity**: Improper routing can isolate resources or create security vulnerabilities
- **Default VPC Reliance**: Production workloads require custom VPC configurations for compliance and security

</details>