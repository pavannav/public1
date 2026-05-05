# Section 4: AWS Storage Basics

<details open>
<summary><b>Section 4: AWS Storage Basics (CL-KK-Terminal)</b></summary>

## Table of Contents
- [4.1 AWS Storage Basics: An Essential Overview](#41-aws-storage-basics-an-essential-overview)
- [4.2 Difference Between Instance Store & EBS Volume Part 1](#42-difference-between-instance-store--ebs-volume-part-1)
- [4.3 Difference Between Instance Store & EBS Volume Part 2](#43-difference-between-instance-store--ebs-volume-part-2)
- [4.4 Instance Store & EBS Volume Scenarios](#44-instance-store--ebs-volume-scenarios)
- [4.5 EBS Volume Type SSD](#45-ebs-volume-type-ssd)
- [4.6 EBS Volume Type HDD](#46-ebs-volume-type-hdd)
- [4.7 EBS (Hands-On)](#47-ebs-hands-on)
- [4.8 EBS Snapshot Backup (Hands-On)](#48-ebs-snapshot-backup-hands-on)
- [4.9 Snapshot Use Case](#49-snapshot-use-case)
- [4.10 Fast Snapshot Restore (Hands-On)](#410-fast-snapshot-restore-hands-on)
- [4.11 Data Lifecycle Manager](#411-data-lifecycle-manager)
- [4.12 Elastic File System (EFS)](#412-elastic-file-system-efs)
- [4.13 EFS Options in AWS Console](#413-efs-options-in-aws-console)
- [4.14 EFS (Hands-On)](#414-efs-hands-on)
- [4.15 FSx Introduction](#415-fsx-introduction)
- [4.16 FSx For NetApp ONTAP](#416-fsx-for-netapp-ontap)
- [4.17 FSx For NetApp ONTAP (Hands-On)](#417-fsx-for-netapp-ontap-hands-on)
- [4.18 Amazon FSx For Open ZFS](#418-amazon-fsx-for-open-zfs)
- [4.19 Open ZFS Vs NetApp ONTAP In FSx](#419-open-zfs-vs-netapp-ontap-in-fsx)
- [4.20 FSx For Window File Server](#420-fsx-for-window-file-server)
- [4.21 Active Directory](#421-active-directory)
- [4.22 FSx Part 1 (Hands-On)](#422-fsx-part-1-hands-on)
- [4.23 FSx Part 2 (Hands-On)](#423-fsx-part-2-hands-on)
- [4.24 FSx For Luster](#424-fsx-for-luster)
- [Summary](#summary)

## 4.1 AWS Storage Basics: An Essential Overview

### Overview
This section introduces the fundamentals of storage in AWS, comparing traditional on-premises storage options with AWS storage solutions. It covers three main storage types and maps AWS services to traditional alternatives, providing a foundation for understanding cloud storage architectures.

### Key Concepts/Deep Dive
AWS offers three primary storage architectures: Direct Attached Storage (DAS), File Storage, and Object Storage. Object storage is unique to the cloud and enables massive scalability.

- **Direct Attached Storage (DAS)**: Also known as block storage, directly connected to computing resources like hard drives or SSDs. In on-premises, examples include hard disks or USB drives formatted with file systems (NTFS for Windows, ext4 for Linux). In AWS, this maps to Instance Store (temporary) and Elastic Block Storage (EBS, persistent).
- **File Storage**: Enables shared access for multiple computers via protocols like NFS (Linux) or SMB/CIFS (Windows). Requires a storage server in traditional setups. In AWS, this translates to Elastic File System (EFS) for Linux and FSx for Windows.
- **Object Storage**: Designed for massive static data storage, not suitable for databases or frequent edits. In AWS, this is Simple Storage Service (S3).

Storage selection depends on requirements: DAS for high-performance, temporary needs; File Storage for shared, structured data; Object Storage for large-scale, archival data. The transcript emphasizes starting with instance storage and EBS in the next video.

### Lab Demos
No hands-on labs in this transcript; theoretical overview only.

## 4.2 Difference Between Instance Store & EBS Volume Part 1

### Overview
This section explains the difference between Instance Store and EBS, focusing on how they attach to EC2 instances and their persistence based on physical host distribution. It introduces EC2 instance lifecycle and AWS algorithm for host selection to illustrate temporary vs. persistent storage.

### Key Concepts/Deep Dive
EC2 instances run on physical hosts in AWS, but placement depends on resource availability. When stopped/started, AWS selects any available host, which determines storage accessibility.

- **Instance Store**: Directly Attached to a specific physical host. Data persists only during the instance's runtime; stopping terminates the instance store. Ideal for temporary data like caches or buffers. Provides high performance (low latency, high IOPS).
- **EBS**: External storage attached to the instance but accessible across multiple hosts. Supports stopping/starting instances without data loss. Suitable for persistent data like databases.

The core difference lies in data persistence: Instance Store ties to instance lifecycle, while EBS provides independence.

### Lab Demos
No labs; conceptual explanation with architecture diagrams (physical hosts and instances).

```diff
- Instance Store: High-performance temporary storage, lost on stop
+ EBS: Persistent storage, accessible from multiple hosts
! Use EBS for mission-critical data, Instance Store for ephemeral needs
```

## 4.3 Difference Between Instance Store & EBS Volume Part 2

### Overview
This part summarizes Instance Store vs. EBS differences in a table format, covering lifecycle, persistence, size, performance, use cases, and costs. Essential for AWS certifications and interviews.

### Key Concepts/Deep Dive
- **Lifecycle/Persistence**: Instance Store data is lost on instance termination/stop; EBS persists independently.
- **Size**: Instance Store size depends on instance type (e.g., 1920 GB for specific types); EBS up to 16 TB per volume.
- **Performance**: Instance Store offers lower latency/high IOPS due to direct attachment; EBS provides high IOPS but may have slightly higher latency.
- **Use Cases**: Instance Store for temporary caches/scratch; EBS for databases, applications.
- **Cost**: Instance Store included in instance pricing; EBS charged per GB/hour.
- **Auto-Mounting**: Instance Store mounts automatically; EBS requires manual attachment.

Use EBS for persistent needs, Instance Store for performance with temporary data.

### Lab Demos
No labs; tabular comparison for study.

```diff
! Instance Store: Free, temporary, high-performance for IoT workloads
! EBS: Paid, persistent, for databases and apps
```

## 4.4 Instance Store & EBS Volume Scenarios

### Overview
This section explores six EC2 instance storage scenarios, demonstrating root/data volume combinations with Instance Store and EBS. It covers AMI selection, configuration during launch, and post-launch modifications.

### Key Concepts/Deep Dive
- **Scenario 1: Instance Store as Root**: Use store-enabled AMIs (Linux only); size, performance fixed by instance type. No termination protection; data lost on stop.
- **Scenario 2: EBS as Root**: Default for most instances; supports Windows; allows deletion on termination toggle.
- **Scenario 3: Instance Store as Data**: Specific instance types only; additional volumes not addable.
- **Scenario 4: EBS as Data**: Flexible; add multiple volumes during launch or later.
- **Scenarios 5 & 6**: Mixed (Instance Root/EBS Data, EBS Root/Instance Data).

Key distinctions: Instance Store has limited instance support, fixed sizes; EBS offers flexibility but requires attachment. Use EBS for persistence, Instance Store for high-performance temporary storage.

### Lab Demos
Demonstrates AMI filtering, volume configuration in EC2 console; size modification post-launch via EBS console. Standards modification for performance/scaling (e.g., resizing volumes).

```diff
+ Add EBS volumes during launch for flexible storage
- Instance Store not modifiable post-launch
! Enable encryption for security best practices
```

## 4.5 EBS Volume Type SSD

### Overview
This section details EBS SSD types (GP2, GP3, IO1, IO2), performance metrics (IOPS, throughput), burst capacity, costs, and use cases. Recommends GP3 over GP2 for cost savings.

### Key Concepts/Deep Dive
SSD types: General Purpose (GP2/GP3) for moderate IOPS; Provisioned IOPS (IO1/IO2) for high-performance.

- **GP2**: IOPS based on size (3 IOPS/GB, 100 minimum, 16K max); burst for non-constant usage.
- **GP3**: Flat 3000 IOPS, modifiable up to max; cheaper than GP2 for high IOPS.
- **IO1/IO2**: Provisioned IOPS up to 64K (IO2 with Block Express for 256K). IO2 recommended for durability (99.999% vs. 99.9%).
- **Performance**: Measured in IOPS (requests/second) and throughput (MB/s). GP3: 125 MB/s base; IO2: up to 1024 MB/s.
- **Costs**: GP3: $0.08/GB/month; IO1/IO2: Higher for provisioned IOPS.
- **Multi-Attach**: Supported on IO1/IO2 with Nitro instances.

Choose based on workload: GP3 for большинстве, IO2 for high-durability HPC.

### Lab Demos
No hands-on; console navigation for volume creation, type selection.

```diff
+ Migrate from GP2 to GP3 for optimized cost-performance
! IO2 for 99.999% durability in critical workloads
```

## 4.6 EBS Volume Type HDD

### Overview
This section covers EBS HDD types (Throughput Optimized, Cold HDD, Magnetic), focusing on performance, costs, and use cases for large-scale, infrequently accessed data.

### Key Concepts/Deep Dive
- **Throughput Optimized HDD**: 500 IOPS, 500 MB/s throughput; for big data, logs.
- **Cold HDD**: Lower throughput (250 MB/s), cheaper ($0.025/GB/month); for archival data.
- **Magnetic**: Lowest performance, phased out by AWS; avoid new usage.
- **Performance**: Base/Max IOPS throughputs; no burst like GP2.
- **Costs**: Significant savings over SSD for large volumes.
- **Limitations**: No boot volumes for HDD; lower SLA.

Use for cost-effective archival; migrate to Cold HDD from Magnetic.

### Lab Demos
No labs; option selection in console.

```diff
- Magnetic: Avoid, AWS phasing out
! Cold HDD: Cost-effective for infrequent access
```

## 4.7 EBS (Hands-On)

### Overview
Hands-on guide for attaching, detaching, modifying EBS volumes on Windows EC2 instances, including formatting NTFS, resizing, encryption, and termination protection.

### Key Concepts/Deep Dive
Steps: Launch EC2 → Create EBS Volume in same AZ → Attach → Initialize/Format Disk → Modify Size if needed. Encryption must be enabled at creation; detachment requires consistency.

- **Attachment**: Use EBS console → Actions → Attach, specify device.
- **Formatting**: Windows Disk Management → Initialize → Create Partition.
- **Modification**: Online resize supported; filesystem extend required.
- **Encryption**: One-way; snapshot required for retrofitting.

Best practice: Same AZ, encrypt at creation.

### Lab Demos
Console commands for volume creation, attach/detach, resize.

```diff
+ Encrypt volumes at creation
! Verify AZ alignment before attachment
! Resize only in same AZ; use snapshot for AZ changes
```

## 4.8 EBS Snapshot Backup (Hands-On)

### Overview
Hands-on demonstration of EBS snapshots for backup and restore, using Windows EC2 with Disk Management for data protection.

### Key Concepts/Deep Dive
- **Creating Snapshot**: From EBS console → Actions → Create Snapshot.
- **Restoring**: Snapshot → Create Volume → Attach → Format.
- **Automation**: Not covered; use DLM.
- **Process**: Delete data → Restore from snapshot → Attach.

Snapshot backups are point-in-time, essential for data recovery.

### Lab Demos
No syntax shown; step-by-step console/UI interaction.

```diff
+ Snapshots enable PIT recovery
! Delete old snapshots to manage costs
```

## 4.9 Snapshot Use Case

### Overview
Explores cross-AZ and cross-region volume migration using snapshots, including encryption retrofitting.

### Key Concepts/Deep Dive
- **AZ Migration**: Snapshot → Create Volume in target AZ → Attach.
- **Region Migration**: Copy Snapshot → Create Volume in new region.
- **Encryption**: Snapshot from unencrypted → Create encrypted volume.
- **Process**: Standard snapshot creation, then volume from snapshot.

Symmetric snapshot workflow for mobility.

### Lab Demos
Console for snapshot copy, volume creation.

```diff
! Use snapshots for disaster recovery and migration
```

## 4.10 Fast Snapshot Restore (Hands-On)

### Overview
Introduces Fast Snapshot Restore (FSR) for rapid EBS volume restoration in HPC scenarios, billed per minute per AZ.

### Key Concepts/Deep Dive
- **FSR**: For large snapshots needing instant volume restore.
- **Management**: EBS -> Snapshots -> Manage Fast Snapshot Restore.
- **Cost**: $0.01/GB or higher; enable only when needed.

Use for time-sensitive restorations.

### Lab Demos
Console option; no full demo.

```diff
! FSR: Premium feature for urgent restores
```

## 4.11 Data Lifecycle Manager

### Overview
Demonstrates automated EBS snapshot management using Data Lifecycle Manager (DLM), scheduling daily backups and retention.

### Key Concepts/Deep Dive
- **Setup**: EBS -> Lifecycle Manager -> Create EBS Snapshot Policy.
- **Policy**: Target by tags, schedule (e.g., daily), retention (e.g., count).
- **Automation**: Replaces manual snapshots.

DLM ensures compliance without manual intervention.

### Lab Demos
Policy creation in console.

```diff
+ DLM: Automate backups
```

## 4.12 Elastic File System (EFS)

### Overview
Introduces EFS for shared Linux storage across EC2 instances, ideal for web servers and file sharing.

### Key Concepts/Deep Dive
- **Use Cases**: Centralized web serving, file sharing, on-premises hybrid.
- **Features**: Auto-scaling, pay-per-use; Linux NFS-only.
- **Vs. EBS**: Shared vs. attached; scalable to petabytes.

EFS solves multi-instance data sharing problems.

### Lab Demos
No labs; conceptual.

```diff
+ EFS: Shared, elastic storage for Linux
! Windows users: Use FSx
```

## 4.13 EFS Options in AWS Console

### Overview
Details EFS configuration options like storage classes, lifecycle, performance modes in AWS Console.

### Key Concepts/Deep Dive
- **Storage Classes**: Standard (current AZ), One Zone (single AZ, cheaper).
- **Lifecycle**: Auto-tier to IA/Cold after days.
- **Performance**: Bursting (performance scales with size), Provisioned/Elastic for predictable throughput.

Choose based on access patterns and cost.

### Lab Demos
Option selection; no mount.

```diff
! Elastic throughput: Pay for usage
```

## 4.14 EFS (Hands-On)

### Overview
Hands-on EFS setup with multi-AZ EC2 instances, mounting via NFS.

### Key Concepts/Deep Dive
- **Setup**: Create EFS → Mount targets → Install NFS utils → Mount (e.g., `sudo mount -t nfs`).
- **Sharing**: Reads/writes across instances.

Best for Linux multi-instance scenarios.

### Lab Demos
Bash commands for mounting, file operations.

```diff
+ Centralized with EFS
```

## 4.15 FSx Introduction

### Overview
Introduces FSx as managed file servers: ONTAP, OpenZFS, Windows, Lustre for enterprise storage.

### Key Concepts/Deep Dive
- **Managed**: No infrastructure management.
- **Use Cases**: Lift-and-shift for NetApp/Windows; HPC with Lustre.

FSx bridges on-premises to cloud.

### Lab Demos
No labs.

```diff
+ FSx: Third-party optimized cloud storage
```

## 4.16 FSx For NetApp ONTAP

### Overview
Details FSx ONTAP: NetApp's Ontap OS in cloud, features, use cases.

### Key Concepts/Deep Dive
- **Features**: <=1ms latency, up to 256K IOPS with Block Express.
- **Use Cases**: Enterprise file/data management.
- **Vs. ZFS**: Proprietary vs. open-source.

ONTAP for high-performance shared storage.

### Lab Demos
Conceptual.

```diff
! ONTAP: Proprietary, high-IOPS for enterprises
```

## 4.17 FSx For NetApp ONTAP (Hands-On)

### Overview
Hands-on ONTAP FSx setup with multi-AZ EC2, iSCSI/NFS mounting.

### Key Concepts/Deep Dive
- **Mounting**: `sudo mount -t nfs`; shared across instances.
- **Protocol**: NFS for Linux.

Demonstrates shared storage with ONTAP features.

### Lab Demos
Console/CLI for creation, file ops.

```diff
+ Multi-protocol: NFS, SMB, iSCSI
```

## 4.18 Amazon FSx For Open ZFS

### Overview
Introduces OpenZFS: Open-source, data integrity-focused, for NAS.

### Key Concepts/Deep Dive
- **Features**: Snapshots, compression, RAID-Z.
- **Open-Source**: Community-driven.

Suited for Linux NAS-like workloads.

### Lab Demos
No labs.

```diff
! OpenZFS: Scalable, open-source NAS
```

## 4.19 Open ZFS Vs NetApp ONTAP In FSx

### Overview
Compares OpenZFS vs. ONTAP: Performance, costs, use cases.

### Key Concepts/Deep Dive
- **OpenZFS**: Cheaper, open, Linux-centric.
- **ONTAP**: Higher IOPS, Windows support.

Choose based on needs: ZFS for cost/Linux, ONTAP for performance.

### Lab Demos
Table comparison.

```diff
+ OPENZFS: Lower cost, 0.5ms latency
```

## 4.20 FSx For Window File Server

### Overview
FSx Windows for SMB-based shared storage, Active Directory integrated.

### Key Concepts/Deep Dive
- **Use Cases**: Windows file sharing, backup.
- **Dependency**: Active Directory.

Secure, managed Windows storage.

### Lab Demos
No labs.

```diff
! Requires Active Directory
```

## 4.21 Active Directory

### Overview
Introduces Active Directory for centralized authentication in Windows domains.

### Key Concepts/Deep Dive
- **Domain Controller**: Manages users/policies.
- **Benefits**: Single sign-on, secure access.

Essential for FSx Windows.

### Lab Demos
No labs.

```diff
+ Centralized auth
```

## 4.22 FSx Part 1 (Hands-On)

### Overview
Hands-on Active Directory setup for Windows.

### Key Concepts/Deep Dive
Configures AD domain, joins clients, prepares for FSx.

### Lab Demos
AD install, domain join.

```diff
+ Prep for FSx security
```

## 4.23 FSx Part 2 (Hands-On)

### Overview
Hands-on FSx creation, mount via SMB.

### Key Concepts/Deep Dive
- **Mount**: `net use z: \\FSxDNS\share`.
- **Sharing**: Multi-instance access.

### Lab Demos
Drive mapping, shared files.

```diff
! Encrypt and manage security
```

## 4.24 FSx For Luster

### Overview
Introduces FSx Lustre for HPC: Low latency, high throughput.

### Key Concepts/Deep Dive
- **Features**: <=1ms latency, 1000 GB/s throughput.
- **Use Cases**: ML, rendering, large-scale computing.

For performance-critical workloads.

### Lab Demos
No labs.

```diff
! HPC-optimized, Linux-only
```

## Summary

### Key Takeaways
```diff
+ DAS: Instance Store/EBS for direct attach
+ File: EFS/FSx for shared access
+ Object: S3 for massive scale
! Choose based on persistence, performance, cost
- Instance Store: Temporary, high-IOPS
! EBS: Persistent, modifiable
! Snapshots: Enable DR and migration
! EFS: Linux shared; FSx: Enterprise options
+ FSx ONTAP: High-IOPS for enterprise
+ OpenZFS: Open-source, cost-effective NAS
+ Windows FSx: SMB with AD integration
+ Lustre: HPC performance
```

### Quick Reference
- **Instance Store**: Ephemeral, host-tied; no persistence on stop/terminate.
- **EBS Types**: GP3 (general), IO2 (high-IOPS), Cold HDD (archival).
- **Snapshots**: Backup/Restore via EBS console.
- **EFS Mount**: `sudo mount -t nfs fs-XXXX:/ efs`
- **FSx Mount (ONTAP)**: `sudo mount -t nfs svm-dns:/volume efs`
- **AD Domain**: Use for FSx Windows; `Add-Computer -DomainName domain.local`

### Expert Insight
**Real-world Application**: In e-commerce, use EFS for shared web assets across auto-scaling EC2; FSx ONTAP for SAP databases with high IOPS.

**Expert Path**: Master performance tuning (GP3 to IO2 transition); implement DLM for automation; explore multi-AZ FSx for HA.

**Common Pitfalls**: Forgetting AZ matching for EBS; not encrypting at volume creation; misunderstanding Instance Store impermanence; ignoring snapshot cleanup for cost control.

**Lesser-Known Facts**: EBS Nitro instances enable multi-attach IO1/IO2; FSx Lustre supports S3 data repository association for cost-effective cold storage.

</details>
