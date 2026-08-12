Google Cloud is a leading public cloud that provides its users with some of the same software, hardware, and networking infrastructure used to power Google services. Businesses, organizations, and individuals can launch servers in minutes, store petabytes of data, and implement global virtual clouds with Google Cloud. It includes an easy-to-use console interface, command-line tools, and application programming interfaces (APIs) for managing resources in the cloud. Users can work with general resources, such as virtual machines (VMs) and persistent disks, or opt for highly focused services for Internet of Things (IoT), machine learning, media, and other specialized domains.

Deploying and managing applications and services in Google Cloud requires a clear understanding of the way Google structures user accounts and manages identities and access controls; you also need to understand the advantages and disadvantages of using various services. Certified Associate Cloud Engineers have demonstrated the knowledge and skills needed to deploy and operate infrastructure, services, and networks in Google Cloud.

This study guide is designed to help you understand Google Cloud in depth so that you can meet the needs of those operating resources in Google Cloud. Yes, this book will, of course, help you pass the Associate Cloud Engineer certification exam, but this is not an exam cram guide. You will learn more than is required to pass the exam; you will understand how to meet the day-to-day challenges faced by cloud engineers, including choosing services, managing users, deploying and monitoring infrastructure, and helping map business requirements into cloud-based solutions.

Each chapter in this book covers a single topic and includes an “Exam Essentials” section that outlines key information you should know to pass the certification exam. There are also exercises to help you review and reinforce your understanding of the chapter's topic. Sample questions are included at the end of each chapter so that you can get a sense of the types of questions you will see on the exam. The book also includes flashcards and practice exams that cover all topics you'll learn about with this guide.

## What Does This Book Cover?

This book describes products and services in Google Cloud. It does not include G Suite administration topics.

- **[Chapter 1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c01.xhtml): Overview of Google Cloud Platform**   In the opening chapter, we look into the types of services provided by Google Cloud, which include compute, storage, and networking services as well as specialized services, such as machine learning products. This chapter also describes some of the key differences between cloud computing and data center or on-premises computing.
- **[Chapter 2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c02.xhtml): Google Cloud Computing Services**   This chapter provides an overview of infrastructure services such as computing, storage, and networking. It introduces the concept of identity management and related services. It also introduces DevOps topics and tools for deploying and monitoring applications and resources. Google Cloud includes a growing list of specialized services, such as machine learning and natural language processing services. Those are briefly discussed in this chapter. The chapter introduces Google Cloud's organizational structure, with a look at regions and zones.
- **[Chapter 3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml): Projects, Service Accounts, and Billing**   One of the first things you will do when starting to work with Google Cloud is to set up your accounts. In this chapter, you will learn how resources in accounts are organized into organizations, folders, and projects. You will learn how to create and edit these structures. You will also see how to enable APIs for particular projects as well as manage user identities and their access controls. This chapter describes how to create billing accounts and link them to projects. You will also learn how to create budgets and define billing alerts to help you manage costs.
- **[Chapter 4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml): Introduction to Computing in Google Cloud**   In this chapter, you will see the variety of options available for running applications and services in Google Cloud. Options include Compute Engine, which provides VMs running Linux or Windows operating systems. Cloud Run and App Engine are platform as a service (PaaS) options that allows developers to run their applications without having to concern themselves with managing VMs. If you will be running multiple applications and services, you may want to take advantage of containers, which are a lightweight alternative to VMs. You will learn about containers and how to manage them with Kubernetes Engine. This chapter also introduces Cloud Functions, which is for event-driven, short-running tasks such as triggering the processing of an image loaded into Cloud Storage.
- **[Chapter 5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml): Computing with Compute Engine Virtual Machines**   In this chapter, you will learn how to configure VMs, including selecting CPU, memory, storage options, and operating system images. You will learn how to use Google Cloud Console and Cloud Shell to work with VMs. In addition, you will see how to install the command-line interface and SDK, which you will use to start and stop VMs. The chapter also describes how to enable network access to VMs.
- **[Chapter 6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml): Managing Virtual Machines**   In the previous chapter, you learned how to create VMs, and in this chapter you will learn how to manage individual and groups of VMs. You will start by managing a single instance of a VM using the Google Cloud console and then perform the same operations using Cloud Shell and the command line. You will also learn how to view currently running VMs. Next, you'll learn about instance groups, which allow you to create sets of VMs that you can manage as a single unit. In the section on instance groups, you will learn the difference between managed and unmanaged instance groups. You will also learn about preemptible instances, which are low-cost VMs that may be shut down by Google. You will learn about the cost–benefit trade-offs of preemptible instances. Finally, the chapter closes with guidelines for managing VMs.
- **[Chapter 7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml): Computing with Kubernetes**   This chapter introduces Kubernetes Engine, Google's managed Kubernetes service. Kubernetes is a container orchestration platform created and released as open source by Google. In this chapter, you will learn the basics of containers, container orchestration, and the Kubernetes architecture. The discussion will include an overview of Kubernetes objects such as pods, services, volumes, and namespaces, as well as Kubernetes controllers such as ReplicaSets, Deployments, and Jobs.  
    
  Next, the chapter turns to deploying a Kubernetes cluster using Google Cloud console, Cloud Shell, and SDK. You will also see how to deploy pods, which includes downloading an existing Docker image, building a Docker image, creating a pod, and then deploying an application to the Kubernetes cluster. Of course, you will need to know how to monitor a cluster of servers. This chapter provides a description of how to set up monitoring and logging with Cloud Operations, which is Google's application, service, container, and infrastructure monitoring service.
