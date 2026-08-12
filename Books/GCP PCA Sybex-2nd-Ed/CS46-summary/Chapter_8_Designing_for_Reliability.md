# Chapter 8: Designing for Reliability

**Exam Objectives Covered:**
- 4.3 Developing procedures to ensure reliability of solutions in production (e.g., chaos engineering, penetration testing)
- 6.1 Monitoring/logging/profiling/alerting solution
- 6.2 Deployment and release management
- 6.3 Assisting with the support for deployed solutions
- 6.4 Evaluating quality control measures

---

**Reliability** is the probability that a system will be able to process some specified workload for some period of time.  
**Availability** is the percentage of time that a system is functioning and able to meet some specified workload.

This chapter focuses on reliability from a reliability engineering (SRE) perspective: how to design, monitor, and maintain reliable and available services.

---

## Improving Reliability with Cloud Operations Suite

Providing reliable software services requires insight into how that software is functioning. The state of software systems changes constantly, especially in the cloud. Examples of things that can go wrong include:

- More demand than anticipated requiring additional compute infrastructure
- Seasonal workload spikes (e.g., holiday shopping)
- Errors disrupting workflows and creating backlogs
- A database running out of persistent storage
- Dropping cache hit ratio causing increased read latency

**Cloud Operations Suite** (formerly Stackdriver) is a comprehensive set of services for collecting data on the state of applications and infrastructure. It provides three ways of collecting reliability information:

| Service | Purpose |
|---|---|
| **Monitoring** | Understand performance and utilization of applications and resources |
| **Logging** | Collect service-specific details about operations of services |
| **Alerting** | Notify responsible parties about issues needing attention |

Google Cloud also offers:
- **Cloud Profiler** – continuous CPU and heap profiling
- **Cloud Trace** – distributed tracing and identifying high-latency services
- **Cloud Debugger** – inspecting the state of running applications

### Monitoring with Cloud Monitoring

**Monitoring** is the practice of collecting measurements of key aspects of infrastructure and application performance. These measurements are known as **metrics** and are made repeatedly over time, constituting a **time series**.

#### Metrics

Metrics have a particular pattern: a property of an entity, a time range, and a numeric value. GCP has defined metrics for:

- GCP services (BigQuery, Cloud Storage, Compute Engine)
- Operating system and application metrics collected by Cloud Monitoring agents on VMs
- Anthos metrics (Kubernetes and Istio metrics)
- AWS metrics for Amazon Web Services resources (e.g., EC2 instances)
- External metrics including Prometheus-defined metrics

Metrics can also have **labels** associated with them, useful for querying or filtering monitored resources.

#### Time Series

A **time series** is a set of metrics recorded with a time stamp, associated with a monitored entity. Time is often shown in epoch seconds (seconds elapsed since midnight January 1, 1970, UTC, excluding leap seconds).

**TABLE 8.1** Example of a CPU utilization time series for a VM instance

| Time | CPU Utilization |
|---|---|
| 1563838664 | 76 |
| 1563838724 | 67 |
| 1563838784 | 68 |
| 1563838844 | 62 |
| 1563838904 | 71 |
| 1563838964 | 73 |
| 1563839024 | 73 |
| 1563839084 | 61 |
| 1563839144 | 65 |

Cloud Monitoring provides an API for working with time-series metrics. The API supports:

- Retrieving time series in a project based on metric name, resource properties, and other attributes
- Grouping resources based on properties
- Listing group members
- Listing metric descriptors
- Listing monitored entities descriptors

Common ways of working with metrics are using **dashboards** and **alerting**.

#### Dashboards

**Dashboards** are visual displays of time series.

![Snapshot of service dashboard showing time-series data.](../images/c08f001.png)

**FIGURE 8.1** Service dashboard showing time-series data  
*Source: `cloud.google.com/blog/products/management-tools/cloud-monitoring-dashboards-using-an-api`*

Dashboards are customized by users to show data that helps monitor and meet service-level objectives or diagnose problems with a particular service. They are especially useful for determining **correlated failures**. For example, a dashboard may indicate an SLO breach for purchase transaction response times; another dashboard can then surface metrics for the application server, database, and cache to determine which component is causing the problem.

Crafting informative dashboards is often an iterative process. You may know key performance indicators when you first create a service, but over time you may monitor additional metrics based on past incidents.

### Alerting with Cloud Monitoring

