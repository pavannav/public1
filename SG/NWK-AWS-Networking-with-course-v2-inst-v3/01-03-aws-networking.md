<details open>
<summary><b>01 AWS Networking (KK-CS45-script-v2-Inst-v3)</b></summary>

# Session 01: AWS Networking Fundamentals

## Table of Contents
- [Introduction to AWS Networking](#introduction-to-aws-networking)
- [Understanding CIDR Blocks](#understanding-cidr-blocks)
- [Virtual Private Cloud (VPC)](#virtual-private-cloud-vpc)
- [Subnets](#subnets)
- [Security Groups](#security-groups)
- [Network Access Control Lists (NACLs)](#network-access-control-lists-nacls)
- [Internet Gateway](#internet-gateway)
- [Route Tables](#route-tables)
- [NAT Gateway](#nat-gateway)
- [VPC Peering](#vpc-peering)
- [VPC Endpoints](#vpc-endpoints)
- [Summary](#summary)

<a id="introduction-to-aws-networking"></a>
## Introduction to AWS Networking

### Overview
AWS Networking forms the backbone of cloud infrastructure, providing secure, scalable, and flexible network connectivity for resources. Unlike traditional networking with physical hardware, AWS offers software-defined networking through the EC2-VPC platform, enabling rapid deployment, isolation, and customization of network environments.

### Key Concepts / Deep Dive

#### Core Networking Components
AWS networking revolves around several fundamental components that work together to create a secure and efficient cloud network:

- **Connectivity**: The ability for resources to communicate with each other and external networks
- **Security**: Multiple layers of access control and traffic filtering
- **Scalability**: Ability to dynamically adjust network configuration as needs change
- **Isolation**: Complete separation of network environments for security and compliance

#### Networking Protocol Stack
AWS leverages standard networking protocols that form the foundation of IP networking:

```diff
+ Layer 3 (Network): IP Addressing and Routing
+ Layer 4 (Transport): TCP/UDP for connection and data delivery
! Layer 2 (Data Link): MAC addresses and physical network interfaces
```

### Understanding IPs and Networking

#### IPv4 vs IPv6
AWS supports both IP version protocols, with IPv4 being the default:

**IPv4 Characteristics:**
- 32-bit addressing scheme
- 4.3 billion unique addresses
- Dotted decimal notation (e.g., 192.168.1.1)
- NAT required for private networks

**IPv6 Characteristics:**
- 128-bit addressing scheme
- Virtually unlimited addresses
- Hexadecimal notation with colons
- Built-in security features
- No need for NAT in most scenarios

> [!NOTE]
> IPv6 adoption is growing in AWS due to address exhaustion concerns.

#### IP Address Ranges

**Public IP Addresses:**
- Routable over the internet
- Unique globally
- Can be static or dynamic

**Private IP Addresses (RFC 1918):**
- Not routable over the internet
- Reusable across different networks
- Three reserved ranges:
  - Class A: 10.0.0.0/8 (10.0.0.0 - 10.255.255.255)
  - Class B: 172.16.0.0/12 (172.16.0.0 - 172.31.255.255)
  - Class C: 192.168.0.0/16 (192.168.0.0 - 192.168.255.255)

<a id="understanding-cidr-blocks"></a>
## Understanding CIDR Blocks

### Overview
Classless Inter-Domain Routing (CIDR) is a method for allocating IP addresses and routing Internet Protocol packets more efficiently than the older classful addressing scheme.

### Key Concepts / Deep Dive

#### CIDR Notation
CIDR blocks are expressed as `base_address/prefix_length`

- **Base Address**: The starting IP address of the block
- **Prefix Length**: Number of bits reserved for network portion (Subnet Mask)
- **Host Bits**: Remaining bits for individual host addresses

#### Subnet Mask Conversion
Understanding the relationship between CIDR notation and subnet masks:

| CIDR | Subnet Mask | Total Addresses | Usable Hosts |
|------|-------------|----------------|--------------|
| /24  | 255.255.255.0 | 256 | 254 |
| /25  | 255.255.255.128 | 128 | 126 |
| /26  | 255.255.255.192 | 64 | 62 |
| /27  | 255.255.255.224 | 32 | 30 |
| /28  | 255.255.255.240 | 16 | 14 |
| /29  | 255.255.255.248 | 8 | 6 |
| /30  | 255.255.255.252 | 4 | 2 |

#### Calculating Available Addresses
```diff
+ Total Addresses = 2^(32 - prefix_length)
+ Usable Hosts = Total Addresses - 2 (subtract network and broadcast addresses)
+ Example: /24 = 2^8 = 256 total, 254 usable
```

<a id="virtual-private-cloud-vpc"></a>
## Virtual Private Cloud (VPC)

### Overview
A Virtual Private Cloud (VPC) is a virtual network dedicated to your AWS account. It provides complete control over the virtual networking environment, including selection of IP address ranges, creation of subnets, and configuration of route tables and network gateways.

### Key Concepts / Deep Dive

#### VPC Architecture
VPCs are isolated network environments within AWS that enable:

- **Logical Isolation**: Complete network separation from other accounts
- **IP Address Control**: Custom IP address ranges
- **Resource Organization**: Grouping of EC2 instances, RDS databases, etc.
- **Multi-tier Applications**: Support for web, application, and database tiers

#### Default vs Custom VPCs

**Default VPC:**
- Created automatically in each region
- Pre-configured with subnets, security groups, and internet access
- CIDR: 172.31.0.0/16
- Suitable for simple applications

**Custom VPC:**
- Manually configured for specific requirements
- Precise control over networking components
- Required for production environments
- Custom CIDR ranges

#### VPC Creation Workflow
```diff
! 1. Choose Region → 2. Define CIDR Block → 3. Create VPC → 4. Configure Subnets → 5. Setup Routing
```

<a id="subnets"></a>
## Subnets

### Overview
Subnets are subdivisions of a VPC's IP address range that enable the segmentation of resources across multiple Availability Zones and provide different levels of security and access control.

### Key Concepts / Deep Dive

#### Public vs Private Subnets

**Public Subnets:**
- Direct internet connectivity
- Resources can receive inbound traffic from the internet
- Route table includes route to Internet Gateway
- Used for web servers, load balancers

**Private Subnets:**
- No direct internet connectivity
- Resources cannot receive inbound traffic from the internet
- No route to Internet Gateway in route table
- Used for databases, application servers

#### Subnet Configuration
Key considerations when designing subnets:

```yaml
Subnet Configuration:
  vpc_id: vpc-xxxxxxxxxxxxxxxxx
  cidr_block: 10.0.1.0/24
  availability_zone: us-east-1a
  tags:
    - Name: public-subnet-1a
      Type: Public
```

#### Network Address Translation (NAT)
For private subnets requiring outbound internet access:

```diff
+ NAT Gateway: AWS managed NAT service in public subnet
+ NAT Instance: EC2 instance configured as NAT gateway
! Enables private resources to initiate outbound connections while preventing inbound traffic
```

<a id="security-groups"></a>
## Security Groups

### Overview
Security Groups act as virtual firewalls for your instances, controlling inbound and outbound traffic at the instance level. They are stateful, meaning that return traffic is automatically allowed.

### Key Concepts / Deep Dive

#### Security Group Rules
Security groups define allowed traffic through rules:

**Inbound Rules:**
- Source (IP ranges, security groups, or prefix lists)
- Protocol (TCP, UDP, ICMP, or ALL)
- Port range
- Description for documentation

**Outbound Rules:**
- Default: Allow all outbound traffic
- Destination (IP ranges, security groups, or prefix lists)
- Protocol and port ranges

#### Stateful Behavior
```diff
+ Stateful: Return traffic automatically allowed
+ Example: If inbound rule allows TCP port 80, responses on port 80 are automatically permitted
- Stateless: Each direction must be explicitly configured
```

#### Best Practices
- **Least Privilege**: Only open necessary ports
- **Named Rules**: Use descriptive names for rules
- **Regular Audits**: Review and update rules periodically

> [!IMPORTANT]
> Security groups are associated with ENIs (Elastic Network Interfaces), not directly with instances.

<a id="network-access-control-lists-nacls"></a>
## Network Access Control Lists (NACLs)

### Overview
Network ACLs are an optional layer of security that acts as a firewall for controlling traffic in and out of subnets. Unlike security groups, NACLs are stateless and evaluate rules in order.

### Key Concepts / Deep Dive

#### NACL Characteristics
NACLs provide subnet-level filtering with specific behaviors:

- **Stateless**: Both inbound and outbound traffic must be explicitly allowed
- **Rule Ordering**: Rules are processed in numerical order (lowest number first)
- **Deny by Default**: Traffic is denied unless explicitly permitted
- **Subnet Association**: Apply to entire subnets, not individual instances

#### Rule Configuration
NACL rules include:

```yaml
NACL Rule Format:
  rule_number: 100
  rule_action: allow/deny
  protocol: tcp/udp/icmp/all
  port_range: 80-80 or all
  source/destination: 0.0.0.0/0 (CIDR notation)
  description: "Allow HTTP traffic"
```

#### Security Groups vs NACLs Comparison

| Feature | Security Groups | Network ACLs |
|---------|-----------------|--------------|
| Level | Instance | Subnet |
| State | Stateful | Stateless |
| Rule Order | Not Applicable | Sequential |
| Default | Allow All Outbound | Allow All Traffic |
| Association | ENI (Instance) | Subnet |
| Response Traffic | Auto-allowed | Must be explicit |

<a id="internet-gateway"></a>
## Internet Gateway

### Overview
An Internet Gateway (IGW) enables communication between instances in your VPC and the internet. It serves as a bridge between your VPC and external networks.

### Key Concepts / Deep Dive

#### IGW Functionality
Internet Gateways provide:

- **Bidirectional Traffic**: Enables inbound and outbound internet connectivity
- **IP Address Translation**: Performs NAT for instances with public IPs
- **Scalability**: Automatically scales to handle traffic demands
- **Availability**: Highly available within the region

#### IGW Configuration
IGWs are attached to VPCs and don't require maintenance:

```yaml
Internet Gateway Configuration:
  vpc_id: vpc-xxxxxxxxxxxxxxxxx
  internet_gateway_id: igw-xxxxxxxxxxxxxxxxx
  state: attached
```

#### Internet Connectivity Options
Different ways to enable internet access:

1. **Public Subnet + IGW**: Direct access with public IP
2. **Private Subnet + NAT Gateway**: Outbound-only access through NAT
3. **Private Subnet + NAT Instance**: Customizable NAT using EC2 instance

<a id="route-tables"></a>
## Route Tables

### Overview
Route tables contain a set of rules (routes) that determine where network traffic is directed. Each subnet in your VPC must be associated with a route table.

### Key Concepts / Deep Dive

#### Route Table Structure
Routes define network destinations and targets:

```yaml
Route Example:
  destination: 0.0.0.0/0
  target: igw-xxxxxxxxxxxxxxxxx
  status: active
```

#### Route Table Types

**Main Route Table:**
- Default route table for the VPC
- Automatically assigned to new subnets
- Can be customized

**Custom Route Tables:**
- Created for specific routing requirements
- Manually associated with subnets
- Flexible route destinations

#### Common Route Targets
```diff
+ igw-xxxxx: Internet Gateway
+ nat-xxxxx: NAT Gateway
+ pcx-xxxxx: VPC Peering Connection
+ vgw-xxxxx: Virtual Private Gateway
+ local: Within VPC
+ vpce-xxxxx: VPC Endpoint
```

#### Subnet Association
Managing which subnets use specific route tables:

- **Explicit Association**: Explicitly associate route table with subnet
- **Implicit Association**: Subnets inherit from main route table if not explicitly associated

<a id="nat-gateway"></a>
## NAT Gateway

### Overview
NAT Gateways enable instances in private subnets to connect to the internet while preventing inbound connections from the internet. They provide a managed, highly available NAT service.

### Key Concepts / Deep Dive

#### NAT Gateway Benefits
Key advantages over NAT instances:

- **Managed Service**: AWS handles scaling and maintenance
- **High Availability**: Automatically fault-tolerant within AZ
- **Performance**: Optimized for high throughput
- **Auto Scaling**: Handles traffic spikes automatically

#### NAT Gateway Configuration
Deployment considerations:

```yaml
NAT Gateway Setup:
  subnet_id: subnet-xxxxxxxxxxxxxxxxx (public subnet)
  allocation_id: eipalloc-xxxxxxxxxxxxxxxxx
  connectivity_type: public
  tags:
    Name: nat-gateway-1a
```

#### Cost Components
NAT Gateway pricing includes:

- **Hourly Rate**: Per NAT Gateway per hour
- **Data Processing**: Per GB of data processed
- **Data Transfer**: Regional data transfer costs

<a id="vpc-peering"></a>
## VPC Peering

### Overview
VPC Peering enables you to connect two VPCs privately using the AWS network infrastructure. This allows resources in different VPCs to communicate with each other as if they were on the same network.

### Key Concepts / Deep Dive

#### Peering Characteristics
VPC peering connections are:

- **Private**: Traffic stays within AWS network
- **No Transitive Routing**: Cannot route through peered VPCs
- **Cross-Region Support**: Can peer VPCs in different regions
- **Cross-Account Support**: Can peer VPCs owned by different accounts

#### Peering States
Connection lifecycle:

```diff
+ pending-acceptance: Waiting for acceptor to accept
+ active: Connection established and ready
+ rejected: Connection rejected by peer
+ expired: Connection request expired
+ failed: Connection request failed
+ deleted: Connection deleted
```

#### Route Table Updates Required
After establishing peering, update route tables:

```yaml
Peering Route:
  destination: 10.1.0.0/16 (peer VPC CIDR)
  target: pcx-xxxxxxxxxxxxxxxxx (peering connection)
```

> [!WARNING]
> Ensure security groups allow traffic between peered VPCs.

<a id="vpc-endpoints"></a>
## VPC Endpoints

### Overview
VPC Endpoints enable you to privately connect your VPC to supported AWS services without requiring an internet gateway, NAT device, VPN connection, or AWS Direct Connect connection.

### Key Concepts / Deep Dive

#### Endpoint Types

**Interface Endpoints:**
- ENI with private IP address
- Supports most AWS services
- Uses AWS PrivateLink technology

**Gateway Endpoints:**
- S3 and DynamoDB only
- No additional network interface
- Modified route table entry

#### Endpoint Configuration
Interface endpoint setup:

```yaml
Interface Endpoint:
  vpc_id: vpc-xxxxxxxxxxxxxxxxx
  service_name: com.amazonaws.us-east-1.s3
  vpc_endpoint_type: Interface
  subnet_ids: [subnet-xxxxx, subnet-yyyyy]
  security_group_ids: [sg-xxxxx]
```

#### Benefits
VPC endpoints provide:

```diff
+ Security: No internet exposure for AWS service traffic
+ Cost: Reduced data transfer costs
+ Performance: Lower latency through AWS network
+ Compliance: Private connectivity meets regulatory requirements
```

<a id="summary"></a>
## Summary

### Key Takeaways
```diff
+ VPC is the fundamental networking construct in AWS, providing isolation and control
+ Subnets divide VPC address space and control internet accessibility
+ Security Groups provide instance-level filtering with stateful behavior
+ Network ACLs offer subnet-level stateless filtering with explicit allow/deny rules
+ Internet Gateways enable bidirectional internet connectivity for public subnets
+ NAT Gateways provide outbound-only internet access for private subnets
+ Route Tables control traffic routing within and outside the VPC
+ VPC Peering enables private cross-VPC communication
+ VPC Endpoints provide secure, private access to AWS services
```

### Quick Reference

#### Common CIDR Blocks for VPCs
```bash
# Large enterprise VPC
10.0.0.0/16          # 65,536 addresses

# Medium Office VPC
192.168.0.0/16       # 65,536 addresses

# Small Development VPC
172.16.0.0/20        # 4,096 addresses
```

#### Security Group Rules Examples
```yaml
# Allow SSH from anywhere
- ip_protocol: tcp
  from_port: 22
  to_port: 22
  cidr_ip: 0.0.0.0/0

# Allow HTTP from load balancer
- ip_protocol: tcp
  from_port: 80
  to_port: 80
  source_security_group_id: sg-loadbalancer123

# Allow MySQL from web servers
- ip_protocol: tcp
  from_port: 3306
  to_port: 3306
  user_id_group_pairs:
    - group_id: sg-web123
```

#### Route Table Best Practices
- Use separate route tables for public and private subnets
- Always include the local route for VPC internal traffic
- Test route changes in development environments first
- Use descriptive names for custom route tables

### Expert Insight

#### Real-world Application
**Microservices Architecture:**
- Create separate VPCs for different environments (dev/staging/prod)
- Use VPC peering or Transit Gateway for inter-environment communication
- Implement security groups based on service roles
- Leverage NAT Gateways for external API calls

**Multi-Region Deployment:**
- Design consistent CIDR schemas across regions
- Use Transit Gateway for simplification
- Implement cross-region VPC peering for specific needs
- Plan for data transfer costs and latency

#### Expert Path
**Mastering AWS Networking:**
1. **Design Phase**: Create detailed network diagrams before implementation
2. **CIDR Planning**: Thoroughly plan IP address allocation upfront
3. **Automation**: Use Infrastructure as Code (CloudFormation/Terraform) from day one
4. **Monitoring**: Implement VPC Flow Logs and CloudWatch monitoring
5. **Security**: Adopt defense-in-depth with multiple security layers
6. **Cost Optimization**: Regularly review and optimize NAT Gateway usage

#### Common Pitfalls
```diff
- Using default VPC for production workloads
- Overlap in CIDR blocks when designing VPC peering
- Forgetting to update route tables after configuration changes
- Security groups with overly permissive rules (0.0.0.0/0)
- Not accounting for NAT Gateway costs in smaller deployments
- Misunderstanding stateless vs stateful filtering differences
```

#### Lesser-Known Facts
- **VPC Flow Logs** can capture rejected traffic for security analysis
- **Default Security Group** allows all inbound from itself - useful for multi-tier apps
- **NACL Rules Processing** stops at first match, unlike security groups
- **Internet Gateway** doesn't require subnet association - routes control that
- **VPC Endpoints** can reduce costs for high-volume S3/DynamoDB traffic

#### Advantages and Disadvantages

**Public Subnets:**
```diff
+ Direct internet access simplifies architecture
+ Easy to deploy and configure
+ Suitable for web-facing services
- Exposed to internet threats
- No inbound traffic control at subnet level
- Requires careful security group management
```

**Private Subnets:**
```diff
+ Enhanced security through isolation
+ Protection from external threats
+ Controlled outbound access via NAT
- More complex routing configuration
- Additional cost for NAT services
- Debugging connectivity issues more challenging
```

**Security Groups:**
```diff
+ Stateful simplifies configuration
+ Instance-level granularity
+ Can reference other security groups
- No explicit deny rules
- No subnet-level enforcement
- Can become complex with many rules
```

**Network ACLs:**
```diff
+ Subnet-level defense-in-depth
+ Explicit allow/deny control
+ Supports rule numbering for priority
- Stateless requires symmetric rules
- Can be more complex to configure
- Potential for misconfigurations
```

</details>