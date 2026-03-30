# Session 24: Day 24 - Deploy Containers in GKE - GUI & CLI Mode; Deploy Multiple Containers in Same Pod; IAM Roles

## Creating Kubernetes Clusters

### Overview
This session provides a comprehensive guide to deploying containerized applications in Google Kubernetes Engine (GKE) using both graphical user interface (GUI) and command-line interface (CLI) approaches. We'll explore the evolution from manual virtual machine management to automated container orchestration, with practical demonstrations of cluster creation, service account configuration, deployment strategies, and operational tasks like scaling and rolling updates.

### Key Concepts

Kubernetes clusters are the foundation of container orchestration in GKE, providing an abstraction layer that eliminates the need for manual virtual machine and networking configuration. GKE provides two cluster modes: **Standard** (manual control) and **Autopilot** (automated), with Standard offering more flexibility for learning purposes.

### Service Accounts and IAM Roles

Service accounts in GKE enable secure communication between cluster components and Google Cloud services. Key roles required for proper functionality:

```yaml
Artifact Registry Reader: Enables image pulling
Monitoring Metric Writer: Sends performance metrics
Logging Writer: Captures application logs
```

**Creating a dedicated service account:**
```bash
gcloud iam service-accounts create gke-node-sa \
  --description="Service account for GKE nodes" \
  --display-name="GKE Node Service Account"
```

**Granting necessary IAM roles:**
```bash
gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:gke-node-sa@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.reader"

gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:gke-node-sa@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/logging.writer"

gcloud projects add-iam-policy-binding PROJECT_ID \
  --member="serviceAccount:gke-node-sa@PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/monitoring.metricWriter"
```

### GUI Mode Deployment

#### Cluster Creation Steps
1. Navigate to GKE Console
2. Select "Standard" cluster mode
3. Choose regional/zonal configuration
4. Configure node pool settings
5. Set service account
6. Enable networking features
7. Monitor creation (typically 5-10 minutes)

> [!IMPORTANT]
> Always use Compute Engine default service account cautiously - dedicated service accounts provide better security and audit trails.

#### Application Deployment
1. Build and push container images to Artifact Registry
2. Deploy via Artifact Registry interface
3. Configure service exposure (LoadBalancer for external access)
4. Set target ports for container communication

#### Scaling Operations
**Manual scaling via GUI:**
- Locate deployment in Workloads section
- Use Actions → Scale
- Specify desired replica count

## CLI Mode Deployment

### Cluster Creation
```bash
gcloud container clusters create cluster-cli \
  --zone=us-west1-a \
  --service-account=gke-node-sa@PROJECT_ID.iam.gserviceaccount.com \
  --num-nodes=3
```

### Authentication
```bash
gcloud container clusters get-credentials cluster-cli --zone=us-west1-a
```

### Imperative Deployment
**Create deployment:**
```bash
kubectl create deployment my-app --image=gcr.io/PROJECT_ID/my-app:1.0 --replicas=2
```

**Expose service:**
```bash
kubectl expose deployment my-app \
  --name=my-app-service \
  --type=LoadBalancer \
  --port=80 \
  --target-port=8081
```

### Scaling Operations
```bash
# Manual scaling
kubectl scale deployment my-app --replicas=4

# View scaling status
kubectl get pods -w
```

### Rolling Updates
```bash
kubectl set image deployment/my-app my-app=gcr.io/PROJECT_ID/my-app:2.0
```

> [!NOTE]
> Rolling updates provide zero-downtime deployments by gradually replacing old pods with new ones.

## Deploying Multiple Containers in Same Pod

### Sidecar Pattern Implementation

The sidecar pattern enables deploying multiple containers within a single pod, sharing network namespace and storage while maintaining isolation. This is particularly useful for logging, monitoring, or service mesh implementations.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: multi-container-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: multi-container-app
  template:
    metadata:
      labels:
        app: multi-container-app
    spec:
      containers:
      - name: nodejs-container
        image: gcr.io/PROJECT_ID/nodejs-app:1.3
        ports:
        - containerPort: 8081
      - name: python-container
        image: gcr.io/PROJECT_ID/python-app:6.0
        ports:
        - containerPort: 8080
```

**Service configuration for multiple ports:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: multi-container-service
spec:
  selector:
    app: multi-container-app
  ports:
  - name: nodejs-port
    port: 8081
    targetPort: 8081
  - name: python-port
    port: 8080
    targetPort: 8080
  type: LoadBalancer
```

