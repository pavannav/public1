# Top 10 Common AWS EC2 Interview Questions Part 1

## Q1: What is Amazon EC2?

**Answer:** Amazon EC2 stands for Elastic Compute Cloud and is a service that provides resizable computing capacity in the cloud. It allows users to launch virtual servers (instances) and scale them as needed for creating virtual machines or servers.

**Note:** This answer is accurate and complete. No corrections needed.

## Q2: What is an instance?

**Answer:** An instance is a virtual server launched using the Amazon EC2 service. It includes compute power, memory, storage, and networking capabilities.

**Note:** This is correct. An instance is essentially a virtual machine running on AWS infrastructure.

## Q3: How do you choose the right instance type for your application?

**Answer:** Instance type refers to the hardware components of the server, including CPU, memory, storage, and networking. To choose the right one, consider your application's requirements for CPU, memory, storage, and networking. AWS offers various instance families like compute-optimized, memory-optimized, storage-optimized, and GPU instances based on different use cases.

**Note:** This answer is comprehensive. A good addition would be to mention current generation instance families (e.g., M5, C5) and using the AWS pricing calculator to estimate costs.

![EC2 Instance Types Overview](./images/ec2-instance-types.png)

## Q4: What is an Amazon Machine Image (AMI)?

**Answer:** AMI stands for Amazon Machine Image. It is a pre-configured image that includes the operating system, application servers, and configurations needed to launch EC2 instances. Examples include Windows, Ubuntu, or Red Hat images.

**Note:** Accurate. Note that users can also create custom AMIs from existing instances.

![AMI Components](./images/ami-components.png)

## Q5: How can you secure your EC2 instances?

**Answer:** Security can be achieved through:
- Security Groups: Virtual firewalls to control inbound and outbound traffic.
- Network ACLs (NACLs): To control traffic at the subnet level.
- IAM roles: To manage permissions for actions within the instance.
- Encryption: To encrypt data at rest and in transit.

**Note:** This covers key aspects. Additionally, mention using VPC security best practices, regular patching, and monitoring with CloudWatch/AWS Config.

![EC2 Security Layers](./images/ec2-security-layers.png)

## Q6: Explain the difference between a security group and a Network ACL.

**Answer:** Both are firewalls for controlling traffic:
- Security Groups operate at the instance level and are attached to individual EC2 instances to control inbound and outbound traffic.
- Network ACLs (NACLs) operate at the subnet level and apply to all instances in that subnet.

**Note:** Correct and concise. Security groups are "stateful" (allow return traffic automatically), while NACLs are "stateless" (rules must be explicit for both directions).

![Security Group vs NACL](./images/security-group-vs-nacl.png)

## Q7: What is an Elastic IP address?

**Answer:** An Elastic IP is a static, public IPv4 address designed for dynamic cloud computing. It remains the same even if the instance is stopped and restarted, and can be remapped to mask instance failures (e.g., remap to a new instance if the old one fails).

**Note:** Accurate. Note that Elastic IPs are free when associated with running instances, but incur charges when not in use. Consider using DNS names or Application Load Balancers for better elasticity.

![Elastic IP Workflow](./images/elastic-ip-workflow.png)

## Q8: How can you scale EC2 instances based on demand?

**Answer:** Use Auto Scaling Groups (ASGs) to automatically scale EC2 instances up or down based on defined conditions, such as CPU utilization or network traffic. ASGs manage the number of instances dynamically.

**Note:** This is correct. Mention scaling policies (e.g., target tracking, step scaling) and integration with Elastic Load Balancer for distribution.

![Auto Scaling Group](./images/auto-scaling-group.png)

## Q9: What is an EC2 instance metadata?

**Answer:** EC2 instance metadata contains information about the running instance, such as VPC ID, subnet, public/private IPs, and security groups. It can be accessed via a unique HTTP URL from within the instance using curl commands.

**Note:** Accurate. Note that instance metadata service (IMDS) provides this data without requiring credentials, so it's secure for the instance itself. Use Instance Metadata Service v2 (IMDSv2) for improved security.

## Q10: Can you attach an EBS volume to multiple EC2 instances simultaneously?

**Answer:** No, an EBS volume follows a one-to-one mapping and can only be attached to one EC2 instance at a time. To attach it to another instance, it must first be detached from the current one.

**Note:** Correct. For shared storage across multiple instances, consider Amazon Elastic File System (EFS) or third-party solutions.

<summary model="CL-KK-Terminal">Created GitHub Flavored Markdown study guide for AWS EC2 Interview Questions Part 1 with Q&A format, validation notes, and conceptual diagrams.</summary>
