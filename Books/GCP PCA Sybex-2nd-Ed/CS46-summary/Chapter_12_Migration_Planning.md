# Chapter 12: Migration Planning

---

![note](../images/note_24.png) **PROFESSIONAL CLOUD ARCHITECT CERTIFICATION EXAM OBJECTIVES COVERED IN THIS CHAPTER INCLUDE THE FOLLOWING:**

- **1.4 Creating a migration plan (i.e. documents and architectural diagrams)**

---

For many organizations, cloud computing is a new approach to delivering information services. Organizations with large, complex on-premises infrastructures want to realize the advantages of cloud computing by migrating existing applications. Migration requires methodical planning that includes the following:

- Integrating cloud services with existing systems
- Migrating systems and data to support a solution
- Software license mapping
- Network planning
- Testing and proof-of-concept development
- Dependency management planning

---

## Integrating Cloud Services with Existing Systems

Cloud migrations are inherently about incrementally changing existing infrastructure to use cloud services. During migrations, some applications move to the cloud while remaining integrated with other applications still running on premises. A four-step migration framework helps structure this work:

1. **Assess**
2. **Plan**
3. **Deploy**
4. **Optimize**

### Assessment Phase

- Take inventory of applications and infrastructure.
- Document compliance, licensing, and dependency considerations.
- Not all applications are cloud candidates (e.g., a legacy mainframe app scheduled for retirement in two years is not a good candidate).
- Consider migrating one or two applications early to learn about cloud operations, develop experience, and gauge level of effort for networking and security.
- Perform a **total cost of ownership (TCO)** assessment.
- Determine the order in which workloads will be migrated.

### Planning Phase

- Define foundations of the cloud environment: **resource organization hierarchy**, identities, groups, and roles.
- Three resource hierarchy design options:
  - **Environment-oriented**: separates development, test, and production resources.
  - **Functional organization**: separates business functions into folders.
  - **Granular-oriented**: additional folder layers implementing further organizational levels.
- Plan user and service account identity management, including whether to use G Suite or Cloud Identity, and whether to integrate an existing identity provider.
- Structure roles for resource hierarchy managers, network administration, and security.
- Plan network topology and connectivity.

### Deployment Phase

- Choose a deployment approach:
  - **Fully manual deployments**: simple, fast, suitable for proof-of-concept only.
  - **Automated replication services** for production workloads:
    - **Migrate for Compute Engine**: migrates VM-based applications.
    - **Migrate for Anthos**: converts VM workloads to containers in GKE.
    - **Google Cloud SQL**: provides replication support for on-premises database migrations.
    - **VMware Engine**: migrates VMware workloads to Google Cloud VMware Engine.
- Use **configuration management tools** (Puppet, Ansible, Chef, Salt) to automate configuration after provisioning VMs.
- Use **GKE deployment services** when deploying to Google Kubernetes Engine.
- Use **infrastructure-as-code (IaC)** tools such as **Terraform** or **Deployment Manager** to provision cloud resources.
- Consider application data dependencies and security requirements for each data source.
- Decide how to migrate data:
  - `gsutil` for smaller volumes.
  - **Google Cloud Transfer Appliance** for large volumes.
- If data is being updated during migration, develop a synchronization strategy.
- For application migration:
  - **Lift-and-shift**: migrate VMs from on-premises to the cloud.
  - **VM-to-container**: migrate VM-based applications to containers running on Kubernetes clusters.

### Optimization Phase

- Add monitoring and logging to applications.
- Improve reliability using multiregional features such as **global load balancing**.
- Replace third-party tools (e.g., ETL tools) with GCP services such as **Cloud Dataflow**.
- Consider using **managed database services** instead of self-managed databases.

---

## Migrating Systems and Data to Support a Solution

### Planning for Systems Migrations

During the assessment phase, document the characteristics of each application that may be migrated. Key factors to document include:

