# Section 20: Ingress Internal ALB

<details open>
<summary><b>Section 20: Ingress Internal ALB (G3PCS46)</b></summary>

## Table of Contents
- [20.1 Step-01- Introduction to Ingress Internal ALB](#201-step-01--introduction-to-ingress-internal-alb)
- [20.2 Step-02- Create Internal ALB using Ingress and Test and Clean-Up](#202-step-02--create-internal-alb-using-ingress-and-test-and-clean-up)
- [Summary](#summary)

## 20.1 Step-01- Introduction to Ingress Internal ALB

### Overview
This lesson introduces creating an internal Application Load Balancer (ALB) using Kubernetes Ingress manifests. It explains switching from internet-facing to internal ALB by using the `scheme` annotation as `internal`, and outlines testing methods since the internal LB cannot be accessed directly from the internet. A curl pod will be deployed within the EKS cluster to perform connectivity tests.

### Key Concepts/Deep Dive

#### Internal vs. Internet-Facing ALBs in Kubernetes Ingress
- **Internet-Facing ALB**: Uses `scheme: internet-facing` annotation to create a load balancer accessible from the public internet. This is suitable for external traffic routing.
- **Internal ALB**: Uses `scheme: internal` annotation to deploy the ALB within private network subnets. It is not reachable from the internet, ideal for internal cluster communication or private services.

![ALB Scheme Comparison](https://mermaid.ink/svg/pako:eNqdUkFu2zAQ_RVCJ7C0cEJCqGCjFGiKQKQUKhAYTQhRFDcMYcLOJQm35M22CzGtKYVcV3vI5kZM3SO777vjv7PfzUU5AjBI9gliKUWLJBJKEqEUaOkNOJKNAjWIuWcyrpSnNaNRTrEAi0wPYTxMkLpOzZLuYlHRZ7x0wSu12VNgpNkPkXWea7Irt9OzMQk1LBtdIyuKY1yjp9ozylfTFMBmmkYJ6xizEbQXwAMS0CC-BMaqbbQNHHQLMHOQJibOHEDD6J02ZvZKPzT8JXmU6fhe2IWe8Ej2kJQnGIwbKVXaSqMKu2LMVwdBUEwfs3hfbqt-4NmQ9nqgT22i-iv1j80yLAmmpEb1lnj8qMqFX5P3zNyfQ3rLtbL5G_jLjYa_kDhN5 sacsTaG84FCr4RUgVpdKLHWbVRkw

#### Testing Internal ALBs
- Direct access from the internet is not possible for internal ALBs.
- Deploy a temporary `curl` pod within the EKS cluster to test connectivity.
- Connect to the curl pod using `kubectl exec` and run curl commands against the internal LB DNS endpoint.

> [!NOTE]  
> The internal ALB DNS name will be in the private IP range (e.g., 10.0.0.0/8 or 172.16.0.0/12), not public subnets.

#### Cluster Access Requirements
- Ensure outbound internet access is available via NAT Gateway for private subnets to download images or run curl for external checks.
- The EKS cluster must be in a VPC with proper security groups and route tables for internal LB access.

### Lab Demo: Overview of Commands
This section outlines preparatory commands for testing. Practical implementation is covered in the next lesson.

- Deploy curl pod:
  ```bash
  kubectl apply -f kube-manifest-curl/
  ```
- Connect to curl pod:
  ```bash
  kubectl exec -it <curl-pod-name> -- sh
  ```
- Test endpoints from curl pod:
  ```bash
  curl <internal-alb-dns>
  curl <internal-alb-dns>/app1/index.html
  curl <internal-alb-dns>/app2/index.html
  ```

> [!WARNING]  
> Ensure the curl pod image is available and the cluster has network policies allowing pod-to-service communication if applicable.

## 20.2 Step-02- Create Internal ALB using Ingress and Test and Clean-Up

### Overview
This practical lesson demonstrates creating an internal ALB using Ingress manifests, deploying curl pod for testing, running curl commands to verify routing, and performing cleanup. It builds on the previous introduction by implementing context-based routing without SSL, using NodePort services and health check settings.

### Key Concepts/Deep Dive

#### Ingress Manifest for Internal ALB
- The Ingress resource name is `ingress-internal-lb-demo`.
- Enable internal scheme by adding annotation: `scheme: internal`.
- Use default listener on port 80; no SSL configurations are needed for this basic setup.
- Routing rules: Context path `/app1` routes to `app1-nginx-service`, `/app2` to `app2-nginx-service`, default to `app3-nginx-service`.
- Health checks are configured automatically for NodePort services, registering all worker nodes as targets.

```yaml:ingress-internal-lb.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-internal-lb-demo
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internal  # Corrected from 'scheme' repeated; this creates internal ALB
    alb.ingress.kubernetes.io/healthcheck-path: /  # Basic health check
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app3-nginx-service
            port:
              number: 80
      - path: /app1
        pathType: Prefix
        backend:
          service:
            name: app1-nginx-service
            port:
              number: 80
      - path: /app2
        pathType: Prefix
        backend:
          service:
            name: app2-nginx-service
            port:
              number: 80
```

> [!IMPORTANT]  
> The ALB name appends `-internal` automatically (e.g., `ingress-internal-lb-internal`). Target groups use instance mode with NodePort, ensuring worker nodes are registered and healthy.

#### Curl Pod Deployment
- Separate manifest for curl pod: Simple Pod spec running a curl-compatible image (e.g., cURL Alpine).
- Grants shell access for testing without risking cluster security.

```yaml:curl-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: curl-pod
spec:
  containers:
  - image: iflya/curl
    name: curl
  restartPolicy: OnFailure
```

#### Testing Sequence
1. **Deploy Applications**: Deploy apps 1, 2, 3 with NodePort services.
2. **Verify Resources**: Check pods, services, and ingress creation.
3. **Inspect ALB**: Confirm internal scheme, port 80 rules, and private DNS.
4. **Test with Curl Pod**: Connect to pod and curl endpoints.

### Lab Demo: Full Implementation Steps

#### Step 1: Deploy Manifests
```bash
kubectl apply -f kube-manifest/
```
- Creates 3 deployments (app1-nginx, app2-nginx, app3-nginx) and NodePort services.
- Deploys ingress with internal ALB.

Verify with:
```bash
kubectl get pods
kubectl get svc
kubectl get ingress
```
- Expected: Pods running, services with NodePorts, ingress showing internal ALB address.

#### Step 2: Inspect AWS Console
- Navigate to Load Balancers; find `ingress-internal-lb-internal` in private subnets.
- Check listeners: Port 80 with routing rules for `/app1` → app1 target group, etc.
- DNS: Internal format (e.g., `internal-ingress-internal-lb-12345678.us-east-1.elb.amazonaws.com` – sample).

#### Step 3: Deploy and Access Curl Pod
```bash
kubectl apply -f kube-manifest-curl/
kubectl exec -it curl-pod -- sh
```

Inside pod:
```bash
curl <internal-alb-dns>  # Returns app3 default backend (Kubernetes Fundamentals Demo)
curl <internal-alb-dns>/app1/index.html  # Returns app1 page
curl <internal-alb-dns>/app2/index.html  # Returns app2 page
```
- Confirm successful routing; test outbound (e.g., `curl google.com`) to verify NAT Gateway.

#### Step 4: Clean-Up
Remove all resources:
```bash
kubectl delete -f kube-manifest/
kubectl delete -f kube-manifest-curl/
```

> [!TIP]  
> Monitor target groups in AWS to ensure all worker nodes are healthy via NodePort services. If tests fail, check security groups for internal traffic allow rules.

## Summary

### Key Takeaways
```diff
+ Internal ALBs are essential for service isolation, routing traffic within private subnets without internet exposure.
+ Use `scheme: internal` annotation in Ingress to create private load balancers.
- Avoid testing internal ALBs directly from external clients; always use cluster-internal pods like curl for verification.
! NodePort services simplify ALB target registration by auto-registering worker nodes as instances.
+ Clean-up is critical to avoid hitting AWS resource limits and unnecessary costs.
```

### Quick Reference
- **Create Internal Ingress**: Apply manifest with `scheme: internal`.
- **Test Command**: `kubectl exec -it curl-pod -- sh` then `curl <internal-dns>/path`.
- **Verify ALB**: Check AWS console for private subnets and port 80 rules.
- **Corrections Noted**: "scheme,scheme" corrected to single "scheme"; "cube CTL" to "kubectl"; transcript path "0-8-14" likely "08-14" per context.

### Expert Insight

#### Real-World Application
In production, internal ALBs enable secure internal API routing for microservices in EKS, reducing external surface area. Pair with CloudWatch metrics for monitoring health and autoscaling policies for target groups.

#### Expert Path
Master annotations like `alb.ingress.kubernetes.io/group.name` for shared ALBs across multiple namespaces. Experiment with adding SSL secrets for internal HTTPS, and use tools like `kubectl logs` and `aws logs` for debugging routing issues.

#### Common Pitfalls
- Forgetting to deploy in private subnets leads to creation failures.
- Assuming internal ALBs are accessible externally causes troubleshooting delays.
- Ignoring security groups can block pod-to-ALB communication within the cluster.
- Failing to clean-up curl pods accumulates resource waste.

</details>
