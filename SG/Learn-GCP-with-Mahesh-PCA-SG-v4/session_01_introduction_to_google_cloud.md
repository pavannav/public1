# Session 1: Introduction to Google Cloud Platform

## Table of Contents

1. Introduction to Google Cloud Platform & Free Trial Account
2. Six Ways to Interact with Google Cloud
3. Summary

## Introduction to Google Cloud Platform & Free Trial Account

### Overview

Google Cloud Platform (GCP) is a suite of cloud computing services offered by Google. This section provides the foundational knowledge required to get started with GCP, including what GCP is, what services it offers, and crucially, how to activate a free trial account to explore these services hands-on at no cost.

### Key Concepts / Deep Dive

#### What is Google Cloud Platform?

GCP is a collection of cloud computing services that runs on the same infrastructure that Google uses internally for its end-user products, such as Google Search and YouTube. It provides a range of infrastructure services, platform as a service offerings, and API-based access to most major Google products.

The key components include:
- **Compute Engine**: Virtual machines in the cloud
- **Cloud Storage**: Scalable object storage
- **BigQuery**: Serverless data warehouse
- **Kubernetes Engine**: Managed container orchestration

#### Why Use Google Cloud?

Organizations choose GCP for several reasons:
- Trusted platform with established security and reliability
- Integration with other Google services
- Competitive pricing and cost optimization tools
- Advanced AI and machine learning capabilities
- Strong support for containerization and cloud-native applications

#### Free Trial Account Activation

GCP offers a free trial with $300 in credits for 90 days. This allows new users to explore the platform without upfront costs. The activation process involves:

1. **Account Creation**: Navigate to cloud.google.com and sign in with a Google account
2. **Billing Account Setup**: Configure billing information and payment method
3. **Verification Process**: Complete account verification through various methods
4. **Tax Information**: Provide tax information if required
5. **Credit Allocation**: Receive the trial credits

> [!IMPORTANT]
> The free trial billing account is separate from any existing GCP projects. Proper setup is required to access the credits.

#### Verification Methods

GCP uses multiple methods to verify new accounts:
- Credit card verification for billing
- Phone verification for identity confirmation
- Address verification through postal services

#### Tax Requirements

For certain countries and account types, tax information must be provided using IRS Form W-9 (for US entities) or W-8BEN (for foreign entities).

### Code/Config Blocks

The instructor demonstrated a simple API call to illustrate cloud concepts:

```bash
curl "https://www.random.org/integers/?num=10&min=1&max=6&col=1&base=10&format=plain&rnd=new"
```

This cURL command retrieves 10 random integers between 1 and 6, demonstrating external API interaction which parallels GCP service interactions.

## Six Ways to Interact with Google Cloud

### Overview

 While GCP can be accessed through various methods, the instructor demonstrates six primary approaches, each with different use cases and benefits. This comprehensive demonstration shows how to interact with GCP using different tools and interfaces, from point-and-click web interfaces to automated infrastructure-as-code deployments.

### Key Concepts / Deep Dive

The six methods are:

1. **Web Console Interface**: Browser-based graphical user interface for manual operations
2. **Cloud Shell**: Browser-based terminal with pre-installed tools
3. **gcloud CLI**: Command-line interface for automation and scripting
4. **REST API with cURL**: Programmatic access using HTTP requests
5. **GUI tools like Postman**: Visual interface for API testing and management
6. **Infrastructure as Code with Terraform**: Declarative resource management

Each method provides different levels of automation, speed, and use cases, allowing users to choose the most appropriate tool for their needs.

### Lab Demo

The following lab demonstrates all six methods, with hands-on examples using Google Cloud Storage as the target service since it's accessible across all tiers and provides immediate visual feedback.

#### Method 1: Web Console Interface

**Step 1: Navigate to Google Cloud Console**
- Open browser and go to console.cloud.google.com
- Sign in with Google account
- Select or create a project

**Step 2: Access Cloud Storage**
- Navigate to "Cloud Storage" from the left sidebar
- Click "Create Bucket"
- Configure bucket settings:
  - Bucket name: choose unique name (e.g., my-gcp-bucket-2024)
  - Storage class: Standard
  - Location: us-central1

**Step 3: Upload Test File**
- Open the created bucket
- Click "Upload Files" button
- Upload a test file (e.g., a text file)

**Step 4: Verify Upload**
- Check that the file appears in the bucket contents
- Note the object path and metadata

#### Method 2: Cloud Shell

**Step 1: Launch Cloud Shell**
- In Google Cloud Console, click the Cloud Shell icon in the top right toolbar
- Wait for the shell to initialize (approx 30 seconds)
- Verify terminal is ready with command prompt

**Step 2: Check gcloud Installation**
```bash
gcloud version
```
Expected output:
```
Google Cloud SDK 400.0.0
bq 2.0.72
core 2022.02.25
gsutil 5.6
```

