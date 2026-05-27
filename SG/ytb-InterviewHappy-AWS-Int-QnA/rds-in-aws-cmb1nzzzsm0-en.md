<details open>
<summary><b>RDS in AWS (KK-CS45-script-v2-Interview)</b></summary>

# RDS in AWS - Interview Study Guide

## Q1. What is Amazon RDS?

**Answer:**
Amazon RDS (Relational Database Service) is a fully managed cloud-based relational database service from AWS. It is offered as a Platform as a Service (PaaS), meaning you just need to provide your data and table structure - AWS handles the installation, configuration, patching, backups, and maintenance of the database.

**Key Points:**
- Managed relational database service
- Supports popular engines: MySQL, Oracle, SQL Server, PostgreSQL, etc.
- You focus on your data; AWS manages the infrastructure
- Part of the PaaS category in AWS

---

## Q2. What is the difference between Amazon RDS and Amazon RDS Custom?

**Answer:**

| Aspect | Standard RDS | RDS Custom |
|--------|-------------|------------|
| **OS/DB Control** | No full control - fully managed by AWS | Full access to OS and DB configurations |
| **Patching & Backups** | Managed by AWS | Managed by you |
| **Custom Configurations** | Limited flexibility | Full flexibility for modifications |
| **Use Case** | Fresh and simple database applications | Legacy database migrations with third-party tools |

**When to Use Each:**

- **Standard RDS**: For new, simple to medium app development where you want AWS to handle all management
- **RDS Custom**: For complex legacy application migrations where you need control over configurations and third-party tool support

---

## Q3. If your global application needs a NoSQL database with great response time, what would you choose in AWS?

**Answer:** Amazon DynamoDB

**Why DynamoDB?**
- Fully managed multi-region NoSQL database
- Provides low latency reads at any scale
- Supports global tables for worldwide user base
- Popular choice for applications requiring high performance and global distribution

---

## Key Concepts Summary

| Concept | Description |
|---------|-------------|
| **RDS** | AWS managed relational database service |
| **RDS Custom** | RDS with OS/DB level access for legacy migrations |
| **DynamoDB** | AWS managed NoSQL database with global capabilities |
| **PaaS** | Platform as a Service - focus on data, not infrastructure |

---

## Interview Tips

1. **RDS vs EC2-hosted DB**: RDS is managed; EC2 requires you to manage everything
2. **Standard RDS vs RDS Custom**: Know when to recommend each based on migration needs
3. **DynamoDB for NoSQL**: When global, low-latency NoSQL is needed

</details>