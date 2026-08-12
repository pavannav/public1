# Mock Test 1

# Questions

Answer these questions to practice for the exam:

1. You want to use Google Cloud free credits to explore Google Cloud’s services and prepare for your ACE exam. You plan to stay within the limits of the free tier whenever possible so that you won’t run out of credits too soon. However, you are asked to provide a payment method during the free trial signup. Why do you think this happened?
   1. It was a mistake. There is no need to provide credit card details because you will receive $300 in credits from Google. You need to contact the support team.
   2. Google will transfer $300 to your bank account, so you need to share your credit card details during the signup process.
   3. Providing payment details is required for the billing account setup, regardless of whether you plan to use a paid account or free credits. This is also how your identity is verified. You will need to monitor your spending because you will be charged once you run out of free credits.
   4. Providing payment details is required for the billing account setup, regardless of whether you plan to use a paid account or free credits. This is also how your identity is verified. You won’t be charged, even if you run out of free credits. You need to explicitly upgrade your account to a paid account for Google to be able to charge you.
2. The CFO has just informed you that the company has decided to switch banks, and as a result, a new billing account must be configured and attached to all existing and new Google Cloud projects. She is asking you, the administrator of the resources, whether this can be achieved without downtime for production workloads and what happens to all pending charges. What applies here?
   1. Changing a billing account for a project shouldn’t impact running services. You can attach a new active billing account to a project at any time by going to the **My Project** page of the **Billing** section. Pending charges will be billed to the former billing account, and all new charges will be billed to a new billing account.
   2. Changing a billing account for a project shouldn’t impact running services. You can attach a new active billing account to a project at any time by going to the **My Project** page of the **Billing** section. Pending and new charges will be billed to a new billing account.
   3. Changing a billing account for a project causes downtime to all running services. Therefore, you need to schedule a maintenance window to switch the billing accounts on the **My Project** page of the **Billing** section. Pending charges will be billed to the former billing account, and all new charges will be billed to a new billing account.
   4. Changing a billing account for a project causes downtime to all running services. You need to schedule a maintenance window to switch the billing accounts on the **My Project** page of the **Billing** section. Pending and new charges will be billed to a new billing account.
3. Your team is preparing to migrate their on-premises workloads to Google Cloud. However, it is worried about the bill and anticipate that it might be higher than they initially calculated. What can you recommend to them to better control its cloud spending?
   1. They should monitor their projects’ total and forecasted monthly costs in billing account reports to ensure only necessary services are generating costs.
   2. They should create a budget for the cloud billing account that includes all their services in all their projects and set a fixed monthly budget amount and alert thresholds. If their spending exceeds one of these thresholds, billing admins will receive an email notification. No resources will be stopped. Also, they will still be able to create new workloads.
   3. They should create a budget for the cloud billing account that includes all their services in all their projects and set a fixed monthly budget amount. If their spending exceeds the target amount, they won’t be able to create new workloads.
   4. They should set a limit on the company’s credit card so that they won’t be charged more than the allowed amount.
4. What mechanism prevents users from creating unlimited resources for a specific service type while keeping existing workloads unaffected?
   1. Quotas
   2. Disabling APIs
   3. Cloud billing budgets
   4. Limits on a credit card used by cloud billing
5. After installing some patches for the operating system in a Compute Engine VM, you noticed the application running on the VM stopped working. After lengthy troubleshooting, you decide to rebuild the VM and reinstall the application on a clean operating system. The problem is that the new VM was assigned a different private IP, and users cannot access the application. How can you fix this issue?
   1. You must reserve the initial internal IP as the static IP address in this VPC. Then, you shut down the VM, edit the network interface, select the reserved address, and start the VM.
   2. Private IP addresses are automatically assigned. You can’t assign a private IP manually by selecting the one you need. Instead, users need to change the IP that they are using to a new one. You must send an email to all users that share a new IP address.
   3. You must reserve the initial internal IP as the static IP address in this VPC. Then, you must recreate the VM one more time, this time, selecting the reserved address for a network interface.
   4. You must shut down the VM, edit the network interface, change the IP to the initial one, and start the VM.
