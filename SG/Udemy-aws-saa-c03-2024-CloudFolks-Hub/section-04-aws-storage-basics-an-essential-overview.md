# Section 4: AWS Storage Fundamentals

<details open>
<summary><b>Section 4: AWS Storage Fundamentals (CL-KK-Terminal)</b></summary>

## Table of Contents
- [4.1 AWS Storage Basics- An Essential Overview](#41-aws-storage-basics--an-essential-overview)
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
- [4.18 FSx For Open ZFS](#418-fsx-for-open-zfs)
- [4.19 Open ZFS Vs NetApp ONTAP In FSx](#419-open-zfs-vs-netapp-ontap-in-fsx)
- [4.20 FSx For Window File Server](#420-fsx-for-window-file-server)
- [4.21 Active Directory](#421-active-directory)
- [4.22 FSx Part 1 (Hands-On)](#422-fsx-part-1-hands-on)
- [4.23 FSx Part 2 (Hands-On)](#423-fsx-part-2-hands-on)
- [4.24 FSx For Luster](#424-fsx-for-luster)

## 4.1 AWS Storage Basics- An Essential Overview

### Overview
This transcript introduces fundamental concepts of storage in AWS, covering the three main storage types: Direct Attached Storage (DAS), file storage, and object storage. It explains the alternatives in AWS like instance store/EBS for DAS, Elastic File System (EFS) for file storage, and Simple Storage Service (S3) for object storage, with a focus on their uses in on-premises vs. cloud environments.

### Key Concepts/Deep Dive
- **Direct Attached Storage (DAS)**: Storage directly connected to a single computer, such as hard disks or SSDs. Example: Pen drives or internal HDDs in PCs. Key issue: Not shared; cannot be used simultaneously by multiple computers. In AWS, alternatives are instance store (temporary, tied to EC2 instance) and EBS (persistent, elastic).

> [!NOTE]
> Composition of Orion Nebula image families MSI uses to create Grandmaster.

- **File Storage**: Shared storage for multiple computers, like NFS for Linux or SMB for Windows. In AWS, Elastic File System (EFS) serves this purpose, enabling centralized file storage accessible by multiple EC2 instances.

- **Object Storage**: Used for large-scale static data, not frequently edited. Ideal for big data and cloud-native storage. AWS service: S3.

**Comparison Table:**

| Storage Type | On-Premises Example | AWS Equivalent | Key Characteristics |
|--------------|---------------------|----------------|---------------------|
| DAS | HDD/SSD in PC | Instance Store / EBS | Not shared, direct attachment |
| File Storage | NFS/SMB Server | EFS/FSx (Windows/Linux) | Shared, multi-user access |
| Object Storage | N/A (cloud-only) | S3 | Scalable, static data storage |

### Code/Config Blocks
No specific code/config examples in this overview transcript.

### Lab Demos
None specified; this is a conceptual overview.

## 4.2 Difference Between Instance Store & EBS Volume Part 1

### Overview
This transcript explains the lifecycle of EC2 instances and physical hosts, differentiating between ephemeral (instance store) and persistent (EBS) storage. Instance store is tied to the instance life, while EBS is network-attached and allows instance restart in different hosts.

### Key Concepts/Deep Dive
- **EC2 Instance Lifecycle**: AWS algorithm selects physical hosts for instance startup/stops. Stops allow restarts in same or different hosts, but terminated instances are lost.
- **Instance Store**: Directly attached to physical host, providing fast access. Data is lost if instance stops or host fails, as storage isn't shared.
- **EBS Volume**: Network-attached storage, accessible from multiple hosts. Enables persistent data, instance migration across hosts, and detachment for reuse.

> [!IMPORTANT]
> Instance store is best for temporary, high-speed needs; EBS for critical, persistent data.

### Tables
| Feature | Instance Store | EBS Volume |
|---------|----------------|------------|
| Accessibility | Single host, direct | Multiple hosts, network |
| Persistence | Ephemeral (lost on stop) | Persistent (survives stop/termination) |
| Performance | Higher (direct attach) | Lower (network attach) |
| Cost | Included in instance | Charged separately |

### Code/Config Blocks
None.

### Lab Demos
None.

## 4.3 Difference Between Instance Store & EBS Volume Part 2

### Overview
This builds on the previous transcript, emphasizing persistence and use cases: instance store for temporary/cached data, EBS for databases and file systems.

### Key Concepts/Deep Dive
- **Persistence**: Instance store data deleted on stop; EBS data survives instance lifecycle.
- **Performance**: Size determines baseline; EBS allows bursting.
- **Cost**: Instance store free; EBS billed per GB.

### Tables
| Aspect | Instance Store | EBS Volume |
|---------|----------------|------------|
| Data Persistence | No (lost on stop) | Yes |
| Best For | Cache, scratch data | Databases, critical files |
| Size | Fixed by instance type | Flexible, scalable |
| Cost | Free | Pay per GB |

### Code/Config Blocks
None.

### Lab Demos
None.

## 4.4 Instance Store & EBS Volume Scenarios

### Overview
Describes six scenarios for configuring local storage on EC2: root/data volume combinations with instance store and EBS.

### Key Concepts/Deep Dive
- **Root Volume**: OS drive.
- **Data Volume**: Additional storage.
- Scenarios include instance store as root (ephemeral), EBS as root (persistent), combinations for availability zones.

### Tables
| Scenario | Root Volume | Data Volume | Notes |
|----------|-------------|-------------|-------|
| IS Root | Instance Store | None/Fixed | Fast boot, no dynamic data add |
| EBS Root | EBS | None | Persistent OS |
| IS Root + EBS Data | Instance Store | EBS | OS ephemeral, data persistent |
| EBS Root + IS Data | EBS | Instance Store | OS persistent, data ephemeral |
| IS Root + IS Data | Instance Store | Instance Store (selected instance types) | All ephemeral |
| EBS Root + EBS Data | EBS | EBS | All persistent |

### Code/Config Blocks
None.

### Lab Demos
None.

## 4.5 EBS Volume Type SSD

### Overview
Covers SSD-based EBS volumes: GP2, GP3 (burstable), IO1/IO2 (provisioned IOPs) for high-performance workloads like databases.

### Key Concepts/Deep Dive
- **GP2/3**: General purpose, burstable IOPs based on size. GP3 cheaper with fixed 3000 IOPS.
- **IO1/2**: For sustained high IOPS; IO2 more durable.
- Performance metrics: IOPS, throughput.

### Tables
| Type | Max Size | Max IOPS | Max Throughput (MB/s) | Use Case |
|------|----------|----------|-----------------------|----------|
| GP3 | 16 TB | 16000 | 1000 | Moderate workloads |
| IO1/IO2 | 16/64 TB | 64000/256000 (IO2 Block Express) | 4000/8000 | High IOPS databases |

### Code/Config Blocks
None.

### Lab Demos
None.

## 4.6 EBS Volume Type HDD

### Overview
HDD volumes: Throughput optimized, Cold HDD, and Magnetic (legacy) for cost-effective, low-performance storage.

### Key Concepts/Deep Dive
- **Throughput Optimized HDD**: High throughput, low IOPS.
- **Cold HDD**: Even more cost-effective for infrequent access.
- Magnetic: Previous generation, avoid for new workloads.

### Tables
| Type | Max Size | Max Throughput (MB/s) | Performance (IOPS) | Cost Rank |
|------|----------|-----------------------|-------------------|-----------|
| Throughput Optimized HDD | 16 TB | 500 | 500 | $$ |
| Cold HDD | 16 TB | 250 | 250 | $ |
| Magnetic | 16 TB | 70-90 | 100-200 | $$$ |

### Code/Config Blocks
None.

### Lab Demos
None.

## 4.7 EBS (Hands-On)

### Overview
Hands-on demo: Creating, attaching, formatting EBS volumes, resizing, and encryption notes.

### Key Concepts/Deep Dive
- Attach/detach volumes; format as NTFS (Windows)/ext4 (Linux).
- Resize via Modify Volume; cannot shrink.
- Encryption: Set at creation; cannot enable later.

### Code/Config Blocks
Run Disk Management:
```bash
diskmgmt.msc
```

### Lab Demos
1. Create 15 GB EBS volume in same AZ.
2. Attach to EC2.
3. Format in Disk Management.
4. Place files.
5. Resize to 30 GB; extend partition.

Detach/Delete volume if unused.

## 4.8 EBS Snapshot Backup (Hands-On)

### Overview
Hands-on: Create snapshots for backup, restore volumes from snapshots.

### Key Concepts/Deep Dive
- Snapshots: Backup to S3; point-in-time.
- Restore: Create volume from snapshot.

### Code/Config Blocks
None specific.

### Lab Demos
1. Attach/form 15 GB EBS.
2. Add files.
3. Create snapshot.
4. Delete files.
5. Create new volume from snapshot.
6. Attach/restore data.

Clean up: Delete volumes/snapshots.

## 4.9 Snapshot Use Case

### Overview
Advanced use: Copy snapshots across AZs/regions, enable encryption post-creation.

### Key Concepts/Deep Dive
- Cross-AZ/Region Copy: Snapshot → Volume in new location.
- Encryption: Via snapshot if missed.

### Code/Config Blocks
None.

### Lab Demos
1. Snapshot unencrypted volume.
2. Copy snapshot to new AZ.
3. Create encrypted volume from it.

Clean up resources.

## 4.10 Fast Snapshot Restore (Hands-On)

### Overview
Manages fast restore for snapshots to quickly create volumes from large snapshots.

### Key Concepts/Deep Dive
- Fast Restore: Pays per minute/AZ for speeding up volume creation from large snapshots.

### Code/Config Blocks
None.

### Lab Demos
1. Create snapshot.
2. Manage Fast Snapshot Restore.
3. Note: Paid feature; demo explains process.

## 4.11 Data Lifecycle Manager

### Overview
Automates EBS snapshot creation and retention.

### Key Concepts/Deep Dive
- Policies: Schedule snapshots, retain (count/age).
- Costs: Pay for automated snapshots.

### Code/Config Blocks
None.

### Lab Demos
1. Create EBS volume with tags.
2. Create DLM policy: Daily snapshots, retain 2.
3. Enable/disable policy.

Clean up: Delete volumes/policy.

## 4.12 Elastic File System (EFS)

### Overview
EFS as shared Linux file storage for multi-EC2 instances, e.g., high-availability websites.

### Key Concepts/Deep Dive
- Shared Storage: File-level, multi-instance access.
- Use Cases: Websites, centralized data.

### Code/Config Blocks
None.

### Lab Demos
Scenarios explained; practical in next transcript.

## 4.13 EFS Options in AWS Console

### Overview
EFS configuration: Storage classes, throughput modes, performance.

### Key Concepts/Deep Dive
- Standard: Multi-AZ replication.
- One Zone: Single AZ, cheaper.
- Lifecycle: Hot/cold data.
- Throughput: Bursting/Provisioned/Elastic.

### Code/Config Blocks
None.

### Lab Demos
Explained; implementation in next.

## 4.14 EFS (Hands-On)

### Overview
Hands-on EFS creation, mounting on Linux EC2s, testing shared access.

### Key Concepts/Deep Dive
- Security Groups: NFS port 2049.
- Mounting: Via commands.

### Code/Config Blocks
Install utilities:
```bash
yum install amazon-efs-utils
```

Mount EFS:
```bash
mkdir /efs
mount -t efs fs-XXXXXXXX /efs
```

### Lab Demos
1. Create Security Groups.
2. Launch Linux EC2s in different AZs.
3. Create EFS with mount targets.
4. Mount EFS on instances.
5. Share files across instances.

## 4.15 FSx Introduction

### Overview
FSx: Managed file servers (NetApp ONTAP, OpenZFS, Windows FS, Lustre) for various workloads.

### Key Concepts/Deep Dive
- Fully managed: No hardware/server management.
- Use Cases: Apps requiring specific file systems (e.g., HPC, databases).

### Code/Config Blocks
None.

### Lab Demos
None.

## 4.16 FSx For NetApp ONTAP

### Overview
FSx ONTAP: AWS-managed NetApp storage with high performance, multi-protocol support.

### Key Concepts/Deep Dive
- Features: iSCSI, NFS, SMB; up to 4-6 GB/s throughput.

### Code/Config Blocks
None.

### Lab Demos
Explained; hands-on next.

## 4.17 FSx For NetApp ONTAP (Hands-On)

### Overview
Hands-on FSx ONTAP creation, iSCSI/NFS mounting.

### Key Concepts/Deep Dive
- Volume Creation: SMB/NFS/iSCSI.
- Mounting: Via provided commands.

### Code/Config Blocks
Mount NFS:
```bash
mount -t nfs fs-XXXXXXXXX:/volume_name /mnt
```

### Lab Demos
1. Create FSx ONTAP.
2. Attach volumes via protocols.
3. Mount on instances.

## 4.18 FSx For Open ZFS

### Overview
FSx ZFS: Open-source, high-performance, for various deployments.

### Key Concepts/Deep Dive
- Features: Data integrity, scalability, open-source.

### Code/Config Blocks
None.

### Lab Demos
None.

## 4.19 Open ZFS Vs NetApp ONTAP In FSx

### Overview
Compares ZFS vs. ONTAP in FSx on latency, throughput, durability.

### Key Concepts/Deep Dive
- ZFS: Lower latency, unlimited capacity.
- ONTAP: Higher durability, multi-AZ.

### Tables
| Metric | OpenZFS | ONTAP |
|--------|---------|-------|
| Latency | 0.5 ms | <1 ms |
| Max Throughput | 10-21 GB/s | 4-6 GB/s |
| Durability | Standard | 99.999% SLA |

### Code/Config Blocks
None.

### Lab Demos
None.

## 4.20 FSx For Window File Server

### Overview
FSx Windows: Managed SMB server for Windows workloads.

### Key Concepts/Deep Dive
- Requires Active Directory.

### Code/Config Blocks
None.

### Lab Demos
Practical in next.

## 4.21 Active Directory

### Overview
AD: Centralized authentication for Windows domains.

### Key Concepts/Deep Dive
- Domains, Controllers, UPN.

### Code/Config Blocks
Join domain:
```powershell
Add-Computer -DomainName "example.local"
```

### Lab Demos
None.

## 4.22 FSx Part 1 (Hands-On)

### Overview
Hands-on AD setup in AWS.

### Key Concepts/Deep Dive
- Domain creation, client joins.

### Code/Config Blocks
None.

### Lab Demos
1. Deploy AD server.
2. Configure static IP/DNS.
3. Promote to domain controller.
4. Join clients to domain.

Clean up: Terminate instances.

## 4.23 FSx Part 2 (Hands-On)

### Overview
Hands-on FSx Windows in AD environment.

### Key Concepts/Deep Dive
- SMB access via Z: drive.

### Code/Config Blocks
None.

### Lab Demos
1. Create FSx with AD.
2. Attach to AD-joined instances.
3. Share files.

## 4.24 FSx For Luster

### Overview
FSx Lustre: HPC file system with high throughput (up to 1000 GB/s).

### Key Concepts/Deep Dive
- Posix-compliant, HPC-specific.

### Code/Config Blocks
None.

### Lab Demos
None; no hands-on provided.

## Summary Section

### Key Takeaways
```diff
+ AWS storage options: DAS (EBS/Instance Store), File (EFS/FSx), Object (S3)
+ Instance Store: Ephemeral, high performance; EBS: Persistent, flexible
+ EBS types: SSD (GP3, IO2) for high IOPS; HDD for throughput
+ Snapshots: Backup, cross-AZ/region copy, encryption enable
+ EFS: Multi-AZ shared Linux storage
+ FSx: Specialized file servers (ONTAP, ZFS, Windows, Lustre)
- Avoid modifying EBS encryption after creation
- Magnetic volumes are legacy; use Cold HDD instead
```

### Quick Reference
- **EBS Volume Types**: GP3 (3000 IOPS base), IO2 (up to 256K IOPS with Block Express)
- **FSx Throughput**: ONTAP 4-6 GB/s, ZFS 10-21 GB/s, Lustre 1000 GB/s
- **DLM Policies**: Automate snapshots with schedules (e.g., daily/7 days retention)
- **EFS Mount**: `mount -t efs fs-XXXXXXXX /efs`

### Expert Insight
**Real-world Application**: Use EBS GP3 for web apps, IO2 for RDS-backed databases, EFS for multi-AZ app sharing, FSx ONTAP for hybrid storage like on-prem extensions via VPC peering.

**Expert Path**: Master performance metrics (IOPS/throughput), storage classes (hot/cold), and encryption via KMS. Explore cross-region snapshots for disaster recovery.

**Common Pitfalls**: Forgetting AZ alignment for EBS/FSx; not encrypting at creation; over-provisioning for burstable GP3; ignoring DLM costs for auto-snapshots.

</details>
