<details open>
<summary><b>Section 123: Samba Server and Clients Configuration (CL-KK-Terminal)</b></summary>

# Section 123: Samba Server and Clients Configuration

## Table of Contents
- [Samba Overview](#samba-overview)
- [Samba Installation and Basic Setup](#samba-installation-and-basic-setup)
- [Configuring Anonymous Samba Share](#configuring-anonymous-samba-share)
- [Accessing Samba Shares from Windows Client](#accessing-samba-shares-from-windows-client)
- [Configuring Secure Samba Share](#configuring-secure-samba-share)
- [Accessing Samba Shares from Linux Client](#accessing-samba-shares-from-linux-client)
- [Troubleshooting Samba Issues](#troubleshooting-samba-issues)

## Samba Overview

### Overview
This section introduces Samba server configuration, covering its history, ports, security aspects, and practical implementation of both anonymous and authenticated file shares across different operating systems. The instructor demonstrates real-world configuration on Linux with client access from Windows and Linux machines.

### Key Concepts
Samba is a free, open-source software implementing the Server Message Block (SMB) protocol for file and print sharing across different operating systems.

#### Samba History and Key Information
- **Full Name**: Server Message Block (SMB)
- **Developed By**: Andrew Tridgell
- **Release Date**: December 1991 - January 1992 in UNIX
- **Current Version**: Supports Active Directory and Windows domains

#### Samba Ports and Services
Samba uses three main services:

1. **SMB Service** (smbd):
   - Purpose: File and print sharing
   - Ports: 139 and 445
   - Listens on TCP ports for client connections

2. **NMB Service** (nmbd):
   - Purpose: NetBIOS name resolution
   - Port: 137
   - Handles network browsing and name resolution

#### Security and Usage Considerations
```diff
+ Benefits: Cross-platform file sharing, mature protocol
- Security Concerns: SMBv1 is unencrypted and vulnerable
! Recommendation: Use SMBv2/v3 with encryption for secure environments
```

### Code/Config Blocks

#### Samba Services Check
```bash
systemctl status smb.service
systemctl status nmb.service
```

## Samba Installation and Basic Setup

### Overview
The initial setup involves installing Samba packages, configuring basic server settings, and preparing the directories for sharing.

### Key Concepts
Before configuration, ensure repositories are configured and install the necessary Samba packages.

#### Package Installation
```bash
yum install samba samba-client samba-common -y
# or on Debian/Ubuntu:
# apt-get install samba samba-client samba-common
```

#### Service Management
```bash
# Enable and start Samba services
systemctl enable smb.service nmb.service
systemctl start smb.service nmb.service

# Restart services after configuration changes
systemctl restart smb.service nmb.service
```

#### Firewall Configuration
```bash
# Add Samba to firewall
firewall-cmd --permanent --add-service=samba
firewall-cmd --reload
```

#### Testing Configuration
```bash
# Test Samba configuration for syntax errors
testparm
```

## Configuring Anonymous Samba Share

### Overview
Anonymous shares allow read/write access without user authentication. This is useful for public file sharing but should be used carefully due to security implications.

### Key Concepts

#### Directory Setup
```bash
# Create share directory
mkdir -p /var/log/samba/public

# Set permissions (read access for all, write for owner)
chmod 0755 /var/log/samba/public

# Set ownership to nobody user
chown nobody:nobody /var/log/samba/public

# Configure SELinux context
semanage fcontext -a -t samba_share_t "/var/log/samba/public(/.*)?"
restorecon -R /var/log/samba/public
```

#### Samba Configuration (smb.conf)
Backup the original configuration first:

```bash
cp /etc/samba/smb.conf /etc/samba/smb.conf.backup
```

Global section configuration:

```bash
[global]
        workgroup = WORKGROUP
        server string = Samba Server v4
        netbios name = samba-server
        security = user
        map to guest = Bad User
        dns proxy = no

# Anonymous share configuration
[public]
        path = /var/log/samba/public
        browsable = yes
        writable = yes
        guest ok = yes
        read only = no
```

## Accessing Samba Shares from Windows Client

### Overview
Windows provides native support for accessing Samba shares through network browsing or direct connection.

### Key Concepts

#### Network Access Methods

1. **Via Network Browsing**:
   - Press Windows + R, type `\\server-name`, click OK
   - Or use `\\IP-address\share-name`

2. **Check Workgroup Configuration**:
   ```cmd
   net config workstation
   ```

#### Connecting to Anonymous Share
```cmd
# Direct connection to server
\\192.168.0.143
```

#### Created File Verification
After creating files in the share, they appear with "nobody" ownership since it's an anonymous share:

```bash
ls -l /var/log/samba/public
-rwxrwxrwx. 1 nobody nobody 0 Aug 22 2022 example.txt
```

## Configuring Secure Samba Share

### Overview
Secure shares require user authentication, providing controlled access with proper permissions and security.

### Key Concepts

#### User and Group Setup
```bash
# Create secure group
groupadd secure-group

# Create user and add to group
useradd -G secure-group demo-user

# Set Samba password for user
smbpasswd -a demo-user

# Verify user membership
id demo-user
```

#### Directory Setup
```bash
# Create secure share directory
mkdir -p /var/log/samba/secure

# Set restrictive permissions (owner and group only)
chmod 0770 /var/log/samba/secure

# Set ownership
chown root:secure-group /var/log/samba/secure

# Configure SELinux context
semanage fcontext -a -t samba_share_t "/var/log/samba/secure(/.*)?"
restorecon -R /var/log/samba/secure
```

#### Samba Configuration Addition
Add to smb.conf:

```bash
[secure]
        path = /var/log/samba/secure
        valid users = @secure-group
        guest ok = no
        writable = yes
        browsable = yes
```

Restart services after configuration:

```bash
systemctl restart smb.service nmb.service
```

## Accessing Samba Shares from Linux Client

### Overview
Linux clients use command-line tools for Samba connections, providing reliable mounting and file operations.

### Key Concepts

#### Package Installation
```bash
yum install samba-client cifs-utils -y
# or
apt-get install samba-client cifs-utils
```

#### Share Discovery
```bash
# List available shares on server
smbclient -L 192.168.0.143 -U demo-user
```

#### Manual Mounting
```bash
# Create mount point
mkdir -p /mnt/secure-share

# Mount with authentication
mount -t cifs //192.168.0.143/secure /mnt/secure-share -o username=demo-user,password=your-password,vers=3.0

# Verify mount
df -h | grep secure
```

#### Permanent Mount (fstab)
Add to `/etc/fstab`:

```
//192.168.0.143/secure    /mnt/secure-share    cifs    username=demo-user,password=your-password,vers=3.0    0 0
```

Remount all filesystems:
```bash
mount -a
```

## Troubleshooting Samba Issues

### Overview
Common issues include connection authentication failures, file permission problems, and SELinux/AppArmor conflicts.

### Key Concepts

#### Windows Connection Issues
```diff
- Windows Firewall blocking connections
- Antivirus interference
- Multiple concurrent connections from same user
- Incorrect workgroup settings

! Solutions:
- Temporarily disable antivirus/firewall for testing
- Use IP address instead of hostname
- Ensure single user connection (Windows limitation)
```

#### Linux Mounting Issues
```diff
- SELinux context not set
- Authentication failures
- Permission denied errors

! Solutions:
- Check SELinux contexts with 'semanage fcontext'
- Verify user group membership
- Use correct CIFS options (vers=3.0)
```

#### Service-Related Problems
```bash
# Check service status
systemctl status smb.service nmb.service

# View logs for errors
journalctl -u smb.service --since "1 hour ago"

# Test configuration syntax
testparm /etc/samba/smb.conf
```

### Tables

| Service | Port | Purpose | Protocol |
|---------|------|---------|----------|
| smbd | 139, 445 | File/Print Sharing | TCP |
| nmbd | 137 | NetBIOS Resolution | UDP |

### Alerts
> [!IMPORTANT]
> Always use SMBv2 or later (vers=3.0) for security. SMBv1 is deprecated and vulnerable.

> [!NOTE]
> Restart Samba services after any configuration changes for settings to take effect.

> [!WARNING]
> Anonymous shares provide no security - avoid for sensitive data.

## Summary

### Key Takeaways
```diff
+ Cross-platform file sharing with SMB protocol
+ Anonymous shares for public access, authenticated shares for security
+ Windows native support, Linux requires samba-client tools
+ SELinux/AppArmor integration critical for proper file access
+ Services: smbd (file/print), nmbd (name resolution)
- SMBv1 unencrypted - use newer versions
! Common troubleshooting: check firewall, permissions, SELinux context
```

### Quick Reference

#### Essential Commands
- `yum install samba*` - Install Samba packages
- `systemctl start smb nmb` - Start services
- `testparm` - Validate configuration
- `smbclient -L server -U user` - List shares
- `mount -t cifs //server/share /mnt` - Mount share

#### Configuration File: `/etc/samba/smb.conf`
```
[global]
    workgroup = WORKGROUP
    security = user

[share-name]
    path = /path/to/directory
    browsable = yes
    writable = yes
    guest ok = no/yes
    valid users = username/@group
```

### Expert Insight

#### Real-world Application
> [!NOTE]
> Samba excels in heterogeneous environments where multiple OS platforms need file sharing. Common use cases include:
> - Enterprise file servers replacing Windows-only solutions
> - NAS devices with mixed client operating systems
> - Domain-joined Linux servers in Windows environments
> - Cross-platform collaboration scenarios

#### Expert Path
**Master Samba by exploring:**
1. Active Directory integration with `realm join`
2. LDAP authentication backends
3. Advanced ACLs with `vfs objects`
4. Performance tuning with socket options
5. Cluster configurations with CTDB

#### Common Pitfalls
```diff
- Forgetting SELinux/AppArmor configurations
- Using outdated SMB versions in modern environments
- Misconfigured workgroups causing discovery failures
- Permissions conflicts between Samba and filesystem settings
- Firewall rules blocking required ports without exception
```

</details>
