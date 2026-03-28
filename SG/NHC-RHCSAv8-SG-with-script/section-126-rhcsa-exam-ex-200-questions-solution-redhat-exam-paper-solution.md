# Section 126: RHCSA Exam Paper Solution Part 1

<details open>
<summary><b>Section 126: RHCSA Exam Paper Solution Part 1 (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Setting Up Hostname and Network Configuration (Question 1)](#setting-up-hostname-and-network-configuration-question-1)
- [Configuring Repositories for Packages (Question 2)](#configuring-repositories-for-packages-question-2)
- [Configuring Web Content on Port 82 (Question 3)](#configuring-web-content-on-port-82-question-3)
- [Creating Users, Groups, and Memberships (Question 4)](#creating-users-groups-and-memberships-question-4)
- [Creating Directories with Specific Permissions (Question 5)](#creating-directories-with-specific-permissions-question-5)
- [Summary](#summary)

## Overview
This session covers Part 1 of solving a sample RHCSA exam paper, focusing on the first 5 questions. The instructor demonstrates practical steps for RHCSA-related tasks, including hostname setup, network configuration, repository management, Apache configuration, user/group management, and directory permissions. The goal is to help beginners understand and implement these solutions in a simulated exam environment.

## Setting Up Hostname and Network Configuration (Question 1)
### Overview
The first question involves configuring the system's hostname, IP address, subnet mask, default gateway, DNS server, and data points for network connectivity.

### Key Concepts
- Hostname must match the exam-provided system name (e.g., `system128.example.com`).
- Network configuration requires setting static IP, gateway, and DNS.
- Ensure services remain enabled post-restart for scoring.

### Code/Config Blocks
Use `hostnamectl` to set hostname:
```bash
hostnamectl set-hostname system128.example.com
```
Verify hostname:
```bash
hostnamectl
```

For network configuration (e.g., on `ens160`):
```bash
nmcli con mod ens160 ipv4.addresses 192.168.1.100/24
nmcli con mod ens160 ipv4.gateway 192.168.1.1
nmcli con mod ens160 ipv4.dns 8.8.8.8
nmcli con mod ens160 ipv4.method manual
nmcli con up ens160
```

Test connectivity:
```bash
ping google.com
```

### Tables
| Component | Description |
|-----------|-------------|
| Hostname | Unique system identifier (e.g., system128.example.com) |
| IP Address | Static IP for network connectivity |
| Gateway | Default route for external access |
| DNS | Domain name resolution server |

## Configuring Repositories for Packages (Question 2)
### Overview
Configure repositories for base and app-stream packages using local server locations. Disable GPG checks and create YAML configuration files.

### Key Concepts
- Repositories point to local server URLs.
- Use `/etc/yum.repos.d/local.repo` for configuration.
- Enable repositories and ensure package installation works.

### Code/Config Blocks
Create `/etc/yum.repos.d/local.repo`:
```yaml
[base]
name=Base packages
baseurl=http://reposerver.example.com/BaseOS/
enabled=1
gpgcheck=0

[appstream]
name=AppStream packages
baseurl=http://reposerver.example.com/AppStream/
enabled=1
gpgcheck=0
```

Clean and list repositories:
```bash
dnf clean all
dnf repolist
```

### Lab Demos
Install a sample package:
```bash
dnf install vim -y
```

## Configuring Web Content on Port 82 (Question 3)
### Overview
Share web content from `/var/www/html` on port 82, removing old entries and setting up symbolic links or configuration for port-specific hosting.

### Key Concepts
- Install Apache (`httpd`) and enable on port 82.
- Configure SELinux for non-standard ports.
- Use `firewalld` to allow traffic.

### Code/Config Blocks
Install and enable httpd:
```bash
dnf install httpd -y
systemctl start httpd
systemctl enable httpd
```

Configure for port 82:
```bash
semanage port -a -t http_port_t -p tcp 82
```

Add Listen directive in `/etc/httpd/conf/httpd.conf`:
```apache
Listen 80
Listen 82
```

Create port-specific VirtualHost.

Test configuration:
```bash
apachectl configtest
certsemctl restart httpd
```

### Diff Blocks
```diff
+ Key Configuration: Added port 82 to httpd.conf and SELinux
- Avoid: Skipping SELinux port configuration, leading to access issues
```

> [!NOTE]
> Ensure SELinux is set to permissive or configured correctly for port 82.

## Creating Users, Groups, and Memberships (Question 4)
### Overview
Create an admin group, add users with specific group memberships, set passwords, and ensure interactive login settings.

### Key Concepts
- Use `groupadd`, `useradd` for creation.
- Set secondary groups and non-interactive users as needed.

### Code/Config Blocks
Create group and users:
```bash
groupadd admin
useradd -G admin harry
useradd -G admin natasha
useradd -s /sbin/nologin sarah
```

Set passwords:
```bash
passwd harry  # Set according to exam
passwd natasha
passwd sarah
```

Verify:
```bash
id harry  # Check groups
getent group admin  # List members
```

| User | Primary Group | Secondary Group | Interactive Login |
|------|----------------|-----------------|-------------------|
| harry | harry | admin | Yes |
| natasha | natasha | admin | Yes |
| sarah | sarah | none | No |

## Creating Directories with Specific Permissions (Question 5)
### Overview
Create a `/common` directory with admin group ownership, set permissions for read/write access to admin members, and configure setgid for automatic group inheritance.

### Key Concepts
- Use `chmod` for permissions, `chown` for ownership.
- Set setgid to ensure new files inherit group ownership.

### Code/Config Blocks
Create and configure directory:
```bash
mkdir /common
chown root:admin /common
chmod 2770 /common  # rwxrws---
```

Test:
```bash
ls -ld /common
su - harry
touch /common/testfile
ls -l /common/testfile  # Should show admin group
```

### Expert Insight
- **Real-world Application**: Directory permissions like these are crucial for shared environments in enterprise Linux setups, ensuring only authorized users can modify files.
- **Expert Path**: Practice with file ACLs (`setfacl`) for finer-grained control; master troubleshooting permission issues in exam scenarios.
- **Common Pitfalls**: Forgetting setgid bit leads to incorrect group ownership on new files; always verify with `ls -l` post-changes.

## Summary
### Key Takeaways
```diff
+ Hostname and network setup uses nmcli for consistency and persistency.
- Repository GPG checks may be disabled only when required; re-enable for production.
+ User/group management requires careful primary/secondary group assignment.
- Directory permissions without setgid can break group inheritance.
+ Apache configuration needs SELinux tweaks for custom ports.
```

### Quick Reference
- Set hostname: `hostnamectl set-hostname <name>`
- Network: `nmcli con mod <interface> ipv4.addresses <ip>/<mask> ipv4.gateway <gw> ipv4.dns <dns>`
- Repository: Create `.repo` in `/etc/yum.repos.d/` with baseurl and enabled=1, gpgcheck=0
- Apache port: `semanage port -a -t http_port_t -p tcp 82` in httpd.conf
- Users: `useradd -G <group> <user>`; `passwd <user>`
- Permissions: `chmod 2770 <dir>`; `chown root:<group> <dir>`

### Expert Insight
- **Real-world Application**: These configurations mirror enterprise server setups, where automation tools like Ansible can streamline exam tasks in production.
- **Expert Path**: Dive into Red Hat documentation for advanced SELinux policies; simulate full exam environments with nested VMs for hands-on mastery.
- **Common Pitfalls**: Services not enabled post-reboot affect scoring; always use `systemctl enable <service>`; test configurations thoroughly before "submitting" changes.

</details>
