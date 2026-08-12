---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVE OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- ![](../images/tick_5.png) **2.2 Planning and configuring compute resources**

---

In this chapter, you will learn about each of the compute options available in Google Cloud and when to use them. We will also discuss preemptible virtual machines and when they can help reduce your overall computing costs.

## Compute Engine

Compute Engine is a service that provides virtual machines (VMs) that run on Google Cloud. We usually refer to a running VM as an *instance*. When you use Compute Engine, you create and manage one or more instances.

### Virtual Machine Images

Instances run images, which contain operating systems, libraries, and other code. You may choose to run a public image provided by Google ([Figure 4.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0001)). Both Linux and Windows images are available. In addition to the images maintained by Google, there are other public images provided by open source projects or third-party vendors.

![Snapshot of a subset of operating system images available in Compute Engine](../images/c04f001.png)


[**FIGURE 4.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0001) A subset of operating system images available in Compute Engine

The public images include a range of operating systems, such as CentOS, Container-Optimized OS from Google, Debian, Red Hat Enterprise Linux, SUSE Enterprise Linux Server, Ubuntu, and Windows Server.

If there is no public image that meets your needs, you can create a custom image from a boot disk or by starting with another image. To create a VM from the console, navigate to Compute Engine and then to VM Instances. You will see a screen similar to [Figure 4.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0002).

![Snapshot of creating a VM in Compute Engine](../images/c04f002.png)


[**FIGURE 4.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0002) Creating a VM in Compute Engine

Click Create Instance to open the page for creating an instance. Here, as shown in [Figure 4.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0003), you can set the name of the instance, choose the machine configuration, add graphics processing units (GPUs), and set other features of the instance.

Other configurable features of an instance are shown in [Figure 4.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0004). For example, for high-security applications, you can use the Confidential VM service to encrypt data in memory. You can also specify a name, size, image, and type of the boot disk. VMs have an associated identity called a service account associated with them. Service accounts are identities, like users and groups, but are not associated with human users. Service accounts can be assigned roles so that they can have permissions to perform actions in Google Cloud. (For more on service accounts, see [Chapter 3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml), “Projects, Service Accounts, and Billing.”)

![Snapshot of part 1 of creating an instance in Compute Engine](../images/c04f003.png)


[**FIGURE 4.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0003) Part 1 of creating an instance in Compute Engine

You can also control what actions an instance can perform by setting access scopes. Access scopes are a legacy access control mechanism that existed before the Identity and Access Management (IAM) service. By default, access scopes allow minimal access, including the ability to read from storage and to write to monitoring and logging services. IAM is the preferred method for controlling access granted to a Compute Engine instance.

You can also specify whether HTTP or HTTPS traffic is allowed to the instance.

[Figure 4.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0005) shows networking configurations for an instance. In the Networking section of the Create Instance page, you can specify network tags, a hostname, and network performance configurations, as well as add additional network interfaces. One network interface is created by default.

![Snapshot of part 2 of creating an instance in Compute Engine](../images/c04f004.png)


[**FIGURE 4.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0004) Part 2 of creating an instance in Compute Engine

If you would like additional disks, along with the boot disk, you can add and configure disks on this page as well. [Figure 4.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0006) shows the options for configuring disks. You can provide a name, description, disk type, size, a backup schedule for the disk, and encryption settings. Note that all data in Google Cloud is encrypted when stored (known as *encryption at rest*) in persistent storage. We do not have the option to persistently store data without encryption, but we can choose how encryption keys are managed. Currently, the choices are Google-managed encryption keys, customer-managed encryption keys, and customer-supplied encryption keys. With Google-managed encryption keys, Google creates and manages keys. With customer-supplied encryption keys, customers create their own keys but Google manages them. When we use customer-supplied encryption keys, the customers create and manage keys outside of Google Cloud.

![Snapshot of configuring network properties in a Compute Engine instance](../images/c04f005.png)


[**FIGURE 4.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0005) Configuring network properties in a Compute Engine instance

Disks can be attached as read/write disks or as read-only disk. A disk by default is kept when an instance is deleted, but you can choose to have the disk deleted when the instance is deleted.

In the Security section of the Create Instance page, you can specify some advanced security features. (See [Figure 4.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0007).) Secure Boot protects against boot-level and kernel-level malicious code, such as rootkits. The Virtual Trusted Platform Module (vTPM) validates boot integrity and provides additional protections for key generation and protection. When vTPM is enabled, you have the option of enabling Integrity Monitoring, which verifies the runtime integrity of the virtual machine.

![Snapshot of configuring disks in a Compute Engine instance](../images/c04f006.png)


[**FIGURE 4.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0006) Configuring disks in a Compute Engine instance

![Snapshot of configuring security in a Compute Engine instance](../images/c04f007.png)


[**FIGURE 4.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0007) Configuring security in a Compute Engine instance

You can further restrict access to an instance through IAM roles. When this feature is enabled, only users with the Compute OS Login role, Compute OS Admin Login role, or other roles that have permissions to enable IAM-based access can login. Another way to block access is to disallow the use of project-based SSH keys, which by default would allow access to any VM instance in a project.

