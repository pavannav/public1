<details open>
<summary><b>Day-002 DevOps Mock Interview (KK-CS45-script-v2-Interview)</b></summary>

## Q1
**Question:** What are your day-to-day activities as a DevOps Engineer?

**Answer:** The candidate checks JIRA applications for emails and tickets, performs application monitoring including checking Kubernetes services, Docker, and CI/CD pipelines health issues.

## Ideal Answer
As a DevOps engineer, my day-to-day activities include monitoring application health through Kubernetes dashboards, reviewing CI/CD pipeline status, responding to system alerts and tickets, managing infrastructure resources, and ensuring continuous deployment processes run smoothly. I typically start by checking monitoring dashboards for any alerts, reviewing overnight pipeline runs, and then addressing any incidents or tickets that require attention.

## Concept
DevOps engineers serve as the bridge between development and operations, focusing on automation, monitoring, and maintaining reliable software delivery pipelines while ensuring system stability.

## Real-World Use Cases
- Managing production Kubernetes clusters serving millions of users
- Monitoring e-commerce platform during Black Friday sales events
- Ensuring zero-downtime deployments for financial trading systems
- Managing infrastructure costs through resource optimization

## Advantages
- Enables rapid, reliable software releases
- Reduces manual operational overhead
- Provides immediate visibility into system health
- Facilitates quick incident response

## Disadvantages
- High cognitive load from managing multiple systems
- Requires deep understanding of both development and operations
- Can lead to alert fatigue if monitoring isn't tuned properly
- Complexity increases with scale

## Common Misconceptions
- Thinking DevOps is just about tools rather than culture and processes
- Assuming monitoring only involves watching dashboards without actionable insights
- Believing CI/CD pipelines run without maintenance and optimization needs

---

## Q2
**Question:** How do you troubleshoot a pod that is in CrashLoopBackOff state?

**Answer:** Check logs using `kubectl logs <pod-name> -n <namespace>`, use `kubectl describe pod <pod-name> -n <namespace>` to get detailed information, look for error messages indicating image pull errors, configuration issues, or insufficient resources. Check resource limits, configuration files like ConfigMaps and Secrets, and application health endpoints.

## Ideal Answer
When a pod is in CrashLoopBackOff state, systematically troubleshoot by: 1) Checking container logs with `kubectl logs` to identify application-level errors, 2) Using `kubectl describe pod` to examine events and pod conditions, 3) Verifying image pull success and configuration correctness, 4) Checking resource limits to ensure sufficient CPU/memory allocation, 5) Validating environment variables and mounted secrets/configmaps, and 6) Testing application health check endpoints.

## Concept
CrashLoopBackOff indicates a pod is repeatedly crashing and being restarted by Kubernetes. This state triggers when an application fails to start properly or crashes shortly after initialization, requiring investigation of both infrastructure and application-level issues.

## Real-World Use Cases
- Database container failing due to missing environment variables for connection strings
- Web application crashing from insufficient memory allocation during startup
- Microservice failing health checks due to dependency service unavailability
- Application startup failure from incorrect configuration file paths

## Advantages
- Systematic approach prevents missing critical diagnostic information
- Combines infrastructure and application-level debugging
- Provides clear next steps regardless of error type
- Helps distinguish between configuration, resource, and code issues

## Disadvantages
- Can be time-consuming when multiple potential causes exist
- Requires access to multiple Kubernetes API endpoints
- May need application source code access for deeper debugging
- Complex scenarios may require correlation across multiple pods

## Common Misconceptions
- Assuming CrashLoopBackOff is always an application code issue
- Ignoring resource limits as a potential cause
- Not checking if dependencies are available before the pod starts
- Overlooking namespace isolation issues

---

## Q3
**Question:** What is a StatefulSet and how does it differ from a Deployment?

**Answer:** A StatefulSet is used to deploy stateful applications like databases. Unlike Deployments used for stateless web servers, StatefulSets provide stable network identity, stable persistent storage with separate volumes per pod, ordered deployment and scaling, and unique pod names in sequence (pod-0, pod-1, pod-2) rather than hash-based naming.

## Ideal Answer
StatefulSets manage stateful applications requiring stable identities and ordered operations, while Deployments handle stateless applications. Key differences include: stable network identities with DNS names, persistent volume claims tied to specific pods, sequential pod creation/deletion/scaling, and ordered rolling updates. Deployments use shared storage and random pod naming, suitable for web servers and stateless APIs.

## Concept
StatefulSets address the unique requirements of stateful applications that need consistent network identities, ordered deployment, and persistent storage that survives pod rescheduling - essential for databases, message queues, and other stateful services.

## Real-World Use Cases
- Deploying MySQL clusters with master-slave replication requiring stable hostnames
- Running Apache ZooKeeper ensembles needing ordered startup and stable peer discovery
- Managing Elasticsearch clusters where node identity matters for data distribution
- Operating Cassandra rings requiring predictable node positioning in the ring topology

## Advantages
- Provides guaranteed ordering for stateful application startup
- Ensures data persistence and identity consistency across rescheduling
- Enables reliable peer discovery for distributed systems
- Supports graceful scaling operations with proper data handling

## Disadvantages
- More complex to configure and manage than simple Deployments
- Scaling operations take longer due to ordered processing
- Storage costs increase with per-pod persistent volumes
- Requires deeper understanding of stateful application architecture

## Common Misconceptions
- Using StatefulSets for stateless applications unnecessarily
- Assuming all databases require StatefulSets without considering managed services
- Not understanding the performance implications of ordered operations
- Confusing stable identity with high availability features

---

## Q4
**Question:** How do you secure a Kubernetes cluster?

