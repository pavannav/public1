# Session 35: Persistent Volume

## Table of Contents
1. [Recap: Empty Directory vs Persistent Volumes](#recap-empty-directory-vs-persistent-volumes)
2. [GCE Persistent Disk](#gce-persistent-disk)
3. [Introduction to File Store](#introduction-to-file-store)
4. [Cost Comparison: Persistent Disk vs File Store vs Cloud Storage](#cost-comparison-persistent-disk-vs-file-store-vs-cloud-storage)
5. [File Store VM Demonstrations](#file-store-vm-demonstrations)
6. [Kubernetes File Store Integration](#kubernetes-file-store-integration)
7. [NFS Deployment Demonstrations](#nfs-deployment-demonstrations)
8. [Persistent Volume and Persistent Volume Claim Concepts](#persistent-volume-and-persistent-volume-claim-concepts)
9. [Static vs Dynamic Provisioning](#static-vs-dynamic-provisioning)
10. [GCSFuse with Cloud Storage](#gcsfuse-with-cloud-storage)
11. [Summary: Key Takeaways and Expert Insights](#summary-key-takeaways-and-expert-insights)

## Recap: Empty Directory vs Persistent Volumes

### Overview
This session builds upon the previous discussion of storage in Kubernetes. Empty directory volumes were explored earlier, providing temporary storage that gets destroyed when pods terminate. In contrast, persistent volumes retain data even when pods are deleted.

### Key Concepts
The fundamental difference lies in data persistence:
- **Empty Directory**: Ephemeral storage that disappears when pods are deleted
- **Persistent Volume**: Maintains data integrity across pod lifecycles

Empty directory volumes are simple and cloud-agnostic, working identically across any Kubernetes environment. However, they lack true persistence, making persistent volumes essential for applications requiring data durability.

## GCE Persistent Disk

### Overview
Google Compute Engine (GCE) persistent disks provide persistent block storage within Google Cloud. The key limitation is that they can only be attached in specific access modes.

### Key Concepts: Access Modes and Limitations

#### Single Pod - Read-Write Mode
```yaml
volumes:
- name: gce-disk
  gcePersistentDisk:
    fsType: ext4
    pdName: my-disk
```

When configured with a single replica (`replicas: 1`), the disk can be mounted in read-write mode. This creates a one-to-one mapping between the pod and the disk.

#### Multiple Pods - Read-Only Mode
For deployments with multiple replicas, the persistent disk must be configured with `readOnly: true` to allow multiple pods to access the data simultaneously:

```yaml
volumes:
- name: gce-disk
  gcePersistentDisk:
    fsType: ext4
    pdName: my-disk
    readOnly: true
```

**Critical Limitation**: GCE persistent disks cannot be attached to multiple pods in read-write mode simultaneously due to technical constraints.

### Demonstration Findings
Testing revealed that attempting read-write mode with multiple replicas fails, throwing an "insufficient storage" error. This occurs even with single-replica deployments that scale up, as Kubernetes cannot attach the same read-write disk to multiple pods.

**Deprecated Status**: GCE persistent disk implementations have been deprecated in favor of Container Storage Interface (CSI) drivers for cloud-native storage management.

## Introduction to File Store

### Overview
Google Cloud Filestore provides fully managed network-attached storage (NAS) that can be mounted using the Network File System (NFS) protocol. Unlike GCE persistent disks, it supports concurrent read-write access from multiple clients across different regions.

### Key Concepts and Advantages

#### Multi-Writer Support
Filestore overcomes the primary limitation of GCE persistent disks by supporting multiple simultaneous writers:

- **Read-Write Many**: Multiple pods can access the same file system for both reading and writing simultaneously
- **Cross-Region Access**: Can be accessed from different GCP regions (though with increased latency for distant regions)
- **Regional Resource**: Must be provisioned in a specific region, but can serve clients globally

#### Regional Deployment Strategy
For optimal performance:
- Deploy Filestore in the same region as your Kubernetes cluster
- Regional latency is minimal compared to cross-region data transfer
- Pricing varies by performance tier and storage capacity

#### Basic vs Enterprise Tiers
- **Basic Tier**: General-purpose NFS, capacity up to 64TB
- **Regional Tier**: High-performance computing, up to 100TB
- **Zonal Tier**: Cost-effective option with HDD storage

## Cost Comparison: Persistent Disk vs File Store vs Cloud Storage

### Cost Analysis for 1TB Storage

#### Persistent Disk SSD (Regional)
```bash
Pricing: ~$39/month for 1TB zonal SSD
- Pro: High performance
- Con: Cannot support multiple writers
```

#### Filestore Basic (Regional)
```bash
Pricing: ~$163/month for 1TB
- Pro: Multi-writer support, regional availability
- Con: Higher cost than persistent disk
```

#### Google Cloud Storage (Single Region Standard)
```bash
Pricing: ~$20/month for 1TB
- Pro: Lowest cost, global accessibility
- Con: Higher latency than traditional file systems
```

### High-End Configuration Comparison (2.5TB)

#### Persistent Disk SSD Regional
```bash
Pricing: ~$870/month for 2.5TB SSD regional
```

#### Filestore Regional/Zonal
```bash
Pricing: ~$100-150/month for 2.5TB
```

#### Cloud Storage Regional
```bash
Pricing: ~$50/month for 2.5TB
```

**Key Insight**: Cloud Storage offers the best price/performance ratio for cost-sensitive deployments, while Filestore provides the best performance for applications requiring traditional file system semantics.

## File Store VM Demonstrations

### VM Setup and Mounting

#### VM Configuration
Create VMs in target regions with startup scripts to install NFS client:

```bash
# Startup script for NFS mounting
apt-get update
apt-get install nfs-common -y
mkdir /mnt/gc-filestore
mount -t nfs [FILESTORE_IP]:/[SHARE_NAME] /mnt/gc-filestore
```

#### Cross-Region Performance Testing
Testing revealed significant latency differences:

**Same Region (US Central)**:
```
File creation: ~11ms
Listing: ~6-8ms response time
```

**Cross-Region (Mumbai to US Central)**:
```
File creation: ~835ms (1x latency)
Listing: ~500ms response time
```

#### Multi-VM Simultaneous Access
Filestore supports concurrent operations across multiple VMs:

```bash
# VM1 operations in US Central
echo "Data from US Central" > /mnt/gc-filestore/us-data.txt
time: 14ms

# VM2 operations in Mumbai
echo "Data from Mumbai" > /mnt/gc-filestore/mumbai-data.txt
time: 1000+ms (1 second)
```

Data written by one VM becomes immediately visible to others, demonstrating true shared storage capabilities.

## Kubernetes File Store Integration

### CSI Driver Enablement
Unlike standalone VMs, Kubernetes requires enabling the Filestore CSI driver:

```yaml
# Enable in GKE cluster configuration
features:
  - filestore-csi-driver
```

**Advantage**: When using Kubernetes, the CSI driver handles all installation and mounting automatically, eliminating manual NFS client installation requirements.

### Deployment Configuration
Deployments use NFS volume configuration:

```yaml
volumes:
- name: nfs-storage
  nfs:
    server: [FILESTORE_IP]
    path: /[SHARE_NAME]
```

This abstraction allows seamless integration without platform-specific knowledge.

## NFS Deployment Demonstrations

### Multi-Pod Read-Write Access

#### Deployment with Multiple Replicas
```yaml
apiVersion: v1
kind: Deployment
metadata:
  name: nfs-app
spec:
  replicas: 4
  template:
    spec:
      volumes:
      - name: nfs-volume
        nfs:
          server: [FILESTORE_IP]
          path: /[SHARE_NAME]

      containers:
      - name: app
        image: nginx
        volumeMounts:
        - name: nfs-volume
          mountPath: /data
```

#### Concurrent Operations Testing
Multiple pods can simultaneously write to the same NFS mount:

```bash
# Pod 1 operations
kubectl exec -ti pod-1 /bin/bash
echo "Data from Pod 1" >> /data/shared.txt

# Pod 2 operations
kubectl exec -ti pod-2 /bin/bash
echo "Data from Pod 2" >> /data/shared.txt
cat /data/shared.txt  # Shows data from both pods
```

**Result**: All pods can read and write simultaneously without conflicts.

### Rolling Deployments
Persistent volumes maintain data across rolling updates:

```bash
kubectl rollout restart deployment/nfs-app
# Data persists across pod recreation
kubectl exec -ti [new-pod] -- cat /data/shared.txt
# Original data remains intact
```

## Persistent Volume and Persistent Volume Claim Concepts

### Overview
Persistent Volume (PV) and Persistent Volume Claim (PVC) implement separation of concerns in Kubernetes storage:

- **Persistent Volume**: Cluster administrator creates storage infrastructure
- **Persistent Volume Claim**: Application developers request storage without knowing underlying details

### Creating PV and PVC

#### Persistent Volume (Admin Task)
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: static-pv
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadOnlyMany
  gcePersistentDisk:
    pdName: my-disk
    fsType: ext4
```

#### Persistent Volume Claim (Developer Task)
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: static-pvc
spec:
  accessModes:
    - ReadOnlyMany
  resources:
    requests:
      storage: 10Gi
```

#### Deployment Using PVC
```yaml
spec:
  template:
    spec:
      volumes:
      - name: persistent-storage
        persistentVolumeClaim:
          claimName: static-pvc
```

### Binding Process
1. Administrator creates PV with specific backend storage
2. Developer creates PVC requesting storage requirements
3. Kubernetes binds PV to PVC with matching criteria
4. Pod mounts the bound volume

**Cloud Agnostic Benefit**: Developers can use the same PVC configuration across different cloud providers.

## Static vs Dynamic Provisioning

### Static Provisioning Process
1. Create the underlying storage resource (disk, bucket, etc.)
2. Create Persistent Volume object referencing the resource
3. Create Persistent Volume Claim
4. Kubernetes binds PVC to PV
5. Use PVC in workload specifications

### Dynamic Provisioning Process
1. Enable storage class with appropriate provisioner
2. Create Persistent Volume Claim (no PV needed)
3. Kubernetes automatically creates PV and backing storage
4. Use PVC in workload specifications

**Storage Classes** define different storage tiers:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-ssd
provisioner: pd.csi.storage.gke.io
parameters:
  type: pd-ssd
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: dynamic-pvc
spec:
  storageClassName: fast-ssd
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

### Demonstration: Dynamic Scaling
Dynamic PVCs support on-demand storage expansion:

```bash
# PVC at 1GB
kubectl patch pvc dynamic-pvc -p '{"spec":{"resources":{"requests":{"storage":"3Gi"}}}}'
kubectl get pv
# PV automatically expands to 3GB when workload is attached
```

## GCSFuse with Cloud Storage

### Overview
GCSFuse (Google Cloud Storage FUSE) adapts Cloud Storage buckets to act as file systems. Unlike Filestore (a true file system), Cloud Storage is blob storage, requiring this translation layer.

### Architecture Comparison
- **Filestore**: Native file system with NFS protocol
- **Cloud Storage with GCSFuse**: Blob storage pretending to be file system

### Installation and Setup

#### Ubuntu Installation
```bash
export GCSFUSE_REPO=gcsfuse-`lsb_release -c -s`
echo "deb https://packages.cloud.google.com/apt $GCSFUSE_REPO main" | sudo tee /etc/apt/sources.list.d/gcsfuse.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get install gcsfuse -y
```

#### Mounting Cloud Storage
```bash
# Create mount directory
mkdir /mnt/gcs-bucket

# Mount bucket
gcsfuse my-bucket-name /mnt/gcs-bucket
```

### Performance Characteristics

#### Cloud Shell (Singapore) → Multi-region Bucket
```
Initial mount time: Several seconds
File listing: ~2 seconds
File operations: ~1-3 seconds
```

#### VM (US Central) → Multi-region Bucket
```
Initial mount time: < 2 seconds
File listing: ~500-800ms
File operations: ~100-500ms
```

### Kubernetes Integration
Enable GCSFuse CSI driver and workload identity:

1. Enable Workload Identity on cluster
2. Enable "Cloud Storage (GCSFuse)" CSI driver
3. Service accounts with Storage Admin permissions for bucket access

## Summary: Key Takeaways and Expert Insights

### Key Takeaways
- **Empty Directory**: Non-persistent, cloud-agnostic temporary storage
- **GCE Persistent Disk**: Deprecated, cannot support multiple writers
- **Filestore**: Managed NFS storage, supports multiple writers, higher cost
- **Cloud Storage with GCSFuse**: Cost-effective blob storage adapter, higher latency
- **PVC/PV**: Separation of concerns for cloud-agnostic storage management
- **Dynamic Provisioning**: On-demand storage allocation via storage classes

```diff
+ PVC/PV provides cloud-agnostic abstraction
+ NFS/Filestore enables multiple simultaneous writers
+ Cloud Storage offers best price-performance ratio
- GCE persistent disks are deprecated and limited
- Cross-region Cloud Storage has significant latency
! Choose storage based on performance requirements vs cost constraints
```

### Expert Insights

#### Real-World Application
**Production Scenarios**:
- Use Filestore for databases requiring simultaneous multi-pod access
- Deploy Cloud Storage with GCSFuse for cost-sensitive AI/ML model storage
- Implement PVC/PV for cloud migration flexibility
- Dynamic provisioning for auto-scaling applications

#### Expert Path
- Master CSI drivers for different storage providers
- Understand StorageClass parameters for performance optimization
- Implement backup strategies for persistent volumes
- Monitor storage performance metrics and cost implications
- Design applications for storage redundancy across zones/regions

#### Common Pitfalls
- **Ignoring Storage Classes**: Not defining appropriate StorageClass parameters leads to suboptimal performance
- **Cross-Region Latency**: Placing storage far from compute increases response time
- **Access Mode Confusion**: Misconfiguring ReadWriteOnce vs ReadOnlyMany causes binding failures
- **Deprecated Options**: Using GCE persistent disk in-tree drivers loses Kubernetes support
- **Cost Estimation**: Underestimating storage pricing based on capacity alone (includes network/operations)

#### Lesser-Known Aspects
- Persistent Volumes retain data when clusters are deleted (independent resources)
- Filestore minimum size (1TB) makes it unsuitable for small-scale deployments
- Cloud Storage buckets support unlimited "directories" through object prefixes
- Workload Identity eliminates service account key management for bucket access
- Storage resize operations occur lazily (when workloads are attached)
