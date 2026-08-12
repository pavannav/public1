# Chapter 7: Computing with Kubernetes

> **Exam Objective Covered:**
> - 3.2 Deploying and implementing Google Kubernetes Engine resources

---

This chapter introduces Kubernetes architecture, core objects, cluster deployment using Cloud Console and `gcloud`, application pod deployment using `kubectl`, and monitoring Kubernetes clusters with Cloud Operations Suite.

---

## Introduction to Kubernetes Engine

- **Kubernetes Engine (GKE)** — Google Cloud's managed Kubernetes service. Customers create and maintain clusters without managing the Kubernetes platform itself.
- **Container orchestration** — determines where to run containers, monitors health, manages the full VM instance life cycle.
- GKE uses **instance groups** to manage the underlying VMs in a cluster.

**Containers vs. VMs:**

| Feature | Containers | Virtual Machines |
|---|---|---|
| Guest OS required | No | Yes |
| Start/stop speed | Seconds | Minutes |
| Resource usage | Lightweight | Heavier |
| Portability | Dev → test → prod without reconfiguration | Less portable |
| Isolation mechanism | Host OS features + container manager | Hypervisor |

> Containers are like shipping containers — they can move from development laptops to testing and production servers without reconfiguration, just as shipping containers ride ships, trains, and trucks.

---

### Kubernetes Cluster Architecture

A Kubernetes cluster consists of a **control plane** and one or more **worker nodes**.

```
Kubernetes Cluster
├── Control Plane (manages the cluster; replicated for HA)
│   ├── API Server          — exposes the Kubernetes API; all cluster communication goes through it
│   ├── Scheduler           — assigns pods to nodes
│   ├── Controller Manager  — manages node controller, job controller, service account controller
│   └── etcd                — highly available key-value store (cluster state)
└── Worker Nodes (execute workloads)
    ├── Kubelet             — agent on each node; communicates with the control plane
    ├── Container Runtime   — software responsible for running containers
    └── Kube-proxy          — network proxy on each node
```

**Core components summary:**

| Component | Location | Role |
|---|---|---|
| **API Server** | Control plane | Exposes Kubernetes API; entry point for all interactions |
| **Scheduler** | Control plane | Assigns pods to nodes |
| **Controller Manager** | Control plane | Manages resource controllers (node, job, service account) |
| **etcd** | Control plane | Highly available key-value store for cluster state |
| **Kubelet** | Each node | Agent communicating with control plane |
| **Container Runtime** | Each node | Runs containers |
| **Kube-proxy** | Each node | Network proxy |

- **Nodes** — VMs running specialized container-optimized OS. Some memory and CPU is **reserved for Kubernetes** itself and is not available to applications.
- Users interact with the cluster via `kubectl` or through the control plane's Kubernetes API.

---

### Kubernetes Objects

Kubernetes organizes workloads using the following objects:

| Object | Purpose |
|---|---|
| **Pods** | Single instance of a running process; contains one or more containers |
| **Services** | Stable endpoint (IP) that decouples clients from ephemeral pods |
| **Deployments** | Set of identical pods; maintains desired state using a pod template |
| **ReplicaSets** | Controller ensuring the correct number of pods are running |
| **StatefulSets** | Deployments for stateful apps; assigns unique identifiers to pods |
| **Jobs** | Creates pods that run until a workload completes |
| **Volumes** | Storage persisting independently of pod life cycle |
| **Namespaces** | Logical separation of resources within a cluster |
| **Node Pools** | Set of nodes in a cluster with the same configuration |

---

#### Pods

- **Pods** are the smallest deployable unit in Kubernetes — a single instance of a running process.
- Contain **at least one container**; may contain multiple when containers are tightly coupled and must share resources.
- Pods share:
  - **Networking** — each pod gets a unique IP address and a set of ports; multiple containers within a pod communicate via `localhost`.
  - **Storage** — shared across containers in the pod.
- Containers within a pod behave as if running on an isolated VM (shared storage, one IP, shared ports).
- Pods are **ephemeral** — expected to terminate; if unhealthy (stuck waiting, crashing repeatedly), they are terminated.
- Generally created in **groups called replicas** (managed as a unit).
- Pods support **autoscaling**.
- Health monitoring and scaling are managed by **controllers**.

#### Services

- Pods are ephemeral — their IP addresses can change when they are terminated and replaced.
- **Services** provide a **stable IP address** (API endpoint) so clients don't need to track individual pod IPs.
- Services maintain an **up-to-date list of pods** running a particular application and update automatically when pod changes occur.
- This provides a **level of indirection** between clients and the pods they consume.

