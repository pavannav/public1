The Google Cloud Platform is a diverse and growing set of services. To pass the Google Cloud Professional Cloud Architect exam, you will need to understand how to reason about both business requirements and technical requirements. This is not so much a test of knowledge about how to do specific tasks in GCP, such as attaching a persistent disk to a VM instance, which is the type of question you are more likely to get or see on the Google Cloud Associate Cloud Engineer exam. The Google Cloud Professional Architect exam tests your ability to perform high-level design and architecture tasks related to the following:

- Designing applications
- Planning migrations
- Ensuring feasibility of proposed designs
- Optimizing infrastructure
- Building and deploying code
- Managing data lifecycles

You will be tested on your ability to design solutions using a mix of compute, storage, networking, and managed services. The design must satisfy both business and technical requirements. If you find a question that seems to have two correct technical answers, look closely at the business requirements. There is likely a business consideration that will make one of the options a better choice than the other. For example, you might have a question about implementing a stream processing system, and the options include a solution based on Apache Flink running in Compute Engine and a solution using Cloud Dataflow. If the business requirements indicate a preference for managed services, then the Cloud Dataflow option is a better choice.

You will be tested on how to plan the execution of work required to implement a cloud solution. Migrations to the cloud are often done in stages. Consider the advantages of starting with low-risk migration tasks, such as setting up a test environment in the cloud before moving production workloads to GCP.

The business and technical requirements may leave you open to proposing two or more different solutions. In these cases, consider the feasibility of the implementation. Will it be scalable and reliable? Even if GCP services have high SLOs, your system may depend on a third-party service that may go down. If that happens, what is the impact on your workflow? Should you plan to buffer work in a Cloud Pub/Sub queue rather than sending it directly to the third-party service? Also consider costs and optimizations, but only after you have a technically viable solution that meets business requirements. As computer science pioneer Donald Knuth realized, “The real problem is that programmers have spent far too much time worrying about efficiency in the wrong places and at the wrong times; premature optimization is the root of all evil (or at least most of it) in programming.”1 The same can be said for architecture as well—meet business and technical requirements before trying to optimize.

The exam guide states that architects should be familiar with the software development lifecycle and agile practices. These will be important to know when answering questions about developing and releasing code, especially how to release code into production environments without shutting down the service. It is important to understand topics such as Blue/Green deployments, canary deployments, and continuous integration/continuous delivery.

In this context, managing is largely about security and monitoring. Architects will need to understand authentication and authorization in GCP. The IAM service is used across GCP, and it should be well understood before attempting the exam. Cloud Monitoring and Cloud Logging are the key services for monitoring and logging in GCP.

---

### How Is the Professional Cloud Architect Exam Different from the Associate Cloud Engineer Exam?

There is some overlap between the Professional Cloud Architect and Associate Cloud Engineer exams. Both exams test for an understanding of technical requirements and the ability to build, deploy, and manage cloud resources. In addition, the Professional Cloud Architect exam tests the ability to work with business requirements to design, plan, and optimize cloud solutions.

The questions on the Professional Cloud Architect exam are based on the kinds of work cloud architects do on a day-to-day basis. This includes deciding which of several storage options is best, designing a network to meet industry regulations, or understanding the implications of horizontally scaling a database.

The questions on the Associate Cloud Engineer exam are based on the tasks that cloud engineers perform, such as creating instance groups, assigning roles to identities, or monitoring a set of VMs. The engineering exam is more likely to have detailed questions about `gcloud`, `gsutil`, and `bq` commands. Architects need to be familiar with these commands and their function, but a detailed knowledge of command options and syntax is not frequently needed on the Professional Cloud Architect exam.

This book is designed to help you pass the Professional Cloud Architect certification exam. If you'd like additional preparation, review the *Official Google Cloud Certified Associate Cloud Engineer Study Guide* (Sybex, 2019).

---

## What Does This Book Cover?

This book covers the topics outlined in the Professional Cloud Architect exam guide available here:

`cloud.google.com/certification/guides/professional-cloud-architect`

