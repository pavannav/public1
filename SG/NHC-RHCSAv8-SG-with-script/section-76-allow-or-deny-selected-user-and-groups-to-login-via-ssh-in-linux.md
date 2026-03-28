# Section 76: SSH Welcome Banner, Disable Root Login, and Change Default Port in Linux

<details open>
<summary><b>Section 76: SSH Welcome Banner, Disable Root Login, and Change Default Port in Linux (CL-KK-Terminal)</b></summary>

## Table of Contents
- [SSH Welcome Banner](#ssh-welcome-banner)
- [Disable Root Login](#disable-root-login)
- [Change Default Port](#change-default-port)
- [Summary](#summary)

## SSH Welcome Banner

### Overview
The SSH welcome banner is a message that is displayed to users when they successfully connect to the server via SSH. This can be used to display legal notices, security warnings, system information, or custom messages to help inform users about the environment they're accessing.

### Key Concepts
- **Banner File Location**: The banner content is typically stored in `/etc/ssh/sshd_banner`.
- **Configuration Updates**:
  - Edit `/etc/ssh/sshd_config` to enable the banner with the line: `Banner /etc/ssh/sshd_banner`
  - Ensure the banner file has appropriate permissions (readable by all).
- **Service Restart**: After changes, restart the SSH daemon using `systemctl restart sshd`.
- **Security Considerations**: Keep the banner brief and informative; avoid sensitive information.
- **Testing**: Connect from a client to verify the banner appears on login.

### Lab Demo
1. Create or edit the banner file:
   ```bash
   sudo vi /etc/ssh/sshd_banner
   ```
   Add content, e.g.:
   ```
   *******************************
   Welcome to Server XYZ
   Unauthorized access is prohibited.
   All activities are logged.
   *******************************
   ```

2. Set appropriate permissions:
   ```bash
   sudo chmod 644 /etc/ssh/sshd_banner
   ```

3. Edit the SSH configuration file:
   ```bash
   sudo vi /etc/ssh/sshd_config
   ```
   Add or uncomment:
   ```
   Banner /etc/ssh/sshd_banner
   ```

4. Restart the SSH service:
   ```bash
   sudo systemctl restart sshd
   ```

5. Test the connection from a client machine:
   ```bash
   ssh user@server
   ```
   You should see the banner message before the password prompt or login.

## Disable Root Login

### Overview
By default, SSH allows root login, which is a significant security risk as it exposes the administrative account to brute-force attacks. Disabling root login via SSH forces users to connect as regular users and then escalate privileges using sudo if needed.

### Key Concepts
- **Configuration Change**: In `/etc/ssh/sshd_config`, set `PermitRootLogin no` to disable direct root access.
- **Alternative Access**: Ensure at least one regular user account exists with sudo privileges before making this change to avoid lockout.
- **Password Authentication**: Optionally combine with public key authentication by setting `PasswordAuthentication yes` or `no`.
- **Service Management**: Always test configurations before applying to production.
- **Backup Best Practice**: Keep a session open during testing to recover if misconfigured.

### Lab Demo
1. Verify sudo access for a regular user:
   ```bash
   su - regularuser
   sudo whoami
   ```
   Ensure it returns "root".

2. Edit the SSH configuration:
   ```bash
   sudo vi /etc/ssh/sshd_config
   ```
   Set:
   ```
   PermitRootLogin no
   ```

3. Optionally enhance security with key-only authentication:
   In the same file, set:
   ```
   PasswordAuthentication no
   PubkeyAuthentication yes
   ```

4. Restart SSH service:
   ```bash
   sudo systemctl restart sshd
   ```

5. Attempt root login from a client (it should fail):
   ```bash
   ssh root@server
   ```
   Use regular user login instead: `ssh regularuser@server && sudo -i`.

## Change Default Port

### Overview
SSH runs on port 22 by default, which is well-known and targeted by attackers. Changing the default port to a non-standard one adds a layer of obscurity, making automated scans less effective while establishing a baseline security measure.

### Key Concepts
- **Port Selection**: Choose a port above 1024 to avoid system conflicts (e.g., 2222).
- **Firewall Configuration**: Update firewall rules to allow the new port.
- **SELinux Updates**: If SELinux is enforcing, update policies for the new port.
- **Client Connection**: Specify the port with `-p` in SSH commands.
- **Monitoring**: Regularly audit SSH logs for failed attempts.

### Lab Demo
1. Check current port:
   ```bash
   grep ^Port /etc/ssh/sshd_config
   ```

2. Edit SSH configuration:
   ```bash
   sudo vi /etc/ssh/sshd_config
   ```
   Change from `Port 22` to:
   ```
   Port 2222
   ```

3. Update firewall rules (firewalld):
   ```bash
   sudo firewall-cmd --permanent --add-port=2222/tcp
   sudo firewall-cmd --reload
   ```

4. If SELinux is enabled, update port context:
   ```bash
   sudo semanage port -a -t ssh_port_t -p tcp 2222
   ```

5. Restart SSH service:
   ```bash
   sudo systemctl restart sshd
   ```

6. Test connection with new port:
   ```bash
   ssh -p 2222 user@server
   ```

7. Verify old port is blocked:
   ```bash
   ssh user@server
   ```
   This should fail as port 22 is no longer listening.

## Summary

### Key Takeaways
```diff
+ Use SSH banner to display informative messages and warnings.
+ Disable root SSH login to prevent direct administrative access risks.
+ Change default SSH port for basic obscurity and protection from automated scans.
- Avoid exposing sensitive data in banners.
- Test all SSH changes thoroughly to prevent being locked out.
```

### Quick Reference
- **Banner Configuration**:
  ```
  echo "Welcome message" > /etc/ssh/sshd_banner
  vi /etc/ssh/sshd_config  # Add: Banner /etc/ssh/sshd_banner
  systemctl restart sshd
  ```
- **Disable Root Login**:
  ```
  vi /etc/ssh/sshd_config  # Change: PermitRootLogin no
  systemctl restart sshd
  ```
- **Change Default Port**:
  ```
  vi /etc/ssh/sshd_config  # Change: Port 2222
  firewall-cmd --permanent --add-port=2222/tcp && firewall-cmd --reload
  semanage port -a -t ssh_port_t -p tcp 2222
  systemctl restart sshd
  ```

### Expert Insight

#### Real-world Application
In production environments, combine these configurations with fail2ban for intrusion detection, use SSH key pairs exclusively, and integrate with monitoring tools like journald or ELK stack to track SSH activities. For enterprise setups, consider SSH jump hosts or bastion servers to limit direct access.

#### Expert Path
Dive deeper into SSH hardening: Study `sshd_config` thoroughly for options like `MaxSessions`, `ClientAliveInterval`, and authentication methods. Learn to implement rate limiting and two-factor authentication (2FA) for SSH. Practice with tools like `ssh-copy-id` for key distribution and `ssh-agent` for key management.

#### Common Pitfalls
- **Firewall Oversights**: Changing the port without updating firewall rules can lock out users.
- **Root Lockout**: Disabling root login without verifying alternative access paths can cause administrative emergencies.
- **SELinux Ignoring**: Forgetting to update SELinux policies on port changes breaks services on enforced systems.
- **Inconsistent Client Configurations**: Teams must update connection strings/scripts to use new ports; automate client configurations to avoid errors.
- **Banner Overuse**: Including secrets or excessive text in banners; keep them concise and compliant with policies.

> [!IMPORTANT]
> Always back up configurations and test changes in a non-production environment first. SSH misconfigurations can lead to total system lockdown if not handled carefully.

</details>
