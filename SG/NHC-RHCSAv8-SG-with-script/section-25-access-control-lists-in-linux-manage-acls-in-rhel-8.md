# Section 25: Access Control Lists (ACLs) 

<details open>
<summary><b>Section 25: Access Control Lists (ACLs) (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Owner File Editing in Editors](#owner-file-editing-in-editors)
- [Special Permissions Management](#special-permissions-management)
- [File System ACL Support](#file-system-acl-support)
- [Applying ACL Permissions](#applying-acl-permissions)
- [Viewing ACL Configurations](#viewing-acl-configurations)
- [ACL Mask Management](#acl-mask-management)
- [Removing ACL Entries](#removing-acl-entries)
- [Disable ACL Support](#disable-acl-support)
- [ACLs vs Standard vs Advanced Permissions](#acls-vs-standard-vs-advanced-permissions)
- [Summary](#summary)

## Owner File Editing in Editors

### Overview
Learn about a critical security feature where file owners can modify their files using editors, even when they lack explicit read/write permissions on the file.

### Key Concepts

The file owner always retains the ability to edit their own files in text editors, regardless of file permissions set.

#### Demonstration
```bash
# Create a test file with no permissions for owner/group/others
chmod 000 testfile.txt

# Even with no permissions, owner can edit in vim
vim testfile.txt
# Edit and save changes - this works!
```

**Note:** This only works when using editors. Direct `cat` or other read commands will still fail.

#### Why This Matters
This flexibility prevents owners from completely losing access to their files if permissions are accidentally restricted.

> [!IMPORTANT]
> This feature provides a safety net for file owners, ensuring they can always access and modify their content when needed, even during permission mishaps.

## Special Permissions Management

### Overview
Explore how to set, view, and remove special permissions like setuid (SUID) and setgid (SGID) on files and directories.

### Key Concepts

Special permissions provide enhanced file access capabilities beyond standard read/write/execute permissions.

#### Setting Special Permissions

```bash
# Set SUID on executable file
chmod u+s executable

# Set SGID on directory  
chmod g+s directory

# Combined with numeric permissions (4 = SUID, 2 = SGID, 1 = sticky)
chmod 4755 suid_executable  # SUID + rwx for owner, rx for group/other
chmod 2755 sgid_executable  # SGID + rwx for owner, rx for group/other
chmod 1755 sticky_file      # sticky + rwx for owner, rx for group/other
```

#### Removing Special Permissions
```bash
# Remove SUID
chmod u-s file

# Remove SGID  
chmod g-s file

# Alternative: Set all permissions and add sticky (requires specific format)
chmod 755 file
chmod +x file  # This maintains permissions but removes special bits
```

### Lab Demo: Special Permissions Management

1. Create a test file and set special permissions
2. Verify permissions with `ls -l`
3. Attempt removal using different methods
4. Confirm final state

## File System ACL Support

### Overview
Understand how to verify if your file system supports Access Control Lists and configure ACL functionality.

### Key Concepts

ACLs require file system support to function. Most modern Linux file systems support ACLs by default.

#### Checking ACL Support
```bash
# View file system features
tune2fs -l /dev/sda1 | grep acl

# Look for "acl" in /proc/fs/ filesystem support list
cat /etc/fstab  # Check mount options for acl
```

**Expected Output:**
```
Default mount options:    acl,user_xattr
```

> [!NOTE]
> Root file system typically has ACL support enabled. If needed, add `acl` to mount options in `/etc/fstab`:

```bash
# Example fstab entry with ACL support
/dev/mapper/rootvg-rootlv / ext4 defaults,acl 0 1
```

## Applying ACL Permissions

### Overview
Learn to use the `setfacl` command to grant specific permissions to individual users and groups beyond standard permissions.

### Key Concepts

ACLs allow fine-grained permission control impossible with standard Unix permissions.

#### Basic ACL Commands

```bash
# Grant read-only access to specific user
sudo setfacl -m u:username:r file

# Grant read/write access to specific group
sudo setfacl -m g:groupname:rw file

# Grant full access (read/write/execute)
sudo setfacl -m u:username:rwx file

# multiple users with different permissions:
sudo setfacl -m u:user1:r,g:group1:rw,u:user2:rx file
```

#### ACL Permission Types
- `r` - Read permission
- `w` - Write permission  
- `x` - Execute permission
- `rw` - Read and write
- `rx` - Read and execute
- `wx` - Write and execute
- `rwx` - Full permissions

### Lab Demo: Applying ACL to Resolve Permission Issues

Consider a scenario with three users:
- Owner: root (full permissions)  
- User `developer`: needs read/write/execute
- User `tester`: needs read-only access
- Group `developers`: needs full access

```bash
# Set base permissions (owner full, others none)
sudo chmod 700 myapp

# Add specific user permissions
sudo setfacl -m u:developer:rwx myapp
sudo setfacl -m u:tester:r myapp  
sudo setfacl -m g:developers:rwx myapp
```

## Viewing ACL Configurations

### Overview  
Use `getfacl` to view detailed ACL permissions and mask information.

### Key Concepts

The `getfacl` command reveals the complete ACL configuration, including user, group, and mask settings.

#### Basic ACL Viewing
```bash
# View ACL on a file
getfacl filename

# Example output:
# file: filename
# owner: root
# group: root
# user::rwx
# group::---
# other::---
# user:developer:rwx
# group:developers:rwx
# mask::rwx
```

#### Understanding the Output
- `user::rwx` - Owner permissions (standard)
- `group::---` - Owner group permissions (standard)
- `other::---` - Other users permissions (standard)
- `user:developer:rwx` - ACL entry for specific user
- `group:developers:rwx` - ACL entry for specific group
- `mask::rwx` - ACL mask (effective permission ceiling)

## ACL Mask Management

### Overview
Understand how the ACL mask controls the maximum effective permissions for ACL entries.

### Key Concepts

The mask acts as an upper bound on permissions granted through ACL entries.

#### How Mask Works

```bash
# Example with mask r-x:
# user::rwx         # Standard owner permissions
# user:tester:rwx   # ACL permits rwx
# mask::r-x         # Maximum effective permission = r-x
# Result: tester gets r-x, not rwx
```

#### Preventing Automatic Mask Calculation
```bash
# Don't recalculate mask when adding entry
sudo setfacl -m --mask mask_value u:user1:rw file

# Set custom mask value  
sudo setfacl -m --mask mask_value u:user1:rw file
```

> [!NOTE]
> By default, `setfacl` automatically recalculates the mask when ACL entries are modified. Use `--mask` flag to prevent this behavior and set custom mask values.

## Removing ACL Entries

### Overview
Learn to remove specific ACL entries or completely clear all ACL configurations.

### Key Concepts

ACL management includes selective removal of individual entries and bulk ACL clearing.

#### Removing Individual ACL Entries

```bash
# Remove specific user ACL entry
sudo setfacl -x u:username file

# Remove specific group ACL entry  
sudo setfacl -x g:groupname file
```

#### Clearing All ACLs
```bash
# Remove entire ACL from file
sudo setfacl -b file

# Use for mount table update
sudo mount -o remount /mountpoint
```

## Disable ACL Support

### Overview
Learn when and how to disable ACL support on specific file systems.

### Key Concepts

ACL support can be disabled by modifying file system mount options, primarily for compatibility or performance reasons.

#### Disabling ACLs

```bash
# Add to /etc/fstab to disable ACLs
/dev/sda1 /mount ext4 defaults,noacl 0 0

# Remount with noacl option
sudo mount -o remount,noacl /mountpoint
```

> [!WARNING]
> Never disable ACLs on root file system. Only disable on specific mount points when necessary for compatibility.

## ACLs vs Standard vs Advanced Permissions

### Overview
Understand the differences and complementary relationships between permission systems.

### Key Concepts

Linux offers three layers of permission management, each serving different scenarios.

| Permission Type | Use Case | Limitations |
|----------------|----------|-------------|
| **Standard (rwx)** | Basic file access control | Max 1 group, all-or-nothing permissions |
| **Advanced (SUID/SGID)** | Special access scenarios | Limited to executables/directories |
| **ACL (Access Control Lists)** | Fine-grained access | File system support required |

### When to Use Each

```diff
+ Standard Permissions: Simple local file access
+ Advanced Permissions: Executable privileges, directory inheritance  
+ ACLs: Complex multi-user/multi-group scenarios
```

### Lab Demo: Choosing the Right Permission System

1. **Standard Permissions Scenario:**
   - File: `config.txt` 
   - Requirements: Owner read/write, group read-only
   - Solution: `chmod 640 config.txt`

2. **Advanced Permissions Scenario:**
   - Directory: `/shared/docs`
   - Requirements: New files inherit group ownership
   - Solution: `chmod g+s /shared/docs`

3. **ACL Scenario:**
   - File: `app.log`
   - Requirements: developer1+2 full access, auditor1 read-only
   - Solution: ACL entries for specific users

## Summary

### Key Takeaways
```diff
+ ACLs extend standard Unix permissions for complex access control
+ File owners retain edit access in editors regardless of permissions  
- ACLs require file system support; enabled by default on ext4
+ setfacl -m (modify), getfacl (view), setfacl -x (remove)
- Mask limits effective ACL permissions and recalculates automatically
+ ACL entries: u:username:perms, g:groupname:perms format
! Always test ACL changes in non-production environments first
```

### Quick Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `getfacl` | View ACL permissions | `getfacl file.txt` |
| `setfacl -m` | Add/modify ACL entry | `setfacl -m u:user:rw file.txt` |
| `setfacl -x` | Remove ACL entry | `setfacl -x u:user file.txt` |
| `setfacl -b` | Remove all ACLs | `setfacl -b file.txt` |
| `chmod u+s` | Set SUID | `chmod u+s executable` |

### Expert Insight

**Real-world Application**: ACLs are essential in enterprise environments with complex user hierarchies. Use them for shared development environments, multi-tenant applications, and compliance scenarios requiring detailed access logs.

**Expert Path**: Master ACL scripting with `setfacl` automation and integrate into deployment pipelines. Learn advanced mount options and performance implications of ACL usage patterns.

**Common Pitfalls**: 
- Forgetting file system ACL support requirements
- Accidental mask recalculation removing intended permissions  
- Not backing up complex ACL configurations before bulk changes
- Overusing ACLs when standard permissions would suffice

</details>
