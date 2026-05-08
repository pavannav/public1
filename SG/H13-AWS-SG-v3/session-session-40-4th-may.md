#### AWS Macie: Sensitive Data Discovery Service

AWS Macie is a fully managed data security service that uses machine learning (ML) and pattern matching to automatically discover, classify, and protect sensitive data in Amazon S3 buckets. It's designed specifically for large-scale data environments where manual inspection is impractical.

### Key Capabilities
- **Automated Data Discovery**: Continuously scans S3 for sensitive data at petabyte scale
- **ML-Powered Detection**: Uses artificial intelligence to identify personal data, financial information, and credentials
- **Compliance Support**: Supports multiple frameworks including PCI DSS, HIPAA, GDPR
- **Custom Identifiers**: Allows creation of organization-specific data patterns

### Use Case Example
Consider a data lake where multiple teams upload data containing:
- Customer credit card information
- Employee personal identifiable information (PII) 
- AWS access keys and API secrets
- Business-critical financial data

Manual inspection becomes impossible at scale. Macie automates this discovery process.

#### Demo: Setting Up Sensitive Data Detection

**Step 1: Create Sample Sensitive Data Files**
```
credit_card.txt:
Access Bank Credit Card: 4532015112830366
CVV: 123
Expiry: 0323

employee_info.txt:  
Employee Mobile: 2345678901
Address: 5 Linux World, India
Employee ID: 12345

keys.txt:
Access Key: AKIAIOSFODNN7EXAMPLE
Secret Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

**Step 2: Enable Macie Service**
```bash
aws macie2 enable-macie
aws macie2 create-detector --enable
```

**Step 3: Create Classification Job**
```bash
aws macie2 create-classification-job \
  --name "sensitive-data-scan" \
  --job-type "ONE_TIME" \
  --s3-job-definition '{
    "bucketDefinitions": [
      {
        "accountId": "'$(aws sts get-caller-identity --query Account --output text)'",
        "buckets": ["my-data-lake-bucket"]
      }
    ]
  }'
```

**Step 4: Custom Data Identifier Creation**
For organization-specific patterns like internal room numbers:
```bash
aws macie2 create-custom-data-identifier \
  --name "internal-room-numbers" \
  --description "Pattern for internal security room access" \
  --regex "[A-Z]{3}-[0-9]{3}" \
  --severity "HIGH"
```

### Macie vs Traditional Tools
| Feature | AWS Macie | Traditional DLP |
|---------|-----------|----------------|
| Data Scale | Unlimited S3 storage | Limited file systems |
| AI/ML | Built-in intelligence | Manual rule creation |
| Accuracy | High (ML-trained) | Rule-based (prone to false positives) |
| Cost | Pay-per-use | High licensing fees |

> [!NOTE] 
> Macie findings are categorized by severity levels, with automated alerting capabilities to reduce response time.

#### AWS GuardDuty: Intelligent Threat Detection

AWS GuardDuty is a threat detection service that continuously monitors AWS accounts and workloads for malicious activity using machine learning, anomaly detection, and integrated threat intelligence.

### Core Capabilities
- **Continuous Monitoring**: Analyzes CloudTrail logs, VPC Flow Logs, and DNS logs
- **Anomaly Detection**: Identifies unusual API calls, privilege escalation, and network behavior
- **Automated Responses**: Generates findings with remediation recommendations
- **Multi-Account Support**: Centralized detection across AWS Organizations

### Threat Categories Detected
1. **Reconnaissance**: Port scanning, unusual API exploration
2. **Instance Compromise**: Cryptocurrency mining, malware execution
3. **Account Takeover**: Suspicious login patterns, credential theft
4. **Data Exfiltration**: Unusual data transfers to external destinations

#### GuardDuty Configuration Demo

**Enable GuardDuty:**
```bash
aws guardduty create-detector --enable
```

**Create Custom Threat Intelligence:**
```bash
# Create IP threat list
echo -e "203.0.113.1\n198.51.100.1" > threat_ips.txt
aws s3 cp threat_ips.txt s3://threat-intelligence-bucket/

aws guardduty create-ip-set \
  --detector-id "$(aws guardduty list-detectors --query 'DetectorIds[0]' --output text)" \
  --name "custom-threat-ips" \
  --format "TXT" \
  --location "s3://threat-intelligence-bucket/threat_ips.txt" \
  --activate
```

**Configure Automated Response:**
```bash
# EventBridge rule for high-severity findings
aws events put-rule \
  --name "guardduty-high-severity" \
  --event-pattern '{
    "source": ["aws.guardduty"],
    "detail": {
      "severity": [7.0, 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7, 7.8, 7.9, 8.0]
    }
  }'

# Attach Lambda function for automated isolation
aws events put-targets \
  --rule "guardduty-high-severity" \
  --targets '[{
    "Id": "GuardDutyResponse",
    "Arn": "arn:aws:lambda:us-east-1:123456789012:function:guardduty-auto-response"
  }]'
```

### Integration Examples

#### EventBridge Integration Flow
```diff
! GuardDuty Finding → EventBridge Rule → Lambda Function → Automated Response

