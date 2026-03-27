# Section 21: EKS Fargate Serverless Workloads

<details open>
<summary><b>Section 21: EKS Fargate Serverless Workloads (G3PCS46)</b></summary>

## Table of Contents
- [EKS & Fargate Introduction](#eks--fargate-introduction)
- [Fargate Basics Introduction](#fargate-basics-introduction)
- [Create EKS Profile using eksctl & Review k8s manifests](#create-eks-profile-using-eksctl--review-k8s-manifests)
- [EKS Fargate - Deploy to Fargate & Test & Clean-Up](#eks-fargate---deploy-to-fargate--test---clean-up)
- [EKS Fargate - Mixed Mode Introduction](#eks-fargate---mixed-mode-introduction)
- [EKS Fargate - Create Profiles using YAML](#eks-fargate---create-profiles-using-yaml)
- [EKS Fargate - Deploy 3 Apps & Test, 2 On Fargate and 1 on EC2 Node Group & Clean-Up](#eks-fargate---deploy-3-apps--test-2-on-fargate-and-1-on-ec2-node-group---clean-up)

## EKS & Fargate Introduction

### Overview
This section provides a comprehensive high-level introduction to AWS Fargate as a serverless compute platform for containers on EKS, covering core concepts, controllers, profiles, deployment options, and architectural considerations. It explains how Fargate integrates with Kubernetes using AWS-built controllers to schedule pods on serverless infrastructure.

### Key Concepts/Deep Dive

#### What is Fargate?
- **Serverless Compute Platform**: Provides on-demand right-sized compute capacity for containers without managing underlying infrastructure
- **Integration with EKS**: Uses Kubernetes controllers built by AWS on top of upstream Kubernetes schedulers to manage pod scheduling
- **Key Components**:
  - Fargate controllers run in EKS control plane (mutating/validating admission controllers + new scheduler)
  - Extensible Kubernetes model allows seamless integration
  - Responsible for recognizing/catching pods that meet Fargate criteria and scheduling them

#### AWS EKS on Fargate
- **Seamless Migration**: Bring existing pods and deploy to Fargate without code changes
- **Workflow Compatibility**: Works with existing Kubernetes tools and services
- **Infrastructure Consideration**: Requires one private subnet per cluster for Fargate profiles

#### Deployment Options
| Deployment Type | Description |
|---|---|
| EC2 Node Groups Only | Managed or unmanaged EC2 instances |
| Mixed Mode | EC2 node groups + Fargate profiles in same cluster |
| Fargate Only | Entire cluster using Fargate serverless |

#### Architecture Comparison
- **EC2 Node Groups**
  - Flexible: Public/private subnet deployment
  - Visibility: Managed AMI and patches from AWS
  - Lifecycle: Customer-managed host lifecycle
- **Fargate Profiles**
  - **1:1 Ratio**: One pod = one Fargate instance (auto-generated)
  - **Private Subnets Only**: Pods run in isolated private subnet environment
  - **Pay-as-you-go**: Only pay for resources allocated per pod
  - **Zero host visibility**: Cannot access/log into underlying instances

#### Fargate Considerations
> [!IMPORTANT]
> Review AWS documentation for comprehensive Fargate limitations and supported features

Key restrictions include:
- DaemonSets not supported
- GPU workloads not available (as of session date)
- Privilege containers restricted
- Stateful workloads require persistent storage analysis
- Vertical pod autoscaler recommended for right-sizing

### Code/Config Blocks

**Fargate Controller Components:**
```yaml
- New scheduler alongside default Kubernetes scheduler
- Mutating Admission Controllers
- Validating Admission Controllers
```

### Lab Demos
✅ **Commands Demonstrated:**
- Cluster requirements verification
- Subnet configuration checks for Fargate compatibility

### Tables

**EKS Deployment Architectures:**

| Mode | EC2 Node Groups | Fargate Profiles | Private Subnets | Public Subnets |
|------|----------------|------------------|----------------|---------------|
| EC2 Only | ✓ | ✗ | ✓ | ✓ |
| Mixed | ✓ | ✓ | ✓ | ✓ |
| Fargate Only | ✗ | ✓ | ✓ | ✗ |

## Fargate Basics Introduction

### Overview
This section covers Fargate profile basics including prerequisites, cluster setup verification, and configuration for basic deployment scenarios. Focuses on creating single Fargate profiles using eksctl CLI and understanding namespace-based workload scheduling.

### Key Concepts/Deep Dive

#### Prerequisites Setup
- **EKS Cluster**: Pre-existing EKS demo cluster with managed node groups
- **EKSCTL Updates**: Frequent CLI updates required (15-20 day cycles)
- **Verification Steps**:
  - kubectl get nodes -o wide (confirm existing EC2 nodes)
  - ALB Ingress Controller pods in kube-system
  - External DNS pods in default namespace

#### Fargate Profile Basics
- **Creation**: eksctl create fargateprofile command
- **Scheduling**: Namespace-based selector determines pod placement
- **Resources**: Automatic Fargate pod execution role creation on first profile

#### Mixed Mode Architecture
```
EKS Cluster (Mixed Mode)
├── Private Subnets: EC2 Managed Node Groups + Fargate Profiles
├── Public Subnets: ALB Ingress Services
└── NAT Gateway: Fargate outbound connectivity to EKS control plane
```

#### Target Type IP Annotation
> [!IMPORTANT]
> Fargate pods lack dedicated worker nodes for NodePort services

Solution: Use `target-type: ip` in ingress annotations for direct pod targeting via IP addresses.

### Code/Config Blocks

**eksctl Fargate Profile Command:**
```bash
eksctl create fargateprofile \
  --cluster eks-demo-one \
  --name fp-dev \
  --namespace fp-dev
```

**Ingress Target Type IP Annotation:**
```yaml
annotations:
  alb.ingress.kubernetes.io/target-type: ip
```

### Tables

**Prerequisite Verification:**

| Component | Namespace | Status Check |
|-----------|-----------|--------------|
| ALB Ingress | kube-system | kubectl get pods |
| External DNS | default | kubectl get pods |
| EKS Nodes | N/A | kubectl get nodes -o wide |

### Lab Demos
✅ **Pre-deployment Steps:**
- EKSCTL version verification and updates
- Cluster node group confirmation
- ALB/external DNS pod status checks

## Create EKS Profile using eksctl & Review k8s manifests

### Overview
This section demonstrates creating a Fargate profile using eksctl CLI commands and reviews the Kubernetes manifests required for Fargate deployments. Covers namespace setup, resource specifications, and ingress configuration optimizations for serverless environments.

### Key Concepts/Deep Dive

#### Fargate Profile Creation
- **Namespace Mapping**: FP Dev namespace → FP Dev Fargate profile
- **Automatic Role Creation**: First profile creates FargatePodExecutionRole
- **No Pre-allocation**: Fargate instances created only when pods deploy

#### Manifest Requirements for Fargate
- **Namespace Declaration**: Mandatory for profile matching
- **Resource Specification**: requests/limits for CPU/memory (highly recommended)
- **Service Types**: Use ClusterIP with ingress routing (avoid NodePort)

#### Resource Allocation Considerations
Fargate calculates host size based on pod requests:
- Pod requests: memory 128MiB
- Fargate allocation: ~256MiB overhead + additional kubelet resources
- **Best Practice**: Define resources to prevent restart loops

#### Ingress Configuration for Fargate
- **Target Type**: IP (direct pod routing)
- **Avoid NodePort**: No dedicated worker nodes for port mapping
- **Mixed Environment**: IP targeting required when Fargate coexists with EC2 nodes

### Code/Config Blocks

**Fargate Profile Verification:**
```bash
eksctl get fargateprofile --cluster eks-demo-one
```

**Namespace Manifest:**
```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: fp-dev
```

**Deployment Resource Section:**
```yaml
spec:
  template:
    spec:
      containers:
      - name: nginx-container
        image: nginx
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
```

**Ingress with Target Type IP:**
```yaml
annotations:
  alb.ingress.kubernetes.io/target-type: ip
spec:
  rules:
  - host: fp-dev.kubeoncloud.com
    http:
      paths:
      - path: /*
        pathType: Prefix
        backend:
          service:
            name: app-one-nginx-nodeport-service
            port:
              number: 80
```

### Tables

**Fargate Pod Execution Role Components:**

| Component | Purpose |
|-----------|---------|
| FargatePodExecutionRole | IAM role for pod execution |
| Pod Identity | Task execution permissions |
| Network Interfaces | VPC configuration access |
| Container Registry | ECR image pull permissions |

### Lab Demos
✅ **Profile Creation Steps:**
- eksctl command execution
- Role creation verification
- Manifest resource allocation setup

## EKS Fargate - Deploy to Fargate & Test & Clean-Up

### Overview
This section demonstrates deploying Kubernetes manifests to Fargate profiles, verifying pod scheduling on Fargate nodes, testing application access through load balancers and DNS, and performing cleanup operations.

### Key Concepts/Deep Dive

#### Deployment Verification
- **Pod Status**: Pending → Running during Fargate instance provisioning
- **Node Types**: 
  - IP- prefixed: EC2 managed node groups
  - fargate-ip: Fargate serverless nodes
- **1:1 Mapping**: Each pod creates one Fargate instance

#### Load Balancer Configuration
- **Target Type IP**: Direct pod IP registration in target groups
- **Health Checks**: HTTP health paths for pod readiness
- **DNS Resolution**: External DNS creates Route 53 records

#### Application Testing
- **URL Access**: fp-dev.kubeoncloud.com/app1/index.html
- **Target Group Verification**: Pod IPs registered automatically
- **Route 53**: CNAME records updated by external DNS

#### Cleanup Operations
- **Graceful Deletion**: Fargate profiles return pods to available node groups
- **Resource Removal**: kubectl delete commands for manifests
- **Cost Optimization**: Automatic Fargate instance termination

### Code/Config Blocks

**Deployment Application:**
```bash
kubectl apply -f kube-manifest/
```

**Pod Status Check:**
```bash
kubectl get pods -n fp-dev -o wide
```

**Load Balancer Target Group Display:**
```
Target Type: ip
Targets:
- IP: 172.31.158.xxx:80 (healthy)
- IP: 172.31.107.xxx:80 (healthy)
```

**Fargate Profile Deletion:**
```bash
eksctl delete fargateprofile \
  --cluster eks-demo-one \
  --name fp-demo \
  --wait
```

### Tables

**Pod Scheduling States:**

| Phase | Description | Duration |
|-------|-------------|----------|
| Pending | Fargate instance provisioning | 10-30 seconds |
| Running | Pod active on Fargate node | Continuous |
| Terminated | Cleanup/scheduling failure | N/A |

### Lab Demos
✅ **End-to-End Workflow:**
- Manifest deployment with kubectl apply
- Port/node verification across namespaces
- Load balancer auto-creation monitoring
- Target group health check validation
- Route 53 DNS record verification
- Browser-access testing
- Profile deletion with resource migration

## EKS Fargate - Mixed Mode Introduction

### Overview
This section introduces mixed mode EKS deployments combining EC2 managed node groups with Fargate profiles, explaining the architecture, namespace isolation considerations, and why separate ingress services are required per namespace in Fargate environments.

### Key Concepts/Deep Dive

#### Mixed Mode Architecture
- **Namespace Organization**: Different apps in separate namespaces
- **Scheduling Logic**: 
  - NS-app-one → EC2 managed node groups
  - NS-app-two → Fargate profile (FP-app2)
  - NS-ums → Fargate profile (FP-ums)
- **Per-Namespace Ingress**: Cross-namespace ingress limitations

#### Cross-Namespace Ingress Limitation
> [!NOTE]
> Ingress services cannot route across namespaces - each namespace requires dedicated ingress

**Reasoning:**
- Kubernetes ingress isolation prevents routing between namespaces
- GitHub issue #I2074 (2015) tracks cross-namespace routing feature
- Current limitation affects all ingress controllers including ALB

#### Application Architecture
```
Mixed Mode EKS Cluster
├── EC2 Node Groups (Private Subnets)
│   └── NS-app-one: Nginx app (NodePort → ALB)
├── Fargate Profiles (Private Subnets)
│   ├── NS-app-two: Nginx app (IP Target → ALB)
│   └── NS-ums: UMS microservice (IP Target → ALB)
└── Shared Services
    ├── RDS MySQL Database
    └── NAT Gateway for outbound connectivity
```

### Code/Config Blocks

**Namespace-Based Deployment Mapping:**
```yaml
# NS-app-one: No Fargate profile → schedules to EC2 nodes
metadata:
  namespace: ns-app-one

# NS-app-two: Fargate profile selector → schedules to Fargate
metadata:
  namespace: ns-app-two

# NS-ums: Fargate profile with label selector
metadata:
  namespace: ns-ums
  labels:
    run-on-fargate: "true"
```

### Tables

**Application Deployment Strategy:**

| Application | Namespace | Target Infrastructure | Ingress Strategy |
|-------------|-----------|----------------------|------------------|
| Nginx App1 | ns-app-one | EC2 Node Groups | Single ingress (NodePort) |
| Nginx App2 | ns-app-two | Fargate Profile | Separate ingress (IP target) |
| UMS Service | ns-ums | Fargate Profile | Separate ingress (IP target) |

### Lab Demos
✅ **Architecture Planning Steps:**
- Namespace design for workload segregation
- Fargate profile selector configuration
- Ingress routing limitation demonstrations

## EKS Fargate - Create Profiles using YAML

### Overview
This section demonstrates creating multiple Fargate profiles simultaneously using YAML configuration files, explaining resource structure, selector definitions with namespaces and labels, and reviewing application manifests for mixed mode deployments.

### Key Concepts/Deep Dive

#### YAML-Based Profile Creation
- **eksctl format**: API version eksctl.io/v1alpha5
- **Multi-profile Support**: Single YAML creates multiple profiles
- **Selectors**:
  - Namespace: required (workloads in namespace → profile)
  - Labels: optional (additional workload filtering)

#### Profile Configuration Structure
```
FargateProfiles:
- name: fp-app2
  selectors:
  - namespace: ns-app-two
- name: fp-ums
  selectors:
  - namespace: ns-ums
    labels:
      run-on-fargate: "true"
```

#### Application Manifest Standards
- **Resource Requirements**: CPU/memory specifications mandatory
- **Namespace Isolation**: Each app in dedicated namespace
- **Label Consistency**: Uniform labeling across Deployment/Service/Secrets
- **DNS Naming**: app-one/app-two/ums.kubeoncloud.com

### Code/Config Blocks

**Fargate YAML Template:**
```yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: eks-demo-one
  region: us-east-1
fargateProfiles:
- name: fp-app2
  selectors:
  - namespace: ns-app-two
- name: fp-ums
  selectors:
  - namespace: ns-ums
    labels:
      run-on-fargate: "true"
```

**eksctl YAML Application:**
```bash
eksctl create fargateprofile -f kube-manifest/01-fargate/fargateprofiles.yml
```

**UMS Deployment Labels:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user-management-microservice
  namespace: ns-ums
  labels:
    run-on-fargate: "true"
spec:
  template:
    metadata:
      labels:
        run-on-fargate: "true"
    spec:
      containers:
      - name: ums-container
        resources:
          requests:
            memory: "512Mi"
            cpu: "200m"
          limits:
            memory: "1Gi"
            cpu: "500m"
```

### Tables

**Selector Configuration Options:**

| Selector Type | Namespace | Labels | Workload Matching |
|---------------|-----------|--------|-------------------|
| Namespace Only | ✓ | ✗ | All workloads in namespace |
| Namespace + Labels | ✓ | ✓ | Workloads with matching labels |

### Lab Demos
✅ **YAML Creation Workflow:**
- Multi-profile YAML file creation
- eksctl API version specification
- Selector namespace/label configuration
- Application manifest namespace updates
- Resource limits specification
- DNS annotation verification

## EKS Fargate - Deploy 3 Apps & Test, 2 On Fargate and 1 on EC2 Node Group & Clean-Up

### Overview
This section demonstrates deploying and testing three applications in mixed mode: one on EC2 managed node groups and two on Fargate profiles. Covers deployment verification, load balancer configuration, DNS setup, application testing, and cleanup procedures.

### Key Concepts/Deep Dive

#### Deployment Verification
- **Node Distribution**: 
  - 2 EC2 nodes (pre-existing)
  - 4 Fargate nodes (2 apps × 2 replicas each)
- **Pod Scheduling**: Automatic profile-based routing
- **Health Checks**: Load balancer target group monitoring

#### Load Balancer Topology
- **Three ALBs**: One per application namespace
- **Target Types**:
  - app-one: instance (NodePort service)
  - app-two/ums: ip (direct pod targeting)
- **Route 53**: Three CNAME records created

#### Testing Validation
- **Application Access**: Browser/load balancer URL verification
- **DNS Resolution**: nslookup validation for cache issues
- **Target Groups**: Health status per application
- **Logs Verification**: Pod startup confirmation

#### Cleanup Strategy
- **Profile Deletion**: Profiles deleted one-by-one with --wait flag
- **Manifest Removal**: kubectl delete -rf for recursive cleanup
- **Resource Migration**: Pods automatically reschedule to available nodes

### Code/Config Blocks

**Recursive Manifest Deployment:**
```bash
kubectl apply -R -f kube-manifest/02-applications/
```

**Cluster-Wide Verification:**
```bash
kubectl get ingress --all-namespaces
kubectl get pods --all-namespaces -o wide
kubectl get nodes -o wide
```

**DNS Health Verification:**
```bash
nslookup app-one.kubeoncloud.com
curl -I https://app-two.kubeoncloud.com/app2/index.html
```

**Profile Deletion Sequence:**
```bash
eksctl delete fargateprofile --cluster eks-demo-one --name fp-app-two --wait
eksctl delete fargateprofile --cluster eks-demo-one --name fp-ums --wait
```

### Tables

**Deployment Metrics:**

| Application | Namespace | Infrastructure | Replicas | Target Type | DNS Record |
|-------------|-----------|----------------|----------|-------------|------------|
| Nginx App1 | ns-app-one | EC2 Nodes | 2 | instance | app-one.kubeoncloud.com |
| Nginx App2 | ns-app-two | Fargate | 2 | ip | app-two.kubeoncloud.com |
| UMS Service | ns-ums | Fargate | 2 | ip | ums.kubeoncloud.com |

### Lab Demos
✅ **End-to-End Mixed Mode Workflow:**
- Bulk manifest application with recursive apply
- Ingress service creation verification across namespaces
- Pod/node mapping validation
- Load balancer rule configuration checks
- Target group health monitoring
- Route 53 record creation confirmation
- DNS resolution troubleshooting techniques
- Application browser testing validation
- Sequential Fargate profile deletion
- Manifest cleanup with recursive delete
- Resource state verification post-deletion

---

## Summary

### Key Takeaways
```diff
! Fargate provides serverless container execution with 1:1 pod-to-host ratio
+ Mixed mode enables seamless EC2 + Fargate workloads in single EKS cluster
! Namespace-based scheduling determines infrastructure target
+ Resource requests/limits essential for Fargate pod stability
+ Cross-namespace ingress routing unsupported - requires separate ALBs
+ Target-type IP annotation enables direct pod load balancing
- Private subnet requirement for all Fargate deployments
+ YAML configuration allows multi-profile creation with selectors
```

### Quick Reference
**Profile Creation (CLI):**
```bash
eksctl create fargateprofile --cluster [name] --name [fp-name] --namespace [ns]
```

**Profile Creation (YAML):**
```bash
eksctl create fargateprofile -f fargateprofiles.yml
```

**Required Ingress Annotation:**
```yaml
annotations:
  alb.ingress.kubernetes.io/target-type: ip
```

**Resource Specification Template:**
```yaml
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "200m"
```

**Namespace Verification:**
```bash
kubectl get pods -n [namespace] -o wide
```

### Expert Insight

#### Real-world Application
Organizations migrate stateless web services and microservices to Fargate for cost optimization and operational simplicity. Mixed mode enables gradual migration - run databases/stateful services on EC2 while moving frontend/API services to Fargate. This approach reduces EC2 licensing costs while maintaining infrastructure flexibility for complex workloads.

#### Expert Path
Start with basic Fargate profiles for simple namespaces, then advance to label-based selectors for granular control. Implement observability with CloudWatch Container Insights to monitor Fargate performance. Master resource tuning through HPA/VPA to optimize costs while ensuring stability. Consider AWS Fargate Spot for variable workloads and implement CI/CD pipelines with EKS Blueprints for production readiness.

#### Common Pitfalls
Failing to specify pod resources leads to restart cycles and wasted compute costs. Using NodePort services with Fargate causes deployment failures due to lack of dedicated worker nodes. Not reviewing Fargate considerations documentation results in incompatible workload deployments (DaemonSets, privileged containers, GPU requirements). Ignoring cross-namespace ingress limitations creates complex, unsupported routing configurations.

</details>
