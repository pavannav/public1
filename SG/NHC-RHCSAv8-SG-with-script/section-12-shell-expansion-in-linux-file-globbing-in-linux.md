# Section 12: File Globbing and Command History Management

<details open>
<summary><b>Section 12: File Globbing and Command History Management (CL-KK-Terminal)</b></summary>

## Table of Contents
- [File Globbing Overview](#file-globbing-overview)
- [Wildcard Characters](#wildcard-characters)
- [Advanced Pattern Matching](#advanced-pattern-matching)
- [Preventing File Globbing](#preventing-file-globbing)
- [Command History Management](#command-history-management)
- [User Profile Configuration](#user-profile-configuration)
- [Summary](#summary)

## File Globbing Overview

File globbing, also known as dynamic file name generation, enables you to work with multiple files using patterns and wildcards when you don't know the exact filenames. This powerful feature replaces static filename lists with dynamic matching patterns.

### Key Concepts
- **Globbing**: The shell's process of expanding wildcard patterns to match filenames
- **Wildcards**: Special characters that match multiple characters in filenames
- **Pattern Expansion**: Shell expands patterns into lists of matching files before command execution

### Basic Usage
The asterisk (`*`) wildcard matches any sequence of characters (including none):

```bash
ls file*     # Lists all files starting with "file"
ls *file*    # Lists all files containing "file" anywhere
ls *         # Lists all files and directories
```

> [!NOTE]
> Globbing works with commands that operate on files like `ls`, `cp`, `mv`, etc.

## Wildcard Characters

### Asterisk (`*`) - Zero or More Characters
The most commonly used wildcard matches any sequence of characters:

```bash
ls file*.txt     # file1.txt, file123.txt, file-abc.txt
ls *.log         # all .log files
ls temp*         # temp, temp1, temp-file, etc.
```

### Question Mark (`?`) - Single Character
Matches exactly one character:

```bash
ls file?.txt     # file1.txt, fileA.txt (but not file12.txt)
ls ???           # exactly 3-character filenames
```

> [!IMPORTANT]
> Each `?` represents exactly one character position.

### Square Brackets (`[]`) - Character Class
Matches any single character within the specified set:

```bash
ls file[123].txt      # file1.txt, file2.txt, file3.txt
ls [abc]*             # files starting with a, b, or c
ls *[xyz]             # files ending with x, y, or z
```

## Advanced Pattern Matching

### Range Specifications
Use hyphens within square brackets for character ranges:

```bash
ls [a-z]*        # files starting with lowercase letters
ls [A-Z]*        # files starting with uppercase letters
ls [0-9]*        # files starting with digits
ls file[1-5].txt # file1.txt through file5.txt
```

### Negation with `!`
Exclude specific characters by placing `!` after opening bracket:

```bash
ls [!5]*          # files not starting with '5'
ls *[!abc]        # files not ending with a, b, or c
```

### Combined Patterns
Complex patterns can be created by combining multiple wildcards:

```bash
# Files starting with "file", then 2 digits, then any 3 characters
ls file[0-9][0-9]*

# Pattern: capital letter + any chars + number + any single char
ls [A-Z]*[0-9]?
```

### Multiple Character Combinations
When exact character positions are unknown, combine wildcards strategically:

```bash
# Unknown middle characters, known positions
ls file*[0-9]      # file followed by numbers somewhere

# With question marks for exact counts
ls file??[0-9].txt  # file + 2 chars + number + .txt
```

## Preventing File Globbing

### Escaping with Backslashes
Prevent globbing by preceding special characters with backslashes:

```bash
ls \*             # lists files literally named "*"
ls file\[1-3\]    # lists file literally named "file[1-3]"
```

### Using Quotes
Surround patterns in quotes to prevent expansion:

```bash
ls '*'           # lists files literally named "*"
ls "*.txt"       # does NOT expand - lists ".txt" literally
ls '*.txt'       # same effect with single quotes
```

> [!WARNING]
> The behavior differs based on quote usage. Double quotes still allow variable expansion but prevent globbing.

### Practical Application
When a directory contains tricky filenames with spaces, brackets, or wildcards:

```bash
# Wrong - will expand
cp *backup* /destination/

# Correct - prevents expansion
cp \*backup\* /destination/
# or
cp "*backup*" /destination/
```

## Command History Management

### Displaying Command History
The `history` command shows previously executed commands with line numbers:

```bash
history           # displays all history
history 10        # shows last 10 commands
```

### Adding Date/Time to History
Set the `HISTTIMEFORMAT` environment variable for timestamps:

```bash
# Temporary setting (current session only)
export HISTTIMEFORMAT="%d/%m/%y %T "

# Example formats:
# %d - day, %m - month, %y - year, %T - time (HH:MM:SS)
export HISTTIMEFORMAT="%F %T "    # 2023-12-25 14:30:45
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S " # same as above
```

### Deleting Specific History Entries
Remove individual commands by line number:

```bash
history -d 105     # delete line number 105
history -d 250-260 # delete range of lines
history -d 250 260 # delete multiple specific lines
```

### Clearing History Entirely
Remove all history entries:

```bash
history -c        # clear all history (memory only)
history -w        # write current history to file
rm ~/.bash_history # permanently delete history file
```

## User Profile Configuration

### Making History Changes Permanent
For personal user configuration:

1. Edit `~/.bashrc` or `~/.bash_profile`
2. Add the HISTTIMEFORMAT export line:

```bash
echo 'export HISTTIMEFORMAT="%F %T "' >> ~/.bashrc
source ~/.bashrc  # activate changes
```

### System-wide Configuration
For all users, edit `/etc/bash.bashrc` or `/etc/profile`:

```bash
# As root, edit system profile
sudo vim /etc/bash.bashrc
# Add: export HISTTIMEFORMAT="%F %T "

# Apply changes system-wide
source /etc/bash.bashrc
```

### User-specific vs System Configuration
- **User profiles** (`~/.bashrc`): Apply to specific user
- **System profiles** (`/etc/bash.bashrc`, `/etc/profile`): Apply to all users
- User settings can override system settings

### Disabling History Logging
To completely disable command history logging:

```bash
# Temporary (current session)
unset HISTFILE

# Permanent (set in profile)
echo 'unset HISTFILE' >> ~/.bashrc
# or
echo 'HISTSIZE=0' >> ~/.bashrc
```

> [!WARNING]
> Disabling history can be a security risk as it removes audit trail of executed commands.

## Summary

### Key Takeaways
- **File globbing** enables dynamic file selection using wildcard patterns
- **Asterisk (`*`)** matches zero or more characters
- **Question mark (`?`)** matches exactly one character  
- **Square brackets (`[]`)** match specified character sets or ranges
- **Backslashes and quotes** prevent undesired pattern expansion
- **HISTTIMEFORMAT** adds timestamps to command history
- **History management** allows viewing, deleting, and timestamping commands

### Quick Reference

#### Common Globbing Patterns
```bash
ls *          # All files
ls *.txt      # All .txt files
ls file?      # file + one character
ls [abc]*     # Starts with a, b, or c
ls *[xyz]     # Ends with x, y, or z
ls [1-9]*     # Starts with digit 1-9
```

#### History Commands
```bash
history                    # View all history
history 20                 # Last 20 commands  
export HISTTIMEFORMAT="%F %T "  # Add timestamps
history -d 105             # Delete line 105
history -c                 # Clear history
```

### Expert Insight

#### Real-world Application
File globbing is essential for system administration tasks:
- **Log rotation**: `mv /var/log/app*.log /archive/` 
- **Backup scripts**: `tar czf backup-$(date +%Y%m%d).tar.gz *.sql`
- **Batch processing**: `for file in *.mp4; do convert "$file" "${file%.mp4}.avi"; done`
- **Cleanup operations**: `rm *~` or `rm *.tmp`

#### Expert Path
Master globbing by practicing with real file systems:
- Create test directories with varied filename patterns
- Learn regular expressions alongside globbing (they complement each other)
- Study globbing differences in Bourne vs Bash shells
- Implement complex patterns in automation scripts

#### Common Pitfalls
- **Hidden files**: Globbing doesn't match files starting with `.` by default
- **Case sensitivity**: `[A-Z]` ≠ `[a-z]` in case-sensitive systems
- **Whitespace issues**: Always quote globbed paths: `for file in *.txt; do ...`
- **Special characters**: Escape `$`, `!`, and other shell metacharacters
- **Directory matching**: `*.txt` matches both files and directories ending with `.txt`

</details>
