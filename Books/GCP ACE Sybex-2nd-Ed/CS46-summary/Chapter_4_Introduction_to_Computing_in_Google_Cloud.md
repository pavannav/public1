# Chapter 4: Introduction to Computing in Google Cloud

> **Exam Objective Covered:**
> - 2.2 Planning and configuring compute resources

---

This chapter covers each compute option available in Google Cloud, when to use them, and how preemptible VMs can reduce computing costs.

---

## Compute Engine

Compute Engine is the Google Cloud service that provides **Virtual Machines (VMs)**. A running VM is called an **instance**. You create and manage one or more instances using Compute Engine.

### Virtual Machine Images

- Instances run **images** — containing the operating system, libraries, and other code.
- **Public images** are provided by Google (Linux and Windows), open source projects, or third-party vendors.

**Available public OS images include:**

| OS Family | Examples |
|---|---|
| Linux | CentOS, Debian, Red Hat Enterprise Linux, SUSE Enterprise Linux Server, Ubuntu |
| Google-specific | Container-Optimized OS |
| Windows | Windows Server |

- If no public image meets your needs, you can create a **custom image** from a boot disk or another image.

![A subset of operating system images available in Compute Engine](../images/c04f001.png)

**Figure 4.1** — A subset of operating system images available in Compute Engine

**Console path to create a VM:** Compute Engine → VM Instances → Create Instance

![Creating a VM in Compute Engine](../images/c04f002.png)

**Figure 4.2** — Creating a VM in Compute Engine

**Part 1 — Create Instance page (instance configuration):**

![Part 1 of creating an instance in Compute Engine](../images/c04f003.png)

**Figure 4.3** — Instance name, machine configuration, GPU, and other features

**Part 2 — Additional features:**

- **Confidential VM service** — encrypts data **in memory** (for high-security applications).
- **Boot disk** — specify name, size, image, and type.
- **Service account** — identity assigned to the VM for performing Google Cloud operations.
- **Access scopes** — legacy access control mechanism (IAM is preferred). By default: read from storage, write to monitoring and logging.
- **HTTP/HTTPS traffic** — allow or deny at instance level.

![Part 2 of creating an instance in Compute Engine](../images/c04f004.png)

**Figure 4.4** — Confidential VM, boot disk, service account, access scopes

**Networking configuration:**

- Network tags, hostname, network performance configurations.
- Additional network interfaces (one created by default).

![Configuring network properties in a Compute Engine instance](../images/c04f005.png)

**Figure 4.5** — Configuring network properties in a Compute Engine instance

**Disk configuration:**

- Add additional disks beyond the boot disk.
- Configure: name, description, disk type, size, backup schedule, encryption.
- Attachment modes: **read/write** or **read-only**.
- By default, disks are **retained** when an instance is deleted (can be changed).

**Encryption key options for persistent storage:**

| Option | Who Creates Keys | Who Manages Keys |
|---|---|---|
| **Google-managed** | Google | Google |
| **Customer-managed** | Customer | Google (via Cloud KMS) |
| **Customer-supplied** | Customer | Customer (outside Google Cloud) |

> All data in Google Cloud is **encrypted at rest** by default. There is no option to store data without encryption.

![Configuring disks in a Compute Engine instance](../images/c04f006.png)

**Figure 4.6** — Configuring disks in a Compute Engine instance

**Security configuration:**

| Feature | Purpose |
|---|---|
| **Secure Boot** | Protects against boot-level and kernel-level malware (e.g., rootkits) |
| **vTPM** (Virtual Trusted Platform Module) | Validates boot integrity; provides key generation and protection |
| **Integrity Monitoring** | Verifies runtime integrity of the VM (requires vTPM enabled) |
| **IAM-based OS Login** | Restricts login to users with `Compute OS Login` or `Compute OS Admin Login` roles |
| **Block project-wide SSH keys** | Prevents project-level SSH keys from granting access to this VM |

![Configuring security in a Compute Engine instance](../images/c04f007.png)

**Figure 4.7** — Configuring security in a Compute Engine instance

**Management features:**

- Description, block deletion, instance reservations, startup automation scripts.
- **Availability settings:** preemptible/spot, live migration during maintenance, auto-restart on hardware failure.

![Configuring management features in a Compute Engine instance](../images/c04f008.png)

**Figure 4.8** — Configuring management features in a Compute Engine instance

**Sole Tenancy:**

