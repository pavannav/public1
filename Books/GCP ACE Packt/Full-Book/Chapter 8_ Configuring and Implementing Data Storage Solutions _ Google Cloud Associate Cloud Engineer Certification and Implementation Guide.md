# 8

# Configuring and Implementing Data Storage Solutions

This chapter will explore how to store data in Google Cloud. We are going to cover the following storage types:

- Object storage – Google Cloud Storage
- Block storage – local and persistent disks for Compute Engine VMs and GKE
- File storage – Filestore
- Different types of databases – Cloud SQL, Cloud Spanner, Bigtable, Firestore, BigQuery, and Memorystore

Google Cloud provides multiple fully managed services for different types of application needs. Each section will look into a specific type of storage and their features, security, and availability. We will also cover the use cases of each category. Designing a storage strategy for cloud workloads is critical to ensure every application’s resiliency, performance, and response time.

# Google’s object storage – Cloud Storage

Google Cloud Storage is a Google-managed, highly available, and durable object storage for storing unstructured immutable data such as images, videos, and documents. Its common use cases are website hosting, content storage and delivery, analytics, and backup and archiving.

All data stored in Google Cloud Storage is encrypted with Google- or customer-managed keys. The service is globally available and consistent, making it visible to all entitled users after a file is uploaded. In addition, there is no limit on the objects you can store. Each object includes data, metadata, and a unique identifier used to interact with it.

Objects stored in Google Cloud Storage are organized in containers called **buckets**. **Buckets** belong to a **project** and help organize and control data access. We can configure buckets to match the desired performance, availability, and cost efficiency.

This section will focus on designing Google Cloud Storage and working with objects stored in buckets.

## Location types

One of the essential decisions when creating a Google Cloud Storage bucket is to choose where to store objects. For example, if objects are critical to our business, we may want to replicate them across regions for higher availability. Alternatively, if we have a latency-sensitive application that reads from our bucket, we may want to deploy a bucket in the same region where the application is running.

Once a bucket is created, it is not possible to modify its location. Therefore, it is important to have a clear understanding of the advantages and disadvantages of each option before making a decision.

Let’s look at the available location types for a Google Cloud Storage bucket to see how a geographic placement of a bucket determines its price, availability, and performance:

- A **regional** bucket is where objects are synchronously and automatically replicated between at least two zones in a single region. In the case of a zone failure, data is served from another zone. The failover and failback (once the region becomes available again) processes are transparent to users:
  - **Benefits**: Lower price per GB than other location types, as you only pay for data in a bucket in one region. Also, you benefit from low latency and higher throughput if you run your Google Cloud workloads in the same region as your bucket. Furthermore, regional buckets are the only way to meet a company’s compliance policy to keep data within a particular country only
  - **Considerations**: This location type doesn’t provide geo-redundancy (the distance between zones is less than 100 miles). Your objects won’t be available in the case of a regional failure.
- A **dual-region** bucket is where you provide geo-redundancy (more than 100 miles distance between data center locations) for your objects by specifying a pair of regions within the same continent between which objects will be replicated asynchronously (not in real time) by Google Cloud. There are three geographic areas: **Asia**, **North America**, and **Europe**, where you can select two regions for your bucket. The target for a default replication is one hour, but usually, it takes less than that. **Turbo replication** enabled between regions in a dual-region bucket will shorten the guaranteed replication time for newly written objects to 15 minutes. In addition, a failure in one region will not affect the availability of your objects. Again, this process is transparent to users and requires no additional setup for the failover and failback:
  - **Benefits**: A dual-region bucket survives a failure in one of two regions. Also, you can define which regions out of the available ones you want to use for your bucket – for example, those closest to regions where you run your Google Cloud workloads or serve your content to users.
  - **Considerations**: Not all regions are available for this location type yet. Also, you must pay per GB for two copies of data located in two regions and the replication traffic for write operations between buckets. The **Turbo replication** option is also subject to an additional fee. Furthermore, if most of your objects exist for a short time, the dual-region type would be of no benefit because object existence would be shorter than the replication window.
- **Multi-region**: This also provides a geo-redundancy within two or more regions in the following geographical areas: **Asia**, **EU** (zones in the European Union), and the **US**. The difference between a multi-region and dual-region type is that you can’t specify the regions for a multi-region bucket:
  - **Benefits**: The price for a multi-region bucket is lower than for a dual-region one. Also, if you are serving content from a bucket to users in a whole geographic region such as the US and you can’t predict where your traffic is coming from, content served from a multi-regional bucket has the highest possibility of being close to users.
  - **Considerations**: We allow Google to store data in different regions in a specified area (**ASIA**, **US**, or **EU**), and we don’t know which regions will be selected for each object. As a result, to access objects belonging to a multi-regional bucket, workloads running only in one region (for example, Compute Engine VMs in **us-west2**) will have to send requests across multiple US regions, impacting the service’s latency.

The following diagram summarizes how a location type choice can affect the object’s availability. There are three regions – **Region A**, **Region B**, and **Region C** – that belong to one geographical area, and three bucket locations – a regional bucket with one object (**cat.jpg**), a dual-region bucket with a replication set between **Region A** and **Region B** with a **dog.jpg** object, and a multi-region bucket with **dino1.jpg**, **dino2.jpg**, and **dino3.jpg** placed randomly across all regions, in two regions each:

![Figure 8.1 – A simplified diagram of an object placement for every Google Cloud Storage location type](../images/B18851_08_01.jpg)

Figure 8.1 – A simplified diagram of an object placement for every Google Cloud Storage location type

When a disaster happens in **Region A**, users can still access objects in the dual-region and multi-region buckets, and they wouldn’t even be aware of a failure if not for the **cat.jpg** object, which was in the regional bucket and is now unavailable.

![Figure 8.2 – A simplified diagram showing how Google Cloud Storage location type choice affects object availability in case of a failure in a region](../images/B18851_08_02.jpg)

Figure 8.2 – A simplified diagram showing how Google Cloud Storage location type choice affects object availability in case of a failure in a region

To conclude, the location type can give objects stored in a bucket the required availability. So, even if we access an object once in 5 years, we may still want it to be highly available on the day we need it, so we configure such a bucket, for example, as **dual-region**.

But once we start storing objects in buckets, we will notice that their access patterns differ. Some of the objects are accessed frequently while, on the other hand, some buckets store archival data that is rarely accessed. Do we have to pay the same price per GB for objects we download every day and those we do once in 5 years? In the next section, we will explore possible savings on the buckets for infrequently accessed data.

## Storage classes

To optimize the cost of storing your data, based on the projected frequency of operations on objects in a bucket, you can choose one of the following storage classes as a default one for all of the objects in a bucket:

- **Standard** class is the default one if you don’t make any choice. It is the best choice for frequent access to data, but it also has the highest price per GB. However, out of all the available classes, the price for operations such as *insert*, *list*, or *copy* is the lowest:
  - **Use case**: Hosting website content, media streaming and sharing, content storage for frequently accessed data, and serving data for gaming applications.
- **Nearline** will be the best if you access your objects less frequently than once per month. It has a lower price per GB than the Standard class, but if you decide to delete, replace, or move data sooner than 30 days, you will have to pay for early deletion, as if this object was actually stored for 30 days. Nearline also has higher operations charges than Standard:
  - **Use case**: Statistical data that is analyzed once per month, data archives, sporadically accessed multimedia content.
- **Coldline** is a good fit for data accessed less frequently than once a quarter. However, its minimum storage duration is 90 days, and, similar to Nearline, if you decide to delete, replace, or move data sooner, you will be charged the early deletion fee. In addition, making operation charges on objects costs more for Coldline than Nearline:
  - **Use case**: Archival storage, data accessed once a year, all rarely used data.
- **Archive** is designed for the least frequently accessed data but performs similarly to other storage classes. It is important to note that objects belonging to the Archive class are as easily accessible as ones from other classes. You don’t have to restore them first to another class to be able to access them. However, data operations are the most expensive for the Archive class compared to other classes. Also, data deleted after a few months will incur the same cost as if it was stored for a whole year:
  - **Use case**: Data that is not expected to be accessed. It is a replacement for storing data on tapes but without weeks-long restores and with high durability for long-term storage requirements – for example, 3-7 years.

The following figure shows how the price and availability can differ depending on the storage class used for a Google Cloud Storage bucket with 1 TB of data. On the left, we have the **Standard** class, which is the most expensive but has the highest availability and no **early deletion** fees. On the right, we can see that an **Archive** class bucket can get expensive if data is retrieved earlier than expected in one year:

![Figure 8.3 – An example of how price and availability values change for the same amount of data depending on a storage class for a regional bucket in europe-central2](../images/B18851_08_03.jpg)

