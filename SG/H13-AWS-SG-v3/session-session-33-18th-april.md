# Session 33: CloudFront Advanced Features, Private S3 Integration, and EC2 Placement Groups

## Overview
This session covers advanced CloudFront concepts including integration with private S3 buckets using Origin Access Control (OAC), followed by EC2 placement groups for optimizing availability and performance through rack-level instance distribution.

## CloudFront Integration with Private S3 Bucket

### Private S3 Bucket Security
- By default, S3 buckets are created as private with all public access blocked
- Bucket policies, rather than IAM roles, control access for AWS services like CloudFront
- S3 provides resource-based policies for cross-service access permissions

### Origin Access Control (OAC)
- Modern replacement for the legacy Origin Access Identity (OAI) method
- Automatically generates and manages bucket policies for CloudFront access
- Allows CloudFront to securely access private S3 buckets without making them public

### Private S3 + CloudFront Setup Steps

Create private S3 bucket in target region:
```
# S3 bucket is created in us-east-1 (Virginia)
Bucket ACL: Disabled (private enforcement)
Block all public access: Enabled
Public access: Blocked
Object ACL: Disabled (inherits bucket privacy)
```

Upload object to bucket (remains private):
```
# Private object uploaded to bucket
Object permissions: Private
Client access: Blocked without proper authorization
```

### CloudFront Distribution Configuration

1. **Create Distribution:**
   - Origin: S3 bucket (not marked as public)
   - Origin Access: Origin Access Control (OAC) recommended
   - Legacy option: Origin Access Identity (OAI) - deprecated

2. **Origin Access Control Setup:**
   - Select S3 origin with restricted access
   - Choose "Origin access control" option
   - Let AWS create new control settings

3. **Automatic Policy Generation:**
   - CloudFront auto-generates bucket policy for private bucket access
   - Policy allows CloudFront service to get S3 objects from specific bucket
   - Restrictions: Only from specific CloudFront distribution ARN

