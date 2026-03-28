# Section 102: RHEL 8 Features - Podman Rootless vs Rootful Containers in Linux

<details open>
<summary><b>Section 102: RHEL 8 Features - Podman Rootless vs Rootful Containers in Linux (CL-KK-Terminal)</b></summary>

## Table of Contents
- [What are Rootless Containers?](#what-are-rootless-containers)
- [What are Rootful Containers?](#what-are-rootful-containers)
- [Rootless vs Rootful: Key Differences](#rootless-vs-rootful-key-differences)
- [Security Implications](#security-implications)
- [Setting up Rootless Containers](#setting-up-rootless-containers)
- [Setting up Rootful Containers](#setting-up-rootful-containers)
- [Managing Volumes and Permissions](#managing-volumes-and-permissions)
- [Networking Considerations](#networking-considerations)
- [Lab Demo: Running Rootless Containers](#lab-demo-running-rootless-containers)
- [Lab Demo: Running Rootful Containers](#lab-demo-running-rootful-containers)
- [Summary](#summary)

## What are Rootless Containers?

### Overview
Rootless containers in Podman allow regular users to run containers without requiring root privileges. This revolutionary approach dramatically improves security by eliminating the need for elevated permissions during container execution.

### Key Characteristics
- **✅ Security Isolation**: Containers run with user privileges, preventing system-wide compromise
- **✅ Process Independence**: Each container process is isolated at the user level
- **✅ Resource Limits**: Natural resource management through user-level constraints
- **⚠ Limited Capabilities**: Some kernel features may be restricted

### Core Architecture
The rootless approach leverages user namespaces to create isolated environments:

```bash
# User namespace creates virtual filesystem isolation
useradd container-user
usermod -aG wheel container-user
su - container-user
```

## What are Rootful Containers?

### Overview
Rootful containers operate with full root privileges, providing complete access to system resources and kernel capabilities. This traditional container approach offers maximum functionality but requires careful security management.

### Key Characteristics
- **✅ Full System Access**: Unrestricted access to all system resources
- **✅ Kernel Capabilities**: Complete access to all kernel features and modules  
- **✅ Network Control**: Full control over network configuration and interfaces
- **⚠ Security Risks**: Root access introduces potential attack vectors

### Traditional Model
Rootful containers map the container root directly to the host root:

```bash
# System-wide container execution
sudo podman run --privileged \
    --name my-rootful-container \
    fedora:latest /bin/bash
```

## Rootless vs Rootful: Key Differences

### Comparative Analysis

| Feature | Rootless Containers | Rootful Containers |
|---------|-------------------|-------------------|
| **Privilege Level** | User privileges | Root privileges |
| **Security Risk** | 🛠 Lower attack surface | ⚠ Higher attack vectors |
| **Resource Access** | Limited kernel features | Full host access |
| **Volume Mounting** | Restricted file permissions | Full filesystem access |
| **Port Binding** | Ports >= 1024 only | Any port available |
| **SELinux Integration** | Enhanced security contexts | Standard contexts |
| **Performance Overhead** | Minimal namespace translation | Direct hardware access |
| **Use Cases** | Development, testing | Production, privileged operations |

> [!IMPORTANT]
> Rootless containers should be preferred for development and non-privileged workloads, while rootful containers are necessary for system-level operations requiring elevated permissions.

## Security Implications

### Container Attack Vectors

```diff
+ Rootless Advantages:
  - User-level process isolation prevents privilege escalation
  - Limited namespace exposure reduces attack surface
  - Natural resource constraints through user limits
  
- Rootful Risks:
  - Root privilege compromise affects entire system
  - Kernel-level access enables persistent threats
  - Vulnerable to container escape techniques
```

### Privilege Management

```bash
# Check current container security context
podman inspect container-name | grep -A 10 "SecurityOpt"

# Enable additional security policies
podman run --security-opt seccomp=default.json \
    --security-opt apparmor=docker-default \
    --tmpfs /tmp:rw,noexec,nosuid,size=100m \
    ubuntu:latest
```

### SELinux Integration

> [!NOTE]
> Both rootless and rootful containers benefit from SELinux, but rootless containers provide additional process confinement through user namespaces.

## Setting up Rootless Containers

### Prerequisites

```bash
# 1. Ensure user namespaces are available
grep user_namespace_available /proc/self/status

# 2. Install required packages
dnf install -y podman

# 3. Enable lingering for systemd services
loginctl enable-linger username

# 4. Verify UID mapping
grep $USER /etc/subuid
grep $USER /etc/subgid
```

### Basic Rootless Container Execution

```bash
# Run a simple container as regular user
podman run -it --rm fedora:latest /bin/bash

# Check process ownership
ps aux | grep pid

# Verify namespace isolation
lsns | grep -E "mnt|user"
```

## Setting up Rootful Containers

### Rootful Execution

```bash
# Run container with root privileges
sudo podman run -it --rm \
    --name rootful-container \
    fedora:latest /bin/bash

# Install system packages (requires root)
dnf install -y httpd

# System-level service management
systemctl enable podman.service
```

### Privilege Escalation Controls

```bash
# Limit capabilities explicitly
podman run --cap-drop=ALL \
    --cap-add=NET_BIND_SERVICE \
    nginx:latest

# Drop specific capabilities
podman run --cap-drop SYS_ADMIN \
    --cap-drop NET_RAW \
    ubuntu:latest
```

## Managing Volumes and Permissions

### Rootless Volume Mounting

```bash
# Create user-owned directories
mkdir -p ~/container-data
chown $USER:$USER ~/container-data

# Mount with appropriate permissions
podman run -v ~/container-data:/data:Z \
    --name rootless-app \
    fedora:latest

# Verify ownership
ls -la ~/container-data
```

### Rootful Volume Handling

```bash
# Mount any host directory (privileged)
sudo podman run -v /host/path:/container/path \
    --privileged \
    ubuntu:latest

# SELinux context management
podman run -v /opt/myapp:/app:z \
    fedora:latest
```

## Networking Considerations

### Rootless Networking Limitations

```bash
# Port binding constraints (>= 1024)
podman run -p 8080:80/tcp \
    nginx:latest

# DNS resolution through user processes
resolv.conf resolution works normally

# Network namespace isolation
podman network ls
podman network create my-network
```

### Rootful Network Capabilities

```bash
# Bind privileged ports
sudo podman run -p 80:80/tcp \
    -p 443:443/tcp \
    nginx:latest

# Custom bridge networks
podman network create --driver bridge \
    --subnet 192.168.100.0/24 \
    secure-bridge

# System firewall integration
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload
```

## Lab Demo: Running Rootless Containers

### Interactive Session Setup

```bash
# Step 1: Switch to regular user
su - testuser

# Step 2: Pull and run alpine container
podman pull alpine:latest

# Step 3: Interactive execution
podman run -it --rm alpine:latest sh

# Inside container
ls -la /
whoami
id

# Verify rootless execution
# Container shows root user, but host sees process owned by testuser
```

### Volume Management Demo

```bash
# Step 1: Prepare local directory
mkdir -p ~/demo-data
echo "Hello from host" > ~/demo-data/message.txt

# Step 2: Run container with volume
podman run -it -v ~/demo-data:/host:Z \
    alpine:latest sh

# Step 3: Verify file access
cat /host/message.txt

# Step 4: Create file in container
echo "Created in container" > /host/container-file.txt

# Step 5: Check ownership
ls -la ~/demo-data/
# Note: Files owned by subuid range (typically 100000+)
```

## Lab Demo: Running Rootful Containers

### Rootful Container Execution

```bash
# Step 1: Root privileges confirmed
whoami

# Step 2: Run privileged container
sudo podman run -it --rm \
    --name demo-rootful \
    fedora:latest

# Step 3: Install system packages (requires root)
dnf install -y httpd mariadb

# Step 4: System service management
systemctl list-units --type=service

# Step 5: Kernel module access
lsmod | head -10
```

### Advanced Rootful Features

```bash
# Device mapping example
sudo podman run --device=/dev/sda1 \
    --device=/dev/null \
    centos:latest

# Systemd integration
sudo podman create --name nginx-service \
    --label "io.containers.autoupdate=registry" \
    nginx:latest

sudo podman generate systemd nginx-service --restart-policy=always
```

### Security Context Verification

```bash
# Inspect security settings
podman inspect demo-rootful | jq '.Config.SecurityOpt'

# Check privilege escalation
getent passwd root
ls -la /etc/shadow

# Direct hardware access
lspci | head -5
```

## Summary

### Key Takeaways

```diff
+ Rootless containers provide enhanced security through user namespace isolation
+ Rootful containers offer maximum functionality but require careful privilege management  
+ Choose rootless for development workloads and elevated privileges only when necessary
+ Podman's daemonless architecture supports both execution models seamlessly
+ Volume mounting permissions differ significantly between rootless and rootful approaches
! Always consider security implications when selecting container execution mode
```

### Quick Reference

| Operation | Rootless | Rootful |
|-----------|----------|----------|
| **Basic Run** | `podman run -it alpine:latest` | `sudo podman run -it alpine:latest` |
| **Port Binding** | `podman run -p 8080:80` | `sudo podman run -p 80:80` |
| **Volume Mount** | `podman run -v host:/container:rw,Z` | `sudo podman run -v host:/container` |
| **Privileged Access** | N/A (inherent limitations) | `sudo podman run --privileged` |
| **System Integration** | Limited | `systemctl` management |
| **Security Context** | User namespace isolation | Direct host access |

### Expert Insight

**Real-world Application**: In production environments, start with rootless containers for application workloads and reserve rootful containers for infrastructure services requiring direct hardware access (network appliances, GPU workloads) or system-level resource management.

**Expert Path**: Master Podman by understanding cgroups v2 integration, exploring `podman inspect` outputs for security contexts, and implementing CI/CD pipelines that leverage rootless containers for build processes. Study Kubernetes PodSecurityPolicy alternatives in pure Podman environments.

**Common Pitfalls**: 
- ⚠ Attempting privileged operations in rootless containers causes permission errors
- ⚠ Overlooking SELinux relabeling (`:Z` vs `:z` flags) leading to access issues
- ⚠ Assuming rootful containers always require `--privileged` flag when more granular capabilities suffice
- ⚠ Ignoring namespace limitations when designing multi-user container platforms

> [!NOTE]
> The choice between rootless and rootful containers should be based on security requirements first, with functionality needs considered second. Podman's flexibility allows seamless switching between models as architectural needs evolve.

</details>
