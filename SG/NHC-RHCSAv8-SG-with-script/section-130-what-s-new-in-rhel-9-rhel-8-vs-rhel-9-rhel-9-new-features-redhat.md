# Section 130: Red Hat Certified Systems Administrator Version 9 (RHCSA v9) Introduction

<details open>
<summary><b>Section 130: Red Hat Certified Systems Administrator Version 9 (RHCSA v9) Introduction (CL-KK-Terminal)</b></summary>

## Table of Contents

1. [Course Introduction and Conclusion](#course-introduction-and-conclusion)
2. [RHEL Version Comparison Overview](#rhel-version-comparison-overview)
3. [Architectural Differences](#architectural-differences)
4. [Package Management and File Systems](#package-management-and-file-systems)
5. [Security and Policy Changes](#security-and-policy-changes)
6. [Networking Changes](#networking-changes)
7. [Programming Language Support](#programming-language-support)
8. [Virtualization and Storage Changes](#virtualization-and-storage-changes)
9. [Container Runtime Updates](#container-runtime-updates)
10. [RHEL 9 Installation Demonstration](#rhel-9-installation-demonstration)
11. [Post-Installation Verification](#post-installation-verification)
12. [Discussion and Q&A Session](#discussion-and-qa-session)

## Course Introduction and Conclusion

### Overview
This session marks the conclusion of the RHCSA v8 training series and serves as an introduction to RHCSA v9. The instructor celebrates completing a year-long training effort and provides a comprehensive comparison between RHEL 7, RHEL 8, and RHEL 9.

### Key Points
- **Series Completion**: Final session of RHCSA v8 course after one year of weekly sessions
- **Transition Planning**: Introduction of RHEL 9 differences and new features
- **Community Engagement**: Special Happy Teachers' Day wishes to all instructors
- **Future Content**: Promise of comprehensive RHEL 9 series and additional courses (Ansible, Satellite)

## RHEL Version Comparison Overview

### Release Information

| Feature | RHEL 7 | RHEL 8 | RHEL 9 |
|---------|--------|--------|--------|
| **Release Date** | - | May 7, 2019 | May 17, 2022 |
| **Code Name** | - | Ootpa | Plow |
| **Kernel Version** | 3.10 | 4.18 | 5.14 |
| **Default File System** | XFS | XFS | XFS |
| **Architecture** | 64-bit AMD | 64-bit AMD (+ IBM) | 64-bit AMD (+ IBM) |
| **Package Manager** | YUM | DNF/YUM | DNF/YUM |

### Major Changes Timeline
- **RHEL 7 → RHEL 8**: Major architectural overhaul (2019)
- **RHEL 8 → RHEL 9**: Feature refinement and modernization (2022)
- **Training Gap**: 3+ years between major versions, allowing new features to mature

## Architectural Differences

### Kernel and Base Components

#### Kernel Versions
```diff
- RHEL 8: Kernel version 4.18
+ RHEL 9: Kernel version 5.14 (major upgrade enabling new features)
```

#### Initial Setup Changes
> [!IMPORTANT]
> In RHEL 9, the initial setup screen has been disabled to improve user experience. Users can no longer set basic configurations during first boot.

### Subscription and Licensing
- **RHEL 8**: Initial setup included licensing/subscription prompts
- **RHEL 9**: No subscription prompts during installation (configured separately)

## Package Management and File Systems

### Repository Structure
- **Consistent**: Both versions maintain `BaseOS` and `AppStream` repositories
- **No Changes**: Standard repository structure unchanged between versions

### File System Support

#### Default File System
- **All Versions**: XFS remains the default file system

#### New Support in RHEL 9
```diff
+ RHEL 9 adds ext4 file system support
+ RHEL 9 adds Btrfs file system support (limited functionality)
```

### Programming Language Support

#### Python Versions
```diff
- RHEL 8: Python 3.6
+ RHEL 9: Python 3.9
```

#### Perl and Other Languages
```diff
- RHEL 8: Perl 5.26, Node.js 10, PHP 7.2
- RHEL 9: Perl 5.32, Node.js 16, PHP 8.0
```

## Security and Policy Changes

### SELinux Policy Enforcement

#### Critical Change in RHEL 9
> [!IMPORTANT]
> The SELinux configuration file has been simplified. The `disable` option has been removed from `/etc/selinux/config`.

```bash
# RHEL 8: Three options available
SELINUX=enforcing   # Enforce SELinux rules
SELINUX=permissive  # Log violations but don't enforce
SELINUX=disabled    # Completely disable SELinux

# RHEL 9: Only two options available
SELINUX=enforcing   # Enforce SELinux rules
SELINUX=permissive  # Log violations but don't enforce
```

#### Reason for Change
Enforcing SELinux security is considered best practice. Complete disabling is not recommended as it creates security gaps.

## Networking Changes

### Network Configuration Tools

#### Network Scripts Removal
```diff
- RHEL 8: Supported both NetworkManager and legacy network scripts
- RHEL 9: Legacy network scripts completely removed
```

#### Configuration Location Changes
```diff
- RHEL 8: Network scripts in /etc/sysconfig/network-scripts/
- RHEL 9: No network scripts directory - NetworkManager only
```

> [!NOTE]
> NetworkManager is used exclusively for all network configurations in RHEL 9. This ensures consistent network management across different deployment methods.

## Virtualization and Storage Changes

### Virtual Data Optimizer (VDO)

#### Removal in RHEL 9
```diff
- RHEL 8: VDO supported for thin provisioning
- RHEL 9: VDO support completely removed
```

> [!WARNING]
> Developers shifted focus to device mapper level thin provisioning instead of VDO. If upgrading systems with VDO, plan for migration to alternative solutions.

### LVM Thin Pooling
- **RHEL 8**: Native LVM support
- **RHEL 9**: Moved to device mapper level (still functional but different implementation)

## Container Runtime Updates

### Podman vs Docker

#### RHEL 8 Container Support
- Required extensive configuration to use Podman
- Docker could be installed but was not recommended

#### RHEL 9 Container Support
```diff
+ RHEL 9: Podman available with minimal configuration
+ RHEL 9: Podman's "podman-docker" package provides Docker compatibility
```

#### Cockpit Integration
> [!IMPORTANT]
> Cockpit (web-based management interface) is included by default in RHEL 9 installations.

## RHEL 9 Installation Demonstration

### Virtual Machine Setup

#### VirtualBox Configuration
```bash
# Recommended VM Specifications for RHCSA Practice:
- RAM: Minimum 1GB, Recommended 4GB
- CPUs: 2 vCPUs
- Storage: Minimum 20GB, Recommended 50GB
- Network: Bridged Adapter for external connectivity
```

### Installation Process Steps

1. **ISO Download**
   ```bash
   # Access Red Hat Developer Portal
   # URL: https://developers.redhat.com/products/rhel/download
   # Login required with Red Hat Developer Account
   ```

2. **Virtual Machine Creation**
   ```
   - Select "New Virtual Machine"
   - Choose "Red Hat (64-bit)" or manually select ISO
   - Configure hardware specifications as above
   ```

3. **Installation Options**
   ```
   - Language: English (India)
   - Keyboard: English (India)
   - Time Zone: Asia/Kolkata
   - Software Selection: Server with GUI (recommended for beginners)
   ```

4. **Partitioning**
   ```
   - Automatic partitioning recommended
   - Creates standard partitions (/boot, /, swap)
   ```

5. **Network Configuration**
   ```
   - DHCP automatic configuration
   - Hostname: Custom (e.g., rhel9-server)
   ```

### Root User Access Configuration

#### Security Enhancement in RHEL 9
```diff
- RHEL 8: Direct root login possible by default
- RHEL 9: Direct root login disabled by default
```

#### RHEL 9 Root Access Methods
```bash
# Method 1: From normal user account
sudo -i

# Method 2: Enable root login if needed
# Edit /etc/ssh/sshd_config
PermitRootLogin yes
systemctl restart sshd
```

## Post-Installation Verification

### System Information Verification

#### Kernel Version Check
```bash
uname -r
# Expected output: 5.14.x-x.el9.x86_64
```

#### Package Verification
```bash
cat /etc/redhat-release
# Output: Red Hat Enterprise Linux release 9.x (Plow)
```

#### Network Configuration Check
```bash
ip addr show
nmcli device show
```

### Graphical Interface Overview

#### GNOME Desktop Features
- **Activities Overview**: Task switching and application launcher
- **Application Menu**: Installed software access
- **System Settings**: Network, display, power management
- **Terminal Access**: Built-in terminal emulator

## Discussion and Q&A Session

### Common Student Questions

#### SELinux Policy Options
```diff
! Question: How to handle SELinux policies?
- Answer: Can only enforce or make permissive; cannot disable
- Reason: Security best practices favor active protection
```

#### Network Scripts Migration
```diff
! Question: How to migrate from network scripts?
- Answer: Convert configurations to NetworkManager profiles
- Example: Use nmcli to recreate network configurations
```

#### Container Runtime
```diff
! Question: Docker vs Podman in RHEL 9?
- Answer: Podman is preferred; Docker compatibility available via podman-docker
- Command: dnf install podman-docker
```

#### Rescue Mode Access
```diff
! Question: How to enter rescue mode?
- Answer: Select rescue kernel during boot (F2 key)
- Kernel parameters: Change boot settings in rescue environment
```

## Summary

### Key Takeaways
```diff
+ RHEL 9 marks a modernization of the platform with significant security enhancements
+ Major focus on simplified administration through NetworkManager and SELinux policy changes
+ Removal of legacy components (network scripts, VDO) in favor of modern alternatives
+ Enhanced container support with Podman as the default runtime
+ Improved user experience with better GUI and installation process
+ Kernel upgrade to 5.14 enables new hardware support and performance improvements
```

### Quick Reference

#### Version Comparison Commands
```bash
# Check RHEL version
cat /etc/redhat-release

# Check kernel version
uname -r

# Check architecture
uname -m

# List available repositories
dnf repolist
```

#### Network Management (RHEL 9)
```bash
# View network interfaces
nmcli device show

# View connections
nmcli connection show

# Create new connection
nmcli connection add type ethernet ifname eth0 con-name "Wired Connection"
```

#### SELinux Status
```bash
# Check SELinux status
sestatus

# View configuration
cat /etc/selinux/config

# Change mode (only Enforcing or Permissive)
setenforce 0  # Permissive (temporary)
setenforce 1  # Enforcing (temporary)
```

### Expert Insight

#### Real-world Application
- **Enterprise Deployments**: RHEL 9's simplified management reduces administrative overhead in large-scale deployments
- **Modernization**: Removal of legacy components encourages adoption of current best practices
- **Security by Design**: Default security settings promote safer out-of-the-box configurations

#### Expert Path
- **Container Orchestration**: Podman skills become essential for modern application deployment
- **NetworkManager Mastery**: Deep understanding of nmcli becomes critical for network administration
- **Security Hardening**: Focus on advanced SELinux policy tuning and AppArmor integration

#### Common Pitfalls
> [!WARNING]
> **Migration Challenges**: Systems using VDO for storage optimization require careful migration planning
>
> [!WARNING]
> **Root Access Assumptions**: Expecting direct root login will fail in default RHEL 9 installations
>
> [!WARNING]
> **Legacy Script Failures**: Network scripts will not exist, causing service failures during upgrades

</details>
