# Session 2: Cloud SDK, REST API, Terraform, and Cloud IAM Fundamentals

## Table of Contents

1. Introduction to Cloud SDK
2. REST API Interactions
3. Infrastructure as Code with Terraform
4. Cloud IAM Concepts - Identity & Roles
5. Summary

## Introduction to Cloud SDK

### Overview

Google Cloud SDK (gcloud CLI) serves as the primary command-line interface for interacting with Google Cloud Platform services. This section introduces the foundational concepts of programmatic cloud management through client libraries, explaining why code-based approaches complement GUI and CLI methods.

### Key Concepts / Deep Dive

The Cloud SDK provides developers and administrators with tools to programmatically manage cloud resources. By leveraging client libraries and command-line utilities, users can automate interactions with cloud services, enabling scripting and integration capabilities that graphical interfaces lack.

Key capabilities include:
- Automated resource provisioning and management
- Integration with CI/CD pipelines
- Custom tooling development
- Administrative automation

#### Client Libraries Architecture

Client libraries bridge applications and Google Cloud APIs:
- Pre-built libraries for multiple programming languages
- Built on REST API foundations
- Handle authentication, retries, and error handling
- Available for go, java, nodejs, python, and others

#### Demonstration: Python Client Library for GCS

The instructor demonstrates using Python's Google Cloud Storage client library to create buckets, showcasing how code can replace manual operations.

- Install required libraries (typically pre-installed in Cloud Shell)
- Import and configure client
- Execute bucket creation
- Verify successful operation in console

```python
import os
from google.cloud import storage
os.environ['GOOGLE_CLOUD_PROJECT'] = 'your-project-id'

client = storage.Client()
bucket_name = 'cloud-architect-gcs-python-client-library-v1'
bucket = client.create_bucket(bucket_name)
print("Bucket created successfully")
```

**Execution Steps:**
1. Set environment variables for authentication
2. Initialize storage client
3. Call create_bucket method
4. Monitor console for new bucket creation

## REST API Interactions

### Overview

REST APIs represent the foundational layer of Google Cloud interactions, providing programmatic access to all services. The instructor demonstrates multiple methods of API interaction, emphasizing how all cloud operations ultimately invoke REST endpoints regardless of the interface used.

### Key Concepts / Deep Dive

REST APIs serve as the universal language of cloud computing:
- HTTP-based communication protocol
- Resource-based URL structures
- JSON data interchange
- HTTP methods (GET, POST, PUT, DELETE)
- Authentication via OAuth tokens or API keys

All Google Cloud services expose REST APIs, making them the most fundamental interaction method before GUI, CLI, or IaC tools.

#### API Explorer Interface

Google API Explorer provides a browser-based interface for testing APIs:
- Authentication handled automatically
- Request/response visualization
- Supports all Google Cloud APIs
- Interactive parameter input
- No coding required

#### Demonstration: Creating GCS Bucket via API Explorer

**Steps:**
1. Navigate to API Explorer in Google Cloud Console
2. Search and select Cloud Storage API
3. Set project ID and bucket name
4. Execute request
5. Verify bucket creation in console
6. Note JSON response structure

#### cURL Implementation

cURL provides command-line HTTP client functionality for API testing:

**Basic Pattern:**
```bash
curl -X POST \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  -d '{"name": "curl-bucket-v2"}' \
  https://storage.googleapis.com/storage/v1/b
```

**Process Flow:**
1. Obtain authentication token using gcloud CLI
2. Construct REST endpoint URL
3. Set appropriate HTTP headers
4. Include request body with bucket creation parameters
5. Execute curl command
6. Parse JSON response

**List Buckets API:**
```bash
curl -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  https://storage.googleapis.com/storage/v1/b?project=YOUR_PROJECT_ID
```

This demonstrates how bucket listing retrieves all previously created buckets across different interaction methods.

#### Postman Integration

Postman offers a graphical API testing environment:

**Configuration Steps:**
1. Install Postman application
2. Set request method (POST for bucket creation)
3. Enter API endpoint URL
4. Configure OAuth 2.0 authentication
5. Add request body with bucket details
6. Send request and validate response
7. Verify bucket creation in console

