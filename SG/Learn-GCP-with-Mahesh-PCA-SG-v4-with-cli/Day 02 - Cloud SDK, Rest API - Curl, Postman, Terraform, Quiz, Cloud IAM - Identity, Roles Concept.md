# Day 02 - Cloud SDK, Rest API - Curl, Postman, Terraform, Quiz, Cloud IAM - Identity, Roles Concept

## Overview
This session covers the six main ways to interact with Google Cloud Platform (GCP): console, CLI, client libraries, REST APIs, Terraform, mobile app. It introduces Cloud IAM fundamentals including identities, roles, and permissions. Key demonstrations show resource provisioning using various methods and IAM role assignments.

## Key Learning Objectives
- Understand and apply the 6 interaction methods for GCP
- Implement resource provisioning using different approaches
- Master Cloud IAM concepts: identities, roles, permissions
- Apply principle of least privilege using appropriate roles
- Navigate between different identity types (human vs. service accounts)

## Detailed Study Guide

### 1. Six Ways to Interact with GCP

#### Method 1: Google Cloud Console (GUI)
- **Use Case**: Visual interface for resource management
- **Access**: console.cloud.google.com
- **Features**: Drag-and-drop, forms, wizards
- **Best For**: Learning, initial setup, complex configurations
- **Limitation**: Slower for bulk operations

**Demonstration Points:**
- Created GCS bucket via GUI
- Settings show default region/zone selection
- Equivalent code snippets available for CLI conversion

#### Method 2: Cloud SDK Command Line Interface (gcloud)
- **Setup**: Install Cloud SDK on local machine or use Cloud Shell
- **Commands**: `gcloud compute instances create`, `gcloud storage buckets create`
- **Advantages**: Scriptable, fast for experienced users
- **Authentication**: Built-in OAuth flow

**Key Commands Covered:**
```bash
gcloud auth login
gcloud storage buckets create gs://my-bucket
gcloud compute instances create my-vm --image-family=debian-11 --image-project=debian-cloud
```

#### Method 3: Client Libraries
- **Languages**: Go, Java, Node.js, Python, Ruby, PHP, .NET, C++
- **Usage**: Programmatic resource creation/destruction
- **Execution**: Run in Cloud Shell (libraries pre-installed)
- **Authentication**: ADC (Application Default Credentials)

**Python Example:**
```python
from google.cloud import storage

bucket_name = 'cloud-architect-gcs-client-library-v1'
client = storage.Client()
bucket = client.create_bucket(bucket_name, location='us')
print(f'Bucket {bucket.name} created.')
```

#### Method 4: REST APIs
- **Foundation**: All GCP services built on REST APIs
- **Endpoints**: `*.googleapis.com` (storage.googleapis.com, compute.googleapis.com)
- **Methods**: GET, POST, PUT, DELETE
- **Authentication**: Bearer tokens via `gcloud auth print-access-token`
- **Tools**: Google API Explorer, curl, Postman

**curl Example:**
```bash
ACCESS_TOKEN=$(gcloud auth print-access-token)
curl -X POST \
  https://storage.googleapis.com/storage/v1/b?project=my-project \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name": "cloud-architect-rest-api-v1"}'
```

#### Method 5: Terraform Infrastructure as Code
- **Purpose**: Declarative infrastructure provisioning
- **Commands**: `terraform init`, `terraform plan`, `terraform apply`, `terraform destroy`
- **Files**: main.tf contains resource definitions
- **Providers**: google_cloud_platform
- **Execution**: Works locally or in Cloud Shell (terraform pre-installed)

**Example Terraform Configuration:**
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
  project = "my-project-id"
}