6. You have to run a batch job and have a limited budget for this task. To save costs, you are considering creating a managed instance group with VMs in a spot provisioning model. But first, you need to verify that your script handles the preemption correctly. How can you achieve this?
   1. You can use spot VMs in a managed instance group and use **gcloud compute instances simulate-maintenance-event** on VMs to test the unexpected termination.
   2. You can’t use spot VMs in a managed instance group.
   3. You can use spot VMs in a managed instance group, but no mechanism is available to help simulate the unexpected termination.
   4. You can only use preemptive VMs in a managed instance group, but no mechanism is available to help simulate the unexpected termination.
7. You want to run a daily backup to prevent Compute Engine VM data from being accidentally deleted. Which option should you choose?
   1. Scheduling **gcloud compute images create** to run daily so that a new VM image will be created every day.
   2. Scheduling **gcloud compute instance-templates create** to run daily so that a new VM instance template will be created every day
   3. Use the Google Cloud console to create a VM similar to an existing one via the **CREATE SIMILAR** option in the **VM** **instances** view
   4. Create a daily snapshot schedule for the disks attached to the VM
8. Your organization has two teams: team 1 creates the frontends, while team 2 creates backends for applications. The teams often share projects and always use the same billing account. How can the finance department calculate the organization’s spending on frontend and backend resources separately?
   1. By using filters in the **Cost breakdown** section of the **Billing** view. Each team can select the services it uses each month and share the report with the finance department.
   2. By using folders. Each team should keep its workloads in a dedicated folder in every project. The finance department can verify spending by filtering the cost per folder in the **Cost breakdown** section of the **Billing** view.
   3. By using labels. The teams should label their resources as **team:team-1** or **team:team-2**. Billing data should be exported to BigQuery for analysis. Queries that return the overall spending for both teams can be exported to Looker Studio and shared with the finance department.
   4. By using tags. The teams should tag their resources as **team-1** or **team-2**. Billing data should be exported to BigQuery for analysis. Queries that return the overall spending tagged as **team-1** and **team-2** can be exported to Looker Studio and shared with the finance department.
9. Which storage volume for a Compute Engine instance is protected against a failure in a zone and provides the best balance of performance and cost?
   1. Regional balanced Persistent Disk volume
   2. Zonal balanced Persistent Disk volume
   3. Regional Cloud Storage bucket
   4. Zonal standard Persistent Disk volume
10. What are the advantages of using a managed instance group?
    1. High availability – it supports multi-zone deployments, scaling based on various metrics, built-in mechanisms for automatically patching instances, and auto-healing, which creates a new instance in case the old one crashes
    2. High availability – it supports multi-zone deployments, built-in mechanisms for automatically patching instances, and auto-healing that reboots instances in case of a crash
    3. High availability – it supports multi-zone deployments, scaling up based on various metrics, built-in mechanisms for automatically patching instances, and auto-healing, which reboots instances in case of a crash
    4. High availability – it supports multi-zone deployments, scaling down based on various metrics, built-in mechanisms for automatically patching instances, and auto-healing, which reboots instances in case of a crash
11. Which instance group type would you choose to set up automatic management for a group of VMs with persistent data?
    1. Managed instance group (stateless)
    2. Managed instance group (stateful)
    3. Unmanaged instance group
    4. All of the above
12. Which compute model should you choose if you want to run a simple event-driven serverless service that processes images right after they are uploaded to Google Cloud Storage? You also don’t want to worry about the execution environment.
    1. Cloud Run
    2. A managed instance group
    3. GKE
    4. Cloud Functions
13. Which compute model should you choose if you want to run a stateless web-based service that scales based on the number of incoming requests and uses no resources when there are no requests? Also, your developers want to use their custom build for this service.
    1. Cloud Functions
    2. Cloud Run
    3. GKE
    4. Kubernetes
