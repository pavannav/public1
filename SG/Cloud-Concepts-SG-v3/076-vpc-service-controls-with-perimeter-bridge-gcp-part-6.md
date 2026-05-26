# 076-VPC-Service-Controls-With-Perimeter-Bridge-GCP-Part-6

<details open>
<summary><b>076-VPC-Service-Controls-With-Perimeter-Bridge-GCP-Part-6 (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts / Deep Dive](#key-concepts--deep-dive)
- [Lab Demo](#lab-demo)
- [Summary](#summary)

## Overview
This session covers Perimeter Bridges in VPC Service Controls, which enable communication between projects in different service perimeters within the same access policy. It includes considerations, limitations, and a practical demonstration of creating and using perimeter bridges.

**Transcript Corrections Noted**: The transcript frequently uses "parameter" instead of "perimeter" (e.g., "service parameter" should be "service perimeter", "parameter Bridge" should be "Perimeter Bridge"). This has been corrected throughout the study guide for accuracy. Other minor typos, such as "exis" corrected to "exists", "accit" to "access", and "transed" to "transitive", have been fixed accordingly.

## Key Concepts / Deep Dive

### Perimeter Bridges
Perimeter Bridges allow projects in different service perimeters to communicate with each other. This is crucial when you have multiple perimeters isolating different projects, but specific projects need to interact securely.

- **Scope and Access Control**:
  - Bridges are scoped to an access policy.
  - Communication is allowed only between projects explicitly connected by the bridge, on an equal footing within the bridge's scope.
  - Access levels and service restrictions are controlled by the individual service perimeters to which the projects belong.

- **Multiple Bridges per Project**:
  - A single project can participate in multiple bridges, connecting it to various other projects across different perimeters.

- **No Transitive Access**:
  - Connections are not transitive. For example, if Project A is connected to Project B via a bridge, and Project B is connected to Project C, Project A cannot directly communicate with Project C without an explicit bridge.

### Considerations for Perimeter Bridges
Before implementing perimeter bridges, consider the following requirements and limitations:

- **Prerequisite: Project Membership**:
  - Each project must already belong to a service perimeter before it can be connected via a bridge.
  - You cannot connect a project that is not part of any perimeter.

- **Organization Constraints**:
  - Perimeter bridges can only connect projects within the same organization. Projects from different organizations cannot be bridged.

- **Scoped Policy Restrictions**:
  - Projects in different scoped policies (scoped to different folders or projects) cannot be bridged.
  - Bridges are supported only in organization-level or folder-level policies, where multiple projects can be included in perimeters.
  - Scoped policies (e.g., at the project level) typically include only one project, so bridges are not applicable across them.

- **VPC Network Integration**:
  - Once a perimeter bridge is created, you can add VPC networks from the bridged projects to the perimeters as needed for networking.

This ensures isolation and controlled access while allowing necessary communication between projects.

## Lab Demo

### Steps to Create and Test Perimeter Bridges
In this demo, we secure two GCP projects ("first-project" and "second-project") in separate service perimeters, then create a perimeter bridge to enable communication. Testing confirms that traffic flows between projects only after the bridge is established.

#### Prerequisites
- Two GCP projects: "first-project" and "second-project".
- Access Policy at the organization level is assumed (organization policies allow multi-project perimeters; scoped policies do not).
- GCP Cloud Console or CLI access with appropriate permissions.

#### Step 1: Create Service Perimeters
1. Navigate to the VPC Service Controls page in the GCP Console.
2. Select your access policy (e.g., organization policy).
3. Create the first service perimeter:
   - Name: "first-perimeter".
   - Add resources: Select "first-project" from the project list.
   - Add services: Include Cloud Storage (`storage.googleapis.com`) to allow access.
4. Create the second service perimeter:
   - Name: "second-perimeter".
   - Add resources: Select "second-project".
   - Add services: Include Cloud Storage (`storage.googleapis.com`).

> [!IMPORTANT]
> If both projects are added to the same perimeter, they form a "fence" and communicate freely. For different security requirements (e.g., allowing Cloud Storage in one but BigQuery in another), use separate perimeters.

#### Step 2: Verify Isolation Before Bridge
- From a VM in "second-project", run:
  ```bash
  gcloud storage buckets list
  ```
  - Result: Access denied (Error 403). The project is isolated outside "first-perimeter".
- Attempting to list compute instances in "first-project" from "second-project":
  ```bash
  gcloud compute instances list
  ```
  - Result: Access denied, as there's no egress policy in "first-perimeter".

#### Step 3: Create a Perimeter Bridge
1. In the VPC Service Controls page, click "New Perimeter" and select "Perimeter Bridge".
2. Name: "bridge".
3. Resources to bridge:
   - Select projects: Include "first-project" and "second-project" (they must already be in perimeters).
4. Create the perimeter bridge.

> [!NOTE]
> The bridge options only appear for projects already in separate perimeters. You cannot bridge projects not in perimeters or across scoped policies.

#### Step 4: Test Communication After Bridge
- Wait ~1-2 minutes for propagation.
- Run again from VM in "second-project":
  ```bash
  gcloud storage buckets list
  ```
  - Result: Success. Buckets in "first-project" are listed.
- Test compute instances:
  ```bash
  gcloud compute instances list
  ```
  - Result: Success. Instances across projects are visible.
- Verify bidirectionality by testing commands from "first-project" to "second-project".

#### Cleanup and Additional Notes
- To delete a service perimeter, remove any bridges first (deletion fails otherwise).
- Scoped policies (created at project or folder level) do not support multi-project perimeters or bridges, as they enforce single-project isolation.
- For folder-level policies, if multiple projects exist in one folder, you can create perimeters and bridges as shown.

This demo illustrates the utility of perimeter bridges for secure inter-project communication without compromising overall perimeter integrity.

## Summary

### Key Takeaways
```diff
+ Perimeter Bridges enable secure communication between projects in different service perimeters within the same access policy.
+ Access controls remain governed by individual project perimeters, preventing transitive access.
- Projects must be in perimeters before bridging; separate scoped policies cannot be bridged.
- Bridges work only within the same organization and support multi-project perimeters (not scoped ones).
+ VPC Service Controls ensure isolation, but bridges provide necessary flexibility for collaborative environments.
```

### Quick Reference
- **Create Perimeter Bridge** (Console): VPC Service Controls > New Perimeter > Perimeter Bridge > Select Projects.
- **Test Commands**:
  ```bash
  # List storage buckets (test communication)
  gcloud storage buckets list

  # List compute instances across projects
  gcloud compute instances list
  ```
- **Limitations**: No cross-organization or scoped-policy bridges.

### Expert Insight
- **Real-world Application**: In enterprise GCP setups, use perimeter bridges for microservices teams needing shared resources (e.g., one team's analytics accessing another's data lake) while maintaining perimeter-level security. This avoids over-permissive policies and supports compliance like GDPR or HIPAA.
- **Expert Path**: Master path: Deepen knowledge with GCP documentation on VPC Service Controls. Experiment with ingress/egress policies combined with bridges, and automate bridge creation via Terraform for DevOps workflows. Advance by integrating with Cloud Identity-aware Proxy (IAP) for user-level access controls.
- **Common Pitfalls**: Avoid adding projects to the wrong scopes (e.g., scoped policies for multi-project needs). Delaying bridge creation leads to communication failures; monitor with Cloud Logging. Forgetting dependency order (perimeters first, then bridges) causes errors.

</details>
