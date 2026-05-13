# Session 022: Creating Firewall Policies GCP Part 2

<details open>
<summary><b>022-Creating-Firewall-Policies-GCP-Part-2 (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Hierarchical vs. Global/Regional Policies](#hierarchical-vs-globalregional-policies)
  - [Global Network Firewall Policies](#global-network-firewall-policies)
  - [Regional Network Firewall Policies](#regional-network-firewall-policies)
  - [Policy Evaluation Order](#policy-evaluation-order)
  - [Secure Tags vs. Network Tags](#secure-tags-vs-network-tags)
  - [Predefined Rules](#predefined-rules)
- [Lab Demos](#lab-demos)
  - [Demo 1: Creating and Testing Global Firewall Policy](#demo-1-creating-and-testing-global-firewall-policy)
  - [Demo 2: Enabling Policy Evaluation Through VPC Rule Modification](#demo-2-enabling-policy-evaluation-through-vpc-rule-modification)
  - [Demo 3: Creating and Testing Regional Firewall Policies](#demo-3-creating-and-testing-regional-firewall-policies)
  - [Demo 4: Modifying Global Policy Action to "Go to Next"](#demo-4-modifying-global-policy-action-to-go-to-next)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview
This session continues from the previous video on firewall policies in Google Cloud Platform (GCP). It focuses on practical implementation of Global and Regional Network firewall policies, demonstrating how they differ from hierarchical policies and interact with VPC firewall rules. The session includes hands-on demos showing policy creation, association, and evaluation order testing across multiple VPCs and regions.

## Key Concepts and Deep Dive

### Hierarchical vs. Global/Regional Policies
Firewall policies in GCP exist at multiple levels in the resource hierarchy:

- **Hierarchical Policies**: Created at organization level and apply downward through folders and projects
- **Global Network Firewall Policies**: Created at project level, apply to all regions within VPC networks in that project
- **Regional Network Firewall Policies**: Created at project level but scoped to specific regions, apply only within those regions across VPC networks

The key distinction is that Global and Regional policies are project-scoped (not organization-scoped like hierarchical policies) and require explicit association with VPC networks to take effect.

### Global Network Firewall Policies
Global Network firewall policies are a powerful tool for managing network security at scale within a GCP project. Key characteristics include:

#### Core Features
- Created at the project level
- Apply to all regions within associated VPC networks
- Manage multiple firewall rules in a single policy object
- Can attach to multiple VPC networks within the project
- Require explicit attachment to VPCs - unattached policies have no effect
- Must have unique priorities within the policy

#### Secure Tags
Unlike VPC firewall rules that use "Target Tags", Global Network firewall policies use "Secure Tags". Secure Tags provide:
- More granular control over resource targeting
- Inheritance capabilities across resources
- Centralized management through tag bindings

#### Predefined Rules
Each Global Network firewall policy comes with four predefined rules:
- Two for IPv4 (allow/deny)
- Two for IPv6 (allow/deny)
- Default action is "Go to Next"
- Customizable enforcement order

#### Evaluation Timing
By default, Global Network firewall policies are evaluated after VPC firewall rules, but this order can be customized to allow Global policies to be processed first if needed.

### Regional Network Firewall Policies
Regional Network firewall policies provide region-specific network control while maintaining the same architectural principles as Global policies.

#### Key Differences from Global Policies
- Created and scoped to a specific region
- Apply only within the designated region across all associated VPC networks
- Allow for region-specific security policies

#### Shared Characteristics
- Same rule management capabilities as Global policies
- Support for Secure Tags
- Require explicit VPC network association
- Unique priority requirements within the policy
- Predefined IPv4/IPv6 rules with "Go to Next" default

#### Use Cases
- Compliance requirements for region-specific data residency
- Geographic-based security policies
- Cost optimization through regional segmentation
- Regulatory requirements for data isolation

### Policy Evaluation Order
The firewall policy evaluation follows a strict hierarchy that determines traffic flow:

1. **Hierarchical Network Policies** (Organization/Folder level)
2. **VPC Firewall Rules** (Network level)
3. **Global Network Firewall Policies** (Project level, all regions)
4. **Regional Network Firewall Policies** (Project level, specific region)

```
graph TD
    A[Traffic arrives] --> B{Hierarchical Policy}
    B -->|Allow| C[VPC Firewall Rules]
    B -->|Deny| Z[Traffic Blocked]
    B -->|Go to Next| C
    C -->|Allow| D[End - Traffic Allowed]
    C -->|Deny| Z
    C -->|No Match| E[Global Network Policy]
    E -->|Allow| D
    E -->|Deny| Z
    E -->|Go to Next| F[Regional Network Policy]
    F -->|Allow| D
    F -->|Deny| Z
    F -->|Go to Next| G[Implied Deny]
```

**Critical Behavior**: Once traffic is explicitly allowed at any level, no further policies are evaluated. The "Go to Next" action allows evaluation to continue to subsequent policy levels.

### Secure Tags vs. Network Tags

| Aspect | Network Tags | Secure Tags |
|--------|--------------|-------------|
| Scope | VPC Network | Global/Regional Policies |
| Usage | VPC Firewall Rules | Network Firewall Policies |
| Inheritance | No | Yes, through resource hierarchy |
| Management | Manual per instance | Centralized tag management |
| Flexibility | Instance-specific | Policy-based application |

### Predefined Rules
Every Network firewall policy includes predefined rules for complete protocol coverage:

**IPv4 Rules:**
- Allow all IPv4 traffic (default: Go to Next)
- Deny all IPv4 traffic (default: Go to Next)

**IPv6 Rules:**
- Allow all IPv6 traffic (default: Go to Next)
- Deny all IPv6 traffic (default: Go to Next)

These rules ensure that all traffic types are accounted for while allowing administrators to customize behavior.

## Lab Demos

### Demo 1: Creating and Testing Global Firewall Policy

**Purpose**: Demonstrate creation of Global Network firewall policy and show VPC firewall rule precedence.

**Steps:**
1. Access GCP Console → VPC Network → Firewall
2. Create new firewall policy:
   - Name: `global-firewall-policy`
   - Scope: Global
   - Description: "Global policy for project-level network security"
3. Add ingress rule:
   - Priority: 1000
   - Direction: Ingress
   - Action: Deny
   - Target: All instances in the network
   - Source IP ranges: `0.0.0.0/0`
   - Protocols/Ports: `tcp:80`
4. Associate policy with VPC networks:
   - Select target VPCs
   - Click "Associate"

**Expected Outcome**: Policy created but traffic continues to flow (demonstrates VPC precedence).

### Demo 2: Enabling Policy Evaluation Through VPC Rule Modification

**Purpose**: Show how VPC firewall rules must be modified for higher-level policies to take effect.

**Steps:**
1. Navigate to VPC Network → Firewall policies
2. Locate default "Allow HTTP" VPC firewall rule
3. Disable the rule (Actions → Disable)
4. Test connectivity to VM instances

**Configuration Example**:
```yaml
# VPC Firewall Rule (before modification)
name: default-allow-http
network: default
direction: INGRESS
action: ALLOW
rules:
- protocol: tcp
  ports:
  - 80
disabled: false  # Set to true to allow policy evaluation
```

**Expected Outcome**: After disabling VPC rule, Global firewall policy denies TCP port 80 traffic.

### Demo 3: Creating and Testing Regional Firewall Policies

**Purpose**: Demonstrate regional isolation and policy evaluation across different regions.

**Steps:**
1. Create Regional firewall policy for US West 4:
   - Name: `us-west4-firewall-policy`
   - Region: us-west4
   - Add ingress rule:
     - Priority: 1000
     - Direction: Ingress
     - Action: Allow
     - Source: `0.0.0.0/0`
     - Protocols/Ports: `tcp:80`
   - Associate with default network

2. Create Regional firewall policy for Asia Southeast 1:
   - Name: `asia-southeast1-firewall-policy`
   - Region: asia-southeast1
   - Add ingress rule:
     - Priority: 1000
     - Direction: Ingress
     - Action: Deny
     - Source: `0.0.0.0/0`
     - Protocols/Ports: `tcp:80`
   - Associate with test network

**Expected Outcome**: US West 4 VM allows traffic, Asia Southeast 1 VM denies traffic.

### Demo 4: Modifying Global Policy Action to "Go to Next"

**Purpose**: Demonstrate policy chaining and evaluation order control.

**Steps:**
1. Edit Global firewall policy created in Demo 1
2. Change rule action from "Deny" to "Go to Next"
3. Save policy changes

**Configuration Change**:
```yaml
# Global Firewall Policy Rule (modified)
priority: 1000
direction: INGRESS
action: goto_next  # Changed from DENY
sourceRanges:
- 0.0.0.0/0
allowed:
- protocol: tcp
  ports:
  - '80'
```

**Expected Outcome**: Traffic now evaluated by Regional policies, allowing fine-grained regional control.

## Summary

### Key Takeaways

```diff
+ Global Network firewall policies are created at project level and apply to all regions within associated VPCs
+ Regional Network firewall policies provide region-specific control while maintaining consistent architecture
+ Traffic evaluation follows strict hierarchy: Hierarchical → VPC Rules → Global → Regional
- VPC firewall rules take precedence over Network firewall policies by default
! Use "Go to Next" action to enable policy chaining and allow lower-level policies to be evaluated
+ Secure Tags replace Network Tags in Network firewall policies for enhanced targeting capabilities
- Unattached firewall policies have no effect - explicit VPC association is required
+ Predefined rules ensure complete protocol coverage with customizable enforcement order
```

### Quick Reference

**Policy Creation Commands:**
```bash
# Global Network Firewall Policy
gcloud compute firewall-policies create global-policy-name \
  --description "Global firewall policy" \
  --global

# Regional Network Firewall Policy
gcloud compute firewall-policies create regional-policy-name \
  --description "Regional firewall policy" \
  --region us-west4
```

**Policy Association:**
```bash
# Associate policy with VPC networks
gcloud compute firewall-policies associations create \
  --firewall-policy global-policy-name \
  --network default \
  --global-association
```

**Rule Addition:**
```bash
# Add deny rule for port 80
gcloud compute firewall-policies rules create 1000 \
  --firewall-policy global-policy-name \
  --action deny \
  --direction ingress \
  --source-ranges 0.0.0.0/0 \
  --rules tcp:80 \
  --global
```

### Expert Insight

#### Real-world Application
Network firewall policies excel in enterprise multi-cloud environments where centralized security management is crucial. Organizations with complex network topologies use these policies to implement consistent security postures across regions while maintaining regional compliance requirements. For example, a global e-commerce platform might use Global policies for baseline security and Regional policies for region-specific data protection regulations.

#### Expert Path
- Master policy evaluation order and use "Go to Next" strategically to create layered security
- Implement Secure Tags for dynamic resource targeting without instance modifications
- Combine with VPC Service Controls for defense-in-depth network security
- Use Infrastructure-as-Code (IaC) tools like Terraform for policy lifecycle management
- Monitor policy effectiveness through VPC Flow Logs and Cloud Logging integration

#### Common Pitfalls
- Forgetting that unattached policies are ineffective - always verify VPC associations
- Assuming Network policies override VPC rules without testing evaluation order
- Using conflicting priorities within the same policy scope
- Not accounting for IPv6 traffic when implementing security controls
- Modifying production policies without testing in development environments first

</details>