### Key Considerations
- **Port conflicts**: Each container must use unique ports within the pod
- **Shared resources**: Containers share network namespace and storage volumes
- **Resource allocation**: CPU and memory limits apply to the entire pod
- **Logging separation**: Container logs remain distinct despite shared pod

> [!WARNING]
> Deploying multiple containers in the same pod requires careful port management to avoid conflicts, as containers within a pod share the same network namespace.

## Logging and Monitoring

### Logging Integration
With proper IAM roles, container logs automatically stream to Cloud Logging:

```bash
# View logs via CLI
kubectl logs -f deployment/my-app

# Access via Cloud Logging UI
# Navigate to Logs Explorer
# Filter by resource: kubernetes_container
```

### Monitoring Setup
Cloud Monitoring captures metrics when monitoring.metricWriter role is assigned:

```bash
# Enable Cloud Monitoring
gcloud container clusters update cluster-name \
  --enable-cloud-monitoring
```

> [!WARNING]
> Without proper IAM roles, logs and metrics remain only in the container and are lost when pods terminate.

## Image Tagging Strategies

### Best Practices
```bash
# Pull specific version (recommended)
kubectl create deployment my-app --image=gcr.io/project/my-app:v1.3

# Pull by digest (most reliable)
kubectl create deployment my-app --image=gcr.io/project/my-app@sha256:...

# Avoid: latest tag (not recommended for production)
kubectl create deployment my-app --image=gcr.io/project/my-app:latest
```

> [!IMPORTANT]
> Kubernetes official documentation explicitly advises against using "latest" tags in production environments due to rollback challenges.

## Service Types Comparison

| Service Type | Use Case | External Access | Load Balancing |
|-------------|----------|----------------|----------------|
| ClusterIP | Internal pod communication | No | No |
| NodePort | Development/testing | Yes (Node IP:Port) | Basic |
| LoadBalancer | Production external access | Yes (External IP) | Advanced |

## Firewall Rules and Security

GKE automatically creates necessary firewall rules for cluster communication:

```bash
# List GKE-created firewall rules
gcloud compute firewall-rules list --filter="name:gke-*"
```

> [!WARNING]
> Never modify or delete GKE-managed firewall rules, as this can break cluster functionality.

## Troubleshooting Common Issues

### Image Pull Errors
```diff
- Missing Artifact Registry Reader role
+ Grant roles/artifactregistry.reader to service account

- Image not found
+ Verify image exists and tagging is correct
```

### Pod Status Issues
```diff
- ImagePullBackOff
+ Check IAM permissions and image availability

- CrashLoopBackOff
+ Review container logs and resource limits
```

### Service Exposure Problems
```diff
- External IP shows <pending>
+ Wait for LoadBalancer provisioning (can take several minutes)

- Port conflicts
+ Ensure unique container ports within pod
```

## Summary

### Key Takeaways
```diff
+ GKE abstracts virtual machines, networking, and storage management
+ Service accounts enable secure communication with GCP services
+ GUI mode excels for learning; CLI mode required for automation
+ Imperative deployment provides quick results; declarative preferred for production
+ Multiple containers per pod enable sidecar patterns but require careful port management
+ Proper IAM roles essential for logging and monitoring
+ Rolling updates provide zero-downtime deployments
- Avoid "latest" image tags in production
- Never modify GKE-managed firewall rules
```

### Expert Insight

**Real-world Application**: Enterprise deployments often combine CLI automation with GUI monitoring. Use kubectl for deployments, Cloud Console for health monitoring and scaling operations.

**Expert Path**: Master kubectl imperative commands first, then transition to declarative YAML manifests. Focus on CI/CD integration using Cloud Build and Cloud Deploy for automated deployments.

**Common Pitfalls**:
- Using default compute service account instead of dedicated accounts
- Forgetting IAM roles, resulting in missing logs and metrics
- Port conflicts when deploying multiple containers per pod
- Using "latest" tags preventing reliable rollbacks
- Modifying automatically created firewall rules

**Lesser Known Details**:
- GKE creates instance templates and managed instance groups automatically
- Each node pool maps to one MIG, enabling heterogeneous clusters
- Service accounts created during API enablement are Google-managed
- Container optimized OS is the recommended node image for security
- Cloud Logging integration requires specific IAM permissions beyond basic logging

**Transcript Corrections Made**: The transcript contained various misspellings including "cuberes" instead of "kubernetes", "hte" (likely "the"), "differen" instead of "different", "availab" instead of "available", and various fragments like "ubernetes" incomplete words. All instances have been corrected to standard English spelling and technical terminology in the study guide.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
