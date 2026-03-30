# Session 16: Q&A Discussion on Snapshots

## Table of Contents
- [Restore from Snapshots Overview](#restore-from-snapshots-overview)
- [Incremental Snapshots and Parent-Child Relationships](#incremental-snapshots-and-parent-child-relationships)
- [Deleting Snapshots and Data Transfer](#deleting-snapshots-and-data-transfer)
- [Viewing Changes Between Snapshots](#viewing-changes-between-snapshots)
- [Logs and Agent Installation for Tracking Changes](#logs-and-agent-installation-for-tracking-changes)
- [Creating VMs from Images vs Snapshot](#creating-vms-from-images-vs-snapshot)
- [Project-Level Access and Global Resources](#project-level-access-and-global-resources)
- [Scheduling Snapshots](#scheduling-snapshots)

## Restore from Snapshots Overview
### Overview
This section addresses key considerations when deciding which snapshot to use for system restoration. Snapshots capture the state of virtual machines (VMs) at specific points in time, allowing you to restore to a previous working configuration if the system becomes corrupted or unstable.

### Key Concepts/Deep Dive
- **Snapshot Selection Logic**: Choose snapshots based on the timeline of installation or changes that caused the corruption. Use the latest snapshot that precedes the problematic event to restore the most recent stable state.
- **Example Scenario**: If installing Nginx and Git caused VM corruption, select the snapshot taken before these installations to restore to a working state.
- **Restoration Process**: Snapshots are used to recreate the VM state; the choice depends on maintaining data integrity without the corrupting elements.

### Lab Demos
No specific step-by-step demos are included in this Q&A session, but the discussion implies future demonstration of restoration processes.

## Incremental Snapshots and Parent-Child Relationships
### Overview
Incremental snapshots build upon previous snapshots, creating a chain where newer snapshots depend on older ones. This efficient approach saves storage by only capturing changes rather than full copies.

### Key Concepts/Deep Dive
- **Incremental Nature**: Later snapshots store only delta changes, referencing the parent snapshot for complete data.
- **Size Comparison**: An incremental snapshot (e.g., 85.9 MB) appears smaller but includes all parent data when restoring.
- **Restoration Behavior**: When restoring, the system merges the incremental snapshot with its parent to recreate the full VM state at that point.
- **Analogy**: Parent snapshots act like a "father" with "child" snapshots inheriting all properties, ensuring continuity across the chain.

### Tables
| Snapshot Type | Size Example | Includes Parent Data | Use Case |
|---------------|--------------|----------------------|----------|
| Full Snapshot | Larger (full capture) | No (standalone) | Initial baseline |
| Incremental Snapshot | Smaller (delta) | Yes (merged at restore) | Point-in-time backups |

## Deleting Snapshots and Data Transfer
### Overview
When deleting older snapshots in a chain, the system transfers data to the next available child snapshot to maintain data integrity and prevent data loss.

### Key Concepts/Deep Dive
- **Inheritance During Deletion**: Deleting a parent snapshot consolidates its data into the successor (child), similar to transferring a will or inheritance.
- **Historical Retention Strategy**: Regularly delete older snapshots while retaining the latest ones (e.g., keep 10 snapshots) to manage storage while preserving recovery options.
- **Bulky Transition**: The successor may temporarily become larger as it absorbs the deleted parent's data and changes.
- **Automation of Data Transfer**: This process ensures no historical data is lost when maintaining only recent snapshots.

### Lab Demos
A demo was mentioned where Snapshot 1 is deleted to demonstrate data transfer to Snapshot 2, showing size changes and integrity maintenance.

## Viewing Changes Between Snapshots
### Overview
Tracking specific changes between snapshots can be challenging without additional logging or agent tools, as snapshots capture VM states but not detailed change logs.

### Key Concepts/Deep Dive
- **Change Tracking Limitations**: Without installed agents or scripts, identifying what changed (e.g., software installations) requires external knowledge or logs.
- **Manual Tracking**: Users must rely on memory or installation records; snapshots don't automatically log changes like "installed Nginx and Git."
- **Difficulty Factors**: Human-driven changes are hard to track; automated scripts or agents make logging feasible.
- **Alternative Methods**: Using startup scripts or agents to send change logs enables better visibility of modifications.

## Logs and Agent Installation for Tracking Changes
### Overview
To monitor changes between snapshots, install agents or use scripts that generate logs of VM modifications, providing visibility into what caused issues like corruption.

### Key Concepts/Deep Dive
- **Agent-Based Logging**: Install monitoring agents that report changes, such as software installations or OS updates.
- **Script Integration**: Use startup scripts to track and log changes automatically.
- **Out-of-the-Box Challenges**: Default snapshots lack built-in change logs; custom solutions required for detailed tracking.
- **Real-World Example**: Similar to Windows updates causing issues (e.g., camera stops working), logs help identify problematic changes and decide restoration points.
- **Patch-Level Tracking**: Easier to track OS patches; software installations require agents for detailed logs.

## Creating VMs from Images vs Snapshot
### Overview
The process of creating new VMs involves selecting sources like custom images or snapshots, automatically scoped to project permissions unless cross-project access is configured.

### Key Concepts/Deep Dive
- **Source Selection**: When creating an instance, choose from existing snapshots or images within the project.
- **Project-Level Visibility**: UI shows only snapshots accessible in the current project; command-line required for cross-project usage.
- **Snapshot Association**: Snapshots automatically reference the originating VM by project and permission settings.

### Lab Demos
Creation process demonstrated in UI, showing source selection options for snapshots and images.

## Project-Level Access and Global Resources
### Overview
Snapshots and custom images are global resources that can be shared across projects if permissions allow, enabling cross-project usage for efficient resource management.

### Key Concepts/Deep Dive
- **Global Nature**: Snapshots and images can be accessed across projects with proper permissions.
- **Access Conditions**: Require explicit permissions; public snapshots enable broader sharing.
- **Command-Line Flexibility**: Cross-project access often requires CLI commands rather than UI.
- **Permission Management**: Ensure project members have access to use resources from other projects.

## Scheduling Snapshots
### Overview
Automated snapshot scheduling can be configured using built-in tools, while custom image creation typically remains manual since schedules don't apply to custom images.

### Key Concepts/Deep Dive
- **Built-in Scheduling**: Use snapshot schedules to automate backups with defined frequency and settings.
- **Schedule Attachment**: Attach schedules to disks for automatic creation at specified intervals.
- **Manual Custom Images**: Custom images aren't scheduled; plan and create them as needed.
- **Best Practice**: Schedule snapshots for regular backups due to their backup nature; custom images created ad-hoc.

## Summary
### Key Takeaways
```diff
+ Use incremental snapshots for efficient storage while allowing full restoration from parents
+ Deleting parent snapshots transfers data to children, maintaining chain integrity
+ Agent installation enables change tracking between snapshots for better debugging
+ Snapshots and images are global resources that support cross-project access with permissions
+ Schedule snapshots for automated backups, but manually manage custom images
+ Restore to the latest stable snapshot before corruption to minimize data loss
! Always verify permissions before cross-project resource usage
```

### Expert Insight
#### Real-world Application
In production environments, implement snapshot schedules for critical VMs (e.g., daily for databases, hourly for application servers) to minimize recovery time objectives (RTO). Use restoration for quick rollbacks during deployment failures or security incidents, ensuring business continuity with minimal downtime.

#### Expert Path
Master snapshot management by learning CLI commands for cross-project operations using tools like `gcloud` or `az` (depending on cloud provider). Experiment with multi snapshots chains and practice restoration scenarios to understand inheritance dynamics. Integrate logging tools like cloud monitoring agents for proactive change tracking.

#### Common Pitfalls
- **Over-relying on Latest Snapshots**: Always verify the snapshot point predates known issues to avoid restoring corrupted states.
- **Ignoring Size Increases**: Expect temporary size bulges when deleting parent snapshots as data transfers occur.
- **Manual Change Documentation**: Without agents, fail to track human-induced changes, leading to longer troubleshooting times.
- **Cross-Project Permission Issues**: Attempting unauthorized resource access fails silently in UI; use CLI with proper IAM roles.
- **Scheduled Custom Images Mismatch**: Expect custom images to remain manual; avoid automation attempts that may fail.

Common issues include:
- Restoration failures due to permission restrictions; resolve by ensuring project access.
- Excessive storage costs from retaining too many snapshots; resolve by maintaining only necessary historical snapshots.
- Change tracking voids in non-agented environments; resolve by implementing centralized logging post-incident.

Lesser known aspects:
- Snapshot inheritance creates dynamic sizing where apparent incremental sizes hide full restore capabilities.
- Global resources enable cost-sharing across projects, reducing duplicate image storage.
- Scheduling applies only to disk-level snapshots, not VM-level custom captures.
- Deletion processes are asynchronous, potentially delaying next snapshot opportunities.

### Notes on Transcript Corrections
The following corrections were made to the transcript for accuracy:
- "engine X" corrected to "Nginx"
- "snapchat" corrected to "snapshot"
- "Snapwe" corrected to "snapshot"
- "GIT" corrected to "Git"
- Minor grammatical and punctuation improvements for clarity (e.g., "diss" → "disks", "Schedu" → "Scheduled") without altering technical content.
