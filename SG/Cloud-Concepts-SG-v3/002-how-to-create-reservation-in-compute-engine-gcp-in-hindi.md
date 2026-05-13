# Session 002: How to Create Reservation in Compute Engine GCP

<details open>
<summary><b>How to Create Reservation in Compute Engine GCP (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
  - [What is a Compute Engine Reservation?](#what-is-a-compute-engine-reservation)
  - [Why Use Reservations?](#why-use-reservations)
  - [Types of Reservations](#types-of-reservations)
  - [Reservation Usage Options](#reservation-usage-options)
- [Lab Demo: Creating a Reservation](#lab-demo-creating-a-reservation)
- [Lab Demo: Using a Reservation](#lab-demo-using-a-reservation)
- [Summary](#summary)

## Overview

This session covers the creation and management of VM instance reservations in Google Cloud Compute Engine (GCE). Reservations allow you to reserve specific compute capacity in advance for guaranteed access to VM resources, which is particularly useful during resource scarcity or quota limitations. The tutorial demonstrates both creating reservations and applying them when launching new VM instances through the GCP Console.

## Key Concepts

### What is a Compute Engine Reservation?

A Compute Engine reservation is a commitment to reserve a specific amount of virtual machine (VM) capacity in a Google Cloud region and zone for future use. Unlike preemptible VMs or on-demand instances, reservations guarantee resource availability even during peak demand periods.

#### Key Characteristics:
- **Capacity Commitment**: Reserves CPU and memory resources in advance
- **Zone-Locked**: Resources are reserved in specific zones within a region
- **Time-Independent**: Reservations hold capacity but don't incur charges until used
- **Resource Allocation**: Can include attached Local SSD storage

### Why Use Reservations?

```diff
+ Advantages:
+ Guaranteed resource availability during resource scarcity
+ Protection against quota exhaustion in busy zones
+ No upfront costs - charges only apply when instances are created
+ Ideal for handling sudden resource spikes
+ Enables proactive capacity planning

- Considerations:
- Requires matching exact specifications when creating VMs
- Zone-specific limitations
- Additional complexity in resource management
```

### Types of Reservations

Google Cloud offers two types of reservations based on sharing scope:

#### 1. Local Reservations
Local reservations are project-specific and cannot be shared with other projects in your organization.

**Use Cases:**
- Dedicated capacity for a single project
- Compliance requirements for resource isolation
- Cost allocation within specific teams

#### 2. Shared Reservations
Shared reservations can be shared across multiple projects within the same organization.

**Use Cases:**
- Multi-project deployments
- Shared infrastructure needs
- Cross-team resource pooling

> [!NOTE]
> Reservations can only be shared with projects within the same Google Cloud organization. External project sharing is not supported.

### Reservation Usage Options

When creating a reservation, you can specify how it will be applied to VM instances:

#### 1. Automatic Reservation
VMs matching the reservation specifications are automatically assigned to use the reserved capacity.

**Behavior:**
- No manual intervention required
- Instances with matching configurations are automatically allocated
- Eliminates user error in reservation assignment

#### 2. Specific Reservation (Targeted)
VM instances must explicitly specify which reservation to use during creation.

**Behavior:**
- Requires manual selection during VM creation
- Allows fine-grained control over resource allocation
- Prevents accidental over-consumption

> [!IMPORTANT]
> Specific reservations require exact matching criteria to be applied successfully. Mismatched configurations will fail to utilize the reservation.

## Lab Demo: Creating a Reservation

### Prerequisites
- Active Google Cloud Project
- Compute Engine API enabled
- Appropriate IAM permissions for reservation management

### Step-by-Step Guide

1. **Navigate to Compute Engine Console**
   ```
   GCP Console → Navigation Menu → Compute Engine → Reservations
   ```

2. **Access Reservations Management**
   ```
   Compute Engine Dashboard → Discounts → Reservations → Create Reservation
   ```

3. **Configure Basic Settings**
   - **Name**: Enter a descriptive name (e.g., "test-reservation")
   - **Description**: Provide purpose/context (e.g., "Reservation for future use during resource spikes")
   - **Region**: Select target region (e.g., asia-south1 - Mumbai)
   - **Zone**: Choose specific zone (e.g., asia-south1-b)

4. **Choose Reservation Type**
   - **Local**: For project-specific reservations
   - **Shared**: For multi-project sharing
     - If Shared: Add additional projects as needed

5. **Configure Usage Options**
   - **Automatic**: Recommended for seamless integration
   - **Specific Reservation**: For targeted control

6. **Specify VM Configuration**
   - **Number of VMs**: Enter quantity needed (default: 1)
   - **Machine Type**: Select exact specification (e.g., n2-standard-2)
   - **Local SSD**: Specify if needed (not applicable to n2-standard-2)

7. **Create the Reservation**
   ```
   Click "Create" button
   Monitor creation status in Reservations console
   ```

8. **Verify Reservation Creation**
   - Check reservation status: Active
   - Verify resource allocation: Total machines reserved vs. used
   - Confirm specifications match requirements

## Lab Demo: Using a Reservation

### Prerequisites
- Existing reservation in target zone
- Matching VM configuration requirements

### Step-by-Step Guide

1. **Create a New VM Instance**
   ```
   Compute Engine → VM instances → Create Instance
   ```

2. **Configure Basic VM Settings**
   - **Name**: Unique instance identifier
   - **Region/Zone**: Must match reservation zone (e.g., asia-south1/as-south1-b)
   - **Machine Type**: Must exactly match reservation specs (e.g., n2-standard-2)

3. **Access Advanced Options**
   ```
   VM Creation Wizard → Advanced options → Management tab
   ```

4. **Select Reservation Usage**
   - **Automatic**: Use reservation automatically
   - **Don't use**: Bypasses reservation entirely
   - **Select specific reservation**: Choose from dropdown list

5. **Specify Reservation (if using Specific mode)**
   - Select reservation from project list
   - Verify name matches created reservation (e.g., "test-reservation")

6. **Create the VM**
   ```
   Click "Create" button
   Monitor VM creation process
   ```

7. **Verify Reservation Utilization**
   - Check VM details: Reservation status should show "Using"
   - Review reservation dashboard: "1 machine is already using"
   - Confirm resource allocation update

### Important Requirements for Reservation Usage

```diff
! Critical Matching Criteria:
! - Zone must be identical to reservation zone
! - Machine type must exactly match reservation configuration
! - Cannot mix reservation types during VM creation
! - Resource availability depends on reservation capacity vs. usage
```

## Summary

### Key Takeaways

```diff
+ Reservations provide guaranteed compute capacity in Google Cloud
+ Automatic reservations enable seamless resource allocation
+ Local reservations offer project isolation, shared enable cross-project usage
+ Mismatched configurations prevent reservation utilization
+ Reservations are zone-specific and machine-type specific
- Resource spikes without reservations may cause quota exhaustion
- Different machine types cannot utilize existing reservations
- Local SSD requirements may affect reservation compatibility
```

### Quick Reference

**Create Reservation via Console:**
```bash
# Navigation path
Compute Engine → Discounts → Reservations → Create Reservation

# Example configuration
Name: test-reservation
Region: asia-south1
Zone: asia-south1-b
Type: Local
Usage: Automatic
VM Config: n2-standard-2
Count: 1
```

**Apply Reservation to VM:**
```bash
# VM Creation with reservation
Advanced Options → Management → Select specific reservation: [reservation-name]
```

**Check Reservation Status:**
```bash
# Console navigation
Compute Engine → Reservations → [reservation-name] → Usage details
```

### Expert Insights

**Real-world Application:**
In production environments, reservations are critical for:
- Handling seasonal traffic spikes (e.g., e-commerce Black Friday events)
- Ensuring availability during planned maintenance windows
- Supporting mission-critical applications requiring guaranteed resources
- Managing hybrid workloads combining on-demand and reserved capacity

**Expert Path to Mastery:**
1. Design reservation strategies based on historical usage patterns
2. Implement monitoring dashboards tracking reservation utilization
3. Use Google Cloud Monitoring to set alerts on reservation usage thresholds
4. Master the Google Cloud Reserve API for programmatic reservation management
5. Integrate reservations with Infrastructure as Code (IaC) solutions like Terraform

**Common Pitfalls:**
- Creating reservations in the wrong zone incompatible with existing architecture
- Using different machine types than reserved capacity, causing utilization failures
- Forgetting Local SSD data loss implications during VM restarts
- Over-reserving capacity leading to wasted committed resources
- Not configuring appropriate IAM permissions for shared reservations
- Assuming reservations apply across regions or zones automatically

</details>