**Alerting** is the process of monitoring metrics and sending notifications when custom-defined conditions are met. The goal is to notify someone when there is an incident or condition that cannot be automatically remediated and that puts SLOs at risk.

#### Policies, Conditions, and Notifications

**Alerting policies** are sets of conditions, notification specifications, and selection criteria for determining resources to monitor.

**Conditions** are rules that determine when a resource is in an unhealthy state. Finding the optimal threshold may take experimentation:
- **Threshold too high** – performance may degrade without notification
- **Threshold too low** – too many **false alerts**, leading to **alert fatigue** where engineers become less likely to pay attention to alerts

#### Reducing Alerts

Reliability can be improved by automatically responding to changes, reducing the need for alerts:

- Use **autoscaling** in instance groups with load balancing to handle workload spikes automatically
- Use **managed services** (e.g., BigQuery instead of a self-managed database) — Google handles monitoring and incident response for serverless products

### Logging with Cloud Logging

**Cloud Logging** is a centralized log management service. Logs are collections of messages that describe events in a system. Unlike metrics (collected at regular intervals), log messages are written only when a particular event occurs.

Examples:
- A new OS user account granted root privileges generates an audit log entry
- A database connection error triggers an application log message
- Java garbage collection start/end generates log messages

Key features of Cloud Logging:
- Store, search, analyze, and monitor log messages from GCP resources, other clouds, or on-premises applications
- Export logs to **BigQuery** for SQL-based analysis
- Integration with **Cloud Monitoring** — log messages can trigger alerts and be used to create metrics
- Default retention: **30 days**; export to Cloud Storage or BigQuery for longer retention
- **Log Analytics** (Pre-GA at time of writing) — query log data directly using BigQuery and SQL
- Stream logs to **Cloud Pub/Sub** for third-party near real-time processing

**Summary of Cloud Operations Suite components:**

| Tool | What it Collects | When Data Is Written |
|---|---|---|
| Monitoring | Metrics — measurements of resource attributes over time | At regular intervals |
| Alerting | Evaluates metric data against predefined conditions | When a condition threshold is met |
| Logging | Messages about specific events in applications/infrastructure | When a specific event occurs |

### Open Source Observability Tools

In addition to Google Cloud–specific services, widely used open source tools include Prometheus and Grafana.

#### Prometheus

Prometheus is a monitoring tool that collects metrics data from targets by **scraping HTTP endpoints** of target services. It is hosted by the Cloud Native Computing Foundation (which also hosts Kubernetes).

Key features:
- Uses a **multidimensional data model** based on key-value pairs (e.g., transaction latency in a specific environment, pod, and app version)
- **PromQL** is the query language
- Includes a server for collecting metrics, client libraries for instrumenting applications, and an alert manager

> **Note:** **Managed Service for Prometheus** is a managed service providing a Prometheus-compatible monitoring stack (Pre-GA at time of writing). It uses Google's in-memory time-series database called **Monarch**. See: `research.google/pubs/pub50652`

#### Grafana

Grafana is an open source **visualization tool** often used with Prometheus.

Key features:
- Queries data from existing data sources rather than importing into Grafana-managed storage
- Can pull data from monitoring services, relational databases, time-series databases, and other sources
- Brings different data together in a single dashboard — no complex data integration pipelines required before visualizing data

---

## Release Management

**Release management** is the practice of deploying code and configuration changes to environments (production, test, staging, development). It is an integral part of **DevOps**, which combines software engineering and system administration efforts.

Release management improves reliability by:
- Enabling developers to deploy corrected code quickly (no waiting for batch releases)
- Enabling frequent deployments of small changes (reduces risk of new bugs vs. large batch changes)
- Providing rollback capability when problematic code is released
- Providing repositories for capturing release information and promoting standardized procedures

### Continuous Delivery

**Continuous delivery (CD)** is the practice of releasing code soon after it is completed and after it passes all tests. CD is typically automated with no human in the loop, enabling rapid deployment.

When a human such as a QA engineer is involved, code may be ready for deployment but not deployed until reviewed.

#### Tests

A **test** is a combination of input data and expected output. Tests promote reliability by reducing the risk that deployed code has errors that can disrupt service. Types of tests used during deployments:

- Unit tests
- Integration tests
- Acceptance tests
- Load testing

##### Unit Tests

A **unit test** checks the smallest unit of testable code — a function, API endpoint, or other entry point. Unit tests are designed to find bugs within the smallest unit.

