# Subnet A Subnet B & Legacy DC

<details open>
<summary><b>Subnet A Subnet B & Legacy DC (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-concepts-deep-dive)
- [Lab Demo](#lab-demo)
- [Summary](#summary)

## Overview
This session covers advanced AWS Virtual Private Cloud (VPC) networking concepts, focusing on creating subnets (one private for production workloads, one public for bastion hosts), configuring route tables, internet and NAT gateways, elastic IPs, and EC2 instances. It demonstrates elastic IP persistence testing through instance reboots, compares dynamic vs. static IPs, explains Outposts for on-premises AWS services, and discusses security groups vs. network ACLs. The session emphasizes production-ready network architectures under client requirements, including cost implications of elastic IPs and best practices for associating resources like IGWs and NAT gateways to VPCs and route tables.

## Key Concepts/Deep Dive
### VPC Architecture Fundamentals
A VPC is an isolated virtual network within AWS where you define IP ranges, subnets, route tables, internet gateways (IGWs), and NAT gateways. Subnets divide the VPC into smaller segments:
- **Private Subnet (e.g., Subnet A)**: Hosts resources that shouldn't be directly accessible from the internet, like production application servers. Uses NAT Gateway for outbound internet access.
- **Public Subnet (e.g., Subnet B)**: Exposes resources like bastion hosts or load balancers to the internet via IGW and elastic IPs.

### Elastic IP (EIP) vs. Dynamic Public IP
- **Dynamic Public IP**: Assigned from AWS IPv4 pool to EC2 instances in public subnets. Changes upon reboot or termination, free for data traffic but not ideal for stable access.
- **Elastic IP**: Static public IPv4 address from AWS pool. Persists after reboots/terminations (until released). Charged when allocated but not attached (idle cost). Used for bastion hosts requiring consistent IPs.

Charging Details for EIPs:
- Idle EIP: Charged hourly when allocated but not associated with an instance.
- Attached EIP: No additional IP charge; only for inbound/outbound data traffic via ISP backbone.

### Internet Gateway (IGW) and NAT Gateway
- **IGW**: Regional service attached to a VPC (one IGW max per VPC). Routes traffic to/from internet for public subnets. Not for NAT/private subnets.
- **NAT Gateway**: Managed by AWS in public subnet. Provides outbound internet access for private subnets while hiding private IPs. Uses elastic IP; redundant across availability zones (AZs). Charged for data throughput.

### Route Tables and Routing
- Route tables act as routers, controlling traffic flow via routes (destination, target gateway).
- **Default Local Route (10.x.x.x/16)**: Handles inter-subnet communication within VPC.
- **Custom Routes**:
  - Public route table: `0.0.0.0/0` → IGW (internet access).
  - Private route table: `0.0.0.0/0` → NAT Gateway (outbound internet).
- One subnet associates with one route table; explicit association required for customized tables.

### Outposts: On-Premises AWS Infrastructure
AWS Outposts extends AWS services (EC2, VPC) to on-premises via hardware provided by AWS. Runs hypervisor-based VMs in legacy data centers, connected to AWS Region. Uses same APIs but managed by AWS with redundancy. Expensive (hardware + management), used for hybrid clouds needing low-latency or compliance.

### Security Groups vs. Network ACLs (NACLs)
| Feature                  | Security Groups (SG)                          | Network ACLs (NACL)                          |
|--------------------------|-----------------------------------------------|-----------------------------------------------|
| **Scope**               | Instance-level (EC2, network interfaces)      | Subnet-level                                 |
| **State**               | Stateful (tracks connections)                | Stateless (check all traffic)                |
| **Rules**               | All rules checked; default deny inbound, allow outbound | First-match rules apply; stops checking after match; default allow |
| **Rules Count**         | Up to 60 inbound/outbound rules per SG       | Up to 20 inbound/outbound rules per NACL     |
| **Assignment**          | Multiple per network interface (5 max)       | One per subnet (implicit)                    |
| **Use Case**            | Micro-segmentation (host security)            | Broad subnet filtering                       |

### DHCP, DNS, and Reserved IPs in AWS VPC
- **DHCP**: Manages IP assignment; create custom DHCP options for custom DNS.
- **DNS**: AWS Route 53; resolves domain names within VPC/subnets.
- Reserved IPs (e.g., 10.1.x.2+.vpc.amazonaws.com for Route 53) in each subnet for AWS DNS servers.
- Custom DNS servers possible via EC2 instances in VPC/subnets.

### Instance Creation and Networking
- EC2 instances launched in specific subnets/subnet AZs.
- **Auto-Assign Public IP**: Enables dynamic IP from AWS pool for public internet-facing instances.
- **Elastic IP Attachment**: Manual allocation/association for static IPs.
- **Security Groups**: Reference local VPC (SG group ID, not external IPs) for intra-VPC traffic; explicit IPs for external access.

### Migrating to AWS: Legacy Data Centers
Outposts enable running AWS-compatible workloads in on-premises data centers without full cloud migration. Hardware (servers, hypervisors) managed by AWS, reducing maintenance costs vs. on-premises virtualization (Dell servers, VMware licenses).

### Architecture Best Practices
Plan network before launching instances:
- Build IGW/NAT Gateways first.
- Create custom route tables and associate subnets.
- Use meaningful naming (environment, function).
- Test reboots for IP persistence.
- Avoid idle EIPs to minimize costs.
- Use Security Groups for instance-level control; NACLs for subnet-level.

For diagrams, here's a Mermaid flow of the session's network setup:

```mermaid
graph TD
    VPC[VPC (e.g., 10.1.0.0/16)] --> SubnetA[Subnet A (Private, Prod Web)]
    VPC --> SubnetB[Subnet B (Public, Bastion)]
    SubnetA --> RT_Private[Private Route Table: Local Route + NAT GW]
    RT_Private --> NAT_GW[NAT Gateway (Public IP via EIP)]
    SubnetB --> RT_Public[Public Route Table: Local Route + IGW]
    RT_Public --> IGW[Internet Gateway]
    NAT_GW --> IGW
    SubnetB --> EC2_Public[EC2 Bastion (EIP Attached)]
    SubnetA --> EC2_Private[EC2 Prod Apps (Dynamic IPs via NAT)]
    IGW --> Internet[Internet]
    RT_Private --> Internet
    RT_Public --> Internet
```

Client requirements drive design: Private subnet for prod (secure, outbound only), public for bastion (internet-accessible).

> [!IMPORTANT]
> Elastic IPs incur hourly charges when idle/unassociated. Always attach immediately or release to avoid costs.

> [!NOTE]
> Outposts reduce on-premises maintenance but increase complexity/cost; evaluate latency/regulatory needs.

## Lab Demo
The instructor demonstrates full VPC setup in AWS Console, focusing on subnets, gateways, elastic IPs, and EC2 instances.

### Step 1: Create VPC and Subnets
- In AWS VPC Console: Create VPC (e.g., 10.1.0.0/16).
- Add two subnets:
  - Subnet A: 10.1.0.0/28 (private, no auto-assign public IP).
  - Subnet B: 10.1.1.0/28 (public, enable auto-assign public IP).

### Step 2: Set Up Gateways and Elastic IPs
- Allocate Elastic IP (from AWS pool).
- Create Internet Gateway (IGW); attach to VPC.
- Create NAT Gateway in Subnet B (connect to Elastic IP for public IP).

### Step 3: Configure Route Tables
- Create Private Route Table:
  - Associate Subnet A explicitly.
  - Add route: `0.0.0.0/0` → NAT Gateway.
- Create Public Route Table:
  - Associate Subnet B explicitly.
  - Add route: `0.0.0.0/0` → IGW.
- Default Local Route (10.1.0.0/16 → Local) in both tables.

### Step 4: Launch EC2 Instances
- Launch three t2.micro instances (free tier):
  - VM Test 1: Subnet A (private), associate custom Security Group (all inbound deny, outbound allow).
  - VM Test 2: Subnet B (public), allocate/manually associate Elastic IP from pool; dynamic IP from AWS pool.
  - VM Test 3: Subnet B (public), auto-assign public IP (dynamic from AWS pool).
- Security Groups: Attach master SG allowing VPC-internal traffic via security group ID.

### Step 5: Test IP Persistence
- Reboot VM Test 2 (Elastic IP): IP remains static.
- Reboot VM Test 3 (Dynamic): IP may change after multiple reboots (DHCP leasing behavior).
- Verify routing for private instance: Outbound traffic via NAT Gateway (masked source).

Commands/scripts not detailed, as this is UI-based; in real CLI:
```bash
aws ec2 create-vpc --cidr-block 10.1.0.0/16
aws ec2 create-subnet --vpc-id vpc-12345 --cidr-block 10.1.0.0/28
aws ec2 allocate-address --domain vpc
aws ec2 create-internet-gateway
aws ec2 attach-internet-gateway --vpc-id vpc-12345 --gateway-id igw-12345
aws ec2 create-route-table --vpc-id vpc-12345
aws ec2 create-route --route-table-id rtb-12345 --destination-cidr-block 0.0.0.0/0 --gateway-id igw-12345
aws ec2 associate-route-table --subnet-id subnet-a --route-table-id rtb-private
```

Tables for key comparisons:
| Instance | IP Type | Changes on Reboot? | Charges |
|----------|---------|-------------------|---------|
| VM2 (Public) | Elastic | No | Idle EIP charged unless attached |
| VM3 (Public) | Dynamic | Yes (after multiple) | Data-only |

> [!IMPORTANT]
> Mistake in transcript: "Sbnet" corrected to "Subnet" throughout. "Nackal" likely "NACL". "Knackal" same error. No "htp" or "cubectl" found.

## Summary
### Key Takeaways
```diff
+ Subnets classify traffic: Private (NAT for outbound), Public (IGW for full internet).
+ Elastic IPs: Static, persistent, but charged when idle—use for bastion hosts.
+ Dynamic IPs: Change on reboot, free except data charges—cost-effective for non-critical.
+ Route tables: Control per-subnet routing; associate explicitly.
+ NAT/IGW: One per VPC; IGW for public subnets, NAT for private outbound masking.
+ Security Groups: Stateful, instance-level; check all rules (no implicit deny).
+ NACLs: Stateless, subnet-level; first-match wins.
+ Outposts: Hybrid cloud for low-latency/compliance, managed by AWS.
+ Test reboots: Verify IP persistence; elastic IPs stable, dynamic variable.
- Avoid idle EIPs: Release unused to prevent charges.
- Confusion risk: Label route tables/function clearly (e.g., "Private Prod").
! Security: Never expose prod subnets directly; use bastion with EIP.
```

### Quick Reference
- **EIP Allocation**: `aws ec2 allocate-address --domain vpc` (charged ~$0.005/hr idle).
- **NAT Gateway Route**: `0.0.0.0/0` → nat-gw-id (only outbound internet for private).
- **IGW Route**: `0.0.0.0/0` → igw-id (full internet for public).
- **Reboot Test**: Check EIP stability; dynamic IPs via `curl ifconfig.me` after reboot.
- **Outposts Use**: For legacy DC + AWS hybrid; hardware leased/managed.

### Expert Insight
**Real-world Application**: In enterprises, use private subnets for app servers (DB, APIs) with NAT for updates/software downloads, public subnets with EIPs for load balancers/basti-ons. Outposts for regulated industries (finance/healthcare) needing on-premises compliance while leveraging AWS APIs.

**Expert Path**: Master Terraform/CloudFormation for IaC VPC provisioning. Learn AWS Direct Connect/VPN for hybrid networking. Certify AWS Networking Specialty for advanced peering/transit gateways.

**Common Pitfalls**: Forgetting to attach NAT to private route tables (causes no internet). Associating wrong subnet to public routing (security breach). Not releasing EIPs (cost spikes). Assuming dynamic IPs stable (breaks bookmarks/connections). Over-relying on Security Groups without NACLs (misconfigured subnet rules).

</details>
