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

<details>
<summary><b>Set-02 Assignment</b></summary>

## Beginner Level Exercises

### Exercise 1.1: Block Device Identification Using Different Methods
**Objective**: Master multiple approaches to identify and classify block devices

**Tasks**:
1. Use `lsblk` with different output formats (tree, list, JSON)
2. Compare output from `/sys/block/` vs `/proc/partitions`
3. Create custom `lsblk` output showing only specific columns
4. Identify removable vs internal storage devices

**Commands**:
```bash
lsblk -J
lsblk -l
lsblk -o NAME,SIZE,TYPE,RM,RO,MOUNTPOINT
cat /sys/block/*/size
for dev in /sys/block/*/; do echo "$dev: $(cat $dev/size 2>/dev/null)"; done
lsblk -d -o NAME,RM,TYPE,SIZE
```

**Deliverable**: Comparison report of different block device identification methods with examples.

### Exercise 1.2: Advanced Disk Metadata Collection
**Objective**: Collect and interpret detailed disk metadata using various tools

**Tasks**:
1. Extract detailed disk information using `udevadm`
2. Parse disk information from `/sys/class/block/`
3. Compare `hdparm` and `smartctl` output for the same device
4. Create a standardized disk information template

**Commands**:
```bash
udevadm info -a -n /dev/sda
cat /sys/class/block/sda/uevent
sudo hdparm -I /dev/sda
sudo smartctl --all /dev/sda
cat /sys/class/block/sda/device/model
cat /sys/class/block/sda/device/rev
```

**Deliverable**: Standardized template for disk metadata collection with sample data.

### Exercise 1.3: Device Path Resolution and Persistence
**Objective**: Understand persistent device naming and path resolution

**Tasks**:
1. Map all persistent device names to their current `/dev` names
2. Analyze udev rules affecting device naming
3. Create custom udev rules for consistent naming
4. Test device name persistence across reboots (in a VM)

**Commands**:
```bash
find /dev/disk -type l -exec ls -la {} \;
udevadm test /sys/class/block/sda 2>&1 | grep ID_
cat /etc/udev/rules.d/70-persistent-net.rules 2>/dev/null || echo "No custom rules"
udevadm trigger --verbose --dry-run
```

**Deliverable**: Documentation of device path mappings and a custom udev rule example.

## Intermediate Level Exercises

### Exercise 2.1: Partition Table Conversion Planning
**Objective**: Plan and understand MBR to GPT conversion processes

**Tasks**:
1. Create a backup strategy for MBR to GPT conversion
2. Document the conversion process using `gdisk`
3. Identify potential issues and their resolutions
4. Plan rollback procedures

**Commands**:
```bash
sudo gdisk /dev/sda
# Interactive commands: r (recovery), g (convert MBR to GPT)
sudo sgdisk --backup=table-backup.bin /dev/sda
sudo sgdisk --load-backup=table-backup.bin /dev/sda
sudo gdisk -l /dev/sda | grep -E "GPT|MBR|protective"
```

**Deliverable**: Step-by-step conversion guide with safety checks and rollback procedures.

### Exercise 2.2: Multi-Path Storage Device Management
**Objective**: Configure and manage devices with multiple access paths

**Tasks**:
1. Identify multipath devices if configured
2. Configure device-mapper-multipath for test devices
3. Create multipath configuration for specific WWIDs
4. Test failover scenarios

**Commands**:
```bash
sudo multipath -ll
cat /etc/multipath.conf
sudo multipath -a 36001405xxxxxxxxxxxxxxx
sudo multipathd show paths
echo "multipath { wwids { /.*xxx.*/ } }" | sudo tee -a /etc/multipath.conf
```

**Deliverable**: Multipath configuration guide with device mapping examples.

### Exercise 2.3: Advanced Partition Alignment Strategies
**Objective**: Implement optimal partition alignment for different workloads

**Tasks**:
1. Calculate optimal starting sectors for different RAID configurations
2. Align partitions for SSDs with different page sizes
3. Create aligned partitions using `parted` with exact values
4. Verify alignment using `blockdev` and filesystem tools

**Commands**:
```bash
sudo parted /dev/sda mkpart primary ext4 2048s 50%
sudo blockdev --getalignoff /dev/sda1
sudo parted /dev/sda align-check optimal 1
cat /sys/block/sda/queue/physical_block_size
cat /sys/block/sda/queue/logical_block_size
```

**Deliverable**: Alignment calculation worksheet with verified optimal configurations.

## Advanced Level Exercises

### Exercise 3.1: Storage Stack Deep Dive and Debugging
**Objective**: Debug complex storage stack issues using kernel tracing

**Tasks**:
1. Enable block layer tracing to monitor I/O patterns
2. Analyze blktrace output for performance bottlenecks
3. Trace device-mapper operations
4. Create custom debug scripts for storage issues

**Commands**:
```bash
sudo blktrace -d /dev/sda -w 30 -o trace
blkparse trace
sudo btrace /dev/sda
echo 1 | sudo tee /sys/block/sda/trace/enable
cat /sys/block/sda/trace/enable
dmsetup table
dmsetup status
```

**Deliverable**: Storage debugging toolkit with custom trace analysis scripts.

### Exercise 3.2: Storage Virtualization with LVM Thin Provisioning
**Objective**: Implement advanced storage virtualization using LVM

**Tasks**:
1. Create thin-provisioned logical volumes
2. Configure thin pool monitoring and auto-extension
3. Implement snapshot strategies for backup
4. Create automated thin pool management scripts

**Commands**:
```bash
sudo lvcreate --type thin-pool -L 100G -n thin_pool vg01
sudo lvcreate --type thin -V 500G -T vg01/thin_pool -n virtual_lv
sudo lvs --segments -o +seg_monitor
sudo lvextend --use-policies vg01/thin_pool
sudo lvs -o +seg_monitor,kernel_read_ahead
```

**Deliverable**: LVM thin provisioning deployment guide with monitoring automation.

### Exercise 3.3: Enterprise Storage Performance Benchmarking Framework
**Objective**: Create comprehensive storage performance testing framework

**Tasks**:
1. Design benchmark scenarios for different workloads (random/sequential, read/write)
2. Implement automated benchmark execution with fio
3. Create performance baseline documentation
4. Generate capacity planning recommendations based on benchmarks

**Commands**:
```bash
sudo fio --name=randread --ioengine=libaio --iodepth=32 --rw=randread --bs=4k --direct=1 --size=10G --numjobs=4 --runtime=300 --group_reporting
sudo fio --name=seqwrite --ioengine=libaio --iodepth=32 --rw=write --bs=1M --direct=1 --size=100G --numjobs=1 --runtime=300
iotop -o -d 1
iostat -xzm 1
```

**Deliverable**: Complete benchmarking framework with workload profiles, automation scripts, and reporting templates.

</details>
</details>