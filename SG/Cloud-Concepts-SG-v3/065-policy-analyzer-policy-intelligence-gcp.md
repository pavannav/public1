# Session 65: Policy Analyzer & Policy Intelligence in GCP

<details open>
<summary><b>Policy Analyzer Policy Intelligence GCP (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
  - [Policy Intelligence](#policy-intelligence)
  - [Policy Analyzer](#policy-analyzer)
  - [Limitations of Policy Analyzer](#limitations-of-policy-analyzer)
  - [Organization Policies Analysis](#organization-policies-analysis)
  - [Service Account Usage Analysis](#service-account-usage-analysis)
- [Lab Demos](#lab-demos)
  - [Creating a Custom Policy Analyzer Query](#creating-a-custom-policy-analyzer-query)
  - [Analyzing Organization Policies](#analyzing-organization-policies)
  - [Service Account Key Usage Check](#service-account-key-usage-check)
- [Summary Section](#summary-section)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview
This session introduces Policy Intelligence in Google Cloud Platform (GCP), focusing on tools to understand, manage, and improve IAM policies for better security and configuration. The primary tool discussed is Policy Analyzer, which helps analyze who has what access to Google Cloud resources. Key areas covered include analyzing access for principals (users, groups, service accounts), troubleshooting access issues, preventing misconfigurations, and using organization policies effectively. The session includes live console demonstrations showing how to create queries at different scopes (organization, folder, project) and interpret results for security auditing.

## Key Concepts/Deep Dive

### Policy Intelligence
Policy Intelligence is a suite of GCP tools designed to help organizations understand and optimize their Identity and Access Management (IAM) policies. It enables security teams to:

- **Analyze Access Patterns**: Determine which principals have access to specific resources and through which roles.
- **Audit Organization Policies**: Review how organizational constraints affect resource security across projects and folders.
- **Troubleshoot Access Issues**: Identify why users might be blocked by deny policies or other restrictions.
- **Monitor Service Account Usage**: Track when service accounts and their keys were last used for better key lifecycle management.
- **Prevent Misconfigurations**: Test policy changes before deployment to avoid unintended access grants.

The term "Policy Intelligence" encompasses multiple specialized tools within the Security Command Center (formerly Security Center), with Policy Analyzer being the core IAM analysis tool.

### Policy Analyzer
Policy Analyzer is a GCP tool that provides insights into IAM policy configurations and access rights. It works by analyzing allow policies (not deny policies) to answer questions like:

- "Who can access this specific service account?"
- "What roles and permissions does this group have?"
- "Which VM instances can be deleted in a project?"
- "Who can access Cloud Storage buckets after 7 PM?"

#### How Policy Analyzer Works
Policy Analyzer operates through query-based analysis:

1. **Scope Definition**: Define the analysis level (organization, folder, or project).
2. **Query Parameters**:
   - **Principal**: Users, groups, service accounts, or domains to check.
   - **Permissions/Roles**: Specific IAM permissions or predefined roles to evaluate.
   - **Resources**: Target Google Cloud resources for access analysis.
   - **API Condition Context**: Optional time-based or other contextual conditions.
3. **Result Interpretation**: Returns roles, permissions, and resource bindings.

#### Supported Access Control Types
Policy Analyzer exclusively analyzes IAM allow policies. It does NOT support:

- IAM deny policies (which can override allow policies)
- Kubernetes RBAC (role-based access control in GKE clusters)
- Cloud Storage ACLs (object-level access)
- Public Access Prevention configurations

> **Important Alert**
> Policy Analyzer results may show that a principal has access through allow policies, but deny policies could still block that access. Always cross-reference with deny policy analysis for complete security assessments.

### Limitations of Policy Analyzer
Several important limitations must be considered:

| Limitation | Impact | Workaround |
|------------|--------|------------|
| No Deny Policy Analysis | Cannot detect explicit access denials | Manually review deny policies using `gcloud iam policies` |
| No Cloud Storage ACLs | Cannot analyze granular object access | Use gsutil or Cloud Console for bucket/object ACLs |
| No Kubernetes RBAC | Cannot troubleshoot GKE cluster access | Use `kubectl auth can-i` for cluster-level checks |
| No Public Access Prevention | Cannot verify bucket privacy | Use Cloud Console or gsutil for visibility checks |
| Free Tier Limits | Restricted to 20 queries/day | Upgrade to Security Command Center Premium |

> [!NOTE]
> Policy Analyzer provides a snapshot view of permissions at query execution time. Access may change dynamically with new policy bindings or conditional grants.

### Organization Policies Analysis
Organization Policies in GCP enforce constraints across an organization, folders, and projects. Policy Analyzer can audit these policies to show:

- **Constraint Inheritance**: How policies are inherited from parent levels.
- **Project/Folder Overrides**: Where constraints are enforced or exempted.
- **Affected Resources**: Which resources are impacted by specific constraints.

Common organization policy queries include:
- Which projects have disabled service account key creation?
- Which VMs are allowed external IP addresses?
- Which resources are affected by domain restrictions?

### Service Account Usage Analysis
Service accounts are GCP's equivalent to service users for automated processes. Policy Analyzer helps audit:

- **Last Usage Tracking**: When a service account was last authenticated.
- **Key Usage Monitoring**: When service account keys were last used.
- **Role Bindings**: Current IAM roles assigned to the service account.
- **Accessible Resources**: Resources the service account can access via audit logs.

This analysis is crucial for:
- Implementing least privilege access
- Detecting unused service accounts for cleanup
- Monitoring key rotation compliance

## Lab Demos

### Creating a Custom Policy Analyzer Query
This demo shows querying access permissions at project level using the Google Cloud Console.

#### Steps:
1. Navigate to Security > Policy Analyzer in the GCP Console.
2. Click "Create custom query".
3. Set scope: Select project level (e.g., "My First Project").
4. Specify principal: Enter your user email or service account ID.
5. Add permissions: Check "storage.buckets.create" permission.
6. Click "Analyze" to run the query.

#### Expected Results:
```
Roles providing storage.buckets.create permission:
- roles/storage.admin (direct role assignment)
- roles/owner (inherited through owner role)
```

#### Advanced Options:
- Enable "List resources within resources" to see specific buckets
- Enable "List individual users in groups" for group membership details
- Enable "List permissions inside roles" to break down custom roles

#### Export Results (Optional):
```
# Create BigQuery dataset and table names
# Note: Export requires billing enabled
bq mk --dataset policy_analyzer_exports
bq mk --table policy_analyzer_exports.user_permissions schema.json
```

### Analyzing Organization Policies
Demonstrates auditing organization policy constraints using pre-built query templates.

#### Steps:
1. In Policy Analyzer, click "Create query" under Organization Policies section.
2. Select template: "Which projects have disabled service account key creation?"
3. Set scope: Organization level.
4. Click "Run query" (note: Visualize requires Premium tier).

#### Expected Output:
```
Constraint: constraints/iam.disableServiceAccountKeyCreation
- Organization: ENFORCED (custom)
- Folder: ENFORCED (inherited)
- Projects: 
  - Project1: ENFORCED (inherited)
  - Project2: ENFORCED (inherited)
```

#### Querying VM External IP Constraints:
- Select "Which VMs are allowed external IP addresses?"
- Review results showing instances without restriction.

### Service Account Key Usage Check
Analyzes service account access patterns and key usage timelines.

#### Steps:
1. Click "Create query" under "Analyze service accounts".
2. Set scope: Select project containing the service account.
3. Select service account: Choose default compute service account.
4. Check "View permissions audit logs" and "Find resources".
5. Run query to see recent usage and accessible resources.
6. For key usage: Add service account key ID if available.

> [!IMPORTANT]
> Service account analysis scope is limited to project level, as service accounts are project resources.

## Summary Section

### Key Takeaways
```diff
+ Policy Intelligence enables comprehensive IAM policy analysis and improvement across GCP organizations
+ Policy Analyzer exclusively examines allow policies but cannot detect deny policy overrides
+ Organization policy auditing reveals inheritance patterns and compliance across resource hierarchies
+ Service account usage analysis is crucial for least privilege implementations and security hygiene
+ Free tier limitations (20 queries/day) restrict extensive security assessments without premium upgrades
- Deny policies, ACLs, and Kubernetes RBAC require separate tools and manual analysis
- Query results represent snapshots and may not reflect real-time policy changes
- Complex conditional policies may produce incomplete analysis results
```

### Quick Reference

#### Policy Analyzer Query Basics
```bash
# Basic structure for policy analysis queries
scope: organizations/{org-id} | folders/{folder-id} | projects/{project-id}
principal: user:{email} | group:{email} | serviceAccount:{email} | domain:{domain}
permissions: iam.serviceAccounts.impersonate
resources: projects/{project-id}/serviceAccounts/{sa-id}
```

#### Common Query Templates
- **User Access Audit**: Check all roles for a specific user
- **Service Account Impact**: Who can impersonate this service account?
- **Permission Enumeration**: All users who can create VMs
- **Organization Constraint**: Which projects allow external IP assignments

#### Organization Policy Commands
```bash
# List organization constraints using gcloud
gcloud org-policies list --project={project-id}

# Describe specific constraint details
gcloud org-policies describe constraints/iam.disableServiceAccountKeyCreation --project={project-id}
```

#### Service Account Key Rotation
```bash
# Create new service account key (follows least privilege)
gcloud iam service-accounts keys create key.json \
  --iam-account=my-service-account@my-project.iam.gserviceaccount.com

# Rotate key (delete old, use new)
gcloud iam service-accounts keys delete {old-key-id} \
  --iam-account=my-service-account@my-project.iam.gserviceaccount.com
```

### Expert Insight

#### Real-world Application
- **Access Reviews**: Use Policy Analyzer quarterly for compliancerelated access certifications
- **Incident Response**: Quickly identify which principals can access compromised resources
- **Zero Trust Implementation**: Analyze service accounts before workloaddrift detection
- **Compliance Audits**: Generate evidence of least privilege observance for auditors

#### Expert Path
- **Advanced Querying**: Master complex queries with conditional contexts and custom roles
- **Integration with Other Tools**: Combine Policy Analyzer with Cloud Asset Inventory and Security Command Center
- **Automated Audits**: Create scheduled queries using Cloud Scheduler and Pub/Sub for continuous monitoring
- **Custom Dashboards**: Export results to BigQuery for custom security dashboards

#### Common Pitfalls
- **Assuming Complete Analysis**: Remember that Policy Analyzer only shows allow policies—always check deny policies separately
- **Ignoring Scope Limitations**: Organization-level queries provide enterprise overview but miss project-level nuances
- **Over-reliance on Templates**: Use pre-built queries as starting points but customize for your security requirements
- **Not Monitoring Usage**: Setting up service accounts without usage tracking leads to credential sprawl
- **Premium Feature Confusion**: Understand free tier limits to avoid blocked security assessments

</details>
