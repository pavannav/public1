<details open>
<summary><b>03-Basics-to-Work-with-Jq-Command (KK-CS45-script-v3-Inst-v1)</b></summary>

# Session 1: Basics to Work with JQ Command

## Table of Contents
- [Overview](#overview)
- [Linux Pipes](#linux-pipes)
- [Linux Redirections](#linux-redirections)
- [JQ Command Basics](#jq-command-basics)
- [Summary](#summary)

## Overview

This foundational session covers two critical Linux concepts essential for working effectively with the `jq` command: pipes and redirections. The session demonstrates how to chain commands together and manage input/output flow, setting the groundwork for more advanced jq operations in subsequent sessions.

## Linux Pipes

### Key Concepts

Linux pipes (`|`) allow you to pass the output of one command as input to another command, enabling powerful command chaining.

**Basic Syntax:**
```bash
command1 | command2
```

**How It Works:**
- The output from `command1` is captured
- This output becomes the standard input (stdin) for `command2`
- This creates a data stream between commands

### Practical Example

```bash
# List files with details, sorted by modification time
ls -lrt | awk '{print $NF}'
```

In this example:
- `ls -lrt` generates a detailed file listing
- The pipe (`|`) passes this output to `awk`
- `awk '{print $NF}'` extracts only the last column (filename)

### Application in JQ

The pipe concept extends beyond shell commands to jq's internal operations:
- One filter's output can feed into another filter
- Functions can receive input from previous filter operations
- This enables complex data transformations through chained operations

> [!NOTE]
> The pipe used in shell commands (`|`) is different from jq's internal pipe (also `|`), though the concept is similar.

## Linux Redirections

### Output Redirections

Redirection symbols control where command output is sent.

#### Write to File (`>` and `>>`)

| Symbol | Behavior | File Exists? | File Not Exists? |
|--------|----------|--------------|------------------|
| `>` | Single greater-than | **Overwrites** existing content | Creates new file |
| `>>` | Double greater-than | **Appends** to existing content | Creates new file |

**Examples:**
```bash
# Create/overwrite file with ls output
ls -lrt > one.txt

# Append date to existing file (or create if not exists)
date >> one.txt
```

### Input Redirections

Multiple syntaxes exist for providing input to commands.

#### Single Less-Than (`<`)

Provides a file as input to a command:
```bash
# Search for "git" in r1.json using grep
grep git < r1.json
```

This is equivalent to:
```bash
grep git r1.json
```

#### Double Less-Than (`<<`) - Heredoc

Provides multi-line data directly as input:
```bash
grep git << EOF
first line
second line with git
last line with git
EOF
```

- Must start with an end-of-file marker (commonly `EOF`)
- Supports multiple lines of input
- Marker closes the heredoc block

#### Triple Less-Than (`<<<`) - Here-string

Provides a string as input to a command:
```bash
# Direct string input
grep git <<< 'we can add any data
second line with git
last line with git'
```

**Important Distinction:**
- Triple less-than requires single quotes around the data
- Input must be a string (not a command directly)

### Providing Command Output as String Input

To use a command's output with triple less-than:
```bash
grep demo <<< "$(ls)"
grep git <<< "$(cat r1.json)"
```

> [!IMPORTANT]
> When using `<<<`, the input must be a string. Use command substitution `$(command)` to convert command output to a string.

## JQ Command Basics

### First Introduction to JQ

The session introduces the most basic jq filter: the identity filter (`.`).

**Basic Usage:**
```bash
echo '[1,2,3]' | jq '.'
```

**Behavior:**
- Takes input JSON/array
- Returns identical output
- Performs formatting/pretty-printing as a side effect

**Alternative Syntax (without pipe):**
```bash
jq '.' <<< "$(echo '[1,2,3]')"
jq '.' <<< '[1,2,3]'
```

## Summary

### Key Takeaways
```diff
+ Linux pipes (|) chain commands by passing output as input
+ Redirection symbols control file creation and input provision
+ Single > overwrites, double >> appends to files
+ Three input redirection types: < (file), << (heredoc), <<< (here-string)
+ JQ's basic identity filter (.) passes input through unchanged
+ Command output can feed into jq using pipes or redirections
```

### Quick Reference

| Operation | Syntax | Purpose |
|-----------|--------|---------|
| Pipe | `cmd1 \| cmd2` | Pass output as input |
| Overwrite | `cmd > file` | Create/overwrite file |
| Append | `cmd >> file` | Append to file |
| File input | `cmd < file` | Read file as input |
| Heredoc | `cmd << EOF` | Multi-line string input |
| Here-string | `cmd <<< 'str'` | Single string input |

### Expert Insight

**Real-world Application:**
Understanding pipes and redirections is fundamental for jq workflows. In production environments, you'll frequently:
- Pipe JSON output from APIs into jq for processing
- Redirect formatted jq output to log files
- Use heredocs for testing jq expressions with sample data

**Expert Path:**
- Practice chaining multiple jq filters using pipes
- Learn when to use each redirection type appropriately
- Master command substitution for dynamic input generation

**Common Pitfalls:**
- Confusing `>` (overwrite) with `>>` (append) leading to data loss
- Forgetting quotes with `<<<` here-strings
- Attempting to pipe binary data through jq without proper handling
- Not escaping special characters in heredoc markers

</details>
