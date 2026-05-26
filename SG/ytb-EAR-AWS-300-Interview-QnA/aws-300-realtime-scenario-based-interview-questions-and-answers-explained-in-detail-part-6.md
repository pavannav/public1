<details open>
<summary><b>AWS 300+ Realtime Scenario Based Interview Questions and Answers - Part 6 (KK-CS45-script-v2-Interview)</b></summary>

## Overview
This session covers questions 36-40, focusing on Elastic IPs, Internet Gateways, Default VPCs, EBS Snapshots, and VPC Peering Connections.

---

## Q36: How many Elastic IPs can you create?

**Answer:** By default, AWS allows a maximum of 5 Elastic IPs per region at the account level. To request more than the default quota, you need to raise a service quota increase request through the Service Quotas console.

**Key Points:**
- Elastic IPs are static IPs that persist even if you stop or terminate instances
- Used when you need a consistent public IP address (e.g., for VPN servers)
- Accessed via: Services → Service Quotas → Search "EC2" → "EC2-VPC Elastic IPs"

**Note:** Elastic IPs are charged when not associated with a running instance, so only allocate when necessary.

---

## Q37: For Internet Gateway, do you find any bandwidth constraint?

**Answer:** No, AWS Internet Gateways do not have any bandwidth constraints. An Internet Gateway provides a highly available, horizontally scaled, and redundant network component for connecting VPC instances to the internet.

**Key Points:**
- Internet Gateway handles any level of internet-bound traffic without bandwidth limitations
- Bandwidth constraints may come from:
  - EC2 instance types (network performance varies by instance family)
  - NAT Gateways
  - VPC Peering connections
  - Transit Gateways

**Note:** While the Internet Gateway itself has no bandwidth limits, your EC2 instances and other networking components may impose performance limitations.

---

## Q38: What is the significance of a default VPC?

**Answer:** Default VPCs are designed for quick deployments and testing purposes. They come pre-configured with subnets, route tables, and an internet gateway, allowing immediate instance launches without network configuration.

**Key Points:**
- Used for testing and development environments
- Pre-configured with public subnets and internet access
- Not recommended for production environments

**Production Best Practices:**
- Create custom VPCs for production environments
- Implement proper security controls and network segmentation
- Configure appropriate routing, NAT gateways, and security groups
- Plan network architecture based on application requirements

**Note:** Always use custom VPCs for production workloads where you need specific security, networking, and scaling configurations.

---

## Q39: Can you make use of default EBS snapshot?

**Answer:** Yes, you can use default EBS snapshots in AWS as backups or templates to create new EBS volumes.

**Key Points:**
- EBS snapshots are incremental by default
- Only store changes since the last snapshot (cost-effective)
- Can be accessed and managed from the EC2 console under Snapshots
- Useful for creating volume templates or point-in-time backups

**Use Cases:**
- Creating golden images for consistent deployments
- Backup and disaster recovery
- Cross-region or cross-account volume replication

---

## Q40: Can you establish a peering connection to a VPC in a different region?

**Answer:** Yes, you can establish VPC peering connections between VPCs in different AWS regions, known as inter-region VPC peering.

**Key Points:**
- Enables private IP communication between VPCs across regions
- Traffic is routed using private IP addresses over AWS's private network
- Requires configuration at both ends (requester and accepter)
- Useful for disaster recovery setups and multi-region architectures

**Important Considerations:**
- Inter-region VPC peering has data transfer charges
- Not transitive - if VPC A peers with VPC B, and VPC B peers with VPC C, VPC A cannot communicate with VPC C through these connections
- For multiple VPCs requiring inter-connectivity, consider using Transit Gateway as a hub

**Note:** For complex multi-VPC architectures within the same region, Transit Gateway is often more cost-effective and manageable than multiple peering connections.

</details>