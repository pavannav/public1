# Session 17: AWS EBS Deep Dive and Storage Comparison

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Multi-Tier Application Review](#multi-tier-application-review)
  - [Storage Types Overview](#storage-types-overview)
  - [Block Storage Deep Dive](#block-storage-deep-dive)
  - [EBS vs Instance Store Comparison](#ebs-vs-instance-store-comparison)
  - [EBS Volume Practical Demonstration](#ebs-volume-practical-demonstration)
  - [EBS Zone-Based Architecture](#ebs-zone-based-architecture)
- [Lab Demos](#lab-demos)
  - [AWS CLI Commands for Instance Types](#aws-cli-commands-for-instance-types)
  - [EBS Volume Creation and Attachment](#ebs-volume-creation-and-attachment)
  - [Partitioning, Formatting, and Mounting EBS Volume](#partitioning-formatting-and-mounting-ebs-volume)
  - [Data Persistence Verification](#data-persistence-verification)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview
This session builds on the previous discussion of multi-tier applications, focusing on AWS storage services, particularly Elastic Block Store (EBS). The instructor provides an in-depth comparison between different block storage options available on AWS EC2, including root volumes, instance store, and EBS volumes. Key emphasis is placed on understanding storage persistence, performance differences, and practical implementation through live demonstrations. The session highlights EBS as a network-attached persistent storage solution, contrasting it with the locally-attached, ephemeral instance store for high-performance use cases.

## Key Concepts and Deep Dive

### Multi-Tier Application Review
✅ **Revision from Session 16**: Multi-tier applications are software systems divided into multiple layers (tiers), each handling specific functions while communicating with others. Example covered: End user → Presentation Layer (WordPress on EC2) → Data Layer (MySQL on RDS).

✅ **Deployment Overview**: Three primary deployment methods for web applications on AWS:
- **EC2 Instance** (manual with Apache HTTPD)
- **Lambda** (serverless)
- **EKS** (containerized with Kubernetes)

✅ **Actual Implementation**: WordPress deployment used EC2 with Apache HTTPD and AWS RDS for managed database service, bypassing self-managed options for reliability and AWS management benefits.

### Storage Types Overview
📝 **Three Main Storage Paradigms in AWS**:
1. **Block Storage**: Raw hard disks requiring partitioning, formatting, and mounting (e.g., EBS, Instance Store)
2. **Object Storage**: Flat file structure with unique keys (S3, Glacier)
3. **File Storage**: Network-attached shared file systems (EFS, NFS)

🔑 **Use Case**: Operating system installation requires block storage as the foundational layer for persistent data (RAM is volatile, storage is permanent).

### Block Storage Deep Dive

#### Root Volume
- **Definition**: Primary storage attached to EC2 instances for OS installation (combination of physical hardware provisioned by AWS hypervisor)
- **Examples**: "C drive" (Windows) or "/" drive (Linux)
- **Persistence**: Ephemeral - lost when instance is terminated (not rebooted)

#### Instance Store (Ephemeral Storage)
- **Definition**: High-performance local block storage physically attached to the host computer's hardware (SSD/flash storage)
- **Key Performance**: Ultra-fast I/O operations (IOPS) due to direct physical attachment
- **Persistence**: Ephemeral - data lost after instance shutdown/restart (not reboot)
- **Cost**: Higher than EBS due to specialized hardware investment
- **Use Cases**: Temporary data (caches, session data, buffers) where persistence isn't required but high performance is critical

#### EBS Volume (Network-Attached Storage)
- **Definition**: Network-based block storage using SAN (Storage Area Network) architecture
- **Technical Implementation**: Volume resides in centralized racks connected via network protocols (FC, iSCSI)
- **Persistence**: Permanent until manually deleted
- **Performance**: Slower than instance store due to network latency, but faster options available

### EBS vs Instance Store Comparison

| Aspect | Instance Store | EBS Volume |
|--------|----------------|------------|
| **Attachment Type** | Direct physical | Network-attached |
| **Persistence** | Ephemeral (terminal persistence) | Permanent (survives instance termination) |
| **Performance** | Ultra-high I/O | Network-limited but optimizable |
| **Cost** | Expensive | Cost-effective |
| **Availability** | Some instance types only | Most instance types |
| **Architecture** | SAN-like (but local) | True SAN |
| **Data Loss Risk** | High on shutdown | Low (network redundancy) |

🔍 **Critical Distinction**: Instance Store provides lightning-fast performance for non-critical temporary data, while EBS offers persistent, cost-effective storage that survives infrastructure changes.

### EBS Volume Practical Demonstration
📋 **Volume Creation Process**:
1. Access EBS service through EC2 console
2. Select volume type (default: General Purpose SSD)
3. Specify size (demonstrated: 1GB)
4. Associate with Availability Zone during creation
5. Attach to running EC2 instance post-launch

📋 **Physical Hardware Equivalent**: Treat EBS like external network-attached pen drives - seemingly local but connected via network cables.

### EBS Zone-Based Architecture
⚠️ **Important Restriction**: EBS volumes are zone-specific (not regional) to minimize latency and maximize performance. Cannot attach Mumbai Zone A volume to Zone B instance.

💡 **Cross-Zone Implications**:
- No direct connection between different zones within same region
- Requires data migration strategies for zone failures
- Backup and restoration mechanisms needed instead of simple attachment

## Lab Demos

### AWS CLI Commands for Instance Types
Discover which EC2 instance types support instance store using AWS CLI filtering:

```bash
# Install AWS CLI and configure credentials
aws configure --profile admin-account
# Enter access key, secret key, default region

# List all instance types with storage details
aws ec2 describe-instance-types --profile admin-account --query 'InstanceTypes[*].[InstanceType,StorageInfo]' --output table

# Filter for instance types supporting instance store
aws ec2 describe-instance-types --profile admin-account --filters Name=supported-virtualization-type,Values=hvm Name=instance-storage-supported,Values=true --query 'InstanceTypes[*].[InstanceType,VCpus,MemoryInfo.SizeInMiB]' --output table
```

### EBS Volume Creation and Attachment
Create and attach an EBS volume to an existing EC2 instance:

```bash
# Launch EC2 instance (Amazon Linux 2 AMI)
aws ec2 run-instances --image-id ami-0c55b159cbfafe1d0 --count 1 --instance-type t2.micro --key-name your-key --security-groups your-sg --profile admin-account

# Create EBS volume (1GB, General Purpose SSD)
aws ec2 create-volume --availability-zone ap-south-1a --size 1 --volume-type gp2 --profile admin-account

# Attach volume to running instance
aws ec2 attach-volume --volume-id vol-1234567890abcdef0 --instance-id i-1234567890abcdef0 --device /dev/xvdf --profile admin-account
```

### Partitioning, Formatting, and Mounting EBS Volume
Prepare raw EBS volume for use (Linux commands):

```bash
# List available block devices
lsblk

# Create partition on new EBS volume (/dev/xvdf)
sudo fdisk /dev/xvdf
# Commands inside fdisk:
# n (new partition)
# p (primary)
# 1 (first partition)
# Enter (default first sector)
# +100M (100MB partition size)
# w (write changes)

# Format partition with ext4 file system
sudo mkfs.ext4 /dev/xvdf1

# Create mount point directory
sudo mkdir /mnt/my-drive

# Mount partition to directory
sudo mount /dev/xvdf1 /mnt/my-drive

# Create test file to verify functionality
echo "Test data in EBS volume" > /mnt/my-drive/test-file.txt
```

### Data Persistence Verification
Demonstrate EBS volume survival through instance lifecycle:

```bash
# Verify attachment and mount status
lsblk
df -h

# Create persistent data on EBS-mounted directory
echo "Persistent data: Created in session 17" > /mnt/my-drive/persistent-data.txt

# Terminate EC2 instance (note the warning about EBS volume deletion)
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0 --profile admin-account

# Launch new EC2 instance and re-attach volume
aws ec2 run-instances --image-id ami-0c55b159cbfafe1d0 --count 1 --instance-type t2.micro --key-name your-key --profile admin-account
aws ec2 attach-volume --volume-id vol-1234567890abcdef0 --instance-id i-new-instance-id --device /dev/xvdf --profile admin-account

# Re-mount and verify data persistence
sudo mount /dev/xvdf1 /mnt/my-drive
cat /mnt/my-drive/persistent-data.txt  # Data remains intact!
```

## Summary

### Key Takeaways
```diff
+ EBS is persistent network-attached block storage for AWS EC2
+ Instance Store offers ultra-high I/O performance but is ephemeral
+ Root volumes are temporary and deleted with instance termination
+ EBS volumes are zone-specific for optimal performance
+ AWS CLI filtering enables discovery of instance type capabilities
+ Manual partitioning, formatting, and mounting required for raw EBS volumes
+ EBS data survives instance failures and terminations
! Choose storage type based on persistence needs and performance requirements
- Avoid assuming all storage attaches automatically like physical drives
- Instance Store data is lost even on simple instance shutdowns (not reboots)
```

### Quick Reference
**Key Commands:**
- `lsblk` - List block devices
- `fdisk /dev/xvdf` - Partition EBS volume
- `mkfs.ext4 /dev/xvdf1` - Format partition
- `mount /dev/xvdf1 /mnt/drive` - Mount to filesystem
- `aws ec2 describe-instance-types --filters Name=instance-storage-supported,Values=true` - Find instance store supported types

**Storage Comparison Table:**
| Type | Persistence | Performance | Cost | Attach Type |
|------|-------------|-------------|------|-------------|
| Root Volume | Ephemeral | Standard | Included | Instance-based |
| Instance Store | Ephemeral | Ultra-high | High | Direct physical |
| EBS Volume | Persistent | Network-limited | Variable | Network-attached |

### Expert Insight

#### Real-world Application
In production environments, **EBS volumes are the go-to choice for application data** requiring persistence across deployments. Combine EBS with EC2 Auto Scaling groups and ELB for resilient architectures where application state needs survival through instance failures. For high-I/O databases, opt for Provisioned IOPS EBS or even migrate to RDS for fully managed database persistence.

#### Expert Path
1. **Master EBS Snapshot Lifecycle**: Learn automated backup creation and restoration
2. **Implement Storage Optimization**: Use CloudWatch metrics to monitor IOPS and throughput, right-size volumes
3. **Explore Advanced Features**: Study multi-attach volumes for shared storage scenarios and gp3 volume types for cost performance
4. **Build Resilient Architectures**: Integrate EBS with Multi-AZ deployments and backup automation
5. **Performance Tuning**: Use AWS Compute Optimizer to identify under-utilized EBS volumes

#### Common Pitfalls
❌ **Assuming EBS Functions Like Local Drives**: Network-attached storage introduces latency - account for this in application design and avoid expecting millisecond response times for large data transfers.

❌ **Ignoring Zone Dependencies**: Planning for disaster recovery requires cross-zone/region data copying strategies since EBS volumes can't be directly attached across zones.

❌ **Underestimating Snapshot Times**: Large EBS volumes take significant time to snapshot - schedule during low-usage windows and consider incremental snapshots for faster backups.

#### Lesser-Known Facts
- **EBS Boot from Snapshot**: You can create AMIs from EBS snapshots, enabling faster instance launches with pre-configured storage
- **Instance Store Conversion**: Some instance types support converting instance store data to EBS using AWS Storage Gateway for migration
- **EBS Encryption Overhead**: Encrypted EBS volumes add zero performance overhead in modern Nitro-system EC2 instances, making default encryption recommended for security
