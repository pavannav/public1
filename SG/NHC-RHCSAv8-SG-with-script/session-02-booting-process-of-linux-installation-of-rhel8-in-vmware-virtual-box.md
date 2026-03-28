<details open>
<summary><b>Section 02: Booting Process of Linux Installation of RHEL8 in VMware Virtual Box (CL-KK-Terminal)</b></summary>

# Section 02: Booting Process of Linux Installation of RHEL8 in VMware Virtual Box

## Table of Contents
- [Introduction to UNIX and Linux](#introduction-to-unix-and-linux)
- [Distributions and Features](#distributions-and-features)
- [Kernel and Operating System Components](#kernel-and-operating-system-components)
- [Booting Sequence](#booting-sequence)
- [File System Hierarchy](#file-system-hierarchy)
- [Virtualization Software Installation](#virtualization-software-installation)
- [Creating a Virtual Machine](#creating-a-virtual-machine)
- [RHEL8 Installation Steps](#rhel8-installation-steps)
- [Post-Installation Access](#post-installation-access)

## Introduction to UNIX and Linux
The transcript discusses the history and evolution of UNIX and Linux operating systems. UNIX was developed by Ken Thompson and Dennis Ritchie in the late 1960s at Bell Labs, initially as a multitasking system for PDP computers. It was a proprietary system used mostly for research.

Linux is a UNIX-like open-source operating system, with its kernel developed by Linus Torvalds in 1991. While UNIX and Linux share similar concepts, they are distinct - Linux is not derived from UNIX but inspired by it. Linux provides the GNU utilities (from the GNU project) and is distributed under free software foundations.

Key correction note: The transcript mentions "gnu" should be "GNU" (an acronym for GNU's Not Unix).

## Distributions and Features
Linux distributions (distros) are customized versions of Linux with additional software and configurations. Major categories include:
- UNIX-based distros (e.g., IBM AIX, Solaris from Oracle)
- Linux-based distros (e.g., Fedora, CentOS, Ubuntu)

### Linux Features:
- **Security**: Highly secure with built-in access controls
- **Stability**: Reliable for server environments
- **Hardware Independence**: Runs on various architectures
- **Multi-user & Multi-tasking**: Supports multiple users simultaneously
- **Customizable**: Extensive options for adaptations
- Widespread usage: From smartphones to supercomputers

Popular distros:
- Fedora (actively maintained by Red Hat)
- CentOS (server-focused, derived from Fedora)
- Ubuntu (desktop and server editions by Canonical)

## Kernel and Operating System Components
The kernel is the core of the OS, responsible for managing hardware interactions. It acts as a bridge between user applications and physical devices, handling instructions from the user through shells and translating them into hardware-executable actions.

Shell/CLI: The command-line interface used for interacting with the system. Remote access is possible via SSH clients like PuTTY, Termius, or mobile apps after authentication with username/passwd.

User accounts are required for machine access. Can create accounts via admin or sudo commands.

## Booting Sequence
Linux's booting process is systematic and involves several stages:

1. **Power On Self Test (POST)**: Machine initializes hardware upon power-on, checking components.
2. **BIOS/UEFI**: Basic Input Output System (now often UEFI) initializes, detecting hardware and loading settings from CMOS (battery-backed memory).
3. **Master Boot Record (MBR)**: Located in the first sector of primary hard disk, contains partition info and references to bootloaders.
4. **GRUB Bootloader**: GRand Unified Bootloader loads the kernel image from RAM. GRUB detects the init ramdisk (initrd) for temporary filesystem access.
5. **Kernel Loading**: Kernel loads, initializing hardware and mounting root filesystem.
6. **Init System**: Determines runlevel/target mode (e.g., single-user, multi-user with/without networking, graphical mode).

Runlevels explained:
- 0: Halt/Shutdown
- 1: Single-user mode (no network, maintenance)
- S: Single-user mode (no network)
- 2: Multi-user mode (no network)
- 3: Multi-user mode (with network)
- 5: Multi-user graphical mode (default for desktops)
- 6: Reboot

`init 0`, `shutdown`, `halt`, `reboot` commands control system state.

## File System Hierarchy

### Root Directory (/)
Acts as the parent directory for all others.

### Standard Directories:
- `/bin`: Essential binaries (commands like ls, cat)
- `/etc`: System configuration files
- `/home`: User home directories (e.g., /home/user)
- `/lib`: Kernel modules and shared libraries
- `/boot`: Boot-related files (GRUB, initrd, kernel images)
- `/dev`: Device files (hardware representations)
- `/var`: Variable data (logs, databases)
- `/usr`: User applications, read-only by default
- `/proc`: Kernel and process information (virtual filesystem)
- `/root`: Home directory for root user (admin)
- `/tmp`: Temporary files (cleared on reboot)
- `/opt`: Optional software packages

> [!NOTE]
> Key correction: Directory names are typically lowercase (e.g., /home, not /Home).

This structure is standardized across Linux distributions.

## Virtualization Software Installation
To install RHEL8 virtually:
1. Choose virtualization platform: VMware Workstation Pro/Fusion (recommended), Oracle VirtualBox, or VMware Workstation/Player.
2. Download from official sites:
   - VMware: vmware.com/workstation-pro/player
   - VirtualBox: virtualbox.org

No license required for personal use with either.

VMware preferred for advanced features, but VirtualBox works equally well.

## Creating a Virtual Machine
Steps for VMware:
1. Launch VMware, click "Create a New Virtual Machine"
2. Select "Typical" or "Custom"
3. Choose "Installer disc image file (iso)" and select RHEL8 DVD ISO (downloaded from redhat.com/downloads or via Red Hat Developer Portal)
4. Set VM name (e.g., RHEL8)
5. Assign CPU: Minimum 1 core (2+ recommended)
6. Assign RAM: Minimum 2GB (4GB+ for better performance)
7. Network: NAT (local access) or Bridge (LAN access)
8. I/O Controller: SCSI
9. Virtual disk: 30GB+ VDI/NVME format
10. Start VM: Boot from ISO

## RHEL8 Installation Steps
1. Boot VM → Select "Install Red Hat Enterprise Linux 8" → Enter
2. Installation wizard appears
3. Select language: English (India)
4. Configure:
   - Keyboard: English (India - Rupee sign)
   - Software: Server with GUI (for desktop) or Minimal (for CLI-only)
   - Network: Enable for internet access
   - Security: Leave default
   - Root password: Set admin password
   - User account: Create non-root user (optional admin)
   - Installation destination: 30GB disk
5. Partitioning:
   - Manual: Create /boot (1GB), swap (2GB or RAM equivalent), / (remaining ~27GB) standardized partitions
   - File systems: ext4 for Linux
   - Or auto-partition: "Installation Destination" → Custom → Done (auto-creates standard partitions)
6. Begin installation: Packages install
7. Reboot: VM boots from local HDD

Installation may take 30-60 minutes depending on system.

## Post-Installation Access
### Console Access:
- Power on VM
- Login with user/passwd or root/passwd

### Remote Access:
1. Get VM IP: Run `ip addr` (e.g., 192.168.x.x)
2. Use SSH clients:
   - PuTTY (Windows): Enter IP, login
   - Termius/Mobile apps: SSH over mobile
   - SSH from another Linux/WSL: `ssh user@IP`

### Commands:
- View OS details: `cat /etc/redhat-release`
- View kernel: `uname -r`
- View filesystem: `ls /` or navigate directories

Root access: Use `su -` or `sudo` commands as needed. Never run as root for regular tasks.

## Key Takeaways
```diff
+ Linux is a UNIX-like OS with open-source advantages
+ Booting involves hardware init, bootloader, kernel loading, and runlevel configuration
+ Root filesystem hierarchy organizes system components logically
+ Virtualization enables safe RHEL8 testing without hardware commitment
- Misconfigurations during partitioning can cause system instability
- Always secure root and user passwords to prevent unauthorized access
! Enable network during install for updates and remote access
```

## Quick Reference
- **Boot Order**: POST → BIOS/UEFI → MBR → GRUB → Kernel → Init
- **Runlevels**: 0=halt, 1=single-user, 3=multi-user (CLI), 5=graphical
- **Partition Sizes**:
  - /boot: 1GB
  - swap: 2GB or RAM size
  - /: Remaining space
- **Commands**: `ip addr` (check IP), `uname -r` (kernel version), `ls /` (filesystem)

## Expert Insight
### Real-world Application
In enterprise environments, understanding the booting sequence helps troubleshoot startup issues (e.g., GRUB repairs). Virtualization with RHEL8 mirrors production setups for secure software development and testing on varied hardware.

### Expert Path
Master dual-booting by configuring GRUB for multi-OS systems. Learn `grub-mkconfig` for bootloader customization and SELinux policies for enhanced security during installation.

### Common Pitfalls
- **Partition Mismatch**: Incorrect sizes (e.g., oversized swap) waste disk space; undersized /boot causes failures.
- **Network Disabled**: Installation without network misses critical updates; enable in wizard.
- **Root Overuse**: Logging as root routinely risks system corruption; use `visudo` for sudo management.
- **ISO Source**: Using unofficial RHEL8 ISOs may include malware; download from redhat.com.

</details>
