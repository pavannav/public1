# Section 25: Microservices Deployment on EKS

<details open>
<summary><b>Section 25: Microservices Deployment on EKS (G3PCS46)</b></summary>

## Table of Contents
- [25.1 Microservices Introduction](#251-microservices-introduction)
- [25.2 Microservices Deployment on EKS - Introduction](#252-microservices-deployment-on-eks---introduction)
- [25.3 Pre-requisite Checks](#253-pre-requisite-checks)
- [25.4 Review Notification Microservice Kubernetes Manifests](#254-review-notification-microservice-kubernetes-manifests)
- [25.5 Review User Management Microservice Kubernetes Manifests](#255-review-user-management-microservice-kubernetes-manifests)
- [25.6 UMS & NS Microservices Deployment & Test](#256-ums--ns-microservices-deployment--test)
- [25.7 Microservices Rollout New Deployments and CleanUp](#257-microservices-rollout-new-deployments-and-cleanup)
- [Summary](#summary)

## 25.1 Microservices Introduction

### Overview
This lecture provides a comprehensive introduction to microservices architecture, defining it as a structural approach that divides applications into loosely coupled, independently deployable services. Each microservice focuses on a specific business capability and is owned by small development teams, enabling greater scalability and resilience.

### Key Concepts
Microservices architecture offers several critical benefits for modern application development:

**Developer Independence**
- Small teams can work in parallel and iterate faster than large monolithic teams
- Each service owns its technology stack and deployment cycles

**Isolation and Resilience**
- If one component fails, other services continue functioning
- Enables graceful degradation without system-wide failures

**Scalability**
- Smaller components consume fewer resources
- Individual microservices can be scaled based on specific demand patterns

**Life Cycle Automation**
- Easier integration into continuous delivery pipelines
- Streamlined deployment for complex scenarios

**Business Alignment**
- Services are split along business domain boundaries
- Enhances organizational understanding and independence

### Deep Dive
The next lecture will demonstrate a practical microservices example for deployment on the EKS cluster.

## 25.2 Microservices Deployment on EKS - Introduction

### Overview
This lecture introduces a practical microservices deployment scenario on AWS EKS, incorporating additional AWS services beyond standard load balancing. The example includes two microservices that demonstrate inter-service communication and external service integration.

### Key Concepts

**Microservices Components**
- **User Management Microservice (UMS)**: Provides APIs for create, list, delete users, and health status
- **Notification Microservice**: Handles send notification API and health status
- Both services are independent units that can communicate with each other
- UMS creates users in a database and triggers email notifications via the Notification service

**Integration Flow**
| Step | Action | Service |
|------|--------|---------|
| 1 | Create User via API | User Management Microservice |
| 2 | Store user in Users DB | User Management Microservice → RDS |
| 3 | Call Send Notification API | User Management Microservice → Notification Microservice |
| 4 | Send email via SMTP | Notification Microservice → AWS SES |

### Architectural Overview
The deployment leverages AWS EKS with private subnets for enhanced security:

**Infrastructure Setup**
<pre>
                    ┌─────────────────┐
                    │   EKS Cluster   │
                    │  Control Plane  │
                    └─────────────────┘
                             │
                    ┌─────────────────┐
                    │ Private Subnets │
                    │     Workers     │
                    └─────────────────┘
</pre>

**Service Deployment Architecture**
```
Internet → ALB Ingress → UMS NodePort Service → UMS Pods → RDS DB
                                 ↓
                Notification ClusterIP Service → Notification Pods → SMTP SES
```

**Outbound Communication**
- Worker nodes in private subnets use NAT Gateway for external access
- Notification service connects to AWS Simple Email Service (SES) via NAT Gateway

**Load Balancing Strategy**
- **Application Load Balancer (ALB)**: Used via ALB Ingress Controller for microservices
- **NodePort Services**: Internal Kubernetes service exposure
- **ClusterIP Services**: Internal service-to-service communication

### AWS Service Integration
Additional AWS services integrated:
- **RDS Database**: User data storage
- **Simple Email Service (SES)**: Email notifications
- **Route 53**: DNS management with external-dns
- **Certificate Manager**: SSL/TLS certificates
- **NAT Gateway**: Outbound internet access from private subnets

## 25.3 Pre-requisite Checks

### Overview
This lecture covers essential prerequisites for deploying microservices on EKS, including database setup, ingress controllers, external DNS configuration, and AWS SES SMTP credentials generation. These steps ensure all dependencies are in place before deployment.

### Key Concepts

**Database Prerequisites**
- Amazon RDS instance must be running from previous sections
- MySQL External Name service manifest requires RDS endpoint replacement
- Database serves as the backend for User Management Microservice

**Ingress and DNS Prerequisites**
- **ALB Ingress Controller**: Must be installed and running in `ingress-nginx` namespace (from Section 08-01)
- **External DNS**: Must be running to auto-register DNS entries in Route 53 (from Section 08-06)
- These components enable internet-facing application access with automatic SSL termination

**SMTP Service Configuration (AWS SES)**
- Generate SMTP credentials for email sending capabilities
- Verify email addresses for testing (both sender and recipient addresses)
- Use verified email addresses to avoid SES sending restrictions

### AWS SES Setup Process

**Step 1: Generate SMTP Credentials**
1. Navigate to AWS SES Console → SMTP Settings
2. Click "Create my SMTP credentials"
3. Provide a name (e.g., "microservices-smtp-user")
4. Download and store credentials securely
```bash
# Credential Example
SMTP Username: AKIAEXAMPLEUSER
SMTP Password: BMTKnR2GXAMPLEPASSWORD
```

**Step 2: Verify Email Addresses**
1. In SES Console → Verified identities
2. Click "Verify a new email address"
3. Enter email addresses (minimum 2: sender and recipient)
4. Complete verification via received emails

**Step 3: Apply Settings**
Update Notification Microservice environment variables:
```yaml
- name: MAIL_SERVER_HOST
  value: "email-smtp.us-east-1.amazonaws.com"  # From SES SMTP settings
- name: MAIL_SERVER_USERNAME
  value: "AKIAEXAMPLEUSER"                   # Generated SMTP username
- name: MAIL_SERVER_PASSWORD
  value: "BMTKnR2GXAMPLEPASSWORD"             # Generated SMTP password
- name: MAIL_FROM
  value: "sender@example.com"                 # Verified sender email
```

> [!NOTE]
> SMTP credentials are unique to each AWS account and cannot be reused across accounts.

### Lab Demo: SES Setup

**Commands Executed**:
```bash
# 1. Generate SMTP credentials via SES Console
# 2. Verify email addresses via SES Console
# 3. Store credentials securely (do not commit to repository)
# 4. Update Notification service environment variables
```

**Verification Steps**:
- Confirm RDS database is running
- Verify ALB Ingress Controller and External DNS are operational
- Test email verification status in SES console

## 25.4 Review Notification Microservice Kubernetes Manifests

### Overview
This lecture reviews the Kubernetes manifests required for the Notification Microservice deployment on EKS, including deployment specifications, service configurations, and external service integrations.

### Key Concepts

**Notification Microservice Components**
- **Deployment Manifest**: Defines pod specifications and environment variables
- **ClusterIP Service**: Enables internal service discovery
- **External Name Service**: Provides access to AWS SES SMTP endpoint

### Notification Microservice Deployment Manifest

**Key Configuration Details**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: notification-microservice
spec:
  replicas: 1  # Scalable as needed
  selector:
    matchLabels:
      app: notification
  template:
    metadata:
      labels:
        app: notification
    spec:
      containers:
      - name: notification-service
        image: stacksimplify/kube-notification-microservice:1.0.0
        imagePullPolicy: Always  # Forces fresh image pull
        ports:
        - containerPort: 8096
        env:
        - name: MAIL_SERVER_HOST
          value: "smtp-service"  # References External Name Service
        - name: MAIL_SERVER_USERNAME
          valueFrom:
            secretKeyRef:
              name: notification-secret
              key: smtp-username
        - name: MAIL_SERVER_PASSWORD
          valueFrom:
            secretKeyRef:
              name: notification-secret
              key: smtp-password
        - name: MAIL_FROM
          value: "stacksimplify@gmail.com"
```

### Service Manifests

**ClusterIP Service**:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: notification-service
spec:
  selector:
    app: notification
  ports:
  - port: 8096
    targetPort: 8096
  type: ClusterIP
```

**External Name Service for SMTP**:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: smtp-service
spec:
  type: ExternalName
  externalName: email-smtp.us-east-1.amazonaws.com  # AWS SES SMTP endpoint
```

### Key Takeaways
- External Name Service pattern enables access to external AWS services
- Environment variables are configured for SMTP server connection
- Service uses port 8096 for both container and service exposure

## 25.5 Review User Management Microservice Kubernetes Manifests

### Overview
This lecture examines the Kubernetes manifests for User Management Microservice (UMS), including deployment configurations, service definitions, and Ingress setup for internet-facing access.

### Key Concepts

**UMS Microservice Components**
- **Deployment Manifest**: Main application deployment with database and notification service integration
- **NodePort Service**: Required for ALB Ingress Controller compatibility
- **External Name Service**: Database connectivity via RDS endpoint
- **Ingress Manifest**: ALB-based load balancing and SSL termination

### User Management Microservice Deployment Manifest

**Key Features**:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: usermgmt-webapp
spec:
  replicas: 2
  template:
    spec:
      containers:
      - name: usermgmt-webapp
        image: stacksimplify/kube-usermgmt-webapp:1.0.0
        env:
        # Database Configuration (RDS MySQL)
        - name: DB_HOSTNAME
          value: "mysql-service"
        - name: DB_USERNAME
          valueFrom:
            secretKeyRef:
              name: mysql-db-secret
              key: username
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-db-secret
              key: password
        - name: DB_NAME
          valueFrom:
            configMapKeyRef:
              name: usermgmt-db-config
              key: dbname
        # Inter-service Communication
        - name: NOTIFICATION_SERVICE_HOST
          value: "notification-service"  # References Notification ClusterIP
        - name: NOTIFICATION_SERVICE_PORT
          value: "8096"
```

### Service Configuration

**NodePort Service**:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: usermgmt-webapp-np-service
spec:
  selector:
    app: usermgmt-webapp
  ports:
  - port: 80
    targetPort: 8080
    nodePort: 31231  # Assigned by Kubernetes
  type: NodePort
```

### Ingress Configuration

**ALB Ingress Manifest**:
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: eks-microservices-demo
  annotations:
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/ssl-redirect: '443'
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-1:ACCOUNT_ID:certificate/CERTIFICATE_ID
spec:
  rules:
  - host: user-management.q1cloud.com
    http:
      paths:
      - path: /*
        pathType: Prefix
        backend:
          service:
            name: usermgmt-webapp-np-service
            port:
              number: 80
```

### Required Customizations
| Component | Customization Required |
|-----------|----------------------|
| RDS Endpoint | Update `externalName` in MySQL External Name Service |
| SSL Certificate | Replace certificate ARN with account-specific ACM ARN |
| Domain Name | Update host field with custom domain |
| Route 53 | Configure hosted zone for DNS resolution |

## 25.6 UMS & NS Microservices Deployment & Test

### Overview
This lecture demonstrates the complete deployment of microservices on EKS, including manifest application, service verification, and end-to-end testing using Postman. The deployment covers both User Management and Notification microservices with their interdependencies.

### Deployment Process

**Apply All Manifests**:
```bash
cd 12-microservices-deployment-on-eks
kubectl apply -f kube-manifests/
```

**Verify Deployment Status**:
```bash
kubectl get pods
kubectl get services
kubectl get ingress
```

### Service Verification

**External DNS Update**:
- Automatic creation of DNS entries in Route 53
- `user-management.q1cloud.com` and `services.q1cloud.com` registered

**Load Balancer Provisioning**:
- ALB automatically provisioned by ALB Ingress Controller
- SSL termination configured for HTTPS traffic

### Health Status Testing

**User Management Service**:
```bash
curl https://user-management.q1cloud.com/user/health-status
# Expected: "User Management Microservice is Up and Running"
```

**Notification Service** (via UMS)**:
```bash
curl https://user-management.q1cloud.com/notification/health-status
# Expected: "Notification Microservice is Up and Running V1"
```

### End-to-End API Testing with Postman

**Postman Environment Setup**:
```
Base URL: https://user-management.q1cloud.com
```

**API Test Scenarios**:

1. **List Users**:
   ```http
   GET /user/listUsers
   ```
   Sample Response:
   ```json
   [
     {"id": 1, "username": "admin", "email": "admin@example.com"},
     {"id": 2, "username": "testuser", "email": "test@example.com"}
   ]
   ```

2. **Create User with Email Notification**:
   ```http
   POST /user/createUser
   Content-Type: application/json
   
   {
     "username": "microtest1",
     "firstname": "Micro",
     "lastname": "Demo",
     "email": "recipient@example.com",
     "role": "user"
   }
   ```
   Expected Response:
   - HTTP 200: User created successfully
   - Email notification sent to specified address

### Inter-Service Communication Flow

**Create User Sequence**:
1. POST request → ALB Ingress → UMS NodePort Service → UMS Pod
2. User data stored in RDS MySQL database
3. UMS calls Notification service via ClusterIP service
4. Notification service sends email via SES SMTP
5. Email delivered to user's inbox

### Testing Results

**Database Verification**:
- New user appears in `/user/listUsers` response
- Data persisted in RDS instance

**Email Notification Verification**:
- AWS SES delivers email to verified recipient address
- Email content includes dynamic user information
- Outbound communication flows through NAT Gateway

### Complete Architecture Validation

```
Internet → AWS Route 53 → ALB → Ingress → NodePort → Pod → RDS
                                           ↓
                                   ClusterIP → Notification Pod → SMTP Service → SES
```

## 25.7 Microservices Rollout New Deployments and CleanUp

### Overview
This lecture demonstrates three methods for rolling out new microservice deployments in Kubernetes: `kubectl set image`, `kubectl edit`, and manifest updates. Each approach enables upgrading from version 1.0.0 to 2.0.0 while maintaining zero-downtime availability.

### Key Concepts

**Zero-Downtime Rolling Updates**
- Kubernetes default deployment strategy
- Gradual pod replacement maintains service availability
- Configurable via `RollingUpdateStrategy`

**Deployment Rollout Options**:
1. **kubectl set image**: Direct image version update
2. **kubectl edit**: Interactive manifest editing
3. **Manifest update**: Apply modified YAML files

### Rollout Strategies

**Method 1: kubectl set image**
```bash
kubectl set image deployment/notification-microservice notification-service=stacksimplify/kube-notification-microservice:2.0.0 --record
```

**Method 2: kubectl edit**
```bash
kubectl edit deployment/notification-microservice
# Edit image field from 1.0.0 to 2.0.0
```

**Method 3: Update and Apply Manifest**
```bash
# Edit kube-manifests/notification-microservice-deployment.yaml
# Change image tag to 2.0.0
kubectl apply -f kube-manifests/
```

### Rollout Monitoring and Management

**Check Rollout Status**:
```bash
kubectl rollout status deployment/notification-microservice
kubectl get rs  # View replica sets
kubectl rollout history deployment/notification-microservice
```

**Rollback Operations**:
```bash
kubectl rollout undo deployment/notification-microservice
# Reverts to previous revision
```

### Verification Process

**Version Identification**:
```bash
# Access notification health endpoint
curl https://user-management.q1cloud.com/notification/health-status
# Version changes from "V1" to "V2" after rollout
```

**Pod Lifecycle During Update**:
```
Time     Old Pods         New Pods        Status
------   --------------   --------------  -------
T0       2 running        0                Stable
T1       1 running        1 creating      Rolling
T2       0                2 running       Complete
```

### Clean Up Process

**Remove All Resources**:
```bash
kubectl delete -f kube-manifests/
# Removes all deployments, services, and ingress resources
```

> [!NOTE]
> Clean up preserves AWS resources (RDS, SES credentials, Route 53 records) for future use.

### Best Practices for Production Deployments

**Rolling Update Configuration**:
```yaml
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 25%
      maxSurge: 1
```

## Summary

### Key Takeaways
```diff
+ Microservices enable independent deployment and scaling of business capabilities
+ Inter-service communication requires careful service discovery configuration
+ External services integrate via Kubernetes External Name services
+ ALB Ingress provides internet-facing access with SSL termination
+ AWS SES integration handles email notifications with SMTP authentication
+ Zero-downtime rollouts are achievable through Kubernetes deployment strategies
+ Private subnet deployments require NAT gateways for external service access
- Monolithic applications cannot achieve the same level of scalability isolation
- Direct pod-to-pod communication bypasses network policies and security controls
- Improper resource limits can cause service disruptions during rollouts
```

### Quick Reference

**Essential Commands**:
```bash
# Deploy microservices
kubectl apply -f kube-manifests/

# Update image version
kubectl set image deployment/notification-microservice notification-service=stacksimplify/kube-notification-microservice:2.0.0

# Check rollout status
kubectl rollout status deployment/notification-microservice

# Rollback deployment
kubectl rollout undo deployment/notification-microservice

# Clean up resources
kubectl delete -f kube-manifests/
```

**Environment Variables**:
| Variable | Purpose | Example |
|----------|---------|---------|
| `DB_HOSTNAME` | RDS endpoint | `mysql-service` |
| `NOTIFICATION_SERVICE_HOST` | Service name | `notification-service` |
| `NOTIFICATION_SERVICE_PORT` | Service port | `8096` |
| `MAIL_SERVER_HOST` | SES endpoint | `email-smtp.us-east-1.amazonaws.com` |

**API Endpoints**:
- Health Check: `GET /user/health-status`
- List Users: `GET /user/listUsers`
- Create User: `POST /user/createUser`

### Expert Insight

**Real-world Application**: Microservices architecture enables organizations to scale development teams independently while maintaining system reliability. In production environments like e-commerce platforms, user management and notification services must handle millions of requests with guaranteed delivery and minimal latency.

**Expert Path**: Master service mesh technologies like Istio or Linkerd for advanced traffic management, circuit breaking, and observability. Learn distributed tracing with Jaeger and implement event-driven architectures using Kafka for complex microservice interactions.

**Common Pitfalls**: Avoid tight coupling between services through synchronous HTTP calls; implement circuit breakers and retry logic. Ensure proper API versioning strategies and maintain backward compatibility. Never hardcode external service endpoints - always use Kubernetes ConfigMaps and Secrets.

</details>