- [**Chapter 1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871057/c01.xhtml)**: Introduction to the Google Professional Cloud Architect Exam**  This chapter outlines the exam objectives, scope of the exam, and case studies used in the exam. One of the most challenging parts of the exam for many architects is mapping business requirements to technical requirements. This chapter discusses strategies for culling technical requirements and constraints from statements about nontechnical business requirements. The chapter also discusses the need to understand functional requirements around computing, storage, and networking as well as nonfunctional characteristics of services, such as availability and scalability.
- [**Chapter 2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871057/c02.xhtml)**: Designing Solutions to Meet Business Requirements**  This chapter reviews several key areas where business requirements are important to understand, including business use cases and product strategies, application design and cost considerations, systems integration and data management, compliance and regulations, security, and success measures.
- [**Chapter 3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871057/c03.xhtml)**: Designing Solutions to Meet Technical Requirements**  This chapter discusses ways to ensure high availability in compute, storage, and applications. It also reviews ways to ensure scalability in compute, storage, and network resources. The chapter also introduces reliability engineering.
- [**Chapter 4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871057/c04.xhtml)**: Designing Compute Systems**  This chapter discusses Compute Engine, App Engine, Kubernetes Engine, Anthos, and Cloud Functions. Topics in this chapter include use cases, configuration, management, and design. Other topics include managing state in distributed systems, data flows and pipelines, and data integrity. Monitoring and alerting are also discussed.
- [**Chapter 5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871057/c05.xhtml)**: Designing Storage Systems**  This chapter focuses on storage and database systems. Storage systems include object storage, network-attached storage, and caching. Several databases are reviewed, including Cloud SQL, Cloud Spanner, BigQuery, Cloud Firestore, and Bigtable. It is important to know how to choose among storage and database options when making architectural choices. Other topics include provisioning, data retention and lifecycle management, and network latency.
- [**Chapter 6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871057/c06.xhtml)**: Designing Networks**  This chapter reviews VPCs, including subnets and IP addressing, hybrid cloud networking, VPNs, peering, Shared VPCs, and direct connections. This chapter also includes a discussion of regional and global load balancing. Hybrid cloud computing and networking topics are important concepts for the exam.
- [**Chapter 7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871057/c07.xhtml)**: Designing for Security and Legal Compliance**  This chapter discusses IAM, data security including encryption at rest and encryption in transit, key management, security evaluation, penetration testing, auditing, and security design principles. Major regulations and ITIL are reviewed.
- [**Chapter 8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871057/c08.xhtml)**: Designing for Reliability**  This chapter begins with a discussion of Cloud Operations (formerly Stackdriver) for monitoring, logging, and alerting. Next, the chapter reviews continuous deployment and continuous integration. Systems reliability engineering is discussed, including overloads, cascading failures, and testing for reliability. Incident management and post-mortem analysis are also described.
- [**Chapter 9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871057/c09.xhtml)**: Analyzing and Defining Technical Processes**  This chapter focuses on software development lifecycle planning. This includes troubleshooting, testing and validation, business continuity, and disaster recovery.
- [**Chapter 10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871057/c10.xhtml)**: Analyzing and Defining Business Processes**  This chapter includes several business-oriented skills including stakeholder management, change management, team skill management, customer success management, and cost management.
- [**Chapter 11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871057/c11.xhtml)**: Development and Operations**  This chapter reviews application development methodologies, API best practices, and testing frameworks, including load, unit, and integration testing. The chapter also discusses data and systems migration tooling. The chapter concludes with a brief review of using Cloud SDK and programmatically working with GCP.
- [**Chapter 12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871057/c12.xhtml)**: Migration Planning**  This chapter describes how to plan for a cloud migration. Steps include integrating with existing systems, migrating systems and data, license mapping, network management and planning, as well as testing and developing proof-of-concept systems.

Like all exams, the Professional Cloud Architect certification from Google is updated periodically and may eventually be retired or replaced. At some point after Google no longer offers this exam, the old editions of our books and online tools will be retired. If you have purchased this book after the exam was retired, or are attempting to register in the Sybex online learning environment after the exam was retired, please know that we make no guarantees that this exam’s online Sybex tools will be available once the exam is no longer available.

## Interactive Online Learning Environment and Test Bank

Studying the material in the *Google Cloud Certified Professional Cloud Architect Study Guide* is an important part of preparing for the Professional Cloud Architect certification exam, but we also provide additional tools to help you prepare. The online Test Bank will help you understand the types of questions that will appear on the certification exam.

