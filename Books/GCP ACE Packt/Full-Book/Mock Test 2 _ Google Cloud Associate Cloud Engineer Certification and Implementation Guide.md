# Mock Test 2

# Questions

Answer the following questions to test your knowledge of this chapter:

1. Your team of developers received their own Google Cloud project to use as their sandbox environment. You would like to be notified if any developers exceed $1,000 per month of their Google Cloud spending. What should you do?
   1. Set up individual billing accounts for each developer and manually check their monthly spending.
   2. Ask the developers to report their monthly Google Cloud spending to you.
   3. Set up a budget alert in Google Cloud that notifies you if any individual developer exceeds $1,000 per month of their Google Cloud spending.
   4. Monitor the spending every quarter and meet with the developers to discuss their usage.
2. Employees in a single physical location use your internal facing application exclusively. It requires strong consistency, fast queries, and multi-table ACID transactional updates. It is based on PostgreSQL, and you received a requirement to deploy it in Google Cloud with minimal code changes. Which database solution is most suitable for this?
   1. Google Cloud Spanner
   2. Google Cloud SQL for PostgreSQL
   3. Google Cloud Firestore
   4. Google Cloud Bigtable
3. Which Google Cloud product is best suited to storing sensor data from construction equipment with high data throughput, consistent time-based data retrieval, and atomic storing and retrieving signals?
   1. Google Cloud Spanner
   2. Google Cloud SQL for PostgreSQL
   3. Google Cloud Storage
   4. Google Cloud Bigtable
4. Which of the following Google Cloud Compute Engine features can prevent the accidental deletion of a VM?
   1. **Deletion protection**: This feature prevents a VM from being deleted unless the user explicitly confirms the deletion.
   2. **Snapshots**: Snapshots are point-in-time copies of a VM. They can be used to restore a VM to a previous state if it is accidentally deleted.
   3. **Backups**: Backups are copies of a VM that are stored off-site. They can be used to restore a VM to a previous state if it is accidentally deleted or if the underlying hardware fails.
   4. **IAM permissions**: IAM permissions can be used to control who has access to delete a VM. This can help to prevent accidental deletions by unauthorized users.
5. What is the first step to take when preparing to create a Google Cloud Spanner instance for a new project that will be used to deploy a globally distributed application?
   1. Set up a Cloud Storage bucket to store backups.
   2. Install the Cloud Spanner client libraries on your local machine.
   3. Configure a firewall to allow access to the Cloud Spanner instance.
   4. Create a Google Cloud Spanner instance configuration and select a multi-region or regional instance.
6. When configuring a VPC firewall for an application, how should you limit data egress to the fewest open ports?
   1. Set up a default deny egress rule, and then create allow rules only for necessary ports and destinations.
   2. Configure an allowlist of allowed egress IP addresses and ports.
   3. Use a proxy server to restrict outbound traffic to approved destinations.
   4. Use Cloud Audit Logging to monitor egress traffic and block any suspicious activity.
7. Which steps should you take to ensure that future CLI commands, by default, address the specific GKE cluster named **development**?
   1. Run the following command – **gcloud config set** **container/cluster development**.
   2. Run the following command – **gcloud config** **set cluster/development**.
   3. Run the following command – **gcloud config** **set container/development**.
   4. Run the following command – **gcloud config** **set development/cluster**.
8. Which of the following options would be the best approach to reducing the cost of running a fault-tolerant batch workload that runs every night on many **VMs** in Google Cloud Platform?
   1. Reducing the size of the VMs to reduce the cost.
   2. Using preemptible or spot VMs to reduce cost.
   3. Using standard persistent disks instead of SSD persistent disks.
   4. Using larger VMs to handle the workload more efficiently.
9. Your company operates in a strongly regulated environment. An auditor wants to review who accessed data in Cloud Storage buckets. Which options to audit access data in Google Cloud Storage buckets would you choose?
   1. Using Cloud Asset Inventory to view access logs for Cloud Storage buckets.
   2. Enabling Cloud Audit Logs for Cloud Storage buckets to view activity logs.
   3. Using the Export Logs API.
   4. Using Cloud Storage reports to view the access logs for Cloud Storage buckets.