- **[Chapter 8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml): Managing Standard Mode Kubernetes Clusters**   In this chapter you will learn the basics of managing a Kubernetes cluster, including viewing the status of the cluster, viewing the contents of the image repository, viewing details about images in the repository, and adding, modifying, and removing nodes, pods, and services. As in the chapter on managing VMs, in this chapter you will learn how to perform management operations with the three management tools: Google Cloud console, Cloud Shell, and SDK. The chapter concludes with a discussion of guidelines and good practices for managing a Kubernetes cluster.
- **[Chapter 9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml): Computing with Cloud Run and App Engine**   Cloud Run and App Engine are part of Google Cloud's serverless offerings. This chapter introduces Cloud Run, a service for running containers in the cloud. You will learn about the difference between Cloud Run Services and Cloud Run Jobs. Cloud Run will likely replace App Engine as the preferred choice for running containers in a serverless service, but App Engine is still in use and will be covered in this book. You will learn about App Engine components such as applications, services, versions, and instances. The chapter also covers how to define configuration files and specify dependencies of an application. In this chapter, you will learn how to view App Engine resources using Google Cloud console, Cloud Shell, and SDK. The chapter also describes how to distribute workload by adjusting traffic with splitting parameters. You will also learn about autoscaling in App Engine.
- **[Chapter 10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c10.xhtml): Computing with Cloud Functions**   Cloud Functions is for event-driven, serverless computations. This chapter introduces Cloud Functions and shows you how to use it to receive events, evoke services, and return results. Next, you'll see use cases for Cloud Functions, such as integrating with third-party APIs and event-driven processing. You will learn about Google's Pub/Sub service for publication- and subscription-based processing and how to use Cloud Functions with Pub/Sub. Cloud Functions are well suited to respond to events in Cloud Storage. The chapter describes Cloud Storage events and how to use Cloud Functions to receive and respond to those events. You will learn how to use Cloud Operations to monitor and log details of Cloud Function executions. Finally, the chapter concludes with a discussion of guidelines for using and managing Cloud Functions.
- **[Chapter 11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml): Planning Storage in the Cloud**   Having described various compute options in Google Cloud, it is time to turn your attention to storage. This chapter describes characteristics of storage systems, such as their time to access, persistence, and data model. In this chapter, you will learn about differences between caches, persistent storage, and archival storage. You will learn about the cost–benefit trade-offs of using regional and multiregional persistent storage and using nearline versus Coldline and archival storage. The chapter includes details on the various Google Cloud storage options, including Cloud Storage for blob storage; Cloud SQL and Spanner for relational data; Firestore and Bigtable, for NoSQL storage; BigQuery for analytic data; and Cloud Firebase for mobile application data. The chapter includes detailed guidance on choosing a data store based on requirements for consistency, availability, transaction support, cost, latency, and support for various read/write patterns.
- **[Chapter 12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml): Deploying Storage in Google Cloud Platform**   In this chapter, you will learn how to create databases, add data, list records, and delete data from each of Google Cloud's storage systems. The chapter starts by introducing Cloud SQL, a managed database service that offers SQL Server, MySQL, and PostgreSQL managed instances. You will also learn how to create databases in Cloud Firestore, BigQuery, Bigtable, and Spanner. Next, you will turn your attention to Cloud Pub/Sub for storing data in message queues, followed by a discussion of Cloud Dataproc, a managed Hadoop and Spark cluster service, for processing big data sets. In the next section, you will learn about Cloud Storage for objects. The chapter concludes with guidance on how to choose a data store for a particular set of requirements.
- **[Chapter 13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c13.xhtml): Loading Data into Storage**   There are a variety of ways of getting data into Google Cloud. This chapter describes how to use the command-line SDK to load data into Cloud SQL, Cloud Storage, Firestore, BigQuery, Bigtable, and Dataproc. It also describes bulk importing and exporting from those same services. Next, you will learn about two common data loading patterns: moving data from Cloud Storage and streaming data to Cloud Pub/Sub.
- **[Chapter 14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml): Networking in the Cloud: Virtual Private Clouds and Virtual Private Networks**   In this chapter, you'll turn your attention to networking with an introduction to basic networking concepts, including the following:
  - IP addresses
  - CIDR blocks
  - Networks and subnetworks
  - Virtual private clouds (VPCs)
  - Routing and rules
  - Virtual private networks (VPNs)
  - Cloud DNS
  - Cloud Routers
  - Cloud Interconnect
  - External peering

  After being introduced to key networking concepts, you will learn how to create a VPC. Specifically, this includes defining a VPC, specifying firewall rules, creating a VPN, and working with load balancers. You will learn about different types of load balancers and when to use them.
