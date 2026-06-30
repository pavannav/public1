# 08-Demonstration-Installing-Git-on-Windows

<details open>
<summary><b>08-Demonstration-Installing-Git-on-Windows (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Download Git for Windows](#download-git-for-windows)
- [Run the Installer](#run-the-installer)
- [License Agreement](#license-agreement)
- [Choose Installation Directory](#choose-installation-directory)
- [Select Components](#select-components)
- [Start Menu Folder](#start-menu-folder)
- [Choose Default Editor](#choose-default-editor)
- [Initial Branch Name](#initial-branch-name)
- [PATH Environment Settings](#path-environment-settings)
- [SSH Executable](#ssh-executable)
- [HTTPS Transport Backend](#https-transport-backend)
- [Line Ending Conversions](#line-ending-conversions)
- [Terminal Emulator](#terminal-emulator)
- [Git Pull Behavior](#git-pull-behavior)
- [Credential Helper](#credential-helper)
- [Additional Options](#additional-options)
- [Complete Installation](#complete-installation)
- [Verify Installation](#verify-installation)
- [Summary](#summary)

## Overview

This demonstration walks through the complete process of installing Git on a Windows machine using the official Git for Windows installer. The process involves downloading the installer from the official website and configuring various installation options through a step-by-step wizard interface. This foundational setup is essential for all subsequent Git operations in the course.

## Download Git for Windows

### Accessing the Official Website

To begin the Git installation process on Windows:

1. Open your web browser and navigate to **git-scm.com**
2. The official Git website serves as the trusted source for downloading Git
3. Scroll down the homepage to locate the "Download for Windows" option

### Selecting the Correct Installer

Git provides different installers based on system architecture:

- **Windows x64**: Standard choice for most Windows users (64-bit Intel/AMD processors)
- **ARM64**: Required for Windows devices with ARM processors

The downloaded file will be an executable (.exe) with a naming convention similar to: `Git-2.51.0.0-64-bit.exe`

## Run the Installer

### Launching the Setup Wizard

1. Once the download completes, locate the executable file
2. Double-click to launch the installer
3. This initiates the "Git for Windows Setup Wizard"
4. The wizard guides users through configuration options step by step

## License Agreement

### Understanding the License

The first screen presents the Git license agreement:

- This is the standard Git license terms
- Click **Next** to accept and proceed
- No need to read the entire agreement for basic usage

## Choose Installation Directory

### Default Installation Path

The installer defaults to: `C:\Program Files\Git`

- This location is recommended for most users
- No special permissions required for standard installation
- Click **Next** to accept the default location

## Select Components

### Default Component Selection

The installer pre-selects essential components:

- **Git Bash**: Command-line interface (most commonly used)
- **Git GUI**: Graphical interface option
- **Git LFS**: Large File Storage support
- **Associate .git* configuration files**: File type associations

### Optional Components

Users may optionally select:

- Desktop shortcut creation
- Additional context menu options

Leaving defaults selected works well for most users.

## Start Menu Folder

### Installation Location for Shortcuts

This screen determines where Git shortcuts appear in the Start Menu:

- Default folder name is typically "Git"
- Click **Next** to accept the default
- No impact on functionality regardless of choice

## Choose Default Editor

### Editor Selection Options

The default editor selection determines which text editor opens for Git operations:

**Default Recommendation**: Vim (powerful but has a learning curve)

**Popular Alternatives**:
- Notepad++
- Visual Studio Code
- Sublime Text

Note: This setting can be changed later if needed.

## Initial Branch Name

### Understanding Default Branch Names

Git allows configuration of the default branch name for new repositories:

- **Default**: `master`
- **Alternative options**: `main`, `trunk`, or custom names

This represents the primary development line in a project, and the concept of branches will be covered in detail later in the course.

## PATH Environment Settings

### Command Line Accessibility

This critical setting controls how Git integrates with the Windows command line:

**Recommended Option**: "Git from the command line and also from 3rd-party software"

This enables Git commands in:
- Git Bash terminal
- Windows Command Prompt
- PowerShell
- Third-party applications

Other options:
- Use Git Bash only
- Use Git and optional Unix tools

## SSH Executable

### Secure Connection Configuration

SSH settings determine how Git establishes secure connections to remote repositories:

**Recommended**: "Use bundled OpenSSH"
- Includes everything needed
- No additional configuration required

**Alternative**: "Use external OpenSSH"
- For users with existing SSH setups
- May require additional configuration

## HTTPS Transport Backend

### Secure Communication Method

The HTTPS backend handles secure communication with remote servers:

**Recommended**: "Use the native Windows Secure Channel library"
- Leverages Windows built-in security features
- Provides seamless integration with Windows certificate management

Alternative options exist for specific use cases.

## Line Ending Conversions

### Cross-Platform Compatibility

Line ending configuration ensures compatibility across different operating systems:

**Recommended**: "Checkout Windows-style, commit Unix-style line endings"

This setting:
- Converts line endings when checking out files (Windows format)
- Converts back to Unix format when committing
- Ensures consistency when collaborating across Windows, macOS, and Linux

## Terminal Emulator

### Git Bash Terminal Options

Git Bash requires a terminal emulator to function:

**Recommended**: "Use MinTTY"
- Provides a clean, user-friendly interface
- Better rendering and scrollback support

**Alternative**: Windows Default Console
- Matches the standard Windows command prompt appearance
- May have limitations in functionality

## Git Pull Behavior

### Merge Strategy Configuration

This setting defines how `git pull` handles incoming changes:

**Default**: "Fast-forward or merge"
- Attempts fast-forward first
- Falls back to merge if needed
- Standard behavior suitable for beginners

This will be explored in greater depth in upcoming lectures.

## Credential Helper

### Authentication Management

The credential helper securely manages authentication credentials:

**Recommended**: Git Credential Manager
- Securely stores usernames and passwords
- Eliminates need to re-enter credentials frequently
- Integrates with Windows credential storage

Enabled by default for convenience and security.

## Additional Options

### Performance and Advanced Features

The final configuration screen includes:

- **File system caching**: Improves performance (enabled by default)
- **Symbolic links**: Support for creating symbolic links
- Additional experimental features

For most users, accepting defaults is recommended.

## Complete Installation

### Installation Process

1. Review all selected options on the final screen
2. Click **Install** to begin the installation
3. Wait for the process to complete (typically under 1 minute)
4. The setup wizard shows progress during installation

## Verify Installation

### Post-Installation Verification

After installation completes:

1. The installer offers to launch Git Bash
2. Keep "Launch Git Bash" checked
3. Uncheck "View Release Notes" (optional)
4. Click **Finish**

### Testing the Installation

Open Git Bash and run verification commands:

```bash
git --version
```

Expected output: `git version 2.51.0.windows.1`

To see available Git commands:

```bash
git
```

This displays the Git command reference, confirming proper installation.

## Summary

Git installation on Windows is complete. The installer provides sensible defaults that work well for most users. Key configuration decisions include:
- PATH integration for command-line access
- Line ending handling for cross-platform work
- Credential management for authentication
- Default branch naming conventions

With Git successfully installed, users can proceed to configuration steps covered in subsequent demonstrations.

</details>