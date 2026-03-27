# Section 1: Course Overview and Resources

<details open>
<summary><b>Section 1: Course Overview and Resources (G3PCS46)</b></summary>

## Table of Contents
- [1.1 Introduction](#11-introduction)
- [1.2 Github Repository](#12-github-repository)
- [Summary Section](#summary-section)

## 1.1 Introduction

### Overview
This introductory module outlines the comprehensive structure of the AWS EKS Kubernetes Masterclass course taught by instructor Kalyan Reddy Daida. The course is designed to take beginners from fundamental concepts to advanced implementation in AWS Elastic Kubernetes Service (EKS), covering Kubernetes principles, AWS integrations, DevOps practices, and microservices architectures. With a duration of approximately 20 hours, the course emphasizes hands-on learning through live demonstrations, YAML template writing, and real-world application scenarios.

### Key Concepts/Deep Dive

#### Course Structure Overview
The course is organized into four major sections:
- **Kubernetes Concepts**: 30 core Kubernetes concepts with live YAML template writing
- **AWS Services Integration**: 18-19 AWS services that integrate with EKS
- **DevOps Concepts**: Implementation of CI/CD pipelines for both applications and Kubernetes manifests
- **Microservices Concepts**: Service discovery, distributed tracing, and canary deployments

#### Fundamental Sections
- **Docker Fundamentals**: Building, pushing, and pulling images; understanding terminology like registries, images, and containers
- **Kubernetes Fundamentals**: Imperative and declarative approaches with practical examples using kubectl commands

#### Storage Section
- **EBS CSI Driver**: Hands-on implementation of deployments, services (ClusterIP, NodePort), environment variables, volumes, and volume mounts
- **RDS Database Integration**: External name services for database connections
- **Storage Classes and Persistent Volume Claims**: Complete storage management concepts
- **EBS vs RDS Comparison**: Understanding advantages and drawbacks of each approach

#### Load Balancing Section
- **Network Architecture**: Workers in private subnets, load balancers in public subnets
- **Classic Load Balancer**: Implementation and testing
- **Network Load Balancer**: Manifest creation and validation
- **Ingress Service with ALB**: Context-based routing, SSL/TLS implementation, HTTP/2 support, HTTPS redirection, and external DNS integration with Route 53

#### Fargate Serverless Section
- **Mixed Mode Deployment**: Running workloads across managed node groups and Fargate profiles
- **Three-Application Demo**: App1 on managed nodes, App2 and UMS on Fargate

#### Elastic Container Registry (ECR)
- **Docker Image Lifecycle**: Building, pushing to ECR, and deploying to Kubernetes
- **Integration with Existing Load Balancers**: Continued use of ingress services

#### DevOps Pipeline Implementation
- **CI/CD Concepts**: Continuous integration, delivery, and deployment
- **Infrastructure as Code**: Automation principles
- **AWS CodeServices**: CodeCommit, CodeBuild, and deployment to EKS
- **Monitoring**: CloudWatch Container Insights integration

#### Microservices Section
- **Service Discovery**: End-to-end implementation with user management and notification microservices
- **Distributed Tracing**: Using AWS X-Ray with demo sets for request flow visualization
- **Canary Deployments**: Traffic distribution (50/50, 75/25) using Kubernetes native features

#### Autoscaling and Monitoring
- **Horizontal Pod Autoscaler (HPA)**: Scaling based on metrics
- **Vertical Pod Autoscaler (VPA)**: Resource optimization
- **Cluster Autoscaler (CA)**: Node group scaling
- **Container Insights**: Detailed monitoring with CloudWatch agent and FluentD demo sets

### Lab Demos
While no specific step-by-step demos are provided in this introductory section, future modules include live template writing for:
- Kubernetes manifest creation
- AWS service integrations
- Pipeline deployments
- Microservices architecture implementation

## 1.2 Github Repository

### Overview
This module introduces the GitHub repositories that accompany the AWS EKS Kubernetes Masterclass course. Three repositories are provided under the StackSimplify organization: the main masterclass repo, a Docker fundamentals repo, and a Kubernetes fundamentals repo. These resources contain comprehensive step-by-step documentation, kubectl commands, Docker images, and all necessary manifests for each section.

### Key Concepts/Deep Dive

#### Repository Structure
- **Main Repository**: AWS EKS Kubernetes Masterclass - Contains all course materials
- **Docker Fundamentals Repository**: Dedicated Docker learning resources
- **Kubernetes Fundamentals Repository**: Focus on core Kubernetes concepts

#### Access Methods
- **Forking**: Clone repositories to your GitHub account for personal modifications
- **ZIP Download**: Download and extract to local machine for offline access

#### kube-manifests Folder
Each section contains a dedicated `kube-manifests` folder holding:
- All Kubernetes YAML manifests
- Deployment specifications
- Service configurations
- Ingress definitions
- Storage classes and persistent volume claims

#### Documentation Approach
Every section includes:
- Detailed step-by-step instructions
- Required kubectl commands
- Docker image specifications
- Troubleshooting guides
- Implementation workflows

### Lab Demos
**Setting Up Course Repositories**
1. Navigate to GitHub and locate StackSimplify organization
2. For each repository (main masterclass, docker-fundamentals, k8s-fundamentals):
   - Click "Fork" button to create personal copy
   - Alternatively, click "Code" → "Download ZIP"
3. If forking, clone to local machine using:
   ```bash
   git clone https://github.com/yourusername/eks-kubernetes-masterclass.git
   ```
4. If downloading ZIP, extract to preferred directory

**Exploring Repository Structure**
1. Open repository in file explorer or IDE
2. Locate `kube-manifests` folder in each section directory
3. Review README files for section-specific instructions
4. Familiarize with manifest YAML structures

```yaml
# Example: Basic structure you'll find in kube-manifests
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: sample-app
  template:
    metadata:
      labels:
        app: sample-app
    spec:
      containers:
      - name: sample-app
        image: nginx:1.21
        ports:
        - containerPort: 80
```

## Summary Section

### Key Takeaways
```diff
+ Comprehensive course coverage: 30 Kubernetes concepts, 18+ AWS services, DevOps pipelines, and microservices
+ Practical learning: Live YAML writing, imperative/declarative approaches, hands-on deployments
+ Resource repository: Structured GitHub repos with step-by-step documentation
+ Progressive complexity: Fundamentals → Storage → Load Balancing → Serverless → DevOps → Advanced patterns
- Requirement: AWS account and basic understanding of containerization recommended
! Preparation needed: Set up AWS CLI, kubectl, and GitHub repositories before starting hands-on sections
```

### Quick Reference
- **Repository URLs**: github.com/stacksimplify (main masterclass, docker-fundamentals, k8s-fundamentals)
- **Key Folders**: `kube-manifests/` in each section
- **Access Methods**: Fork or ZIP download
- **Next Steps**: Create EKS cluster using eksctl

### Expert Insight

#### Real-world Application
Understanding EKS architecture through this comprehensive approach enables you to design production-ready containerized applications that leverage AWS's managed Kubernetes service, integrating multiple services for scalable, secure deployments.

#### Expert Path
Master the fundamentals by implementing concepts immediately upon learning them, then progressively integrate new services. Focus on security (IAM roles, network policies) and cost optimization from day one.

#### Common Pitfalls
- Skipping fundamentals before attempting complex integrations
- Not deploying resources in private subnets for production workloads
- Ignoring SSL/TLS implementation for ingress services
- Underestimating the complexity of microservices communication patterns

</details>
