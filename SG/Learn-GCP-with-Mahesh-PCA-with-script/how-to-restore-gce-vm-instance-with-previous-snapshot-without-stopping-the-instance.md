## Transcript Corrections
> [!NOTE]
> Corrected the following errors found in the transcript for accuracy:
> - "Mya Shh" → "Mahesh"  
> - "snap rocks" → "snapshot"  
> - "kondou" → "Go to"  
> - "discuss" → "disk"  
> - Disk names: "SD B" → "sdb", "SD C" → "sdc", "big image" → likely a filename like "bigimage.jpg", "who" → likely another filename like "whocopy.jpg"  
> - Command corrections: "mount us new disk SDC" → "mount /dev/sdc /mnt/data", added proper syntax where inferred from context  

# Session 1: How to Restore GCE VM Instance with Previous Snapshot Without Stopping the Instance

## Table of Contents
- [Introduction](#introduction)  
- [Creating Snapshots](#creating-snapshots)  
- [Restoring from a Previous Snapshot](#restoring-from-a-previous-snapshot)  
- [Summary](#summary)  

## Introduction
### Overview  
This session demonstrates how to restore a Google Cloud Platform (GCP) Compute Engine (GCE) virtual machine (VM) instance to a previous state using disk snapshots, without stopping or restarting the instance. The process involves creating snapshots of data disks, then swapping the current disk with a new one restored from an earlier snapshot by editing the VM's disk configuration in the GCP Console. This approach allows for data restoration while maintaining instance availability, which is crucial for production environments where downtime must be minimized.  

### Key Concepts/Deep Dive  
- **GCP VM Instance Structure**: VMs in GCP consist of boot disks (OS) and optional additional disks (data). The boot disk contains the operating system and cannot be easily snapshot-replaced while running, but additional data disks can be detached and reattached dynamically.  
- **Disk Snapshots**: Incremental backups of persistent disks that capture the disk's state at a point in time. Snapshots are compressed and stored in Cloud Storage, consuming minimal storage (e.g., 45MB for 660MB actual data in this demo).  
- **Live Disk Replacement**: Unlike EC2 in AWS, GCE allows editing instance configurations (including disk changes) without stopping the VM. This enables zero-downtime restoration.  
- **Mounting and Data Persistence**: After attaching a new disk from a snapshot, administrators must manually remount it to maintain data access paths. The original disk remains attached until explicitly detached during the edit process.  

### Lab Demo: Preparing the Environment  
1. **Navigate to VM Instance**: In GCP Console, go to "Compute Engine" → "VM instances" and select the target instance.  
2. **Inspect Current Disks**: Assume the instance has:  
   - Boot disk: 10GB (OS disk)  
   - Data disk: 20GB (persistent disk, named "data-disk" mapped to `/dev/sdb` internally)  
3. **Check Existing Data**: SSH into the VM and run `lsblk` to confirm disk mapping:  
   ```bash
   lsblk
   ```  
   Output should show `/dev/sdb` with data. Run `ls /mnt/data` to verify contents (e.g., a 660MB file present).  

## Creating Snapshots  
### Overview  
Snapshots serve as point-in-time backups of disks. This section covers creating initial and subsequent snapshots to demonstrate incremental changes and prepare for restoration. Understanding snapshot timing and naming conventions helps organize backups for production scenarios.  

### Key Concepts/Deep Dive  
- **Snapshot Creation Process**:  
  - Source: Persistent disks (boot or additional disks)  
  - Compression: Enabled by default to reduce storage cost  
  - Location: Regional (US-central1 in demo) for latency optimization  
- **Incremental Nature**: First snapshot captures full disk state; subsequent snapshots are differential, only storing changes.  
- **Snapshot Metadata**: Each snapshot includes creation time, source disk size, and compression details.  
- **Storage Efficiency**: Even large disks produce small snapshots if data is compressible (e.g., text/images vs. random data).  

### Lab Demo: Creating First Snapshot  
1. **Navigate to Disks Page**: In GCP Console, go to "Compute Engine" → "Disks".  
2. **Select Data Disk**: Click on the 20GB data disk used by the VM instance.  
3. **Create Snapshot**: Click "Create snapshot" with:  
   - Name: `snapshot-with-one-big-image`  
   - Source disk: Select the data disk  
   - Region: Same as VM (e.g., US-central1)  
   - Compression: Enabled (default)  
4. **Monitor Creation**: Click "Create". The snapshot operation completes quickly. Check "Snapshots" page for status and size (e.g., 45MB for 660MB of data).  

### Lab Demo: Adding Data and Creating Second Snapshot  
1. **Simulate Data Change**: In VM SSH session, copy the existing file to create additional content:  
   ```bash
   cp /mnt/data/bigimage.jpg /mnt/data/whocopy.jpg
   ```  
   Now `ls /mnt/data` shows two files.  
2. **Create Second Snapshot**: Return to GCP Console, Disks page.  
   - Select the same data disk.  
   - Click "Create snapshot" with:  
     - Name: `snapshot-with-two-big-images`  
     - Same configuration as first snapshot.  
   - Click "Create" and verify completion.  

## Restoring from a Previous Snapshot  
### Overview  
Restoration involves replacing the current data disk with a new disk created from a historical snapshot, performed through instance editing without downtime. This method preserves the VM's running state while reverting data to a prior snapshot. Post-attachment, manual mounting ensures applications can access restored data.  

### Key Concepts/Deep Dive  
- **Live Instance Editing**: GCP allows dynamic disk changes on running instances, unlike some cloud providers requiring shutdown.  
- **Disk Swap Process**: Detach old disk → Attach new disk from snapshot → Mount externally → Delete old disk (via console or API).  
- **Data Integrity**: Snapshot-based disks guarantee exact replication of the snapshot's state.  
- **Path Consistency**: Mounting at the same mount point (`/mnt/data`) maintains application compatibility.  
- **Performance Impact**: Brief I/O pause during attachment; no full reboot needed.  
- **Limitations**: Only additional disks can be replaced this way; boot disks require instance stop.  

| Step | Action | GCP Console Location | Notes |
|------|--------|----------------------|-------|
| 1 | Edit Instance | VM Instances → Select VM → Edit | No instance stop required |
| 2 | Detach Old Disk | Scroll to "Additional disks" → Delete existing data disk | Disk service saved; data accessible until deletion |
| 3 | Attach New Disk | Click "Add new disk" → "Disk from snapshot" | Select target snapshot |
| 4 | Mount New Disk | VM SSH terminal | Required for data access |
| 5 | Delete Old Disk | Disks page (optional) | Cleans up unattached resources |

### Lab Demo: Performing Restoration  
1. **Stop and Detach Old Disk**:  
   - In GCP Console, go to "Compute Engine" → "VM instances".  
   - Select the running VM → Click "Edit".  
   - Scroll to "Additional disks".  
   - Delete the existing data disk (do not attach a new one yet).  
   - Click "Save" to apply changes.  

2. **Attach New Disk from Snapshot**:  
   - Return to same VM instance "Edit" page.  
   - Under "Additional disks", click "Add new disk".  
   - Select "Disk from snapshot".  
   - Choose snapshot: `snapshot-with-one-big-image`.  
   - Set disk name (auto-generated, e.g., "data-disk-1").  
   - Click "Done" → "Save".  

3. **Verify Disk Attachment**:  
   - SSH back to VM and run `lsblk`:  
     ```bash
     lsblk
     ```  
     Original `/dev/sdb` should be gone; new `/dev/sdc` now visible.  

4. **Mount Restored Disk**:  
   - Create mount directory (usually `/mnt/data`):  
     ```bash
     mkdir -p /mnt/data
     ```  
   - Mount the new disk:  
     ```bash
     mount /dev/sdc /mnt/data
     ```  
   - Verify content:  
     ```bash
     ls -la /mnt/data
     ```  
     Should show only one file (e.g., `bigimage.jpg`), confirming restoration to pre-second-copy state.  

💡 **Pro Tip**: Mount with filesystem type if auto-detection fails:  
```bash  
mount -t ext4 /dev/sdc /mnt/data  
```  

## Summary  
```diff
+ Key Takeaways:
+ Snapshots provide efficient, compressed backups of GCP disks without downtime.
+ VM instances can be restored via disk swap by detaching/attaching disks from snapshots.
+ Hands-on benefits: Restore data state instantly; maintain VM availability.
+ Lab validation: Simulated data changes and rebuild confirmed restoration success.
! Always verify mount points and file permissions post-restoration.
```

### Expert Insight  
#### Real-world Application  
In production, use this for disaster recovery of application data (e.g., databases, logs) without service interruption. Automate via gcloud CLI scripts triggered by monitoring alerts, or Terraform for infrastructure-as-code deployments.  

#### Expert Path  
Master snapshot automation with Cloud Scheduler for daily backups and gcloud commands (e.g., `gcloud compute disks snapshot-create disk-name --snapshot-names weekly-backup`). Integrate with Cloud Build for CI/CD pipelines that snapshot before major deployments.  

#### Common Pitfalls  
⚠ **Mount Failures**: Occur if filesystem is corrupted – resolution: Run `fsck /dev/sdc` or restore from a different snapshot.  
⚠ **Snapshot Inconsistencies**: IO-heavy workloads may cause inconsistent snapshots – avoid by using consistent snapshots or pausing writes briefly.  
⚠ **Disk Deletion Risks**: Immediate old disk deletion loses access to current state – retain temporarily for rollback.  
⚠ **Region Mismatches**: Cross-region snapshots increase latency – always create snaps in same region as VM.  

### Lesser Known Aspects  
- Snapshots support cross-region copying for DR, but incur transfer costs.  
- Multi-attach disks allow read-only sharing across instances, useful for shared databases.  
- Snapshot expiration policies (via lifecycle management) prevent unbounded storage growth.  
- Using CSI drivers in GKE enables similar disk operations programmatically.  
- Compression ratios vary wildly (e.g., 90% for text logs vs. 10% for encrypted data).  

---  
🤖 Generated with [Claude Code](https://claude.com/claude-code)  

Co-Authored-By: Claude <noreply@anthropic.com>  

<summary>CL-KK-Terminal</summary>  
<model_id>claude-sonnet-4-5-20250929</model_id>
