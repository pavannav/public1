# Session 008: How to create an Instance Template in GCP (Part 1)

<details open>
<summary><b>How to create an Instance Template in GCP - Part 1 (KK-CS45-script-v2)</b></summary>

## Table of Contents
* [Overview](#overview)
* [Key Concepts: Instance Templates](#key-concepts-instance-templates)
* [Lab Demo: Creating an Instance Template](#lab-demo-creating-an-instance-template)
* [Using Templates to Create Instances](#using-templates-to-create-instances)
* [Summary](#summary)

## Overview
This session covers the fundamental concepts and practical steps for creating Instance Templates in Google Cloud Platform (GCP) Compute Engine. Instance Templates serve as blueprints for creating consistent VM configurations across multiple instances, making them essential for scalable deployments and managed instance groups.

### Learning Objectives
- Understand the purpose and benefits of Instance Templates in GCP
- Learn the step-by-step process of creating instance templates
- Explore configuration options available during template creation
- Understand template management limitations and best practices
- Discover how to use templates for creating virtual machine instances

## Key Concepts: Instance Templates

### What are Instance Templates?
Instance Templates in GCP are **immutable configuration blueprints** that define the properties of virtual machine instances. They contain specifications for:

- Machine type and CPU/memory allocation
- Boot disk image and configuration
- Service accounts and IAM roles
- Network interfaces and firewall rules
- Additional storage disks
- Security settings and metadata

### Benefits of Instance Templates
- **Consistency**: Ensure all instances have identical configurations
- **Scalability**: Enable rapid deployment of multiple identical VMs
- **Automation**: Foundation for Managed Instance Groups and auto-scaling
- **Versioning**: Track configuration changes through different template versions
- **Cost-effective**: No additional charges for template creation

### Template Configuration Options

#### Machine Configuration
- **Machine Type**: Defines CPU cores and memory (e.g., n1-standard, n2-highmem)
- **Boot Disk**: Operating system image and size
  - Image family (e.g., ubuntu-2004-lts, centos-7)
  - Disk size and type (Standard, SSD)

#### Identity and Access
- **Service Account**: IAM identity for the instance
  - Default Compute Engine service account
  - Custom service accounts for specific permissions

#### Networking Configuration
- **Network**: VPC network for instance placement
- **Subnet**: Specific subnet within the VPC
- **Network Tags**: Labels for firewall rule application
- **External IP**: Configuration for public IP assignment

#### Storage and Security
- **Additional Disks**: Attach persistent or local SSD storage
- **Security Settings**: Shielded VM options, secure boot, vTPM
- **Metadata**: Custom key-value pairs for instance configuration

### Important Limitations
> [!IMPORTANT]
> Instance Templates are **immutable** once created. Key restrictions include:
>
> - Templates cannot be edited after creation
> - No modification of existing template configurations
> - Only deletion or "Create Similar" options available
> - Changes require new template creation

## Lab Demo: Creating an Instance Template

### Prerequisites
- Active GCP project with Compute Engine API enabled
- IAM permissions for creating instance templates
- Basic familiarity with GCP Console navigation

### Step-by-Step Guide

1. **Navigate to Instance Templates**
   - Open Google Cloud Console
   - Go to Compute Engine → VM instances
   - Select "Instance templates" from the left navigation panel

2. **Initiate Template Creation**
   - Click "Create Instance Template" button
   - Provide a descriptive name (e.g., `web-server-template`)

3. **Configure Machine Settings**
   ```
   Machine configuration:
   - Series: N1 (General-purpose)
   - Machine type: n1-standard-1 (1 vCPU, 3.75 GB RAM)
   - Boot disk: Ubuntu 20.04 LTS, 10 GB Standard persistent disk
   ```

4. **Set Service Account**
   - Choose appropriate service account with required permissions
   - Configure access scopes if using default service account

5. **Configure Networking**
   ```
   Network interfaces:
   - Network: default
   - Subnetwork: default (region-based)
   - External IP: Ephemeral
   - Network tags: (optional - e.g., "web-server")
   ```

6. **Add Additional Disks (Optional)**
   - Click "Add disk" to attach persistent storage
   - Specify disk name, type, and size

7. **Configure Security and Management**
   - Enable shielded VM features if required
   - Set metadata key-value pairs for automation scripts

8. **Create the Template**
   - Review configuration summary
   - Click "Create" to finalize the template

### Verification Steps
- Return to Instance Templates list
- Confirm new template appears with correct configuration
- Note: No actual VM instances are created (no charges incurred)

## Using Templates to Create Instances

### Method 1: Direct VM Creation from Template

1. **From VM Instances Page**
   - Go to Compute Engine → VM instances
   - Click "Create Instance"
   - Select "New VM from template"
   - Choose your created template

2. **Configuration Options**
   - Template settings are pre-populated
   - Can make runtime modifications:
     - Instance name
     - Zone selection
     - Additional labels

3. **Create the Instance**
   - Review final configuration
   - Click "Create"

### Method 2: Via Instance Groups
- Templates are commonly used with Managed Instance Groups (covered in next session)
- Enables autoscaling and load balancing capabilities

## Summary

### Key Takeaways
```diff
+ Instance Templates are immutable configuration blueprints for consistent VM deployment
+ Templates include machine type, disks, networking, and security settings
+ No charges for template creation since no actual resources are provisioned
+ Templates cannot be edited - use "Create Similar" for modifications
+ Foundation for scalable deployments through Managed Instance Groups
+ Essential for infrastructure as code and automated deployments
- Avoid making templates too specific to prevent reusability issues
- Remember to delete unused templates to maintain clean resource inventory
! Templates do not include runtime configurations like instance names or zones
```

### Quick Reference

#### Creating Instance Templates
```bash
# GCP Console steps:
1. Compute Engine → Instance templates → Create Instance Template
2. Configure: Name, Machine type, Boot disk, Service account
3. Set Networking: VPC network, subnet, external IP
4. Add: Additional disks, metadata, security settings
5. Create → Template ready for use
```

#### Template Management Commands
```bash
# List templates
gcloud compute instance-templates list

# Describe template
gcloud compute instance-templates describe TEMPLATE_NAME

# Create VM from template
gcloud compute instances create INSTANCE_NAME \
  --source-instance-template TEMPLATE_NAME
```

### Expert Insight

#### Real-world Application
- **Web Application Deployment**: Use templates for consistent web server configurations across multiple zones
- **Data Processing Clusters**: Pre-configure Hadoop/Spark nodes with identical storage and network settings
- **CI/CD Pipelines**: Templates ensure development, staging, and production environments use identical base configurations
- **Multi-region Deployment**: Maintain regional templates for latency optimization and compliance requirements

#### Expert Path
- **Versioned Templates**: Maintain multiple template versions (v1, v2, v3) for blue-green deployments
- **Infrastructure as Code**: Export templates to Terraform/YAML for version control and automation
- **Template Composition**: Use startup scripts and metadata to customize instance behavior without template modifications
- **Cost Optimization**: Create templates with minimal resource allocation, scale up in instance groups as needed

#### Common Pitfalls
> [!WARNING]
> - **Over-customization**: Avoid making templates too specific, reducing reusability
> - **Security Oversights**: Ensure service accounts have least-privilege access
> - **Network Isolation**: Proper VPC and subnet selection prevents security and connectivity issues
> - **Disk Management**: Boot disks are fixed per template; use additional disks for variable storage needs
> **Resource Waste**: Delete unused templates as they clutter the console and create management overhead

---

**Session Duration**: ~5 minutes (Part 1 of series)
**Next Session**: Managed Instance Groups and Auto-scaling with Templates

</details>