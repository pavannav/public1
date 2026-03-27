# Section 17: Introduction to Ingress SSL Discovery

<details open>
<summary><b>Section 17: Introduction to Ingress SSL Discovery (G3PCS46)</b></summary>

## Table of Contents
- [17.1 Step-01- Introduction to Ingress SSL Discovery](#171-step-01--introduction-to-ingress-ssl-discovery)
- [17.2 Step-02- Implement SSL Discovery Host Demo](#172-step-02--implement-ssl-discovery-host-demo)
- [17.3 Step-03- Implement SSL Discovery TLS Demo](#173-step-03--implement-ssl-discovery-tls-demo)
- [Summary](#summary)

## 17.1 Step-01- Introduction to Ingress SSL Discovery

### Overview
This subsection introduces SSL certificate discovery in Kubernetes Ingress, focusing on how certificates can be automatically associated with Application Load Balancers (ALBs) based on host names or TLS fields. It explains the benefits of avoiding manual certificate ARN specifications when using host-based routing and the alternative TLS field for other routing types. Key concepts include automatic discovery mechanisms and annotations for HTTPS listeners.

### Key Concepts/Deep Dive
SSL certificate discovery simplifies certificate management by leveraging DNS names from Ingress resources. There are two primary methods:

#### SSL Discovery Using Host
- **How it Works**: When using host-based routing (e.g., app101.stacksimplify.com and app201.stacksimplify.com), Ingress automatically discovers and associates certificates from AWS Certificate Manager (ACM) that match the domain names.
- **Benefits**: Eliminates the need for explicit certificate ARN annotations, as wildcard certificates like *.stacksimplify.com cover the specified hosts.
- **Process**: Ingress checks for certificates matching the host values in rules; no manual ARN provision required.
- **Annotations**: Requires HTTPS listener annotation (e.g., listen-ports: ["443"]) to enable SSL.

#### SSL Discovery Using TLS Field
- **How it Works**: For non-host-based routing (e.g., context path-based), use the `tls` field in the Ingress spec to specify host names for certificate discovery.
- **Benefits**: Allows certificate association for default backends or path-based rules without host rules.
- **Process**: Provide `tls.hosts` with domain names (e.g., *.stacksimplify.com); Ingress discovers the matching certificate from ACM.
- **Annotations**: Similar to host method, HTTPS listeners must be explicitly enabled.

> [!IMPORTANT]
> Ensure wildcard certificates (e.g., *.stacksimplify.com) are created in ACM before deployment to enable automatic discovery.

### Lab Demos
No hands-on demos in this introductory subsection; practical implementations follow in the next subsections.

## 17.2 Step-02- Implement SSL Discovery Host Demo

### Overview
This practical demo illustrates SSL certificate discovery using host-based Ingress rules. It demonstrates deploying an Ingress resource with host values, verifying automatic certificate association, and testing access without manual certificate ARN configuration.

### Key Concepts/Deep Dive
Building on the introduction, this demo focuses on real-world implementation of host-based SSL discovery.

#### Deployment Setup
- **Resources**: Includes Kubernetes deployments, NodePort services, and an Ingress manifest with host-based rules.
- **Changes from Previous Demos**: 
  - Comment out certificate ARN annotations.
  - Update DNS names (e.g., app102.stacksimplify.com, app202.stacksimplify.com) to avoid Route 53 caching issues.
- **Ingress Configuration**:
  - Name: `ingress-cert-discovery-host-demo`
  - Hosts: `default102.stacksimplify.com`, `app102.stacksimplify.com`, `app202.stacksimplify.com`
  - Certificate: Automatically discovered via wildcard (*.stacksimplify.com) certificate.

#### Automatic Certificate Association
- **Mechanism**: ALB checks Ingress host values against ACM certificates; matches result in automatic association.
- **Verification Steps**:
  - Deploy manifests using `kubectl apply -f kube-manifests`.
  - Check listeners in AWS Load Balancer Console for 443 port certificate.
  - Confirm wildcard certificate (*.stacksimplify.com) is linked without ARN specification.

#### Testing and Cleanup
- **DNS Lookup**: Use `nslookup` or `dig` to verify DNS resolution.
- **Browser Access**: Test URLs like `https://app102.stacksimplify.com` and `https://app202.stacksimplify.com` for SSL redirects and certificate details.
- **Cleanup**: Delete resources with `kubectl delete -f kube-manifests` to remove ALB, Ingress, and Route 53 records.

### Lab Demo Steps
1. Navigate to the repository section (e.g., `08-new-ELB-app-load-balancers/0810-ingress-ssl-discovery-host`).
2. Edit Ingress manifest: Comment out certificate ARN annotation.
3. Update DNS names in Ingress rules if needed.
4. Deploy: `kubectl apply -f kube-manifests`.
5. Verify deployments: `kubectl get pods`, `kubectl get svc`, `kubectl get ingress`.
6. Check ALB in AWS Console: Confirm 443 listener has associated wildcard certificate.
7. Test DNS: Perform `nslookup` on hostnames.
8. Access applications via browser; verify SSL lock and certificate details.
9. Cleanup: `kubectl delete -f kube-manifests`.

### Code/Config Blocks
#### Example Ingress Manifest (Snippet)
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-cert-discovery-host-demo
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/load-balancer-name: cert-discovery-host
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    # alb.ingress.kubernetes.io/certificate-arn: <Commented out for auto-discovery>
spec:
  rules:
  - host: default102.stacksimplify.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-three-nginx-nodeport
            port:
              number: 80
  - host: app102.stacksimplify.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-one-nginx-nodeport
            port:
              number: 80
  - host: app202.stacksimplify.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-two-nginx-nodeport
            port:
              number: 80
```

- **Note**: Full manifests include deployments and services; only Ingress is shown here for brevity.

## 17.3 Step-03- Implement SSL Discovery TLS Demo

### Overview
This demo showcases SSL certificate discovery using the TLS field in Ingress for context path-based routing. It covers deploying manifests with TLS configuration, verifying certificate association, handling DNS issues, and validating secure access without host-based rules.

### Key Concepts/Deep Dive
Extending the previous demo, this focuses on TLS field usage for non-host routing scenarios.

#### Deployment Setup
- **Resources**: Similar to host demo—deployments, NodePort services, and Ingress.
- **Differences**: 
  - Uses path-based routing instead of host rules.
  - TLS field specifies hosts for certificate discovery.
  - DNS: `cert-discovery-tls101.stacksimplify.com` (or 102 to resolve caching).
- **Ingress Configuration**:
  - Name: `ingress-cert-discovery-tls-demo`
  - TLS: `hosts: ["*.stacksimplify.com"]` for wildcard certificate discovery.
  - Paths: `/app1` → App One, `/app2` → App Two, Default → App Three.

#### TLS Field Mechanics
- **Configuration**: Add `spec.tls` with `hosts` list to enable discovery.
- **Automatic Association**: Ingress discovers certificates matching TLS hosts from ACM.
- **Verification**: Ensure ALB 443 listener links the correct wildcard certificate.

#### Handling Common Issues
- **DNS Caching**: Route 53 may cache old records; use unique names (e.g., increment numbers).
- **Resolution**: Update Ingress manifest and redeploy if DNS lookup fails.

### Lab Demo Steps
1. Go to repository section (`08-new-ELB-app-load-balancers/0811-ingress-ssl-discovery-tls`).
2. Review Ingress manifest: Confirm TLS field and commented-out certificate ARN.
3. Deploy: `kubectl apply -f kube-manifests`.
4. Verify: `kubectl get pods`, `kubectl get svc`, `kubectl get ingress`.
5. Check ALB: Ensure 443 listener associates wildcard certificate.
6. Fix DNS if needed: Update hostnames and redeploy.
7. Test DNS: `nslookup` on new hostname.
8. Browser Access: 
   - `https://cert-discovery-tls102.stacksimplify.com/app1/index.html` → App One
   - `https://cert-discovery-tls102.stacksimplify.com/app2/index.html` → App Two
   - `https://cert-discovery-tls102.stacksimplify.com/` → App Three (default)
9. Verify SSL: Check lock icon and certificate details.
10. Cleanup: `kubectl delete -f kube-manifests`.

### Code/Config Blocks
#### Example Ingress Manifest (Snippet)
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-cert-discovery-tls-demo
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/load-balancer-name: cert-discovery-tls
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    # alb.ingress.kubernetes.io/certificate-arn: <Commented out>
spec:
  tls:
  - hosts:
    - "*.stacksimplify.com"
  rules:
  - host: cert-discovery-tls102.stacksimplify.com
    http:
      paths:
      - path: /app1
        pathType: Prefix
        backend:
          service:
            name: app-one-nginx-nodeport
            port:
              number: 80
      - path: /app2
        pathType: Prefix
        backend:
          service:
            name: app-two-nginx-nodeport
            port:
              number: 80
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-three-nginx-nodeport
            port:
              number: 80
```

- **Note**: Deployments and services remain unchanged from prior examples.

## Summary

```diff
+ Key Takeaways:
+ SSL discovery simplifies Ingress by auto-associating certificates from ACM using host or TLS fields, removing manual ARN management.
+ Host-based discovery works with DNS domain matching; TLS field handles path-based routing.
+ Always enable HTTPS listeners via annotations; wildcard certificates must exist in ACM.
- Common Pitfalls:
- Avoid DNS caching issues by using unique hostnames for each demo deployment.
- Do not rely on cached Route 53 records; verify DNS resolution before testing.
! Alerts:
! Ensure wildcard certificates are pre-created in ACM; manual ARN annotations are not needed but listeners must be 443-enabled.
```

### Quick Reference
- **Check Certificate**: ALB Console → Listeners → Edit Certificate for 443.
- **DNS Test**: `nslookup <hostname>` or `dig <hostname>`.
- **Common Commands**:
  - Deploy: `kubectl apply -f kube-manifests`
  - Verify: `kubectl get ingress`, `kubectl get svc`, `kubectl get pods`
  - Cleanup: `kubectl delete -f kube-manifests`
- **Annotations**:
  - Load Balancer Name: `alb.ingress.kubernetes.io/load-balancer-name`
  - Listen Ports: `alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'`

### Expert Insight
#### Real-World Application
In production environments, leverage SSL discovery to automate certificate management for multi-tenant Kubernetes clusters, reducing operational overhead and minimizing human error in certificate ARN handling across numerous Ingress resources. Combine with tools like external-dns for seamless DNS provisioning.

#### Expert Path
Master this by exploring advanced Ingress controllers (e.g., NGINX, Traefik) for support of different certificate discovery mechanisms. Dive into ACM's certificate lifecycle management and integrate with CI/CD pipelines for automated certificate updates. Practice with real ACM certificates to understand renewal challenges.

#### Common Pitfalls
Misspellings like "cubectl" instead of "kubectl" in commands can cause errors—always double-check CLI commands. Overly specific hostnames may not match wildcard certificates; ensure domain alignment. Forgetting to update DNS names can lead to persistent caching issues; monitor Route 53 records diligently.

</details>
