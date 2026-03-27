# Section 48: RAID 6

<details open>
<summary><b>Section 48: RAID 6 (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to RAID 6](#introduction-to-raid-6)
- [Comparison with RAID 5](#comparison-with-raid-5)
- [How RAID 6 Works](#how-raid-6-works)
- [Configuring RAID 6](#configuring-raid-6)
- [Formatting and Mounting RAID 6](#formatting-and-mounting-raid-6)
- [Practical Demo: RAID 6 Setup](#practical-demo-raid-6-setup)
- [Simulating Disk Failure](#simulating-disk-failure)
- [Removing and Replacing Disks](#removing-and-replacing-disks)
- [Downloading CentOS 8 ISO](#downloading-centos-8-iso)
- [Exam Preparation Tips](#exam-preparation-tips)

## Introduction to RAID 6
RAID 6 is a storage technology that provides high data redundancy and protection by using stripes with dual parity. Unlike RAID 5, which uses single parity, RAID 6 employs two parity blocks per stripe set, allowing it to withstand the failure of up to two disks without data loss. It uses a minimum of 4 disks (2 for data, 1 for parity, 1 for parity copy) and can scale up to 32 disks. RAID 6 balances performance and data security, recommended for applications requiring excellent fault tolerance.

## Comparison with RAID 5
RAID 5 uses striping with single parity, offering good read performance but slower write transactions. RAID 6 improves upon this with dual parity, providing better data protection as it can survive multiple disk failures (up to two). However, RAID 6 write performance is about 20% slower than RAID 5 due to additional parity calculations. Use RAID 6 for critical data storage where performance and security are both priorities, rather than just performance (RAID 5) or extreme security (RAID 10).

| Feature               | RAID 5                    | RAID 6                    |
|-----------------------|---------------------------|---------------------------|
| Minimum Disks         | 3                         | 4                         |
| Parity                | Single                    | Dual                      |
| Tolerance             | 1 disk failure            | 2 disk failures           |
| Read Performance      | Fast                      | Very Fast                 |
| Write Performance     | Moderate                  | Slower (20%)              |
| Use Cases             | General storage, balance  | Critical data, security   |

## How RAID 6 Works
RAID 6 distributes data across multiple disks using striping with dual parity. Data is split into stripes across disks, and parity is calculated for each stripe set. One parity block is stored in one disk, and a copy of the parity is stored in another. This ensures if any disk fails, data can be reconstructed. Even if two disks fail, data remains intact thanks to the dual parity mechanism.

For example, with 4 disks of 1TB each (total capacity 4TB), effective usable space is 2TB (2 for data, 1 for parity, 1 for parity copy). Data from files like "Mehra" is striped across disks, with parity bits calculated and stored randomly.

```bash
# Conceptual strip visualization
Data Stripe 1: [Disk1] [Disk2] [Disk3] [Disk4]
Parity 1:     [Calc]  [Store][Copy]  [Rand]
Parity 2:     [Rand]  [Calc]  [Store][Copy]
```

## Configuring RAID 6
To configure RAID 6, you need at least 4 disks. Use `mdadm` for creation:

```bash
mdadm --create /dev/md6 --level=6 --raid-devices=4 /dev/sdf /dev/sdg /dev/sdh /dev/sdi
```

Specify the level as 6, and list the devices. The first character is 'md' for multi-disk, followed by a number.

## Formatting and Mounting RAID 6
After creation, format the RAID array:

```bash
mkfs.ext4 /dev/md6
```

Mount it to a directory:

```bash
mount /dev/md6 /raid6
```

Add to `/etc/fstab` for persistence:

```bash
/dev/md6 /raid6 ext4 defaults 0 0
```

## Practical Demo: RAID 6 Setup
In the demo, 6 disks (/dev/sdf to /dev/sdi) are used, configuring RAID 6 with the first 4. Create a directory `/raid6`, save files, and verify integrity.

Commands used:
- Create RAID: `mdadm --create /dev/md6 --level=6 --raid-devices=4 /dev/sdf /dev/sdg /dev/sdh /dev/sdi`
- Check status: `mdadm --detail /dev/md6`
- Format and mount after creation.

## Simulating Disk Failure
Simulate failure by marking disks as faulty. Even after failing one disk, data remains intact (can withstand up to 2 failures).

```bash
mdadm /dev/md6 --fail /dev/sdf  # Mark disk as failed
```

After failure, RAID rebuilds automatically. Verify with `mdadm --detail /dev/md6` showing 'degraded' but data safe.

## Removing and Replacing Disks
Remove failed disks, then add new ones for rebuilding.

```bash
mdadm /dev/md6 --remove /dev/sdf /dev/sdg  # Remove after failure
mdadm /dev/md6 --add /dev/sdj /dev/sdk     # Add new disks
```

RAID recovers automatically in 'recovering' state. Once complete, all disks are active.

## Downloading CentOS 8 ISO
To practice, download CentOS 8 ISO from centos.org or mirror sites.

```bash
# Using wget to download ISO
wget https://vault.centos.org/8.5.2111/isos/x86_64/CentOS-8.5.2111-x86_64-dvd1.iso
```

Sizes are ~10GB; use broadband for download.

## Exam Preparation Tips
For RHCSA exam, practice hands-on as objectives include configuring storage and RAID levels. Practice mdadm commands thoroughly.

## Summary
### Key Takeaways
```diff
+ RAID 6 provides superior data protection with dual parity, tolerating up to 2 disk failures compared to RAID 5's 1.
+ Minimum 4 disks required; scales to 32.
+ Read performance is fast, writes are ~20% slower due to parity calculations.
+ Better for critical applications needing both performance and security.
! Avoid using RAID 6 as a substitute for backups.
```

### Quick Reference
- Create RAID 6: `mdadm --create /dev/md6 --level=6 --raid-devices=4 /dev/sdX /dev/sdY /dev/sdZ /dev/sdW`
- Check status: `mdadm --detail /dev/md6`
- Fail disk: `mdadm /dev/md6 --fail /dev/sdX`
- Remove disk: `mdadm /dev/md6 --remove /dev/sdX`
- Add disk: `mdadm /dev/md6 --add /dev/sdNew`

### Expert Insight
**Real-world Application**: RAID 6 is ideal for enterprise storage arrays, backup servers, and cloud storage where data integrity is paramount but performance can't be heavily compromised.

**Expert Path**: Master mdadm by practicing disk failure simulations and recoveries in a virtual environment. Understand parity calculations for deeper troubleshooting.

**Common Pitfalls**: Not configuring enough disks (minimum 4), forgetting to handle RAID reconstruction, or assuming it's a full backup replacement. Always test RAID after setup and monitor with `mdadm --monitor`.

</details>
