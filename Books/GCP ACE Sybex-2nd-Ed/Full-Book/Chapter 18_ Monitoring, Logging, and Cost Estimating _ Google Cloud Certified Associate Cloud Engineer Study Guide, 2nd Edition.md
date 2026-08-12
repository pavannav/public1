---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **2.1 Planning and estimating Google Cloud product use using the Pricing Calculator**
- **4.6 Monitoring and logging**

---

Monitoring system performance is an essential part of cloud engineering. In this chapter, you will learn about Cloud Operations suite, a Google Cloud service for resource monitoring, logging, and tracing. You will start by creating alerts based on resource metrics and custom metrics. Next, you will turn your attention to logging, with a discussion of how to create log sinks to store logging data outside of Cloud Operations. You'll also see how to view and filter log data. Cloud Operations includes diagnostic tools such as Cloud Trace, which you'll learn about as well. We'll close out the chapter with a review of the Pricing Calculator for estimating the cost of Google Cloud resources and services.

## Cloud Monitoring

Cloud Monitoring is a service for collecting performance metrics, logs, and event data from our resources. Metrics include measurements such as the average percentage of CPU utilization over the past minute and the number of bytes written to a storage device in the last minute. Cloud Monitoring includes many predefined metrics. Some examples are shown in [Table 18.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-tbl-0001) that you can use to assess the health of your resources and, if needed, trigger alerts to bring your attention to resources or services that are not meeting service-level objectives.

[**TABLE 18.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-tbl-0001) Example Cloud Monitoring metrics

| Google Cloud Product | Metric |
| --- | --- |
| Compute Engine | CPU utilization |
| Compute Engine | Disk bytes read |
| BigQuery | Execution times |
| Bigtable | CPU load |
| Cloud Functions | Execution count |

Cloud Monitoring works in hybrid environments, with support for Google Cloud, Amazon Web Services, and on-premises resources.

### Creating Dashboards

Metrics are defined measurements on a resource collected at regular intervals. Metrics return aggregate values, such as the maximum, minimum, or average value of the item measured, which could be CPU utilization, amount of memory used, or number of bytes written to a network interface.

For this example, assume you are working with a VM that has Apache Server and PHP installed. VMs will collect basic metrics and logs, but for more detailed metrics, you can install the Ops Agent, which includes both monitoring and logging support. To install the Ops Agent on a Linux VM, execute the following command at the shell prompt (note that these are not `gcloud` commands):

```
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh sudo bash add-google-cloud-ops-agent-repo.sh --also-install
```

VMs with agents installed collect monitoring and logging data and send it to Cloud Monitoring and Cloud Logging.

[Figure 18.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0001) shows an example of the Cloud Monitoring Overview page. It includes information on the status of monitoring setup, available dashboards, as well as links to related articles and blog posts. Details on incidents and health checks are available in the overview as well.

![Snapshot of cloud Monitoring Overview page](../images/c18f001.png)


[**FIGURE 18.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0001) Partial view of Cloud Monitoring Overview page

In the left panel of the Cloud Monitoring page, you can select other monitoring views, including dashboards. An example list of default dashboards is shown in [Figure 18.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0002). The list includes dashboards for App Engine, BigQuery, Cloud Storage, Firewalls, and VPN.

![Snapshot of available dashboards in Cloud Monitoring](../images/c18f002.png)


[**FIGURE 18.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0002) Available dashboards in Cloud Monitoring

Each of the dashboards shows information relevant to the service. For example, the Cloud Storage dashboard shows data on incidents, buckets, requests and network traffic sent, as shown in [Figure 18.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0003).

In addition to the predefined dashboards available in Cloud Monitoring, you can create your own by clicking Create Dashboard to display the window shown in [Figure 18.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0004).

If you choose to create a line chart, a chart component is added to the dashboard, as shown in [Figure 18.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0005). In this example, the mean CPU Utilization metric will be plotted.

### Using Metric Explorer

Metric Explorer is another feature of Cloud Monitoring. It allows you to view a wide variety of metrics by choosing from a list of metrics. [Figure 18.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0006) shows the main page of Metric Explorer, and [Figure 18.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0007) shows details of metrics you can view related to Cloud Storage buckets.

