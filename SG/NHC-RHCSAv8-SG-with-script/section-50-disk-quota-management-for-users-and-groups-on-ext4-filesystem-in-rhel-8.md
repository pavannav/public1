# Section 50: Disk Quota Management

<details open>
<summary><b>Section 50: Disk Quota Management (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to Disk Quota](#introduction-to-disk-quota)
- [Why Disk Quota is Needed](#why-disk-quota-is-needed)
- [Quota Limits: Soft, Hard, and Grace Period](#quota-limits-soft-hard-and-grace-period)
- [Installing and Enabling Quota Package](#installing-and-enabling-quota-package)
- [Creating User and Group Accounts](#creating-user-and-group-accounts)
- [Preparing Filesystem Partition](#preparing-filesystem-partition)
- [Mounting Filesystem with Quota](#mounting-filesystem-with-quota)
- [Creating Quota Database Files](#creating-quota-database-files)
- [Enabling Quota](#enabling-quota)
- [Setting User Quota Limits](#setting-user-quota-limits)
- [Setting Group Quota Limits](#setting-group-quota-limits)
- [Practical Demonstration of Quota Enforcement](#practical-demonstration-of-quota-enforcement)
- [Checking Quota Usage and Grace Period](#checking-quota-usage-and-grace-period)
- [Removing Quota Files](#removing-quota-files)
- [Editing Global Grace Period](#editing-global-grace-period)
- [Summary](#summary)

## Introduction to Disk Quota
Disk quota is a utility in Linux that allows administrators to limit disk space usage for individual users or groups on a filesystem. This prevents resource abuse and ensures fair allocation of storage.

**Key Benefits:**
- Prevents users from over-consuming shared disk space
- Provides granular control (block-level or inode-level limits)
- Supports both user and group quotas
- Imposes restrictions at the filesystem level, not system-wide

## Why Disk Quota is Needed
In shared systems with multiple users, some may misuse storage by downloading excessive files or data, leading to space scarcity for others who need it legitimately. Quota management ensures controlled usage, similar to data limits imposed by internet service providers.

**Real-World Analogy:** Just like ISPs enforce data quotas (e.g., 10GB soft limit with warnings, 15GB hard limit with denial), disk quotas allocate storage limits to prevent unequal resource distribution.

## Quota Limits: Soft, Hard, and Grace Period
Quota enforcement operates on two main limit types:

- **Soft Limit:** The threshold where users receive warnings about exceeding quota. Users can still create/manage files up to the hard limit in a grace period.
- **Hard Limit:** The absolute maximum; users/groups cannot exceed this limit and receive an error (e.g., "Disk quota exceeded").

Additional concept: **Grace Period** - Time window (days/hours/minutes) allowing users to exceed soft limits before enforcement. Determines how long users can create files or use extra space after crossing soft limits.

Example: Soft limit: 10GB, Hard limit: 15GB. After 10GB, warnings appear; within grace period (e.g., 2 days), users can reach 15GB. After grace period/grace period expiry, all access is blocked.

```diff
+ Soft Limit: Flexible threshold with warnings (e.g., 100MB)
- Hard Limit: Absolute cap (e.g., 200MB); users blocked beyond this
! Grace Period: Breather time (e.g., 365 days) to rectify usage before total lockdown
```

## Installing and Enabling Quota Package
Ensure the quota package is installed for managing quotas. On RHEL 8 systems:

```bash
dnf install quota
# Or use alternative package manager if needed
```

Verify installation:
```bash
rpm -qa | grep quota
quota-4.05-10.el8.x86_64  # Example output
```

If not installed, enable repositories and install via yum/dnf.

## Creating User and Group Accounts
Create test users and groups for quota demonstration:

```bash
# Create users
useradd user1
useradd user2
useradd user3
useradd user4

# Set passwords
passwd user1
passwd user2
passwd user3
passwd user4

# Create group
groupadd quota_group

# Add users to group
usermod -G quota_group user1
usermod -G quota_group user2
```

Verify:
```bash
id user1
groups user1
```

## Preparing Filesystem Partition
Prepare a dedicated partition (e.g., 10GB) for quota management. Use parted/fdisk for partitioning and format as ext4:

```bash
# Check available disks
lsblk

# Partition (example: /dev/sdb to 10GB)
parted /dev/sdb mklabel gpt
parted /dev/sdb mkpart primary ext4 1MiB 100%
mkfs.ext4 /dev/sdb1

# Check block device
blkid /dev/sdb1  # Note UUID and filesystem type (ext4)
```

## Mounting Filesystem with Quota
To implement quotas, mount the filesystem with quota options. Add to `/etc/fstab` for persistence:

```bash
# Backup fstab
cp /etc/fstab /etc/fstab.bak

# Add entry to fstab (replace UUID with actual)
echo "UUID=xxxxx-xxxx-xxxxx /quota_dir ext4 defaults,uquota,gquota 0 2" >> /etc/fstab

# Create mount point
mkdir /quota_dir

# Mount
mount -o remount /quota_dir
# Or mount all from fstab
mount -a
```

Verify mount with quota options:
```bash
mount | grep quota_dir
/dev/sdb1 on /quota_dir type ext4 (rw,relatime,seclabel,quota,usrquota,grpquota,data=ordered)
```

## Creating Quota Database Files
Quota requires database files to track usage:

```bash
# Create user quota file
quotacheck -cu /quota_dir

# Create group quota file
quotacheck -cg /quota_dir
```

Verify files created:
```bash
ls -la /quota_dir
# Output: aquota.user and aquota.group files
```

## Enabling Quota
Enable quota enforcement on the mounted filesystem:

```bash
# Enable user and group quotas
quotaon -u /quota_dir
quotaon -g /quota_dir

# Verify status
quotaon -a | grep quota_dir
# Output: /dev/sdb1 [/quota_dir] usrquota,grpquota
```

Set directory permissions for access:
```bash
chmod 775 /quota_dir
chown root:quota_group /quota_dir
```

## Setting User Quota Limits
Set limits for individual users using `edquota`:

```bash
# Edit user quota (e.g., user1)
edquota user1
```

In editor, set limits (values in KB; note 1KB = 1024 bytes, but quotas often use 1K blocks):

```bash
Disk quotas for user user1 (uid 1001):
  Filesystem                   blocks       soft       hard     inodes     soft     hard
  /dev/sdb1                          0         100       200          0         10       15
```

- **blocks soft/hard**: Disk space limits (e.g., soft 100KB, hard 200KB)
- **inodes soft/hard**: File count limits (e.g., soft 10 files, hard 15 files)

Save and apply. Set grace period if needed:
```bash
# Set grace period (e.g., 5 minutes for blocks, 7 days for inodes)
edquota -t
```

## Setting Group Quota Limits
For groups, use similar approach:

```bash
# Edit group quota
edquota -g quota_group
```

Set group limits (e.g., soft 400KB, hard 500KB blocks; soft 100, hard 150 inodes).

Apply globally to group members.

## Practical Demonstration of Quota Enforcement
Switch to a user account (e.g., user1) and test limits:

```bash
# Switch to user
su - user1

# Create test files (within limits)
dd if=/dev/zero of=test1 bs=1M count=10  # Creates 10MB file

# Create multiple files (up to inode limit)
touch file{1..10}

# Attempt beyond soft limit → Warnings appear
dd if=/dev/zero of=test2 bs=1M count=11  # Exceeds soft limit

# Attempt beyond hard limit → Denied
dd if=/dev/zero of=test3 bs=1M count=21  # Exceeds hard limit
# Error: Disk quota exceeded
```

For groups, test with group member accounts. Switch between users and monitor.

Cleanup test files:
```bash
rm -f test*
rm -f file*
```

## Checking Quota Usage and Grace Period
Monitor quota status and usage:

```bash
# Check user quota
quota -u user1

# Check group quota
quota -g quota_group

# Detailed report
repquota /quota_dir
```

During violations, grace period counts down. Check:
Global grace period: `edquota -t`
User specific: Appears in `quota` output (blocks grace: 5days, inodes grace: 2hours)

```diff
+ Grace Period Active: User can still create files temporarily post-soft limit
- Grace Period Expired: Access blocked until usage reduced
```

## Removing Quota Files
To disable quotas:

```bash
# Turn off quotas
quotaoff -u /quota_dir
quotaoff -g /quota_dir

# Remove quota database files
rm /quota_dir/aquota.user /quota_dir/aquota.group
```

Update `/etc/fstab` to remove quota options and remount.

## Editing Global Grace Period
Edit system-wide grace periods without quotaoff:

```bash
# Edit grace time (must be done while quota is active)
edquota -t
```

Set values (e.g., blocks grace: 3days; inodes grace: 24hours). This affects all users/groups on the filesystem.

## Summary

### Key Takeaways
```diff
+ Disk quota prevents storage abuse on shared systems
+ Soft limits allow temporary excess with warnings
- Hard limits absolutely enforce maximum usage
! Grace period provides breathing room post-soft limit violations
+ Both block (size) and inode (file count) quotas supported
- Quotas require ext4 filesystem and proper mount options
+ Commands like edquota, repquota essential for management
```

### Quick Reference
- **Install quota:** `dnf install quota`
- **Enable quota:** `quotaon -u -g /mount_point`
- **Set user limits:** `edquota username`
- **Set group limits:** `edquota -g groupname`
- **Check usage:** `quota -u username`
- **Report all:** `repquota /mount_point`
- **Set grace period:** `edquota -t`

### Expert Insight
**Real-world Application:** In enterprise environments, implement quotas on /home for users and /var for logs to prevent accidental disk fills during automated processes.

**Expert Path:** Master ACLs and extended attributes alongside quotas for finer access control. Practice with LVM snapshots for recovery during quota exceedances.

**Common Pitfalls:** Forgetting to enable quotas post-mount leads to no enforcement; setting grace periods too short causes immediate blocking; mixing quota with LVM resizing without rebuild invalidates quota databases.

</details>