**Answer:** Implement RBAC (Role-Based Access Control) to restrict user and application permissions, use Secrets management for storing sensitive data like passwords and API keys with encryption at rest, apply NetworkPolicies to control traffic flow between pods, enforce Pod Security Policies to restrict privileged containers and ensure read-only root filesystems, and maintain audit logs for troubleshooting and compliance.

## Ideal Answer
Kubernetes cluster security involves multiple layers: RBAC to control API access and define granular permissions, Secrets management with encryption for sensitive data, NetworkPolicies for pod-to-pod communication control, Pod Security Standards/Policies to enforce security contexts, and comprehensive audit logging. Start with RBAC and Secrets as foundational security measures, then layer additional controls based on risk assessment and compliance requirements.

## Concept
Kubernetes security follows a defense-in-depth approach, implementing multiple overlapping security controls at different layers of the infrastructure stack to protect against various attack vectors and ensure compliance with security policies.

## Real-World Use Cases
- Financial services requiring PCI-DSS compliance for payment processing workloads
- Healthcare systems handling PHI data requiring HIPAA compliance controls
- Multi-tenant SaaS platforms needing strict tenant isolation and access controls
- Government systems requiring FedRAMP compliance and detailed audit trails

## Advantages
- Provides comprehensive protection against various attack vectors
- Enables compliance with industry security standards and regulations
- Reduces blast radius of potential security incidents
- Provides audit trails for incident investigation and compliance reporting

## Disadvantages
- Increases operational complexity and potential for misconfiguration
- May impact application performance due to security overhead
- Requires ongoing maintenance and policy updates
- Can create friction between security requirements and developer productivity

## Common Misconceptions
- Assuming default Kubernetes security settings are sufficient for production
- Focusing only on network security while ignoring RBAC and secrets management
- Believing security policies will work without proper testing and validation
- Underestimating the operational overhead of security policy maintenance

---

## Q5
**Question:** What is Kubernetes Ingress and how does it differ from a LoadBalancer service?

**Answer:** Ingress is a resource that manages external HTTP/HTTPS access to services within a cluster, providing fine-grained routing control based on hostnames and paths. Unlike LoadBalancer services which expose services externally using cloud provider load balancers, Ingress sits inside the cluster and routes traffic to multiple services based on URL paths, supports TLS termination, and enables internal traffic routing between microservices.

## Ideal Answer
Ingress provides sophisticated HTTP/HTTPS routing capabilities within the cluster, acting as a reverse proxy and load balancer for external traffic. It enables path-based and host-based routing to different services, SSL termination, and canary deployments. LoadBalancer services use cloud provider load balancers to expose individual services externally, while Ingress provides centralized routing control for multiple services through a single external endpoint.

## Concept
Ingress acts as an API gateway and reverse proxy within Kubernetes, providing advanced traffic routing, SSL termination, and load balancing features that go beyond basic service exposure, enabling sophisticated traffic management patterns for microservices architectures.

## Real-World Use Cases
- Routing traffic to different microservices based on URL paths (/api/users → user-service, /api/orders → order-service)
- Implementing SSL termination and certificate management for multiple domains
- Canary deployments routing small percentages of traffic to new versions
- Multi-tenant applications requiring host-based routing for different customer domains

## Advantages
- Centralized traffic management with sophisticated routing rules
- Cost-effective compared to multiple LoadBalancer services
- Enables advanced traffic patterns like A/B testing and canary releases
- Provides SSL termination reducing certificate management complexity

## Disadvantages
- Additional complexity requiring Ingress controller management
- Single point of failure if not properly designed for high availability
- Limited to HTTP/HTTPS protocols (L7 load balancing)
- Requires understanding of both Ingress resources and controller-specific configurations

## Common Misconceptions
- Confusing Ingress with LoadBalancer services as equivalent solutions
- Assuming all Ingress controllers provide identical features and configurations
- Not considering Ingress controller high availability requirements
- Underestimating the complexity of Ingress rule management at scale

---

## Q6
**Question:** How do you perform a rolling update in Kubernetes?

**Answer:** Update the deployment image or configuration, then apply using `kubectl apply -f deployment.yml`. Kubernetes will gradually create new pods with updated configuration while replacing old pods. Monitor the update progress using `kubectl rollout status deployment/<name>`. The deployment spec includes replicas count, container images, and update strategy configuration.

## Ideal Answer
Rolling updates in Kubernetes are performed by updating the deployment specification (typically container image or environment variables) and applying the changes. Kubernetes uses the configured update strategy (RollingUpdate by default) to gradually replace old pods with new ones, ensuring zero downtime. The process involves updating the deployment, monitoring rollout status with `kubectl rollout status`, and optionally configuring maxUnavailable and maxSurge parameters to control the update pace and resource utilization during the transition.

## Concept
Rolling updates enable zero-downtime deployments by gradually replacing application instances, ensuring continuous availability while deploying new versions. Kubernetes manages the orchestration of old pod termination and new pod creation based on configured update parameters.

## Real-World Use Cases
- Deploying new application versions during business hours without service interruption
- Updating configuration across microservices fleets without coordinated downtime
- Rolling out security patches across production workloads seamlessly
- Implementing database schema migrations with application compatibility

## Advantages
- Zero downtime deployments maintaining service availability
- Automatic rollback capability using `kubectl rollout undo`
- Configurable update speed and availability parameters
- Health check integration ensuring only healthy pods receive traffic

## Disadvantages
- Requires applications to support graceful shutdown and startup
- May take longer than blue-green deployments for large replica counts
- Resource usage spikes during transition with both old and new versions running
- Complex failure scenarios when updates partially fail across pods

## Common Misconceptions
- Assuming all applications support rolling updates without modification
- Not configuring appropriate health checks for update validation
- Ignoring resource requirements during simultaneous old/new pod execution
- Expecting instant rollbacks without proper readiness probe configuration

</details>