# Chapter 4: Designing Compute Systems

---

**THE PROFESSIONAL CLOUD ARCHITECT CERTIFICATION EXAM OBJECTIVES COVERED IN THIS CHAPTER INCLUDE THE FOLLOWING:**

- **1.3 Designing network, storage, and compute resources**
- **2.3 Configuring compute systems**

---

Google Cloud Platform offers several kinds of compute resources with varying levels of controls, features, and management support. This chapter covers the foundations of designing compute systems across these services:

- Compute Engine
- App Engine
- Cloud Functions
- Cloud Run
- Kubernetes Engine
- Anthos

It also covers data pipeline and workflow orchestration services (Cloud Dataflow, Cloud Dataproc, Cloud Workflows, Cloud Data Fusion, Cloud Composer), infrastructure provisioning via IaC, and additional design issues such as managing state, data flows, and monitoring.

---

## Compute Services and Use Cases

Key drivers for using public clouds include:

- Basic virtual machines (IaaS via Compute Engine)
- Serverless PaaS environments (App Engine)
- Event-driven small functions without server management (Cloud Functions)
- Container orchestration at scale (Kubernetes Engine / GKE)
- Multicloud application management (Anthos)
- Scalable, performant data pipelines for AI/ML workloads

For the exam, know the features and use cases for each compute service. Expect questions asking you to choose the correct compute option for given scenarios.

---

### Compute Engine

**Compute Engine** is Google's **infrastructure-as-a-service (IaaS)** offering. The core functionality is **virtual machines (VMs)**, also called **instances**.

#### Specifying a Virtual Machine

When creating a VM, you specify machine type, availability status, and enhanced security controls.

##### Machine Types and Service Accounts

Instances are provisioned by specifying **machine types**, differentiated by number of CPUs and memory. Machine families include:

| Family | Machine Types |
|---|---|
| General-purpose | Shared-core, Standard, High Memory, High CPU |
| Compute-optimized | Standard |
| Memory-optimized | Mega Memory, Ultra Memory |
| GPU | Characterized by type and number of GPUs |

Users can also specify **custom machine types** (vCPUs, memory, CPU platform, GPUs). Options vary by region.

**Boot disk types:**

| Disk Type | Use Case |
|---|---|
| Standard Persistent Disk | Large data processing workloads using sequential I/Os |
| Balanced Persistent Disk | General-purpose; same max IOPS as SSD but lower IOPS per GB |
| SSD Persistent Disk | Low-latency, high IOPS; databases requiring single-digit ms latencies |
| Extreme Persistent Disk | High-performance apps (e.g., SAP HANA); user-configurable IOPS |

When deploying a container, you can specify a restart policy (Always, Never, On Failure) and whether the container runs as privileged. Privileged containers have root-equivalent permissions on the host.

Data is **encrypted automatically**. Options:
- Google managed keys (default)
- **Cloud Key Management Service** (customer-managed keys stored in GCP)
- Customer-supplied keys (stored and managed outside GCP)

A **service account** is an identity associated with a VM that allows processes on the VM to perform actions (e.g., write to Cloud Storage) without requiring a user.

##### Sole-Tenant VMs

**Sole tenancy** ensures your VMs run only on physical servers with VMs from the **same project**. Uses:
- **Node affinity labels** to group nodes and schedule VMs on specific nodes
- Useful for **bring your own license (BYOL)** based on per-core or per-processor pricing
- **CPU overcommit** can be enabled to share spare CPU cycles across instances; useful for workloads that under-utilize CPU and can tolerate performance fluctuations

##### Preemptible Virtual Machines and Spot VMs

| Feature | Preemptible VMs | Spot VMs |
|---|---|---|
| Discount | 60%–91% off standard VMs | Similar pricing model |
| Max run time | 24 hours | No automatic 24-hour limit |
| Shutdown notice | 30 seconds | 30 seconds |
| Live migration | No | No |
| Auto-restart on maintenance | No | No |
| Covered by Compute Engine SLA | No | No |
| Status | GA | Pre-GA at time of writing |

##### Shielded VMs

**Shielded VMs** provide enhanced security controls:

| Feature | Description |
|---|---|
| **Secure Boot** | Runs only software verified by digital signatures using UEFI firmware; boot fails if authentication fails |
| **vTPM (Virtual Trusted Platform Module)** | Stores keys/secrets; enables Measured Boot to create an integrity policy baseline for detecting boot differences |
| **Integrity Monitoring** | Compares boot measurements to the trusted baseline; logs events including secrets store clearing, boot sequence checks, baseline policy updates |

##### Confidential VMs

**Confidential VMs** encrypt **data in use** (complementing encryption of data in transit and at rest). They run on **AMD EPYC™ processors** using **Secure Encrypted Virtualization**, encrypting all memory. Each Confidential VM has its own encryption key. Enable when creating a VM.

##### Recommender

Google's **Recommender service** uses machine learning models to provide insights on saving costs, improving security, or optimizing resources. Recommenders for Compute Engine include:

- Committed use discount recommender
- Idle custom image recommender
- Idle IP address recommender
- Idle persistent disk recommender
- Idle VM recommender

