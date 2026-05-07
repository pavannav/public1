# Session 18: EC2 Storage Deep Dive

## Table of Contents
- [Revision: EBS Types and Concepts](#revision-ebs-types-and-concepts)
- [Introduction to Snapshots](#introduction-to-snapshots)
- [Point-in-Time vs Full Backup](#point-in-time-vs-full-backup)
- [How Snapshots Work Internally](#how-snapshots-work-internally)
- [Use Case: Transferring Volumes Between Availability Zones](#use-case-transferring-volumes-between-availability-zones)
- [Use Case: Increasing Volume Size](#use-case-increasing-volume-size)
- [Use Case: Copying Snapshots to Other Regions](#use-case-copying-snapshots-to-other-regions)
- [Practical Demos](#practical-demos)
- [Summary](#summary)

## Revision: EBS Types and Concepts
### Overview
This session begins with a revision of EBS (Elastic Block Storage) concepts from the previous session. EBS is categorized into root storage (root volume), EBS volume, and instance storage. Key differences include:
- Root storage: Typically the OS drive (e.g., C drive on Windows) where data loss occurs upon OS deletion.
- EBS volume: Persistent external storage attachable to instances.
- Instance store: Fast, local storage attached to the instance/hardware, which is ephemeral.

### Key Concepts
- **Storage Hierarchy**:
  - Raw disk examples: Pen drives, external hard drives.
  - Volume: Block storage term in AWS.
- **Performance Comparison**:
  - EBS: Slower but persistent.
  - Instance store: Very fast but tied to instance lifecycle and costlier.
- **I/O Operations**: Reading/writing on hard disks is measured as input/output operations.
- EBS volumes are network-attached storage, not directly part of the host OS but accessed over the network.

### Code/Config Blocks
```bash
# Creating a partition (example)
sudo fdisk /dev/xvdf  # Assuming /dev/xvdf is the attached EBS volume
# Follow partitioning steps as demonstrated in the session
```

## Introduction to Snapshots
### Overview
Snapshots are highlighted as a critical EBS feature for backup and data management. They enable transferring EBS volumes between availability zones (AZs) or regions, which isn't directly possible without snapshots due to AWS constraints.

### Deep Dive
- **Core Purpose**: Backup creation and point-in-time recovery.
- **Constraint Overcome**: EBS volumes are AZ-bound; snapshots allow data mobility via S3 as the underlying storage.
- **Facility Provided**: Incremental backups, reducing cost and performance impact compared to full backups.

## Point-in-Time vs Full Backup
### Overview
The instructor explains snapshot as a form of incremental or point-in-time backup, contrasting it with traditional full backups.

### Key Concepts
- **Full Backup Drawbacks**:
  - Copies entire data every time (e.g., backing up 60GB data requires 60GB storage each backup).
  - Time-consuming: High copy duration affects performance.
  - Cost: Requires new hardware/storage for each backup.
  - No I/O impact isolation: Slows down applications during backup.
- **Point-in-Time (Incremental) Backup Advantages**:
  - Only backs up delta/changes since last backup (e.g., if only 5GB changed out of 100GB, back up 5GB).
  - Cost-effective: Pay only for changed data, not full volume each time.
  - Performance: Minimal impact on applications due to smaller, faster copies.
  - Versioning: Enables historical point-in-time restores.

### Tables

| Feature            | Full Backup                     | Point-in-Time Backup (Snapshot) |
|-------------------|---------------------------------|------------------------------|
| Data Copied      | Entire volume every time        | Delta/changes only           |
| Cost             | High (full volume size × backups) | Low (delta size × backups)   |
| Time             | Slow (large copies)            | Fast (small changes)         |
| Performance Impact | High (slows app during copy)   | Low (quick, background ops) |
| Versioning       | Manual historical saves       | Automatic timelines         |

### Diff Blocks
```diff
+ Advantages of Snapshots over Full Backups:
+ - Cost savings: Pay only for delta.
+ - Speed: Faster backup/restoration.
+ - Performance: Less I/O impact.
+ - Versioning: Point-in-time recovery.
- Drawbacks of Full Backups:
- - High cost for repetitive full copies.
- - Performance degradation during backups.
- - No efficient delta handling.
```

## How Snapshots Work Internally
### Overview
Internally, snapshots leverage referencing and deduplication to manage backups efficiently without duplicating unchanged data.

### Key Concepts
- **Referencing Concept**: Initial snapshot backs up full volume; subsequent backups reference prior snapshots for unchanged data.
  - Example: Snapshot 1: 10GB backup; Snapshot 2: References Snapshot 1 for 10GB + backs up 5GB new data (total 15GB restored).
- **S3 Storage**: Backups are stored in Amazon S3 (object storage), enabling global access and AZ/region transfers.
- **Billing**: Charged only for delta/changed data, not the full volume size.
- **First Backup**: Copies entire volume; subsequent are incremental.

### Tables

| Snapshot Sequence | Data Backed Up | Total Restore Size | Billing |
|-------------------|----------------|---------------------|---------|
| Snapshot 1       | 10GB (full)    | 10GB               | 10GB   |
| Snapshot 2 (+5GB)| 5GB (delta)    | 15GB (ref. 10GB)      | 5GB    |
| Snapshot 3 (+2GB)| 2GB (delta)    | 17GB (ref. prior)    | 2GB    |

### Alerts
> [!NOTE]
> Snapshots enable versioning, allowing restores to any historical point in time without maintaining multiple full backups.

## Use Case: Transferring Volumes Between Availability Zones
### Overview
EBS volumes are AZ-locked; snapshots facilitate data transfer between AZs for scenarios like disaster recovery or planned maintenance.

### Key Concepts
- **Constraint**: Direct attachment of volume from AZ A to AZ B disallowed.
- **Solution Steps**:
  1. Create snapshot from source volume in AZ A.
  2. Restore volume in AZ B from snapshot.
  3. Attach new volume to instance in AZ B.
- **Benefits**: Enables data mobility for maintenance, DR, or load balancing.

### Diff Blocks
```diff
+ Benefits of Cross-AZ Transfer via Snapshots:
+ - Disaster recovery: Data survives AZ failures.
+ - Planned migrations: Move workloads to different AZs.
+ - Availability: Volumes available in fall-back AZs.
```

## Use Case: Increasing Volume Size
### Overview
Snapshots can create larger volumes from existing data, useful for growing storage requirements.

### Key Concepts
- **Process**: Create snapshot → Restore to new volume with increased size (e.g., 1GB → 2GB).
- **Formatting**: New volume is already formatted; no re-formatting needed beyond mounting.
- **Data Persistence**: Original data intact; extra space added.

### Code/Config Blocks
```bash
# Mount a restored/sized-up volume (example)
sudo mkdir /mnt/my_drive
sudo mount /dev/xvdf /mnt/my_drive
# Data from original volume available immediately
```

## Use Case: Copying Snapshots to Other Regions
### Overview
For regional data transfer (e.g., migrating applications to Singapore from Mumbai), copy snapshots across regions.

### Key Concepts
- **Steps**:
  1. Create snapshot in source region.
  2. Copy snapshot to destination region (e.g., US East 1).
  3. Restore volume in destination region from copied snapshot.
  4. Attach to instance in destination region.
- **Underlying Technology**: S3 object copy over Amazon's global private network; fast and reliable.
- **Cross-Regional Attach**: Volumes restored in new regions can attach to local instances.

### Alerts
> [!WARNING]
> Regional copies involve network transfer costs; ensure S3 pricing awareness for large snapshots.

## Practical Demos
### Overview
The session includes hands-on demos of snapshot creation, volume restoration, AZ transfers, size increases, and regional copies.

### Deep Dive
- **Demo 1: Basic Snapshot Creation**
  - Attach EBS volume to instance (e.g., OS2), create partition, format, mount, add files.
  - Navigate to EBS volume → Actions → Create Snapshot (name: "snapshot_1").
  - Result: Snapshot created quickly; full volume backed up initially.
- **Demo 2: Incremental Snapshot**
  - Add files to volume, create second snapshot.
  - Note: Faster creation due to delta-only backup.
- **Demo 3: Cross-AZ Transfer**
  - Restore volume from snapshot in different AZ (e.g., 1A → 1B).
  - Attach to instance in AZ 1B; mount and verify data persistence.
- **Demo 4: Size Increase**
  - Restore volume with larger size (e.g., 1GB → 2GB) from snapshot.
  - Mount; original files intact + extra space.
- **Demo 5: Regional Transfer**
  - Copy snapshot from Mumbai to US East 1.
  - Create volume in US East 1 from copied snapshot.
  - Attach to Virginia instance; verify data up to snapshot point.

### Code/Config Blocks
```bash
# Basic partition and format commands (from demo)
sudo fdisk /dev/xvdf
# Create partition, write, quit
sudo mkfs.ext4 /dev/xvdf1  # Format
sudo mount /dev/xvdf1 /mnt/my_drive
echo "Example data" > /mnt/my_drive/file.txt
```

### Tables

| Demo Step                  | Command/Action              | Outcome                        |
|----------------------------|----------------------------|-------------------------------|
| Attach Volume             | Via AWS Console           | Volume connected to instance  |
| Create Files              | echo/touch commands       | Volume populated               |
| Snapshot Creation        | AWS Console → Create Snapshot | Backup point created          |
| Restore Volume           | Create Volume from Snapshot | New volume with data replication |
| Cross-AZ Mount          | mount /dev/xvdf1          | Data accessible in new AZ      |

## Summary
### Key Takeaways
- Snapshots enable cost-effective, performant backups via incremental (point-in-time) methods.
- Reference mechanism allows versioning and historical restores without duplicate storage.
- Facilitates AZ/region transfers, size increases, and disaster recovery.
- Internally uses S3 for global accessibility and delta billing.

### Quick Reference
- **Snapshot Creation**: EBS Volume → Actions → Create Snapshot.
- **Volume Restoration**: Snapshot → Actions → Create Volume.
- **Cross-Region Copy**: Snapshot → Actions → Copy Snapshot (select destination region).
- **Key Commands**:
  ```bash
  sudo fdisk /dev/xvdf  # Partition
  sudo mkfs.ext4 /dev/xvdf1  # Format
  sudo mount /dev/xvdf1 /mnt/dir  # Mount
  ```

### Expert Insight
**Real-world Application**: Use snapshots for nightly backups of critical databases in EBS; automate via AWS Backup or Lambda to ensure point-in-time recovery for compliance.

**Expert Path**: Master snapshot scheduling with AWS Backup plans for automated backups. Explore lifecycle policies to transition older snapshots to S3 Glacier for cost optimization.

**Common Pitfalls**: Avoid assuming snapshots replicate live changes (they're static backups); remember initial snapshot copies full volume. Overlook S3 costs for cross-region copies on large volumes.

**Lesser-Known Facts**: Snapshots can create AMIs (Amazon Machine Images) by combining with instance data; consider snapshot sharing for multi-account architectures.

> [!IMPORTANT]
> Snapshots are foundational for EBS resilience, enabling geographic distribution and capacity scaling without data loss.