After you select the object count metric for Cloud Storage buckets, Metric Explorer displays a line graph, as shown in [Figure 18.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0008).

![Snapshot of cloud Storage monitoring dashboard](../images/c18f003.png)


[**FIGURE 18.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0003) Cloud Storage monitoring dashboard

![Snapshot of creating your own dashboard begins with choosing a chart.](../images/c18f004.png)


[**FIGURE 18.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0004) Creating your own dashboard begins with choosing a chart.

![Snapshot of adding a line chart to display mean CPU utilization](../images/c18f005.png)


[**FIGURE 18.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0005) Adding a line chart to display mean CPU utilization

![Snapshot of main page of Metric Explorer](../images/c18f006.png)


[**FIGURE 18.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0006) Main page of Metric Explorer

![Snapshot of metrics available for Cloud Storage Buckets](../images/c18f007.png)


[**FIGURE 18.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0007) Metrics available for Cloud Storage Buckets

![Snapshot of line chart of object count metric for Cloud Storage buckets](../images/c18f008.png)


[**FIGURE 18.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0008) Line chart of object count metric for Cloud Storage buckets

### Creating Alerts

Dashboards are useful for getting a quick overview of a set of key metrics, and Metric Explorer is useful when you are investigating an issue and need to view a variety of metrics. If you want to be automatically notified when a metric exceeds some threshold, you can create alerts.

The main Alerting page in Cloud Monitoring is shown in [Figure 18.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0009). It includes a summary count of incidents firing, incidents responded to, and alert policies. There are also detailed listings of incidents and policies.

![Snapshot of alerting main page of Cloud Logging](../images/c18f009.png)


[**FIGURE 18.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0009) Alerting main page of Cloud Logging

To create an alert, you create a policy. A policy is defined for a metric. For example, [Figure 18.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0010) shows the start of defining a policy to alert you when there is a backlog of unacknowledged messages in a Cloud Pub/Sub topic.

![Snapshot of creating a policy for a Pub/Sub backlog](../images/c18f010.png)


[**FIGURE 18.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0010) Creating a policy for a Pub/Sub backlog

For a policy, you also specify the condition type, which can be a threshold or a metric absence. A threshold condition triggers when the metric value is above or falls below the specified value for the specified period of time. A metric absence condition is based on the absence of data for a specified period of time (see [Figure 18.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0011)).

You also specify an alert trigger, which specifies the scope of the data you consider when checking the alert condition. [Figure 18.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0012) shows the possible options, which include Any Time Series Violates, Percent Of Time Series Violates, Number Of Time Series Violates, and All Time Series Violates.

The last step of creating a policy is to specify notification channels, as shown in [Figure 18.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0013).

Options for notification channels include:

- Email, which sends messages to an email address
- Slack, which sends messages to Slack channels
- SMS, which sends text messages
- Cloud Pub/Sub, which post messages to a Cloud Pub/Sub topic
- PagerDuty, which sends messages to a popular SaaS platform for DevOps
- Webhooks, which invokes an HTTP-based callback function to send messages to an app

![Snapshot of configuring an alert](../images/c18f011.png)


[**FIGURE 18.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0011) Configuring an alert

![Snapshot of alert trigger options](../images/c18f012.png)


[**FIGURE 18.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0012) Alert trigger options

You can also specify a period for automatically closing the alert, labels, and documentation to be included with the alert.

![Snapshot of creating notification channels for an alert](../images/c18f013.png)


[**FIGURE 18.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0013) Creating notification channels for an alert


---

### Too Many Alerts Are as Bad as Too Few

Be careful when crafting monitoring policies. You do not want to subject engineers to so many alerts that they begin to ignore them. This is sometimes called *alert fatigue*. Policies that are too sensitive will generate alerts when no human intervention is required. For example, CPU utilization may regularly spike for brief periods of time. If this is a normal pattern for your environment, and it is not adversely impacting your ability to meet service level agreements, then there is little reason to alert on them. Design policies to identify conditions that actually require the attention of an engineer and are not likely to resolve on their own. Use thresholds that are long enough so that conditions are not triggered on transient states that will not last long. Often by the time an engineer resolves it, the condition is no longer triggering. Designing policies for monitoring is something of an art. You should assume you will need multiple iterations to tune your policies to find the right balance of generating just the right kinds of useful alerts without also generating alerts that are not helpful.

