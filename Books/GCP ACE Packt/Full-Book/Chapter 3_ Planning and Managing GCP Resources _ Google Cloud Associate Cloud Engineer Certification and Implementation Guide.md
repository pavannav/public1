# 3

# Planning and Managing GCP Resources

Welcome to the third chapter. In this chapter, we will focus on planning and managing GCP resources. Our focus lies mainly on planning Google Cloud resources, describing use cases for specific solutions, and learning what the benefits of the different application types are. We will dive into billing and budgets, which are essential in terms of the financial aspect of Google Cloud and a reporting point of view. The last topics covered in this chapter are API and quota management.

We are going to cover the following main topics:

- Planning Google Cloud resources
- Billing and budgets
- API management
- Quota management

# Planning Google Cloud resources

The configuration and implementation of Google Cloud resources is an easy process. You create a project, enable an API, deploy virtual machines (VMs), and complete the task. This process is simple and looks like it is easy to implement. But is it really?

Did you consider all the possible options for your use case? Did you configure your VM or resource optimally? Is your deployment secure?

We could explore these questions in different dimensions and we can end up discussing this for a long time. However, there is a reason we brought them up here. It's because planning is far more important than implementation.

If a cloud deployment is planned and architected well, its implementation and extension are faster, repeatable, easier to maintain, secure, and optimized.

The architecture of Google Cloud isn’t the main topic of the **Associate Cloud Engineer** (**ACE**) certification, but it is important to remember it. Perhaps after passing the ACE exam, you might want to pursue the Professional Cloud Architect exam, and that exam covers the architecting of Google Cloud resources.

The book *Professional Cloud Architect – Google Cloud Certification Guide*, by *Konrad Cłapa and Brian Gerrard*, *Packt Publishing*, is an excellent resource for learning more about Google Cloud architecture and deploying and configuring Google Cloud resources.

Google Cloud has prepared excellent resources for all those interested in planning and configuring.

## Google Cloud setup checklist

The Google Cloud setup checklist is a step-by-step guide for anyone who wants to have scalable, well-architected production and enterprise-ready workloads. It is essential to mention that like identity configuration, role and permission assignment, or resource hierarchy organization, some tasks can be done differently, as every company and environment is different.

The following link covers the initial aspects of the Google Cloud setup checklist – <https://cloud.google.com/docs/enterprise/setup-checklist>. You should be able to see the following list items:

1. Cloud identity and organization
2. Users and groups
3. Administrative access
4. Set up billing
5. Resource hierarchy
6. Access
7. Networking
8. Monitoring and logging
9. Security
10. Support

The checklist consists of various tasks that have step-by-step procedures. Some tasks can be accomplished in multiple ways depending on the desired way to implement them – be it programmatically or in Cloud Console.

Checklists help with following Google Cloud’s best practices but feel free to use them according to your needs.

## Google Cloud’s best practices

Best practices are a set of methods or techniques that have been generally accepted as superior to other alternatives. Best practices are called this because the outcome that is produced by using them is better than those produced by using other methods. A best practice may be a feature of accredited management standards such as ISO 9000 and ISO 14001.

Google Cloud’s best practices are resources that Google has identified and recommends to customers who want to achieve the best possible cloud architecture and follow Google’s recommendations. Google has developed best practices by working with many customers and those repeatable best patterns have helped to ease initial cloud setup and speed up configuration and implementation.

We must ask ourselves one question – *Should I always follow the best practices?* There is no right or wrong answer to this question. Our answer is – *It depends*.

Following the best practices solely because somebody asked us to do so doesn’t make sense. Omitting a set of best practices or implementing only part of it is fine – we just need to make those decisions consciously and know what it means for us when we skip or apply different practices.

If you want to read more about Google Cloud’s best practices, visit the following links:

- <https://cloud.google.com/architecture/framework>
- <https://cloud.google.com/security/best-practices>

In the next section, we will dive into blueprints, which are one of the best ways to implement Google Cloud’s best practices and start the journey with Google Cloud.

## Google Cloud blueprints

We’ve covered the setup checklist and best practices of Google Cloud. All those steps bring us closer to the deployment of Google Cloud in a practical, secure, and well-designed way.

Fortunately for us, Google Cloud has prepared many different methods of implementation for its customers. A Google Cloud implementation blueprint is based on Google Cloud best practices. Again, you don’t need to follow all of them; you can choose parts that make the most sense for you and your organization:

- **Kubernetes Resource Model (KRM) blueprints**: KRM blueprints use **Config Connector**, part of **Anthos Config Management**, which allows us to deploy Google Cloud resources using the KRM. The KRM makes it easy to select resources with YAML or JSON declaratively.

To learn how to implement blueprints using the KRM, visit the following link – <https://cloud.google.com/anthos-config-management/docs/concepts/blueprints#krm-blueprints>.

- **Terraform blueprints**: For those who prefer to use Terraform and want to use **HashiCorp Configuration Language** (**HCL**) to deploy Google Cloud resources, this is also possible. Policies for Terraform blueprints are written as Open Policy Agent constraint templates. Terraform Validator enables client-side policy validation by converting Terraform plans into Cloud Asset Inventory asset metadata, then validates them with OPA policies. This allows the detection of misconfiguration earlier in the deployment pipeline.