##### Integration Tests

**Integration tests** test a combination of units to ensure they operate correctly together. For example, testing that a RESTful API endpoint properly passes data to a calculator function, receives the result, and returns it to the caller.

Integration tests can occur at multiple levels of complexity — from testing a single endpoint calling one function, to testing an API that calls another API that runs business logic against a database.

##### Acceptance Tests

**Acceptance tests** are designed to assure business owners that the code meets **business requirements**. A system can pass rigorous unit and integration tests and still fail to meet business requirements (e.g., a required feature was accidentally disabled or not implemented).

##### Load Testing

**Load testing** measures how a system performs under a particular set of conditions, including heavier-than-expected loads. It is useful for:
- Testing autoscaling within a cluster
- Testing rate limiting and other defensive measures
- Finding bugs that only surface under heavy loads (e.g., database connection timeouts under high query load)

Load testing is especially important when a system may be subject to spiking workloads.

#### Deployment Strategies

When applications run on a collection of servers behind a load balancer, engineers have several options for updating software:

| Strategy | Description | Key Advantage |
|---|---|---|
| Complete deployment | Updates all instances at once | Simple; required for monoliths |
| Rolling deployment | Incrementally updates servers over time | Reduces user exposure to risk |
| Canary deployment | Deploys new code but routes no traffic initially; gradually routes small traffic | Fine-grained control over user exposure |
| Blue/Green deployment | Two production environments; shift workload between them | Fast rollback capability |

##### Complete Deployment

A **complete deployment** updates all instances of the modified code at once. Common in waterfall methodologies and for single-server monolithic applications. Other strategies are generally preferred because complete deployment risks disrupting all users at once and may cause service disruptions.

##### Rolling Deployment

A **rolling deployment** incrementally updates all servers over a period of time. For example, in a 10-server cluster, only one server is updated first; after a period with no problems detected, a second server is updated, and so on.

Advantages:
- Exposes only a subset of users to risk (e.g., 10% initially in a 10-server cluster)
- Generally achievable without service disruptions

##### Canary Deployment

In a **canary deployment**, engineers deploy new code but route no traffic to it initially. Once deployed, a small amount of traffic is routed to the new version. As time passes without problems, more traffic is routed to the new deployment.

Traffic routing can be random, or based on criteria such as preferring to route free-tier users to new deployments before exposing paying customers.

##### Blue/Green Deployment

A **Blue/Green deployment** uses two production environments (Blue and Green) configured similarly but running different code. At any time, one is the active production environment (e.g., Green) processing live workload; the other (Blue) is used to deploy and test updated software.

When testing is complete, workload is shifted from Green to Blue. If problems are found, the workload can be rapidly shifted back.

**State management considerations for Blue/Green:**

When applications require state management (e.g., a relational database):
1. Use a **single shared database** for both deployments when only the stateless application layer changes
2. For database schema changes: use a script to update the schema to support **both** current and new application versions, test and verify, then switch the application layer. Once verified, run another database refactoring script to remove structures no longer needed.

### Continuous Integration

**Continuous integration (CI)** is the practice of incorporating new code into an established code base as soon as it is complete.

Before CI, developers would bundle multiple changes and release them as a batch to justify the manual effort of building, testing, and deploying. Manual build and test processes are also more likely to introduce inconsistencies.

With automated tools, software engineers can continuously integrate changes into the production code base.

**Tools for CI:**

| Tool | Type | Description |
|---|---|---|
| GitHub | Version control | Widely used code repository |
| Cloud Source Repository | Version control | Google Cloud's version control system |
| Jenkins | CI tool | Builds and tests code; supports plugins for version control integration and different programming languages |
| Google Cloud Build | CI service | GCP-native software building service integrated with Cloud Source Repository and other GCP services |

CI and CD together contribute to system reliability by enabling small, incremental production changes and providing mechanisms to quickly roll back problematic changes.

---

## Systems Reliability Engineering

This section focuses on building systems resilient to excessive loads and cascading failures.

### Overload

Service designers cannot control when users place excessive load on a system. Overload can happen due to:

- An **external event** — a marketing campaign prompting many new customers to start using a service
- An **external event** — an organizational change in a customer's company triggering an increase in their workload
- An **internal event** — a bad deployment causing an upstream service to generate more connection requests than ever before
- An **internal event** — another development team releasing a new service that puts unexpected load on your service