**Request Template:**
```
Method: POST
URL: https://storage.googleapis.com/upload/storage/v1/b/my-postman-bucket-2024/o?uploadType=media&name=postman_test.txt
Headers:
- Authorization: Bearer [ACCESS_TOKEN]
- Content-Type: application/json
Body: "Hello from Postman"
```

#### API Debugging with Verbose Logging

All interaction methods ultimately invoke the same REST APIs. Debug mode reveals underlying HTTP calls:

**Enable Debug Mode:**
```bash
gsutil -D cp file.txt gs://bucket/
# or
gcloud storage cp --verbosity=debug file.txt gs://bucket/
```

This shows the actual API endpoints, authentication mechanisms, and data flows underneath higher-level tools.

## Infrastructure as Code with Terraform

### Overview

Terraform enables declarative infrastructure management, allowing teams to define cloud resources as code. This approach ensures consistency, version control, and automated deployment capabilities across development, staging, and production environments.

### Key Concepts / Deep Dive

Infrastructure as Code (IaC) principles apply cloud management:
- Declarative resource definitions
- Version-controlled infrastructure
- State management and drift detection
- Plan and apply workflows
- Provider extensibility for multi-cloud deployments

#### Terraform Workflow Overview

1. **Init**: Initialize working directory with required providers
2. **Plan**: Generate execution plan showing proposed changes
3. **Apply**: Execute the plan to provision resources
4. **Destroy**: Clean up resources when no longer needed

#### Provider Configuration

```hcl
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = "your-project-id"
  region  = "us-central1"
}
```

#### Resource Definition Patterns

**Storage Bucket Resource:**
```hcl
resource "google_storage_bucket" "example_bucket" {
  name          = "cloud-architect-terraform-v1"
  location      = "us-central1"
  force_destroy = true
}
```

**Compute Instance Resource:**
```hcl
resource "google_compute_instance" "demo_vm" {
  name         = "terraform-demo-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
```

#### Execution Commands

```bash
# Initialize Terraform workspace
terraform init

# Preview changes
terraform plan

# Apply configuration
terraform apply

# Destroy resources
terraform destroy
```

#### State Management Considerations

Terraform maintains state files to track resource configurations:
- Local state files (.tfstate) by default
- Remote state backends for team collaboration
- State locking prevents concurrent modifications
- State versioning for rollback capabilities

#### Cloud Shell Terraform Tips

**Persistent Installation:**
- Install Terraform in `/home/$USER/bin/` for retention
- Use auto-approve flags for automated execution
- Leverage ephemeral sessions for quick testing

**Best Practices:**
- Use version pinning for providers
- Implement remote state backends
- Use modules for reusable configurations
- Validate configurations before apply

## Cloud IAM Concepts - Identity & Roles

### Overview

Cloud Identity and Access Management (IAM) forms the security foundation of Google Cloud Platform. This comprehensive section explores identity types, role hierarchies, permission structures, and best practices for implementing least privilege access controls.

### Key Concepts / Deep Dive

IAM answers the fundamental question: "Who can do what on which resources?"

**Core Components:**
- **Principals**: Who (identities) can access resources
- **Roles**: Collections of permissions granted to principals
- **Resources**: Cloud services and data that need protection
- **Policies**: Bindings that connect principals to roles on specific resources

#### Principal Types in Google Cloud

**1. Google Account**
- Personal Gmail accounts (@gmail.com)
- Individual user authentication
- Suitable for learning and individual projects
- Basic authentication via OAuth

**2. Google Workspace Accounts**
- Corporate email domains (@company.com)
- Managed identities through admin.google.com
- Integrated with enterprise authentication
- Support for SAML/SSO integration

**3. Cloud Identity**
- Domain-verified identities
- Managed through admin.google.com
- Supports individual user creation and management
- Foundation for IAM implementation
- Pricing: Free tier available

**4. Cloud Identity with Active Directory**
- Synchronized identities from Microsoft AD
- Google Cloud Directory Sync tool
- Maintains AD as single source of truth
- Supports SSO configurations

**5. Service Accounts**
- Non-human identities for APIs and VMs
- Email addresses ending in @gcp-project.iam.gserviceaccount.com
- Used for automated processes and machine-to-machine communication
- Support workload identity federation

#### Role Hierarchy and Types

