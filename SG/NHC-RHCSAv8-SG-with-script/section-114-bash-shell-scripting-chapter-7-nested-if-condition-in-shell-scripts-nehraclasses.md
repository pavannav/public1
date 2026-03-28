# Section 114: Bash Shell Scripting - Nested Loop Conditions

<details open>
<summary><b>Section 114: Bash Shell Scripting - Nested Loop Conditions (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Revision of File Test Operators](#revision-of-file-test-operators)
- [What are Nested Loop Conditions?](#what-are-nested-loop-conditions)
- [Creating a Nested Condition Script](#creating-a-nested-condition-script)
- [Lab Demo: Appending Text to Files with Permission Checks](#lab-demo-appending-text-to-files-with-permission-checks)
- [Summary](#summary)

## Overview
In this section, we explore **nested loop conditions** in Bash shell scripting. We'll build upon conditional statements by placing one condition inside another to perform more complex logic checks. Specifically, we'll create a script that first checks if a file exists, then verifies write permissions before allowing text append operations.

Key focus: Understanding conditional nesting, file permission checks, and practical implementation for text manipulation in files.

## Revision of File Test Operators
Before diving into nested conditions, let's quickly revisit file test operators for permissions:

### Permission Flags
- `-r`: Checks read permissions
- `-w`: Checks write permissions  
- `-x`: Checks execute permissions

```bash
if [ -r file.txt ]; then
    echo "File is readable"
else
    echo "File is not readable"
fi
```

### Syntax
```bash
#!/bin/bash
if [ -r "$filename" ]; then    # Check read permission
    echo "$filename has read permissions"
else
    echo "$filename does not have read permissions"
fi
```

> [!TIP]
> Permission checks return true/false based on user/group/other permissions on the file.

## What are Nested Loop Conditions?
Nested conditions occur when you place one conditional statement (like `if`) inside another. This allows for multi-level decision making:

```bash
if [ outer_condition ]; then     # Level 1: Check if file exists
    if [ inner_condition ]; then # Level 2: Check if file is writable
        # Execute action
    else
        # Handle case where file exists but no write permission
    fi
else
    # Handle case where file doesn't exist
fi
```

### Key Characteristics
- **Outer Condition**: Performs initial check (e.g., file existence using `-e` flag)
- **Inner Condition**: Performs subsequent check (e.g., permissions using `-w` flag)
- **Execution Flow**: Inner conditions only execute if outer conditions are true

## Creating a Nested Condition Script
Let's create a comprehensive script that implements nested conditions for file manipulation:

### Step 1: Script Structure
```bash
#!/bin/bash

# Get filename from user
echo "Please enter the name of the file:"
read -r filename

# Outer condition: Check if file exists using -e flag
if [ -e "$filename" ]; then
    # Inner condition: Check if file has write permissions using -w flag
    if [ -w "$filename" ]; then
        # Both conditions met - allow text append
        echo "Please type your text here and press Ctrl+D to exit:"
        cat >> "$filename"     # Append mode
    else
        echo "This file does not have write permissions."
    fi
else
    echo "$filename does not exist."
fi
```

### Step 2: Key Components Explained
- **File Existence Check** (`-e`): Uses `-e` flag to verify file presence before any operations
- **Permission Verification** (`-w`): Checks write access before text manipulation
- **Text Append Operation**: Uses `cat >> filename` to append text (preserves existing content)
- **Error Handling**: Provides clear messages for different scenarios

### Step 3: Alternative Overwrite Mode
To replace file content instead of appending:

```bash
# Replace >> with > for overwrite
cat > "$filename"   # This overwrites the file
```

## Lab Demo: Appending Text to Files with Permission Checks

### Preparation
1. Create a test file and remove all permissions:
   ```bash
   touch test.txt
   chmod 000 test.txt
   ```

2. Test the script without permissions:
   ```bash
   $ ./script.sh
   Please enter the name of the file: test.txt
   This file does not have write permissions.
   ```

3. Grant write permissions and test again:
   ```bash
   chmod 644 test.txt  # Read/write for owner, read for group/others
   ```

4. Run the script and append text:
   ```bash
   $ ./script.sh
   Please enter the name of the file: test.txt
   Please type your text here and press Ctrl+D to exit:
   This is my appended text.
   # Press Ctrl+D to save
   ```

### Expected Outputs

**Scenario 1: File doesn't exist**
```
$ ./script.sh
Please enter the name of the file: nonexistent.txt
nonexistent.txt does not exist.
```

**Scenario 2: File exists but no write permissions**
```
$ ./script.sh
Please enter the name of the file: readonly.txt
This file does not have write permissions.
```

**Scenario 3: File exists with write permissions**
```
$ ./script.sh
Please enter the name of the file: test.txt
Please type your text here and press Ctrl+D to exit:
Appended text content here
[Text is appended to the file]
```

## Summary

### Key Takeaways
```diff
+ Nested conditions allow multi-level decision making in scripts
+ Use -e flag to check file existence before operations  
+ Use -w flag to verify write permissions before modifications
+ cat >> appends text while preserving existing content
+ cat > overwrites entire file (use with caution)
+ Always validate conditions before performing file operations
```

### Quick Reference

#### File Permission Testing
```bash
# Read permission: -r
if [ -r "$file" ]; then echo "Readable"; fi

# Write permission: -w  
if [ -w "$file" ]; then echo "Writable"; fi

# Execute permission: -x
if [ -x "$file" ]; then echo "Executable"; fi

# File exists: -e
if [ -e "$file" ]; then echo "Exists"; fi
```

#### Nested Condition Template
```bash
if [ -e "$filename" ]; then
    if [ -w "$filename" ]; then
        echo "File exists and is writable"
        # Perform operations here
    else
        echo "File exists but not writable"
    fi
else
    echo "File does not exist"
fi
```

#### Complete Script
```bash
#!/bin/bash
echo "Please enter the name of the file:"
read -r filename

if [ -e "$filename" ]; then
    if [ -w "$filename" ]; then
        echo "Please type your text here and press Ctrl+D to exit:"
        cat >> "$filename"
    else
        echo "This file does not have write permissions."
    fi
else
    echo "$filename does not exist."
fi
```

### Expert Insight

#### Real-world Application
Nested conditions are crucial for robust shell scripts in production environments:
- **Backup scripts**: Verify file existence, check permissions, then create backups
- **Configuration managers**: Check if config files exist, validate write access, then update settings
- **Log processors**: Confirm log directory exists, ensure write permissions, then append entries

#### Expert Path
Master nested conditions by:
- Always ordering conditions logically (check existence before permissions)
- Using appropriate file test flags (`-e`, `-f`, `-d`, `-r`, `-w`, `-x`)
- Implementing proper error handling for all failure scenarios
- Testing scripts thoroughly with different permission combinations
- Avoiding nested conditions when simpler logic suffices

#### Common Pitfalls
- **Missing quotes**: Always quote variables like `"$filename"` to handle spaces
- **Incorrect flag usage**: Use `-e` for existence, not `-r` (which checks readability)
- **Permission confusion**: Write permission (`-w`) means you can modify the file content
- **Append vs Overwrite**: `>` overwrites completely; `>>` adds to the end (use `>>`)
- **Not testing edge cases**: Always test with nonexistent files, read-only files, etc.

>
> Generated using Claude Code
>
> Co-Authored-By: vondemataram23 <prekshitelang02@gmail.com>

</details>
