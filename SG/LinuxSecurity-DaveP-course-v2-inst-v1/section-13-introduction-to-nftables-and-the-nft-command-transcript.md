# Section 13: Introduction to nftables and the nft Command

<details open>
<summary><b>Section 13: Introduction to nftables and the nft Command (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [13.1 Introduction to nftables and the nft Command](#131-introduction-to-nftables-and-the-nft-command)
- [13.2 nftables Setup](#132-nftables-setup)
- [13.3 Tables, Chains, Rules](#133-tables-chains-rules)
- [13.4 Building the nftables Configuration Part I](#134-building-the-nftables-configuration-part-i)
- [13.5 Building the nftables Configuration Part II](#135-building-the-nftables-configuration-part-ii)
- [13.7 Translating iptables to nftables](#137-translating-iptables-to-nftables)
- [Summary](#summary)

---

## 13.1 Introduction to nftables and the nft Command

### Overview
This module introduces nftables as the modern Linux firewall framework that operates directly with the NetFilter kernel subsystem, providing packet filtering and NAT capabilities. Unlike front-end abstractions like FirewallD or UFW, nftables with the nft command offers direct backend access to kernel-level filtering for maximum control and performance.

### Key Concepts/Deep Dive

#### NetFilter and Linux Kernel Architecture
- **NetFilter**: A kernel-level networking framework providing:
  - Packet filtering
  - Network Address Translation (NAT)
  - Port redirection
  - Implemented through a set of hooks that alter packet processing

- **Legacy ip_tables System**:
  - Includes four kernel modules:
    - `ip_tables`: IPv4 packet filtering
    - `ip6_tables`: IPv6 packet filtering
    - `arp_tables`: ARP filtering
    - `ebtables`: Ethernet bridging tables
  - Administered by userspace tools like `iptables`

- **Modern nftables**:
  - First released in 2014
  - Represents the future of Linux firewalling
  - Administered by the `nft` userspace tool
  - More efficient and flexible than ip_tables

#### Tool Classification
```bash
# Backend Tools (Direct kernel interaction)
nft        # For nftables
iptables   # For legacy ip_tables

# Frontend/Abstraction Tools
firewalld  # Red Hat/CentOS abstraction
ufw        # Ubuntu abstraction
```

> [!IMPORTANT]
> For proper firewall security control, always use nftables with the nft tool rather than frontend abstractions.

---

## 13.2 nftables Setup

### Overview
This module demonstrates the installation and initial configuration of nftables on Debian-based systems, establishing the foundation for building a secure firewall configuration through proper service management.

### Key Concepts/Deep Dive

#### Supported Distributions
- **Debian 12 or higher**: Pre-installed
- **Ubuntu 22.04 or higher**: Pre-installed
- **CentOS 9 or higher**: Pre-installed
- For older distributions, manual installation required

#### Installation and Service Management

```bash
# Install nftables (if not pre-installed)
apt install nftables

# Check service status
systemctl status nftables

# Enable and start the service
systemctl --now enable nftables

# Verify the service is active
systemctl status nftables
```

#### Initial Verification Process

```bash
# Expected output when disabled (default on many systems)
● nftables.service - nftables
     Loaded: loaded (/lib/systemd/system/nftables.service; disabled)
     Active: inactive (dead)

# After enabling
● nftables.service - nftables
     Loaded: loaded (/lib/systemd/system/nftables.service; enabled)
     Active: active (exited)
```

> [!NOTE]
> Unlike UFW or FirewallD, enabling nftables service alone does not activate any firewall rules. Configuration must be explicitly created.

#### Troubleshooting Connectivity Issues

```bash
# Check for conflicting firewalls
ufw status                    # Check UFW
systemctl status firewalld    # Check firewalld

# Disable firewalld if active
systemctl --now disable firewalld
```

#### Testing Methodology
- Use a separate client system for testing
- Verify both inbound (ping, SSH) and outbound connectivity
- Document baseline connectivity before applying rules

```bash
# From client system
ping 10.0.2.51
ssh user@10.0.2.51
```

---

## 13.3 Tables, Chains, Rules

### Overview
This module explains the fundamental nftables architecture consisting of tables containing chains which contain rules, demonstrating how to view and understand the hierarchical structure using the nft command-line interface.

### Key Concepts/Deep Dive

#### Hierarchical Structure
```
Tables (Network Protocol Families)
├── Chains (Traffic Direction/Type)
│   ├── Rules (Match Conditions + Actions)
│   └── Default Policy
```

#### Viewing Current Configuration

```bash
# Display complete ruleset
nft list ruleset

# Example output structure
table inet filter {
    chain input {
        type filter hook input priority 0; policy accept;
    }
    chain output {
        type filter hook output priority 0; policy accept;
    }
    chain forward {
        type filter hook forward priority 0; policy accept;
    }
}
```

#### Key Components Explained

1. **Tables**:
   - Container for chains
   - Named by protocol family (e.g., `inet filter`)
   - Can have multiple tables
   - Most secure table takes precedence

2. **Chains**:
   - Container for rules
   - Defined by hook type (input, output, forward)
   - Include priority and policy settings
   - Can have multiple chains per table

3. **Rules**:
   - Individual filtering decisions
   - Contained within chains
   - Process packets based on criteria
   - Actions include accept, drop, reject

#### Working with nft Command

```bash
# Interactive shell (recommended for configuration)
nft -i

# Single commands
nft list ruleset
nft add table inet my_table
nft add chain inet my_table my_chain { type filter hook input priority 0 \; policy drop \; }
```

> [!NOTE]
> When using the interactive shell (`nft -i`), omit the `nft` prefix from commands. The shell maintains command history accessible via up/down arrows.

---

## 13.4 Building the nftables Configuration Part I

### Overview
This module demonstrates creating a secure nftables configuration by building tables and chains with drop policies, then selectively allowing specific services like SSH through targeted rules.

### Key Concepts/Deep Dive

#### Creating Tables

```bash
# Enter nft interactive shell
nft -i

# Create a new table
add table inet ports_table

# Verify creation
list ruleset
```

#### Creating Chains with Policies

```bash
# Add input chain with drop policy
add chain inet ports_table input { type filter hook input priority 0 ; policy drop ; }

# Priority 0 = highest precedence
# Policy drop = silent packet dropping
```

#### Chain Configuration Components

```bash
# Chain syntax breakdown
add chain [table_name] [chain_name] {
    type filter hook [direction] priority [0-32767] ;
    policy [accept|drop] ;
}
```

#### Testing the Drop Policy

```bash
# From client - all connectivity should fail
ping 10.0.2.51        # No response (dropped silently)
ssh user@10.0.2.51    # Connection timeout
```

#### Adding Selective Rules

```bash
# Allow SSH (TCP port 22)
add rule inet ports_table input tcp dport 22 accept

# Verify rules
list ruleset
```

#### Testing Selective Access

```bash
# SSH should now work
ssh user@debserver

# Ping still blocked
ping 10.0.2.51    # No response
```

> [!IMPORTANT]
> Even when named "input", the chain affects both directions when using `hook input` with `priority 0` as the primary filtering point.

---

## 13.5 Building the nftables Configuration Part II

### Overview
This module extends the firewall configuration to allow ICMP for diagnostics and DNS resolution, demonstrates rule management using handles, and explains persistence concepts.

### Key Concepts/Deep Dive

#### Adding ICMP Rules

```bash
# Allow ICMP echo requests (pings)
add rule inet ports_table input icmp type { echo-request } accept

# Allow ICMP echo replies
add rule inet ports_table input icmp type { echo-reply } accept
```

#### Adding DNS Rules

```bash
# Allow DNS over TCP (source port 53)
add rule inet ports_table input tcp sport 53 accept

# Allow DNS over UDP (source port 53)
add rule inet ports_table input udp sport 53 accept
```

#### Complete Rule Verification

```bash
nft list ruleset
# Shows all rules in order of processing
```

#### Rule Management with Handles

```bash
# View handles
nft -a list table inet ports_table

# Example output showing handles
table inet ports_table { # handle 2
    chain input { # handle 1
        tcp dport 22 accept # handle 3
        icmp type { echo-request } accept # handle 4
        icmp type { echo-reply } accept # handle 5
        tcp sport 53 accept # handle 6
        udp sport 53 accept # handle 7
    }
}
```

#### Deleting Rules

```bash
# Delete specific rule by handle
nft delete rule inet ports_table input handle 6

# Verify deletion
nft list ruleset
```

#### Chain and Table Management

```bash
# Delete entire chain (removes all rules within)
nft delete chain inet ports_table handle 1

# Flush all rules from a table (keeps table and chains)
nft flush table inet ports_table

# Flush entire ruleset (WARNING: removes everything)
nft flush ruleset
```

#### Testing DNS Functionality

```bash
# Before DNS rules: Name resolution fails
ping example.com    # Temporary failure in name resolution

# DNS by IP still works
ping 93.184.216.34  # Successful

# After DNS rules: Name resolution works
ping example.com    # Successful with name resolution
```

> [!WARNING]
> Be extremely careful with `nft flush ruleset` and `nft flush table` commands as they can remove all firewall configuration.

---

## 13.7 Translating iptables to nftables

### Overview
This module covers the iptables-to-nftables translation tool, enabling migration from legacy iptables configurations while understanding the differences and required modifications for successful nftables deployment.

### Key Concepts/Deep Dive

#### iptables-translate Tool

```bash
# Install iptables for translation demonstration
apt install iptables -y

# Verify translation tool
iptables-translate --version    # Version 1.8.9
```

#### iptables Command Structure

```bash
# Complex iptables syntax example
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT
```

#### Translation Process

```bash
# Translate iptables to nftables
iptables-translate -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j ACCEPT

# Output (requires modification)
nft add rule ip filter input tcp dport 22 ct state new counter accept
```

#### Required Modifications

```bash
# Original translation output
nft add rule ip filter input tcp dport 22 ct state new counter accept

# Modified for nftables (correct syntax)
nft add rule inet filter input tcp dport 22 ctstate new counter accept
```

**Changes Required:**
1. Change `ip filter` to `inet filter` (table name)
2. Remove case-sensitive requirements
3. Adjust `ct state` to `ctstate`
4. Verify protocol family compatibility

#### Verification and Testing

```bash
# Apply translated rule
nft add rule inet filter input tcp dport 22 ctstate new counter accept

# Verify in ruleset
nft list ruleset

# Test connectivity
ssh user@server
```

#### System Cleanup

```bash
# Remove test configurations
nft flush ruleset

# Disable nftables
systemctl --now disable nftables

# Remove iptables completely
apt purge iptables -y

# Reboot to verify clean state
reboot
```

> [!NOTE]
> The translation tool provides a starting point but requires manual adjustments for full nftables compatibility. Not all iptables features translate perfectly.

---

## Summary

### Key Takeaways

```diff
+ nftables is the modern Linux firewall framework replacing legacy iptables
+ Direct kernel interaction through nft command provides maximum control
+ Tables contain chains, chains contain rules - hierarchical structure
+ Priority 0 with drop policy provides highest precedence security
+ Rules processed in order - more specific rules before general policies
+ Handle numbers enable precise rule management and deletion
+ DNS requires both TCP and UDP port 53 for complete functionality
+ Translation tools assist migration but require manual adjustments
- Unlike UFW/FirewallD, nftables requires explicit configuration
- Silent dropping (drop policy) vs active rejection affects visibility
```

### Quick Reference

```bash
# Essential nftables Commands
nft -i                                    # Enter interactive shell
nft list ruleset                          # View complete configuration
nft add table inet name                   # Create table
nft add chain inet name chain { type filter hook input priority 0 ; policy drop ; }
nft add rule inet name chain tcp dport 22 accept
nft delete rule inet name chain handle N  # Delete specific rule
nft flush ruleset                         # Remove all rules (DANGEROUS)

# Service Management
systemctl --now enable nftables          # Enable and start
systemctl status nftables                 # Check status
```

### Expert Insight

#### Real-world Application
- Production firewalls require persistence through configuration files in `/etc/nftables.conf`
- Always maintain out-of-band access methods when configuring remote firewalls
- Use separate management interfaces or IPMI/iLO for emergency access
- Regular backup of working configurations essential before modifications

#### Expert Path
- Master nftables sets for efficient IP/port grouping
- Learn about nftables maps for dynamic rule sets
- Understand conntrack integration for stateful filtering
- Explore nftables expressions for complex matching
- Study rate limiting and connection tracking optimization

#### Common Pitfalls
- Forgetting that nftables requires explicit configuration after installation
- Not accounting for both TCP and UDP when configuring DNS rules
- Using translate output without verifying syntax compatibility
- Setting overly restrictive policies without local console access
- Neglecting to save configurations for persistence across reboots

#### Lesser-Known Facts
- nftables can process rules faster than iptables due to optimized kernel structures
- The same chain name can exist in multiple tables with different purposes
- Priority values determine processing order when multiple chains hook the same point
- nftables supports JSON output format for programmatic manipulation
- Legacy iptables rules can coexist with nftables on the same system (with careful configuration)

</details>