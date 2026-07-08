<details open>
<summary><b> Section 06: Debian Server Networking Configuration</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Beginner Level Exercises

### Exercise 1.1: Networking Service Identification and Status
**Objective**: Master identification and status checking of the Debian networking service

**Tasks**:
1. Identify if the networking service is installed and active
2. Compare different methods to check service status (systemctl, service, init.d)
3. Document the difference between active and enabled states
4. Create a status checking procedure document

**Commands**:
```bash
systemctl status networking.service
systemctl status networking
service networking status
/etc/init.d/networking status
systemctl is-active networking
systemctl is-enabled networking
```

**Deliverable**: Comprehensive guide for checking networking service status across different methods.

### Exercise 1.2: Understanding the Interfaces Configuration File
**Objective**: Navigate and understand the /etc/network/interfaces file structure

**Tasks**:
1. Locate and examine the interfaces configuration file
2. Identify loopback and primary interface configurations
3. Document the syntax for interface declarations
4. Map interface names to their physical devices

**Commands**:
```bash
cat /etc/network/interfaces
ls -la /etc/network/
vim /etc/network/interfaces
ip link show
cat /sys/class/net/*/address
```

**Deliverable**: Documentation explaining the interfaces file structure with annotated examples.

### Exercise 1.3: Using ip Commands for Network Analysis
**Objective**: Master the ip command suite for network interface analysis

**Tasks**:
1. Use `ip a` to display all network interface information
2. Use `ip r` to display routing information
3. Combine commands using semicolons and double ampersands
4. Identify interface names, IP addresses, and default gateways

**Commands**:
```bash
ip a
ip addr show
ip r
ip route show
ip a; ip r
ip a && ip r
ip -brief addr show
ip -c addr show
```

**Deliverable**: Network analysis worksheet with command outputs and interpretations.

## Intermediate Level Exercises

### Exercise 2.1: Service Lifecycle Management
**Objective**: Master starting, stopping, enabling, and disabling the networking service

**Tasks**:
1. Safely stop and start the networking service
2. Enable and disable service persistence across reboots
3. Use `--now` flag for combined operations
4. Document the impact of service states on network connectivity

**Commands**:
```bash
systemctl stop networking
systemctl start networking
systemctl restart networking
systemctl reload networking
systemctl enable networking
systemctl disable networking
systemctl --now enable networking
systemctl --now disable networking
```

**Deliverable**: Service management playbook with safe operation procedures and impact analysis.

### Exercise 2.2: Configuring DHCP (Dynamic) IP Addresses
**Objective**: Configure and troubleshoot DHCP-based network addressing

**Tasks**:
1. Modify the interfaces file to use DHCP instead of static
2. Apply changes without rebooting using ifdown/ifup
3. Verify DHCP lease acquisition
4. Document the complete DHCP configuration process

**Commands**:
```bash
vim /etc/network/interfaces
# Change: iface ens3 inet dhcp
ifdown ens3
ifup ens3
ip a show ens3
cat /var/lib/dhcp/dhclient.leases
dhclient -v ens3
```

**Deliverable**: Step-by-step DHCP configuration guide with verification steps and troubleshooting tips.

### Exercise 2.3: Implementing Static IP Configuration
**Objective**: Configure static IP addresses for server environments

**Tasks**:
1. Configure a static IP address with proper CIDR notation
2. Set the default gateway correctly
3. Apply configuration changes safely
4. Validate connectivity after changes

**Commands**:
```bash
# Example configuration:
# iface ens3 inet static
#     address 192.168.1.100/24
#     gateway 192.168.1.1
ifdown ens3 && ifup ens3
ip addr show ens3
ping -c 4 192.168.1.1
ping -c 4 example.com
ifquery ens3
```

**Deliverable**: Static IP configuration documentation with examples for different network scenarios.

## Advanced Level Exercises

### Exercise 3.1: DNS Configuration and Management
**Objective**: Configure and manage DNS settings for name resolution

**Tasks**:
1. Examine and modify /etc/resolv.conf
2. Configure alternative DNS servers (Google, Cloudflare)
3. Test DNS resolution after changes
4. Implement DNS configuration best practices

