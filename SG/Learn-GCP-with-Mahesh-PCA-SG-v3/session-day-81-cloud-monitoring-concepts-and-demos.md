# Session 81: Cloud Monitoring Concepts and Demos

## Table of Contents
- [Virtual Machine Metrics Capture](#virtual-machine-metrics-capture)
- [Kubernetes Standard and Autopilot Clusters Metrics](#kubernetes-standard-and-autopilot-clusters-metrics)
- [Third-Party Application Monitoring (Nginx)](#third-party-application-monitoring-nginx)
- [Uptime Checks](#uptime-checks)
- [Alerting Policies](#alerting-policies)
- [Notification Channels](#notification-channels)
- [Dashboards and Charts](#dashboards-and-charts)
- [Scoping Projects (Workspace)](#scoping-projects-workspace)
- [Transition to Logging](#transition-to-logging)

## Virtual Machine Metrics Capture

### Overview
Cloud Monitoring captures metrics from virtual machines in Compute Engine. The process requires installing the Ops agent, configuring appropriate Google Cloud service accounts with specific IAM roles, and ensuring access to Google Cloud services. Metrics such as CPU, memory, and disk utilization are transmitted to Cloud Monitoring for visualization and alerting.

### Key Concepts / Deep Dive
Virtual machines (VMs) need a service account attached to them with the roles:
- `roles/monitoring.metricWriter`
- `roles/logging.logWriter`

For Compute Engine instances, the default service account often includes broader permissions. The Ops agent must be installed and configured to collect metrics. Subnet networks should support private Google access for metrics transmission without an external IP address.

#### Lab Demos
> [!NOTE]
> Demonstration of creating a VM with internal IP and Ops agent.

1. Create a VM instance with:
   - Service account assigned
   - Ops agent pre-installed (via startup script or manual installation)
   - Internal IP only (using NAT for outbound traffic)

   ```bash
   gcloud compute instances create vm-with-ops-agent \
     --zone=us-central1-a \
     --machine-type=e2-micro \
     --network=your-subnet \
     --no-address \
     --metadata-from-file startup-script=install-ops-agent.sh \
     --service-account=your-service-account@your-project.iam.gserviceaccount.com \
     --scopes=https://www.googleapis.com/auth/cloud-platform
   ```

2. After VM creation, verify metrics in Cloud Monitoring observability section. CPU, memory, and disk metrics should appear within minutes.

   ```diff
   + Metrics transmission confirmed: CPU utilization ~30%, Memory used ~50%
   - Issue: If metrics fail to appear, check service account roles and subnet private access
   ```

### Advantages and Disadvantages
- Advantages: Comprehensive host-level metrics, supports custom agent-based monitoring.
- Disadvantages: Requires Ops agent installation and maintenance.

## Kubernetes Standard and Autopilot Clusters Metrics

### Overview
Kubernetes clusters (standard and Autopilot) in Google Kubernetes Engine (GKE) send metrics to Cloud Monitoring. Autopilot clusters integrate metrics automatically, while standard clusters may require specific service account roles. Clusters without proper roles or workloads may not immediately transmit metrics.

### Key Concepts / Deep Dive
For GKE standard mode:
- Use service account `GKE-SA` with roles: `roles/monitoring.metricWriter` and `roles/logging.logWriter`
- Alternatively, assign the combined role `roles/monitoring.viewer` (Kubernetes Engine default node service account role)

For Autopilot:
- Same roles apply, but metrics transmission occurs only with running workloads (e.g., PODs and nodes provisioned)

> [!IMPORTANT]
> Autopilot metrics depend on active resources; idle clusters without pods may delay or prevent initial metric capture.

#### Lab Demos
Create two GKE clusters in different regions for comparison:
1. One with service account (right roles): Metrics captured successfully.
2. One without roles: No metrics initially.

   ```bash
   gcloud container clusters create gke-with-roles \
     --region=us-central \
     --service-account=your-sa@project.iam.gserviceaccount.com \
     --cluster-version=latest \
     --machine-type=e2-standard-4 \
     --num-nodes=1
   ```

3. Deploy a workload (e.g., Nginx) to trigger metrics:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx-deployment
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: nginx
       template:
         metadata:
           labels:
             app: nginx
         spec:
           containers:
           - name: nginx
             image: nginx:latest
             ports:
             - containerPort: 80
   ```

   Apply and verify metrics in Monitoring after pod creation.

### Advantages and Disadvantages
- Advantages: Serverless Autopilot simplifies cluster management.
- Disadvantages: Autopilot requires active workloads for metric initialization; potential delays in metrics visibility.

## Third-Party Application Monitoring (Nginx)

### Overview
Cloud Monitoring can capture metrics from third-party tools like Nginx by configuring the Ops agent to poll application-specific endpoints (e.g., Nginx status).

### Key Concepts / Deep Dive
To monitor Nginx:
1. Enable Nginx status module.
2. Configure Ops agent with a receiver for Nginx metrics.

#### Lab Demos
> [!NOTE]
> Build on the previous VM setup with Nginx installed.

1. Enable Nginx status on port 80:

   ```bash
   sudo apt update && sudo apt install -y nginx
   sudo nano /etc/nginx/sites-available/default
   ```

   Add to the server block:

   ```nginx
   location /status {
       stub_status on;
       access_log off;
       allow 127.0.0.1;
       deny all;
   }
   ```

   Reload Nginx:

   ```bash
   sudo systemctl reload nginx
   ```

2. Configure Ops agent for Nginx:

   ```yaml
   # /etc/google-cloud-ops-agent/config.yaml
   metrics:
     receivers:
       nginx:
         type: nginx
         status_url: "http://localhost/status"
     processors:
       metrics_filter:
         type: include_metrics
         metrics:
           include: nginx.*
     service:
       pipelines:
         nginx_pipeline:
           receivers: [nginx]
           processors: [metrics_filter]
   ```

3. Restart Ops agent:

   ```bash
   sudo systemctl restart google-cloud-ops-agent
   ```

4. Verify in Metrics Explorer: `nginx.requests` should appear.

   ```diff
   + Successful: Nginx requests spiked to ~5000 per second under load
   - Issue: If Ops agent config fails, revert to basic VM metrics
   ! Alert: Restart agent if no metrics; check YAML syntax
   ```

### Advantages and Disadvantages
- Advantages: Extends monitoring to application-layer metrics.
- Disadvantages: Requires specific configurations; not all tools supported.

## Uptime Checks

### Overview
Uptime checks verify the availability of resources (VMs, load balancers, URLs) by sending periodic HTTP requests and alerting on failures.

### Key Concepts / Deep Dive
Supported protocols: HTTP, HTTPS, TCP. Checks from multiple global regions. Acceptable responses: 1xx-3xx; warnings for 4xx-5xx.

#### Lab Demos
Create uptime check for a VM's internal IP:
1. In Cloud Monitoring → Uptime Checks → Create.
2. Protocol: HTTP, Host: internal IP, Path: `/`, Port: 80.
3. Frequency: Every minute, Timeout: 10s.
4. Notifications: Attach notification channels.

   ```diff
   + Debugging: Firewall rules must allow health check IPs (download ranges from Google)
   - Issue: Internal IPs require specific IP whitelisting or service directory setup
   ```

### Advantages and Disadvantages
- Advantages: Proactive availability monitoring.
- Disadvantages: Requires open firewall rules; internal IPs need extra configuration.

## Alerting Policies

### Overview
Alerting policies define conditions (e.g., CPU > 75%) that trigger notifications when violated, enabling automated responses.

### Key Concepts / Deep Dive
Policies use condition-based thresholds or MQL. Rolling windows (e.g., 5 minutes, function: mean). Auto-recovery on resolution.

#### Lab Demos
1. CPU Utilization Alert:
   - Metric: CPU utilization
   - Condition: Rolling window 5min, mean > 15%
   - Channel: Email + PubSub

2. EngineX Requests Alert:
   - Metric: `nginx.requests`
   - Condition: Delta over 5min > 100
   - (Note: MQL tuning may be needed for accuracy)

   ```mermaid
   flowchart TD
       A[Metric Violates Threshold] --> B[Alert Fired to Channels]
       B --> C[Incident Opened]
       C --> D[Acknowledge/Auto Resolve]
       D --> E[Send Recovery Notification]
   ```

### Advantages and Disadvantages
- Advantages: Customizable thresholds; integrates with autoscaling.
- Disadvantages: Requires tuning; false positives possible.

## Notification Channels

### Overview
Channels deliver alerts via email, PubSub, Slack, PagerDuty, etc. Google's recommendation: Use multiple channels for reliability.

### Key Concepts / Deep Dive
Email common but unreliable; PubSub ideal for integrations (e.g., ticketing systems). Service accounts may need specific roles (e.g., `roles/pubsub.publisher`).

#### Lab Demos
Setup PubSub for alerts:
1. Create PubSub topic and subscription.
2. Add notification channel in Monitoring with service account.
3. Test: Trigger alert to verify message in subscription.

   ```bash
   gcloud pubsub pull YOUR-SUBSCRIPTION --auto-ack
   ```

### Advantages and Disadvantages
- Advantages: Flexible delivery options.
- Disadvantages: Email may be ignored; setup complexity for advanced channels.

## Dashboards and Charts

### Overview
Dashboards visualize metrics via charts and graphs, created from Metrics Explorer by saving as charts.

### Key Concepts / Deep Dive
Charts can include alerts. Public previews for stakeholders.

#### Lab Demos
- Save Nginx metrics as chart in dashboard "Cloud Architect".
- Visualize CPU vs. requests.

### Advantages and Disadvantages
- Advantages: Real-time visualization.
- Disadvantages: UI-dependent; no CLI equivalent for some features.

## Scoping Projects (Workspace)

### Overview
Scoping projects centralize monitoring across multiple projects or cloud providers (e.g., AWS resources).

### Key Concepts / Deep Dive
Add monitored projects/resources. Metrics ingested in scoped project; billing per original project. Supports AWS via agents.

#### Lab Demos
In Monitoring Settings → Metrics Scope → Add monitored projects (e.g., AWS/EC2 metrics).

### Advantages and Disadvantages
- Advantages: Unified view across environments.
- Disadvantages: Billing context remains with source projects.

## Transition to Logging

### Overview
Cloud Logging captures and analyzes logs (e.g., audit trails) for historical analysis. Integrates with Cloud Monitoring for comprehensive observability.

### Key Concepts / Deep Dive
Log Explorer queries events. Centralized via log routers. Retains data for audits.

### Advantages and Disadvantages
- Advantages: Immutable audit trails.
- Disadvantages: Storage costs for high volumes.

## Summary

### Key Takeaways

```diff
+ Metrics capture requires service accounts with specific roles: Compute Engine and GKE need monitoring.metricWriter and logging.logWriter
+ Ops agent enables custom metrics: Configure receivers for applications like Nginx via YAML
+ Alerting on thresholds: Use rolling windows and multiple channels to avoid missed notifications
+ Uptime checks: Whitelist IP ranges for firewalls; supports internal/private resources
- Autopilot GKE metrics: Delayed without active workloads
! Workspace/scoping: Centralizes multi-project/cloud monitoring without changing billing
```

### Quick Reference
- **Ops Agent Config (Nginx)**:
  ```yaml
  metrics:
    receivers:
      nginx:
        type: nginx
        status_url: "http://localhost/status"
  ```

- **Firewall for Uptime Checks**: Download IP ranges from Monitoring; apply via Terraform or gcloud.

- **PubSub Setup**: Create topic/subscription; assign `roles/pubsub.publisher` to service account.

### Expert Insight

#### Real-World Application
In production, use scoping projects for large organizations with multiple GCP/AWS projects to achieve centralized monitoring. Integrate PubSub with ticketing tools (e.g., Jira via webhooks) for automated incident management.

#### Expert Path
Master MQL for complex queries and custom metric derivations. Experiment with log-based metrics for anomaly detection beyond traditional thresholding.

#### Common Pitfalls
- **Missed Emails**: Always pair with secondary channels; email servers can fail or be filtered.
- **Ops Agent Misconfig**: Test YAML syntax; restart agent often required after changes.
- **Autopilot Delays**: Pre-deploy placeholder workloads to initialize metrics.

#### Lesser-Known Facts
- Monitoring supports AWS resources natively via agents; no additional GCP resources needed beyond the scoped project.
- Free tier: 150 MB/month per project; costs scale with ingested data volume.
