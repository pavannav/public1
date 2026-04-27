# Top 15 Scenario Based AWS Load Balancer & Auto Scaling Interview Scenarios (with Answers!) AWS Prep

### Q1: You have a website with sudden spikes in traffic. How would you configure an AWS load balancer to handle unpredictable loads?

**A:** Configure an Application Load Balancer (ALB) with an Auto Scaling group (ASG). Set up auto scaling policies based on CPU utilization or request count to scale out EC2 instances during high traffic and scale down when traffic decreases. Configure health checks in the ALB so traffic is only routed to healthy instances, automatically removing unhealthy ones from rotation.

![ALB and ASG configuration diagram](images/q1_alb_asg_unpredictable_loads.png)

**Note:** The answer is correct. For best practices, also consider using CloudWatch alarms for more granular control and monitoring, and adjust the cool-down period to prevent scaling thrashing.

### Q2: How would you route traffic across multiple AWS regions for a globally distributed application?

**A:** Use AWS Global Accelerator or Route 53 with latency-based routing. Deploy the application behind ALBs in each region. Route 53 (or Global Accelerator) will route users to the nearest region based on latency, providing fault tolerance if one region fails.

![Latency-based routing across regions](images/q2_multi_region_routing.png)

**Note:** The answer is accurate. Global Accelerator is preferred for its anycast IP and improved performance over Route 53 DNS-based routing for applications requiring the lowest possible latency.

### Q3: A new feature rollout is expected to increase traffic for a specific part of your application. How would you adjust your ALB and Autoscaling configurations to prepare?

**A:** Create a new target group with an associated ASG. Configure the ALB with path-based routing to direct traffic for the new feature to the new target group. Increase the minimum instance count in the ASG and monitor performance metrics to adjust instance types or counts accordingly to handle the additional traffic.

![Path-based routing for feature rollout](images/q3_path_based_routing_rollout.png)

**Note:** Correct approach. Consider using canary deployments with weighted routing in ALB to gradually shift traffic, and implement CloudWatch alarms to automatically scale based on traffic patterns during rollout.

### Q4: How would you set up health checks for your ALB to avoid routing traffic to unhealthy instances?

