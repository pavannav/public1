<details open>
<summary><b>Top-10-AWS-Interview-Questions-for-Beginners (KK-CS45-script-v2-Interview)</b></summary>

# Top 10 AWS Interview Questions for Beginners - Study Guide

## Q1: What are the main cloud service models? Explain the difference between IaaS, PaaS and SaaS with AWS examples.

### Answer:

When running applications on-premises, a company needs to manage the entire computing stack:

**Layers managed by IT/Infrastructure Team:**
- Application & Data (Developers)
- Runtime (Java, .NET, NodeJS)
- Middleware (MS Office, SAP, APIs)
- Operating System (Windows/Linux Server)
- Virtualization
- Physical Servers (secured, updated, monitored, antivirus)
- Storage (images, files, database)
- Networking

**Three Cloud Service Models:**

**1. IaaS (Infrastructure as a Service)**
- Managed by company: Application, Data, Runtime, Middleware, OS
- Managed by AWS: Virtualization, Server, Storage, Networking
- Example: Amazon EC2
- Benefit: Infrastructure team has less work

**2. PaaS (Platform as a Service) - Most Popular**
- Company focuses only on: Application and Data
- AWS manages: Everything else (Runtime, Middleware, OS, Networking, Server, Storage)
- Example: AWS Elastic Beanstalk, AWS Lambda
- Ideal for developers who want to focus on code

**3. SaaS (Software as a Service)**
- Everything managed by AWS including Application and Data
- Company just subscribes and uses
- Examples: Amazon WorkMail, Salesforce, Office 365
- No technical work required

**Note:** These are layers, not actual AWS services. Services like EC2 belong to server layer, S3/EBS belong to storage layer.

---

## Q2: What are the main categories of AWS services? What are the top 25 services?

### Answer:

AWS provides hundreds of services organized into categories. While it's not possible to learn all services, **80% of applications can be built using just 20% of services**.

**Main Service Categories:**
1. **Compute** - EC2, Lambda, Elastic Beanstalk, ECS, Lightsail
2. **Database** - RDS, DynamoDB, ElastiCache, Redshift
3. **Storage** - S3, EBS, EFS, Glacier
4. **Networking & Content Delivery** - VPC, CloudFront, Route 53, API Gateway
5. **Messaging & Integration** - SQS, SNS, EventBridge
6. **Security** - IAM, KMS, Cognito, WAF, Shield
7. **Infrastructure & DevOps** - CloudFormation, CloudWatch, CodePipeline, X-Ray

**Key Insight:** When to use which service depends on the situation - this will be covered in upcoming questions.

---

## Q3: What is a resource in AWS? What is the difference between a resource and a service?

### Answer:

**AWS Service:** A tool or feature offered by AWS to perform tasks like computing, storage, network, security (like a class in programming)

**AWS Resource:** An instance of that service that you create, configure and use in the cloud (like an object/instance of a class)

**Example:**
- Creating an EC2 instance in your AWS account = creating a resource
- That specific EC2 instance = a resource
- Multiple resources can be created (RDS instance, S3 bucket, Lambda function)

**Simple Memory Aid:**
- Service = Class
- Resource = Object/Instance of that class

**Important:** A single application requires creating many resources. Resource management will be covered in upcoming questions.

---

## Q4: What are AWS regions and availability zones? How are they different?

### Answer:

**AWS Region:**
- A geographical area where AWS has multiple data centers
- Examples: Mumbai, North Virginia, Singapore
- Your company chooses a region closer to their location for faster access

**AWS Availability Zones (AZs):**
- Physically separate data centers within a single AWS region
- Multiple AZs exist inside one region
- Ensures high availability by protecting applications from single data center failure
- If one AZ fails, other AZs provide immediate backup

**Key Difference:**
- Region = Physical location (e.g., Mumbai)
- AZ = Actual data center locations within each region

**Simple Definition:**
- AWS Region: Geographical area with multiple AWS data centers
- AWS Availability Zone: Physically separate data center within a region ensuring high availability

---

## Q5: What are AWS compute services? Name a few of them.

### Answer:

**AWS Compute Services** are those that handle computations - processing or executing application logic.