#### Instance Groups

**Instance groups** are clusters of VMs managed as a single unit.

| Type | Description |
|---|---|
| **Managed Instance Groups (MIGs)** | Identically configured instances using an instance template; recommended for new configurations |
| **Unmanaged Instance Groups** | Groups of non-identical VMs; used only for preexisting cluster configurations for load balancing; not recommended for new setups |

An **instance template** defines machine type, disk image or container image, network settings, and other VM properties. Instance templates are **global resources**.

**MIG advantages:**
- Maintain minimum number of instances; failed instances are automatically replaced
- Autohealing via application health checks
- Distribution across zones for zonal failure resiliency
- Load balancing across instances
- Autoscaling (add/remove instances based on workload)
- Auto-updates:
  - **Rolling updates**: updates a minimal number of instances at a time until all are updated
  - **Canary updates**: run two versions of instance templates to test new version before full rollout

MIGs can be:
- **Zonal MIGs**: instances in a single zone
- **Regional MIGs**: instances across multiple zones in a single region

MIGs support both **stateless** (e.g., website front ends, bulk file processing) and **stateful** (e.g., databases, long-running batch jobs) workloads. Stateful MIGs preserve instance name, persistent disks, and metadata on restart/re-creation.

#### Compute Engine Use Cases

- Full control over OS, enhanced security, attached storage configuration
- Stateful applications (databases) with configurable persistent storage
- Shielded VMs and sole tenancy for high-security environments
- BYOL licensing based on per-core/per-processor pricing (use sole tenancy)
- Container-based deployments (uses container-optimized OS)

---

### App Engine

**App Engine** is a **serverless PaaS** compute offering. Users provide application code; servers are fully managed. Two forms: **App Engine Standard** and **App Engine Flexible**.

#### App Engine Standard

A PaaS product for running applications in a **serverless environment**. Supported language-specific runtimes:

- Go
- Java
- PHP
- Node.js
- Python
- Ruby

**Runtime generations:**

| Generation | Languages | Default Instance Class | Max Memory | Max CPU |
|---|---|---|---|---|
| Second-generation | Python 3, Java 11, Node.js, PHP 7, Ruby, Go 1.12+ | F1 | 2048 MB | 4.8 GHz |
| First-generation (legacy) | Python 2.7, Java 8, PHP 5.5 | Varies | Varies | Varies |

Instance class can be changed via the `instance:class` setting in `app.yaml`.

> ![note](../images/note_24.png) App Engine–supported languages and features may change. See the Google Cloud App Engine documentation for the most up-to-date list.

#### App Engine Flexible

Allows customization of runtime environments using **Dockerfiles**. Default supported languages:

- Go
- Java 8
- .NET
- Node.js
- PHP 5/7
- Python 2.7 and Python 3.6
- Ruby

##### Custom Runtimes

App Engine Flexible instances are based on **Compute Engine VMs**, enabling SSH for debugging and deployment of custom Docker containers. You can specify CPU and memory configurations. Additional features beyond Compute Engine:

- Health checks and autohealing
- Automatic OS updates
- Automatic colocating of a project's VM instances for performance
- Weekly maintenance (restarts and updates)
- Root access capability

#### App Engine Use Cases

| Criterion | App Engine Standard | App Engine Flexible |
|---|---|---|
| Startup time | Seconds | Minutes |
| Language | Restricted to supported runtimes | Any (via Docker container) |
| Best for | Rapid scale-up/down, supported languages | Microservices, custom code, unsupported libraries |
| SSH access | Not supported | Disabled by default (can be enabled) |
| Container builds | N/A | Built using Cloud Build service |

**Key differences between App Engine Flexible and Compute Engine containers:**
- App Engine Flexible containers are restarted once per week
- SSH access is disabled by default in App Engine Flexible (enabled by default in Compute Engine)
- App Engine Flexible images are built using **Cloud Build**
- Geographic location of App Engine Flexible instances is determined by project settings; all instances are colocated for performance

App Engine resources are **regional**; GCP deploys redundantly across all zones in a region.

**Additional App Engine services:**
- **App Engine Cron Service**: schedules tasks to run at regular times or intervals
- **Task Queues**: supports asynchronous/background operations using push or pull model; for pub/sub messaging, use **Cloud Pub/Sub** instead

---

### Cloud Functions

**Cloud Functions** is a **serverless compute service** suited for **event-driven processing**. Code executes in response to events within GCP.

Supported runtimes: Node.js, Python 3, Go, Java 11, .NET Core, Ruby, PHP.

Incoming requests are assigned to an instance (existing or new). Each instance handles **one request at a time**. You can configure a maximum number of concurrent instances.

#### Events, Triggers, and Functions

Three components: **events**, **triggers**, and **functions**.

**Supported event sources and actions:**

| Event Source | Actions/Events |
|---|---|
| Cloud Storage | Upload, delete, archive |
| Cloud Pub/Sub | Message publishing |
| HTTP | GET, POST, PUT, DELETE, OPTIONS |
| Cloud Firestore | Document create, update, delete, write |
| Firebase | Database triggers, remote config triggers, authentication triggers |
| Cloud Logging | Messages forwarded to Cloud Pub/Sub, then trigger a Cloud Function |

