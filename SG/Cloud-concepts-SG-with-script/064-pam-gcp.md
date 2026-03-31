# Session 064: Privilege Access Manager GCP

## Table of Contents
- [Introduction](#introduction)
- [Create Entitlements](#create-entitlements)
- [Edit Entitlements](#edit-entitlements)
- [User Roles](#user-roles)
- [Grants](#grants)
- [Approval](#approval)
- [Permissions](#permissions)
- [Deny Policy](#deny-policy)
- [Revocation Policy](#revocation-policy)
- [Privilege Access Manager](#privilege-access-manager)
- [Revoke Access](#revoke-access)
- [Delete Access](#delete-access)
- [Group-Based Access](#group-based-access)
- [Real-World Application (Hands-On Demo)](#real-world-application-hands-on-demo)
- [Summary](#summary)

---

## Introduction

### Overview
Privilege Access Manager (PAM) is a Google Cloud service designed to provide just-in-time (JIT), temporary privilege elevation for selected principals. This service enables secure, on-demand access to resources without granting permanent high-level permissions, reducing the risk of unauthorized actions. PAM controls temporary access through entitlements, which define the roles, duration, and approval processes for users or groups requesting elevated privileges. As of the recording, PAM is in preview state, making it suitable for controlled environments rather than production-critical systems.

### Key Concepts/Deep Dive
PAM allows administrators to create entitlements that specify:
- **Principals Eligible for Requests**: A list of users or groups allowed to request grants against the entitlement. Only these principals can apply for temporary access.
- **Justification Requirements**: Option to require requesters to provide a reason for needing temporary access (e.g., "Need to stop a VM for maintenance").
- **Role Constraints**: Users can only request roles predefined in the entitlement. PAM prevents escalation by limiting available roles (e.g., only Compute Admin).
- **Duration Limits**: Grants can range from 1 hour to 24 hours, ensuring access is time-bound.
- **Approval Mechanisms**: Optional requirement for admin approval before granting access. Approvers may also need to justify their decision.
- **Notifications**: Emails for key events like grants or pending approvals.

Entitlements can be created at the organization, folder, or project level, following Google Cloud's resource hierarchy. For example, an organization-level entitlement grants access at folder and project levels.

Groups can be added as requesters or approvers. When a group is specified as requesters, individual group members can request access, but only the requesting user receives elevated privileges—not the entire group. Similarly for approvers, any group member can approve or deny.

❌ **Note**: Basic roles (Owner, Editor, Viewer) are not supported in PAM. Use predefined or custom roles instead.

✅ **Key Statuses for Grants**:
- Initial: Activating/Activation Failed
- Pending: Approval Awaited
- Active: Active/Expired
- Terminated: Denied/Ended/Revoked/Revoking

💡 **Permissions**: Principals requesting or approving grants do not need specific IAM roles. However, the entitlement creator requires PAM Admin role (and optionally Folder Admin or Security Admin). For viewers, a PAM Viewer role exists.

⚠ **Corrections Noted**: The transcript contains minor spelling errors such as "privil" instead of "privilege," "emenent" instead of "entitlement," "principls" instead of "principals," "Justus ation" instead of "justification," "rasing" instead of "requesting," "enertainment" instead of "entitlement," "temporar" instead of "temporary," "permis" instead of "permissions," and "rasing" instead of "requesting." These have been corrected in this guide.

---

## Create Entitlements

### Overview
Creating an entitlement establishes the framework for temporary privilege elevation. Administrators define the scope, roles, and rules through the GCP Console.

### Key Concepts/Deep Dive
To create an entitlement:
1. Navigate to the Privilege Access Manager console.
2. Click "Create Entitlement."
3. Provide details:
   - **Name**: Descriptive identifier (e.g., "Compute Admin Role").
   - **Resource**: Organization, folder, or project level.
   - **Role**: Select from predefined or custom roles (excludes basic roles).
   - **Duration**: Set maximum grant duration (1-24 hours).
   - **Conditions**: Optional IAM conditions for additional restrictions.
4. Configure requesters and justifications.
5. Enable/disable approval process.
6. Set up notifications.

| Step | Description | Example |
|------|-------------|--------|
| Resource Level | Determines inheritance scope. | Organization (affects folders/projects). |
| Role Selection | Must use predefined/custom roles. | Compute Admin (prevents basic role errors). |
| Approvals | Optional admin review. | Required for sensitive grants. |

### Lab Demos
- In the console, create an entitlement named "Compute Role" at the project level.
- Select Compute Admin role (exclude basic roles as they cause errors).
- Set duration to 1 hour.
- Add requester principals (e.g., test user email).
- Enable justification requirement.
- Optionally add approval principals (e.g., admin email).
- Configure notifications if needed.
- Click "Create."

```bash
# Commands executed during demo (not shown in transcript, but implied console actions)
gcp console: Navigate to Privilege Access Manager > Create Entitlement
```

---

## Edit Entitlements

### Overview
Entitlements can be modified after creation, though certain options like approval settings are immutable once set.

### Key Concepts/Deep Dive
Post-creation editing allows:
- Adding/removing roles.
- Adding more requesters.
- Adjusting duration or conditions.
- However, approval settings (e.g., required approvals, approver list) cannot be changed—requires creating a new entitlement.
- At least one principal must remain for requesters.

⚠ **Limitations**: Changes to approval mechanisms necessitate recreation of the entitlement.

---

## User Roles

### Overview
Ensure proper IAM setup for service agents and minimal baseline roles for requesters.

### Key Concepts/Deep Dive
- PAM service agent is auto-created with necessary roles (e.g., "Principal Privilege Access Manager Service Agent Role").
- Grant requesters minimal roles (e.g., Viewer) to view resources without escalation.
- No special permissions needed for grant requests/approvals, but creators need PAM Admin role.

---

## Grants

### Overview
Grants represent the temporary elevation instances requested by principals.

### Key Concepts/Deep Dive
- Users request grants via the PAM interface.
- Specify duration (up to entitlement max) and justification.
- Status tracks from request to activation.

---

## Approval

### Overview
Grants may require admin approval before activation.

### Key Concepts/Deep Dive
- Approvers review requests, add comments, and approve/deny.
- Self-approval is prohibited (e.g., requester cannot approve their own grant).

```bash
# Example notification flow (conceptual)
Email: "Grant requested for Compute Admin - Justification: Need to stop VM"
```

---

## Permissions

### Overview
Temporary grants enable previously restricted actions.

### Key Concepts/Deep Dive
- Post-activation, principals gain role-based access (e.g., Compute Admin allows VM creation/stop).
- Access auto-revokes after duration or manual revocation.

---

## Deny Policy

### Overview
IAM Deny Policies override PAM grants for security.

### Key Concepts/Deep Dive
- Deny policies take precedence over allow rules.
- Example: Deny storage creation overrides PAM Storage Admin grant.

### Lab Demos
- Create deny policy via gcloud:
  ```bash
  gcloud iam policies create deny-storage-create \
    --attachment-point=projects/my-project \
    --kind=denypolicy \
    --policy-file=policy.yaml
  ```
- Policy YAML example:
  ```yaml
  displayName: deny-storage-create
  rules:
  - description: Deny storage bucket create permission
    denyRule:
      deniedPermissions: ["storage.buckets.create"]
      deniedPrincipals: ["user:test@example.com"]
  ```

⚠ **Impact**: Grant temporary access is blocked if deny policy applies.

---

## Revocation Policy

### Overview
Admins can forcibly revoke active grants.

### Key Concepts/Deep Dive
- Revoke from entitlement level or individual grants.
- Immediate cessation of privileges.

---

## Privilege Access Manager

### Overview
Core service interface for managing entitlements and grants.

### Key Concepts/Deep Dive
- Admin view: Create, edit, view entitlements; approve/revoke grants; audit logs.
- User view: Request grants, view active entitlements.

---

## Revoke Access

### Overview
Manual revocation removes temporary privileges instantly.

### Key Concepts/Deep Dive
- Performed by admins for security or policy reasons.
- Applicable across all grants for an entitlement.

---

## Delete Access

### Overview
Entitlements cannot be deleted if active grants exist.

### Key Concepts/Deep Dive
- Sequence: Revoke all grants → Delete entitlement.
- Clean removal prevents orphaned access.

---

## Group-Based Access

### Overview
Groups enhance scalability and management.

### Key Concepts/Deep Dive
- Requesters/Approvers can be groups.
- Available at organization level only.
- Adding users to groups grants access without reconfiguration.
- Prevents individual user burden.

### Lab Demos
- Create entitlement at organization level.
- Use group email as requester.
- Members request independently.
- Approvers (if group) any member can approve.

> [!IMPORTANT]
> Use groups over individuals for better governance.

---

## Real-World Application (Hands-On Demo)

### Overview
The transcript demonstrates a complete PAM workflow.

### Key Concepts/Deep Dive
- Create entitlements for Compute Admin and Storage Admin.
- Request grants (with/without approval).
- Demonstrate role activation (e.g., VM stop/create bucket).
- Apply deny policy to override grants.
- Revoke grants and delete entitlements.

### Lab Demos
1. **Entitlement Creation**:
   - Console: Create "Compute Role Entitlement" → Compute Admin → 1 hour → Add requester (test user) → Enable justification and approval (admin).
   - Result: Entitlement created.

2. **Grant Request**:
   - Switch to test user (Viewer role only).
   - PAM Console: Request Grant → 1 hour → Justification: "Need to stop VM".
   - Status: Approval Awaited.

3. **Approval**:
   - Admin: PAM Console → Approve Grants → Approve with comment.
   - Test user: Access activated (59:55 remaining).

4. **Role Usage**:
   - Test user: Compute Engine → Stop/Create VMs (now available).
   - Audit Logs: Track actions.

5. **Deny Policy Override**:
   - Create deny entitlement: "Deny Policy Demo" → Storage Admin → No approval.
   - Request grant → Access activated.
   - Apply deny policy via gcloud:
     ```bash
     gcloud iam policies create deny-storage-create \
       --attachment-point=projects/my-project \
       --kind=denypolicy \
       --policy-file=deny-policy.yaml
     ```
     - Result: Create bucket button disabled despite active grant.

6. **Revocation**:
   - Admin: Revoke all grants from entitlement.
   - Test user: Access revoked immediately.

7. **Group Demo**:
   - Create group entitlement: "Group Access" → Compute Admin → Group as requester → No approval.
   - Test user: Request grant → Access granted.
   - Approver demo fails (self-approval blocked).

---

## Summary

### Key Takeaways
```diff
+ Just-in-time access via entitlements prevents permanent high privileges.
+ Roles limited to predefined/custom; basic roles excluded.
+ Approval and justification optional but recommended for security.
+ Groups preferred over individuals for scalability.
+ Deny policies override grants; always enforce security precedence.
+ Grants auto-expire or can be revoked manually.
- Avoid granting roles allowing self-escalation (e.g., IAM Editor).
! Self-approval prohibited to maintain security checks.
```

### Expert Insight
**Real-world Application**: In production, use PAM for emergency access (e.g., Incident Response teams needing Storage Admin briefly). Set strict durations (1-2 hours) and require dual approvals for critical roles. Integrate with CI/CD for automated entitlement creation.

**Expert Path**: Master PAM by exploring IAM Conditions (e.g., time/location-based restrictions). Combine with Secret Manager for sensitive operations. Study audit logs for compliance reporting and threat hunting.

**Common Pitfalls**:
- Granting overly broad roles (e.g., Owner) despite restrictions—PAM only controls defined entitlements.
- Ignoring deny policies: Test overrides in staging before production.
- Self-escalation: Monitor for users gaining permanent access via granted roles, as PAM doesn't revoke manually assigned permissions.
- Lesser known: Service agents require network access; ensure VPC configurations allow PAM operations. Grants respect organization policies—test inheritance carefully.

**Resolutions and Avoidances**:
- For revocation errors: Always revoke grants before edits/deletes to prevent stale states.
- Deny policy conflicts: Run `gcloud iam policies list` to check active policies before PAM grants.
- Activation failures: Verify service agent permissions; recreate agent if corrupted.

```yaml
# Sample Entitlement Policy (Conceptual)
entitlement:
  name: "Compute-Emergency-Access"
  resource: "projects/my-project"
  roles: ["roles/compute.admin"]
  maxDuration: "PT1H"
  requesters:
    - principals: ["group:emergency@domain.com"]
  approvalRequired: true
  notifications:
    - events: ["GRANT_PENDING", "GRANT_ACTIVATED"]
      emailRecipients: ["security@domain.com"]
```

> [!NOTE]
> PAM is in preview—monitor Google announcements for GA features.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>

<summary model="CL-KK-Terminal">Processed transcript for Session 64: Privilege Access Manager GCP, corrected typos (e.g., 'principls' to 'principals'), structured with H2 headers following transcript order, included Mermaid-free content (no flowcharts needed), tables for comparisons, code blocks in bash/yaml syntax, demos detailed, expert insights added with pitfalls/resolutions.</summary>
