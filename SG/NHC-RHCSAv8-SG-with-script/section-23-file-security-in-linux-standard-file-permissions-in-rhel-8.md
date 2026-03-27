# Section 23: File Security

<details open>
<summary><b>Section 23: File Security (CL-KK-Terminal)</b></summary>

## Understanding Linux File Permissions

### Overview

File security in Linux is managed through permissions that control who can read, write, or execute files and directories. Standard file permissions are the foundation of Linux security, using a simple but powerful permission system that applies to files, directories, and other system resources.

### Key Concepts

#### File Permission Structure from `ls -l`

The `ls -l` command displays detailed information about files in a long listing format with 9 columns:

1. **Column 1: Inode Number** - Unique numerical identifier for each file/directory in the filesystem
2. **Column 2: Permissions** - 10-character string showing file type and permission bits
3. **Column 3: Link Count** - Number of hard links pointing to this file
4. **Column 4: Owner** - Username of the file owner
5. **Column 5: Group** - Group name that owns the file
6. **Column 6: Size** - File size in bytes
7. **Column 7: Modification Time** - Last modification timestamp
8. **Column 8: Filename** - The actual name of the file/directory

#### Permission Characters

```bash
# File types
-     Regular file
d     Directory  
l     Symbolic link
b     Block device
c     Character device
p     Named pipe
s     Socket
```

#### Permission Bits (Positions 2-10)

```diff
File Type | Owner Permissions | Group Permissions | Other Permissions
--------- | ----------------- | ----------------- | -----------------
    -     |       r w x       |       r w x       |       r w x    
```

**Permission Meanings:**
- `r` (read): Allows viewing file contents
- `w` (write): Allows modifying file contents  
- `x` (execute): Allows running/executing the file
- `-` : No permission granted

#### Permission Values

```diff
+ Numeric Values:
  - r = 4 (read)
  - w = 2 (write) 
  - x = 1 (execute)
  - - = 0 (none)
```

**Examples:**
```bash
rw- = 6 (4+2)        # Read and write
r-x = 5 (4+1)        # Read and execute
--- = 0             # No permissions
rwx = 7 (4+2+1)     # Full permissions
```

### Permission Commands

#### Changing File Ownership (`chown`)

```bash
# Basic syntax
chown [OPTIONS] USER[:GROUP] FILE

# Examples
chown root testfile           # Change owner to root
chown root:root testfile      # Change owner and group to root
chown :developers testfile    # Change only group to developers
chown -R root /path/to/dir    # Recursive ownership change
```

#### Changing File Group (`chgrp`)

```bash
# Basic syntax  
chgrp [OPTIONS] GROUP FILE

# Examples
chgrp developers config.txt
chgrp -R staff /var/log/
```

#### Changing Permissions (`chmod`)

**Numeric Method:**

```bash
# Syntax: chmod [owner][group][other] filename
chmod 755 script.sh      # rwxr-xr-x
chmod 644 file.txt       # rw-r--r--
chmod 600 private.txt    # rw-------
chmod 777 public.dat     # rwxrwxrwx
```

**Symbolic Method:**

```bash
# Syntax: chmod [references][operator][permissions] file
# References: u (owner), g (group), o (other), a (all)

# Add permissions
chmod u+x script.sh      # Add execute for owner
chmod g+w document.txt   # Add write for group  
chmod o+r file.txt       # Add read for others

# Remove permissions
chmod u-w file.txt       # Remove write from owner
chmod g-x,o-w script.sh  # Remove execute from group, write from others

# Set exact permissions
chmod u=rwx script.sh    # Set owner permissions to rwx
chmod g=r,o= file.txt    # Set group to read-only, others to none
```

### umask (User Mask) - Default Permissions

#### How umask Works

The umask value determines default permissions for newly created files and directories:

```bash
# Check current umask
umask          # Shows current value (usually 0022)

# Set umask
umask 007      # More restrictive
umask 022      # Remove write permissions for group and others
```

**Default Values:**
- Files: `666` (rw-rw-rw-) - umask subtracted = final permissions
- Directories: `777` (rwxrwxrwx) - umask subtracted = final permissions

```diff
! Default Calculation:
  Base file permissions: 666 (rw-rw-rw-)
  Current umask: 022
  Result: 666 - 022 = 644 (rw-r--r--)

  Base directory permissions: 777 (rwxrwxrwx)
  Current umask: 022
  Result: 777 - 022 = 755 (rwxr-xr-x)
```

