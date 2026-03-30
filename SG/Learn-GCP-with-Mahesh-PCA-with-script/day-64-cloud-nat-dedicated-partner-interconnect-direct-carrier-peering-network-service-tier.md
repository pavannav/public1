# Session 64: Cloud NAT, Dedicated & Partner Interconnect, Direct & Carrier Peering, Network Service Tiers

## Table of Contents

1. [Cloud NAT Overview](#cloud-nat-overview)
2. [NAT Requirements and Setup](#nat-requirements-and-setup)
3. [Cloud NAT Types and Use Cases](#cloud-nat-types-and-use-cases)
4. [Private NAT for VPC Peering](#private-nat-for-vpc-peering)
5. [Cloud Interconnect Overview](#cloud-interconnect-overview)
6. [Dedicated Interconnect](#dedicated-interconnect)
7. [Partner Interconnect](#partner-interconnect)
8. [Cross Cloud Interconnect](#cross-cloud-interconnect)
9. [Direct Peering](#direct-peering)
10. [Carrier Peering](#carrier-peering)
11. [VPC Flow Logs](#vpc-flow-logs)
12. [Network Service Tiers](#network-service-tiers)
13. [Summary](#summary)

## Cloud NAT Overview

### Overview
Cloud Network Address Translation (NAT) is a Google Cloud service that enables outbound connectivity for Virtual Machine (VM) instances and Google Kubernetes Engine (GKE) nodes without public IP addresses. It allows secure internet access for workloads while maintaining private networking, commonly used for accessing external services like OS updates or external APIs.

### Key Concepts and Deep Dive

Network Address Translation (NAT) translates private IP addresses to public IP addresses for outbound traffic, enabling internal resources to communicate with external networks while maintaining security.

#### How NAT Works
- **Outbound Traffic Only**: NAT allows VMs to initiate connections to the internet, but blocks unsolicited inbound traffic
- **Source NAT**: Translates the source IP address of outgoing packets from private IPs (e.g., 10.5.4.2) to a public NAT IP (e.g., 35.245.65.x)
- **Destination NAT**: Translates the destination IP in responses back to the original private IP
- **Regional Resource**: NAT gateways are regional and apply to all subnets in a region

#### Example Flow
```
VM (10.5.4.2) → MongoDB Request → NAT Gateway → Source IP changed to 35.245.65.x
MongoDB Response → NAT Gateway → Destination IP translated back to 10.5.4.2
```

#### Real-World Analogy
Similar to only accepting expected calls but being able to call anyone. VMs can "call out" to internet services (like MongoDB) but cannot receive direct unsolicited calls from the internet.

### NAT Requirements and Setup

#### Internet Connectivity Requirements
To enable NAT, subnets must have internet connectivity configured:

1. **Default Internet Gateway Route**: Automatically created with VPC, providing a path to 0.0.0.0/0
   ```bash
   # Example: Creating VPC automatically creates this route
   gcloud compute networks create custom-vpc --mode=custom
   ```
   Routes showing default internet gateway: `0.0.0.0/0` → `default-internet-gateway`

2. **Egress Firewall Rules**: Default firewall allows outbound traffic (egress deny rules must not override)

3. **External IP Address OR Cloud NAT**: Either assign external IPs to VMs OR configure Cloud NAT

#### Cloud NAT Configuration
```bash
# Create Cloud Router first
gcloud compute routers create cloud-router-us \
    --network=custom-vpc \
    --region=us-central1

# Create NAT gateway
gcloud compute routers nats create cloud-nat-us \
    --router=cloud-router-us \
    --nat-custom-subnet-ip-ranges=all \
    --nat-external-ip-pool=MANUAL \
    --nat-external-ip-pool-names=my-static-nat-ip \
    --region=us-central1
```

#### NAT Types
- **Automatic IP Allocation**: Dynamic external IP creation, deleted when unused (cost-optimized, no IP whitelisting needed)
- **Manual/Static IP Allocation**: Fixed external IP for whitelisting, persists even when no VMs are active (recommended for production whitelisting)

### Cloud NAT Types and Use Cases

#### Use Cases
- **VM Internet Access**: Servers needing software updates or external API calls
- **Kubernetes Nodes**: GKE clusters accessing external registries
- **Serverless**: Cloud Run, Cloud Functions accessing external services

#### NAT Gateway Modes
- **Public NAT**: Single shared public IP for all outbound traffic
- **Private NAT**: Translation between VPC networks (e.g., for overlapping IP ranges in peering)

## Private NAT for VPC Peering

### Overview
Private NAT enables Network Address Translation between VPC networks, allowing peering even when IP ranges overlap by translating addresses to different ranges.

### Key Concepts and Deep Dive
- Translates IPs between peered networks to resolve conflicts
- Supports source NAT for egress, destination NAT for ingress responses
- Uses BGP for route exchange (unlike static routes)
- Regional per network, applies to all subnets in region

> [!IMPORTANT]
> Private NAT requires manual IP allocation (not auto-allocation)

#### Use Case Example
```
VPC-A (10.0.0.0/16) peers with VPC-B (10.0.0.0/16 - overlapping)
Private NAT translates VPC-A traffic to appear as 192.168.0.0/16 range in VPC-B
```

## Cloud Interconnect Overview

### Overview
Cloud Interconnect provides dedicated, high-bandwidth connections between on-premises networks and Google Cloud, offering superior performance compared to VPN with bandwidth up to 200 Gbps.

### Key Concepts and Deep Dive
- **Dedicated Interconnect**: Direct fiber optic connection to Google Cloud
- **Partner Interconnect**: Connection through service provider
- **Cross-Cloud Interconnect**: Connect to other cloud providers
- **Layer 2 Technology**: Uses Ethernet/VLANs for connectivity
- **Unencrypted by Default**: Private connection, encryption optional via VPN overlay

#### Comparison: Interconnect vs VPN
| Aspect | VPN | Dedicated Interconnect | Partner Interconnect |
|--------|-----|------------------------|-------------------|
| Bandwidth | Up to 3 Gbps (per tunnel) | 10-100 Gbps | 50 Mbps-50 Gbps |
| Encryption | Yes | No (add VPN) | No (add VPN) |
| Setup Time | Minutes | 5+ business days | Varies |
| SLA | End-to-end | Google to edge | Provider to Google |
| Cost | Lower | Higher | Medium |

## Dedicated Interconnect

### Overview
Dedicated Interconnect provides a direct physical connection from on-premises to Google Cloud edge locations, offering maximum bandwidth and lowest latency.

### Key Concepts and Deep Dive
- **Physical Layer 2 Connection**: Direct fiber to collocation facility
- **Bandwidth Tiers**: 10 Gbps (multiples up to 80 Gbps), 100 Gbps (multiples up to 200 Gbps)
- **Redundant Connections**: Minimum 2 links for SLA
- **Setup Requirements**: Must reach Google collocation facility
- **Cost**: Highest but guaranteed performance

#### Supported Bandwidths
- 10 Gbps × N (up to 8 × 10 = 80 Gbps)
- 100 Gbps × N (up to 2 × 100 = 200 Gbps)

#### When to Use
- **High Bandwidth Needs**: >50 Gbps sustained
- **Predictable Latency**: Real-time applications
- **Large Data Transfer**: Terabyte-scale migrations

## Partner Interconnect

### Overview
Partner Interconnect connects through certified service providers when direct access to Google collocation facilities isn't available.

### Key Concepts and Deep Dive
- **Service Provider Partnership**: Uses telecom/carrier infrastructure
- **Flexible Bandwidth**: 50 Mbps to 50 Gbps
- **No Physical Hardware Investment**: Partner manages infrastructure
- **Global Reach**: Available in locations without direct Google presence

#### Supported Providers
- Airtel, Tata Communications, Reliance Jio (India)
- Local carriers worldwide

#### When to Use
- **Geographical Limitations**: Can't reach Google collocation
- **Moderate Bandwidth**: <50 Gbps
- **Quick Setup**: Faster than dedicated interconnect
- **Cost Optimization**: Lower than dedicated interconnect

> [!NOTE]
> SLA provided by partner, not Google directly

## Cross Cloud Interconnect

### Overview
Cross-Cloud Interconnect extends interconnect technology to connect Google Cloud directly with other cloud providers (AWS, Azure, Oracle Cloud).

### Key Concepts and Deep Dive
- **Direct Cloud-to-Cloud Connection**: Private link between providers
- **High Bandwidth**: Up to 200 Gbps
- **Low Latency**: Optimized for inter-cloud communication
- **Use Cases**: Hybrid cloud, disaster recovery, data transfer between clouds

#### Supported Providers
- Amazon Web Services (AWS)
- Microsoft Azure
- Oracle Cloud Infrastructure

#### Example Use Case
```
Google Cloud App → Cross-Cloud Interconnect → Process data in AWS
```

## Direct Peering

### Overview
Google Direct Peering establishes direct layer 3 connections between networks and Google's edge for high-bandwidth access to Google services.

### Key Concepts and Deep Dive
- **Layer 3 Connection**: IP-level routing
- **High Bandwidth**: Up to 10 Gbps per link
- **External IP Usage**: Uses public IP addresses (not RFC 1918)
- **Primary Use**: Google Workspace access (email, docs, etc.)
- **Cost-Effective**: Free setup, pay for bandwidth

#### Requirements
- Submit peering request at peeringdb.google.com/peering
- Meet Google's technical requirements
- Establish BGP session with Google

#### When to Use
- **Google Workspace Integration**: Primary productivity tools
- **High Bandwidth for Google Services**: Cost-effective alternative to interconnect
- **No Private IP Requirements**: Acceptable to use public IPs

## Carrier Peering

### Overview
Carrier Peering uses service provider networks when direct peering requirements cannot be met, providing access to Google services through carriers.

### Key Concepts and Deep Dive
- **Service Provider Network**: Uses carrier infrastructure when direct connection unavailable
- **External IP Routing**: Public IP addresses
- **Lower Bandwidth**: Varies by carrier capability
- **Cost-Effective**: No setup fees

#### When to Use
- **Rejected Direct Peering**: Don't meet Google's requirements
- **Limited Infrastructure**: No direct access available
- **Google Services Access**: Need Google Workspace/API access

## VPC Flow Logs

### Overview
VPC Flow Logs capture network traffic metadata for VMs in subnets, enabling network monitoring, security analysis, and troubleshooting.

### Key Concepts and Deep Dive
- **Subnet-Level Configuration**: Enable per subnet in region
- **Traffic Types**: Captures ingress/egress between VMs
- **Sampling Rate**: 0.0-1.0 (1.0 = 100% traffic)
- **Log Filtering**: Can filter by source/destination IPs, protocols, etc.
- **Cost**: Pay for log storage and processing

#### Log Fields Captured
- Source/Destination IPs
- Ports
- Protocol
- Bytes sent/received
- Connection timestamps

#### Use Cases
- **Security Monitoring**: Detect unusual outbound connections
- **Cost Optimization**: Identify excessive egress traffic
- **Network Troubleshooting**: Debug connectivity issues

#### Configuration Example
```bash
# Enable VPC flow logs on subnet
gcloud compute networks subnets update my-subnet \
    --region=us-central1 \
    --enable-flow-logs \
    --flow-logs-sampling=0.5 \
    --flow-logs-filter='src-ip=10.0.0.0/8'
```

## Network Service Tiers

### Overview
Network Service Tiers determine how traffic routes between Google Cloud and the internet, affecting latency and cost.

### Key Concepts and Deep Dive
- **Premium Tier**: Routes through Google's premium network for lowest latency
- **Standard Tier**: Uses public internet routing for cost savings
- **Regional Setting**: Applies to regional resources
- **Load Balancer Impact**: Affects external load balancer performance

#### Premium vs Standard Tier
| Aspect | Premium Tier | Standard Tier |
|--------|--------------|---------------|
| Latency | Lower (optimized routing) | Higher (public internet) |
| Cost | 25-33% higher | Lower |
| Use Case | User-facing apps | Internal/non-critical |
| Route Type | Google backbone | Public internet |

#### Configuration Examples
```bash
# Set project-wide tier
gcloud compute networks update my-network \
    --network-tier=PREMIUM

# VM with specific tier (requires external IP)
gcloud compute instances create my-vm \
    --network-tier=PREMIUM
```

## Summary

### Key Takeaways
+ ✅ Cloud NAT enables secure outbound internet access for private VMs without external IPs
+ ✅ Interconnect options scale from VPN (3 Gbps) to Dedicated (200 Gbps) based on bandwidth needs
+ ✅ Peering uses public IPs for cost-effective Google services access
+ ✅ VPC Flow Logs provide network traffic visibility for security and optimization
+ ✅ Network Service Tiers balance cost vs performance for internet-bound traffic
- ❌ Cloud NAT only provides outbound connectivity, inbound traffic remains blocked
- ❌ Dedicated Interconnect requires physical connectivity to Google collocation facilities
- ❌ Direct peering uses public IP routing, not suitable for private IP requirements
- ❌ VPC Flow Logs can generate high costs if not properly filtered

### Expert Insight

#### Real-World Application
In enterprise environments, combine multiple network options: use VPN for quick secure connections to development environments, partner interconnect for production workloads requiring 10-50 Gbps bandwidth, and dedicated interconnect for data-intensive applications needing guaranteed 100+ Gbps performance.

#### Expert Path
Master this content by setting up a lab environment with multiple VPCs, configuring different NAT options, establishing partner interconnect relationships, and analyzing flow logs for security insights. Focus on understanding when to choose different interconnect tiers based on bandwidth requirements and cost constraints.

#### Common Pitfalls
- **Choosing wrong interconnect type**: Don't use VPN for bandwidth >3 Gbps; implement interconnects early for high-throughput needs
- **IP overlapping in peering**: Use private NAT to resolve IP conflicts instead of renumbering entire networks
- **Ignoring flow log costs**: Always configure sampling rates and filters to control log volume and expenses
- **Default tier selection**: Question premium tier cost premium - use standard tier for internal/non-critical workloads

#### Lesser-Known Things
Private NAT enables VPC network peering between VPCs with overlapping CIDR ranges by translating IP addresses, a capability introduced in 2022 that simplifies hybrid cloud designs. Interconnect options are regional resources that might require multiple deployments across different Google Cloud regions for global workloads. Flow logs can be exported to BigQuery for advanced analytics and anomaly detection using SQL queries.
