# Session 15: Config Connector Annotations, Abandon & Force Destroy (Part 2) - Google Cloud

<details open>
<summary><b>Config Connector Annotations, Abandon & Force Destroy (Part 2) - Google Cloud (KK-CS45-script-v3)</b></summary>

## Table of Contents

### [Overview](#overview)
### [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
#### [Config Connector Basics](#config-connector-basics)
#### [Resource Management Annotations](#resource-management-annotations)
#### [Abandon Annotations](#abandon-annotations)
#### [Force Destroy Policies](#force-destroy-policies)
#### [Resource Dependencies](#resource-dependencies)
### [Lab Demo: Managing Google Cloud Storage with Config Connector](#lab-demo-managing-google-cloud-storage-with-config-connector)
#### [Creating Resources](#creating-resources)
#### [Abandon Behavior Demonstration](#abandon-behavior-demonstration)
#### [Force Destroy Scenario](#force-destroy-scenario)
#### [Cleaning Up Dependencies](#cleaning-up-dependencies)
### [Summary](#summary)

## Overview

This session continues the exploration of Config Connector's advanced resource management features, focusing on critical annotations and destruction policies when managing Google Cloud resources through Kubernetes declarative configurations. Config Connector acts as a bridge between Kubernetes-style resource management and Google Cloud infrastructure, enabling teams to manage cloud resources using GitOps practices.

The demonstration showcases practical implementation of:
- **Abandon annotations** to separate Kubernetes resources from their actual cloud counterparts
- **Force destroy policies** for ensuring complete resource cleanup
- **Dependency management** when dealing with resources containing objects (like storage buckets with files)

## Key Concepts/Deep Dive

### Config Connector Basics

Config Connector enables declarative management of Google Cloud resources using Kubernetes Custom Resource Definitions (CRDs). Resources are defined as YAML manifests and applied to a Kubernetes cluster, where Config Connector reconciles the desired state with the actual Google Cloud infrastructure.

```yaml
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: my-config-connector-bucket
spec:
  location: US-CENTRAL1
  storageClass: STANDARD
```

### Resource Management Annotations

Config Connector uses special annotations to control resource lifecycle behavior:

#### Deletion Policy Annotations

- `cnrm.cloud.google.com/deletion-policy: abandon` - Prevents deletion of the Google Cloud resource when the Kubernetes object is deleted
- `cnrm.cloud.google.com/deletion-policy: delete` - Allows normal deletion (default behavior)
- `cnrm.cloud.google.com/force-destroy: "true"` - Forces deletion of resources even with dependencies

### Abandon Annotations

The `abandon` annotation is crucial for managing resource ownership transitions:

```yaml
metadata:
  annotations:
    cnrm.cloud.google.com/deletion-policy: abandon
```

**Behavior:**
- When set, deleting the Kubernetes resource does NOT delete the corresponding Google Cloud resource
- The cloud resource becomes "orphaned" and can be managed independently
- Useful for:
  - Migrating resources from declarative to imperative management
  - Preserving production resources during configuration changes
  - Gradual decommissioning of infrastructure components

> [!WARNING]
> Abandoned resources are no longer tracked by Config Connector and may incur costs if not properly managed elsewhere.

### Force Destroy Policies

Force destroy policies handle complex deletion scenarios, particularly when resources contain dependent objects.

**Force Destroy Annotation:**
```yaml
metadata:
  annotations:
    cnrm.cloud.google.com/deletion-policy: delete
    cnrm.cloud.google.com/force-destroy: "true"
```

**Use Cases:**
- Storage buckets containing objects that must be deleted
- Compute instances with attached persistent disks
- Network resources with dependent configurations

> [!IMPORTANT]
> Force destroy operations cannot be reversed. Ensure all dependent resources are ready for deletion before applying this policy.

### Resource Dependencies

Config Connector must handle resource interdependencies during lifecycle operations:

**Common Dependency Scenarios:**
- Storage buckets with objects/files
- Virtual machines with attached disks
- Networks with subnets and firewall rules
- Databases with tables or collections

