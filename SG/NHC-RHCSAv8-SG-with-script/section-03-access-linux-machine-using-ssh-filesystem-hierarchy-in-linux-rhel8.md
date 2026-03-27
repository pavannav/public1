# Section 03: Linux File System and Basic Administration

<details open>
<summary><b>Section 03: Linux File System and Basic Administration (CL-KK-Terminal)</b></summary>

**Table of Contents**
- [Virtual Machine Templates](#virtual-machine-templates)
- [File System Structure](#file-system-structure)
- [Remote Access with SSH/Mobile Xtend](#remote-access-with-sshmobile-xtend)
- [Basic Commands and File Operations](#basic-commands-and-file-operations)
- [User Accounts and Permissions](#user-accounts-and-permissions)
- [System Management Directories](#system-management-directories)
- [Summary](#summary)

## Virtual Machine Templates

### Overview
Virtual machine templates allow quick deployment of pre-configured Linux environments in RHEL/CentOS for training purposes. Templates preserve the exact state of the VM, enabling rapid cloning without reconfiguration. This approach saves time and ensures consistency in development and training setups.

### Key Concepts

The instructor demonstrates creating a template from an existing VM:

1. **Template Creation Process**:
   - Clone an existing VM to preserve the current state
   - Use VMware vSphere Client for the process
   - Right-click VM → Manage → Clone → Clone to Template

   ```bash
   # RHEL VM template naming convention
   Template-Name: training-linux-fresh-state
   ```

2. **Template Benefits**:
   - Quick VM deployment in seconds vs. hours for fresh installation
   - Eliminates repetitive setup tasks
   - Industry standard for infrastructure automation

   > [!NOTE]
   > Templates should be created from a clean, base-configured state to avoid inconsistencies.

## File System Structure

### Overview
Linux file system follows a hierarchical tree structure starting from the root directory (/). Understanding the purpose of each directory is crucial for effective system administration and troubleshooting. The instructor highlights key directories essential for system operation.

### Key Concepts

The Linux file system is organized into standardized directories:

#### Root Directory (/) - Foundation
- Single tree structure unlike Windows (C:\, D:\)
- All directories branch from /
- Represents the entire file system

```bash
# Representation of file system tree
/
├── bin/
├── dev/
├── home/
├── usr/
└── var/
```

#### Key Directories Explained

**Binary Directories (/bin, /usr/bin, /sbin, /usr/sbin)**:
- Store executable programs and commands
- `/bin`: Essential user commands (ls, cd, mkdir)
- `/sbin`: Administrative commands requiring root privileges
- `/usr/bin`: Additional user commands installed post-setup

**Device Files (/dev)**:
- Hardware representation as files
- Examples: `/dev/sda` (storage), `/dev/cdrom` (optical drive)
- Kernel-managed, not traditional files

**Library Directories (/lib, /lib64, /usr/lib)**:
- Shared libraries required for program execution
- Architecture-specific (32-bit vs 64-bit)
- Critical for application compatibility

**Home Directory (/home)**:
- User personal space for documents and settings
- Each user gets `/home/[username]` directory
- Contains: Desktop, Downloads, Documents folders

**System Directories (/usr, /var)**:
- `/usr`: User applications, libraries, and documentation
- `/var`: Variable data like logs (`/var/log`), caches, mail
- `/proc`: Kernel and process information (auto-generated)

**Root User Home (/root)**:
- Root user's personal directory
- Maintained separately for security

#### Directory Navigation Commands

```bash
# Essential commands for file system exploration
cd /               # Go to root directory
ls -l              # List files with permissions, size, dates
ll                 # Alias for ls -l (commonly available in RHEL)
```

> [!IMPORTANT]
> Use absolute paths when accessing system files to ensure correct location, especially in scripts.

## Remote Access with SSH/Mobile Xtend

### Overview
Remote access is essential for Linux administration. The session demonstrates both graphical and command-line remote connectivity methods, comparing their use cases in infrastructure management.

### Key Concepts

#### Remote Login Methods

**SSH (Secure Shell)**:
- Command-line based secure connection
- Default on Linux systems
- Port 22 (firewall configuration required)

```bash
# SSH connection syntax
ssh root@192.168.1.100
# Enter password or use key-based authentication
```

**Mobile Xtend (Graphical)**:
- Provides full GUI desktop access
- Useful for visual administration tasks
- Requires separate setup

   ```diff
   + Advantages: Full GUI access, visual administration
   - Limitations: Bandwidth intensive, slower than CLI
   ```

#### Connection Process Demonstration
1. Identify VM IP address (`ip addr show` or `ifconfig`)
2. Configure SSH service (enabled by default on RHEL 8)
3. Verify firewall settings for SSH port

> [!NOTE]
> CLI access preferred for production environments due to efficiency and automation capabilities.

## Basic Commands and File Operations

### Overview
Command-line mastery is fundamental to Linux administration. The instructor demonstrates practical file creation, modification, and management tasks with real-time examples.

### Key Concepts

#### File Creation and Manipulation

```bash
# Create directories
mkdir test-files
cd test-files

# Create text files
echo "Sample content" > sample.txt
cat > message.txt << EOF
Welcome to Linux training
EOF

# Read files
cat message.txt      # Display content
less message.txt     # Paginated view (q to quit)
head message.txt     # First 10 lines
tail message.txt     # Last 10 lines

# Remove files (caution!)
rm sample.txt
```

#### File System Mounting
- Mounting makes external devices accessible
- Auto-mounting common for removable media
- Manual mounting required for fixed devices

```bash
# Mount example (varies by distribution)
mount /dev/cdrom /mnt
cd /mnt
ls -la
```

> [!WARNING]
> Always unmount devices before physical removal to prevent data corruption.

## User Accounts and Permissions

### Overview
Linux implements strict user isolation for security. The session covers user login, permission systems, and the differences between normal and root accounts. Root privileges (UID 0) provide unrestricted system access.

### Key Concepts

#### Account Types

**Normal User Account**:
- Prompt: `username@hostname $`
- Limited permissions
- Cannot access restricted system files

**Root User Account (Administrator)**:
- Prompt: `username@hostname #`
- UID: 0 (all permissions)
- Can modify any system component

```diff
+ Default standard: Normal user for daily tasks
- Root risks: Potential system damage, security vulnerabilities
! Security practice: Use sudo for specific administrative tasks
```

#### Permission System
- Files have owner, group, and world permissions
- Represented as: `-rw-r--r--` (file type, owner, group, world)

```bash
# Check permissions
ls -l filename

# Permission symbols:
# r = read (4), w = write (2), x = execute (1)
# - = no permission

# Example: drwxr-xr-
# Directory (d), owner rwx, group rx, world r, no world w/execute
```

#### Switching Users
```bash
# Switch to different user (requires password)
su username

# Switch to root
su - root
# OR
sudo -i
```

> [!IMPORTANT]
> Normal users cannot perform administrative tasks. Use `sudo` or switch to root only when necessary.

## System Management Directories

### Overview
Standardized directory purposes enable predictable system administration. The instructor provides practical navigation examples and explains the role of each major directory in system operation.

### Key Concepts

#### Directory Purposes and Locations

| Directory | Purpose | Content Examples |
|-----------|---------|-----------------|
| `/bin` | Essential commands | `ls`, `cd`, `mkdir`, `rm` |
| `/sbin` | System administration | `iptables`, `fdisk`, `mkfs` |
| `/lib` | Shared libraries | `.so` files for program dependencies |
| `/usr` | User applications | Compilers, additional tools |
| `/var` | Variable data | Logs, databases, print queues |
| `/etc` | Configuration files | System and application configs |
| `/home` | User directories | Personal files, settings |
| `/tmp` | Temporary files | Cache, session files (auto-cleaned) |
| `/opt` | Optional software | Third-party applications |

#### Navigation Examples

```bash
# Explore key directories
cd /var/log; ls          # System logs
cd /etc; ls              # Configuration files
cd /usr/bin; ls | head   # Available commands
```

> [!NOTE]
> The Federal Standard (FHS) defines these directory purposes for Linux distributions.

### Lab Demo: ISO Mounting and Package Access

Mount RHEL installation ISO to access package repositories:

```bash
# Mount ISO for package access
mkdir /mnt/rhel-iso
mount /dev/cdrom /mnt/rhel-iso
cd /mnt/rhel-iso

# Access packages
ls Packages/
```

This technique enables offline package installation and dependency resolution.

## Summary

### Key Takeaways
```diff
+ Linux file system is unified hierarchical structure starting at /
+ Root user (# prompt) has unlimited access vs normal users ($ prompt)
+ Remote access via SSH CLI preferred for production administration
+ Correct directory knowledge prevents misplaced files and configuration errors
+ Templates save deployment time in virtualized environments
- Never use root for routine tasks to avoid accidental system damage
! Understand permissions (owner/group/world) before modifying system files
! Always verify path locations when working with critical directories
📝 Practice CLI navigation daily to build instinctive system awareness
💡 Templates and remoting techniques scale efficiently in enterprise environments
```

### Quick Reference

**Essential Commands**:
- `cd /path` - Change directory
- `ls -la` - List all files with details  
- `pwd` - Show current directory
- `mkdir folder` - Create directory
- `touch file.txt` - Create empty file
- `cat file.txt` - Display file content

**Directory Quick Map**:
- `/bin`: User binaries
- `/sbin`: System binaries  
- `/lib`: System libraries
- `/usr`: User programs
- `/var`: Variable files (logs, cache)
- `/etc`: Configurations
- `/home`: User homes
- `/tmp`: Temporary files

### Expert Insight

**Real-world Application**:
In production Linux servers, file system knowledge is critical for security auditing. Administrators regularly check `/var/log` for anomalies, ensure `/etc` contains proper configurations, and use `/usr` for application deployments. Understanding directory permissions prevents privilege escalation attacks.

**Expert Path**:
Master file system navigation through daily practice. Learn advanced commands like `find`, `locate`, and `rsync` for efficient file management. Understand SELinux contexts in RHEL for enterprise security.

**Common Pitfalls**:
- Running administrative commands as normal user → permission denied
- Modifying critical files in `/etc` without backups → system instability  
- Not unmounting devices before ejection → data corruption
- Storing temporary files in persistent locations → disk space issues

</details>
