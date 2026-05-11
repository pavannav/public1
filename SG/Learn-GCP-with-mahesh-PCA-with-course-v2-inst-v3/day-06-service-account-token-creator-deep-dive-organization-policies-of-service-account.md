<details open>
<summary><b>Day 06: Service Account Token Creator Deep Dive, Organization Policies of Service Account (KK-CS45-script-v2-Inst-v3)</b></summary>

# Session 06: Service Account Token Creator Deep Dive and Organization Policies

## Overview

This session provides an in-depth exploration of Google Cloud Platform (GCP) service account authentication mechanisms, focusing on advanced impersonation techniques using the Service Account Token Creator role. The session demonstrates secure and insecure patterns of service account usage, organization-level governance through policies, and practical security considerations for service account keys.

## Key Concepts / Deep Dive

### Service Account User Role Recap

The session begins with a recap of service account roles established in previous sessions:
- Service account user role for attaching service accounts to resources
- Service account token creator role for impersonation capabilities
- Role-based access control (RBAC) principles applied to service accounts

### Service Account Token Creator Role Deep Dive

**Core Functionality:**
The Service Account Token Creator role enables privileged users to generate access tokens on behalf of service accounts through impersonation.

**Key Permissions:**
```bash
iam.serviceAccounts.getAccessToken
```

**Practical Demonstration:**
```bash
# Enable impersonation
gcloud config set auth/impersonate_service_account [SERVICE-ACCOUNT-EMAIL]

# Generate access tokens
gcloud auth print-access-token

# List storage buckets (inherits service account permissions)
gsutil ls
```

**Security Considerations:**
> [!IMPORTANT]
> The service account token creator role provides significant privilege escalation capabilities. Limit this role to trusted administrators and implement least-privilege access patterns.

### Identity Tokens and OpenID Connect

**OIDC Identity Tokens:**
Unlike access tokens used for authorization, identity tokens enable authentication and can contain user or service identity claims.

**Required Permission:**
```bash
iam.serviceAccounts.getOpenIdToken
```

**Token Generation:**
```bash
gcloud auth print-identity-token
```

### Cloud Run Authentication Demonstrations

**Public Service Configuration:**
- Create Cloud Run service with open unauthenticated invocation
- Allow all users access to the endpoint

**Private Service Configuration:**
- Require authentication for Cloud Run access
- Grant Cloud Run Invoker role to specific principals

**Service Account Integration:**
- Attach service accounts to Cloud Run for resource access
- Demonstrates service-to-service communication patterns

### Custom Role Creation for Least Privilege

**Minimal Permission Role:**
The session demonstrates creating custom roles with single permissions rather than using overly broad predefined roles.

**Example Custom Role:**
```yaml
title: "get-access-token-only"
name: "roles/getAccessTokenOnly.custom"
includedPermissions:
- iam.serviceAccounts.getAccessToken
```

**Benefits:**
- Reduces attack surface
- Follows principle of least privilege
- Enables granular access control

### Multi-Level Impersonation

**Service Account to Service Account Impersonation:**
- Enable IAM Service Account Credentials API
- Grant service account token creator role to another service account
- Demonstrates cascading privilege delegation

**Command Pattern:**
```bash
# Virtual machine with attached service account
gcloud auth print-identity-token

# Impersonation from host service account to target service account
gcloud --impersonate-service-account=[TARGET-SA] auth print-identity-token
```

### Service Account Keys Security Analysis

**Key Generation Process:**
```bash
# Create service account key
gcloud iam service-accounts keys create [KEY-FILE] \
  --iam-account=[SERVICE-ACCOUNT-EMAIL]

# Activate service account with key
gcloud auth activate-service-account --key-file=[KEY-FILE]
```

**Security Risks:**
> [!WARNING]
> Service account keys are long-lived credentials that never expire by default. Compromised keys pose severe security risks including:
> - Unauthorized resource access
> - Privilege escalation
> - Cost overruns from malicious usage

**Key Characteristics:**
- RSA 2048-bit encrypted private keys
- Stored as JSON format
- Contain service account email and project information
- Downloadable only once

### Organization Policies for Service Account Governance

**Key Organization Constraints:**

| Policy Name | Function | Recommendation |
|-------------|----------|----------------|
| `constraints/iam.disableServiceAccountCreation` | Block new service account creation | Use during project freeze/migration |
| `constraints/iam.disableServiceAccountKeyCreation` | Block external key generation | Enable for enhanced security |
| `constraints/iam.maxServiceAccountKeyLifetime` | Limit key expiry duration | Set to minimum required |
| `constraints/iam.serviceAccountKeyExpiryInTime` | Define maximum key lifecycle | Enforce rotation practices |

**Implementation Example:**
```bash
# Disable service account key creation at organization level
gcloud resource-manager org-policies enable-enforce \
  constraints/iam.disableServiceAccountKeyCreation \
  --organization=[ORG-ID]
```