The sample tests in the Test Bank include all the questions in each chapter as well as the questions from the assessment test. In addition, there are two practice exams with 50 questions each. You can use these tests to evaluate your understanding and identify areas that may require additional study.

The flashcards in the Test Bank will push the limits of what you should know for the certification exam. There are more than 100 questions that are provided in digital format. Each flashcard has one question and one correct answer.

The online glossary is a searchable list of key terms introduced in this exam guide that you should know for the Professional Cloud Architect certification exam.

Go to `www.wiley.com/go/sybextestprep` to register and gain access to this interactive online learning environment and test bank with study tools.

## Additional Resources

People learn in different ways. For some, a book is an ideal way to study, while auditory learners may find audio and video resources a more efficient way to study. A combination of resources may be the best option for many of us. In addition to this study guide, here are some other resources that can help you prepare for the Google Cloud Professional Cloud Architect exam.

- **The Professional Cloud Architect Certification Exam Guide:**

  `cloud.google.com/certification/guides/professional-cloud-architect`
- **Exam FAQs:**

  `cloud.google.com/certification/faqs/#0`
- **Google's Sample Questions:**

  `cloud.google.com/certification/cloud-architect`
- **Google Cloud Platform documentation:**

  `cloud.google.com/docs`
- **Online course Google Cloud Professional Architect: Get Certified by Dan Sullivan**

  `www.udemy.com/course/google-cloud-professional-architect-get-certified`

---

![note](../images/note_24.png) Exam objectives are subject to change at any time without prior notice and at Google's sole discretion. Please visit the Google Professional Cloud Architect website (`cloud.google.com/certification/cloud-architect`) for the most current listing of exam objectives.

---

## Objective Map

| Objective | Chapter |
| --- | --- |
| **Section 1: Designing and planning a cloud solution architecture** |  |
| 1.1 Designing a solution infrastructure that meets business requirements | 1, 2 |
| 1.2 Designing a solution infrastructure that meets technical requirements | 2, 3 |
| 1.3 Designing network, storage, and compute resources | 4 |
| 1.4 Creating a migration plan (i.e., documents and architectural diagrams) | 12 |
| 1.5 Envisioning future solution improvements | 2 |
| **Section 2: Managing and provisioning solutions infrastructure** |  |
| 2.1 Configuring network topologies | 6 |
| 2.2 Configuring individual storage systems | 5 |
| 2.3 Configuring compute systems | 4 |
| **Section 3: Designing for security and compliance** |  |
| 3.1 Designing for security | 7 |
| 3.2 Designing for compliance | 7 |
| **Section 4: Analyzing and optimizing technical and business processes** |  |
| 4.1 Analyzing and defining technical processes | 9 |
| 4.2 Analyzing and defining business processes | 10 |
| 4.3 Developing procedures to ensure reliability of solutions in production (e.g., chaos engineering, penetration testing) | 8 |
| **Section 5: Managing implementation** |  |
| 5.1 Advising development/operations team(s) to ensure successful deployment of the solution | 11 |
| 5.2 Interacting with Google Cloud programmatically | 11 |
| **Section 6: Ensuring solutions and operations reliability** |  |
| 6.1 Monitoring/logging/profiling/alerting solution | 8 |
| 6.2 Deployment and release management | 8 |
| 6.3 Assisting with support of deployed solutions | 8 |
| 6.4 Evaluating quality control measures | 8 |

## Assessment Test

1. Building for Builders LLC manufactures equipment used in residential and commercial building. Each of its 500,000 pieces of equipment in use around the globe has IoT devices collecting data about the state of equipment. The IoT data is streamed from each device every 10 seconds. On average, 10 KB of data is sent in each message. The data will be used for predictive maintenance and product development. The company would like to use a managed service in Google Cloud. What would you recommend?
   1. Apache Cassandra
   2. Cloud Bigtable
   3. BigQuery
   4. Cloud SQL
2. You have developed a web application that is becoming widely used. The front end runs in Google App Engine and scales automatically. The backend runs on Compute Engine in a managed instance group. You have set the maximum number of instances in the backend managed instance group to five. You do not want to increase the maximum size of the managed instance group or change the VM instance type, but there are times the front end sends more data than the backend can keep up with and data is lost. What can you do to prevent the loss of data?
   1. Use an unmanaged instance group.
   2. Store ingested data in Cloud Storage.
   3. Have the front end write data to a Cloud Pub/Sub topic, and have the backend read from that topic.
   4. Store ingested data in BigQuery.
