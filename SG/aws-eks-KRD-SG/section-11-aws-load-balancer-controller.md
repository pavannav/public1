# Section 11: AWS Load Balancer Controller

<details open>
<summary><b>Section 11: AWS Load Balancer Controller (Claude Code)</b></summary>

## Table of Contents

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

## 11.1 EKS-08-00-LBC-01-What-are-we-going-to-learn-AWS-LBC-Ingress

### Overview

Introduction to AWS Load Balancer Controller and Kubernetes Ingress, enabling Application Load Balancer integration for advanced HTTP/HTTPS routing capabilities in the EKS ecosystem.

### Key Concepts

**AWS Load Balancer Controller:**
- Modern Kubernetes controller for AWS load balancer management
- Replaces legacy AWS ALB Ingress Controller with enhanced security and features
- Provides full lifecycle management of ALBs and NLBs
- Integrates directly with EKS cluster architecture

**Kubernetes Ingress:**
- API specification for external access to Kubernetes services
- Enables HTTP/HTTPS routing based on host, path, and other rules
- Supports SSL termination and advanced load balancer features

### Learning Objectives

- Install and configure AWS Load Balancer Controller
- Understand ingress resource specifications
- Implement application load balancing for EKS workloads
- Deploy production-grade ingress solutions

## 11.2 Step-00-02- Ingress Introduction Part 2

### Overview

Deep dive into Kubernetes Ingress resource specifications, including ingress class integration, annotations for cloud-specific features, and TLS certificate management.

### Key Concepts

**Ingress Class Resource:**
- ```yaml
  apiVersion: networking.k8s.io/v1
  kind: IngressClass
  metadata:
    name: aws-load-balancer
  spec:
    controller: ingress.k8s.aws/alb
  ```

**Ingress Annotations:**
- ```yaml
  annotations:
    # ALB Configuration
    alb.ingress.kubernetes.io/load-balancer-name: my-alb
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/scheme: internet-facing
  ```

### Core Components

**1. Ingress Class:**
- Defines which ingress controller handles the resource
- Enables multiple ingress controllers in one cluster
- Supports default class specification

**2. Rules and Backends:**
- Host-based routing (e.g., api.example.com)
- Path-based routing (/api/v1)
- Default backend for unmatched requests
- SSL/TLS termination support

## 11.3 Step-01- Introduction to AWS Load Balancer Controller

### Overview

The AWS Load Balancer Controller is the official solution for integrating Kubernetes ingress with AWS Application Load Balancers, providing advanced HTTP routing capabilities.

### Key Concepts

**Controller Capabilities:**
- **ALB Creation**: Automatic provisioning of Application Load Balancers
- **NLB Support**: Network load balancer creation and management
- **Ingress Integration**: Advanced HTTP/HTTPS routing functionality
- **Security Enhancement**: Direct IAM integration and enhanced credentials

### Benefits Over Legacy Controllers

- **Native AWS Integration**: Full feature parity with AWS ALB capabilities
- **Security First**: Modern IAM policies and fine-grained permissions
- **Active Development**: Community-driven and AWS-supported project
- **Production-Ready**: Enterprise-grade solution for container ingress

## 11.4 Step-02- Verify Pre-requisites

### Overview

Ensuring EKS cluster readiness for AWS Load Balancer Controller deployment, including OIDC provider configuration and necessary AWS permissions.

### Prerequisites Checklist

```yaml
# Required cluster settings
- EKS cluster version: >= 1.14
- OIDC provider enabled: eks.amazonaws.com
- AWS CLI configured with proper permissions
- kubectl configured to access the cluster
- Helm v3 installed (recommended)
```

### Essential Verifications

**Cluster Information:**
```bash
# Check cluster version
kubectl version --output=json

# Verify OIDC provider
aws eks describe-cluster --name eks-demo-one \
  --query "cluster.identity.oidc.issuer"

# Test AWS CLI credentials
aws sts get-caller-identity
```

### Network Prerequisites

**VPC and Subnet Verification:**
```bash
# Get VPC information
aws ec2 describe-vpcs --filters Name=tag:alpha.eksctl.io/cluster-name,Values=eks-demo-one

# Verify subnet configuration
aws ec2 describe-subnets \
  --filters Name=tag:alpha.eksctl.io/cluster-name,Values=eks-demo-one
```

