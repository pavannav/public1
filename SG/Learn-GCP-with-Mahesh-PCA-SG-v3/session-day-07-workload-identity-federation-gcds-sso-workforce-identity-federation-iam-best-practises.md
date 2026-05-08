# Session 07: Workload Identity Federation, GCDS, SSO, Workforce Identity Federation, IAM Best Practices

## Table of Contents
- [Workload Identity Federation](#workload-identity-federation)
- [Google Cloud Directory Sync (GCDS)](#google-cloud-directory-sync-gcds)
- [Single Sign-On (SSO)](#single-sign-on-sso)
- [Workforce Identity Federation](#workforce-identity-federation)
- [IAM Best Practices](#iam-best-practices)

## Workload Identity Federation

### Overview
Workload identity federation enables external workloads (AWS EC2, Azure VMs, GitHub Actions, Terraform, etc.) to access Google Cloud resources without long-lived service account keys, eliminating security risks associated with key management and rotation.

### Key Concepts / Deep Dive

#### What Problem Does It Solve?
Traditional approach with service accounts requires generating long-lived keys that don't expire and pose security risks if compromised. Workload identity federation uses short-lived tokens obtained through identity providers supporting OpenID Connect.

#### Federated Identity Format
Federated identities follow this pattern for service accounts:
```
principalSet://iam.googleapis.com/projects/[PROJECT_NUMBER]/locations/global/workloadIdentityPools/[POOL_NAME]/subject/[SUBJECT_ATTRIBUTE]
```

#### How It Works
The process consists of four main steps:

1. **Create Workload Identity Pool**: A container for external identities in your project
2. **Add Identity Provider**: Configure which external sources can authenticate (e.g., GitHub, AWS)
3. **Configure Attribute Mapping**: Map external identity attributes to Google Cloud principals
4. **Grant Service Account Permissions**: Allow the external identity to act as a service account

#### GitHub Actions Demo
**Prerequisites**:
- Free GitHub account
- Private repository (recommended for security)
- Google Cloud project with enabled APIs

**GitHub Repository Creation**:
```
Repository Name: workload-identity-federation-demo
Visibility: Private
```

**Workload Identity Pool Setup**:
```
Pool Name: github-storage-list
Description: GitHub workload identity federation for storage access
Enable Pool: Yes
```

**Identity Provider Configuration**:
```
Provider Name: github-storage-list
Issuer URL: https://token.actions.githubusercontent.com
Audience: (Default)
```

**Attribute Mapping**:
```
assertion.sub: attribute.repository
```

**Principal Format**:
```
principalSet://iam.googleapis.com/projects/[PROJECT_NUMBER]/locations/global/workloadIdentityPools/github-storage-list/attribute.repository/gcp-mahes/workload-identity-federation-demo
```

**Service Account Creation**:
```
Service Account Name: github-wif-sa
Roles: Storage Admin
```

**Required Permissions**:
- Service Account Workload Identity User role to the principal
- Service Account Token Creator role for the administrator

#### GitHub Actions Workflow
Create `.github/workflows/gcs-list.yml`:

```yaml
name: List GCS Buckets
on:
  workflow_dispatch:
  push:
    branches: [ main ]

permissions:
  id-token: write   # Required to generate OIDC token
  contents: read    # Required to check out repository

jobs:
  list-buckets:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: 'Authenticate to Google Cloud'
      id: 'auth'
      uses: 'google-github-actions/auth@v2'
      with:
        workload_identity_provider: projects/123456789/locations/global/workloadIdentityPools/github-storage-list/providers/github-storage-list
        service_account: github-wif-sa@gcp-project.iam.gserviceaccount.com

    - name: 'Set up Cloud SDK'
      uses: 'google-github-actions/setup-gcloud@v2'

    - name: 'List buckets'
      run: 'gcloud storage buckets list'

```

#### Token Exchange Flow
1. GitHub Actions requests JWT from GitHub's OIDC provider
2. GitHub signs and returns JWT with repository, actor, and subject claims
3. Google Cloud validates JWT signature and audience
4. Mapped attributes create the principal identifier
5. Principal receives short-lived credentials through Security Token Service

#### Supported Providers
- ✅ AWS, Azure, GitHub, GitLab (out-of-the-box with OpenID Connect)
- ✅ On-premise with Active Directory Federation Services
- ✅ Custom providers with OpenID Connect support

### Summary

**Key Takeaways**:
- ✅ Eliminates service account key management complexity
- ✅ Enables secure external workload authentication
- ✅ Uses short-lived tokens (1-hour expiry by default)
- ✅ Works with any OpenID Connect-compatible identity provider
- ❌ Requires project-level administration
- ❌ Complex initial setup for multiple projects

**Quick Reference**:
```
# Create workload identity pool
gcloud iam workload-identity-pools create github-storage-list \
  --location=global \
  --project=gcp-project

# Create OIDC provider
gcloud iam workload-identity-pools providers create-oidc github-storage-list \
  --workload-identity-pool=github-storage-list \
  --issuer-uri=https://token.actions.githubusercontent.com \
  --attribute-mapping=google.subject=assertion.sub \
  --project=gcp-project

# Grant permissions
gcloud iam service-accounts add-iam-policy-binding github-wif-sa@gcp-project.iam.gserviceaccount.com \
  --role=roles/iam.serviceAccountTokenCreator \
  --member=principalSet://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/github-storage-list/attribute.repository/gcp-mahes/workload-identity-federation-demo
```

**Expert Insight**:

**Real-world Application**: Essential for CI/CD pipelines, multi-cloud architectures, and secure external integrations without exposing long-lived credentials.

**Expert Path**: Master attribute mapping configurations and understand token validation flows for complex federated scenarios.

**Common Pitfalls**:
- ❌ Granting permissions at project scope instead of principal scope
- ❌ Using repository names instead of attribute mappings
- ❌ Forgetting to configure audience in provider settings

**Lesser-Known Facts**:
- Workload identity pools are global resources but can only be created in projects
- OIDC tokens can include custom claims for fine-grained access control
- Integration with Security Token Service enables cross-cloud authentication

**Advantages**:
- Short-lived credentials reduce security risks
- No key rotation required
- Centralized identity management
- Standards-based (OpenID Connect)

**Disadvantages**:
- Complex initial setup
- Project-scoped configuration (not organization/folder)
- Requires external provider OIDC support

## Google Cloud Directory Sync (GCDS)

### Overview
Google Cloud Directory Sync enables one-way synchronization of users, groups, and organizational data from an external directory service (typically Microsoft Active Directory) to Google Cloud Identity, enabling centralized identity management without password synchronization.

### Key Concepts / Deep Dive

#### Architecture
```
Active Directory/LDAP Server → GCDS Agent → Google Cloud Identity
```

#### Installation and Setup
1. Download Google Cloud Directory Sync installer
2. Install on Windows (for Active Directory) or Linux (for LDAP/OpenLDAP)
3. Configure connection to directory source
4. Select objects to sync (users, groups, organizational units)
5. Map attributes between external directory and Google Cloud
6. Schedule automatic synchronization

#### What Gets Synchronized
- ✅ Users (excluding passwords)
- ✅ Groups and group memberships
- ✅ Organizational structure
- ✅ Contact information
- ✅ Custom attributes (configurable)
- ❌ Passwords (security intentionally excluded)

#### Single Sign-On Integration
After directory synchronization, enable SSO:

1. Navigate to Security → Authentication → SSO with third-party identity providers
2. Choose SAML application type
3. Configure SAML metadata from external IdP (AD FS, Okta, Ping, etc.)
4. Set up signing certificates and endpoints
5. Configure attribute mappings for user properties

### Summary

**Key Takeaways**:
- ✅ Enables centralized user management from on-premise AD
- ✅ Supports complex organizational hierarchies
- ✅ One-way sync prevents Cloud Identity modifications from affecting source
- ❌ Requires dedicated Windows/Linux server for sync agent
- ❌ No password synchronization (security feature)

## Single Sign-On (SSO)

### Overview
Single Sign-On enables users to authenticate once and access multiple Google Cloud services without re-entering credentials, improving security and user experience.

### Key Concepts / Deep Dive

#### SSO Providers Supported
- Google Workspace (cloud identity)
- Third-party SAML providers (e.g., Okta, Ping Identity, OneLogin)
- External SAML identity providers with Active Directory federation

#### Implementation Flow
1. User accesses Google Cloud console
2. Console redirects to configured SSO endpoint
3. User authenticates with identity provider
4. Identity provider issues SAML assertion
5. Google Cloud validates assertion and creates session

#### Domain Configuration
```
# Organization domain: yourcompany.com
# SSO URL: https://signin.yourcompany.com/adfs/ls/
# SAML Metadata: Provided by IdP
# Name ID Format: emailAddress
```

### Summary

**Key Takeaways**:
- ✅ Improves user experience with single authentication
- ✅ Reduces password fatigue and credential reuse
- ✅ Centralized authentication management
- ❌ Requires careful configuration of SAML metadata
- ❌ May require federation server (AD FS) setup

## Workforce Identity Federation

### Overview
Workforce identity federation extends Google Cloud access to employees, contractors, and partners from external identity providers without synchronizing identities to Cloud Identity, enabling secure collaboration while maintaining external identity management.

### Key Concepts / Deep Dive

#### Key Differences from Workload Identity
- 🔄 Users vs. Applications
- 🔄 Humans vs. Service accounts
- 🔄 External workforce vs. External workloads
- 🔄 Single sign-on vs. Token-based authentication

#### Prerequisites
- Organization node (org.google.com domain required)
- Supported identity providers (Azure AD, Okta, Ping, custom SAML/LDAP)
- Configured federation servers

#### When to Use
- Multiple external workforce accesses Google Cloud
- Need for centralized external identity management
- Security policies require external IAM control
- Temporary or contractor access requirements

#### Access Flow
```
External User → SAML Authentication → Workforce Identity Pool → Google Cloud Access
```

### Summary

**Key Takeaways**:
- ✅ Enables seamless external workforce access
- ✅ No identity synchronization required
- ✅ Maintains external identity governance
- ❌ Requires organization node and federation setup
- ❌ Complex setup with SAML requirements

## IAM Best Practices

### Overview
IAM best practices focus on implementing least privilege access, proper role management, and security controls to prevent unauthorized access while maintaining operational efficiency.

### Key Concepts / Deep Dive

#### Groups vs Individual User Grants

**Principles**:
- Grant roles to groups, not individual users
- Use Google Groups with domain prefixes for clarity
- Scale access management through group membership changes

**Demonstration**:
```bash
# Create Google Group
# Members: developer@company.com, contractor@company.com

# Grant group role
gcloud projects add-iam-policy-binding $PROJECT \
  --member="group:developers@company.com" \
  --role="roles/editor"
```

**Benefits**:
- Easier onboarding/offboarding
- Reduced IAM policy complexity
- Centralized access management

#### Principle of Least Privilege

**Grant minimum required permissions**:
```
User Needs: Storage upload/download
❌ Grant: Storage Admin (over-permissive)
✅ Grant: Storage Object User (appropriate)
```

**Built-in Roles Comparison**:

| Role Type | Permissions | Use Case |
|-----------|-------------|----------|
| Viewer | Read-only access | Auditors, support staff |
| Editor | CRUD operations | Developers, admins with create/modify needs |
| Owner | Full control | Resource owners, limited set |

#### Service Account Management

**Best Practices**:
- ✅ Use service accounts for non-human authentication
- ✅ Attach to resources, don't grant project-level roles
- ❌ Avoid default service account automatic Editor grants
- ✅ Rotate keys regularly (if used) or prefer workload identity
- ✅ Use custom roles for specific permissions
- ✅ Enable key rotation organization policies

**Key Prevention**:
```bash
# Enable organization policy
gcloud resource-manager org-policies enable-enforce \
  iam.automaticIamGrantsForDefaultServiceAccounts \
  --organization=123456789
```

#### Access Scope vs IAM

**Access Scopes (Legacy)**:
```bash
gcloud compute instances create my-instance \
  --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write
```

**Why IAM is Better**:
- ✅ Granular permission control
- ✅ Dynamic policy updates
- ✅ Audit trail of access
- ✅ No instance restart required for changes

#### Organization Policy Constraints

**Common IAM Constraints**:
- `iam.allowedPolicyMemberDomains`: Restrict principals to specific domains
- `iam.disableServiceAccountCreation`: Prevent service account creation
- `iam.disableServiceAccountKeyCreation`: Block service account key generation

#### Regular Audits and Monitoring

**Audit Commands**:
```bash
# Check recent IAM policy changes
gcloud logging read "protoPayload.methodName=SetIamPolicy" --freshness=30d

# Monitor service account key usage
gcloud logging read "protoPayload.serviceName=iamcredentials.googleapis.com" --freshness=7d

# Recommender insights
gcloud recommender insights list \
  --insight-type=google.iam.policy.Insight \
  --location=global
```

### Summary

**Key Takeaways**:
- ✅ Use groups for scalable access management
- ✅ Implement least privilege access
- ✅ Prefer IAM over access scopes
- ✅ Enable organization policies for security
- ✅ Regular audits and role review

**Quick Reference**:

**Role Granting Patterns**:
```
# Project-level (Limit use)
gcloud projects add-iam-policy-binding $PROJECT_ID --member=user:$USER --role=$ROLE

# Resource-level (Preferred)
gcloud <service> <resource> add-iam-policy-binding $RESOURCE --member=user:$USER --role=$ROLE

# Group membership
gcloud identity groups memberships add --group=$GROUP --member=user:$USER
```

**Expert Insight**:

**Real-world Application**:
- Multi-cloud enterprise environments
- DevSecOps pipelines with automatic access management
- Regulatory compliance scenarios (SAS 70, SOC 2)

**Expert Path**:
- Variable-length subnet masking for network efficiency
- Advanced BGP configuration for routing optimization
- Service mesh patterns with Envoy proxy

**Common Pitfalls**:
- ⚠️ Granting Editor role when Developer role suffices
- ⚠️ Using project scope when resource scope is appropriate
- ⚠️ Ignoring organization policy enforcement

**Lesser-Known Facts**:
- Service account keys can be domain-scoped for additional security
- IAM deny policies can override allow policies for security controls
- Workload identity federation supports custom attribute mapping

**Advantages**:
- Granular access control
- Centralized identity management
- Audit trail for all operations
- Reduced key management overhead

**Disadvantages**:
- Initial setup complexity
- Learning curve for new users
- Potential for role explosion in large organizations

---
🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
