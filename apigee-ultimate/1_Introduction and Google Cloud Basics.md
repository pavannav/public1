# Section 1: Introduction and Google Cloud Basics

## 1.1 Course Introduction

### Course Overview
**Google Cloud Apigee Masterclass** is a comprehensive course covering Apigee X, one of the most modern and popular API management solutions hosted on Google Cloud Platform (GCP).

### 📝 Course Structure
- **Hands-on demos**: Answer "what" and "how"
- **Slide presentations**: Clarify "why" and summarize key takeaways
- **Progressive learning**: Start from basics → move to advanced implementations

### 🎯 Learning Objectives
The course follows a **T-shaped learning approach**:

```
    ────────────────────────────────────
         GCP Services & Concepts
         (Breadth - Horizontal Bar)
    ────────────────┬──────────────────
                    │
    Apigee & API    │  (Depth - Vertical Bar)
    Ecosystem       │
    In-depth        │
                    │
```

**Horizontal (Breadth)**: Explore dozen+ GCP services and common concepts

**Vertical (Depth)**: Deep dive into Apigee and overall API ecosystem
- GCP Networking
- GCP Monitoring
- OAuth2, SAML flows
- Third-party IDPs

### ✅ Best Practices for Learning
- Keep it active learning
- Take notes
- Rewatch videos if needed
- Take your time and have fun

---

## 1.2 Navigate the Course Your Way

### Course Structure Overview

```
Section 1-2 (Optional)     →  GCP & API Basics
    ↓
Section 3-6 (Core)         →  Core Concepts & Hands-on
    ↓
Section 7+ (Advanced)      →  Advanced Use Cases
```

### 📚 Section Breakdown

**Section 1**: GCP Basics (Optional for experienced users)
**Section 2**: API Fundamentals (Optional for API developers)
**Section 3-6**: Core Apigee concepts, configurations, hands-on implementations
**Section 7+**: Advanced features (Networking, Local Development, Developer Portal, SSO, Custom Domains)

> [!IMPORTANT]
> Each section builds upon previous sections. Even if you have prior experience, scan through earlier sections to avoid missing context.

### 🎓 Learning Paths

**For Beginners**: 
- ✅ Don't skip anything
- ✅ Take course from start to finish
- ✅ Learn by doing, not just watching

**For Experienced GCP/API Developers**:
- Scan Sections 1-2
- Focus on Sections 3+
- Note: May miss context from previous sections

**For Existing Apigee Developers**:
- Jump to specific advanced sections
- Be aware of missing context from earlier demos

> [!NOTE]
> Section 2 introduces Google Maps API, which is used for API demos from Section 3 onwards.

---

## 1.3 Google Cloud Essentials: Regions and Zones

### Why Cloud?

**Traditional Infrastructure Challenges**:
```diff
- Procure own servers, storage, network devices
- Plan for peak load (e.g., 10 servers for holiday season)
- Infrastructure underutilized rest of the year
- Maintain dedicated support team
- High capital expenditure (CapEx)
```

**Cloud Benefits**:
```diff
+ On-demand resource provisioning
+ Economy of scale
+ Scale up during peak, scale down during off-peak
+ Pay only for what you use
+ No need to run own data centers
+ Shift from CapEx to operational expenditure (OpEx)
```

### 🌍 GCP Regions

**Region**: Geographical area where cloud infrastructure resides

**Examples**:
- `us-central1` → Iowa, USA
- `asia-south1` → Mumbai, India

```
                    Global Coverage
                          │
        ┌─────────────────┼─────────────────┐
        ↓                 ↓                  ↓
   us-central1      asia-south1        europe-west1
   (Iowa, USA)      (Mumbai, India)    (Belgium)
```

> [!NOTE]
> GCP has **42 regions** spread across **200+ countries and territories** with points of presence worldwide.

### 🏢 Zones

**Zone**: Groups of one or more clusters of data centers within a region

**Example - us-central1 zones**:
- `us-central1-a`
- `us-central1-b`
- `us-central1-c`
- `us-central1-f`

```
Region: us-central1
    │
    ├── Zone A (Data Center Cluster 1)
    ├── Zone B (Data Center Cluster 2)
    ├── Zone C (Data Center Cluster 3)
    └── Zone F (Data Center Cluster 4)
```

### 💡 Zone Characteristics