- Ensures VMs from **other projects do not run on the same physical server**.
- Only VMs from your project with matching **node affinity labels** share the server.
- Option to **overcommit CPUs** — useful when VMs have non-overlapping peak loads (e.g., morning vs. evening peaks).

![Configuring Sole Tenancy features in a Compute Engine instance](../images/c04f009.png)

**Figure 4.9** — Configuring Sole Tenancy features

**Instance Templates:**

- A **reusable description** of a VM configuration.
- Created like a VM but produces a template instead of an actual VM.
- Use the template to create new instances without re-specifying all parameters.

**Machine Images:**

- Create a machine image from an existing VM (name, description, source VM, storage location, encryption key management).
- Use the image to create new identical instances.

![Creating a machine image](../images/c04f010.png)

**Figure 4.10** — Creating a machine image from an existing VM

---

### Virtual Machines Are Contained in Projects

- Every VM instance belongs to a **project**.
- Projects are the lowest-level grouping structure in the resource hierarchy.
- The active project is shown at the top of the Google Cloud Console.

![The current project name or the option to select one is displayed in Google Cloud Console.](../images/c04f011.png)

**Figure 4.11** — Project selector in Google Cloud Console

![Choosing a project from existing projects in an account](../images/c04f012.png)

**Figure 4.12** — Choosing a project

---

### Virtual Machines Run in a Zone and Region

- **Zone** — a data center–like resource (may be one or more closely coupled data centers); a single failure domain.
- **Region** — a geographical location containing one or more zones.
- Zones within a region are connected by **low-latency, high-bandwidth** network links.

**Example region names:** `asia-east1`, `europe-west2`, `us-east4`

**Factors to consider when choosing a region/zone:**

| Factor | Consideration |
|---|---|
| **Cost** | Varies between regions |
| **Data locality** | Some regulations require data to stay in specific geographies (e.g., EU citizen data in EU) |
| **High availability** | Spread instances across zones/regions to survive outages |
| **Latency** | Keep instances close to users geographically |
| **Hardware availability** | Specific processor types may only be available in certain regions |
| **Carbon intensity** | Power generation carbon footprint varies by region |

![Selecting a region in the Create VM form](../images/c04f013.png)

**Figure 4.13** — Selecting a region

![Once a region is selected, you can choose a zone within that region.](../images/c04f014.png)

**Figure 4.14** — Selecting a zone within the chosen region

---

### Users Need Privileges to Create Virtual Machines

Users can be associated with a project as:
- Individual users
- A Google group
- A Google Workspace domain
- A service account

**Predefined Compute Engine roles:**

| Role | Permissions |
|---|---|
| **Compute Admin** | Full control over all Compute Engine instances |
| **Compute Network Admin** | Create, modify, delete most networking resources; read-only on firewall rules and SSL certs; cannot create/alter instances |
| **Compute Security Admin** | Create, modify, delete SSL certificates and firewall rules |
| **Compute Viewer** | Get and list Compute Engine resources; cannot read data from resources |

- Roles granted at the **project level** apply to **all resources** in that project.
- Roles can also be attached directly to **individual resources** for fine-grained control (e.g., Alice manages VM-A, Bob manages VM-B).

---

### Preemptible Virtual Machines

- **Lower cost** — approximately **80% less** than standard VMs.
- Suitable for **fault-tolerant, interruptible workloads**: financial modeling, rendering, big data, continuous integration, web crawling.
- Provide a **30-second warning** before shutdown.
- Work well in combination with regular VMs (reliable base + cheap burst capacity).

**Preemptible VM vs. Spot VM:**

| Feature | Preemptible VM | Spot VM |
|---|---|---|
| Max runtime | 24 hours | No maximum |
| Can be shut down by Google | Yes (with 30-sec warning) | Yes (with 30-sec warning) |
| Pricing model | Same (~80% discount) | Same (~80% discount) |

#### Limitations of Preemptible Virtual Machines

| Limitation | Detail |
|---|---|
| May terminate at any time | No charge if terminated within 1 minute of starting |
| Will be terminated within 24 hours | (Preemptible only; not Spot VMs) |
| May not always be available | Availability varies by zone and region |
| Cannot migrate to a regular VM | |
| Cannot be set to automatically restart | |
| Not covered by any SLA | |

---

### Custom Machine Types

**Predefined machine type examples:**

| Machine Type | vCPUs | Memory |
|---|---|---|
| n2-standard-2 | 2 | 8 GB |
| n2-standard-32 | 32 | 128 GB |
| m2-megamem-416 | 416 | 5.75 TB |
| m2-ultramem-208 | 208 | 5.75 TB |

