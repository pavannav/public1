# Top 10 AWS EKS Scenario-Based Interview Questions & Answers | Master Kubernetes on AWS | Interview

## How to migrate a legacy application to EKS (with stateful components)

**Question:** Your team wants to migrate a legacy application to EKS. The application isn't containerized and has stateful components. How would you handle this migration to EKS?

**Answer:**
1. **Break down the legacy application** and identify components that need containerization
2. **Containerize the application** while addressing stateful components
3. **Use Kubernetes Persistent Volumes (PV) and Persistent Volume Claims (PVC)** to manage storage needs in the EKS cluster
4. **Utilize EBS volumes** for persistent storage to maintain application data
5. **Configure Storage Classes** for dynamic storage management

**Key Steps:**
- Containerize the application components
- Implement PV/PVC for stateful data persistence
- Use EBS as the underlying storage mechanism
- Set up appropriate storage classes for automation

**Note:** The approach is fundamentally correct. However, for production migrations, consider using AWS Database Migration Service (DMS) for database components and ensure proper backup strategies before migration. Additionally, evaluate using AWS App Mesh or service mesh for inter-service communication during migration.

## How to manage multiple EKS clusters

**Question:** You're running multiple EKS clusters for different environments (Dev, Stage, Production) and need a way to manage them effectively. How would you set this up?

**Answer:**
1. **Implement AWS IAM Roles for Service Accounts (IRSA)** to manage access control separately for each environment
2. **Use kubectl config or eksctl** to manage clusters individually with separate context profiles
3. **Leverage Kubernetes Cluster Federation** for centralized multi-cluster management
4. **Implement Argo CD** for GitOps-based deployment across clusters

**Key Tools:**
- IRSA for environment-specific access control
- kubectl/eksctl for cluster management
- Federation tools for centralized control of configurations, policies, and monitoring

**Note:** This is a solid approach. Consider using AWS Control Tower with Organizations for enterprise-wide cluster governance. For advanced multi-cluster management, also consider using Crossplane or Rancher. Cluster Federation is being deprecated in favor of KubeFed or other federation solutions.

## Failed requests and errors (troubleshooting)

**Question:** Your application on EKS is experiencing a high number of failed requests and errors. What steps would you take to troubleshoot this?

**Answer:**
1. **Check Kubernetes pod logs** using `kubectl logs` for application errors
2. **Use CloudWatch Logs** for detailed log information and analysis
3. **Verify resource limits and requests** for CPU and memory in pod configurations
4. **Check node health** using `kubectl get nodes` command
5. **Monitor with Prometheus and Grafana** for performance metrics and bottleneck identification

**Troubleshooting Flow:**
```bash
# Check pod logs
kubectl logs <pod-name> -n <namespace>

# Verify resource configuration
kubectl describe pod <pod-name> -n <namespace>

# Check node status
kubectl get nodes
kubectl describe node <node-name>
```

**Note:** Excellent troubleshooting approach. Additionally, consider implementing distributed tracing with AWS X-Ray and checking Network Policies that might be blocking traffic. Always start with application-level logs before moving to infrastructure issues.

## Low latency access to RDS (different VPC)

**Question:** Your EKS application requires low latency access to an RDS database in a different VPC. How would you set this up?

**Answer:**
1. **Set up VPC Peering** between the VPCs where EKS cluster and RDS are running
2. **Alternatively, use AWS Transit Gateway** if both VPCs are in the same region for scalable connections
3. **Configure Security Groups** to allow traffic from EKS nodes to RDS instance and vice versa
4. **Ensure proper routing** is configured between the VPCs

**Implementation Steps:**
- Establish network connectivity (VPC peering or Transit Gateway)
- Configure security groups for traffic flow
- Test connectivity and latency
- Monitor connection health

**Note:** For even lower latency in production environments, consider placing EKS and RDS in the same VPC when possible. Use AWS PrivateLink if you need private connectivity without VPC peering. Consider using Aurora Serverless or Aurora Global Database for multi-region scenarios.

## Autoscaling (CPU and memory based)

**Question:** You want to scale your application on EKS automatically based on CPU and memory usage. What would you do?

**Answer:**
1. **Implement Horizontal Pod Autoscaler (HPA)** to automatically adjust pod count based on CPU/memory usage
2. **Use Cluster Autoscaler** for cluster-wide scaling of nodes when pods can't be scheduled due to resource constraints
3. **Configure and monitor** both scaling mechanisms using AWS CloudWatch
4. **Set appropriate metrics targets** for scaling decisions

**Scaling Hierarchy:**
- **Pod-level:** HPA scales pods horizontally
- **Node-level:** Cluster Autoscaler scales EC2 instances
- **Monitoring:** CloudWatch for continuous observability

**Configuration Example:**
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

**Note:** This covers the core scaling needs. Consider using Kubernetes Metrics Server for HPA functionality. For advanced scenarios, use KEDA (Kubernetes Event-driven Autoscaling) for custom metrics. Always set resource requests and limits properly for effective autoscaling.

## Rolling Update (minimal downtime)

**Question:** You need to perform a rolling update on your EKS application but want to minimize downtime. How would you configure this?

**Answer:**
1. **Use Rolling Update deployment strategy** in Kubernetes
2. **Configure `maxSurge` and `maxUnavailable` parameters** to control update rate
3. **Ensure minimum pods remain available** during updates
4. **Define acceptable thresholds** for unavailable pods during transition