✅ **Independent and redundant**: Power, cooling, networking
✅ **Close enough**: Low latency connections between zones
✅ **Far enough**: Reduce likelihood of simultaneous outages (fire, weather, local issues)

### 🔄 High Availability Strategy

Deploy applications across **multiple regions** or **multiple zones**:

```
Application Deployment
    │
    ├── us-central1 (Primary)
    │       ├── Zone A
    │       └── Zone B
    │
    └── asia-south1 (Secondary)
            ├── Zone A
            └── Zone B
```

> [!IMPORTANT]
> If regional outage occurs in us-central1, asia-south1 can still serve traffic → Zero downtime

### 📖 Resources
- GCP Regions Documentation: Shows all regions, network coverage, product availability by location
- Product Availability: Check which GCP services are available in specific regions

---

## 1.4 GCP Resource Hierarchy

### Hierarchy Structure

```
                    Organization
                    (Root Node)
                         │
        ┌────────────────┼────────────────┐
        ↓                ↓                 ↓
    Folder          Folder            Folder
  (Department 1)  (Department 2)  (Shared Infra)
        │                │
    ┌───┴───┐        ┌───┴───┐
    ↓       ↓        ↓       ↓
  Folder  Folder   Folder  Folder
  (Team)  (Team)   (Team)  (Team)
    │       │        │       │
    ↓       ↓        ↓       ↓
  Project Project  Project Project
    │       │        │       │
    ↓       ↓        ↓       ↓
Resources Resources Resources Resources
(VMs, Functions, Apigee)
```

### 📦 Hierarchy Levels (Bottom to Top)

#### 1. **Resources** (Bottom Level)
- Instances of Google Cloud services
- Examples: Virtual Machines, Cloud Functions, Apigee
- Always created within a project

#### 2. **Projects**
- Basis for creating and using GCP resources
- **Cannot be nested** within each other
- Best practice: **One project per app per environment**

```
Application: E-commerce App
    │
    ├── Project: ecommerce-dev
    ├── Project: ecommerce-test
    └── Project: ecommerce-prod
```

#### 3. **Folders**
- Additional grouping mechanism
- **Can be nested** at multi-level
- Organize by departments, teams, products

```
Organization
    │
    ├── Folder: Engineering
    │       ├── Folder: Team A
    │       │       ├── Folder: Product 1
    │       │       └── Folder: Product 2
    │       └── Folder: Team B
    │
    └── Folder: Operations
```

#### 4. **Organization** (Top Level)
- Root node of hierarchy
- Associated with company domain
- Linked to Google Workspace or Cloud Identity account

### 🔐 Access Control Benefits

**Example Access Control**:
```
Development Teams  →  Access to non-prod projects only
Operations Team    →  Access to production projects
```

**Policy Inheritance**:
- Policies applied at organization/folder level
- Automatically inherited by levels below

### ⚠ Free Trial Limitations

> [!WARNING]
> When using personal Gmail ID for free trial:
> - ❌ Organization node NOT available
> - ❌ Folders NOT available
> - ✅ Projects available
> - ✅ Resources available
> 
> Reason: No Google Workspace or Cloud Identity account

### 💳 Billing Account

**Billing Account** is NOT part of resource hierarchy, but is a mechanism for GCP to bill usage.

```
Billing Account
(Payment Profile)
    │
    ├── Project 1 (Usage tracked)
    ├── Project 2 (Usage tracked)
    └── Project 3 (Usage tracked)
         ↓
    Monthly Invoice
```

**Free Trial**:
- Creates billing account with payment profile
- All usage from projects tracked in billing account
- Equivalent to $300 in local currency

**Large Companies**:
- Typically use multiple billing accounts as per needs

---

## 1.5 Cost Optimization

### 💰 Cost Optimization Strategy

Managing cost is crucial to avoid unexpected charges or surprise invoices.

#### Three-Pillar Approach:

```
Cost Optimization
    │
    ├── 1. GCP Free Trial
    ├── 2. Apigee Eval Instance
    └── 3. Good Cloud Practices
```

### 1️⃣ GCP Free Trial

**Benefits**:
- $300 worth of credits
- Valid for 3 months
- Requires Google account (personal Gmail ID works)

> [!IMPORTANT]
> Time your GCP signup well! Credits expire after 3 months, but you can upgrade to pay-as-you-go after expiry.

**Course Completion**:
- ✅ Can complete this course within 3 months
- ✅ Can complete under $300 credit

### 2️⃣ Apigee Eval Instance

