# Session 35: Persistent Volumes in Kubernetes

## Table of Contents
- [Overview](#overview)
- [Persistent Volume Concepts Recap](#persistent-volume-concepts-recap)  
- [GCE Persistent Disk Deep Dive](#gce-persistent-disk-deep-dive)
- [Cloud Filestore (NFS) Alternative](#cloud-filestore-nfs-alternative)
- [Persistent Volume (PV) and Persistent Volume Claim (PVC)](#persistent-volume-pv-and-persistent-volume-claim-pvc)
- [Static vs Dynamic Provisioning](#static-vs-dynamic-provisioning)
- [Google Cloud Storage with GCS Fuse](#google-cloud-storage-with-gcs-fuse)
- [Demonstrations](#demonstrations)
- [Summary](#summary)

## Overview

This session explores persistent storage options in Kubernetes beyond basic empty directories, ConfigMaps, and Secrets. We dive deep into persistent volumes using Google Cloud's storage services including GCE Persistent Disk, Cloud Filestore (NFS), and Google Cloud Storage with GCS Fuse. The focus is on achieving data persistence that survives Pod and even cluster restarts, with trade-offs around performance, cost, and Cloud vendor lock-in.

## Persistent Volume Concepts Recap

### Non-Persistent Volumes vs Persistent Volumes

The previous session covered:
- **Empty Directory**: Lives with Pod lifecycle ❌
- **ConfigMap/Secrets**: Still non-persistent at volume level ❌  
- **GCE Persistent Disk**: Initial introduction ✅ (but with limitations)

Persistent volumes provide data retention even when:
- Pods get deleted/destroyed ✅
- Deployments scale beyond 1 replica ✅
- Entire Kubernetes cluster gets deleted ✅

```diff
- Empty Directory: Data lost on Pod deletion
- ConfigMap/Secret: No persistence, just configuration
+ Persistent Volume: Data survives Pod/cluster lifecycle  
```

## GCE Persistent Disk Deep Dive

### Key Characteristics
- **Single Zone**: Regional persistent disks are supported but costly
- **Read/Write Constraints**: Only one writer allowed per disk
- **Multiple Readers**: Multiple Pods can read in read-only mode
- **Deprecated in Kubernetes**: Official docs recommend CSI drivers

### Access Mode Limitations

```yaml
volumes:
- name: gce-persistent-disk
  gcePersistentDisk:
    pdName: gce-disk-name
    fsType: ext4
    readOnly: false  # Only when replica=1
```

**Critical Findings:**
- With `replica=1`: Works in read-write mode ✅
- With `replica>1`: Must use `readOnly: true`, allowing multiple readers only ⚠️
- Multiple writers impossible with persistent disk restrictions
- Deprecated: Future state managed by Container Storage Interface

> [!WARNING]
> GCE Persistent Disk is deprecated. Use CSI-based persistent disks instead.

### Cost Comparison (1TB Storage)

| Service | Standard HDD | SSD |
|---------|--------------|-----|
| Persistent Disk | ~$39/month | ~$870/month (Regional) |
| File Store | ~$163/month | N/A |
| Cloud Storage | ~$20/month | N/A |

## Cloud Filestore (NFS) Alternative

### Network Attached Storage Solution
- Fully managed NFS server by Google Cloud
- Supports multiple readers AND writers simultaneously ✅
- Regional resource (better performance across zones)
- Can cross regions (but with latency penalty)

"File Store acts as a shared Drive with true file system semantics"

### Key Advantages
- Multiple read-write access from different nodes ✅
- Multiple regions supported (though with performance hit)
- More expensive than persistent disk ($163+/month for basic)

### Performance Demonstration
- **Same Zone**: File creation ~11ms latency
- **Different Region**: File creation ~1 second latency  
- **Impact**: Significant performance degradation across geographic boundaries

```bash
# Mount NFS on VM
mount -t nfs -o rw,hard,rsize=65536,wsize=65536 [FILESTORE_IP]:/[SHARE_NAME] /mount/path
```

> [!NOTE]
> File store provides true NFS capabilities with multi-writer support at premium cost.

## Persistent Volume (PV) and Persistent Volume Claim (PVC)

### Separation of Concerns

**Traditional Approach:**
- Cluster Admin: Creates storage resource
- Application Developer: References in YAML

**PV/PVC Solution:**
- Cluster Admin creates PV (tied to specific storage type)
- Developer creates PVC (cloud-agnostic)
- Kubernetes matches PVC to available PV

### PVC Benefits
- **Cloud Agnostic**: Same YAML works across AWS, GCP, Azure
- **Volume Lifecycle**: Managed separately from Pod lifecycle
- **Dynamic Provisioning**: No manual disk creation needed

### Access Modes
- **ReadWriteOnce (RWO)**: Single node, read-write
- **ReadOnlyMany (ROX)**: Multiple nodes, read-only  
- **ReadWriteMany (RWX)**: Multiple nodes, read-write (rare support)

### YAML Structure

```yaml
# PV (Cluster Admin)
apiVersion: v1
kind: PersistentVolume
metadata:
  name: static-volume
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadOnlyMany  # For GCE Disk
  storageClassName: ""  # For static binding
  gcePersistentDisk:
    pdName: gce-disk-name
    fsType: ext4

# PVC (Developer) 
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: static-claim
spec:
  accessModes:
    - ReadOnlyMany
  storageClassName: ""  # Must match PV
  resources:
    requests:
      storage: 10Gi

# Deployment (Developer)
apiVersion: apps/v1
kind: Deployment
spec:
  volumes:
  - name: persistent-storage
    persistentVolumeClaim:
      claimName: static-claim  # Reference PVC
  containers:
  - volumeMounts:
    - mountPath: "/data"
      name: persistent-storage
      readOnly: true  # Match access mode
```

> [!IMPORTANT]
> PVCs enable cloud-agnostic Kubernetes deployments while maintaining data persistence.

## Static vs Dynamic Provisioning 

### Static Provisioning
1. Create GCE Disk manually
2. Create Matching PV
3. Create PVC 
4. Use in deployment

**Drawback:** Manual steps, error-prone ❌

### Dynamic Provisioning  
1. Create PVC directly ❌ (No disk creation needed)
2. Kubernetes auto-creates disk and PV behind scenes ✅

**YAML Simplification:**

```yaml
# Dynamic PVC - StorageClass triggers auto-provisioning
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dynamic-pvc
spec:
  accessModes:
    - ReadWriteOnce  # Single writer
  storageClassName: "standard"  # Or "premium-rwo" etc.
  resources:
    requests:
      storage: 1Gi  # Auto-increases disk size
```

### Dynamic Scaling Demo
- PVC increase from 1Gi → 3Gi → 5Gi creates disk expansion
- **Before Pod attachment**: PV size increases, PVC stays same
- **After Pod attachment**: PVC size matches PV automatically

```diff
+ Dynamic Provisioning Benefits:
+ - No manual disk management
+ - Auto-scaling storage capacity  
+ - Zero-touch operations for developers
- Static Provisioning Drawbacks:
- - Manual cmake maintenance
- - Error-prone human intervention
```

## Google Cloud Storage with GCS Fuse

### Blob Storage as File System
- **GCS**: Object storage, not true file system
- **GCS Fuse**: Adapter for POSIX-like file access
- **Performance Trade-off**: Cheaper than FileStore but slower

### Setup Requirements
1. **Workload Identity**: Enable on cluster
2. **CSI Driver**: Install GCS Fuse CSI driver  
3. **Service Account**: Proper IAM permissions

### Cost vs Performance Matrix

| Metric | FileStore | GCS Fuse | Persistent Disk |
|--------|-----------|----------|------------------|
| Cost | High ($163+) | Low ($20) | Medium ($39-$870) |
| Performance | Best | Good | Good-Slow |
| Multi-Write | ✅ | ✅ | ❌ |
| Regions | ✅ | ✅ | Limited |

### Installation Demo

```bash
# Install on VM/Cloud Shell
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb http://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install gcsfuse

# Mount bucket
mkdir /demo
gcsfuse gcs-bucket-name /demo
# Provides 1PB virtual filesystem
```

> [!TIP] 
> GCS Fuse excels in cost-effective scenarios where performance is secondary to multi-region access.

## Demonstrations

### 1. GCE Persistent Disk Read-Only Multi-Pod Test

```diff
- Single Pod (replica=1): ✅ ReadWrite
- Multi-Pod (replica=3): ❌ Attach failure unless readOnly: true
! Result: "Insufficient storage" error for multiple writers
```

### 2. FileStore NFS Multi-Writer Setup

```yaml
# Works with replica > 1 and readOnly: false
apiVersion: apps/v1
kind: Deployment  
spec:
  replicas: 3
  volumes:
  - name: nfs-volume
    nfs:
      server: [FILESTORE_IP]
      path: /
```

**Results:** ✅ Multiple writers, simultaneous read/write across Pods

### 3. PV/PVC Static Binding

**PV State Flow:**
```
Available → Bound (after PVC creation)
```

### 4. Dynamic PVC Provisioning

```diff
+ PVC Created: Auto-creates disk + PV
+ PVC Resized: Auto-expands disk on attachment
```

### 5. GCS Fuse Performance Test

```diff
- Latency: 1-2 seconds cross-region vs 11ms same-zone FileStore
+ Cost Savings: ~87% cheaper than FileStore
- File Operations: Noticeable lag vs true NFS
```

## Summary

### Key Takeaways

```diff
+ Persistent Volumes survive Pod/Cluster lifecycle
+ GCE Disk: Single-writer, deprecated in favor of CSI  
+ FileStore: Premium NFS with multi-writer, multi-region support
+ PVCs enable cloud-agnostic deployments
+ Dynamic provisioning eliminates manual disk management
+ GCS Fuse: Cost-effective alternative with performance trade-offs
- No single solution fits all use cases
! Storage choice depends on: performance budget, write patterns, compliance needs
```

### Quick Reference

**GCE Persistent Disk Commands:**
```bash
# Create regional disk (experimental)
gcloud compute disks create regional-disk \
  --region=us-central1 \
  --replica-zones=us-central1-a,us-central1-b \
  --size=10GB
```

**FileStore Setup:**
```bash
# Create filestore instance  
gcloud filestore instances create nfs-server \
  --location=us-central1 \
  --tier=BASIC_HDD \
  --file-share=name="vol1",capacity=1TB \
  --network=name="default"
```

**PVC Resize:**
```bash
kubectl patch pvc/my-pvc \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/resources/requests/storage", "value": "100Gi"}]'
```

### Expert Insight

#### Real-world Application
In production ML/AI workloads, GCS Fuse is commonly used to mount model storage buckets (often tens of GBs) as read-only volumes across multiple inference Pods. FileStore serves high-performance shared storage for database clusters requiring simultaneous writes.

#### Expert Path  
Master Kubernetes storage by:
1. Understanding CSI evolution away from deprecated volumes
2. Practicing both static/dynamic provisioning patterns  
3. Performance benchmarking storage options under load
4. Implementing multi-cloud agnostic PVC strategies

#### Common Pitfalls
- **PVC Access Mode Mismatches**: Requesting ReadWriteMany when storage doesn't support it
- **StorageClass Misconfigurations**: Wrong classes prevent PV to PVC binding
- **Cross-Zone Networking Costs**: Overlooked egress charges with regional FileStore
- **GCS Fuse Metadata Operations**: Treating it like NFS can cause performance bottlenecks

#### Lesser-Known Facts
- Kubernetes auto-installs NFS client utilities in containers when using NFS volumes
- Dynamic PVC resizing works with most cloud providers but requires cluster support
- Workload Identity + CSI drivers eliminate service account key management entirely
- GCS Fuse maintains file cache locally to improve performance on repeated access

## Advantages & Disadvantages

| Storage Type | Advantages | Disadvantages |
|--------------|------------|---------------|
| GCE Persistent Disk | Familiar block storage, good performance | Deprecated, single-writer, regional costs |
| FileStore (NFS) | True multi-writer, regional/global access | High cost ($163+/TB), performance varies by region |
| GCS Fuse | Cheapest option ($20/TB), infinite scale | Object-to-file overhead, performance lag, not true POSIX |
| PVC/PV | Cloud agnostic, auto-provisioning | Additional YAML layers, storage class complexity |
