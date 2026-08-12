# Chapter 2: Google Cloud Computing Services

> **Exam Objectives Covered:**
> - 2.2 Planning and configuring compute resources
> - 3.4 Deploying and implementing data solutions

---

Google Cloud is made up of a wide array of services that meet a variety of computing, storage, and networking needs. This chapter provides an overview of the most important Google Cloud computing services and describes important use cases for these services.

---

## Computing Components of Google Cloud

Google Cloud services can be grouped into several core categories:

| Category | Examples |
|---|---|
| Computing resources | Compute Engine, Kubernetes Engine, App Engine, Cloud Run, Cloud Functions |
| Storage resources | Cloud Storage, Persistent Disk, Cloud Filestore |
| Databases | Cloud SQL, Cloud Bigtable, Cloud Spanner, Cloud Firestore, Cloud Memorystore |
| Networking services | VPC, Cloud Load Balancing, Cloud Armor, Cloud CDN, Cloud DNS |
| Identity management and security | Cloud IAM |
| Development tools | Cloud SDK, Cloud Build, Container Registry |
| Management tools | Cloud Monitoring, Cloud Logging, Cloud Trace, Error Reporting |
| Specialized services | BigQuery, Cloud Dataflow, Vertex AI, AutoML, Natural Language, Vision AI |

---

### Computing Resources

Cloud computing resources span from full control (IaaS) to fully managed (PaaS/serverless):

- **Infrastructure as a Service (IaaS)** — user manages VMs, OS, packages; Google provides hardware. Example: **Compute Engine**.
- **Platform as a Service (PaaS)** — user manages code/app; Google manages servers, networks, storage. Example: **App Engine**, **Cloud Functions**.
- **Container orchestration** — managed clusters with auto-scaling and health monitoring. Example: **Kubernetes Engine**.

#### Compute Engine

- Google Cloud's **IaaS** VM service.
- VMs are abstractions of physical servers, emulating CPU, memory, storage.
- VMs run within a **hypervisor** — Google uses a security-hardened version of **KVM** (Kernel Virtual Machine) for virtualization on Linux/x86 hardware.
- The hypervisor can run multiple **guest operating systems** simultaneously, each isolated from others. Each executing guest OS instance is a **VM instance**.

![VM instances running within a hypervisor](../images/c02f001.png)

**Figure 2.1** — VM instances running within a hypervisor

**Parameters you can specify when creating a VM instance:**

| Parameter | Description |
|---|---|
| Operating system | Linux distributions, Windows Server |
| Persistent storage size | Size of attached disk |
| GPUs | For compute-intensive tasks like ML |
| Preemptible / Spot | Lower cost (~80% less), but can be shut down by Google |

**Preemptible VMs vs. Spot Instances:**

| Type | Max Runtime | Can be shut down by Google? |
|---|---|---|
| **Preemptible VM** | 24 hours | Yes, after at least 24 hours |
| **Spot Instance** | No maximum | Yes, at any time |

Both use the same pricing model (~80% less than standard VMs).

---

#### Kubernetes Engine

- Allows users to easily run **containerized applications** on a cluster of servers.
- **Containers vs. VMs:**
  - VMs: guest OS runs on a hypervisor on top of the host OS.
  - Containers: use host OS features to isolate processes — no hypervisor, no guest OS overhead.
  - A single **container manager** coordinates all containers on the server.
  - Containers are **lighter weight** than VMs.

![Containers running on a physical server](../images/c02f002.png)

**Figure 2.2** — Containers running on a physical server

- Kubernetes Engine:
  - Users describe compute, storage, and memory resource requirements.
  - Kubernetes Engine **provisions** the underlying resources.
  - Supports CLI and GUI management.
  - Monitors cluster health; **automatically repairs** failed servers.
  - Supports **autoscaling**.

**Anthos Clusters:**

- Extends GKE for **hybrid and multicloud** environments.
- Multiple clusters managed as a group called a **fleet**.
- Connected via VPNs, Dedicated Interconnect, or Partner Interconnects.

| Anthos Benefit | Description |
|---|---|
| Centralized management as code | Config managed centrally |
| Git-based rollbacks | Deploy rollback using Git |
| Single cluster view | Unified view of infrastructure and apps |
| Centralized auditable workflows | Consistent, auditable operations |
| Anthos Service Mesh | Code instrumentation, auth, and routing |
| Migrate for Anthos | Orchestrates migrations using Kubernetes |

