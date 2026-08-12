# Chapter 2: Designing Solutions to Meet Business Requirements

---

**THE PROFESSIONAL CLOUD ARCHITECT CERTIFICATION EXAM OBJECTIVES COVERED IN THIS CHAPTER INCLUDE THE FOLLOWING:**

- **1.1 Designing a solution infrastructure that meets business requirements**
- **1.2 Designing a solution infrastructure that meets technical requirements**
- **1.5 Envisioning future solution improvements**

---

Cloud architects differ from cloud engineers in their need to work with *business requirements* — collaborating with colleagues in strategy, planning, development, and operations. Business requirements frame the acceptable solution space. On the exam, questions may have multiple technically correct answers; applying business requirements is often what identifies the single best answer (e.g., Cloud SQL over Cloud Spanner for a small single-office app).

Key areas covered in this chapter:

- Business use cases and product strategy
- Application design and cost considerations
- Systems integration and data management
- Compliance and regulations
- Security
- Success measures

---

## Business Use Cases and Product Strategy

Business requirements range from broad strategic objectives to tightly focused specifications. High-level objectives give clues about the shape of a solution, allowing architects to estimate technical requirements even before explicit technical specs are available.

### EHR Healthcare

Explicitly stated business requirements and their technical implications:

| Business Requirement | Technical Implication |
|---|---|
| B2B services; minimize customer onboarding time | Public APIs; likely batch integrations with legacy insurance systems |
| Mix of users (small offices, hospitals, insurers) | Different onboarding/integration needs per customer type |
| 99.9% availability for medical records management | Redundant compute, storage, and networking; no single point of failure |
| Low latency | Multi-region service and data replication |
| Protected health information (PHI) confidentiality | Strict access controls; data lifecycle management |
| Rapid growth; no proportional increase in admin costs | Managed services to reduce operational overhead |
| Derive insights from data | Keep large data volumes; AI/ML managed services (e.g., Vertex AI) |
| Operations in multiple nations | GDPR compliance; region selection for data residency |

### Helicopter Racing League

Business requirements fall into four categories:

1. **Predictive analytics** — improve race predictions; expose models to business partners; increase telemetry data
2. **Increase viewership** — more concurrent viewers, lower latency; drives scalability and geographic distribution requirements
3. **Operations** — minimize operational complexity; ensure regulatory compliance
4. **Revenue** — create a merchandising revenue stream (details vague; requires refinement)

### Mountkirk Games Strategy

- Online, session-based, multiplayer mobile games; already on the cloud
- Customer-facing: support multiple gaming platforms and regions (improves latency and DR)
- Internal: use managed services, pooled resources, and dynamic scaling
- Kubernetes usage suggests Google Kubernetes Engine (GKE) is a likely fit

### TerramEarth Strategy

- Improve prediction of equipment malfunctions (implies Vertex AI, GPUs, TPUs)
- Increase speed and reliability of development workflows
- Enable developers to create custom APIs more efficiently
- Emphasis on developer productivity, including remote workers

**Key takeaway:** Business requirements provide broad context that narrows the feasible technical solution set. They can help rule out exam answer choices — for example, a multi-region storage solution may fail if a regulation requires data to remain in a specific country.

---

## Application Design and Cost Considerations

Business requirements may specify preferences for managed services or tolerance for disruption. Implicit in all requirements is the need to minimize cost while meeting objectives.

**Total Cost of Ownership (TCO)** is the combination of all expenses, including:

- Software licensing costs
- Cloud computing costs (infrastructure + managed services)
- Cloud storage costs
- Data ingress and egress charges
- DevOps personnel costs
- Third-party service costs
- Charges for missed SLAs
- Network connectivity charges (e.g., dedicated on-premises connection)

> Minimize TCO as a whole — not each line item in isolation. Spending more on managed services may reduce personnel costs significantly.

### Managed Services

*Managed services* handle common configuration and maintenance tasks on the customer's behalf (e.g., Cloud SQL handles backups and OS patching).

**When to use managed services:**

