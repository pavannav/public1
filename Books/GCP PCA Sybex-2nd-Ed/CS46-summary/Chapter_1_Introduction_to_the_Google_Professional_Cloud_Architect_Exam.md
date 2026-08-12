# Chapter 1: Introduction to the Google Professional Cloud Architect Exam

## Exam Objectives Covered

- **Section 1: Designing and planning a cloud solution architecture**
  - 1.1 Designing a solution infrastructure that meets business requirements:
    - Business use cases and product strategy
    - Cost optimization
    - Supporting the application design
    - Integration with external systems
    - Movement of data
    - Design decision tradeoffs
    - Build, buy, modify, or deprecate
    - Success measurements (KPIs, ROI, metrics)
    - Compliance and observability

---

## Overview

The Google Cloud Professional Architect exam is **not a body-of-knowledge exam**. It requires exercising judgment, understanding how business requirements constrain technical options, and answering the kinds of questions a business sponsor might ask. The exam covers:

- Planning cloud solutions
- Managing and provisioning cloud solutions
- Securing systems and processes
- Analyzing and optimizing technical and business processes
- Managing implementations
- Ensuring solution and operations reliability

---

## Analyzing Business Requirements

*Business requirements* define the operational landscape in which a solution is developed. They may be about costs, customer experience, or operational improvements. Rarely satisfied by a single technical decision.

### Reducing Operational Expenses

- **Managed services** reduce administrative workload (e.g., Cloud SQL instead of self-managed MySQL, BigQuery instead of a self-managed data warehouse).
- **Preemptible VMs** — low-cost instances that can be shut down at any time; run up to 24 hours; good for batch processing and easily restarted tasks.
- **Pub/Sub Lite** — order of magnitude less expensive than Pub/Sub but with lower availability and durability; requires more operational work.
- **Autoscaling** — Managed Instance Groups add/remove VMs as demand changes; Cloud Run scales to zero when no traffic.

### Accelerating the Pace of Development

- **Managed services** reduce operational workload and allow teams to implement capabilities (e.g., image processing, NLP) without deep domain expertise.
- **Continuous integration / continuous delivery (CI/CD)** — frequent small releases that are easier to review, debug, and get feedback on.
- **Microservice architecture** — decomposing monolithic applications for independent deployability.
- **Lift and shift** — migrate as-is to cloud; fastest but doesn't leverage cloud-native features.
- **Rip and replace** — rebuild on cloud using cloud-native design; more effort but better long-term outcome.

### Reporting on Service-Level Objectives

- **Service-level objectives (SLOs)** — formalized requirements about availability, durability, and performance.
  - Example: 99.9% availability, 11-nines durability for storage, 2s average page load with 4s at 95th percentile.
- **Cloud Logging** — collects information about significant events (e.g., disk running out of space).
- **Cloud Monitoring** — collects metrics from infrastructure, services, and applications (e.g., CPU utilization, bytes written to network).
- **Service-level indicators (SLIs)** — metrics used to demonstrate compliance with SLOs.

### Reducing Time to Recover from an Incident

- *Incidents* are disruptions that cause a service to be degraded or unavailable, often with multiple contributing root causes.
- Collect metrics and log events; make available to engineers at all times.
- Use **exponential backoff** on retries to avoid flooding a failing system.
- Alert on free disk space, queue sizes, and other leading indicators of failure.

### Improving Compliance with Industry Regulations

Key regulations:

| Regulation | Domain |
|---|---|
| HIPAA | Healthcare privacy |
| COPPA | Children's online privacy |
| SOX | Financial reporting |
| PCI DSS | Credit card data protection |
| GDPR | EU privacy protection |

- Implement fine-grained access controls.
- Follow **least privilege** — grant only permissions needed for a job.
- Separate high-risk duties across multiple roles.

---

### Business Terms to Know

| Term | Definition |
|---|---|
| Capital Expenditure (Capex) | Funds spent to acquire long-lived assets; spread over multiple years |
| Operational Expenditure (Opex) | Expense paid from operating budget for day-to-day operations |
| Compliance | Controls and practices to meet regulatory requirements |
| Digital Transformation | Major business change by adopting IT to improve products, service, and operations |
| Governance | Procedures ensuring policies and principles are followed (responsibility of directors/executives) |
| KPI | Measure of how well a business achieves a key objective |
| Line of Business | Part of a business delivering a particular class of products/services |
| SLA | Agreement between provider and customer defining responsibilities and consequences |
| SLI | A metric reflecting how well an SLO is being met (e.g., latency, throughput, error rate) |
| SLO | An agreed-upon target for a measurable service attribute |

---

## Analyzing Technical Requirements

*Technical requirements* specify functional and nonfunctional features of a system.

### Functional Requirements

#### Understanding Compute Requirements

| Service | Best For |
|---|---|
| Compute Engine | Specific OS or hardened Linux distro required |
| App Engine Flexible | Small number of containers; existing App Engine workloads |
| Cloud Run | Stateless containers not requiring Kubernetes features |
| Kubernetes Engine (GKE) | Large-scale containers, service mesh (Anthos Service Mesh), namespaces |
| Cloud Functions | Event-driven, serverless functions |

