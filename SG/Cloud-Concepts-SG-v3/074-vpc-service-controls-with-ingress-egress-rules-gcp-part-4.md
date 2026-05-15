# Session 74: VPC Service Controls with Ingress/Egress Rules - GCP Part 4

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [Understanding Ingress and Egress Rules](#understanding-ingress-and-egress-rules)
  - [Ingress Rules Configuration](#ingress-rules-configuration)
    - [Identity Selection](#identity-selection)
    - [Source Configuration](#source-configuration)
    - [Target Configuration](#target-configuration)
    - [Service and Method Selection](#service-and-method-selection)
  - [Egress Rules Configuration](#egress-rules-configuration)
  - [Security Considerations](#security-considerations)
- [Lab Demo: Implementing Ingress and Egress Policies](#lab-demo-implementing-ingress-and-egress-policies)
  - [Creating a Perimeter](#creating-a-perimeter)
  - [Testing Access Blockage](#testing-access-blockage)
  - [Configuring Ingress Policies](#configuring-ingress-policies)
  - [Configuring Egress Policies](#configuring-egress-policies)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## Overview
This session explores VPC Service Controls (VPC-SC) ingress and egress rules in Google Cloud Platform (GCP). It demonstrates how to use these rules to control the direction of access between resources inside and outside service perimeters, enabling secure data sharing while minimizing risk. The session covers creating service perimeters, implementing ingress policies for external access, and egress policies for outbound connections.

## Key Concepts and Deep Dive

### Understanding Ingress and Egress Rules
Ingress and egress rules define the allowed direction of API calls in VPC Service Controls:

- **Ingress Rules**: Control incoming access to protected resources from outside a service perimeter
  - Refers to any API calls from clients outside the perimeter to resources within the perimeter
  - Useful for allowing controlled access to protected services from authorized external sources

- **Egress Rules**: Control outgoing access from protected resources to services outside the perimeter
  - Allow resources within a perimeter to access external services and resources
  - Support access to Google Cloud services and external resources (like AWS S3)

Both rule types help exchange data privately and efficiently across the organization using Google Cloud Private APIs.

### Ingress Rules Configuration

#### Identity Selection
Choose the type of identity allowed access:

- **Any Identity**: Any user, service account, or group (even over internet)
- **Any User Account**: Human users only (requires authentication through a user session)
- **Any Service Account**: Machine identities only
- **Selected Identities**: Specific users, groups, or service accounts

#### Source Configuration
Define where the traffic originates from:

- **All Sources**: No restrictions on origin
- **Access Level**: Use pre-defined access levels (from previous session)
- **GCP Project**: Specific GCP projects
- **VPC Network**: Specific VPC networks

```nginx
# Example access level configuration (if using Terracotta for VPC access control)
# Configuration syntax would depend on access level definition
```

#### Target Configuration
Specify which protected resources can be accessed:

- **All Projects**: All projects in the perimeter
- **Selected Projects**: Specific project IDs

#### Service and Method Selection
Control which services and operations are permitted:

- **All Services**: Broad access if configured at perimeter level
- **Selected Services**: Specific Google Cloud APIs (e.g., `storage.googleapis.com`)

For methods, choose:
- **All Methods**: All operations on the service
- **Selected Methods**: Granular control over operations like:
  - `get`
  - `list`
  - `create`
  - `delete`

```yaml
# Example ingress rule configuration YAML structure
ingress_rules:
  - identity: ANY_IDENTITY
    source:
      type: ACCESS_LEVEL
      access_level: ALLOWED_VPC_ACCESS
    target:
      projects:
        - protected-project-12345
    services:
      - storage.googleapis.com
    methods:
      - get
      - list
```

### Egress Rules Configuration
Similar to ingress but defines outbound access rules:

- **Identity**: Type of identity requesting outbound access
- **To**: Supports two attribute types:
  - **GCP Services**: Access within Google Cloud
  - **External Resources**: Access to services outside GCP (S3, etc.)

For GCP services:
- **Project Selection**: Target project ID
- **Service Selection**: Specific API (e.g., `storage.googleapis.com`)
- **Method Selection**: All or selected operations

### Security Considerations
VPC-SC rules help minimize risk by constraining access patterns:

- **Granular Control**: Specify exact services, methods, and identities
- **Data Sharing**: Enable controlled sharing across projects and organizations
- **Prevention of Data Exfiltration**: Egress rules prevent unauthorized outbound connections

## Lab Demo: Implementing Ingress and Egress Policies

### Creating a Perimeter
1. Access VPC Service Controls in GCP Console
2. Create new service perimeter
3. Add protected project(s) (e.g., second project)
4. Select restricted services (e.g., Cloud Storage API)
5. Set enforcement mode (or dry-run for testing)

This secures the resources by blocking external access.

### Testing Access Blockage
Before implementing policies, verify access is properly blocked:

```bash
# Attempt to list buckets from outside the perimeter
gcloud storage buckets list

# Expected error: "VPC Service Controls" identifier
# Access denied due to perimeter restrictions
```

### Configuring Ingress Policies
1. In the perimeter configuration, add an ingress rule:

   - **Identity**: Choose based on requirements:
     - `ANY_IDENTITY` for broad access
     - `ANY_USER_ACCOUNT` for human users only
     - `ANY_SERVICE_ACCOUNT` for machine identities
   
   - **Source**: Select origin restrictions:
     - All sources (no restrictions)
     - Specific project (e.g., first-project)
     - Access level or VPC network
   
   - **Target**: Choose protected projects:
     - All projects in perimeter
     - Specific project IDs
   
   - **Service**: Select allowed APIs:
     - `storage.googleapis.com`
   
   - **Methods**: Choose operations:
     - All methods or selected ones

2. After saving, test access:

```bash
# Verify access is restored from authorized sources
gcloud storage buckets list

# Expected: List of buckets from protected project
```

```bash
# Verify access method restrictions
gcloud storage buckets describe gs://uppercase-bucket-name

# This may succeed based on configured methods
```

### Configuring Egress Policies
1. Add egress rule to perimeter:

   - **Identity**: ANY_IDENTITY (or specific type)
   - **To Attribute**:
     - GCP Services: Select target project
     - External: Add external resource URIs (S3 buckets, etc.)
   
   - **Service**: Select API (e.g., `storage.googleapis.com`)
   - **Methods**: Choose allowed operations

2. Test outbound access:

```bash
# Access external project from within perimeter
gcloud storage buckets list --project=external-project-id

# With egress rules: Success
# Without egress rules: Access denied
```

```bash
# Copy objects between projects
gsutil cp gs://source-bucket/object.txt gs://dest-bucket/

# Should work with proper egress configuration
```

## Summary

### Key Takeaways
```diff
+ Ingress rules control INBOUND traffic to protected resources from outside the perimeter
+ Egress rules control OUTBOUND traffic from resources within the perimeter to external services
- Never modify perimeter configurations directly in production without dry-run testing
+ Use granular control with specific identity types, sources, services, and methods to minimize risk
- VPC-SC can completely lockdown project access if misconfigured - always test first
+ For human users, use user accounts; for automation, use service accounts
+ Test configurations thoroughly before enforcement
```

### Quick Reference
```bash
# Check current buckets (after ingress setup)
gcloud storage buckets list

# Test egress access to external project
gcloud storage buckets list --project=external-project-id

# Copy between projects (requires egress rules)
gsutil cp gs://source-bucket/file.txt gs://dest-bucket/
```

### Expert Insight

**Real-world Application**: 
- Enterprise environments use VPC-SC ingress/egress rules for zero-trust architectures, allowing controlled data sharing between departments while preventing exfiltration. For example, allowing analytics teams restricted read-only access to production data buckets via ingress rules.

**Expert Path**: 
- Master VPC-SC by understanding Google Cloud Private APIs and combining perimeter rules with Access Context Manager levels for device-based access control. Practice with dry-run mode extensively before production implementation.

**Common Pitfalls**: 
- Avoid using "ALL" settings for identities, sources, or methods - start restrictive and expand gradually. Never implement without creating incident response procedures for perimeter lockouts. Ensure access levels are properly configured before use in ingress rules. Always audit rule changes in dry-run before enforcement.
