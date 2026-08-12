# Chapter 9: Computing with Cloud Run and App Engine

## Exam Objective Covered

- **3.3 Deploying and implementing Cloud Run and Cloud Functions resources**

---

## Introduction

This chapter covers deploying containerized services using **Cloud Run** and **App Engine**.

- **Cloud Run** — serverless, managed service; supports any containerized application in any language; integrates with Cloud Build, Artifact Registry, and Docker.
- **App Engine** — PaaS offering; language-specific frameworks; minimal infrastructure management. *(Note: App Engine is no longer in the ACE Exam Guide but is included here as cloud engineers should support existing App Engine deployments.)*

---

## Overview of Cloud Run

Cloud Run is a serverless, managed service for running containerized applications. Unlike App Engine Standard or Cloud Functions, Cloud Run is **not restricted to specific programming languages** — any application that runs in a container is supported.

Cloud Run supports two modes:

| Mode | Use Case |
|---|---|
| **Cloud Run Services** | Responds to web requests or events (long-lived: APIs, web apps, microservices) |
| **Cloud Run Jobs** | Runs code until a workload completes, then stops (batch: file processing, data loads) |

---

### Cloud Run Services

Cloud Run services are suited for **web applications, microservices, APIs, and stream data processing**.

**Key characteristics:**

- Listens on an HTTPS endpoint on a unique subdomain of `run.app` (custom domains also supported)
- Scales up to **1,000 container instances** (default quota; can be increased)
- Can specify a **maximum number of instances** to limit cost
- Manages **TLS** automatically
- Supports **WebSockets**, **HTTP/2 (end-to-end)**, and **gRPC**
- Deploys **immutable revisions** — updates require a new container image deployed as a new revision
- Supports **traffic splitting between revisions** for canary deployments and rollbacks

**Access control options:**

| Method | Description |
|---|---|
| **Cloud IAM policy** | Assign roles to users/groups (e.g., `run.developer` for deploying new versions; allow unauthenticated for public) |
| **Ingress settings** | Control network-level traffic |
| **Cloud Identity Aware Proxy (IAP)** | Only authenticated users can access; traffic must come through IAP proxies |

**Ingress setting options:**

| Ingress Setting | Traffic Allowed |
|---|---|
| **Internal** | Most restrictive — internal HTTP(S) LBs, VPC Service Controls perimeter, same-project VPC networks, Eventarc/Pub/Sub/Workflow in same project |
| **Internal and Cloud Load Balancing** | Internal + External HTTP(S) load balancers |
| **All** | Least restrictive — all requests to the service endpoint |

---

### Cloud Run Jobs

Cloud Run jobs run **programs or scripts until a task is complete**, then stop.

**Key characteristics:**

- No persistent listening endpoint (unlike services)
- Can be **scheduled** on a regular cadence
- Support **array jobs** — parallelizable tasks where multiple containers run simultaneously

**Example use case:** Validate and import hundreds of files from Cloud Storage into Cloud SQL. Using array jobs, multiple files are processed simultaneously instead of sequentially.

---

## Creating a Cloud Run Service

From Cloud Console → **Cloud Run** → **Create Service**.

![The form for creating a Cloud Run service](../images/c09f001.png)

**Figure 9.1** The form for creating a Cloud Run service

**Key configuration options:**

- **Container image URL** — type a URL or select from Container Registry / Artifact Registry
- **Deployment option** — single revision or continuous deployment from source repo
- **Service name** and **Region**
- **CPU billing** — pay only when processing requests, or always allocated
- **Min/max instances**

**Ingress configuration:**

![When creating a Cloud Run service, we can choose one of three ingress options](../images/c09f002.png)

**Figure 9.2** When creating a Cloud Run service, we can choose one of three ingress options.

Authentication can be changed from the default (require auth) to allow unauthenticated access (for public websites or APIs).

### Container Tab

![Configuring container parameters in a Cloud Run service](../images/c09f003.png)

**Figure 9.3** Configuring container parameters in a Cloud Run service

| Parameter | Details |
|---|---|
| Port | Port the container listens on |
| Container command & arguments | Override default container startup |
| Memory | Max 16 GB (GA), 32 GB (preview) |
| CPUs | Max 4 (GA), 8 (preview) |
| Request timeout | Default 5 min; range 1–60 min |
| Execution environment | 1st gen or 2nd gen (2nd gen: filesystem access, faster performance) |
| Environment variables | Passed to container |
| Secrets | Reference secrets stored in Secret Manager |

> **Note:** Preview services are not covered by Google Cloud SLAs; GA services are.

### Connections Tab

![Configuring connection parameters in a Cloud Run service](../images/c09f004.png)

**Figure 9.4** Configuring connection parameters in a Cloud Run service