- A **trigger** is a specification of how to respond to an event; triggers have associated functions.
- **HTTP functions**: guaranteed to execute **at most once**
- **Other event types**: guaranteed to execute **at least once**
- Cloud Functions should be **idempotent** (same input always produces same result regardless of execution count)

#### Cloud Functions Use Cases

Cloud Functions are used for event-driven processing. Example use cases:

- Image uploaded to Cloud Storage → verify file type, convert to preferred format if needed
- New code version pushed to a repository → send notification to watching developers via webhook
- User initiates long-running mobile operation → write to Cloud Pub/Sub → notify user of expected duration
- Background process completes → write to Cloud Pub/Sub → notify initiator
- DBA authenticates to Firebase → write to audit log → notify all other admins

Cloud Functions complement the **App Engine Cron Service** (scheduled execution) by providing event-driven execution without requiring a continuously running service.

---

### Cloud Run

Cloud Run is a managed service for running **stateless containers**. Available as a managed service or within Anthos.

| Feature | Detail |
|---|---|
| Language restriction | None (unlike App Engine Standard) |
| Default max container instances | 1,000 |
| Default concurrent requests per instance | 80 (configurable up to 1,000) |
| Access control | Unauthorized access allowed, or use Identity-Aware Proxy (IAP) |
| Regional availability | Yes; replicated across multiple zones |
| Integration | Cloud Code (version control), Cloud Build (continuous deployment) |

A **service** is the main computing abstraction; it can have multiple **revisions** (specific container image + configuration). Cloud Run **autoscales** instances based on load.

- Unlike Cloud Functions, Cloud Run serves **multiple concurrent requests** per instance (up to 80 by default, up to 1,000)
- Set concurrency to 1 for single-threaded workloads
- Configure a **minimum of 1 instance** to avoid cold starts
- Use **Google managed base images** (regularly updated) and enable the **Container Registry image vulnerability scanner** to improve security

---

### Kubernetes Engine

**Google Kubernetes Engine (GKE)** is a managed service providing **Kubernetes cluster management** and **container orchestration**. GKE allocates cluster resources, determines where to run containers, performs health checks, and manages VM lifecycles using Compute Engine instance groups. Kubernetes is often abbreviated **K8s**.

Kubernetes provides declarative configuration to define the desired state of clusters and automates returning systems to that desired state. Key services:

- Service discovery
- Load balancing
- Storage allocation
- Automated rollouts and rollbacks
- Container placement to optimize resource use
- Self-healing (automated detection and correction)
- Configuration management
- Secrets management

Kubernetes is open source and can run in Google Cloud, on-premises, and in other clouds.

#### Kubernetes Cluster Architecture

##### Kubernetes Clusters from an Infrastructure Perspective

A Kubernetes cluster has two types of instances: **cluster masters** and **nodes**.

![Kubernetes clusters have a set of worker nodes that are managed by a control plane.](../images/c04f001.png)

**FIGURE 4.1** Kubernetes clusters have a set of worker nodes that are managed by a control plane.

**Cluster Master** (Control Plane) components:

| Component | Role |
|---|---|
| Controller Manager | Manages Kubernetes abstract components (deployments, replica sets) |
| API Server | Handles calls from applications and intercluster interactions |
| Scheduler | Determines where to run pods |
| etcd | Distributed key-value store for cluster state |

**Nodes:**
- Execute workloads
- Communicate with cluster master via **kubelet** agent
- **Kube-proxy**: network proxy on each node managing network communication rules inside and outside the cluster

**Container runtimes** supported: Docker (deprecated), **containerd**, CRI-O, and any runtime implementing the Kubernetes Container Runtime Interface (CRI).

##### Kubernetes Clusters from a Workload and Kubernetes Abstraction Perspective

Key Kubernetes abstractions:

| Abstraction | Description |
|---|---|
| **Pods** | Smallest computation unit; contains one or more containers; ephemeral; deployed in groups/replicas |
| **Services** | Stable API endpoint and IP address; tracks associated pods; provides service discovery |
| **ReplicaSets** | Controller managing the number of pods running for a deployment |
| **Deployments** | Controller consisting of pods running the same version of an app; uses pod specifications |
| **PersistentVolumes** | Persistent storage allocated for use by pods; decouples storage from ephemeral pods |
| **PersistentVolumeClaim** | Logical link connecting a pod to persistent storage |
| **StatefulSets** | Like a deployment but for stateful applications; assigns unique identifiers to pods; keeps clients paired with specific pods |
| **Ingress** | Object controlling external access to services; requires an Ingress Controller |
| **Node pools** | Sets of nodes with the same configuration and common node label |

**Node pools** (see Figure 4.2):
- Kubernetes creates a **default node pool** when a cluster is created
- Custom node pools can be created for particular workloads
- **nodeSelector** in pod config specifies a node label for scheduling
- **Node affinity**: tries to schedule a pod on a node meeting specified constraints but will use another node if needed

