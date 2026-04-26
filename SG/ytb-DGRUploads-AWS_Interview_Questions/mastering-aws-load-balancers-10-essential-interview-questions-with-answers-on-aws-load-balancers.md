## Mastering AWS Load Balancers: 10 Essential Interview Questions with Answers on AWS load balancers

### What's the purpose of a load balancer?

A load balancer distributes incoming application traffic across multiple targets, such as EC2 instances, to ensure optimal resource utilization, fault tolerance, and high availability. Users connect to the load balancer, which then routes traffic to healthy instances. This prevents any single instance from being overwhelmed and provides redundancy—if one instance fails, traffic is automatically redirected to others.

### What are the different types of load balancers in AWS?

AWS offers four types of load balancers:

1. **Application Load Balancer (ALB)**: Operates at OSI Layer 7, handling HTTP/HTTPS traffic with advanced routing features.
2. **Network Load Balancer (NLB)**: Operates at OSI Layer 4, handling TCP/UDP traffic for ultra-low latency needs.
3. **Gateway Load Balancer (GWLB)**: Routes traffic to third-party appliances like firewalls for inspection before forwarding.
4. **Classic Load Balancer**: Deprecated but still available; operates at both Layer 4 and Layer 7, with basic features.

When creating a load balancer in the AWS console, ALB, NLB, and Gateway LB are the recommended options over the classic version.

### How does an application load balancer differ from a network load balancer?

- **Layer of Operation**: ALB works at Layer 7 (application layer) for HTTP/HTTPS traffic, enabling features like path-based and host-based routing. NLB works at Layer 4 (transport layer) for TCP/UDP/UDP flows, providing ultra-low latency (as low as 195 milliseconds versus ALB's 400-600 milliseconds).
- **Protocols**: ALB primarily supports HTTP, HTTPS, and WebSocket; NLB handles TCP, UDP, TLS, and TCP_UDP.
- **Routing Features**: ALB supports content-based (header/cookie-based) and path-based routing. NLB focuses on IP/port/protocol matching without advanced routing.
- **Performance**: NLB excels in high-throughput, low-latency scenarios like video streaming or heavy data transfers. ALB is better for web applications requiring intelligent routing.
- **Cross-Zone Load Balancing**: Both support it by default.

### How can you achieve cross-zone load balancing with an elastic load balancer?

Cross-zone load balancing distributes traffic evenly across instances in multiple Availability Zones (AZs) within the same region, improving fault tolerance and availability.

- For **Application Load Balancer (ALB)** and **Network Load Balancer (NLB)**: Enabled by default—no manual configuration needed.
- For **Classic Load Balancer**: Must be explicitly enabled via the load balancer attributes in the console.

When enabled, the load balancer treats all instances across AZs as a single pool, routing traffic efficiently even if one AZ becomes overloaded.

### What is the purpose of a target group in a load balancer?

A target group defines a set of targets (e.g., EC2 instances, IP addresses, Lambda functions, or containers) where the load balancer routes requests. It acts as the destination for traffic, allowing configuration of:

- Routing rules (e.g., based on health, weights).
- Health checks to ensure only healthy targets receive traffic.
- Stickiness and other attributes.

When creating an ALB or NLB, you must associate at least one target group. Targets are registered to the group, and the load balancer evaluates their health before forwarding traffic, improving reliability and performance.

### How can you ensure that your application load balancer automatically scales based on traffic demand?

Integrate the Application Load Balancer (ALB) with an Auto Scaling group:

1. Create or use an existing ALB.
2. In the Auto Scaling group configuration (via EC2 Auto Scaling console), select the ALB during setup.
3. Attach the target group to the Auto Scaling group.
4. Configure scaling policies (e.g., CPU utilization thresholds).

This allows the Auto Scaling group to launch/terminate instances based on metrics like CPU usage or request count, dynamically adjusting the ALB's target pool. Ensure the ALB's cross-zone load balancing is enabled for optimal scaling across Availability Zones.

### What is the purpose of a listener in a load balancer?

A listener listens for incoming connection requests on specified protocols/ports (e.g., HTTP on port 80, HTTPS on 443) and forwards them to target groups based on rules. Key functions:

- **Traffic Direction**: Routes requests using conditions like host headers, paths, or query parameters (for ALB).
- **Multi-Application Support**: Allows one load balancer to handle multiple applications/services on different ports.
- **Protocol/Port Configuration**: Defines how traffic is encrypted/decrypted (e.g., SSL termination via HTTPS listeners).

For example, a listener on port 80 might forward HTTP traffic to one target group, while port 443 (HTTPS) routes to another, enabling advanced routing without separate load balancers.

### Explain the concept of sticky sessions in load balancers.

Sticky sessions (session affinity) ensure that requests from the same client are routed to the same target (e.g., EC2 instance) for the duration of the session, preserving session data like shopping carts or user logins. This is useful for stateful applications where data continuity is critical.

- **How It Works**: The load balancer uses cookies or source IP to "stick" a session to a specific instance.
- **Configuration**: Enabled at the target group level in ALB, with options for load balancer-generated cookies or application-based sticky sessions.
- **Trade-offs**: Improves session persistence but can lead to uneven load distribution; not recommended for stateless apps.

### How do you configure health checks for targets in a load balancer?

Health checks monitor target health and route traffic only to healthy instances, preventing failures from affecting users.

Configuration (at the target group level):
- **Protocol/Port**: HTTP, HTTPS, TCP, or UDP; specify port (e.g., 80 for web apps).
- **Path**: For HTTP/HTTPS, a specific endpoint (e.g., `/health`).
- **Timeout/Interval**: Wait time for response (e.g., 5 seconds) and check frequency (e.g., every 30 seconds).
- **Success/Unhealthy Threshold**: Number of consecutive successes/failures to mark the target healthy/unhealthy.
- **Advanced**: Include request headers, timeouts, and criteria.

The load balancer pings targets periodically; unhealthy targets (e.g., returning 5xx errors) stop receiving traffic until recovered, ensuring high availability.

### Can an elastic load balancer distribute traffic to resources in different AWS regions?

No, Elastic Load Balancers are region-specific—load balancer and targets must reside in the same AWS region to maintain low-latency communication.

To achieve cross-region traffic distribution:
- Use AWS Route 53 for DNS-based geo-routing or latency-based routing.
- Leverage AWS Global Accelerator for routing traffic over AWS's global network with fixed IP addresses, reaching targets across regions while improving performance.

Always combine with regional load balancers for local distribution.
