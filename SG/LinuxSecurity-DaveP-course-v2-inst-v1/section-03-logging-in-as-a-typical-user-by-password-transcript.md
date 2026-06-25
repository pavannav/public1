# Section 3: Logging In as a Typical User by Password

<details open>
<summary><b>Section 3: Logging In as a Typical User by Password (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

1. [3.1 Logging in as a Typical User by Password](#31-logging-in-as-a-typical-user-by-password)
2. [3.2 Logging in as an Enterprise User](#32-logging-in-as-an-enterprise-user)
3. [3.3 Locking the System](#33-locking-the-system)
4. [3.4 SSH Basics](#34-ssh-basics)
5. [3.5 SSH and Linux in the Cloud](#35-ssh-and-linux-in-the-cloud)
6. [Summary](#summary)

---

## 3.1 Logging in as a Typical User by Password

### Overview
This module covers the complete process of logging into Linux systems both through the GUI (desktop environment) and console (text-based) interfaces. It demonstrates authentication methods, session management, and system customization options available during the login process.

### Key Concepts

#### GUI Login Process
- **Boot and Login Flow**:
  - System boots through GRUB menu (covered later in course)
  - Login screen displays available user accounts
  - Users can select from listed accounts or choose "Not listed" for manual entry
  - Password entry includes security sprocket for desktop selection

- **Desktop Environment Options**:
  - GNOME is the default desktop when installing Debian
  - Available GNOME variants:
    - **GNOME Wayland**: Latest version (default for Debian)
    - **GNOME Classic**: Traditional interface
    - **GNOME Xorg**: X11-based display server
  - Desktop selection accessible via sprocket icon at password screen

#### User Account Management
- **Account Settings Access**:
  - Navigate to user menu → Settings sprocket → Users section
  - System unlock required for administrative changes
  - Unlock process requires password verification

- **Account Features**:
  - **Automatic Login**: Option to bypass password entry (when available)
  - **Account Activity**: View session history including start/end times
  - **Icon Customization**: Personalize user avatar for visual identification

#### Alternative Authentication Methods
- **USB Security Keys**:
  - Hardware-based authentication tokens
  - Can serve as primary or secondary (MFA) authentication
  - Primary use case: Password storage for internet services
  - Secondary capability: Linux system authentication
  - Note: Requires advanced configuration beyond course scope

#### Keyboard Shortcuts Configuration
- **Default Shortcuts**:
  - Ctrl + Alt + Delete: Opens power off menu (no default logout shortcut)

- **Custom Shortcut Creation**:
  - Access: Settings → Keyboard → Keyboard Shortcuts → Custom Shortcuts
  - Logout command: `gnome-session-quit --logout`
  - Example shortcut: Ctrl + Alt + Backspace for logout
  - Instant logout (no prompt): `gnome-session-quit --logout --no-prompt`

- **Terminal Shortcut Example**:
  - Custom shortcut: Ctrl + Alt + T opens GNOME Terminal
  - Command: `gnome-terminal`
  - Note: Ubuntu includes this by default; must be added to Debian

#### Bashrc Aliases
- **Alias Creation**:
  ```bash
  alias out="gnome-session-quit --logout --no-prompt"
  ```
- Add to `~/.bashrc` for persistent availability
- Usage: Simply type `out` to instantly logout

#### Console Login Process
- **Server Login Characteristics**:
  - Text-only interface (no desktop)
  - Minimal installation (desktops deselected during install)
  - Lightweight and fast boot times
  - Direct root or user login

- **Login Commands**:
  - Standard login with username/password
  - Exit with: `exit` or Ctrl + D

#### Virtual Console Management
- **Multiple Sessions**:
  - Linux supports multiple simultaneous terminal sessions
  - Switch between sessions using Ctrl + Alt + F[1-6]
  - Physical systems: Direct key combination works
  - Virtual machines: May require sending key combinations through hypervisor

- **GNOME vs Server Behavior**:
  - **Debian Server**: Ctrl + Alt + F1 is default (terminal only)
  - **GNOME Desktop**: Ctrl + Alt + F2 is default
    - Additional sessions: Ctrl + Alt + F4, F5, etc.
  - Maximum sessions: Typically 4-5 concurrent sessions

---

## 3.2 Logging in as an Enterprise User

### Overview
This module demonstrates enterprise-level authentication by connecting a Linux client to a FreeIPA domain. FreeIPA provides directory services similar to Microsoft Active Directory but designed specifically for Linux environments.

### Key Concepts

#### FreeIPA Architecture
- **FreeIPA Overview**:
  - Open source directory services software
  - Linux alternative to Microsoft Active Directory
  - Uses Kerberos for authentication
  - Requires client-server architecture

- **Prerequisites for Domain Connection**:
  - Domain controller already configured and running
  - Client must have administrative privileges (wheel group on Fedora)
  - Network connectivity to domain controller verified via ping

#### Client Installation and Configuration

##### Installing FreeIPA Client
```bash
# Check administrative group membership
id  # Verify wheel group membership (Fedora/RHEL/CentOS)

# Install FreeIPA client
sudo dnf install freeipa-client

# With DNS updates enabled
ipa-client-install --enable-dns-updates --mkhomedir
```

##### Network Configuration
- **DNS Configuration with nmcli**:
  ```bash
  # Identify connection name
  nmcli connection show

  # Modify DNS settings
  nmcli connection modify "Wired connection 1" ipv4.dns 10.0.2.63

  # Apply changes
  nmcli connection up "Wired connection 1"

  # Verify configuration
  nmcli
  ```

- **Hostname Verification**:
  ```bash
  hostnamectl  # Verify FQDN matches domain structure
  ```

#### Domain Enrollment Process

##### ipa-client-install Parameters
```bash
sudo ipa-client-install --enable-dns-updates --mkhomedir
```

**Installation Flow**:
1. **Discovery Phase**: Automatically detects domain controller
2. **Time Synchronization**: Critical for Kerberos authentication
   - Prompts for chrony/NTP configuration
   - Time sync must succeed between domain and clients
3. **Authentication**: Requires authorized enrollment user (root or admin)
4. **Realm Enrollment**: Joins Kerberos realm (domain name in uppercase)
5. **Configuration**: Automatic setup of various services

##### Post-Installation Requirements
- **System Reboot**: Essential after domain enrollment
- Changes only fully take effect after restart

#### Enterprise User Account Setup

##### Adding Domain Users
1. Navigate to Settings → Users
2. Select "Add User" → "Enterprise Login"
3. Provide:
   - Domain name (e.g., example.local)
   - Domain username (e.g., dpro)
   - Domain user password

##### First Login Experience
- **Password Expiration**: New domain accounts require password change
- **GNOME Tour**: First-time users prompted for interface tour
- **Home Directory Creation**: Automatically created with --mkhomedir option

#### Verification Commands
```bash
# Confirm domain connection
hostnamectl  # Shows FQDN from domain

# View domain user account
# Settings → Users shows enterprise account
```

#### Cross-Platform Domain Integration
- **Windows Domain Connectivity**:
  - Ubuntu: Use `adcli` or `realmd` with `sssd`
  - Fedora/RHEL: Native FreeIPA or SSSD configuration
  - Core requirements remain consistent across platforms:
    - Hostname must match domain
    - DNS must point to domain controller
    - Client software must be installed and configured

---

## 3.3 Locking the System

### Overview
This module covers system locking as a critical security practice, including GUI locking methods, power management options that trigger automatic locking, and the distinction between locking versus logging out.

### Key Concepts

#### Manual System Locking Methods

##### Keyboard Shortcut
- **Super Key + L**: Primary locking method
  - Equivalent to Windows + L on Windows systems
  - Instantly locks the desktop session
  - In virtual machines: May require hypervisor key sending

##### GUI Method
- **User Menu → Lock Button**: Visual locking option
  - Accessible through top-right user menu
  - Same effect as keyboard shortcut

#### Unlock Process
- **Authentication Required**: Password entry mandatory to unlock
- **Session Restoration**: All previously running programs continue execution
- **Background Processes**: Applications maintain state during lock

#### Critical Distinction: Lock vs Logout

| Aspect | Lock System | Logout |
|--------|------------|---------|
| Running Programs | Continue in background | Terminated |
| Session State | Preserved | Destroyed |
| Resource Usage | Maintained | Released |
| Example Commands | Super+L or lock button | gnome-session-quit |

**Key Insight**: Locked sessions allow continuous processes (e.g., compiles, downloads) to complete while securing the workstation.

#### Power Management and Automatic Locking

##### GNOME Power Settings Access
- Settings → Power (GNOME specific)
- Navigation may differ for other desktops (KDE Plasma, etc.)

##### Available Power Options

1. **Screen Blank (Screensaver)**:
   - Triggers after specified inactivity period
   - Default behavior includes automatic lock
   - Configurable timeout (e.g., 1 minute, 5 minutes)
   - Saves display power without full system suspension

2. **Automatic Suspend**:
   - System-level sleep mode
   - Reduces power to various components
   - Configurable idle timeout
   - Restores full functionality on wake with authentication

##### Laptop-Specific Considerations
- **Battery Conservation**: These features essential for mobile systems
- **Power Profiles**: Can be configured differently for AC vs battery power
- **Security Benefit**: Automatic locking prevents unauthorized access

#### Security Best Practices
- **Training Requirement**: Users must learn to lock systems when stepping away
- **Timeout Configuration**: Balance security with usability
- **Physical Security**: Locking complements other security measures

---

## 3.4 SSH Basics

### Overview
This module introduces Secure Shell (SSH) fundamentals, covering the connection process, authentication methods, and real-time connection monitoring. SSH enables secure remote command-line access to Linux systems.

### Key Concepts

#### SSH Protocol Overview

##### Four-Step Connection Process
1. **Initiation**: SSH client connects to SSH server
2. **Key Exchange**: Server sends public key for authentication
3. **Handshake**: Client and server negotiate encryption parameters
4. **Authentication**: User provides credentials to access the system

##### SSH Server Flexibility
- Target systems can include:
  - Physical/virtual servers
  - Client workstations
  - Network devices (switches, routers, firewalls)
  - Any system running SSH daemon

#### SSH Implementation Details

##### OpenSSH Information
- **Version Check**: `ssh -V`
  - Example output: OpenSSH 9.2
- **Cross-Platform Availability**:
  - Native on all Linux distributions
  - Available on Windows and macOS
  - Most widely deployed SSH implementation

##### SSH Service Management
```bash
# Check SSH status (Debian/Ubuntu)
systemctl status ssh

# Check SSH status (Fedora/RHEL/CentOS)
systemctl status sshd

# Install SSH server if needed
sudo apt install openssh-server
```

#### Network Verification

##### Port Verification
- **Default SSH Port**: 22 (both IPv4 and IPv6)
- **Verification Command**:
  ```bash
  ss -ant | grep :22
  ```
- Confirms SSH daemon is listening for connections

#### Making SSH Connections

##### Basic Connection Syntax
```bash
ssh username@server-ip
# Example: ssh user@10.0.2.51
```

##### First-Time Connection
- **Host Key Verification**:
  - Displays server fingerprint for validation
  - Requires explicit "yes" acceptance
  - Prevents man-in-the-middle attacks
  - Stored in `~/.ssh/known_hosts` for future connections

##### Successful Connection Indicators
- Prompt changes to reflect remote system
- Example: `user@deb-client` → `user@deb-server`
- Full remote command execution capability

#### Connection Monitoring

##### Connection State Verification

**Server-Side Monitoring**:
```bash
# View established connections
ss -tun | grep :22

# Real-time monitoring with watch
watch ss -tp
```

**Key Information Displayed**:
- Local address and port (server:22)
- Remote address and port (client:dynamically assigned)
- Process IDs for both ends
- Protocol identification

**Example Output Analysis**:
```
10.0.2.51:22 ← Server listening
10.0.2.52:58500 ← Client connection (ephemeral port)
```

**Client-Side Verification**:
```bash
ss -tun  # Shows outbound connection to server:22
```

##### Connection Termination
- **Methods**:
  - Type `exit`
  - Press Ctrl + D
- **Result**: Connection removed from both client and server listings

#### Authentication Methods Overview

##### Password Authentication
- **Characteristics**:
  - Default method requiring no pre-configuration
  - Works immediately after SSH installation
  - Username/password credentials required
  - Basic but functional security

##### Cryptographic Keys (Mentioned)
- **Enhanced Security**: More secure than password authentication
- **Implementation**: Covered in subsequent SSH security modules
- **Next Generation**: Passkeys and hardware-based authentication emerging

---

## 3.5 SSH and Linux in the Cloud

### Overview
This module extends SSH concepts to cloud environments, demonstrating connections to AWS and Linode instances. It covers SSH key management, cloud-specific configurations, and security considerations for remote cloud access.

### Key Concepts

#### Cloud SSH Architecture

##### Network Path
```
Local Computer (NW1) → Firewall → Cloud Provider → VM Instances
```

##### Supported Cloud Platforms
- **AWS (Amazon Web Services)**: Primary focus with multiple instance types
- **Linode**: Alternative cloud provider for additional demonstrations

#### AWS Instance Creation with SSH Keys

##### Instance Launch Process
1. **Instance Configuration**:
   - Name: Custom identifier (e.g., "SSH Test")
   - AMI: Amazon Linux (provider's native distribution)
   - Instance Type: t2.micro (free tier eligible)
   - **Important**: Limited free tier hours per month

2. **SSH Key Pair Creation**:
   - Options: RSA or ED25519 algorithms
     - ED25519 preferred when possible
     - RSA may be required by some organizations
   - Format Selection:
     - `.pem`: OpenSSH compatible (selected for this course)
     - `.ppk`: PuTTY compatible

3. **Network Configuration**:
   - Enable SSH traffic in security group
   - Default settings typically sufficient

##### Key File Management
```bash
# Download location: ~/Downloads/
ls -l AWS-test-key.pem

# Critical: Set restrictive permissions
chmod 400 AWS-test-key.pem

# Verify permissions changed
ls -l  # Should show: -r---------
```

**Permission Importance**: Amazon systems reject connections with overly permissive key files.

#### AWS SSH Connection Methods

##### Connection String Format
```bash
ssh -i "path/to/key.pem" ec2-user@public-dns-or-ip
```

##### User Account Conventions
- **Amazon Linux**: `ec2-user` (default)
- **Ubuntu**: `ubuntu`
- **Debian**: `admin`
- **RHEL/CentOS**: `ec2-user` or `centos`

##### Connection Options
1. **Public DNS**: Human-readable hostname (includes IP)
2. **Public IP**: Direct numeric address
3. **AWS Console Methods**:
   - Instance Connect (browser-based)
   - Serial Console
   - Standard SSH clients

#### Pre-configured Cloud Instances

##### Terraform-Managed Infrastructure
- **Tool**: Terraform for infrastructure as code
- **Benefit**: Consistent, repeatable deployments
- **Verification**: `terraform output` displays instance details

##### Key-Based Authentication
```bash
# Debian on AWS
ssh -i "keys/LNSF_Key" admin@public-ip

# Connection Success Indicators:
# - No password prompt
# - Direct shell access
# - Prompt shows remote username@hostname
```

#### System Verification Commands
```bash
# Check OS version
cat /etc/debian_version  # Debian systems

# Verify networking service
systemctl status systemd-networkd  # Amazon Linux 2023

# Update verification (cloud systems auto-update)
# Example: Debian 12.0 → 12.5 detected
```

#### Cross-Provider Connections (Linode Example)

##### Initial Root Connection Requirement
```bash
ssh -i "keys/LNSF_Key" root@97.107.140.84
```

**Important Security Note**:
- Many cloud providers (excluding AWS, Azure, Google) default to root login
- This contradicts the principle of least privilege
- **Immediate Action Required**:
  1. Create administrative user account
  2. Modify `/etc/ssh/sshd_config`
  3. Disable root SSH access: `PermitRootLogin no`
  4. Restart SSH service

##### Security Remediation Timeline
- **Acceptable**: Temporary root access for initial setup only
- **Required**: Disable root access and create sudo-capable account
- **Location**: `/etc/ssh/sshd_config` modifications (detailed in SSH security section)

#### Key Types and Formats
- **ED25519**: Modern, preferred algorithm
  - Used for pre-built cloud instances
  - Shorter keys with equivalent security
- **RSA**: Legacy support for organizational requirements
  - Used for new AWS instance demonstration
  - Longer key lengths required for security

#### Best Practices Summary
1. Always use SSH keys instead of passwords for cloud access
2. Immediately secure newly created instances
3. Verify system updates on cloud instances
4. Document all created keys and their purposes
5. Regularly audit cloud SSH access

---

## Summary

### Key Takeaways
```diff
+ GUI Login: Multiple authentication methods including passwords, USB keys, and automatic login options
+ Enterprise Integration: FreeIPA provides Linux-native domain services similar to Active Directory
+ Security Practice: System locking preserves sessions while preventing unauthorized access
+ SSH Fundamentals: Four-step encrypted connection process with multiple authentication methods
+ Cloud SSH: Key-based authentication essential for secure remote cloud instance management
- Password Authentication: Basic but less secure compared to cryptographic keys
- Root SSH: Direct root login should be disabled after initial cloud instance setup
```

### Quick Reference

#### Common Login Commands
```bash
# GUI Session Management
gnome-session-quit --logout
gnome-session-quit --logout --no-prompt

# SSH Connections
ssh username@hostname
ssh -i key.pem username@hostname

# Permission Management
chmod 400 private_key.pem
```

#### Essential Key Combinations
| Action | Shortcut |
|--------|----------|
| Lock System | Super + L |
| Terminal | Ctrl + Alt + T (custom) |
| Logout | Ctrl + Alt + Backspace (custom) |
| Virtual Console | Ctrl + Alt + F[1-6] |
| SSH Disconnect | Ctrl + D or exit |

#### Important File Locations
- SSH Keys: `~/.ssh/`
- SSH Config: `/etc/ssh/sshd_config`
- Known Hosts: `~/.ssh/known_hosts`
- Bash Aliases: `~/.bashrc`

### Expert Insight

#### Real-world Application
- **Enterprise Environments**: FreeIPA/SSSD integration enables centralized user management across Linux infrastructure
- **Cloud Operations**: SSH key management is critical for DevOps automation and secure CI/CD pipelines
- **Security Compliance**: System locking policies often required for regulatory compliance (PCI-DSS, HIPAA)

#### Expert Path
1. **Master SSH Key Management**: Learn key generation, rotation, and agent forwarding
2. **Explore Advanced FreeIPA**: Certificate management, sudo rules, and HBAC policies
3. **Implement SSH Certificates**: Move beyond individual key management to certificate authorities
4. **Automate with Ansible/Terraform**: Infrastructure-as-code for consistent SSH configurations

#### Common Pitfalls
- **Overly Permissive Keys**: Forgetting `chmod 400` on private keys prevents cloud connections
- **DNS Misconfiguration**: Domain joins fail without proper DNS pointing to domain controllers
- **Time Synchronization**: Kerberos authentication fails when clocks are out of sync
- **Ignoring Updates**: Cloud instances may auto-update; verify versions match expectations

#### Lesser-Known Facts
- **Virtual Console Limit**: Most systems support up to 63 virtual consoles (tty63), though 6 are typically configured
- **SSH Fingerprint Storage**: First-time connections add servers to `known_hosts`; corrupted entries cause connection failures
- **FreeIPA Realm Naming**: Kerberos realms must be uppercase versions of DNS domain names
- **SSH Port Range**: Client ephemeral ports (49152-65535) are dynamically assigned and change with each connection

</details>