# Section 43: Swap Utilization 

<details open>
<summary><b>Section 43: Swap Utilization (CL-KK-Terminal)</b></summary>

## Table of Contents

1. [Understanding Swap Space](#understanding-swap-space)
2. [Swap Utilization Principles](#swap-utilization-principles)
3. [Swapiness Parameter](#swapiness-parameter)
4. [Creating and Managing Swap Space from Files](#creating-and-managing-swap-space-from-files)
5. [Tuning Swap Utilization](#tuning-swap-utilization)

## Understanding Swap Space

### Overview
Swap space in Linux is a portion of the hard disk designated as virtual memory. When the system's physical RAM (Random Access Memory) becomes full, the kernel transfers less frequently used pages from RAM to this swap space, freeing up RAM for active applications. This mechanism allows systems to handle memory demands that exceed the installed RAM.

### Key Concepts
Swap space acts as an extension of physical memory. The total virtual memory available is the sum of physical RAM and swap space. For example, with 4GB RAM and 4GB swap, the system has 8GB virtual memory.

### Why Swap is Necessary
- **System Requirements Exceed Physical RAM**: When applications demand more memory than available RAM, swap prevents crashes by providing overflow capacity.
- **Startup Page Management**: During system boot, swap stores rarely used pages, ensuring that frequently accessed pages remain in fast RAM.

Note: Swapping involves disk I/O, which is slower than RAM access (nanoseconds vs. milliseconds), potentially reducing system performance.

## Swap Utilization Principles

### How Swap Works
The kernel divides physical RAM into fixed-size chunks called "pages" (typically 4KB). When RAM is low:
- Less used pages are copied to swap space.
- This process, known as paging or swapping, frees RAM for current applications.

To monitor page activities, install the `procps-ng` package and use the `vmstat` command (corrected from transcript's "PTM STATS") to view swap-in/swap-out statistics.

### Commands to View Swap Details
Use the following commands to check swap status:
```bash
free  # Shows memory and swap utilization
cat /proc/swaps  # Lists active swap spaces and their types
```

> [!NOTE]
> Swap spaces are mounted automatically on boot if configured in `/etc/fstab`.

## Swapiness Parameter

### Overview
Swappiness (corrected from transcript's "swapiness") is a kernel parameter introduced in Linux kernel 2.6, allowing administrators to control swap usage aggressiveness. It ranges from 0 to 100:
- Low values (e.g., 10-30): Kernel avoids swapping when possible.
- High values (e.g., 60-100): Kernel swaps more aggressively to keep RAM free.

### Detecting Optimal Swappiness Value
Optimal swappiness depends on system workload and RAM usage. Monitor system performance with incremental changes (e.g., via `vmstat`) and adjust to balance between RAM conservation and speed.

### Viewing and Temporarily Changing Swappiness
Check current value:
```bash
cat /proc/sys/vm/swappiness  # Shows current swappiness (e.g., 60)
```

Temporarily change it:
```bash
echo 30 > /proc/sys/vm/swappiness  # Sets to 30
```

> [!IMPORTANT]
> Changes are not persistent and revert on reboot. For permanence, edit the configuration file below.

### Making Changes Persistent
Edit `/etc/sysctl.conf` (systemctl service configuration file in some systems) or create/replace the file:
```bash
vim /etc/sysctl.conf
# Add this line:
vm.swappiness=30
```

Reload with:
```bash
sysctl -p
```

## Creating and Managing Swap Space from Files

### Creating Swap Files
When disk space is limited or extra disks are unavailable, create a file to use as swap space.

#### Using `fallocate` or `dd`
- Install `fallocate` package if needed: `yum install coreutils` (Red Hat-based systems).
- Create a 1GB file in a directory with ample space (e.g., root partition if free):
```bash
fallocate -l 1G /swapfile  # Preferred method for modern systems
# Alternative using dd:
dd if=/dev/zero of=/swapfile bs=1024 count=1048576  # Creates 1GB file (1024x1048576=1G)
```

#### Set Permissions
On the created file:
```bash
chmod 600 /swapfile  # Restricts to root only for security
```

#### Initialize as Swap
```bash
mkswap /swapfile  # Formats the file as swap space
```

#### Activate Swap
```bash
swapon /swapfile  # Enables the swap file
```

Verify with `free` or `cat /proc/swaps`, which should now show the new swap space.

> [!WARNING]
> Avoid using user-accessible partitions for swap files to prevent unauthorized modifications that could lead to system instability.

### Deactivating and Removing Swap Files
1. Turn off: `swapoff /swapfile`
2. Remove from `/etc/fstab` if persistent.
3. Delete file: `rm /swapfile`

### Making Swap Persistent
Add to `/etc/fstab` for auto-mount on boot:
```
UUID=[UUID from blkid] swap swap defaults 0 0
```
Or by file path (less reliable):
```
/swapfile swap swap defaults 0 0
```

Reload fstab: `mount -a` or reboot.

## Tuning Swap Utilization

### Performance Considerations
- High swappiness can cause frequent swaps, slowing the system due to disk I/O.
- Low swappiness (or 0) may not free RAM when needed, risking out-of-memory errors.
- Balance based on workload: Higher for desktop/games with RAM-hungry apps; lower for servers prioritizing speed.

### Monitoring and Adjustment
- Use `free`, `vmstat`, and `top` to monitor RAM/swap usage.
- Adjust swappiness in small increments and test workloads.
- Default values: Often 60 in older systems, around 30 in newer distributions.

### Common Issues
- **File Not Created as Swap**: Ensure correct commands/syntax; check for package installation.
- **Permission Errors**: Swap files must be root-owned with 600 permissions.
- **High Disk Activity**: Indicates excessive swapping; consider increasing physical RAM or reducing demands.

## Summary

### Key Takeaways
```diff
+ Swap space extends RAM via disk, enabling systems to handle memory overflows.
- Avoid excessive swapping, as disk I/O slows performance compared to RAM.
! Swappiness controls swap aggressiveness; tune based on workload and monitor effects.
```
- Swapping moves "cold" (unused) pages to disk, freeing RAM for "hot" (active) applications.
- Virtual memory = Physical RAM + Swap Size.
- Use files as swap for temporary relief without extra disks.

### Quick Reference
- **View Swap Info**: `free -h` or `cat /proc/swaps`
- **Monitor Page Activity**: Install `procps-ng`; use `vmstat`
- **Create File Swap**: `fallocate -l 1G /swapfile; mkswap /swapfile; swapon /swapfile`
- **Change Swappiness**: `echo <value> > /proc/sys/vm/swappiness`
- **Persist Swappiness**: Edit `/etc/sysctl.conf` with `vm.swappiness=<value>`
- **Deactivate Swap**: `swapoff /swapfile`

### Expert Insight
**Real-world Application**: In production servers, use dedicated partitions for faster swap (SSD over HDD). Monitor with tools like Nagios for memory bottlenecks. For containers (e.g., Docker), ensure host has adequate swap to avoid container crashes.

**Expert Path**: Start with system profiling (e.g., `sar` from `sysstat` package) to understand memory patterns. Experiment with swappiness under load tests. Learn ZSWAP/HyperSwap for compressed swap in newer kernels.

**Common Pitfalls**: Setting swappiness too high leads to thrashing; too low risks OOM kills. Always test swap changes in non-production. Ignore file sizes in `dd` calculations can create unusable swaps (note: 1024 byte blocks, count=1048576 yields 1GB correctly).

</details>
