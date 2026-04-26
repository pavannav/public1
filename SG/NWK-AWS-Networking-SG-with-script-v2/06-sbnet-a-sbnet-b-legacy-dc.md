# Session 06: Subnet A Subnet B & Legacy DC

## Table of Contents
- [Overview](#overview)
- [VPC and Subnet Setup](#vpc-and-subnet-setup)
- [Route Tables Configuration](#route-tables-configuration)
- [Internet Gateway (IGW)](#internet-gateway-igw)
- [Elastic IP (EIP) Allocation](#elastic-ip-eip-allocation)
- [NAT Gateway Creation](#nat-gateway-creation)
- [EC2 Instance Launch](#ec2-instance-launch)
- [Security Groups vs. Network ACLs](#security-groups-vs-network-acls)
- [IP Addressing: Dynamic vs. Elastic](#ip-addressing-dynamic-vs-elastic)
- [Outpost and Legacy Data Center Concepts](#outpost-and-legacy-data-center-concepts)
- [Troubleshooting and Testing IPs](#troubleshooting-and-testing-ips)
- [Summary](#summary)

## Overview
This session covers advanced VPC configuration, including creating public and private subnets, route tables, internet gateway, NAT gateway, elastic IPs, and EC2 instances testing IP persistence. The instructor demonstrates subnet segregation (Subnet A as private, Subnet B as public) for production environments, discusses Outpost architecture, and explains security group mechanics versus NACLs. Emphasis is on practical networking for legacy DC integration, with hands-on VM reboots to verify elastic vs. dynamic IP behavior.

## VPC and Subnet Setup
- Created a VPC with two subnets:
  - Subnet A: Designated as private for production workloads.
  - Subnet B: Designated as public for bastion host or internet-facing services.
- Naming convention follows `company-prod-env-vmname` (e.g., networking-prod-ec2-vm-test01).
- Subnets are associated with VPC CIDR and assigned to specific route tables based on use case.

**Lab Demo Steps for VPC Creation:**
1. Navigate to AWS VPC console.
2. Create a new VPC with desired CIDR (e.g., 10.1.0.0/16).
3. Within the VPC, add two subnets:
   - Subnet A: Private, e.g., 10.1.0.0/28 – No auto-assign public IP.
   - Subnet B: Public, e.g., 10.1.16.0/28 – Enable auto-assign public IP.

## Route Tables Configuration
- VPC has a main route table by default, but custom route tables are created for public and private subnets.
- Subnets are explicitly associated with route tables (one subnet per table at a time).
- Local routes (entire VPC CIDR) are automatic; custom routes (e.g., to IGW) are manual.

**Lab Demo Steps for Route Table Setup:**
1. Create two custom route tables in VPC console:
   - Private Route Table: Associate with Subnet A.
   - Public Route Table: Associate with Subnet B.
2. Check default entries: Local route is pre-populated.
3. For Public Route Table, edit routes to add default gateway pointing to IGW (target: igw-xxxxx).

## Internet Gateway (IGW)
- IGW is a regional resource attached to VPC for internet access.
- Only one IGW per VPC; enables public subnet VMs to reach the internet.
- Detached initially; requires attachment to VPC.

**Lab Demo Steps for IGW:**
1. Create IGW in VPC console with a name tag (e.g., networking-Internet-Gateway).
2. Attach IGW to the VPC.
3. Verify attachment status changes to "attached".

## Elastic IP (EIP) Allocation
- EIP is a static public IPv4 address allocated from AWS pool (not customer-owned or outpost pool).
- Charged when idle unless attached to EC2 instance.
- Elastic IPs do not change on reboot; ideal for production bastion hosts.

**Lab Demo Steps for EIP:**
1. Go to EC2 > Elastic IPs.
2. Allocate new EIP (IPv4, Amazon pool).
3. Associate EIP with an EC2 instance's elastic network interface (ENI).

**Corrections Noted:** Transcript misspells "Elastic IP" correctly, but earlier misspellings like "Sbnet" (Subnet) have been corrected. No instances of "htp" (HTTP?), "cubectl" (kubectl), etc., in this transcript. However, "Sbnet B" should be "Subnet B", as it appears frequently.

## NAT Gateway Creation
- NAT Gateway provides internet access for private subnets without exposing them publicly.
- Elastic IP assigned to NAT Gateway (redundant across AZs, but appears as single resource).
- Placed in public subnet; routes 0.0.0.0/0 traffic from private route table to NAT Gateway.

**Lab Demo Steps for NAT Gateway:**
1. Navigate to VPC > NAT Gateways.
2. Create NAT Gateway in public Subnet B.
3. Allocate new Elastic IP for public connectivity.
4. Add route in private route table: Destination 0.0.0.0/0, Target: nat-xxxxx.

## EC2 Instance Launch
- Three EC2 instances created:
  - Prod VM in Subnet A (private).
  - Public VM in Subnet B (dynamic IP for testing).
  - Bastion VM in Subnet B (Elastic IP for constant public access).
- Use Free Tier eligible instances (e.g., t2.micro).
- Advanced networking allows multiple ENIs on single instance for segmented services.

**Lab Demo Steps for Instance Launch:**
1. Go to EC2 > Instances > Launch Instance.
   - Name: e.g., networking-prod-vm-test01.
   - AMI: Amazon Linux 2.
   - Instance Type: t2.micro.
   - Key Pair: Create new (e.g., networking-key).
   - VPC: Select created VPC.
   - Subnet: Choose appropriate (private or public).
   - Security Group: Attach created security group.
   - Enable public IP for public instances.
   - Advance Networking: Optional for multiple ENIs.
2. Repeat for additional instances as needed.
3. Associate Elastic IP post-launch if required.

```bash
# Example command to connect (using allocated key):
ssh -i networking-key.pem ec2-user@<public-ip>
```

## Security Groups vs. Network ACLs
- Security Groups: Stateful, apply per ENI, check all rules (allow if match; implicit deny otherwise). Limits: 60 rules per group (inbound/outbound), 5 groups per ENI.
- Network ACLs: Stateless, apply per subnet, check rules sequentially (match halts). Default: Allow all in/outbound.
- Security Groups preferred for micro-segmentation; NACLs for subnet-level blocking.

```diff
+ Security Group: Checks all rules; allow on match
- Network ACL: Checks sequentially; drops if no match
```

## IP Addressing: Dynamic vs. Elastic
- Dynamic IPs: Assigned from AWS pool; change on reboot (prove via multiple reboots).
- Elastic IPs: Reserved IPv4; persist across reboots. Charged when not in use.
- Use Elastic IP for production public services; dynamic for testing.

**Testing Demo:**
1. Launch instance with dynamic IP.
2. Reboot instance multiple times.
3. Verify IP changes via console or ping.

```bash
# Reboot command (inside instance):
sudo reboot
```

## Outpost and Legacy Data Center Concepts
- AWS Outpost: Extends AWS services (EC2, VPC, etc.) to on-premises via hardware/API calls.
- Handles maintenance, redundancy; integrates with legacy DC for hybrid cloud.
- Outpost uses VPC-compatible hardware (e.g., Nitro hypervisor) for low-latency workloads.
- Maintains AWS API consistency; outages resolved via support.

## Troubleshooting and Testing IPs
- EIP not showing in instance column—check association via EIP console actions.
- Dynamic IP changes on reboot—DHCP random assignment from pool.
- NAT Gateway: Elastic IP unchanged on reboot; private IP internal.

**Common Issues:**
- Elastic IP idle charge: Attach to ENI immediately.
- Association failure: Ensure instance is in correct subnet/route table.
- Reboot testing: Multiple reboots required to observe dynamic IP change.

## Summary

> [!IMPORTANT]
> Key takeaways from subnet A (private) and Subnet B (public) configuration emphasize route table segregation, IGW/NAT Gateway roles for secure internet access, and Elastic vs. Dynamic IP choices for stability.

### Key Takeaways
```diff
+ Private subnet (Subnet A) uses NAT Gateway for outbound traffic; no direct internet exposure.
- Public subnet (Subnet B) attaches IGW for bidirectional access; Elastic IP recommended for production.
+ VXLAN Gateway (VGW) and IGW limits: One per VPC; VGW for VPN, IGW for internet.
+ Security groups: Stateful, all rules checked; NACLs: Sequential, per subnet.
+ Reboots prove Elastic IPs persist; dynamic IPs vary after pool release.
```

### Expert Insight

#### Real-World Application
- In production legacy DC migration, use Outpost for consistent AWS VMs on-premises, with public subnets for bastion hosts (Elastic IP) and private subnets (NAT Gateway) for app servers.
- Implement Outpost for hybrid workloads needing low-latency local data center access, avoiding full cloud migration costs.

#### Expert Path
- Master route table association rules (one subnet per table) and gateway limits.
- Practice multi-ENI setups for segregating financial/HR services on single instance.
- Dive into CloudWatch VPC Flow Logs for troubleshooting traffic issues.

#### Common Pitfalls
- Idle Elastic IPs incur charges—allocate minimally and associate immediately.
- Dynamic IPs may not change on first reboot; restart multiple times in non-production environments to confirm.
- Security group rules overload: Split into groups (60 rule limit) and attach multiple to ENI (up to 16).
- Outpost vs. local hardware: Outpost reduces maintenance but incurs AWS fees; compare with Dell/server costs for latency-critical apps.
