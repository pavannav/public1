<details open>
<summary><b>Kubernetes Best Practices - Sr. Cloud DevOps Interview (KK-CS45-script-v2-Interview)</b></summary>

# Kubernetes Best Practices - Study Guide
**Session:** Kubernetes Best Practices - Sr. Cloud DevOps Interview  
**Source:** ytb-TechWithAjit-Interview-QnA  
**Model:** KK-CS45-script-v2-Interview

---

## Q1: What are some Kubernetes best practices (not specific to EKS or AWS)?

**Answer Provided:**
- Set **resource requests and limits** on pods to control CPU and memory usage
- Use **Secrets and ConfigMaps** instead of hardcoding configuration or environment variables
- Implement **monitoring** using CloudWatch (or Prometheus/Grafana for custom metrics)
- Configure **alerts** for resource usage thresholds (e.g., nodes >80% usage)
- Apply **RBAC and IAM Roles for Service Accounts (IRSA)** for granular access control

**Validation Note:**
The answer is correct and comprehensive. Suggested additions for completeness:
- Use **namespaces** to isolate workloads
- Implement **network policies** for pod-to-pod communication security
- Follow **immutable infrastructure** principles with declarative manifests
- Use **liveness and readiness probes** for proper health checking
- Apply the **principle of least privilege** consistently across all resources

---

## Summary of Best Practices Covered

| Category | Practice | Purpose |
|----------|----------|---------|
| **Resource Management** | Requests & Limits | Prevent resource starvation and ensure fair scheduling |
| **Configuration** | Secrets & ConfigMaps | Externalize sensitive data and configuration |
| **Observability** | Monitoring (Prometheus/Grafana) | Track metrics and system health |
| **Alerting** | Threshold-based alerts | Proactive incident response |
| **Security** | RBAC + IRSA | Granular, least-privilege access control |

---

</details>