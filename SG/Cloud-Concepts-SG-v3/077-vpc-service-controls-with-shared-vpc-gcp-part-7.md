# Session 077: VPC Service Controls With Shared VPC GCP Part 7

<details open>
<summary><b>[Session/Section Name] (KK-CS45-script-v3)</b></summary>

## **Table of Contents**
- [Overview](#overview)
- [Key Concepts: Shared VPC with VPC Service Controls](#key-concepts-shared-vpc-with-vpc-service-controls)
- [Creating Separate Perimeters for VPC Networks](#creating-separate-perimeters-for-vpc-networks)
- [Rules for VPC Network Perimeters](#rules-for-vpc-network-perimeters)
- [Demo: Creating Service Perimeters](#demo-creating-service-perimeters)
- [Demo: Restricting Services and Using Egress Rules](#demo-restricting-services-and-using-egress-rules)
- [Summary](#summary)
  - [Key Takeaways](#key-takeaways)
  - [Quick Reference](#quick-reference)
  - [Expert Insight](#expert-insight)

## **Overview**
This session covers the final part of VPC Service Controls implementation, focusing on integrating VPC Service Controls with Shared VPC architectures. You'll learn how to create separate security perimeters for individual VPC Networks within a shared VPC host project, enabling granular control over service access for different environments (development, testing, production) instead of applying blanket restrictions across the entire host project.

## **Key Concepts: Shared VPC with VPC Service Controls**

### **Shared VPC Overview**
Shared VPC allows organizations to share VPC networks across multiple GCP projects, enabling centralized network management while maintaining project-level isolation.

### **VPC Service Controls Integration**
VPC Service Controls provide an additional security layer by constraining access to Google-managed services within the VPC perimeter, preventing data exfiltration to unrestricted services.

#### **Key Benefits of Separate Perimeters**
- **Granular Control**: Apply different service restrictions to different VPC Networks
- **Environment Isolation**: Development, testing, and production networks can have tailored security policies
- **Centralized Management**: Maintain shared VPC benefits while adding perimeter-based security

### **Perimeter Creation Strategy**
```
graph TD
    A[Host Project] --> B[VPC Network A<br/>- Test Environment<br/>- Restricted Services: GCS]
    A --> C[VPC Network B<br/>- Staging Environment<br/>- Restricted Services: BigQuery]
    A --> D[VPC Network C<br/>- Production Environment<br/>- Restricted Services: GCS, BigQuery]
    
    B --> E[Service Perimeter A<br/>Apply restrictions]
    C --> F[Service Perimeter B<br/>Apply restrictions]  
    D --> G[Service Perimeter C<br/>Apply restrictions]
```

## **Creating Separate Perimeters for VPC Networks**

### **Traditional vs. Granular Approach**
Traditional approach creates one perimeter for the entire host project. The granular approach allows one perimeter per VPC Network, enabling different security policies for each network segment.

### **Requirements**
- **Single Access Policy**: All VPC Networks in the same host project must belong to the same access policy
- **Perimeter Boundaries**: Each VPC Network perimeter acts as an independent security boundary
- **Service Isolation**: Resources within one perimeter cannot access services restricted by another perimeter

## **Rules for VPC Network Perimeters**

> [!IMPORTANT]
> Critical rules that must be followed when implementing VPC Service Controls with Shared VPC:

1. **Single Parameter Constraint**: A VPC Network cannot belong to multiple perimeters - it must be in exactly one parameter
2. **Access Policy Consistency**: All VPC Networks and the host project must be under the same access policy
3. **Parameter Bridge Exclusion**: VPC Networks cannot be added to a perimeter if their parent object exists in a perimeter bridge
4. **Host Project Protection**: If the host project is unprotected, VPC Networks can still be added to separate perimeters
5. **Project Inclusion**: To allow full service access, the project must be included in the perimeter along with the VPC Network

## **Demo: Creating Service Perimeters**

### **Environment Setup**
```
Host Project: shared-vpc-demo
├── Test Network: test-vpc
├── Staging Network: staging-vpc
└── Production Network: prod-vpc

Shared with:
├── First Project
└── Second Project
```

### **Creating Test Network Perimeter**

1. **Navigate to VPC Service Controls**
   ```bash
   # In Google Cloud Console
   Go to: Security > VPC Service Controls
   ```

2. **Create New Perimeter**
   - Name: `test-network-perimeter`
   - Resources to protect: Add VPC Network
   - Select host project containing the VPC networks
   - Choose specific VPC Network (test-vpc)

3. **Restrict Services**
   - Add restricted services: `storage.googleapis.com` (Cloud Storage API)
   - No ingress rules initially

### **Creating Staging Network Perimeter**

1. **Create Additional Perimeter**
   - Name: `staging-vpc-perimeter`
   - Add VPC Network resource (staging-vpc)
   - Restrict services: `bigquery.googleapis.com`

## **Demo: Restricting Services and Using Egress Rules**

### **Testing Service Restrictions**

**From Test VM (in test-vpc):**
```bash
# Cloud Storage access - BLOCKED
gsutil ls

# BigQuery access - ALLOWED (different perimeter)
bq ls
```

**From Staging VM (in staging-vpc):**
```bash
# BigQuery access - BLOCKED
bq ls

# Cloud Storage access - ALLOWED
gsutil ls
```

### **Implementing Egress Rules**

1. **Navigate to Egress Policy**
   ```yaml
   # Egress Policy Configuration
   - policy_name: allow-cloud-storage
     from:
       identities:
         - serviceAccount:any-service-account
       source:
         resources:
           - projects/first-project  # Target project
     to:
       operations:
         - serviceName: storage.googleapis.com
           methodSelectors:
             - method: "*"  # All methods
   ```

2. **Apply Egress Rule**
   - Create egress rule in the test-network-perimeter
   - Specify target projects where allowed services reside
   - Select specific services to allow

### **Verification**
After applying egress rules, previously blocked services become accessible:

```bash
# Cloud Storage now accessible via egress rule
gsutil ls
# Output: gs://bucket1, gs://bucket2
```

## **Summary**

### **Key Takeaways**
```diff
+ Granular Security: Create separate service perimeters for each VPC Network in shared VPC
+ Environment Isolation: Apply different service restrictions to dev/test/prod networks independently  
+ Centralized Control: Maintain shared VPC benefits while adding perimeter-based security
+ Flexible Access: Use ingress/egress rules to allow controlled access across perimeters
+ Single Policy Rule: All VPC Networks must belong to same access policy in host project
+ Excludes Parameter Bridges: Cannot add VPC Networks if parent is in parameter bridge
+ Project Inclusion: Add both projects and VPC Networks for full service access

- Cannot Multi-Perimeter: One VPC Network per perimeter only
- Same Access Policy Required: Cannot split VPC Networks across different access policies
- Host Project Dependencies: Check parameter bridge status before adding VPC Networks
```

### **Quick Reference**

#### **Perimeter Creation Commands**
```bash
# Create perimeter with VPC Network restriction
gcloud access-context-manager perimeters create test-network-perimeter \
  --title="Test Network Perimeter" \
  --resources=projects/host-project \
  --restricted-services=storage.googleapis.com \
  --vpc-allowed-services=RESTRICTED_SERVICES \
  --enable-vpc-accessible-services
```

#### **Common Service APIs**
- Cloud Storage: `storage.googleapis.com`
- BigQuery: `bigquery.googleapis.com`
- Cloud SQL: `sqladmin.googleapis.com`
- Compute Engine: `compute.googleapis.com`

#### **Perimeter Rules Checklist**
- [ ] Host project and VPC networks in same access policy
- [ ] Each VPC network belongs to exactly one perimeter
- [ ] Parent object not in parameter bridge
- [ ] Include projects for full service access (not just VPC networks)
- [ ] Configure appropriate ingress/egress rules

### **Expert Insight**

#### **Real-world Application**
In enterprise GCP environments, combine Shared VPC with VPC Service Controls to create secure, multi-tenant architectures. For example, a SaaS provider can isolate customer data environments while allowing controlled access to shared analytics services through carefully configured egress rules.

#### **Expert Path**
Master the relationship between access policies, perimeters, and parameter bridges. Understand how to design security architectures that balance isolation with operational flexibility. Learn advanced ingress/egress rule patterns for complex cross-project communication scenarios.

#### **Common Pitfalls**
- **Over-Restriction**: Adding projects to perimeters without also including necessary VPC networks results in overly restrictive policies
- **Parameter Bridge Conflicts**: Attempting to add VPC networks to perimeters when the host project exists in a parameter bridge
- **Cross-Perimeter Access**: Expecting resources from one perimeter to directly access services in another perimeter without proper ingress/egress rules
- **Access Policy Confusion**: Trying to place VPC networks from the same host project in different access policies (not supported)
- **Incomplete Service Inclusion**: Restricting services without considering all transitive dependencies and required APIs

</details>
