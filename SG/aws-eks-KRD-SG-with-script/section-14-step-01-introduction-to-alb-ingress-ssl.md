# Section 14: ALB Ingress SSL

<details open>
<summary><b>Section 14: ALB Ingress SSL (G3PCS46)</b></summary>

## Table of Contents
- [14.1 Step-01- Introduction to ALB Ingress SSL](#141-step-01--introduction-to-alb-ingress-ssl)
- [14.2 Step-02- Register Domain AWS Route53](#142-step-02--register-domain-aws-route53)
- [14.3 Step-03- Create SSL Certificate in AWS Certificate Manager](#143-step-03--create-ssl-certificate-in-aws-certificate-manager)
- [14.4 Step-04- Update SSL Ingress Annotation, Deploy and Test](#144-step-04--update-ssl-ingress-annotation-deploy-and-test)
- [14.5 Step-05- Update SSL Ingress Redirection Annotation, Deploy, Test and CleanUp](#145-step-05--update-ssl-ingress-redirection-annotation-deploy-test-and-cleanup)

## 14.1 Step-01- Introduction to ALB Ingress SSL

### Overview
This lecture introduces the ALB Ingress SSL use case for Kubernetes, building on previous context path-based routing. Key tasks include registering a new domain in AWS Route53, creating an SSL certificate via AWS Certificate Manager, updating ingress annotations for SSL, and deploying/testing manifests. It also highlights adding AWS Route53 and Certificate Manager services to the network design.

### Key Concepts/Deep Dive
- **Services Introduced**: 
  - AWS Route53 for domain registration and DNS management.
  - AWS Certificate Manager for SSL certificate creation and validation.
- **Network Design**: Extends previous context path-based routing setup by integrating Route53 and Certificate Manager. The ALB handles SSL-enabled access to applications (app-one, app-two, app-three) via both HTTP and HTTPS URLs with custom DNS names like `ssldemo.stacksimplified.com`.
- **Tasks Breakdown**:
  1. Register a new domain in AWS Route53 (e.g., `kubeoncloud.com` for demo).
  2. Create an SSL certificate in AWS Certificate Manager.
  3. Update SSL annotations in the ingress service.
  4. Deploy Kubernetes manifests and test accessibility.
- **Access Patterns**: 
  - HTTP/HTTPS access to all apps via context paths (`/app1`, `/app2`, default for app-three).
  - Custom domain resolves to ALB DNS.
- **Future Scope**: Next demo adds SSL redirect (HTTP to HTTPS automatic redirection).
- **Corrections Noted**: Transcript mentions "taxsimplified.com" and "cubancloud.com"; standardized to "stacksimplified.com" and "kubeoncloud.com" for consistency.

### Lab Demos
No hands-on steps in this introductory lecture.

## 14.2 Step-02- Register Domain AWS Route53

### Overview
This lecture demonstrates registering a domain in AWS Route53, focusing on purchasing and verifying `kubeoncloud.com`. It covers the process of domain acquisition, payment, and initial DNS configuration via hosted zones.

### Key Concepts/Deep Dive
- **Domain Registration Process**:
  - Search for "Route53" in AWS Console, navigate to "Register domains".
  - Enter domain name (e.g., `kubeoncloud.com`), check availability, add to cart.
  - Provide registrant details (privacy protection enabled by default).
  - Agree to auto-renewal and terms, complete order.
- **Payment and Verification**:
  - Submit order; may take up to 3 days, but often faster (hours).
  - Verify payment via "Domains" → "Action Required" for newly registered domains.
  - Once verified, status updates to "Registered".
- **Hosted Zone Creation**:
  - Route53 automatically creates a public hosted zone for the domain.
  - Use "Manage DNS" to access hosted zone for record creation.
  - Supports subdomains, IP addresses, or ELB DNS names for routing.
- **Key Features**:
  - Auto-renewal ensures continuity.
  - DNS records can be managed for application load balancers (e.g., ALB DNS names).
- **Corrections Noted**: Transcript refers to "Sections 0 8 0 4" (likely "08-04"); corrected for clarity.

### Lab Demos
1. Navigate to AWS Console → Route53.
2. Select "Register domains" → Enter `kubeoncloud.com` → Check availability → Add to cart.
3. Provide registrant details → Enable privacy protection → Accept terms → Complete order.
4. Monitor "Pending requests" until status changes to "Registered" (verify payment).
5. Access hosted zone via "Manage DNS" to review/record setup.

## 14.3 Step-03- Create SSL Certificate in AWS Certificate Manager

### Overview
This section explains creating a wildcard SSL certificate in AWS Certificate Manager for domain `*.stacksimplified.com`, enabling secure access for subdomains. It covers certificate request, DNS validation, and integration with Route53 for automatic record creation.

### Key Concepts/Deep Dive
- **Certificate Types**: Focus on wildcard certificates supporting all subdomains (e.g., `ssl-demo.stacksimplified.com`, `abc.stacksimplified.com`) to avoid browser SSL errors.
- **Request Process**:
  - Navigate to AWS Certificate Manager → "Request a certificate" → "Request a public certificate".
  - Specify fully qualified domain name: `*.stacksimplified.com`.
- **Validation Method**: Use DNS validation for automation.
- **Route53 Integration**: After request, ACM generates DNS records; click "Create records in Route53" to auto-add CNAME records for validation.
- **States**: Certificate starts as "Pending validation"; once DNS records are created and propagated, status changes to "Issued".
- **Validation Verification**:
  - Confirm CNAME records in Route53 hosted zone (e.g., for `stacksimplified.com`).
  - Certificate is ready for ALB association.
- **Benefits**: Wilcard certificates simplify multi-subdomain setups; ARN is used for ingress annotations.

### Lab Demos
1. Go to AWS Console → Certificate Manager.
2. Click "Request a certificate" → "Request a public certificate" → Enter `*.stacksimplified.com` → Choose DNS validation → Request.
3. Select certificate → "Create records in Route53" to auto-add DNS records.
4. Wait for validation; check Route53 hosted zone for CNAME records.
5. Verify certificate status as "Issued" in ACM.

## 14.4 Step-04- Update SSL Ingress Annotation, Deploy and Test

### Overview
Here, SSL annotations are added to the ingress manifest (`04-alb-ingress-ssl.yaml`) to enable HTTPS support. The setup deploys apps with both HTTP (port 80) and HTTPS (port 443) listeners on the ALB, associates the ACM certificate, and tests accessibility via custom DNS.

### Key Concepts/Deep Dive
- **Ingress Changes**:
  - Update ingress name to `ingress-ssl-demo`.
  - Change load balancer name to `ssl-ingress`.
  - Add annotations:
    - `alb.ingress.kubernetes.io/listen-ports`: Specifies ports 80 and 443.
    - `alb.ingress.kubernetes.io/certificate-arn`: Inserts ACM certificate ARN (e.g., from `*.stacksimplified.com`).
    - Optional: `alb.ingress.kubernetes.io/ssl-policy` for custom policies (defaults to standard).
- **Deployment**: Reuse manifests from context path-based routing; adds ingress with SSL support.
- **ALB Configuration**:
  - Creates HTTP (port 80) and HTTPS (port 443) listeners.
  - Rules match context paths (`/app1`, `/app2`, default backend `/app3`).
  - Target groups/health checks mirror previous setup (e.g., pods for app-one, app-two, app-three).
- **DNS Registration**: Create A-record alias in Route53 (e.g., `ssl-demo-101.stacksimplified.com` pointing to ALB DNS).
- **Testing**: 
  - Access apps via HTTP/HTTPS with custom domain; HTTPS shows secure lock.
  - Verify certificate in browser (wildcard supports subdomains).
- **Corrections Noted**: Transcript has "0 8 0 4" and "0 1 0 2 0 3"; corrected to proper section refs.

### Code/Config Blocks
```yaml
# Sample Ingress Annotation (04-alb-ingress-ssl.yaml)
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-ssl-demo
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: ssl-ingress
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    alb.ingress.kubernetes.io/certificate-arn: 'arn:aws:acm:us-east-1:123456789012:certificate/abc123de-4567-89fg-hi01-234ijklmnop'
rules:
- http:
    paths:
    - path: /app1
      pathType: Prefix
      backend:
        service:
          name: app-one
          port:
            number: 80
    - path: /app2
      pathType: Prefix
      backend:
        service:
          name: app-two
          port:
            number: 80
    - path: /
      pathType: Prefix
      backend:
        service:
          name: app-three
          port:
            number: 80
```

### Lab Demos
1. Update ingress YAML with SSL annotations and certificate ARN.
2. Deploy: `kubectl apply -f kube-manifest/`.
3. Verify: `kubectl get pods`, `kubectl get svc`, `kubectl get ingress`.
4. Check ALB in AWS Console: Confirm listeners (80/443), rules, and associated certificate.
5. Create Route53 A-record: `ssl-demo-101.stacksimplified.com` → Alias to ALB DNS.
6. Test: Access `http://ssl-demo-101.stacksimplified.com/app1` (insecure) and `https://ssl-demo-101.stacksimplified.com/app1` (secure with lock).

## 14.5 Step-05- Update SSL Ingress Redirection Annotation, Deploy, Test and CleanUp

### Overview
This demo adds SSL redirection annotations to the ingress, enforcing automatic HTTP-to-HTTPS redirects. It redeploys manifests, tests redirection, and cleans up resources by deleting manifests and DNS records.

### Key Concepts/Deep Dive
- **Annotation Addition**: Add `alb.ingress.kubernetes.io/ssl-redirect: "443"` to ingress for port 80 → 443 redirection.
- **Impact**: ALB removes app-specific rules on port 80, replacing with a single redirect rule to port 443.
- **Default vs. Context**: Contrasts with previous setup where root context was used; here, default backend directs to app-three.
- **Testing**: HTTP URLs auto-redirect to HTTPS; verify in incognito mode to avoid caching.
- **Cleanup Process**:
  - Delete manifests: `kubectl delete -f kube-manifest/`.
  - Confirm ALB deletion.
  - Remove_route53 records (e.g., `ssl-demo-101.stacksimplified.com`).

### Code/Config Blocks
```yaml
# Updated Ingress with Redirection (04-alb-ingress-ssl-redirect.yaml)
# Add to existing annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/ssl-redirect: "443"
```

### Lab Demos
1. Add SSL redirect annotation to ingress YAML.
2. Redeploy: `kubectl apply -f kube-manifest/`.
3. Check ALB: Port 80 now shows redirect rule to 443; port 443 retains app rules.
4. Test: Access `http://ssl-demo-101.stacksimplified.com/app1` → Auto-redirects to `https://` with secure connection.
5. Cleanup: `kubectl delete -f kube-manifest/` → Verify ALB deletion → Remove Route53 A-record.

## Summary

### Key Takeaways
```diff
+ SSL certificates enable secure HTTPS access for Kubernetes ingress via ALB and AWS Certificate Manager.
- Avoid using non-wildcard certificates for subdomains to prevent browser errors; always validate DNS records.
! Proper Route53 DNS registration ensures custom domains resolve correctly to ALB IPs.
```

### Quick Reference
- **Route53 Domain Registration**: Console → Route53 → Register domains → Purchase and verify payment.
- **Wildcard SSL Cert**: ACM → Request public cert → `*.domain.com` → DNS validation → Create records in Route53.
- **Ingress SSL Annotations**: Add `cert-n-arn`, `listen-ports` (80,443); for redirects, add `ssl-redirect: "443"`.
- **Test Commands**: `kubectl get ingress`, `nslookup custom-domain`, access HTTP/HTTPS URLs.
- **Cleanup**: `kubectl delete -f manifests`, remove Route53 records, delete unnecessary domains.

### Expert Insight
**Real-World Application**: In production, use wildcard SSL certificates for multi-tenant apps to ensure security without per-subdomain certs. Integrate with CI/CD for automated certificate renewal via ACM.

**Expert Path**: Master ALB ingress by experimenting with custom SSL policies (e.g., better cipher suites) and combining with external DNS controllers for dynamic scaling.

**Common Pitfalls**: Forgetting DNS validation delays certificate issuance; mismatch ARN errors ALB association. Always test redirects in fresh sessions to avoid caching. Avoid attaching secrets directly; use ACM for managed certs.

</details>