#### Deployments

- **Deployments** are sets of **identical pods** created from the same **pod template**.
- A **pod template** defines how to run a pod (the specification is called a **pod specification**).
- Kubernetes ensures pods match the desired state defined in the template:
  - If the number of pods falls below the specified minimum → more pods are added via a ReplicaSet.
- Pod membership can change (pods terminated, others started) but all run the same application.

#### ReplicaSets

- A **controller** used by deployments to ensure the **correct number of identical pods** are running.
- If a pod is unhealthy → controller terminates it → ReplicaSet detects the deficit → creates a replacement.
- Also used to **update and delete pods**.

> **Best practice:** Use Deployments rather than ReplicaSets directly unless you require custom update orchestration or no updates at all.

#### StatefulSets

- Like Deployments, but assign **unique persistent identifiers** to each pod.
- Used when an application needs:
  - A **unique network identifier** per pod
  - **Stable persistent storage**
- Example: A session that must always be handled by the same pod (stateful sessions).
- Contrast with stateless apps (e.g., a calculation API) where any pod can handle any request.

#### Jobs

- An abstraction for a **workload that runs to completion**.
- Creates pods and runs them until the application completes the specified workload.
- Configuration is defined in a **config file** specifying the container and command to run.

#### Volumes

- **Storage mechanism** that persists data **independently of the pod life cycle**.
- If a pod fails and is restarted → volume data survives → attached to the replacement pod.
- Also used to **share files across containers** running in the same pod.

#### Namespaces

- **Logical abstractions** for separating groups of resources within a cluster.
- Used when clusters host multiple projects, teams, or groups with different policies.
- Kubernetes creates:
  - A **default namespace** — used for objects with no other namespace defined.
  - **System namespaces** — for cluster administration.

#### Node Pools

- A **set of nodes** in a cluster that share the **same configuration**.
- When a cluster is first created, all nodes are in the same node pool.
- Additional node pools can be added after creation.
- Use case: A node pool of **preemptible VMs** to assign cost-sensitive workloads while preventing others from running on them.

---

## Deploying Kubernetes Clusters

Clusters can be deployed via Cloud Console, Cloud Shell, or local Cloud SDK.

### Deploying Kubernetes Clusters Using Cloud Console

**Prerequisite:** Enable the **Kubernetes Engine API**.

**Console path:** Kubernetes Engine → Overview → Create Cluster

![The Overview page of the Kubernetes Engine section of Cloud Console](../images/c07f001.png)

**Figure 7.1** — Kubernetes Engine Overview page

**Two cluster creation modes:**

| Mode | Node Management | Billing | Recommended? |
|---|---|---|---|
| **Standard** | User manages and configures nodes | Pay per provisioned node | When you need full control |
| **Autopilot** | GKE manages node infrastructure | Pay only for resources used when apps run | **Yes — recommended** |

![When creating a GKE, you specify standard mode or autopilot mode.](../images/c07f002.png)

**Figure 7.2** — Standard vs. Autopilot mode selection

---

**Autopilot cluster — what GKE automatically manages:**
- Node infrastructure configuration
- VPC-native traffic routing (public and private clusters)
- Shielded GKE nodes
- Logging and monitoring

**Autopilot cluster creation parameters:**

| Parameter | Description |
|---|---|
| Cluster name | Identifier for the cluster |
| Cluster description | Optional description |
| Region | Geographic region for the cluster |
| Public or Private | Private = nodes have only private IPs; control plane ↔ node comms via private addresses only |

![Creating an autopilot GKE cluster](../images/c07f003.png)

**Figure 7.3** — Autopilot cluster creation form

**Autopilot networking options:**

- Enable **control plane–authorized networks** — blocks non-trusted, non-Google Cloud source IPs from accessing the control plane via HTTPS.
- Specify: network, node subnet, address ranges for pods and services (using **CIDR notation**, e.g., `192.168.0.0/16`).

![Networking options in autopilot mode](../images/c07f004.png)

**Figure 7.4** — Networking options in Autopilot mode

**Autopilot advanced options:**

| Option | Description |
|---|---|
| Maintenance window | Schedule time for routine Kubernetes maintenance (default: any time) |
| Google Groups for RBAC | Grant roles to Google Workspace Group members |
| Application-layer secrets encryption | Encrypt secrets stored in etcd (control plane) |
| Customer-managed key | Encrypt node boot disks with a customer-managed key |
| Labels and description | Metadata for the cluster |

![Advanced options in autopilot mode](../images/c07f005.png)

**Figure 7.5** — Advanced options in Autopilot mode

