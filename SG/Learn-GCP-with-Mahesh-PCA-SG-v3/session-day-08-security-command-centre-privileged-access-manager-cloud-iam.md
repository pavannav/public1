# Session 08: Security Command Center, Privileged Access Manager, Cloud IAM

## Table of Contents
- [Security Command Center Overview](#security-command-center-overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
- [Lab Demos: Security Command Center](#lab-demos-security-command-center)
- [Key Concepts and Deep Dive (Continued)](#key-concepts-and-deep-dive-continued)
- [Lab Demos: Privileged Access Manager](#lab-demos-privileged-access-manager)
- [Summary](#summary)

## Security Command Center Overview

Security Command Center (SCC) is a centralized security and risk management platform provided by Google Cloud. It serves as a comprehensive dashboard for security reviewers and cloud architects to identify, assess, and remediate security issues across an organization.

### Purpose and Benefits
- **Centralized Visibility**: Provides a single pane of glass for all security findings across GCP resources
- **Automated Scanning**: Continuously monitors and scans GCP resources for misconfigurations and vulnerabilities
- **Compliance Tools**: Helps maintain compliance with various industry standards and regulations
- **Risk Assessment**: Generates risk scores and prioritizes findings based on severity

### Access Requirements
- Only available with an Organization node
- Free tier available (Standard Edition) with basic vulnerability scanning
- Enterprise features available via paid tiers

### Tiers Overview

| Tier | Cost | Key Features |
|------|------|--------------|
| Standard | Free | Vulnerability scanning, basic misconfiguration detection, security risks |
| Premium | Paid | Advanced IAM analysis, detailed risk assessments, custom findings |
| Enterprise | Paid | Advanced compliance tools, enterprise integrations, additional scanning modules |

> [!IMPORTANT]
> SCC helps cloud architects validate that security best practices are implemented and followed, providing proof through automated risk assessment.

## Key Concepts and Deep Dive

### Security Command Center as Homepage
Security Command Center should be treated as the homepage for security-focused roles (security engineers, reviewers, auditors, Cloud Architects). It shows the results of implementation efforts - clean slate indicates good security practices.

**Key Indicators Monitored:**
- Virtual machines with external IP addresses
- Publicly exposed Cloud Storage buckets
- Open RDP/SSH ports exposed to the entire internet
- Multiactor authentication settings at organization level
- Outdated libraries and packages
- IAM role privileges (over/under privileged)

**Standards Supported:**
- **CIS (Center for Internet Security)**: Benchmarks for Google Cloud security
  - Foundation level requirements for secure configurations
  - Example: CIS GCP Foundation 3.7 - Ensure VM instances do not have public IP addresses
- **NIST, ISO 27001**: Industry-standard security frameworks
- **HIPAA**: Specific compliance for healthcare data handling

### Organization Policies and SCC Integration
Organization policies work in conjunction with SCC to prevent security misconfigurations proactively:

**Key Organization Policies Related to Security:**
- **Disable External IPs**: Prevents automatic assignment of external IP addresses
- **Enforce Public Access Prevention**: Blocks public bucket creation and access
- **Resource Location Constraints**: Ensures resources are created in approved regions
- **VM Disk Encryption**: Mandates encrypted disks
- **Service Account Key Restrictions**: Prevents external API key usage

### Risk Overview Dashboard
The Risk Overview provides a comprehensive view of current vulnerabilities:

**Dashboard Components:**
- **Active Vulnerabilities Count**: Total findings across all projects
- **Finding Categories**:
  - **Bucket Permissions**: Public access, misconfigured IAM
  - **VM Security**: External IPs, open ports (RDP/SSH/HTTP)
  - **Network Ports**: Unrestricted firewall rules
  - **IAM Issues**: Missing MFA, non-org members with access
  - **Data Exposure**: Public BigQuery datasets, exposed storage

**Severity Levels:**
- Critical: Immediate security threats
- High: Potential security weaknesses
- Medium: Configuration improvements needed
- Low: Best practice recommendations

### Security Health Analytics (SHA)
- Standard tier includes basic vulnerability scanning
- SHA runs standard security scans based on Google security foundations
- Can be enabled/disabled per project
- Provides automated findings integration with SCC

### Additional Modules
Standard edition includes security health analytics with ability to enable:
- Service account analysis
- API key management
- Encryption at rest verification
- Sensitive data discovery

## Lab Demos: Security Command Center

### Demo 1: Basic SCC Dashboard Exploration

**Scenario**: Organization with mixed security practices showing various findings.

**Key Findings Observed:**
- 4 buckets with public access
- 2 RDP ports exposed globally
- SSH ports open to internet
- Missing multifactor authentication at org level
- Non-organization IAM members
- Outdated libraries in applications
- Public BigQuery datasets

**Command Sequence:**
```bash
# Navigate to Security Command Center
gcloud console navigate --project [PROJECT_ID]
# Go to Security > Security Command Center
# View Risk Overview dashboard
# Examine findings by category
```

### Demo 2: Organization Policy Implementation

**Step 1: Create Exemption for External IP (Business Requirement)**
```bash
# Grant Organization Policy Administrator role
gcloud organizations add-iam-policy-binding [ORG_ID] \
  --member=user:[EMAIL] \
  --role=roles/orgpolicy.policyAdmin

# Override organization policy at project level
gcloud org-policies set-policy --resource projects/[PROJECT_ID] \
  --policy-file=exemption.yaml
```

**Content of exemption.yaml:**
```yaml
name: projects/[PROJECT_ID]/policies/compute.disableExternalIp
spec:
  etag: "Ca3tMM9XaN...."
  rules:
  - kind: "booleanPolicy"
    spec:
      enforced: false
    inheritFromParent: false
  parent: organizations/[ORG_ID]
```

**Impact**: Project can now create VMs with external IPs, potentially creating security vulnerabilities.

### Demo 3: Public Bucket Exposure

**Step 1: Create and Expose Bucket**
```bash
# Create bucket
gsutil mb gs://[BUCKET_NAME]

# Upload sample data
echo "Sample data" > sample.txt
gsutil cp sample.txt gs://[BUCKET_NAME]/

# Make bucket publicly readable
gsutil iam ch allUsers:objectViewer gs://[BUCKET_NAME]
```

**Step 2: Access Public URL**
- Navigate to https://storage.googleapis.com/[BUCKET_NAME]/sample.txt
- Verify public access (works in incognito mode if authenticated elsewhere)

**Public Ranges Knowledge**: List of Google Cloud public IP ranges available at `https://support.google.com/cloud/answer/9915152`

### Demo 4: Organization-Level Fix with Enforcement Policy

**Step 1: Enable Public Access Prevention**
```bash
gcloud org-policies set-policy --resource organizations/[ORG_ID] \
  --policy-file=public-access-prevention.yaml
```

**Content of public-access-prevention.yaml:**
```yaml
name: organizations/[ORG_ID]/policies/storage.publicAccessPrevention
spec:
  rules:
  - enforce: true
```

**Impact**: 
- Removes public access from existing buckets immediately
- Prevents new public bucket creation
- Fixes multiple vulnerabilities automatically

### Demo 5: Individual Finding Remediation

**Example: Fix RDP Port Exposure**
```bash
# View current firewall rules
gcloud compute firewall-rules list

# Update firewall rule to restrict RDP access
gcloud compute firewall-rules update [RDP_RULE_NAME] \
  --source-ranges=[YOUR_IP/CIDR]
```

**Example: Remove Public Bucket Access**
```bash
# Remove allUsers permission
gsutil iam ch -d allUsers:objectViewer gs://[BUCKET_NAME]
gsutil iam ch -d allAuthenticatedUsers:objectViewer gs://[BUCKET_NAME]
```

**Example: Fix External VM IP**
```bash
# Update VM to remove external IP
gcloud compute instances update [VM_NAME] \
  --delete-access-configs
```

**Example: Clean Up Public BigQuery Dataset**
```bash
# Remove public permissions
bq show --format=prettyjson [PROJECT_ID]:[DATASET_ID] |
jq '.access[] | select(.specialGroup=="allAuthenticatedUsers")' |
bq remove-iam-policy-binding --member=allUsers [PROJECT_ID]:[DATASET_ID]

# Or through Console: BigQuery > Dataset > Sharing > Remove allUsers
```

## Key Concepts and Deep Dive (Continued)

### Limitations of Organization Policies
While organization policies prevent many issues, they don't cover everything:
- Custom policies needed for BigQuery dataset access (not supported natively)
- Manual intervention required for existing resources (retrospective enforcement)
- Firewall rules managed via VPC firewall policies (separate from org policies)

### Custom Security Findings
SCC supports custom detectors for organization-specific requirements:
- Create custom security findings
- Integrate with third-party security tools (e.g., Prisma Cloud, Check Point)
- Use Security API for automation and custom integrations

### Integration with Third-Party Tools
- Marketplace connectors available for enhanced security scanning
- Examples: CrowdStrike, vulnerability scanners, compliance frameworks
- Can export findings for external analysis

### Exporting Security Findings
**Methods to Export Findings:**
- JSON/CSV export for analysis
- Dashboard integration possibilities
- API-based access for custom reporting

**Sample Export Command:**
```bash
# Export findings to Cloud Storage
gsutil cp findings_$(date +%Y%m%d).json gs://[BUCKET_NAME]/
```

## Lab Demos: Privileged Access Manager

### Overview of Privileged Access Manager (PAM)
- **Purpose**: Temporal access control for elevated privileges
- **Status**: Preview (as of session date)
- **Key Features**: 
  - Request-based approval workflow
  - Time-limited access grants
  - Audit trail for all actions
  - Justification and approval requirements

### Demo Setup: Creating Entitlements

**Step 1: Create Storage Admin Entitlement**
```bash
# Through Console - Security > Privilege Access Manager
# Create new entitlement for specific users
```

**Entitlement Configuration:**
- Resource scope (org/project/folder level)
- Roles: `roles/storage.admin`
- Maximum duration: 1 hour
- Requester groups: Specified Google Groups
- Approver groups: Specified approvers
- Requirements: Justification from requester and approver

**Step 2: Request Access as User**
```bash
# As requester - submit request with justification
# As approver - review and grant/deny
```

### Demo: Access Flow with Justification

**Scenario**: Developer needs temporary access to modify Cloud Storage bucket permissions.

**Request Process:**
1. User requests access via PAM interface
2. Provides business justification
3. Approver reviews and grants access
4. User gains temporary elevated privileges
5. Access automatically expires after specified duration

**Audit Features:**
- All requests and approvals logged
- Justifications tracked
- Time-stamped access grants
- Automatic revocation

### Security Considerations in PAM
- **Scope**: Proper entitlement scoping (org vs project level)
- **Approvals**: Multi-level approval chains if needed
- **Audit**: Complete audit trail captures all actions
- **Compliance**: GDPR/CCPA compliant for privilege access logging

### Comparison: PAM vs Traditional IAM

| Aspect | Traditional IAM | Privilege Access Manager |
|--------|-----------------|---------------------------|
| Access Model | Persistent roles | Time-bound grants |
| Approval | Manual IAM grants | Workflow-based approvals |
| Audit | Basic IAM logs | Detailed justification trail |
| Just-In-Time | Limited | Core feature |
| Use Cases | Standard users | Sensitive operations |

## Summary

### Key Takeaways
```diff
+ Security Command Center (SCC) provides centralized visibility into GCP security posture
+ Organization policies enable proactive security enforcement across all projects
+ SCC integrates with security health analytics for automated vulnerability scanning
+ Privileged Access Manager (PAM) enables time-limited elevated access with audit trails
- Always enable organization policies before creating resources for maximum security coverage
- Public buckets and external IPs create significant security risks and exposure
! Maintain least privilege access and regularly review SCC findings for compliance
```

### Quick Reference

**Important SCC Commands:**
```bash
# Check current SCC findings (via API)
curl -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  "https://securitycenter.googleapis.com/v1/organizations/[ORG_ID]/securityCenterServices/findings"

# Enable public access prevention org policy
gcloud org-policies set-policy --resource organizations/[ORG_ID] \
  --policy-file=enable-pap.yaml
```

**Common Finding Categories:**
- **Bucket Exposures**: Remove `allUsers`/`allAuthenticatedUsers` permissions
- **VM External IPs**: Use load balancers or Cloud NAT for external access
- **Open Ports**: Restrict firewall rules to specific IP ranges
- **MFA Settings**: Enable multifactor authentication at org level

**PAM Access Request Sample:**
```bash
# Request elevated access (Console-based operation)
# 1. Navigate to Privileged Access Manager
# 2. Select appropriate entitlement
# 3. Specify duration (within max limit)
# 4. Provide business justification
# 5. Submit for approval
```

### Expert Insight

**Real-world Application**: 
SCC serves as the central nervous system for security teams, providing automated detection of issues that would otherwise require manual discovery. In enterprise environments, SCC integrates with SIEM tools and helps maintain compliance with standards like CIS, NIST, and SOC 2. PAM complements SCC by enabling secure, auditable temporary access escalations for troubleshooting and emergency maintenance.

**Expert Path**: 
Master SCC by enabling all available security health analytics modules and creating custom detectors for organization-specific requirements. Learn to export and analyze findings programmatically using the Security API. For PAM, understand entitlement scoping and integrate approval workflows with existing change management processes.

**Common Pitfalls**:
- Ignoring SCC standard tier because it's "free" - it provides valuable security insights
- Forgetting retrospective enforcement limitations in organization policies
- Not scoping PAM entitlements properly (overly broad access grants)
- Treating SCC as reactive instead of proactive monitoring
- Manual remediation of findings without addressing root causes

**Lesser-Known Facts**:
- SCC's public access prevention works retroactively on existing resources (unlike many org policies)
- PAM is currently in preview but can be used in production with proper documentation of limitations
- SCC findings update in real-time but may take minutes to reflect policy changes
- The standard edition includes comprehensive vulnerability scanning but enterprise features require custom integrations

**Advantages and Disadvantages of Security Command Center:**

| Advantages | Disadvantages |
|------------|--------------|
| Centralized security dashboard | Only available with org node |
| Automated vulnerability scanning | Standard tier has limitations |
| Integration with org policies | Requires premium/enterprise for advanced features |
| Free basic scanning | Learning curve for custom detectors |
| API-driven automation | Preview status for new features |

**Advantages and Disadvantages of Privileged Access Manager:**

| Advantages | Disadvantages |
|------------|--------------|
| Time-limited access grants | Currently in preview |
| Full audit trails | No support commitments |
| Workflow-based approvals | Requires org node |
| Reduces permanent privilege risks | Limited to predefined/custom roles |
| Compartible with existing IAM | Invitation for privileged operations |
```
