# Part 4 - AWS Interview Questions - Master AWS Scenario Challenges with 10 Questions and answers!

## Q&A Session Overview
This guide summarizes 10 AWS scenario-based interview questions and their answers from the training transcript. Each entry includes the question, a summarized answer, and validation notes for accuracy and improvements.

---

### Question 1: Which AWS service can be used to distribute content worldwide with low latency?
**Answer:** Use Amazon CloudFront, AWS's Content Delivery Network (CDN) service. It caches data at Edge locations globally, reducing latency by serving content from the nearest edge location to users instead of the original source. For example, an object originally hosted in an S3 bucket is cached at multiple Edge locations for faster access.

![CloudFront Diagram](./images/cloudfront-global-distribution.png)

**Validation Note:** Correct. CloudFront is specifically designed for this use case. No better alternatives needed.

---

### Question 2: Explain the concept of IAM roles in AWS.
**Answer:** IAM roles are temporary permissions that can be assumed by users, services, or resources to grant access without long-term credentials. Unlike IAM users (which have permanent access via access keys or passwords), roles provide temporary access tokens. For instance, an EC2 instance can assume a role to access S3 data securely, improving security by avoiding embedded credentials. Roles help in cross-service permissions, like enabling EC2 and S3 interactions.

**Validation Note:** Accurate. Emphasizes security best practices by avoiding long-term access keys.

---

### Question 3: What approach can be taken to encrypt data before storing it in an S3 bucket for data privacy?
**Answer:** Implement client-side encryption. Encrypt the data locally before uploading to the S3 bucket, ensuring privacy during transmission and storage. This differs from server-side encryption, which AWS handles on the bucket side. Client-side encryption involves encrypting on the sender's side before transfer.

**Validation Note:** Correct. This method ensures data is encrypted before it leaves the client. For additional security, combine with server-side encryption if needed.

---

### Question 4: How can you ensure an Amazon RDS database remains available during a failure in the primary Availability Zone?
**Answer:** Enable Multi-AZ deployment. This creates a primary database instance in one AZ and a standby replica in another AZ within the same region. Data is synchronously replicated. In case of failure (e.g., AZ outage), AWS automatically switches to the standby instance, maintaining availability.

![Multi-AZ Deployment](./images/rds-multi-az-diagram.png)

**Validation Note:** Accurate. Multi-AZ is AWS's primary method for high availability in RDS. No major improvements suggested.

---

### Question 5: How can you track expenses and allocate costs accurately for AWS resources across departments?
**Answer:** Use AWS Cost Explorer and Cost Allocation Tags. Cost Explorer provides reports on usage costs (e.g., monthly costs by service, EC2 runtime). Tags allow labeling resources by department or project for allocation. Enable tags on resources and generate custom reports to track spending precisely.

**Validation Note:** Correct. This is the recommended cost management approach. For advanced analytics, consider AWS Budgets or Cost and Usage Reports.

---

### Question 6: What steps can prevent unauthorized access to sensitive data in an S3 bucket?
**Answer:** 
- Use S3 Bucket Policies: Define JSON-based rules to control access permissions.
- Implement IAM Policies: Attach policies to users/roles for fine-grained control.
- Enable Server-Side Encryption: Protect data at rest.
- Follow Access Control Best Practices: Regularly audit permissions to ensure minimal access (principle of least privilege).

**Validation Note:** Comprehensive and correct. Additional measures like VPC endpoints or MFA delete can enhance security further.

---

### Question 7: What Amazon S3 storage class should be chosen to ensure data durability and availability for critical data?
**Answer:** Amazon S3 Standard storage class. It offers 99.999999999% (11 9's) durability and 99.99% availability, suitable for frequently accessed critical data. By default, S3 stores data in Standard unless specified otherwise.

**Validation Note:** Accurate. For even higher availability or redundancy, S3 Intelligent-Tiering could be considered, but Standard meets the stated requirements directly.

---

### Question 8: Explain the difference between AWS Lambda and AWS Fargate for running containers.
**Answer:** AWS Lambda is a serverless compute service for running code in response to events (e.g., S3 bucket creation triggers encryption code). No server management is needed. AWS Fargate is a serverless container orchestration service for running containerized applications, managing infrastructure for microservices without server oversight. Lambda handles event-driven functions, while Fargate manages containers.

**Validation Note:** Correct distinction. Lambda can support containers via runtime compatibility, but Fargate is purpose-built for orchestration.

---

### Question 9: Which AWS service can help distribute a private Docker container image securely within an organization?
**Answer:** Amazon Elastic Container Registry (ECR). It securely stores, manages, and deploys Docker images. Create a private repository, push images via CLI, and pull for deployments, ensuring internal distribution.

**Validation Note:** Accurate. ECR is AWS's equivalent to Docker Hub for private registries. No better alternatives mentioned in AWS for this exact use case.

---

### Question 10: How can you improve the read performance of database queries in Amazon RDS?
**Answer:** Implement Read Replicas. Offload read traffic from the primary database to replicas, which are copies of the primary database for read-only operations. This scales read-heavy workloads without affecting write performance on the primary instance.

![RDS Read Replica Architecture](./images/rds-read-replicas-diagram.png)

**Validation Note:** Correct. Read replicas are ideal for read scaling. For write-intensive scenarios, consider Multi-AZ or Aurora's clustering options.

---

*Summary: CL-KK-Terminal*  
This session covered advanced AWS scenarios, focusing on services like CloudFront, RDS, S3, IAM, and Lambda. Answers have been validated for accuracy; no major corrections needed beyond minor enhancements in validation notes. Images have been referenced where diagrams aid conceptual understanding.
