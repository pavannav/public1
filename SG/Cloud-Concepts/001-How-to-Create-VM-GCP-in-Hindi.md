# Session 001: How to Create VM in GCP

<details open>
<summary><b>Session 001 (Claude)</b></summary>

## Table of Contents
1. [Overview](#overview)
2. [Key Concepts](#key-concepts)
   - [Machine Types](#machine-types)
   - [Boot Disk Options](#boot-disk-options)
   - [Service Accounts](#service-accounts)
   - [Networking Configuration](#networking-configuration)
   - [Spot VMs](#spot-vms)
   - [Host Maintenance Options](#host-maintenance-options)
3. [Lab Demo: Creating a VM](#lab-demo)
4. [Summary](#summary)

## Overview
This session covers the comprehensive process of creating a Virtual Machine (VM) instance in Google Cloud Platform (GCP). The training walks through all configuration options available in the GCP Console, including machine type selection, storage configuration, networking setup, and advanced options like spot VMs and maintenance policies.

## Key Concepts

### Machine Types
GCP offers different machine type categories optimized for specific workloads:

- **General Purpose**: Balanced CPU and memory for variety of workloads
- **Memory Optimized**: Maximum memory allocation for memory-intensive applications
- **Compute Optimized**: Higher CPU allocation for compute-intensive tasks
- **Accelerator Optimized**: Includes GPUs for specialized workloads

**Small/Medium Series**: The training specifically mentions "small micro" series machines, which are entry-level options suitable for basic testing and development.

### Boot Disk Options
When creating a VM, you configure the boot disk which contains the operating system:

- **Standard Persistent Disk**: Basic storage option, balanced performance
- **Balanced Persistent Disk**: Improved performance over standard
- **SSD Persistent Disk**: High-performance storage for I/O intensive workloads
- **Extreme Persistent Disk**: Highest performance option for demanding applications

**Key Features**:
- Deletion Rule: Option to delete disk with instance or retain it
- Encryption: GCP automatically encrypts disks at rest
- Snapshots: Can schedule regular backups of the disk

### Service Accounts
Service accounts allow VMs to interact with other GCP services:

- **Default Service Account**: Automatically created, provides basic permissions
- **Custom Service Account**: User-created with specific permissions
- **Access Scopes**: Define which GCP APIs the service account can access
  - Read-only access
  - Full access
  - Custom API selection

### Networking Configuration
VM networking involves several key components:

#### Network Interface
- **VPC Selection**: Choose the Virtual Private Cloud network
- **Subnet Selection**: Select specific subnet within VPC
- **Multiple NICs**: Option to attach multiple network interfaces

#### IP Address Configuration
- **Internal IP**:
  - Automatic allocation (ephemeral)
  - Custom static IP (reserved)
- **External IP**:
  - Ephemeral (temporary)
  - Static (permanent, costs money when not in use)
  - None (no internet access)

### Spot VMs
Spot VMs offer significant cost savings with specific trade-offs:

**Benefits**:
- Up to 60-91% discount compared to standard VMs
- Suitable for fault-tolerant, stateless workloads

**Risks**:
- VMs can be preempted with 30-second notice
- No availability SLA guaranteed
- Best for batch processing, CI/CD, and testing

### Host Maintenance Options
GCP provides two options for host maintenance events:

1. **Migrate VM**: Live migration to another host (recommended)
   - Minimal downtime
   - VM remains running
   - Default behavior

2. **Terminate VM**: VM is shut down during maintenance
   - Requires manual restart
   - May cause service interruption
   - Use for applications that can't tolerate migration

## Lab Demo

### Step-by-Step VM Creation

1. **Navigate to Compute Engine**
   - Go to GCP Console → Compute Engine → VM instances
   - Click "Create Instance"

2. **Basic Configuration**
   ```
   Name: test-vm (or your preferred name)
   Region: Select region closest to users (e.g., Mumbai for India)
   Zone: Choose zone within region
   ```

3. **Machine Configuration**
   ```
   Series: General-purpose N1, N2, etc.
   Machine Type:
     - Small: e2-micro (shared core)
     - Standard: n2-standard-2, n2-standard-4
     - Memory Optimized: n2-highmem
   ```

4. **Boot Disk Configuration**
   ```
   Operating System: Ubuntu, CentOS, Windows, etc.
   Boot Disk Type:
     - Standard Persistent Disk
     - Balanced Persistent Disk
     - SSD Persistent Disk
   Size: Minimum based on OS requirements
   Deletion Rule: Delete with instance (optional)
   ```

5. **Identity and API Access**
   ```
   Service Account:
     - Default Compute Engine service account
     - Or select custom service account
   Access Scopes:
     - Allow full access to all Cloud APIs
     - Set access for each API
   ```

6. **Networking**
   ```
   Network Tags: For firewall rules
   Network Interfaces:
     - Network: default or custom VPC
     - Subnet: Select appropriate subnet
     - Internal IP: Ephemeral or Static
     - External IP: Ephemeral, Static, or None
   ```

7. **Management Options**
   ```
   Preemptibility: Enable for Spot VMs
   Automatic Restart: Yes/No
   On Host Maintenance: Migrate or Terminate
   Deletion Protection: Enable to prevent accidental deletion
   ```

8. **Create and Verify**
   - Review all configurations
   - Click "Create"
   - Note assigned internal and external IPs

## Important Notes

> [!WARNING]
> **Transcript Corrections**:
> - "बीएमडब्ल्यू" (BMW) should be "VM" - This appears to be a transcription error where "VM" was misheard/transcribed as "BMW"
> - Always verify VM-related references in the transcript

## Summary

### Key Takeaways
```diff
+ VM creation involves multiple configuration layers: compute, storage, network, and security
+ Choose machine types based on workload requirements (CPU vs Memory optimized)
+ Boot disk selection impacts performance and cost
+ Service accounts control VM access to other GCP services
+ Networking configuration determines internet access and inter-service communication
+ Spot VMs offer significant cost savings with availability trade-offs
+ Host maintenance policies affect application availability during infrastructure updates
```

### Quick Reference
```bash
# CLI equivalent for VM creation
gcloud compute instances create INSTANCE_NAME \
    --zone=ZONE \
    --machine-type=MACHINE_TYPE \
    --image-family=IMAGE_FAMILY \
    --image-project=IMAGE_PROJECT \
    --boot-disk-size=SIZE \
    --boot-disk-type=DISK_TYPE
```

### Expert Insights

**Real-world Application**:
- Use standard VMs for web servers and databases
- Implement Spot VMs for CI/CD pipelines and data processing
- Reserve capacity for predictable workloads using reservations
- Always enable deletion protection for production VMs

**Expert Path**:
- Master `gcloud` CLI for automation
- Learn Infrastructure as Code with Terraform
- Understand pricing models and cost optimization
- Implement proper tagging and labeling strategies

**Common Pitfalls**:
- Forgetting to release static external IPs when not in use
- Using Spot VMs for critical workloads without proper handling
- Not configuring appropriate firewall rules
- Over-provisioning resources leading to unnecessary costs

</details>