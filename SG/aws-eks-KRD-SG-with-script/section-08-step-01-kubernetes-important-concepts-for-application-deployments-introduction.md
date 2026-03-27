<details open>
<summary><b>Section 8: Kubernetes Application Deployment Concepts (G3PCS46)</b></summary>

# Section 8: Kubernetes Application Deployment Concepts

## Table of Contents
- [8.1 Step-01- Kubernetes Important Concepts for Application Deployments - Introduction](#81-step-01--kubernetes-important-concepts-for-application-deployments---introduction)
- [8.2 Step-02- Kubernetes Secrets](#82-step-02--kubernetes-secrets)
- [8.3 Step-03- Kubernetes Init Containers](#83-step-03--kubernetes-init-containers)
- [8.4 Step-04- Kubernetes Liveness & Readiness Probes Introduction](#84-step-04--kubernetes-liveness--readiness-probes-introduction)
- [8.5 Step-05- Create Kubernetes Liveness & Readiness Probes](#85-step-05--create-kubernetes-liveness--readiness-probes)
- [8.6 Step-06- Kubernetes Resources - Requests & Limits](#86-step-06--kubernetes-resources---requests--limits)
- [8.7 Step-07- Kubernetes Namespaces - Introduction](#87-step-07--kubernetes-namespaces---introduction)
- [8.8 Step-08- Kubernetes Namespaces - Create Imperatively using kubectl](#88-step-08--kubernetes-namespaces---create-imperatively-using-kubectl)
- [8.9 Step-09- Kubernetes Namespaces - Limit Range - Introduction](#89-step-09--kubernetes-namespaces---limit-range---introduction)
- [8.10 Step-10- Kubernetes Namespaces - Create Limit Range k8s manifest](#810-step-10--kubernetes-namespaces---create-limit-range-k8s-manifest)
- [8.11 Step-11- Kubernetes Namespaces - Limit Range - Update App k8s Manifest, Deploy](#811-step-11--kubernetes-namespaces---limit-range---update-app-k8s-manifest-deploy)
- [8.12 Step-12- Kubernetes - Resource Quota](#812-step-12--kubernetes---resource-quota)

## 8.1 Step-01- Kubernetes Important Concepts for Application Deployments - Introduction

### Overview
This section introduces essential Kubernetes concepts required for deploying applications on clusters, building upon previous MySQL and persistent storage implementations. It covers Secrets, initialization containers, liveness and readiness probes, resource requests and limits, and namespaces to effectively manage and secure application deployments.

### Key Concepts/Deep Dive

- **Secrets**: Used to store sensitive information like database passwords in Base64-encoded format securely instead of plain text manifests.
- **Initialization Containers**: Run before app containers to ensure dependencies like database startup are completed.
- **Liveness and Readiness Probes**: Liveness probes restart containers if unresponsive; readiness probes ensure containers are ready for traffic routing.
- **Requests and Limits**: Define CPU and memory resource allocation for containers to optimize scheduling and prevent overuse.
- **Namespaces**: Provide isolation for environments (e.g., dev, QA, staging), allowing multiple teams/resources allocation.

These concepts help in deploying scalable, secure, and reliable applications on Kubernetes.

> [!NOTE]
> Initialization containers solve issues where apps start before databases are ready.

```yaml
# Example Secret manifest structure
apiVersion: v1
kind: Secret
metadata:
  name: mysql-db-password
type: Opaque
data:
  password: <base64-encoded-password>
```

## 8.2 Step-02- Kubernetes Secrets

### Overview
Kubernetes Secrets securely manage sensitive data like passwords, tokens, or keys in Base64-encoded formats, replacing plain text in deployment manifests for MySQL root passwords and application database passwords.

### Key Concepts/Deep Dive

- **Purpose**: Safely store confidential info without exposing it in code.
- **Creation**: Use Base64 encoding for data; type "Opaque" for unstructured key-value pairs.
- **Integration**: Reference secrets in deployments via `valueFrom.secretKeyRef`.
- **Testing**: Apply manifests, verify logs for connectivity (e.g., health endpoints).

Steps for implementation:
1. Encode password: `echo -n 'db-password-123' | base64`
2. Create Secret YAML with encoded data.
3. Update deployments to use `secretKeyRef`.
4. Deploy and test application functionality.

> [!IMPORTANT]
> Secrets are not encrypted by default; consider additional security measures for production.

## 8.3 Step-03- Kubernetes Init Containers

### Overview
Init containers execute sequentially before app containers in a pod, useful for setup tasks like database readiness checks, ensuring apps only start after prerequisites are met.

### Key Concepts/Deep Dive

- **Execution Order**: Init containers must complete successfully before app containers run; failures affect pod status.
- **Use Cases**: Database connectivity checks, data seeding, tool installations.
- **Implementation**: Add `initContainers` array to pod spec, using lightweight images like BusyBox for commands (e.g., `nc -z mysql 3306`).

Lab Demo Steps:
1. Add init container to user management deployment YAML.
2. Define command for database readiness check.
3. Deploy and monitor pods; observe delayed app startup until init container succeeds.

Output shows successful init container execution before app start.

```yaml
initContainers:
- name: init-db
  image: busybox
  command: ['sh', '-c', 'until nc -z mysql 3306; do echo waiting for db; sleep 2; done;']
```

> [!NOTE]
> Init containers use pod resources and log via `kubectl logs -c <init-container-name>`.

## 8.4 Step-04- Kubernetes Liveness & Readiness Probes Introduction

### Overview
Probes monitor container health: liveness restarts failing containers, readiness controls traffic routing. Options include commands, HTTP GET, or TCP socket checks, applied per container strategy.

### Key Concepts/Deep Dive

- **Liveness Probe**: Detects app failures (e.g., deadlocks) and restarts container; checks startup issues.
- **Readiness Probe**: Ensures container is ready for traffic before load balancer inclusion.
- **Startup Probe**: Delays probes until app initializes, especially for slow-starting apps.
- **Configuration Options**: Add initial/period delays; success/failure thresholds.

```diff
+ Readiness Probe: Ensures app readiness for traffic routing.
- Liveness Probe Failure: Container restarts if unresponsive.
```

## 8.5 Step-05- Create Kubernetes Liveness & Readiness Probes

### Overview
Implement liveness (command-based) and readiness (HTTP GET) probes with delays in user management deployment, ensuring pods stabilize before marking ready.

### Key Concepts/Deep Dive

- **Delay Settings**: 60s initial delay for stabilization; periodic checks every 10s.
- **Probe Commands**: Liveness uses `nc -z localhost 8095`; readiness uses HTTP GET on health endpoint.
- **Pod Status**: Transitions from initializing to ready after readiness probe success.

Lab Demo Steps:
1. Add probe configurations to container spec.
2. Deploy; observe 60s wait before readiness.
3. Verify pod status and health endpoint access.

> [!IMPORTANT]
> Delays prevent premature failures; tune based on app startup time.

```yaml
livenessProbe:
  exec:
    command: ["/bin/sh", "-c", "nc -z localhost 8095"]
  initialDelaySeconds: 60
  periodSeconds: 10
readinessProbe:
  httpGet:
    path: /usermgmt/health-status
    port: 8095
  initialDelaySeconds: 60
  periodSeconds: 10
```

## 8.6 Step-06- Kubernetes Resources - Requests & Limits

### Overview
Define CPU/memory requests (guaranteed allocation) and limits (maximum usage) to optimize pod scheduling and prevent resource exhaustion on clusters.

### Key Concepts/Deep Dive

- **Requests**: Scheduler guarantees these resources per node.
- **Limits**: Kubelet enforces no exceedance; pods may be killed/throttled.
- **Examples**: 500m CPU (0.5 core), 256Mi memory requests; 1 CPU, 500Mi limits.
- **Monitoring**: Use `kubectl describe node` to check resource allocation percentages.

| Resource Type | Requests | Limits | Notes |
|---------------|----------|--------|-------|
| CPU          | 500m     | 1000m | Milli-CPU units |
| Memory       | 256Mi    | 500Mi | Mega/bytes |

Lab Demo Steps:
1. Add resources to container spec.
2. Deploy and check node resource usage.
3. Remove for demonstration; verify cluster sustainment.

> [!WARNING]
> Misconfigured limits can lead to pod eviction or cluster instability.

```yaml
resources:
  requests:
    cpu: "500m"
    memory: "256Mi"
  limits:
    cpu: "1000m"
    memory: "500Mi"
```

## 8.7 Step-07- Kubernetes Namespaces - Introduction

### Overview
Namespaces provide virtual clusters for isolation, enabling multi-team environments with resource quotas and object separation, avoiding conflicts in default namespace.

### Key Concepts/Deep Dive

- **Isolation Boundaries**: Objects in one namespace isolated from others.
- **Benefits**: Organize projects/teams; enforce resource limits via quotas.
- **Default Namespaces**: kube-system (system objects), kube-public (public access), default (implicit).
- **Creation**: Imperative (`kubectl create ns dev`) or declarative YAML.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: dev
```

> [!NOTE]
> Use namespaces from project start for better organization.

## 8.8 Step-08- Kubernetes Namespaces - Create Imperatively using kubectl

### Overview
Create namespaces imperatively for multi-environment deployments, deploying identical manifests to isolated spaces like dev1 and dev2.

### Key Concepts/Deep Dive

- **Imperative Creation**: `kubectl create ns <name>` for quick setup.
- **Deployment Targeting**: Use `-n <namespace>` with `kubectl apply -f`.
- **Object Scoping**: Namespace-scoped (PVCs, pods) vs. cluster-scoped (storage classes).
- **Cleanup**: Delete entire namespaces with `kubectl delete ns`; manually remove cluster-scoped objects.

Lab Demo Steps:
1. Create dev1 and dev2 namespaces.
2. Deploy app manifests to each via `-n dev1`.
3. Verify isolation; test endpoints (dynamic node ports).
4. Cleanup with `kubectl delete ns`.

> [!IMPORTANT]
> Cluster-scoped resources persist namespace deletions.

## 8.9 Step-09- Kubernetes Namespaces - Limit Range - Introduction

### Overview
Limit ranges enforce default CPU/memory requests/limits per namespace, automating resource controls without individual deployment edits.

### Key Concepts/Deep Dive

- **Default Resources**: Apply to all containers; overrides individual specs.
- **Manifest Structure**: Define default and defaultRequest under limits.
- **Association**: Per-container limits via type: Container.

Example: 512Mi CPU limit, 256Mi request per container in namespace.

```yaml
spec:
  limits:
  - default:
      cpu: "500m"
      memory: "512Mi"
    defaultRequest:
      cpu: "300m"
      memory: "256Mi"
    type: Container
```

> [!NOTE]
> Simplifies resource management for multi-app namespaces.

## 8.10 Step-10- Kubernetes Namespaces - Create Limit Range k8s manifest

### Overview
Create declarative manifests for namespaces and limit ranges, ensuring order with 00 prefix for namespace creation before limit range application.

### Key Concepts/Deep Dive

- **Manifest Ordering**: Prefix for deployment sequence (namespace first).
- **Limit Range Spec**: Hard-set defaults; applies to containers implicitly.

Lab Demo Steps:
1. Write namespace and limit range YAMLs.
2. Deploy; verify resources via `kubectl describe pod`.
3. Update configs with namespace references.

```yaml
# Limit Range Manifest
apiVersion: v1
kind: LimitRange
metadata:
  name: default-cpu-mem-limit-range
  namespace: dev3
spec:
  limits:
  - default:
      cpu: "500m"
      memory: "512Mi"
    defaultRequest:
      cpu: "300m"
      memory: "256Mi"
    type: Container
```

## 8.11 Step-11- Kubernetes Namespaces - Limit Range - Update App k8s Manifest, Deploy

### Overview
Update manifests for namespace dev3, deploy, and test limit range enforcement on CPU/memory defaults for all containers.

### Key Concepts/Deep Dive

- **Deployment Command**: `kubectl apply -f kube-manifest` (with hardcoded namespaces).
- **Verification**: Check pod YAML for auto-added resource specs.
- **Resource Quot**: 1 vCPU default; 512Mi memory if unspec'd.

Lab Demo Steps:
1. Update all object metadata with `namespace: dev3`.
2. Deploy; monitor pods.
3. Describe quota and pods for resource details.

> [!NOTE]
> Limit range enforces per-container limits cluster-wide.

## 8.12 Step-12- Kubernetes - Resource Quota

### Overview
Resource quotas limit totals per namespace (e.g., max pods, CPU/Memory), preventing over-allocation and ensuring fair resource sharing.

### Key Concepts/Deep Dive

- **Hard Limits**: Enforce ceilings on namespace resources.
- ** scopable Items**: Pods, services, PVCs, CPU/Memory.
- ** monitoring**: Use `kubectl describe quota` for usage vs. hard limits.

Example Hard Limits:
- pods: 5
- cpu: "2"
- memory: "2Gi"

Lab Demo Steps:
1. Add resource quota to namespace YAML.
2. Deploy; check usage.
3. Verify enforcement (e.g., pod scaling blocked).

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: ns-resource-quota
  namespace: dev3
spec:
  hard:
    requests.cpu: "2000m"
    requests.memory: "4Gi"
    limits.cpu: "2"
    limits.memory: "2Gi"
    pods: "5"
```

> [!WARNING]
> Exceeding quotas prevents new object creation.

## Summary

```diff
+ Secrets ensure secure handling of sensitive app data like passwords.
- Initialization containers prevent apps from starting before dependencies (e.g., DB) are ready.
! Liveness/readiness probes manage container health and traffic eligibility.
+ Namespaces enable isolated environments with resource controls via limit ranges and quotas.
```

### Quick Reference
- **Create Secret**: `echo -n 'password' | base64`
- **Apply Probes**: Add lagivenessProbe or responsivenessProbe to container spec.
- **Request Limits**: Set CPU (e.g., "500m") and memory (e.g., "256Mi") under resources.
- **Namespace Deployment**: `kubectl apply -f manifest.yaml -n dev`
- **Limit Range Defaults**: Auto-apply CPU/memory defaults per container.

### Expert Insight

**Real-world Application**: Use secrets for production databases on cloud Kubernetes; combine init containers with external services like RDS for scalable apps.

**Expert Path**: Master probes by integrating with app health endpoints for zero-downtime deployments; practice resource tuning with metrics from `kubectl top`.

**Common Pitfalls**: Forgetting namespace in manifests causes cluster pollution; setting low limits causes pod evictions; typos like "cubectl" (correct: "kubectl") in commands lead to errors.

</details>
