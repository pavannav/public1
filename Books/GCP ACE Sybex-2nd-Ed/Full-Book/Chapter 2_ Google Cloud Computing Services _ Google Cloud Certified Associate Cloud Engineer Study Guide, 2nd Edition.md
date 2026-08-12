---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- ![](../images/tick_5.png) **2.2 Planning and configuring compute resources**
- ![](../images/tick_5.png) **3.4 Deploying and implementing data solutions**

---

Google Cloud is made up of a wide array of services that meet a variety of computing, storage, and networking needs. This chapter provides an overview of the most important Google Cloud computing services and describes some important use cases for these services.

## Computing Components of Google Cloud

Google Cloud is a suite of cloud computing services that includes compute, storage, and networking services designed to meet the needs of a wide range of cloud computing customers. Small businesses may be attracted to virtual machines (VMs) and storage services. Large businesses and other sizable organizations may be more interested in access to highly scalable clusters of VMs, a variety of relational and NoSQL databases, specialized networking services, and advanced artificial intelligence and machine learning capabilities.

This chapter provides an overview of many of Google Cloud’s services. The breadth of services available in the Google Cloud continues to grow. By the time you read this, Google may be offering additional services. Most of the services can be grouped into several core categories.

- Computing resources
- Storage resources
- Databases
- Networking services
- Identity management and security
- Development tools
- Management tools
- Specialized services

A Google-certified Associate Cloud Engineer should be familiar with the services in each category, how they are used, and the advantages and disadvantages of the various services in each category.

### Computing Resources

Public cloud services provide a range of computing service options. At one end of the spectrum, customers can create and manage VMs themselves. This model gives the cloud user the greatest control of all the computing services. Users can choose the operating system to run, which packages to install, and when to back up and perform other maintenance operations. This type of computing service is typically referred to as infrastructure as a service (IaaS).

An alternative model is called platform as a service (PaaS), which provides a runtime environment to execute applications without the need to manage underlying servers, networks, and storage systems.

One of IaaS computing products is called Compute Engine, and the PaaS offerings are App Engine and Cloud Functions. In addition, Google offers Kubernetes Engine, which is a service for managing containers in a cluster; this type of service is an increasingly popular alternative to managing individual sets of VMs.

#### Compute Engine

Compute Engine is a service that allows users to create VMs, attach persistent storage to those VMs, and make use of other Google Cloud services, such as Cloud Storage.

VMs are abstractions of physical servers. They are essentially programs that emulate physical servers and provide CPU, memory, storage, and other services that you would find if you ran your favorite operating system on a server under your desk or in a data center. VMs run within a low-level service called a *hypervisor*. Google Cloud uses a security-hardened version of the KVM hypervisor. KVM stands for Kernel Virtual Machine and provides virtualization on Linux systems running on x86 hardware.