---

## Cloud Logging

Cloud Logging is a service for collecting, storing, filtering, and viewing log and event data. Logging is a managed service, so you do not need to configure or deploy servers to use the service.

The Associate Cloud Engineering Exam guidelines note several logging tasks a cloud engineer should be familiar with:

- Configuring log routers
- Configuring log sinks
- Viewing and filtering logs
- Viewing message details

We'll review each of these in this section.

### Log Routers and Log Sinks

Log data is ingested by the Cloud Logging API. From there, log messages are routed to one of three types of sinks: the Required log sink, the Default log sink, or a user-defined log sink.

Sinks are associated with a Google Cloud resource, such as a billing account, project, folder, or organization. Google creates a Required and a Default sink for each billing account, project, folder, or organization.

The Log Router is a service that receives log messages and applies inclusion and exclusion filters to determine which log sinks should receive the message. Log Router supports using combinations of sinks to route logs to multiple storage locations.

### Configuring Log Sinks

The Required log sink is used to store admin activity, system events, and access transparency logs. These logs are stored for 400 days, and that duration cannot be changed.

The Default log sink receives log messages that are not sent to the Required log sink. These logs are stored for 30 days by default, but you can change that by configuring a custom retention policy. A 30-day retention is sufficient if you use logs to diagnose operational issues but rarely view the logs after a few days. Your organization may need to keep logs longer to comply with government or industry regulations. You may also want to analyze logs to gain insight into application performance. For these use cases, it is best to export logging data to a long-term storage system like Cloud Storage or BigQuery.

You can create user-defined log buckets in a project. This allows you to route a subset of log messages to a specific Cloud Storage bucket. You can configure a custom retention on a user-defined log bucket.

In addition to storing log messages, Cloud Logging supports log metrics. These are metrics that are based on the content of log messages. If a log message meets a log metric pattern, that message is reflected in the Cloud Monitoring metric associated with the pattern.

Cloud Logging supports several destinations where messages can be routed:

- Cloud Storage, for long-term storage of logs in JSON format
- BigQuery, for logs that will be analyzed
- Cloud Pub/Sub, for JSON messages that are consumed by third-party integrations
- Cloud Logging, for viewing and storing for user-configurable time periods

### Viewing and Filtering Logs

To view the contents of logs, navigate to the Cloud Logging section of the console to view the Log Explorer page, shown in [Figure 18.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0014).

Log Explorer allows you to view log messages. Since logs are often quite large, it is important to be able to quickly filter messages to only those you are interested in. Log Explorer allows you to filter messages based on:

- Time (see [Figure 18.15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0015))
- Resource type (see [Figure 18.16](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0016))
- Severity (see [Figure 18.17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0017))
- Log query (see [Figure 18.18](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0018))

![Snapshot of log Explorer page of the Cloud Logging console](../images/c18f014.png)


[**FIGURE 18.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0014) Log Explorer page of the Cloud Logging console

![Snapshot of time restriction options in Log Explorer](../images/c18f015.png)


[**FIGURE 18.15**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0015) Time restriction options in Log Explorer

![Snapshot of resource filtering options in Log Explorer](../images/c18f016.png)


[**FIGURE 18.16**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0016) Resource filtering options in Log Explorer

![Snapshot of severity filtering options in Log Explorer](../images/c18f017.png)


[**FIGURE 18.17**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0017) Severity filtering options in Log Explorer

![Snapshot of queries in Log Explorer can be as simple as keyword searches.](../images/c18f018.png)


[**FIGURE 18.18**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0018) Queries in Log Explorer can be as simple as keyword searches.

### Viewing Message Details

Each log entry is displayed as a single line when you view the contents of logs. Notice the triangle icon at the left of the line. If you click that icon, the line will expand to show additional details. For example, [Figure 18.19](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0019) shows a log entry expanded by one level.

![Snapshot of a log entry expanded by one level](../images/c18f019.png)


[**FIGURE 18.19**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0019) A log entry expanded by one level

