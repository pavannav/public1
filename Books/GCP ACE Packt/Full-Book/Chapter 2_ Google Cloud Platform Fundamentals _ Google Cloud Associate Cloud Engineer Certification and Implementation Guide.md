# 2

# Google Cloud Platform Fundamentals

This second chapter will focus on Google Cloud Platform fundamentals. We will describe all the core layers of Google Cloud, how they relate to each other, and their core components. We will find out the benefits of each Google Cloud layer and learn when to use them. We are going to cover the following main topics:

- Why Google Cloud Platform?
- Choosing the right cloud solution
- An overview of the core services offered by Google Cloud
- Management interfaces and command-line tools

# Why Google Cloud Platform?

Google and Google Cloud are well-known and established parts of the leading company *Alphabet*. You must have used Google’s products such as Gmail, YouTube, or the Google search engine at some point in time. But have you ever used Google Cloud Platform? You might be asking yourself the following questions:

- Why should I try it out?
- What is in it for me?
- Why should I learn another cloud when I have already learned the other ones?
- Is it worth investing the time in learning it?

We asked ourselves these questions as well, not only before studying for the certification but to also think about whether or not it is worth spending the time to be a Google Cloud expert.

## Google 1 billion users experience

We mentioned Gmail, YouTube, and the Google search engine, Google Chrome, as some of the products that Google invented and that are used daily around the world. You might ask yourself why.

Google as a technological company faced tremendous growth and many challenges along the road. During this growth, Google engineers and Google products evolved, fixed many problems never tackled by anyone else, and constantly improved their products.

In 2004, Google invented the MapReduce programming model, which was inspired by Apache MapReduce and the **Hadoop Distributed File System** (**HDFS**) filesystem. The Bigtable NoSQL database in 2006 inspired Apache HBase and Cassandra, as some of the best-known open source projects that were modeled after Bigtable. The Borg cluster controller in 2015, with the Omega scheduler, was announced in 2016, which became the open source project well known as Kubernetes.

To learn more about Google Cloud and its contribution to open source projects, you can visit the following link: <https://cloud.google.com/open-cloud>.

## The history of Google Cloud

Monday, April 7, 2008, was the day when Google announced the preview release of Google App Engine, and this date is considered the beginning of Google Cloud. App Engine was a tool used to easily run their web applications on Google-grade infrastructure. Service became generally available in November 2011.

## Google Cloud today

At the time of writing in April 2023, Google Cloud is currently available in 37 regions, with a total of 112 separate zones and 176 network edge locations, and it operates in 200+ countries and territories.

By the time you read this book, Google Cloud will have expanded into other regions. You can visit the following URL to check where it operates at a given time: <https://cloud.google.com/about/locations>

As a global cloud provider, Google Cloud ensures to locate the resources closest to its users and their businesses. Google Cloud is heavily investing in its global presence and its expansion plans into new regions confirm this. At the time of writing, Google Cloud offers at a minimum the following products at launch:

- Google Compute Engine (GCE)
- **Google Kubernetes** **Engine** (**GKE**)
- Cloud Storage
- Persistent Disk
- Cloud SQL
- **Virtual Private** **Cloud** (**VPC**)
- Key Management Service
- Cloud Identity
- Secret Manager

Other Google Cloud products will continue to evolve based on the demand from customers.

