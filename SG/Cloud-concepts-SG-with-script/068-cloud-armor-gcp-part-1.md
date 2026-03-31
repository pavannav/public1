# Session 68: Cloud Armor GCP Part 1

**Table of Contents**
- [What is Google Cloud Armor?](#what-is-google-cloud-armor)
- [Security Policies Overview](#security-policies-overview)
- [Types of Security Policies](#types-of-security-policies)
- [Load Balancers and Resources Supported](#load-balancers-and-resources-supported)
- [Rule Evaluation and Configuration](#rule-evaluation-and-configuration)
- [Global vs Regional Scoped Policies](#global-vs-regional-scoped-policies)
- [Rule Actions](#rule-actions)
- [Lab Demo: Setting Up Cloud Armor](#lab-demo-setting-up-cloud-armor)
- [Summary](#summary)

## What is Google Cloud Armor?

### Overview
Google Cloud Armor is a service designed to protect Google Cloud deployments from various types of threats. It provides security capabilities to defend against denial-of-service (DoS) attacks, including volumetric attacks at the network and protocol levels, as well as application-layer attacks such as cross-site scripting (XSS) and SQL injection. Cloud Armor works by creating security policies that filter and scrutinize incoming requests before they reach backend services or resources. It operates behind load balancers to ensure only well-formed, legitimate traffic is allowed to pass through, thereby safeguarding applications running on GCP, in hybrid environments, or on multi-cloud architectures and preventing malicious traffic from exhausting resources.

### Key Concepts/Deep Dive
Google Cloud Armor acts as a web application firewall (WAF) and DDoS mitigation tool, inspecting traffic at the edge and backend levels. It detects and mitigates threats by applying rules based on conditions like IP addresses, IP ranges, regions, headers, and more. Key features include:

- **Always-on DDoS Protection**: Provides built-in mitigation for network and protocol-based volumetric DoS attacks without additional configuration.
- **Layer 7 Filtering**: Scrubs incoming requests to block common web attacks before they reach backends.
- **Edge Filtering**: Blocks traffic at the network edge for connected services like Cloud CDN and Cloud Storage.
- **Resource Efficiency**: Network Edge policies consume no VM or host resources, allowing high-volume traffic to be blocked early.

This tool is essential for protecting backends such as instance groups, network endpoint groups (NEGs), backend buckets, and more, ensuring high availability and security.

## Security Policies Overview

### Overview
Security policies in Cloud Armor are sets of rules that filter and protect applications from threats. Each policy consists of rules evaluated based on priorities to determine whether to allow, deny, or redirect traffic. These policies attach to load balancer backends or services, enabling fine-grained control over who can access resources.

### Key Concepts/Deep Dive
- **Rule Components**: Rules include conditions (e.g., IP matches, region codes) and actions (e.g., deny, allow).
- **Filtering Criteria**: Traffic can be filtered by IP addresses, ranges, geographical regions, request headers, or other attributes.
- **Policy Application**: Policies prevent attacks at the load balancer proxy level, blocking malicious requests before they reach instance groups, backend buckets, or static/dynamic content.
- **Multiple Policy Support**: A backend can have both edge and backend policies for layered protection, though specific combinations are required.

> [!NOTE]
> Policies must be created on GCP Console or via gcloud commands and attached to appropriate load balancers.

## Types of Security Policies

### Overview
Cloud Armor offers three main types of security policies: backend security policies, Edge security policies, and Network Edge security policies. Backend and Edge policies handle layer 7 attacks, while Network Edge focuses on network-level DoS prevention.

### Key Concepts/Deep Dive
- **Backend Security Policies**: Applied at the backend service level to filter requests for resources like instance groups, NEGs, zonal hybrid serverless VMs, and global serverless. They protect against web attacks before traffic hits backends.
- **Edge Security Policies**: Applied at the edge for cached or cloud-served content, such as Cloud CDN endpoints and Cloud Storage buckets. Traffic is checked before accessing cache layers, blocking invalid requests early.
- **Coexistence**: Edge and backend policies can be used together for dual-layer protection. For example, missed hits on caches (cache misses) pass through backend policies.
- **Network Edge Security Policies**: Premium feature (requires Enterprise license) for blocking high-volume traffic at the network edge, protecting network load balancers, protocol forwarding for VMs with public IPs, or single VMs. It prevents DoS without consuming target resources.
- **Application Restrictions**:
  - Backend policies: Only backend services.
  - Edge policies: Backend services and backend buckets.
  - Network Edge policies: Target instances, regional backend services, and regional instance groups.

### Tables
| Policy Type | Application Level | Supported Resources | License Requirement |
|-------------|-------------------|-------------------|---------------------|
| Backend Security | Backend | Backend services (e.g., instance groups, NEGs) | Standard |
| Edge Security | Edge | Backend services, backend buckets (e.g., Cloud CDN, Cloud Storage) | Standard |
| Network Edge | Network Edge | VMs with public IPs, protocol forwarding, network load balancers | Enterprise |

## Load Balancers and Resources Supported

### Overview
Cloud Armor integrates with specific GCP load balancers and resources to enforce policies. It protects backends behind global and regional load balancers, with variations based on the balancer type and policy kind.

### Key Concepts/Deep Dive
- **Supported Load Balancers**:
  - Global External Application Load Balancer (ALB)
  - Classic Application Load Balancer
  - Regional ALB
  - Regional Internal ALB
  - Global Network Load Balancers
  - Protocol Forwarding for VMs with Public IPs (requires Cloud Armor Enterprise)
- **Resource Protections**: Policies secure backend services, bucket objects, and VMs from threats.
- **Limitations**: Not all balancers support all policy types (e.g., Regional policies don't support Edge type).

Cloud Armor creates a default security policy for load balancers if enabled, which includes request throttling to block excessive traffic.

## Rule Evaluation and Configuration

### Overview
Rules in a security policy are evaluated by priority, from lowest number (highest priority) to highest. Priorities range from 0 (max priority) to a large number (lowest priority), allowing insertion of new rules.

### Key Concepts/Deep Dive
- **Priority Usage**: Lower numbers take precedence; provide gaps for future rule additions.
- **Default Rules**: Last rules (e.g., allow all) act as catch-alls.
- **Configuration Modes**:
  - **Basic Mode**: Simple IP/range filters, no expressions required.
  - **Advanced Mode**: Uses custom expressions for complex rules (covered in Part 2).
- **Key Enforcement**: Rules enforced on attributes like IP, headers, cookies, paths, or region codes.

## Global vs Regional Scoped Policies

### Overview
Policies can be global or regional, depending on the load balancer scope. Global policies cover multi-region deployments, while regional ones suit single-region resources.

### Key Concepts/Deep Dive
- **Global Scoped**: For global load balancers (e.g., Global ALB with multi-region instance groups). Supports backend and Edge policies. Applied to backend services and buckets.
- **Regional Scoped**: For regional load balancers. Supports backend policies only (no Edge or Network Edge). Applied to regional backend services and instance groups.
- **Actions**: Global supports allow, deny, redirect; regional supports allow, deny, throttle, rate-based ban (no redirect).

| Scope | Supported Policies | Supported Actions | Supported Load Balancers |
|-------|---------------------|------------|--------------------------|
| Global | Backend, Edge | Allow, Deny, Redirect, Throttle, Rate-based Ban | Global External ALB/Global Network Load Balancers |
| Regional | Backend | Allow, Deny, Throttle, Rate-based Ban | Regional ALB/Regional Internal ALB |

## Rule Actions

### Overview
Each rule specifies an action to take when conditions match: allow traffic to pass, deny access, throttle excessive requests, ban based on rates, or redirect to URLs/captcha.

### Key Concepts/Deep Dive
- **Allow**: Permits traffic with a specified response code.
- **Deny**: Blocks traffic with codes like 404 (Not Found), 403 (Forbidden), or 502 (Bad Gateway).
- **Throttle**: Limits requests per time interval (e.g., 500 per minute); enforced on keys like IP.
- **Rate-based Ban**: Bans clients exceeding thresholds for a duration; includes ban settings separate from throttle.
- **Redirect**: Sends traffic to URLs or captcha (Enterprise feature) to verify users.
- **Preview Mode**: Tests rules without enforcement.

Common pitfalls include mismatching policy scopes to balancers or forgetting default rules.

### Code/Config Blocks
Example basic rule in gcloud (for demonstration):
```bash
gcloud alpha compute security-policies rules create 1000 \
  --security-policy my-policy \
  --description "Block specific IP" \
  --src-ip-ranges 192.0.2.0/24 \
  --action deny-404
```
(Syntax highlighters: `bash` for CLI commands, `yaml` for configs if applicable.)

## Lab Demo: Setting Up Cloud Armor

### Overview
This demo demonstrates creating a load balancer, backend policies, and testing rules like deny, throttle, and rate-based ban.

### Key Concepts/Deep Dive
Detailed steps from the transcript:

1. Create instance groups in different regions (e.g., London, US West) using instance templates.
2. Navigate to Cloud Console > Load Balancing > Create Global External Application Load Balancer.
3. Configure backends:
   - Create backend service for instance groups (e.g., ports 80).
   - Create backend bucket for static content (e.g., enable CDN).
4. Set routing rules (e.g., `/city.png` to backend bucket, others to backend service).
5. Create and attach cloud armor policy:
   - Go to Cloud Armor > Create Policy.
   - Configure default action (allow/deny).
   - Add rules (e.g., block IP with deny-404, priority 1000).
   - Attach to backend service.
6. Test by curling/web browsing:
   - Verify load balancer distributes traffic.
   - Check blocked IP returns 404 for backend service.
   - Add throttle rule (e.g., 5 requests/minute returns 429).
   - Add rate-based ban (e.g., 5/30s, ban 1min for 8/min, returns 429).
   - Note: Rules apply only to policy-attached backends.
7. Update rules as needed (e.g., edit priorities, add headers).
8. Firewall rules must allow load balancer IPs (130.211.0.0/22, 35.191.0.0/16 for health checks and traffic).

### Diagrams
```mermaid
flowchart TD
    A[Incoming Request] --> B{Cloud Armor Policy Applied?}
    B -->|Deny| C[Block with Code (e.g., 404)]
    B -->|Throttle| D{Over Limit?}
    D -->|Yes| E[429 Too Many Requests]
    D -->|No| F[Allow Traffic]
    B -->|Allow| G[Pass to Backend Service/Instance]
    B -->|Rate-based Ban| H{Cross Threshold?}
    H -->|Yes| I[Ban and 429]
    H -->|No| F
```

## Summary

### Key Takeaways
```diff
+ Cloud Armor protects GCP applications from DoS and web exploits by filtering at load balancers.
+ Three policy types: Backend (backend services), Edge (caches/buckets), Network Edge (network level, Enterprise).
+ Rules evaluated by priority (low numbers first); actions include deny, throttle, ban, redirect.
+ Supports global/regional scopes; attach to specific load balancers/backends.
+ Default policies throttle at 500 req/min; customize for IP/regional blocks.
+ Always test policies in preview mode to avoid availability issues.
- Misconfigure priority gaps can prevent adding future rules.
- Attaching Edge/Backend policies requires careful overlap for effective protection.
```

### Expert Insight
**Real-world Application**: In production, use Cloud Armor for e-commerce sites to mitigate DDoS during sales, or for APIs to prevent mass brute-force attacks. Combine with VPC Service Controls for layered security; monitor via Cloud Logging/Monitoring for blocked IPs.

**Expert Path**: Master advanced rules with custom expressions (Part 2) for header-based filtering; integrate with Cloud CDN for global edge protection; automate policy updates with gcloud/terraform. Experiment with rate-limiting to handle API bursts without over-denial.

**Common Pitfalls**: 
- Using global policies on regional balancers – causes errors; always match scopes.
- Overlapping priorities without gaps – makes rule additions hard; plan with large intervals (e.g., 1000, 2000).
- Forgetting firewall rules – health checks fail, backends unhealthy; ensure 130.211.0.0/22 and 35.191.0.0/16 are allowed on ports 80+.
- Lesser Known: Network Edge policies consume zero resources but require Enterprise; Edge policies check both cached (cache-hit) and uncached traffic via backend policies. Also, Cloud Armor doesn't support legacy App Engine (flex/standard); use standard ALBs instead.
Issues and Resolutions: Load balancer creation fails if backends unhealthy – check firewall rules for health check traffic. Policies don't apply immediately – wait 5-10 minutes for propagation. Mistyped IPs/ranges in rules – verify with gcloud logs or preview mode. Captcha redirects require reCAPTCHA key setup and may incur costs. Rate Rule Confusion: Throttle blocks immediately on threshold, ban locks out for duration; combine sparingly. Redirect to URLs: Ensure target domains allow traffic to avoid loops.

> [!IMPORTANT]
> Corrected transcript errors: "thre Tex" to "threats", "DS attack" to "DoS attack", "web setex" to "web security", "Multicloud architecture Google Cloud" to "multicloud architecture. Google Cloud", "LOUD G/pub Balan" to "load balancer", "Energy to make sure" to "NEGs to make sure", "as what" to "Edge", "I have just taken a small screenshot and after that we have n" to "after that we have Network", "seriving some Dynamic content" to "serving some dynamic content", "cachit" to "cache-hit", "bucks" to "buckets", "enforcing Network Edge policy" to "enforcing Network Edge policy", "reams" to "backend services", "application load balancer only supports backend bucket" to "supports backend buckets", "clasic load balancer" to "classic load balancer", "back end" to varied "backend" consistently, "lb" to "load balancer", "allist" to "alllist" wait, "all *language" to "all languages", but mainly formatting; "pone" to "phone" no, "pone" not present; "protot forwarding" to "Protocol Forwarding", "eneffic" to "efficiency", "they will basically get this 4292" to "429", intact as demo. Notify: Original had typos like "tex" for "texts/threats", "thre Tex" corrected to "threats"; "DS" to "DoS"; "enea" to "NEGs"; minor casing/phrasing for clarity without altering meaning.
