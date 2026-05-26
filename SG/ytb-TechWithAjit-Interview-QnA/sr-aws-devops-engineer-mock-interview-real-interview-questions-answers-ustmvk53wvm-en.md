<details open>
<summary><b>Sr. AWS DevOps Engineer Mock Interview - Real Interview Questions & Answers (KK-CS45-script-v2-Interview)</b></summary>

# Sr. AWS DevOps Engineer Mock Interview Study Guide

> **Session Type:** A - Trainer/interviewer led discussion of interview questions and answers  
> **Duration:** ~1 hour mock interview  
> **Interviewee:** Hussein Lokhandwala (4.5 years DevOps experience, AWS/K8s/Terraform/Azure certified)  
> **Interviewer:** Ajit (14 years IT experience, leading technology team)

---

## Q1: Tell me about yourself

### Answer
- **Hussein:** 4.5+ years DevOps experience starting 2021 as junior DevOps
- Worked 1.5 years at first company, then moved to current role as Senior DevOps Engineer
- Day-to-day: Supports US client in Agile methodology, manages tickets, assigns work to junior DevOps, creates POCs
- **Certifications:** AWS, Kubernetes, Terraform, Azure
- **Strengths:** Passionate about solving complex problems and architecting new solutions

### Interviewer Context
- **Ajit:** 14 years IT experience across domains/geographies
- First 6-7 years: Full-stack development
- Next 4-5 years: Cloud platform engineering, solutioning, cloud leadership
- Current: Leading entire technology unit (1.5 years)

---

## Q2: How would you architect a fully available and fault-tolerant application on AWS?

### Answer Structure

**Assumptions made:**
- Data analytics application requiring many services
- Selected **EKS** as compute platform

**Architecture Components:**

### 1. Networking
- **VPC Design:** Multi-AZ setup with private and public subnets
  - **Private subnets:** Compute (EKS nodes), Database (RDS)
  - **Public subnets:** Application Load Balancer, NAT Gateway, Bastion hosts
- **Security:** NACLs and Security Groups configured appropriately
- **Cross-region:** Setup for disaster recovery

### 2. Storage
- **S3:** Primary object storage with **cross-region replication** enabled
- **RDS:** 
  - Read replicas in cross-region for DR
  - Multi-AZ deployment for high availability
- **DynamoDB:** Alternative if application supports global tables

### 3. Compute - EKS (Primary Choice)
**Why EKS over ECS?**
- **Security advantages:**
  - RBAC rules for fine-grained access control
  - Network policies for pod-level security
  - More customization options beyond AWS ecosystem
- **Deployment & Operations:**
  - ArgoCD integration for GitOps workflows
  - Easy rollbacks with GitOps
  - Cross-region node deployments supported
- **Scalability:** Better for complex, enterprise-grade architectures

**Why not EC2?**
- More operational overhead
- Manual patching, scaling, HA management required

### 4. Cross-Region Setup
- **Primary region:** Full EKS cluster with active workloads
- **Secondary region:** 
  - EKS cluster deployed (can scale to zero when idle)
  - RDS read replica for data sync
  - S3 replication for object storage
  - ArgoCD for application deployment

### Notes

> **Validation:** Answer is **correct and comprehensive**. Covers core AWS pillars (compute, storage, networking, security) with clear rationale for technology choices.

> **Alternative consideration:** ECS could be acceptable for simpler applications where AWS-native IAM policies suffice and operational complexity is lower. Cost comparison: ECS is cheaper (only pay for underlying infrastructure); EKS has cluster management fee (~$0.10/hour per cluster).

---

## Q3: When would ECS be better suited than EKS?

### Answer
**ECS is preferable when:**
1. **Simple deployments** with few services
2. **AWS-only ecosystem** - all access management via IAM policies and task definitions
3. **No complex requirements** - no need for ingress controllers, service mesh, or advanced networking
4. **Cost-sensitive workloads** - ECS is cheaper (no cluster management fee)
5. **Manageable within AWS** - sufficient to define routes in ALB and task definitions

### Notes

> **Validation:** Answer is **correct**. ECS shines in simplicity and cost, while EKS excels in flexibility, security granularity, and complex orchestration needs.

