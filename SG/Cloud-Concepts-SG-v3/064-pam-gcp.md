# Session 064: PAM in GCP

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [What is Privilege Access Manager (PAM)?](#what-is-privilege-access-manager-pam)
  - [Core Components](#core-components)
  - [Grant States](#grant-states)
  - [IAM Conditions](#iam-conditions)
  - [Integration with Deny Policies](#integration-with-deny-policies)
  - [Role-Based Access Control](#role-based-access-control)
- [Lab Demos](#lab-demos)
  - [Creating Entitlements](#creating-entitlements)
  - [Requesting and Managing Grants](#requesting-and-managing-grants)
  - [Revoking Access](#revoking-access)
  - [Group-Based Entitlements](#group-based-entitlements)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview
Privilege Access Manager (PAM) is a Google Cloud service in preview that enables Just-In-Time (JIT) temporary privilege elevation for selected principals. Instead of granting permanent elevated permissions, PAM allows you to create time-bound access grants based on predefined entitlements, ensuring users get temporary access only when needed and with proper approval workflows.

## Key Concepts and Deep Dive

### What is Privilege Access Manager (PAM)?

Privileged Access Manager is designed to provide temporary, time-limited access to Google Cloud resources, reducing the risk associated with permanent privileged access.

- **Just-In-Time Access**: Instead of permanent IAM role assignments, users request temporary elevation based on predefined entitlements
- **Approval Workflows**: Optional approval processes ensure access is granted only when justified and approved by authorized personnel
- **Time-Bound Access**: All grants automatically expire after the specified duration
- **Audit Trail**: Complete logging of all grant requests, approvals, and actions taken during elevated access periods

### Core Components

#### Entitlements
An entitlement defines the temporary access rules:
- **Principals**: Users, groups, or service accounts allowed to request grants
- **Roles**: Specific IAM roles that can be granted (cannot use basic roles like Owner/Editor/Viewer)
- **Duration**: Maximum time period (1 hour to 24 hours) for granted access
- **Approval Requirements**: Whether requests need approval from specified approvers
- **Justification**: Whether requestors and approvers must provide justification

#### Grants
Individual access requests made against entitlements:
- **Request Process**: Users select role and duration from available entitlements
- **Justification**: Optional explanation of why access is needed
- **Approval**: If required, approvers review and approve/deny requests
- **Activation**: Once approved (or if auto-activation enabled), elevated privileges are granted

### Grant States

| State | Description |
|-------|-------------|
| Activating | Grant is being provisioned |
| Active | Grant is currently providing elevated privileges |
| Approval Awaited | Grant approved but pending approval |
| Denied | Grant request was denied by an approver |
| Ended | Grant completed normally (expired) |
| Expired | Grant approval window expired before approval |
| Revoked | Administrator manually removed grant |
| Revoking | Grant is in the process of being revoked |

> [!IMPORTANT]
> Grant states provide clear visibility into the access lifecycle, enabling administrators to track and audit temporary privilege elevations.

### IAM Conditions

While not demonstrated in detail, the transcript mentions IAM conditions can enhance entitlements:

```yaml
# Example IAM condition structure (conceptual)
condition:
  title: "Time-based restriction"
  expression: |
    request.time.getHours("America/Los_Angeles").int() >= 9 &&
    request.time.getHours("America/Los_Angeles").int() <= 17
```

### Integration with Deny Policies

Deny policies take precedence over PAM grants and restrict access even when a grant is active.

- **Policy Hierarchy**: Deny policies override allow policies
- **Effect on Grants**: Even with an active PAM grant, deny policies prevent specified actions
- **Testing Requirement**: Always verify deny policies don't conflict with intended PAM access

### Role-Based Access Control

PAM integrates with Google Cloud's RBAC while adding temporary access layers:

- **Role Scope**: Roles granted follow Google Cloud hierarchy (Organization > Folder > Project)
- **Escalation Prevention**: Avoid granting roles that allow users to modify their own IAM permissions
- **Least Privilege**: Grant minimum required permissions for the specific task

## Lab Demos

### Creating Entitlements

#### Step-by-Step Process:
1. **Navigate to Privileged Access Manager** in Google Cloud Console
2. **Click "Create Entitlement"**

#### Role Selection:
- Choose predefined roles (e.g., Compute Admin, Storage Admin)
- Note: Basic roles (Owner/Editor/Viewer) are not supported

```bash
# Example entitlement creation (conceptual)
gcloud privileged-access-manager entitlements create compute-admin-access \
  --project=my-project \
  --role=roles/compute.admin \
  --max-duration=1h \
  --principals=user@example.com \
  --approval-needed=false \
  --justification-needed=true
```

#### Configuration Options:
- **Principals**: Add users/groups who can request grants
- **Approval**: Toggle requirement and specify approvers
- **Justifications**: Require explanations from requestors and approvers
- **Notifications**: Configure email alerts for grant events

### Requesting and Managing Grants

#### Request Process:
1. **User navigates to PAM** in IAM & Admin section
2. **Click "Request Grant"** on available entitlement
3. **Select duration** (up to entitlement maximum)
4. **Provide justification** (if required)
5. **Submit request**

#### Approval Workflow:
1. **Approver receives notification** (if configured)
2. **Review request details** in "Approve Grants" section
3. **Add approval justification** (if required)
4. **Approve or deny** the request

#### Grant Monitoring:
- **Real-time timer** shows remaining access duration
- **Audit logs** track all actions during elevated access
- **Permission verification** through UI testing (e.g., VM create/stop permissions)

### Revoking Access

#### Manual Revocation Process:
1. **Go to PAM Grants section**
2. **Select specific grant**
3. **Click "Revoke"**
4. **Grants are immediately revoked** - access removed instantly

#### Bulk Revocation:
- **Revoke All Grants** option available at entitlement level
- **Prevents ongoing misuse** of temporary permissions

> [!NOTE]
> Entitlements cannot be deleted if open grants exist. Always revoke grants first, then delete if needed.

### Group-Based Entitlements

#### Creation Process:
1. **Create entitlement at organization level** (groups not available at project level)
2. **Add Google Group email** as principal
3. **Configure roles and duration**
4. **All group members can request grants**

#### Key Benefits:
- **Scalability**: Add/remove users by managing group membership
- **Consistency**: Same access parameters apply to all group members
- **Self-Service**: Users can request access without administrator intervention

#### Approval Considerations:
- Group members can be approvers, but individuals cannot approve their own requests
- Use separate groups for requestors and approvers when approvals are required

## Summary

### Key Takeaways

```diff
+ PAM provides time-bound Just-In-Time access elevation in Google Cloud
+ Entitlements define allowed roles, principals, and approval rules
+ Grants automatically expire, ensuring no permanent privilege creep
+ Deny policies take precedence over grant permissions
+ Use groups instead of individual users for better scalability
+ Complete audit trail maintained for all grant operations
- Avoid basic roles (Owner/Editor/Viewer) in entitlements
- Don't grant roles that allow IAM permission modification
- Never approve your own grant requests (system prevents this)
```

### Quick Reference

```bash
# Create deny policy example
gcloud iam policies create deny-storage-create \
  --project=my-project \
  --kind=denypolicies \
  --resource=projects/my-project \
  --policy-file=deny-policy.yaml
```

**Grant States Summary:**
- Activating/Active: Functional elevated access
- Approval Awaited: Pending approval
- Denied/Expired: Access not granted
- Revoked/Revoking: Access removed

**Entitlement Creation Checklist:**
- ✅ Select appropriate IAM role (not basic roles)
- ✅ Configure duration (1-24 hours)
- ✅ Specify principals (users/groups)
- ✅ Set approval requirements
- ✅ Configure justification needs
- ✅ Add stakeholder notifications

### Expert Insight

#### Real-World Application
In enterprise environments, PAM enables zero-trust security by eliminating permanent privileged accounts. Development teams receive temporary access for deployments, security auditors get limited-time reading access, and emergency response teams can quickly elevate privileges for incident handling. This approach significantly reduces the attack surface while maintaining operational flexibility.

#### Expert Path
Master PAM by understanding Google Cloud IAM hierarchy and conditional access. Implement comprehensive audit logging integration with monitoring tools like Cloud Monitoring. Create standardized entitlement templates for common access patterns. Develop approval workflows that involve security teams for high-privilege grants.

#### Common Pitfalls
- **Privilege Escalation**: Granting roles that allow users to modify IAM permissions (e.g., avoiding roles.compute.admin for sensitive resources)
- **Approval Bypass**: Configuring entitlements to bypass approvals for convenience, then failing compliance requirements
- **GroupScope Confusion**: Not understanding that group entitlements require organization-level placement
- **Deny Policy Conflicts**: Not testing deny policies against PAM grants before deployment
- **Grant Persistence**: Forgetting active grants and surprisingly finding them expired during critical work

> [!IMPORTANT]
> Always test broken glass procedures before implementing PAM in production. Validate that temporary access doesn't interfere with existing deny policies and ensure approval workflows are tested.
