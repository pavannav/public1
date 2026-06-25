# Section 7: systemctl Basics

<details open>
<summary><b>Section 7: systemctl Basics (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [7.1 systemctl Basics](#71-systemctl-basics)
- [7.2 Reducing the Attack Surface](#72-reducing-the-attack-surface)
- [7.3 Creating a Degraded System](#73-creating-a-degraded-system)
- [7.4 Repairing a Degraded System](#74-repairing-a-degraded-system)
- [7.5 systemd States](#75-systemd-states)
- [Summary](#summary)

---

## 7.1 systemctl Basics

### Overview
The `systemctl` command is a critical Linux utility for managing system services with two primary purposes: ensuring service availability and reducing the system's attack surface. Understanding systemctl is essential for both maintaining system functionality and enhancing security posture.

### Key Concepts/Deep Dive

#### systemctl Command Categories

The `systemctl` command is organized into two main categories:

**Unit File Commands** (Green - Persistence)
- Control when services start automatically during system boot
- Commands include: `enable`, `disable`, `list-unit-files`, `re-enable`, `unmask`

**Unit Commands** (Blue - Immediate)
- Control services in real-time without persistence
- Commands include: `start`, `stop`, `restart`, `reload`, `list-units`, `kill`, `isolate`

#### Important Distinction: Persistence vs Immediate

```diff
+ Unit File Commands: Changes take effect on next reboot (persistent)
- Unit Commands: Changes take effect immediately (transient)
```

| Aspect | Unit File Commands | Unit Commands |
|--------|-------------------|---------------|
| **Purpose** | Persistence settings | Immediate control |
| **Examples** | enable, disable | start, stop, restart |
| **Effect** | Next boot | Right now |
| **Color Code** | Green | Blue |

#### Learning systemctl Commands

```bash
# View all available options
systemctl --help

# Access detailed documentation
man systemctl
```

Key commands to master:
- `list-units` - Shows currently active units
- `list-unit-files` - Shows all installed unit files and their states
- `start/stop/reload/restart` - Service control commands

---

## 7.2 Reducing the Attack Surface

### Overview
This section demonstrates practical techniques for minimizing a system's attack surface by identifying and disabling unnecessary services. The goal is to reduce potential vulnerabilities while maintaining essential functionality.

### Key Concepts/Deep Dive

#### Service Status Analysis

```bash
# Check service status (shows both unit and unit-file states)
systemctl status <service-name>
```

Service status breakdown:
- **Active/Inactive**: Current operational state (unit level)
- **Enabled/Disabled**: Boot persistence state (unit-file level)

#### Lab 14: Reducing the Attack Surface - Step by Step

##### Understanding Network Services on Debian

On Debian client systems:
- **NetworkManager**: Primary networking service
- **networking**: Legacy backup service (active but unused by default)

##### Service Control Operations

```bash
# Stop a service immediately
sudo systemctl stop networking

# Disable service from starting on boot
sudo systemctl disable networking

# Stop and disable in one command
sudo systemctl disable --now networking

# Start and enable in one command
sudo systemctl enable --now networking
```

##### Filtering Services for Review

```bash
# List all unit files
systemctl list-unit-files

# Filter for services only
systemctl list-unit-files --type service

# Filter for enabled services
systemctl list-unit-files --type service | grep enabled | less
```

##### Port Analysis

```bash
# Check listening ports and services
ss -tulnw
```

This reveals all open UDP and TCP ports, helping identify unnecessary services.

##### Service Removal Process

1. **Stop the service**: `systemctl stop <service>`
2. **Disable from boot**: `systemctl disable <service>`
3. **Remove the package**:
   - `apt remove <package>` - Remove package
   - `apt purge <package>` - Remove package and configuration files

##### Important: Permission Requirements

```bash
# Without sudo - limited information
systemctl status NetworkManager
# Warning: some journal files were not opened due to insufficient permissions

# With sudo - full logging information
sudo systemctl status NetworkManager
# Shows last 10 lines of service log
```

Press `Q` to exit status displays.

---

## 7.3 Creating a Degraded System

### Overview
This lab demonstrates how configuration errors can cause service failures and system degradation. Learning to create failures is essential for developing troubleshooting skills.

### Key Concepts/Deep Dive

#### System Health Indicators

```bash
# Check overall system state
systemctl status
```

System states:
- **Green (running)**: All services operational, no failures
- **Red (degraded)**: One or more units have failed

#### Lab 15 Part 1: Breaking the System

##### Identifying Configuration Files

SSH server configuration paths:
- `/etc/ssh/sshd_config` - Server configuration (main focus)
- `/etc/ssh/ssh_config` - Client configuration
- `/etc/ssh/` - Contains key files and moduli

##### Creating a Configuration Error

```bash
# Edit SSH configuration with sudo
sudo vim /etc/ssh/sshd_config
```

Breaking the configuration:
1. Navigate to the Port directive (line 14)
2. Remove the comment and add invalid characters
3. Change from valid port to malformed entry (e.g., `Port 22garbage`)

##### Observing Failure

```bash
# Restart service to apply broken configuration
sudo systemctl restart ssh

# Expected error output:
# Job for ssh.service failed because the control process exited with an error code
```

The system suggests troubleshooting commands:
- `systemctl status ssh.service`
- `journalctl -xeu ssh.service`

---

## 7.4 Repairing a Degraded System

### Overview
This section covers systematic troubleshooting of service failures, demonstrating how to identify root causes and restore system functionality using systemd tools.

### Key Concepts/Deep Dive

#### Initial System Assessment

```bash
# Check system state
systemctl status
# Shows: deb-client, state: degraded (red)

# List all failed services
systemctl --failed
# Shows: ssh.service - failed
```

#### Troubleshooting Methodology

##### Step 1: Service-Specific Status

```bash
# Basic status (limited information)
systemctl status ssh
# Shows: failed, exit code, exception

# Detailed status with logs
sudo systemctl status ssh
# Shows: "start request repeated too quickly"
```

##### Step 2: Journal Analysis

```bash
# View service-specific journal entries
sudo journalctl -u ssh

# Alternative syntax (as documented)
sudo journalctl -xeu ssh.service

# View last N lines
journalctl -u ssh -n 20
```

Key journal output to identify:
- **Ignore**: systemd housekeeping messages
- **Focus**: Service-specific error messages
- **Look for**: File path and line number references

Example critical log entry:
```
sshd[PID]: /etc/ssh/sshd_config: line 14: Badly formatted port number
```

##### Step 3: Configuration Repair

```bash
# Edit configuration file
sudo vim /etc/ssh/sshd_config

# Fix the issue:
# 1. Navigate to line 14 (or use :set number in vim)
# 2. Comment out or correct the port directive
# 3. Default SSH port is 22 (commented by default)

# Save and quit: :wq
```

##### Step 4: Service Restoration

```bash
# Restart the service
sudo systemctl restart ssh
# No output = success (no news is good news)

# Verify service status
systemctl status ssh
# Should show: active (running), listening on port 22

# Check overall system state
systemctl status
# Should show: running (green)
```

#### General Troubleshooting Framework

1. **Assess**: `systemctl status` → `systemctl --failed`
2. **Investigate**: `systemctl status <service>` → `journalctl -u <service>`
3. **Repair**: Fix configuration or dependency issues
4. **Restore**: `systemctl restart <service>`
5. **Verify**: Check both service and system status

---

## 7.5 systemd States

### Overview
Understanding the various states that systemd units and unit files can occupy is crucial for effective system administration and troubleshooting.

### Key Concepts/Deep Dive

#### Unit States (Blue Box - Immediate)

Units represent the current operational state of services:

| State | Description |
|-------|-------------|
| **active (running)** | Service is operational and using resources |
| **active (exited)** | Service completed successfully, not using resources |
| **inactive (dead)** | Service is stopped |
| **activating** | Service is in the process of starting |
| **deactivating** | Service is in the process of stopping |
| **failed** | Service failed to activate (configuration error, dependency issue) |
| **not-found** | Unit file doesn't exist |
| **dead** | Service is not running |

#### Unit File States (Green Box - Persistence)

Unit files determine service behavior at boot:

| State | Description |
|-------|-------------|
| **enabled** | Will start automatically on boot |
| **disabled** | Will not start on boot |
| **masked** | Completely disabled, cannot be started without unmasking |
| **static** | Unit cannot be enabled/disabled (dependency of another unit) |
| **linked** | Symlink to unit file |
| **transient** | Runtime-generated unit |
| **generated** | Auto-generated unit file |
| **bad** | Invalid unit file or configuration error |

#### Key Commands for State Management

```bash
# View unit states (immediate)
systemctl list-units

# View unit file states (persistence)
systemctl list-unit-files

# Reload all unit configurations
sudo systemctl daemon-reload

# Unmask a masked service
sudo systemctl unmask <service>
```

#### Practical State Transitions

```diff
! Example Workflow:
Client Request → Identify unnecessary services → systemctl stop <service> → systemctl disable <service> → Reduced attack surface
```

#### Working with Services in Different States

| Operation | Command | Effect |
|-----------|---------|--------|
| Immediate stop | `systemctl stop <service>` | Service stops now |
| Persistent disable | `systemctl disable <service>` | Won't start on boot |
| Combined operation | `systemctl disable --now <service>` | Stop now and disable for boot |
| Force reload config | `systemctl daemon-reload` | Reload all configurations |

---

## Summary

### Key Takeaways

```diff
+ systemctl manages both immediate service control and boot-time persistence
+ Use list-units for current state, list-unit-files for persistence settings
+ Reducing attack surface involves disabling unnecessary services
+ System degradation indicates failed units requiring troubleshooting
+ Journal logs provide detailed error information for diagnosis
+ Understanding systemd states is essential for effective administration
```

### Quick Reference

| Task | Command |
|------|---------|
| Check system health | `systemctl status` |
| List active units | `systemctl list-units` |
| List all unit files | `systemctl list-unit-files` |
| Show failed services | `systemctl --failed` |
| Start/stop service | `systemctl [start\|stop] <service>` |
| Enable/disable on boot | `systemctl [enable\|disable] <service>` |
| Stop and disable | `systemctl disable --now <service>` |
| Restart service | `systemctl restart <service>` |
| Reload configuration | `systemctl reload <service>` |
| Reload all configs | `systemctl daemon-reload` |
| View service logs | `journalctl -u <service>` |
| Check listening ports | `ss -tulnw` |

### Expert Insight

#### Real-world Application
In production environments, regularly audit running services using `systemctl list-unit-files --type service | grep enabled` to identify and disable unnecessary services. This is particularly important after system migrations or application deployments where default services may no longer be needed.

#### Expert Path
- Master systemd unit file syntax and create custom service units
- Understand service dependencies and ordering with `systemctl list-dependencies`
- Implement service monitoring with `systemd` watchdog functionality
- Learn to analyze boot performance using `systemd-analyze`

#### Common Pitfalls
- **Forgetting sudo**: Many systemctl operations require elevated privileges, especially for viewing logs
- **Confusing list-units vs list-unit-files**: Remember units = immediate, unit-files = persistence
- **Not verifying changes**: Always check status after modifications
- **Ignoring masked services**: These cannot be started without explicit unmasking

#### Lesser-Known Facts
- `systemctl status` on the entire system shows more than just services - it includes mounts, sockets, and paths
- The `systemctl list-unit-files` shows installed units even if they're not loaded
- Some services have aliases (ssh vs sshd) - both point to the same unit
- Masking a service creates a symlink to `/dev/null`, preventing any start operation

</details>