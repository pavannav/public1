---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVE OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **2.3 Planning and configuring data storage options**

---

As a cloud engineer, you will have to understand the various storage options provided in Google Cloud Platform (Google Cloud). You will be expected to choose the appropriate option for a given use case while knowing the relative trade-offs, such as having access to SQL for a query language versus the ability to store and query petabytes of data streaming into your database.

Unlike most other chapters in the book, this chapter focuses more on storage concepts than on performing specific tasks in Google Cloud. The material here will help you answer questions about choosing the best storage solution. [Chapter 12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml), “Deploying Storage in Google Cloud,” will provide details on deploying and implementing data solutions.

To choose between storage options, it helps to understand how storage solutions vary by:

- Time to access data
- Data model
- Other features, such as consistency, availability, and support for transactions

This chapter includes guidelines for choosing storage solutions for different kinds of requirements.

## Types of Storage Systems

A main consideration when you choose a storage solution is the time in which the data must be accessed. At one extreme, data in an L1 cache on a CPU chip can be accessed in 0.5 nanoseconds (ns). At the other end of the spectrum some services can require hours to return data files. Most storage requirements fall between these extremes.

---

### Nanoseconds, Milliseconds, and Microseconds

Some storage systems operate at speeds as unfamiliar to us as what happens under an electron microscope. One second is an extremely long time when talking about the time it takes to access data in-memory or on disk. We measure time to access, or “latency,” with three units of measure:

- Nanosecond (ns), which is 10-9 second
- Microsecond (μ`s`), which is 10-6 second
- Millisecond (ms), which is 10-3 second

Note that the number 10-3 is in scientific notation and means 0.001 second. Similarly, 10-6 is the same as 0.000001, and 10-9 is the same as 0.000000001 second.

Another consideration is persistence. How durable is the data stored in a particular system? Caches offer the lowest latency for accessing data, but this type of volatile data exists only as long as power is supplied to memory. Shut down the server and away goes your data. Disk drives have higher durability rates, but they can fail. Redundancy helps here. By making copies of data and storing them on different servers, in different racks, in different zones, and in different regions, you reduce the risk of losing data due to hardware failures.

---

Google Cloud has several storage services, including the following:

- A managed service for caching based on Redis and Memcached
- Persistent disk storage for use with VMs
- Object storage for shared access to files across resources
- Archival storage for long-term, infrequent access requirements

### Cache

A *cache* is an in-memory data store designed to provide applications with submillisecond access to data. Its primary advantage over other storage systems is its low latency. Caches are limited in size by the amount of memory available, and if the machine hosting the cache shuts down, then the contents of the cache are lost. These are significant limitations, but in some use cases, the benefits of fast access to data outweigh the disadvantages.

#### Memorystore

Google Cloud offers Memorystore, a managed service that provides Redis or Memcached compatible caching. Both Redis and Memcached are widely used open source cache systems. Since Memorystore is protocol-compatible with Redis and Memcached, tools and applications written to work with either should work with Memorystore.

Caches are usually used with an application that cannot tolerate long latencies when retrieving data. For example, an application that reads from a hard disk drive might have to wait 80 times longer than if the data were read from an in-memory cache. Application developers can use caches to store data that is retrieved from a database and then retrieved from the cache instead of the disk the next time that data is needed.

When you use Memorystore, you create instances that run either Redis or Memcached. A Redis instance is configured with up to 300 GB of memory. It can also be configured for high availability, in which case Memorystore creates failover replicas. Memcached instances are configured as a set of up to 20 nodes, and each node can have a maximum of 256 GB. An instance can support up to 5 TB of memory.

#### Configuring Memorystore

Memorystore caches can be used with applications running in Compute Engine, App Engine, and Kubernetes Engine. [Figure 11.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0001) shows the parameters used to configure Memorystore. You can navigate to this form by choosing Memorystore from the main console menu and then selecting the option to create a Redis instance.

![Snapshot of configuration parameters for a Memorystore Redis cache](../images/c11f001.png)


[**FIGURE 11.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0001) Configuration parameters for a Memorystore Redis cache

To configure a Redis cache in Memorystore, you will need to specify an instance ID, a display name, and a Redis version. You can choose to have a replica in a different zone for high availability by selecting the Standard instance tier. The Basic instance tier does not include a replica but costs less. The configuration of a Memcached is similar but also has parameters for configuring a cluster of nodes.

You will need to specify a region and zone along with the amount of memory you want to dedicate to your cache. The cache can be 1 GB to 300 GB in size. The Redis instance will be accessible from the default network unless you specify a different network. (See [Chapter 14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml), “Networking in the Cloud: Virtual Private Clouds and Virtual Private Networks,” and [Chapter 15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml), “Networking in the Cloud: DNS, Load Balancing, Google Private Access, and IP Addressing,” for more on networks in Google Cloud.) The advanced options for Memorystore allow you to assign labels and define an IP range from which the IP address will be assigned.

The configuration of a Memcached is similar.

