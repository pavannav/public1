# Session 9: GKE vs Cloud Run and Custom Machine Types

## Table of Contents
- [Compute Options Comparison (App Engine, Cloud Run, Cloud Functions)](#compute-options-comparison-app-engine-cloud-run-cloud-functions)
- [Stateful vs Stateless Applications](#stateful-vs-stateless-applications)
- [Custom Machine Types Support](#custom-machine-types-support)
- [Cost Considerations](#cost-considerations)
- [Summary](#summary)

## Compute Options Comparison (App Engine, Cloud Run, Cloud Functions)

### Overview
This section explores the differences between various Google Cloud compute options, focusing on when to use App Engine, Cloud Run, and Cloud Functions. These services cater to different development approaches, with App Engine representing legacy offerings and Cloud Run/Cloud Functions being more modern, containerized alternatives. The discussion highlights use cases like stateless web applications, event-driven processing, and how these services handle state management through external databases and storage.

### Key Concepts/Deep Dive

#### Evolution and Primary Use Cases
- **App Engine**: An older, platform-as-a-service (PaaS) offering that automatically handles infrastructure but is fading out. It was Google's first major compute service and focuses on applications where developers don't need to manage containers.
- **Cloud Run**: Positions as the successor to App Engine, allowing deployment of any web application via containers. It supports both source code deployment (where Google builds the container) and pre-built container images.
- **Cloud Functions**: Best for event-driven workloads. It's designed for scenarios where execution happens only in response to events, with no persistent processes.

#### Deployment Differences
- **App Engine**:
  - Requires minimal setup: just code and a simple deploy command like `gcloud app deploy`.
  - Google handles containerization automatically.
  - Suitable for HTTP/HTTPS-based applications, microservices, and frontend/middle-tier services.

- **Cloud Run**:
  - Offers more flexibility: deploy from source code, pre-built images from Docker Hub, or create custom containers.
  - Recent improvements allow Google to build containers from source automatically.
  - Also focused on HTTP/HTTPS endpoints and microservices.

- **Cloud Functions**:
  - Triggered only by events, making it ideal for specific, one-time operations.
  - Not suitable for persistent or stateful applications.

#### Common Questions and Comparisons
| Aspect | App Engine | Cloud Run | Cloud Functions |
|--------|------------|-----------|-----------------|
| Containerization | Automatic by Google | Manual container creation or automatic build | Not applicable (functions) |
| State Preservation | External databases only | External storage only | External storage only |
| Best For | Web apps, microservices | Modern web apps, containers | Event-driven tasks |
| Infrastructure Control | Minimal | High (via containers) | Minimal |

### Addressing Migration and Modernization
- Companies migrating from AWS EKS to Google Kubernetes Engine (GKE) often face challenges when trying to move applications to Cloud Run because existing code may be stateful.
- Real-world example: An application using EKS that attempted migration to GKE via Cloud Run failed because it was writing to local file systems like `/opt`. The logs quickly revealed this issue, requiring either code refactoring or sticking with compute engine/Kubernetes for infrastructure as code (IaC).

## Stateful vs Stateless Applications

### Overview
This section differentiates between stateful and stateless applications, crucial for choosing appropriate compute services. Stateful applications require persistent data storage, while stateless ones manage data externally. Cloud Run, App Engine, and Cloud Functions are all stateless by design, forcing data persistence through external services like databases or Google Cloud Storage (GCS).

### Key Concepts/Deep Dive

#### Stateless Applications
- **Definition**: Applications that do not maintain state between requests. Each request is independent, and instances can be destroyed after handling without data loss.
- **Common Use Cases**:
  - Static frontends (e.g., e-commerce portals)
  - Recommendation services (microservices that serve HTTP endpoints)
  - API backends that process and return responses

- **Deployment in Cloud Services**:
  - Connect to external databases (e.g., MySQL for WordPress)
  - Use blob storage (GCS) for file uploads or persistent content
  - Avoid writing files locally; instead, store in external services

#### Stateful Applications
- **Definition**: Applications that require maintaining state, such as user sessions, cached data, or file systems that persist across requests.
- **Why Cloud Run/App Engine/Functions Struggle**:
  - Instances are ephemeral: scalability causes request routing to different instances, losing local data.
  - Examples of non-working patterns: Writing to `/opt`, `/var`, or local drives.
  - Suitable alternatives: Compute Engine or Kubernetes Engine for full control.

#### Example: WordPress Architecture
```
Frontend (WordPress UI)
    ↓ HTTP/HTTPS
Backend Services
├── MySQL Database (persists data like plugins, posts)
├── Google Cloud Storage (GCS) (for static assets, uploads)
└── Cloud Run/App Engine instance
```
- **Key Insight**: WordPress needs external MySQL and GCS to remain stateless.
- **Container Deployment**: Use official Docker Hub images or clone/build from GitHub.
- **File Upload Scenario**: User uploads photos → store in GCS, not local file system → process via event-driven functions if needed.

#### Architectural Principles
- Design for scalability: Never hardcode paths to `/C:` or `/opt`; use environment variables or external APIs.
- Application Architecture Role: Architects should design systems that leverage external storage instead of local persistence, ensuring portability across Cloud Run, App Engine, and Functions.

## Custom Machine Types Support

### Overview
Google Cloud Platform (GCP) offers custom machine types to optimize costs and performance by allowing precise specification of CPU cores and memory. However, support varies across machine families (C, E, T, N, M), with not all series providing this flexibility. This section explores availability and limitations to aid resource planning.

### Key Concepts/Deep Dive

#### Supported Machine Families for Custom Types
- **General Purpose**:
  - N4: Supports custom CPU/memory allocation
  - E2: Supports custom configuration
  - N2/N2D: Supports custom setups
- **Other Families**:
  - T2D: Does not support custom machine types
  - A2: Does not offer custom options
  - C3/C4: Newer series may lack custom support (e.g., shown as not having predefined or custom)
  - Memory-optimized (M series): Does not support custom machine types

#### How Custom Machine Types Work
- When available, custom machine types allow selection of specific CPU families (e.g., Intel-specific) while configuring vCPUs and RAM.
- Cost implications: Custom configurations may increase costs compared to predefined options, especially if equivalent standard types exist.
- Recommendation: Use custom only when predefined configurations don't fit your needs.

#### Limitations and Considerations
- Not all series within a family support custom types (e.g., higher-numbered or newer generations).
- Auditing: Always check GCP console or documentation for the latest support matrix.

## Cost Considerations

### Overview
Understanding compute costs is critical for cloud migration. GCP provides the pricing calculator tool for comparing costs across services. Custom machine types incur additional charges, especially compared to predefined equivalents. This section covers cost optimization strategies and comparisons with other cloud providers.

### Key Concepts/Deep Dive

#### Custom Machine Type Costs
- Higher expenses when custom configurations match existing predefined options.
- Use case: Pay the premium only if no standard type fits your requirements.

#### Comparison Tool Usage
- **GCP Pricing Calculator**: Essential tool for estimating and comparing costs.
  - Compare AWS, Azure, and GCP for identical configurations.
  - Real-time updates for accurate budgeting.

#### Strategic Insights
- Factor in migration paths: Moving from stateful applications (e.g., EKS to GKE) may require compute engine over Cloud Run due to code rigidity, potentially affecting cost models.
- Hidden Costs: Logs and error messages in Cloud Run often reveal stateful issues, preventing unnecessary customizations.

## Summary

### Key Takeaways
```diff
+ Choose Cloud Run over App Engine for modern containerized applications needing flexibility
- Avoid storing state locally in Cloud Run, App Engine, or Cloud Functions; use external databases (MySQL) and storage (GCS)
+ Custom machine types are not supported across all GCP compute families (N1, E2, N2 have stronger support than T2, A2, or M series)
- Stateful applications requiring data mounts or local writes need to migrate to Compute Engine or Kubernetes Engine
+ Use the pricing calculator to compare costs across AWS, Azure, and GCP before finalizing configurations
```

### Expert Insight
#### Real-world Application
In production, leverage Cloud Run for microservices like e-commerce recommendation engines that serve HTTP endpoints and connect to BigQuery or GCS for analytics. For migrations from legacy systems (e.g., EKS to GKE), implement CI/CD pipelines that refactor stateful code into stateless APIs, using containers for seamless deployment and scaling.

#### Expert Path
Master containerization fundamentals by experimenting with Docker Hub images (e.g., official WordPress) on Cloud Run. Gain proficiency in GCP's pricing calculator by modeling real workloads, and explore Kubernetes Engine for advanced stateful applications. Focus on serverless architectures while recognizing Compute Engine/GKE as fallbacks for complex, legacy systems.

#### Common Pitfalls
- **Mistake**: Assuming App Engine directly competes with modern tools; it handles basic apps but falters with databases or complex containers.
- **Overcoming**: Always containerize applications before Cloud Run deployment to avoid runtime errors from missing dependencies.
- **Issue**: Selecting custom machine types unnecessarily; verify no predefined equivalent exists via the GCP console.
- **Resolution**: Monitor Cloud Run logs post-deployment—errors about file system writes indicate needed code refactoring or service migration.
- **Less Common**: Overlooking CPU family selection in custom types, leading to performance mismatches; test configurations in development environments before production.
- **Avoidance**: Design stateless from the start: externalize all persistent data to prevent scalability issues, as ephemeral instances destroy local changes.
