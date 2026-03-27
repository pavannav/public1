# Section 30: File Systems and Mounting 

<details open>
<summary><b>Section 30: File Systems and Mounting (CL-KK-Terminal)</b></summary>

## Table of Contents

- [Introduction to File Systems](#introduction-to-file-systems)
- [File System Types](#file-system-types)
- [Other File Systems](#other-file-systems)
- [Checking Supported File Systems](#checking-supported-file-systems)
- [Creating File Systems](#creating-file-systems)
- [Mounting Basics](#mounting-basics)
- [Mounting Options](#mounting-options)
- [Permanent Mounting with FSTAB](#permanent-mounting-with-fstab)
- [Unmounting](#unmounting)
- [File System Management Tools](#file-system-management-tools)
- [Practical Demos](#practical-demos)
- [File System Check](#file-system-check)

## Introduction to File Systems

File systems are essential for organizing and storing data on storage devices. Without a file system, the operating system cannot properly manage files and directories on a partition. The file system defines how data is named, stored, retrieved, and organized while handling access control and metadata like modification times and ownership.

```diff
! Client System → Mount Point → File System → Physical Storage Partition
```

## File System Types

Linux supports various file systems, with ext2, ext3, and ext4 being the most commonly used on disks, and swap for virtual memory.

### Ext2 (Extended 2 File System)
- Most common file system (second extended).
- Lacks journaling feature.
- ! Major disadvantage: File system checks after unclean shutdown can take excessively long.
- Replaced by ext3 mainly due to lack of journaling.

### Ext3 (Extended 3 File System)
- Similar to ext2 but includes journaling.
- Journaling ensures the file system remains consistent even after power failure or unclean shutdown without needing a full file system check.
- Supports block reservation for better performance.

### Ext4 (Extended 4 File System)
- Most widely used today as the default in many Linux distributions.
- Includes all features of ext3 plus:
  - Larger file system size (up to 16TB vs 2TB in ext3).
  - Support for extents for better performance.
  - Online defragmentation.
- ⚠ Ext4 file systems cannot be reduced in size, only extended.
- Developed from ext3 for 64-bit support.

```diff
+ Advantages: Journaling, consistency, performance
- Disadvantages: Ext2 check times, ext4 cannot shrink
```

## Other File Systems

### FAT (File Allocation Table)
- Cross-platform compatibility (Windows, Linux, macOS).
- Supports various implementations:
  - FAT12 (floppy drives).
  - FAT16 (older Windows systems).
  - FAT32 (wider support, larger volumes).
- Primary purpose: Digital cameras, USB drives, flash storage.
- FSTAB entry optional for Windows shares.

### ISO9660 (Rock Ridge, Joliet)
- Standard for CD/DVD-ROMs and images.
- Used for read-only media and ISO image files.
- Mount ISO images directly: `mount -t iso9660 image.iso /mount/point`.

### UDF (Universal Disk Format)
- Optical media (CD, DVD, Blu-ray).
- Limited use in Linux compared to Windows.

### Swap
- Not a traditional file system but used for virtual memory space.
- Must be designated as swap space on dedicated partitions.
- No direct content writing; used for swapping by the OS.

### EXT4 in Clustered Storage
- Used in distributed file systems like GFS2, OCFS2.
- Designed for shared storage environments catering to specific server types.

## Checking Supported File Systems

```bash
# Check currently loaded file system drivers
cat /proc/filesystems

# Check auto-detectable file systems
cat /etc/filesystems
```

Key locations:
/proc/filesystems - Currently supported/loaded FS
/etc/filesystems - Kernel-updated auto-detected FS

## Creating File Systems

Before mounting, create a file system on the partition.

### Commands Overview
- mkfs.ext2 - Create ext2 FS
- mkfs.ext3 - Create ext3 FS  
- mkfs.ext4 - Create ext4 FS
- mkfs.fat - Create FAT FS
- mkfs.ntfs - Create NTFS FS

### Basic Usage
```bash
# Create ext3 on /dev/sdb partition
mkfs.ext3 /dev/sdb

# View file system details
blkid /dev/sdb
# or
lsblk -f  # Human-readable format
dumpe2fs /dev/sdb  # For ext FS details
```

### Tuning File Systems
Use `tune2fs` to modify ext2/ext3 FS parameters:

```bash
# Change reserved block percentage (default 5%)
tune2fs -r 5% /dev/sdb  # Set to 5%
# Change to 10%
tune2fs -r 10% /dev/sdb
```

### Convert File Systems
- ext2 to ext3: Journaling can be added without data loss
- ext3 to ext4: Conversion possible but data backup recommended

## Mounting Basics

Mounting attaches a file system to a directory (mount point).

### Manual Mounting
```bash
# Basic mount (auto-detects FS type)
mount /dev/sdb /mnt/data

# Specify file system type
mount -t ext4 /dev/sdb /mnt/data

# Mount ISO file
mount -t iso9660 /path/to/image.iso /mnt/iso
```

### Check Mount Status
```bash
# Currently mounted FS
mount
# or
cat /proc/mounts  # Kernel-updated info
cat /etc/mtab  # Command-updated info

# DF command for usage
df -h  # Human-readable disk usage
du -h /mount/point  # Directory usage
```

## Mounting Options

Common options for security and functionality:

```bash
# Read-only mount
mount -o ro /dev/sdb /mnt/data

# No execute permissions
mount -o noexec /dev/sdb /mnt/data

# No access times update (performance boost)
mount -o noatime /dev/sdb /mnt/data

# Multiple options
mount -o ro,noexec,noatime /dev/sdb /mnt/data

# Check mount info
cat /etc/mtab | grep sdb
```

> [!IMPORTANT]
> File system-level permissions override mount options. If FS blocks execute, mount noexec won't help.

### Demonstrating Options

```bash
# Mount with noexec
mount -o noexec /dev/sdb /mnt/data

# Attempt to execute file - fails due to FS-level restriction
./executable_file  # Permission denied

# Remount read-only during access
umount /dev/sdb
mount -o ro,noexec /dev/sdb /mnt/data

# Verify - read works, write fails
cat file.txt  # Works
echo "test" > newfile.txt  # Permission denied

# Note: ACLs cannot override noexec and nosuid options
```

## Permanent Mounting with FSTAB

Edit /etc/fstab for persistent mounts across reboots.

### FSTAB Format Fields
1. Device/Source (UUID preferred for reliability)
2. Mount point directory  
3. File system type
4. Options (defaults,ro,noexec, etc.)
5. Dump frequency (0 = disable)
6. File system check order (1 = root FS, 2 = other FS, 0 = disable)

### Example Entry
```
UUID=12345678-1234-1234-1234-123456789abc /mnt/data ext4 defaults 0 2
/dev/sdb /mnt/data ext4 noexec,ro,noatime 0 2
```

### Adding Entry Steps
1. Get partition UUID: `blkid /dev/partition`
2. Edit /etc/fstab with entry
3. Mount all from fstab: `mount -a`
4. Reboot to verify persistence

### Common FSTAB Options
- defaults - Equivalent to: rw,suid,dev,exec,auto,nouser,async
- ro - Read-only
- rw - Read-write  
- noexec - No execute permissions
- nosuid - Ignore SUID/SGID
- nodev - No device files
- noatime - Don't update access times

## Unmounting

```bash
# Unmount specific mount point
umount /mnt/data  

# Unmount by device
umount /dev/sdb

# Force unmount if busy
umount -f /mnt/data

# Lazy unmount (when device busy)
umount -l /mnt/data
```

## File System Management Tools

### Display File System Information
```bash
# Show file system types  
findmnt  # Better than mount

# Disk usage  
df -h  # Human readable
df -T  # Include FS type

# Directory usage
du -h /path

# FS details
tune2fs -l /dev/sdb  # For ext FS
dumpe2fs /dev/sdb
```

### Kernel Messages
```bash
# Check kernel messages for FS info
dmesg | grep sdb

# FS-specific logs
journalctl | grep mount
```

## Practical Demos

### Demo: Create and Mount ext3 FS
1. Format partition: `mkfs.ext3 /dev/sdb`
2. Mount: `mount /dev/sdb /mnt/test`
3. Verify: `df -h` shows mounted FS
4. Unmount: `umount /mnt/test`

### Demo: Permanent Mount
1. Get UUID: `blkid /dev/sdb`
2. Edit /etc/fstab using UUID
3. Reload: `mount -a`
4. Reboot and verify persistence

### Demo: Mount Options
- Create ext3 FS on /dev/sdb
- Mount with noexec: `mount -o noexec /dev/sdb /mnt/test`
- Place executable - execution blocked
- Remount ro: `mount -o remount,ro /mnt/test`
- Verify read-only behavior

## File System Check

Use fsck (file system check) tools for maintenance.

### Commands
```bash
# Check ext FS (run unmounted)
fsck.ext4 /dev/sdb  # or e2fsck /dev/sdb

# Force check even if clean
fsck.ext4 -f /dev/sdb

# Repair (if possible)  
fsck.ext4 -y /dev/sdb  # Auto-answer yes to repairs

# FSCK scripts check multiple FS types
/sbin/fsck.* compressed files in /usr/sbin/
```

### FSCK in Boot Process
- Root FS checked first (order 1 in fstab)
- Other FS checked sequentially
- Post unclean shutdown, checks ensure consistency

### When to Check FS
- After power failure or unclean shutdown
- For regular maintenance
- When suspecting corruption

> [!NOTE]
> Never run fsck on a mounted file system - can cause data loss.

</details>
