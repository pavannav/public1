# Section 36: Logical Volume Management Merging and Splitting 

<details open>
<summary><b>Section 36: Logical Volume Management Merging and Splitting (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Merging Volume Groups](#merging-volume-groups)
- [Splitting Volume Groups](#splitting-volume-groups)
- [Lab Demonstration](#lab-demonstration)
- [Summary](#summary)

## Overview

This section covers advanced Logical Volume Management (LVM) operations focusing on merging and splitting volume groups. You'll learn how to combine multiple volume groups into a single unified volume group and how to divide existing volume groups into separate entities. These operations are crucial for storage management in production environments where you need to reorganize storage resources dynamically without data loss.

## Key Concepts

### Volume Group Operations
Volume groups serve as virtual containers that aggregate physical storage devices. When managing multiple volume groups, you may need to:

- **Merge operations**: Combine separate volume groups into one larger entity
- **Split operations**: Divide a large volume group into smaller, specialized groups
- **Data preservation**: Both operations maintain data integrity without requiring backups

### Extended Logical Volumes
The session demonstrates using `-l` (extents) instead of `-L` (size) for logical volume creation, allowing more precise storage allocation.

> [!NOTE]
> All merge/split operations require deactivated volume groups to prevent data corruption.

## Merging Volume Groups

### Prerequisites
- Multiple volume groups with logical volumes
- Data backed up (though operations preserve data)
- Root access to LVM commands

### Step-by-Step Process

1. **Deactivate Target Volume Group**
   ```bash
   vgchange -a n <target_vg_name>
   ```

2. **Execute Merge Operation**
   ```bash
   vgmerge <destination_vg> <source_vg>
   ```

3. **Reactivate Logical Volumes**
   ```bash
   lvchange -a y <lv_path>
   # OR for all LVs in VG:
   vgchange -a y <destination_vg>
   ```

### Important Commands
```bash
# Check volume group status
vgs

# Display volume group details
vgdisplay <vg_name>

# Verify logical volumes
lvs

# Display physical volumes
pvs
```

## Splitting Volume Groups

### Prerequisites
- Single volume group containing multiple physical volumes
- Knowledge of which physical volumes to separate
- Deactivated volume group

### Step-by-Step Process

1. **Deactivate Volume Group**
   ```bash
   vgchange -a n <vg_name>
   ```

2. **Execute Split Operation**
   ```bash
   vgsplit <source_vg> <new_vg_name> <physical_volume>
   ```

3. **Reactivate Both Volume Groups**
   ```bash
   vgchange -a y <original_vg>
   vgchange -a y <new_vg_name>
   ```

4. **Mount Filesystems**
   ```bash
   mount <lv_path> <mount_point>
   ```

## Lab Demonstration

### Scenario Setup
- Using a 10GB disk divided into two 5GB partitions
- Creating physical volumes (PV), volume groups (VG), and logical volumes (LV)
- Demonstrating merge of two volume groups
- Then splitting the merged volume group back

### Extended Logical Volume Creation
```bash
# Create LV with extent specification
lvcreate -l 100 -n <lv_name> <vg_name>

# Where 100 represents number of physical extents
# Each extent defaults to 4MB (configurable)
```

### Command Sequence
```bash
# Partition disk
fdisk /dev/sdb
# Create 2x 5GB primary partitions

# Create physical volumes
pvcreate /dev/sdb1 /dev/sdb2

# Create volume groups
vgcreate vg1 /dev/sdb1
vgcreate vg2 /dev/sdb2

# Create logical volumes
lvcreate -l 100 -n lv1 vg1
lvcreate -l 100 -n lv2 vg2

# Format and mount
mkfs.ext4 /dev/vg1/lv1
mkfs.ext4 /dev/vg2/lv2
mount /dev/vg1/lv1 /test1
mount /dev/vg2/lv2 /test2

# Populate with test data
# ... create files and directories ...

# Deactivate second VG for merge
vgchange -a n vg2

# Merge vg2 into vg1
vgmerge vg1 vg2

# Reactivate logical volumes
lvchange -a y /dev/vg1/lv2

# Remount filesystems under single VG
umount /test1 /test2
mount /dev/vg1/lv1 /test1
mount /dev/vg1/lv2 /test2
```

For splitting:
```bash
# Deactivate VG
vgchange -a n vg1

# Split off one PV to new VG
vgsplit vg1 vg2 /dev/sdb2

# Reactivate both VGs
vgchange -a y vg1
vgchange -a y vg2

# Reactivate LVs individually if needed
lvchange -a y /dev/vg1/lv1
lvchange -a y /dev/vg2/lv2
```

## Summary

### Key Takeaways

```diff
+ Volume group merging combines separate VGs into unified storage pools
+ Splitting divides large volume groups for specialized use cases
+ Both operations preserve data without requiring backups
+ Physical volumes determine what can be split/merged
+ Deactivation is mandatory before merge/split operations
```

### Quick Reference
| Operation | Command | Key Points |
|-----------|---------|------------|
| Merge VGs | `vgmerge <dest> <src>` | Deactivate source VG first |
| Split VG | `vgsplit <src> <new> <pv>` | Specify physical volume to split |
| Deactivate VG | `vgchange -a n <vg>` | Required for merge/split |
| Activate LV | `lvchange -a y <lv>` | Reactivate after operations |

### Expert Insight

#### Real-world Application
In production environments, volume group merging is invaluable for consolidating storage from decommissioned servers or combining SAN-attached storage. Splitting is essential for creating dedicated VGs for database versus application storage, improving performance and management.

#### Expert Path
- Master physical volume sizing strategies before merge/split
- Implement LVM backup automation before major restructures
- Study advanced LVM features like thin provisioning and RAID
- Practice in test environments before production changes

#### Common Pitfalls
> [!CAUTION]
> - Never merge active volume groups - data corruption guaranteed
- - Always backup critical data before LVM operations
- - Verify physical volume paths before splitting
- - Test mount operations after reactivation

> [!WARNING]
> Splitting operations require careful physical volume selection - choose wisely to avoid data fragmentation.

</details>
