# Session 072: VPC Service Controls GCP Part 2

## Table of Contents
- [Overview of VPC Service Controls at VPC Network Level](#overview-of-vpc-service-controls-at-vpc-network-level)
- [Differences Between Project-Level and VPC Network-Level Protections](#differences-between-project-level-and-vpc-network-level-protections)
- [Restricting Services from Within a VPC Network](#restricting-services-from-within-a-vpc-network)
- [Accessible Services Configuration](#accessible-services-configuration)
- [Lab Demo: Setting Up VPC Service Controls at VPC Network Level](#lab-demo-setting-up-vpc-service-controls-at-vpc-network-level)
- [Testing and Verification](#testing-and-verification)
- [Summary](#summary)

## Overview of VPC Service Controls at VPC Network Level
VPC Service Controls provide a security layer to restrict access to Google Cloud services based on the context of the request. While Part 1 covered implementation at the project level, this session focuses on applying these controls at the VPC network level. This allows you to prevent resources within a specific VPC network from accessing certain Google Cloud APIs, enhancing isolation and compliance for sensitive workloads. It's particularly useful in multi-VPC environments where different VPCs serve distinct purposes (e.g., separating development, staging, and production).

Key considerations include understanding how traffic routing works through private Google access and the implications of service restrictions on compute resources like VMs within the VPC.

## Key Concepts/Deep Dive
### Service Perimeters and Protection Scope
- **Project-Level Protection**: Protects services by blocking external access from outside the perimeter. Traffic from the internet or other projects is denied for restricted services.
- **VPC Network-Level Protection**: Restricts service access exclusively from within the VPC network itself. Resources outside the VPC (e.g., in other projects or via the internet) can still access the services if not otherwise blocked.

### Accessible Services vs. Restricted Services
- **Restricted Services**: APIs explicitly denied access from the VPC. VMs in the restricted VPC cannot call these APIs.
- **Accessible Services**: APIs that can be accessed via Private Google Access (PGA). This allows traffic to flow within Google's network without external IP egress.

### Private Google Access (PGA)
PGA enables VMs without external IPs to access Google Cloud services using internal network routes. This is essential for VPC-level controls where external connectivity is not allowed.

#### Configurations Table
| Configuration | Description | Use Case |
|----------------|-------------|----------|
| All Services (VPC Accessible) | All services accessible via PGA | Default for development environments |
| No Services | No services accessible via PGA | Maximum isolation |
| Selected Services | Specific services only via PGA | Controlled access for production |

### Common Scenarios
- **Development VPC Isolation**: Restrict access to production storage buckets from development VPCs to prevent accidental data exposure.
- **Compliance Requirements**: Ensure sensitive APIs (e.g., BigQuery in production VPC) are inaccessible from lower-trust environments.

## Restricting Services from Within a VPC Network
When services are restricted at the VPC level, any API calls originating from resources (e.g., VMs) within that VPC will be denied. This differs from project-level restrictions, which block external traffic.

- **Impact on VMs**: Even if a VM has IAM permissions, VPC-level restrictions take precedence.
- **Multiple VPCs**: You can have multiple VPCs in a project, each with different restrictions, allowing granular control.

## Accessible Services Configuration
You can configure which services are accessible via PGA:
- **All Services**: Full access via PGA.
- **No Services**: No PGA access; all requests must use external routes (not recommended for isolated VPCs).
- **Specific Services**: Allow only listed services via PGA, excluding others.

This setting interacts with restricted services: If a service is restricted, it's blocked; if accessible, it's allowed via PGA.

## Lab Demo: Setting Up VPC Service Controls at VPC Network Level
Follow these steps to configure VPC Service Controls at the VPC network level in the Google Cloud Console.

### Prerequisites
- Active Google Cloud project with VPC networks.
- Enable VPC Service Controls API: `gcloud services enable accesscontextmanager.googleapis.com`.
- VMs in the target VPC (no external IP for PGA testing).

### Steps
1. **Navigate to VPC Service Controls**:
   - Go to the Google Cloud Console > Security > VPC Service Controls.

2. **Create a Perimeter**:
   - Click "Create perimeter".
   - Name: `second-project-vpc` (example naming).
   - Type: Regular (bridged perimeters are advanced and covered later).

3. **Select Resources to Protect**:
   - Instead of selecting a project, choose "VPC Network".
   - Select the target VPC (e.g., `default` VPC in your project).
   - This perimeter will apply only to this VPC network.

4. **Restrict Services**:
   - In "Restricted Services", add APIs to block (e.g., `storage.googleapis.com` for Cloud Storage).
   - Save the perimeter.

5. **Configure Accessible Services (Optional)**:
   - In "VPC Accessible Services" section:
     - Choose "All services" or "Selected services".
     - If "Selected services", list APIs allowed via PGA (e.g., `bigquery.googleapis.com`).

6. **Enable Private Google Access**:
   - Go to VPC Networks > Subnets > Select the subnet of your VPC.
   - Check "Enable Private Google access for this subnet".

7. **Test Configurations**:
   - SSH into a VM in the restricted VPC.
   - Attempt API calls (see Verification section below).

### Code/Config Blocks
#### Enable VPC Service Controls API (Bash)
```bash
gcloud services enable accesscontextmanager.googleapis.com
```

#### Terraform Example for Perimeter Creation (HCL)
```hcl
resource "google_access_context_manager_service_perimeter" "vpc_perimeter" {
  parent      = "accessPolicies/${var.policy_id}"
  name        = "accessPolicies/${var.policy_id}/servicePerimeters/vpc_perimeter"
  title       = "VPC Network Perimeter"
  description = "Protect a specific VPC network"
  
  perimeter_type = "PERIMETER_TYPE_REGULAR"
  
  status {
    vpc_accessible_services {
      enable_restriction = true
      allowed_services = ["bigquery.googleapis.com"]
    }
    
    restricted_services = [
      "storage.googleapis.com",
      "bigquery.googleapis.com"
    ]
    
    vpc_allowed_services {
      vpc_networks {
        network = "projects/${var.project_id}/global/networks/default"
      }
    }
  }
}
```

## Testing and Verification
### Test Restricted Services
1. **From Restricted VPC**: Create or use a VM in the protected VPC.
   - Run: `gcloud storage buckets list` or `gsutil ls`
   - Expected: Access denied error due to VPC Service Controls.
   - No external IP needed if PGA is enabled.

2. **From Outside the VPC** (Different Project or Internet):
   - Run the same command from another project.
   - Expected: Success (if no project-level restrictions).

### Test Accessible Services
- With "All services" in VPC Accessible Services:
  - Access all PGA-enabled services from the VM.
- With "No services":
  - Deny all PGA access; use external routes if available.
- With "Selected services":
  - Only specified services work via PGA.

### Monitoring
- Use Cloud Logging to monitor denied requests: Look for logs with `vpcServiceControls` context.

> [!IMPORTANT]
> Always test in non-production environments. Perimeter changes may take time to propagate (5-10 minutes).

## Summary

### Key Takeaways
```diff
+ VPC Network-Level Protection: Blocks service access from within the VPC only, allowing resources in other VPCs or projects to access restricted services (unlike project-level).
+ Accessible Services: Configure PGA to allow specific or all services via internal routing, combining with restrictions for granular control.
+ Demo Workflow: Create perimeter → Add VPC → Restrict services → Enable PGA → Test from VM.
- Avoid Confusing Scopes: Project-level affects external access; VPC-level affects internal. Do not apply both without understanding overlaps.
! Security Note: Restrictions enforce context-aware isolation; bypass possible via IAM, so combine with proper permissions.
```

### Expert Insight

#### Real-World Application
In enterprise cloud architectures, VPC-level VPC Service Controls isolate sensitive workloads: e.g., production VPC restricts BigQuery and Cloud Storage access from development VPCs. Combine with Identity-Aware Proxy (IAP) for end-user access control in production deployments. For multi-tenant environments, use separate perimeters per VPC to enforce data residency and compliance (e.g., GDPR restrictions on data access paths).

#### Expert Path
- Master perimeter bridges for shared VPC scenarios—requires understanding of host/project VPC inheritance.
- Integrate with Access Context Manager Policies: Define access levels for conditional ingress/egress (e.g., IP ranges, device states).
- Automate with Terraform: Version control perimeter configurations; use policy sets for environments.
- Advanced: Use VPC Firewall rules alongside for layer 4-7 control.

#### Common Pitfalls
- **Misunderstanding Scope**: Assuming VPC-level restrictions block external access—test from multiple contexts.
- **PGA Oversight**: Forgetting to enable private access on subnets leads to connectivity issues.
- **Propagation Delays**: Changes take time; hasty provisioning causes confusion.
- **IAM Conflicts**: Restrictions don't override IAM—permissions alone allow access if not restricted.

#### Lesser-Known Things
- Perimeters support dry-run mode during creation to simulate impacts without enforcing.
- VPC-level controls work in shared VPCs, but require careful IAM delegation from the host project.
- Logging filter: Use `protoPayload.status.message:VPC_SERVICE_CONTROLS` to monitor all denied requests.

**Transcript Corrections Notified**:
- "VP service control" corrected to "VPC Service Controls" throughout.
- "parameter" corrected to "perimeter" (referring to Service Perimeter in GCP terminology).
- "bpc" corrected to "VPC".
- "parameter Bridge" corrected to "perimeter bridge" (likely referring to bridged perimeters).
- Typos like "uh" removed, and grammatical errors fixed (e.g., "we will look for" to explained context; "sping" to "specifying"). All corrections ensure accurate GCP concepts without altering technical meaning. If any misinterpretations remain, clarify the original intent.
