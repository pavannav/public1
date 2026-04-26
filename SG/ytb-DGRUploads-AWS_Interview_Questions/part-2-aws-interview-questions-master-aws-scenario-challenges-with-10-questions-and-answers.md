# Part 2 _ AWS Interview Questions _ Master AWS Scenario Challenges with 10 Questions and answers!

## 1. How can you ensure that a web application hosted on an EC2 instance is highly available and fault-tolerant?

### Answer:
To make a web application on EC2 highly available and fault-tolerant, deploy it across multiple Availability Zones (AZs). Launch multiple EC2 instances in different AZs (e.g., one in us-east-1a and another in us-east-1b). Use Auto Scaling groups to handle scaling based on CPU or network utilization, allowing automatic scale-up or scale-down of instances.

### Note:
This approach is correct. For better fault tolerance, consider using Elastic Load Balancing (ELB) to distribute traffic, which wasn't explicitly mentioned but would enhance the solution.

## 2. Explain the differences between Amazon RDS and Amazon DynamoDB.

### Answer:
Amazon RDS is a relational database service (SQL), suitable for structured data with rows and columns, supporting SQL queries. AWS manages DynamoDB fully as a NoSQL database for unstructured or semi-structured data with automatic scaling. RDS requires launching and managing a DB instance, while DynamoDB is fully managed.

### Note:
Accurate explanation. RDS supports multiple engines like MySQL, PostgreSQL, whereas DynamoDB is key-value and document-based. For cost-effectiveness on unstructured data at scale, DynamoDB is preferable.

## 3. Your EC2 instances are experiencing performance issues due to high traffic. How can you mitigate this?

### Answer:
Create an Amazon VPC with a proper network architecture, including subnets, firewalls, and route tables for high availability. Implement CloudFront (CDN) for caching to reduce load. Use a load balancer to distribute traffic across multiple instances behind it, preventing overload on individual instances.

### Note:
This is correct. Additionally, consider enabling Elastic Load Balancing (ELB) with Auto Scaling, and monitoring with CloudWatch for proactive scaling. VPC alone doesn't distribute traffic.

## 4. How can you monitor the performance of your EC2 instances and set up automated actions based on metrics?

### Answer:
Use Amazon CloudWatch to monitor EC2 metrics like CPU utilization, network in/out, and disk I/O, which are enabled by default. Create CloudWatch alarms with thresholds (e.g., CPU > 80%) to trigger actions like scaling instances, sending notifications, or executing EC2/System Manager actions.

### Note:
Correct. CloudWatch integrates well with Auto Scaling for automatic scaling. Ensure proper alarm configuration to avoid false positives.

## 5. Your application needs to securely store sensitive configuration information. What AWS service should you use?

### Answer:
Use AWS Systems Manager Parameter Store to store sensitive data like passwords or API keys. It supports encryption for secure strings and makes the data accessible to EC2 instances securely without exposing secrets.

### Note:
This is a good choice. For more advanced key management, consider AWS Secrets Manager, which provides additional features like rotation and is specifically designed for secrets.

## 6. How can you implement data encryption for your S3 buckets?

### Answer:
Enable Server-Side Encryption (SSE) for S3 buckets. Options include:
- SSE-S3: S3-managed encryption keys.
- SSE-KMS: AWS Key Management Service for better control and auditing.
- SSE-C: Customer-provided encryption keys.
Edit bucket properties under Encryption to choose the method; all new objects will be encrypted.

### Note:
Accurate. For existing objects, use S3 Batch Operations if needed. Dual-layer server-side encryption with KMS provides additional security.

## 7. What is AWS Elastic Beanstalk, and how does it differ from EC2 instances?

### Answer:
AWS Elastic Beanstalk is a Platform as a Service (PaaS) that simplifies application deployment and management by handling infrastructure setup, scaling, and deployment automatically. Select the platform, upload code, and configure resources like instances and databases.

EC2 is Infrastructure as a Service (IaaS) where you manually launch and manage instances, deploy applications, and maintain everything.

### Note:
Correct differentiation. Elastic Beanstalk automates deployment, while EC2 offers more control but requires manual management. Ideal for developers focused on code, not infrastructure.

## 8. Your company has a legacy application that requires Windows Server. How can you run Windows workloads on AWS?

### Answer:
Launch EC2 instances using a Windows AMI (Amazon Machine Image), which provides a Windows Server OS. After launching, connect via RDP and deploy the legacy Windows application on the virtual machine.

### Note:
This is correct. Ensure compatibility with Windows Server versions. For modernizing legacy apps, consider AWS App2Container or Lambda if applicable, but EC2 with Windows AMI is straightforward for Windows workloads.

## 9. Explain the difference between an Amazon S3 bucket policy and an IAM policy.

### Answer:
- **S3 Bucket Policy**: Applied directly to an S3 bucket to control access to its contents (JSON document specifying who can access and what actions they can perform, limited to the bucket's resources).
- **IAM Policy**: Attached to IAM users, groups, or roles to define permissions across AWS resources at a broader level (controls actions like launching EC2 instances or creating S3 buckets globally).

### Note:
Accurate. Bucket policies use principals (e.g., users) and actions specific to S3. IAM policies are identity-based and can combine with resource policies for finer control.

## 10. How can you ensure that your EC2 instances have the latest security patches and updates?

### Answer:
Use AWS Systems Manager with Patch Manager to automate patch application. It scans EC2 instances for missing patches and applies security updates in bulk, with options for scheduling and automation.

### Note:
Correct and efficient. Integrate with compliance standards like CIS Benchmarks. For automated patching, use Maintenance Windows in Systems Manager.

<summary>CL-KK-Terminal</summary>
