# Session 017: Updating Managed Instance Groups - Canary Update (Part 1)

<details open>
<summary><b>017-Updating-Managed-Instance-Group-Canary-Update-Part-1-Google-Cloud-in-Hindi (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts - Canary Updates](#key-concepts---canary-updates)
- [Update Strategies](#update-strategies)
- [Instance Group Update Process](#instance-group-update-process)
- [Load Balancer Integration](#load-balancer-integration)
- [Rollback Operations](#rollback-operations)
- [Lab Demo - Manual Canary Update](#lab-demo---manual-canary-update)
- [Summary](#summary)

## Overview

This session covers Managed Instance Group (MIG) updates using Canary deployment strategy in Google Cloud. Canary updates allow gradual rollout of changes by distributing traffic between old and new instance templates, enabling testing and validation before full deployment. The session demonstrates manual canary updates, rolling back changes, and different update strategies available in Google Cloud Console.

## Key Concepts - Canary Updates

### Managed Instance Group Updates
Canary updates provide **gradual deployment** of changes to instance groups, minimizing risk by allowing traffic to be progressively shifted from old to new configurations.

#### Core Components
- **Instance Templates**: Blueprints defining VM specifications, disks, networking
- **Target Size**: Defines number of instances in the group  
- **Distribution Settings**: Controls traffic allocation between templates

### Update Strategies Comparison

| Strategy | Description | Use Case | Impact |
|----------|-------------|----------|---------|
| Rolling Update | Gradual replacement of instances | General updates | No downtime |
| Canary Update | Traffic-based deployment | High-traffic production apps | Traffic validation |
| Blue-Green | Complete switchover | Critical systems | Higher resource usage |

### Update Types

#### Refresh Updates
```yaml
- In-place updates without VM recreation
- Updates instance metadata, tags, labels
- Preserves running state and disk data
- No external access interruption
```

#### Restart Updates  
```yaml
- VM power cycle (power off → power on)
- Updates machine type, disk configuration
- Requires restart to apply changes
- Brief service interruption
```

#### Replace Updates
```yaml
- Complete VM recreation
- New instances from updated template
- Same name preservation option
- Full configuration replacement
```

## Update Strategies

### Manual vs Automatic Updates

#### Manual Canary Updates
- **Controlled rollout**: User manages traffic distribution
- **Testing capability**: Validate new instances before full traffic
- **Rollback ready**: Can immediately revert changes
- **Resource overhead**: Tempolary additional instances during update

#### Automatic Canary Updates
- **Scheduled rollout**: Progressive traffic shifting
- **Health checking**: Automatic validation monitoring
- **Self-healing**: Reverts on failure detection
- **Zero-touch operation**: Minimal manual intervention

### Distribution Configuration

#### Target Size Calculation
```bash
# Example distribution settings
Current Template A: 2 instances (100% traffic)
Target Template B: 1 instance (add to group first)
Distribution: 50% Template A, 50% Template B
Final Result: 3 instances total (after update)
```

```yaml
# YAML configuration example
versions:
- name: old-version
  instanceTemplate: projects/my-project/global/instanceTemplates/old-template
  targetSize:
    fixed: 2
- name: new-version  
  instanceTemplate: projects/my-project/global/instanceTemplates/new-template
  targetSize:
    fixed: 1
```

## Instance Group Update Process

### Pre-Update Preparation

1. **Create New Instance Template**
   ```bash
   gcloud compute instance-templates create new-template \
     --machine-type=n1-standard-1 \
     --image-family=debian-9 \
     --image-project=debian-cloud \
     --metadata startup-script="# New startup script"
   ```

2. **Verify Load Balancer Health**
   - Ensure health checks are properly configured
   - Test current instance responses
   - Validate auto-scaling policies

3. **Set Update Parameters**
   ```yaml
   # Configuration for canary update
   updatePolicy:
     type: OPPORTUNISTIC
     minimalAction: REPLACE
     maxSurge:
       fixed: 1
     maxUnavailable:
       fixed: 0
   ```

### Update Execution Steps

1. **Add Second Instance Template**
   - Navigate to Instance Group → Update VMs
   - Select "Add instance template"
   - Set target size distribution

2. **Configure Distribution**
   ```bash
   # Set 50-50 distribution for testing
   Old Template: 50%
   New Template: 50%
   ```

3. **Monitor Traffic Distribution**
   - Check load balancer metrics
   - Validate application responses
   - Monitor resource utilization

## Load Balancer Integration

### Backend Service Configuration
```yaml
backendService:
  name: my-backend-service
  backends:
  - group: projects/my-project/regions/us-central1/instanceGroups/my-group
  healthChecks:
  - httpsHealthCheck:
      name: my-health-check
      requestPath: /health
      port: 80
```

### Health Check Requirements
```bash
# Health check configuration
gcloud compute health-checks create http my-health-check \
  --request-path="/health" \
  --port=80 \
  --check-interval=30 \
  --timeout=10 \
  --unhealthy-threshold=3 \
  --healthy-threshold=2
```

## Rollback Operations

### Manual Rollback Steps

1. **Delete New Template Instances**
   - Set new template target size to 0
   - GCP will terminate instances running new template

2. **Restore Original Distribution**
   - Original template returns to 100% traffic
   - Monitor health checks during transition

### Rollback Commands
```bash
# Delete canary instances
gcloud compute instance-groups managed set-instance-template my-group \
  --template=new-template \
  --region=us-central1 \
  --size=0

# Restore original configuration
gcloud compute instance-groups managed set-instance-template my-group \
  --template=old-template \
  --region=us-central1 \
  --size=3
```

## Lab Demo - Manual Canary Update

### Prerequisites Setup
- Existing Managed Instance Group with 2 instances
- Two instance templates (old-template, new-template)
- Configured load balancer with health checks

### Step-by-Step Demonstration

#### Step 1: Access Instance Group Update Page
```
Navigation:
Google Cloud Console → Compute Engine → Instance Groups
Select "managed-instance-group" → Update VMs
```

#### Step 2: Configure Canary Update
```yaml
# Add second instance template
Update Method: Manual
Instance Template: new-template
Target Size: Add 1 instance
Distribution: 50% old-template, 50% new-template
```

#### Step 3: Apply Update Configuration
```bash
# GCP Console actions
1. Click "Add instance template"
2. Select new-template from dropdown
3. Set target size to 1
4. Click "Update"
```

#### Step 4: Monitor Update Progress
```bash
# Check instance status
gcloud compute instance-groups managed list-instances my-group \
  --region=us-central1

# Expected output:
NAME              STATUS  TEMPLATE
my-group-abc1     RUNNING old-template
my-group-def2     RUNNING old-template  
my-group-ghi3     RUNNING new-template
```

#### Step 5: Test Traffic Distribution
```bash
# Test load balancer responses
curl http://load-balancer-ip/

# Verify new instances handling traffic
# Check application logs for new vs old behaviors
```

#### Step 6: Complete Rollout or Rollback
```yaml
# Option A: Complete rollout (100% new template)
Target Size:
- old-template: 0
- new-template: 3

# Option B: Rollback (100% old template)  
Target Size:
- old-template: 3
- new-template: 0
```

## Summary

### Key Takeaways
```diff
+ Canary updates enable gradual deployments with traffic control
+ Multiple instance templates allow A/B testing in production
+ Distribution percentages provide precise traffic management
+ Manual updates give full control over rollout process
+ Health checks ensure instance readiness before traffic shift
- Always test canary instances before increasing traffic distribution
- Monitor resource usage as canary updates temporarily increase instance count
! Load balancer health checks must be properly configured for safe updates
```

### Quick Reference

#### Common Commands
```bash
# Check instance group status
gcloud compute instance-groups managed describe my-group --region=us-central1

# List instances in group
gcloud compute instance-groups managed list-instances my-group --region=us-central1

# Update instance template
gcloud compute instance-groups managed set-instance-template my-group \
  --template=new-template --region=us-central1
```

#### Configuration Template
```yaml
# Basic canary update configuration
managedInstanceGroup:
  name: my-instance-group
  region: us-central1
  versions:
  - instanceTemplate: old-template
    targetSize:
      percent: 50
  - instanceTemplate: new-template
    targetSize:  
      percent: 50
  updatePolicy:
    type: OPPORTUNISTIC
    replacementMethod: RECREATE
    maxSurge: 1
    maxUnavailable: 0
```

#### Health Check Configuration
```yaml
healthChecks:
- name: http-health-check
  type: HTTP
  httpHealthCheck:
    port: 80
    requestPath: /health
    checkIntervalSec: 30
    timeoutSec: 10
    healthyThreshold: 2
    unhealthyThreshold: 3
```

### Expert Insight

#### Real-world Application
Canary updates are critical for **high-traffic production applications** where instant rollback capability is essential. In e-commerce platforms, canary deployments allow testing new payment processing logic with 5% of traffic before full rollout, preventing revenue loss from potential bugs.

#### Expert Path  
Master advanced MIG features like **stateful MIGs** for databases, **auto-healing configurations**, and **regional MIGs** for higher availability. Learn **Infrastructure as Code** using Terraform or Deployment Manager for reproducible canary update workflows.

#### Common Pitfalls
- **Insufficient testing**: Always validate canary instances with synthetic traffic before real user load
- **Resource over-commitment**: Calculate CPU/memory increases during canary phase to avoid performance degradation  
- **Load balancer misconfiguration**: Ensure health checks match application endpoints exactly
- **Template drift**: Keep instance templates synchronized across environments to prevent configuration inconsistencies
- **Rollback timing**: Execute rollbacks quickly when issues are detected to minimize user impact

</details>
