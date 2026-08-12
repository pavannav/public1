# 11

# Monitoring, Logging, and Estimating Costs in GCP

At first look, the observability services don’t appear to be the most critical topic. It is possible to run workloads without monitoring them. But soon, after you start deploying services at scale, you will look for a monitoring service to optimize or plan the usage of Google Cloud resources. You will want to investigate logs once the first issues appear. Then, you will need to build customized dashboards and alerts to get notified of the status of your services.

This chapter will help you better understand what kind of observability tools Google Cloud offers and how to use them for your workloads.

We will focus on Google Cloud’s operations suite (formerly Stackdriver), which consists of the following fully managed services – **Cloud Monitoring** for visibility into the health of your applications and Google Cloud services, **Cloud Logging** for real-time log management, and application-level diagnostic tools such as **Trace** and **Profiler** to reduce the latency and cost of your services.

In this chapter, we will also learn how to estimate costs in Google Cloud.

We are going to cover the following main topics:

- Monitoring
- Logging
- Diagnostics
- Estimating costs with Google Cloud Pricing Calculator

As a beginner, learning about monitoring and logging can be difficult since you usually need a deployed real-life application to access more interesting statistics and logs. If you’re up for a challenge, you can try following the steps in the *Getting started with Python* documentation (check the following link) and deploy a real-life web application called **Bookshelf**. This application uses Cloud Run and Google Cloud Storage and can be accessed from the internet, giving you the chance to collect some interesting logs and metrics: <https://cloud.google.com/python/docs/getting-started>.

# Cloud Monitoring

If you have ever worked as an on-premises system administrator, you have probably physically inspected or logged in to your server’s management console in response to various alerts that have fired in your monitoring console. For example, a fan or a disk failure, a power outage, or a network port flap can happen in any data center and can be easily detected thanks to monitoring systems.

Although moving to Google Cloud means you don’t have to monitor the underlying network and physical infrastructure anymore, you are still responsible for your applications in a similar way as you were responsible for them on-premises.

Google offers a highly efficient service called Cloud Monitoring, which is avaiable by default once you create your project. This service provides many tools for collecting, analyzing, and presenting real-time monitoring data for both Google Cloud services and user workloads. Most Google Cloud services are already connected to the monitoring system when you set them up and start using them. Cloud Monitoring is not limited to Google Cloud; it can also be used to collect metrics from other solution providers, such as those available on-premises or on AWS. This makes it a versatile tool for monitoring hybrid-cloud environments.

If you plan to have multiple Google Cloud projects and on-premises workloads, you might assume you must log in to various places to monitor everything. However, that is not the case. Instead, you can create a dedicated monitoring project to gather data from the entire setup and view it all in one place. To expand the scope of your metrics, use the **+ ADD GCP PROJECTS** option to include other projects in your monitoring project. Refer to the accompanying screenshot for guidance:

![Figure 11.1 – Increasing the monitoring scope by adding more projects to Cloud Monitoring](../images/B18851_11_01.jpg)

Figure 11.1 – Increasing the monitoring scope by adding more projects to Cloud Monitoring

An excellent way to start learning about Cloud Monitoring is by exploring what your service’s default dashboards can offer and creating your personalized dashboards in the next step. For example, if you create a Compute Engine VM or start using Google Cloud Storage or GKE, a service-specific dashboard will be added in the **Dashboards** section under the **GCP** category, as shown in the following screenshot. This is the section where you can start discovering the default metrics:

![Figure 11.2 – Default dashboards for GCP services](../images/B18851_11_02.jpg)

Figure 11.2 – Default dashboards for GCP services

To help you easily understand what can be monitored without any extra setup, here is a table showing some Google Cloud services and their corresponding pre-built metric parameters:

| **Service** | **Selected** **out-of-the-box metrics** |
| --- | --- |
| Compute Engine VM | CPU utilization, network traffic, disk operations, and uptime |
| Google Cloud Storage | Number of requests per bucket, network traffic sent/received per bucket, total number of objects stored in a bucket, and size of the objects |
| GKE | Container restarts, CPU utilization, and memory utilization |
| Cloud Run | Container CPU utilization, container memory utilization, request count, request latencies, sent bytes, and received bytes |

Table 11.1 – Examples of pre-build metrics for selected Google Cloud workloads

You can also use built-in charts and out-of-the-box metrics to build customized views to have all the services that build your application in one dashboard.

In the **Dashboards** overview, select **+ CREATE DASHBOARD**, provide its name, and as a next step, drag and drop a metric you need and rearrange or resize it to fit nicely into your dashboard. You can later edit and adjust your dashboard after observing the metrics for some time, so they show only the relevant data.

Let’s look at the example of such a customized dashboard. Its purpose is to have a single dashboard to view resource usage, alerts, and logs for Compute Engine VMs. It consists of four charts – a stacked bar chart to present their CPU utilization, a small text chart that could be used to add more details about monitored objects, an alert chart that shows whether a preconfigured threshold for CPU is exceeded, and a large logs panel showing recent logs from the VMs:

![Figure 11.3 – Example of a customized monitoring dashboard based on out-of-the-box metrics](../images/B18851_11_03.jpg)

Figure 11.3 – Example of a customized monitoring dashboard based on out-of-the-box metrics

Once you start exploring various charts, you will soon notice that although all the data seems to be presented for services such as GKE or App Engine, some of the Compute Engine charts are empty.

Specifically, you won’t find memory metrics for your VMs unless you install an additional component called **Ops Agent**. Keep in mind that this only applies to Compute Engine VMs; GKE and App Engine already have built-in agents for collecting metrics, so you don’t need to install anything extra for those services.

![Figure 11.4 – Some of the metrics require Ops Agent installation](../images/B18851_11_04.jpg)

