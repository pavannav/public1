# Session 44: Cloud Run Service and Functions Concurrency, Start Stopped VM using EventArc, VMware Engine

**Table of Contents**
- [Concurrency in Cloud Run Services](#concurrency-in-cloud-run-services)
- [Concurrency in Cloud Run Functions](#concurrency-in-cloud-run-functions)
- [Deploying Cloud Run Functions via CLI](#deploying-cloud-run-functions-via-cli)
- [Request Timeout Handling in Cloud Run Functions](#request-timeout-handling-in-cloud-run-functions)
- [Triggering Cloud Run Functions with EventArc](#triggering-cloud-run-functions-with-eventarc)
- [VMware Engine](#vmware-engine)
- [Comparisons Between Compute Services](#comparisons-between-compute-services)
- [Decision Tree for Choosing Compute Options](#decision-tree-for-choosing-compute-options)
- [Pricing and Quotas](#pricing-and-quotas)

## Concurrency in Cloud Run Services

### Overview
Concurrency in Cloud Run Services refers to the maximum number of concurrent requests that a single container instance can handle simultaneously. This impacts how your application scales and handles traffic, especially for containerized workloads that may or may not support multi-threading.

### Key Concepts/Deep Dive
- **Default Concurrency**: Cloud Run Services default to 80 concurrent requests per instance.
- **Maximum Concurrency**: Can be set up to 1,000 concurrent requests per instance.
- **Benefits of High Concurrency**: Allows a single instance to handle up to 1 million requests in high-scalability scenarios, assuming 1 vCPU and 1 second per request.
- **Adjusting Concurrency**: Lower the value (e.g., to 1) for single-threaded applications or databases that may face race conditions like duplicate records.
- **Scaling Behavior**: With concurrency set to 1, autoscaling creates multiple instances (up to 100) based on concurrent requests. With high concurrency, fewer instances are needed.

#### Lab Demo: Concurrency Demonstration
Demonstrating different concurrency settings:

```bash
# Set concurrency to 1,000 for high concurrency demo
gcloud run deploy high-concurrency-service \
  --source . \
  --concurrency 1000 \
  --allow-unauthenticated \
  --set-env-vars CONCURRENCY=1000
```

```bash
# Simulate high concurrent requests using Siege
siege -c 500 -t 5m https://high-concurrency-service-url
# Observe scaling: Should remain at ~1 instance
```

```bash
# Set concurrency to 1 for low concurrency demo
gcloud run deploy low-concurrency-service \
  --source . \
  --concurrency 1 \
  --allow-unauthenticated \
  --set-env-vars CONCURRENCY=1
```

```bash
# Simulate concurrent requests
siege -c 200 -t 5m https://low-concurrency-service-url
# Observe scaling: Instances should scale up to handle requests
```

### Common Issues and Resolutions
- **Issue**: Duplicate database entries due to concurrent processing.
  - **Resolution**: Set concurrency to 1 to ensure sequential processing. Avoid by designing thread-safe code.
- **Issue**: Instances not scaling as expected.
  - **Resolution**: Verify CPU and memory allocation; concurrency requires at least 1 vCPU. Avoid by monitoring metrics and adjusting resources.

## Concurrency in Cloud Run Functions

### Overview
For Cloud Run Functions, concurrency limits how many requests an instance can process simultaneously. First-generation functions support only 1 concurrent request per instance, while second-generation (built on Cloud Run) can support up to 1,000.

### Key Concepts/Deep Dive
- **First-Generation Limits**: Maximum 1 concurrent request per function instance; ideal for single-threaded or legacy code.
- **Second-Generation Limits**: Up to 1,000 concurrent requests, requiring at least 1 vCPU.
- **Impact on Scaling**: Higher concurrency reduces the number of instances needed, optimizing cost and resource usage.
- **Use Cases**: Preferred for event-driven tasks where synchronous processing is key.

## Deploying Cloud Run Functions via CLI

### Overview
Deploying Cloud Run Functions via the Google Cloud CLI provides more control than the console, especially for automation and scripting. This is essential for production deployments.

### Key Concepts/Deep Dive
- **Prerequisites**: Use `main.py` for Python or Node.js entry points; cloud functions require specific file names.
- **Gen 1 vs. Gen 2**: CLI defaults to Gen 1; specify `--gen2` for Gen 2 (Cloud Run-based).
- **Timeout Management**: Default 60 seconds for HTTP triggers; editable up to 1 hour post-deployment.
- **Commands**:
  - Deploy: `gcloud functions deploy <name> --region=<region> --gen2 --source=. --runtime=python39 --trigger-bucket=gs://bucket-name --entry-point=main --timeout=3600s`
  - Update Timeout: Redeploy with updated `--timeout` or edit via Cloud Run UI/console.

#### Lab Demo: CLI Deployment
```bash
# Prepare files
echo "def main(data, context):
    import time
    time.sleep(100)
    print('Task completed')
    return 'Success'" > main.py

echo "functions-framework==3.5.0" > requirements.txt

# Deploy via CLI
gcloud functions deploy gcs-trigger-cli \
  --region=us-central1 \
  --gen2 \
  --source=. \
  --runtime=python39 \
  --trigger-bucket=gs://your-bucket \
  --entry-point=main \
  --timeout=540s

# Update timeout post-deploy
gcloud functions deploy gcs-trigger-cli \
  --timeout=3600s
```

## Request Timeout Handling in Cloud Run Functions

### Overview
Request timeouts limit execution time for functions. HTTP-triggered functions default to 1 hour in Gen 2, while bucket-based triggers limit to 9 minutes in UI but editable post-deployment.

### Key Concepts/Deep Dive
- **Defaults**:
  - HTTP: 1 hour (3,600 seconds).
  - Event-based (e.g., GCS): UI caps at 9 minutes (540 seconds); editable to 1 hour after deployment.
- **Workaround**: Deploy with 540 seconds, then update to 3,600 via UI or CLI.
- **Differences Between Gen 1 and Gen 2**: Gen 2 supports longer timeouts due to Cloud Run backend.

#### Lab Demo: Timeout Handling
```bash
# Deploy with 9 minutes
gcloud functions deploy timeout-example \
  --runtime=python39 \
  --region=us-central1 \
  --gen2 \
  --source=. \
  --trigger-bucket=gs://test-bucket \
  --timeout=540s

# Update to 1 hour via CLI
gcloud functions deploy timeout-example --timeout=3600s
```

## Triggering Cloud Run Functions with EventArc

### Overview
EventArc enables event-driven triggers for Cloud Run Functions, such as responding to VM state changes, without relying on HTTP (which fails for long-running tasks due to timeouts and retries).

### Key Concepts/Deep Dive
- **Providers**: Compute Engine, Pub/Sub, Cloud Storage, etc.
- **Events**: VM stop/start, object uploads, topic publishes.
- **Advantages over HTTP**: Handles asynchronous events; supports retries for transient failures.
- **Configuration**: Choose "Other Trigger" in console, select provider (e.g., Compute Engine), specify events (e.g., `compute.instances.stop`), and enable retry on failure.

#### Code/Config Blocks
```python
# Sample function triggered by VM stop
def vm_stop_handler(event, context):
    import base64
    import json
    import google.auth
    from googleapiclient.discovery import build

    # Extract VM details from event
    data = json.loads(str(event['data']))
    vm_name = data['resource']['name']
    zone = data['resource']['zone']

    # Start VM logic (replace with your project/zone)
    compute = build('compute', 'v1', credentials=google.auth.default())
    compute.instances().start(project='your-project', zone=zone, instance=vm_name).execute()
    print(f"Started VM: {vm_name}")
```

#### Tables
| Provider      | Event Type                  | Typical Use Case             |
|---------------|-----------------------------|------------------------------|
| Compute Engine| `compute.instances.stop`   | Auto-start stopped VMs      |
| Cloud Storage | `google.cloud.audit.log.v1.written` (with filters) | Process uploaded files     |
| Pub/Sub       | `google.cloud.pubsub.topic.v1.publish` | Trigger on message publish  |

#### Lab Demo: VM Auto-Start on Stop
```bash
# Deploy function via CLI
gcloud functions deploy vm-auto-start \
  --region=us-central1 \
  --gen2 \
  --source=. \
  --runtime=python39 \
  --trigger-event-filters="type=google.cloud.audit.log.v1.written,methodName=compute.instances.stop" \
  --entry-point=vm_stop_handler \
  --retry-on-failure

# Stop VM to test (ensure function triggers and restarts VM)
gcloud compute instances stop your-vm-name --zone=us-central1-a
```

### Common Issues and Resolutions
- **Issue**: Function fails on initial trigger and doesn't retry.
  - **Resolution**: Enable "Retry on failure" to attempt up to 7 days. Avoid by ensuring code handles transient errors (e.g., VM not ready).
- **Issue**: Misspelled provider or event type.
  - **Resolution**: Verify event filters; use audit logs for custom events. Avoid by testing event payload structure.

## VMware Engine

### Overview
VMware Engine provides a Google-managed VMware stack on dedicated hardware, allowing lift-and-shift migration of on-premises VMware workloads to Google Cloud without code changes.

### Key Concepts/Deep Dive
- **Use Cases**:
  - Lift-and-shift migrations (e.g., end-of-life hardware replacement).
  - Hybrid clouds (unified dev/test across environments).
  - Disaster recovery or on-demand expansion (e.g., holiday traffic bursts).
  - Cost optimization for short-term scaling.
- **Connectivity**: Uses Google Interconnect or VPN for secure access.
- **Advantages**: Retain VMware tooling (e.g., vCenter UI); no Ops overhead; disaster recovery; virtual desktops without code changes.

> [!NOTE]
> Bookish knowledge only; requires on-premises setup for full demonstration.

## Comparisons Between Compute Services

### Overview
Comparing Cloud Run Services, Cloud Run Functions, App Engine, and Compute Engine highlights trade-offs in scalability, ease of use, and customization.

### Key Concepts/Deep Dive
- **Key Differences**:
  - **Runtime Support**: Cloud Run excels with any container/image; Cloud Functions limited to supported languages/runtime.
  - **Timeout**: Cloud Run (up to 1 hour HTTP); Functions (1 hour for HTTP, 9 mins for events, editable to 1 hour).
  - **Custom Domains**: App Engine and Cloud Run support; Functions do not.
  - **Concurrency**: Cloud Run/Functions second-gen up to 1,000; Functions Gen 1 is 1.
  - **Pricing**: Cloud Run cheaper for request-based billing; Functions free up to 2M invocations.

#### Tables
| Feature              | Cloud Run Service | Cloud Run Functions (Gen 2) | App Engine | Compute Engine |
|----------------------|--------------------|------------------------------|------------|----------------|
| Max Timeout         | 15 mins (HTTP)   | 1 hour (HTTP), 1 hour (events) | N/A        | No limit       |
| Custom Domains      | ✅               | ❌                           | ✅        | Through Load Balancer |
| Runtime Flexibility | Any container    | Language-specific           | Limited   | Full OS control |
| Autoscaling         | Yes              | Yes                          | Yes       | Manual/Auto    |

## Decision Tree for Choosing Compute Options

### Overview
Use this decision tree to select the appropriate Google Cloud compute service based on workload requirements.

### Key Concepts/Deep Dive
1. **OS/Hardware Dependency**: If specific OS or GPU required → Compute Engine.
2. **Cloud Agnostic/HTTP-Based**: If yes → Cloud Run Service.
3. **Event-Driven/Cloud-Native**: If yes → Cloud Run Functions.
4. **Web Application/Zero Touch**: App Engine.
5. **Containerized**: Kubernetes Engine (GK) or Cloud Run.
6. **Fallback**: Compute Engine or VMware Engine for rigid setups.

## Pricing and Quotas

### Overview
Pricing for serverless compute focuses on invocations, CPU/memory allocation, and execution time. Free tiers (e.g., 2M requests/month) apply to Cloud Run/Functions.

### Key Concepts/Deep Dive
- **Cloud Run Billing Modes**: Request-based (per invocation + compute time) or instance-based (lifecycle cost).
- **Cloud Functions Gen 1**: Free up to 2M invocations/month.
- **Quotas**: 1,000 Cloud Functions per region (Gen 2 shared with Cloud Run instances); 100 Functions per project (Gen 1).
- **Cost Optimization**: Minimize execution time; use free tiers; monitor via Billing reports/grouped by SKU.

```diff
+ Key Takeaways:
+ Concurrency: Default 80 in Cloud Run; set lower for single-threaded apps to avoid race conditions.
+ Timeouts: 1 hour standard; use workarounds for event triggers (deploy 9 mins, edit to 1 hour).
+ EventArc: Better than HTTP for long/async tasks; enable retries for reliability.
+ VMware Engine: For lift-and-shift migrations without code changes.
+ Comparisons: Cloud Run for flexibility; Functions for events; App Engine for simplicity.
+ Pricing: Request-based preferred for cost; monitor execution time for optimization.
```

### Expert Insights

Real-world Application: In production, use Cloud Run Functions with EventArc for auto-scaling event-driven workflows (e.g., file processing). For complex apps, combine Cloud Run Services with custom domains via Load Balancer.

Expert Path: Master by experimenting with concurrency settings for real workloads; learn EventArc filters for precise triggers. Practice CLI deployments and billing query by SKU for cost engineering.

Common Pitfalls: 
- Overlooking concurrency causing duplicates—design for idempotency and use locking.
- HTTP timeouts for events—switch to EventArc; avoid buggy retry loops by setting failure thresholds.
- Cost overruns from long execution—optimize code and monitor metrics; quash unused functions to avoid quotas affecting new deploys. 
- Lesser Known: VMware Engine supports seamlessly migrating vCenter-managed environments; Cloud Functions Gen 2 shares quotas with Cloud Run, so high concurrency may limit total instances.
