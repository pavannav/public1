# Section 7: EKS Storage Introduction to EBS CSI Driver

<details open>
<summary><b>Section 7: EKS Storage Introduction to EBS CSI Driver (G3PCS46)</b></summary>

## Table of Contents
- [7.1 EKS Storage Introduction](#71-eks-storage-introduction)
- [7.2 Install EBS CSI Driver](#72-install-ebs-csi-driver)
- [7.3 Create Kubernetes Manifests for Storage Class, PVC and ConfigMap](#73-create-kubernetes-manifests-for-storage-class-pvc-and-configmap)
- [7.4 Create Kubernetes Manifests for MySQL Deployment & ClusterIP Service](#74-create-kubernetes-manifests-for-mysql-deployment--clusterip-service)
- [7.5 Test by connecting to MySQL Database](#75-test-by-connecting-to-mysql-database)
- [7.6 Storage References](#76-storage-references)
- [7.7 Create Kubernetes Manifests for User Management Microservice Deployment](#77-create-kubernetes-manifests-for-user-management-microservice-deployment)
- [7.8 Test User Management Microservice with MySQL Database in Kubernetes](#78-test-user-management-microservice-with-mysql-database-in-kubernetes)
- [7.9 Test User Management Microservice UMS using Postman](#79-test-user-management-microservice-ums-using-postman)

## 7.1 EKS Storage Introduction

### Overview
This lecture introduces Amazon EKS storage options, focusing on the Container Storage Interface (CSI) drivers for persistent storage, particularly the EBS CSI driver for Elastic Block Store volumes in AWS environments.

### Key Concepts/Deep Dive

EKS storage includes several CSI drivers and provisioners:
- **Legacy EBS Provisioner**: Deprecated, avoid using for new implementations
- **EBS CSI Driver**: Recommended for persistent volumes using Elastic Block Store
- **EFS CSI Driver**: For network file system storage 
- **FSx CSI Driver**: For Windows file system storage (supported from Kubernetes 1.16+)

Key characteristics of EBS CSI Driver:
- **Lifecycle Management**: EKS manages EBS volumes creation, attachment, and deletion through CSI driver
- **Block Level Storage**: Provides block-level storage mounted as device volumes on EC2 instances
- **Persistence**: Volumes persist independently of EC2 instance lifecycle
- **Dynamic Configuration**: Supports changing volume size, I/O configuration
- **Use Cases**: Optimal for database applications requiring random reads/writes, high-throughput workloads

> **Note**: EBS CSI driver is not supported on AWS EKS Fargate (serverless infrastructure).

### Architecture Overview

The demonstration builds a complete MySQL database deployment with persistent storage:
```
EKS Cluster
├── Storage Class (EBS CSI)
├── Persistent Volume Claim (Dynamic Provisioning)
├── ConfigMap (Database schema initialization)
├── MySQL Deployment (with persistent volumes)
├── MySQL ClusterIP Service
├── User Management Microservice Deployment
└── User Management NodePort Service
```

## 7.2 Install EBS CSI Driver

### Overview
This step demonstrates installing the AWS EBS CSI driver on an EKS cluster using EKS Add-ons with Pod Identity for secure AWS service access.

### Key Concepts/Deep Dive

Prerequisites:
- EKS cluster with appropriate IAM permissions
- Pod Identity enabled

Installation Process:
1. **Navigate to EKS Add-ons**: Access cluster's "Add-ons" section
2. **Select EBS CSI Driver**: Choose "AWS EBS CSI Driver" add-on
3. **Configure Pod Identity**: 
   - Use ECS Pod Identity for authentication
   - Create new IAM role with required policies:
     - `AmazonEBSCSIDriverPolicy`
     - `AmazonECSClusterPolicy`

The CSI driver consists of multiple components:
- **CSI Controller**: Deployment managing volume lifecycle (runs on control plane)
- **CSI Node**: DaemonSet running on each worker node for volume mounting

Verification commands:
```bash
kubectl get pods -n kube-system
kubectl get daemonsets -n kube-system
```

### Code/Configuration Blocks

IAM Role Trust Policy (auto-generated):
```json
{
  "Version": "2012-10-17",
  "Principal": {
    "Service": "pods.eks.amazonaws.com"
  },
  "Action": [
    "sts:AssumeRole",
    "sts:TagSession"
  ]
}
```

Add-on Configuration:
- Add-on Name: AWS EBS CSI Driver
- Version: Latest stable (e.g., v0.5.0+)
- IAM Role: Amazon ECS Pod identity Amazon EBS CSI driver role

## 7.3 Create Kubernetes Manifests for Storage Class, PVC and ConfigMap

### Overview
Create core Kubernetes storage manifests: StorageClass for EBS CSI driver, PersistentVolumeClaim with wait-for-first-consumer binding mode, and ConfigMap for MySQL database schema initialization.

### Key Concepts/Deep Dive

**Storage Class Manifest**:
- **Provisioner**: `ebs.csi.aws.com` (AWS EBS CSI driver)
- **Volume Binding Mode**: `WaitForFirstConsumer` - delays volume provisioning until pod scheduling, ensuring co-location in same availability zone
- **Reclaim Policy**: Default `Delete` (volumes deleted when PVC removed)

**Persistent Volume Claim Manifest**:
- **Access Modes**: `ReadWriteOnce`
- **Storage Class**: Reference to EBS StorageClass
- **Storage Request**: 4Gi allocation

**WaitForFirstConsumer vs Immediate Binding**:
```diff
+ Benefits: Ensures volume and pod in same AZ, prevents scheduling conflicts
- Drawback: PVC remains "Pending" until pod creation
```

**ConfigMap Manifest**:
- **Purpose**: Database schema initialization script
- **Mount Method**: Referenced as volume in deployment
- **Script Content**: SQL commands executed during container startup:
  - Drop existing user_mgmt database
  - Create new user_mgmt database

### Code/Configuration Blocks

Storage Class Manifest:
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-storage-class
provisioner: ebs.csi.aws.com
volumeBindingMode: WaitForFirstConsumer
```

Persistent Volume Claim Manifest:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: ebs-mysql-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: ebs-storage-class
  resources:
    requests:
      storage: 4Gi
```

ConfigMap Manifest:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: user-mgmt-db-creation-script
data:
  mysql_user_mgmt.sql: |
    DROP DATABASE IF EXISTS user_mgmt;
    CREATE DATABASE user_mgmt;
```

Deployment Commands:
```bash
kubectl apply -f kube-manifest/
kubectl get sc
kubectl get pvc
kubectl get pv
```

## 7.4 Create Kubernetes Manifests for MySQL Deployment & ClusterIP Service

### Overview
Create a complete MySQL deployment with persistent storage mounts, environment variables, and ClusterIP service for internal cluster access.

### Key Concepts/Deep Dive

**Deployment Strategy**: `Recreate` (single replica database, no rolling updates)

**Pod Template Components**:
- **Volume Mounts**: Persistent storage for database files, ConfigMap for initialization script
- **Environment Variables**: Database credentials and configuration

**Volume Configuration**:
- **Persistent Volume**: Maps PVC claim for data persistence
- **ConfigMap Volume**: Mounts schema creation script for container initialization

**Container Configuration**:
- **Image**: `mysql:5.6`
- **Ports**: 3306 (MySQL default)
- **Volume Mount Points**:
  - `/var/lib/mysql`: Persistent database files
  - `/docker-entrypoint-initdb.d`: Schema initialization scripts

**Docker Entrypoint Behavior**: 
- Executes scripts in `/docker-entrypoint-initdb.d/` directory during first container startup
- Creates specified databases and runs initialization scripts

### Code/Configuration Blocks

MySQL Deployment Manifest:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  labels:
    app: mysql
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
        ports:
        - containerPort: 3306
          name: mysql-port
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "dbpassword11"
        volumeMounts:
        - name: mysql-persistent-storage
          mountPath: /var/lib/mysql
        - name: user-mgmt-db-creation-script
          mountPath: /docker-entrypoint-initdb.d/
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: ebs-mysql-pvc
      - name: user-mgmt-db-creation-script
        configMap:
          name: user-mgmt-db-creation-script
```

MySQL ClusterIP Service Manifest:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  selector:
    app: mysql
  ports:
  - port: 3306
  clusterIP: None  # Use pod IP directly for headless service
```

## 7.5 Test by connecting to MySQL Database

### Overview
Test the deployed MySQL database by connecting via kubectl exec and client pod, verifying schema creation and persistent volume operation.

### Key Concepts/Deep Dive

**Connection Methods**:
- **Internal Connection**: Use kubectl run with MySQL client container
- **Interactive Terminal**: `--it --rm` flags for temporary debugging container
- **Authentication**: Root credentials from deployment environment variables

**Verification Steps**:
1. Connect to MySQL with client container
2. Check available schemas/databases
3. Verify user_mgmt database creation via ConfigMap
4. Confirm persistent volume binding and pod status

### Code/Configuration Blocks

Connect to MySQL Database:
```bash
kubectl run -it --rm mysql-client --image=mysql:5.6 --restart=Never \
  -- mysql -h mysql -u root -pdbpassword11
```

MySQL Commands:
```sql
SHOW SCHEMAS;
USE user_mgmt;
SHOW TABLES;
```

Verification Commands:
```bash
kubectl get pods
kubectl get pvc
kubectl get pv
kubectl get services
```

## 7.6 Storage References

### Overview
Review AWS EBS CSI driver documentation, features, limitations, and additional configuration options for production deployments.

### Key Concepts/Deep Dive

**Feature Status (as of v0.5.0+)**:
- **Stable**: Dynamic provisioning, static provisioning, mount options, block volumes
- **Beta**: Volume snapshots, volume resizing 
- **Alpha**: None (features may be unstable)

**Key Configuration Options**:
- **Volume Resizing**: Add `allowVolumeExpansion: true` to StorageClass
- **Snapshots**: Create VolumeSnapshot objects for backup/restore
- **Block Volumes**: Support for raw block device mounting

### Code/Configuration Blocks

EBS CSI Driver Links:
- [EBS CSI Driver Documentation](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
- [CSI Driver Examples](https://github.com/kubernetes-sigs/aws-ebs-csi-driver/tree/master/examples)

StorageClass with Expansion:
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: ebs-storage-class
provisioner: ebs.csi.aws.com
allowVolumeExpansion: true
volumeBindingMode: WaitForFirstConsumer
```

## 7.7 Create Kubernetes Manifests for User Management Microservice Deployment

### Overview
Create deployment and NodePort service for a Spring Boot user management microservice that connects to the MySQL database via environment variables.

### Key Concepts/Deep Dive

**Microservice Requirements**:
- Environment variables for database connection
- Container port 8095 for application
- Labels matching service selectors

**Environment Configuration**:
- Database host, port, schema, credentials
- Maps to MySQL ClusterIP service

**Service Configuration**:
- NodePort type for external access
- Custom nodePort (31231) for consistent access

### Code/Configuration Blocks

User Management Deployment Manifest:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user-mgmt-microservice
  labels:
    app: user-mgmt-rest-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: user-mgmt-rest-app
  template:
    metadata:
      labels:
        app: user-mgmt-rest-app
    spec:
      containers:
      - name: user-mgmt-rest-app
        image: stacksimplify/kube-usermgmt-microservice:1.0.0
        ports:
        - containerPort: 8095
        env:
        - name: DB_HOSTNAME
          value: "mysql"
        - name: DB_PORT
          value: "3306"
        - name: DB_NAME
          value: "user_mgmt"
        - name: DB_USERNAME
          value: "root"
        - name: DB_PASSWORD
          value: "dbpassword11"
```

User Management NodePort Service Manifest:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: user-mgmt-rest-app-service
  labels:
    app: user-mgmt-rest-app
spec:
  type: NodePort
  selector:
    app: user-mgmt-rest-app
  ports:
  - port: 8095
    targetPort: 8095
    nodePort: 31231
```

## 7.8 Test User Management Microservice with MySQL Database in Kubernetes

### Overview
Deploy complete stack (storage + MySQL + user management service) and verify connectivity, service discovery, and external access via NodePort.

### Key Concepts/Deep Dive

**Deployment Order Issues**:
- User management service may start before MySQL readiness
- Results in container restarts during dependency initialization
- Temporary solution: Manual redeployment after dependencies stabilize

**Service Discovery**:
- Microservice connects via DNS name "mysql" (ClusterIP service)
- Environment variables provide connection details

**Access Patterns**:
- External access via NodePort on worker node public IP
- Health check endpoint: `/usermgmt/health-status`

### Code/Configuration Blocks

Complete Stack Deployment:
```bash
cd 0403-user-management-microservice-with-mysql-db
kubectl apply -f kube-manifest/
kubectl get pods
kubectl get services
kubectl get nodes -o wide  # Get node external IP
```

Health Check URL:
```
http://<worker-node-public-ip>:31231/usermgmt/health-status
```

## 7.9 Test User Management Microservice UMS using Postman

### Overview
Test the user management REST API endpoints using Postman, verifying CRUD operations and data persistence in MySQL database with EBS storage.

### Key Concepts/Deep Dive

**Postman Setup**:
- Import collection: AWS EKS Masterclass Microservices Postman Collection
- Create environment with NodePort URL variable
- Configure base URL: `http://<worker-node-public-ip>:31231`

**API Endpoints**:
- POST `/usermgmt/user`: Create user
- GET `/usermgmt/user`: List all users  
- PUT `/usermgmt/user`: Update user
- DELETE `/usermgmt/user/{username}`: Delete user

**Notification Integration**: 
- User creation attempts to send notifications (fails if notification service not deployed)
- Core user management functions work independently

**Database Verification**:
- Connect to MySQL via client pod
- Query user_mgmt.users table
- Confirm CRUD operations reflect in persistent storage

### Code/Configuration Blocks

Postman Environment Setup:
```json
{
  "name": "UMS NodePort Environment",
  "values": [
    {
      "key": "url",
      "value": "http://<worker-node-external-ip>:31231"
    }
  ]
}
```

Sample User Creation Payload:
```json
{
  "username": "admin1",
  "email": "admin1@example.com", 
  "role": "admin",
  "enabled": true,
  "firstName": "First1",
  "lastName": "Last1",
  "password": "password123"
}
```

MySQL Data Verification:
```bash
kubectl run -it --rm mysql-client --image=mysql:5.6 --restart=Never \
  -- mysql -h mysql -u root -pdbpassword11 -e "
  USE user_mgmt;
  SELECT * FROM users;
  SHOW TABLES;
  "
```

Cleanup Commands:
```bash
kubectl delete -f kube-manifest/
kubectl get all
```

## Summary

### Key Takeaways
> **📝 Core Components**: Section 7 demonstrates complete persistent storage implementation using EBS CSI driver, covering StorageClass, PVC, ConfigMap, and database deployment with volume persistence.

> **✅ Critical Concepts**: 
> - CSI driver architecture and lifecycle management
> - Dynamic volume provisioning with `WaitForFirstConsumer` binding mode  
> - Volume mount configurations and Docker entrypoint initialization
> - Environment variable-driven microservice configuration
> - Service discovery in Kubernetes clusters

> **⚠ Common Issues**: User management service startup before MySQL readiness, solved with Init Containers in future sections.

### Quick Reference

**Storage Setup Commands**:
```bash
# Install EBS CSI Driver via EKS Add-ons
# Configure Pod Identity and IAM role

# Deploy storage and database stack
kubectl apply -f kube-manifest/

# Verify PVC binding
kubectl get pvc

# Connect to MySQL
kubectl run -it --rm mysql-client --image=mysql:5.6 --restart=Never \
  -- mysql -h mysql -u root -pdbpassword11
```

**Postman API Collection**:
- Health Check: GET `{{url}}/usermgmt/health-status`
- Create User: POST `{{url}}/usermgmt/user`
- List Users: GET `{{url}}/usermgmt/user`
- Update User: PUT `{{url}}/usermgmt/user`  
- Delete User: DELETE `{{url}}/usermgmt/user/{username}`

### Expert Insight

**Real-world Application**: 
Use EBS CSI driver for stateful applications requiring persistent block storage in EKS. Implement `WaitForFirstConsumer` binding mode in multi-AZ clusters to ensure volume-pod co-location and prevent cross-zone mounting issues.

**Expert Path**: 
Master advanced EBS features like volume snapshots for disaster recovery and volume resizing for storage scaling. Combine with Kubernetes storage policies for automated storage class selection based on workload requirements.

**Common Pitfalls**: 
Avoid deploying applications dependent on persistent storage without proper startup ordering. Use Init Containers to ensure database readiness before application startup, preventing unnecessary container restarts and potential data corruption during initialization.

</details>
