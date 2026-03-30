# Session 31: RBAC k8s Concepts, Cloud IAM on Kubernetes

## Table of Contents
- [Introduction to Authorization in Kubernetes](#introduction-to-authorization-in-kubernetes)
- [Google Cloud IAM for Kubernetes](#google-cloud-iam-for-kubernetes)
- [Drawbacks of Cloud IAM with Kubernetes](#drawbacks-of-cloud-iam-with-kubernetes)
- [Introduction to Role-Based Access Control (RBAC)](#introduction-to-role-based-access-control-rbac)
- [RBAC Concepts: Subjects, Roles, and Bindings](#rbac-concepts-subjects-roles-and-bindings)
- [Demonstration: Creating Roles and Role Bindings](#demonstration-creating-roles-and-role-bindings)
- [Cluster Roles and Cluster Role Bindings](#cluster-roles-and-cluster-role-bindings)
- [Using Service Accounts in RBAC](#using-service-accounts-in-rbac)
- [Using Groups in RBAC](#using-groups-in-rbac)

## Introduction to Authorization in Kubernetes
### Overview
This session explores the concepts of workload identity federation, focusing on Role-Based Access Control (RBAC) in Kubernetes and its comparison with Google Cloud Identity and Access Management (IAM). Authorization in Kubernetes determines how users or systems access and perform actions on resources, contrasting with authentication (login processes). The session highlights why RBAC is preferred for fine-grained, cloud-agnostic control over Kubernetes clusters, especially in multi-cluster or enterprise environments.

### Key Concepts/Deep Dive
- **Authentication vs. Authorization**:
  - Authentication: Verifies identity (e.g., logging into GCP with Gmail). In Kubernetes, this includes users, service accounts, or groups.
  - Authorization: Determines permissions (what actions on which resources). Supports two main models: Cloud IAM and RBAC.
- **Cloud Agnostic Nature of RBAC**:
  - Unlike GCP-specific IAM (Google Cloud Identity and Access Management), RBAC uses Kubernetes-native constructs applicable across clouds (AWS, Azure, GCP) or self-managed clusters.
- **Why RBAC?**:
  - Enables precise access control at cluster, namespace, or resource levels.
  - Supports separation of duties (e.g., administrators provision clusters, developers deploy workloads).

### Code/Config Blocks
No specific code blocks in this introductory section, but RBAC configurations will be covered later.

### Lab Demos
No demos in this section; demonstrations follow in subsequent topics.

## Google Cloud IAM for Kubernetes
### Overview
Google Cloud IAM (Identity and Access Management) provides native authentication and authorization for GCP resources, including Google Kubernetes Engine (GKE). This section details key IAM roles specific to Kubernetes, their scopes, and how they integrate with GKE clusters.

### Key Concepts/Deep Dive
- **Key IAM Roles for Kubernetes**:
  - **Kubernetes Engine Cluster Viewer**: Allows viewing cluster details (lowest privilege for cluster access). Essential for connecting to clusters via commands like `gcloud container clusters get-credentials`.
  - **Kubernetes Engine Cluster Admin**: Grants permissions to create, delete, and update clusters. Requires additional roles like Compute Engine Admin or Service Account User for full cluster provisioning.
  - **Kubernetes Engine Developer**: Permits deploying objects like Deployments, Services, Secrets, ConfigMaps, and Ingresses. Focuses on application deployments, not infrastructure management.
- **Project-Level IAM**:
  - Roles apply at the GCP project level, granting access to all resources within the project.
- **Prerequisites for Cluster Provisioning**:
  - Cluster creation needs IAM permissions for compute resources, networks, and service accounts (e.g., `roles/serviceaccount.user` for impersonation).
- **Certification Alignment**:
  - Kubernetes Administrator aligns with Certified Kubernetes Administrator (CKA).
  - Kubernetes Developer aligns with Certified Kubernetes Application Developer (CKAD).

### Tables
| IAM Role | Scope | Permissions Example | Key Limitation |
|----------|-------|---------------------|----------------|
| Kubernetes Engine Cluster Viewer | Cluster Viewer | `container.clusters.get` | Read-only cluster info |
| Kubernetes Engine Cluster Admin | Full Cluster | Create/Update/Delete clusters, `compute.*` permissions | Requires additional compute/network roles |
| Kubernetes Engine Developer | Application Deployment | `container.deployments.*`, `container.services.*` | No cluster management permissions |

### Lab Demos
#### Step-by-Step: Provisioning a GKE Cluster with IAM Roles
1. Assign IAM roles to a user (e.g., `Kubernetes Engine Cluster Admin` + `Service Account User` + custom roles for compute/network).
2. Run cluster creation commands:
   ```bash
   gcloud container clusters create <cluster-name> --num-nodes=2
   ```
3. Verify access: Try retrieving cluster credentials with a user having `Kubernetes Engine Cluster Viewer`.
4. Outcome: User with sufficient roles can create clusters; insufficient roles lead to errors (e.g., "User does not have service account user role").

## Drawbacks of Cloud IAM with Kubernetes
### Overview
While Google Cloud IAM is straightforward for GCP-native resources, it has limitations for fine-grained Kubernetes control, particularly in scenarios requiring access restrictions to specific clusters or namespaces.

### Key Concepts/Deep Dive
- **Project-Level Granularity**:
  - Roles apply to the entire project, allowing access to all clusters. No option to restrict to a single cluster via UI or standard commands.
  - Workaround: Use dedicated GCP projects per environment/team, but this increases management overhead.
- **Separation of Duties Challenges**:
  - Cluster admins can provision infrastructure, but deployed workloads might be inaccessible to them, enforcing separation (e.g., admins create clusters, developers deploy apps).
- **No Resource-Level Restrictions**:
  - Unlike VM or bucket access (which supports per-resource policies), GKE clusters lack this feature, leading to broad access grants.
- **Hybrid Strengths**:
  - Combine Cloud IAM for project-level control with Kubernetes RBAC for finer-grained policies inside clusters.

> [!NOTE]  
> For multi-cluster setups in one project, Cloud IAM permits access to all clusters, potentially violating least privilege principles.

### Code/Config Blocks
Example of checking IAM roles for a user:
```bash
gcloud projects get-iam-policy <project-id> | grep <user-email>
```

### Lab Demos
#### Demonstrating IAM Limitations
1. Create two GKE clusters in the same project.
2. Assign `kubernetes-engine.developer` role to a user.
3. Log in as the user and connect to both clusters (`kubectl config use-context <cluster>`).
4. Deploy a workload in one cluster.
5. Verify: User can access and deploy in both clusters, illustrating the project-level scope drawback.

## Introduction to Role-Based Access Control (RBAC)
### Overview
Role-Based Access Control (RBAC) is Kubernetes-native authorization, providing cloud-agnostic, fine-grained access control. Unlike Cloud IAM's project-level scope, RBAC supports cluster-wide, namespace-specific, or resource-level policies.

### Key Concepts/Deep Dive
- **RBAC as IAM Alternative**:
  - Roles define permissions (what actions on which resources).
  - Bindings link subjects (users/groups/service accounts) to roles.
  - Enables cloud-agnostic control (works in AWS EKS, Azure AKS, etc.).
- **Why Failure-Closed Security**:
  - Default: Deny all requests. Explicit roles and bindings grant access.
- **Cloud Agnosticism**:
  - Use `kubectl` commands universally, unlike GCP-specific `gcloud`.
- **Resource Scope Validation**:
  - Check resources via CLI: `kubectl api-resources`.
  - Namespaced: Includes `Deployment`, `Service`, `Pod`, etc.
  - Cluster-scoped: `Namespace`, `Node`, `PersistentVolume`, etc.

### Code/Config Blocks
List cluster-scoped vs. namespaced resources:
```bash
kubectl api-resources --namespaced=false  # Cluster-scoped
kubectl api-resources --namespaced=true   # Namespaced
```

### Lab Demos
#### Exploring API Resources
1. Run `kubectl api-resources` to list all resources.
2. Filter for namespaced resources: Append `--namespaced=true`.
3. Example output: `Deployment` (namespaced), `Node` (cluster-scoped).

## RBAC Concepts: Subjects, Roles, and Bindings
### Overview
RBAC defines subjects (identities), roles (permissions), and bindings (associations). This section details each component, focusing on users, groups, service accounts, and role types.

### Key Concepts/Deep Dive
- **Subjects (Identities)**:
  - Users: External identities (e.g., Gmail).
  - Groups: Collections of users/groups via Google Groups for Workspaces.
  - Service Accounts: Kubernetes or Google Cloud service accounts for automated access.
- **Roles**:
  - Define actions (verbs) like `get`, `list`, `create`, `delete` on specific resources (e.g., `pods`, `deployments`).
  - Namespace-scoped: Apply within a specific namespace.
- **Cluster Roles**:
  - Similar to roles but cluster-wide (e.g., for nodes, namespaces).
  - No namespace field in the spec.
- **Role Bindings**:
  - Link subjects to namespaced roles.
- **Cluster Role Bindings**:
  - Link subjects to cluster roles (no namespace in binding).
- **Real-World Application**:
  - Use roles for per-namespace access (e.g., dev team in "dev" namespace).
  - Cluster roles for shared resources (e.g., viewing all nodes).

### Code/Config Blocks
Example Role:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: team-one
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```

Example Cluster Role:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: view-nodes
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "list"]
```

### Lab Demos
#### Creating a Namespace-Scoped Role
1. Create YAML for a role allowing pod read access in "team-one" namespace.
2. Apply: `kubectl apply -f role.yml`.
3. Verify: `kubectl describe role pod-reader -n team-one`.

## Demonstration: Creating Roles and Role Bindings
### Overview
This demo illustrates creating namespaced roles and bindings, enforcing fine-grained access (e.g., user can view pods but not delete them).

### Key Concepts/Deep Dive
- **Role Creation Process**:
  - Define resources, verbs, and namespace.
  - Bind to subjects (users/groups/service accounts).
- **Testing Access**:
  - Switch contexts or use `kubectl --as <user>` if authenticated.
  - Errors indicate insufficient permissions.
- **Enhancements**:
  - Expand rules for multiple resources (e.g., pods + deployments).
  - Use sub-resources (e.g., `pods/log` for logs).

### Code/Config Blocks
Pod Reader Role:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: team-one
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch", "delete"]
```

Role Binding:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: team-one
subjects:
- kind: User
  name: mahesh@gcp.com
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

### Lab Demos
#### Step-by-Step: Implementing Pod Access Control
1. Create namespaces "team-one" and "team-two".
2. Create a Deployment in "team-one".
3. Define and apply the `pod-reader` role.
4. Create and apply the role binding for a user.
5. Switch to the user and test: `kubectl get pods -n team-one` (works), `kubectl delete pod <name> -n team-one` (succeeds if delete verb included).
6. Verify namespace isolation: No access to default namespace.

**Possible Enhancements**:
- Add rules for logs: `resources: ["pods/log"]`.

## Cluster Roles and Cluster Role Bindings
### Overview
Cluster roles provide cluster-wide permissions (e.g., viewing all namespaces or nodes), used when access isn't limited to one namespace.

### Key Concepts/Deep Dive
- **Cluster Role Usage**:
  - For cluster-scoped resources (e.g., `nodes`, `namespaces`).
  - Bindings without namespaces.
- **Pre-Defined Cluster Roles**:
  - Many built-in (e.g., `cluster-admin`), modifiable.
- **Real-World Separation of Duties**:
  - Cluster admins manage infrastructure; developers deploy apps.
- **API Group Variations**:
  - Core: Empty `apiGroups` ("").
  - Others: e.g., `apps` for Deployments.

### Code/Config Blocks
Cluster Role for namespaces and nodes:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-viewer
rules:
- apiGroups: [""]
  resources: ["namespaces", "nodes"]
  verbs: ["get", "list"]
```

Cluster Role Binding:
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: view-cluster
subjects:
- kind: User
  name: mahesh@gcp.com
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-viewer
  apiGroup: rbac.authorization.k8s.io
```

### Lab Demos
#### Creating and Binding Cluster Roles
1. Define and apply `cluster-viewer` cluster role.
2. Create cluster role binding for users/groups/service accounts.
3. Test: User can `kubectl get namespaces`, but not modify them.
**Note**: Ensure full resource names (e.g., `nodes` not `noes`).

## Using Service Accounts in RBAC
### Overview
Kubernetes service accounts provide automated access, useful for CI/CD pipelines or workloads needing specific permissions.

### Key Concepts/Deep Dive
- **Service Account Types**:
  - Kubernetes: For pod-to-pod communication or cluster internal access.
  - Google Cloud: External, identifiably via unique ID.
- **Binding Service Accounts**:
  - Use unique ID in RBAC subjects.
  - Enable via `kubectl config`.
- **Limitations**:
  - No UI for RBAC; all via CLI/YAML.
- **VM Setup for Testing**:
  - Provision VM with service account, install `kubectl` if needed.

### Code/Config Blocks
Update Cluster Role Binding with Service Account:
```yaml
subjects:
- kind: User
  name: <service-account-unique-id>
  apiGroup: rbac.authorization.k8s.io
```

### Lab Demos
#### Setting Up Service Account Access
1. Create GCP service account, assign minimal IAM (e.g., `Kubernetes Engine Cluster Viewer`).
2. Bind to cluster role in RBAC.
3. Attach service account to a VM, SSH in, and run `gcloud container clusters get-credentials` (may fail without full IAM; consult docs).
4. Test: `kubectl get namespaces` (cluster-scoped success), but not pods (namespace-specific).

## Using Groups in RBAC
### Overview
Groups allow collective access management, ideal for teams. Requires Google Cloud Organization node and "Google Groups for RBAC" feature in GKE.

### Key Concepts/Deep Dive
- **Setup Requirements**:
  - Enable "Google Groups for RBAC" in GKE.
  - Create fixed group: `gke-security-groups@<domain>`.
  - Add sub-groups or users.
- **Group Permissions**:
  - Grant cluster-level roles via nested groups.
- **Alternative to Individual Users**:
  - Easier maintenance; add/remove group members.

### Code/Config Blocks
Enable Google Groups for RBAC (UI/console).

### Lab Demos
#### Configuring Group-Based Access
1. In GCP Organization, enable RBAC groups in GKE.
2. Create and populate group (e.g., `gke-security-groups@domain` with sub-groups).
3. Bind cluster role to the group.
**Note**: Propagation may take time; test with group members.

## Summary Section
### Key Takeaways
```diff
+ RBAC provides cloud-agnostic, fine-grained Kubernetes access control, unlike project-level Cloud IAM.
- Cloud IAM allows all-cluster access in a project, RBAC supports namespace/cluster/resource-specific restrictions.
! RBAC uses Kubernetes API (kubectl), while Cloud IAM uses GCP tools (gcloud).
+ Roles define permissions; bindings link subjects (users/groups/service accounts) to roles.
- Always verify case-sensitivity in subjects; use unique service account IDs.
```

### Expert Insight
**Real-world Application**: Use RBAC for multi-tenant clusters, granting team-specific namespaces (e.g., QA team in "qa" namespace). Combine with Cloud IAM for initial cluster access.

**Expert Path to Mastery**: 
- Study official RBAC docs and practice with multi-cluster setups.
- Earn CKA/CKAD certifications for in-depth knowledge.
- Experiment with sub-resources (e.g., `pods/log`) and custom roles using kube GPT or official resources.

**Common Pitfalls**: 
- Forgetting cluster-scoped changes (e.g., binding without namespace for cluster roles).
- Case-sensitive errors in user/group names leading to access failures.
- Misspelling resource names (e.g., "noes" instead of "nodes").

**Lesser Known Things**: 
- RBAC supports service accounts for workload identity without external IAM dependencies.
- Pre-defined cluster roles (e.g., `view`, `edit`) can be reused with bindings for quick setups.
- Groups enable hierarchical permissions, reducing manual user management in large organizations.

> [!IMPORTANT]  
> Corrected spelling errors from the transcript: "ript" to "transcript", "gk" to "GKE", "gkes" to "GKE", "cubectl" to "kubectl", "que" to "kube", "noes" to "nodes". These cuts ensure clarity and compliance with documentation standards. If additional corrections are needed, refer to official Kubernetes or GCP docs.