| Factor | Details |
|---|---|
| **Criticality (Tier)** | Tier 1 = must be available 24/7; Tier 2 = batch/tolerant; Tier 3 = all others |
| **Production level** | Production, staging, test, development |
| **Support availability** | Third-party vs. in-house development; vendor status; in-house expertise |
| **SLAs** | Downtime tolerance; compliance requirements |
| **Documentation quality** | Design, runtime, architecture docs; troubleshooting guides |
| **Cloud readiness** | A Dockerized app needs minimal changes; apps requiring unavailable OSes are problematic |
| **Database dependencies** | Read/write databases; HA status; failover locations; RTO |
| **Other dependencies** | Identity management, messaging, monitoring, log collection, backup |
| **Deployment automation** | Level of automation; manual operations required |

These answers inform:

- Level of migration **risk**
- Level of **effort** required
- **Dependency mapping** between applications
- **Tolerable downtime** for switchover

#### Switchover Considerations

- If **no downtime** is acceptable: run both cloud and on-premises systems in parallel before switching traffic.
- Carefully manage **state information** to maintain consistency in distributed systems.
- Use scheduled **maintenance windows** for Tier 1/2 switchovers.
- For **Tier 3** applications, a simple user notification of downtime may suffice.

#### Deployment After Migration

- If deployment is already automated, the same processes may be reused in the cloud.
- CI/CD systems (e.g., Jenkins) must also be in place in the cloud, or replaced with GCP services such as **Cloud Build**.
- Plan monitoring: e.g., use **Cloud Logging** if open to system modification.
- Consider business ROI factors (e.g., avoided hardware refresh, scalability constraints).

---

### Planning for Data Migration

#### Data Governance and Data Migration

Before migrating data, understand all applicable regulations:

- **HIPAA** (United States): governs privacy of personal healthcare data.
- **GDPR** (European Union): restricts where data on EU citizens may be stored.
- Internal data classification and governance policies must also be investigated.

---

#### Migrating Object Storage

Archived, large object, or filesystem data may be migrated to **Cloud Storage**. Steps include:

- Plan the structure of buckets.
- Determine roles and access controls.
- Understand time and cost of migrating data.
- Plan the order of data transfer.
- Determine the transfer method.

**Transfer method decision guide:**

| Data Volume | Recommended Method |
|---|---|
| Less than 10 TB (with ≥100 Mbps bandwidth) | `gsutil` |
| Between 10 TB and 20 TB | Evaluate time/cost; use `gsutil` if acceptable, otherwise Transfer Appliance |
| Over 20 TB | Google Transfer Appliance |

---

![note](../images/note_24.png) Google has a table of transfer times by network bandwidth and data size at `cloud.google.com/solutions/transferring-big-data-sets-to-gcp`.

---

#### Migrating Relational Data

Consider both data volume and database usage/SLA constraints.

**Option 1: Export, transfer, and import**

- Export data from source database, transfer to cloud, import into cloud database.
- Database must be **unavailable** to users during migration.
- Database should be **locked for writes** during export (read access is acceptable).
- After import, configure database applications to point to the new cloud database.

**Option 2: Primary/replica replication (preferred)**

- Create a **replica** of the database in Google Cloud.
- Also called *primary/replica* or *leader/follower* configuration.
- Changes to the primary are replicated to the cloud replica.
- Once synchronized, redirect database applications to the cloud database.
- Preferred method when SLAs or requirements do not allow extended downtime.

**Google Cloud Database Migration Service**

- Supports **PostgreSQL** and **MySQL** databases to Cloud SQL (SQL Server support expected in future).
- Supports both **lift-and-shift migration** and **continuous replication**.
- When a migration is created, a **read replica** is created in Cloud SQL.
- When ready to switch, **promote** the Cloud SQL replica to become the primary (read/write).

---

## Software Licensing Mapping

When migrating to the cloud, review all licenses for operating systems, applications, middleware, and third-party tools. Options for software licensing in the cloud:

