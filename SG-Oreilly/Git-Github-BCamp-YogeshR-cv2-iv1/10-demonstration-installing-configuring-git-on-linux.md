# Demonstration: Installing and Configuring Git on Linux

<details open>
<summary><b>Demonstration: Installing and Configuring Git on Linux (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Connecting to Linux VM via SSH](#connecting-to-linux-vm-via-ssh)
- [System Updates](#system-updates)
- [Changing Hostname](#changing-hostname)
- [Verifying Git Installation](#verifying-git-installation)
- [Exploring Git Help](#exploring-git-help)
- [Configuring Git Identity](#configuring-git-identity)

## Overview

This demonstration walks through installing and configuring Git on a Linux virtual machine hosted on AWS EC2. The session covers connecting via SSH, updating system packages, verifying Git installation status, and setting up global Git configuration including user identity with username and email.

## Connecting to Linux VM via SSH

### Prerequisites
- AWS EC2 instance running Linux (Ubuntu in this demo)
- Private key file for SSH authentication
- Instance IP address

### Connection Process

1. Copy the VM's IP address from AWS console
2. Use SSH command with private key:
   ```bash
   ssh -i <private-key-file> ubuntu@<vm-ip-address>
   ```
3. Upon successful connection, the terminal shows the user context (root user in this demo)

### Key Points
- The private key file must have proper permissions (usually 400)
- Username depends on the AMI (ubuntu for Ubuntu instances)
- SSH provides secure remote access to the Linux VM

## System Updates

### Update Package Lists and Upgrade

Before any installation, ensure the system has the latest packages:

```bash
# Update package lists
apt update

# Upgrade all packages with auto-confirmation
apt upgrade -y
```

### Important Notes
- `apt update`: Refreshes the list of available packages and versions
- `apt upgrade -y`: Installs the latest versions of all packages with automatic confirmation
- Process duration varies based on machine specifications and network speed
- Always update before installing new software to avoid dependency conflicts

## Changing Hostname

### Setting a Meaningful Hostname

Change the system hostname for better identification:

```bash
# Set new hostname
hostnamectl set-hostname thin-crook

# Refresh terminal to apply changes
bash
```

### Benefits of Custom Hostnames
- Easier identification in multi-server environments
- Professional appearance in logs and monitoring systems
- Improved organization when managing multiple instances

## Verifying Git Installation

### Check Git Version

```bash
git --version
```

**Expected Output:**
```
git version 2.43.0
```

### Installation Verification

If Git is not pre-installed, install using:

```bash
sudo apt install git -y
```

### Key Observations
- Most Linux distributions, especially AWS EC2 instances, come with Git pre-installed
- The `-y` flag enables automatic confirmation during installation
- Git version numbers follow semantic versioning (major.minor.patch)

## Exploring Git Help

### Access Git Documentation

```bash
git --help
```

### Common Commands Displayed
- `clone` - Clone a repository
- `init` - Initialize a Git repository
- `add` - Stage files for commit
- `mv` - Move or rename files
- `restore` - Restore working tree files
- `rm` - Remove files from working tree and index
- `bisect` - Use binary search to find commits
- `diff` - Show changes between commits
- `commit` - Record changes to repository
- `log` - Show commit logs
- `branch` - List, create, or delete branches

### Learning Path Note
All commands will be explored in detail throughout subsequent course modules.

## Configuring Git Identity

### Why Configure Identity?

Git records who makes changes in commit history. Proper identity configuration ensures:
- Accurate attribution of commits
- Professional commit history
- Compliance with team standards

### Global Configuration Setup

Configure Git settings globally (applies to all repositories):

```bash
# Set username globally
git config --global user.name "Your Name"

# Set email globally
git config --global user.email "your.email@example.com"

# Verify configuration
git config --list
```

### Configuration Scope Options

| Flag | Scope | Description |
|------|-------|-------------|
| `--global` | User level | Applies to all repositories for the current user |
| `--system` | System level | Applies to all users on the system |
| (none) | Repository level | Applies only to current repository |

### Verification Command

```bash
git config --list
```

**Sample Output After Configuration:**
```
user.name=Yogesh R
user.email=yogesh@example.com
```

## Summary

### Key Takeaways

```diff
+ Always update system packages before installing new software
+ Git comes pre-installed on most Linux distributions
+ Global configuration ensures consistent identity across all repositories
+ SSH provides secure remote access to Linux VMs
+ Hostname changes improve server identification and management
```

### Quick Reference

| Command | Purpose |
|---------|---------|
| `ssh -i key user@ip` | Connect to remote Linux server |
| `apt update && apt upgrade -y` | Update system packages |
| `hostnamectl set-hostname name` | Change system hostname |
| `git --version` | Check Git installation |
| `git --help` | View Git documentation |
| `git config --global user.name "Name"` | Set global username |
| `git config --global user.email "email"` | Set global email |
| `git config --list` | View current configuration |

### Expert Insight

**Real-world Application**: In production environments, Git identity configuration is essential for tracking code ownership, enabling proper code reviews, and maintaining audit trails for compliance requirements. AWS EC2 instances typically come with Git pre-installed, reducing setup time.

**Expert Path**: Master Git configuration at different scopes (system, global, local) to manage multiple projects with different identities. Learn about conditional includes for project-specific configurations.

**Common Pitfalls**:
- Forgetting to configure identity before first commit
- Using local configuration when global is intended
- Not updating system packages before Git installation
- Incorrect SSH key permissions causing connection issues

**Lesser-Known Facts**: Git stores configuration in plain text files (.gitconfig in home directory), making it easy to backup and transfer between machines. The `--global` flag modifies ~/.gitconfig while repository-specific settings are stored in .git/config within each repository.

</details>