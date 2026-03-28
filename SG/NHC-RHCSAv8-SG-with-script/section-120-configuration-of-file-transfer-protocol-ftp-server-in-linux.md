# Section 120: File Transfer Protocol (FTP) 

<details open>
<summary><b>Section 120: File Transfer Protocol (FTP) (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to FTP](#introduction-to-ftp)
- [FTP History and Basics](#ftp-history-and-basics)
- [Security Concerns](#security-concerns)
- [Ports and Protocols](#ports-and-protocols)
- [Installing and Configuring vsftpd](#installing-and-configuring-vsftpd)
- [Enabling FTP Services](#enabling-ftp-services)
- [Firewall Configuration](#firewall-configuration)
- [Connecting as FTP Client](#connecting-as-ftp-client)
- [Managing Users and Access](#managing-users-and-access)
- [Lab Demonstration](#lab-demonstration)
- [Summary](#summary)

## Introduction to FTP

### Overview
FTP stands for File Transfer Protocol, a standard communication protocol used for transferring files between client and server over a computer network. It allows users to upload and download files from a remote server, making it useful for accessing shared resources. This session covers complete FTP server configuration on Linux systems using vsftpd.

### Key Concepts

FTP enables bidirectional file transfers between networked devices. It separates control and data connections for efficient operations. Key characteristics include support for anonymous access and authenticated logins.

**Connection Types:**
- Control connection (port 21): Handles commands and responses
- Data connection (port 20): Transfers actual file data

**User Authentication Modes:**
- **Anonymous users**: Guest access without local account
- **Local users**: Existing system account holders

Code configuration focuses on vsftpd (Very Secure FTP Daemon) implementation with proper security measures.

## FTP History and Basics

### Overview
FTP was developed in 1971 by Abhay Bhushan Pandey, an Indian scientist, to enable file sharing across early computer networks. While it revolutionized data transfer at the time, it lacks modern security features. Today, it's mainly used in private networks or replaced by secure alternatives like SFTP.

### Key Concepts

FTP works on client-server model where server provides file storage services. The protocol operates over TCP/IP networks and supports both active and passive modes.

**Inventor Details:**
- Name: Abhay Bhushan Pandey
- Year: Introduced in 1971 (April 16th)
- Contribution: First implementation on ARPANET

**Protocol Characteristics:**
- Application layer protocol
- Uses TCP for reliable data transfer
- Supports directory listing and file operations

```bash
# Basic FTP server definition
ftp server: A daemon process running on port 21 that accepts file transfer requests
```

Common use cases include web hosting, software distribution, and backup systems.

| Feature | Description |
|---------|-------------|
| Reliability | Uses TCP for error-free transmission |
| Speed | Efficient for large file transfers |
| Compatibility | Works across different operating systems |
| Directory Support | Allows navigation through remote file systems |

## Security Concerns

### Overview
FTP transmits data in plain text without encryption, making it vulnerable to eavesdropping attacks. Network sniffing can easily capture usernames, passwords, and transferred content. This is why SFTP (SSH File Transfer Protocol) or FTPS are preferred for secure environments.

### Key Concepts

**Security Weaknesses:**
- No encryption on data or control channels
- Credentials sent in clear text
- Man-in-the-middle attacks possible
- Not recommended for internet-facing services

**Alternatives:**
- **SFTP**: Secure version using SSH (port 22)
- **FTPS**: FTP over SSL/TLS encryption
- **HTTPS**: For web-based file transfers

```diff
- Risk: Clear text transmission exposes sensitive data
! Warning: Never use FTP over untrusted networks
+ Mitigations: Use VPNs or switch to SFTP for security
```

Modern deployments typically use encrypted protocols to prevent data interception.

## Ports and Protocols

### Overview
FTP uses two main ports for its operations: port 21 for control connections and port 20 for data transfers in active mode. Understanding port allocation is crucial for firewall configuration and troubleshooting connectivity issues.

### Key Concepts

**Port Assignments:**
- **Port 21**: Control channel for commands and responses
- **Port 20**: Data channel in active mode (server initiates connection)

```yaml
ftp_ports:
  control: 21
  data: 20
  range: "Can be changed for custom implementations"
```

**Connection Modes:**
- **Active Mode**: Server connects back to client on random port > 1024
- **Passive Mode**: Client connects to server on random port > 1024

Configure firewall to allow these ports:

```bash
# Allow FTP ports through firewall
sudo firewall-cmd --permanent --add-port=21/tcp
sudo firewall-cmd --permanent --add-port=20/tcp
sudo firewall-cmd --reload
```

## Installing and Configuring vsftpd

### Overview
vsftpd (Very Secure FTP Daemon) is the most commonly used FTP server on Linux systems. Installation involves system package managers, followed by configuration file editing. The configuration file `/etc/vsftpd/vsftpd.conf` controls all server behavior and security settings.

### Key Concepts

**Package Installation:**
```bash
# Install vsftpd and ftp client
sudo yum install vsftpd ftp  # RHEL/CentOS
# or
sudo apt install vsftpd ftp   # Ubuntu/Debian
```

**Key Configuration Options:**
- `anonymous_enable=YES/NO`: Control anonymous access
- `local_enable=YES/NO`: Allow local user logins
- `write_enable=YES`: Enable file upload permissions

```bash
# Enable anonymous users
anonymous_enable=YES

# Allow local users to login
local_enable=YES

# Enable write permissions
write_enable=YES
```

**Directory Configuration:**
- Anonymous users default to `/var/ftp/pub`
- Local users default to their home directory
- Can be customized using `local_root` parameter

📝 **Configuration Tip**: Always backup original config file before making changes:
```bash
sudo cp /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf.backup
```

## Enabling FTP Services

### Overview
After configuration, FTP services must be enabled and started using systemd commands. The service should be set to start automatically on boot to ensure availability. Status checking verifies proper operation.

### Key Concepts

**Service Management:**
```bash
# Start vsftpd service
sudo systemctl start vsftpd

# Enable on boot
sudo systemctl enable vsftpd

# Check status
sudo systemctl status vsftpd
```

**Verification Commands:**
```bash
# Check if service is active
systemctl is-active vsftpd

# Restart service after config changes
sudo systemctl restart vsftpd
```

✅ **Service States**:
- Active: Service running successfully
- Failed: Check logs for errors
- Disabled: Not starting on boot

## Firewall Configuration

### Overview
Firewall rules must allow FTP traffic through ports 21 and 20 for proper functionality. Both permanent and runtime configurations ensure persistent access. Additional security measures like SELinux considerations may apply.

### Key Concepts

**Basic Firewall Setup:**
```bash
# Allow FTP ports
sudo firewall-cmd --permanent --add-service=ftp
sudo firewall-cmd --reload

# Verify rules
sudo firewall-cmd --list-all
```

**Custom Port Rules:**
```bash
# For custom FTP port (example: 3434)
sudo firewall-cmd --permanent --add-port=3434/tcp
sudo firewall-cmd --reload
```

**firewalld Service Configuration:**
- Uses `ftp` service definition (includes ports 21,20)
- Required for both active and passive modes
- Monitor `firewalld` logs for connection attempts

## Connecting as FTP Client

### Overview
FTP clients connect using command-line tools, graphical interfaces like FileZilla, or web browsers. Anonymous access doesn't require authentication, while local user access needs valid system credentials. Various connection methods provide flexibility.

### Key Concepts

**Command-Line Usage:**
```bash
# Connect to localhost
ftp localhost

# Connect with specific port
ftp localhost 3434

# Login commands
Name: anonymous
Password: user@domain.com (email format)
```

**Connection Examples:**
- Anonymous: `ftp localhost` → use "anonymous" as username
- Local user: `ftp localhost` → use system username/password
- Custom port: `ftp localhost 3434`

**Common FTP Commands:**
```bash
# Navigate directories
ls        # List files
cd dir    # Change directory
pwd       # Show current directory

# Transfer files
get file  # Download file
put file  # Upload file
mget *.txt # Multiple downloads
mput *.txt # Multiple uploads

# Session management
bye       # Exit FTP session
```

**GUI Alternatives:**
- FileZilla: Cross-platform FTP client
- Web browsers: Support basic functionality (limited)
- Mobile apps: Termux, FTP clients with similar commands

## Managing Users and Access

### Overview
FTP access control uses user lists and directory restrictions. Anonymous users can be enabled/disabled while local users are managed through system accounts. Custom root directories and permission masks enhance security.

### Key Concepts

**User List Management:**
```bash
# Deny users in /etc/vsftpd/ftpusers
# Format: one username per line
root
nobody
# Add users to deny access

# Allow list management
userlist_enable=YES
userlist_deny=YES  # Deny users in list
userlist_file=/etc/vsftpd/user_list
```

**Custom Root Directory:**
```bash
# Set custom root for anonymous users
anon_root=/custom/directory

# Example configuration
listen_port=3434  # Custom port
anon_root=/home/ftp/share
```

**Access Control Features:**
- **Directory Permissions**: Use `chmod` for read/write access
- **File Masks**: `file_open_mode` controls creation permissions
- **User Groups**: System groups determine access levels

**Security Enhancements:**
```bash
# Restrict local users to home directory
chroot_local_user=YES

# Set maximum connections
max_clients=10
max_per_ip=5
```

## Lab Demonstration

### Overview
Practical configuration shows vsftpd setup from installation to client connection. The demo covers anonymous user enablement, service management, and file transfers between local and remote machines.

### Lab Steps

1. **Install vsftpd packages:**
```bash
sudo yum install vsftpd ftp  # Install packages
sudo systemctl enable --now vsftpd  # Enable and start service
```

2. **Configure anonymous access:**
```bash
sudo vi /etc/vsftpd/vsftpd.conf
# Change anonymous_enable=NO to anonymous_enable=YES
sudo systemctl restart vsftpd
```

3. **Set up firewall:**
```bash
sudo firewall-cmd --permanent --add-service=ftp
sudo firewall-cmd --reload
```

4. **Create test content:**
```bash
sudo mkdir /var/ftp/pub/test
echo "Test content" | sudo tee /var/ftp/pub/test/file.txt
sudo chmod 755 /var/ftp/pub
```

5. **Client connection:**
```bash
ftp localhost
# Username: anonymous
# Password: user@email.com
ls                    # List files
cd pub                # Navigate directories  
get test/file.txt     # Download file
bye                   # Exit
```

6. **Verify transfer:**
```bash
ls -la file.txt       # Check downloaded file
cat file.txt         # Verify content
```

## Summary

> [!IMPORTANT]
> FTP enables file sharing between systems but lacks security. Use SFTP or FTPS for sensitive data transfers over networks.

### Key Takeaways
```diff
+ FTP basics: Standard protocol for file transfers using ports 21/20
+ Configuration: vsftpd.conf controls server behavior and access
+ Security: Not encrypted - avoid for sensitive data over internet
+ Alternatives: SFTP (SSH-based) or FTPS (TLS-encrypted) preferred
+ Practical: Anonymous access, local users, directory restrictions
- Limitations: Clear text transmission, vulnerable to interception
```

### Quick Reference

**Installation:**
```bash
sudo yum install vsftpd ftp
sudo systemctl enable --now vsftpd
```

**Basic Configuration:**
```bash
# /etc/vsftpd/vsftpd.conf
anonymous_enable=YES
local_enable=YES
write_enable=YES
```

**Client Usage:**
```bash
ftp hostname [port]
# Commands: ls, cd, get, put, mget, mput, bye
```

**Ports & Services:**
- Control: Port 21 (commands)
- Data: Port 20 (active mode transfers)
- Service: `vsftpd`

### Expert Insight

**Real-world Application**: FTP servers are commonly deployed in private networks for software distribution, backup systems, and content management. Enterprises use them behind VPNs for secure file sharing among trusted users.

**Expert Path**: Master SFTP implementation with SSH keys for passwordless authentication. Learn to integrate with LDAP/AD for enterprise user management and implement monitoring tools like fail2ban for intrusion detection.

**Common Pitfalls**: Avoid using FTP over public internet without encryption. Never run as root user. Always configure user restrictions and monitor logs for suspicious activity.

</details>
