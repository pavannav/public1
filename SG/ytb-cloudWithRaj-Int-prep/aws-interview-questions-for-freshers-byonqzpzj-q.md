<details open>
<summary><b>AWS Interview Questions For Freshers (KK-CS45-script-v2-Interview)</b></summary>

## Q1
**Question:** Name two AWS services from each area: compute, storage, and network.

**Answer:** For compute: Lambda and EC2. For storage: S3 and EBS. For network: VPC and CloudFront.

**Ideal Answer:**
- **Compute:** AWS Lambda (serverless), Amazon EC2 (virtual servers)
- **Storage:** Amazon S3 (object storage), Amazon EBS (block storage)
- **Network:** Amazon VPC (virtual networking), Amazon CloudFront (CDN)

**Concept:** AWS organizes services into categories like compute (processing power), storage (data persistence), and networking (connectivity and distribution).

**Real-world Use Case:** A web application might use EC2 for web servers, S3 for storing images, and CloudFront to deliver content quickly to users worldwide.

**Advantages:** Covers fundamental AWS service categories; demonstrates basic AWS knowledge.

**Disadvantages:** Only scratches the surface; interviewers may ask for more services.

**Misconceptions:** Confusing EBS with EFS; thinking Route 53 is only for DNS when it's also network-related.

---

## Q2
**Question:** How to ensure you do not go over a certain budget for AWS bill?

**Answer:** Use AWS Budgets to set spending limits and get alerts. You can configure alerts to trigger when spending reaches 80% of your budget, and set up automated actions like SNS notifications or Lambda functions to shut down resources.

**Ideal Answer:** AWS Budgets allows you to:
- Set monthly/quarterly budget limits
- Configure alerts at threshold percentages (e.g., 80% of budget)
- Automate responses using SNS topics and Lambda functions
- Monitor projected vs actual spending

**Concept:** Cost management in cloud computing requires proactive monitoring and automated controls to prevent unexpected charges.

**Real-world Use Case:** A startup sets a $100/month budget with alerts at $80, automatically stopping non-critical EC2 instances when threshold is reached.

**Advantages:** Prevents bill shock; enables proactive cost management; supports automation.

**Disadvantages:** Requires initial setup; may impact service availability if automated shutdowns occur.

**Misconceptions:** Thinking AWS Free Tier prevents all charges; believing budgets automatically stop spending.

---

## Q3
**Question:** What is the alternative to doing everything from the AWS console?

**Answer:** AWS CLI for command-line operations, AWS SDKs for programmatic access from code, and Infrastructure as Code tools like CloudFormation or Terraform for automated deployments.

**Ideal Answer:**
1. **AWS CLI** - Command-line interface for resource management
2. **AWS SDKs** - Programmatic access from applications (Python, Java, etc.)
3. **Infrastructure as Code** - CloudFormation, Terraform, CDK for declarative infrastructure

**Concept:** Console provides GUI access, but automation and scalability require programmatic approaches.

**Real-world Use Case:** CI/CD pipelines using CLI commands or Terraform scripts to provision environments consistently across development, staging, and production.

**Advantages:** Enables automation; supports version control; improves reproducibility; allows infrastructure as code practices.

**Disadvantages:** Steeper learning curve; requires scripting knowledge; debugging can be complex.

**Misconceptions:** Believing console is only for learning; thinking CLI is slower than console operations.

---

## Q4
**Question:** Name some region-specific and global AWS services.

**Question Type:** [Inferred from context]

**Answer:** Regional services include EC2, Lambda, and EKS - these run in specific regions. Global services include IAM and CloudFront - these aren't bound to a single region.

**Ideal Answer:**
- **Regional:** EC2, Lambda, RDS, ECS, EKS (infrastructure-bound)
- **Global:** IAM, CloudFront, Route 53, WAF, Organizations (account-wide)

**Concept:** Some services need to be close to data/users (regional), while others provide account-level or edge-location services (global).

**Real-world Use Case:** IAM users/roles are global for consistent access across all regions, while EC2 instances are regional for low-latency access to regional data.

**Advantages:** Understanding global vs regional helps with architecture design and compliance requirements.

**Disadvantages:** Can cause confusion about service availability and data residency.

**Misconceptions:** Assuming all services are regional; thinking global services mean data is stored globally.

---

## Q5
**Question:** What AWS service is for metrics and logs?

**Answer:** CloudWatch handles application metrics and logs. CloudTrail handles infrastructure/API logs showing who did what in your AWS account.

**Ideal Answer:**
- **CloudWatch:** Application performance metrics, custom metrics, application logs
- **CloudTrail:** API calls, infrastructure changes, user actions, compliance auditing

**Concept:** Monitoring requires both operational metrics (performance) and audit logs (who did what).

