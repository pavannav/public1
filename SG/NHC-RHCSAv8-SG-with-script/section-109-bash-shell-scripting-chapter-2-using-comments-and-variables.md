# Section 109: Using Comments and Variables in Shell Script

<details open>
<summary><b>Section 109: Using Comments and Variables in Shell Script (CL-KK-Terminal)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Introduction to Comments](#introduction-to-comments)
- [Introduction to Variables](#introduction-to-variables)
- [System Defined Variables](#system-defined-variables)
- [User Defined Variables](#user-defined-variables)
- [Exporting Variables](#exporting-variables)
- [Using Variables and Comments in Scripts](#using-variables-and-comments-in-scripts)
- [Reading User Input](#reading-user-input)
- [Summary](#summary)

## Overview

This section covers the fundamentals of using comments and variables in shell scripts. Comments are used to add notes that are ignored by the shell, while variables store values that can be referenced throughout scripts. The content explores both system-defined variables (pre-set by the operating system) and user-defined variables (created by users), including how to declare, use, and export them for broader availability across shell sessions.

## Introduction to Comments

Comments in shell scripts are non-executable lines that help with code readability and documentation. They begin with the `#` symbol, and everything following that symbol on the same line is ignored by the shell.

Key points:
- `#` is also known as the hash or pound sign.
- Use comments to explain complex logic or add notes for future reference.
- Comments are essential for maintaining readable and maintainable scripts, especially in production environments.

### Code Example
```bash
#!/bin/bash
# This is a comment - the shell ignores this line
echo "Hello World"  # This is also a comment
```

> [!NOTE]
> Comments are ignored during execution, improving script performance and code organization.

## Introduction to Variables

Variables are containers that store data values, such as numbers, strings, or paths. They make scripts dynamic and reusable by allowing values to change without modifying the script itself. Variables are case-sensitive and can be either system-defined or user-defined.

Key concepts:
- Variables act as placeholders for values.
- Use the dollar sign `$` to reference a variable's value.
- Variables enable parameterized scripts for various use cases.

### When to Use Variables
- Store configuration settings (e.g., file paths, usernames).
- Handle dynamic data that changes per execution.
- Simplify maintenance by centralizing value changes.

## System Defined Variables

System-defined variables are pre-configured by the operating system or shell. They provide essential information like user details, environment settings, and system paths. These variables are typically in uppercase.

Common system-defined variables:
- `$HOME`: User's home directory path.
- `$SHELL`: Current shell being used (e.g., /bin/bash).
- `$USER`: Current user's username.
- `$PWD`: Present working directory.
- `$PATH`: Colon-separated list of directories for executable searches.
- `$HOSTNAME`: Machine's hostname.
- `$SHELL_VERSION`: Version of the current shell.

### Examples Usage
```bash
echo "Your shell is: $SHELL"
echo "You are logged in as: $USER"
echo "Your hostname is: $HOSTNAME"
```

> [!IMPORTANT]
> System-defined variables are read-only in most cases and provide consistent environment information across sessions.

## User Defined Variables

User-defined variables are created by script writers for custom purposes. They allow storing and manipulating data specific to the script's needs. Variable names must not start with a number.

Rules for naming:
- Must not start with a number (e.g., `var1` is valid, `1var` is invalid).
- Can include letters, numbers, and underscores.
- Convention: Use lowercase for local variables.

### Declaring User-Defined Variables
```bash
my_name="John Doe"
age=25
echo "Name: $my_name, Age: $age"
```

> [!TIP]
> Use quotes for variables with spaces or special characters to avoid parsing errors.

#### Modifying and Removing User-Defined Variables
To remove a variable:
```bash
unset my_name
```

To modify an existing variable:
```bash
my_name="Jane Doe"
```

## Exporting Variables

By default, variables are local to the current shell session. To make them available to child processes or other shell instances, use the `export` command.

### Why Export Variables?
- Ensures variables persist across sub-shells (e.g., when running scripts or entering new shell levels).
- Enables sharing data between parent and child processes.

### Export Example
```bash
export MY_VAR="shared value"
echo $MY_VAR  # Available in child shells
```

Permanent export (add to profile):
- Add to `~/.bashrc` or `~/.profile` for user-specific variables.
- Add to `/etc/profile` or `/etc/bashrc` for system-wide variables.

```bash
# In ~/.bashrc
export MY_VAR="persistent value"
# Then reload: source ~/.bashrc
```

> [!WARNING]
> Exported variables are only temporary unless added to profile files. Log out and log in again or use `source` to reload profiles.

## Using Variables and Comments in Scripts

In scripts, combine comments for documentation and variables for dynamic behavior. This creates maintainable, scalable shell scripts.

### Sample Script Structure
```bash
#!/bin/bash
# Script to demonstrate variables and comments
# Author: Example
# Date: Today

user="student"
echo "Welcome, $user to shell scripting!"
```

### Best Practices
- Use comments to explain logic above code blocks.
- Define variables at the top for easy modification.
- Reference variables using `$VAR_NAME`.

#### Code Block: Advanced Example
```bash
#!/bin/bash
# Get system info using variables

current_user=$USER
current_shell=$SHELL
echo "User: $current_user"
echo "Shell: $current_shell"
```

```diff
+ Use descriptive variable names (e.g., current_user instead of user).
- Avoid hard-coding values; use variables for flexibility.
```

## Reading User Input

Shell scripts can accept input from users dynamically. Use the `read` command to capture user input and store it in variables for processing.

### Basic Input Reading
```bash
echo "Please enter your name:"
read my_name
echo "Hello, $my_name!"
```

### Handling Multi-Word Input
```bash
echo "Enter your full name:"
read first_name last_name
echo "Full name: $first_name $last_name"
```

> [!NOTE]
> Use options like `-p` for prompts or `-s` for silent input (e.g., passwords).

Advanced usage:
```bash
read -p "Enter username: " user_name
echo "Welcome, $user_name"
```

## Summary

### Key Takeaways
```
diff
+ Comments (#) are ignored by the shell and enhance script readability.
+ Variables store dynamic values; prefix with $ to access their value.
+ System-defined variables (uppercase) provide environment info (e.g., $USER, $PWD).
+ User-defined variables are created with NAME=value syntax.
+ Export variables to make them available in child shells.
+ Use read command to capture user input during script execution.
- Variables are case-sensitive; avoid starting names with numbers.
```

### Quick Reference
- Add comment: `# This is a comment`
- Declare variable: `my_var="value"`
- Access variable: `$echo $my_var`
- Export variable: `export my_var`
- Read input: `read my_var`
- Remove variable: `unset my_var`
- Check variables: `set` (shows all), `env` (shows exported)

### Expert Insight

#### Real-world Application
In production scripts, variables and comments are crucial for automation tasks like user management, log parsing, and system monitoring. For example, a backup script might use variables for source/destination paths and comments to outline steps, ensuring easy maintenance during deployments.

#### Expert Path
Master variable scoping by practicing with subshells and exported variables. Advance to array handling (`array=("item1" "item2")`) and parameter expansion. Study environment files (e.g., `.env`) for secure variable management in CI/CD pipelines.

#### Common Pitfalls
- Forgetting quotes around variables with spaces: Leads to word-splitting errors.
- Not exporting variables when needed: Causes failures in nested scripts.
- Case sensitivity issues: Mixing uppercase (system) and lowercase (user) incorrectly.
- Overusing comments: Balance between documentation and clutter.

</details>
