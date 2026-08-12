# Chapter 3: Designing Solutions to Meet Technical Requirements

**Google Cloud Certified Professional Cloud Architect Study Guide, 2nd Edition**

---

**THE PROFESSIONAL CLOUD ARCHITECT CERTIFICATION EXAM OBJECTIVES COVERED IN THIS CHAPTER INCLUDE THE FOLLOWING:**

- **1.2 Designing a solution infrastructure that meets technical requirements**

---

The GCP Professional Cloud Architect exam tests the ability to understand both explicitly stated and implied technical requirements from case studies and questions. Technical requirements may specify hardware/software constraints or require inference (e.g., three subnets imply non-overlapping address spaces). Questions often require choosing among multiple solutions by understanding unstated implications.

This chapter covers three broad categories of technical requirements:

- **High availability**
- **Scalability**
- **Reliability**

These properties must be considered not just at the component level but across the **entire application infrastructure**. Highly reliable storage will not confer high reliability on a system if compute or networking services are unreliable.

---

## High Availability

**High availability** is the continuous operation of a system at sufficient capacity to meet the demands of ongoing workloads. It is usually measured as the percentage of time a system is available and responding to requests within an acceptable latency threshold.

### Example Availability SLAs and Corresponding Downtimes

| Percent Uptime | Downtime/Day | Downtime/Week | Downtime/Month |
|---|---|---|---|
| 99.00 | 14.4 minutes | 1.68 hours | 7.31 hours |
| 99.90 | 1.44 minutes | 10.08 minutes | 43.83 minutes |
| 99.99 | 8.64 seconds | 1.01 minutes | 4.38 minutes |
| 99.999 | 864 milliseconds | 6.05 seconds | 26.3 seconds |
| 99.9999 | 86.4 milliseconds | 604.8 milliseconds | 2.63 seconds |

High availability must account for the fact that hardware and software fail. Failures can occur at multiple points in an application stack:

- An application bug
- A dependency service is down
- A database disk drive fills up
- A network interface card fails
- A router is down
- A network engineer misconfigures a firewall rule

**Mitigation strategies:**

- **Redundancy** — writing data to multiple disks, using multiple servers in instance groups, dual network connections with different telecom vendors.
- **DevOps best practices** — code reviews, multi-level testing, staging environments, canary deployments, treating infrastructure as code.

---

### Compute Availability

GCP offers several compute services relevant to availability:

- Compute Engine
- Kubernetes Engine
- App Engine
- Cloud Functions

#### High Availability in Compute Engine

##### Hardware Redundancy and Live Migration

- Large numbers of physical servers provide hardware-level redundancy.
- **Live migration** moves VMs to other physical servers during hardware problems, scheduled maintenance, network/power issues, or security patches — without user-visible disruption.
- Live migration is **not** available for preemptible VMs (they are not designed for high availability).
- At time of writing, VMs with GPUs attached are not available for live migration.

##### Managed Instance Groups

- **Managed instance groups (MIGs)** are clusters of identically configured VMs using an **instance template** (specifying machine type, boot disk image, etc.).
- If a VM fails, a new one is created from the instance template.
- **Autohealing** — application-specific health checks detect malfunctioning apps; failing instances are replaced automatically.
- MIGs use **load balancing** to distribute workload; traffic is rerouted if an instance is unavailable.
- **Regional instance groups** distribute instances across multiple zones — zone failures do not take down the application.

##### Multiple Regions and Global Load Balancing

- Running in multiple regions with a **global load balancer** provides maximum availability and reduces latency for users in different geographies.
- Global load balancer options: **HTTP(S)**, **SSL Proxy**, or **TCP Proxy**.

---

#### High Availability in Kubernetes Engine

- GKE is a managed Kubernetes service for container orchestration.
- VMs in a GKE cluster are members of managed instance groups (same HA features apply).
- Kubernetes continually monitors containers and pods; non-functioning pods are shut down and replaced.
- Kubernetes collects stats (desired pods, available pods) reported to Cloud Monitoring.
- **Regional GKE clusters** distribute VMs across multiple zones; control plane servers (API server, scheduler, resource controller) are also replicated across zones.

---

#### High Availability in App Engine and Cloud Functions

- Both are **fully managed** compute services — Google Cloud Platform ensures high availability.
- Users are not responsible for maintaining availability of compute resources.
- Application-level failures are addressed with software engineering and DevOps best practices.

---

