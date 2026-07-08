<details open>
<summary><b> Section 30: Disk Management in Linux - Managing Storage in RHEL-8</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Beginner Level Exercises

### Exercise 1.1: Storage Device Identification
**Objective:** Identify and understand different storage device types in Linux

**Tasks:**
- Use `lsblk` command to list all block devices on your system
- Run `ls -l /dev/disk/by-id/` to identify storage devices by their unique IDs
- Execute `cat /proc/partitions` and compare with `lsblk` output
- Document the differences between `/dev/sda`, `/dev/sdb`, and NVMe devices (`/dev/nvme0n1`)

**Expected Output:** A document explaining each column in `lsblk` output and device naming conventions

### Exercise 1.2: Disk Information Gathering
**Objective:** Gather detailed information about storage devices

**Tasks:**
- Use `fdisk -l` to view partition tables of all disks
- Run `parted -l` to get detailed partition information
- Execute `dmesg | grep -i "sd[a-z]"` to view kernel messages about disk detection
- Use `udevadm info --query=all --name=/dev/sda` to get device properties

**Deliverable:** Create a checklist comparing `fdisk` vs `parted` output formats

### Exercise 1.3: Understanding Device Naming
**Objective:** Master Linux storage device naming conventions

**Tasks:**
- Create a mapping table showing:
  - IDE devices naming pattern
  - SATA/SCSI device naming pattern
  - NVMe device naming pattern
  - USB storage naming pattern
- Practice identifying device types from their names: `/dev/sda`, `/dev/nvme0n1`, `/dev/mmcblk0`

**Exercise:** Given device names `/dev/sdb3`, `/dev/nvme1n1p2`, `/dev/mmcblk0p1`, identify each component

## Intermediate Level Exercises

### Exercise 2.1: Virtual Disk Addition and Detection
**Objective:** Add virtual disks to a VM and detect them without reboot

