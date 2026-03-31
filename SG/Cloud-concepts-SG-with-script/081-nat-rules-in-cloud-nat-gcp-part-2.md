# Session 081: NAT Rules in Cloud NAT GCP Part 2

## Table of Contents
- [Introduction to NAT Rules](#introduction-to-nat-rules)
- [How NAT Rules Work](#how-nat-rules-work)
- [NAT Rule Specifications](#nat-rule-specifications)
- [Lab Demo: Creating Cloud NAT with NAT Rules](#lab-demo-creating-cloud-nat-with-nat-rules)

## Introduction to NAT Rules

### Overview
NAT rules in Google Cloud Platform's Cloud NAT service allow you to configure how outbound traffic from your Virtual Private Cloud (VPC) network is translated when accessing the internet. By defining NAT rules based on destination IP ranges, you can control which external IP addresses (NAT IPs) are used for specific outbound connections. This feature enables granular control over outbound traffic, such as directing traffic to specific destinations through dedicated NAT IPs, which is useful for compliance, egress control, or network segmentation.

### Key Concepts/Deep Dive

#### Basic Functionality
- **Source NAT Based on Destination**: NAT rules enable source Network Address Translation (NAT) where the source IP of outbound packets is replaced with a specific NAT IP, determined by the destination address.
- **Rule Structure**: Each NAT rule consists of:
  - **Match Condition**: Specifies destination IP ranges.
  - **Action**: Defines which NAT IP addresses to use for matching traffic.
- **Default Rule**: Automatically created when configuring Cloud NAT. Applies to all destinations not matched by custom rules.

#### Example Scenario
Suppose you have a subnet with VMs and a Cloud NAT gateway. You can create custom NAT rules to route traffic differently based on destinations:

- **Rule 1**: For destination range 19.2.150.100/30, use NAT IP 1.
- **Rule 2**: For destination range 100.30.0.0/30 to 100.31.0.0/30, use NAT IP 2.
- **Default Rule**: For any other destination, use NAT IP 3.

This allows assigning different NAT IPs to specific destinations, enhancing control over outbound connections.

#### Multiple Subnets Support
- Each subnet can have its own NAT gateway with INDIVIDUAL NAT rules.
- For example, Subnet 1 may have multiple custom rules, while Subnet 2 relies on a default rule only, routing all traffic to the internet.

#### NAT Gateway Configuration Without Rules
- If no custom NAT rules are defined, only the default rule exists.
- All outbound traffic uses the default NAT IP(s) defined during NAT gateway creation.

## How NAT Rules Work

### Match and Action Mechanism
- NAT rules operate on a match-action basis:
  - **Match Condition**: Evaluates the destination IP of outbound packets (e.g., a VM sending traffic to a specific IP range).
  - **Action**: If matched, replaces the source IP with the specified NAT IP(s).
- Supports fine-tuning outbound connections by associating destinations with specific NAT IPs.

### Benefits
- Create multiple NAT IPs and associate them with different destinations.
- Useful for scenarios requiring dedicated IPs per destination, such as compliance (e.g., ensuring traffic to specific external services uses a particular egress IP).

## NAT Rule Specifications

### Core Requirements
- **Unique Rule Numbers**: Each NAT rule must have a unique number (e.g., 1 to 65534). No two rules can share the same number within a Cloud NAT configuration.
- **Default Rule Automatic Creation**: A default rule is always present and cannot be removed.
- **Manual NAT IP Allocation Only**: NAT rules are supported only when the NAT IP allocation mode is set to **Manual**. The Automatic mode does not support custom rules.
- **Same Tier Constraint**: All NAT IPs within a single rule must belong to the same network tier (Standard or Premium). Mixing tiers in one rule is prohibited.
- **Multiple NAT IPs Per Rule**: A.rule can include multiple NAT IPs to distribute traffic across them, depending on configuration needs.
- **Non-Overlapping Destination Ranges**: Destination IP ranges across different NAT rules must not overlap. This prevents ambiguity; at most, one rule can match a given packet.
- **NAT IP Uniqueness**: A NAT IP address cannot be attached to multiple rules simultaneously. Each NAT IP is exclusive to one rule.
- **Incompatibility with Endpoint Independent Mapping**: NAT rules cannot be enabled if Endpoint Independent Mapping is activated. Ensure this feature is disabled to use NAT rules.

### Additional Notes
- Rule priority follows the rule number, with lower numbers having higher priority (e.g., rule 1 checks before rule 651).
- Logging can be enabled to monitor NAT translations and errors, providing visibility into traffic flow and IP usage.

### Diagram: NAT Rules Flow

```mermaid
graph TD
    A[VM in Subnet Sends Packet] --> B{NAT Rule Evaluation}
    B -->|Matches Rule 100 Destination Range| C[Use NAT IP 1 (Premium)]
    B -->|Matches Rule 200 Destination Range| D[Use NAT IP 2 (Standard)]
    B -->|No Match| E[Use Default NAT IP]
    C --> F[Outbound Traffic with NAT IP 1]
    D --> G[Outbound Traffic with NAT IP 2]
    E --> H[Outbound Traffic with Default NAT IP]
```

## Lab Demo: Creating Cloud NAT with NAT Rules

### Pre-Requisites
- Two VMs: One internal (used in previous demo), one external with Apache web service running.
- Cloud Router already created in the previous part.
- VPC network with subnets in Mumbai region (asia-south1).

### Step-by-Step Demo

1. **Verify Current Setup**:
   - VMs cannot reach the internet without NAT configuration.
   - Attempt to ping an external IP; it should fail.

2. **Create Cloud NAT Gateway**:
   - Navigate to VPC Network > Cloud NAT in GCP Console.
   - Click "Create NAT gateway".
   - Select "Public NAT" (private NAT covered in next video).
   - Choose the VPC network and region (e.g., asia-south1 matching VM location).
   - Select the Cloud Router (created in Part 1).
   - Enable "Manual" for NAT IP allocation to access NAT rules.
   - Configure subnets: Select all primary and secondary ranges.

3. **Enable NAT Rules**:
   - In NAT IP allocation, select "Manual".
   - NAT rules section appears, allowing up to 50 custom rules.
   - Reserve NAT IPs first:
     - Click "Reserve private IP" for Premium tier.
     - Name it (e.g., "nat-ip-1").
   - Add NAT rule:
     - Click "Add rule".
     - Define destination range (e.g., copy VM's external IP: 35.200.147.100/32? - adjust for single IP or range).
     - Select network tier (Premium).
     - Attach reserved NAT IP.
     - Set unique rule number (e.g., 100).
     - Enable logging for translation and errors.
   - Create additional NAT IPs and rules similarly for other destinations.

4. **Test Configuration**:
   - SSH into external VM.
   - Run `curl` to access a web service:
     ```bash
     curl http://your-vm-external-ip
     ```
     - This matches the custom rule and uses the associated NAT IP (e.g., 34.93.228.228).
   - Run `curl example.com`.
   - Perform `nslookup example.com` to get destination IPs.
   - Check NAT logs: Look for entries showing NAT IP usage based on destination.

5. **Add Another Rule with Different Tier**:
   - Reserve a Standard tier NAT IP (e.g., "standard-ip-1").
   - Add new rule for another destination (e.g., cisco.com IP range).
     - Rule number: 200 (unique).
     - Attach Standard NAT IP.
   - Save changes.
   - Test with `curl cisco.com` or relevant command; traffic should use the new NAT IP.

6. **Edit and Expand Rules**:
   - Inside NAT gateway, edit rules to add multiple NAT IPs per rule.
   - Note: Cannot mix Premium and Standard IPs in one rule; entire rule must use same tier.

7. **Key Observations from Logs**:
   - Logs show:
     - Destination IP, allocation status, NAT IP used.
     - Rule-matching based on IP ranges.

### Common Commands Used
- **Ping (to verify no internet access initially)**:
  ```bash
  ping 8.8.8.8
  ```
- **Curl for HTTP requests**:
  ```bash
  curl http://example.com
  curl cisco.com
  ```
- **DNS Lookup**:
  ```bash
  nslookup example.com
  nslookup cisco.com
  ```

### Errors and Resolutions
- **Rule Number Duplication**: Error when assigning same rule number. Resolve by using unique numbers (1-65534).
- **Tier Mixing**: Cannot add different-tier NAT IPs to one rule; ensure consistency within rules.

## Summary

### Key Takeaways
```diff
+ NAT rules allow fine-grained control over outbound traffic by associating specific destinations with dedicated NAT IPs.
+ Supported only in manual NAT IP allocation mode.
+ Rules must have unique numbers, use same-tier NAT IPs, and avoid overlapping destination ranges.
+ Default rule always exists for unmatched traffic.
+ Useful for compliance, traffic segregation, and monitoring via logging.
- Cannot enable NAT rules with Endpoint Independent Mapping.
- NAT IPs cannot be shared across rules; each IP is exclusive.
! Ensure manual mode is selected; automatic mode lacks rule configuration.
```

### Expert Insight

#### Real-World Application
In production environments, use NAT rules to enforce egress policies. For instance, route sensitive traffic (e.g., to regulatory services) through audited NAT IPs to maintain compliance logs. In hybrid clouds, assign specific NAT IPs for traffic to on-premises VPN endpoints, ensuring traceability and security.

#### Expert Path
Master NAT rules by understanding GCP's network tiers (Premium for low-latency, Standard for cost-optimization) and integrating with VPC Flow Logs for advanced monitoring. Experiment with CIDR ranges for broad rule matching, and automate NAT creation using Terraform to version network configurations.

#### Common Pitfalls
- Overlapping destination ranges lead to undefined behavior; always validate IP ranges manually or with tools.
- Forgetting to enable manual allocation disables NAT rules entirely; double-check during setup.
- Mixing tiers in one rule causes creation failures; plan rules around consistent tiers.
- Ignoring logging misses insights into traffic patterns; enable it for troubleshooting.

#### Common Issues with Resolution
- **No Internet Access After NAT Setup**: Verify NAT gateway status and routing policies. Resolution: Check subnet associations and firewall rules allowing outbound traffic.
- **Traffic Not Using Expected NAT IP**: Rule mismatch due to overlapping ranges. Resolution: Review and adjust destination IP specifications; use more specific CIDRs.
- **Logging Not Capturing Events**: Disabled or misconfigured. Resolution: Enable translation/error logging in NAT gateway settings and wait for log propagation.

#### Lesser-Known Things
- NAT rules can be chained with VPC peering for cross-network egress control.
- Rule evaluation happens in numerical order (lowest number first), but default rule always applies last.
- GCP charges NAT rules based on translated bytes, separate from NAT IP costs.

---

**Transcript Corrections Noted:**
- "net" corrected to "NAT" throughout (e.g., "Cloud net" to "Cloud NAT", "net rules" to "NAT rules").
- "crul" corrected to "curl" in commands.
- "htp" not present, but "cur" is "curl".
- "tooles" corrected to "tools".
- "Tire" corrected to "tier" (network tier: Standard/Premium).
- "Enableo independent mapping" corrected to "Endpoint Independent Mapping".
- "nict" and "cbectl" not applicable; main issues were NAT vs net, tier vs tire, curl vs cur. No "http" or "kubectl" errors found.
