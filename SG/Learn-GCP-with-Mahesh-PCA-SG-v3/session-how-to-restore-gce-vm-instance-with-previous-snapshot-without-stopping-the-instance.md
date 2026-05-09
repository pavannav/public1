# How to restore GCE (VM) instance with previous Snapshot without stopping the instance

## Table of Contents
- [Introduction](#introduction)
- [Create Snapshot](#create-snapshot)
- [Create Second Snapshot](#create-second-snapshot)
- [Attach New Disk](#attach-new-disk)
- [Summary](#summary)

## Introduction

### Overview
This session demonstrates how to restore a Google Compute Engine (GCE) virtual machine (VM) instance to a previous snapshot state without stopping the running instance. The process involves working with disks, creating snapshots, and attaching new disks based on snapshots to achieve the restoration.

### Key Concepts / Deep Dive

Before starting, ensure you have:
- A running GCE VM instance
- Access to the instance (e.g., via SSH)

💡 **Instance Setup for Demo**:
- The demo uses a VM with:
  - Boot disk: 10 GB
  - Data disk: 20 GB (mounted at `/data`)
- Data disk device name: `sdb`

📝 **Preparatory Steps**:
- Access the VM terminal
- List attached disks: `lsblk`
- Verify data disk is present and mounted
- Add test data to the data disk for demonstration

⚠️ **Important Note**: This method allows restoration without downtime by adding a new disk based on the snapshot, rather than replacing the existing disk while the instance is running.

## Create Snapshot

### Overview
Snapshots capture the state of a disk at a specific point in time. We'll create initial snapshots to establish baseline states for restoration.

### Key Concepts / Deep Dive

**Snapshot Creation Process**:
- Snapshots preserve disk data efficiently using compression
- Creation does not require stopping the VM
- Snapshots are regional resources

**Lab Demo: Create First Snapshot**

✅ **Steps**:
1. Navigate to Compute Engine > Snapshots in GCP Console
2. Click "Create Snapshot"
3. Configure the snapshot:
   - **Name**: `snapshot-with-one-big-image`
   - **Source disk**: Select the data disk (20 GB)
   - **Region**: Choose the appropriate region
   - **Snapshot compression**: Enable
4. Click "Create"

📝 **Demo Outcome**:
- Original data disk contains a 660 MB object
- Snapshot size: 45 MB (due to compression)

**Lab Demo: Add More Data and Create Second Snapshot**

✅ **Steps on VM**:

Before creating second snapshot:

```bash
# Check current data in /data
ls -la /data/
# Should show one big image file (660 MB)
```

1. Copy existing file or download another large object:
   ```bash
   cp /data/big-image /data/big-image-copy
   # Or download another file if needed
   ```

2. Navigate to Compute Engine > Snapshots in GCP Console
3. Click "Create Snapshot" 
4. Configure the snapshot:
   - **Name**: `snapshot-with-two-big-images`
   - **Source disk**: Select the data disk (20 GB)
   - **Region**: Choose the appropriate region
   - **Snapshot compression**: Enable
5. Click "Create"

📝 **Demo Outcome**:
- Data disk now contains two images (two 660 MB objects)
- Second snapshot created successfully

## Attach New Disk

### Overview
To restore to a previous state, we attach a new disk created from the desired snapshot, replacing the existing data disk while keeping the VM running.

### Key Concepts / Deep Dive

**Restoration Strategy**:
- GCE VMs support hot-plugging disks while running
- Delete the current data disk attachment
- Attach a new disk based on the target snapshot
- Mount the new disk to the same mount point

**Lab Demo: Restore to First Snapshot**

✅ **Steps**:

1. In GCP Console, go to Compute Engine > VM instances
2. Select the running instance
3. Click "Edit"

4. **Delete Existing Data Disk**:
   - Scroll to "Additional disks" section
   - Delete the current data disk attachment
   - Do **not** check "Delete disk" (preserve the original disk separately if needed)

5. **Attach New Disk from Snapshot**:
   - Click "Add disk"
   - Select "Attach existing disk" (from snapshot)
   - Choose the snapshot: `snapshot-with-one-big-image`
   - Click "Done"

6. Click "Save" to apply changes

✅ **Verification on VM**:

1. Check disk changes:
   ```bash
   lsblk
   # Original sdb should be gone, new disk appears as sdc
   ```

2. Mount the new disk:
   ```bash
   # Mount as /data (create if needed)
   sudo mkdir -p /data
   sudo mount /dev/sdc1 /data  # Adjust partition if needed
   ```

3. Verify restoration:
   ```bash
   ls -la /data/
   # Should now show only the original big image (660 MB)
   # The second file copied earlier should be absent
   ```

## Summary

### Key Takeaways
```diff
+ Non-stop Restoration: Restore VM disks to previous snapshots without instance downtime
+ Hot Disk Swapping: GCE supports attaching/detaching disks on running VMs
+ Efficient Snapshots: Compressed snapshots minimize storage costs (45 MB for 660 MB data)
+ Data Integrity: Snapshots preserve exact disk state for accurate restoration
- No Data Loss Prevention: Original disk data becomes inaccessible after detachment
! Backup Critical Data: Always verify snapshot contents before relying on restoration
```

### Quick Reference

**Utensils for Snapshot Creation**:
```bash
# Commands to run on VM before creating snapshots
lsblk                    # Check disk devices
ls -la /data/           # Verify current data state

# GCP Console steps (cannot be scripted):
# Compute Engine > Snapshots > Create Snapshot
# Name: snapshot-name
# Source: data-disk
# Compression: Enabled
```

**Disk Mounting Template**:
```bash
# Mount new snapshot-based disk
sudo mkdir -p /data
sudo mount /dev/sdX1 /data  # Replace X with new device letter (e.g., sdc1)
ls -la /data/              # Verify restored data
```

### Expert Insight

#### Real-world Application
- **Disaster Recovery**: Implement point-in-time restoration for critical applications
- **Configuration Rollbacks**: Quickly revert misconfigurations in production environments
- **Data Recovery Testing**: Regularly test snapshot restoration processes without downtime
- **Database Restorations**: Use for database VMs where stopping services is impractical

#### Expert Path
- Master snapshot scheduling with Cloud Scheduler for automated backups
- Implement snapshot retention policies to manage costs
- Use snapshot differentials for efficient incremental backups
- Learn Terraform automation for snapshot management
- Study GCE disk types (Standard, SSD, Balanced) for optimal performance-cost balance

#### Common Pitfalls
- **Storage Costs**: Forgetting to delete old snapshots leads to unexpected bills
- **Mount Issues**: Using wrong device path (`/dev/sdc` vs `/dev/sdc1`) causes mount failures
- **Data Verification**:_Not checking restored data integrity leads to silent data corruption issues_
  - **Resolution**: Always run integrity checks (`md5sum` on files) after restoration
  - **Prevention**: Implement automated verification scripts in deployment pipelines
- **Regional Restrictions**: Snapshots cannot be used across regions without copying first
  - **Resolution**: Choose snapshot region matching VM region
  - **Prevention**: Plan regional architectures considering snapshot portability
- **Attached Disk Limits**: Exceeding VM's maximum additional disk count (15 per zone)
  - **Resolution**: Use regional disks or managed instance groups for scaling
  - **Prevention**: Monitor disk counts and plan for disk consolidation strategies

#### Lesser-Known Facts
- **Snapshot Performance**: Restored disks start with I/O performance equal to source disk type
- **Snapshot Compression**: GCP automatically compresses snapshots, often 60-70% smaller than source data
- **Hot Attach Limitations**: Some OS types have better hot-plug support (Linux > Windows)
- **Snapshot Time**: Creation time depends on data changes, not total disk size
- **Cost Optimization**: Snapshots in same region as VM have lower network costs when restored

**Advantages and Disadvantages**:

| Aspect | Advantages | Disadvantages |
|--------|------------|---------------|
| **Availability** | Zero downtime during restoration | Temporary I/O impact during attach |
| **Cost** | No compute costs during restoration | Potential storage costs for multiple snapshots |
| **Speed** | Instant restoration vs full backup recovery | Longer process than local filesystem rollback |
| **Reliability** | GCP-managed secure snapshots | Reliance on network availability |
| **Flexibility** | Restorable to any VM in same region | Cannot modify snapshot contents directly |

> [!IMPORTANT]
> This restoration method provides high availability but requires careful planning to avoid data inconsistencies. Always test restoration procedures in non-production environments first.

> [!NOTE]
> While demonstrated on data disks, this method works for boot disks too, though boot disk restoration typically requires instance restart, unlike data disk hot-swapping shown here.

> [!WARNING]
> Deleting disks during this process removes access to current data. Ensure you have adequate backups before proceeding with any restoration activities.

**Transcript Corrections Made**:
- "Mya Shh" → "Mahesh" 
- "snap rocks" → "snapshot"
- "disc" → "disk" (multiple instances)
- "sauce disk" → "source disk"
- "Mount us new disk" → "Mount our new disk"
- "l s-" → "ls -l"
- "k o n d o u" → "Go to" (typo in verbal instruction)
- Added missing spaces and punctuation for clarity (e.g., "who" → "whoa, but as part of "who and take" → "whoa and take another snapshot")
