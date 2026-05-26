<details open>
<summary><b>Session 090: Cloud Router in GCP - Part 1 (KK-CS45-script-v3)</b></summary>

# Session 090: Cloud Router in GCP - Part 1

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [What is Cloud Router?](#what-is-cloud-router)
  - [How Cloud Router Works](#how-cloud-router-works)
  - [BGP Protocol](#bgp-protocol)
  - [Autonomous Systems and ASN](#autonomous-systems-and-asn)
  - [BGP Timers](#bgp-timers)
  - [Dynamic Routing Modes](#dynamic-routing-modes)
  - [Route Advertisement Modes](#route-advertisement-modes)
- [Lab Demo: Cloud Router with VPN Setup](#lab-demo-cloud-router-with-vpn-setup)
- [Summary](#summary)

## Overview

This session covers Google Cloud's Cloud Router service, focusing on its fundamental role as a distributed BGP speaker and responder that enables dynamic routing between Google Cloud VPC networks and external networks (on-premises, other cloud providers) through VPN tunnels or Cloud Interconnect. The session explores how Cloud Router works in conjunction with Andromeda (Google's network virtualization stack) to provide dynamic route learning and traffic forwarding capabilities.

## Key Concepts and Deep Dive

### What is Cloud Router?

Cloud Router is a fully managed, distributed service in Google Cloud that:

- **Provides BGP Capabilities**: Acts as a BGP (Border Gateway Protocol) speaker and responder
- **Dynamic Route Management**: Enables automatic learning and sharing of routes between networks
- **Integration Points**: Works with Cloud VPN, Cloud Interconnect, and Router Appliances
- **Control Plane Functions**:
  - Manages BGP sessions
  - Shares routes with external networks
  - Decides optimal routing paths
  - Instructs the data plane on traffic forwarding decisions

```
Cloud Router Architecture:
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Control Plane │───→│   BGP Sessions  │───→│ Network Routes  │
│   (Cloud Router)│    │   Management    │    │   Learning      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                        │                        │
         └────────────────────────┼────────────────────────┘
                                  ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Data Plane    │───→│ Route Decisions │───→│ Traffic Forward│
│ (Andromeda)     │    │   Execution     │    │   Lightning    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### How Cloud Router Works

Cloud Router establishes BGP peering sessions to exchange routing information between networks:

1. **Network Connectivity**: First establish physical/logical connectivity (VPN tunnels or Interconnect)
2. **BGP Session Establishment**: Create BGP sessions over the connectivity layer
3. **Route Exchange**: Networks announce available routes to each other
4. **Traffic Forwarding**: Use learned routes to direct traffic between networks

**Example Network Topology:**
```
Google Cloud Region A          External Network
┌─────────────────────┐       ┌─────────────────────┐
│   VPC Subnet A      │◄─────►│   External Subnet  │
│   10.0.1.0/24       │       │   192.168.1.0/24   │
└─────────────────────┘       └─────────────────────┘
         │                             │
         └───────────VPN Tunnel────────┘
                    │
          ┌─────────────────────┐
          │   Cloud Router      │
          │   BGP Sessions      │
          │   Route Learning    │
          └─────────────────────┘
```

### BGP Protocol

BGP (Border Gateway Protocol) is the standard routing protocol of the internet:

- **Purpose**: Enables autonomous systems to exchange routing information
- **Dynamic Nature**: Automatically discovers and shares network routes
- **Reliability**: Routes are withdrawn automatically when connectivity fails
- **Key Benefits**:
  - Eliminates manual static route configuration
  - Supports automatic network growth (new subnets automatically advertised)
  - Provides failover capabilities for redundant paths

**BGP Session Flow:**
```
Network A (ASN: 64512)     ↔     Network B (ASN: 64513)
     │                             │
     │───OPEN Message (ASN)────────│
     ├───KEEPALIVE Messages────────│
     ├───UPDATE (Routes)───────────┤
     │                             │
     │───Traffic Forwarding────────│
     │                             │
```

### Autonomous Systems and ASN

#### Autonomous System (AS)
- Large, independent network under single administrative authority
- Makes routing decisions independently
- Examples: Google (AS15169), Amazon (AS16509), large enterprises, ISPs

#### Autonomous System Number (ASN)
- **Public ASN**: Globally unique numbers (1-64511 for 16-bit, 1-4294967295 for 32-bit)
- **Private ASN**: Reserved for internal use (64512-65534)
- **16-bit Range**: 1 to 64511 (IANA allocation)
- **32-bit Range**: Includes 65536 to 4294967295

> [!NOTE]
> In Google Cloud, you must use private ASN numbers (64512-65534) when creating Cloud Routers for connectivity to on-premises networks.

### BGP Timers

Cloud Router uses several timers to manage BGP session reliability:

#### Keep Alive Timer
- **Default**: 20 seconds
- **Purpose**: Verify session connectivity between BGP peers
- **Recommendation**: Set identical values on both Cloud Router and on-premises router

#### Hold Timer
- **Calculation**: Keep Alive Timer × 3 = 60 seconds
- **Purpose**: Maximum time to wait for keepalive before declaring session dead
- **Action**: Automatically switches traffic to redundant paths when exceeded

#### Graceful Restart Timer
- **Cloud Router Value**: 120 seconds
- **Purpose**: Allows routers to restart without disrupting traffic flow
- **Process**: Router sends notification, peer waits specified time

#### Stale Path Timer
- **Recommended Value**: 300 seconds (on-premises routers)
- **Purpose**: Time to wait before removing learned routes after End-of-RIB message
- **Google Recommendation**: Set to 300 seconds on on-premises routers to match Cloud Router behavior

```bash
# Timer Configuration Example (Conceptual)
bgp {
  timers {
    keepalive 20;
    holdtime 60;
    graceful-restart 120;
  }
}
```

### Dynamic Routing Modes

Cloud Router supports two VPC routing modes that affect route advertisement:

| Mode | Geographic Scope | Route Sharing Behavior |
|------|------------------|------------------------|
| **Regional** | Routes shared only within the region where Cloud Router is deployed | Cloud Router in `us-central1` shares only `us-central1` subnet routes |
| **Global** | Routes shared across all regions in the VPC | All VPC subnets (us-central1, asia-south1, europe-west1) routes shared |

> [!IMPORTANT]
> Regional mode is suitable for architectures with regional isolation requirements. Global mode enables cross-region connectivity but may increase BGP route table size.

### Route Advertisement Modes

#### Default Advertisement
- Advertises subnets based on the VPC's dynamic routing mode configuration
- Regional mode → Regional subnet routes only
- Global mode → All VPC subnet routes

#### Custom Advertisement
- Allows selective route sharing
- Useful for:
  - Security separation (different routes over different tunnels)
  - Traffic prioritization (important data over high-bandwidth connections)
  - Network segmentation

```yaml
# Custom Route Advertisement Example
advertisedRoutes:
  - destinations: 10.0.0.0/24    # Critical application subnet
    priority: high              # Route via primary tunnel
  - destinations: 10.0.1.0/24    # Bulk data subnet  
    priority: low               # Route via secondary tunnel
```

## Lab Demo: Cloud Router with VPN Setup

### Prerequisites
- Two Google Cloud projects with VPC networks
- VPN gateways created in both projects
- Subnets configured in both VPCs

### Step 1: Create Cloud Routers

```bash
# Project 1: GCP VPC Cloud Router
gcloud compute routers create gcp-vpc-cloud-router \
    --project=project-1 \
    --network=gcp-vpc \
    --region=asia-south1 \
    --asn=64512 \
    --bgp-identifier-range=169.254.0.0/30
```

### Step 2: Create HA VPN Tunnels

```bash
# Create VPN Gateway in Project 1
gcloud compute target-vpn-gateways create gcp-vpc-gateway \
    --project=project-1 \
    --network=gcp-vpc \
    --region=asia-south1

# Create VPN Gateway in Project 2  
gcloud compute target-vpn-gateways create onprem-gateway \
    --project=project-2 \
    --network=onprem-vpc \
    --region=asia-south1
```

### Step 3: Establish VPN Tunnels Between Projects

```bash
# VPN Tunnel from Project 1 to Project 2
gcloud compute vpn-tunnels create gcp-vpc-tunnel-1 \
    --project=project-1 \
    --peer-gcp-gateway=onprem-gateway \
    --ike-version=2 \
    --shared-secret=gcp@123 \
    --router=gcp-vpc-cloud-router \
    --vpn-gateway=gcp-vpc-gateway \
    --interface=0
```

### Step 4: Configure BGP Sessions

```bash
# BGP Session Configuration
gcloud compute routers add-interface gcp-vpc-cloud-router \
    --project=project-1 \
    --interface-name=if-tunnel-1 \
    --vpn-tunnel=gcp-vpc-tunnel-1 \
    --ip-address=169.254.0.1 \
    --mask-length=30

gcloud compute routers add-bgp-peer gcp-vpc-cloud-router \
    --project=project-1 \
    --peer-name=bgp-peer-1 \
    --interface=if-tunnel-1 \
    --peer-ip-address=169.254.0.2 \
    --peer-asn=64513 \
    --advertisement-mode=DEFAULT
```

### Step 5: Demonstrate Route Learning

```bash
# Check advertised routes
gcloud compute routers get-status gcp-vpc-cloud-router \
    --project=project-1 \
    --region=asia-south1 \
    --format="table(name,bgpPeerStatus[].advertisedRoutes[].destRange)"
```

### Step 6: Test Connectivity

```bash
# Test ping between VMs across different VPCs
ping 192.168.1.10  # VM in Project 2 from VM in Project 1
```

### Key Demo Observations

1. **Regional vs Global Routing**:
   - Regional mode: Routes visible only in Cloud Router's region
   - Global mode: Routes propagated across all VPC regions

2. **Route Advertisement**:
   - Default mode automatically shares all eligible subnets
   - Custom mode allows selective route sharing per BGP session

3. **BGP Session Status**:
   - `Established`: BGP peering successful, routes exchanged
   - Learned routes visible in router status and VPC routing tables

## Summary

### Key Takeaways

```diff
+ Cloud Router is GCP's managed BGP service for dynamic routing
+ BGP enables automatic route learning between networks
- Always use private ASN numbers (64512-65534) for Cloud Router
+ Regional routing shares routes within one region only
+ Global routing shares routes across all VPC regions  
+ BGP timers ensure session reliability and failover
+ Custom route advertisement enables traffic engineering
+ Cloud Router integrates with VPN tunnels and Interconnect
+ Route changes (add/remove subnets) are automatically advertised
```

### Quick Reference

**Cloud Router Commands:**
```bash
# Create Cloud Router
gcloud compute routers create ROUTER_NAME \
    --network=VPC_NAME \
    --region=REGION \
    --asn=ASN_NUMBER

# Add BGP Interface  
gcloud compute routers add-interface ROUTER_NAME \
    --interface-name=IF_NAME \
    --vpn-tunnel=TUNNEL_NAME \
    --ip-address=BGP_IP \
    --mask-length=30

# Add BGP Peer
gcloud compute routers add-bgp-peer ROUTER_NAME \
    --peer-name=PEER_NAME \
    --interface=IF_NAME \
    --peer-ip-address=PEER_BGP_IP \
    --peer-asn=PEER_ASN
```

**BGP Timer Values:**
- Keep Alive: 20 seconds
- Hold Timer: 60 seconds
- Graceful Restart: 120 seconds
- Stale Path Timer (recommended on-premises): 300 seconds

### Expert Insight

**Real-world Application**: Cloud Router is essential for hybrid cloud architectures where you need seamless connectivity between Google Cloud VPCs and on-premises data centers. It's commonly used in migration scenarios, disaster recovery setups, and multi-cloud environments.

**Expert Path**: Master BGP fundamentals, understand MED (Multi-Exit Discriminator) manipulation for traffic engineering, and learn advanced route filtering techniques. Study RFC 4271 for deep BGP protocol knowledge.

**Common Pitfalls**: 
- Using conflicting ASN numbers between peer routers
- Incorrect BGP IP address ranges causing session failures  
- Forgetting to enable global routing mode when cross-region connectivity is needed
- Not setting matching timers between Cloud Router and on-premises equipment
- Exceeding router limits (250 routes) in complex environments without route summarization

</details>