#### High Availability Computing Requirements in Case Studies

- **EHR Healthcare** — Wants a "scalable, resilient platform that can span multiple environments seamlessly." Uses containerized, customer-facing applications on Kubernetes.
- **Helicopter Racing League** — High availability required for both live streaming services and predictive analytics; unavailability during a race would severely impact viewer experience.
- **Mountkirk Games** — Implied HA; new game platform runs on Kubernetes Engine with autoscaling; telemetry/player data services must be highly available.
- **TerramEarth** — Needs highly available data ingestion for 2M+ vehicles (growing 20%/year), dealer-facing APIs, and reliable CI/CD pipelines.

---

### Storage Availability

**Highly available storage** is available and functional at nearly all times. Categories:

- Object storage
- File and block storage
- Database services
- Caching

---

> **Availability vs. Durability**
>
> **Availability** — the percentage of time a system is accessible. **Durability** — the probability that a stored object will remain accessible in the future. A system can be highly available but not durable (e.g., locally attached storage on VMs is available due to live migration, but data is lost if the VM is terminated). Use **Persistent Disk** or **Cloud Filestore** for durability.

---

#### Availability of Object, File, and Block Storage

- **Cloud Storage** — Fully managed object storage; Google maintains high availability; users take no action.
- **Cloud Filestore** — Managed network-attached file storage; high availability ensured by Google.
- **Persistent Disks (PDs)** — SSDs and HDDs attachable to VMs; continue to exist after VM shutdown; support online resizing.

**Persistent Disk Types:**

| Type | Description |
|---|---|
| Zonal standard PD | Efficient/reliable block storage up to 64 TB |
| Regional standard PD | Like zonal standard PD, replicated across two zones in a region |
| Zonal balanced PD | Higher IOPS than standard PD |
| Regional balanced PD | Like zonal balanced PD, replicated across two zones |
| Zonal SSD PD | Higher IOPS than balanced or standard PD |
| Regional SSD PD | Like zonal SSD PD, replicated across two zones |
| Zonal extreme PD | Highest-performance block storage option |

**Durability by type:**

- Zonal standard PDs: better than 99.99%
- Zonal balanced, zonal SSD, regional standard PDs: better than 99.999%
- Zonal extreme PDs, regional SSD PDs: better than 99.9999%

---

#### Availability of Databases

##### Self-Managed Databases

Running databases on VMs requires planning for availability if the DB server or VM fails. Redundancy is the common approach. PostgreSQL options include:

- **Shared disk** — Multiple databases share a disk; standby uses the shared disk if primary fails.
- **Filesystem replication** — Changes on the master's filesystem are mirrored to the failover server.
- **Synchronous multimaster replication** — Each server accepts writes and propagates changes to others.

> Configuring and maintaining highly available self-managed databases is complex. Managed services like Cloud SQL allow enabling high availability with a single console option.

##### Managed Databases

- **Fully managed/serverless** (Cloud Firestore, BigQuery) — Highly available; Google handles all deployment and configuration.
- **User-configurable** (Cloud SQL, Bigtable) — High availability based on regional replication configuration.
  - **Bigtable regional replication** — Primary-primary replication among clusters in different zones; both clusters accept reads and writes; changes are propagated bidirectionally. Also replicates structural changes (column families, tables).

> As the number of replicas increases: higher availability, higher cost, potentially higher write latency (if all replicas must confirm writes). Consider whether the storage system is zone-local or cross-region.

---

#### Availability of Caching

- Caching stores data in low-latency storage (often in-memory) to improve performance.
- Caches are optimized for low latency, often with lower durability; snapshots may be saved to persistent storage.
- **Cloud Memorystore** — Managed high-availability cache service supporting **Memcached** and **Redis**. Preferable to in-memory state in a VM or container (which is lost on failure).

---

#### High Availability Storage Requirements in Case Studies

- **Mountkirk Games** — Global leaderboard uses **Cloud Spanner** (globally consistent, multiregion). Game player state in **Bigtable** (low-latency reads/writes, scalable). Activity logs in **Cloud Storage**; analyzed with **BigQuery** or federated queries.
- **TerramEarth** — Time-series telemetry data → **Bigtable** (high-volume, real-time, low-latency writes, regional replication).
- **EHR Healthcare** — Relational and NoSQL DBs; if self-managed, use regional or zonal PDs based on availability requirements.
- **Helicopter Racing League** — Encoding/transcoding: consider extreme PDs or local SSDs. Object storage → **Cloud Storage**. Race recordings, telemetry, and viewer data → **Bigtable** (key lookup, range scans, time-series). Unstructured audio/video → **Cloud Storage**.

