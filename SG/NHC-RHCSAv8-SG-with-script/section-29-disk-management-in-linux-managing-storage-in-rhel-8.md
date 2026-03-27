# Section 29: Disk Management in Linux 

<details open>
<summary><b>Section 29: Disk Management in Linux (CL-KK-Terminal)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Storage Device Concepts](#storage-device-concepts)
- [Disk Listing and Inspection Commands](#disk-listing-and-inspection-commands)
- [Scanning for New Disks](#scanning-for-new-disks)
- [Data Security and Secure Erasure](#data-security-and-secure-erasure)
- [Partitioning Fundamentals](#partitioning-fundamentals)
- [MBR vs GPT Partition Tables](#mbr-vs-gpt-partition-tables)
- [Creating Partitions with fdisk](#creating-partitions-with-fdisk)
- [Different Partition Types](#different-partition-types)
- [File Systems and Mounting](#file-systems-and-mounting)
- [Introduction to Logical Volume Management](#introduction-to-logical-volume-management)

## Overview

This section covers essential Linux disk management concepts and commands for system administrators. Learn to identify, scan, partition, format, and mount storage devices while understanding security considerations for data handling. The session emphasizes practical commands for both traditional partitioning and introduces Logical Volume Management (LVM) as a more flexible storage solution.

## Storage Device Concepts

### Block Devices in Linux
Block devices are storage entities that Linux treats as accessible in fixed-size blocks. Any storage medium (hard disks, SSDs, USB drives, SD cards) appears as block devices in the system.

> [!NOTE]
> All storage devices are represented as files in the `/dev` directory, with different naming conventions:
> - IDE drives: `/dev/hd[a-z]` (e.g., `/dev/hda`, `/dev/hdb`)
> - SATA/SCSI drives: `/dev/sd[a-z]` (e.g., `/dev/sda`, `/dev/sdb`)
> - NVMe drives: `/dev/nvme[0-9]n[0-9]` (fastest SSD technology)

## Disk Listing and Inspection Commands

### Listing Block Devices
Use `lsblk` command to display all attached block devices:

```bash
lsblk
```

This shows device names, sizes, mount points, and partition information.

### Detailed Disk Information
For comprehensive disk details including partitions:

```bash
lsblk -f
```

### Partition Table Information
View partition table details with:

```bash
fdisk -l /dev/sda
```

Replace `/dev/sda` with your target device.

### Kernel Ring Buffer Messages
Check kernel messages for disk-related events:

```bash
dmesg | grep -i sda
```

### Real-time Disk Information

```bash
ls /dev/sd*  # List all SATA/SCSI devices
ls /dev/nvme*  # List NVMe devices
```

### Hardware Device Details

```bash
lshw -class disk  # Hardware disk information
lsscsi  # SCSI device details
lsblk -o NAME,FSTYPE,LABEL,UUID,MOUNTPOINT  # Formatted device info
```

## Scanning for New Disks

### Manual Rescan Command
After attaching new storage, force system scan:

```bash
echo "- - -" > /sys/class/scsi_host/host0/scan
```

This command tells the SCSI subsystem to rescan for new devices.

### Verification After Scan
Check if new device appears:

```bash
lsblk
```

The new device should now be listed (e.g., `/dev/sdb`).

## Data Security and Secure Erasure

### Data Recovery Risks
Standard deletion only removes file system pointers - actual data remains until overwritten. Professional data recovery tools can retrieve deleted information.

### Secure Erasure with badblocks

```bash
badblocks -w -s -v /dev/sda
```

**Parameters:**
- `-w`: Write mode (overwrites with patterns)
- `-s`: Show progress
- `-v`: Verbose output

> [!WARNING]
> This command completely destroys all data and takes considerable time based on drive size.

### Secure Erasure with dd

```bash
dd if=/dev/zero of=/dev/sda bs=4M status=progress
```

This overwrites the entire drive with zeros, making data recovery virtually impossible.

## Partitioning Fundamentals

### Why Partitioning is Required
Direct storage usage without file systems is impossible. Partitions allow:
1. Organized storage allocation
2. Multiple operating systems on same drive
3. Different file systems for different purposes
4. Easier backup and management

### File System Creation Process
1. Create partition boundaries
2. Format with chosen file system
3. Mount partition to directory
4. Verify and use for data storage

## MBR vs GPT Partition Tables

### MBR (Master Boot Record) Limitations
- Used with `fdisk` utility
- Supports only 4 primary partitions
- Maximum partition size: 2TB
- Compatible with older BIOS systems
- No built-in redundancy

### GPT (GUID Partition Table) Advantages  
- Used with `gdisk` or `parted` utilities
- Supports up to 128 primary partitions
- No practical size limits
- Modern UEFI systems required
- Built-in redundancy and integrity checks

```diff
! Traditional partitioning requires physical boundaries
! LVM provides logical abstraction over physical storage
```

## Creating Partitions with fdisk

### Interactive Partitioning Process

```bash
sudo fdisk /dev/sdb
```

**Common fdisk commands:**
- `p`: Print partition table
- `n`: Create new partition
- `d`: Delete partition
- `t`: Change partition type
- `w`: Write changes and exit
- `q`: Quit without saving

### Step-by-Step Partition Creation

1. **Launch fdisk:**
   ```bash
   sudo fdisk /dev/sdb
   ```

2. **Create Primary Partition:**
   ```
   Command: n
   Select: p (primary)
   Partition number: 1
   First sector: (press Enter for default)
   Last sector: +2G (for 2GB partition)
   ```

3. **Set Partition Type (Optional):**
   ```
   Command: t
   Partition number: 1
   Hex code: 83 (Linux) or 8e (LVM)
   ```

4. **Write Changes:**
   ```
   Command: w
   ```

### Update Kernel with Changes

```bash
sudo partprobe /dev/sdb
# or
sudo partx -u /dev/sdb
```

Verify partitions:

```bash
lsblk /dev/sdb
```

## Different Partition Types

### Primary Partitions
- Maximum 4 per MBR disk
- Can contain operating systems
- Directly bootable
- No logical partitions within primary

### Extended Partitions  
- Container for logical partitions
- Counts as one primary partition
- Allows creating multiple logical partitions
- Cannot store data directly

### Logical Partitions
- Created within extended partition
- Unlimited number possible
- Cannot contain operating systems (generally)
- Numbered starting from 5

### Creating Different Types

**Primary Partition:**
```
n → p → 1 → Enter → +1G
```

**Extended Partition:**
```
n → e → 2 → Enter → Enter (use remaining space)
```

**Logical Partition:**
```
n → l → 5 → Enter → +2G
```

## File Systems and Mounting

### File System Formatting

```bash
sudo mkfs.ext4 /dev/sdb1
```

Common file systems:
- `ext4`: Modern Linux default
- `xfs`: High-performance enterprise
- `btrfs`: Advanced features, snapshots
- `vfat`: Cross-platform compatibility

### Mounting Partitions

```bash
sudo mkdir /mnt/data
sudo mount /dev/sdb1 /mnt/data
```

### Persistent Mounting (/etc/fstab)

```bash
/dev/sdb1    /mnt/data    ext4    defaults    0 2
```

### Verification Commands

```bash
df -h  # Disk usage
du -sh /mnt/data  # Directory size
mount | grep sdb1  # Mount status
lsblk -f  # File system info
```

## Introduction to Logical Volume Management

### Limitations of Traditional Partitioning
- Fixed partition sizes
- Difficult expansion/reduction
- Wasted space in unused partitions
- Complex storage management

### LVM Advantages
- Dynamic resizing of volumes
- Snapshot capabilities
- Volume migration
- Better space utilization
- Logical abstraction layer

### Basic LVM Concepts
- **Physical Volumes (PV):** Physical storage devices
- **Volume Groups (VG):** Pool of storage from PVs  
- **Logical Volumes (LV):** Usable storage volumes

```bash
# Initialize LVM on partition
sudo pvcreate /dev/sdb1

# Create volume group
sudo vgcreate myvg /dev/sdb1

# Create logical volume
sudo lvcreate -L 1G -n mylv myvg

# Format and mount
sudo mkfs.ext4 /dev/myvg/mylv
sudo mount /dev/myvg/mylv /mnt/lvm
```

## Summary

### Key Takeaways

```diff
+ Disk management is critical for system reliability and data security
+ Use secure erasure methods when disposing of drives
+ LVM provides superior flexibility compared to traditional partitioning
+ Always backup important data before making storage changes
+ Understand your hardware (SATA vs NVMe) for optimal performance
+ Partition tables (MBR vs GPT) have different limitations and use cases
```

### Quick Reference

**Essential Commands:**
- `lsblk`: List block devices
- `fdisk -l`: Partition table details  
- `df -h`: Disk usage
- `mount`: Mount filesystems
- `mkfs.ext4`: Format partition

**Security Commands:**
- `badblocks -w /dev/sdX`: Secure erase with badblocks
- `dd if=/dev/zero of=/dev/sdX`: Zero-fill drive

**LVM Commands:**
- `pvcreate`: Create physical volume
- `vgcreate`: Create volume group
- `lvcreate`: Create logical volume

### Expert Insight

**Real-world Application**: In production environments, always use LVM for critical systems as it allows online resizing, snapshots for backups, and easier storage management across multiple disks.

**Expert Path**: Master LVM commands like `lvextend`, `lvreduce`, and snapshot management. Learn RAID configurations and enterprise storage solutions like Ceph or GlusterFS.

**Common Pitfalls**: 
> [!CAUTION]
> Never format system partitions without backups. Always verify device names with `lsblk` before destructive operations. Remember sector 2048 reservation for proper partition alignment.
 
</details>