### Directory vs File Permissions

```diff
+ Directory Permissions:
  - r: List directory contents
  - w: Create/delete files in directory  
  - x: Access directory (cd command)

+ File Permissions:
  - r: Read file contents
  - w: Modify file contents
  - x: Execute/run file
```

**Important:** Execute permission on a directory is required to access it, even if you have read access.

### Advanced Permission Techniques

#### Recursive Permission Changes

```bash
# Change permissions recursively
chmod -R 755 /home/user/shared/
chmod -R g+rw data/    # Add read/write for group on all files

# Change ownership recursively  
chown -R www-data:www-data /var/www/
```

#### Selective File Type Permissions

```bash
# Change permissions only for directories
find . -type d -exec chmod 755 {} \;

# Change permissions only for files
find . -type f -exec chmod 644 {} \;
```

#### Preserving Permissions During Copy

```bash
# Copy with permissions and timestamp preservation
cp -p source.txt destination.txt
cp -a /source/dir /destination/    # Archive mode (-p + -r)
```

### Lab Demos

#### Demo 1: Creating and Managing File Permissions

```bash
# Create a test file and examine permissions
echo "This is a test file" > test.txt
ls -l test.txt    # Shows default permissions

# Change permissions using numeric method
chmod 600 test.txt    # Owner: rw-, Group: ---, Others: ---
ls -l test.txt

# Add execute permission using symbolic method  
chmod u+x test.txt    # Owner: rwx, Group: ---, Others: ---
ls -l test.txt
```

#### Demo 2: Changing Ownership

```bash
# Change file owner (must be root)
su root
chown newuser test.txt

# Change both owner and group
chown newuser:newgroup test.txt

# Verify changes
ls -l test.txt
```

#### Demo 3: Directory Permissions and Access

```bash
# Create directory and set restrictive permissions
mkdir private
chmod 700 private    # Owner: rwx, Others: ---

# Test access as different users
su user1
cd private    # Should fail with "Permission denied"
ls private    # Should work (read permission on parent)

# Add execute permission to allow directory access
chmod o+x /parentdir  # Allows others to access directory
```

### Common Permission Scenarios

#### 1. Web Server Files
```bash
# Apache/Nginx web files
chmod 644 *.php *.html    # rw-r--r--
chmod 755 *.sh           # rwx-r-x-r-x (execute scripts)
chown www-data:www-data /var/www/
```

#### 2. Shared Directory
```bash
# Allow group collaboration
chmod 775 shared/        # Owner/Group: rwx, Others: r-x
chgrp developers shared/
```

#### 3. Private Files  
```bash
# Personal sensitive files
chmod 600 ~/.ssh/id_rsa
chmod 700 ~/.ssh/
```

### Summary

#### Key Takeaways
```diff
+ File permissions = Type + Owner(3) + Group(3) + Other(3) = 10 characters total
+ Numeric: r=4, w=2, x=1, -=0 (max 777 for directories, 666 for files)
+ Symbolic: u=user, g=group, o=other, +=add, -=remove, ==set
+ Directories need 'x' permission to access them
+ Default permissions determined by umask (022 commonly)
+ chown changes ownership, chgrp changes group, chmod changes permissions
```

#### Quick Reference
```bash
# Check my group memberships
id          # Shows UID, GID, and all groups

# Find files with specific permissions
find /path -perm 777    # Files with full permissions
find /path -user username    # Files owned by user
find /path -group groupname  # Files owned by group

# Change umask permanently (add to ~/.bashrc)
umask 002      # Remove write for others only
```

#### Expert Insight

**Real-world Application:** Linux file permissions are critical in multi-user environments like web servers, shared development machines, and production systems. They prevent unauthorized access while allowing necessary collaboration through group permissions.

**Expert Path:** Master ACLs (Access Control Lists) for advanced scenarios where standard permissions aren't sufficient. Learn SELinux/AppArmor for mandatory access controls beyond discretionary permissions.

**Common Pitfalls:**
- ❌ Forgetting that directories need execute permission to access
- ❌ Setting 777 permissions on files - creates security risks  
- ❌ Not understanding umask impact on default permissions
- ❌ Using numeric permissions without understanding binary conversion
- ❌ Not preserving permissions during file operations with -p flag

</details>
