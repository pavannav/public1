# Section 60: Kernel Management in RHEL 8 

<details open>
<summary><b>Section 60: Kernel Management in RHEL 8 (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction](#introduction)
- [Recovering Deleted Kernel Files Using Rescue Mode](#recovering-deleted-kernel-files-using-rescue-mode)
- [Installing Kernel Version 5.16 on RHEL 8](#installing-kernel-version-516-on-rhel-8)
- [Setting the Default Kernel](#setting-the-default-kernel)
- [Changing GRUB Timeout Settings](#changing-grub-timeout-settings)
- [Summary](#summary)

## Introduction
This section covers advanced kernel management tasks in RHEL 8, including emergency recovery of deleted kernel files, installing newer kernel versions, configure default boot settings, and modifying GRUB timeout parameters. These operations are critical for maintaining system stability and performance, particularly in production environments where kernel corruption or updates can impact service availability.

## Recovering Deleted Kernel Files Using Rescue Mode
When kernel files are accidentally deleted, recovery can be performed using the system's ISO image and Rescue mode. This process involves booting the system from a bootable USB or DVD with the RHEL 8 ISO attached.

### Steps to Recover Kernel Files
1. Boot the system and attach the RHEL 8 ISO as a virtual CD/DVD.
2. Interrupt the boot process (e.g., press any key for RHEL 8 startup menu).
3. Select "Troubleshooting" > "Rescue a Red Hat Enterprise Linux system".
4. Choose rescue options:
   - Skip to shell (default emergency mode).
   - Mount filesystems read-write if dropped into emergency mode.
5. Mount the system partitions manually if needed:
   ```bash
   mkdir /mnt/sysimage
   mount /dev/vda1 /mnt/sysimage  # Adjust device as per your setup
   ```
6. Change to the rescue environment to access the kernel core packages from the ISO repositories.
7. Use RPM to reinstall kernel core:
   ```bash
   rpm -ivh --nodeps /path/to/kernel-core-*.rpm
   ```
8. Reboot the system and relabel SELinux contexts if necessary using `restorecon` or full relabeling for filesystem integrity.

### Key Commands
```bash
# Restart systemd service after rescue
systemctl restart systemd
# Relabel SELinux contexts
restorecon -R /
```

If the system fails to boot after recovery, verify the newly installed kernel images are correctly placed in `/boot` and regenerate GRUB configuration.

## Installing Kernel Version 5.16 on RHEL 8
RHEL 8 comes with kernel 4.18 by default. To install kernel 5.16, add the AlmaLinux or alternative repository containing newer kernel packages.

### Steps to Install New Kernel Version
1. Add the external repository using DNF:
   ```bash
   dnf config-manager --add-repo https://almalinux.org/kernels/el8-x86_64/
   ```
2. Enable the repository and disable others if needed:
   ```bash
   dnf config-manager --set-enabled almalinux-kernels-el8-x86_64
   dnf config-manager --disable baseos appstream
   ```
3. Install the kernel package:
   ```bash
   dnf install kernel-ml-5.16 -y
   ```
4. Verify installation by listing boot entries:
   ```bash
   ls /boot | grep vmlinuz
   ```
5. Reboot and select the new kernel from GRUB menu if not set as default.

> [!IMPORTANT]
> Ensure the system has adequate disk space in `/boot` (typically 1GB is sufficient). Backup existing kernels before upgrading.

## Setting the Default Kernel
After installing multiple kernels, configure GRUB to boot the desired version by default.

### Steps to Set Default Kernel
1. Edit the GRUB default file:
   ```bash
   vi /etc/default/grub
   ```
2. Modify the `GRUB_DEFAULT` parameter (0 for first entry, 1 for second, etc.):
   ```bash
   GRUB_DEFAULT=0  # Set to the index of your preferred kernel
   ```
3. Regenerate GRUB configuration:
   ```bash
   grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg  # For UEFI systems
   # Or for legacy BIOS:
   grub2-mkconfig -o /boot/grub2/grub.cfg
   ```
4. Reboot to verify the default kernel is selected.

> [!NOTE]
> Use `grub2-set-default` command for runtime changes, but permanent settings require editing `/etc/default/grub`.

## Changing GRUB Timeout Settings
Adjust the GRUB menu timeout to control how long the system waits for user input before booting the default kernel.

### Steps to Modify GRUB Timeout
1. Edit the GRUB configuration file:
   ```bash
   vi /etc/default/grub
   ```
2. Update the `GRUB_TIMEOUT` parameter:
   ```bash
   GRUB_TIMEOUT=5  # Set to desired seconds (e.g., 5 for 5 seconds)
   ```
3. Regenerate GRUB configuration:
   ```bash
   grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
   ```
4. Reboot to apply changes.

The default timeout is typically 5 seconds, but increase it for quicker boots or decrease for more interactive control.

### Troubleshooting
- If changes don't take effect, verify `/etc/default/grub` syntax.
- For UEFI systems, ensure correct EFI boot path.
- Clear NVRAM settings if dual-booting with Windows.

## Summary

### Key Takeaways
```diff
+ Kernel recovery via Rescue mode ensures system restoration from corrupted or deleted files.
+ Enable external repositories (e.g., AlmaLinux kernels) for installing newer kernel versions not available in base RHEL repositories.
+ Use GRUB_DEFAULT and GRUB_TIMEOUT in /etc/default/grub to control default kernel and boot timeout.
+ Always back up existing kernels before upgrades to prevent boot failures.
- Avoid deleting kernel packages without alternatives installed, as this can render the system unbootable.
! Always verify kernel installation with ls /boot and test boots before removing old kernels.
💡 Regular kernel updates improve security and performance; schedule them during maintenance windows.
⚠ Skipping SELinux relabeling after rescues can lead to permission errors and service failures.
```

### Quick Reference
- **Check current kernel**: `uname -r`
- **List available kernels**: `rpm -qa kernel*`
- **Set default kernel via command**: `grub2-set-default 0`
- **Regenerate GRUB**: `grub2-mkconfig -o /boot/grub2/grub.cfg`
- **Mount rescue filesystem**: `mount /dev/sdXn /mnt/sysimage`
- **Reinstall kernel**: `rpm -ivh --nodeps kernel-core.rpm`

### Expert Insight
**Real-world Application**: In enterprise environments with multiple servers, automate kernel updates using Ansible or Satellite. For high-availability clusters, enable kdump and crash kernel configurations to capture crash dumps for post-mortem analysis.

**Expert Path**: Master kernel tuning by exploring `/proc/sys/kernel` parameters and compiling custom kernels. Study upstream Linux Kernel mailing lists for security patches and features.

**Common Pitfalls**: Neglecting to update initramfs after kernel changes can cause boot failures. Overwriting exclusive repositories may conflict with system package management, leading to dependency issues. Ensure consistent kernel versions across cluster nodes to avoid downtime during migrations.

</details>
