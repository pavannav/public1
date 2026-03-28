<details open>
<summary><b>Section 83: GRUB Password Setup and Management (CL-KK-Terminal)</b></summary>

# Section 83: GRUB Password Setup and Management

## Table of Contents
- [Introduction to GRUB Password](#introduction-to-grub-password)
- [Why GRUB Password is Important](#why-grub-password-is-important)
- [Setting Up GRUB Password](#setting-up-grub-password)
- [Verifying GRUB Password](#verifying-grub-password)
- [Disabling GRUB Password - Method 1 (Editing GRUB Config)](#disabling-grub-password---method-1-editing-grub-config)
- [Disabling GRUB Password - Method 2 (Commenting Out Settings)](#disabling-grub-password---method-2-commenting-out-settings)
- [Resetting GRUB Password When Both Are Forgotten](#resetting-grub-password-when-both-are-forgotten)
- [Post-Reset Procedures](#post-reset-procedures)

## Introduction to GRUB Password

### Overview
GRUB (GRand Unified Bootloader) password provides an additional security layer for Linux systems like RHEL/CentOS, preventing unauthorized access to bootloader options. This includes protecting kernel parameters, single-user mode, and booting into unauthorized operating systems in multi-boot setups.

### Key Concepts
- **Primary Reasons for GRUB Password:**
  - Prevents unauthorized access via single-user mode
  - Blocks unauthenticated changes to GRUB menu (e.g., via GRUB editor)
  - Protects against information theft in dual/multi-boot scenarios
  - Adds security for non-secure operating systems on the same machine

- **GRUB Password Mechanics:**
  - Stored in `/etc/grub.d/01_users` file
  - Uses hashed password storage for security
  - Requires entering password to modify boot parameters
  - Works at the bootloader level before OS loads

### Lab Demo: Exploring GRUB Configuration Files
```bash
# List boot configuration directory
ls /boot/

# View GRUB config file (contains password settings)
cat /etc/default/grub

# Display current GRUB menu entries
ls /etc/grub.d/
```

## Why GRUB Password is Important

### Overview
GRUB password is crucial for system security, especially in environments where physical access is possible or multi-boot setups exist.

### Key Concepts
- **Single-User Mode Protection:** Without password, anyone can boot to single-user mode and reset root password
- **GRUB Menu Security:** Prevents editing boot entries via GRUB shell
- **Multi-Boot Protection:** Blocks unauthorized booting into insecure OS partitions
- **Information Theft Prevention:** Limits access to sensitive data on drives

### Tables
| Security Layer | Protection Against | Without GRUB Password | With GRUB Password |
|---------------|-------------------|----------------------|-------------------|
| Single-User Mode | Root password reset | ❌ Allowed | ✅ Blocked |
| GRUB Editor | Kernel parameter changes | ❌ Allowed | ✅ Blocked |
| Multi-OS Boot | Unauthorized access | ❌ Allowed | ✅ Blocked |

## Setting Up GRUB Password

### Overview
Setting up GRUB password involves editing the GRUB configuration and regenerating the bootloader config.

### Key Concepts
- **Configuration Steps:**
  1. Edit `/etc/default/grub` to enable unencrypted password
  2. Create hashed password file
  3. Regenerate GRUB config

### Lab Demo: Setting GRUB Password
```bash
# Step 1: Edit GRUB config to enable password (remove "unrestricted" from class definition)
sudo vim /etc/default/grub
# Find the line: "password_pbkdf2 root grub.pbkdf2.sha512..."
# Ensure class is not set to "unrestricted"

# Step 2: Set GRUB password (creates hashed password in /boot/grub2/)
sudo grub2-setpassword

# Enter and confirm password when prompted

# Step 3: Regenerate GRUB configuration
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

## Verifying GRUB Password

### Overview
After setup, verify that GRUB password is active by attempting to reboot and access sensitive options.

### Key Concepts
- **Verification Process:**
  - Reboot system
  - On GRUB menu, press 'e' to edit entries
  - System should prompt for password

### Lab Demo: Testing GRUB Password
1. Reboot the system: `sudo reboot`
2. At GRUB menu, press 'e' on any entry
3. Attempt to access rescue mode or single-user mode
4. System should prompt: "Enter username: " (enter "root") and "Enter password:"
5. Enter correct GRUB password to proceed

## Disabling GRUB Password - Method 1 (Editing GRUB Config)

### Overview
Method 1 involves directly editing the GRUB configuration file and regenerating the config.

### Key Concepts
- **Process:**
  1. Re-add "unrestricted" to class definition in `/etc/default/grub`
  2. Remove password file
  3. Regenerate config

### Lab Demo: Disabling via GRUB Config
```bash
# Step 1: Edit /etc/default/grub and add "unrestricted" to class definition
sudo vim /etc/default/grub
# Change class line to include "unrestricted"

# Step 2: Remove password file
sudo rm /boot/grub2/user.cfg

# Step 3: Regenerate GRUB config
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

## Disabling GRUB Password - Method 2 (Commenting Out Settings)

### Overview
Method 2 involves commenting out password-related lines in the GRUB users file.

### Key Concepts
- **Process:**
  1. Edit `/etc/grub.d/01_users`
  2. Comment out all password-related lines
  3. Regenerate config

### Lab Demo: Disabling by Commenting Out
```bash
# Step 1: Edit GRUB users file
sudo vim /etc/grub.d/01_users

# Step 2: Comment out password-related lines by prefixing with #
# Look for lines like:
# password_pbkdf2 root grub.pbkdf2.sha512...
# Comment them out by adding # at the beginning

# Step 3: Regenerate GRUB config
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

## Resetting GRUB Password When Both Are Forgotten

### Overview
When both GRUB and root passwords are forgotten, use live USB to reset GRUB password.

### Key Concepts
- **Recovery Process:**
  1. Boot from live USB/flash drive
  2. Mount filesystem
  3. Edit GRUB config files
  4. Reboot and complete reset

### Lab Demo: Resetting Forgotten Passwords
```bash
# Step 1: Boot from live USB (CentOS/RHEL installation media)

# Step 2: Access recovery mode
# Choose "Troubleshooting" > "Rescue a CentOS system"
# When prompted to continue, press Enter

# Step 3: Mount filesystem
# In rescue shell, choose option 1 for automount, then chroot
sudo chroot /mnt/sysimage

# Step 4: Edit GRUB config files to disable password
sudo vim /etc/default/grub
sudo vim /etc/grub.d/01_users

# Step 5: Exit chroot, reboot
exit
sudo reboot
```

### Post-Reset Procedures
After GRUB password removal via live boot:
```bash
# Run GRUB config generation to ensure changes take effect
sudo grub2-mkconfig -o /boot/grub2/grub.cfg

# Reboot to verify password is disabled
sudo reboot
```

## Summary

### Key Takeaways
```diff
+ GRUB password adds critical security layer preventing unauthorized single-user mode access
+ Primary protections: single-user mode, GRUB menu editing, multi-boot unauthorized access
+ Setup requires: editing /etc/default/grub, creating hashed password, regenerating config
+ Two disable methods: direct config editing or commenting password lines
+ Password recovery requires live boot when both passwords are forgotten
- Without GRUB password, anyone with physical access can reset root password or access sensitive data
! Always regenerate GRUB config after any GRUB password changes
```

### Quick Reference
**Set GRUB Password:**
```bash
sudo grub2-setpassword
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

**Remove GRUB Password (Method 1):**
```bash
# Edit /etc/default/grub: add "unrestricted"
sudo rm /boot/grub2/user.cfg
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

**Remove GRUB Password (Method 2):**
```bash
# Comment password lines in /etc/grub.d/01_users
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Expert Insight
- **Real-world Application:** GRUB passwords are essential for server environments with physical access risks. Use strong passwords and consider additional BIOS/UEFI boot security.
- **Expert Path:** Master GRUB customization, explore advanced locking, and integrate with centralized authentication systems. Study GRUB source code for deeper security implementations.
- **Common Pitfalls:** Forgetting passwords without recovery plans can cause system lockouts. Always maintain live boot options. Don't disable without security assessment.
</details>
