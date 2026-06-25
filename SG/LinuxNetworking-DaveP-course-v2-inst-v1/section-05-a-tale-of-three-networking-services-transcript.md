# Section 5: A Tale of Three Networking Services

## Table of Contents

- [5.1 A Tale of Three Networking Services](#51-a-tale-of-three-networking-services)
- [5.2 Network Service Example](#52-network-service-example)
- [Summary](#summary)

---

<details open>
<summary><b>Section 5: A Tale of Three Networking Services (KK-CS45-script-v2-Inst-v1)</b></summary>

## 5.1 A Tale of Three Networking Services

### Overview
Linux systems rely on one of several core networking services to manage network connectivity. There are three primary networking services that form the foundation for all network operations across different Linux distributions: networking, networkd, and Network Manager.

### Key Concepts

#### The Three Core Networking Services

Linux distributions use one of three main networking services as the foundation for network connectivity:

1. **networking service**
   - Primarily used by Debian as a server
   - Traditional networking service for Debian-based server deployments

2. **networkd**
   - Used by Ubuntu as a server
   - Modern systemd-based networking solution
   - Lightweight and efficient for server environments

3. **Network Manager**
   - Widely used across multiple distributions:
     - Fedora
     - CentOS (Zentask)
     - Red Hat
     - Debian (as a client)
     - Ubuntu Desktop
     - Many other Linux distributions with desktop environments
   - Designed primarily for desktop/laptop use with dynamic network environments

#### Service Relationships and Purpose

```
Core Networking Services
    ├── networking (Debian Server)
    ├── networkd (Ubuntu Server)
    └── Network Manager (Desktop/Multi-distro)
            ↓
    Foundation for all other networking technologies
            ↓
    FTP, HTTPS, SSH, POP3, and other services
```

#### Key Points

- **Mutual Exclusivity**: A system typically uses only one of the three services at any given time
- **Foundation Role**: These services provide the underlying network infrastructure for higher-level networking technologies
- **Distribution-Specific Usage**: Each service is optimized for specific use cases and distributions

> [!IMPORTANT]
> Understanding which networking service your distribution uses is crucial for effective network configuration and troubleshooting.

## 5.2 Network Service Example

### Overview
This section demonstrates practical usage of Network Manager on a Debian client system, showing how to check service status and retrieve network configuration information using command-line tools.

### Key Concepts

#### Checking Network Service Status

To monitor the status of your networking service, use the `systemctl` command:

```bash
systemctl status NetworkManager
```

This command displays:
- Service status (active/running)
- Enablement status (enabled/disabled)
- Recent log entries and service details

#### Using nmcli for Network Information

The `nmcli` command provides detailed information about TCP/IP connections:

```bash
nmcli
```

This displays network configuration including:
- IP addresses
- Connection details
- Interface information

> [!NOTE]
> The information provided by `nmcli` is similar to what you would see with the `ip a` command.

### Lab Demonstration Steps

1. **Open Virtual Machine**
   - Access the Debian client virtual machine
   - Adjust to full screen mode
   - Increase font size for better visibility

2. **Check NetworkManager Status**
   ```bash
   systemctl status NetworkManager
   ```
   Expected output: Service shows as "active" and "running", and "enabled"

3. **Retrieve Network Configuration**
   ```bash
   nmcli
   ```
   Expected output: Displays IP address and connection details (e.g., IP: 10.0.2.52)

### Practical Example

On a Debian client running Network Manager:
- The NetworkManager service manages network connections
- `systemctl status NetworkManager` confirms the service is operational
- `nmcli` provides quick access to network configuration details

---

## Summary

### Key Takeaways

```diff
+ Three core networking services: networking, networkd, and Network Manager
+ Each distribution typically uses one primary networking service
+ Network Manager is most common for desktop environments
+ systemctl manages service status and enablement
+ nmcli provides network configuration details similar to ip commands
```

### Quick Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `systemctl status <service>` | Check service status | `systemctl status NetworkManager` |
| `nmcli` | Display network configuration | `nmcli` |
| `ip a` | Alternative IP address display | `ip a` |

### Service Distribution Mapping

| Service | Primary Distribution | Use Case |
|---------|---------------------|----------|
| networking | Debian | Server |
| networkd | Ubuntu | Server |
| Network Manager | Fedora, CentOS, Red Hat, Debian/Ubuntu Desktop | Desktop/Clients |

### Expert Insight

**Real-world Application**: In production environments, understanding your system's networking service helps with automation scripts, configuration management, and troubleshooting. Desktop systems benefit from Network Manager's automatic connection handling, while servers typically use the lighter-weight alternatives.

**Expert Path**: Master each networking service by:
1. Learning the specific configuration file locations for each service
2. Understanding service-specific commands and options
3. Practicing configuration changes and service management
4. Developing troubleshooting methodologies for each service type

**Common Pitfalls**:
- Confusing which networking service is active on a system
- Using commands specific to one service when another is running
- Not checking service status before making network changes
- Assuming Network Manager is always present (headless servers often don't use it)

**Lesser-Known Facts**:
- Network Manager can be used on servers but adds unnecessary overhead
- The "networking" service on Debian is actually a collection of ifupdown scripts
- systemd-networkd can coexist with Network Manager but may conflict if both try to manage the same interface
- Network configuration files are in completely different locations depending on which service manages networking

</details>