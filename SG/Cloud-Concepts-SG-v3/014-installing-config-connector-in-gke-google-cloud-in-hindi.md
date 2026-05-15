# Session 14: Installing Config Connector in GKE

<details open>
<summary><b>Installing Config Connector in GKE (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts / Deep Dive](#key-concepts--deep-dive)
  - [Config Connector Overview](#config-connector-overview)
  - [Service Accounts and Permissions](#service-accounts-and-permissions)
  - [Installation Methods](#installation-methods)
- [Lab Demo: Installing Config Connector](#lab-demo-installing-config-connector)
- [Lab Demo: Basic Configuration](#lab-demo-basic-configuration)
- [Summary](#summary)

## Overview
Config Connector is a Kubernetes extension that allows you to manage Google Cloud resources using Kubernetes-style API calls. This session covers the installation and basic setup of Config Connector in a Google Kubernetes Engine (GKE) cluster, enabling GitOps-style management of GCP infrastructure through Kubernetes manifests.

**Note:** The original transcript for this video was not available during guide creation. This study guide is structured based on standard Config Connector installation procedures and topic continuity with Part 2 of the series.

## Key Concepts / Deep Dive

### Config Connector Overview

Config Connector is a Kubernetes add-on that extends the Kubernetes API to support Google Cloud resources. Key benefits include:

- **Infrastructure as Code**: Manage GCP resources using YAML manifests
- **GitOps Workflow**: Version control infrastructure alongside application code  
- **Kubernetes Native**: Use familiar kubectl commands to manage cloud resources
- **Resource Dependencies**: Handle complex resource relationships automatically

The connector supports 80+ Google Cloud services including Compute Engine, Cloud Storage, BigQuery, Cloud SQL, and more.

> [!IMPORTANT]
> Config Connector runs in your cluster and requires IAM permissions to create/manage GCP resources on your behalf.

### Service Accounts and Permissions

Config Connector uses Google Service Accounts for authentication:

- **Kubernetes Service Account**: Runs the connector pods
- **Google Service Account**: Provides GCP API access with required IAM roles
- **Workload Identity**: Recommended for secure authentication without API keys

Common required IAM roles:
```yaml
roles/owner                    # Full access (not recommended for production)
roles/editor                   # Edit access to resources
roles/storage.admin           # Cloud Storage management
roles/compute.admin           # Compute Engine management
roles/container.admin         # GKE cluster management
```

### Installation Methods

Three primary installation approaches:

1. **Google Cloud Marketplace** (Recommended)
   - Pre-configured with Workload Identity
   - Automatic updates
   - Easy cluster integration

2. **Manual Installation via YAML**
   - Direct kubectl application
   - Full control over configuration
   - Self-managed updates

3. **Config Connector Operator**
   - Manages Config Connector lifecycle
   - Automated upgrades
   - Multi-cluster support

## Lab Demo: Installing Config Connector

### Prerequisites
```bash
# Enable required APIs
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable container.googleapis.com

# Create a GKE cluster if not exists
gcloud container clusters create config-connector-demo \
  --zone us-central1-a \
  --num-nodes 2 \
  --enable-workload-identity
```

### Installation via Marketplace
```bash
# Install Config Connector via Google Cloud Marketplace
gcloud marketplace install \
  --project [PROJECT_ID] \
  --name config-connector \
  --version 1.114.0 \
  --cluster config-connector-demo \
  --cluster-location us-central1-a \
  --namespace configconnector-system

# Wait for installation to complete
kubectl wait --for=condition=available \
  --timeout=300s deployment/configconnector -n configconnector-system
```

### Manual Installation Alternative
```bash
# Download Config Connector manifests
gsutil cp gs://configconnector-operator/configconnector-operator.yaml .

# Apply manifests
kubectl apply -f configconnector-operator.yaml

# Create namespace
kubectl create namespace configconnector-system

# Apply Config Connector CRD
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/k8s-config-connector/master/operator/config/crds.yaml
```

### Service Account Setup
```bash
# Create Google Service Account
gcloud iam service-accounts create configconnector \
  --description="Service account for Config Connector" \
  --display-name="Config Connector"

# Grant required roles (example for basic setup)
gcloud projects add-iam-policy-binding [PROJECT_ID] \
  --member="serviceAccount:configconnector@[PROJECT_ID].iam.gserviceaccount.com" \
  --role="roles/editor"

# Enable Workload Identity
gcloud container clusters update config-connector-demo \
  --zone=us-central1-a \
  --workload-pool=[PROJECT_ID].svc.id.goog
```

## Lab Demo: Basic Configuration

### Creating Config Connector Configuration
```yaml
# configconnector.yaml
apiVersion: core.cnrm.cloud.google.com/v1beta1
kind: ConfigConnector
metadata:
  name: configconnector.core.cnrm.cloud.google.com
spec:
  mode: cluster
  googleServiceAccount: "configconnector@[PROJECT_ID].iam.gserviceaccount.com"
```

```bash
# Apply configuration
kubectl apply -f configconnector.yaml
```

### Testing Installation with a Simple Resource
```yaml
# storage-bucket.yaml
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: my-test-bucket-20231215
  namespace: default
spec:
  location: US
  storageClass: STANDARD
  versioning:
    enabled: true
```

```bash
# Deploy bucket
kubectl apply -f storage-bucket.yaml

# Verify creation
kubectl get storagebuckets

# Check GCP Console
gcloud storage buckets list --project [PROJECT_ID]
```

### Managing Resource Lifecycle

Config Connector supports standard Kubernetes operations:

```bash
# Update resource
kubectl edit storagebucket my-test-bucket-20231215

# Delete resource
kubectl delete storagebucket my-test-bucket-20231215

# View resource status and events
kubectl describe storagebucket my-test-bucket-20231215
```

## Summary

### Key Takeaways
```diff
+ Config Connector enables Kubernetes-native management of Google Cloud resources
+ Workload Identity provides secure authentication without API keys
+ Supports declarative infrastructure as code workflows
+ Handles complex resource dependencies automatically
+ Marketplace installation is recommended for simplicity
```

### Quick Reference

#### Installation Commands
```bash
# Marketplace install
gcloud marketplace install config-connector \
  --project [PROJECT_ID] \
  --cluster [CLUSTER_NAME] \
  --cluster-location [LOCATION]

# Basic resource test
kubectl apply -f storage-bucket.yaml
kubectl get storagebuckets
```

#### Common Annotations
```yaml
metadata:
  annotations:
    # Prevent deletion of cloud resource
    cnrm.cloud.google.com/deletion-policy: abandon
    
    # Force deletion ignoring dependencies  
    cnrm.cloud.google.com/force-destroy: "true"
    
    # Project override
    cnrm.cloud.google.com/project-id: "my-project"
    
    # State into Terraform
    cnrm.cloud.google.com/state-into-spec: absent
```

#### IAM Setup Script
```bash
#!/bin/bash
PROJECT_ID=my-project
SERVICE_ACCOUNT=configconnector

gcloud iam service-accounts create $SERVICE_ACCOUNT
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SERVICE_ACCOUNT@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/editor"
```

### Expert Insight

**Real-world Application**: Large enterprises use Config Connector for:
- Multi-environment deployments with consistent resource naming
- Automated cleanup of temporary environments
- Compliance enforcement through resource tagging
- Integration with existing CI/CD pipelines

**Expert Path**: 
- Start with Marketplace install and basic resources
- Implement least-privilege IAM with specific roles per resource type
- Use `cnrm.cloud.google.com/force-destroy` sparingly in production
- Monitor resource status with `kubectl get` commands and events
- Version control Config Connector manifests alongside application code

**Common Pitfalls**:
- Insufficient IAM permissions causing creation failures
- Forgetting `forceDestroy` annotation when resources have dependencies
- Ignoring namespace boundaries for resource scoping
- Not testing deletion policies in non-production first
- Mixing manual GCP changes with Config Connector managed resources

</details>