3. You are setting up a cloud project and want to assign members of your team different roles that have appropriate permissions for their responsibilities. What GCP service would you use to do that?
   1. Cloud Identity
   2. Identity and Access Management (IAM)
   3. Cloud Authorizations
   4. LDAP
4. You would like to run a custom stateless container in a managed Google Cloud service. What are your three options?
   1. App Engine Standard, Cloud Run, and Kubernetes Engine
   2. App Engine Flexible, Cloud Run, and Kubernetes Engine
   3. Compute Engine, Cloud Functions, and Kubernetes Engine
   4. Cloud Functions, Cloud Run, and App Engine Flexible
5. PhotosForYouToday prints photographs and ships them to customers. The front-end application uploads photos to Cloud Storage. Currently, the back end runs a cron job that checks Cloud Storage buckets every 10 minutes for new photos. The product manager would like to process the photos as soon as they are uploaded. What would you use to cause processing to start when a photo file is saved to Cloud Storage?
   1. A Cloud Function
   2. An App Engine Flexible application
   3. A Kubernetes pod
   4. A cron job that checks the bucket more frequently
6. The chief financial officer of your company believes that you are spending too much money to run an on-premises data warehouse and wants to migrate to a managed cloud solution. What GCP service would you recommend for implementing a new data warehouse in GCP?
   1. Compute Engine
   2. BigQuery
   3. Cloud Dataproc
   4. Cloud Bigtable
7. A government regulation requires you to keep certain financial data for seven years. You are not likely to ever retrieve the data, and you are only keeping it to comply with regulations. There are approximately 500 TB of financial data for each year that you are required to save. What is the most cost-effective way to store this data?
   1. Cloud Storage multiregional storage
   2. Cloud Storage Nearline storage
   3. Cloud Storage Archive storage
   4. Cloud Storage persistent disk storage
8. Global Games Enterprises Inc. is expanding from North America to Europe. Some of the games offered by the company collect personal information. With what additional regulation will the company need to comply when it expands into the European market?
   1. HIPAA
   2. PCI-DSS
   3. GDPR
   4. SOX
9. Your team is developing a Tier 1 application for your company. The application will depend on a PostgreSQL database. Team members do not have much experience with PostgreSQL and want to implement the database in a way that minimizes their administrative responsibilities for the database. What managed service would you recommend?
   1. Cloud SQL
   2. Cloud Dataproc
   3. Cloud Bigtable
   4. Cloud PostgreSQL
10. What is a service-level indicator?
    1. A metric collected to indicate how well a service-level objective is being met
    2. A type of log
    3. A type of notification sent to a sysadmin when an alert is triggered
    4. A visualization displayed when a VM instance is down
11. Developers at MakeYouFashionable have adopted agile development methodologies. Which tool might they use to support CI/CD?
    1. Google Docs
    2. Jenkins
    3. Apache Cassandra
    4. Clojure
12. You have a backlog of audio files that need to be processed using a custom application. The files are stored in Cloud Storage. If the files were processed continuously on three n2-standard-4 instances, the job could complete in two days. You have 30 days to deliver the processed files, after which they will be sent to a client and deleted from your systems. You would like to minimize the cost of processing. What might you do to help keep costs down?
    1. Store the files in Coldline storage.
    2. Store the processed files in multiregional storage.
    3. Store the processed files in Cloud CDN.
    4. Use preemptible VMs.
13. You have joined a startup selling supplies to visual artists. One element of the company's strategy is to foster a social network of artists and art buyers. The company will provide e-commerce services for artists and earn revenue by charging a fee for each transaction. You have been asked to collect more detailed business requirements. What might you expect as an additional business requirement?
    1. The ability to ingest streaming data
    2. A recommendation system to match buyers to artists
    3. Compliance with SOX regulations
    4. Natural language processing of large volumes of text
14. You work for a manufacturer of specialty die cast parts for the aerospace industry. The company has built a reputation as the leader in high-quality, specialty die cast parts, but recently the number of parts returned for poor quality is increasing. Detailed data about the manufacturing process is collected throughout every stage of manufacturing. To date, the data has been collected and stored but not analyzed. There is a total of 20 TB of data. The company has a team of analysts familiar with spreadsheets and SQL. What service might you recommend for conducting preliminary analysis of the data?
    1. Compute Engine
    2. Kubernetes Engine
    3. BigQuery
    4. Cloud Functions
