# Section 2: CLI Installation and Setup (AWS EKS Masterclass)

<details open>
<summary><b>Section 2: CLI Installation and Setup (AWS EKS Masterclass)</b></summary>

## Table of Contents
1. [2.1 CLI - Introduction](#21-cli---introduction)
2. [2.2 Step-02- Install AWS CLI](#22-step-02--install-aws-cli)
3. [2.3 Step-03- Install kubectl CLI](#23-step-03--install-kubectl-cli)
4. [2.4 Step-04- Install eksctl CLI](#24-step-04--install-eksctl-cli)
5. [2.5 Step-05- EKS Cluster Introduction](#25-step-05--eks-cluster-introduction)

---

## 2.1 CLI - Introduction

### Overview
This section introduces the three essential command-line tools required for working with AWS EKS: AWS CLI, kubectl, and eksctl. Each tool serves a critical role in EKS cluster management and application deployment.

### Key Concepts

#### Three-Pillar CLI Toolset
```diff
+ AWS CLI: Interface for all AWS services and APIs
+ kubectl: Kubernetes cluster and workload management
+ eksctl: AWS EKS-specific cluster lifecycle management
```

#### Tool Interdependencies
```mermaid
graph TD
    A[AWS CLI] --> B[eksctl]
    B --> C[kubectl]
    C --> D[EKS Cluster Operations]
    D --> E[Application Deployments]
```

#### Prerequisites for Installation
- Terminal/Shell environment (bash/zsh)
- Download utilities (curl/wget)
- Administrative privileges
- Internet connectivity

> [!IMPORTANT]
> All three tools must be properly installed and configured before proceeding to EKS cluster creation. Spend time ensuring each tool works independently before combining them.

---

## 2.2 Step-02- Install AWS CLI

### Overview
Comprehensive installation of AWS CLI v2 on macOS with credential configuration and testing.

### Key Concepts

#### AWS CLI v2 Architecture
```bash
AWS CLI v2 Components:
├── aws (main executable)
├── credentials management
├── configuration profiles
└── service integrations
```

#### Installation Methods by Platform

##### macOS Installation
```bash
# Method 1: Homebrew (recommended)
brew install awscli

# Method 2: Direct download and install
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

##### Windows Installation
```powershell
# Download MSI installer
msiexec.exe /i https://awscli.amazonaws.com/AWSCLIV2.msi

# Alternative: Chocolatey
choco install awscli
```

##### Linux Installation
```bash
# Ubuntu/Debian
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# CentOS/RHEL
yum install -y awscli-2
```

#### Configuration Process
```bash
# Interactive configuration
aws configure

# Prompt responses:
# AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
# AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# Default region name [None]: us-east-1
# Default output format [None]: json
```

#### IAM Requirements
```yaml
Minimal IAM Permissions for EKS:
  - eks:*
  - ec2:*
  - iam:*
  - cloudformation:*
  - elasticloadbalancing:*
```

### Lab Demo: Complete AWS CLI Setup

#### Pre-requisites
- AWS account with programmatic access
- IAM user with administrator permissions
- Terminal access

#### Step-by-Step Setup
1. Navigate to IAM console
2. Create new user with programmatic access
3. Attach AdministratorAccess policy
4. Generate and download access keys
5. Configure AWS CLI locally

```bash
# Verify installation
aws --version
# Output: aws-cli/2.15.0 Python/3.11.6 Darwin/23.3.0 botocore/2.0.1

# Test connectivity
aws ec2 describe-vpcs

# List IAM users (test permissions)
aws iam list-users
```

#### Security Considerations
```diff
+ Use IAM roles instead of access keys where possible
+ Store credentials securely using AWS config files
+ Implement credential rotation policies
- Never commit credentials to version control systems
- Avoid using root account for routine operations
- Store secret keys in plain text files
```

> [!NOTE]
> AWS CLI uses the following precedence for credentials: 1) Environment variables, 2) Shared credential file (~/.aws/credentials), 3) AWS config file (~/.aws/config), 4) Instance profile/IAM roles.

---

## 2.3 Step-03- Install kubectl CLI

### Overview
Installation of the official AWS EKS-provided kubectl binary for optimal Kubernetes cluster compatibility and management.

### Key Concepts

#### kubectl vs AWS EKS kubectl
```diff
+ AWS EKS kubectl: Vendor-optimized for EKS clusters
+ Matches EKS Kubernetes version exactly
+ Reduced compatibility issues
- Requires separate download process
- Version tied to EKS cluster version
```

#### Version Compatibility Matrix
```yaml
EKS Kubernetes Version -> kubectl Version:
  EKS 1.27 -> kubectl 1.27.x-eksbuild.x
  EKS 1.26 -> kubectl 1.26.x-eksbuild.x
  EKS 1.25 -> kubectl 1.25.x-eksbuild.x
  EKS 1.24 -> kubectl 1.24.x-eksbuild.x (LTS)
```

#### Download URLs by Platform
```bash
# macOS (Intel)
https://amazon-eks.s3.us-west-2.amazonaws.com/[VERSION]/bin/darwin/amd64/kubectl

# macOS (Apple Silicon)
https://amazon-eks.s3.us-west-2.amazonaws.com/[VERSION]/bin/darwin/arm64/kubectl

# Linux (x86_64)
https://amazon-eks.s3.us-west-2.amazonaws.com/[VERSION]/bin/linux/amd64/kubectl

# Windows
https://amazon-eks.s3.us-west-2.amazonaws.com/[VERSION]/bin/windows/amd64/kubectl.exe
```

### Lab Demo: kubectl Installation

#### Installation Steps
```bash
# Create binary directory
mkdir -p ~/binaries && cd ~/binaries

# Download kubectl (replace [VERSION] with current EKS version)
curl -LO "https://amazon-eks.s3.us-west-2.amazonaws.com/1.27.3/2023-05-11/bin/darwin/amd64/kubectl"

# Make executable
chmod +x kubectl

# Move to user bin directory
mkdir -p ~/bin
cp kubectl ~/bin/

# Add to PATH (add to ~/.zshrc or ~/.bashrc)
echo 'export PATH=$PATH:~/bin' >> ~/.zshrc
source ~/.zshrc
```

#### Verification Commands
```bash
# Check version
kubectl version --short --client

# Expected output format
Client Version: v1.27.3-eks-1234567

# Test kubectl functionality (will fail without cluster)
kubectl cluster-info
# Output: The connection to the server localhost:8080 was refused
```

#### PATH Configuration Troubleshooting
```bash
# Verify kubectl location
which kubectl
# Output: /Users/username/bin/kubectl

# Check PATH includes ~/bin
echo $PATH | grep -q "~/bin" && echo "PATH includes ~/bin" || echo "PATH missing ~/bin"

# Alternative: Move to system PATH
sudo cp ~/bin/kubectl /usr/local/bin/
```

> [!IMPORTANT]
> Always verify kubectl is accessible from any directory before proceeding to cluster operations. The version must match or be compatible with your EKS cluster version.

---

## 2.4 Step-04- Install eksctl CLI

### Overview
Installation and basic usage of eksctl, the official command-line tool for creating and managing Amazon EKS clusters.

### Key Concepts

#### eksctl Capabilities
```yaml
Core Features:
  - One-command EKS cluster creation
  - Managed node group management
  - VPC and networking setup
  - IAM role and policy configuration
  - Cluster scaling and upgrades
  - Add-on management (e.g., VPC CNI, CoreDNS)
```

#### Installation Methods
```bash
# macOS (Homebrew)
brew install weaveworks/tap/eksctl

# macOS/Linux (Direct download)
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Windows (Chocolatey)
choco install eksctl

# Alternative installations available via package managers
```

#### Architecture Integration
```mermaid
graph TD
    A[eksctl] --> B[AWS CloudFormation]
    B --> C[EC2 Instances]
    A --> D[IAM Roles]
    D --> E[EKS Control Plane]
    A --> F[VPC Networking]
    F --> C
```

### Lab Demo: eksctl Installation and Testing

#### Installation Verification
```bash
# Check version
eksctl version

# Get help and command overview
eksctl --help

# List available regions and clusters
eksctl get cluster --region us-east-1
```

#### Environment Setup
```bash
# Set default AWS region
export AWS_DEFAULT_REGION=us-east-1

# Verify AWS configuration
aws sts get-caller-identity

# Test eksctl connectivity
eksctl info
```

#### Troubleshooting Common Issues
```diff
+ Ensure AWS credentials are properly configured
+ Verify AWS region permissions
+ Check for sufficient IAM permissions
- Missing AWS CLI configuration
- Outdated eksctl version
- Region-specific API limitations
```

> [!NOTE]
> eksctl uses AWS CloudFormation under the hood to provision and manage EKS clusters, providing infrastructure-as-code benefits while abstracting complex CloudFormation templates.

---

## 2.5 Step-05- EKS Cluster Introduction

### Overview
Introduction to Amazon EKS cluster architecture, components, and operational considerations including cost awareness and networking requirements.

### Key Concepts

#### EKS Architecture Components
```yaml
EKS Cluster Stack:
  - Control Plane (AWS managed)
    ├── ETCD
    ├── API Server
    ├── Controller Manager
    └── Scheduler
  ── Worker Nodes (User managed)
    ├── EC2 instances
    ├── Kubelet agents
    └── Container runtime
  ── Networking
    ├── VPC CNI plugin
    ├── Security groups
    └── Load balancers
```

#### Control Plane Responsibilities
```diff
+ Kubernetes API server operations
+ ETCD data persistence
+ Cluster state management
+ Scheduling decisions
+ High availability across AZs
- Direct access not available to users
- Managed service - no SSH access
```

#### Worker Node Options
```yaml
Node Types:
  - Self-managed nodes: Full control, manual scaling
  - Managed node groups: AWS manages scaling, patching
  - Fargate: Serverless, no node management
```

#### Cost Awareness and Optimization
```diff
+ Plan for 24/7 control plane costs (~$0.10/hour per cluster)
+ Worker nodes billed per EC2 instance pricing
+ EBS volumes add storage costs
+ NAT Gateway charges for private subnet traffic
- Unplanned long-running clusters
- Over-provisioned worker nodes
- Cross-AZ data transfer costs
```

### Networking Architecture

#### VPC Design Principles
```yaml
EKS VPC Requirements:
  - Minimum 2 Availability Zones
  - Public subnets for load balancers
  - Private subnets for worker nodes
  - NAT Gateway for outbound traffic
  - Security groups for pod communication
```

#### Security Best Practices
```diff
+ Place worker nodes in private subnets
+ Use security groups to control traffic
+ Enable VPC flow logs for monitoring
+ Implement least-privilege IAM roles
- Direct internet access to worker nodes
- Wide-open security group rules
- Shared subnets with other services
```

```mermaid
graph TD
    IG[Internet Gateway] --> Public[Public Subnet]
    Public --> ELB[Elastic Load Balancer]
    Public --> NAT[NAT Gateway]
    NAT --> Private[Private Subnet]
    Private --> Worker[Worker Nodes]
    ELB --> Worker
    subgraph "EKS Cluster VPC"
        Public
        Private
        IG
        NAT
        ELB
        Worker
    end
```

> [!IMPORTANT]
> EKS requires careful VPC planning. Use separate subnets for different components and always implement security group rules based on least-privilege principles.

---

## Summary

### Key Takeaways
```diff
+ Three essential tools form the foundation: AWS CLI, kubectl, eksctl
+ AWS EKS requires vendor-specific kubectl binary for compatibility
+ eksctl simplifies complex CloudFormation operations into single commands
+ EKS clusters incur continuous costs - plan accordingly
+ Proper VPC networking is critical for EKS cluster security and performance
- Generic kubectl installations often cause compatibility issues
- Insufficient IAM permissions block cluster operations
- Poor VPC design leads to security and connectivity problems
```

### Quick Reference

#### Installation Commands
```bash
# AWS CLI v2 (macOS)
brew install awscli

# kubectl (EKS version)
curl -LO "https://amazon-eks.s3.us-west-2.amazonaws.com/1.27.3/2023-05-11/bin/darwin/amd64/kubectl"
chmod +x kubectl && mv kubectl ~/bin/

# eksctl
brew install weaveworks/tap/eksctl
```

#### Verification Commands
```bash
# AWS CLI
aws --version
aws sts get-caller-identity

# kubectl
kubectl version --short --client
which kubectl

# eksctl
eksctl version
eksctl get cluster --region us-east-1
```

#### Configuration Setup
```bash
# AWS CLI interactive configuration
aws configure

# Set default region
export AWS_DEFAULT_REGION=us-east-1

# Add kubectl to PATH
echo 'export PATH=$PATH:~/bin' >> ~/.zshrc
source ~/.zshrc
```

### Expert Insight

#### Real-world Application
CLI tools are essential for infrastructure automation, CI/CD pipelines, and day-to-day EKS cluster management in production environments.

#### Expert Path
Master AWS CLI fundamentals first, then learn kubectl imperative commands before adopting eksctl for infrastructure templating. Understand the underlying CloudFormation that eksctl generates.

#### Common Pitfalls
```diff
- Installing generic kubectl instead of EKS-specific versions
- Forgetting to configure AWS CLI before using eksctl
- Incomplete PATH configurations causing command-not-found errors
- Using outdated documentation for EKS version compatibility
- Skipping VPC planning, leading to insecure or dysfunctional clusters
- Not monitoring costs during cluster lifecycle management
- Insufficient IAM permissions causing cryptic error messages
```

</details>