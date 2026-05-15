# Session 9: Simulating a Host Maintenance Event in GCP

<details open>
<summary><b>Session 9: Simulating a Host Maintenance Event in GCP (KK-CS45-script-v3)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Maintenance Policies](#maintenance-policies)
- [Live Migration](#live-migration)
- [Lab Demo: Simulating Maintenance Events](#lab-demo-simulating-maintenance-events)
- [Summary](#summary)

## Overview

This session demonstrates how to simulate and understand host maintenance events in Google Cloud Platform (GCP). Host maintenance events occur when Google needs to perform maintenance on the physical server hosting your virtual machine (VM). During these events, VMs may be migrated to different host machines to ensure service continuity.

The session covers:
- Setting maintenance policies for VM instances
- Understanding different termination behaviors during maintenance
- Simulating maintenance events to test configurations
- Live migration process and timing

## Key Concepts

### Host Maintenance Events
Host maintenance events are periodic updates and patches performed by Google Cloud on the underlying physical infrastructure. During these events:

- VMs running on the maintenance-affected host may be migrated to another host
- Migration is typically performed using **live migration** (while VM is running)
- Migration process usually takes only a few seconds
- The entire process is transparent to the VM owner

### Maintenance Policy Configuration
When creating or editing a VM instance, you can configure how the VM behaves during a maintenance event in the Management section under "Automatic restart" and related options.

## Maintenance Policies

GCP provides two main policy options for VM behavior during maintenance:

1. **Termination with Auto-Restart (Recommended)**
   - VM is terminated when maintenance starts
   - VM automatically restarts after maintenance completes
   - Default behavior that ensures continuity

2. **Termination without Auto-Restart**
   - VM is terminated when maintenance starts
   - VM remains in stopped state after maintenance
   - Requires manual intervention to restart

> [!IMPORTANT]
> Once set, the maintenance policy cannot be changed for an existing VM. If you need different policy behavior, create a new VM with the desired configuration.

> [!NOTE]
> For VM families that support live migration (such as N1 and N2 general-purpose machine types), Google will attempt live migration before falling back to the configured termination policy.

## Live Migration

Live migration is Google's preferred method for moving VMs during host maintenance:

- **Transparency**: Migration occurs while VM is running with minimal disruption
- **Duration**: Typically completes in seconds
- **Uptime**: No downtime experienced by the VM
- **Migration Process**: VM is copied to new host while maintaining network connections

### Migration Timing
- Migration window varies but typically occurs during scheduled maintenance windows
- Actual migration precedes the maintenance event
- All VMs on the affected host are migrated simultaneously

```diff
+ Benefits of Live Migration:
  - Zero downtime for applications
  - Maintains network connections
  - Automatic process requiring no intervention

- When Termination Occurs:
  - Maintenance requires immediate shutdown
  - VM restarts automatically (based on policy)
  - Temporary service disruption
```

## Lab Demo: Simulating Maintenance Events

### Pre-requisites
- GCP Project with Compute Engine API enabled
- Appropriate IAM permissions for creating/modifying VMs

### Scenario 1: Termination without Auto-Restart

1. **Create VM Instance:**
   ```
   gcloud compute instances create [INSTANCE_NAME] \
     --machine-type [MACHINE_TYPE] \
     --zone [ZONE] \
     --image-family [IMAGE_FAMILY] \
     --image-project [IMAGE_PROJECT] \
     # Management options are configured after creation
   ```

2. **Configure Maintenance Policy:**
   - Go to VM instances in GCP Console
   - Select your instance > Edit
   - In Management section:
     - Enable "Provide a termination notice" (if you want shutdown scripts)
     - Set "On host maintenance" to "Terminate VM instance"
     - **Disable** automatic restart (VM stays stopped)

3. **Simulate Maintenance Event:**
   - From VM details page > System Events > Simulate Maintenance Event
   - Select appropriate maintenance type
   - Confirm simulation

4. **Observe Results:**
   - VM power state will change to "TERMINATED"
   - VM will not automatically restart
   - Check Compute Engine > Operations for migration details

### Scenario 2: Termination with Auto-Restart

1. **Modify Existing VM** (create new VM if policy was set):
   - Go to VM instances > Select instance > Edit
   - In Management section:
     - Set "On host maintenance" to "Terminate VM instance"
     - **Enable** automatic restart

2. **Simulate Maintenance Event:**
   - System Events > Simulate Maintenance Event
   - Wait for completion

3. **Observe Results:**
   - VM terminates during simulated maintenance
   - VM automatically restarts after maintenance completes
   - Check system events for timestamps

### Verification Steps

**Using GCP Console:**
- Navigate to Compute Engine > VM instances
- Check VM status and operation history
- View System Events for detailed logs

**Using Cloud Logging:**
```bash
gcloud logging read \
  'resource.type=gce_instance \
   resource.labels.instance_name=[INSTANCE_NAME]' \
  --limit=10
```

**Key Observations:**
- Maintenance events are logged in system events
- Migration operations appear in the operations history
- VM startup/shutdown events are clearly timestamped

## Summary

### Key Takeaways
```diff
+ Host maintenance events are automatic Google Cloud operations
+ Live migration minimizes downtime during maintenance
+ Maintenance policies are set per VM and cannot be changed
+ Simulation allows testing maintenance behavior without real events
+ Automatic restart ensures service continuity when enabled

! Maintenance events can trigger VM termination
! Test maintenance policies in staging environments first
```

### Quick Reference

**GCP Console Path:**
- Compute Engine > VM instances > [Instance] > System Events

**Maintenance Policy Commands:**
```bash
# Check current instance configuration
gcloud compute instances describe [INSTANCE_NAME] \
  --format="table(name,metadata.items.onHostMaintenance)"

# Simulate maintenance event (requires instance ID)
# Note: Limited options via CLI, use console for full control
```

**Maintenance Options:**
- **Terminate**: VM stops during maintenance
- **Migrate**: VM migrates to another host (automatic)

### Expert Insights

**Real-World Application:**
- In production environments, use termination with auto-restart for critical services
- Implement shutdown scripts that handle graceful termination signals
- Monitor maintenance windows and plan capacity accordingly
- Use preemptible VMs for non-critical workloads to reduce costs

**Expert Path:**
- Study GCP maintenance schedules and opt-in for maintenance windows
- Implement application-level resilience for termination scenarios
- Use managed instance groups for automatic recovery capabilities
- Monitor Cloud Logging for maintenance-related events and anomalies

**Common Pitfalls:**
- Not testing maintenance behavior in development environments
- Assuming all VM families support live migration
- Overlooking the inability to change maintenance policies on existing VMs
- Not implementing proper shutdown scripts for data consistency
- Ignoring maintenance notifications and custom maintenance windows

</details>
