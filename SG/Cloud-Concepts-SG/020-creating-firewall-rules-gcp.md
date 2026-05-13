# Session 020: Creating Firewall Rules GCP

<details open>
<summary><b>Session 020: Creating Firewall Rules GCP (KK-CS45-script-v2)</b></summary>

## Table of Contents

1. [Overview](#overview)
2. [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
3. [Lab Demos](#lab-demos)
4. [Summary](#summary)

## Overview

This session covers Google Cloud Platform (GCP) Virtual Private Cloud (VPC) network firewall rules. Firewall rules control network traffic flow both into (ingress) and out of (egress) virtual machine instances within a VPC. The session demonstrates default firewall rules, custom rule creation, priority management, target scoping, and practical testing scenarios.

## Key Concepts and Deep Dive

### Firewall Rules Fundamentals

Firewall rules in GCP are applied at the VPC network level and govern traffic flow between instances. Each rule belongs to a specific VPC network and cannot be shared across networks.

**Key Characteristics:**
- **Scope**: Rules are VPC-specific
- **Direction**: Either ingress (incoming) or egress (outgoing) traffic
- **Priority**: Numerical priority (0 = highest, 65535 = lowest)
- **Target**: Which instances the rule applies to
- **Action**: Allow or deny matching traffic
- **Source/Destination**: IP ranges, service accounts, or tags defining traffic origin/destination

### Rule Types

#### Ingress vs Egress
- **Ingress**: Controls incoming traffic to instances
- **Egress**: Controls outgoing traffic from instances

#### Allow vs Deny
- **Allow**: Permits matching traffic
- **Deny**: Blocks matching traffic
- **Precedence**: When rules conflict, deny rules take precedence over allow rules with same priority

### Priority System

Firewall rules are evaluated in priority order (lowest number = highest priority). Traffic is checked against rules sequentially:

```
Priority: 0 ← Highest Priority (evaluated first)
Priority: 1000
Priority: 65534
Priority: 65535 ← Lowest Priority (evaluated last, Google's default deny-all rule)
```

**Important**: A high-priority deny rule will block traffic before a lower-priority allow rule can permit it.

### Default Firewall Rules

Google automatically creates default rules for new VPC networks:

| Rule Name | Priority | Direction | Action | Protocols/Ports | Source | Target |
|-----------|----------|----------|--------|-----------------|---------|---------|
| default-allow-internal | 65534 | Ingress | Allow | tcp:0-65535, udp:0-65535, icmp | 10.128.0.0/9 (VPC subnet) | All instances |
| default-allow-ssh | 65534 | Ingress | Allow | tcp:22 | 0.0.0.0/0 | All instances |
| default-allow-rdp | 65534 | Ingress | Allow | tcp:3389 | 0.0.0.0/0 | All instances |
| default-allow-icmp | 65534 | Ingress | Allow | icmp | 0.0.0.0/0 | All instances |
| default-deny-all-ingress | 65535 | Ingress | Deny | All protocols | 0.0.0.0/0 | All instances |
| default-allow-all-egress | Implied | Egress | Allow | All protocols | All destinations | All instances |

**Security Note**: Default rules allow broad access (0.0.0.0/0) including SSH, RDP, and ICMP from anywhere.

### Target Scoping

Firewall rules apply to different scopes:

#### 1. All Instances in Network (Default)
- Applies rule to all VMs in the VPC
- Simplest but least granular option

#### 2. Specified Service Account
- Targets VMs created with specific service account
- Provides least-privilege access control
- Recommended by Google for security

**Service Account Benefits:**
- Cannot be modified by users with compute permissions
- Requires VM restart to change
- Prevents accidental or malicious tag modifications

#### 3. Specified Target Tags
- Uses custom "network tags" on VM instances
- Most flexible targeting mechanism
- Allows fine-grained control

**Note**: Network tags and target tags are the same concept.

### Source Filters

Ingress rules filter based on traffic origin:

#### IP Ranges (IPv4/IPv6)
- `0.0.0.0/0`: Any IP address (internet)
- Specific CIDR blocks: `10.0.0.0/8`, `192.168.1.0/24`
- Multiple ranges: `10.0.0.0/8, 172.16.0.0/12`

#### Service Accounts (Cross-Project)
- Allows traffic from VMs using specified service account
- Enables secure cross-project communication

**Rule**: Can use either IP ranges OR service accounts, not both simultaneously.

### Protocol and Port Specifications

Rules support:
- **All traffic**: Permit/deny all protocols
- **Specific protocols**: `tcp`, `udp`, `icmp`
- **Port ranges**: `tcp:22`, `tcp:80-443`, `udp:53`

**Examples:**
```
tcp:22       # SSH
tcp:80,443   # HTTP/HTTPS
tcp:3389     # RDP
icmp         # Ping
```

### Rule States

Rules can be:
- **Enabled**: Active and applied
- **Disabled**: Present but not enforced
- **Deleted**: Completely removed

### Firewall Logs and Insights

- **Logging**: Optional metadata logging for rule usage analysis
- **Firewall Insights**: Analyze rule effectiveness and usage patterns

## Lab Demos

### Demo 1: Creating a Custom Firewall Rule

**Objective**: Create ingress rule allowing TCP port 22 from any IP

**Steps:**
1. Navigate to VPC network → Firewall
2. Click "Create Firewall Rule"
3. Configure:
   - Name: `allow-ssh-custom`
   - Network: `default`
   - Priority: `1000` (default)
   - Direction: `Ingress`
   - Action: `Allow`
   - Target: `All instances in the network`
   - Source IP ranges: `0.0.0.0/0`
   - Protocols and ports: `tcp:22`
4. Create rule

### Demo 2: Testing Rule Priority with Deny Rule

**Objective**: Block ICMP traffic within VPC subnet using higher priority rule

**Steps:**
1. Create VMs (vm1, vm2) in default VPC
2. Verify internal pinging works (default-allow-internal rule)
3. Create rule with higher priority to block ICMP:
   - Name: `block-internal-ping`
   - Network: `default`
   - Priority: `1000` (higher than 65534)
   - Direction: `Ingress`
   - Action: `Deny`
   - Target: `All instances in the network`
   - Source IP ranges: `10.128.0.0/9` (VPC subnet)
   - Protocols: `icmp`
4. Verify ICMP traffic is blocked
5. Disable rule → Traffic resumes

### Demo 3: Using Target Tags for Granular Control

**Objective**: Block ICMP traffic only for specific VM using network tags

**Steps:**
1. Create deny ICMP rule:
   - Name: `block-tagged-icmp`
   - Network: `default`
   - Priority: `900`
   - Direction: `Ingress`
   - Action: `Deny`
   - Target: `Specified target tags`
   - Target tags: `block-icmp` (custom identifier)
   - Source IP ranges: `10.128.0.0/9`
   - Protocols: `icmp`
2. Apply tag to vm2:
   - Edit vm2 → Network tags → Add `block-icmp`
   - Save changes
3. Test: vm1 can ping vm2? No ✓, vm2 can ping vm1? Yes ✓

### Demo 4: Egress Rule with Service Account Target

**Objective**: Prevent specific outgoing traffic using egress rule

**Steps:**
1. Confirm egress to Google DNS (8.8.8.8) works
2. Create egress deny rule:
   - Name: `block-google-dns`
   - Network: `default`
   - Direction: `Egress`
   - Action: `Deny`
   - Target: `Specified service accounts`
   - Service account: `Compute Engine default service account`
   - Destination IP ranges: `8.8.8.8/32`
   - Protocols: `icmp`
3. Verify: Cannot ping 8.8.8.8 ✓
4. Verify: Can ping other IPs (8.8.4.4) ✓

## Summary

### Key Takeaways

```diff
+ Firewall rules are VPC-specific and control network traffic at the instance level
+ Priority determines rule evaluation order (lower number = higher priority)
+ Deny rules take precedence over allow rules with identical priority
+ Use service accounts for targeted, secure access control
+ Target tags provide flexible instance-level control
+ Default rules provide broad access - customize for security
+ Test rules thoroughly before production deployment
+ Use firewall insights to monitor rule effectiveness
- Avoid 0.0.0.0/0 source ranges in production
- Never rely solely on default rules for security
- Don't create conflicting rules without understanding precedence
- Avoid modifying Google-managed default rules
```

### Quick Reference

**Common Commands:**
```bash
# Test connectivity (Linux)
ping <target-ip>

# SSH to instance
ssh username@<instance-external-ip>

# Check current rules (gcloud)
gcloud compute firewall-rules list --filter="network:(default)"
```

**Firewall Rule Syntax:**
```yaml
# Example ingress allow rule
name: allow-web-traffic
network: default
direction: INGRESS
action: ALLOW
targetTags: [web-server]
sourceRanges: [0.0.0.0/0]
allowed:
- protocol: tcp
  ports: [80, 443]
```

**Default Priorities:**
- Custom rules: Use 0-65534 (lower = higher priority)
- Google's rules: 65534-65535 (don't modify)

### Expert Insight

**Real-world Application**: In production environments, implement zero-trust networking by:
- Starting with deny-all default rules
- Using service accounts for application-to-application communication
- Implementing network segmentation through careful target tag usage
- Leveraging VPC flow logs and firewall insights for continuous monitoring

**Expert Path**: Master VPC firewall design by:
- Understanding stateful vs stateless filtering implications
- Designing hierarchical firewall policies (project → organization level)
- Implementing network security through service accounts and IAM
- Performing regular firewall rule audits using firewall insights

**Common Pitfalls**:
- Creating rules with overly broad source ranges
- Ignoring rule priority causing unexpected traffic blocking
- Using network tags without corresponding VM tag assignments
- Modifying default Google rules instead of creating custom ones
- Forgetting egress rules control outbound traffic (often overlooked)
- Not testing rules in non-production environments first

</details>