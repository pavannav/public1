# Section 103: RHEL8 Features Running Containers Under Systemd Rootless And Rootful

<details open>
<summary><b>Section 103: RHEL8 Features Running Containers Under Systemd Rootless And Rootful (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Running Containers Under Systemd: Rootless and Rootless](#running-containers-under-systemd-rootless-and-rootless)
  - [Overview](#overview)
  - [Key Concepts](#key-concepts)
  - [Rootful Container Configuration](#rootful-container-configuration)
  - [Rootless Container Configuration](#rootless-container-configuration)
  - [Lab Demo: Configuring Auto-Start for Rootful Container](#lab-demo-configuring-auto-start-for-rootful-container)
  - [Lab Demo: Configuring Auto-Start for Rootless Container](#lab-demo-configuring-auto-start-for-rootless-container)
  - [Common Pitfalls](#common-pitfalls)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Running Containers Under Systemd: Rootless and Rootless

### Overview
This session covers how to configure containers to auto-start using systemd units, distinguishing between rootful (running as root) and rootless (running as non-root user) modes. Rootful containers are managed directly under `/etc/systemd/system/`, while rootless containers require special configuration in the user's home directory, including enabling linger for persistence across reboots. The process involves generating systemd unit files, enabling services, and testing auto-start after reboots, which is crucial for production environments and RHCSA certification scenarios.

### Key Concepts
- **Systemd Units**: Systemd is a system and service manager for Linux. Units are resources managed by systemd, including services, timers, mounts, and devices. Containers can be defined as systemd services for automatic startup.
- **Rootful vs Rootless Containers**: Rootful containers run as the root user, providing full privileges but higher security risks. Rootless containers run under normal users, improving security but requiring additional configuration like lingerd returns and environ variables.
- **Podman as Container Tool**: Podman is used to manage containers on RHEL 8. It integrates with systemd for generating unit files via `podman generate systemd`.
- **Linger and User Services**: For rootless containers, user sessions must be enabled for linger to persist across logins, allowing systemd user services to run continuously.

### Rootful Container Configuration
Rootful containers are simpler to configure as systemd services since they run under the system's systemd instance directly.
- **Prerequisites**: Install podman and container tools module.
- **Steps**:
  1. Search and pull container image: `podman search httpd && podman pull httpd`.
  2. Run container: `podman run -d --name my-web-server -p 80:80 httpd`.
  3. Generate systemd unit: `podman generate systemd --files --name my-web-server > /etc/systemd/system/container-my-web-server.service`.
  4. Enable and start: `systemctl daemon-reload && systemctl enable --now container-my-web-server.service`.
  5. Verify: `podman ps`, then reboot and check auto-start.

### Rootless Container Configuration
Rootless containers require user-specific systemd configuration, which is more complex due to limitations in user sessions.
- **Prerequisites**: Create user directory structure: `~/.config/systemd/user/`.
- **Steps**:
  1. Run container as user: `podman run -d --name my-web-server -p 8080:80 httpd`.
  2. Generate unit: `podman generate systemd --files --name my-web-server > ~/.config/systemd/user/container-my-web-server.service`.
  3. Enable linger: `loginctl enable-linger $USER`.
  4. Reload systemd: `systemctl --user daemon-reload`.
  5. Fix PATH issues by exporting runtime: `export XDG_RUNTIME_DIR=/run/user/$(id -u)`.
  6. Enable and start user service: `systemctl --user enable --now container-my-web-server.service`.
  7. Verify: `podman ps`, then reboot and check as user: `systemctl --user status container-my-web-server.service`.

### Lab Demo: Configuring Auto-Start for Rootful Container
1. Install container tools: `dnf module install container-tools`.
2. Pull httpd image: `podman pull httpd`.
3. Run container: `podman run -d --name httpd-container -p 80:80 httpd`.
4. Generate systemd unit file: `podman generate systemd --files --name httpd-container > /etc/systemd/system/container-httpd-container.service`.
5. Reload and enable: `systemctl daemon-reload && systemctl enable container-httpd-container.service`.
6. Start service: `systemctl start container-httpd-container.service`.
7. Verify container runs: `podman ps`.
8. Access web page: Open browser to server IP:80.
9. Stop container and service: `podman stop httpd-container`, `systemctl stop container-httpd-container.service`.
10. Reboot system: `systemctl reboot`.
11. After reboot, verify auto-start: Log in as root, check `podman ps` and service status with `systemctl status container-httpd-container.service`.

### Lab Demo: Configuring Auto-Start for Rootless Container
1. Switch to normal user: `su - development`.
2. Ensure podman is available (install if needed).
3. Pull httpd image: `podman pull httpd`.
4. Run container: `podman run -d --name my-web-server -p 8080:80 httpd`.
5. Create systemd user directory: `mkdir -p ~/.config/systemd/user`.
6. Generate unit file: `podman generate systemd --files --name my-web-server > ~/.config/systemd/user/container-my-web-server.service`.
7. Enable linger for user: `loginctl enable-linger $USER`.
8. Set runtime directory: `export XDG_RUNTIME_DIR=/run/user/$(id -u)`.
9. Reload user systemd: `systemctl --user daemon-reload`.
10. Enable and start user service: `systemctl --user enable --now container-my-web-server.service`.
11. Verify: `podman ps`, access via browser at IP:8080.
12. Reboot system (as root): `systemctl reboot`.
13. After reboot, login as user, check `podman ps` and `systemctl --user status container-my-web-server.service`.

### Common Pitfalls
- Forgetting to enable linger in rootless mode, resulting in services not persisting.
- Incorrect PATH variables for rootless containers, causing failures in unit start attempts.
- Using wrong syntax in `podman generate systemd`, especially without `--files` flag.
- Not reloading systemd daemons after generating unit files.
- Attempting to run `systemctl` commands without `--user` flag in rootless mode.

## Summary

### Key Takeaways
```diff
+ Rootful containers use /etc/systemd/system/ for unit files and require root privileges.
- Rootless containers need user-specific configuration in ~/.config/systemd/user/ and linger enabled.
+ Use podman generate systemd to create unit files automatically.
- Rootless mode requires runtime exports and user session management for proper auto-start.
+ Certification scenarios often test this configuration, so practice both modes thoroughly.
```

### Quick Reference
- **Install container tools**: `dnf module install container-tools`
- **Run rootful container**: `podman run -d --name <name> -p <port>:<port> <image>`
- **Generate unit for rootful**: `podman generate systemd --files --name <name> > /etc/systemd/system/container-<name>.service`
- **Enable rootful service**: `systemctl enable --now container-<name>.service`
- **Generate unit for rootless**: `podman generate systemd --files --name <name> > ~/.config/systemd/user/container-<name>.service`
- **Enable linger**: `loginctl enable-linger $USER`
- **Reload user systemd**: `systemctl --user daemon-reload`
- **Enable rootless service**: `systemctl --user enable --now container-<name>.service`

### Expert Insight
**Real-world Application**: In production, configure rootless containers for multi-tenant environments where isolation is critical, using systemd auto-start to ensure services remain available post-reboot without full root access. Monitor resource usage with `podman stats` and integrate with monitoring tools.

**Expert Path**: Master both configurations by scripting the setup process. Practice integrating security profiles with SELinux and configuring health checks via `podman healthcheck`. Focus on RHCSA-relevant aspects like user management and service persistence.

**Common Pitfalls**: Avoid manual unit file creation; always use `podman generate systemd`. For rootless, ensure XDG_RUNTIME_DIR is exported correctly, or services may fail silently. Skip enabling linger at your peril - it's mandatory for user services across sessions.

</details>
