# Session 19: EBS Snapshots and Management

## Table of Contents

- [EBS Volume Management](#ebs-volume-management)
  - [Overview](#overview)
  - [Key Concepts](#key-concepts)
  - [Lab Demos](#lab-demos)
- [Snapshots](#snapshots)
  - [Overview](#overview-1)
  - [Key Concepts](#key-concepts-1)
  - [Lab Demos](#lab-demos-1)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## EBS Volume Management

### Overview
EBS (Elastic Block Store) volumes provide persistent block storage for EC2 instances in AWS, serving as virtual hard disks. This session covers EBS volume fundamentals including creation, encryption, modification, and management features like delete on termination. EBS volumes offer elasticity, allowing dynamic resizing without losing data, and support various volume types for different performance needs.

### Key Concepts

#### EBS Volumes
EBS volumes are network-attached storage that can be attached to EC2 instances. Key characteristics:
- Size range: 1 GB to 16 TB
- Types: GP2/GP3 (general purpose), IO1/IO2 (provisioned IOPS), ST1 (throughput optimized), SC1 (cold HDD)
- Elastic: Can increase size on-the-fly
- Persistent: Data survives instance termination
- Multi-attach: Some volume types support attachment to multiple instances

#### Volume Encryption
EBS encryption protects data at rest using AES-256 encryption. Key points:
- Encrypts data blocks before writing to disk
- Uses AWS KMS keys for encryption/decryption
- Transparent to applications and instances
- Can encrypt existing volumes via snapshot recreation
- Performance impact: Slight I/O overhead

❗ **IMPORTANT**  
Encryption requires instances with encryption support. T2 instances and earlier generations may not be compatible.

#### Modifying Volumes
AWS allows online modification of EBS volumes:
- Increase size up to 16 TB
- Change volume type and IOPS
- Process is elastic and doesn't require instance stoppage
- File system must be extended after volume size increase

⚠️ **WARNING**  
Resizing requires file system extension. Failure to resize the file system means you can't use the additional space.

#### Delete on Termination
Controls what happens to EBS volumes when EC2 instance is terminated:
- By default: Root volume deletes, additional volumes persist
- Configurable per volume during instance launch or modification
- Useful for preserving data volumes in multi-volume setups

### Lab Demos

#### Creating and Attaching Encrypted Volumes
```bash
# Example workflow (conceptual)
# 1. Create EC2 instance
aws ec2 run-instances --image-id ami-12345 --instance-type t2.micro

# 2. Create encrypted EBS volume
aws ec2 create-volume --size 8 --availability-zone us-east-1a --encrypted --kms-key-id alias/aws/ebs

# 3. Attach volume to instance
aws ec2 attach-volume --volume-id vol-12345 --instance-id i-12345 --device /dev/sdf

# 4. Mount and format (inside EC2 instance)
sudo mkfs -t ext4 /dev/xvdf
sudo mkdir /data
sudo mount /dev/xvdf /data
```

#### Modifying Volume Size
```bash
# Example: Increase volume from 1GB to 4GB
# AWS Console: EC2 → Volumes → Select volume → Actions → Modify Volume
# Set new size and apply

# After volume resizing, extend file system (inside EC2 instance)
# For ext4 filesystem:
sudo resize2fs /dev/xvdf

# For XFS filesystem:
sudo xfs_growfs /data

# Verify with df -h
df -h /data
```

## Snapshots

### Overview
EBS snapshots are point-in-time backups of EBS volumes stored in Amazon S3. They provide data protection, disaster recovery, and enable creating new volumes from backups. Snapshots are incremental, meaning only changed blocks are stored after the initial full backup, making them cost-effective and space-efficient.

### Key Concepts

#### What are Snapshots
Snapshots fundamentally change how backups work compared to traditional full backups:
- **Incremental**: Capture only changed blocks after initial full snapshot
- **Stored in S3**: Durable, highly available storage
- **Global service**: Can be copied across regions
- **Point-in-time recovery**: Restore to exact moment of snapshot creation
- **Faster than full backups**: No performance impact during creation

#### Creating and Managing Snapshots
Two methods to create snapshots:
1. **From volume**: Volume actions → Create snapshot
2. **From EC2 service**: Snapshots section → Create snapshot

Management features:
- **Tagging**: Organize snapshots (backup type, environment, team)
- **Lifecycle policies**: Automate snapshot creation and deletion
- **Multi-volume consistency**: Application-consistent snapshots possible with coordination

#### Copying Snapshots Across Regions
Enable cross-region disaster recovery and data migration:
- Source snapshot → Actions → Create copy
- Specify destination region
- Encrypted snapshots maintain encryption in target region
- Useful for compliance (data residency) and proximity (latency optimization)

#### Recycle Bin for Snapshots
Protect against accidental deletion (recent feature):
- Configure retention rules (1 day to 1 year)
- Tagged snapshots can have specific policies
- Restore deleted snapshots within retention period
- Cost-effective backup strategy with safety net

```diff
! Full Backup → Full time/space → Performance impact → Costly
+ Incremental Snapshot → Only changes → No performance impact → Cost-effective
```

### Lab Demos

#### Creating Incremental Snapshots
```bash
# Create initial snapshot (full backup conceptually)
aws ec2 create-snapshot --volume-id vol-12345 --description "Initial backup"

# Add data to volume, then create second snapshot
echo "New data" > /data/newfile.txt

# Second snapshot (only captures changes)
aws ec2 create-snapshot --volume-id vol-12345 --description "Incremental backup"
```

#### Cross-Region Snapshot Copy
```bash
# Create snapshot copy to different region
aws ec2 copy-snapshot --source-region us-east-1 --source-snapshot-id snap-12345 --destination-region us-west-2 --description "DR copy"

# Create volume from copied snapshot
aws ec2 create-volume --snapshot-id snap-67890 --availability-zone us-west-2a

# Attach to instance
aws ec2 attach-volume --volume-id vol-abcde --instance-id i-54321 --device /dev/sdg
```

#### Snapshot Recycle Bin Setup
```bash
# Create retention rule (conceptual via AWS Console)
# 1. Navigate to Recycle Bin service
# 2. Create rule:
#    - Resource type: EBS snapshots
#    - Retention period: 10 days
#    - Tags: Environment=Production
# 3. Delete tagged snapshot
# 4. Restore from Recycle Bin within 10 days
aws rbin create-rule --retention-period 10 --resource-type EBS_SNAPSHOT
```

## Summary

### Key Takeaways
```diff
+ EBS volumes provide elastic, persistent block storage for EC2 instances
+ Snapshots enable incremental backups with no performance impact
- Traditional full backups are time-consuming and costly compared to snapshots
+ Encryption protects data at rest transparently
- Failing to extend file systems after volume resize wastes allocated space
+ Recycle Bin protects against accidental snapshot deletion
```

### Quick Reference
- **Create encrypted volume**: `aws ec2 create-volume --encrypted`
- **Extend ext4 filesystem**: `sudo resize2fs /dev/xvdf`
- **Extend XFS filesystem**: `sudo xfs_growfs /mountpoint`
- **Create snapshot**: Volume → Actions → Create snapshot
- **Copy snapshot**: Snapshot → Actions → Create copy
- **Recycle Bin retention**: 1 day minimum, 1 year maximum

### Expert Insight

#### Real-world Application
In production environments, EBS snapshots are critical for:
- **Disaster recovery**: Multi-region snapshots ensure business continuity
- **Dev/Test environments**: Clone production volumes without data transfer delays
- **Cost optimization**: Incremental backups reduce storage costs significantly
- **Compliance**: Encrypted volumes meet data security regulations
- **Blue/green deployments**: Rapid environment provisioning from snapshots

#### Expert Path
To master EBS management:
- **Understand I/O characteristics**: Choose volume types (GP3 for most cases, IO2 for databases)
- **Implement automation**: Use CloudWatch alarms for snapshot creation failures
- **Design for performance**: Size volumes appropriately to avoid over-provisioning
- **Security-first approach**: Always encrypt sensitive data volumes
- **Monitoring and alerting**: Track volume utilization and set up automated snapshots

#### Common Pitfalls
- **File system resize oversight**: Capacity increased but unusable due to unextended file system
- **Snapshot tagging negligence**: Poor organization leads to cleanup challenges
- **Encryption compatibility**: Using unsupported instance types with encrypted volumes
- **Cross-region copy costs**: Data transfer charges for large snapshots
- **Recycle Bin over-reliance**: Deleted data beyond retention period is permanently lost

#### Lesser-Known Facts
- Snapshots are stored redundantly across multiple AZs in S3
- Deleted volumes can be recovered from snapshots within S3 retention periods
- EBS volumes support up to 28 attachments for multi-attach enabled instance types
- Snapshot creation is crash-consistent; use application-consistent methods for databases
- AWS charges for snapshot storage but data transfer between EBS and snapshots is free

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
