<details open>
<summary><b>Section 49: RAID 10 Configuration in Linux (CL-KK-Terminal)</b></summary>

# Section 49: RAID 10 Configuration in Linux

## Table of Contents
- [Overview](#overview)
- [RAID 10 Block Diagram](#raid-10-block-diagram)
- [How RAID 10 Works](#how-raid-10-works)
- [Advantages of RAID 10](#advantages-of-raid-10)
- [Disadvantages of RAID 10](#disadvantages-of-raid-10)
- [Creating RAID 10 in Linux](#creating-raid-10-in-linux)
- [Managing RAID Devices](#managing-raid-devices)
- [RAID Failure and Recovery](#raid-failure-and-recovery)
- [Configuring LVM on RAID 10](#configuring-lvm-on-raid-10)
- [Building Nested RAID on Logical Volumes](#building-nested-raid-on-logical-volumes)
- [Summary](#summary)

## Overview
RAID 10 (Redundant Array of Independent Disks Level 10) combines the features of RAID 1 (mirroring) and RAID 0 (striping). It provides both performance improvements through striping and data redundancy through mirroring. In RAID 10, data is striped across multiple mirrored sets. This section demonstrates the theoretical concept, advantages, disadvantages, and practical implementation of RAID 10 in Linux using the `mdadm` command.

## RAID 10 Block Diagram
RAID 10 uses a combination of striping (RAID 0) and mirroring (RAID 1). The lower layer consists of mirroring, which ensures data redundancy, while the upper layer handles striping for performance.

- **Visual Representation** (Mermaid):
  ```mermaid
  graph TD
      A[Data Input] --> B[Striping (RAID 0)]
      B --> C[Mirror Set 1: Disk1 & Disk2]
      B --> D[Mirror Set 2: Disk3 & Disk4]
      C --> E[Application]
      D --> E
      style B fill:#f9f
      style C fill:#bbf
      style D fill:#bbf
  ```

Each mirrored pair (stripes) operates independently, and data is distributed across these sets.

## How RAID 10 Works
RAID 10 alternates between mirroring and striping:
- Two drives form a mirrored pair (RAID 1).
- These pairs are then striped together (RAID 0).
- Parity is not used; instead, exact copies of data are maintained via mirroring.

### Data Write Process
- Original data (e.g., 10101) is split into 4-bit chunks.
- Bits go to Stripe 1 (bits 1-4) and Stripe 2 (bits 5-8).
- Each stripe is mirrored identically:
  - Stripe 1 data → Disk1 and Disk2
  - Stripe 2 data → Disk3 and Disk4

### Animation Explanation
Using disk animation:
- Four disks: sdb, sdc, sdd, sde.
- RAID 10 created with `mdadm --create --level=10`.
- Lower end: Mirroring (sdb with sdc; sdd with sde).
- Upper end: Striping across the mirrored pairs.
- Data blocks are distributed alternately:
  - Block 1 → Mirror set A
  - Block 2 → Mirror set B
- If one disk fails (e.g., sdb), set A is degraded, but data remains intact because it's mirrored.

### Sets in RAID 10
- **Set A**: sdb and sdc (mirrored pair)
- **Set B**: sdd and sde (mirrored pair)
- Data is striped between sets, ensuring 2-drive failure tolerance if opposite disks fail.

> [!IMPORTANT]
> RAID 10 can tolerate up to 2 drive failures as long as they are not both from the same mirrored pair.

## Advantages of RAID 10
```diff
+ Performance: Excellent read/write speeds due to striping.
+ Fault Tolerance: Can survive multiple drive failures if not in the same mirror.
+ Fast Rebuild: Quick recovery compared to parity-based RAIDs.
+ Cost-Effective: Better balance of performance and redundancy than pure mirroring.
```

Configuration is three times faster than RAID 1, with tripled read/write rates.

## Disadvantages of RAID 10
```diff
- High Storage Overhead: Only 50% of total capacity is usable (half for mirroring).
- Expensive: Requires minimum 4 disks, expensive due to redundancy.
- No Parity Support: Lacks advanced fault tolerance features of RAID 5/6.
```

It consumes more space and is costlier than parity RAIDs like RAID 5.

## Creating RAID 10 in Linux
Requirements: Minimum 4 disks. In this demo, 4 x 4GB disks (sdb, sdc, sdd, sde) are used.

### Step-by-Step Creation
1. **Partition Disks**:
   - Create primary partitions on each disk (e.g., 4GB each).
   ```
   fdisk /dev/sdb
   n (new partition)
   p (primary)
   1 (partition number)
   (full size)
   t (change type to Linux RAID autodetect, code fd)
   w (write changes)
   ```
   Repeat for sdc, sdd, sde.

2. **Install mdadm** (if not installed):
   ```
   sudo apt install mdadm  # or yum install mdadm
   ```

3. **Create RAID 10**:
   ```
   mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
   ```
   - `--level=10`: RAID 10 level.
   - `--raid-devices=4`: Number of devices.

4. **Monitor Creation**:
   ```
   cat /proc/mdstat
   ```
   Watch for synchronization (may take time for large arrays).

5. **Check RAID Details**:
   ```
   mdadm --detail /dev/md0
   mdadm --detail /dev/md125  # Use array name if different
   ```
   Output shows level (raid10), state, active devices, and set information.

## Managing RAID Devices
- **Check Active Devices**:
  ```
  mdadm --query /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
  ```
- **Create and Format Filesystem**:
  ```
  mkfs.ext4 /dev/md0
  mkdir /mnt/raid10
  mount /dev/md0 /mnt/raid10
  ```
- **Simulate Data**:
  Create files in `/mnt/raid10` to test.

## RAID Failure and Recovery
1. **Simulate Failure**:
   ```
   mdadm --fail /dev/md0 /dev/sdb1  # Mark disk as failed
   ```
   Check status: State becomes "degraded", failed devices = 1.

2. **Remove Failed Disk**:
   ```
   fdisk /dev/sdf  # Prepare replacement disk
   mdadm --remove /dev/md0 /dev/sdb1
   ```

3. **Add Replacement Disk**:
   ```
   mdadm --add /dev/md0 /dev/sdf1
   ```
   RAID rebuilds automatically (syncing).

4. **Verify Recovery**:
   ```
   mdadm --detail /dev/md0  # Check state: rebuilding/clean
   ```

> [!NOTE]
> RAID 10 survives disk failure if the failed disk's mirror partner is intact. Data integrity is maintained.

## Configuring LVM on RAID 10
1. **Create Physical Volume**:
   ```
   pvcreate /dev/md0
   pvs  # Verify
   ```

2. **Create Volume Group**:
   ```
   vgcreate vg_raid10 /dev/md0
   vgs  # Check VG
   ```

3. **Create Logical Volumes**:
   ```
   lvcreate -L 2G -n lv1 vg_raid10
   lvcreate -L 2G -n lv2 vg_raid10
   lvs  # Verify LVs
   ```

4. **Format and Mount**:
   ```
   mkfs.ext4 /dev/vg_raid10/lv1
   mount /dev/vg_raid10/lv1 /mnt/lv1
   ```

## Building Nested RAID on Logical Volumes
1. **Create Another RAID on LVs** (e.g., RAID 1):
   ```
   mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/vg_raid10/lv1 /dev/vg_raid10/lv2
   ```

2. **Format and Mount**:
   ```
   mkfs.ext4 /dev/md1
   mount /dev/md1 /mnt/nested_raid
   ```

This demonstrates advanced nesting: RAID 10 → LVM → RAID 1.

## Summary

**Key Takeaways:**
```diff
+ RAID 10 combines striping and mirroring for high performance and redundancy.
+ Minimum 4 disks; 50% capacity overhead.
+ Supports up to 2 drive failures if not in same mirror set.
+ Ideal for applications needing speed and reliability (e.g., databases).
- Expensive and complex; not efficient for large storage needs.
! Always test failure scenarios in labs before production use.
```

**Quick Reference:**
- Create: `mdadm --create /dev/md0 --level=10 --raid-devices=4 /dev/sdX1 ...`
- Check: `cat /proc/mdstat` or `mdadm --detail /dev/md0`
- Add: `mdadm --add /dev/md0 /dev/newdisk1`
- Remove: `mdadm --remove /dev/md0 /dev/faileddisk1`
- Fail device: `mdadm --fail /dev/md0 /dev/sdX1`
- LVM on RAID: `pvcreate /dev/md0; vgcreate vg_name /dev/md0; lvcreate -L size -n lv_name vg_name`

**Expert Insight:**
> **Real-world Application**: Use RAID 10 for transactional databases or virtual machine storage where IOPS are critical. It's common in enterprise servers for balancing cost, performance, and data protection.
> **Expert Path**: Master `mdadm` commands and integrate with LVM for dynamic storage management. Monitor SMART health of disks to predict failures.
> **Common Pitfalls**: Avoid replacing multiple disks simultaneously; ensure identical sizes for even distribution. Backup data before testing failures - simulations are risky on production.
</details>