- **[Chapter 15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml): Networking in the Cloud: DNS, Load Balancing, Google Private Access, and IP Addressing**  In this chapter, you will learn about common network management tasks such as defining subnetworks, adding subnets to a VPC, managing CIDR blocks, and reserving IP addresses. You will learn how to preform each of these tasks using Cloud Console, Cloud Shell, and Cloud SDK.
- **[Chapter 16](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml): Deploying Applications with Cloud Marketplace and Cloud Foundation Toolkit**  Google Cloud Marketplace is Google Cloud's marketplace of preconfigured stacks and services. This chapter introduces Cloud Marketplace and describes some applications and services currently available. You will learn how to browse Cloud Marketplace, deploy applications from Cloud Marketplace, and shut down Cloud Marketplace applications. The chapter also discusses Deployment Manager templates that automate the deployment of an application and launch a Deployment Manager template to provision Google Cloud resources and configure an application automatically.
- **[Chapter 17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml): Configuring Access and Security**  This chapter introduces identity management. In particular, you will learn about identities, roles, and assigning and removing identity roles. This chapter also introduces service accounts and how to create them, assign them to VMs, and work with them across projects. You will also learn how to view audit logs for projects and services. The chapter concludes with guidelines for configuring access control security.
- **[Chapter 18](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml): Monitoring, Logging, and Cost Estimating**  In the final chapter, we will discuss Cloud Operations alerts, logging, distributed tracing, and application debugging. Each of the corresponding Google Cloud services is designed to enable more efficient, functional, and reliable services. The chapter concludes with a review of the Pricing Calculator, which is helpful for estimating the cost of resources in Google Cloud.

## Interactive Online Learning Environment and Test Bank

---

