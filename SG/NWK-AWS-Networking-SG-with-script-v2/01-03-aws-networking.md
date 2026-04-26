# Session 01: AWS Networking Fundamentals and Course Introduction

## Overview

This introductory session covers the basics of networking concepts, AWS services overview, default VPC components, and course logistics. The instructor introduces himself with 14 years of experience in AWS and on-premises, highlights the course structure (22 modules over 3 months), explains lab access, and review IP addressing, subnetting, AWS computing services, networking services, and VPC default configurations.

## Course Introduction and Participant Background

### Instructor Background
- **Experience**: 14 years in cloud (AWS) and on-premises with dual CCIE
- **Certifications**: Practitioner, Solutions Architect Associate (expired), Advanced Networking Specialty, Security Specialty, Azure solutions architect expert and administrator
- **Current Role**: Supporting live AWS projects for US and European clients

### Participant Profiles
1. **Michael (US-based)**: Advanced Networking and Security interest, has Solutions Architect Associate, experienced in AWS primarily
2. **Acharia**: Learner, undergoing introductions
3. **Omar/Usman**: Network Senior Engineer with AWS foundational knowledge
4. **Others**: Gangadar, Manoj, Nitin, Vive/Puja, Bik, Itsri

### Course Expectations
- **Training Duration**: 3 months (approx. 90-120 days), 16-18 modules
- **Frequency**: Weekends (Saturday/Sunday), 2-hour sessions (11 AM - 1 PM IST)
- **Depth**: In-depth networking theory + hands-on labs
- **Labs**: AWS Sandbox (4-hour slots shared among candidates), paid services like Route 53 in instructor's business account
- **Outcome**: Mastery in AWS advanced networking, ability to clear certification, perform live projects, handle interviews and client presentations

## Basic Networking Concepts

### IP Address Classes
- **Class A**: 1-127 (private: 10.0.0.0/8)
- **Class B**: 128-191 (private: 172.16.0.0/12)
- **Class C**: 192-224 (private: 192.168.0.0/16)

### Private IP Ranges
✅ Commonly used private ranges in AWS and networking.

### Subnetting Fundamentals
- **Basic Calculation**: Host bits = 32 - subnet mask bits
- **Example**: 10.0.0.0/27 has 5 host bits (32 IPs), 4 reserved, 28 usable
- **IP Assignments in VPC Subnets**: 
  - .0: Network
  - .1: VPC Router
  - .2: DNS (AmazonProvidedDNS)
  - .3: Future use
  - .4 onwards: VM assignments
  - Last: Broadcast

### Packet Structure
- **Key Headers**: Source IP, Destination IP, Destination Port
- **Notes**: No URL in packet (DNS resolves URL to IP)

## AWS Services Overview

### Computing Services
- **EC2**: Virtual Machines
- **EBS**: Block storage for VM backups
- **EIP**: Elastic public IPs (paid if not attached to running EC2)
- **AMI**: Amazon Machine Images (templates)
- **Free Tier**: 750 hours/month, t2.micro, terminates after 12 months

### Networking and Content Delivery
- **Major Services**: VPC, Route 53, Global Accelerator, Direct Connect, CloudFront
- **Ridgen from Associate**: API Gateway, etc.

### Other Categories
- Analytics, Application Integration, Blockchain, Business Apps, Cost Management, Containers (EKS not covered), Database, Developer Tools, End User Computing, Front-end Web/Mobile, Gaming, IoT, Machine Learning, Management/Governance, Media, Migration/Transfer, Mobile, Quantum, Robotics, Satellite, Security/Compliance, Serverless, Storage

## Default VPC and AWS Components

### Default VPC Creation
- **Auto-created per region**: One default VPC per region
- **Default Subnets**: Six subnets across three Availability Zones (AZs)
- **CIDR**: 172.31.0.0/16 (reserved AWS-wide for default VPCs)
- **Features**: 
  - Internet Gateway (IGW)
  - Route Table with IGW route
  - Security Group (auto-created, EC2 association)
  - Network ACL (auto-created)