Figure 11.4 – Some of the metrics require Ops Agent installation

Ops Agent is a collectd-based daemon that collects telemetry data from Compute Engine VMs for cloud monitoring and logging services. It collects data for supported operating systems and applications from the inside of a VM. You can install it via the Google Cloud console or a command line.

The command to install the agent on the Linux VM is as follows:

```
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh sudo bash add-google-cloud-ops-agent-repo.sh --also-install
```

You can check whether it is running using the following command:

```
sudo service google-cloud-ops-agent status
```

When you create a Compute Engine VM, you have the option to attach either a default or a dedicated service account to it.

The Ops Agent uses this service account to interact with the Logging and Monitoring services, so it requires permission. To ensure proper functionality, assign the service account the following roles:

- For Monitoring, use Monitoring Metric Writer
- For Logging, use Logs Writer

To install the agent on multiple VMs, use Agent Policies. This feature automates the installation and upgrading of a fleet of Ops Agents. For instance, if you have a large number of Debian v10 Compute Engine instances, you can create a policy to install Ops Agent on all of them by attaching a label such as **env: production** to the instances in your project and enabling automated upgrades. To execute this, use the following gcloud command in Cloud Shell:

```
gcloud beta compute instances \ ops-agents policies create ops-agents-debian \
    --agent-rules="type=ops-agent,version=current-major,package-state=installed,enable-autoupgrade=true" \
    --os-types=short-name=debian,version=10 \
    --group-labels=env=production\
    --project=my-project
```

Once the policy is in use, any existing or newly created compliant VM with the **env: production** label, as shown in the following screenshot, will trigger the Ops Agent installation:

![Figure 11.5 – An example of a VM with an env:production tag running on Debian v10, compliant with the “ops-agents-debian” policy](../images/B18851_11_05.jpg)

Figure 11.5 – An example of a VM with an env:production tag running on Debian v10, compliant with the “ops-agents-debian” policy

Let’s explore how the Agent Policy can be implemented in practice. The preceding screenshot is taken from the **VM instances** section in the **Compute Engine** menu. Clicking on any of the VMs will take you to a new page with more specific information about that particular VM. On the left-hand side, there is the **DETAILS** tab view, where you can see that this VM has the necessary label: **env: production**. On the right-hand side, the **Basic info** view shows that the required version of the Debian operating system is 10, which should trigger the Ops Agent installation through the Agent Policy.

The following screenshot shows a log extract (Cloud Logging will be discussed later in this chapter) confirming that **ops-agent-policy** was activated for this VM and that the Ops Agent was installed successfully.

![Figure 11.6 – The Agent Policy installs Ops Agent on compliant VMs](../images/B18851_11_06.jpg)

Figure 11.6 – The Agent Policy installs Ops Agent on compliant VMs

Once Ops Agent is installed, Google Cloud Monitoring detects it and collects more detailed information, such as information about memory usage and running processes. For example, the following screenshot shows previously empty dashboards that are now populated with data once Ops Agent is installed:

![Figure 11.7 – VM processes metrics available after Ops Agent installation](../images/B18851_11_07.jpg)

Figure 11.7 – VM processes metrics available after Ops Agent installation

Now that we know how to set up and adjust monitoring of our services, we can look at the dashboards and analyze, for example, how many resources they are using. But do we have to watch dashboards constantly? In the next section, we will see how this process can be automated.

## Creating Cloud Monitoring alerts based on resource metrics

Monitoring dashboards alone, even the most sophisticated ones, wouldn’t be enough for system administrators as they would have to monitor them 24/7 looking for various anomalies. That is why Google Cloud Monitoring provides alerting capabilities for the following use cases:

- **User notifications** – Used to notify admins when metrics exceed a certain threshold or when certain conditions are met. Administrators can use this feature to prevent potential issues proactively. For instance, if the CPU usage of a VM instance increases unexpectedly, it’s advisable to investigate it as it could be due to a coding bug or ransomware attack. This preemptive approach can help avoid problems before they occur.
- **Autoscaling** – You can use metrics exported from your application to auto-scale its underlying **Managed Instance Group** (**MIG**). The autoscaling feature will adjust the number of instances in response to a signal (such as CPU usage or latency) from your metrics. This feature automatically adjusts the number of instances based on metrics such as CPU usage or latency, eliminating the need for manual monitoring and modifications.
- **Uptime checks** – With uptime checks, you can monitor the availability of internet-accessible URLs, VMs, APIs, or load balancers. Probes placed around the globe continuously send requests to a target that you can configure and report its responses. As a result, you can create alerts based on failed uptime checks and get paged when your service is down.

Let’s take a closer look at the first use case and examine the various ways in which a user can receive alerts and how to configure a CPU-usage-based alert for selected VM instances.

To create alerts based on metrics, you need to specify how Google Cloud Monitoring should notify you. You can configure it under the **Alerting** section by selecting the **Edit Notification Channels** option. You can use the following options for your notifications: **email**, **SMS**, **webhook**, **Pub/Sub**, **Slack**, and **PagerDuty**. If you are using the Cloud Console mobile app to manage Google Cloud resources from your iOS or Android device directly, you can also use it as your notification channel.

Notification channels are not mandatory, but the alternative is that alerts will only be displayed in the Google Cloud Console, and you will have to monitor the **Alerting** dashboard continuously.

When notification channels are set, you need to complete the following steps to create your alert:

1. In the **Alerting** section, select **+** **CREATE POLICY**.
2. Create your first alert condition by selecting a metric from the metrics explorer. For example, to create an alert based on CPU usage for VM instances, you can select **VM Instance** and from the **Instance** section, select **CPU usage**, as shown in the following screenshot:

![Figure 11.8 – Example view on VM Instance metrics explorer](../images/B18851_11_08.jpg)