![](../images/note_13.png) Like all exams, the Associate Cloud Engineer certification from Google Cloud is updated periodically and may eventually be retired or replaced. At some point after Google Cloud is no longer offering this exam, the old editions of our books and online tools will be retired. If you have purchased this book after the exam was retired, or are attempting to register in the Sybex online learning environment after the exam was retired, please know that we make no guarantees that this exam's online Sybex tools will be available once the exam is no longer available.

---

Studying the material in the *Google Cloud Certified Associate Cloud Engineer Study Guide, Second Edition* is an important part of preparing for the Associate Cloud Engineer certification exam, but we provide additional tools to help you prepare. The online Test Bank will help you understand the types of questions that will appear on the certification exam.

The sample tests in the Test Bank include all the questions in each chapter as well as the questions from the assessment test. In addition, there are two practice exams with 50 questions each. You can use these tests to evaluate your understanding and to identify areas where you may require additional study.

The flashcards in the Test Bank will push the limits of what you should know for the certification exam. There are 100 questions provided in digital format. Each flashcard has one question and one correct answer.

The online glossary is a searchable list of key terms introduced in this exam guide that you should know for the Associate Cloud Engineer certification exam.

To start using these to study for the Google Certified Associate Cloud Engineer exam, go to `www.wiley.com/go/sybextestprep` and register your book to receive your unique PIN. Once you have the PIN, return to `www.wiley.com/go/sybextestprep`, find your book and click Register or Login, and follow the link to register a new account or add this book to an existing account.

---

![](../images/note_13.png) Exam policies can change from time to time. We highly recommend that you check `https://cloud.google.com/certification` for the most up-to-date information when you begin your preparation, when you register, and again a few days before your scheduled exam date.

---

## Exam Objectives

The Associate Cloud Engineer certification is designed for people who create, deploy, and manage enterprise applications and infrastructure in Google Cloud. An Associate Cloud Engineer is comfortable working with Cloud Console, Cloud Shell, and Cloud SDK. Such individuals also understand products offered as part of Google Cloud and their appropriate use cases.

The exam will test your knowledge of the following:

- Planning a cloud solution using one or more Google Cloud services
- Creating a cloud environment for an organization
- Deploying applications and infrastructure
- Using monitoring and logging to ensure availability of cloud solutions
- Setting up identity management, access controls, and other security measures

### Objective Map

The following are specific objectives defined by Google at `https://cloud.google.com/certification/guides/cloud-engineer`.

### Section 1: Setting up a cloud solution environment

##### 1.1 Setting up cloud projects and accounts. Activities include:

- Creating a resource hierarchy
- Applying organizational policies to the resource hierarchy
- Granting members IAM roles within a project
- Managing users and groups in Cloud Identity (manually and automated)
- Enabling APIs within projects
- Provisioning and setting up products in Google Cloud's operations suite

##### 1.2 Managing billing configuration. Activities include:

- Creating one or more billing accounts
- Linking projects to a billing account
- Establishing billing budgets and alerts
- Setting up billing exports

##### 1.3 Installing and configuring the command-line interface (CLI), specifically Cloud SDK (e.g., setting the default project)

### Section 2: Planning and configuring a cloud solution

##### 2.1 Planning and estimating Google Cloud product use using the Pricing Calculator

##### 2.2 Planning and configuring compute resources. Considerations include:

- Selecting appropriate compute choices for a given workload (e.g., Compute Engine, Google Kubernetes Engine, Cloud Run, Cloud Functions)
- Using preemptible VMs and custom machine types as appropriate

##### 2.3 Planning and configuring data storage options. Considerations include:

- Product choice (e.g., Cloud SQL, BigQuery, Firestore, Cloud Spanner, Cloud Bigtable)
- Choosing storage options (e.g., Zonal persistent disk, Regional balanced persistent disk, Standard, Nearline, Coldline, Archive)

##### 2.4 Planning and configuring network resources. Tasks include:

- Differentiating load balancing options
- Identifying resource locations in a network for availability
- Configuring Cloud DNS

### Section 3: Deploying and implementing a cloud solution

##### 3.1 Deploying and implementing Compute Engine resources. Tasks include:

