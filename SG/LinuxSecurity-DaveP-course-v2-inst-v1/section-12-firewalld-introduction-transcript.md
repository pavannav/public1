# Section 12: firewalld Introduction

<details open>
<summary><b>Section 12: firewalld Introduction (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [12.1 firewalld Introduction](#121-firewalld-introduction)
- [12.2 Installing and Enabling firewalld](#122-installing-and-enabling-firewalld)
- [12.3 Configuring and Testing firewalld](#123-configuring-and-testing-firewalld)
- [12.4 Lock it Down!](#124-lock-it-down)
- [12.5 Returning the System to its Original State](#125-returning-the-system-to-its-original-state)
- [Summary](#summary)

---

## 12.1 firewalld Introduction

### Overview
firewalld is a dynamic firewall management tool developed by Red Hat that serves as a front-end for the Linux netfilter framework through NFtables. It provides an alternative to direct NFT user-space commands and is the recommended firewall solution for workstations, while also being suitable for servers. The tool uses a zone-based security model that allows different levels of security to be applied to different network interfaces.

### Key Concepts

#### What is firewalld?
- **Developer**: Created by Red Hat
- **Primary Platforms**: Fedora, Red Hat Enterprise Linux (RHEL), CentOS
- **Default Installation**: Pre-installed and enabled on Red Hat-based systems
- **Architecture**: Front-end for netfilter framework via NFtables
- **Alternative To**: Direct NFT user-space commands
- **Cross-Platform Support**: Can be installed on Debian and Ubuntu systems

#### Zone-Based Security Model
```bash
# Built-in zones with varying security levels
firewall-cmd --get-zones
# Output: block, dmz, drop, external, home, internal, public, trusted, work
```

**Security Zone Hierarchy** (from least to most secure):
- **Trusted**: All incoming traffic allowed
- **Home/Internal**: Designed for home/trusted networks
- **Public**: Default zone with moderate security
- **DMZ**: Demilitarized zone configuration
- **External**: For external-facing interfaces with NAT
- **Work**: For work environments
- **Block**: Rejects all incoming connections with ICMP replies
- **Drop**: Silently drops all incoming packets (most secure)

#### Primary Command Interface
All firewalld operations use the `firewall-cmd` command:

```bash
# Service Management
systemctl status firewalld      # Check firewalld status
systemctl start firewalld       # Start firewalld
systemctl stop firewalld        # Stop firewalld
systemctl enable firewalld      # Enable on boot
systemctl disable firewalld     # Disable on boot

# Zone Operations
firewall-cmd --get-active-zones           # Display active zones
firewall-cmd --get-default-zone           # Show default zone
firewall-cmd --set-default-zone=<zone>    # Set default zone
firewall-cmd --list-all                   # List all configuration

# Port Operations
firewall-cmd --list-ports                 # List open ports
firewall-cmd --add-port=<port>/<protocol> # Add port rule
firewall-cmd --remove-port=<port>/<protocol> # Remove port rule

# Service Operations
firewall-cmd --list-services              # List allowed services
firewall-cmd --add-service=<service>      # Add service rule
firewall-cmd --remove-service=<service>   # Remove service rule
```

### Important Notes
- Zones can be assigned to specific network interfaces
- Permanent changes require the `--permanent` flag
- Changes require `--reload` to take effect
- Current SSH sessions persist even after firewall changes
- firewalld behavior may differ slightly on Debian/Ubuntu systems

---

## 12.2 Installing and Enabling firewalld

### Overview
This lab module demonstrates the initial setup and examination of firewalld on a CentOS system. It covers verifying the service status, understanding the default zone configuration, and exploring the various built-in security zones available for different network security requirements.

### Lab Environment Setup
- **Server**: CentOS 9 system (IP: 10.0.2.61)
- **Client**: Debian system for testing connectivity
- **Network Interface**: enp1s0
- **Initial State**: firewalld running with basic configuration

### Key Concepts

#### Initial Connectivity Verification
```bash
# From client system - verify connectivity before firewall changes
ping 10.0.2.61          # Should receive replies
ssh root@10.0.2.61      # Should connect successfully
```

#### Service Status Verification
```bash
# Check if firewalld is running and enabled
systemctl status firewalld

# Expected output shows:
# - Active (running) status
# - Enabled on boot
# - Main PID and process information
```

#### Installation on Debian/Ubuntu
```bash
# For Debian/Ubuntu systems (not pre-installed)
sudo apt update
sudo apt install firewalld

# Enable and start the service
sudo systemctl --now enable firewalld
```

#### Default Zone Configuration
```bash
# Examine active zones
firewall-cmd --get-active-zones
# Output: public zone on enp1s0 interface

# View complete zone configuration
firewall-cmd --list-all
```

**Default Zone Contents**:
- **ICMP Block Inversion**: No (allows ping responses)
- **Pre-configured Services**:
  - cockpit (web console)
  - dhcpv6-client
  - ssh (port 22)
- **Additional Ports**: May include port 2222 from previous SELinux lab

#### Zone Templates Overview
```bash
# List all built-in zones
firewall-cmd --get-zones

# Detailed zone information
firewall-cmd --list-all-zones | less
```

**Zone Security Levels**:
- **Block Zone**: Rejects all incoming connections with ICMP host-unreachable messages
- **Drop Zone**: Silently drops all packets (stealth mode)
- **Public Zone**: Balanced security for public-facing systems
- **DMZ Zone**: Suitable for demilitarized zone configurations

### Lab Demonstration

#### Step 1: Pre-configuration Connectivity Test
```bash
# From Debian client
ping 10.0.2.61          # Successful replies
ssh root@10.0.2.61      # Connection established
```

#### Step 2: Zone Analysis
```bash
# On CentOS server
firewall-cmd --get-active-zones
# Result: public zone on enp1s0

firewall-cmd --list-all
# Shows services: cockpit, dhcpv6-client, ssh
# Shows port 2222 (from previous SELinux work)
```

#### Step 3: Security Zone Evaluation
The tutorial emphasizes using more secure zones like **block** or **drop** for production servers rather than the default **public** zone.

### Important Security Observations
- Port 2222 was identified as a potential security vulnerability (leftover from SELinux lab)
- Default zones may have varying security postures
- Some zones allow specific services while others block everything
- Understanding zone differences is crucial for proper security implementation

---

## 12.3 Configuring and Testing firewalld

### Overview
This comprehensive lab module covers advanced firewalld configuration including zone management, security testing, rule modifications, and multi-port configurations. It demonstrates practical firewall management through hands-on testing from both server and client perspectives.

### Configuration Tasks

#### Zone Management
```bash
# Change active zone with persistence
firewall-cmd --zone=block --change-interface=enp1s0 --permanent

# Verify zone change
firewall-cmd --get-active-zones
# Output: block zone on enp1s0

# Set default zone for command operations
firewall-cmd --set-default-zone=block
firewall-cmd --get-default-zone
# Output: block
```

#### Security Level Testing
After switching to the **block** zone:

**From Client System**:
```bash
ping 10.0.2.61          # Result: "packet filtered"
ssh root@10.0.2.61      # Result: "No route to host"
nmap -Pn 10.0.2.61      # Result: All ports filtered/closed
```

**Server Verification**:
```bash
firewall-cmd --zone=block --list-ports
# Output: (empty - no ports open)
```

#### Adding SSH Access
```bash
# Add SSH port with permanent rule
firewall-cmd --zone=block --add-port=22/tcp --permanent

# Reload firewall to apply changes
firewall-cmd --reload

# Verify configuration
firewall-cmd --zone=block --list-ports
# Output: 22/tcp
```

#### Testing SSH Connectivity
```bash
# From client - after adding SSH rule
ssh root@10.0.2.61
# Connection successful
```

#### Rule Removal
```bash
# Remove SSH port rule
firewall-cmd --zone=block --remove-port=22/tcp --permanent
firewall-cmd --reload

# Verify removal
firewall-cmd --zone=block --list-all
```

### Multi-Port Configuration

#### Adding Multiple Ports Simultaneously
```bash
# FreeIPA server example ports
firewall-cmd --add-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,464/tcp,88/udp,464/udp} --permanent

# Reload to apply changes
firewall-cmd --reload

# Verify all ports added
firewall-cmd --list-ports
```

#### Removing Multiple Ports
```bash
# Change 'add' to 'remove' in previous command
firewall-cmd --remove-port={80/tcp,443/tcp,389/tcp,636/tcp,88/tcp,464/tcp,88/udp,464/udp} --permanent
firewall-cmd --reload
```

### Default Zone Management
```bash
# Check current default zone
firewall-cmd --get-default-zone
# Output: public

# Restore original zone configuration
firewall-cmd --zone=public --change-interface=enp1s0 --permanent
firewall-cmd --set-default-zone=public

# Verify restoration
firewall-cmd --get-active-zones
firewall-cmd --list-all
```

### Network Scanning with nmap
```bash
# Install nmap if needed
sudo apt install nmap          # Debian/Ubuntu
sudo dnf install nmap          # Fedora/RHEL/CentOS

# Scan with host discovery disabled
nmap -Pn 10.0.2.61
```

**Scan Results Analysis**:
- **Before Block Zone**: Quick results with open ports visible
- **After Block Zone**: 70+ seconds, 1000 ports filtered, stealth mode active

### Key Configuration Principles

#### Zone Targeting Requirements
When the active zone differs from the default:
```bash
# Must specify zone in every command
firewall-cmd --zone=block --list-all

# After setting as default, zone specification becomes optional
firewall-cmd --set-default-zone=block
firewall-cmd --list-all        # Works without zone specification
```

#### Permanent vs Runtime Changes
```bash
# Runtime only (lost on reboot)
firewall-cmd --zone=block --change-interface=enp1s0

# Permanent (survives reboots)
firewall-cmd --zone=block --change-interface=enp1s0 --permanent

# Apply permanent changes
firewall-cmd --reload
```

#### Current Session Persistence
- Existing SSH sessions continue after firewall changes
- New connection attempts are subject to updated rules
- Firewall changes affect future connections only

---

## 12.4 Lock it Down!

### Overview
This critical security module demonstrates emergency firewall lockdown procedures using firewalld's panic mode. It provides a rapid response mechanism for isolating compromised systems from network threats while maintaining the ability to restore normal operations.

### Emergency Lockdown Procedures

#### Activating Panic Mode
```bash
# Enable panic mode - immediate network isolation
firewall-cmd --panic-on

# Verify panic mode status
firewall-cmd --query-panic
# Output: yes
```

#### Network Isolation Effects
**Pre-Lockdown (Client)**:
```bash
ping 10.0.2.61          # Successful replies
ssh root@10.0.2.61      # Connection established
```

**Post-Lockdown (Client)**:
```bash
ping 10.0.2.61          # No response (cursor blinks as if host unreachable)
ssh root@10.0.2.61      # Connection timeout/failure
```

### Technical Implementation

#### Panic Mode Characteristics
- **OSI Layer**: Operates at Layer 3 (Network Layer)
- **Protocol Coverage**: All IP-based communications
- **Response Behavior**: Complete network connectivity cutoff
- **Duration**: Active until explicitly disabled

#### Comparison with Drop Zone
Both panic mode and the **drop** zone provide silent packet dropping:
```bash
# Drop zone provides similar stealth protection
firewall-cmd --set-default-zone=drop
# Silently drops packets without ICMP responses
```

### Use Cases for Panic Mode

#### Security Incident Response
```bash
# Immediate response to detected breach
firewall-cmd --panic-on

# Physical access may still be required for complete isolation
# Network cable disconnection provides Layer 1 isolation
```

#### Maintenance Windows
- Temporary complete isolation for critical updates
- Prevents external interference during sensitive operations
- Quick restoration capability when maintenance complete

### Restoration Procedures
```bash
# Disable panic mode
firewall-cmd --panic-off

# Verify restoration
firewall-cmd --query-panic
# Output: no

# Test connectivity restoration
ping 10.0.2.61          # Should receive replies again
```

### Important Considerations

#### Layer 3 vs Physical Isolation
> [!IMPORTANT]
> Panic mode provides Layer 3 network isolation only. For complete isolation:
> 1. Enable panic mode for immediate network cutoff
> 2. Physically disconnect network cables for Layer 1 isolation
> 3. Consider console/physical access restrictions

#### Operational Limitations
- Does not affect locally running services
- Cannot prevent attacks originating from localhost
- May impact legitimate administrative access
- Requires local or out-of-band management access

#### Recovery Planning
- Document panic mode activation procedures
- Ensure alternative access methods (console, IPMI, etc.)
- Test restoration procedures regularly
- Maintain physical access capabilities

---

## 12.5 Returning the System to its Original State

### Overview
The final module demonstrates proper system restoration after security testing, including disabling firewalld for lab cleanup and understanding Linux's default security posture. It emphasizes the importance of firewall usage in production environments.

### System Restoration Procedures

#### Disabling firewalld (CentOS/RHEL)
```bash
# Complete disable including boot persistence
systemctl --now disable firewalld

# Verify service status
systemctl status firewalld
# Shows: inactive (dead) and disabled
```

#### Debian/Ubuntu Considerations
```bash
# For systems where firewalld was manually installed
sudo systemctl --now disable firewalld
sudo apt remove firewalld

# Alternative: retain installation but keep disabled
sudo systemctl disable firewalld
```

### Post-Disable Security Analysis

#### Network Scanning Results
```bash
# Rapid scan completion indicates open system
nmap 10.0.2.61
# Result: 0.13 seconds scan time
# Shows only SSH (port 22) accessible
```

**Linux Default Security Posture**:
- **Closed by Default**: All ports closed unless explicitly opened
- **Service-Based Opening**: Ports open only when services require them
- **Single Open Port**: SSH (port 22) typically the only accessible service
- **Connection Refusal**: Closed ports respond with connection refused messages

### Security Implications

#### Linux Security Advantages
> [!NOTE]
> Linux's inherent security model provides:
> - No default network listeners
> - Explicit service activation required
> - Minimal attack surface out of the box
> - Strong foundation for secure configurations

#### Recommendation for Production
> [!IMPORTANT]
> Despite Linux's secure defaults, always implement firewalls:
> - Defense in depth strategy
> - Protection against zero-day vulnerabilities
> - Compliance with security standards
> - Granular access control capabilities

### Additional Learning Resources

#### Documentation Access
```bash
# Comprehensive firewalld documentation
man firewalld
man firewall-cmd

# Online resources
firewall-cmd --help
```

#### Extended Learning Opportunities
- **Take it to the Next Level**: Lab document provides advanced exercises
- **Custom Zone Creation**: Building specialized security zones
- **Rich Rules**: Complex conditional firewall rules
- **Direct Rules**: Low-level iptables rule integration
- **Service Definitions**: Creating custom service definitions

### Lab Completion Summary
- All firewalld configuration changes reversed
- System returned to pre-lab state
- Enhanced understanding of firewall importance
- Practical experience with zone-based security models

---

## Summary

### Key Takeaways

```diff
+ firewalld provides zone-based firewall management for Red Hat-based systems
+ Multiple built-in zones offer varying security levels from trusted to drop
+ Zone assignment to network interfaces enables granular security policies
+ Panic mode provides emergency network isolation for incident response
+ Permanent changes require --permanent flag and --reload to persist
+ Linux defaults to closed ports, but firewalls add defense in depth
- Avoid leaving unnecessary ports open (e.g., port 2222 from previous labs)
- Distinguish between default zone (for commands) and active zone (enforced)
- Existing SSH sessions persist through firewall changes
- Physical isolation may still be needed for complete network cutoff
```

### Quick Reference

```bash
# Essential Commands
systemctl status firewalld                    # Service status
firewall-cmd --get-active-zones              # Active zone verification
firewall-cmd --list-all                      # Complete configuration
firewall-cmd --add-port=<port>/<proto> --permanent    # Add permanent rule
firewall-cmd --reload                        # Apply permanent changes
firewall-cmd --panic-on/off                  # Emergency lockdown

# Zone Management
firewall-cmd --get-zones                     # List available zones
firewall-cmd --set-default-zone=<zone>       # Set command default
firewall-cmd --zone=<zone> --change-interface=<if> --permanent
```

### Expert Insights

#### Real-world Application
In production environments, implement zone-based security matching network segments:
- **DMZ servers**: Assign to DMZ zone with minimal required services
- **Internal servers**: Use work or internal zones with appropriate service rules
- **Workstations**: Public zone with user-friendly service allowances
- **Critical systems**: Implement panic mode integration with monitoring systems

#### Expert Path
1. **Master zone customization**: Create organization-specific security zones
2. **Rich rules implementation**: Learn conditional rules for advanced filtering
3. **Integration with SELinux**: Combine firewalld with SELinux policies
4. **Centralized management**: Deploy firewalld configurations via Ansible/Puppet
5. **Monitoring integration**: Connect firewalld logs to SIEM systems

#### Common Pitfalls
- **Zone Confusion**: Mixing default zone vs active zone concepts
- **Persistence Issues**: Forgetting `--permanent` flag for lasting changes
- **Reload Oversights**: Making permanent changes without subsequent reload
- **Over-Permissive Rules**: Adding unnecessary services/ports
- **Testing Neglect**: Not verifying rules from external client perspectives

#### Lesser-Known Facts
- Panic mode affects all network interfaces simultaneously
- Zone changes don't terminate existing TCP connections
- firewalld can manage both IPv4 and IPv6 rules simultaneously
- Custom zones can be created with specific service/port combinations
- Direct rule passthrough allows low-level iptables integration when needed

</details>