15. A client of yours wants to run an application in a highly secure environment. They want to use instances that will only run boot components verified by digital signatures. What would you recommend they use in Google Cloud?
    1. Preemptible VMs
    2. Managed instance groups
    3. Cloud Functions
    4. Shielded VMs
16. You have installed the Google Cloud SDK. You would now like to work on transferring files to Cloud Storage. What command-line utility would you use?
    1. `bq`
    2. `gsutil`
    3. `cbt`
    4. `gcloud`
17. Kubernetes pods sometimes need access to persistent storage. Pods are ephemeral—they may shut down for reasons not in control of the application running in the pod. What mechanism does Kubernetes use to decouple pods from persistent storage?
    1. PersistentVolumes
    2. Deployments
    3. ReplicaSets
    4. Ingress
18. An application that you support has been missing service-level objectives, especially around database query response times. You have reviewed monitoring data and determined that a large number of database read operations is putting unexpected load on the system. The database uses PostgreSQL, and it is running in Compute Engine. You have tuned SQL queries, and the performance is still not meeting objectives. Of the following options, which would you try next?
    1. Migrate to a NoSQL database.
    2. Move the database to Cloud SQL.
    3. Use read replicas.
    4. Move some of the data out of the database to Cloud Storage.
19. You are running a complicated stream processing operation using Apache Beam. You want to start using a managed service. What GCP service would you use?
    1. Cloud Dataprep
    2. Cloud Dataproc
    3. Cloud Dataflow
    4. Cloud Identity
20. Your team has had several incidents in which Tier 1 and Tier 2 services were down for more than one hour. After conducting a few retrospective analyses of the incidents, you have determined that you could identify the causes of incidents faster if you had a centralized log repository. What GCP service could you use for this?
    1. Cloud Logging
    2. Cloud Monitoring
    3. Cloud SQL
    4. Cloud Trace
21. A Global 2000 company has hired you as a consultant to help architect a new logistics system. The system will track the location of parts as they are shipped between company facilities in Europe, Africa, South America, and Australia. Anytime a user queries the database, they must receive accurate and up-to-date information; specifically, the database must support strong consistency. Users from any facility may query the database using SQL. What GCP service would you recommend?
    1. Cloud SQL
    2. BigQuery
    3. Cloud Spanner
    4. Cloud Dataflow
22. A database architect for a game developer has determined that a NoSQL document database is the best option for storing players’ possessions. What GCP service would you recommend?
    1. Cloud Firestore
    2. Cloud Storage
    3. Cloud Dataproc
    4. Cloud Bigtable
23. A major news agency is seeing increasing readership across the globe. The CTO is concerned that long page-load times will decrease readership. What might the news agency try to reduce the page-load time of readers around the globe?
    1. Regional Cloud Storage
    2. Cloud CDN
    3. Fewer firewall rules
    4. Virtual private network
24. What networking mechanism allows different VPC networks to communicate using private IP address space, as defined in RFC 1918?
    1. ReplicaSets
    2. Custom subnets
    3. VPC network peering
    4. Firewall rules
25. You have been tasked with setting up disaster recovery infrastructure in the cloud that will be used if the on-premises data center is not available. What network topology would you use for a disaster recovery environment?
    1. Meshed topology
    2. Mirrored topology
    3. Gated egress topology
    4. Gated ingress topology

## Answers to the Assessment Test

  

1. B. Option B is correct. Bigtable is the best option for streaming IoT data, since it supports low-latency writes and is designed to scale to support petabytes of data.

   Option A is incorrect because Apache Cassandra is not a managed database in GCP. Option C is incorrect because BigQuery is a data warehouse. While it is a good option for analyzing large volumes of data, Bigtable is a better option for ingesting the data. Option D is incorrect. CloudSQL is a managed relational database. The use case does not require a relational database, and Bigtable's scalability is a better fit with the requirements.
