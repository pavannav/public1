<details open>
<summary><b>AWS Services for Solutions Architects (KK-CS45-script-v2-Interview)</b></summary>

## Overview
This study guide covers essential AWS services organized by application architecture layers, from migration through monitoring and security.

## Q1
**Question:** What AWS services are needed to migrate on-premises servers to AWS?

**Answer:** Two key services: Application Discovery Service (ADS) discovers servers and databases running on-premises, then Application Migration Service (MGN) migrates discovered servers to EC2 instances on AWS. ADS provides the inventory while MGN handles the actual replication and migration.

## Ideal Answer
**AWS Migration Services:**
- **Application Discovery Service (ADS)**: Agent-based or agentless discovery of on-premises infrastructure, gathers server specs, dependencies, and performance metrics
- **Application Migration Service (MGN)**: Lift-and-shift migration tool that continuously replicates servers to AWS, enables cutover with minimal downtime
- **Database Migration Service (DMS)**: Migrates databases with minimal downtime, supports homogeneous and heterogeneous migrations

**Practical Example:**
```
Migration Flow:
1. Install ADS agent on source servers
2. ADS discovers: 50 VMs, 10 databases, dependencies
3. MGN creates replication servers in AWS
4. Continuous block-level replication
5. Test migrated instances
6. Cutover during maintenance window
```

## Q2
**Question:** How do you scale applications on AWS beyond EC2 Auto Scaling Groups?

**Answer:** Modern scaling approaches include container orchestration with EKS (Elastic Kubernetes Service) for microservices architectures, and serverless compute with Lambda for event-driven workloads. These provide automatic scaling without infrastructure management.

## Ideal Answer
**Compute Scaling Options:**
- **EC2 + Auto Scaling Groups**: Traditional VMs with horizontal scaling based on CloudWatch metrics
- **EKS (Elastic Kubernetes Service)**: Managed Kubernetes for containerized applications, auto-scaling pods and nodes
- **Lambda**: Serverless functions that scale from zero to thousands automatically

**Use Cases:**
- EKS: Microservices, CI/CD pipelines, ML workloads
- Lambda: APIs, data processing, IoT backends, scheduled tasks

## Q3
**Question:** What databases should Solutions Architects know for interviews?

**Answer:** At minimum, one SQL and one NoSQL database. RDS for relational workloads (MySQL, PostgreSQL, Oracle, SQL Server) and DynamoDB for NoSQL needs. DynamoDB integrates especially well with serverless architectures.

## Ideal Answer
**Database Services:**
- **RDS (Relational Database Service)**: Managed SQL databases with automated backups, multi-AZ, read replicas
- **DynamoDB**: Serverless NoSQL with single-digit millisecond latency, auto-scaling, global tables

**Trade-offs:**
- RDS: ACID compliance, complex queries, joins | Higher operational overhead than DynamoDB
- DynamoDB: Schemaless, scales horizontally | Limited query flexibility, eventual consistency options

## Q4
**Question:** How should you handle static content and large files in AWS architecture?

**Answer:** S3 (Simple Storage Service) buckets store unstructured data like images, videos, documents. Use cases include YouTube thumbnails, product images on Amazon, and backup files. S3 provides 99.999999999% durability with lifecycle policies for cost optimization.

## Ideal Answer
**Storage Strategy:**
- **S3**: Object storage for unstructured data, static website hosting, data lake storage
- **Use Cases**: Media files, user uploads, logs, backups, data analytics
- **Features**: Versioning, lifecycle policies, cross-region replication, encryption

## Q5
**Question:** What load balancing options exist on AWS and when to use each?

**Answer:** Three main options: Application Load Balancer (ALB) for HTTP/HTTPS traffic with path-based routing, Network Load Balancer (NLB) for TCP/UDP traffic needing ultra-low latency, and API Gateway for REST/HTTP APIs with built-in authentication and throttling.

## Ideal Answer
**Load Balancing Services:**
- **ALB**: Layer 7, path-based routing, WebSocket support, target groups with health checks
- **NLB**: Layer 4, millions of requests/second, static IP, TLS termination
- **API Gateway**: Managed API service, authentication (Cognito, IAM), rate limiting, caching

**Selection Criteria:**
- ALB: Web applications, microservices
- NLB: Gaming, IoT, high-throughput TCP
- API Gateway: Public APIs, serverless backends