- Launching a compute instance using Cloud Console and Cloud SDK (`gcloud`) (e.g., assign disks, availability policy, SSH keys)
- Creating an autoscaled managed instance group using an instance template
- Generating/uploading a custom SSH key for instances
- Installing and configuring the Cloud Monitoring and Logging Agent
- Assessing compute quotas and requesting increases

##### 3.2 Deploying and implementing Kubernetes Engine resources. Tasks include:

- Installing and configuring the command line interface (CLI) for Kubernetes (`kubectl`)
- Deploying a Google Kubernetes Engine cluster with different configurations including AutoPilot, regional clusters, private clusters, etc.
- Deploying a containerized application to Google Kubernetes Engine
- Configuring Kubernetes Engine monitoring and logging

##### 3.3 Deploying and implementing Cloud Run and Cloud Functions resources. Tasks include, where applicable:

- Deploying an application and updating scaling configuration, versions, and traffic splitting
- Deploying an application that receives Google Cloud events (e.g., Pub/Sub events, Cloud Storage object change notification events)

##### 3.4 Deploying and implementing data solutions. Tasks include:

- Initializing data systems with products (e.g., Cloud SQL, Firestore, BigQuery, Cloud Spanner, Cloud Pub/Sub, Cloud Bigtable, Dataproc, Dataflow, Cloud Storage)
- Loading data (e.g., command line upload, API transfer, import/export, load data from Cloud Storage, streaming data to Pub/Sub)

##### 3.5 Deploying and implementing networking resources. Tasks include:

- Creating a VPC with subnets (e.g., custom-mode VPC, shared VPC)
- Launching a Compute Engine instance with custom network configuration (e.g., internal-only IP address, Google private access, static external and private IP address, network tags)
- Creating ingress and egress firewall rules for a VPC (e.g., IP subnets, network tags, service accounts)
- Creating a VPN between a Google VPC and an external network using Cloud VPN
- Creating a load balancer to distribute application network traffic to an application (e.g., global HTTP(S) load balancer, Global SSL Proxy load balancer, Global TCP Proxy load balancer, regional network load balancer, regional internal load balancer)

##### 3.6 Deploying a solution using Cloud Marketplace. Tasks include:

- Browsing the Cloud Marketplace catalog and viewing solution details
- Deploying a Cloud Marketplace solution

##### 3.7 Implementing resources via infrastructure as code. Tasks include:

- Building infrastructure via Cloud Foundation Toolkit templates and implementing best practices
- Installing and configuring Config Connector in Google Kubernetes Engine to create, update, delete, and secure resources

### Section 4: Ensuring successful operation of a cloud solution

##### 4.1 Managing Compute Engine resources. Tasks include:

- Managing a single VM instance (e.g., start, stop, edit configuration, or delete an instance)
- Remotely connecting to the instance
- Attaching a GPU to a new instance and installing necessary dependencies
- Viewing current running VM inventory (instance IDs, details)
- Working with snapshots (e.g., create a snapshot from a VM, view snapshots, delete a snapshot)
- Working with images (e.g., create an image from a VM or a snapshot, view images, delete an image)
- Working with instance groups (e.g., set autoscaling parameters, assign instance template, create an instance template, remove an instance group)
- Working with management interfaces (e.g., Google Cloud console, Cloud Shell, Cloud SDK)

##### 4.2 Managing Kubernetes Engine resources. Tasks include:

- Viewing current running cluster inventory (nodes, pods, services)
- Browsing Docker images and viewing their details in Artifact Registry
- Working with nodes pools (e.g., add, edit, or remove a node pool)
- Working with pods (e.g., add, edit, or remove pods)
- Working with services (e.g., add, edit, or remove a service)
- Working with stateful applications (e.g., persistent volumes, stateful sets)
- Managing Horizontal and Vertical autoscaling configurations
- Working with management interfaces (e.g., Google Cloud console, Cloud Shell, Cloud SDK, kubectl)

##### 4.3 Managing Cloud Run resources. Tasks include:

- Adjusting application traffic-splitting parameters
- Setting scaling parameters for autoscaling instances
- Determining whether to run Cloud Run (fully managed) or Cloud Run for Anthos

