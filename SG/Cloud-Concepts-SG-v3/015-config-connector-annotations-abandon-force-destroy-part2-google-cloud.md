# Session 015: Config Connector Annotations - Abandon Force Destroy Part 2 (Google Cloud)

<details open>
<summary><b>Session 015: Config Connector Annotations - Abandon Force Destroy Part 2 (Google Cloud) (KK-CS45-script-v3)</b></summary>

## Table of Contents
- [Overview](#overview)
- [Key Concepts/Deep Dive](#key-conceptsdeep-dive)
- [Lab Demos](#lab-demos)
- [Summary](#summary)

## Overview

This session continues the exploration of Config Connector's advanced resource management capabilities in Google Cloud. Building on the previous session's discussion of annotation handling, this video focuses on two critical resource lifecycle annotations: **abandon** and **force destroy**. These annotations provide control over how Config Connector handles resource deletion, particularly when dealing with resources that have dependencies or contain other resources (like Cloud Storage buckets with objects).

The session demonstrates practical scenarios where standard deletion might fail and introduces annotation-based solutions for managing complex resource lifecycles.

## Key Concepts/Deep Dive

### Deletion Policy Annotations

Config Connector uses specific annotations to control how resources are deleted from both Kubernetes and the underlying cloud provider. These annotations provide granular control over the deletion process and help prevent unintended data loss.

#### `cnrm.cloud.google.com/deletion-policy`

This annotation determines the deletion behavior:

- **`delete`** (default): Removes the resource from both Kubernetes and the cloud provider
- **`abandon`**: Removes the resource from Kubernetes management but leaves it intact in the cloud provider
- **`force-delete`**: Performs additional cleanup operations before deletion (varies by resource type)

### Abandon vs Delete

When `deletion-policy: "abandon"` is set:

**Benefits:**
- Preserves cloud resources when you want to stop managing them through Config Connector
- Allows manual management or migration to different tools
- Prevents accidental deletion of important resources

**Use Cases:**
- Transitioning resources to different management tools
- Preserving data during Config Connector reconfiguration
- Debugging resource management issues without data loss

### Force Destroy Operations

Force destroy typically involves additional cleanup operations before the main resource deletion. The behavior varies by resource type.

#### Cloud Storage Buckets with Objects

For Cloud Storage buckets containing objects, the `force-delete` annotation:
- Automatically deletes all objects in the bucket before deleting the bucket itself
- Prevents deletion failures due to non-empty buckets
- Ensures complete resource cleanup

#### Limitations and Safety

```diff
+ Abandon preserves resources for manual management
+ Force destroy ensures complete cleanup
- Abandon can lead to unmanaged resources accumulating costs
- Force destroy may cause data loss if not used carefully
! Always verify resource contents before using force-delete
```

> [!IMPORTANT] 
> Use deletion policies carefully. Abandon can lead to orphaned resources with ongoing costs, while force-delete can permanently remove data.

## Lab Demos

### Demo 1: Abandon Policy with Cloud Storage Bucket

**Objective:** Demonstrate how the abandon annotation preserves resources in Google Cloud while removing Config Connector management.

**Steps:**

1. **Create a Cloud Storage Bucket:**
   ```bash
   # Open the Config Connector manifest
   kubectl create -f bucket-manifest.yaml
   ```

2. **Verify Creation:**
   ```bash
   # Check Kubernetes resource
   kubectl get storagebucket
   
   # Verify in Google Cloud Console
   # Bucket exists and is managed by Config Connector
   ```

3. **Set Abandon Annotation:**
   ```yaml
   apiVersion: storage.cnrm.cloud.google.com/v1beta1
   kind: StorageBucket
   metadata:
     name: my-bucket
     annotations:
       cnrm.cloud.google.com/deletion-policy: "abandon"
   ```

4. **Delete the Resource:**
   ```bash
   kubectl delete storagebucket my-bucket
   ```

5. **Verification:**
   ```bash
   # Resource removed from Kubernetes
   kubectl get storagebucket  # Returns empty
   
   # Bucket still exists in Google Cloud Console
   # Config Connector no longer manages this resource
   ```

### Demo 2: Force Delete with Non-Empty Bucket

**Objective:** Show how force delete handles buckets containing objects.

**Steps:**

1. **Create Bucket and Upload Content:**
   ```bash
   # Create bucket
   kubectl create -f bucket-manifest.yaml
   
   # Upload file to bucket (demonstration)
   gsutil cp some-file.txt gs://my-bucket/
   ```

2. **Attempt Standard Deletion (Will Fail):**
   ```bash
   kubectl delete storagebucket my-bucket
   # Deletion will stall - bucket contains objects
   ```

3. **Check Deletion Policy:**
   ```yaml
   # Current annotation (default delete)
   annotations:
     cnrm.cloud.google.com/deletion-policy: "delete"
   ```

4. **Set Force Delete Annotation:**
   ```yaml
   apiVersion: storage.cnrm.cloud.google.com/v1beta1
   kind: StorageBucket
   metadata:
     name: my-bucket
     annotations:
       cnrm.cloud.google.com/deletion-policy: "force-delete"
   spec:
     location: US
   ```

5. **Execute Force Deletion:**
   ```bash
   kubectl apply -f bucket-manifest.yaml  # Update annotation
   kubectl delete storagebucket my-bucket  # Now succeeds
   ```

6. **Verification:**
   ```bash
   # Check bucket status during deletion
   kubectl get storagebucket my-bucket -o yaml
   # Shows deletion in progress
   
   # After completion, bucket and objects are gone from Google Cloud
   gsutil ls gs://my-bucket/  # Returns error - bucket not found
   ```

### Demo 3: Resource Import Preview

The session ends with a preview of importing existing cloud resources into Config Connector management.

**Key Points Mentioned:**
- Import functionality for running resources
- Management of pre-existing cloud resources
- Integration with Config Connector ecosystem

## Summary

### Key Takeaways
```diff
+ Abandon annotation preserves resources in cloud while removing Config Connector management
+ Force delete annotation enables cleanup of dependent resources (like bucket objects) before deletion
- Deletion can fail if buckets contain objects without proper annotations
! Always verify resource state before applying deletion policies
+ Import functionality (teased for next video) manages existing cloud resources
```

### Quick Reference

**Abandon Annotation:**
```yaml
metadata:
  annotations:
    cnrm.cloud.google.com/deletion-policy: "abandon"
```

**Force Delete Annotation:**
```yaml
metadata:
  annotations:
    cnrm.cloud.google.com/deletion-policy: "force-delete"
```

**Check Resource Status:**
```bash
kubectl get [resource-type] [resource-name] -o yaml
```

### Expert Insight

**Real-world Application:**
In enterprise environments, these annotations are crucial for:
- **Resource Migration**: Use `abandon` when transitioning from Terraform to Config Connector or vice versa
- **Cost Management**: Identify abandoned resources that are no longer needed but still accruing costs
- **Disaster Recovery**: Preserve critical resources during Config Connector reconfiguration
- **CI/CD Pipelines**: Use force-delete in cleanup jobs to ensure complete environment teardown

**Expert Path:**
1. **Audit Existing Resources**: Regularly check for unmanaged resources using cloud provider queries
2. **Policy Standardization**: Establish organization-wide annotation policies for different resource types
3. **Monitoring Integration**: Implement monitoring to track resource lifecycle events and annotation usage
4. **Backup Strategies**: Combine abandon with automated backups before force operations

**Common Pitfalls:**
- **Cost Accumulation**: Abandoned resources continue to generate charges but aren't tracked in Kubernetes
- **Silent Failures**: Force delete operations might fail silently if service accounts lack permissions
- **Dependency Issues**: Not all force delete implementations handle all dependency types equally
- **State Inconsistency**: Manual cloud operations on abandoned resources can create sync issues

</details>
