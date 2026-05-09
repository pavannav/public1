# Session 44: Cloud Run Services & Functions Concurrency, EventArc for VM Management, and VMware Engine

## Table of Contents
- [Cloud Run Services Concurrency](#cloud-run-services-concurrency)
- [Cloud Run Functions Concurrency](#cloud-run-functions-concurrency)
- [Cloud Run Functions HTTP Trigger Timeout](#cloud-run-functions-http-trigger-timeout)
- [Cloud Run Functions GCS Trigger Deployment](#cloud-run-functions-gcs-trigger-deployment)
- [Cloud Run Functions Gen 2 Timeout Adjustment](#cloud-run-functions-gen-2-timeout-adjustment)
- [Concurrency in Cloud Run Functions](#concurrency-in-cloud-run-functions)
- [Cloud Run Services Concurrency Demonstration](#cloud-run-services-concurrency-demonstration)
- [VM Management with Cloud Run Functions and EventArc](#vm-management-with-cloud-run-functions-and-eventarc)
- [VMware Engine Overview](#vmware-engine-overview)

## Cloud Run Services Concurrency
### Overview
Cloud Run Services allow running containerized applications with automatic scaling and no infrastructure management. Concurrency refers to the number of requests a single instance can handle simultaneously, maximizing resource efficiency.

### Key Concepts / Deep Dive
Cloud Run supports up to 80 concurrent requests per instance by default, configurable up to 1,000. This is controlled via the `Maximum number of requests per instance (concurrency)` setting during deployment.

- **Default Behavior**: If concurrency is set to 80, multiple requests share the same container instance.
- **Single Request Per Instance**: Setting concurrency to 1 ensures each request gets its own instance, useful for single-threaded or stateful applications to avoid race conditions (e.g., duplicate database inserts).

### Code/Config Blocks
Configure concurrency in Cloud Run UI or via CLI:

```bash
gcloud run deploy --concurrency 80
```

### Lab Demos
Demonstrated auto-scaling with concurrency set to 1,000: One instance handled 200 concurrent requests without additional scaling.

Used Siege tool for load testing:

```bash
siege -c 200 -t 60S https://url/
```

### Tables
| Concurrency Setting | Scaling Behavior | Use Case |
|---------------------|------------------|----------|
| 1 | Each request triggers new instance | Single-threaded apps |
| 80 (default) | Requests share instance | General web apps |
| 1,000 (max) | High-throughput per instance | Multi-threaded apps |

## Cloud Run Functions Concurrency
### Overview
Cloud Run Functions (Gen 2) run on Cloud Run, supporting concurrency. Gen 1 is limited to 1 concurrent request per function instance.

### Key Concepts / Deep Dive
- **Gen 1**: Fixed at 1 concurrency.
- **Gen 2**: Configurable up to 1,000, same as Cloud Run Services.

Configured in UI under `Concurrency` for Gen 2 functions.

### Code/Config Blocks
Deploy Gen 2 with concurrency:

```bash
gcloud functions deploy --gen2 --concurrency 1
```

### Lab Demos
Cannot set Gen 2 concurrency without sufficient CPU/memory (e.g., at least 1 CPU).

## Cloud Run Functions HTTP Trigger Timeout
### Overview
Cloud Run Functions have a 60-minute timeout for HTTP triggers, longer than the older limits.

## Cloud Run Functions GCS Trigger Deployment
### Key Concepts / Deep Dive
Deploy Gen 2 Cloud Run Functions for GCS bucket triggers via CLI:

- Use entry point like `hello_gcs` for the handler.
- Timeout defaults to 60 seconds but extendable to 60 minutes via Cloud Run UI edit.

```bash
gcloud functions deploy my-function \
  --gen2 \
  --trigger-bucket gs://my-bucket \
  --allow-unauthenticated \
  --entry-point hello_gcs \
  --runtime python312 \
  --source . \
  --timeout 3600
```

Corrected potential errors: Deployment requires entry point definition.

## Cloud Run Functions Gen 2 Timeout Adjustment
### Overview
Gen 2 allows editing timeout in UI (or CLI via re-deploy), unlike Gen 1 which is fixed.

### Lab Demos
Workaround: Deploy with 540 seconds (9 minutes), then edit to 3,600 seconds (1 hour). CLI re-deploy works similarly.

## Concurrency in Cloud Run Functions
### Overview
Builds on Cloud Run concurrency concepts.

## Cloud Run Services Concurrency Demonstration
### Lab Demos
- Deployed hello-world with concurrency 1,000: Handled high load with single instance.
- With concurrency 1: Scaled to 38 instances for same load.

Metrics in Cloud Run UI confirmed instance count based on concurrency settings.

## VM Management with Cloud Run Functions and EventArc
### Overview
Use Cloud Run Functions (Gen 2) with EventArc to trigger VM actions, like starting stopped VMs without HTTP polling.

### Key Concepts / Deep Dive
- Event source: Compute Engine VM stop/start events.
- Handler writes code to detect events and perform actions.
- Avoid sleep-based polling; use events for efficiency.

### Code/Config Blocks
Sample code (Python):

```python
def hello_events(event, context):
    if event['type'] == 'google.cloud.audit.log.v1.written':
        if 'VM stopped' in event['data']:
            # Start VM logic
            compute.start()
```

### Lab Demos
- Created function for compute.engine.vm.stop event.
- Enabled retries to ensure reliability.

Successful test: VM stopped, function triggered, VM restarted automatically.

## VMware Engine Overview
### Overview
Migrates on-premise VMware workloads to Google Cloud without code changes, using dedicated hardware stack in Google's data centers.

### Key Concepts / Deep Dive
- **Use Cases**:
  - Disaster recovery: Sync environments, failover instantly.
  - Bursting: Expand capacity for events (e.g., holidays).
  - Dev/Test: Mirror on-premise for testing.
  - Virtual desktops: Secure access.

- Deployment: Requires private cloud creation in UI/CLI/API. Not demonstrated due to on-premise dependency.

## Summary

### Key Takeaways
```diff
+ Cloud Run Services and Gen 2 Functions support high concurrency (up to 1,000 per instance) for efficient scaling.
+ EventArc enables event-driven VM management, reducing complexity vs. HTTP polling.
+ VMware Engine allows lift-and-shift migrations of VMware environments to Cloud.
- Gen 1 Functions are limited to 1 concurrency; prefer Gen 2.
! Timeout adjustments require deployment workarounds for Gen 2.
```

### Quick Reference
- Deploy Cloud Run with concurrency:
  ```bash
  gcloud run deploy --concurrency 1000
  ```
- Trigger function on VM stop:
  ```python
  gcloud functions deploy --gen2 --trigger-event google.cloud.audit.log.v1.written --trigger-filters type=compute.instances.stop
  ```
- VMware Engine API: Enable via GCP Console, not demoed.

### Expert Insight

#### Real-World Application
In production, use Cloud Run concurrency for cost-efficient microservices; pair with EventArc for infra automation like auto-starting failed VMs or scaling based on events. VMware Engine suits enterprises with VMware investments needing Cloud migration without re-architecture.

#### Expert Path
Master Cloud Run by experimenting with custom containers and EventArc triggers; deep-dive into VMware Engine for lift-and-shift scenarios. Practice CLI deployments and monitor costs via labels for optimization.

#### Common Pitfalls
- Over-setting low concurrency causing unnecessary scaling costs.
- Forgetting entry points in function deployments leads to failures.
- EventArc retries can cause loops if not handled properly; set timeouts.
- Avoiding UI bugs by using CLI for exact timeouts.

#### Lesser-Known Facts
- Cloud Run Gen 2 functions consume Cloud Run quotas (e.g., function count per region).
- VMware Engine supports unified NSX/V-Center UI for seamless operation.
- Concurrency above 80 requires at least 1 CPU per instance in Cloud Run Functions.