[Figure 4.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0008) shows the options for specifying management features. These include a description, the ability to block deletion of the instance, instance reservations (a way of purchasing blocks of instance time at a discount), and whether you want an automation script to run on startup. You can also configure availability parameters, including choosing to make this a preemptible VM. Preemptible VMs cost less but can be shut down at any time by Google Cloud. Originally, preemptible VMs would run for a maximum of 24 hours before being shut down. Google Cloud now offers spot VMs, which are billed like preemptible VMs but are not necessarily shut down after 24 hours. You can also specify if the instance should be migrated to another server during server maintenance and started automatically if there is a hardware failure or other non-user-initiated shutdown.

![Snapshot of configuring management features in a Compute Engine instance](../images/c04f008.png)


[**FIGURE 4.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0008) Configuring management features in a Compute Engine instance

There may be times when you do not want virtual machines from other projects running on the same server as your project's virtual machines. In such cases, you can choose Sole Tenancy for your instance (see [Figure 4.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0009)). Only VMs from your project with node affinity labels matching the labels you specify here will run on the same server together. You also have the option of overcommitting the CPUs on a server that is configured as sole tenant. This can increase performance by scheduling VMs with more CPU requirements than actually available if the VMs do not need all the committed resources at the same time. For example, if two instances are running on a server and one instance has a peak load in the morning and the other has a peak load in the evening, you may be able to overcommit without adversely impacting performance of either instance.

![Snapshot of configuring Sole Tenancy features in a Compute Engine instance](../images/c04f009.png)


[**FIGURE 4.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0009) Configuring Sole Tenancy features in a Compute Engine instance

If you are going to create additional instances with the same configuration, you can create an *instance template*. A template is a description of a VM configuration. The process of creating an instance template is similar to creating a VM as just described but instead of creating a VM when complete, you will have created a template. You can then use that template to create a new instance without having to specify all the configuration parameters manually.

Another way to create an instance is from a machine image that you create. [Figure 4.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0010) shows the dialog box for creating a machine image from an existing VM. You specify a name, description, source VM, and location to store the image. You can also specify how encryption keys are managed.

![Snapshot of creating a machine image](../images/c04f010.png)


[**FIGURE 4.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0010) Creating a machine image

### Virtual Machines Are Contained in Projects

When you create an instance, you specify a project to contain the instance. As you may recall, projects are part of the Google Cloud resource hierarchy. Projects are the lowest-level structure in the hierarchy. Projects allow you to manage related resources with common policies.

When you open Google Cloud Console, you will notice at the top of the form either the name of a project or the phrase Select A Project, as shown in [Figure 4.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0011).

![Snapshot of the current project name or the option to select one is displayed in Google Cloud Console.](../images/c04f011.png)


[**FIGURE 4.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0011) The current project name or the option to select one is displayed in Google Cloud Console.

When you choose Select A Project, a form like the one in [Figure 4.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0012) appears. From there, you can select the project you want to store your resources, including VMs.

![Snapshot of choosing a project from existing projects in an account](../images/c04f012.png)


[**FIGURE 4.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0012) Choosing a project from existing projects in an account

### Virtual Machines Run in a Zone and Region

In addition to having a project, VM instances have a zone assigned. Zones are data center–like resources, but they may consist of one or more closely coupled data centers. They are located within regions. A *region* is a geographical location, such as asia-east1, europe-west2, and us-east4. The zones within a region are linked by low-latency, high-bandwidth network connections.

You specify a region and a zone when you create a VM. As you can see in [Figure 4.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0013) and [Figure 4.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0014), the Create VM form includes drop-down lists from which you can select the region and zone.

You may want to consider several factors when choosing where to run your VM:

- Cost, which can vary between regions.
- Data locality regulations, such as keeping data about European Union citizens in the European Union.
- High availability. If you are running multiple instances, you may want them in different zones and possibly different regions. If one of the zones or regions becomes inaccessible, the instances in other zones and regions can still provide services.
- Latency, which is important if you have users in different parts of the world. Keeping instances and data geographically close to application users can help reduce latency.
- Need for specific hardware platforms, which can vary by region. For example, europe-west1 may have a processor available that is not available in europe-west2.
- The carbon intensity of the power generation in the region.

![Snapshot of selecting a region in the Create VM form](../images/c04f013.png)


[**FIGURE 4.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0013) Selecting a region in the Create VM form

![Snapshot of once a region is selected, you can choose a zone within that region.](../images/c04f014.png)


[**FIGURE 4.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0014) Once a region is selected, you can choose a zone within that region.

### Users Need Privileges to Create Virtual Machines

To create Compute Engine resources in a project, users must be members of the project or a specific resource and have appropriate permissions to perform specific tasks. Users can be associated with projects as follows:

- Individual users
- A Google group
- A Google Workspace domain
- A service account

Once a user, or a set of users, is added to a project, you can assign permissions by granting roles to the user or set of users. This process is explained in detail in [Chapter 17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml), “Configuring Access and Security.” Predefined roles are especially useful because they group together permissions that are often needed for a user to carry out a set of tasks. Here are some examples of predefined roles:

