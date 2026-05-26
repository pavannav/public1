<details open>
<summary><b>[008-How-to-create-a-Instance-Template-GCP-in-Hindi-Part1] (KK-CS45-script-v3)</b></summary>

# Session 008: Creating Instance Templates in GCP (Part 1)

## Table of Contents
- [Overview](#overview)
- [Key Concepts: Instance Templates](#key-concepts-instance-templates)
- [Deep Dive: Template Configuration Options](#deep-dive-template-configuration-options)
- [Lab Demo: Creating an Instance Template](#lab-demo-creating-an-instance-template)
- [Lab Demo: Creating VMs from Templates](#lab-demo-creating-vms-from-templates)
- [Limitations and Best Practices](#limitations-and-best-practices)
- [What's Next (Part 2 Preview)](#whats-next-part-2-preview)
- [Summary](#summary)

## Overview
This session demonstrates how to create and manage Instance Templates in Google Cloud Platform (GCP). Instance Templates are foundational blueprints used to define the configuration for virtual machine instances. We'll navigate the GCP Console, configure template settings including machine types, disks, networking, and service accounts, and learn about template limitations and management.

## Key Concepts: Instance Templates

Instance Templates in GCP serve as reusable configuration blueprints for creating Virtual Machine (VM) instances. They define all the properties that a VM will have when created from that template, ensuring consistency and repeatability across your infrastructure.

### Core Purpose
- **Consistency**: Ensures all VMs created from a template have identical specifications
- **Scalability**: Foundation for Instance Groups and Auto Scaling
- **Automation**: Enables programmatic deployment of standardized environments
- **Cost Management**: Defines resource specifications to control costs

### Template Components
- **Machine Type**: CPU and memory specifications
- **Boot Disk**: Operating system and initial disk configuration
- **Service Accounts**: Identity and permissions for the VM
- **Networking**: VPC network, subnet, and firewall settings
- **Security**: Shielded VM options and security configurations
- **Additional Disks**: Persistent disks attached to the VM
- **Metadata**: Custom key-value pairs for configuration

## Deep Dive: Template Configuration Options

### Machine Configuration
The machine type determines the compute resources allocated to instances:
- **Standard machine types**: Balanced CPU and memory (e.g., n1-standard-1)
- **High-memory types**: More memory per CPU core
- **High-CPU types**: More CPU cores with less memory
- **Custom types**: Fine-tuned resource allocation

### Boot Disk Options
```yaml
# Boot Disk Configuration Example
boot_disk:
  type: pd-ssd  # or pd-standard
  size_gb: 10
  source_image: projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20230501
  auto_delete: true
```

### Service Accounts
Service accounts define the identity and permissions for VMs:
- **Default service accounts**: Automatic access to basic Google Cloud APIs
- **Custom service accounts**: Specific IAM roles and permissions
- **No service account**: Limited API access (not recommended)

### Network Interface Configuration
Network settings control connectivity and security:
- **VPC Network**: Virtual private cloud selection
- **Subnet**: Regional network segment
- **External IP**: Required for internet access
- **Network tags**: Firewall rule targeting
- **Security**: Shielded VM features and secure boot

## Lab Demo: Creating an Instance Template

Follow these steps to create an instance template in the GCP Console:

### Step 1: Navigate to Instance Templates
1. Open Google Cloud Console
2. Navigate to **Compute Engine** → **Instance Templates**
3. Click **+ CREATE INSTANCE TEMPLATE**

### Step 2: Basic Configuration
```
Name: my-first-template
Region: us-central1
```

### Step 3: Machine Configuration
1. **Machine type**: Select appropriate CPU/memory combination
2. **Boot disk**: Choose operating system and disk type
3. **Service account**: Configure permissions (default or custom)

### Step 4: Network Configuration
1. **Network**: Select VPC network
2. **Subnet**: Choose appropriate subnet
3. **External IP**: Configure as needed
4. **Network tags**: Add for firewall rules

### Step 5: Security and Additional Settings
1. **Shielded VM**: Enable secure boot options
2. **Additional disks**: Attach persistent disks if needed
3. **Metadata**: Add custom key-value pairs

### Step 6: Create Template
Click **CREATE** to finalize the instance template.

## Lab Demo: Creating VMs from Templates

### Method 1: Direct VM Creation from Template
1. Go to **Compute Engine** → **VM instances**
2. Click **+ CREATE INSTANCE**
3. Select **New VM instance from template**
4. Choose your created template
5. Customize name and review auto-populated settings
6. Click **CREATE**

### Method 2: Via Instance Templates Page
1. Navigate to **Compute Engine** → **Instance Templates**
2. Select your template
3. Click **NEW VM FROM THIS TEMPLATE**
4. Follow the creation wizard

## Limitations and Best Practices

> [!IMPORTANT]
> Instance Templates cannot be edited once created! You must delete them or create similar templates to make changes.

### Workarounds for Template Modifications
1. **Create Similar**: Use the "Create Similar" option to copy settings and modify
2. **Delete and Recreate**: Remove old template and create new one with changes
3. **Version Control**: Maintain multiple template versions for different environments

### Best Practices
- **Naming Conventions**: Use descriptive names (e.g., `web-server-template-v1`)
- **Documentation**: Store template configurations in version control
- **Testing**: Create test instances before deploying to production
- **Security**: Use least-privilege service accounts
- **Cost Optimization**: Choose appropriate machine types and disk sizes

```diff
+ Template Benefits: No cost for template storage, only charges for VMs
+ Best Practice: Test templates before large-scale deployment
- Major Limitation: Templates are immutable once created
- Avoid: Over-configuring templates - keep them focused
! Important: Template costs don't appear in billing until VMs are created
```

## What's Next (Part 2 Preview)
The next session will cover:
- Creating Instance Groups using templates
- Load balancing configuration
- Auto-scaling policies
- Rolling update strategies for instance groups

## Summary

### Key Takeaways
```diff
+ Instance Templates provide reusable VM configurations
+ Templates ensure consistency across deployments
+ Foundation for scalable Instance Groups and Auto Scaling
+ Cost-effective - no charges for template storage
- Templates cannot be edited once created
- Changes require creating similar or deleting/recreating
! Always test templates before production use
```

### Quick Reference

**Navigation Path:**
```
Compute Engine → Instance Templates → + CREATE INSTANCE TEMPLATE
```

**Key Commands:**
```bash
# Check existing templates (via gcloud CLI)
gcloud compute instance-templates list

# Create template via CLI
gcloud compute instance-templates create my-template \
  --machine-type=n1-standard-1 \
  --image-family=ubuntu-2004-lts \
  --image-project=ubuntu-os-cloud
```

**Template Properties:**
- **Region**: Global resource (can be used in any region)
- **Immutable**: Cannot edit after creation
- **Reusable**: Use for multiple VM deployments
- **Free**: No storage costs

### Expert Insight

#### Real-world Application
In production environments, instance templates are crucial for:
- **Auto-scaling groups**: Templates ensure consistent configuration across scaled instances
- **Blue-green deployments**: Create new template versions for canary deployments
- **Multi-region deployments**: Use templates to maintain identical configurations across regions
- **Cost optimization**: Right-size machine types and disks for workload requirements

#### Expert Path
- **Version your templates**: Use naming conventions like `app-v1.2.3-template`
- **Automate with Terraform**: Define templates as infrastructure as code
- **Monitor costs**: Track VM usage from templates separately
- **Security hardening**: Use custom service accounts with minimal permissions
- **Multi-stage environments**: Create different template variants for dev/staging/prod

#### Common Pitfalls
- **Forgetting immutability**: Attempting to edit existing templates directly
- **Over-engineering disks**: Attaching unnecessary additional disks increases costs
- **Weak service accounts**: Using overly permissive default service accounts
- **Region mismatch**: Creating templates in wrong region for target deployment
- **Cost surprises**: Not realizing template-based VMs incur full compute charges

**Template Management Checklist:**
1. ✓ Define clear naming conventions
2. ✓ Test templates with single VM creation
3. ✓ Configure appropriate machine types and storage
4. ✓ Set up proper security (service accounts, networks)
5. ✓ Document template purposes and configurations
6. ✓ Plan for updates (Create Similar strategy)
7. ✓ Monitor costs and resource usage
</details>