## Q6
**Question:** What services enable event-driven architecture on AWS?

**Answer:** Three core services: SQS for reliable message queuing, SNS for pub/sub notifications, and EventBridge for event routing between services. These enable decoupled, asynchronous communication patterns.

## Ideal Answer
**Event-Driven Services:**
- **SQS**: Managed message queues, dead-letter queues, exactly-once processing
- **SNS**: Fan-out notifications, email/SMS/push delivery, message filtering
- **EventBridge**: Event bus, rules engine, 200+ AWS service integrations

**Architecture Pattern:**
```
Producer → SNS/SQS → Multiple Consumers
EventBridge → Lambda/Step Functions
```

## Q7
**Question:** How do you implement workflow orchestration on AWS?

**Answer:** Step Functions provides serverless workflow orchestration for multi-step processes with branching logic, error handling, and parallel execution. Ideal for order processing, data pipelines, and approval workflows.

## Ideal Answer
**Step Functions:**
- **Features**: Visual workflow designer, 200+ integrations, error handling, parallel execution
- **States**: Task, Choice, Wait, Parallel, Map, Succeed/Fail
- **Use Cases**: ETL pipelines, order fulfillment, compliance workflows

## Q8
**Question:** What monitoring and observability services are essential?

**Answer:** CloudTrail logs all API calls for audit trails, while CloudWatch captures application metrics, logs, and alarms. Together they provide complete infrastructure and application observability.

## Ideal Answer
**Observability Stack:**
- **CloudTrail**: API audit logging, compliance, security analysis
- **CloudWatch**: Metrics, logs, alarms, dashboards, Log Insights
- **Integration**: All AWS services emit metrics to CloudWatch, CloudTrail logs feed into CloudWatch Logs

**Alert Flow:**
```
Application Error → CloudWatch Alarm → SNS Notification → Support Team
```

## Q9
**Question:** What security services should Solutions Architects master?

**Answer:** Core security triad: Cognito for user authentication/authorization, KMS for encryption key management, and IAM for access control. Additional services include WAF, Shield, GuardDuty, and Secrets Manager for comprehensive security.

## Ideal Answer
**Security Services:**
- **Cognito**: User pools, identity pools, OAuth/OIDC integration
- **KMS**: Customer-managed keys, automatic rotation, audit logging
- **IAM**: Roles, policies, least privilege, cross-account access
- **WAF**: SQL injection, XSS protection, rate limiting
- **Shield**: DDoS protection, cost protection
- **GuardDuty**: ML-based threat detection
- **Secrets Manager**: Database credentials, API keys rotation

## Q10
**Question:** How do you optimize costs on AWS?

**Answer:** Use Compute Optimizer for recommendations based on CloudWatch metrics, Spot Instances for fault-tolerant workloads (up to 90% discount), Reserved Instances for predictable usage, and Savings Plans for flexible compute savings.

## Ideal Answer
**Cost Optimization:**
- **Compute Optimizer**: Right-sizing recommendations, idle resource detection
- **Spot Instances**: Batch processing, CI/CD, stateless applications
- **Reserved Instances**: 1-3 year commitments, up to 72% savings
- **Savings Plans**: Compute/hourly spend commitments, application flexibility

**Savings Example:**
```
On-Demand: $1000/month
Reserved Instance: $400/month (60% savings)
Spot Instance: $100/month (90% savings)
```

## Q11
**Question:** How should infrastructure be provisioned on AWS?

**Answer:** Infrastructure as Code (IaC) using CloudFormation for native AWS templates, CDK for programming language-based infrastructure, or Terraform for multi-cloud deployments. Essential for reproducibility and version control.

## Ideal Answer
**IaC Options:**
- **CloudFormation**: Native AWS, JSON/YAML templates, drift detection
- **CDK**: TypeScript/Python constructs, higher-level abstractions
- **Terraform**: Multi-cloud, state management, extensive providers

**Benefits:**
- Version control, code review, automated deployments
- Environment parity, disaster recovery
- Cost estimation before deployment

## Common Misconceptions
- **"EC2 is sufficient for all compute needs"**: Modern applications benefit from containers and serverless
- **"All databases should be relational"**: NoSQL often provides better scalability for specific use cases
- **"Security is just IAM policies"**: Comprehensive security requires multiple layered services
- **"Cost optimization is only about choosing cheaper options"**: Right-sizing and architecture decisions matter more

</details>