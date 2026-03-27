<details open>
<summary><b>Section 59: Recovering Corrupted or Deleted Kernel Files (CL-KK-Terminal)</b></summary>

## Section 59: Recovering Corrupted or Deleted Kernel Files

## Table of Contents

- [Introduction](#introduction)
- [Understanding Kernel Images in RHEL 8](#understanding-kernel-images-in-rhel-8)
- [Simulating Kernel File Corruption or Deletion](#simulating-kernel-file-corruption-or-deletion)
- [Recovery Using Rescue Kernel](#recovery-using-rescue-kernel)
- [Full Recovery Using Live ISO Image](#full-recovery-using-live-iso-image)
- [Verifying Recovery and Final Steps](#verifying-recovery-and-final-steps)

## Introduction

In this session, you will learn how to recover corrupted or deleted kernel image files (vmlinuz) and related boot files in RHEL 8. This includes scenarios where one or both kernel images are affected, preventing normal boot. We'll cover methods using the rescue kernel when available and fallback to live ISO booting for complete recovery.

## Understanding Kernel Images in RHEL 8

RHEL 8's `/boot` directory contains kernel image files, typically two:
- Normal kernel image (e.g., `vmlinuz-4.18.0-553.el8_10.x86_64`) for standard boot.
- Rescue kernel image (e.g., `vmlinuz-0-rescue-xxx`) for recovery.

```bash
ls /boot
```

Output example:
```
vmlinuz-4.18.0-553.el8_10.x86_64  # Normal kernel
vmlinuz-0-rescue-fbd30c061ae9444e9edb62dd6d0c8b91  # Rescue kernel
```

If one kernel image is corrupted or deleted, use the other to boot. If both are affected, recovery requires mounting the installation ISO and reinstalling kernel packages.

## Simulating Kernel File Corruption or Deletion

To demonstrate recovery, simulate the issue by deleting kernel files from `/boot`.

```bash
# Access GRUB menu, select entry to boot into system
# In terminal:
cd /boot
rm -f vmlinuz-4.18.0-553.el8_10.x86_64  # Delete normal kernel
```

If you try to reboot, the system will attempt to boot the first kernel but fail with "Unable to load kernel" or similar errors.

Next, attempt boot with the second (rescue) kernel. If successful, proceed to recovery.

If both are deleted, boot fails entirely, requiring live ISO recovery.

## Recovery Using Rescue Kernel

If the rescue kernel remains intact, boot into it from GRUB.

1. Select the rescue kernel entry in GRUB.
2. Boot into the system.

The system should now be running from the rescue kernel.

Locate the installation ISO (assumed mounted or accessible via network).

```bash
mount /dev/cdrom /mnt  # Or path to ISO
cd /mnt/BaseOS/Packages
```

Find and install the kernel-core package:

```bash
yum install kernel-core-*
```

This may reinstall the kernel package, regenerating `/boot` files.

Or, use RPM directly:

```bash
rpm -ivh kernel-core-xxx.rpm --root /mnt --replacepkgs --replacefiles
```

After installation, verify `/boot` contents:

```bash
ls /boot | grep vmlinuz
```

The normal kernel image should be recreated.

## Full Recovery Using Live ISO Image

If both kernel images are corrupted/deleted, boot from live ISO.

1. Power off the system.
2. Enter BIOS (e.g., Del or F2 key) and configure boot priority: Set CD-ROM to highest priority.

Boot from the RHEL 8 ISO.

In the installation menu:
- Select "Troubleshooting"
- Then "Rescue a Red Hat Enterprise Linux system"

Choose the affected system root partition to mount it read-only.

Enter shell prompt:

```bash
chroot /mnt # Assuming root partition mounted at /mnt

# Navigate to packages in ISO
mount /dev/cdrom /media
cd /media/BaseOS/Packages

# Install kernel-core via yum or rpm
yum install kernel-core --installroot=/mnt

# Or via rpm
rpm -ivh kernel-core-*.rpm --root=/mnt --replacepkgs --replacefiles
```

After installation, the kernel files should appear in `/mnt/boot` (chroot-ed path).

Create bootloader entries if needed:

```bash
grub2-mkconfig -o /mnt/boot/efi/EFI/redhat/grub.cfg  # For UEFI
# Or for legacy: grub2-mkconfig -o /mnt/boot/grub2/grub.cfg
```

Exit chroot and reboot:

```bash
exit
reboot
```

Change BIOS boot priority back to HDD/SSD.

After reboot, the system should boot normally with recreated kernel images.

## Verifying Recovery and Final Steps

After recovery:

1. Boot into the system (normal mode).
2. Check `/boot` directory:

```bash
ls /boot
```

Both kernel images should be present.

Ensure labeling for root filesystem:

```bash
xfs_admin -L "ROOT" /dev/sdaX  # Adjust device; use tune2fs for ext4
```

Run full relabeling if needed:

```bash
touch /.autorelabel  # Forces SELinux relabel on next boot
```

Reboot once more to apply changes.

## Summary

### Key Takeaways

```diff
+ Kernel images are critical for boot; always have backups or keep rescue kernel intact.
- Never delete both kernel files without access to live media.
+ Use rescue kernel first for quick recovery.
+ Live ISO mounting is the fallback for complete kernel package reinstall.
```

### Quick Reference

- **GRUB Menu**: Select rescue kernel to boot damaged system.
- **Mount ISO**: `mount /dev/cdrom /mnt; cd /mnt/BaseOS/Packages`
- **Reinstall Kernel**: `yum install kernel-core` or `rpm -ivh --root /mnt`
- **SELinux Relabel**: `touch /.autorelabel` before reboot.

### Expert Insight

**Real-world Application**: In production RHEL environments, maintain multiple kernel versions and test boot configurations. Use automation (e.g., Ansible) to reinstall packages from ISO mounts during recovery.

**Expert Path**: Master GRUB configuration and understand RAID/md or LVM setups where boot failures occur. Practice recovery in virtual environments before applying to physical systems.

**Common Pitfalls**: Forgetting to adjust BIOS boot order back to disk after ISO recovery; not verifying SELinux contexts post-recovery; deleting system-configured grub files without backups.

</details>
