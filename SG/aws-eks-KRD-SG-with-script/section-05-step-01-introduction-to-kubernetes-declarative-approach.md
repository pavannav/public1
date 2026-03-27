# Section 5: Kubernetes Declarative Approach

<details open>
<summary><b>Section 5: Kubernetes Declarative Approach (G3PCS46)</b></summary>

## Table of Contents
- [5.1 Introduction to Kubernetes Declarative Approach](#51-introduction-to-kubernetes-declarative-approach)
- [5.2 YAML Basics Introduction](#52-yaml-basics-introduction)
- [5.3 Create Pods with YAML](#53-create-pods-with-yaml)
- [5.4 Create NodePort Service with YAML and Access Application via Browser](#54-create-nodeport-service-with-yaml-and-access-application-via-browser)
- [5.5 Create ReplicaSets using YAML](#55-create-replicasets-using-yaml)
- [5.6 Create NodePort Service with YAML and Access Application via Browser](#56-create-nodeport-service-with-yaml-and-access-application-via-browser)
- [5.7 Create Deployment with YAML and Test](#57-create-deployment-with-yaml-and-test)
- [5.8 Backend Application - Create Deployment and ClusterIP Service](#58-backend-application---create-deployment-and-clusterip-service)
- [5.9 Frontend Application - Create Deployment and NodePort Service](#59-frontend-application---create-deployment-and-backend-applications)
- [5.10 Deploy and Test - Frontend and Backend Applications](#510-deploy-and-test---frontend-and-backend-applications)

## 5.1 Introduction to Kubernetes Declarative Approach

### Overview
This lecture introduces the shift from imperative approaches using `kubectl` commands to a declarative approach using YAML manifests. You'll learn to define and manage Kubernetes resources like pods, ReplicaSets, deployments, and services through YAML files and the `kubectl apply` command.

### Key Concepts
Kubernetes supports both imperative and declarative approaches:
- **Imperative**: Direct commands like `kubectl run` or `kubectl expose`
- **Declarative**: Using YAML manifest files with `kubectl apply`

The declarative approach is preferred for:
- Version control of infrastructure
- Repeatable deployments
- Consistency across environments
- Better maintainability

### Code/Config Blocks
```bash
# Example structure for declarative manifests
- pods
- ReplicaSets
- deployments
- services
```

## 5.2 YAML Basics Introduction

### Overview
YAML (YAML Ain't Markup Language) basics are essential for writing Kubernetes manifests. This section covers fundamental YAML syntax needed for defining Kubernetes objects.

### Key Concepts
YAML is designed for human readability and is more user-friendly than JSON. Core elements include:

- **Comments**: Use `#` for single-line comments
- **Key-Value Pairs**: Format as `key: value` (space after colon is mandatory)
- **Dictionaries/Maps**: Group related properties under a key with indentation
- **Arrays/Lists**: Use dashes (-) for list items
- **Spaces**: Indentation defines structure (typically 2 spaces)

### Code/Config Blocks
```yaml
# YAML Example
name: myapp           # Key-value pair
age: 25              # Another key-value pair

person:              # Dictionary/Map
  name: John
  age: 30
  city: New York

hobbies:             # Array/List
  - cooking
  - reading
  - coding

# Multi-line strings using | or >
description: |
  This is a multi-line
  string in YAML
```

### Tables
| YAML Element | Syntax Example | Purpose |
|-------------|----------------|---------|
| Key-Value | `name: value` | Basic configuration |
| Dictionary | `person:\n  name: John` | Grouped properties |
| Array | `items:\n  - item1\n  - item2` | List of values |
| Comment | `# This is a comment` | Documentation |

### Lab Demos
Create a `sample.yml` file with various YAML constructs:
```yaml
# Sample YAML file
app: myapp
version: "1"
environment: production

config:
  database:
    host: localhost
    port: 5432
  features:
    - authentication
    - logging
    - monitoring
```

Use Visual Studio Code or any YAML editor to validate syntax.

## 5.3 Create Pods with YAML

### Overview
Pods are the smallest deployable units in Kubernetes. This section covers creating pod definitions using YAML manifests, contrasting with imperative methods.

### Key Concepts
**Top-Level YAML Structure:**
- `apiVersion`: API version (e.g., `v1` for pods)
- `kind`: Resource type (e.g., `Pod`)
- `metadata`: Object metadata (name, labels)
- `spec`: Object specification

**Important Notes:**
- Direct pod creation is not recommended in production
- Always use controllers (deployments, jobs, etc.) for pod management
- Labels are crucial for selectors and management

### Code/Config Blocks
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app: myapp
    tier: frontend
spec:
  containers:
  - name: myapp-container
    image: stacksimplify/kube-app:v1
    ports:
    - containerPort: 80
```

### Command Reference
```bash
# Create pod from YAML
kubectl apply -f pod-definition.yml

# Verify pod creation
kubectl get pods
kubectl describe pod myapp-pod
```

### Lab Demos
1. Create `pod-definition.yml` with the above YAML
2. Apply the manifest: `kubectl apply -f pod-definition.yml`
3. Verify: `kubectl get pods` and access via NodePort service

## 5.4 Create NodePort Service with YAML and Access Application via Browser

### Overview
NodePort services expose applications externally on static ports. This section demonstrates creating a NodePort service using YAML and accessing the application.

### Key Concepts
**NodePort Service Components:**
- `type: NodePort`: Defines service type
- `selector`: Labels to match target pods
- `ports`: Service ports configuration

**Ports in Service:**
- `port`: Service port inside cluster
- `targetPort`: Container port on pods
- `nodePort`: Static port on worker nodes (30000-32767)

### Code/Config Blocks
```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-pod-nodeport-service
  labels:
    app: myapp
spec:
  type: NodePort
  selector:
    app: myapp
  ports:
  - name: http
    port: 80
    targetPort: 80
    nodePort: 31231
```

### Lab Demos
1. Create NodePort service YAML
2. Apply manifest: `kubectl apply -f nodeport-service.yml`
3. Get node IP: `kubectl get nodes -o wide`
4. Access in browser: `http://<node-ip>:31231`

## 5.5 Create ReplicaSets using YAML

### Overview
ReplicaSets ensure a specified number of pod replicas are running. This section covers creating ReplicaSet manifests and understanding their relationship with deployments.

### Key Concepts
**ReplicaSet Structure:**
- `replicas`: Number of desired pod instances
- `selector`: Labels to identify managed pods
- `template`: Pod template definition

**Key Points:**
- ReplicaSets maintain pod count automatically
- MatchLabels must match pod template labels
- Deployment creates and manages ReplicaSets

### Code/Config Blocks
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp2-rs
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp2
  template:
    metadata:
      labels:
        app: myapp2
    spec:
      containers:
      - name: myapp2
        image: stacksimplify/kube-app:v2
        ports:
        - containerPort: 80
```

### Lab Demos
1. Create ReplicaSet YAML
2. Apply: `kubectl apply -f replicaset-definition.yml`
3. Verify: `kubectl get rs` and `kubectl get pods`
4. Delete a pod to test auto-scaling: `kubectl delete pod <pod-name>`

## 5.6 Create NodePort Service with YAML and Access Application via Browser

### Overview
Create a NodePort service for the ReplicaSet and access the v2 application version to verify load balancing across pods.

### Lab Demos
1. Create NodePort service YAML with selector `app: myapp2`
2. Apply and access via browser on port 31232
3. Observe that multiple pod replicas serve requests, confirming ReplicaSet functionality

## 5.7 Create Deployment with YAML and Test

### Overview
Deployments provide declarative pod management with update strategies. This section transforms a ReplicaSet into a deployment and tests it.

### Key Concepts
Deployments are supersets of ReplicaSets, adding:
- Update strategies (RollingUpdate, Recreate)
- Rollback capabilities
- Pause/resume functionality

### Code/Config Blocks
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp3-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp3
  template:
    metadata:
      labels:
        app: myapp3
    spec:
      containers:
      - name: myapp3-container
        image: stacksimplify/kube-app:v3
        ports:
        - containerPort: 80
```

### Lab Demos
1. Convert ReplicaSet YAML to Deployment (change `kind` and update labels)
2. Apply: `kubectl apply -f deployment-definition.yml`
3. Create NodePort service on port 31233
4. Access v3 version in browser

## 5.8 Backend Application - Create Deployment and ClusterIP Service

### Overview
Create backend REST API deployment and ClusterIP service for internal cluster communication.

### Key Concepts
**ClusterIP Service:**
- Default service type
- Exposes service on internal cluster IP
- Accessible only within cluster
- Used for backend communication

### Code/Config Blocks
```yaml
# Backend Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-rest-app
  labels:
    app: backend-rest-app
    tier: backend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: backend-rest-app
  template:
    metadata:
      labels:
        app: backend-rest-app
        tier: backend
    spec:
      containers:
      - name: backend-rest-app
        image: stacksimplify/kube-helloworld-rest-api:1.0.0
        ports:
        - containerPort: 8080

# Backend ClusterIP Service
apiVersion: v1
kind: Service
metadata:
  name: my-backend-service
  labels:
    app: backend-rest-app
    tier: backend
spec:
  selector:
    app: backend-rest-app
  ports:
  - name: http
    port: 80
    targetPort: 8080
```

### Lab Demos
Apply manifests and verify backend service creation with `kubectl get svc` and logs with `kubectl logs -f <pod-name>`.

## 5.9 Frontend Application - Create Deployment and NodePort Service

### Overview
Create frontend Nginx proxy deployment and NodePort service that connects to the backend service.

### Key Concepts
Frontend application parses backend via ClusterIP service name (`my-backend-service`).

### Code/Config Blocks
```yaml
# Frontend Deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend-nginx-app
  labels:
    app: frontend-nginx-app
    tier: frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: frontend-nginx-app
  template:
    metadata:
      labels:
        app: frontend-nginx-app
        tier: frontend
    spec:
      containers:
      - name: frontend-nginx-app
        image: stacksimplify/kube-frontend-nginx:1.0.0
        ports:
        - containerPort: 80

# Frontend NodePort Service
apiVersion: v1
kind: Service
metadata:
  name: frontend-nginx-app-nodeport-service
  labels:
    app: frontend-nginx-app
    tier: frontend
spec:
  type: NodePort
  selector:
    app: frontend-nginx-app
  ports:
  - name: http
    port: 80
    targetPort: 80
    nodePort: 31234
```

### Lab Demos
Apply manifests, access application on port 31234, and observe load balancing across backend pods.

## 5.10 Deploy and Test - Frontend and Backend Applications

### Overview
This section demonstrates bulk operations using `kubectl apply -f <folder>` and deletion with `kubectl delete -f <folder>`.

### Key Concepts
**kubectl apply:**
- Creates or updates resources based on YAML
- Idempotent operation
- Supports folders for batch operations

**kubectl delete:**
- Removes resources defined in YAML files
- References YAML for exact resource identification

### Code/Config Blocks
```bash
# Apply all manifests in folder
kubectl apply -f kube-manifest/

# Delete all resources
kubectl delete -f kube-manifest/

# Bulk apply multiple files
kubectl apply -f 01-backend-deployment.yml -f 02-backend-service.yml -f 03-frontend-deployment.yml -f 04-frontend-service.yml
```

### Lab Demos
1. Use folder-based apply for efficient deployment
2. Test end-to-end application functionality
3. Use folder-based delete for cleanup

## Summary

### Key Takeaways
```diff
+ Declarative approach uses YAML manifests for version-controlled, repeatable deployments
+ YAML requires proper indentation and space formatting
+ Kubernetes objects follow apiVersion, kind, metadata, spec structure
+ Services provide different exposure types: ClusterIP, NodePort, LoadBalancer
+ Deployments manage ReplicaSets for pod lifecycle management
+ Labels and selectors enable service-to-pod communication
+ kubectl apply supports bulk operations via folders
- Always use controllers (deployments) instead of direct pod creation
- Label mismatches prevent proper service-pod routing
- Incorrect indentation breaks YAML parsing
```

### Quick Reference
```yaml
# Basic Pod Template
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
    app: myapp
spec:
  containers:
  - name: my-container
    image: myimage:tag
    ports:
    - containerPort: 80

# Basic Service Template
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort  # or ClusterIP
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30000  # for NodePort
```

```bash
# Essential commands
kubectl apply -f manifest.yml        # Create/update from YAML
kubectl delete -f manifest.yml       # Delete resources
kubectl apply -f ./kube-manifest/    # Bulk apply folder
kubectl get all                      # View all resources
kubectl describe <resource> <name>   # Detailed information
```

### Expert Insight

#### Real-world Application
In production environments, declarative manifests stored in Git repositories enable:
- Infrastructure as Code (IaC) practices
- Automated CI/CD pipelines
- Environment-agnostic deployments
- Rollback capabilities through version control

#### Expert Path
- Master Helm charts for complex application packaging
- Implement GitOps workflows with ArgoCD or Flux
- Use Kustomize for environment-specific modifications
- Understand resource quotas and RBAC for security

#### Common Pitfalls
- Forgetting namespace specification in multi-tenant clusters
- Incorrect label selectors causing service routing failures
- Missing resource limits leading to resource exhaustion
- Not using ConfigMaps and Secrets for configuration management

</details>