**Step 3: Authenticate**
```bash
gcloud auth login
```
- Follow the auth URL provided
- Sign in to Google account when prompted
- Grant permissions as requested

**Step 4: Set Project**
```bash
gcloud config set project YOUR_PROJECT_ID
```
- Replace YOUR_PROJECT_ID with actual project ID
- Verify with: `gcloud config get-value project`

**Step 5: Create Cloud Storage Bucket**
```bash
gsutil mb -p YOUR_PROJECT_ID -l us-central1 gs://my-gcp-bucket-via-shell-2024/
```

**Step 6: Upload File via Cloud Shell**
```bash
echo "Hello from Cloud Shell" > hello.txt
gsutil cp hello.txt gs://my-gcp-bucket-via-shell-2024/
```

**Step 7: Verify Upload**
```bash
gsutil ls gs://my-gcp-bucket-via-shell-2024/
```
Expected output:
```
gs://my-gcp-bucket-via-shell-2024/hello.txt
```

#### Method 3: gcloud CLI tool

**Step 1: Install gcloud CLI locally**
- Download from https://cloud.google.com/sdk/docs/install
- Install for your operating system
- Initialize with: `gcloud init`

**Step 2: Authenticate locally**
```bash
gcloud auth login
```
- Browser opens for authentication
- Complete sign-in process

**Step 3: Set project**
```bash
gcloud config set project YOUR_PROJECT_ID
```

**Step 4: Create bucket with gcloud**
```bash
gcloud storage buckets create gs://my-gcp-cli-bucket-2024 --location=us-central1 --uniform-bucket-level-access
```

**Step 5: Upload file**
```bash
echo "Hello from local CLI" > local_hello.txt
gcloud storage cp local_hello.txt gs://my-gcp-cli-bucket-2024/
```

**Step 6: List contents**
```bash
gcloud storage ls gs://my-gcp-cli-bucket-2024/
```

#### Method 4: REST API with cURL

**Step 1: Get access token**
```bash
gcloud auth print-access-token
```
- Save the token for use in API calls

**Step 2: Create bucket with cURL**
```bash
curl -X POST -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name": "my-curl-bucket-2024", "location": "us-central1"}' \
     https://storage.googleapis.com/storage/v1/b
```

**Step 3: Upload object**
Create a test file first:
```bash
echo "Hello via cURL" > curl_test.txt
base64 curl_test.txt > curl_test.b64
```

Upload with cURL:
```bash
curl -X POST -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
     -H "Content-Type: text/plain" \
     --data-binary "@curl_test.txt" \
     https://storage.googleapis.com/upload/storage/v1/b/my-curl-bucket-2024/o?uploadType=media&name=curl_test.txt
```

**Step 4: List objects**
```bash
curl -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
     https://storage.googleapis.com/storage/v1/b/my-curl-bucket-2024/o
```

#### Method 5: GUI tools like Postman

**Step 1: Install Postman**
- Download from https://www.postman.com/downloads/
- Install the application

**Step 2: Configure Authentication**
- Create new request
- Set Authorization type to "OAuth 2.0"
- Get access token using gcloud command
- Configure token refresh if needed

**Step 3: Create Bucket Request**
- Method: POST
- URL: https://storage.googleapis.com/storage/v1/b
- Headers:
  - Authorization: Bearer [ACCESS_TOKEN]
  - Content-Type: application/json
- Body (raw JSON):
```json
{
  "name": "my-postman-bucket-2024",
  "location": "us-central1"
}
```

**Step 4: Upload File Request**
- Method: POST
- URL: https://storage.googleapis.com/upload/storage/v1/b/my-postman-bucket-2024/o?uploadType=media&name=postman_test.txt
- Headers:
  - Authorization: Bearer [ACCESS_TOKEN]
  - Content-Type: text/plain
- Body: "Hello from Postman"

**Step 5: List Objects**
- Method: GET
- URL: https://storage.googleapis.com/storage/v1/b/my-postman-bucket-2024/o
- Headers:
  - Authorization: Bearer [ACCESS_TOKEN]

#### Method 6: Infrastructure as Code with Terraform

**Step 1: Install Terraform**
- Download from https://www.terraform.io/downloads
- Verify installation: `terraform version`

