# Session 17: Restore Data Disk, Snapshot, Custom Image via Cross Project, Archive & Instant Snapshot

## Table of Contents
- [Overview of Snapshots and Custom Images](#overview-of-snapshots-and-custom-images)
- [Restoring a Data Disk Without Downtime](#restoring-a-data-disk-without-downtime)
- [Cross-Project Sharing with Custom Images](#cross-project-sharing-with-custom-images)
- [Types of Snapshots: Standard, Archive, and Instant](#types-of-snapshots-standard-archive-and-instant)
- [Cross-Project Access for Snapshots](#cross-project-access-for-snapshots)
- [Real-Lab Scenarios](#real-lab-scenarios)
- [Summary](#summary)

## Overview of Snapshots and Custom Images

### Overview
Snapshots and custom images are both used for backing up and restoring VMs, but they serve different primary purposes. Snapshots are ideal for restoring VMs to a previous state, including boot and data disks, while custom images are primarily used for creating new VMs from a pre-configured setup. This session builds on prior knowledge, focusing on practical restoration techniques, cross-project access, and advanced snapshot features.

### Key Concepts/Deep Dive
- **Snapshots**: Global resources that capture the state of a persistent disk at a specific point. They allow incremental backups and are compressed for storage efficiency.
- **Custom Images**: Derived from disks or other images, used to deploy identical VMs. They include the entire OS and software stack.
- **Use Cases**:
  - Snapshots for quick recovery (e.g., restoring after corruption).
  - Custom images for scalable deployments (e.g., in instance groups).
- **Restoration Goals**: For data disks, aim for zero downtime; for boot disks, downtime is unavoidable due to the need to detach and reattach.

### Code/Config Blocks
To create a snapshot from a disk:
```bash
gcloud compute snapshots create my-snapshot --source-disk=my-disk --source-disk-zone=us-central1-a
```

For custom images:
```bash
gcloud compute images create my-custom-image --source-disk=my-disk --source-disk-zone=us-central1-a
```

Table: Comparison of Snapshot and Custom Image Features

| Feature              | Snapshot                          | Custom Image                     |
|----------------------|-----------------------------------|----------------------------------|
| Primary Use         | Restore existing disks/VMs        | Create new VMs                   |
| Scope               | Disk-specific                     | VM template                      |
| Restoration Method  | Attach/Detach                     | Deploy as new instance           |
| Global Resource     | Yes                               | Yes                              |
| Downtime for Boot Disk | Required                        | None (for deployment)            |

> [!NOTE]
> Snapshots can restore boot disks but require VM termination and detachment, while custom images allow seamless new VM creation.

## Restoring a Data Disk Without Downtime

### Overview
Restoring a data disk from a snapshot allows recovery without shutting down the VM, unlike boot disk restoration. This involves creating a new disk from the snapshot and attaching it, then optionally migrating data via commands like `cp` or direct restoration.

### Key Concepts/Deep Dive
- **Non-Boot Disk Restoration**: No VM downtime; attach a new disk created from the snapshot.
- **Hybrid Approaches**: Combine snapshots with data copying for performance-optimized disks (e.g., from standard to SSD).
- **Performance Considerations**: Avoid heavy copy operations on degraded disks; use snapshots for minimal impact.

### Lab Demos
1. **Prepare Environment**:
   - Create a VM with a boot disk and a 17 GB standard persistent disk as data disk.
   - Install software (e.g., Git and Tree) and add data (e.g., clone a Git repository).

   ```bash
   # Format and mount the data disk (assuming /dev/sdb)
   sudo mkfs.ext4 /dev/sdb
   sudo mkdir /mnt/data-disk
   sudo mount /dev/sdb /mnt/data-disk
   sudo chmod 777 /mnt/data-disk
   ```

2. **Take Snapshot**:
   ```bash
   gcloud compute disks create snapshot-data-snap3 --source-disk=data-disk --zone=us-central1-a
   ```

3. **Restore to SSD Disk** (for performance upgrade):
   - Create a new SSD disk from the snapshot.
   - Attach and mount the new disk, copy data if needed, or mount directly for restoration.

   ```bash
   # Attach new SSD disk
   gcloud compute instances attach-disk my-vm --disk=new-ssd-disk --zone=us-central1-a
   # On VM: Mount and verify
   sudo mount /dev/sdc /mnt/new-data-disk && sudo chmod 777 /mnt/new-data-disk
   ls /mnt/new-data-disk  # Should show restored data
   ```

   > [!TIP]
   > For zero-downtime, avoid `cp -rf` on active disks; snapshot first, then restore externally.

   Diagram of Data Disk Restoration Process:

   ```mermaid
   flowchart TD
       A[Identify Degraded Data Disk] --> B[Take Snapshot]
       B --> C[Create New Disk from Snapshot]
       C --> D[Attach New Disk to Running VM]
       D --> E[Mount and Verify Data]
       E --> F[Detach Old Disk if Needed]
   ```

## Cross-Project Sharing with Custom Images

### Overview
Custom images can be shared across projects with minimal permissions, enabling seamless VM recreation in development or other environments without duplicating costs or infrastructure.

### Key Concepts/Deep Dive
- **Sharing Mechanism**: Grant `roles/compute.imageUser` on the image.
- **Use Cases**: Debug production issues in dev, deploy across sister companies, or migrate setups.
- **Cost Implications**: Image storage is paid by the source project; consumption costs (e.g., VM creation) by the using project.

### Lab Demos
1. **Share a Custom Image**:
   - In production project, grant access:
     - Go to IAM > Add Principal (e.g., dev account email).
     - Role: `Compute Image User`.

2. **Use Shared Image in Another Project**:
   ```bash
   gcloud compute instances create my-dev-vm \
     --image=my-custom-image \
     --image-project=production-project-id \
     --zone=us-central1-a
   ```

   - Verify: SSH and check installed software (e.g., Nginx).
     ```bash
     systemctl status nginx
     ```

   > [!IMPORTANT]
   > Permissions propagate with delay; use CLI if UI doesn't show immediately. Data ingress costs apply for cross-region access.

## Types of Snapshots: Standard, Archive, and Instant

### Overview
Google Cloud offers standard, archive, and instant snapshots, each tailored for different retention and recovery needs. Standard for regular use, archive for long-term cost savings, and instant for zonal, quick restores.

### Key Concepts/Deep Dive
- **Standard Snapshot**: General-purpose, supports multi-region, schedules, and incremental backups.
- **Archive Snapshot**: Cheaper storage (90-day minimum), seldom-accessed data. Higher access fees; no schedules.
- **Instant Snapshot**: Zonal, enables sub-60s restores. Deletions remove associated snapshots.

| Type       | Retention | Cost Per GB/Month | Minimum Billing | Access Speed |
|------------|-----------|-------------------|-----------------|--------------|
| Standard  | Flexible | $0.065            | Per hour        | Standard    |
| Archive   | Long-term| $0.019            | 90 days         | Standard    |
| Instant   | Zonal    | Varies            | None-specified | <60s        |

- **Note**: Instant snapshots reside on the disk; deletion removes them.

### Code/Config Blocks
Create snapshot types:
```bash
# Archive
gcloud compute snapshots create my-archive-snapshot \
  --source-disk=my-disk \
  --storage-location=regional \
  --snapshot-type=ARCHIVE

# Instant
gcloud compute snapshots create my-instant-snapshot \
  --source-disk=my-disk \
  --snapshot-type=INSTANT
```

> [!WARNING]
> Archive snapshots are penalized for early deletion (<90 days); instant deletes with disk.

## Cross-Project Access for Snapshots

### Overview
Snapshots are global; share like images but require custom roles for minimal permissions.

### Key Concepts/Deep Dive
- **Sharing**: Create a custom role with `compute.snapshots.useReadOnly` permission.
- **Use Cases**: Access prod snapshots in dev for debugging or recreation.

### Lab Demos
1. **Create Custom Role** (Production Project):
   ```bash
   gcloud iam roles create CustomSnapshotUser \
     --permissions=compute.snapshots.useReadOnly \
     --stage=ALPHA
   ```

2. **Grant Role**:
   - Go to Snapshot > Share > Add ID with custom role.

3. **Use in Dev Project**:
   ```bash
   gcloud compute disks create my-cross-disk \
     --source-snapshot=my-shared-snapshot \
     --source-snapshot-project=prod-project-id \
     --zone=us-central1-a
   ```
   - Attach to VM and mount.

   ```bash
   gcloud compute instances attach-disk my-vm --disk=my-cross-disk
   # On VM: sudo mount /dev/sdb /mnt/data
   ```

   > [!NOTE]
   > UI may not show external snapshots; rely on CLI. No major downtime if handling data disks.

## Real-Lab Scenarios

### Overview
Apply concepts to real-world changes like machine type or zone adjustments, avoiding full recreations.

### Key Concepts/Deep Dive
- **Machine Type Change**: Stop VM, change type, restart.
- **Zone Change**: No direct migration; use snapshots/images to recreate in new zone.

### Lab Demos
1. **Change Machine Type**:
   - Stop VM: `gcloud compute instances stop my-vm`
   - Update: `gcloud compute instances set-machine-type my-vm --machine-type=n2-standard-4`
   - Start: `gcloud compute instances start my-vm`

2. **Change Zone** (Recreate via Custom Image or Snapshot):
   - Create image/snapshot from old VM.
   - Deploy new VM in target zone (e.g., Singapore B) using shared resources.

   ```mermaid
   graph LR
       A[Running VM in Zone A] --> B[Create Snapshot/Image]
       B --> C[Share Cross-Project]
       C --> D[Deploy New VM in Zone B]
   ```

   > [!CAUTION]
   > Zone availability varies by resource (e.g., GPUs); validate target zones.

## Summary

### Key Takeaways
```diff
+ Snapshots enable zero-downtime data disk restoration with minimal VM impact.
- Direct data copying can degrade performance on failing disks; snapshot first.
! Use custom roles for cross-project access with least-privilege principles.
+ Archive snapshots reduce costs for long-term backups but have 90-day minimums.
- Instant snapshots offer fast restores but vanish with disk deletion.
```

### Expert Insight

**Real-world Application**: In production environments, use snapshots for quick data recoveries (e.g., after index corruption) and custom images for consistent deployments across projects, like migrating from one AWS region to GCP.

**Expert Path**: Master CLI commands for automation; experiment with archive vs. standard costs in test projects. Dive into GCP documentation for advanced scheduling and regional optimizations.

**Common Pitfalls**:
- Assuming UI supports all cross-project features; rely on CLI.
- Ignoring data ingress costs for cross-region access; monitor with billing alerts.
- Deleting disks without checking for instant snapshots; they auto-delete.

**Common Issues and Resolutions**:
- Permission delays: Use CLI and wait; check IAM propagation.
- Zone incompatibility: Verify region/zonal quotas via `gcloud compute zones describe`.
- Resource quotas: Ensure target zones have capacity; scale cautiously.

**Lesser Known Things**: Snapshots compress data paternally; archive storage leverages cheaper regional classes like `REGIONAL`. Instant snapshots support point-in-time restores but only locally, enhancing zonal disaster recovery without multi-region overhead. Hybrid on-premises to GCP migrations often start with custom images imported via `gcloud compute images import`.
