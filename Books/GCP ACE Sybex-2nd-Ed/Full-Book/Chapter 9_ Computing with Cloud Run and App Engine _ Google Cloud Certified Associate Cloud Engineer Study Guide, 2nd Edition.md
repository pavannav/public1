---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVE OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **3.3 Deploying and implementing Cloud Run and Cloud Functions resources**

---

This chapter describes how to deploy containerized services using Cloud Run and App Engine. Cloud Run, an alternative to App Engine for running containers, is a managed, serverless service. App Engine is no longer included in the Associate Cloud Engineer Certification Exam Guide; however, it is still included in this chapter because it is still an option in Google Cloud and cloud engineers should be able to support App Engine services even if they are not asked questions about App Engine on an exam.

Cloud Run is designed to support highly scalable, containerized applications written in any language. Cloud Run integrates with developer tools such as Cloud Build, Artifact Registry, and Docker.

App Engine is a platform-as-a-service (PaaS) offering from Google Cloud that allows developers to work within a set of language specific frameworks and deploy scalable applications while requiring only minimal attention to scaling concerns.

## Overview of Cloud Run

Cloud Run is a serverless, managed service for running containerized applications. Unlike with App Engine Standard and Cloud Function, you are not restricted to using a limited set of programming languages. Cloud Run supports any application that can be run in a container. An advantage of using Cloud Run is that you do not have to manage infrastructure, such as virtual machines. Cloud Run supports two ways to run code: as a service and as a job.

Cloud Run services are used when your code is used to respond to web requests or events. For example, an API that returns data from a Cloud SQL database could be implemented using containers and run as a service in Cloud Run.

Cloud Run jobs is used when the code executes until a workload is complete. For example, if you needed to transform a set of files stored in Cloud Storage and then load it into Cloud SQL you could run the application in a container using Cloud Run jobs.

### Cloud Run Services

Cloud Run services are well suited for web applications, microservices, APIs, and stream data processing.

Cloud Run services are designed to listen to an HTTPS endpoint and respond to requests made to that endpoint. Each Cloud Run service has an endpoint on a unique subdomain of the `run.app` domain and custom domains can be used as well. Endpoints can scale to up to 1,000 container instances with default quotas; you can request a higher quota if needed. You can also specify a maximum number of container instances to run if you want to limit the number of containers and therefore the cost of running those containers. In addition to providing scalable resources to support traffic to the endpoint, Cloud Run manages TLS. You can use WebSockets, HTTP/2 (end-to-end), and gRPC with these endpoints.

With Cloud Run, you deploy immutable versions of a service. To make an update to a service, you would create a new container image and deploy that as a new version. You can run multiple revisions of the same service in Cloud Run. Also, you can route traffic between different revisions. This is useful when you release a new version and you want to send a small amount of traffic to the latest version so that you can monitor for any problems before rolling out the latest version to all users. If you do discover problems with a revision, you can roll it back and have traffic routed to an earlier, more stable revision.

Cloud Run services are deployed privately by default and require authentication to access. You can control access to services in the following ways:

- With a Cloud IAM policy
- Using ingress settings
- Allowing only authenticated users with Cloud Identity Aware Proxy (IAP)

With Cloud IAM policies, you can assign a role to a group of users so that the group has the permissions specified in the group. For example, to make a service publicly accessible, you can allow access to unauthenticated users. You may want to grant a group of developers permissions to create new versions of a service, and you can do that by assigning the run.developer role.

You can also control access at the network level. By default, a Cloud Run endpoint is accessible from anywhere on the Internet using the `run.app` subdomain or a custom domain you define. In addition to using IAM roles to control access to a service, you can control network traffic to the endpoint by specifying an ingress setting. Ingress setting options include:

