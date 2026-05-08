# Session 09: GKE Vs Cloud Run, Support for Custom Machine Type in N,E,T,C,M Series

- [Questions on Compute Service Use Cases](#questions-on-compute-service-use-cases)
- [Differences Between App Engine and Cloud Run](#differences-between-app-engine-and-cloud-run)
- [Example: Deploying WordPress](#example-deploying-wordpress)
- [Stateful vs Stateless Applications](#stateful-vs-stateless-applications)
- [Migration from Other Clouds (e.g., EKS to GKE)](#migration-from-other-clouds-ega-eks-to-gke)
- [Custom Machine Type Support](#custom-machine-type-support)
- [Summary](#summary)

## Questions on Compute Service Use Cases

### Overview
This section addresses questions on when to use different GCP compute services like App Engine, Cloud Run, and Cloud Functions, emphasizing future-focused architectures.

### Key Concepts
App Engine and Cloud Run are suitable for stateless web applications that do not need persistent state. Use cases include front-end UIs, middle-tier services, and microservices exposed over HTTP/HTTPS protocols.

- **`App Engine`**: Primarily for applications, not databases. Supports front-end and middle-tier deployments with protocols like HTTP/HTTPS, and is ideal for microservices.
- **`Cloud Run`**: Similar to App Engine but requires containerization. It supports the same use cases (stateless web apps, microservices) but gives more control through Docker images.
- **`Cloud Functions`**: Best for event-driven scenarios where you respond to specific events, not for running continuous applications.

Focus areas for modern GCP architectures should prioritize Compute Engine, Kubernetes Engine (GKE), and Cloud Run, rather than older services like App Engine.

💡 **Note on Evolution**: App Engine is the predecessor to Cloud Run; whatever App Engine can do, Cloud Run can also accomplish, often with better flexibility.

### Deep Dive
Architects should consider the following decision framework:

1. **Event-Driven Only**: Use Cloud Functions.
2. **Stateless Web Applications/Microservices**: Use Cloud Run or App Engine.
   - If you prefer not to containerize, use App Engine (Google handles containerization).
   - For more control or existing Docker knowledge, use Cloud Run.
3. **Anything with State (Databases, Storage Operations)**: Avoid serverless options; opt for Compute Engine or GKE.

> [!NOTE]
> Legacy App Engine deployments exist for backward compatibility, but new projects should default to Cloud Run for stateless workloads.

## Differences Between App Engine and Cloud Run

### Overview
App Engine is positioned as an upgraded version of App Engine, with Cloud Run being the modern successor handling modern technologies better.

### Key Concepts
- **Containerization**:
  - App Engine: Google handles containerization automatically.
  - Cloud Run: Requires building Docker containers (though Google Cloud Build can create images from source code).
- **Deployment**:
  - App Engine: Deploy with `gcloud app deploy` using source code.
  - Cloud Run: Deploy a container image.
- **Architecture Fit**:
  - Both support stateless applications, event-driven scenarios.
  - Cloud Run offers better integration with container ecosystems and CI/CD pipelines.

### Deep Dive
Cloud Run provides more flexibility as it's built on Kubernetes underpinnings, allowing integration with GKE if needed. Recent updates enable Cloud Run to auto-create containers from source code, bridging the gap with App Engine.

```diff
+ Greater flexibility and control in Cloud Run
+ Easier integration with modern container workflows
+ Better scalability and integration options in Cloud Run
- App Engine requires less setup for beginners
+ Cloud Run is recommended for new projects
```

> [!WARNING]
> Avoid App Engine for new deployments unless specific legacy requirements exist. Focus on Cloud Run for serverless stateless applications.

## Example: Deploying WordPress

### Overview
This section provides a practical example of deploying a stateful application like WordPress in serverless environments like Cloud Run or App Engine.

### Key Concepts
WordPress is a content management system with a PHP front-end and MySQL back-end. Static content (themes, plugins) is stored in Cloud Storage (GCS), and dynamic data in MySQL.

- **Architecture Setup**:
  - Front-end: Renders graphics and content.
  - Back-end: MySQL database for persistence.
  - Storage: GCS for media and plugins.
  - Communication: Direct from Cloud Run/App Engine to GCS and MySQL.

### Deep Dive
- **Cloud Run Deployment**:
  - Pull official WordPress Docker image from Docker Hub.
  - Build and deploy containerized version.
  - Integrate with MySQL and GCS via code.

```bash
# Example: Pull and run WordPress container
docker pull wordpress:latest
# Then deploy to Cloud Run
gcloud run deploy --image wordpress
```

- **App Engine Deployment**:
  - Clone WordPress source from GitHub.
  - Build and deploy using `gcloud app deploy`.
  - Requires modifying code for GCS integration (tricky without experience).

Both are possible for WordPress, but Cloud Run is simpler due to existing containerized images.

> [!IMPORTANT]
> Always connect persistent storage to external services (GCS, databases) instead of local disks in serverless environments.

## Stateful vs Stateless Applications

### Overview
Serverless services like Cloud Run and App Engine are inherently stateless, meaning no persistent local storage across requests.

### Key Concepts
Stateless applications keep no state in the container; all data is external. Stateful applications attempt to persist data locally (e.g., on /opt or C drive), which fails in serverless.

### Deep Dive
- **Why Stateless?**: Instances are ephemeral; after a request, the container may be dismantled, and new requests could hit fresh instances.
- **Best Practices**:
  - Store state in databases, data warehouses, or cloud storage.
  - Avoid writing to local paths; use external storage for uploads, configurations.

```diff
+ Use Google Cloud Storage for files
+ Use databases (MySQL, PostgreSQL) for data
+ Use in-memory databases (Redis) for sessions if needed
- Never write to local disk (/opt, /tmp with persistence)
```

**Real-World Example**: A video upload app stores files in GCS; processing is handled via event triggers. Code should connect to storage at runtime, not assume local persistence.

> [!NOTE]
> Designing for stateless is an architectural decision often handled by application architects to ensure scalability.

## Migration from Other Clouds (e.g., EKS to GKE)

### Overview
Migration from AWS EKS to GCP Cloud Run involves rewriting code if it's stateful or assessing containerization needs.

### Key Concepts
If the application is containerized (as in EKS), Cloud Run can run it directly. If it's stateful (e.g., installing software on local disks), it won't work.

### Deep Dive
- **Scenario**: Company migrates from EKS but lacks Kubernetes expertise. Code is poorly designed (stateful on local disk).
  - Cloud Run fails logs show write errors (e.g., to /opt).
  - Solution: Rewrite code for stateless or use GKE/Kubernetes Engine.
- **Recommendations**:
  - Change code to use external storage.
  - If developers are unavailable, force migration to Compute Engine or GKE.
  - Logs in Cloud Run reveal state issues immediately.

Cloud Functions and app engine don't support dependencies or stateful operations; stick to Compute Engine or GKE.

> [!WARNING]
> Always check logs first; failing deployments indicate stateful code that needs refactoring.

## Custom Machine Type Support

### Overview
Custom machine types allow tailoring CPU and memory, but support varies by series.

### Key Concepts
Custom types incur additional costs but enable precise resource allocation. Not all series support them.

### Deep Dive
- **Supported Series**:
  - General Purpose: N4, E2, N2, N2D
  - Compute Optimized: C3 (new, may not have custom yet)
  - Memory Optimized: No custom support (e.g., M series)
- **Not Supported**:
  - T series (Spot/Preemptible), A (Accelerator-optimized)
  - New series like C4 may lack custom options.

For example, if a configuration matches predefined, costs are similar; custom adds premium pricing.

📝 **Command Example**:
```bash
gcloud compute instances create my-instance --custom-cpu=2 --custom-memory=8GB
```

> [!NOTE]
> Use pricing calculator for cost comparisons across clouds with custom configurations.

## Summary

### Key Takeaways
```diff
+ App Engine and Cloud Run are for stateless, HTTP-based applications
+ Cloud Run is the modern, preferred choice over App Engine for new projects
+ Containerize for Cloud Run; Google builds images from source if needed
+ Always use external storage/dbs in serverless to maintain stateles
- Avoid App Engine for complex, modern app stacks
- Don't write stateful code that assumes local disk persistence
! Custom machine types add cost but provide flexibility in select series
```

### Quick Reference
- **App Engine Deploy**: `gcloud app deploy`
- **Cloud Run Deploy**: `gcloud run deploy --image <container>`
- **Custom Instance**: Example `--custom-cpu=4 --custom-memory=16GB`
- Supported Custom: N4, E2, N2, N2D; Not M, T, A series

### Expert Insight
#### Real-world Application
In production, use Cloud Run for microservices in e-commerce recommendation engines. Pair with Cloud Storage for assets and Firestore for sessions to handle "stateless state."

#### Expert Path
Master containerization (Docker, Kubernetes); learn GKE for hybrid stateful/serverless. Practice rewriting legacy apps for stateles to ace migrations.

#### Common Pitfalls
- Assuming App Engine handles everything—it's fading for modern stacks.
- Ignoring logs; Cloud Run failures reveal state issues quickly.
- Overusing custom types without cost checks; predefined are cheaper when sufficient.

#### Lesser-Known Facts
App Engine's first-gen legacy supports more regions than Cloud Run in some cases, but this is waning. Custom machine types excel for AI/ML workloads needing GPU combinations.

#### Advantages and Disadvantages
- **Advantages**: Cloud Run's zero-maintenance, auto-scaling for web apps; Cost only during execution.
- **Disadvantages**: No support for persistent local state; requires code refactoring for migrations; Custom types raise costs unpredictably.

**Transcript Corrections Made**:
- "ript" corrected to "transcript"
- "anos" corrected to "Anthos"
- "ISO" assumed to be "IAM" based on context
- "htp" corrected to "HTTP"
- "Rus SC" corrected to "microservice"
- "stat that" corrected to "stateless"
- Numerous typos in word flow corrected for clarity (e.g., "state that data is a Mount as a dis wise" to "stateful data is a Mount as a disk wise")
- "an an" corrected from repetition.