- **Compute Admin**   Users with this role have full control over Compute Engine instances.
- **Compute Network Admin**   Users with this role can create, modify, and delete most networking resources, and it provides read-only access to firewall rules and SSL certifications. This role does not give the user permission to create or alter instances.
- **Compute Security Admin**   Users with this role can create, modify, and delete SSL certificates and firewall rules.
- **Compute Viewer**   Users with this role can get and list Compute Engine resources but cannot read data from those resources.

When privileges are granted to users at the project level, then those permissions apply to all resources within a project. For example, if a user is granted the Compute Admin role at the project level, then that person can administer all Compute Engine instances in the project.

An alternative way to control access to resources is to attach IAM policies directly to resources. In this way, privileges can be tailored to specific resources instead of for all resources in a project. For example, you could specify that user Alice has the Compute Engine Admin role on one instance and Bob has the same role on another instance. Alice and Bob would be able to administer their own VM instances, but they could not administer other instances.

### Preemptible Virtual Machines

Consider if you have a workload that is the opposite of needing high availability. Preemptible VMs are short-lived compute instances suitable for running certain types of workloads—particularly for applications that perform financial modeling, rendering, big data, continuous integration, and web crawling operations. These VMs offer the same configuration options as regular compute instances and persist for up to 24 hours; spot VMs do not have this time limitation. If an application is fault-tolerant and can withstand possible instance interruptions (with a 30-second warning), then using preemptible VM instances and spot VMs can reduce Google Compute Engine costs significantly.

Some big data analysis jobs run on clusters of servers running software like Hadoop and Spark. The platforms are designed to be resilient to failure. If a node goes down in the middle of a job, the platform detects the failure and moves the workload to other nodes in the server. You may have analytic jobs that are well served by a combination of reliable VMs and preemptible VMs. With some percentage of reliable VMs, you know you can get your jobs processed within your time constraints, but if you add low-cost, preemptible VMs, you can often finish your jobs faster and at lower overall cost.

#### Limitations of Preemptible Virtual Machines

As you decide where to use preemptible VMs, keep in mind their limitations and differences compared to conventional VM instances in Google Cloud. Preemptible VMs have the following characteristics:

- May terminate at any time. If they terminate within 1 minute of starting, you will not be charged for that time.
- Will be terminated within 24 hours except for spot VMs.
- May not always be available. Availability may vary across zones and regions.
- Cannot migrate to a regular VM.
- Cannot be set to automatically restart.
- Are not covered by any service level agreement (SLA).

### Custom Machine Types

Compute Engine has dozens of predefined machine types grouped into standard types, high-memory machines, high-CPU machines, shared core type, and memory-optimized machines. These predefined machine types vary in the number of virtual CPUs (vCPUs) and amount of memory. Here are some examples:

- n2-standard-2 has 2 vCPU and 8 GB of memory.
- n2-standard-32 has 32 vCPUs and 128 GB of memory.
- m2-megamem-416 has 416 vCPUs and 5.75 TB of memory.
- m2-ultramem-208 has 208 vCPUs and 5.75 TB of memory.

The predefined options for VMs will meet the needs of many use cases, but there may be times where your workload could run more cost effectively and faster on a configuration that is not already defined. In that case, you may want to use a custom machine type.

To create a custom image, select the Create VM option in the console. Click the Customize link in the Machine Type section (see [Figure 4.15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0015)).

This expands the Machine Type section, as shown in [Figure 4.16](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0016). From there you can adjust the sliders to increase or decrease the number of CPUs and the amount of memory you require.

The options available to create a custom machine configuration will vary by series. For example, custom machine types based on the N2 series can have between 2 and 80 vCPUs and up to 640 GB of memory. The price of a custom configuration is based on the number of vCPUs and the memory allocated. Custom machine types based on N2D series can have up to 96 cores and up to 768 GB of memory. You can select Extend Memory to increase the amount of memory relative to CPUs.

![Snapshot of choosing a custom machine type from the Machine Type drop-down menu](../images/c04f015.png)


[**FIGURE 4.15**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0015) Choosing a custom machine type from the Machine Type drop-down menu

![Snapshot of customizing a VM by adjusting the number of CPUs and the amount of memory](../images/c04f016.png)


[**FIGURE 4.16**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0016) Customizing a VM by adjusting the number of CPUs and the amount of memory

### Use Cases for Compute Engine Virtual Machines

Compute Engine is a good option when you need maximum control over VM instances. With Compute Engine, you can do the following:

- Choose the specific image to run on the instance.
- Install software packages or custom libraries.
- Have fine-grained control over which users have permissions on the instance.
- Have control over SSL certificates and firewall rules for the instance.

Relative to other computing services in Google Cloud, Google Compute Engine provides the least amount of management. Google does provide public images and a set of VM configurations, but you as an administrator must make choices about which image to use, the number of CPUs, the amount of memory to allocate, how to configure persistent storage, and how to configure network configurations.

In general, the more control over a resource you have in Google Cloud, the more responsibility you have for configuring and managing the resource.