**Real-world Use Case:** CloudWatch tracks application response times and error rates, while CloudTrail logs all IAM role changes for security auditing.

**Advantages:** Separation of concerns; CloudWatch for operations, CloudTrail for compliance and security.

**Disadvantages:** Additional cost for detailed logging; requires proper configuration.

**Misconceptions:** Using CloudTrail for application logs; thinking CloudWatch handles all AWS activity logging.

---

## Q6
**Question:** What AWS service is for object storage and block storage?

**Answer:** S3 for object storage (like a filing cabinet for files). EBS for block storage (like a hard drive attached to EC2 instances).

**Ideal Answer:**
- **Object Storage (S3):** Files, images, videos, backups - accessed via HTTP APIs
- **Block Storage (EBS):** Operating system drives, databases - low-level block access, attached to EC2

**Concept:** Different storage access patterns require different storage types for optimal performance and cost.

**Real-world Use Case:** Website images stored in S3, database files on EBS volumes attached to EC2 instances running the database.

**Advantages:** Right storage type for use case; cost optimization; performance matching.

**Disadvantages:** Choosing wrong storage type leads to poor performance or high costs.

**Misconceptions:** Using EBS for file sharing (should use EFS); storing frequently changing data in S3 Glacier.

---

## Q7
**Question:** What is the AWS service for virtual machines?

**Answer:** Amazon EC2 (Elastic Compute Cloud) provides virtual machines in the cloud.

**Ideal Answer:** EC2 provides resizable compute capacity with various instance types, operating systems, and configurations for diverse workloads.

**Concept:** Virtualization allows multiple virtual machines to run on physical hardware, providing flexibility and cost efficiency.

**Real-world Use Case:** Web servers, application servers, databases, development environments, batch processing jobs.

**Advantages:** Pay only for what you use; scalable; multiple OS support; various instance types for different workloads.

**Disadvantages:** Requires management overhead; instance sizing decisions; potential vendor lock-in.

**Misconceptions:** Confusing EC2 with Lambda; thinking EC2 is serverless.

---

## Q8
**Question:** What AWS service handles authentication and authorization?

**Answer:** AWS IAM (Identity and Access Management) controls who can access what resources and what actions they can perform.

**Ideal Answer:** IAM provides fine-grained access control through users, groups, roles, and policies defining permissions for AWS resources.

**Concept:** Security requires identifying users (authentication) and determining their permissions (authorization).

**Real-world Use Case:** Grant developers read-only access to production logs while allowing full access to development environments.

**Advantages:** Centralized access control; fine-grained permissions; supports role-based access; integrates with external identity providers.

**Disadvantages:** Complex policy management; potential for overly permissive policies; learning curve for policy syntax.

**Misconceptions:** Thinking IAM only controls user login; confusing IAM with Cognito for application user management.

---

## Q9
**Question:** What are popular databases in AWS?

**Answer:** DynamoDB (NoSQL), Amazon Aurora (MySQL/PostgreSQL compatible), RDS for traditional databases.

**Ideal Answer:**
- **DynamoDB:** Serverless NoSQL with single-digit millisecond performance
- **Aurora:** MySQL/PostgreSQL compatible with 5x performance improvement
- **RDS:** Managed MySQL, PostgreSQL, SQL Server, Oracle

**Concept:** Different applications need different database models - relational for structured data, NoSQL for flexible schemas and scale.

**Real-world Use Case:** E-commerce product catalog in DynamoDB, transaction records in Aurora, legacy system migration to RDS.

**Advantages:** Managed services reduce operational overhead; automatic backups; high availability options.

**Disadvantages:** Vendor-specific features; potential cost at scale; migration complexity.

**Misconceptions:** Assuming DynamoDB is only for simple key-value storage; thinking Aurora is a completely new database engine.

---

## Q10
**Question:** What is your favorite AWS service and why?

**Answer:** [Open-ended - should include specific service with detailed reasoning about features, use cases, and benefits]

**Ideal Answer:** Choose a service you understand deeply. Explain specific features you value, real problems it solves, and trade-offs compared to alternatives.

**Concept:** Interviewers assess depth of knowledge and ability to articulate technical preferences with reasoning.

**Real-world Use Case:** Lambda for event-driven architectures due to zero server management and automatic scaling.

**Advantages:** Demonstrates practical experience; shows analytical thinking; reveals actual usage patterns.

**Disadvantages:** Generic answers without reasoning appear superficial.

**Misconceptions:** Choosing services without explaining "why"; focusing only on popularity rather than specific benefits.

---

## Q11
**Question:** Name some AWS services that can secure your application.

**Answer:** IAM for access control, KMS for encryption, Certificate Manager for SSL/TLS, WAF for web application firewall, GuardDuty for threat detection.

