# Section 7: Introduction to systemd and the networkd Service

## Table of Contents

- [7.1 Introduction to systemd and the networkd Service](#71-introduction-to-systemd-and-the-networkd-service)
- [7.2 Analyzing systemd-networkd in Ubuntu](#72-analyzing-systemd-networkd-in-ubuntu)
- [7.3 Analyzing systemd-networkd in Debian](#73-analyzing-systemd-networkd-in-debian)
- [7.4 Using Netplan to Configure a Static IP Configuration](#74-using-netplan-to-configure-a-static-ip-configuration)
- [7.5 Examining Dynamic and Wireless IP Configurations](#75-examining-dynamic-and-wireless-ip-configurations)
- [7.6 Additional networkd-based Commands](#76-additional-networkd-based-commands)
- [7.7 DNS in a Debian System Running networkd](#77-dns-in-a-debian-system-running-networkd)
- [7.8 Arch in AWS](#78-arch-in-aws)
- [Summary](#summary)

---

<details open>
<summary><b>Section 7: Introduction to systemd and the networkd Service (KK-CS45-script-v2-Inst-v1)</b></summary>

## 7.1 Introduction to systemd and the networkd Service

### Overview
This module introduces systemd as a comprehensive system and service manager that replaced older init systems across Linux distributions. It specifically covers systemd-networkd, a network configuration daemon within systemd that's used primarily by Ubuntu Server, Arch Linux, and in special configurations like Debian servers on AWS.

### Key Concepts

#### What is systemd?
- **Definition**: A suite of system management daemons, libraries, and utilities designed as a central management and configuration platform for Linux systems
- **History**:
  - Debuted around 2011 on Fedora
  - Widely accepted by 2015-2016 after debates and issue resolution
  - Replaced older systems: System V (SysV) and BSD init-based systems
- **Current Status**: Most popular Linux distributions use systemd as their init system

#### systemd-networkd
- **Purpose**: A daemon that manages network configurations within the systemd ecosystem
- **Primary Users**:
  - Ubuntu Server (default networking solution)
  - Arch Linux (in many configurations)
  - Special situations (e.g., Debian on AWS)
- **Alternative**: Many distributions replaced networkd with NetworkManager for desktop use

#### Checking networkd Status
```bash
# Check if networkd is active and enabled
systemctl status systemd-networkd
```

#### Configuration Locations
Different distributions store networkd configurations in different locations:

| Distribution | Configuration Path | Configuration Tool |
|--------------|-------------------|-------------------|
| Ubuntu Server | `/etc/netplan/` | Netplan (YAML files) |
| Debian/Arch (non-Netplan) | `/etc/systemd/network/` | Direct `.network` files |
| Other networkd systems | `/etc/systemd/network/` | Direct `.network` files |

### Configuration File Structure
- **Ubuntu Server**: Uses Netplan with YAML configuration files in `/etc/netplan/`
- **Other networkd systems**: Direct configuration files with `.network` extension in `/etc/systemd/network/`
- **File naming convention**: Often prefixed with numbers (e.g., `10-43.static.network`) for ordering

---

## 7.2 Analyzing systemd-networkd in Ubuntu

### Overview
This lab demonstrates how to analyze and manage the systemd-networkd service on an Ubuntu Server system, including checking service status, understanding interface naming, and managing the service lifecycle.

### Key Concepts

#### Service Management
```bash
# Check service status
systemctl status systemd-networkd

# Stop the service (may not fully stop due to Ubuntu resilience)
systemctl stop systemd-networkd

# To fully disable (required for switching to NetworkManager)
systemctl stop systemd-networkd
systemctl disable systemd-networkd
```

#### Ubuntu Server Specifics
- **Version**: Ubuntu 22.04 (LTS) commonly used in cloud environments
- **Interface naming**: Uses predictable naming (e.g., `ens3` for Ethernet)
- **Resilience**: Ubuntu is designed to maintain network connectivity even when services appear stopped

#### Network Interface Information
```bash
# View network interfaces and IP addresses
ip a

# Example output shows:
# - ens3: Interface name
# - 10.0.2.53: Static IP address assignment
# - Static configuration vs DHCP
```

#### Switching to NetworkManager (if needed)
Some scenarios require compatibility with NetworkManager:
1. Install NetworkManager service
2. Enable and start NetworkManager
3. Stop and disable networkd service
4. Update Netplan configuration to specify NetworkManager as renderer

```yaml
# In Netplan configuration
network:
  version: 2
  renderer: NetworkManager
```

### Important Notes
- Ubuntu Server's resilience means stopping networkd alone may not disconnect the network
- The service appears resilient because critical network functions continue operating
- Full service disablement requires both stop and disable commands

---

## 7.3 Analyzing systemd-networkd in Debian

### Overview
This instructor-led demonstration shows how to configure network interfaces using systemd-networkd directly on Debian systems (non-Ubuntu), where Netplan is not used. It covers the `/etc/systemd/network/` directory structure and `.network` configuration files.

### Key Concepts

#### Configuration Location
```bash
# Navigate to networkd configuration directory
cd /etc/systemd/network/

# View network configuration files
ls -la
# Example files:
# - 10-43.static.network
# - 10-41.static.network
# - 192.168.122.network
# - 192-static.network
```

#### Network Configuration File Structure
```ini
# Example: 10-42.static.network
[Match]
Name=ens6f0

[Network]
Address=192.168.1.100/24
Gateway=192.168.1.1
Metric=100
```

#### Key Configuration Elements
- **File naming**: `[number]-[description].network` for ordering
- **Interface identification**: Uses `Name=` to match specific interfaces
- **IP Configuration**:
  - `Address=`: IP address with CIDR notation
  - `Gateway=`: Default gateway address
  - `Metric=`: Route priority (lower = higher precedence)

#### Multiple Interface Configuration
Different interfaces can have different priorities:
```ini
# High priority interface (lower metric)
Metric=100

# Lower priority interface (higher metric)
Metric=200
```

### Important Concepts
- **Metric values**: Lower numbers indicate higher priority for network traffic
- **File extension**: Must end in `.network` for systemd-networkd to process
- **Direct configuration**: Unlike Netplan, these files directly configure networkd without an intermediate tool

---

## 7.4 Using Netplan to Configure a Static IP Configuration

### Overview
This comprehensive lab covers using Netplan on Ubuntu Server to view, modify, and apply static IP configurations. It explains YAML syntax, backup procedures, configuration options, and the difference between `netplan try` and `netplan apply` commands.

### Key Concepts

#### Netplan Fundamentals
- **Purpose**: Frontend configuration tool for managing network settings on Ubuntu
- **File location**: `/etc/netplan/`
- **File format**: YAML (YAML Ain't Markup Language)
- **Purpose of YAML**: Configuration files and data exchange (not markup)

#### Basic Netplan Configuration Structure
```yaml
network:
  version: 2
  ethernets:
    ens3:
      addresses:
        - 10.0.2.53/24
      routes:
        - to: default
          via: 10.0.2.1
      nameservers:
        addresses:
          - 10.0.2.1
```

#### YAML Configuration Elements

| Element | Purpose | Example |
|---------|---------|---------|
| `network` | Root element | Starts all configurations |
| `version` | Netplan version | `version: 2` |
| `ethernets` | Wired interfaces | Contains interface definitions |
| `addresses` | IP addresses | `- 10.0.2.53/24` |
| `routes` | Routing configuration | Default gateway settings |
| `nameservers` | DNS configuration | DNS server addresses |

#### Multiple IP Addresses
Two methods to configure multiple IPs:
```yaml
# Method 1: Separate dashes
addresses:
  - 10.0.2.53/24
  - 10.0.2.54/24

# Method 2: Square brackets
addresses: [10.0.2.53/24, 10.0.2.54/24]
```

#### Netplan Commands
```bash
# Test configuration with rollback option
netplan try

# Apply configuration immediately
netplan apply

# The 'try' command provides 2 minutes to verify before automatic rollback
```

#### Renderer Configuration
```yaml
network:
  version: 2
  renderer: networkd  # Default for Ubuntu Server
  # renderer: NetworkManager  # When switching to NM
```

### Lab Demonstration Steps

1. **Backup Configuration**
   ```bash
   cd /etc/netplan
   cp 00-installer-config.yaml 00-installer-config.yaml.bak
   ```

2. **Modify IP Address**
   ```bash
   vim 00-installer-config.yaml
   # Change: 10.0.2.53 → 10.0.2.153
   ```

3. **Apply with Verification**
   ```bash
   netplan try
   # Press Enter within 2 minutes to accept
   ip a  # Verify new IP
   ping 10.0.2.1  # Test connectivity
   ```

4. **Restore Original Configuration**
   ```bash
   netplan apply  # Direct apply without verification
   ```

### Key Takeaways
- Always backup configuration files before making changes
- Use `netplan try` for safer configuration changes with automatic rollback
- Test connectivity immediately after applying changes
- The renderer option is needed when switching between network management services

---

## 7.5 Examining Dynamic and Wireless IP Configurations

### Overview
This lab demonstrates how to configure dynamic (DHCP) IP addresses using Netplan and provides an example of wireless network configuration. It emphasizes backup procedures and the differences between server and client networking requirements.

### Key Concepts

#### DHCP Configuration with Netplan
```yaml
network:
  version: 2
  ethernets:
    ens3:
      dhcp4: true
```

#### Important DHCP Notes
- **Server consideration**: Production servers typically use static IPs, not DHCP
- **DHCP in lab environments**: Useful for testing and temporary configurations
- **Configuration simplicity**: Only requires `dhcp4: true`

#### Backup and Recovery Procedures
```bash
# Always create backups before modifications
cp 00-installer-config.yaml 00-installer-config.yaml.bak

# Recovery process if needed
rm 00-installer-config.yaml          # Remove broken config
mv 00-installer-config.yaml.bak 00-installer-config.yaml  # Restore backup
netplan try  # Verify restoration
```

#### Wireless Configuration Example
```yaml
network:
  version: 2
  wifis:
    wlp2s0b1:
      dhcp4: true
      access-points:
        "Your-SSID-Name":
          password: "your-password"
```

#### Wireless Interface Naming
- **Convention**: Wireless interfaces typically start with 'w'
- **Example names**: `wlp2s0b1`, `wlan0`, `wlp3s0`
- **Identification**: `ip a` command shows all interfaces

#### Important Considerations
- **Password security**: Netplan shows passwords in clear text by default
- **Server usage**: Ubuntu Servers rarely have wireless cards
- **Cloud environments**: Virtual servers in the cloud never use wireless
- **On-premises servers**: Most production servers use wired connections

### Lab Steps for DHCP Configuration

1. **Preparation**
   ```bash
   cd /etc/netplan
   cp 00-installer-config.yaml 00-installer-config.yaml.bak
   ```

2. **Configure DHCP**
   ```bash
   vim 00-installer-config.yaml
   # Replace static config with:
   # dhcp4: true
   ```

3. **Apply and Verify**
   ```bash
   netplan try
   ip a  # Shows dynamic IP (e.g., 10.0.2.125)
   ping 10.0.2.1  # Test connectivity
   ```

4. **Restore Static Configuration**
   ```bash
   rm 00-installer-config.yaml
   mv 00-installer-config.yaml.bak 00-installer-config.yaml
   netplan try
   ```

### Expert Insights
- DHCP on servers should only be used in specific scenarios (PXE boot, temporary systems)
- Always verify DHCP configuration works before relying on it for critical systems
- Wireless on servers is an edge case that's rarely encountered in production

---

## 7.6 Additional networkd-based Commands

### Overview
This module covers essential systemd-networkd commands for network diagnostics and DNS configuration management. It introduces `networkctl`, `resolvectl`, and the DNS configuration files used in Ubuntu Server environments.

### Key Concepts

#### networkctl Command
```bash
# Basic network status overview
networkctl

# Output shows:
# - Interface names (lo, ens3)
# - Status (routable, configured, unmanaged)
# - Type (loopback, ether)
```

#### networkctl status Command
```bash
# Detailed network interface information
networkctl status

# Provides comprehensive output including:
# - State: routable
# - Online state: online
# - IP addresses
# - Gateway information
# - DNS server addresses
# - Recent journal log entries
```

#### DNS Configuration Files

##### systemd-resolved
```bash
# View managed resolv.conf (Ubuntu Server)
cat /etc/resolv.conf
# Shows: nameserver 127.0.0.53 (local stub resolver)

# Primary DNS configuration file
/etc/systemd/resolved.conf
```

##### resolved.conf Structure
```ini
[Resolve]
#DNS=10.0.2.1
#FallbackDNS=8.8.8.8
#Domains=dpro42.local
#DNSSEC=no
#DNSOverTLS=no
```

#### resolvectl Command
```bash
# Comprehensive DNS information
resolvectl

# Shows:
# - Current DNS servers
# - DNS security status
# - Search domains
# - Protocol support

# Alternative status command
resolvectl status
```

### DNS Configuration Hierarchy in Ubuntu Server
1. **Netplan** (primary configuration point)
   ```yaml
   nameservers:
     addresses:
       - 10.0.2.1
   ```
2. **systemd-resolved** (intermediary service)
3. **/etc/resolv.conf** (managed automatically, shows stub resolver)

### Important Distinctions
| File | Purpose | Notes |
|------|---------|-------|
| `/etc/resolv.conf` | Current DNS resolution | Managed by systemd-resolved, shows 127.0.0.53 |
| `/etc/systemd/resolved.conf` | systemd-resolved configuration | Can override DNS settings |
| Netplan YAML | Primary network configuration | Where DNS is actually configured |

### Lab Demonstration
```bash
# Check interfaces overview
networkctl

# Get detailed status
networkctl status

# View DNS configuration path
cat /etc/resolv.conf

# Edit resolved configuration (if needed)
sudo vim /etc/systemd/resolved.conf

# Check comprehensive DNS info
resolvectl
```

---

## 7.7 DNS in a Debian System Running networkd

### Overview
This instructor-led demonstration shows how to configure DNS on a Debian system using systemd-networkd directly (without Netplan). It covers the `/etc/systemd/resolved.conf` file and proper sudo usage for configuration changes.

### Key Concepts

#### Direct networkd DNS Configuration
When not using Ubuntu Server with Netplan, DNS is configured directly in:
```bash
/etc/systemd/resolved.conf
```

#### Configuration File Structure
```ini
[Resolve]
DNS=10.0.2.1
FallbackDNS=8.8.8.8
Domains=dpro42.local
# Additional options available:
# DNSSEC=yes|no
# DNSOverTLS=yes|no|opportunistic
# Cache=yes|no
```

#### Administrative Access Requirements
```bash
# View file permissions
ls -la /etc/systemd/resolved.conf
# Shows: rw-r--r-- (readable by all, writable by root only)

# Must use sudo to edit
sudo vim /etc/systemd/resolved.conf
```

#### DNS Configuration Options
| Option | Purpose | Example Values |
|--------|---------|----------------|
| `DNS=` | Primary DNS servers | `10.0.2.1` or `8.8.8.8,8.8.4.4` |
| `FallbackDNS=` | Backup DNS servers | `8.8.8.8` (Google), `1.1.1.1` (Cloudflare) |
| `Domains=` | Search domains | `dpro42.local`, `example.com` |
| `DNSSEC=` | DNS Security Extensions | `yes`, `no`, `allow-downgrade` |

#### Popular DNS Server Options
- **Google DNS**: `8.8.8.8`, `8.8.4.4`
- **Cloudflare DNS**: `1.1.1.1`, `1.0.0.1`
- **Quad9 DNS**: `9.9.9.9`
- **Local gateway**: Often `192.168.1.1` or `10.0.0.1`

### Configuration Workflow
1. **Check current configuration**
   ```bash
   cat /etc/systemd/resolved.conf
   ```

2. **Make changes with sudo**
   ```bash
   sudo vim /etc/systemd/resolved.conf
   # Add:
   # DNS=10.0.2.1
   # FallbackDNS=8.8.8.8
   # Domains=dpro42.local
   ```

3. **Save and test**
   ```bash
   # Changes take effect automatically
   # Test with: ping google.com
   ```

### Important Notes
- Debian with networkd does not use Netplan
- Configuration changes in resolved.conf affect all interfaces
- Unlike Netplan, there's no automatic validation or rollback mechanism
- Always verify DNS resolution after making changes

---

## 7.8 Arch in AWS

### Overview
This demonstration shows how systemd-networkd works on an Arch Linux system hosted on Linode (similar to AWS configurations). It covers the automatic configuration generated by cloud providers and the unique aspects of cloud-based networking.

### Key Concepts

#### Cloud Environment Specifics
- **Provider**: Linode (comparable to AWS, Digital Ocean)
- **Access method**: Direct root SSH access initially
- **Security consideration**: Create non-root admin user after first login

#### Initial Connection and Verification
```bash
# Connect via SSH
ssh -i keyfile root@public-ip

# Verify distribution
cat /etc/*release
# Output: Arch Linux (rolling release)

# Check network configuration
ip a ; ip r
```

#### Interface and IP Information
- **Interface naming**: Uses `eth0` in cloud environments
- **IP assignment**: Public IP directly assigned (no NAT like AWS)
- **Network structure**: /24 network with gateway at .1

#### systemd-networkd Status
```bash
# Verify networkd is running
systemctl status systemd-networkd
# Shows: active, enabled, eth0 link configured
```

#### Cloud-Generated Configuration
```bash
# Navigate to networkd config directory
cd /etc/systemd/network

# View auto-generated configuration
cat *.network
```

#### Example Cloud Configuration
```ini
[Match]
Name=eth0

[Network]
DHCP=no
Address=203.0.113.117/24
Gateway=203.0.113.1
DNS=203.0.113.1
DNS=8.8.8.8
DNS=8.8.4.4
Domains=linode.com
```

#### Cloud Configuration Characteristics
- **Auto-generated**: Created by cloud provider's network helper scripts
- **DHCP disabled**: Static configuration for public IP
- **Multiple DNS**: Several DNS servers configured
- **Domain membership**: Cloud provider domain included

#### Important Warnings
- **Caution with modifications**: Changing cloud-generated configs can render the instance unreachable
- **Root cause**: Misconfiguration can lock you out of the system
- **Recovery difficulty**: May require provider console access or instance recreation

### Security Best Practices for Cloud Systems
1. Connect as root initially
2. Create administrative user with sudo/wheel group membership
3. Configure SSH key-based authentication for the new user
4. Disable root SSH access in SSH configuration
5. Test new user access before disabling root

### Diagnostic Commands
```bash
# Network verification
ip a                    # Show interfaces and IPs
ip r                    # Show routing table
ping -4 example.com     # Force IPv4 (if IPv6 preferred)
cat /etc/resolv.conf    # Check DNS resolution
```

### Configuration File Location
```bash
# Networkd configuration files
/etc/systemd/network/*.network

# Only one file typically in cloud environments
# File shows all networking parameters
```

---

## Summary

### Key Takeaways
```diff
! systemd-networkd: Core networking service within systemd ecosystem
+ Primary users: Ubuntu Server (with Netplan), Arch, special Debian configs
- Alternative: NetworkManager for desktop environments
! Configuration locations vary: /etc/netplan/ (Ubuntu) vs /etc/systemd/network/ (others)
+ Netplan provides safe configuration with try/apply commands and rollback
- DNS configuration: Netplan → systemd-resolved → /etc/resolv.conf hierarchy
! Cloud environments auto-generate configurations - modify with extreme caution
```

### Quick Reference

#### Essential Commands
```bash
# Service management
systemctl status systemd-networkd
systemctl stop/start/enable/disable systemd-networkd

# Network information
ip a                    # Interface and IP information
networkctl             # Overview of network interfaces
networkctl status      # Detailed interface status
resolvectl             # DNS configuration and status

# Netplan operations
netplan try            # Test configuration with rollback
netplan apply          # Apply configuration immediately
```

#### Configuration File Locations
| Purpose | Path | Notes |
|---------|------|-------|
| Ubuntu Netplan configs | `/etc/netplan/` | YAML files, use Netplan commands |
| Direct networkd configs | `/etc/systemd/network/` | `.network` files for non-Netplan systems |
| DNS configuration | `/etc/systemd/resolved.conf` | When not using Netplan |
| Current DNS resolution | `/etc/resolv.conf` | Managed automatically, usually shows stub resolver |

#### Netplan YAML Structure
```yaml
network:
  version: 2
  ethernets:           # or 'wifis' for wireless
    ens3:
      addresses: [10.0.2.53/24]
      routes:
        - to: default
          via: 10.0.2.1
      nameservers:
        addresses: [10.0.2.1]
      dhcp4: true      # For dynamic configuration
```

### Expert Insight

#### Real-world Application
- **Server environments**: Use static IPs with Netplan on Ubuntu Server for predictable addressing
- **Development/testing**: DHCP configuration allows quick deployment without manual IP management
- **Multi-homed systems**: Configure multiple interfaces with different metrics for traffic routing
- **Cloud migrations**: Understand both direct networkd and Netplan configurations for hybrid environments

#### Expert Path
1. Master Netplan YAML syntax including advanced features (bridges, bonds, VLANs)
2. Understand systemd-networkd unit files and direct configuration options
3. Learn network troubleshooting with networkctl and journalctl
4. Practice DNS configuration across different scenarios (local, VPN, split-horizon)
5. Explore advanced Netplan features like renderer switching and profile management

#### Common Pitfalls
- **Not backing up configurations** before modifications
- **Using `netplan apply`** instead of `netplan try` for risky changes
- **Forgetting to test connectivity** after IP changes
- **Modifying cloud-generated configurations** without understanding the consequences
- **Incorrect YAML indentation** causing configuration failures
- **Not understanding the DNS hierarchy** leading to resolution problems

#### Lesser-Known Facts
- Ubuntu Server's resilience can mask service stoppage - the network may continue working even when networkd appears stopped
- The 2-minute timeout in `netplan try` provides a safety net but requires quick decision-making
- Cloud providers often include their own DNS servers as primary with public DNS as fallback
- Multiple IP addresses on a single interface can be configured using either list format or bracket notation in YAML
- The `renderer` option in Netplan is only necessary when switching between network management services

</details>