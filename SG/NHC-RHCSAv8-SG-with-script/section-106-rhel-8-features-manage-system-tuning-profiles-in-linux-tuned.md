<details open>
<summary><b>Section 106: System Tuning Profiles (CL-KK-Terminal)</b></summary>

# Section 106: System Tuning Profiles

### Table of Contents
- [106.1 What are System Tuning Profiles](#1061-what-are-system-tuning-profiles)
- [106.2 Why Use System Tuning Profiles](#1062-why-use-system-tuning-profiles)
- [106.3 Types of System Tuning](#1063-types-of-system-tuning)
- [106.4 Practical Implementation: Installing and Configuring Tuned](#1064-practical-implementation-installing-and-configuring-tuned)
- [106.5 Viewing and Applying Pre-defined Profiles](#1065-viewing-and-applying-pre-defined-profiles)
- [106.6 Creating and Applying Custom Profiles](#1066-creating-and-applying-custom-profiles)

## 106.1 What are System Tuning Profiles

### Overview
System tuning profiles are predefined or custom configurations that optimize system performance, resource utilization, and power management in Linux environments (particularly RHEL/CentOS). They allow administrators to automatically adjust kernel parameters, system settings, and resource allocation based on specific use cases like web servers, databases, or virtualized environments.

### Key Concepts

System tuning profiles provide:
- **Dynamic Resource Management**: Automatic monitoring and adjustment of system resources
- **Pre-defined Configurations**: Built-in profiles for common scenarios
- **Custom Profile Support**: Ability to create tailored configurations

### Deep Dive
The **tuned** daemon is the core component for implementing system tuning profiles. It provides:
- Real-time monitoring of system resource utilization
- Automatic application of optimized settings
- Profile-based configuration management

> [!NOTE]
> Tuned is similar to power plans in Windows control panel, where different profiles (like "balanced" vs "high performance") adjust resource allocation accordingly.

## 106.2 Why Use System Tuning Profiles

### Overview
System tuning profiles are essential for optimizing server performance, especially in enterprise environments where applications require specific resource allocation patterns. They help system administrators maximize efficiency without manual configuration of hundreds of parameters.

### Key Concepts

Profiles help achieve:
- **Maximum Performance**: For CPU-intensive applications
- **Optimal Resource Utilization**: Ensuring efficient hardware usage
- **Power Management**: Reduced energy consumption when performance isn't critical
- **Application-specific Optimization**: Database vs. web server configurations

### Deep Dive

**Performance Enhancement through Resource Monitoring:**
- **Automatic Detection**: Tuned monitors how resources are utilized
- **Intelligent Recommendations**: Suggests optimal profiles based on system workload
- **Dynamic Adjustments**: Continuously tunes parameters in real-time

This is particularly crucial in production environments where services like databases, web applications, or virtualization need optimal performance allocation.

> [!IMPORTANT]
> System administrators typically perform custom tuning using tools like tuned instead of manual kernel parameter adjustments for scalability.

## 106.3 Types of System Tuning

### Overview
System tuning can be categorized into two main approaches: static and dynamic tuning. Each serves different purposes and has distinct implementation methods.

### Key Concepts

#### Static Tuning
- **Definition**: Pre-defined kernel parameters and system settings applied at service startup
- **Benefit**: Consistent configuration for predictable workloads
- **Use Case**: Web servers with steady traffic patterns

#### Dynamic Tuning
- **Definition**: Continuous, real-time monitoring and adjustment of parameters
- **Benefit**: Adaptive performance optimization based on actual workload
- **Use Case**: Variable load environments like databases

### Tables

| Tuning Type | Description | When to Use |
|-------------|-------------|------------|
| Static | Fixed parameters applied once at startup | Predictable workloads |
| Dynamic | Continuous monitoring and adjustment | Variable or unpredictable loads |

### Deep Dive
Static tuning applies configured parameters immediately when the tuned service starts, while dynamic tuning continuously varies parameters based on current system activity, providing adaptive performance management.

## 106.4 Practical Implementation: Installing and Configuring Tuned

### Overview
Implementing system tuning profiles requires installing the tuned package, starting the service, and understanding key configuration locations.

### Key Concepts

**Essential Directories and Files:**
- `/etc/tuned/` - Main configuration directory
- `/etc/tuned/tuned-main.conf` - Primary configuration file
- `/usr/lib/tuned/` - Location of built-in profile directories

### Lab Demonstration

**Installation and Service Startup:**
```bash
yum install tuned        # Install tuned package
systemctl start tuned    # Start the tuned service
systemctl enable tuned   # Enable service to start on boot
```

> [!IMPORTANT]
> Verify the tuned service is active before proceeding with profile management:
> ```bash
> systemctl status tuned
> ```

## 106.5 Viewing and Applying Pre-defined Profiles

### Overview
Tuned comes with multiple built-in profiles optimized for different use cases, from desktop environments to high-performance servers.

### Key Concepts

#### Pre-defined Profiles Include:
- **balanced**: General-purpose profile balancing power and performance
- **desktop**: Optimized for desktop usage
- **throughput-performance**: Maximum performance for disk/network intensive tasks
- **latency-performance**: Reduced latency for real-time applications
- **powersave**: Minimizes power consumption
- **virtual-guest**: Optimized for virtualized environments

### Available Profiles

| Profile | Use Case | Key Characteristics |
|---------|----------|-------------------|
| `balanced` | General computing | Balanced power/performance |
| `desktop` | Desktop systems | UI responsiveness focus |
| `throughput-performance` | Heavy I/O | Maximum disk/network performance |
| `latency-performance` | Real-time apps | Reduced system latency |
| `powersave` | Battery/power optimization | Minimal power consumption |
| `virtual-guest` | VMs | Resource sharing optimization |

### Lab Demonstration

**Viewing Current and Available Profiles:**
```bash
tuned-adm active           # Check currently active profile
tuned-adm list             # List all available profiles
tuned-adm profile balanced # Apply "balanced" profile
```

**Checking Profile Recommendations:**
```bash
tuned-adm recommend   # Shows recommended profile for current workload
```

**Disable Profile:**
```bash
tuned-adm off         # Disable all tuning profiles
```

## 106.6 Creating and Applying Custom Profiles

### Overview
Beyond built-in profiles, administrators can create custom profiles for specific application requirements by defining kernel parameters, system settings, and shell scripts.

### Key Concepts

#### Custom Profile Components:
- **Main Section**: Basic profile metadata
- **CPU/Core Parameters**: Processor optimizations
- **Disk Parameters**: Storage optimizations  
- **Network Parameters**: NIC configurations
- **Power Settings**: Power management
- **Scripts**: Custom shell commands

### Lab Demonstration

**Creating Custom Profile Structure:**
```bash
# Create profile directory
mkdir /etc/tuned/custom-profile

# Create tuned.conf file
vi /etc/tuned/custom-profile/tuned.conf
```

**Sample Custom Profile (tuned.conf):**
```ini
[main]
summary=Custom performance profile for latency-sensitive applications

[cpu]
governor=performance
energy_perf_bias=performance

[disk]
readahead=>4096

[sysctl]
kernel.sched_min_granularity_ns=10000000
kernel.sched_wakeup_granularity_ns=15000000
vm.dirty_ratio=10

[script]
script=${i:PROFILE_DIR}/custom-script.sh
```

**Custom Script Example (custom-script.sh):**
```bash
#!/bin/bash
# Custom tuning commands
echo never > /sys/kernel/mm/transparent_hugepage/enabled
```

**Apply Custom Profile:**
```bash
chmod +x /etc/tuned/custom-profile/custom-script.sh
tuned-adm profile custom-profile
tuned-adm active  # Verify profile is applied
```

**Create Profile Without Script:**
```ini
[main] 
summary=Minimal custom profile

[cpu]
force_latency=1

[vm]
transparent_hugepages=never
```

### Lab Demos
1. **Product Range Network Profile**: Configure network settings for web servers
2. **Database Performance Profile**: Optimize for database workloads with specific kernel parameters

## Summary

### Key Takeaways
```diff
+ System tuning profiles automatically optimize Linux systems for specific use cases
+ Tuned daemon provides both static and dynamic tuning capabilities  
+ Built-in profiles cover common scenarios (balanced, performance, power-saver)
+ Custom profiles allow unlimited flexibility for application-specific requirements
+ Profile switching provides easy testing and rollback of configurations
- Manual parameter tuning is time-consuming and error-prone
```

### Quick Reference
**Essential Commands:**
```bash
# Install and start tuned
yum install tuned
systemctl start tuned

# Profile management  
tuned-adm active       # Current active profile
tuned-adm list         # List all profiles
tuned-adm recommend    # Recommended profile
tuned-adm profile NAME # Apply specific profile
tuned-adm off          # Disable tuning

# Custom profiles
mkdir /etc/tuned/custom-profile
vi /etc/tuned/custom-profile/tuned.conf
tuned-adm profile custom-profile
```

**Important Files:**
- `/etc/tuned/tuned-main.conf` - Main configuration
- `/usr/lib/tuned/` - Profile definitions
- `/etc/tuned/` - Custom profile directory

### Expert Insight

#### Real-world Application
Production environments use tuned profiles extensively:
- **Web Servers**: Apply latency-performance profiles for response time optimization
- **Databases**: Custom profiles with memory management and I/O scheduling
- **Cloud VMs**: Virtual-guest profiles for resource sharing efficiency
- **HPC Clusters**: Throughput-performance for computational workloads

#### Expert Path  
Master system tuning by:
- Understanding kernel parameters via `/proc/sys/` and `sysctl`
- Monitoring performance with `sar`, `vmstat`, and tuned logs
- Creating application-specific profiles based on workload analysis
- Testing profile impacts with benchmark tools before production deployment

#### Common Pitfalls
+ ❌ Not verifying profile application after switching
+ ❌ Creating overly complex custom profiles without testing
+ ❌ Ignoring hardware-specific optimizations
+ ❌ Failing to monitor performance metrics after profile changes
+ ❌ Not planning rollback procedures for profile changes

</details>
