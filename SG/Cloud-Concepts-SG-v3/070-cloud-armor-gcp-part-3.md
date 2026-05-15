<details open>
<summary><b>Session 070: Cloud-Armor-GCP-Part-3 (KK-CS45-script-v3)</b></summary>

# Session 070: Cloud-Armor-GCP-Part-3

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-concepts-deep-dive)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview
This session covers Cloud Armor's Preview Mode and Advanced Match Conditions. You'll learn how to evaluate security rule effects without enforcement, write custom C Expression Language queries, and implement complex filtering based on attributes like origin IP, region, ASN, cookies, and request paths. The session includes practical demonstrations of blocking traffic by geographic region, ASN number, and specific request paths.

## Key Concepts/Deep Dive

### Preview Mode
Preview mode allows you to test Cloud Armor security rules without affecting actual traffic. When enabled:
- Google Cloud processes incoming requests against preview rules but doesn't enforce them
- Comprehensive logging captures both enforced rule outcomes and preview rule outcomes
- You can analyze rule effectiveness safely before deployment
- Remains active for individual rules or entire policies

**Important**: Logging must be enabled on the backend service or load balancer for preview mode to generate useful logs. Without logging enabled, no security policy logs will be available.

### Advanced Match Conditions
Custom rules leverage the C Expression Language (CEL) to create sophisticated filtering logic. Each expression requires two components:

1. **Attribute**: The request data to inspect (e.g., `origin.ip`, `origin.region_code`, `origin.asn`)
2. **Operation**: How to evaluate the attribute (e.g., `in`, `matches`, `equals`)

Up to five expressions can be combined using logical operators (`&&`, `||`) for complex conditions.

### Common Attributes and Operations
- **Origin IP**: `origin.ip in <IP_RANGE>`
- **Region Code**: `origin.region_code == 'US'`
- **ASN**: `origin.asn == 146915`
- **Request Path**: `request.path.matches('/admin/.*')`
- **Headers**: `request.headers['User-Agent'].contains('bot')`
- **Cookies**: `request.cookies['session'].exists()`

### Cloud Logging Integration
Security policies generate detailed logs in Cloud Logging that include:
- Enforced rule outcomes (actual traffic handling)
- Preview rule outcomes (simulated actions)
- Request metadata (IP, region, ASN, headers, cookies)
- Rule priority and configuration details

## Lab Demos

### Demo 1: Basic Preview Mode with IP Blocking
```bash
# Create a security rule blocking specific IP in preview mode
gcloud compute security-policies rules create 10000 \
  --security-policy=default-policy \
  --expression="origin.ip == 'YOUR_VM_IP'" \
  --action="deny-403" \
  --preview
```

**Steps**:
1. Navigate to Cloud Armor security policies in GCP Console
2. Select existing default policy or create new one
3. Add new rule with priority 10000
4. Configure expression for specific IP address
5. Set action to "Deny" with 403 response code
6. Enable preview mode
7. Enable logging on load balancer
8. Test connectivity from targeted IP
9. Review Cloud Logging for both enforced and preview outcomes

**Expected Results**:
- Traffic continues to flow normally (preview doesn't enforce)
- Logs show both actual allow rule and preview deny rule
- Preview outcome field indicates simulated action

### Demo 2: Geographic Blocking with Advanced Rules
```bash
# Block all US traffic
gcloud compute security-policies rules create 1000000 \
  --security-policy=default-policy \
  --expression="origin.region_code == 'US'" \
  --action="deny-502" \
  --preview
```

**Steps**:
1. Enable advanced mode in Cloud Armor rule creation
2. Use "origin.region_code" expression
3. Set action to deny with 502 (Bad Gateway) response
4. Test from VMs in different regions
5. Verify US region VMs receive 502 while others succeed

### Demo 3: Complex Conditions with Multiple Expressions
```bash
# Block traffic from US region AND specific IP range
gcloud compute security-policies rules create 999999 \
  --security-policy=default-policy \
  --expression="origin.region_code == 'US' && origin.ip in '203.0.113.0/24'" \
  --action="deny-403" \
  --preview
```

**Steps**:
1. Edit existing rule to include multiple conditions
2. Use logical AND operator (`&&`) to combine expressions
3. Update priority (higher number = lower priority)
4. Test from various IP ranges within and outside US

### Demo 4: ASN-Based Blocking
```bash
# Block traffic from specific ASN
gcloud compute security-policies rules create 9999 \
  --security-policy=default-policy \
  --expression="origin.asn == 146915" \
  --action="deny-404" \
  --preview
```

**Steps**:
1. Identify target ASN using IP detail lookup
2. Create rule with ASN expression
3. Configure deny action with 404 response
4. Test from identified ASN network

### Demo 5: Path-Based Blocking
```bash
# Block requests to forbidden paths
gcloud compute security-policies rules create 1001 \
  --security-policy=default-policy \
  --expression="request.path.matches('/forbidden')" \
  --action="deny-403" \
  --preview
```

**Steps**:
1. Use regex pattern matching for request paths
2. Test various URL paths against rule
3. Verify allowed paths work while blocked paths return 403

## Summary

```diff
+ Key Takeaways
+ Preview mode enables safe evaluation of security rules without production impact
+ Advanced match conditions use CEL for complex attribute-based filtering
+ Logical operators (&&, ||) combine multiple expressions for sophisticated rules
+ Comprehensive logging crucial for analyzing rule effectiveness
+ Attributes include IP, region, ASN, headers, cookies, and request paths
```

### Quick Reference
**Common Expressions:**
```bash
# Block US traffic
origin.region_code == 'US'

# Block specific ASN
origin.asn == 146915

# Block forbidden paths
request.path.matches('/admin/.*')

# Complex condition (US + specific IP)
origin.region_code == 'US' && origin.ip in '203.0.113.0/24'
```

**CLI Commands:**
```bash
# Create preview rule
gcloud compute security-policies rules create PRIORITY \
  --security-policy=POLICY_NAME \
  --expression="EXPRESSION" \
  --action="deny-403" \
  --preview

# Update rule to enforce
gcloud compute security-policies rules update PRIORITY \
  --security-policy=POLICY_NAME \
  --action="deny-403"
```

### Expert Insight

**Real-world Application**: Use preview mode extensively in development/QA environments to validate rule logic before production deployment. Implement progressive rollouts by initially previewing rules on a percentage of traffic.

**Expert Path**: Master regular expressions for path matching and explore custom headers/cookies for application-layer filtering. Combine geographic and network-based rules for defense-in-depth security architectures.

**Common Pitfalls**: 
- Forgetting to enable logging renders preview mode ineffective
- Using preview mode in production without monitoring can mask traffic issues
- Incorrect priority ordering can cause unexpected rule evaluation
- Complex expressions with typos may result in overly permissive rules

</details>
