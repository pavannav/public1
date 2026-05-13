# Session 013: Installing ArgoCD on Google Kubernetes Engine (GCP)

<details open>
<summary><b>013-Installing-ArgoCD-on-Google-Kubernetes-Engine-GCP-in-Hindi (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts](#key-concepts)
- [Lab Demo: Complete ArgoCD Installation and Configuration](#lab-demo-complete-argocd-installation-and-configuration)
  - [Prerequisites](#prerequisites)
  - [Step 1: Create GKE Cluster](#step-1-create-gke-cluster)
  - [Step 2: Install ArgoCD](#step-2-install-argocd)
  - [Step 3: Access ArgoCD UI](#step-3-access-argocd-ui)
  - [Step 4: Initial Password Setup](#step-4-initial-password-setup)
  - [Step 5: Connect Git Repository](#step-5-connect-git-repository)
  - [Step 6: Create Application](#step-6-create-application)
  - [Step 7: Sync and Deploy](#step-7-sync-and-deploy)
  - [Step 8: Manage Deployments](#step-8-manage-deployments)
- [Summary](#summary)

## Overview
This session covers the installation and configuration of ArgoCD, a declarative, GitOps continuous delivery tool for Kubernetes. You'll learn how to deploy ArgoCD on Google Kubernetes Engine (GKE), connect it to a Git repository, and manage application deployments through Git-driven changes. ArgoCD enables automated deployment synchronization every few minutes, making Git your single source of truth for cluster configurations.

### Learning Objectives
- Understand GitOps principles and ArgoCD architecture
- Install ArgoCD on GKE clusters
- Configure ArgoCD UI access and authentication
- Connect Git repositories for automated deployments
- Create and manage application deployments
- Implement sync policies and rollback strategies

## Key Concepts

### GitOps Fundamentals
GitOps is a paradigm that uses Git repositories as the source of truth for declarative cluster infrastructure and applications. Changes to infrastructure or applications are made via Git commits.

**Core Principles:**
- **Declarative**: Desired state is declared in Git
- **Versioned**: All changes are version-controlled
- **Auditable**: Full history of changes in Git
- **Automated**: Syncing and reconciliation happen automatically

### ArgoCD Architecture
ArgoCD is a Kubernetes controller that continuously monitors applications and compares their live state with the desired state defined in Git repositories.

**Key Components:**
- **ArgoCD API Server**: Web UI and CLI interface
- **Repository Server**: Clones Git repositories and generates Kubernetes manifests
- **Application Controller**: Monitors applications and compares desired vs. actual state
- **ApplicationSet Controller**: Manages multiple applications from templates

### Sync Policies
ArgoCD supports different synchronization strategies:

| Policy | Description | Use Case |
|--------|-------------|----------|
| **Manual** | Requires explicit sync action | Development environments |
| **Automatic** | Syncs automatically when Git changes detected | Production deployments |
| **Auto-Prune** | Enables automatic resource deletion on sync | Clean deployments |

### ArgoCD Applications
An ArgoCD application defines:
- **Source**: Git repository URL and path
- **Destination**: Kubernetes cluster and namespace
- **Sync Policy**: How to handle synchronization
- **Sync Options**: Additional behaviors (auto-create namespace, prune resources)

## Lab Demo: Complete ArgoCD Installation and Configuration

### Prerequisites
- Google Cloud Project with billing enabled
- `gcloud` CLI installed and authenticated
- `kubectl` CLI installed
- A Git repository with Kubernetes manifests (GitHub/GitLab/etc.)

### Step 1: Create GKE Cluster

```bash
# Set your GCP project
gcloud config set project YOUR_PROJECT_ID

# Create GKE cluster (if not already created)
gcloud container clusters create my-argocd-cluster \
  --zone=us-central1-a \
  --num-nodes=3 \
  --machine-type=e2-medium

# Get cluster credentials
gcloud container clusters get-credentials my-argocd-cluster \
  --zone=us-central1-a
```

> [!NOTE]
> The session demonstrates cluster creation in the GCP console. For CLI users, the above commands create a standard GKE cluster suitable for ArgoCD.

### Step 2: Install ArgoCD

```bash
# Create ArgoCD namespace
kubectl create namespace argocd

# Install ArgoCD using kubectl apply
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for pods to be ready
kubectl wait --for=condition=Ready pod --all -n argocd --timeout=300s

# Verify installation
kubectl get pods -n argocd
```

Expected output:
```bash
NAME                                  READY   STATUS    RESTARTS   AGE
argocd-application-controller-0       1/1     Running   0          2m
argocd-dex-server-7f6c7c89fd-hg8xw    1/1     Running   0          2m
argocd-redis-55646dd8d7-k2qqv         1/1     Running   0          2m
argocd-repo-server-5d8c94c6fd-q8lzm   1/1     Running   0          2m
argocd-server-7c9c7b6c46-9r4xb        1/1     Running   0          2m
```

### Step 3: Access ArgoCD UI

```bash
# Expose ArgoCD server service
kubectl patch service argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Get external IP
kubectl get service argocd-server -n argocd
```

Look for the `EXTERNAL-IP` in the output and access `https://<EXTERNAL-IP>`.

### Step 4: Initial Password Setup

```bash
# Get initial admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Login to ArgoCD CLI (optional)
argocd login <ARGOCD_SERVER_URL> --username admin --password <PASSWORD>

# Change default password
kubectl patch secret argocd-secret \
  -n argocd \
  -p '{"data":{"admin.password":"'$(echo -n "NEW_SECURE_PASSWORD" | base64)'","admin.passwordMtime":"'$(date +%FT%T%Z | base64)'"}}'
```

> [!IMPORTANT]
> Always change the default admin password immediately after initial login for security purposes.

### Step 5: Connect Git Repository

In ArgoCD UI:
1. Go to **Settings** → **Repositories**
2. Click **CONNECT REPO**
3. Choose **VIA HTTPS**
4. Enter repository URL (copy from GitHub)
5. Add authentication if repository is private
6. For public repos, no authentication needed

```bash
# CLI alternative (optional)
argocd repo add https://github.com/YOUR_USERNAME/YOUR_REPO.git \
  --username YOUR_USERNAME \
  --password YOUR_TOKEN
```

### Step 6: Create Application

1. In ArgoCD UI → **Applications** → **New App**
2. Configure:
   - **Application Name**: e.g., `my-test-app`
   - **Project**: `default` (or create new project)
   - **Sync Policy**: Choose `Manual` or `Automatic`
   - **Repository URL**: Your Git repository
   - **Path**: Path to Kubernetes manifests
   - **Cluster**: Your GKE cluster
   - **Namespace**: Target namespace (check `Auto-create` if needed)

```bash
# CLI alternative
argocd app create my-test-app \
  --repo https://github.com/YOUR_USERNAME/YOUR_REPO.git \
  --path . \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --sync-policy auto
```

### Step 7: Sync and Deploy

```bash
# Manual sync via CLI
argocd app sync my-test-app

# Or sync via UI
# Click "SYNC" button in application details
```

If sync fails due to missing namespace:
1. Go to application settings
2. Enable **Auto-create Namespace**
3. Retry sync

### Step 8: Manage Deployments

#### Update Application
1. Make changes in Git repository
2. Commit and push changes
3. ArgoCD detects changes automatically

#### Rollback Deployment
In ArgoCD UI:
1. Go to Application → **History and Rollback**
2. Select desired revision
3. Click **Rollback**

```bash
# CLI rollback
argocd app rollback my-test-app HEAD~1
```

## Summary

### Key Takeaways

```diff
+ ArgoCD implements GitOps by making Git the source of truth for Kubernetes deployments
+ Supports automatic synchronization (every 3 minutes) or manual sync modes
+ Provides web UI and CLI for management
+ Enables easy rollbacks and deployment history tracking
- Default admin password must be changed immediately after installation
- Repository connections can be public or private (requires authentication)
- Namespace auto-creation prevents sync failures for new deployments
! Use secure, non-default repositories in production environments
```

### Quick Reference

**Installation:**
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

**Get Admin Password:**
```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

**Create Application:**
```bash
argocd app create APP_NAME \
  --repo REPO_URL \
  --path PATH \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace NAMESPACE
```

**Sync Application:**
```bash
argocd app sync APP_NAME
```

### Expert Insight

#### Real-world Application
In production environments, ArgoCD is commonly used for:
- Multi-environment deployments (dev/staging/prod)
- Progressive delivery strategies
- Policy enforcement through ApplicationSets
- Integration with CI/CD pipelines

#### Expert Path
To master ArgoCD:
- Study ApplicationSets for managing multiple applications
- Learn about resource hooks for complex deployment flows
- Implement custom health checks and sync waves
- Explore integration with external secrets management

#### Common Pitfalls
- **Namespace Issues**: Always enable auto-create namespace or ensure target namespaces exist
- **Repository Authentication**: Use personal access tokens instead of passwords
- **Sync Conflicts**: Be careful with auto-sync in production; use manual sync or gates
- **Resource Limits**: Default ArgoCD deployment may need resource adjustments for large clusters

</details>