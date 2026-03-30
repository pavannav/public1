# Session 68: Provision Load Balancer via gcloud, Cloud DNS, SSL Policy

## Table of Contents
- [Cloud Run Service Deployment](#cloud-run-service-deployment)
- [Network Endpoint Group Creation](#network-endpoint-group-creation)
- [Backend Service Configuration](#backend-service-configuration)
- [Backend Addition to Service](#backend-addition-to-service)
- [URL Map Creation](#url-map-creation)
- [Target Proxy Setup](#target-proxy-setup)
- [Forwarding Rule and Static IP Reservation](#forwarding-rule-and-static-ip-reservation)
- [HTTPS Front End and SSL Certificate](#https-front-end-and-ssl-certificate)
- [HTTP to HTTPS Redirect](#http-to-https-redirect)
- [Cloud DNS Configuration](#cloud-dns-configuration)
- [SSL Policy Implementation](#ssl-policy-implementation)

## Cloud Run Service Deployment
### Overview
Deploy a Cloud Run service using the `nginx` image to serve as the backend for the load balancer. Use region-specific deployment, enable unauthenticated invocations, and ensure the service is ready for integration with network endpoint groups.

### Key Concepts/Deep Dive
- Commands for deployment:
  ```bash
  gcloud run deploy [service-name] --image=nginx:latest --allow-unauthenticated --region=us-central1
  ```
- Wait for deployment completion; note potential delays or errors like quota exceeded.
- Verify deployment via Cloud Console or commands like `gcloud run services list`.

> [!NOTE]
> Cloud Run services must be operational before creating associated network resources.

### Lab Demos
1. Deploy Cloud Run service:
   - Open Cloud Shell.
   - Execute deployment command with specified parameters.
   - Confirm service is running and accessible.

## Network Endpoint Group Creation
### Overview
Create a network endpoint group (NEG) to associate the Cloud Run service with the load balancer infrastructure, enabling serverless backend integration.

### Key Concepts/Deep Dive
- NEG bridges Cloud Run with load balancers as it does for other backends like instance groups.
- Commands:
  ```bash
  gcloud compute network-endpoint-groups create [neg-name] --network-endpoint-type=serverless --cloud-run-service=[service-name] --region=us-central1
  ```
- Verify via `gcloud compute network-endpoint-groups list`.

> [!IMPORTANT]
> NEGs for serverless do not require health checks.

### Lab Demos
1. Create NEG after Cloud Run deployment.
2. Check NEG list and service association.

## Backend Service Configuration
### Overview
Set up a global backend service to route traffic to the NEG, configuring it for external load balancing.

### Key Concepts/Deep Dive
- Backend services manage backends and routing; global for external LB.
- Commands:
  ```bash
  gcloud compute backend-services create [backend-service-name] --global --protocol=HTTPS --load-balancing-scheme=EXTERNAL_MANAGED
  ```
- No direct UI creation; use gcloud, API, or Terraform.
- Verify via `gcloud compute backend-services list`.

### Lab Demos
1. Create global backend service.
2. Confirm in Cloud Console advanced view.

## Backend Addition to Service
### Overview
Attach the NEG to the backend service as its endpoint.

### Key Concepts/Deep Dive
- Adds serverless NEG to backend service.
- Commands:
  ```bash
  gcloud compute backend-services add-backend [backend-service-name] --global --network-endpoint-group=[neg-name] --network-endpoint-group-region=us-central1
  ```
- Updates backend configuration for traffic handling.

### Lab Demos
1. Add NEG to backend service.
2. Refresh and verify backend is attached in UI.

## URL Map Creation
### Overview
Create a URL map to define routing rules, equivalent to the "Load Balancer" name in the UI.

### Key Concepts/Deep Dive
- URL map (load balancer in UI) links to backend service for host/path rules.
- Commands:
  ```bash
  gcloud compute url-maps create [url-map-name] --default-service=[backend-service-name] --global
  ```
- Dependency: Backend service must exist first.

### Lab Demos
1. Create URL map linked to backend service.
2. Verify in Cloud Console.

## Target Proxy Setup
### Overview
Establish a target HTTP proxy to terminate connections and route to backends, enabling protocol-specific handling.

### Key Concepts/Deep Dive
- Proxies like HTTP or HTTPS terminate traffic and route onward; global for LB.
- Role: Creates new connections to backends, preventing source IP retention (use headers for client IP).
- Applicable to layer 7 proxies; differs from pass-through L4 balancers.
- Commands:
  ```bash
  gcloud compute target-http-proxies create [target-proxy-name] --url-map=[url-map-name] --global
  ```
- For HTTPS, use `target-https-proxies` and include SSL certificates.

### Lab Demos
1. Create HTTP target proxy.
2. Link to URL map and verify connections.

## Forwarding Rule and Static IP Reservation
### Overview
Create a global forwarding rule (front end in UI) with a reserved static IP to direct traffic to the target proxy.

### Key Concepts/Deep Dive
- Forwarding rules handle incoming requests; global for load balancers.
- Reserve static IPs for fixed addresses and DNS mappings.
- Commands:
  ```bash
  gcloud compute addresses create [ip-name] --global
  gcloud compute forwarding-rules create [forwarding-rule-name] --global --target-http-proxy=[target-proxy-name] --address=[reserved-ip] --ports=80
  ```
- Costs: Static IPs ~$7/month when unattached; forwarding rules free for the first five.

### Lab Demos
1. Reserve global static IP.
2. Create global forwarding rule with reserved IP.
3. Verify in UI and by accessing via IP.

## HTTPS Front End and SSL Certificate
### Overview
Add HTTPS capability using SSL certificates, including Google-managed certificates for ease and automation.

### Key Concepts/Deep Dive
- Certificates validate domains and enable secure connections.
- Google-managed certificates: Free, 90-day auto-renewal, domain-validated.
- Commands for certificate creation:
  ```bash
  gcloud compute ssl-certificates create [cert-name] --domains=[domain] --global
  ```
- Attach to HTTPS proxies/target proxies with forwarding rules on port 443.

> [!NOTE]
> Domain must resolve properly and return 200 OK for verification.

### Lab Demos
1. Create SSL certificate for domain.
2. Attach to forwarding rule for HTTPS.
3. Test access and certificate validity.

## HTTP to HTTPS Redirect
### Overview
Configure automatic redirection from HTTP to HTTPS for security and user experience.

### Key Concepts/Deep Dive
- Prevents insecure access; creates separate URL map for redirects.
- Enable during forwarding rule creation with `--redirect-to-https`.
- Generates 301/302 redirects; browser caches may affect testing (use incognito or different browsers).

### Lab Demos
1. Edit forwarding rule to include HTTPS redirect.
2. Verify HTTP requests redirect to HTTPS.

## Cloud DNS Configuration
### Overview
Use Cloud DNS for managed domain name resolution, alternative to external providers like GoDaddy.

### Key Concepts/Deep Dive
- 100% SLA service; programmable via gcloud/Terraform.
- Change name servers in domain provider to Google DCs.
- Create zones (containers for records) and A records for IPs.
- Pros: Full control, reliability; cons: Propagation time (hours to days).
- Tools for propagation checks: DNS.google, NS lookup services.

> [!NOTE]
> Reserve IPs and certificates beforehand for smooth transitions.

### Lab Demos
1. Create Cloud DNS zone.
2. Update domain name servers.
3. Add A records; verify propagation.

## SSL Policy Implementation
### Overview
Define SSL policies to control secure connections клиент-side, disabling outdated protocols for compliance.

### Key Concepts/Deep Dive
- Policies negotiate TLS/SSL with clients; modern/strict profiles disable old versions (e.g., TLS 1.0/1.1).
- Attach to forwarding rules/HTTPS products.
- Mimic financial institutions by restricting to TLS 1.2+; tools like SSL Labs for testing.

> [!IMPORTANT]
> Outdated client support poses security risks; audit for compliance.

### Lab Demos
1. Create/modify SSL policy (e.g., modern or custom).
2. Attach to HTTPS forwarding rule.
3. Test with tools like SSL Labs; verify secure connections.

## Summary: Provision Load Balancer via gcloud, Cloud DNS, SSL Policy

### Key Takeaways
```diff
! Global load balancers use components like NEGs, backend services, URL maps, proxies, and forwarding rules for full functionality.
+ Command-line provisioning with gcloud enables automation and scripting.
- UI terms may misalign with technical names (e.g., URL map as "load balancer").
! SSL certificates and policies enhance security; disable outdated protocols for compliance.
! Cloud DNS provides managed, reliable domain resolution over external providers.
- Domain propagation can take 1-48 hours; monitor with DNS tools.
! HTTP to HTTPS redirects improve user security and site reliability.
```

### Expert Insight

**Real-world Application**: Use this setup for production web applications needing secure, scalable access. Integrate with Terraform for IaC, ensuring automated deployment and version control. Monitor costs: Free SSL certs, forwarding rules (if <5), but static IPs and data egress incur charges.

**Expert Path**: Master gcloud commands for load balancers; learn Terraform/modules for DNS and SSL. Study Cloud Armor for security layers. Practice in projects with domain buying (e.g., GoDaddy alternatives). Deepen SSL/TLS knowledge via RFCs and certifications like Google Cloud Security Engineer.

**Common Pitfalls**: 
- Forgetting health checks are unnecessary for serverless NEGs, unlike instance groups.
- Not reserving IPs leading to changes on recreations, complicating DNS updates.
- SSL verification failures from unresolved domains or non-200 responses.
- Outdated SSL policies allowing deprecated protocols, failing audits.
- DNS propagation delays causing outages; plan migrations around this (e.g., weekends).
