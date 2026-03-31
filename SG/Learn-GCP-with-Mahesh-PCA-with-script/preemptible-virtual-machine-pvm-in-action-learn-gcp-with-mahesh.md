# Session 1: Preemptible Virtual Machines (PVM) in Action

## Table of Contents
- [Introduction](#introduction)
- [VM Provisioning and Initial State](#vm-provisioning-and-initial-state)
- [SSH Access and Content Verification](#ssh-access-and-content-verification)
- [Preemption Event and Shutdown](#preemption-event-and-shutdown)
- [Console Verification After Preemption](#console-verification-after-preemption)
- [Restarting the Preemptible VM](#restarting-the-preemptible-vm)
- [Data Persistence on Persistent Disk](#data-persistence-on-persistent-disk)
- [Shutdown Scripts Concept](#shutdown-scripts-concept)
- [Billing Considerations](#billing-considerations)
- [Conclusion](#conclusion)

## Introduction
Preemptible Virtual Machines (PVMs) in Google Cloud Platform (GCP) are a cost-effective option for compute resources that can be interrupted by Google at any time within a 24-hour maximum lifespan. These instances are ideal for non-critical workloads such as batch processing, data analysis, or testing environments where interruptions can be tolerated. The key appeal of PVMs lies in their significantly lower cost compared to regular Compute Engine virtual machines, often at a fraction of the price.

### Overview
PVMs provide up to 80% cost savings compared to standard instances, making them attractive for workloads that are fault-tolerant and can handle sudden termination. Google's Compute Engine may preempt these instances when needed for other higher-priority workloads, but users receive a 30-second warning notification. Despite preemption, the persistent disks and data remain intact, allowing for seamless recovery by restarting the instance.

### Key Concepts/Deep Dive
- **Lifespan**: Maximum 24 hours, though actual duration depends on resource demand and availability.
- **Preemption Notice**: Google sends a preempt signal 30 seconds before termination.
- **Cost Benefits**: Around 60-90% cheaper than standard instances, charged on an hourly basis.
- **Use Cases**:
  - Batch processing jobs
  - Scientific computations
  - Continuous integration/continuous deployment (CI/CD) pipelines
  - Rendering tasks
  - Development and testing environments

> [!NOTE]
> PVMs are not guaranteed to run for the full 24 hours; they may be preempted sooner based on Google's infrastructure needs.

## VM Provisioning and Initial State
The demonstration began with a preemptible VM that was provisioned the previous day. The presenter checked the current time (around 3:49 PM IST on July 2) and noted that the VM had been running for approximately 23 hours and 50 minutes, just under the 24-hour maximum.

### Key Observations
- VM created on July 1 at approximately 4:00 PM.
- No preemption had occurred yet, despite nearing the maximum lifespan.
- Log files showed normal operation without any interruptions.

> [!IMPORTANT]
> Preemption timing is non-deterministic. Google provides no guarantees on when preemption will occur, even if nearing the 24-hour limit.

## SSH Access and Content Verification
The presenter SSH'd into the running preemptible VM to show its current state:
- Directory listing revealed a folder and a text file containing content.
- Small software (likely a gating application or similar) was installed on the VM.

### Shallow Dive
This step demonstrated that the VM was fully functional before preemption. The presence of user data and applications highlighted what would be preserved during and after interruption.

> [!NOTE]
> During the video's pause for 8-9 minutes, the preemption occurred at around 4:12 PM, as evidenced by the subsequent timestamp checks.

## Preemption Event and Shutdown
The VM was preempted approximately 11-12 minutes after setup verification. The shutdown occurred without user intervention, initiated by a system event from Google.

### Detailed Breakdown
- **Preemption Trigger**: System-level event by Google Compute Engine.
- **Shutdown Behavior**: Immediate termination of compute resources (CPU and memory), with 10 GB persistent disk retained.
- **Logs Indication**: Activity logs showed "compute engine preempted" by "system@google.com".

```diff
+ Normal operation maintained for ~23.5 hours
- Preemption initiated without user config or script
! System-level interruption, not user-initiated shutdown
```

> [!NOTE]
> Without a custom shutdown script, the logs showed only the preemption event. Custom scripts could log additional actions during the 30-second grace period.

## Console Verification After Preemption
After preemption, the console displayed:
- A warning message indicating the VM's 24-hour lifespan.
- VM status showed as "stopped" but with disk preservation.
- Logs detailed the shutdown event and preemption timestamp (4:12 PM).

### Key Log Details
- Shutdown event logged with Google system as the principal.
- Activity logs confirmed the preemption under system events.
- No shutdown script was configured in this demonstration.

## Restarting the Preemptible VM
Post-preemption, the VM could be restarted from the GCP console:
- Disk (10 GB boot disk) remained intact.
- Restart took approximately 30 seconds, typical for GCP.
- New instance launched with a fresh billing cycle starting upon restart.

### Process Steps
1. Navigate to Compute Engine > VM instances.
2. Select the stopped preemptible VM.
3. Click "Start" to provision a new instance with the same disk.

> [!IMPORTANT]
> Restarting a preemptible VM creates a new instance with a new 24-hour lifespan, not a continuation of the previous one.

## Data Persistence on Persistent Disk
After restarting the VM and SSH access:
- Original folder and text file remained intact.
- Previously installed software (e.g., gating application) persisted across preemption.
- Demonstrates that only compute resources (CPU/memory) are reclaimed, not storage.

### Conceptual Explanation
```diff
+ Data on persistent disks survives preemption
- In-memory processes/data are lost immediately
! Shutdown scripts should persist critical in-memory data to disk within 30 seconds
```

## Shutdown Scripts Concept
Shutdown scripts are critical for preemptible VMs to handle data persistence during interruption:
- Receive 30-second advance notice for graceful shutdown.
- Should save in-memory data to persistent disk.
- Execute tasks to clean up or finalize operations before termination.

### Implementation Advice
Use GCP's metadata service to define shutdown scripts. Example metadata key: `shutdown-script`.

```bash
# Example shutdown script to persist data
#!/bin/bash
# Save in-memory data to disk
echo "Saving data..." >> /var/log/shutdown.log
# Your persistence logic here
sleep 2
echo "Data saved. Shutting down..." >> /var/log/shutdown.log
```

## Billing Considerations
Preemptible VMs have unique billing mechanics:
- Free of charge if preempted within the first 10 minutes.
- Billing starts only after the initial 10-minute grace period.
- Billed at regular preemptible rates if running beyond 10 minutes when preempted.

### Deep Dive
- **Grace Period**: 10 minutes free runtime post-startup.
- **Billing Cycles**: Separate for each restart; new 10-minute free period on each start.
- **Cost Estimation**: Always check current pricing against standard instances for compute units used.

> [!NOTE]
> The video demonstrated billing nuances, suggesting that building and graceful startup might account for timing variations in the free period.

## Conclusion
This live demonstration effectively showcased preemptible VM preemption in a real GCP environment, illustrating how Google reclaims compute resources while preserving user data. The process reinforced the transient nature of these instances and the importance of designing for interruptions.

## Summary

### Key Takeaways
```diff
+ Preemptible VMs offer significant cost savings (60-90% less than standard instances)
+ Data on persistent disks persists through preemption; only CPU/memory are reclaimed
+ Preemption can occur anytime within 24 hours, with 30 seconds notice
+ Shutdown scripts enable graceful handling of in-memory data during termination
+ Billing includes a 10-minute free grace period post-restart
- No guarantee of 24-hour runtime; design workloads to tolerate interruptions
- In-memory data and processes are immediately lost upon preemption
! Always design for worst-case scenarios with preemption-aware architecture
```

### Expert Insight
#### Real-world Application
In production, preemptible VMs excel in stateless workloads like batch ML training, data preprocessing, or CI/CD pipelines. Enterprises often use managed instance groups with preemptible instances to handle variable workloads, automatically replacing preempted instances with new ones while maintaining overall cluster capacity.

#### Expert Path
Master preemptible VMs by understanding GCP's preemption patterns through monitoring tools like Cloud Monitoring and by implementing robust retry mechanisms in your application code. Learn to use Instance Groups with auto-healing and metadata-based automation for seamless replacement of preempted instances.

#### Common Pitfalls
**Mistake 1**: Treating preemptible VMs like standard instances.
**Resolution**: Implement preemption handling in application logic using GCP's preempt signal. Avoid long-running stateful operations.
**Avoidance**: Use Kubernetes preemptible node pools or design stateless architectures.

**Mistake 2**: Forgetting billing nuances, especially the first 10 minutes.
**Resolution**: Monitor usage with Cloud Billing reports and set alerts.
**Avoidance**: Switch to spot VMs for more advanced pricing (available in some regions).

**Lesser-Known Facts**:
- Preemptible VMs may actually run longer than 24 hours during low-demand periods.
- Google reserves the right to change preemption policies; always code defensively.
- Spot VMs (evolved from preemptible instances) offer better availability guarantees in select regions with comparable pricing.