To learn how to implement blueprints using Terraform and its HCL language, visit the following link – <https://cloud.google.com/anthos-config-management/docs/concepts/blueprints#terraform-blueprints>.

We continue our journey with Google Cloud. We started with a high-level overview of the best practices and then we moved on to implementation with various blueprints. In the next section, we will jump into planning compute resources.

## Planning compute resources

Google Cloud offers a variety of compute options to choose from. Ultimately, it depends on what kind of workload you will run and what type of control over the resources you or your team require.

The following figure provides an overview of the Google Cloud compute options. The more we move to the right, the more highly managed and less customizable services are. Services on the left-hand side of the figure are highly customizable and less managed by Google Cloud:

![Figure 3.1 – Compute resource options__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_01.jpg)

Figure 3.1 – Compute resource options

One thing to remember – you can mix different types of computing resources according to your needs.

We will now describe all Google Cloud compute options:

- **Google Compute Engine** (**GCE**): VMs are a commodity, and GCE allows you to choose from various predefined T-shirt sizes and create desired VM sizes according to your requirement. You can select different disk options, attach GPUs, and decide which operating system you want to use.
- **Preemptible and spot VMs**: Both preemptible and spot VM instances are highly discounted (from 60% up to 91% compared to regular VMs). The difference between preemptible and spot VMs is their lifetime. Preemptible VMs live for up to 24 hours (preemptible) and spot VMs don’t have a maximum runtime. Google Cloud offers them to all customers, and they have one characteristic in common – they can be terminated with a notification sent 30 seconds prior to the termination. Preemptible instances use excess GCE capacity, so their availability varies across Google Cloud regions. The ideal workload for this type of VM is stateless applications, containerized workloads, web apps, or test and development workloads.
- **Custom VM sizes**: One of the features in GCE we like a lot is the possibility to create custom VM sizes. Google Cloud offers the opportunity to configure VMs according to your needs. Whether you need a powerful VM with many CPUs and you don’t need a lot of RAM, or you want to choose between 1 or 2 vCPUs per core to select a different CPU family type – you are covered.

In the following figure, we can see the process of custom VM creation:

![Figure 3.2 – Custom VM size in GCE__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_02.jpg)

Figure 3.2 – Custom VM size in GCE

Let’s move on to the next set of compute options in Google Cloud:

- **Google Kubernetes Engine (GKE)**: Google Cloud offers managed Kubernetes, which is the best choice for containerized applications that require orchestration, managed scaling, updates, and connectivity. GKE creates Kubernetes master nodes and manages them for end users, as well as allowing node pool creation. Also, autoscaling nodes allow you to monitor resources.
- **Cloud Run**: Cloud Run is a fully managed serverless platform to run containers. In comparison to GKE, you provide your application’s code, and Cloud Run hosts the application and autoscales it according to the workload.
- **Google App Engine**: Google App Engine is a fully managed serverless platform for web applications. App Engine is responsible for the application and database autoscaling and providing networking connectivity. It allows you to update applications on the fly, host different versions, and enable diagnostics.
- **Cloud Functions**: For those who require event-driven serverless functions, Cloud Functions is the best choice. You write code and decide what will happen when the event is triggered, and the rest is done automatically.
- **Firebase**: If you’re building an application that relies on a backend for synchronization and/or storage, Firebase is a great option. It allows you to store complex NoSQL documents and files using an API and client available for iOS, Android, and JavaScript.

We covered planning all the computing options in Google Cloud. We will now focus on planning database resources and choosing the right database for your workload.

## Planning database resources

Similar to compute options, Google Cloud offers a variety of database products in which you can store the data. Each product has its unique features and can support various application options:

- **Cloud SQL**: This is a fully managed MySQL, Microsoft SQL Server, or PostgreSQL database service for traditional workloads such as CRM, ERP, e-commerce, or web applications.
- **BigQuery**: This is a serverless, highly scalable, and cost-effective multi-cloud data warehouse designed for business agility and offers up to 99.99% availability. It’s best to use for multi-cloud and real-time data analysis with built-in, ready-to-use machine learning models.
- **Firestore**: This is a serverless document database with built-in features such as high scalability and high availability (99.999%) that supports ACID transactions against document data. It’s best to use Firestore for mobile, web, or IoT applications with real-time or offline synchronization requirements.
- **Cloud Spanner**: This is a fully managed relational database with global, unlimited-scale, robust data consistency synchronization across regions and continents with up to 99.999% availability. Cloud Spanner customers use it for gaming, global financial ledger, or supply chain/inventory management use cases.
- **Cloud Bigtable**: This is a fully managed NoSQL (non-relational) database service with consistent sub-10 ms latency access, which can handle millions of requests per second and offers up to 99.999% availability. It can process more than 5 billion requests per second at peak and more than 10 exabytes of data under management. The ideal use case for Cloud Bigtable is applications such as personalization, AdTech, recommendation engines, or fraud detection.

