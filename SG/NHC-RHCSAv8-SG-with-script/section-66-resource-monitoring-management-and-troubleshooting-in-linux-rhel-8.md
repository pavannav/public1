# Section 66: System Resources Monitoring, Management, and Troubleshooting 

<details open>
<summary><b>Section 66: System Resources Monitoring, Management, and Troubleshooting (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to System Resources](#introduction-to-system-resources)
- [Monitoring CPU Usage](#monitoring-cpu-usage)
- [Monitoring Memory Usage](#monitoring-memory-usage)
- [Monitoring Disk I/O](#monitoring-disk-i-o)
- [Process Monitoring and Management](#process-monitoring-and-management)
- [Troubleshooting with Chroot](#troubleshooting-with-chroot)
- [Summary](#summary)

## Introduction to System Resources
### Overview
System resources refer to the hardware components utilized by servers to deliver services, including the number of CPUs used, network capabilities, available memory, and storage optimization. Effective monitoring ensures resources are allocated appropriately, preventing issues like insufficient memory causing performance degradation or over-provisioning leading to wasted resources. Monitoring is essential for management and troubleshooting when problems arise. Key resources include CPU utilization, memory (RAM and swap), network bandwidth, and disk storage. The goal is to achieve optimal performance by matching resource usage to system needs.

## Monitoring CPU Usage
### Overview
CPU monitoring tracks how processors are utilized, including idle time and performance metrics. Tools like `top`, `mpstat`, and `sar` provide real-time and historical data.

### Key Concepts
- **`top` Command**: Displays real-time process information, including CPU usage, memory, and running processes. Features include:
  - Press `k` followed by PID to kill processes.
  - Press `n` for NIC (nice) value adjustment.
  - Supports interactive killing with `k`.
  - Use `top -p <PID>` for monitoring specific processes.
- **`mpstat` Command**: Provides multiprocessor statistics. After installing `sysstat` package, use:
  - `mpstat` for overall CPU usage.
  - `mpstat -P ALL` to view each core's usage individually.
- **`sar` Command**: System activity reporter, requiring `sysstat` installation.
  - `sar <interval> <count>` (e.g., `sar 2 3`) for CPU statistics.
  - `sar -u` for CPU utilization report.
  - Supports options like `-n` for network.

### Code/Config Blocks
```bash
# Install sysstat if needed
sudo yum install sysstat  # For RPM-based systems
sudo apt install sysstat  # For Debian-based systems (adjust as per OS)

# Real-time monitoring with top
top

# Monitor specific process
top -p 1234

# CPU stats per core
mpstat -P ALL

# SAR with interval
sar 2 5  # Every 2 seconds for 5 counts
```

### Lab Demos
To monitor CPU in a lab environment:
1. Run `top` to view live stats.
2. Identify high-usage processes, e.g., a process consuming >80% CPU.
3. Kill it via top interface: Press `k`, enter PID, confirm kill.

## Monitoring Memory Usage
### Overview
Memory monitoring focuses on RAM and swap usage to ensure applications have adequate memory without excessive paging.

### Key Concepts
- **`free` Command**: Shows memory and swap details.
  - Options: `-h` for human-readable, `-g` for gigabytes, `-m` for megabytes.
  - Real-time updates: `free -s <seconds>` (e.g., `watch free -h` for periodic updates).
- **`watch` Command**: Repeats a command periodically (e.g., `watch -n 3 free -h`).
- Memory includes total, used, free, shared, buffers/cache. Swap tracks virtual memory.

### Tables
| Metric | Description |
|--------|-------------|
| Total | Total available memory |
| Used | Memory currently in use |
| Free | Unused memory |
| Shared | Memory shared among processes |
| Buff/Cache | Buffered/cache memory |
| Available | Memory available for new processes |

### Lab Demos
1. Run `free -h` to view memory stats.
2. Simulate with `watch -n 3 free -m` for updates every 3 seconds.

## Monitoring Disk I/O
### Overview
Disk I/O monitoring tracks read/write operations and performance to optimize storage bottlenecks.

### Key Concepts
- **`iostat` Command**: Requires `sysstat` package. Shows device utilization:
  - `-c`: CPU only; `-d`: Disk only; `-x`: Extended statistics.
  - Specific devices: `iostat -d /dev/sda`.
  - Interval mode: `iostat 3 4` for every 3 seconds, 4 times.
- Metrics: `%util` (utilization percentage), `r/s` (reads per second), `w/s` (writes per second).

> [!NOTE]
> High I/O wait can indicate disk bottlenecks.

### Code/Config Blocks
```bash
# Install sysstat
sudo yum install sysstat

# Disk I/O stats
iostat -d  # Disk devices

# Extended with interval
iostat -x 2 3
```

## Process Monitoring and Management
### Overview
Process monitoring identifies open files, running services, and associated resources for security and performance.

### Key Concepts
- **`lsof` Command**: Lists open files and processes.
  - `lsof` for all; `lsof -p <PID>` for specific process.
  - By user: `lsof -u <user>`; By port: `lsof -i :<port>` (e.g., `-i :22` for SSH).
  - Export: `lsof > open_files.txt`.
- **`fuser` Command**: Manages processes associated with filesystems.
  - `fuser -c /mnt/data` to check file usage.
  - Kill processes: `fuser -k <mount_point>`.
  - By user: `fuser -u <filesystem>`; Identify processes: `fuser -v <filesystem>`.
- **Filesystem Identification**: `findmnt` or `blkid` to locate devices.

### Lab Demos
1. Create a test filesystem: `mkfs.ext4 /dev/sdb1`, mount it: `mount /dev/sdb1 /mnt/test`.
2. Open a file in it without saving, then use `jobs` or `lsof` to find open files.
3. Use `lsof -u <user>` to list user's open files.
4. Kill: `fuser -k /mnt/test`.

> [!IMPORTANT]
> Ensure proper permissions when accessing user-specific data.

## Troubleshooting with Chroot
### Overview
Chroot creates a controlled environment to access a system's filesystem as if booted directly, useful for repairs when a system won't boot.

### Key Concepts
- **Chroot Setup**: Requires activating LVM, mounting root filesystem.
  - Scan volumes: `vgscan`, activate: `vgchange -a y <vg_name>`.
  - Mount root: `mount /dev/mapper/<vg>-<lv> /mnt/root`.
- **Change Root**: `chroot /mnt/root` to enter the environment.
  - Now access the filesystem directly for fixes (e.g., edit configs, reset passwords).
  - Exit and unmount when done.

> [!WARNING]
> Chroot hides external access; use full paths if needed when exiting.

### Code/Config Blocks
```bash
# Activate LVM
vgscan
vgchange -a y myvg

# Mount root filesystem
mount /dev/mapper/myvg-root /mnt/root

# Enter chroot
chroot /mnt/root
# Now in chroot environment

# Commands like passwd work here, then exit
exit

# Unmount
umount /mnt/root
```

### Lab Demos
Boot from ISO, rescue mode: Access GRUB, Troubleshoot > Rescue System.
- Mount partitions, activate LVM, run `chroot` to reset root password or edit configs.

## Summary
> [!IMPORTANT]
> Understanding resource monitoring and troubleshooting with tools like `top`, `free`, `iostat`, `lsof`, `fuser`, and `chroot` is crucial for maintaining server performance and resolving issues in production.

```diff
+ Key Takeaways: Monitoring CPU, memory, disk, and processes prevents bottlenecks; `chroot` enables offline filesystem access for repairs.
- Common Pitfalls: Over-provisioning wastes resources; failing to monitor can lead to unnoticed performance degradation.
! Alert: Always back up before using killing commands like `fuser -k`.
```

### Quick Reference
- CPU: `top`, `mpstat`
- Memory: `free -h`, `watch free`
- Disk I/O: `iostat -x`
- Processes: `lsof -u <user>`, `fuser -v <filesystem>`
- Troubleshooting: `vgchange -a y`, `chroot /mnt/root`

### Expert Insight
**Real-world Application**: In production, set up automated monitoring with tools like Nagios or Prometheus using scripts based on `sar` data, integrating with alerting for immediate response.  
**Expert Path**: Master combining these tools in scripts (e.g., bash loops) for custom dashboards; explore kernel module diagnostics for advanced troubleshooting.  
**Common Pitfalls**: Incorrectly killing processes can cause data loss; ensure proper permissions and backups before chroot operations.

</details>