- Users do not need low-level control (e.g., OS selection)
- The functionality is difficult or expensive to implement independently (e.g., machine vision)
- No competitive advantage comes from managing the underlying resources (e.g., Spark cluster administration)

**Table 2.1 — Examples of Google Cloud Platform Managed Services**

| Service Name | Service Type | Description |
|---|---|---|
| AutoML Tables | AI and machine learning | Machine learning models for structured data |
| Recommendations AI | AI and machine learning | Personalized recommendations |
| Natural Language AI | AI and machine learning | Entity recognition, sentiment analysis, and language identification |
| Cloud Translation | AI and machine learning | Translate between languages |
| Cloud Vision | AI and machine learning | Understand contents of images |
| Dialogflow Essentials | AI and machine learning | Development suite for voice and text conversational apps |
| BigQuery | Analytics | Data warehousing and analytics |
| Cloud Datalab | Analytics | Interactive data analysis tool based on Jupyter Notebooks |
| Dataproc | Analytics | Managed Hadoop and Spark service |
| Cloud Data Fusion | Data management | Data integration and ETL tool |
| Data Catalog | Data management | Metadata management service |
| Dataflow | Data management | Stream and batch processing |
| Cloud Spanner | Database | Global relational database |
| Cloud SQL | Database | Regional relational database |
| Cloud Deployment Manager | Development | Infrastructure-as-code service |
| Cloud Pub/Sub | Messaging | Messaging service |
| Cloud Composer | Orchestration | Data workflow orchestration service |
| Bigtable | Storage | Wide column, NoSQL database |
| Cloud Data Transfer | Storage | Bulk data transfer service |
| Cloud Memorystore | Storage | Managed cache service using Redis or memcached |
| Cloud Storage | Storage | Managed object storage service |

> ![note](../images/note_24.png) Services change over time and may be generally available or in beta. For the current list, see `cloud.google.com/terms/services`.

### Reduced Levels of Services

Trading lower service levels for lower cost:

- Preemptible VMs instead of standard VMs
- Standard tier networking instead of Premium tier
- Pub/Sub Lite instead of Pub/Sub
- Durable Reduced Availability Storage

#### Preemptible Virtual Machines

- Cost approximately **80% less** than standard VMs
- May be shut down at any time by Google; always shut down after **24 hours**
- GCP signals the VM **30 seconds** before shutdown for graceful termination
- Can have local SSDs and GPUs
- Use a **managed instance group** to automatically replace preempted VMs
- Compatible with managed services like Cloud Dataproc

**Suitable for:** Batch jobs and interruptible workloads.

**Not suitable for:** High-availability services (databases, web servers), stateful applications storing state in memory or local SSD (live migration is not supported; data is lost on shutdown). Use Cloud Memorystore or a database for state if required.

> ![note](../images/note_24.png) Google Cloud also offers **Spot VMs**, similar to preemptible VMs but without the guaranteed 24-hour shutdown limit. At time of writing, Spot VMs were in Pre-GA. This book uses the term *Preemptible VMs* to cover both types.

#### Standard vs. Premium Tier Networking

| Feature | Standard Tier | Premium Tier |
|---|---|---|
| Performance | Similar to other cloud providers; uses public internet | High performance, low latency; traffic carried on Google's network |
| Global SLA | No | Yes |
| Load Balancing | Regional only | Global (cross-region) |
| Cost | Lower | Higher |

#### Pub/Sub Lite vs. Pub/Sub

| Feature | Pub/Sub | Pub/Sub Lite |
|---|---|---|
| Availability/Durability | Higher | Lower |
| Message replication | Multizone within a region | Single zone only |
| Service endpoints | Global and regional | Regional only |
| Scaling | Automatic | User must manage capacity |
| Relative cost | Higher | Up to 85% less |

> Google recommends Pub/Sub as the default managed messaging service.

#### Durable Reduced Availability Storage

| Storage Class | Availability |
|---|---|
| Standard Storage | >99.99% (dual/multi-region); 99.99% (region) |
| Durable Reduced Availability (DRA) | 99% |

> Documentation recommends using Standard Storage unless already using DRA, Multi-Regional, or Regional legacy classes.