**Characteristics**:
- Completely FREE
- Expires in 60 days
- Cannot be converted to pay-as-you-go
- Can create one eval instance per GCP project

**Workaround for Expiry**:
```
Eval expires after 60 days
    ↓
Create new GCP project
    ↓
Create new Apigee eval instance
```

**Associated Costs**:
- Apigee eval itself: **$0**
- Non-Apigee resources created during provisioning:
  - Load balancer
  - Virtual machines
  - Public IP addresses
  - **Estimated**: ~$200 from free trial credits for entire course

### 3️⃣ Good Cloud Practices

✅ **Set up budgets and alerts** (as soon as you sign up)
✅ **Regularly monitor billing reports**
✅ **Monitor email alerts**
✅ **Organize GCP projects** to optimize cost

**Example - Project Organization**:
```
Later in course: Apigee Pay-as-you-go demo
    ↓
Create in completely new project
    ↓
Complete demo
    ↓
Destroy entire project
```

### 🧮 GCP Pricing Calculator

**Purpose**: Estimate costs before using services

**How to Use**:
1. Go to GCP Pricing Calculator
2. Click "Add to estimate"
3. Choose service (e.g., Networking, Apigee)
4. Configure parameters
5. View total monthly cost

**Example - Cloud Load Balancing**:
```
Service: Cloud Load Balancing
Scope: Global
Forwarding Rules: 1
Data: 5 GB inbound/outbound
    ↓
Cost: ~$20/month
```

**Example - Apigee Pay-as-you-go**:
```
Environment Type: Base
Regions: 1
API Calls: 5,000
    ↓
Cost: ~$365/month (~$0.50/hour)
```

### 💡 Pricing Calculator Benefits

1. **Understand costs** for different services
2. **Understand configurations** available for a service
   - Example: Apigee has 3 environment types
   - Cost varies by: proxy deployments, regions, environments

> [!NOTE]
> Use pricing calculator + official documentation to understand billing implications. Make it a habit!

---

## 1.6 GCP Free Trial Signup

### 🚀 Signup Process

#### Step 1: Navigate to Cloud Console
```
Browser → console.cloud.google.com
    ↓
Redirected to Google Account login
```

#### Step 2: Google Account
- **Have Gmail ID**: Provide email and click Next
- **Don't have Google account**: Click "Create account"
  - Can use existing email (e.g., Outlook)
  - Can create new Gmail ID

> [!WARNING]
> For full control over GCP account, use **personal email address**. Work email may come under organization policy.

#### Step 3: Optional Setup
- **Home address**: Optional, can skip
- **Profile picture**: Optional, can skip
- **Re-authentication**: May ask to re-authenticate

#### Step 4: Welcome Screen
- Agree to Terms of Service
- Choose your country
- Click "Agree and continue"

> [!NOTE]
> At this point, you're logged into Cloud Console but haven't started free trial yet. No projects exist.

#### Step 5: Start Free Trial
Click "Start Free Trial" button

**Step 5a - Account Activation (Step 1 of 2)**:
- Choose your country
- Agree to free trial terms of service

**Step 5b - Verify Identity (Step 2 of 2)**:
- Create payments profile
  - Click "+" button
  - Choose "Individual" for payment profile type
  - Enter address and city
  - Create profile
- Add payment method
  - Click "+" button
  - Choose payment method (varies by country)
  - Click "Start Free"

**Step 5c - Complete Payment Method**:
- Fill credit/debit card information, OR
- Login to online banking, OR
- Scan QR code (depending on payment method)

#### Step 6: Welcome to Google Cloud
- Prompt welcoming you to Google Cloud
- Background shows Cloud Console with "My First Project"

#### Step 7: Getting Started (Optional)
- "How would you like to get started?": Select "Learn to use Google Cloud"
- "What do you want to do?": Select "I'm not sure"
- Add comment: e.g., "Get familiar with Apigee or other GCP services"
- Click "Done"

### ✅ Signup Success Indicators

1. Can see Google Cloud Console
2. Default project visible ("My First Project")
3. Free trial credits visible on home page
   - Click "Google Cloud" button → Home page
   - Welcome message + remaining credit (~$300 in local currency)

---

## 1.7 Set up Budget/Alerts

### 🧭 Navigating Cloud Console

#### Service Menu
- **Top left corner**: List of all GCP services
  - Cloud Run, VPC Network, Compute Engine, SQL, etc.