resource "google_storage_bucket" "example" {
  name     = "cloud-architect-terraform-v1"
  location = "US"
}
```

#### Method 6: Mobile App
- **Platform**: Android/iOS apps
- **Primary Use**: Monitoring (not resource creation)
- **Features**: View billing, uptime, basic operations
- **Form Factor**: Limited for complex operations

### 2. Cloud IAM Fundamentals

#### What is Cloud IAM?
- **Definition**: Identity and Access Management
- **Core Concept**: "Who can do what on which resources"
- **Components**: Identities, Roles, Permissions, Resources
- **Scope**: Project-level by default (can extend to organization)

#### Identity Types (Who)

**Human Identities:**
1. **Google Account (Gmail)**: Basic personal accounts
   - Domain: gmail.com
   - Use: Individual learning, personal projects
   - Limitations: No organizational control

2. **Google Workspace**: Team collaboration suite
   - Services: Gmail, Drive, Meet, Docs, Sheets
   - Domain: Custom domain (yourcompany.com)
   - Use: Startups needing full Google ecosystem

3. **Cloud Identity**: Identity-only service
   - Basic identity management without full Workspace
   - Domain: Custom domain
   - Use: Large enterprises with existing identity providers

4. **Cloud Identity with Synchronization**:
   - Sync existing AD/Azure AD users
   - Tools: Google Cloud Directory Sync, Google Cloud Identity Sync
   - Single Sign-On (SSO) support

**Service Accounts (Non-Human):**
- **Purpose**: API/machine authentication
- **Email Format**: `<name>@<project-id>.iam.gserviceaccount.com`
- **Use**: VM-to-service, application-to-service authentication
- **Creation Methods**:
  - GUI: IAM & Admin → Service Accounts
  - CLI: `gcloud iam service-accounts create <name>`

#### Role Types

**Basic/Primitive Roles:**
- **Owner**: Full control (9,910+ permissions)
- **Editor**: Can modify resources but not grant access (877 permissions)  
- **Viewer**: Read-only access (limited permissions)
- **Recommendation**: Avoid in production - too broad

**Predefined Roles:**
- Service-specific, granular permissions
- Examples:
  - Storage Admin: Full GCS control
  - Compute Instance Admin: VM management
  - Kubernetes Engine Admin: GKE control
- **Recommendation**: Preferred approach for least privilege

**Custom Roles:**
- Combine/modify permissions as needed
- Maintenance burden: Customer responsibility
- Use cases: Business-specific requirements
- Creation: IAM → Roles → Create Role

#### Permissions Structure
- **Format**: `<service>.<resource>.<verb>`
- **Examples**:
  - `storage.buckets.create`
  - `compute.instances.start`
  - `bigquery.datasets.get`
- **Note**: Permissions granted indirectly via roles, never directly

### 3. IAM Best Practices

#### Principle of Least Privilege
- Grant minimum required permissions
- Prefer predefined roles over basic roles
- Regularly audit and revoke unnecessary access

#### Role Assignment Strategy
- Use groups for team access management
- Avoid individual user assignments
- Leverage service accounts appropriately

#### Common IAM Patterns
- **Dev/Prod Separation**: Different roles for different environments
- **Service Account Keys**: Avoid downloading keys; use workload identity
- **Permission Boundaries**: Use custom roles to limit scope

### 4. CLI Commands Reference

```bash
# Authentication
gcloud auth login
gcloud auth print-access-token

# Project Configuration
gcloud config set project PROJECT_ID
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a

# Resource Creation
gcloud storage buckets create gs://my-bucket
gcloud compute instances create my-vm

# Service Account Management
gcloud iam service-accounts create my-sa --description="My service account"
gcloud iam service-accounts list

# IAM Role Management
gcloud iam roles describe roles/storage.admin
gcloud iam roles list --filter="name:*storage*"
```

### 5. Quiz Answers & Explanations

#### Question 1: Cloud Shell Storage Location
**Question:** Need to install custom utility for weeks. Where to install?

**Answer:** `/home` (persistent storage)
- `/tmp` → Ephemeral (lost on session end)
- `/opt` → Optional components (not persistent)  
- `/usr` → System files (not recommended)
- `/home` → Persistent 5GB storage

#### Question 2: Setting Default Region
**Question:** Set Europe West 1 as default for all gcloud commands.

**Answer:** `gcloud config set compute/region europe-west1`
- A: Cloud Shell doesn't auto-set defaults
- B: Correct command for persistent config
- C: Zone setting (not region)
- D: VPN creation unnecessary for CLI defaults

### 6. Practical Implementation Steps

#### Creating Resources with Different Methods:
1. **Console**: Navigate → Create → Configure → Create
2. **CLI**: Authenticate → Set project → Run command
3. **Client Library**: Import SDK → Authenticate → Write code → Execute
4. **REST**: Get token → Form request → Call API
5. **Terraform**: Write config → Init → Plan → Apply
6. **Mobile**: Limited to monitoring/read operations

#### IAM Setup Process:
1. Identify identities (users/groups/service accounts)
2. Determine required permissions
3. Select appropriate role type (prefer predefined)
4. Grant role to identity at correct scope level
5. Test access and validate

### 7. Real-World Scenarios

#### Scenario 1: New Developer Onboarding
- Create Google Workspace account
- Add to developer group
- Assign Compute Instance Admin role (predefined)
- Grant access to development project

#### Scenario 2: Application Deployment
- Create service account for app
- Assign minimal required roles
- Use workload identity for secure access
-Rotate keys regularly

#### Scenario 3: Security Audit
- List all IAM bindings
- Identify basic role usage
- Convert to predefined roles
- Implement least privilege

### 8. Key Takeaways

1. **Multi-Method Approach**: Master all 6 interaction methods for flexibility
2. **IAM First**: Always consider security before resource creation
3. **Least Privilege**: Use granular predefined roles instead of broad basic roles
4. **Automation**: Prefer IaC (Terraform) for reproducible infrastructure
5. **Testing**: Validate permissions in non-production first

### 9. Resources for Further Learning

- Google Cloud IAM Documentation
- Terraform Registry (Google Provider)
- Cloud SDK Reference
- API Explorer: developers.google.com/apis-explorer
- Practice Labs: Google Cloud Skills Boost

### 10. Next Steps

- Practice creating resources via all 6 methods
- Set up IAM policies in a test project
- Experiment with Terraform configurations
- Explore role inheritance at organization/folder levels

---

*Study Guide Generated from Training Transcript: Day 02 - Cloud SDK, Rest API - Curl, Postman, Terraform, Quiz, Cloud IAM - Identity, Roles Concept*