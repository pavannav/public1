# Session 61: Identity Aware Proxy Demystification, Private GKE Cluster Concepts using Alias IP

- [Identity Aware Proxy (IAP) Fundamentals](#identity-aware-proxy-iap-fundamentals)
- [IAP SSH Tunneling and Access Controls](#iap-ssh-tunneling-and-access-controls)
- [IAP Desktop and Advanced Configurations](#iap-desktop-and-advanced-configurations)
- [Multiple GCloud Configurations](#multiple-gcloud-configurations)
- [Domain Restricted Sharing](#domain-restricted-sharing)
- [Secondary IP Ranges and Alias IPs](#secondary-ip-ranges-and-alias-ips)
- [Private Kubernetes Clusters](#private-kubernetes-clusters)

## Identity Aware Proxy (IAP) Fundamentals

### Overview
Identity Aware Proxy (IAP) is a Google Cloud service that allows secure access to internal applications and VMs without exposing them to the public internet. It provides context-aware access control and identity-based authentication, controlling who can connect to specific resources within a GCP project.

### Key Concepts

IAP functions as a toll booth ▶️ ensuring only authorized users with proper roles can access protected resources. For VMs, IAP enables SSH connections through secure tunnels without requiring external IP addresses.

### Accessing VMs through IAP

**VM Access Scenarios:**
- **VMs with Internal IP Only**: Requires IAP secure tunnel user role for access
- **VMs with External IP**: Can be accessed with OS login role, but IAP adds security controls
- **Firewall Rules**: Must allow IAP's IP ranges (35.235.240.0/20 for SSH)

🚨 **Important**: IAP only comes into play for VMs with internal IP addresses. VMs with external IPs can still be accessed directly if firewall rules allow it, but IAP provides additional security layer.

## IAP SSH Tunneling and Access Controls

### SSH Access with Different Roles

```diff
+ Simple GCP User with Secure Tunnel User role: Can SSH into internal IP VMs
+ Simple GCP User without required roles: Blocked from tunnel access
+ Owner: Always has access to all VMs (includes tunnel user privileges)
```

### Tunneling Mechanism

IAP creates secure tunnels for SSH connections:
1. User authenticates with Google identity
2. IAP validates permissions for specific VM
3. If authorized, establishes secure tunnel
4. User gains SSH access without exposing VM to internet

### Command Line vs UI Access

**UI Access**: Uses automatic tunneling without explicit configuration
**Command Line**: Requires proper gcloud configuration and network connectivity

> [!WARNING]
> VMs with external IPs may show IAP-related error messages in UI even when direct access is possible via firewall rules.

## IAP Desktop and Advanced Configurations

### IAP Desktop Tool

A Windows-specific desktop application for accessing multiple VMs:
- Supports connection to VMs with internal IPs only
- Provides easy-to-use interface for managing multiple VM connections
- Available for Windows users (no Linux/Mac version mentioned)

### Advanced SSH Configurations

**Manual Tunnel Creation**:
```bash
gcloud compute start-iap-tunnel INSTANCE_NAME 8080 --local-host-port=localhost:8080 --zone=ZONE
```

**SSH Key Management**:
- Generate SSH keys for passwordless authentication
- Add public keys to VM metadata
- Enable OS login for user-specific access control

### Performance Considerations

> [!NOTE]
> Connecting through IAP may introduce slight tunneling performance overhead. Consider installing `numpy` for Python-based tunneling improvements if using the IAP tunnel.

## Multiple GCloud Configurations

### Configuration Profiles

**Use Cases**:
- Working with multiple GCP projects/organizations
- Different account permissions for various clients
- Contractor scenarios requiring separate authentication contexts

**Configuration Management**:
```bash
gcloud config configurations list        # List all profiles
gcloud config configurations activate CONFIG_NAME  # Switch contexts
gcloud config configurations create NEW_CONFIG     # Create new profile
```

### Authentication Patterns

**Single Organization**: Use default profile with project-specific roles
**Multi-Organization**: Create separate configurations for each organization with appropriate credentials

## Domain Restricted Sharing

### Organization Policies

**Domain Restriction Controls**:
- Restrict GCP resource access to specific Google Workspace/Cloud Identity domains
- Prevent external users from gaining access to organization resources
- Enforce security boundaries between different business units

```bash
# Restrict to specific domains
gcloud resource-manager org-policies set-policy POLICY_FILE \
--organization=ORGANIZATION_ID
```

### Configuration Impact

> [!WARNING]
> Incorrect domain restriction policies can lock out legitimate users. Always test policies in non-production environments before applying to production resources.

```diff
- Domain restrictions not enforced: All users can be granted access
- Domain restrictions enforced: Only users from allowed domains can be added to IAM policies
```

## Secondary IP Ranges and Alias IPs

### IP Range Management

**Secondary Ranges in VPC**:
- Extend subnet capacity beyond primary IP range
- Enable alias IPs for container-based workloads
- Support microservices architectures with IP-based service isolation

```bash
# Add secondary ranges to subnet
gcloud compute networks subnets update SUBNET_NAME \
--add-secondary-ranges=RANGE_NAME=RANGE_CIDR
```

### Alias IP Implementation

**VM Configuration**:
- Assign multiple IP addresses to single network interface
- Eliminate port-based application multiplexing
- Enable direct IP-based application access

**Kubernetes Integration**:
- Pod IPs sourced from secondary ranges using alias IPs
- Enhanced security through IP-based policies
- Simplified network architecture (no port mapping required)

### Cost Considerations

> [!IMPORTANT]
> Internal IP addresses have no incremental cost. External IP reservations cost $7.29/month when not attached to active resources.

## Private Kubernetes Clusters

### Cluster Types Comparison

| Cluster Type | Worker Nodes | Control Plane Access | Use Case |
|-------------|-------------|---------------------|---------|
| Public Cluster with Public Endpoint | External IPs | Public + Private | Development/Test |
| Private Cluster with Public Endpoint | Internal IPs | Public + Private | Staging/Development |
| Private Cluster with Private Endpoint | Internal IPs | Private Only | Production |

### Configuration Parameters

**Private Cluster Settings**:
```bash
# Enable private nodes (worker nodes get internal IPs only)
gcloud container clusters create CLUSTER_NAME \
--enable-private-nodes \
--enable-ip-alias \
--cluster-secondary-range-name=POD_RANGE \
--services-secondary-range-name=SERVICE_RANGE

# Control plane access (optional - defaults to enabled)
--master-authorized-networks=AUTHORIZED_NETWORKS  # Restrict control plane access
```

### Networking Requirements

**VPC Native Routing**: Essential for proper alias IP functionality in GKE
**Secondary Ranges**: Required for pod and service IP allocation
**Shared VPC**: Recommended for multi-project cluster deployments

### Endpoint Configuration

**Public Endpoint**: Control plane accessible from internet (with authentication)
**Private Endpoint**: Control plane only accessible within VPC network
**Authorized Networks**: Restrict control plane access to specific CIDR ranges

> [!NOTE]
> Private clusters with public endpoints still require private worker nodes for security benefits.

## Summary

### Key Takeaways
```diff
+ Identity Aware Proxy secures VM access without external IPs
+ Alias IP ranges enable IP-based service isolation in microservices
+ Private GKE clusters with private endpoints maximize security boundaries
+ Domain restrictions enforce organization-level access controls
+ Multiple gcloud configurations support multi-project/organization workflows
```

### Quick Reference
**Common IAP Roles**:
- `roles/iap.tunnelResourceAccessor` - Access through IAP tunnels
- `roles/compute.osLogin` - OS-level user management
- `roles/compute.osAdminLogin` - Administrative OS access

**Critical Commands**:
```bash
# IAP tunnel creation
gcloud compute start-iap-tunnel INSTANCE_NAME INSTANCE_PORT --local-host-port=LOCAL_PORT

# Kubernetes cluster with private endpoints
gcloud container clusters create CLUSTER_NAME \
--enable-private-nodes \
--enable-private-endpoint \
--enable-ip-alias \
--cluster-secondary-range-name=POD_RANGE \
--services-secondary-range-name=SERVICE_RANGE
```

### Expert Insight

#### Real-world Application
Private GKE clusters with private endpoints are essential for production workloads requiring maximum security. Enterprises deploy bastion hosts within the same VPC for administrative access to private clusters, ensuring all management traffic remains within private networks.

#### Expert Path
Master the interplay between IAP, VPC-native routing, and private clusters. Focus on implementing least-privilege access patterns using resource-level IAM roles and network policies.

#### Common Pitfalls
- Incorrect secondary range sizing leading to IP exhaustion
- Overlapping IP ranges between pods and services
- Insufficient firewall rules for IAP IP ranges (35.235.240.0/20)
- Domain restriction policies blocking legitimate user access

#### Lesser-Known Facts
- IAP tunneling works across different regions within the same VPC
- Alias IPs can provide up to 100 pods per node without NAT complexity
- Private clusters support workload identity federation for service account management
