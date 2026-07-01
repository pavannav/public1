# Session 002: How to Create Reservation in Compute Engine

<details open>
<summary><b>Session 002 (Claude)</b></summary>

## Table of Contents
1. [Overview](#overview)
2. [Key Concepts](#key-concepts)
   - [What are Reservations?](#what-are-reservations)
   - [Reservation Types](#reservation-types)
   - [Zone vs Regional Reservations](#zone-vs-regional-reservations)
   - [Dedicated vs Shared Reservations](#dedicated-vs-shared-reservations)
   - [Automatic vs Specific Assignment](#automatic-vs-specific-assignment)
3. [Lab Demo: Creating a VM Reservation](#lab-demo)
4. [Summary](#summary)

## Overview
This session demonstrates how to create reservations in Google Compute Engine to guarantee resource availability for future use. Reservations ensure that specific VM configurations (CPU, memory) are always available in your chosen zone, preventing "out of quota" errors when creating VMs during peak demand.

## Key Concepts

### What are Reservations?
Reservations allow you to reserve Compute Engine resources (vCPUs and memory) in advance:

- **Purpose**: Guarantee resource availability for future VM deployments
- **Use Case**: When specific zones run out of capacity
- **Benefit**: Prevents deployment failures due to resource unavailability

> [!IMPORTANT]
> Without reservations, you might see errors like "Quota exceeded" or "No available resources" when trying to create VMs in busy zones.

### Reservation Scope

#### Local Reservations
- Specific to a single project
- Cannot be shared with other projects
- More secure and isolated

#### Shared Reservations
- Can be shared across multiple projects
- Useful for organizations with multiple projects
- Requires explicit project selection for sharing

### Zone vs Regional Reservations

**Zone Reservations**:
- Resources reserved in a specific zone
- More precise control over resource location
- Used in this training (Mumbai South B zone selected)

### Automatic vs Specific Assignment

#### Automatic Assignment
- VMs matching the reserved configuration automatically use the reservation
- No manual specification needed
- Reservation is consumed when matching VM is created

#### Specific Assignment
- Must explicitly specify reservation name during VM creation
- Provides more control over which VMs use reservations
- Useful when you want some VMs to use on-demand resources

### Machine Configuration Matching
For a VM to use a reservation, it must match exactly:
- Machine type (e.g., n2-medium)
- CPU count
- Memory size
- Optionally: Local SSD configuration

## Lab Demo

### Creating a Reservation

#### Step 1: Navigate to Reservations
```
GCP Console → Compute Engine → Committed use discounts → Reservations
```

#### Step 2: Create New Reservation
```
Name: test-reservation
Description: Reservation for future use
Region: Asia South 1 (Mumbai)
Zone: Asia South 1-B (or specific zone)
```

#### Step 3: Configure Reservation Scope
```
Scope Options:
- Local: Project-specific reservation
- Shared: Share with other projects (requires project selection)
```

#### Step 4: Configure Assignment Type
```
Assignment Options:
1. Automatic: VMs with matching config auto-assign
2. Specific: Must specify reservation name during VM creation
3. Don't use: Reserve but don't allow auto-assignment
```

#### Step 5: Select Machine Configuration
```
Machine Type: n2-medium
vCPUs: 2
Memory: 4 GB
Local SSD: Optional (note: data lost on restart)
```

#### Step 6: Create Reservation
- Review configuration
- Click "Create"
- Reservation status shows "Unused" initially

### Using the Reservation

#### Method 1: Automatic Assignment
1. Create a VM with exact matching configuration
2. Select the zone where reservation exists
3. VM automatically consumes the reservation
4. Check reservation usage in the Reservations console

#### Method 2: Specific Assignment
1. Create VM → Advanced Options → Management
2. Select "Specific reservation"
3. Enter reservation name: `test-reservation`
4. VM creation will fail if configuration doesn't match

### Verification Steps

1. **Check Reservation Usage**:
   - Navigate to Reservations
   - Verify "1 machine is already using this"
   - Confirm resource allocation

2. **Test Configuration Mismatch**:
   - Try creating VM with different machine type (e.g., n2-standard-2)
   - Observe error: "No available resources for specified reservation"
   - Confirms exact matching requirement

## Important Configuration Details

### What Gets Reserved
- vCPU count
- Memory amount
- Machine type family

### What Doesn't Transfer
- Local SSD data (lost on VM restart)
- Boot disk data
- Network configurations

### Billing Considerations
- Reservations are billed whether used or not
- Provides cost predictability for resource planning

## Summary

### Key Takeaways
```diff
+ Reservations guarantee resource availability in specific zones
+ Must match exact machine configuration to consume reservation
+ Two scope options: Local (project-specific) and Shared (cross-project)
+ Automatic assignment simplifies usage; specific assignment provides control
+ Useful for ensuring capacity during peak demand or for critical workloads
+ Local SSD attached to reserved VMs loses data on restart
```

### Quick Reference Commands
```bash
# Create a reservation using gcloud
gcloud compute reservations create RESERVATION_NAME \
    --machine-type=MACHINE_TYPE \
    --zone=ZONE \
    --vm-count=COUNT

# Create VM with specific reservation
gcloud compute instances create INSTANCE_NAME \
    --zone=ZONE \
    --reservation-affinity=specific \
    --reservation=RESERVATION_NAME
```

### Expert Insights

**Real-world Application**:
- Reserve resources for production workloads that can't tolerate delays
- Plan for seasonal spikes in demand
- Ensure capacity for disaster recovery scenarios

**Expert Path**:
- Combine reservations with committed use discounts for maximum savings
- Implement reservation monitoring and alerts
- Use Infrastructure as Code to manage reservations

**Common Pitfalls**:
- Forgetting that configurations must match exactly
- Not accounting for reservation costs when unused
- Assuming regional reservations (session covers zone-specific only)

</details>