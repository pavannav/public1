# Section 37: Migration of Logical Volume from One Disk to Another

## Table of Contents

#### 1. [Introduction and Setup](#introduction-and-setup)
#### 2. [Migrating a Single Logical Volume with Data](#migrating-a-single-logical-volume-with-data)
#### 3. [Migrating the Entire Root Filesystem and Swap](#migrating-the-entire-root-filesystem-and-swap)
#### 4. [Summary](#summary)

## 1. Introduction and Setup

### Overview
This section covers the migration of logical volumes (LVs) along with their data from one physical disk to another. This is a critical operation in storage management, allowing administrators to relocate data without downtime or data loss. We'll demonstrate both single LV migration and full system migration (root and swap filesystems), using commands like `pvmove`, `vgextend`, and `vgreduce`.

### Key Concepts
Logical Volume Migration involves moving data from one physical volume (PV) to another within the same Volume Group (VG). The key components include:
- **Physical Volumes (PV)**: Storage devices or partitions converted for LVM use
- **Volume Groups (VG)**: Logical groupings of PVs
- **Logical Volumes (LV)**: Virtual disks created from VG space
- **pvmove**: The command that performs the data migration

### Lab Demo: Initial Setup
1. Create additional disks for migration testing:
   ```bash
   # Assume we have /dev/sdb (10GB) and /dev/sdc (10GB) as additional disks
   lsblk  # Verify disk availability
   ```

2. Create a partition on the first disk:
   ```bash
   fdisk /dev/sdb
   # n → p → 1 → [Enter] → [Enter] → t → 8e → w
   partprobe  # Reload partition table
   lsblk  # Verify partition creation
   ```

3. Convert partition to Physical Volume:
   ```bash
   pvcreate /dev/sdb1
   pvdisplay  # Verify PV creation
   ```

4. Create Volume Group:
   ```bash
   vgcreate data_vg /dev/sdb1
   vgs  # Verify VG creation
   ```

5. Create Logical Volume:
   ```bash
   lvcreate -L 4G -n data_lv data_vg
   lvs  # Verify LV creation
   ```

6. Format and mount the LV:
   ```bash
   mkfs.ext4 /dev/data_vg/data_lv
   mkdir /data
   mount /dev/data_vg/data_lv /data
   df -h  # Verify mount
   ```

7. Create sample data for migration:
   ```bash
   cd /data
   mkdir test_dir
   echo "Sample data for migration" > test_dir/sample.txt
   md5sum test_dir/sample.txt  # Note checksum for verification
   ```

## 2. Migrating a Single Logical Volume with Data

### Overview
To migrate a single LV, we need to:
1. Extend the VG with a new PV
2. Move the LV data using `pvmove`
3. Remove the old PV from the VG
4. Resize the VG if needed

### Key Concepts
- **VG Extension**: Add new PV to the VG for migration target
- **Data Movement**: `pvmove` copies data in the background
- **PV Removal**: Reduces VG size, moves data off the old PV

### Lab Demo: LV Migration Steps

1. Prepare the target partition:
   ```bash
   fdisk /dev/sdc
   # n → p → 1 → [Enter] → [Enter] → t → 8e → w
   partprobe
   pvcreate /dev/sdc1
   pvdisplay
   ```

2. Extend Volume Group:
   ```bash
   vgextend data_vg /dev/sdc1
   vgs  # Note: VG size increases to ~20GB
   ```

3. Verify current PV distribution:
   ```bash
   pvdisplay -m  # Check which PV contains the old_extents
   ```

4. Move LV data:
   ```bash
   pvmove -n data_lv /dev/sdb1 /dev/sdc1
   # This command moves data from /dev/sdb1 to /dev/sdc1
   ```

   > [!NOTE]
   > The `pvmove` command works in the background. Monitor progress with `pvs` or wait for completion.

5. Verify data integrity:
   ```bash
   md5sum /data/test_dir/sample.txt  # Should match original checksum
   lvs -o+devices  # Check LV is now on new PV
   ```