---

### Network Availability

When network connectivity is down, applications are unavailable. Two primary ways to improve availability:

1. **Redundant network connections**
2. **Premium Tier networking**

**Redundant network connections:**

- **Dedicated Interconnect** — Minimum 10 Gbps throughput; does not traverse the public internet. Requires a shared point of presence between your network and Google's.
- **Partner Interconnect** — Used when no shared point of presence exists. Traffic flows from your data center through a telecom provider's network to Google Cloud; does not use the public internet.
- **HA VPN** — Google Cloud's high-availability VPN; uses redundant connections; offers a **99.99% SLA**.

**Network tiers:**

- **Premium Network Tier** — Uses Google's internal network; designed for high availability and low latency. Required for global load balancing.
- **Standard Network Tier** — Uses the public internet; lower cost.

#### High Availability Network Requirements in Case Studies

Case studies do not provide explicit networking requirements beyond the implied expectation that the network is always available. Architects should inquire about:

- Whether Premium Tier networking is required.
- Whether multiple network connections between on-premises and Google data centers are needed.

---

### Application Availability

**Application availability** builds on compute, storage, and networking availability, plus the application itself. Designing software for high availability is beyond this book's scope and is unlikely to be tested directly.

Key tools for observing application state:

- **Cloud Monitoring** — Detect problems early.
- **Cloud Logging** — Diagnose issues.
- **Custom metrics** — Instrument applications for application-specific diagnostics.

---

## Scalability

**Scalability** is the process of adding and removing infrastructure resources to meet workload demands efficiently.

Examples of scaling characteristics:

- VMs in a MIG scale by adding or removing instances.
- Kubernetes scales pods based on load and configuration parameters.
- NoSQL databases scale horizontally but introduce consistency trade-offs.
- Relational databases require clock synchronization for horizontal scaling with strong consistency. **Cloud Spanner** uses the **TrueTime service** (atomic clocks + GPS signals) to ensure a low upper bound on clock differences in distributed systems.

**General rules:**

- **Stateless applications** — Easy to scale horizontally.
- **Stateful applications** — Difficult to scale horizontally; vertical scaling is often the first choice. Alternatively, move state to a cache (Cloud Memorystore) or database.
- Resources that scale at different rates should be **decoupled** (e.g., front-end vs. database).
- For resources that are difficult to scale (relational databases except Spanner, network interconnects), **deploy for peak capacity**.

---

### Scaling Compute Resources

Compute Engine and Kubernetes Engine support automatic scaling. App Engine and Cloud Functions autoscale automatically (managed by GCP).

#### Scaling Compute in Compute Engine

- **Managed instance groups** support autoscaling (scaling out = adding VMs; scaling in = removing VMs).
- Autoscaling is **not available** when a MIG has a stateful configuration.
- **Unmanaged instance groups** do not support autoscaling.
- Compute Engine autoscaling should not be used on MIGs owned by GKE; use cluster autoscaling instead.

**Autoscaling metrics:**

- Average CPU utilization
- HTTP load balancing utilization
- Customer monitoring (Cloud Monitoring) metrics

The autoscaler compares collected metrics to targets in an autoscaling policy. When multiple metrics are configured, the autoscaler calculates a recommended VM count per metric and **chooses the maximum**.

**Scheduling and prediction:**

- **Scaling schedules** — Set minimum VMs by time (start time, duration, recurrence: daily/weekly).
- **Predictive autoscaling** — Forecasts future loads (best for applications with long startup times and predictable workload patterns over days/weeks).

**Autoscaling timing concepts:**

| Term | Description |
|---|---|
| Cooldown period | Time for a new VM's application to initialize (default: 60 seconds). Data from VMs in cooldown is used for scale-in decisions but not scale-out. |
| Stabilization period | The previous 10 minutes; autoscaler ensures enough VMs to meet peak load during this window. |
| Trailing time window | Time window the autoscaler monitors for scaling decisions; limits abrupt scale-in events by specifying a maximum allowed reduction in VMs. |

- Before a VM is removed, it can optionally run a **shutdown script** (best-effort basis).
- When an instance is added, it is configured from the **instance template**.

---

#### Scaling Compute in Kubernetes Engine

