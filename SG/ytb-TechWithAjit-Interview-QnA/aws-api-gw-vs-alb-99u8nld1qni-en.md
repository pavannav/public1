<details open>
<summary><b>AWS API Gateway vs Application Load Balancer (KK-CS45-script-v2-Interview)</b></summary>

## Q1: What is the difference between API Gateway and ALB? When would you use each?

**Answer:**

**Use ALB when:**
- Your APIs are transferring only inside the VPC
- APIs are simple and don't require authentication
- Path-based routing or host-based routing will work
- Requests are internal within your VPC

**Use API Gateway when:**
- Your APIs need to be authenticated
- APIs are coming from third-party sources
- You need to send requests to third-party tools/APIs
- DDoS protection is required
- TLS is needed by default
- Additional security configurations are necessary

**Note:**

The answer is correct. ALB operates at Layer 7 (application layer) and is ideal for internal VPC traffic with path/host-based routing. API Gateway provides a managed service with built-in security features including authentication, DDoS protection (via AWS WAF integration), and TLS termination, making it suitable for external-facing APIs that require these capabilities.

</details>