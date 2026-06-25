# Section 14: Review of SSH

<details open>
<summary><b>Section 14: Review of SSH (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [14.1 Review of SSH](#141-review-of-ssh)
- [14.2 Using Keys to Connect via SSH](#142-using-keys-to-connect-via-ssh)
- [14.3 The sshd_config File](#143-the-sshd_config-file)
- [14.4 Modifying the Default SSH Port](#144-modifying-the-default-ssh-port)
- [14.5 Disabling Password-based SSH](#145-disabling-password-based-ssh)
- [14.6 Disabling Root Login via SSH](#146-disabling-root-login-via-ssh)
- [14.7 Exclusive SSH Groups](#147-exclusive-ssh-groups)
- [14.8 Authentication Settings](#148-authentication-settings)
- [14.9 Terminating SSH Connections Part I](#149-terminating-ssh-connections-part-i)
- [14.10 Terminating SSH Connections Part II](#1410-terminating-ssh-connections-part-ii)
- [Summary](#summary)

---

## 14.1 Review of SSH

### Overview
This section introduces the fundamental architecture of SSH communications, establishing the client-server model that underpins all subsequent SSH security configurations. Understanding this basic model is crucial for implementing the security measures covered in later sections.

### Key Concepts/Deep Dive

#### SSH Architecture Components

**SSH Client**
- The client is the system from which connections originate
- Represents the workstation or device used to initiate remote connections
- In lab environments, typically a Debian client system
- Client-side outbound ports are dynamically assigned (typically >30,000)

**SSH Server**
- The target system being remotely controlled
- Can be any computer, switch, or network device running SSH daemon
- In lab environments, typically a Debian server system
- **Critical Requirement**: Must have inbound Port 22 open by default
- The SSH daemon (sshd) must be installed, active, and enabled

#### Connection Flow
```
SSH Client (Debian) → [Outbound Dynamic Port] → Firewall → [Inbound Port 22] → SSH Server (Debian)
```

#### Authentication Evolution
- **Traditional Method**: Password-based authentication
- **Enhanced Method**: Key-based authentication (covered in next section)
- **Benefits of Keys**:
  - Eliminates need to type passwords repeatedly
  - Enables creation of keys with customizable strength
  - Provides more secure authentication mechanism

#### Lab Setup Verification Commands
```bash
# Verify SSH installation on client
ssh -V

# Verify SSH server status
sudo systemctl status ssh
# or
sudo systemctl status sshd

# Check if SSH is enabled to start on boot
sudo systemctl is-enabled ssh
```

### Lab Demonstration
This module establishes the baseline for all SSH labs:
1. Confirm client can reach server network-wise
2. Validate SSH service is running on server
3. Prepare environment for key-based authentication transition

---

## 14.2 Using Keys to Connect via SSH

### Overview
This comprehensive section details the creation, management, and utilization of SSH cryptographic key pairs, providing a secure alternative to password-based authentication while introducing advanced configuration techniques for streamlined connections.

### Key Concepts/Deep Dive

#### Cryptographic Key Pair Architecture

**Private Key**
- Resides on the client workstation where the key pair is generated
- Must remain strictly confidential - never share with anyone
- Acts as the authentication credential
- Protected by an optional but recommended passphrase

**Public Key**
- Resides on the SSH server/remote system
- Can be freely distributed without security concerns
- Used by the server to verify the client's identity
- Format: `ssh-rsa AAAAB3NzaC1yc2E... username@hostname`

#### Key Generation Process

**RSA Key Generation**
```bash
# Generate standard RSA key (3072 bits default)
ssh-keygen

# Generate strong RSA key (8192 bits)
ssh-keygen -b 8192

# Generate with specific bit strength
ssh-keygen -b 4096
```

**ed25519 Key Generation (Preferred)**
```bash
# Generate ed25519 key pair (smaller but equally secure)
ssh-keygen -t ed25519
```

**Key Generation Process Steps:**
1. Specify key storage location (default: `~/.ssh/id_rsa` or `~/.ssh/id_ed25519`)
2. Enter passphrase (strongly recommended)
3. Key pair generation completes with fingerprint and randomart

#### Passphrase Security Model
- **Common Misconception**: Keys eliminate passwords entirely
- **Reality**: Passphrase protects the private key file
- **Advantage**: Enter passphrase once per terminal session
- **Risk Without Passphrase**: System compromise = access to all SSH keys

#### SSH Directory Structure
```
~/.ssh/
├── id_rsa          # RSA private key
├── id_rsa.pub      # RSA public key
├── id_ed25519      # ed25519 private key
├── id_ed25519.pub  # ed25519 public key
├── authorized_keys # Keys authorized for this system
├── known_hosts     # Verified remote host fingerprints
└── config          # Client-side connection configurations
```

#### Key Distribution Process

**Using ssh-copy-id**
```bash
# Copy specific key to remote host
ssh-copy-id -i id_ed25519 user@10.0.2.51

# Copy would copy all keys without -i flag
ssh-copy-id user@10.0.2.51  # Copies both keys
```

**Manual Connection with Key Specification**
```bash
# Connect specifying key file
ssh -i id_ed25519 user@10.0.2.51 -p 2222
```

#### SSH Configuration File for Automation

**Config File Location**: `~/.ssh/config`

**Example Configuration:**
```ssh-config
Host debserver
    HostName 10.0.2.51
    User user
    IdentityFile ~/.ssh/lnsf-ed25519
    Port 2222

Host debclient
    HostName 10.0.2.52
    User user
    IdentityFile ~/.ssh/lnsf-ed25519
```

**Usage After Configuration:**
```bash
ssh debserver  # Automatically connects with specified parameters
ssh debclient  # Automatically connects with specified parameters
```

#### Key Management Best Practices
- **Security**: Always use passphrases with private keys
- **Organization**: Use descriptive key names for different purposes
- **Cleanup**: Remove unused keys to prevent sprawl
- **Auditing**: Regularly audit key files and their usage
- **Lifecycle**: Implement timeouts for temporary access keys

#### Manual Page Resources
```bash
man ssh-keygen  # Detailed RSA command information
man ssh-ed25519 # ed25519 specific documentation
```

---

## 14.3 The sshd_config File

### Overview
This foundational section introduces the primary SSH server configuration file, establishing the importance of backups and explaining the relationship between server-side and client-side configurations.

### Key Concepts/Deep Dive

#### Configuration File Location and Structure
```
/etc/ssh/
├── sshd_config          # Server-side configuration (primary focus)
├── ssh_config           # Client-side configuration
├── sshd_config.d/       # Additional server configurations
├── ssh_config.d/        # Additional client configurations
└── moduli               # Diffie-Hellman prime numbers
```

#### Built-in Host Key Pairs
The system includes pre-generated key pairs:
- **ECDSA** (Elliptic Curve Digital Signature Algorithm)
- **Ed25519** (Elliptic Curve based, recommended)
- **RSA** (Rivest-Shamir-Adleman, widely compatible)

**Security Implication**: These server keys can be used for host authentication, separate from user authentication keys.

#### Critical Pre-Configuration Step

**Always Create Backup Before Modifications:**
```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
```

**Verification:**
```bash
ls -la /etc/ssh/sshd_config*
```

#### Configuration Management Strategy
- **Primary File**: `/etc/ssh/sshd_config` for main settings
- **Modular Approach**: Use `/etc/ssh/sshd_config.d/` for custom configurations
- **Best Practice**: Separate custom configurations to maintain clarity between built-in and modified settings
- **Comment Convention**: Use triple comments (`###`) to mark custom sections

#### Moduli File Purpose
- Contains prime numbers for Diffie-Hellman key exchange
- Location: `/etc/ssh/moduli`
- Generally no manual modification required

#### Service Identification Note
Different distributions use different service names:
- **Debian/Ubuntu (newer)**: `ssh`
- **Fedora/RHEL/CentOS**: `sshd`
- Both services are typically aliased to work interchangeably

---

## 14.4 Modifying the Default SSH Port

### Overview
This security hardening section demonstrates changing the default SSH port from 22 to a non-standard port, explaining both the security benefits and limitations of this common obfuscation technique.

### Key Concepts/Deep Dive

#### Default Port Security Analysis

**Port 22 Characteristics:**
- Well-known and universally recognized
- Primary target for automated port scanners
- Many scanners focus on ports 1-100 or 1-1000
- Changing to higher ports may reduce scan probability

#### Port Modification Process

**Server-Side Configuration:**
```bash
# Edit sshd_config
sudo vim /etc/ssh/sshd_config

# Change from:
#Port 22
# To:
Port 2222
```

**Recommended Port Selection Criteria:**
- Avoid well-known ports (0-1023)
- Select ports not used by organizational infrastructure
- Consider ports > 30,000 for reduced visibility
- Example secure choices: 30741, 45123, etc.

#### Post-Configuration Requirements

**Service Restart:**
```bash
# Debian/Ubuntu
sudo systemctl restart ssh

# Fedora/RHEL/CentOS
sudo systemctl restart sshd

# Verify status
sudo systemctl status ssh
```

**SELinux Considerations (RHEL/Fedora/CentOS):**
```bash
# Inform SELinux of port change
sudo semanage port -a -t ssh_port_t -p tcp 2222
```

**Firewall Configuration:**
```bash
# Open new port and close old port
sudo ufw allow 2222/tcp
sudo ufw deny 22/tcp
```

#### Client Connection with Custom Port
```bash
# Basic connection with port specification
ssh user@10.0.2.51 -p 2222

# Connection refused on default port
ssh user@10.0.2.51  # Results in "Connection refused"
```

#### Security Analysis and Limitations

**nmap Scan Results:**
```
PORT     STATE SERVICE
2222/tcp open  EtherNetIP-1
```

**Security Assessment:**
- ✅ May deflect bulk automated scans
- ⚠️ Sophisticated scanners will still detect the port
- ⚠️ Only delays, doesn't prevent determined attackers
- ✅ Adds to defense-in-depth strategy

#### Client-Side Port Configuration
Add to `~/.ssh/config`:
```ssh-config
Host debserver
    HostName 10.0.2.51
    Port 2222
    User user
```

---

## 14.5 Disabling Password-based SSH

### Overview
This critical security section demonstrates completely disabling password authentication, forcing all connections to use cryptographic keys and significantly reducing the attack surface.

### Key Concepts/Deep Dive

#### Password Authentication Risks
- Vulnerable to brute-force attacks
- Susceptible to password guessing
- No protection against keyloggers on client systems
- Accounts remain accessible if passwords are compromised

#### Implementation Process

**Locate Configuration Option:**
```bash
# Search in sshd_config
/PasswordAuthentication
```

**Disable Password Authentication:**
```bash
# Change from:
PasswordAuthentication yes
# To:
PasswordAuthentication no
```

**Apply Configuration:**
```bash
sudo systemctl restart ssh
```

#### Testing and Verification

**Before Disabling (Password Works):**
```bash
ssh sysadmin@10.0.2.51 -p 2222
# Enter password when prompted
# Connection successful
```

**After Disabling (Password Fails):**
```bash
ssh sysadmin@10.0.2.51 -p 2222
# Permission denied (publickey)
# Connection fails as expected
```

#### Key-Based Authentication Validation
```bash
# Keys continue to work after password disable
ssh user@10.0.2.51 -p 2222
# Connection successful (no password prompt)
```

#### Security Impact Summary
| Authentication Method | Before Change | After Change |
|----------------------|---------------|--------------|
| Password-based | ✅ Allowed | ❌ Denied |
| Key-based | ✅ Allowed | ✅ Allowed |
| Root with Password | ✅ Allowed | ❌ Denied |
| Root with Key | ✅ Allowed | ❌ Denied |

#### Error Messages
- `Permission denied (publickey)` - Expected when password auth is disabled
- Confirms the system requires cryptographic authentication

---

## 14.6 Disabling Root Login via SSH

### Overview
This essential security measure prevents direct root login through SSH, forcing administrators to authenticate as regular users before escalating privileges, following the principle of least privilege.

### Key Concepts/Deep Dive

#### Root Login Security Risks
- Direct root access eliminates accountability
- Compromised root credentials = complete system compromise
- No audit trail of which administrator performed actions
- Violates principle of least privilege

#### Configuration Options Analysis

**Available Settings:**
- `yes` - Root login allowed (insecure default)
- `no` - Root login completely disabled (most secure)
- `prohibit-password` - Root can connect with keys only, not passwords
- `forced-commands-only` - Root limited to specific commands

#### Implementation Process

**Modify PermitRootLogin Setting:**
```bash
# Search for the setting
/PermitRootLogin

# Change from:
PermitRootLogin yes
# To:
PermitRootLogin no
```

**Important**: If `PermitRootLogin prohibit-password` is encountered, it still allows key-based root access, which should be avoided for maximum security.

#### Comprehensive Testing

**Root Connection Attempt After Disabling:**
```bash
ssh root@10.0.2.51 -p 2222
# Connection refused (wrong port) or
# Permission denied (publickey) or
# Root login disabled message
```

#### Multi-Layer Security Verification
After implementing all previous security measures:
1. ✅ Non-standard port (2222)
2. ✅ Password authentication disabled
3. ✅ Root login disabled
4. ✅ Key-based authentication required
5. ✅ No direct root access possible

#### Administrative Access Model
```
Local Admin → SSH as regular user → sudo/su to root
```

---

## 14.7 Exclusive SSH Groups

### Overview
This access control section demonstrates implementing group-based SSH restrictions, providing granular control over which users can establish SSH connections to the server.

### Key Concepts/Deep Dive

#### Access Control Philosophy
- **Default State**: All users can potentially SSH (if they have passwords/keys)
- **Restricted State**: Only explicitly authorized users/groups can SSH
- **Security Benefit**: Prevents unauthorized users from even attempting connections

#### Group-Based Access Implementation

**Create Dedicated SSH Group:**
```bash
sudo addgroup ssh-allowed
```

**Add Users to SSH Group:**
```bash
sudo adduser user ssh-allowed
```

**Verify Group Membership:**
```bash
groups user
# Output: user : user sudo ssh-allowed

id user
# Shows all group memberships including ssh-allowed
```

#### SSH Configuration for Group Restriction

**Add to sshd_config:**
```bash
### Custom SSH Group
AllowGroups ssh-allowed
```

**Alternative**: Allow multiple groups
```bash
AllowGroups ssh-allowed admin-group developers
```

**Alternative**: Allow specific users (less scalable)
```bash
AllowUsers user admin backup-user
```

#### Dynamic Testing Process

**Phase 1 - User in Group (Connection Allowed):**
```bash
# Verify user is in ssh-allowed group
groups user
# user : user sudo ssh-allowed

# Connection succeeds
ssh user@10.0.2.51 -p 2222
```

**Phase 2 - Remove User from Group:**
```bash
sudo deluser user ssh-allowed
sudo systemctl restart ssh
```

**Phase 3 - User Removed from Group (Connection Denied):**
```bash
ssh user@10.0.2.51 -p 2222
# Permission denied (publickey)
# Despite having valid keys, group membership is required
```

#### Configuration File Best Practices
- Consider using `/etc/ssh/sshd_config.d/` for custom configurations
- Use descriptive comments to separate custom from default settings
- Always backup before modifications

#### Security Architecture Summary
```
User Account → Group Membership Check → SSH Access Decision
     ↓                    ↓                      ↓
  user@server         ssh-allowed            Allow/Deny
```

---

## 14.8 Authentication Settings

### Overview
This advanced security section covers fine-tuning SSH authentication parameters including attempt limits, grace periods, and X11 forwarding controls to create a hardened authentication environment.

### Key Concepts/Deep Dive

#### Maximum Authentication Attempts

**Purpose**: Limit password guessing attempts to prevent brute-force attacks

**Configuration:**
```bash
# Change from default of 6
MaxAuthTries 3  # Standard recommendation
MaxAuthTries 1  # Maximum security (one strike rule)
```

**Testing Impact:**
```bash
# With MaxAuthTries set to 1
ssh sysadmin@10.0.2.51 -p 2222
# Too many authentication failures
# Connection immediately terminated after single failed attempt
```

#### Login Grace Time

**Purpose**: Limit time window for completing authentication

**Default Setting**: 2 minutes
**Recommended Setting**: 15-30 seconds

**Configuration:**
```bash
LoginGraceTime 15
```

**Impact Demonstration:**
1. Initiate SSH connection
2. Password prompt appears
3. Wait 15 seconds without entering password
4. Connection automatically terminated
5. "Connection closed by remote host" message

#### X11 Forwarding Security

**What is X11 Forwarding?**
- Allows running graphical applications on remote server
- Displays on local client machine
- Requires X11 server on client
- Potential security risk for unauthorized access

**Security Risk**: Malicious graphical applications could capture input or display sensitive information

#### Server-Side X11 Disabling

**In sshd_config:**
```bash
X11Forwarding no
```

#### Client-Side X11 Disabling

**Location**: `/etc/ssh/ssh_config`

**Default Configuration Analysis:**
```bash
Host *
    ForwardX11 no  # Already disabled by default on many systems
```

**Manual Disabling (if needed):**
```bash
sudo vim /etc/ssh/ssh_config
# Uncomment and ensure:
ForwardX11 no
ForwardX11Trusted no
```

**Note**: Client configuration requires sudo due to read-only permissions for regular users.

#### Integrated Security Testing

**Combined Authentication Hardening:**
1. ✅ MaxAuthTries: 1 attempt allowed
2. ✅ LoginGraceTime: 15 seconds to authenticate
3. ✅ X11Forwarding: Disabled on both ends
4. ✅ PasswordAuthentication: Disabled
5. ✅ PermitRootLogin: Disabled
6. ✅ AllowGroups: Restricted access

#### Manual Page Reference
```bash
man sshd_config  # Comprehensive documentation of all options
```

---

## 14.9 Terminating SSH Connections Part I

### Overview
This operational section teaches methods for monitoring and terminating SSH connections using process management tools, essential for security incident response and session management.

### Key Concepts/Deep Dive

#### SSH Connection Monitoring

**Basic Connection Count:**
```bash
pgrep -c sshd
# Returns count of SSH daemon processes
# 1 = Only local administrative connection
# 3 = Local admin + one remote connection (bidirectional)
```

**Detailed Process View:**
```bash
ps -ef | grep ssh

# Sample Output:
# root      1260     1  0 10:00 ?        00:00:00 /usr/sbin/sshd -D
# root      1281  1260  0 10:05 ?        00:00:00 sshd: user@pts/0
# user      1264  1281  0 10:05 ?        00:00:00 sshd: user@pts/0
```

#### Understanding Process Relationships
- **PID 1260**: Master SSH daemon (listener)
- **PID 1281**: Server-side of user connection
- **PID 1264**: Client-side of user connection
- Each remote connection creates a bidirectional tunnel with two processes

#### Real-Time Connection Monitoring

**Using ss Command:**
```bash
ss -punt | grep ssh

# Shows:
# - Local address and port (10.0.2.51:2222)
# - Peer address and port (10.0.2.52:54834)
# - Associated process IDs
```

**Real-Time Monitoring with watch:**
```bash
watch ss -punt

# Continuously updates connection list
# Press Ctrl+C to exit
```

#### Connection Termination Methods

**Terminate by Process ID:**
```bash
# Kill specific connection
kill 1281

# Verify termination
pgrep -c sshd  # Count decreases
```

**Bulk Termination with pkill:**
```bash
# Terminate all SSH connections (emergency use)
pkill --signal KILL sshd

# Results in:
# - All remote connections terminated
# - Only local administrative connection remains
pgrep -c sshd  # Returns to 1
```

#### Alternative Termination Tools

**killall Command:**
```bash
# Install if needed
sudo apt install psmisc

# Terminate all SSH daemon processes
killall sshd
```

#### Connection Identification Strategy
```
IP Address → ss -punt (identifies peer)
User Account → ps -ef | grep ssh (identifies user)
Process ID → Both commands provide PIDs for termination
```

#### Emergency Response Workflow
1. **Identify**: Use `ss -punt` to see active connections
2. **Investigate**: Use `ps -ef` to identify users
3. **Terminate**: Use `kill [PID]` for specific or `pkill` for all
4. **Verify**: Confirm with `pgrep -c sshd`

---

## 14.10 Terminating SSH Connections Part II

### Overview
This advanced session management section demonstrates automatic session termination through inactivity timeouts, implementing both user-specific and global policies while introducing SSH key management concepts.

### Key Concepts/Deep Dive

#### Session Timeout Architecture

**Historical Context**: ClientAliveInterval and ClientAliveCountMax were deprecated in OpenSSH 8.2

**Modern Approach**: Use shell-level TMOUT variable for automatic termination

#### User-Specific Timeout Configuration

**Create/Modify .bash_profile:**
```bash
vim ~/.bash_profile

# Add timeout configuration
TMOUT=180  # 3 minutes of inactivity
readonly TMOUT
export TMOUT
```

**Alternative Values:**
- `TMOUT=15` - Demo/testing (immediate feedback)
- `TMOUT=180` - 3 minutes (recommended minimum)
- `TMOUT=600` - 10 minutes (more user-friendly)

#### Global Timeout Configuration

**Create System-Wide Script:**
```bash
sudo vim /etc/profile.d/custom.sh

#!/bin/bash
TMOUT=180
readonly TMOUT
export TMOUT
```

**Important**: Setting applies to ALL users including root

#### Timeout Behavior Analysis
- **Scope**: Applies to all terminal sessions (local and remote)
- **Trigger**: Any keyboard input resets the timer
- **Result**: "timed out waiting for input" message
- **Recovery**: User must reconnect after timeout

#### SSH Key Management Concepts

**The Problem**: SSH key sprawl
- Thousands of unused keys in Fortune 1000 companies
- Old encryption algorithms still in use
- Keys scattered across systems without tracking

**Key Management Recommendations:**
- Implement key management programs
- Maintain inventory of all keys (public and private)
- Track key locations and ownership
- Set expiration dates for temporary access
- Regularly audit and rotate keys
- Remove unused or weak keys promptly

#### External Resources
- SSH Key Management guidance documentation
- Industry best practices for key lifecycle management

#### Comprehensive Security Closure
This module completes the SSH security curriculum by addressing:
1. ✅ Session lifecycle management
2. ✅ Automatic termination policies
3. ✅ Key inventory and management
4. ✅ Long-term security maintenance

---

## Summary

### Key Takeaways
```diff
+ SSH follows a client-server model with daemon running on TCP port 22 by default
+ Key-based authentication provides superior security compared to passwords
+ Multiple layers of security: non-standard ports, key auth, group restrictions, timeouts
+ Configuration changes require service restart and firewall adjustments
+ Session monitoring and termination are essential for security operations
+ Key management prevents sprawl and ensures long-term security
```

### Quick Reference

#### Essential Commands
```bash
# Service Management
sudo systemctl restart ssh          # Debian/Ubuntu
sudo systemctl restart sshd         # RHEL/Fedora/CentOS

# Key Generation
ssh-keygen -t ed25519               # Recommended key type
ssh-keygen -b 8192                  # Strong RSA key

# Key Distribution
ssh-copy-id -i id_ed25519 user@host

# Connection Monitoring
pgrep -c sshd                       # Count connections
ss -punt                           # View connections
ps -ef | grep ssh                  # Detailed process view

# Session Termination
kill [PID]                         # Terminate specific
pkill --signal KILL sshd           # Emergency termination

# Configuration Files
/etc/ssh/sshd_config               # Server configuration
/etc/ssh/ssh_config                # Client configuration
~/.ssh/config                      # User-specific config
```

#### Critical Configuration Options
```bash
Port 2222                          # Non-standard port
PasswordAuthentication no          # Disable passwords
PermitRootLogin no                 # Disable root login
AllowGroups ssh-allowed            # Group restriction
MaxAuthTries 3                     # Limit attempts
LoginGraceTime 15                  # Authentication timeout
X11Forwarding no                   # Disable X11
```

### Expert Insight

#### Real-world Application
In production environments, implement these SSH security measures in layers:
1. Start with key-based authentication as the foundation
2. Add network-level controls (port changes, firewall rules)
3. Implement access controls (groups, user restrictions)
4. Configure session management (timeouts, monitoring)
5. Establish key management procedures

#### Expert Path
- Master SSH configuration options through `man sshd_config`
- Implement automated key rotation systems
- Develop monitoring dashboards for SSH access patterns
- Create incident response playbooks for SSH compromise scenarios
- Explore advanced features like SSH certificates and CA infrastructure

#### Common Pitfalls
- ❌ Forgetting to backup configurations before changes
- ❌ Not updating firewall rules after port changes
- ❌ Leaving root login enabled with key authentication
- ❌ Setting timeouts too aggressive, causing workflow disruption
- ❌ Not maintaining key inventory leading to orphaned keys
- ❌ Forgetting SELinux context changes on RHEL systems

#### Lesser-Known Facts
- ed25519 keys are smaller but provide equivalent security to much larger RSA keys
- SSH connections create bidirectional tunnels with two process IDs per connection
- The moduli file contains carefully selected primes for Diffie-Hellman security
- SSH config files support pattern matching with wildcards and conditions
- TMOUT variable affects all shell sessions, not just SSH connections

</details>