# Session [100]: Preemptible Virtual Machine (PVM) in Action - Demo

## Table of Contents
- [Intro](#intro)
- [Preemptible VM Lifecycle Demonstration](#preemptible-vm-lifecycle-demonstration)
- [Log Files and Monitoring](#log-files-and-monitoring)
- [SSH and VM Inspection](#ssh-and-vm-inspection)
- [Preemption Event Capture](#preemption-event-capture)
- [Activity Log Analysis](#activity-log-analysis)
- [Data Persistence Verification](#data-persistence-verification)
- [VM Restart and Validation](#vm-restart-and-validation)
- [Cost and Billing Implications](#cost-and-billing-implications)
- [Key Behavior and Best Practices](#key-behavior-and-best-practices)
- [Summary](#summary)

## Intro

This session provides a live demonstration of Preemptible Virtual Machines (PVMs) in Google Cloud Platform (GCP), showcasing their complete lifecycle from provisioning to preemption and restart. PVMs offer significant cost savings but can be terminated by Google at any time with a 30-second notice.

### Overview
Preemptible VMs are designed for fault-tolerant workloads that can handle interruptions. The demonstration shows a real VM that ran for nearly 24 hours before being terminated, with all data and configurations preserved on persistent disks.

### Key Concepts
- **Maximum Lifespan**: 24 hours theoretical, ~23.5 hours in practice
- **Preemption Notice**: 30-second ACPI shutdown signal
- **Data Survival**: Only persistent disks retained; in-memory data lost
- **Immediate Restart**: VMs can be restarted with all disk data intact
- **Cost Optimization**: 80% savings with no availability guarantees

## Preemptible VM Lifecycle Demonstration

### Provisioning Timeline
```bash
# VM provisioned on July 1st at approximately 4:00 PM
# Demonstration conducted on July 2nd at 3:50 PM Indian time
Runtime before preemption: ~23 hours 50 minutes
```

### Preemption Occurrence
The VM was preempted by Google's Compute Engine system at 4:12 PM on July 2nd, approximately 11-12 minutes after the start of the recording.

### Lifespan Verification
```
Creation Time: July 1st, 4:01 PM
Preemption Time: July 2nd, 4:12 PM  
Total Runtime: 23 hours 11 minutes
Remaining Life: ~48 minutes 49 seconds before hitting guarantee limit
```

> [!NOTE]
> The VM lived just 11-12 minutes during the recording, but this was after nearly a full day of runtime.

## Log Files and Monitoring

### Initial Log Inspection
After creation, the VM showed no activity logs in streaming mode, indicating normal operation since provisioning.

```bash
# Log streaming command (implied)
tail -f /var/log/messages  # Standard Linux monitoring
```

### Preemption Log Entry
```
Jul 2 16:12:22 instance-name compute[pid]: Compute Engine preempted by system@google.com
```

### System Event Details
```
Event Type: Shutdown Event
Principal: system@google.com
Timestamp: July 2nd, 4:12 PM
Duration: Approximately 11 minutes after recording start
```

## SSH and VM Inspection

### Initial SSH Connection
```bash
# Connect to running VM
gcloud compute ssh preemptible-vm-instance --zone=us-central1-a
```

### Directory and File Check
```bash
# Clear screen and list contents
clear
ls
# Output: folder/ file.txt (demo content)

# View file content
cat file.txt  # Shows retained content
```

### Software Installation Verification
```bash
# Check installed applications
which example-app  # Returns path if installed
# Output: /usr/bin/example-app (demonstrates git installation preserved)
```

### System Health Check
```bash
# Verify VM is running normally
uptime
# Output: Shows uptime since creation time
```

## Preemption Event Capture

### Warning Sign Indication
The GCP console displayed a clear warning message indicating the instance is preemptible:

> ⚠️ **Warning**: This virtual machine is preemptible and can be terminated at any time.

### Status Change
```
Before: Running
During: Shutting Down (grace period)
After: Stopped/Preempted
```

### Preemption Notification
```diff
! VM receives ACPI power button event (shutdown signal)
! 30-second countdown begins for graceful shutdown
! Any running processes are terminated
```

### Console Status
```
Status: TERMINATED
Boot Disk: Intact (attached)
Data Disks: Preserved
```

## Activity Log Analysis

### Activity Log Navigation
Access activity logs through GCP Console:
```
Navigation: VM Details → Activity Log tab
```

### Preemption Event Details
| Field | Value |
|-------|-------|
| **Event** | Shutdown Event |
| **Time** | July 2nd, 4:12 PM |
| **Principal** | system@google.com |
| **Type** | Compute Engine preempted |
| **Status** | Completed |

### Expanded Details View
```json
{
  "eventType": "GCE_API_CALL",
  "methodName": "compute.instances.preempted",
  "resourceName": "//compute.googleapis.com/projects/project-id/zones/zone/instances/instance-name",
  "principal": "system@google.com",
  "timestamp": "2023-07-02T10:42:00Z"
}
```

> [!IMPORTANT]
> The activity log shows "system@google.com" as the principal, indicating this was a system-initiated preemption, not a user action.

## Data Persistence Verification

### What Survives Termination
✅ **Persistent Disk Content**: Boot disk with OS and user data
✅ **Software Installations**: Applications like git, custom packages
✅ **File Systems**: Mounted persistent storage
✅ **VM Configuration**: Machine type, network settings, metadata

### What is Lost
❌ **In-Memory Data**: Current session variables, RAM content
❌ **Running Processes**: Active computations and services
❌ **Temporary Files**: /tmp directory contents
❌ **Network Connections**: Active TCP sessions

### Expected Shutdown Script Execution
```bash
#!/bin/bash
# Example shutdown script for data persistence

# Save in-memory data to persistent disk
save_process_state() {
  # Persist current application state
  echo "$(date): Saving state on preemption" >> /persistent/state.log
  
  # Example: Save database state
  mysqldump db > /persistent/db_backup.sql
  
  # Note: This script must complete within 30 seconds
}

save_process_state
```

## VM Restart and Validation

### Post-Preemption State
```
VM Status: TERMINATED
Disks: Still attached and available
Billing: Stopped automatically
```

### Restart Procedure
```bash
# Restart command
gcloud compute instances start preemptible-vm-instance \
  --zone=us-central1-a

# Expected result: VM starts in ~30 seconds
```

### Verification After Restart
```bash
# SSH into restarted VM
gcloud compute ssh preemptible-vm-instance --zone=us-central1-a

# Verify data persistence
ls -la /home/user/  # Check demo folder
# Output: folder/ file.txt still exist

# Check installed software
which git  # Returns: /usr/bin/git

# Verify file content matches original
cat file.txt  # Same content as before
```

### SSH Session Demonstration
```bash
$ whoami
user

$ pwd  
/home/user

$ ls
folder/ file.txt

$ cat file.txt
[Original demo content retained]
```

## Cost and Billing Implications

### Billing Timeline
```diff
+ First 10 minutes after restart: No charge (complimentary)
! After 10 minutes: Standard preemptible rates apply
! Maximum 24-hour billing cycle restarts
```

### Restart Life Cycle Reset
```
Restart Time: July 2nd, ~4:25 PM
New Lifespan: 24 hours from this timestamp
Next Possible Preemption: After July 3rd, 4:25 PM
```

### Cost Analysis
```
Complimentary Period: 10 minutes
Runtime After Complimentary: Billable at preemptible rates
Total Cost: Significantly less than regular VM pricing
Preemption Benefit: Avoided additional costs on terminated compute
```

## Key Behavior and Best Practices

### PVM Characteristics

| Aspect | Behavior |
|--------|----------|
| **Availability** | No SLA, can be terminated anytime |
| **Cost Saving** | Up to 80% cheaper than regular VMs |
| **Lifespan** | Maximum 24 hours guaranteed |
| **Notice** | 30 seconds before termination |
| **Data** | Disks survive, memory content lost |
| **Restart** | Immediate, with data intact |

### Recommended Workloads
- Batch processing jobs
- Data analytics pipelines  
- CI/CD build environments
- Load testing scenarios
- Development sandboxes
- Fault-tolerant applications

### Preemption Handling Best Practices
```bash
# Implement shutdown script for data persistence
# Create idempotent workloads that can resume
# Use checkpointing for long-running tasks
# Monitor logs for preemption events
# Design for automatic restart capabilities
```

### Monitoring and Alerting
```bash
# Check for preemption in logs
gcloud logging read \
  "resource.type=gce_instance \
   jsonPayload.event_type=compute.instances.preempted" \
  --freshness=1d

# Set up alerting for cost management
gcloud pubsub subscriptions create preemption-alerts \
  --topic=compute-notifications \
  --filter="resource.type=gce_instance AND protoPayload.method=compute.instances.preempted"
```

## Summary

### Key Takeaways
```diff
+ Preemptible VMs provide up to 80% cost savings with controlled interruptions
+ Google gives 30-second notice before VM termination
+ Persistent disks retain all data; memory content is lost
+ VMs can be restarted immediately with all configurations intact
+ First 10 minutes after restart are complimentary
! Design workloads for fault tolerance and data persistence
! Monitor activity logs for preemption events
```

### Quick Reference
| Command | Purpose |
|---------|---------|
| `gcloud compute instances create vm --preemptible` | Create PVM |
| `gcloud compute instances start vm-name` | Restart after preemption |
| `gcloud logging read "preempted"` | View preemption logs |
| `grep preempted /var/log/syslog` | Local VM log check |

### Expert Insight

#### Real-World Application
Preemptible VMs excel in:
- **Data Processing**: ETL jobs with checkpointing
- **ML Training**: Models that save state regularly
- **Batch Computations**: Parallel processing tasks
- **Testing Environments**: Temporary infrastructure
- **Cost-Optimized Production**: Fault-tolerant microservices

#### Expert Path
To master preemptible VMs:
1. Study regional preemption patterns and rates
2. Implement advanced shutdown scripts with data snapshots
3. Build orchestration systems for automatic workload recovery
4. Monitor cost-vs-reliability trade-offs across workloads
5. Create custom AMIs optimized for quick restarts

#### Common Pitfalls
❌ **Assuming 24-hour availability** for critical workloads
❌ **No shutdown scripts** leading to data loss
❌ **Ignoring 10-minute complimentary period** in cost planning
❌ **Lack of idempotent design** for process resumption
❌ **Poor monitoring** leading to unnoticed preemptions

#### Lesser-Known Facts
- VMs can be preempted minutes after creation (rare)
- Google may preempt in coordinated waves for capacity management
- Restart resets the 24-hour guarantee completely
- Some machine types have different preemption frequencies
- Preemptible VMs still incur network egress charges when terminated

---
*🤖 Generated with [Claude Code](https://claude.com/claude-code)*
*Co-Authored-By: Claude <noreply@anthropic.com>*

<summary>KK-CS45-V3</summary>
