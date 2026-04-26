# Top 10 Common AWS EC2 Interview Questions - Part 3: Prepare for Your AWS EC2 Interview

This study guide covers the third part of common AWS EC2 interview questions, focusing on key concepts related to EC2 instances, limits, access methods, AMIs, devices, monitoring, scaling, and networking.

## Question 1: What is the default number of EC2 instances that you can launch in an AWS region?

**Answer:** The default limit is 20 EC2 instances per AWS region for a new account. This limit applies to the total number of running instances concurrently across your entire AWS account in that region. To launch more instances beyond this limit, you need to submit a service limit increase request through the AWS Support Center.

**Notes:** 
- This is accurate as of the information provided (20 instances per region is the standard default).
- AWS may have updated limits; always verify current defaults in the AWS EC2 documentation.

## Question 2: How can you regain access to a Linux-based EC2 instance if you lost the private key?

**Answer:** There are four main methods to regain access:

1. **User Data (Boot Script):** Generate a new key pair and use user data to append the new public key to the instance's authorized_keys file. This requires stopping and starting the instance to execute the boot script.

2. **AWS Systems Manager (SSM):** Use the "AWS-ResetAccess" document in Systems Manager to reset or replace the key pair. Again, stopping and starting the instance may be required.

3. **EC2 Instance Connect:** Available for Amazon Linux 2 and later (including Amazon Linux 2023). Allows connecting to the instance via the console without requiring the key pair directly, but may involve stopping/starting the instance.

4. **EC2 Serial Console:** For supported Nitro-based instances where the serial console is enabled, you can log in directly through the serial console for troubleshooting and access recovery.

**Important Considerations:**
- Methods 1, 2, and 3 typically require stopping and restarting the instance, which can change the public IP address.
- Always back up data on instance store volumes before stopping, as it will be lost.
- Use Elastic IP addresses instead of public IPs for instances to maintain consistent external access.

**Notes:**
- Correct and comprehensive. No better alternatives, but emphasize security: prevent key loss through backups or secure key management systems like AWS Secrets Manager or KMS.

## Question 3: What is the use of AMIs (Amazon Machine Images) for your EC2 instances?

**Answer:** AMIs (Amazon Machine Images) are templates used to launch EC2 instances. They define the operating system, pre-installed applications, configurations, block device mappings, and other settings for the virtual machine. Without an AMI, you cannot launch an EC2 instance. AMIs allow you to standardize and replicate instance configurations easily.

**Key Points:**
- Includes OS (e.g., Linux, Windows), application servers, and volume types.
- Public AMIs from AWS, community AMIs, and custom AMIs that you create.

**Notes:**
- Accurate. No additions needed, but mention that custom AMIs from existing instances include snapshots, incurring costs.

## Question 4: Explain the concept of EC2 instance root device and block devices.

**Answer:** 
- **Root Device:** The primary storage volume used to boot the operating system. It contains OS-related data and configurations (similar to the C: drive on Windows). For EC2, this is typically an EBS volume or instance store.
- **Block Devices:** Additional storage volumes attached to the instance for data storage beyond the root device. These are usually EBS volumes attached after launch.

By default, instances have one root device and may have additional block devices for extra storage needs.

**Notes:**
- Correct. For clarity, the root device is what boots the instance, while block devices are all volumes except the root. Consider adding a simple diagram:

```
EC2 Instance
├── Root Device (Boot Volume: OS Files)
└── Block Devices (Additional Volumes: Data)
```

(Image placeholder: A diagram illustrating root vs. block devices could be placed here as `images/root-vs-block-devices.png` to visualize the concept.)

## Question 5: How does CloudWatch help in monitoring your EC2 instances?

**Answer:** AWS CloudWatch is the monitoring service for EC2 instances and other AWS resources. It collects and tracks metrics like CPU utilization, disk usage, network throughput, and application logs. You can set alarms on metrics (e.g., alert when CPU exceeds 80%) and configure actions like notifications or scaling responses.

