# Session 71: VPC Service Controls GCP Part 1

## Table of Contents
- [Introduction to VPC Service Controls](#introduction-to-vpc-service-controls)
- [Benefits and Security Scenarios](#benefits-and-security-scenarios)
- [Dry Run Mode and Enforcement](#dry-run-mode-and-enforcement)
- [Service Perimeters Overview](#service-perimeters-overview)
- [Lab Demo: Creating Access Policy](#lab-demo-creating-access-policy)
- [Lab Demo: Creating Service Perimeter](#lab-demo-creating-service-perimeter)
- [Restricting Services](#restricting-services)
- [VPC Accessible Services](#vpc-accessible-services)
- [Configuring Dry Run Mode](#configuring-dry-run-mode)
- [Monitoring Logs](#monitoring-logs)
- [Summary](#summary)

## Introduction to VPC Service Controls

### Overview
VPC Service Controls provide an additional layer of protection for Google Cloud services, helping to prevent unauthorized access to sensitive data stored in resources like Cloud Storage or BigQuery. This feature is designed to minimize the risk of data exfiltration resulting from malicious actions or accidental exposures, offering a security mechanism independent of IAM policies.

### Key Concepts/Deep Dive
- **Purpose**: Acts as a security perimeter around your Google Cloud resources, controlling access based on defined boundaries rather than just identity-based permissions.
- **Core Components**:
  - **Service Perimeters**: These are the boundaries you create to restrict access to specific services in your projects or VPC networks.
  - **Restricts Access From**:
    - External identities (unauthorized networks).
    - Insider threats, including compromised credentials.
  - **Integration with IAM**: While IAM handles identity and permissions, VPC Service Controls enforce network-level restrictions, ensuring that even users with valid credentials cannot bypass certain access rules if they originate from outside defined perimeters.
- **Scoped Application**: Can be applied at the project level (including all resources in that project) or at the VPC network level (limiting to resources within specific networks).
- **Access Control**: Only allows traffic from trusted sources, such as on-prem networks or specific IP addresses, to prevent data exfiltration.

> [!NOTE]
> VPC Service Controls is not a replacement for IAM but complements it by adding network-based restrictions.

## Benefits and Security Scenarios

### Overview
VPC Service Controls mitigate various risks associated with data protection in Google Cloud environments, providing fine-grained control over resource access to reduce exposure to threats.

### Key Concepts/Deep Dive
- **Mitigated Risks**:
  - **Accidental or Targeted Actions**: Blocks access attempts from outside the defined perimeter, protecting against both external threats and internal misuse.
  - **Insider Threats**: Prevents malicious insiders or compromised code from exfiltrating data, even if they have legitimate access to other resources.
  - **Misconfigured IAM Policies**: Overrides IAM misconfigurations that could otherwise allow public exposure of private data.
  - **Unauthorized Networks**: Denies requests from networks using stolen credentials, ensuring access is only permitted from approved origins.
- **Benefits**:
  - **Data Exfiltration Prevention**: Reduces risks of sensitive data leakage across organizational boundaries.
  - **Monitoring and Logging**: Tracks access attempts for auditing and compliance.
  - **Enhanced Security Posture**: Provides an extra layer beyond IAM, closing gaps where identity-based controls might fail.

VPC Service Controls ensure secure data exchange by enforcing perimeter boundaries, which is crucial for organizations handling highly sensitive information.

## Dry Run Mode and Enforcement

### Overview
Service perimeters can operate in two modes: dry run (for monitoring and auditing) and enforce (for active blocking). This allows organizations to test configurations without disrupting services.

### Key Concepts/Deep Dive
- **Dry Run Mode**:
  - Requests violating the perimeter are logged but not denied.
  - Useful for previewing impacts, auditing access patterns, and refining policies before enforcement.
  - Helps in development environments to simulate production scenarios.
- **Enforce Mode (Default)**:
  - Requests that violate the perimeter are actively denied.
  - Protects Google Cloud resources by enforcing boundaries for restricted services.
  - Blocks ingress (inbound) and egress (outbound) traffic based on defined rules.
- **Use Cases**:
  - Start with dry run to monitor traffic and adjust rules, then switch to enforce once satisfied.

## Service Perimeters Overview

### Overview
A service perimeter is the fundamental construct in VPC Service Controls, defining the boundary for restricted services. It can encompass entire projects or specific VPC networks.

### Key Concepts/Deep Dive
- **Levels of Application**:
  - **Project Level**: Applies restrictions to all resources within the project (e.g., blocking access to Cloud Storage across the entire project).
  - **VPC Network Level**: Limits to resources within specified VPC networks, offering more granular control.
- **Perimeter Scope**:
  - Restricts access to outlined services from outside the perimeter.
  - Supports creating ingress rules (allowing inbound traffic) and egress rules (allowing outbound traffic).
- **Bridging Perimeters**: Allows communication between two perimeters (covered in advanced topics).

Service perimeters act as virtual fences around your Google Cloud environments, ensuring only authorized access paths.

## Lab Demo: Creating Access Policy

### Overview
Before creating service perimeters, you must establish an access policy at either the organization level or scoped to folders/projects. Organization-level policies are required for scoped policies to function.

### Lab Demos
1. **Navigate to VPC Service Controls Page**:
   - Go to your Google Cloud Console.
   - Access the VPC Service Controls section.

2. **Create Organization-Level Access Policy**:
   - Click on "Manage Policy" if no policy exists.
   - Click "Create Policy".
   - Provide a name (e.g., "MyOrgAccessPolicy").
   - Do not add projects or folders to keep it organization-wide.
   - Optionally, add principles for administrative roles.
   - Click "Create Access Policy".

> [!IMPORTANT]
> Without an organization access policy, scoped policies at folder/project levels will not function.

This step ensures a foundational policy for enforcing controls.

## Lab Demo: Creating Service Perimeter

### Overview
Service perimeters define the restricted boundaries. In the demo, a perimeter is created to protect a project by restricting specific APIs like Cloud Storage and Compute Engine.

### Lab Demos
1. **Access VPC Service Controls**:
   - In Google Cloud Console, go to VPC Service Controls.
   - Click "New Perimeter" after ensuring an access policy exists.

2. **Configure Perimeter**:
   - **Name/Title**: e.g., "SecureSecondProject".
   - **Perimeter Type**: Select "Regular Perimeter" (for basic setup; bridge perimeters are advanced).
   - **Mode**: Defaults to "Enforce" (blocks violating requests); switch to dry run for testing.
   - **Resources to Protect**: Add projects or VPC networks. For example:
     - Select "Projects" and add your target project (e.g., a project with sensitive data).
   - **Restricted Services**: Choose services to restrict. Examples:
     - Cloud Storage API
     - Compute Engine API
     - Select from supported services (179 available).

3. **Create the Perimeter**:
   - Leave other options (VPC Accessible Services, Access Levels, Ingress Policies) as default for initial setup.
   - Click "Create Perimeter".

After creation, test access: Attempts from outside the perimeter (e.g., via SSH or CLI) will be blocked, showing errors like "Request denied by VPC Service Controls".

## Restricting Services

### Overview
Within a service perimeter, specify which Google Cloud APIs to restrict, ensuring they are only accessible from within defined boundaries.

### Key Concepts/Deep Dive
- **Service Selection**:
  - Choose from supported APIs (e.g., Cloud Storage, BigQuery, Compute Engine).
  - Restrictions apply only to the selected services in the protected projects.
- **Impact**: Once restricted, services cannot be accessed from unauthorized networks, even with valid IAM permissions.

Examples of restricted access scenarios include CLI commands from external VMs failing to list resources in protected projects.

## VPC Accessible Services

### Overview
VPC Accessible Services configure how restricted services can be accessed via Private Google Access, allowing traffic from specific subnets without reaching the internet.

### Key Concepts/Deep Dive
- **Private Google Access**:
  - Enable on subnet level to access Google services using internal IPs within Google’s network.
  - By default, restricted services may be accessible via private endpoints if enabled.
- **Configuration Options**:
  - **All Services**: Allow all services via private access.
  - **No Services**: Deny private access to restricted services.
  - **Restricted Services**: Permit only listed services via private access.
  - **Custom Services**: Select specific APIs to permit.

### Lab Demos
1. **Enable Private Google Access**:
   - Go to VPC Networks > Subnets.
   - Edit the target subnet (e.g., default subnet) and enable "Private Google Access".

2. **Modify VPC Accessible Services**:
   - In the service perimeter, under VPC Accessible Services, choose:
     - "All restricted services" to allow private access to everything restricted.
     - Or select specific services.
   - Test by running commands from a VM in that subnet: Access will work if configured correctly.

Without private Google access enabled, even internal traffic may be blocked unless explicitly allowed via ingress rules.

## Configuring Dry Run Mode

### Overview
Dry run mode logs violating requests without enforcing blocks, aiding in policy refinement.

### Lab Demos
1. **Edit Perimeter for Dry Run**:
   - In the service perimeter, access the "Dry Run" tab.
   - Add or modify restrictions (e.g., add Compute Engine API to the restricted list).
   - Save changes in dry run mode.

2. **Monitor Behavior**:
   - Traffic that would be blocked is logged instead.
   - Check logs in Cloud Logging for entries with "dry-run=true" in metadata.

This mode allows safe testing without service disruption.

## Monitoring Logs

### Overview
VPC Service Controls integrate with Cloud Logging to audit access attempts, providing insights into blocked or logged traffic.

### Key Concepts/Deep Dive
- **Log Types**:
  - Audit logs show denied requests, service names, methods, and policy details.
  - Useful for verifying dry run policies and troubleshooting enforce mode issues.
- **Accessing Logs**:
  - Navigate to Cloud Logging.
  - Filter by service (e.g., VPC Service Controls logs).
  - Analyze metadata to distinguish dry run from enforce mode actions.

Logs help confirm policy effectiveness and identify necessary adjustments.

## Summary

### Key Takeaways
```
+ VPC Service Controls add network-level restrictions beyond IAM, using service perimeters to protect Google Cloud resources.
+ Essential for preventing data exfiltration from insider threats, misconfigured policies, and unauthorized access.
! Always test policies in dry run mode first to avoid disrupting services; then enforce to block violations.
- Common mistake: Skipping access policy creation, which breaks scoped perimeters.
```

### Expert Insight

#### Real-world Application
In production environments, use VPC Service Controls to isolate sensitive projects (e.g., those with PII or financial data) by restricting APIs like Cloud Storage. Combine with ingress rules to allow audited access from on-prem networks, ensuring compliance with regulations like GDPR or HIPAA. For multi-tenant scenarios, apply perimeters at the VPC network level for finer segmentation.

#### Expert Path
Deepen knowledge by mastering advanced features like ingress/egress rules, bridge perimeters for cross-project communication, and access levels for conditional policies. Certify with Google Cloud Professional Cloud Security Engineer, and practice with hands-on labs on Qwiklabs or Google Cloud Skills Boost. Experiment with different perimeter configurations in staging environments.

#### Common Pitfalls
- **Forgetting Access Policy**: Attempting scoped perimeters without an organization policy fails silently—always verify policy creation.
- **Over-Restricting Services**: Blocking essential APIs (e.g., Compute Engine) can lock out VMs, requiring egress rules for SSH.
- **Neglecting Private Google Access**: Assuming defaults match needs; explicitly disable if strict restrictions are required.
- **Misunderstanding Modes**: Running enforce mode prematurely disrupts operations—in dry run first for 24-48 hours.
- **Ignoring Logs**: Not monitoring audit logs leads to blind spots in policy effectiveness.

### Transcript Corrections Made
- "expiltration" corrected to "exfiltration" (data exfiltration).
- "parameter" referring to service boundary corrected to "perimeter" (VPC Service Controls uses service perimeters, not "parameters").
- "fans" likely meant "fence" or contextually "perimeter" boundary.
- "IM" corrected to "IAM" (Identity and Access Management).
- "VP service control" standardized to "VPC Service Controls".
- "VBP" corrected to "VPC".
- General misspellings like "Gipglinq" to "Google Cloud" inferred and corrected.
- "compute in" to "gcloud compute" for CLI commands.
- "Unique identifier" contextually to "organization policy VPC Service Controls".
- Various grammatical fixes for clarity, e.g., "mininor" to "minimize", "stolen credential" to "credentials".
