# Top 15 AWS Security Interview Questions & Answers _ Must-Know AWS Security Concepts for 2024! AWS

## 1. What is AWS Identity and Access Management (IAM) and why is it important?

**Answer:** AWS Identity and Access Management (IAM) is AWS's backbone for securely managing access to your AWS resources. It allows you to create users, groups, and roles, and define permissions with policies to control who can access AWS services and resources. IAM is important because it ensures fine-grained access control, enhances the security of your accounts, and enforces the principle of least privilege by granting only the permissions needed to perform specific tasks.

### Note
The answer is accurate. A better phrasing could emphasize that IAM provides centralized control of access to AWS services and resources, supporting features like multi-factor authentication (MFA) for enhanced security.

## 2. What is the principle of least privilege and how does AWS implement it?

**Answer:** The principle of least privilege ensures that users and services are only granted the minimum permissions necessary to perform their tasks. AWS implements this through IAM policies, Service Control Policies (SCPs), and permission boundaries, which help minimize security risks by restricting unnecessary access.

### Note
The answer is correct. To expand, mention that SCPs are only available in AWS Organizations and apply to member accounts, while permission boundaries set the maximum permissions even if IAM policies grant more.

## 3. How does AWS secure data in transit and at rest?

**Answer:** Data in transit is encrypted using SSL or TLS protocols. For data at rest, AWS offers multiple encryption options including Server-Side Encryption (SSE) for S3 buckets, EBS encryption for EBS volumes, and KMS keys for databases and custom encryptions. You can use AWS Key Management Service (KMS) to create your own keys and encrypt EBS volumes, RDS databases, and S3 data.

### Note
The answer is accurate but could specify SSE-KMS (for SSE with KMS keys) and SSE-S3 (Amazon S3 managed keys). For transit, mention that HTTPS is used by default in AWS services, and data can also be secured with VPNs or Direct Connect.

## 4. What is AWS Key Management Service (KMS) and its use cases?

**Answer:** AWS Key Management Service (KMS) is AWS's centralized encryption key service for creating, managing, and controlling encryption keys. It is commonly used to encrypt data in S3 buckets, EBS volumes, RDS databases, and other services. KMS's ability to integrate seamlessly with AWS services makes it essential for securing data.

### Note
Correct. KMS supports symmetric and asymmetric keys, and key policies can control access. It's also used for envelope encryption, where data keys encrypt data and master keys from KMS encrypt the data keys.

## 5. How does AWS handle DDoS attacks?

**Answer:** AWS provides multiple layers of protection, including AWS Shield (with a standard free version and an advanced paid version) to protect against Distributed Denial of Service (DDoS) attacks. It pairs well with Amazon CloudFront and Route 53. CloudFront enables caching and geo-restrictions to mitigate attacks, while Route 53 can avoid attack formations.

### Note
Accurate. Note that AWS WAF can also mitigate DDoS by blocking common attack patterns. AWS Global Accelerator and Elastic Load Balancing also contribute to DDoS protection.

## 6. What is AWS Security Hub and how does it help AWS security?

**Answer:** AWS Security Hub is a centralized, unified view for monitoring and assessing your AWS security posture. It aggregates security alerts, performs compliance checks, and provides insights across multiple accounts. You can monitor compliance issues and security alerts from one single point.

### Note
Correct. It integrates findings from services like GuardDuty, Config, and Inspector, normalizing them into a common format for easier management and automatic remediation workflows.

## 7. How do you secure an S3 bucket?

**Answer:** Secure an S3 bucket by enabling bucket policies and IAM policies for controlled access, bucket versioning to avoid accidental deletions, server-side encryption for data security, Block Public Access settings to prevent accidental public access, and using AWS CloudTrail and S3 access logs for activity logging and auditing.

### Note
Good answer. Additionally, enable MFA delete for versioning to prevent unauthorized deletions, use S3 Object Lock for immutable storage, and consider Access Analyzer to review bucket access policies for potential security gaps.

## 8. What are AWS Organizations and how do they enhance security?