## 11.5 Step-03- Create IAM Policy, IAM Role, k8s service account and annotate it

### Overview

Setting up secure authentication for the AWS Load Balancer Controller using EKS Pod Identity for seamless AWS API access from within the cluster.

### Key Concepts

**EKS Pod Identity Flow:**
1. Create IAM policy with required ALB permissions
2. Create IAM role and attach the policy
3. Create Kubernetes service account
4. Annotate service account with IAM role ARN

### AWS Resources Creation

**IAM Policy (AWSLoadBalancerControllerIAMPolicy):**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "iam:CreateServiceLinkedRole",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeVpcs",
        "ec2:DescribeVpcPeeringConnections",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeInstances",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeTags",
        "elasticloadbalancing:DescribeLoadBalancers",
        "elasticloadbalancing:DescribeLoadBalancerAttributes",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:DescribeListenerCertificates",
        "elasticloadbalancing:DescribeSSLPolicies",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeTargetGroupAttributes",
        "elasticloadbalancing:DescribeTargetHealth",
        "ec2:DescribeSSLPolicies"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cognito-idp:DescribeUserPoolClient",
        "acm:ListCertificates",
        "acm:DescribeCertificate",
        "iam:ListServerCertificates",
        "iam:GetServerCertificate",
        "waf-regional:GetWebACL",
        "waf-regional:GetWebACLForResource",
        "waf-regional:AssociateWebACL",
        "waf-regional:DisassociateWebACL",
        "wafv2:GetWebACL",
        "wafv2:GetWebACLForResource",
        "wafv2:AssociateWebACL",
        "wafv2:DisassociateWebACL",
        "shield:GetSubscriptionState",
        "shield:DescribeProtection",
        "shield:CreateProtection",
        "shield:DeleteProtection",
        "shield:DescribeSubscription",
        "shield:ListProtections",
        "shield:ListResourcesForWebACL",
        "shield:AssociateDRTLogBucket",
        "shield:AssociateDRTRole",
        "ec2:AssociateRouteTable",
        "ec2:CreateRoute",
        "ec2:CreateSecurityGroup",
        "ec2:CreateSubnet",
        "ec2:CreateVpc",
        "ec2:DeleteRoute",
        "ec2:DeleteRouteTable",
        "ec2:DeleteSecurityGroup",
        "ec2:DeleteSubnet",
        "ec2:DeleteVpc",
        "ec2:ModifyRoute",
        "ec2:CreateNatGateway",
        "ec2:DeleteNatGateway",
        "ec2:CreateNetworkAcl",
        "ec2:CreateNetworkAclEntry",
        "ec2:DeleteNetworkAcl",
        "ec2:DeleteNetworkAclEntry",
        "ec2:ReplaceNetworkAclAssociation",
        "ec2:ReplaceNetworkAclEntry",
        "ec2:DescribeNetworkAcls",
        "ec2:ModifyNetworkAclEntry",
        "ec2:DescribeRouteTables",
        "ec2:ReplaceRouteTableAssociation",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:CreateInternetGateway",
        "ec2:DeleteInternetGateway",
        "ec2:AttachInternetGateway",
        "ec2:DetachInternetGateway",
        "ec2:ModifyVpcAttribute",
        "ec2:DescribeVpcAttribute",
        "ec2:ModifySubnetAttribute",
        "elasticloadbalancing:CreateListener",
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:CreateRule",
        "elasticloadbalancing:CreateTargetGroup",
        "elasticloadbalancing:DeleteListener",
        "elasticloadbalancing:DeleteLoadBalancer",
        "elasticloadbalancing:DeleteRule",
        "elasticloadbalancing:DeleteTargetGroup",
        "elasticloadbalancing:ModifyListener",
        "elasticloadbalancing:ModifyLoadBalancerAttributes",
        "elasticloadbalancing:ModifyRule",
        "elasticloadbalancing:ModifyTargetGroup",
        "elasticloadbalancing:ModifyTargetGroupAttributes",
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets",
        "iam:GetRole",
        "iam:CreateServiceLinkedRole"
      ],
      "Resource": "*"
    }
  ]
}
```

### Kubernetes Service Account

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::ACCOUNT-ID:role/AmazonEKSLoadBalancerControllerRole
```

