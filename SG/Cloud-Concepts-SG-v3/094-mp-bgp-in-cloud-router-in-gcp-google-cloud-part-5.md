<details open>
<summary><b>094-MP-BGP-in-Cloud-Router-in-GCP-Google-Cloud-Part-5 (KK-CS45-script-v3)</b></summary>

# Session 094: MP-BGP in Cloud Router in GCP Google Cloud Part 5

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
- [Lab Demo: Setting up HA VPN with MP-BGP](#lab-demo-setting-up-ha-vpn-with-mp-bgp)
- [Summary](#summary)

## Overview
This session covers Multi-Protocol BGP (MP-BGP) functionality in Google Cloud Router for HA VPN connections. We'll explore how MP-BGP enables exchanging IPv4 and IPv6 routes over single BGP sessions, eliminating the need for parallel sessions. The session includes practical demonstrations of setting up dual-stack tunnels and configuring BGP authentication with MD5.

> [!IMPORTANT]
> MP-BGP is essential for organizations requiring both IPv4 and IPv6 connectivity over existing cloud infrastructure, optimizing network efficiency by reusing single tunnels for dual-protocol traffic.

## Key Concepts and Deep Dive

### Multi-Protocol BGP (MP-BGP) Fundamentals

**What is MP-BGP?**
Multi-Protocol BGP extends standard BGP capabilities to carry routing information for multiple network protocols within a single BGP session. In Google Cloud, this primarily means exchanging both IPv4 and IPv6 routes over either IPv4 or IPv6 BGP sessions.

**Why Use MP-BGP?**
- **Resource Efficiency**: Eliminates need for parallel IPv4 and IPv6 BGP sessions
- **Network Simplification**: Single tunnel handles dual-protocol traffic
- **Cost Optimization**: Reduces router CPU and memory usage on-premises
- **Flexibility**: Can configure IPv4 BGP session to exchange IPv6 routes, or IPv6 BGP session to exchange IPv4 routes

**Default BGP Session Behavior:**
By default, IPv4 BGP sessions only exchange IPv4 routes. The same applies to IPv6 BGP sessions. MP-BGP enables cross-protocol route exchange.

### HA VPN Tunnel Types

Google Cloud HA VPN supports different tunnel configurations for IP addressing:

1. **IPv4 Single Stack**: Only IPv4 traffic
2. **IPv6 Single Stack**: Only IPv6 traffic  
3. **Dual Stack**: Both IPv4 and IPv6 traffic over the same tunnel

**Configuration Options:**
- Select stack type during tunnel creation
- Applies to both HA VPN and Dedicated Interconnect
- Dual stack configuration enables MP-BGP capabilities

### BGP Session Configuration Variations

**Option 1: IPv4 BGP Session with IPv6 Routes**
```
- Create IPv4 BGP session
- Enable "Send IPv6 traffic over IPv4 tunnel" option
- Allocates both IPv4 and IPv6 IP addresses for BGP peering
```

**Option 2: IPv6 BGP Session with IPv4 Routes**
```
- Create IPv6 BGP session  
- Enable "Send IPv4 traffic over IPv6 tunnel" option
- Exchanges IPv4 routes using IPv6 transport
```

**Option 3: Parallel Sessions**
- Separate IPv4 and IPv6 BGP sessions
- Each session only exchanges routes for its address family
- Requires double configuration but provides independent management

### BGP Authentication with MD5

**MD5 Authentication Overview:**
- Binds BGP sessions with shared secret keys
- Supported on HA VPN and Cloud Interconnect
- Supported with certain third-party appliances
- Optional feature for enhanced security

**Implementation Steps:**
1. Provide shared secret during BGP session creation
2. Must configure same key on both cloud and on-premises routers
3. Session flaps during key updates or changes

**Key Management:**
- Can add MD5 authentication to existing sessions
- Modify existing keys requiring session flap
- Disable authentication removes key protection

**Security Benefits:**
- Encrypts BGP control plane traffic
- Prevents BGP session hijacking and man-in-the-middle attacks

### Traffic Plane vs Control Plane Behavior

**IPv4 Traffic Outage Impact:**
```
IPv4 Session (Default): Withdraws ALL routes (IPv4 + IPv6)
IPv6 Session (Default): Only drops IPv4 traffic
```

This behavior ensures network stability when using MP-BGP for dual-protocol routing.

### IPv4/IPv6 Interoperability Notes

**Traffic Flow Limitations:**
- IPv4-only devices cannot directly ping IPv6 addresses
- IPv6-only devices cannot directly ping IPv4 addresses
- Requires dual-stack intermediate devices or NAT translators

**Network Address Translation Considerations:**
- IPv4-to-IPv6 translation requires NAT64 gateways
- IPv6-to-IPv4 translation requires NAT46 gateways
- Dual-stack architectures resolve direct communication needs

### Cloud Router Advertisement Modes

**Route Advertisement:**
- Automatic route advertisement for VPC subnets
- Custom route import/export capabilities
- Supports both IPv4 and IPv6 route tables

**Viewing Learned Routes:**
```bash
# Routes learned from peer routers displayed per address family
IPv4 Routes: 10.0.0.0/16, 192.168.1.0/24
IPv6 Routes: 2001:db8::/32, 2600:1900::/28
```

**Configuration Steps:**
1. Enable IPv6 at VPC subnet level
2. Choose internal or external IPv6 IP allocation
3. Create dual-stack HA VPN tunnels

> [!NOTE]
> IPv6 subnets cannot have external IP addresses allocated - only internal IPv6 addresses are supported for direct VM networking.

## Lab Demo: Setting up HA VPN with MP-BGP

### Prerequisites
- Two GCP projects with appropriate permissions
- Dual-stack enabled VPC with IPv6 subnets
- Cloud Router ASNs (unique between projects)

### Step 1: Configure Dual-Stack HA VPN

**First Project Configuration:**
```yaml
Project: production
Network: my-dual-stack-network
Region: asia-south1
VPN Gateway Name: my-gcp-gateway
IP Stack: Dual Stack (IPv4 and IPv6)
ASN: 64512
```

**Second Project Configuration:**
```yaml
Project: development  
Network: dev-dual-stack-network
Region: asia-south1
VPN Gateway Name: dev-gateway
IP Stack: Dual Stack (IPv4 and IPv6)
ASN: 64513
```

### Step 2: Create VPN Tunnels

**Tunnel Configuration:**
```bash
# Creating two tunnels per gateway for high availability
# IKEv2 pre-shared key: "GCP123"

# First Project - Tunnel 1 (External Gateway 1)
gcloud compute vpn-tunnels create first-project-tunnel-1 \
  --project=production \
  --peer-external-gateway=dummy-peer \
  --ike-version=2 \
  --shared-secret=GCP123

# First Project - Tunnel 2 (External Gateway 2)  
gcloud compute vpn-tunnels create first-project-tunnel-2 \
  --project=production \
  --peer-external-gateway=dummy-peer-2 \
  --ike-version=2 \
  --shared-secret=GCP123
```

### Step 3: Configure MP-BGP Sessions

**IPv4 BGP Session with IPv6 Routes:**
```yaml
Session Type: IPv4 (Multi-Protocol)
Exchange IPv6 Routes: Enabled
BGP IPv4 Addresses:
- Local: 169.254.1.1
- Peer: 169.254.1.2  
MD5 Authentication: cloud123
Advertised Networks:
- IPv4: 10.10.0.0/16
- IPv6: 2600:1900::/28
```

**IPv6 BGP Session with IPv4 Routes:**
```yaml
Session Type: IPv6 (Multi-Protocol)
Exchange IPv4 Routes: Enabled
BGP IPv6 Addresses: (Auto-assigned by Google)
MD5 Authentication: cloud123
Advertised Networks:
- IPv4: 192.168.1.0/24
- IPv6: 2001:db8::/32
```

### Step 4: Create Test VMs

**VM Configurations:**
```bash
# VM 1: IPv4 Only
gcloud compute instances create ipv4-vm \
  --machine-type=e2-micro \
  --network-interface=network=my-network,subnet=my-subnet

# VM 2: IPv6 Only  
gcloud compute instances create ipv6-vm \
  --machine-type=e2-micro \
  --network-interface=network=my-network,subnet=my-ipv6-subnet

# VM 3: Dual Stack
gcloud compute instances create dual-stack-vm \
  --machine-type=e2-micro \
  --network-interface=network=my-network,subnet=my-dual-subnet
```

### Step 5: Test Connectivity

**Testing Commands:**
```bash
# Test IPv4 connectivity
ping -c 4 10.10.1.10

# Test IPv6 connectivity (from IPv6-enabled VM)
ping6 -c 4 2600:1900::100

# Test dual-stack functionality
# IPv4 source to IPv6 destination (will fail)
ping -I 10.10.1.10 2600:1900::100  # NETWORK UNREACHABLE

# IPv6 source to IPv4 destination (will fail)  
ping6 -I 2600:1900::100 10.10.1.10  # NETWORK UNREACHABLE

# Test from dual-stack VM (succeeds for both)
ping -c 4 10.10.1.10      # IPv4 reachable
ping6 -c 4 2600:1900::100 # IPv6 reachable
```

### Step 6: Demonstrate Session Failover

**Disable IPv4 BGP Session to Show IPv6 MP-BGP Traffic Flow:**
```bash
# Disable IPv4 BGP session (via Console or CLI)
# IPv6 traffic continues flowing over remaining session
# Routes remain active for unaffected protocols
```

### Firewall Rules for IPv6 Testing

**IPv6 Ingress Rule:**
```yaml
Name: allow-ipv6-ssh
Type: Ingress
Targets: Apply to all instances  
Source filter: IPv6 ranges
IPv6 ranges: 2000::/3 (or specific range)
Protocols/ports: tcp:22, 58 (ICMPv6)
```

> [!WARNING]
> ICMP is protocol 58 for IPv6, not protocol 1 as in IPv4. Typing "ICMP" directly in port fields will not work.

## Summary

### Key Takeaways
```diff
+ MP-BGP enables single BGP sessions to exchange routes for multiple protocol families (IPv4/IPv6)
+ Dual-stack HA VPN tunnels support both IPv4 and IPv6 traffic over one connection
+ IPv4 BGP sessions can carry IPv6 routes and vice versa using multi-protocol extensions
+ MD5 authentication provides BGP session security with shared secret keys
+ Traffic plane outages only affect affected protocol families, not all routes
- Parallel sessions consume double resources but allow independent management
- IPv4-only and IPv6-only networks cannot directly communicate without translation
- IPv6 subnets cannot have external IP addresses allocated
```

### Quick Reference

**MP-BGP Configuration Commands:**
```bash
# Enable IPv6 route exchange over IPv4 session
bgp session create --type=ipv4 --enable-ipv6=true

# Enable IPv4 route exchange over IPv6 session  
bgp session create --type=ipv6 --enable-ipv4=true

# Add MD5 authentication
bgp session update --md5-key=shared-secret
```

**Tunnel IP Stack Options:**
- `ipv4_only`: Single stack IPv4
- `ipv6_only`: Single stack IPv6  
- `ipv4_ipv6`: Dual stack support

**BGP Session States:**
- `UP`: Session established, routes exchanged
- `DOWN`: Session disconnected, routes withdrawn

### Expert Insight

**Real-world Application:**
In enterprise environments migrating to IPv6, MP-BGP provides seamless dual-protocol support without deploying parallel infrastructure. This is particularly valuable for cloud-to-on-premises connectivity where both protocol stacks coexist during transition periods.

**Expert Path:** 
Master BGP route propagation, network address translation (NAT64/NAT46), and dual-stack architecture design. Practice troubleshooting MP-BGP neighborship issues using `show bgp neighbors` and route debugging commands.

**Common Pitfalls:**
- Mismatched MD5 keys cause session flaps without clear error messages
- IP stack configuration mismatches prevent proper route exchange  
- Firewall rules missing IPv6 ICMP (protocol 58) break connectivity testing
- IPv6 BGP addresses auto-assigned by Google Cloud must be manually configured on on-premises routers

</details>