Kubernetes does not scale containers directly; autoscaling is based on Kubernetes abstractions.

**Key abstractions:**

| Abstraction | Description |
|---|---|
| Pod | Smallest computational unit; contains one or more tightly coupled containers. |
| Node | VM in a managed instance group that runs pods. |
| Node pool | Set of nodes with the same configuration. |
| Deployment | Specifies updates for pods and ReplicaSets. |
| ReplicaSet | Set of identically configured pods running at a point in time. |
| Service | Stable abstraction for accessing a deployment's pods (abstracts dynamic IP addresses). |

**Scaling mechanisms:**

- **Cluster autoscaling** — GKE automatically adds nodes when a new pod cannot be scheduled due to insufficient resources.
- **Pod/replica autoscaling** — Specify min/max replicas and a target resource (e.g., CPU utilization at 80%). Since GKE 1.9, custom Cloud Monitoring metrics can be used as targets.
- **Canary deployment** — A new deployment runs alongside the existing one; a small amount of traffic is routed to it for production testing without full exposure.

---

### Scaling Storage Resources

- **Locally attached SSDs** — Least scalable; data is lost on VM termination/stop; not persistent.
- **Zonal/regional persistent disks and SSDs** — Scale up to 64 TB per VM instance.

**Persistent disk performance:**

| Type | Max Sustained Read IOPS | Max Sustained Write IOPS |
|---|---|---|
| Standard PD | 0.75 per GB | 1.5 per GB |
| Persistent SSD | 30 per GB | 30 per GB |

- Standard PDs: better for large-volume batch processing (low cost, high volume).
- Persistent SSDs: better for database workloads (performance-sensitive).

Adding storage to a VM is a **two-step process**:
1. Allocate persistent storage.
2. Issue OS-level commands to make storage available to the filesystem (OS-specific).

**Managed services** (Cloud Storage, BigQuery) scale storage automatically. For BigQuery, **partitioning** data improves query performance and reduces cost (BigQuery charges by data scanned).

---

### Network Design for Scalability

- Connectivity between on-premises and Google data centers **does not scale dynamically** like compute or storage.
- **Plan ahead for peak capacity** — though you may only pay for bandwidth used, depending on provider.

---

## Reliability

**Reliability** is a measure of the likelihood that a system is available and able to meet the needs of the load on the system. Reliability requirements may be explicit or implicit.

Designing for reliability requires:

1. Minimizing the chance of system failures (redundancy, DevOps best practices — same as availability).
2. Planning how to respond when systems do fail.

Distributed applications may depend on multiple **microservices**, each with its own dependencies (internal teams or third-party services).

---

### Measuring Reliability

- **Total system uptime** — Simple but can be misleading for distributed systems (e.g., if 1 VM out of many is up, is the system "up"?).
- **Successful request rate** — Percentage of all application requests successfully responded to. Better metric because:
  - Easy to calculate.
  - Directly reflects user experience.

> Rather than focus on implementation metrics (number of instances available), reliability is **better measured as a function of the work performed by the service**.

---

### Reliability Engineering

Architects should address reliability during the **design stage**:

- **Identify how to monitor services** — Will they require custom metrics?
- **Consider alerting conditions** — Balance early detection with avoiding unactionable alert overload for DevOps teams.
- **Integrate with existing incident response procedures** — Add specialized procedures if needed (e.g., notify information security for incidents involving PII access control failures).
- **Implement a system for tracking outages and post-mortems** — Understand why disruptions occurred.

> Designing for reliability engineering emphasizes **organizational and management issues**, unlike high availability and scalability, which are dominated by technical considerations. Architects have both technical and management responsibilities.

---

## Summary

Architects work with both explicit technical requirements (e.g., "store 10 TB/day," "support SQL") and **implied** requirements (e.g., a streaming app accepting late-arriving data implies buffering and a late-data threshold).

Technical requirements fall into two categories:

1. **Constraint statements** — e.g., must use MySQL 8.0.
2. **Derived requirements** — analyzed from multiple business needs, often related to high availability, scalability, and reliability.

Compute, storage, and networking services must be designed to support the levels of availability, scalability, and reliability the business requires.

---

## Exam Essentials

- **Understand the differences between availability, scalability, and reliability.**
  - *High availability* — Continuous operation at sufficient capacity; measured as percentage of uptime.
  - *Scalability* — Adding/removing infrastructure resources to meet workload demands efficiently.
  - *Reliability* — Likelihood a system is available and capable of meeting load demands.

