<details open><summary><b>Section 75: SSH Options (CL-KK-Terminal)</b></summary>

# Section 75: SSH Options

## Table of Contents
- [SSH Welcome Banner](#ssh-welcome-banner)
  - [Pre-Login Welcome Banner](#pre-login-welcome-banner)
  - [Post-Login Welcome Banner](#post-login-welcome-banner)
- [Disabling Root Login via SSH](#disabling-root-login-via-ssh)
- [Changing Default SSH Port](#changing-default-ssh-port)
- [Summary](#summary)

## SSH Welcome Banner
SSH welcome banners are text messages displayed to users when connecting to a server. They can be set up before or after login to enhance security, provide information, or for branding purposes. There are two types: pre-login (before authentication) and post-login (after successful login).

### Pre-Login Welcome Banner
This banner appears before the user enters their password. It's configured via the SSH daemon configuration.

**Overview**: 2-3 minutes setup to display a custom message before authentication, improving user experience and security awareness.

**Key Concepts**:
- Create the banner file in `/etc/ssh/banner.txt` with desired text.
- Edit `/etc/ssh/sshd_config` to enable the banner option.
- Restart the SSH service for changes to take effect.

**Steps**:
1. Create the banner file:
   ```bash
   sudo vi /etc/ssh/banner.txt
   ```
   Add content like:
   ```
   Welcome to DevOps Training!
   Subscribe to our YouTube channel for more tutorials.
   ```

2. Edit SSH configuration:
   ```bash
   sudo vi /etc/ssh/sshd_config
   ```
   Uncomment and set:
   ```bash
   Banner /etc/ssh/banner.txt
   ```

3. Restart SSH service:
   ```bash
   sudo systemctl restart sshd
   ```

**Verification**:
- Connect via SSH: `ssh root@localhost`
- The banner should display before prompting for password.

> [!NOTE]
> Supports ASCII art for visual appeal, but ensure compatibility with terminal displays.

### Post-Login Welcome Banner
This banner appears after successful login. It's handled by the MOTD (Message of the Day) system.

**Overview**: 1-2 minutes to set up a message that greets users post-authentication.

**Key Concepts**:
- Use `/etc/motd` file for MOTD.
- Content displays automatically after login.
- Useful for production server warnings or welcome messages.

**Steps**:
1. Edit MOTD file:
   ```bash
   sudo vi /etc/motd
   ```
   Add content like:
   ```
   Welcome to Production Server!
   Handle with care - Production Environment.
   ```

2. Restart SSH service if needed (though MOTD updates immediately):
   ```bash
   sudo systemctl restart sshd
   ```

**Verification**:
- SSH login: `ssh dev@localhost`
- Banner appears after password entry.

```diff
+ Pre-login banner: Enhances security by showing terms before access
- Post-login banner: Ideal for personalized greetings or warnings
```

## Disabling Root Login via SSH
For security, direct root login via SSH is disabled to prevent unauthorized access and enable accountability.

**Overview**: Modify SSH config to deny root login, requiring users to log in as normal users and switch to root.

**Key Concepts**:
- Auditability: Tracks which user switched to root.
- Prevents brute-force attacks on root account.
- Uses `PermitRootLogin no` in config.

**Steps**:
1. Edit SSH config:
   ```bash
   sudo vi /etc/ssh/sshd_config
   ```
   Set:
   ```bash
   PermitRootLogin no
   ```

2. Restart service:
   ```bash
   sudo systemctl restart sshd
   ```

**Verification**:
- Attempt SSH as root: `ssh root@localhost` → "Permission denied"
- Normal user login works: `ssh dev@localhost`
- Switch to root: `su root` (after login)

> [!IMPORTANT]
> Always test with a normal user account to ensure access is preserved.

## Changing Default SSH Port
Default SSH port (22) is often targeted by attackers. Changing it enhances security.

**Overview**: 5-10 minutes process involving config edit, firewall update, and service restart.

**Key Concepts**:
- Change from port 22 to custom port (e.g., 5152).
- Update firewalls and SELinux if applicable.
- Use tools like `firewall-cmd` for CentOS/RHEL.

**Steps**:
1. Edit SSH config:
   ```bash
   sudo vi /etc/ssh/sshd_config
   ```
   Uncomment and set:
   ```bash
   Port 5152
   ```

2. Update firewall:
   ```bash
   sudo firewall-cmd --permanent --add-port=5152/tcp
   sudo firewall-cmd --reload
   ```
   Or for `ufw`:
   ```bash
   sudo ufw allow 5152/tcp
   ```

3. Restart SSH:
   ```bash
   sudo systemctl restart sshd
   ```

**Verification**:
- Connect on new port: `ssh root@localhost -p 5152`
- Old port blocked: Port 22 denies connections.

```diff
! Use non-standard ports like 5152 to avoid common scans
```

## Summary

### Key Takeaways
```diff
+ SSH banners enhance security and user communication
+ Disable root login for accountability and protection
+ Change ports to mitigate automated attacks
! Always backup configs before changes
- Avoid using default port 22 in production
```

### Quick Reference
- **Banner Setup**: Edit `/etc/ssh/sshd_config` + `/etc/motd`
- **Root Disable**: `PermitRootLogin no` in `/etc/ssh/sshd_config`
- **Port Change**: Edit port in `/etc/ssh/sshd_config`, update firewall
- **Service Restart**: `sudo systemctl restart sshd`

### Expert Insight
**Real-world Application**: In production, always disable root SSH login and use custom ports with monitoring tools like fail2ban.

**Expert Path**: Master SSH hardening by combining with key-based auth, rate limiting, and regular audits.

**Common Pitfalls**: Forgetting firewall updates leading to connection failures; ensure SELinux allows new ports.

</details>
