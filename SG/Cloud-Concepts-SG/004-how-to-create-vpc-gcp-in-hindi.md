# Session 004: How to create VPC GCP in Hindi

<details open>
<summary><b>004-How-to-create-VPC-GCP-in-Hindi (KK-CS45-script-v2)</b></summary>

# Session 004: How to create VPC GCP in Hindi

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [What is VPC in Google Cloud Platform (GCP)?](#what-is-vpc-in-google-cloud-platform-gcp)
  - [Creating a Custom VPC](#creating-a-custom-vpc)
  - [Subnets in VPC](#subnets-in-vpc)
  - [Regions and Availability Zones](#regions-and-availability-zones)
  - [Service Accounts](#service-accounts)
  - [VPC Traffic Flow](#vpc-traffic-flow)
  - [Cloud Router](#cloud-router)
  - [Global vs Regional VPC](#global-vs-regional-vpc)
- [Lab Demo: Creating a Custom VPC in GCP](#lab-demo-creating-a-custom-vpc-in-gcp)
- [Summary Section](#summary-section)

## Overview
This session covers the creation of Virtual Private Cloud (VPC) networks in Google Cloud Platform (GCP), focusing on custom VPC configurations, subnet management, regional settings, service accounts, traffic flow monitoring, and Cloud Router for BGP connectivity. The tutorial explains the differences between auto-mode and custom-mode VPCs, how to set up subnets in specific regions like South Asia (e.g., Mumbai), and considerations for global versus regional VPC scopes. It also touches on internal communication, external IP management, and automatic route learning in global VPCs.

> [!NOTE]
> The transcript is provided in Hindi, but this study guide summarizes and explains the concepts in English for clarity and accessibility.

## Key Concepts/Deep Dive

### What is VPC in Google Cloud Platform (GCP)?
A Virtual Private Cloud (VPC) is a virtual network environment in GCP that provides isolation, security, and connectivity for your cloud resources such as virtual machines, Kubernetes clusters, databases, and storage. VPCs allow you to define IP address ranges, subnets, routes, and firewall rules.

Key points:
- **Modes**: GPC offers two main VPC modes:
  - **Auto Mode VPC**: Automatically created with default subnets in each region. Suitable for simple setups but lacks customization.
  - **Custom Mode VPC**: Requires manual subnet creation and offers full control over network configuration, IP ranges, and regions.
- VPCs are global resources by default, but their scope can be regional or global depending on Cloud Router configuration.

### Creating a Custom VPC
To create a custom VPC:
1. Navigate to the VPC Network section in the Google Cloud Console.
2. Click on "Create VPC network".
3. Choose "Custom" mode to avoid auto-generated subnets.
4. Provide a name (e.g., "my-custom-vpc").
5. Optionally, set multi-tenancy if using organization-level resources.

The process involves selecting regions and defining IP ranges for controlled networking.

### Subnets in VPC
Subnets are logical subdivisions of a VPC's IP space, each associated with a specific region. They control internal traffic and resource placement.

- **Pri mary IP Range**: Used for VM instances and internal communication (e.g., 10.0.1.0/24).
- **External Connectivity**: Subnets can connect to the internet via Cloud Router or NAT if configured.
- **Private Subnets**: Can access other GCP services without requiring external IPs.

Example subnet configuration:
- Name: subnet-1
- Region: asia-south1 (Mumbai)
- IP Range: 10.0.1.0/24
- If connected to internet, assign external IPs for outbound access.

> [!IMPORTANT]
> Ensure IP ranges do not overlap to avoid routing conflicts.

### Regions and Availability Zones
GCP divides the world into regions (e.g., asia-south1 for Mumbai, South Cast asia regions), each containing multiple availability zones.

- **Selecting Regions**: Choose based on latency, compliance, or cost. For example, asia-south1 for users in South Asia.
- **Zone Affinity**: Subnets are created within specific zones for high availability and fault tolerance.

### Service Accounts
Service accounts are special GCP identities for applications and VMs to access other GCP resources secure y.

- **Permissions**: Grant access to Storage, Compute Engine, etc., without external IPs.
- **Use Case**: Allows VMs to interact with services internally, or monitor traffic flows without internet dependency.
- If services need internet access, assign external IPs carefully.

### VPC Traffic Flow
VPC Flow Logs capture information about IP network flows, helping monitor, diagnose, and optimize traffic.

- **Enable**: Use Console or gcloud to enable flow logs on subnets or VM instances.
- **Use Case**: Understand internal traffic patterns or detect anomalies.

### Cloud Router
Cloud Router is a fully distributed and managed service for dynamic routing in GCP VPCs, supporting BGP for external connectivity.

- **Regional vs Global**:
  - Regional: Manages routes within one region only.
  - Global: Propagates routes across all regions, learning subnets automatically.
- **BGP Configuration**: Set up BGP sessions for peering with external routers.
- **Route Learning**: In global mode, Cloud Router automatically learns all subnets across regions for seamless global routing.

### Global vs Regional VPC
- **Regional VPC**: Scope limited to a single region. Cloud Router learns only local subnets.
- **Global VPC**: Spans multiple regions. Cloud Router automatically includes subnets from all regions for unified routing.

Use cases:
- Regional: For region-specific isolation.
- Global: For multi-region applications needing automated cross-region communication.

## Lab Demo: Creating a Custom VPC in GCP
This demo follows the transcript's steps for creating a custom VPC.

1. **Access Google Cloud Console**:
   - Log in with your Google account.
   - Go to VPC Network > VPC Networks.

2. **Create Custom VPC**:
   - Click "Create VPC network".
   - Name: custom-vpc-demo
   - Mode: Custom

3. **Add Subnet**:
   - Create subnet manually.
   - Name: demo-subnet
   - Region: asia-south1 (Mumbai)
   - IP Range: 10.0.1.0/24
   - Flow logs: Enable if needed for traffic monitoring.

4. **Configure Cloud Router (Optional)**:
   - If enabling BGP, create a Cloud Router.
   - Type: Regional or Global based on needs.
   - Region: asia-south1
   - BGP Settings: Define ASN and peer details.

5. **Verify and Apply**:
   - Review network routes: External IPs for internet access, internal routes for private communication.
   - Ensure service accounts have necessary permissions for Compute Engine or Storage access.

Commands (using gcloud CLI):
```bash
# Create custom VPC
gcloud compute networks create custom-vpc-demo --subnet-mode=custom

# Create subnet
gcloud compute networks subnets create demo-subnet --network=custom-vpc-demo --range=10.0.1.0/24 --region=asia-south1

# Create Cloud Router
gcloud compute routers create demo-router --network=custom-vpc-demo --region=asia-south1 --asn=64512
```

## Summary Section

### Key Takeaways
```diff
+ VPC is a customizable virtual network in GCP for secure resource deployment.
+ Custom VPCs offer control over subnets, regions, and IP ranges.
+ Subnets enable regional isolation and internal communication.
+ Cloud Router with BGP supports advanced routing and external peering.
+ Global VPCs provide cross-region connectivity via automatic route learning.
+ Service accounts allow secure, IP-restricted service interaction.
+ Monitor traffic with VPC Flow Logs for optimization and security.
- Misconfigurations like overlapping IP ranges can cause routing issues.
```

### Quick Reference
| Component | Command/Example |
|-----------|-----------------|
| Create Custom VPC | `gcloud compute networks create vpc-name --subnet-mode=custom` |
| Add Subnet | `gcloud compute networks subnets create subnet-name --network=vpc-name --range=10.0.1.0/24 --region=asia-south1` |
| Enable Flow Logs | `gcloud compute networks subnets update subnet-name --enable-flow-logs` |
| Create Cloud Router | `gcloud compute routers create router-name --network=vpc-name --region=region --asn=64512` |

### Expert Insight

#### Real-world Application
In production, custom VPCs are essential for multi-tenant architectures, where each tenant has isolated subnets. Use Cloud Router for hybrid cloud setups, connecting on-premises networks via VPN or Dedicated Interconnect, ensuring secure BGP routing.

#### Expert Path
- Master VPC peering to connect VPCs without external IPs, reducing security risks.
- Explore Shared VPC for centralized network management in organizations.
- Learn Network Security Groups (Firewalls) and Bastion Hosts for secure access.
- Integrate with Identity-Aware Proxy (IAP) for context-aware access control.

#### Common Pitfalls
- Forgetting to enable Private Google Access for service communication, leading to unwanted external dependencies.
- Overlapping IP ranges in global VPCs, causing routing conflicts.
- Ignoring BGP configuration in Cloud Router, resulting in incomplete route learning across regions.
- Exposing service accounts unnecessarily, increasing security risks.

</details>