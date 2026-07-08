<details open>
<summary><b> Section 07: systemd-networkd and Netplan Configuration</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Beginner Level Exercises

### Exercise 1.1: Systemd and Networkd Introduction
**Objective:** Understand the relationship between systemd and networkd

**Tasks:**
- Research and document the history of systemd (debut year, distributions, controversies)
- Create a comparison table between systemd and previous init systems (System V, BSD init)
- Document which Linux distributions primarily use networkd vs NetworkManager
- Explain the role of networkd within the systemd ecosystem

**Deliverable:** Create a one-page summary explaining when and why to use networkd

### Exercise 1.2: Service Status Analysis
**Objective:** Master systemd-networkd service management

**Tasks:**
- On an Ubuntu server, run the following commands and document the output:
  ```bash
  systemctl status systemd-networkd
  systemctl is-enabled systemd-networkd
  systemctl list-dependencies systemd-networkd
  journalctl -u systemd-networkd --no-pager
  ```
- Create a checklist of what to look for in the status output
- Document the differences between `active (running)` and `enabled`

**Exercise:** Write a script that checks if networkd is properly configured and running

### Exercise 1.3: Network Interface Identification
**Objective:** Identify and understand network interfaces in Ubuntu server

**Tasks:**
- Document the naming convention for network interfaces (ens3, enp0s3, etc.)
- Run `ip link show` and `ip addr show` to examine all interfaces
- Create a mapping of interface types:
  - Loopback interface
  - Ethernet interfaces
  - Virtual interfaces
- Document how to identify which interface is the primary network connection

**Practical Task:** Create a reference guide for common Ubuntu server interface names

## Intermediate Level Exercises

### Exercise 2.1: Netplan Configuration Basics
**Objective:** Master basic netplan configuration for static IP addresses

**Tasks:**
- Locate and examine the netplan configuration directory: `/etc/netplan/`
- Document the YAML structure of a typical netplan configuration file
- Create a static IP configuration with the following requirements:
  - Interface: ens3 (or your primary interface)
  - IP Address: 192.168.1.100/24
  - Gateway: 192.168.1.1
  - DNS: 8.8.8.8, 8.8.4.4
- Apply the configuration using `netplan apply`
- Verify the configuration with `ip addr show`

**Challenge:** Create configurations for multiple scenarios (DHCP, static with multiple DNS)

### Exercise 2.2: Netplan Directory Structure Analysis
**Objective:** Understand netplan configuration locations across distributions

**Tasks:**
- Document the configuration file locations for different scenarios:
  - Ubuntu server using networkd: `/etc/netplan/`
  - Arch Linux: `/etc/systemd/network/`
  - Special situations requiring `/etc/systemd/network/`
- Create a decision tree for determining which configuration method to use
- Practice identifying which service is managing your network based on configuration locations

**Exercise:** Write a script that identifies which network management system is active

### Exercise 2.3: Service Lifecycle Management
**Objective:** Understand the implications of stopping/starting networkd

**Scenario-based Tasks:**
1. **Test Service Resilience:**
   - Attempt to stop networkd: `systemctl stop systemd-networkd`
   - Document what happens to existing connections
   - Test connectivity to verify Ubuntu's resilience
   - Document why connectivity may persist

2. **Proper Service Management:**
   - Document the correct procedure to switch from networkd to NetworkManager
   - Create a step-by-step guide including:
     - Installing NetworkManager
     - Enabling and starting NetworkManager
     - Disabling and stopping networkd
     - Updating netplan configuration to use NetworkManager

**Deliverable:** Complete service management runbook

## Advanced Level Exercises

### Exercise 3.1: Dynamic IP Configuration with Networkd
**Objective:** Configure and troubleshoot DHCP with systemd-networkd

**Tasks:**
- Configure a network interface for DHCP using netplan
- Document the DORA process (Discover, Offer, Request, Acknowledge) as it applies to networkd
- Analyze DHCP lease information:
  ```bash
  journalctl -u systemd-networkd | grep -i dhcp
  cat /run/systemd/netif/leases/*
  ```
- Create a troubleshooting checklist for DHCP issues with networkd
- Test connectivity before and after obtaining DHCP lease

**Advanced Challenge:** Compare DHCP behavior between networkd and NetworkManager

### Exercise 3.2: DNS Configuration with Networkd
**Objective:** Master DNS configuration in networkd environments

**Tasks:**
- Configure DNS settings using netplan for networkd
- Document the different approaches:
  - Global DNS configuration
  - Per-interface DNS configuration
  - Integration with systemd-resolved
- Verify DNS resolution:
  ```bash
  resolvectl status
  resolvectl query example.com
  cat /etc/resolv.conf
  ```
- Create a troubleshooting guide for DNS issues in networkd environments

**Exercise:** Document the relationship between netplan, networkd, and systemd-resolved

### Exercise 3.3: Cloud Environment Analysis (AWS)
**Objective:** Understand networkd usage in cloud environments

**Tasks:**
- Research and document why Debian on AWS uses networkd
- Compare network configuration approaches:
  - On-premises Ubuntu server
  - Ubuntu server in AWS
  - Arch Linux configurations
- Create a matrix comparing configuration locations and methods across environments
- Document any special considerations for cloud deployments

**Deliverable:** Cloud networking deployment guide for networkd environments

### Exercise 3.4: Networkd Command Line Tools
**Objective:** Master additional networkd-related commands and tools

**Tasks:**
- Research and document these commands:
  - `networkctl` - networkd control tool
  - `networkctl status`
  - `networkctl list`
  - `networkctl reload`
- Create practical examples for each command
- Develop a monitoring script that uses these tools to track network status
- Compare networkctl output with traditional ip commands

**Advanced Challenge:** Create a unified monitoring dashboard using networkctl and ip commands

</details>
</details>