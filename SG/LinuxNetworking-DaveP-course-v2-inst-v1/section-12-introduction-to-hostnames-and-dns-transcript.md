# Section 12: Introduction to Hostnames and DNS

<details open>
<summary><b>Section 12: Introduction to Hostnames and DNS (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [12.1 Introduction to Hostnames and DNS](#121-introduction-to-hostnames-and-dns)
- [12.2 Configuring a Hostname in the GUI](#122-configuring-a-hostname-in-the-gui)
- [12.3 Configuring a Hostname in the Terminal](#123-configuring-a-hostname-in-the-terminal)
- [12.4 FQDNs](#124-fqdns)
- [12.5 Review of DNS](#125-review-of-dns)
- [12.6 Configuring DNS in the GUI](#126-configuring-dns-in-the-gui)
- [12.7 Configuring DNS in the Big Three Networking Services](#127-configuring-dns-in-the-big-three-networking-services)
- [12.8 Working with the hosts File](#128-working-with-the-hosts-file)
- [Summary](#summary)

---

## 12.1 Introduction to Hostnames and DNS

### Overview

This module introduces the fundamental concepts of hostnames and DNS in Linux networking. Hostnames are human-readable names assigned to computers, while DNS provides the translation mechanism to convert these names to IP addresses that computers use for network communication.

### Key Concepts

**Hostnames:**
- Written names assigned to computers for human identification
- Essential because end users remember names more readily than IP addresses
- Multiple configuration methods available: GUI settings, hostnamectl command, or direct file editing

**DNS (Domain Name System):**
- Translates hostnames to IP addresses
- Required because computers communicate using IP addresses, not hostnames
- Two primary configuration locations in Linux:
  - `/etc/resolv.conf` (primary DNS configuration file)
  - `/etc/systemd/resolved.conf` (systemd-resolved configuration)

> [!NOTE]
> The hostname identifies a computer as a particular name, while DNS handles the conversion between hostnames and IP addresses since computers cannot communicate directly using hostnames.

---

## 12.2 Configuring a Hostname in the GUI

### Overview

This module demonstrates how to configure a Linux system's hostname through the graphical interface using system settings, providing an intuitive method for users who prefer GUI-based configuration.

### Key Concepts

**Accessing Hostname Settings:**
- Open system settings using the sprocket icon
- Navigate to "About" section (location varies by distro)
- Click on "Device Name" to modify the hostname

**GUI Configuration Process:**
1. Access Settings from the desktop environment
2. Scroll to the "About" section
3. Click the device name field to edit
4. Enter the new hostname
5. Changes are applied immediately in the GUI

**Important Considerations:**
- Changes may not appear immediately in the current terminal session
- May need to close and reopen terminal to see hostname in prompt
- Generally, GUI changes are instantaneous

> [!TIP]
> Some Linux prompts don't display the hostname by default - check your prompt configuration if the hostname doesn't appear.

---

## 12.3 Configuring a Hostname in the Terminal

### Overview

This module covers terminal-based hostname configuration using modern Linux tools, demonstrating both information display and modification capabilities through command-line interfaces.

### Key Concepts

**Hostname Commands:**
- `hostname` - Legacy command (somewhat deprecated)
- `hostnamectl` - Modern replacement with enhanced functionality

**Using hostnamectl:**
- Displays comprehensive system information including:
  - Static hostname
  - System chassis type (physical/virtual)
  - Virtualization platform (e.g., KVM)
  - Operating system details
  - Kernel version

**Setting Hostname:**
```bash
# View current hostname information
hostnamectl

# Set new hostname
hostnamectl set-hostname debclient

# Add additional system information
hostnamectl set-location "lab 1"
```

**Key Features:**
- No sudo required for basic hostname changes
- Changes don't immediately reflect in current terminal prompt
- Requires terminal restart to see updated prompt
- Supports various metadata options (location, pretty names, etc.)

> [!IMPORTANT]
> Always reopen the terminal after changing the hostname to see the updated prompt display.

---

## 12.4 FQDNs

### Overview

This module explains Fully Qualified Domain Names (FQDNs) and demonstrates how to configure a complete DNS name by combining hostnames with domain names using various methods.

### Key Concepts

**FQDN Structure:**
- Combines hostname with domain name
- Format: `hostname.domain.tld` (e.g., `debclient.example.local`)
- Provides complete, unambiguous system identification

**Configuration Methods:**

1. **Direct File Editing:**
   ```bash
   sudo vim /etc/hostname
   # Add domain to existing hostname
   # Example: debclient.example.local
   ```

2. **Using hostnamectl:**
   ```bash
   hostnamectl set-hostname debclient.example.local
   ```

**Important Distinctions:**
- **Static Hostname**: The complete FQDN configured
- **Transient Hostname**: The hostname portion only as recognized by Linux kernel
- File `/etc/hostname` requires administrative privileges to modify

**Access Requirements:**
- GUI and hostnamectl changes don't require sudo
- Direct file editing in `/etc/` always requires sudo privileges
- System displays warning for read-only files when lacking privileges

> [!NOTE]
> The `.local` top-level domain works well for internal lab environments and won't conflict with internet domains.

---

## 12.5 Review of DNS

### Overview

This module provides a comprehensive review of DNS functionality, emphasizing its role as a worldwide distributed database that translates human-readable names to IP addresses for network communication.

### Key Concepts

**DNS Fundamentals:**
- **DNS** = Domain Name System
- Worldwide system of domains, hosts, and DNS servers
- Primary function: resolve names to IP addresses

**Resolution Process:**
1. Client queries DNS server
2. DNS server searches locally or forwards to other DNS servers
3. IP address is returned to client
4. Client uses IP address for actual communication

**Example Resolution:**
```
example.com → 93.184.216.34
```

**DNS Server Locations:**
- Local DNS servers on LAN
- Internet-based DNS servers
- Caching and forwarding mechanisms optimize performance

> [!IMPORTANT]
> DNS servers resolve hostnames, domain names, and FQDNs to their corresponding IP addresses - this is the fundamental purpose of DNS.

---

## 12.6 Configuring DNS in the GUI

### Overview

This module demonstrates GUI-based DNS configuration options available in Linux desktop environments, focusing on NetworkManager integration and the Network Connections Editor.

### Key Concepts

**GUI Configuration Tools:**
1. **System Settings → Network:**
   - Access Wired settings
   - Configure IPv4 settings
   - Modify DNS server entries

2. **NM Connection Editor:**
   - Alternative GUI tool for network configuration
   - Provides detailed connection properties
   - Access via terminal: `nm-connection-editor`

**Configuration Options:**
- **Automatic (DHCP)**: Obtains DNS from DHCP server
- **Manual**: Specify custom DNS servers (e.g., `8.8.8.8`)

**NetworkManager DNS File:**
- `/etc/resolv.conf` is generated by NetworkManager on client systems
- Not the primary configuration file on NetworkManager systems
- Changes should be made through NetworkManager tools, not direct file editing

> [!TIP]
> When using NetworkManager, avoid directly editing `/etc/resolv.conf` - use NetworkManager tools instead to ensure changes persist.

---

## 12.7 Configuring DNS in the Big Three Networking Services

### Overview

This module provides comprehensive coverage of DNS configuration across the three major Linux networking services: traditional networking, NetworkManager, and networkd with Netplan.

### Key Concepts

**Three Major Networking Services:**

#### 1. Traditional Networking Service (Debian Server)
**Primary File:** `/etc/resolv.conf`
```bash
# View current configuration
cat /etc/resolv.conf

# Edit configuration
sudo vim /etc/resolv.conf
```
- Configure name servers directly
- Set domain search paths
- Example entries:
  ```
  nameserver 10.0.2.1
  search 10-network.2-nat
  ```

#### 2. NetworkManager (Debian Client)
**Configuration Method:** Use nmcli instead of direct file editing
```bash
# Identify connection name
nmcli connection show

# Modify DNS settings
nmcli connection modify ens3 ipv4.dns 8.8.8.8

# Reactivate connection
nmcli connection down ens3 && nmcli connection up ens3
```

#### 3. Networkd with Netplan (Ubuntu Server)
**Primary Methods:**

a) **Netplan Configuration:**
```bash
# Edit Netplan YAML file
cd /etc/netplan
sudo vim 00-installer-config.yaml

# Apply changes
sudo netplan try    # Test configuration
sudo netplan apply  # Apply configuration
```

b) **systemd-resolved Configuration:**
```bash
# Edit resolved.conf
cd /etc/systemd
sudo vim resolved.conf

# Example configuration:
[Resolve]
DNS=10.0.2.1
FallbackDNS=8.8.8.8
```

**Multiple Name Server Support:**
- Primary DNS server
- Secondary/Fallback DNS servers
- Configured in order of preference

> [!WARNING]
> Always test DNS changes after configuration to ensure connectivity is maintained.

---

## 12.8 Working with the hosts File

### Overview

This module explores the `/etc/hosts` file as an alternative name resolution method, demonstrating its use as a backup to DNS and for local network hostname-to-IP mappings.

### Key Concepts

**Purpose of hosts File:**
- Local name resolution backup when DNS fails
- Static hostname-to-IP mappings
- No network dependency required

**File Structure:**
```
IP_Address    Hostname              [Aliases]
127.0.0.1     localhost
127.0.1.1     hostname              (Ubuntu/Debian specific)
10.0.2.51     debserver             debserver.example.local
```

**Common Entries:**
- `127.0.0.1` - Loopback address (localhost)
- `127.0.1.1` - System hostname (Debian/Ubuntu)
- Custom entries for network hosts

**Practical Implementation:**
1. **Add host entries:**
   ```bash
   sudo vim /etc/hosts
   # Add: 10.0.2.51    debserver    debserver.example.local
   ```

2. **Test resolution:**
   ```bash
   ping debserver
   # Resolves through hosts file to IP
   ```

**FQDN Support:**
- Multiple names can point to same IP
- Supports both short names and FQDNs
- Resolution order follows file order

**Resolution Process:**
```
ping debserver
→ resolves to debserver.example.local (FQDN from hosts)
→ resolves to 10.0.2.51 (IP from hosts)
→ executes ping
```

> [!NOTE]
> The hosts file provides triple-action resolution: short name → FQDN → IP address in a single lookup.

---

## Summary

### Key Takeaways
```diff
+ Hostnames provide human-readable computer identification
+ DNS translates hostnames to IP addresses for network communication
+ Multiple configuration methods exist: GUI, hostnamectl, direct file editing
+ Three major networking services require different DNS configuration approaches
+ The hosts file serves as a local DNS backup for name resolution
+ FQDNs combine hostnames with domain names for complete identification
+ Always restart terminal sessions to see hostname changes in prompts
+ Test DNS configurations after making changes
```

### Quick Reference

| Task | Command/Tool | Location |
|------|-------------|----------|
| View hostname | `hostnamectl` | Terminal |
| Set hostname | `hostnamectl set-hostname name` | Terminal |
| Edit hostname file | `sudo vim /etc/hostname` | File |
| Configure DNS (NetworkManager) | `nmcli connection modify` | Terminal |
| Configure DNS (Netplan) | Edit `/etc/netplan/*.yaml` | File |
| Configure DNS (resolved) | Edit `/etc/systemd/resolved.conf` | File |
| Edit hosts file | `sudo vim /etc/hosts` | File |
| View current DNS | `cat /etc/resolv.conf` | File |

### Expert Insight

**Real-world Application:**
In production environments, hostnames and DNS are critical for system identification and service discovery. Use `hostnamectl` for most hostname changes, configure DNS through your networking service's native tools, and maintain critical hosts file entries for essential infrastructure that must remain accessible during DNS outages.

**Expert Path:**
- Master nmcli for NetworkManager systems
- Learn Netplan YAML syntax for Ubuntu Server deployments
- Understand systemd-resolved advanced features
- Study BIND DNS server configuration for authoritative DNS services
- Implement DNS over HTTPS/TLS for enhanced security

**Common Pitfalls:**
- Forgetting to restart terminal after hostname changes
- Directly editing `/etc/resolv.conf` on NetworkManager systems (changes don't persist)
- Not testing DNS changes before deployment
- Overlooking the difference between static and transient hostnames
- Missing sudo when editing `/etc/` files

**Lesser-Known Facts:**
- The `.local` TLD is reserved for mDNS but works well in isolated labs
- Ubuntu/Debian systems use `127.0.1.1` in hosts file for the system hostname
- hostnamectl can store extensive metadata beyond just the hostname
- DNS resolution order: hosts file → DNS → mDNS → other methods
- The hosts file can contain multiple aliases for a single IP address

</details>