# Session 072: VPC Service Controls GCP Part 2

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
- [Lab Demonstrations](#lab-demonstrations)
- [Summary](#summary)

## Overview
This session focuses on implementing VPC Service Controls at the VPC Network level, building on the project-level approach covered in Part 1. You'll learn the differences between project and VPC Network scoping, how to create service perimeters that restrict service access from within specific VPCs, and practical demonstrations using Google Cloud Console and CLI tools.

## Key Concepts and Deep Dive

### Differences Between Project-Level and VPC-Level VPC Service Controls

VPC Service Controls provide perimeter security for Google Cloud resources, but the scope and effect differ significantly depending on whether you implement them at the project or VPC Network level:

**Project-Level Implementation:**
- **Scope**: Protects resources at the project boundary
- **Blocking Mechanism**: Blocks access to protected services from outside the perimeter (Internet, other projects)
- **Resource Constraints**: Requires access levels and ingress/egress rules for external connectivity
- **Use Case**: Prevent unauthorized external access to specific project resources

**VPC Network-Level Implementation:**
- **Scope**: Protects services from within the VPC Network itself
- **Blocking Mechanism**: Restricts access to Google Cloud APIs from VMs and resources inside the VPC
- **Resource Constraints**: Can block private Google access traffic within the VPC
- **Use Case**: Isolate VPCs (e.g., development VPC can't access production storage)

> [!IMPORTANT]
> VPC-level perimeters restrict access from inside the VPC, while project-level perimeters restrict external access to the project. You can use both levels simultaneously but must ensure compatibility.

### Service Perimiters at VPC Network Level
Service perimeters define the boundaries of your secure environment. When scoped to VPC Networks:

```yaml
- Resource Type: VPC_ACCESSIBLE_SERVICES
- Scope: Specific VPC Networks within a project  
- Protection: Ingress from within VPC to Google APIs
```

### Resources to Protect
Unlike project-level perimeters where you select entire projects, VPC Network perimeters allow granular control:

- **VPC Networks**: Add specific VPCs to the perimeter
- **Services**: Block or allow Google Cloud APIs from VLAN-restricted VMs
- **Accessible Services**: Define which services VMs in the VPC can reach via private Google access

### Private Google Access Integration
VPC-level service controls interact with Private Google Access settings at the subnet level:

- **Enabled**: Allows all Google APIs access through private routing
- **Disabled**: Services controlled by perimeter rules
- **Impact**: Perimeter restrictions override Private Google Access for blocked services

## Lab Demonstrations

### Demo 1: Creating Service Perimeter for VPC Network-Level Access Control

**Objective**: Restrict Cloud Storage API access from within a specific VPC Network.

**Prerequisites**:
- Two projects (first-project, second-project)
- VPC Networks created in each project
- VMs in both projects without external IPs
- Private Google Access enabled on VM subnets
- Service accounts with appropriate IAM roles

**Steps**:

1. **Create Service Perimeter in Security Command Center**:
   ```
   Navigation: Security → VPC Service Controls → Create new perimeter
   ```

2. **Configure Perimeter**:
   - **Perimeter Name**: second-project-vpc-perimeter (regular perimeter type)
   - **Resources to Protect**: VPC Networks only
   - **Projects**: Select second-project
   - **VPC Networks**: Add "default" VPC (target VPC to restrict)

3. **Configure Services to Protect**:
   - Select "Add specific services to protect"
   - Add "Cloud Storage API (storage.googleapis.com)"
   - Keep "VPC Accessible Services" as "All services allowed"

4. **Validation Before Restriction**:
   - Connect to VM in second-project VPC
   - Run command to verify access:
     ```bash
     gsutil ls
     ```
     - Expected output: No buckets found (but command succeeds)

5. **Apply Perimeter Restriction**:
   - Create the perimeter in console
   - Wait for propagation (typically 2-5 minutes)

6. **Test Blocked Access**:
   - Re-run command from VM in restricted VPC:
     ```bash
     gsutil ls
     ```
   - Expected output:
     ```
     AccessDeniedException: 403 Request is prohibited by VPC Service Controls
     ```

7. **Verify Access from Unrestricted VPC**:
   - Connect to VM in first-project VPC
   - Run cross-project access test:
     ```bash
     gcloud storage buckets list --project=second-project
     ```
   - Expected output: Command succeeds (external access allowed)

### Demo 2: Adding Multiple Service Restrictions

**Objective**: Extend restrictions to include BigQuery API access.

**Steps**:

1. **Edit Existing Perimeter**:
   - Go to VPC Service Controls
   - Edit the second-project-vpc-perimeter
   - Add "BigQuery API (bigquery.googleapis.com)" to restricted services

2. **Test BigQuery Access Before**:
   ```bash
   bq ls
   ```
   - Expected: Returns dataset list (access allowed)

3. **Apply Changes and Test**:
   ```bash
   bq ls
   ```
   - Expected: "Operation denied by VPC Service Controls"

### Demo 3: Understanding VPC Accessible Services Controls

**Objective**: Demonstrate how accessible services affect VPC-level restrictions.

**Configuration Comparison**:

| Setting | VPC Accessible Services | Impact on VPC Resources |
|---------|------------------------|--------------------------|
| All services | All Google APIs | Full private access via private Google access |
| Restricted list | Only specified APIs | Only listed services accessible; others blocked |
| No services | None | No Google APIs accessible via private access |

**Testing Compute API Access**:
```bash
gcloud compute networks list
```
- With "All services": Command succeeds
- With restrictive settings: May fail depending on configuration

> [!NOTE]
> VPC-level restrictions don't affect project-level external access controls. A service blocked at VPC-level can still be accessed from outside the project if not restricted there.

## Summary

### Key Takeaways
```diff
+ VPC Network-level perimeters restrict internal access from within VPCs, unlike project-level which blocks external access
+ Use VPC perimeters for isolating environments (e.g., dev VPC can't access prod storage)
+ Private Google Access interacts directly with VPC perimeter rules - blocked services cannot use private routing
+ Can combine project and VPC-level perimeters for comprehensive security
+ Changes may take several minutes to propagate
- Don't accidentally set "No services" accessible unless you have project-level restrictions configured
- Ensure service account permissions don't contradict perimeter restrictions
! Test perimeter changes thoroughly before applying in production
```

### Quick Reference

**Creating Perimeter** (GCLOUD CLI):
```bash
gcloud access-context-manager perimeters create second-project-vpc-perimeter \
  --title="VPC Level Storage Protection" \
  --resources=//compute.googleapis.com/projects/second-project \
  --restricted-services="storage.googleapis.com" \
  --access-levels="" \
  --enable-vpc-accessible-services=True
```

**Common Commands for Testing**:
```bash
# Cloud Storage
gsutil ls

# BigQuery  
bq ls

# Compute Engine API
gcloud compute networks list

# Cross-project access test
gcloud storage buckets list --project=target-project
```

### Expert Insight

**Real-world Application**: Implement VPC-level perimeter in multi-environment setups where development teams need isolated access. For example, create separate perimeters for "dev-vpc", "test-vpc", and "prod-vpc", allowing dev environments limited API access while production maintains full access control.

**Expert Path**: Advanced implementations involve access levels with custom conditions, ingress/egress rules for data exfiltration prevention, and conditional perimeters that change based on resource tags or labels. Master parameter bridging for cross-project resource sharing while maintaining security isolation.

**Common Pitfalls**: 
- Forgetting that VPC levels don't protect against external threats - always combine with project-level if external blocking is needed
- Testing perimeters only from console, missing edge cases with service accounts or regional routing
- Not accounting for propagation delays that can cause intermittent failures during testing
- Misconfiguring accessible services, locking out necessary APIs while leaving others exposed

This completes VPC Service Controls Part 2. Part 3 covers access levels, ingress/egress policies, and parameter bridging for complex multi-project scenarios.
