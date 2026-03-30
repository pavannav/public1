# Session 32: Kubernetes Service Account, Annotations, Workload Identity Federation

- [Groups in RBAC](#groups-in-rbac)
- [Kubernetes Service Accounts](#kubernetes-service-accounts)
- [Annotations](#annotations)
- [Workload Identity Federation](#workload-identity-federation)

## Groups in RBAC

### Overview
RBAC (Role-Based Access Control) in Kubernetes handles permissions for users and service accounts. In Google Cloud, integration with Google Groups allows managing access at a group level rather than individual users, promoting better security and management through nested groups in Google Groups for the GKE security group.

### Key Concepts
- **Google Groups in GKE**: A GKE cluster can be configured to enable Google Groups authentication. Creating a security group in Google Workspace allows managing Kubernetes RBAC through Google Groups memberships.
- **Nested Groups**: Google Groups support nested structures, enabling hierarchical permission management. Members can include users and other groups.
- **Limitations**: Up to 2,000 groups can be supported per user membership, including nested hierarchies.
- **RBAC Priority**: Kubernetes RBAC policies take precedence over IAM permissions when evaluating access.

> [!IMPORTANT]  
> In RBAC authorization, GKE checks RBAC policies first. If no RBAC match exists, it then checks Google Cloud IAM permissions.

> [!NOTE]  
> Avoid adding individual users directly to the GKE security group for ad-hoc testing, as this is against best practices.

### Common Scenarios
- Use groups for scalable user management in large teams.
- Implement nested groups to organize permissions by department or role.
- Restrict individual user additions to the security group; prefer nested group memberships.

```diff
+ Positive: Use nested Google Groups for granular RBAC control.
- Negative: Adding service accounts to groups can lead to over-permissive access.
```

### Lab Demos
N/A (Continued discussion on existing configurations).

### Key Takeaways
```diff
+ RBAC prioritizes local Kubernetes permissions over global IAM.
+ Leverage Google Groups for user management to avoid individual privilege assignments.
+ Nested groups enhance scalability.
```

### Expert Insight
#### Real-world Application
In production, integrate with Google Workspace to synchronize user group memberships with Kubernetes roles, ensuring seamless access management without manual configurations.

#### Expert Path
Master integrating external identity providers like Active Directory with GKE for advanced RBAC scenarios. Understand RBAC vs. IAM trade-offs deeply.

#### Common Pitfalls
- Granting excessive permissions via nested groups without audits.
- Ignoring RBAC precedence, leading to unexpected permission grants.
- Not documenting group responsibilities, causing confusion during changes.

Common issues with resolution:
- Users unable to access cluster: Verify Google Groups membership and RBAC bindings.
- Propagation delays: Allow up to 15 minutes for group changes to reflect in GKE.
- Exceeding group limits: Use fewer nested groups or consolidate permissions.

## Kubernetes Service Accounts

### Overview
Kubernetes Service Accounts (KSAs) are identities used by pods to authenticate with the Kubernetes API server. Unlike user accounts, KSAs are managed within namespaces and automatically created per namespace (with a default "default" account).

### Key Concepts
- **Namespace Isolation**: Each namespace gets its own default service account. Explicitly create additional accounts for specific workloads.
- **API Resources**: Interact with Kubernetes resources using verbs like "get", "list", "create" via RBAC roles.
- **Default Behavior**: Pods use the default service account unless specified otherwise in the pod spec.
- **Token Management**: KSAs handle token generation for secured pod API communications.

### Code/Config Blocks
Create a Kubernetes Service Account:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-service-account
  namespace: example-namespace
```

Associate with a Pod:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  serviceAccountName: my-service-account
  containers:
  - name: app
    image: nginx
```

### Key Takeaways
```diff
+ Use KSAs for pod-level identity and API access.
- Avoid relying solely on default accounts to minimize permission creep.
```

### Expert Insight
#### Real-world Application
Assign specific KSAs to microservices in CI/CD pipelines to enforce least-privilege principles, ensuring pods only access necessary resources.

#### Expert Path
Dive into OIDC-based authentication with external IDPs for advanced scenarios and secure cross-cluster communication.

#### Common Pitfalls
- Forgetting to bind RBAC roles to custom KSAs, resulting in pods lacking API access.
- Overusing default accounts, exposing unnecessary permissions.

Common issues with resolution:
- "Default service account cannot access resources": Bind appropriate RBAC roles or create custom KSAs.
- Token expiry issues: Automate token rotation via RBAC or use short-lived tokens.

## Annotations

### Overview
Annotations in Kubernetes add arbitrary metadata to resources (e.g., pods, services) for tracking, configuration, or external tool integration. Unlike labels (used for selectors), annotations store non-identifying data.

### Key Concepts
- **Key-Value Pairs**: Support strings, with integers/floats requiring double quotes.
- **Use Cases**: Track ownership, enable features (e.g.,via Google-defined annotations), or store configuration details.
- **Immutability**: Non-functional; doesn't affect resource behavior directly but can influence controllers.

### Code/Config Blocks
Add annotations to a deployment:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
  annotations:
    developer: "mahesh@example.com"
    version: "1.0"
spec:
  # deployment spec
```

Update annotations:
```bash
kubectl annotate deployment my-deployment developer="kumar@example.com"
```

### Key Takeaways
```diff
+ Annotations enhance resource metadata for tracking and configuration.
- Avoid using annotations for selectors; prefer labels.
```

### Expert Insight
#### Real-world Application
In production, use annotations for integration with monitoring tools (e.g., Prometheus) or Google Cloud features like specifying static IPs in Ingress via `compute.googleapis.com/region: us-central1`.

#### Expert Path
Explore admission controllers to enforce annotation policies and automate metadata management.

#### Common Pitfalls
- Misplacing annotations outside metadata or using incorrect YAML syntax.
- Confusing annotations with labels, leading to failed selections.

Common issues with resolution:
- Annotation not appearing: Ensure valid YAML structure and proper Helmholtz.
- Updates not reflecting: Annotations are mutable; restart affected controllers if needed.

## Workload Identity Federation

### Overview
Workload Identity Federation enables secure access from Kubernetes pods to Google Cloud APIs without service account keys. It maps Kubernetes Service Accounts (KSAs) to Google Cloud Service Accounts (GSAs), allowing pod processes to authenticate seamlessly.

### Key Concepts
- **Workload Identity Pool**: Created automatically in GKE clusters enabling it, using format `PROJECT_ID.svc.id.goog`.
- **Federation Process**: KSA impersonates GSA via RBAC and IAM policies, bypassing key-based authentication.
- **Node Pool Requirements**: Workload Identity must be enabled on node pools for proper functionality.

### Code/Config Blocks
Enable Workload Identity in an existing cluster:
```bash
gcloud beta container clusters update CLUSTER_NAME --enable-workload-identity
```

Create a KSA:
```bash
kubectl create serviceaccount ksa-name -n namespace-name
```

Grant IAM role to KSA:
```bash
gcloud iam service-accounts add-iam-policy-binding GSA_EMAIL \
  --role roles/storage.admin \
  --member "principal://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/PROJECT_ID.svc.id.goog/subject/ns/NAMESPACE_NAME/ksa/KSA_NAME"
```

Associate in Pod Spec:
```yaml
spec:
  serviceAccountName: ksa-name
```

### Lab Demos
1. Enable Workload Identity on cluster and node pools.
2. Create namespace and KSA.
3. Grant IAM roles for specific resources (e.g., GCS bucket access).
4. Deploy pod with associated KSA and verify access via `gsutil ls`.

### Tables

| Approach | Steps | Limitations | Recommended For |
|----------|-------|-------------|-----------------|
| Old (with annotation) | Annotate KSA, create GSA, bind IAM, deploy pod | Complexity, limited services | Legacy systems |
| New | Create namespace/ KSA, bind IAM directly, deploy pod | None | Modern GKE workloads |

### Key Takeaways
```diff
+ Eliminates service account keys for secure, keyless authentication.
- Requires careful IAM role scoping to avoid over-permissions.
```

### Expert Insight
#### Real-world Application
Use for event-driven applications (e.g., Cloud Functions triggering GCS uploads via pods) to maintain security boundaries without credential management.

#### Expert Path
Integrate with Anthos for multi-cluster federation and advanced authentication flows using external IDPs.

#### Common Pitfalls
- Forgetting to update node pools, leading to authentication failures.
- Broad IAM roles exposing unnecessary access (e.g., project-level vs. resource-level grants).
- Misconfiguration of workload identity pool subjects.

Common issues with resolution:
- Pod cannot access GCS: Verify KSA-to-GSA binding and node pool enablement.
- Permission denied on specific resources: Scope IAM to resources, not projects.
- Annotation mismatches: Prefer direct IAM bindings over legacy annotations.
