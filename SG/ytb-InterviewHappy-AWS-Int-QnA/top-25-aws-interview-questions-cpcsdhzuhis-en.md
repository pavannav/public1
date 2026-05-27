<details open>
<summary><b>Top 25 AWS Interview Questions (KK-CS45-script-v2-Interview)</b></summary>

# Top 25 AWS Interview Questions Study Guide

## Q1: What is Cloud Computing? What is AWS?

**Answer:**
Cloud computing is the delivery of computing services including servers, storage, databases, networking, and software over the internet instead of using physical hardware or local servers. AWS (Amazon Web Services) is a cloud computing platform provided by Amazon offering a wide range of services to build, deploy, and manage applications and infrastructure.

**Key Points:**
- Cloud computing is a concept; AWS, Azure, and Google Cloud are its practical implementations
- In cloud, you don't need to maintain physical servers - everything is accessed via the internet
- Your company subscribes to services rather than purchasing hardware

---

## Q2: What are the 5 advantages of using AWS over on-premise servers?

**Answer:**

### 1. Cost Savings (Pay-As-You-Go Model)
- Only pay for what you use - no upfront hardware costs
- If you need 5 servers today but 10 tomorrow, you only pay for current usage
- No maintenance costs - AWS handles all infrastructure maintenance

### 2. Scalability & Flexibility
- **Auto Scaling**: Automatically adds or removes resources based on demand
- **Horizontal Scaling**: EC2 instances automatically scale during high load (e.g., weekends for e-commerce)
- Handles instant load changes without manual intervention

### 3. High Availability
- AWS guarantees 99.99% uptime through Service Level Agreements
- Services are always available and resilient

### 4. Disaster Recovery
- Data stored across multiple Availability Zones and data centers
- If one data center fails, another automatically provides backup
- Automated recovery and data backup provided by AWS

### 5. Advanced Security
- AI-driven threat detection
- Multi-layer security with encryption
- IAM access policies and multi-factor authentication
- No need to worry about hacking or malware

---

## Q3: What are the main cloud service models? Explain the difference between IaaS, PaaS, and SaaS with AWS examples.

**Answer:**

### The Computing Stack Layers:
1. **Application & Data** (Top)
2. **Runtime** (Java, .NET, NodeJS)
3. **Middleware** (MS Office, SAP)
4. **OS** (Windows/Linux Server)
5. **Virtualization**
6. **Physical Servers**
7. **Storage**
8. **Networking** (Bottom)

### Cloud Service Models:

#### **IaaS (Infrastructure as a Service)**
- You manage: Application, Data, Runtime, Middleware, OS
- AWS manages: Virtualization, Servers, Storage, Networking
- **AWS Example**: EC2, VPC, EBS
- Work reduction: Infrastructure team has less work

#### **PaaS (Platform as a Service)** - Most Popular
- You manage: Application and Data only
- AWS manages: Everything else (Runtime, Middleware, OS, Servers, Storage, Networking)
- **AWS Example**: Elastic Beanstalk, Lambda
- Most developers work at this level

#### **SaaS (Software as a Service)**
- AWS manages: Everything including Application and Data
- You just subscribe and use
- No technical work required
- **Examples**: Amazon WorkMail, Salesforce, Office 365

**Key Insight**: As an AWS developer, you'll mostly work with IaaS or PaaS models.

---

## Q4: What is the AWS Shared Responsibility Model?

**Answer:**
The AWS Shared Responsibility Model divides security and compliance responsibilities between AWS and the customer. AWS manages security "OF" the cloud while customers manage security "IN" the cloud.

**Division of Responsibilities:**

### AWS Responsibilities:
- Physical security of data centers
- Hardware maintenance
- Network infrastructure
- Virtualization layer
- Service availability (99.99% uptime SLA)

### Customer Responsibilities:
- Data encryption (at rest and in transit)
- IAM policies and access management
- Application-level security
- Operating system patches (for IaaS)
- Network configuration (Security Groups, NACLs)

