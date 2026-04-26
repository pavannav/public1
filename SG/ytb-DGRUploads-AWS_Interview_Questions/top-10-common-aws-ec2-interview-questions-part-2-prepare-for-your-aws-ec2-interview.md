# Top 10 Common AWS EC2 Interview Questions - Part 2 _ Prepare for Your AWS EC2 Interview

## Question 1: What is the difference between on-demand, reserved, and spot instances?

**Answer Explanation:**
- **On-demand instances**: Follow a pay-as-you-go model with no upfront commitment. You pay by the second or hour for the compute capacity used, ideal for unpredictable workloads.
- **Reserved instances**: Require a 1- or 3-year commitment, offering significant cost savings (up to 70% discount compared to on-demand). Best for steady-state workloads.
- **Spot instances**: Spare EC2 capacity offered at a discount based on supply and demand. Instances can be interrupted when supply diminishes, suitable for fault-tolerant applications.

**Note**: This answer accurately covers the key differences. For production workloads requiring high availability, on-demand or reserved instances are preferred over spot instances due to potential interruptions.

## Question 2: How can you move an EC2 instance from one region to another?

**Answer Explanation:**
There is no direct method to migrate an EC2 instance between regions. As a workaround:
1. Launch a new EC2 instance in the target region.
2. Create an EBS snapshot of the source EBS volume.
3. Copy the snapshot to the target region.
4. Restore the snapshot as a new EBS volume in the target region.
5. Attach the restored EBS volume to the new EC2 instance and reconfigure as needed.

**Note**: This is correct. AWS does not support direct instance migration due to regional isolation for compliance and performance. For automated migrations, consider AWS Server Migration Service or CloudFormation templates, which can streamline the process.

## Question 3: What is an instance profile, and how is it used?

**Answer Explanation:**
An instance profile is a container for an IAM role that securely provides role-related information (permissions) to an EC2 instance at launch. It allows the instance to access other AWS services (e.g., S3, Lambda) without storing credentials on the instance itself, enhancing security.

**Note**: Accurate description. Instance profiles are essential for least-privilege access in serverless-like environments within EC2.

## Question 4: Can you change the instance type of a running EC2 instance?

**Answer Explanation:**
No, you cannot change the instance type of a running EC2 instance. You must:
1. Stop the instance.
2. Modify the instance type using the AWS Console, CLI, or SDKs.
3. Restart the instance.

**Note**: Correct. Changing instance types requires a restart to reallocate resources. For seamless changes, consider AWS Systems Manager Automation or blue-green deployments.

## Question 5: Explain the concept of EBS snapshots.

**Answer Explanation:**
EBS snapshots are point-in-time backups of EBS volumes, stored in Amazon S3. They enable:
- Data backups and recovery.
- Migration of volumes between regions.
- Creation of new volumes from snapshots for restoration or duplication.

Snapshots are incremental, meaning only changed blocks are stored after the initial snapshot.

**Note**: Accurate. To optimize costs, delete unused snapshots and use snapshot lifecycle policies for automated management.

## Question 6: How can you ensure high availability for your EC2 instances?

**Answer Explanation:**
To ensure high availability:
- Deploy EC2 instances across multiple Availability Zones (AZs) within a region.
- Place instances behind a load balancer (e.g., Application Load Balancer or Network Load Balancer) to distribute traffic and handle failures.

This setup ensures that if one AZ fails, others continue serving traffic.

**Note**: Correct. For enhanced resilience, integrate Auto Scaling groups to automatically adjust instance counts based on demand.

## Question 7: What is the difference between an instance store and an EBS volume?

**Answer Explanation:**
- **Instance store**: Temporary, local storage physically attached to the host machine. Data persists only while the instance is running; stopping or terminating the instance wipes the data. Used for high-performance, temporary storage (e.g., caches).
- **EBS (Elastic Block Store)**: Persistent, network-attached block storage. Data survives instance termination and is durable/replicable. Suitable for databases or persistent data.

**Note**: Accurate. Instance stores offer better I/O performance but less reliability; EBS provides durability at a slight performance trade-off.

## Question 8: What is the role of the UserData property when launching an EC2 instance?

**Answer Explanation:**
UserData is a script (e.g., bash) that runs automatically during the initial boot of an EC2 instance. It can be used to:
- Install software/packages.
- Configure the instance (e.g., update settings).
- Start services at launch.

UserData must be base64-encoded and is executed as root only on the first boot.

**Note**: Correct. For complex setups, consider AWS CloudFormation or AWS OpsWorks instead of plain UserData for better templating and error handling.

## Question 9: Can you share an AMI with other AWS accounts?

**Answer Explanation:**
Yes, by default, custom AMIs are private. To share:
- Make the AMI public (accessible to all AWS accounts).
- Set it as private and specify target AWS account IDs.
- Use AWS Organizations for sharing across accounts in an organization.

Permissions are managed via the AMI's attributes in the EC2 console or CLI.

**Note**: Accurate. Ensure shared AMIs are hardened and compliant with security best practices to avoid exposing sensitive configurations. Use AMI sharing cautiously to prevent unauthorized access.
