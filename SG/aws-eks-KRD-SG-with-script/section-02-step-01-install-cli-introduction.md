# Section 2: AWS CLI Installation and EKS Cluster Management

<details open>
<summary><b>Section 2: AWS CLI Installation and EKS Cluster Management (G3PCS46)</b></summary>

## Table of Contents
- [2.1 Install CLI - Introduction](#21-install-cli---introduction)
- [2.2 Install AWS CLI](#22-install-aws-cli)
- [2.3 Install kubectl CLI](#23-install-kubectl-cli)
- [2.4 Install eksctl CLI](#24-install-eksctl-cli)
- [2.5 EKS Cluster Introduction](#25-eks-cluster-introduction)
- [2.6 Create EKS Cluster](#26-create-eks-cluster)
- [2.7 Create EKS Managed Node Group & IAM OIDC Provider](#27-create-eks-managed-node-group--iam-oidc-provider)
- [2.8 Verify EKS Cluster Nodes](#28-verify-eks-cluster-nodes)
- [2.9 EKS Cluster Pricing Note - Very Important](#29-eks-cluster-pricing-note---very-important)
- [2.10 EKS Delete Cluster](#210-eks-delete-cluster)

## 2.1 Install CLI - Introduction
### Overview
This transcript introduces the three essential command-line interfaces (CLIs) required for managing AWS EKS clusters: AWS CLI for AWS service control, kubectl for Kubernetes operations, and eksctl for EKS-specific tasks. These tools enable automation, cluster management, and application deployment on EKS, with eksctl being particularly powerful for creating and managing clusters compared to the AWS Management Console.

### Key Concepts/Deep Dive
- **AWS CLI (Command Line Interface)**: Facilitates interaction with AWS services using scripts for automation. For EKS, it handles underlying configurations, security credentials, and resource management. Installation varies by platform (Mac, Windows, Linux).
- **kubectl (Kubernetes Controller)**: Manages Kubernetes clusters and objects directly. It's the primary tool for deploying and controlling applications on EKS throughout the course.
- **eksctl**: A specialized tool for creating, managing, and deleting EKS clusters, node groups, and Fargate profiles. It's recommended over the AWS Management Console for production-grade operations due to its efficiency.

### Code/Config Blocks
Refer to installation steps in subsequent subsections for specific commands. For example, after installing CLIs, configure AWS CLI with `aws configure` for access keys and region settings.

### Lab Demos
No specific demos in this transcript, but preparation for installations is covered.

## 2.2 Install AWS CLI
### Overview
This transcript covers installing and configuring the AWS CLI v2 on macOS, with notes for Windows. It emphasizes downloading the binary, installing it securely, and verifying the setup before configuring credentials for AWS account access.

### Key Concepts/Deep Dive
- Installation process involves downloading the CLI v2 binary from AWS documentation (for version 2.0.x features) and using `sudo installer` for macOS. Windows users follow steps for MSI or ZIP installation via AWS docs.
- Verification ensures the CLI version is up-to-date. Configuration requires generating IAM access keys: go to AWS IAM > Users > Security credentials > Create access key, then run `aws configure` to input keys, region (e.g., us-east-1), and output format (JSON).
- Security: Store access keys securely; they provide access to AWS resources.

### Code/Config Blocks
```bash
# Install AWS CLI v2 on macOS
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

# Verify installation
aws --version  # Should show 2.0.x

# Configure AWS CLI
aws configure
# Input: Access Key ID, Secret Access Key, Default region (us-east-1), Output format (json)

# Verify access
aws ec2 describe-vpcs
```

### Lab Demos
- Demonstrates configuring AWS CLI and verifying with an EC2 command to confirm account access.

## 2.3 Install kubectl CLI
### Overview
This transcript focuses on installing the AWS EKS-vendor kubectl binary on macOS, emphasizing vendor-specific versions for compatibility. It involves downloading the appropriate binary (e.g., for Kubernetes 1.16), setting permissions, and updating the PATH to enable cluster control.

### Key Concepts/Deep Dive
- kubectl tools manage Kubernetes clusters; AWS provides EKS-specific binaries for better compatibility, reducing issues.
- Download links are version-specific (e.g., for cluster version like 1.16); always check AWS documentation for the latest. CLI v1.16.8-eks is installed as an example.
- After download, extract, set executable permissions, and copy to ~/bin to update PATH.

### Code/Config Blocks
```bash
# Create bin directory
mkdir ~/bin

# Download EKS kubectl binary (for 1.16)
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/darwin/amd64/kubectl

# Make executable and set PATH
chmod +x ./kubectl
cp ./kubectl ~/bin/kubectl && export PATH=$HOME/bin:$PATH

# Verify
kubectl version --client
```

### Lab Demos
No explicit demos, but the process guides binary installation and path configuration.

## 2.4 Install eksctl CLI
### Overview
This transcript describes installing eksctl on macOS using Homebrew. It covers adding the Weaveworks Homebrew tap, installing the tool, and verifying the installation, with notes for Windows using Chocolatey or direct binaries.

### Key Concepts/Deep Dive
- eksctl (EKS Control) simplifies EKS operations: create/delete clusters, manage node groups/Fargate profiles. Preferred over AWS Management Console for its power and ease.
- Installation via Homebrew for macOS; Windows via Chocolatey (`choco install eksctl`) or manual binary download.

### Code/Config Blocks
```bash
# Tap Weaveworks Homebrew
brew tap weaveworks/tap

# Install eksctl
brew install weaveworks/tap/eksctl

# Verify
eksctl version
```

### Table: eksctl Installation Methods
| Platform | Method | Command |
|----------|--------|---------|
| macOS    | Homebrew | See above |
| Windows  | Chocolatey | `choco install eksctl` |
| Linux    | Direct | Download from GitHub releases |

### Lab Demos
Direct installation demo with verification output.

## 2.5 EKS Cluster Introduction
### Overview
This detailed introduction covers AWS EKS core components: control plane, worker nodes/node groups, Fargate profiles, and VPC. It explains how EKS works, including high availability, managed services, and why VPC design is crucial for security and architecture in production.

### Key Concepts/Deep Dive
- **EKS Control Plane**: Managed by AWS (single-tenant), hosts kube-api-server, kube-controller-manager, etcd. Ensures high availability (2 API servers, 3 etcd nodes across 3 AZs); replaces unhealthy instances.
- **Worker Nodes & Node Groups**: EC2 instances (t3.medium default) in Auto Scaling Groups; connect to control plane via API endpoint. EKS-managed nodes auto-patch. Groups enhance scalers for CPU/memory via Cluster Autoscaler.
- **Fargate Profiles**: Serverless compute for pods without EC2 provisioning. Uses AWS Fargate Controller; pods have isolation. Suited for hybrid setups with worker nodes.
- **VPC**: Fundamental for design; public subnets for external access, private for security. API endpoint exposure (public/private) affects worker access. NAT gateways for outbound traffic; security groups control flow.
- **EKS Workflow**: Create cluster (control plane), add node groups/Fargate, deploy apps via kubectl. Security via RBAC; production-ready with proper VPC.

### Code/Config Blocks
EKS leverages AWS tools (eksctl, kubectl) for operations. Example workflow:
```bash
# Create cluster
eksctl create cluster --name my-cluster --region us-east-1 --zones us-east-1a,us-east-1b

# Add node group
eksctl create nodegroup --cluster my-cluster --name my-ng --node-type t3.medium --nodes 2

# Deploy app
kubectl apply -f deployment.yaml
```

### Lab Demos
Conceptual, with future demos in cluster creation subsections.

## 2.6 Create EKS Cluster
### Overview
This transcript walks through creating an EKS cluster without node groups using eksctl, emphasizing control plane setup first. It highlights regions, versions, and default selections like public subnets, with CONFIG updates for kubectl.

### Key Concepts/Deep Dive
- Cluster creation via `eksctl create cluster` (15-20 min); specifies name, region (us-east-1), zones (restrict to avoid quota issues). Uses latest supported Kubernetes (e.g., 1.16).
- Separates node groups for custom control; default creates node groups with t3.medium. Updates ~/.kube/config automatically.
- Verification: `eksctl get clusters`, `kubectl get nodes` (none initially).

### Code/Config Blocks
```bash
# Create EKS cluster (control plane only)
eksctl create cluster --name eks-demo-1 --region us-east-1 --zones us-east-1a,us-east-1b --without-nodegroup

# List clusters
eksctl get clusters --region us-east-1

# Check nodes (none expected)
kubectl get nodes
```

### Lab Demos
Live creation with output showing subnet selection, version (1.16), public access enabled. Cluster config auto-updates.

## 2.7 Create EKS Managed Node Group & IAM OIDC Provider
### Overview
This transcript covers enabling IAM OIDC provider for EKS (essential for IAM roles with service accounts), creating EC2 key pairs for node access, and adding managed node groups with add-on flags for policies (e.g., ALB, ECR, ASG).

### Key Concepts/Deep Dive
- **OIDC Provider**: Associates with cluster for IAM roles/service account integration (e.g., for ALB Ingress, external DNS).
- **EC2 Key Pair**: Enables SSH access to worker nodes (t3.medium, 20GB storage, 2-4 nodes). Pair-name convention for security.
- **Managed Node Groups**: AWS-handled patching/upgrades; uses eksctl with flags for auto-scaling, ECR access, etc. IAM role auto-created with policies.

### Code/Config Blocks
```bash
# Associate OIDC Provider
eksctl utils associate-iam-oidc-provider --cluster eks-demo-1 --region us-east-1 --approve

# Create node group with add-ons
eksctl create nodegroup --cluster eks-demo-1 --region us-east-1 --name eks-demo-1-ng-public-1 \
  --node-type t3.medium --nodes 2 --nodes-min 2 --nodes-max 4 --node-volume-size 20 \
  --ssh-access --ssh-public-key kube-demo --asg-access --external-dns-access --full-ecr-access --alb-ingress-access \
  --managed

# Verify nodes
kubectl get nodes -o wide
```

### Table: Add-on Flags for Node Groups
| Flag | Purpose | Example Use |
|------|---------|-------------|
| --asg-access | Enables Cluster Autoscaler IAM policy | Scaling nodes |
| --full-ecr-access | Full Elastic Container Registry access | Pulling private images |
| --alb-ingress-access | AWS Load Balancer Controller policy | ALB Ingress |
| --external-dns-access | Route53 DNS updates | External DNS |

### Lab Demos
Creation with output showing node readiness; verification via kubectl.

## 2.8 Verify EKS Cluster Nodes
### Overview
This transcript details step-by-step verification: subnets (public via IGW), node group details in EKS console, IAM roles/policies for ASG/ECR, CloudFormation stacks, security groups, SSH access, and configurations via eksctl/kubectl.

### Key Concepts/Deep Dive
- Subnet verification: Check route tables for IGW (public); security groups include remote access for SSH/all traffic.
- Node group: Managed, with ASG/IAM roles; instances show key pair.
- CloudFormation: Tracks creations (NAT Gateway, VPC elements); endpoints listed.
- SSH Access: Use `ssh -i key.pem ec2-user@public-ip` for troubleshooting.

### Code/Config Blocks
```bash
# List nodes (detailed)
kubectl get nodes -o wide

# Check clusters
eksctl get clusters --region us-east-1

# View kubeconfig
kubectl config current-context

# SSH into a node (assuming IP and key)
ssh -i ~/.ssh/kube-demo.pem ec2-user@<node-public-ip>
```

### Table: IAM Policies Attached to Worker Node Role
| Policy | Purpose |
|--------|---------|
| AmazonEKSWorkerNodePolicy | Basic node permissions |
| AmazonEKS_CNI_Policy | VPC networking |
| AmazonEC2ContainerRegistryReadOnly | ECR pulls |
| Custom ALB/ECR Policies | From add-ons |

### Lab Demos
Console navigation for subnets, security groups (adding all traffic rule); SSH login demo; IAM role verification.

## 2.9 EKS Cluster Pricing Note - Very Important
### Overview
This critical note on EKS pricing warns of costs: $0.10/hour control plane ($2.40/day, $72/month). Worker nodes (e.g., t3.medium) add $30/month. Fargate profiles have separate charges. Emphasizes deleting clusters when not in use to avoid runaway costs.

### Key Concepts/Deep Dive
- **Pricing Model**: AWS EKS charges per hour; no free tier. Regions vary slightly.
- **Worker Nodes**: Add EC2 costs; can't stop/start like regular EC2—delete node groups instead.
- **Best Practices**: For learning, create/delete clusters as needed; monitor via AWS Billing.

### Table: Sample Monthly Costs (us-east-1)
| Component | Hourly Cost | Monthly (24/7) |
|-----------|-------------|----------------|
| EKS Control Plane | $0.10 | $72 |
| 2x t3.medium Nodes | ~$0.04 each | $60 |
| Total (approx) | - | $132 |

### Lab Demos
No demos; focuses on cost awareness.

## 2.10 EKS Delete Cluster
### Overview
This transcript explains deleting EKS clusters and node groups via eksctl, stressing rollback of manual changes (e.g., security group edits) to avoid CloudFormation failures. Covers individual node group deletion or full cluster deletion, with notes on charges for NAT Gateway/NLBs.

### Key Concepts/Deep Dive
- **Deletion Risks**: Revert EKSCTL-managed object changes (e.g., IAM policies, security groups) before deletion; failure may require manual CloudFormation cleanup.
- Commands: `eksctl delete nodegroup` for groups; `eksctl delete cluster` for everything (control plane + nodes).
- Costs: Control plane, nodes, NLB, NAT Gateway incur charges hourly.

### Code/Config Blocks
```bash
# Delete specific node group
eksctl delete nodegroup --cluster eks-demo-1 --region us-east-1 --name eks-demo-1-ng-public-1

# Delete entire cluster
eksctl delete cluster --name eks-demo-1 --region us-east-1
```

### Table: Deletion Scenarios
| Scenario | Command | Notes |
|----------|---------|-------|
| Delete Node Group Only | `eksctl delete nodegroup` | Retains control plane |
| Delete Full Cluster | `eksctl delete cluster` | Removes all (control plane, node groups) |
| After Manual Changes | Revert changes first | Prevents failures |

### Lab Demos
Conceptual; advises on rollback steps (e.g., remove added security rules).

## Summary
### Key Takeaways
```diff
+ AWS CLI enables secure, scripted AWS service management.
- Neglecting OIDC association limits IAM role integration for service accounts.
+ eksctl simplifies EKS operations; prefer managed node groups.
- Forgetting rollback edits before deletion causes CloudFormation failures.
+ Public subnets expose API endpoints; design VPC carefully.
- EKS costs $0.10/hour control plane—delete when not using.
+ Managed node groups auto-patch; use eksctl add-ons.
```

### Quick Reference
- Install AWS CLI: `aws configure` after download/install.
- Install kubectl: Download EKS-vendor binary, update PATH.
- Install eksctl: `brew install weaveworks/tap/eksctl` (macOS).
- Create cluster: `eksctl create cluster --name <name> --region <region> --zones <zones> --without-nodegroup`.
- Add node group: `eksctl create nodegroup --cluster <cluster> --managed --nodes <count>`.
- Verify: `kubectl get nodes`, `eksctl get clusters`.
- Delete cluster: `eksctl delete cluster --name <name>`.

### Expert Insight
**Real-world Application**: In production, use eksctl for IaC-like EKS management. Combine with Terraform for VPC design, ensuring private subnets for security and NAT for outbound.

**Expert Path**: Master kubectl for daily ops; study Cluster Autoscaler for scaling. Experiment with Fargate for bursty workloads. Dive into AWS Logging for troubleshooting.

**Common Pitfalls**: Skipping OIDC leads to service account issues. Not reverting manual changes causes delete failures. Overlooking costs runs up bills—set alarms.

</details>