![Pods are deployed on nodes, which may be grouped into multiple node pools within a cluster.](../images/c04f002.png)

**FIGURE 4.2** Pods are deployed on nodes, which may be grouped into multiple node pools within a cluster.

#### Kubernetes Engine Types of Clusters

| Mode | Description | Cluster Type | Billing |
|---|---|---|---|
| **Standard** | Maximum flexibility and control over configuration and infrastructure | Zonal or Regional | Per node provisioned |
| **Autopilot** | Preconfigured, provisioned, and managed cluster; GKE manages nodes and node pools | Always Regional (VPC-native) | Per CPU, memory, and storage used by running pods |

**Standard mode cluster types:**

| Type | Description |
|---|---|
| Single-zone cluster | Control plane and nodes in the same zone |
| Multizonal cluster | Single control plane in one zone; nodes in multiple zones |
| Regional cluster | Multiple control plane replicas across multiple zones; node pools replicated across 3 zones by default |

**Private clusters**: nodes have only internal IP addresses, isolating nodes from the internet by default.

#### Kubernetes Networking

Three kinds of IP addresses in Kubernetes:

| Type | Description | Assigned From |
|---|---|---|
| **ClusterIP** | Fixed IP address assigned to a service | VPC |
| **Pod IP** | Ephemeral IP address assigned to a pod | Shared pool across the cluster |
| **Node IP** | IP address assigned to a node | Cluster's VPC network |

![Kubernetes uses multiple types of IP addresses for different purposes.](../images/c04f003.png)

**FIGURE 4.3** Kubernetes uses multiple types of IP addresses for different purposes.

##### Service Networking

By default, pods do not expose external IP addresses; rely on **kube-proxy**.

**ServiceTypes:**

| ServiceType | Access | Description |
|---|---|---|
| **ClusterIP** (default) | Internal only | Exposes service on internal IP; reachable only within the cluster |
| **NodePort** | External (via node IP + port) | Exposes service on node's IP at a static NodePort |
| **LoadBalancer** | External (via cloud load balancer) | Auto-creates NodePort and ClusterIP; cloud load balancer routes to them |
| **ExternalName** | Via DNS name | Uses DNS to make a service reachable |

##### Load Balancing in Kubernetes Engine

| Load Balancer Type | Use Case |
|---|---|
| **External load balancer** | Service reachable from outside cluster and VPC; GKE provisions a network LB and configures firewall rules |
| **Internal load balancer** | Service reachable within the cluster; uses VPC subnet IP address |
| **Container-native load balancing** | Uses network endpoint groups (NEGs); endpoints = IP address + port (pod + container port) |
| **HTTP(S) load balancer (Ingress)** | HTTP(S) traffic from outside VPC; maps URLs and hostnames to services |

Additional network security options:
- **Network policies**: pod-level firewall rules based on labels, IP address ranges, port numbers
- **loadBalancerSourceRanges**: restricts external load balancer access
- **Cloud Armor** and **Identity-Aware Proxy**: limit access to HTTP(S) load balancers

#### Kubernetes Engine Use Cases

| Scenario | Recommended Option |
|---|---|
| Minimize system administration overhead for containers | App Engine Flexible |
| Stateless containers without Kubernetes features | Cloud Run |
| Full control over platform configuration | Kubernetes Engine (Standard mode) |
| Kubernetes features with minimal cluster/infrastructure management | Kubernetes Engine (Autopilot mode) |

---

## Anthos

**Anthos** is an application management platform building on Kubernetes for **hybrid and multicloud** implementations. It extends the declarative model to manage a **fleet** of clusters across GCP, on-premises, and other clouds. Management includes policy enforcement, service management, cluster management, and infrastructure management.

### Overview of Anthos

- **Anthos Clusters** extend GKE for hybrid and multicloud environments; provide services to create, scale, and upgrade conformant Kubernetes clusters
- Multiple clusters managed as a group called a **fleet**
- Connectivity via VPNs, Dedicated Interconnects, and Partner Interconnects
- Configuration stored in **Git repositories** using Kubernetes abstractions (namespaces, labels, annotations)
- **Migrate for Anthos for GKE**: service for orchestrating migrations using Kubernetes and Anthos

**Key benefits:**
- Centralized management of configuration as code
- Ability to roll back deployments with Git
- Single view of cluster infrastructure and applications
- Centralized and auditable workflows
- Instrumentation of code using Anthos Service Mesh
- Anthos Service Mesh authorization and routing

### Anthos Service Mesh

A **service mesh** provides a common framework for services to communicate, handling monitoring, networking, and authentication on behalf of services. **Anthos Service Mesh** is a managed service based on **Istio** (open source).

**Architecture:**
- **Control plane**: configures and manages communications between services; provides configuration to sidecar proxies
- **Sidecar**: auxiliary service running with a workload container in a pod (e.g., Envoy proxy)
- **Data plane**: manages communications between workload services

**Functionality provided:**
- Traffic flow control between services, including layer 7 (application layer) using Istio-compatible custom resources
- Collecting service metrics and logs for Cloud Operations ingestion
- Preconfigured service dashboards
- Authenticating services with **mutual TLS (mTLS)** certificates
- Encrypting control plane communications

