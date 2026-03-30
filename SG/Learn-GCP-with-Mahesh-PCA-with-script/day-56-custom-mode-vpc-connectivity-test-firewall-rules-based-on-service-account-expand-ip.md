# Session 56: Custom Mode VPC, Connectivity Test, Firewall Rules Based on Service Account

## Table of Contents
- [Recap of Previous Session](#recap-of-previous-session)
- [Custom VPC Creation and Subnets](#custom-vpc-creation-and-subnets)
- [Firewall Rules for Security](#firewall-rules-for-security)
- [External and Internal IP Management](#external-and-internal-ip-management)
- [IP Reservation and Static IPs](#ip-reservation-and-static-ips)
- [Organization Policies for External IP Restrictions](#organization-policies-for-external-ip-restrictions)
- [Routes in VPC](#routes-in-vpc)
- [Subnet IP Expansion](#subnet-ip-expansion)
- [Auto vs Custom VPC](#auto-vs-custom-vpc)
- [Network Connectivity Testing](#network-connectivity-testing)
- [Best Practices for Firewall Rules](#best-practices-for-firewall-rules)
- [Service Accounts in Firewall Rules](#service-accounts-in-firewall-rules)
- [Lab: Implementing Secure Communication](#lab-implementing-secure-communication)

## Recap of Previous Session

### Overview
In the previous session, we explored Google VPC concepts, highlighting the difference between traditional on-premise VPCs and Google VPC (which is global). We demonstrated creating VMs in different regions that can communicate via internal IP addresses, justifying the avoidance of default VPCs due to eight to nine reasons, including security risks and scalability issues. The session concluded with a custom VPC setup across multiple regions.

### Key Concepts/Deep Dive
- **Google VPC Characteristics**: Global construct allowing VM creation across all regions within a project.
- **Default VPC Pitfalls**: Reasons to avoid include lack of isolation, broad default firewall rules exposing resources, and difficulties in management at scale.
- **Certification Script**: Used to provision VMs in regions like London, Singapore, and US Central with RFC 1918 private IP ranges (10.0.0.0/8, 192.168.0.0/16, 172.16.0.0/12).
- **Communication Testing**: Successful ping via internal IPs demonstrated intra-region and inter-region connectivity.

### Lab Demos
- Created custom subnets in multiple global regions.
- Verified internal IP connectivity across regions using ping commands from VMs.

## Custom VPC Creation and Subnets

### Overview
Building on the previous session, we transition to custom VPC mode for better control. Custom VPC allows creating subnets in specific regions, ensuring isolation and compliance without polluting all regions.

### Key Concepts/Deep Dive
- **Custom VPC Benefits**: Unlike auto mode, custom VPC enables targeted subnet creation, reducing unnecessary resource sprawl.
- **Subnet Regionality**: Subnets are regional resources, tied to specific zones, allowing precise regional deployments.
- **VPC Global Attributes**: Firewall rules and routes associated with VPC are global, even though subnets are regional.

```bash
# Example: Create a custom VPC
gcloud compute networks create custom-vpc --subnet-mode=custom

# Create a subnet in a specific region
gcloud compute networks subnets create subnet-us-central \
  --network=custom-vpc \
  --range=10.0.0.0/24 \
  --region=us-central1
```

| Feature | Default VPC (Auto) | Custom VPC |
|---------|-------------------|------------|
| Scope | All regions | Specific regions |
| Management | Automated | Manual control |
| Firewall Defaults | Broad exposure | User-defined |
| Scalability | High overhead | Optimized |

### Lab Demos
- Created a custom VPC without subnets initially.
- Added regional subnets post-creation.
- Verified regional isolation.

## Firewall Rules for Security

### Overview
Firewall rules control traffic flow in VPCs. By default, incoming traffic is blocked, requiring explicit rules for access. Proper firewall rules are crucial to avoid exposing resources to unauthorized access.

### Key Concepts/Deep Dive
- **Firewall Rule Components**: Direction (ingress/egress), targets (networks, tags, service accounts), source/destination ranges, protocols/ports.
- **AP for TCP Forwarding Range**: Use 35.235.240.0/20 for Google Cloud Shell and other tunneling (verify via cidr.xyz or mxtoolbox).
- **Priority Handling**: Lower priority numbers override higher ones; default deny rules have priority 65535.
- **VPC-Level Application**: Firewall rules apply at VPC level, global in scope.

```yaml
# Example: Firewall rule for SSH via IAP
gcloud compute firewall-rules create allow-ssh-iap \
  --network=custom-vpc \
  --direction=INGRESS \
  --priority=1000 \
  --action=ALLOW \
  --rules=tcp:22 \
  --source-ranges=35.235.240.0/20 \
  --target-tags=allow-ssh
```

### Lab Demos
- Disabled default SSH rule.
- Created IAP-based SSH access rule.
- Tested SSH access using gcloud command with IAP tunneling.

## External and Internal IP Management

### Overview
VMs can have external IPs for public access, but best practices recommend using internal IPs exclusively to minimize exposure. External IPs are costly and insecure.

### Key Concepts/Deep Dive
- **Ephemeral vs Static External IPs**: Ephemeral IPs are temporary and released on stop; static IPs persist but incur costs.
- **Internal IPs**: Always ephemeral within DHCP lease (24 hours), retained across stop/start cycles.
- **Cost Implications**: Free for internal IPs; static external IPs cost ~$3.65/month + usage fees; unused charged double.
- **Motive**: Hate external IPs; restrict via policies or command flags (`--no-address`).

```bash
# Example: Create VM without external IP
gcloud compute instances create my-vm \
  --network=custom-vpc \
  --subnet=subnet-us-central \
  --no-address

# View reserved IPs
gcloud compute addresses list
```

### Lab Demos
- Demonstrated ephemeral IP release on VM stop.
- Created static external IP and observed retention.
- Showed command-line default external IP prevention.

## IP Reservation and Static IPs

### Overview
IP reservation allows fixed IPs for licensing, bindings, or continuity. Internal IPs can be reserved via custom subnets; external requires pool allocation.

### Key Concepts/Deep Dive
- **Internal IP Reservation**: Create subnets with specific ranges; reserve exact IPs within range.
- **External Static IPs**: Google assigns from pool; cannot specify exact IP due to scarcity.
- **Constraints**: Min subnet /29 (4 usable IPs post-4 reserved); avoid over-reservation to prevent cost spikes.
- **Use Cases**: Licensing tied to IP, hosting customer-facing static IPs.

```bash
# Reserve internal IP
gcloud compute addresses create reserved-internal \
  --region=us-central1 \
  --subnet=subnet-us-central \
  --addresses=10.0.0.5

# Create static external IP
gcloud compute addresses create static-external \
  --global  # For global resources like load balancers
```

### Tables

| IP Type | Type | Persistence | Cost | Use Case Restriction |
|---------|------|-------------|------|---------------------|
| Internal Ephemeral | Auto-assigned | Retains across stop/start | Free | N/A |
| Internal Reserved | Manual | Fixed | Free | Within subnet range |
| External Static | Manual | Fixed | $7.25/month unused | Random from pool |
| External Ephemeral | Auto-assigned | Releases on stop | Usage only | N/A |

### Lab Demos
- Reserved internal and external IPs.
- Checked quota limits (~5 VPCs/project increasing via request).
- Demonstrated reservation in custom subnets.

## Organization Policies for External IP Restrictions

### Overview
Use organization policies to enforce no external IPs across projects, enforcing security via guardrails.

### Key Concepts/Deep Dive
- **Policy Enforcement**: Denies VM creation with external IPs; overrides defaults.
- **Break Glass Access**: Allows exceptions for debugging/legacy use.
- **Custom Constraints**: For advanced rules like blocking auto VPC creation via custom expressions (e.g., CEL).

```bash
# Example: Check active policies
gcloud alpha resource-manager org-policies list \
  --resource=projects/my-project

# Enforce no external IP
gcloud organizations set-policy vmExternalIpAccess \
  --organization=your-org-id \
  --constraint=compute.worldSafeWeb:disabled
```

### Lab Demos
- Applied org policy blocking external IPs.
- Attempted VM creation (failed).
- Overrode with exceptions.

## Routes in VPC

### Overview
Routes direct traffic flow; VPC subnets auto-generate routes. Default internet gateway allows outbound; local routes handle internal traffic.

### Key Concepts/Deep Dive
- **Auto-Generated Routes**: One per VPC (internet gateway); one per subnet (local routing).
- **Command Line Insight**: Create VPC with routes visible post-subnet addition.
- **Global Nature**: Routes global despite subnet regionality.

```bash
# View routes
gcloud compute routes list --network=custom-vpc
```

### Lab Demos
- Created VPC without subnets; added one; viewed route additions.
- Demonstrated route terms via apartment/house analogy.

```mermaid
flowchart TD
    A[VM in Singapore] --> B[Egress Firewall (Allowed by Default)]
    B --> C[Route to US (Auto-Generated Local Route)]
    C --> D[Ingress Firewall (VM-Specific Rule)]
    D --> E[Packet Delivered to US VM]
    E --> F[Stateful Response via Firewall Tracking]
    F --> A
```

## Subnet IP Expansion

### Overview
Expand subnets to accommodate more resources without disruption. Custom VPCs expand fully; auto VPCs limit to /16.

### Key Concepts/Deep Dive
- **Expansion Mechanism**: Increase mask (e.g., /29 to /28 doubles IPs); no shrink option.
- **Limits**: Custom VPC to full range (/8 for 10.0.0.0); auto VPC capped at /16.
- **Reasoning**: Avoid broad initial ranges (security/IP overload); mitigate risks in multi-tenancy.

### Lab Demos
- Created /29 subnet (4 IPs).
- Added VMs exhausting IPs.
- Expanded to /28; verified continued access.

## Auto vs Custom VPC

### Overview
Auto VPC auto-creates subnets everywhere (costly), limited expansion. Custom VPC for controlled resource allocation.

### Key Concepts/Deep Dive
- **Regional Expansion**: Prevents IP exhaustion in new regions.
- **Best Practice**: Skip default VPC; use org policies or "skipDefaultNetworkCreation".

### Tables

| Aspect | Auto Mode | Custom Mode |
|--------|-----------|-------------|
| Subnets | All 42 regions | Specific regions |
| Expansion Limit | /20 to /16 | Full range |
| Firewall Rules | Broad defaults | Strict user control |
| Cost | High | Optimized |

### Lab Demos
- Created auto VPC; attempted expansion (failed beyond /16).
- Compared with custom VPC full expansion.

## Network Connectivity Testing

### Overview
Network Intelligence Connectivity Tests visualize traffic paths, aiding troubleshooting without direct access.

### Key Concepts/Deep Dive
- **Test Components**: Source/destination IPs, protocols; simulates real traffic.
- **Visualization**: Shows firewall/route hops for ingress/egress.

### Lab Demos
- Tested Singapore-US communication; viewed route/firewall paths.
- Demonstrated blocked paths (no matching rules).

## Best Practices for Firewall Rules

### Overview
Secure firewall rules prevent unauthorized access. Avoid tags/IP ranges; use service accounts for identity-based control.

### Key Concepts/Deep Dive
- **Tag Risks**: Editable by VM admins; bypass via UI edits.
- **Service Account Security**: Requires "act-as" IAM; immutable without VM restart (detectors trigger alarms).
- **IAM Mitigations**: Custom roles removing "compute.instances.setTags"; enforce least privilege.

```bash
# Firewall rule with service account
gcloud compute firewall-rules create allow-ms1-to-ms2 \
  --network=custom-vpc \
  --direction=INGRESS \
  --action=ALLOW \
  --rules=icmp \
  --source-service-accounts=ms1@project.iam.gserviceaccount.com \
  --target-service-accounts=ms2@project.iam.gserviceaccount.com
```

### Lab Demos
- Demonstrated tag exploitation by user with VM edit rights.
- Showed service account-based rules securing against edits.
- Tested connectivity simulations for secure inter-service communication.

## Service Accounts in Firewall Rules

### Overview
Service accounts enable secure, identity-based firewall rules, aligning with zero-trust principles.

### Key Concepts/Deep Dive
- **Advantages**: Session-based; prevents IP-based bypass; integrates with IAM.
- **Three Methods**: Service account-based (best), custom IAM roles, subnetwork partitioning.
- **Implementation**: Source/target service accounts; protocols specified.

### Lab Demos
- Created rules for front-end to middleware, middleware to backend (not direct to backend).
- Verified via connectivity tests.

## Lab: Implementing Secure Communication

### Overview
Demonstrated secure architecture: Front-end ↔ Middleware ↔ Backend, with firewall rules preventing unauthorized cross-talk.

### Lab Demos
- Configured VMs with distinct service accounts.
- Implemented selective firewall rules.
- Validated allowed/restricted communications.

## Summary

### Key Takeaways
```diff
+ Always use custom VPC mode over auto for control and scalability.
+ Prefer internal IPs only; enforce via org policies to avoid costs and risks.
+ Reserve IPs judiciously; avoid stockpiling external static IPs.
+ Use service accounts for firewall rules instead of tags or IPs for security.
- Avoid external IPs on VMs; they are costly and insecure by default.
- Never use auto VPC; limited expansion and broad exposure.
! Expansion cannot be reversed; plan subnet CIDRs carefully.
```

### Expert Insight
**Real-world Application**: In production, custom VPCs with service account-based firewalls isolate microservices, preventing lateral movement in breaches. Integrate with shared VPC for centralized networking management.

**Expert Path**: Master IAM roles for "serviceAccountTokenCreator"; automate VPC creation with Terraform; monitor with VPC Flow Logs.

**Common Pitfalls**: Over-reserving IPs leads to cost shocks; tags enable easy bypass without alarm triggers; forgetting route auto-generation causes isolation issues. Always test expansions and rely on connectivity tools for validation. Avoid broad rules—group workloads logically with service accounts. Errors include "AP" (likely IAP for Identity-Aware Proxy) misspellings and phrasing like "y number of scenarios" (use "a number of"). If holistic expansion planned, simulate with large CIDRs but prefer granular for security.