### Persistent Storage

In Google Cloud, persistent disks provide durable block storage. Persistent disks can be attached to VMs in Google Compute Engine (GCE) and Google Kubernetes Engine (GKE). Since persistent disks are block storage devices, you can create filesystems on these devices. Persistent disks are not directly attached to physical servers hosting your VMs but are network accessible. VMs can have locally attached solid-state drives (SSDs), but the data on those drives is lost when the VM is terminated. The data on persistent disks continues to exist after VMs are shut down and terminated. Persistent disks exist independently of virtual machines; local attached SSDs do not.

#### Features of Persistent Disks

Persistent disks are available in SSD and hard disk drive (HDD) configurations. SSDs are used when high throughput is important. SSDs provide consistent performance for both random access and sequential access patterns. HDDs have longer latencies but cost less, so HDDs are a good option when storing large amounts of data and performing batch operations that are less sensitive to disk latency than interactive applications. Persistent disks are available in the following types:

- Zonal standard persistent disks, which provide efficient and reliable block storage within a zone using standard hard disk drives
- Regional standard persistent disks, which are like zonal standard persistent disks in performance but also provide for synchronous replication across two zones within a region
- Zonal balanced persistent disks, which are cost effective and reliable storage using SSDs
- Regional balanced persistent disks, which are like zonal balanced persistent disks in performance but also provide for synchronous replication across two zones within a region
- Zonal SSD persistent disks, which provide fast and reliable block storage within a zone
- Regional SSD persistent disks, which are like zonal SSD persistent disks in performance but also provide for synchronous replication across two zones within a region
- Zonal extreme persistent disks, which offer the highest performance block storage of persistent disks and use SSDs

In addition to persistent disks, Google Cloud offers Local SSDs, which are high-performance local block storage but have no redundancy. Persistent disks have a maximum capacity of 64 TB whereas Local SSDs have a fixed capacity of 375 GB.

Persistent disks can be mounted on multiple VMs to provide multireader storage. Snapshots of disks can be created in minutes, so additional copies of data on a disk can be distributed for use by other VMs. If a disk created from a snapshot is mounted to a single VM, it can support both read and write operations.

The size of persistent disks can be increased while mounted to a VM. If you do resize a disk, you may need to perform operating system commands to make that additional space accessible to the filesystem. Both SSD and HDD disks can be up to 64 TB.

Persistent disks automatically encrypt data on the disk.

When planning your storage options, you should also consider whether you want your disks to be zonal or regional. Zonal disks store data across multiple physical drives in a single zone. If the zone becomes inaccessible, you will lose access to your disks. Alternatively, you could use regional persistent disks, which replicate data blocks across two zones within a region but are more expensive than zonal storage.

#### Configuring Persistent Disks

You can create and configure persistent disks from the console by navigating to Compute Engine and selecting Disks. From the Disk page, click Create A Disk to display a form like that in [Figure 11.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0002).

You will need to provide a name for the disk, but the description is optional. There are two types of disk: standard and SSD persistent disk. For higher availability, you can have a replica created within the region. You will need to specify a region and zone. Labels are optional but recommended to help keep track of each disk's purpose.

Persistent disks can be created blank or from an image or snapshot. Use the image option if you want to create a persistent boot disk. Use a snapshot if you want to create a replica of another disk.

When you store data at rest in Google Cloud, it is encrypted by default. When creating a disk, you can choose to have Google manage encryption keys, in which case no additional configuration is required. You could use Google Cloud's Cloud Key Management Service to manage keys yourself and store them in Google Cloud's key repository. Choose the customer-managed encryption key (CMEK) option for this. You will need to specify the name of a key you have created in Cloud Key Management Service. If you create and manage keys using another key management system, then select customer-supplied encryption key (CSEK). You will have to enter the key into the form if you choose the customer-supplied key option.

### Object Storage

Caches are used for storing relatively small amounts of data that must be accessible with submillisecond latency. Persistent storage devices can store up to 64 TB on a single disk and provide up to hundreds of IOPS for read and write operations. When you need to store large volumes of data—that is, up to exabytes—and share it widely, object storage is a good option. Google Cloud's object storage is Cloud Storage.

![Snapshot of form to create a persistent disk](../images/c11f002.png)


[**FIGURE 11.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0002) Form to create a persistent disk

#### Features of Cloud Storage

Cloud Storage is an object storage system, which means files that are stored in the system are treated as atomic units—that is, you cannot operate on part of the file, such as reading only a section of the file. You can perform operations on an object, like creating or deleting it, but Cloud Storage does not provide functionality to manipulate subcomponents of a file. For example, there is no Cloud Storage command for overwriting a section of the file. Also, Cloud Storage does not support concurrency and locking. If multiple clients are writing to a file, then the last data written to the file is stored and persisted.

Cloud Storage is well suited for storing large volumes of data without requiring any consistent data structure. You can store different types of data in a bucket, which is the logical unit of organization in Cloud Storage. Buckets are resources within a project. It is important to remember that buckets share a global namespace, so each bucket name must be globally unique. We shouldn't be surprised if we can't name a bucket “mytestbucket,” but it's not too difficult to find a unique filename.