**Basic Roles (Primitive Roles):**
- **Owner**: Full control including billing and IAM management
- **Editor**: Full control except IAM policies and billing
- **Viewer**: Read-only access to all resources
- *Recommendation*: Avoid in production due to broad permissions

**Predefined Roles:**
- Service-specific granular permissions
- Maintained by Google
- Follow principle of least privilege
- Examples: `storage.admin`, `compute.instanceAdmin.v1`, `bigquery.dataEditor`

**Custom Roles:**
- User-defined permission collections
- Scopes: Organization, Folder, Project
- Maintenance overhead for creators
- Use when predefined roles don't meet requirements

#### Permission Structure

Permissions follow the format: `service.resource.verb`
- `storage.buckets.create`
- `compute.instances.start`
- `bigquery.jobs.create`

#### Service Account Management

**Creation Methods:**

**Via Console:**
1. Go to IAM → Service Accounts
2. Click "Create Service Account"
3. Provide name and description
4. Grant roles (optional during creation)
5. Generate keys if needed

**Via CLI:**
```bash
gcloud iam service-accounts create SERVICE_ACCOUNT_NAME \
  --description="Description" \
  --display-name="Display Name"
```

**Key Points:**
- Service accounts are created at project level
- Can be granted roles across projects
- Private keys should be managed securely
- Workload Identity Federation is preferred over keys

#### Role Assignment Patterns

**Direct Role Assignment:**
- Grant roles directly to users/groups/service accounts
- Immediate effect
- Granular control possible

**Group-Based Assignment:**
- Create groups in Cloud Identity or Google Groups
- Grant roles to groups rather than individuals
- Simplifies user lifecycle management
- Best practice for enterprise environments

#### Policy Binding Structure

IAM policies bind principals to roles:
```json
{
  "bindings": [
    {
      "role": "roles/storage.admin",
      "members": [
        "user:jane@example.com",
        "group:admins@groups.example.com",
        "serviceAccount:my-sa@my-project.iam.gserviceaccount.com"
      ]
    }
  ]
}
```

### Code/Config Blocks

#### Service Account CLI Commands
```bash
# List all service accounts
gcloud iam service-accounts list

# Create service account
gcloud iam service-accounts create my-sa \
  --description="Storage service account" \
  --display-name="GCS Service Account"

# Grant role to service account
gcloud projects add-iam-policy-binding my-project \
  --member="serviceAccount:my-sa@my-project.iam.gserviceaccount.com" \
  --role="roles/storage.admin"
```

#### Terraform IAM Resources
```hcl
resource "google_service_account" "storage_sa" {
  account_id   = "storage-service-account"
  display_name = "Storage Service Account"
  description  = "Service account for GCS operations"
}

resource "google_project_iam_binding" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.storage_sa.email}",
  ]
}
```

### Lab Demo

#### Exercise: Implementation of Principle of Least Privilege

**Scenario:** User "Mahes" needs to:
- Start/stop VMs (but not create or delete them)
- Upload objects to GCS buckets (but not create/delete buckets)

**Solution Implementation:**

1. **Create Custom Role for VM Operations**
```bash
gcloud iam roles create vmOperator --project=my-project \
  --title="VM Operator" \
  --description="Can start/stop VMs but not create/delete" \
  --permissions=compute.instances.start,compute.instances.stop,compute.instances.get
```

2. **Create Custom Role for Storage Operations**
```bash
gcloud iam roles create storageOperator --project=my-project \
  --title="Storage Object Operator" \
  --description="Can upload/delete objects but not manage buckets" \
  --permissions=storage.objects.create,storage.objects.delete,storage.objects.get
```

3. **Grant Custom Roles to User**
```bash
# Grant VM operation role
gcloud projects add-iam-policy-binding my-project \
  --member="user:simple-gcp-user@gmail.com" \
  --role="projects/my-project/roles/vmOperator"

# Grant storage operation role
gcloud projects add-iam-policy-binding my-project \
  --member="user:simple-gcp-user@gmail.com" \
  --role="projects/my-project/roles/storageOperator"
```

4. **Verification**
- User can start/stop existing VMs
- User can upload/delete objects in existing buckets
- User cannot create new VMs or buckets
- Demonstrates granular access control

