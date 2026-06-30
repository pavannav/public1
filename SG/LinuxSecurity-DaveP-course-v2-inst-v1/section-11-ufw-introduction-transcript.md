# Section 11: UFW Introduction

## Table of Contents

- [11.1 UFW Introduction](#111-ufw-introduction)
- [11.2 Setting up UFW](#112-setting-up-ufw)
- [11.3 Configuring UFW](#113-configuring-ufw)
- [Summary](#summary)

---

<details open>
<summary><b>Section 11: UFW Introduction (KK-CS45-script-v2-Inst-v1)</b></summary>

## 11.1 UFW Introduction

### Overview

The Uncomplicated Firewall (UFW) is a user-friendly front-end firewall utility developed by Canonical that interfaces with iptables and/or nftables. Designed primarily for Ubuntu and Debian systems (not RHEL derivatives), UFW provides simple commands to manage complex firewall rules while implementing secure default policies that deny all incoming connections by default.

### Key Concepts/Deep Dive

#### What is UFW?

**UFW (Uncomplicated Firewall)** is:
- A front-end utility for managing iptables/nftables
- Developed and maintained by Canonical (Ubuntu's parent company)
- Optimized for Ubuntu and Debian distributions
- Designed to simplify complex firewall management
- Implements an intuitive command syntax

> [!NOTE]
> While designed for Ubuntu/Debian, UFW can work on other distributions but may require additional configuration.

#### Basic UFW Commands

| Command | Description |
|---------|-------------|
| `ufw status` | Shows whether UFW is active or inactive |
| `ufw enable` | Starts and enables the firewall |
| `ufw show added` | Lists all UFW rules |
| `ufw reset` | Disables UFW and deletes all rules |
| `ufw --help` | Displays help information |
| `man ufw` | Shows the manual page |

> [!CAUTION]
> **Warning**: The `ufw reset` command will disable UFW and delete ALL rules. Use with extreme caution.

#### Default Global Rules

UFW implements secure defaults:

```diff
+ Implicit Deny (Default): Denies all incoming connections
+ Allow Outbound (Default): Allows all outgoing connections
```

These defaults represent the principle of least privilege — nothing gets in unless explicitly allowed, but systems can still communicate outbound for updates and services.

#### Individual Rule Structure

Basic rule syntax:
```bash
ufw allow 22/tcp
```

This allows TCP traffic on port 22 (SSH) through the firewall.

---

## 11.2 Setting up UFW

### Overview

Setting up UFW involves verifying installation, enabling the service, activating the firewall, and testing its effectiveness using port scanning tools like nmap to confirm the implicit deny policy is working correctly.

### Key Concepts/Deep Dive

#### Installation Verification

On Ubuntu systems, UFW is typically pre-installed:

```bash
# Check if UFW is installed
ufw

# Expected output if installed but no arguments provided:
# "error: not enough arguments"

# Install if needed (Debian or if missing on Ubuntu)
sudo apt install ufw
```

#### Service Management

Enable and verify the UFW service:

```bash
# Check service status
systemctl status ufw

# If not active and enabled:
sudo systemctl --now enable ufw

# Expected status: active and enabled
```

#### Firewall Activation

Enable the firewall itself:

```bash
sudo ufw enable

# Expected output:
# "Firewall is active and enabled on system startup"
```

#### Testing with Nmap

Verify firewall effectiveness using port scanning:

```bash
# From a remote client, install nmap
sudo apt install nmap

# Scan the target server
nmap 10.0.2.53

# For hosts blocking ping, use:
nmap -Pn 10.0.2.53
```

**Expected Results**:
- Host appears up but all 1,000 scanned ports are "filtered"
- Indicates UFW is successfully dropping inbound connections
- No response from the target (typical of drop policy)

#### UFW Configuration Files

**Primary configuration file**: `/etc/default/ufw`

Key settings:
```bash
DEFAULT_INPUT_POLICY="DROP"
DEFAULT_OUTPUT_POLICY="ACCEPT"
DEFAULT_FORWARD_POLICY="DROP"
```

**Rules files location**: `/etc/ufw/`
- `user.rules` - IPv4 rules based on iptables specification
- `user6.rules` - IPv6 rules

---

## 11.3 Configuring UFW

### Overview

UFW configuration involves creating inbound allow/deny rules using simple commands, managing rules by number, selectively enabling protocols, and understanding how to reset or disable the firewall when needed.

### Key Concepts/Deep Dive

#### Creating Inbound Allow Rules

Allow SSH access by service name or port:

```bash
# By service name
sudo ufw allow ssh

# By port number (recommended for specificity)
sudo ufw allow 22/tcp

# Rule confirmation
sudo ufw show added
# Output: ufw allow 22/tcp
```

#### Testing Connectivity

Verify rule effectiveness:

```bash
# SSH connection test from client
ssh user@10.0.2.53

# Netcat port verification
nc -v 10.0.2.53 22
# Expected: Shows "open" and "SSH" service

# Test blocked port (should hang/fail)
nc -v 10.0.2.53 80
```

#### Creating Deny Rules

Explicitly deny access:

```bash
sudo ufw deny ssh

# Verify status
sudo ufw status
# Shows: SSH (port 22) being denied for both IPv4 and IPv6
```

#### Managing Rules by Number

View numbered rules for precise management:

```bash
sudo ufw status numbered

# Example output:
# [1] Deny to any port 22 (IPv4)
# [2] Deny to any port 22 (IPv6)
```

Delete specific rules:

```bash
sudo ufw delete 1
# Deletes rule number 1
# "Deleting: deny 22"
# "Rule deleted"
```

#### Protocol-Specific Rules

Create rules for specific IP versions:

```bash
# Allow IPv4 only (listen on all IPv4 networks)
sudo ufw allow proto tcp from 0.0.0.0/0 to any port 22

# Status shows:
# [1] 22/tcp ALLOW IN Anywhere (IPv4)
# [2] 22/tcp DENY IN Anywhere (IPv6)
```

#### Disabling IPv6 Globally

Edit configuration to disable IPv6:

```bash
sudo vim /etc/default/ufw

# Change this line:
IPV6=yes
# To:
IPV6=no

# Reload UFW
sudo ufw reload

# Result: All IPv6 rules are automatically removed
```

#### Complete Firewall Reset

Disable UFW and remove all rules:

```bash
# Reset firewall (will prompt for confirmation)
sudo ufw reset
# Type "yes" to confirm

# Disable the service
sudo systemctl --now disable ufw
```

#### Verification After Disable

```bash
# Quick nmap scan shows immediate results
nmap 10.0.2.53
# Shows "closed" ports instead of "filtered"
# Port 22 (SSH) appears open due to OpenSSH server running
```

### Lab Demonstration Summary

**Complete workflow demonstrated**:
1. Install and verify UFW service
2. Enable firewall with implicit deny
3. Test blocking with nmap
4. Create allow rule for SSH (port 22/tcp)
5. Verify connectivity with SSH and netcat
6. Create deny rule and test blocking
7. Delete rules using numbers
8. Create protocol-specific rules
9. Disable IPv6 globally
10. Reset firewall and disable service

---

## Summary

### Key Takeaways

```diff
+ UFW provides simple firewall management for Ubuntu/Debian systems
+ Default policy denies all inbound, allows all outbound connections
+ Rules can be created by service name or port/protocol specification
+ Use "ufw status numbered" to manage rules precisely by ID
+ Protocol-specific rules allow fine-grained IPv4/IPv6 control
+ Always test firewall rules from remote systems
- Never use "ufw reset" without understanding it deletes ALL rules
- Port scanning (nmap) is essential for verifying firewall effectiveness
```

### Quick Reference

| Action | Command |
|--------|---------|
| Check status | `sudo ufw status` |
| Enable firewall | `sudo ufw enable` |
| Allow port | `sudo ufw allow 22/tcp` |
| Deny port | `sudo ufw deny 22/tcp` |
| Delete rule | `sudo ufw delete [number]` |
| View numbered rules | `sudo ufw status numbered` |
| Show added rules | `sudo ufw show added` |
| Reload after config | `sudo ufw reload` |
| Reset all | `sudo ufw reset` |
| Get help | `sudo ufw --help` or `man ufw` |

### Expert Insight

**Real-world Application**:
- Ideal for securing cloud instances and VPS deployments
- Essential for hardening development servers and workstations
- Simplifies compliance requirements for basic network security
- Commonly used in CI/CD pipelines for controlled access

**Expert Path**:
- Master complex rule syntax with source/destination specifications
- Learn to create application profiles in `/etc/ufw/applications.d/`
- Understand routing and forwarding configurations
- Practice with logging and rule auditing capabilities
- Explore integration with fail2ban for dynamic blocking

**Common Pitfalls**:
- Forgetting to allow SSH before enabling UFW (lockout risk)
- Using service names instead of ports (can be ambiguous)
- Not testing rules from remote systems
- Confusing INPUT vs OUTPUT policies
- Overlooking IPv6 rules when only configuring IPv4

**Lesser-Known Facts**:
- UFW automatically handles both IPv4 and IPv6 by default
- Rules are stored in human-readable format in `/etc/ufw/user.rules`
- The "uncomplicated" name refers to simplified management, not reduced security
- Default policies are actually DROP (not REJECT), providing stealth benefits

</details>