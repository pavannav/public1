# 15 Advanced AWS IAM Interview Questions _ Real-World Scenario Based Q&A _ AWS Interview Prep _ IAM

<summary>CL-KK-Terminal</summary>

## Question 1: Allowing Team Access to S3 with Delete Restrictions

**Question:** You want to allow your team to have access to Amazon S3 but restrict their ability to delete objects. How would you implement this?

**Answer:** Create an IAM policy that explicitly allows the necessary S3 actions while denying delete permissions. Attach this policy to an IAM group or role for the team.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Deny",
            "Action": "s3:DeleteObject",
            "Resource": "*"
        }
    ]
}
```

**Note:** This approach is correct and aligns with AWS best practices for granular permissions. Consider scoping resources more specifically using ARNs if possible.

## Question 2: Granting Temporary Access to EC2 for External Consultant

**Question:** You need to grant an external consultant temporary access to a particular EC2 instance without sharing long-term credentials. How would you do this?

**Answer:** Use IAM roles with AWS Security Token Service (STS). Create an IAM role with EC2 permissions, configure a trust policy allowing the consultant's AWS account or identity provider, and have them use the AssumeRole API to get temporary credentials.

**Steps:**
1. Create IAM role with EC2 access permissions
2. Set up trust policy for consultant's account/IDP
3. Use AssumeRole to generate temporary security credentials

**Note:** Correct approach for secure, temporary access. Ensure trust policies follow the principle of least privilege.

## Question 3: Preventing Accidental S3 Deletions

**Question:** An IAM user accidentally deleted important data from an S3 bucket. How can you set up a policy to prevent future deletions?

**Answer:** Implement either an IAM policy or S3 bucket policy that explicitly denies the `s3:DeleteObject` action. Additionally, enable MFA delete on the bucket for extra protection against accidental deletions.

**Recommended IAM Policy:**
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "s3:DeleteObject*",
            "Resource": "*"
        }
    ]
}
```

**Note:** This is a robust solution. For additional protection, consider versioning and object locks (if applicable).

## Question 4: Cross-Account Permissions for Auditing Team

**Question:** Your organization uses different AWS accounts for teams. How do you manage permissions across accounts for a central auditing team?

**Answer:** Create cross-account IAM roles in each AWS account granting read-only access to required resources. Specify the central auditing account as the trusted entity in the role's trust policy.

**Note:** Correct implementation of AWS cross-account access patterns. Ensure auditing roles follow read-only principles.

## Question 5: IP Address Restricted Access

**Question:** You need to allow an IAM user access to EC2 and S3 services only from a specific IP address range. How can you enforce this?

**Answer:** Create an IAM policy using condition keys to restrict access based on the source IP address.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["ec2:*", "s3:*"],
            "Resource": "*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": "203.0.113.0/24"
                }
            }
        }
    ]
}
```

**Note:** Effective for IP-based restrictions, but remember clients may use dynamic IPs or NAT gateways, which could make this less reliable. Consider VPC endpoints as a supplement.

## Question 6: Enforcing Access Key Rotation

**Question:** How can you ensure IAM users are forced to rotate their access keys regularly?

**Answer:** Use CloudWatch Events to track key age and trigger Lambda functions to disable old keys (e.g., over 90 days) while sending notifications. IAM Access Analyzer can also help identify and suggest rotations.

**Note:** Proactive approach aligned with AWS security best practices. Implement automated rotation where possible.

## Question 7: Restricting DynamoDB Access to Specific Table

**Question:** How can you restrict an IAM user to accessing only a specific DynamoDB table?

**Answer:** Create an IAM policy allowing specific DynamoDB actions only on the designated table's ARN.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:Scan",
                "dynamodb:Query"
            ],
            "Resource": "arn:aws:dynamodb:region:account-id:table/example-table"
        }
    ]
}
```

**Note:** Precise resource-level permissions demonstrate good security practice.

## Question 8: Tracking IAM User API Calls

**Question:** You need to track which IAM user made a specific API call. How would you do this?

**Answer:** Enable AWS CloudTrail to log all API calls, including user identity, timestamps, source IP, and actions performed.

**Note:** CloudTrail is the standard auditing tool for AWS API activity. Integrate with CloudWatch Logs for alerts on suspicious activity.

## Question 9: Restricting EC2 Instance Types

**Question:** How do you prevent IAM users from launching EC2 instances outside specific instance types like t2.micro?

**Answer:** Create an IAM policy with conditions restricting the instance type.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:RunInstances",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ec2:InstanceType": "t2.micro"
                }
            }
        }
    ]
}
```

**Note:** Useful for cost control and compliance. Consider using approved AMIs as an additional restriction.

## Question 10: Enforcing MFA for Console Access

**Question:** You want to enforce MFA for IAM users accessing the AWS Management Console. How do you implement this?

**Answer:** Create an IAM policy that denies all actions unless MFA authentication is present.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "*",
            "Resource": "*",
            "Condition": {
                "BoolIfExists": {
                    "aws:MultiFactorAuthPresent": "false"
                }
            }
        }
    ]
}
```

**Note:** This ensures MFA requirement but may need exclusions for programmatic access. Virtual MFA devices are recommended over hardware keys when possible.

## Question 11: Automating User Access Revocation

**Question:** How can you automate revoking all access for an IAM user when they leave the company?

**Answer:** Set up CloudWatch Events to detect termination events and trigger Lambda functions that disable the user, remove access keys, and detach policies.

**Note:** Proactive offboarding helps maintain security posture. Integrate with HR systems for automated triggers at scale.

## Question 12: Region-Restricted EC2 Access

**Question:** How would you allow an IAM user to manage EC2 instances only in specific regions?

**Answer:** Create an IAM policy with region-based conditions.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:*",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": "us-east-1"
                }
            }
        }
    ]
}
```

**Note:** Effective for compliance and cost management. Consider using service control policies (SCPs) in organizations for broader application.

## Question 13: Tag-Based Resource Access

**Question:** How do you restrict access to EC2 instances with specific tags?

**Answer:** Use IAM policies with resource tag conditions to allow actions only on tagged resources.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:*",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:ResourceTag/Environment": "Production"
                }
            }
        }
    ]
}
```

**Note:** Tag-based access is flexible and scalable. Ensure consistent tagging practices across teams.

## Question 14: User Tag-Based S3 Access

**Question:** You need to ensure only IAM users with a "Department=Finance" tag can access a specific S3 bucket. How would you do that?

**Answer:** Create an IAM policy using request tag conditions.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::example-bucket/*",
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalTag/Department": "Finance"
                }
            }
        }
    ]
}
```

**Note:** Attribute-based access control (ABAC) approach. Requires proper tagging of users and resources.

## Question 15: Allowing Cross-Account Role Assumption

**Question:** How do you allow an IAM user to assume multiple roles in different AWS accounts?

**Answer:** Create an IAM policy permitting `sts:AssumeRole` for specific role ARNs, and update the roles' trust policies to trust the user's account.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": [
                "arn:aws:iam::account-1:role/Role1",
                "arn:aws:iam::account-2:role/Role2"
            ]
        }
    ]
}
```

**Note:** Standard pattern for cross-account delegation. Use session policies to limit scope during role assumption.
