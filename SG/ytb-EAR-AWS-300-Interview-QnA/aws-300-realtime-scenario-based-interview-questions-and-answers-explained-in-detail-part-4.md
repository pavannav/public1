<details open>
<summary><b>AWS 300+ Realtime Scenario based Interview questions and answers explained in detail - Part - 4 (KK-CS45-script-v2-Interview)</b></summary>

# AWS 300+ Realtime Scenario Based Interview Q&A - Part 4

## Question 26: What is CloudFront and How to Create It?

### Answer:

**Amazon CloudFront** is a Content Delivery Network (CDN) service that speeds up the distribution of static and dynamic web content (HTML, CSS, images) to users worldwide.

#### Key Components:
- **Edge Locations**: AWS data centers that cache content for faster delivery
- **Origin**: The source of content (S3 bucket, EC2 instance, or API)
- **Caching**: Copies of content stored at edge locations to reduce latency

#### How CloudFront Works:
1. User requests content from nearest edge location
2. If content exists in cache → served immediately
3. If content doesn't exist → fetched from origin, cached, then served
4. Subsequent requests served from cache without origin access

#### Creating CloudFront Distribution:

**Step 1: Create S3 Bucket**
- Navigate to S3 → Create bucket
- Provide bucket name (globally unique)
- Disable ACL (Access Control List)
- Block all public access
- Upload files (e.g., index.html, images)

**Step 2: Create CloudFront Distribution**
1. Go to CloudFront → Create distribution
2. Select origin (S3 bucket)
3. Configure Origin Access Control (S3 only)
4. Create distribution (note: will show "Deploying" status)
5. Update S3 bucket policy with provided permissions
6. Edit distribution → Set Default Root Object (index.html)
7. Wait for deployment to complete (status changes to "Deployed")

**Step 3: Verify**
- Copy CloudFront distribution domain name
- Access via browser to confirm content delivery

> **Note**: Edge locations cache content globally, significantly reducing latency for users worldwide.

---

## Question 27: Brief About S3 Storage and How to Create S3 Bucket

### Answer:

**Amazon S3 (Simple Storage Service)** is an object storage service for storing and retrieving any amount of data.

#### Key Features:
- Upload/download files (similar to FTP)
- Store snapshots and large datasets
- Encrypt sensitive data
- Block all public access for security
- Supports both object and block storage

#### Creating S3 Bucket:

**Step 1: Create Bucket**
1. Navigate to S3 service
2. Click "Create bucket"
3. Provide bucket name (globally unique)
4. Keep default settings
5. Enable "Block all public access"
6. Create bucket

**Step 2: Upload Files**
1. Select bucket → Click "Upload"
2. Choose files to upload
3. Click "Upload" button
4. Files appear as private objects

**Step 3: Access Management**
- Files remain private by default
- Attempting to access via Object URL returns "Access Denied"
- Can be configured for public access if needed (with appropriate permissions)

> **Note**: S3 provides scalable, secure object storage with built-in encryption and access controls.

---

## Question 28: What is Hypervisor?

### Answer:

A **hypervisor** is software that enables virtualization by partitioning physical hardware resources into virtual platforms delivered to multiple users.

#### Role of Hypervisor:
- Acts as an intermediary between OS and hardware
- Creates illusion of dedicated resources (memory, disk, network)
- Actually running on host machine's base OS
- Functions like a "broker" managing resource allocation

#### Types of Hypervisors:

**Type 1 (Bare Metal) Hypervisor:**
```
[Hardware]
    ↓
[Hypervisor]
    ↓
[Guest OS 1] [Guest OS 2] [Guest OS 3]
```
- Runs directly on hardware
- Examples: VMware ESXi, Microsoft Hyper-V, Xen

**Type 2 (Hosted) Hypervisor:**
```
[Hardware]
    ↓
[Host OS]
    ↓
[Hypervisor]
    ↓
[Guest OS 1] [Guest OS 2]
```
- Runs on top of existing OS
- Examples: VMware Workstation, VirtualBox

#### Real Example (Type 2):
1. Windows OS installed on laptop
2. VMware Workstation installed on Windows
3. Virtual machines created within VMware
4. Each VM gets allocated RAM, disk space, network interfaces

> **Note**: Xen is the hypervisor used for AWS EC2 instances.

---

## Question 29: What is the Feature of Classic Link?

### Answer:

**Note**: EC2-Classic Link has been retired and is no longer available for new implementations.

#### Historical Feature (for reference):
Classic Link allowed EC2-Classic platform instances to communicate with instances in a VPC using private IP addresses.

#### Key Limitations:
- Could only be linked to one VPC at a time
- Enabled private IP communication within single VPC
- Instances in different VPCs could not communicate via Classic Link

#### Current Status:
- **Retired Service**: No longer implementable
- If asked in interview, explain as historical concept only

> **Note**: Modern AWS networking uses VPC peering, Transit Gateway, or PrivateLink for inter-VPC communication.

---

## Question 30: Can You Edit a Route Table in VPC?

### Answer:

**Yes**, route tables in VPC can be edited at any time.

#### Route Table Capabilities:
- Modify routing rules dynamically
- Specify which subnets route to:
  - Internet Gateway (for internet access)
  - Virtual Private Gateway (for VPN/Direct Connect)
  - Other instances or NAT gateways
  - VPC endpoints

#### Common Modifications:
1. Add route to Internet Gateway: `0.0.0.0/0 → igw-xxxxx`
2. Add route to NAT Gateway for private subnets
3. Configure VPC peering routes
4. Add routes for on-premises networks via VPN

#### Best Practices:
- Plan subnet routing during VPC design
- Use separate route tables for public/private subnets
- Document all route modifications
- Test connectivity after changes

---

## Summary

This session covered five essential AWS concepts:

1. **CloudFront CDN** - Global content delivery with edge caching
2. **S3 Storage** - Secure object storage with access controls
3. **Hypervisors** - Virtualization technology (Type 1 vs Type 2)
4. **Classic Link** - Retired VPC networking feature
5. **VPC Route Tables** - Editable routing configuration

Each topic included practical AWS console demonstrations and real-world scenarios commonly encountered in interviews.

</details>