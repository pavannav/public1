# Session 001: How to Create VM in GCP

<details open>
<summary><b>How to Create VM GCP in Hindi (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [VM Machine Types](#vm-machine-types)
  - [Memory Optimization](#memory-optimization)
  - [Boot Disk](#boot-disk)
  - [Service Accounts](#service-accounts)
  - [Networking](#networking)
  - [Security Options](#security-options)
  - [Reservations](#reservations)
  - [Spot Instances](#spot-instances)
  - [Host Maintenance](#host-maintenance)
- [Lab Demonstration](#lab-demonstration)
- [Summary](#summary)

## Overview
This session explains how to create a Virtual Machine (VM) in Google Cloud Platform (GCP) in Hindi. The transcript covers the step-by-step process of VM creation, including machine type selection, memory optimization, networking configuration, security settings, and other advanced options like service accounts and spot instances.

## Key Concepts and Deep Dive

### VM Machine Types
VMs in GCP come with different machine types optimized for specific workloads:
- **Standard Series**: Balanced CPU and memory for general-purpose workloads.
- **High-memory Optimized**: Focus on maximizing memory (e.g., Series like the 8.5 mentioned in transcript).
- **High-CPU Optimized**: Emphasis on CPU performance.
- **Small/Micro Series**: Cost-effective options like e2-small for testing and low-usage scenarios.

> [!IMPORTANT]
> When selecting a machine type, consider your application's CPU, memory, and storage requirements to optimize costs and performance.

### Memory Optimization
GCP provides machine types optimized for memory-intensive workloads:
- Maximize memory allocation for applications requiring large datasets or in-memory processing.
- Example: Use memory-optimized instances for databases or caching systems.

### Boot Disk
The boot disk is the primary persistent storage attached to the VM:
- **Standard Persistent Disk**: Balanced performance and cost.
- **Balanced Persistent Disk**: Balanced option between performance and cost.
- **SSD Persistent Disk**: High-performance for I/O-intensive applications.
- **Extreme SSD**: Ultra-high performance for demanding workloads.

Encryption is applied automatically by Google Cloud.

> [!NOTE]
> For testing environments, you can use smaller, cheaper disk options and enable deletion protection to prevent accidental data loss.

### Service Accounts
Service accounts define the identity and permissions for VMs in GCP:
- **Default Compute Engine Service Account**: Provides basic access for common operations.
- **Custom Service Accounts**: Allow fine-grained access control based on IAM roles.
- Options include:
  - Full access to all Google Cloud services.
  - Selective access to specific APIs (e.g., read-only or customized permissions).

When setting up service accounts, consider the principle of least privilege.

### Networking
Networking options control how the VM communicates within and outside GCP:
- **Network**: VPC network selection (default or custom).
- **Network Tags**: Used for firewall rules and routing.
- **Network Interfaces**: Support for multiple network interfaces if needed.
- **Subnetwork**: VPC subnet assignment (auto or custom).
- **External/External IP**: Public IP assignment for internet access.

**Internal IP Configuration**:
- Automatic or custom ephemeral/static IPs.
- Reserve static IP to retain the same address across VM recreations.

**External IP Configuration**:
- Assign ephemeral or reserved public IPs.
- Without external IP, the VM cannot access the internet directly.

### Security Options
Enhance VM security through various settings:
- **Shielded VM Essential Features**: Secure boot, integrity monitoring, virtual trusted platform module (vTPM).
- Additional security includes encryption and monitoring.

Deletion protection prevents accidental VM deletion; remove it explicitly before deleting the VM.

### Reservations
Reservations guarantee capacity for specific machine types and zones:
- Reserve CPU and memory resources in advance.
- Useful for production workloads requiring consistent capacity.
- Reserves resources for future scaling needs.

### Spot Instances
Cost-effective preemptible VMs:
- Up to 60% cheaper than regular VMs.
- May be terminated by Google Cloud with 30-second notice.
- Suitable for fault-tolerant, batch processing workloads.
- Use automation scripts to handle preemptions and restart elsewhere if needed.

### Host Maintenance
Options for handling host-level maintenance events:
- **Migrate**: VM automatically migrates to a different host (minimal downtime).
- **Terminate**: VM shuts down during maintenance (higher downtime).

Choose based on application availability requirements.

## Lab Demonstration

> [!NOTE]
> This lab follows the GCP Console process described in the transcript for creating a VM. Assuming a GCP project is set up.

### Step-by-Step VM Creation

1. **Navigate to VM Instances Page**:
   - Go to GCP Console → Compute Engine → VM instances.
   - Click "Create instance".

2. **Basic Configuration**:
   - **Name**: Enter a unique name (e.g., "test-vm").
   - **Region and Zone**: Select region (e.g., Mumbai for lower latency in India) and zone.

3. **Machine Configuration**:
   - **Series**: Choose series (e.g., E2 for general purpose).
   - **Machine Type**: Select based on needs (e.g., e2-micro for small workloads).
   - For memory optimization: Use memory-optimized series if needed.

4. **Boot Disk**:
   - Choose disk type (Balanced for most cases).
   - Enable deletion on VM deletion if for testing.

5. **Identity and API Access**:
   - **Service Account**: Select default or custom.
   - **Access Scopes**: Choose Full or Selective API access.

6. **Networking**:
   - **Network**: Use default or custom VPC.
   - **External IP**: Assign if internet access needed, or None for internal-only.
   - Custom external IP if reserving.

7. **Security**:
   - Enable Shielded VM options if required.
   - Enable Deletion protection.

8. **Advanced Options**:
   - **Reservations**: Enable if reserving resources.
   - **Spot Instance**: Select "Spot" for cost savings (preemptible VM).
   - **Host Maintenance**: Choose Migrate or Terminate.

9. **Create VM**:
   - Click "Create".
   - VM will show internal and external IP addresses once created.

```bash
# Example: SSH into VM (if external IP assigned)
gcloud compute ssh --project [PROJECT_ID] --zone [ZONE] [VM_NAME]

# Example: Check VM status
gcloud compute instances list --filter="name=test-vm"
```

> [!WARNING]
> Spot instances may be terminated at any time. Implement restart logic or use for stateless workloads only.

## Summary

### Key Takeaways
```diff
+ VM Creation Basics: Select appropriate machine type, region, and storage for your workload costs and performance.
+ Networking Essentials: Internal IPs for VPC communication, external IPs for internet access.
+ Service Accounts: Use principle of least privilege to control API access.
+ Spot Instances: Cheaper but preemptible; ideal for batch jobs and fault-tolerant apps.
+ Security First: Enable shielded VM features and deletion protection.
- Avoid Over-Provisioning: Don't allocate more resources than needed to optimize costs.
- Overlook Regional Pricing: Different regions have varying costs; choose wisely.
+ Anticipate Evictions: For spot instances, have restart scripts ready.
```

### Quick Reference
- **Create VM Command (gcloud)**:
  ```bash
  gcloud compute instances create test-vm \
    --project [PROJECT_ID] \
    --zone us-central1-a \
    --machine-type e2-micro \
    --network-tier PREMIUM \
    --image-family ubuntu-2004-lts \
    --image-project ubuntu-os-cloud \
    --boot-disk-size 10GB \
    --boot-disk-type pd-standard
  ```
- **Machine Types**: e2-standard-2 (balanced), e2-highmem-2 (memory), e2-highcpu-2 (CPU).
- **Spot Instance Flag**: `--preemptible` in gcloud commands.

### Expert Insight

**Real-world Application**:
- Use spot instances for CI/CD pipelines, data processing, or ML training to reduce costs.
- Implement auto-scaling groups with reserved instances for production workloads ensuring high availability.

**Expert Path**:
- Master GCP monitoring and logging to track VM performance and costs.
- Learn Infrastructure as Code (IaC) with Terraform or Deployment Manager for reproducible VM deployments.
- Study GCP networking deeply: VPC peering, load balancers, and security policies for complex architectures.

**Common Pitfalls**:
- Forgetting to set up firewall rules, leading to insecure VMs.
- Not budgeting for spot instance evictions; always have failover mechanisms.
- Over-relying on external IPs for all VMs; use Cloud NAT for outbound internet access in private subnets.

</details>