![Once the autopilot clusters are deployed, it will be listed on the GKE page of the console.](../images/c07f006.png)

**Figure 7.6** — Deployed autopilot cluster listed in GKE console

---

**Standard cluster creation options:**

- Specify **name** and **location** (zone for zonal cluster, region for regional cluster).
- **Regional clusters** — nodes in **3 zones by default**; can specify custom zones.
- **Release channel** (default) — enables **automatic cluster software upgrades**.
- **Static channel** — user controls the upgrade process manually.

![Initial steps to configure a standard cluster](../images/c07f007.png)

**Figure 7.7** — Standard cluster configuration form

---

### Deploying Kubernetes Clusters Using Cloud Shell and Cloud SDK

**Base command for Kubernetes Engine:**

```bash
gcloud container
```

**`gcloud container clusters create` parameters:**

| Parameter | Description |
|---|---|
| `--num-nodes` | Number of nodes per zone |
| `--region` | Region for the cluster |
| `--zone` | Zone for a zonal cluster |
| `--machine-type` | Machine type for nodes |
| `--image-type` | Node OS image type |
| `--disk-type` | Boot disk type |
| `--disk-size` | Boot disk size |

```bash
# Create a standard mode cluster with 3 nodes in us-central1
gcloud container clusters create cluster1 --num-nodes=3 --region=us-central1

# Create an autopilot mode cluster
gcloud container clusters create-auto CLUSTER_NAME --region=REGION
```

> Full parameter reference: `https://cloud.google.com/sdk/gcloud/reference/container/clusters/create`

---

## Deploying Application Pods

### Deploying via Cloud Console

**Console path:** Kubernetes Engine → Clusters → Create Deployment

**Step 1 — Container configuration:**

| Parameter | Description |
|---|---|
| Container image | Docker image to run |
| Environment variables | Key-value environment configuration |
| Initial command | Command to start the application |

**Step 2 — Deployment configuration:**

| Parameter | Description |
|---|---|
| Application name | Name for the deployment |
| Namespace | Kubernetes namespace |
| Labels | Key-value metadata |
| Cluster | Target cluster |

![The Create Deployment option provides a form to specify a container to run and an initial command.](../images/c07f008.png)

**Figure 7.8** — Create Deployment form — container configuration

![Configuring a deployment](../images/c07f009.png)

**Figure 7.9** — Deployment configuration (name, namespace, labels, cluster)

After configuration, Cloud Console generates a **YAML specification** that can be saved and reused to create deployments from the command line.

---

### Deployment YAML Specification

Deployment configs use **YAML format**. Core YAML elements:

| Element | Purpose |
|---|---|
| `apiVersion` | API version used |
| `kind` | Type of Kubernetes object |
| `metadata` | Name, namespace, labels |
| `spec` | Desired state specification |

**Listing 7.1** — Sample YAML configuration for a deployment with autoscaling:

```yaml
apiVersion: "apps/v1"
kind: "Deployment"
metadata:
  name: "nginx-1"
  namespace: "default"
  labels:
    app: "nginx-1"
spec:
  replicas: 3
  selector:
    matchLabels:
      app: "nginx-1"
  template:
    metadata:
      labels:
        app: "nginx-1"
    spec:
      containers:
      - name: "nginx-1"
        image: "nginx:latest"
---
apiVersion: "autoscaling/v2beta1"
kind: "HorizontalPodAutoscaler"
metadata:
  name: "nginx-1-hpa-5fkn"
  namespace: "default"
  labels:
    app: "nginx-1"
spec:
  scaleTargetRef:
    kind: "Deployment"
    name: "nginx-1"
    apiVersion: "apps/v1"
  minReplicas: 1
  maxReplicas: 5
  metrics:
  - type: "Resource"
    resource:
      name: "cpu"
      targetAverageUtilization: 80
```

---

### Deploying via `kubectl`

`kubectl` is the Kubernetes command-line tool for managing the **internal state** of clusters.

**Install `kubectl`:**

```bash
gcloud components install kubectl
```

**`kubectl` command structure:**

```
kubectl  <verb>  <resource>  [OPTIONS]
```

> Note: `kubectl` uses **verb → resource** order, whereas `gcloud` uses **resource → verb** order.

```bash
# Create a deployment running a Docker image on port 8080
kubectl create deployment app-deploy1 --image=app1 --port=8080

# Scale a deployment to 5 replicas
kubectl scale deployment app-deploy1 --replicas=5

# Scale a deployment to 10 replicas
kubectl scale deployment ch07-app-deploy --replicas=10
```