### Data Lifecycle Management

Storage options lie on a spectrum from short-term to archival:

- **Memorystore (Cache):** Lowest latency; not durable. Store only data that can be re-fetched or regenerated. Data may disappear at any time.
- **Databases (Cloud SQL, Firestore):** Persistent, actively queried/updated data. Export to object storage when no longer needed for querying.
- **Time-series databases:** Aggregate data progressively as it ages to save space and improve query performance (e.g., minute-level → hourly after 3 days → daily after 1 month).
- **Cloud Storage object storage:**

| Storage Class | Use Case |
|---|---|
| Standard | Frequently accessed data |
| Nearline | Accessed at most once per month |
| Coldline | Accessed at most once per 90 days |
| Archive | Accessed at most once per year |

**Cloud Storage Lifecycle Management** can automate transitions:

- **Actions:** Delete object or change storage class
- **Transition paths:** Standard → Nearline/Coldline/Archive; Nearline → Coldline/Archive; Coldline → Archive; DRA → other classes
- **Lifecycle conditions:** Object age, creation date (CreatedBefore, CustomTimeBefore), days since custom time metadata, storage class, number of versions, days since noncurrent, live/non-live status

Monitor lifecycle actions with Cloud Storage usage logs or Pub/Sub notifications on a bucket.

---

## Systems Integration and Data Management

Business requirements reveal dependencies between systems and how data flows between them.

### Systems Integration Business Requirements

Architects ensure systems work together. Business requirements state what needs to happen to data or what functions users need, without specifying technical implementation details.

#### EHR Healthcare Systems Integration

Legacy file- and API-based integrations with insurers will be replaced (rip-and-replace strategy). New cloud-native systems must address:

- Volume and types of data exchanged
- Service authentication
- Encryption at rest and in transit, with key management
- Decoupling services to absorb demand spikes
- Designing ingestion and data pipelines
- Monitoring, logging (performance and security)
- Multi-region storage/compute with regulatory data residency constraints
- Retiring on-premises systems without disrupting services

#### Helicopter Racing League

Two types of analytics:

1. **Viewer consumption and engagement** — scalable ingestion of geographically distributed viewer behavior data; likely Cloud Dataflow for streaming pipeline
2. **Race predictions** — telemetry data for predictive modeling

Data may be stored in two systems:
- **BigQuery** — scanning hundreds of terabytes across races
- **Bigtable** — low-latency writes and key-based lookups (e.g., time-series for a single viewer over 10 minutes)

#### Mountkirk Games Systems Integration

Multiple datastores in a single game system:

| Data Type | Recommended Store |
|---|---|
| Player data (possessions, characteristics) | Cloud Datastore (document database) |
| Time-series game data | Bigtable |
| Billing/payment data | Relational database (transactional) |

Architects must ensure data consistency across stores (e.g., payment authorization must succeed before adding item to player inventory).

Microservices architecture: each service exposes one function via APIs. Use **Cloud Endpoints** to manage, secure, and monitor API calls. High-risk services (e.g., payment) require stronger security controls.

#### TerramEarth Systems Integration

- Some data collected in batch (when vehicles return to base); some collected in real time
- Future direction: retire batch in favor of real-time uploads from all vehicles
- Use **Cloud Pub/Sub** to decouple and buffer data; prevents loss if ingestion services fall behind
- Data sharing with dealers requires additional design decisions:
  - What data is meaningful to dealers?
  - How should dealers access data? (TerramEarth APIs vs. data pushed to dealer warehouses)

**Key considerations for all systems integration:**

- Structure and volume of data exchanged
- Frequency of data exchange
- Authentication requirements
- Reliability of each system
- Prevention of data loss during failures
- Protection from traffic bursts that could overwhelm receiving services

### Data Management Business Requirements

Minimum data management questions to answer:

1. How much data will be collected and stored?
2. How long will it be stored?
3. What processing will be applied to the data?
4. Who will have access to the data?

#### How Much Data Is Stored?