| Model | Description |
|---|---|
| **Included licensing** | License cost is bundled with cloud service charges (e.g., Windows Server OS cost included in VM hourly charge) |
| **Pay-as-you-go / Metered model** | Charged per hour or unit of usage in the cloud |
| **Bring-your-own-license (BYOL)** | Use an existing license in the cloud; must verify transferability |

**Important notes:**

- Do **not** assume an on-premises license automatically applies to cloud use; verify with the vendor.
- Watch for licenses based on **physical core or physical processor** (e.g., Microsoft SharePoint, SQL Server) — these may require **sole-tenant nodes** in Google Cloud.

**Steps for bringing an existing license to Google Cloud (BYOL):**

1. Prepare images according to license requirements.
2. Activate licenses.
3. Import virtual disk files and create images.
4. Create sole-tenant node templates.
5. Create sole-tenant node groups.
6. Provision VMs on the node groups with the virtual disk files.
7. Track license usage.
8. Report license usage to your vendor.

For additional details, see `cloud.google.com/compute/docs/nodes/bringing-your-own-licenses`.

Use the **IAP Desktop** tool (`github.com/GoogleCloudPlatform/iap-desktop/releases/tag/2.21.681`) to help monitor and report on license usage on sole-tenant nodes.

- Also consider whether existing licenses (e.g., single site licenses) map appropriately to new cloud usage patterns (e.g., multi-region deployment).
- Evaluate all options (BYOL vs. pay-as-you-go) and choose the best fit for how the application will be used.

---

## Network Planning

Network planning applies whether you are migrating fully to the cloud, partially (hybrid), or planning for a transition period. Network migration planning is broken down into four broad categories:

- **Virtual private clouds (VPCs)**
- **Access controls**
- **Scaling**
- **Connectivity**

---

![note](../images/note_24.png) This chapter briefly describes networking considerations for migration planning. For more details on GCP networking, see Chapter 6, "Designing Networks."

---

### Virtual Private Clouds

VPCs are collections of networking components and configurations that organize cloud infrastructure. Components include:

- Networks
- Subnets
- IP addresses
- Routes
- Virtual private networks (VPNs)

VPC infrastructure is built on Google's **software-defined networking** platform.

**RFC 1918 private address ranges:**

| Range | Available Addresses |
|---|---|
| 10.0.0.0 – 10.255.255.255 | 16,777,216 |
| 172.16.0.0 – 172.31.255.255 | 1,048,576 |
| 192.168.0.0 – 192.168.255.255 | 65,546 |

**Subnet management:**

- **Auto mode**: Google creates a subnet in each region automatically — useful when not connecting to other networks.
- **Custom mode networks** (recommended): Full control over which regions have subnets and their address ranges.

**IP addresses:**

- VMs can have both **internal** (within VPC) and **external** (optional, for external communication) IP addresses.
- External addresses can be **ephemeral** or **static**.
- Use **static** IP addresses for consistent long-term needs (e.g., public websites or API endpoints).

**Routes:**

- Auto-generated when VPCs are created (default routes between subnets).
- Custom routes can be created for **many-to-one NAT** or **transparent proxies**.

**Cloud VPN:**

- Links Google Cloud VPC to on-premises or other cloud networks (AWS, Azure) via **IPSec tunnels**.
- Available as **Classic VPN** and **HA VPN** (some Classic VPN features deprecated March 31, 2022).
- **HA VPN** recommended: provides **99.99% availability** using two interfaces and two IP addresses.
- A single VPN gateway sustains up to **3 Gbps**; use additional gateways or Cloud Interconnect for higher bandwidth.

---

### Network Access Controls

Plan IAM roles for controlling access to network management functions:

| Role | Permissions |
|---|---|
| **Network Admin** | Full permissions to manage network resources |
| **Network Viewer** | Read-only access to network resources |
| **Security Admin** | Manage firewall rules and SSL certificates |
| **Compute Instance Admin** | Manage VM instances |

**Firewall rules** control traffic flow between subnets and networks. For each rule, define:

- Traffic **protocol** (e.g., TCP, IP)
- Direction: **ingress** (incoming) or **egress** (outgoing)
- **Priority** (higher-priority rules take precedence)