## App Engine

App Engine is a PaaS compute service that provides a managed platform for running applications. When you use App Engine, your focus is on your application and not on the VMs that run the application. Instead of configuring VMs, you specify some basic resource requirements along with your application code, and Google will manage the resources needed to run the code. This means that App Engine users have less to manage, but they also have less control over the compute resources that are used to execute the application.

Like VM instances, applications in App Engine are created within a project. Unlike Compute Engine, when creating an App Engine service, you are not providing a lot of detail for configuring virtual machines. Instead, you are configuring your application to run as a service in App Engine (see [Figure 4.17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0017)).

![Schematic illustration shows when using App Engine, the focus is on applications, not infrastructure.](../images/c04f017.png)


[**FIGURE 4.17**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0017) When using App Engine, the focus is on applications, not infrastructure.


---

![](../images/note_13.png) App Engine is not included as a topic in the Google Cloud Associate Cloud Engineer exam guide, but it is included here because the service is still available and continues to be used.

---

 

### Structure of an App Engine Application

App Engine applications have a common structure, and they consist of services. Services provide a specific function, like computing sales tax in a retail web application or updating inventory as products are sold on a site. Services have versions, and this allows multiple versions to run at one time. Each version of a service runs on an instance that is managed by App Engine (see [Figure 4.18](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0018)).

![Snapshot of the structure of an App Engine application](../images/c04f018.png)


[**FIGURE 4.18**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0018) The structure of an App Engine application

The number of instances used to provide an application depends on your configuration for the application and the current load on the application. As the load increases, Google can add more instances to meet the need. Similarly, if the load lessens, instances can be shut down to save on the cost of unutilized instances. This kind of autoscaling is available with dynamic instances.

In addition to dynamic instances, App Engine also provides resident instances. You can add or remove resident instances manually.

When the number of deployed instances changes frequently, it can be difficult to estimate the costs of running instances. Fortunately, Google Cloud allows users to set up daily spending limits as well as create budgets and set alarms.

### App Engine Standard and Flexible Environments

App Engine provides two types of runtime environments: standard and flexible. The standard environment provides language runtimes, whereas the flexible environment is a more generalized container execution platform. In both environments, your code runs in container instances running on Google Cloud managed infrastructure.

#### App Engine Standard Environment

The standard environment is the original App Engine environment. It consists of a preconfigured, language-specific runtime. There are currently two generations of the standard environment. The second generation improves on the performance of the first generation and has fewer limitations.

Currently, App Engine standard environment users can choose from the following supported languages:

**First Generation**

- Python 2.7
- Java 8
- PHP 5.5Go 1.11

### Second Generation

- Python 3
- Java 11, 17
- Node.js
- PHP 7/8
- Ruby
- Go 1.12+

With the second-generation standard environment, developers can use any language extension, but in the first generation only a select set of extensions and libraries are allowed. Network access is restricted in the first generation, but users have full network access in the second generation.

App Engine services are scaled using automatic, manual, or basic scaling. With basic scaling, App Engine tries to keep costs low so it does not start another instance until there is a request that cannot be serviced by an existing instance. This can cause a delay in the time to process the request because the instance has to start. With automatic scaling, App Engine automatically creates new instances as load increases. With manual scaling, you specify the number of instances for each version of a service.

App Engine standard environment is especially appealing from a cost perspective because you only pay for what you need and applications can scale to zero instances when there is no traffic to the application.

An App Engine service gets compute and memory resources based on the instance class configured for the service.

For first-generation runtimes, the default instance class for front end services, called F1, has up to 128 MB of memory and a CPU limit of 600 MHz. The default instance class for back-end services, called B2, has 256 MB of memory and a 1.2 GHz CPU limit. There are several other classes for both front-end and back-end instance classes.

For second-generation environments, F1 has 256 MB of memory and a 600 MHz CPU limit whereas the B2 instance has 512 MB of memory and a 1.2 GHz CPU limit.

Front-end instance classes scale automatically, and back-end instance classes support manual and basic scaling.

#### App Engine Flexible Environment

The App Engine flexible environment provides more options and control to developers who would like the benefits of a platform as a service (PaaS) like App Engine but without the language and customization constraints of the App Engine standard environment.

Like App Engine Standard, the App Engine flexible environment uses containers as the basic building block abstraction; however, in App Engine Flexible users can customize their runtime environments by configuring a container. The flexible environment uses Docker containers, so developers familiar with Dockerfiles can specify base operating system images, additional libraries and tools, and custom tools. It also has native support for Java, Python, Node.js, Ruby, PHP, .NET core, and Go. See App Engine documentation for specific versions supported.

In some ways, the App Engine flexible environment is similar to the Kubernetes Engine, which will be discussed in the next section. Both Google products can run customized Docker containers. The App Engine flexible environment provides a fully managed PaaS and is a good option when you can package your application and services into a small set of containers. These containers can then be autoscaled according to load. Kubernetes Engine, as you will see shortly, is designed to manage containers executing in a cluster that you control. With Kubernetes Engine you have control over your cluster but must monitor and manage that cluster using tools such as Cloud Monitoring and autoscaling. With the App Engine flexible environment, the health of App Engine servers is monitored by Google and corrected as needed without any intervention on your part.