10. Which of the following options would you use to investigate whether a former employee accessed sensitive customer information in Google Cloud after leaving the company?
    1. Using Cloud Audit Logs to view the access history of the former employee’s Google Cloud account.
    2. Using Google Cloud DLP to scan for sensitive information in the Google Cloud projects and storage buckets accessed by the former employee.
    3. Using Google Cloud’s operations suite to view the former employee’s activity logs in Google Cloud.
    4. Using Cloud Identity and Access Management to check the former employee’s access to Google Cloud and revoke it if necessary.
11. Which command can grant a user the **editor** role for a specific Google Cloud project using the **gcloud** command-line tool?
    1. **gcloud** **projects add-iam-policy-binding**
    2. **gcloud iam** **roles create**
    3. **gcloud iam** **service-accounts create**
    4. **gcloud compute** **firewall-rules create**
12. Which statement about Google Cloud VPN in **high availability** (**HA**) mode is correct?
    1. Google Cloud VPN in HA mode is designed to provide HA by replicating VPN gateways across multiple regions.
    2. Google Cloud VPN in HA mode is only available for use with Google Cloud Compute Engine instances.
    3. Google Cloud VPN in HA mode is not recommended for production use, as it can cause connectivity issues.
    4. Google Cloud VPN in HA mode is a paid service that requires a separate subscription.
13. Imagine that you have an application hosted on a bare-metal server situated in your data center, which needs access to cloud storage. However, your security policies prevent the servers that host the application from having public IP addresses or accessing the internet. In such a case, you must abide by Google’s recommended guidelines to facilitate the application’s access to cloud storage. What actions should you take?
    1. Use the **nslookup** or **dig** command to get the IP address of **storage.googleapis.com**. Negotiate with the security team to provide public IP addresses to bare-metal servers. Allow only egress traffic from bare-metal servers to the IP addresses of **storage.googleapis.com**.
    2. Use Cloud VPN or Cloud Interconnect to create a tunnel to your VPC in Google Cloud. Use Cloud Router to create a custom route advertisement for **199.36.153.4/30** and **2600:2d00:0002:1000::/64**. Announce that network to your on-premises network through the VPN tunnel. In your on-premises network, configure the DNS server to resolve **\*.googleapis.com** as a CNAME to **restricted.googleapis.com**.
    3. Use Migrate for Compute Engine to migrate bare-metal servers to Compute Engine. Create an internal Load Balancer that uses **storage.google.com** as a backend. Configure new Compute Engine instances to use Internal Load Balancer as proxy.
    4. Use Cloud VPN, and create a VPN tunnel to your VPC in Google Cloud. In the VPC, create Compute Engine with a Squid proxy. Configure your server to use the Squid proxy to access Cloud Storage.
14. What steps should be performed as a prerequisite before creating a new Compute Engine instance using the CLI, and after creating a new project in Google Cloud with the **gcloud** command-line tool and linking a billing account to the project?
    1. Set the default project using the **gcloud config set project [****PROJECT\_ID]** command.
    2. Enable the Compute Engine API for the project using the **gcloud services enable** **compute.googleapis.com** command.
    3. Install the Google Cloud SDK on the machine where the CLI will be run.
    4. Create a new service account with the necessary permissions to create Compute Engine instances.
15. What is the command to create a new Kubernetes Engine cluster in Google Cloud using the **gcloud** CLI?
    1. **gcloud kubernetes** **clusters create**
    2. **gcloud compute** **instances create**
    3. **gcloud container** **clusters create**
    4. **gcloud compute** **kubernetes create**
16. What steps can be taken to automate the installation of Jenkins for efficient and streamlined application building and deployment from source code during the development of a new application?
    1. Create an instance template with Jenkins already installed. Create a managed instance group from the template.
    2. Create a new Kubernetes Engine cluster and create a deployment from the Jenkins image.
    3. Create a new Compute Engine instance and install Jenkins manually.
    4. Deploy Jenkins from Google Cloud Marketplace.