**Ideal Answer:**
- **Identity:** IAM, Cognito
- **Encryption:** KMS, ACM
- **Network Security:** WAF, Shield, GuardDuty
- **Compliance:** Config, Security Hub

**Concept:** Application security requires multiple layers: identity management, data protection, network security, and threat detection.

**Real-world Use Case:** Financial application using IAM for user access, KMS for data encryption, WAF to block SQL injection, and GuardDuty for threat monitoring.

**Advantages:** Defense in depth; compliance with security standards; protection against common attack vectors.

**Disadvantages:** Complex configuration; potential false positives; additional costs.

**Misconceptions:** Thinking SSL certificates alone provide complete security; assuming IAM policies are sufficient without network security.

---

## Q12
**Question:** How will you scale your application running in EC2, Kubernetes, and Lambda?

**Answer:** EC2 uses Auto Scaling Groups based on metrics or schedules. Kubernetes uses HPA for pods and Cluster Autoscaler for nodes. Lambda scales automatically with no configuration needed.

**Ideal Answer:**
- **EC2:** Auto Scaling Groups with CPU/memory thresholds or scheduled scaling
- **Kubernetes:** HPA (Horizontal Pod Autoscaler) for pods, CA (Cluster Autoscaler) for nodes
- **Lambda:** Automatic scaling - one instance per concurrent request

**Concept:** Different compute platforms have different scaling mechanisms matching their architectural models.

**Real-world Use Case:** Web application scales EC2 instances during business hours, Kubernetes pods based on request queue depth, Lambda functions handle individual API calls automatically.

**Advantages:** Cost optimization through right-sizing; handles traffic spikes; improves reliability.

**Disadvantages:** Configuration complexity; potential over-provisioning; cold starts for some services.

**Misconceptions:** Thinking Lambda needs Auto Scaling Groups; confusing HPA with manual pod scaling.

---

## Q13
**Question:** Name three services to run your code in AWS.

**Answer:** EC2 (virtual machines), Lambda (serverless functions), and EKS/ECS (containers) or App Runner, Lightsail for simpler deployments.

**Ideal Answer:**
1. **EC2** - Full control over virtual machines
2. **Lambda** - Serverless event-driven functions
3. **EKS/ECS** - Container orchestration
4. **App Runner** - Simplified container deployment
5. **Lightsail** - Simple VPS for beginners

**Concept:** AWS offers multiple compute abstractions from raw VMs to fully managed serverless platforms.

**Real-world Use Case:** Monolith on EC2, microservices in EKS, event processing in Lambda, simple web apps in App Runner.

**Advantages:** Choice of abstraction level; cost optimization for different workloads; flexibility in deployment models.

**Disadvantages:** Decision paralysis; different operational models to learn.

**Misconceptions:** Assuming all workloads should use the same compute service; thinking serverless means no operations.

---

## Q14
**Question:** What are three ways to run Kubernetes in AWS?

**Answer:** Amazon EKS (managed Kubernetes), ROSA (Red Hat OpenShift on AWS), and self-managed Kubernetes on EC2 instances.

**Ideal Answer:**
1. **EKS** - AWS-managed Kubernetes control plane
2. **ROSA** - Managed OpenShift with Red Hat support
3. **Self-managed on EC2** - Full control over control plane and worker nodes

**Concept:** Kubernetes deployment options range from fully managed to complete self-management with varying levels of operational responsibility.

**Real-world Use Case:** Startups choose EKS for managed experience, enterprises use ROSA for OpenShift features, advanced teams run self-managed for custom requirements.

**Advantages:** Choice of management level; compliance with specific requirements; cost optimization based on team expertise.

**Disadvantages:** Trade-off between control and operational overhead.

**Misconceptions:** Thinking EKS means no Kubernetes knowledge needed; assuming self-managed is always cheaper.

---

## Q15
**Question:** What is AWS Region, Availability Zone, and Point of Presence?

**Answer:** [Reference to AWS documentation - common interview topic requiring study of official docs]

**Ideal Answer:**
- **Region:** Geographic area with multiple AZs (e.g., us-east-1)
- **Availability Zone:** Isolated data center within a region for fault tolerance
- **Point of Presence:** Edge locations for services like CloudFront

**Concept:** AWS infrastructure geography affects latency, compliance, disaster recovery, and service availability.

**Real-world Use Case:** Multi-AZ deployments for high availability, regional selection for data residency compliance, edge locations for global content delivery.

**Advantages:** Understanding infrastructure helps with architecture decisions and compliance requirements.

**Disadvantages:** Complex to understand initially; requires ongoing education as AWS expands.

**Misconceptions:** Confusing AZs with regions; thinking all services are available in all AZs.

</details>