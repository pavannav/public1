<details open>
<summary><b>Top 10 AWS Interview Questions for Developers (KK-CS45-script-v2-Interview)</b></summary>

# Top 10 AWS Interview Questions for Developers - Study Guide

## Question 1: What is the difference between Amazon EC2 and AWS Elastic Beanstalk? When to use what?

### Answer:

**EC2 (Elastic Compute Cloud)**
- EC2 instances are **virtual servers in the AWS cloud**
- You install any software, run any application, and manage everything inside these virtual servers yourself
- Similar to managing real servers or your local laptop - you install everything to run the application

**Elastic Beanstalk**
- A **PaaS (Platform as a Service)** that primarily and directly hosts web applications, APIs, and mobile backends
- You don't need to worry about the infrastructure
- AWS fully manages the infrastructure, OS, runtime environment, autoscaling, load balancing, and even rollbacks during deployment

### Key Differences:

| Aspect | EC2 | Elastic Beanstalk |
|--------|-----|-------------------|
| Management | User-managed | Fully managed by AWS |
| Control | Full control over server | Limited customization |
| Use Case | Complex applications, full server control needed | Simple to medium web apps, APIs, mobile backends |
| Responsibilities | OS updates, patches, security groups, scaling, load balancing | Handled by AWS |

### When to Use Each:

**Use EC2 when you need:**
- Full control of the server
- Hosting very large custom applications or complex backend processing
- Applications requiring very tight control over security (e.g., banking applications)
- Custom security mechanisms or custom networking configurations
- Third-party software installations
- Raw server flexibility

**Use Elastic Beanstalk when you:**
- Are building simple to medium-level, mid-size web applications, APIs, or mobile backends
- Want to focus on your code, not the infrastructure
- Have a small team and don't want to worry about infrastructure management
- Need faster, automatic deployment
- Want automatic scaling features

### Note:
While Elastic Beanstalk is secured and offers many features (automatic deployment, scaling, load balancing), it is not highly customizable. Choose EC2 for full control and flexibility; choose Elastic Beanstalk for faster deployment and managed infrastructure.

---

</details>