It is important to remember that object storage does not provide a filesystem. Buckets are analogous to directories in that they help organize objects into groups, but buckets are not true directories that support features such as subdirectories. Google does support an open source project called Cloud Storage Fuse, which provides a way to mount a bucket as a filesystem on Linux and Mac operating systems. Using Cloud Storage Fuse, you can download and upload files to buckets using filesystem commands, but it does not provide full filesystem functionality. Cloud Storage Fuse has the same limitations as Cloud Storage. Its purpose is to make it more convenient to move data in and out of buckets when working in a Linux or Mac filesystem.

Cloud Storage provides four different classes of object storage: standard, nearline, coldline, and archive. For each class of storage, we can choose to store the data in a single region, dual regions, or multi-regions.

#### Storage Classes

Standard storage is the best option for frequently used data, which is sometimes referred to as “hot data” or data that is being stored for short periods of time. Dual region replication can increase availability over single region storage. Multi-region storage is a good option when the data will be read from multiple regions and you want to reduce latency to accessing data from multiple regions. Dual and multi-region Standard storage have 99.95 percent availability, while single region has 99.9 percent availability.

For infrequently accessed data, the nearline and coldline storage classes are good options. Nearline storage is designed for use cases in which you expect to access files less than once per month. Coldline storage is designed, and priced, for files expected to be accessed once per 90 days or less.

Nearline storage has a 99.95 percent typical monthly availability in multiregional locations and a 99.9 percent typical availability in regional locations. The SLAs for nearline are 99.9 percent in multiregional locations and 99.0 percent in regional locations. These lower SLAs come with a significantly lower cost per gigabyte stored, but before you start moving all your regional and multiregional data to nearline to save on costs, you should know that Google adds a data retrieval charge to nearline and coldline storage. There is also a minimum 30-day storage duration for nearline storage.

Coldline storage has a 99.95 percent typical monthly availability in multiregional locations and a 99.9 percent typical availability in regional locations. The SLAs are 99.9 percent for multiregional locations and 99.0 percent for regional locations. Coldline also has a lower cost per gigabyte than nearline storage. Remember, that is only the storage charge. Like nearline storage, coldline storage has access charges. Google expects data in coldline storage to be accessed once per 90 days or less and have at least a 90-day minimum storage.

Archive storage is designed for long-term storage for archiving, disaster recovery, and other use cases where the data will be accessed less than once per year and will be stored for at least 365 days. The SLA for Archive storage is 99.9 percent for multi-region and dual region and 99.0 percent for region location types.

It is more important to understand the relative cost relationships than the current prices. Prices can change, but the costs of each class relative to other classes of storage are more likely to stay the same.

#### Regional, Dual Regional, and Multi-Regional Storage

When you create a bucket, you specify a location to create the bucket. The bucket and its contents are stored in this location. You can store your data in a single region, dual regions, or multiple regions. A region is a specific geographic location, such as Northern Virginia, Paris, and Mumbai. A dual-region is a a pair of regions. A multi-region is a large geographic area, such as the Untied States, European Union, and Asia. The availability SLA for regional storage is 99.9 percent while dual-region and multi-region have a 99.95 percent availability SLQ. Regional buckets are redundant across zones.

Multiregional buckets are used when content needs to be stored in multiple regions to ensure acceptable times to access content. It also provides redundancy in case of zone-level failures. These benefits come with a higher cost, however. (You are not likely to be asked about specific prices on the Associate Cloud Engineer exam, but you should know the relative costs so that you can identify the lowest-cost solution that meets a set of requirements.)

Both regional and multiregional storage are used for generally used data. If you have an application where users download and access files often, such as more than once per month, then it is most cost-effective to choose regional or multiregional. You choose between regional and multiregional based on the location of your users. If users are globally dispersed and require access to synchronized data, then multiregional may provide better performance and availability.

---

![](../images/note_13.png) A note on terminology: Google sometimes uses the term *georedundant*. Georedundant data is stored in at least two locations that are at least 100 miles apart. If your data is in multiregional locations, then it is georedundant.

---

#### Versioning and Object Life Cycle Management

Buckets in Cloud Storage can be configured to retain versions of objects when they are changed. When versioning is enabled on a bucket, a copy of an object is archived each time the object is overwritten or when it is deleted. The latest version of the object is known as the live version. Versioning is useful when you need to keep a history of changes to an object or want to mitigate the risk of accidentally deleting an object.

Cloud Storage also provides life cycle management policies to automatically change an object's storage class or delete the object after a specified period. A life cycle policy, sometimes called a configuration, is a set of rules. The rules include a condition and an action. If the condition is true, then the action is executed. Life cycle management policies are applied to buckets and affect all objects in the bucket.

