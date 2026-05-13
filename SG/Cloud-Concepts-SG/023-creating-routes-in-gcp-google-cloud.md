# Creating Routes in GCP - Google Cloud

<details open>
<summary><b>Creating Routes in GCP - Google Cloud (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Understanding Routes in VPC Networks](#understanding-routes-in-vpc-networks)
- [Types of Routes](#types-of-routes)
- [Default Routes](#default-routes)
- [Subnet Routes](#subnet-routes)
- [Custom Routes](#custom-routes)
- [Dynamic and Peering Routes](#dynamic-and-peering-routes)
- [Policy-Based Routes](#policy-based-routes)
- [Lab Demonstration: Working with Routes](#lab-demonstration-working-with-routes)
- [Summary](#summary)

## Overview
This session covers the fundamental concepts of routing in Google Cloud Platform (GCP) Virtual Private Cloud (VPC) networks. Routes determine how packets are forwarded between virtual machines (VMs), subnets, and external destinations like the internet. The instructor demonstrates through console operations and practical examples how routes work, their different types, and how to manage them effectively for network traffic control.

## Understanding Routes in VPC Networks

Routes in GCP VPC networks are essential for directing network traffic. Without proper routes, packets cannot reach their destinations. Think of routes as turn-by-turn directions for packet navigation in your cloud network.

### Key Route Functions

1. **Intra-Subnet Communication**: Enable traffic flow between specific VMs within the same network
2. **Inter-Subnet Communication**: Allow traffic between different subnets within a VPC
3. **External Communication**: Direct traffic to destinations outside the VPC (internet, other VPCs)

### Route Components

Every route consists of:
- **Destination Range**: IP address range the route applies to
- **Next Hop**: Where to send traffic (internet gateway, instance, VPN tunnel, etc.)
- **Network Tags**: Optional filtering mechanism to apply routes to specific VMs

> [!IMPORTANT]
> Routes work only when accompanied by proper firewall rules. Even with correct routing, traffic will be blocked if firewall policies deny access.

## Types of Routes

### System-Generated Routes
When you create a VPC network, GCP automatically generates several route types:

| Route Type | Description | Priority | Deletable |
|------------|-------------|----------|-----------|
| Default Internet Route | Directs traffic to `0.0.0.0/0` via internet gateway | 1000 | Yes |
| Subnet Routes | Handles internal subnet communication | 0 (highest) | No |

### User-Defined Routes
You can create custom routes for specific networking requirements.

## Default Routes

Default routes handle traffic destined for destinations outside your VPC network. The standard default route uses:
- **Destination**: `0.0.0.0/0` (all internet destinations)
- **Next Hop**: Internet gateway
- **Priority**: 1000

### Security Considerations

> [!NOTE]
> Deleting the default route isolates your VMs from the internet. This creates "private VMs" that cannot reach external services.

### Practical Example: Route Deletion Impact

```bash
# Before deleting default route (internet accessible)
PING google.com (172.217.194.139) 56(84) bytes of data.
64 bytes from 172.217.194.139: icmp_seq=1 ttl=96 time=1.25 ms

# After deleting default route (traffic blocked)
PING google.com (172.217.194.139) 56(84) bytes of data.
# No response - packets cannot reach internet
```

## Subnet Routes

Subnet routes handle communication between VMs in different subnets within the same VPC. These routes are automatically created and maintain the highest priority (0).

### Characteristics of Subnet Routes

```diff
+ Highest priority (0) - takes precedence over all other routes
- Cannot be deleted
- Represents internal subnet IP ranges (e.g., 10.x.x.x/24)
- Enables communication across all regions and zones in the VPC
```

### Route Range Restrictions

```diff
! Critical Limitation: Cannot create custom routes with the exact same IP range as subnet routes
- Attempting to create duplicate range routes will fail
+ Solution: Use more specific or broader ranges in custom routes
```

## Custom Routes

Custom routes (also called static routes) are user-created routes for specific networking purposes. You can create them through:

1. GCP Console: VPC Network > Routes > Create Route
2. gcloud CLI: `gcloud compute routes create`
3. Terraform/Ansible automation

### Creating a Custom Default Route

```bash
# Console steps:
1. Navigate to VPC Network > Routes
2. Click "Create Route"
3. Enter route name and description
4. Select target network
5. Set destination: 0.0.0.0/0
6. Choose next hop (internet gateway)
7. Optionally add instance tag restriction
```

## Dynamic and Peering Routes

### Dynamic Routes
Created automatically by Cloud Router when:
- Connecting VPC to on-premises networks via VPN
- Using Cloud Interconnect
- Establishing BGP sessions

Dynamic routes are updated, added, or removed based on network configuration changes.

### Peering Routes
Generated when establishing VPC peering between two VPC networks:
- Share subnet routes from peer networks
- Exchange custom routes (if configured)
- Imported/exported during peering setup

## Policy-Based Routes

Advanced routing mechanism combining:
- Protocol (TCP/UDP)
- Source IP range
- Destination IP range

### Key Characteristics

```diff
+ Evaluated before any other route types
- Not exchanged through VPC peering
+ Used by Internal TCP/UDP Load Balancing
```

## Lab Demonstration: Working with Routes

### Demo 1: Controlling Internet Access

This lab demonstrates how routes and network tags control VM internet access.

**Steps Performed:**

1. **Initial Setup**
   - Created VPC network with default route
   - Verified internet connectivity from VM

   ```bash
   ping -c 3 8.8.8.8
   # Successful ping responses received
   ```

2. **Delete Default Route**
   ```bash
   # Console: VPC > Routes > Delete default-internet-gateway route
   ```

3. **Verify Isolation**
   ```bash
   ping -c 3 8.8.8.8
   # No response - traffic blocked
   ```

4. **Create Tagged Route**
   - Route Name: `route-to-internet`
   - Destination: `0.0.0.0/0`
   - Next Hop: Internet Gateway
   - Tags: `internet-access`

5. **Apply Network Tag to Specific VM**
   ```bash
   # VM Instance > Edit > Network Tags: internet-access
   ```

6. **Test Selective Access**
   - VM with tag: ✅ Internet accessible
   - VM without tag: ❌ Internet blocked

### Demo 2: Route Range Conflicts

**Experimental Setup:**
- Existing subnet route: `192.168.0.0/24`
- Attempted custom route: `192.168.0.0/24` (same range)

**Expected Error:**
```
Operation failed: The route second-route hides the address space of the network and cannot change the routing of packets destined for the network.
```

**Resolution:**
- Changed custom route destination to `/23` (broader range)
- Route created successfully

## Summary

### Key Takeaways

```diff
+ Routes determine packet forwarding paths in VPC networks
+ Firewall rules must allow traffic even with correct routing
+ Subnet routes have highest priority (0) and cannot be deleted
+ Default route enables internet access via internet gateway
+ Instance tags control which VMs use specific routes
+ Cannot create custom routes with same range as subnet routes
+ Dynamic routes created automatically by Cloud Router
+ Policy-based routes evaluated first, not shared in peering
- Default route deletion isolates VMs from internet
```

### Quick Reference

**Route Creation Commands:**
```bash
# Create default route
gcloud compute routes create default-route \
  --network=my-vpc \
  --destination-range=0.0.0.0/0 \
  --next-hop-gateway=default-internet-gateway \
  --tags=internet-access

# Delete default route
gcloud compute routes delete default-internet-gateway
```

**Network Tag Configuration (Console):**
1. Compute Engine > VM Instances > [Instance Name] > Edit
2. Network Tags: `internet-access`
3. Save changes

### Expert Insight

#### Real-world Application
In production environments, selective internet access routing enables:
- Bastion host-only internet access for security
- Private subnet isolation while maintaining necessary outbound connectivity
- Cost optimization by routing specific traffic through dedicated internet gateways

#### Expert Path
Master advanced routing concepts:
- Learn Cloud Router configuration for dynamic routing
- Understand BGP peer configuration for hybrid cloud connectivity
- Implement policy-based routing for complex traffic engineering scenarios

#### Common Pitfalls
- **Overlooking firewall rules**: Routes alone don't permit traffic - always verify firewall configurations
- **IP range conflicts**: Remember subnet routes have zero priority - avoid duplicate ranges
- **Tag misconfiguration**: Instance tags filter route application - double-check tag spelling and assignment
- **Zone communication**: Routes don't override VPC subnet isolation - ensure proper subnet sizing and connectivity

</details>