Figure 8.3 – An example of how price and availability values change for the same amount of data depending on a storage class for a regional bucket in europe-central2

Note that all storage classes offer similar performance and response times in milliseconds. They also have a consistent set of APIs and similar tooling. The difference is mainly in the cost metrics. Also, Standard storage provides the highest availability.

## Data lifecycle

Storage classes work best when the frequency of operations on objects in a bucket can be predicted. But what about unpredictable access patterns? Although you can change the storage class of an individual object via a command line (a storage class is a metadata of an object), this could be unprofitable because the object will have to be rewritten, possibly incurring additional operation fees.

For such cases, Google Cloud Storage offers the following options to manage an object’s class assignment:

- **Object Lifecycle Management** is a feature you can set at a bucket level that allows changing a class of an object without a rewrite operation and the cost that goes with it (although an early deletion fee could be applied). We can set the conditions such as an object’s age and an automatic action that follows when this condition is met – for example, to move an object to a colder class (for example, from Standard to Nearline or from Nearline to Coldline, etc.) or delete it.
- The **Autoclass** feature is also a bucket-level setting configured during its creation. It automatically migrates infrequently accessed objects to colder classes without retrieval fees and class transition charges.

![Figure 8.4 – Because an object is not accessed, the Autoclass feature progressively transitions it to a less expensive storage class](../images/B18851_08_04.jpg)

Figure 8.4 – Because an object is not accessed, the Autoclass feature progressively transitions it to a less expensive storage class

The preceding figure presents how the Autoclass feature changes storage class metadata for a **cat.jpg** object. First, the original Standard class changes to Nearline after no one has accessed the object for 30 days. Next, after 60 days, the class changes to Coldline. When the object is moved to Coldline, it hasn’t been accessed for *30+60=90* days. Still, if no one accesses it in the next 275 days, its class will change to Archive. But anytime someone accesses **cat.jpg**, regardless of its storage class, it will return to the Standard class.

Note that in both cases (**Object Lifecycle** and **Autoclass**), it is an individual object for which a storage class (its metadata) is changed. Buckets are not modified during this process, so there is no impact on your applications or users accessing data.

## Working with buckets and objects

Now that we know how to design Google Cloud Storage buckets for availability and cost efficiency, let’s see how we can upload and manage objects that go into our buckets.

### Managing Google Cloud Storage via the Google Cloud console

The Google Cloud console is the easiest way for single-bucket operations and object uploads. You can access the **Buckets** section by selecting **Cloud Storage** in the main menu, as shown in the following screenshot:

![Figure 8.5 – The location of the Buckets section in the Google Cloud console](../images/B18851_08_05.jpg)

Figure 8.5 – The location of the Buckets section in the Google Cloud console

To create a bucket, use the **CREATE** button. This action will open a bucket creation wizard where you can name your bucket (a globally unique name is required), provide a location, and set an object class:

![Figure 8.6 – Creating a bucket in the Google Cloud console](../images/B18851_08_06.jpg)

Figure 8.6 – Creating a bucket in the Google Cloud console

There are specific rules to follow when naming a bucket. For example, you can only use lowercase letters, numeric characters, dashes, and underscores. Dots are supported when a bucket contains a domain name but using a domain requires its ownership verification. Also, including “google” as a part of the name is not supported.

We will see the bucket creation process later in this section. Please note that once you create a bucket, you can’t change its name.

As mentioned in the previous section, the only way to change most of the bucket’s parameters is to create a new bucket with desired settings and move contents to this new bucket.

If you want to delete a bucket or multiple buckets with all content, select them in the same view as shown in the preceding screenshot; the **DELETE** button will appear at the top.

![Figure 8.7 – Bucket details view](../images/B18851_08_07.jpg)

Figure 8.7 – Bucket details view

If you want to download or delete an object or a group of objects from a bucket in the Google Cloud console, use the **DOWNLOAD** or **DELETE** options, respectively. Both are available in the **Bucket details** view, as shown in *Figure 8**.7*.

There are also alternatives to uploading and downloading data from a local workstation. For example, under the **TRANSFER DATA** option, you will find a wizard to create a transfer job, for example, from object stores belonging to other cloud providers or other Google Cloud Storage buckets.

![Figure 8.8 – Ordering Transfer Appliance for uploading large amounts of data](../images/B18851_08_08.jpg)

Figure 8.8 – Ordering Transfer Appliance for uploading large amounts of data

If you are planning to move a large amount of data from an on-premises data center to your Google Cloud Storage bucket, it is important to have a solid strategy in place. For example, if you have a deadline of one month to transfer 100 TB of data over your 1 Gbps bandwidth, it should be easily achievable. However, if you only have 100 Mbps bandwidth available, it could take several months to complete the transfer and you may not meet your deadline. In this scenario, it may be beneficial to consider an offline upload using Transfer Appliance (see *Figure 8**.8*), which can have an end-to-end cycle time of less than a month.

Transfer Appliance is a high-capacity storage device that allows you to securely transfer your data to a Google upload facility, where it will be uploaded to Cloud Storage.

If your data is located in another cloud storage provider, you should consider using the **Storage Transfer Service**. This service automates the transfer of data between various object and file storage systems, such as Google Cloud Storage, Amazon S3, Azure Storage, or on-premises. It is a reliable and efficient way to transfer large amounts of data without requiring any coding skills.

Using the Google Cloud console is very convenient when learning to work with Google Cloud Storage. Later, when we use it in production, alternative ways to manipulate large amounts of objects are preferred. The following sections will describe how to work with Google Cloud Storage on a larger scale or programmatically.

#### Using gsutil as a command-line tool

Google Cloud Storage offers an automated command line tool, **gsutil**, to manage bucket and object level operations such as create, list, delete, move, and copy on a larger scale.

You can start by using **gsutil** from the Cloud Shell and practice the following commands:

- To create a **unique-name-of-the-bucket** bucket with a **standard** storage class in the **europe-central2** location, use the following command:

  ```
  gsutil mb -c standard -l europe-central2 gs://unique-name-of-the-bucket
  ```
- The following command is how you can list objects in a bucket:

  ```
  gsutil ls -l gs://unique-name-of-the-bucket
  ```

You can find an example output of those two actions in the following screenshot:

![Figure 8.9 – Creating a bucket and listing its content using gsutil](../images/B18851_08_09.jpg)

Figure 8.9 – Creating a bucket and listing its content using gsutil

- To download a file from a bucket, use **gsutil cp**:

  ```
  gsutil cp gs://unique-name-of-the-bucket/folder/file_name /folder/destination_folder
  ```

Next, you can find an example of downloading a file to a Cloud Shell virtual machine directly and listing the folder’s content to make sure the **photo1.jpg** file was downloaded successfully:

![Figure 8.10 – A file copy from a bucket using gsutil](../images/B18851_08_10.jpg)

Figure 8.10 – A file copy from a bucket using gsutil

- If you are transferring or deleting many files, you can improve the performance of such an operation by using multi-threading with the **gsutil -m** option. For example, with the following command, you can delete all the content of the **tmp** folder on the **unique-name-of-the-bucket** bucket:

  ```
  gsutil rm gs://unique-name-of-the-bucket /tmp/*
  ```

If you add the **-m** option, this operation (especially when the number of manipulated objects is significant) will be faster. Conversely, if you forget to use the **-m** option, you will be notified that the operation will be done sequentially, and that will take more time. Take a look at the following figure, which shows a notification about using the **-m** option for sequence operations:

![Figure 8.11 – Deleting content of a folder in a bucket where we got a note that the -m option could be used](../images/B18851_08_11.jpg)

Figure 8.11 – Deleting content of a folder in a bucket where we got a note that the -m option could be used

If you want to practice more, you can find other examples of using **gsutil** here: <https://cloud.google.com/storage/docs/gsutil/commands/help>.

#### Client libraries and REST API access for developers

Google Cloud Storage offers client libraries for languages such as C++, C#, Go, Java, Node.js, PHP, Python, and Ruby so that you can interact with buckets directly from your code.

Furthermore, JSON and XML APIs are also available, so you can, for example, call APIs to upload data from your folder onto a Google Cloud Storage bucket.

#### Managing access to objects

There are two ways to control access to your objects in a bucket. You can select one of the following options when creating a bucket:

- **Uniform**, where you use **Identity and Access Management** (**IAM**) to define access permissions on a bucket level, so all objects inherit them. To grant access to a bucket, you need to select **Edit access**, as shown in the following screenshot:

![Figure 8.12 – Editing permissions for a bucket with uniform access control](../images/B18851_08_12.jpg)

Figure 8.12 – Editing permissions for a bucket with uniform access control

In the next step, you provide a user and a role that you want to assign to this user – for example, a predefined role, **Storage Object Viewer**, that allows only viewing and listing an object and its metadata:

![Figure 8.13 – Granting access to a bucket with uniform access control](../images/B18851_08_13.jpg)

Figure 8.13 – Granting access to a bucket with uniform access control

Note that, in *Figure 8**.13*, the **Resource** field shows a bucket, not an individual object.

- **Fine-grained** access control allows you to assign permissions to individual objects in conjunction with bucket-level permissions. Once the bucket is created, you can select individual objects and assign permissions to access it by selecting **Edit access**, as shown in the following screenshot:

![Figure 8.14 – Editing access permissions per object for a bucket with fine-grained access](../images/B18851_08_14.jpg)

Figure 8.14 – Editing access permissions per object for a bucket with fine-grained access

Note that, in the following screenshot, the resource that we provide access to is an individual object:

![Figure 8.15 – Creating a fine-grained access level for a bucket with permissions applied on an object level](../images/B18851_08_15.jpg)

Figure 8.15 – Creating a fine-grained access level for a bucket with permissions applied on an object level

The **Fine-grained** access option also allows creating time-limited **signed URLs** for accessing an object through a link. You can give users a signed URL for temporary access to Cloud Storage objects without needing a Google account.

Alternatively, you can edit access to an object and set **Entity** as **Public**, **Name** as **all Users**, and **Access** as **Reader** to allow public access.

As shown in the following example, a public URL can be generated for an object so that everyone can download it:

![Figure 8.16 – An object from a fine-grained access bucket that can be accessed by anyone](../images/B18851_08_16.jpg)

Figure 8.16 – An object from a fine-grained access bucket that can be accessed by anyone

Let’s put all this information from all the sections of this chapter together and use an example for summarizing what we have discussed in this chapter so far.

## Creating a bucket in practice

Imagine setting up a Google Cloud Storage bucket for storing a copy of your backup data of the on-premises systems located in your data center in Frankfurt. You want your bucket to be the closest to your data center location and be available even if one of the Google regions fails. You expect the data will be accessed less than once a month, and you want to adjust the storage class to minimize costs. Also, the bucket can’t be accessed from the internet. Furthermore, you might want to protect backups against malicious deletion and make sure no one deletes them for the next 5 years. Let’s look at the possible steps you need to take to configure such a bucket:

1. In the **Cloud Storage** section, select **Bucket** and then **+CREATE**. Provide a bucket name, which must be unique globally across all Google Cloud projects. You should use a globally unique name that relates to the bucket’s purpose, such as **my-backup-bucket-europe**
2. The next step is to decide where the backups should be stored. In this case, the requirement is for the bucket to be accessible even in the case of a region failure, so we can’t select a regional bucket. On the other hand, we want to ensure minimal latency, so we also can’t select a multi-regional option. In the multi-regional option, Google will decide where data is stored within a selected continent and possibly select one of the regions that are further compared to others. This choice can potentially introduce additional latency. For our needs, the best choice is dual-region placement. This allows us to select two regions that we want to use. In this case, we should keep data within the geographical area of Europe and select regions closest to our on-premises location. Moreover, in the case of a failure in one region, the second one will serve the content. As of writing this book, possible options in the bucket configuration page (see *Figure 8**.17*) are Finland, Belgium, and Netherlands, with Belgium and Netherlands being closest to Frankfurt:

![Figure 8.17 – Creating a bucket; selecting location type](../images/B18851_08_17.jpg)

Figure 8.17 – Creating a bucket; selecting location type

1. Next, you can select the storage class based on planned data usage or use Autoclass. In our case, we will store backup copies that won’t be frequently accessed. Therefore, Nearline is the optimal option as it is tailored for accessing data less than once a month. Also, it is good practice to verify with the backup vendor whether they support a storage class we want to use. For example, backup software may consolidate backups as a background task and read from a bucket more often than we think, and that will generate additional costs:

![Figure 8.18 – Creating a bucket; available storage classes](../images/B18851_08_18.jpg)

Figure 8.18 – Creating a bucket; available storage classes

1. One of the requirements is to make sure backup files are not accessible from the internet. We can control it by selecting **Enforce public access prevention on this bucket**, ensuring no one can make those backup files public:

![Figure 8.19 – Creating a bucket; access control](../images/B18851_08_19.jpg)

Figure 8.19 – Creating a bucket; access control

1. The last requirement was to ensure that no one would delete backup files in five years. This can be configured by setting **Retention policy** to retain objects for five years. Please note that in real-life situations, depending on the backup solution vendor, the protection tools may have limited support:

![Figure 8.20 – Creating a bucket; retention policy](../images/B18851_08_20.jpg)

Figure 8.20 – Creating a bucket; retention policy

1. As a last step, we can also choose whether the files will be encrypted using the Google-managed encryption key or the **customer-managed encryption key** (**CMEK**). By utilizing CMEK, you gain greater control over various aspects of your key management and lifecycle such as using different types of keys (software or hardware-backed keys) and using keys managed externally.
2. To proceed with the setup, we need to hit **CREATE**. The bucket will be available in a few moments.

By following those steps, we created a Google Cloud Storage bucket that complies with our example task’s requirements, and this way, we reviewed the most important features of Google Cloud Storage buckets.

Now that we have learned how the object store works, let’s explore alternative ways to store data in Google Cloud.

# Block storage – local and persistent disks

At Google Cloud, block storage in the form of disks emulating physical drives and attached to a compute layer is used by **Google Kubernetes Engine** (**GKE**) and **Google Compute Engine** (**GCE**). An operating system recognizes block storage as a volume that can be formatted so applications can use it.

Compute Engine instance has, by default, a single boot persistent disk where the operating system is running. However, you can add multiple **local** or **persistent** disks if you need additional storage space.

