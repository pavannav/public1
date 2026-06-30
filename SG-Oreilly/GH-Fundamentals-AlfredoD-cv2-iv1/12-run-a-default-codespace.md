# Section 12: Run A Default Codespace

<details open>
<summary><b>Section 12: Run A Default Codespace (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [Overview](#overview)
- [Repository Selection and Access](#repository-selection-and-access)
- [Understanding the Code Tab Interface](#understanding-the-code-tab-interface)
- [Creating a Default Codespace](#creating-a-default-codespace)
- [Codespace Setup and Loading Process](#codespace-setup-and-loading-process)
- [Verifying the Codespace Environment](#verifying-the-codespace-environment)
- [Managing Active Codespaces](#managing-active-codespaces)
- [Summary](#summary)

## Overview

This section demonstrates how to create and run a default GitHub Codespace on any repository where Codespaces are enabled. It covers the complete workflow from repository selection through Codespace creation, setup verification, and basic management of running Codespaces.

## Repository Selection and Access

The process begins in the user's GitHub account by navigating to the Repositories tab. This functionality works on any owned repository with Codespaces enabled.

**Key Points:**
- No special repository configuration is required
- Works on any repository the user owns with Codespaces enabled
- Example used: "DemoFunction" repository - a simple Azure Functions demo without even a README file
- No special setup or configuration needed in the repository itself

## Understanding the Code Tab Interface

When accessing the Code tab on a repository, users see different options depending on their setup and permissions.

**Local Tab Options:**
- HTTPS cloning method (most common for users without SSH keys)
- SSH cloning method (for users with configured SSH keys)
- GitHub CLI option
- Purpose: Clone repository contents to local computer

**Codespaces Tab:**
- Appears when Codespaces are enabled on the repository
- Provides option to "Run codespaces"
- Offers creation of Codespace on the main branch by default

## Creating a Default Codespace

The creation process is straightforward with minimal user input required for a default setup.

**Steps to Create:**
1. Navigate to the repository's Code tab
2. Click on the "Codespaces" tab (appears when enabled)
3. Select "Create codespace on main" (default option)
4. Click to initiate creation

**What Happens:**
- Page shows progress with checkmarks during setup
- Creation process typically completes quickly
- VS Code interface loads in the browser

## Codespace Setup and Loading Process

During the initial setup, several automated processes occur to prepare the development environment.

**Setup Sequence:**
1. **Infrastructure Provisioning**: Cloud resources allocated for the Codespace
2. **Container Setup**: Development environment container configured
3. **Extension Installation**: User's VS Code extensions automatically installed
4. **Settings Sync**: If VS Code sync is enabled, personal settings are applied
5. **Interface Loading**: Full VS Code interface becomes available in browser

**User Experience Notes:**
- Loading time varies but is generally quick
- Extension installation may show visual indicators of activity
- Experience may differ slightly for users without settings sync enabled

## Verifying the Codespace Environment

Once loaded, users should verify they're in the cloud environment rather than their local machine.

**Verification Methods:**
- Open the integrated terminal
- Run system commands like `uname -a` or `lsb_release -a`
- Confirm the OS shows Ubuntu 20.04 (or current default)
- Verify the environment URL indicates browser-based access

**Important Indicators:**
- Running in browser, not on local computer
- Full access to terminal and development tools
- Environment is completely separate from local machine

## Managing Active Codespaces

GitHub provides management capabilities for all running Codespaces from the repository interface.

**Accessing Management:**
1. Return to the repository's Code tab
2. Navigate to Codespaces section
3. View all running Codespaces with status information
4. Click "Manage all" for comprehensive controls

**Management Options:**
- View running duration for each Codespace
- Access individual Codespace controls
- Delete Codespaces when no longer needed
- Monitor resource usage

## Summary

### Key Takeaways
```diff
+ Codespaces work on any owned repository with the feature enabled
+ No repository configuration or special files needed for basic usage
+ Default creation uses the main branch automatically
+ Full VS Code experience runs entirely in the browser
+ Environment verification confirms cloud-based execution (Ubuntu 20.04)
+ Management interface allows deletion of unused Codespaces
```

### Quick Reference
| Action | Location | Result |
|--------|----------|--------|
| Access Codespaces | Repository → Code tab → Codespaces | Shows creation options |
| Create default Codespace | Click "Create codespace on main" | Starts cloud environment |
| Verify environment | Terminal → `uname -a` | Shows Ubuntu 20.04 |
| Manage Codespaces | Code tab → Manage all | Delete/view all instances |

### Expert Insight

**Real-world Application:**
Default Codespaces provide instant development environments for quick reviews, pair programming, or when working from machines without local development tools. They're ideal for open source contributors who need to make quick fixes without setting up local environments.

**Expert Path:**
- Experiment with creating Codespaces on different repository types
- Explore the differences between default and custom Codespace configurations
- Learn about Codespace lifecycle management and billing implications
- Practice using the terminal and extensions in the cloud environment

**Common Pitfalls:**
- Forgetting that running Codespaces consume resources/billing allocation
- Not verifying the environment before making changes (could affect production if misidentified)
- Assuming all extensions will work identically to local VS Code
- Leaving Codespaces running unnecessarily

**Lesser-Known Facts:**
- The default Ubuntu version (20.04) is specifically chosen for compatibility
- Extension installation happens automatically but may take additional time after initial load
- Even repositories without any configuration files can use default Codespaces
- The "Manage all" option shows Codespaces across all repositories, not just the current one

</details>