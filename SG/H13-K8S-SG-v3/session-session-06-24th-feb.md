### Common Pitfalls in AWS CLI Setup

AWS CLI installation often fails due to:
1. Incorrect Python version (required >= 3.6)
2. PATH environment variable not updated
3. Conflicting AWS CLI versions
4. Proxy settings blocking downloads

```bash
# Troubleshooting commands
which aws     # Check if AWS CLI is installed
aws --version # Verify installation
aws configure # Re-run configuration if needed
```

### Advanced IAM Policy Structure
JSON policies follow this structure:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "ec2:DescribeInstances",
            "Resource": "*"
        }
    ]
}
```

**Production Security Best Practices:**
- Implement least privilege access
- Use IAM roles instead of long-term access keys
- Enable CloudTrail for audit logging
- Rotate access keys every 90 days
- Use multi-factor authentication (MFA)

**CloudWatch Monitoring Best Practices:**
- Set up billing alerts for cost control
- Create composite alarms for complex conditions
- Use CloudWatch Logs for centralized logging
- Implement custom metrics for application monitoring
- Configure automated remediation using Lambda

**CLI Automation Tips:**
```bash
# Use profiles for multiple accounts
aws configure --profile staging
aws configure --profile production

# Execute commands with specific profiles
aws s3 ls --profile staging
aws ec2 describe-instances --profile production

# Export common variables
export AWS_DEFAULT_REGION=us-east-1
export AWS_PROFILE=my-profile
```

This comprehensive study guide covers the foundational AWS services that enable secure, monitored, and automated cloud infrastructure management. The practical demonstrations provide hands-on understanding of how to implement these concepts in real-world scenarios.
