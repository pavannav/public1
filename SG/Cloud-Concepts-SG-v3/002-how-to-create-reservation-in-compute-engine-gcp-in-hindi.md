# Session 002: How to Create Reservation in Compute Engine GCP in Hindi

<details open>
<summary><b>Session 002: How to Create Reservation in Compute Engine GCP in Hindi (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Understanding Reservations](#understanding-reservations)
- [Creating a Reservation](#creating-a-reservation)
- [Local vs Shared Reservations](#local-vs-shared-reservations)
- [Reservation Usage Options](#reservation-usage-options)
- [Lab: Creating and Using Reservations](#lab-creating-and-using-reservations)
- [Reservation Requirements and Limitations](#reservation-requirements-and-limitations)
- [Summary](#summary)

## Overview

This session demonstrates how to create and manage reservations in Google Cloud Compute Engine for future VM deployments. Reservations are particularly useful during resource scarcity periods when regular quotas are exhausted in specific zones or regions.

The tutorial covers the complete workflow from creating a reservation to applying it during VM creation, including configuration options and important constraints.

## Understanding Reservations

### What is a Compute Engine Reservation?

A reservation in Google Compute Engine is a mechanism to pre-allocate virtual machine resources for future use. This is especially valuable when:

- **Resource Scarcity**: When your zone/region quota is exhausted for CPU/memory resources
- **Peak Demand Planning**: Preparing for anticipated spikes in compute requirements
- **Guaranteed Capacity**: Ensuring reserved capacity is available when needed

> [!IMPORTANT]
> Reservations help overcome quota limitations by dedicating specific compute resources that are guaranteed to be available for your use, even during high-demand periods.

### Key Benefits

- **Quota Bypass**: Deploy VMs even when regional quotas are reached
- **Cost Optimization**: Reserved capacity can be more cost-effective for consistent workloads
- **Capacity Assurance**: Guaranteed resource availability for critical applications

## Creating a Reservation

### Accessing Compute Engine

**Navigation Path:**
1. Open Google Cloud Console
2. Navigate to **Compute Engine**
3. Click on **VM Instances**
4. Click on **Reservations** under the "Compute" section

### Basic Configuration Steps

1. **Name the Reservation**
   - Enter a descriptive name (e.g., "test-reservation")
   - Add optional description explaining purpose

2. **Region Selection**
   - Choose the region where you need reserved resources
   - Example: Mumbai region for this demonstration

3. **Zone Selection**
   - Select the specific zone within the region
   - Note: Reservations are zone-specific

## Local vs Shared Reservations

### Local Reservation
- **Scope**: Specific to your current project only
- **Sharing**: Cannot be used by other projects
- **Control**: Complete ownership and control
- **Use Case**: When you want exclusive access to reserved resources

### Shared Reservation
- **Scope**: Can be shared across multiple projects
- **Sharing**: Allows other projects in your organization to utilize the reservation
- **Management**: Requires additional project selection during configuration
- **Use Case**: Cross-project resource allocation and sharing

```diff
+ Recommended Default: Start with Local reservations for full control
- Avoid Shared reservations unless you have specific cross-project requirements
```

## Reservation Usage Options

### Automatic Usage
- **Behavior**: VM instances automatically consume matching reservations
- **Requirements**: VM configuration must exactly match reservation configuration
- **Configuration**: Reservation uses machine type specifications (e.g., n2-standard-2)

### Specify Reservation
- **Behavior**: Manually assign reservation during VM creation
- **Requirements**: Must explicitly select reservation by name
- **Configuration**: Allows more control over reservation assignment

## Lab: Creating and Using Reservations

### Demo 1: Creating a Reservation

**Steps to Create Reservation:**

1. Navigate to Compute Engine → Reservations
2. Click "Create Reservation"
3. Configure basic settings:
   ```bash
   Name: test-reservation
   Description: Reservation for future VM usage
   Region: asia-south1 (Mumbai)
   Zone: asia-south1-b
   ```
4. Choose reservation scope (Local/Shared)
5. Set usage option: Specify Specific Reservation
6. Configure machine type:
   - Machine Type: n2-standard-2
   - Quantity: 1 VM
7. Optional: Configure local SSD (not applicable for all machine types)
8. Click "Create"

> [!NOTE]
> Local SSD can only be attached to specific machine types. Attempting to add local SSD to incompatible types (like n2-standard-2) will fail.

### Demo 2: Creating VM with Reservation

**VM Creation Process:**

1. Navigate to Compute Engine → VM Instances → Create Instance
2. Configure basic VM settings:
   - Name: vm-with-reservation
   - Region: asia-south1
   - Zone: asia-south1-b
3. Select machine type: n2-standard-2 (must match reservation exactly)
4. Access "Advanced options" → "Management" tab
5. Select "Use specific reservation":
   - Choose "test-reservation" from dropdown
6. Complete VM creation

### Demo 3: Verification and Testing

**Reservation Status Check:**
- View reservation details to see usage status
- Check "In use by" to see consumed instances
- Monitor remaining capacity

**Testing Scenarios:**

1. **Exact Match Configuration**: VM creation succeeds ✓
2. **Different Machine Type**: VM creation fails with "No available resources" ✗

```diff
! Critical: Matching machine configuration is mandatory for reservation usage
! Attempting to use reservations with different machine types results in resource allocation failure
```

## Reservation Requirements and Limitations

### Matching Criteria
- **Machine Type**: Exact match required (e.g., n2-standard-2 = n2-standard-2)
- **Zone**: Same zone specification mandatory
- **Count**: Limited to reservation quantity

### Constraints
- **Local SSD Limitations**: Not supported on all machine types
- **Data Persistence Warning**: Local SSD data is lost on VM restart/stop
- **Resource Specificity**: Reservations cannot be used across different configurations

> [!WARNING]
> Local SSD data is ephemeral and will be lost when the VM is restarted or stopped. Use persistent disks for data persistence requirements.

### Usage Best Practices
```diff
+ Match exact machine configurations for reliable reservation usage
+ Monitor reservation consumption status regularly
+ Plan reservations based on predictable workload patterns
- Do not assume reservations work across different machine types
- Avoid over-provisioning reservations to minimize waste
```

## Summary

### Key Takeaways
```diff
+ Reservations guarantee capacity during resource scarcity
+ Exact machine type matching required for usage
+ Local reservations provide exclusive project access
+ Local SSDs are ephemeral and data-loss on restart
+ Reservations bypass regional quota limitations
! Automatic assignment requires exact configuration match
```

### Quick Reference

**Reservation Navigation:**
- Console: Compute Engine → Reservations
- CLI: `gcloud compute reservations create [NAME]`

**VM with Reservation:**
- Advanced Options → Management → Use specific reservation

**Common Machine Types:**
- n2-standard-2: 2 vCPU, 4GB RAM
- n2-highmem-2: 2 vCPU, 16GB RAM

### Expert Insight

**Real-world Application:**
- **Auto-scaling Clusters**: Reserve capacity for burst-auto scaling scenarios
- **Seasonal Workloads**: Plan reservations for predictable peak periods
- **Multi-project Organizations**: Use shared reservations for org-wide capacity planning

**Expert Path:**
- Master reservation automation using Cloud Deployment Manager or Terraform
- Implement monitoring dashboards for reservation utilization
- Design reservation strategies for complex multi-zone deployments

**Common Pitfalls:**
```diff
- Configuration mismatch causing deployment failures
- Assuming reservations work across different machine families
- Forgetting local SSD data loss implications
- Underestimating regional quota vs reservation usage
- Not monitoring reservation expiration and renewal
```

</details>