When overload occurs, consider **criticality** of operations (e.g., writing to an audit log may be more important than responding to a user query quickly) when applying the following strategies.

#### Shedding Load

**Load shedding** is the practice of dropping data that exceeds the system's capacity.

Approaches:
1. **Naive approach** — start dropping data when a monitoring condition is met (e.g., CPU utilization exceeds a threshold). Simple but crude — does not consider criticality or SLA variations.
2. **Criticality-based shedding** — categorize operations by criticality; drop lower-criticality requests first, then increasingly higher-criticality operations if overload continues.
3. **SLA-based shedding** — drop load from free users before paying customers; enforce per-customer request-rate limits (e.g., drop requests once a customer exceeds 10,000 requests per minute).
4. **Statistical sampling** — sample an IoT data stream to estimate descriptive statistics (mean, standard deviation) rather than processing every data point.

#### Degrading Quality of Service

When feasible, a service may provide **partial or approximate results** rather than failing:

- A distributed query may return results from some servers instead of waiting for slow ones (common in web search)
- A data warehouse query could sample 10% of sales data to produce an approximate ranked list of sales regions

Advantages:
- The service returns results rather than errors
- Requires planning to accommodate degraded/partial results
- Does NOT work for all cases (e.g., there is no "approximately completing" a transaction)

#### Upstream Throttling

Rather than the overloaded service shedding load, a **calling service** can slow down its request rate. This is **upstream throttling**.

A client detecting errors or timeouts from a downstream service can:
- **Cache requests** and wait until the downstream service recovers
- **Shed requests** if the data is time-sensitive and no longer valuable after a delay

When late-arriving data is still valuable, data can be cached in the calling service or in an intermediate mechanism. **Message queues** like Cloud Pub/Sub are commonly used to decouple the rate of requests between services.

**Circuit Breaker Pattern:**

The **Circuit Breaker pattern** is a design pattern that implements upstream throttling:
1. An object monitors the results of a function or service call
2. When errors exceed a threshold, the service stops making additional requests — **tripping** the circuit breaker
3. The downstream service can clear its backlog without additional incoming requests
4. The circuit breaker waits a random period, then tries a request
5. If the request succeeds, the calling service slowly increases the request rate while monitoring errors
6. If errors remain low, the calling service returns to normal operating rates

### Cascading Failures

**Cascading failures** occur when a failure in one part of a distributed system causes a failure in another part, which causes another failure, and so on.

**Example — server cluster failure:**  
A server in a cluster fails → additional load is routed to remaining servers → one of those servers fails due to overload → further load shifts to the remaining healthy servers → more failures.

**Example — database storage failure:**  
A database attempts to write data but storage is full → `INSERT` operation returns an error → application code retries every 10 seconds for up to six attempts (60 seconds) → multiple failing calls hold up service → processing backlog grows → other services begin to fail.

Cascading failures are often caused by **resource exhaustion** (memory, CPU, or database connections).

**Strategies to address cascading failures:**

1. Use the **Circuit Breaker pattern** to reduce load on failing services and allow them to catch up
2. **Degrade quality of service** to conserve resources (reduce CPU allocated per service call)
3. **Load test** services and **autoscale** resources — set autoscaling parameters to add resources *before* failures begin

**Autoscaling considerations:**
- Be aware of initialization time before a new instance is fully available (if startup time > 2 seconds, expect no improvement until 5–15 seconds after instance start)
- Plan for the time between detecting the need to scale and the resource becoming available
- Set thresholds to avoid **thrashing** (rapidly adding and releasing resources in quick succession) — it is better to have spare capacity than to run resources at the edge of capacity

### Testing for Reliability

Testing is an important part of ensuring reliability. These tests may be applied outside of the CI/CD process:

- Unit tests
- Integration tests
- System tests
- Reliability stress tests

#### Unit Tests

**Unit tests** are the simplest type of test. Performed by software developers to ensure the smallest unit of testable code functions as expected. Typically automated and performed before code is released from the development environment.

#### Integration Tests

**Integration tests** determine whether functional units operate as expected when used together (e.g., testing that an API function with an SQL query executes properly against a staging database).

#### System Tests

**System tests** include all integrated components and test whether an entire system functions as expected. Three types:

1. **Sanity checks** — simple tests to verify all components function under the simplest conditions
2. **Performance tests** — place expected workloads on the system to uncover problems before production release
3. **Regression tests** — ensure that previously corrected bugs are not reintroduced. Developers should create tests for specific known bugs and execute them during testing.

