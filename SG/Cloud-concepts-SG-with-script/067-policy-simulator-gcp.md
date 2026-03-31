# Session 067: Policy Simulator GCP

## Table of Contents
- [Policy Simulator Overview](#policy-simulator-overview)
- [How Policy Simulator Works](#how-policy-simulator-works)
- [Types of Access Changes](#types-of-access-changes)
- [Supported Resources](#supported-resources)
- [Using Policy Simulator in the Console](#using-policy-simulator-in-the-console)
- [Summary](#summary)

## Policy Simulator Overview

### Overview
The Policy Simulator is a tool in Google Cloud that helps preview the impact of changes to Identity and Access Management (IAM) allow policies. It enables administrators to test policy modifications safely before implementation, ensuring that changes do not inadvertently revoke or grant access in unintended ways. This tool is particularly useful for organizations managing complex access controls across projects, folders, and resources.

The primary purpose is to simulate the effects of policy changes on principals (users, service accounts, or groups) using historical access logs, thereby preventing potential disruptions to user access.

### Key Concepts/Deep Dive
- **Prevention of Unintended Changes**: By simulating changes, administrators can avoid scenarios where a user loses necessary access or gains unauthorized permissions.
- **Dependency on Access Logs**: The simulator relies on the last 90 days of access logs to assess impacts. This ensures realistic simulations based on real user behavior.
- **Scope of Simulation**: It evaluates changes at different levels (organization, folder, project, or resource level) and considers inherited policies and descendant resource policies.

## How Policy Simulator Works

### Overview
Policy Simulator analyzes access attempts from the past 90 days and re-evaluates them against both the current and proposed allow policies. It compares results to identify differences, reporting changes in access for principals.

### Key Concepts/Deep Dive
- **Data Source**: Characterized access logs for supported resource types over the previous 90 days. The collection point depends on the policy's level (e.g., organization-level policies collect organization-wide logs).
- **Re-Evaluation Process**:
  1. It re-evaluates access attempts using the current allow policy, including inherited policies and those on descendant resources.
  2. It replays the same attempts against the proposed allow policy.
  3. Results from both evaluations are compared, highlighting differences.
- **Focus on Permissions vs. Access**: The tool does not directly compare permissions but focuses on actual access outcomes from logged attempts. This provides a practical view of real-world impacts.

## Types of Access Changes

### Overview
Policy Simulator categorizes access changes to help administrators understand the consequences of policy modifications.

### Key Concepts/Deep Dive
The simulator reports the following access change types:

- **Access Revoked**: The principal has access under the current allow policy but will not under the proposed policy.
- **Access Potentially Revoked**: The principal has access under the current policy, but the outcome under the proposed policy is unknown (risk of loss).
- **Access Gained**: The principal lacks access under the current policy but gains it under the proposed policy.
- **Access Potentially Gained**: The principal lacks explicit access under the current policy (or it's unknown), but access under the proposed policy is unknown.
- **Access Unknown**: The outcome is unknown for both policies, as the simulator could not determine the result.
- **Error**: An error occurred during simulation, requiring resolution for accurate results.

| Access Change Type | Description | Impact Level |
|--------------------|-------------|--------------|
| Revoked | Confirmed loss of access | High risk |
| Potentially Revoked | Possible loss of access | Medium risk |
| Gained | New access granted | Low risk (if intended) |
| Potentially Gained | Possible new access | Medium risk |
| Unknown | Undetermined outcome | Investigate further |
| Error | Simulation failure | Requires fixing |

## Supported Resources

### Overview
Policy Simulator supports a limited set of Google Cloud resources, with varying levels of feature support for each.

### Key Concepts/Deep Dive
As of the time of this video, the supported resources include:
- **Cloud Storage**: Only bucket-level access.
- **Cloud SQL**: Snapshots.
- **Spanner**: Subscriptions.
- **Pub/Sub**: Topics.
- **Resource Manager**: Folders, organizations, and projects.
- **Compute Engine**: All instances.

Note that not all functions within these resources are supported. Unsupported resource types result in "Unknown" or error outcomes in simulations.

## Using Policy Simulator in the Console

### Overview
This section provides a hands-on guide to using Policy Simulator via the Google Cloud Console, including steps for testing policy changes on principals.

### Lab Demos
#### Demo 1: Simulating Permission Removal
1. Navigate to the IAM & Admin section in the Google Cloud Console.
2. Select a user (e.g., an admin user) by clicking on their entry.
3. Click the "Edit" button next to their roles.
4. Remove a role, such as the "Owner" permission from a Storage role.
5. In the summary of changes, click "Test Changes" to initiate the simulation.
6. Review the generated report:
   - **Policy Difference**: Shows roles being removed or added (e.g., "User had Owner role, now does not").
   - **Permission Changes**: Lists permissions affected (e.g., 826 permissions removed for Storage Owner).
   - **View Permission Difference**: Displays a detailed list of permissions being deleted or retained due to other roles (e.g., some permissions persist via Storage Admin role).
   - **Simulation Results**: Shows access changes over 90 days, categorized as revoked, unknown, unchanged, or errors.
     - Example: 9 permissions revoked, 800 unknown/error, 397 unchanged.
   - Click on specific entries (e.g., Storage, Compute Engine) to see why access changes (e.g., "Default to 'Denied' after proposed policy").
   - Review historical attempts (e.g., 418 attempts between April 19 and June 29) and hypothetical outcomes if changes occurred 90 days ago.
   - Note unsupported resource types (e.g., Access Approval) listed under "Unsupported Resource Type."
7. If satisfied, click "Apply Proposed Changes" to commit the modification.

#### Demo 2: Simulating Permission Addition
1. Select a test user in IAM & Admin.
2. Assign a new role (e.g., Compute Engine Instance Admin).
3. Click "Test Changes" to run the simulation.
4. Review the report:
   - No permissions removed, but additions shown (e.g., permissions for creating, setting, computing addresses).
   - Existing permissions (e.g., from Viewer role) are not duplicated in green highlights.
5. Simulation Results: Shows gained access (e.g., 54 blocked accesses now allowed), unknowns, and unchanged accesses.
   - Example: Access gained for VM creation; unknowns indicate simulation limitations.
6. Apply changes if desired.

#### Demo 3: Reversing Changes
1. Revert the added role in the IAM settings.
2. Run "Test Changes" again.
3. Observe permissions being removed and access changes (e.g., previously gained access now revoked).

### Requirements
To use Policy Simulator, ensure you have necessary roles:
- Cloud Asset Viewer
- Simulation Admin
- Simulation Reviewer

## Summary

### Key Takeaways
```diff
+ Policy Simulator previews IAM policy changes using 90 days of access logs.
+ It categorizes access changes: revoked, gained, unknown, or error.
+ Supported resources are limited: Cloud Storage (buckets), Compute Engine (instances), etc.
+ Use the console for easy testing before applying real changes.
- Avoid unexpected access revocation by reviewing simulation results carefully.
! Always check for unsupported resources to avoid incomplete assessments.
```

### Expert Insight

#### Real-World Application
In production environments, use Policy Simulator before bulk role changes in large organizations. For example, revoking permissions from hundreds of users can be tested to ensure critical services remain accessible. Integrate it into CI/CD pipelines for automated policy reviews.

#### Expert Path
To master Policy Simulator, practice with various resource types and scenario overloads (e.g., inherited policies). Study access logs via Cloud Logging to understand dependencies, and combine with tools like Policy Analyzer for deeper insights.

#### Common Pitfalls
- Relying on simulations for unsupported resources can lead to blind spots; always verify manually.
- Ignoring "Unknown" results—investigate permissions like Cloud Asset Viewer role for better accuracy.
- Overlooking inherited policies may cause valid access to appear revoked.

Common issues include:
- **Simulation Errors**: Often due to unsupported resource types; resolve by focusing on supported resources only.
  - Avoid by checking resource compatibility before simulation.
- **Unknown Results**: Caused by incomplete access log data or unsupported permissions; resolution involves adding required roles.
  - How to avoid: Ensure the simulator account has full access logs and supported permissions; rerun simulations after fixing errors.
- **Operational Errors**: Issues like replay failures; these indicate data issues.
  - Lesser Known: Simulator doesn't capture all API calls (e.g., internal GCP requests), so results aren't 100% comprehensive. Always supplement with manual testing.

---

<!-- Corrections made in transcript: principle -> principal, exess -> access, terized -> characterized, alloww -> allow, proknow -> unknown, roked -> revoked, xis -> access, gain -> gained, voced -> revoked, wate -> wait, stimultion -> stimulation, pops -> Pub/Sub, pup -> Pub/Sub, Hob -> Hub, um -> empty filler words removed, summary of changes removed owner and rules at it not available -> summary of changes: removed Owner role (corrected "at it"). Other minor fixes for clarity and grammar. -->
