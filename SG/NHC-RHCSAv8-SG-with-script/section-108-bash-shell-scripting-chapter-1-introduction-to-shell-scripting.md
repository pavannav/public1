# Section 108: Introduction to Shell Scripting

<details open>
<summary><b>Section 108: Introduction to Shell Scripting (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to Shell and Terminal](#introduction-to-shell-and-terminal)
- [Shell Types and Management](#shell-types-and-management)
- [Basics of Shell Scripting](#basics-of-shell-scripting)
- [Creating and Executing Scripts](#creating-and-executing-scripts)
- [Printing, Escape Characters, and Basic Commands](#printing-escape-characters-and-basic-commands)
- [Using Variables in Scripts](#using-variables-in-scripts)

## Introduction to Shell and Terminal
### Overview
This section introduces the fundamental concepts of shells and terminals in Linux environments. It explains that while terminals provide a user interface (like GNOME Terminal), shells are the underlying programs (often Bash) that interpret and execute commands typed at the prompt. Shells act as intermediaries, processing commands from users or scripts and communicating with the operating system. The difference between terminals (front-end interfaces) and shells (back-end interpreters) is crucial for understanding scripting environments.

### Key Concepts
- **Shell**: A command-line interpreter that processes commands entered by the user or from scripts. It reads input, translates it into system-level instructions, and executes them. Examples include Bash (`/bin/bash`), Dash (`/bin/dash`), and others like Zsh or Fish.
  
- **Terminal**: A graphical user interface application (e.g., GNOME Terminal, xterm) that provides access to the shell. It is not the shell itself but a window into it. Terminals enable keyboard input and display output from the shell.

- **Why Distinguish**: Terminals offer flexibility by allowing users to switch shells, while shells define the scripting language and behavior. For instance, Bash supports advanced features like arrays and functions, whereas Dash is lighter for system scripts.

- **Common Shells**:
  - H# Bash: Default in most Linux distributions (e.g., RHEL, Ubuntu).
  - Zsh: Feature-rich, often used for interactive shells.
  - Fish: User-friendly with auto-suggestions.
  - Dash: Lightweight, used for system scripts (e.g., `/bin/sh`).

> [!IMPORTANT]
> Understanding shells is key for scripting because different shells have varying syntax and capabilities. Always verify your shell with `echo $SHELL` before scripting.

### Correction Notes
- Transcript misspells "bash" as "vesh" at times (e.g., "vesh shell"); corrected to "bash" throughout.
- Phrases like "htp" (likely "how to") or "kubuntu" (likely "Kubernetes") are not present in this specific transcript, but related sections may have similar issues—corrected here as "how to" or proper terms.

## Shell Types and Management
### Overview
This part covers identifying installed shells on your system, changing the default shell, and understanding how to view or modify shell configurations. Shells are stored in `/etc/shells`, and users can switch shells for sessions or permanently.

### Key Concepts
- **Available Shells**: Use `cat /etc/shells` to list installed shells (e.g., `/bin/bash`, `/bin/dash`).
  
- **Current Shell**:
  - Use `echo $SHELL` to check the current login shell.
  - Use `ps -p $$` or `echo $0` to see the active session shell.

- **Changing Shells**:
  - **Temporarily**: Use `chsh -s /bin/zsh` (requires password; changes default in `/etc/passwd`).
  - **Session-Only**: Run `/bin/zsh` directly to switch for the current session.
  - Edit `/etc/passwd` manually or use `usermod -s /bin/zsh $USER`.

- **Configuration Files**:
  - User-level: `~/.bashrc` or `~/.zshrc` for customizations.
  - Reloading: Run `source ~/.bashrc` after changes.

- **Example Commands**:
  ```
  $ chsh -s /bin/bash  # Change to Bash
  $ echo $SHELL        # Verify
  Password:
  Shell changed.
  $ source ~/.bashrc   # Reload config
  ```

### Table: Common Shells and Their Paths

| Shell Name | Path          | Description |
|------------|---------------|-------------|
| Bash      | /bin/bash     | Default, full-featured scripting shell |
| Dash      | /bin/dash     | Lightweight, POSIX-compliant |
| Zsh       | /bin/zsh      | Interactive with plugins/extensions |
| Fish      | /usr/bin/fish | Beginner-friendly with completions |

## Basics of Shell Scripting
### Overview
Shell scripting involves writing programs (scripts) that use shell commands in sequence. Scripts are interpreted directly by the shell/OS without compilation, allowing automation of tasks. Scripts start with a shebang (`#!/bin/bash`) to specify the interpreter.

### Key Concepts
- **Why Scripting?**: Unlike compiled languages (e.g., C++), shell scripts are executed line-by-line by the interpreter (e.g., Bash). Ideal for system administration, automation, and RHCSA exams where shell questions appear.

- **Shebang Line**: The first line in a script (`#!/bin/bash`) tells the system which shell to use.

- **File Extensions**: Convention is `.sh` (e.g., `hello.sh`), but not mandatory—shell recognizes via shebang.

- **Script Components**:
  - Instances: Reuse system commands.
  - Loops/Conditions: Control flow (covered in future sections).
  - Variables: Store data (e.g., `name="value"`).

> [!NOTE]
> Scripts are portable across Similar systems but shell-dependent (e.g., Bash-only features won't work in Dash).

## Creating and Executing Scripts
### Overview
Scripts are plain text files created with editors like Vim, Nano, or Vi. They require execute permissions to run. Errors like "permission denied" are fixed by adding executable rights.

### Key Concepts
- **Creating a Script**:
  1. Open editor: `vim hello.sh`
  2. Add shebang: `#!/bin/bash`
  3. Write commands: `echo "Hello World"`
  4. Save: `:wq`

- **Executing Scripts**:
  - Method 1: `./hello.sh` (requires execute permission).
  - Method 2: `/bin/bash hello.sh` (temporary override, no permission needed).
  - Avoid running with `bash hello` if file lacks shebang—use full path.

- **Permissions**:
  - Check: `ls -l hello.sh` (should show `x` for execute).
  - Add: `chmod +x hello.sh` or `chmod 755 hello.sh`.
  - Numeric: `755` (rwxr-xr-x) for user execute, group/other read.

- **Common Errors**:
  - Permission denied: Add execute bit.
  - Shebang missing: Script runs but may fail in incompatible shells.

### Code Blocks
**Basic Hello World Script** (`hello.sh`):
```bash
#!/bin/bash
echo "Hello World"
```

**Running the Script**:
```bash
$ touch hello.sh
$ vim hello.sh  # Edit as above
$ chmod +x hello.sh
$ ./hello.sh
Hello World
```

### Lab Demo (Based on Transcript Example)
1. Create file: `vim hello.sh`
2. Write content: Simple echo string.
3. Check permissions: `ls -l hello.sh`
4. Add permission: `chmod +x hello.sh`
5. Execute: `./hello.sh`
   - Output: Prints the message.

## Printing, Escape Characters, and Basic Commands
### Overview
Printing in scripts uses `echo` for output. Escape sequences (e.g., newlines, tabs) require the `-e` flag. Understanding quotes is key: double quotes expand variables, single quotes are literal.

### Key Concepts
- **Echo Command**:
  - Basic: `echo "Hello"` → Prints "Hello"
  - With options: `echo -e "Hello\nWorld"` → Multiline output

- **Escape Characters with `-e`**:
  • `\n`: Newline (requires `-e`)
  • `\t`: Tab
  • `\\`: Backslash

- **Quotes**:
  - Double (`" "`): Expands variables (e.g., `"Hello $name"`)
  - Single (`' '): Literal (e.g., `'Hello $name'` prints "Hello $name")

- **Previous Command Reference**: `!!` or `!$` (e.g., `echo !$` prints last argument).

### Code Block
**Example with Escape Sequences** (`print-demo.sh`):
```bash
#!/bin/bash
echo -e "Welcome\n\tTo\n\tScripting\n\t!!"
echo "Variable expansion: $HOME"
echo 'Literal: $HOME'  # No expansion
```

**Output**:
```
Welcome
    To
    Scripting
    [last_command]
Variable expansion: /home/user
Literal: $HOME
```

## Using Variables in Scripts
### Overview
Variables store data temporarily. In shells, they're untyped and referenced with `$` (e.g., `$name`). This section covers basic variable usage, including declaration and access.

### Key Concepts
- **Variable Types**:
  - System: `$SHELL`, `$HOME` (auto-set).
  - User-defined: `name="value"`

- **Declaration and Access**:
  - Declare: `my_var="hello"`
  - Access: `echo $my_var` or `echo ${my_var}` (braces for concatenation, e.g., `${my_var}World`)
  - Scope: Local to script unless exported.

- **Special Variables**:
  - `$0`: Script name
  - `$1, $2, ...`: Arguments
  - `$$`: Process ID

- **Input**: Future sections cover `read` for user input.

### Code Block
**Variable Script** (`vars.sh`):
```bash
#!/bin/bash
#!/bin/bash
my_var="50"
echo "My variable: $my_var"
echo "Script name: $0"
echo "Home: $HOME"  # System var
```

**Running**:
```bash
$ ./vars.sh
My variable: 50
Script name: ./vars.sh
Home: /home/user
```

## Summary

### Key Takeaways
```diff
+ Shell enables command interpretation and scripting for automation.
- Terminal is a UI; shell is the interpreter—don't confuse them.
+ Use shebang (#!/bin/bash) to specify interpreter in scripts.
- Scripts need execute permissions (chmod +x) to run.
+ Double quotes expand variables; single quotes are literal.
+ Escape chars require -e with echo for newlines/tabs.
+ Variables reference with $; system vars like $SHELL are pre-defined.
```

### Quick Reference
| Command | Description | Example |
|---------|-------------|---------|
| `echo $SHELL` | Check current shell | `bash` |
| `cat /etc/shells` | List available shells | `/bin/bash` |
| `chsh -s /bin/bash` | Change shell | Requires reboot/log out |
| `chmod +x script.sh` | Add execute permission | N/A |
| `./script.sh` | Run script | `Hello World` |
| `echo "Hello\nWorld"` | Echo with newline | Multiline output |
| `my_var="value"; echo $my_var` | Variable use | `value` |

### Expert Insight
**Real-world Application**: Shell scripts automate sysadmin tasks like backups (e.g., cron jobs for log rotation) or deployments in CI/CD pipelines. In RHCSA, expect 2-3 questions on basics like permissions and shebang.

**Expert Path**: Practice writing scripts for common tasks (e.g., user management). Experiment with multiple shells to see differences.

**Common Pitfalls**: Forgetting shebang causes "command not found"; using wrong quotes leads to variable failure; neglecting permissions blocks execution. Test scripts in stages.

</details>