| Option | Description |
|---|---|
| HTTP/2 end-to-end | Supports gRPC streaming services |
| Session affinity | Routes requests from a client to the same container when possible |
| Cloud SQL connection | For services using a Cloud SQL database |
| VPC Connector (Serverless VPC Access) | Connect to Compute Engine instances, Cloud Memorystore, and other VPC resources |

### Security Tab

![Configuring security parameters in a Cloud Run service](../images/c09f005.png)

**Figure 9.5** Configuring security parameters in a Cloud Run service

| Option | Description |
|---|---|
| Service account | Identity used by the Cloud Run service |
| Binary Authorization | Verifies containers meet policy requirements before deployment (also applies to GKE) |
| Encryption keys | Google-managed or customer-managed (CMEK) |

---

## Creating a Cloud Run Job

From Cloud Console → **Cloud Run** → **Jobs** tab → **Create A Job**.

![Creating a Cloud Run job](../images/c09f006.png)

**Figure 9.6** Creating a Cloud Run job

Configuration is similar to a service: container image URL, region, job name. Additional job-specific options:

### General Tab

![Configuring container parameters for a Cloud Run job](../images/c09f007.png)

**Figure 9.7** Configuring container parameters for a Cloud Run job

| Parameter | Details |
|---|---|
| Container command & arguments | Similar to service |
| Memory / CPU | Similar to service |
| Number of times to run | Default: 1 |
| Retries | Number of retries for failed tasks |
| Parallelism | Number of concurrent tasks (for array jobs) |
| Execute immediately | Option to run job right after creation |

### Variables & Secrets Tab

![Configuring variables and secrets for a Cloud Run job](../images/c09f008.png)

**Figure 9.8** Configuring variables and secrets for a Cloud Run job

Specify environment variables and references to stored secrets.

### Connections Tab

![Configuring connection parameters for a Cloud Run job](../images/c09f009.png)

**Figure 9.9** Configuring connection parameters for a Cloud Run job

Cloud SQL connections and VPC connector configuration (same as service).

### Security Tab

![Configuring security parameters for a Cloud Run job](../images/c09f010.png)

**Figure 9.10** Configuring security parameters for a Cloud Run job

Service account and encryption key management (same as service).

---

## App Engine Components

App Engine is available in **Standard** and **Flexible** versions. App Engine Standard applications consist of four components:

| Component | Description |
|---|---|
| **Application** | Top-level resource; one per project; tied to the region specified at creation |
| **Service** | Code executing in the App Engine environment; performs a single function (microservice) |
| **Version** | A specific combination of source code + configuration file; multiple versions can run simultaneously |
| **Instance** | A running execution of a version |

**Key concepts:**

- **Microservices** — Complex applications built from multiple single-function services (e.g., one for API data access, one for authentication, one for billing)
- **Versioning** — Multiple versions can run at the same time; enables traffic splitting, rollback, and gradual rollouts
- A version is defined by its **source code + `app.yaml` configuration file**

---

## Deploying an App Engine Application

### Deploying an App Using Cloud Shell and SDK

**Step 1:** Install/update the App Engine Python component:

```bash
gcloud components install app-engine-python
```

**Step 2:** Download the Hello World example:

```bash
git clone https://github.com/GoogleCloudPlatform/python-docs-samples
```

**Step 3:** Change to the Hello World directory:

```bash
cd python-docs-samples/appengine/standard_python3/hello_world
```

Directory contents:

| File | Purpose |
|---|---|
| `app.yaml` | App Engine configuration file |
| `main.py` | Application source code |
| `main_test.py` | Unit tests |
| `requirements.txt` | Runtime dependencies |
| `requirements-test.txt` | Test dependencies |

![The contents of an app.yaml file for a Python 3 application](../images/c09f011.png)

**Figure 9.11** The contents of an `app.yaml` file for a Python 3 application

The `app.yaml` file specifies the Python version (runtime). It may also contain API version, `threadsafe` parameter, and environment variables.

**Step 4:** Deploy the app:

```bash
gcloud app deploy app.yaml
```

> `app.yaml` is the default filename, so specifying it is optional.

**Optional `gcloud app deploy` parameters:**

| Parameter | Description |
|---|---|
| `--version` | Specify a custom version ID |
| `--project` | Specify the project ID |
| `--no-promote` | Deploy without routing traffic to the new version |

Access the deployed app at: `https://<project-name>.appspot.com`

> **Note:** You can assign a custom domain via **App Engine Settings → Add New Custom Domain**.

**Stop serving specific versions:**

```bash
gcloud app versions stop v1 v2
```

---

## Scaling App Engine Applications

App Engine can automatically add/remove instances based on load.

| Instance Type | Description | Configured By |
|---|---|---|
| **Dynamic** | Created and destroyed based on demand; optimizes cost | Autoscaling or basic scaling |
| **Resident** | Always running; optimized for performance (lower latency) | Manual scaling |

