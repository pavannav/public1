# Session 002: How to Create Reservation in Compute Engine GCP

## Table of Contents
- [Introduction to Reservations](#introduction-to-reservations)
- [Navigating to Compute Engine](#navigating-to-compute-engine)
- [Creating a Reservation](#creating-a-reservation)
- [Reservation Options: Local vs Shared](#reservation-options-local-vs-shared)
- [Specific vs Automatic Reservation Usage](#specific-vs-automatic-reservation-usage)
- [Attaching SSD to Reservation](#attaching-ssd-to-reservation)
- [Creating a VM Using Reservation](#creating-a-vm-using-reservation)
- [Limitations and Matching Configurations](#limitations-and-matching-configurations)
- [Summary](#summary)

## Introduction to Reservations

### Overview
In Google Cloud Platform (GCP), a reservation allows you to reserve specific virtual machine (VM) resources like CPU and memory for future use. This is particularly useful in scenarios where your zone's available resources might be exhausted, preventing VM creation during peak times.

### Key Concepts/Deep Dive
- **Purpose**: Reservations ensure availability of compute resources, acting like a booking system for VMs.
- **Common Use Case**: If a spike in demand causes resource shortages in your zone, a reservation guarantees you can create VMs when needed.

## Navigating to Compute Engine

### Overview
To create a reservation, start by accessing the Compute Engine section in the GCP console.

### Lab Demo: Accessing Compute Engine
1. Go to the GCP console.
2. Navigate to "Compute Engine".
3. Click on "Discounts" in the left sidebar.
4. Click on "Reservation" to proceed.

## Creating a Reservation

### Overview
The reservation creation process involves providing basic details like name, description, region, and zone.

### Key Concepts/Deep Dive
- **Name**: A unique identifier for the reservation (e.g., "test-reservation").
- **Description**: Optional notes about the reservation's purpose.
- **Region and Zone**: Select the specific Google Cloud region and zone where resources are reserved.

### Lab Demo: Basic Reservation Setup
1. Enter a name for the reservation (e.g., "test").
2. Add a description like: "Reservation for future use during spikes."
3. Choose a region (e.g., Mumbai).
4. Choose a zone (e.g., asia-south1-b).

## Reservation Options: Local vs Shared

### Overview
Reservations can be local (restricted to the current project) or shared (available across multiple projects).

### Key Concepts/Deep Dive
- **Local Reservation**: Tied to the specific project; cannot be used by other projects.
- **Shared Reservation**: Can be shared with other projects by adding them explicitly.

### Lab Demo: Setting Reservation Scope
1. Choose between "Local" or "Shared".
2. For shared reservations, click "Add projects" to select additional projects.
3. In this example, select "Local" for project-specific use.

## Specific vs Automatic Reservation Usage

### Overview
When creating VMs, reservations can be used automatically (matching exact configurations) or specifically (by naming the reservation).

### Key Concepts/Deep Dive
- **Automatic**: If a VM's configuration matches the reservation, it will be used without manual selection.
- **Specific**: Requires explicit selection of the reservation name during VM creation.

### Lab Demo: Reservation Usage Options
1. On the reservation creation page, select "Use reservation" and choose between:
   - "Automatic": Resources are allocated to matching VMs automatically.
   - "Specific": Specify the reservation name when creating VMs.
2. For "Specific", enter the number of VMs (e.g., 1).
3. Choose machine type (e.g., n2-standard-2, which has 2 CPUs and 4GB memory).

## Attaching SSD to Reservation

### Overview
You can attach local SSDs directly to the VM as part of the reservation configuration.

### Key Concepts/Deep Dive
- **Local SSD**: High-performance storage attached directly to the VM.
- **Caution**: Data on local SSD is lost on VM restart or stop. Not available for all machine types (e.g., not compatible with n1-standard-1).

### Lab Demo: Adding SSD
1. In the reservation settings, check for SSD attachment options.
   ⚠ **Warning**: If local SSD is attached, all data will be lost on restart.
2. Specify the number of SSDs needed (e.g., 1 or more).
3. Note: Availability depends on the selected machine type.

## Creating a VM Using Reservation

### Overview
Once the reservation is created, you can create VMs that utilize it by matching configurations.

### Lab Demo: VM Creation Process
1. After creating the reservation (e.g., "test-reservation"), go to VM Instances in Compute Engine.
2. Click "Create Instance".
3. Enter VM name and choose region/zone matching the reservation (e.g., asia-south1-b).
4. Select the same machine type (e.g., n2-standard-2).
5. Under "Management" in Advanced options:
   - Uncheck "Use committed use discounts" if conflicting.
   - Choose "Select specific reservation".
   - Enter the reservation name (e.g., "test-reservation") - it auto-populates.
6. Confirm the VM configuration matches the reservation to ensure allocation.

> [!NOTE]  
> The reservation remains unused if the VM configuration doesn't match exactly.

### Key Concepts/Deep Dive
- **Matching Criteria**: CPU, memory, and other configs must be identical for automatic allocation.
- **Usage Tracking**: Check reservation details to see if it's "In use" or "1 machine already using".

## Limitations and Matching Configurations

### Overview
Reservations only activate for VMs with identical configurations; mismatched settings prevent allocation.

### Lab Demo: Testing Limitations
1. Attempt to create a VM with a different machine type (e.g., n2-standard-1 instead of n2-standard-2).
   - Result: Error "No available resources" even if the reservation is specified.
2. Create a VM with matching config (e.g., exact same machine type) under advanced options > management > select specific reservation.
   - Success: VM creates successfully, and reservation shows "In use".
3. Verify in reservation details: Shows "1 machine is already using" the reservation.

> [!IMPORTANT]  
> Configurations must match on both ends (reservation and VM) for the reservation to be applied, even when explicitly selected.

## Summary

### Key Takeaways
```diff
+ Reservations ensure resource availability during demand spikes.
+ Automatic allocation works only with exact matching configs.
+ Local SSD attachment is high-performance but data is ephemeral.
+ Shared reservations allow cross-project resource sharing.
- Mismatched VM configurations will prevent reservation usage.
! Always verify zone and machine type alignment before creation.
```

### Expert Insight

#### Real-world Application
In production, use reservations for critical workloads in high-demand zones to avoid outages during traffic surges. For example, e-commerce sites can reserve VMs for Black Friday events to guarantee scaling.

#### Expert Path
- Dive deep into GCP cost optimization by comparing reservations vs. committed use discounts.
- Automate reservation creation using gcloud CLI commands for repeatability.
- Monitor usage via GCP APIs to trigger alerts when reservations approach depletion.

#### Common Pitfalls
- **Configuration Mismatch**: Done here - always double-check CPU/memory specs; otherwise, resources remain idle.
- **Attaching SSD**: Data loss on restart/shutdown; regulate by choosing appropriate storage solutions.
- **Sharing Issues**: Shared reservations require careful project management to avoid misuse.
- **Quota Exhaustion**: Reservations don't bypass zone quotas; plan for overall limits.

**Lesser Known Things**: Reservations can include GPUs and TPUs for specialized workloads, and they support minimum commitment periods for better billing. Automatic reservations can be overridden per VM if needed, providing flexibility in mixed environments.

> [!NOTE]  
> Corrections made: Corrected "इंजन" to "Engine", "क्रिएट" to "create", "मशीन" to "machine", "रिजन" to "region", "जेम" likely "zone", "ओप्शन" to "option", technical terms standardized (e.g., "वीएम" to "VM", "एसएसडी" to "SSD"). No major misspellings like "htp/http" found.
