# 7

# Implementing Compute Solutions – Cloud Run, Cloud Functions, and Infrastructure as Code

This chapter aims to familiarize ourselves with various compute solutions and how to implement them.

We are going to cover the following main topics:

- Cloud Run
- Cloud Functions
- Infrastructure as Code
- Marketplace solutions

We will start with IaC, a stateless computing service where we can run containerized code. The next topic will be IaC, where we will learn about running code in response to events without provisioning or managing servers. Lastly, we will look at **Infrastructure as Code** (**IaC**), what benefits we can get by implementing it, and how to use IaC to deploy solutions.

# Cloud Run

Cloud Run, a managed serverless compute platform, offers easy microservice deployment without service-specific configuration. It provides a simple and unified developer experience and uses container images as the unit of deployment. With scalable serverless execution, microservices automatically scale based on incoming requests, eliminating the need for Kubernetes cluster management. Additionally, Cloud Run supports code written in any language, thanks to its container-based architecture.

Before using Cloud Run, we must learn how it works, the use cases, and its benefits.

## Cloud Run architecture

Cloud Run is a stateless computing environment where customers can run their containerized code on Google Cloud infrastructure. Cloud Run is a regional offering that benefits us with higher resiliency and availability. If one zone fails, Cloud Run could still provide the service. Higher availability is reflected by a service SLA of 99.95% a month.

Traffic to the services is automatically load-balanced across zones within a region, and container instances are automatically scaled up and down to meet incoming traffic.

To learn more about Cloud Run zonal redundancy, go to https://cloud.google.com/architecture/disaster-recovery#cloud-run.

### Cloud Run services

The main component of the Cloud Run architecture is called a **service**. Each service is in a specific Google Cloud region where you use Cloud Run. Each service exposes a unique endpoint and automatically scales the Cloud Run infrastructure to handle load and requests.

A service is used to run code that responds to web requests or events. Some workloads that run extensively as Cloud Run services are as follows:

- Websites and web applications
- APIs and microservices
- Event-driven architectures and streaming data processing

The following diagram shows the Cloud Run services architecture:

![Figure 7.1 – The Cloud Run services architecture__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_01.jpg)

Figure 7.1 – The Cloud Run services architecture

A Cloud Run service includes an internal load balancer, which distributes requests to containers.

A service includes the following features by default:

- **HTTPS endpoint**: Every Cloud Run service has an HTTP endpoint and unique subdomain from the **.run.app** domain that supports custom domain configuration. It includes a TLS certificate and supports **WebSockets**, **HTTP/2,** and **gRPC**. All of these are end-to-end.
- **Autoscaling**: Cloud Run has built-in autoscaling, which allows the service to scale up from one to thousands of containers. If the service demand is decreased, the service scales down by removing idle containers. It is possible to limit the maximum number of instances.
- **Traffic management**: Every service deployment creates a new immutable version. Built-in traffic management allows you to route whole traffic to the latest revision, roll back a previous revision, or split traffic into multiple revisions. It allows you to test the new version and reduce the risk of deploying new, untested revisions.

### Cloud Run revisions

Each deployment to service creates a **revision**. Once a revision has been created, it cannot be modified. If we wished to change the container image, we would need to create a new revision.

The following figure shows active requests connecting to **Service A** via **Revision A-3**. We have two older revisions of **Service A** that we can roll back to if needed. In parallel, we have two revisions of **Service B** that can be used to test the new version of the application:

![Figure 7.2 – Overview of the Cloud Run architecture__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_02.jpg)

Figure 7.2 – Overview of the Cloud Run architecture

Now that we’ve learned about services and revisions, we can move on to Cloud Run jobs and how they can be used to host workloads.

### Cloud Run jobs

A job is a collection of one or multiple independent tasks that are executed in parallel during the job execution. Each job is executed in a specific Google Cloud region and can run one or more containers until it is finished:

![Figure 7.3 – Array of jobs in Cloud Run__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_03.jpg)

Figure 7.3 – Array of jobs in Cloud Run

The preceding figure shows us a comparison between a job that might have one task and can be executed longer and an array of jobs that can be parallelized and run faster than a job.

Using a single job to perform one task can take much longer than creating a job with many independent tasks. In Cloud Run, identical jobs may run independently, creating an array job.

An example of an array job in Cloud Run could be batch image processing stored in Cloud Storage.

Cloud Run jobs are best suited to be used when the code performs a job and then stops. Here are some examples:

- Scripts or other operational tasks
- Parallel jobs
- Saving the results of a query

### Cloud Run for Anthos

