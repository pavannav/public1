# Session 067: Policy Simulator in Google Cloud

- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
- [Lab Demo: Simulating Policy Changes](#lab-demo-simulating-policy-changes)
- [Summary](#summary)

## Overview

The Policy Simulator in Google Cloud Platform (GCP) is a powerful tool that allows administrators to test the potential impact of IAM (Identity and Access Management) policy changes on principal access without actually committing those changes. By analyzing access logs from the last 90 days, it helps prevent unintended access modifications that could disrupt users or systems. This session explores how the Policy Simulator works, its supported resources, and practical demonstration through IAM policy simulations involving role additions and removals.

## Key Concepts and Deep Dive

### What is Policy Simulator?

Policy Simulator is an IAM tool in GCP designed to evaluate how proposed allow policy changes will affect principal access. It provides a safe way to preview the consequences of policy modifications by simulating access attempts based on historical data.

The tool focuses on access changes rather than just permissions, ensuring administrators understand the real-world impact on users. It operates at multiple levels: organization, folder, project, or resource level, taking into account inherited policies and descendant resource policies.

### How Policy Simulator Works

The Policy Simulator leverages access logs (not permissions) from the past 90 days to determine the impact of proposed policy changes. Here's the process:

1. **Access Log Collection**: It categorizes access logs for supported resource types over the 90-day period.
   - Location depends on the resource level: organization, folder, project, or individual resource.

2. **Access Attempt Replay**: Re-evaluates the access attempts using the current allow policy, including inherited policies and policies on descendant resources.

3. **Proposed Policy Comparison**: Replays the same attempts against the proposed allow policy.

4. **Difference Analysis**: Reports the disparities between current and proposed policy outcomes as a list of access changes.

This approach ensures that changes don't inadvertently revoke access that principals currently need.

### Supported Resource Types

As of the current documentation, the Policy Simulator supports:
- **Cloud Storage**: Buckets only
- **Compute Engine**: Instances only
- **Cloud SQL**
- **Spanner**
- **Pub/Sub**: Snapshots, subscriptions, and topics
- **Resource Manager**: Folders, organizations, and projects

Not all services are fully supported, and within supported services, only specific resource types are included.

### Types of Access Changes

After simulation, Policy Simulator categorizes results into several types of access changes:

| Access Change Type | Description |
|-------------------|-------------|
| Access Revoked | Principal had access under current policy but loses it with proposed changes |
| Potentially Revoked | Principal has access under current policy, but result with proposed policy is unknown |
| Access Gained | Principal gains access with proposed policy that they didn't have before |
| Potentially Gained | Principal doesn't have access under current policy, but result with proposed policy is unknown |
| Access Unknown | Access status is unknown under both current and proposed policies, indicating proposed changes might affect the principal |

Additionally:
- **Error**: An error occurred during simulation, preventing determination of access changes.
- **Access Unchanged**: The principal's access remains the same under both policies.

### Permissions Required

To use Policy Simulator, the principal requires specific permissions:
- `cloudasset.inventory.get` (Cloud Asset Viewer)
- Simulation-related permissions such as simulation admin and simulation reviewer roles

## Lab Demo: Simulating Policy Changes

This section provides step-by-step guidance on using Policy Simulator through the GCP Console, based on practical examples involving role modifications.

### Scenario 1: Removing Permissions

1. **Navigate to IAM Console**:
   - Go to the Google Cloud Console
   - Select IAM & Admin > IAM

2. **Select a Principal**:
   - Choose a user or service account (e.g., an admin user)

3. **Modify Permissions**:
   - Click the edit button for the principal
   - Remove a role, such as the Storage Object Admin (or owner) role
   - Click "Save" to proceed with testing (do not apply yet)

   The console will show a "Summary of changes" indicating removed roles.

4. **Run Policy Simulation**:
   - Click "Test changes" to initiate the simulation
   - The system generates a report analyzing the last 90 days of access logs

5. **Review Simulation Results**:
   - **Policy Difference**: Shows roles being changed (e.g., removing owner role)
   - **Permission Changes**: Displays permissions being added or removed (e.g., 2,600+ permissions removed, some retained due to other roles)
   - **Access Changes**: Categorizes access attempts over 90 days into revoked, gained, unknown, error, or unchanged categories

   Example output:
   - 418 access attempts during the period
   - Results showing which resources (e.g., Storage, Compute Engine) would have revoked access
   - Breakdown of blocked vs. allowed access before and after changes

6. **Apply or Discard Changes**:
   - If satisfied, click "Apply proposed changes"
   - Otherwise, discard the changes

### Scenario 2: Adding Permissions

1. **Add a New Role**:
   - Select a principal (e.g., a test user)
   - Add a role, such as Compute Instance Admin
   - Click "Test changes"

2. **Review Differences**:
   - Permission changes show added permissions (e.g., `compute.instances.create`)
   - Access changes indicate gained access (e.g., 54 blocked accesses now gained)

3. **Handle Unknown Results**:
   - Unknown results occur when simulation cannot determine access due to unsupported operations
   - Retry or investigate permissions

4. **Apply Changes**:
   - Click "Apply proposed changes" to implement
   - Update takes effect immediately

### Common Simulation Issues

- **Operational Errors**: Simulation fails due to issues like unsupported resource types
- **Unknown Results**: Policy Simulator cannot replay certain access attempts
- **Unsupported Resources**: Only specific services and resource types are supported

## Summary

### Key Takeaways
```diff
+ Policy Simulator tests IAM policy changes safely using 90-day access logs
+ Focuses on access changes, not just permissions, to prevent unintended revocations
+ Supports limited resource types: Cloud Storage (buckets), Compute Engine (instances), Cloud SQL, Spanner, Pub/Sub, Resource Manager
+ Results include revoked/gained access, potentially affected areas, and unknowns/errors
- Does not support all GCP services or resource types
- Simulation requires Cloud Asset Viewer and simulation-specific permissions
- Unknown results may require manual verification or retry
```

### Quick Reference
- **Navigate to Policy Simulator**: IAM & Admin > IAM > Select Principal > Edit Permissions > Test Changes
- **Supported Levels**: Organization, Folder, Project, Resource
- **Log Window**: 90 days of access logs
- **Key Permissions**:
  ```bash
  cloudasset.inventory.get
  # Plus simulation admin/reviewer roles
  ```

### Expert Insight
**Real-world Application**: In production environments, use Policy Simulator before any IAM changes affecting multiple users or critical systems. For example, before removing broad roles like Owner, simulate to identify downstream services that might lose access unexpectedly.

**Expert Path**: Master Policy Simulator by first understanding your organization's access patterns through Cloud Audit Logs. Practice simulations in non-production projects, and integrate it into change management workflows. Combine with Policy Intelligence Center for comprehensive policy analysis.

**Common Pitfalls**: Ignoring unknown results can lead to surprises post-deployment; always investigate and test critical services manually. Forgetting inherited policies at higher levels can cause incorrect simulations. ಬಿ Recap - simulations are resource-limited, so apply a "least privilege" mindset when interpreting results.

> [!IMPORTANT]
> Always test policy changes in development environments first, and have rollback plans ready. Policy simulations provide historical insights but may not capture future access patterns.

> [!NOTE]
> As GCP evolves, check official documentation for updated supported resource types and new features beyond this session's recording.
