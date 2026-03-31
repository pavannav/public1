# Session 1: Custom Roles as a Cloud Architect

## Table of Contents
- [Introduction to Custom Roles](#introduction-to-custom-roles)
- [Role Types in GCP](#role-types-in-gcp)
- [When to Use Custom Roles](#when-to-use-custom-roles)
- [When Not to Use Custom Roles](#when-not-to-use-custom-roles)
- [Maintaining Custom Roles](#maintaining-custom-roles)
- [Demo: Checking and Adding Permissions to Custom Roles](#demo-checking-and-adding-permissions-to-custom-roles)
- [Summary](#summary)

## Introduction to Custom Roles
### Overview
Custom roles in Google Cloud Platform (GCP) represent user-defined sets of permissions that allow granular access control beyond predefined roles. This session explores when custom roles are appropriate for use in GCP, focusing on scenarios where predefined roles do not meet specific requirements. The discussion covers role types, maintenance considerations, and practical examples, providing cloud architects with guidance on implementing least-privilege security principles.

As a cloud architect, understanding custom roles is crucial for designing secure, efficient access management in GCP environments. Custom roles help reduce over-privileged access while requiring ongoing maintenance to stay current with evolving service permissions.

### Key Concepts/Deep Dive
Custom roles enable fine-tuned permission control but introduce management overhead. Key considerations include:
- User-defined permission sets not automatically updated by Google
- Need for manual maintenance when new permissions are introduced
- Essential for implementing precise access policies

## Role Types in GCP
### Overview
GCP offers three primary types of Identity and Access Management (IAM) roles to control access to resources. Understanding these types helps architects choose the most appropriate approach for their use cases.

### Key Concepts/Deep Dive
The three role types are:

- **Primitive Roles**: Broad permissions like Owner, Editor, and Viewer. These should be avoided whenever possible due to excessive privileges that violate least-privilege principles.

- **Predefined Roles**: Google-managed roles with specific permission sets (e.g., `roles/compute.admin`). These are recommended for most scenarios because:
  - Fully managed and maintained by Google
  - Automatically updated when new permissions are added to existing services
  - Comprise carefully curated permission combinations

- **Custom Roles**: User-created roles with selected permissions. These provide maximum flexibility but require manual management.

| Role Type | Managed By | Permission Updates | Recommended Use |
|-----------|------------|-------------------|-----------------|
| Primitive | Google | Automatic | Avoid - too broad |
| Predefined | Google | Automatic | Preferred for most cases |
| Custom | User | Manual | When predefined roles don't fit requirements |

## When to Use Custom Roles
### Overview
Custom roles become necessary when predefined roles contain either too many or too few permissions for specific use cases.

### Key Concepts/Deep Dive
Consider custom roles when:
- A predefined role includes unnecessary permissions that should be removed
- Need exists for a subset of permissions from multiple predefined roles
- Organizational policies require very specific permission combinations

**Example Scenario**: A predefined role has 15 permissions, but only 13 are needed. Creating a custom role allows removing the 2 unnecessary permissions while maintaining the required access.

> [!IMPORTANT]  
> Custom roles are user-defined and not maintained by Google. Users must manually update permissions when Google adds new features.

## When Not to Use Custom Roles
### Overview
Custom roles introduce maintenance overhead and should be avoided when predefined roles adequately meet requirements.

### Key Concepts/Deep Dive
Avoid custom roles when:
- Predefined roles provide sufficient permissions
- Automatic updates are preferred over manual maintenance
- Simplicity outweighs the need for granular control

Predefined roles are ideal because Google automatically incorporates new permissions as services evolve, eliminating manual intervention.

## Maintaining Custom Roles
### Overview
Since custom roles are not managed by Google, they require proactive maintenance to incorporate new permissions.

### Key Concepts/Deep Dive
Key maintenance considerations:
- Monitor [change logs](https://cloud.google.com/iam/docs/release-notes) for new permissions
- Manually add relevant permissions as Google releases updates
- Document custom role usage in design documents
- Factor in operational work for permission updates

**Change Log Strategy**: 
- Regularly review the latest change log entries
- Example: Compute Engine permissions added on November 2nd included multiple new capabilities
- Search IAM role documentation to verify permission additions

> [!NOTE]  
> The changelogs page provides continuous updates on permission additions across GCP services.

### Real-world Impact
A custom role created in July 2020 might miss over 125 permissions added by November of the same year, potentially leaving resources unprotected or inaccessible.

## Demo: Checking and Adding Permissions to Custom Roles
### Overview
This hands-on walk demonstrates how to check for missing permissions in a custom role and add them manually.

### Lab Demos
Follow these steps to update a custom role with newly available permissions:

1. **Access Change Logs**: Navigate to the [change logs page](https://cloud.google.com/iam/docs/release-notes) to identify recently added permissions.

2. **Identify Relevant Permissions**: Review new permissions for your services (e.g., Compute Engine additions on November 2nd).

3. **Verify in IAM**: Select your custom role (e.g., "custom compute admin") and check the "Permissions" tab.

4. **Search for New Permissions**:
   ```bash
   # Example permission format: service.resource.verb
   # Search for permissions like:
   # compute.instances.createNetworkEndpointGroup
   # compute.globalendpointgroups.delete
   ```

5. **Compare Counts**: Note your role's current permission count (e.g., 451 permissions).

6. **Edit the Role**: Click "Edit role" in the IAM console.

7. **Add Permissions**:
   - Click "Add permission"
   - Search for and select newly added permissions
   - Increase your permission count (e.g., from 451 to 452)

8. **Save Changes**: Click "Save" to update the role.

9. **Verify Update**: Confirm the role shows the updated creation/modification timestamp.

After these steps, the custom role includes the latest permissions and maintains compatibility with new GCP features.

## Summary

### Key Takeaways
```diff
+ Custom roles enable granular permission control in GCP IAM
+ Prefer predefined roles for automatic maintenance whenever possible
+ Primitive roles should be avoided due to overly broad permissions
- Custom roles require manual updates when Google adds new permissions
- Maintenance overhead must be factored into design documents
! Always monitor change logs to keep custom roles current
! Document operational work required for custom role management
```

### Expert Insight

#### Real-world Application
In production environments, custom roles excel for specialized access patterns like CI/CD pipelines requiring specific compute permissions without broader admin access. For example, create a "build-agent" role with only necessary VM and storage permissions for automated deployment systems. This reduces security surface area while enabling automated operations.

#### Expert Path
- Master predefined roles first - they cover 90% of typical use cases
- Maintain a permission matrix documenting custom role rationales
- Implement automated monitoring scripts to check for permission gaps
- Build expertise in GCP change logs and service release notes
- Practice role testing in separate projects before production deployment

#### Common Pitfalls
##### Common Issues with Resolutions
- **Outdated Permissions**: Custom roles become ineffective as GCP adds features
  - Resolution: Set quarterly reviews of change logs and automation scripts to detect gaps
  - Avoidance: Start with predefined roles, only customize when absolutely necessary

- **Permission Overlap**: Creating redundant custom roles across teams
  - Resolution: Centralize role management in a shared organization policy
  - Avoidance: Establish clear naming conventions and review processes

- **Maintenance Burnout**: Manual updates become overwhelming
  - Resolution: Automate permission synchronization using API scripts
  - Avoidance: Limit custom roles to critical applications only

- **Security Gaps**: Missing new permissions leads to access failures
  - Resolution: Monitor audit logs for permission-related errors
  - Avoidance: Include permission update budgets in project planning

- **Accidental Over-Provisioning**: Adding too many permissions during creation
  - Resolution: Regular access reviews and cleanup procedures
  - Avoidance: Always justify each permission with business requirements

##### Lesser Known Things
- Custom roles can have up to 3,000 permissions, but Google recommends limiting to essential ones
- Permission names follow a consistent `service.resource.verb` format (e.g., `compute.instances.list`)
- Organizations can set custom role policies at folder level to standardize across projects
- IAM role IDs are immutable once created - plan naming carefully
- Custom roles support metadata like descriptions and launch stage tracking

## Corrections Made
During transcript processing, the following spelling and grammatical errors were identified and corrected:
- "custom rules" → "custom roles" (multiple instances throughout)
- "ads" → "adds" (in reference to Google adding permissions)
- "a overhead" → "an overhead"
- "operations work" → "operational work" (in design document context) 
- "these mini good number" → "this many good number" (likely a transcription error for "this many good number of permissions")

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