Conditions are often based on age. Once an object reaches a certain age, it can be deleted or moved to a lower-cost storage class. In addition to age, conditions can check the number of versions, whether the version is live, whether the object was created before a specific date, and whether the object is in a particular storage class.

You can delete an object or change its storage class. Both unversioned and versioned objects can be deleted. If the live version of a file is deleted, then instead of actually deleting it, the object is archived. If an archived version of an object is deleted, the object is permanently deleted.

You can also change the storage class of an object using life cycle management. There are restrictions on which classes can be assigned. Standard storage objects can be changed to nearline, coldline, or archive. Nearline can be changed only to coldline or archive, whereas coldline can be changed to archive.

#### Configuring Cloud Storage

You can create buckets in Cloud Storage using the console. From the main menu, navigate to Storage and select Create Bucket. This will display a form similar to [Figure 11.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0003).

When creating a bucket, you need to supply some basic information, including a bucket name and storage class. You can optionally add labels and choose either Google-managed keys or customer-managed keys for encryption. You can also set a retention policy to prevent changes to files or deletion of files before the time you specify.

Once you have created a bucket, you define a life cycle policy. Choose Lifecycle from the horizontal menu to display the form shown in [Figure 11.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0004).

Notice that the Lifecycle column indicates whether a life cycle configuration is enabled. Choose a bucket to create or modify a life cycle and click None or Enabled in the Lifecycle column. This will display the form shown in [Figure 11.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0005).

![Snapshot of form to create a storage bucket from the console. Advanced options are displayed.](../images/c11f003.png)


[**FIGURE 11.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0003) Form to create a storage bucket from the console. Advanced options are displayed.

![Snapshot of the list of buckets includes a link to define or modify life cycle policies.](../images/c11f004.png)


[**FIGURE 11.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0004) The list of buckets includes a link to define or modify life cycle policies.

When you add a rule, you need to specify the object condition and the action. Condition options are Age, Creation Data, Storage Class, Newer Versions, and Live State. Live State applies to version objects, and you can set your condition to apply to either live or archived versions of an object. The action can be to set the storage class to either nearline, coldline, or archive.

Let's look at an example policy. From the Browser section of Cloud Storage in the console, you can see a list of buckets, as shown in [Figure 11.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0006).

### Storage Types When Planning a Storage Solution

When planning a storage solution, a factor you should consider is the time required to access data. Caches, like Memorystore, offer the fastest access time but are limited to the amount of memory available. Caches are volatile; when the server shuts down, the contents of the cache are lost. You should save the contents of the cache to persistent storage at regular intervals to enable recovery to the point in time when the contents of the cache were last saved.

Persistent storage is used for block storage devices, such as disks attached to VMs. Google Cloud offers SSD and HDD drives. SSDs provide faster performance but cost more. HDDs are used when large volumes of data need to be stored in a filesystem but users of the data do not need the fastest access possible.

Object storage is used for storing large volumes of data for extended periods of time. Cloud Storage has both regional and multiregional storage classes and supports life cycle management and versioning.

In addition to choosing an underlying storage system, you will have to consider how data is stored and accessed. For this, it is important to understand the data models available and when to use them.

![Snapshot of when creating a life cycle policy, click the Add Rule option, which is in the lower horizontal menu. to define a rule.](../images/c11f005.png)


[**FIGURE 11.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0005) When creating a life cycle policy, click the Add Rule option, which is in the lower horizontal menu. to define a rule.

![Snapshot of listing of buckets in Cloud Storage Browser](../images/c11f006.png)


[**FIGURE 11.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0006) Listing of buckets in Cloud Storage Browser

## Storage Data Models

There are four broad categories of data models available in Google Cloud: object, relational, analytical, and NoSQL.

### Object: Cloud Storage

The object storage data model treats files as atomic objects. You cannot use object storage commands to read blocks of data or overwrite parts of the object. If you need to update an object, you must copy it to a server, make the change, and then copy the updated version back to the object storage system.

Object storage is used when you need to store large volumes of data and do not need fine-grained access to data within an object while it is in the object store. This data model is well suited for archived data, machine learning training data, and old Internet of Things (IoT) data that needs to be saved but is no longer actively analyzed.

### Relational: Cloud SQL and Cloud Spanner

Relational databases have been the primary data store for enterprises for decades. Relational databases support frequent queries and updates to data. They are used when it is important for users to have a consistent view of data. For example, if two users are reading data from a relational table at the same time, they will see the same data. This is not always the case with databases that may have inconsistencies between replicas of data, such as some NoSQL databases.

Relational databases, like Cloud SQL and Cloud Spanner, support database transactions. A transaction is a set of operations that is guaranteed to succeed or fail in its entirety—there is no chance that some operations are executed and others are not. For example, when a customer purchases a product, the count of the number of products available is decremented in the inventory table, and a record is added to a customer-purchased products table. With transactions, if the database fails after updating inventory but before updating the customer-purchased products table, the database will roll back the partially executed transaction when the database restarts.

