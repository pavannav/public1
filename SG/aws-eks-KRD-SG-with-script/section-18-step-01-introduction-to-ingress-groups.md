# Section 18: Ingress Groups

<details open>
<summary><b>Section 18: Ingress Groups (G3PCS46)</b></summary>

## Table of Contents
- [18.1 Step-01- Introduction to Ingress Groups](#181-step-01--introduction-to-ingress-groups)
- [18.2 Step-02- Implement Ingress Groups Demo with 3 Apps](#182-step-02--implement-ingress-groups-demo-with-3-apps)
- [Summary](#summary)

## 18.1 Step-01- Introduction to Ingress Groups

### Overview
Ingress Groups allow you to group multiple Ingress resources together in Kubernetes, enabling you to manage configurations for multiple applications through a single Application Load Balancer (ALB) while keeping their rules segregated in separate files. This approach avoids the tedium of maintaining a single large Ingress manifest for numerous apps, such as 50 or 100 applications, by using annotations to merge rules into one ALB. It introduces concepts like group names, group order, and priorities to organize and prioritize routing rules effectively.

### Key Concepts/Deep Dive
Ingress Groups solve the challenges of scaling Kubernetes Ingress configurations in larger environments. Previously, without groups, all routing rules for multiple apps (e.g., app1, app2, app3) were defined in one Ingress resource, making updates cumbersome and error-prone.

#### Drawbacks of Single Ingress Resources
- **Maintenance Complexity**: For apps numbering in the tens or hundreds, editing a single Ingress manifest becomes tedious and prone to mistakes.
- **Confusion**: Rules for different apps are intermixed, making it hard to isolate changes.
- **Scalability Issues**: Adding or modifying rules for one app requires redeploying the entire Ingress, risking downtime for unaffected apps.

#### How Ingress Groups Work
Ingress Groups enable grouping multiple Ingress resources, allowing the AWS ALB controller to merge their rules into a single ALB.
- Each app gets its own Ingress resource with rules defined only for that app.
- Annotations group them together:
  - `group.name`: Specifies the group (e.g., `myapps.web`).
  - `group.order`: Defines priority/order (e.g., 10, 20, 30) for rule application in the ALB.
- Common configurations:
  - All Ingress resources share the same ALB name via annotations (e.g., `alb.ingress.kubernetes.io/load-balancer-name: ingress-groups-demo`).
  - Grouped resources are merged by the ALB controller, creating routing rules in priority order.

#### Annotations and Structure
Here’s a sample structure for Ingress Group annotations in an Ingress manifest:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-one-ingress
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/load-balancer-name: ingress-groups-demo
    alb.ingress.kubernetes.io/group.name: myapps.web
    alb.ingress.kubernetes.io/group.order: '10'
spec:
  rules:
  - http:
      paths:
      - path: /app-one
        pathType: Prefix
        backend:
          service:
            name: app-one-nginx
            port:
              number: 80
```

Key points:
- The `group.name` links Ingress resources to the same ALB group.
- The `group.order` (also called rule priority) determines rule precedence; lower numbers execute first.
- Separate folders for each app (e.g., `app-one/`, `app-two/`) contain dedicated Kubernetes manifests for Deployment, Service, and Ingress.
- This creates multiple Ingress resources (e.g., `app-one-ingress`, `app-two-ingress`) that merge into one ALB.

> [!NOTE]
> Annotations on one Ingress apply only to the paths defined in that specific Ingress resource.

#### Benefits
- **Simplified Management**: Each app's rules are isolated, reducing conflicts and improving readability.
- **Scalability**: Easily add or remove apps by managing separate files without affecting others.
- **Efficiency**: Merges rules into a single ALB, optimizing resource usage.

No major spelling mistakes were found in the transcript (e.g., "cubectl" was not present; references to "kubectl" appear correctly as "Cube CTL").

## 18.2 Step-02- Implement Ingress Groups Demo with 3 Apps

### Overview
This section provides a hands-on demonstration of implementing Ingress Groups with three sample applications (app-one, app-two, app-three) using the AWS ALB controller. We deploy separate Kubernetes manifests for each app, apply Ingress Group annotations to merge rules into one ALB, and verify functionality by accessing the applications via the load balancer. This builds directly on the introduction, showing practical segregation and merging of rules.

### Key Concepts/Deep Dive
Building on Ingress Groups, this demo emphasizes practical implementation. We use three apps: app-one, app-two, and app-three, each with their own Deployment, NodePort Service, and Ingress resource. Rules are segregated by app, and groups ensure a shared ALB.

#### Demo Structure
- **Folders**: `kube-manifest/app-one/`, `app-two/`, `app-three/`.
- **Per Folder**: `01-nginx-app-{one/two/three}-deployment.yaml`, `02-nginx-app-{one/two/three}-ingress.yaml`.
- **Shared ALB**: All Ingress resources reference `ingress-groups-demo` as the load balancer name.
- **Group Settings**:
  - `group.name: myapps.web`
  - `group.order`: 10 (app-one), 20 (app-two), 30 (app-three)
- This creates three Ingress resources merged into one ALB with prioritized rules.

#### Kubernetes Manifests Review
- **Deployments and Services**: Identical across apps; no changes from prior sections.
  ```yaml
  # Example: 01-nginx-app-one-deployment.yaml (similar for others)
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: app-one-nginx
  spec:
    replicas: 1
    selector:
      matchLabels:
        app: app-one-nginx
    template:
      metadata:
        labels:
          app: app-one-nginx
      spec:
        containers:
        - name: nginx
          image: stacksimplify/kube-nginxapp1:1.0.0
          ports:
          - containerPort: 80
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: app-one-nginx-nodeport-service
  spec:
    type: NodePort
    selector:
      app: app-one-nginx
    ports:
    - port: 80
      targetPort: 80
      nodePort: 31200  # Adjust as needed
  ```
- **Ingress For app-one** (`02-app-one-ingress.yaml`):
  - Name: `app-one-ingress`
  - ALB Name: `ingress-groups-demo`
  - Group: `myapps.web`, Order: 10
  - Rule: Path `/app-one` routes to `app-one-nginx-nodeport-service:80`
  ```yaml
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: app-one-ingress
    annotations:
      kubernetes.io/ingress.class: alb
      alb.ingress.kubernetes.io/load-balancer-name: ingress-groups-demo
      alb.ingress.kubernetes.io/group.name: myapps.web
      alb.ingress.kubernetes.io/group.order: '10'
      alb.ingress.kubernetes.io/target-type: instance
  spec:
    rules:
    - http:
        paths:
        - path: /app-one
          pathType: Prefix
          backend:
            service:
              name: app-one-nginx-nodeport-service
              port:
                number: 80
  ```
- **Ingress For app-two** (`02-app-two-ingress.yaml`):
  - Similar to app-one, but name: `app-two-ingress`, order: 20, path: `/app-two`, backend: `app-two-nginx-nodeport-service:80`
- **Ingress For app-three** (`02-app-three-ingress.yaml`):
  - Name: `app-three-ingress`, order: 30
  - Default backend: Routes to `app-three-nginx-nodeport-service:80` (no specific path rule)

#### Lab Demo: Deploy and Verify
1. **Deploy Resources**:
   - Navigate to `08-12-Ingress-Groups/kube-manifest/`.
   - Run: `kubectl apply -R -f kube-manifest/` (deploys subfolders recursively) or apply each folder sequentially: `kubectl apply -f app-one/`, etc.
   - This creates Deployments, Services, and three Ingress resources.

2. **Verify Resources**:
   - Check Deployments and Services: `kubectl get deployments` and `kubectl get svc` (app-one-nginx, etc., should be running).
   - Check Ingress: `kubectl get ingress` shows three resources with the same address (e.g., `ingress-groups-demo-16361047...`).

3. **Verify ALB**:
   - In AWS EC2 console, refresh Load Balancers; see one ALB: `ingress-groups-demo`.
   - Check status: Should go from "provisioning" to "active".
   - View Listeners > Rules: Rules with priorities (e.g., Rule 1: `/app-one` to app-one target group, Rule 2: `/app-two`, Default: app-three).

4. **Test Access**:
   - External DNS: `ingress-groups-demo-601.stacksimplify.com` (verify via DNS or browser).
   - Access URLs:
     - App-one: `https://ingress-groups-demo-601.stacksimplify.com/app-one` ✅ Returns app-one content.
     - App-two: `https://ingress-groups-demo-601.stacksimplify.com/app-two` ✅ Returns app-two content.
     - Default: `https://ingress-groups-demo-601.stacksimplify.com/` ✅ Returns app-three (Kubernetes Fundamentals v3.1).

5. **Cleanup**:
   - Run: `kubectl delete -R -f kube-manifest/`.
   - Verify: `kubectl get ingress` shows deletions; ALB and DNS entries should be removed.

> [!IMPORTANT]
> Ensure annotations are consistent across Ingress resources for the group to merge correctly.

No additional spelling corrections were needed; commands like "cube ctl" are contextual presentations of kubectl.

## Summary

### Key Takeaways
```diff
+ Ingress Groups simplify managing multiple apps with a shared ALB by segregating rules into separate files while merging via annotations.
+ Use group.name and group.order to prioritize and organize rules, avoiding single-file bottlenecks.
🚀 Real-world Application: In production, use Ingress Groups for microservices architectures on AWS, ensuring isolated config management and efficient load balancing.
💡 Expert Path: Master ALB annotations deeply, experiment with advanced features like conditions, and automate with Helm charts for scalable deployments.
⚠️ Common Pitfalls: Mismatched group names can prevent merging; forgetting target-type instance may cause connectivity issues. Always test rules post-deployment.
```

### Quick Reference
- **Apply Ingress Groups**: `kubectl apply -R -f kube-manifest/`
- **Check ALB Rules**: AWS Console > Load Balancers > Rules (priorities 10, 20, 30).
- **Access Demo**: `https://{alb-dns}/app-one`, `/app-two`, or `/` (default).

### Expert Insights
- **Real-world Application**: Ingress Groups are ideal for multi-tenant environments or shared platforms, allowing teams to manage app-specific Ingress without central file conflicts, while the ALB handles rule prioritization for high-traffic scenarios.
- **Expert Path**: Dive into AWK ALB docs for features like redirect actions, authentication, and integration with WAF. Certify expertise by building complex groups with 10+ apps.
- **Common Pitfalls**: Annotation typos (e.g., wrong order) break rules; ensure consistent ALB names to avoid duplicate load balancers. Monitor logs for rule conflicts.

</details>