**Popular AWS Compute Services:**

1. **Amazon EC2 (Elastic Compute Cloud)**
   - Used to host applications as virtual servers

2. **AWS Lambda**
   - Used for serverless computation

3. **AWS Elastic Beanstalk**
   - Used for deploying applications without managing infrastructure

4. **EC2 Auto Scaling**
   - Used for automatically scaling EC2 instances

**Definition:**
AWS compute services provide cloud-based processing power, autoscaling, and execution environments for applications.

**Next Question:** EC2 will be covered in detail next.

---

## Q6: What are Amazon EC2 instances? When would you use them in a project?

### Answer:

**EC2 instances** are like servers in the cloud where you host your applications.

**On-Premises vs Cloud:**
- On-premises: Physical servers host frontend and backend/API
- Cloud: EC2 instances host applications (called "servers" in the cloud)

**EC2 = Elastic Compute Cloud**

**Uses:**
- Host applications (most common)
- Running background processes
- Similar to how you'd use a physical server, but virtual

**Simple Definition:**
EC2 instances are cloud-based virtual servers that allow running applications without needing to buy or manage physical hardware.

**Important Note:** EC2 is NOT always the best/simplest/fastest option for hosting applications. The best service depends on requirements.

---

## Q7: What is AWS Elastic Beanstalk? For what purpose can you use it?

### Answer:

**Elastic Beanstalk** is a PaaS (Platform as a Service) offering.

**Comparison with EC2 (IaaS):**
- **EC2 (IaaS):** Developer manages many things - installs OS, frameworks, handles hosting setup
- **Elastic Beanstalk (PaaS):** Developer only provides:
  - Application code
  - Data
  - Configuration
  - Nothing else needed

**When to Use:**
Ideal for developers who want to focus on code without infrastructure management.

**Key Benefit:**
As a developer, you don't need to create EC2 instances or manage the underlying infrastructure. AWS handles all that automatically.

**Use Case:** When you want to deploy applications quickly without managing servers, load balancers, or scaling.

---

## Q8: What is Amazon S3? What are its use cases?

### Answer:

**Amazon S3 (Simple Storage Service)** is AWS's object storage service.

**Use Cases:**
1. **Static Website Hosting** - Host HTML, CSS, JS files
2. **Media Storage** - Images, videos, audio files
3. **Data Backup** - Backup files and databases
4. **Data Lakes** - Store large amounts of raw data
5. **Application Assets** - Store application files and documents
6. **Log Storage** - Store application logs

**Key Features:**
- Highly scalable
- 99.999999999% durability
- Pay-as-you-go pricing
- Multiple storage classes for cost optimization

---

## Q9: What is Amazon RDS? When would you use it?

### Answer:

**Amazon RDS (Relational Database Service)** is a managed relational database service.

**Supported Database Engines:**
- MySQL
- PostgreSQL
- Oracle
- SQL Server
- MariaDB
- Amazon Aurora

**When to Use:**
- Need managed database without administration overhead
- Require automated backups
- Need multi-AZ deployment for high availability
- Want automatic software patching
- Need to scale compute and storage independently

**Benefits:**
- No server management
- Automated backups
- Multi-AZ deployments
- Read replicas for scaling
- Point-in-time recovery

---

## Q10: What is AWS Lambda? Explain its use cases and benefits.

### Answer:

**AWS Lambda** is a serverless compute service that runs code in response to events.

**Key Characteristics:**
- No server management required
- Pay only for compute time used
- Automatically scales
- Runs code in response to triggers

**Use Cases:**
1. **Event-driven processing** - Process S3 uploads, DynamoDB updates
2. **API backends** - Build serverless APIs with API Gateway
3. **Data processing** - Transform data in real-time
4. **IoT backends** - Process IoT device data
5. **Chatbots** - Backend logic for conversational interfaces
6. **Scheduled tasks** - Run code on a schedule

**Benefits:**
- Zero server management
- Automatic scaling from 0 to thousands
- Cost-effective (pay per millisecond)
- Built-in fault tolerance
- Supports multiple languages (Node.js, Python, Java, C#, Go, Ruby)

---

</details>