**A:** In the ALB, use target groups with health checks configured via endpoints (e.g., /health) that test EC2 instance functionality. Set criteria like expected response, timeout, and healthy/unhealthy thresholds. If an instance fails health checks (e.g., doesn't return a success response), it's marked unhealthy and removed from rotation.

**Note:** The explanation is correct. For improved accuracy, use multiple health checks (HTTP status 200-299, response time < thresholds), and consider implementing application-level health checks beyond basic connectivity.

### Q5: You need to reduce response time for users in multiple regions. What setup would you use for your load balancers?

**A:** Deploy ALBs in multiple regions and use Route 53 with latency-based routing. This routes users to the closest region, reducing response time and providing regional failover if one region goes down.

![Multi-region load balancers with Route 53](images/q5_multi_region_latentcy_reduction.png)

**Note:** Accurate. Alternative: AWS Global Accelerator for consistent routing around the world without DNS redirection issues, potentially reducing jitter compared to Route 53 latency routing.

### Q6: If your ALB encounters an HTTP 504 timeout error, what steps would you take to troubleshoot this?

**A:** Check if health checks are passing in the target groups. Verify backend server response time and ensure it's within ALB's timeout configuration (default 60 seconds). If needed, increase ALB timeout or optimize backend server processing time.

**Note:** The troubleshooting steps are correct. Additionally, check for network issues, SSL/TLS issues if using HTTPS, and ensure the target group health check threshold isn't too restrictive.

### Q7: Describe how would you configure a load balancer to support both HTTP and HTTPS traffic with automatic redirection?

**A:** Create two listeners in the ALB: one for HTTP on port 80 and one for HTTPS on port 443 with an SSL certificate. Configure the HTTP listener with redirection rules to HTTPS, ensuring all HTTP traffic is automatically redirected to HTTPS for secure communication.

![HTTP to HTTPS redirection in ALB](images/q7_http_https_redirection.png)

**Note:** Correct configuration. Best practice: Use AWS Certificate Manager (ACM) for SSL certificates and enable security headers in the ALB for additional protection.

### Q8: Your application needs sticky sessions. How would you configure this on your ALB?

**A:** Enable sticky sessions at the target group level. Set an appropriate duration for session stickiness. This ensures requests from the same client are consistently routed to the same server, maintaining session persistence (e.g., shopping cart data).

**Note:** The configuration is correct. Note that session stickiness should be used cautiously as it can interfere with even load distribution and auto scaling. Consider using external session storage (e.g., ElastiCache) for better scalability.

### Q9: How do you configure Autoscaling groups to handle daily high traffic predictable periods without manual intervention?

**A:** Use scheduled scaling to scale up instances at predictable times based on historical traffic patterns, and scale down afterward. Alternatively, configure dynamic scaling policies based on CPU or network utilization to adjust instances automatically based on demand.

**Note:** The approaches are accurate. For hybrid scenarios, combine scheduled scaling with dynamic policies. Use CloudWatch predictions for more adaptive scheduled scaling based on learned patterns.

### Q10: Your application requires additional instances when memory usage hits 80%. How would you set this up in Auto scaling?

**A:** Use CloudWatch custom metrics to monitor memory usage (since it's not built-in). Create a custom CloudWatch metric and alarm that triggers when memory exceeds 80%. Configure the alarm to scale up ASG capacity.

**Note:** Correct method. Since CloudWatch doesn't natively monitor instance-level memory, deploy a CloudWatch agent on EC2 instances. Consider using AWS Lambda functions to poll and publish memory metrics periodically.

### Q11: How would you ensure that an Autoscaling group maintains a minimum number of healthy instances even during instance failures?

**A:** Set a minimum instance count in the ASG configuration. Enable health checks so unhealthy instances are automatically terminated and replaced, ensuring the minimum capacity is maintained.

**Note:** Accurate. For critical applications, increase the minimum count and use ELB health checks in addition to EC2 ones. Also, enable detailed monitoring for quicker failure detection.

### Q12: Describe how would you use autoscaling with a fleet of spot instances to save costs without compromising availability?

**A:** Use a mixed instances policy with spot and on-demand instances. Assign higher weight to spot instances and enable capacity rebalance to replace interrupted spot instances with available on-demand ones, maintaining capacity.

**Note:** Correct approach. Diversify across instance types/families to reduce interruption risk. Use spot instance allocation strategies (e.g., diversified) and set maximum spot price limits.

### Q13: How would you configure Auto scaling to prevent excessive scaling during temporary traffic spikes?

**A:** Use target tracking scaling with cool-down periods, or implement step scaling with gradual instance increases based on metric thresholds. This prevents over-scaling for short-term spikes by waiting or scaling incrementally.

**Note:** The methods are valid. Cooldown periods prevent rapid scaling cycles. For advanced control, use predictive scaling based on CloudWatch metrics and machine learning predictions.

### Q14: What steps would you take if your autoscaling group was scaling in and terminating instances too quickly leading to downtime?

**A:** Adjust the cool-down period to delay scaling actions, giving instances more time to process requests. Switch to target tracking scaling for more predictable and stable scaling behavior.

**Note:** Good troubleshooting. Also, review scaling policies to ensure thresholds aren't too aggressive, and consider adding buffer instances or adjusting minimum instance counts during peak times.

### Q15: Your application has varying load levels in different regions. How do you configure Auto scaling for this setup?

**A:** Create separate ASGs in each region to handle loads independently. Use Route 53 with latency-based routing or AWS Global Accelerator to distribute traffic across regions based on proximity and load.

![Regional ASGs with cross-region routing](images/q15_regional_asg_varying_loads.png)

**Note:** Correct for regional autonomy. Ensure ASG policies are tuned per region. For advanced scenarios, use global ASG configurations with cross-region replication for certain workloads.
