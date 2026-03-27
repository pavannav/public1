# Section 54: Stratis Filesystem Management in RHEL 8

<details open>
<summary><b>Section 54: Stratis Filesystem Management in RHEL 8 (CL-KK-Terminal)</b></summary>

## Table of Contents

1. [Introduction to Stratis Filesystem](#introduction-to-stratis-filesystem)
2. [Installing Stratis Packages](#installing-stratis-packages)
3. [Enabling and Starting Stratis Services](#enabling-and-starting-stratis-services)
4. [Creating and Managing Stratis Pools](#creating-and-managing-stratis-pools)
5. [Creating and Managing Filesystems](#creating-and-managing-filesystems)
6. [Adding Physical Volumes to Pools](#adding-physical-volumes-to-pools)
7. [Filesystem Snapshots](#filesystem-snapshots)
8. [Deleting Filesystems and Pools](#deleting-filesystems-and-pools)
9. [Summary](#summary)

## Introduction to Stratis Filesystem

Stratis is an advanced filesystem feature introduced with RHEL (Red Hat Enterprise Linux) that provides enhanced storage capabilities. It supports thin provisioning, filesystem snapshots, tiering, and portfolio management. By default, Stratis uses Btrfs as its underlying filesystem, offering improved flexibility and efficiency over traditional filesystems.

Stratis allows you to:
- Create thin-provisioned volumes
- Take snapshots of filesystems for data backup and recovery
- Manage storage tiering
- Monitor filesystem and pool usage
- Expand pools dynamically by adding disks

> [!NOTE]
> Stratis is designed for production environments where advanced storage features are required. It's a modern alternative to tools like LVM, providing better performance and features.

## Installing Stratis Packages

To use Stratis on RHEL 8, you need to install two key packages:
- `stratisd`: The daemon service
- `stratis-cli`: Command-line tools for management

### Installation Commands
For CentOS or other RHEL-derived distributions:
```bash
yum install stratisd stratis-cli
```

For RHEL with subscriptions:
```bash
subscription-manager repos --enable=rhel-8-for-x86_64-appstream-rpms
yum install stratisd stratis-cli
```

If using local repositories, ensure they are configured locally.

### Verification
Check if packages are installed:
```bash
rpm -qa | grep stratis
```

## Enabling and Starting Stratis Services

Once installed, enable and start the Stratis daemon:
```bash
systemctl enable stratisd --now
```

### Verification
Check service status:
```bash
systemctl status stratisd
```

The service should be active and running. It will auto-start on reboot if enabled.

## Creating and Managing Stratis Pools

A pool in Stratis acts like a volume group in LVM, aggregating multiple physical disks for filesystem creation.

### Creating a Pool
```bash
stratis pool create <poolname> /dev/<disk1> /dev/<disk2> ...
```

Example:
```bash
stratis pool create mypool /dev/sdb /dev/sdc
```

### Listing Pools
```bash
stratis pool list
```

This shows pool names, sizes, and associated devices.

### Pool Details
Each pool displays:
- Name
- Total size (sum of all added devices)
- Used size
- Status

> [!IMPORTANT]
> Ensure no filesystem exists on drives before adding to a pool. Wipe existing filesystems if needed:
> ```bash
> wipefs -a /dev/<disk>
> ```

## Creating and Managing Filesystems

Once a pool is created, you can add filesystems (analogous to logical volumes).

### Creating a Filesystem on a Pool
```bash
stratis filesystem create <poolname> <filesystemname>
```

Example:
```bash
stratis filesystem create mypool myfilesystem1
```

### Listing Filesystems
```bash
stratis filesystem list <poolname>
```

Or for all pools:
```bash
stratis filesystem list
```

### Mounting Filesystems
Filesystems are accessible via UUID or device paths under `/stratis/<poolname>/`.
```bash
mount /stratis/<poolname>/<filesystemname> /mnt/data
```

Create directories and mount persistently by adding to `/etc/fstab`:
```bash
UUID=<fs-uuid> /mnt/data stratis defaults 0 0
```

Use `blkid` or check `/etc/fstab` entries for UUIDs.

### Filesystem Check Configuration
In `/etc/fstab`, set the last field to:
- `0`: No check
- `1`: Root filesystem check
- `2`: Non-root filesystem check

Example entry added via UUID:
```bash
stratis filesystem create mypool datafs
# Then in fstab:
UUID=abcdef-1234-5678... /mnt/data stratis defaults 0 2
```

## Adding Physical Volumes to Pools

To expand pool storage, add more disks dynamically.

### Adding a Disk to an Existing Pool
```bash
stratis pool add-data mypool /dev/sdd
```

### Verification
List pools again to see updated size:
```bash
stratis pool list mypool
```

The pool size will increase by the added disk's capacity.

## Filesystem Snapshots

Snapshots capture the state of a filesystem at a point in time for backup/restore.

### Creating a Snapshot
```bash
stratis filesystem snapshot <poolname> <sourcefs> <snapshotname>
```

Example:
```bash
stratis filesystem snapshot mypool datafs data-snapshot
```

### Restoring from a Snapshot
Unmount the original filesystem, create a copy from the snapshot, then remount.

Example workflow:
1. Create snapshot.
2. Delete/modify data.
3. Create a new filesystem copy from the snapshot.
4. Mount the snapshot-based filesystem to recover data.

## Deleting Filesystems and Pools

### Deleting Filesystems
```bash
stratis filesystem destroy <poolname> <filesystemname>
```

Verify:
```bash
stratis filesystem list <poolname>
```

### Deleting Pools
```bash
stratis pool destroy <poolname>
```

Permanently removes the pool and associated filesystems. Ensure no active filesystems remain.

## Summary

### Key Takeaways
```diff
+ Stratis provides advanced storage features like thin provisioning, snapshots, and tiering in RHEL 8.
+ Requires stratisd and stratis-cli packages for operation.
+ Pools aggregate disks, filesystems are created on pools, and snapshots enable data recovery.
- Requires clean disks (no pre-existing filesystems) before pool creation.
! Snapshots are space-efficient and allow point-in-time restores without affecting original data.
- Pools and filesystems can be dynamically expanded, but deletions are destructive.
```

### Quick Reference
- **Install**: `yum install stratisd stratis-cli`
- **Create Pool**: `stratis pool create <pool> /dev/sdb /dev/sdc`
- **Create FS**: `stratis filesystem create <pool> <fs>`
- **Mount**: `mount /stratis/<pool>/<fs> /mnt/point`
- **Snapshot**: `stratis filesystem snapshot <pool> <source> <snap>`
- **Delete FS**: `stratis filesystem destroy <pool> <fs>`
- **Delete Pool**: `stratis pool destroy <pool>`

### Expert Insight
**Real-world Application**: Stratis excels in cloud and enterprise environments for scalable storage solutions, especially with its snapshot capabilities for daily backups or rollback scenarios in production systems.

**Expert Path**: Master Stratis by practicing pool expansion, snapshot automation with scripts, and monitoring via `stratis` commands. Understand Btrfs internals for optimal performance tuning.

**Common Pitfalls**: Avoid adding disks with existing data to pools; always verify pool/filesystem status before destructive operations. Ensure proper `/etc/fstab` entries to prevent mount issues after reboots.

</details>
