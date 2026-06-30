# Section 15: RAID and Backup

<details open>
<summary><b>Section 15: RAID and Backup (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [15.1 RAID 1 - Mirroring](#151-raid-1---mirroring)
- [15.2 RAID 5 - Striping with Parity](#152-raid-5---striping-with-parity)
- [15.3 RAID 10 and ZFS](#153-raid-10-and-zfs)
- [15.4 Backup Strategies](#154-backup-strategies)
- [Summary](#summary)

---

## 15.1 RAID 1 - Mirroring

### Overview
RAID 1, also known as mirroring, is a fundamental fault-tolerance technology that creates exact copies of data across two drives simultaneously. This ensures that if one drive fails, the other can immediately take over without any data loss. The technology is implemented at the hardware controller level in servers and provides redundancy while maintaining read performance comparable to a single drive.

### Key Concepts

#### What is RAID?
RAID stands for **Redundant Array of Inexpensive/Independent Disks/Drives**. The importance lies in:
- **R (Redundancy)**: Data exists in multiple places for fault tolerance
- **A (Array)**: All drives working together as a single logical unit

#### How RAID 1 Works
- Uses exactly **two drives** that are mirrored
- Controller writes all data to both drives simultaneously
- Creates a single logical volume (drive letter) from both drives
- Total usable storage equals the size of one drive (50% efficiency)

#### Performance Characteristics
| Operation | Performance Impact | Reason |
|-----------|-------------------|---------|
| **Write Speed** | Slower than single drive | Must write to both drives simultaneously |
| **Read Speed** | Same as single drive | Reads from one drive only |
| **Fault Tolerance** | Excellent | Survives single drive failure |

#### Disk Duplexing Optimization
- Uses **two controllers** (one for each drive) instead of one
- Reduces write speed penalty of standard RAID 1
- Provides additional redundancy at the controller level

### Hardware Configuration Example (HP Server)

#### BIOS Configuration Steps:
1. Access the Smart Array Controller in BIOS
2. Select "Create Logical Drive" option
3. Choose RAID 1 configuration (not the default RAID 0)
4. Verify selection: "RAID 1 fault tolerance" with total data size
5. Press F8 to save configuration
6. Confirm: "Configuration saved"

#### Important Notes:
- RAID 0 (striping) provides no fault tolerance - avoid for critical data
- With RAID 1, only two drives can be used per array
- For servers with more drives, create multiple RAID 1 arrays

### Key Points Summary
- ✅ RAID 1 uses exactly two mirrored drives
- ✅ Data written to both drives simultaneously
- ✅ Automatic failover if one drive fails
- ✅ Write speed slower, read speed equivalent to single drive
- ✅ Creates single logical volume

---

## 15.2 RAID 5 - Striping with Parity

### Overview
RAID 5 combines the performance benefits of striping with fault tolerance through distributed parity information. Data and compressed parity information are striped across three or more drives, allowing the system to rebuild lost data if any single drive fails. This provides excellent performance and storage efficiency while maintaining fault tolerance.

### Key Concepts

#### RAID 5 Architecture
- Requires **minimum of 3 drives**, supports 10+ drives
- Data is **striped** across all drives for performance
- **Parity information** (compressed data recovery data) is also striped
- Parity is distributed evenly across all drives using rotating patterns

#### How Parity Striping Works
**Example with 3 drives and data chunks A, B, C:**

| Drive 1 | Drive 2 | Drive 3 |
|---------|---------|---------|
| A1 | A2 | A(P) |
| B1 | B(P) | B2 |
| C(P) | C1 | C2 |

Where (P) represents parity information for that data chunk.

#### Fault Tolerance Mechanism
- If any single drive fails, data can be **rebuilt from parity**
- Example: If Drive 1 fails:
  - A1 rebuilt from A(P) on Drive 3
  - B1 rebuilt from B2 on Drive 3
  - C(P) must be recalculated from C1 and C2
- **Maximum tolerance: 1 drive failure**
- Losing 2+ drives results in total data loss

#### Performance Benefits
| Feature | Benefit |
|---------|---------|
| **Write Speed** | Faster than single drive (stripe across multiple drives) |
| **Read Speed** | Faster than single drive (stripe across multiple drives) |
| **Storage Efficiency** | (n-1)/n where n = number of drives |

#### RAID 6 Extension
- Adds **fourth drive** for dual parity
- Can survive **two drive failures**
- Requires minimum of 4 drives
- Labeled as A(P1) and A(P2) for dual parity sets

### Implementation Notes
- Creates **single logical volume** presented to the OS
- Linux sees one volume, not individual drives
- Most servers support **hot-swappable drives**
- Ideal for servers requiring large storage with fault tolerance

### Key Points Summary
- ✅ Uses 3+ drives with striping and distributed parity
- ✅ Survives single drive failure through parity reconstruction
- ✅ Better performance than RAID 1 for large data storage
- ✅ Hot-swappable drive support common in servers

---

## 15.3 RAID 10 and ZFS

### Overview
RAID 10 combines RAID 0 striping with RAID 1 mirroring to achieve both high performance and fault tolerance. Unlike RAID 5/6, RAID 10 uses no parity - instead, it creates multiple RAID 1 mirrors that are then striped together. Additionally, ZFS (Zettabyte File System) provides software-based RAID capabilities directly within the Linux operating system.

### Key Concepts

#### RAID 10 Architecture
- **Minimum requirement: 4 drives**
- **Combination approach**: RAID 0 + RAID 1
- Creates multiple RAID 1 mirrors, then stripes data across them
- No parity information used - fault tolerance through mirroring only

#### How RAID 10 Striping Works
**Example with 4 drives:**

| RAID 1 Mirror (Odd) | RAID 1 Mirror (Even) |
|---------------------|----------------------|
| A1 (primary) | A2 (primary) |
| A3 (primary) | A4 (primary) |
| A1 (mirror) | A2 (mirror) |
| A3 (mirror) | A4 (mirror) |

Data chunks are written alternately to different mirrors (A1, A2, A3, A4) for striping performance.

#### Performance and Tolerance Characteristics
| Feature | RAID 10 Specification |
|---------|----------------------|
| **Minimum Drives** | 4 (creates 2 RAID 1 mirrors) |
| **Fault Tolerance** | Survives multiple drive failures (one per mirror) |
| **Read Performance** | Excellent (stripe + mirror reads) |
| **Write Performance** | Good (mirror writes with stripe distribution) |
| **Storage Efficiency** | 50% (due to mirroring) |

#### Fault Tolerance Example
- If one drive fails in each mirror, system continues operating
- No parity calculation overhead
- Hot-swappable drive replacement supported

### Hardware Configuration Example (Dell Server)

#### BIOS/RAID Controller Setup:
1. Access Device Settings → Integrated RAID Controller
2. Controller: PERC H730 (example)
3. Navigate to Configuration Management
4. Select "Convert to RAID Capable"
5. Choose drives for array configuration
6. Options include: RAID 0, 1, 5, 6, 10

#### Configuration Strategies:
- **Example**: RAID 1 (2 drives for OS) + RAID 5 (remaining drives for data)
- **Example**: RAID 10 array across all available drives
- Can create multiple arrays from available drives

### ZFS - Software-Based RAID

#### What is ZFS?
- **ZFS**: Originally "Zettabyte File System," now just called ZFS
- Provides **software-based RAID** directly in Linux
- Supported RAID levels: RAID 1, 5, 10
- Integrated file system with advanced features

#### ZFS Implementation Example
- System: Proxmox Virtual Environment (Debian-based)
- Hardware: 8 SAS drives (300GB each)
- Configuration: RAID 10 ZFS across all 8 drives
- Kernel: 6.5 PVE (Proxmox-specific)

#### ZFS Architecture Details
```
Drive Structure:
- BIOS Boot Partition
- EFI Partition
- ZFS File System Partition

Total Volume: ~1.5TB usable (from 2.4TB raw with RAID 10)
```

#### ZFS Advantages
- **Software-based**: No hardware RAID controller dependency
- **Automatic RAID**: Handles RAID 1, 5, 10 configurations
- **Advanced Features**: Built-in compression, snapshots, data integrity
- **Linux Integration**: Native support in modern distributions

#### ZFS Considerations
- ⚠️ **Risk**: Software-based nature may not be supported by all applications
- ⚠️ **Policy**: Some organizations require hardware controller RAID
- ✅ **Recommendation**: Excellent tool for virtualization platforms

### Key Points Summary
- ✅ RAID 10 combines speed (RAID 0) + fault tolerance (RAID 1)
- ✅ No parity overhead - uses mirroring for redundancy
- ✅ ZFS provides software RAID 1, 5, 10 capabilities
- ✅ Requires minimum 4 drives for RAID 10
- ✅ Proxmox example shows practical ZFS implementation

---

## 15.4 Backup Strategies

### Overview
Backup strategies are distinct from fault tolerance and focus on creating separate copies of data for recovery purposes. While RAID provides immediate fault tolerance, backups protect against data corruption, deletion, ransomware, and complete system failures. Linux offers robust backup tools including rsync, dd, and various third-party solutions.

### Key Concepts

#### Backup vs. Fault Tolerance Distinction
| Aspect | RAID/Fault Tolerance | Backup |
|--------|---------------------|---------|
| **Purpose** | Immediate drive failure recovery | Long-term data protection |
| **Redundancy** | Hardware-level duplication | Separate data copies |
| **Protection** | Single drive failure | Multiple failure scenarios |
| **Storage** | Within array | External/different location |

#### Backup Device Options

##### Hardware Solutions:
1. **Linear Tape Open (LTO)**: High-capacity tape drives
   - Handles terabytes of data
   - Long-term archival storage
   - Often Linux-based systems

2. **Network Attached Storage (NAS)**:
   - Companies: Synology and similar
   - Drive configurations: 2-6+ drives
   - Supports RAID 1, 5, 6, 10
   - Debian/Fedora-based firmware
   - Ideal for small to medium businesses

#### Linux Backup Tools

##### Built-in Tools:
1. **rsync**: Primary backup utility
   - Archive mode preserves permissions and timestamps
   - Incremental backup capabilities
   - Network-aware transfer

2. **dd**: Low-level disk operations
   - ISO image copying
   - Drive cloning and zeroing
   - Block-level data transfer

3. **ZFS send/receive**: ZFS-specific backup
   - Snapshot-based backups
   - Efficient incremental transfers

##### Third-Party Solutions:
- **Duplicati**: Cross-platform backup
- **Deja Dup**: GNOME-based backup
- **Borg**: Efficient deduplication backup
- **Syncthing**: Real-time file synchronization

#### Key Third-Party Features to Evaluate

##### Essential Features:
- **Archiving**: Long-term data preservation
- **Deduplication**: Eliminates duplicate data copies
- **Compression**: Reduces storage requirements
- **Cloud Integration**: Off-site backup capabilities
- **Synchronization**: Real-time file updates

### Practical rsync Demonstration

#### Environment Setup:
- **Client**: Debian system with documents and downloads directories
- **Server**: Remote Debian server
- **Authentication**: SSH keys (no password required)

#### SSH Configuration Restoration:
```bash
# Backup current secure config
cp sshd_config sshd_config-secure.bak

# Restore original configuration
cp sshd_config.bak sshd_config

# Restart SSH service
systemctl restart ssh
```

#### rsync Installation:
```bash
# Install on both systems
sudo apt install rsync
```

#### rsync Backup Command:
```bash
rsync -AvrP {documents,downloads} user@debian-server:/backup/path/
```

#### Command Options Explained:
| Option | Function |
|--------|----------|
| `-A` | Archive mode (preserves permissions, timestamps, symbolic links) |
| `-v` | Verbose output showing transfer details |
| `-r` | Recursive directory traversal |
| `-P` | Progress display during transfer |

#### Transfer Results Example:
```
Ubuntu.iso          2.1GB @ 173MB/s (11 seconds)
nomachine.deb       ~100MB @ 138MB/s (immediate)
documents/          Various files transferred with progress
```

### Advanced Backup Automation

#### Scheduling Options:
1. **Cron Jobs**: Automated scheduled backups
2. **Bash Scripts**: Custom automation with loops
3. **Ansible Playbooks**: Infrastructure-as-code backups

#### Example Automation Approaches:
```bash
# Cron job example (daily backup at 2 AM)
0 2 * * * rsync -AvrP /data/ backup@server:/backups/

# Bash script with logging
#!/bin/bash
rsync -AvrP /important/data/ backup@server:/backups/$(date +%Y%m%d)/
```

### Key Points Summary
- ✅ Backup is distinct from RAID fault tolerance
- ✅ rsync with archive mode provides efficient incremental backups
- ✅ Multiple device options: tape, NAS, cloud
- ✅ Third-party tools offer deduplication and compression
- ✅ Automation through cron, scripts, or Ansible
- ✅ Always verify SSH connectivity and tool installation

---

## Summary

### Key Takeaways
```diff
+ RAID 1: Simple mirroring with 2 drives for basic fault tolerance
+ RAID 5: Striping with distributed parity for performance + tolerance
+ RAID 10: Combines striping speed with mirror redundancy (4+ drives)
+ ZFS: Software-based RAID implementation within Linux
+ Backup: Essential separate strategy from fault tolerance
+ rsync: Primary tool for efficient, incremental Linux backups
```

### Quick Reference

#### RAID Comparison Table:
| RAID Level | Min Drives | Fault Tolerance | Performance | Storage Efficiency |
|------------|------------|-----------------|-------------|-------------------|
| RAID 1 | 2 | 1 drive | Read: Good, Write: Slow | 50% |
| RAID 5 | 3 | 1 drive | Read/Write: Good | (n-1)/n |
| RAID 6 | 4 | 2 drives | Read/Write: Good | (n-2)/n |
| RAID 10 | 4 | Multiple | Excellent | 50% |

#### Essential Commands:
```bash
# rsync backup with archive and progress
rsync -AvrP source/ user@server:/destination/

# Check ZFS status (if using ZFS)
zpool status

# System information for RAID analysis
uname -a && df -h
```

### Expert Insight

#### Real-world Application
- **RAID 1**: Use for critical OS/boot volumes requiring simple redundancy
- **RAID 5**: Ideal for file servers and databases with large storage needs
- **RAID 10**: Perfect for high-performance applications like virtualization hosts
- **ZFS**: Excellent for Proxmox/Proxmox VE and modern Linux virtualization
- **Backup Strategy**: Implement 3-2-1 rule (3 copies, 2 media types, 1 offsite)

#### Expert Path
1. Start with understanding hardware RAID controller BIOS configuration
2. Practice rsync with various options in lab environments
3. Experiment with ZFS on non-production systems
4. Develop automated backup scripts with proper logging
5. Study advanced ZFS features like snapshots and send/receive

#### Common Pitfalls
- ❌ Confusing RAID fault tolerance with backup protection
- ❌ Using RAID 0 for any data that cannot be lost
- ❌ Not testing backup restoration procedures
- ❌ Over-securing SSH configurations that break automation
- ❌ Forgetting that RAID 5/6 can only handle specific drive failure counts

#### Lesser-Known Facts
- 💡 RAID 1 with two controllers (disk duplexing) provides additional redundancy
- 💡 ZFS provides built-in data integrity checking beyond standard RAID
- 💡 Most enterprise servers support hot-swapping drives without downtime
- 💡 rsync archive mode is crucial for preserving Linux permissions and attributes
- 💡 Proxmox combines virtualization with advanced ZFS storage capabilities

</details>