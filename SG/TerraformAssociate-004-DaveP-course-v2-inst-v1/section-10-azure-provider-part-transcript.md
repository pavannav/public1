# Section 10: Multi-Cloud Providers and Advanced Terraform Features

<details open>
<summary><b>Section 10: Multi-Cloud Providers and Advanced Terraform Features (KK-CS45-script-v2-Inst-v1)</b></summary>

## Table of Contents
- [10.1-10.3 Azure Provider Labs](#101-103-azure-provider-labs)
- [10.4-10.5 Google Cloud Provider Labs](#104-105-google-cloud-provider-labs)
- [10.6 VMware vSphere Provider](#106-vmware-vsphere-provider)
- [10.7 Docker Provider](#107-docker-provider)
- [10.8 More Providers: Kubernetes and libvirt](#108-more-providers-kubernetes-and-libvirt)
- [10.9 Using Aliases in AWS](#109-using-aliases-in-aws)
- [10.10 Working with the Lock File and Terraform Providers Command](#1010-working-with-the-lock-file-and-terraform-providers-command)
- [10.11 Working with Shared Credentials and Multiple Profiles in AWS](#1011-working-with-shared-credentials-and-multiple-profiles-in-aws)
- [10.12 S3 Remote Backend](#1012-s3-remote-backend)
- [10.13 Quiz](#1013-quiz)
- [Summary Section](#summary-section)

---

## 10.1-10.3 Azure Provider Labs

### Overview
These lessons guide you through creating Azure infrastructure using Terraform, covering Azure account setup, CLI installation, authentication, and building a complete virtual machine with networking components.

### Key Concepts

#### Azure Account and CLI Setup
- **Prerequisites**:
  - Create Azure account at portal.azure.com
  - Install Azure CLI for your platform (Windows, macOS, Linux)
  - Verify installation with `az --version`
- **Authentication**: Use `az login` which opens browser for authentication
- **MFA Requirement**: Azure requires MFA for logins; either use tenant ID or set up MFA

#### Azure RM Provider Configuration
```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "=4.57.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "your-subscription-id"
}
```

⚠️ **Important**: For Azure RM provider version 4+, subscription_id must be specified in the provider block.

### Azure Resource Hierarchy
Resources must be created in proper order:
1. `azurerm_resource_group` - Container for all Azure resources
2. `azurerm_virtual_network` - Network infrastructure
3. `azurerm_subnet` - Subnet within VNet
4. `azurerm_public_ip` - Public IP for VM access
5. `azurerm_network_security_group` - Security rules (SSH on port 22)
6. `azurerm_network_interface` - NIC connecting VM to network
7. `azurerm_network_interface_security_group_association` - Associates NIC with security group
8. `azurerm_linux_virtual_machine` - The actual VM

### Key Resource Implementations

#### SSH Key Configuration
```hcl
admin_ssh_key {
  username   = "adminuser"
  public_key = file("keys/azurekey.pub")
}
```

#### VM Image Reference (Provider v4+)
```hcl
source_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server"
  sku       = "24_04-lts-gen2"
  version   = "latest"
}
```

### Azure vs AWS Terminology
| Azure Resource | AWS Equivalent |
|----------------|----------------|
| Virtual Machine | EC2 Instance |
| Resource Group | Logical grouping (no direct equivalent) |
| Network Security Group | Security Group |
| Virtual Network | VPC |

### Outputs
```hcl
output "public_ip_address" {
  value = azurerm_linux_virtual_machine.azurevm1.public_ip_address
}

output "resource_group_name" {
  value = azurerm_linux_virtual_machine.azurevm1.resource_group_name
}
```

### Labs Summary
- **Part 1**: Created SSH keys, Azure account, installed Azure CLI, authenticated
- **Part 2**: Analyzed and configured Azure infrastructure code with subscription ID
- **Part 3**: Built infrastructure (8 resources), SSH'd into Ubuntu VM, destroyed resources

---

## 10.4-10.5 Google Cloud Provider Labs

### Overview
These lessons demonstrate building a Google Compute Engine instance using Terraform, covering Google Cloud setup, GCloud CLI installation, and troubleshooting common authentication issues.

### Key Concepts

#### Google Cloud Prerequisites
1. Create Google account
2. Create new project at console.cloud.google.com
3. Set up permissions (compute.instance, compute.firewalls)
4. Enable Google Compute Engine API
5. Set up billing account and credit card

#### Google Cloud CLI Setup
```bash
# Install GCloud CLI (Debian/Ubuntu)
gcloud init
gcloud auth application-default login  # Required for Terraform
```

⚠️ **Critical**: Must run `gcloud auth application-default login` and select all permissions for Terraform to work.

### Google Provider Configuration
```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>7.16.0"
    }
  }
}

provider "google" {
  project = "your-project-id"
  region  = "us-east1"
}
```

### Google Cloud Naming Conventions

#### Resource Types
- VPC: `google_compute_network`
- Subnet: `google_compute_subnetwork`
- Instance: `google_compute_instance`
- Firewall: `google_compute_firewall`

#### Network Interface Access for Outputs
```hcl
output "public_ip" {
  value = google_compute_instance.google_vm_1.network_interface[0].access_config[0].nat_ip
}
```

### Important Google Cloud Concepts
- **Zones**: More granular than AWS regions (us-east1-c, us-east1-b)
- **ephemeral IPs**: Default public IP behavior (short-lived, dynamic)
- **Data Sources**: Use `data.google_compute_image` for latest images

### Troubleshooting Guide

| Issue | Solution |
|-------|----------|
| Application default credentials error | Run `gcloud auth application-default login` |
| Zone capacity issues | Change to different zone (a, b, c, d, e, f) |
| API not enabled | Enable Compute Engine API in project |

### Labs Summary
- **Part 1**: Set up Google Cloud project, installed GCloud CLI, authenticated, reviewed infrastructure code
- **Part 2**: Applied Terraform (4 resources), troubleshooted zone issues, SSH'd into Debian VM, cleaned up credentials

---

## 10.6 VMware vSphere Provider

### Overview
This lesson explains the VMware vSphere provider for managing virtual machines in VMware ESXi environments, which can be either on-premises or in the cloud.

### Key Concepts

#### vSphere Architecture
```
vCenter (Management)
    ↓
ESXi Servers (Virtualization Hosts)
    ↓
Virtual Machines
```

#### Provider Configuration (v2+)
```hcl
terraform {
  required_providers {
    vsphere = {
      source  = "VMware/vsphere"
      version = "2.15.0"
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}
```

### Required Data Sources
Must configure before creating VMs:
1. `vsphere_datacenter`
2. `vsphere_datastore`
3. `vsphere_compute_cluster`
4. `vsphere_network`

```hcl
data "vsphere_datacenter" "datacenter" {
  name = "DC01"
}

data "vsphere_datastore" "datastore" {
  name          = "Datastore01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
```

### VM Resource Configuration
```hcl
resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-vm"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 4096
  guest_id = "debian12_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 20
  }
}
```

### vSphere Variables Best Practices
- Use `variables.tf` for variable declarations
- Store sensitive values in `terraform.tfvars` (added to .gitignore)
- Or use environment variables for credentials

### Important Notes
- ❌ No working lab provided (too many components required)
- ✅ ESXi server is free
- ✅ vCenter requires license (evaluation available)
- Minimal requirements: 1 ESXi server + vCenter access

---

## 10.7 Docker Provider

### Overview
This lesson demonstrates using Terraform to manage Docker containers, specifically running an NGINX web server as a container.

### Key Concepts

#### Provider Setup
```hcl
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}
```

⚠️ **Windows Note**: May need additional configuration in provider block for Windows systems.

### Docker Resources
```hcl
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "nginx-server"

  ports {
    internal = 80
    external = 8000
  }
}
```

### Lab Workflow
1. Install Docker for your OS
2. Add user to docker group: `sudo usermod -aG docker $USER`
3. Reboot system
4. Initialize and apply Terraform

### Key Insights
- Docker images download very quickly (~3 seconds for NGINX)
- Container depends on image (destroy order: container → image)
- Access container at `http://127.0.0.1:8000`

### Alternative: Podman
- Podman recommended as Docker alternative on Linux
- Native NFTables (iptables replacement) support
- Command compatible with Docker

### Labs Summary
- Installed Docker, created NGINX container via Terraform
- Verified web server accessibility
- Destroyed container and image

---

## 10.8 More Providers: Kubernetes and libvirt

### Overview
This lesson covers two additional providers: Kubernetes for managing EKS clusters and libvirt for KVM virtualization management.

### Kubernetes Provider (EKS)

#### Provider Configuration
```hcl
terraform {
  required_providers {
    aws        = { source = "hashicorp/aws" }
    kubernetes = { source = "hashicorp/kubernetes" }
  }
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name]
  }
}
```

#### Deployment Resource
```hcl
resource "kubernetes_deployment_v1" "nginx" {
  metadata {
    name = "scalable-nginx"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"
          port {
            container_port = 80
          }
          resources {
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
        }
      }
    }
  }
}
```

⚠️ **Note**: Requires existing EKS cluster (see additional labs for creation)

### libvirt Provider (KVM)

#### Provider Setup
```hcl
terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.0"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"  # Local KVM
  # uri = "qemu+ssh://user@host/system"  # Remote KVM
}
```

#### Virtual Machine Resources
```hcl
resource "libvirt_volume" "debian13" {
  name   = "debian13-server.qcow2"
  pool   = "default"
  source = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-13-generic-amd64.qcow2"
  format = "qcow2"
}

resource "libvirt_domain" "debian13" {
  name   = "debian13-server"
  memory = "2048"
  vcpu   = 2

  disk {
    volume_id = libvirt_volume.debian13.id
  }

  network_interface {
    network_name = "default"
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
  }
}
```

### Provisioners Note
- `remote-exec` provisioner shown but deprecated
- Recommended alternatives:
  - Cloud-init for initialization
  - Ansible for configuration management

### Lab Context
- libvirt used for creating ~7 VM images simultaneously
- Combines with Cloud-init and Ansible
- Final lab will demonstrate similar patterns on AWS

---

## 10.9 Using Aliases in AWS

### Overview
This lesson explains how to use provider aliases to manage resources across multiple AWS regions within a single Terraform configuration.

### Key Concepts

#### The Alias Problem
```hcl
provider "aws" {
  region = "us-east-2"  # Ohio
}

provider "aws" {
  alias  = "oregon"
  region = "us-west-2"  # Oregon
}
```

Without aliases, Terraform defaults to the first provider configuration. Aliases enable multi-region deployments.

#### Meta Arguments
- Provider usage with alias is a **meta argument**
- Essential for multiple regions, accounts, or provider configurations

### Resource Configuration with Aliases
```hcl
resource "aws_instance" "test_instance" {
  ami           = "ami-ohio-debian13"
  instance_type = "t2.micro"
  # Defaults to us-east-2 (no provider specified)
}

resource "aws_instance" "oregon_instance" {
  provider      = aws.oregon
  ami           = "ami-oregon-debian13"
  instance_type = "t2.micro"
}
```

### Important Rules
1. Default region always gets the first provider
2. Must specify provider for secondary regions
3. Use format: `provider = aws.alias_name`

### Data Sources for AMIs
Instead of hardcoding AMIs per region:
```hcl
data "aws_ami" "debian_ohio" {
  most_recent = true
  owners      = ["136693071363"]  # Official Debian AWS account

  filter {
    name   = "name"
    values = ["debian-13-amd64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```

✅ **Best Practice**: Use data sources with owner IDs to get latest AMIs across regions without hardcoding.

### Labs Summary
- Created instances in Ohio (us-east-2) and Oregon (us-west-2) using aliases
- Demonstrated need for different AMIs per region
- Showed data source solution for dynamic AMI selection
- Destroyed multi-region infrastructure

---

## 10.10 Working with the Lock File and Terraform Providers Command

### Overview
This lesson covers the Terraform lock file for standardizing provider versions and the providers commands for managing provider installations across platforms.

### Key Concepts

#### Terraform Lock File (.terraform.lock.hcl)
- Automatically created by `terraform init`
- Locks provider versions based on constraints
- Contains cryptographic hashes for integrity

```hcl
provider "registry.terraform.io/hashicorp/aws" {
  version = "6.28.0"
  hashes = [
    "h1:abc123...",  # Linux AMD64
    "h1:def456...",  # Linux ARM64
    "zh:xyz789..."   # Zip hash (legacy)
  ]
}
```

### Hash Types

| Hash Type | Purpose | Format |
|-----------|---------|--------|
| h1 | Hash scheme 1 - SHA256 of package contents | Current standard |
| zh | Zip hash - SHA256 of zip file | Legacy format |

#### Hash Differences
- **h1**: Works with unpacked directories, recompressed packages, multiple installation methods
- **zh**: Hashes the actual zip file, used when downloading from registry

### Terraform Providers Commands

#### Display Current Providers
```bash
terraform providers
```
Shows providers required by configuration and versions.

#### Lock Additional Platforms
```bash
terraform providers lock \
  -platform=linux_arm64 \
  -platform=linux_amd64 \
  -platform=darwin_amd64 \
  -platform=windows_amd64
```

This enables:
- Team collaboration across different OSes
- Alternate installation methods (mirrors)
- Local provider caching

### Security Purpose
- **Trust on First Use**: Detects provider tampering
- **Supply Chain Protection**: Validates identical versions across environments
- **Checksum Validation**: Prevents unexpected provider changes

### Platform Architecture Examples
- `linux_amd64`: Linux on x86_64
- `linux_arm64`: Linux on ARM (Apple Silicon, ARM servers)
- `darwin_amd64`: macOS on Intel
- `windows_amd64`: Windows on x86_64

### Labs Summary
- Explained lock file structure and hashes
- Added multiple platform providers using lock command
- Discussed security implications of cryptographic hashing
- Demonstrated team collaboration benefits

---

## 10.11 Working with Shared Credentials and Multiple Profiles in AWS

### Overview
This mini-lab demonstrates using AWS shared credentials files with multiple profiles to enable team collaboration and environment separation.

### Key Concepts

#### Provider Configuration with Profiles
```hcl
provider "aws" {
  region                   = "us-east-2"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "prod"
}
```

#### Credentials File Structure
```ini
[default]
aws_access_key_id = AKIA...
aws_secret_access_key = ...

[prod]
aws_access_key_id = AKIA...
aws_secret_access_key = ...

[dev]
aws_access_key_id = AKIA...
aws_secret_access_key = ...
```

### Use Cases
1. **Team Collaboration**: Multiple users sharing credentials file
2. **Environment Separation**:
   - Production profile with limited permissions
   - Development profile with broader access
   - Testing profile for CI/CD

### Profile Selection
- Specified in provider block
- Different Terraform files can use different profiles
- Only the specified profile's credentials are used

### Best Practices
- ✅ Always backup credentials before modifications
- ✅ Add credentials files to .gitignore
- ✅ Use least privilege access per profile
- ✅ Separate profiles for different environments

### Labs Summary
- Created multiple profiles in credentials file
- Built IAM user using prod profile
- Verified profile isolation (wrong keys ignored)
- Restored original credentials

---

## 10.12 S3 Remote Backend

### Overview
This mini-lab shows how to configure Terraform to store state files remotely in an AWS S3 bucket instead of locally.

### Key Concepts

#### Remote Backend Configuration
```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "dave-bucket-123"
    key    = "dir1/key"
    region = "us-east-2"
  }
}
```

#### Backend vs Local Storage
| Storage Type | Location | Default |
|--------------|----------|---------|
| Local | Working directory | ✅ Yes |
| Remote | S3, GCS, Terraform Cloud | No |

### Creating S3 Bucket
```bash
aws s3 mb s3://dave-bucket-123 --region us-east-2
```

### Verification Methods

#### AWS Console
- Navigate to S3 → Bucket → Directory → State file
- View JSON contents in browser

#### AWS CLI
```bash
# List bucket contents
aws s3 ls s3://dave-bucket-123/dir1/

# View state file contents
aws s3 cp s3://dave-bucket-123/dir1/key - | jq

# Verify created resources
aws iam get-user --user-name user-42
```

### Cleanup Commands
```bash
# Remove state file
aws s3 rm s3://dave-bucket-123/dir1/key

# Remove bucket
aws s3 rb s3://dave-bucket-123
```

### Key Takeaways
- ✅ Default backend is always local
- ✅ Backend specified in terraform block
- ✅ State file becomes source of truth in S3
- ✅ No local terraform.tfstate file created

### Labs Summary
- Created S3 bucket
- Configured remote backend
- Applied Terraform (state stored remotely)
- Verified state file contents
- Cleaned up resources and bucket

---

## 10.13 Quiz

### Question 1: Multi-Cloud Challenges
**Question**: A team using AWS CloudFormation faces which challenge when expanding to Azure?
**Answer**: B - Expanding to Azure with the current codebase
**Explanation**: CloudFormation is AWS-specific; Terraform enables multi-cloud deployments from day one.

### Question 2: AWS Aliases
**Question**: Which configuration creates an instance in us-east-2 when using aliases?
**Answer**: B - Using `provider = aws.ohio` with `alias = "ohio"` and `region = "us-east-2"`
**Explanation**: Must use the alias meta argument to target secondary regions.

---

## Summary Section

### Key Takeaways

```diff
+ Multi-Cloud Support: Terraform works with AWS, Azure, Google, VMware, Docker, Kubernetes, and many more
+ Provider Aliases: Enable multi-region deployments with the provider meta argument
+ Lock Files: Standardize provider versions and enable cross-platform collaboration
+ Remote State: S3 backends provide team collaboration and state persistence
+ Credentials Management: AWS profiles enable environment separation and team access
+ Exam Alert: Know the main resource names for each cloud provider
```

### Quick Reference

#### Provider Resource Names
| Cloud | VM Resource | Network | Security |
|-------|------------|---------|----------|
| AWS | `aws_instance` | `aws_vpc` | `aws_security_group` |
| Azure | `azurerm_linux_virtual_machine` | `azurerm_virtual_network` | `azurerm_network_security_group` |
| Google | `google_compute_instance` | `google_compute_network` | `google_compute_firewall` |
| VMware | `vsphere_virtual_machine` | `vsphere_network` | N/A |
| Docker | `docker_container` | N/A | N/A |
| Kubernetes | `kubernetes_deployment_v1` | N/A | N/A |
| libvirt | `libvirt_domain` | `libvirt_network` | N/A |

#### Essential Commands
```bash
# Azure
az login
az --version

# Google Cloud
gcloud init
gcloud auth application-default login

# Terraform Multi-Platform
terraform providers lock -platform=linux_amd64 -platform=darwin_amd64 -platform=windows_amd64

# AWS S3 Backend
aws s3 mb s3://bucket-name --region us-east-1
```

### Expert Insights

#### Real-world Application
- Use **aliases** for disaster recovery across regions
- Implement **remote state** with S3 + DynamoDB for team collaboration
- Configure **multiple profiles** for CI/CD pipelines with different permission levels
- Lock provider versions in production to prevent unexpected changes

#### Expert Path
1. Master one cloud provider (AWS recommended)
2. Add second cloud (Azure or Google)
3. Implement remote state with locking
4. Create multi-region architectures with aliases
5. Add on-premises with VMware/libvirt providers
6. Container orchestration with Docker/Kubernetes

#### Common Pitfalls
- ❌ Forgetting subscription_id in Azure provider v4+
- ❌ Not running `gcloud auth application-default login` for Google
- ❌ Hardcoding AMIs instead of using data sources
- ❌ Not backing up credentials files before modifications
- ❌ Forgetting to specify provider alias for secondary regions

#### Lesser-Known Facts
- Azure CLI automatically opens browser for `az login`
- Google requires explicit zone selection (can fail if zone is full)
- Docker images download faster than Terraform initialization
- Lock file supports 12+ platform architectures
- Each AWS region has unique AMI IDs for the same OS

</details>