---

#### App Engine

- Google Cloud's **PaaS** compute offering — serverless, no VM/cluster management needed.
- Developers write code in supported languages and deploy to a **managed environment**.
- Well-suited for **web and mobile back-end applications**.
- Supported languages include: **Java, Go, Python, Node.js**.

**Two App Engine environments:**

| Environment | Description | Best For |
|---|---|---|
| **Standard** | Language-specific sandbox; isolated from host OS and other apps | Apps using supported languages with no OS package requirements |
| **Flexible** | Runs containerized apps; supports background processes and local disk writes | Apps needing third-party libraries or compiled software |

---

#### Cloud Run

- Service for running **stateless containers** — fully managed by Google.
- **Pay per use**; scales to up to **1,000 container instances** by default.
- Not restricted to a fixed set of programming languages (unlike App Engine Standard).
- **Regional availability**; service is replicated across multiple zones.
- Supports **multiple revisions** of a service.
- Autoscales the number of instances based on load.
- Good alternative to Kubernetes when full GKE features are not needed.

> **Note:** Cloud Run does not support applications that maintain state in the container.

---

#### Cloud Functions

- **Lightweight, event-driven** serverless compute.
- Executes code in response to events such as:
  - File uploaded to Cloud Storage
  - Message written to a message queue
- Code must be **short-running** — not designed for long-running workloads.
- Often used to call other services: third-party APIs, Google Cloud services (e.g., translation).
- Automatically **scales** with load — no VM or container management required.
- For long-running jobs, use Compute Engine, Kubernetes Engine, or App Engine instead.

**Compute Options Comparison:**

| Service | Type | Best For | Manages Servers? |
|---|---|---|---|
| **Compute Engine** | IaaS | Full control over VMs and OS | User |
| **Kubernetes Engine** | Container Orchestration | Containerized microservices in clusters | Shared |
| **App Engine** | PaaS (serverless) | Web/mobile back ends, long-running apps | Google |
| **Cloud Run** | Serverless Containers | Stateless containers, rapid autoscaling | Google |
| **Cloud Functions** | Serverless Functions | Short event-driven code execution | Google |

---

## Storage Components of Google Cloud

### Storage Resources

#### Cloud Storage

- Google Cloud's **object storage system**.
- Stores any type of file or **binary large object (blob)**.
- Objects organized into **buckets** (analogous to directories, but not a filesystem).
- Each object is addressable by a **unique URL**:

```
https://storage.cloud.google.com/ace-certification-exam-prep/chapter1.pdf
```

- Accessible from VMs, containers, or any network device with appropriate privileges.
- Access granted via **IAM roles** on service accounts.
- Best for objects treated as a **single unit** (read/write entirely at once), e.g., images, datasets.

**Cloud Storage Location Types:**

| Type | Description | Best For |
|---|---|---|
| **Regional** | Copies in a single region | Low-latency apps in same region |
| **Multi-region** | Replicas across multiple regions | High availability, global access |
| **Nearline** | Low-cost, accessed < once/month | Infrequent access |
| **Coldline** | Lower-cost, accessed < once/90 days | Rare access |
| **Archive** | Lowest-cost, accessed < once/year | Long-term archival, high durability |

**Life Cycle Management Policies** — automatically move or delete objects based on rules:
- Example: Move objects older than 60 days from Standard to Nearline.
- Example: Delete objects in an archive bucket older than 5 years.

---

> ### Real World Scenario
> ### Multi-Region Storage
>
> If there was an outage in region **us-east1** and objects were stored only there, they would be inaccessible during the outage. With **multiregion storage** enabled, objects in us-east1 are also stored in another region (e.g., **us-west1**), ensuring continued availability even during a regional outage.

---

#### Persistent Disk

- **Block storage** attached to VMs in Compute Engine or Kubernetes Engine.
- Available on **SSDs** (low-latency, higher cost) and **HDDs** (high capacity, lower cost).
- Supports **multiple simultaneous readers** without performance degradation.
- Disks can be **resized while in use** — no VM restart required.
- Maximum size: **64 TB** (SSD or HDD).
- Multiple persistent disks can be attached to a single VM.

