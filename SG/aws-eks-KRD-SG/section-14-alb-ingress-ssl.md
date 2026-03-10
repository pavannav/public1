# Section 14: ALB Ingress SSL

<details open>
<summary><b>Section 14: ALB Ingress SSL (Claude Code)</b></summary>

## Table of Contents

- [14.1 Step-01- Introduction to ALB Ingress SSL](#141-step-01--introduction-to-alb-ingress-ssl)
- [14.2 Step-02- Register Domain AWS Route53](#142-step-02--register-domain-aws-route53)
- [14.3 Step-03- Create SSL Certificate in AWS Certificate Manager](#143-step-03--create-ssl-certificate-in-aws-certificate-manager)
- [14.4 Step-04- Update SSL Ingress Annotation, Deploy and Test](#144-step-04--update-ssl-ingress-annotation-deploy-and-test)
- [14.5 Step-05- Update SSL Ingress Redirection Annotation, Deploy, Test and CleanUp](#145-step-05--update-ssl-ingress-redirection-annotation-deploy-and-test-and-cleanup)

## 14.1 Step-01- Introduction to ALB Ingress SSL

### Overview

Section 14 explores SSL/TLS certificate integration with ALB ingress, demonstrating secure HTTPS access to Kubernetes applications through AWS Certificate Manager and ingress annotations.

### Key Concepts

**SSL Integration Architecture:**
- **HTTPS Termination**: SSL certificates loaded on ALB for secure https:// access
- **Domain Registration**: Custom domain name registration with Route53
- **Certificate Management**: AWS Certificate Manager for SSL certificate lifecycle
- **Ingress Annotations**: ALB-specific SSL configuration directives

### SSL/TLS Flow with ALB Ingress

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    User     │────►│    ALB      │────►│ Kubernetes  │
│  HTTPS://   │     │   SSL/TLS   │     │  Ingress    │
│  app.com    │     │ Termination │────►│            │
│             │     └─────────────┘     └─────────────┘
│             │                              │
└─────────────┘                              ▼
                                         ┌─────────────┐
                                         │  Services  │─►Pods
                                         │  HTTP      │
                                         └─────────────┘
```

### ALB SSL Capabilities

- **Certificate Binding**: AWS ACM certificates directly attached to listeners
- **Automatic Renewal**: ACM handles certificate renewal automatically
- **Multiple Domains**: SNI (Server Name Indication) support for multiple domains
- **Security Policies**: Configurable SSL/TLS protocol versions and cipher suites
- **HTTPS Redirect**: Automatic HTTP to HTTPS redirection support

### Prerequisites for SSL Implementation

**Required Components:**
- **Custom Domain**: Domain name registered with Route53
- **SSL Certificate**: Certificate issued by AWS Certificate Manager
- **DNS Configuration**: Route53 hosted zone with proper NS records
- **Ingress Annotations**: SSL configuration annotations for ALB

### HTTP vs HTTPS Processing

**SSL Termination Architecture:**
1. **Domain Resolution**: `app.example.com` resolves to ALB DNS
2. **SSL Handshake**: ALB performs SSL termination with ACM certificate
3. **Protocol Translation**: HTTPS traffic decrypted and forwarded as HTTP
4. **Ingress Routing**: Standard HTTP routing rules applied
5. **Pod Communication**: Service-to-pod traffic remains HTTP

### Certificate Domain Matching

**Certificate Types Supported:**
- **Single Domain**: `example.com`
- **Wildcard Certificate**: `*.example.com`
- **Multi-Domain Certificate**: `example.com, api.example.com`
- **SNI Required**: Required for multiple certificates on same ALB

### Security Benefits

- **End-to-End Encryption**: SSL/TLS protecting user traffic to ALB
- **ALB Security**: AWS-managed certificate renewal and validation
- **Performance**: Hardware-accelerated SSL termination
- **Compliance**: SSL encryption and security policies for regulatory requirements

## 14.2 Step-02- Register Domain AWS Route53

### Overview

Setting up custom domain infrastructure through AWS Route53 domain registration and hosted zone management for proper DNS resolution supporting SSI certificate validation.

### Domain Registration Process

**Route53 Domain Registration Steps:**
1. **Domain Search**: Verify domain availability
2. **Registration Request**: Provide contact information and payment
3. **DNS Configuration**: Automatic Route53 hosted zone creation
4. **Domain Validation**: Verify ownership through email or DNS
5. **DNS Propagation**: Global DNS updates (24-48 hours)

### Route53 Hosted Zone Setup

```bash
# Create hosted zone (automatically done during registration)
aws route53 create-hosted-zone \
  --name example.com \
  --caller-reference "eks-demo-$(date +%s)"

# Verify hosted zone creation
aws route53 list-hosted-zones \
  --query 'HostedZones[?contains(Name, `example.com`)]'
```

### DNS Record Management

**Essential DNS Records:**
- **SOA (Start of Authority)**: Domain authoritative server information
- **NS (Name Server)**: Route53 name servers for domain delegation
- **A Record**: Root domain resolution (will point to ALB later)
- **CNAME Records**: Subdomain aliases if needed

### Domain Verification Commands

```bash
# Check domain propagation
dig example.com

# Verify Route53 name servers
whois example.com | grep -i nameserver

# Test DNS resolution
nslookup example.com
```

### Cost Considerations

- **Domain Registration**: $9-15/year depending on domain extension
- **DNS Queries**: First 1 billion queries free/month
- **Hosted Zone**: $0.50/month for standard hosted zones

## 14.3 Step-03- Create SSL Certificate in AWS Certificate Manager

### Overview

SSL certificate creation and domain validation using AWS Certificate Manager for secure HTTPS encryption of ALB traffic.

### Certificate Manager Process

**ACM Certificate Creation:**
1. **Request Certificate**: Public certificate for domain validation
2. **Domain Names**: Add primary domain and optional SAN (Subject Alternative Names)
3. **Validation Method**: DNS validation (preferred over email)
4. **DNS Records**: Route53 CNAME records added automatically
5. **Validation**: Certificate ready in 5-10 minutes

### Certificate Request Commands

```bash
# Request certificate through console or CLI
aws acm request-certificate \
  --domain-name example.com \
  --subject-alternative-names *.example.com \
  --validation-method DNS

# List certificates
aws acm list-certificates --includes keyUsages ENCRYPT_DECRYPT
```

### Certificate Types and Use Cases

| Certificate Type | Use Case | Example |
|-----------------|----------|---------|
| **Single Domain** | One website | `example.com` |
| **Wildcard** | All subdomains | `*.example.com` |
| **Multi-Domain** | Multiple domains | `example.com`, `api.example.com` |

### DNS Validation Process

**Route53 Integration Benefits:**
- **Automatic Record Addition**: ACM creates DNS records automatically
- **No Manual Intervention**: DNS records added to correct hosted zone
- **Fast Validation**: Certificate validated in minutes, not days
- **Renewal Automation**: AWS handles renewal automatically

### Certificate Status Verification

```bash
# Check certificate status
aws acm describe-certificate \
  --certificate-arn arn:aws:acm:region:account:certificate/cert-id

# Expected status: PENDING_VALIDATION → ISSUED
```

### Validation Timeline

- **Request Initiated**: Certificate ARN created immediately
- **Validation Records Added**: Route53 records created automatically
- **DNS Propagation**: Route53 CNAME records globally available
- **Certificate Issued**: VALID status reached (5-10 minutes)
- **ALB Deployment**: Certificate ready for SSL termination

## 14.4 Step-04- Update SSL Ingress Annotation, Deploy and Test

### Overview

Implementing SSL configuration through ALB ingress annotations with ACM certificate integration for secure HTTPS application access.

### SSL Ingress Configuration

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-ssl-https
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: ssl-demo-app1-lb
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    alb.ingress.kubernetes.io/ssl-redirect: "443"
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:region:account:certificate/cert-id
    alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-2-2017-01
spec:
  ingressClassName: aws-load-balancer
  rules:
  - host: ssl.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app1-nginx-nodeport-service
            port:
              number: 80
```

### Critical SSL Annotations

| Annotation | Purpose | Example Value |
|------------|---------|---------------|
| `alb.ingress.kubernetes.io/listen-ports` | HTTP/HTTPS ports | `[{"HTTP": 80}, {"HTTPS": 443}]` |
| `alb.ingress.kubernetes.io/certificate-arn` | ACM certificate ARN | Full ARN from ACM |
| `alb.ingress.kubernetes.io/ssl-policy` | Security policies | `ELBSecurityPolicy-TLS-1-2-2017-01` |
| `alb.ingress.kubernetes.io/ssl-redirect` | HTTP→HTTPS redirect port | `"443"` |

### DNS Configuration for SSL

**Route53 Record Update:**
```bash
# Create A record alias pointing to ALB
aws route53 change-resource-record-sets \
  --hosted-zone-id ZXXXXXXXXXXX \
  --change-batch '{
    "Changes": [{
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "ssl.example.com",
        "Type": "A",
        "AliasTarget": {
          "DNSName": "dualstack.ssl-demo-app1-lb-xxxx.amazonaws.com",
          "HostedZoneId": "Zzzzzz",
          "EvaluateTargetHealth": true
        }
      }
    }]
  }'
```

### SSL Implementation Process

**Deployment Steps:**
```bash
# 1. Update ingress with SSL annotations
kubectl apply -f ingress-ssl.yaml

# 2. Monitor ALB creation with SSL
kubectl get ingress ingress-ssl-https -w

# 3. Verify ALB listeners
aws elbv2 describe-load-balancers \
  --query 'LoadBalancers[?contains(DNSName, `ssl-demo-app1-lb`)]'

# 4. Check listener configurations
LISTENER_ARN=$(aws elbv2 describe-listeners \
  --load-balancer-arn YOUR-ALB-ARN \
  --query 'Listeners[?Protocol==`HTTPS`].ListenerArn' \
  --output text)

aws elbv2 describe-listeners --listener-arns $LISTENER_ARN
```

### Testing SSL Implementation

**HTTPS Access Verification:**
```bash
# Test HTTPS access
curl -k https://ssl.example.com/
# Should return SSL handshake and application content

# Verify certificate details
openssl s_client -connect ssl.example.com:443 -servername ssl.example.com < /dev/null 2>/dev/null | openssl x509 -noout -text | grep -E "(Subject:|Issuer:|DNS:)"

# Expected: Certificate issued to ssl.example.com
```

### Certificate Chain and Security

**SSL Configuration Analysis:**
- **Certificate Status**: Should show as "Active" in ACM
- **Domain Validation**: Shows domain successfully validated
- **Trust Chain**: AWS AMIs/SM intermediate certificates included
- **Protocol Support**: TLS 1.2 minimum with modern cipher suites

## 14.5 Step-05- Update SSL Ingress Redirection Annotation, Deploy, Test and CleanUp

### Overview

Implementing HTTPS redirection through inbound annotations, ensuring all HTTP traffic automatically redirects to HTTPS for enhanced security and compliance.

### HTTP to HTTPS Redirect Configuration

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-ssl-redirect
  annotations:
    alb.ingress.kubernetes.io/load-balancer-name: ssl-redirect-app1-lb
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    alb.ingress.kubernetes.io/ssl-redirect: "443"  # Enable redirect
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:region:account:certificate/cert-id
    alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-2-2017-01
spec:
  ingressClassName: aws-load-balancer
  rules:
  - host: redirect.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app1-nginx-nodeport-service
            port:
              number: 80
```

### Redirect Mechanism Details

**ALB Redirect Implementation:**
1. **Dual Listeners**: ALB creates both HTTP:80 and HTTPS:443 listeners
2. **HTTP Listener Rules**: HTTP listener returns 301/302 redirect response
3. **HTTPS Listener Rules**: HTTPS listener forwards to target groups
4. **Seamless Redirection**: No application changes required for redirect

### Testing Redirect Behavior

```bash
# 1. Update DNS for redirect subdomain
aws route53 change-resource-record-sets \
  --hosted-zone-id ZXXXXXXXXXXX \
  --change-batch '{
    "Changes": [{
      "Action": "CREATE",
      "ResourceRecordSet": {
        "Name": "redirect.example.com",
        "Type": "A",
        "AliasTarget": {
          "DNSName": "ssl-redirect-app1-lb-xxxx.amazonaws.com",
          "HostedZoneId": "Zzzzzz"
        }
      }
    }]
  }'

# 2. Test HTTP access (should redirect)
curl -I http://redirect.example.com/
# HTTP/1.1 301 Moved Permanently
# Location: https://redirect.example.com/

# 3. Test direct HTTPS access
curl -k https://redirect.example.com/
# Should return application content over HTTPS
```

### ALB Listener Rule Verification

**HTTP Listener (Port 80):**
```
Rule 1: IF (Host Header: redirect.example.com) THEN Redirect to https://redirect.example.com/
```

**HTTPS Listener (Port 443):**
```
Rule 1: IF (Host Header: redirect.example.com) AND (Path: /*) THEN Forward to TargetGroup-App1
```

### Security Enhancement Benefits

- **Automatic HTTPS**: Enforces secure communication
- **SEO Benefits**: Search engines prefer HTTPS
- **Compliance**: Meets security standards and regulations
- **User Trust**: HTTPS lock icon builds user confidence
- **Modern Standards**: Aligns with current web security best practices

### Redirect Annotation Options

| Annotation | Behavior |
|------------|----------|
| `alb.ingress.kubernetes.io/ssl-redirect: "443"` | HTTP → HTTPS redirect |
| No annotation | Allow both HTTP and HTTPS (less secure) |

### Complete Cleanup Process

```bash
# 1. Delete ingress (ALB auto-deleted)
kubectl delete ingress ingress-ssl-redirect

# 2. Remove Route53 records
aws route53 change-resource-record-sets \
  --hosted-zone-id ZXXXXXXXXXXX \
  --change-batch '{
    "Changes": [{
      "Action": "DELETE",
      "ResourceRecordSet": {
        "Name": "redirect.example.com",
        "Type": "A",
        "AliasTarget": {
          "DNSName": "ssl-redirect-app1-lb-xxxx.amazonaws.com",
          "HostedZoneId": "Zzzzzz"
        }
      }
    }]
  }'

# 3. Optional: Delete certificate from ACM
# aws acm delete-certificate --certificate-arn YOUR-CERT-ARN

# 4. Verify ALB cleanup
aws elbv2 describe-load-balancers \
  --query 'LoadBalancers[?contains(DNSName, `redirect-app1-lb`)]'
```

## Summary

### Key Takeaways

```diff
+ ALB ingress enables SSL termination with AWS Certificate Manager integration
+ HTTPS redirection ensures all traffic uses secure connections
+ Route53 provides domain management and DNS resolution capabilities
+ ACM handles certificate lifecycle automatically including renewals
+ Ingress annotations control SSL configuration and security policies
```

### Quick Reference

**SSL Ingress Configuration:**
```yaml
annotations:
  alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
  alb.ingress.kubernetes.io/certificate-arn: "IMPORT-CERTIFICATE-ARN"
  alb.ingress.kubernetes.io/ssl-redirect: "443"
  alb.ingress.kubernetes.io/ssl-policy: "ELBSecurityPolicy-TLS-1-2-2017-01"
```

### Lab Demos Summary

1. **Domain Setup**: Route53 domain registration and hosted zone creation
2. **Certificate Management**: AWS Certificate Manager public certificate issuance
3. **SSL Ingress**: ALB configuration with HTTPS termination
4. **Redirect Implementation**: Automatic HTTP to HTTPS redirection
5. **DNS Integration**: Route53 ALIASES pointing to ALB DNS names

### Expert Insight

**Production SSL Architecture**: AWS Certificate Manager with ALB ingress provides enterprise-grade SSL termination with automated certificate management, enabling secure HTTPS access to containerized applications.

**Best Practices**:
- Always enable SSL redirect in production
- Use wildcard certificates for multi-service domains
- Implement proper certificate pinning for extra security
- Configure security policies that disable older TLS versions
- Use DNS validation for faster certificate issuance
- Implement proper monitoring for certificate expiration

**Common Pitfalls**:
- ❌ Forgetting to validate certificate domain ownership
- ❌ Using self-signed certificates in production environments
- ❌ Missing Route53 hosted zone NS record delegation causing DNS failures
- ❌ Certificate ARN expiration without renewal monitoring
- ❌ Security policies not updated for modern encryption standards
- ❌ DNS propagation delays causing validation timeouts