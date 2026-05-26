# Session 69: Cloud Armor GCP Part 2

<details open>
<summary><b>Session 69: Cloud Armor GCP Part 2 (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Edge Security Policies](#edge-security-policies)
- [Network Security Policies](#network-security-policies)
- [Backend vs Edge vs Network Policy Comparison](#backend-vs-edge-vs-network-policy-comparison)
- [Two-Layer Protection with Edge + Backend Policies](#two-layer-protection-with-edge--backend-policies)
- [Regional vs Global Policies](#regional-vs-global-policies)
- [Lab Demonstrations](#lab-demonstrations)
- [Summary](#summary)

## Overview

This session covers the second part of Cloud Armor focusing on Edge Security Policies and Network Security Policies. We explore how these policies differ from Backend Security Policies and how they can be applied to protect backend buckets and services at different layers. The session demonstrates creating Edge policies, applying them to backend buckets, and showcasing two-layer protection when combining Edge with Backend security policies.

## Edge Security Policies

Edge Security Policies provide global protection at Google's network edge, filtering traffic before it enters your GCP infrastructure. These policies are designed for protecting both backend services and backend buckets.

### Key Characteristics
- **Scope**: Global deployment only, cannot be regional
- **Targets**: Supports both backend services and backend buckets
- **Actions**: Allow or Deny (limited compared to backend policies)
- **Position**: First layer of defense at Google's edge

### Creating an Edge Security Policy

```bash
# Navigate to Cloud Armor
gcloud compute security-policies create edge-security-policy \
  --type=EDGE \
  --description="Edge security policy for global protection"
```

> [!NOTE]
> Edge policies are specifically designed for global load balancers and backend buckets.
> They provide defense at Google's network perimeter before traffic reaches your VPC.

## Network Security Policies

Network Security Policies are premium features that provide advanced filtering capabilities similar to Edge policies but with enhanced control.

### Key Limitations
- **Premium Feature**: Requires Google Cloud Premium Networking tier
- **Availability**: Not demonstrated in this session due to premium requirements
- **Targets**: Supports backend services and backend buckets
- **Capabilities**: Advanced threat detection and filtering

## Backend vs Edge vs Network Policy Comparison

| Policy Type | Scope | Targets | Actions | Position |
|-------------|--------|---------|---------|----------|
| Backend Security | Regional | Backend Services only | Allow, Deny, Redirect, Rate-based, Bot management | After load balancer, before backend |
| Edge Security | Global | Backend Services + Backend Buckets | Allow, Deny | At Google's network edge |
| Network Security | Global | Backend Services + Backend Buckets | Advanced filtering | At Google's network edge |

## Two-Layer Protection with Edge + Backend Policies

When both Edge and Backend policies are applied to the same backend service, traffic flows through multiple layers of protection.

### Policy Evaluation Order
1. **Edge Policy**: First evaluation at Google's network edge
2. **Backend Policy**: Second evaluation before reaching the backend service

### Demonstration Scenario
- Edge Policy: Denies traffic by default (502 response)
- Backend Policy: Allows specific IP ranges

```yaml
# Traffic Flow Example
User Request → Edge Policy (Deny: 502) → Backend Policy (Allow: 200)
```

> [!IMPORTANT]
> If traffic is denied at any layer, it will be blocked. The edge policy acts as the first line of defense.

## Regional vs Global Policies

### Regional Policies
- **Scope**: Specific GCP regions
- **Type**: Only Backend Security Policies supported
- **Targets**: Regional backend services and load balancers
- **Use Case**: Fine-grained, region-specific protection

### Global Policies
- **Scope**: Worldwide
- **Types**: Edge Security Policies (Backend policies can be global too)
- **Targets**: Global load balancers, backend buckets
- **Use Case**: Consistent protection across all regions

## Lab Demonstrations

### Creating an Edge Security Policy

1. **Create Policy**:
   ```bash
   gcloud compute security-policies create my-edge-policy \
     --type=CLOUD_ARMOR_EDGE \
     --action-on-match=deny-502
   ```

2. **Add Target**:
   ```bash
   gcloud compute security-policies attach-target my-edge-policy \
     --target-resource=my-backend-bucket
   ```

3. **Test Policy**:
   ```bash
   curl -I https://my-load-balancer-url/
   # Expected: HTTP 502 Bad Gateway
   ```

### Applying Both Edge and Backend Policies

1. **Create Edge Policy** (Default: Deny with 502):
   ```bash
   gcloud compute security-policies create edge-policy \
     --type=CLOUD_ARMOR_EDGE
   ```

2. **Create Backend Policy** with Allow Rule:
   ```bash
   gcloud compute security-policies create backend-policy \
     --type=CLOUD_ARMOR_BACKEND \
     --rules='[{ "priority": 1000, "match": { "versionedExpr": "SRC_IPS_V1", "config": { "srcIpRanges": ["192.168.1.0/24"] } }, "action": "allow" }]'
   ```

3. **Test Two-Layer Protection**:
   - Traffic allowed by Edge: Still denied if blocked by Backend policy
   - Traffic denied by Edge: Never reaches Backend policy

## Summary

```diff
+ Key Takeaways

+ Edge Security Policies provide global protection at Google's network edge before traffic reaches your VPC
+ Edge policies can protect both backend services AND backend buckets (unlike backend security policies)
+ When Edge + Backend policies are applied together, they create two layers of protection with Edge evaluated first
+ Network Security Policies are premium features with advanced filtering (not covered due to premium requirements)
+ Regional policies are limited to backend security policies only; Edge policies must be global

- Common Pitfalls
- Forgetting that Edge policies deny by default - traffic must be explicitly allowed
- Applying conflicting rules between Edge and Backend policies without understanding evaluation order
- Attempting to use premium features without appropriate Google Cloud tier
- Not testing policy propagation delays (can take several minutes)
```

### Quick Reference

**Creating Edge Policy:**
```bash
gcloud compute security-policies create my-edge-policy \
  --type=CLOUD_ARMOR_EDGE \
  --action-on-match=deny-502
```

**Attaching to Backend Bucket:**
```bash
gcloud compute security-policies attach-target my-edge-policy \
  --target-resource=my-backend-bucket
```

**Testing Policy Response:**
- `502 Bad Gateway` = Edge policy deny
- `403 Forbidden` = Backend policy deny
- `200 OK` = Traffic allowed through both layers

### Expert Insights

#### Real-world Applications
- **CDN Protection**: Secure backend buckets serving static content globally
- **Hybrid Security**: Use Edge policies for basic geography/IP filtering, Backend policies for advanced threat detection
- **Compliance Requirements**: Implement edge-level blocking for regulated industries requiring perimeter security

#### Expert Path
Master Cloud Armor by understanding the security layers: 
- Geographic restrictions → Edge policies
- Advanced threat detection → Backend policies with rules
- Rate limiting and bot management → Backend security policies
- Zero-trust implementation → Layered Edge + Backend + VPC firewall rules

#### Common Pitfalls to Avoid
- **Policy Propagation Delays**: Always wait 5-10 minutes after creating/updating policies before testing
- **Rule Priority Conflicts**: Lower priority numbers (1000) take precedence - plan rule ordering carefully
- **Backend Bucket Misconfigurations**: Edge policies protect buckets, but bucket permissions still apply separately
- **Overlapping Ranges**: IP ranges in Edge policies may conflict with Backend policy ranges when both are applied

</details>
