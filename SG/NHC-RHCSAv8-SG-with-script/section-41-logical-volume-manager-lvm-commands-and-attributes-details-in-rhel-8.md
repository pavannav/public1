# Section 41: Final LVM Session - Advanced Files, Recovery & Troubleshooting

<details open>
<summary><b>Section 41: Final LVM Session - Advanced Files, Recovery & Troubleshooting (CL-KK-Terminal)</b></summary>

## LVM Files and Configuration Entries in /etc/lvm/

### Overview
This section explores the critical configuration files and backup entries that LVM uses to manage logical volumes. The `/etc/lvm/` directory contains essential files that store metadata, track changes, and enable recovery operations. Understanding these files is crucial for LVM administration and troubleshooting.

### Key Concepts

**Core LVM Files in /etc/lvm/:**

- **backup**: Contains automatic backups of LVM configurations. Every time you modify LVM objects (VGs, LVs, PVs), changes are automatically logged here as text files.
```bash
ls /etc/lvm/backup/
```

- **cache**: Stores information about physical volumes and their locations
```bash
ls /etc/lvm/cache/
```

- **archive**: Contains detailed metadata for LVM objects, enabling recovery of deleted volumes using `vgcfgrestore` command
```bash
ls /etc/lvm/archive/
vgcfgrestore -f /etc/lvm/archive/VG_NAME_00000.vg VG_NAME
```

- **lvm.conf**: Main LVM configuration file where you can modify global settings, backup policies, and volume group behaviors
```bash
vim /etc/lvm/lvm.conf
```

