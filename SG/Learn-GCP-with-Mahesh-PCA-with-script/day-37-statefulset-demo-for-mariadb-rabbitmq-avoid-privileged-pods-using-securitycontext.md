# Session 37: Statefulset Demo for MariaDB, RabbitMQ, Avoid Privileged Pods Using SecurityContext

## Table of Contents
- [Recap of StatefulSet Concepts](#recap-of-statefulset-concepts)
- [StatefulSet Use Case: MariaDB Galera Cluster](#statefulset-use-case-mariadb-galera-cluster)
  - [Creating the Database Cluster via Marketplace](#creating-the-database-cluster-via-marketplace)
  - [Exploring Components and Architecture](#exploring-components-and-architecture)
  - [Demonstrating Replication and Data Persistence](#demonstrating-replication-and-data-persistence)
- [StatefulSet Use Case: RabbitMQ Cluster](#statefulset-use-case-rabbitmq-cluster)
  - [Deploying RabbitMQ via Marketplace](#deploying-rabbitmq-via-marketplace)
  - [Management Interface and Scaling](#management-interface-and-scaling)
- [Question and Answer Session](#question-and-answer-session)
- [Avoiding Privileged Pods with SecurityContext](#avoiding-privileged-pods-with-securitycontext)
  - [Security Risks and Best Practices](#security-risks-and-best-practices)
  - [Demonstrating Non-Privileged Containers](#demonstrating-non-privileged-containers)
  - [Creating Custom Non-Privileged Images](#creating-custom-non-privileged-images)
- [Summary Section](#summary-section)

## Recap of StatefulSet Concepts

### Overview
In this session, we revisit the core concepts of StatefulSet, building on our previous StatefulSet introduction. StatefulSet is crucial for managing stateful applications requiring stable hostnames, persistent storage, and ordered deployment/scaling. We recap key differences from Deployments and explore practical implementations using real database and messaging services.

### Key Concepts/Deep Dive

StatefulSet provides stable hostnames and persistent storage that Deployment objects cannot match. Here's a comparison:

| Feature | Deployment | StatefulSet |
|---------|------------|-------------|
| Pod Names | Randomly generated | Sequential (e.g., app-0, app-1, app-2) |
| Storage | Requires separate PVC creation | Volume Claim Templates for automatic PVCs |
| Scaling | No ordering guarantees | Ordered creation/deletion |
| Use Case | Stateless applications | Stateful databases like MySQL, Kafka |

**Key Properties of StatefulSet:**
- **Stable Identity**: Pods maintain consistent names even after restarts
- **Stable Storage**: Each pod connects to its dedicated persistent storage
- **Ordered Operations**: Pods are created and scaled in sequence
- **Headless Service**: Enables direct pod communication without load balancing

### Code/Config Blocks

A basic StatefulSet YAML structure:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql-cluster
spec:
  serviceName: mysql-headless
  replicas: 3
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
        image: mysql:8.0
        env:
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: password
  volumeClaimTemplates:
  - metadata:
    name: mysql-pvc
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 32Gi
```

### Lab Demos
**Demo 1: Listing StatefulSet Objects**
```bash
kubectl get statefulsets -o wide
kubectl get sts  # Short form
```

**Demo 2: Describing StatefulSet Components**
```bash
kubectl describe sts mariadb-galera-cluster
kubectl get pods -o wide  # Shows stable pod names
```

## StatefulSet Use Case: MariaDB Galera Cluster

### Overview
Demonstrating StatefulSet with a real-world database cluster shows practical implementation of persistence and replication. MariaDB Galera Cluster provides multimaster MySQL-compatible database with automatic failover and data synchronization across nodes.

### Key Concepts/Deep Dive

Galera Cluster provides:
- **Multimaster Architecture**: All nodes can read/write data
- **Automatic Replication**: Changes sync across nodes instantly
- **No Single Point of Failure**: If one pod crashes, others continue operating
- **Eventually Consistent**: All nodes share the same state

Components used:
- **StatefulSet Controller**: Manages 3 replicas with ordered scaling
- **Headless Service**: Enables stable DNS resolution for pod-to-pod communication
- **Persistent Volume Claims**: Each pod has dedicated 32GB SSD storage
- **ConfigMap and Secrets**: Store configuration and credentials
- **Init Containers**: Prepare environment before main database container

### Code/Config Blocks

**Headless Service for MariaDB:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mariadb-service
spec:
  clusterIP: None  # Headless service
  selector:
    app: mariadb
  ports:
  - name: mysql
    port: 3306
    targetPort: 3306
```

**Persistent Volume Claim Template:**
```yaml
volumeClaimTemplates:
- metadata:
  name: data
  spec:
  accessModes: ["ReadWriteOnce"]
  storageClassName: premium-rwo  # SSD storage
  resources:
    requests:
      storage: 32Gi
```

**Container Configuration:**
```yaml
containers:
- name: mariadb
  image: mariadb:10.11
  ports:
  - containerPort: 3306
  env:
  - name: MYSQL_ROOT_PASSWORD
    valueFrom:
      secretKeyRef:
        name: mariadb-secret
        key: password
  volumeMounts:
  - name: data
    mountPath: /var/lib/mysql
```

### Lab Demos

#### Creating the Database Cluster via Marketplace
1. Navigate to Google Cloud Marketplace → Kubernetes apps → Search "MariaDB"
2. Select "MariaDB Galera cluster"
3. Configure:
   - Cluster size: 3
   - Storage class: premium-rwo (SSD)
   - Storage: 32 Gb per node
4. Deploy to default namespace
5. Monitor deployment:

```bash
kubectl get all
kubectl watch kubectl get pods,pvc,services  # Watch resources creation
```

#### Exploring Components and Architecture
```bash
# View all resources
kubectl get sts,pods,pvc,services,cm,secrets

# Connect to a pod
kubectl exec -it mariadb-galera-cluster-0 -- bash

# Inside pod, connect to MySQL
mysql -u root -p  # Password from secret
```

#### Demonstrating Replication and Data Persistence
```bash
# In first replica (pod-0)
mysql> CREATE DATABASE demo;
mysql> USE demo;
mysql> CREATE TABLE employee (id INT, name VARCHAR(50));
mysql> INSERT INTO employee VALUES (1, 'John');

# In second replica (pod-1), verify replication
mysql> USE demo;
mysql> SELECT * FROM employee;  # Should show data instantly

# Delete first pod to test data persistence
kubectl delete pod mariadb-galera-cluster-0

# After pod restarts, verify data persists
kubectl exec -it mariadb-galera-cluster-0 -- mysql -u root -p demo -e "SELECT * FROM employee;"
```

## StatefulSet Use Case: RabbitMQ Cluster

### Overview
RabbitMQ is a robust messaging broker that benefits from StatefulSet's stable identity and storage. This demo shows how messaging services with state (queues, exchanges) can leverage StatefulSet for production deployments.

### Key Concepts/Deep Dive

RabbitMQ cluster features:
- **Clustering**: Multiple nodes share queue definitions and bindings
- **High Availability**: Queues mirror across nodes
- **Management Interface**: Web UI for monitoring and administration
- **AMQP Protocol**: Standard messaging protocol support

StatefulSet roles:
- **Ordered Deployment**: Ensures cluster bootstrap sequence
- **Stable Hostnames**: Nodes can find each other reliably
- **Persistent Queues**: Message queues survive pod restarts

### Code/Config Blocks

**RabbitMQ StatefulSet Example:**
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: rabbitmq-cluster
spec:
  serviceName: rabbitmq-headless
  replicas: 3
  template:
    spec:
      containers:
      - name: rabbitmq
        image: rabbitmq:3.12-management
        ports:
        - containerPort: 5672  # AMQP
        - containerPort: 15672  # Management
        env:
        - name: RABBITMQ_ERLANG_COOKIE
          valueFrom:
            secretKeyRef:
              name: rabbitmq-secret
              key: cookie
        volumeMounts:
        - name: data
          mountPath: /var/lib/rabbitmq
  volumeClaimTemplates:
  - metadata:
    name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

### Lab Demos

#### Deploying RabbitMQ via Marketplace
1. Search "RabbitMQ" in Marketplace
2. Configure cluster with 3 replicas
3. Enable management interface
4. Deploy to dedicated namespace

```bash
kubectl get namespaces
kubectl create ns rabbitmq
kubectl apply -f rabbitmq-cluster.yaml -n rabbitmq
```

#### Management Interface and Scaling
```bash
# Get management UI URL
kubectl get service -n rabbitmq  # Look for load balancer IP

# Login to http://EXTERNAL_IP:15672
# Username: admin (from secret)
# Password: admin123 (from secret)

# Scale cluster
kubectl scale sts rabbitmq-cluster --replicas=5 -n rabbitmq
kubectl get pods -n rabbitmq  # Display ordered scaling (0,1,2,3,4)
```

## Question and Answer Session

### Overview
This Q&A session reinforces StatefulSet concepts through practical scenarios commonly encountered in GCP Associate Cloud Engineer exam and real-world deployments.

### Key Concepts/Deep Dive

**Question 1:** You have a web application deployed in GKE with multiple microservices using MySQL database. You need to scale database replicas while maintaining consistent hostnames across restarts.

**Answer:** StatefulSet with persistent volume claim templates.

**Question 2:** Your microservices need to communicate internally with load balancing across pods of different services.

**Answer:** Deploy each microservice as Deployment objects, expose with ClusterIP services, use DNS names for pod-to-pod communication.

**Question 3:** Standalone pods with services vs. Deployment objects with services.

**Code/Config Blocks:**

```yaml
# Valid: Deployment with Service
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
---
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  selector:
    app: my-app
  ports:
  - port: 80
```

**Question 4:** Demonstrating service-pod interaction:

```bash
# Create standalone pod
kubectl apply -f pod-with-service.yaml

# Check if selector works (it won't)
kubectl describe svc my-service  # Shows 0 endpoints

# This proves pods cannot be directly exposed via services - need controller objects
```

## Avoiding Privileged Pods with SecurityContext

### Overview
SecurityContext prevents running containers as root user, reducing attack surface. This is critical for production deployments where privilege escalation could compromise the cluster.

### Key Concepts/Deep Dive

**Security Risks:**
- Root containers allow installation of malicious tools
- Can expose cluster secrets or sensitive data
- Enable lateral movement within the cluster
- Violate principle of least privilege

**SecurityContext Implementation:**
- Run containers as non-root user
- Drop unnecessary capabilities
- Use read-only root filesystem
- Apply at pod level (affects all containers)

### Code/Config Blocks

**Pod-Level SecurityContext:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secure-pod
spec:
  securityContext:
    runAsUser: 1000  # Non-root user
    runAsGroup: 1000
    fsGroup: 1000
    runAsNonRoot: true  # Explicit non-root
  containers:
  - name: secure-container
    image: nginx:alpine
    securityContext:
      allowPrivilegeEscalation: false
      readOnlyRootFilesystem: true
      runAsNonRoot: true
```

**Dockerfile for Non-Privileged Image:**
```dockerfile
FROM node:16-alpine

# Create non-root user
RUN addgroup -g 1000 appuser && \
    adduser -u 1000 -G appuser -s /bin/sh -D appuser

# Set working directory with correct permissions
WORKDIR /usr/src/app
RUN chown -R appuser:appuser /usr/src/app

USER appuser

EXPOSE 8080
CMD ["node", "server.js"]
```

### Lab Demos

#### Security Risks and Best Practices
```bash
# Demonstrate privileged container
kubectl exec -it privileged-pod -- sh
whoami  # Shows "root"
apt update && apt install -y curl  # Can install anything

# Demonstrate secure container
kubectl exec -it secure-pod -- sh
whoami  # Shows "appuser" or specific user
apt update  # Permission denied
```

#### Demonstrating Non-Privileged Containers
1. Use existing Cloud SDK image:
```bash
kubectl run cloud-sdk-pod --image=gcr.io/google.com/cloudsdktool/cloud-sdk:alpine \
  --restart=Never
kubectl exec -it cloud-sdk-pod -- sh
whoami  # Shows "cloudsdk" (non-root)
id -u   # Shows 1337 (non-zero UID)
```

2. Apply SecurityContext to convert privileged containers:
```yaml
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
```

#### Creating Custom Non-Privileged Images
```dockerfile
FROM node:alpine

RUN adduser -u 2000 -G appgroup -s /bin/sh -D appuser

USER appuser

COPY . /app
EXPOSE 8080
CMD ["node", "server.js"]
```

```bash
# Build and push
docker build -t gcr.io/project-id/secure-app:v1 .
docker push gcr.io/project-id/secure-app:v1

# Deploy
kubectl run secure-app --image=gcr.io/project-id/secure-app:v1
kubectl exec -it secure-app -- sh
whoami  # Shows "appuser"
```

**Important Port Considerations:**
```yaml
# Privileged ports (<1024) require root
containers:
- name: web-server
  image: nginx:alpine
  ports:
  - containerPort: 80  # FAILS with securityContext

# Use non-privileged ports
containers:
- name: web-server
  image: nginx:alpine
  ports:
  - containerPort: 8080  # WORKS with securityContext
```

## Summary Section

### Key Takeaways
```diff
+ StatefulSet provides stable hostnames and ordered scaling for stateful apps like databases
- Deployment objects are unsuitable for applications requiring persistent identity
+ SecurityContext prevents privilege escalation by enabling non-root container execution
- Pack all dependencies in container images; don't install software dynamically in pods
+ Headless services enable direct pod communication while maintaining DNS resolution
- Privileged ports require root access; always use non-privileged ports (1024+) with SecurityContext
+ Volume claim templates auto-create PVCs for each StatefulSet replica
- Base images may run as root; explicitly configure non-root users in Dockerfiles
```

### Expert Insight

#### Real-world Application
StatefulSet + SecurityContext combinations are industry standard for production databases. Google Cloud SQL (managed) is great for simplicity, but StatefulSet gives full control for hybrid/multi-cloud deployments where multiple Kubernetes clusters need consistent database state. SecurityContext with proper RBAC prevents lateral movement attacks that could compromise entire clusters.

#### Expert Path
Master StatefulSet by implementing complex clusters like Cassandra or Elasticsearch that require head services and custom storage classes. Learn Kubernetes security admission controllers to enforce SecurityContext policies cluster-wide. Deepen your knowledge with etcd backup strategies and disaster recovery procedures for stateful workloads.

#### Common Pitfalls
1. **Forgetting ordered scaling**: StatefulSet scales sequentially - if pod-0 fails, scaling operations wait. Always check pod status before scaling.
2. **SecurityContext port conflicts**: Using privileged ports (80, 443) with non-root users causes failures. Design applications with configurable, non-privileged ports.
3. **Resource cleanup**: StatefulSet PVCs persist after deletion. Use `--cascade=foreground` when deleting StatefulSets to ensure PVC cleanup.
4. **Credential management**: Never embed secrets in ConfigMaps. Use Kubernetes Secrets with proper RBAC permissions for sensitive data access.

Lesser known aspects:
- **Pod disruption budgets**: Combine with StatefulSet for controlled rolling updates during maintenance
- **Init containers with SecurityContext**: Even init containers respect pod-level SecurityContext when performing privileged operations like changing file permissions
- **Storage class selection**: Premium SSDs are essential for database workloads, but consider capacity limits vs. actual IOPS requirements for cost optimization