- **Understand how redundancy is used to improve availability.**
  - Compute: Clusters of identical VMs behind a load balancer.
  - Storage: Multiple copies of data.
  - Networking: Multiple direct connections between data center and Google Cloud.
  - Redundancy must be combined with autohealing or autorepair.

- **Know that managed services relieve users of many responsibilities for availability and scalability.**
  - Services like Cloud Storage are highly available and scalable without user configuration.

- **Understand how Compute Engine and Kubernetes Engine achieve high availability and scalability.**
  - Compute Engine: Managed instance groups with instance templates and autoscalers.
  - Kubernetes Engine: Pods scale to meet deployment demands; clusters autoscale nodes to meet pod resource requirements.

- **Understand reliability engineering is about managing risk.**
  - Minimize failure chance through redundancy and DevOps best practices.
  - Measure reliability by successful request rate (function of work performed), not just instance count.

---

## Review Questions

1. You are advising a customer on how to improve the availability of a data storage solution. Which of the following general strategies would you recommend?
   1. Keeping redundant copies of the data
   2. Lowering the network latency for disk writes
   3. Using a NoSQL database
   4. Using Cloud Spanner

2. A team of data scientists is analyzing archived data sets. Their statistical model building procedures run in batches. If the model building system is down for up to 30 minutes per day, it does not adversely impact the data scientists' work. What is the minimal percentage availability among the following options that would meet this requirement?
   1. 99.99 percent
   2. 99.90 percent
   3. 99.00 percent
   4. 99.999 percent

3. Your development team has recently triggered three incidents that resulted in service disruptions. In one case, an engineer mistyped a number in a configuration file and in the other cases specified an incorrect disk configuration. What practices would you recommend to reduce the risk of these types of errors?
   1. Continuous integration/continuous deployment
   2. Code reviews of configuration files
   3. Vulnerability scanning
   4. Improved access controls

4. Your company is running multiple VM instances that have not had any downtime in the past several weeks. Recently, several of the physical servers suffered disk failures. The applications running on the servers did not have any apparent service disruptions. What feature of Compute Engine enabled that?
   1. Preemptible VMs
   2. Live migration
   3. Canary deployments
   4. Redundant array of inexpensive disks

5. You have deployed an application on a managed instance group. Occasionally the application experiences an intermittent malfunction and then resumes normal operation. Which of these is a reasonable explanation for what is happening?
   1. The application shuts down when the instance group time-to-live (TTL) threshold is reached.
   2. The application shuts down when the health check fails.
   3. The VM shuts down when the instance group TTL threshold is reached and a new VM is started.
   4. The VM shuts down when the health check fails and a new VM is started.

6. An online gaming company is growing its user base in North America, Europe, and Asia. Executives are concerned that players in Europe and Asia will have a degraded experience if the game backend runs only in North America. What would you suggest to improve latency and game experience for users in Europe and Asia?
   1. Use Cloud Spanner to have a globally consistent, horizontally scalable relational database.
   2. Create instance groups running the game backend in multiple regions across North America, Europe, and Asia. Use global load balancing to distribute the workload.
   3. Use Standard Tier networking to ensure that data sent between regions is routed over the public internet.
   4. Use a Cloud Memorystore cache in front of the database to reduce database read latency.

7. What configuration changes are required to ensure high availability when using Cloud Storage or Cloud Filestore?
   1. A sufficiently long TTL must be set.
   2. A health check must be specified.
   3. Both a TTL and health check must be specified.
   4. Nothing. Both are managed services. GCP manages high availability.

8. The finance director at your company is frustrated with the poor availability of an on-premises finance data warehouse. The data warehouse uses a commercial relational database that only scales by buying larger and larger servers. The director asks for your advice about moving the data warehouse to the cloud and if the company can continue to use SQL to query the data warehouse. What GCP service would you recommend to replace the on-premises data warehouse?
   1. Bigtable
   2. BigQuery
   3. Cloud Datastore
   4. Cloud Storage

9. TerramEarth has determined that it wants to use Cloud Bigtable to store equipment telemetry received from vehicles in the field. It has also concluded that it wants two clusters in different regions. Both clusters should be able to respond to read and write requests. What kind of replication should be used?
   1. Primary–hot primary
   2. Primary–warm primary
   3. Primary–primary
   4. Primary read–primary write

