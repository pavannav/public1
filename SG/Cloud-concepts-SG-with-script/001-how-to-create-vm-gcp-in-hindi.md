# Session 1: Creating VM in GCP

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview

This session covers the process of creating a Virtual Machine (VM) in Google Cloud Platform (GCP). We'll explore machine type selection, memory optimization, disk configurations, service accounts, networking options, IP assignments, security settings, and maintenance behaviors. The content is presented in a step-by-step guide translated from Hindi transcript, focusing on practical configuration options for VM deployment.

## Key Concepts/Deep Dive

### Machine Type Selection
- **Memory Optimization**: Choose memory-optimized instances where emphasis is on maximum memory for specific workloads.
- **Micro Instances**: For small-scale applications, select e_series with f1-micro or specific micro series configurations.
- **Custom Sizing**: Available options include 8.5 GB configurations for optimized memory usage.

### Storage Configuration
- **Persistent Disk Options**:
  - Standard or SSD types for boot disks
  - Balanced options for performance
  - SSD provides faster storage than standard HDD
- **Snapshots**: Enable automatic snapshots for backups and scheduling.

### Account Management
- **Service Accounts**: Configure service accounts for different environments or applications.
- **API Access Restrictions**:
  - Editor permissions by default
  - Full access grants complete API permissions
  - Selective access allows choosing specific APIs
  - Compute Engine can be set to read-only permissions

### Networking Configuration
- **Firewall Rules**: Add network tags for connectivity, manage separately in advanced options.
- **Network Interface Cards**: Two types available for connection.
- **Multiple Networks**: Support for multiple network connections with auto-selected subnets.
- **Internal IPs**: 
  - Custom reservations possible
  - IP addresses persist even if VM is deleted for reuse
- **External IPs**:
  - Public IP required for internet access
  - Ephemeral by default, replaceable
  - Disable if no internet connectivity needed

### Security Options
- **Secure Boot**: Includes integrity monitoring and verified boot options for enhanced security.
- **Deletion Protection**: Prevents accidental VM deletion, must be manually disabled first.

### Advanced Options

#### Reservations
- Prereserve specific CPU and memory for future use.
- Useful for predictable workloads and availability.

#### Pricing Comparison

| Instance Type | Approximate Cost (Monthly) |
|---------------|----------------------------|
| Standard | $10 |
| Memory Optimized | Higher (varies) |

#### Spot Instances
- Cost-effective alternative running as preemptive VMs.
- Requires specific scripting to handle termination.
- Applications may experience downtime.

### Maintenance Behavior
- **Options during maintenance**:
  - Migrate VM to another host.
  - Terminate VM during maintenance shutdown.
- Termination suspends VM until manually restarted.

## Lab Demos

### Creating a VM in GCP

1. **Machine Selection**:
   - Configure memory optimization options.
   - Select e_series micro instance with 8.5 GB memory.

2. **Storage Setup**:
   - Choose SSD balanced persistent disk for boot.
   - Enable backup schedules and automatic encryption (GCP default).

3. **Service Account Configuration**:
   - Create new service account or select existing.
   - Set appropriate API access levels (full, selective, or read-only).

4. **Networking Options**:
   - Add network tags for firewall connectivity.
   - Configure external IP for internet access (or None if internal only).
   - Reserve static internal IP if needed to prevent deletion.

5. **Security Settings**:
   - Enable secure boot and integrity checks.
   - Configure deletion protection to prevent accidental removal.

6. **Advanced Settings**:
   - Set maintenance behavior (migrate or terminate).
   - Create reservations for CPU/memory if required.
   - Configure spot instances for cost savings.

7. **Create and Verification**:
   - Initiate VM creation process.
   - Wait for deployment completion.
   - Verify internal IP (for VPC access) and external IP (for internet).

## Summary

### Key Takeaways
```diff
+ GCP provides flexible VM configuration options for various workload requirements
+ Memory-optimized instances work best for RAM-intensive applications
+ SSD storage offers better performance than standard persistent disks
+ Service accounts enable secure API interactions with configurable permissions
+ Public IPs are essential for internet connectivity, while private IPs handle internal communication
+ Deletion protection prevents accidental VM removal
+ Spot instances reduce costs but may experience termination
- Avoid selecting external IPs if internet access is not required
- Without reservations, resource availability isn't guaranteed during peak demand
```

### Expert Insight

#### Real-world Application
In production environments, use memory-optimized instances for database workloads and SSD-balanced disks for web applications requiring fast I/O. Implement reservations during peak traffic periods to ensure resource availability, and configure automatic snapshots for data backup strategies.

#### Expert Path
Master GCP VM creation by practicing with different machine types and understanding billing implications of each configuration. Deepen knowledge through GCP documentation on sustained use discounts and committed use contracts to optimize long-term costs.

#### Common Pitfalls
- Forgetting to enable deletion protection on critical VMs can lead to accidental data loss.
- Not reserving static external IPs may cause service disruptions during IP changes.
- Ignoring maintenance behavior settings can result in unexpected downtime during Google infrastructure updates.
- Using spot instances without automated restart mechanisms can interrupt continuous services.
- Inadequate API access restrictions may expose sensitive resources to unauthorized users.

Transcript Notes:
- The original transcript contains many incomplete sentence fragments and colloquial Hindi expressions.
- No obvious spelling corrections were needed (e.g., no instances of "htp" for "http" or "cubect" for "kubectl").
- All technical terms and acronyms have been standardized and translated for clarity (e.g., "जीपीयू" interpreted as GPU, but context suggests general compute configuration).