**Deployment options:**

| Option | Description |
|---|---|
| In-cluster control plane | Istiod runs in control plane; manages security, traffic, configuration, service discovery |
| Managed Anthos Service Mesh | Google manages control plane including upgrades, scaling, and security |
| Compute Engine VMs in service mesh | Manage and secure MIGs and GKE Clusters in the same mesh |

### Anthos Multi Cluster Ingress

- **Controller** hosted on Google Cloud enabling **load balancing across clusters**, including multiregional clusters
- Provides a **single consistent virtual IP** for applications regardless of deployment location
- Supports **high availability** (multiple regions and clusters)
- Enables **cluster migration during upgrades**, reducing downtime
- **Config Cluster**: the GKE Cluster in GCP configured with the Multi Cluster Ingress resource (runs only on Google Cloud Deployment)

### Anthos Deployment Options

**Anthos Service Mesh** and **Anthos Config Management** are included in all deployment options.

**Anthos Service Mesh features (all deployments):**
- Traffic control with rules for HTTP(S), gRPC, and TCP traffic
- Metrics, logs, and traces for all HTTP(S) traffic (including ingress/egress)
- Service-level security with authentication and authorization
- Support for A/B testing and canary rollouts

**Anthos Config Management:** controls cluster configuration via specifications applied to cluster components; includes **Policy Controller** for enforcing business logic rules on Kubernetes API requests.

**Deployment options:**

| Deployment | Key Additional Components |
|---|---|
| **Google Cloud Deployment** (most comprehensive) | Core GKE: node auto provisioning, vertical pod autoscaling, Shielded GKE Nodes, Workload Identity Federation, GKE Sandbox; also Anthos Config Management, Anthos Cloud Run, Multi Cluster Ingress, binary authorization |
| **On-Premises Deployment** | Anthos Config Management, Anthos UI & Dashboard, Network plugin, CSI and hybrid storage, Authentication Plugin for Anthos, Prometheus and Grafana (on VMware), Bundled layer 4 load balancers (on VMware) |
| **AWS Deployment** | Anthos Config Management, Anthos UI & Dashboard, Network Plugin, CSI and hybrid storage, Authentication Plugin for Anthos, AWS load balancers |
| **Attached Clusters Deployment** (minimal) | Anthos Config Management, Anthos UI & Dashboard, Anthos Service Mesh |

---

## AI and Machine Learning Services

### Vertex AI

**Vertex AI** is the unified ML platform combining former **AutoML** and **AI Platform** services. Provides a single API and UI.

**Components:**

| Component | Description |
|---|---|
| Training | AutoML automated training and AI custom training |
| Model Deployment | Support for ML model deployment |
| Data Labeling | Request human assistance in labeling training examples for supervised learning |
| Feature Store | Repository for managing and sharing ML features |
| Workbench | Jupyter notebook-based development environment |

Also includes specially configured deep learning VM images and containers.

### Cloud TPU

**Cloud TPU** provides access to **Tensor Processing Units (TPUs)**: custom-designed ASICs built by Google for deep learning model training.

| Version | Performance |
|---|---|
| TPU v2 (single) | 180 teraflops |
| TPU v3 (single) | 420 teraflops |
| TPU v2 Pod | 11.5 petaflops |
| TPU v3 Pod | 100+ petaflops |

- Clusters of TPUs are called **pods**
- Accessible from Compute Engine VMs (running deep learning images) or GKE
- **Preemptible TPUs** available at **70% off** standard pricing

---

## Data Flows and Pipelines

Applications often require multiple steps of processing across multiple services. Workflows can involve monolithic systems or microservices.

**Example: Health insurance claim workflow**
1. Verify patient and provider data (eligibility application)
2. Assign value to medical procedures (benefits assignment application)
3. Review for potential fraud (compliance review system)
4. Send to data warehouse (business analysts)
5. Issue payment to provider (payment processing system)
6. Send explanation of benefits to patient (patient services application)

**Example: Online purchase workflow**
1. Check inventory
2. Authorize payment
3. Issue fulfillment order
4. Send transaction data to data warehouse
5. Send confirmation message to customer

When designing workflows, consider how data will flow from one service to the next.

### Cloud Pub/Sub Pipelines

Cloud Pub/Sub buffers data between services, supporting **push** and **pull** subscriptions.

| Subscription Model | Description | Best For |
|---|---|---|
| **Push** | Message data sent by HTTP POST to a push endpoint URL | Single endpoint processing messages from multiple topics; App Engine Standard or Cloud Functions (billed only when in use) |
| **Pull** | Service reads messages from the topic | Large volume data; efficiency is top concern |

Cloud Pub/Sub works well for transmitting or buffering data between services. For processing/transforming data, use **Cloud Dataflow**.

### Cloud Dataflow Pipelines

**Cloud Dataflow** is an implementation of the **Apache Beam** stream processing framework.

- Fully managed (no provisioning or managing instances)
- Operates in both **stream** and **batch** mode without code changes
- Supported languages: **Java, Python, SQL**
- Often used between data ingestion services (Cloud Pub/Sub, Cloud IoT Core) and storage/analysis services (Cloud Bigtable, BigQuery, Cloud Machine Learning)

