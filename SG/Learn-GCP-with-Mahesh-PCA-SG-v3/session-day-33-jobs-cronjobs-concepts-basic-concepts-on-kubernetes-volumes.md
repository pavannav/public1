# Session 33: Jobs, CronJobs Concepts. Basic concepts on Kubernetes Volumes

## Table of Contents
- [Review of Workload Identity Federation](#review-of-workload-identity-federation)
- [Jobs Concepts](#jobs-concepts)
- [CronJobs Concepts](#cronjobs-concepts)
- [Introduction to Kubernetes Volumes](#introduction-to-kubernetes-volumes)

## Review of Workload Identity Federation

### Overview
Session continues from previous Workload Identity Federation discussion, emphasizing its application in Kubernetes workloads interacting with Google Cloud services, particularly Cloud Storage.

### Key Concepts

#### Cluster Configuration Review
- Using standard GKE cluster with workload identity enabled
- Enabled via `gcloud container clusters update` command with workload pool
- Project number and service identity pool format verification

**Command Reference:**
```bash
# Enable workload identity on existing cluster
gcloud container clusters update CLUSTER_NAME \
  --workload-pool=PROJECT_ID.svc.id.goog \
  --enable-workload-identity

# Check node labels for workload identity
kubectl get nodes --show-labels
# Should show: iam.gke.io/gke-metadata-server-enabled=true
```

#### Namespaced Resources Setup
- Created dedicated namespace for scheduled workloads
- Kubernetes service account created with IAM policy binding
- Resource-level permission granted to specific GCS bucket

**Namespace and Service Account:**
```bash
kubectl create namespace scheduled-jobs
kubectl create serviceaccount data-generator-sa -n scheduled-jobs
```

**IAM Policy Binding:**
```bash
gcloud storage buckets add-iam-policy-binding gs://BUCKET_NAME \
  --member="principal://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/PROJECT_ID.svc.id.goog/subject/ns/scheduled-jobs/sa/data-generator-sa" \
  --role="roles/storage.objectAdmin"
```

### Lab Demo: Workload Identity Testing with Data Generator

**Pod Deployment:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: data-generator
  namespace: scheduled-jobs
spec:
  serviceAccountName: data-generator-sa
  containers:
  - name: data-generator
    image: google/cloud-sdk:slim
    command: ["sleep", "infinity"]
```

**Testing Steps:**
1. Deploy pod
   ```bash
   kubectl apply -f data-generator-pod.yaml
   kubectl get pods -n scheduled-jobs
   ```

2. Access pod and verify identity
   ```bash
   kubectl exec -it data-generator-pod-name -n scheduled-jobs -- bash
   gcloud auth list  # Should show workload identity
   gcloud storage buckets list  # Should show accessible buckets
   ```

3. Test bucket-restricted access
   ```bash
   gsutil ls  # Lists objects in accessible bucket
   gsutil ls gs://other-bucket/  # Should fail with access denied
   ```

4. Generate and upload sample data
   ```bash
   echo "Sample data for testing" > test.txt
   gsutil cp test.txt gs://your-bucket/test.txt
   gsutil ls gs://your-bucket/  # Verify upload
   ```

## Jobs Concepts

### Overview
Jobs are Kubernetes controller objects designed for **ephemeral, one-time tasks** that run to completion and release resources. Unlike deployments, jobs terminate pods after successful execution.

### Key Concepts

#### Jobs vs Deployments Comparison

**When to Use Jobs:**
- One-time data processing, database migrations, container initialization
- Tasks that shouldn't run continuously but need completion tracking

**Key Differences:**
| Aspect | Jobs | Deployments |
|--------|------|-------------|
| Lifecycle | Ephemeral (completes and exits) | Persistent (runs continuously) |
| Resource Usage | Releases resources after completion | Holds resources indefinitely |
| Restart Policy | `Never` (by default) | `Always` |
| Scaling | Single pod or controlled parallelism | Replicas for scaling |

> [!IMPORTANT]
> Jobs release CPU/memory resources after completion, providing better resource utilization for batch workloads.

#### Job Specification and Configuration

**Basic Job Manifest:**
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: pi-calculation
spec:
  template:
    spec:
      restartPolicy: Never  # Critical for jobs
      containers:
      - name: pi
        image: perl:5.34
        command: ["perl", "-Mbignum=bpi", "-wle", "print bpi(2000)"]
```

**Retry and Backoff Configuration:**
```yaml
spec:
  backoffLimit: 4                    # Max retry attempts
  activeDeadlineSeconds: 300         # Job timeout
  ttlSecondsAfterFinished: 86400     # Auto-cleanup delay
  parallelism: 1                     # Concurrent pods
  completions: 1                     # Successful completions needed
```

#### Self-Healing and Retry Behavior

**Job Lifecycle States:**
- Job creates pods to execute the task
- If pod fails, job creates new pod (up to `backoffLimit`)
- Successful completion marks job as `Complete`
- Failed retries mark job as `Failed`

**Error Handling:**
```bash
kubectl describe job job-name  # Shows detailed failure reasons
kubectl logs job/job-name      # Shows pod execution logs
```

### Lab Demo: Creating and Managing Jobs

**Step 1: Deploy Pi Calculation Job**
```bash
# Create job
kubectl apply -f pi-job.yaml

# Monitor job status
kubectl get jobs
# Output example:
# NAME            COMPLETIONS   DURATION   AGE
# pi-calculation  1/1           30s        45s
```

**Step 2: View Job Execution Results**
```bash
# List pods created by job
kubectl get pods --selector=job-name=pi-calculation

# View execution logs
kubectl logs job/pi-calculation
# Should display pi calculation output: 3.14159...
```

**Step 3: Demonstrate Resource Release**
```bash
kubectl get pods  # Shows 0 pods running after completion
kubectl get jobs  # Shows completion status
# Output example:
# Pods Statuses: 0/1  (resources released)
```

**Step 4: Job with Retry Demonstration**
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: retry-demo
spec:
  backoffLimit: 2
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: demo
        image: busybox
        command: ["sleep", "300"]  # 5-minute task
```

**Force Failure and Observe Retries:**
```bash
kubectl apply -f retry-demo.yaml
kubectl delete pod $(kubectl get pods --selector=job-name=retry-demo -o jsonpath='{.items[0].metadata.name}')
# Kubernetes automatically recreates pod
kubectl get jobs  # Shows retry attempts
```

## CronJobs Concepts

### Overview
CronJobs automate **scheduled, repetitive tasks** using cron expressions. They create Job objects at specified intervals, perfect for periodic data processing, backups, and maintenance tasks.

### Key Concepts

#### CronJob Basics and Scheduling

**Core Components:**
- **Schedule**: Cron expression defining execution frequency  
- **Job Template**: Job specification to execute on schedule
- **History**: Tracks execution results and cleanup

**Basic CronJob Manifest:**
```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: scheduled-backup
spec:
  schedule: "*/5 * * * *"  # Every 5 minutes
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: google/cloud-sdk:slim
            command: ["gsutil", "cp", "data/*", "gs://backup-bucket/"]
          restartPolicy: OnFailure
```

#### Cron Expressions Deep Dive

**Cron Format:**
```
* * * * *  command
│ │ │ │ └─ Day of Week (0-7, Sunday=0)
│ │ │ └── Month (1-12)
│ │ └──── Day of Month (1-31)
│ └────── Hour (0-23)
└──────── Minute (0-59)
```

**Common Schedules:**
```yaml
schedule: "0 * * * *"       # Hourly at :00
schedule: "0 2 * * *"       # Daily at 2:00 AM
schedule: "*/15 * * * *"    # Every 15 minutes  
schedule: "0 9 * * 1-5"     # Weekdays at 9:00 AM
schedule: "@hourly"         # Built-in shorthand
```

**Advanced Scheduling:**
```yaml
spec:
  schedule: "0 2 * * *"
  timeZone: "America/New_York"
  startingDeadlineSeconds: 300    # Max delay for missed schedules
  suspend: false                  # Enable/disable scheduling
```

#### Job Template Configuration

**Per-Job Settings:**
```yaml
jobTemplate:
  spec:
    activeDeadlineSeconds: 3600   # Job execution timeout
    backoffLimit: 3               # Retr(y) attempts
    ttlSecondsAfterFinished: 600  # Cleanup delay after completion
```

### Lab Demo: Creating and Managing CronJobs

**Step 1: Create CronJob for Data Generation**
```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: data-generator-cron
  namespace: scheduled-jobs
spec:
  schedule: "*/1 * * * *"              # Every minute
  jobTemplate:
    spec:
      template:
        spec:
          serviceAccountName: data-generator-sa
          containers:
          - name: generator
            image: google/cloud-sdk:slim
            command: ["/bin/bash", "-c"]
            args: ["echo 'Generated data $(date)' | gsutil cp - gs://your-bucket/data-$(date +%s).txt"]
          restartPolicy: OnFailure
```

**Step 2: Deploy and Monitor CronJob**
```bash
kubectl apply -f data-generator-cron.yaml
kubectl get cronjobs -n scheduled-jobs
# Output example:
# NAME                 SCHEDULE      SUSPEND   ACTIVE   LAST SCHEDULE   AGE
# data-generator-cron  */1 * * * *   False     0        30s             45s
```

**Step 3: Observe Scheduled Execution**
```bash
# Check every minute for new jobs
kubectl get jobs -n scheduled-jobs --sort-by=.metadata.creationTimestamp
# Should see new job created each minute

# View execution logs
kubectl logs $(kubectl get pods -n scheduled-jobs --selector=job-name=data-generator-cron-XXXXX -o jsonpath='{.items[0].metadata.name}') -n scheduled-jobs

# Check GCS bucket for uploaded files
gsutil ls gs://your-bucket/
# Should show new files each minute
```

**Step 4: CronJob Management**
```bash
# Suspend scheduling temporarily
kubectl patch cronjob data-generator-cron -n scheduled-jobs -p '{"spec":{"suspend":true}}'

# Resume scheduling
kubectl patch cronjob data-generator-cron -n scheduled-jobs -p '{"spec":{"suspend":false}}'

# View job history
kubectl get jobs -n scheduled-jobs
kubectl describe cronjob data-generator-cron -n scheduled-jobs
```

**Step 5: Cleanup Old Jobs**
```bash
# Manual cleanup (or use ttlSecondsAfterFinished)
kubectl delete jobs --field-selector status.successful=1 -n scheduled-jobs
```

## Introduction to Kubernetes Volumes

### Overview
Kubernetes volumes provide **storage abstraction** for pods and containers. They decouple storage from container restarts, enabling data persistence and controlled access across workloads.

### Key Concepts

#### Volume Types Overview

**Ephemeral vs Persistent:**
- **Ephemeral**: Data lost when pod terminates, fast but temporary
- **Persistent**: Data survives pod lifecycle, essential for stateful applications

> [!NOTE]
> Volumes are **pod-level resources**, not container-level. All containers in a pod can access the same volumes.

#### Six Volume Types Covered

**Three Ephemeral Volume Types:**

1. **emptyDir**: Temporary scratch space using node disk
   ```yaml
   volumes:
   - name: temp-space
     emptyDir: {}
   ```

2. **configMap**: Mount configuration data as files
   ```yaml
   volumes:
   - name: config-vol
     configMap:
       name: app-config
   ```

3. **secret**: Mount sensitive data (credentials, keys)
   ```yaml
   volumes:
   - name: secret-vol
     secret:
       secretName: app-secrets
   ```

**Three Persistent Volume Types:**

1. **GCE Persistent Disk**: Google Cloud-specific persistent storage
   ```yaml
   volumes:
   - name: persistent-disk
     gcePersistentDisk:
       pdName: my-disk
       fsType: ext4
   ```

2. **NFS**: Network File System for shared storage
   ```yaml
   volumes:
   - name: nfs-vol
     nfs:
       server: nfs-server.example.com
       path: /exports
   ```

3. **PersistentVolumeClaim**: Cloud-agnostic abstraction (covered conceptually)

#### Storage Architecture Principles

**Pod-Level Volume Design:**
- Volumes defined in `spec.volumes` (pod level)
- Containers reference via `spec.containers[].volumeMounts`
- Single volume accessible by multiple containers

**Basic Volume Mounting:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: data-pod
spec:
  containers:
  - name: app
    image: ubuntu
    volumeMounts:
    - name: data-vol
      mountPath: /data
  volumes:
  - name: data-vol
    emptyDir: {}  # Volume specification
```

#### Detailed Volume Explanations

**emptyDir Volume Details:**
- Uses node's disk space (node ephemeral storage)
- Shared pod lifecycle - data lost on pod deletion
- Useful for temporary work, scratch space, cache

**configMap Volume Details:**
- Mounts key-value pairs as files in directory
- Automatic reload every 60 seconds (no restart needed)
- Ideal for configuration that changes infrequently

**secret Volume Details:**
- Similar mounting to configMap but for sensitive data
- Files mounted with restrictive permissions (600)
- Service account tokens, TLS certificates, database passwords

**GCE Persistent Disk Details:**
- Provides persistent storage surviving pod restarts
- **Single writer limitation**: Only one pod can write at a time
- Read-only access possible from multiple pods (readWriteOnce)

**NFS Volume Details:**
- Network-attached storage accessible from multiple nodes
- Supports multiple readers and writers
- Better for cross-node, shared access scenarios

### Storage Abstraction Benefits

**From Cloud-Specific to Agnostic:**
```
Traditional: App → GCE Persistent Disk (hardcoded)
Kubernetes: App → PersistentVolumeClaim → PersistentVolume → Actual Storage
├── Portable across cloud providers
├── Declarative configuration
└── Dynamic resource management
```

### Volume Persistence Demonstration

**Problem with Deployments:**
- Data stored in pod containers is ephemeral
- Pod deletion/recreation loses all data

**Lab Demo: Volume Persistence Verification**
```bash
# Create pod with emptyDir volume and write data
kubectl run test-pod --image=busybox --restart=Never -- sleep 3600
kubectl exec -it test-pod -- sh
echo "test data" > /tmp/test.txt
ls -la /tmp/test.txt
# Shows file exists
```

```bash
# Delete pod and recreate
kubectl delete pod test-pod
kubectl run test-pod --image=busybox --restart=Never -- sleep 3600
kubectl exec -it test-pod -- sh
ls -la /tmp/test.txt
# File is gone - demonstrates ephemeral nature
```

## Summary

### Key Takeaways

> Jobs execute one-time tasks and release resources upon completion, while CronJobs schedule repetitive Jobs based on cron expressions. Volumes abstract storage from pods, providing either ephemeral scratch space or persistent data retention.

```diff
+ Jobs: Resource-efficient batch processing with completion tracking
- Deployments: Resource-consuming continuous operation

+ CronJobs: Automated scheduling with cron flexibility  
- Manual scheduling: Error-prone and labor-intensive

+ Persistent Volumes: Data survives pod lifecycle
- Ephemeral storage: Data loss on pod termination

+ Workload Identity: Secure, automated service-to-service authentication
- Manual keys: Credential management burden
```

### Quick Reference

**Job Management:**
```bash
kubectl apply -f job.yaml           # Create job
kubectl get jobs                    # List jobs
kubectl logs job/job-name           # View execution logs
kubectl delete jobs --older-than=7d # Cleanup old jobs
```

**CronJob Management:**
```bash
kubectl apply -f cronjob.yaml       # Create cronjob
kubectl get cronjobs                # List cronjobs
kubectl describe cronjob name       # View configuration
kubectl patch cronjob name -p '{"spec":{"suspend":true}}'  # Pause
```

**Volume Examples:**
```yaml
# Ephemeral emptyDir
volumes:
- name: temp
  emptyDir: {}

# Persistent GCE Disk
volumes:
- name: data
  gcePersistentDisk:
    pdName: my-disk
    fsType: ext4

# ConfigMap volume
volumes:
- name: config
  configMap:
    name: app-config
```

**Common Cron Expressions:**
```bash
"*/5 * * * *"   # Every 5 minutes
"0 * * * *"     # Every hour
"0 2 * * *"     # Daily at 2 AM
"0 9 * * 1-5"   # Weekdays 9 AM
```

### Expert Insight

#### Real-world Application
**Scenario**: Automated data pipeline for customer analytics
- **Jobs**: One-time data migration from legacy systems
- **CronJobs**: Daily ETL processes at off-peak hours
- **Volumes**: Persistent volumes for intermediate data storage between pipeline stages

#### Expert Path
- **Job chaining**: Use job dependencies for multi-step batch workflows
- **Resource quotas**: Configure namespace limits for batch workloads to prevent resource exhaustion
- **Storage optimization**: Use regional persistent disks for high-availability data requirements
- **Scheduling optimization**: Implement cron expression testing and job overlap prevention

#### Common Pitfalls
- **Resource leaks**: CronJobs creating overlapping jobs without proper cleanup
- **Single-writer conflicts**: GCE persistent disks causing pod scheduling failures in multi-replica scenarios
- **Time zone confusion**: CronJobs using UTC while application expects local time
- **Pod disruption**: Jobs interrupted by cluster maintenance without proper retry logic

#### Lesser-Known Facts
- **Job ownership**: CronJobs create independent Job objects following standard job lifecycle rules
- **Volume pod affinity**: Persistent disks create implicit node affinity for pods
- **ConfigMap reload limitation**: Changes to mounted ConfigMaps require pod restart for immediate effect, despite 60-second reload interval
- **TTL limitations**: Job cleanup only removes finalizers; manual cleanup may still be needed

### Advantages and Disadvantages

| Component | Advantages | Disadvantages |
|-----------|------------|--------------|
| Jobs | Efficient resource usage, completion guarantees, retry logic | Manual scheduling, no built-in history limits |
| CronJobs | Automated scheduling, flexible cron expressions, job isolation | UTC-only scheduling, potential resource spike overlaps, complex expressions |
| Ephemeral Volumes | Simple configuration, high performance, no storage costs | Data loss on pod failures, unsuitable for stateful data |
| Persistent Volumes | Data durability, pod restart resilience, cross-node availability (with NFS) | Additional storage costs, potential performance overhead, single-writer limitations (GCE) |
| Workload Identity | Automated authentication, reduced credential management, improved security | Requires IAM policy management, GCP-specific implementation |
