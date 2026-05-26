# Session 026: Creating VPC Network Peering in GCP

<details open>
<summary><b>Creating VPC Network Peering GCP in Hindi (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [VPC Peering Fundamentals](#vpc-peering-fundamentals)
- [Key Benefits](#key-benefits)
- [Configuration Options](#configuration-options)
- [Requirements and Restrictions](#requirements-and-restrictions)
- [Routing and Traffic Flow](#routing-and-traffic-flow)
- [Firewall Rules and Security](#firewall-rules-and-security)
- [Comparison with Shared VPC](#comparison-with-shared-vpc)
- [Lab Demo: Creating VPC Peering](#lab-demo-creating-vpc-peering)
- [Common Troubleshooting](#common-troubleshooting)
- [Summary](#summary)

## Overview
VPC Network Peering enables secure, private connectivity between VPC networks in Google Cloud Platform (GCP). This session covers the concepts, benefits, configuration options, and practical implementation of VPC peering, including a complete lab demonstration between different GCP projects.

## VPC Peering Fundamentals
### What is VPC Peering?

<texbook-style>
VPC Network Peering connects two VPC networks, enabling them to communicate privately through internal IP addresses without requiring external internet connectivity. Traffic flows entirely through Google's internal network infrastructure.
</texbook-style>

### Basic Architecture
```
Network 1 (Project A)    Network 2 (Project B)
    ↓                         ↓
[192.168.2.0/24]     [192.168.10.0/24]
    ↓                         ↓
Peer Connection Created
    ↓                         ↓
Direct IP Address Communication
```

### Key Characteristics
- **Private Connectivity**: No external IP addresses required
- **Google Internal Network**: Traffic remains within Google's network
- **Fully Managed Service**: No network hardware management needed
- **Regional/Global**: Can be configured across regions/projects

## Key Benefits

### 1. Network Latency
```diff
+ Lower Latency: Traffic stays within Google's network avoiding public internet hops
+ Reduced Packet Loss: More reliable connectivity with fewer network intermediaries
```
**Impact**: Typically 50-70% faster communication compared to internet-based connectivity

### 2. Security Enhancement
```diff
+ No Public Exposure: Traffic never traverses the public internet
+ Reduced Attack Surface: Eliminates interception risks during transmission
+ Compliance Friendly: Maintains data privacy for regulated workloads
```

### 3. Cost Efficiency
```diff
+ No Egress Costs: Avoids data transfer charges when communicating between peered networks
+ Shared Resources: Leverage existing Google network infrastructure
```

### 4. Administrative Separation
```diff
+ Independent Management: Each network team maintains control of their own network
+ Flexible Scaling: Add/remove resources without requiring comprehensive network knowledge
```

## Configuration Options

### 1. Same Project Peering
```
Project Alpha
├── VPC Network 1 → Peer with ← VPC Network 2
└── Storage Services Backend
```
**Use Case**: Development and production environments within same team

### 2. Different Projects, Same Organization
```
Organization: Google.com
├── Project Beta (Network 1)
└── Project Gamma (Network 2)
    └── VPC Peering Established
```
**Use Case**: Multi-project deployments within enterprise organizations

### 3. Different Projects, Different Organizations
```
Organization A: google.com
├── Project A (VPC A)
Organization B: test.com  
└── Project B (VPC B)
    └── Cross-Org Peering
```
**Use Case**: Business partnerships, hybrid cloud scenarios

## Requirements and Restrictions

### Prerequisites
- **Dual Stack Matching**: If Network A enables dual stack (IPv4/IPv6), Network B must also have dual stack enabled
- **Unique Subnet Ranges**: No IP address overlaps between peered networks
- **Active VPC Networks**: Both networks must be operational

### Critical Restrictions

#### 1. Transitive Peering Not Supported
```
Network A ── Peer ── Network B
    │                      │
     Not Connected         Not Connected
    │                      │
Network C               Network C
```
**Explanation**: If Network A peers with Network B, and Network A peers with Network C, Network B and C cannot communicate directly through A.

#### 2. Subnet Range Conflicts
```
❌ INVALID: Network A (10.0.0.0/24) + Network B (10.0.0.0/24)
✅ VALID: Network A (10.0.0.0/24) + Network B (10.0.1.0/24)
```
**Error Message**: `subnet IP range overlaps with an active peer network`

#### 3. Firewall Rules Not Inherited
```diff
- Peering connections DO NOT automatically transfer firewall rules
! Manual Configuration Required: Configure firewalls on both networks to allow desired traffic
```

#### 4. DNS Resolution Limitations
```diff
- Internal DNS names resolve only within their originating network
- Peer network DNS names remain unresolved
```

## Routing and Traffic Flow

### Automatic Route Exchange
#### IPv4 Routes
```
Network A Subnets:
├── Subnet 1: 192.168.2.0/24
└── Subnet 2: 192.168.3.0/24

Network B Subnets:
├── Subnet 1: 10.0.0.0/16
└── Subnet 2: 10.1.0.0/16

Peering Result:
├── Network A learns: 10.0.0.0/16, 10.1.0.0/16
└── Network B learns: 192.168.2.0/24, 192.168.3.0/24
```

### Custom Route Handling
#### 1. Static Routes
```
Route Type: Custom (Static)
↓
Must Exclusively Export/Import
  ┌─ Export: Network A → Network B
  └─ Import: Network B accepts from Network A
```

#### 2. Routes with Instance Tags
```
Routes with Tags/Specific Instances:
↓
✅ Work only within originating network
❌ NEVER shared during peering
```

#### 3. Public IPs as Private
```bash
# Example subnet creation for public IP range
Name: Private-Public-11-0-8-0
Range: 11.0.8.0/24
Type: Private IP Address (Public Range)
```

**Steps to Share**:
1. Configure subnet with public IP range
2. Enable private IP allocation on subnet
3. Export from originating network
4. Explicitly import in destination network

### IPv6 Considerations
```diff
+ Dual Stack Enabled: IPv4 + IPv6 routes exchanged
! Both Networks Must Support IPv6
```

## Firewall Rules and Security

### Peering Connection Impact
```diff
- Firewall rules configured in source network
! REMAIN ONLY in source network
- Cross-network traffic REQUIRES firewall rules on destination network
! Configure complementary rules in target network
```

### Common Configuration Pattern
```
Network A → Network B Communication:
1. Network A Firewall: Allow outbound to Network B subnets
2. Network B Firewall: Allow inbound from Network A subnets
```

## Comparison with Shared VPC

| Feature | VPC Peering | Shared VPC |
|---------|-------------|------------|
| **Scope** | Cross-project, cross-org | Single organization |
| **Administration** | Decentralized | Centralized (host project) |
| **Existing Resources** | Fully supported | Requires migration to use |
| **Transitive Communication** | ❌ | ✅ |
| **Network Type** | Hub-and-spoke model | Hierarchical model |

## Lab Demo: Creating VPC Peering

### Prerequisites
- Two GCP projects with VPC networks
- VM instances with internal IPs only
- Appropriate IAM permissions

### Step 1: Verify Current Connectivity
```bash
# Test current connectivity (should fail)
ping <internal-ip-of-vm-in-other-network>
# Expected: No response, no external IP connectivity
```

### Step 2: Access VPC Network Peering Console
```
Google Cloud Console → VPC Network → VPC Network Peering
```

### Step 3: Create First Side Peering Connection
```bash
# Connection Details
Name: service-prj-1-to-2-vpc12
Local Network: default (in service-prj-1)
Peer Network: In another project

# Peer Network Details  
Project ID: service-prj-2
VPC Network Name: default
Exchange custom routes: 'Import' or 'Export' as needed
```

### Step 4: Accept Peering on Second Network
```bash
# Second Project Console
Project: service-prj-2
VPC Network Peering → Connections
# Status should show: Waiting for peer network approval (expected)
```

### Step 5: Verify Both Sides Active
```diff
+ Prerequisites: Both sides display 'Active' status
+ Route Exchange: Subnets automatically appear in routing tables
```

### Step 6: Test Connectivity
```bash
# Successful ping test
ping 10.128.0.10  # Internal IP of VM in peered network
# Expected: Cannot reach before peering
# Actual: Can reach after peering establishment
```

### Step 7: Examine Route Details
```
Imported Routes:
├── 192.168.2.0/24 (Subnet range from peer network)
└── 10.128.0.0/20 (Additional subnets)

Exported Routes:  
├── 10.128.0.0/20 (Local subnet ranges)
└── 192.168.10.0/24 (Automatically exported)
```

## Common Troubleshooting

### Issue 1: Subnet Overlap Error
```bash
Error: subnet IP range overlaps with an active peer network
Solution: Adjust subnets to use non-overlapping IP ranges
```

### Issue 2: Cannot Create Subnet After Peering
```diff
! Restriction: Cannot create subnets matching imported route ranges
Node: Plan IP address schema before establishing peering connections
```

### Issue 3: Custom Route Not Appearing
```bash
# Check configuration sequence:
1. Export route from source network
2. Import route at destination network
3. Refresh console and verify in route tables
```

### Issue 4: Firewall Traffic Blocking
```diff
! Common Mistake: Firewall rules not configured for peered traffic
Recommendation: Configure complementary ingress/egress rules on both networks
```

### Issue 5: Dual Stack Route Missing
```diff
! Issue: IPv6 routes not appearing despite export/import
Cause: Target network not dual-stack enabled
Fix: Enable dual stack on target network VPC level
```

## Summary

### Key Takeaways
```diff
+ VPC Peering enables private, high-performance communication between VPC networks
+ Supports same project, cross-project, and cross-organization connectivity
+ Eliminates public internet reliance with lower latency and enhanced security
+ Automatic route exchange for subnet connectivity with manual custom route handling
- Transitive peering unsupported - direct connections required for multi-network scenarios
+ Subnet overlap prevention mandatory to avoid configuration conflicts
! Firewall rules, DNS resolution, and custom routes require separate configuration
+ Dual stack considerations when IPv6 routing needed
- Administrative separation maintained between peered network teams
```

### Quick Reference

```bash
# Create VPC Peering
gcloud compute networks peerings create PEERING-NAME \
    --network=LOCAL-NETWORK \
    --peer-project=PEER-PROJECT \
    --peer-network=PEER-NETWORK

# List peering connections  
gcloud compute networks peerings list --network=NETWORK-NAME

# Delete peering connection
gcloud compute networks peerings delete PEERING-NAME --network=NETWORK-NAME

# Check routes after peering
gcloud compute routes list --filter="nextHopNetwork:PEER-NETWORK"
```

```bash
# Firewall rule template for peered traffic
gcloud compute firewall-rules create allow-peer-traffic \
    --network=NETWORK-NAME \
    --allow=tcp:0-65535,udp:0-65535,icmp \
    --source-ranges=PEER-SUBNET-RANGE
```

### Expert Insight

#### Real-world Application
VPC Peering excels in enterprise scenarios requiring secure, high-performance connectivity between isolated network segments. Common implementations include:
- **Microservices Architecture**: Service-to-service communication across different projects
- **Multi-region Deployments**: Global application connectivity with unified networking
- **Database Integration**: Backend database access from multiple application tiers
- **DevSecOps Pipelines**: Isolation between development, staging, and production environments

#### Expert Path to Mastery
1. **Understand GCP Networking Hierarchy**: Master VPC, subnet, and route concepts before peering
2. **IP Planning**: Design comprehensive IP address schemas preventing future overlaps  
3. **Network Automation**: Use Terraform/Infrastructure as Code for reproducible peering deployments
4. **Monitoring and Security**: Implement VPC Flow Logs and Security Command Center for peering traffic
5. **Hybrid Scenarios**: Learn Cloud Interconnect and VPN gateways for on-premise integrations

#### Common Pitfalls
```diff
- Underestimating transitive limitations leading to complex peer relationship requirements
- Neglecting firewall rule configuration resulting in traffic blocking post-peering
! Overlapping IP ranges causing unforeseen service disruptions
- Assuming DNS resolution works cross-network without custom DNS solutions
+ Not enabling dual-stack consistently across peered networks requiring IPv6
- Creating extensive VPC peering (referred as "spaghetti network" in GCP)
- Performance degradation from misconfigured custom routes creating routing loops
```

</details>
