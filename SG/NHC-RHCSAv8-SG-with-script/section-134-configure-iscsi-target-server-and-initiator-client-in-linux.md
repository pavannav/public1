# Section 134: iSCSI Target and Initiator

<details open>
<summary><b>Section 134: iSCSI Target and Initiator (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [iSCSI Targets and Initiators](#iscsi-targets-and-initiators)
- [Block-Level vs File System Sharing](#block-level-vs-file-system-sharing)
- [iSCSI Ports](#iscsi-ports)
- [Configuring iSCSI Target Server](#configuring-iscsi-target-server)
- [Configuring iSCSI Initiator Client](#configuring-iscsi-initiator-client)
- [Discovery and Login](#discovery-and-login)
- [Partitioning and Mounting](#partitioning-and-mounting)
- [Verification and Best Practices](#verification-and-best-practices)
- [Summary](#summary)

<a name="overview"></a>
## Overview
In this section, we explore iSCSI (Internet Small Computer Systems Interface) which is a transport layer protocol that works on top of TCP/IP. iSCSI allows block-level storage sharing over IP networks, enabling remote storage devices to appear as local block devices. The session demonstrates how to configure an iSCSI target server to share block storage and set up an initiator client to access that shared storage, complete with practical commands for LUN creation, mapping, discovery, and mounting.

<a name="key-concepts"></a>
## Key Concepts

<a name="iscsi-targets-and-initiators"></a>
### iSCSI Targets and Initiators
> [!IMPORTANT]
> The iSCSI target serves as the storage provider (server), while the iSCSI initiator acts as the storage consumer (client).

- **Target**: The system sharing storage resources over the network
- **Initiator**: The system accessing the shared storage from the target
- Each system has a unique iSCSI Qualified Name (IQN) for identification

<a name="block-level-vs-file-system-sharing"></a>
### Block-Level vs File System Sharing
```diff
! iSCSI operates at the block level, unlike NFS, Samba, or AFS which work at the file system level
```

- **Block Level**: Shares raw disk blocks directly, allowing for custom partitioning, file systems, and full disk utilization
- **File System Level**: Requires creating file systems before sharing, limiting flexibility
- iSCSI presents shared storage as virtual disk devices in `/dev/sd*` or similar paths

<a name="iscsi-ports"></a>
### iSCSI Ports
- Target uses port `3260` for connections
- Initiator uses port `860` for operations

<a name="configuring-iscsi-target-server"></a>
### Configuring iSCSI Target Server
Pre-requirements: Ensure repositories are configured with `dnf repolist` or `yum repolist`.

#### Hostname and Package Installation
```bash
# Set static hostname
hostnamectl set-hostname server.nehra-classes.local
hostnamectl status

# Verify hostname
hostnamectl status

# Install targetcli package
dnf install -y targetcli
```

#### Create LUN Using Block Storage
Add a disk to the virtual machine first (e.g., 20GB disk via VMware settings), then:

```bash
# List block devices
lsblk

# Launch targetcli interactive shell
targetcli

# Inside targetcli shell:
/backstores/block create newlun /dev/sdb
/backstores/block ls
```

#### Create iSCSI Target and Configure LUN Mapping
```bash
# Create target (IQN generated automatically)
/iscsi create
cd /iscsi/iqn.2003-01.org.linux-iscsi.server.nehra:x86:dev.newlun/tpg1

# Create LUN mapping
luns/ create /backstores/block/newlun

# Create ACL for initiator access
acls/ create iqn.1994-05.com.redhat:client1

# Configure portal (network interface for target)
/iscsi/iqn.2003-01.org.linux-iscsi.server.nehra:x86:dev.newlun/tpg1/portals create

# Verify configuration
tree
exit
```

<a name="configuring-iscsi-initiator-client"></a>
### Configuring iSCSI Initiator Client
On the client system, install the required package and discover targets.

```bash
# Verify hostname
hostnamectl set-hostname client.nehra-classes.local
hostnamectl status

# List available block devices (no additional disks should exist)
lsblk

# Install iscsi-initiator-utils
dnf install -y iscsi-initiator-utils

# Get client's IQN (needed for ACL configuration)
cat /etc/iscsi/initiatorname.iscsi
```

<a name="discovery-and-login"></a>
### Discovery and Login
Use the server's IP address (e.g., 192.168.0.143) for discovery and login.

```bash
# Discover available targets from server
iscsiadm -m discovery -t st -p 192.168.0.143

# Login to discovered target
iscsiadm -m node -T iqn.2003-01.org.linux-iscsi.server.nehra:x86:dev.newlun -p 192.168.0.143 -l

# Verify new block device appears
lsblk
# You should now see an additional device like /dev/sdb
```

<a name="partitioning-and-mounting"></a>
### Partitioning and Mounting
Once the iSCSI LUN is attached as a local block device:

```bash
# Partition the new device
fdisk /dev/sdb
# Inside fdisk: n (new), p (primary), 1 (partition number), Enter (default first sector), Enter (default last sector), w (write)

# Format the partition
mkfs.ext4 /dev/sdb1

# Create mount point
mkdir -p /mnt/iscsi_data

# Mount the filesystem
mount /dev/sdb1 /mnt/iscsi_data

# Create test files
touch /mnt/iscsi_data/file1.txt /mnt/iscsi_data/file2.txt
echo "Test data in shared iSCSI storage" > /mnt/iscsi_data/test.txt
```

<a name="verification-and-best-practices"></a>
### Verification and Best Practices
#### Verification Commands
On server:
```bash
# Check targetcli configuration
targetcli
ls
info /iscsi/iqn.2003-01.org.linux-iscsi.server.nehra:x86:dev.newlun/tpg1
exit

# Check if target service is running
systemctl status target
```

On client:
```bash
# View iSCSI sessions
iscsiadm -m session

# Detailed iSCSI info
iscsiadm -m node
```

> [!NOTE]
> Always distinguish between local disks and iSCSI shared disks to avoid accidental formatting of shared storage.

> [!IMPORTANT]
> Never format or modify disks that are being used as iSCSI LUNs without proper understanding - they may contain data from remote clients.

## Summary

### Key Takeaways
```diff
+ iSCSI enables block-level remote storage sharing over IP networks
+ Target server shares raw disk blocks as LUNs; initiator mounts them as local devices
+ Leader in enterprise environments for centralized storage management
+ Requires careful ACL configuration for security
! Target always uses port 3260
! Always verify your configurations before formatting disks
```

### Quick Reference
- **Target installation**: `dnf install targetcli`
- **Initiator installation**: `dnf install iscsi-initiator-utils`
- **Create LUN**: `/backstores/block create $NAME /dev/$DEVICE`
- **Discover targets**: `iscsiadm -m discovery -t st -p $SERVER_IP`
- **Login to target**: `iscsiadm -m node -T $TARGET_IQN -p $SERVER_IP -l`

### Expert Insight
**Real-world Application**: Production environments use iSCSI for SAN (Storage Area Network) implementations, enabling enterprise applications to access shared storage pools across multiple servers.

**Expert Path**: Master multipathing techniques and advanced target configurations for high availability setups. Learn CHAP authentication for secure iSCSI sessions.

**Common Pitfalls**: 
- Accidentally formatting LUNs thinking they're local disks
- Incorrect ACL configurations preventing access (the transcript showed this corrected by properly setting up ACLs)
- Network connectivity issues between target and initiator
- Not properly distinguishing between local block devices and iSCSI-attached ones

In the transcript, there were transcription errors where "iSCSI" was repeatedly misspoken as "ice cream" (आइसक्रीम), and commands were described phonetically. The correct terms have been used in this guide.

</details>
