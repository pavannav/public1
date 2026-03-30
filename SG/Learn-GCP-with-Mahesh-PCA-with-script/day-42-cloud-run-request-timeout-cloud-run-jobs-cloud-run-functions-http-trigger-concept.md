# Session 42: Cloud Run Request Timeout, Cloud Run Jobs, Cloud Run Functions HTTP Trigger Concept

## Table of Contents
- [Cloud Build Packs and Source Deployment](#cloud-build-packs-and-source-deployment)
- [Design Considerations for Cloud Run Services](#design-considerations-for-cloud-run-services)
- [Cloud Run Jobs Overview](#cloud-run-jobs-overview)
- [Cloud Run Functions Overview](#cloud-run-functions-overview)
- [First Generation vs Second Generation Cloud Functions](#first-generation-vs-second-generation-cloud-functions)
- [Summary](#summary)

## Cloud Build Packs and Source Deployment

### Overview
Cloud Build Packs is an open-source project that simplifies containerization by automatically generating Dockerfiles for source code. In Google Cloud, this integrates with Cloud Run, App Engine, and Cloud Run Functions. When deploying with `--source=.`, Cloud Build Packs detects the language and creates the necessary container image, eliminating the need for manual Dockerfile creation.

### Key Concepts
Cloud Build Packs automates the build process for supported languages like Node.js (up to version 22, down to 6), Python (latest to 3.7), Go, Java, Ruby, and PHP. It works well for web-focused applications, containerizing code into runnable images that can be deployed to Cloud Run.

However, it has limitations:
- Unsupported languages like Perl are not handled by Cloud Build Packs.
- Requires specific dependency files (e.g., `requirements.txt` for Python).
- If the source language or dependencies don't match supported builds, fall back to custom Dockerfiles.

For migrations, especially from AWS ECR or Azure ACR, first push the container to Artifact Registry if possible. If the code needs containerization, use Cloud Build Packs. If unsupported, generate a custom Dockerfile.

### Code/Config Blocks
To deploy using source:
```bash
gcloud run deploy my-service --source=. --allow-unauthenticated
```

For comparison with AWS/Azure registries:
| Feature | AWS ECR | Azure ACR | Google Artifact Registry |
|---------|---------|-----------|--------------------------|
| Pull/Push | Supported | Supported | Supported |
| Integration | With Cloud Run | With AKS | With Cloud Run |

### Lab Demos
**Demo 1: Using --source=. for Deployment**
1. Ensure source code is in a Git repo (e.g., GitHub, GitLab, or Bitbucket).
2. Add dependency file (e.g., `package.json` for Node.js).
3. Run command: `gcloud run deploy perl-app --source=. --allow-unauthenticated`.
4. Cloud Build Packs detects Node.js, generates container, and deploys.

**Demo 2: Migrating from AWS ECR**
1. Pull image from AWS ECR.
2. Push to Google Artifact Registry: `gcloud artifacts docker push us-central1-docker.pkg.dev/my-project/cloud-run-repo:image`.
3. Deploy: `gcloud run deploy --image=us-central1-docker.pkg.dev/my-project/cloud-run-repo:image --allow-unauthenticated`.

## Design Considerations for Cloud Run Services

### Overview
Cloud Run Services excel at running stateless, web-focused workloads but have design constraints that beginners should consider. Key limitations include request timeouts, resource limits, and support for any web-focused language as long as it can be containerized.

### Key Concepts
**Request Timeout:**
- Maximum HTTP request timeout is 1 hour.
- Exceeds typical web application response times (e.g., 5-60 seconds).
- Suitable for jobs like web crawling or data processing lasting up to 1 hour.
- Beyond 1 hour, use Cloud Run Jobs (up to 7 days in preview) or alternatives like Compute Engine.

**Comparison with App Engine:**
| Aspect | App Engine Standard | App Engine Flexible | Cloud Run Services |
|--------|---------------------|---------------------|---------------------|
| Timeout | 60 seconds | 1 hour | 1 hour |
| Resource Limits | CPU/memory quotas | Dedicated instances (up to n2-standard-128) | Up to 8 vCPUs, 32 GB RAM |
| Scaling | Automatic | Slower scaling | Sub-second |

**Resource Constraints:**
- Max 8 vCPUs and 32 GB RAM (per instance).
- Not ideal for compute-intensive tasks exceeding these limits.
- Cold start impacts initial requests.

Support any language via custom containers (e.g., Perl via Dockerfile and command: `docker build -t perl:latest . && docker push`).

### Code/Config Blocks
Sample Dockerfile for custom language (e.g., Perl):
```dockerfile
FROM perl:5.34
COPY . /app
WORKDIR /app
CMD ["perl", "main.pl"]
```

For testing timeouts:
```python
# server.js (Node.js example)
const express = require('express');
const app = express();

app.get('/', (req, res) => {
    setTimeout(() => {
        res.send('Hello after 5 minutes');
    }, 300000);  // 5 minutes
});

app.listen(8080);
```

### Tables
**HTTP Timeouts:**
| Service | Max Timeout |
|---------|-------------|
| App Engine Standard | 60 seconds |
| App Engine Flexible | 1 hour |
| Cloud Run Services | 1 hour |
| Cloud Run Jobs | Up to 7 days (preview) |

### Lab Demos
**Demo: Testing 1 Hour Timeout in Cloud Run**
1. Deploy Node.js app: Modify timeout to 30 minutes and set Cloud Run timeout to 30 minutes via UI or `gcloud run deploy --timeout=30`.
2. Test: `curl https://service-url`.
3. Result: Succeeds within timeout; times out if exceeded.

✅ Supports any web-focusable language.
❌ Request timeout >1 hour not supported.

## Cloud Run Jobs Overview

### Overview
Cloud Run Jobs handle asynchronous, background tasks running for extended periods without HTTP interactions. Ideal for jobs like data scraping, backups, or analytical tasks, with support up to 7 days in preview.

### Key Concepts
- Designed for tasks running longer than Cloud Run Services' 1-hour limit.
- Supports same languages but uses containers; can run shell scripts via custom Dockerfiles.
- Resource limits: 8 vCPUs, 32 GB RAM.
- No concurrent task limits in UI; parallelism configurable.
- Service account: Compute Engine default.

**Use Cases:**
- Web scraping: Process data from APIs or sites.
- Database backups to Cloud Storage.
- Batch processing.

**Advantages:**
- Fully asynchronous; trigger via CLI or APIs.
- Integrates with Cloud Build, Artifact Registry.
- Jobs can be retried; parallelism for efficiency.

### Code/Config Blocks
Sample Dockerfile for shell script job:
```dockerfile
FROM alpine:latest
COPY job.sh /app/job.sh
RUN chmod +x /app/job.sh
CMD ["/app/job.sh"]
```

Sample `job.sh`:
```bash
#!/bin/bash
echo "Starting job at $(date)"
sleep 3600  # Sleep for 1 hour
echo "Job completed at $(date)"
```

Deployment:
```bash
gcloud run jobs create my-job --source=. --region=us-central1
gcloud run jobs execute my-job
```

### Tables
**Cloud Run Impact Comparison:**
| Aspect | Cloud Run Services | Cloud Run Jobs |
|--------|---------------------|----------------|
| Timeout | 1 hour | Up to 7 days |
| Execution | HTTP-triggered | Background/asynchronous |
| Languages | Any web-focused | Any containerizable (including shell) |
| Use Case | Microservices | Batch jobs, crawlers |

### Lab Demos
**Demo: Running a 1-Hour Sleep Job**
1. Create `job.py`: Python script with `time.sleep(3600)`.
2. Dockerize and deploy: `gcloud run jobs create sleep-job --image=gcr.io/my-project/sleep:v1`.
3. Execute: Check logs for completion.
4. Result: Job runs for 1 hour without timeout (if configured).

**Demo: Retrying Failed Jobs**
1. Create job with invalid script (e.g., missing files).
2. Set retries to 2: `--max-retries=2`.
3. Execute and observe failures/retries.

## Cloud Run Functions Overview

### Overview
Cloud Run Functions (formerly Cloud Functions) are event-driven serverless functions, triggered by events like HTTP requests, bucket changes, or Pub/Sub messages. Evolution from Cloud Functions Gen 1 to Gen 2, now powered by Cloud Run.

### Key Concepts
- Ideal for single, event-triggered tasks (e.g., image processing on upload).
- Supported runtimes: Node.js, Python, Go, Java, Ruby, PHP.
- Built-in libraries: FFmpeg (video), ImageMagick (images), headless Chrome (web scraping).
- Gen 1: Older, separate product; Gen 2: Based on Cloud Run, better performance.

**Triggers:**
- HTTP: Direct endpoint invocation.
- Cloud Storage: On file upload/download.
- Pub/Sub: Message-based (to be covered in Module 6).

### Code/Config Blocks
Gen 2 Python HTTP function:
```python
from flask import Flask, request
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello from PCA Team'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
```

Gen 2 requirements.txt:
```
Flask==2.3.3
functions_framework==3.4.0
```

Deployment:
```bash
gcloud functions deploy my-function --source=. --trigger-http --runtime=python312 --allow-unauthenticated
```

### Lab Demos
**Demo: HTTP-Triggered Function**
1. Create `main.py` as above.
2. Deploy with above command.
3. Invoke via curl: `curl https://region-project.cloudfunctions.net/my-function`.
4. Output: "Hello from PCA Team"

**Demo: Multi-Region Deployment**
1. Deploy same function in us-central1 and asia-south1.
2. Test redundancy for high availability.

## First Generation vs Second Generation Cloud Functions

### Overview
Gen 1 is legacy, deprecating soon; Gen 2 is recommended, integrating_gen1 Cloud Run for better scaling and features.

### Key Concepts
**Comparisons:**
| Aspect | Gen 1 | Gen 2 |
|--------|-------|-------|
| Backend | Standalone | Cloud Run/K-Native |
| Service Account | App Engine default | Compute Engine default |
| Regions | Limited | Most Cloud Run regions |
| Resource Limits | 2 GB RAM max | 32 GB RAM/8 vCPUs |
| Traffic Splitting | No | Yes (via Cloud Run UI) |
| Deployment Source | Source/Triggered repos | Artifact Registry only |
| Integrations | Cloud Storage, Pub/Sub | All, plus Cloud Run features |

Gen 2 supports traffic splitting, more regions, and scalability but fewer regions than fully-global services.

### Code/Config Blocks
Gen 1 inline editor (Node.js):
```javascript
exports.helloWorld = (req, res) => {
  res.json({ message: 'Hello from PCA Team' });
};
```

Gen 2 (same, with framework):
```javascript
const functions = require('@google-cloud/functions-framework');
functions.http('helloHttp', (req, res) => {
  res.send('Hello HTTP World!');
});
```

### Lab Demos
**Demo: Gen 1 to Gen 2 Migration**
1. Deploy Gen 1 function.
2. Recreate in Gen 2 with same code.
3. Compare: Gen 2 shows in Cloud Run under "Deployment Type: Function".

## Summary

### Key Takeaways
```diff
+ Cloud Run Services: 1-hour timeout, web-focused apps.
- Timeout Limitation: Jobs >1 hour need Cloud Run Jobs or alternatives.
+ Cloud Run Jobs: Up to 7 days (preview), for batch/background tasks.
- Resource Caps: 8 vCPUs/32 GB RAM across Services/Jobs/Functions.
+ Cloud Run Functions: Event-driven, Gen 2 preferred.
! Gen 1 Deprecating: Migrate to Gen 2 for scalability and features.
```

### Expert Insight
**Real-world Application**: Use Cloud Run Jobs for ETL pipelines processing data from BigQuery to GCS, running overnight without manual intervention. Cloud Run Functions ideal for real-time image resizing on GCS uploads in e-commerce apps.

**Expert Path**: Start with Gen 2 Functions for HTTP events, then explore Pub/Sub triggers (Module 6). Master containerization to surpass Build Packs limits. Integrate with IAM for secure service accounts in production.

**Common Pitfalls**: Ignoring timeouts leads to failed jobs—always test with deliberate delays. Overusing Gen 1 in non-supported regions causes deployment failures. Avoid complex logic in Functions; prefer Services for sustained HTTP traffic.

> [!IMPORTANT]
> Always prefer Cloud Run Jobs for async tasks and Gen 2 Functions for events to leverage Cloud Run's scalability. Test with sleep commands to validate timeouts before production deployment.
> 
> [!NOTE]
> Cloud Build Packs supports web apps only; use Dockerfiles for shell scripts or non-web code. Monitor costs: Initial builds free, but invocations scale quickly.
