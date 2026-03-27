# Section 31: CloudWatch Container Insights 

<details open>
<summary><b>Section 31: CloudWatch Container Insights (G3PCS46)</b></summary>

## Table of Contents
- [Step-01- CloudWatch Container Insights - Introduction](#step-01--cloudwatch-container-insights---introduction)
- [Step-02- Install Container Insights as Daemonsets on EKS Cluster](#step-02--install-container-insights-as-daemonsets-on-eks-cluster)
- [Step-03- Deploy Sample App, Load Test and Verify Container Insights Dashboard](#step-03--deploy-sample-app-load-test-and-verify-container-insights-dashboard)
- [Step-04- CloudWatch Log Insights in Depth](#step-04--cloudwatch-log-insights-in-depth)
- [Step-05- CloudWatch Alarms for Container Insights Metrics](#step-05--cloudwatch-alarms-for-container-insights-metrics)

## Step-01- CloudWatch Container Insights - Introduction

### Overview
CloudWatch Container Insights provides comprehensive observability for containerized applications on EKS clusters by collecting, aggregating, and summarizing metrics and logs. It leverages fully managed services for monitoring, troubleshooting, and alerting across CPU, memory, disk, and network resources. Key features include diagnostic information on container restarts and failures, automated dashboards, and integration with CloudWatch Log Insights for in-depth analysis.

### Key Concepts

**Core Components:**
- **FluentD DaemonSet**: Deploys one pod per worker node to collect application logs, Kubernetes cluster logs, and performance logs. These logs are pushed to CloudWatch for analysis using Log Insights.
- **CloudWatch Agent DaemonSet**: Deploys one pod per worker node to gather metrics like CPU, memory, network, and disk from pods, nodes, and services. It provides 134 types of metrics with detailed dimensions.
- **Metrics and Logs**: Captures utilization data and diagnostic info, enabling quick issue isolation and resolution through CloudWatch alarms.

**Benefits and Features:**
- **Container Map**: Visual representation of all Kubernetes objects (pods, services, nodes) across namespaces, offering a complete view of the cluster topology.
- **Resource View**: Lists all container resources, switchable between map and list views for detailed monitoring.
- **Performance Dashboard**: Displays automatic dashboards via CloudWatch for metrics like CPU, memory, and network, including pod-level details such as usage over limits.
- **Log Groups and Insights**: Four default log groups (/aws/containerinsights/[cluster]/application, /aws/containerinsights/[cluster]/dataplane, /aws/containerinsights/[cluster]/host, /aws/containerinsights/[cluster]/performance) for querying logs and creating custom dashboards or alerts.
- **Alarms Integration**: Sets CloudWatch alarms on metrics, potentially triggering autoscaling actions like adding nodes when thresholds are exceeded (e.g., 80% CPU on worker nodes).
- **Prometheus Support**: Recent beta feature for integrating Prometheus metrics from EKS clusters into Container Insights dashboards.

### Lab Demos
No specific hands-on steps in this introductory section, but references future deployment of FluentD and CloudWatch Agent as DaemonSets on EKS.

## Step-02- Install Container Insights as Daemonsets on EKS Cluster

### Overview
Installing Container Insights involves associating the CloudWatch agent server policy with EKS worker node IAM roles and deploying the quick-start manifest. This sets up DaemonSets for FluentD (log collection) and CloudWatch Agent (metrics collection), ensuring per-node pods for comprehensive monitoring. The process uses AWS-provided YAML templates with cluster-specific parameters.

### Key Concepts

**Prerequisites:**
- **IAM Policy Attachment**: Attach the `CloudWatchAgentServerPolicy` to the EKS worker node IAM role (e.g., via EC2 console or AWS CLI). This grants permissions for worker nodes to send metrics and logs to CloudWatch.

**Installation Process:**
- **Quick-Start Template**: Deploy a Kubernetes manifest (e.g., `CWAgent-QuickStart.yaml`) via `kubectl apply`. This template:
  - Creates namespace: `amazon-cloudwatch`.
  - Sets up ServiceAccounts, ClusterRoles, ClusterRoleBindings for secure access.
  - Configures ConfigMaps for agent settings.
  - Deploys DaemonSets for:
    - CloudWatch Agent: Collects metrics (134 types) from cluster, nodes, pods, services.
    - FluentD: Aggregates logs for application, dataplane, host, and performance.

**Parameters:**
- `{{cluster_name}}`: E.g., `eks-demo-1`.
- `{{region_name}}`: E.g., `us-east-1`.

**Verification:**
- Run `kubectl get daemonsets --namespace amazon-cloudwatch` to confirm two ready pods per DaemonSet (matching worker node count, e.g., 2 for a 2-node cluster).
- DaemonSets ensure one pod per node for both FluentD and CloudWatch Agent.

### Lab Demos
1. Attach CloudWatchAgentServerPolicy to worker node IAM role via AWS Console or CLI.
2. Deploy the quick-start manifest:
   ```
   kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart.yaml
   ```
   - Substitute placeholders for cluster name and region.
3. Verify DaemonSets and pods: `kubectl get ds -n amazon-cloudwatch` (expect 2/2 ready).

## Step-03- Deploy Sample App, Load Test and Verify Container Insights Dashboard

### Overview
Deploy a sample NGINX app with resource limits, generate load using Apache Bench, and verify metrics via CloudWatch Container Insights dashboard. This demonstrates resource utilization monitoring, including CPU over-limits for pods, in automatic dashboards.

### Key Concepts

**Application Deployment:**
- **Sample App Manifest**: Deploys NGINX (v1.21.3) with requests/limits (e.g., CPU: 100m/200m, Memory: 128Mi/256Mi) via ClusterIP service.
- Resources monitored: CPU, memory, network for pods and nodes.

**Load Testing:**
- **Apache Bench Pod**: Temporary pod running `httpd:alpine` image to generate requests (e.g., 1000 concurrent requests to sample-nginx-service.default.svc.cluster.local).
- Load induces high CPU usage, simulating over-limit scenarios.

**Dashboard Verification:**
- **Container Insights Console**:
  - **Container Map**: Visualize cluster topology (namespaces, services, pods, e.g., default namespace with `sample-nginx-deployment` and `sample-nginx-service`).
  - **Performance Dashboard**: Shows cluster/node metrics (CPU: 7%, Memory: 16.6%, Disk: 14%, Nodes: 2).
  - **Namespace/Pod Details**: Per-namespace CPU/memory, over-limit notifications (e.g., pod CPU 71.9% over 100m limit).
  - **Log Insights Access**: From pod menu > Application Logs/Performance Logs to explore logs via CloudWatch Log Insights.
  - **Traces (if enabled)**: Links to X-Ray for application traces.
- Metrics include pod restarts, failures, and resource utilizations.

### Lab Demos
1. Deploy sample NGINX app: `kubectl apply -f <sample-nginx-app-manifest.yaml>`.
2. Generate load: `kubectl run apache-bench --image=httpd:alpine --rm -it -- ab -n 1000 -c 10 http://sample-nginx-service.default.svc.cluster.local/`.
3. Access CloudWatch > Container Insights:
   - View Container Map for cluster structure.
   - Check Performance Dashboard for metrics and over-limits.
   - Explore Log Insights for application/performance logs.
4. Note over-limit alerts (e.g., CPU usage exceeding pod requests).

## Step-04- CloudWatch Log Insights in Depth

### Overview
CloudWatch Log Insights enables deep querying of Container Insights logs across four log groups (application, dataplane, host, performance). Create custom dashboards by running queries, filtering fields, and visualizing results as charts or tables for monitoring EKS metrics.

### Key Concepts

**Log Groups:**
- **Application**: Pod/service logs (e.g., container access logs).
- **Dataplane**: Control plane logs.
- **Host**: Worker node logs.
- **Performance**: Resource utilization logs (e.g., CPU, memory, fs usage).

**Querying and Visualization:**
- **Syntax**: Use stats, fields, filters (e.g., `stats avg(NodeCpuUtilization) as avg_node_cpu by NodeName | sort avg_node_cpu desc` for performance logs).
- **Fields**: Discovered fields like timestamp, container name, message; wrap with `fields` command.
- **Examples**:
  - Node CPU avg by node name.
  - Container restarts by pod.
  - CPU usage by container.
  - Pods requested vs. running.
  - Application errors by container.
- **Dashboards**: Save queries as widgets (bar, line, table) to custom dashboards (e.g., "EKS Performance") for continuous monitoring.

**Benefits:**
- Custom metrics from logs (e.g., error rates, restarts) integrated into dashboards.
- Time-based filtering (last 1hr, 3hr, custom) for historical analysis.

### Lab Demos
1. Access CloudWatch > Logs > Insights.
2. Select log group (e.g., performance).
3. Run queries (e.g., node CPU):
   ```
   stats avg(NodeCpuUtilization) as avg_node_cpu by NodeName | sort avg_node_cpu desc
   ```
4. Add to dashboard as bar/line chart.
5. Repeat for other metrics (e.g., restarts: `stats sum(numberOfContainerRestarts) as total_restarts by PodName`).
6. Explore fields for application logs to filter by container errors.

## Step-05- CloudWatch Alarms for Container Insights Metrics

### Overview
Configure CloudWatch alarms on Container Insights metrics for proactive monitoring and alerting. Alarms trigger notifications or actions (e.g., autoscaling) based on custom thresholds, using SNS for email alerts. Demonstrate with a node CPU alarm triggered by simulated load.

### Key Concepts

**Custom Namespaces and Metrics:**
- **Container Insights Metrics**: Over 134 metrics in custom namespace (no AWS/EC2 standard). Dimensions: cluster, node, pod, service, namespace.
- **Important Metrics**: Node CPU utilization, pod CPU over limit, container restarts, pod CPU utilization over limits, node failures.

**Alarm Configuration:**
- **Thresholds**: Static/GreaterThan (e.g., CPU > 4% for demo; realistic: 80-90%).
- **Period**: 1-5 minutes (e.g., 1min for quick response).
- **Conditions**: 1 of 1 data points triggers alarm.
- **Actions**: SNS notifications (new topic/email; subscribe/confirm via email).
- **Optional**: Autoscaling actions if ASG configured.

**Demonstration:**
- Create alarm on node CPU utilization for EKS cluster.
- Simulate load to trigger alarm state change.

**Cleanup:**
- Delete Container Insights: `kubectl delete -f <quickstart-template>` with cluster/region.
- Remove sample app: `kubectl delete -f <kube-manifests>`.

> [!IMPORTANT]
> Alarms enable automated responses like scaling worker nodes, reducing downtime during high utilization.

### Lab Demos
1. CloudWatch > Alarms > Create Alarm.
2. Select metric: ContainerInsights (NodeCpuUtilization for cluster/node).
3. Set threshold (e.g., >4% CPU), period (1min), 1/1 data points.
4. Configure SNS: Create topic "EKS Alerts", add email (confirm subscription).
5. Name alarm "EKS Node CPU Alert", add to dashboard.
6. Trigger: Run load (e.g., Apache Bench); monitor alarm state to "ALARM".
7. Note email notification on threshold breach.
8. Extend to other metrics (e.g., pod restarts >0).

## Summary

### Key Takeaways
```diff
+ Container Insights provides end-to-end observability for EKS clusters via metrics (134 types) and logs (4 groups) from DaemonSets.
+ Automated dashboards visualize cluster maps, performance data, and resource utilization, including over-limits.
+ Log Insights enables custom queries for troubleshooting, error analysis, and dashboard creation.
+ Alarms integrate with SNS for alerts and autoscaling actions on metrics breaches.
- Common pitfalls include forgetting IAM policy attachment or mismanaged thresholds leading to false alerts.
! Ensure DaemonSets are healthy (1 pod/node) for accurate data collection; misconfigurations may result in data gaps.
```

### Quick Reference
- **Install Command**: `kubectl apply -f https://<url>/quickstart.yaml` (replace cluster/region).
- **Verify DaemonSets**: `kubectl get ds -n amazon-cloudwatch`.
- **Sample Load Test**: `kubectl run apache-bench --image=httpd:alpine -- ab -n 1000 http://<service-url>`.
- **Log Query Example**: `stats avg(NodeCpuUtilization) by NodeName`.
- **Alarm Metric Lookup**: ContainerInsights namespace, NodeCpuUtilization dimension.

### Expert Insight

**Real-world Application**:
- Deploy Container Insights on production EKS clusters to monitor microservices, detect anomalies (e.g., pod crashes via container restarts metric), and auto-scale nodes during traffic spikes. Integrate with CI/CD for log-based alerting on deployment failures.

**Expert Path**:
- Master query optimization in Log Insights: Combine filters, aggregate by dimensions, and schedule queries for proactive monitoring. Experiment with Prometheus beta for advanced metrics beyond default scrapers.

**Common Pitfalls**:
- Overlooking IAM roles can prevent metric ingestion; always verify CloudWatchAgentServerPolicy attachment.
- High-frequency alarms (e.g., 1min checks) may increase costs; balance with actual monitoring needs.
- Ignoring log retention limits CloudWatch log groups; set retention policies to avoid data loss.

</details>