2. C. The correct answer is C. A Cloud Pub/Sub topic would decouple the front end and backend, provide a managed and scalable message queue, and store ingested data until the backend can process it.

   Option A is incorrect. Switching to an unmanaged instance group will mean that the instance group cannot autoscale. Option B is incorrect. You could store ingested data in Cloud Storage, but it would not be as performant as the Cloud Pub/Sub solution. Option D is incorrect because BigQuery is a data warehouse and not designed for this use case.
3. B. The correct answer is B. IAM is used to manage roles and permissions.

   Option A is incorrect. Cloud Identity is a service for creating and managing identities. Option C is incorrect. There is no GCP service with that name at this time. Option D is incorrect. LDAP is not a GCP service.
4. B. The correct answer is B. You can run custom stateless containers in App Engine Flexible, Cloud Run, and Kubernetes Engine.

   Option A is incorrect because App Engine Standard does not support custom containers. Option C is incorrect because Compute Engine is not a managed service and Cloud Functions does not support custom containers. Option D is incorrect because Cloud Functions does not support custom containers.
5. A. The correct answer is A. A Cloud Function can respond to a create file event in Cloud Storage and start processing when the file is created.

   Option B is incorrect because an App Engine Flexible application cannot directly respond to a Cloud Storage write event. Option C is incorrect. Kubernetes pods are the smallest compute unit in Kubernetes and are not designed to directly respond to Cloud Storage events. Option D is incorrect because it does not guarantee that photos will be processed as soon as they are created.
6. B. The correct answer is B. BigQuery is a managed analytics database designed to support data warehouses and similar use cases.

   Option A is incorrect. Compute Engine is not a managed service. Option C is incorrect. Cloud Dataproc is a managed Hadoop and Spark service. Option D is incorrect. Bigtable is a NoSQL database well suited for large-volume, low-latency writes and limited ranges of queries. It is not suitable for the kind of ad hoc querying commonly done with data warehouses.
7. C. The correct answer is C. Cloud Storage Archive is the lowest-cost option, and it is designed for data that is accessed less than once per year.

   Options A and B are incorrect because they cost more than Archive storage. Option D is incorrect because there is no such service.
8. C. The correct answer is C. The GDPR is a European Union directive protecting the personal information of EU citizens.

   Option A is incorrect. HIPAA is a US healthcare regulation. Option B is incorrect. PCI-DS is a payment card data security regulation; if Global Games Enterprises Inc. is accepting payment cards in North America, it is already subject to that regulation. Option D is a US regulation on some publicly traded companies; the company may be subject to that regulation already, and expanding to Europe will not change its status.
9. A. The correct answer is A. Cloud SQL is a managed database service that supports PostgreSQL.

   Option B is incorrect. Cloud Dataproc is a managed Hadoop and Spark service. Option C is incorrect. Cloud Bigtable is a NoSQL database. Option D is incorrect. There is no service called Cloud PostgreSQL in GCP at this time.
10. A. The correct answer is A. A service-level indicator is a metric used to measure how well a service is meeting its objectives.

    Options B and C are incorrect. It is not a type of log or a type of notification. Option D is incorrect. A service-level indicator is not a visualization, although the same metrics may be used to drive the display of a visualization.
11. B. The correct answer is B. Jenkins is a popular CI/CD tool. Option A is incorrect. Google Docs is a collaboration tool for creating and sharing documents. Option C is incorrect. Cassandra is a NoSQL database. Option D is incorrect. Clojure is a Lisp-like programming language that runs on the Java virtual machine (JVM).
12. D. The correct answer is D. Use preemptible VMs, which cost significantly less than standard VMs. Option A is incorrect. Coldline storage is not appropriate for files that are actively used. Option B is incorrect. Storing files in multiregional storage will cost more than regional storage, and there is no indication from the requirements that they should be stored multiregionally. Option C is incorrect. There is no indication that the processed files need to be distributed to a global user base.
13. B. The correct answer is B. This is an e-commerce site matching sellers and buyers, so a system that recommends artists to buyers can help increase sales.

    Option A is incorrect. There is no indication of any need for streaming data. Option C is incorrect. This is a startup, and it is not likely subject to SOX regulations. Option D is incorrect. There is no indication of a need to process large volumes of text.
14. C. The correct answer is C. BigQuery is an analytics database that supports SQL.

    Options A and B are incorrect because although they could be used to run analytics applications, such as Apache Hadoop or Apache Spark, it would require more administrative overhead. Also, the team members working on this are analysts, but there is no indication that they have the skills or desire to manage analytics platforms. Option D is incorrect. Cloud Functions is for running short programs in response to events in GCP.
