<details open>
<summary><b>IAAS vs PAAS vs SAAS (KK-CS45-script-v2-Interview)</b></summary>

# IAAS vs PAAS vs SAAS - Study Guide

This transcript covers the three main cloud service models and provides practical examples for AWS interviews.

## Key Concepts

### Computing Stack Layers

The complete computing stack required to run applications includes:

1. **Application and Data** - Managed by developers
2. **Runtime** - Java, .NET, NodeJS frameworks
3. **Middleware** - MS Office, SAP, third-party software
4. **Operating System** - Windows Server, Linux
5. **Virtualization** - Required to simulate hardware
6. **Physical Servers** - Must be secured, updated, monitored
7. **Storage** - Images, files, databases
8. **Networking** - Connects servers and databases

### Three Cloud Service Models

#### 1. Infrastructure as a Service (IaaS)

**Managed by Your Company:**
- Application
- Data
- Runtime
- Middleware
- Operating System

**Managed by AWS:**
- Virtualization
- Server
- Storage
- Networking

**Key Point:** Reduces infrastructure team workload compared to on-premise.

#### 2. Platform as a Service (PaaS)

**Managed by Your Company:**
- Application
- Data only

**Managed by AWS:**
- Everything else: runtime, middleware, OS, networking, server, storage

**Key Point:** Most popular cloud model. Developers focus solely on application code.

#### 3. Software as a Service (SaaS)

**Managed by AWS:**
- Everything including application and data

**Your Company's Role:**
- Simply subscribe and use the software
- No development or technical configuration required

**Examples:** Amazon WorkMail, Salesforce, Office 365

### Important Distinction

The layers discussed (application, runtime, middleware, etc.) are **not** actual AWS services. Each layer contains specific services. For example:
- **Amazon EC2** belongs to the server layer
- **Amazon S3, EBS** belong to the storage layer

AWS developers primarily work with implementing AWS services, not managing layers.

## Interview Questions

### Q1: Your team wants to avoid purchasing servers for a new application. Which AWS model would you suggest?

**Answer:** Platform as a Service (PaaS) using AWS Elastic Beanstalk

**Explanation:**
- Simplest option for new AWS users
- AWS handles all infrastructure, scaling, and maintenance
- Fast, cost-effective, and ideal for launching applications

### Q2: Your client wants to use their existing on-premise servers with AWS. What cloud model fits best?

**Answer:** Hybrid Cloud

**Explanation:**
- Enables gradual migration from on-premise to cloud
- Reduces risk of application crashes during immediate full migration
- Allows incremental transition of application pieces

### Q3: Who is responsible for patching the OS in IaaS, PaaS, and SaaS?

**Answer:** C (varies by model)

**Breakdown:**
- **IaaS:** You are responsible for installing and managing the OS
- **PaaS:** AWS manages OS installation; you can make limited modifications to patches
- **SaaS:** AWS handles everything completely

## Notes for Interview Preparation

- **On-premise setup** involves your company managing the entire computing stack
- **IaaS** reduces your company's workload compared to on-premise
- **PaaS** further reduces workload to only application and data management  
- **SaaS** eliminates all technical work - just subscribe and use
- AWS developers typically work with IaaS and PaaS models
- Focus on actual services rather than layers when working with AWS

</details>