---

## Q4: How do you make a subnet public or private?

### Answer
**Route Tables determine subnet type:**

**Public Subnet:**
- Route table includes route: `0.0.0.0/0` → **Internet Gateway**
- Resources can directly access internet
- Must be attached to VPC's Internet Gateway

**Private Subnet:**
- Route table includes route: `0.0.0.0/0` → **NAT Gateway**
- Resources access internet via NAT (outbound only)
- NAT Gateway placed in public subnet
- No direct inbound internet access

**Key Points:**
- Internet Gateway is attached to **VPC** (not subnet directly)
- NAT Gateway is placed in **public subnet** to provide outbound internet for private subnets
- Outbound rules for private subnet traffic are defined in the **private subnet's route table**

### Notes

> **Validation:** Answer is **correct**. Internet Gateway attachment to VPC is accurate. NAT Gateway placement in public subnet is standard AWS architecture.

---

## Q5: What hybrid networking options exist to connect on-premises to AWS?

### Answer

| Option | Use Case | Cost | Description |
|--------|----------|------|-------------|
| **AWS Direct Connect** | High-volume, consistent workloads | Higher | Dedicated network connection from on-prem to AWS |
| **Site-to-Site VPN** | Moderate workloads | Lower | IPsec VPN tunnel between customer gateway and AWS VPN gateway |
| **Transit Gateway** | Multiple VPCs + on-prem | Moderate | Hub-and-spoke model for centralized connectivity |
| **VPC Peering** | VPC-to-VPC within AWS | Low | Direct VPC connection (not hybrid, intra-AWS only) |

**Selection Criteria:**
- **Direct Connect:** Tons of data transfer, production workloads requiring consistent latency
- **Site-to-Site VPN / Transit Gateway:** Lower data volume, cost-sensitive scenarios

### Notes

> **Validation:** Answer is **correct**. Transit Gateway and AWS hub services mentioned are accurate options.

---

## Q6: VPC Peering vs Transit Gateway - When to use each?

### Answer

**VPC Peering:**
- **Best for:** Connecting 2 VPCs
- **Limitation:** Not transitive - must create peering between every pair (A↔B, A↔C, B↔C)
- **Cost:** Cheaper data transfer

**Transit Gateway:**
- **Best for:** Connecting 3+ VPCs (hub-and-spoke model)
- **Advantage:** Single transit gateway connects to all VPCs; all VPCs communicate through TGW
- **Cost:** Higher data transfer costs than VPC peering
- **Use case:** Centralized connectivity management for multiple VPCs

**Decision Matrix:**
- 2 VPCs → VPC Peering (simpler, cheaper)
- 5-10 VPCs → Transit Gateway (manageable, scalable)

### Notes

> **Validation:** Answer is **correct and well-articulated**. Hub-and-spoke model accurately describes Transit Gateway architecture.

---

## Q7: Design a Disaster Recovery solution for an e-commerce website

### Answer

**Step 1: Determine RTO/RPO Requirements**

**Scenario A: Cost-Optimized (Some Downtime Acceptable)**
- **Solution:** Backup & Recovery
- Process: Regular backups of EKS, RDS, S3
- Recovery: Spin up new EKS + RDS in DR region, restore from backup, update DNS
- **Trade-off:** Cheaper, longer RTO

**Scenario B: Reduced Downtime (Minutes)**
- **Solution:** Pilot Light / Warm Standby
- RDS: Read replica in DR region (continuous replication)
- EKS: Cluster deployed but nodes scaled to zero
- Recovery: Scale up EKS nodes, promote read replica, update DNS
- **Trade-off:** Moderate cost, faster recovery than backup

**Scenario C: Zero Downtime (Active-Active)**
- **Solution:** Multi-Site Active/Active
- Both regions fully scaled with production workloads
- Route 53 health checks with failover policies
- Application Load Balancer health checks trigger automatic traffic diversion
- RDS: Multi-AZ + cross-region read replicas
- **Trade-off:** Highest cost, lowest RTO (~0)

### Notes

> **Validation:** Answer is **comprehensive and accurate**. Covers all three standard DR patterns (Backup & Restore, Pilot Light, Multi-Site Active/Active) with correct AWS service mappings.