Cloud SQL and Cloud Spanner are used when data is structured and modeled for relational databases. Cloud SQL is a managed database service that provides MySQL, SQL Server, and PostgreSQL databases. Cloud SQL is used for databases that do not need to scale horizontally—that is, by adding additional servers to a cluster. Cloud SQL databases scale vertically—that is, by running on servers with more memory and more CPU. Cloud Spanner is used when you have extremely large volumes of relational data or data that needs to be globally distributed while ensuring consistency and transaction integrity across all servers.

Large enterprises often use Cloud Spanner for applications like global supply chains and financial services applications, whereas Cloud SQL is often used for web applications, and e-commerce applications.

#### Configuring Cloud SQL

You can create a Cloud SQL instance by navigating to Cloud SQL in the main menu of the console and selecting Create Instance. You will be prompted to choose a MySQL, PostgreSQL, or SQL Server instance, as shown in [Figure 11.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0007).

![Snapshot of cloud SQL provides MySQL, PostgreSQL, and SQL Server instances.](../images/c11f007.png)


[**FIGURE 11.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0007) Cloud SQL provides MySQL, PostgreSQL, and SQL Server instances.

To configure a MySQL instance, you will need to specify a name, root password, region, and zone. The configuration options include the following:

- MySQL version.
- Connectivity, where you can specify whether to use a public or a private IP address.
- Machine type. The default is a db-n1-standard-1 with 1 vCPU and 3.75 GB of memory.
- Automatic backups.
- Failover replicas.
- Database flags. These are specific to MySQL and include the ability to set a database read-only flag and set the query cache size.
- A maintenance time window.
- Labels.

[Figure 11.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0008) shows the configuration form for MySQL instances, [Figure 11.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0009) shows the configuration for SQL Server instances, and [Figure 11.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0010) shows the configuration for PostgreSQL instances.

#### Configuring Cloud Spanner

If you need to create a global, consistent database with support for transactions, you should consider Cloud Spanner. Given the advanced nature of Spanner, its configuration is surprisingly simple. In the console, navigate to Cloud Spanner and select Create Instance to display the form in [Figure 11.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0011).

![Snapshot of configuration form for a MySQL instance](../images/c11f008.png)


[**FIGURE 11.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0008) Configuration form for a MySQL instance

You need to provide an instance name, instance ID, and number of nodes. You will also have to choose either a regional or multiregional configuration to determine where nodes and data are located. This will determine cost and replication storage location. If you select Regional, you will choose from the list of available regions, such as us-west1, asia-east1, and europe-north1.

### Analytical: BigQuery

BigQuery is a service designed for a data warehouse and analytic applications. BigQuery is designed to store petabytes of data. BigQuery works with large numbers of rows and columns of data and is not suitable for transaction-oriented applications, such as e-commerce or support for interactive web applications.

![Snapshot of configuration form for a SQL Server instance](../images/c11f009.png)


[**FIGURE 11.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0009) Configuration form for a SQL Server instance

#### Configuring BigQuery

BigQuery is a serverless analytics service, which provides storage plus query, statistical, and machine learning analysis tools. BigQuery does not require you to configure instances. Instead, when you first navigate to BigQuery from the console menu, you will see the form shown in [Figure 11.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0012).

The first task for using BigQuery is to create a dataset to hold data. You do this by clicking Create Dataset to display the form shown in [Figure 11.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0013).

When creating a dataset, you will have to specify a name and select a region in which to store it. Not all regions support BigQuery. Currently you have a choice of most locations across the United States, Europe, and Asia.

![Snapshot of configuration form for a PostgreSQL instance](../images/c11f010.png)


[**FIGURE 11.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0010) Configuration form for a PostgreSQL instance

In [Chapter 12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml), we will discuss how to load and query data in BigQuery and other Google Cloud databases.

### NoSQL: Cloud Firestore and Bigtable

NoSQL databases do not use the relational model and do not require a fixed structure or schema. Database schemas define what kinds of attributes can be stored. When no fixed schema is required, developers have the option to store different attributes in different records. Google Cloud has a document database called Cloud Firestore and a wide column database called Bigtable.

![Snapshot of the Cloud Spanner configuration form in Cloud Console](../images/c11f011.png)


[**FIGURE 11.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0011) The Cloud Spanner configuration form in Cloud Console

![Snapshot of bigQuery user interface for creating and querying data](../images/c11f012.png)


[**FIGURE 11.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0012) BigQuery user interface for creating and querying data

![Snapshot of form to create a data set in BigQuery](../images/c11f013.png)


[**FIGURE 11.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0013) Form to create a data set in BigQuery

#### Firestore Features

Firestore is a document database. That does not mean it is used to store documents like spreadsheets or text files but that the data in the database is organized into a structure called a document. Documents are made up of sets of key-value pairs. A simple example is as follows:

```
    { book : "ACE Study Guide",
        chapter: 11, length: 20,
    topic: "storage" }
```