- Predefined types cover most use cases, but **custom machine types** let you optimize for cost and performance.
- Created in the console via: Create VM → Machine Type section → Customize.

**Custom machine type limits (examples):**

| Series | vCPU Range | Max Memory |
|---|---|---|
| N2 | 2–80 vCPUs | 640 GB |
| N2D | Up to 96 cores | 768 GB |

- Price is based on **number of vCPUs and memory allocated**.
- **Extend Memory** option available to increase memory relative to CPU count.

![Choosing a custom machine type from the Machine Type drop-down menu](../images/c04f015.png)

**Figure 4.15** — Selecting custom machine type

![Customizing a VM by adjusting the number of CPUs and the amount of memory](../images/c04f016.png)

**Figure 4.16** — Adjusting vCPUs and memory for a custom VM

---

### Use Cases for Compute Engine Virtual Machines

Use Compute Engine when you need **maximum control** over VM instances:

- Choose a specific image (including custom images).
- Install software packages or custom libraries.
- Fine-grained user permission control on the instance.
- Control SSL certificates and firewall rules.

> **Trade-off:** More control = more responsibility for configuration and management.

---

## App Engine

App Engine is a **PaaS compute service** — focus is on your **application**, not the underlying VMs.

- You specify basic resource requirements + application code; Google manages the rest.
- Applications are created within a **project**.
- Less control, less management overhead compared to Compute Engine.

> **Note:** App Engine is not explicitly listed in the Google Cloud ACE exam guide but is still available and widely used.

![When using App Engine, the focus is on applications, not infrastructure.](../images/c04f017.png)

**Figure 4.17** — App Engine: application-focused, not infrastructure-focused

---

### Structure of an App Engine Application

- Applications are composed of **services** (e.g., tax calculation, inventory update).
- Services have **versions** — multiple versions can run simultaneously.
- Each version runs on **instances** managed by App Engine.

![The structure of an App Engine application](../images/c04f018.png)

**Figure 4.18** — App Engine application structure: Application → Services → Versions → Instances

**Instance types:**

| Type | Description |
|---|---|
| **Dynamic instances** | Auto-added/removed based on load (autoscaling) |
| **Resident instances** | Manually added or removed by the administrator |

> Google Cloud allows setting **daily spending limits**, **budgets**, and **alerts** to manage variable instance costs.

---

### App Engine Standard and Flexible Environments

Both environments run code in **container instances** on Google-managed infrastructure.

#### App Engine Standard Environment

- Original App Engine environment; **language-specific preconfigured runtime**.
- Two generations:

**Supported Languages:**

| Generation | Languages |
|---|---|
| **First Generation** | Python 2.7, Java 8, PHP 5.5, Go 1.11 |
| **Second Generation** | Python 3, Java 11/17, Node.js, PHP 7/8, Ruby, Go 1.12+ |

**Differences between generations:**

| Feature | First Generation | Second Generation |
|---|---|---|
| Language extensions | Select set only | Any extension allowed |
| Network access | Restricted | Full network access |

**Scaling options in App Engine Standard:**

| Scaling Type | Behavior |
|---|---|
| **Basic scaling** | Starts a new instance only when existing ones can't handle requests; lowest cost but higher latency on cold start |
| **Automatic scaling** | Automatically creates instances as load increases |
| **Manual scaling** | User specifies the number of instances per service version |

> App Engine Standard can scale down to **zero instances** when there is no traffic — pay nothing when idle.

**Instance classes (resources per instance):**

| Class | Generation | Memory | CPU Limit |
|---|---|---|---|
| F1 (front end) | First | 128 MB | 600 MHz |
| B2 (back end) | First | 256 MB | 1.2 GHz |
| F1 (front end) | Second | 256 MB | 600 MHz |
| B2 (back end) | Second | 512 MB | 1.2 GHz |

- **Front-end classes (F):** scale automatically.
- **Back-end classes (B):** support manual and basic scaling.

> **Best practice:** For new projects, use **second-generation** standard instances. First-generation instances should only be used for existing applications designed for that platform.

#### App Engine Flexible Environment

- More control than Standard — customize runtime environments via **Docker containers**.
- Uses **Dockerfiles** to specify: base OS image, libraries, tools, package manager commands (`apt-get`, `yum`).
- Native support for: **Java, Python, Node.js, Ruby, PHP, .NET Core, Go**.

**App Engine Flexible vs. Kubernetes Engine:**