- **profile/**: Contains user-defined profiles for customizing LVM behavior per volume group

### Code/Config Blocks

**Examining Backup Files:**
```bash
cat /etc/lvm/backup/vg_name.bkp
```

**Restoring from Archive:**
```bash
vgcfgrestore -f /etc/lvm/archive/vg_name_00001.vg vg_name
```

## Physical Volume Management Commands

### Overview
Physical Volume (PV) commands form the foundation of LVM operations. These commands handle disk preparation, attribute changes, and troubleshooting at the base layer.

### Key Concepts

**PV Display and Scanning:**
- `pvdisplay`: Shows detailed information about physical volumes
- `pvdisplay -m`: Shows mapping details with logical extents
- `pvs`: Compact view of PV status, size, and allocation

**PV Creation and Management:**
- `pvcreate`: Initializes disks or partitions for LVM use
- `pvremove`: Removes LVM labels from devices
- `pvchange`: Modifies PV attributes (allocation policy, etc.)

**PV Attributes Interpretation:**
| Attribute | Status | Meaning |
|-----------|---------|---------|
| a | alloc | Free to be allocated |
| u | unalloc | No free extents available |
| 1 | allocated | Extent is allocated to LV |
| - | unallocated | Extent is free |

### Code/Config Blocks

**Display PV Information:**
```bash
pvdisplay
pvs -v
```

**Create Physical Volume:**
```bash
pvcreate /dev/sdb
```

**Change PV Attributes:**
```bash
pvchange -x n /dev/sdb  # Turn off allocation
pvchange -x y /dev/sdb  # Turn on allocation
```

**Scan for PVs:**
```bash
pvscan
pvscan --cache  # Update cache
```

## Volume Group Management Commands

### Overview
Volume Group (VG) commands manage collections of physical volumes. This layer abstracts storage pools and handles distributed storage across multiple disks.

### Key Concepts

**VG Display and Information:**
- `vgdisplay`: Shows complete VG details including size, PV count, LV count
- `vgs`: Compact view with VG status
- `vgscan`: Scans for volume groups and updates cache

**VG Flags and Options:**
| Flag | Description |
|------|-------------|
| --maxlogicalvolumes | Maximum number of LVs in VG |
| --maxphysicalvolumes | Maximum number of PVs in VG |
| --physicalextentsize | Size of physical extents (default 4MB) |
| --clustered | Enable clustering for shared storage |

**VG Attributes:**
| Attribute | Meaning |
|-----------|---------|
| w | writeable |
| r | readonly |
| z | resized |
| x | exportable |

### Code/Config Blocks

**Create VG with Options:**
```bash
vgcreate --maxlogicalvolumes 512 --maxphysicalvolumes 256 --physicalextentsize 32M vg_name /dev/sdb
```

**Display VG Information:**
```bash
vgdisplay vg_name
vgs -v vg_name
```

**Extend/Reduce VG:**
```bash
vgextend vg_name /dev/sdc
vgreduce vg_name /dev/sdc
```

## Logical Volume Management Commands

### Overview
Logical Volume (LV) commands create, modify, and manage actual usable filesystem storage. This is where abstract storage becomes practical filesystem space.

### Key Concepts

**LV Display and Status:**
- `lvdisplay`: Detailed LV information including segments and mapping
- `lvs`: Compact LV view
- `lvscan`: Scan for logical volumes

**LV Creation Options:**
| Option | Description |
|--------|-------------|
| -m | Mirror count (for RAID-1) |
| -s | Create snapshot |
| -I | Stripe size |
| -i | Number of stripes |
| --type | LV type (linear, striped, mirror, etc.) |

**LV Attributes:**
| Position | Attribute | Meaning |
|----------|-----------|---------|
| 1 | w/r | writable/readable |
| 2 | i | inherited permissions |
| 5 | a | active |
| 9 | s | snapshot |

### Code/Config Blocks

**Create LV Types:**
```bash
# Linear LV
lvcreate -L 2G -n lv_name vg_name

# Stripped LV
lvcreate -L 2G -i 2 -I 64K -n lv_stripe vg_name

# Mirror LV
lvcreate -L 2G -m1 -n lv_mirror vg_name

# Convert to Mirror
lvconvert -m1 vg_name/lv_name
```

**Snapshot Creation:**
```bash
lvcreate -s -L 500M -n snap_lv lv_name
```

**LV Management:**
```bash
lvrename vg_name old_name new_name
lvremove vg_name/lv_name
lvchange -ay vg_name/lv_name  # Activate
lvchange -an vg_name/lv_name  # Deactivate
```

## Disk Management and Partitioning Preparation

### Overview
Before using disks with LVM, proper partitioning is essential. This section covers preparing physical disks with proper partitioning for LVM operations.

### Key Concepts

**Partition Types:**
- Linux LVM uses type 8e (Linux LVM) in fdisk
- Proper alignment and sizing is crucial for performance
- Multiple partitions can be used as separate PVs

> [!NOTE]
> Always use GPT for modern systems with disks > 2TB

### Code/Config Blocks

**Partition Disk for LVM:**
```bash
fdisk /dev/sdb
# Commands in fdisk:
# n (new partition)
# p (primary)
# 1 (partition number)
# Enter (default start)
# Enter (default end - full disk)
# t (change type)
# 8e (Linux LVM)
# w (write and exit)
```

**Initialize Partition as PV:**
```bash
pvcreate /dev/sdb1
```

## Troubleshooting and Recovery Techniques

### Overview
LVM failures require systematic recovery procedures. Corrupted metadata or hardware failures can be recovered using archived configurations and repair commands.

### Key Concepts

**Common Failure Scenarios:**
- Physical disk failure in VG
- Corrupted PV metadata
- Lost VG configuration
- Failed mirror legs

**Recovery Priority:**
1. Assess damage (`vgscan`, `pvscan`)
2. Reduce VG if missing PVs (`vgreduce --removemissing`)
3. Restore from backup (`vgcfgrestore`)
4. Recreate affected components
5. Re-add repaired PVs

### Code/Config Blocks

**Identify Failed PV:**
```bash
pvscan  # Will show "missing PV" errors
vgscan  # May show incomplete VG
```

**Recover from Missing PV:**
```bash
# Reduce VG to remove missing PV
vgreduce --removemissing --force vg_name

# Or restore from backup
vgcfgrestore -f /etc/lvm/backup/vg_name.bkp vg_name
```

**Repair Corrupted PV:**
```bash
# Check filesystem first
fsck /dev/vg_name/lv_name

# If PV corrupted, try to repair
pvck /dev/sdb1  # Check integrity
pvck --dump /dev/sdb1  # Dump metadata to screen
```

**Move Data from Failing PV:**
```bash
# Move active extents off failing PV
pvmove /dev/sdb1

# Then remove the PV
vgreduce vg_name /dev/sdb1
```

## Lab Demo: Full Recovery Scenario

### Overview
This comprehensive demo shows recovering from a disk failure scenario where one PV in a mirrored setup fails, gets replaced, and the system is restored to full functionality.

### Lab Steps

1. **Create Test Environment:**
```bash
# Create VG with two PVs
fdisk /dev/sdb1 /dev/sdc1  # Partition both disks
pvcreate /dev/sdb1 /dev/sdc1
vgcreate mirror_vg /dev/sdb1 /dev/sdc1
lvcreate -m1 -L 2G -n mirror_lv mirror_vg
mkfs.ext4 /dev/mirror_vg/mirror_lv
```

2. **Simulate Disk Failure:**
```bash
# "Fail" one disk by corrupting partition table
dd if=/dev/zero of=/dev/sdb1 bs=1M count=1
```

3. **Detect and Assess Failure:**
```bash
pvscan  # Shows missing PV
vgdisplay mirror_vg  # Shows partial VG
```

4. **Repair Process:**
```bash
# Remove missing PV from VG
vgreduce --removemissing --force mirror_vg

# Add new disk
fdisk /dev/sdd1 && pvcreate /dev/sdd1
vgextend mirror_vg /dev/sdd1

# Convert back to mirror
lvconvert -m1 mirror_vg/mirror_lv /dev/sdd1
```

## Expert LVM Configuration Flags

### Overview
Advanced LVM configuration uses flags and attributes to control behavior and optimize performance across enterprise environments.

### Key Configuration Flags

**VG Creation Flags:**
```bash
vgcreate --systemid myserver --allocation contiguous --clustered y cluster_vg /dev/sd{b..h}
```

**LV Creation Options:**
```bash
lvcreate --stripesize 256k --stripes 4 --mirrors 2 --alloc cling -L 10G -n data_lv data_vg
```

**Caching Configuration:**
```bash
lvcreate --type cache-pool -L 5G -n cache_pool data_vg /dev/fast_ssd
lvconvert --type cache --cachepool data_vg/cache_pool data_vg/data_lv
```

## Summary

### Key Takeaways
```diff
! LVM consists of three layers: PV (Physical Volumes), VG (Volume Groups), and LV (Logical Volumes)
+ Physical Volume commands provide foundation operations for disk management
- Volume Group commands manage storage pools and distribution across disks
+ Logical Volume commands create actual filesystem space with various RAID configurations
+ Recovery from failures follows systematic approach: assess, reduce, restore, recreate
+ Archive files (/etc/lvm/archive/) enable complete recovery even after deletions
! Mirror conversion and sneakshots require careful planning and proper order of operations
```

### Quick Reference Commands

**Essential PV Commands:**
```bash
pvcreate /dev/sdb               # Initialize PV
pvdisplay                      # Show PV details
pvscan --cache                 # Scan and cache PVs
pvchange -ay /dev/sdb          # Activate PV
```

**Volume Group Operations:**
```bash
vgcreate vg_name /dev/sdb      # Create VG
vgdisplay vg_name              # Show VG details
vgextend vg_name /dev/sdc      # Add PV to VG
vgreduce vg_name /dev/sdc      # Remove PV from VG
```

**Logical Volume Management:**
```bash
lvcreate -L 5G -n lv_name vg_name    # Create LV
lvdisplay vg_name/lv_name           # Show LV details
lvextend -L +2G vg_name/lv_name     # Extend LV
lvremove vg_name/lv_name            # Delete LV
```

**Emergency Recovery:**
```bash
vgreduce --removemissing vg_name    # Remove failed PVs
vgcfgrestore -f backup_file vg_name # Restore from backup
pvmove /dev/sdb                     # Move data off PV
```

### Expert Insight

**Real-world Application**: In enterprise environments, LVM enables dynamic storage management where business-critical applications can expand storage without downtime by adding new disks and extending logical volumes seamlessly.

**Expert Path**: Master the relationship between `/etc/lvm/` files and how they enable disaster recovery. Focus on automated backup verification and mirror configuration for high-availability systems.

**Common Pitfalls**: Avoid storing database files directly on LVs without proper filesystem tuning. Always test recovery procedures in staging before applying in production. Never force-remove PVs without data evacuation.

</details>
