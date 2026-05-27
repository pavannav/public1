<details open>
<summary><b>Load Balancer in AWS (KK-CS45-script-v2-Interview)</b></summary>

## **AWS Elastic Load Balancer - Complete Study Guide**

---

## Q1: What is the role of AWS Elastic Load Balancer?

**Answer:**
AWS Elastic Load Balancer acts as a traffic police or traffic light for your AWS infrastructure. It receives all incoming requests from users on the internet and evenly distributes them across multiple EC2 instances.

**Key Points:**
- Distributes incoming traffic across multiple EC2 instances
- Ensures **high availability**, **scalability**, and **fault tolerance**
- Prevents any single EC2 instance from being overloaded
- Essential when running horizontal scaling setups with multiple EC2 instances

**Simple Definition:**
> AWS Load Balancer distributes incoming traffic across multiple EC2 instances to ensure high availability, scalability, and fault tolerance.

---

## Q2: What are the types of AWS Elastic Load Balancers?

**Answer:**
AWS provides four types of Elastic Load Balancers:

| Load Balancer Type | Full Form | Use Case |
|-------------------|-----------|----------|
| **NLB** | Network Load Balancer | High-performance, TCP/UDP traffic |
| **ALB** | Application Load Balancer | HTTP/HTTPS, advanced routing |
| **CLB** | Classic Load Balancer | Legacy systems (older generation) |
| **GWLB** | Gateway Load Balancer | Third-party appliances, security |

---

## Q3: What is Classic Load Balancer (CLB)?

**Answer:**
Classic Load Balancer is the **older generation** of AWS load balancers. It was the first load balancer AWS offered and has since been replaced by NLB and ALB.

**Key Characteristics:**
- Has features of both ALB and NLB but with **limited capabilities**
- Used primarily for **legacy systems** (older AWS setups)
- Still relevant when companies have existing CLB configurations that are difficult to migrate
- Recommendation: Use NLB or ALB for new deployments

**When to use CLB:**
- Legacy applications running on older AWS infrastructure
- Situations where migrating from CLB to NLB/ALB would require significant effort

**Note:** CLB is not recommended for new implementations. Modern applications should use ALB or NLB instead.

---

## Q4: What is Gateway Load Balancer (GWLB)?

**Answer:**
Gateway Load Balancer is a specialized load balancer designed for deploying, scaling, and managing third-party virtual appliances. It operates at the network layer (Layer 3) and is used for security, inspection, and compliance use cases.

**Use Cases:**
- Third-party network appliances (firewalls, IDS/IPS)
- Inline traffic inspection
- Advanced security filtering
- Compliance and monitoring solutions

**Note:** GWLB is a complex topic covered in detail in advanced AWS interview preparation materials.

---

## Architecture Diagram Concept

```
Users (Internet)
        ↓
[Elastic Load Balancer]
        ↓
   Distributes Traffic
   /    |    \
  EC2  EC2   EC2
Instance Instance Instance
```

---

## Key Interview Takeaways

1. **Load Balancer Definition** - Always memorize the simple, easy-to-remember definition provided above
2. **Four Types** - Know all four load balancer types and their abbreviations (NLB, ALB, CLB, GWLB)
3. **CLB Status** - CLB is legacy/old generation; prefer ALB/NLB for new projects
4. **Primary Function** - Distribute requests evenly, ensure no instance overload, provide high availability
5. **Horizontal Scaling Context** - Load balancers become essential when you scale out multiple EC2 instances

---

## Revision Checklist

- [ ] Can explain the role of Elastic Load Balancer in 30 seconds
- [ ] Can name all four types of AWS load balancers
- [ ] Understand when to use Classic Load Balancer (legacy systems only)
- [ ] Know that NLB and ALB are the modern replacements for CLB
- [ ] Can describe the traffic distribution flow with a diagram

</details>