14. Which of the following is true about regional GKE clusters?
    1. They can’t be deployed in Autopilot mode
    2. They contain multiple replicas of the control plane, running in multiple zones in a region and nodes in multiple or a single zone
    3. They can be changed to zonal at any time
    4. They have one replica of the control plane running in a selected zone and nodes in multiple zones
15. How can you isolate a GKE cluster so that it can’t be accessed from the internet and at the same time allow outbound internet access for the nodes?
    1. Deploy a public cluster
    2. Deploy a private cluster with **Access control plane using its external IP address** option enabled
    3. Deploy a private cluster and use Cloud NAT for outbound internet traffic
    4. Deploy a private cluster with Private Google Access enabled on a VPC
16. Which sentence about GKE Autopilot is not true?
    1. It can be configured with regional or zonal availability
    2. Resources are provisioned based on workloads
    3. You pay for the resources that are consumed by workloads (per pod)
    4. It’s deployed with a hardened configuration
17. How can you configure Cloud Monitoring and Logging for GKE standard cluster mode?
    1. No configuration is required as Cloud Monitoring and Logging are enabled by default during cluster creation
    2. You need to install the Ops Agent inside the nodes and enable FW rules to allow incoming traffic on ports **20201** and **20202**
    3. You need to install Ops Agent inside the nodes and modify the **config.yaml** file by adding **gke** to the list of monitored systems
    4. Cloud Monitoring and Logging for GKE is supported only for GKE autopilot cluster mode
18. You are writing an application and you want to focus on code, without having to manage infrastructure. That is why you want to use Cloud Functions. But you also want to experiment with some code and send just a subset of traffic to every new revision. How can you achieve this with Cloud Functions?
    1. You must use Cloud Run to split traffic between revisions. This can’t be achieved with Cloud Functions.
    2. Traffic splitting between various versions of your code is a Cloud Functions second-generation feature, so you need to use this version.
    3. Cloud Functions (first- and second-generation) support the traffic-splitting mechanism by default. It doesn’t matter which version you use.
    4. You can configure an HTTP(S) load balancer to distribute traffic between revisions of Cloud Function deployments.
19. Which sentence does not describe Cloud Functions?
    1. It supports languages such as Python, Java, Go, and Node.js
    2. You can trigger Cloud Function execution with HTTP/S requests, Pub/Sub messages, and Cloud Storage changes, such as a new object being created or deleted.
    3. You are billed only for the time your function is executed
    4. It supports network protocols beyond HTTP/S
20. Select the sentence that is not true about Cloud Run.
    1. It runs code in response to events
    2. It runs containers in a fully managed environment
    3. It allows you to use any language and any library
    4. It scales automatically
21. What are the minimum steps required to deploy a Cloud Run service?
    1. Build a container with code that listens to HTTP requests on a predefined port. Then, create a service endpoint and deploy the container by selecting its image and providing a name for a service and a region where it should run. Finally, configure Cloud Logging for the Cloud Run service.
    2. Build a container with code that listens to HTTP requests on a predefined port. Then, create a source repository and upload the image before creating a service endpoint. Finally, deploy the container by selecting its image from the source repository and providing a name for a service.
    3. Build a container with code that listens to HTTP requests on a predefined port, then deploy the container by selecting its image and providing a name for a service and a region where it should run.
    4. Build a container with code that listens to HTTP requests on a predefined port, then deploy the container on a previously created GKE cluster in a selected region.
22. You are an instructor who delivers Associate Cloud Engineer exam preparation courses. Every time a course starts, you must deploy labs for your students. To simplify troubleshooting, all deployments must be the same. After the course, labs need to be destroyed to avoid costs. How can you prepare your labs efficiently?
    1. Use Infrastructure as Code. You can use Google Cloud Platform Provider in Terraform to provision your projects and create resources. Later, you can use **terraform destroy** to remove the provisioned workloads.
    2. You should prepare a deploy script and use Cloud Client Libraries to access the Google Cloud API programmatically to set up your projects. Later, by detaching your billing account from projects, you can ensure resources will be deleted.
    3. Use Infrastructure as Code. You can use Google Cloud Platform Provider in Terraform to provision your projects and create resources. Later, you can delete each project manually to ensure no services are running.
    4. You should prepare a deploy script and use Cloud Client Libraries to access the Google Cloud API programmatically to set up your projects and delete them later.
