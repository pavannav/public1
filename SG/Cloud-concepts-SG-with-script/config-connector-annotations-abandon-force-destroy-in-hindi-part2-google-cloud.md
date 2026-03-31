# Session 2: Config Connector Annotations (Abandon, Force Destroy)

**Target Audience**: Beginners aspiring to reach an Expert level in Google Cloud and Config Connector.

## Table of Contents
- [Editing Resources and Annotations](#editing-resources-and-annotations)
- [Abandon Annotation](#abandon-annotation)
- [Force Destroy Annotation](#force-destroy-annotation)
- [Lab Demo: Deleting Bucket with Objects](#lab-demo-deleting-bucket-with-objects)
- [Summary](#summary)

## Editing Resources and Annotations

### Overview
Config Connector is a Kubernetes add-on that enables management of Google Cloud resources through Kubernetes custom resources. Annotations in Config Connector allow fine-grained control over resource lifecycle, particularly for deletion operations. This session builds on basic tree configurations from Part 1, focusing on advanced annotations for handling resource abandonment and forced destruction in scenarios where resources cannot be deleted cleanly.

### Key Concepts/Deep Dive

**Resource Deletion Challenges**
- In Config Connector, simply deleting a Kubernetes resource does not always guarantee the deletion of the underlying Google Cloud resource.
- Common scenarios include resources with dependent objects (e.g., Cloud Storage buckets containing files, Compute Engine instances with attached disks).
- Without proper annotations, resources may remain orphaned in Google Cloud, leading to unmanaged billing and security risks.

**Annotation Types Covered**
1. *Abandon* annotation: Detaches Kubernetes management while preserving the Google Cloud resource
2. *Force Destroy* annotation: Forces deletion of the Google Cloud resource and its contents, even if dependencies exist

**Technical Details**
- Annotations are applied as metadata fields in the Config Connector resource YAML
- Syntax follows standard Kubernetes annotation format: `annotation-key: "annotation-value"`
- Annotations take effect during resource lifecycle operations (create, update, delete)

## Abandon Annotation

### Overview
The *abandon* annotation (`configconnector.googleapis.com/abandon: "true"`) instructs Config Connector to relinquish control of the Google Cloud resource without deleting it. This is useful for migrating resources to other management tools or preserving data during reconfiguration.

### Key Concepts/Deep Dive

**Use Cases**
- Resource migration between management systems
- Preserving historical data during Kubernetes cluster refactoring
- Testing configurations without permanent deletions

**Behavior**
- Applied during delete operations
- Config Connector removes its references but leaves the resource intact in Google Cloud
- Subsequent management must be handled manually or through other tools

**Implementation**
```yaml
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: my-bucket
  annotations:
    configconnector.googleapis.com/abandon: "true"
spec:
  location: US
```

**Verification Steps**
1. Apply the annotation to the resource
2. Delete the Kubernetes resource
3. Check Google Cloud console - resource should remain
4. Verify Config Connector status shows clean dissociation

> [!NOTE]
> Use abandon cautiously to avoid resource accumulation in your Google Cloud environment.

## Force Destroy Annotation

### Overview
The *force delete* annotation (`configconnector.googleapis.com/force-destroy: "true"`) enables aggressive deletion of Google Cloud resources, including cascading deletion of contained objects. This is particularly useful for storage buckets with files or container registries with images that block standard deletion.

### Key Concepts/Deep Dive

**Use Cases**
- Cleaning up test environments with populated resources
- Forcing deletion of storage buckets containing files
- Removing container registries with image artifacts

**Behavior**
- Applied during delete operations
- Automatically handles dependency deletion
- Bypasses typical "resource not empty" protections

**Implementation**
```yaml
apiVersion: storage.cnrm.cloud.google.com/v1beta1
kind: StorageBucket
metadata:
  name: my-bucket
  annotations:
    configconnector.googleapis.com/force-destroy: "true"
spec:
  location: US
```

**Dependency Handling**
- Storage buckets: Automatic deletion of all objects
- Compute resources: Termination with forced deallocation
- Container registries: Removal of all images and versions

> [!WARNING]
> Force destroy operations are irreversible. Ensure you have backups before applying.

**Synchronous vs Asynchronous Processing**
- Large resource deletions may take time
- Monitor deletion status through kubectl and Google Cloud console
- Retries are automatic in most cases

## Lab Demo: Deleting Bucket with Objects

### Overview
This hands-on demonstration shows the practical application of Config Connector annotations for managing Google Cloud Storage buckets, including scenarios where standard deletion fails.

### Key Concepts/Deep Dive

**Scenario Setup**
- Create a StorageBucket resource using Config Connector
- Upload objects to trigger deletion blocking
- Demonstrate abandon vs. force destroy behavior

### Step-by-Step Lab Demo

1. **Environment Preparation**
   ```bash
   kubectl create namespace demo-namespace
   ```

2. **Create StorageBucket Resource**
   ```yaml
   apiVersion: storage.cnrm.cloud.google.com/v1beta1
   kind: StorageBucket
   metadata:
     name: config-connector-demo-bucket
   spec:
     location: US
   ```
   Apply with:
   ```bash
   kubectl apply -f bucket.yaml
   ```

3. **Initial Deletion Attempt (Without Annotations)**
   - Upload a file to the bucket via Google Cloud Console
   ```bash
   kubectl delete storagebucket config-connector-demo-bucket
   ```
   - Observe deletion failure due to non-empty bucket
   - Verify bucket remains in Google Cloud Storage

4. **Apply Abandon Annotation**
   ```yaml
   apiVersion: storage.cnrm.cloud.google.com/v1beta1
   kind: StorageBucket
   metadata:
     name: config-connector-demo-bucket
     annotations:
       configconnector.googleapis.com/abandon: "true"
   spec:
     location: US
   ```
   Apply changes:
   ```bash
   kubectl apply -f bucket.yaml
   ```
   Delete resource:
   ```bash
   kubectl delete storagebucket config-connector-demo-bucket
   ```
   - Kubernetes resource removed
   - Google Cloud bucket and contents preserved

5. **Apply Force Destroy Annotation**
   ```yaml
   apiVersion: storage.cnrm.cloud.google.com/v1beta1
   kind: StorageBucket
   metadata:
     name: another-demo-bucket
     annotations:
       configconnector.googleapis.com/force-destroy: "true"
   spec:
     location: US
   ```
   - Upload objects to the new bucket
   - Delete the Kubernetes resource:
     ```bash
     kubectl delete storagebucket another-demo-bucket
     ```
   - Verify complete deletion in Google Cloud Console
   - Asynchronous processing may take a few minutes

### Verification Commands

```bash
# Check Config Connector resources
kubectl get storagebucket

# Verify Google Cloud resource status
gsutil ls gs://bucket-name/

# Check Config Connector status
kubectl describe storagebucket bucket-name
```

**Key Observations**
- Abandon preserves resources for manual management
- Force destroy enables complete cleanup
- Annotations provide fine-grained lifecycle control

## Summary

### Key Takeaways
```diff
+ Config Connector annotations provide precise control over Google Cloud resource lifecycles
+ Abandon annotation (configconnector.googleapis.com/abandon: "true") detaches management while preserving resources
+ Force Destroy annotation (configconnector.googleapis.com/force-destroy: "true") enables complete resource deletion including dependencies
+ Annotations are applied in resource metadata and take effect during delete operations
+ Use abandon for migrations and force destroy for cleanup scenarios
! Always verify annotation effects in non-production environments first
- Force destroy operations are irreversible - ensure backups exist
```

### Expert Insight

**Real-world Application**
In production Google Cloud environments using Config Connector for infrastructure as code, annotations enable sophisticated lifecycle management. For example, during cluster upgrades, you might abandon persistent resources like StorageBuckets with historical data, then re-adopt them post-migration. Force destroy is invaluable for tearing down test environments or handling CI/CD pipeline cleanup where resources accumulate rapidly.

**Expert Path**
Master Config Connector annotations by studying all annotation types beyond abandon and force-destroy. Experiment with conditional configurations using annotations in GitOps pipelines. Learn to combine annotations with resource policies for advanced automation scenarios. Practice with different resource types (Compute, Storage, Networking) to understand varying deletion behaviors.

**Common Pitfalls**
- Applying annotations to resources with production dependencies without backups
- Forgetting that abandoned resources accumulate unnecessary cloud costs
- Assuming force destroy works instantaneously for large resource sets
- Not testing annotation combinations in staging environments

**Common Issues and Resolutions**
- *Issue*: Deletion hangs with "resource not empty"
  - *Resolution*: Apply force-destroy annotation, wait for asynchronous completion
  - *Prevention*: Document resource dependencies and use consistent cleanup policies
- *Issue*: Abandoned resources become unmanaged zombies
  - *Resolution*: Maintain inventory of abandoned resources with scheduled reviews
  - *Prevention*: Limit abandon usage to migration scenarios only
- *Issue*: Annotation changes not taking effect
  - *Resolution*: Ensure resource is re-applied after annotation modification
  - *Prevention*: Test annotation logic in isolated namespaces

**Lesser Known Things**
- Config Connector annotations can be applied to entire namespaces using label selectors
- Force destroy operations generate audit logs in Google Cloud for compliance tracking
- Annotations work with Config Connector's drift detection, enabling automated reconciliation
- Some resource types have additional specialized annotations beyond the standard set

---
*Model ID: CL-KK-Terminal*  
*Corrections made: "कनफ्लिक्ट" corrected to "Config Connector"; "एडिटर" to "Editor"; "नेक्स्ट" to "next"; various Hindi-English mix standardized; "आबंदों" interpreted and corrected to "abandon"; "फॉल्स" to "force"; "बकेट प्ले" to "bucket play"; missing punctuation and structure added for readability.*
