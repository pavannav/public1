# Session 026: Creating VPC Network Peering in GCP

<details open>
<summary><b>Creating VPC Network Peering GCP (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [What is VPC Network Peering?](#what-is-vpc-network-peering)
  - [Use Cases for VPC Peering](#use-cases-for-vpc-peering)
  - [Benefits of VPC Peering](#benefits-of-vpc-peering)
  - [Limitations and Considerations](#limitations-and-considerations)
  - [Peering Request States](#peering-request-states)
- [Prerequisites](#prerequisites)
- [Creating VPC Network Peering](#creating-vpc-network-peering)
  - [Step 1: Navigate to VPC Networks](#step-1-navigate-to-vpc-networks)
  - [Step 2: Create Peering Connection](#step-2-create-peering-connection)
  - [Step 3: Configure Network Details](#step-3-configure-network-details)
  - [Step 4: Request Peering](#step-4-request-peering)
  - [Step 5: Accept Peering Request](#step-5-accept-peering-request)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)
- [Summary](#summary)

## Overview

This session covers VPC Network Peering in Google Cloud Platform (GCP), a networking feature that allows you to connect two VPC networks so that resources in each network can communicate with each other using internal IP addresses. Learn the concepts, benefits, limitations, and step-by-step process to create network peering connections through the GCP console.

## Key Concepts and Deep Dive

### What is VPC Network Peering?

VPC Network Peering is a Google Cloud networking feature that enables direct communication between two VPC networks. Unlike VPNs or interconnections, peered networks appear as if they are part of the same network, allowing resources to communicate using internal IP addresses without needing external IP addresses or traversing the public internet.

```bash
# Conceptual representation:
VPC A (10.0.0.0/16) <---peering---> VPC B (10.1.0.0/16)
# Resources in VPC A can directly access resources in VPC B
# and vice versa using private IP addresses
```

### Use Cases for VPC Peering

VPC Network Peering is commonly used in these scenarios:

1. **Multi-Project Architectures**: Connect VPCs across different GCP projects
2. **Shared Services**: Enable access to shared services like databases or APIs
3. **Development Environments**: Separate dev/test/prod environments with controlled access
4. **Service Mesh Integration**: Connect service meshes across VPC boundaries
5. **Cross-Organization Connectivity**: Connect VPCs owned by different organizations
6. **Microservices Communication**: Allow microservices deployed in different VPCs to communicate
7. **Hybrid Cloud Extensions**: Extend on-premises networks through peered VPCs

### Benefits of VPC Peering

```diff
+ Zero Data Transfer Costs: No charges for traffic between peered networks
+ Low Latency: Direct network communication without hop through public internet
+ Enhanced Security: Traffic stays within Google's private network
+ Simplified Architecture: No need for VPN gateways or external IP addresses
+ Scalability: Automatically handles varying traffic patterns
+ Resource Isolation: Maintains network isolation while enabling connectivity
+ Internal IP Communication: Resources communicate using private RFC 1918 addresses
```

### Limitations and Considerations

> [!IMPORTANT]
> Understanding these limitations is crucial for planning your network architecture.

| Limitation | Description | Impact |
|------------|-------------|--------|
| **No Transitive Peering** | A peered with B, B peered with C does not mean A can reach C | Requires direct peering relationships |
| **No Overlapping CIDR Ranges** | Cannot peer networks with overlapping IP address ranges | Plan IP address allocation carefully |
| **Regional Limitation** | Initially regional, but can be upgraded to global routing | May need global peering for multi-region architectures |
| **Route Exchange** | Only specific routes are exchanged, not all routes | Review routing implications |
| **Firewall Rules Required** | Peering doesn't automatically create firewall rules | Must configure VPC firewall rules separately |
| **No Health Checks** | GCP doesn't perform health checks on peering connections | Monitor connectivity at application level |
| **Manual Route Updates** | Some route changes may require manual intervention | Understand routing behavior |

### Peering Request States

VPC peering connections go through several states:

1. **Pending**: Initial request sent, waiting for acceptance
2. **Active**: Both sides have accepted, connection is live
3. **Rejected**: Peering request was denied
4. **Expired**: Request timed out without acceptance (30 days default)
5. **Inactive**: Connection disrupted due to network changes

## Prerequisites

Before creating VPC Network Peering, ensure you have:

- **Two VPC Networks**: At least two VPC networks in GCP
- **IAM Permissions**:
  - `compute.networks.updatePeering` on source VPC
  - `compute.networks.updatePeering` on destination VPC
- **Non-Overlapping CIDRs**: Ensure no IP address range conflicts
- **Network Connectivity**: Both VPCs must be active and healthy
- **Project Access**: Appropriate project editor/viewer permissions

> [!NOTE]
> If peering across projects, you need permissions in both projects.

## Creating VPC Network Peering

### Step 1: Navigate to VPC Networks

1. Go to Google Cloud Console
2. Navigate to **VPC network** > **VPC networks**
3. Select the source VPC network you want to peer from

### Step 2: Create Peering Connection

1. In the selected VPC network page, click on **Private service connection**
2. Click **Create connection**
3. Select **VPC Network Peering**
4. Click **Continue**

### Step 3: Configure Network Details

```yaml
# Peering Configuration Parameters:
- Name: descriptive-name-for-peering
- Network: select the source VPC network
- Peered network:
  - Project: target project ID
  - Network: target VPC network name
- Description: optional description
```

**Key Fields to Configure:**
- **Name**: Choose a meaningful name (e.g., `my-project-to-shared-services`)
- **Your VPC network**: This is pre-selected (source network)
- **Peered VPC network**:
  - **Project**: Select the project containing the target VPC
  - **VPC network**: Select the target network
- **Description**: Add context like purpose or environment

### Step 4: Request Peering

1. Click **Create** to initiate the peering request
2. The state shows as "Pending" in the source network
3. Navigate to the target VPC network to accept the request

### Step 5: Accept Peering Request

1. In the target VPC network, go to **Private service connection**
2. Find the pending peering request (shows as "Inactive" or "Pending")
3. Click **Accept** to establish the connection
4. Once accepted, both networks show "Active" state

```bash
# Conceptual Commands (Console-Based):
# 1. Request peering from VPC-A to VPC-B
gcloud compute networks peerings create vpc-a-to-vpc-b \
  --network=vpc-a \
  --peer-project=project-b \
  --peer-network=vpc-b

# 2. Accept peering in VPC-B
gcloud compute networks peerings update vpc-b-to-vpc-a \
  --network=vpc-b \
  --peer-project=project-a \
  --peer-network=vpc-a \
  --status=ACTIVE
```

## Verification

To verify your peering connection:

1. **Check Connection Status**: Both networks should show "Active" state
2. **Subnet Route Exchange**: Verify routes are exchanged in the VPC routing table
3. **Connectivity Testing**:
   - Use `ping` between instances in peered networks
   - Test application connectivity
   - Verify firewall rules allow traffic
4. **Routing Table Inspection**: Check effective routes in both VPCs

```bash
# Verification Commands:
# Check peering status
gcloud compute networks peerings list --network=vpc-a

# List routes to verify subnet exchange
gcloud compute routes list --filter="nextHop=peering"

# Test connectivity with network tools
ping -c 4 10.1.0.10  # Internal IP in peered network
```

> [!NOTE]
> Firewall rules must allow traffic between peered networks. Create ingress rules for the required protocols and ports.

## Troubleshooting

### Common Issues

1. **Overlapping CIDR Ranges**:
   ```
   Error: Networks have overlapping IP ranges
   ```
   **Solution**: Review and modify IP address ranges to eliminate conflicts

2. **Permission Denied**:
   ```
   Error: Insufficient permissions for peering operation
   ```
   **Solution**: Verify IAM permissions in both projects

3. **Request Timeout**:
   ```
   Error: Peering request expired
   ```
   **Solution**: Re-initiate the peering request within 30 days

4. **Route Conflicts**:
   ```
   Warning: Route conflicts detected
   ```
   **Solution**: Review and resolve conflicting routes

5. **Firewall Blocking Traffic**:
   ```
   Connection refused
   ```
   **Solution**: Configure VPC firewall rules to allow traffic

## Summary

### Key Takeaways
```diff
+ VPC Network Peering enables direct communication between VPC networks using internal IP addresses
+ Zero data transfer costs between peered networks makes it cost-effective for GCP architectures
+ Benefits include low latency, high security, and simplified network management
- No transitive peering requires direct connections for multi-VPC mesh architectures
- Overlapping IP ranges prevent peering - plan CIDR allocation carefully
+ Requires both networks to accept peering request for active connection
+ Firewall rules must be configured separately for traffic to flow
+ Regional by default, but can enable global routing for multi-region needs
```

### Quick Reference

**Creating Peering (Console):**
1. VPC network > VPC networks > Select source VPC
2. Private service connection > Create connection > VPC Network Peering
3. Configure: Name, target project/network
4. Create (source) > Accept (target)

**GCloud Commands:**
```bash
# Create peering request
gcloud compute networks peerings create PEERING-NAME \
  --network=SOURCE-NETWORK \
  --peer-project=PEER-PROJECT \
  --peer-network=PEER-NETWORK

# Accept peering request
gcloud compute networks peerings update PEERING-NAME \
  --network=PEER-NETWORK \
  --peer-project=SOURCE-PROJECT \
  --peer-network=SOURCE-NETWORK \
  --status=ACTIVE
```

**Common Limits:**
- Maximum 25 peering connections per VPC
- Request expires after 30 days
- 100 dynamic routes per peering connection

### Expert Insight

**Real-world Application:**
```
In enterprise environments, VPC peering is commonly used for:
- Shared services architectures where central services (like logging, monitoring)
  need to be accessible across multiple projects
- Multi-tenant applications where each tenant has isolated VPC but needs
  access to common infrastructure resources
- Development pipelines where CI/CD tools in one project need to deploy
  to application VPCs in separate projects
```

**Expert Path to Mastery:**
- Calculate IP address requirements upfront to avoid CIDR conflicts
- Implement network naming conventions for scalable peering management
- Design hub-and-spoke topologies using direct peering relationships
- Monitor peering connections proactively using Cloud Monitoring
- Automate peering creation using Infrastructure as Code (Terraform/Cloud Deployment Manager)
- Understand transit network patterns for complex multi-VPC architectures

**Common Pitfalls:**
```diff
- Assuming peering creates automatic firewall rules (configure them explicitly)
- Overlooking overlapping CIDRs during network planning
- Not monitoring for route conflicts after network changes
- Forgetting regional limitations for global architectures
- Creating circular dependencies with transitive peering assumptions
- Neglecting to document peering relationships for operational clarity
- Failing to clean up unused peering connections (they block new peerings)
```

</details>