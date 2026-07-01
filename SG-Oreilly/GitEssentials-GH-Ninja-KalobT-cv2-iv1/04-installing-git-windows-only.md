# Section 4: Installing Git on Windows

<details open>
<summary><b>Section 4: Installing Git on Windows (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [Overview](#overview)
- [4.1 Downloading Git for Windows](#41-downloading-git-for-windows)
- [4.2 Installing Git for Windows](#42-installing-git-for-windows)
- [4.3 Using Git Bash Terminal](#43-using-git-bash-terminal)
- [4.4 Basic Command Line Navigation](#44-basic-command-line-navigation)
- [Summary](#summary)

## Overview

This section provides Windows-specific instructions for installing Git using the Git for Windows application. It covers downloading the correct installer, installation requirements, and basic command-line navigation skills needed to work with Git repositories.

## 4.1 Downloading Git for Windows

### Git for Windows Introduction
Git for Windows is the recommended Git client for Windows users. The instructor emphasizes this as the best program for Windows-based Git development based on extensive cross-platform experience.

### Download Process
1. Navigate to **gitforwindows.org**
2. Click the download button
3. This redirects to a GitHub page where the installer is hosted
4. Locate the appropriate installer file:
   - **64-bit (Recommended)**: `Git-*-64-bit.exe` - For modern computers (last 4 years)
   - **32-bit**: For older Windows systems/laptops

### System Requirements
- 64-bit installer recommended for computers manufactured within the last 4 years
- 32-bit installer only for significantly older hardware

## 4.2 Installing Git for Windows

### Installation Steps
1. Download the appropriate `.exe` file based on system architecture
2. Run the installer
3. The installation creates the "Git for Windows" program

### Post-Installation Result
After installation, users can access a command-line tool interface for Git operations.

## 4.3 Using Git Bash Terminal

### Terminal Characteristics
- Git for Windows provides a command-line interface
- Visual appearance differs from native Windows Command Prompt
- Supports text input and command execution
- Has customizable color schemes and appearance settings

### Key Terminal Features
- Basic command execution capability
- Directory navigation
- File listing and management

## 4.4 Basic Command Line Navigation

### Essential Commands

**Directory Listing**
```bash
dir
```
- Displays list of files and directories in current location
- Windows-equivalent of Unix `ls` command

**Change Directory**
```bash
cd [directory_name]
```
- **Purpose**: Change to a different directory
- Navigation between folders
- Required for accessing project directories

**Print Working Directory**
```bash
pwd
```
- Shows current directory location
- Helps confirm navigation success

### Project Setup Recommendations
- Create a sample project folder on desktop, downloads, or temporary location
- Navigate to this directory using `cd` before starting Git work
- All Git operations should be performed within the designated project folder

## Summary

### Key Takeaways
```diff
+ Git for Windows is the recommended Git client for Windows development
+ Download 64-bit installer for modern Windows systems
+ Git Bash provides a Unix-like terminal experience on Windows
+ Basic navigation commands: dir, cd, pwd are essential
+ Set up a dedicated project directory before starting Git work
```

### Quick Reference
| Command | Description |
|---------|-------------|
| `dir` | List files and directories |
| `cd [path]` | Change to specified directory |
| `pwd` | Show current working directory |

### Expert Insight

**Real-world Application**: Git for Windows provides developers with a consistent Git experience across Windows systems, enabling seamless collaboration in mixed-OS environments. The command-line interface offers the full power of Git without GUI limitations.

**Expert Path**: After mastering basic navigation, explore advanced Git Bash features like tab completion, command history, and customization options. Consider learning PowerShell integration for advanced Windows scripting scenarios.

**Common Pitfalls**:
- Downloading the incorrect architecture installer (32-bit vs 64-bit)
- Not navigating to the correct project directory before initializing Git repositories
- Confusing Windows Command Prompt commands with Git Bash commands

**Lesser-Known Facts**: Git for Windows actually includes a complete MSYS2 environment, providing Unix tools like `bash`, `grep`, and `awk` alongside Git functionality.

</details>