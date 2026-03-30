# Session 80: Terraform Concepts Part 2 and Cloud Monitoring Concepts

- [Overview of Terraform Concepts Part 2](#overview-of-terraform-concepts-part-2)
  - [Fixing Terraform Outputs](#fixing-terraform-outputs)
  - [Using Gemini CLI for Code Generation](#using-gemini-cli-for-code-generation)
  - [Commit and CI/CD Integration](#commit-and-cicd-integration)
  - [Reverse Engineering Terraform](#reverse-engineering-terraform)
  - [Terraform Blueprints and Alternatives](#terraform-blueprints-and-alternatives)
- [Cloud Monitoring Concepts Overview](#cloud-monitoring-concepts-overview)
  - [Introduction to Cloud Operations Suite](#introduction-to-cloud-operations-suite)
  - [Monitoring Virtual Machines](#monitoring-virtual-machines)
  - [Monitoring GKE Clusters](#monitoring-gke-clusters)
  - [Monitoring Cloud Run Services](#monitoring-cloud-run-services)
  - [Service Accounts and Roles for Monitoring](#service-accounts-and-roles-for-monitoring)
- [Summary](#summary)

## Overview of Terraform Concepts Part 2

### Fixing Terraform Outputs

Terraform outputs are crucial for exposing important infrastructure details after deployment. After creating Google Compute Engine (GCE) VMs through Terraform modules, you need to properly reference outputs from child modules in the root module.

Key steps:
- Define outputs in the module configuration
- Reference them in the root `main.tf` using module interpolation syntax
- Use correct attribute paths (e.g., `module.compute_engine.vm_name`)

Common issues:
- Interface vs network attributes in VM network configurations
- Improper indexing for list attributes

> [!IMPORTANT]
> Outputs should propagate from modules to the root level for CI/CD visibility, allowing pipelines to access VM details like IP addresses without console access.

### Using Gemini CLI for Code Generation

Gemini CLI provides an AI-powered alternative to traditional code writing, allowing local execution without uploading code to external platforms.

**Setup Requirements:**
- Node.js installed
- Authenticate with Google account (free tier: 1000 requests/day)
- Use Vertex AI for unlimited access (requires billing)

**Advantages:**
- Code remains local (secure for production codebases)
- Generates complete configurations (files, variables, integration)
- Supports iterative prompts for refinement

**Demonstrated Features:**
- README generation from existing codebase
- Firewall rule creation with module integration
- Automatic variable file setup
- Commit message suggestions

> [!NOTE]
> Gemini CLI is ideal for day-to-day development but not for exam preparation, as it's not part of official GCP certification curriculum.

### Commit and CI/CD Integration

Proper git workflows with Terraform enable automated deployments through CI/CD pipelines.

**Git Safety Protocols:**
- Add, commit, push changes sequentially
- Use descriptive commit messages
- Commit before triggering builds
- Handle partial failures gracefully

**Cloud Build Integration:**
- Automatic triggering on push events
- Parameterized builds for different environments (`dev.tfvars`, `prod.tfvars`)
- Parallel resource creation (VPC, GCS, VMs)
- Build success validation through artifact outputs

> [!IMPORTANT]
> Always test builds with clean deployments rather than incremental updates to ensure full infrastructure integrity.

### Reverse Engineering Terraform

Reverse engineering brings existing GCP resources under Terraform management, crucial for organizations with pre-existing infrastructure.

**Import Process:**
```bash
terraform init
terraform import [resource_type].[resource_name] [gcp_resource_id]
terraform show  # Review generated configuration
terraform state push  # If using remote state
terraform plan  # Verify no changes
terraform apply  # Confirm management
```

**Key Concepts:**
- Identify resource IDs (e.g., Spanner instance names, project IDs)
- Generate complete Terraform blocks using `terraform show`
- Remove system-generated attributes (id, state, labels)
- Parameterize configurations (avoid hardcoding)
- Handle dependencies (VPCs, networks, etc.)

| Aspect | Import | Manual Creation |
|--------|--------|-----------------|
| Speed | Fast for existing infra | Slower for complex resources |
| Accuracy | High (reads actual configuration) | Dependent on documentation |
| Dependencies | Automatic detection | Manual specification required |
| Attributes | Includes all current settings | May miss optional configurations |

> [!NOTE]
> Use reverse engineering sparingly for last-resort scenarios when existing infra must be managed as code. Ideal for disaster recovery setups.

**Module Integration:**
- Import into dedicated modules
- Configure root module references
- Synchronize state files between local and remote backends
- Validate with `terraform apply -auto-approve`

**Resource-Specific Examples:**

*Spanner Instance:*
```hcl
resource "google_spanner_instance" "default" {
  name         = "demo-instance"
  display_name = "Demo Instance"
  config       = "regional-us-central1"
  num_nodes    = 1
  # Remove system attributes like id, state
}
```

### Terraform Blueprints and Alternatives

Terraform blueprints provide pre-built, verified configurations from official GCP repositories.

**Blueprint Structure:**
```
terraform-google-modules/
├── compute-engine/
├── storage/
├── vpc/
├── load-balancer/
└── spanner/
```

**Example: GCS Bucket Creation**
```hcl
module "gcs_bucket" {
  source     = "terraform-google-modules/storage-bucket/google"
  version    = "~> 3.0"
  project_id = var.project_id
  names      = ["demo-bucket"]
  location   = "US"
}
```

**Advantages:**
- Official, tested configurations
- Regular updates and security patches
- Standardized patterns

*Disadvantages:*
- External dependency on GitHub repos
- Potential breaking changes with upstream updates
- Less control over implementation details

**Alternatives:**

*Pulumi:*
- Programming language support (Python, Go, TypeScript)
- Better developer experience for teams with coding backgrounds
- Easier debugging with familiar tools

*Deployment Manager:*
- GCP-native (deprecated for new projects)
- Integration with GCP-specific features
- Limited to Google Cloud ecosystem

| Tool | Provider Support | Learning Curve | Community Size |
|------|------------------|----------------|----------------|
| Terraform | Multi-cloud | Moderate | Very Large |
| Pulumi | Multi-cloud | Steep | Medium |
| Deployment Manager | GCP-only | Low | Small |

> [!IMPORTANT]
> Choose based on team expertise: Terraform for infrastructure teams, Pulumi for development teams with strong coding backgrounds.

## Cloud Monitoring Concepts Overview

### Introduction to Cloud Operations Suite

Cloud Operations (formerly Stackdriver) provides unified observability across GCP and AWS resources.

**Core Components:**
- **Cloud Monitoring:** Metrics collection and visualization
- **Cloud Logging:** Centralized log aggregation and analysis
- **Error Reporting:** Exception grouping and alerting
- **Trace Service:** Distributed tracing for latency analysis
- **Profiler:** Application performance profiling

**Evolution:**
- Acquired Stackdriver in 2016
- Renamed in 2020 to Cloud Operations Suite
- Supports multi-cloud monitoring capabilities

> [!IMPORTANT]
> Cloud Operations Suite is essential for maintaining production-ready infrastructure, providing visibility into system health, performance, and issues.

### Monitoring Virtual Machines

VM monitoring requires installing the Ops Agent for comprehensive metrics collection.

**Installation:**
- Automatic with "Enable logging and monitoring" option
- Manual installation using startup scripts
- Ops agent replaces legacy stackdriver logging/monitoring agents

**Metrics Categories:**

*System Metrics (No Agent Required):*
- CPU utilization
- Network throughput
- Disk read/write operations

*Agent-Required Metrics:*
- Memory utilization
- Disk space utilization
- Custom application metrics

**Service Account Requirements:**
```yaml
roles:
- roles/monitoring.metricWriter
- roles/logging.logWriter
```

**Configuration Example:**
```hcl
resource "google_compute_instance" "vm" {
  name         = "monitoring-vm"
  machine_type = "e2-medium"

  # Enable ops agent
  metadata = {
    enable-osconfig = "TRUE"
    ops-agent-config = jsonencode({
      third_party_applications = {}
      logs = {
        receivers = {
          syslog = {
            type = "syslog"
          }
        }
      }
      metrics = {
        receivers = {
          hostmetrics = {
            type = "hostmetrics"
          }
        }
      }
    })
  }

  service_account {
    email  = google_service_account.vm_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}
```

> [!NOTE]
> Ops agent automatically collects third-party application metrics (e.g., Apache, MySQL, MongoDB) when detected.

### Monitoring GKE Clusters

GKE monitoring works differently based on cluster mode.

**Standard Clusters:**
- Use dedicated service account with monitoring/logging roles
- System metrics enabled by default
- Workload metrics optional
- Agent-based collection on nodes

**Autopilot Clusters:**
- Monitoring/logging always enabled
- No manual configuration possible
- System metrics always collected
- Workload metrics optional

**Key Configuration:**

*Standard GKE:*
```hcl
resource "google_container_cluster" "standard" {
  name     = "monitoring-cluster"
  location = "us-central1"

  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS"]
    managed_prometheus {
      enabled = true
    }
  }

  logging_config {
    enable_components = ["SYSTEM_COMPONENTS"]
  }
}
```

*Service Account:*
```hcl
resource "google_service_account" "gke_sa" {
  account_id = "gke-monitoring-sa"
}

resource "google_project_iam_member" "gke_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}
```

> [!IMPORTANT]
> Prometheus metrics are enabled by default in GKE for advanced monitoring capabilities.

### Monitoring Cloud Run Services

Cloud Run monitoring is fully managed with no agent or special configuration required.

**Automatic Metrics:**
- Request/response counts
- Latency distributions
- Error rates
- Instance scaling information
- CPU and memory utilization

**Observability Features:**
- Built-in dashboards
- Automatic alerting
- Integration with Cloud Monitoring
- Log-based metrics and alerts

**Example Alerting Policy:**
```hcl
resource "google_monitoring_alert_policy" "cloud_run_high_latency" {
  display_name = "Cloud Run High Latency"
  documentation {
    content = "Cloud Run service experiencing high latency"
  }

  conditions {
    display_name = "Request latency > 1s"

    condition_monitoring_query_language {
      query = "fetch cloud_run_revision | metric 'run.googleapis.com/request_latencies' | align delta(1m) | every 1m | group_by [], [value_request_latencies_percentile: percentile(cont, 95)] | condition val() > 1 's'"
    }
  }
}
```

> [!NOTE]
> Cloud Run automatically scales based on traffic, and monitoring helps track resource utilization during traffic spikes.

### Service Accounts and Roles for Monitoring

Proper IAM configuration is critical for metrics collection across services.

| Service | Agent Required | Service Account Role(s) | Notes |
|---------|----------------|-------------------------|-------|
| VMs | Yes (Ops Agent) | monitoring.metricWriter, logging.logWriter | Manual installation |
| GKE Standard | No | container.defaultNodeServiceAccount (includes monitoring) | Node-level collection |
| GKE Autopilot | No | Built-in managed | No configuration possible |
| Cloud Run | No | None required | Fully managed |
| Cloud Storage | No | Built-in GCS service | Automatic metrics |
| BigQuery | No | Built-in BQ service | Automatic query metrics |

**Common Issues:**
- Missing `monitoring.metricWriter` role prevents metrics submission
- Incorrect project bindings prevent cross-project monitoring
- Legacy agent configurations inhibit proper data collection

> [!WARNING]
> Service accounts without proper roles result in "no data available" states in monitoring dashboards, creating false positives for system health.

## Summary

### Key Takeaways

```diff
+ Terraform outputs enable CI/CD pipelines to access infrastructure details like VM IPs and network configurations
+ Gemini CLI provides secure, local AI-assisted code generation with full context awareness
+ Reverse engineering brings existing GCP resources under Terraform management using import and show commands
+ Ops Agent is required for comprehensive VM monitoring, especially memory and disk metrics
+ Service accounts with monitoring.metricWriter and logging.logWriter roles are essential for metrics collection
+ Cloud Run and managed services provide automatic monitoring without configuration
+ Kubernetes node service accounts include built-in monitoring and logging permissions
- Hardcoded values in Terraform configurations reduce reusability and maintainability
- Missing IAM roles can prevent metrics from appearing in monitoring dashboards
- Over-reliance on AI tools for fundamental Terraform concepts weakens core understanding
- Incorrect attribute references in Terraform modules can break output propagation
- Not synchronizing Terraform state in reverse engineering scenarios leads to duplicate resource creation attempts
```

### Expert Insight

**Real-world Application:** In enterprise environments, Terraform reverse engineering is commonly used during cloud migration projects where legacy resources exist outside IaC frameworks. Cloud Monitoring integrates with incident response systems, automatically creating tickets when metric thresholds are breached. Ops Agent supports third-party application monitoring (e.g., databases, web servers) through auto-detection, enabling comprehensive infrastructure observability without manual configuration.

**Expert Path:** Master Terraform by building custom modules for frequently used patterns, then advance to multi-cloud deployments using providers. For monitoring, focus on custom dashboards and SLO (Service Level Objective) configurations using MQL (Monitoring Query Language) for precise alerting. Learn Pulumi as a complementary tool for teams with strong development backgrounds requiring programmatic IaC.

**Common Pitfalls:**
- Forgetting to commit module outputs to root configuration, breaking CI/CD visibility
- Using default service accounts without minimum IAM roles for managed services
- Not enabling private Google access in custom VPCs, blocking Ops Agent communication
- Ignoring Prometheus metrics in GKE clusters despite their rich observation capabilities
- Hardcoding resource names instead of using variables, making imports fail during reverse engineering
- Configuring OAuth 401 redirects instead of 302 redirects
- Not understanding the difference between stackdriver-meta-v1 and prometheus metrics in GKE

**Lesser Known Things About This Topic:**
- Terraform supports "moved" blocks for refactoring module structures without destroying resources
- Cloud Monitoring can collect custom metrics from applications using OpenCensus libraries
- Gemini CLI maintains local code security while providing context-aware suggestions
- GKE node pools can have different monitoring configurations than the cluster level settings
- Cloud Run automatically integrates with Cloud Trace for request path analysis without code changes

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