### Use Cases for App Engine

The App Engine product is a good choice for a computing platform when you have little need to configure and control the underlying operating system or storage system. App Engine manages underlying VMs and containers and relieves developers and DevOps professionals of some common system administration tasks, like patching and monitoring servers.

#### When to Use App Engine Standard Environment

The App Engine standard environment is designed for applications written in one of the supported languages. The standard environment provides a language-specific runtime that comes with its own constraints. The constraints are fewer in the second-generation App Engine standard environment.

---

![](../images/note_13.png) If you are starting a new development effort and plan to use the App Engine standard environment, then it is best to choose second-generation instances. First-generation instances will continue to be supported, but that kind of instance should be used only for applications that already exist and were designed for that platform.

---

#### When to Use App Engine Flexible Environment

The App Engine flexible environment is well suited for applications that can be decomposed into services and where each service can be containerized. For example, one service could use a Django application to provide an application user interface, another could embed business logic for data storage, and another service could schedule batch processing of data uploaded through the application. If you need to install additional software or run commands during startup, you can specify those in the Dockerfile. For example, you could add a `run` command to a Dockerfile to run `apt-get update` to get the latest version of installed packages. Dockerfiles are text files with commands for configuring a container, such as specifying a base image to start with and specifying package manager commands, like `apt-get` and `yum`, for installing packages.

The App Engine standard environment scales down to no running instances if there is no load, but this is not the case with the flexible environment. There will always be at least one container running with your service, and you will be charged for that time even if there is no load on the system.

## Kubernetes Engine

Compute Engine allows you to create and manage VMs either individually or in groups called *instances groups*. Instance groups let you manage similar VMs as a single unit. This is helpful if you have a fleet of servers that all run the same software and have the same operational life cycle. Modern software, however, is often built as a collection of services, sometimes referred to as *microservices*. Different services may require different configurations of VMs, but you still may want to manage the various instances as a single resource, or cluster. You can use Kubernetes Engine for that.

Kubernetes is an open source tool created by Google for administering clusters of virtual and bare-metal machines. (Kubernetes is sometimes abbreviated K8s.) Kubernetes is a container orchestration service that helps you. It allows you to do the following:

- Create clusters of VMs or bare metal machines that run the Kubernetes orchestration software for containers.
- Deploy containerized applications to the cluster.
- Administer the cluster.
- Specify policies, such as autoscaling.
- Monitor cluster health.

Kubernetes Engine is Google Cloud's managed Kubernetes service. If you wanted, you could deploy a set of VMs, install Kubernetes on your VMs, and manage the Kubernetes platform yourself. With Kubernetes Engine you get the benefits of Kubernetes without the administrative overhead.

Kubernetes Engine supports two modes: GKE Standard and GKE Autopilot. With GKE Standard, you pay-per-node for resources in your GKE cluster, and you are responsible for configuring and managing nodes. With GKE Autopilot you pay per pod, which is a single unit of resources for providing a service, and GKE manages configuration and infrastructure.

### Kubernetes Functionality

Kubernetes is designed to support clusters that run a variety of applications. This is different from other cluster management platforms that provide a way to run one application over multiple servers. Spark, for example, is a big data analytics platform that runs Spark services on a cluster of servers. Spark is not a general-purpose cluster management platform like Kubernetes.

Kubernetes Engine provides the following functions:

- Load balancing across Compute Engine VMs that are deployed in a Kubernetes cluster
- Automatic scaling of nodes (VMs) in the cluster
- Automatic upgrading of cluster software as needed
- Node monitoring and health repair
- Logging
- Support for node pools, which are collections of nodes all with the same configuration

### Kubernetes Cluster Architecture

A Kubernetes cluster includes a cluster control plane and one or more worker nodes.

The control plane manages the cluster. Cluster services, such as the Kubernetes API server, resource controllers, and schedulers, run on the control plane. The Kubernetes API Server is the coordinator for all communications to the cluster. The control plane determines what containers and workloads are run on each node.

![Snapshot of kubernetes Engine supports clusters that you can manage using Standard mode, or you can have Kubernetes Engine manage many of your cluster operations using Autopilot mode.](../images/c04f019.png)


**FIGURE 4.19** Kubernetes Engine supports clusters that you can manage using Standard mode, or you can have Kubernetes Engine manage many of your cluster operations using Autopilot mode.

When a Kubernetes cluster is created from either Google Cloud Console or a command line, a number of nodes are created as well. These are Compute Engine VMs, and you can specify the machine type when creating the cluster.

Kubernetes deploys containers in abstract compute units known as *pods*. They often have a single container but may have more than one. Containers within a single pod share storage and network resources. Containers within a pod share an IP address and port space. Containers are deployed and scaled as a unit.

### Kubernetes Engine Use Cases