- **Pin services**: Click pin icon for commonly used services
  - Pinned services appear at top of menu

**Example - Pin Apigee**:
```
View all products → Search "Apigee" → Click pin icon
    ↓
Apigee appears in pinned products list
```

#### Search Bar (Recommended)
- Faster than navigating menus
- Search for any service (e.g., "Compute Engine", "Apigee", "Billing")

### 💳 Billing Account Setup

#### Navigate to Billing
```
Search "billing" → Click "Billing accounts in product page"
```

#### Rename Billing Account
```
Scroll to bottom → Account Management
    ↓
Rename → e.g., "Apigee Course Billing"
```

#### View Linked Projects
- All projects linked to single billing account
- Default project: "My First Project" with unique project ID

### 📊 Billing Reports

#### Navigate to Reports
```
Billing → Reports
```

#### Filters Available

**Group By**:
- Service
- Project
- SKU (exact service causing cost)
- No grouping (total cost)

**Example - Group by SKU**:
```
Forwarding Rule: $X
Cloud Armor Regional Policy: $Y
Networking: $Z
```

**Example - Group by Service**:
```
Networking Services: $A
Compute Engine: $B
Apigee: $C
```

#### Cost Analysis Tips

✅ **Uncheck "Savings"**: See actual costs without free trial credits applied
✅ **Filter by project**: View costs for specific projects
✅ **Time period selection**: Drill down into cost spikes

**Daily Cost Example**:
```
Two Apigee instances running
    ↓
Daily cost: ~₹175 (~$2/day)
    ↓
Per instance: ~$1-1.5/day (including networking charges)
```

#### Save Custom Reports
```
Click "Save as new" → Name report → Save
    ↓
View all reports → See saved custom reports
```

### 💰 View Credits

```
Billing → Credits
    ↓
Status: Active
Total Value: $300 (in local currency)
Remaining Credits: $XXX
```

### 💳 Payment Settings

```
Billing → Payments tab
    ↓
- Payment settings
- Payment method
- Transactions
- Documents
```

### 🚨 Set Up Budgets and Alerts

#### Create Budget

```
Cost Management → Budgets & alerts → Create Budget
```

**Step 1 - Budget Name**:
```
Name: "Monthly Budget INR 5000" (or "$50" for USD)
```

**Step 2 - Budget Scope**:
- ✅ All projects
- ✅ All services
- ❌ Uncheck "Savings" (to see actual charges, not credits)

**Step 3 - Budget Amount**:
```
Amount: 5000 INR (or $50 USD)
    ↓
Red line shows maximum threshold on graph
```

**Step 4 - Alert Rules**:

```diff
! Alert Threshold 1: Actual amount reaches 50% of budget
! Alert Threshold 2: Actual amount reaches 80% of budget
! Alert Threshold 3: Forecasted amount reaches 100% of budget
! Alert Threshold 4: Actual amount reaches 95% of budget
```

**Alert Configuration**:
- Trigger Type: Actual or Forecasted
- Percentage: 50%, 80%, 95%, 100%

**Step 5 - Notifications**:

✅ **Email alerts to billing admins and users**
- You are billing admin (created free trial with personal email)

✅ **Additional email channels** (optional):
```
Link monitoring email notification channels
    ↓
Select project (e.g., "My First Project")
    ↓
Create new notification channel
    ↓
Type: Email
Email: your-alternate-email@example.com
Display Name: "My Alternate Email"
    ↓
Save
```

**Step 6 - Finish**:
```
Click "Finish" → Budget created
```

### ⚠ Important Budget Limitation

> [!WARNING]
> Setting a budget does NOT cap resource or API consumption!
> 
> Billing will NOT stop when budget threshold is crossed. You must manually:
> 1. Check what's causing cost increase
> 2. Shut down unnecessary services

**Alert Flow**:
```
Threshold crossed
    ↓
Email alert sent to:
- Billing admin email
- Alternate email(s)
    ↓
Manual action required to stop services
```

---

## 1.8 Managing GCP Projects

### 📁 Default Project

**Free trial** comes with default project:
- **Project Name**: "My First Project" (same for all accounts)
- **Project ID**: Globally unique (different for everyone)

```
Project: My First Project
    ↓
Project ID: my-first-project-123456 (example - yours will differ)
```

### ➕ Create New Project

#### Method 1: From Project Picker
```
Click project dropdown → "New Project"
```