### Autoscaling Configuration in `app.yaml`

```yaml
automatic_scaling:
  target_cpu_utilization: 0.65
  target_throughput_utilization: 0.75
  max_concurrent_requests: 50
  max_instances: 20
  min_instances: 2
  max_pending_latency: 30ms
  min_pending_latency: 0ms
```

| Parameter | Description |
|---|---|
| `target_cpu_utilization` | Max CPU utilization before adding instances |
| `target_throughput_utilization` | Max concurrent requests ratio before adding instances (0.5–0.95) |
| `max_concurrent_requests` | Max concurrent requests per instance before starting a new one (default: 10, max: 80) |
| `max_instances` / `min_instances` | Range of instances allowed |
| `max_pending_latency` / `min_pending_latency` | Max/min time a request waits in the queue |

### Basic Scaling

Only two parameters: `idle_timeout` and `max_instances`. Simpler than autoscaling.

---

> ### Real World Scenario: Microservices vs. Monolithic Applications
>
> Many legacy applications were **monolithic** — all functionality compiled into a single program. Problems with monolithic apps:
> - Any change requires redeploying the entire application (slow)
> - Rolling back a bug also rolls back all other changes in that release
> - Difficult for multiple developers to coordinate changes in a small number of files
>
> **Microservices** divide code into single-function apps:
> - Change and deploy one service without impacting others
> - Source control tools (Git) enable parallel development
> - Enables frequent updates and gradual rollouts (canary releases)

---

## Splitting Traffic Between App Engine Versions

When multiple versions are running, traffic can be split between them.

| Splitting Method | How It Works | Best For |
|---|---|---|
| **IP address** | Hashes the client IP to a number 0–999; routes to a version | Sticky routing (but breaks if IP changes) |
| **HTTP cookie** | Uses `GOOGAPPUID` cookie with hash value 0–999 | **Preferred** — user stays on same version even if IP changes |
| **Random** | Routes requests randomly | Even workload distribution |

> If no `GOOGAPPUID` cookie is present, traffic is routed **randomly**.

**Command to split traffic:**

```bash
gcloud app services set-traffic serv1 --splits v1=.4,v2=.6
```

This routes 40% of traffic to `v1` and 60% to `v2` of the service named `serv1`. If no service name is specified, the split applies to **all services**.

**Key parameters:**

| Parameter | Description |
|---|---|
| `--migrate` | Migrate all traffic from previous version to new version |
| `--split-by` | Specify split method: `ip`, `cookie`, or `random` |

Traffic can also be migrated via Cloud Console → **App Engine → Versions** → **Migrate**.

---

## Summary

| Feature | Cloud Run Services | Cloud Run Jobs | App Engine Standard |
|---|---|---|---|
| **Type** | Long-lived web service | Batch/task execution | PaaS web app platform |
| **Trigger** | HTTP requests / events | On demand / scheduled | HTTP requests |
| **Language** | Any (containerized) | Any (containerized) | Specific runtimes |
| **Scaling** | Automatic (0–1000 instances) | Parallelism parameter | Auto/basic/manual |
| **Config** | Console / gcloud / API | Console / gcloud / API | `app.yaml` |
| **Versioning** | Revisions (traffic splitting) | N/A | Versions (traffic splitting) |

---

## Exam Essentials

- **Cloud Run is a serverless service for running containers.** No servers to manage; configure instance count, security, and connections. Supports any language via containers.

- **Cloud Run services run long-lived workloads** (websites, APIs). Pay per request or always-on CPU billing. Supports traffic splitting between revisions.

- **Cloud Run jobs run tasks to completion.** Configured similarly to services. Supports parallelism via array jobs for concurrent workloads.

- **App Engine Standard structure: Application → Service → Version → Instance.** One application per project. Services perform single functions (microservices). Versions enable rollback and traffic splitting.

- **Deploy App Engine apps with `gcloud app deploy`.** Configure the environment via `app.yaml`. One App Engine app per project. The `--no-promote` flag deploys without routing traffic.

- **App Engine scaling options:**
  - **Autoscaling** — dynamic instances, full configuration options
  - **Basic scaling** — dynamic instances, `idle_timeout` and `max_instances` only
  - **Manual scaling** — resident instances (always running)

---

## Review Questions

1. You want to provide your customers with an API to query a proprietary database. You want your developers to focus on features, not on administering servers. Which Google Cloud service would you choose?
   - A. Compute Engine managed instance groups
   - B. Compute Engine unmanaged instance groups
   - **C. Cloud Run services**
   - D. Cloud Run jobs

2. A biomedical research group has hundreds of data files in Cloud Storage and wants to run a statistical analysis program against each file, writing output to another bucket. They want to deploy the program in a container. What would you recommend?
   - A. Kubernetes Engine
   - B. Compute Engine
   - C. App Engine Flexible
   - **D. Cloud Run jobs**