### Bucket Policy Structure (Auto-generated)
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCloudFrontServicePrincipal",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudfront.amazonaws.com"
      },
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::bucket-name/*",
      "Condition": {
        "StringEquals": {
          "AWS:SourceArn": "arn:aws:cloudfront::account-id:distribution/distribution-id"
        }
      }
    }
  ]
}
```

## AEC2 Placement Groups - Hardware Optimization

### Rack Architecture Fundamentals
- **Data Center Structure**: Physical servers connected in racks with high-speed internal networking
- **Rack Failure Impact**: Shared power supply means entire rack failure affects all instances
- **Internal Networking**: Ultra-low latency, high-throughput connections between instances in same rack
- **Availability Zones**: Multiple racks across different availability zones for redundancy

### Placement Group Strategies

#### 1. Spread Strategy (Availability Focus)
- **Placement Level**: Rack (separate hardware rack per instance)
- **Benefits**:
  - Maximizes availability (rack failure ≠ all instance loss)
  - Fault tolerance across hardware failures
  - Suitable for critical applications requiring high availability
- **Use Case**: Web servers, application replicas where availability > performance

#### 2. Cluster Strategy (Performance Focus)
- **Placement Level**: Single rack (grouped together)
- **Benefits**:
  - Ultra-low latency between instances
  - High-throughput networking gains
  - Optimal for tightly coupled applications
- **Trade-offs**: Rack failure affects entire group
- **Use Case**: High-performance computing, distributed computing clusters

#### 3. Partition Strategy (Awareness Focus)
- **Placement Level**: Controlled partitions across racks
- **Benefits**:
  - Application awareness of placement (rack metadata)
  - Supports distributed computing patterns
  - Maximum 7 partitions per group
- **Use Case**: Big data tools (Hadoop, Cassandra, Spark) requiring rack awareness

### Placement Group Implementation

Create placement group:
```
AWS Console → EC2 → Placement Groups → Create
Group name: web-server-placement-group
Strategy: Spread (for availability)
```

Launch instances with placement group:
```
EC2 Launch → Advanced Details → Placement Group
Select: web-server-placement-group
Result: Instances distributed across separate racks
```

### Instance Metadata and Rack Awareness
- Metadata API provides partition information for rack-aware applications
- Big data tools use this for data locality optimizations
- Enables distributed computing frameworks like Hadoop rack awareness

## AWS Shield and WAF - Security Services

### AWS Shield (DDoS Protection)
- **Shield Standard**: Automatically protects all AWS services
- **Shield Advanced**: Enhanced protection for critical applications
- Features:
  - DDoS attack detection and mitigation
  - Real-time monitoring via CloudWatch metrics
  - Integration with CloudFront and Route 53

### AWS WAF (Web Application Firewall)
- Protects against web application attacks
- **Web ACL Creation**: Define rules for malicious traffic
- **Resource Integration**: Attach to CloudFront distributions
- **Managed Rules**: Pre-configured rule sets for common attacks

### Security Implementation Steps
```
1. Navigate to AWS Shield Console
2. Select "AWS Shield Advanced"
3. Add protected resources (CloudFront distributions)
4. Configure CloudWatch metrics and alarms
5. Enable WAF integration for advanced filtering
```

### Elastic IP (EIP) - Static Public IP Management

#### Dynamic vs Static IP Management
- **Dynamic Public IP**: Changes upon instance stop/start
- **Static IP**: Static, persistent public IP addresses
- **Billing Consideration**: EIP is free when associated with running instance, charged when unused

#### EIP Lifecycle
1. **Allocate EIP**: Obtain IP from AWS pool
2. **Associate to Instance**: Attach to running EC2 instance
3. **Usage**: Permanent IP for that instance
4. **Dissociation**: Detach when needed (billing starts if unused)

### EIP Billing Model
- ✅ **Free**: EIP associated with running instance
- 💰 **Charged**: EIP allocated but not associated, or associated with stopped instance
- 💰 **Charged**: EIP idle in account without association

### API Gateway Integration Possibilities
- CloudFront can connect to API Gateway as origin
- API Gateway can connect to CloudFront via custom domain
- Combined architecture: Client → CloudFront → API Gateway → CloudFront → S3

## Summary

### Key Takeaways
```diff
+ CloudFront OAC enables secure private S3 bucket access without public exposure
+ Placement groups optimize EC2 instances across hardware racks for availability or performance
+ Spread strategy maximizes fault tolerance, cluster maximizes performance
+ EIP provides static public IPs but incurs charges when unused
+ AWS Shield protects against DDoS attacks with CloudWatch monitoring
```

### Quick Reference

**CloudFront Private Bucket Commands:**
```bash
# Distribution creation with OAC
Origin: Private S3 bucket
Origin Access: Origin Access Control (recommended)
Behavior: Create new OAC settings
```

**Placement Group Strategies:**
- Spread → Rack-level distribution (availability)
- Cluster → Single-rack grouping (performance)
- Partition → Aware groups (distributed computing)

**EIP Management:**
```bash
Allocate: Free initial allocation
Associate: Assign to running instance (free)
Dissociate: Remove from instance (billing starts)
Release: Return IP to AWS pool (stops billing)
```

### Expert Insight

#### Real-world Application
- **Distributed Systems**: Use partition placement groups for Hadoop/Spark clusters requiring rack awareness
- **Highly Available Applications**: Implement spread placement groups for web/app servers across multiple racks
- **Performance Clusters**: Deploy HPC workloads in cluster placement groups for minimal latency
- **Content Distribution**: CloudFront + private S3 for secure CDN-like file serving without public bucket exposure

#### Expert Path
Master EC2 placement strategies through practical deployment of distributed applications. Understand rack-level networking gain insights into data center hardware architecture. Learn to design fault-tolerant systems using multiple AZs and placement groups.

#### Common Pitfalls
Avoid mixing placement strategies within single group. Don't assume placement groups guarantee performance - test networking. Remember EIP costs when unused. Use OAC over legacy OAI for better security. Don't make S3 buckets public for CloudFront access.

#### Lesser-Known Facts
Rack-level networking can achieve under 100μs latency between instances. Big data frameworks like Hadoop were designed around rack awareness concepts AWS implements. Shield Advanced provides access to DDoS Response Teams. CloudFront distributions can cache API Gateway responses just like website content.

## Corrections Made
"In employment Static IP" → "Static IP" (typo correction)