#### Reliability Stress Tests

**Reliability stress tests** place increasingly heavy load on a system until it breaks. The goals are:
- Understand *when* a system will fail
- Understand *how* it will fail (e.g., does the database fail before the application layer?)
- Understand which failures cascade and how

Stress tests inform:
- Monitoring strategy (monitor components that can trigger cascading failures)
- Where to invest development time to improve reliability

**Chaos Engineering:**  
Another form of stress testing uses **chaos engineering** tools such as **Simian Army** — a set of tools developed by Netflix to introduce failures randomly into functioning systems to study the impact. See: `medium.com/netflix-techblog/the-netflix-simian-army-16e57fbab116`

### Incident Management and Post-Mortem Analysis

**Incidents** are events with significant adverse impact on a service's ability to function. Incidents are service-level disruptions affecting multiple internal teams or external customers (not minor problems affecting only a small group).

**Incident management** is a set of practices used to identify the cause of a disruption, determine a response, implement corrective action, and record details in real time.

Best practices when an incident occurs:
- **Identify an incident commander** to coordinate the response
- **Have a well-defined operations team** to analyze problems and make system corrections
- **Maintain a log of actions taken**, which is helpful during post-mortem analysis

The goal of incident management is to correct problems and restore services as quickly as possible. There should be less focus on why the problem occurred or who is responsible than on solving the immediate problem.

**Post-Mortem Analysis:**

After an incident is resolved, conduct a **post-mortem analysis**. During the post-mortem meeting, engineers share information about the chain of events that led to the incident — which may be as simple as a bad deployment or as complex as an unlikely combination of events.

Goals of a post-mortem:
- Identify the causes of the incident
- Understand why it happened
- Determine what can be done to prevent recurrence

Key principles:
- Post-mortems do **not** assign blame — fosters trust and honesty needed to ensure all relevant details are understood
- Post-mortems are opportunities to **learn from failures**
- Document conclusions and decisions for future reference

---

## Summary

Reliability is a property of systems that measures the probability that a service will be available for a period of time. Key factors:

- **Monitoring** systems using metrics, logs, and alerts provides observability into cloud systems
- **Continuous integration and continuous delivery** reduce risk by emphasizing frequent release of small changes with automation
- **Systems reliability engineering** incorporates software engineering practices with operations management, recognizing that failures will occur and the best approach is to set well-defined SLOs and SLIs, monitor systems to detect failures early, and learn from failures using post-mortem analysis
- Systems should be architected to anticipate **overloading** and **cascading failures**
- **Testing** (unit, integration, system, and stress testing) is essential for promoting highly reliable systems

---

## Exam Essentials

- **Know the role of monitoring, logging, and alerting in maintaining reliable systems.** Monitoring collects metrics (measurements of key attributes such as utilization rates) as time series. Logging records significant events in applications or infrastructure components. Alerting sends notifications when a predefined condition is met (typically a resource measurement exceeding a threshold for a specified period of time).

- **Understand continuous delivery and continuous integration.** CI/CD releases code soon after completion and after passing all tests. Continuous integration incorporates code changes into baseline code frequently using version control repositories that support collaboration.

- **Know the different kinds of tests used when deploying code.** Unit tests check the smallest unit of functional code. Integration tests check that a combination of units function correctly together. Acceptance tests verify that code meets business requirements. Load testing measures how well the system responds to increasing levels of load.

- **Understand that systems reliability engineering combines software engineering practices with operations management to reduce risk and increase reliability.** Core tenets include:
  - Automating systems operations as much as possible
  - Understanding and accepting risk and implementing practices that mitigate risk
  - Learning from incidents
  - Quantifying service-level objectives and service-level indicators
  - Measuring performance

- **Know that systems reliability engineering includes design practices such as planning for overload, cascading failures, and incident response.** Overload occurs when workload exceeds the system's processing capacity; responses include load shedding, degrading service, and upstream/client throttling. Cascading failures occur when a failure leads to actions that cause further failures. Incident response uses a structured process to identify, correct, and learn from failures.

- **Know that testing is an important part of reliability engineering.** Multiple test types should be used, including stress testing beyond the CI/CD process.

---

## Review Questions