We now know what use cases fit best when deploying on Cloud Run. Google Cloud has another offering for Cloud Run, called Cloud Run for Anthos. You might be wondering, what is Anthos? Anthos is a Google cloud-native platform that allows to deploy and manage applications consistently across on-premises environments, the edge, and multiple clouds. It is a unified platform that provides a consistent development and operations experience for all your applications, regardless of where they run. Anthos isn’t part of the Associate Cloud Engineer certification, but if you want to learn [more about Anthos, go to https](https://cloud.google.com/anthos)://cloud.google.com/anthos.

The Cloud Run for Anthos architecture can be seen in the following diagram:

![Figure 7.4 – Overview of Cloud Run for Anthos__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_04.jpg)

Figure 7.4 – Overview of Cloud Run for Anthos

Cloud Run for Anthos abstracts away the complexity of Kubernetes, allowing easy build and application deployment across hybrid and multi-cloud environments. Cloud Run for Anthos is a Knative open source project that enables serverless workloads on Kubernetes.

## Cloud Run application deployment

Now that we’ve learned about the Cloud Run architecture and two possible application deployment types, it is time to deploy our first application – a service:

1. We will start by clicking the **CREATE** **SERVICE** button:

![Figure 7.5 – Initial screen before deploying the Cloud Run application__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_05.jpg)

Figure 7.5 – Initial screen before deploying the Cloud Run application

1. We can choose from any container image we wish, but in our case, we will use a sample container provided by Google Cloud. To do so, we need to click the **TEST WITH A SAMPLE** **CONTAINER** button:

![Figure 7.6 – Cloud Run application deployment using a sample container provided by Google Cloud__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_06.jpg)

Figure 7.6 – Cloud Run application deployment using a sample container provided by Google Cloud

1. We can allocate CPU where we are charged for the entire life cycle of the container instance or use CPU only when requests are processed.
2. In the **Autoscaling** section, we can choose the minimum and maximum number of instances. By default, the minimum is set to **0**. We must allocate at least one container to improve the application’s latency. To learn more about **cold start** in Cloud Run, go to https://cloud.google.com/run/docs/tips/general?authuser=4#start\_containers\_quickly:

![Figure 7.7 – The Autoscaling option of Cloud Run for specifying the minimum and maximum number of instances__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_07.jpg)

Figure 7.7 – The Autoscaling option of Cloud Run for specifying the minimum and maximum number of instances

1. The next option is choosing service access from internal Google Cloud resources or from everywhere:

![Figure 7.8 – Cloud Run traffic configuration – internal traffic or direct traffic from the internet__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_08.jpg)

Figure 7.8 – Cloud Run traffic configuration – internal traffic or direct traffic from the internet

1. We can allow unauthenticated service invocations or force authorization with Cloud IAM in the **Authentication** section. We will choose **Allow** **unauthenticated invocations**:

![Figure 7.9 – Cloud Run authentication configuration__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_09.jpg)

Figure 7.9 – Cloud Run authentication configuration

1. In the following sections – **Container**, **Networking**, and **Security** – we can fine-tune container deployment details such as capacity (the amount of memory, CPU, timeouts, or execution environment), HTTP2 or session configuration, and service account. We encourage you to try various options while learning Cloud Run. We will proceed with the default options.
2. We can access the application via its unique URL after deployment:

![Figure 7.10 – The Cloud Run application is live__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_10.jpg)

Figure 7.10 – The Cloud Run application is live

1. After visiting the URL in our browser, we can access the live application:

![Figure 7.11 – Cloud Run application accessed from the browser__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_11.jpg)

Figure 7.11 – Cloud Run application accessed from the browser

Now that we’ve successfully deployed our first service, it is time to dive deeper into revisions and traffic management.

## Cloud Run application revisions

The following steps are based on the previously deployed sample container and look at the case where we want to update or change the container image we used previously. What do we do?

1. First, we need to find an image we can use to replace our existing container or change image content.
2. We will use several images to demonstrate revisions: Nginx and Apache HTTP Server images.
3. Let's start with Nginx. For this, we need to click the **EDIT & DEPLOY NEW** **REVISION** button:

![Figure 7.12 – New revision in Cloud Run__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_12.jpg)

Figure 7.12 – New revision in Cloud Run

1. We will change the container image URL to a new one – **nginx** – and We will change the container port from **8080** to **80** while leaving all the other settings as-is:

![Figure 7.13 – New container image and container port in the new Cloud Run revision__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_13.jpg)

Figure 7.13 – New container image and container port in the new Cloud Run revision

1. Finally, we need to click the **Deploy** button.
2. In our case, as the image was small, the deployment took about 5 seconds. After revisiting the unique URL, we will see that the content has changed:

![Figure 7.14 – The new container has been deployed as a new revision__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_14.jpg)

Figure 7.14 – The new container has been deployed as a new revision

1. In Cloud Console, we can see that a new revision has been deployed and that it’s serving 100% traffic:

![Figure 7.15 – New revision visible in Cloud Console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_15.jpg)

Figure 7.15 – New revision visible in Cloud Console

1. We deployed Apache HTTP Server with the **httpd** Docker image, where 100% of traffic is served:

![Figure 7.16 – HTTPD container created with a new version where 100% of traffic is served__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_16.jpg)

Figure 7.16 – HTTPD container created with a new version where 100% of traffic is served

1. When we visit the application URL, we’ll see that the content has changed:

![Figure 7.17 – HTTPD container in a browser__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_17.jpg)

Figure 7.17 – HTTPD container in a browser

In this section, We showed you how easy it is to deploy new revisions of applications. It can be the exact container or a different one. We can do it very quickly and without any hassle. In the next section, we will show you how to manage traffic between revisions.

## Cloud Run traffic management

Cloud Run allows you to specify which revision should receive traffic. It can be the latest revision, and you can split the traffic by percentages between different revisions. It is possible to use tags for testing, traffic migration, and rollbacks.

To manage the traffic in a service, we need to navigate to **Service** and click **REVISIONS**. Once we’re in the **Revisions** section of the service, we can click the **MANAGE** **TRAFFIC** button:

![Figure 7.18 – Overview of a service with multiple revisions__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_18.jpg)

Figure 7.18 – Overview of a service with multiple revisions

We will be presented with the **Manage traffic** window, where we can decide how network traffic flows:

![Figure 7.19 – Overview of a service with multiple revisions__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_19.jpg)

Figure 7.19 – Overview of a service with multiple revisions

We can decide how to distribute traffic between different revisions in this window.

For example, we can direct 50% of it to the latest healthy revision and the remaining 50% to another revision:

![Figure 7.20 – Network traffic split between two revisions__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_20.jpg)

Figure 7.20 – Network traffic split between two revisions

After a moment, the internal load balancer will distribute network traffic as desired:

![Figure 7.21 – Network traffic split between two revisions in place__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_21.jpg)

Figure 7.21 – Network traffic split between two revisions in place

Similarly, we can roll back the changes or distribute traffic further across revisions of our application.

In the next section, we will focus on autoscaling and concurrent requests.

## Cloud Run Traffic autoscaling

Before we start with the autoscaling concept in Cloud Run, we need to determine the limits of the Cloud Run instances. By default, Cloud Run services are configured to a maximum of 100 instances, and the default values for capacity are as follows:

- CPU: 1
- Memory: 512 MiB
- Request timeout: 300 seconds
- Maximum requests per container: 80
- Container instances: 30

At the time of writing, this book’s maximums apply to Cloud Run:

- CPU: 8
- Memory: 34 GiB
- Request timeout: 3,600 seconds
- Maximum requests per container: 1,000
- Maximum container instances *(quota increase* *needed)*: 1,000

Cloud Run allows us to control the number of requests per instance precisely. Sometimes, you can lower the maximum concurrency to 1 if your code cannot process parallel requests; each request uses most of the available CPU and memory. Setting the maximum concurrency to 1 will likely negatively affect scaling performance due to the need to start many container instances before they can handle incoming requests.

To learn more about Cloud Run concurrency, go to <https://cloud.google.com/run/docs/about-concurrency>.

Cloud Run is a fantastic service, and we highly encourage you to try it out, explore its options, and have fun with it. To learn more about Cloud Run development tips, visit <https://cloud.google.com/run/docs/tips/general>.

The next section of this chapter will focus on another serverless product: Cloud Functions.

# Cloud Functions

Cloud Functions, which falls under category of **Function-as-a-Service** (**FaaS**), is a serverless execution environment where we can run code without provisioning or managing any infrastructure. Cloud Functions is executed in a fully managed and serverless environment – you don’t need to provision infrastructure or manage servers. Functions are triggered when an event being watched occurs.

## Cloud Functions overview

The main advantage of Cloud Functions in Google Cloud is that you only need to write your code. Everything else will be done for you; there is no need to manage any infrastructure. Cloud Functions integrates very well within the Google Cloud products ecosystem. Functions listen and respond to various events – for example, when you upload an object to Cloud Storage, the function detects it and can invoke action.

Cloud Functions’ use cases are most likely limited to our creativity, but I’d like to list just a few of the use cases used by Google Cloud customers:

- **Webhooks**: We can use HTTP triggers to respond to events from other systems such as GitHub, GitLab, Slack, or any software that sends HTTP requests. For example, we can create a Slack command that searches the Google Knowledge Graph API.
- **Data processing**: This involves listening and responding to Google Cloud Storage events – object creation, change, or deletion. For example, we can perform image processing, video transcoding, or data validation once data has been uploaded to Cloud Storage.
- **Lightweight APIs**: You can build your applications by combining different cloud functions.
- **Mobile backend**: You can use the Google Cloud mobile platform application product known as Firebase and write the backend in Cloud Functions.
- **IoT**: This is the ideal solution for a fleet of devices streaming data into Pub/Sub while invoking Cloud Functions to process, transform, and store data.

## Events and triggers

Events are, generally speaking, things that happen in your cloud environment. The broadness of Google Cloud services allows users to interact when changes in databases, files, or virtual machines are made by responding to those events.

After an event, we have the option to respond to them. This response is called a trigger. By connecting the two, we can create sophisticated functions that can do some exciting work – fully automated and at scale.

## Cloud Functions versions

Google Cloud offers two versions of Cloud Functions – 1st and 2nd generation. As anyone could expect, 2nd generation offers multiple improvements over the 1st generation.

To view a detailed comparison of the two generations, go to <https://cloud.google.com/functions/docs/concepts/version-comparison#comparison-table>.

Another essential feature is that the 2nd generation of Cloud Functions is built on Cloud Run, which was described earlier in this chapter. It also supports Eventarc – Google Cloud’s approach to interacting with various services withi[n Google Cloud.](https://cloud.google.com/eventarc/docs/overview)

[To learn more about Google Ev](https://cloud.google.com/eventarc/docs/overview)entarc, go to https://cloud.google.com/eventarc/docs/overview.

## Google Cloud Functions example

Now that you’ve learned what Cloud Functions is, I’d like to show you how to implement a sample Cloud Function.

We will guide you through **optical character recognition** (**OCR**) on Google Cloud Platform with Cloud Functions.

Our use case is as follows:

1. An image with text is uploaded to Cloud Storage.
2. A triggered Cloud Function utilizes the Google Cloud Vision API to extract the text and identify the source language.
3. The text is queued for translation by publishing a message to a Pub/Sub topic.
4. A Cloud Function employs the Translation API to translate the text and stores the result in the translation queue.
5. Another Cloud Function saves the translated text from the translation queue to Cloud Storage.
6. The translated results are available in Cloud Storage as individual text files for each translation.

We need to download the samples first; we will use Golang as th[e programming language. Source files can be downloaded fr](https://github.com/GoogleCloudPlatform/golang-samples.git)om – <https://github.com/GoogleCloudPlatform/golang-samples>. Before working with the OCR function sample, we recommend enabling the Cloud Translation API and the Cloud Vision API. If they are not enabled, your function will throw errors, and the process will not be completed.

Let’s start with deploying the function:

1. We need to create a Cloud Storage bucket. Create your own bucket with unique name – please refer to documentation on bucket naming under following link: <https://cloud.google.com/storage/docs/buckets>. We will use the following code:

   ```
   gsutil mb gs://wojciech_image_ocr_bucket
   ```
2. We also need to create a second bucket to store the results:

   ```
   gsutil mb gs://wojciech_image_ocr_bucket_results
   ```
3. We must create a Pub/Sub topic to publish the finished translation results. We can do so with the following code: **gcloud pubsub topics create YOUR\_TOPIC\_NAME**. We used the following command to create it:

   ```
   gcloud pubsub topics create wojciech_translate_topic
   ```
4. Creating a second Pub/Sub topic to publish translation results is necessary. We can use the following code to do so:

   ```
   gcloud pubsub topics create wojciech_translate_topic_results
   ```
5. Next, we will clone the Google Cloud GitHub repository with some Python sample code:

   ```
   git clone https://github.com/GoogleCloudPlatform/golang-samples
   ```
6. From the repository, we need to go to the **golang-samples/functions/ocr/app/** file to be able to deploy the desired Cloud Function.
7. We recommend reviewing the included **go** files to review the code and understand it in more detail. Please change the values of your storage buckets and Pub/Sub topic names.
8. We will deploy the first function to process images. We will use the following command:

   ```
   gcloud functions deploy ocr-extract-go --runtime go119 --trigger-bucket wojciech_image_ocr_bucket --entry-point ProcessImage --set-env-vars "^:^GCP_PROJECT=wmarusiak-book-351718:TRANSLATE_TOPIC=wojciech_translate_topic:RESULT_TOPIC=wojciech_translate_topic_results:TO_LANG=es,en,fr,ja"
   ```
9. After deploying the first Cloud Function, we must deploy the second one to translate the text. We can use the following code snippet:

   ```
   gcloud functions deploy ocr-translate-go --runtime go119 --trigger-topic wojciech_translate_topic --entry-point TranslateText --set-env-vars "GCP_PROJECT=wmarusiak-book-351718,RESULT_TOPIC=wojciech_translate_topic_results"
   ```
10. The last part of the complete solution is a third Cloud Function that saves results to Cloud Storage. We will use the following snippet of code to do so:

    ```
    gcloud functions deploy ocr-save-go --runtime go119 --trigger-topic wojciech_translate_topic_results --entry-point SaveResult --set-env-vars "GCP_PROJECT=wmarusiak-book-351718,RESULT_BUCKET=wojciech_image_ocr_bucket_results"
    ```
11. We are now free to upload any image containing text. It will be processed first, then translated and saved into our Cloud Storage bucket.
12. We uploaded four sample images that we downloaded from the Internet that contain some text. We can see many entries in the **ocr-extract-go** Cloud Function’s logs. Some Cloud Function log entries show us the detected language in the image and the other extracted text:

![Figure 7.22 – Cloud Function logs from the ocr-extract-go function__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_22.jpg)

Figure 7.22 – Cloud Function logs from the ocr-extract-go function

1. **ocr-translate-go** translates detected text in the previous function:

![Figure 7.23 – Cloud Function logs from the ocr-translate-go function__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_23.jpg)

Figure 7.23 – Cloud Function logs from the ocr-translate-go function

1. Finally, **ocr-save-go** saves the translated text into the Cloud Storage bucket:

![Figure 7.24 – Cloud Function logs from the ocr-save-go function](../images/B18851_07_24.jpg)

Figure 7.24 – Cloud Function logs from the ocr-save-go function

1. If we go to the Cloud Storage bucket, we’ll see the saved translated files:

![Figure 7.25 – Translated images saved in the Cloud Storage bucket__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_25.jpg)

Figure 7.25 – Translated images saved in the Cloud Storage bucket

1. We can view the content directly from the Cloud Storage bucket by clicking **Download** next to the file, as shown in the following screenshot:

![Figure 7.26 – Translated text from Polish to English stored in the Cloud Storage bucket__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_26.jpg)

Figure 7.26 – Translated text from Polish to English stored in the Cloud Storage bucket

Cloud Functions is a powerful and fast way to code, deploy, and use advanced features. We encourage you to try out and deploy Cloud Functions to understand the process of using them better.

At the time of writing, Google Cloud Free Tier offers a generous number of free resources we can use. Cloud Functions offers the following with its free tier:

- 2 million invocations per month (this includes both background and HTTP invocations)
- 400,000 GB-seconds, 200,000 GHz-seconds of compute time
- 5 GB network egress per month

Google Cloud has comprehensive tutorials that you can try to deploy. Go to <https://cloud.google.com/functions/docs/tutorials> to follow one.

Now that we’ve covered the serverless products in Google Cloud, we will learn about IaC.

# Infrastructure as Code

IaC is a new way to deploy and manage infrastructure. It doesn’t only apply to cloud resources but to on-premises resources – for example, VMware vSphere. However, this book and this chapter will focus on IaC deployment in Google Cloud.

We briefly mentioned IaC in *Chapter 2*, where we discussed various ways of deploying resources in Google Cloud – Cloud Foundation Toolkit, Config Connector, and Terraform.

IaC aims to solve main issues from the past – lengthy time to deliver resources, errors during the deployment, ease of implementation, and the overall complexity of IT resource management.

## Config Connector in Google Kubernetes Engine

In [*Chapter 5*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_05.xhtml#_idTextAnchor095) and *6* we learned how to create, configure, and use **Google Kubernetes Engine** (**GKE**) to deploy applications. We will use that knowledge to install, configure, and deploy Config Connector and Google Cloud resources. Config Connector is an open source Kubernetes add-on that allows us to manage Google Cloud resources in a Kubernetes way.

To use Config Connector, there are a few prerequisites that GKE needs to have:

- GKE version:
  - **1.15.11-gke.5** and later
  - **1.16.8-gke.8** and later
  - **1.17.4-gke.5** and later
- A Workload Identity Pool needs to be enabled
- GKE monitoring must be enabled

We will start by installing Config Connector on the newly created GKE cluster.

### Installing Config Connector

As mentioned previously, Config Connector is an add-on to GKE. We can enable it during GKE cluster creation or reconfigure the existing GKE cluster to support it.

#### New GKE cluster

As mentioned previously, we must ensure that all the prerequisites have been met:

1. Go to GKE in Cloud Console.
2. Click **Create** and choose **GKE Standard**.
3. Provide the name of your GKE cluster.
4. Choose the supported GKE master version.
5. In the **Security** part of the cluster, select **Enable** **Workload Identity**:

![Figure 7.27 – Workload Identity configuration in the Security section of the newly created GKE cluster__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_27.jpg)

Figure 7.27 – Workload Identity configuration in the Security section of the newly created GKE cluster

1. In the **Features** section of the cluster, click **Enable** **Config Connector**:

![Figure 7.28 – Config Connector configuration in the Security section of the newly created GKE cluster__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_28.jpg)

Figure 7.28 – Config Connector configuration in the Security section of the newly created GKE cluster

1. Monitoring must also be enabled and selected by default with newly created GKE clusters.
2. Now that we’ve created the cluster, Config Connector is ready to be used.

Next, we will enable Config Connector in the existing GKE cluster.

#### Existing GKE cluster

To enable Config Connector in the existing GKE cluster, we must enable the Config Connector add-on, enable Workload Identity, and create an Workload Identity:

1. Prior to doing any work with the existing GKE cluster, we need to authenticate with it to be able to run any command
2. We can use following command:

   ```
   gcloud container clusters get-credentials YOUR_CLUSTER_NAME  --zone=ZONE --project=YOUR_PROJECT_NAMENAME
   ```
3. Once authenticated, we can enable Workload Identity on the existing cluster with the following command:

   ```
   gcloud container clusters update CLUSTER_NAME 
       --region=COMPUTE_REGION \
       --workload-pool=PROJECT_ID.svc.id.goog
   ```
4. In our case, we used following code:

   ```
   gcloud container clusters update cluster-1 --region=us-central1-c --workload-pool=wmarusiak-book.svc.id.goog
   ```
5. Then, we need to enable Config Connector. To do this, we need to use following gcloud command:

   ```
   gcloud container clusters update CLUSTER_NAME --zone=YOUR_ZONE --update-addons ConfigConnector=ENABLED
   ```

After enabling the Config Connector add-on and Workload Identity in an existing GKE cluster, we can proceed with IAM resources creation.

Config Connector creates and manages Google Cloud resources by using an **Identity and Access Management** (**IAM**) service account to authenticate with Google Cloud. It then uses GKE’s Workload Identity to bind the IAM service account to a Kubernetes service account. This allows Config Connector to access and manage Google Cloud resources on behalf of the Kubernetes cluster.

1. First, we need to create a workload identity. We need one because Config Connector authenticates with IAM to create and manage Google Cloud resources.
2. We will create a new service account using the following code:

   ```
   gcloud iam service-accounts create gke-workload-identity-sa
   ```
3. Next, we must grant elevated permission to the IAM service account in our project. Similar to the Pub/Sub section, please change the project and other values used in the following commands:

   ```
   gcloud projects add-iam-policy-binding wmarusiak-book --member="serviceAccount:gke-workload-identity-sa@wmarusiak-book.iam.gserviceaccount.com" --role="roles/editor"
   ```
4. The last step is to create an IAM policy binding between the IAM service account and the predefined GKE service account that Config Connector uses. To do so, we need to run the following command:

   ```
   gcloud iam service-accounts add-iam-policy-binding gke-workload-identity-sa@wmarusiak-book.iam.gserviceaccount.com --member="serviceAccount:wmarusiak-book.svc.id.goog[cnrm-system/cnrm-controller-manager]" --role="roles/iam.workloadIdentityUser"
   ```
5. Now, we need to create the **configconnector.yaml** file with the following content. To apply it to the existing GKE cluster, we need to run the **kubectl apply** **-f** **configconnector.yaml** **command:**

   ```
   # configconnector.yaml apiVersion: core.cnrm.cloud.google.com/v1beta1
   kind: ConfigConnector metadata:
    # the name is restricted to ensure that there is only one
    # ConfigConnector resource installed in your cluster name: configconnector.core.cnrm.cloud.google.com
   spec:
    mode: cluster googleServiceAccount: "gke-workload-identity-sa@wmarusiak-book.iam.gserviceaccount.com"
   ```
6. After a moment, we can check if the Config Connector resources have been created. We can use the **kubectl get pods -A** **| grep** **config** **command:**

![Figure 7.29 – Config Connector resources created in the kube-system namespace__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_29.jpg)

Figure 7.29 – Config Connector resources created in the kube-system namespace

1. We must configure the resource destination before creating any resource with Config Connector. Resources can be created at the project, folder, or organization level. But first, we must create a GKE namespace. we will use the following command:

   ```
   kubectl create namespace config-connector
   ```
2. I will choose to organize resources at the project level. I will use the following command to configure this:

   ```
   kubectl annotate namespace config-connector cnrm.cloud.google.com/project-id=project_ID
   ```

If you wish, you can organize resources at the folder level by changing the annotation to **kubectl annotate namespace config-connector cnrm.cloud.google.com/folder-id=config\_connector\_folder** or **kubectl annotate namespace** **config-connector cnrm.cloud.google.com/organization-id=ORGANIZATION\_ID**.

1. To verify the installation, we can run the following command:

   ```
   kubectl wait -n cnrm-system --for=condition=Ready pod --all
   ```

We will get the following output:

![Figure 7.30 – Config Connector is correctly installed in the cluster__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_30.jpg)

Figure 7.30 – Config Connector is correctly installed in the cluster

Now that we’ve learned how to configure Config Connector on the newly created GKE cluster and existing GKE cluster, we can create, modify, and delete Google Cloud resources.

### Practical usage of Config Connector

Cloud Config supports [many Google Cloud services. The complete list of supported servi](https://cloud.google.com/config-connector/docs/reference/overview)ces can be found at <https://cloud.google.com/config-connector/docs/reference/overview>.

We will create a Cloud Storage bucket using Config Connector as a sample resource.

Config Connector describes each resource well and provides some sample YAML code:

![Figure 7.31 – Config Connector sample YAML code__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_31.jpg)

Figure 7.31 – Config Connector sample YAML code

The code to create a Cloud Storage bucket looks like this:

```
apiVersion: storage.cnrm.cloud.google.com/v1beta1 kind: StorageBucket
metadata:
  annotations:
    cnrm.cloud.google.com/force-destroy: "false" labels:
    label-one: "value-one" name: wmarusiak-cc-bucket
spec:
  lifecycleRule:
    - action:
        type: Delete condition:
        age: 7 versioning:
    enabled: true uniformBucketLevelAccess: true
```

To create a resource, we need to save the code as a YAML file and apply it using the following command:

```
kubectl apply -f YOUR_FILENAME.YAML
```

After a moment, resource creation will be completed:

![Figure 7.32 – Cloud Storage bucket created by Config Connector__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_32.jpg)

Figure 7.32 – Cloud Storage bucket created by Config Connector

We can edit the previous YAML file to change the Cloud Storage bucket configuration. Let’s add additional labels and an additional life cycle rule:

```
apiVersion: storage.cnrm.cloud.google.com/v1beta1 kind: StorageBucket
metadata:
  annotations:
    cnrm.cloud.google.com/force-destroy: "false" labels:
    label-one: "value-one" label-two: "value-two"
  name: wmarusiak-cc-bucket spec:
  lifecycleRule:
    - action:
        storageClass: NEARLINE type: SetStorageClass
      condition:
        age: 7
    - action:
        type: Delete condition:
        age: 365 versioning:
    enabled: true uniformBucketLevelAccess: true
```

We must apply the file using the same command that we used previously:

![Figure 7.33 – An additional life cycle rule has been added to the bucket__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_33.jpg)

Figure 7.33 – An additional life cycle rule has been added to the bucket

We can also see that an additional label was added to the bucket configuration:

![Figure 7.34 – An additional label has been added to the bucket__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_34.jpg)

Figure 7.34 – An additional label has been added to the bucket

After changing the resource, we can remove it. We can do this using **kubectl delete --namespace CC\_NAMESPACE -f your\_resource.YAML**. In our case, the command will be **kubectl delete --namespace config-connector -****f config-connector-cloud-storage.yaml**.

To confirm that the Cloud Storage bucket was deleted, we can check the logs in Logs Explorer:

![Figure 7.35 – Confirming that the Cloud Storage bucket has been deleted in Logs Explorer__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_35.jpg)

Figure 7.35 – Confirming that the Cloud Storage bucket has been deleted in Logs Explorer

Config Connector allows us to easily create and manage Google Cloud resources in a Kubernetes way. The following section focuses on managing Google Cloud resources using Terraform.

## Terraform

In [*Chapter 2*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_02.xhtml#_idTextAnchor027) we briefly touched upon Terraform as part of the possible ways to manage Google Cloud resources. This book and its content focus on the Google Cloud Associate Cloud Engineer certification. We will briefly touch upon Terraform as one of the ways to deploy IaC. Many blog articles and books describe Terraform and other Hashicorp products in much greater detail; we recommend checking them out if you wish to use Terraform as your IaC deployment tool.

Fortunately for us, Cloud Shell includes Terraform as one of the base tools. Terraform is a tool that can be installed on many platforms, such as macOS, Windows, Linux, and many others. To install Terraform on your operating system, go to <https://developer.hashicorp.com/terraform/downloads>, which contains guides on various operating systems.

### Practical Terraform implementation

There is no better way to learn than to get our hands dirty and implement the code. Let’s get started:

1. We will start in Cloud Shell by creating the terraform directory.
2. Per Terraform’s best practices, we will create a file called **main.tf**.
3. We will specify the Terraform provider as **hashicorp/google**:

   ```
   terraform { required_providers {
       google = { source = "hashicorp/google"
         version = "4.51.0" }
     }
   }
   provider "google" { project = "wmarusiak-terraform-project"
     region  = "europe-west4" zone    = "europe-west4-c"
   }
   resource "google_compute_network" "vpc_network" { name = "terraform-network"
   }
   ```
4. This section of the code deploys a new project (if one doesn’t exist) and creates a VPC network named **terraform-network**.
5. Before we can use the code, we need to initiate the Terraform provider. To do so, we must use the **terraform** **init** command:

![Figure 7.36 – Successfully initializing the Terraform provider__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_36.jpg)

Figure 7.36 – Successfully initializing the Terraform provider

1. Before we implement the code, it is a good practice to validate our code and check which resources the code creates. We can use the **terraform apply** command to do this, which checks if we have permission to create specified resources and gives us an overview of the resources to be created. To validate the code, we can use the **terraform validate** command. To show changes that are required by the current configuration, we need to use the **terraform** **plan** command:

![Figure 7.37 – Terraform validates and shows the execution plan__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_37.jpg)

Figure 7.37 – Terraform validates and shows the execution plan

1. Finally, we can use the **terraform apply** command to create the resources. As a final check, we will be asked if we want to create specified resources; we need to type **yes** to execute the code.
2. After a moment, the code will be implemented, and we can use the newly created resources:

![Figure 7.38 – Terraform code execution completed__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_38.jpg)

Figure 7.38 – Terraform code execution completed

1. After successfully implementing code with Terraform, we can delete the resources that were created using the **terraform** **destroy** command.
2. After a moment, the resources will be deleted:

![Figure 7.39 – Resource deletion is finished__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_39.jpg)

Figure 7.39 – Resource deletion is finished

As this example has shown, using Terraform in Google Cloud is straightforward.

### Terraform best practices

Google Cloud has published Terraform’s best practices at <https://cloud.google.com/docs/terraform/best-practices-for-terraform>. These best practices cover topics such as the following:

- Module structure
- Naming conventions
- Using variables
- And many more

Similar cloud-agnostic Hashicorp-provided best practices for using Terraform are available at - <https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices>

With the recent updates, Google Cloud introduced a possibility to view Terraform Code when we create a new virtual machine. You can view the Terraform code snippet after clicking the on **Equivalent Code** button in the Google Compute Engine section.

In the next section, we will build on the skills we’ve learned in this section and implement a sample template in the Google Cloud project.

## Cloud Foundation Toolkit

**Cloud Foundation Toolkit** (**CFT**) is a set of reference templates that reflect Google Cloud best practices. CFT-provided templates can be used to quickly build repeatable enterprise-ready environments in Google Cloud. CFT can be deployed using Deployment Manager or Terraform. Google Cloud provides Terraform blueprints and modules that can be used immediately.

For the list of all blueprints, go to <https://cloud.google.com/docs/terraform/blueprints/terraform-blueprints>.

Let’s check one of the templates and examine the settings we can configure in it. I’ve selected the Cloud VPN template available at <https://github.com/terraform-google-modules/terraform-google-vpn>.

As we learned in the previous section, the **main.tf** file will consist of the main code for our template:

```
resource "google_compute_router" "cr-uscentral1-to-prod-vpc" { name    = "cr-uscentral1-to-prod-vpc-tunnels"
  region  = "us-central1" network = "default"
  project = var.project_id bgp {
    asn = "64519" }
}
module "vpn-prod-internal" { source  = "terraform-google-modules/vpn/google"
  version = "~> 1.2.0" project_id         = var.project_id
  network            = "default" region             = "us-west1"
  gateway_name       = "vpn-prod-internal" tunnel_name_prefix = "vpn-tn-prod-internal"
  shared_secret      = "secrets" tunnel_count       = 1
  peer_ips           = ["1.1.1.1", "2.2.2.2"]
  route_priority = 1000 remote_subnet  = ["10.17.0.0/22", "10.16.80.0/24"]
}
module "vpn-manage-internal" { source  = "terraform-google-modules/vpn/google"
  version = "~> 1.2.0" project_id         = var.project_id
  network            = "default" region             = "us-west1"
  gateway_name       = "vpn-manage-internal" tunnel_name_prefix = "vpn-tn-manage-internal"
  shared_secret      = "secrets" tunnel_count       = 1
  peer_ips           = ["1.1.1.1", "2.2.2.2"]
  route_priority = 1000 remote_subnet  = ["10.17.32.0/20", "10.17.16.0/20"]
}
```

This code can be adjusted to our needs and easily deployed with Terraform commands.

Google Cloud also offers a GitHub repositor[y for creating](https://github/) an environment that is fully configured with best practices. The GitHub repository is available at <https://github.com/terraform-google-modules/terraform-example-foundation>.

It consists of many stages and is highly adjustable to our needs. Try various Google Cloud Terraform templates to build secure, enterprise-ready Google Cloud environments and resources.

The following section will focus on browsing and deploying Google Cloud Marketplace solutions.

# Marketplace solutions

Google Cloud Marketplace is a catalog of third-party software that is integrated with Google Cloud Platform and ready to deploy in just a few clicks. The Google Cloud ecosystem is broad and consists of many products. However, some of them might not be available as native solutions. For example, let’s say you have been using GitLab in the past and would like to use it in Google Cloud. Google Cloud offers its products with Git functionality, but you need to use certain features from GitLab and don’t want to deploy it yourself.

In that case, Google Cloud Marketplace comes to the rescue:

![Figure 7.40 – Google Cloud Marketplace__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_40.jpg)

Figure 7.40 – Google Cloud Marketplace

The preceding screenshot shows that there are various options to choose from. In the search field, you can type in the product or solution you want to use, and within a few clicks, it will be up and running.

## Marketplace solution deployment

Let’s go through a sample Marketplace solution deployment. In Google Cloud Marketplace’s search area, we will specify **wordpress**, one of the most popular blogging platforms, so that we can deploy WordPress automatically on Google Cloud:

![Figure 7.41 – WordPress offering in Google Cloud Marketplace__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_41.jpg)

Figure 7.41 – WordPress offering in Google Cloud Marketplace

From the 77 results, we will select one to be deployed in our Google Cloud project. After selecting the product, we are redirected to the **Product** **details** area:

![Figure 7.42 – The openlitespeed-wordpress WordPress offering in Google Cloud Marketplace__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_42.jpg)

Figure 7.42 – The openlitespeed-wordpress WordPress offering in Google Cloud Marketplace

After clicking **Launch**, we can proceed with the deployment. If some Google Cloud APIs aren’t enabled, we can enable them via a pre-deployment check:

![Figure 7.43 – Pre-deployment checks in Marketplace__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_43.jpg)

Figure 7.43 – Pre-deployment checks in Marketplace

After enabling missing APIs, we will be redirected to the offering configuration page, where we can adjust any settings and see the pricing summary:

![Figure 7.44 – Marketplace offering configuration page__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_44.jpg)

Figure 7.44 – Marketplace offering configuration page

Once we’ve configured everything, we’ll be redirected to the **Deployment Manager** page, where we can track deployment progress:

![Figure 7.45 – Marketplace offering deployment progress__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_45.jpg)

Figure 7.45 – Marketplace offering deployment progress

Once the deployment has been completed, we can start using the product. In our case, we can log in as a WordPress administrator and start blogging:

![Figure 7.46 – Marketplace offering deployment progress__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_07_46.jpg)

Figure 7.46 – Marketplace offering deployment progress

Once the resource is not needed anymore, we can quickly delete it. As there are many Marketplace offerings, we encourage you to try and deploy them yourself.

# Summary

This chapter focused on the last of the compute solutions available in Google Cloud. We started with Google Cloud Run, which offers a serverless experience via containers. Then, we jumped into Cloud Functions, where serverless and event-based functions can run code without the need to provision or manage infrastructure. After, we explored the fantastic World of IaC with Terraform. We finalized this chapter by looking at Google Cloud Marketplace, which allows us to consume predefined, pre-configured, and tightly integrated offerings.

In the upcoming chapter, we will jump into the topic of data storage in Google Cloud. We will learn about different storage types, including object storage with Google Cloud Storage, block storage for local and persistent disks in Compute Engine VMs and GKE, file storage using Filestore, relational databases such as Cloud SQL and Spanner, NoSQL databases such as Cloud Bigtable and Firestore, data warehousing through BigQuery, and in-memory database solutions such as Memorystore.

# Questions

Answer the following questions to test your knowledge of this chapter:

1. You have been tasked with deploying an application deployed as a Cloud Function. Which of the programming languages are supported? (Choose all that apply.)
   1. PHP
   2. Ruby
   3. Java
   4. Go
   5. Python
   6. Node.js
   7. PowerShell
   8. C++
   9. C#
2. What steps should you take to follow Google’s recommended practices for efficiently deploying and managing the development, test, and production environments for your project deployment in Google Cloud while ensuring consistency? Your team is responsible for building these environments:
   1. Use Cloud Foundation Toolkit, create one deployment template that works for all environments, and deploy it with Terraform.
   2. Create one configuration for all environments in Terraform. Use parameters for different environments.
   3. Create a Cloud Shell script that uses **gcloud** commands to deploy all environments.
   4. Upload Cloud Foundation Toolkit in Marketplace
3. Which of the following use cases is not a good fit for Cloud Run jobs?
   1. APIs and microservices
   2. Running scripts to perform database migrations or other operational tasks
   3. Creating and sending invoices every month
   4. Parallelized processing of all files in the Cloud Storage bucket
4. What can be a trigger in Cloud Functions (2nd gen)? (Choose all that apply.)
   1. Firestore triggers
   2. HTTP triggers
   3. Pub/Sub triggers
   4. Eventarc triggers
5. To monitor Cloud Run job performance and metrics, it is necessary to configure Cloud Monitoring. (True or False?)
   1. True
   2. False
6. Which of the following use cases are best fit for Cloud Functions? (Choose all that apply.)
   1. Data processing/ETL
   2. Lightweight APIs
   3. IoT
   4. Running scripts or operational tasks
7. Choose the correct statement about Cloud Run revisions:
   1. Every new deployment creates an editable revision.
   2. You can only split traffic between the latest and previous revision.
   3. Cloud Run creates an HTTPS endpoint in a unique subdomain of the **\*.****run.app** domain.
   4. Cloud Run supports WebSockets, HTTP/2 (end-to-end), and gRPC (end-to-end).
8. By default, Cloud Run supports which amount of resources?
   1. CPU – 8, Memory - 34 GiB, Request timeout – 3,600 seconds, Maximum requests per container – 1,000
   2. CPU – 1, Memory – 512 MiB, Request timeout – 300 seconds, Maximum requests per container – 80, Container instances – 30
   3. CPU – 2, Memory – 1,024 MiB, Request timeout – 600 seconds, Maximum requests per container – 160, Container instances – 60
   4. CPU – 12, Memory – 3072 MiB, Request timeout – 1,800 seconds, Maximum requests per container – 480, Container instances – 180
9. Select every statement that is true about Cloud Run revisions:
   1. Each deployment to a service creates a revision.
   2. Each deployment to a revision creates a service.
   3. Once a revision has been created, it cannot be modified.
   4. If you want to change the container image, you must create a new service.
10. Which of the following is true about Cloud Run?
    1. Cloud Run jobs need to start a web server.
    2. If the Cloud Run task fails, the job continues until all tasks run, and the entire job is marked as failed.
    3. Tasks cannot be retried.
    4. Cloud Run jobs cannot use serverless VPC access, custom service accounts, or cloud SQL connections.
11. You have been tasked to manage Google Cloud resources through Kubernetes. Which tool can you use?
    1. Terraform
    2. Deployment Manager
    3. Cloud Functions
    4. Config Connector
12. You are trying to install Config Connector in your Google Kubernetes Cluster, but the installation is failing. Choose all components that might cause this issue:
    1. GKE with version 1.17.3.
    2. GKE monitoring is disabled.
    3. You haven’t enabled a Workload Identity Pool.
    4. You haven’t granted the **roles/iam.serviceAccountAdmin** permissions to Config Connector.
13. You are working with Terraform code to deploy resources into Google Cloud. Which command allows you to validate code for syntax errors?
    1. **terraform apply**
    2. **terraform init**
    3. **terraform validate**
    4. **terraform plan**
14. What is the name of the action that allows Cloud Functions to execute a response to various scenarios?
    1. A log entry
    2. A trigger
    3. An incident
    4. An event
    5. An occurrence
    6. A start
15. What is Google Cloud Marketplace?
    1. A software packaging offering
    2. A Google Cloud scripts marketplace
    3. A Google Cloud job market
    4. A collection of solutions that are fully integrated with Google Cloud and can easily be deployed with just a few clicks
16. How does Terraform differ from other IaC tools? (Choose all that apply.)
    1. Terraform can store local variables, passwords, and cloud tokens in the Terraform registry in an encrypted form.
    2. Terraform supports cloud and on-premises environments.
    3. Terraform can be deployed in a CI/CD way.
    4. Terraform doesn’t require any agent deployments.
    5. All of the above.
17. What is the Cloud Function’s 2nd generation memory limit?
    1. 64 GiB
    2. 2 GiB
    3. 16 GiB
    4. 32 GiB
18. Choose all serverless options from the Google Cloud portfolio:
    1. Google Kubernetes Engine
    2. Cloud Run
    3. Cloud Functions
    4. Google Compute Engine
    5. Google Cloud VMware Engine
19. Choose a product that provides a flexible serverless deployment platform for hybrid and multi-cloud environments:
    1. Google Kubernetes Engine
    2. Cloud Run
    3. Cloud Functions
    4. Cloud Run for Anthos
20. Choose the correct statement about Cloud Functions:
    1. In Cloud Functions (1st gen), the maximum timeout duration is 9 minutes (540 seconds).
    2. In Cloud Functions (2nd gen), the maximum timeout duration is 60 minutes (3,600 seconds) for HTTP functions and 9 minutes (540 seconds) for event-driven functions.
    3. In Cloud Functions (1st gen), the maximum timeout duration is 5 minutes (300 seconds).
    4. In Cloud Functions (2nd gen), the maximum timeout duration is 30 minutes (1,800 seconds) for HTTP functions and 4 minutes (240 seconds) for event-driven functions.

# Answers

Here are the answers to this chapter’s questions:

1ABCDEF, 2A, 3A, 4BCD, 5False, 6ABC, 7CD, 8B, 9AC, 10B, 11D, 12ABC, 13C, 14B, 15D, 16E, 17C, 18BC, 19D, 20AB