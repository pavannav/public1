# Section 70: Network Management

<details open>
<summary><b>Section 70: Network Management (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Hindi Introduction](#hindi-introduction)
- [Session Overview](#session-overview) 
- [Different Network Adapter Types](#different-network-adapter-types)
- [DHCP vs Static IP](#dhcp-vs-static-ip)
- [Network Commands Overview](#network-commands-overview)
- [Using nmcli Command](#using-nmcli-command)
- [Creating Connections](#creating-connections)
- [Network Scripts and Configuration](#network-scripts-and-configuration)
- [Graphical Network Management](#graphical-network-management)
- [DNS and Gateway Configuration](#dns-and-gateway-configuration)
- [Advanced Connection Management](#advanced-connection-management)
- [File-Based Configuration](#file-based-configuration)
- [Q&A Section](#qa-section)
- [Summary](#summary)

## Hindi Introduction
### Overview
This training session session 17 on network management contains Hindi introduction covering basic concepts and session agenda.

### Key Concepts
- **Training Content**: Complete network management in any RHEL machine
- **Topics Covered**: Dynamic IP allocation, static IP setting, subnet/gateway configuration, default gateway setup
- **Important Concepts**: Network adapter differences (bridged vs internal-only vs host-only), IP address creation, subnet management, DNS configuration
- **Methods Taught**: CLI commands, graphical tools, file editing approaches
- **Practical Demonstration**: Extensive terminal demonstrations of all network management methods

## Session Overview
### Overview  
This session provides comprehensive coverage of network management in Linux systems, essential for system administrators and DevOps professionals working with RHEL/CentOS environments.

### Key Concepts
- **Target Audience**: Beginners who want to reach Expert level
- **Practical Focus**: Live terminal demonstrations and real-world scenarios
- **Multiple Methods**: CLI commands, graphical interfaces, and file-based configuration
- **Infrastructure Used**: RHEL 8 Stream virtual machines with bridged network connections
- **Execution Control**: Instructor pauses for explanations and creates additional sessions

### Code/Config Blocks
```bash
# Current IP assignment via DHCP server
ifconfig
nmcli device status
```

> [!NOTE]
> Student feedback requested on preferred session frequency per week (3, 4, 5, 6, or 7 sessions)

## Different Network Adapter Types  
### Overview
Understanding different network adapter configurations is crucial for virtual machine networking and connectivity scenarios.

### Key Concepts
- **Bridged Adapter**: VM connects directly to host's physical network with same IP range
- **Internal-Only/Host-Only**: VM can only communicate with host machine, not external networks
- **NAT (Network Address Translation)**: VM gets private IP, host NATs traffic for internet access

### Tables
| Adapter Type | Host Access | VM-to-VM | External Access | Use Case |
|-------------|-------------|----------|-----------------|----------|
| **Bridged** | ✅ | ✅ | ✅ | Production-like networking |
| **Host-Only** | ✅ | ❌ | ❌ | Host-only development |
| **Internal-Only** | ❌ | ✅ | ❌ | Isolated VM clusters |

```diff
+ Bridged: Full connectivity (Internet + LAN access)
- Host-Only: Limited to host machine only
- Internal-Only: VMs communicate only among themselves
```

## DHCP vs Static IP
### Overview
DHCP provides automatic IP assignment while static IP requires manual configuration. Both have specific use cases depending on network requirements.

### Key Concepts
- **DHCP**: Automatic IP allocation by DHCP server (24-48 hour lease, variable IP)
- **Static IP**: Manual IP assignment, permanent until changed
- **DHCP Server Location**: Managed by virtualization platform (VirtualBox/VMware) for VMs
- **Lease Duration**: Configurable time periods for IP validity

### Code/Config Blocks
```bash
# Check current IP assignment
ifconfig

# DHCP configuration example
BOOTPROTO=dhcp
```

> [!IMPORTANT]
> IPv4 classification basics assumed known - focus on C-Class (192.x.x.x) networks

## Network Commands Overview
### Overview
Multiple commands available for network management - `ifconfig`, `ip`, `nmcli` for different purposes and user preferences.

### Key Concepts
- **ifconfig**: Legacy network command for interface management
- **ip**: Modern replacement with more features (`ip addr` vs traditional `ifconfig`)
- **nmcli**: NetworkManager CLI - modern, comprehensive network management
- **Connection vs Device**: Connection = configuration profile, Device = physical/virtual hardware

### Code/Config Blocks
```bash
# nmcli device status - show devices
nmcli device status

# nmcli connection show - show connections
nmcli connection show

# Show network details with connection status
nmcli device show [device-name]
```

## Using nmcli Command
### Overview
NetworkManager CLI (nmcli) provides comprehensive network management with device and connection handling.

### Key Concepts
- **Device Status**: Shows physical/virtual network interfaces and their state
- **Connection Management**: Separate from devices - connections apply configurations
- **Active Connections**: Connections currently applied to devices

### Code/Config Blocks
```bash
# Show all available devices
nmcli device status

# Show detailed device information
nmcli device show ens160

# List all connections (active + inactive)
nmcli connection show

# Show only active connections
nmcli connection show --active
```

> [!NOTE]
> Connection: Configuration stored in /etc/sysconfig/network-scripts/
> Device: Physical/virtual network interface hardware

## Creating Connections
### Overview
Create new network connections from existing devices with various configuration options including DHCP and static IP assignment.

### Key Concepts
- **Connection Creation**: Link device to configuration profile
- **DHCP Assignment**: Automatic via DHCP server
- **Static IP**: Manual assignment with subnet, gateway, DNS
- **Interface Binding**: Specify which network device to use

### Code/Config Blocks
```bash
# Create connection with DHCP
nmcli connection add type ethernet con-name "bridged-net" ifname ens160

# Create connection with static IP
nmcli connection add type ethernet con-name "static-net" ifname ens160 ipv4.address 192.168.02.100/24 ipv4.gateway 192.168.02.1 ipv4.dns 8.8.8.8

# Bring connection up
nmcli connection up bridged-net

# Check IP assignment
ip addr show ens160
```

## Network Scripts and Configuration
### Overview
NetworkManager stores configurations in /etc/sysconfig/network-scripts/ directory with human-readable files.

### Key Concepts
- **File Location**: /etc/sysconfig/network-scripts/ contains ifcfg-* files
- **File Naming**: ifcfg-connection-name format
- **Parameters Hierarchy**: TYPE, DEVICE, BOOTPROTO, IPADDR, NETMASK, GATEWAY, DNS
- **Auto-activation**: ONBOOT=yes activates on system boot

### Code/Config Blocks
```ini
# Example configuration file: /etc/sysconfig/network-scripts/ifcfg-bridged-net
TYPE=Ethernet
DEVICE=ens160
BOOTPROTO=dhcp
ONBOOT=yes
CONNECTION_NAME=bridged-net
UUID=auto-generated-uuid
```

Key Parameters:
- **BOOTPROTO**: dhcp (dynamic) or none (static)
- **IPADDR**: Static IP address for static configuration  
- **NETMASK/PREFIXLEN**: Network mask specification
- **GATEWAY**: Default gateway IP
- **DNS**: DNS server addresses

## Graphical Network Management
### Overview
RHEL provides graphical network management tools via GNOME settings for those preferring GUI interfaces.

### Key Concepts
- **Virtual Machine Integration**: Full integration with RHEL desktop environment
- **Network Settings**: Available in System Settings > Network
- **Device Management**: Add/modify network adapters through GUI
- **Configuration Editing**: Edit existing connections with point-and-click interface

### Lab Demo Steps
1. Access GUI: Open Settings > Network in RHEL desktop
2. View Devices: Click network icon to see available connections
3. Edit Connection: Click gear icon next to active connection to modify settings
4. Static IP Configuration: Navigate to IPv4 settings, change to Manual, enter IP/gateway/DNS
5. Apply Changes: Click Apply to save configuration

## DNS and Gateway Configuration
### Overview
DNS resolution and routing configuration are critical for network connectivity and external communication.

### Key Concepts
- **DNS Servers**: Multiple DNS servers can be configured for redundancy
- **Gateway Configuration**: Default route for traffic outside local network
- **nmcli Modifications**: Use modify commands for existing connections
- **Space-Separated Values**: Multiple DNS entries separated by spaces

### Code/Config Blocks
```bash
# Add DNS to existing connection
nmcli connection modify [connection-name] ipv4.dns "8.8.8.8 8.8.4.4"

# Set gateway address
nmcli connection modify [connection-name] ipv4.gateway 192.168.02.1

# Add multiple DNS servers with proper quoting
nmcli connection modify static-net ipv4.dns "8.8.8.8 1.1.1.1"
```

## Advanced Connection Management
### Overview
Manage connection lifecycle including activation, deactivation, user permissions, and deletion operations.

### Key Concepts
- **Connection States**: Up/down control for connectivity management
- **User Permissions**: Grant specific users read/write access to connections
- **Interactive Editing**: nmcli edit for complex configuration changes
- **Persistent Settings**: ONBOOT controls auto-activation on boot

### Code/Config Blocks
```bash
# Bring connection down/up
nmcli connection down [connection-name]
nmcli connection up [connection-name]

# Grant permissions to specific users
nmcli connection modify [connection-name] connection.permissions "vikas,admin"

# Modify auto-connect setting
nmcli connection modify [connection-name] connection.autoconnect no

# Delete connection
nmcli connection delete [connection-name]
```

## File-Based Configuration
### Overview
Direct editing of configuration files provides granular control over network settings when GUI/CLI options are insufficient.

### Key Concepts
- **Manual Editing**: Direct modification in network scripts directory
- **Syntax Requirements**: Proper quoting for DNS servers with spaces
- **Unicode Support**: Names can include spaces when properly escaped
- **Automatic Updates**: NetworkManager recognizes file changes

### Code/Config Blocks
```ini
# Direct file modification example
vi /etc/sysconfig/network-scripts/ifcfg-static-net

[Modified file contents:]
TYPE=Ethernet
DEVICE=ens224
BOOTPROTO=none
IPADDR=192.168.150.25
PREFIX=24
GATEWAY=192.168.150.1
DNS1=8.8.8.8
DNS2=8.8.4.4
ONBOOT=yes
```

Commands for applying changes:
```bash
nmcli connection reload
nmcli connection up static-net
```

## Q&A Section
### Overview
Addressing student questions on network management concepts, troubleshooting, and practical applications.

### Key Concepts
- **Active Learning**: Questions drive deeper understanding of concepts
- **Troubleshooting**: Common issues like network connectivity failures
- **Session Frequency**: Community feedback determines 5 sessions per week
- **Practical Scenarios**: Real-world application of network management concepts

### Common Questions Answered
**Q: Difference between NMCLI, GUI, and file editing methods?**
- NMCLI: CLI automation, scripting-friendly
- GUI: Visual configuration, beginner-friendly  
- File Editing: Manual control, advanced customization

**Q: Bridge vs NAT networking scenarios?**
- Bridge: Production-like with LAN access
- NAT: Private networking with internet via host

**Q: Static IP assignment methods?**
- nmcli connection add (with parameters)
- GUI manual settings
- Direct file configuration in ifcfg files

## Summary

### Key Takeaways
```diff
+ Network management methods: CLI (nmcli), GUI, file-based
+ Adapter types: Bridged = full access, Host-only = host-only, Internal = VM-only
+ DHCP vs Static: DHCP for dynamic, static for permanent addressing
+ Connection vs Device: Connection = profile, Device = hardware
+ DNS essential for internet connectivity
+ Understanding network scripts and NetworkManager
+ User permissions and connection lifecycle management
```

### Quick Reference
**Essential Commands:**
```bash
# Check network status
nmcli device status

# Show connections
nmcli connection show --active

# Create DHCP connection
nmcli connection add type ethernet con-name "my-net" ifname [device]

# Create static IP connection  
nmcli connection add type ethernet con-name "static" ifname [device] ipv4.address 192.168.X.X/24 ipv4.gateway 192.168.X.1 ipv4.dns 8.8.8.8

# Bring up/down connections
nmcli connection up [con-name]
nmcli connection down [con-name]

# Check IP configuration
ip addr show [device]
```

**Configuration File Location:**
```
/etc/sysconfig/network-scripts/ifcfg-*
```

### Expert Insight

#### Real-world Application
Network management in production environments requires understanding these fundamental concepts for troubleshooting connectivity issues, setting up secure networking in virtualized environments, and maintaining reliable system connectivity across development, staging, and production networks.

#### Expert Path  
Build expertise by mastering IPv4/IPv6 networking fundamentals, practicing various network configurations in isolated virtual environments, and understanding the interaction between physical/virtual networks and how different virtualization platforms (VirtualBox, VMware, KVM) implement network isolation and connectivity.

#### Common Pitfalls
- **Bridged Configuration**: Using incorrect network ranges can cause conflicts
- **Static vs DHCP Confusion**: Mixing methods results in connectivity issues  
- **DNS Overlap**: Multiple DNS servers can conflict - prioritize primary
- **User Permissions**: Incorrect permissions can prevent updates
- **Case Sensitivity**: nmcli parameters are case-sensitive
- **Space Requirements**: DNS entries require proper quoting with multiple values

</details>
