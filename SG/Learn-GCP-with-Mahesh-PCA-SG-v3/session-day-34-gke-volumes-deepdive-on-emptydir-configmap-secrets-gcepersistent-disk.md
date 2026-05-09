# Session 34: GKE Volumes Deepdive on emptyDir, configMap, secrets, GCE Persistent Disk

## Table of Contents
1. [Overview](#overview)
2. [Volume Types Classification](#volume-types)
3. [emptyDir Volume - Scratch Space](#emptydir-concepts)
4. [Pod-Level Volume Mounting](#pod-level-volumes)
5. [ConfigMap and Secrets as Volumes](#configmap-secrets-volumes)
6. [MySQL-PHP Demo with Volume Refresh](#mysql-php-demo)
7. [GCE Persistent Disk - Dedicated Storage](#gce-persistent-disk)
8. [Deployment Deployment Challenges](#deployment-challenges)
9. [Summary](#summary)

## Overview

Kubernetes volumes provide an abstraction layer for storage, addressing the core limitation that pods are ephemeral and lose data when terminated. Volumes are **mounted at the pod level** (not container level), making them accessible to all containers within a pod but local to that specific pod instance.

### Why Volumes Exist:
- **Pod Ephemerality Problem**: Data stored inside containers is lost when pods crash or restart
- **Container Isolation**: Each container has its own isolated filesystem
- **Data Sharing Need**: Containers within the same pod need to communicate through shared storage

> [!NOTE]
> Volumes solve the fundamental issue: `Pod Restart → Data Loss Problem`

## Volume Types

### Ephemeral vs Persistent Classification

```diff
! Ephemeral Volumes:
- Data lost when pod terminates
- Short-lived storage needs
- Examples: emptyDir, configMap volumes, secret volumes

! Persistent Volumes:
- Data survives pod termination
- Long-term data retention
- Examples: GCE Persistent Disk, NFS, cloud storage
```

### Storage Backing Categories

```sql
Ephemeral Types           | Backing               | Lifetime
--------------------------|----------------------|-----------
emptyDir                  | Node disk space       | Pod lifetime
configMap/secret volumes  | Kubelet cache         | 60s refresh cycle
```

```sql
Persistent Types          | Backing               | Lifetime
--------------------------|----------------------|-----------
GCE Persistent Disk       | Dedicated PD          | Independent of pods
NFS                       | Network file system   | Independent
```

## emptyDir Volume - Scratch Space

The emptyDir volume is the simplest volume type, providing **empty scratch space** during a pod's runtime. It's ideal for temporary data that doesn't need to persist beyond the pod's lifecycle.

### Key Characteristics:
- ✅ **Empty on pod startup**: Clean slate every time
- ✅ **Node-backed storage**: Uses one of the node's disk resources
- ✅ **Pod-level access**: All containers in pod can access
- ❌ **Ephemeral**: Data lost when pod terminates

### Use Cases:
- Temporary file processing
- Cache directories for applications
- Log aggregation points within pods
- Shared workspace between containers

## Lab Demo: emptyDir with Multi-Container Pod

### Configuration:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: emptydir-demo
spec:
  containers:
  - name: python
    image: python:3.8
    volumeMounts:
    - mountPath: /python
      name: scratch-pad
    command: ["sleep", "3600"]
  - name: nginx
    image: nginx:alpine
    volumeMounts:
    - mountPath: /shared
      name: scratch-pad
    resources:
      limits:
        memory: "128Mi"
        cpu: "100m"
  volumes:
  - name: scratch-pad
    emptyDir: {}  # Empty declaration - uses defaults
```

### Execution Steps:

1. **Create pod:**
   ```bash
   kubectl apply -f emptydir-demo.yaml
   kubectl get pods -o wide  # Note node placement
   ```

2. **Verify volume accessibility:**
   ```bash
   # Enter python container
   kubectl exec -it emptydir-demo -c python -- /bin/bash
   df -H  # Shows /python mount
   echo "From Python" > /python/test.txt

   # Enter nginx container (same pod)
   kubectl exec -it emptydir-demo -c nginx -- /bin/bash
   df -H  # Shows /shared mount
   cat /shared/test.txt  # Should show "From Python"
   ```

3. **Prove pod-level isolation:**
   ```bash
   # Create another pod instance
   kubectl scale pod emptydir-demo --replicas=2
   # Second pod has separate emptyDir volume
   ```

### Deployment Conversion for Self-Healing:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: emptydir-deployment
spec:
  replicas: 2  # Multiple pod instances
  selector:
    matchLabels:
      app: scratch-app
  template:
    metadata:
      labels:
        app: scratch-app
    spec:
      containers:
      - name: writer
        image: busybox
        command: ["sh", "-c", "echo 'data' > /temp/data.txt && sleep 3600"]
        volumeMounts:
        - mountPath: /temp
          name: shared-data
      - name: reader
        image: busybox
        command: ["sh", "-c", "sleep 3600"]
        volumeMounts:
        - mountPath: /input
          name: shared-data
      volumes:
      - name: shared-data
        emptyDir: {}
```

## Pod-Level Volume Mounting

### Key Insight from Demo:

```diff
+ Volume mounted ONCE at pod level
+ NOT mounted per container
+ ALL containers access same underlying storage
```

### Multi-Container Data Sharing Pattern:

```
Pod Specification
├── Container 1 (Python)
│   └── VolumeMount: /app-data
├── Container 2 (Nginx) 
│   └── VolumeMount: /web-data
└── Volume: shared-storage (emptyDir)
    └── Mounts to BOTH containers
```

## ConfigMap and Secrets as Volumes

ConfigMaps and Secrets mounted as volumes provide **automatic configuration refresh** without pod restarts, unlike environment variables.

### Critical Difference from Environment Variables:

```diff
! Environment Variables:
- Baked into container at startup
- Require pod restart for updates
- Cannot be updated dynamically

! Volume-based Config/Secrets:
+ Mounted as files in filesystem
+ Kubelet refreshes every 60 seconds
+ Application reads latest values dynamically
```

### Volume Declaration Syntax:

```yaml
volumes:
- name: config-volume
  configMap:
    name: app-configmap
- name: secret-volume
  secret:
    secretName: app-secret
```

### Mount with Read-Only Enforcement:
```yaml
volumeMounts:
- name: config-volume
  mountPath: /etc/config
  readOnly: true  # Always true for configMap/secret volumes
```

## Lab Demo: MySQL-PHP Application with Dynamic Configuration

### Problem Statement:
Original environment variable approach required pod deletions for password changes. Volume approach enables automatic updates.

### Step 1: Create Configuration Objects

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: php-config
data:
  database: "gkconcepts"
  dbuser: "gkuser"

---
apiVersion: v1
kind: Secret
metadata:
  name: php-secret
type: Opaque
data:
  dbpassword: Z2tjb25uZWN0MjAyNA==  # base64 encoded
```

### Step 2: Application with Volume Mounts

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-mysql-app
spec:
  replicas: 1
  template:
    spec:
      containers:
      - name: php-app
        image: php:7.4-apache
        ports:
        - containerPort: 80
        volumeMounts:
        - name: db-config
          mountPath: /etc/db-config
          readOnly: true
        - name: db-secret
          mountPath: /etc/db-secret
          readOnly: true
        env:
        - name: DB_HOST
          value: "mysql-service.default.svc.cluster.local"
      volumes:
      - name: db-config
        configMap:
          name: php-config
      - name: db-secret
        secret:
          secretName: php-secret
```

### Step 3: Code Modification for Volume Reading

```php
<?php
// Read from volumes instead of environment variables
$config_file = '/etc/db-config/database';
$secret_file = '/etc/db-secret/dbpassword';

// Read configuration files
$db_name = file_get_contents($config_file);
$db_user = file_get_contents('/etc/db-config/dbuser');
$db_pass = file_get_contents($secret_file);

// Database connection using dynamic config
try {
    $pdo = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);
    // Application logic...
} catch (Exception $e) {
    echo "Connection failed - check credentials";
}
?>
```

### Step 4: Test Dynamic Updates

```bash
# Change MySQL password
kubectl patch secret php-secret \
  --type='json' \
  -p='[{"op": "replace", "path": "/data/dbpassword", "value": "'$(echo -n "newpassword" | base64)'"}]'

# Wait 60 seconds maximum for kubelet refresh
# Application automatically picks up new password
# No pod restart required!
```

### Zero-Downtime Password Updates

Using **MySQL secondary password feature**:

```sql
-- MySQL supports multiple passwords
SET PASSWORD = 'newpassword';
-- Old password still works temporarily
```

```yaml
# Apply both passwords temporarily
kubectl patch secret php-secret \
  --type='json' \
  -p='[{"op": "replace", "path": "/data/dbpassword", "value": "'$(echo -n "old,new" | base64)'"}]'
```

## GCE Persistent Disk - Dedicated Storage

GCE Persistent Disk provides **truly persistent storage** that survives pod and node failures.

### Key Advantages:
- ✅ **Independent of pods**: Data survives pod deletion
- ✅ **Independent of nodes**: Data survives node failure
- ❌ **Cloud-specific**: GCP-only implementation
- ❌ **Synchronous access**: Only one pod at a time for write access

### Cloud Engineer Abstraction Benefits:
- ❌ Manual disk creation: `gcloud compute disks create my-disk --size=10GB --zone=us-central1-a`
- ✅ **Kubernetes handles formatting**: New disks auto-formatted, existing disks auto-mounted
- ✅ **Zone management**: Handles multi-zone replication for regional disks

### Regional vs Zonal Disks:

```diff
! Zonal Persistent Disks:
- Single zone only
- Low replication overhead
- Faster I/O

! Regional Persistent Disks:
+ Replicated to exactly 2 zones
+ Survives single zone failures
+ Higher availability
```

## Pod with GCE Persistent Disk Demo

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: data-pod
spec:
  containers:
  - name: app
    image: busybox
    command: ["sleep", "3600"]
    volumeMounts:
    - mountPath: /persistent-data
      name: data_volume
  volumes:
  - name: data_volume
    gcePersistentDisk:
      pdName: my-data-disk  # Must exist in cluster region
      fsType: ext4
      readOnly: false
```

### Demo: Persistence Testing

1. **Create data:**
   ```bash
   kubectl exec -it data-pod -- touch /persistent-data/test.txt
   echo "Persistent data survives" > /persistent-data/test.txt
   ```

2. **Delete pod:**
   ```bash
   kubectl delete pod data-pod
   ```

3. **Recreate pod:**
   ```bash
   kubectl apply -f data-pod.yaml
   kubectl exec -it data-pod -- cat /persistent-data/test.txt
   # Data still exists!
   ```

## Deployment Deployment Challenges

**Critical Limitation**: GCE Persistent Disk cannot be safely used with multi-replica deployments across multiple nodes due to disk attach conflicts.

### The Deadlock Problem:

```
Rolling Update Scenario:
┌─────────────────────┐    ┌─────────────────────┐
│ Node 1 (running)    │    │ Node 2 (new pod)   │
├─────────────────────┤    ├─────────────────────┤
│ Pod A + Disk D      │    │ Pod B (waiting)     │
│                     │    │                     │
│ Rolling update:     │    │ [Disk Attach]       │
│ "Kill Pod A first"  │    │ ❌ DEADLOCK         │
└─────────────────────┘    └─────────────────────┘
```

#### Linear Notation for Disk Conflict:
```diff
! Rolling Update + Multi-Node + Single Disk → Disk Attach Deadlock

! Solution: Recreate Strategy OR Single Replica
```

### Solution 1: Recreate Deployment Strategy

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: stateful-single
spec:
  strategy:
    type: Recreate  # Stop ALL pods, then start new ones
  replicas: 1
  template:
    spec:
      containers:
      - name: app
        image: busybox
        volumeMounts:
        - mountPath: /data
          name: persistent-volume
      volumes:
      - name: persistent-volume
        gcePersistentDisk:
          pdName: shared-disk
          fsType: ext4
```

### Solution 2: Single Replica per Disk

```yaml
spec:
  replicas: 1  # Most reliable for direct GCE disk mounting
  # Scale horizontally with multiple disks or use PVC approach
```

### Recommended Production Approach

> [!WARNING]
> **Use PersistentVolume Claims instead for production:**

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: storage-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cloud-agnostic-app
spec:
  replicas: 3  # Safe with PVC - different disks auto-provisioned
  template:
    spec:
      containers:
      - name: app
        volumeMounts:
        - mountPath: /data
          name: storage-volume
      volumes:
      - name: storage-volume
        persistentVolumeClaim:
          claimName: storage-claim
```

## Summary

### Key Takeaways

```diff
+ Volume abstraction solves pod ephemerality (data loss on restart)
+ Volumes mount at POD level - accessible by all containers in pod
+ emptyDir provides ephemeral scratch space during pod lifetime
+ configMap/secret volumes auto-refresh every 60 seconds (vs env vars requiring restarts)
+ GCE Persistent Disk: survives pod/node crashes but has multi-replica limitations
+ Use PersistentVolume claims for cloud-agnostic, production deployments
+ Deployment strategy matters: Recreate avoids disk attach deadlocks
```

### Quick Reference

**Commands:**
- `kubectl exec -it <pod> -c <container>` - Access specific container
- `kubectl rollout restart deployment/<name>` - Force redeployment
- `kubectl get pods -o wide` - Verify node scheduling
- `mount | grep <path>` - Check mount types (read-only vs read-write)
- `df -H` - Display filesystem usage

**Volume Declaration Patterns:**
```yaml
# emptyDir - temporary pod storage
volumes:
- name: temp-space
  emptyDir: {}

# ConfigMap as volume - auto-refreshing configuration  
volumes:
- name: config-vol
  configMap:
    name: my-config

# Secret as volume - secure auto-refreshing credentials
volumes:
- name: secret-vol
  secret:
    secretName: my-secret

# GCE persistent disk - dedicated storage (production use PVC instead)
volumes:
- name: persistent-vol
  gcePersistentDisk:
    pdName: pre-created-disk
    fsType: ext4
    readOnly: false
```

### Expert Insight

#### Real-world Application
- **Microservice configurations**: Mount ConfigMaps/Secrets as volumes for zero-downtime config updates
- **Shared logging**: emptyDir volumes for collecting logs from multiple containers
- **Database migration**: GCE disks for one-off persistent storage during lift-and-shift
- **Production databases**: Always use PersistentVolume with storage classes and claims

#### Expert Path
- Dive into **Volume SubPaths** for container-specific volume access
- Learn **Projected Volumes** for combining multiple volume types
- Study **Volume Topology** for cross-zone persistent workloads
- Explore **Volume Snapshots** for backup and disaster recovery

#### Common Pitfalls
- ❌ Using GCE persistent disk with multi-replica deployments
- ❌ Expecting environment variable deployments to auto-refresh
- ❌ Forgetting `readOnly: true` when mounting configMap/secret volumes
- ❌ Assuming volumes persist across namespace deletions

#### Lesser-Known Facts
- **Memory-backed emptyDir**: `emptyDir: { medium: "Memory" }` uses RAM for ultra-fast temporary storage
- **Projected downwardAPI**: Mount pod metadata (labels, annotations) as files
- **Volume ownership permissions** can be set using securityContext
- **ConfigMap/Secret refresh actually happens every ~1 minute** but officially documented as 60 seconds

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
