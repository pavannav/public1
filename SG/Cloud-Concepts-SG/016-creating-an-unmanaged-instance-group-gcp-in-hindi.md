# Session 016: Creating an Unmanaged Instance Group GCP in Hindi

<details open>
<summary><b>Session 016: Creating an Unmanaged Instance Group GCP in Hindi (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-concepts-deep-dive)
  - [Unmanaged vs Managed Instance Groups](#unmanaged-vs-managed-instance-groups)
  - [Prerequisites for Unmanaged Instance Groups](#prerequisites-for-unmanaged-instance-groups)
  - [Load Balancer Integration](#load-balancer-integration)
  - [Health Checks and Firewall Rules](#health-checks-and-firewall-rules)
- [Lab Demo: Creating Unmanaged Instance Group](#lab-demo-creating-unmanaged-instance-group)
  - [Step 1: Create VMs](#step-1-create-vms)
  - [Step 2: Create Unmanaged Instance Group](#step-2-create-unmanaged-instance-group)
  - [Step 3: Set up Load Balancer](#step-3-set-up-load-balancer)
  - [Step 4: Configure Firewall Rules](#step-4-configure-firewall-rules)
- [Summary](#summary)

## Overview
This session covers creating an unmanaged instance group in Google Cloud Platform (GCP). Unmanaged instance groups differ from managed ones as they don't require instance templates and allow VMs with different configurations to be grouped together. The session demonstrates adding VMs to instance groups, integrating with load balancers, and configuring health checks and firewall rules.

## Key Concepts/Deep Dive

### Unmanaged vs Managed Instance Groups

**Managed Instance Groups:**
- Require instance templates for VM creation
- All instances have identical configuration (machine type, disk, image)
- Support auto-scaling and rolling updates automatically

**Unmanaged Instance Groups:**
- Do not require instance templates
- Can contain VMs with different machine types and configurations
- No auto-scaling or automatic updates
- Better for heterogeneous workloads or testing environments

```diff
+ Unmanaged Instance Groups: Flexible for mixed configurations
- Managed Instance Groups: Require uniform instance templates
```

### Prerequisites for Unmanaged Instance Groups

All VMs in an unmanaged instance group must be in:
- **Same Network**: All instances share the same VPC network
- **Same Zone**: All instances must be in the same GCP zone (eg. us-central1-c)

> [!NOTE]
> VMs in different zones cannot be added to the same instance group.

### Load Balancer Integration

Unmanaged instance groups can be used as backends for HTTP/HTTPS load balancers to distribute traffic across multiple VMs.

**Health Checks:**
- Load balancers use health checks to determine VM availability
- Google Cloud uses specific IP ranges (130.211.0.0/22 and 35.191.0.0/16) for health checks
- VMs must respond on the health check port (default: 80)

### Health Checks and Firewall Rules

**Firewall Requirements:**
- Health checks originate from Google service IP ranges
- Firewall rules must allow traffic from these ranges to the health check port
- Without proper firewall rules, health checks fail and load balancers won't send traffic

```diff
+ Enable firewall rules for Google load balancer IP ranges
- Block health check IPs: Load balancers will mark VMs as unhealthy
```

## Lab Demo: Creating Unmanaged Instance Group

### Step 1: Create VMs

Pre-requisite: Same network and zone for all VMs

```bash
# Create first VM (E2 series with startup script)
gcloud compute instances create unmanage-vm1 \
  --zone=us-central1-c \
  --machine-type=e2-micro \
  --network=default \
  --tags=http-server \
  --metadata-from-file startup-script=startup-script.sh
```

```bash
# Create second VM (N1 series with different config)
gcloud compute instances create unmanage-vm2 \
  --zone=us-central1-c \
  --machine-type=n1-standard-1 \
  --network=default \
  --tags=http-server \
  --metadata-from-file startup-script=startup-script.sh
```

**Startup Script Example:**
```bash
#!/bin/bash
apt update
apt install -y apache2
echo "My page from $(hostname)" > /var/www/html/index.html
service apache2 start
```

### Step 2: Create Unmanaged Instance Group

```bash
# Access GCP Console: Compute Engine > Instance Groups > Create Instance Group
# Select "Unmanaged instance group"
gcloud compute instance-groups unmanaged create my-unmanaged-group \
  --zone=us-central1-c \
  --network=default
```

```bash
# Add existing VMs to the group
gcloud compute instance-groups unmanaged add-instances my-unmanaged-group \
  --zone=us-central1-c \
  --instances=unmanage-vm1,unmanage-vm2
```

### Step 3: Set up Load Balancer

```bash
# Create backend service
gcloud compute backend-services create my-backend-service \
  --protocol=HTTP \
  --health-checks=my-health-check \
  --global

# Add instance group to backend service
gcloud compute backend-services add-backend my-backend-service \
  --instance-group=my-unmanaged-group \
  --instance-group-zone=us-central1-c \
  --global
```

```bash
# Create health check
gcloud compute health-checks create http my-health-check \
  --port=80 \
  --global
```

### Step 4: Configure Firewall Rules

```bash
# Enable firewall rules for Google load balancer health checks
gcloud compute firewall-rules update default-allow-http \
  --source-ranges="130.211.0.0/22,35.191.0.0/16" \
  --allow=tcp:80

# Or create new rule if needed
gcloud compute firewall-rules create allow-health-check \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges="130.211.0.0/22,35.191.0.0/16" \
  --target-tags=http-server \
  --rules=tcp:80
```

## Summary

### Key Takeaways
```diff
+ Unmanaged instance groups provide flexibility for heterogeneous VM configurations
+ VMs must be in same network and zone to be grouped together
+ Load balancers require proper health checks and firewall rules for Google service IPs
+ Health checks determine if load balancers will send traffic to backend instances
```

### Quick Reference
- **Instance Group Type**: `unmanaged` - No template required
- **Prerequisites**: Same network, same zone
- **Health Check IPs**: `130.211.0.0/22,35.191.0.0/16`
- **Common Commands**:
  ```bash
  gcloud compute instance-groups unmanaged create [NAME] --zone=[ZONE] --network=[NETWORK]
  gcloud compute instance-groups unmanaged add-instances [GROUP] --instances=[VM_LIST]
  gcloud compute health-checks create http [NAME] --port=80
  ```

### Expert Insight

**Real-world Application:**
Unmanaged instance groups are ideal for microservices architectures where different services may require different VM configurations, or for blue-green deployments and canary releases where you need precise control over instance updates.

**Expert Path:**
- Learn managed instance groups for auto-scaling
- Master Google Cloud Load Balancing (HTTP(S), TCP, UDP)
- Implement monitoring with Cloud Monitoring and Logging
- Consider regional instance groups for multi-zone deployments

**Common Pitfalls:**
- Forgetting that all VMs must be in same zone
- Not configuring firewall rules for health check IPs - results in no traffic routing
- Mismatched health check ports between load balancer and VM services
- Assuming auto-scaling works with unmanaged groups (it doesn't)

</details>
