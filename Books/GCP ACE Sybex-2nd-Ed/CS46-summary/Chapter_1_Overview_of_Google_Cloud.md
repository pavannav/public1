# Chapter 1: Overview of Google Cloud

> **Exam Objective Covered:**
> - 1.0 Setting up cloud projects and accounts

---

Google Cloud is a public cloud service that offers some of the same technologies used by Google to deliver its own products. This chapter describes the most important components of Google Cloud and discusses how it differs from on-premises data center–based computing.

---

## Types of Cloud Services

Public cloud providers (Google, Amazon, Microsoft) offer services across four broad categories:

- **Compute resources**
- **Storage**
- **Networking**
- **Specialized services** (e.g., machine learning)

Cloud users range from startups with no on-premises infrastructure to large enterprises that supplement existing data centers with cloud resources. Enterprises face additional integration challenges such as identity management synchronization and establishing secure networks between on-premises and cloud environments.

---

### Compute Resources

Computing resources come in a variety of forms in public clouds.

#### Virtual Machines

- A **Virtual Machine (VM)** is the basic unit of computing in the cloud.
- After creating a Google Cloud account and project, you can provision VMs via the portal or CLI.
- Google Cloud offers **preconfigured VM types** (varying vCPUs and memory) or **custom configurations**.
- You have full administrator rights: configure filesystems, add persistent storage, patch the OS, install packages.
- Multiple VMs can be placed behind **load balancers** for high availability.
- **Autoscaling** adds or removes VMs based on workload — controls cost and ensures capacity.

#### Managed Kubernetes Clusters

- For users who prefer not to manage cluster infrastructure, **managed clusters** are available.
- Use **containers** — lightweight VMs that isolate processes from each other.
- You specify: number of servers, containers to run, and autoscaling parameters.
- The cluster management software **monitors container health** and restarts failed containers.
- Good for applications built on **multiple microservices**.

#### Serverless Computing

- No need to configure VMs or Kubernetes clusters.
- Google Cloud offers **three serverless options**:

| Service | Use Case |
|---|---|
| **App Engine** | Long-running applications and containers (e.g., website back end, POS systems) |
| **Cloud Run** | Stateless containers needing fully managed service and rapid autoscaling |
| **Cloud Functions** | Event-driven short code execution (e.g., file upload, message queue event) |

---

### Storage

Public clouds offer four types of storage:

- **Object storage**
- **File storage**
- **Block storage**
- **Caches**

#### Object Storage

- Manages storage as **objects/blobs** (typically files), grouped into **buckets**.
- Each object is individually addressable via a **URL**.
- Not limited by attached disk size — scales virtually without bounds.
- Multiple copies stored for **high availability and durability**; optionally replicated across regions.
- **Serverless** — no VM required. Accessible from Google Cloud and the public Internet.
- Google Cloud's object storage service: **Cloud Storage**.

#### File Storage

- Provides a **hierarchical filesystem** (directory/file structure).
- Based on **Network File System (NFS)**.
- Google Cloud service: **Cloud Filestore**.
- Filesystem is **decoupled from VMs** — exists independently of any VM or application.
- Suitable for applications requiring **OS-like file access**.

#### Block Storage

- Uses **fixed-size data blocks** to organize data.
- Common block sizes: **4 KB** (Linux filesystems), **8 KB+** (relational databases).
- Used for disks attached to VMs.
- Two types:

| Type | Description |
|---|---|
| **Persistent disk** | Survives VM shutdown or detachment; data persists independently |
| **Ephemeral disk** | Exists only while VM is running; deleted when VM stops |

- Supports fast **OS-level and filesystem-level access**.
- **Comparison with object storage:** Object storage keeps data independent of VM lifecycle but requires higher-level protocols (HTTP); block storage is faster for direct access.

#### Caches

- **In-memory data stores** for minimum-latency data retrieval.
- Designed for **submillisecond latency**.

**Latency Comparison Table:**

| Operation | Latency |
|---|---|
| Main memory reference | 100 ns (0.1 µs) |
| Read 4 KB randomly from SSD | 150 µs |
| Read 1 MB sequentially from memory | 250 µs |
| Read 1 MB sequentially from SSD | 1,000 µs (1 ms) |
| Read 1 MB sequentially from HDD | 20,000 µs (20 ms) |

**Unit conversions:**
- 1,000 nanoseconds = 1 microsecond
- 1,000 microseconds = 1 millisecond
- 1,000 milliseconds = 1 second

**Reading 1 MB comparison:**
- From in-memory cache: **0.25 ms**
- From SSD: **1 ms** (4× slower)
- From HDD: **20 ms** (80× slower)