Figure 11.8 – Example view on VM Instance metrics explorer

1. Add a filter if you want to create an alert for a specific subset of resources – for example, for VMs with a particular name or running in a specific region. This setting is optional.
2. Select the **minutes** or **hours** option in the rolling window or provide a custom value. This parameter and the rolling window function describe how the threshold will be calculated. For example, when we set the rolling window to **10 minutes** and the function to **mean**, a mean value for the duration of 10 minutes will be calculated. Other possible functions are, among others, *min*, *max*, *count*, *sum*, and *percentage*. Click **Next** to confirm your selection.
3. The next step is to configure the trigger for the alert. For the threshold-based triggers, you can specify whether the alert should be fired for the following:
   - Every violation
   - A percentage of violations
   - A number of violations

You must also specify whether the threshold position is above or below the threshold value. Once you select the threshold, it will appear on the chart on the right-hand side, and you will be able to verify how the value you provided corresponds to the situation from the selected time.

An alternative option to the threshold value is the absence of a metric. It gets triggered when metrics are absent for a selected period.

The last step in this section is to provide the condition name (if you want to use multiple conditions, a name would be beneficial) and confirm the settings by clicking **Next**:

![Figure 11.9 – Alert condition’s view](../images/B18851_11_09.jpg)

Figure 11.9 – Alert condition’s view

1. You can create more alert conditions by selecting **+ADD ALERT CONDITION**. It is possible to create advanced scenarios with a multi-condition trigger, where you get a single alert when a subset of conditions happens simultaneously – for example, the VM CPU value exceeds 50%, and at the same time, the memory utilization reaches 80%:

![Figure 11.10 – Multi-condition view](../images/B18851_11_10.jpg)

Figure 11.10 – Multi-condition view

In the **Notifications and name** section, select your notification channels. After the alert is triggered, you will not only be notified via selected channels but an alert will also be shown in the **Alerting** section in the Google Cloud Console. You can specify how long an unattended alert should be visible in your Console in the **Incident autoclose** **duration** section:

![Figure 11.11 – Notification and name view](../images/B18851_11_11.jpg)

Figure 11.11 – Notification and name view

1. The **Notifications and name** section also includes an optional text field to provide instructions and the steps an operator can follow once this alert is triggered:

![Figure 11.12 – Additional instructions that can be provided for an alert](../images/B18851_11_12.jpg)

Figure 11.12 – Additional instructions that can be provided for an alert

1. The last step in the **Notifications and name** section is to give the name for this alerting policy that will be visible in the **Alerting** section once an alert is fired.
2. When you review your policy, save it. It will be enabled by default.

![Figure 11.13 – An example of an email notification for an alerting policy](../images/B18851_11_13.jpg)

Figure 11.13 – An example of an email notification for an alerting policy

When an alert is triggered, Google Cloud Monitoring will notify you of the issue through the designated notification channels. As shown in *Figure 11**.13*, you may receive a similar email notification about the CPU utilization of a VM.

## Creating and ingesting Cloud Monitoring custom metrics