This concludes our discussion of the database options in Google Cloud and when you should choose a specific database for your workload. In the next section, we will review options for storing data in Google Cloud.

## Planning data storage options

This section covers various data storage options – object, block, and file storage. Every product and use case is different, and different product selections apply. The most important thing for us to understand is that block storage is required for VMs to be able to install the operating system of choice. In comparison, object storage cannot be used to install operating systems and cannot be used as a boot device for GCE VMs.

Let’s start with storage options for compute in Google Cloud.

### Compute storage options

We have two options to choose from with GCE. We can use either a persistent disk or local **solid-state** **drives** (**SSDs**).

Like other planning considerations for computing or database workloads, choosing the appropriate storage options should be done carefully. We need to identify the desired storage size, performance requirements, and availability.

The Google Cloud storage advisor web page can guide you through different storage options and assess your requirements. The following links will help you to navigate through other storage options:

- <https://cloud.google.com/architecture/storage-advisor#review_the_storage_options>
- <https://cloud.google.com/compute/docs/disks#introduction>
- <https://cloud.google.com/storage/docs/storage-classes#descriptions>

#### Persistent disk

A standard disk is attached to every VM in GCE. Persistent disk offers us a variety of options that can be precisely mapped to our requirements. It is a block device used with every Compute Option VM utilized as a boot device:

- **Zonal persistent disk**: Zonal persistent disks provide durable storage and data location in one zone.
- **Regional persistent disk**: Regional persistent disks have storage qualities that are similar to persistent zonal disks. However, persistent regional disks provide durable storage and data replication between two zones in the same region.
- **Standard persistent disk**: Standard persistent disks (pd-standard) are backed by standard **hard disk** **drives** (**HDDs**).
- **Balanced persistent disk**: Balanced persistent disks (pd-balanced) are backed by SSDs. They are an alternative to SSD persistent disks that balances performance and cost.
- **SSD persistent disk**: SSD persistent disks (pd-ssd) are backed by SSDs and offer high **input/output operations per second** (**IOPS**) and throughput.
- **Extreme persistent disk**: Extreme persistent disks (pd-extreme) are backed by SSDs. Extreme persistent disks are designed for high-end database workloads with consistently high performance for both random access workloads and bulk throughput.

#### Local SSDs

A local SSD is an ephemeral, locally attached form of block storage for VMs and containers. Compared to other block storage options, it offers superior performance, very high IOPS, and very low latency. The typical use cases for local SSDs are flash-optimized databases, hot caching layers for analytics, or application scratch disks.

#### Google Cloud Storage

GCS is ultra-low-cost, highly reliable, and secure object storage with high-speed access speeds where customers can store any amount of data. Object storage cannot be used as a boot disk for GCE VMs. GCS offers multiple types of storage classes.

The following GCS concepts are common in all classes:

- Object: Pieces of data uploaded to GCS.
- Storage class: This is a piece of metadata that is used by every object.
- Bucket: Buckets are the primary containers that store your data. Everything that is stored in GCS must be contained in a bucket.
- Unlimited storage with no minimum object size.
- Worldwide accessibility and worldwide storage locations.
- Low latency (time to the first byte is typically tens of milliseconds).
- High durability (99.999999999% annual durability).
- Geo-redundancy if the data is stored in a multi-region (more than two regions) or dual-region (exactly two regions).
- A uniform experience with GCS features, security, tools, and APIs.

Google Cloud describes in detail and keeps documentation up to date about exact locations of multi-region and dual-region pairs. Visit the following URL to learn more about exact multi-region and dual-region locations: <https://cloud.google.com/storage/docs/locations#available-locations>

Now that we know all the common features in GCS, we need to understand when to use each type of storage and their main features:

- **Standard**: Standard storage is best for frequently accessed data (“hot” data) and stored for brief periods. The ideal use cases for standard storage are “hot” data that’s accessed frequently, including websites, streaming videos, and mobile apps.
- **Nearline**: Nearline storage is low-cost storage. It is suitable for data stored for at least 30 days, including data backup and long-tail multimedia content.
- **Coldline**: Coldline storage is a very low-cost storage option. It is suitable for data that can be stored for at least 90 days, including disaster recovery.
- **Archive**: Archive storage is a good choice for data that can be stored for at least 365 days, including regulatory archives.

With all the options described in this section, we can find the right storage options with the desired functionality and best price range.

## Conclusion

The choice of three storage categories already shows us how complex cloud products can be. In this section, we focused on each product’s main options. We could multiply these selections by various dimensions, and would still be able to find something tailored to us.

# Billing and budgets

A Cloud Billing account is one of the prerequisites for consuming any Google Cloud resource. Without it, we can’t create any VM, utilize the free trial period, or use resources under the Google Cloud Free Tier.

One aspect that might be of interest to those leaning toward the ACE certification is the free trial.

## Free trial

Google Cloud offers a 90-day, $300-worth free trial for every newly created Google Cloud account. Once registered, $300 worth of credits is added to the bill, which can be used with all products. During the free trial period, resources used from the Free Tier do not get charged against your free trial credits:

![Figure 3.3 – First visit to Google Cloud Console as a new user__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_03.jpg)