#### Cloud Storage for Firebase

- Designed for **mobile app developers**.
- Supports uploads and downloads over **unreliable network connections**.
- Provides **secure transmission** and **robust recovery mechanisms**.
- Once files (photos, recordings) are uploaded, accessible via Cloud Storage CLI and SDKs.

#### Cloud Filestore

- Provides a **shared filesystem** for Compute Engine and Kubernetes Engine.
- Based on the **Network File System (NFS)** protocol — easy to mount on VMs.
- Provides high **IOPS** and variable storage capacity.
- Administrators can configure IOPS and capacity to specific requirements.

---

### Databases

Google Cloud provides both **relational** and **NoSQL** databases. Choosing the right database depends on application requirements for consistency, scalability, transaction support, and data structure.

#### Cloud SQL

- **Managed relational database** service.
- Supports **MySQL**, **PostgreSQL**, and **SQL Server**.
- Google handles: backups, patching, replication, and automatic failover.
- Provides **high availability** via managed replication.
- Best for applications with consistent, structured data (e.g., banking, CRM).

#### Cloud Bigtable

- **NoSQL wide-column database** designed for **petabyte-scale** workloads.
- Handles up to **billions of rows** and **thousands of columns**.
- Designed for **low-latency** read/write operations — supports **millions of ops/second**.
- Integrates with: Cloud Storage, Cloud Pub/Sub, Cloud Dataflow, Cloud Dataproc.
- Supports **HBase API** (Hadoop big data ecosystem).
- Also integrates with open source tools for data processing, graph analysis, and time-series analysis.

#### Cloud Spanner

- **Globally distributed relational database** combining relational and NoSQL strengths.
- Provides **strong consistency**, **transactions**, and **horizontal scalability**.
- **99.999% availability SLA**.
- Enterprise-grade security: **encryption at rest and in transit**, identity-based access controls.
- Supports **ANSI 2011 standard SQL**.
- Best for enterprise applications requiring global scalability + relational features.

#### Cloud Firestore

- **NoSQL document database** (formerly Cloud Datastore).
- Uses **documents** (collections of key-value pairs) as the basic building block.
- Supports **flexible schemas** — keys/fields don't need to be predefined.
- Accessed via a **REST API** from Compute Engine, Kubernetes Engine, or App Engine.
- Auto-scales and auto-shards data to maintain performance.
- Managed service: Google handles replication and backups.
- Supports **transactions, indexes, and SQL-like queries** despite being NoSQL.
- Best for: product catalogs, user profiles, user navigation history.

#### Cloud Memorystore

- **Managed in-memory cache** service.
- Designed for **submillisecond** data access.
- Supports **Redis** and **Memcached** (popular open source caching systems).
- Google manages: high availability, patching, automatic failover.
- Users only specify **cache size**.

**Database Comparison:**

| Database | Type | Key Features | Best For |
|---|---|---|---|
| **Cloud SQL** | Relational | MySQL/PostgreSQL/SQL Server, managed | Structured, transactional apps |
| **Cloud Bigtable** | NoSQL Wide-Column | Petabyte scale, billions of rows, HBase API | IoT, time-series, low-latency analytics |
| **Cloud Spanner** | Relational (global) | Horizontal scale + ANSI SQL + 99.999% SLA | Global transactional enterprise apps |
| **Cloud Firestore** | NoSQL Document | Flexible schema, REST API, auto-scale | User profiles, catalogs, flexible data |
| **Cloud Memorystore** | In-Memory Cache | Redis/Memcached, submillisecond access | Caching, session data, low-latency reads |

---

## Networking Components of Google Cloud

### Networking Services

#### Virtual Private Cloud (VPC)

- Allows organizations to **logically isolate** cloud resources within the shared public cloud infrastructure.
- **Google Cloud VPCs are global** — span the globe without relying on the public Internet.
- Traffic between Google Cloud services is **routed over the Google global network** (not the public Internet).
- Back-end servers can access Google services (ML, IoT) **without needing a public IP**.
- VPCs can be linked to on-premises networks via **IPSec VPN**.
- Supports separation by **projects** and **billing accounts** for department/group management.
- **Firewall rules** restrict access to resources within a VPC.

#### Cloud Load Balancing