##### 4.4 Managing storage and database solutions. Tasks include:

- Managing and securing objects in and between Cloud Storage buckets
- Setting object life cycle management policies for Cloud Storage buckets
- Executing queries to retrieve data from data instances (e.g., Cloud SQL, BigQuery, Cloud Spanner, Datastore, Cloud Bigtable)
- Estimating costs of data storage resources
- Backing up and restoring database instances (e.g., Cloud SQL, Datastore)
- Reviewing job status in Dataproc, Dataflow, or BigQuery

##### 4.5 Managing networking resources. Tasks include:

- Adding a subnet to an existing VPC
- Expanding a subnet to have more IP addresses
- Reserving static external or internal IP addresses
- Working with CloudDNS, CloudNAT, Load Balancers and firewall rules

##### 4.6 Monitoring and logging. Tasks include:

- Creating Cloud Monitoring alerts based on resource metrics
- Creating and ingesting Cloud Monitoring custom metrics (e.g., from applications or logs)
- Configuring log sinks to export logs to external systems (e.g., on-premises or BigQuery)
- Configuring log routers
- Viewing and filtering logs in Cloud Logging
- Viewing specific log message details in Cloud Logging
- Using cloud diagnostics to research an application issue (e.g., viewing Cloud Trace data, using Cloud Debug to view an application point-in-time)
- Viewing Google Cloud status

### Section 5: Configuring access and security

##### 5.1 Managing Identity and Access Management (IAM). Tasks include:

- Viewing IAM policies
- Creating IAM policies
- Managing the various role types and defining custom IAM roles (e.g., primitive, predefined and custom)

##### 5.2 Managing service accounts. Tasks include:

- Creating service accounts
- Using service accounts in IAM policies with minimum permissions
- Assigning service accounts to resources
- Managing IAM of a service account
- Managing service account impersonation
- Creating and managing short-lived service account credentials

##### 5.3 Viewing audit logs

## How to Contact the Publisher

If you believe you've found a mistake in this book, please bring it to our attention. At John Wiley & Sons, we understand how important it is to provide our customers with accurate content, but even with our best efforts an error may occur.

In order to submit your possible errata, please email it to our Customer Service Team at `wileysupport@wiley.com` with the subject line “Possible Book Errata Submission.”

## Assessment Test

1. Instance templates are used to create a group of identical VMs. The instance templates include:
   1. Machine type, boot disk image or container image, zone, and labels
   2. Cloud Storage bucket definitions
   3. A load balancer description
   4. App Engine configuration file
2. The command-line command to create a Cloud Storage bucket is:
   1. `gcloud mb`
   2. `gsutil mb`
   3. `gcloud mkbucket`
   4. `gsutil mkbucket`
3. Your company has an object management policy that requires that objects stored in Cloud Storage be migrated from standard storage to nearline storage 90 days after the object is created. The most efficient way to do this is to:
   1. Create a Cloud Function to copy objects from regional storage to nearline storage.
   2. Set the `MigrateObjectAfter` property on the stored object to 90 days.
   3. Copy the object to persistent storage attached to a VM and then copy the object to a bucket created on nearline storage.
   4. Create a life cycle management configuration policy specifying an age of 90 days and `SetStorageClass` as nearline.
4. An education client maintains a site where users can upload videos, and your client needs to assure redundancy for the files; therefore, you have created two buckets for Cloud Storage. Which command do you use to synchronize the contents of the two buckets?
   1. `gsutil rsync`
   2. `gcloud cp sync`
   3. `gcloud rsync`
   4. `gsutil cp sync`
5. VPC resources are which of the following?
   1. Regional
   2. Zonal
   3. Global
   4. Subnet
6. A remote component in your network has failed, which results in a transient network error. When you submit a `gsutil` command, it fails because of a transient error. By default, the command will:
   1. Terminate and log a message to Cloud Monitoring
   2. Retry using a truncated binary exponential backoff strategy
   3. Prompt the user to decide to retry or quit
   4. Terminate and log a message to Cloud Shell