Figure 3.3 – First visit to Google Cloud Console as a new user

In *Figure 3**.3*, we see the option to activate the free trial. After clicking **TRY FOR FREE**, we need to verify our account. We need to add a mobile phone number, provide some information about ourselves, and add a credit card:

![Figure 3.4 – Step 3 of 3 – payment information verification__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_04.jpg)

Figure 3.4 – Step 3 of 3 – payment information verification

Once we add a credit or debit card and confirm our identity, we are welcomed into the free trial:

![Figure 3.5 – Free trial activation__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_05.jpg)

Figure 3.5 – Free trial activation

After providing some required data, we can finally start using Google Cloud.

### Program eligibility

A free trial program is created under the following conditions:

- You have never been a customer of Google Cloud, Google Maps, or Firebase.
- You have never previously signed up for the free trial.

Let’s review how can we start the free trial program at Google Cloud.

### Program start

The 90-day, $300-worth free trial starts automatically when the sign-up is completed. One prerequisite required to finish it is adding a valid credit card or another acceptable payment method. Other payment methods, which vary per country, are as follows:

- Debit card
- A bank account

Google Cloud provides an extensive list of supported and unsupported payment methods, which might change over time. If you wish to find out which payment methods are supported and unsupported in your country, visit the following URL – <https://cloud.google.com/billing/docs/how-to/payment-methods>.

The following figure shows the possibility of adding a credit or debit card:

![Figure 3.6 – Example of adding a payment method in the Google Cloud portal__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_06.jpg)

Figure 3.6 – Example of adding a payment method in the Google Cloud portal

Please remember that payment options may vary between countries. We are located in Germany, and the following payment options were available for users: credit or debit card and PayPal.