- **Global load balancing** service using a **single anycast IP address**.
- Distributes workload within and across regions.
- Handles **failed or degraded servers** automatically.
- Supports **autoscaling** in response to workload changes.
- Supports **internal load balancing** — no public IP needed.
- Balances: **HTTP, HTTPS, TCP/SSL, and UDP** traffic.

#### Cloud Armor

- **Network security service** built on top of Global HTTP(S) Load Balancing.
- Protects against **DDoS attacks** and other threats.

| Cloud Armor Feature | Description |
|---|---|
| IP-based allow/restrict | Filter traffic by source IP address |
| XSS protection | Predefined rules against cross-site scripting |
| SQL injection protection | Counter SQL injection attacks |
| Layer 3–7 rule definitions | Rules from network to application layer |
| Geo-based filtering | Allow/restrict by geographic location of traffic |

#### Cloud CDN

- **Content delivery network** with 100+ global endpoints.
- Caches static content on endpoints close to users — reduces latency.
- Managed as a **global resource** — no per-region configuration needed.
- Best for sites with large amounts of static content and a global audience (e.g., news sites).

#### Cloud Interconnect

- Connects existing networks to the **Google global network**.

**Two types of connections:**

| Type | Description |
|---|---|
| **Direct Interconnect** | Direct physical connection between on-premises/hosted data center and a Google colocation facility (North America, South America, Europe, Asia, Australia). Uses RFC 1918 private addressing. |
| **Partner Interconnect** | Uses a third-party network provider when a direct connection to a Google facility is not possible. Recommended method to connect through providers. |
| **Carrier Peering** | Used for accessing Google Workspace applications. Does not use Cloud Interconnect connections or Cloud Routers. |
| **VPN** | For organizations not requiring high bandwidth; routes traffic over the public Internet using IPSec. |

#### Cloud DNS

- **High-availability, low-latency** domain name service.
- Maps domain names (e.g., `example.com`) to IP addresses (e.g., `74.120.28.18`).
- Auto-scales to support **millions of addresses** without user management.
- Supports **private zones** for custom VM name resolution within your network.

---

### Identity Management and Security

- **Cloud IAM (Identity and Access Management)** — fine-grained access control for all Google Cloud resources.
- Core IAM concepts:

| Concept | Description |
|---|---|
| **Identity** | Abstraction of a user (human or service account) |
| **Authentication** | Verifying who the identity is (login, etc.) |
| **Permission** | A specific action allowed on a resource (e.g., create a VM, delete a bucket) |
| **Role** | A bundle of related permissions assigned to an identity |

---

### Development Tools

- **Cloud SDK** — command-line interface for managing all Google Cloud resources (VMs, storage, firewalls, etc.).
- **Client libraries** supported: Java, Python, Node.js, Ruby, Go, .NET, PHP.
- Container tooling: **Container Registry**, **Cloud Build**, **Cloud Source Repositories**.

**IDE integrations:**

| Tool | Platform |
|---|---|
| Cloud Tools for IntelliJ | IntelliJ IDEA |
| Cloud Tools for PowerShell | PowerShell |
| Cloud Tools for Visual Studio | Visual Studio |
| Cloud Tools for Eclipse | Eclipse |
| App Engine Gradle Plugin | Gradle builds |
| App Engine Maven Plugin | Maven builds |

---

## Additional Components of Google Cloud

### Management and Observability Tools

| Tool | Purpose |
|---|---|
| **Cloud Monitoring** | Collects performance data from Google Cloud, AWS, and open source systems (NGINX, Cassandra, Elasticsearch) |
| **Cloud Logging** | Store, analyze, and alert on log data from Google Cloud and AWS |
| **Error Reporting** | Aggregates and displays application crash information in a centralized interface |
| **Cloud Trace** | Distributed tracing — captures latency data to identify performance bottlenecks |
| **Cloud Debugger** | Inspect executing code state, inject commands, view call stack variables |
| **Cloud Profiler** | Collects CPU and memory usage across the call hierarchy using statistical sampling (minimal performance impact) |

---

### Specialized Services

#### Apigee API Platform

- **API management service** for deploying, monitoring, and securing APIs.
- Generates **API proxies** based on the Open API Specification.
- Provides **routing and rate-limiting** for traffic spikes.
- Authentication via **OAuth 2.0** or **SAML**.
- Data encrypted **in transit and at rest**.

