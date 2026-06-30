<details open>
<summary><b>Session 5: Install JQ Command, Verify the Version, and Get Help from Command Line (KK-CS45-script-v3-Inst-v1)</b></summary>

# Session 5: Install JQ Command, Verify the Version, and Get Help from Command Line

## Table of Contents
- [Overview](#overview)
- [Installation Prerequisites](#installation-prerequisites)
- [Installing JQ on Linux](#installing-jq-on-linux)
- [Installing JQ on macOS](#installing-jq-on-macos)
- [Verifying JQ Installation](#verifying-jq-installation)
- [Getting Help from Command Line](#getting-help-from-command-line)
- [Summary](#summary)

## Overview
This session covers the essential steps for setting up the `jq` command-line JSON processor. You'll learn how to install `jq` on different operating systems, verify the installation, and access help documentation directly from the command line. These foundational skills ensure you have a working `jq` environment before diving into more complex JSON processing techniques.

## Installation Prerequisites

### Root or Elevated Privileges Required
> [!IMPORTANT]
> All `jq` installation commands must be executed as the root user or with root/sudo privileges.

- Without proper permissions, package installation will fail
- This applies to all operating systems and package managers
- User must have administrative access to install system packages

### Supported Operating Systems
- **Linux distributions**: CentOS, RHEL, Ubuntu, Debian, and other RPM/DEB-based systems
- **macOS**: Via Homebrew package manager

## Installing JQ on Linux

### RPM-based Systems (CentOS/RHEL)
For CentOS or RHEL systems, use the system's package manager:

```bash
# Using yum (older systems)
sudo yum install jq

# Using dnf (newer RHEL/CentOS/Fedora)
sudo dnf install jq
```

- Must run from root user or with `sudo`
- Package manager will handle dependencies automatically
- Installation typically takes seconds on modern systems

## Installing JQ on macOS

### Using Homebrew
On macOS, Homebrew is the recommended package manager:

```bash
# Install jq using Homebrew
brew install jq
```

- Homebrew handles the entire installation process
- No manual compilation required
- Automatically places binaries in the correct PATH

## Verifying JQ Installation

### Check JQ Version
After installation, verify that `jq` is properly installed:

```bash
jq --version
```

**Expected Output:**
```
jq-1.6
```

- Confirms `jq` is accessible from the command line
- Shows the installed version number
- Version 1.6 is the current stable release at time of recording
- If command not found, installation failed or PATH issues exist

## Getting Help from Command Line

### Basic Help Command
Access quick reference information:

```bash
jq --help
```

**What you'll see:**
- Basic usage syntax
- Available command-line options
- Filter options and modifiers
- Brief descriptions of each feature

### Complete Documentation
For comprehensive, end-to-end documentation:

```bash
man jq
```

**Manual page includes:**
- Detailed option descriptions
- Complete filter reference
- Examples and usage patterns
- Advanced features and edge cases
- Exit the man page by pressing `q`

### Understanding Help Output Structure
```
jq - commandline JSON processor [version 1.6]

Usage: jq [options] <jq filter> [file...]
       jq [options] --args <jq filter> [<strings...>]
       jq [options] --argjson <a name> <a value> [--argjson <a name> <a value>...] <jq filter> [files...]

```

- **Options**: Always optional command-line flags (e.g., `-n`, `-r`, `-c`)
- **Filters**: Core JSON processing expressions (covered throughout course)
- **Files**: Input JSON files to process

## Summary

### Key Takeaways
```diff
+ Always install jq with root or sudo privileges
+ Verify installation immediately after installing with jq --version
+ Use jq --help for quick reference and man jq for complete documentation
+ Options in jq are always optional - they modify default behavior
+ The course will cover all three usage patterns: options, filters, and file input
```

### Quick Reference
| Command | Purpose |
|---------|---------|
| `sudo yum install jq` | Install on CentOS/RHEL (older) |
| `sudo dnf install jq` | Install on CentOS/RHEL/Fedora (newer) |
| `brew install jq` | Install on macOS |
| `jq --version` | Verify installation and check version |
| `jq --help` | Quick help and option overview |
| `man jq` | Complete documentation |

### Expert Insight

**Real-world Application:**
In production environments, `jq` is typically pre-installed on CI/CD runners, container images, and server fleets. When setting up new development machines or containers, always verify `jq` installation in your initialization scripts to prevent pipeline failures.

**Expert Path:**
- Memorize the installation commands for your primary OS
- Create a personal cheat sheet of the most useful `jq` options from `--help`
- Practice accessing man pages efficiently (navigation with arrow keys, search with `/`)
- Understand that `jq` version differences are minimal between 1.5 and 1.6 for most use cases

**Common Pitfalls:**
- Forgetting to use `sudo` when installing (results in permission denied errors)
- Assuming `jq` is in PATH after installation (may require shell restart or `source ~/.bashrc`)
- Not verifying installation before using in scripts
- Confusing `jq --help` (brief) with `man jq` (comprehensive)

</details>
