# Section 9: AppArmor Basics

<details open>
<summary><b>Section 9: AppArmor Basics (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [9.1 AppArmor Basics](#91-apparmor-basics)
- [9.2 AppArmor Profiles](#92-apparmor-profiles)
- [9.3 AppArmor and Apache Example](#93-apparmor-and-apache-example)
- [9.4 SELinux Basics](#94-selinux-basics)
- [Summary](#summary)

---

## 9.1 AppArmor Basics

### Overview
AppArmor is a Linux Security Module (LSM) that provides mandatory access control (MAC) primarily on Debian and Ubuntu systems. Unlike discretionary access control where users control permissions, MAC enforces system-defined security policies that protect applications from unauthorized access and misuse.

### Key Concepts

#### What is AppArmor?
- **Linux Security Module** designed for Debian/Ubuntu systems
- Implements **Mandatory Access Control (MAC)** at the kernel level
- Protects applications by defining access profiles with specific rules
- Works as a path-based access control system
- Default active and enabled on Debian/Ubuntu systems

#### Checking AppArmor Status

```bash
# Check if AppArmor packages are installed
apt list | grep apparmor

# Check AppArmor policy status
apt policy apparmor

# Verify AppArmor service status
systemctl status apparmor

# Check if AppArmor is enabled (returns "Yes")
aa-enabled

# Display comprehensive AppArmor status
aa-status
```

#### Understanding aa-status Output
```
apparmor module is loaded.
24 profiles are loaded.
22 profiles are in enforce mode.
2 profiles are in complain mode.
```

**Profile Modes:**
- **Enforce Mode**: Actively enforces security rules, blocks violations
- **Complain Mode**: Logs violations but doesn't block them (useful for testing)

#### Managing AppArmor Service

```bash
# Disable AppArmor (requires reboot)
systemctl --now disable apparmor

# Enable AppArmor
systemctl --now enable apparmor

# Temporary teardown (unloads profiles without disabling service)
aa-teardown

# Restart service to reload all profiles
systemctl restart apparmor
```

> [!IMPORTANT]
> After disabling AppArmor, profiles will not be active until the service is re-enabled and potentially rebooted.

### Lab Demonstration: Basic AppArmor Operations

1. **Verify Installation**: Check AppArmor packages and service status
2. **Check Status**: Use `aa-status` to view loaded profiles and their modes
3. **Disable AppArmor**: Stop and disable the service
4. **Verify Disabled State**: Confirm no profiles are loaded
5. **Re-enable AppArmor**: Restart the service and verify profiles return

---

## 9.2 AppArmor Profiles

### Overview
AppArmor profiles define the security boundaries for specific applications by specifying which files, capabilities, and network access the application can use. This section covers creating, analyzing, modifying, and removing AppArmor profiles.

### Key Concepts

#### Profile Creation Process

1. **Install Required Tools**
```bash
apt install apparmor-utils auditd
```

2. **Create Test Application**
```bash
# Copy existing binary to create new application
cp /usr/bin/man /usr/local/bin/human

# Test the new application
human ls
```

3. **Generate Profile with aa-genprof**
```bash
aa-genprof /usr/local/bin/human
```

#### Profile Generation Workflow
- System monitors application behavior
- User responds to logged events with decisions:
  - **I** - Inherit profile from parent
  - **A** - Allow access
  - **D** - Deny access
  - **G** - Glob (use wildcards)
  - **O** - Owner permissions
  - **S** - Save profile

#### Profile Storage and Naming
- Location: `/etc/apparmor.d/`
- Naming convention: Path separators replaced with dots
  - `/usr/local/bin/human` → `usr.local.bin.human`
  - `/usr/bin/man` → `usr.bin.man`

#### Profile Modes Management

```bash
# Set profile to complain mode (for testing)
aa-complain /etc/apparmor.d/usr.local.bin.human

# Set profile to enforce mode (production)
aa-enforce /etc/apparmor.d/usr.local.bin.human

# Disable a profile
aa-disable /etc/apparmor.d/usr.local.bin.human

# Remove profile completely
rm /etc/apparmor.d/usr.local.bin.human
```

#### Profile Structure Example
```yaml
# /etc/apparmor.d/usr.local.bin.human
/usr/local/bin/human {
  #include <abstractions/base>
  #include <abstractions/nameservice>

  capability dac_override,
  capability setuid,

  /etc/manpath.config r,
  /usr/bin/man rix,
  /usr/local/bin/human mr,
  /var/cache/man/** rw,
}
```

### Profile Analysis Commands

```bash
# View all profiles and their modes
aa-status | less

# View specific profile file
cat /etc/apparmor.d/usr.local.bin.human

# Check audit logs for AppArmor events
journalctl -u apparmor
```

> [!NOTE]
> Always test profiles in complain mode before enforcing them in production.

---

## 9.3 AppArmor and Apache Example

### Overview
This section demonstrates how to secure a real-world application (Apache web server) using AppArmor. It covers installing pre-built profiles, enabling protection modules, and understanding how AppArmor defends against common web attacks.

### Key Concepts

#### Pre-built Profiles
- Available through APT package manager
- Tested and maintained by community
- Can be found on Apache website and security repositories
- Provide immediate protection without custom creation

#### Securing Apache with AppArmor

1. **Install Apache and AppArmor Module**
```bash
# Install Apache web server
apt install apache2

# Install AppArmor Apache module
apt install libapache2-mod-apparmor

# Restart Apache to load module
systemctl restart apache2
```

2. **Enable Apache Profile**
```bash
# Set Apache profile to enforce mode
aa-enforce /etc/apparmor.d/usr.sbin.apache2
```

3. **Verify Profile Activation**
```bash
aa-status | grep apache
# Output shows:
# 3 profiles in enforce mode:
#   usr.sbin.apache2
#   usr.sbin.apache2//default-uri
#   usr.sbin.apache2//HANDLING-UNT
```

#### Apache Profile Features
- **Input Validation**: Handles untrusted inputs securely
- **Capability Restrictions**: Limits system capabilities
- **Path Restrictions**: Controls file system access
- **Attack Prevention**:
  - Reduces injection attacks
  - Prevents XSS (Cross-Site Scripting)
  - Limits lateral movement from compromised applications

#### Profile Location and Analysis
```bash
# View Apache profile
vim /etc/apparmor.d/usr.sbin.apache2

# Key sections include:
# - Required capabilities
# - Allowed file paths and permissions
# - Network access rules
# - Untrusted input handling
```

### Cleanup Process

```bash
# Disable profile
aa-disable /etc/apparmor.d/usr.sbin.apache2

# Remove profile file
rm /etc/apparmor.d/usr.sbin.apache2

# Purge AppArmor Apache module
apt purge libapache2-mod-apparmor

# Remove Apache
apt remove apache2
```

> [!IMPORTANT]
> Web servers are prime attack targets - always implement AppArmor protection for production web servers.

---

## 9.4 SELinux Basics

### Overview
Security-Enhanced Linux (SELinux) is the mandatory access control system used on Fedora-based distributions including CentOS, RHEL, and Fedora. Unlike AppArmor which is path-based, SELinux uses labels and contexts for fine-grained access control.

### Key Concepts

#### SELinux Fundamentals
- **Kernel-level security architecture**
- Works with file labels and security contexts
- Default mode: **Enforcing**
- Three modes available:
  - **Enforcing**: Actively enforces policies (recommended)
  - **Permissive**: Logs violations but doesn't block
  - **Disabled**: Completely disabled (not recommended)

#### Basic SELinux Commands

```bash
# Check SELinux status
sestatus

# Check enforcement mode
getenforce

# Output example:
# SELinux status: enabled
# Current mode: enforcing
# Policy from config file: targeted
```

#### Managing SELinux Modes

```bash
# Set to permissive mode (temporary)
setenforce 0
# or
setenforce permissive

# Set to enforcing mode
setenforce 1
# or
setenforce enforcing

# Verify current mode
getenforce
```

#### Permanent SELinux Configuration
```bash
# Edit SELinux configuration
vim /etc/sysconfig/selinux

# Possible values:
SELINUX=enforcing   # Default, recommended
SELINUX=permissive  # For testing
SELINUX=disabled    # Not recommended
```

> [!CAUTION]
> Disabling SELinux requires a reboot and may break system functionality. Always test on isolated systems first.

### Managing SSH Port Changes with SELinux

#### Step-by-Step Process

1. **Modify SSH Configuration**
```bash
vim /etc/ssh/sshd_config
# Change from: #Port 22
# To: Port 2222
```

2. **Restart SSH (Will Fail Initially)**
```bash
systemctl restart sshd
# Error: Failed to start due to SELinux policy
```

3. **Notify SELinux of Port Change**
```bash
semanage port -a -t ssh_port_t -p tcp 2222
```

4. **Restart SSH Service**
```bash
systemctl restart sshd
# Success - service starts properly
```

5. **Configure Firewall**
```bash
# Add new port to firewall
firewall-cmd --add-port=2222/tcp --permanent

# Reload firewall
firewall-cmd --reload

# Verify port is open
firewall-cmd --list-ports
```

6. **Connect Using New Port**
```bash
ssh -p 2222 user@server-ip
```

### SELinux Port Management

```bash
# List all SSH ports SELinux knows about
semanage port -l | grep ssh

# Delete a port assignment
semanage port -d -t ssh_port_t -p tcp 2222

# Add network port with specific type
semanage port -a -t http_port_t -p tcp 8080
```

### Key Differences: AppArmor vs SELinux

| Feature | AppArmor | SELinux |
|---------|----------|---------|
| **Distribution** | Debian/Ubuntu | Fedora/CentOS/RHEL |
| **Access Control** | Path-based | Label-based |
| **Complexity** | Simpler | More complex |
| **Default Mode** | Enforce | Enforcing |
| **Profile Format** | Text files | Binary policies |

---

## Summary

### Key Takeaways
```diff
+ AppArmor provides mandatory access control for Debian/Ubuntu systems
+ Profiles define security boundaries for applications
+ Always test profiles in complain mode before enforcing
+ Use aa-status to monitor profile status and modes
+ Pre-built profiles are available for common applications like Apache
+ SELinux serves the same purpose on Fedora-based systems
+ Port changes on SELinux systems require semanage commands
+ Both systems help prevent application compromise and lateral movement
```

### Quick Reference

```bash
# AppArmor Commands
aa-status                    # View AppArmor status
aa-enabled                   # Check if AppArmor is enabled
aa-enforce <profile>         # Set profile to enforce mode
aa-complain <profile>        # Set profile to complain mode
aa-disable <profile>         # Disable a profile
aa-genprof <binary>          # Generate new profile
aa-teardown                  # Temporarily unload profiles

# SELinux Commands
sestatus                     # Check SELinux status
getenforce                   # Check enforcement mode
setenforce [0|1]             # Set mode (0=permissive, 1=enforcing)
semanage port -a -t <type> -p tcp <port>  # Add port to SELinux
```

### Expert Insight

#### Real-world Application
- **Production Deployment**: Always run AppArmor/SELinux in enforcing mode on production servers
- **Container Security**: Both systems integrate with container runtimes for additional isolation
- **Compliance**: Required for many security frameworks and regulatory requirements
- **Zero Trust**: Implements least-privilege access at the application level

#### Expert Path
1. Master creating custom profiles for your specific applications
2. Learn to analyze audit logs for security events
3. Understand policy development and tuning
4. Integrate with CI/CD pipelines for automated security testing
5. Explore advanced features like hats and abstractions

#### Common Pitfalls
- ❌ Not testing profiles before enforcing them
- ❌ Forgetting to notify SELinux about configuration changes
- ❌ Disabling security modules instead of troubleshooting
- ❌ Running in permissive/complain mode permanently
- ❌ Not opening firewall ports after changing service ports

#### Lesser-Known Facts
- 💡 Docker containers may continue running their own AppArmor profiles even when system AppArmor is disabled
- 💡 SELinux can protect network ports, not just files
- 💡 AppArmor profiles can include other profiles using "include" statements
- 💡 Both systems can generate detailed audit reports for compliance

</details>