**Tasks:**
- Add a new 10GB virtual disk to your RHEL 8 VM (use your hypervisor's settings)
- Without rebooting, scan for new storage devices using:
  ```bash
  echo "---" > /sys/class/scsi_host/host0/scan
  echo "---" > /sys/class/scsi_host/host1/scan
  echo "---" > /sys/class/scsi_host/host2/scan
  ```
- Verify the new disk appears using `lsblk` and `fdisk -l`
- Document the complete process including before/after comparisons

**Challenge:** Add multiple disks of different sizes and identify them correctly

### Exercise 2.2: MBR Partition Table Analysis
**Objective:** Understand and work with MBR (DOS) partition tables

**Tasks:**
- Create a backup of your current partition table: `sfdisk -d /dev/sda > /tmp/sda-backup.txt`
- Using `fdisk`, analyze the structure of an MBR partition table
- Document the limitations: maximum partitions, size limits
- Practice identifying primary vs extended partitions
- Create a visual diagram showing how extended partitions work with logical partitions

**Practical Task:** On a test disk, create the maximum number of primary partitions possible with MBR

### Exercise 2.3: GPT Partition Table Exploration
**Objective:** Work with modern GPT partition tables

**Tasks:**
- Compare GPT vs MBR by converting a test disk between formats (backup first!)
- Use `gdisk` to examine GPT-specific features:
  - GUID partition entries
  - Protective MBR
  - Backup partition table location
- Document GPT advantages: partition count, size limits, UUID usage
- Practice recovering GPT from backup headers

**Exercise:** Create a comparison table of MBR vs GPT capabilities and limitations

## Advanced Level Exercises

### Exercise 3.1: Storage Troubleshooting Scenarios
**Objective:** Diagnose and resolve common storage issues

**Scenario-based Tasks:**
1. A disk shows as `/dev/sda` but `fdisk -l` reports "contains no partitions"
2. New disk added to VM but not visible in `lsblk`
3. Disk appears with wrong size or as read-only
4. Multiple disks have similar names after hot-add

**Methods to Practice:**
- Using `dmesg` to diagnose detection issues
- Checking `/var/log/messages` for storage events
- Using `udevadm trigger` to reprocess device events
- Verifying multipath configuration when applicable

### Exercise 3.2: Storage Performance Analysis
**Objective:** Analyze storage device performance characteristics

**Tasks:**
- Use `lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE,MODEL` for detailed output
- Run `cat /sys/block/sda/queue/rotational` to identify SSD vs HDD
- Check device scheduler: `cat /sys/block/sda/queue/scheduler`
- Use `smartctl -a /dev/sda` (if available) to view S.M.A.R.T. data
- Create a script that identifies all SSDs vs HDDs in the system

**Deliverable:** Write a bash script that categorizes all storage devices by type and reports their key characteristics

### Exercise 3.3: Multi-Disk Environment Setup
**Objective:** Configure a complex multi-disk storage environment

**Tasks:**
- Add 4 additional virtual disks of varying sizes (5GB, 10GB, 15GB, 20GB)
- Create a naming convention document for your environment
- Write a script that:
  - Identifies all new disks (not the boot disk)
  - Displays their sizes, types, and current status
  - Creates a report of available storage capacity
- Practice safe disk identification methods to prevent accidental operations on wrong disks

**Advanced Challenge:** Implement disk identification using UUIDs and udev rules

</details>

<summary><b>Set-02 Assignment</b></summary>

## Expert Level Exercises

### Exercise 4.1: Enterprise Storage Planning
**Objective:** Design storage architecture for enterprise scenarios

**Scenario:** Design storage layout for a database server requiring:
- OS partition (minimum 50GB)
- Database data partition (minimum 200GB, high IOPS)
- Database logs partition (minimum 100GB, sequential writes)
- Backup partition (minimum 500GB)
- Temporary/scratch space (minimum 100GB)

**Tasks:**
- Research and document appropriate RAID levels for each partition type
- Calculate minimum number of physical disks required
- Design partition layout considering performance and redundancy
- Document the boot process implications of your design
- Create implementation scripts with safety checks

**Deliverable:** Complete storage architecture document with implementation plan

### Exercise 4.2: Storage Automation Framework
**Objective:** Create automated storage management tools

**Tasks:**
- Develop a comprehensive storage management script that:
  - Safely identifies disks using multiple methods (name, UUID, serial, size)
  - Creates automated partitioning schemes based on disk size
  - Implements logging of all storage operations
  - Includes rollback capabilities
  - Generates storage inventory reports
- Implement udev rules for consistent device naming in your environment
- Create monitoring scripts that alert on storage changes

**Requirements:**
- Must handle multiple disk types (SATA, NVMe, virtual disks)
- Must include extensive error handling and validation
- Must maintain an audit trail of all operations

### Exercise 4.3: Storage Recovery and Migration
**Objective:** Master advanced storage recovery techniques

**Complex Scenarios:**
1. Recover data from a disk with corrupted partition table
2. Migrate data from MBR to GPT disk while online
3. Recover from accidental `dd` operation on wrong disk
4. Implement disk encryption key recovery procedures
5. Design and test a complete bare-metal recovery procedure

**Tools to Master:**
- `testdisk` and `photorec` for data recovery
- `ddrescue` for imaging failing disks
- Various partition table backup/restore methods
- Live CD/USB environments for recovery

**Documentation:** Create a comprehensive storage recovery playbook with step-by-step procedures

### Exercise 4.4: Performance Optimization and Benchmarking
**Objective:** Optimize storage performance for specific workloads

**Tasks:**
- Set up a test environment with multiple storage configurations
- Benchmark different configurations using tools like:
  - `fio` for I/O performance testing
  - `ioping` for latency measurements
  - Custom scripts using `dd` with various block sizes
- Analyze impact of different schedulers (noop, deadline, cfq)
- Test impact of I/O scheduler parameters
- Document findings with performance graphs and recommendations

**Advanced Challenge:** Create a storage performance comparison matrix for different workload types (database, file server, web server, backup server)

## Certification Preparation Exercises

### Exercise 5.1: RHCSA Exam Scenarios
**Objective:** Practice exam-style storage tasks under time constraints

**Timed Exercises (complete within 15 minutes each):**
1. Add a new disk, create GPT partition table, create 2GB partition
2. Identify all disks larger than 10GB and create a report
3. Configure persistent device naming using UUIDs
4. Create a script that safely wipes all non-boot disks (with confirmation)
5. Implement automated disk inventory system

**Exam Tips Documented:**
- Safe disk identification methods
- Common exam pitfalls to avoid
- Time-saving command combinations
- Verification procedures

### Exercise 5.2: Real-World Production Scenarios
**Objective:** Handle production storage management challenges

**Production Scenarios:**
1. **Capacity Planning:** Analyze current storage utilization and project growth
2. **Maintenance Windows:** Plan and document storage maintenance procedures
3. **Compliance:** Implement storage encryption and access auditing
4. **Disaster Recovery:** Design and document storage backup strategies
5. **Performance Tuning:** Optimize storage for specific application requirements

**Documentation Requirements:**
- Create runbooks for common storage operations
- Design change management procedures for storage modifications
- Implement monitoring and alerting for storage events
- Create training materials for junior administrators

</details>
</details>