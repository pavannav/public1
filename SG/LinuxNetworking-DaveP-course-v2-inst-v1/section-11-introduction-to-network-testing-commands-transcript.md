# Section 11: Introduction to Network Testing Commands

<details open>
<summary><b>Section 11: Introduction to Network Testing Commands (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [11.1 Introduction to Network Testing Commands](#11.1-introduction-to-network-testing-commands)
- [11.2 ping Basics](#11.2-ping-basics)
- [11.3 Advanced ping](#11.3-advanced-ping)
- [11.4 traceroute](#11.4-traceroute)
- [11.5 whois](#11.5-whois)
- [11.6 dig and nslookup](#11.6-dig-and-nslookup)
- [11.7 ss](#11.7-ss)
- [11.8 nmap Scanning](#11.8-nmap-scanning)
- [Summary](#summary)

---

## 11.1 Introduction to Network Testing Commands

### Overview
This module provides an overview of essential Linux networking diagnostic tools that allow system administrators to analyze, troubleshoot, and verify network connectivity across Linux systems and remote hosts.

### Key Concepts and Tools

#### Network Testing Command Overview

| Command | Purpose | Use Case |
|---------|---------|----------|
| `ping` | Test host availability and reachability | Verify if a host is alive on the network |
| `traceroute` | Display network path and hops to remote host | Identify routing issues and path problems |
| `whois` | Discover domain/host registration information | Find domain registration details and contacts |
| `dig`/`nslookup` | Query DNS information | Resolve hostnames and analyze DNS records |
| `ss` | Display socket and port information | Analyze active network connections |
| `nmap` | Network scanning and port discovery | Discover hosts and open services on networks |

#### Tool Integration Strategy
These commands work together to provide comprehensive network analysis:
- Start with `ping` to confirm basic connectivity
- Use `traceroute` to identify path issues
- Leverage DNS tools (`dig`, `nslookup`) for name resolution problems
- Analyze ports with `ss` and `nmap` for service verification

> [!NOTE]
> When used together, these commands provide authoritative analysis of Linux systems and network infrastructure.

---

## 11.2 ping Basics

### Overview
The ping command tests network connectivity by sending ICMP echo requests to determine if hosts are reachable and measure response times, serving as the foundation for network troubleshooting.

### Key Concepts

#### Basic ping Syntax and Options

```bash
# Basic ping syntax
ping [hostname|IP_address]

# Common options
ping -c [count]     # Send specific number of ICMP echoes
ping -s [size]      # Specify packet size in bytes
ping -4             # Force IPv4
ping -6             # Force IPv6
```

#### ICMP Protocol Fundamentals
- **ICMP**: Internet Control Message Protocol operates at Layer 3 (Network Layer)
- **Purpose**: Provides supervisory/management functionality for network diagnostics
- **Default Behavior**: Linux ping runs continuously until interrupted (Ctrl+C)

#### Systematic Network Testing Methodology

The recommended approach branches outward systematically:

```bash
# Step 1: Test localhost (verify TCP/IP stack)
ping localhost -4          # Tests 127.0.0.1 (IPv4 loopback)
ping localhost -6          # Tests ::1 (IPv6 loopback)
ping 127.0.0.1             # Direct IPv4 loopback test

# Step 2: Test local system hostname
ping [hostname]            # May resolve to 127.0.1.1 on Debian/Ubuntu

# Step 3: Test actual system IP
ping [system_IP]           # Direct IP connectivity test

# Step 4: Test gateway
ping [gateway_IP]          # Local network connectivity

# Step 5: Test remote hosts
ping example.com           # Internet connectivity and DNS resolution
```

#### Response Time Analysis
- **Local/Gateway connections**: < 1ms (typically 0.1-0.3ms)
- **LAN connections**: ~1ms
- **Internet connections**: 10+ ms depending on distance

#### Debian/Ubuntu Specific Behavior
> [!IMPORTANT]
> Debian and Ubuntu systems associate the hostname with 127.0.1.1 instead of 127.0.0.1, which differs from other Linux distributions like Fedora.

---

## 11.3 Advanced ping

### Overview
Advanced ping techniques provide enhanced diagnostic capabilities through count control, packet size manipulation, and automated testing scripts for comprehensive network analysis.

### Advanced Options and Techniques

#### Count Control with -c
```bash
# Send specific number of pings
ping -c 5 [destination]           # Send exactly 5 ICMP echoes

# Single ping for availability testing
ping -c 1 [destination]           # Useful in scripts for alive checks
```

#### Packet Size Control with -s
```bash
# Default packet analysis
# Default: 64 bytes (small supervisory packets)

# Custom packet sizes
ping -s 1400 -c 5 [destination]   # 1400-byte packets + 8-byte ICMP header

# Maximum theoretical size
ping -s 65500 [destination]       # Maximum TCP/IP packet size (rarely practical)
```

#### MTU and Frame Size Considerations
- **MTU (Maximum Transmission Unit)**: 1500 bytes for standard Ethernet frames
- **Layer 2 Constraint**: Ethernet frames cannot exceed 1500 bytes
- **IP Packet Sizing**: Must be smaller than MTU due to frame encapsulation overhead
- **Firewall Filtering**: Many firewalls block packets >1500 bytes

#### Lab Demonstration: Packet Size Impact
```bash
# Compare response times with different packet sizes
ping -c 5 10.0.2.1                # Normal 64-byte packets ~0.153ms average
ping -s 1400 -c 5 10.0.2.1        # Large 1400-byte packets ~0.165ms average
ping -s 65500 -c 5 10.0.2.1      # Maximum size ~0.466ms average
```

### Automated Network Testing

#### superping Script Overview
A bash script for batch testing multiple systems:

```bash
# Script components:
# - Reads hosts from computers.txt
# - Uses while loop with do statement
# - Pings each system systematically
# - Logs results (responding/non-responding)
# - Stores output in separate files
```

#### Practical Applications
- **Server monitoring**: Verify critical systems availability
- **Network infrastructure testing**: Check switches, routers, servers
- **Script integration**: Use `-c 1` for efficient alive checks

> [!TIP]
> The superping script is available in the course repository under the scripts directory.

---

## 11.4 traceroute

### Overview
The traceroute command maps the complete network path from source to destination, identifying each hop and measuring latency to diagnose routing issues and network problems.

### traceroute Fundamentals

#### Basic Usage
```bash
# Standard traceroute
traceroute example.com

# Numeric output (no DNS resolution)
traceroute -n example.com

# Custom query count per hop
traceroute -q 5 example.com
```

#### Output Interpretation
```
traceroute to example.com
1  virtualization-gateway (10.0.2.1)
2  physical-gateway (10.42.0.1)
3  isp-router (various IPs)
...
9  example.com (93.184.216.34)
```

Each hop shows three ping attempts by default, providing latency measurements similar to ping results.

#### Troubleshooting with traceroute
- **Three stars (***): Indicates timeout, hidden hop, or connectivity issue
- **Path analysis**: Identifies exactly where connectivity breaks
- **Performance monitoring**: Compare hop-by-hop latency increases

### Advanced Options

#### -n (Numeric) Option
```bash
# Suppress hostname resolution for faster results
traceroute -n example.com

# Benefits:
# - Eliminates DNS lookup delays
# - Shows raw IP addresses
# - Essential for network administrators
```

#### -q (Query Count) Option
```bash
# Increase pings per hop for thorough analysis
traceroute -q 5 example.com

# Default: 3 queries per hop
# Useful when suspecting timeout issues at specific hops
```

#### Help and Documentation
```bash
traceroute --help    # Display all available options
man traceroute       # Complete manual documentation
```

---

## 11.5 whois

### Overview
The whois command retrieves comprehensive domain registration and contact information, essential for domain analysis and network reconnaissance.

### Installation and Basic Usage

#### Installation
```bash
# Install whois package (may not be installed by default)
sudo apt install whois

# Verify installation
whois --version
```

#### Basic Domain Query
```bash
# Query domain information
whois example.com
whois prowse.tech
```

### Information Retrieved

#### Domain Registration Details
- **Registry Domain ID**: Unique identifier from registrar
- **Creation/Update dates**: Domain registration timeline (example.com: 1995)
- **Registrar information**: Registration service provider (e.g., namecheap, Verisign)
- **Name servers**: Authoritative DNS servers for the domain
- **Contact information**: Administrative and technical contacts
- **DNSSEC status**: Security configuration (signed/unsigned)

#### Example Output Analysis
```bash
whois example.com
# Registry Domain ID: 233679-DOMAIN
# Registrar: RESERVED-Internet Assigned Numbers Authority
# Creation Date: 1995-08-14T04:00:00Z
# Name Servers: A.IANA-SERVERS.NET, B.IANA-SERVERS.NET
```

### Advanced Options

#### Specialized Queries
```bash
# Hide legal disclaimers
whois -H example.com

# Get IANA information
whois -I example.com

# Combined options
whois -H -I prowse.tech
```

#### TLD-Specific Information
- **.tech domains**: Managed by Radix organization (Mumbai)
- **Registrar details**: Different registrars provide varying information levels
- **Privacy considerations**: Some domains may hide contact information

> [!WARNING]
> Always review terms of use and legal information provided in whois results.

---

## 11.6 dig and nslookup

### Overview
DNS analysis tools dig and nslookup provide deep insight into domain name resolution, DNS records, and network infrastructure through authoritative DNS queries.

### dig Command (Preferred)

#### Basic Usage
```bash
# Basic domain lookup
dig example.com

# Reverse lookup (IP to hostname)
dig -x 93.184.216.34

# Alternative domains
dig prowse.tech
dig dprocomputer.com
```

#### Output Analysis

##### Header Verification
```
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 12345
```
- **NOERROR**: Results are trustworthy
- **Any other status**: Indicates potential issues with results

##### Answer Section Components
- **A records**: Direct IP address mappings
- **CNAME records**: Canonical names/aliases
- **Query time**: Response speed measurement
- **Server identification**: DNS server that processed query

#### Advanced Examples

##### Forward Lookup Analysis
```bash
dig prowse.tech
# prowse.tech. CNAME prowse-tech.ghost.io.
# prowse-tech.ghost.io. CNAME ghost.map.fastly.net.
# ghost.map.fastly.net. A 151.101.1.195
```

##### Reverse Lookup Process
```bash
# Step 1: Find IP address
ping example.com    # Shows: 93.184.216.34

# Step 2: Reverse DNS lookup
dig -x 93.184.216.34
# Returns: 34.216.184.93.in-addr.arpa.
# Pointer (PTR) record for reverse mapping
# Start of Authority (SOA) record information
```

### nslookup Command

#### Basic Usage
```bash
# Standard lookup
nslookup prowse.tech

# Interactive mode
nslookup
# > prowse.tech
# > google.com
# > exit
```

#### Server Information Display
```
Server: 10.42.0.1#53
Address: 10.42.0.1#53

Non-authoritative answer:
prowse.tech canonical name = prowse-tech.ghost.io.
```

### Comparative Analysis

| Feature | dig | nslookup |
|---------|-----|----------|
| **Recommendation** | Preferred for Linux/Unix | Legacy command |
| **Interactive mode** | No | Yes |
| **Output detail** | Comprehensive | Basic |
| **Options** | Extensive (check help) | Limited |

#### DNS Record Types Demonstrated
- **A records**: IPv4 address mappings
- **AAAA records**: IPv6 address mappings
- **CNAME records**: Canonical name aliases
- **PTR records**: Reverse lookup pointers
- **SOA records**: Start of Authority information

> [!IMPORTANT]
> For comprehensive DNS analysis, use `dig` as the primary tool, falling back to `nslookup` only when specific interactive features are needed.

---

## 11.7 ss

### Overview
The ss (socket statistics) command provides detailed analysis of network sockets, ports, and active connections, serving as a modern replacement for the legacy netstat command.

### Core ss Command Options

#### Basic Socket Display
```bash
# Show all established socket connections
ss

# Display TCP and UDP with numeric addresses
ss -tulnw

# Show TCP connections with process info
ss -tun

# Include process ID information
ss -plunt

# All listening and TCP/UDP connections
ss -ant
```

#### Option Breakdown
- **-t**: TCP connections only
- **-u**: UDP connections only
- **-l**: Listening sockets
- **-n**: Numeric (no hostname resolution)
- **-w**: Wide format for better readability
- **-p**: Show process ID and program name

### Network Port Fundamentals

#### Port Range and Categories
- **Total ports available**: 65,536 (0-65535)
- **Port 53**: DNS service
- **Port 22**: SSH service
- **Port 80**: HTTP (avoid in favor of HTTPS)
- **Port 443**: HTTPS (recommended)

#### Protocol Analysis
```bash
# View both TCP and UDP connections
ss -tulnw

# TCP: Connection-oriented, guaranteed delivery
# - Services: SSH, FTP, HTTPS
# - Socket type: Stream sockets

# UDP: Connectionless, best-effort delivery
# - Services: Streaming media, DNS queries
# - Socket type: Datagram sockets
```

### Real-time Monitoring

#### Watch Command Integration
```bash
# Real-time connection monitoring
watch ss -tun

# Default refresh: every 2 seconds
# Press Ctrl+C to exit monitoring
```

#### Practical Monitoring Scenario
```bash
# Terminal 1: Start monitoring
watch ss -tun

# Terminal 2: Generate connections
# Open browser to various websites
# Observe new established connections appear
```

### Connection State Analysis

#### Established Connection Example
```
State  Recv-Q Send-Q  Local Address:Port  Peer Address:Port   Process
ESTAB  0      0       10.0.2.52:45106    3.162.100.204:80
```

#### Local System Analysis
- **Source**: Local system IP and ephemeral port
- **Destination**: Remote server IP and service port
- **State**: ESTAB (established connection)

> [!TIP]
> Use `ss -tun` regularly on servers to monitor established TCP connections, and `watch ss -tun` for real-time analysis during troubleshooting.

---

## 11.8 nmap Scanning

### Overview
Nmap provides comprehensive network discovery and security auditing capabilities, enabling administrators to map network topology, identify active hosts, and enumerate open services across entire network segments.

### Installation and Verification

```bash
# Install if not present
sudo apt install nmap -y

# Verify installation
nmap -V

# Access documentation
nmap.org
```

### Basic Network Scanning

#### Network Host Discovery
```bash
# Scan entire subnet for active hosts
nmap -sn 10.0.2.0/24

# Results interpretation:
# Nmap scan report for 10.0.2.0/24
# Nmap done: 3 IP addresses (3 hosts up) scanned
```

#### Sample Network Scan Output
```
Nmap scan report for 10.0.2.1
Host is up
Nmap scan report for 10.0.2.51
Host is up
Nmap scan report for 10.0.2.52
Host is up
```

### Port Scanning Techniques

#### Default TCP Port Scanning
```bash
# Scan first 1000 TCP ports on target
nmap 10.0.2.51

# Sample results:
# PORT   STATE SERVICE
# 22/tcp open  ssh
```

#### Multi-System Network Analysis

##### Proxmox System Analysis
```bash
nmap 10.42.0.11
# Host: parallax.dpro42.local
# 22/tcp   open  ssh
# 111/tcp  open  rpcbind
# 3128/tcp open  squid-http
```

##### Ubuntu Desktop System Analysis
```bash
nmap 10.42.0.15
# Host: telemetry
# 22/tcp   open  ssh
# 4000/tcp open  remoteanything  (NoMachine)
# 8200/tcp open  trivnet1
# 9090/tcp open  zeus-admin        (Cockpit web interface)
```

### Protocol and Service Identification

#### Service Detection Process
1. **Port identification**: Nmap tests connectivity on each port
2. **Service recognition**: Matches port numbers to known services
3. **Protocol analysis**: Identifies TCP vs UDP usage
4. **Version detection**: When possible, identifies service versions

#### Output Format Analysis
```
PORT     STATE SERVICE      REASON
22/tcp   open  ssh          syn-ack
111/tcp  open  rpcbind      syn-ack
3128/tcp open  squid-http   syn-ack
```

### Complementary Tools

#### ip neighbor Command
```bash
# Show network neighbors (ARP table)
ip neighbor
# OR abbreviated forms:
ip neigh
ip n

# Sample output:
# 10.0.2.1 dev eth0 lladdr 52:54:00:12:34:56 REACHABLE
# 10.0.2.51 dev eth0 lladdr 52:54:00:12:34:57 STALE
```

#### Connection State Management
- **REACHABLE**: Active/recent communication confirmed
- **STALE**: No recent communication, cached entry
- **Update trigger**: New ping or connection forces state update

### Security and Ethical Considerations

> [!IMPORTANT]
> Nmap scanning should only be performed on networks and systems you own or have explicit permission to scan. Unauthorized scanning may violate security policies or laws.

#### Network Mapping Strategy
1. **Subnet discovery**: Use `-sn` for host enumeration
2. **Service identification**: Default scans for open ports
3. **Detailed analysis**: Target specific systems for in-depth examination
4. **Documentation**: Record findings for network inventory

---

## Summary

### Key Takeaways
```diff
! Network testing requires systematic approach: localhost → system → gateway → remote
+ ping provides basic connectivity testing with various packet sizes and counts
+ traceroute maps complete network paths identifying each hop and potential failures
+ DNS tools (dig/nslookup) reveal name resolution details and infrastructure
+ ss command monitors real-time socket connections and port utilization
+ nmap enables comprehensive network discovery and service enumeration
- Always verify DNS resolution before trusting network diagnostic results
```

### Quick Reference

#### Essential Command Cheat Sheet
```bash
# Connectivity Testing
ping -c 4 [target]              # 4 pings to target
ping -s 1400 [target]           # Large packet test

# Path Analysis
traceroute -n [target]          # Numeric traceroute (no DNS)
traceroute -q 5 [target]        # 5 queries per hop

# DNS Analysis
dig [domain]                    # Forward DNS lookup
dig -x [IP]                     # Reverse DNS lookup
nslookup [domain]               # Alternative DNS tool

# Domain Information
whois -H [domain]               # Domain info (hide legal text)

# Socket/Port Analysis
ss -tulnw                       # All TCP/UDP connections numeric
ss -tun                         # Established TCP connections
watch ss -tun                   # Real-time monitoring

# Network Discovery
nmap -sn [network/24]           # Host discovery scan
nmap [target]                   # Port scan target
ip neighbor                     # Show network neighbors
```

### Expert Insights

#### Real-world Application
- **Network troubleshooting**: Systematic connectivity testing from local to remote
- **Security auditing**: Regular port scanning to identify unauthorized services
- **Performance monitoring**: Latency analysis for network optimization
- **Incident response**: Rapid network mapping during security events

#### Expert Path
1. Master basic ping variations before advancing to complex scenarios
2. Practice traceroute analysis on various network topologies
3. Develop custom scripts combining multiple tools for automated testing
4. Learn to interpret DNS results for infrastructure mapping
5. Create monitoring dashboards using ss and nmap outputs

#### Common Pitfalls
- **Ignoring DNS errors**: Always verify "NOERROR" status in dig results
- **Firewall interference**: Large ping packets (>1500 bytes) often blocked
- **Permission issues**: nmap and some ss options require elevated privileges
- **Network congestion**: High query counts can trigger rate limiting
- **Privacy violations**: Respect organizational policies when scanning networks

#### Lesser-Known Facts
- **Debian hostname quirk**: Uses 127.0.1.1 vs standard 127.0.0.1 for hostname resolution
- **Virtualization timing**: VM-to-gateway pings (~0.1ms) vs physical gateway (~0.2-0.3ms)
- **Port significance**: Ephemeral ports (like 45106) indicate client-side connections
- **Service identification**: Nmap can identify hidden services like NoMachine (port 4000)
- **Cockpit integration**: Modern Linux systems expose web management on port 9090

</details>