**Limitations of caches:**
1. **Cost** — Memory is more expensive than SSD/HDD; not practical for all data.
2. **Volatility** — Data is lost on power loss or reboot; never use as the sole data store.
3. **Stale data risk** — Cache can go out of sync with the "system of truth." Cache invalidation is notoriously hard (Phil Karlton: *"There are only two hard things in computer science: cache invalidation and naming things."*)

---

> ### Real World Scenario
> ### Improving Database Query Response Time
>
> Users expect web applications to respond within 2–3 seconds. Database queries involve disk reads, and under high load, queries queue up, increasing latency.
>
> **Solution — Use a cache:**
> - Query results are fetched from the database and **stored in the cache**.
> - Subsequent requests for the same data are served from the **faster in-memory cache**.
> - Reduces latency (memory vs. disk) and reduces database query queue depth.
> - Requires application code changes to: (1) check cache before querying DB, and (2) store results in cache after DB fetch.

---

### Networking

Key networking concepts in Google Cloud:

- Cloud resources have **IP addresses** — both **internal** (VPC-only) and **external** (Internet-accessible).
- External IPs can be:
  - **Static** — assigned for extended periods.
  - **Ephemeral** — assigned to a VM and released when it stops.
- **Virtual Private Cloud (VPC)** — your internal private network in Google Cloud.
- **Firewall rules** control inbound and outbound traffic to subnetworks and VMs.
  - Example: Restrict database access to only the application server's IP.
- Connecting on-premises to VPC uses **peering** options:
  - VPNs
  - Interconnects
  - Shared VPC
  - VPC network peering
  - Direct or Carrier peering

---

### Specialized Services

Characteristics common to all specialized services:

- **Serverless** — no server or cluster configuration needed.
- **Function-specific** — e.g., image analysis, text translation.
- Accessible via **API**.
- **Usage-based billing**.

**Examples of Google Cloud specialized services:**

| Service | Function |
|---|---|
| **AutoML** | Machine learning model training |
| **Cloud Natural Language** | Text analysis |
| **Speech-to-Text** | Converts spoken language to text |
| **Recommendations AI** | Personalized product recommendations |

Specialized services make advanced capabilities (e.g., NLP, ML) accessible to developers without deep domain expertise.

---

## Cloud Computing vs. Data Center Computing

### Rent Instead of Own Resources

| Model | Characteristics |
|---|---|
| **On-premises / owned** | Large upfront purchase or long-term lease; idle capacity during off-peak periods |
| **Cloud / rented** | Short-term rental; pay only when needed; scale for peak without idle cost |

**Example:** A retailer with average load of 20 servers but peak load of 80 servers:
- On-premises: Buy 80 servers → 60 idle most of the year.
- Cloud: Run 20 on-premises + burst to 80 in cloud during peak → cost-efficient.

> Unit cost per server may be higher in the cloud, but **total cost** (including idle capacity) is often lower.

---

### Pay-as-You-Go-for-What-You-Use Model

- Charged for a **minimum period** (e.g., 1 minute), then **per second**.
- Cost varies by server characteristics (vCPUs, memory).
- Cloud engineers must **monitor usage** carefully to avoid runaway costs.
- In some scenarios, cloud can be **more expensive** than on-premises if not managed.

---

### Elastic Resource Allocation

| Environment | Time to Provision |
|---|---|
| **Cloud** | Minutes |
| **On-premises** | Days to weeks (hardware procurement) |

- Cloud providers maintain **extensive resources** across large data centers.
- Efficient multi-tenant resource sharing enables rapid, elastic allocation.
- Variation of any one customer's demand has **minimal effect** on overall capacity.

---

### Specialized Services

- Developing in-house ML or data science expertise is expensive; only large enterprises can afford it.
- Cloud providers **amortize** the cost of specialized services across **many customers**.
- Makes advanced capabilities accessible to a **broader developer audience**.

---

## Summary

Google Cloud offers services across four domains:

| Domain | Key Services |
|---|---|
| **Compute** | Virtual Machines, Kubernetes clusters, App Engine, Cloud Run, Cloud Functions |
| **Storage** | Cloud Storage (object), Cloud Filestore (file), persistent/ephemeral disks (block), in-memory caches |
| **Networking** | VPC, VPNs, Interconnects, Shared VPC, VPC peering, Direct/Carrier peering |
| **Specialized** | AutoML, Cloud Natural Language, Speech-to-Text, Recommendations AI |

**Advantages of cloud over on-premises:**
1. Renting rather than owning infrastructure
2. Pay-as-you-go model
3. Elastic resource allocation
4. Access to specialized services

---

## Exam Essentials

- **Different ways of delivering cloud computing resources:**
  - Self-managed VMs and clusters → most control.
  - Managed Kubernetes clusters → reduced operational overhead.
  - Serverless (App Engine, Cloud Run, Cloud Functions) → no server management; best when control of compute environment isn't needed.