7. All of the following are components of firewall rules except which one?
   1. Direction of traffic
   2. Action on match
   3. Time to live (TTL)
   4. Protocol
8. Adding virtual machines to an instance group can be triggered in an autoscaling policy by all of the following, except which one?
   1. CPU utilization
   2. Cloud Monitoring metrics
   3. IAM policy violation
   4. Load balancing serving capacity
9. Your company's finance department is developing a new account management application that requires transactions and the ability to perform relational database operations using fully compliant SQL. Data store options in Google Cloud include:
   1. Spanner and Cloud SQL
   2. Firestore and Bigtable
   3. Spanner and Cloud Storage
   4. Firestore and Cloud SQL
10. The marketing department in your company wants to deploy a web application but does not want to have to manage servers or clusters. A good option for them is:
    1. Compute Engine
    2. Kubernetes Engine
    3. Cloud Run
    4. Cloud Functions
11. Your company is building an enterprise data warehouse and wants SQL query capabilities over petabytes of data, but does not want to manage servers or clusters. A good option for them is:
    1. Cloud Storage
    2. BigQuery
    3. Bigtable
    4. Firestore
12. You have been hired as a consultant to a startup in the Internet of Things (IoT) space. The startup will stream large volumes of data into Google Cloud. The data needs to be filtered, transformed, and analyzed before being stored in Google Cloud Firestore. A good option for the stream processing component is:
    1. Dataproc
    2. Cloud Dataflow
    3. Cloud Endpoints
    4. Cloud Interconnect
13. Preemptible virtual machines may be shut down at any time but will always be shut down after running:
    1. 6 hours
    2. 12 hours
    3. 24 hours
    4. 48 hours
14. You have been tasked with designing an organizational hierarchy for managing departments and their cloud resources. What organizing components are available in Google Cloud?
    1. Organization, folders, projects
    2. Buckets, directories, subdirectories
    3. Organizations, buckets, projects
    4. Folders, buckets, projects
15. During an incident that has caused an application to fail, you suspect some resource may not have appropriate roles granted. The command to list roles granted to a resource is:
    1. `gutil iam list-grantable-roles`
    2. `gcloud iam list-grantable-roles`
    3. `gcloud list-grantable-roles`
    4. `gcloud resources grantable-roles`
16. The availability of CPU platforms can vary between zones. To get a list of all CPU types available in a particular zone, you should use:
    1. `gcloud compute zones describe`
    2. `gcloud iam zones describe`
    3. `gutil zones describe`
    4. `gcloud compute regions list`
17. To create a custom role, a user must possess which role?
    1. `iam.create`
    2. `compute.roles.create`
    3. `iam.roles.create`
    4. `Compute.roles.add`
18. You have been asked to create a network with 1,000 IP addresses. In the interest of minimizing unused IP addresses, which CIDR suffix would you use to create a network with at least 1,000 addresses but no more than necessary?
    1. /20
    2. /22
    3. /28
    4. /32
19. A team of data scientists have asked for your help setting up an Apache Spark cluster. You suggest they use a managed Google Cloud service instead of managing a cluster themselves on Compute Engine. The service they would use is:
    1. Dataproc
    2. Cloud Dataflow
    3. Cloud Hadoop
    4. BigQuery
20. You have created a web application that allows users to upload files to Cloud Storage. When files are uploaded, you want to check the file size and update the user's total storage used in their account. A serverless option for performing this action on load is:
    1. Cloud Dataflow
    2. Dataproc
    3. Cloud Storage
    4. Cloud Functions
21. Your company has just started using Google Cloud, and executives want to have a dedicated connection from your data center to the Google Cloud to allow for large data transfers. Which networking service would you recommend?
    1. Google Cloud Carrier Internet Peering
    2. Google Cloud Dedicated Interconnect
    3. Google Cloud Internet Peering
    4. Google Cloud DNS
22. You want to have Google Cloud manage cryptographic keys, so you've decided to use Cloud Key Management Services. Before you can start creating cryptographic keys, you must:
    1. Enable Google Cloud Key Management Service (KMS) API and set up billing.
    2. Enable Google Cloud KMS API and create folders.
    3. Create folders and set up billing.
    4. Give all users grantable roles to create keys.
