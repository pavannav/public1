# Session 071: VPC Service Controls GCP Part 1

<details open>
<summary><b>071-VPC-Service-Controls-GCP-Part-1 (KK-CS45-script-v3)</b></summary>

## Table of Contents
1. [Overview](#overview)
2. [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
   - [What is VPC Service Controls?](#what-is-vpc-service-controls)
   - [Security Benefits](#security-benefits)
   - [Access Policies](#access-policies)
   - [Service Perimeters](#service-perimeters)
   - [Perimeter Types](#perimeter-types)
   - [Enforce vs Dry Run Mode](#enforce-vs-dry-run-mode)
   - [VPC Accessible Services](#vpc-accessible-services)
3. [Lab Demo: Creating Service Perimeters](#lab-demo-creating-service-perimeters)
4. [Summary](#summary)

## Overview
This session introduces **VPC Service Controls** in Google Cloud Platform, focusing on Part 1 of a multi-part series. VPC Service Controls provide an additional layer of security for Google Cloud services by creating secure perimeters that protect against data exfiltration and unauthorized access. The session covers creating access policies, service perimeters, and demonstrates both enforcement and dry-run modes through practical examples.

:::info Key Learning Objectives
- Understand VPC Service Controls concepts and benefits
- Learn how to create organization-level access policies
- Implement service perimeters to restrict access to specific Google Cloud services
- Differentiate between enforce and dry-run modes
- Configure VPC accessible services for private Google access
:::

## Key Concepts and Deep Dive

### What is VPC Service Controls?
VPC Service Controls is a Google Cloud security feature that provides an **additional layer of protection** beyond Identity and Access Management (IAM). It creates secure perimeters around Google Cloud resources to prevent:

- Accidental or targeted data exfiltration
- Unauthorized network access using stolen credentials
- Malicious insiders or compromised code accessing sensitive data
- Public exposure of private data due to misconfigured IAM policies

### Security Benefits
VPC Service Controls addresses several critical security scenarios:

1. **Unauthorized Network Access**: Blocks access from unauthorized networks even with valid credentials
2. **Data Exfiltration Prevention**: Mitigates risks from malicious insiders or compromised code
3. **IAM Policy Overrides**: Protects against misconfigured IAM policies that might expose private data
4. **Fine-grained Control**: Enables secure data exchange across organizational boundaries

The service works **independently of IAM** but can be used alongside it for enhanced security.

### Access Policies
Before creating service perimeters, you must establish access policies:

**Two Types of Access Policies:**
- **Organization Level**: Required for scoped policies to function
- **Scoped Policies**: Can be created at folder or project level

:::warning Important Requirement
Scoped policies at folder/project level **do not work** unless an organization-level access policy exists first.
:::

### Service Perimeters
Service perimeters contain Google Cloud resources and define the services that can be accessed from within the perimeter boundaries.

**Key Components:**
- **Resources**: Projects or VPC networks to protect
- **Restricted Services**: Specific Google Cloud APIs to protect (supports 179+ services)
- **VPC Accessible Services**: Services accessible via Private Google Access
- **Access Levels**: Define conditions for access (covered in later parts)
- **Ingress/Egress Policies**: Control traffic flow (covered in Part 2)

### Perimeter Types
Two types of service perimeters available:

1. **Regular Perimeter**: Standard security perimeter for protecting resources
2. **Perimeter Bridge**: Allows communication between two perimeters (covered in separate video)

### Enforce vs Dry Run Mode
Every service perimeter exists in both modes simultaneously:

#### Enforce Mode (Default)
- **Active Security**: Requests violating the perimeter are **denied**
- Protects Google Cloud resources by enforcing perimeter boundaries
- **Impact**: Service calls are blocked when they violate perimeter rules
- Example: Accessing restricted services from outside the perimeter results in access denied

#### Dry Run Mode
- **Logging Only**: Requests that violate perimeter rules are **logged but not blocked**
- Useful for:
  - Testing perimeter impact before enforcement
  - Monitoring which services/requests would be affected
  - Determining appropriate perimeter boundaries
- **Monitoring Tools**: Use Cloud Logging to review denied requests
- **Metadata**: Logs include `dryRun=true` to distinguish from enforced blocks

:::tip Best Practice
Always test perimeter changes in dry run mode first to avoid disrupting production services.
:::

### VPC Accessible Services
Controls which restricted services can be accessed via Private Google Access:

**Configuration Options:**
- **All Services**: All services accessible via Private Google Access
- **No Services**: No services accessible via Private Google Access (maximum restriction)
- **All Restricted Services**: Only services listed as restricted can be accessed
- **Selected Services**: Manually specify which restricted services are accessible

**Private Google Access Prerequisites:**
- Must be enabled at the subnet level
- Allows access to Google Cloud services using internal IP addresses
- Traffic stays within Google's network

## Lab Demo: Creating Service Perimeters

### Prerequisites
- Google Cloud Organization
- Two GCP projects for testing
- Service account with appropriate IAM roles

### Step 1: Create Organization Access Policy
```bash
# Navigate to VPC Service Controls in Google Cloud Console
# 1. Go to VPC Service Controls → Manage Policies
# 2. Click "Create Policy"
# 3. Choose "Organization" scope (don't add projects/folders)
# 4. Provide policy name (e.g., "my-access-policy")
# 5. Optionally add principals with administrator roles
# 6. Click "Create Access Policy"
```

### Step 2: Create Service Perimeter
```bash
# Create a new service perimeter
# 1. Click "Create Perimeter"
# 2. Choose perimeter name (e.g., "secure-second-project")
# 3. Select perimeter type: Regular (default)
# 4. Choose "Enforce" mode (dry run is also created automatically)
```

### Step 3: Configure Resources to Protect
```bash
# Add resources (projects or VPC networks)
# Example: Add target project to protect GCS and Compute resources
# 1. In "Resources to protect" section
# 2. Select "Projects" 
# 3. Choose target project (e.g., "second-project")
```

### Step 4: Restrict Services
```bash
# Add specific Google Cloud APIs to restrict
# Example: Restrict Cloud Storage and Compute APIs
# 1. In "Restricted Services" section
# 2. Click "Add Services"
# 3. Select "Cloud Storage API" and "Compute Engine API"
# 4. Add selected services to the restriction list
```

### Step 5: Configure VPC Accessible Services
```bash
# Control Private Google Access behavior
# Options:
# - All services via Private Google Access
# - No services via Private Google Access  
# - All restricted services
# - Selected specific services

# Example: Enable private access to restricted services
# 1. Select "All restricted services"
# 2. This allows GCS/Compute access from subnets with Private Google Access enabled
```

### Step 6: Test Perimeter Enforcement
```bash
# Test from unauthenticated external access
gcloud compute instances list --project=target-project
# Result: Access denied - prohibited by organization policy

gcloud storage buckets list --project=target-project  
# Result: Access denied - VPC Service Controls blocks access
```

### Step 7: Enable Private Google Access (if needed)
```bash
# In VPC Network settings:
# 1. Navigate to VPC → Networks
# 2. Select the network containing your test instances
# 3. Go to Subnets
# 4. Edit subnet settings
# 5. Enable "Private Google access" under Private access options
```

### Step 8: Testing and Modifications
```bash
# Test access from authorized VPC:
# Login to VM in subnet with Private Google Access enabled
gcloud compute instances list --project=target-project  # Works
gcloud storage buckets list --project=target-project   # Works

# Monitor in dry run mode:
# 1. Edit perimeter to add services to dry run
# 2. Check Cloud Logging for denied requests
# 3. Review serviceName, method, and dryRun=true metadata

# Remove services from enforced perimeter for testing:
# 1. Edit perimeter
# 2. Remove services from "Restricted Services"
# 3. Save - changes take effect immediately
```

### Step 9: SSH Access Testing
```bash
# Attempt SSH to VM in protected project:
# 1. Compute Engine → VM instances
# 2. Click SSH for target VM
# 3. Result: Connection failed - network path blocked

# SSH works when:
# - VM is in VPC with proper ingress rules (covered in Part 2)
# - Using authorized network paths
```

## Summary

### Key Takeaways
```diff
+ VPC Service Controls provides perimeter-based security beyond IAM
+ Always create organization access policy before scoped policies
+ Use dry run mode first to test perimeter impact
+ Perimeters can protect projects or specific VPC networks
+ Private Google Access enables internal service communication
- Misconfigurations can block all access to protected resources
! Test perimeter changes thoroughly before enforcement
```

### Quick Reference
```bash
# Common CLI commands for testing perimeters:
gcloud compute instances list --project=PROJECT_ID    # Test Compute API access
gcloud storage buckets list --project=PROJECT_ID      # Test Storage API access  
gcloud compute networks list --project=PROJECT_ID     # Test Network API access

# Enable Private Google Access on subnet:
# VPC Network → Subnets → Edit subnet → Enable Private Google access
```

### Expert Insight

**Real-world Application**: VPC Service Controls is critical for regulated industries handling sensitive data (healthcare, finance). Use perimeters to create "data lakes" where sensitive information can only be accessed from secure, monitored networks while allowing public access to less sensitive resources.

**Expert Path**: Master perimeter-to-perimeter communication using perimeter bridges. Learn advanced ingress/egress rules with access levels based on device trust, IP ranges, and identity attributes. Combine with BeyondCorp Enterprise access policies for zero-trust architectures.

**Common Pitfalls**: 
- Creating scoped policies before organization policy exists
- Testing perimeters with production workloads without dry run
- Forgetting that perimeter changes affect all resources within the perimeter scope
- Misconfiguring VPC Accessible Services leading to unexpected access denials

**Next Steps**: Part 2 covers VPC network-based perimeters, ingress/egress rules, access levels, and scoped policies for fine-grained control.

</details>