1. As an SRE, you are assigned to support several applications. In the past, these applications have had significant reliability problems. You would like to understand the performance characteristics of the applications, so you create a set of dashboards. What kind of data would you display on those dashboards?
   - A. Metrics and time-series data measuring key performance attributes, such as CPU utilization
   - B. Detailed log data from syslog
   - C. Error messages output from each application
   - D. Results from the latest acceptance tests

   **Answer: A.** Dashboards display metrics and time-series data about key performance attributes.

2. After determining the optimal combination of CPU and memory resources for nodes in a Kubernetes cluster, you want to be notified whenever CPU utilization exceeds 85 percent for 5 minutes or when memory utilization exceeds 90 percent for 1 minute. What would you have to specify to receive such notifications?
   - A. An alerting condition
   - B. An alerting policy
   - C. A logging message specification
   - D. An acceptance test

   **Answer: B.** Alerting policies are sets of conditions, notification specifications, and selection criteria for resources to monitor.

3. A compliance review team is seeking information about how your team handles high-risk administration operations, such as granting operating system users root privileges. Where could you find data that shows your team tracks changes to user privileges?
   - A. In metric time-series data
   - B. In alerting conditions
   - C. In audit logs
   - D. In ad hoc notes kept by system administrators

   **Answer: C.** Audit logs record events such as granting root privileges to OS users.

4. Release management practices contribute to improving reliability by which one of the following?
   - A. Advocating for object-oriented programming practices
   - B. Enforcing waterfall methodologies
   - C. Improving the speed and reducing the cost of deploying code
   - D. Reducing the use of stateful services

   **Answer: C.** Release management improves reliability by enabling rapid deployment of corrected code and reducing the cost and effort of deploying changes.

5. A team of software engineers is using release management practices. They want developers to check code into the central team code repository several times during the day. The team also wants to make sure that the code that is checked in is functioning as expected before building the entire application. What kind of tests should the team run before attempting to build the application?
   - A. Unit tests
   - B. Stress tests
   - C. Acceptance tests
   - D. Compliance tests

   **Answer: A.** Unit tests check the smallest unit of testable code and are run before the full application build.

6. Developers have just deployed a code change to production. They are not routing any traffic to the new deployment yet, but they are about to send a small amount of traffic to servers running the new version of code. What kind of deployment are they using?
   - A. Blue/Green deployment
   - B. Before/After deployment
   - C. Canary deployment
   - D. Stress deployment

   **Answer: C.** Canary deployments release new code with no initial traffic, then gradually route a small amount of traffic to the new version.

7. You have been hired to consult with an enterprise software development team that is starting to adopt Agile and DevOps practices. The developers would like advice on tools they can use to help them collaborate on software development in the Google Cloud. What version control software might you recommend?
   - A. Jenkins and Cloud Source Repositories
   - B. Syslog and Cloud Build
   - C. GitHub and Cloud Build
   - D. GitHub and Cloud Source Repositories

   **Answer: D.** GitHub and Cloud Source Repositories are version control tools for collaborative software development.

8. A startup offers a software-as-a-service solution for enterprise customers. Many of the components of the service are stateful, and the system has not been designed to allow incremental rollout of new code. The entire environment has to be running the same version of the deployed code. What deployment strategy should they use?
   - A. Rolling deployment
   - B. Canary deployment
   - C. Stress deployment
   - D. Blue/Green deployment

   **Answer: D.** Blue/Green deployment runs two environments with the same version of code and switches between them, enabling the entire environment to shift from one code version to another at once.

9. A service is experiencing unexpectedly high volumes of traffic. Some components of the system are able to keep up with the workload, but others are unable to process the volume of requests. These services are returning a large number of internal server errors. Developers need to release a patch as soon as possible that provides some relief for an overloaded relational database service. Both memory and CPU utilization are near 100 percent. Horizontally scaling the relational database is not an option, and vertically scaling the database would require too much downtime. What strategy would be the fastest to implement?
   - A. Shed load
   - B. Increase connection pool size in the database
   - C. Partition the workload
   - D. Store data in a Pub/Sub topic

   **Answer: A.** Load shedding is the fastest strategy to implement to provide immediate relief by dropping excess requests.

10. A service has detected that a downstream process is returning a large number of errors. The service automatically slows down the number of messages it sends to the downstream process. This is an example of what kind of strategy?
    - A. Load shedding
    - B. Upstream throttling
    - C. Rebalancing
    - D. Partitioning

    **Answer: B.** Upstream throttling is when a calling service slows down the rate at which it sends requests to a downstream service that is returning errors.
