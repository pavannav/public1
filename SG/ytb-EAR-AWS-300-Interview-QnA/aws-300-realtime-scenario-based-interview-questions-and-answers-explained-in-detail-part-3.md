<details open>
<summary><b>AWS 300+ Realtime Scenario based Interview Questions and Answers - Part 3 (KK-CS45-script-v2-Interview)</b></summary>

# AWS 300+ Realtime Scenario based Interview Questions and Answers - Part 3

## Table of Contents
1. [What is Auto Scaling and How to Create It](#question-1-what-is-auto-scaling-and-how-to-create-it)
2. [Standby RDS Instance Availability Zone](#question-2-standby-rds-instance-availability-zone)
3. [Difference Between Amazon RDS, DynamoDB, and Redshift](#question-3-difference-between-amazon-rds-dynamodb-and-redshift)
4. [What are Lifecycle Hooks](#question-4-what-are-lifecycle-hooks)
5. [What is S3 and How Many Backups Can Be Created](#question-5-what-is-s3-and-how-many-backups-can-be-created)

---

## Question 1: What is Auto Scaling and How to Create It

### Interview Question
What is auto scaling and how do we create auto scaling groups?

### Answer

**Auto Scaling Definition:**
Auto Scaling is the process of creating duplicate instances during heavy business hours to handle increased traffic/load. It involves two key operations:
- **Scale-in**: Reducing the number of instances
- **Scale-out**: Increasing the number of instances by creating duplicates

**Key Components of Auto Scaling Group:**
- **Minimum Size**: The minimum number of instances that will always be running
- **Desired Capacity**: The target number of instances the group should maintain
- **Maximum Size**: The maximum limit for scaling out when traffic increases

**Real-World Example - IRCTC:**
Consider IRCTC (Indian Railway booking site) during ticket booking rush:
- Normal times: 2 instances handle traffic
- Heavy traffic: Auto scales to 4-6 instances
- Traffic reduces: Scales back to minimum required instances

### How to Create Auto Scaling (Step-by-Step)

#### Prerequisites:
1. **Create AMI (Amazon Machine Image)** from existing instance
2. **Create Load Balancer** (Classic Load Balancer)
3. **Create Target Group**

#### Step-by-Step Process:

**Step 1: Create AMI**
```bash
1. Select EC2 instance → Actions → Image and templates → Create image
2. Provide image name and description
3. Add appropriate tags
4. Create the AMI (takes time to complete)
```

**Step 2: Create Load Balancer**
```bash
1. Navigate to EC2 → Load Balancers
2. Create Classic Load Balancer
3. Configure:
   - Name: e.g., "LB1"
   - VPC and subnets selection
   - Security groups
   - Protocol: TCP
4. Create the load balancer
```

**Step 3: Create Target Group**
```bash
1. Navigate to Target Groups
2. Create target group with:
   - Type: Instances
   - Protocol and port configuration
   - VPC selection
   - Name: e.g., "TG1"
3. Register instances to target group
```

**Step 4: Create Auto Scaling Group**
```bash
1. Navigate to Auto Scaling → Auto Scaling Groups
2. Create Auto Scaling Group
3. Configure Launch Configuration:
   - Name: e.g., "auto-configuration-1"
   - Select created AMI
   - Instance type: t2.micro (free tier)
   - Security group: Same as original instance
   - Key pair selection

4. Configure Group Details:
   - Minimum: 2 instances
   - Desired: 3-4 instances
   - Maximum: 6 instances
   - VPC and subnet selection

5. Attach Load Balancer:
   - Select previously created load balancer
   - Choose target group

6. Configure Scaling Policies:
   - Choose "No scaling policies" for manual control
   - Or configure dynamic scaling policies

7. Add Tags and Create the group
```

**Step 5: Verify Auto Scaling**
- Check Activity tab to see instances launching
- Monitor instance count based on desired capacity
- Test by terminating instances to verify automatic replacement

---

## Question 2: Standby RDS Instance Availability Zone

### Interview Question
When you launch a standby Relational Database Service (RDS) instance, will it be available in the same availability zone?

### Answer

**No, it is not advisable to keep standby RDS in the same availability zone.**

**Reasoning:**
- **Purpose of Standby**: Standby instances serve as backups to prevent infrastructure failure
- **High Availability**: Keeping standby in different AZ provides redundancy
- **Failure Protection**: If primary AZ goes down, standby in different AZ ensures continuity

**AWS Availability Zones:**
- Each AWS region has multiple AZs (typically 3+): e.g., ap-south-1a, ap-south-1b, ap-south-1c
- Standby RDS should be placed in a different AZ than the primary
- This ensures different underlying infrastructure for true redundancy

> **Note**: This is a theoretical question commonly asked for freshers with 1-2 years of experience to understand AWS high availability concepts.

---

## Question 3: Difference Between Amazon RDS, DynamoDB, and Redshift

### Interview Question
What is the difference between Amazon RDS, DynamoDB, and Redshift?

### Answer

| Service | Data Type | Use Case | Description |
|---------|-----------|----------|-------------|
| **Amazon RDS** | Structured Data | Relational databases | Traditional SQL databases like MySQL, PostgreSQL, Oracle |
| **DynamoDB** | Unstructured/ Semi-structured Data | NoSQL database | Serverless NoSQL database for flexible data models |
| **Redshift** | Structured Data | Data warehousing | Analytics and business intelligence workloads |

**Detailed Comparison:**

**1. Amazon RDS (Relational Database Service):**
- Traditional relational database service
- Supports MySQL, PostgreSQL, MariaDB, Oracle, SQL Server
- Structured data with predefined schemas
- ACID compliance for transactions

**2. Amazon DynamoDB:**
- NoSQL database service
- Handles unstructured and semi-structured data
- Key-value and document data models
- Serverless with automatic scaling
- Millisecond response times

**3. Amazon Redshift:**
- Data warehouse solution
- Designed for analytics and reporting
- Columnar storage for better query performance
- Used for business intelligence and data analysis
- Can handle petabyte-scale data

---

## Question 4: What are Lifecycle Hooks

### Interview Question
What are lifecycle hooks in AWS Auto Scaling?

### Answer

**Lifecycle hooks** are features of Auto Scaling groups that enable custom actions by pausing instances as an Auto Scaling group launches or terminates them.

**Key Points:**
- Each Auto Scaling group can have multiple lifecycle hooks
- They provide control over instance lifecycle during scale-in and scale-out operations
- Enable custom actions before instances are fully operational or terminated

**Use Cases for Lifecycle Hooks:**

**During Scale-Out (Instance Launch):**
- Ensure bootstrap scripts complete successfully
- Verify application readiness before accepting traffic
- Wait for instance registration with Elastic Load Balancer (ELB)
- Perform health checks before adding to load balancer

**During Scale-In (Instance Termination):**
- Download logs and data before termination
- Invoke AWS Lambda functions during wait state
- Connect to instance for data extraction
- Use Amazon EventBridge for notifications

**Lifecycle States:**
- **Pending:Wait** - Instance paused during launch
- **Terminating:Wait** - Instance paused during termination
- **Autoscaling** - Custom actions can be performed

**Benefits:**
- Control when instances are registered with load balancers
- Ensure application readiness before traffic routing
- Safely extract important data before termination
- Execute custom automation scripts

---

## Question 5: What is S3 and How Many Backups Can Be Created

### Interview Question
What is S3 and how many buckets can be created?

### Answer

**S3 (Simple Storage Service):**
S3 is an object storage service with a simple web service interface to store and retrieve any amount of data from anywhere on the web.

**Key Characteristics:**
- **Object Storage**: Stores data as objects in buckets
- **Scalability**: Store unlimited amounts of data
- **Accessibility**: Access data from anywhere via web services
- **Durability**: 99.999999999% (11 9's) durability

**Storage Classes Available:**
- Standard
- Intelligent-Tiering
- Standard-IA (Infrequent Access)
- One Zone-IA
- Glacier (for archival)
- Glacier Deep Archive

**Bucket Limits:**
- **Default Limit**: 100 buckets per AWS account per region
- Can request increase from AWS Support if more buckets needed
- Bucket names must be globally unique

**S3 vs EBS Storage Types:**
- **S3**: Object storage for unstructured data, files, backups
- **EBS**: Block storage for EC2 instances, structured like hard drives

---

## Summary

This session covered essential AWS concepts for interview preparation:

1. **Auto Scaling**: Dynamic instance management based on traffic
2. **RDS High Availability**: Multi-AZ deployments for redundancy
3. **Database Services**: Understanding different AWS database solutions
4. **Lifecycle Management**: Fine-grained control over instance lifecycle
5. **S3 Storage**: Object storage fundamentals and limitations

These questions are suitable for candidates with 1-3 years of AWS experience and form the foundation for more advanced topics in subsequent sessions.

</details>