23. What is a good use case for running Cloud Run on Anthos instead of using a fully managed Cloud Run?
    1. Incorporating Kubernetes’ best practices and creating a better bridge between the Dev and Ops teams
    2. Running a flexible serverless platform to deploy workloads in hybrid and multi-cloud environments
    3. Simplifying the application deployment and management experience for Kubernetes
    4. Ability to scale down to zero
24. Your team is designing a business-critical application that is expected to go from a small to a massive scale. Which managed relational database would you recommend, knowing they need the ability to scale the instance without downtime and require strong consistency?
    1. Cloud SQL
    2. Cloud BigTable
    3. Cloud Firestore
    4. Cloud Spanner
25. While building a truck tracking application for a global logistics company, you look for a scalable, low-latency database to store the GPS position of thousands of vehicles at a given timestamp. Which database should you choose?
    1. Cloud SQL
    2. Cloud BigTable
    3. Cloud Firestore
    4. Cloud Spanner
26. You are designing a serverless system to analyze real-time data streamed by people counting appliances in stores so that your analytics team can better understand consumers’ behavior. What would be the most critical components of such a system?
    1. Real-time data should be streamed to Pub/Sub first so that no event is lost in the case of processing bottlenecks. Then, data should be parsed through Dataflow and sent to BigQuery, where it will be available to the analytics team.
    2. Real-time data should be streamed directly to BigQuery, where it will be available for the analytics team.
    3. Real-time data should be streamed to Pub/Sub first so that no event is lost in the case of processing bottlenecks. Then, data should be parsed through Dataproc and sent to BigQuery, where it will be available for the analytics team.
    4. Real-time data should be streamed to Pub/Sub first so that no event is lost in the case of processing bottlenecks. Then, data should be parsed through Dataproc and sent to BigTable, where it will be available for the analytics team.
27. Which CLI command can be used to create a Google Cloud Storage bucket called **my-awesome-bucket**?
    1. **cbt** **mb my-awesome-bucket**
    2. **bq** **mb gs://my-awesome-bucket**
    3. **gsutil** **mb gs://my-awesome-bucket**
    4. **gcloud buckets** **create gs://my-awesome-bucket**
28. You are working on an application to help studio photographers share session photos with their customers. You have decided to use Google Cloud Storage buckets to store photos, but you are worried that storing a large number of high-resolution images can be expensive. To limit the storage bill, you decided that photos will be available for download for 30 days only. How can you achieve this?
    1. Use Google Cloud SDK in your application’s code to interact with Google Cloud Storage, query the objects’ lifetimes, and delete ones that are older than 30 days.
    2. List bucket details in the Google Cloud console in the Google Cloud Storage view, order objects by date, and delete the oldest every month.
    3. Use the Google Cloud Storage Autoclass feature to automatically detect access patterns and move objects to the Archive storage if they are not accessed for 30 days.
    4. Use Object Lifecycle with **Action** set to **delete** and **Condition** set to **age=30**.
29. Which of the following storage systems would be the best fit for storing users’ home directories?
    1. Google Cloud Storage
    2. Persistent Disk
    3. Filestore
    4. Local Disk
30. You are designing a standalone application that must survive a failure in a Google Cloud region. You decide to create resources in two regions, europe-west3 and europe-central2, and build a replication mechanism between them. Which network design would be the most optimal for this case?
    1. One VPC with a subnet in the europe-west3 and europe-central2 regions
    2. Two VPCs with a subnet in the europe-west3 and europe-central2 regions
    3. One shared VPC with a subnet in the europe-west3 and europe-central2 regions
    4. There is no need to create two redundant subnets since the VPC is a global, highly available service
