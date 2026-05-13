# Session 19: Creating a VPC in GCP
<details open>
<summary><b>[Session 19: Creating a VPC in GCP] (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [VPC Fundamentals](#vpc-fundamentals)
- [Default VPC Network](#default-vpc-network)
- [Creating Custom VPC Networks](#creating-custom-vpc-networks)
- [IPv6 Support and Configuration](#ipv6-support-and-configuration)
- [Subnet Management](#subnet-management)
- [Firewall Rules and Security](#firewall-rules-and-security)
- [Advanced VPC Features](#advanced-vpc-features)
- [VPC Management and Operations](#vpc-management-and-operations)

## Overview
This session covers the essential concepts of Virtual Private Clouds (VPCs) in Google Cloud Platform. A VPC is a virtual network that provides connectivity to Google Cloud services like Compute Engine, Kubernetes Engine, and App Engine. Built on Google's Andromeda network algorithm, VPCs enable secure communication between cloud resources and can connect to on-premises networks via Cloud VPN and Cloud Interconnect.

Key session topics include VPC architecture, subnet creation, IPv4/IPv6 configuration, firewall rules, and advanced features like Private Google Access and flow logging.

## VPC Fundamentals

### Global Resource Architecture
VPCs are **global resources** that span the entire GCP infrastructure, unlike subnets which are **regional resources**. This global nature enables seamless connectivity across regions while maintaining regional isolation for resources.

### Regional vs Global Resources
- **VPC (Global)**: Defined at project level
- **Subnets (Regional)**: Span across all zones within a region
  - Example: Mumbai region contains multiple subnets, each covering all Mumbai zones
  - Multiple subnets can exist in the same region (with non-overlapping IP ranges)

### IP Address Management
Each subnet defines a range of IPv4 addresses (and optionally IPv6 addresses) used by:
- Compute Engine VMs
- Kubernetes Engine (GKE) clusters
- App Engine Flex environments
- Load balancers (TCP/UDP)

## Default VPC Network

### Auto Subnets Mode
Google automatically creates a default VPC in every new project with auto subnets:
- Available in all 35+ GCP regions
- Each region gets a /20 IPv4 network range
- Pre-configured firewall rules for internal traffic

### Default Firewall Rules
The default VPC includes four auto-generated firewall rules:

```yaml
# Allow Internal Traffic
name: default-allow-internal
source-ranges: 10.128.0.0/9
targets: null
rules:
  icmp: allow
  tcp: allow
  udp: allow

# Allow ICMP (ping)
name: default-allow-icmp
source-ranges: 0.0.0.0/0

# Allow RDP (Windows)
name: default-allow-rdp
source-ranges: 0.0.0.0/0

# Allow SSH (Linux)
name: default-allow-ssh
source-ranges: 0.0.0.0/0
```

### Built-in Security Rules
Two immutable rules cannot be deleted:
- **Deny all ingress**: Blocks all incoming traffic (lowest priority)
- **Allow all egress**: Permits all outgoing traffic from VMs

> [!IMPORTANT]
> The deny all ingress rule means you must explicitly create firewall rules with lower priority numbers (e.g., 100) to allow inbound traffic to your VMs.

### Network Isolation
VPCs provide complete isolation between networks:
- VMs in VPC-A cannot communicate with VMs in VPC-B except via public internet
- Useful for multi-tenant architectures and security segmentation

## Creating Custom VPC Networks

### VPC Creation Options
When creating a new VPC, choose between:
1. **Automatic Mode**: Creates subnets in all regions (similar to default VPC)
2. **Custom Mode**: Manually define subnet configurations

```yaml
# Custom VPC Creation Example
gcloud compute networks create my-custom-vpc \
  --project=my-project \
  --description="Custom VPC for application isolation" \
  --mtu=1460
```

### Custom Subnet Configuration
For custom VPCs, specify subnet details during creation:
- **Subnet Name**: Descriptive identifier
- **Region**: Target GCP region (e.g., asia-south1)
- **IP Range**: CIDR notation (e.g., 192.168.0.0/24)
- **Stack Type**: Single stack (IPv4 only) or Dual stack (IPv4 + IPv6)

### Subnet IP Range Conflicts
VPCs enforce IP range isolation:
- Subnets within the same region cannot have overlapping IP ranges
- GCP validates IP range conflicts during subnet creation/modification

## IPv6 Support and Configuration

### IPv6 Architecture
Google Cloud VPCs support native IPv6 implementation:
- IPv6 ranges allocated from Google's global IPv6 address space
- Supports both internal and external IPv6 addressing

### IPv6 Allocation Options
VPCs support three IPv6 allocation strategies:
1. **Automatic Google Allocation**: GCP assigns /48 range globally unique
2. **Manual Assignment**: Specify custom IPv6 prefix (for BYOIP scenarios)
3. **Dual Stack Support**: Run IPv4 and IPv6 simultaneously

### Stack Type Configuration
Choose between stack types per VPC (not per subnet):
- **Single Stack (IPv4 only)**: Traditional IP addressing
- **Dual Stack**: Both IPv4 and IPv6 addresses available

```bash
# Switch from dual stack to single stack using gcloud
gcloud compute networks subnets update test-subnet \
  --project=my-project \
  --region=asia-south1 \
  --stack-type=IPV4_ONLY
```

### IPv6 Types in GCP VPC
- **Internal IPv6**: Used within VPC network (routed internally)
- **External IPv6**: Publicly routable IPv6 addresses
- `/64` prefix length for subnets (96 usable host bits)

## Subnet Management

### Creating Additional Subnets
Multiple subnets per region are supported:
- Each subnet must have non-overlapping IP ranges within the VPC
- Useful for multi-tier application architectures (web tier, app tier, database tier)

### Secondary IP Ranges
Allocate secondary IP ranges for specialized use cases:
```yaml
# Examples of secondary IP range usage
secondaryIpRanges:
  - rangeName: gke-pods
    ipCidrRange: 10.10.0.0/16
  - rangeName: gke-services
    ipCidrRange: 10.11.0.0/24
```

### Private Google Access
Enable VMs without external IP to access Google APIs:
```yaml
# Enable Private Google Access per subnet
privateGoogleAccess: enable
```

>
//  **Benefits**:
//  - Secure access to Cloud Storage, BigQuery, etc.
//  - No external IP required on VM instances
//  - Traffic stays within Google's private network

### Subnet Expansion
Expand subnet IP ranges to accommodate growth:
- **Expand Operation**: Increase IP capacity (e.g., from /24 to /23)
- **One-way Operation**: Cannot shrink subnets back to smaller ranges
- **Auto Mode Limitation**: Auto subnets cannot expand beyond /16 to prevent conflicts with predefined ranges

> [!NOTE]
> Plan subnet sizing carefully as expansion is irreversible. Consider future growth requirements and application architecture needs.

### VPC Mode Conversion
- **Auto → Custom**: Convert legacy auto-mode VPCs to custom mode
- **One-way Operation**: Cannot convert custom back to auto mode
- Use organization policies to prevent automatic default VPC creation

## Firewall Rules and Security

### Priority-Based Rule Evaluation
Firewall rules use numeric priorities (0-65535):
- **Lower priority numbers = Higher precedence**
- **Priority Range**: 0-65535 (0 highest, 65535 lowest)
- **Immutable Rules**: deny-all-ingress (65535) and allow-all-egress (65534)

### Traffic Direction Handling
- **Ingress Rules**: Control inbound traffic to VMs
- **Egress Rules**: Control outbound traffic from VMs
- Identity-aware proxy integration for advanced access control

### Rule Management Best Practices
```yaml
firewall-rules:
  - name: allow-web-traffic
    network: my-vpc
    priority: 100  # Higher precedence than auto rules
    direction: INGRESS
    sourceRanges:
      - 0.0.0.0/0
    targetTags:
      - web-server
    allowed:
      - protocol: tcp
        ports: [80, 443]
```

## Advanced VPC Features

### Flow Logs
Capture network traffic metadata for analysis:
- **Aggregation Interval**: 5 sec, 30 sec, 5 min, 10 min, 15 min
- **Sample Rate**: 0.0-1.0 (0.50 = 50% of flows captured)
- **Storage**: Cloud Logging or Cloud Storage
- **Costs**: Monitor usage as logs consume storage and processing resources

### Dynamic Routing Mode
Configure BGP route exchange behavior:
- **Regional Mode**: Routes from selected region shared locally
- **Global Mode**: Routes from all regions exchanged through single router
  - Useful for hub-and-spoke topologies
  - Simplifies route management in multi-region architectures

```yaml
# Global dynamic routing configuration
dynamicRoutingMode: GLOBAL
bgpRouters:
  - name: mumbai-router
    region: asia-south1
    asn: 64512
    advertisedRoutePriority: 100
```

### MTU Configuration
Maximum Transmission Unit settings:
- **Default MTU**: 1460 bytes
- **Jumbo Frames**: Support for larger packet sizes (up to 8896 bytes)
- **Path MTU Discovery**: Automatic adjustment for optimal data transfer

## VPC Management and Operations

### VPC Lifecycle Operations
Common maintenance tasks include:
- **Subnet Range Expansion**: Increase IP capacity as needed
- **Stack Type Modification**: Switch between IPv4-only and dual stack
- **Firewall Rule Optimization**: Modify priorities and target definitions
- **Flow Log Tuning**: Adjust aggregation intervals and sampling rates

### Resource Dependencies
VPC management considers existing resources:
- Running VMs retain existing IP configurations during subnet modifications
- IPv6 address assignments maintained during stack type changes
- Route table updates propagate automatically across regions

### Network Architecture Planning
Strategic considerations for VPC design:
- **IP Range Planning**: Avoid future conflicts through proper CIDR allocation
- **Region Selection**: Minimize latency for primary user locations
- **Security Zoning**:-segment applications using multiple VPCs
- **Cost Optimization**: Balance compute, network, and storage expenses

## Summary

### Key Takeaways
```diff
+ GCP VPCs are global resources spanning all regions, with subnets providing regional isolation
+ Default VPC auto-creates subnets in all regions with pre-configured firewall rules
+ Custom VPCs enable fine-tuned control over IP ranges, regions, and advanced features
+ IPv6 support includes automatic allocation and dual-stack operations
+ Private Google Access enables secure API access without external IPs
+ Firewall rules use priority-based evaluation (lower numbers = higher precedence)
+ Subnet expansion is one-way; plan IP ranges for future growth
+ Flow logs and dynamic routing provide advanced networking capabilities
- IP range conflicts prevent subnet creation and expansion
- No automatic rollback for subnet range changes or VPC mode conversions
- Flow logs consume storage and processing resources requiring cost monitoring
```

### Quick Reference

#### Common Commands
```bash
# Create custom VPC
gcloud compute networks create my-vpc --subnet-mode=custom

# Create subnet with dual stack
gcloud compute networks subnets create my-subnet \
  --network=my-vpc \
  --region=us-central1 \
  --range=192.168.1.0/24 \
  --stack-type=IPV4_IPV6

# Switch subnet stack type
gcloud compute networks subnets update my-subnet \
  --stack-type=IPV4_ONLY

# Enable Private Google Access
gcloud compute networks subnets update my-subnet \
  --enable-private-ip-google-access
```

#### Firewall Rule Priority Examples
- **Priority 0**: Highest precedence (critical security rules)
- **Priority 100**: Application-specific rules
- **Priority 65535**: deny-all-ingress (lowest precedence, immutable)

#### IP Range Calculator
- **/24 subnet**: 256 addresses (254 usable)
- **/20 subnet**: 4096 addresses (4094 usable)
- **/16 subnet**: 65,536 addresses (65,534 usable)

### Expert Insight

#### Real-world Application
VPCs serve as the foundation for secure cloud architectures. Production deployments typically use:
- **Hub-and-spoke topology** with shared VPCs for multi-team isolation
- **Private Google Access** to securely access managed services
- **Global load balancers** leveraging cross-region subnet connectivity
- **Cloud VPN/Interconnect** for hybrid cloud connectivity

#### Expert Path
Master advanced networking by:
1. Understanding BGP routing fundamentals
2. Designing IP address schemes for scale
3. Implementing least-privilege security policies
4. Monitoring network performance with flow logs
5. Planning disaster recovery across regions

#### Common Pitfalls
- **Insufficient IP Planning**: Underestimating future growth leads to complex subnet expansions
- **Firewall Rule Misconfiguration**: Incorrect priority settings can expose services unexpectedly
- **Auto-to-Custom Conversion**: Irreversible change requires careful planning
- **MTU Mismatch**: Different MTU settings cause fragmentation and performance issues
- **Flow Log Over-aggregation**: Too-frequent sampling increases costs without value
</details>