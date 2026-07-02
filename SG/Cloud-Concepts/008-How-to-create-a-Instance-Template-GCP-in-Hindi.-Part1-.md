# Session 008: How to Create Instance Templates in GCP - Part 1

<details open>
<summary><b>Session 008: How to Create Instance Templates in GCP - Part 1 (Claude Opus 4)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Lab Demo: Creating an Instance Template](#lab-demo-creating-an-instance-template)
- [Instance Template Configuration Options](#instance-template-configuration-options)
- [Creating VMs from Templates](#creating-vms-from-templates)
- [Important Limitations](#important-limitations)
- [Summary](#summary)

## Overview
This session covers creating and using Instance Templates in Google Compute Engine. Instance templates provide a convenient way to save VM configurations for consistent and repeatable VM deployments, particularly useful for managed instance groups.

## Key Concepts

### What are Instance Templates?
Instance templates are resource templates that define configuration settings for VM instances. They serve as a blueprint for creating multiple VMs with identical configurations, ensuring consistency across deployments.

### Key Benefits
- **Consistency**: Ensure all VMs have identical configurations
- **Repeatability**: Quickly create VMs with the same settings
- **Automation**: Essential foundation for managed instance groups
- **Time Savings**: Avoid repetitive configuration for multiple VMs

### Instance Template Characteristics
- **Immutable**: Once created, templates cannot be edited
- **Reusable**: Can be used multiple times to create VMs
- **Regional**: Templates are regional resources
- **Cost-Free**: No charges for creating/storing templates

## Lab Demo: Creating an Instance Template

### Step 1: Navigate to Instance Templates
```
GCP Console → Compute Engine → Instance templates → Create instance template
```

### Step 2: Configure Basic Settings
```
Name: first-template
Description: Template for web servers
Machine Configuration:
  - Machine type: e2-micro (or appropriate type)
  - Boot disk: Select appropriate image and size
```

### Step 3: Configure Identity and API Access
```
Service Account:
  - Default Compute Engine service account
  - Or select custom service account
Access scopes: Full access to all Cloud APIs (or specific scopes)
```

### Step 4: Configure Networking
```
Network Interface:
  - Network: Select VPC network
  - Subnet: Choose appropriate subnet
  - IP Stack Type: IPv4 only or dual-stack

External IP: Ephemeral or None
Network tags: Add tags for firewall rules (e.g., http-server, https-server)
```

### Step 5: Configure Disks
```
Boot Disk:
  - Image: Select OS image
  - Size: Configure disk size
  - Type: Standard Persistent Disk or SSD

Additional Disks:
  - Click "Add new disk" for secondary storage
  - Configure size, type, and mode (Read/Write or Read-only)
```

### Step 6: Security and Protection Options
```
Shielded VM:
  - Enable Secure Boot
  - Enable vTPM
  - Enable Integrity Monitoring

Deletion Protection:
  - Prevent accidental deletion

Preemptibility:
  - Make this a Spot/Preemptible VM (cost savings)
```

### Step 7: Create Template
```
Review all configurations
Click "Create"
Template is now available for VM creation
```

## Instance Template Configuration Options

### Machine Configuration
- **Machine Type**: Predefined or custom machine types
- **CPU Platform**: Minimum CPU generation requirements
- **GPUs**: Optional GPU accelerators for ML workloads

### Boot Disk Configuration
- **Image Selection**: Public images, custom images, or snapshots
- **Disk Size**: Minimum size based on image requirements
- **Disk Type**:
  - Standard Persistent Disk
  - SSD Persistent Disk
  - Balanced Persistent Disk

### Identity and Security
- **Service Account**: Determines API access permissions
- **Access Scopes**: Granular permissions for the service account
- **Shielded VM**: Enhanced security features
- **Confidential Computing**: Memory encryption for sensitive workloads

### Networking Options
- **Multiple Network Interfaces**: Up to 8 NICs depending on machine type
- **Network Tags**: Used for firewall rule targeting
- **Aliases IP Ranges**: Additional IP ranges for the VM

### Metadata and Startup Scripts
```yaml
Metadata:
  startup-script: |
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
  custom-metadata-key: value
```

## Creating VMs from Templates

### Method 1: Direct Creation from Template
```
GCP Console → Compute Engine → VM instances → Create instance
Select "New VM instance from machine image" → NOT
Alternative: Use "New VM instance from template"
```

### Method 2: From Template List
```
GCP Console → Compute Engine → Instance templates
- Select template
- Click "Create VM instance"
- Customize as needed (name, zone, etc.)
- Some fields become editable during VM creation
```

### What Can Be Customized During VM Creation
- **VM Name**: Always customizable
- **Zone**: Select deployment zone
- **Machine Type**: Can be changed
- **Disk Size**: Can be increased
- **Network Configuration**: Can be modified

### What Cannot Be Changed
- **Template Source**: Must create new template for changes
- **Core Configuration**: Machine type selection is fixed in template

## Important Limitations

### Immutability of Templates
```diff
- Once created, instance templates CANNOT be edited
- No direct edit option available in console or API
```

### Solutions for Template Modifications
1. **Create Similar Template**:
   - Select existing template
   - Click "Create similar"
   - Modify as needed
   - Creates a new template with changes

2. **Template Versioning Strategy**:
   - Use naming conventions (e.g., `web-server-v1`, `web-server-v2`)
   - Maintain multiple versions for rollback capability

### Cost Implications
- **No Direct Cost**: Templates themselves incur no charges
- **Storage**: Templates are lightweight and don't consume significant resources
- **VM Costs**: Only VMs created from templates incur charges

## Use Cases for Instance Templates

### Infrastructure as Code
- Consistent VM deployment across environments
- Integration with Deployment Manager or Terraform

### Managed Instance Groups
- Required foundation for creating managed instance groups
- Enables auto-scaling and auto-healing features

### Standardized Workloads
- Web servers with specific configurations
- Database servers with optimized settings
- Development/test environments

## Summary

### Key Takeaways
```diff
+ Instance templates provide reusable VM configurations
+ Essential foundation for managed instance groups
+ Include comprehensive configuration options (machine, disks, networking, security)
+ VMs created from templates can have certain customizations
+ Templates incur no direct costs
- Templates are immutable after creation
- Must create new template for any configuration changes
- Use "Create similar" to base new templates on existing ones
```

### Quick Reference
```bash
# Create instance template via gcloud
gcloud compute instance-templates create TEMPLATE_NAME \
    --machine-type=e2-micro \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --network=default

# Create VM from template
gcloud compute instances create VM_NAME \
    --source-instance-template=TEMPLATE_NAME \
    --zone=ZONE

# List instance templates
gcloud compute instance-templates list

# Delete instance template
gcloud compute instance-templates delete TEMPLATE_NAME
```

### Expert Insight

#### Real-world Application
- Standardize VM configurations across development, staging, and production
- Enable consistent security postures with Shielded VM settings
- Implement cost optimization with preemptible VM templates

#### Expert Path
- Master integration with managed instance groups
- Understand template usage in Infrastructure as Code practices
- Implement template versioning and lifecycle management
- Explore advanced features like nested virtualization and confidential computing

#### Common Pitfalls
- Attempting to edit existing templates instead of creating new ones
- Not using meaningful naming conventions for template versions
- Over-configuring templates with environment-specific settings
- Forgetting that some template settings can be overridden during VM creation

</details>