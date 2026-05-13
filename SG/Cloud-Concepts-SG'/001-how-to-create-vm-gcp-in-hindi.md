# Session 1: How to Create VM in GCP

<details open>
<summary><b>Session 1: How to Create VM in GCP (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [VM Types and Series](#vm-types-and-series)
- [Storage Options](#storage-options)
- [Security and Access](#security-and-access)
- [Networking Configuration](#networking-configuration)
- [IP Address Management](#ip-address-management)
- [Reservation Options](#reservation-options)
- [Pricing Models](#pricing-models)
- [Maintenance Behavior](#maintenance-behavior)
- [Metadata and Custom Options](#metadata-and-custom-options)
- [Lab Demo: Creating VM](#lab-demo-creating-vm)
- [Summary](#summary)

## Overview
This session covers the comprehensive process of creating Virtual Machines (VMs) in Google Cloud Platform (GCP). We'll explore machine types, storage options, security configurations, networking settings, IP management, and advanced features like reservations and pricing models.

## VM Types and Series
### Machine Types Categories
- **Micro Series**: Optimized for lightweight workloads
  - `e2-micro` with 8.5 GB memory for memory-optimized small instances
- **Optimization Focus**:
  - `e2-medium`: Balanced performance
  - Memory-optimized: Maximum focus on RAM capacity
  - CPU-optimized: Enhanced CPU performance
  - Storage-optimized: SSD/HD focused configurations

### Configuration Considerations
Select machine types based on workload requirements:
- Small workloads → `e2-micro`
- Balanced needs → Standard series
- Memory intensive → Memory-optimized
- CPU intensive → CPU-optimized

## Storage Options
### Boot Disk Types
- **Persistent Disk (PD)**: Primary boot disk
- **Balanced SSD**: Enhanced performance
- **SSD**: Extreme performance
- **Standard HDD**: Cost-effective option

### Disk Management
- **Encryption**: GCP automatically encrypts data at rest
- **Snapshots**: Enable scheduled backups
- Add additional disks if needed for testing or persistent storage
- Deletion protection available

## Security and Access
### Service Accounts
- **Compute Engine Default Service Account**:
  - Editor access by default
  - Grants full API access if enabled
- **Custom Service Accounts**:
  - Create new accounts for specific service access
  - Control access levels (read-only, full, selective APIs)

### Security Features
- **Secure Boot**: Enabled during testing
- **Integrity Monitoring**: Verify boot process
- **Virtual Trusted Platform Module (vTPM)**: Additional security layer

## Networking Configuration
### VPC Networks
- **Default Network**: Automatic selection if single VPC
- **Custom Networks**: Develop multi-VPC architectures
- **Network Tags**: Associate with firewall rules
- **Subnets**: Regional deployment control

### Network Interface Cards (NICs)
- **Single NIC**: Basic connectivity
- **Multiple NICs**: Multi-network configurations
- Auto-connected to default subnet initially

## IP Address Management
### Internal IP
- **Ephemeral**: Automatic assignment (recommended)
- **Static/Internal Reserved**: Persistent IP management
  - Reserve IP addresses that persist after VM deletion
  - Prevent IP conflicts in network

### External IP (Public IP)
- **Required for Internet Access**: Analogous to home router's public IP
- **Ephemeral**: Temporary, changes on restart
- **Static**: Permanent public IP addresses
- **None**: For private networks only

## Reservation Options
### Dedicated Resources
- **CPU/Reservations**: Guarantee specific compute resources
- **Memory Reservations**: Ensure RAM availability
- **Use Cases**: Critical workloads requiring consistent resources
  - Holiday traffic surges
  - Peak business hours
  - Mission-critical applications

## Pricing Models
### Instance Types
- **On-Demand**: Standard pricing (~$10 for e2-medium)
- **Spot Instances**: Cost-effective preemptible VMs
  - Significant discounts (70-90%)
  - Applications must handle interruptions
- **Committed Use**: Long-term commitments with discounts

### GPU Integration
- **vCPU and RAM Requirements**: Additional script execution
- **Data Persistence**: Manage spot instance interruptions

## Maintenance Behavior
### Host Maintenance Events
- **VM Migration**: Default behavior
  - GCP migrates running VMs during host maintenance
  - Minimal downtime (<1 minute)
- **Termination Option**: Stop VMs during maintenance
  - Longer downtime but preserves data integrity

### Migration Strategy
- **Automatic Migration**: Live migration without shutdown
- **Manual Stop/Start**: Control maintenance timing
- **Scheduled Maintenance**: Plan around business hours

## Metadata and Custom Options
### Instance Metadata
- **Custom Metadata**: User-defined key-value pairs
- **Startup Scripts**: Automated deployment tasks
- **Shutdown Scripts**: Cleanup operations

### Command Line Integration
- **gcloud Commands**: CLI management capabilities
- **API Access**: Programmatic VM control

## Lab Demo: Creating VM

### Step-by-Step VM Creation Process

1. **Access GCP Console**
   - Navigate to Compute Engine → VM instances
   - Click "Create Instance"

2. **Machine Configuration**
   - Name: Choose descriptive instance name
   - Region/Zone: Select geographically appropriate location
   - Machine Type: Select based on workload:
     ```bash
     # Example micro instance
     e2-micro (2 vCPUs, 1 GB RAM)
     ```

3. **Storage Setup**
   - Boot disk: Choose disk type and size
     ```bash
     # Balanced SSD example
     Size: Minimum 10GB
     Type: Balanced (recommended)
     ```
   - Enable snapshots for backup if needed

4. **Identity and API Access**
   - Service Account: Choose appropriate permissions
     ```bash
     # Default selection
     Compute Engine default service account (Editor)
     ```
   - API access: Enable required APIs

5. **Networking Configuration**
   ```bash
   # Default network settings
   Network: default
   Subnet: Auto-selected
   ```

6. **IP Address Assignment**
   ```yaml
   # Internal IP
   Type: Ephemeral (Automatic)

   # External IP
   Type: Ephemeral (Automatic)  # or Static if required
   ```

7. **Security Options**
   - Enable secure boot for enhanced security
   - Configure as needed for testing environments

8. **Advanced Options**
   - Enable deletion protection for production VMs
   - Configure maintenance behavior:
     ```bash
     # Migration options
     Migrate VM instance
     Terminate instance (for spot instances)
     ```

9. **Cost Management**
   - Review pricing estimates
   - Consider reserved instances for cost optimization

10. **Launch and Verification**
    ```bash
    # Monitor creation status
    Status: Creating... (approximately 30 seconds)

    # Verify IP addresses
    Internal IP: 10.x.x.x (VPC native range)
    External IP: [Public IP if assigned]
    ```

## Summary

### Key Takeaways
```diff
+ Choose machine types based on workload requirements: memory, CPU, or storage optimization
+ Always assign external IPs for internet-connectivity needs
+ Enable deletion protection for production VMs to prevent accidental termination
+ Use service accounts correctly to control API access levels
+ Reserve static IPs for persistent addressing requirements
+ Consider spot instances for cost-effective, interrupt-tolerant workloads
+ Configure maintenance behavior appropriately for availability needs
! Always review security settings and enable features like secure boot
! Monitor costs and use appropriate pricing models for budget control
```

### Quick Reference

**Common Machine Types:**
```bash
# Micro instances
e2-micro     - 2 vCPUs, 1GB RAM
e2-small     - 2 vCPUs, 2GB RAM
e2-medium    - 2 vCPUs, 4GB RAM

# Balanced instances
n1-standard-1 - 1 vCPU, 3.75GB RAM
n1-standard-2 - 2 vCPUs, 7.5GB RAM
```

**gcloud VM Creation Command:**
```bash
gcloud compute instances create [INSTANCE_NAME] \
    --machine-type=[MACHINE_TYPE] \
    --zone=[ZONE] \
    --network=[NETWORK] \
    --subnet=[SUBNET]
```

### Expert Insight

#### Real-world Application
- **Production Environments**: Use deletion protection and static IP reservations
- **Testing/Development**: Leverage spot instances and automatic IP assignments
- **Cost Optimization**: Reserve commit capacity for 1-3 year terms
- **Multi-region Deployments**: Consider network tagging for global scaling

#### Expert Path
1. Master gcloud CLI for automation and scripting
2. Understand GCP networking deeply (VPC, subnets, firewall rules)
3. Implement infrastructure-as-code using Terraform/CloudFormation
4. Design auto-scaling groups and load balancers
5. Optimize costs through reserved instances and commitments

#### Common Pitfalls
- **Forgetting external IPs**: VMs become inaccessible without internet connectivity
- **Incorrect service accounts**: Too few permissions cause deployment failures
- **No deletion protection**: Accidental terminations in production
- **Neglecting snapshots**: Data loss from unbacked critical instances
- **Spot instance dependencies**: Critical applications interrupted unpredictably
- **Region/zone selection**: Poor geographic choices increase latency/costs

</details>