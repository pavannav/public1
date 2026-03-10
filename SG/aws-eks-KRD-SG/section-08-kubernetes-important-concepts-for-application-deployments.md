# Section 08: Kubernetes Important Concepts for Application Deployments

<details open>
<summary><b>Section 08: Kubernetes Important Concepts for Application Deployments (Claude Code)</b></summary>

## Table of Contents

- [8.1 Step-01- Kubernetes Important Concepts for Application Deployments -Introduction](#81-step-01--kubernetes-important-concepts-for-application-deployments--introduction)
- [8.2 Step-02- Kubernetes Secrets](#82-step-02--kubernetes-secrets)
- [8.3 Step-03- Kubernetes Init Containers](#83-step-03--kubernetes-init-containers)
- [8.4 Step-04- Kubernetes Liveness & Readiness Probes Introduction](#84-step-04--kubernetes-liveness--readiness-probes-introduction)
- [8.5 Step-05- Create Kubernetes Liveness & Readiness Probes](#85-step-05--create-kubernetes-liveness--readiness-probes)
- [8.6 Step-06- Kubernetes Resources - Requests & Limits](#86-step-06--kubernetes-resources---requests--limits)
- [8.7 Step-07- Kubernetes Namespaces - Introduction](#87-step-07--kubernetes-namespaces---introduction)
- [8.8 Step-08- Kubernetes Namespaces -  Create Imperatively using kubectl](#88-step-08--kubernetes-namespaces---create-imperatively-using-kubectl)
- [8.9 Step-09- Kubernetes Namespaces - Limit Range - Introduction](#89-step-09--kubernetes-namespaces---limit-range---introduction)
- [8.10 Step-10- Kubernetes Namespaces - Create Limit Range k8s manifest](#810-step-10--kubernetes-namespaces---create-limit-range-k8s-manifest)
- [8.11 Step-11- Kubernetes Namespaces - Limit Range - Update App k8s Manifest, Deploy](#811-step-11--kubernetes-namespaces---limit-range---update-app-k8s-manifest-deploy)
- [8.12 Step-12- Kubernetes - Resource Quota](#812-step-12--kubernetes---resource-quota)

## 8.1 Step-01- Kubernetes Important Concepts for Application Deployments -Introduction

### Overview

Section 8 focuses on enterprise-ready Kubernetes concepts that enhance application reliability, security, and resource management for production deployments.

### Key Concepts

This section covers five major production readiness concepts:

1. **Kubernetes Secrets**: Secure management of sensitive configuration data
2. **Init Containers**: Sequential dependency management within pods
3. **Liveness & Readiness Probes**: Application health monitoring and traffic routing
4. **Requests & Limits**: Resource allocation and enforcement
5. **Namespaces**: Multi-tenancy, resource quotas, and environments isolation

### Why These Concepts Matter

These concepts solve real-world production challenges:
- Services failing because of startup order
- Exposing secrets in manifests
- Applications receiving traffic while unhealthy
- Resource starvation or hoarding
- Lack of environment isolation

## 8.2 Step-02- Kubernetes Secrets

### Overview

Kubernetes Secrets provide secure storage for sensitive data like passwords, tokens, and API keys, encoded in Base64 format and stored etcd.

### Key Concepts

**Secret Types:**
- **Opaque**: Unstructured key-value pairs (most common for configuration)
- **ssl/tls**: Certificates for TLS termination
- **docker-registry**: Docker authentication credentials

### Code/Config Blocks

```yaml
# Create Secret
apiVersion: v1
kind: Secret
metadata:
  name: mysql-db-password
type: Opaque
data:
  db_password: REJQQXNzdzExIA==   # Base64 encoded "dbpass11"

---
# Use Secret in Deployment
env:
- name: MYSQL_ROOT_PASSWORD
  valueFrom:
    secretKeyRef:
      name: mysql-db-password
      key: db_password

- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: mysql-db-password
      key: db_password
```

### Commands

```bash
# Create Base64 encoded password
echo -n "dbpass11" | base64
# REJQQXNzdzExIA==

# Apply and verify
kubectl apply -f kube-manifests/
kubectl get secrets
```

### Expert Insight

> [!IMPORTANT]
> Secrets are only Base64 encoded, not encrypted! Use Kubernetes secrets for security by obscurity only. For true security, use external secret management like AWS Secrets Manager or HashiCorp Vault.

**Best Practices:**
- Reference secrets by name/key, not hardcode values
- Use separate secrets per application/environment
- Rotate secrets regularly
- Never commit actual secret values to source control

## 8.3 Step-03- Kubernetes Init Containers

### Overview

Init containers execute sequentially before main application containers start, ensuring proper startup ordering and prerequisite setup.

### Key Concepts

**Init Container Characteristics:**
- **Sequential Execution**: Each init container must complete before next starts
- **Failure Behavior**: Pod restarts if init container fails (unless restartPolicy: Never)
- **Same Pod Environment**: Share volumes and network with main containers
- **Resource Constraints**: Affected by same resource limits as main containers

**Common Use Cases:**
- Database connectivity verification before starting application
- Schema migrations or seed data initialization
- Configuration file generation
- Certificate download/validation
- Volume preparation/mounting

### Code/Config Blocks

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: usermgmt-microservice
spec:
  template:
    spec:
      initContainers:
      - name: init-db
        image: busybox
        command: ['sh', '-c', 'until nc -z mysql 3306; do echo "Waiting for MySQL"; sleep 2; done; echo "MySQL DB server has started"']
      containers:
      - name: usermgmt-rest-app
        image: stacksimplify/kube-usermgmt:v1
        # Main application container
```

### Key Takeaways

```diff
+ Init containers prevent service disruption from wrong startup order
+ Each init container must exit successfully for app to start
+ NetCat or curl commands commonly used for connectivity checks
+ Init containers share pod lifecycle and volumes
- Never use for long-running background processes
```

### Lab Demos

**Init Container Verification:**
```bash
kubectl describe pod usermgmt-microservice-xxxxx
# Shows init container execution sequence
# Events:
# - Init container init-db started
# - Init container init-db completed
# - Container usermgmt-rest-app started
```

## 8.4 Step-04- Kubernetes Liveness & Readiness Probes Introduction

### Overview

Health probes determine pod health status and control traffic routing. Liveness probes restart unhealthy pods; readiness probes control service endpoint inclusion.

### Key Concepts

**Liveness Probe:**
- **Purpose**: Detects application failures and restarts pods
- **Trigger**: Container enters unhealthy state
- **Action**: Kills and recreates pod
- **Use Case**: Application hangs, returns errors, or becomes unresponsive

**Readiness Probe:**
- **Purpose**: Ensures application can accept traffic
- **Trigger**: Application isn't ready to serve requests
- **Action**: Removes pod from service endpoints
- **Use Case**: Startup delays, incomplete initialization

### Table: Probe Configuration Options

| Property | Description | Examples |
|----------|-------------|----------|
| `initialDelaySeconds` | Wait before first probe | 30, 60 |
| `periodSeconds` | Probe frequency | 10, 30 |
| `timeoutSeconds` | Probe timeout | 1, 5 |
| `successThreshold` | Consecutive successes needed | 1, 2 |
| `failureThreshold` | Consecutive failures needed | 3, 5 |

## 8.5 Step-05- Create Kubernetes Liveness & Readiness Probes

### Overview

Implementation of HTTP-based health checks for application containers to ensure proper startup and continuous operation.

### Key Concepts

**HTTP Probe Configuration:**
- **Readiness**: `/usermgmt/health-status` endpoint
- **Liveness**: `/usermgmt/health-status` endpoint
- **Initial Delay**: Allows startup time
- **Period**: Regular health checking interval

### Code/Config Blocks

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: usermgmt-microservice
spec:
  template:
    spec:
      containers:
      - name: usermgmt-rest-app
        image: stacksimplify/kube-usermgmt:v1
        ports:
        - containerPort: 8095
        readinessProbe:
          httpGet:
            path: /usermgmt/health-status
            port: 8095
          initialDelaySeconds: 5
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        livenessProbe:
          httpGet:
            path: /usermgmt/health-status
            port: 8095
          initialDelaySeconds: 30
          periodSeconds: 30
          timeoutSeconds: 5
          failureThreshold: 3
```

### Commands

```bash
# Check probe configuration
kubectl describe pod usermgmt-microservice-xxxxx

# View probe status
kubectl get pod -l app=usermgmt

# Check probe failure logs
kubectl logs usermgmt-microservice-xxxxx --previous
```

### Lab Demos

**Probe Health Status:**
```bash
kubectl describe pod usermgmt-microservice-xxxxx | grep -A 10 "Readiness Probe"
kubectl describe pod usermgmt-microservice-xxxxx | grep -A 10 "Liveness Probe"
```

Status output shows:
- **Ready**: True/False
- **Reason**: Readiness probe failed/Liveness probe succeeded

## 8.6 Step-06- Kubernetes Resources - Requests & Limits

### Overview

Resource requests (guaranteed allocation) and limits (maximum consumption) ensure fair resource distribution and prevent cluster starvation.

### Key Concepts

**Resource Types:**
- **CPU**: Measured in cores (500m = 0.5 cores) or units
- **Memory**: Measured in bytes (1Gi, 512Mi) or decimals

**Resource Guarantees:**
- **Requests**: Minimum resources pod receives (scheduler consideration)
- **Limits**: Maximum resources pod can consume (throttling/overkill)

**QoS Classes:**
- **Guaranteed**: requests = limits (highest priority)
- **Burstable**: requests < limits (medium priority)
- **BestEffort**: no requests/limits (lowest priority)

### Code/Config Blocks

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: usermgmt-microservice
spec:
  template:
    spec:
      containers:
      - name: usermgmt-rest-app
        image: stacksimplify/kube-usermgmt:v1
        resources:
          requests:
            memory: "256Mi"
            cpu: "200m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        ports:
        - containerPort: 8095
```

### Common Pitfalls

```diff
- Exceeding node capacity with limits > available resources
- Not setting requests causing improper scheduling
- Setting requests = limits unnecessarily
- Forget to reserve resources for system daemons
```

### Expert Insight

**Production Sizing Strategy:**
- **CPU**: Measure application peaks, add 20-30% overhead
- **Memory**: Monitor heap dumps, account for JVM overhead
- **Limits**: Set 150% of typical load for bursts
- **Monitoring**: Use metrics to adjust based on actual usage

## 8.7 Step-07- Kubernetes Namespaces - Introduction

### Overview

Namespaces provide logical separation of Kubernetes resources, enabling multi-tenancy, resource partitioning, and environment isolation.

### Key Concepts

**Namespace Benefits:**
- **Multi-tenancy**: Multiple teams/projects use same cluster
- **Environment Isolation**: dev/staging/prod in same cluster
- **Resource Partitioning**: CPU/memory quotas per environment
- **Security**: Policy boundaries between namespaces

**Namespace Scope:**
- **Namespaced Objects**: Deployments, Services, ConfigMaps (most objects)
- **Cluster-wide Objects**: PersistentVolumes, StorageClasses, Nodes

### Understanding Scope

```bash
# Check current namespace
kubectl get ns

# Set namespace context
kubectl config set-context --current --namespace=development

# List objects in specific namespace
kubectl get pods -n production
```

## 8.8 Step-08- Kubernetes Namespaces -  Create Imperatively using kubectl

### Overview

Imperative namespace creation enables on-the-fly environment setup and multi-environment deployments with single manifest sets.

### Key Concepts

**Imperative vs Declarative:**
- **Imperative**: Direct commands, immediate effect
- **Declarative**: YAML manifests, version controlled

### Commands

```bash
# Create namespaces
kubectl create namespace dev-one
kubectl create namespace dev-two

# Deploy to specific namespace
kubectl apply -f kube-manifests/ -n dev-one

# View namespace-specific objects
kubectl get all -n dev-one
kubectl get all -n dev-two

# Clean up
kubectl delete ns dev-one dev-two
```

### Key Takeaways

- Declarative approach preferred for production
- Namespaced objects (PVC, ConfigMap, Deployment) created within specified namespace
- Cluster objects (StorageClass, PersistentVolume) remain global
- NodePort services require unique ports across namespaces

## 8.9 Step-09- Kubernetes Namespaces - Limit Range - Introduction

### Overview

LimitRange enforces default resource constraints per namespace, ensures all pods meet minimum resource requirements.

### Key Concepts

**LimitRange Features:**
- **Default Requests**: Minimum guaranteed resources
- **Default Limits**: Maximum resource consumption
- **Container Scoping**: Applies to all containers in namespace
- **Validation**: Kubernetes validates pod specs against limits

### Important Behavior

- **Missing Requests**: Uses defaultRequest values
- **Missing Limits**: Applies defaultLimit values
- **Too Low Requests**: Pod creation rejected
- **Exceeds Limits**: Pod scheduled but may be throttled/terminated

## 8.10 Step-10- Kubernetes Namespaces - Create Limit Range k8s manifest

### Overview

Creating declarative limit ranges with namespace and resource constraints, applied automatically to all pods in the namespace.

### Key Concepts

**Limit Range Configuration:**
- **Apply to Container Type**: Default container behavior
- **CPU Grenade**: Maximum/Moderate resource allocation
- **Memory Allocation**: Balanced for application needs

### Code/Config Blocks

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: dev3

---
apiVersion: v1
kind: LimitRange
metadata:
  name: default-cpu-mem-limit-range
  namespace: dev3
spec:
  limits:
  - default:
      cpu: 500m
      memory: 512Mi
    defaultRequest:
      cpu: 300m
      memory: 256Mi
    type: Container
```

### Commands

```bash
# Apply namespace and limit range
kubectl apply -f 00-namespace-limitrange.yml

# Deploy application with resource enforcement
kubectl apply -f kube-manifests/ -n dev3

# Check resource allocation
kubectl get pods -n dev3 -o yaml | grep -A 10 resources
```

## 8.11 Step-11- Kubernetes Namespaces - Limit Range - Update App k8s Manifest, Deploy

### Overview

Updating all application manifests to specify the target namespace and demonstrating deployment with enforced resource limits.

### Key Concepts

**Namespace Updates:**
- **Metadata Addition**: Add `namespace: dev3` to all manifests
- **Resource Enforcement**: LimitRange auto-applies constraints
- **Application Readiness**: All services accessible in namespace

### Commands

```bash
# Update all manifests with namespace
echo "namespace: dev3" >> metadata section for each manifest

# Deploy entire application
kubectl apply -f kube-manifests/

# Verify resource allocation
kubectl get pods -n dev3 --show-limits=true
```

### Lab Demos

**Limit Range Verification:**
```bash
kubectl get limitranges -n dev3
kubectl describe limitrange default-cpu-mem-limit-range -n dev3

# Check applied resources on pods
kubectl describe pod mysql-xxxxx -n dev3 | grep -A 10 CPU
kubectl describe pod usermgmt-microservice-xxxxx -n dev3 | grep -A 10 MEMORY
```

## 8.12 Step-12- Kubernetes - Resource Quota

### Overview

ResourceQuota restricts total resource consumption per namespace, preventing resource monopolization and ensuring fair cluster usage.

### Key Concepts

**ResourceQuota Coverage:**
- **Compute Resources**: CPU, memory limits and requests
- **Object Count Limits**: Deployments, services, etc.
- **Storage Resources**: PVC claims, persistent volumes
- **Enforcement Level**: Namespace-wide totals, not per-pod

### Code/Config Blocks

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: namespace-quota
  namespace: dev3
spec:
  hard:
    requests.cpu: "2000m"
    requests.memory: "2Gi"
    limits.cpu: "4000m"
    limits.memory: "4Gi"
    persistentvolumeclaims: "10"
    pods: "20"
    services: "5"
```

### Commands

```bash
# Create ResourceQuota
kubectl apply -f resource-quota.yml

# Check quota status
kubectl describe resourcequota namespace-quota -n dev3

# Attempt to exceed quota (will fail)
kubectl apply -f too-many-pods.yml  # ResourceQuota exceeded error
```

### Expert Insight

**ResourceQuota vs LimitRange:**
- **LimitRange**: Enforces per-pod default limits
- **ResourceQuota**: Enforces namespace-wide totals
- **Together**: Complete resource governance solution

**Monitoring Usage:**
```bash
kubectl get resourcequota -n dev3
kubectl describe resourcequota namespace-quota -n dev3
```

## Summary

### Key Takeaways

```diff
+ Secrets provide secure configuration management
+ Init containers ensure proper startup sequencing
+ Liveness/Readiness probes maintain application health
+ Requests/Limits prevent resource starvation
+ Namespaces enable multi-tenancy and environment isolation
```

### Quick Reference

**Essential Configurations:**
```yaml
# Secret usage
valueFrom:
  secretKeyRef:
    name: my-secret
    key: password

# Init container for DB dependency
initContainers:
- name: wait-for-db
  image: busybox
  command: ['sh', '-c', 'until nc -z db-service 3306; do sleep 2; done']

# Health probes
readinessProbe:
  httpGet: {path: /health, port: 8080}
  initialDelaySeconds: 5

# Resource limits
resources:
  requests: {cpu: "200m", memory: "256Mi"}
  limits: {cpu: "500m", memory: "512Mi"}
```

### Expert Insight

**Real-world Application**: Enterprise Kubernetes deployments use these concepts to achieve production readiness, proper resource management, and secure configuration handling.

**Expert Path**:
- Implement automated secret rotation with external providers
- Use PodDisruptionBudgets with readiness probes
- Configure Horizontal Pod Autoscaler based on resource metrics
- Implement network policies for namespace security

**Common Pitfalls**:
- ❌ Forgetting to specify namespace context
- ❌ Setting resource requests without monitoring actual usage
- ❌ Exposing secrets in logs or status outputs
- ❌ Not testing failure scenarios for probes
- ❌ Creating ultra-high limits without quotabounds