#### Data Analytics and Data Pipelines

| Service | Description |
|---|---|
| **BigQuery** | Petabyte-scale analytics database for data warehousing |
| **Cloud Dataflow** | Batch and stream processing pipeline framework |
| **Cloud Dataproc** | Managed Hadoop and Spark service |
| **Cloud Dataprep** | Data exploration and preparation for analysts |

#### AI and Machine Learning

- **Vertex AI** — unified AI platform for building ML models.

| Service | Description |
|---|---|
| **AutoML** | ML model development for non-expert developers |
| **Translation AI** | Text translation (AutoML Translation, Translation API) and audio (Media Translation API) |
| **Natural Language** | Extract features and concepts from text using ML |
| **Vision AI** | Image annotation, text extraction, content filtering |
| **Recommendations AI** | Personalized product recommendations at scale |

---

## Summary

Google Cloud provides a full range of services to support information processing including:
- **Computing resources** (IaaS, PaaS, serverless)
- **Storage resources** (object, block, file, in-memory)
- **Databases** (relational and NoSQL)
- **Networking services** (VPC, load balancing, CDN, DNS, interconnect)
- **Identity management and security** (Cloud IAM)
- **Development tools** (Cloud SDK, IDE integrations)
- **Management and observability** (monitoring, logging, tracing, profiling)
- **Specialized services** (Apigee, data analytics, Vertex AI)

---

## Exam Essentials

- **Differences between Compute Engine, Kubernetes Engine, App Engine, Cloud Run, and Cloud Functions:**

| Service | Key Point |
|---|---|
| **Compute Engine** | IaaS VMs; user controls OS, CPU, memory, disk; can add GPUs; managed individually or in groups |
| **Kubernetes Engine** | Container orchestration; distributes containers across clusters; monitors health; autoscales |
| **App Engine** | PaaS; standard = language sandbox; flexible = containerized; no server management |
| **Cloud Run** | Serverless stateless containers; no cluster deployment; rapid autoscaling; no state in container |
| **Cloud Functions** | Serverless; short-running code; event-driven; Node.js or Python |

- **Serverless means:** customers do not configure, monitor, or maintain the underlying compute resources. Physical servers still exist — serverless only means you don't manage them.

- **Object vs. file storage:**
  - **Object (Cloud Storage):** referenced by URL; no block/filesystem services; not suitable for databases.
  - **File (Cloud Filestore):** block-based, hierarchical directories; NFS-based.

- **Types of databases:**

| Type | Examples | Key Traits |
|---|---|---|
| Relational | Cloud SQL, Cloud Spanner | Transactions, strong consistency, SQL; Cloud Spanner adds global horizontal scalability |
| NoSQL Key-Value | Cloud Memorystore | In-memory, submillisecond latency |
| NoSQL Document | Cloud Firestore | Flexible schema, scalable |
| NoSQL Wide-Column | Cloud Bigtable | Petabyte scale, millions of ops/sec |

- **VPCs:** Logical isolation of cloud resources; global in Google Cloud; traffic stays on Google's network; no need for public IPs on back-end servers.

- **Load balancing:** Distributes workload across server groups; global in Google Cloud; network-level and application-level rules.

- **Developer and management tools:**
  - Developer tools: version control, container builds, container registry, IDE plug-ins.
  - Management tools: Cloud Monitoring and Cloud Logging for operational visibility.

- **Specialized services:** Growing list including data analytics (BigQuery, Dataflow, Dataproc) and AI/ML (Vertex AI, AutoML, Natural Language, Vision AI).

- **On-premises vs. public cloud:**
  - On-premises: company owns/manages hardware; may be in company facility or colocation facility.
  - Colocation facility: provides power, cooling, physical security; customer manages all infrastructure.
  - Public cloud: provider maintains hardware and facilities; mix of IaaS (customer manages) and serverless (provider manages more).

---

## Review Questions

1. You need to distribute workload across regions for a North America/Europe/Asia SaaS application. Which service?
   - A. Cloud DNS
   - B. Cloud Spanner
   - C. **Cloud Load Balancing**
   - D. Cloud CDN

