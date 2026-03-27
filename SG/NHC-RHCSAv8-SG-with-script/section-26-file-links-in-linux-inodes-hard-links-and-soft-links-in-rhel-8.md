# Section 26: File Links - Hard Links and Soft Links

<details open>
<summary><b>Section 26: File Links - Hard Links and Soft Links (CL-KK-Terminal)</b></summary>

## Table of Contents

- [File System Access Control Lists (ACLs)](#file-system-access-control-lists-acls)
- [Inodes in File Systems](#inodes-in-file-systems)
- [Hard Links](#hard-links)
- [Soft Links (Symbolic Links)](#soft-links-symbolic-links)
- [Practical Demonstration](#practical-demonstration)
- [Link Management Commands](#link-management-commands)

## File System Access Control Lists (ACLs)

### Overview
Access Control Lists (ACLs) provide granular permissions beyond traditional owner/group/other model. In Linux file systems, ACLs allow multiple users and groups to have specific permissions on files and directories. This section explores how different file systems handle ACL support and why it's crucial for secure file access management.

### Key Concepts

ACLs define permissions for:
- **Multiple users**: Different users can have specific access rights
- **Multiple groups**: Groups beyond the owning group can have permissions
- **Default ACLs**: Automatically applied to newly created files in directories

### File System ACL Support Matrix

| File System | ACL Support | Disabling ACL |
|-------------|-------------|---------------|
| Ext4 | Enabled by Default | Cannot be disabled |
| XFS | Enabled by Default | Can be disabled |
| Btrfs | Recent versions support | Can be configured |

### Mounting File Systems with ACL Options

To mount a file system with specific ACL options:

```bash
# Mount with ACL support
mount -t ext4 /dev/sdb1 /mnt/data

# Check if ACL is enabled on a mounted file system
tune2fs -l /dev/sdb1 | grep features

# Enable ACL on ext4 file system (if not already enabled)
tune2fs -o acl /dev/sdb1
```

### Lab Demo: Working with ACLs

```bash
# Set ACL permissions on a file
setfacl -m u:user1:rwx,g:group1:r-- /path/to/file

# View ACL permissions
getfacl /path/to/file

# Remove ACL entry
setfacl -x u:user1 /path/to/file
```

## Inodes in File Systems

### Overview
Inodes (index nodes) are fundamental data structures that store metadata about files and directories. They contain all information about a file except its name and actual content. Understanding inodes is crucial for grasping how file systems manage data and links.

### Key Concepts

Inode components:
- **File metadata**: Size, permissions, timestamps, owner/group
- **Data pointers**: References to actual file data blocks
- **Reference count**: Number of hard links pointing to the inode

### Inode Number vs Reference Count

| Attribute | Description | Usage |
|-----------|-------------|--------|
| Inode Number | Unique identifier for file/directory | Unchangeable |
| Reference Count | Number of hard links | Increases with hard links |

### Finding File Inode Information

```bash
# Display inode number and details
ls -li /path/to/file

# Output format: permissions links owner group size date inode_number filename

# Search files by inode number
find /path -inum 12345

# Check inode usage on file system
df -i /mount/point
```

### Inode Allocation

> [!IMPORTANT]
> File systems have limited inodes. Large numbers of small files can exhaust inode space before disk space is full.

## Hard Links

### Overview
Hard links create multiple directory entries pointing to the same inode. Both entries are equally valid references to the file data. This differs from copies - hard links share the same underlying data block allocation.

### Key Concepts

Hard link characteristics:
- **Same inode number**: All hard links share identical inode
- **Same permissions and ownership**: Cannot differ between links
- **Same file size and timestamps**: Updates affect all links
- **Indistinguishable**: No visual difference between original and links

### Creating Hard Links

```bash
# Syntax: ln source_file link_name
ln original_file hard_link_name

# Example
ln calendar_original.txt calendar_hardlink.txt
```

### Hard Link Behavior

```diff
+ Both files share same inode (ls -i shows same number)
+ Reference count increases (ls -l shows link count > 1)
- Cannot create hard links between different file systems
! Deleting any link only decreases reference count, not actual data
```

## Soft Links (Symbolic Links)

### Overview
Soft links (symbolic links) create pointers to files or directories. Unlike hard links, symbolic links can cross file system boundaries and point to non-existent targets. They maintain separate inodes and can have different permissions.

### Key Concepts

Symbolic link characteristics:
- **Separate inode**: Different inode number from target
- **Can cross file systems**: Work between mounted partitions
- **Different permissions**: Can have own permission set
- **Broken links**: Become invalid if target is moved/deleted

### Creating Symbolic Links

```bash
# Syntax: ln -s target_path link_name
ln -s /full/path/to/target symbolic_link_name

# Example
ln -s /home/user/document.txt doc_softlink.txt
```

### Soft Link Detection

```bash
# Check if symbolic link (shows 'l' in permissions)
ls -l symbolic_link

# Output shows: lrwxrwxrwx -> /path/to/target

# Find broken symbolic links
find /path -type l -! -exec test -e {} \; -print
```

## Practical Demonstration

### Disk Preparation and Formatting

Format disk with ext4 and mount with ACL support:

```bash
# Format disk
mkfs.ext4 /dev/sdb

# Mount point setup
mkdir /express_dir
mount -t ext4 /dev/sdb /express_dir
```

### ACL Disable Attempt

> [!NOTE]
> Attempting to disable ACL in ext4 fails as it's not supported:

```bash
# This will fail on ext4
tune2fs -o ^acl /dev/sdb
# Error: tune2fs: Bad options specified
```

### Link Creation Examples

```bash
# Hard link within same file system
ln original.txt hard_link.txt

# Soft link (can cross file systems)
ln -s /mnt/other_fs/file.txt soft_link.txt

# Verify links
ls -li original.txt hard_link.txt soft_link.txt
```

### File Content Modification

```bash
# Modify through any link
echo "New content" > hard_link.txt
cat original.txt  # Shows new content

echo "More content" > soft_link.txt
cat original.txt  # Shows original content unchanged
```

## Link Management Commands

### Common Link Operations

```bash
# Remove any type of link
rm link_name

# Copy preserving links
cp -d source destination  # For hard links
cp -a source destination  # Preserve soft links

# Move/rename links
mv old_link new_link
```

### Link Status Checking

```bash
# Check link type and target
ls -l link_name

# Find all hard links to a file
find / -inum $(ls -i file.txt | awk '{print $1}')

# List all symbolic links in directory
ls -la | grep "^l"
```

## Summary

### Key Takeaways

```diff
+ ACLs provide advanced permission control in Linux file systems
- Ext4 does not allow disabling ACLs unlike XFS
! Inodes contain all file metadata except name and content
+ Hard links share inode and reference count
- Soft links can point across file systems and to non-existent files
! File system choice impacts link capabilities and ACL support
+ Both link types help organize and provide multiple access paths to data
```

### Quick Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `ln file1 file2` | Create hard link | `ln orig.txt link.txt` |
| `ln -s target link` | Create soft link | `ln -s /path/file link` |
| `ls -li` | Show inode numbers | `ls -li *.txt` |
| `find -inum N` | Find files by inode | `find . -inum 12345` |
| `getfacl file` | View ACL permissions | `getfacl /etc/passwd` |
| `setfacl -m u:user:rwx` | Set ACL permissions | `setfacl -m u:bob:rwx file` |

### Expert Insight

**Real-world Application**: In enterprise environments, use symbolic links for cross-filesystem access (like linking `/var/www/html` to `/mnt/storage/website`), while hard links excel at creating multiple directory entries for the same file without duplication.

**Expert Path**: Master advanced ACL commands like `setfacl` with recursive operations (`-R`) and default ACL inheritance. Learn `rsync` with `--link-dest` for efficient backups using hard links.

**Common Pitfalls**: Creating symbolic links with relative paths when absolute paths would be more robust; attempting hard links across file systems; forgetting ACL inheritance on directory creation.

</details>