3. A climate research group has tens of thousands of weather data files in Cloud Storage. Each file can be analyzed independently. They plan to use Cloud Run jobs. What feature would you recommend?
   - A. Customer-managed encryption keys
   - **B. Array jobs**
   - C. Cloud SQL Connection
   - D. A private IP address

4. An application administrator wants all client requests routed to the same container if possible. How would you accomplish this?
   - A. Use Cloud SQL Connection.
   - B. Use array jobs.
   - **C. Configure the connection in the Cloud Run Service to support session affinity.**
   - D. Use a private IP address.

5. You are deploying a service on Cloud Run that handles PII. For compliance reasons, you must restrict it to internal traffic only. What ingress configuration would you use?
   - **A. Internal**
   - B. Internal and Cloud Load Balancing
   - C. All
   - D. PII proxy traffic

6. You want to use a service account specifically created for a Cloud Run service. Where would you specify that in the Cloud Console?
   - A. On the Connections tab
   - **B. On the Security tab**
   - C. On the Container tab
   - D. On the Variables & Secrets tab

7. A group of developers needs the ability to deploy new versions of a service running in Cloud Run. How would you configure that access?
   - **A. Using IAM**
   - B. Using Cloud Identity Aware Proxy (IAP)
   - C. Using an ingress policy
   - D. Using the Security tab in the Cloud Run console

8. Your Cloud Run service needs to access a Cloud Memorystore cache running in a VPC. What would you use to enable this?
   - A. Cloud SQL Connection
   - B. Cloud IAP Proxy
   - **C. VPC Connection**
   - D. Session affinity

9. A service deployed to Cloud Run will communicate with clients using gRPC. What should you configure to enable this?
   - A. External Load Balancing
   - B. Cloud Identity Aware Proxy (IAP)
   - C. Session affinity
   - **D. HTTP/2 end-to-end**

10. What Google Cloud services can be used to store and access container images accessible from Cloud Run?
    - A. Container Registry only
    - **B. Container Registry and Artifact Registry**
    - C. Artifact Registry only
    - D. Container Registry, Artifact Registry, and Kubernetes Engine

11. You want to deploy updates to an App Engine microservice with minimal disruption. What App Engine component would you use?
    - A. Services
    - **B. Versions**
    - C. Instance groups
    - D. Instances

12. You have an App Engine Standard app with peak demand requiring up to 12 instances, but normally 5 is sufficient. What is the best way to ensure enough instances without overspending?
    - **A. Configure your app for autoscaling and specify max instances of 12 and min instances of 5.**
    - B. Configure your app for basic scaling and specify max instances of 12 and min instances of 5.
    - C. Create a cron job to add instances just prior to peak periods.
    - D. Configure your app for instance detection and do not specify a max or minimum.

13. What command should you use to deploy an App Engine app from the command line?
    - A. `gcloud components app deploy`
    - **B. `gcloud app deploy`**
    - C. `gcloud components instances deploy`
    - D. `gcloud app instance deploy`

14. App Engine is trying to run your Python 3 application using Python 2. What file would you check and possibly modify?
    - A. `app.config`
    - **B. `app.yaml`**
    - C. `services.yaml`
    - D. `deploy.yaml`

15. You want more instances added when there are more than 20 concurrent requests. What `app.yaml` parameter would you specify?
    - **A. `max_concurrent_requests`**
    - B. `target_throughput_utilization`
    - C. `max_instances`
    - D. `max_pending_latency`

16. What parameters can be configured with basic scaling?
    - A. `max_instances` and `min_instances`
    - B. `idle_timeout` and `min_instances`
    - **C. `idle_timeout` and `max_instances`**
    - D. `idle_timeout` and `target_throughput_utilization`

17. The `runtime` parameter in `app.yaml` is used to specify what?
    - A. The script to execute
    - B. The URL to access the application
    - **C. The language runtime environment**
    - D. The maximum time an application can run

18. You work for a startup and costs are a major concern. You are willing to accept a slight performance hit to save money. How should you configure scaling?
    - **A. Use dynamic instances by specifying autoscaling or basic scaling.**
    - B. Use resident instances by specifying autoscaling or basic scaling.
    - C. Use dynamic instances by specifying manual scaling.
    - D. Use resident instances by specifying manual scaling.

19. What parameter to `gcloud app services set-traffic` specifies the method to use when splitting traffic?
    - A. `--split-traffic`
    - **B. `--split-by`**
    - C. `--traffic-split`
    - D. `--split-method`

20. What are valid methods for splitting traffic in App Engine?
    - A. By IP address only
    - B. By HTTP cookie only
    - C. Randomly and by IP address only
    - **D. By IP address, HTTP cookies, and randomly**