**Example**: When using EC2 (IaaS), you manage the OS and applications. When using Lambda (PaaS), AWS manages more of the stack.

---

## Q5: What are the main categories of AWS services? What are the top 25 services?

**Answer:**

### Main Categories:
1. **Compute** - EC2, Lambda, ECS, Elastic Beanstalk
2. **Database** - RDS, DynamoDB, ElastiCache, Redshift
3. **Storage** - S3, EBS, EFS, Glacier
4. **Networking & Content Delivery** - VPC, Route 53, CloudFront, ELB
5. **Messaging & Integration** - SQS, SNS, EventBridge
6. **Security** - IAM, KMS, WAF, GuardDuty
7. **Infrastructure & DevOps** - CloudFormation, CodePipeline, CloudWatch

### Top 25 Most Used Services:
1. EC2 (Compute)
2. S3 (Storage)
3. RDS (Database)
4. Lambda (Serverless)
5. VPC (Networking)
6. IAM (Security)
7. CloudFront (CDN)
8. Route 53 (DNS)
9. DynamoDB (NoSQL)
10. EBS (Block Storage)
11. ELB (Load Balancing)
12. Auto Scaling
13. SQS (Message Queue)
14. SNS (Notifications)
15. CloudWatch (Monitoring)
16. CloudFormation (IaC)
17. ECS/EKS (Containers)
18. ElastiCache (Caching)
19. API Gateway
20. Cognito (Authentication)
21. KMS (Key Management)
22. CloudTrail (Logging)
23. Systems Manager
24. Parameter Store
25. Secrets Manager

---

## Q6: What is Hybrid Cloud?

**Answer:**
Hybrid Cloud is a computing environment that combines on-premises infrastructure (your own data center or servers) with AWS cloud services, working together seamlessly.

**Use Case Example:**
- Company migrates application servers to AWS EC2
- Database remains on-premises due to:
  - Regulatory compliance
  - Company policy for sensitive data
  - Complex legacy systems
  - Large data volume

**Implementation:**
- Use **AWS Direct Connect** or **AWS VPN** for secure connection
- Create hybrid architecture connecting cloud and on-premises resources
- Enable data flow between AWS cloud and on-premises database

---

## Q7: What is a Resource in AWS? Difference between Resource and Service?

**Answer:**

### AWS Service:
A tool or feature offered by AWS to perform specific tasks (like a class in programming)
- **Examples**: EC2, S3, RDS, Lambda
- Services are always available for you to use

### AWS Resource:
An instance of a service that you create, configure, and use in the cloud (like an object/instance of a class)
- **Examples**:
  - An EC2 instance named "web-server-prod"
  - An S3 bucket named "my-company-backups"
  - An RDS database instance named "customer-db"

**Key Difference:**
- **Service** = The offering/tool (EC2)
- **Resource** = What you create from the service (specific EC2 instance)

---

## Q8: Explain the AWS Global Infrastructure

**Answer:**

### Global Infrastructure Components:

#### **Regions**
- Geographic areas with multiple data centers
- Examples: us-east-1 (N. Virginia), eu-west-1 (Ireland), ap-southeast-1 (Singapore)
- Each region is isolated and independent

#### **Availability Zones (AZs)**
- Physically separate data centers within a region
- Connected by high-speed, low-latency networks
- Minimum 3 AZs per region for high availability
- Format: us-east-1a, us-east-1b, us-east-1c

#### **Edge Locations**
- CDN endpoints for CloudFront
- 400+ locations worldwide
- Deliver content with low latency

#### **Local Zones**
- Extension of AWS regions closer to users
- Single-digit millisecond latency for applications

---

*Study Tip: Focus on understanding when to use each service model (IaaS/PaaS/SaaS) and practice explaining the advantages of cloud computing with real examples.*

</details>