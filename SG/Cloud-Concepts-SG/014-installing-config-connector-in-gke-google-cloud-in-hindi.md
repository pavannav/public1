# Session 014: Installing Config Connector in GKE Google Cloud

<details open>
<summary><b>014-Installing-Config-Connector-In-GKE-Google-Cloud-in-Hindi (KK-CS45-script-v2)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts and Deep Dive](#key-concepts-and-deep-dive)
  - [What is Config Connector](#what-is-config-connector)
  - [Benefits of Config Connector in GKE](#benefits-of-config-connector-in-gke)
  - [Prerequisites](#prerequisites)
- [Installation Steps](#installation-steps)
- [Configuration](#configuration)
- [Lab Demo: Step-by-Step Installation](#lab-demo-step-by-step-installation)
- [Summary](#summary)

## Overview

This session focuses on installing and configuring Config Connector within Google Kubernetes Engine (GKE). Config Connector is a Kubernetes addon that extends the Kubernetes API by adding Google Cloud service resources, enabling declarative management of Google Cloud resources through Kubernetes-style APIs.

> [!NOTE]
> **Transcript Note**: The provided transcript file contains only a YouTube video reference. The study guide below has been created based on the session topic and standard Config Connector installation procedures in GKE.

## Key Concepts and Deep Dive

### What is Config Connector

**Config Connector** is a Kubernetes extension that:

- **Extends Kubernetes API**: Adds new resource types corresponding to Google Cloud services
- **Declarative Resource Management**: Manage Google Cloud infrastructure as Kubernetes resources
- **Consistent Tooling**: Use familiar Kubernetes tools (kubectl, Helm, etc.) for cloud resources

```yaml
# Example: Creating a GCS bucket via Config Connector
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: my-bucket
spec:
  location: US
  storageClass: STANDARD
```

### Benefits of Config Connector in GKE

| Benefit | Description |
|---------|-------------|
| **Infrastructure as Code** | Define cloud resources in YAML/Kubernetes manifests |
| **GitOps Integration** | Manage cloud infrastructure through Git workflows |
| **Dependency Management** | Automatic handling of resource dependencies |
| **Multi-Environment Support** | Consistent deployments across dev/staging/prod |
| **Audit Trails** | Full visibility of infrastructure changes |

### Prerequisites

Before installing Config Connector, ensure you have:

1. **GKE Cluster**: Running GKE cluster (version 1.16+ recommended)
2. **IAM Permissions**:
   - `roles/editor` or equivalent permissions on the Google Cloud project
   - `roles/iam.serviceAccountAdmin` for service account management
3. **kubectl**: Configured to connect to your GKE cluster
4. **Google Cloud SDK**: Latest version installed and authenticated

```bash
# Verify cluster access
kubectl cluster-info

# Verify gcloud authentication
gcloud auth list
gcloud config list project
```

## Installation Steps

### Step 1: Install Config Connector via gcloud

```bash
# Install Config Connector in your GKE cluster
gcloud alpha container hub config-management enable config-connector \
    --project=YOUR_PROJECT_ID \
    --fleet-project=YOUR_PROJECT_ID \
    --location=global
```

### Step 2: Configure Namespace and Service Account

```bash
# Create a namespace for Config Connector resources
kubectl create namespace config-connector

# Create Google Service Account for Config Connector
gcloud iam service-accounts create config-connector \
    --description="Config Connector Service Account" \
    --display-name="Config Connector"

# Grant necessary permissions
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:config-connector@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/editor"

# Create and download key
gcloud iam service-accounts keys create key.json \
    --iam-account=config-connector@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

### Step 3: Create ConfigConnector Custom Resource

```yaml
# configconnector.yaml
apiVersion: core.cnrm.cloud.google.com/v1beta1
kind: ConfigConnector
metadata:
  name: configconnector.core.cnrm.cloud.google.com
spec:
  mode: cluster
  googleServiceAccount: config-connector@YOUR_PROJECT_ID.iam.gserviceaccount.com
---
apiVersion: v1
kind: Secret
metadata:
  name: configconnector
  namespace: config-connector
type: Opaque
data:
  # Base64 encoded service account key
  key.json: <BASE64_ENCODED_KEY>
```

```bash
# Apply the configuration
kubectl apply -f configconnector.yaml
```

## Configuration

### Resource Types Available

Config Connector supports hundreds of Google Cloud resource types:

| Category | Examples |
|----------|----------|
| **Compute** | Compute Engine VMs, Disks, Networks |
| **Storage** | Cloud Storage Buckets, BigQuery Datasets |
| **Identity** | Service Accounts, IAM Policies |
| **Networking** | Load Balancers, VPC Networks, DNS |
| **Databases** | Cloud SQL, Firestore, Bigtable |

### Annotations and Labels

Config Connector supports Google Cloud labels and annotations:

```yaml
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: my-bucket
  annotations:
    cnrm.cloud.google.com/project-id: my-project
  labels:
    environment: production
    team: devops
spec:
  location: US
  storageClass: STANDARD
```

## Lab Demo: Step-by-Step Installation

### Demo Setup
Follow these steps to install Config Connector in your GKE cluster:

1. **Prepare Environment**
   ```bash
   # Set project variables
   export PROJECT_ID=your-project-id
   export CLUSTER_NAME=gke-cluster
   export REGION=us-central1

   # Authenticate and set project
   gcloud auth login
   gcloud config set project $PROJECT_ID
   gcloud config set compute/region $REGION
   ```

2. **Enable Required APIs**
   ```bash
   # Enable necessary Google Cloud APIs
   gcloud services enable cloudresourcemanager.googleapis.com
   gcloud services enable container.googleapis.com
   gcloud services enable iam.googleapis.com
   ```

3. **Install Config Connector**
   ```bash
   # Install Config Connector addon
   gcloud alpha container hub config-management enable config-connector \
       --project=$PROJECT_ID \
       --fleet-project=$PROJECT_ID \
       --location=global
   ```

4. **Verify Installation**
   ```bash
   # Check Config Connector pods
   kubectl get pods -n config-connector-system

   # Check available CRDs
   kubectl get crd | grep cnrm.cloud.google.com

   # Test with a simple resource
   kubectl apply -f - <<EOF
   apiVersion: resourcemanager.cnrm.cloud.google.com/v1beta1
   kind: Project
   metadata:
     name: $PROJECT_ID
   spec:
     resourceID: $PROJECT_ID
   EOF
   ```

## Summary

### Key Takeaways

```diff
+ Config Connector extends Kubernetes to manage Google Cloud resources declaratively
+ Installation requires GKE cluster, IAM permissions, and service account setup
+ Supports hundreds of Google Cloud resource types through Kubernetes CRDs
+ Enables Infrastructure as Code practices using familiar Kubernetes tooling
+ Provides automatic dependency management and audit trails
- Be cautious with IAM permissions - Config Connector SA needs broad access
- Test installations in non-production environments first
- Monitor resource creation limits and quotas
```

### Quick Reference

**Installation Command:**
```bash
gcloud alpha container hub config-management enable config-connector \
    --project=YOUR_PROJECT_ID \
    --fleet-project=YOUR_PROJECT_ID \
    --location=global
```

**Verify Installation:**
```bash
kubectl get pods -n config-connector-system
kubectl get crds | grep cnrm.cloud.google.com
```

**Sample Resource Creation:**
```yaml
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: my-config-connector-bucket
spec:
  location: US
  storageClass: STANDARD
```

### Expert Insight

**Real-world Application:**
In production environments, Config Connector excels at:
- Managing multi-region infrastructure deployments
- Implementing GitOps workflows for cloud resources
- Ensuring consistency across development, staging, and production environments
- Providing self-service infrastructure capabilities to development teams

**Expert Path:**
- Master advanced Config Connector features like resource references and dependencies
- Learn to use Config Connector with GitOps tools like Flux or ArgoCD
- Understand resource lifecycle management and cleanup strategies
- Implement proper RBAC controls for Config Connector resources

**Common Pitfalls:**
- **Over-permissive IAM**: Avoid giving Config Connector service accounts excessive permissions
- **Circular Dependencies**: Watch for resource dependencies that create loops
- **Quota Limits**: Monitor Google Cloud quotas during large deployments
- **Namespace Isolation**: Properly scope Config Connector resources per namespace/project

</details>