- Understand expected volumes and growth rate even when using managed services (for cost estimation and storage limit planning)
- Track both rate of new data arrival and rate of data removal to calculate net storage growth

#### How Long Is Data Stored?

- **Cloud Pub/Sub queue:** Data may be retained for minutes to days. Configure a retention period based on business value (e.g., 7-day max if older data has no value). GCP manages capacity automatically.
- **Cloud Storage:** Use lifecycle policies to delete or change storage class as data ages (Standard → Nearline → Coldline → Archive).
- **Databases:** Develop procedures to remove stale data. Consider archiving to Cloud Storage rather than deleting outright — large volumes of historical data may benefit machine learning models.

#### What Processing Is Applied to the Data?

Key considerations:

| Factor | Details |
|---|---|
| Data locality | Distance between storage and processing affects latency and network costs. Use multiregional storage or read replicas for geographically dispersed access. |
| Batch vs. stream | Batch tolerates higher latency; stream requires low latency. Use Cloud Dataflow (managed Apache Beam) for unified batch/stream processing. |
| Late-arriving data | Define a cutoff window (e.g., wait 5 minutes for sensor data). Data not arrived by then is assumed lost. |
| Asynchronous consumption | Producers write to Cloud Pub/Sub; consumers read from the topic. Prevents data loss and enables scalable, parallel processing. |

---

## Compliance and Regulation

Business requirements must be analyzed for regulatory compliance obligations. Regulations apply based on jurisdiction, industry, and the type of data processed.

| Regulation | Scope | Focus |
|---|---|---|
| HIPAA | U.S. healthcare providers and those with access to PHI | Privacy and security of medical information |
| GDPR | EU residents and citizens (applies to any company serving them) | Privacy protections; data residency and transfer restrictions |
| SOX (Sarbanes-Oxley) | U.S. publicly traded companies | Accuracy and integrity of financial statements; anti-fraud |
| COPPA | U.S. websites collecting data from children under 13 | Privacy protections for minors |
| PCI DSS | Any business accepting payment cards | Security controls protecting cardholder data |
| GLBA (Gram-Leach-Bliley) | U.S. banks and financial institutions | Privacy of consumers' nonpublic financial information |
| California Consumer Privacy Act | Companies operating in California | Consumer privacy rights |

More than 40 countries plus the EU and Singapore have privacy regulations.

### Privacy Regulations

Privacy regulations require protecting data throughout its entire lifecycle:

- **Encryption in transit** — encrypt before transmitting to cloud applications
- **Encryption at rest** — Google Cloud provides this by default
- **Access controls** — only authenticated and authorized users and service accounts can access protected data
- **Tamperproof audit logs** — required when data changes must be tracked
- **Network and server protection** — firewalls; Cloud Identity-Aware Proxy (IAP) for request-level authorization
- **Principle of least privilege** — users and service accounts have only the permissions needed for their role
- **Defense in depth** — multiple overlapping security controls; assume any single control may be compromised

### Data Integrity Regulations

Data integrity regulations (e.g., SOX) require:

- Controls preventing tampering with sensitive data
- Ability to demonstrate controls exist (application logs, vulnerability scanner reports, anti-malware reports)
- Message digests and digital signing for tamper-proof data protection where required

Many privacy controls (encryption, firewalls) also serve data integrity goals.

> Always review compliance and regulations with business owners during the design phase — regulatory requirements often overlap with general security best practices.

---

## Security

Security business requirements typically fall into three categories: **confidentiality**, **integrity**, and **availability**.

### Confidentiality

*Confidentiality* limits data access to those with a legitimate business need.

- Use HTTPS; encrypt data at rest (GCP provides this by default)
- **Default encryption:** Google manages keys — lowest overhead
- **Customer-managed encryption keys (CMEK):** Customer controls keys via **Cloud KMS** (keys stored in cloud)
- **Customer-supplied encryption keys (CSEK):** Keys stored outside GCP infrastructure — maximum customer control

During requirements gathering, determine:
- Whether a hardened OS is required (constrains compute service choices)
- Whether multifactor authentication (MFA) is required
- What IAM roles and custom roles are needed
- What level and type of audit logging is required