### Cloud Dataproc

**Cloud Dataproc** is a managed **Spark and Hadoop** service for large-scale batch processing and machine learning (Spark also supports stream processing).

- Creates clusters quickly; often used **ephemerally**
- Uses Compute Engine VMs; supports **preemptible instances** as worker nodes
- Supports **Workflows Templates** (directed acyclic graphs)
- Built-in integration with BigQuery, Bigtable, Cloud Storage, Cloud Logging, Cloud Monitoring
- Recommended when **migrating on-premises Spark/Hadoop clusters** to minimize management overhead

### Cloud Workflows

**Cloud Workflows** orchestrates HTTP-based API services and serverless workflows, integrating with Cloud Functions, Cloud Run, and other Google Cloud APIs.

- Workflows defined as a series of steps in **YAML or JSON**
- Requires **authenticated call** to execute
- Best for coordinating a series of API calls
- For large data volumes or complex job sequences, use Cloud Dataflow, Cloud Dataproc, Cloud Data Fusion, or Cloud Composer

### Cloud Data Fusion

**Cloud Data Fusion** is a managed service based on the **CDAP data analytics platform** for developing **ETL** (extract, transform, load) and **ELT** (extract, load, transform) pipelines **without coding**.

- Code-free, **drag-and-drop** development tool
- More than **160 prebuilt connectors and transformations**

**Editions:**

| Edition | Features |
|---|---|
| Developer | Lowest cost; most limited features |
| Basic | Visual design, transformations, SDK |
| Enterprise | Basic features + streaming pipelines, metadata repository integration, high availability, triggers and scheduling |

### Cloud Composer

**Cloud Composer** is a managed service for **Apache Airflow**, a workflow orchestration system using **directed acyclic graphs (DAGs)**.

- Workflows = collections of tasks with dependencies
- DAGs defined in **Python scripts**, stored in Cloud Storage

**Apache Airflow building blocks:**

| Component | Description |
|---|---|
| Tasks | Unit of work; represented as a node in a graph |
| Operators | Define how tasks run; types: action, transfer, sensor |
| Hooks | Interfaces to third-party services |
| Plugins | Hook + operator combination |

**Logging:** Workflow logs are associated with a single DAG task. View in the Airflow web interface, or in the logs folder of the associated Cloud Storage bucket. Streaming logs available in Logs Viewer (scheduler, web server, workers).

---

## Compute System Provisioning

GCP provides:
- **Interactive console** and **command-line utility** for managing resources
- **Deployment Manager**: declarative IaC templates that describe what should be deployed; sets of resource templates grouped into **deployments**
- **Terraform**: open source IaC using **HashiCorp Configuration Language (HCL)**; cloud agnostic; generates execution plans to bring infrastructure to desired state

Using IaC is a best practice: enables rapid environment reproduction, code reviews, version control, and other software engineering practices.

---

## Additional Design Issues

### Managing State in Distributed Systems

#### Persistent Assignment of Clients to Instances

Stateful systems keep data about client processes and connections. Example: IoT sensors sending metrics every minute; 10 minutes of buffered data represents state.

**Assignment strategy using modulo division:**

```
Sensor ID 80 mod 8 = 0  → Instance 0
Sensor ID 83 mod 8 = 3  → Instance 3
Sensor ID 89 mod 8 = 1  → Instance 1
Sensor ID 93 mod 8 = 5  → Instance 5
```

(Divisor = number of instances in the cluster)

For aggregate-level assignments (e.g., by machine ID instead of sensor ID), be careful of uneven workload distribution if groups have varying sizes.

Horizontally scalable systems (Compute Engine MIGs, GKE clusters) can add/remove compute resources easily. When instances store state, work must be distributed at the application level—or state must be moved to a common data store.

#### Persistent State and Volatile Instances

Assigning a client to a server ensures state is available but doesn't solve **instance volatility** (instances shutting down unexpectedly). Options for separating state storage from volatile instances:

##### In-Memory Cache

**Cloud Memorystore** is a managed Redis and memcached service providing low-latency access to data.

- Data can be **persisted via snapshots**
- On cache failure, re-create from latest snapshot (data since last snapshot is lost)
- Mitigation: keep data in queue with **TTL** longer than snapshot interval
  - Example: snapshots every minute → set **Time to Live (TTL)** on messages to 2 minutes
- **Cloud Pub/Sub**: messages removed after delivery is acknowledged; redelivered if not acknowledged within configured time

##### Databases

- Advantages: durable storage; no additional steps for snapshots or queue management
- Potential disadvantage: higher latency than cache
- Mitigation: use cache to store frequently queried database results
- GCP offers managed databases: **Cloud SQL**, **Cloud Datastore** (reduce operational burden)

### Synchronous and Asynchronous Operations

| Operation Type | Description | Example Use Case |
|---|---|---|
| **Synchronous** | Waits for operation to complete before returning | Credit card authorization |
| **Asynchronous** | Does not wait for operation to complete | Fulfillment order creation after payment |