17. What steps should you take to deploy additional pods that require **n2-highmem-32** nodes on GKE, without causing any downtime, given that your existing application already runs on multiple pods across eight GKE **n2-standard-8** nodes?
    1. Create a new GKE cluster with **n2-highmem-32** nodes and redeploy the pods. After that, delete the old cluster.
    2. Use the **gcloud container clusters upgrade** command and deploy new pods.
    3. Create a new cluster with both n2-highmem-32 and **n2-standard-8** nodes. Redeploy the pods and delete the old cluster.
    4. Create a new node pool, specify the machine type as n2-highmem-32, and deploy the new pods.
18. What steps must you take to deploy a Docker image of your application as a workload on GKE?
    1. Upload the image to Cloud Storage and create a GKE service, referencing the image.
    2. Upload the image to Cloud Storage and create a GKE deployment, referencing the image.
    3. Upload the image to Artifact Registry and create a GKE deployment, referencing the image.
    4. Upload the image to Container Registry and create a Kubernetes Service, referencing the image.
19. Which programming languages are supported by Google Cloud Functions?
    1. Java
    2. Python
    3. Ruby
    4. All of the preceding.
20. Which of the following statements is true about Google Cloud Functions?
    1. It allows developers to write and deploy code without worrying about server infrastructure.
    2. It is only compatible with Google Cloud Platform services.
    3. It requires developers to manage their servers and infrastructure.
    4. It is a platform to manage cloud storage and data processing.
21. What **database management systems** (**DBMs**) can be hosted on Google Cloud SQL?
    1. Only MySQL
    2. Only PostgreSQL
    3. Only Microsoft SQL Server
    4. MySQL, PostgreSQL, and Microsoft SQL Server
22. What is the main benefit of using Shared VPC in Google Cloud?
    1. It allows you to share VMs between multiple projects.
    2. It allows you to share billing information between multiple projects.
    3. It allows you to share VPC networks and subnets between multiple projects.
    4. It allows you to share IAM roles and permissions between multiple projects.
23. What is the main difference between Google Cloud Internal Load Balancer and Google Cloud HTTPS Load Balancer?
    1. Google Cloud Internal Load Balancer is used for internal traffic within a VPC, while Google Cloud HTTPS Load Balancer is used for external traffic over the internet.
    2. Google Cloud Internal Load Balancer supports only HTTP traffic, while Google Cloud HTTPS Load Balancer supports both HTTP and HTTPS traffic.
    3. Google Cloud Internal Load Balancer is a software-based load balancer, while Google Cloud HTTPS Load Balancer is a hardware-based load balancer.
    4. Google Cloud Internal Load Balancer is a Layer 4 load balancer, while Google Cloud HTTPS Load Balancer is a Layer 7 load balancer.
24. What is the main difference between jobs and services in Google Cloud Run?
    1. Jobs are used for short-lived tasks, while services are used for long-running applications.
    2. Jobs are used for batch processing, while services are used for real-time applications.
    3. Jobs are used for background tasks, while services are used for frontend tasks.
    4. Jobs and services are the same things in Google Cloud Run.