#### Understanding Storage Requirements

| Requirement | Recommended Service |
|---|---|
| Global, strongly consistent transactions | Cloud Spanner |
| Regional relational database | Cloud SQL |
| Flexible schema / document store | Cloud Firestore |
| High-volume time-series / low-latency ingest | Bigtable |
| Data warehouse / analytics | BigQuery |
| Long-term archival (frequent access) | Cloud Storage Standard |
| Multiregional/global access | Cloud Storage multiregional or dual-region |
| Infrequent access (≤1×/month, ≥30 days) | Cloud Storage Nearline |
| Rare access (≤1×/quarter, ≥90 days) | Cloud Storage Coldline |
| Very rare access (≤1×/year) | Cloud Storage Archive |

#### Understanding Network Requirements

- **Virtual private clouds (VPCs)** isolate customer resources.
  - Key components: Firewalls/firewall rules, DNS, CIDR blocks, autogenerated and custom subnets, VPC peering.
- **Hybrid connectivity options**:

| Option | When to Use |
|---|---|
| VPN | Low bandwidth; data can traverse public Internet |
| Dedicated Interconnect | Requires 10 Gbps; on-prem PoP co-located with Google PoP |
| Partner Interconnect | No co-location with Google PoP; uses telecom partner equipment |

#### Nonfunctional Requirements

| Property | Definition |
|---|---|
| Availability | Percentage of time service is functioning correctly and accessible |
| Reliability | Probability that a service continues to function under load for a period of time |
| Scalability | Ability to adapt infrastructure to load; autoscalers + managed instance groups |
| Durability | Likelihood that stored objects are retrievable in the future; Cloud Storage = 11 nines |
| Observability | Ability to determine internal state by examining outputs (metrics, logs) |

---

## Exam Case Studies

The exam uses **four case studies** as the basis for some questions. Study them before the exam to save time. They are available at:

- **EHR Healthcare**: `services.google.com/fh/files/blogs/master_case_study_ehr_healthcare.pdf`
- **Helicopter Racing League**: `services.google.com/fh/files/blogs/master_case_study_helicopter_racing_league.pdf`
- **Mountkirk Games**: `services.google.com/fh/files/blogs/master_case_study_mountkirk_games.pdf`
- **TerramEarth**: `services.google.com/fh/files/blogs/master_case_study_terramearth.pdf`

Each case study includes: company overview, solution concept, existing technical environment, business requirements, and executive statement.

### EHR Healthcare

**Overview**: Electronic health records software company; customers in multiple countries; growing business.

**Key Facts**:
- Multiple colocation facilities; one lease expiring soon.
- Containerized apps on Kubernetes; both relational and NoSQL databases.
- Microsoft Active Directory for identity management.
- Open source monitoring tools; alert fatigue issue.

**Business Requirements**: Onboard new clients quickly, 99.9% availability, improve observability, regulatory compliance, reduce admin costs.

**Technical Requirements**: Legacy interface support, standardized container management, high-performance hybrid networking, consistent logging, auto-provisioning of environments, data ingestion interfaces, reduced latency.

**Architecture Considerations**:

| Need | Solution |
|---|---|
| Multi-country low latency + DR | Multiregional deployment; Cloud Spanner for global relational DB |
| Container management | GKE (Autopilot mode to reduce ops) |
| Identity federation with Active Directory | Cloud Identity + AD as IdP |
| Multiple environments / IaC | Cloud Deployment Manager or Terraform |
| CI/CD | Cloud Build + Cloud Source Repository + Artifact Registry |
| Observability | Cloud Monitoring + Cloud Logging |

### Helicopter Racing League

**Overview**: Global sports provider for helicopter racing; streams races globally; provides real-time race predictions.

**Key Facts**:
- Runs on public cloud; truck-mounted mobile data centers at race sites.
- Initial recording/editing in field → uploaded to cloud for VM processing.
- TensorFlow for ML predictions; object storage for content.

**Business Requirements**: Expand predictive analytics (race results, mechanical failures, crowd sentiment), reduce viewer latency, minimize operational complexity, increase telemetry collection, regulatory compliance.

**Technical Requirements**: Improve prediction accuracy, reduce latency, increase video processing performance, additional analytics and data mart services.

**Architecture Considerations**:

| Need | Solution |
|---|---|
| AI/ML | Vertex AI; GPUs/TPUs for TensorFlow models |
| Telemetry ingest | Cloud Pub/Sub |
| Container scaling | GKE with global load balancer |
| MLOps | Vertex Pipelines (automated CI/CD for ML) |
| Low latency for global fans | Premium Tier networking + Cloud CDN |
| Analytics / data marts | BigQuery |

### Mountkirk Games

**Overview**: Mobile multiplayer game developer; migrated on-prem workloads to GCP; building a new game with hundreds of players in geospecific arenas and real-time leaderboard.

