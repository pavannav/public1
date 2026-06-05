<details open>
<summary><b>Amazon Interview Tips - Sample AWS GCP Azure Questions and Answers Good vs Bad Answer (KK-CS45-script-v2-Interview)</b></summary>

## Q1
**Question:** How can you make your application scalable for a big traffic day?

**Answer:** A subpar answer is to put virtual machines in an auto scaling group and use a load balancer. This is considered basic because five years ago it would have been good, but now there are many more considerations beyond auto scaling groups for handling huge traffic days.

## Q2
**Question:** [Inferred Question] What is a good answer for scaling applications during high traffic events?

**Answer:** A good answer should briefly touch on two factors: the limit of scaling (peak traffic the application must accommodate) and the rate of scaling (how fast traffic will increase). Pre-warm load balancers based on peak traffic or rate of traffic increase. If traffic increases from 0 to 50,000 in a couple of seconds, the load balancer needs time to warm up, so pre-warming prevents throttling. For EC2, use auto scaling groups but ensure the AMI is lightweight and doesn't take long to spin new instances. Select the appropriate EC2 family type based on workload (compute-heavy or memory-heavy). Applications should ideally have microservices architecture so each service can scale independently. For containers, use request limits, horizontal pod autoscaler, cluster autoscaler, and cluster over-provisioner for Kubernetes. For serverless, use provisioned concurrency. Check account limits - if peak traffic concurrency exceeds account limits, work with the cloud provider to raise limits or re-architect. Also discuss database scaling: for SQL databases use read replicas for read queries, optimize queries, use caching; for NoSQL like DynamoDB, use DynamoDB Accelerator if applicable and switch to on-demand mode. AWS-specific tip: run IEM (Infrastructure Event Management) where AWS conducts load tests to ensure everything works smoothly.

## Q3
**Question:** How can I run my website on cloud?

**Answer:** A subpar answer is to deploy your web server and application server on virtual machines (e.g., AWS EC2), then use load balancer and auto scaling group. This is not good because it's pretty generic lift-and-shift, missing opportunities to impress interviewers on newer services and knowledge, and will lead to follow-up questions on scaling, cost, and security.

## Q4
**Question:** [Inferred Question] What is a good approach to running websites on cloud using modern methods?

**Answer:** There are multiple ways depending on project requirements. For teams new to cloud, virtual machines can be used, but serverless or containers represent modern approaches. When explaining serverless, highlight advantages: no need to manage scaling, highly available without creating VMs in multiple availability zones, and pay-per-use model. Alternatively, explain using containers or other modern methods like AWS Amplify based on your knowledge. If the interviewer specifically asks about lift-and-shift, discuss virtual machines, but if open-ended, there's a great chance to impress with knowledge of modern approaches.

## Q5
**Question:** What is the difference between SQL and NoSQL?

**Answer:** The most common answer is that SQL holds structured data and NoSQL holds unstructured data, you can define indexes and run queries on SQL, SQL is good for transactional systems, and NoSQL is best for logging. This is bad because it's very basic - just stating "structured versus unstructured" doesn't give much clarity, doesn't highlight strengths of modern NoSQL databases, and modern NoSQL databases like DynamoDB support indexes and can be used in transactional systems too.

## Q6
**Question:** [Inferred Question] What are the key differences between SQL and NoSQL databases?

**Answer:** SQL has a predefined schema while NoSQL doesn't. Go over ACID versus CAP theorem properties, different scaling behavior, use cases, and examples. You can even reference case studies where companies run both SQL and NoSQL effectively.

## Q7
**Question:** How do you secure your application on cloud?

**Answer:** A bad answer focuses on using authorization and authentication to ensure proper people or applications can access what they should access. This is bad because the interviewer is asking about cloud-specific security mechanisms, not application-level processes like authentication and authorization which must be implemented whether running on-premise or in the cloud.

## Q8
**Question:** [Inferred Question] What are the key cloud security considerations for applications?

**Answer:** Always mention there are two aspects: securing data at rest and securing data in transit. For data at rest, use KMS encryption. For maximum flexibility, use customer-managed CMK. Mention client versus server-side encryption approaches. AWS-specific security services include IAM for identity and access management, Security Groups and NACLs for network-level security, WAF for web application firewall protection, GuardDuty for threat detection, Inspector for vulnerability assessment, and Secrets Manager for credential management. Data in transit should be encrypted using TLS/SSL. Implement proper network isolation using VPCs, subnets, and route tables. Use IAM roles instead of long-term credentials for EC2 instances. Implement least privilege access principles. Enable CloudTrail for API activity logging and CloudWatch for monitoring. Use AWS Config for compliance monitoring. Consider implementing encryption at multiple layers. For databases, enable encryption at rest and in transit. Use Parameter Store or Secrets Manager for managing application secrets. Implement proper backup and disaster recovery strategies. Consider using AWS Shield for DDoS protection. Regularly rotate credentials and implement proper key management practices.

</details>