- Internal, which is the most restrictive and allows only traffic from internal HTTP(S) load balancers, resources within the VPC Service Controls perimeter, VPC networks in the same project or VPC Service Controls perimeter, as well as Eventarc, Cloud Pub/Sub, and Cloud Workflow services in the same project or service control perimeter
- Internal and Cloud Load Balancing, which includes traffic allowed by the Internal setting along with External HTTP(S) load balancers
- All, which is the least restrictive and allows all requests to run that are sent to the service endpoint

Cloud IAP is a security service that protects services by only allowing traffic to the services to come from proxies. When a user tries to access a Cloud Run service protected by Cloud IAM, they are first subject to authentication and authorization by IAP.

### Cloud Run Jobs

Cloud Run jobs are programs or scripts that run for a period of time while completing a task and then stop. For example, you could use Cloud Run jobs to run a script to validate files uploaded to a Cloud Storage bucket and then import data in those files to a Cloud SQL database. Unlike a service, which continues to accept requests to perform tasks, jobs perform a task and terminate. Cloud Run jobs can be scheduled to run on regular schedules. They also array jobs, which can be parallelized. The file processing example just mentioned is a good example of a job that can be parallelized. Instead of processing each file one at a time, multiple containers can be started so that multiple files can be processed simultaneously.

## Creating a Cloud Run Service

You can create a Cloud Run service using the console, the Cloud SDK, or programmatically using the API. In this section, we'll review how to create a Cloud Run service using the console.

