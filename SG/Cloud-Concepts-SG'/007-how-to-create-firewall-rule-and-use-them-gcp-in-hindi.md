# Session 7: How to Create Firewall Rules and Use Them in GCP

<details open>
<summary><b>007-How-to-create-Firewall-rule-and-use-them-GCP-in-Hindi (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Firewall Rules in GCP VPC](#firewall-rules-in-gcp-vpc)
  - [Creating Firewall Rules](#creating-firewall-rules)
  - [Rule Priorities](#rule-priorities)
  - [Traffic Direction: Ingress vs Egress](#traffic-direction-ingress-vs-egress)
  - [Actions: Allow vs Deny](#actions-allow-vs-deny)
  - [Targets](#targets)
  - [Source and Destination Filters](#source-and-destination-filters)
  - [Protocols and Ports](#protocols-and-ports)
- [Lab Demo: Ingress Rule for Allowing ICMP](#lab-demo-ingress-rule-for-allowing-icmp)
- [Lab Demo: Egress Rule for Blocking Specific IP](#lab-demo-egress-rule-for-blocking-specific-ip)
- [Summary](#summary)

## Overview
This session focuses on creating and managing firewall rules in Google Cloud Platform (GCP) to control network traffic flow in VPC networks. We'll cover the concepts, configuration options, and practical demonstrations of both ingress (incoming) and egress (outgoing) rules.

## Key Concepts and Deep Dive

### Firewall Rules in GCP VPC
Firewall rules in GCP are stateful and evaluated in order of priority. They allow or deny traffic based on specified criteria such as IP ranges, protocols, and ports.

> [!IMPORTANT]
> Firewall rules are applied to VPC networks and can control traffic across all instances in the network or just specific instances using tags or service accounts.

### Creating Firewall Rules
Access firewall rules from the VPC network menu in Google Cloud Console:
1. Go to VPC network > Firewall policies
2. Click "Create Firewall Rule"

### Rule Priorities
- **Priority range**: 0-65535
- **Higher priority**: Lower numbers (0 is highest)
- **Evaluation order**: Rules are checked from lowest to highest priority number
- **Same priority**: Deny rules are prioritized over allow rules

```diff
+ Lower number = Higher priority (0 = maximum priority)
- Higher number = Lower priority (65535 = lowest priority)
! Always evaluate priority carefully to avoid security misconfigurations
```

### Traffic Direction: Ingress vs Egress
- **Ingress**: Incoming traffic to instances within the network
- **Egress**: Outgoing traffic from instances to external destinations

> [!NOTE]
> Egress rules control traffic leaving your instances, while ingress rules control traffic entering your instances.

### Actions: Allow vs Deny
- **Allow**: Permits traffic to pass through to the target
- **Deny**: Drops the matching traffic

### Targets
Specify which instances the rule applies to:
- **All instances in the network**: Applies to every instance in the selected VPC
- **Target tags**: Instances with matching network tags
- **Service accounts**: Instances running with specific service accounts

> [!IMPORTANT]
> Google recommends using service accounts for targeting as they provide better security control compared to tags.

### Source and Destination Filters
- **IP ranges**: Specific IPv4 or IPv6 addresses/ranges
- **Source/Destination tags**: Tags on instances in the same network

> [!NOTE]
> Source/destination tags only work within the same project and require instances to have corresponding network tags.

### Protocols and Ports
Specify which protocols and ports to allow/deny:
- **Allow all**: Permits all protocols (not recommended for public exposure)
- **Specific protocols**:
  - TCP, UDP, ICMP
  - Custom ports (e.g., port 80 for HTTP)

```bash
# Example protocol specifications
tcp:80      # TCP port 80
tcp:80,443  # TCP ports 80 and 443
udp         # All UDP ports
icmp        # ICMP protocol
```

## Lab Demo: Ingress Rule for Allowing ICMP

### Steps to Create Ingress Rule
1. Navigate to VPC network > Firewall rules
2. Click "Create Firewall Rule"
3. Configure the following options:
   - **Name**: firewall-testing
   - **Description**: Allow ICMP for testing
   - **Logs**: Optional - enable if you want to monitor traffic
   - **Network**: default (or your VPC)
   - **Priority**: Default (1000)
   - **Direction**: Ingress
   - **Action**: Allow
   - **Target**: Target tags (specify a tag like "allow-internet-traffic")
   - **Source filters**: IPv4 ranges (0.0.0.0/0 for all IPs)
   - **Protocols and ports**: icmp

### Applying the Rule to VM
1. Go to Compute Engine > VM instances
2. Select your VM and click "Edit"
3. In the Network tags section, add the same tag specified in the firewall rule (e.g., "allow-internet-traffic")
4. Save the changes

### Testing the Rule
1. Get the external IP of your VM
2. Use an online ping tool with the VM's external IP
3. Verify that ping requests are successful

## Lab Demo: Egress Rule for Blocking Specific IP

### Steps to Create Egress Rule
1. Navigate to VPC network > Firewall rules
2. Click "Create Firewall Rule"
3. Configure the following options:
   - **Name**: block-google-dns
   - **Description**: Block traffic to Google DNS IP
   - **Network**: default (or your VPC)
   - **Priority**: Default (1000)
   - **Direction**: Egress
   - **Action**: Deny
   - **Target**: Target tags (specify a tag like "block-google-dns")
   - **Destination filters**: IPv4 ranges (8.8.8.0/24 for Google DNS)
   - **Protocols and ports**: icmp

### Applying the Rule to VM
1. Go to Compute Engine > VM instances
2. Select your VM and click "Edit"
3. Add the target tag (e.g., "block-google-dns") to the Network tags
4. Save the changes

### Testing the Rule
1. From the VM, try to ping 8.8.8.8
2. Verify that the ping fails (timeout)
3. Test with a different IP to confirm other traffic works

> [!NOTE]
> The transcript contains several Hindi terms that were corrected to proper English/technical terms:
> - "बीपीसी" → VPC (Virtual Private Cloud)
> - "फायर वाल" → Firewall
> - Various transliteration corrections for GCP console options

## Summary

### Key Takeaways
- Firewall rules in GCP are evaluated based on priority, with lower numbers having higher precedence
- Use ingress rules to control incoming traffic and egress rules for outgoing traffic
- Target specific instances using network tags or service accounts for better security
- Always specify specific IP ranges and protocols rather than allowing all traffic
- Test firewall rules using tools like ping to verify functionality

### Quick Reference
#### Common Firewall Rule Configurations
```yaml
# Allow HTTP/HTTPS ingress
name: allow-web-traffic
direction: INGRESS
action: ALLOW
target_tags: ["web-server"]
source_ranges: ["0.0.0.0/0"]
protocols:
  tcp: [80, 443]

# Block egress to specific IP
name: deny-specific-destination
direction: EGRESS
action: DENY
target_tags: ["restricted-vm"]
destination_ranges: ["8.8.8.8/32"]
protocols:
  tcp: all
  udp: all
```

#### Priority Guidelines
- 0: Highest priority (use carefully)
- 100-1000: Custom rules
- 65535: Lowest priority

#### Common Protocols
- `tcp` - TCP traffic
- `udp` - UDP traffic
- `icmp` - ICMP (ping, traceroute)
- `esp` - IPSec ESP
- `ah` - IPSec AH
- `sctp` - SCTP

### Expert Insight

**Real-world Application**: In production environments, firewall rules should follow the principle of least privilege. Use service accounts instead of network tags for targeting, implement tiered architectures with separate VPCs, and regularly audit firewall logs to detect anomalies.

**Expert Path**: Master complex rule interactions by creating multiple rules with different priorities and understanding precedence. Learn to implement hierarchical firewall policies at the organization level and integrate with Cloud Identity-Aware Proxy (IAP) for additional security.

**Common Pitfalls**:
- Avoid using "Allow all" for protocols/ports in production
- Watch for conflicting rules with similar priorities (remember: deny overrides allow)
- Ensure source/destination tags match exactly on target instances
- Regular review of unused firewall rules to prevent security drift

</details>