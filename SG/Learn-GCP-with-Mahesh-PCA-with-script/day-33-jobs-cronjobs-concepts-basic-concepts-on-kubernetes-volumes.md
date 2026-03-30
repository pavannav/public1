# Session 33: Jobs, CronJobs, and Kubernetes Volumes

## Table of Contents
- [Workload Identity Federation Setup](#workload-identity-federation-setup)
- [Use Case: Routine Data Generation to GCS](#use-case-routine-data-generation-to-gcs)
- [Kubernetes Workloads Overview](#kubernetes-workloads-overview)
- [Jobs in Kubernetes](#jobs-in-kubernetes)
- [Demonstration: Creating and Managing Jobs](#demonstration-creating-and-managing-jobs)
- [Pre-Built Applications via Marketplace](#pre-built-applications-via-marketplace)
- [CronJobs for Scheduled Tasks](#cronjobs-for-scheduled-tasks)
- [Drawbacks of Deployment Objects for Stateful Workloads](#drawbacks-of-deployment-objects-for-stateful-workloads)
- [Kubernetes Volumes Fundamentals](#kubernetes-volumes-fundamentals)
- [Types of Volumes](#types-of-volumes)

## Workload Identity Federation Setup

### Overview
Workload Identity Federation enables secure, seamless access for Kubernetes workloads to Google Cloud services without needing static service account keys. This enhances security by tying Kubernetes Service Accounts (KSAs) to Google Service Accounts (GSAs) dynamically.

### Key Concepts
- **Enabling Workload Identity Pool**: Create and enable the workload identity pool on an existing or new GKE cluster.
- **Namespace and Service Accounts**: Use specific namespaces (e.g., `scheduled-jobs`) and create KSAs (e.g., `ksa-scheduler`) bound to GSAs.
- **GSA Permissions**: Grant appropriate roles (e.g., Storage Object Admin) at resource level (e.g., specific GCS bucket) rather than project level for least privilege.
- **Node Selector**: Ensure nodes have the required labels (e.g., `iam.gke.io/gcp-service-account`) for identity propagation.

### Code/Config Blocks
Enable Workload Identity on new cluster:
```bash
gcloud container clusters create CLUSTER_NAME --region REGION --workload-pool PROJECT_ID.svc.id.goog --enable-image-streaming --enable-shielded-nodes
```

Create IAM policy binding for resource-level access:
```bash
gcloud storage buckets add-iam-policy-binding gs://BUCKET_NAME --member="principal://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workloadIdentityPools/PROJECT_ID.svc.id.goog/subject/ns/NAMESPACE/sa/SERVICE_ACCOUNT_NAME@PROJECT_ID.iam.gserviceaccount.com" --role=roles/storage.objectAdmin
```

Create KSA and bind:
```bash
gcloud iam service-accounts add-iam-policy-binding GSA_EMAIL --role roles/iam.workloadIdentityUser --member "serviceAccount:PROJECT_ID.svc.id.goog[scheduled-jobs/ksa-scheduler]"
```

### Lab Demo: Access Validation
- Deploy a pod with the KSA annotation.
- Execute into the pod and list GCS bucket objects to confirm access.
  - Access granted to specific bucket only (access denied for others).

> **📝 Note**: Identity is propagated at the pod level, utilizing the workload identity pool created during cluster setup.

## Use Case: Routine Data Generation to GCS

### Overview
The primary use case involves generating data (e.g., logs or metrics) inside a Kubernetes pod and storing it in a Google Cloud Storage (GCS) bucket on a routine basis (e.g., every 5 minutes).

### Key Concepts
- Container images like `gcr.io/google-cloud-sdk/slim` or custom Python-based images for cloud interactions.
- Use of workload identity for secure GCS access.
- Data generation via scripts (e.g., shell or Python) and upload using `gsutil` or SDK libraries.
- Routine execution managed via Jobs or CronJobs.

### Tables
| Component | Purpose |
|-----------|---------|
| GCS Bucket | Storage destination for generated data |
| Workload Container | Runs data generation logic |
| KSA with Identity | Enables secure bucket access without keys |

### Lab Demo: Data Upload Workflow
1. Generate sample data (e.g., JSON logs).
2. Use `gsutil cp` to upload to bucket.
3. Verify upload via `gsutil ls gs://BUCKET_NAME`.

```bash
echo "Sample data" > data.txt
gsutil cp data.txt gs://BUCKET_NAME/
gsutil ls gs://BUCKET_NAME/
```

**🚀 Real-world Application**: Backend services generating audit logs or metrics data that need periodic archival to cloud storage.

## Kubernetes Workloads Overview

### Key Concepts
- **Deployment**: For long-running, stateless applications with self-healing and scaling.
- **Jobs**: For one-time or batch tasks that complete and release resources.
- **CronJobs**: For scheduled, recurring Jobs.

```diff
+ Deployments: Continuous resource utilization
- Jobs/CronJobs: Release resources post-completion; better for bursty workloads
```

- **Self-Healing**: Enabled via replica sets in Deployments; limited retries in Jobs.

> **⚠ Common Pitfalls**: Misusing Deployments for stateful or one-time tasks leads to wasted resources. Always assess workload characteristics (stateless vs. stateful, one-time vs. recurring).

## Jobs in Kubernetes

### Overview
Jobs are Kubernetes controller objects designed for running one-time or batch processes that need to complete successfully. Upon completion, resources are released, making it cost-effective.

### Key Concepts
- **Job Lifecycle**: Created, executes pod(s), completes (success/failure), retains history for audit.
- **Backoff Limits**: Retry failed jobs up to specified attempts (default 6); prevents infinite loops.
- **Self-Healing**: Limited retries if pods fail, but not for indefinite execution.
- **Use Cases**: Pre-deployment tasks, data migrations, computations (e.g., Pi calculation).

### Code/Config Blocks
Basic Job YAML for Pi calculation:
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: pi-calculation
spec:
  backoffLimit: 4
  template:
    spec:
      containers:
      - name: perl
        image: perl:5.34
        command: ["/bin/sh", "-c", "perl -Mbignum=bpi -wle 'print bpi(2000)'"]
      restartPolicy: Never
```

- `restartPolicy: Never` ensures completion-based termination.

### Lab Demo: Job Execution
1. Apply Job YAML.
2. Monitor pod status: `kubectl get pods`.
3. Retrieve logs: `kubectl logs JOB_POD_NAME`.
4. Observe resource release post-completion.

**🚀 Expert Insight**: Use Jobs for CI/CD pipelines or ETL processes where execution is finite.

## Demonstration: Creating and Managing Jobs

### Overview
This demo builds on the Pi calculation Job to illustrate creation, monitoring, and cleanup.

### Key Concepts
- **Job States**: Pending → Running → Succeeded/Failed.
- **Resource Auditing**: Jobs maintain completion history.
- **Cleanup**: Manually delete completed Jobs to free resources.

### Lab Demo Steps
1. Create and deploy Pi Job.
2. Check logs for output.
3. Delete Job and verify pods are terminated.

```bash
kubectl apply -f pi-job.yaml
kubectl logs -l job-name=pi-calculation
kubectl delete job pi-calculation
```

> **⚠ Common Pitfalls**: Forgetting to set appropriate `backoffLimit`; excessive retries waste cluster resources.

## Pre-Built Applications via Marketplace

### Overview
Google Cloud Marketplace offers pre-configured, deployable Kubernetes applications (e.g., RabbitMQ) that include Jobs for initialization.

### Key Concepts
- **Components Included**: Jobs for setup, StatefulSets for persistence, Services for access.
- **Benefits**: Quick deployment without manual YAML creation.
- **Tear-Down**: Deletes associated resources.

### Lab Demo: RabbitMQ Deployment
1. Search Marketplace for "RabbitMQ".
2. Configure (e.g., name: `rabbitmq-app`, replicas: 1).
3. Deploy and access via exposed LoadBalancer or internal endpoint.
4. Observe Job (e.g., `rabbitmq-deployer`) for initial setup.

**🚀 Real-world Application**: Deploy messaging queues or databases quickly in development/test environments.

## CronJobs for Scheduled Tasks

### Overview
CronJobs are extensions of Jobs for recurring executions based on cron schedules.

### Key Concepts
- **Scheduling**: Uses cron format (e.g., `5 * * * *` for every 5 minutes).
- **History Limit**: Retains successful/failed job history (default 3; configurable).
- **Suspension**: Pause/resume via `spec.suspend: true/false`.
- **Timezone**: Defaults to UTC; specify if needed.
- **Concurrency Policy**: Control multiple concurrent runs.

### Code/Config Blocks
Basic CronJob YAML:
```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: data-generator-cron
spec:
  schedule: "*/5 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: data-gen
            image: custom-generator-image
            command: ["python", "gen-data.py"]
          restartPolicy: OnFailure
```

- Convert Jobs to CronJobs by wrapping in `jobTemplate` and adding `schedule`.

### Lab Demo: Scheduled Data Generation
1. Deploy CronJob.
2. Verify jobs run per schedule.
3. Adjust schedule or suspend as needed.

**🚀 Expert Insight**: Ideal for periodic data backups or health checks in production.

## Drawbacks of Deployment Objects for Stateful Workloads

### Overview
Deployment objects are stateless and ephemeral; data is lost on pod recreation. Stateful workloads require persistent storage.

### Key Concepts
- **Pod Ephemerality**: Pod deletion loses data in containers.
- **Self-Healing**: New pods have fresh state; no data persistence.
- **Solution**: Use StatefulSets or persistent volumes.

### Lab Demo: Data Loss Verification
1. Generate data in a Deployment pod.
2. Delete pod.
3. Verify data loss in new pod.

**⚠ Common Pitfalls**: Storing data in pods without volumes leads to permanent loss on failures or upgrades.

## Kubernetes Volumes Fundamentals

### Overview
Volumes provide storage abstraction in Kubernetes, allowing data persistence and sharing across containers in a pod.

### Key Concepts
- **Attchment Scope**: Volumes attach to pods, not containers—accessible by all pod containers.
- **Types**: Ephemeral (e.g., EmptyDir) vs. Persistent (e.g., GCS-based).
- **Abstraction**: Persistent Volumes decouple from cloud-specific implementations.

```diff
+ Ephemeral Volumes: Data lost on pod deletion
- Persistent Volumes: Data retained across pod lifecycles
```

### Types of Volumes

#### Ephemeral Volumes
- **EmptyDir**: Temporary scratch space using node's local disk; data persists only during pod lifetime.
- **ConfigMap Volume**: Mounts ConfigMap data as files; auto-reloads every 60s; non-sensitive config.
- **Secret Volume**: Similar to ConfigMap but for sensitive data; encrypted at rest.

#### Persistent Volumes
- **GCE Persistent Disk**: Persistent across pod deletes; single-writer/multi-reader. **Limitation**: Read-write limited to one node per volume.
- **NFS (File Store)**: Multi-writer support; higher cost and Cloud-native.
- **Persistent Volume Claim (PVC)**: Abstracts underlying storage; allows Cloud-agnostic manifests by claiming pre-defined PVs.

### Code/Config Blocks
Example EmptyDir mount:
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: data-pod
spec:
  containers:
  - name: generator
    image: busybox
    command: ["/bin/sh", "-c", "echo 'data' > /tmp/data.txt; sleep 300"]
    volumeMounts:
    - name: shared-volume
      mountPath: /tmp
  volumes:
  - name: shared-volume
    emptyDir: {}
```

Example GCE Persistent Disk:
```yaml
volumes:
- name: gce-disk
  gcePersistentDisk:
    pdName: my-disk
    fsType: ext4
```

### Lab Demo: Volume Mounting
1. Attach EmptyDir to pod.
2. Generate data and mount to path.
3. Verify data in multiple containers (if present).

**🚀 Real-world Application**: Use PVCs for databases or file shares in multi-cloud deployments.

## Summary

### Key Takeaways
```diff
+ Workload Identity: Secure, keyless GCP access for pods via KSAs/GSAs binding.
+ Jobs: Ideal for one-time tasks; releases resources after completion.
+ CronJobs: Scheduled Jobs with cron syntax; supports history and suspension.
+ Volumes: Ephemeral for temp data; Persistent (e.g., PVC) for stateful workloads.
- Misuse Deployments: Avoid for scheduled/stateful tasks to prevent resource waste.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### Expert Insight

**Real-world Application**: In production, use CronJobs for automated log rotations or backups. Combine with persistent volumes to ensure data integrity in database-heavy applications.

**Expert Path**: Master workload identity for IAM best practices. Experiment with StatefulSets for advanced stateful workloads like databases.

**Common Pitfalls**: Over-reliance on ephemeral volumes leads to data loss. Not setting `backoffLimit` in Jobs causes unnecessary resource consumption. giải

**Lesser Known Things**: CronJobs support timezone-aware schedules in beta versions. Volumes can be dynamically provisioned via StorageClasses for auto-scaling storage needs.