### Core VPC Components
1. **Route Table**
   - Stores routes: Destination → Next Hop
   - Managed by implicit/explicit association

2. **Security Group**
   - Layer 4 (transport): Source IP, Dest IP, Port
   - Stateful firewall
   - Instance-level (NIC attachment)

3. **Network ACL**
   - Layer 3 (network): IP-based rules
   - Subnet-level, stateless
   - Default: Allow all inbound/outbound

4. **Internet Gateway (IGW)**
   - Attach to VPC for internet connectivity
   - Public IP routing

### Custom vs. Default VPC
- Custom: Manual component creation
- Default: All components auto-provisioned

## Course Structure and Lab Access

### Module Outline (22 Modules)
1. VPC Fundamentals & Features
2. VPC Additional Features
3. VPC Network Performance Optimization
4. VPC Traffic Monitoring & Troubleshooting
5. VPC Private Connectivity: VPC Peering
6. VPC Gateway Endpoint
7. VPC Interface Endpoint & PrivateLink
8. Transit Gateway
9. AWS Client VPN
10. AWS Site-to-Site VPN
11. AWS Direct Connect
12. AWS Cloud WAN
13. CloudFront
14. Elastic Load Balancing
15. Route 53
16. AWS Network Security & Services
17. EKS (Elastic Kubernetes Service - Networking)
18. AWS Management & Governance
19. Hybrid Networking
20. VPC Sharing
21. VPC Private NAT Gateway
22. Architecture Workshop & Extra AWS Networking Services (e.g., AppStream)

### Lab Environment
- **Sandbox**: Free 4-hour slots (shared: 24 hours/divided by 6 users = 4 hours each)
- **Paid Labs**: Route 53 in instructor's business+ account
- **Access**: Via incognito/private mode
- **Monitoring**: Candidates screenshot outputs for verification
- **24/7 Availability**: Within time slots (max 4 hourscontinuous)

### WhatsApp Group
- For chat, support, lab scheduling
- Link shared post-session

## Session Wrap-up and Next Module
- Preview: Module 1 (VPC Fundamentals)
- Hands-on: Create VPC, subnet, IGW, route table, security group, EC2 VM, test internet connectivity

## Summary

### Key Takeaways
```diff
+ AWS Advanced Networking covers backbone services (VPC, Transit Gateway, Direct Connect) beyond Associate-level features
+ Default VPC uses 172.31.0.0/16 CIDR globally; custom VPCs use other private ranges
+ Course emphasizes 100% practical knowledge with hands-on labs for certification and career readiness
+ VGW, DX, TGW enable hybrid connectivity between AWS and on-premises/other clouds
- IP subnetting and networking fundamentals are critical for AWS deployments
- Labs require precise resource management due to cost implications
```

### Expert Insight
#### Real-World Application
In production environments, VPC design involves multi-AZ subnets with IGW for public access and NAT for private; Transit Gateway connects multiple VPCs/accounts for complex networks like microservices; Direct Connect provides low-latency, high-bandwidth links for large data migrations.

#### Expert Path
Master subnetting calculations for efficient IP usage; study BGP/OSPF for hybrid routing; practice multi-VPC architectures with TGW for scalability; focus on cost optimization (e.g., EIP charges) and security (layered SG/NACL).

#### Common Pitfalls
- Over-estimating IP needs wastes ranges; always calculate host bits carefully
- Forgetting TGW transitivity; route tables must be configured post-pairing
- Exceeding free tier: Monitor running instances to avoid charges
- Assuming default VPC presence; verify regional availability

Lesser-known AWS Networking: Cloud WAN provides managed SD-WAN; AWS Design for Operations uses Control Tower for governance; WorkSpaces networking differs from EC2, using DirectConnect for low-latency desktop access.
