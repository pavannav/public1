# Section 128: RHCSA Exam Paper Solution Part 3

<details open>
<summary><b>Section 128: RHCSA Exam Paper Solution Part 3 (CL-KK-Terminal)</b></summary>

## Table of Contents

- [Question 15: Partition Creation and LVM Setup](#question-15-partition-creation-and-lvm-setup)
- [Question 16: Btrfs Volume Creation](#question-16-btrfs-volume-creation)
- [Question 17: Resize Logical Volume](#question-17-resize-logical-volume)
- [Question 18: Tune Profile Configuration](#question-18-tune-profile-configuration)
- [Questions 19 & 20: Container Configuration with Persistent Storage and System Startup Service](#questions-19--20-container-configuration-with-persistent-storage-and-system-startup-service)
- [Differences Between Red Hat Container Tools and Red Hat Enterprise Linux](#differences-between-red-hat-container-tools-and-red-hat-enterprise-linux)
- [Summary](#summary)

## Question 15: Partition Creation and LVM Setup

### Overview
This section demonstrates creating a 512MB swap partition and setting up LVM with a volume group and logical volume for database storage. It covers partitioning, LVM creation, file system setup, and mounting.

### Key Concepts/Deep Dive
- **Create Swap Partition**:
  - Use `fdisk` to create a primary partition on `/dev/sdb` (free disk).
  - Set partition type to swap (hex code 82).
  - Size: +512M.
  - Run `partprobe` to update partition table.

- **Create Physical Volume**:
  - Use `pvcreate` on the new partition (`/dev/sdb1`).

Note: For RHEL 8+, use `podman` contexts; for RHEL 9, adjust for newer commands.

- **Create Volume Group**:
  - `vgcreate data-store /dev/sdb2` (assuming second partition).
  - Extent size: 8MB (`-s 8m`).

- **Create Logical Volume**:
  - `lvcreate -L 50G -n database data-store`.
  - Format with `mkfs.ext3`.
  - Mount at `/database` and add to `/etc/fstab`.

### Code/Config Blocks
```bash
# Partition creation (swap)
fdisk /dev/sdb
n (new partition)
p (primary)
w (write)

# Set type to swap
t
82

# Update partitions
partprobe

# Create PV on second partition
pvcreate /dev/sdb2

# Create VG
vgcreate -s 8m data-store /dev/sdb2

# Create LV
lvcreate -L 50G -n database data-store

# Format
mkfs.ext3 /dev/data-store/database

# Mount (temporary)
mount /dev/data-store/database /database

# Add to /etc/fstab
echo "/dev/data-store/database /database ext3 defaults 0 0" >> /etc/fstab
```

### Tables
| Command | Description |
|---------|-------------|
| pvcreate | Initialize disk/partition as Physical Volume |
| vgcreate | Create Volume Group from PVs |
| lvcreate | Create Logical Volume from VG |

## Question 16: Btrfs Volume Creation

### Overview
Create a 50GB Btrfs volume named "vector" and mount it at `/test` directory.

### Key Concepts/Deep Dive
- Install btrfs tools: `dnf install btrfs-progs`.
- Start and enable services.
- Wipe existing file systems if any.
- Create Btrfs volume with 50GB size.
- Format and mount at `/test`.
- Add to `/etc/fstab`.

### Code/Config Blocks
```bash
# Install tools
dnf install btrfs-progs

# Start/enable services
systemctl start<|reserved_126|>-MK btrfs
systemctl enableویس btrfs

# Wipe disk
wipefs -a /dev/sdc

# Create Btrfs volume
btrfs subvolume create /mnt/btrfs/volume  # Adjust path as needed
# Actually, for the question:
mkfs.btrfs /dev/sdc

# Mount
mount /dev/sdc /test

# Add to /etc/fstab
echo "/dev/sdc /testwają btrfs defaults 0 0" >> /etc/fstab
```

## Question 17: Resize Logical LVM

### Overview
Extend logical volume by 100 extents (assuming 8MB extents, this is 800MB).

### Key Concepts/Deep Dive
- Use `lvextend` to add extents.
- Resize file system with `resize2fs`.
- Check current size with `lvs`.

### Code/Config Blocks
```bash
# Extend LV
lvextend -l +100 /dev/data-store/database

# Resize FS
resize2fs /dev/data-store/database

# Verify
lvs
df -h
```

## Question 18: Tune Profile Configuration

### Overview
Apply recommended tuned profile for virtual guest.

### Key Concepts/Deep Dive
- Install tuned if needed.
- Check recommended profile: `tuned-adm recommend`.
- Apply profile: `tuned-adm profile virtual-guest`.

### Code/Config Blocks
```bash
# Install tuned
dnf install tuned

# Check recommend
tuned-adm recommend  # Output: virtual-guest

# Apply
tuned-adm profile virtual-guest
```

## Questions 19 & 20: Container Configuration with Persistent Storage and System Startup Service

### Overview
Configure container for system startup service, using RHS image, with persistent logs and mount at specific directories.

### Key Concepts/Deep Dive
- For RHEL 8 (podman):
  - Pull image: `podman pull registry.redhat.io/rhel8/log-server`.
  - Create container: `podman run --privileged -d --name log-server registry.redhat.io/rhel8/log-server`.
  - For persistent storage: Configure `/var/log/containers` to persist.
  - Mount at `/home/paradise/container_general`.
  - Enable lingering for user: `loginctctl enable-linger paradise`.
  - Generate systemd unit: `podman generate systemd log-server`.
  - Enable/start as user service.

- For RHEL 9:
  - Use `podman run` with additional options for startup.
  - Difference: Podman contexts and lingering more critical.

### Code/Config Blocks (RHEL 9 Example)
```bash
# As root, configure journald
vi /etc/systemd/journald.conf  # Set Storage=persistent
systemctl restart systemd-journald

# As paradise user
su - paradise
podman run -d --name log-server -v /home/paradise/container_general:/var/log:Z registry.redhat.io/rhel8/log-server

# Generate unit
podman generate systemd --name log-server

# Enable restart
vi ~/.config/systemd/user/log-server.service  # Add Restart=always

# Enable/linger
loginctl enable-linger paradise
systemctl --user enable log-server
systemctl --user start log-server
```

### Lab Demos
- Demonstrate rebooting and verifying container starts automatically.
- Check logs in mounted directory.

### Tables
| RHEL Version | Package | Service |
|--------------|---------|---------|
| 8 | podman | systemd-journald |
| 9 | podman-compose (if needed) | systemd-journald |

## Differences Between Red Hat Container Tools and Red Hat Enterprise Linux

### Overview
Key differences in container configuration between Red Hat Container Tools (local) and Red Hat Enterprise Linux (official).

### Key Concepts/Deep Dive
- Red Hat Container Tools:
  - Uses podman contexts.
  - Lingering enabled differently.
  - Image registries may differ.

- Red Hat Enterprise Linux:
  - Standard systemctl for services.
  - Journald configurations standard.
  - More integration with systemd.

## Summary

### Key Takeaways
```diff
+ Partition: Use fdisk for swap (type 82), wipefs for clean disks.
+ LVM: pvcreate -> vgcreate -> lvcreate -> format -> mount.
+ Btrfs: Install tools, create subvolume, mount with options.
+ Tune: Recommend virtual-guest for VMs.
+ Containers: Use podman run with -v for persistence, generate systemd units.
- Do not forget to enable lingering for user sessions.
! Always reboot to verify services start automatically.
```

### Quick Reference
- Partition: `fdisk /dev/sdX -> n -> p -> +size -> t (82) -> w`
- LVM Create: `pvcreate /dev/sdX -> vgcreate VG PV -> lvcreate -L size -n LV VG`
- Container: `podman run -d --name NAME -v HOST:CONT IMAGE`

### Expert Insight

**Real-world Application**: In production, use LVM for flexible storage, containers for microservices with persistent logs on shared storage.

**Expert Path**: Master podman networking, volumes, and orchestration with Kubernetes; practice troubleshooting with `podman logs`.

**Common Pitfalls**: Forget to enable lingering (error: "No such file"), incorrect fstab entries cause boot failures, incorrect registry login leads to pull failures. Always verify mounts with `df -h` and services with `systemctl status`.

</details>
