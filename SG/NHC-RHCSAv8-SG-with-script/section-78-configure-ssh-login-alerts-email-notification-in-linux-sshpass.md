# Section 78: SSH Login Alerts and SSH Pass Usage

<section-78-ssh-login-alerts-and-ssh-pass.md>

<details open>
<summary><b>Section 78: SSH Login Alerts and SSH Pass Usage (CL-KK-Terminal)</b></summary>

## Table of Contents
1. [SSH Login Alerts](#ssh-login-alerts)
   - Overview
   - Prerequisites and Installation
   - Configuring Alerts for Root User
   - Testing and Customization
   - Common Issues and Solutions
2. [SSH Pass Usage](#ssh-pass-usage)
   - Overview and Benefits
   - Installation
   - Using SSH Pass for Login
   - Running Remote Commands
   - File Copy Examples
   - Password from File
3. [Summary](#summary)

## SSH Login Alerts

### Overview
SSH login alerts are critical security mechanisms that notify administrators when someone logs into critical servers, especially as root or privileged users. These alerts help prevent unauthorized access and allow immediate response to suspicious activities. This section covers configuring email alerts for SSH logins using built-in Linux mail utilities.

### Prerequisites and Installation
Before configuring SSH login alerts, ensure your system has the necessary mail packages installed:

```bash
# Install required packages for mail functionality
yum install postfix mailx -y  # CentOS/RHEL
# or
apt install postfix mailutils -y  # Ubuntu/Debian
```

Enable and start the postfix service:

```bash
systemctl enable postfix
systemctl start postfix
systemctl status postfix
```

### Configuring Alerts for Root User

The alerts are configured in the `.bashrc` profile file for the user you want to monitor. For root user security alerts:

1. Open the root's `.bashrc` file:
   ```bash
   vi ~/.bashrc
   ```

2. Add the alert script at the end of the file:
   ```bash
   # SSH Login Alert Configuration
   echo "Alert: Root Login Detected" | mail -s "Alert Root Access" root@localhost
   ```

The complete configuration includes hostname, user details, login time, and message:
```bash
echo "Alert: Root Login from $(hostname -f) by $(whoami) at $(date)" | mail -s "Alert Root Access" root@localhost
```

❗ **Note**: Use organizational email addresses. Public email providers (Gmail, Yahoo) have become stricter with security and may reject these emails due to relay restrictions.

### Testing and Customization
After configuration, test the alert by logging in as root:

```bash
# Check mail queue
mail -u root

# View mail content
1  # Enter mail number
```

The email will contain:
- Subject: "Alert Root Access"
- Body: Alert message with hostname, username, and timestamp

#### Customizing Email Recipients
To send alerts to different email addresses, modify the mail command:

```bash
echo "Alert: Root Login from $(hostname -f) by $(whoami) at $(date)" | mail -s "Alert Root Access" your-org-admin@yourcompany.com
```

### Common Issues and Solutions

> [!CAUTION]
> **Security Context**: Always test alerts in non-production environments first to avoid alert fatigue or blocking critical users.

**Common Problems:**
- Public email rejection: Gmail/Yahoo block relay emails
- Mail server configuration: Ensure postfix is properly configured
- Network restrictions: Firewall rules may block SMTP traffic

**Solutions:**
- Use internal organizational mail servers
- Configure relay settings properly
- Test with local mail delivery first (`root@localhost`)

## SSH Pass Usage

### Overview and Benefits
SSH pass is a utility that allows automating SSH password entry when interactive input isn't supported or for scripted operations. It's particularly useful for:

- Automated deployments and backups
- Scripted remote server management
- File transfers without manual intervention
- SSH tunneling and remote command execution

Key advantages:
- Eliminates manual password prompts
- Enables automation in scripts
- Supports password masking for security

### Installation

Install SSH pass using package managers:

```bash
# Add EPEL repository if needed (CentOS/RHEL)
yum install epel-release -y

# Install SSH pass
yum install sshpass -y

# Verify installation
sshpass -V
```

Alternative installation from source:
```bash
wget https://sourceforge.net/projects/sshpass/files/latest/download
tar -xzf sshpass-*.tar.gz
cd sshpass-*
./configure && make && make install
```

### Using SSH Pass for Login

**Basic SSH login with password:**
```bash
sshpass -p 'YourPassword' ssh user@localhost
```

**With additional options to bypass host verification:**
```bash
sshpass -p 'YourPassword' ssh -o StrictHostKeyChecking=no user@localhost
```

**Complete remote login example:**
```bash
sshpass -p 'MyPass123' ssh -o StrictHostKeyChecking=no root@remote-server.com
```

### Running Remote Commands

Execute commands on remote servers without interactive login:

```bash
# Single command
sshpass -p 'password' ssh -o StrictHostKeyChecking=no user@remote-server 'ls -la /home'

# Multiple commands
sshpass -p 'password' ssh -o StrictHostKeyChecking=no user@remote-server 'cd /var/log && tail -f syslog'
```

### File Copy Examples

**Copy local file to remote server:**
```bash
sshpass -p 'password' scp -o StrictHostKeyChecking=no local-file.txt user@remote-server:/remote/path/
```

**Copy file between two remote servers via local machine:**
```bash
sshpass -p 'password' scp -o StrictHostKeyChecking=no user@server1:/path/file.txt user@server2:/path/
```

**Copy directory with options:**
```bash
sshpass -p 'password' scp -o StrictHostKeyChecking=no -r /local/directory user@remote:/remote/
```

### Password from File

For enhanced security, store passwords in files rather than command line:

```bash
# Create password file (secure permissions)
echo 'MySecurePassword123' > ~/.sshpassword
chmod 600 ~/.sshpassword

# Use password from file
sshpass -f ~/.sshpassword ssh -o StrictHostKeyChecking=no user@remote-server

# SSH login using password file
sshpass -f /path/to/password-file ssh user@hostname
```

## Summary

### Key Takeaways
```diff
+ SSH login alerts provide immediate notification for security incidents
+ SSH pass enables automation for password-requiring SSH operations
+ Always test mail configurations and use secure password storage
- Public email providers may reject SSH alerts due to security policies
- Never store plaintext passwords in scripts without proper security measures
```

### Quick Reference
**SSH Alert Commands:**
- Install postfix: `yum install postfix mailx -y && systemctl enable postfix && systemctl start postfix`
- Check mail: `mail -u root`
- Configure alerts in `~/.bashrc`

**SSH Pass Commands:**
- Basic login: `sshpass -p 'pass' ssh -o StrictHostKeyChecking=no user@host`
- Remote command: `sshpass -p 'pass' ssh user@host 'command'`
- File copy: `sshpass -p 'pass' scp source dest`

### Expert Insight

**Real-world Application**: In production environments, combine SSH login alerts with centralized logging systems like syslog-ng or ELK stack for comprehensive monitoring. SSH pass is commonly used in CI/CD pipelines for automated deployment scripts.

**Expert Path**: Master SSH key-based authentication instead of passwords for production servers. Use SSH pass only for legacy systems during migration periods. Learn Ansible for advanced automation beyond basic SSH operations.

**Common Pitfalls**: 
- Alert spam from legitimate users leading to ignored warnings
- Weak passwords in SSH pass commands visible in shell history
- Network policies blocking mail relay for internal alerts
- Forgetting to disable StrictHostKeyChecking in automation environments

</details>