31. You used Google Cloud SDK in your code to spin up 500 Compute Engine VMs in the same subnet. However, in the Google Cloud console, you noticed that only around half of them were successfully deployed. What could be the reason for this?
    1. Your application ran out of memory
    2. Your subnet was created with a **/24** mask and you used all of the IP addresses
    3. Using Google Cloud SDK is not supported for creating a large number of resources
    4. Your Organization Policy only allows you to create 250 VMs per user
32. How can you provide internet access to a Compute Engine VM with only a private IP assigned?
    1. Internet access will only be available for a VM with a public IP assigned
    2. Use Cloud NAT
    3. You need to add a default route of **0.0.0.0/0** to the internet in the VPC where a VM is running
    4. You need to add a DNS entry of **8.8.8.8** to the VM’s networking configuration
33. Which load balancer type would best fit a globally accessible external non-HTTPS application?
    1. An external network TCP/UDP load balancer
    2. A global external TCP/SSL Proxy
    3. A global external HTTP(S) load balancer
    4. None of them
34. You are connecting your on-premises environment with Google Cloud. However, your on-premises router doesn’t support BGP for exchanging routes. Which option can you choose to connect to Google Cloud?
    1. Dedicated Interconnect
    2. Partner Interconnect
    3. HA VPN
    4. Classic VPN
35. You are working on an application that will be running inside a Compute Engine VM. The application will index files uploaded to a Google Cloud Storage bucket, searching for specific text patterns. How can the application access the bucket?
    1. The service account that is assigned to the VM needs to have Google Cloud Storage access permissions such as Storage Admin for interacting with the bucket
    2. The VM can access the objects in the same project as the bucket if Private Service Access is enabled on a VPC
    3. If a user who creates the VM has the Compute Admin role, the VM will be able to access the objects
    4. The default service account that’s assigned to a VM during deployment has Google Cloud Storage access permissions by default, so the VM can interact with the bucket
36. Starting next year, your company must comply with regulatory requirements to store data in the European Union. How can this be achieved?
    1. By using the **gcloud asset search-all-resources** command to search for assets outside the EU.
    2. By creating VPC subnets only in EU regions. Here, resources can only be created in regions where a subnet exists.
    3. By using an organization policy to limit the regions where resources can be deployed to the EU ones. This will apply to new resources only, so an audit needs to be conducted to identify which existing resources need to be migrated.
    4. By using an organization policy to limit the regions to which resources can be deployed to the EU ones. This will apply to existing and new resources, so it has to be done during a maintenance window to ensure there’s no impact on existing services.
37. You are working as a networking administrator in a global company. Your current assignment is to plan networking for all new Google Cloud projects to simplify its management overhead. However, you want to address the following problem with existing projects: every time Google launches a new region, developers contact you and ask for a subnet in a new region. As a result, you log in to existing projects one by one and manually add a new subnet. How can you simplify this process?
    1. Use a Shared VPC in the custom mode
    2. Use a Shared VPC in auto mode
    3. Use a VPC in custom mode
    4. Use a VPC in auto mode
38. Your organization still uses legacy tools that require service account keys. You must ensure the keys are used only by the entitled tools. Which option will help you to achieve this?
    1. Cloud Logging
    2. Service Account Insights
    3. Cloud Monitoring
    4. Cloud Audit Logs
39. You supervise three teams of developers: team a, team b, and team c. Those teams create and use multiple Google Cloud projects for their workloads. Following Google’s recommendations, how can you ensure you have view access to all of them?
    1. Create a root folder for your teams and add individual folders for each team under the root folder. Ensure team members only have a Project Creator role at their team’s folder level. The Project Viewer role needs to be assigned to you at the root folder level.
    2. The Project Viewer role needs to be assigned to you in every project individually.
    3. The Project Viewer role needs to be assigned to you at the organization level.
    4. Create a root folder for your teams and add individual folders for each team under the root folder. Ensure team members only have a Project Creator role at their team’s folder level. The Project Viewer role needs to be assigned to you at every team’s folder level.
