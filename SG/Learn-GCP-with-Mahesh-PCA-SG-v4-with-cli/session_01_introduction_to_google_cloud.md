# Session 1: Introduction to Google Cloud

## Table of Contents

1. [Introduction](#introduction)
2. [What is Google Cloud?](#what-is-google-cloud)
3. [Free Trial Activation](#free-trial-activation)
4. [Six Ways to Interact with Google Cloud](#six-ways-to-interact-with-google-cloud)
   - [Method 1: Graphical User Interface (GUI)](#method-1-graphical-user-interface-gui)
   - [Method 2: Cloud Shell](#method-2-cloud-shell)
   - [Method 3: Cloud SDK](#method-3-cloud-sdk)
   - [Method 4: REST API with Curl](#method-4-rest-api-with-curl)
   - [Method 5: REST API with Postman](#method-5-rest-api-with-postman)
   - [Method 6: Terraform](#method-6-terraform)
5. [Conclusion](#conclusion)

---

## Introduction

Welcome to the customized Professional Cloud Architect training led by Mahesh Kumar. This session provides an overview of Google Cloud, the course structure, and multiple ways to interact with Google Cloud resources.

### Overview

This introductory session sets the stage for the comprehensive 300-hour training program. Key topics include:

- Course customization and benefits
- Google Cloud product family
- Free trial account activation
- Six different interaction methods with Google Cloud
- Hands-on demonstrations

### Key Concepts

**Customized Training Approach:**
- Focus on deep-dive demos rather than slide-heavy lectures
- Real-world implementation experience sharing
- Deliberate breakage and debugging to simulate production scenarios
- Interview question coverage
- Project thinking exercises
- Post-training support including resume assistance

**Course Benefits:**
- Lifetime access to shared resources (PDF slides, code snippets, cheat sheets, implementation guides)
- Private YouTube playlist for recordings
- Technical discussion channels
- 10-minute breaks every hour during 4-hour sessions

---

## What is Google Cloud?

Google Cloud is the modern cloud ecosystem where major Google services like YouTube, Google Drive, and Maps run. It offers a comprehensive suite of products for computing, storage, networking, AI, and more.

### Key Concepts

**Product Categories:**
- **Compute Services:** Virtual machines, containers, serverless functions
- **Storage:** Object storage, file systems, databases
- **Networking:** Global infrastructure, load balancing, CDN
- **AI/ML:** Pre-trained APIs, AutoML, Vertex AI
- **Data & Analytics:** BigQuery, Pub/Sub, Dataflow
- **DevOps:** Cloud Build, Cloud Deploy, monitoring

**Certification Overview:**
The Professional Cloud Architect certification is the flagship credential, requiring deep understanding of Google Cloud's service ecosystem. This course prepares you for certification success through comprehensive coverage and hands-on practice.

### Deep Dive

**Architectural Design Thinking:**
Cloud architects translate business requirements into technical solutions. Common requirements include:
- Scalability (handling thousands of requests per second)
- Security compliance (HIPAA, SOC2, etc.)
- Data residency requirements
- Cost optimization

**Career Impact:**
- Post-certification opportunities: Cloud migration, digital transformation
- Typical salary progression: Mid to senior cloud architect roles
- Freelance consulting potential across DevOps, security, and data engineering

---

## Free Trial Activation

Google Cloud offers a $300 credit for 90 days to explore services hands-on.

### Overview

Free tier activation provides access to all Google Cloud services with credit limits. Important considerations include quota management and subscription cancellation.

### Key Concepts

**Activation Steps:**
1. Create Gmail account for Google Cloud access
2. Navigate to console.cloud.google.com
3. Select country and agree to terms
4. Verify billing information
5. Claim promotional credits

**Billing Account Types:**
- **Self-pay:** Personal liability for charges
- **Corporate:** Company subsidy for training purposes

### Code/Config Blocks

**Console Navigation:**
```bash
# Primary console URL
console.cloud.google.com

# Regional endpoints available
us-central1-console.cloud.google.com
europe-west1-console.cloud.google.com
asia-southeast1-console.cloud.google.com
```

### Lab Demo

**Free Trial Activation:**
1. Visit console.cloud.google.com
2. Create/select billing account
3. Accept $300 credit offer
4. Set billing alert threshold at $10
5. Navigate billing section to view current balance and quotas

> [!TIP]
> Always set billing alerts to prevent unexpected charges during demos.
> Cancel free trial before expiration to avoid auto-conversion to paid account.

---

## Six Ways to Interact with Google Cloud

Google Cloud provides six primary methods for resource management, offering flexibility for different use cases.

### Overview

Each interaction method has specific advantages, disadvantages, and use cases. The methods range from GUI-based approaches to infrastructure-as-code solutions.

### Deep Dive

**Interaction Philosophy:**
- Plan A: Graphical interface (user-friendly, visual)
- Plan B: Cloud Shell (command-line, pre-authenticated)
- Plan C: Local Cloud SDK (command-line, persistent)

### Method 1: Graphical User Interface (GUI)

**Overview:**
Web console at console.cloud.google.com for point-and-click resource management.

**Key Concepts:**
- Browser-based interface
- Visual project management
- Real-time monitoring dashboards

**Advantages:**
- Intuitive navigation
- Immediate visual feedback
- No setup required

**Disadvantages:**
- Limited productivity for repetitive tasks
- Not scriptable for automation
- Potential browser compatibility issues

### Method 2: Cloud Shell

**Overview:**
Browser-based Ubuntu environment with pre-installed gcloud SDK.

**Key Concepts:**
- Docker container instance
- Pre-authenticated with project access
- 5GB persistent disk
- Terminates after 20 minutes idle

**Code/Config Blocks:**
```bash
# Example Cloud Shell commands
gcloud compute instances list
gcloud config list
```

**Lab Demo:**
1. Open Cloud Console
2. Click Cloud Shell icon
3. Run `gcloud --version` to verify installation
4. List compute instances: `gcloud compute instances list`
5. Set project: `gcloud config set project [PROJECT_ID]`

**Advantages:**
- No local installation required
- Pre-authenticated
- Includes common developer tools
- Persistent $HOME directory

**Disadvantages:**
- Terminates after 20 minutes idle
- Data deletion after 120 days inactive
- Limited to 5GB storage

### Method 3: Cloud SDK

**Overview:**
Locally installed command-line tools for Google Cloud resource management.

**Key Concepts:**
- Cross-platform installation (Windows, macOS, Linux)
- Authenticate once, use indefinitely
- Full access to all gcloud commands
- Supports scripts and automation

**Code/Config Blocks:**
```bash
# Windows installation
# Download and run google-cloud-sdk installer

# Linux/Mac installation
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud --version

# Authentication
gcloud auth login
gcloud config set project [PROJECT_ID]
gcloud compute instances create test-vm \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --machine-type=f1-micro \
  --zone=us-central1-a
```

**Lab Demo:**
1. Download Cloud SDK installer for your platform
2. Install with default settings
3. Run `gcloud auth login` and follow browser authentication
4. Set project: `gcloud config set project [PROJECT_ID]`
5. Create test VM and delete it
6. Verify with `gcloud config list`

**Advantages:**
- Local persistence across sessions
- Full automation capabilities
- No time limits
- Larger storage than Cloud Shell

**Disadvantages:**
- Manual installation process
- Doesn't include full developer toolchains
- Storage limited by local hardware

### Method 4: REST API with Curl

**Overview:**
Direct HTTP API calls using curl for programmatic resource management.

**Key Concepts:**
- Raw HTTP requests to Google Cloud APIs
- Authentication via OAuth2 tokens
- JSON request/response format

**Code/Config Blocks:**
```bash
# Enable Compute Engine API
curl -X POST https://serviceusage.googleapis.com/v1/projects/[PROJECT_ID]/services/compute.googleapis.com:enable \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  --data '{}'

# List Compute Instances API call
curl -X GET https://compute.googleapis.com/compute/v1/projects/[PROJECT_ID]/zones/us-central1-a/instances \
  -H "Authorization: Bearer $(gcloud auth print-access-token)"
```

**Lab Demo:**
1. Enable Compute Engine API in console
2. Get access token: `gcloud auth print-access-token`
3. Make curl request to list instances
4. Parse JSON response with jq

**Advantages:**
- Direct API interaction
- Platform-independent
- Suitable for scripting

**Disadvantages:**
- Complex authentication handling
- Manual JSON construction/parsing
- No built-in error handling

### Method 5: REST API with Postman

**Overview:**
Graphical API testing tool for Google Cloud service interactions.

**Key Concepts:**
- GUI for API request construction
- Saved collections for repeatable calls
- Automatic token management
- Request/response visualization

**Lab Demo:**
1. Install Postman from postman.com
2. Create new collection "GCP APIs"
3. Set up Google OAuth2 authentication
4. Import GCP API documentation from developer.google.com
5. Make test API calls to Compute Engine APIs

**Advantages:**
- Visual request building
- Response inspection
- Environment management
- Team collaboration features

**Disadvantages:**
- Desktop application requirement
- Learning curve for OAuth setup
- Less suited for production automation

### Method 6: Terraform

**Overview:**
Infrastructure-as-code tool for declarative cloud resource management.

**Key Concepts:**
- HCL (HashiCorp Configuration Language) for resource definition
- Plan-and-apply workflow
- Multi-cloud support
- State management for resource tracking

**Code/Config Blocks:**
```hcl
# main.tf
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}

# Apply commands
terraform init
terraform plan
terraform apply -auto-approve
terraform destroy
```

**Lab Demo:**
1. Install Terraform from terraform.io
2. Initialize provider: `terraform init`
3. Write basic VM resource configuration
4. Run `terraform plan` to see changes
5. Apply: `terraform apply`
6. Verify VM creation in console
7. Destroy resources: `terraform destroy`

**Advantages:**
- Declarative infrastructure definition
- Version-controlled infrastructure
- Drift detection and correction
- Broad ecosystem support

**Disadvantages:**
- Learning HCL syntax
- State file management
- Provider-specific knowledge required

---

## Conclusion

This session established the foundation for comprehensive Google Cloud training with practical approaches to resource interaction.

### Key Takeaways

```diff
+ Google Cloud is an enterprise-grade platform used by Google's own services
+ Six interaction methods provide flexibility for different use cases
+ Free trial enables hands-on learning without immediate costs
+ GUI suits beginners, infrastructure-as-code (Terraform) suits automation
+ Cloud Shell offers instant command-line access in browser
+ Cloud SDK provides local development persistence
```

### Quick Reference

**Console URLs:**
- Global: console.cloud.google.com
- Regional: [region]-console.cloud.google.com

**CLI Authentication:**
```bash
gcloud auth login
gcloud config set project [PROJECT_ID]
```

**Terraform Workflow:**
```bash
terraform init
terraform plan
terraform apply
terraform destroy
```

### Expert Insights

🏭 **Real-world Application**
Multiple interaction methods allow cloud architects to choose appropriate tools for specific tasks - GUI for exploration, infrastructure-as-code for production deployments.

🧭 **Expert Path**
Master Cloud SDK and Terraform for automation capabilities. Learn REST APIs for custom tooling development.

🪤 **Common Pitfalls**
- Exceeding free trial limits without monitoring
- Not setting up proper authentication across methods
- Over-reliance on GUI due to lack of CLI comfort

🔍 **Lesser-Known Facts**
Cloud Shell uses Docker containers for environment isolation. The 120-day auto-deletion prevents data persistence costs.

⚖️ **Advantages & Disadvantages**

| Method | Advantages | Disadvantages |
|--------|------------|---------------|
| GUI | User-friendly, visual | Not automatable |
| Cloud Shell | Pre-configured, instant | Limited persistence |
| Cloud SDK | Full automation, persistence | Local setup required |
| Curl | Direct, scriptable | Complex manual work |
| Postman | Visual API testing | GUI-only tool |
| Terraform | Declarative, multi-cloud | Learning curve for HCL |

---

📝 Transcript Corrections: None