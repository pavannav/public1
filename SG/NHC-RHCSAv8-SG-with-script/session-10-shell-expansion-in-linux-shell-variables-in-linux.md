# Section 10: Shell Variables in Linux

<details open>
<summary><b>Section 10: Shell Variables in Linux (CL-KK-Terminal)</b></summary>

## Shell Variables in Linux

### Overview
This session introduces shell variables - dynamic storage entities that hold data in Linux environments. Variables are essential building blocks for shell scripting and system administration, allowing storage of values that can change dynamically during script execution or system operations.

### Key Concepts

#### Variable Types and Characteristics

**System-Defined Variables**
- Pre-configured by the operating system
- Written in CAPITAL LETTERS (convention)
- Available immediately upon login

**User-Defined Variables**
- Created by users for custom purposes
- Can use any case combination
- Flexible for scripting and automation

#### Common System Variables

| Variable | Example | Purpose |
|----------|---------|---------|
| `USER` | `vikas` | Current logged-in username |
| `PWD` | `/root` | Present Working Directory |
| `SHELL` | `/bin/bash` | Current shell being used |
| `HOME` | `/root` | User's home directory |
| `PATH` | `:/usr/bin:/bin` | Executable search locations |

#### Variable Naming Rules

**✅ Valid Conventions:**
- Must start with alphabetic character
- Can contain letters, numbers, and underscores
- Case sensitive (`USER` ≠ `user`)

**❌ Invalid Examples:**
- `2var` (cannot start with number)
- Names cannot contain spaces or special characters except underscore

#### Setting Variables

```bash
# Basic assignment
MY_VAR=hello
CITY="Jaipur Delhi"

# Display variable value
echo $MY_VAR        # Output: hello
echo $CITY          # Output: Jaipur Delhi
```

#### Quote Behavior

```bash
# Double quotes allow expansion
VAR="hello world"
echo "$VAR"         # Output: hello world
echo "Hi $VAR"      # Output: Hi hello world

# Single quotes preserve literal strings
echo '$VAR'         # Output: $VAR
echo 'Hi $VAR'      # Output: Hi $VAR
```

#### Variable Persistence

**Temporary Variables:**
```bash
TEMP_VAR=temporary
echo $TEMP_VAR     # Available in current shell
# Lost after logout
```

**Permanent Variables:**
```bash
# Add to ~/.bashrc for user persistence
echo 'export MY_VAR="permanent"' >> ~/.bashrc
source ~/.bashrc   # Activate changes

# Add to /etc/bashrc for system-wide persistence
echo 'export SYSTEM_VAR="all_users"' >> /etc/bashrc
```

#### Exporting Variables to Child Processes

```bash
# Local variable
LOCAL_VAR="local only"

# Export to child shells
export SHARED_VAR="child accessible"

# Test in subshell
bash -c 'echo $SHARED_VAR'    # Will display value
bash -c 'echo $LOCAL_VAR'     # Will be empty
```

#### Removing Variables

```bash
unset VARIABLE_NAME

MY_VAR="temporary"
echo $MY_VAR        # Output: temporary
unset MY_VAR
echo $MY_VAR        # Output: (empty)
```

#### Special Variables

**PS1 (Prompt String):**
Controls shell prompt appearance
```bash
echo $PS1           # View current prompt format
PS1="Custom> "      # Change prompt
```

**PATH Variable:**
System searches these directories for executables
```bash
echo $PATH          # View current paths
export PATH="$PATH:/custom/bin"    # Add custom path
```

#### Environment Inspection

```bash
set                 # Show all variables and functions
env                 # Show only exported variables
echo $VARIABLE      # Display specific variable
```

#### Variable Debugging

```bash
# Enable undefined variable warnings
set -u
echo $UNDEFINED     # Error: unbound variable

# Disable warnings
set +u
echo $UNDEFINED     # No error, empty output
```

#### Color Coding Configuration

