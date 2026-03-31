# Session 06: Service Account Token Creator Deep Dive, Organization Policies of Service Account

## Table of Contents
- [Recap of Previous Session on Service Account Token Creator](#recap-of-previous-session-on-service-account-token-creator)
- [Access Tokens vs. Identity Tokens](#access-tokens-vs-identity-tokens)
- [Demo: Identity Tokens with Cloud Run](#demo-identity-tokens-with-cloud-run)
- [Custom Roles and Permissions](#custom-roles-and-permissions)
- [Sign Blobs and JWTs](#sign-blobs-and-jwts)
- [Workload Identity Federated Credentials](#workload-identity-federated-credentials)
- [Service Account Keys: Creation, Risks, and Management](#service-account-keys-creation-risks-and-management)
- [Organization Policies for Service Accounts](#organization-policies-for-service-accounts)
- [Best Practices for Service Accounts](#best-practices-for-service-accounts)

## Recap of Previous Session on Service Account Token Creator

### Overview
In the previous session, we explored service account authentication through impersonation, focusing on attaching service accounts to resources to enable secure processes. The key role discussed was the Service Account Token Creator, which allows a principal (like a user) to generate tokens on behalf of a service account without additional privileges.

### Key Concepts/Deep Dive
Service accounts enable machines or applications to authenticate to Google Cloud services. Attaching a service account to a resource grants it specific IAM roles, allowing automated tasks like accessing storage or launching VMs.

The Service Account Token Creator role uses a single crucial permission: `iam.serviceAccounts.getAccessToken`. This is more secure than broader roles because it limits impact.

Impersonation flags (e.g., `--impersonate-service-account`) let you act as a service account with minimal privileges.

> [!IMPORTANT]
> Access tokens are short-lived (up to 1 hour) and destined to expire, preventing indefinite access.

## Access Tokens vs. Identity Tokens

### Overview
Access tokens authorize API calls to Google Cloud services, while identity (OpenID Connect) tokens handle authentication for external services, confirming user or service identity.

### Key Concepts/Deep Dive
- **Access Tokens**: Used for Google Cloud API authorization. Opaque tokens not decodable locally; validateable via endpoints.
- **Identity Tokens**: JWTs for OpenID Connect authentication, typically used with third-party services like Cloud Run.

```diff
+ Access Tokens: For authorizing Google Cloud API requests
- Identity Tokens: For authenticating to external services
```

### Code/Config Blocks
To generate an access token:
```bash
gcloud auth print-access-token --impersonate-service-account=your-sa@project.iam.gserviceaccount.com
```

For identity token:
```bash
gcloud auth print-identity-token --impersonate-service-account=your-sa@project.iam.gserviceaccount.com
```

> [!NOTE]
> Propagate permissions carefully; changes may take time.

## Demo: Identity Tokens with Cloud Run

### Overview
Cloud Run demonstrates identity tokens for service authentication. A private Cloud Run service requires identity tokens, not access tokens, ensuring only authorized access.

### Key Concepts/Deep Dive
Cloud Run is a serverless platform for containerized applications. For private services:
1. Disable unauthenticated invocations.
2. Grant `roles/run.invoker` to principals.
3. Use identity tokens for requests.

The demo involved:
- Creating a public Cloud Run service (allowing anyone).
- Switching to private by rejecting `allUsers` access.
- Granting invoker roles to service accounts.
- Generating and using identity tokens for authentication.

#### Lab Demos
1. **Deploy Public Cloud Run Service**:
   - Use sample image (e.g., `hello` from Google).
   - Allow unauthenticated invocations.
   - Access via URL.

2. **Make Service Private**:
   - Remove `allUsers` from Cloud Run invoker role.
   - Attempt access; should fail with "forbidden".

3. **Grant Access and Test**:
   - Grant `roles/run.invoker` to a service account.
   - Impersonate and generate identity token.
   - Use Postman to send: `Authorization: Bearer <identity-token>`.
   - Verify 200 OK response.

### Code/Config Blocks
Cloud Run deployment command:
```bash
gcloud run deploy hello-public --source . --platform managed --region us-central1 --allow-unauthenticated
```

Remove public access:
```bash
gcloud run services remove-iam-policy-binding hello-private --member=allUsers --role=roles/run.invoker
```

## Custom Roles and Permissions

### Overview
Custom roles use minimal permissions (e.g., only `iam.serviceAccounts.getOpenIdToken`) for granular access control, reducing security risks compared to predefined roles.

### Key Concepts/Deep Dive
Predefined roles like Service Account Token Creator include superfluous permissions. Create custom roles with exactly needed permissions.

- `iam.serviceAccounts.getAccessToken`: For access tokens.
- `iam.serviceAccounts.getOpenIdToken`: For identity tokens.

| Permission | Purpose |
|------------|---------|
| `iam.serviceAccounts.getAccessToken` | Generate access tokens for GCP APIs |
| `iam.serviceAccounts.getOpenIdToken` | Generate identity tokens for authentication |

## Sign Blobs and JWTs

### Overview
Service Account Token Creator allows signing blobs or JWTs using managed Google keys, useful for artifact verification or signed URLs.

### Key Concepts/Deep Dive
- **Sign Blob**: Applies digital signature to arbitrary data.
- **Sign JWT**: Signs JSON Web Token for secure claims.

These use Google-managed private keys, no local key management needed.

### Code/Config Blocks
Sign a file:
```bash
gcloud iam service-accounts sign-blob --iam-account=your-sa@project.iam.gserviceaccount.com --input-file=input.txt --output-file=output.txt
```

Sign a JWT:
```bash
gcloud iam service-accounts sign-jwt --iam-account=your-sa@project.iam.gserviceaccount. com --input-file=claims.json --output-file=signed-jwt.txt
```

## Workload Identity Federated Credentials

### Overview
Workload Identity enables Kubernetes workloads to access GCP resources securely without keys, extending to external providers.

### Key Concepts/Deep Dive
This role package includes permissions for federated identity. In Kubernetes, pods assume service accounts via federation, avoiding direct key usage.

> [!NOTE]
> Covered in depth during Kubernetes sessions.

## Service Account Keys: Creation, Risks, and Management

### Overview
Service account keys are JSON/P12 files for long-term authentication, posing high security risks if compromised. Use only when necessary, and rotate/view them via the console.

### Key Concepts/Deep Dive
- **Internal Keys**: Auto-managed by Google; user-hidden.
- **External Keys**: User-downloaded; no auto-rotation.

Risks: If leaked, full resource access. Best to use service account user roles or workload identity instead.

### Code/Config Blocks
Generate a key:
```bash
gcloud iam service-accounts keys create key.json --iam-account=your-sa@project.iam.gserviceaccount.com
```

Activate key:
```bash
gcloud auth activate-service-account --key-file=key.json
```

### Tables
| Key Type | Expiry | Rotation | Visibility |
|----------|--------|----------|------------|
| Internal | Auto (2 years) | Google-managed | Console/API hidden |
| External (JSON/P12) | User-defined (max 10 years) | Manual/user-scripted | Downloadable |

## Organization Policies for Service Accounts

### Overview
Organization policies enforce security at Org/GL/AR levels, disabling risky features like key creation or cross-project access.

### Key Concepts/Deep Dive
Key policies:
- **Disable Service Account Creation**: Freezes project activity.
- **Disable Service Account Key Creation**: Prevents external key generation.
- **Disable Automatic IAM Grants for Default SA**: Removes editor role from default compute SA.
- **Domain-Restricted Sharing**: Limits SA to org domains.
- **SA Key Expiry Duration**: Sets max key lifetime (e.g., 1h to 10y, in predefined durations).

Override for exceptions with policy administrator role.

### Code/Config Blocks
Enforce key creation disable:
```yaml
constraint: constraints/iam.disableServiceAccountKeyCreation
listPolicy:
  deniedValues: ["true"]
```

## Best Practices for Service Accounts

### Overview
Minimize privileges, audit regularly, use organization policies, and avoid keys when possible.

### Key Concepts/Deep Dive
- Use least privileged roles/custom roles.
- Enable org policies to block keys or cross-project use.
- Rotate keys manually; Google doesn't auto-rotate user keys.
- Prefer impersonation, workload identity.

### Tables
| Scenario | Recommended Role | Alternative |
|----------|------------------|-------------|
| Attach SA to VM | Service Account User | Compute VM Admin default SA |
| Generate tokens | Custom with specific permissions | Service Account Token Creator |
| Authenticate to external | Workload Identity Federation | Keys (last resort) |

### Lab Demos
1. **Block Key Creation at Org Level**:
   - Set Policy: `constraints/iam.disableServiceAccountKeyCreation = true`.
   - Verify: Attempt key creation fails.

2. **Create SA with Expire-able Key**:
   - Use expiry policy (e.g., 1 hour).
   - Generator key; note expiry.

## Summary

### Key Takeaways
```diff
+ Service Account Token Creator minimizes privileges for token generation
- Avoid service account keys; use impersonation or workload identity instead
+ Organization policies enforce security at scale
- Regular audits prevent privilege escalation
+ Identity tokens enable secure external authentication
```

### Expert Insight

#### Real-world Application
Use Service Account Token Creator for CI/CD pipelines needing short-term GCP access without long-lived keys. For multi-cloud, leverage Workload Identity Federation for seamless authentication between providers.

#### Expert Path
Master IAM Simulator for role testing; automate SA creation via Terraform; integrate with Google Cloud Workflows for token management. Deepen Kubernetes integration with Workload Identity for pod-level security.

#### Common Pitfalls
Granting Service Account Token Creator without oversight leads to broad impersonation. Forgetting key rotation exposes resources; default compute SA often over-provisioned. Ignoring propagation delays causes authentication failures.

#### Lesser Known Things
Service accounts can impersonate others recursively (e.g., A -> B -> C) for chained delegation. Internal keys exist but are invisible, handling Google-managed operations. Signed URLs in GCS rely on blob signing permissions from this role. Active Directory sync integrates with SA for hybrid environments.