23. In Kubernetes Engine, a node pool is:
    1. A subset of nodes across clusters
    2. A set of VMs managed outside of Kubernetes Engine
    3. A set of preemptible VMs
    4. A subset of node instances within a cluster that all have the same configuration
24. The Google Cloud service for storing and managing Docker containers is:
    1. Cloud DevOps Repository
    2. Cloud Build
    3. Container Registry
    4. Docker Repository
25. Code for Cloud Functions can be written in several languages, including:
    1. Node.js and Python only
    2. Node.js, Python, and Go
    3. Python and Go
    4. Python and C

## Answers to Assessment Test

1. A.Machine type, boot disk image or container image, zone, and labels are all configuration parameters or attributes of a VM and therefore would be included in an instance group configuration that creates those VMs.
2. B. `gsutil` is the command line for accessing and manipulating Cloud Storage from the command line. `mb` is the specific command for creating, or making, a bucket.
3. D. The life cycle configuration policy allows you to specify criteria for migrating data to other storage systems without having to concern yourself with running jobs to actually execute the necessary steps. The other options are inefficient or do not exist.
4. A. `gsutil` is the command-line tool for working with Cloud Storage. `rsync` is the specific command in `gsutil` for synchronizing buckets.
5. C. Google operates a global network, and VPCs are resources that can span that global network.
6. B. `gcloud` by default will retry a failed network operation and will wait a long time before each retry. The time to wait is calculated using a truncated binary exponential backoff strategy.
7. C. Firewall rules do not have TTL parameters. Direction of traffic, action on match, and protocol are all components of firewall rules.
8. C. IAM policy violations do not trigger changes in the size of clusters. All other options can be used to trigger a change in cluster size.
9. A. Only Spanner and Cloud SQL databases support transactions and have a SQL interface. Firestore has transactions but does not support fully compliant SQL; it has a SQL-like query language. Cloud Storage does not support transactions or SQL.
10. C. Cloud Run is a serverless service for running containers and allows developers to deploy full applications without having to manage servers or clusters. Compute Engine and Kubernetes Engine require management of servers. Cloud Functions is suitable for short-running Node.js or Python functions but not full applications.
11. B. BigQuery is designed for petabyte-scale analytics and provides a SQL interface.
12. B. Cloud Dataflow allows for stream and batch processing of data and is well suited for this kind of ETL work. Dataproc is a managed Hadoop and Spark service that is used for big data analytics. Cloud Endpoints is an API service, and Cloud Interconnect is a network service.
13. C. If a preemptible machine has not been shut down within 24 hours, Google will stop the instance.
14. A. Organizations, folders, and projects are the components used to manage an organizational hierarchy. Buckets, directories, and subdirectories are used to organize storage.
15. B. `gcloud` is the command-line tool for working with IAM, and `list-grantable-roles` is the correct command.
16. A. `gcloud` is the command-line tool for manipulating compute resources, and `zones describe` is the correct command.
17. C. `iam.roles.create` is correct; the other roles do not exist.
18. B. The /22 suffix produces 1,022 usable IP addresses.
19. A. Dataproc is the managed Spark service. Cloud Dataflow is for stream and batch processing of data, BigQuery is for analytics, and Cloud Hadoop is not a Google Cloud service.
20. D. Cloud Functions respond to events in Cloud Storage, making them a good choice for taking an action after a file is loaded.
21. B. Google Cloud Dedicated Interconnect is the only option for a dedicated connection between a customer's data center and a Google data center.
22. A. Enabling the Google Cloud KMS API and setting up billing are steps common to using Google Cloud services.
23. D. A node pool is a subset of node instances within a cluster that all have the same configuration.
24. C. The Google Cloud service for storing and managing Docker containers is Artifact Registry. Cloud Build is for creating images. Cloud Source Repositories are private Git repositories hosted on Google Cloud Docker Repository is not a Google Cloud service.
25. B. Node.js, Python, and Go are three of the languages supported by Cloud Functions.