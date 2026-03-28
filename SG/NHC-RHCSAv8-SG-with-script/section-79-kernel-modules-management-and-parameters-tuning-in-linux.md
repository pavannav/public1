# Section 79: Kernel Modules, Management and Parameters Tuning

<details open>
<summary><b>Section 79: Kernel Modules, Management and Parameters Tuning (CL-KK-Terminal)</b></summary>

> **Kernel modules and parameters tuning are essential for system administrators to extend kernel functionality without recompiling, optimize performance, and troubleshoot issues in Linux environments.**

## Table of Contents
- [Kernel Modules Overview](#kernel-modules-overview)
- [Kernel Module Management](#kernel-module-management)
- [Creating Kernel Modules](#creating-kernel-modules)
- [Dynamic Library Management](#dynamic-library-management)
- [Kernel Parameters Tuning](#kernel-parameters-tuning)

## Kernel Modules Overview

A kernel module is a piece of code that can be loaded and unloaded into the kernel on demand. This allows extending the kernel's functionality without requiring a full kernel rebuild and reboot. Kernel modules provide flexibility for hardware support, filesystem drivers, and custom functionality.

### Key Concepts
Kernel modules are object files (`.ko` extension) stored in `/lib/modules/$(uname -r)/` directory. They can be loaded manually using `insmod` or automatically based on hardware detection and dependencies.

Common commands for kernel information:
```bash
# Check kernel version
uname -r

# View kernel boot messages
dmesg

# Check current boot parameters
cat /proc/cmdline
```

### Kernel Source Download
To work with kernel modules, you often need kernel development packages:

**Installation steps:**
```bash
# Install development tools group
dnf install -y @development-tools

# Install kernel development packages
dnf install -y kernel-devel kernel-headers

# Download kernel source (example for kernel 4.18.0)
wget https://kernel.org/pub/linux/kernel/v4.x/linux-4.18.0.tar.xz
tar -xf linux-4.18.0.tar.xz
cd linux-4.18.0
```

## Kernel Module Management

Kernel modules are managed through various commands. The system maintains dependencies and can load/unload modules automatically or manually.

### Listing Loaded Modules
```bash
# List all currently loaded modules
lsmod

# More detailed view
lsmod | cat

# View module information
modinfo <module_name>

# Check for specific module
lsmod | grep <module_name>
```

### Loading and Unloading Modules
```bash
# Load a module
insmod <module_name.ko>
# OR
modprobe <module_name>  # Handles dependencies automatically

# Unload a module
rmmod <module_name>

# Force unload (if in use)
rmmod -f <module_name>

# Remove with modprobe
modprobe -r <module_name>
```

### Module Dependencies
Module dependencies are tracked in `/lib/modules/$(uname -r)/modules.dep`. The `modprobe` command automatically resolves dependencies, while `insmod` does not.

**Example**: Loading video module with dependencies:
```bash
modprobe video
# This may automatically load dependent modules
```

### Lab Demo: Module Operations
```bash
# 1. Check if module is loaded
lsmod | grep video

# 2. Load module
modprobe video

# 3. Verify loading
lsmod | grep video

# 4. Check module information
modinfo video

# 5. Unload module
modprobe -r video
```

## Creating Kernel Modules

To create custom kernel modules, you need kernel development tools and a basic understanding of C programming.

### Development Setup
```bash
# Install necessary packages
dnf install -y @development-tools
dnf install -y kernel-devel kernel-headers

# Source code location
cd /usr/src/kernels/$(uname -r)/
```

### Basic Module Structure
**hello.c** - A simple kernel module:
```c
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Vikas Nehra");
MODULE_DESCRIPTION("Simple Linux Kernel Module");

static int __init hello_init(void)
{
    printk(KERN_INFO "Hello World - Module Loaded\n");
    return 0;
}

static void __exit hello_exit(void)
{
    printk(KERN_INFO "Goodbye World - Module Unloaded\n");
}

module_init(hello_init);
module_exit(hello_exit);
```

**Makefile** for compilation:
```makefile
obj-m += hello.o

all:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
    make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
```

### Compilation Steps
```bash
# Compile the module
make

# This creates hello.ko file

# Load the compiled module
insmod hello.ko

# Check kernel messages
dmesg | tail

# Unload the module
rmmod hello

# Verify unloading
dmesg | tail
```

### Module with Cleanup Function
```c
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

MODULE_LICENSE("GPL");

static int __init hello_init(void)
{
    printk(KERN_INFO "Module loaded successfully\n");
    return 0;
}

static void __exit hello_exit(void)
{
    printk(KERN_INFO "Module unloaded and cleaned up\n");
}

module_init(hello_init);
module_exit(hello_exit);
```

## Dynamic Library Management

Libraries are shared objects that provide functions to multiple programs. Linux uses shared libraries (`.so` files) for efficient memory usage and code reuse.

### Library Locations
- System libraries: `/lib64/`, `/usr/lib64/`
- Kernel libraries: Part of kernel modules
- Custom libraries: `/usr/local/lib/`

### Library Operations
```bash
# View library dependencies of a program
ldd /bin/bash

# View detailed library information
objdump -p /bin/bash

# Check system library performance
strace -c /bin/bash
```

### File Permissions and Library Analysis
```bash
# Make file read-only
chmod 400 testfile

# Monitor system calls for file operations
strace -e trace=file cat testfile > /dev/null

# View strace output file
cat strace_output.txt
```

## Kernel Parameters Tuning

Kernel parameters control various system behaviors and can be tuned for specific requirements like database installations, security hardening, or performance optimization.

### Viewing Parameters
```bash
# View all sysctl parameters
sysctl -a

# View specific parameter
sysctl kernel.shmall

# Alternative method
cat /proc/sys/kernel/shmall
```

### Temporary Tuning
```bash
# Change parameter temporarily
sysctl -w kernel.shmall=2097152

# Multiple parameters
sysctl -w kernel.shmmax=4294967296 -w kernel.shmall=2097152
```

### Permanent Tuning
Edit `/etc/sysctl.conf` file:
```bash
# Add or modify parameters
kernel.shmall = 2097152
kernel.shmmax = 4294967296
net.core.somaxconn = 65536

# Load changes without reboot
sysctl -p

# Verify changes
sysctl kernel.shmall
```

### Application Examples
**Oracle Database Setup:**
```bash
# Common parameters for Oracle
kernel.shmall = 2097152
kernel.shmmax = 4294967296
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
fs.file-max = 6815744
net.ipv4.ip_local_port_range = 9000 65500
```

**High Performance Networking:**
```bash
net.core.rmem_default = 262144
net.core.rmem_max = 262144
net.core.wmem_default = 262144
net.core.wmem_max = 262144
```

## Summary

### Key Takeaways
```diff
+ Kernel modules extend functionality without recompilation
+ Use modprobe for dependency-aware loading, insmod for direct loading
+ sysctl provides both temporary and permanent parameter tuning
+ Regular kernel updates are crucial for security and features
- Always check module dependencies before manual loading
! Back up sysctl.conf before making permanent changes
- Test parameter changes in non-production environments first
```

### Quick Reference
```bash
# Module management
lsmod                    # List loaded modules
modinfo <module>         # Module information
modprobe <module>        # Load with dependencies
rmmod <module>           # Unload module

# Parameter tuning
sysctl -a               # View all parameters
sysctl -w <param>=<val> # Temporary change
sysctl -p               # Load from /etc/sysctl.conf

# Kernel development
make -C /lib/modules/$(uname -r)/build M=$(PWD) modules
```

### Expert Insight

**Real-world Application**: Kernel parameter tuning is critical for enterprise applications like databases (Oracle, PostgreSQL) and high-throughput systems requiring specific memory, network, and I/O optimizations.

**Expert Path**: Start with system monitoring tools like `sar`, `vmstat`, and `iostat` to identify bottlenecks before tuning. Always document changes and have rollback plans. Participate in kernel mailing lists for advanced discussions.

**Common Pitfalls**: 
- Loading incompatible modules without dependency checks
- Making permanent sysctl changes without testing
- Not updating kernel regularly, leaving security vulnerabilities
- Over-tuning parameters without monitoring actual performance impact

</details>
