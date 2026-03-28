# Section 96: KVM - Kernel-based Virtual Machine

<details open>
<summary><b>Section 96: KVM - Kernel-based Virtual Machine (CL-KK-Terminal)</b></summary>

## Table of Contents
- [What is KVM?](#what-is-kvm)
- [KVM Features and Benefits](#kvm-features-and-benefits)
- [Hardware Requirements for KVM](#hardware-requirements-for-kvm)
- [Enabling Virtualization in BIOS/UEFI](#enabling-virtualization-in-biosuefi)
- [Installing KVM Packages via DNF](#installing-kvm-packages-via-dnf)
- [Configuring and Starting KVM Services](#configuring-and-starting-kvm-services)
- [Setting Up Network Bridge for VMs](#setting-up-network-bridge-for-vms)
- [Creating Virtual Machines with Cockpit](#creating-virtual-machines-with-cockpit)
- [Installing OS on Virtual Machines](#installing-os-on-virtual-machines)
- [Managing Virtual Machines](#managing-virtual-machines)
- [Summary](#summary)

## What is KVM?

### Overview
KVM (Kernel-based Virtual Machine) is an open-source virtualization technology that allows you to convert your Linux machine into a Type-1 bare-metal hypervisor. It uses loadable kernel modules to create virtual operating systems, enabling you to run multiple VMs on a single physical host.

### Key Concepts/Deep Dive
- **Definition**: Loadable kernel module (Technology Access Management) that creates a virtual operating system platform using Type-1/Bare-metal hypervisor architecture.
- **Purpose**: Enables running virtual machines within your physical machine, similar to running VirtualBox or VMware Workstation, but as a kernel-integrated solution.
- **Origin**: Originally developed for RHEL/CentOS but now available on various Linux distributions including Ubuntu.

## KVM Features and Benefits

### Overview
KVM provides numerous advantages for server management, testing, and development environments without requiring separate licensing or expensive hardware.

### Key Concepts/Deep Dive

KVM offers:
- **Open Source**: No licensing costs required
- **Kernel Integration**: Tightly integrated with Linux kernel
- **Performance**: Near-native performance for virtualized workloads
- **Flexibility**: Supports multiple guest operating systems

```diff
- Traditional hypervisors: Separate layer between HW and OS
+ KVM: Direct kernel integration with hardware access
! KVM enables running Windows/Linux VMs simultaneously
```

## Hardware Requirements for KVM

### Overview
Before implementing KVM, your hardware must support virtualization technology and have sufficient resources allocated for virtual machines.

### Key Concepts/Deep Dive
Critical requirements include:

1. **Hardware Virtualization Support**:
   - Intel VT-x/AMD-V processors
   - **⚠️ Cannot run nested virtualization on AMDs (will return errors)**

2. **Resource Allocation**:
   - **Memory**: Minimum 2GB RAM per VM + host overhead
   - **Storage**: Adequate disk space for VM images (20GB+ recommended)
   - **CPU**: Multiple cores for concurrent VM execution
   - **Network**: Separate interface or bridged networking

   > [!IMPORTANT]
   > Check hardware compatibility before installation. Intel machines use VT-x, while AMD uses AMD-V.

3. **BIOS/UEFI Settings**: Virtualization must be enabled in firmware settings.

## Enabling Virtualization in BIOS/UEFI

### Overview
Virtualization Technology (VT) must be enabled in your system's firmware settings before KVM can function properly.

### Key Concepts/Deep Dive

#### Checking Current Status
```bash
# Check if virtualization is supported
grep -E 'vmx|svm' /proc/cpuinfo

# For Intel processors
grep -o 'vmx' /proc/cpuinfo

# For AMD processors  
grep -o 'svm' /proc/cpuinfo
```

#### BIOS/UEFI Configuration Steps
1. **Restart machine and enter BIOS Setup**
   - Press F2/F10/F12/Delete (varies by manufacturer during boot)

2. **Navigate to CPU/Virtualization Settings**
   - Intel: `Intel Virtualization Technology (VT-x)` or `VT-d`
   - AMD: `Secure Virtual Machine (SVM)`

3. **Enable Relevant Settings**:
   ```diff
   + Intel VT-x: Enabled
   + VT-d: Enabled
   + AMD SVM: Enabled
   ```

4. **Save and Exit**
   - Power cycle the machine for settings to take effect

   > [!NOTE]
   > Some advanced servers may have these settings pre-enabled, while consumer-grade hardware may require manual activation.

## Installing KVM Packages via DNF

### Overview
KVM requires specific packages including Cockpit for web-based management and virtualization components that integrate with the kernel.

### Key Concepts/Deep Dive

#### Installing Core KVM Packages
```bash
# Install virtualization packages
dnf install @virtualization-hypervisor @virtualization-client @virtualization-platform @virtualization-tools -y

# Install Cockpit for web management
dnf install cockpit cockpit-machines -y
```

#### Verifying Installation
```bash
# Check installed packages
rpm -qa | grep -E '(qemu|libvirt|cockpit)'

# Verify KVM kernel modules
lsmod | grep -i kvm
```

### Tables
**Key KVM Packages and Their Purposes**

| Package | Purpose | Status |
|---------|---------|--------|
| `qemu-kvm` | CPU/hardware virtualization | Core VM engine |
| `libvirt` | VM management API | Interface layer |
| `cockpit-machines` | Web UI for VM management | GUI management |
| `virt-install` | Command-line VM installation | CLI tools |

## Configuring and Starting KVM Services

### Overview
KVM uses `libvirtd` service for VM management and Cockpit for web-based administration. These services must be properly configured and started.

### Key Concepts/Deep Dive

#### Service Configuration
```bash
# Start and enable libvirtd service
systemctl enable --now libvirtd
systemctl start libvirtd

# Verify libvirtd status
systemctl status libvirtd

# Start and enable Cockpit service  
systemctl enable --now cockpit.socket
systemctl start cockpit.socket

# Verify socket status
systemctl status cockpit.socket
```

#### Firewall Configuration (if applicable)
```bash
# Allow Cockpit through firewall
firewall-cmd --add-service=cockpit --permanent
firewall-cmd --reload
```

#### Accessing Web Interface
- Navigate to: `https://<IP_ADDRESS>:9090`
- Login with: `root` or privileged user credentials

   > [!IMPORTANT]
   > Cockpit uses SSL/TLS by default on port 9090. Accept the self-signed certificate for initial access.

## Setting Up Network Bridge for VMs

### Overview
For VMs to communicate with external networks using their own IP addresses (instead of NAT), configure a network bridge interface in Cockpit.

### Key Concepts/Deep Dive

#### Bridge Configuration Steps
1. **Access Network Settings in Cockpit**
   - Log into Cockpit web interface
   - Navigate to: **Networking** tab

2. **Create Bridge Interface**
   - Select: **Add Bridge**
   - Name: `virbr0` (default) or custom name
   - Attach to: Your physical ethernet interface (e.g., `eno1`, `eth0`)

3. **Apply Configuration**
   ```yaml
   # Bridge configuration example
   interfaces:
     - name: virbr0
       type: bridge
       bridge:
         ports: [eno1]  # Your physical interface
   ```

#### Verification
```bash
# Check bridge status
ip link show virbr0

# Verify bridge configuration
brctl show virbr0

# Check IP assignment
ip addr show virbr0
```

## Creating Virtual Machines with Cockpit

### Overview
Cockpit provides an intuitive web interface for creating KVM virtual machines, eliminating the need for command-line virtualization tools.

### Key Concepts/Deep Dive

#### VM Creation Process
1. **Navigate to VM Section**
   - Cockpit Dashboard → **Virtual Machines** tab

2. **Choose Installation Method**
   - **Local Install**: Use downloaded OS ISOs
   - **Download**: Fetch from official repositories
   - **Cloud Images**: Pre-configured cloud VMs
   - **Import**: Existing VM images

3. **Configure VM Specifications**
   ```yaml
   vm_config:
     name: "ubuntu-server"
     os: "Ubuntu 22.04"
     memory: 4096  # MB
     storage: 20   # GB
     cpu_cores: 2
   ```

4. **Set Installation Source**
   - Local path: `/var/lib/libvirt/images/ubuntu.iso`
   - Cloud URL: Direct download links

5. **Finalize and Launch**
   - Check: **"Immediately Start VM"** if desired
   - Apply → VM creation begins

#### Supported Formats
```diff
+ QCOW2: Preferred format for KVM
+ RAW: Direct disk images  
+ VMDK: VMware compatibility
- ISO: Boot media only (not for storage)
```

## Installing OS on Virtual Machines

### Overview
Once the VM is created, you can access its console through Cockpit to perform standard OS installation procedures.

### Key Concepts/Deep Dive

#### Installation Steps
1. **Access VM Console**
   - Cockpit → VM details → **Console** tab
   - VNC connection provides graphical access

2. **Follow OS Installation Wizard**
   - **Storage**: Configure partitions/disk layout
   - **User Accounts**: Set root/admin credentials
   - **Network**: Configure IP addressing (DHCP/static)
   - **Software**: Select packages to install

3. **Post-Installation Tasks**
   ```bash
   # Update packages
   apt update && apt upgrade  # Ubuntu/Debian
   dnf update                # RHEL/CentOS

   # Install essential tools
   apt install openssh-server
   systemctl enable --now ssh
   ```

   > [!NOTE]
   > Installation typically takes 20-40 minutes depending on ISO size and hardware performance.

#### Monitoring Installation Progress
Cockpit provides real-time:
- CPU utilization
- Memory consumption  
- Storage usage
- Network interface status

## Managing Virtual Machines

### Overview
Cockpit provides comprehensive VM management capabilities including start/stop, snapshots, export/import, and performance monitoring.

### Key Concepts/Deep Dive

#### Basic VM Operations
```bash
# Via libvirt commands
virsh list --all           # List all VMs
virsh start <vm-name>      # Start VM
virsh shutdown <vm-name>   # Graceful shutdown
virsh destroy <vm-name>    # Force stop
virsh undefine <vm-name>   # Delete VM
```

#### Export VM Configuration
- **Cockpit Method**:
  - VM → **More Actions** → **Export VM**
  - Choose export location (local/cloud storage)

- **Command Line**:
  ```bash
  virsh dumpxml <vm-name> > vm-config.xml
  cp /var/lib/libvirt/images/<vm>.qcow2 /backup/path/
  ```

#### Import VM Configuration  
- **Create from existing image**:
  - Cockpit → **Create VM** → **Import a virtual machine image**
  - Select: OVA/OVA, or separate disk+config files

### Lab Demos

**Creating Ubuntu VM via Cockpit**:
1. Download Ubuntu ISO to `/var/lib/libvirt/images/`
2. Open Cockpit → Virtual Machines
3. Click "Create VM" → Local Install
4. Specify: Name:"Ubuntu-Server", CPUs:2, Memory:4GB, Storage:20GB
5. Select ISO path and OS type
6. Check "Immediately Start VM" → Create
7. Access Console → Complete Ubuntu installation

**Network Bridge Setup**:
1. Cockpit → Networking → Add Bridge
2. Name: "br0", Interfaces: Attach physical NIC
3. Create VM with network type: "Bridge Device"
4. VM gets IP from same subnet as host

## Summary

### Key Takeaways
- KVM converts Linux machines into Type-1 hypervisors using kernel modules
- Cockpit provides web-based VM management without command-line complexity
- Hardware virtualization support (Intel VT-x/AMD-V) is mandatory
- Bridge networking enables VMs to obtain real IP addresses
- VMs can run any supported OS (Windows/Linux) simultaneously

### Quick Reference

**Essential Commands:**
```bash
# Install KVM components
dnf install @virtualization-hypervisor cockpit-machines

# Start services
systemctl enable --now libvirtd cockpit.socket

# Create VM via CLI (alternative)
virt-install --name ubuntu-vm \
  --ram 4096 \
  --disk path=/var/lib/libvirt/images/ubuntu.qcow2,size=20 \
  --vcpus 2 \
  --os-variant ubuntu22.04 \
  --network bridge=virbr0 \
  --graphics none \
  --location /path/to/ubuntu.iso
```

**Common Configuration Files:**
- VM configs: `/etc/libvirt/qemu/`
- Images location: `/var/lib/libvirt/images/`
- Network configs: `/etc/libvirt/qemu/networks/`

### Expert Insight

#### Real-world Application
In production environments, KVM with Cockpit enables:
- **Test/Development Environments**: Isolated testing without separate hardware
- **Cloud Infrastructure**: Building private cloud platforms
- **Container Orchestration**: Running Kubernetes nodes as VMs
- **Legacy Application Support**: Windows applications on Linux infrastructure

#### Expert Path
```diff
+ Master nested virtualization for advanced testing scenarios
+ Integrate with OpenStack for cloud management
+ Implement VM live migration for high availability
+ Learn Open vSwitch for advanced networking topologies
```

#### Common Pitfalls
- **BIOS Settings**: Always verify VT-x/AMD-V is enabled before installation
- **Resource Over-allocation**: Don't assign more vCPUs/VMs than physical cores
- **Storage Performance**: Use SSD storage for better VM performance
- **Network Isolation**: Configure VLANs/branches for multi-tenant environments
- **Update Management**: Always backup VMs before major host OS updates

</details>