15. D. The correct answer is D. Shielded VMs include secure boot, which only runs digitally verified boot components.

    Option A is incorrect. Preemptible VMs are interruptible instances, but they cost less than standard VMs. Option B is incorrect. Managed instance groups are sets of identical VMs that are managed as a single entity. Option C is incorrect. Cloud Functions is a managed service for running programs in response to events in GCP.
16. B. The correct answer is B. `gsutil` is the command-line utility for working with Cloud Storage.

    Option A is incorrect. `bq` is the command-line utility for working with BigQuery. Option C is incorrect. `cbt` is the command-line utility for working with Cloud Bigtable. Option D is incorrect. `gcloud` is used to work with most GCP services but not Cloud Storage.
17. A. The correct answer is A. PersistentVolumes is Kubernetes' way of representing storage allocated or provisioned for use by a pod.

    Option B is incorrect. Deployments are a type of controller consisting of pods running the same version of an application. Option C is incorrect. A ReplicaSet is a controller that manages the number of pods running in a deployment. Option D is incorrect. An Ingress is an object that controls external access to services running in a Kubernetes cluster.
18. C. The correct answer is C. Use read replicas to reduce the number of reads against the primary persistent storage system that is supporting both reads and writes.

    Option A is incorrect. The application is designed to work with a relational database, and there is no indication that a NoSQL database is a better option overall. Option B is incorrect. Simply moving the database to a managed service will not change the number of read operations, which is the cause of the poor performance. Option D is incorrect. Moving data to Cloud Storage will not reduce the number of reads, and Cloud Storage does not support SQL.
19. C. The correct answer is C. Cloud Dataflow is an implementation of the Apache Beam stream processing framework. Cloud Dataflow is a fully managed service.

    Option A is incorrect. Cloud Dataprep is used to prepare data for analysis. Option B is incorrect. Cloud Dataproc is a managed Hadoop and Spark service. Option D is incorrect. Cloud Identity is an authentication service.
20. A. The correct answer is A. Cloud Logging is a centralized logging service.

    Option B is incorrect. Cloud Monitoring collects and manages performance metrics. Option C is incorrect. Cloud SQL is used for regional, relational databases. Option D is incorrect. Cloud Trace is a service for distributed tracing of application performance.
21. C. The correct answer is C. Cloud Spanner is a globally scalable, strongly consistent relational database that can be queried using SQL.

    Option A is incorrect because it will not scale to the global scale as Cloud Spanner will. Option B is incorrect. The requirements describe an application that will likely have frequent updates and transactions. BigQuery is designed for analytics and data warehousing. Option D is incorrect. Cloud Dataflow is a stream and batch processing service.
22. A. The correct answer is A. Cloud Firestore is a managed document NoSQL database in GCP.

    Option B is incorrect. Cloud Storage is an object storage system, not a document NoSQL database. Option C is incorrect. Cloud Dataproc is a managed Hadoop and Spark service. Option D is incorrect. Cloud Bigtable is a wide-column NoSQL database, not a document database.
23. B. The correct answer is B. Cloud CDN is GCP's content delivery network, which distributes static content globally.

    Option A is incorrect. Reading from regional storage can still have long latencies for readers outside of the region. Option C is incorrect. Firewall rules do not impact latency in any discernible way. Option D is incorrect because VPNs are used to link on-premises networks to Google Cloud.
24. C. The correct answer is C. VPC peering allows different VPCs to communicate using private networks.

    Option A is incorrect. ReplicaSets are used in Kubernetes; they are not related to VPCs. Option B is incorrect. Custom subnets define network address ranges for regions. Option D is incorrect. Firewall rules control the flow of network traffic.
25. B. The correct answer is B. With a mirrored topology, the public cloud and private on-premises environments mirror each other.

    Option A is incorrect. In a mesh topology, all systems in the cloud and private networks can communicate with each other. Option C is incorrect. In a gated egress topology, on-premises service APIs are made available to applications running in the cloud without exposing them to the public Internet. Option D is incorrect. In a gated ingress topology, cloud service APIs are made available to applications running on-premises without exposing them to the public Internet.