In addition to monitoring native GCP services and operating systems of your VMs (via Ops Agent), Cloud Monitoring provides you with options to closely monitor your applications. If your application runs on a Compute Engine VM and is listed as a supported third-party application in the Google Cloud Monitoring documentation (<https://cloud.google.com/monitoring/agent/ops-agent/third-party>), you can leverage Ops Agent to monitor it. For example, Ops Agent supports nginx (a web server app) integration to collect connection metrics and access logs. If your VM has Ops Agent installed and you follow the Ops Agent nginx configuration instructions published on the aforementioned URL, Cloud Monitoring will start ingesting new metrics related to web server traffic.

The following screenshot shows the **Dashboard list** section with an **Integration Dashboards** category in which **Nginx Overview** was added automatically after the Ops Agent configuration:

![Figure 11.14 – Once the nginx service is detected, a new dedicated dashboard is shown under the Integration section](../images/B18851_11_14.jpg)

Figure 11.14 – Once the nginx service is detected, a new dedicated dashboard is shown under the Integration section

If you look for more customized dashboards for your nginx service, you can set them up the same way we do later in the *Custom metrics* section. **VM Instance** metrics will have new additional nginx-related metrics such as Nginx request count.

![Figure 11.15 – Metrics available for nginx](../images/B18851_11_15.jpg)

Figure 11.15 – Metrics available for nginx

The following is an example of a customized dashboard built using dedicated nginx metrics:

![Figure 11.16 – Example dashboard with nginx requests](../images/B18851_11_16.jpg)

Figure 11.16 – Example dashboard with nginx requests

It shows the number of incoming requests that can be tracked thanks to the nginx-specific Ops Agent configuration. Similarly, we can leverage dedicated metrics for all other supported third-party applications.

## Custom metrics ingestion

What if your application doesn’t run inside a Compute Engine VM, built-in metrics don’t collect what you need, or a more customized approach to monitoring your app is required? For such scenarios, Google Cloud provides custom metrics and log-based metrics.

### Custom metrics

Suppose you want to collect application-specific metrics that the built-in Cloud Monitoring doesn’t offer. In that case, you can capture those by using the client library for the monitoring APIs directly in your code and send the metrics to Cloud Monitoring. It is the lowest possible layer at which you can control and collect data. The downside to this approach is that you will have to manage the entire setup in your code.

The alternative would be to use the OpenCensus metrics instrumentation library to define custom metrics. It is an open source framework for collecting metrics used in Google Cloud as a default ingestion mechanism. If you don’t want to use instrumentation libraries, there is another possibility – to use Google Cloud Managed Service for Prometheus. Prometheus is a standard for monitoring in the open source ecosystem and offers a wide range of system integrations in multi-cloud environments. In Google Cloud, it can be used to monitor Kubernetes and VM workloads.

### Log-based metrics

With log-based metrics, you can configure metrics based on log entries from Cloud Logging (this service will be the subject of the next section) without any additional instrumentation. For example, if you want to monitor a specific behavior of your application and you know how this behavior is represented in logs, there is no need to use a monitoring API; you can configure a dashboard where the specific occurrence of a log entry is parsed and monitored.

Let’s look at an example application. It creates a log entry, **Application Restarted**, every time a specific process fails and is reloaded. We can create a simple query in **Logs Explorer** to list this specific entry. The following figure shows that the restart incident happens quite frequently.

You can create log-based metrics from **Logs Explorer** directly. There is a **Create metric** option in the same line as **Histogram**. Alternatively, you will find **Log-based Metrics** in the **Logging** section in the menu on the left:

![Figure 11.17 – Logs Explorer showing selected log entries](../images/B18851_11_17.jpg)

Figure 11.17 – Logs Explorer showing selected log entries

The log-based metrics feature allows you to create metrics that will be later visible in **Metrics Explorer** in the **Monitoring** section. There are two types of metrics:

- **Counter metrics**: These are used to track the number of events occurrences, and can be used to count how many times a particular error occurred.
- **Distribution metrics**: These are used to extract numeric values from logs, and can be used to extract regular expressions and numeric values such as the latency of an application.

In our example, we will select the option to count the number of entries matching a chosen filter. We will also provide the metric’s name, description, and units.

![Figure 11.18 – Logs-based metrics configuration](../images/B18851_11_18.jpg)

Figure 11.18 – Logs-based metrics configuration

In the **Filter** section, we need to specify what logs we want to monitor and how we want to parse them. We will use the instance name, type, and text from the log entry in this example:

![Figure 11.19 – The continuation of logs-based metrics configuration](../images/B18851_11_19.jpg)

Figure 11.19 – The continuation of logs-based metrics configuration

You can build complex filters that count certain text occurrences and parse the logs to ingest certain values or array types. More information on the Logging query language that is used for building such filters can be found at the following link: <https://cloud.google.com/logging/docs/view/logging-query-language>.

Once our metric is created, it can be found in **Metrics Explorer** (initially introduced in *Figure 11**.8*) under the **/****logging/user** section:

![Figure 11.20 – Logs-based metrics in Metrics Explorer](../images/B18851_11_20.jpg)

Figure 11.20 – Logs-based metrics in Metrics Explorer

The next step is to create a dashboard using the newly created metric. The parameters we need can be defined in the **ADVANCED** section – no preprocessing and grouping, **count** as an alignment function, and a **1-m**inute period:

![Figure 11.21 – Creating an advanced chart that counts log entry occurrences](../images/B18851_11_21.jpg)

Figure 11.21 – Creating an advanced chart that counts log entry occurrences

Once the dashboard is saved, it can also be used to create alerts when the counters exceed a certain threshold. The alert configuration was explained earlier in this chapter. In the following screenshot, there is an example of an alert configured every time an application has two restarts in a minute:

![Figure 11.22 – Alert threshold set up on log-based metrics](../images/B18851_11_22.jpg)

Figure 11.22 – Alert threshold set up on log-based metrics

When creating a log-based alert, consider that there can be a delay between when an error happens for your application and when enough errors are aggregated in the metrics to trigger a notification.

# Cloud Logging

Cloud Logging is a comprehensive solution for managing logs generated by your applications, the platform they run on, and the underlying infrastructure, whether it’s on Google Cloud, other cloud providers, or on-premises systems. This fully managed service allows you to easily store, search, analyze, monitor, and receive alerts on logging data and events from all of these environments.

Logs are one of the most important sources of information when it comes to day-to-day admin activities and troubleshooting. Google Cloud services are capable of generating various types of logs, including the following:

- **Platform logs**: These are, in most cases, enabled by default and can’t be disabled; they are logs from Google Cloud services such as Compute Engine VMs or Google Cloud Storage.
- **Component logs**: These are similar to platform logs but come from the Google software components that run on user-owned systems.
- **Security logs**: These logs are collected for auditing and compliance purposes. In [*Chapter 12*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_12.xhtml#_idTextAnchor255)*,* detailed information about security logs will be provided.
- **User-written logs**: These are enabled and controlled by a user. They are logs collected by Ops Agent, APIs, client libraries, and third-party applications.
- **Multi-cloud and hybrid-cloud logs**: These come from other cloud providers and on-premises environments.

The Logging service, by default, encrypts the ingested logs using Google-managed encryption keys. But it is possible to use customer-managed keys to control the encryption process altogether.

When designing system architecture, you may want to have control over where your logs are streamed and for how long they are stored. To route logs to specified destinations, Google Cloud uses **log sinks**. All logs are stored in **\_Required** and **\_Default** log buckets, but it is also possible to keep them in other destinations, such as the following:

- Google Cloud Storage
- BigQuery
- Pub/Sub, which can be used for third-party integrations such as Splunk
- Customer-owned cloud logging buckets

When your project is created, there are two sinks defined:

- **\_Required**, which sends logs to a global audit log bucket where the logs are stored for 400 days. You can’t delete a **\_Required** sink or edit it to change the log destination. Logs that are stored in an audit log bucket are related to the following:
  - Admin activities related to modifying configuration or metadata, for example, when a VM instance is created
  - System events from Google Cloud Platform
  - Access transparency related to a justified Google’s access to your resources
- **\_Default**, which sends the remaining part of logs to a global default log bucket where logs are stored for 30 days. A user can change the retention period. You can also delete the **\_Default** sink and create your sinks if you don’t want your logs to be stored in a global bucket.

The following diagram is based on *Routing and storage overview* from Google’s documentation, which you can read here: <https://cloud.google.com/logging/docs/routing/overview>. It covers how logs are routed via default, customized sinks, and the default and customized destinations to route them:

![Figure 11.23 – Routing and storing Cloud Logging entries](../images/B18851_11_23.jpg)

Figure 11.23 – Routing and storing Cloud Logging entries

In addition to **\_Required** and **\_Default** sinks, users can define their own sinks and send data to other locations, also customizing the retention time to adjust to their company’s policy. In the upcoming sections, we will learn how to customize such **log sinks**, but first, let’s look at how logs are presented in Cloud Logging dashboards and how to filter logs before we send them to a new destination.

## Viewing and filtering logs in Cloud Logging

We already had a sneak peek into Cloud Logging when we built log-based metrics in the *Cloud Monitoring* section. Now, it’s time to explain how to view logs with **Logs Explorer**.

The upper section of **Logs Explorer** includes a **Query** pane with a time-range selector, an editor to build queries, a filter to narrow down a scope, and a search box where you can search across all log fields:

![Figure 11.24 – Logs Explorer Query pane](../images/B18851_11_24.jpg)

Figure 11.24 – Logs Explorer Query pane

On the left-hand side, a **Log fields** pane is updated according to the fields shown in log entries. It has a **SEVERITY** section, a **RESOURCE TYPE** or service section, and others that help narrow down the logging scope.

In terms of severity, each log entry is categorized based on the seriousness of the issue. The **SEVERITY** levels include **Emergency**, **Alert**, **Critical**, **Error**, **Warning**, **Notice**, **Info**, **Debug**, and **Default**. You can utilize these levels to refine your search.

For example, only **Error** logs will be listed if you select an **Error** severity level. If you select the **VM instance** resource type, the log output will be limited to Compute Engine VMs.

![Figure 11.25 – Logs Explorer Log fields pane](../images/B18851_11_25.jpg)

Figure 11.25 – Logs Explorer Log fields pane

In the center pane, you will find a **Histogram** section where the distribution of logs over time is visualized, as can be seen in the following screenshot. It will help you to look for trends in your system’s behavior or detect when a specific issue started.

![Figure 11.26 – Logs Explorer Histogram and Query results section](../images/B18851_11_26.jpg)

Figure 11.26 – Logs Explorer Histogram and Query results section

Under **Histogram**, there is a **Query results** pane where logs are listed. You can expand all nested fields in a selected log entry, show or hide similar ones, download logs, or save them to Google Drive.

## Viewing specific log message details in Cloud Logging

If you are looking for a specific message in Cloud Logging to examine its content, you can start by listing logs of a certain severity coming from a specific resource in the **Log fields** pane. Once you select a time range in the **Query** pane to narrow your search, you can inspect the **Query results** pane. When you expand a log entry and select a field, you will see an option to show/hide matching entries:

![Figure 11.27 – Logs Explorer sections that help to narrow down a log search](../images/B18851_11_27.jpg)

Figure 11.27 – Logs Explorer sections that help to narrow down a log search

Selecting **Show**/**hide similar entries** will populate a **Query** pane with a query that matches your request. The **Query** pane is where you can build more sophisticated logic that will narrow down your log search:

![Figure 11.28 – Using a Query pane to narrow down a log search](../images/B18851_11_28.jpg)

Figure 11.28 – Using a Query pane to narrow down a log search

Let’s look at the following screenshot. In the **Query** pane, there is a query that limits the log search to the Cloud Run service, showing only entries with the severity level of **WARNING** in the **us-east4** zone and only the HTTP request with status of **400**:

![Figure 11.29 – Example query for logs related to HTTP service](../images/B18851_11_29.jpg)

Figure 11.29 – Example query for logs related to HTTP service

Narrowing down a search scope will make your troubleshooting easier. But you may also want to limit the scope before sending logs to other destinations. In the next section, where we will learn how to configure log sinks; building filters to include specific logs will prove useful.

Please keep in mind that Logs Explorer is the ideal tool for troubleshooting and exploring log data. However, if you need assistance in creating insights and identifying trends, Google provides Log Analytics specifically for this purpose.

You can learn more about Log Analytics from this link:

<https://cloud.google.com/logging/docs/log-analytics#analytics>.

## Configuring log routers

Imagine a situation where you have a policy in your company that requires you to keep all logs coming from your workloads in a specific geographic region. Because the **\_Default** log bucket is global (logs generated in a particular region are stored in this region), you must change this default behavior.

To modify the destination of logs in your project, you need to change the configuration settings in the **Logs Router**. The Logs Router is responsible for receiving logs, filtering them based on user-defined criteria, and forwarding them to specified destinations. Let’s see how we can adjust the Logs Router settings to send logs to a different location.

First, you will need to create a new log bucket by selecting **CREATE LOG BUCKET** in the **Logs** **Storage** section:

![Figure 11.30 – Configuring a new log bucket](../images/B18851_11_30.jpg)

Figure 11.30 – Configuring a new log bucket

For the log bucket region, you can select a single region, global region, or multi-region such as the EU or US. The retention can be set between 1 and 3,650 days (around ten years) and modified later.

![Figure 11.31 – Configuring a region and a retention period for a log bucket](../images/B18851_11_31.jpg)

Figure 11.31 – Configuring a region and a retention period for a log bucket

Once a regional log bucket is created, you can either configure a new sink by selecting **CREATE SINK** in the **Cloud Router** section or edit an existing default one and point it to the new log bucket. If you create a new sink to replace the default one, you may want to build a new inclusion filter to include a specific subset of logs. Otherwise, all available logs will be routed to this new log bucket.

![Figure 11.32 – Editing a default sink](../images/B18851_11_32.jpg)

Figure 11.32 – Editing a default sink

To modify an existing **\_Default** sink to send logs to a new log bucket, edit the sink and replace the existing bucket with your bucket in the **Select a log bucket** section and save the configuration:

![Figure 11.33 – Redirecting logs to a new log bucket](../images/B18851_11_33.jpg)

Figure 11.33 – Redirecting logs to a new log bucket

After the sink has been modified, the last step is to check that logs are now stored in the new log bucket. To ensure the sink works, go to **Logs Explorer** and select **REFINE SCOPE**. Then, in **Scope by storage**, select the new bucket.

![Figure 11.34 – Verifying that logs are stored in a new logs bucket](../images/B18851_11_34.jpg)

Figure 11.34 – Verifying that logs are stored in a new logs bucket

You should be able to see new logs appearing in the **Query results** section, as illustrated in the preceding screenshot.

## Configuring log sinks to export logs to external systems

We configured a sink to route logs to a new log bucket in the previous section. Log buckets are the default choice for storing logs. It is also possible to route all or a subset of logs to alternative locations for longer retention (Google Cloud Storage), in-depth analysis (BigQuery), or third-party applications (in the cloud or on-premises).

When creating an alternative sink destination, one of the possible options is to send logs to a Cloud Storage bucket. Please note that a Cloud Storage bucket is a different destination from a Cloud Logging bucket. It is also not a real-time service because logs are written in hourly batches to Cloud Storage buckets.

If you want to export the logs to a third-party application that runs in the cloud or on-premises, you should use a Google Cloud Pub/Sub topic as the destination for your log sink. If there is network reachability between your application and your project and the required permissions, log files will populate in the configured Pub/Sub topic. Once you configure your application to pull messages from the Pub/Sub subscriptions, logs will be ingested to their final destination:

![Figure 11.35 – Available services for a log sink](../images/B18851_11_35.jpg)

Figure 11.35 – Available services for a log sink

Let’s configure a sink to export logs to an external system for further analysis. In this example, we will export them to BigQuery, so we need to create a data set in the **BigQuery** section, as illustrated in the following screenshot:

![Figure 11.36 – Creating a new BigQuery data set](../images/B18851_11_36.jpg)

Figure 11.36 – Creating a new BigQuery data set

Creating a new data set includes providing its ID and preferred location. We will reference the ID when creating a new log sink:

![Figure 11.37 – Set up a name and location for a new BigQuery data set](../images/B18851_11_37.jpg)

Figure 11.37 – Set up a name and location for a new BigQuery data set

We created a log sink for a log bucket in the previous section. In a similar way, we can create a log sink for a BigQuery data set:

![Figure 11.38 – Configuring a BigQuery data set as a log destination](../images/B18851_11_38.jpg)

Figure 11.38 – Configuring a BigQuery data set as a log destination

We don’t want to send all the logs to a data set, so we build an inclusion filter. The example filter will send only the logs related to a startup of a Compute Engine VM to Big Query. You can practice creating inclusion filters by building queries in **Logs Explorer**. If the query returns correct log entries, it can be copied and used as an inclusion filter:

![Figure 11.39 – Example inclusion filter that includes only logs related to a VM startup](../images/B18851_11_39.jpg)

Figure 11.39 – Example inclusion filter that includes only logs related to a VM startup

After creating the sink, we can check whether logs are sent to the BigQuery data set. If you don’t know how to start a query, select the data set and then **Query**.

![Figure 11.40 – How to query a data set](../images/B18851_11_40.jpg)

Figure 11.40 – How to query a data set

It will open an editor with a simple query that will look like this one:

```
SELECT * FROM `my-demo-project-xxx.bq_cloud_logging.syslog_20221219` LIMIT 1000
```

You can run it to see how the data set is organized and create a more precise one later:

![Figure 11.41 – A query that lists imported VM startup entries](../images/B18851_11_41.jpg)

Figure 11.41 – A query that lists imported VM startup entries

In *Figure 11**.41*, we can see a screenshot of the Big Query Explorer view that confirms the successful routing of logs to BigQuery and correct filtering. Only entries related to Compute Engine startup operation are displayed, as intended. Cloud Logging is a highly effective tool for in-depth troubleshooting of workloads. In the upcoming section, we will explore other tools that can aid in troubleshooting.

# Diagnostics

Google Cloud Monitoring and Logging will help you to make data-driven decisions to shape your application. Knowing how many underlying resources it uses, its current health state, and what type of errors it generates is critical for service availability and future improvements.

But there is more to what the Google Cloud operations suite can offer. This section will describe the additional operations suite services that help with application diagnostics for further improvements and troubleshooting. This is essential, particularly for serverless applications. For this type of system, monitoring the underlying platform is challenging, and browsing through platform logs to understand a user’s experience can also be tricky. Tools such as Trace and Profiler can help immensely here.

## Using cloud diagnostics to research an application issue

It is possible to diagnose an issue caused by a code in your application using Cloud Monitoring alone. Still, you will have to somehow go from metrics to the request and logs that generated that metric’s data point. Also, examining logs from a web service in Logs Explorer to track the most common errors would be doable but time-consuming. Therefore, this section will focus on dedicated Google Cloud observability tools that address those issues.

### Error Reporting

The Error Reporting service runs through the logs collected from your systems, automatically identifying the most common errors for your applications. As a result, just by looking at a dashboard, you can tell when errors started emerging, how many users were impacted, and which part of the code those issues are coming from.

Google Cloud services such as App Engine, Compute Engine, Cloud Functions, Cloud Run, and GKE have Error Reporting automatically enabled. This means that you do not have to configure anything to gain better insight into how your applications are performing.

If you wish to utilize Error Reporting for an application that does not run on any of the mentioned services, it is necessary to send the logs to Cloud Logging in a particular format. Cloud Logging will automatically enable Error Reporting when a user log that meets any of the supported patterns is ingested. Refer to this document to understand how to structure the log entry for your application:

<https://cloud.google.com/error-reporting/docs/formatting-error-messages>

![Figure 11.42 – Error reporting view for an example application](../images/B18851_11_42.jpg)

Figure 11.42 – Error reporting view for an example application

The preceding screenshot shows the **Error reporting** section for a Cloud Run application. Cloud Run is integrated with Error Reporting, so there is no need for any additional configuration. You can see which revision of Cloud Run is causing errors, when they occurred, and how many errors there were, and the corresponding code is presented at the bottom of this view.

### Trace

If you want to improve the performance of your applications and provide your users with a better experience, you can use Google Cloud Trace. This tool helps you identify the areas of your application that cause delays, so you can focus on optimizing those components and reducing overall latency.

It works by default with Google-managed services such as Cloud Run, Cloud Functions, and App Engine, but it is also available as a Trace API and SDK for Java, Node.js, Ruby, and Go to be used inside a Compute Engine VM or even outside Google Cloud. By using Trace, you can track potential bottlenecks and issues in your applications:

![Figure 11.43 – Trace view for an example application](../images/B18851_11_43.jpg)

Figure 11.43 – Trace view for an example application

Trace will help you understand your service’s topology and its flow of requests. In addition, it is responsible for monitoring calls to services and measuring the time it takes for each call to finalize.

### Profiler

Google Cloud Profiler helps developers to understand their code’s performance characteristics and identify what parts of their application consume the most resources. It continuously collects CPU usage and memory-allocation information from applications with a low-overhead Profiler package imported into their code (Java, Go, Node.js, and Python are supported). Profiler data can be sent to a Google Cloud project, even from another cloud or on-premises. The results of code performance analysis can be used to improve the speed and reduce the costs of an application.

![Figure 11.44 – A flame graph in the Profiler view](../images/B18851_11_44.jpg)

Figure 11.44 – A flame graph in the Profiler view

The preceding screenshot shows a Profiler view with a flame graph. Each frame in the graph represents a function in the code, and its relative size shows this function’s resource consumption proportion. Looking at the graph, you can see the resource usage patterns and potential hotspots of library functions in this demo application.

### Debugger

Cloud Debugger (unfortunately planned to shut down in the middle of 2023 and be replaced by an open source CLI tool called Snapshot Debugger: <https://github.com/GoogleCloudPlatform/snapshot-debugger>) allows you to inspect what is happening in the code of a running application. For example, suppose you located an error in your production application thanks to Error Tracking and examined the corresponding logs in Logs Explorer. Now you have precise information on what line of your code should be examined. As a next step, you can use Debugger to take a snapshot of what is happening in the code in this position and check the details of variables without pausing this service.

### Predefined roles for Google Cloud’s operations suite services

When working with Google Cloud’s operations suite products described in this section (Debugger, Profiler, and Trace, but also Logging and Monitoring, which were presented earlier in this chapter), it is essential to know what the permissions model looks like. For example, what role can be assigned to a user that wants only to view dashboards?

In the following table, you can find predefined roles that a user can leverage to access and edit dashboards and logs for each service described in this chapter:

![Table 11.2 – Predefined IAM roles for Google Cloud’s operations suite services](../images/B18851_11_Table_11.2.jpg)

Table 11.2 – Predefined IAM roles for Google Cloud’s operations suite services

Note that the mentioned observability services usually have a predefined **Viewer** role that allows for read-only access to dashboards, and an **Admin** role that provides full access to resources.

## Viewing Google Cloud status

You can monitor, in real-time, the status of Google Cloud services organized by by-products or regions at the following address: [https://status.cloud.google.com](https://status.cloud.google.com/).

The following screenshot shows the status dashboard of Google Cloud services. You can see that at the time of taking the screenshot, additional status information was published for the Cloud Firestore service in all regions.

![Figure 11.45 – Viewing the Google Cloud Service Health dashboard](../images/B18851_11_45.jpg)

Figure 11.45 – Viewing the Google Cloud Service Health dashboard

Your Cloud Console dashboard also has a Google Cloud Platform status card. If an issue you are experiencing is listed there, monitor the dashboard for incoming messages. Otherwise, if all services are operational, your issue is most likely related to your environment and is not global, so you should open a support case to get help.

![Figure 11.46 – Viewing the Google Cloud Platform status in the Cloud Console dashboard](../images/B18851_11_46.jpg)

Figure 11.46 – Viewing the Google Cloud Platform status in the Cloud Console dashboard

The preceding screenshot shows the Google Cloud Platform status with potential issues with the Google Cloud Console. This section is located by default in the top-right corner of the **DASHBOARD** view although this view can be customised, if needed.

# Estimating costs with the Google Cloud Pricing Calculator

Suppose your project team needs to determine the cost of an application that utilizes Compute Engine, GKE, Google Cloud Storage, and Interconnect to your on-premises data center. This is to secure a budget for the project. Instead of studying the pricing documentation for each service, you can quickly calculate the estimate using the Google Cloud Pricing Calculator.

You can access the Google Cloud Pricing Calculator web app through this link: <https://cloud.google.com/products/calculator>.

The calculator is designed to simplify estimating a monthly bill for even very complex architectures that utilize various Google Cloud services. It is organized by product, starting with Compute Engine and GKE, moving on to databases such as CloudSQL and Cloud Bigtable, networking options such as Interconnect and VPN, serverless services such as Cloud Run, and storage options such as Google Cloud Storage or Filestore. Users can customize each product’s components and provide detailed configurations, including class, tier, size, and estimated traffic. Once the configuration of every service is complete, you simply click **ADD TO ESTIMATE** and the calculator will instantly provide a monthly cost for all the included services.

![Figure 11.47 – Google Cloud Pricing Calculator supports various Google Cloud services](../images/B18851_11_47.jpg)

Figure 11.47 – Google Cloud Pricing Calculator supports various Google Cloud services

Here’s an example of calculating the monthly cost for a Compute Engine VM that will be used for a web service running on Ubuntu in the **europe-central-2** region, 24/7. This VM requires a 100-GB boot drive and needs to be available from the internet.

In the **SERVICE SELECTION** pane of the Pricing Calculator, shown in *Figure 11**.48*, find a **Compute Engine** service and provide details such as the number of VMs (**1**), an operating system (**Debian**), an instance type (depending on the web server requirements – in this case, we will leave the default **E2** type).

![Figure 11.48 – Preparing a price estimate for a VM instance](../images/B18851_11_48.jpg)

Figure 11.48 – Preparing a price estimate for a VM instance

Select **europe-central2** as the region and choose the **Balanced persistent disk** option for the boot disk with **100** GB of storage, as shown in *Figure 11**.49*. Additionally, specify the duration for which you plan to run the VM as **24** hours, and **7** days per week. Also, add one public IP address. Leave all other values as their defaults.

![Figure 11.49 – Preparing a price estimate for a VM instance (continuation)](../images/B18851_11_49.jpg)

Figure 11.49 – Preparing a price estimate for a VM instance (continuation)

Once you have entered all your required details, simply click on the **ADD TO ESTIMATE** button shown in *Figure 11**.49* to receive an accurate estimate of your monthly operating costs for the VM.

![Figure 11.50 – Google Cloud Pricing Calculator final estimate for running a VM instance](../images/B18851_11_50.jpg)

Figure 11.50 – Google Cloud Pricing Calculator final estimate for running a VM instance

Considering the settings provided, the Pricing Calculator generated two estimates for our Compute Engine VM. The first estimate is for the VM itself, which will be billed at a monthly rate of $65.94. The additional boot drive will also be charged at $13.00 per month. Consequently, the monthly cost to keep the web application running will be $78.94. Please note that the Pricing Calculator will automatically update the estimate if any changes or new services are added. You can add more Google Cloud services to this estimate to reflect the architecture you plan to run on Google Cloud.

If you're interested in understanding the pricing for a particular service, you can find a comprehensive pricing list for Google Cloud services at <https://cloud.google.com/pricing/list>. Additionally, if you anticipate using services for a minimum of one year, you may be eligible for Committed Use Discounts (CUDs). For more information on CUDs, please visit <https://cloud.google.com/docs/cuds>.

# Summary

Even though you may get fewer observability-related questions compared to the other services on the ACE exam, the Monitoring and Logging services are essential areas in your hands-on experience with Google Cloud. Initially, observability helps you better understand how Google Cloud services work. Later, when you run your applications in production, it will help you to improve customer experience and reduce costs.

To get the most out of observability, start with out-of-the-box dashboards, add agents for Compute Engine VMs to collect additional metrics, and create logs-based metrics and alerts. Next, centralize monitoring into a dedicated project or logs by aggregating sinks. Finally, use Trace, Profiler, and Debugger to optimize your application.

# Questions

Answer the following questions to test your knowledge of this chapter:

1. While looking at the **Cloud Monitoring** dashboard, you noticed that the Compute Engine VM memory consumption chart is empty. What can you do to fix the problem?
   1. Edit the **VM Instances** dashboard in the **Cloud Monitoring** section and change a memory chart to **VM Memory Total** instead of **VM** **Memory Used**.
   2. Verify whether Ops Agent runs inside this VM using **sudo service** **google-cloud-ops-agent status**.
   3. Restart the VM.
   4. Make sure Cloud Monitoring is enabled in this project and your account has a **Monitoring** **Viewer** role.
2. Users are complaining that the response time of your web app has increased. You want to use the Google Cloud suite to investigate the issue. Which service will help you to track latencies?
   1. Trace
   2. Profiler
   3. Cloud Logging
   4. Debugger
3. Your company’s policy is to only deploy workloads in low-carbon Google Cloud locations. How can you ensure that all your logs are stored in a location compliant with this policy?
   1. It is impossible to choose where logs are stored as they are always stored in the same region as the system generating them.
   2. You need to create a log bucket in a low-carbon location and point the log sinks to this new bucket.
   3. You need to create a log bucket in a low-carbon location. Cloud Logging will detect the new bucket and redirect logs automatically.
   4. You need to edit the existing log bucket and change its location to a low-carbon one.
4. You are looking for inexpensive storage to keep your logs long-term. Which approach would be the best?
   1. Edit an existing sink and send logs to BigQuery.
   2. Create a new sink and send logs to Google Cloud Storage.
   3. Edit a **\_Default** log bucket to change its retention to 3,650 days.
   4. Both bucket types can be a good choice because there is no difference between keeping logs in a log bucket or a Google Cloud Storage bucket.
5. You got a task to configure monitoring for a new project. The team owning this project wants to deploy services running on Compute Engine, Google Cloud Storage, and GKE. What steps should you follow to collect metrics from those services?
   1. Go to the **Cloud Monitoring** section and enable monitoring. All metrics for the services that your team wants to deploy will be automatically collected.
   2. Go to the **Cloud Monitoring** section and enable **Monitoring**. Select **+CREATE DASHBOARD** and create dashboards for the required services.
   3. Cloud Monitoring is enabled by default, and once services are deployed, service-specific metrics will automatically appear in the **Monitoring** dashboard. For a Compute Engine VM, you will need to install Ops Agent for better OS and applications observability.
   4. Cloud Monitoring is enabled by default, and once services are deployed, service-specific metrics will automatically appear in the **Monitoring** dashboard. No additional configuration is required.

# Answers

The answers to the preceding questions are provided here:

1B, 2A, 3B, 4B, 5C