**`gcloud` vs. `kubectl` command comparison:**

| Tool | Syntax Order | Example |
|---|---|---|
| `gcloud` | resource → verb | `gcloud container clusters create` |
| `kubectl` | verb → resource | `kubectl scale deployment` |

---

## Monitoring Kubernetes

- **Cloud Operations Suite** — Google Cloud's comprehensive monitoring, logging, and alerting product.
- Includes **Cloud Monitoring** and **Cloud Logging**, both usable with GKE clusters.
- Both are **enabled by default** when creating a cluster.

**GKE metric sources:**

| Source | Description |
|---|---|
| **System metrics** | Low-level cluster resources: CPUs, memory, storage |
| **Managed Service for Prometheus** | Google-managed version of the open source Prometheus monitoring tool; no infrastructure management required |
| **Workload metrics** | Deprecated set of metrics exposed by GKE workloads |

> **Prometheus** — widely used open source system for collecting performance metrics. Google Cloud offers it as a **managed service** so customers can use it without managing the Prometheus infrastructure themselves.

---

## Summary

| Topic | Key Points |
|---|---|
| **Kubernetes Engine** | Google-managed Kubernetes; container orchestration; uses instance groups for underlying VMs |
| **Control plane** | API Server, Scheduler, Controller Manager, etcd; manages nodes and workloads |
| **Nodes** | Worker VMs; run Kubelet, Container Runtime, Kube-proxy; some CPU/memory reserved for Kubernetes |
| **Pods** | Smallest unit; single running process; one or more containers; ephemeral |
| **Services** | Stable IP endpoint; decouples clients from ephemeral pod IPs |
| **Deployments** | Set of identical pods; maintains desired state via pod template + ReplicaSet |
| **ReplicaSets** | Ensures correct pod count; auto-replaces unhealthy pods |
| **StatefulSets** | Deployments for stateful apps; unique persistent identifiers per pod |
| **Jobs** | Runs pods until workload completes |
| **Volumes** | Pod-independent persistent storage |
| **Namespaces** | Logical cluster resource separation |
| **Node Pools** | Same-configuration node groups within a cluster |
| **Deployment modes** | Standard (user manages nodes) vs. Autopilot (GKE manages; pay per pod; recommended) |
| **CLI tools** | `gcloud container` for GKE management; `kubectl` for internal cluster management |
| **Monitoring** | Cloud Monitoring + Cloud Logging (default); Managed Prometheus available |

---

## Exam Essentials

- **Kubernetes is a container orchestration system.** GKE is Google Cloud's managed Kubernetes product. Kubernetes manages containers running across a set of VM instances.

- **Control plane manages nodes and workloads.** Coordinates execution, monitors pod health. Problematic pods are corrected and rescheduled by the control plane.

- **Pod definitions:**
  - **Pod** — single instance of a running process.
  - **Service** — stable IP endpoint; decouples clients from specific pod IPs.
  - **ReplicaSet** — controller ensuring correct pod count.
  - **Deployment** — set of identical pods using a pod template.
  - **StatefulSet** — deployment for stateful apps with unique pod identifiers.

- **`gcloud` vs. `kubectl` syntax:**
  - `gcloud container clusters create` — manages GKE service resources.
  - `kubectl scale deployment` — manages internal cluster state.
  - `gcloud`: resource before verb. `kubectl`: verb before resource.
  - Deployment YAML format: `apiVersion`, `kind`, `metadata`, `spec`.

- **Autopilot vs. Standard:**
  - Autopilot = GKE manages infrastructure; pay per pod; recommended.
  - Standard = user manages nodes; pay per provisioned node; more control.

- **Monitoring:** Cloud Operations Suite (Cloud Monitoring + Cloud Logging) enabled by default. Managed Prometheus available for metrics collection.

---

## Review Questions

1. What purpose do instance groups play in a Kubernetes cluster?
   - A. They monitor the health of instances
   - B. They create pods and deployments
   - C. **They create sets of VMs that can be managed as a unit**
   - D. They create alerts and notification channels

2. What components are required in a Kubernetes cluster?
   - A. **A control plane and nodes to execute workloads**
   - B. A control plane, nodes, and monitoring nodes
   - C. Kubernetes nodes; all instances are the same
   - D. Instances with at least six vCPUs

3. What is a pod in Kubernetes?
   - A. A set of containers
   - B. Application code deployed in a Kubernetes cluster
   - C. **A single instance of a running application in a cluster**
   - D. A controller that manages communication between clients and Kubernetes services