| Feature | App Engine Flexible | Kubernetes Engine |
|---|---|---|
| Container runtime | Docker containers | Docker containers |
| Cluster management | Fully managed by Google | You manage the cluster |
| Health monitoring | Google monitors and corrects | Cloud Monitoring + autoscaling by you |
| Best for | Small set of containerized services | Complex microservice clusters you control |

> **Key difference:** App Engine Flexible **always has at least one container running** — you are charged even with zero traffic.
> App Engine Standard can scale to **zero** — no charge when idle.

---

### Use Cases for App Engine

- Good when you have **little need to control the underlying OS or storage system**.
- Google manages: patching, monitoring, VMs, and containers.

**When to use App Engine Standard:**
- Application written in a supported language.
- Prefers minimum cost (scales to zero).
- Does not need OS-level packages or custom compiled software.

**When to use App Engine Flexible:**
- Application decomposable into containerized services.
- Needs third-party libraries, custom tools, or startup commands.
- Example: Django UI service + business logic service + batch processing service, each in its own container.

---

## Kubernetes Engine

- Kubernetes (K8s) is an **open source container orchestration tool** created by Google.
- **Kubernetes Engine** is Google Cloud's **managed Kubernetes service** — benefits of Kubernetes without administrative overhead.

### Kubernetes Functionality

Kubernetes Engine provides:

| Function | Description |
|---|---|
| **Load balancing** | Across Compute Engine VMs deployed in the cluster |
| **Automatic scaling** | Nodes (VMs) scaled automatically |
| **Automatic upgrades** | Cluster software updated as needed |
| **Node health monitoring and repair** | Detects and remediates node failures |
| **Logging** | Cluster and workload logging |
| **Node pools** | Collections of nodes all with the same configuration |

**GKE Standard vs. GKE Autopilot:**

| Mode | Billing | Node Management |
|---|---|---|
| **GKE Standard** | Pay per node | User configures and manages nodes |
| **GKE Autopilot** | Pay per pod | GKE manages configuration and infrastructure |

### Kubernetes Cluster Architecture

```
Cluster
├── Control Plane
│   ├── Kubernetes API Server (coordinator of all cluster communications)
│   ├── Resource Controllers
│   └── Schedulers
└── Worker Nodes (Compute Engine VMs)
    └── Pods
        └── Containers (share storage, network, IP address, and port space)
```

- **Control plane** — manages the cluster; runs API server, controllers, schedulers.
- **Nodes** — Compute Engine VMs; machine type is specified at cluster creation.
- **Pods** — abstract compute units; usually one container, may have more; containers within a pod share storage and network.

![Kubernetes Engine supports clusters that you can manage using Standard mode, or you can have Kubernetes Engine manage many of your cluster operations using Autopilot mode.](../images/c04f019.png)

**Figure 4.19** — GKE Standard vs. Autopilot mode

### Kubernetes Engine Use Cases

- Large-scale applications requiring **high availability and reliability**.
- Applications built as **microservices** with different life cycles and scalability requirements.
- Allows logical management of: UI services, business logic services, and back-end services as separate deployment sets.

---

### Anthos

- **Not a compute service** — a **managed service for centrally configuring and managing deployments** across clouds and on-premises.
- Manages multiple GKE clusters on VMs and **bare-metal servers**.
- Manages clusters in **Google Cloud, other clouds (e.g., AWS), and on-premises**.
- Enables **policy definition and enforcement across environments**.
- **Anthos Service Mesh** — manages complex microservice architectures; consistently secures and monitors services running in Kubernetes.

![Anthos supports the management of Kubernetes clusters in Google Cloud, other clouds, and on-premises.](../images/c04f020.png)

**Figure 4.20** — Anthos multi-cluster management

---

## Cloud Run

- **Managed service for running stateless containers**.
- **Stateless** = any instance of the container can respond to any request; no per-connection or per-user state stored in the container.
- Like App Engine, fully managed — you specify configuration; Google manages infrastructure.

**Deployment parameters for Cloud Run:**
- Container image
- Service name
- Region
- CPU allocation configuration
- Autoscaling parameters
- Traffic configuration
- Authentication information

![When deploying an application to Cloud Run, you will specify a container, a location to run the container, and a minimal set of configuration parameters.](../images/c04f021.png)

**Figure 4.21** — Cloud Run deployment configuration

### Cloud Run Use Cases

- Preferred option for running containers when:
  - Application is **stateless**.
  - You do **not want to manage infrastructure**.
  - Full Kubernetes Engine functionality is not needed.