#### Method 2: Step-by-step
```
1. Click project name/ID at top
2. Click "New Project"
3. Enter project name: e.g., "temp-demo"
4. Google auto-generates similar project ID
5. Click "Edit" to customize project ID (optional)
6. Organization: None (for free trial accounts)
7. Click "Create"
```

**Example**:
```
Project Name: temp-demo
    ↓
Auto-generated Project ID: temp-demo-123456
    ↓
Project created
```

### 🔄 Switch Between Projects

```
Click project picker → Recent projects or All projects
    ↓
Click desired project
    ↓
Context switches to that project
```

> [!IMPORTANT]
> Current context determines where resources are created. If you create VM, Apigee, etc., they're created in the currently selected project.

### 🔗 Link Project to Billing Account

**Automatic Linking**:
- New projects typically auto-link to default billing account

**Manual Linking** (if needed):
```
Go to project → Billing
    ↓
Link a billing account
    ↓
Choose billing account → Set account
```

> [!NOTE]
> If you hit quota limit for projects linked to billing account, you must increase quota before linking more projects.

### 🗑 Delete Project

#### Best Practice: Disable Billing First

```
Step 1: Disable Billing
    ↓
Billing → Account Management
    ↓
Select project → Disable billing → Confirm
```

```
Step 2: Delete Project
    ↓
Manage Resources
    ↓
Select project → Delete
    ↓
Enter project ID to confirm → Shut down
```

**Deletion Timeline**:
```
Project shut down
    ↓
Soft delete (30-day grace period)
    ↓
After 30 days: Permanent deletion
```

### ♻ Restore Deleted Project

```
Manage Resources → Resources pending deletion
    ↓
Select project ID → Restore
```

> [!NOTE]
> Projects can be restored within 30 days of deletion.

---

## 1.9 API Enablement in Google Cloud

### 🔌 Ways to Interact with GCP

```
                GCP Resources
                      │
        ┌─────────────┼─────────────┐
        ↓             ↓             ↓
    Console         CLI        Client
  (Browser UI)   (gcloud)    Libraries
                      │             │
                      └──────┬──────┘
                             ↓
                    Infrastructure as Code
                        (Terraform)
                             │
                             ↓
                    Underlying GCP APIs
```

**All methods ultimately use underlying GCP APIs**:
- Create resource → API call
- List resource → API call
- Delete resource → API call

### 🔧 API Enablement Concept

**Why Enable APIs?**
- Ensures project is properly configured for:
  - Billing
  - Monitoring
  - Security

**Cost**:
- ❌ No charge for API enablement itself
- ✅ Charges apply when consuming resources/services

> [!IMPORTANT]
> Best practice: Disable unused APIs (especially in shared company projects)

### 📝 API Enablement Process

#### Automatic Enablement
Some APIs are enabled by default when project is created:
- Analytics Hub API
- BigQuery APIs
- Monitoring
- Cloud Run
- Cloud SQL

**View Default Enabled APIs**:
```
Search "APIs and services" → Enabled APIs
    ↓
Scroll down to see list
```

#### Manual Enablement

**Example 1 - Kubernetes Engine (GKE)**:
```
Navigate to GKE service
    ↓
Redirected to enable API first
    ↓
Enable → Redirected to service
```

**Example 2 - Compute Engine**:
```
Navigate to Compute Engine
    ↓
Click "VM instances"
    ↓
Redirected to enable Compute Engine API
```

#### Enable APIs Directly

```
APIs & Services → Search for API (e.g., "Compute Engine API")
    ↓
Click API → Enable
```

#### Disable APIs

```
APIs & Services → Enabled APIs
    ↓
Select API → Disable
```

### ⚠ Throughout the Course

> [!NOTE]
> You will be prompted/redirected to enable APIs as needed. Go ahead and enable required APIs.

---

## 1.10 Cloud Shell and gcloud Basics

### ☁ Cloud Shell

**Definition**: Browser-based free interactive shell environment in GCP

**Technical Details**:
- Ephemeral VM
- 5 GB persistent directory (persists across sessions)
- Pre-installed with:
  - Google Cloud SDK
  - `gcloud` CLI
  - Other developer utilities

```
Cloud Shell Session
    │
    ├── Ephemeral VM (temporary)
    └── 5 GB Persistent Directory (permanent)
         ↓
    Attached to new VM each session
```

### 🛠 gcloud CLI

**Generic Command Format**:
```
gcloud [SERVICE] [OBJECT] [ACTION]
```

