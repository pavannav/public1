# Section 05: Working With Directories In Linux / Manage Directories in RHEL 8

<details open>
<summary><b>Section 05: Working With Directories In Linux / Manage Directories in RHEL 8 (CL-KK-Terminal)</b></summary>

## Table of Contents

- [Present Working Directory (pwd)](#present-working-directory-pwd)
- [Change Directory (cd)](#change-directory-cd)
- [Path Types - Absolute vs Relative](#path-types---absolute-vs-relative)
- [Tab Completion](#tab-completion)
- [List Directory Contents (ls)](#list-directory-contents-ls)
- [Long Listing (ls -l)](#long-listing-ls--l)
- [Hidden Files and Human Readable Format](#hidden-files-and-human-readable-format)
- [Create Directory (mkdir)](#create-directory-mkdir)
- [Remove Directory (rmdir and rm -rf)](#remove-directory-rmdir-and-rm--rf)
- [Practical Examples](#practical-examples)

## Present Working Directory (pwd)

### Overview
The `pwd` command displays the full path of your current working directory, showing exactly where you are in the file system hierarchy.

### Key Concepts
- **Purpose**: Shows the absolute path from root (/) to your current location
- **Output**: Displays the path starting from `/` (root directory)
- **Usage Context**: Essential when you need to confirm your current location, especially in deep directory structures

### Code Examples
```bash
pwd
```
Output: `/home/user` (example for normal user)

### Lab Demos
1. Start in your home directory and run `pwd`
2. Navigate to `/etc` using `cd /etc` then run `pwd` to verify location

## Change Directory (cd)

### Overview
The `cd` command allows you to navigate between directories in the Linux file system. It supports both absolute and relative paths for flexible navigation.

### Key Concepts
- **Basic Usage**: `cd [directory_path]` moves you to specified location
- **Home Directory Navigation**: `cd` alone or `cd ~` takes you to user's home directory
- **Parent Directory Navigation**: `cd ..` moves up one level
- **Previous Location**: `cd -` returns to previously visited directory

### Code Examples
```bash
# Change to /etc directory
cd /etc

# Return home
cd
# or
cd ~

# Move up one directory level
cd ..

# Return to previous directory
cd -
```

| Command | Description | Example Path |
|---------|-------------|--------------|
| `cd /absolute/path` | Full path from root | `cd /var/log` |
| `cd relative/path` | Path relative to current location | `cd Documents/Projects` |
| `cd ..` | Parent directory | Moves up one level |
| `cd -` | Previous directory | Returns to last location |

### Common Patterns
- Use `cd /` to reach root directory
- Use `cd ../..` to go up two levels

## Path Types - Absolute vs Relative

### Overview
Linux uses two path types for navigation: absolute paths provide complete routes from root, while relative paths are relative to your current position.

### Key Concepts
- **Absolute Path**: Full path starting from `/` root directory
- **Relative Path**: Partial path relative to current working directory
- **Current Directory Indicator**: `.` represents your current directory
- **Parent Directory Indicator**: `..` represents the directory above your current one

### Code Examples
```bash
# Absolute path navigation
cd /home/user/Documents

# Relative path navigation (if currently in /home)
cd user/Documents

# Using relative indicators
cd ./mydir    # Stay in current and enter mydir
cd ../otherdir  # Go up one level, then enter otherdir
```

### Real-World Application
Absolute paths are used for:
- System scripts
- Configuration files pointing to fixed locations
- Cron jobs

Relative paths are preferred for:
- User-level navigation
- Scripts that should work regardless of execution location
- Project-specific commands

## Tab Completion

### Overview
Tab completion automatically completes directory and file names when you press the Tab key, significantly speeding up command-line navigation.

### Key Concepts
- **Functionality**: Press Tab after typing partial path to auto-complete
- **Multiple Matches**: Press Tab twice to see all matching options
- **Directory Detection**: Distinguishes between files and directories
- **Path Resolution**: Works with both absolute and relative paths

### Code Examples
```bash
# Start typing and press Tab
cd /var/lo[Tab]  # Completes to /var/log/
cd Doc[Tab]     # If in home, completes to Documents/

# See multiple options
ls /etc/[Tab][Tab]  # Shows all files in /etc/
```

## List Directory Contents (ls)

### Overview
The `ls` command lists files and directories in your current or specified location, providing basic visibility into file system contents.

### Key Concepts
- **Basic Listing**: Shows all visible files and directories
- **Path Specification**: `ls [path]` lists contents of specific directory
- **Output Format**: Sorted alphabetically by default
- **Hidden Files Exclusion**: Doesn't show files starting with `.`

### Code Examples
```bash
# List current directory contents
ls

# List specific directory
ls /home/user/Documents

# List with path indication
ls -p  # Shows directories with trailing /
```

## Long Listing (ls -l)

### Overview
The `ls -l` command provides detailed information about files and directories, including permissions, ownership, size, and timestamps.

### Key Concepts
- **Permission Details**: Shows read/write/execute permissions for user/group/others
- **File Type Indicators**: 
  - `d` for directory
  - `-` for regular file
  - `l` for symbolic link
- **Ownership Information**: Shows owner and group names
- **Size Information**: File size in bytes
- **Timestamp**: Last modification time

### Code Examples
```bash
ls -l
```

Sample output format:
```
drwxr-xr-x  2 user group 4096 Jan 15 10:30 Documents
-rw-r--r--  1 user group 1024 Jan 14 15:45 file.txt
```

| Column | Description |
|--------|-------------|
| `d rwx r-x r-x` | File type and permissions |
| `2` | Number of links |
| `user` | Owner name |
| `group` | Group name |
| `4096` | Size in bytes |
| `Jan 15 10:30` | Modification date/time |
| `Documents` | File/directory name |

> [!NOTE]
> The first character indicates file type, followed by three permission groups of three characters each (rwx).

## Hidden Files and Human Readable Format

### Overview
Linux uses dot-files (starting with `.`) for configuration and system files. The `-h` option makes file sizes more readable for humans.

### Key Concepts
- **Hidden Files**: Files starting with `.` are hidden from normal `ls`
- **Hidden File Listing**: Use `ls -a` to show all files including hidden
- **Human Readable**: `-h` converts bytes to KB/MB/GB
- **Dot and Double Dot**: Every directory contains `.` (current) and `..` (parent)

### Code Examples
```bash
# Show hidden files
ls -a

# Long listing with hidden files
ls -la

# Human readable file sizes
ls -lh

# Combine all options
ls -lah
```

### Common Hidden Files
- `.bashrc` - Shell configuration
- `.profile` - User profile
- `.ssh/` - SSH keys and configuration

## Create Directory (mkdir)

### Overview
The `mkdir` command creates new directories in the file system with support for single or nested directory creation.

### Key Concepts
- **Basic Creation**: `mkdir directory_name` creates single directory
- **Parent Directory Option**: `-p` creates nested directory structures
- **Path Support**: Works with both absolute and relative paths

### Code Examples
```bash
# Create single directory
mkdir mydir

# Create nested directories
mkdir -p parent/child/grandchild

# Create multiple directories
mkdir dir1 dir2 dir3
```

### Real-World Application
Use `mkdir -p` when creating directory structures for:
- Project setups
- Log files organization
- Backup directory hierarchies

## Remove Directory (rmdir and rm -rf)

### Overview
Directory removal requires careful consideration as Linux doesn't have an "undelete" feature. Use `rmdir` for empty directories and `rm -rf` with extreme caution.

### Key Concepts
- **rmdir**: Removes empty directories only
- **rm -rf**: Removes directories with contents (recursive and force)
- **Safety Measures**: Never run `rm -rf /` or similar destructive commands
- **Confirmation**: Use `rm -rf -i` to confirm each deletion

### Code Examples
```bash
# Remove empty directory
rmdir emptydir

# Force remove directory with contents (CAUTION!)
rm -rf dir_with_content

# Confirm before deletion
rm -rf -i dir_with_content
```

> [!IMPORTANT]
> `rm -rf` is extremely dangerous. Always double-check your path before executing.

> [!WARNING]
> Never run commands like `rm -rf /*` or `rm -rf /etc`. These can destroy your system completely.

## Practical Examples

### Overview
Common scenarios combining directory management commands demonstrate practical Linux directory operations.

### Key Examples

```bash
# Create a project structure
mkdir -p ~/Projects/website/{css,js,images}
cd ~/Projects/website

# List the structure
ls -la

# Create a backup directory and copy files
mkdir -p ../backup
cp -r * ../backup/

# Clean up temporary files
rm -rf /tmp/old_session_*

# Navigate complex paths
cd /var/log && ls -lh | grep -i error
```

## Summary

> [!IMPORTANT]
> Directory management is fundamental to Linux administration. Always know your current location (`pwd`), use tab completion for efficiency, and exercise extreme caution with destructive commands like `rm -rf`.

### Key Takeaways
```diff
+ pwd shows your exact location in the file system
+ cd supports both absolute and relative path navigation
+ Tab completion speeds up command entry
+ ls -l provides detailed file information including permissions
+ mkdir -p creates nested directory structures safely
- Never run rm -rf / or similar destructive commands
! Always confirm paths before using rm -rf
```

### Quick Reference
```bash
# Navigation
pwd                                    # Show current directory
cd /path/to/directory                  # Change to absolute path
cd relative/path                       # Change to relative path
cd                                    # Go to home directory
cd -                                   # Go to previous location
cd ..                                 # Go up one directory level

# Listing
ls                                     # List current directory
ls -l                                  # Long listing
ls -a                                  # Show hidden files
ls -h                                  # Human readable sizes
ls -lah                                # Combine all options

# Directory Management
mkdir dirname                          # Create single directory
mkdir -p parent/child/grandchild      # Create nested directories
rmdir emptydir                        # Remove empty directory
rm -rf dirname                        # Remove directory with contents (CAUTION!)
```

### Expert Insight

**Real-world Application**: In production server management, directory structures are carefully planned for backups, logs, configurations, and user data. Commands like `mkdir -p` are essential for automated deployment scripts that need to create directory hierarchies reliably.

**Expert Path**: Master path completion and relative navigation - they dramatically improve efficiency. Learn to combine commands with pipes (e.g., `ls -la | grep pattern`) for powerful file system analysis.

**Common Pitfalls**: 
- Forgetting to use `rm -rf -i` for confirmation in scripts
- Not understanding the difference between absolute and relative paths
- Running destructive commands from root directory
- Not checking disk space before creating large directory structures

</details>

> Note: No corrections were needed for misspelled technical terms in the transcript. The Hindi-English mixed transcript was converted to clean English technical content.
