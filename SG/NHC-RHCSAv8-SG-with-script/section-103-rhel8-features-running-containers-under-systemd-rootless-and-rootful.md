# Section 103: Defining Containers as Systemd Services for Auto-Start

<details open>
<summary><b>Section 103: Defining Containers as Systemd Services for Auto-Start (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to systemd and Services](#introduction-to-systemd-and-services)
- [Rootful Container Setup](#rootful-container-setup) 
- [Rootless Container Setup](#rootless-container-setup)
- [Troubleshooting Common Issues](#troubleshooting-common-issues)

## Introduction to systemd and Services

### Overview
This section introduces systemd, the init system used by modern Linux distributions to manage services. You'll learn how to define container services so they automatically start when the system boots, eliminating manual startup requirements. This is essential for production deployments where containers must be available immediately after system restart.

### Key Concepts/Deep Dive

**What is systemd?**
Systemd is a modern init system that manages system services, resources, and processes. It replaced traditional SysV init systems and provides enhanced capabilities for service management.

**Core Components:**
- **Units**: Resource types systemd can manage (services, timers, devices, mounts, etc.)
- **systemd services**: Unit files that define how services should start, stop, and be managed
- **Unit Files**: Configuration files stored in `/etc/systemd/system/` that describe service behavior

**Key systemd Features for Containers:**
- Service activation and deactivation ✅
- Automatic dependency mapping ✅ 
- Instance and template management ✅
- Enhanced security hardening ✅
- Resource management ✅

**Unit Anatomy Example:**
```ini
[Unit]
Description=My Container Service
After=network.target

[Service]
ExecStart=/usr/bin/podman run my-container
Restart=always

[Install]
WantedBy=multi-user.target
```

> [!IMPORTANT]  
> Understanding systemd units is crucial because containers need to be defined as services with proper startup dependencies and restart policies.

**Container Tools Integration:**
Container tools like Podman must be installed on the system before defining services. Use `dnf install podman` or appropriate package manager command.

## Rootful Container Setup

### Overview
Rootful containers run under the root user account and are easier to configure as systemd services. This method is commonly used in production environments where containers need full system access. You'll learn to generate service files automatically and enable them for auto-start.

### Key Concepts/Deep Dive

**Prerequisites:**
- Container tools installed (`podman` package)
- Root user access
- Container image downloaded and tested

**Step-by-Step Process:**

1. **Pull Container Image:**
```bash
podman search httpd
podman pull registry.fedoraproject.org/httpd:latest
```

2. **Run and Verify Container:**
```bash
podman run -d --name my-httpd -p 8080:80 registry.fedoraproject.org/httpd:latest
podman ps
curl 192.168.x.x:8080
```

3. **Generate systemd Unit File:**
```bash
podman generate systemd --new --files --name my-httpd
```

4. **Copy Unit File to System Location:**
```bash
cp ~/container-httpd.service /etc/systemd/system/
```

5. **Enable and Start Service:**
```bash
systemctl enable container-my-httpd.service
systemctl start container-my-httpd.service
systemctl status container-my-httpd.service
```

6. **Test Auto-Start on Reboot:**
```bash
systemctl reboot
# After reboot, verify:
podman ps
```

**Unit File Contents (Generated Example):**
```ini
# /etc/systemd/system/container-my-httpd.service
[Unit]
Description=Podman container-my-httpd.service
Documentation=man:podman-generate-systemd(1)
Wants=network.target
After=network-online.target

[Service]
Environment=PODMAN_SYSTEMD_UNIT=%n
Restart=on-failure
TimeoutStopSec=70
ExecStart=/usr/bin/podman start my-httpd
ExecStop=/usr/bin/podman stop -t 10 my-httpd
PIDFile=/run/containers/storage/overlay-containers/abcdef1234567890/userdata/conmon.pid
Type=forking

[Install]
WantedBy=multi-user.target
```

### Lab Demo: HTTP Server Container
1. Run container with `podman run -d --name httpd-demo -p 8080:80 httpd`
2. Generate unit: `podman generate systemd --new --files --name httpd-demo`
3. Copy and enable: `systemctl enable container-httpd-demo.service`
4. Verify status and test HTTP access
5. Reboot system to confirm auto-start

## Rootless Container Setup

### Overview
Rootless containers run under normal user accounts without root privileges, providing better security isolation. This setup is more complex for systemd integration but essential for multi-user systems. You'll learn the additional steps required including user permissions and environment variables.

### Key Concepts/Deep Dive

**Challenges with Rootless Containers:**
- Cannot directly define services in `/etc/systemd/system/`
- Requires user-specific systemd configuration
- Environment variables need special handling
- Lingering sessions must be enabled

**Additional Prerequisites:**
- User lingering enabled: `loginctl enable-linger username`
- Podman configured for rootless operation
- User systemd directory: `~/.config/systemd/user/`

**Step-by-Step Process:**

1. **Switch to Normal User Account:**
```bash
su - development
```

2. **Pull and Test Container:**
```bash
podman pull registry.fedoraproject.org/httpd:latest
podman run -d --name my-web-server -p 8080:80 httpd:latest
podman ps
```

3. **Generate Unit File:**
```bash
podman generate systemd --new --files --name my-web-server
```

4. **Create User systemd Directory:**
```bash
mkdir -p ~/.config/systemd/user
```

5. **Copy Unit File to User Location:**
```bash
cp container-my-web-server.service ~/.config/systemd/user/
```

6. **Enable User Lingering:**
```bash
loginctl enable-linger development
# OR for current user:
loginctl enable-linger $USER
```

7. **Handle Environment Variables:**
```bash
export XDG_RUNTIME_DIR=/run/user/$(id -u $USER)
echo "export XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR" >> ~/.profile
```

8. **Reload and Enable Service:**
```bash
systemctl --user daemon-reload
systemctl --user enable container-my-web-server.service
systemctl --user status container-my-web-server.service
```

**Rootless Unit File Example:**
```ini
# ~/.config/systemd/user/container-my-web-server.service
[Unit]
Description=Podman container-my-web-server.service
Documentation=man:podman-generate-systemd(1)
Wants=network.target
After=network-online.target

[Service]
Environment=PODMAN_SYSTEMD_UNIT=%n
Restart=on-failure
TimeoutStopSec=70
ExecStart=/usr/bin/podman start my-web-server
ExecStop=/usr/bin/podman stop -t 10 my-web-server
PIDFile=/run/user/1000/podman/pidfile
Type=forking

[Install]
WantedBy=default.target
```

### Lab Demo: Web Server in Rootless Mode
1. Switch to user account: `su - devuser`
2. Enable lingering: `loginctl enable-linger devuser`
3. Run container and generate unit
4. Copy to user systemd directory
5. Enable with `--user` flag and test
6. Verify after system reboot

## Troubleshooting Common Issues

### Overview
Common problems arise during rootless container systemd setup, especially with RHEL 8.5+ where default configurations have changed. Learn to diagnose and fix these issues systematically.

### Key Concepts/Deep Dive

**Common Problem: systemctl --user daemon-reload fails**
```
! Connection refused: Failed to connect to bus: No such file or directory
```

**Solution - Enable Lingering Explicitly:**
```bash
# Check current status
loginctl user-status $USER

# Enable lingering
sudo loginctl enable-linger $USER

# Verify
loginctl user-status $USER
```

**PATH Variable Issues:**
```diff
- If PATH variables are unset, commands fail
+ Solution: Export required variables
```

```bash
# Diagnose
# loginctl show-user $USER
# systemctl --user status container-name

# Fix PATH issues
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Add to ~/.profile or ~/.bashrc
```

**Rootless Container Startup Issues:**
```
! systemctl --user start container-name.service fails
! Error: "Connection refused"
```

**Solution - Define Runtime Directory:**
```bash
# Export XDG_RUNTIME_DIR
export XDG_RUNTIME_DIR=/run/user/$(id -u $USER)

# Add to profile
echo "export XDG_RUNTIME_DIR=/run/user/\$(id -u \$USER)" >> ~/.profile

# Reload profile
source ~/.profile
```

**Verification Commands:**
```bash
# Check user systemd status
systemctl --user list-units
systemctl --user is-active container-service

# Check container status
podman ps -a

# Check logs
journalctl --user -u container-service-name
```

> [!NOTE]  
> PATH and XDG_RUNTIME_DIR environment variables are critical for rootless container services. These often need manual configuration in user profiles.

## Summary

### Key Takeaways
```diff
+ Systemd enables automatic container startup on system boot
+ Rootful containers use /etc/systemd/system/ (simpler setup)
+ Rootless containers require ~/.config/systemd/user/ with lingering enabled
+ Container tools like podman generate systemd unit files automatically
+ Environment variables (PATH, XDG_RUNTIME_DIR) must be properly configured for rootless mode
- Common pitfalls include missing PATH variables and disabled user lingering
! Verify service status with systemctl status and journalctl logs
```

### Quick Reference
```bash
# Rootful Setup
podman generate systemd --new --files --name container-name
cp service-file /etc/systemd/system/
systemctl enable container-name.service
systemctl start container-name.service

# Rootless Setup  
loginctl enable-linger $USER
export XDG_RUNTIME_DIR=/run/user/$(id -u $USER)
podman generate systemd --new --files --name container-name
cp service-file ~/.config/systemd/user/
systemctl --user enable container-name.service
systemctl --user start container-name.service
```

### Expert Insight

**Real-world Application**: In production environments, container services ensure high availability. RHCSA/RHCE candidates frequently encounter these questions as they're critical for enterprise deployments where containers must survive system restarts without manual intervention.

**Expert Path**: Master both rootful and rootless approaches, understand systemd dependency management, and practice troubleshooting permission/environment issues. Focus on security implications of running containers with different privilege levels.

**Common Pitfalls**: ❌ Forgetting to enable user lingering causes rootless services to fail silently. ❌ PATH environment variables not set leads to command execution failures. ❌ Mixing rootful and rootless contexts without proper service separation. ⚠️ Always test service auto-start by rebooting the system, not just manually starting services.

</details>