## Summary

### Key Takeaways

The session establishes the programmatic foundations of Google Cloud Platform through multiple interaction paradigms:

- **REST APIs** serve as the universal interface underlying all cloud operations
- **Client libraries and SDKs** enable programmatic resource management across languages
- **Infrastructure as Code with Terraform** provides declarative, version-controlled resource provisioning
- **Cloud IAM** implements security through identity types and role-based access control
- **Service accounts** enable secure machine-to-machine communications
- **Principle of least privilege** should guide all access management decisions

### Quick Reference / Cheatsheet

#### Authentication & Project Setup
```bash
# Authenticate to Google Cloud
gcloud auth login

# Set active project
gcloud config set project YOUR_PROJECT_ID

# Get access token for API calls
gcloud auth print-access-token
```

#### Client Library (Python GCS Example)
```python
from google.cloud import storage

client = storage.Client()
bucket = client.create_bucket('my-bucket')
print(f"Bucket {bucket.name} created")
```

#### REST API with cURL
```bash
# Create bucket
TOKEN=$(gcloud auth print-access-token)
curl -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name": "curl-bucket"}' \
  https://storage.googleapis.com/storage/v1/b

# List buckets
curl -H "Authorization: Bearer $TOKEN" \
  https://storage.googleapis.com/storage/v1/b?project=YOUR_PROJECT_ID
```

#### Terraform Basics
```bash
# Initialize workspace
terraform init

# Preview changes
terraform plan

# Apply configuration
terraform apply

# Clean up resources
terraform destroy
```

#### Common IAM Commands
```bash
# List service accounts
gcloud iam service-accounts list

# Create service account
gcloud iam service-accounts create my-sa --display-name="My SA"

# Grant role
gcloud projects add-iam-policy-binding PROJECT \
  --member="serviceAccount:EMAIL" \
  --role="roles/ROLE_NAME"
```

### Expert Insights

#### 🏭 **Real-world Application**
Professional cloud deployments prioritize:
- **Infrastructure as Code** for production deployments using Terraform Enterprise editions
- **Service accounts with Workload Identity** instead of service account keys
- **Federated identity** integration with existing enterprise directories
- **Automated policy management** through CI/CD pipelines
- **Regular access reviews** using IAM recommender tools

#### 🧭 **Expert Path**
Advanced IAM practices include:
1. **Organization-level policies** for enterprise governance
2. **Folder-level resource organization** for multi-team structures
3. **Conditional role bindings** using IAM Conditions
4. **VPC Service Controls** for data perimeter enforcement
5. **BeyondCorp security** implementation using IAP
6. **Cloud Asset Inventory** for resource discovery and compliance

#### 🪤 **Common Pitfalls**
- **Overusing primitive roles** especially Owner and Editor
- **Sharing service account keys** instead of using Workload Identity
- **Granting permanent access** without time-based revocation
- **Ignoring organization policies** at the project level
- **Not rotating service account keys** regularly
- **Missing least privilege principles** in access management

#### 🔍 **Lesser-Known Facts**
- **Cloud Shell sessions persist** for 12 hours allowing continued work
- **API Explorer** works for all Google APIs, not just Cloud services
- **Terraform can operate without state files** in ephemeral mode
- **Service accounts can be granted cross-project permissions**
- **IAM policies support up to 1500 members** per binding
- **Custom roles require project or organization level creation**

#### ⚖️ **Advantages & Disadvantages**

| Method | Speed | Learning Curve | Automation | Production Ready |
|--------|-------|----------------|------------|------------------|
| Web Console | Fast | Low | Limited | No |
| gcloud CLI | Medium | Medium | High | Yes |
| REST APIs | Variable | High | High | Yes |
| Client Libraries | Variable | Medium-High | High | Yes |
| Terraform | Slow | High | High | Yes |

**Key Decision Factors:**
- **Ad-hoc tasks**: Use console or CLI
- **Development**: Client libraries or CLI scripts
- **Production deployments**: Terraform with CI/CD
- **System integration**: REST APIs or client libraries
- **Multi-cloud**: Terraform's provider ecosystem

📝 Transcript Corrections: "ript" at the beginning appears to be a transcription artifact that should be corrected to "Script" or similar.