6. Remove old PV:
   ```bash
   vgreduce data_vg /dev/sdb1
   pvremove /dev/sdb1
   vgs  # VG size reduced back to 10GB
   ```

7. Verify final state:
   ```bash
   pvdisplay
   vgs
   lvs
   ```

> [!IMPORTANT]
> Always ensure VG has sufficient space before starting migration. The target PV should be larger than the data being moved.

## 3. Migrating the Entire Root Filesystem and Swap

### Overview
Migrating root (/) and swap filesystems involves moving multiple LVs. This is typically done for disk replacement or to consolidate storage. The process is similar but requires careful handling since these are system-critical filesystems.

### Key Concepts
- **Root Migration**: Move the entire / filesystem while maintaining system stability
- **Swap Migration**: Move swap space to new disk
- **System Constraints**: Ensure sufficient space on target and backup critical data

### Prerequisites
- Additional disk with enough space for root + swap (~10-20GB minimum)
- System backup recommended (though not required for this demo)

### Lab Demo: Root and Swap Migration

1. Identify current system LVs:
   ```bash
   lvs  # Identify root and swap LVs
   ```

2. Prepare additional target disk (assume /dev/nvme0n1p3 as example):
   ```bash
   fdisk /dev/nvme0n1p3  # Create partition
   partprobe
   pvcreate /dev/nvme0n1p3
   ```

3. Extend VG:
   ```bash
   vgextend rhel /dev/nvme0n1p3  # Replace 'rhel' with your VG name
   vgs
   ```

4. Migrate root LV:
   ```bash
   pvmove -n root /dev/sdl1 /dev/nvme0n1p3  # Move root LV data
   # Wait for completion
   ```

5. Migrate swap LV:
   ```bash
   pvmove -n swap /dev/sdl1 /dev/nvme0n1p3  # Move swap LV data
   # Wait for completion
   ```

6. Verify migration:
   ```bash
   lvs -o+devices  # Check LVs are on new PV
   df -h /  # Verify root filesystem
   ```

7. Remove old PV:
   ```bash
   vgreduce rhel /dev/sdl1  # Reduce VG to remove old PV
   pvremove /dev/sdl1
   vgs
   ```

> [!WARNING]
> Never perform critical system migrations without backups in production. This operation can render systems unbootable if errors occur.

### Monitoring Migration Progress

```bash
# Check pvmove progress
pvdisplay -m | grep -A 10 "under migration"

# Monitor I/O activity
iostat -x 1

# Check system load
uptime
```

## Summary

### Key Takeaways
```diff
+ Logical Volume Migration allows moving data between disks without downtime
- Always backup critical data before system migrations
! pvmove operates in background; use pvdisplay to monitor progress
+ VG must be extended with target PV before migration
- Never reduce VG containing only PV without data redistribution
```

### Quick Reference
| Command | Description | Example |
|---------|-------------|---------|
| `pvmove` | Migrate LV data between PVs | `pvmove -n lv_name /dev/old_pv /dev/new_pv` |
| `vgextend` | Add PV to VG | `vgextend vg_name /dev/new_pv` |
| `vgreduce` | Remove PV from VG | `vgreduce vg_name /dev/old_pv` |
| `pvdisplay -m` | Show PV allocation details | Check which extents are allocated |

### Expert Insight

#### Real-world Application
In production environments, LV migration is used for:
- Disk replacement during hardware upgrades
- Rebalancing storage across different disk types
- Moving critical data to faster storage
- Preparing systems for disk decommissioning

#### Expert Path
- Learn LVM mirroring (`lvconvert --type mirror`) for high availability
- Study thin provisioning for advanced storage efficiency
- Practice with `dmsetup` commands for deeper LVM internals

#### Common Pitfalls
- Insufficient target disk space causing migration failures
- Forgetting to update bootloader after root migration
- Running migrations during peak load periods
- Not verifying data integrity post-migration
