<details open>
<summary><b>001-How-to-Create-VM-GCP-in-Hindi (KK-CS45-script-v3)</b></summary>

# Session 1: How to Create VM in GCP

## Table of Contents
- [Overview](#overview)
- [Machine Types and Optimization](#machine-types-and-optimization)
- [Disks and Storage](#disks-and-storage)
- [Service Accounts and IAM](#service-accounts-and-iam)
- [Networking Configuration](#networking-configuration)
- [Security Features](#security-features)
- [Instance Options and Maintenance](#instance-options-and-maintenance)
- [VM Creation Process](#vm-creation-process)
- [Summary](#summary)

## Overview
This session covers the step-by-step process of creating and configuring Virtual Machines (VMs) in Google Cloud Platform (GCP) Compute Engine. You'll learn about machine types, storage options, networking, security settings, and best practices for deploying VMs in GCP. The session focuses on practical configuration options including optimization strategies, cost-effective instance types, and proper access management.

## Machine Types and Optimization

### VM Machine Types
GCP offers various machine types designed for different workloads:

- **General Purpose**: Balanced CPU and memory for general applications
- **Compute Optimized**: Focuses on high CPU performance for compute-intensive tasks
- **Memory Optimized**: Maximizes memory capacity (up to 12TB per VM) for memory-intensive workloads
- **Shared Core**: Cost-effective option for development, testing, and small applications (e.g., f1-micro, g1-small)

### Optimization Strategies
```diff
+ Balanced Optimization: Equal focus on CPU, memory, and storage
+ Compute Optimized: Maximum CPU performance (best for high-performance computing)
+ Memory Optimized: Maximum memory allocation (ideal for databases, in-memory processing)
- General Purpose: May be over-provisioned for specialized workloads
```

### Spot Instances
Cost-effective alternative to regular instances (up to 70-80% savings):
- **Preemptible**: Can be terminated by Google with 30-second notice
- **Best for**: Fault-tolerant, batch processing, development/testing workloads
- **Risk**: Automatic shutdown during maintenance or high-demand periods

## Disks and Storage

### Disk Types
GCP provides multiple disk options for different performance needs:

- **Standard Persistent Disk**: Cost-effective, HDD-based storage
- **SSD Persistent Disk**: Higher performance, SSD-based storage
- **Balanced Persistent Disk**: Optimal performance-to-cost ratio
- **Extreme Persistent Disk**: Highest performance for demanding applications

### Key Features
```diff
+ Automatic Encryption: Google automatically encrypts all disk data
+ Boot Disk: Contains OS image and initial files
+ Data Disks: Additional storage for applications and data
- Manual Deletion Protection: Must be explicitly removed before VM deletion
```

### Backup and Recovery
- **Snapshots**: Point-in-time backups of persistent disks
- **Scheduled Snapshots**: Automated backup schedules for data protection
- **Cross-region replication**: Geographic redundancy options

## Service Accounts and IAM

### Service Account Roles
When creating VMs, you can choose from different service account options:

- **Default Service Account**: Basic access for most common operations
- **Custom Service Account**: Specific permissions tailored to your needs
- **No Service Account**: Minimal access, only for basic VM operations

### IAM Permissions
Common permission levels:
- **Editor**: Full access to create and modify resources
- **Viewer**: Read-only access for monitoring
- **Custom Roles**: Granular permissions for specific APIs

```diff
+ Principle of Least Privilege: Grant only necessary permissions
- Over-permissions: Avoid providing full access unnecessarily
! Security: Regularly audit service account usage
```

## Networking Configuration

### Network Interface Types
- **Access Config Enabled**: Includes public IP for internet access
- **Access Config Disabled**: No public IP, internal network only
- **Ephemeral IPs**: Temporary IPs assigned during VM lifecycle
- **Static IPs**: Reserved IPs that persist across VM restarts/deletions

### Network Tags
Security and routing configuration:
- **Firewall Rules**: Control inbound/outbound traffic
- **Load Balancer Targeting**: Route traffic through load balancers
- **Network Policies**: Centralized network management

### IP Address Management
```bash
# Internal IP - Accessible within VPC network
Internal_IP: 10.x.x.x range

# External IP - Public internet access
External_IP: Public address for internet connectivity
```

> [!IMPORTANT]
> Reserve static IPs for production workloads to maintain consistent access points.

## Security Features

### Boot Integrity
- **Secure Boot**: Prevents boot from unauthorized sources
- **Integrity Monitoring**: Detects changes to VM boot process
- **vTPM**: Virtual Trusted Platform Module for enhanced security

### Networking Security
- **Firewall Rules**: Fine-grained traffic filtering
- **Network Tags**: Apply security policies consistently
- **Private Google Access**: Access Google services without public IPs

## Instance Options and Maintenance

### Maintenance Behavior
During host maintenance events:
- **Migrate**: VM automatically moved to new host with minimal downtime
- **Terminate**: VM shutdown during maintenance (suitable for fault-tolerant workloads)

### Instance Scheduling
- **On/Off Options**: Schedule automatic startup/shutdown based on usage patterns
- **Maintenance Windows**: Choose optimal downtime for batch processing

### Cost Optimization
Spot instances versus regular instances:
```diff
+ Spot Instances: Up to 80% cost savings
- Spot Instances: Higher risk of termination
+ Regular Instances: Guaranteed availability
- Regular Instances: Higher cost
```

> [!NOTE]
> Use spot instances for non-critical workloads like development, testing, and batch processing.

## VM Creation Process

### Basic VM Creation Steps

1. **Select Project**: Choose your GCP project
2. **Choose Region/Zone**: Select geographic location (affects latency and cost)
3. **Configure Machine Type**: Select CPU/memory based on requirements
4. **Choose Boot Disk**: Select OS image and disk type
5. **Network Settings**: Configure VPC, subnet, and IP options
6. **Security**: Set up service accounts and firewall rules
7. **Create Instance**: Deploy the VM

### Result
Successfully created VMs show:
- **Internal IP**: For VPC network communication
- **External IP**: For internet access (if configured)
- **Status**: Running state confirmation
- **Metadata**: Instance details and configurations

## Lab Demo: Creating a GCP VM

### Prerequisites
- Active GCP account with billing enabled
- Basic familiarity with GCP Console

### Step-by-Step VM Creation

1. **Navigate to Compute Engine**
   - Open GCP Console → Navigation menu → Compute Engine → VM instances

2. **Create Instance**
   - Click "CREATE INSTANCE"
   - Name your VM (e.g., test-vm)

3. **Machine Configuration**
   ```bash
   # Select machine type
   Machine Type: e2-medium (2 vCPU, 4GB RAM) - Cost-effective general purpose
   
   # Or for compute-intensive workloads
   Machine Type: c2-standard-4 (4 vCPU, 16GB RAM)
   ```

4. **Boot Disk Setup**
   ```bash
   # Select operating system
   OS: Ubuntu 22.04 LTS
   Disk Type: Balanced Persistent Disk
   Size: 20 GB
   ```

5. **Network Configuration**
   ```yaml
   Network: default
   Subnetwork: auto-selected
   External IP: Ephemeral (temporary public IP)
   Firewall: Allow HTTP/HTTPS traffic (optional)
   ```

6. **Service Account**
   - Choose: Compute Engine default service account
   - Access scopes: Allow full access to Cloud APIs

7. **Advanced Options**
   - Security: Enable Secure Boot
   - Maintenance: Automatic restart enabled
   - Deletion protection: Disabled (for development)

8. **Create VM**
   - Click "CREATE"
   - Monitor creation progress

### Post-Creation Verification
```bash
# Check VM status in GCP Console
VM Instances → Your VM → Status: Running

# SSH Access (if external IP configured)
gcloud compute ssh test-vm --zone=YOUR_ZONE

# Verify internal connectivity
ping INTERNAL_IP_FROM_ANOTHER_VM
```

## Summary

### Key Takeaways
```diff
+ GCP VMs offer multiple optimization strategies: Balanced, Compute-optimized, Memory-optimized
+ Choose appropriate disk types: Standard (cost-effective), SSD (high performance), Balanced (optimal), Extreme (maximum performance)
+ Configure networking carefully: Public IPs for internet access, private networks for internal communication
+ Use spot instances for cost savings on fault-tolerant workloads (up to 80% cheaper)
+ Enable security features: Secure Boot, integrity monitoring, vTPM
+ Always plan for maintenance events: Choose migrate or terminate behavior appropriately
+ Service accounts provide fine-grained IAM control for VM access
+ Reserve static IPs for production workloads to maintain consistent endpoints
```

### Quick Reference

#### Common GCP VM Commands
```bash
# Create a basic VM
gcloud compute instances create test-vm \
  --machine-type=e2-medium \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud

# List running VMs
gcloud compute instances list

# SSH into VM
gcloud compute ssh test-vm --zone=us-central1-a

# Stop VM
gcloud compute instances stop test-vm

# Delete VM
gcloud compute instances delete test-vm
```

#### Machine Type Comparison
| Type | vCPU | Memory | Use Case | Cost/Hour (USD) |
|------|------|--------|----------|-----------------|
| f1-micro | 0.2 | 0.6GB | Development/Testing | ~$0.007 |
| e2-medium | 2 | 4GB | General Purpose | ~$0.034 |
| c2-standard-4 | 4 | 16GB | High Performance | ~$0.187 |
| m2-ultramem-208 | 208 | 5888GB | Memory Intensive | ~$44.43 |

### Expert Insight

#### Real-world Application
Production VM deployment involves:
- **Capacity Planning**: Analyze workload requirements (CPU, memory, storage)
- **High Availability**: Distribute across multiple zones/regions
- **Cost Optimization**: Use committed use discounts for predictable workloads
- **Monitoring**: Implement Cloud Monitoring and logging
- **Security**: Apply principle of least privilege, regular patch management

#### Expert Path
To master GCP VM management:
- Understand GCP's resource hierarchy (Organization → Folders → Projects → Resources)
- Learn Infrastructure as Code (Cloud Deployment Manager, Terraform)
- Master gcloud CLI for automation
- Study GCP networking concepts (VPC, subnets, firewall rules)
- Monitor costs with GCP Billing reports and budgets
- Implement auto-scaling for variable workloads

#### Common Pitfalls
```diff
- Not planning IP allocation strategy (leads to connectivity issues)
- Over-provisioning for temporary workloads (waste of resources)
- Ignoring maintenance behavior settings (unexpected downtime)
- Using default service accounts with excessive permissions
- Forgetting to enable deletion protection on production VMs
- Not monitoring costs for on-demand instances
- Skipping snapshot backups for persistent data
! Security: Never expose sensitive VMs directly to internet without proper security controls
```

</details>
