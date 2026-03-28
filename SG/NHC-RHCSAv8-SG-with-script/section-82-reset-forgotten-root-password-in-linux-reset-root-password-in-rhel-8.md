## Section 82: Resetting Root Password in Linux

<details open>
<summary><b>Section 82: Resetting Root Password in Linux (CL-KK-Terminal)</b></summary>

## Overview

This section explores multiple methods for resetting the root password in Linux systems, particularly focusing on RHEL 9/CentOS/Rocky Linux. You'll learn different approaches depending on whether you know the current password or not, including traditional methods and newer techniques required for modern Linux distributions.

## Resetting Root Password When You Know the Current Password

### Prerequisites
- Current root password access
- sudo privileges as a non-root user

### Method 1: Using Root Account Directly
If you have root access or know the password, the simplest method is:
```bash
passwd root
```
Enter the new password twice when prompted.

### Method 2: Using sudo (Non-root User with sudo Privileges)
```bash
sudo passwd root
```

## Resetting Root Password When You DON'T Know It (RHEL 7/8 Traditional Method)

⚠️ **Important**: This method does NOT work in RHEL 9 due to changes in system behavior.

### Traditional Approach (RHEL 7/8)
1. Reboot the system
2. Interrupt boot process at GRUB menu
3. Press 'e' to edit the selected kernel entry
4. Append `rd.break` to the end of the linux16 line
5. Press Ctrl+X to boot
6. Mount root filesystem as read-write:
   ```bash
   mount -o remount,rw /sysroot
   ```
7. Switch to system root:
   ```bash
   chroot /sysroot
   ```
8. Change password:
   ```bash
   passwd root
   ```

### Problem with This Method in RHEL 9
In RHEL 9, attempting to use `rd.break` prompts for root password instead of allowing direct access:
```
Press Enter for Maintenance or enter root password:
```

The system no longer allows unrestricted access in maintenance mode for security reasons.

## RHEL 9 Method: Using Rescue Mode

### Prerequisites
- Physical/console access to server
- BIOS/UEFI access if needed

### Step-by-Step Process

#### 1. Interrupting Boot Process
- Reboot the system
- Enter GRUB menu by pressing cursor keys or Esc when you see the boot messages
- Select the kernel you want to boot (usually the first option)

#### 2. Editing GRUB Entry
Press 'e' to edit the selected kernel entry. You'll see kernel parameters lines.

**For Recovery/Rescue Mode:**
- Remove any existing `rd.break` if present
- Change from normal kernel selection to rescue mode
- Replace first line selection with rescue mode line:

**Before:**
```
CentOS Linux (5.4.77-1.el9.elrepo.x86_64) 5.14.6-1.el9.elrepo.x86_64
```

**After (Rescue Mode):**
```
CentOS Linux 9 (0-rescue-???) 5.14.6-1.el9.elrepo.x86_64
```

#### 3. Modifying Kernel Parameters
After selecting rescue mode, press 'e' again to edit the kernel parameters.

Find the line starting with `linux` or `linux16` and add at the end:
```
rd.break
```

**Example:**
```
linux   /vmlinuz-5.14.6-1.el9.elrepo.x86_64 root=/dev/mapper/cl-root ro crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M resume=/dev/mapper/cl-swap rd.lvm.lv=cl/root rd.lvm.lv=cl/swap rhgb quiet rd.break
```

Press Ctrl+X to boot with these parameters.

#### 4. Maintenance Mode
Instead of dropping to single-user mode, RHEL 9 will show:
```
Press Enter for Maintenance or enter root password:
```
Press Enter to proceed to maintenance mode.

#### 5. Remounting File System
Mount the root file system as read-write:
```bash
mount -o remount,rw /sysroot
```

#### 6. Changing Root Environment
```bash
chroot /sysroot
```

#### 7. Resetting Password
```bash
passwd root
```
Enter new password twice when prompted.

#### 8. SELinux Context Relabeling

Create the autorelabel file for SELinux context restoration:
```bash
touch /.autorelabel
```

Note: If autorelabel file already exists, you may skip this step.

Exit the chroot environment:
```bash
exit
```

#### 9. Rebooting System
```bash
reboot
```

The system will automatically relabel SELinux contexts during bootup. This process may take several minutes depending on system size.

## Lab Demo: Practical Implementation

### Environment Setup
- **VM/Lab Setup**: CentOS/RHEL 9 system with root password set
- **Goal**: Demonstrate password reset without knowing current password

### Demonstration Steps

1. **Initial Boot Interruption**
   - Server boots normally
   - Interrupt at GRUB menu when "Press any key" appears
   - Use arrow keys to select kernel line

