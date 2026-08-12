# 10

# Data Processing Services in Google Cloud

For years, companies of all sizes have collected and stored vast amounts of data about their customers and business operations to enhance performance, achieve growth, and realize their goals. In 2006, Clive Humby, a renowned British mathematician, coined the phrase *Data is the new oil* to emphasize the growing importance of data in the modern business landscape. Google Cloud has a broad portfolio of data processing products.

In [*Chapter 7*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_07.xhtml#_idTextAnchor159), we introduced some data-related services from the storage perspective. This chapter aims to familiarize us with the data processing services in Google Cloud. We discussed Cloud SQL, BigQuery, Firestore, Cloud Spanner, and Cloud Bigtable. To complete the story, we will cover the following topics in this chapter:

- Data processing point of overview – Pub/Sub, Dataproc, and Dataflow
- Initializing and loading data using the command line, API transfer, and loading the data from Cloud Storage and streaming it using Pub/Sub

# Data processing services overview

Data processing in Google Cloud refers to the various tools and services provided by **Google Cloud Platform** (**GCP**) that enable organizations to process, store, and analyze large amounts of data in the cloud.

These services provide organizations with the necessary infrastructure and tools to collect, process, store, analyze, and visualize their data in the cloud, helping them discover meaningful insights and make better-informed business decisions.

## Pub/Sub

Pub/Sub is a publish/subscribe service – a messaging service where the senders of messages are decoupled from the receivers.

Pub/Sub is a messaging service that is both scalable and asynchronous, allowing us to separate the message-producing services from the services that process those messages. It allows various Google Cloud services to communicate asynchronously with latencies of 100 milliseconds. The most common use case for Pub/Sub is streaming analytics and data integration pipeline with data ingestion and distribution.

Here are some other Pub/Sub use cases:

- **Ingestion user interaction and server events**: From your application or servers, you can forward events to Pub/Sub and process them with stream processing tools such as Dataflow.
- **Real-time event distribution**: Pub/Sub allows us to distribute events to multiple applications or databases.
- **Parallel processing and workflows**: When combined with Cloud Functions, Pub/Sub can distribute messages among multiple workers to be used in tasks such as file compression, sending email notifications, or processing images.
- **Enterprise event bus**: Pub/Sub is well suited to an enterprise-wide data sharing bus and distributing events.

There are two services – Pub/Sub and Pub/Sub Lite.

Pub/Sub is the default choice for most users and applications. Pub/Sub Lite, on the other hand, has a lower cost and offers lower reliability compared to Pub/Sub. Other differences are that Pub/Sub Lite topics are stored in only one zone and replicated asynchronously.

To learn more about the differences between the two services, go to <https://cloud.google.com/pubsub/docs/choosing-pubsub-or-lite>.

### Pub/Sub architecture

To understand Pub/Sub, we need to list several key service components:

- **Message**: Data that flows through the service.
- **Topic**: A named entity that represents a feed of messages.
- **Subscription**: A named entity that receives messages on a particular topic.
- **Publisher**: Also called a producer, the publisher creates messages and publishes them to the messaging service on a specific topic.
- **Subscriber**: Also called a consumer, the subscriber receives messages on a specific subscription.

The following is a visual representation of the architecture:

![Figure 10.1 – Pub/Sub architecture](../images/B18851_10_01.jpg)

Figure 10.1 – Pub/Sub architecture

The preceding diagram shows two publishers – A and B – sending messages to a topic. The topic has two subscriptions that want to receive messages from the topic. On the right-hand side, subscribers receive messages from the specific subscription. We can also see that subscribers receive different messages. Some subscribers receive only message A or B, but **Subscriber 3** receives both A and B.

Pub/Sub combines the horizontal scalability of **Apache Kafka** and **Pulsar** with features found in traditional messaging middleware such as **Apache ActiveMQ** and **RabbitMQ**.

Pub/Sub integrates with other Google Cloud services such as **Dataflow**, **Logging** and **Monitoring**, triggers, notifications, and webhooks.

In the next section, we will learn about Dataproc – one of the next data processing services in Google Cloud.

## Dataproc

Dataproc is a fully managed Google Cloud service that runs **Apache Hadoop**, **Apache Spark**, **Apache Flink**, **Presto**, and more than 30 other open source tools and frameworks. It can be used for data lake modernization, **Extract, Transform,** and **Load** (**ETL**) operations, and data science.

One advantage of using Dataproc is that there’s no need to learn new tools or APIs. Dataproc allows us to start, scale, and shut down; each operation takes 90 seconds or less. Creating a cluster might take 5 to 30 minutes compared to on-premises deployments. Dataproc integrates with other Google Cloud services such as BigQuery, Cloud Storage, Cloud Bigtable, Cloud Logging, and Cloud Monitoring. This creates a data ecosystem that is easy to use, regardless of how you interact with it – the Google Cloud console, Cloud SDK, or REST API.

By default, Dataproc supports the following images:

- Ubuntu
- Debian
- Rocky Linux

To learn which exact versions of images are supported, go to <https://cloud.google.com/dataproc/docs/concepts/versioning/dataproc-version-clusters#supported_dataproc_versions>.

### Dataproc architecture

Google Cloud allows you to run Dataproc on **Google Compute Engine** (**GCE**) or **Google Kubernetes Engine** (**GKE**). The main difference between Dataproc on GCE versus Dataproc on GKE is that Dataproc on GKE virtual clusters does not include separate master and worker VMs. In Dataproc on GKE, a node pool is created within the GKE cluster, and jobs are run as pods on these node pools:

![Figure 10.2 – High-level Dataproc architecture](../images/B18851_10_02.jpg)

Figure 10.2 – High-level Dataproc architecture

The preceding diagram shows a high-level overview of the Dataproc architecture. On the left-hand side, we have possible sources of the data. In the middle section, we have data computing units that leverage autoscaling policies. If your job requires more compute units, you can configure autoscaling policies. You can store the results of the jobs in Cloud Storage or BigQuery.

The following section will discuss the next Google Cloud offering – the Dataflow data portfolio product.

## Dataflow

Dataflow is a fully managed service that allows data modifications and enhancements in batch and stream modes. It provides automated provisioning and management of compute resources. Dataflow allows you to use **Apache Beam**, an open source unified model for defining batch and streaming data processing pipelines. You can use the Apache Beam programming model and Apache Beam SDK.

Dataflow provides templates that can accelerate product adoption.

### Dataflow architecture

Dataflow provides several features that help you run secure, reliable, fast, and cost-effective data pipelines at scale. They are as follows:

- **Autoscaling**: *Horizontal* (scale out – the appropriate number of workers is selected) and *vertical* autoscaling (scale up – Dataflow dynamically scales up or down memory available to workers) allow you to run jobs in a cost-efficient manner.
- **Serverless**: Pipelines that use Dataflow Prime benefit from automated and optimized resource management, reduced operational costs, and improved diagnostics capabilities.
- **Job Monitoring**: Seeing and interacting with Dataflow jobs is possible. In the monitoring interface, you can view Dataflow jobs via a graphical representation of each pipeline, along with each job’s status.

The following figure shows the Dataflow architecture, where we can see tight integration with core Google Cloud services and possibilities to interact with the service by using Dataflow SQL:

![Figure 10.3 – High-level Dataflow architecture](../images/B18851_10_03.jpg)

Figure 10.3 – High-level Dataflow architecture

You can also use **Customer Managed Encryption Keys** (**CMEKs**) to encrypt data at rest and specify networks or subnetworks with VPC Service Controls.

Now that we’ve learned about the architecture and use cases for each data processing product, we should learn how to initialize and load data into them.

# Initializing and loading data into data products

In this practical part of the chapter, we will focus on initializing and loading data into the previously described data products. Covering such practical exercises and providing an architecture overview allow us to understand the products better.

## Pub/Sub and Dataflow

The first example will combine the usage of three data products: Pub/Sub, Dataflow, and Cloud Storage. The Pub/Sub topic will read messages published to a topic and group the messages by timestamp. Ultimately, these messages will be stored in a Cloud Storage bucket:

1. Before we start, we need to enable a few APIs – Dataflow, Compute Engine, Cloud Logging, Cloud Storage, Google Cloud Storage JSON API, Pub/Sub, Resource Manager, and Cloud Scheduler.
2. In Cloud Shell, run the following command:

   ```
   gcloud services enable dataflow.googleapis.com  compute.googleapis.com  logging.googleapis.com  storage-component.googleapis.com  storage-api.googleapis.com  pubsub.googleapis.com  cloudresourcemanager.googleapis.com  cloudscheduler.googleapis.com
   ```

Our solution will create a new service account and grant it several roles to interact with multiple services. Those roles have the **/dataflow—worker**, **roles/storage.objectAdmin**, and **roles/pubsub.admin** rights.

1. We must create a new service account with the following **gcloud** command:

   ```
   gcloud iam service-accounts create data-services-sa
   ```
2. Once our service account has been created, we can grant roles to it. We can do so by executing the following command and specifying the previously mentioned roles – that is, **roles/dataflow. worker**, **roles/storage.objectAdmin**, and **roles/pubsub.admin**:

   ```
   gcloud projects add-iam-policy-binding wmarusiak-book-351718 --member="serviceAccount data-services-sa@wmarusiak-book-351718 .iam.gserviceaccount.com" --role=roles/dataflow.worker
   ```
3. After adding these roles to the service account, we can grant our Google account a role so that we can use the previously created roles and attach the service account to other resources. To do so, we need to execute the following code:

   ```
   gcloud iam service-accounts add-iam-policy-binding data-services-sa@wmarusiak-book-351718.iam.gserviceaccount.com --member="user:YOUR_EMAIL_ADDRESS" --role=roles/iam.serviceAccountUser
   ```
4. Now, we must use service credentials to be configured as default application credentials. In Cloud Shell, run the following code:

   ```
   gcloud auth application-default login
   ```
5. The next step involves creating a Cloud Storage bucket name. We must execute the **gsutil mb gs://YOUR\_BUCKET\_NAME** command in Cloud Shell. Please replace the bucket name with a unique name – we used **wmarusiak-data-services-bucket**.
6. Now that we’ve created the Cloud Storage bucket, we must create a Pub/Sub topic. We can use the **gcloud pubsub** **topics create** **YOUR\_PUB\_SUB\_TOPIC\_NAME** command to do so. We used **wmarusiak-data-services-topic** as our Pub/Sub topic name. Please replace the topic’s name with a unique name.
7. To finish resource creation, we must create a Cloud Scheduler job in the working project. The job publishes a message to a Pub/Sub topic every minute. The command to create a Cloud Scheduler job is as follows:

   ```
   gcloud scheduler jobs create pubsub publisher-job --schedule="* * * * *" --topic=wmarusiak-data-services-topic --message-body="Hello!" --location=europe-west1
   ```
8. To start the job, we need to run the following **gcloud** command:

   ```
   gcloud scheduler jobs run publisher-job --location=europe-west1
   ```

The last step involves downloading a Java or Python GitHub repository to initiate the necessary code quickly.

1. We used Python code; you can use this instruction to download it:

   ```
   git clone https://github.com/GoogleCloudPlatform/python-docs-samples.git \ cd python-docs-samples/pubsub/streaming-analytics/ pip install -r requirements.txt  # Install Apache Beam dependencies
   ```
2. You can find the Python code by visiting the Google Cloud GitHub repository at https://github.com/GoogleCloudPlatform/python-docs-samples/blob/HEAD/pubsub/streaming-analytics/PubSubToGCS.py.
3. The last step is to run the Python code. We need to replace the constants with our actual data:

   ```
   python PubSubToGCS.py --project=$PROJECT_ID --region=$REGION --input_topic=projects/$PROJECT_ID/topics/$TOPIC_ID --output_path=gs://$BUCKET_NAME/samples/output --runner=DataflowRunner --window_size=2 --num_shards=2 --temp_location=gs://$BUCKET_NAME/temp --service_account_email=$SERVICE_ACCOUNT
   ```
4. In our case, the code looks as follows:

   ```
   python PubSubToGCS.py --project=wmarusiak-book-351718 --region=europe-west1 --input_topic=projects/wmarusiak-book-351718/topics/wmarusiak-data-services-topic  --output_path=gs://wmarusiak-data-services-bucket/samples/output --runner=DataflowRunner --window_size=2  --num_shards=2 --temp_location=gs://wmarusiak-data-services-bucket/temp --service_account_email=data-services-sa@wmarusiak-book-351718.iam.gserviceaccount.com
   ```
5. Our Dataflow job runs, and messages flow from Cloud Scheduler to Pub/Sub:

![Figure 10.4 – Dataflow job execution graph](../images/B18851_10_04.jpg)

Figure 10.4 – Dataflow job execution graph

1. We can also see the code output in the Cloud Storage bucket, which contains stored messages:

![Figure 10.5 – Saved job output in the Cloud Storage bucket](../images/B18851_10_05.jpg)

Figure 10.5 – Saved job output in the Cloud Storage bucket

1. We can download objects to view the content of processed messages:

![Figure 10.6 – Content of processed messages](../images/B18851_10_06.jpg)

Figure 10.6 – Content of processed messages

1. To get a few more messages, we created two additional Cloud Scheduler services.

This example showed us the tight integration between Google Cloud products and how we can ingest incoming messages and process them in a few steps. In the next section, we will cover the Dataproc service.

## Dataproc

It is one of the everyday use cases in data science and data engineering to read data from one storage platform, transform it, and use it elsewhere. Our Dataproc example will be based on a data processing pipeline that uses Apache Spark (Python API) with Dataproc (PySpark). We will run a sample pipeline to read data from Reddit posts stored in BigQuery and extract the title and body (raw text) with the timestamp that was created for each Reddit comment. This data will be converted into CSV format, compressed in ZIP format, and stored in a Google Cloud Storage bucket:

1. For our use case with Dataproc, we must enable three APIs – Dataproc, Compute Engine, and BigQuery. We can do this using the following **gcloud** command:

   ```
   gcloud services enable compute.googleapis.com dataproc.googleapis.com bigquerystorage.googleapis.com
   ```
2. We can default the Dataproc region by using the **gcloud config set dataproc/region YOUR\_REGION**, command, where **YOUR\_REGION** can be any available region. In our case, **YOUR\_REGION** will be **europe-west1**.
3. To create a Dataproc cluster, we must provide its name and additional configuration:

   ```
   gcloud beta dataproc clusters create DATAPROC_CLUSTER_NAME --worker-machine-type n1-standard-2 --num-workers 6 --image-version 1.5-debian --initialization-actions gs://dataproc-initialization-actions/python/pip-install.sh --metadata 'PIP_PACKAGES=google-cloud-storage' --optional-components=ANACONDA --enable-component-gateway
   ```

We need to enter the Dataproc cluster’s name, and we can choose different worker machine types. Pick a desired worker type from the available Google Compute Engine instance types. In our case, we changed it to **n1-standard-2** so that we don’t exceed our CPU quota. We can also specify a different amount of worker nodes. After a moment, the Dataproc cluster will be operational and ready to accept incoming jobs:

![Figure 10.7 – The Dataproc cluster is operational](../images/B18851_10_07.jpg)

Figure 10.7 – The Dataproc cluster is operational

1. We will use the Google Cloud Python GitHub repository, which can be cloned with the following command:

   ```
   git clone https://github.com/GoogleCloudPlatform/cloud-dataproc
   ```
2. Once we enter the repository with the **cd ~/cloud-dataproc/codelabs/spark-bigquery** command, we can execute the Dataproc job.
3. To execute the Dataproc job, we can use the following command:

   ```
   gcloud dataproc jobs submit pyspark --cluster dataproc-cluster-1 --jars gs://spark-lib/bigquery/spark-bigquery-latest_2.12.jar  --driver-log-levels root=FATAL counts_by_subreddit.py
   ```
4. The job’s status can be viewed in the Google Cloud console or Cloud Shell once it’s been accepted:

![Figure 10.8 – Dataproc job visible in Cloud Shell and the Google Cloud console](../images/B18851_10_08.jpg)

Figure 10.8 – Dataproc job visible in Cloud Shell and the Google Cloud console

Dataproc provides various components of the Dataproc cluster – **YARN ResourceManager**, **MapReduce Job History**, **Spark History Server**, **HDFS NameNode**, **YARN Application Timeline**, and **Tez**. This information is visible in **Cluster details** under the **WEB** **INTERFACES** tab:

![Figure 10.9 – Cluster details](../images/B18851_10_09.jpg)

Figure 10.9 – Cluster details

1. After a moment, the job will complete, and we can proceed with data transformation:

![Figure 10.10 – Dataproc job results](../images/B18851_10_10.jpg)

Figure 10.10 – Dataproc job results

1. In BigQuery Web UI’s Query Editor, we run the **select \* from fh-bigquery.reddit\_posts.2017\_01 limit 10;** SQL query to view sample data output:

![Figure 10.11 – SQL query output in BigQuery Web UI](../images/B18851_10_11.jpg)

Figure 10.11 – SQL query output in BigQuery Web UI

1. We will see that different columns are available, but two columns – **title** and **selftext** – contain the information we will use later.
2. In the **cloud-dataproc/codelabs/spark-bigquery** folder downloaded in the previous steps repository, we run the **backfill.py** Python script. To do so, we can run the following **gcloud** command:

   ```
   cd ~/cloud-dataproc/codelabs/spark-bigquery bash backfill.sh dataproc-cluster-1 wmarusiak-dataproc-bucket-1
   ```
3. After a few minutes, the job will be completed, and the CSV files will be uploaded to the Google Cloud Storage bucket. We can list the bucket’s content with the following command:

   ```
   gsutil ls gs://YOUR_CLOUD_STORAGE_BUCKET/reddit_posts/*/*/food.csv.gz
   ```

We will get the following output:

![Figure 10.12 – SQL query output in BigQuery Web UI](../images/B18851_10_12.jpg)

Figure 10.12 – SQL query output in BigQuery Web UI

1. So, what can we do with this data after processing it? One example could be building models on top of it.
2. Now that we’ve learned about and implemented Dataproc in Google Cloud, we will move on to the next section, where we will learn about APIs and their use cases and do a hands-on implementation of them.

## Using Google Cloud APIs

**API** stands for **application programming interface**, a set of definitions and protocols for building and integrating applications. Google Cloud APIs are programmatic interfaces that interact with Google Cloud services. In *Chapter 3*, we learned how to enable and disable Google Cloud APIs with the **gcloud** command-line interface. In this part of this chapter, we would like to focus on working with Google Cloud APIs using REST/HTTP APIs. As mentioned in [*Chapter 3*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_03.xhtml#_idTextAnchor058), Google Cloud offers many ways to interact with its services. For this chapter, we will show you how to interact with data-related products using REST/HTTP APIs.

### Using Google Cloud APIs with REST/HTTP APIs

We can use various tools to work with REST/HTTP APIs. Depending on the operating system and our preferences, it can be a **curl** Linux command-line tool, or we can use desktop applications such as Postman, Swagger, or HTTPie. These tools are multiplatform, and you can try them out yourself. We will use Postman in this part of this book.

Before interacting with Google Cloud APIs, we need to authenticate ourselves with Google Cloud.

### Authenticating using REST

Similar to the different choices Google Cloud offers us for interacting with APIs, we have different ways to authenticate with Google Cloud to work with its services. In our case, we will describe OAuth 2.0 authentication with Postman, as other authentication possibilities exceed Associate Cloud Engineer certification requirements.

If you wish to learn about different ways, go to https://cloud.google.com/docs/authentication/client-libraries.

### OAuth 2.0

**OAuth 2.0** is an open standard protocol that allows users to grant third-party application access to their resources without them revealing their credentials. It provides a secure and standard way for users to authorize access to their resources, such as social media profiles, email accounts, or online storage services.

In an OAuth 2.0 flow, the user authenticates with the resource provider (for example, Google, Facebook, or another provider) and then authorizes the third-party application to access their resources. The third-party application obtains an access token, which it can use to make requests on behalf of the user to access their resources.

To set OAuth 2.0, we must first create credentials in **APIs & Services** in Google Cloud:

1. In the desired project, go to **APIs &** **Services**.
2. Click **Credentials**. If this is the first time you’re creating credentials, you must configure the consent screen. Click the **CONFIGURE CONSENT** **SCREEN** button:

![Figure 10.13 – The Credentials section in APIs & Services](../images/B18851_10_13.jpg)

Figure 10.13 – The Credentials section in APIs & Services

1. In our case, we will set **User Type** to **Internal**. Click **Create**.
2. In the next section, we need to enter **App name** (the name of the app asking for consent) and **User support email** (for users to contact you with questions about their consent) details; optionally, we can add the app logo and more information about the app. We can also look at the app’s home page, privacy policy, and terms of service:

![Figure 10.14 – OAuth consent screen creation](../images/B18851_10_14.jpg)

Figure 10.14 – OAuth consent screen creation

1. In the **Scopes** section, we can specify the permissions we want users to authorize for our app.
2. After saving the **Scopes** section, the OAuth consent section will be completed.
3. Back in the **Credentials** section, we can start creating credentials. Click the **CREATE CREDENTIALS** button to start this process. From the menu, choose **OAuth** **client ID**:

![Figure 10.15 – The CREATE CREDENTIALS button and the possible choices](../images/B18851_10_15.jpg)

Figure 10.15 – The CREATE CREDENTIALS button and the possible choices

1. From the drop-down menu, choose **Web application**:

![Figure 10.16 – Selecting an OAuth client ID application type](../images/B18851_10_16.jpg)

Figure 10.16 – Selecting an OAuth client ID application type

1. Enter the name of the web application and set **Authorized redirect URIs** to <https://oauth.pstmn.io/v1/callback> and **https://www.getpostman.com/oauth2/callback**, respectively:

![Figure 10.17 – Authorized redirect URIs to work with Postman](../images/B18851_10_17.jpg)

Figure 10.17 – Authorized redirect URIs to work with Postman

1. Click **CREATE** to finalize the OAuth client ID creation process:

![Figure 10.18 – OAuth client created](../images/B18851_10_18.jpg)

Figure 10.18 – OAuth client created

1. You will receive a client ID and client secret in the window. We will use these to authenticate our API request in Postman.

Now that we’ve retrieved the **Client ID** and **Client Secret** details, we must familiarize ourselves with API call types and response codes.

### Popular API calls

To work with API calls, it is essential to understand which API calls we can make and what they do. Here is a list of the most popular ones:

- **GET**: A request to retrieve information from the server
- **POST**: A request to send information to the server
- **PUT**: A request to update existing data on the server
- **DELETE**: A request to delete data from the server
- **PATCH**: A request to update existing data on the server partially
- **OPTIONS**: A request to retrieve information about the communication options available on the server
- **HEAD**: A request to retrieve only the header information from the server
- **CONNECT**: A request to establish a network connection to the server
- **TRACE**: A request to retrieve a diagnostic trace of the actions performed by the server
- **Remote Procedure Call** (**RPC**): A request to execute a procedure on a remote server.

Now that we’ve learned what popular API calls we can make, it is essential to know what the most popular HTTP status codes are in response to API calls:

- **200 OK**: The request was successful, and the response contains the requested data.
- **201 Created**: The request has been fulfilled, and a new resource has been created.
- **204 No Content**: The request was successful, but there is no data to return.
- **400 Bad Request**: The request was malformed or invalid.
- **401 Unauthorized**: Authentication is required and has failed or has not been provided.
- **403 Forbidden**: The server has understood the request but refuses to authorize it.
- **404 Not Found**: The requested resource could not be found.
- **500 Internal Server Error**: The server encountered an error while processing the request.
- **502 Bad Gateway**: The server received an invalid response from the upstream server.
- **503 Service Unavailable**: The server cannot handle the request due to a temporary overload or maintenance.

In the next section, we will learn how to use Postman to make simple API calls in Google Cloud.

### Postman configuration

*“Postman is an API platform for building and using APIs. Postman simplifies each step of the API life cycle and streamlines collaboration so that you can create better APIs –* *faster”.*

This quote is from <https://www.postman.com/product/what-is-postman/>.

Postman can be used on any modern operating system – Windows, Linux, or macOS. To download it, go to https://www.postman.com/downloads/postman-agent/. If you do not wish to install Postman, you can use the web-based portal to interact with Google Cloud services using API calls:

1. Open Postman and click the **+** button to create a new API call.
2. We will start with a straightforward **GET** call to list instances in a particular Google Cloud zone: **GET** https://compute.googleapis.com/compute/v1/projects/{project}/zones/{zone}/instances. We will change the project and zone to the values that reflect our environment.
3. In Postman, we must enter the previous URL with the correct project name and zone:

![Figure 10.19 – GET API call to query GCE instances in the europe-west4-a zone](../images/B18851_10_19.jpg)

Figure 10.19 – GET API call to query GCE instances in the europe-west4-a zone

1. Let’s test whether we can retrieve any information by clicking **Send**.
2. As we can see in the **Body** section, there was an error with a status code of **401 Unauthorized**.
3. We authorized and previously created OAuth credentials in Google Cloud to authorize.

In the **Authorization** tab of Postman, choose **OAuth 2.0**:

![Figure 10.20 – The Authorization section of the API call](../images/B18851_10_20.jpg)

Figure 10.20 – The Authorization section of the API call

1. In the **Configure New Token** section, we need to configure the following information:
   1. **Type**: OAuth 2.0
   2. Add authorization data to request headers
   3. **Token Name**: Enter your desired name
   4. **Grant Type**: Authorization code
   5. **Callback URL**: We will use previously configured URLs in the **Credentials** section of **API & Services** – that is, **https://www.getpostman.com/oauth2/callback** and <https://oauth.pstmn.io/v1/callback>
   6. **Auth** **URL**: <https://accounts.google.com/o/oauth2/auth>
   7. **Access Token** **URL**: <https://accounts.google.com/o/oauth2/token>
   8. **Client ID**: Our previously created OAuth credential Client ID
   9. **Client Secret**: Our previously created OAuth credential client secret
   10. **Scope**: <https://www.googleapis.com/auth/cloud-platform>
2. Click the **Get New Access Token** button to retrieve a new token:

![Figure 10.21 – New token filled with necessary information](../images/B18851_10_21.jpg)

Figure 10.21 – New token filled with necessary information

1. We need to authenticate using our email and password:

![Figure 10.22 – Authentication to Google Cloud](../images/B18851_10_22.jpg)

Figure 10.22 – Authentication to Google Cloud

1. We need to accept Postman permissions. If you are okay with Postman managing your Google Cloud data, proceed by clicking **Allow**.
2. The token will be successfully created and can be used with Google Cloud:

![Figure 10.23 – Successful token creation](../images/B18851_10_23.jpg)

Figure 10.23 – Successful token creation

1. To finalize the token creation process, click the **Use** **Token** button.
2. Finally, after completing the authorization process, we can execute the **GET** call. Click the **SEND** button. In the response’s **Body** section, we will see the response’s output and Google compute instance details:

![Figure 10.24 – Successful response and the compute instance details](../images/B18851_10_24.jpg)

Figure 10.24 – Successful response and the compute instance details

Now that we’ve learned how to use Google Cloud APIs and retrieve information about compute instances, we will proceed with more hands-on examples.

### Interacting with data services using API calls

Google Cloud offers comprehensive documentation about the usage of its APIs. We recommend several valid URLs that you should visit if you want to dive deeper:

- <https://cloud.google.com/apis/docs/overview>: General overview of the **cloud** APIs concept
- <https://developers.google.com/apis-explorer>: A tool that lets you try out Google API methods without having to write any code
- <https://cloud.google.com/apis/docs/getting-started>: A getting started guide for working with Google Cloud APIs

In this section, we will create a Pub/Sub architecture with one topic and two subscriptions based on the following diagram:

![Figure 10.25 – Pub/Sub architecture](../images/B18851_10_25.jpg)

Figure 10.25 – Pub/Sub architecture

We will work with the REST APIs located at <https://cloud.google.com/pubsub/docs/reference/rest>.

We will start with topic creation and use **REST Resource:** **v1.projects.topics API**:

1. First, we will use a **PUT HTTP** request, **https://pubsub.googleapis.com/v1/projects/{project}/topics/{topic}**, where we need to replace **{project}** with our project ID and **{topic}** with a new topic name:

![Figure 10.26 – Pub/Sub new topic creation with the REST API](../images/B18851_10_26.jpg)

Figure 10.26 – Pub/Sub new topic creation with the REST API

1. We can check whether the topic exists via a REST API call. We can run a **GET REST API** call with the **https://pubsub.googleapis.com/v1/projects/{PROJECT\_ID}/topics** URL. In our case, a topic was successfully created:

![Figure 10.27 – Pub/Sub new topic was created](../images/B18851_10_27.jpg)

Figure 10.27 – Pub/Sub new topic was created

1. Now, we have two topics, called **api-created-subscription-1** and **api-created-subscription-2**. We will use the **PUT** method and send it to **https://pubsub.googleapis.com/v1/projects/{PROJECT\_ID}/subscriptions/{SUBSCRIPTION\_NAME}**. As usual, we need to replace **PROJECT ID** and **SUBSCRIPTION NAME**. In addition, we need to add the following JSON payload in the **Body** section. We need to replace **TOPIC\_NAME** with the previously created topic and **SUBSCRIPTION\_NAME** with the new name of the topic we want to create:

   ```
   { "topic": "projects/{PROJECT_ID}/topics/{TOPIC_NAME}",
     "name": "{SUBSCRIPTION_NAME}" }
   ```

We will get the following output:

![Figure 10.28 – Pub/Sub new subscription was created](../images/B18851_10_28.jpg)

Figure 10.28 – Pub/Sub new subscription was created

1. These newly created subscriptions will also be visible in the Google Cloud console:

![Figure 10.29 – Pub/Sub sample architecture visible in the Google Cloud console](../images/B18851_10_29.jpg)

Figure 10.29 – Pub/Sub sample architecture visible in the Google Cloud console

As you can see, creating Google Cloud resources using APIs can be done much faster than in the Google Cloud console and they can easily be integrated into applications. This example focused on Pub/Sub, but more sophisticated architectures or applications can be created with all other Google Cloud services and their available APIs.

# Summary

Google Cloud and its data processing services cover many problems. We started by looking at messaging and leveraging Pub/Sub and Pub/Sub Lite to integrate various Google Cloud products. We then learned about Dataproc, where we can quickly run fully managed Apache Hadoop, Apache Spark, or Apache Pig clusters and process massive amounts of data. Finally, Dataflow, a fully managed Apache Beam-based product, allows us to develop, execute, and process data pipelines in a simple, fast, and scalable way.

At the end of this chapter, we discovered another way to interact with Google Cloud services – REST APIs. We learned how to authenticate with Google Cloud using OAuth 2.0 and how to perform simple HTTP REST API calls. We leveraged our knowledge to create a Pub/Sub topic and attach it to its subscriptions.

The next chapter will discuss Google Cloud’s operations suite (formerly Stackdriver), which provides a set of fully managed services for monitoring, logging, and tracing your applications and Google Cloud services. These services can help you improve the performance, reliability, and security of your applications.

# Questions

Answer the following questions to test your knowledge of this chapter:

1. Choose the correct statement about Pub/Sub:
   1. Pub/Sub is a synchronous messaging service.
   2. Pub/Sub is an asynchronous messaging service.
   3. Pub/Sub is a message broker.
   4. Pub/Sub is a distributed messaging system.
2. Pub/Sub consists of which of the following components?
   1. Teams and subscribers
   2. Publishers and subscribers
   3. Subscribers and broadcasters
   4. Broadcasters and receivers
3. Choose the incorrect Pub/Sub use case:
   1. Enterprise event bus
   2. Real-time event distribution
   3. Refreshing static caches
   4. Parallel processing and workflows
4. Choose the correct statement:
   1. Pub/Sub is the only messaging service available in Google Cloud.
   2. Pub/Sub and Pub/Sub Lite are messaging services available in Google Cloud.
   3. Google Cloud offers Apache Kafka as a service.
   4. Pub/Sub cannot be used as a service-to-service communication service.
5. Choose the correct statement about a Pub/Sub topic:
   1. A topic is an application that creates and sends messages.
   2. A topic is an application with a subscription to a single or multiple events.
   3. A topic is a named resource to which publishers send messages.
   4. A topic requires acknowledgment to proceed with the message.
6. When a Pub/Sub message is not acknowledged before its acknowledgment deadline has expired, what does Pub/Sub do?
   1. Pub/Sub resends the message.
   2. Pub/Sub deletes the message.
   3. Pub/Sub keeps the message in the queue until it is acknowledged.
   4. Pub/Sub does nothing.
7. Dataproc provides out-of-the-box and end-to-end support for many of the most popular job types, including which of the following?
   1. Pidgeon jobs, PySpark, and MapReduce
   2. Spark, Spark SQL, PySpark, MapReduce, Hive, and Pig jobs
   3. PySpark, MapReduce, Hive, and Anaconda
   4. Spark, Spark SQL, and MySQL
8. What development languages are supported in Dataproc?
   1. Java
   2. Java and Scala
   3. Scala
   4. Java, Scala, Python, and R
9. Choose two correct statements about Dataproc:
   1. After submitting the job in the Dataproc cluster, it can’t be stopped.
   2. It is possible to SSH into every machine from within the cluster.
   3. Dataproc only supports Debian and SUSE Linux distributions.
   4. Dataproc is billed on a per-second basis.
10. What is the main difference between Dataproc on GCE and Dataproc on GKE?
    1. Dataproc on GCE is faster.
    2. Dataproc on GKE requires an internal load balancer.
    3. Dataproc on GKE does not include separate master and worker VMs.
    4. Dataproc on GKE requires a separate GKE cluster and node pool.
11. Choose the correct statement about Dataproc web interfaces:
    1. Customers only have access to Spark History Server.
    2. Access to web interfaces costs additional fees.
    3. Customers can access YARN ResourceManager, MapReduce Job History, Spark History Server, HDFS NameNode, YARN Application Timeline, and Tez.
    4. To use additional Dataproc web interfaces, it is necessary to configure a site-to-site VPN.
12. Single-node Dataproc clusters are best suitable for which use cases? (Choose all that apply.)
    1. Trying out new versions of Spark and Hadoop
    2. Building a proof of concept
    3. Small-scale non-critical data processing
    4. Large-scale parallel data processing
    5. High-availability workloads
13. Choose the correct statement about Dataflow:
    1. Dataflow is a fully managed Apache Spark service.
    2. Dataflow is a fully managed Apache Kafka service.
    3. Dataflow is a fully managed Apache Beam service.
    4. Dataflow is a fully managed Apache Airflow service.
14. To use the Dataflow service, which API is needed to be enabled?
    1. **dataflew.googleapis.com**
    2. **dataflow.gogleapis.com**
    3. **dataflow.googleapis.com**
    4. **dataflow.googleapis.net**
15. Which **gcloud** command can be used to configure the default Dataproc region?
    1. **gcloud set config** **dataproc/region YOUR\_REGION**
    2. **gcloud config set region/dataproc -****r YOUR\_REGION**
    3. **cloud config set dataproc -****n YOUR\_REGION**
    4. **gcloud config ser** **dataproc/region YOUR\_REGION**
16. When configuring an OAuth client ID in **APIs & Services** under the **Credentials** section, what can you use to restrict the domains to which the application can send requests?
    1. Authorized JavaScript origins and authorized redirect URLs
    2. Authorized redirect URLs
    3. Authorized domains
    4. Authorized JavaScript origins
17. Google Cloud offers many ways to authenticate with APIs. Choose the correct ones:
    1. Authentication using client libraries
    2. Authenticate using REST
    3. Authenticate using API keys
    4. All of the above
18. Which API calls are valid?
    1. **GET**, **POST**, **REMOVE**, **UPDATE**
    2. **POST**, **REMOVE**, **TRACE**, **CONNECT**
    3. **TRACE**, **PATCH**, **GET**, **PUT**
    4. **SPOT**, **PUT**, **PATCH**, **TRACE**
19. Choose the correct statement:
    1. When making HTTP calls, we always receive a client and server response.
    2. **404 Not Found** means that the requested resource could not be found.
    3. **200 OK** means the request was successful, and the API call succeeded.
    4. **404 Bad Request** means the request was malformed or invalid.
20. Which API call can be used to check whether a Pub/Sub topic exists?
    1. **GET https://pubsub.googleapis.com/v1/projects/{PROJECT\_ID}/topics**
    2. **PUT https://pubsub.googleapis.com/v1/projects/{PROJECT\_ID}/topics**
    3. **GET** **https:// googleapis.com/pubsub/v1/projects/{PROJECT\_ID}/topics**
    4. **TRACE https://pubsub.googleapis.com/v1/projects/{PROJECT\_ID}/topics**

# Answers

The following are the answers to this chapter’s questions:

1B, 2B, 3C, 4B, 5C, 6A, 7B, 8D, 9BD, 10C, 11C, 12A, B, and C, 13C, 14C, 15C, 16A, 17D, 18C, 19BC, 20A