- **Different forms of cloud storage and when to use them:**

| Type | Best For | Notes |
|---|---|---|
| **Object** | Highly durable file/blob storage | No filesystem access; use HTTP |
| **File** | OS-like file access, shared across servers | Hierarchical; NFS-based |
| **Block** | Disk-level storage for VMs and databases | Fast; used with SSDs and HDDs |
| **Cache** | Low-latency read access | Volatile; never use as "system of truth" |

- **Differences between on-premises and cloud:**
  - Cloud advantages: short-term rental, pay-as-you-go, elastic allocation, specialized services.
  - Unit cost per minute may be higher in cloud; understand the cost model to optimize workload placement.

---

## Review Questions

1. Which of the following is an option for choosing a computing resource in Google Cloud?
   - A. Cache
   - B. **Virtual machine (VM)**
   - C. Block
   - D. Subnet

2. If you use a cluster managed by a cloud provider, which is managed for you?
   - A. Monitoring
   - B. Networking
   - C. Some security management tasks
   - D. **All of the above**

3. You need serverless computing for file processing and a website back end; which two products?
   - A. Kubernetes Engine and Compute Engine
   - B. **Cloud Run and Cloud Functions**
   - C. Cloud Functions and Compute Engine
   - D. Cloud Functions and Kubernetes Engine

4. You need to store large data files in high-availability storage without filesystem functionality. Which storage system?
   - A. Block storage
   - B. **Object storage**
   - C. Cache
   - D. Network File System

5. All block storage systems use what block size?
   - A. 4 KB
   - B. 8 KB
   - C. 16 KB
   - D. **Block size can vary**

6. Which network security control limits traffic flow between subnets in a VPC?
   - A. Identity access management
   - B. Router
   - C. **Firewall**
   - D. IP address table

7. When creating a machine learning service, what type of servers should you manage?
   - A. Virtual machines (VMs)
   - B. Clusters of VMs
   - C. **No servers; use specialized services, which are serverless**
   - D. VMs running Linux only

8. When does investing in servers for 3–5 years work well?
   - A. When a company is just starting up
   - B. **When a company can accurately predict server need for an extended period**
   - C. When a company has a fixed IT budget
   - D. When a company has a variable IT budget

9. What factor determines the unit per minute cost of running a virtual server?
   - A. The time of day the VM is run
   - B. **The characteristics of the server**
   - C. The application you run
   - D. None of the above

10. You plan to use AutoML. How many VMs should you allocate?
    - A. 1
    - B. 10
    - C. 25
    - D. **None; AutoML is a serverless service**

11. You need to run multiple services to support an application. Which deployment model is best?
    - A. Run on a large, single VM
    - B. **Use containers in a managed cluster**
    - C. Use two large VMs, one read only
    - D. Use a small VM and resize when CPU > 90%

12. Which system administration operations are allowed on a VM you created?
    - A. Configure the filesystem
    - B. Patch operating system software
    - C. Change file and directory permissions
    - D. **All of the above**

13. Cloud Filestore is based on what filesystem technology?
    - A. **Network File System (NFS)**
    - B. XFS
    - C. EXT4
    - D. ReiserFS

14. When creating resources in Google Cloud, those resources are always part of what?
    - A. **Virtual private cloud**
    - B. Subdomain
    - C. Cluster
    - D. None of the above

15. How will using a cache affect data retrieval?
    - A. A cache improves the execution of client-side JavaScript
    - B. A cache will continue to store data even if power is lost
    - C. Caches can get out of sync with the system of truth
    - D. **Using a cache will reduce latency, since retrieving from a cache is faster than from SSDs or HDDs**

16. Why can cloud providers offer elastic resource allocation?
    - A. Cloud providers take resources from lower-priority customers
    - B. **Extensive resources and the ability to quickly shift resources enables public cloud providers to offer elastic allocation more efficiently than smaller data centers**
    - C. They charge more the more resources you use
    - D. They don't

17. What is NOT a characteristic of specialized services in Google Cloud?
    - A. They are serverless
    - B. They provide a specific function
    - C. **They require monitoring by the user**
    - D. They provide an API

18. Your client's transactions need random access to parts of files on an attached drive. What kind of storage does the attached drive provide?
    - A. Object storage
    - B. **Block storage**
    - C. NoSQL storage
    - D. SQL storage

19. You are deploying a relational database to support a web application. Which storage type would you use for data files?
    - A. Object storage
    - B. Data storage
    - C. **Block storage**
    - D. Cache

20. A user prefers services that require minimal setup. Why recommend Cloud Storage, Cloud Run, and Cloud Functions?
    - A. They are charged only by time
    - B. **They are serverless**
    - C. They require a user to configure VMs
    - D. They can only run applications written in Go
