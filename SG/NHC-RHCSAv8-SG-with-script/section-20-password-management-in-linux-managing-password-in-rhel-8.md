# Section 20: Password Management in Linux

<details open>
<summary><b>Section 20: Password Management in Linux (CL-KK-Terminal)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Changing User Passwords](#changing-user-passwords)
- [Password Reset for Other Users](#password-reset-for-other-users)
- [Where Passwords Are Stored](#where-passwords-are-stored)
- [Password Encryption Mechanism](#password-encryption-mechanism)
- [Demonstrating Encryption with OpenSSL](#demonstrating-encryption-with-openssl)
- [Password Aging and Expiration](#password-aging-and-expiration)
- [Password Policy Configuration](#password-policy-configuration)
- [Locking and Unlocking User Accounts](#locking-and-unlocking-user-accounts)
- [Disabling User Accounts](#disabling-user-accounts)
- [Summary](#summary)

## Overview

Password management in Linux is a critical security practice involving creating, changing, and securing user passwords, managing account access, and implementing policies for password aging and expiration. This section covers essential commands and files for handling user authentication, including the secure storage of passwords in encrypted formats.

## Changing User Passwords

### Overview

Users can change their own passwords using the `passwd` command. This command requires entering the current password and setting a new complex password that meets system requirements.

### Key Concepts

- The `passwd` command accepts various inputs and validates password complexity
- Dictionary-based passwords are rejected for security reasons
- Complex passwords must include uppercase, lowercase, numbers, and special characters

### Code/Config Blocks

To change your own password:
```bash
passwd
```
- Enter current password
- Enter new password (complex: at least 8-12 characters, mixed case, numbers, symbols)
- Confirm new password

The system will validate:
- Password complexity
- Avoidance of dictionary words
- Compliance with system policies

### Lab Demos

Example interaction:
```bash
[root@localhost ~]# passwd
Changing password for user root.
New password: MyComplexP@ss123
Retype new password: MyComplexP@ss123
passwd: all authentication tokens updated successfully.
```

## Password Reset for Other Users

### Overview

When users forget their passwords or administrators need to reset them, the root user can reset passwords without knowing the current one.

### Key Concepts

- Root can reset any user's password using `passwd <username>`
- User accounts can be locked/unlocked using `usermod` commands
- Root has sudo access to manage all accounts

### Code/Config Blocks

To reset another user's password (as root):
```bash
passwd username
```

To switch users and potentially reset:
```bash
su username  # If you know the password
```

For sudo-enabled users:
```bash
sudo passwd username
```

## Where Passwords Are Stored

### Overview

Linux stores encrypted passwords in the `/etc/shadow` file, which contains detailed account information including password aging, expiration dates, and account lock status.

### Key Concepts

The `/etc/shadow` file contains one line per user with colon-separated fields:
- Username
- Encrypted password (or `!!` for locked, or empty for no password)
- Last password change (days since 1970-01-01)
- Minimum days between changes
- Maximum days until expiration
- Warning days before expiration
- Days after expiration before account disable
- Account expiration date
- Reserved field

Access requires root privileges:
```bash
cat /etc/shadow
```

### Tables

| Field | Description | Example Value |
|-------|-------------|---------------|
| Username | User login name | root |
| Password | Hashed password (SHA-512 by default) | $6$randomsalt$encrypteddata |
| Last Change | Days since epoch (1970-01-01) | 8094 |
| Min Days | Minimum days before change allowed | 0 |
| Max Days | Days until password expires | 99999 |
| Warn | Days to warn before expiration | 7 |
| Inactive | Days after expiration to disable | (empty) |
| Expire | Account expiration date | (empty) |

## Password Encryption Mechanism

### Overview

Linux uses the crypt function for password hashing, typically SHA-512 with salt for security. This ensures passwords cannot be easily cracked even if the hash file is compromised.

### Key Concepts

- **Crypt function**: C library function that generates hashed passwords
- **Salt**: Random data added to prevent rainbow table attacks
- **Hash algorithm**: Modern systems use SHA-512
- The same password with different salt produces different hashes

### Code/Config Blocks

To manually encrypt a password (example):
```bash
# Using openssl for demonstration (not for production)
openssl passwd -6 -salt randomsalt MyPassword123
```

Production hashing is done automatically by the passwd command.

## Demonstrating Encryption with OpenSSL

### Overview

The `openssl passwd` command can demonstrate password hashing techniques, showing how different algorithms and salts produce unique encrypted outputs.

### Key Concepts

- OpenSSL provides various hashing algorithms (MD5, SHA-256, SHA-512)
- Salt values are crucial for security
- Same password + same salt = same hash
- Same password + different salt = different hash

### Code/Config Blocks

Basic MD5 hashing:
```bash
openssl passwd -1 MyPassword
```

SHA-256 hashing:
```bash
openssl passwd -5 -salt mysalt MyPassword
```

SHA-512 hashing (modern default):
```bash
openssl passwd -6 -salt randomstring MyPassword123
```

Custom program to hash passwords:
```c
#include <stdio.h>
#include <unistd.h>

int main() {
    char *password = "MyPassword123";
    char *encrypted = crypt(password, "$6$randomsalt$");
    printf("%s\n", encrypted);
    return 0;
}
```

Compile and run:
```bash
gcc -o crypt_demo crypt_demo.c -lcrypt
./crypt_demo
```

## Password Aging and Expiration

### Overview

Password aging controls how long passwords remain valid, requiring periodic changes and warning users before expiration. This is configured in `/etc/shadow` and `/etc/login.defs`.

### Key Concepts

- Password age tracked from Unix epoch (1970-01-01)
- Warning periods notify users before expiration
- Accounts can be automatically disabled after expiration
- Grace periods allow continued access briefly

### Tables

Sample `/etc/shadow` entries:

| Entry | Value | Meaning |
|-------|--------|---------|
| Last Change | 8094 | Password changed 8094 days ago |
| Minimum Days | 0 | Can change immediately |
| Maximum Days | 99999 | Never expires (practically) |
| Warning Days | 7 | Warn 7 days before expiration |
| Expiration | 11544 | Account expires 11544 days from epoch |
| Inactive |  | No automatic disable |

## Password Policy Configuration

### Overview

System-wide password policies are set in `/etc/login.defs` and can be modified to enforce security requirements. The `chage` command allows per-user policy management.

### Key Concepts

- `login.defs` contains default aging policies
- `chage` command provides detailed user-specific control
- Policies can be viewed without root access using `chage -l`

### Code/Config Blocks

View `/etc/login.defs` (relevant sections):
```bash
grep -E "^PASS_|MD5_CRYPT_ENAB" /etc/login.defs
```

Change user password aging (as root):
```bash
chage -m 1 -M 30 -W 7 username
```

View user aging information:
```bash
chage -l username
```

## Locking and Unlocking User Accounts

### Overview

Account locking prevents user login while preserving account data. Multiple methods exist to lock/unlock accounts through password manipulation and configuration files.

### Key Concepts

- Locked accounts show `!!` or `!` prefix in `/etc/shadow`
- Locking prevents all authentication methods except root
- Unlocking restores normal access

### Code/Config Blocks

Lock account:
```bash
usermod -L username
passwd -l username
```

Unlock account:
```bash
usermod -U username
passwd -u username
```

Manual editing:
```bash
vipw  # Edit /etc/shadow
# Add !! prefix to encrypted password field
```

## Disabling User Accounts

### Overview

Account disablement prevents login while account remains intact. This can be done by editing configuration files or using specific commands targeted at login restrictions.

### Key Concepts

- Edit `/etc/passwd` to add `*` before shell entry
- Use `vipw` command for safe editing
- Different methods provide various levels of restriction

### Code/Config Blocks

Method 1 - Edit `/etc/passwd`:
```bash
vipw  # Safe edit /etc/shadow (though actually edits passwd)
# Change shell from /bin/bash to invalid entry
```

Method 2 - Add to end of line:
```bash
# Edit using editor
# Append !! to end of username field
```

Common disable markers:
- `!!` in password field (locked)
- `/*` in shell field (invalid shell)
- Invalid shell path

## Summary

### Key Takeaways

```diff
+ Root users can reset any password without knowing current credentials
+ Passwords are stored encrypted in /etc/shadow file using SHA-512 with salt
- Never store plain text passwords or use dictionary-based passwords
! Dictionary check prevents common passwords during changes
```

### Quick Reference

**Essential Commands:**
- `passwd` - Change password
- `passwd username` - Reset other user's password (root only)
- `usermod -L username` - Lock account
- `usermod -U username` - Unlock account
- `chage -l username` - View password aging
- `vipw` - Edit /etc/shadow safely
- `vigr` - Edit /etc/group safely

**Important Files:**
- `/etc/shadow` - Encrypted password storage
- `/etc/login.defs` - System password policies

### Expert Insight

**Real-world Application**: Password management is crucial in production environments. Enterprises use LDAP/Active Directory for centralized password policies, implementing MFA and automated rotation. In cloud environments like AWS/Linux servers, password policies are configured via security groups and IAM roles, with monitoring for unauthorized access attempts.

**Expert Path**: Master advanced authentication methods including PAM modules, LDAP integration, and SELinux contexts. Understand auditing with `auditd` for password-related events. Learn to implement password cracking protection using `fail2ban` and rate limiting. Study compliance frameworks like CIS benchmarks for hardening.

**Common Pitfalls**: Accidentally locking service accounts causing system outages, using weak password policies tempting brute force attacks, forgetting to update password policies after system upgrades, and misconfiguring expiration dates leading to account lockouts during critical operations.

</details>