In the cloud console, navigate to the Cloud Run page and select the option for creating a service. The Create Service page shown in [Figure 9.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#c09-fig-0001) opens.

![Snapshot of the form for creating a Cloud Run service](../images/c09f001.png)


[**FIGURE 9.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#R_c09-fig-0001) The form for creating a Cloud Run service

On this page you will specify a container image URL. You type in a URL or select an image from the Container Registry or the Artifact Registry. By default, you will deploy one revision, but you can select the option to continuously deploy new versions as the source repository is updated.

You will also specify a service name and choose a region to run your service. You have the option of paying only for the time CPU resources are allocated to processing a request or for paying for CPU resources that are always allocated. You can also specify a minimum and maximum number of instances.

[Figure 9.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#c09-fig-0002) shows how we can specify an ingress rule. The ingress configuration options were described above. You can also change the default requirement for authentication to allow for unauthenticated access. Unauthenticated access is typically used for websites or public APIs.

![Snapshot of when creating a Cloud Run service, we can choose one of three ingress options.](../images/c09f002.png)


[**FIGURE 9.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#R_c09-fig-0002) When creating a Cloud Run service, we can choose one of three ingress options.

Next, you can specify additional configuration options for containers, connections and security.

For containers ([Figure 9.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#c09-fig-0003)), you can specify a port, a container command, and container arguments. You can also configure the amount of memory and number of CPUs. Currently, the max memory is 32 GB in preview and 16 GB in general release. Up to 8 CPUs are currently supported in preview and up to 4 in general release. (Services in preview are not covered by the Google Cloud SLA, but services in general release are covered by SLAs.)

By default, requests will time out after 5 minutes, but you can specify a shorter or longer period ranging from 1 to 60 minutes.

Cloud Run has two execution environments: first generation and second generation. The second generation supports features such as filesystem access and faster performance. By default, Cloud Run will choose an environment for you. You can also specify environment variables for the container and reference secrets in the container.

On the Connections tab ([Figure 9.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#c09-fig-0004)), you can indicate if you want to use HTTP/2 end-to-end, which supports gRPC streaming services, and if you want to support session affinity. Session affinity will route requests from a client to the same container, if possible. You can also specify a Cloud SQL connection for services that use a Cloud SQL database. You can also use create a VPC Connector to use Serverless VPC Access to connect your Cloud Run service to other resources in your VPC, such as Compute Engine instances or a Cloud Memorystore cache.

![Snapshot of configuring container parameters in a Cloud Run service](../images/c09f003.png)


[**FIGURE 9.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#R_c09-fig-0003) Configuring container parameters in a Cloud Run service

![Snapshot of configuring connection parameters in a Cloud Run service](../images/c09f004.png)


[**FIGURE 9.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#R_c09-fig-0004) Configuring connection parameters in a Cloud Run service

On the Security tab ([Figure 9.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#c09-fig-0005)), you can specify a service account to use with this service. You can also require Binary Authorization before deploying a container. Binary Authorization is a service that verifies that containers meet requirements specified in a policy governing the deployment of containers in Cloud Run and Kubernetes Engine, among other services. You can also specify if you want to use Google-managed or customer-managed encryption keys.

![Snapshot of configuring security parameters in a Cloud Run service](../images/c09f005.png)


[**FIGURE 9.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#R_c09-fig-0005) Configuring security parameters in a Cloud Run service

## Creating a Cloud Run Job

Creating a job in Cloud Run is similar to creating a service. From the Cloud Run page on the cloud console, select the Jobs tab and Create A Job to open a form similar to [Figure 9.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#c09-fig-0006).

As when creating a service, you will specify a container image URL and region. You will also provide a job name and the number of times you want to run the container; the default is one time.

On the General tab, you can specify container configuration parameters ([Figure 9.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#c09-fig-0007)). Some parameters, such as Container Command, Container Arguments, Memory, and CPU are similar to what you saw when configuring a Cloud Run service. In addition, you can specify the number of retries of failed tasks and a parallelism parameter to control the number of concurrent tasks. There is also an option to execute a job immediately.

On the Variables & Secrets tab ([Figure 9.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#c09-fig-0008)), you can specify environment variables and references to stored secrets.

As with Cloud Run services, you can specify Cloud SQL connections and a VPC connector on the Connections tab ([Figure 9.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#c09-fig-0009)). On the Security tab ([Figure 9.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#c09-fig-0010)), you can specify a service account for the service and encryption key management.

Before the release of Cloud Run, developers often chose to run their services on App Engine.

![Snapshot of creating a Cloud Run job](../images/c09f006.png)


[**FIGURE 9.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#R_c09-fig-0006) Creating a Cloud Run job

## App Engine Components

App Engine is available in a Standard and a Flexible version. App Engine Standard applications consist of four components:

- Application
- Service
- Version
- Instance

An App Engine application is a high-level resource created in a project; that is, each project can have one App Engine application. All resources associated with an App Engine app are created in the region specified when the app is created.

![Snapshot of configuring container parameters for a Cloud Run job](../images/c09f007.png)


[**FIGURE 9.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#R_c09-fig-0007) Configuring container parameters for a Cloud Run job

![Snapshot of configuring variables and secrets for a Cloud Run job](../images/c09f008.png)


[**FIGURE 9.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#R_c09-fig-0008) Configuring variables and secrets for a Cloud Run job

![Snapshot of configuring connection parameters for a Cloud Run job](../images/c09f009.png)


[**FIGURE 9.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#R_c09-fig-0009) Configuring connection parameters for a Cloud Run job

![Snapshot of configuring connection parameters for a Cloud Run job](../images/c09f010.png)


[**FIGURE 9.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#R_c09-fig-0010) Configuring security parameters for a Cloud Run job

Apps have at least one service, which is the code executed in the App Engine environment. Because multiple versions of an application's code base can exist, App Engine supports versioning of apps. A service can have multiple versions, and these are usually slightly different, with newer versions incorporating new features, bug fixes, and other changes relative to earlier versions. When a version executes, it creates an instance of the app.

Services are typically structured to perform a single function with complex applications made up of multiple services, known as *microservices*. One microservice may handle API requests for data access, while another microservice performs authentication and a third records data for billing purposes.

Services are defined by their source code and their configuration file. The combination of those files constitutes a version of the app. If you slightly change the source code or configuration file, it creates another version. In this way, you can maintain multiple versions of your application at one time, which is especially helpful for testing new features on a small number of users before rolling the change out to all users. If bugs or other problems occur with a version, you can easily roll back to an early version. Another advantage of keeping multiple versions is that they allow you to migrate and split traffic, which we'll describe in more detail later in the chapter.

## Deploying an App Engine Application

The Google Associate Cloud Engineer certification exam does not require engineers to write an application, but we are expected to know how to deploy one. In this section, you will download a Hello World example from Google and use it as a sample application that you will deploy. The app is written in Python, so you'll use the Python runtime in App Engine.

### Deploying an App Using Cloud Shell and SDK

First, you will work in a terminal window using Cloud Shell, which you can start from the console by clicking the Cloud Shell icon. Make sure `gcloud` is configured to work with App Engine by using the following command:

```
gcloud components install app-engine-python
```

This command will install or update the App Engine Python library as needed. If the library is up-to-date, you will receive a message saying that.

When you open Cloud Shell, you may have a directory named `python-docs-samples`. This contains a number of example applications, including the Hello World app we'll use. If you do not see this directory, you can download the Hello World app from Google using this:

```
git clone https://github.com/GoogleCloudPlatform/python-docs-samples
```

Next, change your working directory to the directory with the Hello World app, using the following:

```
cd python-docs-samples/appengine/standard_python3/hello_world
```

If you list the files in the directory, you will see five files:

- `app.yaml`
- `main.py`
- `main_test.py`
- `requirements.txt`
- `requirements-test.txt`

Here you are primarily concerned with the `app.yaml` file. ([Figure 9.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#c09-fig-0011)).

![Snapshot of the contents of an app.yaml file for a Python 3 application](../images/c09f011.png)


[**FIGURE 9.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c09.xhtml#R_c09-fig-0011) The contents of an `app.yaml` file for a Python 3 application

In this example, the app configuration file specifies the version of Python to use. Depending on the version of Python you are using, the `app.yaml` file may also contain the API version you are deploying, a Python parameter called `threadsafe`, and environment variables.

To deploy your app, you can use the following command:

```
gcloud app deploy app.yml
```

However, `app.yml` is the default, so if you are using that for the filename, you do not have to specify `app.yml` in the `deploy` command.

This command must be executed from the directory with the `app.yaml` file. The `gcloud app deploy` command has some optional parameters:

- `--version`, to specify a custom version ID
- `--project`, to specify the project ID to use for this app
- `--no-promote`, to deploy the app without routing traffic to it

You can see the output of the Hello World program by navigating in a browser to your project URL, such as `https://gcpace-project.appspot.com`. The project URL is the project name followed by `.``appspot.com`.

---

![](../images/note_13.png) You can also assign a custom domain if you would rather not use an `appspot.com` URL. You can do this from the Add New Custom Domain function on the App Engine Settings page.

---

You can stop serving versions using the `gcloud app versions stop` command and passing a list of versions to stop. For example, to stop serving versions named v1 and v2, use the following:

```
gcloud app versions stop v1 v2
```

## Scaling App Engine Applications

Instances are created to execute an application on an App Engine–managed server. App Engine can automatically add or remove instances as needed based on load. When instances are scaled based on load, they are called *dynamic* instances. These dynamic instances help optimize your costs by shutting down when demand is low.

Alternatively, you can configure your instances to be resident or running all the time. These are optimized for performance so that users will wait less time while an instance is started.

Your configuration determines whether an instance is resident or dynamic. If you configure autoscaling or basic scaling, then instances will be dynamic. If you configure manual scaling, then your instances will be resident.

To specify automatic scaling, add a section to `app.yaml` that includes the term `automatic_scaling` followed by key-value pairs of configuration options. These include the following:

- `target_cpu_utilization`
- `target_throughput_utilization`
- `max_concurrent_requests`
- `max_instances`
- `min_instances`
- `max_pending_latency`
- `min_pending_latency`

- **`target_cpu_utilization`**   Specifies the maximum CPU utilization that occurs before additional instances are started.
- **`target_throughput_utilization`**   Specifies the maximum number of concurrent requests before additional instances are started. This is specified as a number between 0.5 and 0.95.
- **`max_concurrent_requests`**   Specifies the maximum concurrent requests an instance can accept before starting a new instance. The default is 10; the max is 80.
- **`max_instances` and `min_instances`**   Indicates the range of number of instances that can run for this application.
- **`max_pending_latency` and `min_pending_latency`**   Indicates the maximum and minimum time a request will wait in the queue to be processed.

You can also use basic scaling to enable automatic scaling. The only parameters for basic scaling are `idle_timeout` and `max_instances`.

---

### Real World Scenario

### Microservices vs. Monolithic Applications

Scalable applications are often written as collections of microservices. This has not always been the case. In the past, many applications were monolithic, or designed to include all functionality in a single compiled program or script. This may sound like a simpler, easy way to manage applications, but in practice it creates more problems than it solves:

- Any changes to the application require redeploying the entire application, which can take longer than deploying microservices. Developers tended to bundle changes before releasing them.
- If a bundled release had a bug in a feature change, then all feature changes would be rolled back when the monolithic application was rolled back.
- It was difficult to coordinate changes when teams of developers had to work with a single file or a small number of files of source code.

---

Microservices divide application code into single-function applications, allowing developers to change one service and roll it out without impacting other services. Source code management tools, like Git, make it easy for multiple developers to contribute components of a larger system by coordinating changes to source code files. This single-function code and the easy integration with other code promote more frequent updates and the ability to test new versions before rolling them out to all users at once.

## Splitting Traffic Between App Engine Versions

If you have more than one version of an application running, you can split traffic between the versions. App Engine provides three ways to split traffic: by IP address, by HTTP cookie, and by random selection. IP address splitting provides some stickiness, so a client is always routed to the same split, at least as long as the IP address does not change. HTTP cookies are useful when you want to assign users to versions. Random selection is useful when you want to evenly distribute workload.

When using IP address splitting, App Engine creates a hash—that is, a number generated based on an input string between 0 and 999, using the IP address of each version. This can create problems if users change IP address, such as if they start working with the app in the office and then switch to a network in a coffee shop. If state information is maintained in a version, it may not be available after an IP address change.

The preferred way to split traffic is with a cookie. When you use a cookie, the HTTP request header for a cookie named GOOGAPPUID contains a hash value between 0 and 999. With cookie splitting, a user will access the same version of the app even if the user's IP address changes. If there is no GOOGAPPUID cookie, then the traffic is routed randomly.

The command to split traffic is `gcloud app services set-traffic`. Here's an example:

```
gcloud app services set-traffic serv1 --splits v1=.4,v2=.6
```

This command will split traffic, with 40 percent going to version 1 of the service named serv1 and 60 percent going to version 2. If no service name is specified, then all services are split.

The `gcloud app services set-traffic` command takes the following parameters:

- `--migrate` indicates that App Engine should migrate traffic from the previous version to the new version.
- `--split-by` specifies how to split traffic using either IP or cookies. Possible values are `ip`, `cookie`, and `random`.

You can also migrate traffic from the console. Navigate to the Versions page and select the Migrate command.

## Summary

Cloud Run is a serverless, managed service for running containerized applications. Cloud Run supports any application that can be run in a container. Cloud Run services are used when your code is used to respond to web requests or events. Cloud Run jobs are used when the code executes until a workload is complete. When working with services or jobs, you can configure several categories of parameters, including container, connection, and security settings.

App Engine Standard is a serverless platform for running applications in language-specific environments. As a cloud engineer, you are expected to know how to deploy and scale App Engine applications. App Engine applications consist of services, versions, and instances. You can have multiple versions running at one time. You can split traffic between versions and have all traffic automatically migrate to a new version. App Engine applications are configured through `app.yaml` configuration files. You can specify the language environment, scaling parameters, and other parameters to customize your deployment. App Engine is no longer listed in the Google Cloud Associate Cloud Engineer Exam Guide, but it is included here because cloud engineers should be familiar with this popular Google Cloud service.

## Exam Essentials

- **Be able to describe Cloud Run as a serverless service for running containers.**   Cloud Run is a serverless, managed service for deploying, scaling, and managing services. Although there are no servers to configure, you can specify parameters to control the number of instances running at any time, the security used to protect the service, as well as connection configuration details.
- **Know how Cloud Run services are used to run long-lived services like websites and API servers.**   Cloud Run services run containers continuously. You have the option to pay only for CPU resources used when responding to requests, or you can choose to have a container always available and pay for the time the CPU resources are allocated.
- **Know how Cloud Run jobs are used to run tasks, such as loading data into a database.**   Cloud Run jobs are configured similarly to Cloud Run services. You can specify that jobs use multiple containers running simultaneously. This is useful when running parallelizable workloads.
- **Be able to describe the structure of App Engine Standard applications.**   These consist of services, versions, and instances. Services usually provide a single function. Versions are different versions of code running in the App Engine environment. Instances are managed instances running the service.
- **Know how to deploy an App Engine app.**   This includes configuring the App Engine environment using the `app.yaml` file. Know that a project can have only one App Engine app at a time. Know how to use the `gcloud app deploy` command.
- **Understand the various scaling options.**   Three scaling options are autoscaling, basic scaling, and manual scaling. Only autoscaling and basic scaling are dynamic. Manual scaling creates resident instances. Autoscaling allows for more configuration options than basic scaling.

## Review Questions

You can find the answers in the Appendix.

1. You want to provide your customers with an API to allow them to query a database with proprietary industry data. You want your developers to focus on adding new features and not on administering servers. Which of the following Google Cloud services would you choose?
   1. Compute Engine managed instance groups
   2. Computer Engine unmanaged instance groups
   3. Cloud Run services
   4. Cloud Run jobs
2. You are working for a biomedical research group that has several hundred data files stored in Cloud Storage. They have a statistical analysis program that analyzes a data file and writes the output to another Cloud Storage bucket. They have agreed with you that deploying the program in a container is the best option, but they are unsure which Google Cloud service to use to run the container. What would you recommend?
   1. Kubernetes Engine
   2. Compute Engine
   3. App Engine Flexible
   4. Cloud Run jobs
3. You are working for a climate change research group that has tens of thousands of public weather data files stored in Cloud Storage. They are building a model to predict sea levels in the near future. The data in each file can be analyzed independently of other files. They plan to use Cloud Run jobs for this task. What feature of Cloud Run jobs would you recommend they use?
   1. Customer-managed encryption keys
   2. Array jobs
   3. Cloud SQL Connection
   4. A private IP address
4. An application administrator has asked for your help with configuring a Cloud Run service. The application administrator would like to have all client requests routed to the same container if possible. How would you suggest the administrator accomplish this?
   1. Use Cloud SQL Connection.
   2. Use array jobs.
   3. Configure the connection in the Cloud Run Service to support session affinity.
   4. Use a private IP address.
5. You are deploying a service on Cloud Run. The service has access to personal identifiable information (PII) and for compliance reasons, you do not want to expose the service to any traffic outside of internal traffic in your Google Cloud environment. What ingress configuration would you use?
   1. Internal
   2. Internal and Cloud Load Balancing
   3. All
   4. PII proxy traffic
6. You want to use a service account specifically created for a Cloud Run service. Where would you specify that in the cloud console?
   1. On the Connections tab
   2. On the Security tab
   3. On the Container tab
   4. On the Variables & Secrets tab
7. A group of developers need the ability to deploy new versions of a service running in Cloud Run. How would you configure that access?
   1. Using IAM
   2. Using Cloud Identity Aware Proxy (IAP)
   3. Using an ingress policy
   4. Using the Security tab in the Cloud Run console
8. Your team deployed a Cloud Run service last month that accesses a Cloud SQL database. The database team has changed their system and now use a Memcached cache running in Cloud Memorystore. You have to change your Cloud Run service to access the Cloud Memorystore cache. What would you use to do that?
   1. Cloud SQL Connection
   2. Cloud IAP Proxy
   3. VPC Connection
   4. Session affinity
9. A service is deployed to Cloud Run services and will communicate with clients using gRPC. What should you configure to enable this protocol to work with the service?
   1. External Load Balancing
   2. Cloud Identity Aware Proxy (IAP)
   3. Session affinity
   4. HTTP/2 end-to-end
10. What Google Cloud services can be used to store and access container images accessible from Cloud Run?
    1. Container Registry only
    2. Container Registry and Artifact Registry
    3. Artifact Registry only
    4. Container Registry, Artifact Registry, and Kubernetes Engine
11. You have designed a microservice that you want to deploy to production. Before it can be deployed, you have to review how you will manage the service life cycle. The architect is particularly concerned about how you will deploy updates to the service with minimal disruption. What aspect of App Engine components would you use to minimize disruptions during updates to the service?
    1. Services
    2. Versions
    3. Instance groups
    4. Instances
12. You've just released an application running in App Engine Standard. You notice that there are peak demand periods in which you need up to 12 instances, but most of the time 5 instances are sufficient. What is the best way to ensure that you have enough instances to meet demand without spending more than you have to?
    1. Configure your app for autoscaling and specify max instances of 12 and min instances of 5.
    2. Configure your app for basic scaling and specify max instances of 12 and min instances of 5.
    3. Create a cron job to add instances just prior to peak periods and remove instances after the peak period is over.
    4. Configure your app for instance detection and do not specify a max or minimum number of instances.
13. What command should you use to deploy an App Engine app from the command line?
    1. `gcloud components app deploy`
    2. `gcloud app deploy`
    3. `gcloud components instances deploy`
    4. `gcloud app instance deploy`
14. You have deployed a Django 1.5 Python application to App Engine. This version of Django requires Python 3. For some reason, App Engine is trying to run the application using Python 2. What file would you check and possibly modify to ensure that Python 3 is used with this application?
    1. `app.config`
    2. `app.yaml`
    3. `services.yaml`
    4. `deploy.yaml`
15. You are concerned that as users make connections to your application, the performance will degrade. You want to make sure that more instances are added to your App Engine application when there are more than 20 concurrent requests. What parameter would you specify in `app.yaml`?
    1. `max_concurrent_requests`
    2. `target_throughput_utilization`
    3. `max_instances`
    4. `max_pending_latency`
16. What parameters can be configured with basic scaling?
    1. `max_instances` and `min_instances`
    2. `idle_timeout` and `min_instances`
    3. `idle_timeout` and `max_instances`
    4. `idle_timeout` and `target_throughput_utilization`
17. The `runtime` parameter in `app.yaml` is used to specify what?
    1. The script to execute
    2. The URL to access the application
    3. The language runtime environment
    4. The maximum time an application can run
18. You work for a startup, and costs are a major concern. You are willing to take a slight performance hit if it will save you money. How should you configure the scaling for your apps running in App Engine?
    1. Use dynamic instances by specifying autoscaling or basic scaling.
    2. Use resident instances by specifying autoscaling or basic scaling.
    3. Use dynamic instances by specifying manual scaling.
    4. Use resident instances by specifying manual scaling.
19. What parameter to `gcloud app services set-traffic` is used to specify the method to use when splitting traffic?
    1. `––split-traffic`
    2. `––split-by`
    3. `––traffic-split`
    4. `––split-method`
20. What are valid methods for splitting traffic in App Engine?
    1. By IP address only
    2. By HTTP cookie only
    3. Randomly and by IP address only
    4. By IP address, HTTP cookies, and randomly