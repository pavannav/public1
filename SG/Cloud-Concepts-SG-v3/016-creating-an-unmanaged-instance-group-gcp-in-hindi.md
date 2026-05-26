<details open>
<summary><b>Session 016: Creating an Unmanaged Instance Group GCP in Hindi (KK-CS45-script-v3)</b></summary>

# Session 016: Creating an Unmanaged Instance Group in GCP

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Understanding Instance Groups](#understanding-instance-groups)
  - [Unmanaged vs Managed Instance Groups](#unmanaged-vs-managed-instance-groups)
  - [Prerequisites and Requirements](#prerequisites-and-requirements)
  - [Load Balancer Integration](#load-balancer-integration)
  - [Health Checks](#health-checks)
  - [Firewall Configuration](#firewall-configuration)
- [Lab Demo: Creating Unmanaged Instance Group](#lab-demo-creating-unmanaged-instance-group)
- [Summary](#summary)

## Overview
This session covers creating and managing unmanaged instance groups in Google Cloud Platform (GCP). Unlike managed instance groups that require instance templates, unmanaged groups allow you to directly add existing VMs with different configurations. The session demonstrates the complete workflow including VM creation, instance group setup, load balancer integration with health checks, and firewall rule configuration.

## Key Concepts and Deep Dive

### Understanding Instance Groups
Instance groups in GCP are collections of virtual machine (VM) instances that can be managed as a single unit. They enable you to:
- Apply configuration changes to multiple instances simultaneously
- Implement load balancing across instances
- Perform rolling updates
- Auto-scale based on utilization metrics

### Unmanaged vs Managed Instance Groups

| Feature | Unmanaged Instance Group | Managed Instance Group |
|---------|------------------------|----------------------|
| **Template Requirement** | No template needed | Requires instance template |
| **Instance Flexibility** | VMs can have different machine types, configurations | All instances from same template |
| **Auto-scaling** | Manual scaling only | Supports auto-scaling policies |
| **Rolling Updates** | Manual updates required | Supports automated rolling updates |
| **Simplicity** | Simple collection of VMs | Complex state management |
| **Use Case** | Quick grouping of unrelated VMs | Consistent application deployment |

**Key Differences Explained:**
- **Configuration Flexibility**: Unmanaged groups allow heterogeneous VM configurations (different machine types, disk sizes, etc.), while managed groups enforce uniform configuration through templates.
- **State Management**: Managed groups maintain state and can recreate failed instances, whereas unmanaged groups simply group existing VMs without ownership.
- **Complexity**: Unmanaged groups are simpler to set up but require manual management for updates and scaling.

### Prerequisites and Requirements
> [!IMPORTANT]
> Unmanaged instance groups have strict requirements for successful operation.

**Mandatory Requirements:**
- All instances must reside in the **same network**
- All instances must be in the **same zone**
- VMs must have **consistent application configuration** for effective load balancing

**Network Considerations:**
- Instances can be in different projects if using Shared VPC
- Regional instance groups are available but must span multiple zones
- Cross-region instance groups are not supported

### Load Balancer Integration
Load balancers distribute traffic across multiple instances in an instance group. Key components:

**Backend Service Configuration:**
- Defines how traffic is routed to instances
- Specifies load balancing algorithm (default: round-robin)
- Configures session affinity if needed

**Frontend Configuration:**
- External load balancer IP address allocation
- SSL certificate setup (optional)
- URL routing rules

### Health Checks
Health checks verify instance availability before directing traffic to them.

**Health Check Parameters:**
- **Protocol**: HTTP/HTTPS/TCP/SSL
- **Port**: Default port for health checks (must match application)
- **Request Path**: URL path to check (e.g., `/health`)
- **Check Interval**: Frequency of health verification
- **Timeout**: Maximum response time allowed
- **Healthy Threshold**: Number of successful checks needed
- **Unhealthy Threshold**: Number of failed checks before marking unhealthy

> [!NOTE]
> Health check endpoints must return HTTP 200 status codes to be considered healthy.

### Firewall Configuration
Load balancer health checks originate from specific Google Cloud IP ranges and require dedicated firewall rules.

**Required Firewall Rules:**
- Source IP ranges: `130.211.0.0/22` and `35.191.0.0/16`
- Protocol: TCP
- Ports: Must match health check port (typically port 80)

```bash
# Example firewall rule creation
gcloud compute firewall-rules create allow-health-checks \
  --allow tcp:80 \
  --source-ranges 130.211.0.0/22,35.191.0.0/16 \
  --description "Allow load balancer health checks"
```

## Lab Demo: Creating Unmanaged Instance Group

### Step 1: Create VMs with Different Configurations

**VM 1 Configuration:**
- Name: `unmanaged-vm1`
- Machine Type: E2 series
- Zone: us-central1-c
- Network: default
- Firewall: Allow HTTP traffic
- Startup Script: Echo hostname

```bash
gcloud compute instances create unmanaged-vm1 \
  --machine-type=e2-small \
  --zone=us-central1-c \
  --tags=http-server \
  --metadata startup-script='echo "My hostname: $(hostname)"' \
  --allow-traffic-from-rules=all
```

**VM 2 Configuration:**
- Name: `unmanaged-vm2`
- Machine Type: N1 series (g1-small)
- Zone: us-central1-c (same zone)
- Network: default (same network)
- Firewall: Allow HTTP traffic
- Startup Script: Same echo script

```bash
gcloud compute instances create unmanaged-vm2 \
  --machine-type=g1-small \
  --zone=us-central1-c \
  --tags=http-server \
  --metadata startup-script='echo "My hostname: $(hostname)"' \
  --allow-traffic-from-rules=all
```

### Step 2: Create Unmanaged Instance Group

```bash
gcloud compute instance-groups unmanaged create my-unmanaged-group \
  --zone=us-central1-c
```

**Add Instances to Group:**
```bash
gcloud compute instance-groups unmanaged add-instances my-unmanaged-group \
  --instances=unmanaged-vm1,unmanaged-vm2 \
  --zone=us-central1-c
```

### Step 3: Configure Load Balancer

**Create HTTPS Load Balancer:**
1. Navigate to Load Balancing > Create Load Balancer
2. Select HTTPS Load Balancer
3. Configure frontend (protocol: HTTP, global scope)

**Create Backend Service:**
```bash
gcloud compute backend-services create my-backend-service \
  --load-balancing-scheme=EXTERNAL \
  --protocol=HTTP
```

**Add Instance Group to Backend:**
```bash
gcloud compute backend-services add-backend my-backend-service \
  --instance-group=my-unmanaged-group \
  --zone=us-central1-c \
  --port-name=http \
  --balancing-mode=UTILIZATION
```

**Create Health Check:**
```bash
gcloud compute health-checks create http my-health-check \
  --port=80 \
  --check-interval=10 \
  --timeout=5 \
  --unhealthy-threshold=3 \
  --healthy-threshold=2
```

**Attach Health Check to Backend Service:**
```bash
gcloud compute backend-services update my-backend-service \
  --health-checks=my-health-check
```

### Step 4: Configure Firewall Rules

**Enable Health Check Firewall Rule:**
```bash
gcloud compute firewall-rules update allow-health-checks \
  --source-ranges="130.211.0.0/22,35.191.0.0/16" \
  --allow=tcp:80 \
  --enable
```

> [!NOTE]
> Health check ranges: `130.211.0.0/22` and `35.191.0.0/16` are Google's standard ranges for load balancer health checks.

### Step 5: Test Load Balancer

**Verify Load Balancer IP:**
- Access the load balancer's public IP
- Observe traffic distribution between VMs
- Check hostname responses alternate between VMs

**Remove Instance from Group:**
```bash
gcloud compute instance-groups unmanaged remove-instances my-unmanaged-group \
  --instances=unmanaged-vm1 \
  --zone=us-central1-c
```

**Verify Traffic Routing:**
- Only `unmanaged-vm2` receives traffic after removal
- Load balancer automatically stops routing to removed instance

## Summary

### Key Takeaways
```diff
+ Unmanaged instance groups are simpler than managed groups but offer less automation
+ All VMs in an unmanaged group must be in the same network and zone
+ VMs can have heterogeneous configurations (different machine types, disk sizes)
+ Load balancer integration requires proper health checks and firewall rules
+ Health checks use specific Google Cloud IP ranges that must be allowed in firewall rules
- No auto-scaling or rolling update capabilities in unmanaged groups
- Manual management required for all instance lifecycle operations
- Group creation fails if VMs are in different zones or networks
```

### Quick Reference

**Common Commands:**
```bash
# Create unmanaged instance group
gcloud compute instance-groups unmanaged create [GROUP_NAME] --zone=[ZONE]

# Add instances to group
gcloud compute instance-groups unmanaged add-instances [GROUP_NAME] \
  --instances=[INSTANCE1,INSTANCE2] --zone=[ZONE]

# Create health check
gcloud compute health-checks create http [HEALTH_CHECK_NAME] \
  --port=80 --check-interval=10

# Enable load balancer firewall rules
gcloud compute firewall-rules update [RULE_NAME] \
  --source-ranges="130.211.0.0/22,35.191.0.0/16" --allow=tcp:80
```

**Critical IP Ranges:**
- Health Check Range 1: `130.211.0.0/22`
- Health Check Range 2: `35.191.0.0/16`

**Health Check Defaults:**
- Port: 80 (HTTP)
- Check Interval: 5-10 seconds
- Timeout: 5 seconds
- Healthy Threshold: 2 consecutive successes
- Unhealthy Threshold: 3 consecutive failures

### Expert Insight

**Real-world Application**
Unmanaged instance groups are ideal for:
- Testing environments with mixed VM configurations
- Legacy applications requiring different instance types
- Temporary groupings for deployment testing
- Situations where you need precise control over individual VMs

They shine in development and staging environments where you need flexibility without the complexity of managed groups.

**Expert Path**
Master unmanaged instance groups by understanding:
- Network architecture impacts on load balancer efficiency
- Health check tuning for different application types
- Monitoring and alerting setup for instance health
- Integration with Cloud Monitoring for group-level metrics

**Common Pitfalls**
- **Zone Mismatch**: Always verify all VMs are in the same zone
- **Network Isolation**: Ensure VPC/subnet configuration is consistent
- **Health Check Failures**: Double-check firewall rules and application ports
- **Load Imbalance**: Monitor actual traffic distribution, not just configuration
- **Application State**: Remember that removing a VM doesn't delete the actual instance

</details>