- Not suitable for stateful applications (use Kubernetes Engine instead).

---

## Cloud Functions

- **Serverless computing platform** for running **single-purpose code in response to events**.
- No need to provision or manage VMs, containers, or clusters.
- Acts as **"glue" code** between independent services.

**Supported languages:** Node.js, Python, Go, Java, .NET, Ruby, PHP

**Example use case:**
- Service A uploads a file to Cloud Storage.
- Service B needs to process that file.
- A Cloud Function is triggered by the Cloud Storage upload event and invokes Service B — **no direct dependency** between A and B.

### Cloud Functions Execution Environment

Three key properties:

| Property | Detail |
|---|---|
| **Secure, isolated execution** | Google manages the secure runtime environment |
| **Automatic scaling** | Scales to as many instances as needed without user intervention |
| **Independent life cycles** | Each invocation is independent of all others |

- Multiple invocations can run **simultaneously** (e.g., two users upload files at the same time → two function instances execute independently).
- Functions do **not share memory or variables** between invocations.
- Functions should be **stateless** — output depends only on input, not on previous invocations.

![Configuring a Cloud Function](../images/c04f022.png)

**Figure 4.22** — Cloud Function configuration

### Cloud Functions Use Cases

Best for **short-running, event-based processing**:

| Use Case | Description |
|---|---|
| **IoT** | Sensor sends data → Cloud Function triggers alert or starts data processing |
| **Mobile applications** | Mobile app sends data to cloud → Cloud Function triggers back-end processing |
| **Asynchronous workflows** | Each step starts after previous completes; no timing assumptions between steps |

---

## Summary

**Compute options comparison:**

| Service | Type | Control Level | Best For |
|---|---|---|---|
| **Compute Engine** | IaaS (VMs) | Maximum | Full OS control, custom configs, legacy apps |
| **App Engine Standard** | PaaS (serverless) | Low | Language-specific apps, scales to zero, low cost |
| **App Engine Flexible** | PaaS (containerized) | Medium | Containerized services needing custom packages |
| **Kubernetes Engine** | Container Orchestration | High | Complex microservices, high availability clusters |
| **Anthos** | Multi-cluster Mgmt | High | Managing K8s clusters across clouds/on-premises |
| **Cloud Run** | Serverless Containers | Low | Stateless containers, simple managed deployment |
| **Cloud Functions** | Serverless Functions | Minimal | Event-driven short code, glue between services |

> **General rule:** The more control you have over a resource, the more responsibility you have for configuring and managing it.

---

## Exam Essentials

- **VM images and projects:** Instances run images (OS + libraries + code). Every VM belongs to a project.

- **Regions and zones:** VMs run in zones within regions. Zones within a region have low-latency, high-bandwidth links. Zones are single failure domains.

- **Preemptible VMs:** ~80% cost savings; can be shut down at any time with 30-second warning; not suitable for critical or stateful workloads. Spot VMs are similar but without the 24-hour maximum runtime.

- **App Engine Standard vs. Flexible:**
  - Standard: language-specific sandbox; scales to zero; cheaper.
  - Flexible: Docker containers; custom runtimes; always at least one instance running.

- **Kubernetes:** Container orchestration platform. Provides load balancing, autoscaling, logging, health checks and repair. Pods are the deploy unit (usually one container per pod).

- **Anthos:** Manages multiple Kubernetes clusters across Google Cloud, other clouds, and on-premises.

- **Cloud Run:** Managed stateless containers. Good when full Kubernetes is not needed. Application must be stateless.

- **Cloud Functions:** Serverless; event-triggered; short-running; independent invocations that do not share memory.

---

## Review Questions

1. You are deploying a Python web application with only custom code and basic Python libraries. Sporadic use expected, minimize cost and DevOps overhead. Which service?
   - A. Compute Engine
   - B. **App Engine standard environment**
   - C. App Engine flexible environment
   - D. Kubernetes Engine

2. Your manager wants to use preemptible VMs to reduce costs. For which workload should you NOT use preemptible VMs?
   - A. **Database server**
   - B. Batch processing with no fixed time requirement
   - C. High-performance computing cluster
   - D. None of the above

3. What parameters need to be specified when creating a VM in Compute Engine?
   - A. **Project and zone**
   - B. Username and admin role
   - C. Billing account
   - D. Cloud Storage bucket