```bash
# Root user prompt: Red
# Normal user prompt: Green

# Add to ~/.bashrc or /etc/bashrc
if [ "$UID" -eq 0 ]; then
    PS1='\[\e[31m\][\u@\h \W]\$\[\e[0m\] '
else
    PS1='\[\e[32m\][\u@\h \W]\$\[\e[0m\] '
fi
```

### Lab Demos

#### Demo 1: Variable Assignment and Display

```bash
# Set variables
CITY=Jaipur
COUNTRY="United States"

# Display variables
echo $CITY          # Output: Jaipur
echo '$CITY'        # Output: $CITY
echo "$CITY"        # Output: Jaipur

# Combine variables
echo "Located in $CITY, $COUNTRY"
# Output: Located in Jaipur, United States
```

#### Demo 2: Making Variables Permanent

```bash
# Add to user profile
echo 'export PROJECT_HOME="/home/user/project"' >> ~/.bashrc

# Activate changes
source ~/.bashrc

# Verify persistence
echo $PROJECT_HOME
# Output: /home/user/project
```

#### Demo 3: Working with PATH

```bash
# View current PATH
echo $PATH | tr ':' '\n'

# Add custom directory
export PATH="$PATH:/home/user/scripts"

# Verify addition
which myscript      # Will find in /home/user/scripts
```

#### Demo 4: Shell Level Tracking

```bash
echo $SHLVL         # Current level: 1

# Enter subshell
bash
echo $SHLVL         # Output: 2

# Exit back to parent
exit
echo $SHLVL         # Output: 1
```

#### Demo 5: Variable Export Demonstration

```bash
# Set local variable
LOCAL_VAR="parent only"
export SHARED_VAR="available in children"

# Show in current shell
echo $LOCAL_VAR $SHARED_VAR

# Test in subshell
bash -c 'echo "Child: $LOCAL_VAR $SHARED_VAR"'
# Output: Child: available in children
# (LOCAL_VAR is empty in child)
```

### Configuration Files Reference

**`/etc/bashrc` or `/etc/bash.bashrc`**
- System-wide bash configuration
- Affects all users

**`~/.bashrc`**
- User-specific bash configuration
- Per-user customizations

**`~/.bash_profile`**
- Executed during login sessions
- Sets up user environment

## Summary

### Key Takeaways
```diff
! Variables store dynamic data in shell environments

! Two types: system-defined (capital convention) and user-defined

! Names must start with letters, case-sensitive, no special characters except underscore

! Use $ prefix to access variable values

+ Single quotes preserve literals, double quotes enable expansion

! Export command shares variables with child processes

! Profile files make variables persistent across sessions

! PS1 controls prompt appearance, PATH contains executable locations
```

### Quick Reference

**Essential Commands:**
```bash
echo $VAR            # Display variable value
export VAR=value     # Export variable to children
unset VAR            # Remove variable
set                  # Show all variables/functions
env                  # Show exported variables
source ~/.bashrc     # Reload bash configuration
```

**Variable Syntax:**
- `VAR=value` - Basic assignment
- `$VAR` - Variable access
- `${VAR}` - Explicit variable boundary
- `"$VAR"` - Double quotes (expansion enabled)
- `'$VAR'` - Single quotes (literal text)

### Expert Insight

**Real-world Application**: Shell variables are fundamental to Linux system administration, enabling environment configuration, script parameterization, and dynamic behavior in automation. They're extensively used in deployment pipelines, configuration management, and system monitoring scripts.

**Expert Path**: Master variable scoping rules, understand the shell initialization sequence (system profiles vs user profiles), and practice advanced parameter expansion techniques. Learn to securely handle sensitive data in environment variables and create robust configuration management systems.

**Common Pitfalls**: Forgetting variable export for child processes, inappropriate quote usage causing unexpected behavior, not reloading configuration files after changes, and confusing variable scoping between parent/child shells.

</details>
