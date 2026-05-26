# Session 60: IAM (Identity and Access Management) in Google Cloud

## Table of Contents
1. [Overview](#overview)
2. [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
   - [IAM Fundamentals](#iam-fundamentals)
   - [Principals (Identities)](#principals-identities)
   - [Permissions](#permissions)
   - [Roles](#roles)
   - [Allow Policies (IAM Policies)](#allow-policies-iam-policies)
   - [Policy Application and Inheritance](#policy-application-and-inheritance)
   - [Role Types in GCP](#role-types-in-gcp)
   - [Special Identifiers](#special-identifiers)
   - [Hands-on Demonstration](#hands-on-demonstration)

## Overview
This session covers Google Cloud Platform's Identity and Access Management (IAM) system, which is the fundamental security model for controlling access to GCP resources. IAM follows the principle of least privilege by defining who (identities) has what access (roles) to which resources. The session explains IAM concepts through theory and practical demonstrations showing how to grant appropriate permissions to users, groups, and domains at different levels of the GCP resource hierarchy.

## Key Concepts and Deep Dive

### IAM Fundamentals
IAM (Identity and Access Management) is GCP's authorization system that determines whether a user or service has permission to perform specific operations on resources. It works by **mapping identities to permissions through roles**, rather than assigning permissions directly to identities. This role-based access control (RBAC) approach provides granular, scalable, and maintainable access management.

```
Key IAM Components:
- Principal (Who): The identity making the request
- Role (What): Collection of permissions
- Resource (Which): GCP service/resource being accessed
```

IAM operates at four hierarchical levels in GCP: Organization → Folder → Project → Resource. Permissions flow downward through inheritance, with child resources inheriting policies from parent levels.

### Principals (Identities)
Principals are identities that can be granted access to GCP resources. Each principal must have a unique email address identifier and supports various authentication methods. GCP recognizes several principal types:

#### Google Accounts
- Primary identity type for human users
- Includes Gmail addresses and Google Workspace accounts
- Can access resources directly or through delegation

#### Service Accounts
- Designed for applications, compute workloads, and automated processes
- Enables programmatic access to GCP resources
- Can be attached to individual users but represents non-human principals
- Uses consistent naming convention: `service-account-name@project-id.iam.gserviceaccount.com`

#### Google Groups
- Collections of Google accounts and service accounts
- Managed through Google Workspace or Cloud Identity
- Permissions applied to groups automatically extend to all members
- Supports hierarchical organization through nested groups
- Common for departmental or team-based access patterns

#### Google Workspace and Cloud Identity Domains
- Enterprise-grade account management
- Supports custom domains (e.g., `user@company.com`)
- All users within a domain can be granted permissions
- Provides enhanced security features like SAML authentication

### Permissions
Permissions define what operations are allowed on specific GCP resources. They follow a structured naming convention:

```
Format: service.resource.action
Examples:
- compute.instances.create (create VM instances)
- storage.objects.list (list objects in buckets) 
- resourcemanager.projects.get (get project details)
```

Permissions are domain-specific, meaning they're defined for particular GCP services and resources. For instance, Compute Engine permissions manage virtual machine access, while Cloud Storage permissions control bucket operations.

> [!IMPORTANT]
> Permissions cannot be assigned directly to principals. Instead, they're grouped into roles which are then bound to identities. This design ensures consistent and auditable access control.

### Roles
Roles are collections of permissions that determine a principal's access level to resources. When you grant a role to a principal, they receive all permissions contained within that role. GCP provides three main role types:

#### Basic Roles
Broad, pre-designed permissions with organization-wide scope:
- **Owner**: Full access to all resources, including billing and IAM management (9,555+ permissions). Should be granted sparingly.
- **Editor**: Read/create/delete access to most GCP resources, but cannot manage billing or IAM policies.
- **Viewer**: Read-only access to GCP resources for monitoring and troubleshooting purposes.

> [!WARNING]
> Basic roles are overly permissive for production environments. Use them cautiously in development or testing scenarios only.

#### Predefined Roles
Service-specific roles tailored to GCP products:
- Fined-grained control for individual services
- Examples: `roles/compute.instanceAdmin.v1`, `roles/storage.admin`, `roles/pubsub.publisher`
- Designed by GCP to meet common access patterns
- Regularly updated as new permissions are added

#### Custom Roles
User-created roles for specialized requirements:
- Combine permissions from multiple services
- Support minimum-violation access principles
- Created when predefined roles don't meet organizational needs
- Can be defined at organization or project level
- Include lifecycle management (Alpha, Beta, GA, Disabled)

### Allow Policies (IAM Policies)
Allow policies (also called IAM policies) define which roles are bound to which principals. They're the binding mechanism that connects identities to permissions through roles.

```
Policy Structure:
- bindings[]: Array of role-principal relationships
- Each binding contains:
  - role: String identifier (e.g., "roles/compute.instanceAdmin.v1")  
  - members[]: Array of principals (e.g., ["user:alice@example.com", "group:developers@example.com"])
```

Policy example demonstrating role binding:
```json
{
  "bindings": [
    {
      "role": "roles/compute.instanceAdmin.v1",
      "members": [
        "user:alice@example.com",
        "serviceAccount:compute-service@my-project.iam.gserviceaccount.com"
      ]
    },
    {
      "role": "roles/storage.admin", 
      "members": [
        "group:developers@example.com",
        "domain:mycompany.com"
      ]
    }
  ]
}
```

The `member` field uses prefixes to identify principal types:
- `user:` - Individual Google accounts
- `serviceAccount:` - Service accounts
- `group:` - Google groups
- `domain:` - Workspace domains

### Policy Application and Inheritance
IAM policies can be applied at different points in the GCP hierarchy, with automatic inheritance by child resources. The hierarchical application order:

```
Organization Level → Folder Level → Project Level → Resource Level
```

**Inheritance Rules:**
- **Organization Policies**: Flow to all folders, projects, and resources within
- **Folder Policies**: Inherit from organization, apply to child folders and projects  
- **Project Policies**: Inherit from organization/folder, apply to all project resources
- **Resource Policies**: Inherit from parent hierarchy, apply only to specific resource

**Practical Application Examples:**
- Apply compute admin at project level → Principal can create VMs in that project only
- Apply storage admin at organization level → Principal can manage all buckets across organization
- Combine granular and inherited permissions for precise access control

### Role Types in GCP
GCP offers three distinct role categories to support different access management scenarios:

#### Basic Roles (Primitive Roles)
Three predefined roles with broad permissions:
- Suitable for small teams or development environments
- Not recommended for production due to excessive privileges
- Named: Owner, Editor, Viewer with project scope

#### Predefined Roles (Curated Roles)  
Service-specific, Google-maintained roles:
- Fine-grained permissions for GCP services
- Regularly updated with new permissions
- Prefix: `roles/service.name`
- Examples: `roles/compute.instanceAdmin.v1`, `roles/storage.objectViewer`

#### Custom Roles (User-Defined Roles)
Organized-created roles for specialized access needs:
- Combination of permissions from multiple services
- Supports least-privilege principle
- Can be scoped at organization or project level
- Allows mixing permissions from different GCP products

### Special Identifiers
GCP includes two special principal identifiers for public access scenarios:

#### allAuthenticatedUsers
- Represents any user authenticated with a Google account
- Includes Gmail and Google Workspace users
- Can access resources with appropriate permissions
- Not valid for project-level IAM policies
- Available only at specific service levels (like Cloud Storage)

#### allUsers  
- Represents anyone on the internet (authenticated or not)
- Enables truly public access to resources
- Highest security risk - use only when necessary
- Commonly used for public website hosting or open datasets

> [!IMPORTANT]  
> Special identifiers (allAuthenticatedUsers, allUsers) cannot be assigned in project-level IAM. They require service-specific permissions at the resource level, such as Cloud Storage bucket IAM or object ACLs. Avoid using allUsers due to significant security implications.

### Hands-on Demonstration
The session includes a comprehensive GCP console demonstration covering:

#### User Access Management
- Granting roles to individual Google accounts via project IAM
- Testing effective permissions across services (Compute Engine, Cloud Storage)
- Verifying role inheritance from organization to project

#### Domain-Level Permissions  
- Assigning roles to entire Google Workspace domains
- Ensuring all domain users receive unified access
- Understanding permission scoping at project level

#### Google Groups Integration
- Creating groups and adding members via GCP console
- Granting roles to groups (instead of individuals)
- Demonstrating automatic permission distribution to group members

#### Organization-Level Policies
- Applying policies at organization root for automatic inheritance
- Overriding project-level permissions (organization policies take precedence)
- Managing inherited permissions that cannot be directly removed

#### Custom Role Creation
- Building custom roles with specific permission combinations
- Adding/removing permissions during role definition
- Assigning and testing custom roles to principals

## Summary

### Key Takeaways
```diff
+ IAM enables granular access control through identity-to-role bindings rather than direct permission assignment
+ Roles group permissions and are assigned to principals (users, groups, service accounts, domains)
+ GCP hierarchy allows policy inheritance: Organization → Folder → Project → Resource
- Avoid basic roles in production; use predefined or custom roles for least privilege
- Basic roles (Owner, Editor, Viewer) provide overly broad permissions across all services
! Carefully scope permissions at appropriate hierarchy levels to prevent unnecessary access
+ Custom roles allow precise permission combinations but require ongoing maintenance
- Special identifiers (allUsers, allAuthenticatedUsers) bypass traditional IAM and increase security risk
```

### Quick Reference

**Basic Roles:**
- `roles/owner`: Full control over all GCP resources (use sparingly)
- `roles/editor`: Create/update/delete most resources, no IAM management
- `roles/viewer`: Read-only access to GCP resources

**Common Predefined Roles:**
- `roles/compute.instanceAdmin.v1`: Full Compute Engine instance management
- `roles/storage.admin`: Full Cloud Storage control
- `roles/pubsub.publisher`: Publish to Pub/Sub topics only

**Role Binding Command (gcloud):**
```bash
gcloud projects add-iam-policy-binding [PROJECT_ID] \
  --member="user:user@example.com" \
  --role="roles/compute.instanceAdmin.v1"
```

**Principal Types:**
- `user:` - Individual Google accounts
- `serviceAccount:` - Application identities
- `group:` - Google Groups collections  
- `domain:` - Workspace enterprise domains

### Expert Insight

#### Real-world Application
In enterprise environments, IAM serves as the foundation for zero-trust security models. Organizations typically:
- Centralize IAM policy management at organization level
- Use Google Groups for team-based access patterns
- Implement custom roles that align with job functions
- Combine IAM with VPC Service Controls for perimeter defense
- Automate role bindings through infrastructure-as-code

#### Expert Path
To master GCP IAM, focus on:
1. **Hierarchical Design**: Understand implication across organization, folder, project, and resource levels
2. **Least Privilege Principle**: Start with minimal permissions and add as needed
3. **Service-Specific Knowledge**: Learn permission patterns for each GCP service
4. **Automation**: Use IaC tools (Terraform, Deployment Manager) for scalable policy management
5. **Monitoring**: Implement Cloud Audit Logs to monitor privilege usage and abuse

#### Common Pitfalls
- **Over-permissive Roles**: Granting Owner role for development tasks
- **Broken Inheritance**: Assuming child policies override parent policies directly  
- **Service Account Misuse**: Using service accounts for human access instead of dedicated roles
- **Static Groups**: Not aligning Google Groups with organizational changes
- **Public Access Errors**: Using allUsers when allAuthenticatedUsers would suffice
- **Custom Role Complexity**: Creating overly complex custom roles that become maintenance burdens

> [!NOTE]
> Always test IAM policy changes in development environments before production deployment. Use tools like gcloud's `--dry-run` flag or Policy Simulator to validate permission changes before application.