25. You have been tasked with the life cycle configuration of the Google Cloud Storage bucket. The life cycle rule should change the object’s class from Standard to Coldline. Choose the correct rule in JSON format:
    1. **{**

**"****rule": [**

**{**

**"****action": {**

**"****storageClass": "COLDLINE",**

**"****type": "SetStorageClass"**

**},**

**"****condition": {**

**"****age": 30**

**}**

**}**

**]**

1. **{**

**"****rule": [**

**{**

**"****action": {**

**"****storageClass": "NEARLINE",**

**"****type": "SetStorageClass"**

**},**

**"****condition": {**

**"****age": 60**

**}**

**}**

**]**

**}**

1. **{**

**"****rulesToSet": [**

**{**

**{**

**"****storageClass": "COLDLINE",**

**"****type": "SetStorageClass"**

**},**

**"****condition": {**

**"****age": 30**

**}**

**}**

**]**

**}**

1. **{**

**"****rule": [**

**{**

**"****execute": {**

**" SetStorageClass ": "****COLDLINE",**

**"****type": "StorageClass"**

**},**

**"****condition": {**

**"age":**

**}**

**}**

**]**

**}**

1. You have been tasked with uploading many files from an on-premises fileserver into a Google Cloud Storage bucket. You want to leverage a parallel multithreaded copy mechanism. Choose the correct **gsutil** command:
   1. **gsutil cp -r -M** **dir gs://my-bucket**
   2. **gcloud -m cp -r** **dir gs://my-bucket**
   3. **gsutil cp -r** **dir gs://my-bucket**
   4. **gsutil -m cp -r** **dir gs://my-bucket**
2. You are planning the migration of 200 VMs running on VMware vSphere from on-premises, with a total size of 280 GiB of data. Your internet provider agreed to increase the speed of your internet connection to 1 Gbps. What is the fastest way to migrate the VMs to Google Cloud?
   1. Use the **gsutil** command-line utility with the **-****m** option.
   2. Use the Migrate to VMs service to migrate directly into Google Compute Engine.
   3. Order Transfer Appliance TA300, and copy all the VMVM files onto it. Once data is uploaded to the Cloud Storage bucket, use the **gcloud compute images import my-imported-image --source-file** **gs://your\_gcs\_bucket/my\_server.vmdk** command.
   4. Convert VMware VMs into the RAW format and upload them to the Cloud Storage bucket. Use the **gcloud compute images import my-imported-image --source-file** **gs://your\_gcs\_bucket/my\_server.raw** command.
3. An application owner has informed you that app performance is degraded. After checking the application performance metrics in Cloud Monitoring, the bottleneck has been identified – the PostgreSQL database. Cloud Monitoring points to insufficient CPU capacity and slow read performance from the database. What steps can be taken to improve the performance of the PostgreSQL database? (Select four correct answers):
   1. Increase the CPU capacity of the database instance.
   2. Add more memory to the database instance.
   3. Optimize the database schema and indexes.
   4. Use a different database management system.
   5. Create read replicas to offload read queries from the primary instance.
4. As an operations team member, you have been tasked with creating a notification channel in Google Cloud’s operations suite. What are the valid options for delivering notifications?
   1. Email, mobile app, SMS, and Pub/Sub
   2. Email, mobile app, Pub/Sub, and Webhooks
   3. Email, PagerDuty, and SMS
   4. Email, mobile app, PagerDuty, SMS, Slack, Webhooks, and Pub/Sub
5. Choose correct identities where IAM roles can be granted:
   1. A Google account and a Service account
   2. A Google group and a Cloud Identity domain
   3. A Google account, a service account, a Google group, a Google Workspace domain, and a Cloud Identity domain
   4. A Google Workspace domain and a Cloud Identity domain
6. Which of the following options is a way to provide a group of data scientists with access to a 10-GB dataset acquired from a third-party research firm, minimizing the steps they will have to take to access it from their statistics programs written in R, while also giving each scientist their dedicated VM with the data available in the VM’s filesystem?
   1. Load the dataset into BigQuery.
   2. Use Cloud Storage to store the dataset.
   3. Use a disk with the data to create a source image, and then create VMs from the source image.
   4. Store the dataset in Google Drive.
7. Which command can be used to create a VPC?
   1. **gcloud compute** **create networks**
   2. **gcloud compute** **networks create**
   3. **gsutil networks** **vpc create**
   4. **kubectl compute** **networks create**
   5. **gcloud vpc** **networks create**
8. After a successful proof of concept with Google Cloud, you have been tasked with creating a production Cloud SQL database. As a precaution, you want to enable deletion protection on your production Cloud SQL database. Which command can be used to perform this task?
   1. **gcloud sql instances create** **INSTANCE\_NAME --deletion-protection**
   2. **gcloud compute sql create instances** **INSTANCE\_NAME --deletion-protection**
   3. **gsutil compute sql instances create** **INSTANCE\_NAME --no-delete**
   4. **gcloud sql instances patch [****INSTANCE\_NAME] --no-deletion-protection**
9. Which roles are necessary to check quotas for a project?
   1. Project Owner (roles/owner), Project Editor (roles/editor), and Quota Viewer (**roles/servicemanagement.quotaViewer**)
   2. Project Owner (**roles/owner**)
   3. Quota Viewer (**roles/servicemanagement.quotaViewer**)
   4. Quota Administrator (**roles/servicemanagement.quotaAdmin**)
   5. Project Owner (**roles/owner**) and Quota Administrator (**roles/servicemanagement.quotaAdmin**)
   6. All of the preceding
10. What are the options for batch-loading data into BigQuery?
    1. Avro
    2. CSV and JSON
    3. ORC
    4. PHP
    5. AVRO, CSV, JSON, and ORC
11. Which of the following is an appropriate use case for Google Dataflow?
    1. Running a web server and serving HTTP requests
    2. Generating interactive visualizations of large datasets
    3. Processing streaming data in real time
    4. Storing and querying data in a distributed data warehouse
12. Choose the correct statement about Google Cloud VPCs and CIDR ranges:
    1. You can create one CIDR range for each VPC.
    2. You can create a CIDR range for each subnet.
    3. You can create a CIDR range for each region.
    4. You can create a CIDR range for each zone.
13. You want to implement an infrastructure-as-code approach regarding infrastructure deployment in your company. Terraform was brought to your attention, and you would like to try it out. Which order of Terraform command(s) allows you to deploy your code successfully?
    1. **terraform create**
    2. **terraform apply,** **terraform init**
    3. **terraform init, terraform plan,** **terraform apply**
    4. **terraform configure, terraform apply,** **terraform init**
14. Before migration to Google Cloud, your developer’s team used RabbitMQ as a message broker. After successfully migrating all applications, you want to use cloud-native technologies. Choose the correct product that will allow you to use messaging services in Google Cloud.
    1. Dataflow
    2. Dataproc
    3. Pub/Sub
    4. BigQuery
15. You are considering using managed instance groups in Compute Engine, configured with an autoscaling policy. What are valid autoscaling policy metrics?
    1. The average CPU utilization
    2. An HTTP load-balancing serving capacity
    3. Cloud Monitoring metrics
    4. All of the preceding
16. What are potential use cases for Google Cloud Functions? (Select two correct answers):
    1. Triggering real-time data processing tasks
    2. Building and deploying web applications
    3. Automating infrastructure management tasks
    4. Running long-term, resource-intensive computations
17. Which of the following are features of Google Cloud Spanner? (Select two correct answers):
    1. It is a NoSQL database that allows for flexible schema designs.
    2. It is a fully managed relational database service.
    3. It provides strong consistency and HA across multiple regions.
    4. It is designed for low-latency, high-throughput workloads.
18. You have been asked to create a firewall rule to allow TCP traffic destined for VM1, with the IP **192.168.1.2** on port **80**. Choose the correct command to perform this task:
    1. **gcloud compute firewall-rules create firewall-rule-1 --network NETWORK\_NAME --action deny --direction egress --rules tcp --destination-ranges 192.168.1.2/32 --****priority 1000**
    2. **gcloud compute firewall-rules create firewall-rule-1 --network NETWORK\_NAME --action allow --direction egress --rules tcp:80 --destination-ranges 192.168.1.2/32 --****priority 60**
    3. **gcloud compute firewall-rules create firewall-rule-1 --network NETWORK\_NAME --action allow --direction egress --rules tcp:443 --destination-ranges 192.168.1.2/32 --priority 70 --****target-tags webserver**
    4. **gcloud compute firewall-rules firewall-rule-1 --network NETWORK\_NAME --action allow --direction ingress --rules tcp:22 --source-tags database --priority 80 --****target-tags webserver**
    5. **gcloud compute firewall-rules firewall-rule-1--network NETWORK\_NAME --action deny --direction egress --rules tcp --destination-ranges 192.168.1.2/32 --****priority 1000**
19. Choose the correct statement about Google Cloud Dataproc. (Select two correct answers):
    1. Dataproc is managed by Apache Spark and the RabbitMQ service.
    2. Dataproc supports Windows Server and Ubuntu images.
    3. Dataproc allows you to run it on Google Compute Engine or Kubernetes Engine.
    4. Dataproc on Google Kubernetes Engine doesn’t have separate master and worker nodes.
    5. Dataproc is billed on a per-minute basis.
20. You would like to analyze logs stored in Cloud Logging in external systems. What are the valid external sink destinations?
    1. A Cloud Logging bucket
    2. A BigQuery dataset
    3. A Cloud Pub/Sub topic
    4. Splunk
    5. All of the preceding
21. What are the three types of roles in Google Cloud IAM? (Select three correct answers):
    1. Basic roles
    2. Special roles
    3. Admin roles
    4. Custom roles
22. What is true about a VPC created in auto mode? (Select two correct answers):
    1. When an auto-mode VPC network is created, one subnet from each region is automatically created within it.
    2. Those automatically created subnets use a set of predefined IPv4 ranges that fit within the **10.128.0.0/9** CIDR block.
    3. When new Google Cloud regions become available, you have to create new subnets in those regions manually.
    4. You cannot add more subnets manually to VPC networks in auto mode.
23. Which of the following statements about the type of applications deployed on Kubernetes are true?
    1. A ReplicaSet ensures that a specified number of pod replicas run at any given time.
    2. A Deployment provides declarative updates for pod replicas and allows for rollbacks if necessary.
    3. A StatefulSet is used to manage stateful applications that require stable network identities and ordered deployment and scaling.
    4. A DaemonSet ensures that a pod runs on every node in a cluster.
    5. All of the preceding.
24. What types of service accounts are available in Google Cloud IAM? (Select more than two correct answers):
    1. User-managed service accounts
    2. Default service accounts
    3. Google-managed service accounts
    4. Service-specific service agents
    5. None of the preceding
25. What statements about Kubernetes Services are true regarding exposing a containerized application outside a GKE cluster? (Select two correct answers):
    1. A Service can expose a containerized application to the internet using a static IP address and a LoadBalancer type.
    2. A Service can only expose a containerized application to other applications running inside the GKE cluster.
    3. A Service can expose a containerized application to the internet using an Ingress resource.
    4. A Service cannot expose a containerized application outside a GKE cluster.

# Answers

The answers to the preceding questions are provided here:

1C, 2B, 3D, 4A, 5D, 6A, 7A, 8B, 9B, 10A, 11A, 12A, 13B, 14A, 15C, 16D, 17D, 18C, 19D, 20A, 21D, 22C, 23A, 24A, 25A, 26D, 27C, 28A, B, C, and E, 29D, 30C, 31C, 32B, 33A, 34A, 35E, 36C, 37B, 38C, 39C, 40D, 41A and C, 42B and C, 43B, 44C and D, 45E, 46A, B, and D, 47A and B, 48E, 49A, B, C, and D, 50A and C

If you liked reading *Google Cloud Associate Cloud Engineer Certification and Implementation Guide*, you can join its dedicated GitHub repository to ask questions about the topics covered in it, or just to stay up to date with the latest changes. The repository is located at <https://github.com/PacktPublishing/Google-Cloud-Associate-Cloud-Engineer-Certification-and-Implementation-Guide>.

![Figure 14.1 – The QR code for the GitHub repository](../images/B18851_14_01.jpg)

Figure 14.1 – The QR code for the GitHub repository

You can also join the book’s Slack channel if you want to interact with the authors and other readers. The channel is located at [bit.ly/ace-gcp-book-slack](http://bit.ly/ace-gcp-book-slack).

![Figure 14.2 – The QR code for the Slack channel](../images/B18851_14_02.jpg)

Figure 14.2 – The QR code for the Slack channel