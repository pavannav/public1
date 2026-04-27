# 01 03 AWS Networking

<details open>
<summary><b>01 03 AWS Networking (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [AWS Networking Fundamentals](#aws-networking-fundamentals)
  - [IP Addressing and Subnetting](#ip-addressing-and-subnetting)
  - [AWS Console and Lab Access](#aws-console-and-lab-access)
- [Lab Demos](#lab-demos)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview
This introductory session covers the fundamentals of AWS Networking, with a focus on Amazon Virtual Private Cloud (VPC). The instructor and students introduce themselves, discussing their backgrounds and expectations for the course. The session provides an overview of the AWS console, VPC concepts, IP addressing basics (class A, B, C networks), subnetting, and the course structure across 22 modules. Key topics include VPC components like routetables, security groups, Network ACLs (NACLs), and Internet Gateways (IGWs). The class emphasizes practical hands-on labs using a free AWS account for basic exercises and a paid lab environment for advanced scenarios. Lab access, timing, and course deliverables like PPTs and online resources are also explained.

## Key Concepts/Deep Dive
### AWS Networking Fundamentals
Amazon Web Services (AWS) provides a global infrastructure for deploying applications securely and scalably. The AWS Management Console is the primary interface for interacting with AWS services, accessible via the web portal. Key services under **Network and Content Delivery** include:

- **VPC (Virtual Private Cloud)**: A logically isolated virtual network within the AWS cloud, mimicking an on-premises data center. It provides control over network configuration, security groups, and routetables.
- **Route 53**: A scalable Domain Name System (DNS) web service that translates domain names into IP addresses.
- **Direct Connect**: A dedicated, high-bandwidth connection between on-premises infrastructure and AWS.
- **Global Accelerator**: A service to improve application availability and performance for global users.
- **CloudFront**: A Content Delivery Network (CDN) for distributing content (e.g., videos, APIs) with low latency.

The instructor discusses AWS support for enterprise-grade connectivity, highlighting their experience with complex networks for global clients (e.g., 128 VPCs and 3,000 workloads across regions).

### IP Addressing and Subnetting
IP addressing forms the backbone of networking. AWS uses IPv4 and IPv6 for resource allocation.

#### IP Address Classes
- **Class A**: Range 1.0.0.0 to 126.255.255.255 (127.0.0.0/8 reserved for loopback). Suitable for very large networks with up to ~16 million hosts per network.
- **Class B**: Range 128.0.0.0 to 191.255.255.255. Ideal for medium-sized networks.
- **Class C**: Range 192.0.0.0 to 223.255.255.255. Best for smaller networks.

Reserved ranges for private (RFC 1918) use:
- Class A: 10.0.0.0/8
- Class B: 172.16.0.0/12
- Class C: 192.168.0.0/16

#### Subnetting Basics
Subnetting divides a larger network into smaller subnetworks for better management and security. Key concepts:
- **CIDR Notation**: E.g., /16 means first 16 bits for network ID, remaining for hosts.
- **Subnet Mask**: E.g., 255.255.0.0 for /16.
- **Usable IPs**: Reserved IPs (network ID, broadcast, DNS gateway) reduce available hosts. For a /27 (255.255.255.224), usable hosts per subnet: 32 (total) - 2 (network/broadcast) - 2 (reserved) = 28.
- **Magic Number**: For subnetting, calculate the increment: 256 - subnet mask (e.g., 256 - 240 = 16 for /28).

AWS reserves specific ranges for default VPCs in each region, e.g., US regions typically use 172.31.0.0/12 for automatic creation.

#### Default vs. Custom VPC
- **Default VPC**: Automatically created in AWS accounts, with pre-configured subnets, routetables, security groups, IGW, and NACLs. Convenient for quick deployments but limited customization (e.g., fixed CIDR 172.31.0.0/12 across regions).
- **Custom VPC**: User-defined for specific requirements (e.g., multi-tier architectures), allowing custom CIDRs, regions, and advanced networking setups.

### AWS Console and Lab Access
- **Dashboard Navigation**: Search for services or browse categories. Free resources (e.g., EC2 t2.micro for 750 hours/month) are available, but paid/terminated unused instances to avoid charges post-free tier.
- **Sandbox Lab**: Provided for class, accessible via incognito mode. Time-limited (4 behind schedule/hour slots for 6-12 students/day). Rules: Delete unused instances immediately.
- **Personal Free Tier Setup**: Students must create AWS accounts. Instructor shares business-plus access for advanced labs (e.g., Route 53).
- **Collaboration**: WhatsApp group for updates, lab access, and support. Sessions: Saturdays/Sundays, 11 AM IST (8 AM US ET).

## Lab Demos
No hands-on labs were performed in this transcript, as it was introductory. Future demos planned include:
- VPC Creation: Spin up custom VPC with specific C characteristic/CIDR (e.g., 10.1.0.0/24).
- Subnet and Route Configuration: Create private/public subnets, attach IGW, configure routetables for internet access.
- Security Setup: Apply security groups and NACLs; test connectivity (e.g., ping from EC2 instance).
- EC2 Instance Launch: Deploy VMs in subnets, verify routing via bastion host.
- CLI Commands: Use Bash for resource management.

Students encouraged to perform labs autonomously after instruction, sharing screenshots for feedback. Tools: AWS Management Console, Bash scripting, IP calculators.

In the transcript, one misspelling correction noted: "cript" at the start should be "transcript". No instances of "htp" or "cubectl" were found in this session transcript.

## Summary
### Key Takeaways
```diff
+ AWS Networking centers on VPC for isolated, scalable networks, combining on-premises concepts with cloud scalability.
+ Understand IP classes, subnetting (e.g., /12 for default VPC reservations), and AWS components (RouteTables, Security Groups, NACLs, IGW) to design secure architectures.
+ Master AWS Console navigation and lab tools (sandbox, free tier) for hands-on practice; avoid cost overruns by managing resources.
+ Course structure: 22 modules over ~10-12 weeks, covering VPC, hybrid connectivity (e.g., Transit Gateway, Direct Connect), security, and advanced services like CloudFront/Route 53.
+ Emphasis on practical knowledge: Labs build confidence for real-world jobs; theory alone insufficient for AWS roles.
- Misconfigurations (e.g., open security groups, unused EC2 instances) lead to security breaches or unexpected bills.
- Default VPC simplicity vs. custom VPC complexity: Trade ease for control in production environments.
```

### Quick Reference
- **AWS Free Tier Limits**: 750 hours EC2 t2.micro/month; monitor N. Virginia billing.
- **Common Commands**:
  - VPC Creation: `aws ec2 create-vpc --cidr-block 10.0.0.0/16`
  - Check Resources: `aws ec2 describe-vpcs`
  - Ping Test: Use from EC2 via Security Group allowance.
- **Lab Access**: Private Excel sheet via WhatsApp group; 4-hour slots, 24x7 access.
- **IP Calculations**: Magic Number = 256 - NetMask (e.g., /28: 16).

### Expert Insight
**Real-World Application**: In enterprise environments, VPC segmentation enables multi-tier (web/app/DB) deployments with micro-segmentation via tools like Kubernetes for internal restrictions. For global clients, use Transit Gateway for hub-and-spoke connectivities or Direct Connect for on-premises migration, ensuring governance compliance.

**Expert Path**: Build on legacy (Cisco/Juniper) experience by mastering AWS-specifics like CloudHub for multi-cloud connectivity. Pursue advanced certs (e.g., Advanced Networking Specialty); practice subnetting automation via Terraform for large-scale deployments (e.g., 128 VPCs globally).

**Common Pitfalls**: Overestimating default VPC simplicity leads to insecure defaults; poor subnetting causes IP waste or conflicts in hybrid setups. Ensure SLA awareness (e.g., DynamoDB 99.99%, not absolute downtime-free); always plan for multi-region redundancy despite failures.
</details>
