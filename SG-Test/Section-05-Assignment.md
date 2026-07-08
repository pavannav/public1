<details open>
<summary><b> Section 05: Linux Networking Services</b></summary>

<details>
<summary><b>Set-01 Assignment</b></summary>

## Beginner Level Exercises

### Exercise 1.1: Identifying Active Networking Services
**Objective**: Determine which networking service is active on a Linux system

**Tasks**:
1. Check which of the three networking services (networking, networkd, NetworkManager) is installed
2. Identify which service is currently active using systemctl
3. Document the enabled/disabled status of each service
4. Note which distribution type is using which service

**Commands**:
```bash
systemctl list-unit-files | grep -E "network|NetworkManager"
systemctl is-active NetworkManager networking systemd-networkd
systemctl is-enabled NetworkManager networking systemd-networkd
systemctl status NetworkManager
```

**Deliverable**: Report identifying the active networking service and its status on your system.

### Exercise 1.2: Basic Network Service Status Monitoring
**Objective**: Monitor and interpret networking service status output

**Tasks**:
1. Run systemctl status for each networking service
2. Interpret the output: active/running, enabled, loaded status
3. Identify any failed or inactive services
4. Document the differences in status output between services

**Commands**:
```bash
systemctl status NetworkManager --no-pager
systemctl status networking --no-pager
systemctl status systemd-networkd --no-pager
systemctl --failed | grep -i network
journalctl -u NetworkManager --since "1 hour ago"
```

**Deliverable**: Documentation explaining how to interpret systemctl status output for networking services.

### Exercise 1.3: Network Information Retrieval Methods
**Objective**: Explore different methods to retrieve network connection information

**Tasks**:
1. Use nmcli to display all network connections
2. Compare nmcli output with ip addr output
3. Identify IP addresses, interfaces, and connection states
4. Document connection details in a structured format

**Commands**:
```bash
nmcli
nmcli device status
nmcli connection show
ip addr show
ip -brief addr show
nmcli -f NAME,UUID,TYPE,DEVICE connection
```

**Deliverable**: Comparison table of network information from different command outputs.

## Intermediate Level Exercises

### Exercise 2.1: Service Management and Dependencies
**Objective**: Understand service dependencies and management commands

**Tasks**:
1. Identify service dependencies for each networking service
2. Practice safe service restart procedures
3. Document the impact of stopping/starting services
4. Create a service management checklist

**Commands**:
```bash
systemctl list-dependencies NetworkManager
systemctl list-dependencies systemd-networkd
systemctl cat NetworkManager
sudo systemctl restart NetworkManager
systemctl daemon-reload
systemctl mask/unmask [service]
```

**Deliverable**: Service management documentation with dependency maps and safe operation procedures.

### Exercise 2.2: NetworkManager Connection Profiling
**Objective**: Work with NetworkManager connection profiles

**Tasks**:
1. List all configured connection profiles
2. Examine detailed connection properties
3. Identify active vs inactive connections
4. Document connection type and configuration details

**Commands**:
```bash
nmcli connection show --active
nmcli connection show "Connection Name"
nmcli connection show --show-secrets
nmcli -g connection.uuid connection show
cat /etc/NetworkManager/system-connections/*.nmconnection 2>/dev/null || ls /etc/NetworkManager/system-connections/
```

**Deliverable**: Connection profile documentation with properties and configuration examples.

### Exercise 2.3: Service Logs and Troubleshooting Basics
**Objective**: Analyze networking service logs for troubleshooting

**Tasks**:
1. Examine recent service logs for errors or warnings
2. Identify common log patterns and their meanings
3. Document log locations and rotation settings
4. Create a basic troubleshooting checklist

**Commands**:
```bash
journalctl -u NetworkManager -p err
journalctl -u systemd-networkd --since today
journalctl -u networking -n 50
sudo ls -la /var/log/ | grep -i network
grep -i network /var/log/syslog 2>/dev/null | tail -20
```

**Deliverable**: Log analysis guide with common issues and their log signatures.

## Advanced Level Exercises

### Exercise 3.1: Multi-Service Environment Configuration
**Objective**: Configure systems to switch between different networking services

**Tasks**:
1. Document the process to switch from one networking service to another
2. Configure fallback mechanisms between services
3. Create service priority rules
4. Test service switching in a controlled environment

**Commands**:
```bash
systemctl disable --now NetworkManager
systemctl enable --now systemd-networkd
systemctl mask NetworkManager
systemctl unmask NetworkManager
update-rc.d networking defaults  # Debian/Ubuntu
chkconfig network on  # RHEL/CentOS
```

**Deliverable**: Service switching guide with configuration files and validation steps.

### Exercise 3.2: Custom Network Service Monitoring Script
**Objective**: Create automated monitoring for networking services

**Tasks**:
1. Write a script to monitor all three networking services
2. Include status checks, log analysis, and alerting
3. Add performance metrics collection
4. Implement automated recovery procedures

**Script Template**:
```bash
#!/bin/bash
# Monitor networking services
SERVICES=("NetworkManager" "networking" "systemd-networkd")
for service in "${SERVICES[@]}"; do
    status=$(systemctl is-active $service)
    enabled=$(systemctl is-enabled $service)
    echo "$service: $status (enabled: $enabled)"
done
```

**Deliverable**: Complete monitoring script with documentation and cron integration examples.

### Exercise 3.3: Distribution-Specific Networking Implementation
**Objective**: Analyze and document networking implementations across distributions

**Tasks**:
1. Document which distributions use which networking service by default
2. Create comparison matrix of service features
3. Identify distribution-specific configuration locations
4. Map service capabilities to distribution requirements

**Commands**:
```bash
cat /etc/os-release
lsb_release -a 2>/dev/null
which NetworkManager nmcli networkctl
dpkg -l | grep -E "network-manager|ifupdown|systemd-networkd"
rpm -qa | grep -E "NetworkManager|network-scripts|systemd-networkd"
```

**Deliverable**: Distribution networking matrix with service mappings and configuration paths.

</details>
</details>