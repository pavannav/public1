# Session 002: How to Create Reservation in Compute Engine GCP

<details open>
<summary><b>002-How-to-Create-Reservation-in-Compute-Engine-GCP-in-Hindi (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
- [Lab Demo: Creating a Reservation](#lab-demo-creating-a-reservation)
- [Lab Demo: Using Reserved Capacity in VM Creation](#lab-demo-using-reserved-capacity-in-vm-creation)
- [Summary](#summary)

## Overview
This session covers creating and managing Compute Engine reservations in Google Cloud Platform (GCP). Reservations allow you to pre-book compute capacity for critical workloads, ensuring availability during resource shortages or sudden spikes in demand. The tutorial demonstrates the complete workflow from reservation creation to consumption via VM instances.

> [!IMPORTANT]
> Reservations are particularly valuable in scenarios where your region/zone runs out of CPU or memory quotas, preventing new VM creation during critical business needs.

## Key Concepts and Deep Dive

### What is a Compute Engine Reservation?
Compute Engine reservations provide guaranteed access to compute resources in a specific region and zone. Unlike spot instances or standard on-demand VMs, reservations:

- **Reserve capacity upfront**: Block specific compute resources (CPU, memory) for your future use
- **Guarantee availability**: Ensure resources are available even during high-demand periods or regional outages
- **Cost-effective for consistent needs**: Ideal for production workloads with predictable resource requirements
- **Flexible sharing**: Can be scoped to a single project or shared across multiple projects

### Reservation Types

#### Local Reservations
- **Scope**: Specific to the project where created
- **Use case**: Dedicated resource allocation within your project
- **Access**: Cannot be used by other projects

```bash
# Local reservation restricts usage to owning project only
Reservation Scope: Project-Specific
```

#### Shared Reservations
- **Scope**: Can be shared with specified projects
- **Use case**: Cross-project resource sharing within an organization
- **Access**: Allows designated projects to consume reserved capacity

```bash
# Shared reservation enables cross-project usage
Project Sharing Enabled: Yes (with explicit project selection)
```

### Reservation Usage Modes

#### Automatic Reservation Usage
- **Behavior**: VM instances automatically consume matching reservations
- **Requirements**: VM configuration must match reservation exactly
- **Management**: Zero manual intervention required

```bash
# Automatic reservation assignment
Match Criteria: Exact machine type, zone, and region match required
```

#### Specific Reservation Usage
- **Behavior**: Requires explicit reservation selection by name
- **Requirements**: Specify reservation name during VM creation
- **Management**: Manual selection in VM creation workflow

```bash
# Named reservation selection
Reservation Name: Required for manual assignment
```

### Machine Configuration Considerations

#### Local SSD Attachments
Local SSDs can be included in reservations but carry important data persistence warnings:

> [!WARNING]
> **Data Loss Risk**: Local SSD data is ephemeral and will be destroyed on VM restart/stop operations. This is different from persistent disks which maintain data across VM lifecycle events.

```bash
# Local SSD behavior in reservations
Data Persistence: Ephemeral
Stop/Restart Impact: Complete data loss
```

## Lab Demo: Creating a Reservation

### Prerequisites
- Active GCP project with Compute Engine API enabled
- Appropriate IAM permissions for reservation creation

### Step-by-Step Creation Process

1. **Navigate to Compute Engine Console**
   - Open Google Cloud Console
   - Navigate to Compute Engine section

2. **Access Reservations Menu**
   - Click on "Compute Engine" in the left navigation
   - Select "Discounts" option
   - Click "Reservations" to access the reservation management page

3. **Create New Reservation**
   - Click "Create Reservation" button
   - Configure reservation parameters

4. **Reservation Configuration Details**

```yaml
Reservation Name: test-reservation
Description: Reservation for future VM capacity needs during spikes
Region: asia-south1
Zone: asia-south1-a
Scope: Local (project-specific)
Usage Mode: Specific reservation (named)
Number of VMs: 1
Instance Template: No (direct machine type)
Machine Type: n2-standard-2
Local SSD: None (data persistence warning acknowledged)
```

### Important Configuration Notes
- **Number of VMs**: Specifies how many instances of the machine type are reserved
- **Machine Type Matching**: Only VMs with identical machine type (n2-standard-2) can consume this reservation
- **Zone Specificity**: Reservations are bound to specific zones within regions

## Lab Demo: Using Reserved Capacity in VM Creation

### Scenario: Consuming the Created Reservation

1. **Create VM Instance**
   - In Compute Engine, click "Create Instance"
   - Configure VM with matching specifications:

```yaml
VM Name: test-vm
Region: asia-south1
Zone: asia-south1-a
Machine Type: n2-standard-2 (must match reservation exactly)
Boot Disk: Standard persistent disk
```

2. **Access Reservation Selection**
   - Scroll to "Management" section in VM creation form
   - Under "Reservations", select "Specific reservation"

3. **Select Reservation**
   - Choose "test-reservation" from dropdown
   - System automatically detects the matching configuration

4. **Verification**
   - VM creation completes successfully
   - Reservation shows "1 machine is already using" in reservation details

### Configuration Matching Requirements

```bash
# Strict matching criteria for reservation utilization
Machine Type: Must be identical
Region/Zone: Must match exactly
Local SSD: Must match reservation configuration
Reservation Scope: Must have access permissions
```

### Failure Scenarios

**Common Error: Resource not available due to reservation mismatch**

```bash
Error Message: "No available resources specified reservation"
Cause: Machine type or zone mismatch
Example: Attempting to create n2-standard-4 VM against n2-standard-2 reservation
```

## Summary

### Key Takeaways
```diff
+ Strategic Resource Planning: Reservations ensure capacity availability during peak demand
+ Exact Matching Required: VM configuration must precisely match reservation specifications
+ Cost-Effective Guaranteed Computing: Pre-book resources without continuous costs when unused
+ Flexible Sharing Options: Choose between project-exclusive or organization-wide access
+ Data Persistence Awareness: Understand local SSD ephemeral nature to avoid data loss
- Configuration Mismatch Issues: Different machine types cannot consume reservations, preventing VM creation
- Manual Reservation Selection: Specific mode requires explicit naming in VM creation workflow
```

### Quick Reference

#### Reservation Creation Commands (gcloud)
```bash
# Create a local reservation
gcloud compute reservations create test-reservation \
    --machine-type=n2-standard-2 \
    --vm-count=1 \
    --zone=asia-south1-a

# Create a shared reservation
gcloud compute reservations create shared-reservation \
    --machine-type=n2-standard-2 \
    --vm-count=2 \
    --zone=asia-south1-a \
    --share-setting=projects \
    --share-with="projects/project-id-1,projects/project-id-2"
```

#### VM Creation with Reservation
```bash
# Create VM using specific reservation
gcloud compute instances create test-vm \
    --machine-type=n2-standard-2 \
    --zone=asia-south1-a \
    --reservation=test-reservation
```

#### Key Reservation Properties
- **Local SSD Warning**: Restart/stop destroys all SSD data
- **Zone Bound**: Reservations cannot be used across zones
- **Automatic vs Manual**: Choose based on operational needs

### Expert Insight

#### Real-world Application
Reservations excel in production environments where predictable capacity is critical:
- **Black Friday/Cyber Monday traffic spikes**: Reserve compute capacity months in advance
- **Batch processing workloads**: Ensure capacity for scheduled data processing jobs
- **Disaster recovery scenarios**: Maintain reserved capacity in secondary regions

#### Expert Path
- **Monitor Usage**: Track reservation utilization via Cloud Monitoring dashboards
- **Cost Optimization**: Balance reservation commitments with actual usage patterns
- **CI/CD Integration**: Incorporate reservation deployment in infrastructure-as-code pipelines
- **Reserve Management**: Implement automated reservation lifecycle management with Terraform

#### Common Pitfalls
- **Reservation Configuration Drift**: VM creation fails when machine types don't match exactly
- **Unused Capacity Waste**: Track and optimize reservation usage to avoid paying for unused resources
- **Local SSD Data Loss**: Forgetting ephemeral nature leads to unexpected data loss during maintenance
- **Cross-Zone Usage Errors**: Attempting to use reservations outside their zone boundaries

</details>