**Commands**:
```bash
cat /etc/resolv.conf
vim /etc/resolv.conf
# nameserver 8.8.8.8
# nameserver 1.1.1.1
nslookup example.com
dig example.com
host example.com
resolvectl status  # systemd-resolved
systemd-resolve --status
```

**Deliverable**: DNS configuration guide with testing procedures and performance comparisons.

### Exercise 3.2: Network Interface State Management
**Objective**: Master advanced interface management techniques

**Tasks**:
1. Use ifquery to inspect interface configurations
2. Implement proper down/up sequences for configuration changes
3. Handle interface naming differences across systems
4. Create automated interface management scripts

**Commands**:
```bash
ifquery --list
ifquery ens3
ifquery --allow=auto
ifdown -a
ifup -a
ifdown ens3 --verbose
ifup ens3 --verbose
cat /etc/network/interfaces.d/*
```

**Deliverable**: Interface management automation scripts with error handling and logging.

### Exercise 3.3: Cloud Environment Networking (AWS Debian)
**Objective**: Adapt Debian networking knowledge for cloud environments

**Tasks**:
1. Analyze network configuration in AWS Debian instances
2. Compare cloud-init configurations with traditional setups
3. Document differences in network interface naming
4. Create migration guides between on-premise and cloud networking

**Commands**:
```bash
cat /etc/debian_version
systemctl status networking
systemctl status systemd-networkd
ls /run/systemd/network/
cat /run/systemd/network/*.network
cat /run/systemd/network/*.link
cloud-init query --all
```

**Deliverable**: Cloud networking adaptation guide with configuration comparisons and migration procedures.

</details>

<details>
<summary><b>Set-02 Assignment</b></summary>

## Beginner Level Exercises

### Exercise 1.1: Advanced Service Status Analysis
**Objective**: Deep dive into interpreting detailed systemctl output for networking services

**Tasks**:
1. Analyze all fields in systemctl status output (Loaded, Active, Docs, Main PID, Tasks, Memory, CPU)
2. Compare journalctl output with systemctl status
3. Create custom status monitoring commands with specific output formats
4. Document warning and error patterns in service status

**Commands**:
```bash
systemctl status networking --full --no-pager
systemctl show networking
systemctl show networking --property=ActiveState,SubState,LoadState
journalctl -u networking --no-pager -n 20
systemctl list-dependencies networking --reverse
```

**Deliverable**: Service analysis template with field explanations and troubleshooting indicators.

### Exercise 1.2: Network Interface Deep Inspection
**Objective**: Master detailed network interface analysis using multiple tools

**Tasks**:
1. Use `ethtool` to gather detailed interface statistics
2. Analyze interface statistics from `/sys/class/net/`
3. Compare `ip` command output with `/proc/net/` information
4. Document interface capabilities and supported features

**Commands**:
```bash
ethtool ens3
ethtool -S ens3
ethtool --show-features ens3
cat /sys/class/net/ens3/statistics/*
cat /proc/net/dev
ss -tuln
netstat -i 2>/dev/null || ip -s link
```

**Deliverable**: Interface analysis report with performance metrics and capability documentation.

### Exercise 1.3: Command History and Automation Basics
**Objective**: Leverage shell history and create basic automation for network tasks

**Tasks**:
1. Master command history navigation and search
2. Create shell aliases for common network commands
3. Build simple one-liner commands for network diagnostics
4. Document efficient workflows for network management

**Commands**:
```bash
history | grep -E "ip |systemctl "
Ctrl+R for reverse search
alias ipa='ip a'
alias ipr='ip r'
alias netstat='systemctl status networking'
!! to repeat last command
!systemctl to repeat last systemctl command
```

**Deliverable**: Personal network management cheat sheet with aliases and efficient command patterns.

## Intermediate Level Exercises

### Exercise 2.1: Advanced DHCP Troubleshooting and Analysis
**Objective**: Deep troubleshooting of DHCP client operations and lease management

**Tasks**:
1. Analyze DHCP client logs and lease file contents
2. Manually trigger DHCP renewals and releases
3. Configure custom DHCP client options
4. Debug DHCP failures with verbose output

**Commands**:
```bash
dhclient -r ens3  # Release
dhclient -v ens3  # Verbose request
cat /var/lib/dhcp/dhclient.*.leases
tail -f /var/log/syslog | grep -i dhcp
dhcpcd --dumplease ens3
systemd-resolve --status
journalctl -u systemd-networkd -f
```

