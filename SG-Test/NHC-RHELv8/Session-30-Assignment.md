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
</details>