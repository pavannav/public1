# Section 9: Introduction to the Wicked and Network Services

<details open>
<summary><b>Section 9: Introduction to the Wicked and Network Services (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [9.1 Introduction to the Wicked and Network Services](#91-introduction-to-the-wicked-and-network-services)
- [9.2 Working with the Wicked Service in openSUSE](#92-working-with-the-wicked-service-in-opensuse)
- [9.3 Amazon Linux](#93-amazon-linux)
- [Summary](#summary)

---

## 9.1 Introduction to the Wicked and Network Services

### Overview

This module introduces two additional Linux distribution families beyond Debian and Fedora derivatives: SUSE/openSUSE with its **wicked** networking service and Amazon Linux with its modified **systemd-networkd** service. The instructor emphasizes that SUSE systems are prevalent in enterprise environments and offers paid support options.

### Key Concepts

#### SUSE and openSUSE Distributions

**SUSE** is a commercial Linux distribution that provides paid support, while **openSUSE** is its open-source counterpart for users who want to take full responsibility without commercial support.

**Networking Service**: By default, SUSE/openSUSE uses the **wicked** networking service.

**Verification Command**:
```bash
systemctl status wicked
```

#### Configuration Methods in SUSE

The primary configuration methods, listed in order of preference:

1. **YaST Control Center** (recommended) - A tab-based graphical/text interface
2. **netconfig command** - Command-line configuration tool
3. **Configuration files** (last resort only)

**Configuration File Location**:
```
/etc/sysconfig/network
```

> [!WARNING]
> The instructor strongly advises against directly modifying configuration files. Use YaST instead.

#### Amazon Linux Distribution

**Current Networking Service**: Amazon Linux uses a modified version of **systemd-networkd**.

**Verification Command**:
```bash
systemctl status systemd-networkd
```

**Configuration File Location** (as of recording):
```
/etc/sysconfig/network-scripts
```

> [!NOTE]
> This location differs from modern NetworkManager's INI-style files (`/etc/NetworkManager/system-connections`) and represents an older configuration approach.

#### Linux Distribution Network Service Summary

| Distribution Family | Default Network Service | Configuration Method |
|---------------------|------------------------|---------------------|
| Debian/Ubuntu | networking | `/etc/network/interfaces` |
| Fedora/RHEL/CentOS | NetworkManager | YaST/nmtui/nmcli |
| SUSE/openSUSE | wicked | YaST (preferred) |
| Amazon Linux | systemd-networkd | `/etc/sysconfig/network-scripts` |

### Important Notes

- Linux distros continuously evolve; configuration locations and methods may change
- Debian has remained most consistent over time
- SUSE systems can be found in many enterprise environments
- Amazon Linux instances are typically configured via cloud scripts or AWS console

---

## 9.2 Working with the Wicked Service in openSUSE

### Overview

This hands-on module demonstrates practical configuration of an openSUSE system using the YaST control center. The instructor logs in as root, verifies the wicked service status, and navigates through YaST's network configuration interface.

### Key Concepts

#### Initial System Verification

**Login and Status Check**:
```bash
# Check wicked service status
systemctl status wicked

# Verify IP configuration
ip a

# Check routing
ip r
```

The wicked service shows as "active (exited)" yet "enabled" - a normal state indicating the service has completed its initialization successfully.

#### YaST Control Center

**Accessing YaST**:
```bash
yast
# or
yast2
```

YaST provides a tab-delimited, keyboard-navigable interface for system configuration.

#### Network Configuration Workflow

1. **Navigate to Network Settings**:
   - Select "System" → "Network Settings"

2. **Available Configuration Tabs**:
   - **Overview**: Device list with IP addresses
   - **Hostname/DNS**: DNS server configuration
   - **Routing**: Default gateway settings
   - **Global Options**: DHCP settings, IPv6 configuration, service selection

3. **Interface Configuration**:
   - Press **F4** to edit IP connection settings
   - Modify IP address, CIDR notation, and hostname
   - Press **F9** to cancel without saving

#### Alternative Service Selection

Within Global Options, administrators can switch from wicked to other services:

```bash
# Install NetworkManager if needed
zypper install NetworkManager
```

Then select NetworkManager from the YaST service options instead of wicked.

#### Additional YaST Categories

- **Network Services**: Hostnames, proxy configuration
- **Security and Users**: AppArmor, firewall settings
- **System**: Hardware configuration, kernel settings

#### Configuration File Inspection

**Path**: `/etc/sysconfig/network`

**Example ifcfg file structure** (`ifcfg-eth0`):
```ini
BOOTPROTO='static'
IPADDR='10.0.2.61'
NETMASK='255.255.255.0'
GATEWAY='10.0.2.1'
STARTMODE='auto'
```

### Lab Demonstration

1. Log in to openSUSE as root
2. Verify wicked service: `systemctl status wicked`
3. Check IP: `ip a`
4. Launch YaST: `yast`
5. Navigate: System → Network Settings
6. Explore tabs: Overview, Hostname/DNS, Routing, Global Options
7. View configuration: `vim /etc/sysconfig/network/ifcfg-eth0`
8. Exit with F9

### Key Takeaways

- wicked service is "wicked fast" and reliable
- YaST is the preferred configuration method over direct file editing
- Configuration changes require F10 to save, F9 to cancel
- Multiple network services can be installed and selected via YaST

---

## 9.3 Amazon Linux

### Overview

This module covers Amazon Linux configuration on AWS, emphasizing that cloud instances typically receive their network configuration automatically. The instructor demonstrates the current state of Amazon Linux's networking service and notes important differences from local virtual machines.

### Key Concepts

#### Amazon Linux Networking Evolution

**Current Service**: systemd-networkd (modified for AWS)

**Previous Service**: The "network" service (older versions)

**Status Verification**:
```bash
systemctl status systemd-networkd
```

The service shows as active, running, and enabled.

#### Configuration File Location

**Current Path** (as of recording):
```
/etc/sysconfig/network-scripts
```

This uses the older **ifcfg** file format rather than modern INI/Key files.

**Example ifcfg-eth0**:
```ini
DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
```

#### Service Verification Commands

```bash
# Check current service
systemctl status systemd-networkd

# Verify other services are not installed/active
systemctl status network        # Not found
systemctl status NetworkManager # Not found
systemctl status networking     # Not found (Debian service)
```

#### IP Configuration on AWS

**Default IP Assignment**:
- Public IP (for initial connection)
- Private IP on /20 network (automatically assigned)
- Gateway configuration for VPC routing

**Verification Commands**:
```bash
ip a    # Shows enx0 interface with private IP
ip r    # Shows default gateway
```

#### Terminal Multiplexing Options

For enhanced terminal productivity on Amazon Linux:

**Available Options**:
1. **GNU Screen** (built-in)
2. **tmux** (installation required)

**tmux Installation**:
```bash
sudo yum install tmux
```

> [!TIP]
> The instructor prefers tmux over Screen for efficiency, though both provide terminal multiplexing capabilities.

#### Cloud vs Local Configuration Differences

| Aspect | Local VM | AWS Instance |
|--------|----------|--------------|
| Network Configuration | Manual via YaST/nmtui | Automatic via cloud scripts |
| Static IP Assignment | Common | Rare (use Elastic IPs if needed) |
| Multiple Interfaces | Manual setup | VPC configuration |
| DNS Configuration | Local settings | VPC DHCP options |

### Best Practices for Amazon Linux

1. **Don't modify network settings** through traditional Linux methods
2. **Use AWS Console** or CloudFormation/Terraform for network configuration
3. **Utilize terminal multiplexers** for improved productivity
4. **Remember**: Cloud instances receive IPs automatically

### Important Considerations

- Amazon Linux is "always in flux" with frequent updates
- Configuration methods may change with new releases
- Always check current documentation for the specific Amazon Linux version
- Cloud-init scripts typically handle initial network configuration

---

## Summary

### Key Takeaways

```diff
+ SUSE/openSUSE uses 'wicked' service, configured primarily via YaST
+ Amazon Linux uses modified systemd-networkd with ifcfg files in /etc/sysconfig/network-scripts
+ Cloud instances should not have network settings manually changed
+ Multiple YaST tabs provide comprehensive network configuration options
+ Terminal multiplexing (tmux/screen) enhances cloud instance productivity
- Never directly edit configuration files in SUSE; use YaST instead
- Configuration locations differ significantly between distributions
```

### Quick Reference

| Task | SUSE/openSUSE | Amazon Linux |
|------|---------------|--------------|
| Check service | `systemctl status wicked` | `systemctl status systemd-networkd` |
| Configure network | `yast` → Network Settings | AWS Console/CloudFormation |
| Config location | `/etc/sysconfig/network` | `/etc/sysconfig/network-scripts` |
| Edit interface | F4 in YaST | Not recommended |

### Expert Insight

**Real-world Application**: SUSE systems are prevalent in enterprise environments, particularly in European markets and regulated industries. Understanding YaST configuration is essential for managing these systems in production.

**Expert Path**:
- Master YaST's keyboard shortcuts for efficient navigation
- Understand wicked's configuration file structure for troubleshooting
- Learn cloud-init for automated Amazon Linux configuration
- Practice with both wicked and NetworkManager on SUSE systems

**Common Pitfalls**:
- Attempting to manually edit wicked configuration files
- Changing network settings on cloud instances
- Assuming all distributions use NetworkManager
- Not verifying which networking service is active before configuration

**Lesser-Known Facts**:
- wicked service name comes from "WIreless Event-to-Command Daemon"
- YaST is an acronym for "Yet another Setup Tool"
- Amazon Linux's network-scripts location reflects its Red Hat heritage
- openSUSE can run NetworkManager if wicked is replaced

</details>