## 11.6 Step-04- Install AWS Load Balancer Controller using HELM

### Overview

Deploying the AWS Load Balancer Controller using Helm with proper cluster configuration, service account associations, and regional settings.

### Installation Process

**Add Helm Repository:**
```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update
```

**Install Controller:**
```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  --namespace kube-system \
  --set clusterName=eks-demo-one \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set image.repository=public.ecr.aws/eks/aws-load-balancer-controller \
  --version v2.7.0
```

### Configuration Parameters

```yaml
# Key configuration options
clusterName: eks-demo-one                    # EKS cluster name
serviceAccount:
  create: false                              # Use existing service account
  name: aws-load-balancer-controller          # Existing SA name
image:
  repository: public.ecr.aws/eks/aws-load-balancer-controller
vpcId: ""                                    # Auto-discover VPC
region: ""                                   # Auto-discover region
```

## 11.7 Step-05- Verify AWS LBC Deployment and WebHook Service

### Overview

Comprehensive verification of AWS Load Balancer Controller deployment including pod health, service account permissions, and webhook configurations.

### Verification Steps

**Controller Pod Status:**
```bash
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

NAME                                                    READY   STATUS    RESTARTS   AGE
aws-load-balancer-controller-65b85cdfb6-vhf7l          1/1     Running   0          2m
```

**Service Account Verification:**
```bash
kubectl get serviceaccounts aws-load-balancer-controller -n kube-system -o yaml

# Check role annotation
kubectl describe serviceaccount aws-load-balancer-controller -n kube-system
```

**Webhook Configuration:**
```bash
kubectl get validatingwebhookconfigurations aws-load-balancer-webhook -o yaml

# Check webhook status
kubectl describe validatingwebhookconfiguration aws-load-balancer-webhook
```

### Log Analysis

**Review Controller Logs:**
```bash
kubectl logs -n kube-system deployment/aws-load-balancer-controller

# Look for successful initialization
"controller-runtime.metrics" level=info msg="Metrics server is starting to listen" addr=":8080"
"Starting Controller" controller="alb-ingress-controller"
```

### Common Issues and Solutions

**Permission Issues:**
```diff
- IAM role not properly attached to service account
- OIDC provider not enabled on cluster
- Missing IAM permissions in policy
- Incorrect role ARN in annotation

# Solution: Verify role attachment
aws iam get-role --role-name AmazonEKSLoadBalancerControllerRole
```

**Network Issues:**
```diff
- VPC not properly configured
- Subnets not tagged for load balancer
- Security groups blocking traffic

# Solution: Verify subnets
aws ec2 describe-subnets --filters Name=vpc-id,Values=YOUR-VPC-ID
```

## 11.8 Step-06- LBC Service Account and TLS Cert Internals

### Overview

Understanding the internal mechanics of service account authentication and TLS certificate management for secure webhook operations.

### Service Account Authentication

**Pod Identity Flow:**
1. Kubernetes generates JWT token for service account
2. Token exchanged for temporary AWS credentials via STS
3. Controller uses temporary credentials to call AWS APIs
4. Credentials automatically refreshed (valid for 12 hours)

### TLS Certificate Management

**Webhook Certificates:**
- Kubernetes CA signs webhook certificates
- Automatic certificate rotation
- Mutual TLS authentication for webhook calls
- Certificate validity monitoring and renewal

## 11.9 Step-06-02- Uninstall Load Balancer Controller Command SHOULD NOT BE EXECUTED

### Overview

Cleanup commands for Load Balancer Controller removal (marked as SHOULD NOT BE EXECUTED in production environments).

### Warning: Destructive Operations

**Uninstall Commands (DO NOT EXECUTE in production):**
```bash
# Helm uninstall
helm uninstall aws-load-balancer-controller -n kube-system

# Remove IAM resources
aws iam detach-role-policy \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --policy-arn arn:aws:iam::account:policy/AWSLoadBalancerControllerIAMPolicy

aws iam delete-role --role-name AmazonEKSLoadBalancerControllerRole
aws iam delete-policy --policy-arn arn:aws:iam::account:policy/AWSLoadBalancerControllerIAMPolicy

# Remove service account
kubectl delete serviceaccount aws-load-balancer-controller -n kube-system
```

