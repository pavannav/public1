# Section 17: Working with Additional Networking Tools

<details open>
<summary><b>Section 17: Working with Additional Networking Tools (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [17.1 Working with Additional Networking Tools](#171-working-with-additional-networking-tools)
- [17.2 wget](#172-wget)
- [17.3 Create an Apache Web Server](#173-create-an-apache-web-server)
- [17.4 curl](#174-curl)
- [17.5 NetPerf](#175-netperf)
- [17.6 Additional Tools](#176-additional-tools)
- [17.7 Deprecated Tools](#177-deprecated-tools)
- [17.8 speedtest-cli](#178-speedtest-cli)
- [Summary](#summary)

---

## 17.1 Working with Additional Networking Tools

### Overview
This introductory module presents a comprehensive suite of additional networking tools available in Linux, covering data transfer utilities (wget, curl), performance benchmarking (NetPerf), and system monitoring tools. The instructor demonstrates package management across different Linux distributions and introduces Neofetch as both a system information tool and configuration example.

### Key Concepts/Deep Dive

#### Package Management Across Distributions
```bash
# Debian/Ubuntu
sudo apt install [package-name]

# Fedora/RHEL 8+
sudo dnf install [package-name]

# RHEL 7 and older
sudo yum install [package-name]

# Arch Linux
sudo pacman -S [package-name]
```

**Important**: When installing packages, always substitute the appropriate package manager command based on your distribution.

#### Neofetch: System Information with Networking
Neofetch is a command-line system information tool that displays comprehensive details about your Linux system:

- **Basic System Info**: OS version, kernel, hostname
- **Hardware Details**: CPU, GPU, memory
- **Desktop Environment**: Window manager, terminal type
- **Networking Information**: Can be configured to show local and public IP addresses

#### Configuration Customization
```bash
# Access Neofetch configuration
vim ~/.config/neofetch/config.conf

# Enable Local IP display (uncomment the line)
# print_info() {
#   info title
#   info underline
#   info "Local IP" local_ip      # ← Uncomment this line
#   info "Public IP" public_ip    # Optional
#   info users
#   ...
# }
```

**Key Configuration Options**:
- `local_ip`: Displays the system's local network address
- `public_ip`: Shows the external/public IP (use with caution in shared environments)
- `users`: Shows currently logged-in users

#### Installation Example
```bash
# Install Neofetch on Debian
sudo apt install neofetch

# Run the program
neofetch

# Sample Output:
# OS: Debian GNU/Linux 12 (bookworm) x86_64
# Host: KVM/QEMU (Standard PC)
# Kernel: 6.1.0-18-amd64
# Uptime: 2 hours, 15 mins
# Packages: 1247 (dpkg)
# Shell: bash 5.2.15
# Resolution: 1920x1080
# DE: GNOME
# WM: Mutter
# Terminal: gnome-terminal
# CPU: Intel i7-10700K (8) @ 3.800GHz [VM]
# Memory: 4.2GiB / 8.0GiB
# Local IP: 10.0.2.52
# Users: user
```

### Lab Demos
1. **Package Installation**: Install tools using appropriate package managers
2. **Neofetch Configuration**: Customize output to include local networking information
3. **System Analysis**: Use Neofetch to gather comprehensive system details

---

## 17.2 wget

### Overview
The wget command is a powerful, non-interactive network downloader that can retrieve files from both HTTP and FTP servers. It excels at mirroring websites recursively, downloading multiple files programmatically, and operating without user intervention—making it ideal for automation and scripting.

### Key Concepts/Deep Dive

#### Core Functionality
```bash
# Basic wget usage - downloads index.html by default
wget https://prowse.tech

# Download creates local file
ls -la
# -rw-r--r-- 1 user user 24567 index.html
```

**Key Characteristics**:
- **Non-interactive**: Runs without user participation
- **Protocol Support**: Works with HTTP, HTTPS, and FTP
- **Recursive Downloading**: Can mirror entire directory structures
- **Resumption Support**: Can resume interrupted downloads

#### Essential Command Options

| Option | Description | Example |
|--------|-------------|---------|
| `-r, --recursive` | Recursively download directories | `wget -r https://example.com` |
| `-l, --level=NUM` | Maximum recursion depth | `wget -r -l 2 https://example.com` |
| `-nd, --no-directories` | Don't create directory structure | `wget -nd https://example.com/file.zip` |
| `-np, --no-parent` | Don't ascend to parent directories | `wget -r -np https://example.com/dir/` |
| `-A, --accept=LIST` | File type filter | `wget -A zip,pdf https://example.com` |
| `-a, --append-output=FILE` | Log to file instead of stdout | `wget -a log.txt https://example.com` |
| `--help` | Display all options | `wget --help` |

#### Advanced Usage: Selective File Downloads
**Scenario**: Download all Terraform releases for specific platforms

```bash
# Target URL structure
URL="https://releases.hashicorp.com/terraform/1.6.2/"

# Download specific file types recursively without creating directories
wget -nd -np -r --accept=.zip $URL

# Results:
# - Downloads 319MB in 7.5 seconds (42 MB/s)
# - Creates flat directory with platform-specific .zip files
# - Includes: terraform_1.6.2_darwin_amd64.zip, terraform_1.6.2_linux_amd64.zip, etc.
```

#### Logging and Scripting
```bash
# Create dedicated directory for logging
mkdir wget_logs && cd wget_logs

# Download with logging (no terminal output)
wget -a log.txt https://prowse.tech

# Verify log contents
cat log.txt
# --2024-01-15 10:30:45--  https://prowse.tech/
# Resolving prowse.tech (prowse.tech)... 172.67.XXX.XXX, 104.21.XXX.XXX
# Connecting to prowse.tech (prowse.tech)|172.67.XXX.XXX|:443... connected.
# HTTP request sent, awaiting response... 200 OK
# Length: 24567 (24K) [text/html]
# Saving to: 'index.html'
```

### Lab Demos
1. **Basic Download**: Retrieve single webpage with `wget prowse.tech`
2. **Recursive Mirroring**: Download entire website structure with `-r` flag
3. **Selective Downloads**: Filter downloads by file extension using `--accept`
4. **Logging Practice**: Implement file-based logging for automated processes

---

## 17.3 Create an Apache Web Server

### Overview
This hands-on module demonstrates the complete process of installing, configuring, and managing an Apache web server on Debian Linux. It covers service management with systemctl, basic HTML creation, and testing methodologies using both command-line tools and web browsers.

### Key Concepts/Deep Dive

#### Apache Installation and Verification

```bash
# Check if Apache is already installed
systemctl status apache2

# Expected output if not installed:
# Unit apache2.service could not be found.

# Install Apache web server
sudo apt install apache2

# Verify installation and status
systemctl status apache2

# Sample successful output:
# ● apache2.service - The Apache HTTP Server
#    Loaded: loaded (/lib/systemd/system/apache2.service; enabled; vendor preset: enabled)
#    Active: active (running) since Mon 2024-01-15 14:30:25 EST; 27s ago
#      Docs: https://httpd.apache.org/docs/2.4/
```

#### Troubleshooting Broken Installations
```bash
# If installation fails with broken packages
sudo apt --fix-broken install
sudo apt autoremove

# Retry installation
sudo apt install apache2
```

#### Apache Default Directory Structure
```bash
# Navigate to web root
cd /var/www/html

# List contents
ls -la
# drwxr-xr-x 2 root root 4096 Jan 15 14:30 .
# -rw-r--r-- 1 root root 10701 Jan 15 14:30 index.html

# View default Apache page
cat index.html
```

#### Service Management Commands
```bash
# Stop the web server
sudo systemctl stop apache2

# Verify stopped status
systemctl status apache2
# Active: inactive (dead) since Mon 2024-01-15 14:35:10 EST; 5s ago

# Start the web server
sudo systemctl start apache2

# Check final status
systemctl status apache2
# Active: active (running) since Mon 2024-01-15 14:36:00 EST; 2s ago
```

#### Creating Custom Web Content

**Backup and Create New Index**:
```bash
# Backup existing page
sudo cp /var/www/html/index.html /var/www/html/index.html.back

# Create new custom index.html
sudo vim /var/www/html/index.html
```

**Custom HTML Content**:
```html
<!DOCTYPE html>
<html>
<head>
    <title>My Custom Website</title>
</head>
<body>
    <h1>My Very Own Website</h1>
    <p>Welcome to my website, isn't it grand?</p>
</body>
</html>
```

**Save and verify**:
```bash
# Save file (:wq in vim)
sudo vim /var/www/html/index.html

# Verify content
cat /var/www/html/index.html
```

#### Testing Methodology
1. **Local Testing**: Use `127.0.0.1` or `localhost` in browser
2. **Remote Testing**: Access via server's IP address
3. **wget Testing**:
   ```bash
   wget 127.0.0.1
   # Downloads index.html from local Apache server
   ```

### Lab Demos
1. **Complete Installation**: Install Apache with troubleshooting steps
2. **Service Control**: Master start/stop/enable operations with systemctl
3. **Content Creation**: Build and deploy custom HTML content
4. **Multi-terminal Workflow**: Use parallel terminals for real-time testing

---

## 17.4 curl

### Overview
Curl is a versatile data transfer utility that supports virtually all internet protocols (HTTP, HTTPS, FTP, SFTP, SMTP, LDAP) and excels in scripted environments. Unlike wget's focus on downloading, curl provides bidirectional data transfer capabilities and is specifically designed for automation within bash scripts.

### Key Concepts/Deep Dive

#### Protocol Support
Curl supports extensive protocol coverage:
- **Web Protocols**: HTTP, HTTPS, HTTP/2, HTTP/3
- **File Transfer**: FTP, FTPS, SFTP, SCP
- **Mail Protocols**: SMTP, SMTPS, IMAP, POP3
- **Directory Services**: LDAP, LDAPS
- **Other**: DICT, TELNET, TFTP, and many more

#### Basic Operations

**Simple Webpage Download**:
```bash
# Create test directory
mkdir test-dir && cd test-dir

# Basic curl to file
curl https://prowse.tech > index.html

# Alternative with progress display
curl -o index.html https://prowse.tech
```

**Direct Output to Terminal**:
```bash
curl 127.0.0.1
# Displays raw HTML content directly in terminal
```

#### File Download with Options

| Option | Purpose | Example |
|--------|---------|---------|
| `-L, --location` | Follow redirects | `curl -L -O URL` |
| `-O, --remote-name` | Save with remote filename | `curl -O URL` |
| `-o, --output FILE` | Specify output filename | `curl -o local.zip URL` |
| `-s, --silent` | Suppress progress output | `curl -s URL` |
| `--silent` | No progress meter or error messages | `curl --silent URL` |

**Advanced File Download**:
```bash
# Download specific Terraform release
curl -L -o ./terraform.zip \
"https://releases.hashicorp.com/terraform/1.6.2/terraform_1.6.2_linux_amd64.zip"

# Result: Downloads 52MB file with progress indication
# % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
#                                Dload  Upload   Total   Spent    Left  Speed
# 100 52.3M  100 52.3M    0     0  23.1M      0  0:00:02  0:00:02 --:--:-- 23.2M
```

#### Script Integration: Kea DHCP Installation

**Complete Automated Setup**:
```bash
# Download and execute setup script for Kea DHCP
curl -1sLf \
'https://dl.cloudsmith.io/public/isc/kea-2-4/cfg/setup/bash.deb.sh' \
| sudo bash

# Install Kea DHCP4 server
sudo apt install isc-kea-dhcp4-server

# Verify installation
systemctl status isc-kea-dhcp4-server

# Configuration location
ls /etc/kea/
# kea-dhcp4.conf
```

**Script Options Explained**:
- `-1`: Require TLS version 1 or higher
- `-s`: Silent mode (no progress output)
- `-L`: Follow HTTP redirects
- `-f`: Fail fast with no output on HTTP errors

#### Practical Testing Command
```bash
# Discover public IP and network information
curl ifconfig.me/all

# Sample Output:
# ip_addr: XXX.XXX.XXX.XXX
# remote_host: XXX.XXX.XXX.XXX
# user_agent: curl/7.88.1
# port: 54321
# language:
# referer:
# connection:
# method: GET
# encoding: gzip, deflate, br
# via: XXX.XXX.XXX.XXX
# forwarded: XXX.XXX.XXX.XXX
```

### Lab Demos
1. **Basic Downloads**: Retrieve files with various curl options
2. **Redirect Following**: Master the `-L` flag for URL redirections
3. **Silent Operations**: Implement silent mode for scripting
4. **Automated Installation**: Use curl to automate software installation via scripts

---

## 17.5 NetPerf

### Overview
NetPerf is a sophisticated network performance benchmarking tool that measures data throughput (transfer rates) between systems. It provides quantitative metrics for network performance analysis and is particularly valuable for establishing performance baselines in virtualized and physical environments.

### Key Concepts/Deep Dive

#### Installation Requirements
**Important**: NetPerf requires access to "non-free" repositories in Debian-based systems.

```bash
# Modify sources.list to include non-free repositories
sudo vim /etc/apt/sources.list

# Add 'non-free' to repository lines:
# Before:
# deb http://deb.debian.org/debian bookworm main
# deb http://security.debian.org/debian-security bookworm-security main

# After:
# deb http://deb.debian.org/debian bookworm main non-free
# deb http://security.debian.org/debian-security bookworm-security main non-free

# Update package lists
sudo apt update

# Install NetPerf
sudo apt install netperf
```

#### Client-Server Architecture

**Server Setup**:
```bash
# Start NetPerf server on specific port
netserver -p 50000

# Server runs continuously until manually terminated
# Use Ctrl+C or kill command to stop
```

**Client Testing**:
```bash
# Basic performance test
netperf -H 10.0.2.51 -p 50000

# Sample Output:
# MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.2.51 (10.0.2.51) port 0 AF_INET
# Recv   Send    Send                          Utilization
# Socket Socket  Message  Elapsed              Send     Recv
# Size   Size    Size     Time     Throughput  local    remote
# bytes  bytes   bytes    secs.    10^6bits/s  % S      % S
#
#  87380  65536  65536    10.00      9171.32
```

#### Understanding Throughput Metrics

**Bit Rate Calculation**:
- **Base Unit**: Results displayed as 10^6 bits/second (megabits)
- **Calculation**: `9171.32 * 10^6 = 9,171,320,000 bits/second = 9.17 Gbps`
- **Real-world Context**: Virtual machine performance often exceeds physical Gigabit networks

#### Advanced Testing Options

| Option | Description | Example |
|--------|-------------|---------|
| `-D INTERVAL` | Interim reporting interval (seconds) | `netperf -D 2` |
| `-F UNIT` | Output format (G=Gigabytes, M=Megabytes) | `netperf -F G` |
| `-H HOST` | Target host IP address | `netperf -H 192.168.1.100` |
| `-p PORT` | Target port number | `netperf -p 50000` |

**Enhanced Testing**:
```bash
# Detailed interim reporting with gigabyte output
netperf -H 10.0.2.51 -p 50000 -D 2 -F G

# Sample interim results:
# Interim result:  1.16    10^9Bytes/s over 2.000 seconds
# Interim result:  1.14    10^9Bytes/s over 2.000 seconds
# Final result:    1.15    10^9Bytes/s over 10.000 seconds
```

#### Performance Expectations

**Network Performance Baselines**:

| Environment | Expected Throughput | Notes |
|-------------|-------------------|-------|
| Virtual Machines (Virtio) | 20-40 Gbps | Internal host communication |
| Physical Gigabit LAN | ~940-980 Mbps | Real-world maximum |
| 10 Gigabit LAN | ~9.4-9.8 Gbps | High-performance networks |
| Internet Connections | Varies by plan | Limited by ISP bandwidth |

#### Virtio Networking Advantage
```bash
# Virtio provides superior VM-to-VM performance
# Check current NIC type:
# Settings → Network → Network Interface → Virtio

# Alternative virtual NICs (lower performance):
# - RTL 8139 (Realtek emulation)
# - E1000 (Intel emulation)
```

#### Server Process Management
```bash
# Find running netserver process
ps aux | grep netserver

# Sample output:
# USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
# root      8050  0.0  0.1   4520  2048 ?        S    15:30   0:00 netserver -p 50000

# Terminate specific process
sudo kill 8050

# Verify termination
netperf -H 10.0.2.51 -p 50000
# Error: establish_control: can't establish control connection
```

### Lab Demos
1. **Repository Configuration**: Enable non-free repositories for NetPerf installation
2. **Local Testing**: Establish baseline performance on single system
3. **Client-Server Testing**: Measure throughput between multiple systems
4. **Advanced Options**: Experiment with interim reporting and different output formats

---

## 17.6 Additional Tools

### Overview
This module introduces a diverse collection of specialized networking and system monitoring utilities that complement standard Linux networking tools. These tools provide real-time network traffic analysis, hardware-level information, and enhanced system monitoring capabilities.

### Key Concepts/Deep Dive

#### iftop: Real-Time Network Traffic Monitor

**Installation and Basic Usage**:
```bash
# Install iftop
sudo apt install iftop

# Run with administrative privileges
sudo iftop

# Interface Information Displayed:
# Current network interface: eth0
# Local IP: 10.0.2.52
# Local MAC: 52:54:00:12:34:56
```

**Real-Time Monitoring Features**:
- Live bandwidth utilization
- Connection tracking by host
- Data transfer rate visualization
- Source/destination IP identification

**Example Output Interpretation**:
```
   # Host name (port/service if enabled)            last 2s   last 10s last 40s
--------------------------------------------------------------------------------------------
debclient.local:ssh           => debserver.local:22     1.2Kb  2.1Kb   1.8Kb
debclient.local:ssh           <= debserver.local:22     856b   1.5Kb   1.2Kb
debclient.local:5353          => mdns.local:5353       245b   312b    198b
```

**Controls**:
- `Q`: Quit the program
- Real-time updates every 2 seconds by default

#### btop: Enhanced System Monitor

**Installation**:
```bash
sudo apt install btop
```

**Comprehensive Monitoring Display**:
- **CPU Usage**: Per-core utilization with frequency
- **Memory Usage**: RAM and swap utilization
- **Disk I/O**: Storage device activity and capacity
- **Network Activity**: Per-interface download/upload rates
- **Process Management**: PID, CPU%, MEM%, runtime information

**Network Interface Navigation**:
```bash
# Start btop
btop

# Navigation Controls:
# 'b' or 'n': Cycle to next network interface
# 'p' or 'N': Cycle to previous network interface
# 'q': Quit program
```

**Sample Network Section**:
```
Network
┌─────────────────────────────────────┐
│ Interface: eth0                     │
│ IP: 10.0.2.52                      │
│ Download: 1.2 MB/s                 │
│ Upload: 856 KB/s                   │
│ Total Down: 45.2 MB                │
│ Total Up: 12.8 MB                  │
└─────────────────────────────────────┘
```

#### ifplugstatus: Network Link Detection

**Purpose**: Detect physical network connectivity without physical access to hardware indicators.

**Installation and Usage**:
```bash
sudo apt install ifplugd
sudo ifplugstatus

# Sample Output:
# eth0: link beat detected
# wlan0: unplugged
```

**Use Cases**:
- Remote server connectivity verification
- Troubleshooting physical layer issues
- Automated network presence detection scripts

#### ethtool: Ethernet Interface Analysis

**Requirements**: Physical system (limited functionality in virtual environments)

**Installation and Basic Usage**:
```bash
sudo apt install ethtool
sudo ethtool ens6f0
```

**Comprehensive Output**:
```bash
Settings for ens6f0:
        Supported ports: [ TP ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
                                1000baseT/Full
        Supported pause frame use: Symmetric
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  1000baseT/Full
        Advertised pause frame use: No
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Speed: 1000Mb/s
        Duplex: Full
        Port: Twisted Pair
        PHYAD: 1
        Transceiver: internal
        Auto-negotiation: on
        MDI-X: off (auto)
        Supports Wake-on: pumbg
        Wake-on: g
        Current message level: 0x00000007 (7)
                               drv probe link
        Link detected: yes
```

**Key Metrics Explained**:
- **TP**: Twisted Pair (RJ45 cabling)
- **Speed/Duplex**: Current negotiated connection parameters
- **Auto-negotiation**: Automatic speed/duplex detection capability

#### bmon: Bandwidth Monitor

**Installation and Usage**:
```bash
sudo apt install bmon
bmon
```

**Visual Bandwidth Representation**:
- Real-time RX/TX graphs
- Per-interface statistics
- Historical data visualization
- Rate limiting detection

**Sample Interface Display**:
```
Interface: eth0
┌─ RX ─────────────────────────────────────────┐
│ Current:  2.3 MB/s    Average:  1.8 MB/s      │
│ Peak:    15.2 MB/s    Total:   234.5 MB       │
└───────────────────────────────────────────────┘
┌─ TX ─────────────────────────────────────────┐
│ Current:  856 KB/s    Average:  642 KB/s      │
│ Peak:     3.2 MB/s    Total:    89.1 MB       │
└───────────────────────────────────────────────┘
```

### Lab Demos
1. **Traffic Analysis**: Use iftop to monitor real-time network connections
2. **System Monitoring**: Explore btop's comprehensive system overview
3. **Link Detection**: Verify network connectivity with ifplugstatus
4. **Hardware Analysis**: Examine Ethernet parameters with ethtool (physical systems)
5. **Bandwidth Visualization**: Monitor data transfer patterns with bmon

---

## 17.7 Deprecated Tools

### Overview
This module covers legacy networking tools that have been superseded by modern alternatives but remain relevant for compatibility, cross-platform administration, and historical understanding. These tools include ifconfig, route, netstat, and arp from the net-tools package.

### Key Concepts/Deep Dive

#### Installation of Legacy Tools
```bash
# Install the complete net-tools package
sudo apt install net-tools -y

# Package includes: ifconfig, netstat, route, arp, rarp, and others
```

**Note**: These tools require sudo privileges due to their deprecated status and potential security implications.

#### ifconfig: Legacy Network Interface Configuration

**Current Usage**:
```bash
sudo ifconfig

# Sample Output:
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.52  netmask 255.255.255.0  broadcast 10.0.2.255
        inet6 fe80::5054:ff:fe12:3456  prefixlen 64  scopeid 0x20<link>
        ether 52:54:00:12:34:56  txqueuelen 1000  (Ethernet)
        RX packets 12345  bytes 5678901 (5.4 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 9876  bytes 3456789 (3.3 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

**Comparison with Modern Alternative**:
```bash
# Modern equivalent
ip addr show

# Key Differences:
# - ifconfig: Shows netmask as 255.255.255.0
# - ip addr: Shows CIDR notation as /24
# - ifconfig: Legacy format for BSD/macOS compatibility
```

**Cross-Platform Relevance**:
- **BSD Systems**: Still primary network configuration tool
- **macOS**: Default network interface utility
- **Synology DSM**: Network Attached Storage management

#### route: Legacy Routing Table Display

**Usage**:
```bash
sudo route

# Sample Output:
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         _gateway        0.0.0.0         UG    100    0        0 eth0
10.0.2.0        0.0.0.0         255.255.255.0   U     100    0        0 eth0
```

**Enhanced Readability**:
```bash
sudo route -n

# Sample Output (numerical format):
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.0.2.1        0.0.0.0         UG    100    0        0 eth0
10.0.2.0        0.0.0.0         255.255.255.0   U     100    0        0 eth0
```

**Modern Alternative**:
```bash
ip route show
# Default via 10.0.2.1 dev eth0 proto dhcp src 10.0.2.52 metric 100
# 10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.52 metric 100
```

#### netstat: Network Statistics and Connections

**Basic Usage**:
```bash
netstat

# Note: No sudo required for basic functionality
```

**Focused Connection Analysis**:
```bash
netstat -ant

# Sample Output:
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN
tcp        0      0 10.0.2.52:22            10.0.2.100:54321        ESTABLISHED
tcp6       0      0 :::80                   :::*                    LISTEN
```

**Option Breakdown**:
- `-a`: Show all connections and listening ports
- `-n`: Show numerical addresses instead of hostnames
- `-t`: Show only TCP connections

**Modern Alternative**:
```bash
ss -ant

# Similar output with enhanced performance and additional features
```

#### arp: Address Resolution Protocol Cache

**Usage**:
```bash
sudo arp

# Sample Output:
Address                  HWtype  HWaddress           Flags Mask            Iface
gateway                  ether   52:54:00:12:34:57   C                     eth0
10.0.2.100              ether   52:54:00:ab:cd:ef   C                     eth0
```

**Enhanced Output Formats**:
```bash
# Ethernet format
sudo arp -e

# Alternative format
sudo arp -a

# Sample Output:
gateway (10.0.2.1) at 52:54:00:12:34:57 [ether] on eth0
10.0.2.100 (10.0.2.100) at 52:54:00:ab:cd:ef [ether] on eth0
```

**Modern Alternative**:
```bash
ip neighbor show
# or
ip n

# Sample Output:
10.0.2.1 dev eth0 lladdr 52:54:00:12:34:57 REACHABLE
10.0.2.100 dev eth0 lladdr 52:54:00:ab:cd:ef STALE
```

### Recommended Migration Path

| Legacy Tool | Modern Replacement | Command |
|-------------|-------------------|---------|
| ifconfig | ip addr | `ip addr show` |
| route | ip route | `ip route show` |
| netstat | ss | `ss -ant` |
| arp | ip neighbor | `ip neighbor show` |

### Lab Demos
1. **Legacy Tool Installation**: Install and explore net-tools package
2. **Interface Analysis**: Compare ifconfig output with ip addr
3. **Routing Examination**: Analyze routing tables with route vs ip route
4. **Connection Monitoring**: Use netstat for connection analysis
5. **ARP Cache Inspection**: Explore MAC address resolution with arp

---

## 17.8 speedtest-cli

### Overview
The speedtest-cli utility provides command-line access to internet speed testing services, enabling bandwidth verification and performance monitoring directly from terminal environments. This tool is essential for validating internet service provider performance claims and establishing baseline connectivity metrics.

### Key Concepts/Deep Dive

#### Installation and Basic Usage

**Installation**:
```bash
sudo apt install speedtest-cli
```

**Privacy-Conscious Testing**:
```bash
# Standard test (displays public IP - use with caution)
sudo speedtest-cli

# Privacy-focused simple output
speedtest-cli --simple
```

#### Output Analysis

**Simple Mode Results**:
```bash
speedtest-cli --simple

# Sample Output:
Ping: 12.345 ms
Download: 294.12 Mbit/s
Upload: 18.67 Mbit/s
```

**Detailed Mode Output**:
```bash
speedtest-cli

# Comprehensive Results:
Retrieving speedtest.net configuration...
Testing from Internet Service Provider (XXX.XXX.XXX.XXX)...
Retrieving speedtest.net server list...
Selecting best server based on ping...
Hosted by Server Provider (City, State) [12.34 km]: 8.901 ms
Testing download speed................................................................................
Download: 294.12 Mbit/s
Testing upload speed......................................................................................................
Upload: 18.67 Mbit/s
```

#### Technical Considerations

**Virtual Machine Testing**:
- Results may vary when testing from virtual machines
- Bridge mode configurations provide near-native performance
- NAT configurations may introduce slight overhead
- **Important**: Virtual machine results are representative when bridged directly to physical NIC

**Performance Expectations**:
- **Download Speeds**: Typically higher than upload for residential connections
- **Upload Speeds**: Usually asymmetrical in cable/DSL connections
- **Ping/Latency**: Indicates connection responsiveness to test server
- **Geographic Factors**: Server selection affects measured performance

#### Practical Applications

**Network Troubleshooting**:
```bash
# Baseline establishment
speedtest-cli --simple

# Regular monitoring script
#!/bin/bash
echo "$(date): $(speedtest-cli --simple)" >> ~/speedtest.log
```

**ISP Verification**:
- Validate advertised speeds against actual performance
- Compare results across different times of day
- Document performance for service disputes

### Lab Demos
1. **Installation and Testing**: Install speedtest-cli and run initial tests
2. **Privacy Configuration**: Use simple mode to protect sensitive information
3. **Performance Documentation**: Establish baseline internet connectivity metrics
4. **Cross-Platform Validation**: Compare virtual machine vs physical host results

---

## Summary

### Key Takeaways
```diff
+ wget: Non-interactive web downloader with recursive capabilities and extensive option set
+ curl: Versatile data transfer tool optimized for scripting and automation across multiple protocols
+ Apache: Complete web server installation, configuration, and content management workflow
+ NetPerf: Network performance benchmarking establishing quantitative throughput baselines
+ Additional Tools: Specialized utilities for traffic analysis, system monitoring, and hardware diagnostics
+ Deprecated Tools: Legacy compatibility layer for cross-platform administration and historical contexts
+ speedtest-cli: Internet bandwidth verification and ISP performance validation
```

### Quick Reference

#### Essential Commands
```bash
# Data Transfer
wget -nd -np -r --accept=.zip URL          # Selective recursive download
curl -L -o file.zip URL                    # Download with redirect following
curl -1sLf 'URL' | sudo bash               # Silent script execution

# Web Server Management
sudo apt install apache2                   # Install Apache
sudo systemctl start/stop/status apache2   # Service control
sudo vim /var/www/html/index.html          # Content creation

# Network Performance
sudo apt install netperf                   # Install (requires non-free repos)
netserver -p 50000                         # Start server
netperf -H HOST -p PORT -D 2 -F G          # Client testing with options

# System Monitoring
sudo iftop                                 # Real-time traffic analysis
btop                                       # Comprehensive system monitor
sudo ethtool INTERFACE                     # Ethernet hardware analysis
bmon                                       # Bandwidth visualization

# Legacy Tools
sudo ifconfig                              # Legacy interface configuration
sudo route -n                              # Legacy routing table
netstat -ant                               # Legacy connection analysis
sudo arp -e                                # Legacy ARP cache inspection

# Internet Testing
speedtest-cli --simple                     # Privacy-conscious speed test
```

### Expert Insight

#### Real-world Application
- **wget/curl**: Essential for automated deployment scripts, configuration management, and CI/CD pipelines
- **Apache**: Foundation for web hosting, reverse proxy configurations, and development environments
- **NetPerf**: Critical for network capacity planning, SLA verification, and performance optimization
- **Additional Tools**: Enable proactive network monitoring, capacity planning, and hardware troubleshooting
- **Deprecated Tools**: Necessary for legacy system maintenance, cross-platform consistency, and vendor-specific environments
- **speedtest-cli**: Validates ISP performance, enables remote connectivity assessment, and supports network troubleshooting

#### Expert Path
1. **Master scripting integration** of wget and curl for automated system provisioning
2. **Develop Apache expertise** including virtual hosts, SSL/TLS, and performance tuning
3. **Establish performance baselines** using NetPerf across different network topologies
4. **Build monitoring dashboards** combining data from iftop, btop, and bmon
5. **Create compatibility layers** for environments requiring both legacy and modern tools
6. **Implement continuous internet monitoring** with speedtest-cli for SLA compliance

#### Common Pitfalls
- **wget/curl confusion**: wget excels at mirroring, curl at protocol versatility and scripting
- **Apache permission issues**: Always use sudo for /var/www modifications
- **NetPerf repository access**: Must enable non-free repositories before installation
- **Virtual machine networking**: Performance results significantly different from physical networks
- **Deprecated tool security**: These tools may lack modern security features and should be used cautiously
- **Speed test privacy**: Always use --simple flag to avoid exposing public IP addresses

#### Lesser-Known Facts
- **Neofetch extensibility**: Configuration file allows custom scripting and additional information sources
- **wget resume capability**: Automatically resumes interrupted downloads with `-c` flag
- **curl's mail capabilities**: Can send emails directly via SMTP integration
- **NetPerf's bidirectional testing**: Can test both upload and download performance simultaneously
- **iftop's connection tracking**: Identifies individual network flows and bandwidth consumers
- **ethtool's advanced features**: Can modify NIC settings including Wake-on-LAN and auto-negotiation
- **speedtest-cli's server selection**: Algorithmically chooses optimal test server based on latency

</details>