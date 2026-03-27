# Section 24: Advanced File Permissions

<details open>
<summary><b>Section 24: Advanced File Permissions (CL-KK-Terminal)</b></summary>

## Table of Contents
1. [Symbolic Umask Settings](#symbolic-umask-settings)
2. [Sticky Bit (chmod +t)](#sticky-bit-chmod-t)
3. [SetGID (chmod g+s)](#setgid-chmod-gs)
4. [SetUID (chmod u+s)](#setuid-chmod-us)
5. [Permanent Umask Configuration](#permanent-umask-configuration)

## Symbolic Umask Settings

**Overview**
The umask command controls default permissions for newly created files and directories. While we previously learned to set umask using octal values (like 022), this section demonstrates how to set and view umask symbolically using alphabetical representations like `u=rwx,g=rx,o=`.

**Key Concepts**

Symbolic umask allows you to specify permissions for owner (`u`), group (`g`), and others (`o`) using readable characters instead of numbers.

**Viewing Current Umask Symbolically**
```bash
umask -S
# OR
umask --symbolic
```

**Setting Umask Symbolically**
The format follows: `umask u=<perms>,g=<perms>,o=<perms>`

**Examples:**
```bash
# Restrict permissions to owner only
umask u=rwx,g=,o=

# Give owner full access, group read/execute, others none
umask u=rwx,g=rx,o=

# Numeric equivalent: 022
umask u=rw,g=rw,o=r

# Numeric equivalent: 077
umask u=rwx,g=,o=

# Numeric equivalent: 002
umask u=rwx,g=rwx,o=rw
```

**Deep Dive**
- `umask -S` shows the effective permissions that will be given (what's actually set)
- `umask <value>` changes the mask numerically
- Symbolic format provides clearer understanding of what permissions are being masked out

**Lab Demo**

Create a demonstration directory and test umask behavior:
```bash
# Check current umask
umask

# Change to restrictive umask (077)
umask 077

# Create files and see limited permissions
touch testfile1
mkdir testdir1

# Check permissions
ls -la

# Change using symbolic format
umask u=rwx,g=rx,o=

# Verify the change
umask -S
```

## Sticky Bit (chmod +t)

**Overview**
The sticky bit is a special permission that prevents users from deleting or renaming files in a shared directory, even if they have write permissions to that directory. When set on a directory, users can only delete their own files.

**Key Concepts**

- **Octal representation**: 1000 in octal, or '1' in the tens thousands place
- **Command syntax**: `chmod +t <directory>` or `chmod 1777 <directory>`
- **Effect**: Users cannot delete files owned by others in the directory
- **Default behavior**: /tmp directory has sticky bit enabled by default

**Setting Sticky Bit**

```bash
# Method 1: Using symbolic notation
chmod +t directory_name

# Method 2: Using octal (add 1000 to desired permissions)
chmod 1777 directory_name  # sticky bit + rwx for all
chmod 1644 directory_name  # sticky bit + rw for owner, r for group/others
```

**Viewing Sticky Bit**
```bash
ls -ld directory_name
```
You'll see a 't' or 'T' in the permission string:
- `t` indicates sticky bit with execute permission
- `T` indicates sticky bit without execute permission

**Deep Dive**

The sticky bit works by allowing only the file/directory owner to delete or rename files within the protected directory.

**Lab Demo**

```bash
# Create a test directory
mkdir /root/test

# Change ownership to root and permissions to 777 (full access)
chown root:root /root/test
chmod 777 /root/test

# Apply sticky bit
chmod +t /root/test

# Verify (should show 't' at end of permissions)
ls -ld /root/test
# drwxrwxrwt 2 root root ...

# Switch to different user account (e.g., development user)
su development

# Try to delete someone else's file - should fail
rm /root/test/file_created_by_root
# Output: rm: remove write-protected regular file '/root/test/file_created_by_root'? y
# Operation will be denied
```

**Removing Sticky Bit**
```bash
# Method 1: Remove with minus
chmod -t directory_name

# Method 2: Set permissions without thousands digit
chmod 0777 directory_name  # removes sticky bit
```

## SetGID (chmod g+s)

**Overview**
SetGID (Set Group ID) is a special permission that ensures all files and subdirectories created within a directory inherit the group ownership of the parent directory, rather than the primary group of the creating user.

**Key Concepts**

- **Octal representation**: 2000 in octal, or '2' in the thousands place
- **Command syntax**: `chmod g+s <directory>` or `chmod 2777 <directory>`
- **Effect**: New files/subdirs get parent's group ownership
- **Behavior**: When set on executables, processes run with supplementary group access

**Setting SetGID**

```bash
# Method 1: Using symbolic notation
chmod g+s directory_name

# Method 2: Using octal (add 2000 to desired permissions)
chmod 2777 directory_name  # setgid + rwx for all
chmod 2644 directory_name  # setgid + rw for owner, r for group/others
```

**Viewing SetGID**
```bash
ls -ld directory_name
```
You'll see an 's' or 'S' in the group permissions position:
- `s` indicates setgid with execute permission for group
- `S` indicates setgid without execute permission for group

**Deep Dive**

SetGID creates collaborative environments where multiple users sharing a group can work together on files without complex permission management.

**Lab Demo**

```bash
# Create project directory
mkdir /root/project_data

# Create dedicated group
groupadd project_team

# Change directory ownership and group
chown root:project_team /root/project_data

# Set group permissions and apply SetGID
chmod 770 /root/project_data  # rw for owner/group
chmod g+s /root/project_data   # inherit group ownership

# Verify
ls -ld /root/project_data
# drwxrws--- 2 root project_team ...

# Switch to development user (assuming they're added to project_team group)
su development

# Create files in the directory
touch /root/project_data/analysis.txt

# Check ownership - should show project_team as group
ls -la /root/project_data/analysis.txt
# -rw-rw-r-- 1 development project_team ...
```

**Removing SetGID**
```bash
# Method 1: Remove with minus
chmod g-s directory_name

# Method 2: Set permissions without thousands digit
chmod 0777 directory_name  # removes setgid
```

## SetUID (chmod u+s)

**Overview**
SetUID (Set User ID) is a special permission that allows a file to run with the privileges of its owner, rather than the privileges of the user executing the file. This is commonly used for system commands that need elevated permissions.

**Key Concepts**

- **Octal representation**: 4000 in octal, or '4' in the thousands place
- **Command syntax**: `chmod u+s <file>` or `chmod 4755 <file>`
- **Effect**: Process runs with file owner's permissions (effective UID)
- **Security consideration**: Creates security risks if misused

**Setting SetUID**

```bash
# Method 1: Using symbolic notation
chmod u+s filename

# Method 2: Using octal (add 4000 to desired permissions)
chmod 4755 filename  # setuid + rwx for owner, rx for group/others
chmod 4644 filename  # setuid + rw for owner, r for group/others
```

**Viewing SetUID**
```bash
ls -l filename
```
You'll see an 's' or 'S' in the owner permissions position:
- `s` indicates setuid with execute permission for owner
- `S` indicates setuid without execute permission for owner

**Deep Dive**

SetUID is primarily used for system binaries that need to perform privileged operations. The most common examples are `/usr/bin/passwd` and `/usr/bin/su`.

**Finding SetUID Files**
```bash
# Find all setuid files on the system
find / -type f -perm /4000 2>/dev/null

# Common setuid files:
/usr/bin/passwd     # Allows users to change passwords
/usr/bin/su         # Allows switching to root
/usr/bin/sudo       # Allows executing commands as other users
```

**Lab Demo**

```bash
# Examine a typical setuid file
ls -l /usr/bin/passwd
# -rwsr-xr-x 1 root root 67992 Mar 27  2023 /usr/bin/passwd

# Create a demonstration script (CAUTION: This is for educational purposes only)
echo '#!/bin/bash
echo "Running with effective UID: $EUID"
echo "Process UID: $UID"
' > /root/test_uid.sh

chmod 755 /root/test_uid.sh

# Apply setuid (VERY CAUTIOUS - don't do this on real systems)
chmod u+s /root/test_uid.sh

# Verify
ls -l /root/test_uid.sh
# -rwsr-xr-x 1 root root ... /root/test_uid.sh

# Execute as regular user
su user123
./root/test_uid.sh
# Running with effective UID: 0 (root)
# Process UID: 1000 (regular user)
```

**Removing SetUID**
```bash
# Method 1: Remove with minus
chmod u-s filename

# Method 2: Set permissions without thousands digit
chmod 0755 filename  # removes setuid
```

## Permanent Umask Configuration

**Overview**
By default, umask changes are temporary and revert when the user logs out. To make umask settings permanent, they must be configured in the appropriate system files.

**Key Concepts**

- **System-wide changes**: Modify `/etc/profile` or `/etc/bashrc`
- **User-specific changes**: Modify `~/.bashrc` or `~/.bash_profile`

**Making Umask Permanent System-Wide**
```bash
# Edit system-wide profile
sudo vim /etc/profile

# Add line (e.g., set umask 022)
umask 022

# Save and exit
source /etc/profile  # or logout/login to test
```

**Making Umask Permanent for Specific User**
```bash
# Edit user's bashrc (as root or user)
vim ~/.bashrc

# Add line
umask 007

# Save and exit
source ~/.bashrc
```

**Deep Dive**

The `/etc/profile` file is executed for all interactive login shells, making it the ideal place for system-wide umask settings.

**Lab Demo**

```bash
# Check current umask in profile (may not be set by default)
grep "umask" /etc/profile

# If none found, add system-wide default
sudo bash -c 'echo "umask 022" >> /etc/profile'

# Verify addition
tail -5 /etc/profile

# Test by logging out and back in, or by sourcing
source /etc/profile

# Verify new umask is active
umask
```

## Summary

### Key Takeaways

```diff
+ Symbolic umask (umask u=rwx,g=r,o=) provides readable permission masking
+ Sticky bit (chmod +t) prevents users from deleting others' files in shared directories
+ SetGID (chmod g+s) makes new files inherit parent directory's group ownership
+ SetUID (chmod u+s) allows executables to run with owner's permissions (use cautiously)
+ Permanent changes made in /etc/profile survive logout/login
- Avoid unverified setuid applications for security reasons
! Never apply special permissions to ordinary user files without understanding implications
```

### Quick Reference

**Special Permissions Summary:**
- **Sticky Bit**: `chmod +t` or octal with 1000 (prevents file deletion in shared dirs)
- **SetGID**: `chmod g+s` or octal with 2000 (inherit group ownership)  
- **SetUID**: `chmod u+s` or octal with 4000 (run with owner permissions)

**Viewing Permissions:**
- Sticky bit shown as `t/T` at end of permissions
- SetGID shown as `s/S` in group execute position
- SetUID shown as `s/S` in owner execute position

**Common System Files with Special Permissions:**
```bash
# Password change utility
-rwsr-xr-x root root /usr/bin/passwd

# Default temp directory  
drwxrwxrwt root root /tmp
```

### Expert Insight

**Real-world Application**: SetGID directories are essential for collaborative development environments where team members need to share files while maintaining proper group access. Sticky bit is critical for shared upload directories in web applications to prevent user conflicts.

**Expert Path**: Master these permissions by practicing in isolated virtual machines. Understand the security implications of SetUID especially - it's powerful but dangerous. Move to Access Control Lists (ACLs) and SELinux for enterprise-level permission management.

**Common Pitfalls**: 
- Setting SetUID on regular scripts without understanding the security risks
- Forgetting that root-bypass permissions apply even to incorrectly configured files
- Assuming special permissions override standard ownership rules
- Not regularly auditing setuid/setgid files on production systems

</details>