Hypervisors run operating systems like Linux or Windows Server. Hypervisors can run multiple operating systems, referred to as *guest operating systems*, while keeping the activities of each isolated from other guest operating systems. Each instance of an executing guest operating system is a VM instance. [Figure 2.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c02.xhtml#c02-fig-0001) shows the logical organization of VM instances running on a physical server.

VMs come in a range of predefined sizes, but you can also create a customized configuration. When you create an instance, you can specify several parameters, including the following:

- The operating system
- The size of persistent storage
- Whether you'll add graphical processing units (GPUs) for compute-intensive operations like machine learning
- Whether you'll make the VM preemptible

The last option, making a VM preemptible, means you may be charged significantly less for the VM than normal (around 80 percent less), but your VM could be shut down at any time by Google. It will be shut down after the preemptible VM has run for at least 24 hours. The latest version of preemptible VMs are known as *spot instances* and use the same pricing model as preemptible VM; however, spot instances do not have a maximum runtime and will not be shut down after 24 hours.

![Schematic illustration of VM instances running within a hypervisor](../images/c02f001.png)


[**FIGURE 2.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c02.xhtml#R_c02-fig-0001) VM instances running within a hypervisor

[Chapter 4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml), “Introduction to Computing in Google Cloud,” will introduce the details of managing Compute Engine VMs. To explore Compute Engine, log into the Google Cloud Console, navigate to the main menu on the left, and select Compute Engine.

#### Kubernetes Engine

Kubernetes Engine is designed to allow users to easily run containerized applications on a cluster of servers. Containers are often compared to VMs because they are each used for isolating computing processing and resources. Containers take a different approach than VMs for isolating computing processes.

As mentioned, a VM runs a guest operating system on a physical server. The physical server runs an operating system as well, along with a hypervisor. Another approach to isolating computing resources is to use features of the host operating system to isolate processes and resources. With this approach, there is no need for a hypervisor; the host operating system maintains isolation. Instead, a container manager is used. That is, a single container manager coordinates containers running on the server. No additional, or guest, operating systems run on top of the container manager. Instead, containers make use of host operating system functionality, while the operating system and container manager ensure isolation between the running containers. [Figure 2.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c02.xhtml#c02-fig-0002) shows the logical structure of containers.

![Schematic illustration of containers running on a physical server](../images/c02f002.png)


[**FIGURE 2.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c02.xhtml#R_c02-fig-0002) Containers running on a physical server

Kubernetes Engine is a Googel Cloud product that allows users to describe the compute, storage, and memory resources they'd like to run their services. Kubernetes Engine then provisions the underlying resources. It's easy to add and remove resources from a Kubernetes cluster using a command-line interface or a graphical user interface.

In addition, Kubernetes monitors the health of servers in the cluster and automatically repairs problems, such as failed servers. Kubernetes Engine also supports autoscaling, so if the load on your applications increases, Kubernetes Engine will allocate additional resources.

Anthos clusters extend GKE for hybrid and multicloud environments by providing services to create, scale, and upgrade conformant Kubernetes clusters along with a common orchestration layer. Multiple clusters can be managed as a group known as a *fleet*. Anthos clusters can be connected using standard networking options, including VPNs, Dedicated Interconnect, and Partner Interconnects.

There are several key benefits to using Anthos to manage multiple Kubernetes clusters. These include:

- Centralized management of configuration as code
- Ability to roll back deployments with Git
- A single view of cluster infrastructure and applications
- Centralized and auditable workflows
- Instrumentation of code using Anthos Service Mesh
- Anthos Service Mesh authorization and routing

In addition, Anthos includes Migrate for Anthos for GKE, which is a service that allows you to orchestrate migrations using Kubernetes and Anthos.

The term “Anthos clusters” refers to Google Kubernetes Engine clusters that have been extended to function on-premises or in multicloud environments.

[Chapter 7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml), “Computing with Kubernetes,” will describe the details of planning and managing Kubernetes Engine. To explore Kubernetes Engine, log into the Google Cloud Console, navigate to the main menu on the left, and select Kubernetes Engine.

#### App Engine

App Engine is a Google Cloud compute PaaS offering. With App Engine, developers and application administrators don't need to concern themselves with configuring VMs or specifying Kubernetes clusters. Instead, developers create applications in a popular programming language such as Java, Go, Python, or Node.js and deploy that code to a serverless application environment.

App Engine manages the underlying computing and network infrastructure. There is no need to configure VMs or harden networks to protect your application. App Engine is well suited for web and mobile back-end applications.

App Engine is available in two types:

- In the **standard** environment, you run applications in a language-specific sandbox, so your application is isolated from the underlying server's operating system as well as from other applications running on that server. The standard environment is well suited to applications that are written in one of a supported languages and do not need operating system packages or other compiled software that would have to be installed along with the application code.
- In the **flexible** environment, you run containerized applications in the App Engine environment. The flexible environment works well in cases where you have application code but also need libraries or other third-party software installed. As the name implies, the flexible environment gives you more options, including the ability to work with background processes and write to local disk.

[Chapter 9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml), “Computing with Cloud Run and App Engine,” will introduce details for using and managing App Engine. To explore App Engine, log into the Google Cloud Console, navigate to the main menu on the left, and select App Engine.

#### Cloud Run

Cloud Run is a Google Cloud service for running stateless containers. When using the managed service, you pay per use and can have up to 1,000 container instances by default.

Unlike App Engine Standard, Cloud Run does not restrict you to using a fixed set of programming languages. Cloud Run services have regional availability.

A service is the main abstraction of computing in Cloud Run. A service is in a region and replicated across multiple zones. A service may have multiple revisions. Cloud Run will autoscale the number of instances based on load.

#### Cloud Functions

Google Cloud Functions is a lightweight computing option that is well suited to event-driven processing. Cloud Functions runs code in response to an event, like a file being uploaded to Cloud Storage or a message being written to a message queue. The code that executes in the Cloud Functions environment must be short-running—this computing service is not designed to execute long-running code. If you need to support long-running applications or jobs, consider Compute Engine, Kubernetes Engine, or App Engine.

Cloud Functions is often used to call other services, such as third-party application programming interfaces (APIs) or other Google Cloud services, like a natural language translation service.

Like App Engine and Cloud Run, Cloud Functions is a serverless product. Users only need to supply code; they do not need to configure VMs or create containers. Cloud Functions will automatically scale as load increases.

In addition to these computing products, Google Cloud offers a number of storage resources.

[Chapter 10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml), “Computing with Cloud Functions,” will describe the details of using and managing Cloud Functions. To explore Cloud Functions, log into the Google Cloud Console, navigate to the main menu on the left, and select Cloud Functions.

## Storage Components of Google Cloud

Applications and services that run in the cloud must meet a wide range of requirements when it comes to storage.

### Storage Resources

Sometimes an application needs fast read and write times for moderate amounts of data. Other times, a business application may need access to petabytes of archival storage but can tolerate minutes and even hours to retrieve a document. Google Cloud has several storage resources for storing objects and files.

#### Cloud Storage

Cloud Storage is Google Cloud’s object storage system. Objects can be any type of file or binary large objects, or blob. Objects are organized into buckets, which are analogous to directories in a filesystem. It is important to remember that Cloud Storage is not a filesystem; it is a service that receives, stores, and retrieves files or objects from a distributed storage system. Cloud Storage is not part of a VM in the way an attached persistent disk is. Cloud Storage is accessible from VMs, containers, or any other network device with appropriate privileges and so complements filesystems on persistent disks.

Each stored object is uniquely addressable by a URL. For example, a PDF version of this chapter, called `chapter1.pdf`, that if stored in a bucket named *ace-certification-exam-prep* would be addressable as follows:

`https://storage.cloud.google.com/ace-certification-exam-prep/chapter1.pdf`

Google Cloud users and others can be granted permission to read and write objects to a bucket. Often, an application will be granted privileges through a service account with Identity and Access Management (IAM) roles to enable the application to read and write to buckets.

Cloud Storage is useful for storing objects that are treated as single units of data. For example, an image file is a good candidate for object storage. Images are generally read and written all at once. There is rarely a need to retrieve only a portion of the image. In general, if you write or retrieve an object all at once and you need to store it independently of servers that may or may not be running at any time, then Cloud Storage is a good option.

There are different location types of cloud storage. Regional storage keeps copies of objects in a single Google Cloud *region*. Regions are distinct geographic areas that can have multiple *zones*, or deployment areas. A zone is considered a single failure domain, which means that if all instances of your application are running in a zone and there is a failure, then all instances of your application will be inaccessible. Regional storage is well suited for applications that run in the same region and need low-latency access to objects in Cloud Storage.

Cloud Storage has some useful advanced features, such as support for multiple regions. This feature provides for storing replicas of objects in multiple Google Cloud regions, which is important for high availability, durability, and low latency.

---

### Real World Scenario

### Multi-Region Storage

If there was an outage in region us-east1 and your objects were stored only in that region, then you would not be able to access those objects during the outage. However, if you enabled multiregion storage, then your objects stored in us-east1 would be stored in another region, such as us-west1, as well.

---

In addition to high availability and durability, multiregion storage allows for faster access to data when users or applications are distributed across regions.

Sometimes data needs to be kept for extended periods of time but is rarely accessed. In those cases, nearline and coldline storage classes are good options. Use nearline when you will access objects less than once per month, and use coldline when you will access objects less than once every 90 days.

The archive storage class is low-cost archival storage designed for high durability and infrequent access. This class of storage is suitable for data that is accessed less than once per year.

A useful feature of Cloud Storage is the set of life cycle management policies that can automatically manage objects based on policies you define. For example, you could define a policy that moves all objects more than 60 days old in a bucket from standard storage class to nearline storage class, or deletes any object in an archive storage bucket that is older than five years.

#### Persistent Disk

Persistent disks are storage services that are attached to VMs in Compute Engine or Kubernetes Engine. Persistent disks provide block storage on solid-state drives (SSDs) and hard disk drives (HDDs). SSDs are often used for low-latency applications where persistent disk performance is important. SSDs cost more than HDDs, so applications that require large amounts of persistent disk storage but can tolerate longer read and write times can use HDDs to meet their storage requirements.

An advantage of persistent disks on the Google Cloud is that these disks support multiple readers without a degradation in performance. This allows for multiple instances to read a single copy of data. Disks can also be resized as needed while in use without the need to restart your VMs.

Persistent disks can be up to 64 TB in size using either SSDs or HDDs. Multiple persistent disks can be attached to a single VM.

#### Cloud Storage for Firebase

Mobile app developers may find Cloud Storage for Firebase to be the best combination of cloud object storage and the ability to support uploads and downloads from mobile devices with sometimes unreliable network connections.

The Cloud Storage for Firebase API is designed to provide secure transmission as well as robust recovery mechanisms to handle potentially problematic network quality. Once files, like photos or music recordings, are uploaded into Cloud Storage, you can access those files through the Cloud Storage command-line interface and software development kits (SDKs).

#### Cloud Filestore

Sometimes, developers need to have access to a filesystem housed on network-attached storage. For these use cases, the Cloud Filestore service provides a shared filesystem for use with Compute Engine and Kubernetes Engine.

Filestore can provide high numbers of input-output operations per second (IOPS) as well as variable storage capacity. Filesystem administrators can configure Cloud Filestore to meet their specific IOPS and capacity requirements.

Filestore implements the Network File System (NFS) protocol so that system administrators can easily mount shared filesystems on virtual servers.

Storage systems like the ones just described are used to store coarse-grained objects such as files. When data is more finely structured and has to be retrieved using query languages that describe the subset of data to return, then it is best to use a database management system.

[Chapter 11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml), “Planning Storage in the Cloud,” describes details and guidance for planning storage services. To explore storage options, log into the Google Cloud Console, navigate to the main menu on the left, and select Storage or Filestore.

### Databases

Google Cloud provides several database options. Some are relational databases, and some are NoSQL databases. Some are serverless and others require users to manage clusters of servers. Some provide support for atomic transactions, and others are better suited for applications with less stringent consistency and transaction requirements. Google Cloud users must understand their application requirements before choosing a service, and doing so is especially important when choosing a database, which often provides core storage services in the application stack.

#### Cloud SQL

Cloud SQL is Google Cloud managed relational database service that allows users to set up MySQL, PostgreSQL, and SQL Server databases on VMs without having to attend to database administration tasks, such as backing up databases or patching database software.

This database service includes management of replication and allows for automatic failover, providing for highly available databases.

Relational databases are well suited to applications with relatively consistent data structure requirements. For example, a banking database may track account numbers, customer names, addresses, and so on. Since virtually all records in the database will need the same information, this application is a good fit for a relational database.

#### Cloud Bigtable

Cloud Bigtable is designed for petabyte-scale applications that can manage up to billions of rows and thousands of columns. It is based on a NoSQL model known as a *wide-column data model*, which is different from relational databases such as Cloud SQL. Bigtable is suited for applications that require low-latency write and read operations. It is designed to support millions of operations per second.

Bigtable integrates with other Google Cloud services, such as Cloud Storage, Cloud Pub/Sub, Cloud Dataflow, and Cloud Dataproc. It also supports the HBase API, which is an API for data access in the Hadoop big data ecosystem. Bigtable also integrates with open source tools for data processing, graph analysis, and time-series analysis.

#### Cloud Spanner

Cloud Spanner is Google's globally distributed relational database that combines the key benefits of relational databases, such as strong consistency and transactions, with the ability to scale horizontally like a NoSQL database. Spanner is a high-availability database with a 99.999 percent availability service level agreement (SLA), making it a good option for enterprise applications that demand scalable, highly available relational database services.

Cloud Spanner also has enterprise-grade security with encryption at rest and encryption in transit, along with identity-based access controls.

Cloud Spanner supports ANSI 2011 standard SQL.

#### Cloud Firestore

Cloud Firestore, formerly known as Cloud Datastore, is a NoSQL document database. This kind of database uses the concept of a document, or collection of key-value pairs, as the basic building block. Documents allow for flexible schemas. For example, a document about a book may have key-value pairs listing author, title, and date of publication. Some books may also have information about companion websites and translations into other languages. The set of keys that may be included does not have to be defined prior to use in document databases. This is especially helpful when applications must accommodate a range of attributes, some of which may not be known at design time.

Cloud Firestore is accessed via a REST API that can be used from applications running in Compute Engine, Kubernetes Engine, or App Engine. This database will scale automatically based on load. It will also *shard*, or partition, data as needed to maintain performance. Since Cloud Firestore is a managed service, it takes care of replication, backups, and other database administration tasks.

Although it is a NoSQL database, Cloud Firestore supports transactions, indexes, and SQL-like queries.

Cloud Firestore is well suited to applications that demand high scalability and structured data and do not always need strong consistency when reading data. Product catalogs, user profiles, and user navigation history are examples of the kinds of applications that use Cloud Datastore.

#### Cloud Memorystore

Cloud Memorystore is an in-memory cache service. Other databases offered in Google Cloud are designed to store large volumes of data and support complex queries, but Cloud Memorystore is a managed service for caching frequently used data in memory. Caches like this are used to reduce the time needed to read data into an application. Cloud Memorystore is designed to provide submillisecond access to data. Cloud Memorystore supports both Redis and memcached, two popular open source caching systems.

As a managed service, Cloud Memorystore allows users to specify the size of a cache while leaving administration tasks to Google. Google Cloud ensures high availability, patching, and automatic failover so users don't have to.

[Chapter 12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml), “Deploying Storage in Google Cloud,” delves into details of how to create various types of databases, as well as how to load, delete, and query data. Each of the databases can be accessed from the main menu of the Google Cloud Console. From there you can begin to explore how each works and begin to see the differences.

## Networking Components of Google Cloud

In this section, we will review the major networking components. Details on setting up networks and managing them are described in [Chapter 14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml), “Networking in the Cloud: Virtual Private Clouds and Virtual Private Networks,” and [Chapter 15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml), “Networking in the Cloud: DNS, Load Balancing, Google Private Access, and IP Addressing.”

### Networking Services

Google Cloud provides a number of networking services designed to allow users to configure virtual networks within Google's global network infrastructure, link on-premises data centers to Google's network, optimize content delivery, and protect your cloud resources using network security services.

#### Virtual Private Cloud

When an enterprise operates its own data center, it controls what is physically located in that data center and connected to its network. Its infrastructure is physically isolated from those of other organizations running in other data centers. When an organization moves to a public cloud, it shares infrastructure with other customers of that public cloud. Although multiple enterprises will use the same cloud infrastructure, each enterprise can logically isolate its cloud resources by creating a virtual private cloud (VPC).

A distinguishing feature of Google Cloud is that a VPC can span the globe without relying on the public Internet. Traffic from any server on a VPC can be securely routed through the Google global network to any other point on that network. Another advantage of the Google network structure is that your back-end servers can access Google services, such as machine learning or Internet of Things (IoT) services, without creating a public IP address for back-end servers.

VPCs in Google Cloud can be linked to on-premises virtual private networks using Internet Protocol Security (IPSec).

Although a VPC is global, enterprises can use separate projects and billing accounts to manage different departments or groups within the organization. Firewalls can be used to restrict access to resources on a VPC as well.

#### Cloud Load Balancing

Google provides global load balancing to distribute workloads across your cloud infrastructure. Using a single cast IP address, Cloud Load Balancing can distribute the workload within and across regions, adapt to failed or degraded servers, and autoscale your compute resources to accommodate changes in workload. Cloud Load Balancing also supports internal load balancing, so no IP addresses need to be exposed to the Internet to get the advantages of load balancing.

Cloud Load Balancing is a software service that can load-balance HTTP, HTTPS, TCP/SSL, and UDP traffic.

#### Cloud Armor

Services exposed to the Internet can become targets of distributed denial-of-service (DDoS) attacks. Cloud Armor is a Google network security service that builds on the Global HTTP(s) Load Balancing service. Cloud Armor features include the following:

- Ability to allow or restrict access based on IP address
- Predefined rules to counter cross-site scripting attacks
- Ability to counter SQL injection attacks
- Ability to define rules from level 3 (network) to level 7 (application)
- Allows and restricts access based on the geolocation of incoming traffic

#### Cloud CDN

With content delivery networks (CDNs), users anywhere can request content from systems distributed in various regions. CDNs enable low-latency response to these requests by caching content on a set of endpoints across the globe. Google currently has more than 100 CDN endpoints that are managed as a global resource, so there is no need to maintain region-specific configurations.

CDNs are especially important for sites with large amounts of static content and a global audience. News sites, for example, could use the Cloud CDN service to ensure fast response to requests from any point in the world.

#### Cloud Interconnect

Cloud Interconnect is a set of Google Cloud services for connecting your existing networks to the Google network. Cloud Interconnect offers two types of connections: interconnects and peering.

Interconnect with direct access to networks uses the Address Allocation for Private Internets standard (RFC 1918) to connect to devices in your VPC. A direct network connection is maintained between an on-premises or hosted data center and one of Google's colocation facilities, which are in North America, South America, Europe, Asia, and Australia. Alternatively, if an organization cannot achieve a direct interconnect with a Google facility, it could use Partner Interconnect. This service depends on a third-party network provider to provide connectivity between the company's data center and a Google facility.

Partner Interconnect is the recommended way to connect to Google Cloud through providers, but if you need to access Google Workspace applications, then you can use carrier peering. Peering does not use Google Cloud resources such as interconnect connections or Cloud Routers.

For organizations that do not require the bandwidth of a direct or peered interconnect, Google offers VPN services that enable traffic to transmit between data centers, other vendor clouds, and Google Cloud using the public Internet.

#### Cloud DNS

Cloud DNS is a domain name service provided in Google Cloud. Cloud DNS is a high availability, low-latency service for mapping from domain names, such as `example.com`, to IP addresses, such as 74.120.28.18.

Cloud DNS is designed to automatically scale so customers can have thousands or even millions of addresses without concern for scaling the underlying infrastructure. Cloud DNS also provides for private zones that allow you to create custom names for your VMs if you need those.

### Identity Management and Security

Google Cloud Identity and Access Management (IAM) service enables customers to define fine-grained access controls on resources in the cloud. IAM uses the concepts of users, roles, and permissions.

Identities are abstractions about users of services, such as a human user. After an identity is authenticated by logging in or some other mechanism, the authenticated user can access resources and perform operations based on the permissions granted to that identity. For example, a user may have permissions to create a bucket in Cloud Storage or delete a VM running in Compute Engine.

Users often need similar sets of permissions. Someone who can create a VM will likely want to be able to modify or delete those VMs. Groups of related permissions can be bundled into roles. Roles are sets of permissions that can be assigned to an identity.

As a Google Certified Associate Cloud Engineer, you will become familiar with identities, roles, and permissions and how to administer them across organizations and projects.

You can find identity management tools under the IAM and Admin menu in the Google Cloud Console. [Chapter 17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml), “Configuring Access and Security,” provides details on identity, roles, and best practices for their management.

### Development Tools

Google Cloud is an excellent choice for developers and software engineers because of the easy access to infrastructure and data management services, but also for the tools it supports.

Cloud SDK is a command-line interface for managing Google Cloud resources, including VMs, disk storage, network firewalls, and virtually any other resource you might deploy in Google Cloud. In addition to a command-line interface, Cloud SDK client libraries include libraries for Java, Python, Node.js, Ruby, Go, .NET, and PHP.

Google Cloud also supports deploying applications to containers with Container Registry, Cloud Build, and Cloud Source Repositories.

Google has also developed plug-ins to make it easy to work with popular development tools. These include the following:

- Cloud Tools for IntelliJ
- Cloud Tools for PowerShell
- Cloud Tools for Visual Studio
- Cloud Tools for Eclipse
- App Engine Gradle Plugin
- App Engine Maven Plugin

Of course, applications move from development to production deployment, and Google Cloud follows that flow with additional management tools to help monitor and maintain applications after they are deployed.

## Additional Components of Google Cloud

Management tools are designed for those who are responsible for ensuring the reliability, availability, and scalability of applications.

### Management and Observability Tools

The following are some of the most important tools in the management and observability tools category:

- **Cloud Monitoring**   This service collects performance data from Google Cloud, AWS resources, and application instrumentation, including popular open source systems like NGINX, Cassandra, and Elasticsearch.
- **Cloud Logging**   This service enables users to store and analyze and alert on log data from both Google Cloud and Amazon Web Services (AWS) logs.
- **Error Reporting**   This aggregates application crash information for display in a centralized interface.
- **Cloud Trace**   This is a distributed tracing service that captures latency data about an application to help identify performance problem areas.
- **Cloud Debugger**   This enables developers to inspect the state of executing code, inject commands, and view call stack variables.
- **Cloud Profiler**   This is used to collect CPU and memory utilization information across the call hierarchy of an application. Profiler uses statistical sampling to minimize the impact of profiling on application performance.

The combination of management and observability tools provides insights into applications as they run in production, enabling more effective monitoring and analysis of operational systems.

### Specialized Services

In addition to IaaS and PaaS offerings, Google Cloud has specialized services for APIs, data analytics, and machine learning.

#### Apigee API Platform

The Apigee API platform is a management service for Google Cloud customers providing API access to their applications. The Apigee platform allows developers to deploy, monitor, and secure their APIs. It also generates API proxies based on the Open API Specification.

It is difficult to predict load on an API, and sometimes spikes in use can occur. For those times, the Apigee API platform provides routing and rate-limiting based on policies customers can define.

APIs can be authenticated using either OAuth 2.0 or SAML. Data is encrypted both in transit and at rest in the Apigee API platform.

#### Data Analytics and Data Pipelines

Google Cloud has a number of services designed for analyzing big data in batch and streaming modes. Some of the most important tools in this set of services are:

- BigQuery, a petabyte-scale analytics database service for data warehousing
- Cloud Dataflow, a framework for defining batch and stream processing pipelines
- Cloud Dataproc, a managed Hadoop and Spark service
- Cloud Dataprep, a service that allows analysts to explore and prepare data for analysis

Often, data analytics and data warehousing projects use several of these services together.

#### AI and Machine Learning

Google is a leader in AI and machine learning, so it is no surprise that Google Cloud includes several AI services. Vertex AI is a unified AI platform for building machine learning models. Specialized services in this area include the following:

- **AutoML**   This is a tool that allows developers without machine learning experience to develop machine learning models.

- **Translation AI**   This tool is for translating human language and includes AutoML Translation and Translation API for text translations and Media Translation API for audio translations.

- **Natural Language**   Analyze and extract features and concepts from text using machine learning methods.

- **Vision AI**   This is an image analysis platform for annotating images with metadata, extracting text, or filtering content.

- **Recommendations AI**   This is a service to provide personalized recommendations to customers at scale.

## Summary

Google Cloud provides a full range of services to support information processing including computing resources, storage resources, databases, networking services, identity management and security services, development tools, management and operations services, as well as specialized services to support AI.

## Exam Essentials

- **Understand the differences between Compute Engine, Kubernetes Engine, App Engine, Cloud Run, and Cloud Functions.**   Compute Engine is Google's VM service. Users can choose CPUs, memory, persistent disks, and operating systems. They can further customize a VM by adding graphics processing units for compute-intensive operations. VMs are managed individually or in groups of similar servers.

  Kubernetes Engine manages groups of virtual servers and applications that run in containers. Containers are lighter weight than VMs. Kubernetes is called an *orchestration service* because it distributes containers across clusters, monitors cluster health, and scales as proscribed by configurations.

  App Engine is Google's PaaS. Developers can run their code in a language-specific sandbox when using the standard environment or in a container when using the flexible environment. App Engine is a serverless service, so customers do not need to specify VM configurations or manage servers.

  Cloud Run is a service for running stateless containers. This is a serverless option that provides some of the advantages of Kubernetes without requiring you to deploy your own clusters. Note that Cloud Run does not currently support applications that maintain state in the container.

  Cloud Functions is a serverless service that is designed to execute short-running code that responds to events, such as file uploads or messages being published to a message queue. Functions may be written in Node.js or Python.
- **Understand what is meant by serverless.**   Serverless means customers using a service do not need to configure, monitor, or maintain the computing resources underlying the service. It does not mean there are no servers involved—there are always physical servers that run applications, functions, and other software. Serverless only refers to not needing to manage those underlying resources.
- **Understand the difference between object and file storage.**   Object stores are used to store and access file-based resources. These objects are referenced by a unique identifier, such as a URL. Object stores do not provide block or filesystem services, so they are not suitable for database storage. Cloud Storage is Google Cloud object storage service.

  File storage supports block-based access to files. Files are organized into directories and subdirectories. Google's Filestore is based on NFS.
- **Know the different kinds of databases.**   Databases are broadly divided into relational and NoSQL databases.

  Relational databases support transactions, strong consistency, and the SQL query languages. Relational databases have been traditionally difficult to horizontally scale. Cloud Spanner is a global relational database that provides the advantages of relational databases with the scalability previously found only in NoSQL databases.

  NoSQL databases are designed to be horizontally scalable. Other features, such as strong consistency and support for standard SQL, are often sacrificed to achieve scalability and low-latency query responses. NoSQL databases may be key-value stores like Cloud Memorystore, document databases like Cloud Firestore, or wide-column databases such as Cloud Bigtable.
- **Understand virtual private clouds.**   A VPC is a logical isolation of an organization's cloud resources within a public cloud. In Google Cloud, VPCs are global; they are not restricted to a single zone or region. All traffic between Google Cloud services can be transmitted over the Google network without the need to send traffic over the public Internet.
- **Understand load balancing.**   Load balancing is the process of distributing a workload across a group of servers. Load balancers can route workload based on network-level or application-level rules. Google Cloud load balancers can distribute workloads globally.
- **Understand developer and management tools.**   Developer tools support common workflows in software engineering, including using version control for software, building containers to run applications and services, and making containers available to other developers and orchestration systems, such as Kubernetes Engine.

  Management tools, such as Cloud Monitoring and Cloud Logging, are designed to provide systems administration information to developers and operators who are responsible for ensuring applications are available and operating as expected.
- **Know the types of specialized services offered by Google Cloud.**   Google Cloud includes a growing list of specialized services for data analytics as well as AI and machine learning.
- **Know the main differences between on-premises and public cloud computing.**   On-premises computing is computing, storage, networking, and related services that occur on infrastructure managed by a company or organization for its own use. Hardware may be located literally on the premises in a company building or in a third-party colocation facility. Colocation facilities provide power, cooling, and physical security, but the customers of the colocation facility are responsible for all the setup and management of the infrastructure.

  Public cloud computing uses infrastructure and services provided by a cloud provider such as Google, AWS, or Microsoft. The cloud provider maintains all physical hardware and facilities. It provides a mix of services, such as VMs that are configured and maintained by customers and serverless offerings that enable customers to focus on application development, while the cloud provider takes on more responsibility for maintaining the underlying compute infrastructure.

## Review Questions

You can find the answers in the Appendix.

1. You are planning to deploy an SaaS application for customers in North America, Europe, and Asia. To maintain scalability, you will need to distribute workload across servers in multiple regions. Which Google Cloud service would you use to implement the workload distribution?
   1. Cloud DNS
   2. Cloud Spanner
   3. Cloud Load Balancing
   4. Cloud CDN
2. You have decided to deploy a set of microservices using containers. The microservices will maintain state in the container. You could install and manage Docker on Compute Engine instances, but you'd rather have Google Cloud provide some container management services. Which are two Google Cloud services that allow you to run containers in a managed service?
   1. App Engine standard environment and App Engine flexible environment
   2. Kubernetes Engine and App Engine standard environment
   3. Kubernetes Engine and Cloud Run environment
   4. App Engine standard environment and Cloud Functions
3. Why would an API developer want to use the Apigee API platform?
   1. To get the benefits of routing and rate-limiting
   2. Authentication services
   3. Version control of code
   4. A and B
   5. All of the above
4. You are deploying an API to the public Internet and are concerned that your service will be subject to DDoS attacks. Which Google Cloud service should you consider to protect your API?
   1. Cloud Armor
   2. Cloud CDN
   3. Cloud IAM
   4. VPCs
5. You have an application that uses a Pub/Sub message queue to maintain a list of tasks that are to be processed by another application. The application that consumes messages from the Pub/Sub queue removes the message only after completing the task. It takes approximately 10 seconds to complete a task. It is not a problem if two or more VMs perform the same task. What is a cost-effective configuration for processing this workload?
   1. Use preemptible VMs
   2. Use standard VMs
   3. Use DataProc
   4. Use Spanner
6. Your department is deploying an application that has a database back end. You are concerned about the read load on the database server and want to have data available in memory to reduce the time to respond to queries and to reduce the load on the database server. Which Google Cloud service would you use to keep data in memory?
   1. Cloud SQL
   2. Cloud Memorystore
   3. Cloud Spanner
   4. Cloud Firestore
7. The Cloud SDK can be used to configure and manage resources in which of the following services?
   1. Compute Engine
   2. Cloud Storage
   3. Network firewalls
   4. All of the above
8. What server configuration is required to use Cloud Functions?
   1. VM configuration
   2. Cluster configuration
   3. Pub/Sub configuration
   4. None
9. You have been assigned the task of consolidating log data generated by each instance of an application. Which management and observability tools would you use?
   1. Cloud Monitoring
   2. Cloud Trace
   3. Cloud Debugger
   4. Cloud Logging
10. Which specialized services are most likely to be used to build a data warehousing platform that requires complex extraction, transformation, and loading operations on batch data as well as processing streaming data?
    1. Apigee API platform
    2. Data analytics
    3. AI and machine learning
    4. Cloud SDK
11. Your company has deployed 100,000 Internet of Things (IoT) sensors to collect data on the state of equipment in several factories. Each sensor will collect and send data to a data store every 5 seconds. Sensors will run continuously. Daily reports will produce data on the maximum, minimum, and average values for each metric collected on each sensor. There is no need to support transactions in this application. Which database product would you recommend?
    1. Cloud Spanner
    2. Cloud Bigtable
    3. Cloud SQL MySQL
    4. Cloud SQL PostgreSQL
12. You are the lead developer on a medical application that uses patients' smartphones to capture biometric data. The app is required to collect data and store it on the smartphone when data cannot be reliably transmitted to the back-end application. You want to minimize the amount of development you have to do to keep data synchronized between smartphones and back-end data stores. Which data store option should you recommend?
    1. Cloud Firestore
    2. Cloud Spanner
    3. Cloud CDN
    4. Cloud SQL
13. A software engineer comes to you for a recommendation. They have implemented a machine learning algorithm to identify cancerous cells in medical images. The algorithm is computationally intensive, makes many floating-point calculations, requires immediate access to large amounts of data, and cannot be easily distributed over multiple servers. What kind of Compute Engine configuration would you recommend?
    1. High memory, high CPU
    2. High memory, high CPU, GPU
    3. Mid-level memory, high CPU
    4. High CPU, GPU
14. You are tasked with mapping the authentication and authorization policies of your on-premises applications to Google Cloud’s authentication and authorization mechanisms. The Google Cloud documentation states that an identity must be authenticated in order to grant permissions to that identity. What does the term *identity* refer to?
    1. VM ID
    2. User
    3. Role
    4. Set of privileges
15. A client is developing an application that will need to analyze large volumes of text information. The client is not expert in text mining or working with language. What Google Cloud service would you recommend they use?
    1. Vertex AI
    2. Recommendation AI
    3. Natural Language
    4. Text-to-Speech
16. Data scientists in your company want to use a machine learning library available only in Apache Spark. They want to minimize the amount of administration and DevOps work. How would you recommend they proceed?
    1. Use Cloud Spark.
    2. Use Cloud Dataproc.
    3. Use BigQuery.
    4. Install Apache Spark on a cluster of VMs.
17. Database designers at your company are debating the best way to move a database to Google Cloud. The database supports an application with a global user base. Users expect support for transactions and the ability to query data using commonly used query tools. The database designers decide that any database service they choose will need to support ANSI SQL 2011 and global transactions. Which database service would you recommend?
    1. Cloud SQL
    2. Cloud Spanner
    3. Cloud Firestore
    4. Cloud Bigtable
18. Which specialized service supports both batch and stream processing workflows?
    1. Cloud Dataflow
    2. BigQuery
    3. Cloud Firestore
    4. AutoML
19. You have a Python application you'd like to run in a scalable environment with the least amount of management overhead. Which Google Cloud product would you select?
    1. App Engine flexible environment
    2. Cloud Engine
    3. App Engine standard environment
    4. Kubernetes Engine
20. A product manager at your company reports that customers are complaining about the reliability of one of your applications. The application is crashing periodically, but developers have not found a common pattern that triggers the crashes. They are concerned that they do not have good insight into the behavior of the application and want to perform a detailed review of all crash data. Which observability tool would you use to view consolidated crash information?
    1. Cloud DataProc
    2. Cloud Monitoring
    3. Cloud Logging
    4. Error Reporting