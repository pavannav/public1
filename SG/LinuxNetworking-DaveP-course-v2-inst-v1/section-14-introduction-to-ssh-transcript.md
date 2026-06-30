# Section 14: Introduction to SSH

<details open>
<summary><b>Section 14: Introduction to SSH (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents

- [14.1 Introduction to SSH](#141-introduction-to-ssh)
- [14.2 Installing and Analyzing SSH on Linux](#142-installing-and-analyzing-ssh-on-linux)
- [14.3 Using SSH to Connect to a Remote System](#143-using-ssh-to-connect-to-a-remote-system)
- [14.4 Analyzing the SSH Connection](#144-analyzing-the-ssh-connection)
- [14.5 Terminating SSH Connections](#145-terminating-ssh-connections)
- [14.6 Using SSH Keys Part I](#146-using-ssh-keys-part-i)
- [14.7 Using SSH Keys Part II](#147-using-ssh-keys-part-ii)

---

## 14.1 Introduction to SSH

### Overview

SSH (Secure Shell) is the primary protocol for remotely controlling Linux systems from the command line. This module introduces the four-step SSH connection process and covers OpenSSH, the standard implementation used across Linux distributions.

### Key Concepts/Deep Dive

#### What is SSH?

SSH enables secure remote access and control of systems over encrypted channels. The basic architecture consists of:

- **SSH Client**: Initiates connections to remote systems (outbound, dynamically assigned ports)
- **SSH Server**: Listens for incoming connections (default inbound port 22)

#### The Four-Step SSH Connection Process

```diff
! Step 1: Client initiates connection to SSH server
! Step 2: Server sends public key for authentication/fingerprint verification
! Step 3: Systems handshake on parameters and establish secure channel
! Step 4: User authenticates and logs into remote system
```

The handshake parameters vary based on authentication method:
- Password-based authentication
- Key-based authentication
- Certificate-based authentication

#### OpenSSH Implementation

**Key characteristics of OpenSSH:**
- Built into Linux distributions by default
- Open source and freely available
- Compatible with macOS and Windows
- Used for all labs in this course

#### Network Architecture

**Client-side network behavior:**
- Uses dynamically assigned outbound ports (typically in ephemeral range)
- Example ports: 32842, 34142, 46402
- Port assignment varies with each connection

**Server-side network behavior:**
- Listens on inbound port 22 (default)
- Accepts connections from any client
- Can be configured to listen on specific interfaces only

#### Authentication Methods Preview

This section covers two primary authentication approaches:
1. **Password-based**: Traditional method requiring username/password
2. **Key-based**: More secure method using public/private key pairs

---

## 14.2 Installing and Analyzing SSH on Linux

### Overview

This lab module demonstrates how to verify SSH installation, check service status, and ensure both client and server systems are properly configured for SSH connectivity.

### Key Concepts/Deep Dive

#### Verifying SSH Installation

**Check SSH version and installation:**
```bash
ssh -V
```

**Expected output:**
```
OpenSSH_9.2p1 Debian-2+deb12u3, OpenSSL 3.0.11 19 Sep 2023
```

#### Installing OpenSSH Server

If SSH is not installed, use the appropriate package manager:

**For Debian/Ubuntu:**
```bash
sudo apt install openssh-server
```

**For RHEL/CentOS/Fedora:**
```bash
sudo dnf install openssh-server
# or
sudo yum install openssh-server
```

#### Managing SSH Service

**Check service status:**
```bash
systemctl status ssh
```

> [!NOTE]
> While `sshd` was historically used, modern distributions use `ssh` as the service name. The `sshd` service is becoming deprecated.

**Service status indicators:**
- `active (running)`: Service is operational
- `enabled`: Service starts automatically on boot

#### Network Port Verification

**Using SS command to verify listening ports:**
```bash
ss -tulnw
```

This displays:
- TCP and UDP listening ports
- IPv4 and IPv6 bindings
- Network namespace information

**Sample output showing SSH:**
```
State    Recv-Q   Send-Q     Local Address:Port     Peer Address:Port  Process
LISTEN   0        128              0.0.0.0:22            0.0.0.0:*
LISTEN   0        128                 [::]:22               [::]:*
```

#### Pre-Connection Checklist

**Essential verification steps:**

1. ✅ Both systems have OpenSSH installed
2. ✅ Same or compatible SSH versions
3. ✅ SSH service is active and running
4. ✅ Port 22 is listening (IPv4 and IPv6)
5. ✅ Administrative privileges available for installation if needed

---

## 14.3 Using SSH to Connect to a Remote System

### Overview

This hands-on lab provides comprehensive instruction on establishing SSH connections to remote systems, including direct IP connections, hostname resolution, and VirtualBox-specific port forwarding configurations.

### Key Concepts/Deep Dive

#### Basic SSH Connection Syntax

**Command structure:**
```bash
ssh username@hostname_or_ip
```

**Example connection:**
```bash
ssh user@10.0.2.51
```

#### SSH Connection Process Walkthrough

1. **Initiate connection**
   ```bash
   ssh user@10.0.2.51
   ```

2. **Host key verification**
   - Server presents its public key fingerprint
   - User confirms authenticity (first connection)
   - Fingerprint added to `known_hosts` file

3. **Authentication**
   - Enter password for target user account
   - Successful authentication establishes session

#### Post-Connection Indicators

**Connection confirmation elements:**
- Shell prompt changes to show remote hostname
- Example: `user@debserver` vs `user@debclient`
- Welcome banner displays distribution information
- All commands execute on remote system

#### Command Examples on Remote System

```bash
# Check remote system IP
ip a

# List directories
ls -la

# View system information
cat /etc/debian_version
```

#### Terminating SSH Sessions

**Method 1: Exit command**
```bash
exit
```

**Method 2: Keyboard shortcut**
```
Ctrl + D
```

**Expected logout message:**
```
logout
Connection to 10.0.2.51 closed.
```

#### Alternative Connection Methods

**Connecting via hostname (with DNS/hosts file configured):**
```bash
ssh user@telemetry
```

**Connecting to different user accounts:**
```bash
ssh sysadmin@10.42.0.15
```

#### VirtualBox Port Forwarding Configuration

VirtualBox requires additional configuration for SSH access to guest VMs.

**Network Requirements:**
- NAT Network must be configured
- Port forwarding rules required
- Two-step configuration process

**Port Forwarding Setup:**
1. Access VirtualBox Network Manager
2. Configure port forwarding rule:
   - Host IP: `127.0.0.1` (localhost)
   - Host Port: `2222` (arbitrary local port)
   - Guest IP: `10.0.2.15` (target VM IP)
   - Guest Port: `22` (SSH default port)

**Connection via port forwarding:**
```bash
ssh -p 2222 vboxuser@127.0.0.1
```

**Key considerations:**
- Password for VirtualBox VMs: `changeme` (default)
- Must specify username configured in VM
- Local port must match forwarding rule

---

## 14.4 Analyzing the SSH Connection

### Overview

This module demonstrates techniques for monitoring and analyzing established SSH connections using various Linux networking tools to understand connection states and process associations.

### Key Concepts/Deep Dive

#### Client-Side Connection Analysis

**View established connections:**
```bash
ss -tun
```

**Understanding output fields:**
- **Local Address:Port**: Client IP and dynamically assigned outbound port
- **Peer Address:Port**: Server IP and listening port (22)

**Sample client connection output:**
```
State  Recv-Q Send-Q  Local Address:Port  Peer Address:Port
ESTAB  0      0       10.0.2.52:34142    10.0.2.51:22
```

**Key observations:**
- Outbound port (34142) is dynamically assigned
- Port changes with each new connection
- Peer always shows port 22 on server

#### Server-Side Connection Analysis

**View reverse perspective:**
```bash
ss -tun
```

**Sample server connection output:**
```
State  Recv-Q Send-Q  Local Address:Port  Peer Address:Port
ESTAB  0      0       10.0.2.51:22       10.0.2.52:34142
```

**Understanding server view:**
- Local port 22 is listening
- Remote (peer) shows client details
- Relationship is inverted from client perspective

#### Extended Connection Information

**Additional options for detailed analysis:**

```bash
# Show all connections (listening and established)
ss -ant

# Show processes with connections
ss -tp

# Show comprehensive information
ss -tulnw
```

**Process ID information:**
- `ss -tp` reveals process IDs for connections
- Essential for connection management and termination
- Shows both local and remote process associations

#### Real-Time Connection Monitoring

**Using the watch command:**
```bash
watch ss -tp
```

**Benefits of real-time monitoring:**
- Automatically updates connection list
- Shows new connections as they establish
- Essential for managing multiple connections
- Process IDs visible for termination decisions

#### Multiple Connection Handling

**Establishing multiple sessions:**
```bash
ssh user@10.0.2.51
# Open new terminal
ssh user@10.0.2.51
```

**Server behavior with multiple connections:**
- Newer connections appear at top of list
- Each connection has unique client-side port
- Different process IDs for each session
- Default allows multiple concurrent sessions

**Sample multiple connection output:**
```
ESTAB  0  0  10.0.2.51:22  10.0.2.52:34142  users:(("sshd",pid=1234,fd=7))
ESTAB  0  0  10.0.2.51:22  10.0.2.52:46402  users:(("sshd",pid=5678,fd=7))
```

#### Network Topology Context

**Reference information for analysis:**
- Client IP: 10.0.2.52
- Server IP: 10.0.2.51
- All connections from main system through virtualization layer

---

## 14.5 Terminating SSH Connections

### Overview

This module provides comprehensive instruction on managing and terminating SSH connections, covering process identification, selective termination, and bulk session management techniques.

### Key Concepts/Deep Dive

#### Understanding SSH Process Architecture

**Process counting considerations:**
```bash
pgrep -c ssh
```

**Process multiplication factor:**
- Each SSH connection creates 2 processes (client ↔ server communication)
- Base SSH listener process always runs
- Formula: (connections × 2) + 1 = total count

**Example calculation:**
- 2 SSH connections = 4 processes
- Plus 1 administrative listener = 5 total

#### Process Identification Methods

**Method 1: Filter by user**
```bash
pgrep -u root ssh
```

**Method 2: Process listing with filtering**
```bash
ps -ef | grep ssh
```

**Expected output includes:**
- Root listener process (always present)
- User session processes (per connection)
- Both server and client process IDs

#### Connection State Analysis

**Identify specific connections:**
```bash
ss -punt
```

**Sample output:**
```
State  Recv-Q Send-Q  Local:Port  Peer:Port   Process
ESTAB  0      0       *:22       10.0.2.52:34142  users:(("sshd",pid=944,fd=7))
ESTAB  0      0       *:22       10.0.2.52:46402  users:(("sshd",pid=1056,fd=7))
```

**Critical information:**
- Server-side process IDs
- Client-side port numbers
- Enables targeted termination

#### Selective Connection Termination

**Terminate specific session:**
```bash
kill 944
```

**Verification:**
```bash
ss -punt
# Confirm reduced connection count
```

**Impact analysis:**
- Immediate termination of selected session
- Corresponding client-side closure
- Other sessions remain unaffected

#### Bulk Session Management

**Terminate all SSH sessions:**
```bash
pkill --signal KILL sshd
```

**Alternative termination methods:**

**Method using xargs:**
```bash
ps -ef | grep sshd | xargs kill -9
```

> [!WARNING]
> `pkill` affects all SSH sessions including the administrative listener. Use with caution.

#### Post-Termination Verification

**Confirm session closure:**
```bash
ss -punt
# Should show no established connections

pgrep -c ssh
# Should return 1 (only the listener process)
```

**Expected results:**
- Zero established TCP connections
- Only the base SSH listener process remains
- All user sessions terminated

#### Connection Recreation Testing

**Re-establish connections for testing:**
```bash
ssh user@10.0.2.51
# Creates fresh session with new client port
```

**Session tracking:**
- Each new connection receives new client port
- Process ID tracking through `ss -tp` or `watch` command
- Enables testing of termination procedures

---

## 14.6 Using SSH Keys Part I

### Overview

This module introduces SSH key-based authentication as a more secure and convenient alternative to password authentication, covering key pair generation and the cryptographic principles behind public-key authentication.

### Key Concepts/Deep Dive

#### Password vs Key Authentication

**Limitations of password authentication:**
- Requires typing password for each connection
- Vulnerable to brute-force attacks
- Password complexity requirements
- Risk of password reuse across systems

**Advantages of key-based authentication:**
- No password typing required after initial setup
- Significantly higher security level
- Eliminates password transmission over network
- Immune to brute-force password attacks

#### SSH Key Pair Architecture

**Key pair components:**
- **Private Key**: Stored on client, never shared, highly secured
- **Public Key**: Distributed to servers, safe to share

**Key relationship:**
- Keys are mathematically linked (key pair)
- Public key verifies possession of corresponding private key
- One-way function: Public key cannot derive private key

#### Key Storage Locations

**Client-side storage:**
- Default location: `~/.ssh/`
- Private key: `id_rsa` (never share)
- Public key: `id_rsa.pub` (distribute to servers)

**Server-side storage:**
- Location: `~/.ssh/authorized_keys`
- Contains public keys from authorized clients
- One key per line in the file

#### Supported Algorithms

**Available encryption types:**
- **RSA**: Default algorithm, widely supported
- **Ed25519**: Modern, recommended for new deployments
- **ECDSA**: Elliptic curve-based option

**Algorithm selection:**
```bash
ssh-keygen          # Uses RSA by default
ssh-keygen -t ed25519  # Specify algorithm type
```

#### RSA Key Specifications

**Default parameters:**
- Algorithm: RSA
- Key size: 3072 bits (current default)
- File naming: `id_rsa` and `id_rsa.pub`

**Custom key sizes:**
```bash
ssh-keygen -b 4096    # 4096-bit key
ssh-keygen -b 8192    # 8192-bit key
ssh-keygen -b 16384   # 16384-bit key
```

> [!NOTE]
> Maximum tested size: 32768 bits. Larger keys provide more security but take longer to generate.

#### Passphrase Protection

**Purpose of passphrases:**
- Protects private key locally on client system
- Required even if attacker gains system access
- Prevents unauthorized use of stolen keys

**Passphrase best practices:**
- Use complex, lengthy passphrase
- Different from account passwords
- Store securely (password manager recommended)

**Consequences of no passphrase:**
- Stolen private key enables immediate unauthorized access
- No secondary protection mechanism
- Violates security best practices

#### Key Generation Process

**Complete key generation workflow:**
```bash
ssh-keygen
# Accept default location: ~/.ssh/id_rsa
# Enter secure passphrase when prompted
# Key pair generated successfully
```

**Key fingerprint generation:**
- Automatic fingerprint creation
- Format: `user@hostname`
- Unique identifier for the key pair

---

## 14.7 Using SSH Keys Part II

### Overview

This module completes the SSH key setup process by demonstrating public key distribution to remote servers, connection using keys, and server-side key management.

### Key Concepts/Deep Dive

#### Inspecting Generated Keys

**View SSH directory contents:**
```bash
ls -la ~/.ssh/
```

**Key files to identify:**
- `id_rsa`: Private key (protect this file)
- `id_rsa.pub`: Public key (safe to distribute)
- `known_hosts`: Previously verified host fingerprints

#### Key Permission Considerations

**File security requirements:**
- Private key: `600` (owner read/write only)
- Public key: `644` (world readable acceptable)
- `.ssh` directory: `700` (owner access only)

#### Distributing Public Keys

**Using ssh-copy-id for automation:**
```bash
ssh-copy-id user@10.0.2.51
```

**Process steps:**
1. Connect to target server (password authentication)
2. Upload public key to `~/.ssh/authorized_keys`
3. Set appropriate permissions on server
4. Confirm successful installation

**Manual verification:**
```bash
# Check key was installed
cat ~/.ssh/authorized_keys
```

#### Understanding authorized_keys Format

**File structure:**
- One public key per line
- Contains algorithm type, key data, and comment
- Example: `ssh-rsa AAAAB3NzaC1yc2E... user@debclient.example.local`

**Key components:**
- Algorithm identifier: `ssh-rsa`
- Base64-encoded key data
- User and hostname comment

#### First Key-Based Connection

**Initial connection process:**
```bash
ssh user@10.0.2.51
```

**Authentication sequence:**
1. Server presents public key challenge
2. Client unlocks private key with passphrase
3. Cryptographic verification occurs
4. Access granted without password prompt

**Passphrase caching behavior:**
- Passphrase cached for session duration
- Default timeout: ~30 minutes
- Subsequent connections within timeout require no passphrase

#### Subsequent Connection Behavior

**Cached authentication flow:**
```bash
ssh user@10.0.2.51
# Immediate connection without prompts
```

**Cache invalidation triggers:**
- System reboot
- Passphrase timeout expiration
- Manual cache clearing

#### Server-Side Key Management

**Verify key installation:**
```bash
cd /home/user/.ssh
ls -la
cat authorized_keys
```

**Understanding server response:**
- Public key enables authentication
- Private key remains solely on client
- Key pair relationship verified during connection

#### Security Best Practices

**Private key protection:**
- Never share private key
- Use strong passphrases
- Backup keys securely
- Monitor key usage

**Key rotation considerations:**
- Regular key regeneration recommended
- Remove old keys from servers
- Update authorized_keys files
- Maintain key inventory

#### Practical Application Testing

**Recommended practice scenarios:**
- Set up keys between multiple Linux systems
- Configure keys for different user accounts
- Test connections to various network devices
- Practice key management and rotation

**Benefits realization:**
- Faster connection times
- Elimination of password fatigue
- Enhanced security posture
- Professional workflow alignment

---

## Summary

### Key Takeaways

```diff
+ SSH provides encrypted remote access using a standard four-step connection process
+ OpenSSH is the universal standard implementation across Linux distributions
+ Port 22 is the default SSH server port; clients use dynamically assigned outbound ports
+ Always verify SSH installation and service status before attempting connections
+ VirtualBox requires port forwarding configuration for guest VM access
+ Monitor connections using ss, pgrep, and watch commands for management
+ Terminate specific sessions with kill or all sessions with pkill
+ SSH keys provide superior security and convenience over passwords
+ Key pairs consist of a private key (client-only) and public key (distributed to servers)
+ Use ssh-copy-id for automated public key distribution
+ Passphrases protect private keys from unauthorized local access
+ RSA is the default algorithm; consider ed25519 for modern deployments
```

### Quick Reference

**Essential SSH Commands:**
```bash
ssh -V                           # Check version
systemctl status ssh             # Service status
ss -tun                          # View connections
ssh user@host                    # Connect
ssh -p port user@host            # Connect with custom port
ssh-keygen                       # Generate key pair
ssh-copy-id user@host            # Distribute public key
kill PID                         # Terminate specific session
pkill --signal KILL sshd        # Terminate all sessions
```

**Key File Locations:**
- Private key: `~/.ssh/id_rsa`
- Public key: `~/.ssh/id_rsa.pub`
- Authorized keys: `~/.ssh/authorized_keys`
- Known hosts: `~/.ssh/known_hosts`

### Expert Insight

**Real-world Application:**

In production environments, SSH keys are essential for:
- Automated deployment scripts requiring passwordless access
- DevOps CI/CD pipelines for continuous integration
- System administration across large server fleets
- Compliance requirements for audit trails and access control
- Jump host configurations for layered security architectures

**Expert Path:**

To master SSH operations:
1. Configure SSH agent forwarding for seamless multi-hop connections
2. Implement SSH certificates for enterprise-scale key management
3. Set up SSH bastions/jump hosts for secure network segmentation
4. Configure advanced options like ControlMaster for connection multiplexing
5. Implement fail2ban and SSH hardening configurations
6. Practice key rotation and emergency access procedures

**Common Pitfalls:**

- ❌ Leaving private keys unprotected without passphrases
- ❌ Copying private keys between systems instead of generating unique pairs
- ❌ Using weak key sizes (1024-bit or smaller)
- ❌ Failing to update authorized_keys when users leave organizations
- ❌ Ignoring SSH version vulnerabilities and not keeping OpenSSH updated
- ❌ Using password authentication in production environments

**Lesser-Known Facts:**

- The maximum RSA key size is practically unlimited, though 4096 bits provides excellent security
- SSH agent can hold multiple keys and automatically selects the correct one
- ControlMaster enables connection multiplexing for significant performance improvements
- SSH certificates provide an alternative to traditional key distribution
- The `.ssh/config` file enables per-host configuration customization
- SSH supports subsystem commands for SFTP and other protocols

</details>