2. **GRUB Mode Selection**
   - Default shows kernel like:
     ```
     CentOS Linux (5.4.77-1.el9.elrepo.x86_64) 5.14.6-1.el9.elrepo.x86_64
     ```
   - Change to rescue mode line (modify grub.cfg if needed)

3. **Kernel Parameter Modification**
   - Press 'e' on rescue kernel line
   - Add `rd.break` at end of linux line
   - Boot with Ctrl+X

4. **Maintenance Access**
   - System prompts: "Press Enter for Maintenance"
   - Press Enter (no password required at this stage)

5. **File System Operations**
   ```bash
   # Mount root as read-write
   mount -o remount,rw /sysroot

   # Change to system environment
   chroot /sysroot
   ```

6. **Password Reset Command**
   ```bash
   passwd root
   # Enter new password twice
   ```

7. **SELinux Preparation**
   ```bash
   touch /.autorelabel
   exit
   ```

8. **System Restart**
   ```bash
   reboot
   ```

9. **Verification**
   - System boots normally with relabeling process
   - Login with new root password

## Security Considerations

### When to Use Each Method
Use RHEL 9 rescue mode method when:
- Root password is forgotten/lost
- Current user lacks sudo privileges
- Single-user mode is password-protected

### Security Implications
- Physical/console access may be bypassed in cloud environments
- GRUB password protection can prevent these methods
- SELinux relabeling requires significant boot time

### Production Environment Warnings
- **Critical Applications**: May experience issues during SELinux relabeling
- **Large Systems**: Relabeling process can be time-consuming
- **Emergency Use Only**: Use password reset only when no other recovery options exist

## Differences: RHEL Versions Comparison

| Feature | RHEL 7/8 | RHEL 9 |
|---------|----------|--------|
| Single-user mode | Direct access | Password required |
| Rescue mode access | Same method | Separate rescue kernel |
| Root password prompt | None | Prompts for maintenance |
| SELinux relabeling | Required | Required |
| Security hardening | Basic | Enhanced |

## Common Mistakes to Avoid

### ❌ **Don't Skip SELinux Relabeling**
- System won't boot properly without `.autorelabel` file
- Services may fail due to incorrect contexts

### ❌ **Don't Modify Production Systems Without Backup**
- Always snapshot or backup before changes
- Test in lab environment first

### ❌ **Don't Use Outdated Methods on RHEL 9**
- Traditional `rd.break` method fails
- Waste time attempting deprecated approaches

### ❌ **Don't Reboot Without Saving Changes**
- All file changes must be committed before reboot
- Password changes require file system sync

## Expert Insights

### Real-World Application
- Cloud environments often require vendor-specific recovery processes
- Enterprise systems may have console access restrictions
- Always document password reset procedures in incident response plans

### Expert Path to Mastery
- Understand GRUB configuration thoroughly (`/etc/grub2/grub.cfg`)
- Learn initramfs debugging and rescue techniques
- Study PAM (Pluggable Authentication Modules) configuration
- Master SELinux administration and troubleshooting

### Common Pitfalls Answers
- **Boot loader security**: Set GRUB password in `/etc/grub.d/01_users`
- **Console access**: Virtual console (VC) implementation differences
- **Emergency scenarios**: DRAC/iDRAC/IPMI access for remote servers
- **File system corruption**: Use rescue USB/live CD when disk is damaged

## Summary

### Key Takeaways
```diff
+ RHEL 9 requires rescue mode instead of traditional rd.break method
+ SELinux relabeling is mandatory for system stability
+ Physical/console access is essential for password recovery
+ Rescue mode bypasses password requirements for maintenance
- Traditional methods from RHEL 7/8 will fail in RHEL 9
- Never perform on production systems without proper planning
! Use only as last resort when other recovery methods fail
! Document all password changes and recovery procedures
```

### Quick Reference

**Basic Password Change (when you know current):**
```bash
passwd root
```

**RHEL 9 Password Reset (when forgotten):**
1. Interrupt boot → Select rescue kernel → Add `rd.break`
2. Boot with Ctrl+X → Press Enter for maintenance
3. `mount -o remount,rw /sysroot`
4. `chroot /sysroot`
5. `passwd root`
6. `touch /.autorelabel`
7. `exit` and `reboot`

**GRUB Security:**
```bash
# Set GRUB password
grub2-mkpasswd-pbkdf2
# Add to /etc/grub.d/01_users
```

### Expert Insight
Ultimately, mastering Linux password recovery requires understanding the entire boot process from BIOS through init systems. Modern security implementations have made direct root access more challenging, emphasizing the importance of proper account management, backup strategies, and emergency preparedness. The expert administrator views password reset as a contingency capability, not a regular maintenance task.

</details>
