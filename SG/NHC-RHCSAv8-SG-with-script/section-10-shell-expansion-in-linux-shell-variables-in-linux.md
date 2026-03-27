<section-10-shell-variables.md># Section 10: Shell Variables

<details open>
<summary><b>Section 10: Shell Variables (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to Shell Variables](#introduction-to-shell-variables)
- [Types of Variables](#types-of-variables)
- [System-Defined Variables](#system-defined-variables)
- [User-Defined Variables](#user-defined-variables)
- [Setting and Using Variables](#setting-and-using-variables)
- [PATH Variable and Command Execution](#path-variable-and-command-execution)
- [PS1 Variable and Prompt Customization](#ps1-variable-and-prompt-customization)
- [Exporting Variables](#exporting-variables)
- [Unsetting Variables](#unsetting-variables)
- [Variable Scope and Subshells](#variable-scope-and-subshells)
- [Setting Options with Set Command](#setting-options-with-set-command)

## Introduction to Shell Variables

Shell variables are dynamic containers that store data, allowing their values to change during program execution. Unlike constants, variables can hold different values at different times, making them essential for scripting and system configuration.

Key characteristics:
- **Mutable**: Values can be modified.
- **Typed**: Can store strings, numbers, or other data types.
- **Scoped**: Exist within the current shell session unless exported.

In Linux, variables play a crucial role in customizing the shell environment, storing user information, paths, and configurations.

## Types of Variables

Variables in Linux shells are categorized into two main types:

1. **System-Defined Variables**: Pre-configured by the system or shell, often in capital letters.
2. **User-Defined Variables**: Created by users for specific purposes, can be in any case.

System variables are case-sensitive in some contexts but generally follow uppercase conventions. User variables can be defined as needed.

## System-Defined Variables

System-defined variables are set by the operating system or shell at startup. They include information about the user, system paths, and environment.

Examples:
- `$USER`: Current logged-in user (e.g., `echo $USER` displays `root` or username).
- `$HOME`: User's home directory path.
- `$PWD`: Present working directory.
- `$SHELL`: Current shell being used (e.g., `bash`).
- `$PATH`: Directories where executable commands are located.

To view a variable's value: `echo $VAR_NAME`
To list all defined variables: `set` or `env` commands.

## User-Defined Variables

User-defined variables are created for custom scripting or temporary use. They follow specific naming rules:

- Must start with an alphabetic character, not a number.
- Can contain alphanumeric characters and underscores.
- Case-sensitive.

Example:
```bash
MYVAR=100
echo $MYVAR  # Outputs: 100
```

To make permanent, add to `~/.bashrc` or `/etc/profile`.

## Setting and Using Variables

### Setting Variables
Use the assignment operator `=`. No spaces around `=`.

```bash
VAR_NAME=VALUE
```

Example:
```bash
CITY="Delhi"
NUMBER=123
```

### Using Variables
Prefix with `$`:
```bash
echo $CITY     # Outputs: Delhi
echo $NUMBER   # Outputs: 123
```

### Variable Modification
To change value:
```bash
# Append to existing variable
VAR_NAME="${VAR_NAME}additional_text"

# Example
NAME="John"
NAME="$NAME Doe"
echo $NAME  # Outputs: John Doe
```

### Quotes Usage
- **Double Quotes**: Expand variables inside.
- **Single Quotes**: Treat as literal text.

```bash
NAME="World"
echo "Hello $NAME"  # Outputs: Hello World
echo 'Hello $NAME'  # Outputs: Hello $NAME
```

## PATH Variable and Command Execution

The `PATH` variable contains a colon-separated list of directories where the shell looks for executable commands.

To view: `echo $PATH`

Example output: `/usr/local/bin:/usr/bin:/bin`

Command execution:
- When you type a command (e.g., `ls`), the shell searches `PATH` directories.
- If not found, error: `command not found`.
- To run un PATH'ed commands: Use full path, e.g., `/bin/ls`.

Adding to PATH temporarily:
```bash
export PATH="$PATH:/new/directory"
```

## PS1 Variable and Prompt Customization

PS1 (Prompt Statement 1) controls the shell prompt appearance.

Current PS1: `echo $PS1`

Default structure:
- Username
- Hostname
- Current directory
- Prompt character (`$` for user, `#` for root)

Customizing PS1:
```bash
PS1="New Prompt: "
```

Advanced example with colors:
In `~/.bashrc`, add escape sequences for colors:

```bash
# Red for root, green for normal user
if [ "$EUID" -eq 0 ]; then
    PS1='\[\e[1;31m\]\u@\h:\w#\[\e[0m\] '
else
    PS1='\[\e[1;32m\]\u@\h:\w$\[\e[0m\] '
fi
```

Source the file: `source ~/.bashrc`

## Exporting Variables

By default, variables are local to the current shell. To make them available in subshells or child processes, export them.

```bash
MY_VAR="shared_value"
export MY_VAR  # Now available in subshells
```

Example:
```bash
CITY="Mumbai"
export CITY
# In subshell
bash -c 'echo $CITY'  # Outputs: Mumbai
```

Without export: `bash -c 'echo $CITY'` would be empty.

## Unsetting Variables

To remove a variable's definition:

```bash
unset VARIABLE_NAME
```

Example:
```bash
SET_VAR="value"
unset SET_VAR
echo $SET_VAR  # Outputs nothing
```

To unset globally: Remove from profile files.

## Variable Scope and Subshells

Variables exist within their defined scope:
- **Shell Level**: Checked with `$SHLVL` (increments in subshells).

Example:
```bash
echo $SHLVL  # Level 1
bash
echo $SHLVL  # Level 2
exit
echo $SHLVL  # Level 1 again
```

Variables without export are not inherited by subshells.

## Setting Options with Set Command

The `set` command configures shell behavior.

- `set -u`: Treat unset variables as errors.
- `set +u`: Disable (default).

Example:
```bash
set -u
echo $DEFINED_VAR  # Normal if defined
echo $UNDEFINED_VAR  # Error: UNDEFINED_VAR: unbound variable
```

To view all variables: `set` (shows all).
To view exported variables: `printenv` or `env`.

## Summary

### Key Takeaways
```diff
+ Variables store dynamic data in shell environments, enabling customization and scripting flexibility.
- System variables (e.g., $USER, $PATH) are predefined and often in uppercase; user variables are custom-defined.
! Variables must start with letters and can include numbers/underscores; they are case-sensitive.
+ Use $ to access variables, and export for subshell availability.
- PATH enables command discovery; PS1 customizes prompts with color codes for better UX.
+ Permanent variables require profile updates; temporary ones vanish on shell exit.
! Proper scoping prevents naming conflicts; unset removes variables when needed.
```

### Quick Reference
- **Set variable**: `VAR=value`
- **Access variable**: `echo $VAR`
- **Export variable**: `export VAR`
- **Unset variable**: `unset VAR`
- **List variables**: `set` or `env`
- **Custom PS1 colors**: Add escape sequences in `~/.bashrc` (e.g., `\[\e[1;32m\]` for green)
- **PATH locations**: Colon-separated; add via `export PATH="$PATH:/new/path"`

### Expert Insight
**Real-world Application**: Shell variables are foundational for automation scripts (e.g., storing API keys, paths in CI/CD pipelines) and system administration (e.g., customizing prompts for quick environment identification).

**Expert Path**: Master variable manipulation by practicing in shell sessions, then apply in scripts. Experiment with `readonly` for constants and array variables in advanced bash scripting.

**Common Pitfalls**: Forgetting to export variables, using variables in single quotes (no expansion), or starting variable names with numbers. Always test in subshells and validate with `set -u`.

</details>
