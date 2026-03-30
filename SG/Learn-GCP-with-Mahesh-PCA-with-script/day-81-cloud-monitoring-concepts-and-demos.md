# Session 81: Cloud Monitoring Concepts and Demos

## Table of Contents
- [Service Account Roles for Metrics Capture](#service-account-roles-for-metrics-capture)
- [Setting up Service Accounts and Roles](#setting-up-service-accounts-and-roles)
- [Capturing Metrics from Virtual Machines](#capturing-metrics-from-virtual-machines)
- [Installing Ops Agent for Custom Metrics](#installing-ops-agent-for-custom-metrics)
- [Nginx Metrics Configuration and Monitoring](#nginx-metrics-configuration-and-monitoring)
- [Uptime Checks for Resource Monitoring](#uptime-checks-for-resource-monitoring)
- [Alerting Policies and Notification Channels](#alerting-policies-and-notification-channels)
- [CPU Utilization Alerting Demo](#cpu-utilization-alerting-demo)
- [Scoping Projects for Centralized Monitoring](#scoping-projects-for-centralized-monitoring)
- [Integration with AWS Metrics](#integration-with-aws-metrics)
- [Preview of Next Topic: Logging](#preview-of-next-topic-logging)

## Service Account Roles for Metrics Capture

### Overview
Cloud Monitoring allows organizations to collect and analyze metrics from Google Cloud resources like virtual machines, Kubernetes clusters, and serverless services such as Cloud Run. At its core, monitoring involves capturing telemetry data to ensure system health, performance, and availability. Service accounts play a crucial role in authorizing these services to send metrics data to monitoring systems. Without proper roles, metrics may not be captured or transmitted.

### Key Concepts/Deep Dive

#### Roles Required for Different Services
- **Virtual Machines (Compute Engine)**:
  - Require a service account with at least **Monitoring Metrics Writer** and **Logging Logs Writer** roles.
  - If using default service accounts, ensure they have editing roles that encompass these permissions (e.g., Editor role).
  - The Ops Agent must be installed on VMs to enable custom metrics collection.

- **Kubernetes (GKE)**:
  - Use **Kubernetes Engine Compute Engine VM Service Account** role, which combines Monitoring Metrics Writer and Logging Logs Writer.
  - For Standard GKE, assign the role directly.
  - For Autopilot GKE, assign the role after cluster creation; metrics may not capture immediately if roles are missing.

- **Cloud Run**:
  - No additional roles or agents required; metrics are captured automatically as Cloud Run is serverless.
  - Simply ensure a service account with basic permissions is attached.

- **Comparison of Roles Across Services**

  | Service               | Service Account Requirement | Additional Setup          |
  |-----------------------|-----------------------------|---------------------------|
  | Virtual Machines     | Monitoring Metrics Writer + Logs Writer | Install Ops Agent        |
  | Kubernetes Standard  | Kubernetes Engine Compute Engine VM SA | N/A                      |
  | Kubernetes Autopilot | Same as above (post-creation assignment) | Role must be added retrospectively |
  | Cloud Run            | Any service account (no specific role needed) | N/A                      |

#### Common Pitfalls in Role Assignment
- **Role Omission**: For VMs and Kubernetes, forgetting to assign roles results in missing metrics until corrected.
- **Autopilot Delays**: In Autopilot GKE, metrics may not appear instantly after role assignment due to node provisioning.
- **Firewall and Network Issues**: Private Google access is essential for VMs without external IPs to reach monitoring endpoints.

## Setting up Service Accounts and Roles

### Overview
Service accounts in Google Cloud Platform (GCP) are identities used by applications or services to interact with GCP APIs. For monitoring, service accounts must have specific IAM roles to write metrics and logs. This section covers creating dedicated service accounts, assigning roles, and creating Kubernetes clusters with correct configurations for testing metrics capture.

### Key Concepts/Deep Dive
#### Creating Service Accounts
- Use GCP IAM to create service accounts without initial roles.
- Example command via Bash:
  ```bash
  gcloud iam service-accounts create gke-sa-autopilot --description="Service account for GKE Autopilot metrics" --display-name="GKE SA Autopilot"
  ```
- Create multiple service accounts for comparative testing (e.g., with/without roles).

#### Assigning Roles
- Key roles: `roles/monitoring.metricService.metricWriter` and `roles/logging.logWriter`.
- Use combined role `roles/container.hostServiceAgentUser` for Kubernetes.
- Assign via IAM policies or cluster creation parameters.
- For Autopilot GKE, assign roles after cluster creation using:
  ```bash
  gcloud iam service-accounts add-iam-policy-binding SERVICE_ACCOUNT@PROJECT.iam.gserviceaccount.com --member=serviceAccount:GKE_SERVICE_ACCOUNT --role=roles/container.hostServiceAgentUser
  ```

#### Cluster Creation for Testing
- Create Autopilot GKE clusters in different regions to avoid quota issues.
- Use commands like:
  ```bash
  gcloud container clusters create CLUSTER_NAME --region=REGION --node-pool=autopilot --service-account=SERVICE_ACCOUNT
  ```
- Compare clusters: one with proper roles (metrics captured) vs. one without (no metrics).

#### Demo Steps
1. Create two service accounts: `gke-sa-autopilot-no-role` and `gke-sa-right-role`.
2. Create Autopilot clusters:
   - Cluster 1: Use `gke-sa-autopilot-no-role` (no metrics initially).
   - Cluster 2: Use `gke-sa-right-role` (metrics enabled).
3. Verify metrics in Cloud Monitoring > Observability after 10-15 minutes.
4. For clusters without roles, assign roles retrospectively and wait for metrics to appear.

## Capturing Metrics from Virtual Machines

### Overview
Virtual machines in GCP can be monitored for built-in metrics like CPU, memory, and disk utilization. Enabling metrics capture requires the Ops Agent installation and proper service account roles. This ensures data flows to Cloud Monitoring without external IP addresses, relying on private Google access.

### Key Concepts/Deep Dive
- **Prerequisites**: Ops Agent installed, service account with monitoring roles, subnet with private Google access.
- **Built-in Metrics**: CPU utilization, memory usage, disk I/O reported automatically.
- **Uptime Checks**: Not directly a metric capture but used for proactive monitoring.

#### Code/Config Blocks
```bash
# Install Ops Agent (executed via VM startup script or SSH)
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install
sudo systemctl enable google-cloud-ops-agent
```

#### Lab Demo
1. Create a VM with internal IP, Ops Agent installed, and correct service account.
2. Use Cloud Monitoring Metrics Explorer to view CPU, memory, disk metrics.
3. Apply filter for instance name to isolate metrics.
4. Enable Private Google Access on subnet for external IP-less VMs.

> [!NOTE]
> Metrics take 5-10 minutes to appear after agent installation.

## Installing Ops Agent for Custom Metrics

### Overview
The Google Cloud Ops Agent extends monitoring beyond built-in metrics by capturing data from third-party applications like Nginx. Installation involves configuration updates to the agent's YAML file, enabling custom telemetry collection.

### Key Concepts/Deep Dive
- **Third-Party Apps Supported**: Nginx, Apache, MySQL, etc.
- **Configuration**: Update `/etc/google-cloud-ops-agent/config.yaml` with receiver sections.
- **Reload Process**: Restart agent after changes.

#### Config Updates
```yaml
# In /etc/google-cloud-ops-agent/config.yaml
metrics:
  receivers:
    nginx:
      type: nginx
      stub_status_url: "http://localhost/server-status"
  service:
    pipelines:
      nginx_pipeline:
        receivers: [nginx]
```

#### Lab Demo
1. SSH into VM: Install Nginx `sudo apt update && sudo apt install nginx`.
2. Enable Nginx stub status:
   ```nginx
   # In /etc/nginx/sites-available/default
   location /server-status {
       stub_status on;
       access_log off;
       allow 127.0.0.1;
       deny all;
   }
   ```
3. Update Ops Agent config and restart:
   ```bash
   sudo systemctl restart google-cloud-ops-agent
   ```
4. Verify metrics in Metrics Explorer (Nginx requests, connections).

## Nginx Metrics Configuration and Monitoring

### Overview
Monitoring Nginx involves configuring it for status reporting and integrating with the Ops Agent. This allows tracking of requests, connections, and performance specific to the web server application layer.

### Key Concepts/Deep Dive
- **Stub Status Module**: Enables `/server-status` endpoint for metrics.
- **Ops Agent Receivers**: Pulls data from Nginx and sends to monitoring.
- **Use Cases**: Application-level load balancing, autoscaling triggers based on requests.

#### Code Blocks
```bash
# Automate Nginx config update
sed -i '/server {/a    location /nginx_status { stub_status on; allow 127.0.0.1; deny all; }' /etc/nginx/sites-available/default
sudo systemctl reload nginx
```

#### Lab Demo
1. Follow installation steps.
2. Generate load with `siege -c 100 -t 5M http://localhost`.
3. Monitor in-dashboards or Metrics Explorer for request spikes.
4. Integrate with managed instance group autoscaling.

## Uptime Checks for Resource Monitoring

### Overview
Uptime checks verify resource availability by simulating requests. They are crucial for detecting outages in VMs, load balancers, or URLs, ensuring proactive incident response.

### Key Concepts/Deep Dive
- **Check Types**: HTTP/HTTPS, TCP, ICMP (ping).
- **Regions**: Global checks from multiple locations.
- **Frequency**: Configurable (e.g., every minute).
- **Integrations**: Automatic alerting via email, Pub/Sub, etc.
- **Firewall Requirements**: For internal IPs, allow specific GCP uptime check ranges.

#### Response Expectations
- Acceptable codes: 200-399.
- Timeouts: Default 10 seconds.
- Locations: Multiple continents.

#### Lab Demo
1. In Monitoring > Uptime Checks, create check for instance or URL.
2. Use internal IP with firewall rules or external IP.
3. Set notifications: Email, Pub/Sub, etc.
4. Simulate failure by stopping VM; verify alerts in email and console.

> [!IMPORTANT]
> Whitelist GCP uptime check IP ranges in firewall for private checks.

## Alerting Policies and Notification Channels

### Overview
Alerting policies define conditions that trigger notifications when metrics violate thresholds. Notification channels determine how alerts are delivered, supporting multiple methods for reliability.

### Key Concepts/Deep Dive
- **Policy Components**: Metric selection, rolling window, condition (e.g., >90% CPU).
- **Channels**: Email, Slack, PagerDuty, Pub/Sub, SMS.
- **Runbooks**: Documentation in alerts for response guidance.
- **Best Practices**: Use multiple channels to avoid missing alerts.

#### Configuration
- Example CPU Alert Policy:
  - Metric: `compute.googleapis.com/instance/cpu/utilization`
  - Condition: Mean over 5 minutes > 0.15
  - Channels: Email + Pub/Sub

#### Lab Demo
1. Create policy in Monitoring > Alerting.
2. Set CPU threshold, add runbook documentation.
3. Test notifications by generating load on VM.
4. Receive emails and Pub/Sub messages.

## CPU Utilization Alerting Demo

### Overview
This demo demonstrates configuring and triggering an alert based on CPU utilization, simulating high load to exceed a custom threshold.

### Key Concepts/Deep Dive
- **Rolling Windows**: Average over time periods (e.g., 5 minutes).
- **Thresholds**: User-defined (e.g., 15% for demo).
- **Load Generation**: Python script for CPU stress.

#### Code Blocks
```python
# cpu_stress.py
import threading
from math import sqrt

def stress():
    while True:
        sqrt(999999999999 ** 999999999)  # Intense calculation

threads = []
for _ in range(4):
    t = threading.Thread(target=stress)
    t.start()
    threads.append(t)

for t in threads:
    t.join()
```

#### Lab Demo
1. Deploy VM, run stress script.
2. Configure alerting policy for CPU >15%.
3. Wait for alert; observe in console and email.
4. Include detailed runbook in alert notifications.

## Scoping Projects for Centralized Monitoring

### Overview
Scoping projects (formerly workspaces) enable centralized monitoring across GCP projects, providing a single pane of glass for multi-project environments.

### Key Concepts/Deep Dive
- **Setup**: Set one project as scoping; add others as monitored.
- **Benefits**: Unified dashboards, policies without project switching.
- **Billing**: Metrics still billed per originating project.

#### Configuration
- In Settings > Metrics Scope, add monitored projects.

## Integration with AWS Metrics

### Overview
Cloud Monitoring supports AWS resources via dedicated agents, allowing unified monitoring of multi-cloud environments.

### Key Concepts/Deep Dive
- **Supported Services**: EC2, ELB, RDS, S3 equivalents.
- **Setup**: Deploy AWS monitoring agent, configure as monitored project.

#### Comparison
| GCP | AWS Equivalent | Monitoring Support |
|-----|----------------|---------------------|
| VMs | EC2           | Yes                 |
| Cloud SQL | RDS    | Yes                 |

## Preview of Next Topic: Logging

### Overview
Cloud Logging captures and analyzes audit logs for security and compliance, enabling queries on historical events like resource deletions or access grants.

### Key Concepts/Deep Dive
- **Log Types**: Activity, data access, system events.
- **Exploration**: Use Log Explorer for queries (e.g., "resource.type=gce_instance").
- **Centralization**: Via Log Buckets and sinks to BigQuery or Cloud Storage.

---

## Summary

### Key Takeaways
```diff
+ Cloud Monitoring requires specific IAM roles for service accounts to capture metrics from VMs, Kubernetes, and Cloud Run services.
- Forgetting to assign roles like Monitoring Metrics Writer can lead to missing telemetry data, especially in Autopilot Kubernetes clusters.
! Alerting policies with multiple notification channels (e.g., email + Pub/Sub) enhance reliability and compliance with best practices.
- Firewall configurations must allow GCP uptime check IP ranges for private resource monitoring to avoid false negatives.
```

### Expert Insight
**Real-world Application**: In production environments, integrate Cloud Monitoring with autoscaling Managed Instance Groups using Nginx requests as triggers, ensuring elastic scaling based on real application load rather than just VM-level metrics. Centralized scoping projects streamline DevOps teams monitoring thousands of resources across projects, reducing context-switching overhead.

**Expert Path**: Master advanced monitoring by implementing custom SLOs using Service Level Objectives with custom metrics. Deepen expertise with MQL (Monitoring Query Language) for complex queries and Prometheus-style integration for Kubernetes workloads. Pursue Google Cloud Professional Cloud Architect certification modules on operations for production-grade skills.

**Common Pitfalls and Resolutions**: 
- **Pitfall**: Delays in metrics appearing post-role assignment in Autopilot GKE due to node provisioning; Resolution: Wait 15-30 minutes and verify in Metrics Explorer.
- **Pitfall**: Alert fatigue from ignored emails; Resolution: Embed detailed runbooks in notifications and use multiple channels like Slack for DevOps teams.
- **Pitfall**: Incorrect Ops Agent config for third-party apps causing missing logs; Resolution: Validate YAML syntax and test with `sudo systemctl status google-cloud-ops-agent`.
- Lesser-known fact: Cloud Monitoring integrates AWS metrics seamlessly via agents, enabling unified dashboards for hybrid cloud architectures without vendor lock-in.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
