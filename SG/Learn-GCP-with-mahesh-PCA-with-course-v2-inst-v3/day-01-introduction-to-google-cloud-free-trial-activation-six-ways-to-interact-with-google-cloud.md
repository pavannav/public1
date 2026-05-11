<details open>
<summary><b>Session 01: Day 01 - Introduction to Google Cloud, Free Trial Activation, Six ways to interact with Google Cloud (KK-CS45-script-v2-Inst-v3)</b></summary>

# Day 01 - Introduction to Google Cloud, Free Trial Activation, Six ways to interact with Google Cloud

## Table of Contents

- [Session 01: Day 01 - Introduction to Google Cloud, Free Trial Activation, Six ways to interact with Google Cloud (KK-CS45-script-v2-Inst-v3)](#session-01-day-01---introduction-to-google-cloud-free-trial-activation-six-ways-to-interact-with-google-cloud-kk-cs45-script-v2-inst-v3)
  - [Table of Contents](#table-of-contents)
  - [Session Overview](#session-overview)
  - [Introduction to Google Cloud](#introduction-to-google-cloud)
    - [What is Google Cloud?](#what-is-google-cloud)
    - [Building a House Analogy](#building-a-house-analogy)
    - [Certifications Path](#certifications-path)
    - [Professional Cloud Architect Role](#professional-cloud-architect-role)
    - [Course and Learning Approach](#course-and-learning-approach)
    - [Prerequisites](#prerequisites)
  - [Google Cloud Free Trial Activation](#google-cloud-free-trial-activation)
    - [Free Trial Details](#free-trial-details)
    - [Activation Process](#activation-process)
    - [Troubleshooting](#troubleshooting)
    - [Project Creation](#project-creation)
  - [Key Concepts: Zones, Regions, and Scopes](#key-concepts-zones-regions-and-scopes)
    - [Zone](#zone)
    - [Region](#region)
    - [Multi-Region](#multi-region)
    - [Global](#global)
    - [Project Structure](#project-structure)
  - [Six Ways to Interact with Google Cloud](#six-ways-to-interact-with-google-cloud)
    - [Method 1: Google Cloud Console (GUI)](#method-1-google-cloud-console-gui)
      - [Creating Resources via GUI](#creating-resources-via-gui)
    - [Method 2: Cloud Shell](#method-2-cloud-shell)
    - [Method 3: Cloud SDK](#method-3-cloud-sdk)
    - [Method 4: REST APIs (Curl)](#method-4-rest-apis-curl)
    - [Method 5: REST APIs (Postman)](#method-5-rest-apis-postman)
    - [Method 6: Terraform (Infrastructure as Code)](#method-6-terraform-infrastructure-as-code)
  - [Summary](#summary)
    - [Key Takeaways](#key-takeaways)
    - [Quick Reference](#quick-reference)
    - [Expert Insight](#expert-insight)
      - [Real-World Application](#real-world-application)
      - [Expert Path](#expert-path)
      - [Common Pitfalls](#common-pitfalls)
      - [Lesser-Known Facts](#lesser-known-facts)
      - [Advantages and Disadvantages](#advantages-and-disadvantages)

## Session Overview

This inaugural session introduces the fundamentals of Google Cloud Platform (GCP), guides through free trial activation, and demonstrates six different methods for interacting with Google Cloud resources. The session emphasizes a customized learning approach with deep-dive demos, connecting technical concepts with business requirements, and preparing for the Professional Cloud Architect certification.

## Introduction to Google Cloud

### What is Google Cloud?

Google Cloud is a comprehensive suite of cloud computing services that runs on the same infrastructure powering Google's end-user products like YouTube, Gmail, and Google Drive. This shared infrastructure ensures high scalability, reliability, and performance.

**Key Features:**
- Compute, storage, networking, big data, AI/ML, and developer tools
- Robust security and compliance capabilities
- Global network with over 200+ regions and zones
- APIs for all services
- Free tier and pay-as-you-go pricing

### Building a House Analogy

```diff
! Professional Cloud Architect
+ Understands business requirements
+ Converts business needs to technical architecture
+ Plans and designs cloud solutions

! Similar to:
- Cloud Engineer (Implementation)
- Security Engineer (Secures foundation)
- DevOps Engineer (Operationalizes)
- App Developer (User Experience)
- Network Engineer (Connectivity)
```

### Certifications Path

```
Cloud Architect → Network Engineer → Security Engineer → Data Engineer/DevOps Engineer
                    ↓
                Cloud Engineer
```

### Professional Cloud Architect Role

The Professional Cloud Architect (PCA) enables organizations to leverage Google Cloud technologies by:
- Designing scalable, secure, robust cloud solutions
- Converting business requirements to technical architecture
- Implementing dynamic, cost-effective solutions
- Managing and optimizing cloud resources

**Day-to-Day Responsibilities:**
- System design and architecture
- Resource provisioning and management
- Cost optimization
- Performance monitoring
- Security implementation

### Course and Learning Approach

**Course Structure (300 hours):**
- Modules: Introduction, IAM, Compute Options (120+ hours), Storage, Networking (50+ hours), Big Data, AI, DevOps/Terraform, Migration, Exam Prep

**Learning Methodology:**
1. Attend sessions and watch demos
2. Recollect and practice implementations
3. Break systems to understand debugging
4. Add customizations to deepen understanding
5. Use free trial account for all practice

### Prerequisites

- Linux command basics
- Cloud computing fundamentals (IaaS/PaaS/SaaS)
- Programming skills (helpful but not mandatory)
- Browser access (Chrome preferred)

## Google Cloud Free Trial Activation

### Free Trial Details

- **Credits**: $300 or equivalent
- **Duration**: 90 days (extendable by creating new accounts)
- **What's Included**: All GCP services
- **Costs**: Transactions may appear for 1-2 days during activation (reversed)
- **Restrictions**: Use new Gmail ID, avoid office VPNs

### Activation Process

1. **Access URL**: https://cloud.google.com/free
2. **Sign In**: Use new Google account
3. **Payment Profile**: Debit/credit card details
4. **Verification**: 1-2 rupees/dollars charge (auto-refunded)

```bash
# Verification pattern
gcloud auth print-access-token  # Test authentication
```

### Troubleshooting

**Common Issues:**
- **Quota Exceeded**: Wait or create alternative account
- **Region Restrictions**: Use personal hotspot
- **Suspension**: Re-upload documentation if requested
- **Verification Failures**: Use different card if needed

### Project Creation

```diff
! Project Attributes (Immutable = Cannot Change)
+ Project Name: Custom name for identification
+ Project ID: Globally unique string (e.g., cloud-architect-concepts-123)
- Project Number: Auto-generated 11-12 digit number
- Billing Account: Free trial account
```

**Project Limits:**
- Default APIs enabled automatically
- Compute Engine requires API activation
- Service accounts created upon first use

## Key Concepts: Zones, Regions, and Scopes

### Zone

```diff
+ Physical building (data center)
+ Name pattern: [region]-[letter] (e.g., us-central1-a)
- Collection of buildings in same campus
```

### Region

```diff
+ Geographical area containing 3+ zones
+ Examples: Mumbai, Delhi, Singapore
- When disaster recovery needed
+ Use multiple regions for high availability
```

### Multi-Region

```diff
+ Cross-region deployment
+ Examples: Replicate data across US-West and US-East
- For data residency compliance
+ For disaster recovery across countries
```

### Global

```diff
+ Worldwide resources
+ Examples: Network, DNS, Cloud Load Balancing
- Not tied to specific region
+ Serves worldwide audience
```

### Project Structure

```diff
! Everything in Google Cloud belongs to a Project
+ Unique container for resources
+ Billing boundary
+ IAM boundary
+ API/Services boundary
- Resources cannot exist outside projects
```

**Regional Picker Tips:**
- Latency: Closest region to users
- Cost: Regions with lower pricing
- Compliance: Respects data residency laws
- Carbon Footprint: Green energy regions

## Six Ways to Interact with Google Cloud

### Method 1: Google Cloud Console (GUI)

**Access**: https://console.cloud.google.com

**Features:**
- Visual interface
- All products accessible
- API management
- Billing and cost monitoring
- Region picker tool

#### Creating Resources via GUI

**Google Cloud Storage Bucket:**
1. Navigate to Storage → Create bucket
2. Enter unique name
3. Default settings → Create
4. Upload files

**Virtual Machine:**
1. Compute Engine → VM instances
2. Create instance → Configure
3. Enable compute API (auto-triggered)
4. SSH access from console

### Method 2: Cloud Shell

**Features:**
- Built-in Linux environment
- 5GB persistent storage (`$HOME`)
- Pre-installed gcloud SDK
- Browser-based (no local installation)

```bash
# Cloud Shell capabilities
pwd                 # /home/username
df -h               # 5GB storage
sudo apt install -y [package]  # Install tools
gcloud --help       # Available commands
```

### Method 3: Cloud SDK

**Installation:**
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install google-cloud-sdk
gcloud init

# Windows/Mac/Linux available
```

**Usage:**
```bash
gcloud auth login
gcloud compute instances list
gcloud compute instances create my-vm \
  --zone=us-central1-a \
  --machine-type=e2-micro \
  --image=cos-cloud/cos-stable
```

### Method 4: REST APIs (Curl)

**Authentication:**
```bash
export PROJECT_ID="your-project-id"
export ACCESS_TOKEN=$(gcloud auth print-access-token)
```

**List VMs:**
```bash
curl -X GET \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  https://compute.googleapis.com/compute/v1/projects/$PROJECT_ID/aggregated/instances
```

**Create VM:**
```bash
curl -X POST \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "my-vm",
    "zone": "us-central1-a",
    "machineType": "zones/us-central1-a/machineTypes/e2-micro"
  }' \
  https://compute.googleapis.com/compute/v1/projects/$PROJECT_ID/zones/us-central1-a/instances
```

### Method 5: REST APIs (Postman)

**Setup:**
1. Install Postman (https://www.postman.com/)
2. Create new request
3. Method: GET/POST
4. Headers:
   - Authorization: Bearer [ACCESS_TOKEN]
   - Content-Type: application/json (if POST)
5. URL: API endpoints
6. Body: JSON data for POST requests

### Method 6: Terraform (Infrastructure as Code)

**Basic Setup:**

```hcl
# main.tf
provider "google" {
  project = "your-project-id"
  region  = "us-central1"
}

resource "google_compute_instance" "vm_instance" {
  name         = "cloud-architect-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    network = "default"
  }
}
```

**Commands:**
```bash
terraform init       # Initialize
terraform plan       # Review changes
terraform apply      # Create resources
terraform destroy    # Remove resources
```

## Summary

### Key Takeaways

```diff
+ Google Cloud runs on Google's proven infrastructure
+ Six ways to interact: GUI, Cloud Shell, SDK, REST APIs, Postman, Terraform
+ Projects are containers for resources with unique IDs
+ Free trial provides $300/90 days for learning
- Always check project creation quotas and billing
! Understand zones/regions for resource deployment
```

### Quick Reference

| Method | Tool | Installation | Use Case |
|--------|------|--------------|----------|
| GUI | Console | Browser | Visual management |
| Cloud Shell | Shell | Built-in | Quick CLI testing |
| Cloud SDK | gcloud | Download | Local CLI development |
| REST APIs | curl | Built-in | Script automation |
| REST APIs | postman | Download | API development |
| IaC | terraform | Download | Production deployments |

```bash
# Common gcloud commands
gcloud auth login              # Authenticate
gcloud config get-value project # Current project
gcloud compute instances list  # List VMs
gcloud storage buckets list    # List buckets

# URLs
Console: https://console.cloud.google.com
Cloud Shell: Click shell icon in console
Cloud SDK: https://cloud.google.com/sdk/docs/install
```

### Expert Insight

#### Real-World Application
In enterprise environments, Cloud Architects use Terraform for infrastructure provisioning as it enables version control, peer reviews, and disaster recovery. REST APIs are crucial for CI/CD integrations, while GUI serves for quick troubleshooting.

#### Expert Path
- Master Terraform workspaces for multi-environment deployments
- Implement automated API testing using Postman collections
- Create custom Cloud Shell scripts for repetitive tasks
- Understand Google Cloud's global network topology
- Focus on cost optimization from day one

#### Common Pitfalls
- **Billing surprises**: Always set budgets and alerts
- **API quota issues**: Monitor limits during development
- **Zone/Region mismatch**: Ensure resources are in compatible locations
- **Service account overuse**: Use service accounts appropriately
- **Security**: Never expose project IDs or access tokens

#### Lesser-Known Facts
- Google Cloud Console uses Merkel Merkle tree for API management efficiency
- Free trial cards may show temporary holds of $0.01 (always refunded)
- Project IDs containing "google" are reserved
- Cloud Shell VMs are recycled every 20 minutes of inactivity

#### Advantages and Disadvantages

**GUI Method:**
- ✅ Intuitive, visual feedback
- ✅ Perfect for first-time setup
- ❌ Time-consuming for repetitive tasks
- ❌ Not programmable

**Cloud Shell:**
- ✅ Zero installation required
- ✅ Persistent 5GB storage
- ❌ Timeouts after inactivity
- ❌ Single session per account

**Cloud SDK:**
- ✅ Full programmatic access
- ✅ Supports automation scripts
- ✅ Works behind corporate proxies
- ❌ Installation and configuration required

**REST APIs:**
- ✅ Most flexible and powerful
- ✅ Integrates with any language/tools
- ❌ Steep learning curve
- ❌ Authentication management needed

**Postman:**
- ✅ GUI for API testing
- ✅ Collections for repeatability
- ✅ Team sharing capabilities
- ❌ Not suitable for production automation

**Terraform:**
- ✅ Infrastructure as Code
- ✅ Version controllable
- ✅ Production-ready
- ❌ State management complexity
- ❌ HCL syntax learning required

</details>