**Implementing asynchronous processing with message queues:**
- One application writes to a queue; another reads from it
- Buffering decouples services with different scaling requirements
- Messages accumulate in the queue when the reading application cannot keep up
- Separates work that must be done immediately (respond to user) from work that can be done later (backend processing)

**Options for implementing workflows and pipelines:**
- Implement your own messaging system on a GCP compute service
- Deploy a third-party messaging service (e.g., **RabbitMQ**)
- Deploy a streaming log (e.g., **Apache Kafka**)
- Use GCP managed services: **Cloud Pub/Sub** and **Cloud Dataflow**

---

## Summary

GCP offers multiple compute services:

| Service | Type | Key Characteristic |
|---|---|---|
| **Compute Engine** | IaaS | Full VM control; most management responsibility |
| **App Engine Standard** | PaaS | Language-specific runtimes; serverless |
| **App Engine Flexible** | PaaS | Container-based; more flexibility; minutes to scale |
| **Cloud Run** | Managed containers | Stateless containers; managed service; rapid scaling |
| **Kubernetes Engine** | Managed Kubernetes | Container orchestration; cluster management |
| **Anthos** | Application orchestration | Fleet management across multiple clouds and on-premises |
| **Cloud Functions** | Serverless | Event-driven code execution |

Data pipeline and ML services: Cloud Pub/Sub, Cloud Dataflow, Cloud Dataproc, Cloud Data Fusion, Cloud Composer, Cloud Workflows, Vertex AI, Cloud TPU.

Key design considerations: managing state in distributed systems, data flows, monitoring, and alerting.

---

## Exam Essentials

- **Understand when to use different compute services.** Compute Engine (IaaS, greatest control, most management responsibility); App Engine Standard (PaaS, language-specific sandboxes); App Engine Flexible (PaaS, containers via Docker); Cloud Run (managed stateless containers); Kubernetes Engine (managed Kubernetes, microservices; Anthos for multicloud); Cloud Functions (event-driven, trigger-based execution).

- **Understand Compute Engine instances' optional features.** Variety of machine types, preemptibility, Shielded VMs, service accounts, managed instance groups with autoscaling and health checks.

- **Know the difference between App Engine Standard and App Engine Flexible.** Standard: language-specific runtimes. Flexible: containers (customizable runtime). Know the App Engine Cron Service and Task Queues.

- **Know the Kubernetes and Anthos architectures.** Differences between cluster master (controller manager, API server, scheduler, etcd) and nodes (workloads, kubelet, kube-proxy). Organizing abstractions: pods, services, ReplicaSets, deployments, PersistentVolumes, StatefulSets, Ingress (controls external access).

- **Know when to use specialized data pipeline and machine learning services.** Cloud Pub/Sub (messaging/buffering), Cloud Dataflow (Apache Beam stream/batch processing), Cloud Dataproc (managed Spark/Hadoop), Cloud Workflows (orchestrating API calls), Cloud Data Fusion (code-free ETL/ELT). Vertex AI: automated and custom ML model training.

---

## Review Questions

1. You are consulting for a client considering moving on-premises workloads to GCP. The workloads run on VMs with a specially hardened OS. Application administrators need root access. The client wants to minimize changes to the existing configuration. Which GCP compute service would you recommend?
   - A. **Compute Engine** ✓
   - B. Kubernetes Engine
   - C. App Engine Standard
   - D. App Engine Flexible

2. You have joined a startup that analyzes healthcare data and must comply with privacy regulations. A compliance consultant recommends controlling your own encryption keys while minimizing management overhead. What GCP service should the company use?
   - A. Use default encryption on Compute Engine instances.
   - B. **Use Google Cloud Key Management Service to store keys that you create and use them to encrypt storage used with Compute Engine instances.** ✓
   - C. Implement a trusted key store on premises, create keys yourself, and use them to encrypt storage.
   - D. Use an encryption algorithm that does not use keys.

3. A colleague complains that GCP VMs keep shutting down without shutdown commands and no instance runs more than 24 hours. What should you suggest they check?
   - A. Make sure that the Cloud Operations agent is installed.
   - B. Verify that sufficient persistent storage is attached.
   - C. **Make sure that the instance availability is not set to preemptible.** ✓
   - D. Ensure that an external IP address has been assigned.

4. Your company is working on a government contract requiring all VMs to have a virtual Trusted Platform Module. What Compute Engine configuration option would you enable?
   - A. Trusted Module Setting
   - B. **Shielded VMs** ✓
   - C. Preemptible VMs
   - D. Disable live migration

5. You are leading a lift-and-shift migration. Your company has load-balanced clusters using VMs that are not identically configured. You want to make as few changes as possible. What GCP feature would you use?
   - A. Managed instance groups
   - B. **Unmanaged instance groups** ✓
   - C. Flexible instance groups
   - D. Kubernetes clusters

6. Your startup has a stateless web app written in Python 3.7. You are not sure what load to expect and do not want to manage servers or containers. What GCP service would you use?
   - A. Compute Engine
   - B. **App Engine** ✓
   - C. Kubernetes Engine in Standard Mode
   - D. Cloud Dataproc

