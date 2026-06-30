# Section 8: 10 Steps to a Secure Linux Server

<details open>
<summary><b>Section 8: 10 Steps to a Secure Linux Server (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [8.1 10 Steps to a Secure Linux Server - Part I](#81-10-steps-to-a-secure-linux-server---part-i)
- [8.2 10 Steps to a Secure Linux Server - Part II](#82-10-steps-to-a-secure-linux-server---part-ii)
- [8.3 Wired & Wireless Security in Linux](#83-wired--wireless-security-in-linux)
- [8.4 Securing GRUB](#84-securing-grub)
- [Summary](#summary)

---

## 8.1 10 Steps to a Secure Linux Server - Part I

### Overview
This module introduces the first five critical steps for securing any Linux server, applicable across all major distributions. The focus begins with foundational security measures from hardware-level protections through network security configurations.

### Step 1: Hardware and BIOS Security

#### Physical Security Measures
- **Locking Server Case**: Implement physical locking mechanisms for server hardware
- **Server Room Security**: Ensure server rooms and racks have appropriate physical access controls
- **Environmental Controls**: Consider temperature, humidity, and power conditioning for hardware protection

#### Hardware Redundancy
Implementing fault tolerance at the hardware level:

| Component | Redundancy Options | Purpose |
|-----------|-------------------|---------|
| Power Supplies | Dual PSUs (common in servers) | Prevent single point of power failure |
| Network Interface Cards | 4+ NICs with bonding/teaming | Ensure network connectivity failover |
| Storage Devices | RAID 1, RAID 5, RAID 10 | Protect against disk failures |

#### BIOS/UEFI Security
```bash
# BIOS/UEFI Configuration Requirements
- Set complex password for BIOS/UEFI access
- Disable unnecessary boot devices
- Enable secure boot when available
- Password protect boot order modifications
```

> [!IMPORTANT]
> Hardware and BIOS security forms the foundation - without physical security, all other measures can be bypassed.

### Step 2: Installation Considerations

#### Minimal Installation Strategy
Choose minimal/distribution variants without GUI:

| Distribution | Minimal Install Option | Benefits |
|--------------|----------------------|----------|
| Debian | Server install (no GUI) | Reduced attack surface |
| CentOS/RHEL | Minimal/Minimal Install | Fewer packages to secure |
| Alpine | Default minimal design | Smallest footprint |
| Ubuntu | Server edition | No desktop components |

#### Partition Scheme Planning
```bash
# Recommended partition separation
/          # Root filesystem
/home      # User home directories (separate mount)
/var       # Variable data, logs
/tmp       # Temporary files (consider tmpfs)
/boot      # Boot files (separate for encryption)
```

#### Authentication During Installation
- Set lengthy, complex root password
- Create strong primary user account password
- Consider automated password policies

### Step 3: Post-Installation Security

#### System Updates
```bash
# Debian/Ubuntu update process
sudo apt update
sudo apt upgrade -y

# Check system information
uname -a

# Example Debian output showing security level
Linux server 6.1.0-18-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.76-1 (2024-02-01) x86_64 GNU/Linux
```

#### Kernel Management Without Reboot
```bash
# Ubuntu Livepatch for kernel updates without reboot
sudo snap install canonical-livepatch
sudo canonical-livepatch enable [TOKEN]

# Benefits:
# - Zero downtime updates
# - Critical security patches applied immediately
# - Maintains system availability
```

#### Security Mailing Lists
Subscribe to distribution-specific security lists:
- Debian Security: `debian-security-announce@lists.debian.org`
- Red Hat: `rhsa-announce@redhat.com`
- Ubuntu: `ubuntu-security-announce@lists.ubuntu.com`

#### File System Integrity
```bash
# Available integrity checking tools
aide          # Advanced Intrusion Detection Environment
tripwire      # File integrity monitoring
debsums       # Debian package verification
rpm -Va       # RPM package verification (RHEL/CentOS)
```

#### Cloud-Specific Security
```bash
# Create superuser and disable root SSH
sudo adduser adminuser
sudo usermod -aG sudo adminuser

# Disable root SSH access
sudo vim /etc/ssh/sshd_config
# Set: PermitRootLogin no
sudo systemctl restart sshd
```

### Step 4: System Hardening

#### Service Management
```bash
# Identify and remove unnecessary services
systemctl list-unit-files --type=service --state=enabled
sudo systemctl disable [unnecessary-service]
sudo apt purge [unnecessary-package]  # Debian/Ubuntu
sudo yum remove [unnecessary-package]  # RHEL/CentOS
```

#### Linux Security Modules
| Module | Distribution | Purpose |
|--------|-------------|---------|
| AppArmor | Ubuntu, Debian, SUSE | Application confinement |
| SELinux | RHEL, CentOS, Fedora | Mandatory access control |

```bash
# Enable security modules
sudo aa-enforce /etc/apparmor.d/*  # AppArmor
sudo setenforce 1                   # SELinux enforcing mode
```

#### Security Tools
```bash
# Install security monitoring tools
sudo apt install fail2ban clamav rkhunter

# fail2ban: Blocks malicious connection attempts
# ClamAV: Antivirus scanning
# rkhunter: Rootkit detection
```

### Step 5: Secure Networking

#### Secure File Transfer Protocols
```bash
# SFTP - SSH File Transfer Protocol
sftp user@server

# rsync over SSH (most used by instructor)
rsync -avz --progress /local/path/ user@server:/remote/path/

# SMB/CIFS with encryption
mount -t cifs //server/share /mnt/point -o credentials=/etc/samba/creds,seal
```

#### Kernel Network Security Parameters
```bash
# /etc/sysctl.conf or /etc/sysctl.d/99-security.conf

# Disable ICMP redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Ignore ICMP broadcasts (Smurf attack protection)
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Enable TCP SYN cookies (SYN flood protection)
net.ipv4.tcp_syncookies = 1

# Apply changes
sudo sysctl -p
```

#### Network Security Checklist
- [ ] Verify IP addressing scheme
- [ ] Close unnecessary ports (`nmap localhost`)
- [ ] Check DNS forwarding configuration
- [ ] Implement firewall rules
- [ ] Consider CDN security (CloudFlare, etc.)

---

## 8.2 10 Steps to a Secure Linux Server - Part II

### Overview
Continuing with steps 6-10, this module covers user security, SSH hardening, firewall implementation, intrusion detection systems, and comprehensive backup/audit strategies.

### Step 6: Secure the Users

#### Password Security with PAM
Pluggable Authentication Modules (PAM) configuration:

```bash
# PAM configuration files location
/etc/pam.d/

# Common security modules
pam_unix.so      # Standard Unix authentication
pam_tally2.so    # Account lockout after failed attempts
pam_pwquality.so # Password complexity requirements
```

#### Multi-Factor Authentication (MFA)
Authentication factors:
1. **Something you know**: Password/PIN
2. **Something you have**: Smart card, USB key, authenticator app
3. **Something you are**: Biometrics (fingerprint, facial recognition)

```bash
# Example: Google Authenticator with SSH
sudo apt install libpam-google-authenticator
google-authenticator  # Run as user to configure
```

#### Principle of Least Privilege
```bash
# Create limited-purpose users
sudo useradd -m -s /bin/bash backupuser
sudo usermod -aG backup backupuser  # Add to specific group only

# Use sudo for administrative tasks
sudo systemctl restart nginx  # Instead of logging in as root

# Restrict sudo access
sudo visudo
# user ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
```

#### User Auditing
```bash
# Monitor user activities
sudo last          # Last logged in users
sudo lastb         # Failed login attempts
sudo aureport      # Audit report (if auditd installed)
sudo journalctl _AUDIT_TYPE=1  # Systemd audit logs
```

### Step 7: Use and Secure SSH

#### SSH Hardening Configuration
```bash
# /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
PermitEmptyPasswords no
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
AllowUsers adminuser backupuser
AllowGroups sshusers
```

#### SSH Key-Based Authentication
```bash
# Generate key pair on client
ssh-keygen -t ed25519 -C "user@hostname"

# Or RSA with higher bits
ssh-keygen -t rsa -b 4096

# Copy public key to server
ssh-copy-id -i ~/.ssh/id_ed25519.pub user@server

# Test connection
ssh -i ~/.ssh/id_ed25519 user@server
```

#### SSH Timeouts and Sessions
```bash
# Client-side timeout in ~/.ssh/config
Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3

# Server-side in sshd_config
ClientAliveInterval 300
ClientAliveCountMax 2
```

### Step 8: Set Up a Firewall

#### Linux Firewall Solutions
| Tool | Interface | Best For |
|------|-----------|----------|
| firewalld | High-level | Dynamic zones, RHEL family |
| nftables | Low-level | Modern replacement for iptables |
| UFW | Simplified | Ubuntu/Debian quick setup |
| iptables | Legacy | Maximum control, older systems |

```bash
# UFW example (Ubuntu)
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# firewalld example (RHEL/CentOS)
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

### Step 9: Set Up IDS/IPS

#### Intrusion Detection/Prevention Systems
| System | Type | Deployment |
|--------|------|------------|
| Snort | IDS/IPS | Network-based, signature matching |
| Suricata | IDS/IPS | Multi-threaded, protocol identification |

```bash
# Install Snort
sudo apt install snort

# Basic configuration
sudo vim /etc/snort/snort.conf
# Set HOME_NET to your network
# Configure rules path

# Run in IDS mode
sudo snort -A console -q -c /etc/snort/snort.conf -i eth0
```

### Step 10: Backup and Auditing

#### Backup Strategies
```bash
# Native Linux backup tools
cp -a /source /backup/           # Archive copy
scp -r /data user@backup:/dest/  # Secure copy
rsync -avz --delete /data/ backup:/data/  # Synchronization

# Advanced options
dd if=/dev/sda of=/backup/disk.img bs=4M  # Disk imaging
zfs send tank/data@backup | zfs receive backup/data

# Automation with cron
0 2 * * * /usr/local/bin/backup-script.sh >> /var/log/backup.log 2>&1
```

#### Third-Party Backup Tools
| Tool | Type | Features |
|------|------|----------|
| Borg | Deduplicating | Compression, encryption |
| Deja Dup | GUI/Simple | GNOME integration |
| Duplicati | Cross-platform | Cloud storage support |
| Syncthing | P2P sync | Real-time synchronization |

#### Log Review and Auditing
```bash
# System logging
sudo journalctl -xe                    # Systemd logs with errors
sudo journalctl -u sshd               # Service-specific logs
sudo journalctl --since "1 hour ago"  # Time-based filtering

# Log locations
/var/log/auth.log      # Authentication events (Debian)
/var/log/secure        # Authentication events (RHEL)
/var/log/syslog        # General system messages
```

#### Audit Checklist
- [ ] Verify backup integrity with test restores
- [ ] Check storage redundancy status
- [ ] Review user access patterns
- [ ] Analyze system performance metrics
- [ ] Document security incidents

---

## 8.3 Wired & Wireless Security in Linux

### Overview
This hands-on lab demonstrates practical kernel-level network security techniques applicable to both wired and wireless interfaces, including protocol blocking and network statistics analysis.

### Lab Environment Setup
- **Lab**: Lab 16 - Wired/Wireless Security
- **Primary System**: Debian server with ens3 interface
- **Connection**: SSH from client system
- **Requirements**: Two systems with network connectivity

### Blocking Protocols at Kernel Level

#### Initial Connectivity Test
```bash
# From client system
ping 10.0.2.51
# Should receive replies confirming connectivity
```

#### Creating Security Script
```bash
#!/bin/bash
# /etc/network/secure-interface-ens3.sh

echo 1 > /proc/sys/net/ipv4/icmp_echo_ignore_all
echo 0 > /proc/sys/net/ipv4/ip_forward

# Make executable
chmod +x /etc/network/secure-interface-ens3.sh
```

#### Integrating with Network Configuration
```bash
# Edit /etc/network/interfaces
auto ens3
iface ens3 inet static
    address 10.0.2.51
    netmask 255.255.255.0
    gateway 10.0.2.1
    pre-up /etc/network/secure-interface-ens3.sh
```

#### Verification
```bash
# After reboot, test from client
ping 10.0.2.51
# Result: Destination Host Unreachable

# Restore normal operation
# Comment out pre-up line and reboot
```

### Network Interface Statistics Analysis

#### Accessing Statistics
```bash
# Navigate to network statistics
cd /sys/class/net/enp1s0/statistics

# Key statistics files
cat rx_packets    # Received packets
cat tx_packets    # Transmitted packets
cat rx_bytes      # Received bytes
cat tx_bytes      # Transmitted bytes
cat collisions    # Network collisions
cat rx_errors     # Receive errors
cat tx_errors     # Transmit errors
```

#### Real-Time Monitoring
```bash
# Watch packets in real-time
watch -n 1 cat /sys/class/net/enp1s0/statistics/rx_packets

# Monitor multiple statistics
watch -n 1 'echo "RX: $(cat rx_bytes) TX: $(cat tx_bytes)"'

# Generate traffic for testing
ping -s 1472 -f target_ip  # Flood ping with large packets
```

### Important Kernel Directories

#### Network Configuration Paths
| Path | Purpose | Contents |
|------|---------|----------|
| `/sys/class/net/` | Interface info | Device directories, flags, statistics |
| `/proc/sys/net/` | Runtime config | IPv4/IPv6 settings, netfilter parameters |
| `/proc/sys/net/ipv4/` | IPv4 tuning | ICMP, TCP, forwarding settings |
| `/proc/sys/net/netfilter/` | Firewall params | Connection tracking settings |

---

## 8.4 Securing GRUB

### Overview
This lab covers securing the GRUB bootloader against unauthorized access while maintaining usability, including password configuration with PBKDF2 encryption and boot parameter modifications.

### Lab Environment
- **Lab**: Lab 17 - Securing GRUB
- **System**: Debian client
- **GRUB Version**: GRUB 2 (grub-pc package)
- **Goal**: Password protect GRUB menu access

### Accessing GRUB Command Line

#### Boot Process Interruption
1. Reboot the system
2. Press `C` key immediately at boot
3. Access GRUB command prompt

#### GRUB Command Examples
```grub
grub> vbeinfo
# Display available video modes
# Example: 1920x1200x16 (resolution x color depth)

grub> set pager=1
# Enable pagination for long output

grub> set
# View all GRUB variables

grub> ls
# List available devices and partitions
```

#### Boot Menu Options
- **Debian**: Standard boot option
- **Advanced options**: Previous kernel versions
- **Recovery mode**: Emergency boot with minimal services

### Configuring GRUB Password

#### Edit Custom Configuration
```bash
# File: /etc/grub.d/40_custom
#!/bin/sh
exec tail -n +3 $0

set superusers="user"
password_pbkdf2 user grub.pbkdf2.sha512.10000.[HASH]
```

#### Generate PBKDF2 Password
```bash
# Install if needed
sudo apt install grub-pc-bin

# Generate password hash
grub-mkpasswd-pbkdf2
# Enter password twice
# Copy the resulting hash

# Example output format:
# grub.pbkdf2.sha512.10000.ABC123...DEF456
```

#### Update GRUB Configuration
```bash
sudo update-grub
# Regenerates /boot/grub/grub.cfg with new settings
```

### Advanced GRUB Security

#### Unrestricted Boot Configuration
```bash
# File: /etc/grub.d/10_linux
# Find the line:
menuentry "Debian GNU/Linux" --class debian --class gnu-linux --class gnu --class os --unrestricted {
```

#### Verification Process
1. Reboot system
2. Normal boot proceeds without password
3. Press `C` to enter GRUB menu
4. Username/password required for menu access

### Security Considerations

#### Password Best Practices
- Use strong, complex passwords
- PBKDF2 provides strong hashing (SHA-512)
- 10,000 iterations minimum
- Store backup of configuration securely

#### Recovery Considerations
- Document GRUB password securely
- Maintain access to rescue media
- Test password before relying on it
- Consider multiple authorized users

```diff
! GRUB Security Flow:
! Normal Boot → No Password Required (--unrestricted)
! Press 'C' → Username/Password Required → GRUB Menu Access
```

</details>