4. You need to run a licensed Linux third-party software package in Docker containers. Which Google Cloud services could you use?
   - A. Compute Engine only
   - B. Kubernetes Engine only
   - C. **Compute Engine, Kubernetes Engine, and the App Engine flexible environment only**
   - D. Compute Engine, Kubernetes Engine, App Engine flexible, or App Engine standard

5. You can specify packages to install into a Docker container by including commands in which file?
   - A. `Docker.cfg`
   - B. **`Dockerfile`**
   - C. `Config.dck`
   - D. `install.cfg`

6. Which of the following could be managed using Anthos?
   - A. Kubernetes clusters in Google Cloud only
   - B. App Engine Flexible containers and Kubernetes clusters in Google Cloud
   - C. App Engine Flexible containers, Cloud Functions, and Kubernetes clusters in Google Cloud
   - D. **Kubernetes clusters in Google Cloud, AWS, and on-premises**

7. Which of the following is NOT a feature Kubernetes provides to reduce DevOps workload?
   - A. Load balancing across Compute Engine VMs in the cluster
   - B. **Security scanning for vulnerabilities**
   - C. Automatic scaling of nodes in the cluster
   - D. Automatic upgrading of cluster software as needed

8. You need to deploy three sets of highly reliable, scalable microservices (UI, business logic, account management) that have different life cycles and scalability requirements. Which service is the best option?
   - A. App Engine standard environment
   - B. Compute Engine
   - C. Cloud Functions
   - D. **Kubernetes Engine**

9. A mobile app uploads images to Cloud Storage. You want an image analysis service to start automatically on upload while keeping both services fully decoupled. How?
   - A. Change the mobile app to start a VM running the analysis service
   - B. **Write a Python Cloud Function triggered by new files in the Cloud Storage bucket; the function submits the file URL to the image analysis service**
   - C. Run a Kubernetes cluster continuously with one pod watching the bucket
   - D. Run a Compute Engine VM continuously listing bucket contents

10. A new pipeline uses Cloud Functions. How do you prevent multiple simultaneous invocations from interfering with each other?
    - A. Include a check to ensure another invocation isn't running
    - B. Schedule each invocation in a separate process
    - C. Schedule each invocation in a separate thread
    - D. **Nothing — Google Cloud ensures invocations do not interfere with each other**

11. A client needs a custom encryption library installed on all VMs. What kind of image would you use?
    - A. **Custom image**
    - B. Public image
    - C. CentOS 6 or 7
    - D. Ubuntu 18 or later

12. What is the lowest level of the resource hierarchy?
    - A. Folder
    - B. **Project**
    - C. File
    - D. VM instance

13. Your application runs in us-central1 and you are seeing latency issues for European users. You are considering deploying to a European region. Which factor should you NOT consider when choosing a region?
    - A. Cost
    - B. Latency
    - C. Regulations
    - D. **Reliability**

    > Note: Reliability is still a valid consideration — the intent of the question is that all listed factors are relevant for region selection. In exam context, the answer is D as reliability is considered constant across Google Cloud regions.

14. What role gives users full control over Compute Engine instances?
    - A. Compute Manager role
    - B. **Compute Admin role**
    - C. Compute Regional Manager role
    - D. Compute Security Admin

15. Which of the following are limitations of a preemptible VM?
    - A. Will be terminated within 24 hours
    - B. May not always be available
    - C. Cannot migrate to a regular VM
    - D. **All of the above**

16. Which of the following would eliminate Cloud Run as an option for deploying an application?
    - A. The application uses a mix of Java and Python
    - B. **The application stores session data in memory for use across multiple requests**
    - C. The application runs in a container
    - D. The container configuration is specified in a Dockerfile

17. When using the App Engine standard environment, which language runtime is NOT supported?
    - A. Java
    - B. Python
    - C. **C**
    - D. Go

18. You want all services in a Kubernetes Engine cluster to use the same authentication and monitoring services. What service would you use?
    - A. Cloud Functions
    - B. **Anthos Service Mesh**
    - C. App Engine Flexible
    - D. App Engine Standard

19. You want to validate VM boot integrity to protect against malware compromising the OS. Which Compute Engine feature would you enable?
    - A. Customer-supplied encryption keys
    - B. **vTPM**
    - C. Sole tenancy
    - D. IAM roles

20. Your client wants to move to serverless platforms to reduce DevOps overhead. You recommend Cloud Functions for all of the following except which one?
    - A. **Long-running data warehouse data load procedures**
    - B. IoT back-end processing
    - C. Mobile application event processing
    - D. Asynchronous workflows