**Deliverable**: DHCP troubleshooting guide with common issues, log analysis, and resolution steps.

### Exercise 2.2: Complex Static Network Configurations
**Objective**: Implement advanced static networking features in Debian

**Tasks**:
1. Configure multiple IP addresses on a single interface
2. Set up custom routing tables and policy routing
3. Implement network bonding/teaming configurations
4. Create VLAN interfaces for network segmentation

**Commands**:
```bash
# Multiple IPs
iface ens3 inet static
    address 192.168.1.100/24
    gateway 192.168.1.1
iface ens3 inet static
    address 192.168.1.101/24

# Custom routing
ip route add 10.0.0.0/8 via 192.168.1.1 dev ens3
echo "100 custom" >> /etc/iproute2/rt_tables
ip rule add from 192.168.1.100 table custom

# VLAN configuration
iface ens3.100 inet static
    address 192.168.100.1/24
    vlan-raw-device ens3
```

**Deliverable**: Advanced configuration examples with verification procedures and rollback plans.

### Exercise 2.3: DNS Optimization and Failover Configuration
**Objective**: Optimize DNS configuration with multiple servers and failover

**Tasks**:
1. Configure multiple DNS servers with priority ordering
2. Implement DNS caching strategies
3. Set up DNS search domains and options
4. Create DNS failover testing procedures

**Commands**:
```bash
# Multiple nameservers with options
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1
options timeout:2 attempts:3 rotate
search example.com local.lan

# Test resolution paths
dig @8.8.8.8 example.com
host -v example.com 8.8.8.8
getent hosts example.com
strace -e trace=network host example.com 2>&1 | grep -i send
```

**Deliverable**: DNS optimization documentation with performance testing results and failover procedures.

## Advanced Level Exercises

### Exercise 3.1: Network Automation with Scripts and Ansible
**Objective**: Create automated network configuration management

**Tasks**:
1. Write bash scripts for automated network configuration
2. Create configuration validation and backup scripts
3. Implement configuration deployment with version control
4. Design automated testing and rollback procedures

**Commands**:
```bash
#!/bin/bash
# backup-config.sh
cp /etc/network/interfaces /etc/network/interfaces.backup.$(date +%Y%m%d)
# validate-config.sh
ifup --no-act ens3 && echo "Config valid" || echo "Config error"
# deploy-config.sh with git integration
git add /etc/network/interfaces
git commit -m "Network config update $(date)"
```

**Deliverable**: Complete automation toolkit with scripts, documentation, and CI/CD integration examples.

### Exercise 3.2: Network Security Hardening for Debian Servers
**Objective**: Implement network security best practices and hardening

**Tasks**:
1. Configure firewall rules with iptables/nftables
2. Implement network intrusion detection
3. Set up secure DNS with DNSSEC validation
4. Create network security monitoring and alerting

**Commands**:
```bash
# Basic firewall
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -P INPUT DROP

# DNSSEC validation
dnssec-triggerd
unbound-control status
dig +dnssec example.com

# Network monitoring
ss -tuln | grep LISTEN
nmap -sV localhost
tcpdump -i ens3 -c 100 host not 127.0.0.1
```

**Deliverable**: Security hardening guide with configuration templates and compliance checklists.

### Exercise 3.3: High Availability and Redundancy Configuration
**Objective**: Design and implement network redundancy for critical services

**Tasks**:
1. Configure network interface bonding with multiple modes
2. Implement VRRP/keepalived for gateway redundancy
3. Set up DNS round-robin and health checking
4. Create failover testing and monitoring procedures

**Commands**:
```bash
# Bonding configuration
iface bond0 inet static
    bond-slaves ens3 ens4
    bond-mode 802.3ad
    bond-miimon 100
    address 192.168.1.100/24

# Keepalived setup
vrrp_instance VI_1 {
    interface ens3
    virtual_router_id 51
    priority 100
    advert_int 1
    virtual_ipaddress {
        192.168.1.200/24
    }
}

# Monitoring script
while true; do
    ping -c 1 192.168.1.1 >/dev/null && echo "Gateway OK" || echo "Gateway DOWN"
    sleep 5
done
```

**Deliverable**: High availability deployment guide with configuration examples, testing procedures, and recovery documentation.

</details>
</details>