### Integrity

*Data integrity* ensures data is changed only by authorized users for legitimate purposes.

- **Access controls** are the primary tool — GCP provides fine-grained predefined roles (e.g., App Engine: administrator, code viewer, deployer)
- Identify which business roles need read-only vs. read-write access and assign least-privileged roles accordingly
- Server and network security also contribute

### Availability

*Availability* ensures users can access services, particularly against malicious acts:

- **DDoS attacks** — distributed denial of service
- **Malware infections**
- **Ransomware attacks** — encrypting data without authorization

During requirements gathering, identify unusual availability requirements. Security focuses on preventing malicious acts; reliability focuses on redundancy and failover for component failures.

---

## Success Measures

Decision-makers measure cloud project value to allocate resources effectively. Two primary success measures are **Key Performance Indicators (KPIs)** and **Return on Investment (ROI)**.

### Key Performance Indicators

KPIs are measurable values indicating how well an organization achieves its objectives.

#### Project KPIs

Used to measure migration progress. Examples:
- Volume of data migrated to cloud (no longer on-premises)
- Number of test cases run per day in the cloud
- Number of workload hours running in the cloud

KPI definitions must be precise (e.g., define "workload hour" as wall-clock time × CPU count) and established early in the project.

#### Operations KPI

Used by line-of-business managers to measure operational performance. Examples:
- Retailer: total sales revenue
- Telecom: reduction in customer churn
- Financial institution: number of loan applications reviewed

For architects, KPIs reveal what the business values and what drives investment decisions.

### Return on Investment

ROI measures the monetary value of an investment, expressed as a percentage:

![equation](../images/c02-disp-0001.png)

```
ROI = (Value of Investment - Cost of Investment) / Cost of Investment × 100%
```

- Measured over a fixed period (e.g., 1 year or 3 years)
- Example: $100,000 investment generating $145,000 value over 3 years = **45% ROI over 3 years**

In cloud migrations, the investment includes cloud service costs, employee/contractor costs, and third-party services. Value includes savings from retiring old hardware, reduced power consumption, and new revenue enabled by cloud scalability.

---

## Summary

- Begin cloud projects by understanding business use cases and product strategy — this sets the context for technical requirements.
- Application design must consider managed services, reduced service tiers (lower cost/lower SLA), and data lifecycle management.
- Regulations introduce additional requirements. Common areas: privacy (HIPAA, GDPR, COPPA, GLBA) and data integrity (SOX, PCI DSS).
- Security requirements revolve around three pillars: **confidentiality**, **integrity**, and **availability**.
- Additional security requirements may include nonrepudiation (e.g., signed acknowledgments for digital purchase orders).
- Organizations use **KPIs** and **ROI** to measure project progress and business value. Architects must understand these measures to design systems aligned with business priorities.

---

## Exam Essentials

- **Study all four case studies** (EHR Healthcare, Helicopter Racing League, Mountkirk Games, TerramEarth). They are available during the exam, but familiarity saves time and helps apply business requirements to constrain technical options.
- **Understand TCO, KPIs, and ROI.** You will not need to calculate them, but know what they measure and why executives use them.
- **Know the GCP managed services catalog** and the purposes they serve. Managed services reduce DevOps overhead and enable rapid adoption of capabilities like ML.
- **Understand the four data management questions:** how much data, how long stored, what processing applied, who has access.
- **Know how regulations introduce additional requirements** — HIPAA, GDPR, SOX, COPPA, PCI DSS, GLBA.
- **Know the three security pillars:** confidentiality (limit access), integrity (prevent unauthorized changes), availability (prevent malicious disruption).
- **Know why success measures are used.** KPIs are operation-specific indicators; ROI compares investment cost to realized benefit.

---

## Review Questions

1. In the TerramEarth case study, the volume of data and compute load will be most affected by what characteristics of the TerramEarth systems?
   - A. The number of dealers and customers
   - **B. The number of vehicles, the number of sensors on vehicles, network connectivity, and the types of data collected**
   - C. The type of storage used
   - D. Compliance with regulations