**Example**:
```bash
gcloud apigee environments list
```
- `apigee` = Service
- `environments` = Object
- `list` = Action

### 💻 Installing gcloud Locally

**Platforms**: MacBook, Windows

**Initialization Commands**:
```bash
gcloud auth login
# OR (better)
gcloud init
```

**Initialization Process**:
- Prompts for basic parameters:
  - Project ID
  - Region
  - Zone
  - Authentication

### 🔧 Service-Specific CLI Tools

> [!NOTE]
> Some services use different CLI tools (not `gcloud`):
> - **BigQuery**: `bq`
> - **Cloud Storage**: `gsutil`

**Examples**:
```bash
bq query "SELECT * FROM dataset.table"
gsutil cp file.txt gs://bucket-name/
```

### 🚀 Activate Cloud Shell

```
Top right corner → Click Cloud Shell icon
    ↓
Authorization prompt → Authorize
    ↓
Cloud Shell environment ready
```

**Cloud Shell Options**:
- Open in new tab
- Settings:
  - Text size (increase/decrease)
  - Font
  - Theme
- Open Editor mode (easier for file management)

### 📝 gcloud Commands

#### Initialize gcloud
```bash
gcloud init
```

**Output**:
```
Existing configuration found with:
- Account: your-email@gmail.com
- Project: my-first-project-123456
- Region: (not set)
- Zone: (not set)

Options:
1. Re-initialize with existing configuration
2. Create new configuration

Select option: 1
Select account: your-email@gmail.com
Select project: 2 (my-first-project)
Configure default compute region/zone? n
```

#### List Configuration
```bash
gcloud config list
```

**Output**:
```
[compute]
gce_metadata_read_timeout = 30

[core]
account = your-email@gmail.com
project = my-first-project-123456
```

#### List Specific Property
```bash
# List core/project property
gcloud config list core/project
# OR (core is default category)
gcloud config list project
```

#### Set Properties
```bash
# Set region
gcloud config set compute/region asia-south1

# Set zone
gcloud config set compute/zone asia-south1-a
```

**Output**:
```
Updated property [compute/region].
Updated property [compute/zone].
```

#### List Compute Properties
```bash
gcloud config list compute/region
```

**Output**:
```
[compute]
region = asia-south1
```

#### Format Output (Get Plain Value)
```bash
gcloud config list compute/region --format="value(compute.region)"
```

**Output**:
```
asia-south1
```

> [!NOTE]
> This removes the category label, giving clean output suitable for scripting.

#### Store Value in Variable
```bash
# Export variable
export REGION=$(gcloud config list compute/region --format="value(compute.region)")

# Echo variable
echo $REGION
```

**Output**:
```
asia-south1
```

**Use Cases**:
- Store region, zone, project ID in variables
- Use in scripts for automation

### 💡 Cloud Shell Editor

```
Cloud Shell → Open Editor
    ↓
Terminal + File Explorer interface
    ↓
Easier to:
- Create files
- Delete files
- Create project directories
- Navigate file system
```

**Switch Back**:
```
Open Editor → Open Terminal
```

### 🎯 Key Takeaways

✅ Cloud Shell is free and browser-based
✅ Pre-installed with gcloud and developer tools
✅ 5 GB persistent storage across sessions
✅ `gcloud` command format: `gcloud [SERVICE] [OBJECT] [ACTION]`
✅ Settings are local to your gcloud configuration
✅ Use `--format` flag for clean output suitable for scripting
✅ Variables can store gcloud output for automation

---

## Summary

### Section 1 Key Concepts

✅ **Course Structure**: T-shaped learning (Apigee depth + GCP breadth)
✅ **GCP Fundamentals**: Regions, zones, global coverage
✅ **Resource Hierarchy**: Organization → Folders → Projects → Resources
✅ **Cost Optimization**: Free trial ($300/3 months) + Apigee eval (free) + good practices
✅ **Billing Management**: Budgets, alerts, reports, cost calculator
✅ **Project Management**: Create, delete, restore, link to billing
✅ **API Enablement**: Required for services, no cost for enablement itself
✅ **Cloud Shell & gcloud**: Browser-based CLI, pre-installed tools, scripting capabilities

### 🎯 Next Steps

Section 2 will cover **API Fundamentals** including:
- API definitions and types
- HTTP methods and status codes
- REST principles
- OpenAPI specification
- Google Maps API exploration
