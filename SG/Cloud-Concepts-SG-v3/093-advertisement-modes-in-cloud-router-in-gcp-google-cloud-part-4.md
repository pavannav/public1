# Session 93: Advertisement Modes in Cloud Router in GCP Part 4

<details open>
<summary><b>Session 93: Advertisement Modes in Cloud Router in GCP Part 4 (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [What are Advertisement Routes?](#what-are-advertisement-routes)
  - [MULTIEXIT DISC (MED/M) in BGP Routing](#multiexit-disc-medm-in-bgp-routing)
  - [Advertisement Mode Configurations](#advertisement-mode-configurations)
  - [Default Advertisement Mode](#default-advertisement-mode)
  - [Custom Advertisement Mode](#custom-advertisement-mode)
  - [BGP Session Level Configuration](#bgp-session-level-configuration)
  - [Practical Implementation and Traffic Engineering](#practical-implementation-and-traffic-engineering)
- [Summary Section](#summary-section)

## Overview
This session covers **Advertisement Modes in Cloud Router (GCP)**, focusing on how to configure BGP prefix advertisement at both the cloud router and individual BGP session levels. The session explains the difference between default and custom advertisement modes, demonstrates practical configuration through GCP Console, and shows how to implement traffic engineering by routing different subnets through specific VPN tunnels.

## Key Concepts and Deep Dive

### What are Advertisement Routes?
Advertised routes are BGP prefixes that Cloud Router shares with BGP peers (on-premises routers, other cloud providers, or other GCP VPCs). When you advertise a subnet, you're essentially telling your BGP peer: "This network range is accessible through me - you can send traffic to destinations in this range via our connection."

**Key Points:**
- Enables connectivity between your VPC and external networks
- Uses MultiExit Discriminator (MED/M) values to influence path selection
- Can advertise entire VPC subnets or custom CIDR ranges

> [!NOTE]
> Advertisement routes work bidirectionally - you advertise outbound routes to allow peers to reach your networks, while also learning inbound routes from peers to reach their networks.

### MULTIEXIT DISC (MED/M) in BGP Routing
MED (MultiExit Discriminator) is a BGP attribute used to influence path selection between multiple exit points to the same destination. Lower MED values are preferred.

**How it works:**
- When advertising routes, Cloud Router assigns MED values to each prefix
- BGP peers use MED to choose preferred paths
- Enables primary/secondary path configurations based on bandwidth, latency, or other criteria

### Advertisement Mode Configurations
Advertisement modes can be configured at two levels:
1. **Cloud Router Level**: Affects all BGP sessions within that router (default behavior)
2. **BGP Session Level**: Allows per-session customization, overriding router-level settings

### Default Advertisement Mode
The default advertisement mode automatically advertises all subnets visible to the Cloud Router.

**Behavior:**
- For regional VPCs: Only advertises subnets in the same region as the Cloud Router
- For global VPCs: Advertises all subnets across all regions
- Automatically adds new subnets when they're created
- Requires no manual configuration

### Custom Advertisement Mode
Custom mode provides granular control over which IP ranges are advertised.

**Options:**
1. **All subnets + custom ranges**: Advertises local subnets plus additional custom CIDR blocks
2. **Custom ranges only**: Only advertises explicitly defined custom ranges

**Common Use Cases:**
- **Summarization**: Avoid hitting BGP quota limits by advertising aggregated ranges instead of individual /28 subnets
- **Selective routing**: Only expose specific internal networks to peers
- **VPC peering integration**: Advertise custom routes created through VPC peering

### BGP Session Level Configuration
BGP session-level configuration allows different advertisement behavior per VPN tunnel or interconnect attachment.

**Key Features:**
- **Inherit**: Use cloud router's advertisement configuration
- **Custom**: Define session-specific advertisement rules
- Independent of cloud router settings - new subnets added to cloud router won't automatically appear in custom-configured sessions

### Practical Implementation and Traffic Engineering

#### VPC Peering with Custom Advertisement
Here's a demonstration of advertising VPC peering routes:

1. Create VPC peering between two GCP VPCs
2. Configure custom advertisement at Cloud Router level
3. Add the peered VPC's subnet ranges as custom advertised routes

```yaml
advertisement-config:
  mode: CUSTOM
  # Include all local subnets
  all-subnets: true
  # Plus specific custom ranges
  custom-ranges:
    - 10.1.0.0/16
    - 10.160.0.0/20
```

#### Per-Session Traffic Engineering
Configure different BGP sessions to advertise different subnets for traffic segregation:

```yaml
# Session 1 Configuration
bgp-session-1:
  advertisement-mode: CUSTOM
  custom-ranges:
    - 10.0.1.0/24    # Primary subnet
    - 10.0.2.0/24    # Secondary subnet

# Session 2 Configuration  
bgp-session-2:
  advertisement-mode: CUSTOM
  custom-ranges:
    - 10.10.11.0/24  # Tertiary subnet
```

#### Traffic Flow Verification
Use GCP Cloud Logging to verify which tunnel handles specific traffic:

```bash
# Query Cloud VPN logs
protoPayload.serviceName="compute.googleapis.com"
protoPayload.methodName="SetUpBackup"
protoPayload.requestMetadata.callerIp="10.0.1.5"
protoPayload.requestMetadata.destination="10.10.11.3"
```

## Summary Section

### Key Takeaways
```diff
+ Advertisement modes control which IP ranges Cloud Router shares with BGP peers
+ Default mode automatically advertises all visible subnets (regional scope)
+ Custom mode enables granular control and summarization
+ BGP session-level configuration overrides router-level settings
+ MED values help implement primary/secondary routing paths
+ VPC peering routes need explicit advertisement to be shared
- Avoid mixing advertisement modes unless deliberate traffic segregation is needed
- Custom configurations don't auto-update with new subnets
```

### Quick Reference

| Mode | Scope | Behavior | Use Case |
|------|-------|----------|----------|
| Default | Cloud Router | Advertise all visible subnets | Simple deployments |
| Custom | Cloud Router/BGP Session | Selective range advertisement | Traffic engineering, summarization |

**GCP Console Navigation:**
1. Network Services → Cloud Routers
2. Select router → Edit → Advertisement mode
3. For BGP sessions: VPN → Cloud VPN Gateways → Tunnel → BGP session → Edit

**Common Advertisement Scenarios:**
- **VPC Peering**: Custom ranges + all local subnets
- **Traffic segregation**: Different subnets per BGP session
- **Quota management**: CIDR summarization (e.g., /20 instead of /28 subnets)

### Expert Insight
**Real-world Application:**
In enterprise environments, advertisement modes enable sophisticated traffic engineering. For example, direct critical application traffic through dedicated high-bandwidth interconnects while routing non-critical traffic through cost-effective VPN tunnels. This approach optimizes both performance and cost.

**Expert Path:**
Master BGP fundamentals before implementing custom advertisement modes. Understand AS path prepending, community tags, and route maps for advanced traffic control. Practice with lab environments before production implementation.

**Common Pitfalls:**
- Failing to advertise return paths causing traffic blackholing
- Exceeding BGP peer route limits without summarization
- Inconsistent configuration across redundant BGP sessions
- Forgetting that custom session configuration isolates from router-level changes

</details>