2. You have received complaints from customers about long wait times while loading application pages in their browsers, especially pages with several images. Your director has tasked you with reducing latency when accessing and transmitting data to a client device outside the cloud. Which of the following would you use? (Choose two.)
   - **A. Multiregional storage**
   - B. Coldline storage
   - **C. CDN**
   - D. Cloud Pub/Sub
   - E. Cloud Dataflow

3. Mountkirk Games will analyze game players' usage patterns. This will require collecting time-series data including game state. What database would be a good option for doing this?
   - A. BigQuery
   - **B. Bigtable**
   - C. Cloud Spanner
   - D. Cloud Storage

4. You have been hired to consult with a new data warehouse team. They are struggling to meet schedules because they repeatedly find problems with data quality and must write preprocessing scripts to clean the data. What managed service would you recommend for addressing these problems?
   - A. Cloud Dataflow
   - B. Cloud Dataproc
   - **C. Cloud Dataprep**
   - D. Cloud Datastore

5. You have deployed an application that receives data from sensors on manufacturing equipment. Sometimes more data arrives than can be processed by the current set of Compute Engine instances. Business managers do not want to run additional VMs. What changes could you make to ensure that data is not lost because it cannot be processed as it is sent from the equipment? Assume that business managers want the lowest-cost solution.
   - A. Write data to local SSDs on the Compute Engine VMs.
   - B. Write data to Cloud Memorystore and have the application read data from the cache.
   - **C. Write data from the equipment to a Cloud Pub/Sub queue and have the application read data from the queue.**
   - D. Tune the application to run faster.

6. Your company uses Apache Spark for data science applications. Your manager has asked you to investigate running Spark in the cloud. Your manager's goal is to lower the overall cost of running and managing Spark. What would you recommend?
   - A. Run Apache Spark in Compute Engine.
   - **B. Use Cloud Dataproc with preemptible virtual machines.**
   - C. Use Cloud Data Fusion.
   - D. Use Cloud Memorystore with Apache Spark running in Compute Engine.

7. You are working with a U.S. hospital to extract data from a legacy electronic health record (EHR) system. The hospital has offered to provide business requirements, but there is little information about regulations in the documented business requirements. What regulations would you look to for more guidance on complying with relevant regulations?
   - A. GDPR
   - B. SOX
   - **C. HIPAA**
   - D. PCI DSS

8. What security control can be used to help detect changes to data?
   - A. Firewall rules
   - **B. Message digests**
   - C. Authentication
   - D. Authorization

9. Your company has a data classification scheme for categorizing data as secret, sensitive, private, and public. There are no confidentiality requirements for public data. All other data must be encrypted at rest. Secret data must be encrypted with keys that the company controls. Sensitive and private data can be encrypted with keys managed by a third party. Data will be stored in GCP. What would you recommend to meet these requirements while minimizing cost and administrative overhead?
   - A. Use Cloud KMS to manage keys for all data.
   - **B. Use Cloud KMS for secret data and Google default encryption for other data.**
   - C. Use Google default encryption for all data.
   - D. Use a custom encryption algorithm for all data.

10. You manage a service with several databases. The queries to the relational database are increasing in latency. Reducing the amount of data in tables will improve performance and reduce latency. The application administrator has determined that approximately 60 percent of the data in the database is more than 90 days old and has never been queried and does not need to be in the database. You are required to keep the data for five years in case it is requested by auditors. What would you propose to decrease query latency without increasing costs?
    - A. Horizontally scale the relational database.
    - B. Vertically scale the relational database.
    - **C. Export data more than 90 days old, store it in Cloud Storage Archive class storage, and delete that data from the relational database.**
    - D. Export data more than 90 days old, store it in Cloud Storage multiregional class storage, and delete that data from the relational database.

