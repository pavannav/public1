# Section 3: Amazon VPC fundamentals

<details open>
<summary><b>Section 3: Amazon VPC fundamentals (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [3.1 Section Introduction](#31-section-introduction)
- [3.2 What is Amazon VPC](#32-what-is-amazon-vpc)
- [3.3 Scope of VPC with respect to AWS Account, Region & AZ](#33-scope-of-vpc-with-respect-to-aws-account-region--az)
- [3.4 VPC Building blocks - core components](#34-vpc-building-blocks---core-components)
- [3.5 VPC Addressing (CIDR)](#35-vpc-addressing-cidr)
- [3.6 VPC Route Tables](#36-vpc-route-tables)
- [3.7 IP Addresses - IPv4 vs IPv6, Private vs Public vs Elastic IP](#37-ip-addresses---ipv4-vs-ipv6-private-vs-public-vs-elastic-ip)
- [3.8 VPC Firewall - Security Group](#38-vpc-firewall---security-group)
- [3.9 VPC Firewall - Network Access Control List (NACL)](#39-vpc-firewall---network-access-control-list-nacl)
- [3.10 Default VPC](#310-default-vpc)
- [3.11 [Important] AWS Console UI Update](#311-important-aws-console-ui-update)
- [3.12 Hands On- Creating VPC with Public Subnet](#312-hands-on--creating-vpc-with-public-subnet)
- [3.13 Hands On- Add Private subnet](#313-hands-on--add-private-subnet)
- [3.14 NAT Gateway](#314-nat-gateway)
- [3.15 Hands On- Create NAT Gateway](#315-hands-on--create-nat-gateway)
- [3.16 NAT Gateway High Availability](#316-nat-gateway-high-availability)
- [3.17 NAT Instance (EC2 based NAT)](#317-nat-instance-ec2-based-nat)
- [3.18 New ! Regional NAT Gateway (Re-invent 2025)](#318-new--regional-nat-gateway-re-invent-2025)
- [3.19 Exam Essentials](#319-exam-essentials)

## 3.1 Section Introduction

### Overview
This section introduces the fundamentals of Amazon VPC, covering basic concepts necessary for AWS Advanced Networking Certification. Experienced developers may skip to advanced VPC features, while beginners should complete this section to understand core VPC concepts before proceeding.

### Key Concepts/Deep Dive
The section covers:
- Basic definition and purpose of VPC
- Relationship between AWS networking services (EC2, VPC, region, AZ)
- AWS services that reside inside vs outside VPC
- VPC addressing using CIDR notation
- Routing concepts including public and private subnets
- IP address types (IPv4, IPv6, private, public, elastic)
- VPC firewalls: security groups and network ACLs
- NAT concepts for outbound internet connectivity

> [!NOTE]
> The section includes multiple hands-on labs for practical understanding.

## 3.2 What is Amazon VPC

### Overview
Amazon VPC (Virtual Private Cloud) is a fundamental AWS networking service that provides a logically isolated section of the AWS cloud where you can launch AWS resources in a virtual network that you define.

### Key Concepts/Deep Dive
Amazon VPC is:
- A private, isolated section of AWS cloud
- A customizable virtual network in your AWS account
- Region and availability zone scoped
- Allows full control over network environment
- Enables terraform-like configuration of virtual networks

VPC creation involves:
- Defining IP address range (CIDR blocks)
- Configuring route tables
- Setting up network gateways
- Configuring subnets
- Implementing security measures

> [!IMPORTANT]
> VPC is regional in scope but spans multiple availability zones within a region.

## 3.3 Scope of VPC with respect to AWS Account, Region & AZ

### Overview
Understanding the hierarchical relationship between AWS accounts, regions, availability zones, and VPCs is crucial for proper network architecture design.

### Key Concepts/Deep Dive
**Hierarchical Structure:**
- **AWS Account**: Top level container (Global)
- **AWS Region**: Geographic area (e.g., us-east-1) - Default scope for many services
- **Availability Zone (AZ)**: Isolated location within a region (Physical data centers)
- **VPC**: Software-defined network within a region

**Service Placement Examples:**
- IAM users/policies: Account level
- Amazon Route 53: Global level
- Amazon S3 buckets: Regional level
- EC2 instances: AZ level
- VPC resources: Regional (spanning multiple AZs)

```diff
+ Logical Hierarchy: Account → Region → AZ → VPC Resources
```

This understanding helps in designing resilient, fault-tolerant architectures across multiple AZs.

## 3.4 VPC Building blocks - core components

### Overview
VPC consists of several core components that work together to create a complete networking environment.

### Key Concepts/Deep Dive
**Core VPC Components:**

1. **CIDR Block**: IP address range for the VPC
2. **Subnet**: Segment of VPC's IP address range in a specific AZ
3. **Route Table**: Set of rules for directing network traffic
4. **Internet Gateway**: Enables communication between VPC and internet
5. **NAT Gateway**: Provides outbound internet access for private subnets
6. **Security Group**: Instance-level firewall
7. **Network ACL**: Subnet-level firewall

**Additional Components:**
- **DHCP Options Set**: DNS servers, domain names for VPC
- **VPC Peering**: Connection between two VPCs
- **VPC Endpoints**: Private connection to AWS services
- **VPN Gateway**: Connection to on-premises networks

These components provide complete control over network architecture and security.

## 3.5 VPC Addressing (CIDR)

### Overview
VPC addressing uses Classless Inter-Domain Routing (CIDR) notation to define IP address ranges for VPCs and subnets.

### Key Concepts/Deep Dive
**CIDR Notation:**
- **Format**: IP address/prefix length (e.g., 10.0.0.0/16)
- **Prefix Length**: Number of bits for network portion
- **Host Bits**: Remaining bits for host addresses

**VPC CIDR Restrictions:**
- Minimum: /28 (16 addresses)
- Maximum: /16 (65,536 addresses)
- Cannot overlap with other VPCs in same region/account
- 172.31.0.0/16 blocked (Default VPC range)

**CIDR Calculations:**
- /24: 256 addresses (254 usable)
- /25: 128 addresses (126 usable)
- /26: 64 addresses (62 usable)

**Subnet Design Considerations:**
- Reserve IP addresses for AWS services
- Plan for growth
- Consider security isolation

```bash
# Example CIDR calculations
10.0.0.0/24 has 256 total IPs (0-255)
Usable IPs: 10.0.0.1 to 10.0.0.254
Network: 10.0.0.0
Broadcast: 10.0.0.255
```

## 3.6 VPC Route Tables

### Overview
VPC Route Tables contain rules (routes) that determine where network traffic is directed within your VPC and to external networks.

### Key Concepts/Deep Dive
**Route Table Basics:**
- **Main Route Table**: Default for new subnets
- **Custom Route Table**: User-defined routing rules
- **Routes**: Destination + Target combinations

**Route Components:**
- **Destination**: CIDR block or specific route
- **Target**: Where to send traffic (local, igw, nat, etc.)

**Common Routes:**
- Local route for intra-VPC traffic
- Internet Gateway route for public subnets
- NAT Gateway route for private subnet internet access
- VPC peering routes for cross-VPC traffic

**Route Table Association:**
- Each subnet associates with exactly one route table
- Multiple subnets can share same route table
- Explicit subnet association overrides main route table

**Route Priority:** Most specific route wins.

## 3.7 IP Addresses - IPv4 vs IPv6, Private vs Public vs Elastic IP

### Overview
AWS supports both IPv4 and IPv6 addressing schemes, with different types of IP addresses serving various purposes in VPC networking.

### Key Concepts/Deep Dive
**IP Address Types:**

**IPv4 vs IPv6:**
- **IPv4**: 32-bit addresses (e.g., 192.168.1.1)
- **IPv6**: 128-bit addresses (e.g., 2001:db8::/32)

**Private vs Public IPs:**
- **Private IPs**: Internal network addresses
  - RFC 1918 ranges: 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16
- **Public IPs**: Internet-routable addresses

**IPv4 Addressing in AWS:**
- **Private IPv4**: Auto-assigned from subnet range
- **Public IPv4**: Manual assignment to instances in public subnets
- **Elastic IP**: Static public IPv4 address

**IPv6 Addressing in AWS:**
- **Global Unicast Addresses**: Internet-routable
- **Link-local Addresses**: Internal communication
- VPC supports IPv6 but most services still use IPv4

**Elastic IP Characteristics:**
- **Static**: Doesn't change when instance stops/starts
- **Moveable**: Can be reassigned to different instances
- **Charges**: Billed when not associated with running instance

## 3.8 VPC Firewall - Security Group

### Overview
Security Groups act as virtual firewalls at the instance level, controlling inbound and outbound traffic based on rules you define.

### Key Concepts/Deep Dive
**Security Group Basics:**
- **Instance-level firewall**
- **Stateful**: Automatic return traffic allowance
- **Default behavior**: Allow all outbound, deny all inbound

**Rule Components:**
- **Type**: Protocol (TCP, UDP, ICMP)
- **Protocol**: TCP/UDP ports or ICMP types
- **Port Range**: Specific ports or ALL
- **Source/Destination**: IP ranges or security groups

**Security Group Rules:**
- **Inbound Rules**: Traffic coming to instance
- **Outbound Rules**: Traffic leaving instance
- **Reference other SG**: Dynamic rule updates

**Best Practices:**
- **Principle of Least Privilege**: Allow only necessary traffic
- **Use descriptive names**: For rule management
- **Group resources**: Common security requirements

**Limitations:**
- Default limit: 5 security groups per instance (configurable)
- Rules evaluated as "allow" only (implicit deny)

## 3.9 VPC Firewall - Network Access Control List (NACL)

### Overview
Network Access Control Lists (NACLs) provide an additional layer of security at the subnet level, acting as stateless firewalls.

### Key Concepts/Deep Dive
**NACL Basics:**
- **Subnet-level firewall**
- **Stateless**: Each packet evaluated independently
- **Default behavior**: Allow all inbound/outbound

**Key Differences from Security Groups:**
- **Stateless vs Stateful**: NACL is stateless
- **Level**: Subnet vs instance level
- **Processing Order**: NACL first, then Security Group

**NACL Rule Format:**
- **Rule Number**: Processing order (1-32766)
- **Type**: Allow/Deny
- **Protocol**: TCP/UDP/ICMP/ALL
- **Port Range**: Specific ports
- **Source CIDR**: Inbound source/Destination CIDR outbound

**Processing Logic:**
- Rules processed in ascending order
- First matching rule applies
- Explicit deny overrides allow
- No match = deny (default)

**Use Cases:**
- **Block specific IPs**: DDoS protection
- **Subnet isolation**: Between private subnets
- **Port blocking**: Specific service restrictions

## 3.10 Default VPC

### Overview
AWS creates a default VPC in each region automatically to simplify getting started with EC2 instances.

### Key Concepts/Deep Dive
**Default VPC Characteristics:**
- **Auto-created**: One per region
- **CIDR Block**: 172.31.0.0/16
- **Pre-configured**: Internet Gateway, route tables, subnets

**Default Subnets:**
- **One per AZ**: Automatically created in each AZ
- **Public subnets**: Auto-assigned public IPs
- **Auto-assign public IP**: Enabled by default

**Default Security Group:**
- **Open to world**: SSH (port 22), RDP (port 3389)
- **Self-referencing**: Instances in same SG can communicate

**When to Use Default VPC:**
- **Getting started**: Simple deployments
- **Development**: Non-production workloads
- **Quick testing**: Proof-of-concept

**Limitations:**
- **Fixed CIDR**: 172.31.0.0/16 cannot be changed
- **Limited customization**: Pre-defined settings
- **Region-specific**: Different across regions

## 3.11 [Important] AWS Console UI Update

### Overview
AWS regularly updates the console interface, which may affect navigation and feature availability in VPC sections.

### Key Concepts/Deep Dive
**Console Updates:**
- **Regular releases**: New features and UI changes
- **Region variations**: UI may differ by region
- **Feature flags**: New services roll out gradually

**Navigation Changes:**
- **VPC Dashboard**: Central access point
- **Reorganized menus**: Logical grouping of services
- **Wizard improvements**: Step-by-step creation processes

**Accommodation Strategies:**
- **Follow current docs**: AWS documentation updates
- **Check region**: Features may vary
- **Use APIs/CLI**: Consistent interface alternatives

## 3.12 Hands On- Creating VPC with Public Subnet

### Overview
This hands-on lab demonstrates creating a custom VPC with a public subnet capable of internet access.

### Key Concepts/Deep Dive

**Creation Steps:**

1. **Navigate to VPC Dashboard**
2. **Launch VPC Wizard**
3. **Configure VPC Settings:**
   - Name: my-vpc
   - IPv4 CIDR: 10.0.0.0/16

4. **Create Public Subnet:**
   - Name: public-subnet
   - AZ: us-east-1a
   - CIDR: 10.0.1.0/24

5. **Attach Internet Gateway**
6. **Configure Route Table:**
   - Associate with public subnet
   - Add route: 0.0.0.0/0 → igw-xxxxx

**Verification:**
- **Connectivity test**: Launch instance in public subnet
- **Public IP assignment**
- **Internet access confirmation**

```bash
# SSH into instance
ssh -i key.pem ec2-user@public-ip

# Test internet connectivity
ping google.com
```

## 3.13 Hands On- Add Private subnet

### Overview
This lab extends the previous setup by adding a private subnet to demonstrate network segmentation.

### Key Concepts/Deep Dive

**Addition Steps:**

1. **Create Private Subnet:**
   - Name: private-subnet
   - AZ: us-east-1b (different AZ for HA)
   - CIDR: 10.0.2.0/24

2. **Verify Route Table:**
   - Private subnet uses default route table
   - No internet route (local traffic only)

3. **Security Considerations:**
   - Separate AZ prevents single point of failure
   - No public IP assignment

**Testing Private Subnet:**
- Launch instance without public access
- Verify internal connectivity between subnets
- Confirm external access restriction

```bash
# From public instance, test connectivity
ping private-instance-ip
```

## 3.14 NAT Gateway

### Overview
NAT Gateway provides outbound internet access for instances in private subnets while maintaining security.

### Key Concepts/Deep Dive
**NAT Gateway Functionality:**
- **Network Address Translation**: Private to public IP translation
- **Outbound only**: Clients cannot initiate inbound connections
- **Port Address Translation (PAT)**: Multiple private IPs share one public IP

**Benefits:**
- **Security**: Private subnets remain isolated
- **Outbound access**: Software updates, API calls
- **Port reuse**: Different source ports for concurrent connections

**Architecture:**
- **Placement**: Public subnet
- **Elastic IP**: Static public address
- **Highly available**: Per AZ deployment

**Route Table Configuration:**
- Private subnet route table needs route to NAT Gateway
- Example: 0.0.0.0/0 → nat-xxxxx

## 3.15 Hands On- Create NAT Gateway

### Overview
This hands-on demonstration shows deploying a NAT Gateway for private subnet internet access.

### Key Concepts/Deep Dive

**Creation Process:**

1. **Allocate Elastic IP:**
   - EC2 → Elastic IPs → Allocate new address

2. **Create NAT Gateway:**
   - VPC → NAT Gateways → Create
   - Select public subnet
   - Assign Elastic IP

3. **Wait for State**: Available (takes 1-2 minutes)

4. **Update Route Table:**
   - Private subnet route table
   - Add route: 0.0.0.0/0 → NAT Gateway

**Testing:**
- Launch instance in private subnet
- Verify outbound connectivity
- Confirm inbound blocking

```bash
# From private instance
curl -I https://checkip.amazonaws.com
# Should show NAT Gateway Elastic IP
```

## 3.16 NAT Gateway High Availability

### Overview
NAT Gateway provides automatic high availability within an availability zone but requires cross-AZ deployment for region-level resilience.

### Key Concepts/Deep Dive
**Availability Zones:**
- **Single AZ resilience**: NAT Gateway is AZ-specific
- **Fault isolation**: Issues in one AZ don't affect others

**High Availability Strategies:**
- **Multiple NAT Gateways**: One per AZ
- **Private subnet distribution**: Spread across AZs
- **Route table configuration**: Each AZ's route table points to local NAT Gateway

**Costs and Considerations:**
- **Per-hour charges**: ~$0.045/hour
- **Data processing fees**: ~$0.045/GB
- **Elastic IP requirements**: One per NAT Gateway

**Best Practices:**
- **Cross-AZ design**: Always deploy in multiple AZs
- **Cost optimization**: Evaluate usage patterns
- **Monitoring**: CloudWatch metrics for traffic analysis

## 3.17 NAT Instance (EC2 based NAT)

### Overview
NAT Instance is an EC2-based alternative to NAT Gateway, offering more control but less automation.

### Key Concepts/Deep Dive
**NAT Instance Characteristics:**
- **EC2 instance**: Running NAT software
- **Manual configuration**: AMI selection and setup
- **Full control**: Instance type, monitoring, scaling

**Advantages over NAT Gateway:**
- **Cost effective**: For variable workloads
- **Port forwarding**: Advanced routing capabilities
- **Bursting**: Can handle traffic spikes (with limits)

**Limitations:**
- **Manual setup**: Bootstrap configuration required
- **Availability**: Single point of failure (without redundancy)
- **Maintenance**: Patching, updates required

**Use Cases:**
- **Cost optimization**: Steady, predictable traffic
- **Advanced networking**: Complex routing requirements
- **Legacy compatibility**: Custom configurations

## 3.18 New ! Regional NAT Gateway (Re-invent 2025)

### Overview
Re:invent 2025 introduced Regional NAT Gateway, providing region-wide NAT services with simplified architecture.

### Key Concepts/Deep Dive
**Key Features:**
- **Regional scope**: Single NAT Gateway serves entire region
- **Simplified deployment**: No per-AZ instances
- **Automatic scaling**: Handles variable traffic patterns
- **Multi-AZ redundancy**: Built-in high availability

**Benefits:**
- **Cost reduction**: Single gateway vs per-AZ
- **Simplified management**: Centralized configuration
- **Automatic failover**: No manual redundancy setup
- **Consistent performance**: Regional traffic optimization

**Implementation:**
- **Regional deployment**: Instead of AZ-specific
- **Route tables**: Single target for all private subnets
- **Scaling**: Automatic capacity adjustment

## 3.19 Exam Essentials

### Overview
Key concepts and configurations essential for AWS Advanced Networking Specialty certification exam.

### Key Concepts/Deep Dive
**Core VPC Concepts:**
- VPC boundaries and limitations
- CIDR planning and subnet design
- Route table configurations
- Security group vs NACL differences

**IP Addressing Knowledge:**
- IPv4 vs IPv6 allocation
- Private vs public IP types
- Elastic IP management

**NAT Concepts:**
- NAT Gateway vs NAT Instance
- High availability configurations
- Regional NAT Gateway features

**Network Architecture:**
- Multi-AZ designs
- Internet connectivity patterns
- Security layer implementations

**Exam Focus Areas:**
- Default VPC behavior
- Custom VPC creation steps
- Firewall rule configuration
- Troubleshooting connectivity issues

## Summary

### Key Takeaways
```diff
+ VPC is a regional isolation boundary within AWS account
+ CIDR blocks define VPC and subnet IP address ranges
+ Route tables control traffic flow within and outside VPC
+ Security Groups provide stateful instance-level protection
+ NACLs offer stateless subnet-level filtering
+ NAT Gateway enables private subnet outbound connectivity
+ Multi-AZ deployment ensures high availability
+ Default VPC simplifies getting started
```

### Quick Reference
**Common CIDR Blocks:**
- VPC: 10.0.0.0/16 (65,536 addresses)
- Subnet: 10.0.1.0/24 (256 addresses)

**Security Group Rule Syntax:**
```
Type: SSH
Protocol: TCP
Port Range: 22
Source: 0.0.0.0/0
```

**Route Table Entry:**
```
Destination: 0.0.0.0/0
Target: igw-xxxxx (for public)
Target: nat-xxxxx (for private)
```

### Expert Insight

**Real-world Application:**
- Design VPC architectures with multiple subnets (public/private) for web applications
- Implement bastion hosts for secure administrative access
- Use VPC endpoints to access AWS services privately
- Apply Defense in Depth security with multiple firewall layers

**Expert Path:**
- Master subnet sizing calculators for CIDR planning
- Understand AWS network limits and request increases
- Learn advanced networking features like Transit Gateway
- Practice hands-on labs in multiple regions

**Common Pitfalls:**
- Overlapping CIDR blocks between VPCs
- Incorrect route table associations
- Assuming Security Groups are sufficient (forgetting NACLs)
- NAT Gateway in wrong subnet (should be public)

**Lesser-Known Facts:**
- Reserved IP addresses in each subnet (AWS uses first 4, last)
- NACL rules processed in numerical order (lowest first)
- NAT Gateway can handle up to 55,000 concurrent connections
- IPv6 simplifies security group rules (no need for stateful returns)

</details>