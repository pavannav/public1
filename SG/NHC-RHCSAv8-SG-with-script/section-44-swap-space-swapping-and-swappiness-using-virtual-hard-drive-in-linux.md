# Section 44: Virtual Hard Disk Management and Swapping

<details open>
<summary><b>Section 44: Virtual Hard Disk Management and Swapping (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Swapping Overview](#swapping-overview)
- [Swappiness Parameter](#swappiness-parameter)
- [Stress Testing with Stress Command](#stress-testing-with-stress-command)
- [Practical Demo of Swappiness Impact](#practical-demo-of-swappiness-impact)
- [Installing and Using Stress Command](#installing-and-using-stress-command)
- [Virtual Hard Disk Creation with dd Command](#virtual-hard-disk-creation-with-dd-command)
- [Formatting the Virtual Disk](#formatting-the-virtual-disk)
- [Mounting and Unmounting Virtual Disk](#mounting-and-unmounting-virtual-disk)
- [Permanent Mounting via /etc/fstab](#permanent-mounting-via-etcfstab)
- [Summary](#summary)

## Swapping Overview

Swapping is a memory management technique where the Linux kernel moves inactive or less-used memory pages from RAM to a designated swap space on the hard disk. This occurs when:

- RAM demand exceeds available physical memory.
- Programs terminate but leave unused memory allocations.
- System needs to prioritize active processes.

The swap process involves:
- **Pages**: Divisions of memory in RAM.
- **Swapping**: Moving pages between RAM and swap space (/dev/sdaX partition).

Pages are copied to swap when RAM fills up, freeing space for new processes. This allows systems to handle more processes than physical RAM alone would support.

## Swappiness Parameter

Stored in `/proc/sys/vm/swappiness`, this parameter controls how aggressively the kernel performs swapping. Values range from 0-100:

- **Higher values** (e.g., 60): More aggressive swapping, increased I/O, potential performance hit.
- **Lower values** (e.g., 10): Less aggressive swapping, better for desktop systems but risk of OOM kills.
- **Default**: Usually 60.

Adjust with:
```bash
echo 30 > /proc/sys/vm/swappiness
```

For permanent changes, edit `/etc/sysctl.conf` or add to `/etc/rc.local`.

## Stress Testing with Stress Command

The `stress` command manually applies load to test system limits, useful for:
- CPU testing
- Memory testing
- I/O testing

Install via EPEL repository:
```bash
dnf install -y epel-release
dnf install -y stress
```

Examples:
- CPU stress: `stress --cpu 1 --timeout 30s`
- Memory stress: `stress --vm 1 --vm-bytes 4G --timeout 30s`
- I/O stress: `stress --io 4 --timeout 30s`

Monitor impact with:
- `uptime` (load average)
- `free -h` (memory/swap usage)
- `vmstat 2` (I/O, processes)

## Practical Demo of Swappiness Impact

1. Check current load and swappiness:
   ```bash
   uptime
   cat /proc/sys/vm/swappiness
   free -h
   ```

2. Generate memory load:
   ```bash
   stress --vm 1 --vm-bytes 4G --timeout 60s
   ```

3. Observe:
   - With high swappiness: Swap usage starts earlier (after ~20-30% RAM usage).
   - With low swappiness: Swap usage starts later (after ~80-90% RAM usage).
   - Use `vmstat 2` to monitor swap activity.

4. Adjust and verify:
   - Set `swappiness=0`: Swap happens minimally.
   - Set `swappiness=60`: More aggressive swapping.

Demonstrates how swappiness controls swap frequency and system I/O patterns.

## Installing and Using Stress Command

Prerequisites: EPEL repo installed.

Commands:
- Install: `yum install stress` (on CentOS/RHEL)
- Usage patterns:
  - CPU: `stress -c 4` (4 cores, infinite)
  - Memory: `stress -m 2 -t 60s` (2 threads, 60 seconds)
  - Combined: `stress -c 2 -m 2 -d 4 -i 3 -t 60s`

Monitor effects on system metrics to understand load distribution.

## Virtual Hard Disk Creation with dd Command

Create a file for virtual disk using `dd`:
```bash
dd if=/dev/zero of=/root/virtual-disk.img bs=1M count=1200
```

Parameters:
- `if`: Input file (source, /dev/zero for zero-filled).
- `of`: Output file path.
- `bs`: Block size (1M for 1MB).
- `count`: Number of blocks (1200 × 1M = 1.2GB).

Verify with `ls -lh /root/virtual-disk.img`.

Security note: Avoid overusing this for production storage.

## Formatting the Virtual Disk

Format as ext4:
```bash
mkfs.ext4 /root/virtual-disk.img
```

Or use:
```bash
mke2fs -t ext4 /root/virtual-disk.img
```

Check file system:
```bash
blkid /root/virtual-disk.img
file /root/virtual-disk.img
```

## Mounting and Unmounting Virtual Disk

1. Create mount point:
   ```bash
   mkdir /mnt/testdata
   ```

2. Mount (loop device):
   ```bash
   mount -o loop /root/virtual-disk.img /mnt/testdata
   ```

3. Verify:
   ```bash
   df -h /mnt/testdata
   ```

4. Unmount:
   ```bash
   umount /mnt/testdata
   ```

Involves using the `loop` device to treat file as block device.

## Permanent Mounting via /etc/fstab

Edit `/etc/fstab`:
```bash
/root/virtual-disk.img  /mnt/testdata  ext4  loop,defaults  0  0
```

- Fields: Device path, mount point, file system, options (loop for file), dump, pass.

Reload:
```bash
mount -a
```

Remains mounted after reboot.

## Summary

### Key Takeaways
- Swapping manages memory overflow efficiently but impacts performance.
- Swappiness fine-tuning balances RAM usage and I/O.
- `stress` enables controlled load testing for stability verification.
- `dd`, `mkfs`, `mount` commands create virtual storage from files.

### Quick Reference
- Check swappiness: `sysctl vm.swappiness`
- Set swappiness: `sysctl -w vm.swappiness=10`
- Create virtual disk: `dd if=/dev/zero of=disk.img bs=1M count=1000`
- Format: `mkfs.ext4 disk.img`
- Mount: `mount -o loop disk.img /mnt/point`
- Unmount: `umount /mnt/point`

### Expert Insight
**Real-world Application**: Use virtual disks for testing partitioned setups, data isolation, or fast prototyping without hardware changes.

**Expert Path**: Master kernel parameters like `vm.dirty_ratio`, combine with LVM for dynamic partitioning. Experiment with compressed swap (zswap) for better performance.

**Common Pitfalls**: High swappiness causes disk thrashing. Always verify loop mounts with `--lazy` option for emergency unmounts. Avoid using virtual disks for critical production data - prefer physical drives.

</details>