11. Your company is running several custom applications that were written by developers who are no longer with the company. The applications frequently fail. The DevOps team is paged more for these applications than any others. You propose replacing those applications with several managed services in GCP. A manager notes that the cost of managed services will be more than what they pay for internal servers. What would you recommend as the next step for the manager?
    - A. Nothing. The manager is correct — the costs are higher. You should reconsider your recommendation.
    - **B. Suggest that the manager calculate total cost of ownership, which includes the cost to support the applications as well as infrastructure costs.**
    - C. Recommend running the custom applications in Compute Engine to lower costs.
    - D. Recommend rewriting the applications to improve reliability.

12. A director at an online gaming startup has asked for your recommendation on how to measure the success of the migration to GCP. The director is particularly interested in customer satisfaction. What KPIs would you recommend?
    - A. Average revenue per customer per month
    - **B. Average time played per customer per week**
    - C. Average time played per customer per year
    - D. Average revenue per customer per year

13. Mountkirk Games is implementing a player analytics system. You have been asked to document requirements for a stream processing system that will ingest and preprocess data before writing it to the database. The preprocessing system will collect data about each player for one minute and then write a summary of statistics. The project manager has provided the list of statistics to calculate and a rule for calculating values for missing data. What other business requirements would you ask of the project manager?
    - A. How long to store the data in the database?
    - B. What roles and permissions should be in place to control read access to data in the database?
    - **C. How long to wait for late-arriving data?**
    - D. A list of managed services that can be used in this project.

14. A new data warehouse project is about to start. The data warehouse will collect data from 14 different sources initially, but this will likely grow over the next 6 to 12 months. What managed GCP service would you recommend for managing metadata about the data warehouse sources?
    - **A. Data Catalog**
    - B. Cloud Dataprep
    - C. Cloud Dataproc
    - D. BigQuery

15. You are consulting for a multinational company that is moving its inventory system to GCP. The company wants to use a managed database service, and it requires SQL and strong consistency. The database should be able to scale to global levels. What service would you recommend?
    - A. Bigtable
    - **B. Cloud Spanner**
    - C. Cloud Datastore
    - D. BigQuery

16. TerramEarth has interviewed dealers to better understand their needs regarding data. Dealers would like to have access to the latest data available, and they would like to minimize the amount of data they have to store in their databases and object storage systems. How would you recommend that TerramEarth provide data to their dealers?
    - A. Extract dealer data to a CSV file once per night during off-business hours and upload it to a Cloud Storage bucket accessible to the dealer.
    - **B. Create an API that dealers can use to retrieve specific pieces of data on an as-needed basis.**
    - C. Create a database dump using the database export tool so that dealers can use the database import tool to load the data into their databases.
    - D. Create a user account on the database for each dealer and have them log into the database to run their own queries.

17. Your company has large volumes of unstructured data stored on several network-attached storage systems. The maintenance costs are increasing, and management would like to consider alternatives. What GCP storage system would you recommend?
    - A. Cloud SQL
    - **B. Cloud Storage**
    - C. Cloud Datastore
    - D. Bigtable

18. A customer-facing application is built using a microservices architecture. One of the services does not scale as fast as the service that sends it data. This causes the sending service to wait while the other service processes the data. You would like to change the integration to use asynchronous instead of synchronous calls. What is one way to do this?
    - **A. Create a Cloud Pub/Sub topic, have the sending service write data to the topic, and have the receiving service read from the topic.**
    - B. Create a Cloud Storage bucket, have the sending service write data to the topic, and have the receiving service read from the topic.
    - C. Have the sending service write data to local drives, and have the receiving service read from those drives.
    - D. Create a Bigtable database, have the sending service write data to the topic, and have the receiving service read from the topic.

19. A key initiative at TerramEarth is to use the data that is collected from vehicles to predict when equipment will break down. What managed services would you recommend TerramEarth to consider?
    - A. Bigtable
    - B. Cloud Dataflow
    - **C. Cloud AutoML**
    - D. Cloud Spanner

20. A team of data scientists is more proficient with statistics than with coding extraction, transformation and loading pipelines. The data scientists would like to use a managed service specifically designed for ETL. What GCP service would you recommend?
    - **A. Cloud Data Fusion**
    - B. Cloud BigQuery
    - C. Cloud Data Catalog
    - D. Cloud Pub/Sub
