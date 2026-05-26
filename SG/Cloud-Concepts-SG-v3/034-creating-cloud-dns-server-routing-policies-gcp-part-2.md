<details open>
<summary><b>Creating Cloud DNS Server Routing Policies GCP Part-2 (KK-CS45-script-v3)</b></summary>

# Session 34: Creating Cloud DNS Server Routing Policies GCP Part-2

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Weighted Round Robin Routing Policy](#weighted-round-robin-routing-policy)
  - [Geolocation-Based Routing Policy](#geolocation-based-routing-policy)
  - [Failover Routing Policy](#failover-routing-policy)
- [Lab Demos](#lab-demos)
  - [Demonstrating Weighted Round Robin with and without Health Checks](#demonstrating-weighted-round-robin-with-and-without-health-checks)
  - [Demonstrating Geolocation-Based Routing](#demonstrating-geolocation-based-routing)
  - [Demonstrating Failover and Geo-Fencing](#demonstrating-failover-and-geo-fencing)
- [Summary](#summary)

## Overview
This session continues the discussion on Cloud DNS Server Routing Policies in Google Cloud Platform (GCP), focusing on advanced routing options including Weighted Round Robin, Geolocation-based routing, and Failover policies. It covers practical demonstrations, health checks, load balancing integration, and configuration best practices for traffic routing based on weights, locations, and failure scenarios.

## Key Concepts and Deep Dive

### Weighted Round Robin Routing Policy
The Weighted Round Robin policy allows distributing traffic across multiple targets based on predefined weight values, ranging from 0 to 1000. This enables proportional traffic splitting, such as sending 80% to one target and 20% to another.

- **Health Checks**: Enable health checking to ensure traffic is only directed to healthy targets, avoiding downtime. If disabled, traffic continues to unhealthy targets.
- **Internal vs External Load Balancing**: Supports internal load balancers for private routing.
- **Traffic Splitting**: Useful for A/B testing or directing portions of traffic (e.g., production vs experimental versions).

> [!NOTE]
> Weights can be set from 0 (no traffic) to 1000, allowing fine-grained control over distribution.

### Geolocation-Based Routing Policy
This policy routes traffic based on the nearest geographic location to the query source, optimizing performance by directing requests to the closest target region.

- **Latency Optimization**: Automatically selects the nearest target (e.g., India for Indian queries, US for American queries).
- **Health Checks**: Enabled by default, ensuring failover to healthy targets if a region fails.
- **Regional Mapping**: Uses Google Cloud's geography scores for intelligent routing.

> [!IMPORTANT]
> Global access must be enabled on load balancers to allow routing from multiple regions, providing seamless worldwide reach.

### Failover Routing Policy
Failover policies create active-backup configurations, where primary targets handle traffic until failure, then automatically switch to backups.

- **Active and Backup Setup**: Define primary active targets and backup failover targets.
- **Health Checks**: Critical; without them, the policy cannot detect failures.
- **Geo-Fencing**: Enables region-based fencing to prevent traffic shifts during regional failures, maintaining user experience.
- **Traffic Porting**: Supports sending a small percentage (e.g., 10-20%) to backups even during normal operation for testing.

> [!IMPORTANT]
> Always enable global access on load balancers for proper Geo-Fencing functionality.

## Lab Demos

### Demonstrating Weighted Round Robin with and without Health Checks
Create a weighted routing policy with two load balancers: one with 800 weight, one with 200 weight.

**Steps:**
1. In GCP Console, navigate to Cloud DNS > Routing Policies > Create New Weighted Policy.
2. Set weights: 80% and 20%.
3. Attach IP addresses of load balancers.
4. Enable health checks for automatic failover.
5. Test by stopping one load balancer and observe traffic shifting proportionally.

**Console Configuration:**
```bash
# Example CLI for weighted policy (approximate)
gcloud dns record-sets create --zone=example-zone --name=example.com --type=A --routingpolicy-type=WEIGHTEDROUNDROBIN --routingpolicy-rrdatas=lb1-ip;lb2-ip --routingpolicy-weights=800;200
```

> [!NOTE]
> Without health checks, traffic persists to unhealthy targets. With checks enabled, failed targets are avoided.

### Demonstrating Geolocation-Based Routing
Configure routing based on query source location.

**Steps:**
1. Create a Geolocation policy in Cloud DNS.
2. Select source regions (e.g., Asia South1, Central).
3. Assign targets per location.
4. Perform DNS lookups from different regions to verify routing.
5. Enable health checks and test failover by simulating region failure.

**Verification Command:**
```bash
nslookup example.com
# Observe IP based on geographic location
```

### Demonstrating Failover and Geo-Fencing
Set up active-backup with geo-fencing for regional resilience.

**Steps:**
1. Create Failover routing policy with primary (active) and secondary (backup) targets.
2. Enable geo-fencing to restrict traffic during failures.
3. Set fallback percentage (e.g., 30% to backup during active operation).
4. Stop primary and watch automatic failover.
5. Disable geo-fencing to allow global routing.

**Load Balancer Setup:**
- Ensure "Global Access" is enabled.
- Attach to routing policy as targets.

## Summary

### Key Takeaways
```diff
+ Weighted Round Robin enables proportional traffic distribution with health-aware routing.
+ Geolocation optimizes latency by routing to nearest targets with default health checks.
+ Failover provides active-backup setups with geo-fencing for regional failure handling.
- Avoid disabling health checks to prevent traffic to unhealthy endpoints.
- Always enable global access on load balancers for multi-region routing.
! Common pitfall: Forgetting to enable health checks leads to undetected failures.
- Misconfiguring weights can cause uneven load, impacting performance.
```

### Quick Reference
- **Weight Range**: 0-1000 for round-robin policies.
- **Geo-Fencing Values**: 0.0 to 1.0 (e.g., 0.3 = 30% traffic to backup).
- **Health Check Types**: Automatic for geolocation, optional for weighted.
- **CLI Example**:
  ```bash
  gcloud dns record-sets create --routingpolicy-type=GEOLOCATION --routingpolicy-geo-locations=asia-south1;us-central1 --routingpolicy-rrdatas=lb1-ip;lb2-ip
  ```

### Expert Insight
**Real-world Application**: Use weighted policies for blue-green deployments, geolocation for CDN-like performance, and failover for high-availability hybrid clouds.

**Expert Path**: Master by combining policies (e.g., geo-based failover), integrate with Cloud Monitoring for advanced alerts, and automate via Terraform for large-scale infra.

**Common Pitfalls**: Skipping global access leads to routing failures; ignoring health checks causes outages; unbalanced weights result in uneven loads—always test with synthetic traffic.
</details>