7. Users upload audio files to Cloud Storage for transcription. Transcription runs at midnight. Users complain about not being notified of file format problems until the next day. Your app can verify audio file quality in under 2 seconds. What change would you make?
   - A. Include more documentation about requirements.
   - B. **Use Cloud Functions to run the quality verification program when the file is uploaded. If there is a problem, notify the user immediately.** ✓
   - C. Create a Compute Engine instance with a cron job running every hour.
   - D. Use the App Engine Cron Service to run a cron job every hour.

8. You have a monolithic C++ application with a Dockerfile and container image. You want to deploy it with minimal maintenance effort. How would you deploy this application?
   - A. Create a Compute Engine instance, install Docker and Cloud Monitoring agent, and run the Docker image.
   - B. Create a Compute Engine instance; install the application, Ruby, and needed libraries directly.
   - C. **Use App Engine Flexible to run the container image.** ✓
   - D. Use App Engine Standard to run the container image.

9. How would you explain the difference between cluster master and nodes in a Kubernetes presentation?
   - A. **Cluster masters manage the cluster and run core services such as the controller manager, API server, scheduler, and etcd. Nodes run workload jobs.** ✓
   - B. The cluster manager is an endpoint for API calls. All services needed to maintain a cluster are run on nodes.
   - C. The cluster manager is an endpoint for API calls. All services are run on nodes; workloads run on a third kind of server (a runner).
   - D. Cluster masters manage the cluster and run core services. Nodes monitor the cluster master and restart it if it fails.

10. External services cannot access services running in a Kubernetes cluster. You suspect a controller may be down. Which type of controller would you check?
    - A. Pod
    - B. Deployment
    - C. **Ingress Controller** ✓
    - D. Service Controller

11. You are planning to run stateful applications in Kubernetes Engine. What should you use?
    - A. Pods
    - B. StatefulPods
    - C. **StatefulSets** ✓
    - D. PersistentStorageSet

12. Every time a database administrator logs into a Firebase database, you want a message sent to your mobile device. Which compute service would minimize your work?
    - A. Compute Engine
    - B. Kubernetes Engine
    - C. **Cloud Functions** ✓
    - D. Cloud Dataflow

13. Your team must deploy infrastructure for dev, test, staging, and production environments in us-west1 and likely two additional regions. What service supports an IaC approach?
    - A. Cloud Dataflow
    - B. **Deployment Manager** ✓
    - C. Identity and Access Manager
    - D. App Engine Flexible

14. An IoT startup collects streaming data from industrial sensors and evaluates it using a machine learning model. The data is buffered in a server for 10 minutes. Which statement is true?
    - A. **It is stateful.** ✓
    - B. It is stateless.
    - C. It may be stateful or stateless; there is not enough information.
    - D. It is neither stateful nor stateless.

15. Your team is designing a stream processing application for industrial sensor data. Someone suggests using Cloud Memorystore. What could that cache be used for?
    - A. A SQL database
    - B. **As a memory cache to store state data outside of instances** ✓
    - C. An extraction, transformation, and load service
    - D. A persistent object storage system

16. A distributed application underperforms during peak load. The first of three microservices sends more data than the second can process, causing the first to wait. What can be done to decouple the services?
    - A. Run the microservices on separate instances.
    - B. Run the microservices in a Kubernetes cluster.
    - C. **Write data from the first service to a Cloud Pub/Sub topic and have the second service read from the topic.** ✓
    - D. Scale both services together using MIGs.

17. A colleague suggests using the Apache Beam framework for a highly scalable workflow. Which Google Cloud service would you use?
    - A. Cloud Dataproc
    - B. **Cloud Dataflow** ✓
    - C. Cloud Dataprep
    - D. Cloud Memorystore

18. Your manager wants data on CPU and memory utilization of Compute Engine applications. What Google Cloud service would you use?
    - A. Cloud Dataprep
    - B. **Cloud Monitoring** ✓
    - C. Cloud Dataproc
    - D. Cloud Memorystore

19. You receive alerts that CPU utilization is high on Compute Engine instances running a custom C++ app. You currently add instances manually when alerts fire. What is the best option to avoid manual scaling?
    - A. Always run more servers than needed.
    - B. **Deploy the instances in a MIG and use autoscaling to add and remove instances as needed.** ✓
    - C. Run the application in App Engine Standard.
    - D. Whenever you receive an alert, add two instances instead of one.

20. A retailer has sales data streaming from stores into a Cloud Pub/Sub topic. Data needs to be transformed and aggregated before being written to BigQuery. Which service would you use?
    - A. Firebase
    - B. **Cloud Dataflow** ✓
    - C. Cloud Memorystore
    - D. Cloud Datastore

21. Auditors find that microservices deployed on Kubernetes clusters across GCP and on-premises don't comply with authentication security requirements. You want developers to deploy microservices without spending significant time on authentication mechanisms. What managed service would you use?
    - A. Kubernetes Services
    - B. **Anthos Service Mesh** ✓
    - C. Kubernetes Ingress
    - D. Anthos Config Management
