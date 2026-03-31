# Session 4: VPC Service Controls with Ingress/Egress Rules GCP Part 4

## Table of Contents
- [Overview of Ingress and Egress Rules](#overview-of-ingress-and-egress-rules)
- [Protecting Projects with Service Perimeters](#protecting-projects-with-service-perimeters)
- [Creating Ingress Policies](#creating-ingress-policies)
- [Creating Egress Policies](#creating-egress-policies)
- [Using Dry Run Mode](#using-dry-run-mode)
- [Best Practices and Warnings](#best-practices-and-warnings)
- [Summary](#summary)

## Overview of Ingress and Egress Rules

VPC Service Controls in Google Cloud provide perimeter security to control access between resources within Google Cloud and external entities. Ingress rules dictate the direction of allowed access from outside a service perimeter to resources inside the perimeter, while egress rules control outbound traffic from resources within the perimeter to external resources. This enables private and efficient data exchange within an organization while minimizing risk by constraining allowed services, methods, projects, VPC networks, and identities.

Ingress refers to access by API clients from outside the perimeter to resources inside the perimeter, such as allowing a different project to access protected resources. Egress allows traffic from resources within the perimeter to communicate with external resources, like connecting to services in another project.

Ingress rules grant access based on API requests, specifying exact services (e.g., Cloud Storage API), methods (e.g., list, get, create, delete), contexts, Google Cloud projects, VPC networks, and identities (e.g., user accounts, service accounts, workload identities, or Google Groups if available over the internet).

> [!IMPORTANT]
> Ingress and egress rules are crucial for implementing zero-trust architecture in Google Cloud, ensuring that only authorized traffic is allowed based on predefined policies.

## Protecting Projects with Service Perimeters

To implement VPC Service Controls, you first create a service perimeter to protect specific projects and services. This perimeter acts as a security boundary, restricting access to the enclosed resources unless explicitly allowed via policies.

### Key Concepts/Deep Dive
- **Service Perimeter Creation**: Define a perimeter by selecting the project to protect and the services to restrict (e.g., Cloud Storage API).
- **Impact on Access**: Once a perimeter is enforced, any external access to the protected resources is blocked, including from VMs in other projects or the console if the services are restricted.
- **Verification**: Use commands like `gcloud storage buckets list` to test access before and after perimeter creation.

### Lab Demo: Creating a Service Perimeter
1. Navigate to the VPC Service Controls page in the Google Cloud Console.
2. Click on "Create Perimeter".
3. Enter a perimeter name (e.g., "vpc-sc-perimeter").
4. Under "Add Projects", select the project to protect (e.g., second project).
5. Under "Add Services", select the service to protect (e.g., Cloud Storage API).
6. Set the access level to "In Policy" (enforce mode).
7. Click "Create".

After creation, verify by running:
```bash
gcloud storage buckets list
```
Expected behavior: Buckets in the protected project should still be accessible from within the project, but external access (e.g., from another project's VM or console) will be blocked with an error like "Server cannot fulfill my request" or "VPC Service Control denied access".

## Creating Ingress Policies

Ingress policies allow controlled access from outside the perimeter to resources inside. You can specify identities (e.g., any identity over the internet, user accounts, service accounts), sources (e.g., all sources, specific projects, VPC networks, or access levels), and restrict to specific methods.

### Key Concepts/Deep Dive
- **Identity Types**:
  - **Any Identity**: Allows anyone over the internet, including user accounts and service accounts.
  - **User Accounts**: Restricts to human users, blocking service accounts.
  - **Service Accounts**: Allows only machine identities.
  - **Access Levels**: Use predefined conditions for fine-grained control.
- **Source Restrictions**:
  - All sources
  - Specific projects
  - Specific VPC networks
  - Custom access levels
- **Target Scope**: All projects or selected projects within the perimeter.
- **Service and Method Selection**: Choose which services (e.g., Cloud Storage API) and methods (e.g., list, get, create, delete) to allow.

### Tables: Method Options for Cloud Storage API

| Method Category | Example Methods |
|-----------------|-----------------|
| Read Operations | List Buckets, Get Bucket |
| Write Operations | Create Bucket, Delete Bucket |
| Object Operations | Download, Upload, Delete Objects |

### Lab Demo: Adding an Ingress Policy
1. Edit the created perimeter.
2. Navigate to "Ingress Rules" and click "Add Rule".
3. Select Identity: Any Identity.
4. Source: Select a project (e.g., first project where the accessing VM is located).
5. Select the project from the dropdown and add it.
6. Choose Services: Cloud Storage API.
7. Methods: All Methods (or specify selected ones).
8. Save the ingress policy.

Test by running `gcloud storage buckets list` from the specified source project. Access should be granted. Refresh the console for the protected project to verify access.

> [!NOTE]
> If an ingress policy doesn't include the current source (e.g., internet access), console access may be blocked until adjusted.

## Creating Egress Policies

Egress policies control outbound traffic from within the perimeter to external resources, such as other GCP projects or even external services like AWS S3.

### Key Concepts/Deep Dive
- **Identity Types**: Select identities sending the traffic (e.g., any identity, user accounts, service accounts).
- **Destination**: Specify external resources or GCP services/projects.
  - For GCP: Select target projects.
  - For External: Define URIs (e.g., s3://bucket-name for AWS S3).
- **Permissions**: Ensure external resources (e.g., S3 buckets) have proper IAM roles or policies configured before enabling egress.

### Lab Demo: Adding an Egress Policy
1. Edit the perimeter and navigate to "Egress Rules".
2. Click "Add Rule".
3. Select Identity: Any Identity.
4. Destination: Add a GCP project (e.g., first project).
5. Select the target project and confirm.
6. Choose Services: Cloud Storage API.
7. Methods: All Methods.
8. Save the egress policy.

Test by running `gcloud storage buckets list` targeted at the external project from within the protected VM. You should now be able to access the external buckets. For file operations like copying:
```bash
gsutil cp gs://source-bucket/object gs://destination-bucket/
```
Ensure the URI is correct and access is granted.

## Using Dry Run Mode

Dry run mode logs all access attempts without enforcing blocks, allowing you to validate policies before production deployment.

### Key Concepts/Deep Dive
- **Activation**: Switch the perimeter to dry run mode to monitor traffic.
- **Audit Logs**: Review logs to see which requests would be denied in enforce mode.
- **Testing**: Simulate scenarios and check for unintended blocks.

### Lab Demo: Enabling Dry Run Mode
1. Edit the perimeter configuration.
2. Toggle to dry run mode.
3. Navigate to "Audit Logs" in the VPC Service Controls page to review requests.
4. After validation, switch back to enforce mode.

## Best Practices and Warnings

⚠️ **Critical Warning**: VPC Service Controls can disable all access to protected resources if misconfigured, including console access. Always use dry run mode first and conduct interviews with stakeholders to understand requirements.

- Test all policies in dry run mode before enforcing.
- Start with broader rules and narrow down as needed.
- Monitor audit logs regularly for unexpected denials.
- Ensure external resources have necessary permissions before configuring egress.

## Summary

### Key Takeaways
```diff
+ Ingress rules allow inbound access from outside the perimeter based on identities, sources, services, and methods.
! Egress rules enable outbound traffic to external resources or GCP projects, requiring proper permissions on targets.
- Without policies, creating a perimeter blocks all external access, potentially causing service outages.
+ Dry run mode is essential for testing configurations without enforcement.
! Always validate IAM roles for external resources (e.g., S3) before enabling egress.
```

### Expert Insight

#### Real-World Application
In production environments, use ingress and egress rules to implement data residency controls, ensuring sensitive data (e.g., in Cloud Storage) is only accessible by authorized teams or regions. For multi-project organizations, egress rules facilitate secure cross-project integrations like data pipelines between BigQuery datasets.

#### Expert Path
To master VPC Service Controls, practice with complex scenarios involving access levels tied to device contexts (e.g., IP ranges) and workload identities. Study audit logs deeply to understand traffic patterns, and integrate with Identity-Aware Proxy (IAP) for additional authentication layers.

#### Common Pitfalls
- Misconfiguring egress to external services without verifying IAM roles, leading to failed connections.
- Overly restrictive ingress policies blocking legitimate console access from administrators.
- Assuming dry run mode logs all requests—some subtle denials may not be captured.
- Common Issues and Resolutions:
  - Issue: Requests fail with "VPC Service Control denied access". Resolution: Check ingress/egress policies and ensure the source/identity matches. Avoid: Broadly permissive policies without access levels.
  - Issue: Console inaccessible after perimeter creation. Resolution: Add ingress rules allowing user accounts from trusted sources. Avoid: Forgetting to include admin access in early configurations.
- Lesser-Known Things: VPC Service Controls can integrate with Access Groups (in preview) for Google Groups-based identities, and they support custom methods beyond standard APIs for fine-tuned control. Additionally, network tags aren't directly supported; use access levels instead.

### Corrections Made
- "Andress" corrected to "Ingress" throughout.
- "ESS" corrected to "Egress".
- "agress" corrected to "egress".
- "htp" (assuming from context but not present here) – none found in this transcript.
- "cubectl" (assuming from context but not present here) – none found in this transcript.
- Other minor typos like "ridges" to "bridges", "parameter" to "perimeter" where appropriate, "restration" to "registration", but ensured contextual accuracy. No additional notifications needed as all were self-evident corrections.