### Service Account Key Rotation Best Practices

**Manual Rotation Process:**
1. Create new service account key
2. Update applications with new key
3. Delete old key
4. Verify application functionality

**Automated Rotation:**
Google Cloud does not provide built-in key rotation. Implement custom scripts using:
- Cloud Scheduler
- Cloud Functions
- Custom automation pipelines

### Workload Identity Federation Overview

**Use Cases:**
- Cross-cloud authentication (AWS, Azure, on-premises)
- GitHub Actions integration
- External identity providers

**Supported Providers:**
- AWS
- Azure AD
- OIDC-compliant providers
- SAML 2.0 providers

### Real-World Impersonation Scenarios

**Use Case 1: Developer Access:**
```bash
# Developer impersonates service account for testing
gcloud config set auth/impersonate_service_account [DEV-SA]
gcloud storage buckets list
```

**Use Case 2: Automated Deployments:**
- CI/CD pipelines impersonate service accounts
- Service accounts granted minimal required permissions

**Use Case 3: Cross-Service Communication:**
- Cloud Run services access Cloud Storage via attached service accounts
- Service accounts granted resource-specific roles

### Service Account Roles Matrix

| Role | Permissions | Use Case |
|------|-------------|----------|
| `roles/iam.serviceAccountUser` | Attach service accounts to resources | VM attachments, resource binding |
| `roles/iam.serviceAccountTokenCreator` | Generate access/identity tokens | Impersonation, token generation |
| `roles/iam.serviceAccountOpenIdTokenCreator` | Create OIDC identity tokens | Authentication flows |
| `roles/iam.workloadIdentityUser` | K8s workload identity | Container orchestration |
| `roles/iam.serviceAccountKeyAdmin` | Manage service account keys | Key lifecycle management |
| `roles/iam.serviceAccountAdmin` | Full service account management | Service account administration |

### Security Best Practices

**Key Recommendations:**
> [!NOTE]
> - Disable service account key creation through organization policies
> - Implement least-privilege access patterns
> - Use custom roles with minimal permissions
> - Enable key expiry constraints
> - Prefer workload identity federation over keys
> - Implement regular security audits

## Summary

### Key Takeaways

```diff
+ Service Account Token Creator enables secure impersonation without key management
- Service account keys pose significant security risks and should be avoided when possible
! Organization policies provide enterprise governance for service account usage
+ Identity tokens enable authentication flows separate from authorization (access tokens)
+ Multi-level impersonation allows for complex delegation patterns
+ Workload identity federation provides keyless authentication for modern workloads
```

### Quick Reference

**Common Commands:**
```bash
# Impersonate service account
gcloud config set auth/impersonate_service_account [SA-EMAIL]

# Generate access token
gcloud auth print-access-token

# Generate identity token
gcloud auth print-identity-token

# Create service account key (avoid when possible)
gcloud iam service-accounts keys create key.json --iam-account [SA-EMAIL]

# Enable organization policy
gcloud resource-manager org-policies enable-enforce \
  constraints/iam.disableServiceAccountKeyCreation
```

**Role Comparison Table:**

| Feature | Service Account User | Token Creator | OpenID Token Creator |
|---------|---------------------|---------------|---------------------|
| Attach to resources | ✅ | ❌ | ❌ |
| Generate access tokens | ❌ | ✅ | ❌ |
| Generate identity tokens | ❌ | ✅ | ✅ |
| Minimal permissions | Limited | Single permission possible | Single permission |

### Expert Insights

**Real-world Application:**
Service account impersonation is widely used in GCP deployments for secure, automated workflows. Organizations implement token-based authentication to eliminate long-lived credentials while maintaining auditability.

**Expert Path:**
1. Master organization policy configuration for service accounts
2. Implement workload identity federation for all new applications
3. Design custom roles with granular permissions
4. Establish service account key rotation procedures
5. Configure security monitoring for anomalous token usage

**Common Pitfalls:**
- Over-reliance on default service account with editor role
- Sharing service account keys across environments
- Neglecting key rotation schedules
- Granting overly broad permissions during development
- Failing to implement organization-level constraints

**Lesser-Known Facts:**
- Service accounts have an internal private key used by Google services (never exposed)
- Token creator role enables cross-project access without resource-level grants
- Cloud Run's default service account gets editor role automatically (can be disabled)
- Service account keys can be restricted to specific IP ranges in some cases
- The `iam.serviceAccountCredentialsAPI` is required for programmatic impersonation

**Advantages vs Disadvantages:**

**Advantages:**
- Granular access control through impersonation
- No credential management overhead
- Audit trails for all operations
- Compatible with modern CI/CD pipelines
- Scalable across large organizations

**Disadvantages:**
- Complex initial configuration
- Propagation delays for permissions
- Limited delegation depth (service account can impersonate others, but chains have limits)
- Requires enabling additional APIs
- steeper learning curve for teams new to GCP
</details>