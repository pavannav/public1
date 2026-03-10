# Section 07: EKS Storage and User Management Microservice

<details open>
<summary><b>Section 07: EKS Storage and User Management Microservice (Claude Code)</b></summary>

## Table of Contents

- [7.1 Step-01- EKS Storage Introduction](#71-step-01--eks-storage-introduction)
- [7.2 Step-02- Install EBS CSI Driver](#72-step-02--install-ebs-csi-driver)
- [7.3 Step-03- Create Kubernetes Manifests for Storage Class, PVC and ConfigMap](#73-step-03--create-kubernetes-manifests-for-storage-class-pvc-and-configmap)
- [7.4 Step-04- Create Kubernetes Manifests for MySQL Deployment & ClusterIP Service](#74-step-04--create-kubernetes-manifests-for-mysql-deployment--clusterip-service)
- [7.6 Step-06- Storage References](#76-step-06--storage-references)
- [7.7 Step-07- Create Kubernetes Manifests for User Management Microservice Deployment](#77-step-07--create-kubernetes-manifests-for-user-management-microservice-deployment)
- [7.8 Step-08- Test User Management Microservice with MySQL Database in Kubernetes](#78-step-08--test-user-management-microservice-with-mysql-database-in-kubernetes)
- [7.9 Step-09- Test User Management Microservice UMS using Postman](#79-step-09--test-user-management-microservice-ums-using-postman)

## 7.1 Step-01- EKS Storage Introduction

### Overview

EKS storage encompasses various drivers and provisioners for persistent volumes. The focus is on the EBS CSI driver, which provides modern container storage interface support for Amazon Elastic Block Store.

### Key Concepts

- **CSI Drivers vs Legacy Provisioners**: CSI drivers are the current standard for Kubernetes storage, replacing deprecated legacy provisioners
- **EBS CSI Driver**: Manages EBS volume lifecycle, supports dynamic provisioning, and integrates with EKS Pod Identity
- **Supported Kubernetes Versions**: Driver works with Kubernetes 1.14+ and is production-ready
- **Use Cases**: Ideal for databases, applications needing fast random I/O, and long-term data persistence

### Table: Storage Drivers Comparison

| Driver | Provisioner | Status | Use Case |
|--------|-------------|--------|----------|
| EBS CSI | ebs.csi.aws.com | Production Ready | General persistent storage |
| EFS CSI | efs.csi.aws.com | Production Ready | Shared file storage |
| FSx CSI | fsx.csi.aws.com | Beta (Windows) | High-performance file systems |

### What You'll Learn

- Installing EBS CSI driver via EKS Add-ons
- Dynamic volume provisioning vs static
- Creating StorageClass, PVC, and ConfigMap manifests
- MySQL deployment with persistent volumes
- User management microservice integration

> [!NOTE]
> EBS is not supported on EKS Fargate - only EC2 node groups

### Code/Config Blocks

```yaml
# Sample StorageClass
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
```

## 7.2 Step-02- Install EBS CSI Driver

### Overview

Installation of the EBS CSI driver using EKS Add-ons with ECS Pod Identity for secure AWS service access without explicit IAM role management.

### Key Concepts

**Installation Steps:**
1. EKS Console → Cluster → Add-ons → Get more add-ons
2. Select "Amazon EBS CSI Driver"
3. IAM access: Choose "ECS Pod Identity"
4. Create recommended IAM role
5. Install add-on

**Installed Components:**
- **ebs-csi-controller**: Manages volume provisioning/deletion
- **ebs-csi-node**: DaemonSet for volume attachment to nodes

### Commands

```bash
# Verify installation
kubectl get pods -n kube-system | grep ebs
kubectl get daemonset ebs-csi-node -n kube-system
```

### Expected Output

```
NAME                 READY   STATUS    RESTARTS   AGE
ebs-csi-controller-0   6/6     Running   0          2m
```

> [!IMPORTANT]
> Pod Identity eliminates complex IAM role annotations required by the legacy approach

## 7.3 Step-03- Create Kubernetes Manifests for Storage Class, PVC and ConfigMap

### Overview

Core Kubernetes manifests required for dynamic volume provisioning: StorageClass for provisioning logic, PersistentVolumeClaim for requesting storage, and ConfigMap for database initialization scripts.

### Key Concepts

**StorageClass Manifest:**
- Provisioner: `ebs.csi.aws.com`
- `volumeBindingMode: WaitForFirstConsumer`: Delays volume creation until pod scheduling

**PersistentVolumeClaim:**
- Access mode: ReadWriteOnce
- Storage request: 4Gi
- References StorageClass for provisioning

**ConfigMap for MySQL:**
- Contains SQL scripts to initialize the database
- Mounted as init scripts in MySQL container

### Code/Config Blocks

```yaml
# StorageClass
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-sc
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer

---
# PVC
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-mysql-pvc
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: ebs-sc
  resources:
    requests:
      storage: 4Gi

---
# ConfigMap for DB init
apiVersion: v1
kind: ConfigMap
metadata:
  name: usermgmt-db-creation-script
data:
  mysql_usermgmt.sql: |
    DROP DATABASE IF EXISTS usermgmt;
    CREATE DATABASE usermgmt;
```

### Commands

```bash
kubectl apply -f kube-manifests/
kubectl get sc,pvc,cm
```

### Key Takeaways

- `WaitForFirstConsumer` ensures volume AZ matches pod AZ
- ConfigMap enables automated database schema creation

## 7.4 Step-04- Create Kubernetes Manifests for MySQL Deployment & ClusterIP Service

### Overview

Complete MySQL deployment with persistent volumes, environment variables for configuration, volume mounts for data persistence, and database initialization scripts.

### Key Concepts

**Deployment Features:**
- Recreate strategy for database safety (no RollingUpdate)
- Single replica
- Environment variables for MySQL configuration
- Two volume mounts: persistent data and init scripts

**Service Configuration:**
- ClusterIP type (internal cluster access)
- Headless service (`clusterIP: None`) for direct pod access

### Code/Config Blocks

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
spec:
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:5.6
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "dbpass11"
        ports:
        - containerPort: 3306
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
        - name: usermgmt-db-creation-script
          mountPath: /docker-entrypoint-initdb.d
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: ebs-mysql-pvc
      - name: usermgmt-db-creation-script
        configMap:
          name: usermgmt-db-creation-script

---
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  clusterIP: None
  selector:
    app: mysql
  ports:
  - port: 3306
```

## 7.6 Step-06- Storage References

### Overview

Reference guide for EBS CSI driver features, current versions, and advanced configurations with examples for different use cases.

### Key Concepts

**Driver Version Status:**
- EBS CSI Driver v1.0+: Production ready
- Features: Dynamic/static provisioning, snapshots (alpha), resizing (alpha)

**StorageClass Variants:**
```yaml
# With expansion enabled
allowVolumeExpansion: true

# With parameters
parameters:
  type: gp3
  encrypted: "true"
  iops: "3000"
```

### Code/Config Blocks

```yaml
# Full-featured StorageClass
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-advanced
provisioner: ebs.csi.aws.com
allowVolumeExpansion: true
volumeBindingMode: WaitForFirstConsumer
parameters:
  encrypted: "true"
  type: gp3
```

## 7.7 Step-07- Create Kubernetes Manifests for User Management Microservice Deployment

### Overview

Spring Boot microservice deployment that connects to the MySQL database via environment variables, demonstrating application integration with persistent storage.

### Key Concepts

**Environment Configuration:**
- DB_HOST: MySQL service name
- DB_USER, DB_PASSWORD, DB_NAME: Database credentials
- DB_PORT: MySQL port

**Service Ports:**
- Application port: 8080
- Actuator endpoint: 9066

**API Structure:**
- /usermgmt/users (GET, POST, PUT, DELETE with ID)

### Code/Config Blocks

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: usermgmt-microservice
spec:
  replicas: 1
  selector:
    matchLabels:
      app: usermgmt
  template:
    metadata:
      labels:
        app: usermgmt
    spec:
      containers:
      - name: usermgmt
        image: stacksimplify/kube-usermgmt:v1
        env:
        - name: DB_HOST
          value: "mysql"
        - name: DB_USER
          value: "root"
        - name: DB_PASSWORD
          value: "dbpass11"
        - name: DB_NAME
          value: "usermgmt"
        - name: DB_PORT
          value: "3306"
        ports:
        - containerPort: 8080
          name: usermgmt-port
        - containerPort: 9066
          name: actuator-port
```

## 7.8 Step-08- Test User Management Microservice with MySQL Database in Kubernetes

### Overview

Testing database connectivity and data persistence by verifying schema creation, running SQL queries, and checking application connectivity.

### Key Commands

```bash
# Deploy microservice
kubectl apply -f 08-usermgmt-deployment.yml

# Verify connections
kubectl get pods
kubectl logs -f usermgmt-microservice-xxxxx

# Database connectivity test
kubectl run mysql-client --image=mysql:5.6 --rm -i --tty --restart=Never -- mysql -h mysql -P 3306 -u root -pdbpass11 usermgmt

# Inside MySQL shell
USE usermgmt;
SHOW TABLES;
SELECT * FROM users;
```

### Expected Results

- Database schema automatically created via ConfigMap
- Microservice logs show successful database connection
- Users table exists with proper schema

## 7.9 Step-09- Test User Management Microservice UMS using Postman

### Overview

Complete REST API testing workflow using Postman to validate CRUD operations and confirm data persistence across pod lifecycles.

### API Testing Steps

#### 1. Get All Users (Initially empty)
- **Method**: GET
- **URL**: `http://<load-balancer-url>/usermgmt/users`
- **Response**: `[]`

#### 2. Create New User
- **Method**: POST
- **Headers**: `Content-Type: application/json`
- **Body**:
```json
{
  "email": "john.doe@example.com",
  "firstname": "John",
  "lastname": "Doe"
}
```

#### 3. Verify User Creation
- **Method**: GET
- **URL**: `http://<load-balancer-url>/usermgmt/users`
- **Response**: User list with John Doe

#### 4. Get Specific User
- **Method**: GET
- **URL**: `http://<load-balancer-url>/usermgmt/users/1`

#### 5. Update User
- **Method**: PUT
- **URL**: `http://<load-balancer-url>/usermgmt/users/1`
- **Body**: Updated user data

#### 6. Delete User
- **Method**: DELETE
- **URL**: `http://<load-balancer-url>/usermgmt/users/1`

### Data Persistence Verification

```bash
# Connect to database and verify data remains
kubectl run mysql-client --image=mysql:5.6 --rm -i --tty --restart=Never -- mysql -h mysql -P 3306 -u root -pdbpass11
USE usermgmt;
SELECT * FROM users;
```

### Lab Demos

**Pod Recreation Test:**
```bash
kubectl delete pod usermgmt-microservice-xxxxx
kubectl get pods  # New pod created
kubectl run mysql-client --image=mysql:5.6 --rm -i --tty --restart=Never -- mysql -h mysql -P 3306 -u root -pdbpass11 usermgmt
# Query shows data still exists
```

## Summary

### Key Takeaways

```diff
+ EBS CSI Driver enables dynamic persistent storage with Pod Identity
+ volumeBindingMode prevents cross-AZ attachment issues
+ ConfigMaps provide automated database initialization
+ Environment variables configure secure database connections
+ Data persists independently of pod lifecycle
+ Applications integrate seamlessly with persistent MySQL storage
```

### Quick Reference

**Essential Manifests:**
- StorageClass: `provisioner: ebs.csi.aws.com`
- PVC: `volumeBindingMode: WaitForFirstConsumer`
- Deployment: `strategy: type: Recreate` for DB safety
- Service: `clusterIP: None` for headless access
- ConfigMap: Mount to `/docker-entrypoint-initdb.d/`

**Common Commands:**
```bash
kubectl get sc,pvc,cm,pods,svc
kubectl logs -f <pod-name>
kubectl run mysql-client --image=mysql:5.6 -it --rm --restart=Never -- mysql -h mysql -u root -pdbpass11
```

### Expert Insight

**Real-world Application**: EBS-backed MySQL deployments support content management systems, user databases, and any persistent data requirements in Kubernetes.

**Expert Path**:
- Implement backup strategies with CSI snapshots
- Configure automated volume expansion with HPA
- Use RDS instead of pods for true production deployments
- Implement connection pooling and monitoring

**Common Pitfalls**:
- ❌ Forgetting `volumeBindingMode` causing volume-pod AZ mismatch
- ❌ Using RollingUpdate strategy with databases risking data corruption
- ❌ Exposing database ports directly without security considerations
- ❌ Not implementing proper backup/restore procedures