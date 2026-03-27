# Section 38: How to Migrate LVM (Logical Volume Manager) with Data from One Machine to Another

<details open>
<summary><b>Section 38: How to Migrate LVM (Logical Volume Manager) with Data from One Machine to Another (CL-KK-Terminal)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Preparing the Disk and Creating LVM Components](#preparing-the-disk-and-creating-lvm-components)
- [Creating and Formatting the Logical Volume](#creating-and-formatting-the-logical-volume)
- [Adding Sample Data](#adding-sample-data)
- [Exporting the Volume Group](#exporting-the-volume-group)
- [Migrating the Disk to Another Machine](#migrating-the-disk-to-another-machine)
- [Importing and Activating the Volume Group](#importing-and-activating-the-volume-group)
- [Mounting and Verifying Data Integrity](#mounting-and-verifying-data-integrity)
- [Configuring Permanent Mounting](#configuring-permanent-mounting)
- [Key Takeaways](#key-takeaways)
- [Quick Reference](#quick-reference)
- [Expert Insight](#expert-insight)

## Overview
This section demonstrates how to migrate an entire LVM (Logical Volume Manager) setup, including all data, from one machine to another. The process involves exporting the volume group, safely transferring the physical disk, and then importing and activating it on the target machine. This ensures complete data preservation and allows seamless continuation of work across systems.

### Key Concepts
LVM migration provides flexibility in managing storage across different machines. It allows you to move logical volumes, physical volumes, and volume groups while keeping all data intact. The process requires careful deactivation, export, physical transference, and re-activation on the new machine.

### Prerequisites
- Basic knowledge of Linux partitioning and mounting
- Understanding of LVM components (PV, VG, LV)
- Access to virtualization software (e.g., VirtualBox) for attaching disks to different VMs
- Root privileges on both source and target machines

## Preparing the Disk and Creating LVM Components

### Overview
The first step involves preparing the disk by creating a partition, then setting up the foundational LVM components: Physical Volume (PV), Volume Group (VG), and Logical Volume (LV).

### Key Concepts
- Use `fdisk` or `parted` to create a primary partition on the disk (e.g., /dev/sdb).
- Create a Physical Volume with `pvcreate`.
- Create a Volume Group and add the PV to it using `vgcreate`.
- Display information using `pvdisplay`, `vgdisplay`.
- Use Physical Extents (PE) to define VG size.

### Steps and Commands

```bash
# List and partition the disk (e.g., 10GB disk /dev/sdb)
lsblk

# Use fdisk to create a primary partition
fdisk /dev/sdb
# n (new), p (primary), 1 (partition number), defaults for size, w (write)

# Update kernel with new partition
partprobe

# Verify partition
fdisk -l /dev/sdb

# Create Physical Volume
pvcreate /dev/sdb1

# Create Volume Group
vgcreate vggrp /dev/sdb1

# Display VG info
vgdisplay
```

## Creating and Formatting the Logical Volume

### Overview
With the VG created, proceed to create a Logical Volume (LV), format it with a filesystem (e.g., ext4), and mount it for use.

### Key Concepts
- Use `lvcreate` to allocate space from the VG (e.g., 8GB from VG size).
- Format with `mkfs.ext4`.
- Create a mount point and mount using `mount`.
- Use `lvdisplay` and `mkdir` as needed.
- Verify with `df -hT` and `mount`.

### Steps and Commands

```bash
# Create Logical Volume (e.g., 8000 extents for ~8GB)
lvcreate -l 8000 -n lvbol vggrp

# Verify LV
lvdisplay

# Format the LV
mkfs.ext4 /dev/vggrp/lvbol

# Create mount point
mkdir /data

# Mount the LV
mount /dev/vggrp/lvbol /data

# Verify mount
df -hT /data
```

## Adding Sample Data

### Overview
To demonstrate data preservation, create some sample files and directories on the mounted LV.

### Key Concepts
- Create test files and directories.
- Add content to files for verification post-migration.

### Steps and Commands

```bash
# Navigate to mount point
cd /data

# Create test files and directories
mkdir testdir
echo "test content 1" > testfile.txt
echo "02gib size content" > 2gib.txt
echo "BSc file content" > bsc.txt
mkdir subdir
echo "Master file content" > master.txt
echo "calendar content" > calendar.txt
```

## Exporting the Volume Group

### Overview
Before physically migrating the disk, deactivate the VG, unmount the LV, deactivate the VG, and export it to prepare for removal.

### Key Concepts
- Always unmount before deactivation.
- Use `vgchange -an` to deactivate.
- Export with `vgexport`.
- Verify export status with `vgdisplay` (shows exported state).
- Power off the machine before removing the disk (never hot-remove active disks).

### Steps and Commands

```bash
# Unmount the LV
umount /data

# Deactivate VG
vgchange -an vggrp

# Export VG
vgexport vggrp

# Verify (VG is now exported)
vgdisplay
lvdisplay  # No active LVs
```

### Important Notes

> [!IMPORTANT]
> Always power off the machine before physically removing disks to prevent data corruption. Never remove active LVM disks from a running system.

## Migrating the Disk to Another Machine

### Overview
Power off the source machine, detach the disk, and attach it to the target machine (e.g., via VirtualBox or hardware).

### Key Concepts
- In virtualization, use settings to add existing disk image (.vdi file).
- Ensure target machine is powered off if hot-plug not supported.
- Copy the .vdi file path for attachment.
- Boot the target machine with changed boot order (if needed).
- Adjust BIOS boot settings to prioritize the migrated disk.

### Steps and Commands

# Power off source machine
poweroff

# In virtualization software (e.g., VirtualBox):
# Go to Settings > Storage > Add Hard Disk
# Select "Choose existing disk"
# Paste the path to the source .vdi file

# Power on target machine
# If needed, enter BIOS (F2/Del) and set boot order

# On target machine, scan for changes (if running)
pvscan  # For running machines
```

## Importing and Activating the Volume Group

### Overview
On the target machine, scan for imported VGs, import, and activate them.

### Key Concepts
- Use `pvscan` to detect exported VG.
- Import with `vgimport`.
- Activate VG with `vgchange -ay`.
- Verify with `pvdisplay`, `vgdisplay`, `lvdisplay`.

### Steps and Commands

```bash
# Scan for PVs and exported VGs
pvscan

# Import VG (specify VG name)
vgimport vggrp

# Activate VG
vgchange -ay vggrp

# Verify activation
vgdisplay
lvdisplay
```

## Mounting and Verifying Data Integrity

### Overview
Mount the LV and check that all data is intact and accessible.

### Key Concepts
- Mount the LV to a directory.
- Verify file contents and structure.
- Use checksums or file listings for deeper verification.

### Steps and Commands

```bash
# Mount the LV
mount /dev/vggrp/lvbol /data

# Verify contents
ls -la /data
cat /data/testfile.txt
cat /data/master.txt
cat /data/calendar.txt

# Check filesystem (optional)
fsck /dev/vggrp/lvbol
```

### Verification Results
- All created directories and files should be present.
- File contents match exactly what was created before migration.
- No corruption or data loss.

## Configuring Permanent Mounting

### Overview
To make the mount persistent across reboots, add an entry to `/etc/fstab`.

### Key Concepts
- Get UUID with `blkid /dev/vggrp/lvbol`.
- Edit `/etc/fstab` with mount details.
- Reload systemd daemon or reboot to apply.

### Steps and Commands

```bash
# Get UUID
blkid /dev/vggrp/lvbol

# Edit /etc/fstab (add entry like):
# UUID=xxxx-xxxx-xxxx-xxxx /data ext4 defaults 0 0
vim /etc/fstab

# Reload systemd
systemctl daemon-reload

# Mount all
mount -a
```

## Key Takeaways
```diff
+ LVM provides complete disk migration capabilities, preserving all data and logical structures.
+ Always deactivate and export VG before physical disk removal to ensure safety.
+ Use pvscan and vgimport on the target machine to bring migrated storage online.
+ Verify data integrity immediately after import to catch any issues early.
- Never hot-remove disks from running systems as it can cause data loss.
- For running target machines, scan before mounting to avoid detection issues.
! Migration works for local disks, SAN, or virtual disks; always backup critical data first.
```

## Quick Reference
### Common Commands
- **Partition and PV**: `fdisk`, `pvcreate`, `pvdisplay`
- **VG Management**: `vgcreate`, `vgdisplay`, `vgexport`, `vgimport`, `vgchange -an/-ay`
- **LV Management**: `lvcreate`, `lvdisplay`
- **Mounting**: `mount`, `umount`, `blkid`, edit `/etc/fstab`
- **Verification**: `pvscan`, `fsck`, `ls`, `cat`

### Migration Checklist
✅ Partition disk  
✅ Create PV and VG  
✅ Create LV and format  
✅ Add data and mount  
✅ Deactivate VG and export  
✅ Power off and detach disk  
✅ Attach to new machine and import/activate  
✅ Mount and verify data  
✅ Update fstab for persistence  

## Expert Insight
### Real-world Application
In enterprise environments, LVM migration enables seamless storage upgrades, server migrations, or disaster recovery by moving entire storage pools between physical/virtual servers without data loss. It's commonly used for cloud migrations, data center relocations, or hardware refreshes.

### Expert Path
Master LVM extents and striping for advanced setups; combine with tools like `pvmove` for online migrations. Dive into multipath configurations for high-availability storage.

### Common Pitfalls
- Forgetting to export/import VG leads to inaccessible data.
- Hot-removing disks causes kernel panics and corruption.
- Not updating fstab results in unmounted volumes post-reboot.
- Skipping pvscan on running machines leaves storage undetected.

</details>