---

## Q8: Design a global multi-region architecture with minimal latency

### Answer

**Requirements:**
- E-commerce accessed from US and India
- Minimum latency for each region
- Separate databases per region (geo-isolated writes)

**Architecture:**

### 1. Frontend - CDN Layer
- **CloudFront:** Global CDN caches static assets at edge locations
- Reduces latency by serving content from nearest PoP

### 2. Application Layer - Global Load Balancing
- **Global Accelerator or Route 53 with latency-based routing**
- Routes requests to nearest regional ALB
- Health checks ensure traffic only routes to healthy regions

### 3. Caching Layer
- **ElastiCache / Redis:** Regional caches reduce database load
- Cache query results in each region

### 4. Database Layer - Multi-Master Writes
- **DynamoDB Global Tables:** 
  - Multi-region, multi-master writes
  - Eventually consistent across regions
  - Low-latency reads/writes from any region
- **Alternative:** RDS with read replicas (read scaling only, writes go to primary)

### Notes

> **Validation:** Answer is **correct**. Interviewer noted that DynamoDB Global Tables solve the multi-write problem that CDN + ElastiCache cannot address. RDS with read replicas doesn't support multi-region writes.

---

## Q9: Security Best Practices by AWS Service Area

### Networking Security
- **AWS Shield:** DDoS protection (standard free, advanced paid)
- **AWS WAF:** Web Application Firewall with custom rules (SQL injection, XSS, rate limiting)
- **VPC Flow Logs:** Enable to monitor and audit all network traffic
- **NACLs + Security Groups:** Defense-in-depth network access control
- **Private subnets:** Never expose databases/compute directly to internet

### Compute Security (EKS/ECS)
- **IAM Roles for Service Accounts (IRSA):** Fine-grained pod-level permissions in EKS
- **RBAC:** Kubernetes role-based access control
- **Network Policies:** Kubernetes-native pod network segmentation
- **Secrets Management:** Use AWS Secrets Manager or Parameter Store, never hardcoded secrets
- **Image Scanning:** Enable ECR scanning or Trivy/Clair for container vulnerabilities

### Storage Security
- **S3:**
  - Block public access (account-level and bucket-level)
  - Enable encryption at rest (SSE-S3 or SSE-KMS)
  - Enable versioning for ransomware protection
  - Bucket policies with least privilege
- **EBS:** Enable encryption at rest
- **RDS:** Encryption at rest + encryption in transit (SSL/TLS)
- **DynamoDB:** Enable encryption at rest (customer-managed or AWS-managed keys)

### General Best Practices
- **Least Privilege IAM:** Grant minimum required permissions
- **Multi-Factor Authentication (MFA):** Enforce for all users
- **CloudTrail + Config:** Audit logging and compliance monitoring
- **GuardDuty:** Threat detection service
- **Inspector:** Vulnerability assessments

### Notes

> **Validation:** Answer is **comprehensive**. Covers security across all major AWS service categories with specific, actionable recommendations.

---

## Key Interview Takeaways

### Strengths Demonstrated
1. **Clear architectural reasoning** - Justified EKS choice with security, GitOps, and flexibility arguments
2. **Practical DR knowledge** - Distinguished between cost-optimized, reduced-downtime, and zero-downtime patterns
3. **Networking fundamentals** - Accurate understanding of subnets, route tables, NAT vs IGW
4. **Global architecture patterns** - Correctly identified CDN, Global LB, and Global Tables for multi-region

### Areas for Improvement
1. **Cost optimization discussion** - Could elaborate on reserved instances, spot instances, Savings Plans
2. **Observability** - Mention CloudWatch, X-Ray, Prometheus/Grafana for monitoring
3. **CI/CD pipeline** - Could discuss CodePipeline, Jenkins, or GitHub Actions integration
4. **State management** - Terraform state locking, remote backends for infrastructure-as-code

### Common Follow-up Topics
- How would you implement blue-green or canary deployments?
- Explain your approach to secrets management in Kubernetes
- How do you handle database migrations in a zero-downtime deployment?
- Describe your monitoring and alerting strategy

---

</details>