**Dependency Management Strategy:**
1. **Pre-deletion validation** - Confirm resources are ready for cleanup
2. **Manual dependency removal** - Delete child resources first
3. **Force destroy as last resort** - Use when manual cleanup is impractical

## Lab Demo: Managing Google Cloud Storage with Config Connector

### Creating Resources

First, create a namespace for Config Connector resources:

```bash
kubectl create namespace config-connector-demo
```

Apply the StorageBucket manifest:

```yaml
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: config-connector-demo-bucket
  namespace: config-connector-demo
spec:
  location: US-CENTRAL1
  storageClass: STANDARD
```

Verify creation:
```bash
kubectl get storagebucket -n config-connector-demo
```

### Abandon Behavior Demonstration

Test the default behavior by deleting without abandon annotation:

```bash
kubectl delete storagebucket config-connector-demo-bucket -n config-connector-demo
```

**Expected Result:** Both Kubernetes resource and Google Cloud bucket are deleted.

Recreate and add the abandon annotation:

```yaml
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: config-connector-demo-bucket
  namespace: config-connector-demo
  annotations:
    cnrm.cloud.google.com/deletion-policy: abandon
spec:
  location: US-CENTRAL1
  storageClass: STANDARD
```

Now delete with abandon annotation:

```bash
kubectl delete storagebucket config-connector-demo-bucket -n config-connector-demo
```

**Result:** Kubernetes resource is removed, but the Google Cloud bucket persists.

### Force Destroy Scenario

Create a new bucket and upload files:

```yaml
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: force-destroy-demo-bucket
  namespace: config-connector-demo
spec:
  location: US-CENTRAL1
  storageClass: STANDARD
```

Upload sample files to the bucket (through Google Cloud Console or CLI).

Attempt normal deletion:

```bash
kubectl delete storagebucket force-destroy-demo-bucket -n config-connector-demo
```

**Expected Result:** Deletion fails because bucket contains objects.

### Cleaning Up Dependencies

Manually remove all objects from the bucket, then apply force destroy:

```yaml
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: force-destroy-demo-bucket
  namespace: config-connector-demo
  annotations:
    cnrm.cloud.google.com/deletion-policy: delete
    cnrm.cloud.google.com/force-destroy: "true"
spec:
  location: US-CENTRAL1
  storageClass: STANDARD
```

Apply the configuration:
```bash
kubectl apply -f force-destroy-bucket.yaml
```

Verify cleanup - both Kubernetes resource and cloud bucket should be deleted.

## Summary

### Key Takeaways

```diff
+ Abandon annotations preserve cloud resources when Kubernetes objects are deleted
+ Force destroy enables cleanup of resources with dependencies
+ Always check resource dependencies before deletion operations
+ Config Connector bridges declarative Kubernetes management with imperative cloud resources
+ Plan resource ownership transitions carefully to avoid cost overruns
```

### Quick Reference

**Common Annotations:**

```yaml
# Abandon - Preserve cloud resource
cnrm.cloud.google.com/deletion-policy: abandon

# Force destroy - Clean up all dependencies
cnrm.cloud.google.com/deletion-policy: delete
cnrm.cloud.google.com/force-destroy: "true"
```

**Commands:**

```bash
# Check resource status
kubectl get storagebucket -n <namespace>

# Apply configurations
kubectl apply -f resource.yaml

# Delete resources
kubectl delete storagebucket <name> -n <namespace>
```

### Expert Insight

**Real-world Application:**
In production environments, use abandon annotations during infrastructure refactoring to prevent accidental resource deletion. Combine with GitOps workflows to safely transition resources between different management patterns.

**Expert Path:**
Master complex dependency mapping using Config Connector's status fields. Learn to automate cleanup workflows with custom operators that handle cascading deletions. Study Google Cloud service-specific deletion behaviors to predict force destroy requirements.

**Common Pitfalls:**
- Forgetting to clean up bucket objects before deletion
- Assuming abandon means "free" - orphaned resources still generate cloud costs
- Race conditions when multiple operators manage the same resources
- Not testing deletion policies in lower environments first
- Ignoring service-specific cleanup requirements (databases, networking, etc.)

</details>