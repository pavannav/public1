# Section 1: Recommended Lab Setup

<details open>
<summary><b>Section 1: Recommended Lab Setup (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [1.1 Recommended Lab Setup](#11-recommended-lab-setup)
- [1.2 Potential Virtualization Systems](#12-potential-virtualization-systems)
- [1.3 Configuring Linux Virtual Machines](#13-configuring-linux-virtual-machines)
- [1.4 Configuring NAT](#14-configuring-nat)
- [1.5 Using SSH](#15-using-ssh)
- [1.6 Working with the Terminal](#16-working-with-the-terminal)
- [1.7 Basic Linux Commands](#17-basic-linux-commands)
- [1.8 Using Text Editors](#18-using-text-editors)
- [1.9 Using VSCode](#19-using-vscode)
- [1.10 Accessing the Course Repository](#110-accessing-the-course-repository)
- [Summary](#summary)

---

## 1.1 Recommended Lab Setup

### Overview
This module introduces the recommended hardware and virtualization options for setting up a lab environment for the Linux Networking course, including physical machines, virtual machines, and cloud-based systems with specific guidance on choosing appropriate platforms.

### Key Concepts

#### Lab Setup Options

**Physical Machines**
- ✅ **Recommended approach** for hands-on networking experience
- Old hardware works well with Linux - even 10-year-old systems run effectively
- Laptops offer built-in wired and wireless network interfaces for comprehensive learning
- Intel-based systems (CPU + GPU) provide the best compatibility
- Sources: Friends, family, shopping portals, garage sales

**Virtual Machines (VMs)**
- Excellent alternative when physical hardware is unavailable
- Run locally using virtualization platforms like VirtualBox or KVM
- Both instructor and course content demonstrate VM-based setups

**Cloud-Based Systems**
- ⚠️ **Not recommended** due to networking complexity
- Requires same-subnet configuration for inter-machine communication
- Must use console connections instead of SSH for control
- Incurs ongoing costs

**Avoid These Options**
- ❌ Windows Subsystem for Linux (WSL)
- ❌ Containers
- ❌ Sandboxes

#### Recommended Configuration

**Minimum Setup**
- 2 machines: 1 server + 1 client
- Debian Server and Debian Client combination works best
- Debian's lightweight footprint enables smooth operation on older hardware

**Optimal Setup**
- Multiple machines enhance learning experience
- Add Fedora Workstation for diversity
- GNOME desktop environment used throughout the course

#### Instructor's Lab Environment

```
Dave's Lab Setup Components:

Virtual Machines (on main system):
├── Debian Server
├── Debian Client  
├── Ubuntu Server
├── CentOS
├── Fedora Server
├── Fedora Workstation
├── OpenSUSE
└── Mystery VMs

Physical Systems:
├── Debian Laptop (10 years old, wired + wireless)
├── Ubuntu Desktop Server (Supermicro, 6 wired + wireless)
└── Proxmox (Dell R630, 4 wired connections)

External Access:
└── Cloud-based systems via internet
```

### Lab Resources
- 📝 **Lab Setup Document**: Available in the course repository at github.com/daveprowse/linux-net
- 💡 **Step-by-Step Installation Guides**: Available at prowse.tech/linux-installs (both video and article formats)

---

## 1.2 Potential Virtualization Systems

### Overview
This module examines various virtualization platforms available for running Linux virtual machines, ranging from free desktop solutions to enterprise-grade server hypervisors, with specific recommendations based on experience level.

### Key Concepts

#### Desktop Virtualization Options

| Platform | Cost | Platform | Best For |
|----------|------|----------|----------|
| **VirtualBox** | Free | Windows, macOS, Linux, Solaris | Beginners (recommended) |
| **Hyper-V** | Free (Windows Pro/Enterprise) | Windows | Windows users |
| **VMware Workstation** | Paid | Windows, macOS | Field professionals |
| **Parallels** | Paid | macOS only | Mac users |

#### Server/Advanced Virtualization Options

| Platform | Cost | Platform | Notes |
|----------|------|----------|-------|
| **KVM** | Free | Linux (macOS possible) | Type 1 hypervisor, powerful and fast |
| **Proxmox** | Free | Debian + KVM based | Requires dedicated system |
| **ESXi** | Free (no vCenter) | Dedicated server | VMware server-side solution |

#### Instructor's Choices
- **Primary**: KVM on Debian Linux (main system)
- **Secondary**: Proxmox on Dell R630 server
- **Demonstrates**: VirtualBox for broad accessibility

### Recommendations by Experience Level

> [!NOTE]
> Start simple and advance as your virtualization skills develop.

**Beginners**
- Start with: VirtualBox (free, cross-platform)
- Alternative: Hyper-V or VMware Workstation

**Intermediate**
- Consider: KVM or Proxmox
- Explore: ESXi with vCenter

---

## 1.3 Configuring Linux Virtual Machines

### Overview
This hands-on module demonstrates the complete process of creating and configuring Linux virtual machines in both VirtualBox and KVM, covering hardware allocation, ISO selection, and post-installation tips.

### Key Concepts

#### VirtualBox VM Creation Process

**Step-by-Step Configuration**

1. **Access Creation Wizard**
   - Machine → New Machine
   - Or use the New button in the toolbar

2. **Basic Settings**
   ```
   Name: Debian Server
   ISO Image: debian-12.1-amd64-netinstallation.iso
   Type: Linux → Debian (auto-detected)
   ```

3. **Installation Type Decision**
   - ✅ **Unattended Installation**: For client VMs only
     - Default credentials: vboxuser/vboxuser
   - ❌ **Skip Unattended**: For server VMs
     - Requires manual configuration
     - No GUI/desktop installation

4. **Hardware Allocation**
   | Resource | Server Minimum | Client/Desktop Recommendation |
   |----------|----------------|------------------------------|
   | RAM | 2GB | 2GB+ |
   | CPUs | 2 | 2+ |
   | Storage | 20GB | 40-50GB |

#### Post-Creation Tips

**Window Management**
- Full Screen: Host Key + F
- Scaled Mode: Host Key + C
- Host Key (PC): Right Ctrl key

**Installation Navigation**
- Servers: Use keyboard-only navigation
- Clients: Graphical install available
- Access Advanced Options via menu for specialized needs

#### KVM Workflow

**Access Method**
- Use Virtual Machine Manager GUI
- Double-click existing VMs to open
- Click Play to boot

**Resources**
- 📝 KVM Guide: prowse.tech/kvm

---

## 1.4 Configuring NAT

### Overview
This module explains Network Address Translation (NAT) concepts in virtualization environments, with specific focus on configuring NAT Networks in VirtualBox to enable inter-VM communication.

### Key Concepts

#### NAT Types Comparison

| NAT Type | Internet Access | Host ↔ VM | VM ↔ VM | Use Case |
|----------|----------------|-----------|---------|----------|
| **NAT (Default)** | ✅ | ✅ | ❌ | Isolated VMs |
| **NAT Network** | ✅ | ✅ | ✅ | Multi-VM environments |

#### VirtualBox NAT Network Configuration

**Two-Step Process**

**Step 1: Create NAT Network**
```
Path: File → Tools → Network Manager → NAT Networks
- Click "Create" for new network
- Default subnet: 10.0.2.0/24
- DHCP server: Enabled by default
```

**Step 2: Configure VM Network Adapter**
```
VM Settings → Network → Adapter 1
Attachment: NAT Network (not NAT)
Select: Your created NAT network
```

#### Platform Differences

> [!IMPORTANT]
> Only VirtualBox requires manual NAT Network configuration. Other platforms default to NAT Network behavior.

| Platform | Default Behavior |
|----------|------------------|
| VMware Workstation | NAT Network |
| KVM | NAT Network |
| VirtualBox | NAT (requires manual change) |

### Key Takeaway
> [!WARNING]
> VMs on default NAT cannot communicate with each other. NAT Network is essential for multi-machine lab setups.

---

## 1.5 Using SSH

### Overview
This module covers SSH installation across operating systems, basic usage for remote connections, and VirtualBox-specific port forwarding configuration required for SSH access to NAT-configured VMs.

### Key Concepts

#### SSH Installation by Platform

**Linux (Debian/Ubuntu)**
```bash
sudo apt install openssh-server
ssh -V  # Verify: OpenSSH 9.2+
```

**macOS**
```bash
brew install openssh
# Alternative: MacPorts
```

**Windows**
- Settings → Apps → Optional Features → OpenSSH Client/Server
- Chocolatey: `choco install openssh --pre`

#### Basic SSH Usage

**Connection Syntax**
```bash
ssh username@ip_address
# Example:
ssh user@10.0.2.52
```

#### VirtualBox Port Forwarding

> [!IMPORTANT]
> VirtualBox NAT requires port forwarding for SSH access. This complexity doesn't exist in KVM or VMware.

**Configuration Steps**
```
File → Tools → Network Manager → NAT Networks → Port Forwarding

Rule Settings:
- Name: PF for SSH to [VM Name]
- Protocol: TCP
- Host IP: 127.0.0.1
- Host Port: 2222 (or any available port)
- Guest IP: [VM's IP, e.g., 10.0.2.15]
- Guest Port: 22
```

**Connecting via Port Forward**
```bash
ssh -p 2222 username@127.0.0.1
```

**Default Unattended Credentials**
- Username: vboxuser
- Password: changeme (⚠️ Must be changed immediately)

### Security Note
> [!WARNING]
> Always change default passwords on unattended installations before production use.

---

## 1.6 Working with the Terminal

### Overview
This module demonstrates essential terminal operations in the GNOME desktop environment, including launching, window management, customization, and keyboard shortcuts for efficient terminal usage.

### Key Concepts

#### Launching the Terminal

**GNOME Desktop**
- Press Super key (Windows/Command key)
- Type "terminal" in search
- Or use custom shortcut: Ctrl + Alt + T

#### Window Management Shortcuts

| Action | Shortcut |
|--------|----------|
| Maximize | Super + ↑ |
| Restore | Super + ↓ |
| Snap Right | Super + → |
| Snap Left | Super + ← |
| Toggle Terminal Group | Alt + ` (backtick) |
| Switch Programs | Alt + Tab |

#### Font and Display Control

```
Increase Font: Ctrl + Shift + +
Decrease Font: Ctrl + -
```

#### Color Customization
- Right-click → Preferences → Colors
- Predefined themes: Tango Light, Dark variants
- Custom color selection available

#### Multi-Terminal Management

**Opening Additional Terminals**
```bash
gnome-terminal
```

**Navigation Between Terminals**
- Alt + ` : Switch within terminal group
- Alt + Tab : Switch between different applications

#### Exit Methods
```bash
exit
# or
Ctrl + D
```

---

## 1.7 Basic Linux Commands

### Overview
This module introduces fundamental Linux filesystem navigation and file management commands essential for working effectively in the Bash shell environment.

### Key Concepts

#### Essential Navigation Commands

| Command | Description | Example |
|---------|-------------|---------|
| `ls` | List directory contents | `ls` |
| `cd` | Change directory | `cd documents` |
| `pwd` | Print working directory | `pwd` |

#### Directory Navigation Patterns

```bash
# Absolute paths
cd /home/user/documents

# Relative navigation
cd documents          # Down into documents
cd ..                 # Up one level (parent directory)
cd -                  # Return to previous directory
cd                    # Return to home directory (~)

# Home directory indicators
~                     # User's home directory
$ echo $0            # Shows current shell (bash)
```

#### File Creation and Management

**Touch Command**
```bash
touch test.txt        # Create empty file
ls                    # Verify creation
```

**Directory Creation**
```bash
mkdir test_dir        # Create directory
ls                    # Directories shown first (blue)
```

**Removal Operations**
```bash
rm test.txt           # Remove file
rm -r test_dir        # Remove directory recursively
# Alternative for directories: rmdir (some systems)
```

#### Bash Auto-Completion

```
Type partial name → Tab → Auto-completes
test → Tab → Shows options if ambiguous
test.txt → Tab → Completes uniquely
```

#### Keyboard Shortcuts

| Shortcut | Function |
|----------|----------|
| Tab | Auto-complete |
| Ctrl + W | Delete last word |
| Ctrl + U | Clear to beginning |
| Ctrl + L | Clear screen (not buffer) |
| ↑/↓ | Command history |

#### Shell Identification
```bash
echo $0    # Output: bash
```

### Important Notes
- ✅ "No news is good news" - successful commands produce no output
- ✅ Bash is the primary shell for Linux servers
- 📝 Additional shortcuts available in course repository

---

## 1.8 Using Text Editors

### Overview
This module compares three text editors available in Linux environments - Vim, Nano, and Gedit - with specific guidance on their appropriate use cases, particularly distinguishing between server and desktop environments.

### Key Concepts

#### Editor Comparison Matrix

| Editor | Environment | Learning Curve | Best For |
|--------|-------------|----------------|----------|
| **Vim** | CLI (any) | Steep | Servers, config files |
| **Nano** | CLI (any) | Gentle | Quick edits |
| **Gedit** | GUI only | Minimal | Desktop environments |

#### Vim Workflow

**Mode-Based Operation**
```bash
# Command Mode (default)
vim filename.txt

# Enter Insert Mode
i                     # Insert at cursor
# Type your content...

# Return to Command Mode
Esc

# Save and Quit
:wq                   # Write and quit
:w                    # Write only
:q                    # Quit (if saved)
Shift + ZQ           # Force quit without saving
```

#### Nano Workflow

**Direct Editing**
```bash
nano filename.txt     # Start typing immediately

# Bottom menu shows shortcuts
# ^ = Ctrl key
Ctrl + X             # Exit
Y                    # Confirm save
Enter                # Accept filename
```

#### Gedit Installation and Usage

**Installation (if needed)**
```bash
sudo apt install gedit
```

**Root Access Methods**
```bash
su -                  # Switch to root (needs root password)
sudo -i              # Become root using sudo
```

**File Operations**
- Standard GUI shortcuts (Ctrl+S, etc.)
- Forks the terminal (terminal waits for close)
- Non-forking: Loses terminal access during edit

### Environment-Specific Guidance

> [!IMPORTANT]
> **Servers**: Use Vim or Nano only (text-only environments)
> **Desktops**: Any editor works, but Vim/Nano recommended for config files

### Security Consideration
> [!WARNING]
> Avoid VS Code for Linux configuration files requiring sudo - potential security risk

---

## 1.9 Using VSCode

### Overview
This module provides guidance on installing and using Visual Studio Code for Linux development, including keyboard navigation and appropriate use cases within the course context.

### Key Concepts

#### Installation by Package Type

| Distribution | Extension | Command |
|--------------|-----------|---------|
| Debian/Ubuntu | .deb | `sudo dpkg -i code_*.deb` |
| Red Hat/Fedora | .rpm | `sudo rpm -i code_*.rpm` |
| SUSE | .rpm | `sudo rpm -i code_*.rpm` |

**Download Location**: code.visualstudio.com/download

#### VS Code Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| Toggle Terminal | Ctrl + ` |
| Explorer Panel | Ctrl + Shift + E |
| Code Window 1 | Ctrl + 1 |
| Code Window 2 | Ctrl + 2 |
| Rename File | F2 |
| Markdown Preview | Ctrl + Shift + V |

#### Appropriate Use Cases

**✅ Recommended For**
- Programming in various languages
- Markdown file editing
- Repository file management
- General development work

**❌ Avoid For**
- Linux configuration files requiring sudo
- System-level modifications
- Security-sensitive operations

### Markdown Preview
```
Right-click file → Open Preview
# or
Ctrl + Shift + V
```

---

## 1.10 Accessing the Course Repository

### Overview
This module explains how to access and navigate the course's GitHub repository, which contains all lab documentation, setup guides, and supporting materials in markdown format.

### Key Concepts

#### Repository Contents

```
github.com/daveprowse/linux-net/
├── Lab Setup Document
├── Labs/
│   ├── lab01-ipa-command.md
│   └── [additional labs]
└── Scripts/
```

#### Access Methods

**Method 1: Direct GitHub Access**
- Browse at: github.com/daveprowse/linux-net
- Markdown renders with clickable links
- Copy-paste ready code blocks

**Method 2: Git Clone**
```bash
# Install git if needed
sudo apt install git

# Clone repository
git clone https://github.com/daveprowse/linux-net

# Navigate
cd linux-net
ls
```

**Method 3: VS Code Integration**
```
File → Open Folder → Select linux-net directory
Ctrl + Shift + V → Preview markdown files
```

#### Markdown Features in VS Code

- **Preview Mode**: Renders formatted view with clickable links
- **Easy Navigation**: Better readability than raw markdown
- **Resource Access**: Links to external guides and documentation

### Available Resources
- 📝 Lab Setup Document (PDF-style guide)
- 📝 Individual lab markdown files
- 📝 Bash shortcuts reference
- 🔗 Links to installation guides at prowse.tech

---

## Summary

### Key Takeaways
```diff
+ Physical or VM-based labs are essential; avoid WSL/containers for this course
+ VirtualBox requires manual NAT Network configuration and port forwarding for SSH
+ Debian provides the optimal balance of lightweight operation and compatibility
+ Master terminal navigation and basic commands before proceeding
+ Vim and Nano are the primary editors for server configuration
+ The course repository contains all lab documentation and reference materials
```

### Quick Reference

| Task | Command/Action |
|------|----------------|
| Open Terminal | Super key → type "terminal" |
| Navigate home | `cd` or `cd ~` |
| List files | `ls` |
| Create file | `touch filename` |
| Create directory | `mkdir dirname` |
| Remove file | `rm filename` |
| Remove directory | `rm -r dirname` |
| Edit with Vim | `vim filename` |
| Edit with Nano | `nano filename` |
| SSH connection | `ssh user@ip` |
| SSH with port forward | `ssh -p PORT user@127.0.0.1` |

### Expert Insight

**Real-world Application**
Setting up a proper lab environment is crucial for networking courses. The decision between physical and virtual machines impacts hands-on learning quality. VirtualBox's unique networking requirements teach important NAT concepts, while Debian's lightweight nature ensures compatibility across diverse hardware.

**Expert Path**
Progress from VirtualBox to KVM for better performance and native Linux integration. Master both CLI editors (Vim/Nano) as servers rarely have GUIs. Build a multi-machine environment that simulates real network topologies.

**Common Pitfalls**
- Forgetting to change VirtualBox from NAT to NAT Network
- Not setting up SSH port forwarding in VirtualBox
- Using containers/WSL which won't demonstrate true networking concepts
- Keeping default passwords on unattended installations
- Attempting to use GUI editors on headless servers

**Lesser-Known Facts**
- VirtualBox's default NAT creates a private network invisible to other VMs
- The host key in VirtualBox varies by host OS (Right Ctrl on Windows)
- Proxmox requires a dedicated system as it's a complete OS + hypervisor
- Debian's small footprint allows it to run effectively on decade-old hardware

</details>