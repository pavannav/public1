# Session 018: Updating Managed Instance Group - Canary Update Part 2 (Google Cloud)

<details open>
<summary><b>Session 018: Updating Managed Instance Group - Canary Update Part 2 (Google Cloud) (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview

This session continues from Part 1, focusing on manual and selective updates to Managed Instance Groups (MIGs) in Google Cloud Platform (GCP). It demonstrates canary deployment strategies using load balancers and auto-scaling, ensuring zero-downtime updates while maintaining application stability.

## Key Concepts and Deep Dive

### Managed Instance Groups (MIGs)
Managed Instance Groups are collections of identical VMs managed by GCP. They support auto-scaling, rolling updates, and canary deployments to ensure high availability.

### Canary Updates
Canary updates allow gradual deployment of changes:
- Deploy new instances alongside existing ones
- Route traffic incrementally to new instances
- Monitor performance before full rollout
- Rollback if issues detected

### Load Balancers in GCP
Load balancers distribute traffic across instances:
- **Backend Services**: Define how traffic reaches MIGs
- **Health Checks**: Ensure instances are healthy
- **Target Pools**: Groups of instances for load balancing

### Selective Update Strategies

| Strategy | Description | Use Case |
|----------|-------------|----------|
| One-at-a-Time | Replace instances one by one | Low-risk updates, gradual deployment |
| Proportional | Maintain target distribution during update | Production environments requiring stability |
| Opportunistic | Replace when instances fail or scale | Minimizes disruption in auto-scaling setups |

### Auto-Scaling During Updates
Auto-scaling adjusts instance count based on metrics:
- **Minimum/Maximum Size**: Defines scaling bounds
- **Target CPU Utilization**: Scaling trigger metric
- Migration preserves instance templates during scaling

### Instance Templates
- Define VM configuration (machine type, boot disk, etc.)
- Versioned for rollbacks
- Instance groups reference templates for new instances

## Lab Demos

### Demonstration 1: Selective Update with Load Balancer

**Steps:**
1. Access MIG in GCP Console
2. Choose "Rolling Update" > "Selective Update"
3. Configure update options:
   ```yaml
   replacement_method: one_at_a_time
   max_surge: 1
   max_unavailable: 1
   ```
4. Monitor instance replacement in "Instances" tab
5. Observe traffic distribution via external IP

**Commands:**
```bash
# Check MIG status
gcloud compute instance-groups managed list

# Describe MIG
gcloud compute instance-groups managed describe [MIG_NAME] --zone=[ZONE]
```

### Demonstration 2: Auto-Scaling Behavior During Updates

**Steps:**
1. Configure auto-scaling policy:
   ```yaml
   min_num_replicas: 2
   max_num_replicas: 5
   cpu_utilization:
     target: 60
   ```
2. Generate traffic to trigger scaling up
3. Initiate selective update
4. Observe new instances use updated template
5. Stop traffic to trigger scaling down
6. Monitor instance deletion order (newest first)

### Demonstration 3: Instance Recreation Options

**Steps:**
1. Replace individual instances via "Update VMs"
2. Use "Restart VMs" to restart instances
3. Configure "Delete VMs" for forced recreation
4. Observe template version changes in instance list

## Summary

### Key Takeaways
```diff
+ Canary updates enable zero-downtime deployments by gradual instance replacement
+ Selective update strategies (one-at-a-time, proportional) control rollout pace
+ Auto-scaling integrates seamlessly with updates, respecting min/max bounds
- Avoid full updates in production without canary testing first
! Always monitor health checks and metrics during updates for issues
```

### Quick Reference
- **Check MIG Status**: `gcloud compute instance-groups managed list`
- **Describe MIG**: `gcloud compute instance-groups managed describe [NAME]`
- **Update Template**: Replace template reference in MIG configuration
- **Auto-Scaling Config**:
  ```yaml
  autoscaling:
    enabled: true
    minNumReplicas: 2
    maxNumReplicas: 10
    cpuUtilization:
      target: 0.8
  ```

### Expert Insight

#### Real-world Application
In production GCP environments, implement canary updates for:
- Application version rollouts
- Security patches
- Infrastructure changes
Use monitoring tools like Cloud Monitoring to track metrics during update windows.

#### Expert Path
- Master instance templates with versioning
- Implement comprehensive health checks
- Use canary analysis tools for automated rollback decisions
- Practice with different update strategies in staging environments

#### Common Pitfalls
- **Template Mismatches**: Ensure new templates are tested before updates
- **Resource Constraints**: Max surge/unavailable settings can cause downtime if misconfigured
- **Auto-Scaling Conflicts**: Dynamic scaling during updates may delay completion
- **Load Imbalance**: Monitor traffic distribution to avoid overwhelming new instances

</details>