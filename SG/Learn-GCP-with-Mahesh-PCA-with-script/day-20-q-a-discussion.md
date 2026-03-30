# Session 20: GCP MIG and Load Balancer Q&A Discussion

**Table of Contents**
- [Message Acknowledgement and Scaling Down](#message-acknowledgement-and-scaling-down)
- [Stabilization Period in Autoscaling](#stabilization-period-in-autoscaling)
- [Pub/Sub Topic Storage Capacity](#pubsub-topic-storage-capacity)
- [Health Checks for Multiple Ports in MIGs](#health-checks-for-multiple-ports-in-migs)
- [Load Balancers and Internal LBs for Multi-Port Applications](#load-balancers-and-internal-lbs-for-multi-port-applications)
- [Global vs Regional Load Balancers for High Availability](#global-vs-regional-load-balancers-for-high-availability)
- [Summary](#summary)

## Message Acknowledgement and Scaling Down

### Overview
In Google Cloud Pub/Sub, messages persist in the queue until they are acknowledged by subscribers. Acknowledgement is required for each message, after which the message is deleted, indicating utilization has occurred. This process ties into scaling down managed instance groups (MIGs), where VMs may not scale down immediately after message processing due to stabilization periods.

### Key Concepts/Deep Dive
- **Message Acknowledgement Process**:
  - Once a message is published, it remains in the queue until acknowledged.
  - Subscribers must send an acknowledgement signal for each message to confirm processing.
  - After acknowledgement, the message is deleted, and the associated VM utilization is considered complete.
  
- **Scaling Down Behavior**:
  - Post-acknowledgement, the MIG checks for reduced load.
  - Scaling down (scale-in) does not occur instantly; it requires a stabilization period.
  - During this period, the autoscaler monitors capacity to ensure peak load can still be met before removing instances.

> [!IMPORTANT]
> Acknowledgement must be handled for every message to prevent resource wastage, but scaling actions are not immediate.

### Lab Demos
No explicit code or config blocks were demonstrated for this topic. The discussion emphasized monitoring acknowledgement timestamps to observe scaling triggers (e.g., at 7:36 PM in the demo).

## Stabilization Period in Autoscaling

### Overview
The stabilization period is a fixed delay (10 minutes) before an autoscaler in GCP MIGs scales down instances. This prevents rapid fluctuations and ensures the system monitors load stability. It cannot be reduced below 10 minutes, even for highly efficient setups.

### Key Concepts/Deep Dive
- **Minimum Duration**: Officially set at 10 minutes; no options to shorten it further.
- **Purpose**: Allows the autoscaler to confirm sustained low load before decommissioning VMs.
- **Application Impact**: If applications take longer than 10 minutes to initialize, consider adjusting initialization periods, but the minimum stabilization remains enforced.
- **Monitoring**: The autoscaler continuously evaluates capacity during this window, deleting VMs only when sufficient excess capacity exists.
- **Alternatives**: For shorter responses, consider Cloud Run or Cloud Functions, which also adhere to a 10-minute stabilization period.

> [!NOTE]
> Examples: Stabilization period ensures that intermittent spikes don't trigger premature scaling, but it may delay cost savings in low-load scenarios.

### Lab Demos
Demo referenced: Completed message acknowledgements around 7:36 PM, with scaling down expected starting at 7:46 PM (10-minute wait). Recommendation to wait and refresh instance groups to observe changes.

## Pub/Sub Topic Storage Capacity

### Key Concepts/Deep Dive
- **Message Limits**:
  - Each message payload (data) must not exceed 10 MB.
  - Unlimited number of messages can be published (e.g., millions).
  - No fixed storage cap as Pub/Sub uses backend cloud storage (internally called Colossus) for persistence.
  
- **Underlying Storage**: Pub/Sub relies on Google Cloud's storage infrastructure, making it a serverless component without explicit storage quotas.

> [!IMPORTANT]
> Pub/Sub is designed for high-volume messaging without storage limitations, ideal for large-scale event-driven architectures.

### Lab Demos
Navigation to Pub/Sub console to confirm message size restrictions in the publish interface. No code blocks, but references to cloud storage bucket utilization for storage management.

## Health Checks for Multiple Ports in MIGs

### Overview
When MIGs run multiple applications on different ports (e.g., microservices), health checks must focus on a dedicated "health" endpoint to determine VM vitality. Load balancers route to healthy VMs only.

### Key Concepts/Deep Dive
- **Health Check Mechanism**:
  - Expected ports: Often use a standard like port 80 for health checks.
  - MIGs associate with a single health check configuration per load balancer backend service.
  - For complex setups: Implement custom code to aggregate microservice health (e.g., if all services are "up", return a "healthy" response on a specific port).
  
- **Best Practices**:
  - DESIGNATE a single port (e.g., 80) for health status.
  - ENSURE health checks are simple and quick (e.g., temperature-like status checks).
  - VMs can run multiple ports/services internally; only the health port matters for MIG management.

> [!TIP]
> For microservices, create a health endpoint that verifies all dependent services before reporting status.

### Tables
| Component | Port Example | Purpose |
|-----------|--------------|---------|
| Main Application/Microservice | 80, 8080, 3306 | Service endpoint |
| Health Check | 80 | Binary up/down status for LB |

## Load Balancers and Internal LBs for Multi-Port Applications

### Overview
External load balancers handle traffic to MIG front-ends (e.g., port 80), while internal load balancers manage routing to middle-tier or database layers (e.g., ports 8080, 3306). Health checks are uniform per backend service, necessitating dedicated health ports.

### Key Concepts/Deep Dive
- **Architecture Setup**:
  - **External LB**: Routes from internet to front-end MIG (e.g., Nginx on port 80).
  - **Internal LB**: Handles traffic between tiers (e.g., front-end to middle-tier on 8080, middle-tier to DB on 3306).
  - **Health Checks**: One per backend service; cannot have multiple health checks per LB.
  - **Port Consistency**: All VMs in an MIG must match the health check port (e.g., 80).
  - **Global/Regional Considerations**: Global LBs route to the closest healthy region; regional LBs are regional-only.

- **Limitations**:
  - A single health check per backend service.
  - Different regions/ports (e.g., Mumbai on 80, London on 443) require separate internal LBs to avoid conflicts.
  
- **Mermaid Diagram**:
  ```mermaid
  flowchart TD
      A[External Traffic] --> B[External LB]
      B -->|Port 80| C[Front-end MIG e.g. Nginx]
      C --> D[Health Check Port 80]
      C --> E[Internal LB]
      E -->|Port 8080| F[Middle-tier MIG e.g. App Server]
      E -->|Port 3306| G[Database MIG e.g. MySQL]
      D -.-> H{VM Health}
      H -->|Yes| I[Route Traffic] --> J[Forward to App]
      H -->|No| K[Mark Unhealthy - No Traffic]
  ```

### Exhaustive Details
- Ensure front-end (e.g., Nginx) communicates with middle-tier via specific ports.
- Database interactions use designated ports like 3306 for MySQL.
- Health check code: Implement endpoint returning "healthy" only if all microservices are operational.

## Global vs Regional Load Balancers for High Availability

### Overview
Global load balancers offer automatic failover across regions, enhancing high availability without manual intervention. Regional load balancers confine traffic to a single region, requiring reconfiguration during outages.

### Key Concepts/Deep Dive
- **Global LBs**:
  - Distribute traffic globally based on proximity and health.
  - No configuration changes needed; if a region fails, routes to alternatives automatically.
  - Use Virtual IPs without regional ties.

- **Regional LBs**:
  - Operate within one region; failure means traffic disruption.
  - Manual or DNS-based redirection required (e.g., update DNS to point to a new LB IP in another region).
  - Suitable for single-region deployments but risky for HA.

- **HA Strategies**:
  - For third-party apps (e.g., SQL databases requiring virtual IPs), global LBs provide seamless failover.
  - DNS as fallback: Configure internal DNS to switch LB IPs dynamically.

> [!CAUTION]
> Regional load balancers lack automatic multi-region failover; plan for manual adjustments in production.

## Summary

### Key Takeaways
```diff
+ Acknowledgement per message triggers deletions and potential MIG scale-down after stabilization (10 minutes).
- Avoid expecting immediate scaling; stabilization prevents premature VM removal.
! Health checks require one dedicated port per MIG for LB monitoring.
+ Internal load balancers enable multi-tier routing with unified health checks.
- Regional LBs need manual failover; always prefer global for HA in multi-region setups.
```

### Expert Insight
#### Real-world Application
In production, implement robust health check endpoints in microservices (e.g., via Spring Boot Actuators) to ensure MIG integrity. For pub/sub integrations, configure autoscaling based on backlogs rather than simple acknowledgements, leveraging GCP's Cloud Monitoring for proactive scaling.

#### Expert Path
Master GCP autoscaling by studying monitoring metrics (e.g., CPU utilization, queue depths). Experiment with custom health checks in Terraform for IaC pipelines. Dive into Cloud Logging for autoscaling events to optimize stabilization periods in specific workloads.

#### Common Pitfalls
- **Pitfall**: Assuming health checks can multiplex ports – leads to inaccurate LB routing.
  - **Resolution**: Maintain one health port; use custom code for multi-service aggregation. Avoid by designing health endpoints early.
- **Pitfall**: Overlooking stabilization period in demos – results in unexpected delays in scale-in.
  - **Resolution**: For urgent scaling, consider Cloud Functions. Avoid by documenting wait times in playbooks.
- **Pitfall**: Misconfiguring global vs. regional LBs for HA.
  - **Resolution**: Always opt for global unless regional isolation is needed. Avoid by testing failover scenarios.
- **Lesser-Known**: Pub/Sub storage is unlimited but impacts costs; monitor via billing reports for hidden expenses in high-volume scenarios.
- **Corrections Made**: Original transcript had "quebe" corrected to "queue", "stabilization period is uh basically 10" clarified as 10 minutes, and minor grammatical fixes for clarity. No technical errors like "htp" or "cubectl" were present.