The step-by-step guide on configuring a Compute Engine VM, including persistent disks, was already presented in [*Chapter 4*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_04.xhtml#_idTextAnchor080). Please look at *Figure 4**.38*, which presents a table comparing available persistent disk types in Google Cloud: **Balanced**, **Extreme**, **SSD**, and **Standard**.

The following table summarizes the differences between available disks for Compute Engine VMs. Note that some disks can be replicated between zones. Also, a persistent disk can exist without a VM, whereas data on a local one will be discarded when a VM is stopped. Finally, you can expand a disk without powering off your VM.

![Figure 8.21 – Summary of available block storage options for Compute Engine VMs](../images/B18851_08_21.jpg)

Figure 8.21 – Summary of available block storage options for Compute Engine VMs

Check out the following page for a more detailed comparison and performance characteristics for the block storage options: <https://cloud.google.com/compute/docs/disks>.

Data on zonal and regional persistent disks can be protected with snapshots. Snapshots can be manual or scheduled, and you can store them in a selected region or a multi-regional location. Refer to the *Creating instance snapshot* section in [*Chapter 4*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_04.xhtml#_idTextAnchor080) for more details on this topic.

Note that Google has also introduced a new type of block storage called **Hyperdisk**, which outperforms persistent disks. With Hyperdisk, each volume provides maximum IOPS and throughput, unlike in persistent disks where performance is shared across all attached volumes for a single virtual machine. Additionally, Hyperdisk volumes are independent of VMs, which means you can detach or move them to keep your data even after deleting your VMs. Furthermore, you can dynamically update the performance, resize existing Hyperdisk volumes, or add more volumes to a VM to meet your storage and performance needs, as Hyperdisk performance is not tied to size.

Although VMs can share disks among each other (for some disk types), the number of VMs that can be attached to a disk is limited, and such access is primarily suitable for applications and databases. However, if you are looking for shared storage for files that multiple applications or users can access, this will be covered in the next section.

# File storage – Cloud Filestore

Cloud Filestore is a Google-managed, high-performance, network-attached storage for applications that require a (shared) filesystem interface to store files in a folder structure. Filestore’s most common use cases are storing website content, users’ home directories, images, or videos for editing, and storing data for batch jobs such as rendering.

Each created Filestore instance represents a single file share that can be mounted using the NFSv3 protocol (a networking protocol for distributed file sharing) to Compute Engine VMs, GKE, and even workstations on-premises, assuming they have network connectivity to such a Filestore instance.

To interact with Filestore, you can use the Google Cloud console, APIs, or **gcloud** commands. By default, Filestore automatically encrypts your data at rest. The access to a file share can be controlled based on the client’s IP address. The following table presents the available service tiers.

![Figure 8.22 – Filestore service tiers and their characteristics](../images/B18851_08_22.jpg)

Figure 8.22 – Filestore service tiers and their characteristics

The **Basic** tier is for general-purpose use such as file sharing and web hosting, with the **solid-state drive** (**SSD**) tier providing better read and write throughput than the **hard disk drive** (**HDD**). The **High Scale** tier is designed for workloads with the highest capacity and performance demands, such as media rendering. The **Enterprise** tier has a regional redundancy to meet high availability requirements for mission-critical workloads. Note that the **Basic HDD** tier is the least expensive one. With High Scale and Enterprise, you can grow your instance and later shrink it. For the Basic tier, you can create a backup, and it will be a standalone copy of data. You can restore it to a source or another instance. The Enterprise tier offers snapshots that are a point-in-time view of a file share to which you can roll back your instance. They are stored on the instance and use its capacity.

In the next section, we will work on an example task to create a Filestore instance and mount its share to Compute Engine VMs.

## Creating a file share in practice

Suppose you received a task to create a share so that the owner of **vm-a** and the owner of **vm-b** can work together on documents in a folder structure. Both VMs are deployed as Compute Engine VMs that run in the **europe-central2** region with an NFS client already installed. The files take around 500 GB now, but the capacity can increase. Also, you need to set up a backup so that you can restore it if one of the owners deletes a file accidentally. The budget is limited. You decide to use a Filestore share and mount it to VMs. We assume you have a **Cloud Filestore Editor** role so you can create Filestore instances. Here are the steps you should follow to achieve it:

1. In the **Navigation** menu, go to the **Storage** section, select **Filestore**, and go to **Instances**. A **Create an instance** menu opens, as shown in the following screenshot:

![Figure 8.23 – Creating a Filestore instance](../images/B18851_08_23.jpg)

Figure 8.23 – Creating a Filestore instance

1. Provide a unique name for your instance (for example, **my-fileshare**) and a description.
2. Select **Basic** for **Instance type** because the budget is limited, and the workload (sharing documents) doesn’t seem to require high performance or high availability. Under the **Instance type** section, you will find a **Storage type** section. Select **HDD** as we are looking for the lowest price. You can check the prices on the right-hand side in the **Cost** **estimate** section.
3. In the **Allocate capacity** section, provide a **1 TiB** value, as this is the minimal amount you can deploy with this storage type. Also, you can increase the instance capacity later up to 63.9 TiB as you already know that the owners plan to create more files.
4. In the **Choose where to store data** section, select the region where **vm-a** and **vm-b** run, so in this case, **europe-central2**. This way, you will ensure the lowest latency. Also, you will not be charged for ingress traffic to Filestore or egress traffic to a client if they are located within the same zone.
5. In the **VPC network section**, select a network that both VMs use to ensure network connectivity. The networking and VPCs will be explained in detail later in [*Chapter 9*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_09.xhtml#_idTextAnchor200).
6. In the **Configure file share name** section, set the name for the share that VM owners will use to mount this share. In our case, it will be **documents**.
7. Note that you can also use the **gcloud** command line to create the instance:

   ```
   gcloud filestore instances create my-fileshare --zone=europe-central2-a --tier=BASIC_HDD --file-share=name="documents",capacity=1TB --network=name="my-network"
   ```
8. Wait for the **my-fileshare** instance to be created and select it to view more details. Then, in the **OVERVIEW** section, look for **NFS mount point** and copy it. In the following screenshot, you can see that there is the **10.165.64.226:/documents** NFS mount point:

![Figure 8.24 – Viewing details of a Filestore instance](../images/B18851_08_24.jpg)

Figure 8.24 – Viewing details of a Filestore instance

1. Ask VM owners to SSH to their instances and create a folder under the **/mnt** directory (for example, **/mnt/shared**), and run the following command as a root:

   ```
   mount 10.165.64.226:/document /mnt/shared
   ```

They can now go to **/mnt/shared** and see the files served from the **my-fileshare** instance, as shown in the following screenshot. You can also grant the owners **Cloud Filestore Viewer** roles, so they can check the mount point details themselves in the Google Cloud console:

![Figure 8.25 – Mounting the remote target on the VM’s local directories](../images/B18851_08_25.jpg)

Figure 8.25 – Mounting the remote target on the VM’s local directories

1. The last task is to run a backup task from time to time to be able to restore the files if someone deletes them. Edit the Filestore instance and select **Create a backup**. Provide a name and location and select **CREATE**.

# Databases

Block, file, or object storage are not the only solutions to store data. Data can also be stored in databases: relational SQL databases and non-relational NoSQL databases. Both types will be covered in the next sections. Also, we will look into a data warehouse and in-memory database:

While looking for a database that will be the best fit for a solution, we consider the following requirements:

- **Availability**: Can an application accept that data is unavailable or available with a certain delay? Should it be regional (such as Cloud SQL), multi-regional, or span continents such as Spanner?
- **Scale**: How much data will be stored? For example, terabytes in a CloudSQL instance or petabytes with a Spanner instance.
- **Performance**: Is it a database for real-time systems or analytics? How fast should a database process read and write operations? How many regions will it have to serve? (If copies of a database are spread across regions, it may introduce some latency to write operations. This is a trade-off for maintaining strong consistency, like with Spanner). How can database performance be improved? For example, can we add more nodes?
- **Consistency**: In the case of database replication between regions, does the data written in one region have to be immediately available in another one?
- **Functions**: What are some additional features a database can offer? What form of a database backup is available?
- **Cost**: Does a solution need to be cost-optimized? For example, can it scale down when a larger capacity is no longer required?

In the next sections, we will look into database solutions offered by Google Cloud and discuss the requirements we just listed.

## Relational databases

Data stored in relational databases is structured ahead of time and organized in tables with a static schema. Relational databases scale vertically by adding more compute and storage resources to the server where they run or by migrating to a larger server instance. To query and manipulate data in a relational database, a SQL programming language is used. The strength of relational databases is that they are designed for operations such as aggregations, sums, or multi-row transactions.

Google Cloud offers the following relational database services: Cloud SQL and Cloud Spanner, which we will cover in this section.

### Cloud SQL

Cloud SQL is a relational database service that offers three engines – MySQL PostgreSQL, and Microsoft SQL Server. It has a built-in integration and can be used as a backend for other Google Cloud services such as Compute Engine, GKE, and Cloud Run. In addition, the integration with Google’s serverless data warehouse, BigQuery (which will be covered later in this chapter), allows you to run federated queries to your Cloud SQL databases from BigQuery directly.

Each Cloud SQL instance is powered by a VM deployed in a Google-managed environment, and Google is responsible for its availability, updates, and patching. You can choose the amount of CPU, RAM, and storage for your instance according to the performance you need. CPU and RAM resources can be adjusted in time up to the maximum values a VM can offer, but it requires an instance shutdown. On the other hand, storage can be increased while an instance is running.

To handle more data or queries, you can increase the single VM capacity of your current instance by adding additional resources. This is called **vertical scaling**.

An instance is a resource pool for your databases. Once an instance is deployed, you can create databases that will run inside.

Assigning a **Public IP** to your instance will make it accessible from the outside of your environment. Alternatively, Cloud SQL can only connect to your internal network when it is configured with a **Private IP**. In addition, Cloud SQL has built-in encryption, both at rest and in transit.

Cloud SQL can be deployed in multiple zones within a selected region to achieve high availability. Furthermore, as data is replicated synchronously, when a failure occurs in a **primary zone**, a database will be served automatically from a **secondary zone** without data loss and the need to reconfigure applications connecting to an instance.

Use on-demand or scheduled backups to protect your Cloud SQL databases. Backups can run during a provided maintenance window. Also, there is an option to enable **point-in-time recovery** and recover data from a point in time, thanks to storing transaction logs.

In scenarios where you expect database traffic to come from different regions or need extra processing for analytics, leverage another Cloud SQL feature – **read replicas**. Read replicas are read-only copies of an original database that can be placed in the same or a different region, close to users. Read replicas can also be used to migrate a database to a different region or a larger instance.

![Figure 8.26 – Example use case of Cloud SQL high availability with a read replica located in another region](../images/B18851_08_26.jpg)

Figure 8.26 – Example use case of Cloud SQL high availability with a read replica located in another region

The preceding example presents how high availability and read replica features can be used together. An application in Region A and Zone A inserts data into a Cloud SQL database in Region A and Zone B; both run in the same region to minimize latencies. The SQL instance works in high availability mode, so the data is synchronously replicated to another zone, Zone C. In the case of Zone B failure, data will be served from the same IP (**x.x.x.x**) from the instance in Zone C. There is also a read replica instance in another region, Region B, where data is replicated. An analytics application, also located in Region B, reads data directly from a read replica served from a different IP, **y.y.y.y**. This approach offloads analytics traffic from the original instance and allows it to be served from a copy closer to the analytics application. In the case of a failure in Region A, the read replica in Region B can be promoted to a standalone primary instance.

Let’s summarize what we have learned about Cloud SQL by going through the following example.

#### Working with a PostgreSQL database

Suppose you were asked to create a small but critical PostgreSQL database for an application that would run on a Compute Engine Linux VM, **VM-a**, in a **my-subnet** subnet in the **europe-central2** region. The owner of the application is concerned about a potential latency between the database and their application. Also, although lightweight, the database needs to be highly available. In addition, the owner should be able to recover data from a specific time point within 7 days, and backups can only run within a 4-hour window during the night. Furthermore, the database can’t be accessed from the internet.

The following diagram presents an example of how a Compute Engine VM can connect to a PostgreSQL database via a private network. We could use this approach to address the requirements of our task. Note that more information about networking will be presented in [*Chapter 9*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_09.xhtml#_idTextAnchor200).

![Figure 8.27 – Connecting to a PostgreSQL database from a VM via Private service access](../images/B18851_08_27.jpg)

Figure 8.27 – Connecting to a PostgreSQL database from a VM via Private service access

Here are the steps that will guide you through the setup:

1. First, let’s create a database. To create a SQL instance, go to the **DATABASES** section in the main menu of the Google Cloud console:

![Figure 8.28 – The DATABASES section of the main menu](../images/B18851_08_28.jpg)

Figure 8.28 – The DATABASES section of the main menu

1. Out of the three available database engines, in this example, we will create a PostgreSQL instance by selecting **Create an instance** and then choosing **PostgreSQL**:

![Figure 8.29 – Three database engines offered by Cloud SQL](../images/B18851_08_29.jpg)

Figure 8.29 – Three database engines offered by Cloud SQL

1. In the next step, we provide the instance ID, **my-instance**, a password for the default **postgres** user, and the required version of the engine. Next, we select a predefined instance configuration (**Production** for critical workloads, or **Development**, a cost-optimized version). In our case, we need to provide high availability for the database, so we choose **Production**. Finally, note that on the right-hand side, there is a **Summary** section, which shows the most current setup and performance characteristics:

![Figure 8.30 – Creating a PostgreSQL instance](../images/B18851_08_30.jpg)

Figure 8.30 – Creating a PostgreSQL instance

1. In the next step, we select a region where we want the instance to be deployed. For the minimal latency between the VM and the database, we select the same region where the VM is running: **europe-central2**. Also, as the database must be highly available, we select a multi-zonal availability:

![Figure 8.31 – Selecting a region and an availability type for a PostgreSQL instance](../images/B18851_08_31.jpg)

Figure 8.31 – Selecting a region and an availability type for a PostgreSQL instance

1. In the **Customize your instance** section, you can choose its machine type (*memory* and *cores*), storage type (**HDD** or **SSD**), and disk capacity. In our example, although the database needs to be highly available, it doesn’t need high performance, so we will override the predefined settings and deploy a **Lightweight** machine type with 1vCPU and 3.75 GB of RAM, and set **Storage type** as **SSD** and **10 GB**.
2. In the **Connections** section, we configure the instance to be accessible only internally via **Private IP** and select the same VPC where the application is running – **my-network** for this connection. The private services access needs to be set up for the private communication to work, so we follow the **SET UP CONNECTION** wizard, selecting the default options. We will use **Cloud SQL Auth Proxy** installed inside **VM-a** to connect to the database:

![Figure 8.32 – Network configuration for a PostgreSQL instance](../images/B18851_08_32.jpg)

Figure 8.32 – Network configuration for a PostgreSQL instance

1. In the **Data protection** section, we select the 4-hour backup window to match the task’s requirements and the default location where backups will be stored, which is the closest multi-region location to the database instance. The default retention is to keep **7** backups. We also need to enable point-in-time recovery and store 7 days of logs.

![Figure 8.33 – Configuring backups for PostgreSQL instance](../images/B18851_08_33.jpg)

Figure 8.33 – Configuring backups for PostgreSQL instance

1. Select **Create Instance** and wait till it is available. It usually takes a few minutes. Once the instance is ready, you can select it to view more details:

![Figure 8.34 – Details of the PostgreSQL instance, my-instance](../images/B18851_08_34.jpg)

Figure 8.34 – Details of the PostgreSQL instance, my-instance

1. We need to create a PostgreSQL database that will run in **my-instance**. Select **Databases** from the menu and then **CREATE DATABASE**, providing its name: **my-db**. If you need to create additional users, you can do so in the **Users** section of the menu. To populate a database with data, you can use the **IMPORT** option to import data from a file uploaded to a Google Cloud Storage bucket:

![Figure 8.35 – Importing data from a bucket](../images/B18851_08_35.jpg)

Figure 8.35 – Importing data from a bucket

1. Enable **Cloud SQL Admin API** in the project where **VM-a** is running. Ensure that the service account that the VM is configured with has a **Cloud SQL Client** role. Both settings are needed to connect to the database from the VM.
2. SSH to **VM-a** and download **Cloud SQL** **Auth Proxy**:

   ```
   wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
   ```
3. Make it executable:

   ```
   chmod +x cloud_sql_proxy
   ```
4. Start the proxy to **my-instance**:

   ```
   ./cloud_sql_proxy -instances=my-demo-project:europe-central2:my-instance=tcp:5432 &
   ```

The application running on **VM-a** can use the local proxy to connect to the database, **my-database**. You can also connect to the database and access its content using the following command:

```
psql "host=127.0.0.1 port=5432 sslmode=disable dbname=my-database user=postgres"
```

![Figure 8.36 – Starting Cloud SQL Auth Proxy inside VM-a and accessing the my-db PostgreSQL database](../images/B18851_08_36.jpg)

Figure 8.36 – Starting Cloud SQL Auth Proxy inside VM-a and accessing the my-db PostgreSQL database

In addition to the application’s access to the database, the application owner could use integration with BigQuery to share database data with his analytics team. For example, if the instance was created with a Public IP instead of using a private service access communication, the analytics team could connect to Cloud SQL, not from a VM as in this example excercise, but from BigQuery directly and run federated queries on the PostreSQL database:

![Figure 8.37 – Using BigQuery integration with Cloud SQL](../images/B18851_08_37.jpg)

Figure 8.37 – Using BigQuery integration with Cloud SQL

The preceding figure shows an example of how a federated query in the BigQuery view looks once the **external connection** to Cloud SQL is created.

### Cloud Spanner

There are limits to how much a relational database can expand. In most cases, it can only expand vertically. For example, you can grow Cloud SQL instances (described in the previous sections) by adding more storage or replicating to a larger instance up to the largest available type (vertical scaling), but to some point only, and not without performance sacrifices and downtime during migrations. Also, if a database needs to be reachable globally from applications requiring low latency, Cloud SQL can only provide regional read replicas for read-only operations.

Cloud Spanner is a Google-managed relational database service (with SQL schemas and querying) that can horizontally scale for reads and writes. **Horizontal scaling** is a method of increasing processing power and storage capacity by distributing the workload across multiple instances, unlike vertical scaling, which adds more resources to a single instance.

Furthermore, Cloud Spanner has global reachability as it can span across regions so that it can be accessed with low latency from all over the world. In addition, it meets the highest availability demands as it offers an SLA of up to 99.999% (roughly 5 minutes of downtime per year) for a multi-regional deployment. It doesn’t failover to a **standby instance** like Cloud SQL, but it elects a new leader out of available read-write replicas.

Spanner is located in the **DATABASES** section of the main menu of the Google Cloud console. When configuring an instance, you can choose the following configurations:

- The **Regional** option, which will create three read-write replicas in three separate zones within a chosen region. Regional configurations have 99.99% availability (roughly 50 minutes of downtime in a year) and low write latency within their region.
- The **Multi-region** option:
  - Spans across the same continent, with two read-write replicas in two regions and one **Witness** location.
  - Spans across the globe; for example, two read-write replicas in two regions of the same continent (the US), with one Witness replica (the US) and two read-replicas in the other two continents (Europe and Asia).

Note that a Witness replica’s role is not to serve reads but to form a majority quorum in case of a region’s loss. Multi-region configurations have 99.999% availability and low read latencies in multiple regions. The trade-off is increased write latency compared to Regional configurations, as the replication is synchronous and read-write replicas in separate regions need to vote on each write. Once a transaction is committed, it is written to all databases.

![Figure 8.38 – Configuring a Spanner instance that spans globally](../images/B18851_08_38.jpg)

Figure 8.38 – Configuring a Spanner instance that spans globally

The following example presents how the replicas could be located when choosing the **nam-eur-asia1** configuration, which spans continents. The global consistency for Spanner databases is achieved by utilizing Google’s low-latency global network and **TrueTime**, a global clock responsible for time synchronization across data centers:

![Figure 8.39 – Explanatory figure of Spanner node placements across the globe for the nam-eur-asia1 multi-region setup](../images/B18851_08_39.jpg)

Figure 8.39 – Explanatory figure of Spanner node placements across the globe for the nam-eur-asia1 multi-region setup

In addition to Spanner’s location, you need to configure your instance compute and storage capacity by selecting either a required number of processing units or nodes (1 node equals 1,000 processing units). Each node equals 4 TB of storage with peak read and write performance per node being specific to a region. For example, for the **nam-eur-asia1** setup, it is approximately 7,000 peak reads per region and 1,000 peak writes globally. Later, you can scale up or down your instance to add more resources or reduce the number of idle ones. This operation doesn’t require a maintenance window.

Similarly to Cloud SQL, Spanner supports point-in-time recovery for up to seven days, protecting data against accidental deletion or corruption. For longer-term retention, Spanner offers backups in the form of a transactionally consistent full copy of a database that can be stored for one year.

## Non-relational databases (NoSQL)

Non-relational databases store data in an unstructured format. In contrast to SQL databases with a fixed schema, NoSQL databases store data as documents (JSON), key-value pairs, graphs, or dynamic-sized tables. Non-relational databases scale horizontally by adding new servers, making them a good fit for big data. Let’s look at the NoSQL database options that are offered by Google Cloud.

### Cloud Bigtable

Imagine you need to design an application that continuously scans the state of millions of IoT sensors, or that the service you are designing will be responsible for keeping track of a few million users’ behaviors and offering them recommendations based on their preferences. In such scenarios, you will have to store data in a low-latency database. Still, the data model must be flexible because data structures could change over time: upgraded IoT devices storing an additional set of parameters could be introduced, or a new service could be integrated with your recommendation engine. Therefore, such a database should be able to store large amounts of rapidly changing and constantly growing data. Also, it should retrieve data within single-digit milliseconds as everyone expects to get results in real time. On the other hand, high throughput demands could be seasonal, so such a database would have to be able to scale up and down based on load for cost optimization.

Cloud Bigtable is a good fit for such cases. It is a fully managed, key-value, and wide-column NoSQL database designed to store petabytes of data and scales well, offering low latency reads and writes. A Cloud Bigtable instance is a container that hosts clusters deployed in one or many regions. Clusters consist of nodes that define the performance of an instance. You can add or remove nodes manually via autoscaling without downtime. Inside an instance, we can create tables. With Bigtable, we manage tables, not a database itself.

The cost optimization of Cloud Bigtable comes not only from the ability to scale up and down. In addition, tables in Bigtable are sparse, which means they don’t need to store entries in every cell. Because there is no charge for empty cells, savings can be significant, especially when such a database scales to an enormous number of rows and columns.

The IoT service or the recommendation engine from our example could also benefit from Cloud Bigtable’s **versioning**, which can help, for example, with time series analysis. Cells in tables may not only be empty but they can also have different values at different time points. Each time data is written to a cell, it is timestamped, so when new data is written to the same cell, the old one is not overridden. You can enable a **garbage collection** to delete older versions when they are no longer needed and reclaim this space.

You can increase the availability of a Cloud Bigtable instance by replicating it to clusters in other regions. The replication in the same cluster within nodes is **strongly consistent**, but **eventually consistent** between clusters. This means that it can take some time between when data is written to one cluster and the time it can be read from another.

To protect data in tables, you can use backups stored on the cluster that owns a table and keep it for up to 30 days.

Cloud Bigtable is a non-relational database, so it might be not easy to use it for analytics operations as it doesn’t support joins and aggregations. However, for analyzing data stored in Cloud Bigtable, leverage its integration with BigQuery.

You can work with an instance and create tables and backups in the Google Cloud console. But to interact with tables, you will have to use client libraries (HBase Java Client, Go, and Python Client), HBase Shell, or **cbt**, a command-line tool for performing operations on Cloud Bigtable. The **cbt** tool can be installed as a **gcloud** CLI component or launched from Cloud Shell.

![Figure 8.40 –Creating a Bigtable table via the Google Cloud console](../images/B18851_08_40.jpg)

Figure 8.40 –Creating a Bigtable table via the Google Cloud console

To download **cbt** to your workstation, use the following command:

```
gcloud components install cbt
```

You can configure **cbt** to use your project by editing the **cbtrc** configuration file:

```
echo project = my-demo-project-xxx >> ~/.cbtrc
```

A Bigtable instance can be created via the Google Cloud console or **cbt**. The user interface equivalent of creating an instance would be the following:

```
cbt creanteinstance <instance-id> <display-name> <cluster-id> <zone> <number-of-nodes> <storage type: SSD or HDD>
```

To create a **my-instance** instance in the **us-central1** region that runs on three nodes and uses SSD storage, use the following:

```
cbt createinstance my-instance "My instance" my-instance-c1 us-central1-b 3 SSD
```

Once **my-instance** is created, you need to update the **cbtrc** file for **cbt** to use this instance:

```
echo instance = my-instance >> ~/.cbtrc
```

The following figure shows the command-line output from the creation of a Bigtable instance using the aforementioned steps:

![Figure 8.41 – Creating a Cloud Bigtable instance with the cbt tool](../images/B18851_08_41.jpg)

Figure 8.41 – Creating a Cloud Bigtable instance with the cbt tool

Let’s use **my-instance** to create an example table that stores information about room temperature from sensors:

![Figure 8.42 – A table that stores the temperature and location of sensors](../images/B18851_08_42.jpg)

Figure 8.42 – A table that stores the temperature and location of sensors

To create a table using **cbt**, run the following command:

```
cbt createtable sensors
```

Bigtable organizes data in **column families**, which are columns often used together, such as **location**, **floor**, and **room**. It helps to organize the data and limits the amount of pulled data. We will create two column families – **temperature** and **location**:

```
cbt createfamily sensors temperature cbt createfamily sensors location
```

Then, we can provide values that match the values in the table in *Figure 8**.42*. Note that you don’t have to provide values for all the column families:

```
cbt set sensors s1 temperature:temp=5 location:floor=1 location:room=1 cbt set sensors s2 temperature:temp=15 location:floor=1 location:room=1
cbt set sensors s3 temperature:temp=15 location:floor=1 location:room=1 cbt set sensors s4 temperature:temp=15 location:floor=1 location:room=1
cbt set sensors s5 temperature:temp=15 cbt set sensors s6 location:floor=1 location:room=1
```

Use **cbt** **read sensors** to read the data from the table.

![Figure 8.43 – A part of the output of the cbt read command that shows multiple values for the same cell](../images/B18851_08_43.jpg)

Figure 8.43 – A part of the output of the cbt read command that shows multiple values for the same cell

Now, let’s say we update the temperature value for the **s1** sensor to **10**:

```
cbt set sensors s1 temperature:temp=10
```

We will see both **temperature** values with timestamps, as presented in *Figure 8**.43*.

The following figure shows a screenshot of a section of a database output (for the **s4**, **s5**, and **s6** sensors) after we added values to columns for our sensors. Note that the table is sparse, so for the **s4** sensor, we have values for each of the columns (**floor**, **room**, and **temp**) but the **s5** sensor has only a value for **temp**, and the **s6** sensor only has values for **floor** and **room**.

![Figure 8.44 – A part of the output of the cbt read command showing that not all cells have values](../images/B18851_08_44.jpg)

Figure 8.44 – A part of the output of the cbt read command showing that not all cells have values

Now that we looked into the key-value NoSQL database, let’s see a different type of NoSQL type, which is a document store.

### Firestore

Firestore is a serverless document database with all its underlying infrastructure components and complexity hidden from users. Compared to Cloud Bigtable, where we deploy an instance with nodes that define the performance, or Cloud SQL, where we configure CPU, RAM, and storage resources for an instance, there is no node provisioning and resource planning in Firestore. In consequence, Firestore scales horizontally and transparently to a user. Also, the pricing in Firestore is based on consumption (for example, on stored data and operations such as read, write, and delete), not on assigned resources.

Firestore operates in two modes:

- **Datastore mode**, which is compatible with a Datastore database and can be used by existing Datastore users. It has the same API but a new storage layer that provides strong consistency and high availability. Firestore is a new Datastore version optimized for writes and real-time updates.
- **Native mode**, which leverages a document model and integrates with third-party clients. It is optimized for concurrent connections.

In both cases, databases can be either multi-regional, with 99.999% SLA, or regional, with 99.99% SLA.

The first step of a Firestore setup is to select the mode. This selection is permanent. In this chapter, we will examine the **Native mode**. Selecting the location is the second and last step to configure Firestore:

![Figure 8.45 – Firestore location options: multi-region and regional](../images/B18851_08_45.jpg)

Figure 8.45 – Firestore location options: multi-region and regional

This document database stores **collections** of organized objects called **documents**. They consist of named string fields, numbers, and object data values in the form of JSON documents. There is no schema enforcement. Instead, documents are stored in a flexible tree-like structure:

![Figure 8.46 – Hierarchical structure of collections and documents](../images/B18851_08_46.jpg)

Figure 8.46 – Hierarchical structure of collections and documents

The preceding figure presents a simplified example structure of the Firestore database with collections named **Books**, **Movies**, and **Music**. In every collection, there is a set of documents with fields that describe features of books, films, and albums. Each collection has a **subcollection** that represents the ratings for some items.

In the following screenshot, we can see how the example **Book**, **Movies**, and **Music** collections could be implemented. For example, the **Book** collection consists of documents that contain fields describing the details of a book:

![Figure 8.47 – The Data view in the Firestore panel with example collections](../images/B18851_08_47.jpg)

Figure 8.47 – The Data view in the Firestore panel with example collections

Firestore has libraries for popular languages such as Java or Python, and Android and iOS devices can access it directly via native SDKs. In most cases, it will be fixed in the code of an application, with an imported Firestore client library to query a database. But we can also use the Google Cloud console to query data. The following example shows a query run against the **Book** collection, where all the documents containing the defined author name in the author field are listed:

![Figure 8.48 – Database query run from the Firestore panel](../images/B18851_08_48.jpg)

Figure 8.48 – Database query run from the Firestore panel

One of the most valuable features of Firestore that helps developers to build mobile-friendly applications is how it can handle data synchronization between a database and a client in real time: for example, when a user runs a query to see and rate books written by an author and, at the same time, a cover of one of the books changes, a client application is notified, and the changed data is sent to a device. Similarly, data can be synchronized across mobile devices that use the same application.

In addition to **real-time updates**, Firestore provides **offline support**. Imagine that a user from the preceding example temporarily loses access to the internet while looking at book ratings in the application. Assuming the application is leveraging the offline support functionality of Firebase, it will cache queries on a mobile device so a user can look at search results, even when a device is offline. Moreover, all the changes made when rating books are queued up on a device and will be uploaded after it goes online:

![Figure 8.49 – Real-time updates for online devices and data caching for offline devices](../images/B18851_08_49.jpg)

Figure 8.49 – Real-time updates for online devices and data caching for offline devices

Applications on mobile devices can directly interact with Firestore. Still, usually, there is a logic between a database and users, for example, to moderate uploaded data, send notifications to keep them engaged, or offload some functionality from a mobile application to limit battery usage on devices. Cloud Functions could be used for this purpose.

Looking at the way Firestore is structured, it won’t be a good fit for offline analysis and queries across datasets. But Firestore data can be exported to BigQuery for more advanced queries, and BigQuery will be what we will cover next.

## Warehouse and analytics – BigQuery

As data grows out of datasheets, it needs a more efficient system for its analytics – a data warehouse. However, scaling and managing such a platform on-premises can be challenging, especially when data grows from gigabytes to terabytes and petabytes. Such challenges are addressed by the Google-managed serverless data warehouse: BigQuery.

This is a query engine designed to handle massive amounts of data with no limit to the amount of data that can be stored. In addition, BigQuery supports SQL queries and is a good choice for table scan tasks and cross-database queries.

It owes its horizontal scalability to storage and compute separation. Although storage and compute layers are decoupled, it doesn’t impact the speed of data access, thanks to Google’s fast networking. Also, it is highly durable (with eleven nines of durability, the chance of data loss is almost 0) as it replicates data across zones. Still, its whole internal architecture is hidden from users as BigQuery is serverless.

Data in BigQuery is organized in containers called **datasets**, which are top-level folders that organize and control access to underlying tables:

![Figure 8.50 – BigQuery Explorer view in the Google Cloud console with example dataset with tables](../images/B18851_08_50.jpg)

Figure 8.50 – BigQuery Explorer view in the Google Cloud console with example dataset with tables

BigQuery is integrated with Google’s IAM service so you can manage read/write access to datasets for users and groups, enabling their collaboration on shared data. For example, a predefined **BigQuery Data Viewer** role lets you view a dataset’s details. A **BigQuery Data Editor** role allows you to create, update, and delete dataset tables. A user with **BigQuery Job User** role has the ability to execute various jobs, such as running queries, within the whole project.

Data stored in BigQuery is encrypted before being written onto disks. The encryption is done using either Google-managed or customer-managed encryption keys.

You can import data to BigQuery in the following ways:

- If your data will not change, it can be loaded once as a batch operation. For example, you can use a file in a CSV format and let BigQuery auto-detect its schema. Data can be uploaded from a local machine, Google Cloud Storage, or Cloud Bigtable. You can also upload data from object storage from other cloud providers.
- If your data changes occasionally (for example, once a day), you can use the **Data Transfer** feature of BigQuery and load data on schedule from other Google services or external storage or warehouse providers.
- If data needs to be analyzed in real-time, some options would be to stream data to BigQuery via the **Storage Write API** or **Dataflow**, a Google Cloud serverless service for unified stream and batch data processing (for more information on Dataflow, check [*Chapter 10*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_10.xhtml#_idTextAnchor224).

Once raw data is loaded, it can be used as staging data for further processing.

You can interact with BigQuery via the Google Cloud console or **bq**, a Python-based command-line tool from the **gcloud** CLI. It also supports client libraries for Python, Java, and Go. Alternatively, you can use the REST API or third-party tools for further integration.

The following screenshot presents the BigQuery **Explorer** view, where you can create datasets and tables, import data to a table, and run SQL queries:

![Figure 8.51 – Example SQL query on a table containing imported data from a CSV file](../images/B18851_08_51.jpg)

Figure 8.51 – Example SQL query on a table containing imported data from a CSV file

Data can be further visualized in **Looker Studio**, a platform where you can explore data and build charts based on various metrics and filters, narrowing down the dataset:

![Figure 8.52 – Google Maps-style dashboard in Looker visualizing the query from Figure 8.51](../images/B18851_08_52.jpg)

Figure 8.52 – Google Maps-style dashboard in Looker visualizing the query from Figure 8.51

You can practice SQL queries in BigQuery on a public dataset: **bigquery-public-data**. Please refer to the documentation for detailed instructions on how to use public datasets:<https://cloud.google.com/bigquery/docs/quickstarts/query-public-dataset-console>.

Please refer to the following screenshot for an example of how to query the public dataset’s **bigquery-public-data.san\_francisco\_film\_locations.film\_locations** table to search for information regarding the filming locations of a popular movie that was shot in San Francisco:

![Figure 8.53 – Practicing SQL queries on the public dataset](../images/B18851_08_53.jpg)

Figure 8.53 – Practicing SQL queries on the public dataset

To build queries, you can also use Cloud Shell, which has the **bq** command-line tool installed. In addition to the Google Cloud console, this is another option available to you. Simply run the **bq ls** command to list the available datasets. To construct your queries, use the following format:

```
bq query --use_legacy_sql=false 'SELECT title, release_year, locations, actor_1 FROM `bigquery-public-data.san_francisco_film_locations.film_locations` where title LIKE "%Matrix%" ORDER BY release_year';
```

The following screenshot presents the Cloud Shell console view where the similar command is issued:

![Figure 8.54 – Practicing the bq command-line tool](../images/B18851_08_54.jpg)

Figure 8.54 – Practicing the bq command-line tool

Now, let’s look into the last storage option of this chapter. It is a totally different kind of database than we have investigated so far. This one is optimized to provide the lowest response times.

## In-memory datastore – Memorystore

Applications designed for real-time banking, online interactive gaming with player scores and profiles, or geospatial processing all need the fastest possible response times. Databases such as Cloud SQL or Spanner still rely on disk operations, although they provide high throughput. To reduce its response latency to an absolute minimum, a database could be stored in memory directly by a processor.

Google Cloud offers a fully managed in-memory data store service called **Memorystore** for two open source caching engines: **Redis** and **Memcached**. Both can be used to build a cache for an application for heavily accessed data with sub-millisecond access to a dataset. In this section, we will focus on Redis.

Reduced latency is a huge benefit, but it doesn’t come without a trade-off. RAM is expensive and is available in smaller sizes compared to disks. That is why in-memory databases are kept closer to an application and used to accelerate an application response time, having a traditional, sizeable disk-based database at the backend.

Also, the in-memory database will not survive a node restart as memory is flushed in that process. Even though applications can be designed to populate cache from persistent disks to avoid downtime, Memorystore can be deployed with read replicas to which it can automatically failover. Also, Memorystore supports **Redis Database** **RDB** **snapshots**, which are point-in-time snapshots of a dataset.

When you provision a Redis instance, you provide the following: its name, location, the number of replicas, the VPC network that clients will use to connect to it, and its memory size. The more memory you provision, the higher throughput you will get.

There are two types of Memorystore for Redis:

- **Basic tier**, which you can deploy as a single Redis instance in a zone. It can serve as a simple cache, assuming an application that uses it can tolerate Redis data loss when this instance is restarted. The instance health is monitored, but there is no SLA.
- **Standard tier**, where instances of Redis are replicated across zones in a region. Up to five read replicas can be deployed. If you deploy an instance without a read replica, one replica will be deployed for high availability. Note that this replica won’t be enabled for reads. The Standard tier offers an SLA of 99.9% (roughly 9 hours per year). Multiple read replicas are used not only for availability but also to distribute the load of read operations. Each Redis instance is deployed with the **primary endpoint** that points to the **primary replica** and the **read endpoint** distributed among read replicas.

The following figure presents an example of Memorystore deployment options, where, with the Basic tier, only one instance can be deployed and accessed via an endpoint, and with the Standard tier, we can have one or more instance replica(s) used for high availability accessed via a primary endpoint. Additionally, we can utilize multiple replicas for reads, accessed via a read endpoint.

![Figure 8.55 – Memorystore deployment options for the Basic and Standard tier](../images/B18851_08_55.jpg)

Figure 8.55 – Memorystore deployment options for the Basic and Standard tier

In the following screenshot, you can see the **Memorystore** section in the Google Cloud console. There is a Redis instance deployed in **europe-central2** with **5 GB** of capacity, a **Standard** tier with read replicas. It has two endpoints – **Primary endpoint** for read/write access and **Read endpoint** for scaling read operations:

![Figure 8.56 – Memorystore dashboard with a Redis instance](../images/B18851_08_56.jpg)

Figure 8.56 – Memorystore dashboard with a Redis instance

You can manage a Redis instance in the Google Cloud console using **gcloud** commands or client libraries in your code. You can control access to an instance via IAM. To connect to a Redis instance, a client should be in the same VPC as the instance, as it uses an internal IP. Alternatively, to connect to the instance from another VPC, a VPN service could be used.

Let’s assume you want to connect to an instance from a Compute Engine VM that uses the same VPC as your Redis instance. First, you need to deploy a **redis-tools** client:

```
sudo apt-get install redis-tools
```

To connect to an instance, use the following:

```
redis-cli -h 10.178.160.5
```

Here, the IP address is the one presented in the **Memorystore** dashboard for this instance.

You can run **redis-benchmark** to generate some workload:

```
redis-benchmark -h 10.178.160.5 -q
```

The following figure presents a monitoring chart of this instance with calls that the preceding **benchmark** command triggered to test the database performance. It’s very convenient to have observability built into a database service because it allows for closer monitoring and troubleshooting of any issues that may arise:

![Figure 8.57 – A Redis instance dashboard with a monitoring chart](../images/B18851_08_57.jpg)

Figure 8.57 – A Redis instance dashboard with a monitoring chart

The preceding screenshot presents a **Monitoring** dashboard with client calls during **redis-benchmark** tests.

# Summary

This chapter explored various ways that data can be stored in Google Cloud. Let’s summarize what we have learned about storage.

For large amounts of unstructured data, we could use Google Cloud Storage. Applications installed inside Compute Engine VM will benefit greatly from performant local or persistent drives. If files need to be shared between users over a network, Filestore will be the best fit. If data that we store for an application is structured and can be organized in tables, relational databases such as Cloud SQL or Spanner will make a good choice, with Spanner being able to scale horizontally better. If the data is not relational but of the key-value type, Cloud Bigtable is a perfect use case. Firestore is the best fit if you are looking for a document database for mobile applications. BigQuery would be the best for analyzing large amounts of unchanged data.

Please refer to the following diagram, which will hopefully assist you in identifying the differences between the database solutions discussed in this chapter:

![Figure 8.58 – Selecting the right database, a decision tree with keywords that summarize features of databases in Google Cloud](../images/B18851_08_58.jpg)

Figure 8.58 – Selecting the right database, a decision tree with keywords that summarize features of databases in Google Cloud

As you may have noticed, we also briefly discussed networking when exploring accessing databases and storage. Moving forward, in the upcoming chapter, we will delve deeper into the world of networking and explore its intricacies.

# Questions

Answer the following questions to test your knowledge of this chapter:

1. You are looking for a storage solution your global team could use for video editing collaboration. The current amount of data is 10 TB, but it is expected to grow to 80 TB. Which option should you choose?
   1. The Google Cloud Storage Standard tier as the price per operation on data is the lowest compared to other tiers.
   2. High Scale Filestore with a mechanism to backup edited videos to Google Cloud Storage for long-term storage.
   3. Compute Engine VM with a balanced persistent disk of 80 TB replicated between two zones in a region for better resiliency.
   4. Google Cloud Hyperdisk to ensure the highest performance.
2. Your company discovered that many users from the **europe-central2** region also use their application backed by Cloud SQL in the **europe-west3** region. How can you ensure all users get the same experience when using your application?
   1. Deploy another Cloud SQL instance (read-write replica) in **europe-central2**.
   2. Migrate the database to Cloud Spanner.
   3. Add more CPU and RAM resources to your Cloud SQL instance to handle increasing traffic.
   4. Deploy another Cloud SQL instance (read replica) in **europe-central2**.
3. You are looking for a database to store constantly changing data uploaded by millions of various types of sensors in real time. Which database should you choose?
   1. Bigtable, because it offers high throughput and scalability for unstructured data.
   2. BigQuery, because it is petabyte-scale storage that can process such a large amount of data.
   3. Cloud SQL, as this type of data should be stored in a relational database where advanced querying and operations on data are available.
   4. Only Cloud Spanner can handle such an amount of data.
4. Your team plans to deploy a Cloud SQL instance as a backend of their new gaming application. They expect massive traffic on the day the game is launched globally, but later, the number of users will most likely drop significantly. So, they asked you for advice on how to make the launch successful:
   1. Firebase is the most optimal database for gaming.
   2. Cloud SQL is a perfect fit. They should go with the largest machine type available and create a read replica in another region. Once the traffic decreases, to save costs, they can scale the database down by changing the machine type to a smaller one on the replica first (power off is required), promoting it to the primary instance, and downsizing the “new” replica in the next step.
   3. Cloud SQL is a perfect fit. They should use the medium-sized machine type and create a read replica in another region. Once the traffic increases, to adjust the throughput, they can scale the database up by changing the machine type to a larger one on the replica first (power off is required), promoting it to the primary instance, and changing the machine type for the “new” replica in the next step.
   4. They should use Spanner instead of Cloud SQL because its instances can span the globe so that all users will have the same experience (similar latency). Also, they can deploy the Autoscaler tool in Spanner, which could take care of increasing or reducing the number of nodes or processing units based on utilization.
5. Your manager is concerned about the Google Cloud Storage bill. He thought the Archive tier would be an inexpensive replacement to tape backups, but after running it for a month, it costs too much. Also, he is sure no backups were deleted. How can you explain it?
   1. It must be a mistake. You open a support ticket to have this sorted out.
   2. You investigate your billing report looking for early deletion charges, which must be the only reason for the increased Google Cloud Storage cost this month.
   3. You meet with the backup admin. It turns out backup copies weren’t tagged as an archive, so the backup solution ran daily consistency checks on those objects, meaning operation charges were applied. You deactivate this option.
   4. You should activate Autoclass on the bucket and let it automatically adjust the storage class based on the access pattern.
6. Your team is working on a new application that will recommend nearby restaurants for mobile users in your city based on other users’ ratings. Unfortunately, the mobile network coverage is poor in your city. The team worries users will lose interest if this application stops working when a mobile is offline. Your role is to help to overcome this issue:
   1. You recommend Firestore as it can handle caching application data on offline mobile devices.
   2. You suggest adding a mobile app code to monitor the network coverage. If it detects a drop in coverage, it will display random pictures of restaurants to keep the user engaged.
   3. You decide to use Memorystore, which is perfect for caching data.
   4. You propose adding a code to the mobile application to monitor the coverage. Once it detects it is dropping, it immediately pushes all changes to the Firestore database.
7. Your team selected Memorystore for Redis to keep player profiles for their gaming application. Your task is to protect the database against unexpected data loss in case of failure. What architecture should you recommend, assuming everyone is concerned about costs?
   1. The Basic tier would be sufficient as it costs less than the Standard tier. In addition, the underlying hardware and a Redis instance are monitored, so nothing should happen to the database.
   2. Standard tier deployed with no read replicas.
   3. Standard tier with three read replicas, one per zone in the region.
   4. The Basic tier would be sufficient as it costs less than the Standard tier. You can schedule continuous backups of the database to avoid data loss.

# Answers

The answers to the preceding questions are as follows:

1B, 2D, 3A, 4D, 5C, 6A, 7B