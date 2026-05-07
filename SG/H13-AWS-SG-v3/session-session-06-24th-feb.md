# Session 06: AWS CloudWatch, IAM, and CLI Introduction

## Table of Contents
- [CloudWatch Monitoring Service](#cloudwatch-monitoring-service)
  - [Overview](#overview)
  - [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Practical Implementation](#practical-implementation)
- [AWS Identity and Access Management (IAM)](#aws-identity-and-access-management-iam)
  - [Overview](#overview-1)
  - [Key Concepts and Deep Dive](#key-concepts-and-deep-dive-1)
  - [Practical Implementation](#practical-implementation-1)
- [AWS Command Line Interface (CLI)](#aws-command-line-interface-cli)
  - [Overview](#overview-2)
  - [Key Concepts and Deep Dive](#key-concepts-and-deep-dive-2)
  - [Practical Implementation](#practical-implementation-2)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

---

## CloudWatch Monitoring Service

### Overview
AWS CloudWatch is a comprehensive monitoring service that automatically collects, tracks, and monitors metrics from AWS resources and applications. It provides operational visibility, alerts, and automated actions to help optimize resource utilization and improve application performance.

### Key Concepts and Deep Dive

**What is Monitoring?**
Monitoring involves continuously tracking system resources and performance metrics to gain insights into application behavior and infrastructure health. CloudWatch tracks various metrics including CPU utilization, memory usage, network bandwidth, storage capacity, and custom application metrics.

**Why Monitor Resources?**
The primary purpose of monitoring includes:
- **Cost Optimization**: Identify underutilized resources (e.g., servers running at 10% capacity instead of optimal usage)
- **Performance Analysis**: Detect performance bottlenecks before they impact users
- **Proactive Issue Resolution**: Set up alerts for network congestion or memory issues before they cause service degradation
- **Business Decision Making**: Make data-driven decisions about scaling requirements

**Metrics and Monitoring Scope**
CloudWatch collects metrics from multiple AWS services:
- **EC2 Instances**: CPU utilization, memory usage, network I/O, disk I/O
- **EBS Volumes**: Read/write operations, throughput, latency
- **S3 Buckets**: Object operations, data transfer, error rates
- **ELB Load Balancers**: Request count, response time, healthy/unhealthy instances

**Key Features:**
- **Metrics Dashboard**: Graphical representation of resource utilization
- **Alarms**:Automated alerting based on metric thresholds
- **Logs**: Centralized log collection and analysis
- **Events**: Automated responses to resource state changes
- **X-Ray**: Distributed Tracing for application performance analysis

**Integration Points:**
CloudWatch integrates with most AWS services and automatically starts monitoring when resources are launched. For example, when an EC2 instance is created, CloudWatch immediately begins collecting metrics like CPU utilization and network activity.

### Practical Implementation

**Accessing CloudWatch:**
- Navigate to AWS Management Console
- Search for "CloudWatch" service
- Access the "Metrics" tab to view collected data

**Metrics Collection Process:**
1. AWS services automatically send metrics to CloudWatch
2. Metrics are organized by namespace (e.g., AWS/EC2, AWS/EBS)
3. Data points are stored for 15 months by default
4. Granularity varies (typically 1-5 minute intervals)

**Creating Visualizations:**
- Select metrics from the Metrics console
- Use "Add to graph" to combine multiple metrics
- Customize time ranges and aggregation functions
- Create dashboards for persistent monitoring views

---

## AWS Identity and Access Management (IAM)

### Overview
AWS Identity and Access Management (IAM) is a web service that helps secure access to AWS resources. It enables users to control who (identity) can do what (permissions) with which resources (access management). IAM provides centralized access management across AWS services, replacing the limitations of root account usage.

### Key Concepts and Deep Dive

**Security Problem Solved:**
Real-world organizations require multiple team members with different permission levels. Using a single root account for all operations creates security vulnerabilities and operational challenges. IAM solves this by enabling fine-grained access control.

**Core IAM Components:**

**1. Users**
- Individual accounts representing people or applications
- Can be console-accessible (human users) or programmatic (CLI/API access)
- Each user has unique credentials (username/password for console, access keys for CLI)

**2. Groups**
- Collections of users with similar permissions
- Simplifies permission management (apply policies once to the group)
- Users inherit group permissions

**3. Roles**
- Temporary permission sets that can be assumed by users or services
- Enable cross-account access and service-to-service permissions
- More secure than long-term credentials

**4. Policies**
- JSON documents defining permissions
- Specify what actions are allowed/denied on which resources
- Types: AWS managed policies, customer managed policies, inline policies

**Authentication vs Authorization:**
- **Authentication**: Verifying identity ("Are you who you claim to be?")
  - Console: Username + password
  - CLI: Access key + secret key
- **Authorization**: Determining permissions ("What can you do?")
  - Policies attached to users, groups, or roles
  - Effect: Allow or Deny
  - Principal, Action, Resource, Condition statements

**Permission Levels:**
- **ReadOnlyAccess**: View-only permissions across services
- **FullAccess**: Complete control over specific service
- **AdministratorAccess**: Near-root level permissions (except billing)
- **Custom Policies**: Granular permissions using JSON policy documents

### Practical Implementation

**Creating IAM Users:**
1. Navigate to IAM service in AWS Console
2. Select "Users" → "Add user"
3. Configure:
   - Username (e.g., "john-devops", "sarah-admin")
   - Access type: Console access and/or programmatic access
   - Password requirements and forced rotation
4. Attach permissions/policies during creation
5. Download credentials (security keys) immediately

**Configuring User Permissions:**
- **Managed Policies**: Pre-built by AWS (e.g., "AmazonEC2ReadOnlyAccess")
- **Inline Policies**: Custom permissions attached directly to users
- **Group Membership**: Add users to groups for collective permissions

**Permission Examples:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeImages",
        "ec2:DescribeKeyPairs"
      ],
      "Resource": "*"
    }
  ]
}
```

**Best Practices:**
- **Least Privilege Principle**: Grant only minimum required permissions
- **Multi-Factor Authentication (MFA)**: Enable for critical accounts
- **Regular Rotation**: Rotate access keys and passwords regularly
- **Use Groups**: Apply permissions via groups instead of individual users
- **Monitor Access**: Use CloudTrail to audit IAM actions

---

## AWS Command Line Interface (CLI)

### Overview
AWS Command Line Interface (CLI) provides direct access to AWS services through terminal commands. It enables scripting, automation, and programmatic access to AWS resources without using the web-based management console. CLI is essential for DevOps practices, infrastructure automation, and efficient AWS management.

### Key Concepts and Deep Dive

**Three Ways to Access AWS:**
1. **Management Console**: Web-based GUI interface
   - Best for learning and visual operations
   - Suitable for manual tasks and beginners
   - Limited automation capabilities

2. **CLI (Command Line Interface)**:
   - Text-based terminal commands
   - Ideal for automation and scripting
   - Preferred by developers and system administrators
   - Rich error reporting and detailed output

3. **SDK/API**: Application Programming Interfaces
   - Programming language integration (Python boto3, Java SDK, etc.)
   - Used for custom applications and mobile apps
   - Enables AWS service integration in application code

**CLI Advantages:**
- **Automation**: Create scripts for repetitive tasks
- **Speed**: Faster execution for resource management
- **Scripting**: Integration with infrastructure as code
- **Error Handling**: Detailed error messages and troubleshooting
- **Batch Operations**: Manage multiple resources simultaneously
- **Advanced Features**: Access to features not available in console

**Authentication Methods:**
- **Human Users**: Username/password for console access
- **Programs/CLI**: Access key and secret key
- **Applications**: API keys or IAM role assumption

**Command Syntax:**
```
aws <service> <subcommand> [options]
```

**Service Categories Supported:**
- Compute: EC2, Lambda, ECS, EKS
- Storage: S3, EBS, EFS, Glacier
- Networking: VPC, Route 53, CloudFront, ELB
- Security: IAM, KMS, WAF, Shield
- Database: RDS, DynamoDB, Redshift
- Analytics: EMR, Kinesis, Athena
- And many more services...

### Practical Implementation

**Installation Process:**
1. Download AWS CLI from official AWS website
2. Select appropriate version for your OS (Windows/Mac/Linux)
3. Install the MSI/pkg/deb package
4. Verify installation: `aws --version`

**Initial Configuration:**
```bash
aws configure
```
- Enter Access Key ID
- Enter Secret Access Key
- Set default region (e.g., us-east-1, ap-south-1)
- Set default output format (json, text, table)

**Command Examples:**

**EC2 Instance Management:**
```bash
# List all instances
aws ec2 describe-instances

# Start an instance
aws ec2 start-instances --instance-ids i-1234567890abcdef0

# Stop an instance
aws ec2 stop-instances --instance-ids i-1234567890abcdef0

# Terminate an instance
aws ec2 terminate-instances --instance-ids i-1234567890abcdef0
```

**S3 Bucket Operations:**
```bash
# List all buckets
aws s3 ls

# Upload a file
aws s3 cp myfile.txt s3://my-bucket/

# Download a file
aws s3 cp s3://my-bucket/myfile.txt .

# List files in bucket
aws s3 ls s3://my-bucket/
```

**Discovering Commands:**
- Use `aws <service> help` to see available subcommands
- Use `aws <service> <subcommand> help` for command-specific options
- Example: `aws ec2 help` or `aws s3 ls help`

**Command Structure Patterns:**
- **Describe/List**: `describe-instances`, `ls`, `list-buckets`
- **Create**: `run-instances`, `create-bucket`, `create-role`
- **Delete**: `terminate-instances`, `delete-bucket`, `delete-object`
- **Modify**: `modify-instance-attribute`, `modify-bucket-policy`

**Output Filtering:**
```bash
# Filter specific fields using --query
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name]' --output table
```

**Scripting Integration:**
```bash
#!/bin/bash
INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=test-server" --query 'Reservations[*].Instances[*].InstanceId' --output text)

if [ -n "$INSTANCE_ID" ]; then
    aws ec2 start-instances --instance-ids $INSTANCE_ID
    echo "Started instance: $INSTANCE_ID"
else
    echo "Instance not found"
fi
```

---

## Summary

### Key Takeaways
```diff
+ AWS CloudWatch provides comprehensive monitoring for all AWS resources
+ IAM enables secure, fine-grained access control through users, groups, roles, and policies
+ AWS CLI offers powerful command-line access for automation and efficient resource management
+ Three primary access methods: Console (GUI), CLI (command-line), SDK/API (programming)
+ Least privilege principle should guide all access control decisions
+ CLI commands follow consistent patterns: aws <service> <action> [options]
+ CloudWatch metrics help optimize costs by identifying underutilized resources
+ IAM policies use JSON syntax to define allow/deny permissions
+ CLI configuration requires access keys, secret keys, and default region
+ Regular monitoring prevents performance issues and enables proactive scaling
```

### Quick Reference

#### CloudWatch Commands
- Access CloudWatch console from AWS Management
- View metrics by service (EC2, EBS, EBS, Lambda, etc.)
- Create alarms for threshold-based alerts
- Use dashboards for persistent monitoring views

#### IAM Commands
- Create users: IAM Console → Users → Add User
- Attach managed policies: AWS managed permissions (e.g., EC2FullAccess, S3ReadOnlyAccess)
- Configure programmatic access for CLI usage
- Use groups for collective permission management

#### CLI Commands
```bash
# Configuration
aws configure                    # Initial setup with credentials
aws --version                   # Verify CLI installation

# EC2 Management
aws ec2 describe-instances      # List all instances
aws ec2 start-instances --instance-ids <id>    # Start instance
aws ec2 stop-instances --instance-ids <id>     # Stop instance

# Help System
aws help                        # Main help
aws ec2 help                    # EC2 service help
aws ec2 describe-instances help # Specific command help
```

### Expert Insight

#### Real-world Application

**Production Monitoring Strategy:**
In enterprise environments, CloudWatch serves as the central nervous system for infrastructure visibility. Teams create custom dashboards showing KPIs across development, staging, and production environments. Automated alarms notify DevOps teams via Slack/PagerDuty when CPU spikes beyond 80% or error rates exceed thresholds.

**IAM Security Architecture:**
Large organizations implement multi-account strategies where each project/application gets its own AWS account. IAM roles enable cross-account access while maintaining security boundaries. Regular access reviews ensure employees only retain necessary permissions.

**Infrastructure Automation:**
CLI becomes indispensable in CI/CD pipelines. Deployment scripts use CLI commands to provision resources, configure security groups, and update load balancers. Combined with tools like Terraform or CloudFormation, entire infrastructures can be recreated with single commands.

#### Expert Path
To excel in AWS operations, focus on CLI mastery first - learn to perform basic operations (create/list/describe/delete) for core services (EC2, S3, VPC, IAM). Progress to advanced filtering, output formatting, and scripting. Then move to CloudWatch for monitoring depth and IAM for enterprise security patterns.

#### Common Pitfalls
- ❌ Installing CLI globally on shared systems (security risk)
- ❌ Using root account for routine operations
- ❌ Skipping CloudWatch monitoring in development (blind spots)
- ❌ Not rotating access keys regularly
- ❌ Testing permissions with production data instead of test accounts

#### Lesser-Known Facts
- CloudWatch stores metrics for 15 months, but can be extended with paid options
- IAM policies can include resource-level permissions (down to individual S3 objects)
- CLI supports --dry-run flag for safe command testing before execution
- CloudWatch can monitor custom metrics from applications via SDK
- IAM roles can be assumed by Lambda functions for automatic credential management

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