**Key Parameters:**
- `maxSurge`: Number of pods that can be created above the desired count
- `maxUnavailable`: Number of pods that can be unavailable during update

**Deployment Configuration:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    # pod template
```

**Note:** Correct approach for zero-downtime deployments. For blue-green deployments, consider using AWS CodeDeploy or progressive delivery tools like Flagger. Always test rolling updates in staging environments first. Consider using readiness probes to ensure new pods are ready before terminating old ones.

## Access Control (restrict to specific IP range)

**Question:** You need to restrict access to EKS cluster to a specific IP range. How would you set this up?

**Answer:**
1. **Configure EKS cluster Security Groups** to allow inbound traffic only from specific IP ranges
2. **Set public access CIDRs** in EKS API server settings to limit access
3. **Implement Kubernetes Network Policies** for granular traffic control within the cluster
4. **Use AWS WAF** for additional layer of access control if using Application Load Balancer

**Security Layers:**
- **Network Level:** Security Groups and CIDRs
- **Cluster Level:** Network Policies
- **Application Level:** Additional filtering as needed

**Note:** For enhanced security, consider using AWS PrivateLink to access EKS API server privately, and implement AWS Config Rules for compliance monitoring. Always use least-privilege access and implement audit logging.

## Cost tracking (usage by namespace)

**Question:** Your team needs to track detailed usage and costs for each namespace in the EKS cluster. What's your approach for this?

**Answer:**
1. **Implement AWS Cost Allocation Tags** for each namespace
2. **Use Kubernetes Resource Quotas** to set usage limits and track consumption
3. **Deploy monitoring solutions** like KubeCost, Prometheus, or Grafana
4. **Generate detailed cost and usage reports** based on namespace allocation

**Tools for Cost Monitoring:**
- AWS Cost Explorer with tags
- KubeCost for Kubernetes-native cost allocation
- Prometheus/Grafana for custom dashboards
- Resource Quotas for enforcement

**Sample Resource Quota:**
```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-resources
  namespace: my-namespace
spec:
  hard:
    requests.cpu: "1"
    requests.memory: 1Gi
    limits.cpu: "2"
    limits.memory: 2Gi
```

**Note:** Excellent approach for cost accountability. Consider using AWS Organizations and Cost Allocation Reports for enterprise-wide cost visibility. For detailed pod-level costing, implement AWS Container Insights and correlate with CloudWatch metrics.

## Troubleshooting (pod in crash loop backoff)

**Question:** You notice that a pod in your EKS cluster is in a CrashLoopBackOff state. What steps would you take to diagnose and fix the issue?

**Answer:**
1. **Check pod logs** using `kubectl logs <pod-name>` to identify crash causes
2. **Review deployment YAML** for misconfigurations in container setup
3. **Verify resource limits and requests** to ensure sufficient CPU/memory allocation
4. **Investigate container images** for faulty entrypoints or code issues
5. **Check events** using `kubectl describe pod <pod-name>` for additional diagnostic information

**Diagnostic Commands:**
```bash
# Get pod status
kubectl get pods -n <namespace>

# Detailed pod information
kubectl describe pod <pod-name> -n <namespace>

# Check pod logs
kubectl logs <pod-name> -n <namespace> --previous

# Check events
kubectl get events -n <namespace> --field-selector involvedObject.name=<pod-name>
```

**Note:** Comprehensive troubleshooting approach. Additionally, check if the pod is being restarted by liveness probes that might be misconfigured. Consider using `kubectl logs --previous` to see logs from previous container instance. Always check the pod's exit codes and consider implementing startup probes for slow-starting applications.

## CPU Throttling (resolution)

**Question:** Your EKS cluster is experiencing CPU throttling issues on certain workloads. How would you resolve this?

**Answer:**
1. **Increase CPU requests and limits** in deployment YAML for affected pods
2. **Monitor CPU usage** using CloudWatch and Prometheus to understand demand patterns
3. **Implement Node Autoscaler** to add more nodes when cluster resources are insufficient
4. **Optimize workload placement** by using node selectors or affinity rules

**Resolution Steps:**
- Adjust resource specifications in manifests
- Scale infrastructure automatically
- Monitor usage patterns for capacity planning
- Optimize scheduling policies

**Note:** Correct identification of the issue. Consider using CPU limits higher than requests to allow burst capacity when needed. For CPU-intensive workloads, consider using CPU management policies at the node level. Implement proper HPA configurations based on actual usage patterns rather than guesswork.

---

## Key Takeaways for EKS Interview Preparation

- **Migration:** Containerization + Persistent Storage (PV/PVC with EBS)
- **Multi-cluster:** IRSA + Federation tools (Cluster Federation/Argo CD)
- **Troubleshooting:** Logs → Resources → Nodes → Monitoring
- **Networking:** VPC peering/Transit Gateway + Security Groups
- **Scaling:** HPA (pods) + Cluster Autoscaler (nodes)
- **Updates:** Rolling updates with proper surge/unavailable settings
- **Security:** Security Groups + Network Policies + IP restrictions
- **Cost Management:** Cost Allocation Tags + Resource Quotas + Monitoring tools
- **Pod Issues:** Logs, configs, resources, image validation
- **Performance:** Resource tuning + monitoring + autoscaling

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
