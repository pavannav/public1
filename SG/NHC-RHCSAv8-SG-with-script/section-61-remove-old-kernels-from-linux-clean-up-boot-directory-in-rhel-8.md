<details open>
<summary><b>Section 61: Removing Old Kernels and Freeing Up /boot Space (CL-KK-Terminal)</b></summary>

# Section 61: Removing Old Kernels and Freeing Up /boot Space

## Table of Contents
- [Overview](#overview)
- [Patching the System and Enabling Repositories](#patching-the-system-and-enabling-repositories)
- [Rebooting the System After Updates](#rebooting-the-system-after-updates)
- [Identifying Installed Kernels](#identifying-installed-kernels)
- [Checking /boot Partition Size](#checking-boot-partition-size)
- [Removing Old Kernels](#removing-old-kernels)
- [Verification and Best Practices](#verification-and-best-practices)
- [Summary](#summary)

## Overview {#overview}
This section covers how to remove old, unused kernels from a Red Hat-based system (like CentOS or RHEL) to free up space in the `/boot` partition. When systems are updated over time, multiple kernel versions can accumulate, consuming storage space. We'll explore identifying, safely removing, and verifying old kernels without disrupting the system's boot process. The session emphasizes practical steps to maintain system cleanliness, especially in environments where space is limited, while ensuring you keep at least the most recent kernels for rollback purposes.

## Patching the System and Enabling Repositories {#patching-the-system-and-enabling-repositories}

### Overview
Before removing kernels, it's essential to update the system to its latest state. This ensures all packages, including kernel-related ones, are synchronized. The process uses `dnf` commands to handle repositories and updates, requiring active subscriptions or local repositories for access to package data.

### Key Concepts and Deep Dive
- **Repositories and Subscriptions**: Access to updates depends on Red Hat subscriptions or local mirror setups (e.g., via Satellite). Free alternatives like CentOS Stream work without subscriptions for evaluation.
- **Update Process Flow**: Run `dnf update` to fetch and install patches. This can take time based on internet speed and the number of packages (often 500+).
- **Post-Update Reboot**: Always reboot after major updates, especially those involving kernels, to apply changes. This prevents inconsistencies like corrupted files or unreachable state.

### Lab Demo: Running System Updates
1. Ensure repositories are enabled:
   ```
   sudo dnf check-update
   ```
   This command lists available updates without installing them.

2. Perform the update:
   ```
   sudo dnf update
   ```
   - Downloads and installs packages.
   - May prompt for confirmation; type 'y' to proceed.
   - Monitor the process: It shows package counts, sizes, and progress.

3. Enable automatic updates (optional):
   ```
   sudo dnf install dnf-automatic
   sudo systemctl enable --now dnf-automatic.timer
   ```
   This prevents repeated manual updates in production.

> [!NOTE]  
> Updates can take significant time; patience is key. If the system lacks repositories, install subscription-manager or use developer subscriptions (3-month free trial for evaluation).

> [!IMPORTANT]  
> Never run `dnf update` without a backup plan. Test updates in VMs first.

## Rebooting the System After Updates {#rebooting-the-system-after-updates}

### Overview
Post-update reboots are mandatory in Linux to activate kernel changes. The session demonstrates booting into the new kernel and handling potential issues like network unreachability or service failures.

### Key Concepts and Deep Dive
- **Boot Process**: GRUB menu lists available kernels. Select the latest (highest version number) to boot.
- **Troubleshooting Post-Reboot**: If unreachable, use console access (e.g., ILOM for physical servers) or GRUB recovery mode to fall back to old kernels.
- **Hidden Risks**: Corruption in `/boot` or configuration files (e.g., fstab) can cause boot loops. Always backup critical data like mount points and service states.

### Lab Demo: Rebooting and Selecting Kernels
1. Reboot the system:
   ```
   sudo reboot
   ```
   - Graceful shutdown takes 1-2 minutes.
   - Watch for kernel options in GRUB menu (press ESC during boot if hidden).

2. Select kernel in GRUB:
   - Navigate to GRUB menu (appears briefly).
   - Choose the entry with the latest kernel version (e.g., `4.18.0-305` over `4.18.0-358`).
   - Press Enter to boot.

3. Verify boot success:
   ```
   uname -r
   ```
   Output should match the selected kernel (e.g., `4.18.0-305.el8_4.x86_64`).

4. Check logs for issues:
   ```
   journalctl --boot | tail -20
   ```

> [!NOTE]  
> If boot fails, fall back: Boot to recovery mode, check `/var/log/messages`, or revert configurations.

## Identifying Installed Kernels {#identifying-installed-kernels}

### Overview
Use package managers to list installed kernels. This helps determine which are obsolete and safe to remove, while retaining 1-2 recent ones for emergencies.

### Key Concepts and Deep Dive
- **Kernel Packages**: Kernels have multiple components (kernel-core, kernel-modules, etc.). Focus on the main `kernel` package.
- **Version Identification**: Versions include numbers (e.g., 4.18.0-305) and release dates; newer is better.
- **Best Practice**: Never remove the running kernel or more than one old version to allow rollbacks.

### Lab Demo: Listing Kernels
1. Use `dnf` to query kernels:
   ```
   sudo dnf list --installed kernel*
   ```
   - Shows installed kernel packages with versions.

2. Alternative with `rpm`:
   ```
   rpm -qa kernel*
   ```
   - Lists all kernel-related RPMs; filter for `*` for full view.

3. Example Output:
   ```
   kernel.x86_64              4.18.0-305.el8               @rhel-8-appstream-rpms
   kernel.x86_64              4.18.0-358.el8               @rhel-8-appstream-rpms
   kernel-modules.x86_64      4.18.0-305.el8               @rhel-8-appstream-rpms
   kernel-modules.x86_64      4.18.0-358.el8               @rhel-8-appstream-rpms
   ```
   - Older versions (e.g., 4.18.0-305) are candidates for removal.

> [!TIP]  
> Keep the two most recent kernels for safety.

## Checking /boot Partition Size {#checking-boot-partition-size}

### Overview
The `/boot` partition is small (~1GB in CentOS installations) and fills up with multiple kernels. Monitor its usage before and after cleanup.

### Key Concepts and Deep Dive
- **Typical Size**: 100-300MB per kernel, including initrd and vmlinuz files.
- **Capacity Issues**: Exceeding 90% risks failed boot or new kernel installs.
- **Monitoring**: Use `df` for usage, `du` for directories.

### Lab Demo: Monitoring /boot Space
1. Check /boot usage:
   ```
   df -h /boot
   ```
   - Example: `Used: 700MB Avail: 200MB Use%: 78%`

2. Drill down into contents:
   ```
   du -sh /boot/*
   ```
   - Shows size per file/directory (e.g., `/boot/vmlinuz-4.18.0-305` ~100MB).
   - Total should be tracked post-cleanup.

| Item | Old Usage (Example) | New Usage (After Cleanup) | Savings |
|------|---------------------|---------------------------|---------|
| /boot | 700MB (78%)        | 217MB (22%)               | ~483MB  |
| Kernels Count | 2 | 1 | N/A |

> [!WARNING]  
> If /boot is full, consider resizing partitions or migrating to larger disks.

## Removing Old Kernels {#removing-old-kernels}

### Overview
Safely remove obsolete kernels using `dnf remove` or `rpm -e`. The process cleans packages, images, and GRUB entries, freeing /boot space.

### Key Concepts and Deep Dive
- **Safe Removal**: Remove only non-running kernels from older versions. Use `uname -r` to confirm.
- **Dependencies**: Software like modules auto-remove with kernels.
- **Cleanup**: Manual removal of `/boot` files if needed post-package uninstall.

### Lab Demo: Removing a Kernel
1. Identify target kernel (e.g., `4.18.0-305`):
   ```
   uname -r  # Confirm current kernel
   ```

2. Remove with `dnf`:
   ```
   sudo dnf remove kernel-4.18.0-305
   ```
   - Prompts for confirmation; 'y' to proceed.
   - Cleans packages, symlinks, and GRUB entries.

3. Alternative with `rpm` (dangerous; avoid):
   ```
   sudo rpm -e --nodeps kernel-4.18.0-305.el8.x86_64
   ```
   - Bypasses dependencies; use only if `dnf` fails.

4. Remove associated files manually if needed:
   ```
   sudo rm /boot/initrd-4.18.0-305.img
   sudo rm /boot/vmlinuz-4.18.0-305
   ```
   - Update GRUB after: `sudo grub2-mkconfig -o /boot/grub2/grub.cfg`

5. Verify GRUB config:
   ```
   sudo grubby --default-kernel  # Shows current default
   sudo grubby --set-default /boot/vmlinuz-4.18.0-358  # Set new default
   ```

> [!IMPORTANT]  
> Test boot the system after removal. Have console access ready for recovery.

## Verification and Best Practices {#verification-and-best-practices}

### Overview
After removal, confirm cleanliness and space savings. Adhere to best practices to avoid regressions, such as regular cleanups and keeping backups.

### Key Concepts and Deep Dive
- **Verification Steps**: Re-query packages, check sizes, and test boots.
- **Risks**: Removing active kernels causes boot failures. SELinux or firewalls may block network post-reboot.
- **Automation**: Schedule cleanups or use tools like `dnf` plugins for auto-removal.

### Lab Demo: Post-Removal Verification
1. Re-check installed kernels:
   ```
   sudo rpm -qa kernel*
   ```
   - Should show only desired versions.

2. Re-assess /boot size:
   ```
   df -h /boot
   du -sh /boot
   ```
   - Expect 300-500MB savings per removed kernel.

3. Test reboot:
   ```
   sudo reboot
   uname -r  # Confirm version
   ```

> [!NOTE]  
> SELinux status: Check `sestatus` for enforcing mode, ensuring security contexts apply correctly.

## Summary {#summary}

### Key Takeaways
```diff
+ Kernel updates must be followed by reboots to apply changes safely.
+ Identify deprecated kernels using package queries and keep 1-2 recent ones.
+ Removing old kernels frees /boot space and prevents capacity issues, but requires careful selection to avoid boot failures.
- Avoid removing the running kernel or using risky flags without verification.
! Always monitor /boot usage and have recovery options like GRUB fallback ready.
```

### Quick Reference
- **Update System**: `sudo dnf update && sudo reboot`
- **List Kernels**: `rpm -qa kernel*` or `sudo dnf list --installed kernel*`
- **Check /boot Size**: `df -h /boot && du -sh /boot/*`
- **Remove Kernel**: `sudo dnf remove kernel-[version]`
- **Verify GRUB**: `sudo grubby --default-kernel`

### Expert Insight
**Real-world Application**: In production servers, automate kernel cleanup scripts to run post-updates via cron jobs, ensuring /boot doesn't exceed 70% capacity. This prevents downtime from failed boots.

**Expert Path**: Master GRUB CLI (`grubby --help`) for advanced booting scenarios like custom kernels. Investigate `kernel-core` vs. `kernel` packages for deeper system tuning.

**Common Pitfalls**: Lack of subscriptions leads to update failures; forgetting reboots causes inconsistent states; removing active kernels results in unbootable systems—always boot-test changes.

</details>
