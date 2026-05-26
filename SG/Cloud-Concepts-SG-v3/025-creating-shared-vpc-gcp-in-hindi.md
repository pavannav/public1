<details open>
<summary><b>025-Creating-Shared-VPC-GCP-in-Hindi (KK-CS45-script-v3)</b></summary>

# Session 025: Creating Shared VPC in GCP

## Table of Contents
- [Overview](#overview)
  - [What is Shared VPC?](#what-is-shared-vpc)
  - [Why Use Shared VPC?](#why-use-shared-vpc)
  - [Key Components](#key-components)
  - [Important Constraints](#important-constraints)
- [Deep Dive into Components](#deep-dive-into-components)
  - [Host Project](#host-project)
  - [Service Projects](#service-projects)
  - [Network Resources Shared](#network-resources-shared)
- [Permissions and Access Control](#permissions-and-access-control)
  - [Project-Level Permissions](#project-level-permissions)
  - [Subnet-Level Permissions](#subnet-level-permissions)
  - [Compute Network User Role](#compute-network-user-role)
- [Lab Demo Guide](#lab-demo-guide)
  - [Enabling Host Project](#enabling-host-project)
  - [Configuring Sharing Mode](#configuring-sharing-mode)
  - [Attaching Service Projects](#attaching-service-projects)
  - [Granting Permissions](#granting-permissions)
  - [Verifying Access](#verifying-access)
- [Summary](#summary)

## Overview

### What is Shared VPC?

**Shared VPC** (Virtual Private Cloud) is a Google Cloud networking architecture that allows multiple projects within an organization to share a common VPC network infrastructure. This enables centralized network management while maintaining project-level isolation for resources and access control.

The primary use case is when an organization wants multiple projects to utilize the same VPC network instead of each project creating and managing its own VPC. This reduces operational overhead and ensures consistent networking across environments (development, testing, production).

### Why Use Shared VPC?

Shared VPC addresses several key organizational networking requirements:

- **Centralized Network Management**: A dedicated networking team can manage all VPC resources (subnets, firewall rules, routes) from a single host project
- **Cost Optimization**: Eliminates redundancy of network resources across multiple projects
- **Security and Compliance**: Centralized control over network security policies and routing
- **Scalability**: Easily onboard new projects without recreating network infrastructure

### Key Components

A Shared VPC setup consists of two main project types:

1. **Host Project**: Contains the VPC network resources that are shared
2. **Service Projects**: Connect to the host project's VPC network to utilize shared resources

### Important Constraints

> [!IMPORTANT]
> 
> **Critical Shared VPC Rules:**
> - A service project can connect to **only one** host project at a time
> - A host project can connect to **multiple** service projects
> - A project **cannot** be both a host project and service project simultaneously

## Deep Dive into Components

### Host Project

The host project acts as the central hub for network infrastructure management:

- **Responsibilities**: 
  - Hosts the VPC network, subnets, firewall rules, and routes
  - Maintains the primary networking configuration
  - Ensures network resources are available for connected service projects

- **Configuration Process**:
  1. Enable the project as a host project via the Shared VPC settings
  2. Choose sharing mode: share all subnets or individual subnets
  3. Attach service projects to grant access

### Service Projects

Service projects consume the shared network resources:

- **Characteristics**:
  - Create compute instances that connect to host project subnets
  - Can use shared firewall rules, routes, and other network configurations
  - Maintain their own IAM permissions and project-level resources

- **Network Configuration**:
  - When creating VM instances, network options show "Networks shared with me"
  - Service projects can only utilize subnets to which they have been granted access
  - No ability to modify shared network resources

### Network Resources Shared

Shared VPC enables sharing of core networking components:

- **VPC Networks**: The actual virtual private cloud infrastructure
- **Subnets**: Regional IP address ranges used by compute instances
- **Firewall Rules**: Security policies controlling network traffic
- **Routes**: Custom routing tables for directing network traffic
- **VPN Gateways and Cloud Routers**: For hybrid connectivity scenarios

## Permissions and Access Control

### Project-Level Permissions

For sharing **all subnets** across all VPCs in a project:

```yaml
Required IAM Roles on Host Project:
- roles/compute.networkUser  # Minimum permission for network access
- roles/compute.networkViewer  # Read-only network access
- roles/compute.networkAdmin  # Full network management
- roles/editor  # Broad project editor access
- roles/owner  # Full project control
```

### Subnet-Level Permissions

For sharing **individual subnets**:

```yaml
Process:
1. Navigate to specific subnet in VPC network console
2. Add individual principals (users/service accounts)
3. Grant compute.networkUser role on the subnet

Advantages:
- Granular access control per subnet
- Selective sharing based on region or environment
```

### Compute Network User Role

The `compute.networkUser` role is the minimum permission required:

- **Grants Ability To**:
  - Create compute instances in shared subnets
  - Use VPC network resources (firewalls, routes)
  - Configure network interfaces in VMs

- **Does NOT Grant**:
  - Ability to modify shared network resources
  - Creation or deletion of subnets/firewall rules
  - Management of the VPC itself

## Lab Demo Guide

### Enabling Host Project

```bash
# In Google Cloud Console - VPC Network > Shared VPC
1. Navigate to VPC network section
2. Select "Shared VPC" from left sidebar
3. Click "Enable host project"
4. Save and continue to apply setting

Console Steps:
- Go to VPC network > Shared VPC
- Enable host project
- Save and continue
```

### Configuring Sharing Mode

**Two Sharing Modes Available:**

1. **Share All Subnets** (Project-Level)
   - Grants access to all current and future subnets
   - Requires project-level IAM permissions

2. **Share Individual Subnets** (Subnet-Level)
   - Granular control per subnet
   - Requires individual subnet permissions
   - Allows selective sharing (e.g., production only)

### Attaching Service Projects

```bash
# Attach service projects to host project
Console Steps:
1. In Shared VPC section, click "Add projects"
2. Enter project IDs (e.g., service-project-1, service-project-2)
3. Users in attached projects automatically get compute.networkUser role on selected subnets
```

### Granting Permissions

**For Individual Subnet Sharing:**

```bash
Console Steps:
1. Navigate to specific subnet (asia-south1-subnet)
2. Click "Add principal" in permissions section  
3. Enter user/service account email
4. Grant "Compute Network User" role
5. Save changes

Verification:
- Access shared subnets appears in service project VPC network console
- Users can create VMs in permitted subnets only
```

**For All Subnets Sharing:**

```bash
GCP IAM Commands:
1. gcloud projects add-iam-policy-binding HOST_PROJECT_ID \
   --member=user:USER@DOMAIN.COM \
   --role=roles/compute.networkUser

2. Refresh service project VPC network console
3. All subnets from host project should now be visible
```

### Verifying Access

**Compute Engine VM Creation Test:**

```bash
Console Verification Steps:
1. Go to Compute Engine > VM instances > Create instance
2. In networking section, click "Networks shared with me"
3. Verify permitted subnets are available for selection
4. Select subnet and complete VM creation

Cross-Region Test:
- Attempt VM creation in permitted region (asia-south1) ✓
- Attempt VM creation in non-permitted region (us-central1) ✗
```

## Summary

### Key Takeaways

```diff
+ Shared VPC centralizes network management across multiple GCP projects
+ Host projects contain and manage shared VPC resources
+ Service projects consume shared networks with limited permissions
+ Service projects can connect to only ONE host project at a time
+ Minimum required role is compute.networkUser on host project or subnet
+ Choose between all-subnet sharing (project-level) or individual subnet sharing (granular control)
+ Attachments and detachments require no active resources using shared networks
+ Network interfaces in VMs can utilize shared subnets
+ Firewall rules, routes, and other VPC resources are inherited by service projects
```

### Quick Reference

**Common Commands/IAM Roles:**
```
Host Project Enable: VPC Network > Shared VPC > Enable host project
Attach Project: Shared VPC > Add projects  
Grant Network Access: IAM > Add compute.networkUser role
Individual Subnet Share: Subnet > Permissions > Add principal
VM Network Selection: Compute Engine > Create > Networks shared with me
Detach Project: Shared VPC > Attached projects > Detach
Disable Shared VPC: Shared VPC > Disable (verify no active resources)
```

**Essential IAM Permissions:**
- `roles/compute.networkUser` - Minimum access to use shared networks
- `roles/compute.networkAdmin` - Full network management capability
- `roles/editor` or `roles/owner` - Project-level network access

### Expert Insight

**Real-world Application:**
In enterprise environments, Shared VPC excels in multi-tenant scenarios where each department (service project) needs consistent network connectivity without managing their own VPCs. Banking applications use this to ensure all production workloads connect through centrally-managed secure networks with consistent firewall policies, while development teams operate in their own service projects with different subnet allocations.

**Expert Path:**
- Master IAM policy management with organization-wide policies using Google Cloud Identity
- Integrate with Resource Manager for automated project provisioning
- Combine with VPC Service Controls for additional security boundaries
- Use Terraform or Deployment Manager for infrastructure-as-code Shared VPC setup
- Monitor network usage with VPC Flow Logs and Cloud Monitoring

**Common Pitfalls:**
- **Circular Dependencies**: Never attempt to make a project both host and service simultaneously
- **Permission Gaps**: Users without compute.networkUser role cannot see shared subnets in console
- **Active Resource Lock**: Cannot detach service projects if VMs/ILBs use shared networks
- **Subnet Scope**: Individual sharing doesn't affect project-level roles - users still need basic access
- **Cross-Project Traffic**: Ensure firewall rules allow traffic between service project instances
- **Region Limitations**: Shared subnets are region-specific, plan multi-region deployments carefully

</details>
