# Section 24: EKS DevOps Pipeline Implementation

<details open>
<summary><b>Section 24: EKS DevOps Pipeline Implementation (G3PCS46)</b></summary>

## Table of Contents

- [24.1 EKS DevOps Introduction](#241-eks-devops-introduction)
- [24.2 What We Are Going to Learn](#242-what-we-are-going-to-learn)
- [24.3 Pre-requisite Check](#243-pre-requisite-check)
- [24.4 Create AWS ECR Registry and GitHub Repo](#244-create-aws-ecr-registry-and-github-repo)
- [24.5 Build Stage- AWS CodeBuild Introduction](#245-build-stage--aws-codebuild-introduction)
- [24.6 Build Stage- Review buildspec-build.yml](#246-build-stage--review-buildspec-buildyml)
- [24.7 Build Stage- Create GitHub Connection](#247-build-stage--create-github-connection)
- [24.8 Build Stage- AWS CodePipeline Introduction](#248-build-stage--aws-codepipeline-introduction)
- [24.9 Build Stage- Create CodePipeline for Build Stage](#249-build-stage--create-codepipeline-for-build-stage)
- [24.10 Build Stage- Update CodeBuild Role and Run Pipeline](#2410-build-stage--update-codebuild-role-and-run-pipeline)
- [24.11 Deploy Stage- Review buildspec-deploy.yml](#2411-deploy-stage--review-buildspec-deployyml)
- [24.12 Deploy Stage- Create Deploy Stage in Pipeline](#2412-deploy-stage--create-deploy-stage-in-pipeline)
- [24.13 Deploy Stage- Create STS Assume IAM Role](#2413-deploy-stage--create-sts-assume-iam-role)
- [24.14 Deploy Stage- Update aws-auth configmap and create STS policy](#2414-deploy-stage--update-aws-auth-configmap-and-create-sts-policy)
- [24.15 Deploy Stage- Test End to End Pipeline](#2415-deploy-stage--test-end-to-end-pipeline)
- [24.16 Approval Stage- Create and Test](#2416-approval-stage--create-and-test)
- [24.17 Fix for Alternate Build Stage Failures](#2417-fix-for-alternate-build-stage-failures)
- [24.18 Clean-Up](#2418-clean-up)

## 24.1 EKS DevOps Introduction

### Overview
This lecture introduces core DevOps concepts including continuous integration (CI) and continuous delivery (CD) on AWS EKS using tools like CodeCommit, CodeBuild, and CodePipeline.

### Key Concepts

#### Release Process Stages
- **Source Stage**: Check-in source code to version control repository (GitHub), peer reviews, pull requests
- **Build Stage**: Compile code, build artifacts (WAR/JAR files, container images, K8s manifests), perform unit testing
- **Test Stage**: Integration testing, load testing, UI testing, security testing across QA/staging environments
- **Production Stage**: Deploy to production, monitor for errors

#### Continuous Integration vs Continuous Delivery
- **CI**: Belongs to source and build stages - automatically kick-off new releases on code check-in, build/test in consistent environments, maintain deployable artifacts
- **CD**: Belongs to test and production stages - deploy changes to staging safely, faster delivery, increased frequency, reduced rollback risk

#### AWS Code Services Integration
- **CodeCommit/GitHub**: Version control (replacing CodeCommit for broader adoption)
- **CodeBuild**: Build artifacts, integrate with third-party testing tools
- **CodePipeline**: Orchestrate CI/CD pipelines from source to production

#### Infrastructure as Code
- Automate everything using CloudFormation templates checked into source control
- Apply to all stages: source, build, test, production

#### Monitoring with AWS Code Services
- **CloudWatch Container Insights**: End-to-end monitoring of containerized applications and Kubernetes infrastructure

### Code/Config Blocks
```yaml
# Example CloudFormation template structure for IaC
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  # Infrastructure automation resources
```

### Lab Demos
The hands-on implementation will demonstrate:
- Setting up CI/CD pipeline using AWS CodePipeline
- Building containerized applications
- Deploying to EKS clusters
- End-to-end pipeline execution from code commit to production

## 24.2 What We Are Going to Learn

### Overview
This section outlines the complete EKS DevOps pipeline implementation using AWS developer tools and GitHub for CI/CD on Kubernetes clusters.

### Key Concepts

#### Complete Pipeline Architecture
- **Source**: GitHub repository with application code and Kubernetes manifests
- **Build**: AWS CodeBuild for container image creation and artifact generation  
- **Deploy**: AWS CodeBuild for Kubernetes deployment to EKS clusters
- **Approval**: Manual deployment approval using SNS notifications

#### AWS Services Integration
- **Elastic Container Registry (ECR)**: Private Docker registry for container images
- **CodePipeline**: Orchestrates entire CI/CD workflow
- **CodeBuild**: Manages build and deployment processes
- **IAM Roles**: Secure access control for cross-service communication
- **CloudWatch**: Comprehensive monitoring and logging

#### Application Components
- **Static Nginx Application**: Simple HTML application for demonstration
- **Dockerfile**: Containerization of the application
- **Kubernetes Manifests**: Deployment configuration for EKS
- **Build Specifications**: YAML files defining build and deployment stages

#### Security and Access Management
- **STS Assume Roles**: Temporary credential generation for kubectl access
- **AWS Auth ConfigMap**: IAM role integration with Kubernetes RBAC
- **Policy Attachments**: Least-privilege access to AWS resources

### Code/Config Blocks
```dockerfile
# Dockerfile example
FROM nginx:latest
COPY app1 /usr/share/nginx/html/app1
```

```yaml
# K8s Deployment example
apiVersion: apps/v1
kind: Deployment
metadata:
  name: eks-devops-deployment
spec:
  template:
    spec:
      containers:
      - image: ${CONTAINER_IMAGE}
        ports:
        - containerPort: 80
```

## 24.3 Pre-requisite Check Before Implementing EKS DevOps Pipeline

### Overview
Before implementing the CI/CD pipeline, verify that the EKS environment is properly configured with all required controllers and components for successful deployment.

### Key Concepts

#### EKS Cluster Validation
- Verify AWS Load Balancer Controller pod is running in kube-system namespace
- Confirm External DNS controller pod availability in default namespace
- Ensure Controllers are functioning correctly

#### Kubernetes Manifest Preparation
- **Deployment**: Simple nginx deployment with container image placeholder
- **Service**: NodePort service for internal communication
- **Ingress**: Application Load Balancer ingress with SSL/TLS termination

#### Prerequisite Testing Process
1. Retrieve ALB-Ingress manifests and update with certificate ARN
2. Update DNS hostnames for your domain
3. Temporarily comment out ECR image references
4. Uncomment pre-built GitHub package image for testing
5. Apply manifests and verify deployment
6. Check external DNS logs for Route53 record creation
7. Validate end-to-end accessibility via HTTPS

#### Environment-Specific Configurations
- Certificate ARN from AWS Certificate Manager
- Domain DNS names compatible with hosted zones
- Routing configuration for load balancer endpoints

### Code/Config Blocks
```bash
# Verify controller status
kubectl get pods -n kube-system | grep aws-load-balancer-controller
kubectl get pods -n default | grep external-dns

# Apply and verify manifests
kubectl apply -f kube-manifests/
kubectl get pods,svc,ingress -o wide
```

```yaml
# ALB Ingress example (SNIPPET)
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:region:account:certificate/id
spec:
  ingressClassName: alb
  rules:
  - host: eksdevops1.yourdomain.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: eks-devops-service
            port:
              number: 80
```

### Lab Demos
✅ Check external DNS logs for Route53 automation:
```bash
kubectl logs -f deployment/external-dns -n default | grep eksdevops
```

✅ Access application via browser after ALB provisioning completes

## 24.4 Create AWS ECR Registry and GitHub Repo

### Overview
Create the foundational components for the CI/CD pipeline: private Elastic Container Registry for Docker images and a GitHub repository for source code management.

### Key Concepts

#### GitHub vs CodeCommit Migration
- **AWS CodeCommit Deprecation**: Primary service now unavailable for new customers
- **GitHub Adoption**: Industry-standard version control with broad ecosystem support
- **Connectivity**: Secure AWS-to-GitHub integration using AWS Connector app

#### ECR Repository Setup
- **Repository Name**: eks-devops (standardized naming convention)
- **Image Mutability**: Immutable for version control and traceability
- **Tag Scanning**: Optional security scanning for vulnerabilities

#### GitHub Repository Initialization
- **Repository Structure**: Public availability for learning community access
- **Version Control Workflow**: Local Git operations → GitHub synchronization
- **Content Organization**: Application code, manifests, build specifications

### Code/Config Blocks
```bash
# Git repository initialization workflow
mkdir aws-eks-devops && cd aws-eks-devops
git init
git remote add origin https://github.com/username/aws-eks-devops.git
cp -r /path/to/github-files/* ./
git add .
git commit -m "Base commit"
git push -u origin main
```

### Lab Demos
The demonstration covers:
- ECR repository creation with immutable tagging configuration
- GitHub repository setup with appropriate permissions
- Initial code commit with complete project structure
- Verification of repository accessibility and contents

## 24.5 Build Stage- AWS CodeBuild Introduction

### Overview
Understanding AWS CodeBuild as the core component for build and deployment processes in the CI/CD pipeline, providing managed containerized build environments.

### Key Concepts

#### CodeBuild Architecture Fundamentals
- **Managed Build Service**: Eliminate need for custom build server provisioning/scaling
- **Prepackaged Environments**: Support for popular languages and build tools (Apache Maven, Java, Node.js, Python)
- **Custom Environment Support**: Extend with custom Docker images if needed

#### Pipeline Integration Methods
- **Manual Execution**: Directly from AWS Console, CLI, or SDK
- **CodePipeline Orchestration**: Automated triggering based on source changes
- **Event-Driven Architecture**: CloudWatch Events for pipeline state management

#### Build Environment Configuration
- **Docker Container Runtime**: Isolated and consistent build execution
- **Resource Scaling**: Automatic scaling based on build demand
- **Artifact Management**: Built-in S3 integration for output storage

#### Build Lifecycle Phases
- **Install**: Dependency installation and prerequisite setup
- **Pre-build**: Authentication and environment preparation
- **Build**: Core compilation and artifact generation
- **Post-build**: Artifact packaging and storage

### Code/Config Blocks
```yaml
# Buildspec.yaml structure template
version: 0.2
env:
  variables:
    # Environment-specific variables
phases:
  install:
    commands:
      # Prerequisite installations
  pre_build:
    commands:
      # Authentication and setup
  build:
    commands:
      # Core build operations
  post_build:
    commands:
      # Cleanup and packaging
artifacts:
  files:
    # Output artifact definitions
```

### Lab Demos
Focus areas include understanding build environment selection, artifact lifecycle management, and integration patterns with source control systems.

## 24.6 Build Stage- Review buildspec-build.yml file

### Overview
Detailed examination of the build specification file that defines the container image creation and artifact generation process using AWS CodeBuild.

### Key Concepts

#### Environment Variable Configuration
- **IMAGE_URI**: ECR repository endpoint (account and region specific)
- **IMAGE_TAG**: Dynamic tag based on Git commit hash (first 7 characters)
- **Export Mechanism**: Exported variables for downstream pipeline stages

#### Build Lifecycle Implementation

**Install Phase**: No custom dependencies required (Amazon Linux 2 image includes Docker)

**Pre-build Phase**:
```bash
export IMAGE_TAG=$CODEBUILD_RESOLVED_SOURCE_VERSION
aws ecr get-login-password | docker login --username AWS --password-stdin $IMAGE_URI
```

**Build Phase**:
```bash
docker build -t $IMAGE_URI:$IMAGE_TAG .
```

**Post-build Phase**:
```bash
docker push $IMAGE_URI:$IMAGE_TAG
echo "IMAGE_URI=$IMAGE_URI" > exported-vars.env
echo "IMAGE_TAG=$IMAGE_TAG" >> exported-vars.env
```

#### Artifact Definitions
- **exported-vars.env**: Environment variables for deployment phase
- **buildspec-deploy.yml**: Deployment specification file
- **kube-manifests/**: Kubernetes deployment manifests

### Code/Config Blocks
```yaml
version: 0.2

env:
  variables:
    IMAGE_URI: "your-account-id.dkr.ecr.us-east-1.amazonaws.com/eks-devops"
  exported-variables:
    - IMAGE_URI
    - IMAGE_TAG

phases:
  install:
    runtime-versions:
      # No custom installations needed
  
  pre_build:
    commands:
      - IMAGE_TAG=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c1-7)
      - aws ecr get-login-password | docker login --username AWS --password-stdin $IMAGE_URI
  
  build:
    commands:
      - docker build -t $IMAGE_URI:$IMAGE_TAG .
  
  post_build:
    commands:
      - docker push $IMAGE_URI:$IMAGE_TAG
      - echo "IMAGE_URI=$IMAGE_URI" > $CODEBUILD_SRC_DIR/exported-vars.env
      - echo "IMAGE_TAG=$IMAGE_TAG" >> $CODEBUILD_SRC_DIR/exported-vars.env

artifacts:
  files:
    - 'exported-vars.env'
    - 'kube-manifests/**/*'
    - 'buildspec-deploy.yml'
```

### Lab Demos
The build process demonstrates:
- GitHub commit ID correlation with container image tags
- ECR authentication and image push operations
- Artifact export strategy for Pipeline continuation
- Integration between build and deployment stages

## 24.7 Build Stage- Create GitHub Connection from AWS Developer Tools

### Overview
Establish secure connectivity between AWS CodePipeline and GitHub repositories using AWS Developer Tools connections for webhook-based CI/CD triggering.

### Key Concepts

#### OAuth Application Installation
- **GitHub App**: AWS Connector for secure API access without storing credentials
- **Repository Permissions**: Granular access control for specific repositories
- **Webhook Integration**: Automatic pipeline triggering on Git events

#### Connection Configuration
- **Connection Name**: eks-devops-github-connection (descriptive naming)
- **Provider Selection**: GitHub (version 2) for modern API access
- **Repository Authorization**: Selective access to avoid over-permissive configurations

#### Security Considerations
- **Two-Factor Authentication**: Required for connection validation
- **Scoped Access**: Only authorized repositories accessible by AWS services
- **Connection Status**: Active monitoring of connection health and permissions

### Code/Config Blocks
```bash
# Connection verification (read-only)
aws codestar-connections get-connection --connection-arn arn:aws:codestar-connections:region:account:connection/connection-id
```

```json
# Connection metadata structure
{
  "ConnectionArn": "arn:aws:codestar-connections:us-east-1:123456789012:connection/eks-devops-github-connection",
  "ProviderType": "GitHub",
  "Status": "AVAILABLE",
  "OwnerAccountId": "123456789012"
}
```

### Lab Demos
Hands-on steps include:
- GitHub OAuth app authorization workflow
- Repository access configuration in GitHub settings
- AWS connection validation and status verification
- Webhook creation for push event triggering

## 24.8 Build Stage- AWS CodePipeline Introduction

### Overview
Explore AWS CodePipeline as the orchestration engine that coordinates source control, build, and deployment processes into a cohesive CI/CD workflow.

### Key Concepts

#### Continuous Delivery Lifecycle
- **Automated Release Processes**: Model, visualize, and automate software delivery
- **Quality Gates**: Consistent release workflows across environments
- **Delivery Acceleration**: Reduced time-to-market while maintaining quality standards

#### Pipeline Stage Architecture
- **Source Stage**: GitHub webhook integration for change detection
- **Build Stage**: CodeBuild containerized compilation environments
- **Deploy Stage**: Infrastructure-as-code deployment to production
- **Approval Stages**: Manual quality gates and compliance checks

#### External Tools Integration
- **Source Providers**: GitHub, GitLab, Bitbucket, AWS CodeCommit
- **Build Systems**: AWS CodeBuild, Jenkins, CloudBees
- **Deployment Targets**: ECS, EKS, CloudFormation, Elastic Beanstalk

#### Monitoring and Observability
- **Pipeline Dashboard**: Visual progress tracking and bottleneck identification
- **Execution History**: Audit trail and failure analysis capabilities
- **CloudWatch Events**: Alerting and integration with enterprise monitoring systems

### Code/Config Blocks
```yaml
# CloudFormation pipeline definition snippet
Resources:
  EKSDevOpsPipeline:
    Type: AWS::CodePipeline::Pipeline
    Properties:
      Stages:
        - Name: Source
          Actions:
            - Name: SourceAction
              ActionTypeId:
                Category: Source
                Owner: AWS
                Provider: GitHub
        - Name: Build  
          Actions:
            - Name: BuildAction
              ActionTypeId:
                Category: Build
                Owner: AWS
                Provider: CodeBuild
        # Additional stages...
```

### Lab Demos
The introduction covers architectural patterns, integration capabilities, and monitoring strategies for complex deployment pipelines.

## 24.9 Build Stage- Create CodePipeline for build stage

### Overview
Implement the initial CodePipeline configuration focusing on source and build stages, establishing the foundation for the complete CI/CD workflow.

### Key Concepts

#### Pipeline Configuration Strategy
- **Progressive Implementation**: Start with core source and build stages
- **Iterative Enhancement**: Add deployment and approval stages incrementally
- **Resource Naming Convention**: Suffix numbers (551) for easy identification and testing

#### Source Stage Setup
- **Provider**: GitHub via AWS Connector app
- **Repository**: aws-eks-devops with main branch monitoring
- **Trigger Mechanism**: Automatic pipeline execution on push events
- **Output Artifacts**: Source code bundle passed to build stage

#### Build Stage Configuration
- **CodeBuild Project**: build-eks-devops-551 (auto-created during pipeline setup)
- **Environment**: Amazon Linux 2 with standard runtime
- **Buildspec Location**: buildspec-build.yml in repository root
- **Artifact Management**: Exported variables and manifests for downstream use

#### Error Handling Considerations
- **Build Project Creation**: Potential UI timeout issues during initial setup
- **Project Verification**: Manual validation of CodeBuild project parameters
- **Pipeline Recreation**: Handle race conditions in AWS resource provisioning

### Code/Config Blocks
```yaml
# Pipeline stage definitions (Source + Build)
pipeline:
  name: eks-devops-pipeline-551
  roleArn: arn:aws:iam::account:role/service-role/AWSCodePipelineServiceRole
  stages:
    - name: Source
      actions:
        - name: Source
          actionTypeId:
            category: Source
            owner: AWS
            provider: GitHub
          configuration:
            ConnectionArn: arn:aws:codestar-connections:region:account:connection/connection-id
            FullRepositoryId: username/aws-eks-devops
            BranchName: main
          outputArtifacts:
            - name: SourceArtifact
          runOrder: 1
    
    - name: Build  
      actions:
        - name: Build
          actionTypeId:
            category: Build
            owner: AWS
            provider: CodeBuild
          configuration:
            ProjectName: build-eks-devops-551
          inputArtifacts:
            - name: SourceArtifact
          outputArtifacts:
            - name: BuildArtifact
          runOrder: 1
```

### Lab Demos
The implementation demonstrates:
- GitHub connection integration workflow
- CodeBuild project creation through Pipeline interface
- Initial pipeline execution and build verification
- Troubleshooting common setup issues and workarounds

## 24.10 Build Stage- Update CodeBuild Role and Run pipeline and verify

### Overview
Configure IAM permissions for the CodeBuild service role and execute the pipeline to validate the build stage functionality, resolving access issues to ECR and logs.

### Key Concepts

#### IAM Role Permission Updates
- **EC2ContainerRegistryFullAccess**: Required for ECR image operations (pull/push)
- **CloudWatchLogsFullAccess**: Essential for build log streaming and retention
- **Service Role Modification**: build-eks-devops-551-service-role updates

#### Pipeline Execution Verification
- **Source Resolution**: GitHub commit triggers automatic pipeline execution
- **Build Phase Monitoring**: Real-time log analysis for troubleshooting
- **Artifact Generation**: ECR image creation and artifact export validation
- **Retry Mechanism**: Built-in failure recovery for transient issues

#### Docker Image Management
- **Registry Authentication**: Secure ECR login using temporary credentials
- **Image Tagging Strategy**: Commit-based versioning for traceability
- **Layer Caching**: Optimized builds using Docker layer caching

### Code/Config Blocks
```bash
# IAM role policy attachment
aws iam attach-role-policy \
  --role-name build-eks-devops-551-service-role \
  --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess

aws iam attach-role-policy \
  --role-name build-eks-devops-551-service-role \
  --policy-arn arn:aws:iam::aws:policy/CloudWatchLogsFullAccess
```

```yaml
# Build log phases verification
phases:
  install:
    commands:
      # Base image preparation
  pre_build:
    commands:
      - aws ecr get-login-password | docker login...
      - IMAGE_TAG extraction logic
  build:
    commands:
      - docker build -t image:tag .
  post_build:
    commands:
      - docker push image:tag
      - Artifact export operations
```

### Lab Demos
Verification steps include:
- ECR repository authentication testing
- Build log analysis for each phase execution
- Docker image push confirmation in ECR
- Exported artifacts validation in pipeline artifacts

## 24.11 Deploy Stage- Review buildspec-deploy.yml

### Overview
Analyze the deployment specification that handles the Kubernetes manifest updates and application rollout to the EKS cluster using CodeBuild execution.

### Key Concepts

#### Deployment Stage Architecture
- **Environment Variables**: Cluster-specific configuration (EKS name, IAM roles)
- **Artifact Sourcing**: Build artifacts (exported-vars.env) provide image metadata
- **Kubernetes Operations**: kubectl-based manifest application and verification

#### Buildspec Phases Breakdown

**Pre-build Phase**:
- Source environment variables from previous build artifacts
- Update Kubernetes deployment manifests with new container image
- Dynamic manifest modification using sed commands

**Build Phase**:
- AWS CLI-based kubeconfig configuration
- IAM role assumption for temporary cluster access credentials
- Kubernetes manifest deployment and rollout monitoring

**Post-build Phase**:
- Resource verification (pods, services, ingress)
- Deployment status confirmation

### Code/Config Blocks
```yaml
version: 0.2

env:
  variables:
    EKS_CLUSTER_NAME: "your-eks-cluster"
    EKS_KUBECTL_ROLE_ARN: "arn:aws:iam::account:role/EKSCodeBuildKubectlRole"

phases:
  pre_build:
    commands:
      - source exported-vars.env
      - sed -i "s|CONTAINER_IMAGE|$IMAGE_URI:$IMAGE_TAG|g" kube-manifests/01-DEVOPS-Nginx-Deployment.yml
      - cat kube-manifests/01-DEVOPS-Nginx-Deployment.yml
  
  build:
    commands:
      - aws eks update-kubeconfig --name $EKS_CLUSTER_NAME --region $AWS_REGION
      - aws sts assume-role --role-arn $EKS_KUBECTL_ROLE_ARN --role-session-name build-session | jq -r '.Credentials | "export AWS_ACCESS_KEY_ID=\(.AccessKeyId) AWS_SECRET_ACCESS_KEY=\(.SecretAccessKey) AWS_SESSION_TOKEN=\(.SessionToken)"' > creds.sh
      - source creds.sh
      - kubectl apply -f kube-manifests/
      - kubectl rollout status deployment/eks-devops-deployment -n default
  
  post_build:
    commands:
      - kubectl get pods -o wide
      - kubectl get svc -o wide  
      - kubectl get ingress -o wide
```

### Lab Demos
The review covers IAM role ARN formatting, manifest modification logic, and the secure credential management approach using temporary STS tokens.

## 24.12 Deploy Stage- Create Deploy stage in pipeline

### Overview
Extend the CodePipeline by adding the deployment stage and configuring the necessary CodeBuild project for Kubernetes manifest application.

### Key Concepts

#### Pipeline Stage Addition
- **Sequential Execution**: Deploy stage executes after successful build completion
- **Artifact Input**: Build artifacts feed into deployment process
- **Action Provider**: AWS CodeBuild for kubectl operations

#### CodeBuild Project Configuration
- **Project Naming**: deploy-eks-devops-551 for consistency
- **Service Role**: deploy-eks-devops-551-service-role (requires STS assume permissions)
- **Buildspec**: buildspec-deploy.yml for deployment logic

#### Pipeline Permission Extension
- **CodeBuildAdminAccess Policy**: Pipeline role requires permissions to invoke deploy CodeBuild project
- **Resource Management**: CodeBuild project lifecycle controlled by CodePipeline

### Code/Config Blocks
```bash
# Pipeline service role policy attachment
aws iam attach-role-policy \
  --role-name AWSCodePipelineServiceRole \
  --policy-arn arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess
```

```yaml
# Pipeline deploy stage addition
stages:
  - name: Deploy
    actions:
      - name: DeployToEKSCluster
        actionTypeId:
          category: Deploy
          owner: AWS
          provider: CodeBuild
        configuration:
          ProjectName: deploy-eks-devops-551
        inputArtifacts:
          - name: BuildArtifacts
        runOrder: 1
```

### Lab Demos
Implementation includes CodeBuild project creation through Pipeline interface, service role configuration, and pipeline update validation.

## 24.13 Deploy Stage- Create STS Assume IAM Role

### Overview
Implement secure access management by creating an IAM role that follows least-privilege principles for CodeBuild deployments to EKS clusters.

### Key Concepts

#### IAM Role Design Principles
- **Trust Policy**: STS assume-role configuration for temporary credential generation
- **Inline Policy**: EKS describe permissions for cluster access validation
- **Cross-Account Considerations**: Account ID and region-specific ARN construction

#### kubectl Access Architecture
- **Temporary Credentials**: 15-minute session tokens for secure cluster interaction
- **kubeconfig Configuration**: Programmatic AWS authentication setup
- **Assumed Role Context**: Build process operates with restricted permissions

#### Policy Configuration
Access to EKS cluster operations required for deployment validation and monitoring

### Code/Config Blocks
```bash
# IAM role creation with trust policy
ROLE_NAME="EKSCodeBuildKubectlRole"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

aws iam create-role \
  --role-name $ROLE_NAME \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::'$ACCOUNT_ID':root"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }'

# Attach EKS describe permissions
aws iam put-role-policy \
  --role-name $ROLE_NAME \
  --policy-name eks-describe \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ],
        "Resource": "*"
      }
    ]
  }'
```

### Lab Demos
Role creation verification includes policy attachment confirmation and ARN extraction for subsequent permission assignments.

## 24.14 Deploy Stage- Update aws-auth configmap and create STS policy

### Overview
Configure Kubernetes RBAC and IAM integration to authorize CodeBuild deployments, establishing secure cluster access through AWS authentication mechanisms.

### Key Concepts

#### AWS Auth ConfigMap Management
- **IAM Role Registration**: EKSCodeBuildKubectlRole integration for cluster access
- **Username Mapping**: 'build' user designation for audit trail clarity
- **System Masters Permission**: Administrative privileges for deployment operations

#### Backup Strategy
- **ConfigMap Preservation**: Pre-modification capture of existing configurations
- **Rollback Capability**: Original state restoration if needed
- **Manual Reconstruction**: Account-specific node group role ARN requirements

#### STS Policy Implementation
- **Deployment Role Authorization**: CodeBuild service role policy for assume role operations
- **Fine-Grained Access**: Specific ARN targeting for security compliance
- **Account Context**: Region-independent policy construction

### Code/Config Blocks
```bash
# AWS auth configmap backup
kubectl get configmap aws-auth -n kube-system -o yaml > aws-auth-backup.yaml

# Role ARN extraction for configmap updates
ROLE_ARN=$(aws iam get-role --role-name EKSCodeBuildKubectlRole --query 'Role.Arn' --output text)

# ConfigMap patch application
kubectl patch configmap/aws-auth \
  --type merge \
  -n kube-system \
  -p '{"data":{"mapRoles":"- rolearn: '$ROLE_ARN'\n  username: build\n  groups:\n  - system:masters\n"}}'
```

```json
# STS assume role policy document
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::ACCOUNT-ID:role/EKSCodeBuildKubectlRole"
    }
  ]
}
```

### Lab Demos
Configuration updates demonstrate configmap modification workflow, permission validation, and integration testing through pipeline execution.

## 24.15 Deploy Stage- Test end to end Pipeline (Source, Build and Deploy)

### Overview
Execute comprehensive pipeline testing from source code commit through build artifact generation and Kubernetes deployment, validating the complete CI/CD workflow.

### Key Concepts

#### End-to-End Validation Strategy
- **Sequential Stage Testing**: Source → Build → Deploy phase verification
- **Artifact Chain Validation**: Environment variables propagated through pipeline
- **Resource Creation Monitoring**: ECR images, Kubernetes objects, Load Balancers

#### Application Version Management
- **Version Identifier Updates**: Systematic increment (V2, V3, V4, V5, V6) for change detection
- **Git Operations**: Standard workflow commit and push operations
- **Pipeline Triggering**: Automatic execution on source modifications

#### Deployment Verification Matrix
- **Container Registry**: ECR image tagging and availability confirmation
- **Kubernetes Resources**: Pod readiness, service exposure, ingress provisioning
- **External Access**: Load balancer DNS resolution and application accessibility

### Code/Config Blocks
```bash
# Application update workflow
cd aws-eks-devops
echo "V6" > app1/index.html
git add app1/index.html
git commit -am "V6 version update"
git push origin main
```

```bash
# Deployment verification commands
kubectl get pods -o wide
kubectl get svc -o wide
kubectl get ingress -o wide
kubectl logs -f deployment/eks-devops-deployment
```

### Lab Demos
Testing covers multiple iteration cycles with:
- Pipeline execution monitoring across all stages
- Build artifact inspection and ECR validation
- Kubernetes rollout status monitoring
- Application accessibility testing through ALB
- Load balancer and Route53 DNS record verification

## 24.16 Approval Stage- Create and Test Deployment Approval Stage

### Overview
Implement manual approval gates in the CodePipeline to introduce human oversight before production deployments, enhancing control and compliance.

### Key Concepts

#### SNS Topic Architecture
- **Email Notifications**: Human-readable approval requests via email
- **Topic Subscription**: Direct email integration for notification delivery
- **Confirmation Workflow**: Subscription verification and message delivery setup

#### Approval Stage Integration
- **Pipeline Insertion**: Manual approval between build and deploy stages
- **SNS Configuration**: Automated notifications using pre-configured topics
- **Timeout Management**: Configurable approval windows and expiration handling

#### IAM Permission Resolution
- **Missing Permissions**: SNS publish authorization for CodePipeline service role
- **Policy Attachment**: CloudWatch and SNS integrations for notification success

### Code/Config Blocks
```bash
# SNS topic and subscription setup
aws sns create-topic --name eks-devops-topic-one

aws sns subscribe \
  --topic-arn arn:aws:sns:region:account:eks-devops-topic-one \
  --protocol email \
  --notification-endpoint stacksimplify@gmail.com

# Pipeline service role permission expansion
aws iam attach-role-policy \
  --role-name AWSCodePipelineServiceRole \
  --policy-arn arn:aws:iam::aws:policy/AmazonSNSFullAccess
```

```yaml
# Manual approval stage configuration
stages:
  - name: ManualApproval
    actions:
      - name: DeploymentApprovalToEKS
        actionTypeId:
          category: Approval
          owner: AWS
          provider: Manual
        configuration:
          NotificationArn: arn:aws:sns:region:account:eks-devops-topic-one
        runOrder: 1
```

### Lab Demos
Implementation demonstrates:
- SNS topic creation and email subscription workflow
- Manual approval interaction through email links
- Pipeline state transitions based on approval decisions
- Approval audit trail and execution history tracking

## 24.17 Fix for Alternate Build Stage Failures

### Overview
Address intermittent Docker layer caching issues causing alternating build successes/failures by transitioning from Docker Hub to AWS ECR for base images.

### Key Concepts

#### Rate Limiting Diagnostics
- **Anonymous Pull Limits**: Docker Hub restrictions on unauthenticated access
- **Cache Invalidation**: Layer caching dependencies on previous build states
- **Retry Logic**: Pipeline automatic retry mechanisms for transient failures

#### ECR Migration Strategy
- **Public ECR Registry**: aws-lambda-provided/nginx for reliable access
- **FROM Statement Update**: Dockerfile modification from public.ecr.aws/lambda/nginx:latest
- **Cache Consistency**: ECR repositories provide more predictable caching behavior

#### Build Optimization Benefits
- **No Authentication Required**: Public ECR images accessible without credentials
- **Improved Reliability**: Reduced external dependency failure points
- **Consistent Performance**: Eliminated rate limiting and network variability

### Code/Config Blocks
```dockerfile
# Original Dockerfile (problematic)
FROM nginx:latest

# Updated Dockerfile (ECR-based)
FROM public.ecr.aws/nginx/nginx:latest
COPY app1 /usr/share/nginx/html/app1
EXPOSE 80
```

```bash
# Build reliability testing
# V8 version update and pipeline trigger
echo "V8 version" > app1/index.html
git add . && git commit -m "V8 update" && git push
# Observe consistent successful builds without retries
```

### Lab Demos
The fix validation includes:
- Dockerfile modification and testing
- Pipeline build consistency verification across multiple executions
- Build time performance improvements
- ECR image layer caching effectiveness confirmation

## 24.18 Clean-Up Delete all resources which are not needed

### Overview
Perform comprehensive resource cleanup to minimize AWS charges and maintain clean infrastructure state following DevOps pipeline testing completion.

### Key Concepts

#### Resource Lifecycle Management
- **Cost Optimization**: Remove active AWS resources (ALBs, pipeline executions)
- **State Preservation**: Maintain IAM roles and policies for reference
- **Selective Deletion**: Preserve reusable assets while removing ephemeral resources

#### Kubernetes Resource Removal
- **Manifest Deletion**: Reverse deployment operations using kubectl delete
- **Load Balancer Cleanup**: ALB automatic termination on ingress removal
- **DNS Record Management**: External-DNS controller cleanup verification

#### Cloud Resource Inventory
- Pipeline deletion for billing cessation
- CodeBuild project preservation for educational reference
- SNS topic and subscription removal for cost control

### Code/Config Blocks
```bash
# Kubernetes resource cleanup
kubectl delete -f kube-manifests/
kubectl get pods,svc,ingress  # Verification commands

# AWS resource termination
aws codepipeline delete-pipeline --name eks-devops-pipeline-551
aws sns delete-topic --topic-arn arn:aws:sns:region:account:eks-devops-topic-one
aws codebuild delete-project --name build-eks-devops-551
aws codebuild delete-project --name deploy-eks-devops-551
```

```bash
# Repository archival (optional)
# GitHub repository can remain public for community access
# Route53 and external resources automatically cleaned by controllers
```

### Lab Demos
Cleanup process includes systematic resource removal verification:
- Kubernetes object deletion confirmation
- Pipeline removal and execution cessation
- Load balancer termination monitoring
- SNS resource cleanup validation
- Final AWS resource inventory confirmation

## Summary

### Key Takeaways
```diff
+ DevOps pipeline automates CI/CD using AWS CodePipeline, CodeBuild, and GitHub
+ Containerized builds with ECR provide reliable artifact management
+ IAM roles with STS assume provide secure Kubernetes cluster access
+ Manual approval stages enable governance and quality control
+ Infrastructure as code principles apply to all pipeline components
- Rate limiting from external registries can cause intermittent failures
- Proper permission configuration is critical for cross-service communication
- Resource cleanup prevents unnecessary cloud costs
```

### Quick Reference
- **Container Registry**: ECR repositories for private Docker image storage
- **Pipeline Stages**: Source (GitHub) → Build (CodeBuild) → Approval (SNS) → Deploy (EKS)
- **Key IAM Roles**: CodeBuild service roles with STS assume permissions
- **Buildspecs**: YAML files defining build and deployment processes
- **Security**: Temporary credentials via STS assume-role for kubectl access

### Expert Insight

**Real-world Application**: EKS DevOps pipelines enable organizations to implement GitOps workflows where infrastructure and application changes flow seamlessly from development to production through automated quality gates and deployment controls.

**Expert Path**: Master advanced CodeBuild configurations with custom build environments, implement blue/green deployments with CloudFormation, and integrate security scanning tools into the CI pipeline. Learn infrastructure as code patterns using CDK or Terraform for complete pipeline automation.

**Common Pitfalls**: Insufficient IAM permissions causing pipeline failures, race conditions in resource provisioning, external dependency rate limits, improper artifact versioning leading to deployment inconsistencies, and failing to implement approval gates for production deployments.

</details>