This example describes the characteristics of a chapter in a book. There are four keys or properties in this example: `book`, `chapter`, `length`, and `topic`. This set of key-value pairs is called an *entity* in Firestore terminology. Entities often have properties in common, but since Firestore is a schema-less database, there is no requirement that all entities have the same set of properties. Here's an example:

```
    { book : "ACE Study Guide",
        Chapter: 11, topic: "computing",
    number_of_figures: 8 }
```

Firestore is a managed database, so users of the service do not need to manage servers or install database software. Firestore automatically partitions data and scales up or down as demand warrants.

Firestore is used for nonanalytic, nonrelational storage needs. It is a good choice for product catalogs, which have many types of products with varying characteristics or properties. It is also a good choice for storing user profiles associated with an application.

Firestore has some features in common with relational databases, such as support for transactions and indexes to improve query performance. The main difference is that Firestore does not require a fixed schema or structure and does not support relational operations, such as joining tables, or computing aggregates, such as sums and counts.

Cloud Firestore is the latest generation of document databases in Google Cloud. Cloud Datastore preceded Cloud Firestore as a document database.

#### Configuring Firestore

Firestore, like BigQuery, is a serverless database service that does not require you to specify node configurations. Instead, you can work from the console to add entities to the database. [Figure 11.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0014) shows the initial form that appears when you first navigate to Firestore in Cloud Console. The first thing you must do when using Firestore is choose between Native mode, which automatically scales to millions of clients, or Datastore mode, which automatically scales to millions of writes per second.

Once you have chosen a mode, you choose where to store your data (see [Figure 11.15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0015)). You have the option of using multiregional storage or regional storage.

Once you have configured Cloud Firestore for your project in Datastore mode, you can create entities. When creating an entity, you specify a namespace, which is a way to group entities much like schemas group tables in a relational database. You will need to specify a kind, which is analogous to a table in a relational database. Each entity requires a key, which can be an autogenerated numeric key or a custom-defined key.

Next, you will add one or more properties that have names, types, and values. Types include string, date and time, Boolean, and other structured types like arrays. Firestore Native Mode, provides a different data model based on documents and collections. Documents are collections of key-value pairs and collections are sets of documents.

Additional details on loading and querying data in Firestore are in [Chapter 12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml).

#### Bigtable Features

Bigtable is another NoSQL database, but unlike Firestore, it is a wide-column database, not a document database. Wide-column databases, as the name implies, store tables that can have a large number of columns. Not all rows need to use all columns, so in that way it is like Firestore—neither requires a fixed schema to structure the data.

![Snapshot of the Firestore user interface allows you to choose between Native and Datastore modes.](../images/c11f014.png)


[**FIGURE 11.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0014) The Firestore user interface allows you to choose between Native and Datastore modes.

Bigtable is designed for petabyte-scale databases. Both operational databases, like storing IoT data, and analytic processing, like data science applications, can effectively use Bigtable. This database is designed to provide consistent, low-millisecond latency. Bigtable runs in clusters and scales horizontally.

Bigtable is designed for applications with high data volumes and a high-velocity ingest of data. Time series, IoT, and financial applications all fall into this category.

![Snapshot of choosing a storage location](../images/c11f015.png)


[**FIGURE 11.15**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0015) Choosing a storage location

#### Configuring Bigtable