10. Your company is implementing a hybrid cloud computing model. Line-of-business owners are concerned that data stored in the cloud may not be available to on-premises applications. The current network connection is using a maximum of 40 percent of bandwidth. What would you suggest to mitigate the risk of that kind of service failure?
    1. Configure firewall rules to improve availability.
    2. Use redundant network connections between the on-premises data center and Google Cloud.
    3. Increase the number of VMs allowed in Compute Engine instance groups.
    4. Increase the bandwidth of the network connection between the data center and Google Cloud.

11. A team of architects in your company is defining standards to improve availability. In addition to recommending redundancy and code reviews for configuration changes, what would you recommend including in the standards?
    1. Use of access controls
    2. Use of managed services for all compute requirements
    3. Use of Cloud Monitoring to alert on changes in application performance
    4. Use of Bigtable to collect performance monitoring data

12. Why would you want to run long-running, compute-intensive backend computation in a different managed instance group than on web servers supporting a minimal user interface?
    1. Managed instance groups can run only a single application.
    2. Managed instance groups are optimized for either compute or HTTP connectivity.
    3. Compute-intensive applications have different scaling characteristics from those of lightweight user interface applications.
    4. There is no reason to run the applications in different managed instance groups.

13. An instance group is adding more VMs than necessary and then shutting them down. This pattern is happening repeatedly. What would you do to try to stabilize the addition and removal of VMs?
    1. Increase the maximum number of VMs in the instance group.
    2. Decrease the minimum number of VMs in the instance group.
    3. Increase the time autoscalers consider when making decisions.
    4. Decrease the cooldown period.

14. A clothing retailer has just developed a new feature for its customer-facing web application. Customers can upload images of their clothes, create montages from those images, and share them on social networking sites. Images are temporarily saved to locally attached drives as the customer works on the montage. When the montage is complete, the final version is copied to a Cloud Storage bucket. The services implementing this feature run in a managed instance group. Several users have noted that their final montages are not available even though they saved them in the application. No other problems have been reported with the service. What might be causing this problem?
    1. The Cloud Storage bucket is out of storage.
    2. The locally attached drive does not have a filesystem.
    3. The users experiencing the problem were using a VM that was shut down by an autoscaler, and a cleanup script did not run to copy the latest version of the montage to Cloud Storage.
    4. The network connectivity between the VMs and Cloud Storage has failed.

15. Your development team has implemented a new application using a microservices architecture. You would like to minimize DevOps overhead by deploying the services in a way that will autoscale. You would also like to run each microservice in containers. What is a good option for implementing these requirements in Google Cloud Platform?
    1. Run the containers in Cloud Functions.
    2. Run the containers in Kubernetes Engine.
    3. Run the containers in Cloud Dataproc.
    4. Run the containers in Cloud Dataflow.

16. TerramEarth is considering building an analytics database and making it available to equipment designers. The designers require the ability to query the data with SQL. The analytics database manager wants to minimize the cost of the service. What would you recommend?
    1. Use BigQuery as the analytics database, and partition the data to minimize the amount of data scanned to answer queries.
    2. Use Bigtable as the analytics database, and partition the data to minimize the amount of data scanned to answer queries.
    3. Use BigQuery as the analytics database, and use data federation to minimize the amount of data scanned to answer queries.
    4. Use Bigtable as the analytics database, and use data federation to minimize the amount of data scanned to answer queries.

17. Line-of-business owners have decided to move several applications to the cloud. They believe the cloud will be more reliable, but they want to collect data to test their hypothesis. What is a common measure of reliability that they can use?
    1. Mean time to recovery
    2. Mean time between failures
    3. Mean time between deployments
    4. Mean time between errors

18. A group of business executives and software engineers are discussing the level of risk that is acceptable for a new application. Business executives want to minimize the risk that the service is not available. Software engineers note that the more developer time dedicated to reducing risk of disruption, the less time they have to implement new features. How can you formalize the group's tolerance for risk of disruption?
    1. Request success rate
    2. Uptime of service
    3. Latency
    4. Throughput

19. Your DevOps team recently determined that it needed to increase the size of persistent disks used by VMs running a business-critical application. When scaling up the size of available persistent storage for a VM, what other step may be required?
    1. Adjusting the filesystem size in the operating system
    2. Backing up the persistent disk before changing its size
    3. Changing the access controls on files on the disk
    4. Updating disk metadata, including labels