40. Which is not the recommended best practice for providing access to Google Cloud resources?
    1. Attaching IAM roles to groups instead of individual users
    2. Using the principle of least privilege
    3. C. Using Basic roles
    4. Using Predefined roles
41. You deployed an application on a Compute Engine VM, which generates unstructured logs that must be stored for 7 years. After a few weeks, you notice that the log volume it generates is too high to be stored locally on a Persistent Disk. To reduce spending, you decide to send logs to an external system. Which option would be the best fit?
    1. Add functionality to your application’s code to send logs to the Google Cloud Storage archive class bucket. Set Object Lifecycle on the bucket to delete data after 7 years.
    2. Add functionality to your application’s code to send logs to a syslog appliance on-premises, backed by a storage array that can be used for archiving.
    3. No code changes are required. Install Ops Agent, which will collect and process logs and send them to Cloud Logging without additional setup. Create a log sink to send the application logs to a log bucket and set its retention to 7 years.
    4. Add functionality to your application’s code using client libraries to structure and send logs to the Cloud Logging API. Create a log sink to send the application logs to a log bucket and set its retention to 7 years.
42. The security team in your organization contacted you, the application owner, and asked you to troubleshoot their access to Audit Logs for your project. They wanted to examine logs from Google Cloud Storage for object upload and deletion on your buckets. But when they accessed Cloud Logging, they could only see logs related to bucket creation. How can you fix this?
    1. The security team needs a Logging Admin role to be able to see Audit Logs.
    2. You need to enable Data Access Logs for the Google Cloud Storage service. Also, the security team needs to be added to “exempted principals” in the Google Cloud Storage data audit log configuration.
    3. You need to enable Data Access Logs for the Google Cloud Storage service. Also, the security team needs a Private Log Viewer role to be able to see Data Access logs.
    4. The security team needs a Private Log Viewer role to be able to see Admin Activity logs.
43. You want to configure a VPC in a newly created project. What is the first step you need to do to be able to create a VPC?
    1. Enable the Compute Engine API
    2. Go to **VPC Networks**, select **CREATE VPC NETWORK**, and start configuring the VPC
    3. Enable the Cloud Networking API
    4. You don’t need to do anything – the default VPC is ready to use once a new project is created
44. Your team wishes to consolidate the monitoring of all Compute Engine VMs deployed in multiple projects in one place. However, they also want to be able to view VM metrics per individual project. How can they achieve this most effectively?
    1. They should decide which of the existing projects will become a new scoping project and add all existing projects to this one.
    2. They should create a new project dedicated to monitoring and add other projects to the scoping project.
    3. This can only be achieved by exporting metrics to a third-party monitoring tool.
    4. They should decide which of the existing projects will become a new scoping project and add all existing projects to this one. They should use filters and customized charts to monitor VMs for individual projects.
