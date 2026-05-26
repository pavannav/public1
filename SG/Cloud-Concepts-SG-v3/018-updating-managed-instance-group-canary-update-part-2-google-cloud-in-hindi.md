<details open>
<summary><b>Session 018: Updating Managed Instance Group Canary Update - Part 2 (KK-CS45-script-v3)</b></summary>

# Session 018: Updating Managed Instance Group Canary Update - Part 2

## Table of Contents
- [Overview](#overview)
- [Key Concepts: Managed Instance Group Updates](#key-concepts-managed-instance-group-updates)
- [Deep Dive: Canary Deployment Strategies](#deep-dive-canary-deployment-strategies)
- [Lab Demo: Selective Update Operations](#lab-demo-selective-update-operations)
- [Summary](#summary)

<a name="overview"></a>
## Overview

This session demonstrates advanced update mechanisms for Google Cloud Managed Instance Groups (MIGs), focusing on canary deployment patterns and selective update strategies. Building on Part 1's automatic updates, this session explores manual control over instance updates, traffic distribution during deployments, and scaling behavior considerations during canary rollouts.

Key focus areas include:
- Understanding selective update policies in MIGs
- Implementing canary deployment strategies
- Managing traffic distribution during updates
- Handling scaling operations alongside updates

<a name="key-concepts-managed-instance-group-updates"></a>
## Key Concepts: Managed Instance Group Updates

### Selective Update Policies

Selective updates provide granular control over when and how instance group updates occur:

- **Manual Control**: Updates only occur when explicitly initiated, not automatically
- **Traffic Protection**: Ensures no traffic disruption during update operations
- **Rollback Flexibility**: Ability to revert changes if issues arise

### Instance Template Management

Instance groups can reference multiple templates simultaneously:

```diff
+ New Template: Contains updated configuration/version
- Old Template: Original configuration maintained for rollback
! Template Selection: Group determines which template to use for new instances
```

### Update Operation Types

Three primary update approaches covered:

1. **Automatic Updates** (Covered in Part 1)
   - Proactive replacement of instances
   - Immediate application of template changes

2. **Selective Updates** (Current focus)
   - Controlled replacement on demand
   - Manual initiation required

3. **Rolling Updates with Traffic Control**
   - Gradual replacement with traffic management
   - Canary deployment patterns

<a name="deep-dive-canary-deployment-strategies"></a>
## Deep Dive: Canary Deployment Strategies

### Traffic Distribution During Updates

> [!IMPORTANT]
> Canary deployments ensure zero-downtime updates by gradually shifting traffic to new instances while monitoring health and performance.

### Scaling Behavior Considerations

When updates occur alongside auto-scaling:

| Scenario | Old Instances | New Instances |
|----------|---------------|---------------|
| Traffic Increase | Scale using old template | Maintain new template |
| Traffic Decrease | Scale down new instances first | Preserve minimum instances |
| Mixed Load | Dynamic scaling with template awareness | Template-specific scaling rules |

### Update Protection Mechanisms

1. **10-Minute Traffic Protection**
   - Prevents immediate deletion of recently active instances
   - Ensures traffic stability during transition periods

2. **Health Monitoring Integration**
   - Load balancer health checks determine instance readiness
   - Automated removal only after successful health validation

3. **Rollback Capabilities**
   - Manual intervention possible if issues detected
   - Template switching for emergency reversions

<a name="lab-demo-selective-update-operations"></a>
## Lab Demo: Selective Update Operations

### Demo 1: Initial Selective Update Setup

The demonstration begins with an existing instance group running on the original template:

```bash
# Instance group status verification
gcloud compute instance-groups managed list-instances [INSTANCE-GROUP-NAME]
```

Key observations:
- Two instances running on original template
- Load balancer distributing traffic evenly
- No automatic updates configured

### Demo 2: Selective Update Execution

**Steps Performed:**
1. Access GCP Console → Compute Engine → Instance Groups
2. Select target managed instance group
3. Navigate to "Update VMs" section
4. Configure selective update parameters:
   - Choose "Selective" update type
   - Select replacement strategy
   - Confirm traffic handling preferences

```bash
# GCP Console equivalent (programmatic approach)
gcloud compute instance-groups managed rolling-action start-update [INSTANCE-GROUP-NAME] \
  --version template=[NEW-TEMPLATE-NAME] \
  --type selective
```

### Demo 3: Traffic Management During Updates

**Load Balancer Configuration:**
```yaml
# Load balancer backend service configuration
backend:
  group: [INSTANCE-GROUP-URL]
  balancingMode: UTILIZATION
  maxUtilization: 0.8
  capacityScaler: 1.0
```

**Traffic Distribution Observation:**
- Existing instances maintain 100% traffic initially
- New instance created but receives no traffic
- Load balancer health checks validate new instance

### Demo 4: Auto-Scaling Impact Analysis

**Auto-Scaling Configuration:**
```yaml
# Auto-scaler configuration
autoscalingPolicy:
  minNumReplicas: 2
  maxNumReplicas: 10
  coolDownPeriodSec: 60
  cpuUtilization:
    utilizationTarget: 0.6
```

**Scaling Behavior During Updates:**
- Traffic increase triggers scaling on **old template** instances
- New template instances remain at current count
- Minimum instance requirements (2) maintained throughout

### Demo 5: Update Completion and Cleanup

**Forced Update Process:**
```bash
# Start update operation
gcloud compute instance-groups managed rolling-action start-update [INSTANCE-GROUP-NAME] \
  --version template=[NEW-TEMPLATE-NAME] \
  --max-surge 1 \
  --max-unavailable 1 \
  --min-ready 10m
```

**Traffic Transition:**
- New instances begin receiving traffic
- Old instances gradually removed after 10-minute protection period
- Load balancer automatically redistributes traffic

### Demo 6: Advanced Update Options

**Rolling Update with Specific Controls:**
```bash
# Rolling update with restart policy
gcloud compute instance-groups managed rolling-action replace [INSTANCE-GROUP-NAME] \
  --version template=[NEW-TEMPLATE-NAME] \
  --replacement-method restart
```

**Multi-Region Considerations:**
- Instance placement across zones
- Load balancer health verification timing
- Traffic shifting algorithms

<a name="summary"></a>
## Summary

### Key Takeaways
```diff
+ Selective updates provide manual control over instance group modifications
+ Canary deployments ensure zero-downtime by gradual traffic shifting
+ Auto-scaling continues during updates using appropriate templates
+ 10-minute traffic protection prevents immediate instance deletion
+ Load balancer health checks determine traffic distribution readiness
- Avoid concurrent template changes during active scaling operations
! Monitor health metrics during canary deployment phases
```

### Quick Reference

**Selective Update Command:**
```bash
gcloud compute instance-groups managed rolling-action start-update [GROUP-NAME] \
  --version template=[NEW-TEMPLATE] \
  --type selective
```

**Check Update Status:**
```bash
gcloud compute instance-groups managed list-instances [GROUP-NAME]
```

**Force Update Completion:**
```bash
gcloud compute instance-groups managed rolling-action replace [GROUP-NAME] \
  --version template=[NEW-TEMPLATE]
```

**Load Balancer Backend Health:**
```bash
gcloud compute backend-services get-health [BACKEND-SERVICE-NAME]
```

### Expert Insight

**Real-world Application**: In production environments, selective updates enable controlled rollouts of critical application updates. Teams can monitor performance metrics on canary instances before committing to full deployment, ensuring high availability and quick rollback capabilities.

**Expert Path**: Master advanced GCP deployment patterns by combining Instance Group Managers with Cloud Deployment Manager templates. Learn to implement automated canary analysis using Cloud Monitoring metrics and automated rollback triggers based on SLO violations.

**Common Pitfalls**:
- Not accounting for auto-scaling behavior during updates can lead to unexpected instance counts
- Insufficient health check configuration may cause premature traffic shifting
- Ignoring the 10-minute traffic protection window can result in service disruptions
- Concurrent template updates without proper sequencing can cause deployment conflicts

</details>