+ Example Response Actions:
+ High-Severity Instance Threat: Stop EC2 instance + Snapshot for forensics
+ API Brute Force: Create WAF rule to block source IP
+ Credential Theft: Revoke IAM access keys + Force password reset
```

#### Security Hub Integration
```bash
# Enable Security Hub consolidation
aws securityhub enable-security-hub

# Macie and GuardDuty findings automatically aggregate in Security Hub
# Create custom insight for compliance monitoring
aws securityhub create-insight \
  --name "PCI-DSS-Sensitive-Data" \
  --filters '{
    "ResourceType": ["AwsS3Bucket"],
    "Compliance": {
      "Status": ["FAILED"]
    }
  }'
```

> [!WARNING]
> Automated responses should include human oversight to prevent legitimate traffic disruption during configuration testing phases.

### Comparative Analysis: Macie vs GuardDuty

| Service | Primary Focus | Data Sources | Response Type |
|---------|---------------|-------------|---------------|
| Macie | Data at rest | S3 objects | Classification/Protection |
| GuardDuty | Activity monitoring | API calls, network logs | Threat detection/Isolation |

### Career Implications
These services represent the future of cloud security:
- Reduced manual security operations by 70-80%
- AI-driven threat hunting capabilities  
- Automated compliance evidence generation
- Scalable security for multi-petabyte environments

> [!IMPORTANT] 
> Organizations should implement both services together for comprehensive cloud security posture - Macie for data protection, GuardDuty for threat detection.

#### Lambda Function: Automated Response Handler
```python
import boto3
import json
from datetime import datetime

def lambda_handler(event, context):
    """
    Automated response handler for Macie and GuardDuty findings
    """
    source = event['source']
    
    if source == 'aws.macie':
        return handle_macie_finding(event)
    elif source == 'aws.guardduty':
        return handle_guardduty_finding(event)

def handle_macie_finding(event):
    """Process Macie sensitive data findings"""
    finding = event['detail']
    bucket_name = finding['resourcesAffected']['s3Bucket']['name']
    object_key = finding['resourcesAffected']['s3ObjectKey']['key']
    
    # Quarantine sensitive object
    s3 = boto3.client('s3')
    quarantine_key = f"quarantine/{datetime.now().isoformat()}/{object_key}"
    
    s3.copy_object(
        CopySource={'Bucket': bucket_name, 'Key': object_key},
        Bucket=f"{bucket_name}-quarantine",
        Key=quarantine_key
    )
    
    # Encrypt and restrict access
    s3.put_object_acl(
        Bucket=f"{bucket_name}-quarantine", 
        Key=quarantine_key,
        ACL='private'
    )
    
    # Send notification
    sns = boto3.client('sns')
    sns.publish(
        TopicArn='arn:aws:sns:us-east-1:123456789012:sensitive-data-alert',
        Message=f"Sensitive data quarantined: s3://{bucket_name}/{object_key}",
        Subject='ALERT: Sensitive Data Detected and Isolated'
    )
    
    return {'statusCode': 200}

def handle_guardduty_finding(event):
    """Process GuardDuty security findings"""
    finding = event['detail']
    severity = finding['severity']
    resource_type = finding['resource']['resourceType']
    
    if severity >= 8.0:  # Critical threat
        if resource_type == 'Instance':
            instance_id = finding['resource']['instanceDetails']['instanceId']
            
            # Isolate compromised EC2 instance
            ec2 = boto3.client('ec2')
            ec2.stop_instances(InstanceIds=[instance_id])
            
            # Create forensic snapshot
            response = ec2.describe_instances(InstanceIds=[instance_id])
            device_mappings = response['Reservations'][0]['Instances'][0]['BlockDeviceMappings']
            
            for mapping in device_mappings:
                volume_id = mapping['Ebs']['VolumeId']
                snapshot_desc = f"GuardDuty-Forensic-{instance_id}-{datetime.now().isoformat()}"
                
                ec2.create_snapshot(
                    VolumeId=volume_id,
                    Description=snapshot_desc
                )
            
            # Critical alert
            sns = boto3.client('sns')
            sns.publish(
                TopicArn='arn:aws:sns:us-east-1:123456789012:critical-security-alert',
                Message=f"CRITICAL: Instance {instance_id} isolated due to threat detection",
                Subject='SECURITY ALERT: Critical Threat Detected'
            )
    
    return {'statusCode': 200}
```

### Production Implementation Checklist
```diff
+ Service Enablement:
+ Enable Macie in target accounts/regions
+ Enable GuardDuty with proper permissions
+ Configure necessary IAM roles for cross-service access

+ Integration Setup:
+ Create EventBridge rules for automated responses
+ Configure Lambda functions for remediation logic
+ Set up SNS topics for alerting stakeholders
+ Integrate with Security Hub for centralized view

+ Monitoring & Tuning:
+ Set appropriate severity thresholds
+ Create custom data identifiers for business-specific patterns
+ Configure threat intelligence feeds
+ Establish alerting escalation procedures

+ Compliance & Documentation:
+ Generate reports for regulatory requirements
+ Document automated response procedures
+ Establish incident response playbooks
+ Regular review and adjustment of detection rules
```

**🤖 Generated with [Claude Code](https://claude.com/claude-code)**

**Co-Authored-By: Claude <noreply@anthropic.com>**

*MODEL ID: KK-CS45-V3*
