# Section 51: XFS Quota Management in Linux

<details open>
<summary><b>Section 51: XFS Quota Management in Linux (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to Disk Quota Management](#introduction-to-disk-quota-management)
- [Enabling Quotas on XFS Filesystem](#enabling-quotas-on-xfs-filesystem)
- [Setting Up Directories for Quota Management](#setting-up-directories-for-quota-management)
- [User Group and Project Quota Limits](#user-group-and-project-quota-limits)
- [Monitoring and Reporting Quotas](#monitoring-and-reporting-quotas)
- [Changing Grace Periods](#changing-grace-periods)
- [Disabling Quotas](#disabling-quotas)
- [Summary](#summary)

## Introduction to Disk Quota Management

### Overview
Disk quota management in Linux, specifically using XFS filesystem, allows administrators to control disk space utilization effectively. This prevents any single user or group from consuming excessive storage, ensuring fair resource allocation across systems. The demonstration uses a practical setup with an XFS-formatted additional disk partition to illustrate quota implementation and management.

### Key Concepts/Deep Dive
XFS supports quotas at three levels: user, group, and project. These help monitor and limit storage usage:
- **Soft Limits**: Allow temporary exceedance with a grace period before enforcement.
- **Hard Limits**: Strictly enforced limits that cannot be surpassed.
- **Grace Period**: Default 7 days, during which soft limits can be exceeded before restrictions apply.

Quotas are essential for multi-user environments to prevent storage overuse by non-essential data holders.

```diff
- Problem: Users storing unnecessary data waste storage
+ Solution: Implement quotas to enforce efficient resource use
```

! Resource wastage occurs when users hoard non-essential files, leading to storage shortages despite useful data needing space.

### Lab Demo: Preparing Disk Partition
1. Create a primary partition on the additional disk (e.g., 10GB).
2. Format the partition with XFS: `mkfs.xfs /dev/sdb1`.
3. Mount the partition temporarily to a directory for initialization.

```bash
# Example partition creation (using fdisk)
fdisk /dev/sdb
# Create primary partition, then:
mkfs.xfs /dev/sdb1
mount /dev/sdb1 /mnt/quota_test
```

## Enabling Quotas on XFS Filesystem

### Overview
To use quotas on XFS, the filesystem must be remounted with quota options. This involves adding entries to `/etc/fstab` and using `mount` commands with specific flags. The process enables user, group, and project quota enforcement on the mounted filesystem.

### Key Concepts/Deep Dive
XFS quota options include:
- `usrquota`: Enables user-level quotas.
- `grpquota`: Enables group-level quotas.
- `prjquota`: Enables project-level quotas.

These can be set permanently in `/etc/fstab` or temporarily via mount commands.

> [!IMPORTANT]
> Ensure the filesystem is unmounted before formatting, and always backup data if reformatting.

### Lab Demo: Enabling XFS Quotas
1. Mount the XFS partition with quota options temporarily: `mount -o usrquota,grpquota,prjquota /dev/sdb1 /path/to/mount`.
2. Update `/etc/fstab` for permanent mounting: add line like `/dev/sdb1 /mnt/xfs_quota xfs usrquota,grpquota,prjquota 0 0`.
3. Verify with `mount` command.

```bash
# Permanent fstab entry example
echo "/dev/sdb1 /mnt/xfs_quota xfs usrquota,grpquota,prjquota 0 0" >> /etc/fstab
mount /mnt/xfs_quota
```

Use `xfs_quota` command to set and manage limits after mounting.

## Setting Up Directories for Quota Management

### Overview
After mounting the XFS filesystem, create directories for quota enforcement. This involves adding user, group, and project configurations to `/etc/projects` and `/etc/projid` for project quotas. Permissions must be adjusted to allow user access while maintaining security.

### Key Concepts/Deep Dive
- Directories serve as mount points for quota-controlled storage.
- Project quotas require entries in `/etc/projects` and `/etc/projid`.
- Permission sets (e.g., `777`) enable broad access for demonstration, but in production, use appropriate restrictions.

```diff
+ Setup: Create dedicated directories with proper permissions
- Avoid: Leaving restrictive permissions that block quota testing
```

### Lab Demo: Creating Quota Directories
1. Create directories: `mkdir /mnt/xfs_quota/quota_dir`.
2. Set permissions: `chmod 777 /mnt/xfs_quota/quota_dir`.
3. Add project entries for project quotas.

```bash
mkdir /mnt/xfs_quota/quota_test
chmod 777 /mnt/xfs_quota/quota_test

# For project quota, edit /etc/projects
echo "test_quota:101" >> /etc/projects

# Edit /etc/projid
echo "test_quota:101" >> /etc/projid
```

Project quotas are initialized using `xfs_quota` initialization.

## User Group and Project Quota Limits

### Overview
Using `xfs_quota` in expert mode (`-x`), limits are set for users, groups, and projects. This includes defining soft and hard limits for blocks (storage) and inodes (file count). Practical demos show creating users/groups and testing quota enforcement.

### Key Concepts/Deep Dive
Limits can be set per filesystem type:
- **Blocks**: Byte-level storage limits (e.g., 1GB soft, 2GB hard).
- **Inodes**: File count limits (e.g., 1000 soft, 1500 hard).

Commands use `limit` with form: `limit -u| -g| -p [soft] [hard] user/group/project`.

```diff
+ Effective: Use expert mode for precise control
- Ineffective: Casual mode lacks detailed options
```

### Tables: Quota Limit Types

| Type       | Block Limits     | Inode Limits    | Enforcement |
|------------|------------------|-----------------|-------------|
| User      | Per user storage | Per user files  | Individuals |
| Group     | Per group shared | Per group files | Team allocation |
| Project   | Project-level    | Project files   | Project scopes |

### Lab Demo: Setting and Testing Limits
1. Add test user/group: `useradd testuser`, `groupadd testgrp`.
2. Set user limits: `xfs_quota -x -c 'limit -u bsoft=1g bhard=2g testuser' /mnt/xfs_quota`.
3. Test overloading limits and observing grace periods.

```bash
# Set user quota limits
xfs_quota -x -c 'limit -u bsoft=100m bhard=200m testuser' /mnt/xfs_quota

# Create test files exceeding limits
dd if=/dev/zero of=/mnt/xfs_quota/test bs=1M count=150  # Exceeds soft limit, starts grace timer
```

Files exceeding limits fail creation; grace period applies to soft overrides.

## Monitoring and Reporting Quotas

### Overview
Monitor quota usage with `xfs_quota` report commands. Options like `-b` for blocks, `-i` for inodes provide detailed status, including usage percentages and grace timers. This helps administrators track compliance and identify abusers.

### Key Concepts/Deep Dive
Reporting modes:
- `-h`: Human-readable output.
- `-b/-i`: Block or inode focus.
- Combined for comprehensive views (e.g., blocks and inodes).

Displays current usage against limits and any active grace periods.

```diff
+ Monitor: Regularly check reports for resource management
- Ignore: Reports lead to uncontrolled storage growth
```

### Lab Demo: Generating Reports
1. Get full quota status: `xfs_quota -x -c 'report -h' /mnt/xfs_quota`.
2. Block-specific: `xfs_quota -x -c 'report -bh' /mnt/xfs_quota`.

```bash
# Detailed quota report
xfs_quota -x -c 'report -bi -h' /mnt/xfs_quota
```

Output shows usage, limits, and remaining grace time for user/group/project.

## Changing Grace Periods

### Overview
Modify grace periods for blocks and inodes using `xfs_quota` timer commands. Change units include days, minutes for both user/group/project levels. This overrides defaults (7 days) for tailored enforcement.

### Key Concepts/Deep Dive
Timer formats: `blockgrace=Nd` or `inodegrace=Nm` (days/minutes).
- `-u`: User level, `-g`: Group, `-p`: Project.

Adjust based on organizational needs.

> [!NOTE]
> Excessive grace periods may defeat quota intentions.

### Lab Demo: Adjusting Grace Periods
1. Change block grace to 10 days: `xfs_quota -x -c 'timer -u blockgrace=10d' /mnt/xfs_quota`.
2. Verify with status reports.

```bash
# Set group inode grace to 30 minutes
xfs_quota -x -c 'timer -g inodegrace=30m' /mnt/xfs_quota
```

## Disabling Quotas

### Overview
Quotas can be disabled temporarily (enforcement off) or permanently (remove options). Temporary disable allows over-quota usage; permanent requires unmounting and fstab edits. Use `xfs_quota` disable commands or mount adjustments.

### Key Concepts/Deep Dive
Modes:
- **Temporary**: `xfs_quota -x -c 'disable -up'` – stops enforcement.
- **Permanent**: Remove quota options from `/etc/fstab`, unmount/remount.

Ensure filesystem integrity during changes.

```diff
+ Temporary: Useful for testing without limits
- Permanent: Removes quota tracking entirely
```

### Lab Demo: Disabling Quotas
1. Temporary disable: `xfs_quota -x -c 'disable -u -g -p' /mnt/xfs_quota`.
2. Permanent: Edit `/etc/fstab` (remove quota options), `umount`, `mount`.

```bash
# Temporary disable all quotas
xfs_quota -x -c 'disable -ugp' /mnt/xfs_quota

# For permanent (after unmount and fstab edit)
umount /mnt/xfs_quota
mount /mnt/xfs_quota  # Without quota options
```

## Summary

### Key Takeaways
```diff
+ Quotas prevent storage overuse by enforcing user/group/project limits
+ XFS supports soft/hard limits with grace periods for fairness
+ Use xfs_quota expert mode for comprehensive management
- Disabling quotas without removal allows uncontrolled growth
```

### Quick Reference
- Enable quotas: `mount -o usrquota,grpquota,prjquota /dev/partition /mount/point`
- Set user limit: `xfs_quota -x -c 'limit -u bsoft=1g bhard=2g username' /mount/point`
- Report usage: `xfs_quota -x -c 'report -bh -i' /mount/point`
- Change grace: `xfs_quota -x -c 'timer -u blockgrace=10d' /mount/point`
- Temporary disable: `xfs_quota -x -c 'disable -u -g -p' /mount/point`

### Expert Insight
**Real-world Application**: In enterprise environments, implement quotas on shared NFS/XFS storage to ensure teams don't monopolize resources, maintaining system performance. Useful for cloud storage tiers or multi-tenant hosting.

**Expert Path**: Start with user quotas, then master project quotas for complex hierarchies. Learn advanced XFS tuning post-quota implementation. Pursue RHCSA/RHCE certifications focusing on storage management.

**Common Pitfalls**: Forgetting to initialize projects after `/etc/projects` edits, or exceeding hard limits without monitoring grace periods. Ensure filesystem consistency before quota changes; test in staging environments first.

</details>