From Cloud Console, navigate to Bigtable and click Create Instance to open the form shown in [Figure 11.16](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#c11-fig-0016).

In this form, you will need to provide an instance name and an instance ID. Next, choose either Production or Development mode. Production clusters have a minimum of three nodes and provide for high availability. Development mode uses low-cost instances without replication or high availability. You will also need to choose either SSD or HDD for persistent disks used by the database.

Bigtable can support multiple clusters. For each cluster you will need to specify a cluster ID, a region and zone location, and the number of nodes in the cluster. The cluster can be replicated to improve availability.

In [Chapter 12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml), we will describe how to load and query data in Bigtable.

![Snapshot of configuration form for Bigtable](../images/c11f016.png)


[**FIGURE 11.16**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c11.xhtml#R_c11-fig-0016) Configuration form for Bigtable


---

### Real World Scenario

### The Need for Multiple Databases

Healthcare organizations and medical facilities store and manage a wide range of data about patients, their treatments, and the outcomes. A patient's medical records include demographic information, such as name, address, age, and so on. Medical records also store detailed information about medical conditions and diagnoses as well as treatment, such as drugs prescribed and procedures performed. This kind of data is highly structured. Transaction support and strong consistency are required. Relational databases, like Cloud SQL, are a good solution for this kind of application.

The medical data stored in transactional, relational databases is valuable for analyzing patterns in treatments and recovery. For example, data scientists could use medical records to identify patterns associated with readmission to the hospital. However, transactional relational databases are not suited for analytics. A better option is to use BigQuery and build a data warehouse with data structured in ways that make it easier to analyze data. Data from the transactional system is extracted, transformed, and loaded into a BigQuery dataset.

---

## Choosing a Storage Solution: Guidelines to Consider

Google Cloud offers multiple storage solutions. As a cloud engineer, you may have to help plan and implement storage solutions for a wide range of applications. The different storage solutions lend themselves to different use cases, and in many enterprise applications, you will find that you need two or more storage products to support the full range of application requirements. Here are several factors to keep in mind when choosing storage solutions:

- **Read and Write Patterns**   Some applications, such as accounting and retail sales applications, read and write data frequently. There are also frequent updates in these applications. They are best served by a storage solution such as Cloud SQL if the data is structured; however, if you need a global database that supports relational read/write operations, then Cloud Spanner is a better choice. If you are writing data at consistently high rates and in large volumes, consider Bigtable. If you are writing files and then downloading them in their entirety, Cloud Storage is a good option.
- **Consistency**   Consistency ensures that a user reading data from the database will get the same data no matter which server in a cluster responds to the request. If you need strong consistency, which is always reading the latest data, then Cloud SQL and Cloud Spanner are good options. Firestore can be configured for strong consistency, but I/O operations will take longer than if a less strict consistency configuration is used. Firestore is a good option if your data is unstructured; otherwise, consider one of the relational databases. NoSQL databases offer at least eventual consistency, which means some replicas may not be in sync for a short period of time. During those periods it is possible to read stale data. If your application can tolerate that, then you may find that less strict consistency requirements can lead to faster read and write operations.
- **Transaction Support**   If you need to perform atomic transactions in your application, use a database that supports them. You may be able to implement transaction support in your application, but that code can be difficult to develop and maintain. The relational databases, Cloud SQL and Spanner, and Firestore provide transaction support.
- **Cost**   The cost of using a particular storage system will depend on the amount of data stored, the amount of data retrieved or scanned, and per-unit charges of the storage system. If you are using a storage service in which you provision VMs, you will have to account for that cost as well.
- **Latency**   Latency is the time between the start of an operation, like a request to read a row of data from a database, to the time it completes. Bigtable provides consistently low-millisecond operations. Spanner can have longer latencies, but with those longer latencies you get a globally consistent, scalable database.

In general, choosing a data store is about making trade-offs. In an ideal world, we could have a low-cost, globally scalable, low-latency, strongly consistent database. We don't live in an ideal world. We have to give up one or more of those characteristics.

In the next chapter, you will learn how to use each of the storage solutions described here, with an emphasis on loading and querying data.

## Summary

When planning cloud storage, consider the types of storage systems and types of data models. The storage systems provide the hardware and basic organizational structure used for storing data. The data models organize data into logical structures that determine how data is stored and queried within a database.

The main storage systems available in Google Cloud are Memorystore, a managed cache service, and persistent disks, which are network-accessible disks for VMs in Compute Engine and Kubernetes Engine. Cloud Storage is Google Cloud's object storage system.

The primary data models are object, relational, and NoSQL. NoSQL databases in Google Cloud are further subdivided into document and wide-column databases. Cloud Storage uses an object data model. Cloud SQL and Cloud Spanner use relational databases for transaction processing applications. BigQuery uses a relational model for data warehouse and analytic applications. Firestore is a document database. Bigtable is a wide-column table.

When choosing data storage systems, consider read and write patterns, consistency requirements, transaction support, cost, and latency.

## Exam Essentials

- **Know the major storage system types, including caches, persistent disks, and object storage.**   Caches are used to improve application performance by reducing the need to read from databases on disk. Caches are limited by the amount of available memory. Persistent disks are network devices that are attached to VMs. Persistent disks may be attached to multiple VMs in read-only mode. Object storage is used for storing files for shared access and long-term storage.
- **Know the major kinds of data models.**   Relational databases are used for transaction processing systems that require transaction support and strong consistency. Cloud SQL and Cloud Spanner are relational databases used for transaction processing applications. BigQuery uses an analytical model but is designed for data warehouses and analytics. The object model is an alternative to a filesystem model. Objects, stored as files, are treated as atomic units. NoSQL data models include document data models and wide-column models. Firestore is a document database. Bigtable is a wide-column database.
- **Know the various classes in Cloud Storage.**   Standard, nearline, coldline, and archive are the four storage classes. Standard is designed for data that is accessed frequently (more than once per month) or only stored in Cloud Storage for a short time. Nearline is designed for infrequent access, less than once per month. Coldline storage is designed for long-term storage, with files being accessed less than once per 90 days. Archive storage is designed for data that is not accessed more frequently than once per year. Nearline, Coldline, and Archive storage incur retrieval charges in addition to charges based on the size of the data.
- **Know that cloud applications may require more than one kind of data store.**   For example, an application may need a cache to reduce latency when querying data in Cloud SQL, object storage for the long-term storage of data files, and BigQuery for data warehousing reporting and analysis.
- **Know that you can apply lifecycle configurations on Cloud Storage buckets.**   Lifecycles are used to delete files and change storage class. Standard class objects can be changed to Nearline, Coldline, or Archive. Nearline storage can change to Coldline and Archive. Coldline can be changed to Archive.
- **Know the characteristics of different data stores that help you determine which is the best option for your requirements.**   Read and write patterns, consistency requirements, transaction support, cost, and latency are often factors.

## Review Questions

You can find the answers in the Appendix.

1. You are tasked with defining life cycle configurations on buckets in Cloud Storage. You need to consider all possible options for transitioning from one storage class to another. All of the following transitions are allowed except for which one?
   1. Nearline to Coldline
   2. Coldline to Archive
   3. Standard to Nearline
   4. Archive to Standard
2. Your manager has asked for your help in reducing Cloud Storage charges. You know that some of the files stored in Cloud Storage are rarely accessed more than once every 90 days. What kind of storage would you recommend for those files?
   1. Nearline
   2. Standard
   3. Coldline
   4. Archive
3. You are working with a startup developing analytics software for IoT data. You need to ingest large volumes of data consistently and store it for several months. The startup has several applications that will need to query this data. Volumes are expected to grow to petabyte volumes. Which database should you use?
   1. Cloud Spanner
   2. Bigtable
   3. BigQuery
   4. Firestore
4. A software developer on your team is asking for your help improving the query performance of a database application. The developer is using a Cloud SQL MySQL database and is willing to modify some parts of the application but wants to continue to use a relational database. Which options would you recommend?
   1. Memorystore and SSD persistent disks
   2. Memorystore and HDD persistent disks
   3. Firestore and SSD persistent disks
   4. Firestore and HDD persistent disks
5. You are creating a set of persistent disks to store data for exploratory data analysis. The disks will be mounted on a virtual machine in the us-west2-a zone. The data is historical data retrieved from Cloud Storage. The data analysts do not need peak performance and are more concerned about cost than performance. The data will be stored in a local relational database. Which type of storage would you recommend?
   1. SSDs
   2. HDDs
   3. Firestore
   4. Bigtable
6. Which of the following statements about Cloud Storage is not true?
   1. Cloud Storage buckets can have retention periods.
   2. Lifecycle configurations can be used to change storage class from Archive to Standard.
   3. Cloud Storage does not provide block-level access to data within files stored in buckets.
   4. Cloud Storage is designed for high durability.
7. When using versioning on a bucket, what is the latest version of the object called?
   1. Live version
   2. Top version
   3. Active version
   4. Safe version
8. A product manager has asked for your advice on which database services might be options for a new application. Transactions and support for tabular data are important. Ideally, the database would support common query tools. What databases would you recommend the product manager consider?
   1. BigQuery and Spanner
   2. Cloud SQL and Spanner
   3. Cloud SQL and Bigtable
   4. Bigtable and Spanner
9. The Cloud SQL service provides fully managed relational databases. What two types of databases are available in Cloud SQL?
   1. Oracle and MySQL
   2. Oracle and PostgreSQL
   3. PostgreSQL and MySQL
   4. MySQL and DB2
10. Which of the following Cloud Spanner configurations would have the highest hourly cost?
    1. Located in us-central1
    2. Located in nam3
    3. Located in us-west1-a
    4. Located in nam-eur-asia1
11. Which of the following are database services that do not require you to specify configuration information for VMs?
    1. BigQuery only
    2. Firestore only
    3. Bigtable only
    4. BigQuery and Firestore
12. What kind of data model is used by Firestore?
    1. Relational
    2. Document
    3. Wide-column
    4. Graph
13. You have been tasked with creating a data warehouse for your company. It must support tens of petabytes of data and use SQL for a query language. Which managed database service would you choose?
    1. BigQuery
    2. Bigtable
    3. Cloud SQL
    4. IBM DB2
14. A team of mobile developers is developing a new application. It will require synchronizing data between mobile devices and a back-end database. Which database service would you recommend?
    1. BigQuery
    2. Firestore
    3. Spanner
    4. Bigtable
15. A product manager is considering a new set of features for an application that will require additional storage. What features of storage would you suggest the product manager consider?
    1. Read and write patterns only.
    2. Cost only.
    3. Consistency and cost only.
    4. They are all relevant considerations.
16. What is the maximum size of a Memorystore cache when using Redis?
    1. 100 GB
    2. 300 GB
    3. 400 GB
    4. 50 GB
17. Once a bucket has its storage class set to Archive, what are other storage classes it can transition to?
    1. Standard
    2. Nearline
    3. Coldline
    4. None of the above
18. Before you can start storing data in BigQuery, what must you create?
    1. A dataset
    2. A bucket
    3. A persistent disk
    4. An entity
19. What features can you configure when running a MySQL database in Cloud SQL?
    1. Machine type
    2. Maintenance windows
    3. Failover replicas
    4. All of the above
20. A colleague is wondering why some storage charges are so high. They explain that they have moved all their storage to Nearline and Coldline storage and then costs increased. They routinely access most of the objects on any given day. What is one possible reason the storage costs are higher than expected?
    1. Nearline and Coldline incur access charges.
    2. Transfer charges are involved.
    3. Egress charges are involved.
    4. None of the above.