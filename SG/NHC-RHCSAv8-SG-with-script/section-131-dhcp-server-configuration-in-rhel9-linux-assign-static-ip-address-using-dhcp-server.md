# Section 131: DHCP Server Configuration in RHEL8/SG

<details open>
<summary><b>Section 131: DHCP Server Configuration in RHEL8/SG (CL-KK-Terminal)</b></summary>

## Table of Contents
- [Introduction to DHCP](#introduction-to-dhcp)
- [DHCP Server Installation and Initial Setup](#dhcp-server-installation-and-initial-setup)
- [Configuring Network Adapters for Host-Only Mode](#configuring-network-adapters-for-host-only-mode)
- [Setting Static IP Address on the Server](#setting-static-ip-address-on-the-server)
- [Configuring DHCP Server for Dynamic IP Assignment](#configuring-dhcp-server-for-dynamic-ip-assignment)
- [Enabling DHCP Service and Firewall Rules](#enabling-dhcp-service-and-firewall-rules)
- [Testing Dynamic IP Assignment on Client Machines](#testing-dynamic-ip-assignment-on-client-machines)
- [Configuring Static IP Leases in DHCP](#configuring-static-ip-leases-in-dhcp)
- [Testing Static IP Assignment](#testing-static-ip-assignment)
- [Summary](#summary)

## Introduction to DHCP
### Overview
Dynamic Host Configuration Protocol (DHCP) is a network protocol that enables automatic assignment of IP addresses and other network configuration parameters to devices on a network. It simplifies network management by dynamically allocating IP addresses from a predefined pool, eliminating the need for manual configuration on each device. This section covers DHCP server configuration in Red Hat Enterprise Linux (RHEL) 8/Study Guide (SG) environment, focusing on both dynamic and static IP assignments.

### Deep Dive
DHCP works by having a server automatically assign IP addresses to client machines upon boot-up or network connection. Key concepts include:

- **Dynamic IP Address Pool**: A range of IP addresses defined on the DHCP server. Clients receive temporary addresses that can change.
- **Static vs. Dynamic Assignment**:
  - Static IP addresses are permanent and fixed, ideal for devices like printers that require consistent access.
  - Dynamic IP addresses are leased temporarily and can change, suitable for most client devices.
- **DHCP Process**:
  - Client sends a DHCP Discover broadcast.
  - Server responds with DHCP Offer, providing an IP address.
  - Client requests the offer (DHCP Request).
  - Server acknowledges and assigns the IP (DHCP Acknowledgment).

This protocol is widely used in enterprise environments, home networks, and ISPs to manage IP allocation efficiently.

| Component | Role |
|-----------|------|
| DHCP Server | Assigns and manages IP addresses from a pool |
| DHCP Client | Receives IP configuration automatically |
| Lease Time | Duration for which an IP is assigned to a client |

## DHCP Server Installation and Initial Setup
### Overview
To configure a DHCP server in RHEL 8, start by installing the necessary packages and ensuring the system is ready for network roles. The following steps guide through package installation and initial configuration preparation.

### Deep Dive
1. **Install DHCP Package**:
   - Use the package manager to install the DHCP server software.

   ```bash
   dnf install dhcp-server -y
   ```

   This command installs the DHCP daemon and required dependencies.

2. **File Structure Overview**:
   - After installation, key configuration files are located in `/etc/dhcp/`.
     - `dhcpd.conf`: Main configuration file for defining IP pools, options, and leases.
     - `/etc/dhcp/dhcpd.conf`: Sample file; copy and modify as needed.

Attach a Firewall rule to allow DHCP traffic and check CentOS/RHEL version for compatibility.

> [!NOTE]
> Ensure the server machine has sufficient RAM and CPU for handling network requests. Test in a virtual environment first to simulate client connections.

### Lab Demo
- Install the package as shown above.
- Verify installation with `rpm -q dhcp-server`.

## Configuring Network Adapters for Host-Only Mode
### Overview
In a virtualized environment like VMware or VirtualBox, configure network adapters to operate in host-only mode to isolate the network for testing DHCP configurations without affecting real networks.

### Deep Dive
- Modify virtual machine settings:
  - Edit virtual machine > Network Adapter > Change type to "Host-only".
  
This ensures devices on the host network communicate directly, simulating a private subnet for DHCP server testing.

- Repeat for all client virtual machines to prevent interference from external connections.

> [!IMPORTANT]
> Host-only mode restricts external access, ideal for lab environments but not suitable for production networks exposed to the internet.

### Common Pitfalls
- Forgetting to set host-only mode may cause IP conflicts or connectivity issues if using bridged mode.

## Setting Static IP Address on the Server
### Overview
The DHCP server itself requires a static IP address to function correctly. This prevents the server from becoming its own client and ensures reliability.

### Deep Dive
- Configure static IP using Text User Interface (TUI) or Network Manager.
- Access network settings via `nmtui` (Network Manager TUI).

Steps:
1. Run `nmtui` and select "Edit a connection".
2. Choose the desired interface (e.g., ens33).
3. Set to manual, assign static IP (e.g., 192.168.140.1), subnet mask (255.255.255.0), gateway, and DNS.
4. Activate and deactivate the connection to apply changes.
5. Restart NetworkManager if issues arise: `systemctl restart NetworkManager`.

```bash
# Example via command line after selecting manual mode:
nmcli con mod "ens33" ipv4.addresses 192.168.140.1/24
nmcli con mod "ens33" ipv4.method manual
nmcli con up "ens33"
```

This sets up the server on its own subnet for DHCP operations.

## Configuring DHCP Server for Dynamic IP Assignment
### Overview
Edit the DHCP configuration file to define the IP pool, subnet, and lease parameters. This enables automatic IP assignment to client devices.

### Deep Dive
- Edit `/etc/dhcp/dhcpd.conf`:
  - Base it on the sample file: `cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.backup` then modify.

Key directives:
- `subnet`: Defines the network subnet.
- `range`: Specifies the IP address range for dynamic allocation.
- `option routers`: Sets the default gateway.
- `option domain-name-servers`: Configures DNS servers.
- `default-lease-time` and `max-lease-time`: Control lease durations (e.g., 600 seconds default, 7200 max).

Example configuration:
```bash
subnet 192.168.140.0 netmask 255.255.255.0 {
  range 192.168.140.120 192.168.140.130;
  option domain-name-servers 8.8.8.8, 8.8.4.4;  # Google DNS, comment if using local DNS
  default-lease-time 600;
  max-lease-time 7200;
}
```

- This allocates IPs from 120 to 130 in the 192.168.140.0/24 subnet.

> [!WARNING]
> Avoid overlapping ranges or conflicting with existing static IPs to prevent network conflicts.

## Enabling DHCP Service and Firewall Rules
### Overview
Start the DHCP service and configure firewall rules to allow DHCP traffic for proper functionality.

### Deep Dive
1. **Enable and Start Service**:
   ```bash
   systemctl enable dhcpd
   systemctl start dhcpd
   ```

2. **Firewall Configuration**:
   ```bash
   firewall-cmd --add-service=dhcp --permanent
   firewall-cmd --reload
   ```

3. **Verify Status**:
   ```bash
   systemctl status dhcpd
   dhcpd -t  # Test configuration syntax
   ```

This ensures the server listens on UDP port 67 for client requests.

## Testing Dynamic IP Assignment on Client Machines
### Overview
Test DHCP by starting client VMs and verifying automatic IP assignment from the defined pool.

### Deep Dive
- Start client VMs (e.g., Note1, Note2) in host-only mode.
- On clients, restart NetworkManager if needed: `systemctl restart NetworkManager`.
- Check assigned IPs: `ip addr show` or `ifconfig`.

Expected: Clients auto-assign IPs like 192.168.140.120, 192.168.140.121 from the range.
- Troubleshoot: Ensure no static IPs conflict; use `dhcpd -t` on server.

> [!TIP]
> Monitor server logs: `journalctl -u dhcpd` for lease offers.

## Configuring Static IP Leases in DHCP
### Overview
For specific devices requiring fixed IPs (e.g., printers), add host declarations in the DHCP config to assign static leases.

### Deep Dive
- In `/etc/dhcp/dhcpd.conf`, add a `host` block with MAC address and fixed IP.

Example:
```bash
host client3 {
  hardware ethernet 00:1B:44:11:3A:B7;  # Replace with actual MAC
  fixed-address 192.168.140.125;
  option host-name "client3.example.local";
}
```

- Retrieve MAC address from client: `ifconfig` or `ip link show`.
- This ensures Client3 always gets 192.168.140.125.

> [!IMPORTANT]
> Prevent IP conflicts by reserving ranges for static assignments outside the dynamic pool.

## Testing Static IP Assignment
### Overview
Restart DHCP service and reboot the client to verify static IP assignment persists.

### Deep Dive
- On server: `systemctl restart dhcpd`.
- On client (e.g., Note3):
  ```bash
  systemctl restart NetworkManager
  ip addr show  # Confirm fixed IP
  ```

Verify the IP matches the host declaration and remains stable across reboots.

## Summary
### Key Takeaways
```diff
+ DHCP automates IP assignment, reducing manual network management effort.
+ Combine dynamic pools for general clients with static leases for servers/printers.
- Avoid mixing host-only mode with bridged adapters in production to prevent security risks.
! Test configurations in isolated environments before deployment.
```

### Quick Reference
- Install DHCP: `dnf install dhcp-server -y`
- Configure file: `/etc/dhcp/dhcpd.conf`
- Start service: `systemctl start dhcpd`
- Firewall: `firewall-cmd --add-service=dhcp --permanent`

### Expert Insight
**Real-world Application**: In large corporate networks, DHCP integrates with Active Directory for centralized management and security policies.
**Expert Path**: Master DHCP failover, relay agents, and integration with technologies like DNS for dynamic updates (DDNS).
**Common Pitfalls**: Overlapping subnets cause lease conflicts; always back up configs before changes, and monitor lease logs for unauthorized devices.

</details>
