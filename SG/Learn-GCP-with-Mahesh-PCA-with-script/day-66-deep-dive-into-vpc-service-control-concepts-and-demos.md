# Session 66: Deep Dive into VPC Service Control Concepts and Demos

## Table of Contents
- [Introduction](#introduction)
- [Setting Up Protected Storage](#setting-up-protected-storage)
- [IAM Roles and Permissions](#iam-roles-and-permissions)
- [Data Exfiltration Scenarios](#data-exfiltration-scenarios)
- [VPC Service Control Setup](#vpc-service-control-setup)
- [Access Context Manager Integration](#access-context-manager-integration)
- [Identity-Aware Proxy (IAP) Integration](#identity-aware-proxy-iap-integration)
- [Bridge Perimeters](#bridge-perimeters)
- [Supported Services and Limitations](#supported-services-and-limitations)
- [Logs and Troubleshooting](#logs-and-troubleshooting)
- [Summary](#summary)

## Introduction

VPC Service Control provides firewall-like protection for Google Cloud resources that don't support traditional VM firewalls, such as Google Cloud Storage, BigQuery, Cloud SQL, Bigtable, Spanner, and Cloud Run.

### Overview
VPC Service Control acts as a perimeter firewall for Google Cloud APIs. It allows organizations to define security perimeters that control access to sensitive cloud resources based on network location, user identity, and device context.

### Key Concepts
- **Perimeter**: A security boundary that defines which resources are protected and which access conditions must be met
- **Access Levels**: Conditions that must be satisfied for access (IP ranges, geographical locations, device policies)
- **Dry Run Mode**: Test perimeter effects without impacting traffic
- **Enforce Mode**: Apply perimeter restrictions to live traffic

### Real-World Use Cases
- Protect sensitive GCS buckets containing confidential data
- Prevent data exfiltration by restricting access to authorized networks only
- Comply with enterprise security policies requiring access from corporate networks
- Restrict access to production databases to specific IP ranges

```diff
+ Advantages: Provides firewall protection for services that can't have VM firewalls
- Limitations: Doesn't support App Engine, Cloud Shell, or Google Cloud Console
```

## Setting Up Protected Storage

### Overview
This section demonstrates setting up a GCS bucket with retention policies and security measures to protect highly confidential data.

### Key Concepts

**Bucket Creation with Security Features**:
- Use uniform bucket-level access
- Enable object versioning and retention policies
- Set retention periods (e.g., 5 minutes for demo purposes)

**Data Population**:
- Upload sensitive files using gsutil commands
- Demonstrate copying data between project buckets

### Code/Config Blocks

**Creating a GCS Bucket**:
```bash
# Create bucket with retention policy
gsutil mb -c regional -l us-central1 gs://confidential-data-bucket/
gsutil bucketpolicyonly set on gs://confidential-data-bucket/
gsutil retention set 5m gs://confidential-data-bucket/
```

**Populating Data**:
```bash
# Upload sensitive files
echo "Sensitive data content" > confidential.txt
echo "Top secret information" > sensitive_data.txt
gsutil cp confidential.txt gs://confidential-data-bucket/
gsutil cp sensitive_data.txt gs://confidential-data-bucket/
```

**Verification**:
```bash
# List bucket contents
gsutil ls -lh gs://confidential-data-bucket/
```

### Retention Policy Setup
- **Purpose**: Prevents accidental deletion of sensitive data
- **Duration**: 5 minutes (300 seconds) for demonstration
- **Production**: Use longer durations (days/months)
- **Additional Protections**: Enable soft delete and object versioning

> [!IMPORTANT]
> Always enable retention policies on confidential buckets to prevent data loss from accidental deletion.

## IAM Roles and Permissions

### Overview
Proper IAM configuration is crucial but insufficient for protecting sensitive resources. IAM controls who can access resources, but doesn't restrict network locations.

### Key Concepts

**Common IAM Roles for GCS**:
- **Storage Object Admin**: Full control over objects
- **Storage Object User**: Read/write access to objects
- **Storage Object Viewer**: Read-only access to objects
- **Storage Legacy Bucket Owner/Reader/Writer**: Legacy roles

**Service Account Permissions**:
- Google-managed service accounts automatically get permissions
- Custom service accounts need explicit roles
- Compute Engine default service account gets broad access

### IAM Permissions Analysis

**Example Permission Structure**:
```
Principal: user@domain.com
Role: roles/storage.objectAdmin
Conditions: None (global access)
```

### Deep Dive Table: Common GCS IAM Roles

| Role | Permissions | Use Case |
|------|-------------|----------|
| `roles/storage.objectAdmin` | Create, read, update, delete objects | Application service accounts |
| `roles/storage.objectUser` | Read and write objects | Data upload/download users |
| `roles/storage.objectViewer` | Read objects only | Auditors, analysts |

### Expert Insight

**IAM Limitations**: While IAM controls *who* can access resources, it doesn't control *where* or *how* access occurs. A user with proper IAM permissions can access data from anywhere - public WiFi, home network, cloud shell, etc.

> [!NOTE]
> IAM is necessary but insufficient for comprehensive security. Combine with network controls like VPC Service Control.

## Data Exfiltration Scenarios

### Overview
This section demonstrates how data can be stolen even with proper IAM permissions, highlighting the need for VPC Service Control.

### Key Concepts

**Exfiltration Methods**:
1. **Console Download**: Direct download through Google Cloud Console
2. **Cloud Shell Access**: Using GCP's hosted shell environment
3. **Cross-Project Copy**: Moving data between different projects
4. **Local Machine Copy**: Downloading to personal computers
5. **VM Instance Copy**: Using authorized VMs to extract data

### Detailed Scenarios

**Scenario 1: Owner with Global Access**
- User has storage.objectAdmin role
- Can access from any location with internet
- Can download files directly or copy to other buckets

**Scenario 2: Viewer Role Exploitation**
- User has read-only permissions
- Can create personal GCS buckets or use local storage
- Can copy data to unauthorized locations

**Scenario 3: Accidental Data Movement**
- Developers with multi-project access
- Mistakenly copy sensitive data to non-sensitive projects
- Work pressure causes errors in data handling

### Deep Dive: Cloud Shell Risks

```
Cloud Shell Characteristics:
├── Provisioned in Singapore/Mumbai (Asia zones)
├── Different IP than user's actual location
├── Google-managed, not user-controlled
├── No network restrictions by default
└── Exposes all authorized resources
```

### Common Issues

**Cross-Environment Access**:
- Users with production access can accidentally access dev/qa
- No network segmentation between environments
- Lack of IP-based restrictions

**Device-Based Access Control**:
- Users accessing from personal devices
- Public WiFi connections with traceable IPs
- No device policy enforcement

```diff
+ VPC Service Control prevents all these scenarios by enforcing perimeter boundaries
- Without VPC Service Control, IAM alone cannot prevent exfiltration
```

## VPC Service Control Setup

### Overview
VPC Service Control requires organization-level setup and creates security perimeters around Google Cloud resources.

### Prerequisites
- **Organization Node**: Required for VPC Service Control
- **Access Context Manager**: Integrated with VPC Service Control
- **Policy Creation**: Hierarchical policy framework

### Step-by-Step Setup

#### 1. Create VPC Service Control Policy
```bash
# Command structure (requires org admin)
gcloud access-context-manager policies create \
  --title="VPC Service Control Policy" \
  --organization=ORG_ID
```

#### 2. Create Service Perimeter
**Regular Perimeter**: Protects resources within a project
**Bridge Perimeter**: Connects multiple regular perimeters

#### 3. Configure Protected Services
- **Storage Services**: GCS, Cloud Storage, Filestore, Backup/DR
- **Databases**: Cloud SQL, Spanner, Bigtable, Firestore
- **Analytics**: BigQuery
- **Compute**: VMs, Kubernetes (optional)

### Configuration Options

**Perimeter Types**:
```yaml
# Regular Perimeter
type: REGULAR
project: service-project-a
protected_services:
  - storage.googleapis.com
  - sqladmin.googleapis.com
```

**Enforcement Modes**:
- **Dry Run**: Test without blocking (recommended first)
- **Enforced**: Active protection (production)

### Access Control Methods

**VPC Accessible Services**:
- **All**: All Google APIs accessible via Private Google Access
- **None**: No services accessible via PGA
- **Selected**: Only specified services via PGA

### UI-Based Configuration

1. **Navigate**: Organization → Security → VPC Service Control
2. **Create Perimeter**: Choose dry-run or enforced mode
3. **Add Resources**: Select projects, folders, or organization
4. **Configure Services**: Choose protected Google Cloud services
5. **Set Access Levels**: Define network and identity conditions

### Tables: Service Categories

| Category | Services | Protection Priority |
|----------|----------|-------------------|
| Storage | GCS, Cloud Storage, Filestore | High |
| Databases | Cloud SQL, Spanner, Bigtable | High |
| Analytics | BigQuery | High |
| Compute | VMs, GKE | Low-Medium |

### Code/Config Blocks

**Create Perimeter via API**:
```bash
# Create perimeter
gcloud access-context-manager perimeters create gcs-perimeter \
  --title="GCS Protection Perimeter" \
  --type=regular \
  --policy=POLICY_ID \
  --project=service-project-a
```

**Add Protected Services**:
```bash
# Add storage service
gcloud access-context-manager perimeters add-access \
  --perimeter=gcs-perimeter \
  --service=storage.googleapis.com
```

### Expert Insight

**Service Selection Strategy**:
- **Minimum Viable Perimeter**: Start with critical data services
- **Gradual Expansion**: Add services incrementally
- **Risk Assessment**: High-risk services first (databases, file storage)

**Testing Best Practices**:
- Always start with dry-run mode
- Test with non-production projects first
- Monitor Cloud Audit Logs for access patterns

## Access Context Manager Integration

### Overview
Access Context Manager defines the conditions under which access through VPC Service Control is allowed.

### Key Concepts

**Access Levels**:
- **Basic Levels**: IP ranges, geographical locations
- **Premium Levels**: Device policies, identity verification
- **Combined Conditions**: AND operations between attributes

### Basic Access Levels

**IP-Based Restriction**:
```yaml
conditions:
  - ipSubnetworks:
      - 192.168.1.0/24
      - 10.0.0.0/8
```

**Geographical Restriction**:
```yaml
conditions:
  - regions:
      - US
      - CA
```

**Combined Conditions**:
```yaml
conditions:
  - ipSubnetworks:
      - 192.168.1.0/24
    regions:
      - US
```

### Command Line Management

**Create Access Level**:
```bash
gcloud access-context-manager levels create corporate-ip \
  --title="Corporate IP Access" \
  --basic-level-spec=corp_network.yaml \
  --policy=POLICY_ID
```

### UI Configuration Steps

1. **Navigate**: Access Context Manager → Access Levels
2. **Create Level**: Define conditions (IP, geo, device)
3. **Attach to Perimeter**: Link access level to VPC Service Control perimeter
4. **Test Access**: Verify conditions work as expected

### Deep Dive: Access Level Logic

```
Access Decision Process:
├── Check IAM permissions ✓
├── Verify network location ✓
├── Validate geographical location ✓
├── Confirm device compliance ✓
└── Grant/deny access
```

### Common Issues

**Propagation Delays**:
- Access level changes take 5-10 minutes to propagate
- Clear browser cache when testing
- Use incognito mode for clean testing

**Condition Conflicts**:
- AND logic requires ALL conditions to be met
- OR logic not supported between different condition types
- Plan conditions carefully to avoid over-restriction

### Tables: Access Level Examples

| Condition Type | Example | Use Case |
|----------------|---------|----------|
| IP Range | 10.0.0.0/8 | Corporate VPN |
| Geographic | US, CA | Region compliance |
| Device | Chrome OS | Company devices |

```diff
+ Access levels provide granular control beyond IAM
- Changes require careful testing to avoid blocking legitimate access
```

## Identity-Aware Proxy (IAP) Integration

### Overview
IAP provides additional authentication layer with VPC Service Control, enabling single sign-on (SSO) for web applications.

### Key Concepts

**IAP Integration**:
- **OAuth 2.0 Flow**: Google handles authentication
- **Secure Web App User Role**: Required for user access
- **Context-Aware Access**: IP, device, and identity verification

### Setup Process

#### 1. Enable IAP
```bash
gcloud services enable iap.googleapis.com
```

#### 2. Configure OAuth Consent Screen
- Create consent screen for external applications
- Define authorized domains
- Set up branding

#### 3. Grant IAM Roles
```bash
# Grant IAP-secured web app user role
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member=user:USER@DOMAIN \
  --role=roles/iap.httpsResourceAccessor
```

#### 4. Enable IAP on Resources
- Web applications (Cloud Run, App Engine)
- HTTPS load balancers (with custom domains)
- GKE applications

### Integration with VPC Service Control

**Combined Protection**:
```yaml
VPC Service Control Perimeter:
  - Restricts network access
  - IAP handles identity verification
  - Combined: Network + Identity + Device control
```

### Deep Dive: IAP Flow

```
Authentication Flow:
├── User accesses protected URL
├── IAP intercepts request
├── Redirect to Google OAuth
├── User authenticates
├── IAP verifies access contexts
├── VPC Service Control checks perimeter
└── Grants access if all conditions met
```

### Code/Config Blocks

**Deploy Cloud Run with IAP**:
```bash
# Deploy service
gcloud run deploy my-app \
  --source=. \
  --platform=managed \
  --region=us-central1 \
  --allow-unauthenticated=false

# Enable IAP
gcloud run services proxy iap enable my-app \
  --region=us-central1
```

### Expert Insight

**When to Use IAP + VPC Service Control**:
- **Web Applications**: User-facing apps needing authentication
- **Employee Portals**: Internal tools requiring corporate access
- **Compliance Requirements**: Industries needing strict access controls

**Performance Impact**:
- Small latency increase due to OAuth redirects
- Pre-warm applications to reduce cold starts
- Use regional endpoints for better performance

## Bridge Perimeters

### Overview
Bridge perimeters allow controlled communication between separate VPC Service Control perimeters.

### Key Concepts

**Purpose**: Enable necessary cross-perimeter access while maintaining isolation.

**Use Cases**:
- Data transfer between production and analytics environments
- Shared services access across perimeters
- Third-party integration requiring access

### Configuration

**Bridge Perimeter Setup**:
```yaml
type: BRIDGE
perimeters:
  - production-perimeter
  - analytics-perimeter
restricted_services: []
access_levels: []
```

### Common Patterns

**Hub-and-Spoke Model**:
```
Central Bridge Perimeter:
├── Connected to multiple regular perimeters
├── Manages cross-perimeter communication
└── Applies consistent access controls
```

**Service-Specific Bridges**:
- BigQuery access bridges
- Cloud Storage transfer bridges
- Database replication bridges

### Tables: Bridge vs Regular Perimeters

| Aspect | Regular Perimeter | Bridge Perimeter |
|--------|------------------|-----------------|
| Purpose | Protect project resources | Connect perimeters |
| Isolation | Strict enforcement | Controlled connections |
| Access Control | Required for all access | Filtered by service/intent |

## Supported Services and Limitations

### Overview
VPC Service Control supports 194+ Google Cloud services with some exclusions.

### Supported Services

**High-Priority Storage**:
- Google Cloud Storage (GCS)
- Cloud Filestore
- Backup and DR services

**Databases**:
- Cloud SQL (MySQL, PostgreSQL, SQL Server)
- Cloud Spanner
- Cloud Bigtable
- Firestore/Native
- Memorystore
- AlloyDB

**Analytics & Data**:
- BigQuery
- Data Transfer Service

**Compute & Containers**:
- Compute Engine (optional)
- Kubernetes Engine (optional)
- Cloud Run
- Cloud Functions

### Unsupported Services

**Always Unsupported**:
- App Engine (Standard and Flexible)
- Cloud Shell
- Google Cloud Console

**Partner Services**: Most third-party services not supported

### Numbers Growth

The service count has grown:
- **Historical**: ~130 services
- **Current**: 194 services
- **Trend**: Continuously increasing

### VPC Accessible Services Options

| Setting | Description | Use Case |
|---------|-------------|----------|
| All | All Google APIs via PGA | Maximum flexibility |
| None | No APIs via PGA | Maximum security |
| Restricted | Specific services only | Balanced approach |

### Expert Insight

**Service Selection Strategy**:
- **Data Protection First**: Prioritize storage and database services
- **Risk-Based Selection**: High-value data services first
- **Incremental Adoption**: Start small, expand gradually

## Logs and Troubleshooting

### Overview
Cloud Audit Logs capture VPC Service Control access decisions for troubleshooting and compliance.

### Key Concepts

**Log Types**:
- **Activity Logs**: Successful/failed access attempts
- **Data Access Logs**: API usage patterns
- **System Event Logs**: Configuration changes

### Log Analysis

**VPC Service Control Events**:
```
resource.type="access_context_manager"
severity>=WARNING
jsonPayload.methodName:"VPC_SERVICE_CONTROL"
```

**Common Log Fields**:
- `device_state`: Authorized/unauthorized device
- `ip_address`: Source IP address
- `user_id`: Attempting user (may be masked)
- `resource_name`: Target resource
- `reason`: Failure reason

### Troubleshooting Steps

#### 1. Check Perimeter Configuration
```bash
# List perimeters
gcloud access-context-manager perimeters list \
  --policy=POLICY_ID
```

#### 2. Verify Access Levels
```bash
# List access levels
gcloud access-context-manager levels list \
  --policy=POLICY_ID
```

#### 3. Analyze Logs
```bash
# Search for denied access
gcloud logging read \
  'resource.type=access_context_manager AND severity>=WARNING' \
  --limit=10
```

### Common Error Messages

| Error | Cause | Resolution |
|-------|--------|------------|
| `Access denied by VPC Service Control` | Missing access level | Check perimeter configuration |
| `Resource not in VPC perimeter` | Unauthorized network | Verify IP/geographic conditions |
| `Insufficient permissions` | Missing IAM roles | Grant appropriate IAM roles |

### Expert Insight

**Log Masking**:
- Google masks user identifiers in logs by design
- Makes attribution challenging
- Implement additional monitoring/logging for compliance

**Propagation Issues**:
- Configuration changes take time to propagate
- Wait 5-15 minutes after changes
- Clear caches and use fresh sessions for testing

## Summary

### Key Takeaways
```diff
+ VPC Service Control provides firewall protection for Google Cloud services without native firewall capabilities
+ Creates security perimeters around projects to prevent data exfiltration
+ Integrates with Access Context Manager for network and device-based controls
+ Supports dry-run testing before enforcing rules
+ Covers 194+ services but excludes App Engine, Cloud Shell, and Cloud Console
+ Enables controlled cross-perimeter access via bridge perimeters
+ Provides comprehensive logging for troubleshooting and compliance
```

### Expert Insight

**Real-World Application**:
VPC Service Control is essential for enterprises needing to protect sensitive cloud resources. It's particularly valuable in regulated industries (finance, healthcare, government) where data residency and access control requirements are strict. The ability to restrict access to corporate networks while allowing authenticated users prevents credential theft attacks and ensures data sovereignty.

**Expert Path**:
- Master perimeter design and service selection strategies
- Understand integration patterns with IAP and Access Context Manager
- Learn advanced logging analysis for security monitoring
- Practice bridge perimeter configurations for complex architectures
- Study real-world deployment patterns in enterprise environments

**Common Pitfalls**:
- Overly restrictive access levels blocking legitimate access
- Forgetting to use dry-run mode before enforcement
- Not accounting for required Google-managed service account permissions
- Insufficient logging and monitoring of perimeter access
- Failure to design proper bridge perimeters for multi-project setups
- Ignoring propagation delays when testing changes
- Not planning for emergency access procedures during outages
- Assuming IAM alone provides sufficient protection

**Lesser Known Details**:
- Perimeter configurations can include folder-level and organization-level controls beyond individual projects
- Premium Access Context Manager features enable device policy enforcement (Chrome Enterprise required)
- VPC Service Control integrates with VPC peering for hybrid cloud scenarios
- Access levels support custom device attributes and identity provider-specific claims
- Bridge perimeters can have their own access level controls separate from connected perimeters
- Google continuously adds new supported services (growth from ~130 to 194 services in recent years)