In the case of the first-level expansion, you see high-level information such as `insertId`, `logName`, and `receiveTimestamp`. You also see other structured data elements, such as `protoPayload` and `resource`. [Figure 18.20](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0020) shows the protoPayload structure expanded.

![Snapshot of a log entry with the protoPayload structure expanded](../images/c18f020.png)


[**FIGURE 18.20**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0020) A log entry with the protoPayload structure expanded

You can continue to drill down individually into each structure if there is a triangle at the left. For example, in the protoPayload structure, you could drill down into `authenticationInfo`, `authorizationInfo`, and `requestMetadata`, among others. [Figure 18.21](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0021) shows the `requestMetadata` section expanded.

![Snapshot of details of the requestMetadata section of a log message](../images/c18f021.png)


[**FIGURE 18.21**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0021) Details of the `requestMetadata` section of a log message

## Using Cloud Trace and Google Cloud Status

Google Cloud provides diagnostic tools that software developers can use to collect information about the performance and functioning of their applications. Specifically, developers can use Cloud Trace to collect data as their applications execute.

### Overview of Cloud Trace

Cloud Trace is a distributed tracing system for collecting latency data from an application. This helps developers understand where applications are spending their time and to identify cases where performance is degrading.

From the Cloud Trace console, you can list traces generated by applications running in a project. Traces are generated when developers specifically call Cloud Trace from their applications. In addition to seeing lists of traces, you can create reports.

For the purpose of the Associate Cloud Engineering Exam, remember that Cloud Trace is a distributed tracing application that helps developers and DevOps engineers identify sections of code that are performance bottlenecks.

### Viewing Google Cloud Status

In addition to understanding the state of your applications and services, you need to be aware of the status of Google Cloud services. You can find this status in the Google Cloud Status Dashboard, which displays information on service status: Available, Service Disruption, or Service Outage.

To view the status of Google Cloud services, navigate to `https://status.cloud.google.com`. [Figure 18.22](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0022) shows the overview status of major geographical areas.

![Snapshot of overview status of Google Cloud services](../images/c18f022.png)


[**FIGURE 18.22**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0022) Overview status of Google Cloud services

There are also tabs for seeing more detail within major geographic regions. For example, [Figure 18.23](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0023) shows more details about the status of American regions.

## Using the Pricing Calculator

Google provides a Pricing Calculator to help Google Cloud users understand the costs associated with the services and configuration of resources they choose to use. You will find the Pricing Calculator at `https://cloud.google.com/products/calculator` (see [Figure 18.24](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0024)).

![Snapshot of more detailed view of American service status](../images/c18f023.png)


[**FIGURE 18.23**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0023) More detailed view of American service status

![Snapshot of google Cloud Pricing Calculator](../images/c18f024.png)


[**FIGURE 18.24**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0024) Google Cloud Pricing Calculator

With the Pricing Calculator, you can specify the configuration of resources, the time they will be used, and in the case of storage, the amount of data that will be stored. Other parameters can be specified too. Those will vary according to the service you are calculating charges for. [Figure 18.25](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0025) shows some of the services available to use with the Pricing Calculator.

![Snapshot of partial list of services available in the Pricing Calculator](../images/c18f025.png)


[**FIGURE 18.25**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0025) Partial list of services available in the Pricing Calculator

After selecting a service, you can specify a configuration specific to that service. For example, when estimating the price of a Compute Engine virtual machine, you will provide:

- Number of instances
- Machine types
- Operating system
- Average usage per day and week
- Persistent disks
- Load balancing
- Cloud tensor processing units (TPUs) (for machine learning applications)