Kubernetes Engine is a good choice for large-scale applications that require high availability and high reliability. Kubernetes Engine supports the concept of pods and deployment sets, which allow application developers and administrators to manage services as a logical unit. This can help if you have a set of services that support a user interface, another set that implements business logic, and a third set that provides back-end services. Each of these different groups of services can have different life cycles and scalability requirements. Kubernetes helps to manage these at levels of abstraction that make sense for users, developers, and DevOps professionals.

### Anthos

Anthos is not a compute service, like Compute Engine or Kubernetes Engine, but it is an increasingly important service that is used to managed services and resources across clouds and on-premises environments.

Anthos is a managed service for centrally configuring and managing the way you deploy services. (See [Figure 4.20](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0020).) With Anthos, you can manage multiple GKE clusters running on virtual machines as well as bare-metal servers. Anthos can manage clusters running in other clouds and on-premises as well.

![Snapshot of anthos supports the management of Kubernetes clusters in Google Cloud, other clouds, and on-premises.](../images/c04f020.png)


[**FIGURE 4.20**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0020) Anthos supports the management of Kubernetes clusters in Google Cloud, other clouds, and on-premises.

One of the advantages of using Anthos is that you can define and enforce policies across environments. Anthos Service Mesh is a service for managing complex microservices architectures and consistently securing and monitoring services running in Kubernetes.

## Cloud Run

Cloud Run is a managed service for running containers. Specifically, Cloud Run is used to deploy stateless containers. By *stateless*, we mean that any instance of a container running a service can respond to requests from that service. No data is maintained in a service about a particular connection or user of the service.

Cloud Run, like App Engine, is a managed service for running containers. (See [Figure 4.21](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0021)) When you deploy a service to Cloud Run, you specify a container image, a service name, a region, CPU allocation configuration, autoscaling parameters, as well as traffic configuration and authentication information.

### Cloud Run Use Cases

The key thing to keep in mind when using Cloud Run is that the service runs containers. This puts it in group with Kubernetes Engine and App Engine, which also run containers. Cloud Run does not provide virtual machines; those are provided by Compute Engine.

If you are primarily interested in running your code in containers and do not want to manage infrastructure, then Cloud Run is the recommended option if your application is stateless.

## Cloud Functions

Cloud Functions is a serverless computing platform designed to run single-purpose pieces of code in response to events in the Google Cloud environment. There is no need to provision or manage VMs, containers, or clusters when using Cloud Functions. Code that is written in Node.js, Python, Go, Java, .NET, Ruby, and PHP can be run on Cloud Functions. See the Cloud Functions documentation for information on supported versions of these languages.

Cloud Functions is not a general-purpose computing platform like Compute Engine or App Engine. Cloud Functions provides the “glue” between services that are otherwise independent.

For example, one service may create a file and upload it to Cloud Storage, and another service has to pick up those files and perform some processing on the file. Both services can be developed independently. There is no need for either to know about the other. However, you will need some way to detect that a new file has been written to Cloud Storage, and then the other application can begin processing it.

We don't want to write applications in ways that make assumptions about other processes that may provide input or consume output. Services can change independently of each other. We should not have to keep track of dependencies between services if we can avoid it. Cloud Functions helps us avoid that situation.

### Cloud Functions Execution Environment

Google Cloud manages everything that is needed to execute your code in a secure, isolated environment. Of course, below the serverless abstraction, there are virtual and physical servers running your code, but you as a cloud engineer do not have to administer any of that infrastructure. Three key things to remember about Cloud Functions are the following:

- The functions execute in a secure, isolated execution environment.
- Compute resources scale as needed to run as many instances of Cloud Functions as needed without you having to do anything to control scaling.
- The execution of one function is independent of all others. The life cycles of Cloud Functions are not dependent on each other.

![Snapshot of when deploying an application to Cloud Run, you will specify a container, a location to run the container, and a minimal set of configuration parameters.](../images/c04f021.png)


[**FIGURE 4.21**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0021) When deploying an application to Cloud Run, you will specify a container, a location to run the container, and a minimal set of configuration parameters.

There is an important corollary to these key points: Cloud Functions may be running in multiple instances at one time. If two mobile app users uploaded an image file for processing at the same time, two different instances of Cloud Functions would execute at roughly the same time. You do not have to do anything to prevent conflicts between the two instances; they are independent.

Since each invocation of a Cloud Function runs in a separate instance, functions do not share memory or variables. In general, this means that Cloud Functions should be stateless. That means the function does not depend on the state of memory to compute its output. This is a reasonable constraint in many cases, but sometimes you can optimize processing if you can save state between invocations. Cloud Functions does offer some ways of doing this, which will be described in [Chapter 11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml), “Planning Storage in the Cloud.”

### Cloud Functions Use Cases

Cloud Functions is well suited to short-running, event-based processing. If your workflows upload, modify, or otherwise alter files in Cloud Storage or use message queues to send work between services, then the Cloud Functions service is a good option for running code that starts the next step in processing. Some application areas that fit this pattern include the following:

- Internet of Things (IoT), in which a sensor or other device can send information about the state of a sensor. Depending on the values sent, Cloud Functions could trigger an alert or start processing data that was uploaded from the sensor.
- Mobile applications that, like IoT apps, send data to the cloud for processing.
- Asynchronous workflows in which each step starts at some time after the previous steps completes, but there are no assumptions about when the processing steps will complete.

