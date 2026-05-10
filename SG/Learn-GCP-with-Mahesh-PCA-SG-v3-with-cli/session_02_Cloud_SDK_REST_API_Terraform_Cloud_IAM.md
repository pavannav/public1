# Session 02: Cloud SDK, REST API, Terraform, and Cloud IAM Fundamentals

## Table of Contents
- [Overview](#overview)
- [Cloud SDK and Client Libraries](#cloud-sdk-and-client-libraries)
  - [Cloud SDK Installation and Setup](#cloud-sdk-installation-and-setup)
  - [Python Client Libraries](#python-client-libraries)
  - [Demonstrating Google Cloud Storage Operations](#demonstrating-google-cloud-storage-operations)
- [REST API Interaction Methods](#rest-api-interaction-methods)
  - [REST API as Mother of All Interfaces](#rest-api-as-mother-of-all-interfaces)
  - [API Explorer Demonstration](#api-explorer-demonstration)
  - [Curl Command Implementation](#curl-command-implementation)
  - [Postman REST API Testing](#postman-rest-api-testing)
- [Infrastructure as Code with Terraform](#infrastructure-as-code-with-terraform)
  - [Terraform Concepts and Workflow](#terraform-concepts-and-workflow)
  - [Creating Resources with Terraform](#creating-resources-with-terraform)
  - [Terraform for Virtual Machines](#terraform-for-virtual-machines)
- [Cloud Shell Usage and Persistence](#cloud-shell-usage-and-persistence)
  - [Cloud Shell Environment](#cloud-shell-environment)
  - [Persistent Storage Management](#persistent-storage-management)
- [Cloud IAM Identity and Access Management](#cloud-iam-identity-and-access-management)
  - [Identity Types in Google Cloud](#identity-types-in-google-cloud)
  - [Service Accounts](#service-accounts)
  - [Cloud Identity and Directory Synchronization](#cloud-identity-and-directory-synchronization)
- [IAM Roles Deep Dive](#iam-roles-deep-dive)
  - [Primitive Roles (Basic Roles)](#primitive-roles-basic-roles)
  - [Predefined Roles](#predefined-roles)
  - [Custom Roles](#custom-roles)
  - [Role Permissions Structure](#role-permissions-structure)
- [Practical IAM Demonstrations](#practical-iam-demonstrations)
  - [Creating and Managing Service Accounts](#creating-and-managing-service-accounts)
  - [Granting Access to Identities](#granting-access-to-identities)
- [Quiz Section](#quiz-section)
- [Summary](#summary)

## Overview
This session delves into advanced Google Cloud Platform interaction methods beyond the basic console. We explore Cloud SDK, REST APIs using curl and Postman, Infrastructure as Code with Terraform, and establish a strong foundation in Cloud IAM concepts including identities, roles, and permissions. The session includes practical demonstrations of all methods and concludes with important quiz content that reinforces key concepts for exam preparation.

## Cloud SDK and Client Libraries

### Cloud SDK Installation and Setup

The Google Cloud SDK provides command-line access to GCP services across multiple platforms. It includes essential tools like gcloud, gsutil, and bq for comprehensive cloud management.

**Installation Methods:**

1. **Interactive Installation:**
```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
```

2. **Package Manager Installation (Ubuntu/Debian):**
```bash
sudo apt-get update && sudo apt-get install google-cloud-sdk
```

3. **Container Installation:**
```bash
docker run -ti --name gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk gcloud auth login
```

**Basic Setup Commands:**
```bash
# Initialize Cloud SDK
gcloud init

# Set project
gcloud config set project PROJECT_ID

# Set default region
gcloud config set compute/region us-central1

# View current configuration
gcloud config list
```

> [!NOTE]
> Cloud SDK provides a unified interface for managing all Google Cloud services. The gcloud command is the primary interface, while gsutil handles Cloud Storage operations and bq manages BigQuery datasets.

### Python Client Libraries

Google provides official client libraries in multiple programming languages, enabling programmatic interaction with GCP services. The Python library allows seamless integration for automation and development.

**Key Characteristics:**
- ✅ **Cross-platform compatibility**
- ✅ **Automatic authentication handling**
- ✅ **Exception handling and error management**
- ✅ **Synchronous and asynchronous operations**

### Demonstrating Google Cloud Storage Operations

Let's create a Google Cloud Storage bucket using Python, demonstrating practical client library usage.

```python
from google.cloud import storage

def create_storage_bucket(bucket_name):
    """Create a new Google Cloud Storage bucket using Python client library."""
    storage_client = storage.Client()
    bucket = storage_client.create_bucket(bucket_name)
    print(f"✅ Bucket {bucket.name} created successfully!")
    return bucket

# Usage
bucket_name = "cloud-architect-python-demo"
create_storage_bucket(bucket_name)
```

**Prerequisites:**
1. Install the Google Cloud Storage library: `pip install google-cloud-storage`
2. Authenticate with Google Cloud
3. Ensure proper IAM permissions

**Key Points:**
- ✅ **Generative AI Integration**: Use ChatGPT or Vertex AI to generate code snippets
- ✅ **Cross-platform Language Support**: Available in Python, Node.js, Go, Java, C#, and more
- ✅ **Production Ready**: Includes error handling and logging capabilities

## REST API Interaction Methods

### REST API as Mother of All Interfaces

REST APIs form the fundamental layer of Google Cloud interactions. Every action performed via console, CLI, or UI ultimately calls REST API endpoints.

**Key Principles:**
- 📝 **Universal Access**: Any programming language with HTTP capabilities can interact with GCP
- 🔐 **Authentication**: OAuth 2.0, API keys, or service account authentication
- 🌐 **HTTP Methods**: GET, POST, PUT, DELETE, PATCH
- 📋 **JSON Payloads**: Request/response data in JSON format

> [!IMPORTANT]
> REST APIs are the mother of all Google Cloud interfaces. Every console action, CLI command, and UI operation translates to REST API calls. Mastering REST APIs provides complete control over GCP resources using any programming language.

### API Explorer Demonstration

Google Cloud provides an interactive API Explorer for testing REST API calls directly from the browser.

**Features:**
- ✅ **No Code Required**: Interactive testing without development setup
- ✅ **Parameter Validation**: Built-in form validation for required fields
- ✅ **OAuth Integration**: Seamless authentication flow
- ✅ **Request History**: Track API calls and responses

**Creating a GCS Bucket via API Explorer:**

1. Navigate to [Google API Explorer](https://developers.google.com/apis-explorer)
2. Search for "storage.buckets.insert"
3. Provide required parameters:
   - Project ID
   - Bucket name
   - Authentication
4. Execute the request
```json
{
  "name": "cloud-architect-api-demo",
  "location": "us-central",
  "storageClass": "STANDARD"
}
```

### Curl Command Implementation

Curl provides command-line REST API interaction with comprehensive GCP control.

**Basic GCS Bucket Creation with Curl:**
```bash
# Get access token
ACCESS_TOKEN=$(gcloud auth print-access-token)

# Create bucket
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "cloud-architect-curl-demo",
    "location": "us-central1"
  }' \
  https://storage.googleapis.com/storage/v1/b?project=YOUR_PROJECT_ID
```

**Advanced Usage:**
```bash
# List buckets
curl -H "Authorization: Bearer $ACCESS_TOKEN" \
  https://storage.googleapis.com/storage/v1/b

# Upload file to bucket
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  https://storage.googleapis.com/upload/storage/v1/b/YOUR_BUCKET/o?name=file.txt \
  -d @local-file.txt
```

> [!WARNING]
> Always use HTTPS endpoints, never HTTP, to ensure encrypted communication with Google Cloud APIs.

### Postman REST API Testing

Postman offers a user-friendly interface for REST API testing and collection management.

**Key Features:**
- 📝 **Pre-built Collections**: Save and organize API requests
- 🔍 **Environment Variables**: Manage different environments (dev, staging, prod)
- 📊 **Response Visualization**: Format JSON/XML responses
- 🔐 **Authentication Methods**: Support for OAuth, Bearer tokens, API keys
- 📈 **Testing and Monitoring**: Built-in test scripts and monitoring

**Postman Setup for GCP:**

1. **Authentication Setup:**
   - Method: Bearer Token
   - Token: `$(gcloud auth print-access-token)`

2. **Bucket Creation Request:**
   - Method: POST
   - URL: `https://storage.googleapis.com/storage/v1/b?project=YOUR_PROJECT_ID`
   - Headers: `Content-Type: application/json`
   - Body: `{"name": "cloud-architect-postman-demo"}`

> [!NOTE]
> Postman excels at API workflow testing and documentation. It's particularly useful for complex API sequences and parameter variations.

## Infrastructure as Code with Terraform

### Terraform Concepts and Workflow

Terraform enables infrastructure as Code (IaC), managing GCP resources through declarative configuration files. It's HashiCorp's open-source tool for multi-cloud infrastructure provision.

**Core Concepts:**
- 📝 **Declarative Configuration**: Define desired state, not procedural steps
- 🔄 **State Management**: Track resource changes and dependencies
- 💻 **Multi-cloud Support**: Works across GCP, AWS, Azure
- 📦 **Modules**: Reusable infrastructure components

**Terraform Workflow:**
```bash
# 1. Initialize Terraform (download providers)
terraform init

# 2. Plan changes (preview modifications)
terraform plan

# 3. Apply changes (create/update resources)
terraform apply

# 4. Destroy resources (cleanup)
terraform destroy
```

### Creating Resources with Terraform

**Basic Project Configuration:**
```hcl
# Provider configuration
provider "google" {
  project = "your-project-id"
  region  = "us-central1"
}

# Resource definition
resource "google_storage_bucket" "example" {
  name     = "cloud-architect-terraform-demo"
  location = "us-central1"

  lifecycle {
    prevent_destroy = true
  }
}
```

### Terraform for Virtual Machines

**VM Creation Template:**
```hcl
# Virtual Machine Resource
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-vm-demo"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 20
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

# Static IP Allocation
resource "google_compute_address" "static" {
  name = "vm-static-ip"
}
```

**Key Benefits:**
- ✅ **Reproducibility**: Identical infrastructure across environments
- 🔄 **Version Control**: Track infrastructure changes like code
- 💰 **Cost Management**: Simple resource cleanup with `terraform destroy`

## Cloud Shell Usage and Persistence

### Cloud Shell Environment

Cloud Shell provides browser-based terminal access to GCP with pre-installed tools and is free to use.

**Key Features:**
- ✅ **Pre-authenticated**: Automatic authentication for GCP projects
- ✅ **Persistent $HOME Directory**: 5GB storage persists across sessions
- 🔧 **Pre-installed Tools**: gcloud, kubectl, terraform, git, etc.
- 🌐 **Global Access**: Available everywhere with internet connectivity

### Persistent Storage Management

**Storage Management:**
```bash
# Check current storage usage
df -h | grep /home/$USER

# Clear temporary files when needed
rm -rf /tmp/*

# Clean up Terraform cache
rm -rf .terraform/
```

**Ephemeral Mode:**
- Create non-persistent environments for quick experiments
- Zero storage persistence
- No $HOME directory mounting

**Usage Tips:**
- 📝 **Regular Cleanup**: Remove unused files to prevent storage exhaustion
- 🔄 **Selective Persistence**: Use persistent mode for long-term development
- 🚀 **Quick Tests**: Ephemeral mode for one-time demonstrations

## Cloud IAM Identity and Access Management

### Identity Types in Google Cloud

Cloud IAM manages who can do what on which resources through a system of identities, roles, and permissions.

**Identity Hierarchy:**
1. **Google Account**: Personal Gmail accounts (e.g., `user@gmail.com`)
2. **Google Workspace**: Organizational accounts (e.g., `user@company.com`)
3. **Cloud Identity**: Directory services with optional on-premises sync
4. **Service Accounts**: Machine identities (e.g., `service@project.iam.gserviceaccount.com`)

### Service Accounts

Service accounts represent applications or VMs, not human users. They enable secure, authenticated API access without user credentials.

**Key Characteristics:**
- 🤖 **Non-human Identities**: For applications and automated processes
- 🔑 **Key-based Authentication**: Uses JSON keys or metadata authentication
- 🎯 **Scoped Access**: Fine-grained permissions for specific operations
- 🔒 **Security First**: Cannot log into Google Cloud console

**Creating Service Accounts:**
```bash
# Via CLI
gcloud iam service-accounts create sa-name \
  --description="Description" \
  --display-name="Display Name"

# Via Console
# IAM → Service Accounts → Create service account
```

**Service Account Email Format:**
```
sa-name@project-id.iam.gserviceaccount.com
```

### Cloud Identity and Directory Synchronization

Cloud Identity bridges on-premises identity systems with Google Cloud through directory synchronization.

**Cloud Identity Options:**

1. **Manual Creation**: Create users directly in admin.google.com
2. **Directory Sync**: Automated synchronization with Active Directory
3. **Single Sign-On**: Enforce corporate authentication policies

**Directory Synchronization:**
- 📤 **One-way Sync**: On-premises AD → Google Cloud Identity
- 🔐 **Password Hashing**: Syncs password hashes (never clear text)
- 👥 **Group Management**: Synchronizes groups and memberships

**Migration Flow:**
```
Active Directory → Cloud Identity → Project IAM
        ↓              ↓              ↓
   User Creation → SSO Setup → Role Assignment
```

> [!WARNING]
> Directory synchronization enables enterprise-wide single sign-on but requires careful planning to avoid lockouts. Always test SSO implementation in a sandbox environment first.

## IAM Roles Deep Dive

### Primitive Roles (Basic Roles)

Primitive roles provide broad access across all Google Cloud services. While simple to use, they're considered security anti-patterns.

**Three Primitive Roles:**
- **Owner**: Full access (including billing) - Dangerous in production
- **Editor**: Modify resources but can't grant access
- **Viewer**: Read-only access to resources

**Primitive Roles Schedule:**

| Role | Permissions | Use Case | Security Rating |
|------|------------|----------|-----------------|
| Owner | ~9,910 permissions | Personal sandbox projects | 🚨 High Risk |
| Editor | ~877 permissions | Development environments | ⚠️ Medium Risk |
| Viewer | Read-only | Auditing and monitoring | ✅ Low Risk |

> [!DANGER]
> Avoid using primitive roles in production environments. Use predefined roles with least privilege principle instead.

### Predefined Roles

Predefined roles offer granular, service-specific access with appropriate permissions for common tasks.

**Example Service Roles:**
```diff
! Storage Admin: Full control over Cloud Storage buckets
+ Storage Object Viewer: Read-only access to objects
- Compute Admin: Full control over Compute Engine resources
! Cloud SQL Admin: Full control over Cloud SQL instances
```

**Role Discovery:**
```bash
# List all predefined roles
gcloud iam roles list --filter="permissions:storage.buckets.*"

# Describe specific role
gcloud iam roles describe roles/storage.admin
```

### Custom Roles

Custom roles enable organizational specific permission combinations when predefined roles don't suffice.

**Use Cases:**
- ✅ **Custom Business Logic**: Permissions matching unique workflows
- ✅ **Least Privilege**: Exact permissions needed for tasks
- ❌ **Role Combining**: Avoid using custom roles just to merge existing roles

**Best Practices:**
- 🎯 **Principle of Least Privilege**: Grant minimum required permissions
- 📊 **Regular Reviews**: Audit custom roles for continued relevance
- 🔄 **Maintenance**: Custom roles require organizational maintenance

### Role Permissions Structure

Permissions follow a structured format: `service.resource.action`

**Permission Examples:**
```
storage.buckets.create
storage.objects.list
compute.instances.start
compute.networks.use
```

**Assignment Rules:**
- ✅ **Role Assignment**: Assign roles to identities
- ❌ **Direct Permission Assignment**: Never assign permissions directly
- 📝 **RBAC Model**: Role-Based Access Control implementation

> [!IMPORTANT]
> Roles are granted to identities, not permissions directly. This ensures consistent, manageable access control throughout your Google Cloud organization.

## Practical IAM Demonstrations

### Creating and Managing Service Accounts

**Console Method:**
1. Navigate to IAM → Service Accounts
2. Click "Create service account"
3. Define account details and roles
4. Download JSON key (treat as sensitive data)

**CLI Method:**
```bash
# Create service account
gcloud iam service-accounts create sa-demo \
  --description="Demo service account" \
  --display-name="Demo SA"

# List service accounts
gcloud iam service-accounts list

# Grant roles
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:sa-demo@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.admin"
```

### Granting Access to Identities

**Granting Roles via Console:**
1. IAM → IAM
2. "Add" button
3. Enter principal (email or service account)
4. Select role
5. Save changes

**Granting Roles via CLI:**
```bash
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="user:john.doe@example.com" \
  --role="roles/compute.admin"
```

**Best Practices:**
- 📝 **Group-based Access**: Assign roles to groups, not individuals
- 🔍 **Regular Audits**: Review and rotate IAM bindings
- 🎯 **Role Separation**: Different service accounts for different functions

## Quiz Section

### Cloud Shell Quiz

**Question 1: Where should custom utilities be installed for week-long retention?**

```diff
! /usr/local/bin - Not persistent
+ /home/$USER/bin - Persistent in Cloud Shell
! /tmp - Temporary location
- /opt - Not persistent
```

**Answer: /home/$USER/bin**

### gcloud Command Quiz

**Question 2: How to set default region for all gcloud commands?**

```diff
! gcloud config set region europe-west1 - Incorrect flag
+ gcloud config set compute/region europe-west1 - Correct command
! Use Cloud Shell navigation - UI-based, not command-line
- VPN setup - Unnecessary for default region setting
```

**Answer: gcloud config set compute/region europe-west1**

## Summary

### Key Takeaways

```diff
+ Six GCP interaction methods: Console, Cloud SDK, REST API, Client Libraries, IaC Terraform, Mobile App
! REST APIs are the mother of all interfaces - foundational layer for all GCP interactions
- Client libraries provide language-native GCP integration with error handling
+ Cloud Shell offers persistent environments with pre-installed tools
! Identity types: Google Account, Workspace, Cloud Identity, Service Accounts
+ Service accounts enable secure machine-to-machine authentication
- Primitive roles (Owner/Editor/Viewer) are dangerous - use predefined roles instead
+ Custom roles allow fine-tuned permissions but require maintenance
! IAM follows "who + what + on which resources" paradigm
- Always assign roles, never grant permissions directly
```

### Quick Reference

**Essential Commands:**
```bash
# Cloud SDK setup
gcloud init
gcloud config set project PROJECT_ID
gcloud config set compute/region us-central1

# Terraform workflow
terraform init
terraform plan
terraform apply
terraform destroy

# Service account management
gcloud iam service-accounts create SA_NAME --description="Description"
gcloud iam service-accounts list
gcloud projects add-iam-policy-binding PROJECT_ID --member=PRINCIPAL --role=ROLE

# IAM role inspection
gcloud iam roles list --filter="permissions:storage.*"
gcloud iam roles describe roles/storage.admin
```

**REST API Endpoints:**
```bash
# List projects
curl -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  https://cloudresourcemanager.googleapis.com/v1/projects

# Create storage bucket
curl -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  https://storage.googleapis.com/storage/v1/b \
  -d '{"name":"my-bucket","location":"us-central1"}'
```

### Expert Insight

**Real-world Application:**
Start with console and CLI for learning, then migrate to IaC (Terraform) for production deployments. Use custom client libraries for application integration and REST APIs for low-level automation. Always implement IaC for infrastructure management to ensure reproducibility and version control.

**Expert Path:**
Master Terraform modules and workspaces for large-scale deployments. Understand IAM policy hierarchy (Organization → Folders → Projects → Resources) for complex multi-project setups. Learn Cloud Asset Inventory API for programmatic IAM auditing and compliance monitoring.

**Common Pitfalls:**
- ⚠️ **Primitive Role Overuse**: Never use Owner role in teams - leads to unauthorized changes
- 🚨 **Service Account Key Exposure**: Never commit JSON keys to version control
- 🔓 **Over-permissive IAM**: Follow least privilege - start restrictive and expand as needed
- ❌ **Manual Resource Creation**: Use IaC from day one to avoid configuration drift

**Lesser-Known Facts:**
- Service accounts can act as principals in other GCP services
- Cloud SDK supports multiple configuration profiles for different projects
- Terraform remote state in Cloud Storage enables team collaboration
- Cloud Shell automatically authenticates with active console project

**Advantages and Disadvantages:**

| Method | Advantages | Disadvantages |
|--------|------------|----------------|
| **Cloud SDK** | Scriptable, comprehensive, automation-friendly | Steep learning curve for beginners |
| **REST API** | Universal language support, complete control | Complex authentication, verbose requests |
| **Client Libraries** | Language-native, easier error handling | Library dependencies, version management |
| **Terraform** | Reproducible infrastructure, version control | Requires infrastructure planning |
| **Postman** | User-friendly testing, collection management | Not suitable for automated workflows |
| **Cloud Shell** | Free, pre-configured, authenticated | Limited storage (5GB), session timeouts |

> [!IMPORTANT]
> Master at least two interaction methods: gcloud CLI for operations and Terraform for infrastructure. Understand IAM deeply before deploying production workloads. Practice VPC creation, instance management, and storage operations before proceeding to advanced services.

> [!NOTE]
> Remember that primitive roles contain thousands of permissions and violate security best practices. Use predefined roles with the principle of least privilege for production environments.

— Day 02: Complete cloud interaction methods and IAM foundations established. Ready for policy binding and organizational IAM concepts.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>