In the following figure (the original image can be found here: <https://cloud.google.com/images/locations/regions.png>), we can see Google Cloud’s global presence, including the existing and planned regions for 2023. It is worth mentioning that Google Cloud splits each region into three separate zones:

![Figure 2.1 – Google Cloud regions across the world](../images/B18851_02_01.jpg)

Figure 2.1 – Google Cloud regions across the world

Regions are just part of the Google Cloud presence. All regions are connected with each other via global networks and **Content Delivery Network** (**CDN**) points of presence.

![Figure 2.2 – Google Cloud Edge points of presence across the world](../images/B18851_02_02.jpg)

Figure 2.2 – Google Cloud Edge points of presence across the world

To view current Google Cloud locations, visit the website <https://cloud.google.com/about/locations>.

## What makes Google Cloud different?

There is no right answer to this question because every customer and business is different and has different requirements. We have gathered differentiators that might be the most common ones. Let’s have a look at them:

- Google-grade security
  - Google has managed their infrastructure for more than 15 years and this experience has allowed them to keep customers safe when using applications such as Gmail or Google Apps. Google Cloud is based on this experience and provides additional security products for customers.
- Billing by the second
  - GCE instances use a 1-second billing feature that allows customers to only pay for used resources.
- Big data
  - Innovation is the core principle of Google and this has led not only to technological innovations such as MapReduce, Bigtable, and Dremel but also next-generation services for cloud data warehousing (BigQuery), advanced ML (AI Platform), batch and real-time data processing (Dataflow, Pub/Sub, and Dataproc), and visual analytics (Google Looker Studio). Google Cloud big data solutions are serverless, which removes complexity and increases the ease of use.
- Global network
  - Google Cloud networks have global availability by default and are scaled according to software-defined solutions, instantly responding to users’ needs.
- Environment friendly
  - Google Cloud data centers run on 100% renewable energy where it is available. Since 2017, Google has been carbon neutral and has set the goal to run all its data centers carbon free 24/7/365 by 2030.

Recently, Google Cloud released carbon footprint tools, which allow customers to choose **virtual machines** (**VMs**) with low CO2 emissions, resulting in a lower carbon footprint.

In the following figure, we have an excellent example of this commitment. When creating a **GCE** VM, users can choose the Google Cloud region with the lowest CO2 consumption:

![Figure 2.3 – The creation of the VM with a selection of regions with a low CO2 footprint](../images/B18851_02_03.jpg)

Figure 2.3 – The creation of the VM with a selection of regions with a low CO2 footprint

Google provides cloud sustainability reports at the following website: <https://cloud.google.com/sustainability>

This website is a great resource for anyone who would like to learn more about what Google did in the past to work toward carbon neutrality, and how Google wants all their data centers to be carbon free by 2030.

# Choosing the right cloud solution

To have a better understanding of which cloud solution might suit your requirements, we have created a diagram with an overview of services and their corresponding customer and provider responsibilities:

![Figure 2.4 – An on-premises versus IaaS versus PaaS versus SaaS comparison](../images/B18851_02_04.jpg)

Figure 2.4 – An on-premises versus IaaS versus PaaS versus SaaS comparison

Let’s dig into the four different types of resource consumption with varied usage and responsibilities.

## On-premises

On-premises service usage is the classical deployment and management of resources. The whole responsibility lies with the data center or service owner at all layers – the OS, storage, data, and applications. You must ensure service availability, provision resources, and manage them. In addition, you are responsible for any maintenance activities, and you must plan well in advance, for not only the purchase but also the capacity of the infrastructure.

## Infrastructure as a service

Now, we move to the **Infrastructure as a Service** (**IaaS**) cloud consumption model where the cloud provider is responsible for hardware – the servers, storage, networking, security, availability, cooling, electricity, and infrastructure capacity. By offloading this to the cloud provider, customers have already gained some advantages in comparison with on-premises services. Customers can focus on delivering the applications and managing resources while still having full access to the OS, applications, and data.

Some of Google Cloud’s IaaS services are as follows:

- GCE
- Cloud Storage
- VPC
- Persistent Disk

The preceding list is not comprehensive and we will discuss IaaS services in further detail in upcoming chapters.

## Platform as a service

The layer above IaaS is **Platform as a Service** (**PaaS**). Customers who are using the PaaS model benefit from all services that are included in the IaaS model. However, in contrast to IaaS, they no longer need to patch OSs or update SQL databases.

What they need to take care of is planning the deployment type (whether using a single database or a replicated one), in which region to deploy Cloud SQL, and how to design their database schema. The cloud provider takes care of patching, building the database, and making it highly available. On-premises deployments of such a service might take a massive amount of time, consume countless hours, involve many teams, and most importantly, consume a huge amount of funds.

Some of Google Cloud’s PaaS services are as follows:

- App Engine
- Cloud SQL

The preceding list is not comprehensive and we will discuss the PaaS service in further detail in upcoming chapters.

## Software as a service

The final cloud consumption model is **Software as a Service** (**SaaS**). It is a way of delivering without installing and maintaining any software, and there is no need to patch OSs or applications. We focus solely on software consumption and usage. One great analogy of SaaS is by thinking of a bank that takes care of simply providing access to us as customers. How a bank is doing it is irrelevant to us – we simply consume bank services.

If we go back to cloud services, IaaS and PaaS are managed by a cloud provider, and we simply focus on consuming services or applications.

Some of Google Cloud’s SaaS services are as follows:

- Cloud DNS
- Cloud Armor
- Cloud CDN
- Cloud IAM

The preceding list is not comprehensive and we will discuss SaaS in further detail in upcoming chapters.

We have covered all the types of cloud services consumption and compared them to traditional on-premises service consumption. Each type of cloud consumption has different layers and responsibilities divided between cloud users and cloud providers. This will allow you to choose the best solution based on your requirements and needs.

# An overview of the core services offered by Google Cloud

Google Cloud offers more than 100 products to their customers. It is very hard to list all these products and it doesn’t bring much value to our Associate Cloud Engineer certification journey. Therefore, we have decided to list the core services from computing, storage, networking, security, and AI and ML.

A full list of Google Cloud products can be accessed by visiting the following web page: <https://cloud.google.com/products>

### Compute services

We start with a list of core compute services:

- App Engine
  - A managed application platform
- Bare Metal
  - Dedicated hardware for specialized workloads
- Cloud Run
  - A serverless solution for containerized applications
- GCE
  - VMs from Google Cloud
- Spot VMs and preemptible VMs
  - Google Compute instances with a short lifetime, ideal for batch jobs and fault-tolerant workloads
- Shielded VMs
  - Hardened Google Compute VMs
- Sole-tenant nodes
  - Dedicated hardware designed for workloads that require compliance and licensing
- SQL Server on Google Cloud
  - A managed SQL Server solution to run MySQL, PostgreSQL, and Microsoft SQL Server
- VMware Engine
  - A fully managed VMware as a service solution

The preceding list is very comprehensive and not all products are relevant to the Associate Cloud Engineer certification.

## Storage services

We have listed the core storage services that complement compute services from Google Cloud as follows. Very often, both services are used together, but some products such as Cloud Storage can be consumed separately:

- Storage Transfer Service
  - A service for transferring a large amount of data to Google Cloud with the usage of storage appliances
- Cloud Storage
  - Secure object storage with high durability and scalability
- Filestore
  - A managed NFS service
- Local SSD
  - Highly performant, locally attached to GCE instances, NVMe disks
- Persistent Disk
  - Block storage for Google Compute VMs

The most popular storage services are Cloud Storage and Persistent Disk. We will focus on them in the upcoming chapters of the book.

## Networking services

Another set of services that are used daily in Google Cloud are networking services, from Cloud CDN or DNS to a core service, which is VPC:

- Cloud Armor
  - A DDoS and web application firewall service
- Cloud CDN
  - A global CD
- Cloud DNS
  - A managed domain name resolution service
- Cloud IDS
  - A Cloud **Intrusion Detection System** (**IDS**) that provides network threat detection
- Cloud Load Balancing
  - A multi-region load balancing solution
- Cloud NAT
  - A managed NAT service for GCE VMs
- Hybrid connectivity
  - Cloud VPN, Interconnect, and Partner Interconnect for connecting with Google Cloud
- Network Service Tiers
  - Tier-based network options
- Network Telemetry
  - Monitoring of the Google Cloud network with VPC flow logs
- Private Service Connect
  - A secure connection between your VPC and other Google Cloud services
- Traffic Director
  - A service with a traffic control plane and management for open service mesh
- VPC
  - A global virtual network for Google Cloud resources

Network services from Google Cloud are unique in the market and are one of its key differentiators.

## Security and identity services

Security and identity services are another set of services from Google Cloud that are crucial to every customer. The most important ones are listed as follows:

- Access Transparency
  - A service for customers to use to audit cloud provider access to resources
- Assured Workloads
  - Allows customers to use Google Cloud in compliance with the requirements
- Binary Authorization
  - A service for deploying trusted containers on GKE
- Chronicle
  - Security insights from telemetry
- Cloud Asset Inventory
  - An asset management service to view, monitor, and analyze Google Cloud resources
- Cloud Data Loss Prevention
  - A service for classifying, inspecting, and redacting sensitive data
- Cloud Key Management
  - A managed security keys offering
- Confidential Computing
  - Fully encrypted VMs
- Firewalls
  - Global firewall solutions for protecting cloud resources
- Cloud IAM
  - A service for managing resources and access
- Secret Manager
  - Securely stores API keys, passwords, or certificates
- Security Command Center
  - A bird’s-eye view into the security of your Google Cloud services
- VPC Service Controls
  - API-based security controls
- VM Manager
  - Provides a OS patch management, OS configuration management, and OS inventory management service

Google Cloud offers a comprehensive set of services with a core focus on security based on many years of experience and its customers’ requirements.

## AI and ML services

We’ll finish detailing the core services by listing AI and ML services. This list includes the newly released Vertex AI platform, which combines many AI capabilities into one product:

- Vertex AI
  - A managed platform for ML
- AutoML
  - A custom low-code ML model training and development service
- Vision AI
  - Pre-trained models for detecting emotion, text, and more from images
- Video AI
  - Video analysis that recognizes objects, places, and actions in videos using ML
- Cloud Natural Language
  - A service for extracting from, analysing, and classifying unstructured text
- Cloud Translation
  - Detects and translates languages with dynamic translation
- Text-to-Speech
  - Speech synthesis in 220+ voices and 40+ languages
- Speech-to-Text
  - Speech recognition and transcription supporting 125 languages
- Dialogflow
  - A platform for designing and integrating user interfaces into mobile applications, web applications, or bots
- AutoML Tables (beta)
  - A service for building and deploying ML models using structured data
- Recommendations AI
  - AI product-based recommendations for any customer interfaces
- AI Infrastructure
  - A service to use to train deep learning and ML models
- Cloud **Tensor Processing** **Units** (**TPUs**)
  - TPUs for ML applications

Google Cloud is well known for its advanced and best-on-the-market AI and ML products. Although Associate Cloud Engineer focuses more on computing, storage, networking, and security, it is still worth mentioning the best products on the market.

# Management interfaces and command-line tools

There is no one right or wrong way to use Google Cloud services. Every customer or company has a different way of using Google Cloud and all of them are good. Developers use the cloud via API calls or code execution and security officers might simply use the Google Cloud console from the browser.

In the following sections, we’ve described all the interfaces that can be used to manage and use Google Cloud.

## Google Cloud console

For most users, the Google Cloud console will be the primary tool that they use to interact with Google Cloud. It uses a modern interface, with the possibility to customize the dashboard, allowing users to pin services and organize them for ease of use. The following figure shows a typical Google Cloud console. The Cloud console can be configured according to your requirements and what you want to see there. To do it, use the drag-and-drop functionality on the widgets:

![Figure 2.5 – The Google Cloud console main screen](../images/B18851_02_05.jpg)

Figure 2.5 – The Google Cloud console main screen

Typically, it can be accessed from computers as well as mobile devices.

## Cloud Shell

Cloud Shell is a Linux shell provided for every Google Cloud user. It has a set of pre-installed development tools such as the gcloud CLI, kubectl, Terraform, and Git. Users can access it directly from the browser and it provides 5 GB of Persistent Disk storage.

![Figure 2.6 – The Cloud Shell main screen](../images/B18851_02_06.jpg)

Figure 2.6 – The Cloud Shell main screen

Cloud Shell is the ideal solution for users who don’t want to use a locally configured command-line interface or who want to always use the same pre-configured terminal, which is ready in a few seconds.

## The gcloud CLI

The gcloud CLI is a set of command-line tools for managing Google Cloud resources. With the gcloud CLI, you can perform all the actions that can be done in the browser-based Google Cloud console. The gcloud CLI can be installed on many OSs, including the following:

- Generic Linux
- Debian/Ubuntu
- Red Hat/Fedora/CentOS
- macOS
- Windows

In *Figure 2**.7*, you will find the Google Cloud SDK installed on Windows. Although it might look different on your OS, the functionality is the same:

igure 2.7 – The gcloud CLI installed on Windows 10

To review the installation instructions, visit the following link: <https://cloud.google.com/sdk/docs/install-sdk#installing_the_latest_version>.

## Cloud APIs

Cloud APIs allow users to interact with Google Cloud directly from your code. Cloud APIs provide a similar functionality to Cloud SDKs and the Google Cloud console. Integrating Cloud APIs with REST calls or client libraries is possible in many popular programming languages. For example, GCE can be accessed from client libraries written in C#, Go, Java, Node.js, PHP, Python, and Ruby.

The following is a JSON-formatted example of a GCE API with an IP address:

igure 2.8 – A sample representation of an IP address resource in the JSON-formatted GCE API

Google Cloud API resources can have different descriptions and use many different values.

## Config Connector

For those who are familiar with Kubernetes and would like to manage Google Cloud resources the *Kubernetes way*, Google Cloud offers the Config Connector tool. It is very similar to managing Kubernetes resources in the YAML format. Config Connector provides a collection of Kubernetes **CustomResourceDefinitions** (**CRDs**) and controllers, which eventually reconcile your environment with your desired state:

igure 2.9 – A sample configuration file in YAML format in Config Connector

The preceding figure shows the Config Connector configuration file that is required for its initial usage.

## Google Cloud Deployment Manager

Google Cloud Deployment Manager is a deployment service that allows automation and Google Cloud resource management. It uses the concept of a configuration file with YAML-based syntax that can import one or more template files used during the deployment. Templates can be written in Jinja or Python.

![Figure 2.10 – A sample configuration file in YAML format in Deployment Manager](../images/B18851_02_10.jpg)

Figure 2.10 – A sample configuration file in YAML format in Deployment Manager

You can visit the Google Cloud GitHub repository to find more examples in Jinja and Python: <https://github.com/GoogleCloudPlatform/deploymentmanager-samples>

Deployment Manager can only be used to deploy Google Cloud resources.

## Terraform

Terraform is an **Infrastructure** **as Code** (**IaC**) software tool created by HashiCorp. Terraform use its own declarative language, **HashiCorp Configuration Language** (**HCL**), or JSON.

Terraform abstracts underlying resources with its own programming language and allows users to focus on deployment, rather than learning each deployment target-specific language. In simple words, if you learn how to use HCL, you no longer need to learn how to deploy specific cloud provider features and you use the necessary Terraform provider. The following is a sample code part written in HCL, which describes a Cloud SQL instance deployment:

![Figure 2.11 – Terraform sample configuration code describing a Cloud SQL instance deployment](../images/B18851_02_11.jpg)

Figure 2.11 – Terraform sample configuration code describing a Cloud SQL instance deployment

Similar to Cloud APIs, Terraform’s IaC approach allows for the use of software-deployment-like techniques with infrastructure.

## Service Catalog

Service Catalog is a product intended for cloud administrators who manage Google Cloud organizations where control distribution, internal compliance, and solution discoverability are needed.

It allows us to curate available products in Service Catalog and allows easy resource visibility and deployment at the organization, folder, and project levels. It is a go-to tool for ensuring internal compliance and governance.

The following figure shows the creation of a link-based solution:

![Figure 2.12 – A sample configuration of Service Catalog](../images/B18851_02_12.jpg)

Figure 2.12 – A sample configuration of Service Catalog

Once a solution is created, it will appear in the **Solutions** table.

## Mobile applications

Google Cloud offers mobile applications for both Android and iOS, which give users the ability to monitor and make changes to Google Cloud resources. You can manage resources such as projects, billing, an App Engine app, or GCE VMs.

You can use the following features:

- Incident management
  - Open, assign, acknowledge, and resolve incidents
- GCE
  - Start, stop, and turn SSH into instances and view logs from each instance
- App Engine
  - Troubleshoot errors, roll back deployments, and change traffic splitting
- Alerts
  - Get alerts on production issues
- Dashboard
  - View the health of your services, view graphs, and key metrics
- Cloud Storage
  - View and delete Cloud Storage data
- Error reporting
  - Understand crashes of your cloud services
- Billing
  - See up-to-date billing information and get billing alerts for projects
- Cloud SQL
  - View the health of, start, and stop Cloud SQL instances

With all the features provided in the mobile application, you can view your most important resources from your smartphone as well.

The following figure shows multiple sections that can be viewed in the application, such as the dashboard, resources overview, billing, and monitoring:

![Figure 2.13 – An overview of the mobile application](../images/B18851_02_13.jpg)

Figure 2.13 – An overview of the mobile application

Mobile applications can be installed on Android or iOS, allowing simplified cloud management on the go.

# Summary

This chapter focused on bringing Google Cloud closer to us. We learned how and when Google Cloud started its business, and we tried to understand what makes it different within the market. Later on, our focus was on choosing the right cloud solution. We learned about the different types of services and when to use them. We then listed the essential Google Cloud services necessary to ace the exam and core services within IaaS, PaaS, and SaaS solutions.

At the end of this chapter, we learned different ways to interact with Google Cloud.

In the next chapter, we will learn how to plan and manage Google Cloud resources.

# Questions

Answer the following questions to test your knowledge of this chapter:

1. In the IaaS cloud delivery model, who manages servers, storage, and networks?
   1. You
   2. The cloud provider
   3. You and the cloud provider together
   4. Managed Service Provider
2. Which *as a service* model offers the most flexibility in the operating system and application configuration?
   1. SaaS
   2. PaaS
   3. IaaS
   4. IDaaS
3. In the PaaS model, who will install a new database patch?
   1. It will be you, as you have full access to the database
   2. The cloud provider, as this is its responsibility
   3. It will be a joint effort between you and the cloud provider
   4. None of the above
4. Which tools can be used to manage Google Cloud resources?
   1. Config Manager, the gcloud CLI, and the Google Cloud console
   2. Terraform, Cloud APIs, and Cloud Shell
   3. Cloud Shell, Service Manager, and the Google Cloud console
   4. Cloud Shell, the gcloud CLI, and Cloud APIs
5. What is the name of the Google Cloud service to run VMs?
   1. Google Compute Engine (GCE)
   2. Google Kubernetes Engine (GKE)
   3. Google Storage (GS)
   4. Google Elastic Compute (GEC)
6. Which components are the base of a VM?
   1. The operating system
   2. The compute disk
   3. The processor and RAM
   4. All of the above
7. You have been asked to store millions of small files on a cheap but powerful storage solution. What will you choose?
   1. Persistent Disk
   2. Google Cloud Storage
   3. Cloud Filestore
   4. Storage Transfer Service
8. You are tasked to choose the best solution to host containerized applications with node control, scale, and cluster configuration. Choose the correct answer.
   1. Cloud Run
   2. Spot VMs
   3. GKE
   4. Cloud Armor
9. Google Cloud VPC is which of the following by default?
   1. Configured with pre-defined IP ranges
   2. Global
   3. Software-defined
   4. All the above
10. What are the benefits of cloud computing?
    1. Billing by the second, easy resource allocation, and security
    2. Paying only by usage, no commitments, and a broad product portfolio
    3. No need for upfront investment in the hardware and managed services such as Cloud SQL or Cloud Run
    4. All of the above

# Answers

The answers to the preceding questions are provided here:

1D, 2C, 3B, 4B, 5A, 6D, 7B, 8C, 9D, 10D