As with other serverless compute options, when using Cloud Functions, you specify parameters about your service, in this case a function, and do not need to concern yourself with the underlying infrastructure (see [Figure 4.22](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#c04-fig-0022)).

## Summary

Google Cloud offers several computing options. The options vary in the level of control that you, as a user of Google Cloud, have over the computing platform. Generally, with more control comes more responsibility and management overhead. Your objective when choosing a computing platform is to choose one that meets your requirements while minimizing DevOps overhead and cost.

Compute Engine is the Google Cloud service that lets you provision VMs. You can choose from predefined configurations, or you can create a custom configuration with the best combination of virtual CPUs and memory for your needs. If you can tolerate some disruption in VM functioning, you can save a significant amount of money by using preemptible VMs.

![Snapshot of configuring a Cloud Function](../images/c04f022.png)


[**FIGURE 4.22**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c04.xhtml#R_c04-fig-0022) Configuring a Cloud Function

Modern software applications are built on multiple services that may have different computing requirements and change on different life cycles. Kubernetes Engine runs clusters of servers that can be used to run a variety of services while efficiently allocating work to servers as needed. Kubernetes Engine also provides monitoring, scaling, and remediation when something goes wrong with a VM in the cluster.

As enterprises adopt Kubernetes and run multiple clusters, they can turn to Anthos for managing Kubernetes clusters in Google Cloud, other clouds, and on-premises.

Cloud Run is a managed service for running stateless containers. If you do not need the full functionality and feature-richness of Kubernetes Engine, Cloud Run is a good option for deploying stateless containers.

Loosely coupled applications may be strung together to implement complex workflows. Often, we want each component to be independent of others. In such cases, we often need to execute “glue” code that moves workload from one stage to another. Cloud Functions is the serverless computing option designed to meet this need.

## Exam Essentials

- **Understand how images are used to create instances of VMs and how VMs are organized in projects.**   Instances run images, which contain operating systems, libraries, and other code. When you create an instance, you specify a project to contain the instance.
- **Know that Google Cloud has multiple geographic regions and regions have one or more zones.**   VMs run in zones. A region is a geographical location, such as asia-east1, europe-west2, and us-east4. The zones within a region are linked by low-latency, high-bandwidth network connections.
- **Understand what preemptible VMs are and when they are appropriate to use.**   Also understand when *not* to use them. Google Cloud offers an option called a preemptible VM for workloads that can be disrupted without creating problems.
- **Understand the difference between the App Engine standard and flexible environments.**   The standard environment runs a language-specific platform, and the App Engine flexible environment allows you to run custom containers. App Engine is well suited for HTTP(S)-based applications.
- **Know that Kubernetes is a container orchestration platform.**   It also runs containers in a cluster.
- **Understand Kubernetes.**   It provides load balancing, automatic scaling, logging, and node health checks and repair. Also know that Anthos is used to manage multiple Kubernetes clusters across Google Cloud, other clouds, and on-premises.
- **Understand Cloud Run.**   Cloud Run is a managed service for running stateless containers and is a good option when you do not need the full functionality of Kubernetes Engine.
- **Understand Cloud Functions.**   This service is used to run programs in response to events, such as file upload or a message being added to a queue.

## Review Questions

You can find the answers in the Appendix.

1. You are deploying a Python web application to Google Cloud. The application uses only custom code and basic Python libraries. You expect to have sporadic use of the application for the foreseeable future and want to minimize both the cost of running the application and the DevOps overhead of managing the application. Which computing service is the best option for running the application?
   1. Compute Engine
   2. App Engine standard environment
   3. App Engine flexible environment
   4. Kubernetes Engine
2. Your manager is concerned about the rate at which the department is spending on cloud services. You suggest that your team use preemptible VMs for all of the following except which one?
   1. Database server
   2. Batch processing with no fixed time requirement to complete
   3. High-performance computing cluster
   4. None of the above
3. What parameters need to be specified when creating a VM in Compute Engine?
   1. Project and zone
   2. Username and admin role
   3. Billing account
   4. Cloud Storage bucket
4. Your company has licensed a third-party software package that runs on Linux. You will run multiple instances of the software in Docker containers. Which of the following Google Cloud services could you use to deploy this software package?
   1. Compute Engine only
   2. Kubernetes Engine only
   3. Compute Engine, Kubernetes Engine, and the App Engine flexible environment only
   4. Compute Engine, Kubernetes Engine, the App Engine flexible environment, or the App Engine standard environment
5. You can specify packages to install into a Docker container by including commands in which file?
   1. `Docker.cfg`
   2. `Dockerfile`
   3. `Config.dck`
   4. `install.cfg`
6. Which of the following could be managed using Anthos?
   1. Kubernetes clusters in Google Cloud only
   2. App Engine Flexible containers and Kubernetes clusters in Google Cloud
   3. App Engine Flexible containers, Cloud Functions, and Kubernetes clusters in Google Cloud
   4. Kubernetes clusters in Google Cloud, AWS, and on-premises
7. Your manager is making a presentation to executives in your company advocating that you start using Kubernetes Engine. You suggest that the manager highlight all the features Kubernetes provides to reduce the workload on DevOps engineers. You describe several features, including all of the following except which one?
   1. Load balancing across Compute Engine VMs that are deployed in a Kubernetes cluster
   2. Security scanning for vulnerabilities
   3. Automatic scaling of nodes in the cluster
   4. Automatic upgrading of cluster software as needed
8. Your company is about to release an online service that builds on a new user interface experience driven by a set of services that will run on your servers. A separate set of services manage authentication and authorization. A third set of services keeps track of account information. All three sets of services must be highly reliable and scale to meet demand. Which of the Google Cloud services is the best option for deploying this?
   1. App Engine standard environment
   2. Compute Engine
   3. Cloud Functions
   4. Kubernetes Engine
9. A mobile application uploads images for analysis, including identifying objects in the image and extracting text that may be embedded in the image. A third party has created the mobile application, and you have developed the image analysis service. You both agree to use Cloud Storage to store images. You want to keep the two services completely decoupled, but you need a way to invoke the image analysis as soon as an image is uploaded. How should this be done?
   1. Change the mobile app to start a VM running the image analysis service and have that VM copy the file from storage into local storage on the VM. Have the image service run on the VM.
   2. Write a function in Python that is invoked by Cloud Functions when a new image file is written to the Cloud Storage bucket that receives new images. The function should submit the URL of the uploaded file to the image analysis service. The image analysis service will then load the image from Cloud Storage, perform analysis, and generate results, which can be saved to Cloud Storage.
   3. Have a Kubernetes cluster running continuously, with one pod dedicated to listing the contents of the upload bucket and detecting new files in Cloud Storage and another pod dedicated to running the image analysis software.
   4. Have a Compute Engine VM running and continuously listing the contents of the upload bucket in Cloud Storage to detect new files. Another VM should be continually running the image analysis software.
10. Your team is developing a new pipeline to analyze a stream of data from sensors on manufacturing devices. The old pipeline occasionally corrupted data because parallel threads overwrote data written by other threads. You decide to use Cloud Functions as part of the pipeline. As a developer of a Cloud Function, what do you have to do to prevent multiple invocations of the function from interfering with each other?
    1. Include a check in the code to ensure another invocation is not running at the same time.
    2. Schedule each invocation to run in a separate process.
    3. Schedule each invocation to run in a separate thread.
    4. Nothing. Google Cloud ensures that function invocations do not interfere with each other.
11. A client of yours processes personal and health information for hospitals. All health information needs to be protected according to government regulations. Your client wants to move their application to Google Cloud but wants to use the encryption library that they have used in the past. You suggest that all VMs running the application have the encryption library installed. Which kind of image would you use for that?
    1. Custom image
    2. Public image
    3. CentOS 6 or 7
    4. Ubuntu 18 or later
12. What is the lowest level of the resource hierarchy?
    1. Folder
    2. Project
    3. File
    4. VM instance
13. Your company is seeing a marked increase in the rate of customer growth in Europe. Latency is becoming an issue because your application is running in us-central1. You suggest deploying your services to a region in Europe. You have several choices. You should consider all the following factors except which one?
    1. Cost
    2. Latency
    3. Regulations
    4. Reliability
14. What role gives users full control over Compute Engine instances?
    1. Compute Manager role
    2. Compute Admin role
    3. Compute Regional Manager role
    4. Compute Security Admin
15. Which of the following are limitations of a preemptible VM?
    1. Will be terminated within 24 hours.
    2. May not always be available. Availability may vary across zones and regions.
    3. Cannot migrate to a regular VM.
    4. All of the above.
16. Which of the following would eliminate Cloud Run as an option for deploying an application in Google Cloud?
    1. The application uses a mix of Java and Python application code.
    2. The application stores data about a session in memory for use across multiple requests during a session.
    3. The application runs in a container.
    4. The container configuration is specified in a Dockerfile.
17. When using the App Engine standard environment, which of the following languages' runtime is not supported?
    1. Java
    2. Python
    3. C
    4. Go
18. You want to be sure all services running in a Kubernetes Engine cluster use the same authentication and monitoring services. What service would you use?
    1. Cloud Functions
    2. Anthos Service Mesh
    3. App Engine Flexible
    4. App Engine Standard
19. You are deploying a set of virtual machines in Compute Engine. You want to ensure that malware does not compromise the operating system, so you want to validate boot integrity. What feature of Compute Engine would you enable?
    1. Customer-supplied encryption keys
    2. vTPM
    3. Sole tenancy
    4. Identity and access management roles
20. A client has brought you in to help reduce their DevOps overhead. Engineers are spending too much time patching servers and optimizing server utilization. They want to move to serverless platforms as much as possible. Your client has heard of Cloud Functions and wants to use them. You recommend all the following types of applications except which one?
    1. Long-running data warehouse data load procedures
    2. IoT back-end processing
    3. Mobile application event processing
    4. Asynchronous workflows