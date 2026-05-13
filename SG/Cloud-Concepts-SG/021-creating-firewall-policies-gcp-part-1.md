<details open>
<summary><b>[Session 021: Creating Firewall Policies in GCP - Part 1] (KK-CS45-script-v2)</b></summary>

# Session 021: Creating Firewall Policies in GCP - Part 1

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Introduction to Firewall Policies](#introduction-to-firewall-policies)
  - [Types of Firewall Policies](#types-of-firewall-policies)
  - [Traffic Evaluation and Rules](#traffic-evaluation-and-rules)
  - [Priorities in Firewall Policy Rules](#priorities-in-firewall-policy-rules)
  - [Limitations of Firewall Policies](#limitations-of-firewall-policies)
  - [Creating and Managing Hierarchical Firewall Policies](#creating-and-managing-hierarchical-firewall-policies)
  - [Lab Demo: Hierarchical Firewall Policy in Action](#lab-demo-hierarchical-firewall-policy-in-action)
- [Summary](#summary)

## Overview
This session introduces firewall policies in Google Cloud Platform (GCP), focusing on hierarchical firewall policies. Firewall policies allow grouping and enforcing firewall rules across different scopes like organizations, folders, or projects. The session covers the three main types of firewall policies, how they evaluate traffic, and demonstrates a practical example using hierarchical policies to manage traffic at the organization level, including allowing and denying specific traffic while interacting with VPC firewall rules.

![Diagram of Firewall Policy Evaluation Order](mermaid
graph TD
    A[Traffic Incoming] --> B[Organization Policy]
    B --> C{Action: Allow/ Deny/ Go to Next}
    C -->|Allow| D[Traffic Allowed to Instance]
    C -->|Deny| E[Traffic Dropped]
    C -->|Go to Next| F[Folder Policy]
    F --> G{Action}
    G -->|Allow| D
    G -->|Deny| E
    G -->|Go to Next| H[VPC Firewall Rules]
    H --> I{Action}
    I -->|Allow| D
    I -->|Deny| E
    I -->|Go to Next| J[Next Policy or Default Block]
)

## Key Concepts and Deep Dive

### Introduction to Firewall Policies
Firewall policies are advanced security features in GCP that enable centralized management of firewall rules. Unlike VPC firewall rules that apply at the project level, firewall policies can be applied at organization, folder, or regional levels. This allows for consistent enforcement across multiple projects and resources, simplifying security governance.

**Textbook Definition**: A firewall policy is a collection of security rules grouped together to control network traffic flow at different hierarchical levels in Google Cloud.

### Types of Firewall Policies
There are three primary types of firewall policies in GCP:

| Type | Scope | Description |
|------|-------|-------------|
| **Hierarchical Firewall Policy** | Organization and Folder | Applied at the organization level or to specific folders for broad coverage. |
| **Global Network Firewall Policy** | Project-wide | Created within a project and applies globally across all regions in that project. |
| **Regional Network Firewall Policy** | Region-specific | Applies only to a specific region, allowing fine-grained regional control. |

Each type serves different use cases: hierarchical for top-down enforcement, global for project consistency, and regional for localized needs.

### Traffic Evaluation and Rules
Firewall policies evaluate traffic in a hierarchical order:
1. Organization-level policies evaluated first.
2. Traffic proceeds to folder policies if set to "go to next."
3. Then to VPC network policies (global or regional).
4. Finally, to VPC firewall rules.

Rules within policies include:
- **Ingress**: Controls incoming traffic (e.g., from external sources to GCP resources).
- **Egress**: Controls outgoing traffic (e.g., from GCP resources to the internet).
- **Actions on Match**: Three possible actions for each rule:
  - **Allow**: Permits the traffic and stops evaluation.
  - **Deny**: Blocks the traffic and stops evaluation.
  - **Go to Next**: Continues to the next policy level; if unmatched, falls back to implied deny rules.

Implied rules (automatically applied) handle any unmatched traffic:
- For IPv4: Go to next (lowest priority).
- For IPv6: Similar behavior.

### Priorities in Firewall Policy Rules
- Priorities range from 0 to a large number (e.g., up to 2^31-1), allowing wide flexibility.
- Lower numbers indicate higher priority (e.g., 1000 > 1020 in importance).
- **Unique Priority Requirement**: Unlike VPC firewall rules (which allow multiple rules with the same priority), each rule in a firewall policy must have a unique priority. Attempting to create duplicate priorities results in an error.

Example command to create a rule with gcloud (illustrative only):
```bash
gcloud compute network-firewall-policies rules create RULE_ID \
  --network-firewall-policy POLICY_NAME \
  --priority 1000 \
  --direction ingress \
  --action allow \
  --source-ranges 0.0.0.0/0 \
  --protocols tcp:80 \
  --organization ORGANIZATION_ID
```
Correct any misspellings: "firewall policies" is consistently "firewall policies" in transcript; no major errors noted beyond occasional "Fireball" which is corrected to "firewall".

### Limitations of Firewall Policies
- **Targeting**: Cannot use source tags or service accounts (only target service accounts or VPC networks allowed). No network tags support.
- **Application Scope**: Cannot be applied directly at the VPC network level; only to organizations, folders, or specific VPCs via policy association.
- **Logging**: Logging is supported for Allow and Deny rules but not for "Go to Next" rules.
- **Association**: Only one firewall policy can be associated with a node (organization or folder) at a time.
- **Predefined Rules**: Automatic implied rules for IPv4/IPv6 go-to-next actions exist but cannot be modified.
- **IPv6 Support**: Only one version (IPv4 or IPv6) per rule; cannot mix.

> [!IMPORTANT]
> When designing firewall policies, carefully evaluate higher-level rules (e.g., organization-level allows) to avoid overriding lower-level denies, as allowed traffic ceases evaluation.

### Creating and Managing Hierarchical Firewall Policies
Hierarchical policies are created at the organization level (requires an organization account, e.g., via Google Cloud Identity).

**Steps to Create**:
1. In GCP Console, navigate to Organization > Firewall Policies.
2. Create a new policy with a unique name and optional description.
3. Add rules: Specify priority, direction (ingress/egress), action, source/target IP ranges, protocols.
4. Associate the policy with an organization or folder node.
5. Enable logging if needed.

Policies can target specific VPC networks or service accounts for selective application instead of affecting the entire organization.

### Lab Demo: Hierarchical Firewall Policy in Action
The demo demonstrates traffic control using a hierarchical policy.

**Setup**:
- Existing VPC with a VM running a web server on port 80 (displays VM IP).
- Organization account with hierarchical firewall policy.

**Demo Steps**:
1. **Block Traffic at VPC Level**:
   - Create VPC firewall rule: Egress, deny ICMP to 8.8.8.8 (Google DNS).
   - Test: Ping 8.8.8.8 from VM fails (blocked).

2. **Override with Hierarchical Policy**:
   - Add egress rule in hierarchical policy: Priority 3000, allow ICMP to 8.8.8.8/32.
   - Effect: Ping succeeds, demonstrating policy precedence.

3. **Deny Ingress Traffic**:
   - Add ingress rule: Priority 4000, deny HTTP (TCP:80) from 0.0.0.0/0.
   - Create new VM in another VPC with startup script serving web page.
   - Associate policy selectively or broadly.
   - Test: Unassociated VPC allows access; associated blocks the web server.

**Commands Used (Illustrative)**:
```bash
# Example ping test
ping 8.8.8.8

# Create VPC firewall rule via gcloud (approximate)
gcloud compute firewall-rules create deny-google-dns \
  --direction egress \
  --priority 1000 \
  --network my-vpc \
  --action deny \
  --destination-ranges 8.8.8.8/32 \
  --rules icmp
```

This demo shows how hierarchical policies can selectively allow/deny traffic, overriding VPC rules when associated.

## Summary

### Key Takeaways
```diff
+ Hierarchical firewall policies enable organization-wide traffic management, ensuring consistent security across projects.
- Policies are evaluated before VPC firewalls, so higher-level allows override lower-level denies.
! Unique priorities are mandatory, preventing rule ambiguities.
+ Three policy types allow flexible scoping: hierarchical (org/folder), global (project-wide), regional (region-specific).
- Limitations include no source tags, no logging for "go to next," and strict association rules.
```

### Quick Reference
- **Priority Range**: 0 to large number (unique per rule).
- **Implied Rules**: Automatic go-to-next for unmatched IPv4/IPv6 traffic.
- **Actions**: Allow, Deny, or Go to Next.
- **Console Path**: Organization > IAM & Admin > Firewall Policies.

### Expert Insight
**Real-world Application**: Use hierarchical policies for enterprise governance, e.g., denying all external SSH at organization level while allowing specific dev environments via folder policies.

**Expert Path**: Start with Least Privilege: Begin with deny-all defaults, gradually allowing services. Integrate with VPC PhD Security Groups for fine-tuning. Monitor logs via Cloud Logging for audit trails.

**Common Pitfalls**: Overlooking priority uniqueness causes creation failures. Forgetting that allowed traffic at org-level bypasses VPC denies. Testing changes in non-production environments to avoid service disruption.
</details>