4. You have developed an application that calls a service in a Kubernetes cluster. Pods can be terminated and replaced with different IP addresses. How should you code your application?
   - A. Query Kubernetes for a list of IP addresses of pods running the service
   - B. **Communicate with Kubernetes Services so applications do not have to be coupled to specific pods**
   - C. Query Kubernetes for a list of pods running the service
   - D. Use a `gcloud` command to get the IP addresses needed

5. Application performance has degraded and you suspect configuration changes altered the number of running pods. Where would you look for details on the number of pods that should be running?
   - A. **Deployment config**
   - B. Cloud Operations Suite
   - C. Container Runtime
   - D. Jobs

6. You are deploying a high-availability application in Kubernetes Engine and want to maintain availability even if a data center has a major network outage. What feature would you employ?
   - A. Multiple instance groups
   - B. **Regional cluster**
   - C. Regional deployments
   - D. Load balancing

7. You need to quickly write a script to deploy a Kubernetes cluster with GPUs but are unsure of all required parameters. What is the fastest way to develop this script?
   - A. **Use the GPU template in the Kubernetes Engine cloud console to generate the `gcloud` command**
   - B. Search the web for a script
   - C. Review the documentation on `gcloud` parameters for adding GPUs
   - D. Use an existing script and add GPU parameters

8. What `gcloud` command creates a cluster named `ch07-cluster-1` with four nodes?
   - A. **`gcloud container clusters create ch07-cluster-1 --num-nodes=4`**
   - B. `gcloud container clusters create ch07-cluster-1 --size=4`
   - C. `gcloud container clusters create ch07-cluster-1 --region-nodes=4`
   - D. `gcloud beta container clusters create ch07-cluster-1 4`

9. When using Create Deployment from Cloud Console, which of the following CANNOT be specified?
   - A. Container image
   - B. Application name
   - C. **Time to Live (TTL)**
   - D. Initial command

10. Deployment configuration files created in Cloud Console use what file format?
    - A. CSV
    - B. **YAML**
    - C. TSV
    - D. JSON

11. What command is used to run a Docker image on a cluster?
    - A. `gcloud container run`
    - B. `gcloud container clusters run`
    - C. **`kubectl run`**
    - D. `kubectl container run`

12. What command would you use to have 10 replicas of a deployment named `ch07-app-deploy`?
    - A. `kubectl upgrade deployment ch07-app-deploy --replicas=5`
    - B. `gcloud containers deployment ch07-app-deploy --replicas=5`
    - C. **`kubectl scale deployment ch07-app-deploy --replicas=10`**
    - D. `kubectl scale deployment ch07-app-deploy --pods=5`

13. Cloud Operations Suite is used for what operations on Kubernetes clusters?
    - A. Notifications only
    - B. Monitoring and notifications only
    - C. Logging only
    - D. **Notifications, monitoring, and logging**

14. What must you do to enable Cloud Logging and Cloud Monitoring when creating a GKE cluster?
    - A. Specify `--monitoring=True` and `--logging=True` in the `gcloud container create cluster` command
    - B. Create a node pool configured for monitoring and logging
    - C. Create a namespace configured for monitoring and logging
    - D. **Nothing; metrics and logs are sent to Cloud Logging and Cloud Monitoring by default**

15. What popular open source monitoring tool is available in Google Cloud as a managed service?
    - A. **Prometheus**
    - B. Apache Flink
    - C. MongoDB
    - D. Spark

16. You want to create a Kubernetes Engine cluster while minimizing configuration and infrastructure management. What kind of cluster would you create?
    - A. Standard mode cluster
    - B. **Autopilot mode cluster**
    - C. Minimal mode cluster
    - D. Template mode cluster

17. You want the greatest degree of control over your Kubernetes cluster. What kind of cluster would you create?
    - A. **Standard mode cluster**
    - B. Autopilot mode cluster
    - C. Minimal mode cluster
    - D. Template mode cluster

18. You want to create a Kubernetes cluster but do not want GKE to automatically upgrade it. How would you configure it?
    - A. With a release channel
    - B. **With a static channel**
    - C. With multiple node pools
    - D. With a ReplicaSet

19. You are attempting to execute deployment commands on a Kubernetes cluster but they are having no effect. What component could be the problem?
    - A. **The Kubernetes API**
    - B. A StatefulSet
    - C. Cloud SDK `gcloud` commands
    - D. ReplicaSet

20. Pods are terminated due to resource starvation and new pods with different IP addresses are created. Clients still connect successfully. What Kubernetes component makes this possible?
    - A. **Services**
    - B. ReplicaSet
    - C. Alerts
    - D. StatefulSet
