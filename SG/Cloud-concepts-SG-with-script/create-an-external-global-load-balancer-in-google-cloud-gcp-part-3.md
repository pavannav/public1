# Session 3: Traffic Management in GCP External Global Load Balancer

## Table of Contents

- [Overview of Traffic Management](#overview-of-traffic-management)
- [Advanced Traffic Management Features](#advanced-traffic-management-features)
- [Host and Path Rules](#host-and-path-rules)
- [Routing Process](#routing-process)
- [Advanced Host and Path Rules](#advanced-host-and-path-rules)
- [HTTP to HTTPS Redirect](#http-to-https-redirect)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

---

## Overview of Traffic Management

Traffic management is essential for controlling how traffic is distributed across backend services in a load balancer. Google's External Global Load Balancer supports advanced traffic management features that go beyond basic routing, allowing for sophisticated traffic handling, which is not available in classic load balancers. This enables scenarios like canary deployments, traffic steering based on HTTP parameters (e.g., device type), and custom policies for mirroring or redirecting traffic.

Key topics include traffic steering, weight-based splitting, custom policies, host and path matching, and redirections. These features are crucial for production environments where precise control over traffic flow is needed to ensure performance, security, and efficient resource utilization.

💡 **Tip**: Traffic management helps optimize user experience by directing requests to the most appropriate backends based on custom rules.

---

## Advanced Traffic Management Features

The External Global Load Balancer offers three main advanced features for traffic management:

### 1. Traffic Steering
Traffic steering allows directing traffic to specific backend services based on HTTP parameters. For example:
- Route mobile traffic (e.g., Android users) to one backend.
- Route iPhone traffic to another backend.

This is achieved using custom matching rules in the URL map.

### 2. Weight-Based Traffic Splitting
This enables percentage-based traffic distribution, ideal for canary testing. For instance:
- Send 90% of traffic to the current backend (e.g., version 1.0).
- Send 10% to a new backend (e.g., version 2.0) for gradual rollout and testing.

⚠ **Warning**: Weights must sum to 100% to avoid undefined behavior.

### 3. Custom Policies (Traffic Mirroring)
Traffic mirroring duplicates all incoming traffic to a secondary backend without waiting for a response. This one-way mirroring is useful for monitoring or testing how a new system handles real traffic loads.

These features provide fine-grained control over traffic flow, enabling advanced deployment strategies like A/B testing, blue-green deployments, and fault injection for resilience testing.

---

## Host and Path Rules

Host and path rules define how traffic is routed based on the incoming request's host (domain) and path.

### Simple Host and Path Rules
- **Host Matching**: Matches the domain name (e.g., `cloudconcepts.in`).
- **Path Matching**: Routes based on URL segments (e.g., `/video` to video backends, `/audio` to audio backends).
- Default Service: Handles unmatched traffic.

Example flow: Request hits load balancer IP/domain → HTTPS proxy → URL map determines backend → Routes to matching backend service.

💡 **Use Case**: Basic routing for multi-service applications.

### Advanced Host and Path Rules
For more complex scenarios, use advanced rules that involve route rules with priorities. Lower priority numbers take precedence (e.g., priority 1 has higher precedence than 100).

Key components:
- **Route Rules**: Define how to route traffic, including match conditions and actions.
- **Priorities**: Prevent conflicts by sequencing rules.
- **Actions**: Route, split traffic, or perform redirects.

This allows for features like URL redirection, fault injection, and custom weighting, which are absent in simple rules.

> [!NOTE]
> Advanced rules are more complex and require careful validation to avoid misrouting traffic.

---

## Routing Process

Understanding the traffic flow is critical:

1. Incoming traffic reaches the load balancer IP/domain.
2. Traffic is forwarded to the HTTPS proxy (load balancer).
3. The HTTPS proxy passes the request to the URL map.
4. URL map evaluates:
   - Host rules (domain).
   - Path rules (URL segments).
   - Matches against route rules (in priority order).
5. Route actions determine the backend (single service, weighted split, or redirect).

```mermaid
graph TD
    A[Client Request] --> B[Load Balancer IP/Domain]
    B --> C[HTTPS Proxy]
    C --> D[URL Map]
    D --> E{Host Match?}
    E -->|Yes| F{Path Match?}
    F -->|Yes| G{Route Rules in Priority Order}
    G --> H[Routed to Backend Service(s)]
    E -->|No| I[Default Service]
    F -->|No| I
```

This process ensures efficient and accurate routing, preventing traffic from reaching unintended backends.

---

## Advanced Host and Path Rules

Advanced rules build on simple ones but introduce route-based matching for greater flexibility:

- Instead of basic path matching, use route rules with conditions like prefix matching (e.g., `/api`).
- **Priorities**: Example – priority 1 routes `/api/v1` traffic; priority 5 handles general traffic.
- **Actions**:
  - **Traffic Split**: Define percentages (e.g., 70% to Backend A, 30% to Backend B).
  - **URL Rewrite**: Modify request paths before routing (e.g., `/legacy` to `/new-api`).
  - **Fault Injection**: Introduce delays (e.g., 10s for 25% of traffic) or errors (e.g., 503 for 50% of traffic) for testing resilience.
  - **Mirroring**: Duplicate traffic to a monitor backend without response dependency.

Example: Using route rules for canary testing – send 5% to a new backend, 95% to stable backend.

Key considerations:
- Only one primary action per route (e.g., route or split).
- Multiple add-ons (e.g., retry, timeout) possible.
- Validation via Cloud Console or CLI prevents conflicts.

> [!IMPORTANT]
> Always validate rules before applying; errors can cause complete traffic failures.

---

## HTTP to HTTPS Redirect

This feature automatically redirects HTTP traffic to HTTPS, enhancing security and enforcing SSL/TLS.

### Adding to New Load Balancer
1. Create a new load balancer.
2. Select HTTPS protocol.
3. Require an SSL certificate and reserved external IP.
4. Enable HTTP to HTTPS redirect option.
5. This creates:
   - Load balancer.
   - URL map with redirect setup.
   - Target HTTP proxy.

### Adding to Existing Load Balancer
1. Create a new load balancer with HTTP protocol.
2. Use the same IP as the HTTPS load balancer (Port 80).
3. In routing rules:
   - Choose Advanced Host and Path.
   - Enable redirect to a different host/path (leave blanks for full HTTPS redirect).
   - Do not select backend services (pure redirection).
4. It shares the IP but redirects HTTP requests to the HTTPS load balancer.

Example: HTTP request `http://example.com` → Redirect to `https://example.com`.

⚠ **Warning**: Requires a valid SSL certificate for HTTPS; without it, the load balancer will fail.

---

## Lab Demos

### Demo 1: Enabling HTTP to HTTPS Redirect
- **Setup**: Create a separate HTTP-only load balancer sharing the IP with an existing HTTPS load balancer.
- **Configuration**:
  - Name: `http-redirect`
  - Protocol: HTTP (Port 80)
  - Use existing external IP.
  - Routing: Advanced Host and Path → Enable redirect → No backend services.
- **Verification**: Access `http://domain.com` → Auto-redirects to `https://domain.com`.

### Demo 2: Canary Testing with Traffic Splitting
- **Backends**: Two managed instance groups (IG1, IG2) + Cloud Run services.
- **Configuration** (in Advanced Host and Path):
  - Default service: IG1.
  - Route Rule (priority 101, match prefix `/`, action split: 90% IG1, 10% IG2).
- **Test**: Requests to domain → 90% responses from IG1, 10% from IG2 (refresh to observe distribution).

### Demo 3: Traffic Splitting for Subdomain
- **Setup**: Subdomain routing (e.g., `test.domain.com`).
- **Configuration**:
  - Default: IG1.
  - Route Rule (priority, match prefix `/hello`, split: 70% CloudRun1, 30% CloudRun2).
- **Test**: `test.domain.com` → IG1; `test.domain.com/hello` → Split responses (70% hello, 30% hello2).

### Demo 4: Fault Injection
- **Configuration**: Add route rule (lower priority, e.g., 102, match prefix `/`):
  - Fault: Fixed delay 10s for 25% traffic, 503 error for 50% traffic.
- **Test**: Requests → Observe delays/errors in responses.
- **Issue Resolution**: Adjust priorities (higher priority overrides); match rules must not conflict.

### Demo 5: CLI Validation and Updates
- **Export URL Map**: `gcloud compute url-maps export FINAL-LB --destination=export.yaml`
- **Edit and Validate**: `gcloud compute url-maps validate-config /path/to/file.yaml --load-balancing-scheme=EXTERNAL_MANAGED`
- **Import/Apply**: `gcloud compute url-maps import FINAL-LB --source=updated.yaml`
- **Note**: CLI changes replace all console rules; export first to preserve existing config.

> [!NOTE]
> Always export the URL map before CLI changes to avoid losing configurations.

---

## Summary

### Key Takeaways
```diff
+ Advanced traffic management includes steering, splitting, and custom policies like mirroring for sophisticated routing.
+ Simple host/path rules handle basic matching, while advanced rules use priorities and route actions for complex scenarios.
+ HTTP to HTTPS redirect ensures secure traffic with optional SSL enforcement.
+ Demos illustrate canary testing, fault injection, and CLI management for real-world application.
- Misconfigured priorities or rules can cause traffic failures; always validate before applying.
! Fault injection helps test resilience but should not target production without proper isolation.
```

### Expert Insight

**Real-world Application**: In production, use traffic splitting for zero-downtime deployments (e.g., blue-green or canary). Traffic mirroring monitors new backends under live load. Fault injection simulates outages for chaos engineering.

**Expert Path**: Start with simple rules, then progress to advanced features. Master Cloud Console for quick changes; use CLI for automation in CI/CD pipelines. Experiment in staging environments to build confidence.

**Common Pitfalls**:
- **Priority Conflicts**: Higher-priority rules block lower ones if matches overlap. Avoid by ensuring priorities align (lower numbers first) and validate via CLI or console preview. Resolution: Rearrange rules in order vs sequence; test with mock traffic.
- **Overriding Changes**: Mixing console and CLI overwrites configs; export before modifying to prevent loss. Avoid: Directly apply new YAML files without backup. To avoid, use console for interactive edits and CLI for scripted updates, never mixing.
- **Invalid Configurations**: Missing SSL for HTTPS or incorrect paths cause full failures. Resolution: Run validation commands before apply; monitor logs. To avoid, always test in dev env; use reserved IPs to prevent abrupt service disruption.
- **Traffic Blackholes**: If no default service or mismatched routes, traffic drops. Resolution: Confirm default backends; add comprehensive logging. To avoid, create catch-all rules and use health checks to detect backend issues early.

**Lesser Known Things**:
- Route rules support regex for advanced matching, enabling dynamic routing based on headers like User-Agent.
- Mirroring can be weighted (e.g., mirror 10% of traffic) for selective monitoring without full production impact.
- URL rewrites can include dynamic elements, allowing API version upgrades on-the-fly without client changes.