---

### Scaling

**Cloud load balancing** distributes traffic globally using a single **anycast IP address**.

| Load Balancing Type | Layer | Use Case |
|---|---|---|
| HTTP(S) load balancing | Layer 7 (Application) | Distribute traffic across regions; route to nearest healthy node; route by content type |
| Network load balancing | Layer 4 | Handle TCP/IP traffic spikes; support additional protocols; session affinity |

- **Cloud CDN** (Content Delivery Network): Distribute static/large content (e.g., video) globally with low latency.
- **Cloud DNS**: Google-managed DNS service for high-availability, low-latency global service availability.

---

### Connectivity

For hybrid cloud scenarios, plan networking between Google Cloud and on-premises data centers.

**Cloud Interconnect** options (routes traffic directly to Google Cloud, bypassing public internet):

| Option | Description |
|---|---|
| **Dedicated Interconnect** | Direct physical connection between Google Cloud and on-premises network |
| **Partner Interconnect** | Connection via a telecom service provider that connects to both on-premises and Google Cloud networks |

See `cloud.google.com/interconnect/pricing` for details on capacities and costs.

---

## Summary

Migration planning requires broad scope planning from business service considerations to network design. Key areas include:

- **Integration with existing systems**: Best addressed using a four-step plan — assessment, plan, deploy, optimize.
- **Systems and data migration**: Understand dependencies, SLA commitments, and risk before migrating. Migrate data first, then applications.
- **Database migration**: Takes additional planning to avoid data loss or disruption; replication-based methods are preferred.
- **Software licensing**: Review all licenses; options include BYOL, pay-as-you-go, or bundled with cloud charges.
- **Network planning**: Plan VPCs, network access controls, scalability, and connectivity.

---

## Exam Essentials

- **Cloud migrations are inherently about incrementally changing existing infrastructure to use cloud services.** Careful planning minimizes the risk of disrupting services and maximizes the likelihood of successfully moving applications and data to the cloud.

- **Know the four stages of migration planning: assessment, planning, deployment, and optimization.** Assessment = inventory of apps and infrastructure. Planning = define resource hierarchy, identities, roles, groups. Deployment = move data and applications in a logical order. Optimization = add monitoring, improve reliability, replace tools with GCP services.

- **Understand how to assess the risk of migrating an application.** Considerations include SLAs, system criticality, support availability, documentation quality, dependencies (upstream and downstream), and challenging migration operations such as database replication switchovers.

- **Understand how to map licensing to how you will use licensed software in the cloud.** OS, application, middleware, and third-party tools all have licenses. Options: license included in cloud charges, BYOL, or pay-as-you-go/metered model. Verify license transferability with vendors; watch for physical-core-based licenses requiring sole-tenant nodes.

- **Know the steps involved in planning a network migration.** Four categories: VPCs, access controls, scaling, and connectivity. Plan networks, subnets, IP addresses, routes, and VPNs. Plan for linking on-premises networks to Google Cloud using VPNs or Cloud Interconnect.

---

## Review Questions

1. Your midsize company has decided to assess the possibility of moving some or all of its enterprise applications to the cloud. As the CTO, you have been tasked with determining how much it would cost and what the benefits of a cloud migration would be. What would you do first?
   1. **Take inventory of applications and infrastructure, document dependencies, and identify compliance and licensing issues.**
   2. Create a request for proposal from cloud vendors.
   3. Discuss cloud licensing issues with enterprise software vendors.
   4. Interview department leaders to identify their top business pain points.

2. You are working with a colleague on a cloud migration plan. Your colleague would like to start migrating data. You have completed an assessment but no other preparation work. What would you recommend before migrating data?
   1. Migrating applications
   2. **Conducting a pilot project**
   3. Migrating all identities and access controls
   4. Redesigning relational data models for optimal performance

