# Section 10: AWS Load Balancers and AWS Load Balancer Controller

<details open>
<summary><b>Section 10: AWS Load Balancers and AWS Load Balancer Controller (Claude Code)</b></summary>

## Table of Contents

- [10.1 Step-01- AWS Load Balancers Introduction](#101-step-01--aws-load-balancers-introduction)
- [10.2 Step-02- Create EKS Private Node Group](#102-step-02--create-eks-private-node-group)
- [10.3 Step-03- EKS with Classic Load Balancers Demo](#103-step-03--eks-with-classic-load-balancers-demo)
- [10.4 Step-04- EKS with Network Load Balancers Demo](#104-step-04--eks-with-network-load-balancers-demo)
- [11.1 EKS-08-00-LBC-01-What-are-we-going-to-learn-AWS-LBC-Ingress](#111-eks-08-00-lbc-01-what-are-we-going-to-learn-aws-lbc-ingress)
- [11.2 Step-00-02- Ingress Introduction Part 2](#112-step-00-02--ingress-introduction-part-2)
- [11.3 Step-01- Introduction to AWS Load Balancer Controller](#113-step-01--introduction-to-aws-load-balancer-controller)
- [11.4 Step-02- Verify Pre-requisites](#114-step-02--verify-pre-requisites)
- [11.5 Step-03- Create IAM Policy, IAM Role, k8s service account and annotate it](#115-step-03--create-iam-policy-iam-role-k8s-service-account-and-annotate-it)
- [11.6 Step-04- Install AWS Load Balancer Controller using HELM](#116-step-04--install-aws-load-balancer-controller-using-helm)
- [11.7 Step-05- Verify AWS LBC Deployment and WebHook Service](#117-step-05--verify-aws-lbc-deployment-and-webhook-service)
- [11.8 Step-06- LBC Service Account and TLS Cert Internals](#118-step-06--lbc-service-account-and-tls-cert-internals)
- [11.9 Step-06-02- Uninstall Load Balancer Controller Command SHOULD NOT BE EXECUTED](#119-step-06-02--uninstall-load-balancer-controller-command-should-not-be-executed)
- [11.10 Step-07- Introduction to Kubernetes Ingress Class Resource](#1110-step-07--introduction-to-kubernetes-ingress-class-resource)
- [11.11 Step-08- Deploy Ingress and Verify](#1111-step-08--deploy-ingress-and-verify)

## 10.1 Step-01- AWS Load Balancers Introduction

### Overview

Section 10 explores AWS's three load balancer types (CLB, NLB, ALB) and their integration with Kubernetes services, transitioning to enterprise-ready private node group architecture with external load balancer connectivity.

### Key Concepts

**AWS Load Balancer Types:**

| Load Balancer | Protocol Types | Recommended Use Case | Kubernetes Integration |
|---------------|----------------|----------------------|------------------------|
| **Classic Load Balancer (CLB)** | HTTP, HTTPS, TCP, SSL, UDP | Legacy applications | Default for `LoadBalancer` services |
| **Network Load Balancer (NLB)** | TCP, UDP, TLS (Layer 4) | High performance, TCP applications | Annotation-based selection |
| **Application Load Balancer (ALB)** | HTTP, HTTPS (Layer 7) | Microservices, path-based routing | AWS Load Balancer Controller required |

### AWS Load Balancer Capabilities Matrix

| Feature | Classic LB | Network LB | Application LB |
|---------|------------|------------|----------------|
| Protocols | TCP, HTTP, HTTPS, SSL | TCP, UDP, TLS | HTTP, HTTPS |
| Connection Drainage | ✅ | ✅ | ✅ |
| Health Checks | ✅ | ✅ | ✅ |
| Security Groups | ✅ | ✅ | ✅ |
| Logging | Limited | ✅ | ✅ |
| CloudWatch Metrics | Basic | Advanced | Advanced |
| Target Groups | N/A | ✅ | ✅ |
| Path-based Routing | ❌ | ❌ | ✅ |
| Host-based Routing | ❌ | ❌ | ✅ |
| WebSocket Support | ❌ | ✅ | ✅ |

### Production Architecture Evolution

**From Public Node Groups to Enterprise:**
```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Internet      │<───►│  Classic CLB    │<─┐  │   LoadBalancer  │
│   User Traffic  │     │   Public IP     │  │  │   Kubernetes    │
└─────────────────┘     └─────────────────┘  │  │   Service       │
                                             │  └─────────────────┘
                                             │
┌─────────────────┐     ┌─────────────────┐  │
│   EKS Managed   │<───►│   EKS Node      │  │
│   Node Group    │     │   Workers       │  │  └───────────┐
│   (Private)     │     │   (Private)     │                  │
└─────────────────┘     └─────────────────┘                  │
           │                                                │
           │                                                │
           ↓                                                │
┌─────────────────┐     ┌─────────────────┐     ┌───────────┴─────┐
│   External      │<───►│    AWS RDS      │     │   External      │
│   Name Service  │     │   MySQL DB      │     │   LoadBalancer  │
│   (DNS Alias)   │     │   (Private)     │     │   Annotation     │
└─────────────────┘     └─────────────────┘     └─────────────────┘
  kubernetes service     AWS managed service   ingress controller
  type: ExternalName     Multi-AZ, HA          advanced routing
```

### Key Features of Each Load Balancer

1. **Classic Load Balancer:**
   - Legacy load balancer supporting multiple protocols
   - Default choice when creating `LoadBalancer` service types
   - Limited advanced features compared to newer load balancers

2. **Network Load Balancer:**
   - Ultra-high performance load balancing at TCP/UDP layer
   - Very low latency and high connection rate support
   - Ideal for TCP-based applications (databases, SMTP, etc.)

3. **Application Load Balancer:**
   - Advanced HTTP/HTTPS load balancer with Layer 7 intelligence
   - Path-based and host-based routing capabilities
   - Required for Kubernetes Ingress implementations

## 10.2 Step-02- Create EKS Private Node Group

### Overview

Transitioning from public to private node groups establishes enterprise-compliant architecture where application workloads run isolated from internet exposure.

### Key Concepts

**Public vs Private Node Groups:**
- **Public Node Groups**: Worker nodes in public subnets, receive public IPs, internet-accessible
- **Private Node Groups**: Worker nodes in private subnets, no public IPs, NAT gateway for outbound

### Architecture Benefits

- **Security Isolation**: Workloads not directly exposed to internet
- **Network Segmentation**: Clear separation between control plane and data plane
- **Compliance**: Meets enterprise security requirements
- **Load Balancer Integration**: Supports external traffic routing through load balancers

### Commands

```bash
# Delete existing public node group
eksctl delete nodegroup --cluster=eks-demo-one --name=ng-public

# Create private node group
eksctl create nodegroup \
  --cluster=eks-demo-one \
  --name=ng-private \
  --node-type=t3.medium \
  --nodes=2 \
  --nodes-min=1 \
  --nodes-max=3 \
  --node-private-networking \
  --asg-access

# Verify node group details
eksctl get nodegroup --cluster=eks-demo-one
```

### Infrastructure Changes

Before vs After EKS Architecture:

**Before (Public Node Groups):**
```
Internet → EKS Node (Public IP) → Pod Application
```

**After (Private Node Groups):**
```
Internet → Load Balancer → Private EKS Nodes → Pod Application → RDS Database
```

## 10.3 Step-03- EKS with Classic Load Balancers Demo

### Overview

Demonstrating default Kubernetes LoadBalancer service creation which automatically provisions AWS Classic Load Balancer for external traffic access to internal services.

### Key Concepts

**Kubernetes LoadBalancer Service:**
- **Type: LoadBalancer**: Tells Kubernetes to provision external load balancer
- **Default Behavior**: Creates Classic Load Balancer on AWS
- **Traffic Flow**: LB receives traffic → routes to NodePort → kube-proxy → pods

### Code/Config Blocks

```yaml
apiVersion: v1
kind: Service
metadata:
  name: usermgmt-clb-service
spec:
  type: LoadBalancer
  selector:
    app: usermgmt
  ports:
  - port: 80
    targetPort: 8095
    protocol: TCP
```

### Provisioning Process

1. **Service Creation**: `kubectl apply -f service.yml`
2. **AWS Integration**: Kubernetes creates CLB via AWS API
3. **Discovery**: Nodes register with CLB target groups
4. **Routing**: Traffic flows CLB → NodePort → Service → Pods

### Verification Commands

```bash
# Watch CLB provisioning
kubectl get svc -w

# Verify AWS load balancer
aws elb describe-load-balancers --region us-east-1

# Check load balancer health
kubectl get nodes -o wide
kubectl get pods -l app=usermgmt --show-labels
```

### Common Issues

```diff
- Load balancer remains in "pending" state
- Node security groups blocking health checks
- Target group misconfigurations
- Subnet availability zone mismatches
```

## 10.4 Step-04- EKS with Network Load Balancers Demo

### Overview

Creating Network Load Balancer for high-performance TCP/UDP applications using Kubernetes service annotations to override default CLB creation.

### Key Concepts

**NLB Selection Annotation:**
- Service annotation specifies load balancer type preference
- Overrides default CLB creation behavior
- Enables protocol-specific load balancer selection

### Code/Config Blocks

```yaml
apiVersion: v1
kind: Service
metadata:
  name: usermgmt-nlb-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
spec:
  type: LoadBalancer
  selector:
    app: usermgmt
  ports:
  - port: 80
    targetPort: 8095
    protocol: TCP
```

### NLB Characteristics

- **TCP Layer 4**: Pure network load balancing without HTTP parsing
- **Static IPs**: Can have static IP addresses (unlike CLB)
- **Multi-Protocol**: Supports TCP, UDP, and TLS protocols
- **Ultra-Low Latency**: Minimal overhead compared to CLB/ALB

### Lab Demos

**NLB Verification:**
```bash
# Check service creation
kubectl get svc usermgmt-nlb-service

# AWS Console verification
aws elbv2 describe-load-balancers \
  --region us-east-1 \
  --query 'LoadBalancers[?Type==`network`]'

# Traffic test
curl http://<nlb-dns-name>/usermgmt/health-status
```

### Performance Comparison

| Metric | Classic LB | Network LB | Improvement |
|--------|------------|------------|-------------|
| Throughput | Moderate | Very High | 2-3x higher |
| Latency | ~100ms | <25ms | 75% reduction |
| Connections/sec | 5,000 | 500,000+ | 100x scale |

## 11.1 EKS-08-00-LBC-01-What-are-we-going-to-learn-AWS-LBC-Ingress

### Overview

Introduction to AWS Load Balancer Controller and Kubernetes Ingress, enabling Application Load Balancer integration for advanced HTTP/HTTPS routing capabilities.

### Key Concepts

**AWS Load Balancer Controller:**
- **Kubernetes Controller**: Replaces legacy ALB Ingress Controller
- **Multi-load-balancer Support**: ALB, NLB, CLB creation
- **Enhanced Security**: IAM integration and fine-grained permissions
- **Advanced Features**: Path-based routing, SSL termination, WebSocket support

**Kubernetes Ingress:**
- **API Resource**: Allows external access to internal services
- **Layer 7 Intelligence**: HTTP-aware routing and capabilities
- **Host/Path Support**: Route traffic based on hostname and URL paths
- **SSL Termination**: Certificate management at load balancer level

## 11.2 Step-00-02- Ingress Introduction Part 2

### Overview

Deep dive into Kubernetes Ingress resource capabilities, including ingress classes, annotations for load balancer customization, and TLS certificate management.

### Key Concepts

**Ingress Class:**
- **Resource Selection**: Links ingress to specific controller
- **Controller Discovery**: IngressClass resource defines controller identity
- **Default Behavior**: Can specify default ingress class

**Ingress Annotations:**
- Load balancer type specification
- Health check configuration
- SSL/TLS certificate references
- Listener configuration options

## 11.3 Step-01- Introduction to AWS Load Balancer Controller

### Overview

The AWS Load Balancer Controller is the recommended solution for Kubernetes ingress and load balancer integration, providing full lifecycle management of AWS ALBs and NLBs.

### Key Concepts

**Controller Capabilities:**
- **ALB Creation**: Automatic Application Load Balancer provisioning
- **NLB Support**: Advanced Network Load Balancer features
- **Ingress Integration**: Sophisticated HTTP routing capabilities
- **Security Enhancement**: Direct IAM integration over legacy solutions

### Benefits Over Alternatives

- **Native AWS Integration**: Full feature access vs partial coverage
- **Security First**: Modern IAM policies and service mesh integration
- **Active Development**: Community-driven and AWS-supported
- **Comprehensive Features**: All ALB/NLB capabilities available

### Installation Requirements

- **EKS Clusters**: Supported on all EKS versions
- **IAM Permissions**: Service account annotations for AWS API access
- **Helm Integration**: Standard Helm deployment package
- **Metrics Integration**: CloudWatch and Prometheus support

## 11.4 Step-02- Verify Pre-requisites

### Overview

Ensuring cluster readiness for AWS Load Balancer Controller installation, including OIDC provider configuration and necessary IAM permissions.

### Pre-requisites Checklist

```yaml
# Prerequisites verification
- EKS cluster version: >= 1.14
- OIDC provider enabled: oidc.eks.region.amazonaws.com
- Worker node policies: AmazonEKSWorkerNodePolicy, AmazonEKS_CNI_Policy
- VPC configuration: Multiple availability zones
- Security group rules: Permissive for initial setup
```

### Commands

```bash
# Verify cluster version and endpoint
kubectl version --short
eksctl get cluster --region us-east-1

# Check OIDC provider
aws eks describe-cluster --name eks-demo-one --query "cluster.identity.oidc"

# Verify VPC and subnets
aws ec2 describe-vpcs --filters Name=tag:Name,Values=eks-ctl-eks-demo-one-vpc
aws ec2 describe-subnets --filters Name=vpc-id,Values=vpc-xxxxxx --query 'Subnets[*].[SubnetId,AvailabilityZone,Tags[?Key==`aws:cloudformation:logical-id`].Value|[0]]'
```

## 11.5 Step-03- Create IAM Policy, IAM Role, k8s service account and annotate it

### Overview

Setting up identity and access management for the AWS Load Balancer Controller to securely interact with AWS APIs, using EKS Pod Identity for enhanced security.

### Key Concepts

**EKS Pod Identity:**
- **Modern Authentication**: Replaces complex kube2iam and external secrets
- **Security Enhancement**: Service accounts directly assume IAM roles
- **Simplified Setup**: No cluster-level trust relationships required
- **Audit Trail**: Clear resource-to-relationship mapping

### Installation Steps

1. **IAM Policy Creation:** AWSLBControllerIAMPolicy with minimum required permissions
2. **IAM Role Setup:** Trust relationship with EKS service account
3. **Kubernetes Manifests:** Service account with annotations
4. **Helm Deployment:** Install controller with proper service account

### Code/Config Blocks

```yaml
# Service account annotation
apiVersion: v1
kind: ServiceAccount
metadata:
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::account-id:role/AmazonEKSLoadBalancerControllerRole

---
# IAM policy (critical permissions excerpt)
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:*",
        "ec2:CreateSecurityGroup",
        "ec2:Describe*"
      ],
      "Resource": "*"
    }
  ]
}
```

## 11.6 Step-04- Install AWS Load Balancer Controller using HELM

### Overview

Deploying the AWS Load Balancer Controller using Helm chart with proper configurations, service account associations, and cluster specifications.

### Key Concepts

**Helm Installation Benefits:**
- **Package Management**: Versioned, reproducible deployments
- **Dependency Resolution**: Automatic sub-chart management
- **Upgrade Mechanisms**: Safe in-place upgrades and rollbacks
- **Configuration Flexibility**: Values-based customization

### Installation Commands

```bash
# Add Helm repository
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# Install controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --namespace kube-system \
  --set clusterName=eks-demo-one \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set image.repository=public.ecr.aws/eks/aws-load-balancer-controller \
  --version v2.7.0

# Verify deployment
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
```

### Controller Configuration

```yaml
# key configuration values
clusterName: eks-demo-one
serviceAccount:
  create: false
  name: aws-load-balancer-controller
vpcId: vpc-xxxxxx
region: us-east-1
autoDiscoverAwsRegion: true
autoDiscoverAwsVpcID: true
```

## 11.7 Step-05- Verify AWS LBC Deployment and WebHook Service

### Overview

Comprehensive verification of AWS Load Balancer Controller deployment including service account permissions, webhook configurations, and health status checks.

### Key Concepts

**Webhook Integration:**
- **Admission Controller**: Validates ingress resource specifications
- **Policy Enforcement**: Ensures compliance with AWS resource constraints
- **Failure Rejection**: Prevents invalid configurations from deploying

### Verification Checklist

```bash
# Controller pod status
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

# Service account verification
kubectl get serviceaccounts aws-load-balancer-controller -n kube-system -o yaml

# Webhook configuration
kubectl get validatingwebhookconfigurations aws-load-balancer-webhook -o yaml

# Event logs
kubectl logs -n kube-system deployment/aws-load-balancer-controller
```

### Common Verification Issues

```diff
- Service account role annotation missing
- Webhook certificate expired/invalid
- IAM permissions insufficient
- Cluster name mismatch in configuration
```

## 11.8 Step-06- LBC Service Account and TLS Cert Internals

### Overview

Understanding the internal mechanics of service account role assumption and TLS certificate management for secure webhook operations.

### Key Concepts

**Service Account Token:**
- **JWT Generation**: Kubernetes generates signed tokens
- **AWS STS Exchange**: Tokens exchanged for temporary AWS credentials
- **Secure Ephemeral**: Credentials valid for 12 hours, auto-refresh

**Webhook TLS Certificates:**
- **Kubernetes CA**: Uses cluster's certificate authority
- **Automatic Provisioning**: Controller generates and rotates certificates
- **Security Model**: Mutual TLS authentication for webhook calls

### Internal Mechanics

```yaml
# Service account token request
kubectl get secrets aws-load-balancer-controller-token-xxxx -n kube-system -o jsonpath='{.data.token}' | base64 -d
```

## 11.9 Step-06-02- Uninstall Load Balancer Controller Command SHOULD NOT BE EXECUTED

### Overview

Cleanup command reference for Load Balancer Controller removal (marked explicit اجرایی as SHOULD NOT BE EXECUTED in current context).

### Cleanup Commands

```bash
# Warning: DO NOT EXECUTE while in use
helm uninstall aws-load-balancer-controller -n kube-system

# Remove IAM resources
aws iam detach-role-policy \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --policy-arn arn:aws:iam::account:policy/AWSLoadBalancerControllerIAMPolicy

aws iam delete-role --role-name AmazonEKSLoadBalancerControllerRole
aws iam delete-policy --policy-arn arn:aws:iam::account:policy/AWSLoadBalancerControllerIAMPolicy
```

### Preservation Guidelines

- **Dependency Check**: Verify no active ingress resources depend on controller
- **Gradual Migration**: Plan removal when moving between environments
- **Backup Policies**: Preserve IAM policies for future reuse

## 11.10 Step-07- Introduction to Kubernetes Ingress Class Resource

### Overview

Kubernetes Ingress classes provide a mechanism to specify which ingress controller should handle specific ingress resources, enabling multi-controller environments.

### Key Concepts

**Ingress Class Parameters:**
- **Controller Selection**: Links ingress to specific implementation
- **Configuration**: Controller-specific customization options
- **Default Behavior**: Can specify cluster-wide default controller

### Code/Config Blocks

```yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: aws-load-balancer
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: ingress.k8s.aws/alb
```

### Benefits

- **Multi-Controller Support**: Different ingress controllers per application
- **Migration Strategy**: Gradual transition between controllers
- **Configuration Segmentation**: Environment-specific controller settings

## 11.11 Step-08- Deploy Ingress and Verify

### Overview

Creating production-ready ingress resources with AWS Load Balancer Controller, demonstrating HTTP routing, SSL certificates, and advanced load balancer features.

### Key Concepts

**Ingress Configuration:**
- **Host Matching**: Route traffic based on hostname
- **Path Routing**: Direct traffic by URL path patterns
- **SSL Termination**: Certificate management at load balancer level
- **Health Checks**: Application-aware health monitoring

### Code/Config Blocks

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: usermgmt-ingress
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: usermgmt-prod-alb
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/healthcheck-path: /usermgmt/health-status
spec:
  ingressClassName: aws-load-balancer
  rules:
  - host: usermgmt.example.com
    http:
      paths:
      - path: /usermgmt
        pathType: Prefix
        backend:
          service:
            name: usermgmt-service
            port:
              number: 80
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
```

### Advanced Annotations

```yaml
# ALB-specific configurations
annotations:
  # SSL/TLS configuration
  alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:region:account:certificate/cert-id
  alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-2-2017-01

  # Security and access control
  alb.ingress.kubernetes.io/security-groups: sg-01,s g-02,sg-03
  alb.ingress.kubernetes.io/wafv2-acl-arn: arn:aws:wafv2:region:account:regional/webacl/webacl-id

  # Traffic management
  alb.ingress.kubernetes.io/load-balancer-attributes: idle_timeout.timeout_seconds=180
```

### Verification Process

```bash
# Ingress resource creation
kubectl apply -f ingress.yml

# Monitor ALB creation
kubectl get ingress usermgmt-ingress -w
aws elbv2 describe-load-balancers --region us-east-1

# Traffic verification
curl -H "Host: usermgmt.example.com" http://<alb-dns-name>/usermgmt/health-status
```

### Lab Demos

**Full Ingress Workflow:**
```bash
# 1. Verify ingress class
kubectl get ingressclass

# 2. Create ingress resource
kubectl apply -f ingress.yml

# 3. Check ALB creation status
kubectl describe ingress usermgmt-ingress

# 4. Test application access
curl https://usermgmt.example.com/usermgmt/users
```

## Summary

### Key Takeaways

```diff
+ AWS offers three load balancer types for different architectural needs
+ CLB is default for Kubernetes LoadBalancer services but legacy
+ NLB provides ultra-high performance for TCP/UDP workloads
+ ALB enables advanced HTTP/HTTPS routing via AWS Load Balancer Controller
+ Private node groups provide enterprise security compliance
+ AWS Load Balancer Controller replaces legacy solutions
```

### Quick Reference

**Service Type Selection:**
```yaml
# Classic Load Balancer (Default)
apiVersion: v1
kind: Service
metadata:
  name: my-clb
spec:
  type: LoadBalancer

# Network Load Balancer
apiVersion: v1
kind: Service
metadata:
  name: my-nlb
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
spec:
  type: LoadBalancer  # ALB requires Ingress resource instead
```

**Installation Acceleration:**
```bash
# One-command controller installation
curl -fsSL https://raw.githubusercontent.com/aws-samples/aws-load-balancer-controller-install/main/install.sh | bash
```

### Expert Insight

**Real-world Application**: AWS Load Balancer Controller enables production-grade ingress for microservices with advanced routing, SSL termination, and comprehensive observability.

**Production Considerations**:
- **Cost Optimization**: Use ALB for complex routing vs NLB for high-volume TCP
- **Security**: Implement WAF integration and SSL/TLS best practices
- **Multi-AZ**: Ensure subnets cover all cluster availability zones
- **Monitoring**: Enable CloudWatch metrics and access logs
- **Backup Strategy**: Document and automate ingress configuration recovery

**Common Pitfalls**:
- ❌ Missing IAM permissions causing ALB creation failures
- ❌ Selecting wrong service type for application requirements
- ❌ No ingress class configured leading to controller confusion
- ❌ Subnet configuration issues blocking load balancer deployment
- ❌ SSL certificate ARN misconfigurations