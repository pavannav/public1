# Section 1: Course Introduction (AWS EKS Masterclass)

<details open>
<summary><b>Section 1: Course Introduction (AWS EKS Masterclass)</b></summary>

## Table of Contents
1. [1.1 Introduction](#11-introduction)
2. [1.2 GitHub Repository](#12-github-repository)

---

## 1.1 Introduction

### Overview
Welcome to the AWS EKS Kubernetes Masterclass taught by Kalyan Reddy Daida. This comprehensive 20+ hour course covers Kubernetes fundamentals, AWS integrations, DevOps practices, and microservices implementation using AWS Elastic Kubernetes Service (EKS).

### Key Concepts

#### Course Structure
The course is organized into four major sections:

1. **Kubernetes Concepts** (30+ concepts covered)
   - Live YAML template writing for declarative approaches
   - Imperative commands for practical understanding
   - Core Kubernetes resources: pods, replica sets, deployments, services

2. **AWS Service Integrations** (18+ AWS services)
   - EKS, Fargate, ECR, ELB (ALB, NLB, CLB)
   - Certificate Manager, Route 53
   - EBS, RDS, and other storage/monitoring services

3. **DevOps Concepts**
   - CI/CD pipelines using AWS Code Services
   - Infrastructure as Code
   - Application and manifest deployment automation

4. **Microservices Architecture**
   - Service discovery
   - Distributed tracing with AWS X-Ray
   - Canary deployments

#### Infrastructure Journey
```diff
! Client Request → Node → Kube Proxy → [Routing Logic] → Correct Pod
```

#### Key Milestones Covered
- Docker fundamentals (images, containers, registries)
- Kubernetes architecture and resources
- EKS storage with EBS CSI driver and RDS
- Load balancing (CLB, NLB, ALB with Ingress)
- Serverless with EKS Fargate
- Container registry operations
- DevOps pipelines and monitoring
- Microservices patterns and distributed systems

### Lab Demos Included
- Docker image building and registry operations
- Complete Kubernetes manifests (deployments, services)
- Multi-tier application deployments
- Load balancer configurations with SSL/certificate management
- Service mesh and ingress routing scenarios
- Monitoring and logging with CloudWatch Container Insights

---

## 1.2 GitHub Repository

### Overview
The course provides three essential GitHub repositories under the StackSimplify organization, plus additional supporting repositories for specific topics.

### Key Concepts

#### Available Repositories
1. **AWS EKS Kubernetes Masterclass**
   - Main course repository
   - Contains all section materials and manifests

2. **Docker Fundamentals**
   - Dedicated repository for Docker concepts
   - Hands-on exercises and examples

3. **Kubernetes Fundamentals**
   - Comprehensive K8s foundation content
   - Terminal practices and YAML examples

#### Repository Structure
```yaml
├── kube-manifests/
│   ├── docker-fundamentals/
│   ├── kubernetes-fundamentals/
│   ├── eks-storage/
│   ├── load-balancing/
│   └── microservices/
├── docker/
├── eks-code-pipeline/
└── monitoring/
```

### Important Notes

> [!IMPORTANT]
> Every course section contains a `kube-manifests` folder with ready-to-deploy Kubernetes manifests.

#### Getting Started Options
- **Fork**: Maintain your own copy in GitHub
- **Download**: Get as ZIP for local development
- All materials include step-by-step instructions

> [!NOTE]
> The `kube-manifests` folder serves as the central location for all Kubernetes YAML files throughout the entire course.

---

## Summary

### Key Takeaways
```diff
+ Comprehensive coverage of AWS EKS from fundamentals to expert level
+ 30+ hands-on K8s concepts with live template writing
+ 18+ AWS service integrations with EKS
+ Complete DevOps and microservices implementation
- Requires significant time investment (20+ hours)
- AWS account and compute costs involved
```

### Quick Reference
- **Main Repository**: github.com/stack-simplify/aws-eks-kubernetes-masterclass (fictional)
- **Docker Repository**: stack-simplify/docker-fundamentals (fictional)
- **K8s Repository**: stack-simplify/kubernetes-fundamentals (fictional)

### Expert Insight

#### Real-world Application
Perfect for developers, DevOps engineers, and architects looking to master cloud-native application deployment on AWS using Kubernetes.

#### Expert Path
Start with Docker fundamentals, then progress through Kubernetes imperative approaches before tackling AWS EKS specifics and advanced patterns.

#### Common Pitfalls
- Underestimating AWS resource costs during hands-on exercises
- Skipping Docker fundamentals before Kubernetes sections
- Not following repository setup instructions precisely

</details>