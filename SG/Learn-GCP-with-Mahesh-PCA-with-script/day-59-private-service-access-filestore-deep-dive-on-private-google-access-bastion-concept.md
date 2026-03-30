# Session 59: Private Service Access & Filestore, Deep dive on Private Google Access, Bastion Concept

## Table of Contents
- [Overview](#overview)
- [Private Service Access](#private-service-access)
- [Filestore](#filestore)
- [Deep Dive on Private Google Access](#deep-dive-on-private-google-access)
- [Bastion Concept](#bastion-concept)

## Overview
Session 59 explores Google Cloud networking concepts focusing on private connectivity. It builds on VPC network peering concepts for shared VPC, covering how services like Cloud SQL, Memorystore, and Filestore use private service access in shared environments. The session then deep dives into private Google access for broader connectivity, and discusses why bastion hosts are not needed in Google Cloud compared to traditional environments.

## Private Service Access

### Shared VPC and Private Service Access
- Shared VPC host project manages network resources
- Service projects use shared VPC but need private service access for specific services
- Cloud SQL and Memorystore use private service access by default
- Private service access creates VPC network peering behind the scenes
- Pairs resources between service project and shared VPC network

### Service Networking APIs
- Private service access requires Service Networking API enabled
- Allocates dedicated IP ranges (/20, /24, etc.) for Google services
- Managed peering connections between Google service networks and customer VPCs
- Supports ~15 Google-managed services requiring VPC-level connectivity

### IAM Permissions for Shared VPC
- Network user compute network user role granted at subnetwork level
- Additional roles needed for private service access setup:
  - Compute network viewer role for viewing existing ranges
  - Service networking admin role for creating connections
- Shared VPC network admins perform setup, not individual service owners

```bash
# Example: Creating Cloud SQL with private IP
gcloud sql instances create INSTANCE_NAME \
  --project=SERVICE_PROJECT \
  --network=projects/HOST_PROJECT/global/networks/VPC_NAME \
  --no-assign-ip \
  --allocate-ip-range \
  --range-name=SQL_RANGE
```

## Filestore

### Filestore Networking Requirements
- Unlike compute resources, Filestore only requires VPC network
- No subnetwork dependency - works with shared VPC network alone
- Creates dedicated pairing connections in private service access
- Allocates IP ranges within configured private service connection space

### Creating Filestore in Shared VPC
- Use shared VPC network through "Use an existing IP range" option
- Network admins prepopulate ranges that service project users can select
- Automatic allocation also available but less predictable
- Region selection important for latency optimization

### FilestoreNetworkTopology
- Cross-region pairing adds latency
- Same region pairing shows <100ms performance
- Regional pairings create dedicated routes similar to other services
- Multiple filestore instances share same private service connection

## Deep Dive on Private Google Access

### Fundamental Concept
- Enables VMs without external IP addresses to access Google Services
- Routes traffic internally through Google's backbone infrastructure
- Proxies all Google API calls and service access
- Activated at subnetwork level on an opt-in basis

```yaml
# Terraform example for private Google access
resource "google_compute_subnetwork" "subnet" {
  name          = "private-subnet"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"

  private_ip_google_access = true
}
```

### Use Cases
- **Production Environments**: VMs with only internal IP addresses accessing Google Services
- **Compliance**: Restrict outbound traffic to Google services only
- **Security**: No internet exposure while accessing cloud resources

### Scope of Services
- **Access**: All Google APIs and Google Cloud services
- **Exceptions**: Fallback to other services slows connectivity
- **Global Reach**: Connects via any Google infrastructure region

### Implementation Steps
1. Enable Private Google Access on target subnet
2. Remove external IP addresses from VMs
3. Configure IAM roles for specific service access
4. Test connectivity to Google APIs and cloud console

### Performance Considerations
- **Regional Latency**: Same region access shows minimal delay (~5-10ms)
- **Cross-region Issues**: Long distance connectivity shows significant latency (800+ms)
- **Bandwidth**: Google backbone performs as internal routing

## Bastion Concept

### Traditional Bastion Hosts
- Jump hosts with external IP addresses in DMZ networks
- Required for SSH access to private IP only instances
- Single point of access requiring hardened security configurations
- Operational overhead: patching, monitoring, resource allocation
- Cost factors: external IP charges, compute resources, operational staff

### Cost Analysis
- External static IP: ~$3.65/month
- VM resources: Standard configuration minimum requirements
- Security monitoring: Dedicated operational resources
- Potential attack surface: Exposed external endpoint

### Google Cloud Alternative
- **Identity-Aware Proxy (IAP)**: Tunnel connections without external IPs
- **SSH from Console**: Direct web-based access to VMs
- **AP Desktop**: Client application for secure tunneling
- Zero external IP requirement eliminates attack vectors

### Advantages over Bastion Approach
- **Zero Trust Security**: Per-user authentication without exposed endpoints
- **Cost Efficiency**: No external IP charges or dedicated jump resources
- **Simplified Operations**: No maintenance required for bastion infrastructure
- **Scalability**: Direct tunneling scales with demand without resource contention

## Summary

### Key Takeaways
```diff
+ Private service access creates VPC peering for specific Google services requiring network connectivity (Cloud SQL, Memorystore, Filestore)

+ Private Google access enables VMs with internal IPs only to access all Google APIs and services through proxy routing

+ Shared VPC environments require network admin roles for service access setup - users need additional permissions beyond standard network user roles

+ Bastion hosts are unnecessary in Google Cloud due to IAP tunneling capabilities

+ Choose private Google access for Google-only access, NAT for broader internet while maintaining Google service connectivity

- Cross-region service access introduces significant latency (100ms+)

- Default shared VPC permissions insufficient for private service range viewing
```

### Expert Insight
**Real-world Application**: Enterprise environments leverage shared VPC with private service access for database workloads across hundreds of service projects, maintaining centralized network oversight while enabling developer autonomy.

**Expert Path**: Master VPC flow logs analysis alongside private Google access to troubleshoot connectivity issues; develop automation scripts for routine IAM permission grants across shared VPC environments.

**Common Pitfalls**:
- Forgetting to enable Service Networking API before attempting resource creation
- Assigning insufficient IAM roles for private service access configuration
- Ignoring regional latency impacts when deploying services across multiple zones

**Lesser Known Things**: Private Google access enables browser-based RDP to Windows VMs without external IPs using AP Desktop, providing secure remote desktop access for administrative purposes. Google Cloud actually turns on private Google access automatically when you configure Cloud NAT, making the explicit setting often redundant.</parameter>
