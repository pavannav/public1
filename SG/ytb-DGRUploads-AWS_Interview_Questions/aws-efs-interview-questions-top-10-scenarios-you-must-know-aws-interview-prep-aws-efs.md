# AWS EFS Interview Questions: Top 10 Scenarios You Must Know! AWS Interview Prep AWS EFS

## Question 1: What is AWS EFS and how is it different from Amazon S3 and EBS volumes?

**Answer:** AWS EFS stands for Elastic File System, a fully managed AWS service that allows shared storage accessible by multiple EC2 instances. It uses NFS (Network File System) protocols for network-based file sharing.

Key differences:
- **vs S3:** S3 is object storage optimized for durability and scalability, ideal for unstructured data. EFS supports directory hierarchies, POSIX compliance, and file system features.
- **vs EBS:** EBS is block storage tightly coupled to a single EC2 instance, not shareable. EFS can be shared across multiple instances.

**Note:** The answer is accurate. No correction needed.

## Question 2: What are the key features of AWS EFS?

**Answer:** 
- Automatic scaling: Increases/decreases capacity based on data added/removed.
- Shared access: Multiple EC2 instances can access the same file system concurrently.
- POSIX compliance: Supports standard Linux file system operations.
- Durability and high availability: Data stored across multiple availability zones for fault tolerance.
- Performance modes: General Purpose (default) and Max I/O.
- Lifecycle management: Automates moving infrequently accessed files to IA (Infrequent Access) storage class for cost reduction.

**Note:** Accurate description of features. Lifecycle management is a key automation feature.

## Question 3: How does AWS EFS handle security?

**Answer:** EFS provides:
- Encryption at rest and in transit.
- IAM policies for controlling access and management.
- VPC integration with security groups and NACLs for network-level traffic control.
- Integration with KMS (Key Management Service) for key generation and encryption.

**Note:** Comprehensive and correct. IAM policies and VPC controls are essential for access management.

## Question 4: What are the performance modes in AWS EFS and when would you use each?

**Answer:** 
- **General Purpose:** Default mode for latency-sensitive applications like web serving or CMS. Prioritizes low latency.
- **Max I/O:** For high-throughput and high-IOPS applications like big data analytics. Slightly higher latency than General Purpose.

**Note:** Correct usage scenarios. Choose based on latency tolerance vs. throughput needs.

## Question 5: Explain the cost model of AWS EFS.

**Answer:** Pricing based on:
- Storage usage: Higher cost for standard (frequently accessed) storage; lower for IA (infrequently accessed).
- Data transfer: Additional charges for cross-region or outbound transfers.
- Provisioned throughput: Optional payment for exceeding baseline throughput (if provisioned).

**Note:** Accurate. Note that bursting throughput is included up to a limit; provision only if needed.

## Question 6: How do you mount an EFS file system on an EC2 instance?

**Answer:** 
1. Create the EFS in the AWS console.
2. Install NFS utilities (e.g., nfs-utils or nfs-common) on the EC2 instance.
3. Run the mount command (e.g., `sudo mount -t nfs4 <efs-mount-target>:/ /mnt/efs`).
4. Verify with `df -h` to see the attached file system.

**Note:** Correct steps. Note that EFS mount targets must be in the same VPC as the EC2 instance.

## Question 7: What are the use cases of AWS EFS?

**Answer:** 
- Web hosting: Shared access to web server files by multiple EC2 instances.
- Big data analytics: Sharing data across compute nodes.
- Container storage: Persistent storage for ECS, EKS, or Kubernetes.
- Backup and archiving: Storing application backups with lifecycle policies.
- Media processing: Centralized storage for large media files accessed by multiple nodes.

**Note:** Excellent and accurate use cases. EFS is ideal for scenarios requiring shared file systems.

## Question 8: What is AWS EFS lifecycle management and how does it help optimize costs?

**Answer:** Lifecycle management automatically moves infrequently accessed data to the IA (Infrequent Access) storage class, which has lower storage costs while maintaining high availability and durability. It's designed for cost optimization in applications with data accessed infrequently.

**Note:** Correct. Transition policies can be set after specified days of no access.

## Question 9: Can you use EFS with containers AWS ECS or EKS?

**Answer:** Yes, EFS can be used as persistent storage for containers in ECS or EKS.
- For EKS: Use EFS CSI driver.
- For ECS: Define volumes in task definitions.

This enables sharing data across containers or tasks.

**Note:** Accurate. EFS integration allows stateful container workloads.

## Question 10: What are the limitations of AWS EFS?

**Answer:** 
- Region-bound: Limited to a single AWS region.
- Latency: Higher latency compared to block storage like EBS.
- Protocols: Supports only NFSv4 and 4.1.
- Compatibility: Primarily Linux-based with limited Windows support.

**Note:** Correct limitations. Windows support is emerging but still limited compared to Linux.

> **Additional Resources:** For visual overviews, see the AWS EFS documentation at https://docs.aws.amazon.com/efs/latest/ug/.

![EFS Architecture Diagram](images/efs-architecture.png)

![EFS Security Model](images/efs-security.png)

![EFS Performance Modes](images/efs-performance-modes.png)

<!---
<summary model='CL-KK-Terminal'>Processed AWS EFS transcript into Q&A format with validation notes and image references.</summary>
--->