After you enter data in the fields, the Pricing Calculator will generate an estimate, such as that shown in [Figure 18.26](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#c18-fig-0026).

Different resources will require different parameters for an estimate. For example, when estimating the price of using BigQuery you will need to specify both storage and query parameters. The storage parameters are for active and long-term storage as well as the volume of data in streaming inserts and streaming reads. For queries, you will need to specify the volume of data queried because BigQuery charges based on the amount of data processed or scanned to get query results. Currently, the first 1 TB of data processed during querying per month is free.

![Snapshot of example price estimate for five e2-standard-2 VMs](../images/c18f026.png)


[**FIGURE 18.26**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml#R_c18-fig-0026) Example price estimate for five e2-standard-2 VMs

## Summary

As a cloud engineer, you are responsible for monitoring the health and performance of applications and cloud services. Google Cloud provides multiple tools, including monitoring, logging, and tracing services.

Cloud Monitoring allows you to define alerts on metrics, such as CPU utilization, so that you can be notified if part of your infrastructure is not performing as expected. Cloud Logging collects, stores, and manages log entries. Logs can be stored in Cloud Logging–provided buckets or user-defined buckets. Log messages can be routed to Cloud Storage, BigQuery, or Cloud Pub/Sub. Cloud Trace provides distributed tracing services to identify slow-running parts of code.

You can always get the status of Google Cloud services at the Google Cloud Status Dashboard at `https://status.cloud.google.com`.

The Pricing Calculator is designed to help you estimate the cost of services in the Google Cloud. It is available at `https://cloud.google.com/products/calculator`.

## Exam Essentials

- **Understand the need for monitoring and the role of metrics.**   Metrics provide data on the state of applications and infrastructure. You create conditions, like CPU exceeding 80 percent for 5 minutes, to trigger alerts. Alerts are delivered by notification channels. Google Cloud has a substantial number of predefined metrics, but you can create custom metrics as well.
- **Know how to collect, store, filter, and display log data using Cloud Logging.**   Logs can come from virtually any source. Logging keeps log data in the Default bucket for 30 days unless a custom retention policy is specified. If you need to keep log data longer than that, you need to export the data to a log sink. Log sinks may be a Cloud Storage bucket, a BigQuery data set, or a Cloud Pub/Sub topic.
- **Know how to filter logs.**   Logs can contain a large amount of data. Use filters to search for text or labels, limit log entries by log type and severity, and restrict the time range to a period of interest.  
    
  Log entries are hierarchical. Cloud Logging shows a single-line summary for a log entry by default, but you can drill down into the details of a log entry. Use the Expand All and Collapse All options to quickly view or hide the full details of a log entry.
- **Know how to use the Cloud Trace distributed tracing service.**   Software developers include Cloud Trace code in their applications to record trace data. Trace data can be viewed as individual traces, or you can create reports that include parameters specifying a subset of traces you want to include.
- **Know where Google Cloud publishes the status of services.**   The Google Cloud Status page includes a list of all services, their current status, and the status over the near past. If there is an incident in a service, you will find additional details on the impact and root cause of the problem.
- **Know how to use the Pricing Calculator to estimate the cost of resources and services in the Google Cloud.**   The calculator is available at `https://cloud.google.com/products/calculator`. There is a separate calculator for each service. Each service has its own set of parameters for estimating costs. The Pricing Calculator allows you to estimate the cost of multiple services and generate a total estimate for all those services.

## Review Questions

1. What Cloud Operations service is used to generate alerts when the CPU utilization of a VM exceeds 80 percent?
   1. Cloud Logging
   2. Cloud Monitoring
   3. Cloud Trace
   4. Cloud Debugger
2. You have just created a virtual machine, and you'd like to collect detailed metrics about the VM. What do you need to do to the VM to have this happen?
   1. Install a Cloud Operations image.
   2. Install the Ops Agent on the VM.
   3. Edit the VM configuration in Cloud Console and select the Monitor With Cloud Monitoring option.
   4. Set a notification channel.
3. Where can Cloud Monitoring be used to monitor resources?
   1. In Google Cloud only
   2. In Google Cloud and Amazon Web Services only
   3. In Google Cloud and on-premises data centers
   4. In Google Cloud, Amazon Web Services, and on-premises data centers
4. You are responsible for the reliability and availability of several services running in Kubernetes Engine. You have determined that you need to monitor several metrics to get information on the state of the services. You'd like to see all of these metrics displayed as line charts, one for each metric. All of the line charts should be available on a single-page view. What would you use to create such a page view?
   1. Cloud Monitoring Dashboard
   2. Cloud Logging sink
   3. Cloud Monitoring Alert
   4. BigQuery data set
5. You have created a condition of CPU utilization, and you want to receive notifications. Which of the following are options?
   1. Email only
   2. PagerDuty only
   3. Webhooks and PagerDuty
   4. Email, PagerDuty, and Webhooks
6. When you create a policy to notify you of a potential problem with your infrastructure, you can specify optional documentation. Why would you bother putting documentation in that form?
   1. It is saved to Cloud Storage for future use.
   2. It can help you or a colleague understand the purpose of the policy.
   3. It can contain information that would help someone diagnose and correct the problem.
   4. Options B and C.
7. What is alert fatigue, and why is it a problem?
   1. Too many alert notifications are sent for events that do not require human intervention, and eventually DevOps engineers begin to pay less attention to notifications.
   2. Too many alerts put unnecessary load on your systems.
   3. Too few alerts leave DevOps engineers uncertain of the state of your applications and infrastructure.
   4. Too many log messages make it hard to find important messages.
8. How long is log data stored in the Default bucket of Cloud Logging?
   1. 7 days
   2. 15 days
   3. 30 days
   4. 60 days
9. You need to store log entries for a longer period of time than Cloud Logging retains them in the Default bucket. What is the best option for preserving log data?
   1. There is no option; once the data retention period passes, Cloud Logging deletes the data.
   2. Create a user-defined bucket and configure a retention policy.
   3. Write a Python script to use the Cloud Logging API to write the data to Cloud Storage.
   4. Write a Python script to use the Cloud Logging API to write the data to BigQuery.
10. Which of the following are options for logging sinks?
    1. Cloud Storage bucket only
    2. BigQuery dataset and Cloud Storage bucket only
    3. Cloud Pub/Sub topic only
    4. Cloud Storage bucket, BigQuery dataset, and Cloud Pub/Sub topic
11. Which of the following can be used to filter log entries when viewing logs in Cloud Logging?
    1. Log query only
    2. Resource type and severity only
    3. Time and severity only
    4. Log query, resource type, severity, and time
12. Which of the following is not a standard log level that can be used to filter log viewings?
    1. Critical
    2. Halted
    3. Warning
    4. Info
13. You are viewing log entries and spot one that looks suspicious. You are not familiar with that kind of log entry, and want to find out what, specifically, is in a field called `metadataRequest`. What would you do?
    1. Expand the `metadataRequest` field in the JSON structure of the message.
    2. View the message in Metric Explorer.
    3. Write a Python script to reformat the log entry.
    4. Click the Show Detail link next to the log entry.
14. What Cloud Operations service is best for identifying where bottlenecks exist in your application?
    1. Monitoring
    2. Logging
    3. Trace
    4. Debugger
15. There is a performance problem in a microservice. You have reviewed application outputs but cannot identify the problem. What Cloud Operations service would you use to gain insight into the performance of the services throughout execution?
    1. Monitoring
    2. Logging
    3. Trace
    4. Debugger
16. You believe there may be a problem with BigQuery in the us-central zone. Where would you go to check the status of the BigQuery service for the quickest access to details?
    1. Email Google Cloud Support.
    2. Check `https://status.cloud.google.com`.
    3. Check `https://bigquery.status.cloud.google.com`.
    4. Call Google tech support.
17. You would like to estimate the cost of Google Cloud resources you will be using. Which services would require you to have information on the virtual machines you will be using?
    1. Compute Engine and BigQuery
    2. Compute Engine and Kubernetes Engine
    3. BigQuery and Kubernetes Engine
    4. BigQuery and Cloud Pub/Sub
18. You are generating an estimate of the cost of using BigQuery. One of the parameters is Query Pricing. You have to specify a value in TB units. What is the value you are specifying?
    1. The amount of data stored in BigQuery
    2. The amount of data returned by the query
    3. The amount of data scanned by the query
    4. The number of partitions used
19. Why do you need to specify the operating system to be used when estimating the cost of a VM?
    1. All operating systems are charged a fixed rate.
    2. Some operating systems incur a cost.
    3. It's not necessary; it is only included for documentation.
    4. To estimate the cost of Bring Your Own License configurations.
20. Which types of log messages are sent to the Required log sink?
    1. Operating system messages only
    2. Admin activity messages only
    3. Admin activity and system events only
    4. Admin activity, system events, and access transparency