For companies, there is the option to receive invoices, which isn’t [available to private users. To review the payment optio](https://cloud.google.com/billing/docs/how-to/get-invoice)ns for companies, please visit the following link: https://cloud.google.com/billing/docs/how-to/get-invoice.

The payment step is very important for private persons and companies and shouldn’t be underestimated because one small error can lead to a temporary account blockage or suspension.

### Program limitations

Newly created Google Cloud accounts that use a free trial have some limitations, which are temporary and will be removed if you use your account for an extended period of time.

Some initial limitations are as follows:

- You can’t add GPUs to your VM instances.
- You can’t request quota increases
- You can’t create VMs with Windows server-based images.
- You can’t create Google Cloud VMware Engine resources

With the limitations in mind, we will now focus on the program duration and its features.

### Program duration

The free trial program ends when you spend your $300 in credits or 90 days have passed since you signed up.

You can check your Google Cloud expenditure and remaining days in **Billing Overview**:

![Figure 3.7 – Free trial credit status in the Billing Overview section__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_07.jpg)

Figure 3.7 – Free trial credit status in the Billing Overview section

Please note that the initial $300 is converted into the currency used where you reside.

### Upgrading to a paid Cloud Billing account

As you progress with learning about Google Cloud, your free trial might end, or you might have already used all $300 in credit. There might be a case where even if your free trial is not yet finished, you would like to create a Windows-based VM or increase your quotas.

To do so, you need to upgrade to a paid Cloud Billing account. You remove some initial restrictions and ensure that your resources won’t be deleted by upgrading.

![Figure 3.8 – Activation of a complete account__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_08.jpg)

Figure 3.8 – Activation of a complete account

As you can see in the preceding figure, activation is done just by clicking the **ACTIVATE** button.

Once our account is fully activated, we can start using all Google Cloud services. In the next section, we will describe the Google Cloud Free Tier offering.

## Google Cloud Free Tier

Free Tier is an offer from Google Cloud where users can use services for free. One difference between a free trial and Free Tier is that Free Tier is available to all Google Cloud users. Free Tier is available to users monthly, and its limits are calculated per billing account. In the next section, we will understand the Free Tier usage limits and which products can be used in the program.

### Free Tier usage limits

Google Cloud offers more than 28 products included in the Free Tier program. The range of products is broad: from Google App Engine, BigQuery, Cloud Functions, GCE, or GKE up to reCAPTCHA Enterprise and Pub/Sub.

Please visit the following page to review details about Free Tier usage limits per available product: <https://cloud.google.com/free/docs/gcp-free-tier#free-tier>.

If the usage of the product exceeds the Free Tier limits, the user is billed for the product at standard rates.

## Billing

Billing in Google Cloud is quite an important topic. Without a billing account with an associated payment method, you can’t run any cloud resources. This is critical if you have production workloads and don’t want interruptions. Payment method issues might cause account suspension, and you certainly want to avoid that.

In the next section, we will guide you through the process of creating a billing account.

### Creating a billing account

If a Google Cloud organization manages your account and you are a member, you must have **Billing Account** **Creator** permissions:

1. From Google Cloud Console, click on **Billing**.
2. Select the Google Cloud organization if you are part of one; otherwise, proceed with account creation:

![Figure 3.9 – Selection of an organization when creating a billing account__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_09.jpg)

 Figure 3.9 – Selection of an organization when creating a billing account

1. Click **CREATE ACCOUNT**.
2. Enter a name in **Name**, choose an option for **Country**, and click **CONTINUE** to proceed.

![Figure 3.10 – We need to provide the billing account name and choose a country with the associated currency__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_10.jpg)

Figure 3.10 – We need to provide the billing account name and choose a country with the associated currency

1. We are at the last stage of creating a new billing account. We can select an existing payment profile or create a new one. If we already have a payment profile associated with the payment method, we need to click **SUBMIT AND** **ENABLE BILLING**.

![Figure 3.11 – Final step to complete the new billing profile creation__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_11.jpg)

Figure 3.11 – Final step to complete the new billing profile creation

1. The new billing profile is ready to use:

![Figure 3.12 – Newly created billing profile is active__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_12.jpg)

Figure 3.12 – Newly created billing profile is active

Once the billing profile is created, we can link it to a project.

### Linking a new project to a billing account

Our billing account is created, and we are ready to use it. We will guide you through the new project creation process and associate it with the billing account.

The following are the steps to link a new project to an existing billing account:

1. From the main screen, click **NEW PROJECT**:

![Figure 3.13 – Initial phase of new project creation__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_13.jpg)

Figure 3.13 – Initial phase of new project creation

1. The next and final step in the new project creation process is to provide a **project name** and select the **Billing account**, **Organization**, and **Location** values:

![Figure 3.14 – A new project can be created with a selected billing account__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_14.jpg)

Figure 3.14 – A new project can be created with a selected billing account

1. You can place it in a specific folder or root organization tree:

![Figure 3.15 – Optional placement selection of project within the organization__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_15.jpg)

Figure 3.15 – Optional placement selection of project within the organization

This step concludes how to link the new Google Cloud project to a billing account.

### Linking an existing project to a billing account

Migrating a Google Cloud project to different billing accounts is a straightforward procedure.

We will now link the existing Google Cloud project to a billing account:

1. On the main Google Cloud Console screen, click **Billing**.
2. As we have multiple billing accounts, click **MANAGE** **BILLING ACCOUNTS**.

![Figure 3.16 – Multiple billing accounts in Google Cloud Console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_16.jpg)

Figure 3.16 – Multiple billing accounts in Google Cloud Console

1. In the **Billing** section, we have an overview of existing billing accounts.

![Figure 3.17 – Billing accounts overview__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_17.jpg)

Figure 3.17 – Billing accounts overview

1. To change the billing account for a project, click **MY PROJECTS**:

![Figure 3.18 – The MY PROJECTS section in the billing account overview__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_18.jpg)

Figure 3.18 – The MY PROJECTS section in the billing account overview

1. To change the billing account for a project, choose the **Actions** button:

![Figure 3.19 – Change the billing action in the MY PROJECTS section of Billing__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_19.jpg)

Figure 3.19 – Change the billing action in the MY PROJECTS section of Billing

1. From the drop-down menu, choose the desired billing account:

![Figure 3.20 – Billing account selection__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_20.jpg)

Figure 3.20 – Billing account selection

1. To finalize the process, click the **SET** **ACCOUNT** button.
2. Once the process is completed, you will see a change in the billing account associated with your project.

Linking an existing project to a billing account is a straightforward process.

We will pivot from linking projects with billing accounts into budgets and alerts.

### Budgets and alerts

Like our life outside the cloud, budgets play a crucial role in everybody’s lives. A budget helps create financial stability, allows us to track expenses, and helps us to plan our expenses.

The budget in Google Cloud plays a similar role to that in our daily lives. Some may say that it is even more critical because if we make a mistake during the learning phase, the cost of it might be high.

Google Cloud offers excellent flexibility and elasticity. If the setup of your resources is misconfigured, or your code is miswritten, you might end up paying thousands of dollars for resources you never needed. The budget and alerts should be configured before any cloud activities.

Google Cloud allows us to create budgets, set thresholds, and send notifications using a selected notification medium.

#### Budget creation

To create a budget for a Cloud Billing account, we need to have **billing.budgets.create** permissions. To view all budgets, **billing.budgets.get** and **billing.budgets.list IAM** permissions are required.

One way of assigning this permission could be the IAM role assignment of **Billing Account Administrator** or **Billing Account** **Costs Manager**.

Let’s create our first budget in Google Cloud Console:

1. Navigate to the **Billing** section of Cloud Console.
2. Choose **Budgets & alerts** from the **Cost** **management** section.
3. Click the **CREATE** **BUDGET** button:

![Figure 3.21 – Initial budget creation dialog__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_21.jpg)

Figure 3.21 – Initial budget creation dialog

1. We need to provide a budget name, choose a time range (a **Monthly**, **Quarterly**, **Yearly**, or **Custom** range), specify how many projects to include (one, more, or all), and select the desired services:

![Figure 3.22 – Scoping the budget__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_22.jpg)

Figure 3.22 – Scoping the budget

1. In the **Amount** section, choose **Specified amount** if your budget should be compared against it. Choose **Last month’s spend** if your budget should be dynamically compared to the last calendar period’s spend:

![Figure 3.23 – Selection of the type of budget and the amount__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_23.jpg)

Figure 3.23 – Selection of the type of budget and the amount

1. In the last section of budget creation, we need to enter threshold rules. We can add more thresholds if we want more granular notifications. By default, we have three points, but more can be added:

![Figure 3.24 – Final budget creation page__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_24.jpg)

Figure 3.24 – Final budget creation page

1. To complete the budget creation, we need to select one of the notification channels. It can be an email alert to billing administrators and users, linking the monitoring email notification channel to the budget, or connecting the Pub/Sub topic to the budget once the selected budget creation is completed.
2. It is important to mention – *budget creation doesn’t stop the usage of your resources or block the creation of new ones*. Once you reach 100% of your budget, you can still create new cloud resources, but you will be charged for them.

Budgets can be edited and deleted, but the essential task is to create one and not miss the notifications when exceeding the configured thresholds. To learn more about Google Cloud budgets, visit this link: <https://cloud.google.com/billing/docs/how-to/budgets-notification-recipients>.

### Viewing billing and cloud usage

Billing is configured and we created alerts so we are well prepared to consume Google Cloud resources. The **Billing** section allows us to view detailed reports and break down costs at the project or service level:

![Figure 3.25 – Sample last month’s report view__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_25.jpg)

Figure 3.25 – Sample last month’s report view

You see an example of a monthly report for our account in the preceding figure. On the right-hand side, we can filter the views by projects, folders and organizations, services, and more:

![Figure 3.26 – Cost table breakdown filtered on the project level__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_26.jpg)

Figure 3.26 – Cost table breakdown filtered on the project level

We can view the project ID, SKU, and SKU description information in this detailed view.

### Billing exports

Google Cloud offers additional possibilities for those whose existing billing and cloud usage reporting isn’t enough. Billing exports allow customers to export billing data into the Google Cloud data warehouse called **BigQuery**.

We will learn about BigQuery in upcoming chapters, but in the context of billing exports, BigQuery can be used to export all billing data automatically. It can be helpful if an organization uses external tools to analyze or visualize data. The following documentation explains how to configure billing exports to BigQuery: <https://cloud.google.com/billing/docs/how-to/export-data-bigquery-setup>.

We configured a billing export into BigQuery for one of our projects.

![Figure 3.27 – Billing account configured to export all billing data into BigQuery__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_27.jpg)

Figure 3.27 – Billing account configured to export all billing data into BigQuery

It may take up to 24 hours to see the data from the billing account in BigQuery. Once the data is in the BigQuery dataset, we can query it.

![Figure 3.28 – Sample query in BigQuery with billing data__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_28.jpg)

Figure 3.28 – Sample query in BigQuery with billing data

Looker Studio is a free product offered to Google Cloud users. We can store up to 10 GiB of data with the Free Tier and query up to 1TiB data.

Once the export i[s finished, we can work with the data. For example, we can visualize it in Google Cloud](https://datastudio.google.com/u/2/reporting/1MJ0GHVvcHI6cRHwMKyeSK3r7UoabEHOH/page/WXzW) Data Studio, as shown in the following figure (image from <https://lookerstudio.google.com/u/0/reporting/64387229-05e0-4951-aa3f-e7349bbafc07/page/p_l3qef1s8rc>):

![Figure 3.29 – Sample publicly available on GCP Advanced Billing dashboard created in Looker Studio__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_29.jpg)

Figure 3.29 – Sample publicly available on GCP Advanced Billing dashboard created in Looker Studio

Billing exports allow users to analyze their cloud expenditure further and visualize it in Looker Studio.

We can drag and drop dimensions from the available fields in the following screenshot:

![Figure 3.30 – Data Studio sample billing data__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_30.jpg)

Figure 3.30 – Data Studio sample billing data

We can add charts to visualize our data better as well:

![Figure 3.31 – Cloud Billing data exported into BigQuery and visualized in Data Studio__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_31.jpg)

Figure 3.31 – Cloud Billing data exported into BigQuery and visualized in Data Studio

Visualization is quite a straightforward process and we can configure charts to our liking or business requirements.

# API management

All Google Cloud services can be used only if the correlated API has been enabled. API enablement occurs at the project level. For example: if you used GCE and GCS in your existing project and created a brand-new task, you will need to enable both APIs.

There are three options for us to enable an API in the Google Cloud project:

- Ask a security admin to create an API key for you.
- Ask a security admin to grant you access to the project so that you can create an API key in the same project that the API is associated with
- Ask a security admin to grant you access to enable the API in your own Google Cloud project so that you can create an API key

In the next section, we will learn how to enable a Google Cloud API.

## Enabling an API

We can enable an API in two places – Cloud Console or Google Cloud Shell. Let’s start with Cloud Console.

### Enabling an API in Cloud Console

To enable an API in Cloud Console, we need to go to **APIs & Services** in our project:

![Figure 3.32 – Overview of APIs & Services__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_32.jpg)

Figure 3.32 – Overview of APIs & Services

Simply type the product name or choose it from the categories to enable a particular API. Once selected, click **ENABLE**:

![Figure 3.33 – API enablement for Pub/Sub__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_33.jpg)

Figure 3.33 – API enablement for Pub/Sub

API enablement usually takes just a few seconds. Now, let’s look at how to enable an API in Cloud Shell.

### Enabling an API in Cloud Shell

Similar to Cloud Console, APIs can be enabled in Cloud Shell. The steps are as follows:

1. To list all projects, type the following command:

   ```
   gcloud projects list
   ```
2. The next step is to choose our desired project:

   ```
   gcloud config set project PROJECT_ID
   ```
3. Before we enable the API, we need to list all available services by running the following command:

   ```
   gcloud services list --avialable
   ```
4. Choose the desired service and enable it:

   ```
   gcloud services enable SERVICE_NAME
   ```

Once we enable the API, it is good to know where to check which APIs are enabled to have an overview. This is the topic of the next section.

### Overview of an enabled API

To check which APIs are enabled, we can view this information in the **APIs & Services** section, shown as follows:

![Figure 3.34 – Overview of enabled APIs](../images/B18851_03_34.jpg)

Figure 3.34 – Overview of enabled APIs

In addition to information on enabled APIs, we can view the number of requests, error percentage, and latency.

API management is a straightforward process, but it is essential to remember that APIs are already enabled every time we use the Google Cloud service. If we have never used a service, we need to have sufficient permissions to allow it to use it.

The fact that API management is a straightforward process is especially important to remember if we want to run services in newly created projects. The next section focuses on quota management, which is an important topic for day-to-day cloud usage and the certification.

# Quota management

Another part of using Google Cloud services is quotas. Together with APIs, they fully allow you to manage how you will use Google Cloud services. While APIs enable us to control whether the service is in an enabled or disabled state, quotas will allow us to control how many resources can be used.

Different products may have various quantifiable resources such as the number of API calls or requests per time period, or be as simple as CPU and RAM space or disk storage number.

You might wonder why cloud providers limit you from spending however much you want on cloud resources. First and foremost, Google Cloud wishes to protect you from unexpected spending. We all make mistakes, and some code deployment, script, or even GUI errors happen. If there is no protection, your credit card could be quickly charged with thousands of US dollars. Some cloud resources are more expensive than others – for example, GPUs or high-CPU and RAM VMs. They can max out your credit card very quickly.

All this is done to protect you, your spending, and other customers.

The longer you use the cloud and have a more extended spending history, the possibility of creating more cloud resources increases. Google Cloud evaluates many factors such as previous spending or abuse penalties. Customers might have different quotas based on these aspects and some other factors. In the next figure, we can see the **Quota** section of Google Cloud Console:

![Figure 3.35 – Unable to change quota notification__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_35.jpg)

Figure 3.35 – Unable to change quota notification

The preceding screenshot shows precisely that the quota can’t be changed yet.

The final word is to remember that quotas are project resources. In the next section, we will focus on the quota increase process and factors.

## Quota increase

Quota increase is an automated process where many pre-existing factors such as project longevity, how long you have been using Google Cloud, and whether the account is newly created are evaluated. Some quotas might be denied now for you but approved later.

Fortunately, it is not a fully automated process, and Cloud Customer Billing works on those requests. Usually, it takes 2-3 business days to process a request. In our experience, quota increase requests have been processed much faster.

### Quota increase permissions

To view your project quota in Google Cloud Console or access the project quota programmatically, you must have the following IAM permissions:

- **resourcemanager.projects.get**
- **resourcemanager.folders.get** (if you want to view the quota for an entire folder)
- **resourcemanager.organizations.get** (if you want to view quota for an entire organization)
- **serviceusage.quotas.get**

To change your quota at the project, folder, or organization level, you must have the following permission:

- **serviceusage.quotas.update**

These permissions allow you to manage quotas in Google Cloud.

### Quota increase process

To increase a quota, follow these steps:

1. To view all quotas and available resources in your project in Cloud Console, go to **Quotas**:

![Figure 3.36 – Overview of Quotas in a project__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_36.jpg)

Figure 3.36 – Overview of Quotas in a project

1. Choose the desired quota to change. Click the **EDIT** **QUOTAS** button.

![Figure 3.37 – Editing the desired quota with the request description__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_37.jpg)

Figure 3.37 – Editing the desired quota with the request description

1. Once you have added a new limit and request description, you need to provide your details such as an email address and a phone number:

![Figure 3.38 – Quota increase request with contact details__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_38.jpg)

Figure 3.38 – Quota increase request with contact details

1. After we click **SUBMIT REQUEST**, we receive a ticket number, and will receive updates by email:

![Figure 3.39 – Quota increase request with ticket number__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_03_39.jpg)

Figure 3.39 – Quota increase request with ticket number

This concludes the process of increasing a quota in Cloud Console.

Sometimes, a quota increase fails, and we will cover possible causes and errors you might encounter.

### Quota errors

You might encounter the following quota errors:

- **429 TOO MANY REQUESTS** – An HTTP error when the HTTP/REST request is exceeded
- **413 REQUEST ENTITY TOO LARGE** – An HTTP error if you exceed a quota with an API request
- **ResourceExhausted** – The HTTP error if you exhaust a quota with gRPC
- **1** – If you exceeded the quota using the Google Cloud CLI

Hopefully, by reading this section, you will not encounter quota errors, and if you do, you will know what caused them and be able to fix them very fast.

Quota management, billing, and API management are day-to-day operations that some of you will do programmatically or by using Google Cloud Console. Regardless of how they will be executed, they are an integral part of working with Google Cloud.

# Summary

After reading this chapter, you should be able to plan the deployment of Google Cloud compute, database, and storage options. We covered various types of persistent disk options for GCE, different types of object storage, and various database options. We created new billing accounts and created budgets and alerts. We learned how to enable an API and increase the quota for a specific GCP service.

In the next chapter, we will focus on the implementation of Google Cloud compute resources starting from VMs up to Cloud Run or infrastructure as code.

# Questions

Answer the following questions to test your knowledge gained from this chapter:

1. Which permissions are required to increase the quota in a project?
   1. **resourcemanager.projects.get**
   2. **resourcemanager.folders.get**
   3. **resourcemanager.organizations.get**
   4. **serviceusage.quotas.get**
   5. All the above
2. Which product would you use for a workload that requires full access to the underlying operating system?
   1. GKE
   2. Cloud Run
   3. GAE
   4. GCE
3. What is the main difference between persistent disk and cloud storage?
   1. Cloud Storage is used mainly for object storage
   2. A persistent disk is a default boot device for VMs
   3. Cloud Storage objects can be accessed from VMs
   4. The persistent disk has an unlimited size
4. A Compute Engine VM can have which of the following disks?
   1. A zonal persistent disk
   2. An extreme global disk
   3. A regional bucket disk
   4. A local SSD
5. To use Google Cloud products, I need to \_\_\_\_\_\_\_\_\_\_:
   1. Have a billing account
   2. Attach a payment type
   3. Create a project
   4. Enable a specific product API
   5. All of the above
6. What is the durability of Cloud Storage?
   1. 99.999999999% annual durability
   2. 99.9% weekly durability
   3. 99.9999999999999999999% monthly durability
   4. 99% annual durability
7. Select a product that uses event-driven serverless functions:
   1. Cloud Run
   2. Cloud Serverless
   3. Google Serverless Run
   4. Cloud Functions
8. Select all that apply:
   1. The project must have an associated billing account
   2. One billing account can be associated with multiple projects
   3. A billing account requires a payment method
   4. There can be numerous billing accounts
   5. All of the above
9. Which product fits best to the requirements of autoscaling applications and databases with high availability and integrated monitoring and A/B testing?
   1. GKE
   2. GCE
   3. GAE
   4. Cloud Run
10. Select a database for an application that requires high scalability and high availability and will be deployed as a mobile application:
    1. Cloud Bigtable
    2. Cloud SQL
    3. BigQuery
    4. Firestore
11. Which type of persistent disk provides the highest availability?
    1. A global extreme disk
    2. A local SSD
    3. A zonal persistent disk
    4. A regional persistent disk
12. Who can use the Google Cloud Free Trial?
    1. Any new customer
    2. Existing and new customers
    3. Customers who use invoicing
    4. Only Free Tier customers
13. Why is it recommended to create billing alerts?
    1. It provides visibility into existing cloud expenditure
    2. It informs us about cloud expenditure
    3. It prevents excessive cloud expenditure
    4. It protects our budget
    5. All of the above
14. Select as suitable type of Google Cloud Storage for backups that will be stored for more than 10 years and retrieved once per year:
    1. Standard
    2. Nearline
    3. Performance
    4. Archive
15. You have been asked to advise on a data warehouse solution that can query complex datasets interactively with sub-second query response time and high concurrency. Which option would you go for?
    1. Google Cloud Run
    2. BigQuery
    3. Cloud Bigtable
    4. Cloud SQL
16. Choose a computing option for a containerized application with complete control over the nodes with the ability to fine-tune and run custom administrative workloads:
    1. Cloud Run
    2. Cloud Spanner
    3. GKE
    4. GAE
17. Choose the compute option for a stateless or batch-processing application:
    1. n1-ultramem-160
    2. Preemptible/spot VM
    3. GCE
    4. Cloud Run
18. Who can use Google Cloud Free Tier?
    1. Free Tier ends after 30 days and cannot be used afterward
    2. Free Tier is available after the free trial
    3. Only enterprise customers can use it
    4. It is available to all Google Cloud users
19. Select all that apply to budget exports:
    1. They provide greater flexibility than Google Cloud Billing
    2. They allow you to integrate with other billing tools
    3. They provide greater visibility into the billing data
    4. Data can be visualized in other tools
    5. All of the above
20. GCS cannot be used \_\_\_\_\_\_:
    1. As a boot disk for compute VMs
    2. For high-performance object storage
    3. For archival storage
    4. For database storage
    5. Answers A and D

# Answers

The answers to the preceding questions are as follows:

1E, 2D, 3B, 4A, 5E, 6A, 7D, 8E, 9C, 10D, 11D, 12A, 13E, 14D, 15B, 16C, 17B, 18D, 19E, 20E