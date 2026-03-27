# Section 58: Kernel Panic and Initramfs Recovery

<details open>
<summary><b>Section 58: Kernel Panic and Initramfs Recovery (CL-KK-Terminal)</b></summary>

## Introduction

This session covers kernel panic errors and initramfs (initial ram filesystem) management in Linux RHEL 8. The instructor demonstrates practical scenarios where initramfs corruption leads to kernel panic, and provides step-by-step recovery procedures using rescue kernels and ISO boot methods.

## Key Concepts

### Understanding Initramfs
Initramfs serves as a temporary root filesystem loaded into memory during boot time. It provides essential kernel modules and drivers needed to access the actual root filesystem. The initramfs contains:

- Driver modules for hardware recognition
- Kernel modules for device initialization 
- Essential tools for mounting the real filesystem

### Kernel Panic Causes
Kernel panic occurs when the kernel cannot continue execution due to critical errors. Common causes include:

- **Corrupted initramfs**: Prevents hardware initialization
- **Incompatible hardware**: Drivers not available or mismatched kernel version
- **Filesystem corruption**: Unable to mount root partition
- **Hardware failures**: Disk controller issues or memory problems

### GRUB Bootloader Configuration
The GRUB configuration files determine how and which kernel loads:

- `/boot/grub2/grub.cfg`: Automatically generated configuration
- `/etc/grub.d/`: Contains scripts for menu generation
- Key parameters configured via `grub2-mkconfig`

## Kernel Panic Scenarios

### Scenario 1: Initramfs Corruption
If `/boot/initramfs-[kernel-version].img` is corrupted or deleted:

1. System fails to mount root filesystem
2. Hardware devices remain unavailable
3. Kernel panic message displays: `kernel panic not syncing vfs unable to mount root fs`

**Recovery Process:**
- Boot into rescue kernel (second menu option in GRUB)
- The rescue kernel loads its own initramfs with required drivers
- Access root filesystem in read-write mode
- Regenerate corrupted initramfs using `dracut` command

### Scenario 2: GRUB Configuration Issues
If both main initramfs and GRUB configuration are corrupted:

1. No GRUB menu appears on boot
2. Cannot select rescue or normal kernel options

**Recovery Process:**
- Boot from installation ISO
- Mount system partitions in rescue mode
- chroot to system environment
- Restore GRUB configuration and initramfs files

## Practical Commands

### Initramfs Creation/Recovery
```bash
# Regenerate initramfs using dracut
dracut -f /boot/initramfs-[kernel-version]-rescue.img [kernel-version]

# Using mkinitrd
mkinitrd /boot/initramfs-[kernel-version].img [kernel-version]

# Force recreate corrupted file
dracut --force /boot/initramfs-[kernel-version].img [kernel-version]
```

### GRUB Management
```bash
# Generate GRUB configuration
grub2-mkconfig -o /boot/grub2/grub.cfg

# Install GRUB to disk
grub2-install [device]

# Update GRUB settings without menu customization
grub2-mkconfig
```

### System Rescue Procedures
```bash
# Check currently mounted filesystems
df -h

# Mount system in rescue mode
mount | grep /dev

# Access GRUB configuration location
cd /boot/grub2

# Relabel SELinux contexts (required after rescue operations)
touch /.autorelabel

# Exit rescue shell
exit
```

## ISO-Based System Rescue

When complete initramfs/GRUB corruption occurs:

1. **Prepare bootable ISO**: Use installation media
2. **Change BIOS boot order**: Prioritize CD/DVD or USB
3. **Enter rescue mode**: Select "Troubleshoot" > "Rescue system"
4. **Mount system partitions**: Access filesystem for repairs
5. **Chroot environment**: Execute commands on actual system
6. **Regenerate configurations**: Rebuild initramfs and GRUB
7. **Restore boot order**: Return to normal HDD boot priority

### Chroot Sequence for ISO Rescue
```bash
# Verify mounted partitions
lsblk

# Chroot to system (example for /dev/sda2)
mount /dev/sda2 /mnt/sysimage
cd /mnt/sysimage
chroot /mnt/sysimage

# Now execute recovery commands on actual system
grub2-mkconfig -o /boot/grub2/grub.cfg
dracut --force /boot/initramfs-[version].img
touch /.autorelabel
```

## Troubleshooting Tips

### Common Error Patterns
- **Filesystem not mounting**: Check `lsblk` output and mount commands
- **GRUB not displaying**: Verify `/boot/efi` structure (UEFI systems)
- **Initramfs recreation fails**: Confirm kernel version and module availability

### Verification Steps
```bash
# Verify kernel version
uname -r

# Check initramfs contents
lsinitrd /boot/initramfs-[version].img

# Test GRUB configuration
grub2-mkconfig
```

### Alternative Rescue Methods
- **Network boot** using PXE for enterprise environments
- **USB live systems** with persistent storage
- **Alternative bootloaders** like systemd-boot for simpler recovery

## Summary

| Component | Normal Function | Failure Symptoms | Recovery Method |
|-----------|----------------|------------------|-----------------|
| Initramfs | Hardware init | Kernel panic, hardware failure | dracut regeneration |
| GRUB Config | Boot loader | No menu, boot failure | grub2-mkconfig |
| Rescue Kernel | Emergency boot | N/A | Select in GRUB menu |
| ISO Rescue | Complete recovery | Total inaccessibility | Full system repair |

## Key Takeaways
```diff
+ Initramfs provides essential drivers for hardware recognition during boot
+ Kernel panic indicates critical system initialization failure
+ Rescue kernel allows access when main initramfs is corrupted
+ ISO-based rescue offers complete system recovery capabilities
+ GRUB configuration must be regenerated after manual changes
- Never edit grub.cfg directly; use grub2-mkconfig tool
- Ensure correct kernel version when regenerating initramfs
! Backup critical files including initramfs and GRUB configurations
```

## Quick Reference

**Common Commands:**
- Regenerate initramfs: `dracut --force [output] [kernel-version]`
- Update GRUB: `grub2-mkconfig -o /boot/grub2/grub.cfg`
- Rescue mode entry: BIOS boot menu → CD/USB priority
- SELinux relabel: `touch /.autorelabel`

## Expert Insights
**Real-world Application:** Initramfs corruption commonly occurs during kernel updates or hardware changes. Enterprise systems should maintain multiple kernel versions and automated backups of boot-critical files.

**Expert Path:** Study kernel module dependencies and udev rules to troubleshoot complex hardware recognition issues. Learn `systemd-boot` and other alternative bootloaders for modern UEFI systems.

**Common Pitfalls:**
- ❌ Forcing boot with incorrect kernel modules causes further corruption
- ❌ Skipping SELinux relabeling leads to system malfunction post-recovery
- ❌ Not verifying hardware compatibility before kernel updates
- ❌ Using outdated rescue tools instead of current distro-specific commands

</details>
