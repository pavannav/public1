# Session 19: Advanced EBS Features and Snapshots

## Table of Contents

- [EBS Snapshot Revision](#ebs-snapshot-revision)
- [EBS Volume Features](#ebs-volume-features)
- [Recycle Bin for EBS Snapshots](#recycle-bin-for-ebs-snapshots)
- [Tagging AWS Resources](#tagging-aws-resources)
- [EBS Encryption](#ebs-encryption)
- [Modifying EBS Volumes](#modifying-ebs-volumes)
- [AMI Introduction](#ami-introduction)
- [EKS Training Announcement](#eks-training-announcement)
- [Summary](#summary)


## EBS Snapshot Revision

### Overview
This session begins with a comprehensive revision of EBS snapshots covered in the previous session, including backup concepts and practical demonstrations of creating and managing snapshots for data transfer and backup purposes.

### Key Concepts / Deep Dive
EBS snapshots serve as point-in-time backups for EBS volumes, addressing critical data protection needs in AWS environments.

**Backup Types and Challenges:**
- **Full Backup**: Complete copy of all data at specific point. Challenges include time consumption, resource intensive, and performance impact during backup operations.
- **Incremental Backup**: Only backs up changed data since last backup, more efficient than full backup.
- **Point-in-Time Backup**: Creates backup at specific moment without performance impact, enabling consistent data recovery.

**How Snapshots Work:**
- AWS manages snapshots internally in S3
- Snapshots are global service, allowing cross-region operations
- Incremental nature - only store changed blocks
- No performance impact on running volumes during snapshot creation
- Supports volume restoration and cross-region copying

### Lab Demos: Snapshot Management

**Creating Snapshots:**
1. Go to EC2 Dashboard → Volumes
2. Select volume (e.g., os1-extra-HD)
3. Actions → Create snapshot
4. Name: `snap-one`, add description if needed
5. Create snapshot

**Creating Volume from Snapshot:**
1. Go to Elastic Block Store → Snapshots
2. Select snapshot (e.g., snap-2)
3. Actions → Create volume
4. Choose availability zone (e.g., ap-south-1b)
5. Set size (e.g., 2GB)
6. Create volume

**Transfering Data Across Regions:**
1. Create copy of snapshot in destination region (e.g., North Virginia/us-east-1)
   - Select snapshot → Actions → Create copy
   - Set destination region: us-east-1
   - Description: "snap in AP South one"
2. Create volume from copied snapshot in us-east-1
3. Attach volume to instance in us-east-1
4. Mount volume and verify data
   ```bash
   mount /dev/xvdh /data
   ls -l /data
   # Verify linux folder linuxworld.xt with content
   ```

## EBS Volume Features

### Overview
Additional configuration options for EBS volumes including deletion behavior and cross-environment transfer capabilities.

### Key Concepts / Deep Dive
EBS volumes provide flexible block storage with several advanced features for better resource management and data mobility.

**Delete on Termination:**
- Controls whether EBS volume is automatically deleted when EC2 instance terminates
- **Use Cases:**
  - Keep extra volumes for data persistence
  - Auto-delete temporary volumes to avoid costs
- Default: Disabled for extra volumes

**Data Transfer Capabilities:**
- Transfer EBS volumes between availability zones
- Copy snapshots across regions for disaster recovery
- Supports creating launch instances and volumes in different regions from snapshots

### Lab Demos: Volume Management

**Setting Delete on Termination (Conceptual):**
- When launching instance → Add storage → Volume settings
- Uncheck "Delete on termination" for volumes you want to keep
- OR: After creation, modify termination protection in volume settings

## Recycle Bin for EBS Snapshots

### Overview
AWS Recycle Bin provides protection against accidental deletion of EBS snapshots, allowing recovery within a specified retention period.

### Key Concepts / Deep Dive
Recycle Bin introduces safety net for backup lifecycle management, similar to recycle bins in operating systems.

**Key Features:**
- **Retention Rules**: Define how long deleted snapshots are retained (1 day to 1 year minimum)
- **Recovery**: Restore deleted snapshots within retention period
- **Rules Management**:
  - Create rules by resource tag (e.g., environment=production)
  - Apply to all snapshots or specific tagged snapshots
  - Multiple rules allowed for different scenarios

**Use Cases:**
- Production environment snapshots with 1-year retention
- Development snapshots with 1-day retention
- Prevent accidental deletion costs and recovery challenges

### Lab Demos: Recycle Bin Configuration

**Creating Retention Rule:**
1. Go to Recycle Bin service
2. Select "Create retention rule"
3. Name: "Production Snapshot Rule"
4. Resource type: EBS snapshots
5. Retention period: 10 days
6. Tag-based rule:
   - Key: environment
   - Value: production
7. Create rule

**Recovering Deleted Snapshot:**
1. Delete snapshot with environment=production tag
2. Go to Recycle Bin → Resources
3. Select deleted snapshot
4. Click "Recover"
5. Snapshot restored to original location

> [!NOTE]
> Recycle Bin only applies to snapshots, not EBS volumes directly. Use snapshots to protect volume data through Recycle Bin.

## Tagging AWS Resources

### Overview
AWS tagging enables effective resource organization and management across large cloud environments through metadata classification.

### Key Concepts / Deep Dive
Tags are key-value pairs attached to AWS resources for identification and organization.

**Common Tagging Strategies:**
- **Environment**: dev, test, production
- **Team**: web-team, db-team, devops
- **Project**: project-alpha, beta
- **Cost Center**: finance, marketing
- **Owner**: john.doe, dev-team

**Benefits in AWS Services:**
- **Batch Operations**: Apply actions to resources with specific tags
- **Cost Management**: Track and allocate costs by tags
- **Compliance**: Enforce policies based on tags
- **Automation**: Use tags in Lambda, Systems Manager, and lifecycle policies

### Lab Demos: Resource Tagging

**Adding Tags to Resources:**
1. Select EC2 instance → Actions → Instance settings → Manage tags
2. Add tags:
   - Key: environment, Value: production
   - Key: team, Value: web-team
3. Apply same concept for EBS volumes and snapshots

## EBS Encryption

### Overview
EBS encryption provides data-at-rest security by encrypting volume data using AES-256 encryption, ensuring sensitive data remains protected.

### Key Concepts / Deep Dive
Encryption addresses security concerns about data stored on physical disks in AWS data centers.

**Data Security Concepts:**
- **Data at Rest**: Information stored on disks/media (concern: physical access)
- **Data in Transit**: Information moving between systems

**Encryption Mechanics:**
- Uses SSL/TLS for management operations
- KMS service manages encryption keys
- Auto-decryption on supported instances (no manual intervention)
- Double encryption not allowed (can't encrypt already encrypted volumes)

**Performance Impact:**
- Minimal performance overhead but does impact read/write speeds
- CPU usage increases slightly for encryption/decryption operations
- Full encryption/decryption transparent to applications

**Supported Instance Types:**
- Most current generation instances support EBS encryption
- Xen hypervisor has some limitations (check AWS documentation)
- Nitro hypervisor instances typically support all encryption

### Lab Demos: Encrypted EBS Volumes

**Creating Encrypted Volume:**
1. Go to Volumes → Create volume
2. Set encryption: Enabled
3. Select KMS key:
   - Default `aws/ebs` key (AWS managed)
   - OR custom KMS key for cross-account scenarios
4. Create volume
5. Attach to supported instance (no decryption required)

**Encrypting Existing Unencrypted Volume:**
1. Create snapshot from unencrypted volume
2. Create new volume from snapshot with encryption enabled
3. Attach encrypted volume and detach old unencrypted volume
4. Resize filesystem if needed

## Modifying EBS Volumes

### Overview
Modify volume feature allows size and performance changes without downtime, demonstrating AWS elasticity concept.

### Key Concepts / Deep Dive
AWS elasticity enables resource scaling without interruption, fundamental to cloud computing.

**Modify Capabilities:**
- **Size**: Increase from 1GB to 16TB maximum
- **Type**: Change between GP2, GP3, IO1, IO2, etc. for different IOPS and throughput
- **Throughput**: Adjust based on workload requirements

**Key Challenge: Filesystem Resizing**
AWS handles physical disk expansion, but filesystem requires manual expansion for utilization.

**Filesystem Types:**
- **EXT4/XFS**: Support online resizing without unmounting
- **EXT3**: Supports decrease/increase with limitations

### Lab Demos: Volume Modification

**Increasing Volume Size:**
1. Select volume → Actions → Modify volume
2. Increase size (e.g., 1GB → 4GB)
3. Modify volume (no downtime)

**Filesystem Resizing (EXT4):**
```bash
# Check current size
df -h
lsblk

# Resize filesystem
sudo resize2fs /dev/xvdh

# Verify
df -h
```

> [!WARNING]
> If volume formatted directly without partitions, DF command may not reflect physical size increase until filesystem resize. Use resize2fs or growfs commands based on filesystem type.

**Volume Modification Examples:**

| Modification Type | Impact | Command/Process |
|-------------------|---------|----------------|
| Size Increase | Instant physical expansion | resize2fs (ext4) |
| Type Change | Performance adjustment | Throughput/IOPS change |
| Size Decrease | Data loss risk | EXT4/EXT3 only |

## AMI Introduction

### Overview
AWS Machine Images (AMIs) are pre-configured templates for EC2 instances, containing OS and application configurations.

### Key Concepts / Deep Dive
AMIs enable rapid instance deployment with consistent configurations. Detailed coverage in next session includes creating custom AMIs from instances and AMI lifecycle management.

## EKS Training Announcement

### Overview
AWS Elastic Kubernetes Service (EKS) core training announcement for free access to cloud enablement students.

### Key Concepts / Deep Dive
**EKS Training Benefits:**
- **Core/Basic Training**: Free for cloud enablement students
- **Advanced Training**: Separate session for professional students
- **Prerequisites**: Basic AWS knowledge (no Kubernetes required)
- **Format**: Weekend training (Saturday/Sunday)
- **Outcomes**: Hands-on projects, certificates

**EKS Value Proposition:**
- High-demand skill set
- Complete AWS-managed Kubernetes service
- Enhances cloud career prospects

## Summary

### Key Takeaways
```diff
+ EBS Snapshots provide point-in-time backups without performance impact
+ Recycle Bin protects against accidental snapshot deletion
+ Encryption secures data at rest automatically on supported instances
+ Volume modifications enable elastic scaling and performance adjustments
+ Filesystem resizing required after physical volume size changes
+ EKS training provides free advanced Kubernetes training
- Avoid full backups due to time and performance costs
- Must resize filesystem after volume size modifications
- Encryption impacts performance (minimal but measurable)
```

### Quick Reference

**Backup Types Comparison:**
| Type | Description | Advantages | Disadvantages |
|------|-------------|------------|--------------|
| Full Backup | Complete data copy | Complete recovery | Time/resource intensive |
| Incremental | Changed data only | Faster | Complex recovery chain |
| Point-in-Time (Snapshot) | AWS-managed incremental | Zero performance impact, global access | Based in S3 |

**Common EBS Commands:**
```bash
# Check disk usage
df -h

# List block devices
lsblk

# Mount volume (example)
mount /dev/xvdh /mnt/data

# Resize EXT4 filesystem
sudo resize2fs /dev/xvdh

# Create filesystem (if needed)
sudo mkfs.ext4 /dev/xvdh
```

**Volume Modification Process:**
1. Modify volume in AWS Console
2. Wait for modification complete
3. Resize filesystem if size increased
4. Verify with df -h command

### Expert Insight

#### Real-world Application
In production environments, implement multi-region snapshots for disaster recovery. Use Recycle Bin retention rules (e.g., 30-365 days) for critical backups. Tag all resources systematically for cost management and automation. Enable EBS encryption for compliance requirements (HIPAA, PCI-DSS).

#### Expert Path
Master EKS fundamentals through free sessions, then pursue CKAD/CKA certifications. Study KMS service for advanced encryption scenarios. Learn CloudFormation/Terraform for automated EBS resource provisioning. Practice multi-AZ deployments with encrypted volumes.

#### Common Pitfalls
- Forgetting filesystem resize after volume modification leads to unused capacity
- Snapshot restoration to wrong region causing data transfer costs
- Using expensive volume types (io1/io2) inappropriately for non-IOPS workloads
- Not enabling Recycle Bin in production, risking data loss
- Incompatible instance types for encrypted volumes

#### Lesser-Known Facts
- Snapshots can be created from encrypted volumes but cannot be re-encrypted
- Volume modifications can be scheduled during maintenance windows
- EBS volumes can be shared between accounts using RAM (Resource Access Manager)
- Recycle Bin stores deleted snapshots temporarily, incurring storage costs
- EBS performance (IOPS) scales automatically with volume size for GP2 type

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
