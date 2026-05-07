# Session 22: Revision of Previous Sessions (AWS Storage Services)

**Tags:** AWS-Storage, EBS, EFS, Recycle-Bin, Revision

## Table of Contents

- [Recycle Bin Service Overview](#recycle-bin-service-overview)
- [EBS Encryption and Key Management](#ebs-encryption-and-key-management)
- [EFS (Elastic File System) Overview](#efs-elastic-file-system-overview)
- [EBS vs EFS Comparison](#ebs-vs-efs-comparison)
- [Practical Demonstrations](#practical-demonstrations)
- [Session Summary](#session-summary)

## Recycle Bin Service Overview

### Overview
The Recycle Bin service in AWS protects Elastic Block Store (EBS) snapshots and Amazon Machine Images (AMIs) from accidental deletion, allowing data recovery for a specified retention period.

### Key Concepts / Deep Dive
- **Data Loss Prevention**: When EBS volumes or snapshots are deleted/detached, data is permanently lost without proper backup mechanisms.
- **Snapshot Protection**: Recycle Bin specifically safeguards EBS snapshots, which serve as backups of EBS volumes.
- **Tagging for Management**: Resources (including snapshots) should be tagged for better organization and identification. Example tags include:
  - Team: web
  - Environment: prod
- **Retention Rules**: Define rules to retain critical snapshots in Recycle Bin for a specified duration (retention period).
  - Applicable to tagged resources (e.g., Environment: prod).
  - Retention period determines how long recoverable snapshots are kept.
  - Resources protected: EBS snapshots and AMIs.
- **Recovery Process**: Deleted snapshots can be recovered from the Recycle Bin, restoring data without permanent loss.

### Lab Demo: Creating and Using Recycle Bin
1. Navigate to AWS Recycle Bin service (or via EC2 → Snapshots → Actions → Recycle Bin).
2. **Create Retention Rule**:
   - Rule Name: `my-rule-only-for-prod`
   - Resource Type: EBS snapshot
   - Retention Period: Specify duration (e.g., days, hours).
   - Tags: Environment: prod
   - Click "Create retention rule".
3. **Tag Snapshots**: Ensure snapshots have tags like Environment: prod.
4. **Delete Snapshot**: Go to EC2 → Snapshots → Actions → Delete snapshot (e.g., snap-3).
5. **Recover Snapshot**: In Recycle Bin, select deleted snapshot → Actions → Recover → Click "Recover resources".

> [!IMPORTANT]  
> Always tag resources for better management and cost tracking. Tagging helps in organizing AWS resources efficiently.

| Aspect | Description |
|--------|-------------|
| Retention Rules | Applied to tagged snapshots/AMIs |
| Supported Resources | EBS Snapshots and AMIs |
| Benefits | Prevents accidental deletion, enables recovery |

## EBS Encryption and Key Management

### Overview
AWS Key Management Service (KMS) enables encryption and decryption of EBS volumes, ensuring data security using symmetric keys.

### Key Concepts / Deep Dive
- **Encryption Process**: 
  - EBS volumes can be encrypted; attached volumes inherit encryption.
  - Uses symmetric keys for both encryption and decryption.
  - AWS provides default keys for automatic encryption/decryption.
- **Snapshot Encryption**: Encrypted volumes produce encrypted snapshots; encrypted snapshots create encrypted volumes.
- **Key Management Service (KMS)**: 
  - Generates and manages AWS encryption keys.
  - Used securely for EBS encryption tasks.
- **Volume Creation Workflow**:
  - Create volume from snapshot.
  - Enable encryption during creation.
  - Attach encrypted volume to instance.
- **Volume Modification**: Resize volumes (e.g., from 1GB to 3GB) via EC2 console → Actions → Modify Volume.
- **Encryption for Existing Volumes**: Requires creating a snapshot, then creating a new encrypted volume from that snapshot.

### Lab Demo: Encrypting EBS Volumes
1. **Create Encrypted Volume**:
   - Navigate to EC2 → Volumes → Create Volume.
   - Size: 1GB (or as needed).
   - Enable encryption.
   - Volume Name: `volume-wall-enc`.
2. **Create Snapshot from Volume**:
   - Select volume → Actions → Create Snapshot.
   - Name: `snap-4`.
3. **Attach Volume**: Select volume → Actions → Attach Volume → Select instance and mount point.

```bash
# Check attached volumes in instance
lsblk

# Example output verification (adjust for your mount points)
/dev/xvda1   8:1    0   8G  0 part /
/dev/xvdh    202:112  0   1G  0 part /mnt/ebs-volume
```

4. **Modify Volume Size**:
   - Actions → Modify Volume → New Size: 3GB.
   - Verify size increase (instance may need reboot or resize commands).

> [!WARNING]  
> Modifying volume size may require filesystem resizing; test in non-production environments.

## EFS (Elastic File System) Overview

### Overview
Elastic File System (EFS) is a serverless, scalable file storage service for EC2 instances, providing shared access across multiple instances and availability zones.

### Key Concepts / Deep Dive
- **Storage Types Comparison**:
  - **Block Storage**: EBS (Elastic Block Store).
  - **File Storage**: EFS (Elastic File System).
  - **Object Storage**: S3 (Simple Storage Service).
- **EFS Characteristics**:
  - Serverless and fully elastic.
  - Shared via NFS (Network File System) protocol.
  - Supports multiple clients (Linux, Windows).
  - Accessible across AZs and regions.
- **Storage Classes**:
  - **EFS Standard**: Regional, redundant across multiple AZs for high availability.
  - **EFS One Zone**: Single AZ redundant, cost-effective for intra-AZ use.
- **Use Cases**:
  - Multi-instance shared storage.
  - Disaster recovery with multi-AZ replication.
  - Connect to on-premises via public internet.
  - Multicloud setups.
- **Challenges with EBS Addressed by EFS**:
  - EBS limited to single instance; EFS supports multi-instance.
  - No native replication in EBS; EFS provides multi-AZ.
  - Rigid sizing in EBS; EFS is elastic.
  - No on-premises connectivity in EBS; EFS supports hybrid setups.

### Lab Demo: Creating and Mounting EFS
1. **Create EFS File System**:
   - Search for EFS service → Create file system.
   - Name: `my-shared-storage`.
   - Storage class: Standard (multi-AZ redundancy).
2. **Configure Networking**: Choose subnets and security groups.
3. **Mount to Instance**:
   - Use NFS mount commands (or via EC2 launch wizard: Add shared storage → EFS → Specify mount point like `/var/www/html`).
   ```bash
   # Install NFS client (if needed)
   sudo yum install -y nfs-utils  # For Amazon Linux
   
   # Mount EFS
   sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport [EFS-DNS]:/ /mnt/efs
   
   # Verify mount
   df -h | grep efs
   ```
4. **Test Sharing**: Write files to mounted directory from one instance; verify access from another instance.

> [!NOTE]  
> EFS DNS names are available in the EFS console for mounting.

## EBS vs EFS Comparison

| Feature | EBS (Elastic Block Store) | EFS (Elastic File System) |
|---------|---------------------------|---------------------------|
| Storage Type | Block Storage | File Storage |
| Attachment | Single EC2 instance | Multiple instances (shared) |
| Pricing | Per GB provisioned | Per GB used |
| Elasticity | Pre-provisioned size | Fully elastic (pay-as-you-go) |
| Replication | Third-party tools only | Native multi-AZ replication |
| Protocol | Block-level | NFS (Network File System) |
| Availability | Single AZ (unless configured) | Multi-AZ (Standard class) |
| Use Cases | Boot volumes, databases | Shared web content, file servers |

## Practical Demonstrations

### Additional Commands and Verification
- **Check Disk Usage**: `df -h` (shows mounted filesystems).
- **List Block Devices**: `lsblk` (displays all block devices).
- **Navigate and Test Data Recovery**:
  - Create test file: `echo "Test data" > /mnt/efs/test.txt`
  - Verify on another instance.

```diff
+ Positive Workflow: Create tagged snapshot → Apply retention rule → Safely delete and recover
- Negative Pitfall: Untagged snapshots bypass retention rules, leading to permanent data loss
! Security Note: Enable encryption for sensitive data volumes
```

> [!IMPORTANT]  
> Root volumes in EC2 are EBS-backed by default (8GB minimum), housing OS files.

## Session Summary

```diff
+ Recycle Bin protects EBS snapshots with retention rules and tagging.
+ EFS enables shared, elastic file storage across instances and AZs.
+ Encryption in EBS uses KMS and symmetric keys for data security.
+ EFS overcomes EBS limitations like single-instance attachment and replication.
```

### Key Takeaways
- Use Recycle Bin for snapshot protection against accidental deletion.
- Tag all AWS resources for better management and cost control.
- Choose EBS for block storage needs; EFS for shared file systems.
- Encryption is critical for data security in production environments.

### Quick Reference
- **Retention Rule Creation**: AWS Console → Recycle Bin → Create Retention Rule.
- **EFS Mount Command**: `sudo mount -t nfs [EFS-DNS]:/ /mnt/efs`
- **Volume Encryption**: Enable during creation or via snapshot recreation.
- **Key Services**: Recycle Bin (Snapshots), KMS (Keys), EFS (File storage).

### Expert Insight

#### Real-World Application
Recycle Bin and encrypted EBS are essential for production failover scenarios, while EFS supports multi-instance web farms and hybrid cloud architectures, enabling seamless data sharing across global deployments.

#### Expert Path
Master tagging strategies and cost optimization (e.g., EFS One Zone for lower-cost intra-AZ storage). Deepen knowledge in NFS configurations and KMS key policies for enterprise security compliance.

#### Common Pitfalls
- Deleting untagged snapshots bypasses retention rules, causing unrecoverable data loss.
- Resizing encrypted volumes without verifying filesystem integrity can lead to data corruption.
- Misconfiguring security groups blocks EFS mount attempts; ensure NFS port (2049) is open.
- Assuming EBS provides replication without third-party tools leads to single-point-of-failure risks.

#### Lesser-Known Facts
- EFS One Zone class offers up to 47% lower costs than Standard for single-AZ use cases, ideal for dev/test environments.
- Recycle Bin integrates with AWS Backup for automated retention policies across multiple services.

#### Advantages and Disadvantages
**Advantages of EFS over EBS**:
- Shared access across multiple instances and AZs.
- Automatic scaling without downtime.
- Native encryption and multi-AZ redundancy (Standard class).

**Disadvantages of EFS over EBS**:
- Higher latency compared to directly attached EBS.
- Costlier for small, static workloads.
- Not suitable for high-IOPS database workloads requiring low-latency block storage.