3. As the CTO of your company, you are responsible for approving a cloud migration plan for services that include a wide range of data. You are reviewing a proposed plan that includes a data migration plan. Network and security plans are being developed in parallel and are not yet complete. What should you look for as part of the data migration plan?
   1. Database configuration details, including IP addresses and port numbers
   2. Specific firewall rules to protect databases
   3. **An assessment of data classifications and regulations relevant to the data to be migrated**
   4. A detailed description of current backup operations

4. A client of yours is prioritizing applications to move to the cloud. One system written in Java is a Tier 1 production system that must be available 24/7; it depends on three Tier 2 services that are running on premises, and two other Tier 1 applications depend on it. Which of these factors is least important from a risk assessment perspective?
   1. **The application is written in Java.**
   2. The application must be available 24/7.
   3. The application depends on three Tier 2 services.
   4. Two other Tier 1 applications depend on it.

5. As part of a cloud migration, you will be migrating a relational database to the cloud. The database has strict SLAs, and it should not be down for more than a few seconds a month. The data stores approximately 500 GB of data, and your network has 100 Gbps bandwidth. What method would you consider first to migrate this database to the cloud?
   1. Use a third-party backup and restore application.
   2. Use the MySQL data export program and copy the export file to the cloud.
   3. **Set up a replica of the database in the cloud, synchronize the data, and then switch traffic to the instance in the cloud.**
   4. Transfer the data using the Google Transfer Appliance.

6. Your company is running several third-party enterprise applications. You are reviewing the licenses and find that they are transferrable to the cloud, so you plan to take advantage of that option. This form of licensing is known as which one of the following?
   1. Compliant licensing
   2. **Bring-your-own-license**
   3. Pay-as-you-go license
   4. Metered pricing

7. Your company is running several third-party enterprise applications. You are reviewing the licenses and find that they are not transferrable to the cloud. You research your options and see that the vendor offers an option to pay based on your level of use of the application in the cloud. What is this option called?
   1. Compliant licensing
   2. Bring-your-own-license
   3. **Pay-as-you-go license**
   4. Incremental payment licensing

8. You have been asked to brief executives on the networking aspects of the cloud migration. You want to begin at the highest level of abstraction and then drill down into lower-level components. What topic would you start with?
   1. Routes
   2. Firewalls
   3. **VPCs**
   4. VPNs

9. You have created a VPC in Google Cloud, and subnets were created automatically. What range of IP addresses would you not expect to see in use with the subnets?
   1. 10.0.0.0 to 10.255.255.255
   2. 172.16.0.0 to 172.31.255.255
   3. 192.168.0.0 to 192.168.255.255
   4. **201.1.1.0 to 201.2.1.0**

10. During migration planning, you learn that traffic to the subnet containing a set of databases must be restricted. What mechanism would you plan to use to control the flow of traffic to a subnet?
    1. IAM roles
    2. **Firewall rules**
    3. VPNs
    4. VPCs

11. During migration planning, you learn that some members of the network management team will need the ability to manage all network components, but others on the team will only need read access to view the state of the network. What mechanism would you plan to use to control the user access?
    1. **IAM roles**
    2. Firewall rules
    3. VPNs
    4. VPCs

12. Executives in your company have decided that the company should not route its GCP-only traffic over public internet networks. What Google Cloud service would you plan to use to geographically distribute the workload of an enterprise application?
    1. **Global load balancing**
    2. Simple network management protocol
    3. Content delivery network
    4. VPNs

13. Executives in your company have decided to expand operations from just North America to Europe as well. Applications will be run in several regions. All users should be routed to the nearest healthy server running the application they need. What Google Cloud service would you plan to use to meet this requirement?
    1. **Global load balancing**
    2. Cloud Interconnect
    3. Content delivery network
    4. VPNs

14. Executives in your company have decided that the company should expand its service offerings to a global market. Your company distributes educational video content online. Maintaining low latency is a top concern. What type of network service would you expect to use to ensure low-latency access to content from around the globe?
    1. Routes
    2. Firewall rules
    3. **Content delivery network**
    4. VPNs