**Answer:** AWS Organizations is a service for centrally managing multiple AWS accounts. It enhances security by using Service Control Policies (SCPs) to enforce organization-wide access restrictions. It also provides centralized billing for multiple accounts and controls permissions across accounts via SCPs.

### Note
Accurate. SCPs are effective at setting boundaries for all IAM entities in member accounts, allowing for hierarchical management of permissions and enabling features like consolidated billing and cross-account roles.

## 9. What is AWS WAF and how does it work?

**Answer:** AWS WAF (Web Application Firewall) is a security service that protects web applications from common threats like SQL injections and cross-site scripting (XSS). To use WAF, you create rules to allow, block, or monitor traffic based on conditions such as blocking traffic from certain IPs, query strings, headers, or allowing specific headers. WAF acts as a firewall for your web applications.

### Note
Correct. Mention that WAF integrates with CloudFront, ALB, API Gateway, etc. Rules can be based on IP addresses, country origins, request sizes, and more, with managed rule groups from AWS or third parties.

## 10. What is Amazon GuardDuty?

**Answer:** Amazon GuardDuty is a threat detection service that monitors for malicious activity and delivers detailed security findings, such as compromised accounts, unusual API activity, or unauthorized data access, helping to identify and respond to security threats in your AWS account.

### Note
Accurate. GuardDuty uses machine learning and threat intelligence to analyze CloudTrail logs, VPC Flow Logs, and DNS logs, providing findings that can trigger automated responses via EventBridge.

## 11. How do you ensure compliance with AWS?

**Answer:** Ensure compliance by using AWS Config to track resource compliance with predefined rules, conducting regular audits with AWS Security Hub and AWS Artifact. Enable logging and monitoring with AWS CloudTrail and Amazon CloudWatch to ensure compliance through documentation, continuous assessments, and auditing.

### Note
Good answer. AWS Artifact provides access to compliance reports from AWS auditors, and Config Rules can be custom or AWS managed. Consider using AWS Audit Manager for more comprehensive compliance reporting.

## 12. What is the difference between Security Groups and NACLs?

**Answer:** Both are firewalls in Amazon VPC. Security Groups act at the instance level, are attached to EC2 instances, and are stateful, meaning outbound and return traffic is automatically allowed when you define inbound rules. Network Access Control Lists (NACLs) operate at the subnet level and are stateless, requiring explicit definition of both inbound and outbound rules; otherwise, traffic may not flow properly.

### Note
Correct. Security Groups can reference other security groups and self-referencing rules, while NACLs are numbered rules processed in order, with an implicit deny at the end. Remember, security groups are the primary defense, and NACLs provide an additional layer.

## 13. What are IAM roles and how are they different from users?

**Answer:** IAM roles provide temporary access to AWS resources with temporary credentials that expire after use. Users are permanent users with permanent credentials until deleted. Roles can be assumed temporarily by users or other entities for elevated permissions, while users have persistent access and credentials.

### Note
Accurate. Roles don't have standard long-term credentials; they are assumed dynamically. Use roles for applications running on EC2 or for cross-account access to avoid hard-coding credentials.

## 14. How do you monitor security in AWS?

**Answer:** Monitor security by using AWS CloudTrail for logging API activities, AWS Config for compliance monitoring, and Amazon Detective for analyzing and investigating security threats across your AWS account.

### Note
Good answer. Also integrate AWS Security Hub for aggregated findings, AWS Inspector for EC2 assessments, and GuardDuty for anomaly detection. CloudWatch can monitor metrics and set alarms for security events.

## 15. How do you secure RDS databases in AWS?

**Answer:** Secure RDS databases by enabling encryption at rest using AWS KMS keys, using VPC security groups to control inbound and outbound traffic, disabling public access unless required, using SSL/TLS connections, and enabling RDS backups for data recovery and restoration.

### Note
Correct. Additionally, enable Multi-AZ deployments for high availability, use RDS Proxy to manage connections and reduce attack surfaces, and regularly update DB instances. For auditing, enable enhanced monitoring and RDS logs.