45. How can you create a group that includes both users and service accounts?
    1. In the Google Cloud console, at the organization level, go to the **Groups** section of IAM, create a group, and add all members and their roles.
    2. Log in to the Admin console as a superadmin at [https://admin.google.com](https://admin.google.com/), go to **Directory** | **Group**, create a new group, and add its members. Next, add the group members.
    3. Log in to the Admin console as a superadmin at [https://admin.google.com](https://admin.google.com/), go to **Directory** | **Group**, create a new group, and add its members. Next, add the group members. Finally, log in to the Google Cloud console and verify that the group exists.
    4. You can’t create a group that consists of both users and service accounts.
46. A support team should only be able to view monitoring dashboards without access to other resources in all projects under the **production** folder. What option would follow Google’s recommendation in this scenario?
    1. Create a group for the support team and assign a Project Viewer role to the group at the **production** folder level.
    2. Assign a Project Viewer role to individual users at the **production** folder level.
    3. Create a group for the support team and assign a Project Viewer role to the group at the **production** folder level. In the individual projects, assign the Monitoring Viewer role to the group.
    4. Create a group for the support team and assign a Monitoring Viewer role to the group at the **production** folder level.
47. You accidentally applied the **gcloud projects delete project1** command instead of **gcloud projects delete project2**. How can you revert this action?
    1. **gcloud projects** **undelete project1**
    2. **gcloud projects** **restore project1**
    3. **gcloud projects** **revert project1**
    4. There is no option to undo this action
48. Which method would be the most optimal for creating 15 independent Compute Engine VMs with the same settings?
    1. In the **Compute Engine** view, go to the **VM instances** section and select the **BULK CREATE** **VMs** option
    2. Create an instance template and use a managed instance group to deploy the required number of VMs
    3. Use bulk creation in the CLI – for example, **gcloud compute instances bulk create --name-pattern=vm## --count=15 --zone=europe-central2-a --****network=my-vpc-network --subnet=warsaw-subnet**
    4. Use bulk creation in the CLI – for example, **gcloud compute instances bulk create --predefined-names=vm1,vm2,vm3,vm4,.. --zone=europe-central2-a --****network=my-vpc-network --subnet=warsaw-subnet**
49. In which case is using a Pub/Sub Push subscription type as a delivery mechanism for an application the best option?
    1. When you’re dealing with a large volume of messages
    2. When high message throughput is expected
    3. When Google Cloud credentials can’t be used
    4. When a public HTTPS endpoint with a non-self-signed certificate can’t be used
50. You want to provide internet access to your Compute Engine VMs, which are deployed in two zones – **europe-west3** and **europe-central2** – in the same VPC (**my-vpc**) in a newly created project called **my-project**. Which set of commands should you run?
    1. **gcloud compute routers create router-waw** **--project=my-project --****network=my-vpc --region=europe-central2**

**gcloud compute routers create router-fra --project=my-project --****network=my-vpc --region=europe-west3**

**gcloud compute routers nats create nat-waw --router=router-waw --region=europe-central2 --****auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges**

**gcloud compute routers nats create nat-fra --router=router-fra --region=europe-west3 --****auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges**

1. **gcloud compute routers create router my-router –****project=my-project --network=my-vpc**

**gcloud compute routers nats create nat –router=my-router --****auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges**

1. **gcloud compute routers create router my-router --****project=my-project --network=my-vpc**

**gcloud compute routers nats create nat-waw --router=my-router --region=europe-central2 --****auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges**

**gcloud compute routers nats create nat-fra --router=my-router --region=europe-west3 --****auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges**

1. Compute Engine VMs are always created with a public IP, allowing internet egress with no additional configuration

# Answers

Here are the answers to this mock test’s questions:

1D, 2A, 3B, 4A, 5C, 6A, 7D, 8C, 9A, 10A, 11B, 12D, 13B, 14B, 15C, 16A, 17A, 18B, 19D, 20A, 21C, 22A, 23B, 24D, 25B, 26A, 27C, 28D, 29C, 30A, 31B, 32B, 33B, 34D, 35A, 36C, 37B, 38D, 39A, 40C, 41D, 42C, 43A, 44B, 45A, 46D, 47A, 48C, 49C, 50A

If you liked reading this book, *Google Cloud Associate Cloud Engineer Certification and Implementation Guide*, you can join this book’s dedicated GitHub repository to ask questions about this book, or just to stay up to date on the latest changes. The repository is located at <https://github.com/PacktPublishing/Google-Cloud-Associate-Cloud-Engineer-Certification-and-Implementation-Guide>.

![Figure 13.1 – QR code to this book’s GitHub repository](../images/B18851_13_01.jpg)

Figure 13.1 – QR code to this book’s GitHub repository

You can also join this book’s Slack channel if you want to interact with this book’s authors and other readers. The channel is located at [bit.ly/ace-gcp-book-slack](https://bit.ly/ace-gcp-book-slack).

![Figure 13.2 – QR code to this book’s Slack channel](../images/B18851_13_02.jpg)

Figure 13.2 – QR code to this book’s Slack channel