**Step 2: Create Provider Configuration**
Create `main.tf` file:
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
  project = "YOUR_PROJECT_ID"
  region  = "us-central1"
}
```

**Step 3: Define Storage Bucket Resource**
```hcl
resource "google_storage_bucket" "terraform_bucket" {
  name          = "my-terraform-bucket-2024"
  location      = "us-central1"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "test_object" {
  name   = "terraform_test.txt"
  source = "terraform_test.txt"
  bucket = google_storage_bucket.terraform_bucket.name
}
```

**Step 4: Initialize Terraform**
```bash
terraform init
```

**Step 5: Plan the Deployment**
```bash
terraform plan
```

**Step 6: Apply the Configuration**
```bash
terraform apply
```
- Confirm with "yes" when prompted

**Step 7: Verify Creation**
```bash
terraform show
```

## Summary

### Key Takeaways

The fundamental concept of Google Cloud Platform revolves around its six primary interaction methods, each suited for different use cases and user preferences:

- **Web Console**: Intuitive GUI for beginners and ad-hoc operations
- **Cloud Shell**: Browser-based terminal with pre-installed tools
- **gcloud CLI**: Powerful command-line interface for automation
- **REST APIs with cURL**: Programmatic access for integrating with scripts
- **GUI tools like Postman**: Visual API testing and management
- **Terraform**: Infrastructure as Code for managing cloud resources declaratively

Each method offers the same functionality but with different levels of automation, learning curve, and integration capabilities.

### Quick Reference / Cheatsheet

#### Cloud Shell Operations
```bash
# Authenticate
gcloud auth login

# Set project
gcloud config set project YOUR_PROJECT_ID

# Create bucket
gsutil mb -p PROJECT_ID -l us-central1 gs://your-bucket/

# Upload file
gsutil cp file.txt gs://your-bucket/

# List contents
gsutil ls gs://your-bucket/
```

#### Local gcloud CLI
```bash
# Initialize
gcloud init

# Authenticate
gcloud auth login

# Create bucket
gcloud storage buckets create gs://your-bucket --location=us-central1

# Upload file
gcloud storage cp file.txt gs://your-bucket/

# List contents
gcloud storage ls gs://your-bucket/
```

#### REST API with cURL
```bash
# Get access token
ACCESS_TOKEN=$(gcloud auth print-access-token)

# Create bucket
curl -X POST -H "Authorization: Bearer $ACCESS_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name": "your-bucket", "location": "us-central1"}' \
     https://storage.googleapis.com/storage/v1/b

# Upload object
curl -X POST -H "Authorization: Bearer $ACCESS_TOKEN" \
     --data-binary "@file.txt" \
     https://storage.googleapis.com/upload/storage/v1/b/your-bucket/o?uploadType=media&name=file.txt
```

#### Terraform Basics
```hcl
# Provider configuration
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
}

# Resource definition
resource "google_storage_bucket" "example" {
  name     = "your-bucket-name"
  location = "us-central1"
}

# Commands
terraform init
terraform plan
terraform apply
terraform destroy
```

### Expert Insights

#### 🏭 **Real-world Application**
In professional cloud environments, the choice of interaction method depends on the use case:
- **Web Console**: Best for initial exploration, debugging, and ad-hoc resource management
- **Cloud Shell**: Ideal for tutorials, workshops, and environments without local tool installation
- **gcloud CLI**: Preferred for scripting, CI/CD pipelines, and operations that need automation
- **REST APIs**: Used by applications and services that need programmatic cloud access
- **GUI tools like Postman**: Essential for API development, testing, and documentation
- **Terraform**: Critical for infrastructure management, version control, and maintaining production environments

#### 🧭 **Expert Path**
To become proficient with GCP:
1. Start with the web console to understand services conceptually
2. Master Cloud Shell for guided learning
3. Learn gcloud CLI for scripting and automation
4. Understand REST APIs for integration work
5. Practice with Terraform for infrastructure management
6. Combine multiple approaches based on project requirements

#### 🪤 **Common Pitfalls**
- **Authentication confusion**: Different authentication methods for different tools
- **Resource naming conflicts**: Buckets and other resources must have globally unique names
- **Billing surprises**: Free trial credits can expire unexpectedly
- **API versioning**: Ensure you're using the correct API versions for your operations
- **Permission scopes**: Many operations require specific IAM permissions beyond basic login

#### 🔍 **Lesser-Known Facts**
- Cloud Shell sessions persist for 12 hours and can be restarted
- gcloud CLI supports tab completion and context-aware help
- REST APIs can be called from various programming languages using any HTTP client
- Terraform state management is crucial for collaboration and change tracking
- GCP offers client libraries in multiple languages to simplify API interactions

#### ⚖️ **Advantages & Disadvantages**
Each interaction method has trade-offs:

| Method | Speed | Learning Curve | Automation | Visual Feedback |
|--------|-------|----------------|------------|-----------------|
| Web Console | Fast | Low | Low | High |
| Cloud Shell | Medium | Low | Medium | Low |
| gcloud CLI | Medium | Medium | High | Low |
| REST API | Variable | High | High | Variable |
| Postman | Slow | Low | Low | High |
| Terraform | Slow | High | High | Low |

📝 Transcript Corrections: None