2. You need managed container services that support stateful containers. Which two options?
   - A. App Engine standard and App Engine flexible
   - B. Kubernetes Engine and App Engine standard
   - C. **Kubernetes Engine and Cloud Run environment**
   - D. App Engine standard and Cloud Functions

   > Note: Cloud Run does not support stateful containers; Kubernetes Engine does. The question asks which services allow containers in a managed service — Kubernetes Engine and App Engine flexible (which runs containers) are the correct managed container options. Answer C is the best match among the given options.

3. Why would an API developer use the Apigee API platform?
   - A. Routing and rate-limiting
   - B. Authentication services
   - C. Version control of code
   - D. **A and B**
   - E. All of the above

4. You are deploying an API to the public Internet and are concerned about DDoS attacks. Which service?
   - A. **Cloud Armor**
   - B. Cloud CDN
   - C. Cloud IAM
   - D. VPCs

5. You have a Pub/Sub-based task queue where tasks take ~10 seconds each and duplicate processing is acceptable. What is a cost-effective configuration?
   - A. **Use preemptible VMs**
   - B. Use standard VMs
   - C. Use DataProc
   - D. Use Spanner

6. You want to reduce database read load by keeping data in memory. Which service?
   - A. Cloud SQL
   - B. **Cloud Memorystore**
   - C. Cloud Spanner
   - D. Cloud Firestore

7. The Cloud SDK can manage resources in which services?
   - A. Compute Engine
   - B. Cloud Storage
   - C. Network firewalls
   - D. **All of the above**

8. What server configuration is required to use Cloud Functions?
   - A. VM configuration
   - B. Cluster configuration
   - C. Pub/Sub configuration
   - D. **None**

9. You need to consolidate log data from each instance of an application. Which tool?
   - A. Cloud Monitoring
   - B. Cloud Trace
   - C. Cloud Debugger
   - D. **Cloud Logging**

10. Which specialized services support complex ETL on batch data and streaming data for a data warehouse?
    - A. Apigee API platform
    - B. **Data analytics**
    - C. AI and machine learning
    - D. Cloud SDK

11. You have 100,000 IoT sensors sending data every 5 seconds; daily aggregation reports needed; no transaction support needed. Which database?
    - A. Cloud Spanner
    - B. **Cloud Bigtable**
    - C. Cloud SQL MySQL
    - D. Cloud SQL PostgreSQL

12. You have a mobile medical app that must capture data offline and sync when connected. Which data store minimizes development effort?
    - A. **Cloud Firestore**
    - B. Cloud Spanner
    - C. Cloud CDN
    - D. Cloud SQL

13. A machine learning algorithm for image analysis is computationally intensive, float-heavy, needs large memory, and cannot be distributed. What Compute Engine configuration?
    - A. High memory, high CPU
    - B. **High memory, high CPU, GPU**
    - C. Mid-level memory, high CPU
    - D. High CPU, GPU

14. What does the term *identity* refer to in Google Cloud IAM?
    - A. VM ID
    - B. **User**
    - C. Role
    - D. Set of privileges

15. A client needs to analyze large volumes of text but is not a text mining expert. Which service?
    - A. Vertex AI
    - B. Recommendation AI
    - C. **Natural Language**
    - D. Text-to-Speech

16. Data scientists want to use a machine learning library available only in Apache Spark with minimal admin. What should they use?
    - A. Use Cloud Spark
    - B. **Use Cloud Dataproc**
    - C. Use BigQuery
    - D. Install Apache Spark on VMs

17. A global application database needs ANSI SQL 2011 and global transactions. Which service?
    - A. Cloud SQL
    - B. **Cloud Spanner**
    - C. Cloud Firestore
    - D. Cloud Bigtable

18. Which specialized service supports both batch and stream processing workflows?
    - A. **Cloud Dataflow**
    - B. BigQuery
    - C. Cloud Firestore
    - D. AutoML

19. You have a Python app requiring a scalable environment with the least management overhead. Which product?
    - A. App Engine flexible environment
    - B. Cloud Engine
    - C. **App Engine standard environment**
    - D. Kubernetes Engine

20. Customers report an application is crashing periodically. Developers want to review consolidated crash data. Which tool?
    - A. Cloud DataProc
    - B. Cloud Monitoring
    - C. Cloud Logging
    - D. **Error Reporting**
