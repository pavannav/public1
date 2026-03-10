# Section 09: EKS Storage and RDS Integration

<details open>
<summary><b>Section 09: EKS Storage and RDS Integration (Claude Code)</b></summary>

## Table of Contents

- [9.1 Step-01- EKS Storage - RDS DB Introduction](#91-step-01--eks-storage---rds-db-introduction)
- [9.2 Step-02- Create RDS DB](#92-step-02--create-rds-db)
- [9.3 Step-03- Create Kubernetes ExternalName Service & Other Manifests, Deploy & Test](#93-step-03--create-kubernetes-externalname-service--other-manifests-deploy--test)

## 9.1 Step-01- EKS Storage - RDS DB Introduction

### Overview

Section 9 addresses production database challenges by replacing self-hosted MySQL pods and EBS volumes with managed AWS RDS MySQL, eliminating persistence complications and AZ attachment issues.

### Key Concepts

**Problems with Self-Hosted Database:**
- **EBS Limitations**: Single AZ attachment, complex resize operations
- **Pod Lifecycle**: Database recreation on pod termination risks data loss
- **Resource Constraints**: Manual scaling and backup management
- **Complexity**: Storage classes, PVC creation, volume binding

**Benefits of RDS Integration:**
- **Managed Service**: Automated backups, patches, and high availability
- **Multi-AZ**: Cross-AZ replication for redundancy
- **Scaling**: Storage and compute scale independent of application
- **External Connectivity**: Connect from any application architecture

### What You'll Learn

- Create RDS database in private subnets
- Configure VPC security groups for private connectivity
- Implement Kubernetes ExternalName service for DNS aliasing
- Update application manifests for external database connection
- Verify connectivity and data persistence without pod restarts

> [!NOTE]
> This establishes cloud-native database patterns vs containerized databases

## 9.2 Step-02- Create RDS DB

### Overview

Complete RDS MySQL database setup in private VPC subnets with security group configuration, enabling secure connectivity from Kubernetes pods without internet exposure.

### Key Concepts

**VPC Architecture:**
- **Private Subnets**: Database isolation from public internet
- **Same AZ as Cluster**: Minimizes latency and data transfer costs
- **NAT Gateway Access**: Worker nodes communicate with RDS via NAT

**Security Configuration:**
- **VPC-only Access**: No public accessibility
- **Security Group Restrictions**: Limited to Kubernetes cluster communication
- **DB Subnet Group**: Multi-AZ private subnet specification

### Code/Config Blocks

**RDS Database Specification:**
- **Engine**: MySQL 5.7/8.0 (Latest available)
- **Instance Class**: db.t2.micro (Free tier for testing)
- **Storage**: 20GB GP2 SSD
- **Multi-AZ**: Disabled (can be enabled for production)
- **Public Access**: Disabled

**Network Configuration:**
```yaml
# VPC: eks-ctl-eks-demo-one-vpc
# DB Subnet Group: eks-rds-db-subnet-group
# Private Subnets: us-east-1a-private, us-east-1b-private
# Security Group: eks-rds-db-sg (MySQL port 3306)
```

### Commands

```bash
# AWS CLI - Create DB Subnet Group
aws rds create-db-subnet-group \
  --db-subnet-group-name eks-rds-db-subnet-group \
  --db-subnet-group-description "DB Subnet Group for EKS RDS" \
  --subnet-ids subnet-12345678 subnet-87654321 \
  --vpc-id vpc-abcdef12

# Create RDS DB
aws rds create-db-instance \
  --db-instance-identifier usermgmt-db \
  --db-instance-class db.t2.micro \
  --engine mysql \
  --master-username dbadmin \
  --master-user-password dbpass11 \
  --allocated-storage 20 \
  --db-subnet-group-name eks-rds-db-subnet-group \
  --vpc-security-group-ids sg-12345678 \
  --no-publicly-accessible
```

### Important Infrastructure Setup

```
├── VPC (eks-ctl-eks-demo-one-vpc)
│   ├── Private Subnet us-east-1a (10.0.64.0/19)
│   ├── Private Subnet us-east-1b (10.0.96.0/19)
│   ├── NAT Gateway (for EKS to RDS communication)
│   └── Security Groups
│       └── eks-rds-db-sg (MySQL 3306)
│           └── Ingress: TCP 3306 from eks-cluster-sg
```

> [!IMPORTANT]
> Database creation takes 10-15 minutes. Use this time to prepare Kubernetes manifests.

**Endpoint Discovery:**
After creation, copy the database endpoint URL for ExternalName service configuration.

## 9.3 Step-03- Create Kubernetes ExternalName Service & Other Manifests, Deploy & Test

### Overview

Kubernetes ExternalName service creates DNS alias for RDS database endpoint, enabling pods to connect via standard Kubernetes service discovery while ExternalName routes traffic externally.

### Key Concepts

**ExternalName Service Benefits:**
- **DNS Aliasing**: `mysql` service name resolves to RDS endpoint
- **Zero Proxying**: Unlike ClusterIP, doesn't create kube-proxy rules
- **External Abstraction**: Applications connect to standard service name, unaware of RDS
- **Load Balancing**: Inherent in RDS multi-AZ setup

**Connectivity Flow:**
```
Pod → ExternalName Service (mysql.default.svc.cluster.local)
       ↓
Resolves to → RDS Endpoint (usermgmt-db.xxxx.rds.amazonaws.com)
       ↓
Connects via → MySQL 3306 protocol
```

### Code/Config Blocks

```yaml
---
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  type: ExternalName
  externalName: usermgmt-db.xxxx.region.rds.amazonaws.com

---
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secrets
type: Opaque
data:
  username: ZGJhZG1pbg==  # dbadmin (base64)
  password: ZGJwYXNzMTE=  # dbpass11 (base64)
  database: dXNlcm1nbXQ=  # usermgmt (base64)

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: usermgmt-microservice
spec:
  template:
    spec:
      containers:
      - name: usermgmt-rest-app
        env:
        - name: DB_HOST
          value: "mysql"
        - name: DB_PORT
          value: "3306"
        - name: DB_USER
          valueFrom:
            secretKeyRef:
              name: mysql-secrets
              key: username
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secrets
              key: password
        - name: DB_NAME
          valueFrom:
            secretKeyRef:
              name: mysql-secrets
              key: database
```

### Lab Demos

**Database Connectivity Test:**
```bash
# Create schema manually from cluster
kubectl run mysql-client --image=mysql:5.6 --rm -i --tty --restart=Never \
  -- mysql -h mysql -u dbadmin -pdbpass11 usermgmt

# Inside MySQL shell
CREATE DATABASE usermgmt;
USE usermgmt;
SELECT DATABASE();
```

**Application Verification:**
```bash
kubectl get svc mysql -o wide
# Check ExternalName resolution

kubectl logs -f usermgmt-microservice-xxxxx
# Verify successful external database connection
```

### Commands

```bash
# Deploy RDS-integrated stack
kubectl apply -f kube-manifests/

# Verify service resolution
nslookup mysql.default.svc.cluster.local
# Should resolve to RDS endpoint

# Test connectivity
kubectl run test-mysql --image=mysql:5.6 --rm -i --tty --restart=Never \
  -- mysql -h mysql.default.svc.cluster.local -u dbadmin -pdbpass11 -e "SELECT VERSION();"
```

### Key Takeaways

```diff
+ ExternalName services provide seamless DNS translation to external resources
+ RDS enables production-ready database without persistence complexity
+ Private subnet isolation prevents direct internet access
+ Kubernetes service discovery works transparently with external endpoints
+ No PVC/PV/EBS management overhead
```

### Quick Reference

**Essential Components:**
1. **RDS Security Group**: Allow MySQL 3306 from Kubernetes CIDR
2. **DB Subnet Group**: Private subnets in node AZs
3. **ExternalName Service**: Maps mysql → RDS endpoint
4. **Secrets**: Base64 encoded credentials
5. **Environment Variables**: Service-alias-based configuration

**Connectivity Verification:**
```bash
# DNS resolution test
kubectl run dns-test --image=busybox --rm -it --restart=Never -- \
  nslookup mysql.default.svc.cluster.local

# Database connection test
kubectl run db-test --image=mysql:5.6 --rm -it --restart=Never -- \
  sh -c 'mysql -h mysql -u dbadmin -pdbpass11 usermgmt -e "SELECT 1;"'
```

### Expert Insight

**Production Architecture Decision:**
- **RDS vs Self-hosted**: Choose RDS for managed HA/backup/scaling
- **ExternalName vs ConfigMaps**: ExternalName preferred for DNS benefits
- **Security**: Use parameter groups for encryption, audit logs
- **Cost Optimization**: Smaller instance classes with Aurora read replicas
- **Backup Strategy**: Automated RDS snapshots + cross-region

**Common Pitfalls**:
- ❌ Database in different AZ than nodes (latency/latency spike)
- ❌ Public RDS access enabled (security risk)
- ❌ ExternalName creation order dependency
- ❌ Schema provision race conditions (use init containers)
- ❌ RDS timeout configurations from Kubernetes