**Key Features:**
- Collects system-level metrics every 5 minutes (free tier) or 1 minute (detailed).
- Integrates with logs for centralized application monitoring.
- Enables dashboards and alarms for proactive resource management.

**Notes:**
- Accurate and well-explained. No discrepancies. Emphasize that custom metrics can be published via API for application-specific monitoring.

## Question 6: Can you resize an EBS volume attached to a running EC2 instance?

**Answer:** Yes, you can resize (increase or decrease) an EBS volume attached to a running EC2 instance, but the instance must be stopped for some changes (e.g., reducing size or modifying certain attributes). This involves downtime. Alternatively, to avoid downtime, attach a new EBS volume and mount it, then migrate data.

**Resize Process:**
1. Stop the instance (if required).
2. Modify the volume size via the EC2 console or CLI.
3. Start the instance and resize the filesystem (for Linux) or extend the partition (for Windows).

**Notes:**
- Correct, but clarify: Increasing size without stopping works for some cases, but stopping is safer and required for decreases or certain modifications. Best practice: Use Amazon EBS Elastic Volumes (where available) for dynamic resizing.

## Question 7: What is the difference between horizontal scaling and vertical scaling?

**Answer:** 
- **Horizontal Scaling (Scale Out/In):** Increases the number of EC2 instances to distribute load (e.g., from 2 to 5 instances). This provides redundancy and handles variable workloads via Auto Scaling groups.
- **Vertical Scaling (Scale Up/Down):** Increases the capacity (CPU, memory, storage) of existing instances without changing their number (e.g., upgrading from t2.micro to t2.large).

Use horizontal scaling for stateless applications and vertical for simple improvements with minimal changes.

**Notes:**
- Accurate. Horizontal scaling is preferred in cloud for elasticity, while vertical has physical limits. Example: Horizontal adds machines; vertical upgrades machines.

## Question 8: How do Amazon CloudWatch and Auto Scaling work together?

**Answer:** Auto Scaling uses CloudWatch metrics to dynamically scale EC2 instances. In an Auto Scaling group, define policies based on metrics (e.g., CPU utilization >80%). CloudWatch monitors these metrics and triggers alarms, signaling Auto Scaling to launch or terminate instances to maintain desired capacity and handle load.

**Workflow:**
1. Set conditions in Auto Scaling group.
2. CloudWatch monitors metrics.
3. When conditions are met, Auto Scaling adjusts instance count.
4. Ensures optimal resource availability.

**Notes:**
- Correct. No better explanation; this is standard. Mention custom metrics for more granular scaling (e.g., application latency).

## Question 9: What is the significance of an Elastic Network Interface (ENI)?

**Answer:** An ENI is a virtual network card for EC2 instances, containing network-related information like private/public IPs, security groups, subnets, and VPC details. By default, each instance gets one primary ENI; you can attach additional ENIs for advanced networking (e.g., multi-NIC setups).

**Features:**
- Provides network connectivity, IP addresses, and security rules.
- Can be attached/detached from instances without stopping them (live migration).
- Used for multi-homed instances, load balancers, or network isolation.

**Notes:**
- Accurate. For visualization, an image of the EC2 console showing the network interface section could be added as `images/eni-details.png`.

## Question 10: Can you attach an IAM role to an existing EC2 instance?

**Answer:** Yes, you can attach or modify an IAM role on a running EC2 instance without stopping it. Use the EC2 console (Actions > Security > Modify IAM Role), CLI, or SDK. The role permissions take effect immediately.

**Steps:**
1. Go to the instance in the console.
2. Modify IAM role under Actions.
3. Saves the change without downtime.

**Notes:**
- Correct. Unlike instance profiles, IAM roles can be added/modified on running instances. Security note: Rotate roles regularly and follow least-privilege principles.

For more advanced scenarios and scenario-based questions, stay tuned for upcoming sessions.

*Prepared using CL-KK-Terminal*