**Key Facts**:
- New game on GKE with global load balancer + multiregion Cloud Spanner.
- Existing games running on VMs; eventually migrating to GKE.
- Popular legacy games isolated in own projects; less-trafficked games consolidated.

**Business Requirements**: Multi-device, multi-region, scales to demand; server-side GPU rendering; minimize latency and costs; use managed services; store structured game activity logs; rapid feature deployment.

**Architecture Considerations**:

| Need | Solution |
|---|---|
| Global low-latency gaming | Global load balancing + multiregion GKE |
| Server-side rendering | GPU-enabled VMs or GKE nodes |
| Game activity log storage | Cloud Logging → log sink → BigQuery (structured + analytics) |
| Rapid deployments | CI/CD pipelines |

> **Note**: Cloud Logging stores logs for only 30 days; create a log sink to Cloud Storage or BigQuery for longer retention.

### TerramEarth

**Overview**: Heavy equipment manufacturer for agriculture and mining; 100+ countries, 2M+ vehicles in operation; 20% annual growth.

**Key Facts**:
- Vehicles generate 200–500 MB/day of telemetry; mostly batch-uploaded; small amount real-time.
- Data aggregation and analysis on Google Cloud.
- Legacy inventory/logistics apps in private data centers; multiple network interconnects to GCP.

**Business Requirements**: Predict/detect vehicle malfunctions, just-in-time parts shipment, reduce operational costs, increase development speed, support remote work, provide partner APIs.

**Technical Requirements**: HTTP API layer for legacy systems, modern CI/CD, self-service project creation, cloud-native key management, identity-based access management.

**Architecture Considerations**:

| Need | Solution |
|---|---|
| Real-time telemetry ingest | Cloud Pub/Sub |
| Real-time data processing | Cloud Dataflow (read from Pub/Sub → process → write to storage) |
| Batch upload processing | Cloud Storage → Cloud Dataflow → BigQuery |
| Analytics + ML | BigQuery (with built-in ML via SQL) |
| Complex MLOps workflows | Cloud Composer (directed acyclic graph workflows) |
| Structured ML on sensor data | Vertex AI / AutoML Tables |
| Deep learning models | GPUs / TPUs |

**Example MLOps Workflow (Cloud Composer)**:
1. Train ML model on latest data.
2. If training fails → retry training; do NOT replace existing prediction job.
3. If training succeeds → update prediction job → initiate parts shipment when component failure predicted.

---

## Summary

The exam requires both business and technical skills:

- **Business skills**: Reducing operational expenses, accelerating development, maintaining SLAs, assisting with regulatory compliance.
- **Technical skills**: Functional requirements (compute, storage, networking) and nonfunctional characteristics (availability, scalability, durability, observability).
- Case studies are used as the basis for some exam questions; study them before the exam.

---

## Exam Essentials

- **Every word matters** in case studies and exam questions — technical requirements may be implied in business statements.
- **Study case studies before the exam** — you'll have access during the test, but familiarity saves time. Watch for scale indicators (e.g., 10 Gbps → Cloud Interconnect, not VPN).
- **Plan for the near term AND future** — e.g., TerramEarth may eventually add camera-based image classification with AutoML Vision Edge.
- **Understand migration planning** — run old and new systems in parallel; schedule lower-risk steps first; plan incremental migrations.
- **Know CI/CD and agile practices** — CI/CD, infrastructure as code, and environment management (dev/test/staging/prod).
- **Solutions may include non-Google services** — Jenkins, Spinnaker, GitHub, third-party databases may be part of the answer.

---

## Review Questions

1. When interviewing line-of-business owners, you expect to find:
   - **B** — Business requirements do not have a one-to-one correlation with technical requirements.

2. To reduce operational expenses, recommend:
   - **B** — Managed services, preemptible machines, autoscaling.

3. Justification for CI/CD:
   - **A** — CI/CD supports small releases, which are easier to debug and enable faster feedback.

4. For a 7-year document retention regulation (retrieval within 7 days, 100 TB):
   - **B** — Durability SLO.

5. Definition of *incident* in IT context:
   - **C** — A disruption that causes a service to be degraded or unavailable.

6. Regulation for private medical information (US company):
   - **D** — HIPAA.

7. Global inventory database requiring SQL reporting:
   - **C** — Cloud Spanner.

8. Managed document store (no server management, no backups):
   - **A** — Cloud Firestore.

9. Resource isolating a customer's GCP resources from others:
   - **C** — Virtual private clouds.

10. Replace self-managed MySQL on Compute Engine with managed service:
    - **C** — Cloud SQL.

11. Requirement that points to Compute Engine over App Engine:
    - **C** — Run a hardened Linux distro on a virtual machine.

12. Time-series database for player game data:
    - **A** — Bigtable.

13. Original video files requiring high durability, accessed ≤once in 5 years:
    - **D** — Cloud Storage Archive class.

14. Query up to 10 TB of analytics data:
    - **B** — BigQuery.

15. Google Cloud services to improve observability:
    - **C** — Cloud Monitoring and Cloud Logging.
