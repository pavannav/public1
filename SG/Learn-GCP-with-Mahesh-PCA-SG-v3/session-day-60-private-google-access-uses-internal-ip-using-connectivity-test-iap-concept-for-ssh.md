# Session 60: Private Google Access Uses Internal IP using Connectivity Test, IAP Concept for SSH

## Table of Contents
- [Private Google Access Overview](#private-google-access-overview)
- [Demonstrating PGA Uses Internal IP Addresses](#demonstrating-pga-uses-internal-ip-addresses)
- [Connectivity Test Demonstrations](#connectivity-test-demonstrations)
- [PGA with NAT](#pga-with-nat)
- [Private Google Access vs Private Service Access](#private-google-access-vs-private-service-access)
- [Identity Aware Proxy (IAP) Concept](#identity-aware-proxy-iap-concept)
- [IAP Tunnel Setup and Requirements](#iap-tunnel-setup-and-requirements)
- [IAP Demos with Different User Roles](#iap-demos-with-different-user-roles)
- [Summary](#summary)

## Private Google Access Overview
Private Google Access (PGA) enables virtual machines (VMs) with only internal IP addresses to access Google Cloud services through internal networks without requiring external IP addresses. This enhances security by reducing exposure to internet attacks while maintaining access to essential Google services.

## Demonstrating PGA Uses Internal IP Addresses

Enable PGA at the subnet level for secure access to Google services from internal-only VM instances.

### Steps to Enable PGA
1. Navigate to VPC network in Google Cloud Console
2. Select the subnet (e.g., us-central1)
3. Enable "Private Google access" for the subnet
4. Create a VM instance on this subnet without external IP

### Key Demonstration Points
- VM instances with only internal IPs can access Google Cloud Storage (GCS), BigQuery, etc.
- Commands like `gsutil ls` and `bq ls` work despite no external IP
- PGA routes traffic through internal network paths

## Connectivity Test Demonstrations

Use Connectivity Test tools to verify internal routing and demonstrate PGA behavior.

### Connectivity Test for Google Services
- Source: Internal IP of PGA-enabled VM
- Destination: Google service IP (e.g., storage.googleapis.com)
- Protocol: TCP, Port 80/443
- Result: Traffic routes through internal gateway, NOT internet

```
curl -I storage.googleapis.com
# Returns HTTP 200 - successful internal connection
```

### Firewall Configuration
PGA requires:
- Default internet gateway (0.0.0.0/0 route) enabled
- Egress firewall rules allowing outbound traffic
- No external IP on VM

### Demonstration: VM Ping vs Connectivity Test
- Direct ping from VM to Google service IPs may fail
- Connectivity Test shows successful routing through PGA
- Confirms internal connectivity despite ping failures

## PGA with NAT

PGA works independently of Cloud NAT. Even when NAT is enabled, Google service traffic still uses internal PGA routes.

### Configuration Steps
1. Create Cloud Router in same network as VM
2. Configure Cloud NAT with the router
3. NAT Configuration:
   - Region matching subnet
   - Network selection
   - Cloud Router attachment

### Demonstration Results
- Google service traffic: Routes through PGA (internal)
- Non-Google service traffic: Routes through NAT (external IP translation)
- Connectivity Test path remains unchanged for Google services after NAT enablement

### Key Observation
```
# Traffic Flow with PGA + NAT
VM → Default Route → Internet Gateway + PGA Static Route → Google Service (Internal)
VM → Default Route → NAT → External Destinations (NAT IP)
```

## Private Google Access vs Private Service Access

Understanding when to apply each private access pattern.

### Private Google Access (PGA)
- **Scope**: Google Cloud services that don't require VPC peering
- **Services**: Cloud Storage, BigQuery, Cloud Functions, etc.
- **Architecture**: No VPC network changes needed
- **When to Use**: Services not using dedicated VPC space

### Private Service Access (PSA)
- **Scope**: Google Cloud managed services requiring VPC connectivity
- **Services**: Cloud SQL, Memorystore, Filestore, etc.
- **Architecture**: Uses VPC peering to connect tenant projects
- **When to Use**: Services with dedicated networking architecture

### Architecture Difference
**GCS (uses PGA)**: No network peering required
**Cloud SQL (uses PSA)**: Requires tenant project + VPC peering

### Key Decision Factors
- Does the service need VPC peering? → Use PSA
- Is the service in your project? → Use PGA
- Does the service require internal IP connectivity? → Depends on implementation

## Identity Aware Proxy (IAP) Concept

IAP provides secure remote access to VMs without external IPs through encrypted TCP tunnels.

### Traditional Bastion Host Issues
- Requires additional VM with external IP
- Potential security exposure
- Cost implications
- Manual configuration complexity

### IAP Solution
- Zero-trust access with fine-grained controls
- Tunnel-based forwarding for SSH/RDP
- No external IPs required on protected VMs
- Cost-effective (no extra VMs needed)

### IAP Architecture
```
User → IAP Tunnel → Client VM (Internal IP only)
     ↑
[Encrypted TCP Tunnel]
```

### Firewall Requirements
- Allow IAP IP ranges: `35.235.240.0/20`
- Port 22 for SSH, 3389 for RDP
- Source: IAP proxy IPs

## IAP Tunnel Setup and Requirements

Configure IAP for secure VM access without external exposure.

### Prerequisites
1. Enable IAP API in project
2. Configure Firewall Rules
3. Set appropriate IAM permissions

### Firewall Configuration
```
Name: allow-iap-ssh
Targets: VM instances
Source IP ranges: 35.235.240.0/20
Protocols/ports: tcp:22
```

### IAM Roles Required
- `iap.tunnelResourceAccessor` - Access to tunnel resources
- `compute.osLogin` - OS Login (recommended over SSH keys)
- `roles/iap.secureTunnelUser` - Secure tunnel access

### Optional Enhanced Permissions
- `compute.instanceAdmin.v1` - VM metadata management
- `iam.serviceAccountUser` - If using service accounts

## IAP Demos with Different User Roles

Demonstrate IAP access control with varying permission levels.

### Owner Access (Full Privileges)
- As project owner, tunnel access works automatically
- No additional configuration needed
- Can access all VMs in project

### Limited User Access (Granular Control)
1. Grant IAP roles at resource level (per VM)
2. Configure OS Login metadata
3. Test tunnel access

### Demonstration Commands
```bash
# Cloud Shell IAP tunnel command
gcloud compute ssh [VM_NAME] --tunnel-through-iap
```

### Access Control Levels
- **Project Level**: Broad access to all VMs
- **Resource Level**: Specific VM access control
- **Service Account Level**: Act-as permissions for additional functionality

### Connection Verification
- User connection shows source IP from IAP ranges (`35.235.240.0/20`)
- No SSH keys required with OS Login enabled
- Secure tunnel established automatically

## Summary

### Key Takeaways
```diff
+ Private Google Access enables internal-only VMs to reach Google Cloud services without external IPs
+ IAP provides secure SSH access to VMs through encrypted tunnels, eliminating bastion host needs
+ PGA vs PSA: PGA for non-VPC services, PSA for VPC-peered managed services
+ Connectivity Tests verify internal routing behavior
+ IAM controls provide fine-grained access management at resource level
+ Default internet gateway required for PGA but traffic remains internal for Google services
```

### Quick Reference
**PGA Firewall Requirements:**
- Default internet route: `0.0.0.0/0`
- Egress allow-all rule
- No external IP needed

**IAP Tunnel Commands:**
```bash
gcloud compute ssh [VM] --tunnel-through-iap --zone=[ZONE]
```

**Key IP Ranges:**
- IAP Proxy: `35.235.240.0/20`
- IPv6 (future): `2600:1900::/28`

### Expert Insight
#### Real-world Application
Secure enterprise environments using PGA and IAP eliminate external IP management complexity while maintaining service connectivity. IAP tunneling enables secure remote administration without VPN overhead, ideal for multi-cloud deployments and regulated industries requiring zero-trust access controls.

#### Expert Path
Deepen understanding by implementing custom IAP applications using the IAP programmatic access APIs. Explore IAP for Web applications with context-aware access policies. Study Google Cloud Armor integration with IAP for advanced threat protection.

#### Common Pitfalls
- Assuming PGA works without default internet gateway
- Forgetting OS Login configuration for keyless SSH
- Over-granting IAP permissions at project level instead of resource level
- Using external IPs when IAP provides equivalent secure access

#### Lesser-Known Facts
- IAP tunneling uses WebSocket connections through HTTPS
- PGA traffic is automatically compressed reducing bandwidth costs
- IAP supports RDP tunneling in addition to SSH
- Private Service Access creates dedicated tenant projects per region for each managed service instance

🤖 Generated with [Claude Code](https://claude.com/claude-code)  
Co-Authored-By: Claude <noreply@anthropic.com>
