# Session 37: Statefulset Demo for MariaDB, RabbitMQ, Avoid Privileged Pods using SecurityContext

## Table of Contents
- [Recap of StatefulSets](#recap-of-statefulsets)
- [StatefulSets for Databases](#statefulsets-for-databases)
- [Marketplace Deployment](#marketplace-deployment)
- [MariaDB Galera Cluster Architecture](#mariadb-galera-cluster-architecture)
- [MariaDB Deployment Demo](#mariadb-deployment-demo)
- [RabbitMQ Deployment Demo](#rabbitmq-deployment-demo)
- [Q&A on Kubernetes Questions](#QA-on-kubernetes-questions)
- [Avoid Privileged Pods using SecurityContext](#avoid-privileged-pods-using-securitycontext)
- [Summary](#summary)

## Recap of StatefulSets

### Overview
StatefulSets provide stable storage and networking for stateful applications. Unlike Deployments, StatefulSets ensure ordered pod deployment, stable hostnames, and persistent volumes tied to specific pods, preventing data loss during pod restarts.

### Key Concepts
StatefulSets are ideal for workloads like databases, message queues, or any service requiring persistent data and reliable identity. Key differences from Deployments include:
- **Ordered Creation**: Pods deploy sequentially, ensuring each is ready before the next starts.
- **Stable Hostnames**: Pods use ordinal indexes (e.g., statefulset-name-0, -1).
- **Bound Persistent Storage**: Each pod links to a unique PersistentVolumeClaim (PVC), maintaining data consistency.

Problems with Deployments for stateful workloads:
- Pod names and IPs are dynamic.
- PVCs can detach and reattach incorrectly, leading to data mixing.
- No guaranteed stable network identity.

Headless Services pair with StatefulSets to allow direct pod DNS resolution (e.g., pod-name.service-name.namespace.svc.cluster.local).

## StatefulSets for Databases

### Overview
Databases demand high availability, data persistence, and consistent networking. StatefulSets address these for clustered databases like MariaDB or messaging systems like RabbitMQ.

### Key Concepts
Pros of running databases in Kubernetes:
- Cloud-agnostic deployment.
- Simplified portability.

Cons (overhead):
- Managing backups, patches, and high availability.
- Requires database expertise.

Primary use case: StatefulSets ensure:
- Stable pod identities for replication.
- Dedicated persistent disks per pod.

Examples: MySQL/MariaDB for relational databases, RabbitMQ for message queuing.

## Marketplace Deployment

### Overview
Google Cloud Marketplace offers pre-configured Kubernetes workloads, including stateful applications. These use standard Kubernetes objects like Deployments, StatefulSets, and ConfigMaps for quick deployment.

### Key Concepts
Key features of Marketplace deployments:
- Pre-built YAML with kubernetes objects (StatefulSets, Services, ConfigMaps, Secrets).
- Supports autoscaling and user-defined storage classes.
- Costs: Infrastructure only; software is free.
- Prerequisites: Appropriate service accounts, compatible Kubernetes versions.

Deployment Steps:
1. Select solution (e.g., MariaDB).
2. Configure cluster settings (nodes, VM types).
3. Specify storage (e.g., premium SSD for performance) and replicas.
4. Deploy and monitor via Console.

Monitor with `kubectl watch` for resources like jobs, PVCs, PVs, StatefulSets, pods.

### Lab Demos

#### MariaDB Deployment
- Cluster setup: Zonal Kubernetes cluster with autoscaling (min 3 nodes).
- Storage: 32GB SSD per replica (3 replicas).
- Objects created: Job (for installation), StatefulSets, PVCs, ConfigMaps, Secrets.
- Commands to monitor:
  ```
  kubectl get jobs
  kubectl get pvc
  kubectl get pv
  kubectl get sts
  kubectl get pods
  kubectl get svc
  kubectl get cm
  ```
- Pod structure: 3 replicas with names like mariadb-galera-0, -1, -2; each with 2 containers (MariaDB + exporter for replication).

#### Configuration
Access database:
```
kubectl exec -it mariadb-galera-0 -- bash
mysql -u root -p
```

Create database and table:
```
CREATE DATABASE demo;
USE demo;
CREATE TABLE employee (name VARCHAR(50), id INT);
INSERT INTO employee VALUES ('employee1', 100);
INSERT INTO employee VALUES ('employee2', 101);
```

Data replicates across pods:
- Use `SHOW DATABASES;` and `SELECT * FROM employee;` to verify.

Service configurations (via kubectl get cm and kubectl get secrets):
- ConfigMaps store non-sensitive configs (e.g., MariaDB config files).
- Secrets store sensitive data (e.g., password in base64-encoded format).

PVCs and PVs:
- Each pod attaches to a unique 32GB SSD PVC.
- Retrieve root password from secrets for access.

## MariaDB Galera Cluster Architecture

### Overview
The MariaDB Galera cluster is a multi-master database setup where any node handles reads/writes, with automatic replication via synchronous multi-threading.

### Key Concepts
Load balancer not required; StatefulSet + Headless Service ensures direct pod access.
Components in YAML:
- StatefulSet: Replicas (3), ordered creation, volume claim templates.
- Service: Headless (clusterIP: None), ports (3306 for MySQL, exporter port).
- ConfigMaps: MySQL configs.
- Secrets: TLS certs, passwords.
- PVCs: Persistent storage per pod.
- Init Containers: Pre-configure environment before main containers.
- Security: End-to-end encryption.

Multiple tiers prevent issues (e.g., init containers update configs without making mounts read-only).

### Table: Object Roles
| Object Type | Role |
|-------------|------|
| StatefulSet | Manages replicas, volumes, ordered creation. |
| Service (Headless) | Provides DNS for pod access. |
| ConfigMap | Stores configs (e.g., my.cnf). |
| Secret | Stores TLS certs, passwords. |
| PV/PVC | Persistent storage. |
| Job | One-time setup. |
| Init Container | Pre-populates ConfigMap data. |

## RabbitMQ Deployment Demo

### Overview
RabbitMQ requires persistent storage for queues and exchanges. StatefulSets ensure stable broker identities.

### Key Concepts
Marketplace YAML includes:
- StatefulSet with 3 replicas.
- HDD storage (5GB per pod).
- Components: ConfigMaps, Secrets, PVCs.

Deployment and Access:
- Similar process: Deploy, wait for resources.
- Service: User `rabbit` or retrieve from secrets (base64 decode).
- Web UI access: Port 15672; external IP via LoadBalancer or port forwarding.

Port Forwarding Example:
```
kubectl port-forward svc/rabbitmq 8080:15672
```
Then access via browser (localhost:8080).

Pod structure: 3 pods with stable names; direct access via headless service.

## Q&A on Kubernetes Questions

### Overview
Interactive responses clarify concepts through practical examples, reinforcing learning via demos over theory.

### Key Concepts

Example 1: Scaling StatefulSets
- Question: Can StatefulSets scale replicas?
- Answer: Yes, but with ordered operations. Use `kubectl scale sts <name> --replicas=<n>`.

Example 2: Persistent Data Replica Scaling
- Question: What happens to data on pod deletion?
- Answer: Data persists in PVC; pod recreation reattaches.

Example 3: Standalone Pods vs. Deployments/Services
- Question: Can standalone pods expose services?
- Answer: No; selectors exist only in controllers (e.g., Deployments). Demos confirm service creation fails without selectors.

### Lab Demos

#### Scaling MariaDB StatefulSet
```
kubectl scale sts mariadb-galera --replicas=2
```
- Reduces replicas; attempts to scale back may fail if issues (e.g., ordered creation blocks partial failure).

#### Standalone Pod Service Demo
- YAML with pod and service; apply fails due to missing selector in pod spec.
- Alternative: Use Deployment for replications and services.

## Avoid Privileged Pods using SecurityContext

### Overview
Security best practices prevent containers from running as root (high privilege), reducing exploit risks. Use SecurityContext for non-root users.

### Key Concepts
Privileged pods (default root) allow unrestricted actions (e.g., install malware), communicating laterally.
Non-privileged pods:
- Run as low-privilege user (e.g., UID 1000+).
- Uses `runAsUser`, `runAsGroup` in pod spec.

Shortcomings:
- External images may require SecurityContext additions.
- Custom images: Define users in Dockerfile (e.g., `USER appuser`).
- Port conflicts: Privileged ports (<1024) fail without root (e.g., port 80). Use >1024 or delegate to load balancers.

### Lab Demos

#### Adding SecurityContext to Existing Pod
For cloud-sdk image:
```
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 1000
```
- Prompts change from `#` (root) to `$` (non-root).
- Prevents installation (e.g., `apt-get install` fails).

#### Custom Dockerfile with Non-Privileged User
Dockerfile example:
```
FROM node:alpine
RUN addgroup -g 2000 appgroup && adduser -D -u 2000 -G appgroup appuser
USER appuser
CMD ["node", "server.js"]
```

Build and deploy:
```
docker build -t artifact/image:1.0 .
kubectl apply -f pod.yaml
```
- Verifies with `whoami` showing appuser.

Security considerations:
- Package dependencies in Dockerfile; avoid runtime installs.
- Use high UIDs (>1000) to avoid conflicts.
- Test thoroughly; ensure apps bind to >1024 ports.

## Summary

### Key Takeaways
```diff
+ StatefulSets enable stable identity and storage for stateful apps like databases and queues.
- Deployments lack ordered scaling and persistent bindings, risking data inconsistencies.
! Avoid privileged pods by using SecurityContext for non-root execution.
+ Marketplace simplifies deployments but requires careful configuration.
- Secure containers mean packaging tools in images, not runtime installations.
```

### Quick Reference
- Commands:
  ```
  kubectl exec -it <pod> -- /bin/bash  # Access pod
  kubectl port-forward svc/<service> 8080:<port>  # External access
  Docker build -t <image> . && docker push <image>  # Build/deploy custom image
  ```
- Config snippets:
  ```
  securityContext:
    runAsUser: 2000
    runAsGroup: 2000
  ```
  Dockerfile user:
  ```
  FROM node:alpine
  RUN addgroup -g 2000 appgroup && adduser -D -u 2000 -G appgroup appuser
  USER appuser
  ```

### Expert Insight

#### Real-world Application
Run production databases (e.g., MariaDB) on Kubernetes StatefulSets for seamless scaling and HA. Use SecurityContext in CI/CD pipelines to enforce non-privileged containers, aligning with CIS benchmarks for Kubernetes security. Monitor with liveness/readiness probes (upcoming topic).

#### Expert Path
Master StatefulSets by experimenting with cluster replicas and failure simulations (e.g., `kubectl delete pod`). Integrate with Helm for templated deployments. Advance to RBAC with ServiceAccounts for Marketplace workloads.

#### Common Pitfalls
Avoid default root users; test port bindings (>1024 recommended). Ensure PVC reclaim policies to prevent data leaks. Mind ordered scaling—failed pods block further actions.

#### Lesser-Known Facts
Headless services enable DNS-based pod discovery. Init containers modify ConfigMaps without read-only mounts. Galera clusters use multi-master for zero-downtime writes/read.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
