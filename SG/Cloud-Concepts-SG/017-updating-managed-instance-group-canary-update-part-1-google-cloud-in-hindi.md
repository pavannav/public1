# Session 017: Updating Managed Instance Group - Canary Update Part 1 - Google Cloud

<details open>
<summary><b>Updating Managed Instance Group - Canary Update Part 1 - Google Cloud (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [Managed Instance Groups (MIGs)](#managed-instance-groups-migs)
  - [Instance Templates](#instance-templates)
  - [Canary Deployment Strategy](#canary-deployment-strategy)
  - [Update Strategies in GCP](#update-strategies-in-gcp)
- [Implementation: Canary Update in GCP](#implementation-canary-update-in-gcp)
  - [Prerequisites](#prerequisites)
  - [Create New Instance Template](#create-new-instance-template)
  - [Configure Canary Update](#configure-canary-update)
  - [Monitor and Test](#monitor-and-test)
  - [Complete Rollout or Rollback](#complete-rollout-or-rollback)
- [Summary](#summary)

## Overview

This session demonstrates the process of performing **canary updates** on Google Cloud Platform's (GCP) Managed Instance Groups (MIGs). Canary deployment is a risk-reduction strategy where new changes are gradually rolled out to a small subset of users before full deployment, allowing for testing and validation in production-like conditions.

The session covers creating instance templates, configuring load balancers, and executing canary updates with 50/50 traffic distribution for testing new configurations while maintaining zero downtime.

### Learning Objectives
- Understand MIG architecture and update mechanisms
- Master canary deployment strategy in GCP
- Learn configuration options for safe application updates
- Gain expertise in rolling updates, replacements, restarts, and rollbacks

## Key Concepts

### Managed Instance Groups (MIGs)
Managed Instance Groups in GCP provide:
- **Automatic Scaling**: Based on load balancing rules and health checks
- **Self-Healing**: Automatic recreation of failed VMs
- **Rolling Updates**: Gradual replacement of instances without service interruption
- **Load Distribution**: Automatic traffic routing across healthy instances

MIGs use instance templates to define the base configuration for all instances in the group.

### Instance Templates
An instance template is a reusable configuration that defines:
- VM machine type (e.g., n1-standard-1)
- Boot disk image and size
- Network configuration
- Startup scripts
- Metadata key-value pairs

```yaml
# Example instance template configuration
machine_type: n1-standard-1
network_interfaces:
  - network: default
    access_configs:
      - type: ONE_TO_ONE_NAT
startup_script: |
  #!/bin/bash
  apt-get update && apt-get install -y nginx
  echo "Updated configuration" > /var/www/html/index.html
```

### Canary Deployment Strategy
Canary deployment involves:
- **Gradual Rollout**: Send traffic to new version incrementally
- **Testing in Production**: Validate new changes with real users
- **Risk Mitigation**: Limit impact if issues arise
- **Zero Downtime**: Maintain service availability during updates

#### Traffic Distribution Model
```
User Traffic ──┬─► 50% ──► Old Version (Stable)
               └─► 50% ──► New Version (Testing)
```

### Update Strategies in GCP

GCP provides several update mechanisms for MIGs:

#### 1. **Rolling Update (Default)**
- Instances replaced gradually
- Maintains minimum instance count
- Supports maximum surge and unavailable settings

#### 2. **Restart**
- Stops and restarts instances
- Preserves instance metadata but applies new configurations
- Network configuration changes may require restarts

#### 3. **Refresh**
- Updates running instances without stopping
- Limited to metadata, tags, and some configuration updates
- No downtime, minimal disruption

#### 4. **Replace**
- Completely recreates instances
- Preserves instance names if needed
- Full configuration replacement

> [!NOTE]
> Replace vs Restart: Use replace when hardware changes are needed (new machine types). Restart is sufficient for software or metadata updates.

## Implementation: Canary Update in GCP

### Prerequisites
- GCP project with Compute Engine API enabled
- Existing MIG with running instances
- Load balancer attached to the MIG
- Two instance templates: current (old) and updated (new)

### Create New Instance Template

1. **Navigate to Compute Engine** → **Instance templates**
2. **Create new template** with updated configuration
   - Modified startup script
   - Updated software versions
   - New machine type if needed

```bash
# Create new instance template via gcloud CLI
gcloud compute instance-templates create new-template-name \
  --machine-type=n1-standard-1 \
  --network=default \
  --metadata startup-script='#!/bin/bash
    # Updated startup commands here
    echo "New configuration applied" > /var/www/html/index.html' \
  --tags=web-server
```

### Configure Canary Update

1. **Access MIG** in GCP Console
2. **Click "Update VMs"**
3. **Configure update settings**:
   - **Target distribution**: 50% to new template
   - **Update type**: Rolling update (recommended)
   - **Minimum health period**: Wait time before considering update complete
   - **Maximum unavailable**: Percent of instances can be down (default 20%)

```bash
# Configure canary update via gcloud
gcloud compute instance-groups managed rolling-action start-update instance-group-name \
  --version template=new-template-name,target-size="50%" \
  --max-unavailable=0% \
  --max-surge=1
```

### Monitor and Test

**Monitoring during canary deployment:**
- Watch health checks (HTTP/HTTPS)
- Monitor error rates and latency
- Check application logs
- Validate functionality with test traffic

```bash
# Check instance group status
gcloud compute instance-groups managed describe instance-group-name

# View instances in the group
gcloud compute instance-groups managed list-instances instance-group-name
```

### Complete Rollout or Rollback

#### Full Rollout
1. Set new template target to 100%
2. Old version automatically removed
3. Verify all traffic on new instances

```bash
# Complete rollout to 100%
gcloud compute instance-groups managed rolling-action start-update instance-group-name \
  --version template=new-template-name,target-size="100%"
```

#### Rollback Process
1. Delete new version from distribution
2. Traffic automatically redirects to old version

```bash
# Rollback by removing new version
gcloud compute instance-groups managed rolling-action start-update instance-group-name \
  --version template=old-template-name,target-size="100%"
```

## Summary

### Key Takeaways
```diff
+ Canary updates enable safe, gradual rollouts with minimal risk exposure
+ GCP MIGs provide multiple update strategies: refresh, restart, replace, and rolling updates
+ 50/50 traffic distribution allows thorough testing of new configurations
+ Maximum unavailable/surge settings control update speed and resource usage
+ Automatic rollback capabilities ensure quick recovery from issues
- Always test health checks and monitoring before full production rollout
- Ensure startup scripts are idempotent to handle restart scenarios
! Never set maximum unavailable to 0% if you require zero downtime during updates
! Monitor application metrics during canary phase to detect issues early
```

### Quick Reference

#### GCP Console Steps for Canary Update
1. Compute Engine → Instance groups → [Select MIG]
2. Update VMs → Add new instance template
3. Set target distribution (e.g., 50%)
4. Configure maximum unavailable/surge
5. Start update and monitor progress

#### CLI Commands
```bash
# Start canary update
gcloud compute instance-groups managed rolling-action start-update instance-group-name \
  --version template=new-template-name,target-size="50%" \
  --max-unavailable=20% \
  --max-surge=1

# Monitor update status
gcloud compute instance-groups managed rolling-action describe instance-group-name

# Complete rollout
gcloud compute instance-groups managed rolling-action start-update instance-group-name \
  --version template=new-template-name,target-size="100%"
```

### Expert Insight

#### Real-world Application
In production environments, canary deployments are crucial for:
- **Microservices Updates**: Gradually roll out API changes
- **Database Schema Changes**: Test compatibility with existing data
- **Critical Infrastructure**: Validate changes with real user traffic

#### Expert Path
- **Blue-Green Alternative**: Consider blue-green deployments for complex changes
- **Automated Testing**: Integrate automated canary analysis with monitoring tools
- **Feature Flags**: Use alongside canary deployments for fine-grained traffic control
- **Multi-region Strategy**: Combine with multi-region deployments for geographic canary tests

#### Common Pitfalls
- **Improper Health Checks**: Canary failures due to inadequate monitoring
- **Resource Constraints**: Insufficient quota for surge instances during updates
- **State Dependencies**: Applications requiring sticky sessions may need special handling
- **Rollback Complexity**: Ensure rollback plans are tested and documented
- **Traffic Imbalance**: Monitor actual traffic distribution vs. configured percentages

This concludes Part 1. Part 2 will cover selective updates and advanced automation techniques.

</details>