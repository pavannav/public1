# Session 028: Creating Private Services Access in GCP (in Hindi)

<details open>
<summary><b>Creating Private Services Access in GCP in Hindi (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [What is Private Service Access?](#what-is-private-service-access)
  - [Service Producers and Consumers](#service-producers-and-consumers)
  - [IP Address Allocation Requirements](#ip-address-allocation-requirements)
  - [VPC Network Peering](#vpc-network-peering)
  - [Supported Google Cloud Services](#supported-google-cloud-services)
  - [Connection Types](#connection-types)
- [Creating Private Service Access](#creating-private-service-access)
- [Lab Demo: Implementing Private Service Access](#lab-demo-implementing-private-service-access)
  - [Step 1: Allocating IP Address Range](#step-1-allocating-ip-address-range)
  - [Step 2: Creating Private Service Connection](#step-2-creating-private-service-connection)
  - [Step 3: Creating SQL Instance with Private IP](#step-3-creating-sql-instance-with-private-ip)
  - [Step 4: Connecting from VM using Private Service Access](#step-4-connecting-from-vm-using-private-service-access)
  - [Adding Multiple IP Ranges](#adding-multiple-ip-ranges)
- [Management and Troubleshooting](#management-and-troubleshooting)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview

This session explores **Private Service Access** in Google Cloud Platform (GCP), a networking feature that enables private connectivity between your Virtual Private Cloud (VPC) network and Google/third-party services. Instead of accessing these services over the public internet, Private Service Access establishes private connections using internal IP addresses, enhancing security and reducing latency.

The session demonstrates how to create and configure Private Service Access, including IP range allocation, connection establishment, and service integration through a practical lab with Cloud SQL. Key benefits include improved security posture, reduced data transfer costs, and consistent private networking within GCP.

## Key Concepts and Deep Dive

### What is Private Service Access?

Private Service Access is a networking feature that creates private connections between your VPC network and services offered by Google Cloud Platform or third-party service producers. These private connections leverage **internal IP addresses** rather than public IP addresses, allowing secure access to managed services without exposing traffic to the public internet.

```
graph TD
    A[Your VPC Network] --> B[VPC Network Peering]
    B --> C[Service Producer Network]
    C --> D[Managed Services]

    style A fill:#e1f5fe
    style C fill:#f3e5f5
    style D fill:#e8f5e8
```

> **Key Concept**: Unlike public IP access that routes traffic over the internet, Private Service Access uses dedicated private ranges and VPC peering to maintain all communication within Google's private network infrastructure.

### Service Producers and Consumers

- **Service Producers**: Entities (like Google Cloud Platform) that offer managed services and provide internal IP-based access to those services
- **Service Consumers**: GCP projects that consume these services through Private Service Access connections
- **Connection Scope**: A single Private Service Access connection can provide access to multiple services from the same producer

### IP Address Allocation Requirements

Before creating Private Service Access, you must allocate an internal IPv4 address range with these constraints:

1. **IPv4 Only**: Currently supports IPv4 addresses; IPv6 is not supported
2. **CIDR Notation**: Must be specified in CIDR format (e.g., `/24`, `/20`)
3. **Non-overlapping**: The range must not conflict with existing subnets in your VPC
4. **Private Ranges**: Use RFC 1918 private IP ranges (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)

**Common Allocation Options:**
- **Custom**: Specify exact range (e.g., `192.168.0.0/24`)
- **Automatic**: GCP allocates a `/24` range for you

### VPC Network Peering

Private Service Access automatically creates VPC Network Peering between your VPC and the service producer's network. This peering:

- Connects your VPC with Google's service network
- Enables routing between networks
- Maintains network isolation
- Supports cross-region connectivity
- Manages dynamic routes automatically

### Supported Google Cloud Services

Private Service Access supports these GCP services:

| Service | Description | Use Case |
|---------|-------------|----------|
| **Cloud SQL** | Managed relational databases | Private database connectivity |
| **Cloud Build** | CI/CD pipelines | Private build environments |
| **Filestore** | Managed NFS file storage | Private file shares |
| **Memorystore** | In-memory data stores (Redis/Memcached) | Private caching layers |
| **Cloud NetApp Volumes** | Enterprise file storage | Private enterprise file systems |

### Connection Types

You can create multiple Private Service Access connections, but typically one connection per VPC is sufficient since it provides access to all supported services from a single producer.

## Creating Private Service Access

The creation process involves two main steps:

1. **IP Range Allocation**: Reserve a private IP range in your VPC
2. **Connection Establishment**: Create the peering connection to Google Cloud services

```bash
# Command to allocate IP range (example - this is conceptual)
gcloud compute addresses create RANGE_NAME \
  --global \
  --purpose=VPC_PEERING \
  --addresses=192.168.0.0 \
  --prefix-length=24 \
  --network=VPC_NAME
```

## Lab Demo: Implementing Private Service Access

This section provides step-by-step instructions for implementing Private Service Access as demonstrated in the session.

### Step 1: Allocating IP Address Range

1. Navigate to VPC Networks → Private service connection
2. Click "ALLOCATE IP RANGE"
3. Configure the range:
   - **Name**: Choose a descriptive name (e.g., "private-range")
   - **IP Version**: IPv4 (only option available)
   - **IP Range**: Specify custom range (e.g., `192.168.0.0/24`) or use automatic allocation
4. Click "ALLOCATE" to reserve the range

### Step 2: Creating Private Service Connection

1. In Private service connection, click "CREATE CONNECTION"
2. Select the service producer:
   - Choose "Google Cloud Platform" (most common)
   - Optionally select "NetApp Cloud Volumes"
3. Choose the allocated IP range from Step 1
4. Click "CONNECT"

The connection will show:
- Connection name
- Associated IP range
- Service producer (Google Cloud Platform)
- Status as "Active"

### Step 3: Creating SQL Instance with Private IP

1. Navigate to Cloud SQL instances
2. Click "CREATE INSTANCE" → Choose database type
3. Configure basic settings:
   - **Instance ID**: Choose descriptive name
   - **Password**: Set admin password
   - **Region**: Select appropriate region
   - **Zone**: Choose single zone for demo purposes
4. In "Connections" section:
   - Disable "Public IP"
   - Enable "Private IP"
   - Select your VPC network
5. Configure instance size and storage as needed
6. Click "CREATE"

> [!IMPORTANT]
> The VPC must have Private Service Access configured before creating private IP instances. If not configured, the dialog will prompt you to set it up.

### Step 4: Connecting from VM using Private Service Access

With Private Service Access established:

1. Create a VM instance in the same VPC with only private IP
2. SSH into the VM
3. Install MySQL client if needed:
   ```bash
   sudo apt-get update
   sudo apt-get install mysql-client
   ```
4. Connect to Cloud SQL using internal IP:
   ```bash
   mysql -h [SQL_INSTANCE_PRIVATE_IP] -u [USERNAME] -p
   ```

The connection flows through the private peering rather than public internet.

### Adding Multiple IP Ranges

You can allocate multiple IP ranges for different services or organizational purposes:

1. Navigate to VPC Networks → Private service connection
2. Click "ALLOCATE IP RANGE" again
3. Add new range with different CIDR block
4. Update connection to include both ranges
5. Refresh to see both ranges available for service selection

This allows segregation like:
- `192.168.0.0/24` for SQL databases
- `10.0.0.0/20` for Memorystore instances
- `172.16.0.0/24` for Filestore shares

## Management and Troubleshooting

### Managing IP Ranges
- **Allocating**: Add new ranges through Private service connection
- **Releasing**: Click "RELEASE" next to allocated ranges
- **Deletion Constraints**: Cannot delete ranges still in use by services

### Common Issues
- **Service Producer Retention**: Service producer networks retain IP ranges for 4 days after service deletion
- **Overlapping Ranges**: Must not conflict with existing VPC subnets
- **Connection Refresh**: May need to refresh pages to see updated configurations

### Deletion Process
When deleting Private Service Access:
1. Delete all dependent services (SQL instances, Memorystore, etc.)
2. Wait 4 days for service producer cleanup
3. Delete IP ranges
4. Connection automatically cleans up

## Summary

### Key Takeaways

```diff
+ Private connectivity to Google Cloud services using internal IPs
+ Requires advance IP range allocation (IPv4 only, non-overlapping)
+ VPC Network Peering automatically established for secure routing
+ Single connection provides access to multiple supported services
+ Supports SQL, Filestore, Memorystore, Cloud Build, and NetApp Volumes
+ Multiple IP ranges possible for service segregation
+ 4-day retention period on service producer side affects deletions
```

### Quick Reference

**IP Range Allocation:**
```bash
# Google Cloud Console
VPC Networks → Private service connection → ALLOCATE IP RANGE
# Custom: 192.168.0.0/24 (example)
# Automatic: GCP assigns /24 range
```

**Create Private Connection:**
```bash
# Console steps
Private service connection → CREATE CONNECTION
# Select Google Cloud Platform → Choose IP range → CONNECT
```

**Connect to Private SQL Instance:**
```bash
mysql -h [private-ip] -u [username] -p
```

### Expert Insight

**Real-world Application:**
In enterprise environments, Private Service Access is crucial for compliance requirements that mandate private networking. Use it for production databases, file storage, and caching layers to eliminate public IP exposure and reduce security perimeters.

**Expert Path:**
Master Private Service Access by understanding how it integrates with other GCP networking features like VPC Network Peering, Cloud NAT, and Private Google Access. Learn to design IP allocation schemes that scale with organizational growth while maintaining network security boundaries.

**Common Pitfalls:**
- Forgetting the 4-day service producer retention period when decommissioning environments
- Overlapping IP ranges causing connection failures
- Not refreshing console views after configuration changes
- Assuming IPv6 compatibility (currently unsupported)
- Failing to disable public IPs on services when using private access

</details>