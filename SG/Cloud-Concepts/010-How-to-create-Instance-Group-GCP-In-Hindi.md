# Session 010: How to Create Instance Groups in GCP

<details open>
<summary><b>Session 010: How to Create Instance Groups in GCP (Claude Opus 4)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Lab Demo: Creating a Managed Instance Group](#lab-demo-creating-a-managed-instance-group)
- [Instance Group Types](#instance-group-types)
- [Auto Scaling Configuration](#auto-scaling-configuration)
- [Auto Healing](#auto-healing)
- [Summary](#summary)

## Overview
This session covers creating and configuring Instance Groups in Google Compute Engine, building upon Instance Templates from the previous session. Instance Groups enable high availability, auto-scaling, and load balancing for your applications.

## Key Concepts

### What are Instance Groups?
Instance Groups are collections of VM instances that share common configuration and enable advanced features like auto-scaling, load balancing, and auto-healing. They provide the foundation for highly available and scalable applications.

### Types of Instance Groups
1. **Managed Instance Groups (MIGs)**: Created from Instance Templates with identical VM configurations
2. **Unmanaged Instance Groups**: Manually added existing VMs with potentially different configurations

### Key Features
- **High Availability**: Distribute VMs across multiple zones
- **Auto Scaling**: Automatically adjust VM count based on load
- **Auto Healing**: Automatically replace unhealthy VMs
- **Load Balancing**: Integrate with Google Cloud Load Balancers

## Lab Demo: Creating a Managed Instance Group

### Step 1: Navigate to Instance Groups
```
GCP Console → Compute Engine → Instance groups → Create instance group
```

### Step 2: Configure Basic Settings
```
Name: my-new-ig
Description: Instance group for web servers
```

### Step 3: Select Instance Template
```
Instance Template: Select from previously created templates
- Can create new template if needed
- Choose from available templates (e.g., "first", "second")
```

### Step 4: Configure Location and Distribution
```
Location Options:
1. Single Zone: All VMs in one zone
   - Risk: Zone failure impacts entire group

2. Multiple Zones: VMs distributed across zones
   - Benefit: Higher availability
   - Configure target distribution policy

Target Distribution Policy:
- Even: Distribute VMs evenly across selected zones
- Balanced: Place VMs in zones with available capacity
- Any Single Zone (Preview): All VMs in one zone
```

### Step 5: Configure Auto Scaling
```
Auto Scaling Options:
1. No Scaling: Fixed number of VMs
2. Auto Scale: Dynamic scaling based on metrics

For Auto Scaling:
- Minimum instances: 2
- Maximum instances: 100 (or based on requirements)
- Scaling policy based on CPU utilization, load balancer, etc.
```

### Step 6: Configure Auto Healing
```
Health Check Configuration:
- Create or select existing health check
- Define check interval and timeout
- Set healthy/unhealthy thresholds

Auto Healing Behavior:
- Unhealthy VMs automatically recreated
- Requires proper health check configuration
- Prevents infinite loops from blocked health checks
```

### Step 7: Create Instance Group
```
Review configuration
Click "Create"
Group creation begins with automatic VM provisioning
```

## Instance Group Types

### Managed Instance Groups (MIGs)
```diff
+ Stateless workloads (default)
+ VMs created from single Instance Template
+ Automatic naming with random suffixes
+ Supports auto-scaling and auto-healing
+ Required for load balancer backends
```

### Unmanaged Instance Groups
```
Use Case: Group existing VMs with different configurations
Creation Process:
1. Create new unmanaged instance group
2. Manually add existing VMs
3. No template requirement
4. Can be used with load balancers
```

## Auto Scaling Configuration

### Scaling Modes

#### Scale Out Only
- Increases VM count during high load
- Does not decrease VM count when load drops
- Requires manual intervention to reduce VMs

#### Auto Scale (Bidirectional)
- Automatically adds VMs when load increases
- Automatically removes VMs when load decreases
- Requires proper metric configuration

### Scaling Metrics

#### CPU Utilization
```yaml
Target CPU: 60%
Behavior: Add VM when average exceeds 60%
Remove VM: When load falls below threshold
```

#### Load Balancer Metrics
- Requests per second
- Backend latency
- Custom Cloud Monitoring metrics

#### Predictive Auto Scaling
- Uses machine learning on historical data
- Anticipates load increases
- Pre-emptively scales before load spike

### Configuration Example
```
Minimum instances: 2
Maximum instances: 100
Metric: CPU utilization
Target: 60%
Cooldown period: Default (for stabilization)
```

## Auto Healing

### Health Check Configuration
```
Protocol: HTTP/HTTPS/TCP
Port: Application port (e.g., 80, 443)
Request Path: Health endpoint (e.g., /health)
Check Interval: 30 seconds (default)
Timeout: 5 seconds (default)
Healthy Threshold: 2 successful checks
Unhealthy Threshold: 2 failed checks
```

### Important Considerations
```diff
! Ensure health checks can reach VMs
! Verify firewall rules allow health check traffic
! Configure proper response codes
- Misconfigured health checks cause infinite recreation loops
```

### Auto Healing Process
1. Health check detects unhealthy VM
2. Instance Group marks VM as unhealthy
3. Unhealthy VM is deleted
4. New VM created from template
5. New VM joins instance group

## VM Naming and Identification

### Naming Convention
```
Format: [instance-group-name]-[random-suffix]
Example: my-new-ig-x7k9p
Purpose: Ensures unique names across group
```

### VM Properties
- Random suffixes for uniqueness
- Creation timestamp tracking
- IP address assignment (internal/external based on template)
- Automatic metadata propagation from template

## Port Mapping for Load Balancing

### Named Ports Configuration
```yaml
Purpose: Map service names to ports for load balancers
Example:
  - Name: http
    Port: 80
  - Name: https
    Port: 443
Usage: Referenced by load balancer backend services
```

## Stateless vs Stateful Workloads

### Stateless (Default)
```diff
+ No persistent state on VMs
+ Disk data not preserved across recreations
+ Suitable for web servers, API backends
+ VMs can be replaced without data loss concerns
- Application state must be external (database, cache)
```

### Stateful (Requires Special Configuration)
- Preserves disk state across VM recreations
- Maintains IP addresses
- Requires different creation process
- Covered in subsequent sessions

## Monitoring and Management

### Available Options
- **Monitoring Dashboard**: Traffic patterns, errors, performance metrics
- **VM Management**: Individual VM restart, replace operations
- **Rolling Updates**: Template version management (covered in next session)
- **Error Tracking**: Identify and troubleshoot issues

### Key Metrics to Monitor
- Request rate and latency
- Error rates
- VM utilization patterns
- Auto-scaling events

## Summary

### Key Takeaways
```diff
+ Instance Groups provide high availability and scalability
+ Managed groups require Instance Templates for identical VMs
+ Auto-scaling adjusts VM count based on defined metrics
+ Auto-healing replaces unhealthy VMs automatically
+ Distribution across zones prevents single points of failure
+ Health checks must be properly configured to avoid issues
- Stateless workloads are default; stateful requires special setup
- Unmanaged groups allow grouping existing diverse VMs
```

### Quick Reference
```bash
# Create managed instance group
gcloud compute instance-groups managed create GROUP_NAME \
    --base-instance-name BASE_NAME \
    --template TEMPLATE_NAME \
    --size 2 \
    --zone ZONE

# Configure auto-scaling
gcloud compute instance-groups managed set-autoscaling GROUP_NAME \
    --max-num-replicas 100 \
    --target-cpu-utilization 0.6 \
    --zone ZONE

# Enable auto-healing
gcloud compute instance-groups managed update GROUP_NAME \
    --health-check HEALTH_CHECK_NAME \
    --initial-delay 300 \
    --zone ZONE

# List instance groups
gcloud compute instance-groups list

# Describe instance group
gcloud compute instance-groups describe GROUP_NAME --zone ZONE
```

### Expert Insight

#### Real-world Application
- Deploy stateless web applications with automatic scaling
- Implement high-availability architectures across multiple zones
- Enable cost-effective auto-scaling for variable workloads

#### Expert Path
- Master advanced auto-scaling policies with custom metrics
- Implement rolling updates and canary deployments
- Design stateful workloads with persistent disks
- Optimize health check configurations for various application types

#### Common Pitfalls
- Not configuring health checks properly, causing VM recreation loops
- Setting identical min/max instance counts (prevents scaling)
- Ignoring zone distribution for single-zone deployments
- Not planning for stateless design in applications
- Overlooking named port configuration for load balancing integration

</details>