### Safely Removing Controller

```bash
# 1. Verify no active ingress resources
kubectl get ingress --all-namespaces

# 2. Backup ingress configurations
kubectl get ingress -o yaml > ingress-backup.yaml

# 3. Scale controller to zero during maintenance
kubectl scale deployment aws-load-balancer-controller --replicas=0 -n kube-system

# 4. Perform removal only after confirming no dependencies
```

## 11.10 Step-07- Introduction to Kubernetes Ingress Class Resource

### Overview

IngressClass resources enable management of multiple ingress controllers within a single cluster, providing clear controller association and default behavior.

### Key Concepts

**IngressClass Definition:**
- Links ingress resources to specific controllers
- Enables multi-controller environments
- Supports default class specification
- Provides controller-specific configuration

### IngressClass Resource

```yaml
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: aws-load-balancer
  annotations:
    ingressclass.kubernetes.io/is-default-class: "true"
spec:
  controller: ingress.k8s.aws/alb
  parameters:
    apiGroup: elbv2.k8s.aws
    kind: IngressClassParams
    name: default-alb
```

### Benefits

- **Multi-Controller Support**: Different ingress controllers per application
- **Migration Strategy**: Gradual transition between controllers
- **Resource Segmentation**: Environment-specific controller configuration
- **Operational Clarity**: Clear ingress-to-controller mapping

## 11.11 Step-08- Deploy Ingress and Verify

### Overview

Creating production ingress resources that automatically provision ALBs with integrated routing and traffic management capabilities.

### Basic Ingress Deployment

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: simple-app-ingress
  namespace: default
spec:
  ingressClassName: aws-load-balancer
  rules:
  - host: app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80
```

### Load Balancer Creation Process

1. **Ingress Deployment**: `kubectl apply -f ingress.yaml`
2. **ALB Provisioning**: Controller creates Application Load Balancer
3. **Target Group Creation**: TG created for each service backend
4. **Listener Configuration**: HTTP/HTTPS listeners configured
5. **DNS Resolution**: ALB DNS name becomes available

### Verification Process

```bash
# Monitor ingress creation
kubectl get ingress simple-app-ingress -w

# Verify ALB creation
aws elbv2 describe-load-balancers --region us-east-1 \
  --query 'LoadBalancers[?contains(DNSName, `app`)].{Name:Name, DNS:DNSName, State:State.Code}'

# Test application access
curl -H "Host: app.example.com" http://<alb-dns-name>/
```

### Advanced Ingress Features

**Multi-path, Multi-host Configuration:**
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: complex-app-ingress
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: production-alb
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/scheme: internet-facing
spec:
  ingressClassName: aws-load-balancer
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /api/v1
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
  - host: web.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

## Summary

### Key Takeaways

```diff
+ AWS Load Balancer Controller provides enterprise ALB integration for Kubernetes
+ Ingress resources enable sophisticated HTTP routing and traffic management
+ IAM Pod Identity replaces complex authentication mechanisms
+ IngressClass resources support multi-controller environments
+ Complete ALB lifecycle managed through Kubernetes API
```

### Quick Reference

**Installation One-Liner:**
```bash
# Automated installation script
curl -fsSL https://raw.githubusercontent.com/aws-samples/aws-load-balancer-controller-install/main/install.sh | bash
```

**Essential Commands:**
```bash
# Controller status
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller

# Ingress verification
kubectl get ingress --all-namespaces
kubectl describe ingress <ingress-name>

# ALB verification
aws elbv2 describe-load-balancers
aws elbv2 describe-target-groups
```

### Expert Insight

**Production Architecture**: AWS Load Balancer Controller enables cloud-native ingress with self-healing infrastructure, automatic scaling, and deep AWS service integration.

**Expert Path**:
- Implement cross-zone load balancing for high availability
- Configure ALB access logs and metrics for observability
- Use WAF integration for enhanced security
- Implement blue-green deployments with ingress modifications
- Leverage NLB annotations for TCP-based applications

**Common Pitfalls**:
- ❌ Missing ingress class configuration causing routing failures
- ❌ Insufficient IAM permissions blocking ALB creation
- ❌ Incorrect subnet tagging preventing ALB placement
- ❌ Security group rules blocking health check traffic
- ❌ Misconfigured health check paths causing pod termination