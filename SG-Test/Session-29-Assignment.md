<details open>
<summary><b> Session 29: Disk Management in Linux - Managing Storage in RHEL 8</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Beginner Level Exercises

### Exercise 1.1: Understanding Block Devices
**Objective**: Identify and understand block devices in a Linux system

**Tasks**:
1. List all block devices in your system using appropriate commands
2. Identify which devices are disks vs partitions
3. Document the major and minor numbers for each block device
4. Check the size and type of each identified device

**Commands**:
```bash
lsblk
lsblk -f
cat /proc/partitions
ls -la /dev/sd*
ls -la /dev/nvme*
```

**Deliverable**: Create a document listing all block devices with their properties, sizes, and types.

### Exercise 1.2: Disk Information Gathering
**Objective**: Gather comprehensive information about storage devices

**Tasks**:
1. Use fdisk to list disk information without making changes
2. Use parted to view disk geometry and partition tables
3. Check disk health status using smartctl if available
4. Document the disk model, serial number, and firmware version

**Commands**:
```bash
sudo fdisk -l
sudo parted -l
sudo smartctl -i /dev/sda
lsblk -o NAME,SIZE,TYPE,MODEL,SERIAL
```

**Deliverable**: A report containing detailed information about each storage device in the system.

### Exercise 1.3: Understanding Device Naming
**Objective**: Understand different storage device naming conventions

**Tasks**:
1. Identify the naming convention used for IDE, SATA, and NVMe devices
2. Map device names to their corresponding /dev entries
3. Create a reference chart showing device naming patterns
4. Verify device symlinks in /dev/disk/by-*

**Commands**:
```bash
ls -la /dev/disk/by-id/
ls -la /dev/disk/by-uuid/
ls -la /dev/disk/by-path/
udevadm info --query=all --name=/dev/sda
```

**Deliverable**: A reference guide documenting device naming conventions and symlink mappings.

## Intermediate Level Exercises

### Exercise 2.1: Partition Table Analysis
**Objective**: Analyze and understand different partition table types

**Tasks**:
1. Examine the current partition table type (MBR vs GPT) on your system
2. Document the differences between MBR and GPT partition tables
3. Calculate the maximum number of partitions possible for each type
4. Identify the protective MBR in GPT disks

**Commands**:
```bash
sudo parted /dev/sda print
sudo fdisk -l /dev/sda
gdisk -l /dev/sda
hexdump -C /dev/sda | head -20
```

**Deliverable**: Documentation comparing MBR and GPT partition tables with examples from your system.

### Exercise 2.2: Storage Device Scanning
**Objective**: Practice scanning for new storage devices without rebooting

**Tasks**:
1. Simulate adding a new disk (or identify how to trigger rescan)
2. Rescan SCSI devices to detect new disks
3. Rescan NVMe namespaces if applicable
4. Verify new devices appear in the system

**Commands**:
```bash
ls /sys/class/scsi_host/
echo "- - -" | sudo tee /sys/class/scsi_host/host*/scan
lsblk
sudo nvme list
sudo rescan-scsi-bus.sh
```

**Deliverable**: Step-by-step guide for scanning new storage devices with verification steps.

### Exercise 2.3: Partition Planning and Documentation
**Objective**: Plan partition layouts for different use cases

**Tasks**:
1. Document current partition layout including mount points
2. Plan a partition scheme for a web server (/, /var, /home, swap)
3. Calculate appropriate sizes based on disk capacity
4. Consider alignment for optimal performance

**Commands**:
```bash
df -h
cat /etc/fstab
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE
sudo parted /dev/sda unit MB print free
```

**Deliverable**: Partition planning document with recommended layouts for different server types.

## Advanced Level Exercises

### Exercise 3.1: Storage Troubleshooting Scenario
**Objective**: Diagnose and resolve common storage issues

**Tasks**:
1. Create a scenario where a disk shows as read-only
2. Diagnose the issue using system logs
3. Identify filesystem errors and repair procedures
4. Document recovery steps for different failure scenarios

**Commands**:
```bash
dmesg | grep -i error
sudo journalctl -b | grep -i disk
sudo fsck -N /dev/sda1
smartctl -t short /dev/sda
smartctl -a /dev/sda | grep -i fail
```

**Deliverable**: Troubleshooting guide with common storage issues and their resolutions.

### Exercise 3.2: Automation Script for Disk Inventory
**Objective**: Create scripts to automate disk management tasks

**Tasks**:
1. Write a script to inventory all storage devices
2. Include disk health checks using SMART
3. Generate alerts for disks approaching capacity limits
4. Create a report showing partition usage trends

**Script Requirements**:
```bash
#!/bin/bash
# Disk inventory script should include:
# - Device enumeration
# - Size and usage statistics
# - SMART health status
# - Partition table type identification
# - Export to CSV/JSON format
```

**Deliverable**: Complete automation script with documentation and usage examples.

### Exercise 3.3: Performance Analysis and Optimization
**Objective**: Analyze storage performance and implement optimizations

**Tasks**:
1. Benchmark current disk performance using appropriate tools
2. Analyze I/O scheduler settings for different device types
3. Document NVMe vs SATA performance differences
4. Create a performance tuning recommendations document

**Commands**:
```bash
sudo hdparm -Tt /dev/sda
sudo iostat -x 1 5
cat /sys/block/sda/queue/scheduler
lsblk -D
nvme id-ctrl /dev/nvme0n1
```

**Deliverable**: Performance analysis report with optimization recommendations based on your findings.

</details>
</details>