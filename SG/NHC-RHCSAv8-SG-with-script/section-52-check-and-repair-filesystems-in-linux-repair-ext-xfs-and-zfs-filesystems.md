# Section 52: Linux File System Check and Repair

<details open>
<summary><b>Section 52: Linux File System Check and Repair (CL-KK-Terminal)</b></summary>

## Table of Contents

- [File System Check Commands Overview](#file-system-check-commands-overview)
- [Required Packages and Dependencies](#required-packages-and-dependencies)  
- [FSCK Exit Codes](#fsck-exit-codes)
- [FSCK vs E2FSCK Differences](#fsck-vs-e2fscK-differences)
- [FSCK Command Options](#fsck-command-options)
- [Checking Different File System Types](#checking-different-file-system-types)
- [File System Mount State Requirements](#file-system-mount-state-requirements)
- [Practical Lab: Creating Test File Systems](#practical-lab-creating-test-file-systems)
- [Root File System Checking in Rescue Mode](#root-file-system-checking-in-rescue-mode)
- [Repairing Corrupted File Systems](#repairing-corrupted-file-systems)
- [Summary](#summary)

## File System Check Commands Overview

### Overview
This section introduces the essential commands used for checking and repairing Linux file systems, focusing on FSCK and E2FSCK utilities. These tools are critical for maintaining file system integrity and recovering from corruption issues.

### Key Concepts
- **FSCK**: File System Consistency Check - primary utility for checking file systems
- **E2FSCK**: Extended file system check tool specifically for ext2/ext3/ext4 file systems  
- **xfs_repair**: Separate utility for XFS file systems
- **fsck options**: Various flags to control behavior (forced check, repair, verbose output)

**Key Command Patterns:**
```bash
# Basic FSCK usage
fsck /dev/sdXn

# Force check (even if clean)
fsck -f /dev/sdXn

# FSCK with auto-repair
fsck -p /dev/sdXn
```

## Required Packages and Dependencies

### Overview
Before using file system check tools, ensure the correct packages are installed on your Linux system. Different file systems require different utilities.

### Key Concepts

**Package Requirements:**
- **util-linux**: Contains the `fsck` command for general file system checking
- **e2fsprogs**: Contains `e2fsck` specifically for ext2/ext3/ext4 file systems

**Verification Commands:**
```bash
# Check if fsck is available
rpm -qf /sbin/fsck

# Check if e2fsck is available  
rpm -qf /sbin/e2fsck

# Find what package provides specific commands
rpm -qf `which fsck` `which e2fsck`
```

> [!NOTE]
> Without these packages installed, fsck commands will not work. This is a common source of confusion when troubleshooting file system issues.

## FSCK Exit Codes

### Overview
Understanding FSCK exit codes is crucial for interpreting the results of file system checks and determining appropriate repair actions.

### Key Concepts

**Exit Code Meanings:**
- **0**: File system is clean, no errors found
- **1**: File system had errors that were corrected
- **2**: File system should be rebooted immediately (serious errors)
- **4**: File system errors left uncorrected
- **8**: Operational error occurred
- **16**: Usage or syntax error
- **128**: Shared library error

**Table of FSCK Exit Codes:**

| Exit Code | Meaning |
|-----------|---------|
| 0 | No errors found |
| 1 | Errors were corrected |
| 2 | Reboot required |
| 4 | Errors left uncorrected |
| 8 | Operational error |
| 16 | Syntax error |
| 128 | Library error |

## FSCK vs E2FSCK Differences

### Overview
While both tools check file systems, they have important behavioral differences that affect when each should be used.

### Key Concepts

**Behavioral Differences:**

| Aspect | FSCK | E2FSCK |
|--------|------|--------|
| **Target Systems** | General purpose | Ext2/3/4 specific |
| **Wrapper Behavior** | Calls e2fsck for ext file systems | Native ext checker |
| **Development History** | Older wrapper tool | Dedicated modern tool |
| **Primary Use** | General file system checking | Ext family file systems |

**Key distinction:**
- FSCK acts as a wrapper and calls e2fsck automatically for ext2/3/4 file systems
- E2FSCK is the native tool for ext file systems with more options

## FSCK Command Options

### Overview
FSCK provides numerous options to control checking behavior, repair actions, and output verbosity. Understanding these options is essential for effective file system maintenance.

### Key Concepts

**Common FSCK Options:**

| Option | Description |
|--------|-------------|
| `-p` | Auto-repair mode (no user interaction) |
| `-n` | Check only (read-only mode, no repairs) |
| `-y` | Assume "yes" to all questions |
| `-f` | Force check even if file system appears clean |
| `-v` | Verbose output |
| `-b` | Specify superblock location |
| `-m` | Check if file system was properly unmounted |
| `-C` | Show progress bar |
| `-t` | Specify file system type |

**Example Usage:**
```bash
# Force check with verbose output
fsck -fv /dev/sdXn

# Auto-repair with progress display
fsck -pC /dev/sdXn

# Check-only mode for verification
fsck -n /dev/sdXn
```

## Checking Different File System Types

### Overview
Different file systems require different checking tools. Ext-based systems use FSCK/e2fsck, while XFS uses xfs_repair.

### Key Concepts

**File System Types and Tools:**

| File System | Primary Tool | Secondary Tool |
|-------------|--------------|----------------|
| ext2 | e2fsck | fsck |
| ext3 | e2fsck | fsck |
| ext4 | e2fsck | fsck |
| xfs | xfs_repair | N/A |

**Commands by File System:**

**For EXT file systems:**
```bash
# Using e2fsck directly
e2fsck /dev/sdXn

# Using fsck (calls e2fsck internally)
fsck /dev/sdXn
```

**For XFS file systems:**
```bash
# XFS repair (no check-only option, always repairs)
xfs_repair /dev/sdXn
```

## File System Mount State Requirements

### Overview
File systems must be in the correct mount state for checking operations to work properly. This is a common source of issues when troubleshooting.

### Key Concepts

**Mount State Rules:**
- ❌ **MOUNTED file systems cannot be checked**
- ✅ **UNMOUNTED file systems must be checked**

**Common Error Scenarios:**
```bash
# This will fail - file system is mounted
fsck /dev/sda1
# Error: /dev/sda1 is mounted

# Correct approach - unmount first
umount /dev/sda1
fsck /dev/sda1
```

**Exception:** Root file system requires rescue mode to unmount

## Practical Lab: Creating Test File Systems

### Overview
This section demonstrates creating test partitions and file systems for practicing check and repair operations.

### Key Concepts

**Partition Creation Process:**
```bash
# Launch fdisk
fdisk /dev/sdb

# Create partitions:
# n (new), p (primary), 1 (number), default start, +5G (size)
# n (new), p (primary), 2 (number), default start, +5G (size)
# w (write changes)
```

**File System Creation:**
```bash
# Format ext4
mkfs.ext4 /dev/sdb1

# Format xfs  
mkfs.xfs /dev/sdb2
```

**Mounting File Systems:**
```bash
# Add to /etc/fstab
/dev/sdb1 /data1 ext4 defaults 0 0
/dev/sdb2 /data2 xfs defaults 0 0

# Mount all
mount -a
```

## Root File System Checking in Rescue Mode

### Overview
Root file system checking requires booting into rescue mode since the root file system cannot be unmounted during normal operation.

### Key Concepts

**Rescue Mode Steps:**

1. **Boot from Installation Media**
   - Insert bootable USB/DVD
   - Select "Troubleshooting" → "Rescue a Red Hat Enterprise Linux system"

2. **Activate Logical Volumes**
   ```bash
   # Check volume groups
   vgs
   
   # Activate all volume groups
   vgchange -a y
   ```

3. **Find Root File System**
   ```bash
   # Check mounts and identify root
   df -h
   
   # Alternative: check blkid output
   blkid
   ```

4. **Perform File System Check**
   ```bash
   # For XFS root (common on RHEL 8+)
   xfs_repair /dev/mapper/rhel-root
   
   # For ext4 root
   e2fsck /dev/mapper/rhel-root
   ```

5. **Reboot to Normal System**
   ```bash
   # Reboot after successful repair
   reboot
   ```

## Repairing Corrupted File Systems

### Overview
File system corruption can occur due to improper shutdowns, disk errors, or improper operations. This section covers repair procedures for corrupted file systems.

### Key Concepts

**Common Corruption Scenarios:**

| Corruption Type | Causes | Repair Method |
|----------------|--------|---------------|
| **Superblock Corruption** | Sudden power loss, disk errors | Use backup superblock |
| **Journal Corruption** | System crash during writes | FSCK auto-repair |
| **Inode Damage** | Hardware failure | FSCK with -y option |
| **Partition Table Issues** | Disk cloning errors, fdisk misuse | Recreate partitions |

**Repair Examples:**

**Repairing EXT File System:**
```bash
# Force repair with yes to all prompts
fsck -fy /dev/sdXn

# Verbose repair with progress
fsck -fCy /dev/sdXn
```

**Repairing XFS File System:**
```bash
# XFS repair (read-write by default)
xfs_repair -v /dev/sdXn
```

**Handling Superblock Issues:**
```bash
# Find backup superblocks first
dumpe2fs /dev/sdXn | grep -i superblock

# Repair using backup
e2fsck -b 32768 -y /dev/sdXn
```

## Summary

### Key Takeaways
```diff
+ File system integrity is critical for Linux system reliability
+ FSCK (fsck) and E2FSCK are primary tools for ext2/3/4 file systems  
+ XFS uses xfs_repair instead of fsck
- Never run fsck on mounted file systems
- Root file system requires rescue mode for checking
! Always backup data before repairing corrupted file systems
```

### Quick Reference

**Common FSCK Commands:**
```bash
# Check file system (read-only)
fsck -n /dev/sdXn

# Force check and auto-repair
fsck -fp /dev/sdXn

# Verbose check with progress
fsck -fvC /dev/sdXn

# Repair XFS file system
xfs_repair /dev/sdXn
```

**Rescue Mode Root Check:**
```bash
# Boot from install media → Troubleshooting → Rescue
vgchange -a y                    # Activate LVs
blkid                            # Find root device  
xfs_repair /dev/mapper/rhel-root  # Repair XFS root
reboot                           # Restart system
```

### Expert Insight

**Real-world Application**: File system checking is essential in production environments for preventing data loss. Schedule regular fsck runs during maintenance windows and implement proper shutdown procedures to minimize corruption risks.

**Expert Path**: Master the differences between file system types and their specific repair tools. Learn to interpret FSCK exit codes and log analysis for proactive maintenance. Understand backup superblock locations for disaster recovery.

**Common Pitfalls**: 
- Running fsck on mounted file systems (causes damage)
- Not backing up critical data before repair operations
- Confusing FSCK options leads to unintended consequences
- Failing to update /etc/fstab after partition changes

</details>
