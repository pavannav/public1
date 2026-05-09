# Session 36: Cloud Storage Fuse CSI Driver Mounted in Pod, Concept of StatefulSet and Basic Demo on STS

## Table of Contents
- [Overview](#overview)
- [Cloud Storage Fuse CSI Driver in Kubernetes](#cloud-storage-fuse-csi-driver-in-kubernetes)
- [StatefulSet Concepts](#statefulset-concepts)
- [StatefulSet vs Deployment Comparison](#statefulset-vs-deployment-comparison)
- [Headless Services](#headless-services)
- [Basic StatefulSet Demo](#basic-statefulset-demo)
- [Persistence Volume Claim Templates](#persistence-volume-claim-templates)
- [Ordered Pod Creation](#ordered-pod-creation)
- [Stable Network Identity](#stable-network-identity)
- [StatefulSet Advantages and Use Cases](#statefulset-advantages-and-use-cases)
- [Summary](#summary)

## Overview

This session explores advanced Kubernetes storage and controller concepts, focusing on integrating Google Cloud Storage with Kubernetes pods using CSI drivers and understanding StatefulSets for stateful applications. We learn how to overcome limitations of deployment objects for persistent, stateful workloads like databases and messaging systems.

## Cloud Storage Fuse CSI Driver in Kubernetes

### What is GCS Fuse?
GCS Fuse allows mounting Google Cloud Storage buckets as local filesystems, enabling read/write access from within pods. Unlike persistent disks that limit single-part read/write access, GCS Fuse enables multiple pods to access the same bucket simultaneously.

### Key Benefits
- **Cost-effective alternative** to persistent disks for shared storage needs
- **Read/write access** from multiple pods without blocking
- **Seamless integration** with existing GCS buckets

### Prerequisites for CSI Driver Usage
- **Workload Identity enabled** on the cluster
- **CSI driver installation** through GCP console features
- **Service account permissions** with storage roles (storage.object.admin, storage.object.user)

### Demo: Mounting GCS Bucket in Pod
We demonstrated mounting a GCS bucket using the CSI driver with a sidecar container approach.

**Key YAML Components:**
- **Volume specification** using CSI driver type with bucket name
- **Volume mount** specifying read/write mode and mount path `/data`
- **Annotation** for sidecar container injection: `gke-gcsfuse/volumes: true`
- **Service account** configuration in volume attributes

**Commands for verification:**
```bash
# Check mounted filesystems
df -h

# Write data to bucket
echo "sample data" > /data/sample.txt

# Verify in GCS console - data appears immediately
```

### Limitations
- **Latency issues** vs local persistent disks
- **Performance considerations** for high-throughput workloads
- May require mount options tuning (`fileCacheEnable`, `implicitDirs`)

## StatefulSet Concepts

### StatefulSet vs Deployment
StatefulSets address fundamental limitations of Deployments for stateful applications.

**Deployment Object Limitations:**
- **Single pod read/write** persistent disk access
- **Dynamic pod names** and IPs
- **Shared storage conflicts** across pods
- **No stable identity** for stateful applications

**StatefulSet Solutions:**
- **Ordered pod creation/termination**
- **Stable, persistent pod names** using ordinal indices
- **Dedicated storage per pod**
- **Predictable network identities**

### Core StatefulSet Properties

1. **Stable Pod Identity**
   - Pod naming: `{statefulset-name}-{ordinal-index}`
   - Hostname equals pod name
   - Consistent across pod restarts

2. **Ordered Pod Management**
   - Pods created/deleted in sequential order
   - Pod N waits for Pod N-1 to be ready
   - Parallel mode available if needed

3. **Stable Storage**
   - Each pod gets dedicated PersistentVolumeClaim
   - Storage persists across pod lifecycle
   - Access modes: ReadWriteOnce (default)

## StatefulSet vs Deployment Comparison

| Feature | Deployment | StatefulSet |
|---------|------------|-------------|
| Pod Identity | Dynamic/random | Stable/ordinal |
| Storage | Shared/bottlenecked | Dedicated per pod |
| Access Mode | Read-only or single R/W | ReadWriteOnce per pod |
| Ordering | Parallel | Sequential |
| Use Cases | Stateless applications | Databases, message queues |

## Headless Services

### What is a Headless Service?
Headless services are Kubernetes services without cluster IPs, enabling direct pod-to-pod communication.

### Headless vs Normal Services
```yaml
# Normal Service (Load Balancer)
spec:
  type: ClusterIP  # or LoadBalancer

# Headless Service
spec:
  clusterIP: None
```

### Benefits for StatefulSets
- **Direct pod access** via DNS resolution
- **DNS returns pod IPs** instead of service IP
- **Stable network identity** for communication
- **Database clustering** requirement

### DNS Resolution Example
```bash
# Normal service resolves to service IP
nslookup myapp

# Headless service returns all pod IPs
nslookup web-sts-0.web-svc.default.svc.cluster.local
```

## Basic StatefulSet Demo

### YAML Structure Components

1. **Headless Service**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: web
spec:
  clusterIP: None  # Makes it headless
  selector:
    app: web
  ports:
  - port: 80
```

2. **StatefulSet**
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: web  # References headless service
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    spec:
      containers:
      - name: nginx
        image: k8s.gcr.io/nginx-slim:0.8
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:  # Creates PVC for each pod
  - metadata:
    name: www
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
```

### Ordered Pod Creation Demonstration

```bash
# Watch pod creation sequence
kubectl get pods --watch

# Output shows sequential creation:
web-0   0/1   Pending
web-0   1/1   Running
web-1   0/1   Pending  
web-1   1/1   Running
web-2   0/1   Pending
web-2   1/1   Running
```

### Persistence Verification

1. **Write data to first pod**
```bash
kubectl exec -it web-0 -- bash
echo "Data from pod-0" > /usr/share/nginx/html/index.html
```

2. **Access via load balancer**
```bash
curl web  # Returns data from any pod via round-robin
```

3. **Delete and recreate pod**
```bash
kubectl delete pod web-0
kubectl get pods  # web-0 recreates with same name
curl web-sts-0.web  # Direct access to specific pod
```

## Persistence Volume Claim Templates

### How PVC Templates Work
- **Dynamically creates PVC** for each pod replica
- **Naming convention**: `{volumeClaimTemplate.name}-{pod.name}`
- **One-to-one mapping**: Pod "web-0" ↔ PVC "www-web-0"

### PVC Template Example
```yaml
volumeClaimTemplates:
- metadata:
  name: www
  spec:
    accessModes:
    - ReadWriteOnce
    resources:
      requests:
        storage: 1Gi
```

### Steady State Verification
```bash
kubectl get pv  # Shows 3 dedicated disks
kubectl get pvc  # Shows 3 claims, one per pod
# Names: www-web-0, www-web-1, www-web-2
```

## Ordered Pod Creation

### Default Behavior: Sequential
Pods created with guaranteed ordering: 0 → 1 → 2
Pod N+1 waits for Pod N ready status

### Parallel Creation Option
```yaml
apiVersion: apps/v1
kind: StatefulSet
spec:
  podManagementPolicy: Parallel  # Default: OrderedReady
```

### Use Cases
- **OrderedReady** (default): Databases requiring master-slave setup
- **Parallel**: Independent pods not requiring specific startup order

## Stable Network Identity

### Pod DNS Records
```bash
# Individual pod DNS
web-0.web.default.svc.cluster.local

# Headless service DNS records
nslookup web.default.svc.cluster.local
# Returns IPs of all 3 pods
```

### Communication Patterns

1. **Load-balanced access** via normal service
2. **Direct pod access** via headless service DNS
3. **Stable endpoints** for application configuration

### Demonstration: Database Synchronization
```bash
# Pod-to-pod communication
kubectl exec -it web-0 -- nslookup web-1.web

# Returns web-1's IP address consistently
# Enables database replication configuration
```

## StatefulSet Advantages and Use Cases

### Advantages
- **Stable storage**: Dedicated persistence per pod
- **Predictable naming**: Consistent DNS and hostnames
- **Scalable stateful apps**: No storage conflicts
- **Simplified configuration**: Known pod identities

### Real-World Applications

1. **Database Clusters**
   ```diff
   + MySQL/MariaDB replication
   + PostgreSQL streaming replication
   + MongoDB replica sets
   ```

2. **Messaging Systems**
   ```diff
   + Kafka brokers with dedicated storage
   + RabbitMQ clustering
   + Elasticsearch nodes
   ```

3. **AI/ML Workloads**
   ```diff
   + Model training checkpoints
   + Inference servers with GCS integration
   + Shared datasets for distributed training
   ```

### Common Patterns

```yaml
# For database clustering
statefulSet:
  replicas: 3
  serviceName: mysql-headless
  volumeClaimTemplates:
  - storage: 100Gi  # Per-node persistent storage
```

## Summary

### Key Takeaways
- **Cloud Storage Fuse CSI Driver** enables shared GCS bucket mounting across pods with full read/write capabilities
- **StatefulSets provide stable identity** through ordinal naming and dedicated storage, solving Deployment limitations
- **Headless services** facilitate direct pod communication, crucial for cluster formation
- **PVC templates** create dedicated storage automatically for each replica
- **Ordered pod management** ensures predictable startup sequences for dependent workloads
- **Use StatefulSets** for databases, message queues, and any application requiring persistent state

### Quick Reference

**CLI Commands:**
```bash
# Check mounted filesystems
df -h

# Watch StatefulSet creation
kubectl get pods --watch

# Access specific pod via headless service
kubectl exec -it web-0 -- bash

# DNS lookup for pod IPs
nslookup web-0.web-service

# Check persistent volumes
kubectl get pv,pvc
```

**Key YAML Annotations:**
```yaml
# GCS Fuse CSI driver
metadata:
  annotations:
    gke-gcsfuse/volumes: "true"
    gke-gcsfuse/memory-limit: "128Mi"  # Optional

# StatefulSet PVC retention
spec:
  persistentVolumeClaimRetentionPolicy:
    whenDeleted: Delete
    whenScaled: Retain  # or Delete
```

### Expert Insight

#### Real-world Application
StatefulSets with GCS Fuse CSI drivers excel in **machine learning inference pipelines** where:
- Models stored in GCS buckets can be accessed by multiple inference pods simultaneously
- Persistent local storage via StatefulSets holds model artifacts for fast loading
- Headless services enable direct pod communication for distributed processing

#### Expert Path
Master StatefulSet management through:
1. **PVC retention policies** for proper cleanup
2. **Pod management policies** (OrderedReady vs Parallel)
3. **CSI driver integrations** beyond GCS (AWS EFS, Azure Disk)
4. **Storage class optimizations** for performance and cost

#### Common Pitfalls
```diff
- Not using headless services for pod discovery
- Ignoring ordered pod creation implications
- Misconfiguring PVC templates leading to storage conflicts
- Forgetting workload identity setup for CSI drivers
- Not planning for disk attachment limits per VM
```

#### Lesser-Known Facts
- **GCS Fuse performance** can be optimized using `fileCacheCapacity` settings
- **Pod names serve double-duty** as hostnames, enabling direct DNS resolution
- **StatefulSets don't use ReplicaSets** internally - pods created directly
- **PVC templates can be deleted independently** from StatefulSet termination

### Advantages
✅ **True multi-pod read/write** access to persistent storage  
✅ **Stable networking** simplifies application configuration  
✅ **Ordered lifecycle management** for dependency handling  
✅ **Storage isolation** prevents data corruption risks  

### Disadvantages
❌ **Sequential scaling** can slow cluster expansion  
❌ **Complex deletion policies** require careful PVC management  
❌ **Storage costs** scale linearly with replica count  
❌ **Node attachment limits** constrain maximum pod count
