# 068-Cloud-Armor-GCP-Part-1

<details open>
<summary><b>068-Cloud-Armor-GCP-Part-1 (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Cloud Armor Introduction](#cloud-armor-introduction)
  - [Protection Scope](#protection-scope)
  - [Security Policies](#security-policies)
  - [Rule Evaluation and Priority](#rule-evaluation-and-priority)
  - [Policy Scoping](#policy-scoping)
  - [Rule Actions](#rule-actions)
- [Lab Demos](#lab-demos)
  - [Demo Setup](#demo-setup)
  - [Creating Security Policies](#creating-security-policies)
  - [IP-Based Blocking Demo](#ip-based-blocking-demo)
  - [Throttling Demo](#throttling-demo)
  - [Rate-Based Ban Demo](#rate-based-ban-demo)
  - [Redirect with reCAPTCHA Demo](#redirect-with-recaptcha-demo)
- [Summary](#summary)

## Overview

Cloud Armor is Google's web application firewall (WAF) and DDoS protection service for Google Cloud Platform that protects applications from various cyber threats including denial-of-service attacks, cross-site scripting (XSS), SQL injection, and other Layer 7 attacks. It works by creating security policies that filter traffic before it reaches your backend services, providing always-on protection at the edge of Google's network.

The service integrates with Google Cloud load balancers and content delivery networks, allowing you to configure rules based on IP addresses, geographic locations, request headers, and other criteria to allow, deny, throttle, or redirect traffic according to your security requirements.

## Key Concepts and Deep Dive

### Cloud Armor Introduction

Cloud Armor provides comprehensive protection for Google Cloud deployments against multiple types of threats:

- **DoS Attacks**: Denial of Service attacks that attempt to make services unavailable
- **Application Attacks**: Layer 7 attacks including XSS (Cross-Site Scripting) and SQL injection
- **Volumetric Attacks**: Network and protocol-based DDoS attacks generating massive traffic

```yaml
# Cloud Armor Protection Types
Web Application Threats:
  - XSS (Cross-Site Scripting)
  - SQL Injection
  - Other application-layer attacks

Network Threats:
  - SYN floods
  - UDP floods
  - ICMP floods
  - Other volumetric DDoS
```

> [!IMPORTANT]
> Cloud Armor provides always-on DDoS protection without additional configuration - you only need to create custom security policies for application-specific rules.

### Protection Scope

Cloud Armor protects applications running behind supported Google Cloud load balancers:

**Supported Load Balancers:**
- Global External Application Load Balancer
- Classic Application Load Balancer
- Regional Application Load Balancer
- Regional Internal Application Load Balancer
- Global Network Load Balancers

**Additional Support (Enterprise License Required):**
- VMs with public IP addresses
- Protocol forwarding

> [!NOTE]
> Protection works by scrubbing incoming requests at the load balancer level, blocking malicious traffic before it reaches your backend services or instance groups.

### Security Policies

Cloud Armor uses security policies containing rules that filter traffic based on conditions. Each policy consists of:
- **Conditions**: IP addresses, ranges, regions, headers, or request attributes
- **Actions**: Allow, deny, redirect, throttle, or rate-based ban
- **Priority-based evaluation**: Rules processed from lowest to highest priority number

#### Types of Security Policies

| Policy Type | Description | Target Resources | License |
|-------------|-------------|------------------|---------|
| Backend Security Policy | Applied at backend level for instance groups, network endpoint groups | Backend services, buckets (Cloud Storage, Cloud CDN) | Standard |
| Edge Security Policy | Applied at network edge before cache lookup | Cloud CDN endpoints, Cloud Storage buckets | Standard |
| Network Edge Security Policy | Applied at network level for volumetric attack prevention | VMs with public IP, protocol forwarding | Enterprise |

### Rule Evaluation and Priority

Rules are evaluated in priority order:
- **Lowest priority number = Highest precedence** (0 is maximum priority)
- Rules evaluated sequentially until a match is found
- Default rule (usually allow or deny all) has lowest priority
- Recommended: Space priorities with gaps (100, 200, 500) for future rule insertion

### Policy Scoping

Policies can be scoped globally or regionally:

**Global Scoping:**
- Used with global load balancers
- Supports backend services and backend buckets
- Edge security policies can be global

**Regional Scoping:**
- Used with regional load balancers
- Supports regional backend services
- Network edge security policies are regional
- Does not support redirect actions

### Rule Actions

Cloud Armor supports five rule actions:

| Action | Description | Use Case |
|--------|-------------|----------|
| Allow | Permits traffic to pass through | Default permissive behavior |
| Deny | Blocks traffic with HTTP error code | Blocking malicious IPs/ranges |
| Throttle | Limits request rate with error response | Rate limiting per IP/client |
| Rate-based Ban | Temporarily bans clients exceeding thresholds | Progressive blocking |
| Redirect | Sends clients to different URL or reCAPTCHA | Bot protection, external handling |

**Action Configuration Options:**
- Deny: HTTP status codes (404 Not Found, 403 Forbidden, 502 Bad Gateway)
- Throttle: Request count threshold + time window + enforcement key
- Rate-based Ban: Rate threshold + ban duration + ban trigger threshold
- Redirect: External URL or Google reCAPTCHA Enterprise

## Lab Demos

### Demo Setup

The demo environment uses:
- Global External Application Load Balancer
- Two backend instance groups (europe-west2, us-west4)
- Backend bucket with Cloud CDN enabled
- Test VMs for traffic simulation

**Load Balancer Configuration:**
```bash
# Backend Service 1 (Europe)
Region: europe-west2
Instance Group: my-europe-ig
Port: 80

# Backend Service 2 (US)
Region: us-west4  
Instance Group: my-us-ig
Port: 80

# Backend Bucket
Bucket: my-cdn-bucket
CDN: Enabled

# Routing Rules
- /city.png -> Backend Bucket
- /* -> Backend Service (default)
```

### Creating Security Policies

**Basic Policy Creation Steps:**
1. Navigate to **Network Security > Cloud Armor** in Google Cloud Console
2. Click **Create Policy**
3. Choose policy type (Backend/Global or Edge/Network)
4. Configure default rule (allow/deny all)
5. Add specific rules with conditions and actions
6. Set priorities (lower numbers = higher priority)
7. Attach policy to target backend service

```yaml
# Example Backend Security Policy Structure
policy:
  name: "block-malicious-traffic"
  type: "BACKEND_SECURITY_POLICY"
  scope: "GLOBAL"
  default_rule:
    action: "ALLOW"
  rules:
    - priority: 1000
      description: "Block specific IP"
      condition: "srcIp == '203.0.113.1'"
      action: "DENY"
      preview: false
  target:
    backend_service: "my-backend-service"
```

### IP-Based Blocking Demo

**Configuration:**
```yaml
rule:
  description: "Block test VM traffic"
  ip_ranges: ["35.203.123.45"]  # Test VM IP
  action: "DENY"
  response_code: 404  # Not Found
  priority: 100000
```

**Testing Results:**
```bash
# From allowed IP (normal access)
curl http://load-balancer-ip/
# Returns: 200 OK + backend response

# From blocked IP  
curl http://load-balancer-ip/
# Returns: 404 Not Found

# Backend bucket access (not affected by backend policy)
curl http://load-balancer-ip/city.png
# Returns: 200 OK + image content
```

> [!IMPORTANT]
> Backend security policies only affect traffic routed to backend services, not backend buckets. Use edge security policies for comprehensive coverage.

### Throttling Demo

**Throttle Rule Configuration:**
```yaml
rule:
  description: "Throttle excessive requests"  
  action: "THROTTLE"
  rate_limit_options:
    conform_action: "ALLOW"
    exceed_action: "DENY"
    rate_limit_threshold:
      count: 5          # Max requests
      interval_sec: 60  # Per minute
  enforce_on_key: "IP"   # Per source IP
  priority: 10000
```

**Testing Results:**
```bash
# First 5 requests (allowed)
for i in {1..5}; do curl http://lb-ip/; done
# Returns: 200 OK responses

# 6th request (throttled)
curl http://lb-ip/
# Returns: 429 Too Many Requests

# After 1 minute, requests work again
sleep 60
curl http://lb-ip/
# Returns: 200 OK
```

### Rate-Based Ban Demo

**Rate-Based Ban Configuration:**
```yaml
rule:
  description: "Rate-based IP banning"
  action: "RATE_BASED_BAN"
  rate_limit_options:
    conform_action: "ALLOW" 
    exceed_action: "BAN"
    rate_limit_threshold:
      count: 5
      interval_sec: 30
  ban_options:
    ban_duration_sec: 60      # Ban for 1 minute
    ban_threshold:
      count: 8                # Trigger ban after 8 requests in 1 minute
  enforce_on_key: "ALL"
  priority: 1000
```

**Testing Results:**
```bash
# Initial requests work
curl http://lb-ip/  # 200 OK
# ... up to 5 requests in 30 seconds work

# After 30 seconds, 3 more requests work  
curl http://lb-ip/  # 200 OK x3

# 9th request = BAN triggered
curl http://lb-ip/  # 429 Too Many Requests + BAN

# Must wait 60 seconds for ban to expire
```

### Redirect with reCAPTCHA Demo

**reCAPTCHA Redirect Configuration:**
```yaml
rule:
  description: "Bot protection with reCAPTCHA"
  action: "REDIRECT"
  redirect_options:
    type: "GOOGLE_RECAPTCHA"
  priority: 999
```

**Requirements:**
- Enable Cloud Armor Enterprise API
- Configure reCAPTCHA Enterprise site key
- Potential charges apply for reCAPTCHA usage

**Testing Results:**
```bash
# First request triggers reCAPTCHA challenge
curl http://lb-ip/
# Returns: reCAPTCHA verification page

# After completing reCAPTCHA verification
# Subsequent requests work normally for that session
```

## Summary

### Key Takeaways
```diff
+ Cloud Armor provides always-on DDoS protection for applications behind Google Cloud load balancers
+ Three policy types: Backend (service-level), Edge (CDN/cached content), Network Edge (volumetric attacks)
+ Rules evaluated by priority order (lowest number = highest precedence)
+ Five action types: Allow, Deny, Throttle, Rate-based Ban, Redirect
+ Global policies for global load balancers; Regional for regional deployments
+ Backend policies protect backend services; Edge policies protect cached content
- A single backend service can only have one backend policy attached (can combine with edge policies)
- Network edge security policies require Enterprise license
- reCAPTCHA redirect feature requires API enablement and may incur charges
```

### Quick Reference

**Policy Scoping Matrix:**
```bash
Global Policies:
  - Backend Services ✓
  - Backend Buckets ✓ (Edge only)
  - Redirect Actions ✓

Regional Policies:
  - Backend Services ✓  
  - Backend Buckets ✗
  - Redirect Actions ✗
  - Network Load Balancers only
```

**Common Rule Actions:**
```bash
# Block specific IP
srcIp == "192.168.1.1" -> DENY (404)

# Rate limiting (5 requests/minute)
rateLimit(5, 60) -> THROTTLE (429)

# Geographic blocking  
origin.region_code == "CN" -> DENY (403)

# Header-based blocking
request.headers["User-Agent"].contains("bad-bot") -> DENY
```

### Expert Insight

**Real-world Application:**
Cloud Armor serves as the first line of defense in a defense-in-depth security strategy. Organizations typically combine it with additional measures like:
- Instance-level firewalls (VPC firewall rules)
- Application-level security (CSP headers, input validation)
- Monitoring and alerting (Cloud Logging, Cloud Monitoring)
- CDN integration for static content caching and additional protection layers

**Expert Path:**
1. Start with default policies from load balancer creation
2. Implement basic IP blocking for known malicious sources
3. Add rate limiting to prevent abuse
4. Implement geographic filtering for country-specific restrictions
5. Use advanced mode expressions for complex conditions
6. Enable reCAPTCHA for suspicious traffic patterns
7. Monitor logs and adjust thresholds based on legitimate traffic patterns
8. Consider Network Edge policies for volumetric attack scenarios requiring Enterprise licensing

**Common Pitfalls:**
- Forgetting that backend policies only protect backend services, not backend buckets
- Setting priorities without leaving gaps for future rule insertion
- Not testing policies in preview mode before enforcing
- Ignoring propagation time (up to 5-10 minutes for global policies)
- Misunderstanding the difference between throttle vs. rate-based ban actions
- Attempting to attach multiple backend policies to the same service
- Not enabling necessary APIs for advanced features like reCAPTCHA

</details>
