# Section 46: RAID Level 1 (Mirroring)

<details open>
<summary><b>Section 46: RAID Level 1 (Mirroring) (CL-KK-Terminal)</b></summary>

## Table of Contents

1. [Overview of RAID 1](#overview-of-raid-1)
2. [Advantages of RAID 1](#advantages-of-raid-1)
3. [Disadvantages of RAID 1](#disadvantages-of-raid-1)
4. [RAID 1 Conceptual Explanation](#raid-1-conceptual-explanation)
5. [Practical Configuration of RAID 1](#practical-configuration-of-raid-1)
6. [Testing Data Integrity in RAID 1](#testing-data-integrity-in-raid-1)
7. [Simulating Disk Failure](#simulating-disk-failure)
8. [Replacing Failed Disk](#replacing-failed-disk)
9. [Summary](#summary)

## Overview of RAID 1

RAID Level 1, also known as mirroring, is a data protection technique that duplicates data across multiple physical disks. In RAID 1 configuration, data is written simultaneously to two or more disks, ensuring that if one disk fails, the data remains intact on the surviving disk(s). This technology uses mirroring instead of striping, where identical copies of data are maintained on separate disks.

RAID 1 requires a minimum of two disks and can use more disks depending on your redundancy requirements. The mirroring concept ensures that every block of data on the first disk is exactly replicated on the second disk.

## Advantages of RAID 1

RAID 1 offers several key benefits:

- **Excellent Performance**: Read operations are faster than single disk configurations (though not as fast as non-RAID setups)
- **High Redundancy**: Data remains intact even if one disk fails
- **Data Integrity**: Mirrors ensure no data loss
- **Simple Implementation**: Easy to configure and manage
- **Wide Compatibility**: Works with most file systems

When comparing performance, RAID 1 provides read speeds equivalent to a single disk but offers superior reliability. The read speed is dependent entirely on the speed of the individual disks used in the array.

## Disadvantages of RAID 1

Despite its benefits, RAID 1 has some limitations:

- **Storage Cost**: Capacity is halved - if you use two 1TB disks, you only get 1TB of usable storage
- **No Performance Gain for Writes**: Write operations are equivalent to single disk performance
- **Limited Scalability**: Cannot add more disks dynamically like other RAID levels
- **Not Suitable for Hot Swapping**: In physical RAID setups, the machine must be powered off to replace failed disks

RAID 1 is ideal for mission-critical data where data availability is paramount, such as financial records, medical data, or small server configurations.

## RAID 1 Conceptual Explanation

### Data Mirroring

In RAID 1, data is duplicated across disks at the block level. Consider this scenario:

- **Disk 1** contains blocks: [A][B][C][D]
- **Disk 2** automatically mirrors: [A][B][C][D]

When writing data (e.g., the word "Spring"), the system stores the exact same data on both disks simultaneously. This ensures that even if one disk fails completely, the data remains accessible.

### Failure Scenario

If Disk 1 fails during operation, Disk 2 continues to serve all data requests without interruption. The system can operate in a "degraded" state until the failed disk is replaced.

### Use Cases

RAID 1 is particularly well-suited for:
- Mission-critical data storage
- Financial and accounting systems
- Medical records and databases
- Small to medium-sized file servers
- Any application where data integrity is more important than storage capacity

## Practical Configuration of RAID 1

### Prerequisites

Before configuring RAID 1, ensure you have:
- Multiple physical disks of identical size and type (recommended)
- Root or sudo access
- `mdadm` package installed
- Familiarity with Linux file system operations

### Step 1: Prepare Disks

First, create partitions on the disks to be used:

```bash
fdisk /dev/sdb
# Press n for new partition
# Press p for primary partition
# Press 1 for partition number 1
# Accept default first and last sectors (full disk)
# Press w to write changes

fdisk /dev/sdc
# Repeat the same process for the second disk
```

### Step 2: Create RAID 1 Array

```bash
mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
```

**Command explanation:**
- `--create`: Creates a new RAID array
- `--verbose`: Provides detailed output
- `/dev/md0`: Name of the RAID array (you can choose any name)
- `--level=1`: Specifies RAID level 1 (mirroring)
- `--raid-devices=2`: Number of disks to include
- `/dev/sdb1 /dev/sdc1`: The partition devices to use

### Step 3: Verify RAID Creation

Check the RAID status:

```bash
cat /proc/mdstat
```

You should see output indicating the RAID is being built (resyncing). This process may take time depending on disk size.

### Step 4: Format and Mount

```bash
mkfs.ext4 /dev/md0
mkdir /mnt/raid1
mount /dev/md0 /mnt/raid1
```

### Step 5: Verify Array Details

```bash
mdadm --detail /dev/md0
```

This command shows comprehensive information about the RAID array including device status, array level, and component devices.

## Testing Data Integrity in RAID 1

After mounting the RAID array, create test files to verify data replication:

```bash
cd /mnt/raid1
echo "Spring Season" > file1.txt
mkdir test_directory
echo "Class IX Notes" > test_directory/notes.txt
```

List the contents to confirm files are created:

```bash
ls -la
ls -la test_directory/
```

You should see all created files and directories.

## Simulating Disk Failure

**Important Safety Note**: This is for educational purposes only. In a production environment, exercise extreme caution when simulating disk failures.

### Step 1: Mark Disk as Failed

```bash
mdadm /dev/md0 --fail /dev/sdb1
```

### Step 2: Verify Failure Status

Check the RAID status:

```bash
cat /proc/mdstat
mdadm --detail /dev/md0
```

You should see:
- One device marked as failed
- RAID state as degraded but active
- Resync operation showing progress

### Step 3: Remove Failed Disk

```bash
mdadm /dev/md0 --remove /dev/sdb1
```

⚠ **Note**: This simulates hot removal. In physical hardware, you would need to power off the system to physically remove the disk.

## Replacing Failed Disk

### Step 1: Prepare Replacement Disk

Create a partition on the replacement disk:

```bash
fdisk /dev/sdd
# Create primary partition 1, use full disk, write changes
```

### Step 2: Add Replacement Disk to RAID

```bash
mdadm /dev/md0 --add /dev/sdd1
```

### Step 3: Monitor Rebuilding

Check resync progress:

```bash
cat /proc/mdstat
watch -n 10 cat /proc/mdstat  # Monitor every 10 seconds
```

The RAID will automatically start rebuilding (resyncing) data from the surviving disk to the new one.

### Step 4: Verify Array Health

Once rebuilding is complete (100% resync), verify:

```bash
mdadm --detail /dev/md0
ls -la /mnt/raid1  # Check that all data is intact
cat /mnt/raid1/file1.txt  # Verify file contents
```

All data should be accessible and intact.

## Summary

### Key Takeaways
```diff
+ RAID 1 provides data redundancy through mirroring, ensuring data availability even when one disk fails
+ Minimum of 2 disks required, with the total usable capacity equal to the size of one disk
+ Excellent for critical data protection where integrity is paramount
+ Automatic failover and rebuild capabilities with mdadm
+ Performance is comparable to single disk for writes, but offers better read potential
- Storage efficiency is poor (50% overhead for redundancy)
- Not suitable for hot-swapping without proper system preparation
- No performance improvement compared to advanced RAID levels
```

### Quick Reference
```diff
! Create RAID 1: mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
! Check status: cat /proc/mdstat
! Fail disk: mdadm /dev/md0 --fail /dev/sdb1
! Remove failed disk: mdadm /dev/md0 --remove /dev/sdb1
! Add replacement: mdadm /dev/md0 --add /dev/sdd1
! Detailed info: mdadm --detail /dev/md0
```

### Expert Insight

#### Real-world Application
RAID 1 is commonly deployed in database servers, web servers hosting critical applications, and file servers where uptime is crucial. Many small to medium businesses use RAID 1 for their primary data storage because it provides a simple, reliable protection mechanism without complex management requirements. In enterprise environments, RAID 1 is often used for operating system partitions and critical application data.

#### Expert Path
To master RAID 1 implementation:
1. Practice mdadm commands thoroughly in test environments before production deployment
2. Understand your hardware's RAID capabilities (software vs hardware RAID)
3. Implement regular monitoring using tools like Nagios or built-in system monitoring
4. Learn about RAID 10 (striped mirrors) for improved performance in multi-disk scenarios
5. Study enterprise storage solutions that build upon RAID 1 concepts

#### Common Pitfalls
- **Size Mismatches**: Using disks of different sizes can reduce effective capacity to the smallest disk
- **Monitoring Neglect**: Failing to monitor RAID health can lead to undetected failures
- **Improper Removal**: Attempting to remove working disks without proper failure indication
- **filesystem Choices**: Ensure your chosen filesystem fully supports RAID operations
- **Backup Confusion**: RAID 1 is not a substitute for proper backup strategies

</details>
