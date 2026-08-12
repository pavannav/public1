# Chapter 9: Analyzing and Defining Technical Processes

**Exam Objective Covered:** 4.1 Analyzing and defining technical processes

---

As an architect, you will participate in several kinds of technical processes, including continuous integration (CI)/continuous delivery (CD) and post-mortem analysis. This chapter covers the software development lifecycle, CI/CD, troubleshooting and post-mortem culture, IT enterprise processes (ITIL), and business continuity and disaster recovery planning — all with a focus on how they relate to business objectives.

---

## Software Development Lifecycle Plan

The **software development lifecycle (SDLC)** is a series of steps software engineers follow to create, deploy, and maintain complicated software systems. SDLC consists of seven phases:

1. Analysis
2. Design
3. Development
4. Testing
5. Deployment
6. Documentation
7. Maintenance

The *cycle* in SDLC refers to the ongoing nature of understanding business requirements and developing software to meet them, even after software is deployed.

### Analysis

The analysis phase exists to:

- Identify the scope of the problem to address
- Evaluate options for solving the problem
- Assess the cost-benefit of various options

#### Scoping the Problem to Be Solved

Focus is on the business or organizational problem to be solved. This requires domain knowledge about the problem area and software/systems knowledge to frame a solution. Domain experts with broad knowledge help identify key aspects of requirements and contribute to defining scope.

#### Evaluating Options

After scoping, consider options for solving the problem. A common question is: **"Should the organization buy a software solution or build one?"**

**Commercial off-the-shelf software (COTS)** refers to existing software solutions.

**Advantages of buying software or using a service:**

- Faster time to solution (no need to build)
- Allows developers to focus on other business requirements
- Purchased software or service typically includes support

**Disadvantages of buying:**

- Potentially high licensing costs
- Inability to customize to specific needs

**When building:**

- Modifying an existing application may be fastest for getting to production, but may constrain design choices (e.g., language and platform constraints)
- Building from scratch gives full control over architecture and design choices, but requires significant time and engineering resources
- Consider **opportunity cost**: the value of developers' time spent on one project versus another

#### Cost-Benefit Analysis

The analysis phase also includes considering the costs and benefits of the project. **Return on investment (ROI)** measures the value, or return, of making an investment. Architects may be asked to help develop a cost justification for a project, enabling decision-makers to compare the relative value of different projects.

---

### Design

In the design phase, you map out in detail how the software will be structured and how key functions will be implemented. Design is often broken into two subphases:

#### High-Level Design

During **high-level design**, major subcomponents of the system are identified.

**Example — Insurance Claims Processing System:**

- Ingestion system (receives claim data from clients)
- Data validation system (preliminary completeness checks)
- Business logic backend (evaluates claims against policy)
- Customer communication service (sends letters describing claims/benefits)
- Management reporting component (KPIs: volume, backlog, etc.)

Key considerations:

- Define **interfaces between components** (especially important in microservice or distributed architectures)
- **RESTful interfaces** are common; **GraphQL** is an increasingly popular API design alternative
- For large data volumes between services, consider **asynchronous messaging** (e.g., Cloud Pub/Sub) instead of synchronous API calls
  - Cloud Pub/Sub decouples components — producers write to a topic; consumers read from it
  - Enables handling of load spikes: messages stay in queue if the consuming service can't keep up
  - Especially important when client services can scale (e.g., stateless web) but downstream services cannot (e.g., relational databases that only vertically scale)

#### Detailed Design

**Detailed design** focuses on how to implement each subcomponent. This includes:

- Decomposing components into modules and lower-level functions
- Defining data structures, algorithms, security controls, and logging
- Designing user interfaces (with input from direct system users)

**User experience (UX)** considerations are important during detailed design — engage people with different roles, including those who will directly use the system.

During high-level or detailed design, developers may choose:

- Libraries and frameworks for the application
- **Object-oriented design** approaches
- **Object Relational Mappers (ORM)** to interface with relational databases

---

#### Development, Testing, and Deployment

During development, software engineers create:

- **Application code** (implements functionality)
- **Configuration files** (environment-specific details — file locations, environment variables)

Developers use tools such as:

- Integrated development environments (IDEs)
- Static analysis tools
- Database administration tools
- Source control systems (GitHub, Cloud Source Repositories)

Testing during development typically includes **unit testing** and **integration testing**.

##### Documentation

> ![note](../images/note_24.png) Not all SDLC frameworks include documentation, but it is included here for completeness.

Three distinct kinds of documentation:

| Type | Audience | Purpose |
|------|----------|---------|
| **Developer documentation** | Software engineers | Inline code comments, design documents; explains code logic and how to modify the application |
| **Operations documentation** | System administrators, DevOps engineers, SREs | Instructions to deploy and maintain systems; includes **runbooks** with setup steps, operational guidance, and troubleshooting advice |
| **User documentation** | End users | Explains how to use the application; often written by technical writers; must be updated as features change with Agile practices |

A **runbook** includes instructions on how to set up and run a service or application, and may contain troubleshooting advice.

---

#### Maintenance

**Maintenance** is the process of keeping software running and up-to-date with business requirements.

With Agile software practices, it is common for developers to maintain their own code.

Maintenance includes:

- **Monitoring**: Collects data on application and infrastructure performance
- **Alerting**: Notifies system administrators or developers of conditions requiring human intervention
- **Logging**: Collects detailed information about system state over time; logging level is a configurable parameter

**Infrastructure-as-Code (IaC):** Tools like **Terraform** (deploy and modify infrastructure), **Puppet**, and **Chef** (configure software on servers) allow developers to treat infrastructure configuration as code. Architects have substantial roles in analysis and high-level design, and in setting standards for tools such as version control systems and CI/CD platforms.

---

## Continuous Integration/Continuous Delivery

CI/CD is the process of incorporating code into a baseline of software, testing it, and if the code passes tests, releasing it for use.

### Business Drivers to Adopt CI/CD

**Historical context:** Previously, new features were bundled and released in major updates (e.g., every six months), especially when software was shipped on physical media.

**Today:** CI/CD is practical because:

- Tools help developers roll out code quickly
- Software is increasingly delivered as a service — developers deploy to servers/cloud and users get access immediately

> ![note](../images/note_24.png) **Feature flags** are runtime configurations that can modify application behavior without deploying new code, allowing selective release of capabilities to customers.

**CI/CD limitations:**

| Software Type | CI/CD Suitability |
|---------------|------------------|
| General business systems | Well-suited; validated by automated tests |
| **Safety-critical software** (medical devices, aviation, factory automation, autonomous vehicles) | May **not** be appropriate; requires rigorous validation including human review |
| **Business-critical and security-critical software** | More demanding testing requirements, but may be incorporatable into CI/CD |

CI/CD is a widely used alternative to **big-bang releases** (infrequent bulk updates). It should be implemented with sufficient testing and human review based on software safety and criticality.

---

### CI/CD Building Blocks

CI/CD builds on several types of tools:

- Version control
- Secrets management
- Automated builds
- Deployment pipelines

These building blocks are commonly used together in a practice known as **GitOps** — managing infrastructure and software deployment using software engineering tools including version control services like Git.

#### Version Control

Version control tracks changes to software and enables team collaboration. Key capabilities:

- Tracks changes
- Enables multiple simultaneous changes to source code
- Allows reverting to previous versions

**Historical model:** Centralized servers where developers checked files in and out — blocked developers if the server was down.

**Modern model:** Distributed version control systems like **Git** — developers clone complete repository copies; Git tracks incremental changes by multiple developers.

**Google Cloud service:** **Cloud Source Repository** is a managed version control service in Google Cloud.

#### Secrets Management

Secrets include API keys, certificates, passwords, and other sensitive data. Hard-coding secrets into application or configuration code is a **bad practice**.

**Secrets managers** (e.g., HashiCorp Vault, **Google Cloud's Secret Manager**) provide:

- Secure, centralized storage for secrets
- Key-value pair storage (key = secret name, value = actual secret)
- **Replication policies** to control where secrets are stored
- **Audit logging** to track changes
- Access control through **IAM**

#### Deployment Pipelines

Modern applications require many components, libraries, and modules.

- **Build pipelines**: Automate creation of deployable artifacts
- **Deployment pipelines**: Release previously built artifacts for use

**Google Cloud services:**

| Service | Purpose |
|---------|---------|
| **Cloud Build** | Managed service for building, testing, and deploying software; can create container images |
| **Artifact Registry** | Managed centralized repository for images and private packages |

**Cloud Build capabilities:**

- Deploys to virtual machines, Kubernetes clusters, serverless services, and Firebase
- Scans images for known vulnerabilities before release

**Binary Authorization** (used with Kubernetes Engine or Cloud Run):

- Requires container images to be signed by trusted providers
- Verifies signatures before running the image
- Ensures only trusted containers run in your infrastructure

---

## Troubleshooting and Post-Mortem Analysis Culture

Complicated and complex systems fail, sometimes in unanticipated ways. Approaches to managing failures:

1. **Formal methods** (refinement from specification, theorem provers) — appropriate for safety-critical systems but costly and slow
2. **Chaos engineering** — introducing failures to understand consequences and identify unanticipated failure modes; Netflix's **Simian Army** is a collection of chaos engineering tools
3. **Post-mortem analysis** — learning from failures

> **Chaos engineering** cannot be used in safety-critical or security-critical systems.

There are two types of post-mortems:

### Incident Post-Mortems

An **incident** is an event that disrupts a service. Incidents range in scope from minor (brief lag affecting few customers) to major (data loss, large-scale customer impact).

An **incident post-mortem** is a review of:

- Causes of the incident
- Effectiveness of responses
- Lessons learned

#### Learning from Minor Incidents

A single minor incident may not provide much learning, but a **series of minor incidents** may indicate a systemic problem.

**Example:** A misconfigured load balancer not distributing load optimally — leads to processing lag. Remediation options:

- Develop a **static code analysis script** that checks parameter names against valid parameter lists
- Set an **alert on the corresponding log file** to notify a DevOps engineer when parameter warning messages appear

Minor incidents help identify weak spots in procedures without significant adverse effects on users.

#### Learning from Major Incidents

A **major incident** affects a large portion of users with service disruption or data loss.

**First priority: Restore service.**

Key characteristics of major incidents in complex systems:

- Frequently occur when **two or more adverse events occur simultaneously** (e.g., a node running out of disk space at the same time as a network partition)

**Best practices for major incidents:**

- Follow established procedures (identify incident manager, notify business owners)
- Document decisions and steps taken
- Create a **timeline of events** including reasoning behind decisions
- Capture notes (even informally — a message channel thread is valuable)

**Post-mortem review goals:**

- Understand what happened, why it happened, and how to prevent recurrence
- **Not** to assign blame

**Blameless culture:** Engineers should feel free to disclose mistakes without fear of retribution. Complex systems fail even when everyone does their best. Part of the value of experienced engineers is the lessons they've learned from past mistakes.

---

### Project Post-Mortems

A **project post-mortem** reviews the way work was done on a project, with the goal of identifying issues that slowed down work or caused problems for team members.

**Benefits:**

- Improve team practices (e.g., adding additional integration testing, improving decision documentation)
- Help all team members know where to find answers to past decisions

Like incident post-mortems, project post-mortems should be **blameless**. The goal is to improve team capabilities.

---

## IT Enterprise Processes

Large organizations need ways to manage huge numbers of software projects, operational systems, and expanding infrastructures.

### ITIL

**ITIL** (originally: Information Technology Infrastructure Library) is a comprehensive set of IT service management practices for planning and executing IT operations in a coordinated way across a large organization.

**ISO/IEC 20000** is an international standard for IT service management similar to ITIL.

> ![note](../images/note_24.png) The current version is **ITIL 4**. Reference:
> `www.tsoshop.co.uk/Business-and-Management/AXELOS-Global-Best-Practice/ITIL-4`
>
> ISO/IEC 20000 reference:
> `www.iso.org/standard/51986.html`

> ITIL and ISO/IEC 20000 may be helpful for large organizations, but small organizations may find that the overhead outweighs the benefits.

**ITIL's four dimensions:**

| Dimension | Description |
|-----------|-------------|
| **Organizations and people** | How people and groups contribute to IT processes |
| **Information and technology products** | IT services within an organization |
| **Partners and suppliers** | External organizations providing IT services |
| **Value streams and processes** | Activities executed to realize benefits of IT |

**ITIL's three management practice groups:**

| Group | Examples |
|-------|---------|
| **General management practices** | Strategy management, portfolio management, architecture management |
| **Service management practices** | Business analysis, service catalog management, availability management, service desk management |
| **Technical management practices** | Deployment management, infrastructure and platform management, software development management |

---

## Business Continuity Planning and Disaster Recovery

### Business Continuity Planning

**Business continuity planning** is planning for keeping business operations functioning in the event of a large-scale natural or human-made disaster.

Large-scale disruptions include: Category 5 hurricanes, 7.0+ magnitude earthquakes, and other events causing major damage to power, water, transportation, and communication systems.

**Key components of a business continuity plan:**

| Component | Description |
|-----------|-------------|
| **Disaster plan** | Documents strategy for responding to a disaster; includes operations location, priority services, vital personnel, plans for insurance carriers and supplier/customer relationships |
| **Business impact analysis** | Describes possible outcomes of different disruption levels; includes cost estimates (e.g., minor flooding vs. loss of power to a data center requiring cloud deployment) |
| **Recovery plan** | Describes how services will be restored to normal operations; done incrementally to verify physical infrastructure functioning |
| **Recovery time objectives (RTOs)** | Prioritize which services should be restored first and the expected time to restore them |

---

### Disaster Recovery

**Disaster recovery (DR)** is the subset of business continuity planning that focuses specifically on IT operations.

**DR planning includes:**

- Plans for deploying services in a production environment other than the usual one (e.g., on-premises to cloud)
- Scripts configured for the DR environment
- Description of roles (DevOps engineer, network engineer, database administrator, etc.)
- Procedures for replicating access controls from the normal environment to the DR environment (same roles and permissions in DR as in production)
- Clear guidance on **when to switch to a DR environment** (criteria are a business decision, informed by risk tolerance, SLAs, and expected costs)

**DR plans must be tested** by executing them as if a disaster occurred. Industry or government regulations may require specific DR planning.

**Criteria for invoking DR** considerations:

- If a critical service cannot be restored within a specified time, start it in the DR environment
- If two or more critical services fail in the normal environment, potentially switch all services to DR

**Key architectural challenge:** Restoring a service in DR to a state as close as possible to the last good production state:

- Keep database replicas in the DR environment
- Copy committed code to a backup repository each time the production version control system is updated

**Important principle:** DR planning is not something that can be added on after a system is designed. It must be considered during architecture. Organizations may have to choose between comprehensive (high-cost) and less comprehensive (lower-cost but degraded service) DR plans. Architects help business decision-makers understand these costs and trade-offs.

---

## Summary

Cloud architects contribute to and participate in a wide range of technical and business processes:

- **SDLC**: A series of phases to understand requirements, plan architecture, design implementation, develop, deploy, and maintain software
- **CI/CD**: Enables rapid feature release and faster bug detection compared to batch updates; not suitable for all software types (e.g., safety-critical systems)
- **Post-mortem analysis**: Provides means to learn from minor and major incidents in a **blameless culture**; also applicable to project reviews
- **ITIL**: A well-established set of enterprise practices for managing general, service, and technical aspects of IT operations
- **Business continuity planning**: Prepares for major disruptions; **disaster recovery** is a subset focused on IT services

---

## Exam Essentials

- **Information systems are highly dynamic**: Technical processes (SDLC, CI/CD, post-mortem analysis, business continuity planning) help individuals and organizations function in a coordinated fashion.
- **First stage of SDLC is analysis**: Involves scoping the problem, evaluating options (build vs. buy), and assessing costs/benefits including opportunity costs.
- **High-level vs. detailed design**: High-level design identifies major subcomponents and integration (asynchronous vs. synchronous interfaces); detailed design describes how subcomponents operate (algorithms, data structures, frameworks).
- **Three kinds of documentation**: Developer (for engineers to understand/modify code), Operations (for DevOps/SREs to keep systems running; includes runbooks), User (for end users; explains how to use the system).
- **Benefits of CI/CD**: Rapid feature rollout; not appropriate for safety-critical software that requires substantial testing and validation.
- **Post-mortems**: Reviews of incidents or projects to improve services or practices; major incidents often result from two or more simultaneous failures; conducted without blame assignment.
- **Enterprise IT management**: Large organizations need enterprise-scale practices (ITIL) to manage dynamic IT portfolios.
- **Business continuity and DR planning**: Prepare for natural or human-made disasters; DR is a component of BCP; DR plans must be tested regularly.

---

## Review Questions

1. A team of early career software engineers has been paired with an architect to work on a new software development project. The engineers are anxious to get started coding, but the architect objects because there has been insufficient work prior to development. What steps should be completed before beginning development according to SDLC?
   - A. Business continuity planning
   - B. **Analysis and design** ✓
   - C. Analysis and testing
   - D. Analysis and documentation

2. In an analysis meeting, a business executive asks about research into COTS. What is this executive asking about?
   - A. **Research related to deciding to build versus buying a solution** ✓
   - B. Research about a Java object relational mapper
   - C. A disaster planning protocol
   - D. Research related to continuous operations through storms (COTS), a business continuity practice

3. Business decision-makers have created a budget for software development. There are more projects proposed than can be funded. What measure might they use to choose projects to fund?
   - A. Mean time between failures (MTBF)
   - B. Recovery time objectives (RTO)
   - C. **Return on investment (ROI)** ✓
   - D. Marginal cost displacement

4. A team of developers is debating whether to use arrays, lists, or hash maps for a backend service. In what stage of the SDLC are they?
   - A. Analysis
   - B. High-level design
   - C. **Detailed design** ✓
   - D. Maintenance

5. An engineer on call receives a notification that a set of APIs is returning HTTP 500 errors to most requests. What kind of documentation would the engineer turn to first?
   - A. Design documentation
   - B. User documentation
   - C. **Operations documentation** ✓
   - D. Developer documentation

6. As a developer, you write code locally, test it, and commit it to a version control system, where it is automatically incorporated with the baseline version. What is this process called?
   - A. Software continuity planning
   - B. **Continuous integration (CI)** ✓
   - C. Continuous development (CD)
   - D. Software development lifecycle (SDLC)

7. As a consulting architect, you have been asked to improve reliability of a distributed system. You start randomly shutting down servers and simulating network partitions to learn from experiments. This is an example of what practice?
   - A. Irresponsible behavior
   - B. Integration testing
   - C. Load testing
   - D. **Chaos engineering** ✓

8. During a post-mortem of a security breach where a developer included a private key in a version control repository (which was later publicly exposed via a misconfigured backup bucket), one of the objectives should be to:
   - A. Identify the developer who uploaded the private key — they are responsible
   - B. Identify the system administrator who backed up the repository — they are responsible
   - C. Identify the system administrator who misconfigured the storage system — they are responsible
   - D. **Identify ways to better scan code checked into the repository for sensitive information and perform checks on cloud storage systems to identify weak access controls** ✓

9. You have just been hired as a cloud architect for a large financial institution. What practices would you expect to find at the enterprise level that you might not find at a startup?
   - A. Agile methodologies
   - B. SDLC
   - C. **ITIL** ✓
   - D. Business continuity planning

10. A software engineer asks for the difference between business continuity planning and DR planning. What is the difference?
    - A. There is no difference; the terms are synonymous
    - B. They are two unrelated practices
    - C. **DR is a part of business continuity planning, which includes other practices for continuing business operations in the event of an enterprise-level disruption of services** ✓
    - D. Business continuity planning is a subset of disaster recovery

11. In addition to ITIL, which other standard might you reference when working on enterprise IT management issues?
    - A. **ISO/IEC 20000** ✓
    - B. Java Coding Standards
    - C. PEP-8
    - D. ISO/IEC 27002

12. A minor problem repeatedly occurs with several instances of an application, causing a slight increase in error rates. Users who retry usually succeed. Should you investigate?
    - A. No. The problem is usually resolved when users retry
    - B. No. New feature requests are more important
    - C. Yes. But only investigate if the engineering manager insists
    - D. **Yes. Since it is a recurring problem, there may be an underlying bug or design weakness that should be corrected** ✓

13. A CTO hires you to consult on IT practices. You realize the company has no business continuity plan. What would you recommend they develop first?
    - A. Recovery time objectives (RTO)
    - B. An insurance plan
    - C. **A disaster plan** ✓
    - D. A service management plan

14. A developer's new algorithm passes all CI/CD tests, but a sudden traffic spike causes the new code to generate many errors. After post-mortem analysis, what might the team decide to do?
    - A. Fire the developer who wrote the algorithm
    - B. Have at least two engineers review all code before release
    - C. **Perform stress tests on changes to code that may be sensitive to changes in load** ✓
    - D. Ask the engineering manager to provide additional training to the engineer

15. Your company's services are experiencing high error rates and dropping data ingest rates during hurricane season. Your data center is in a hurricane-prone area. What criteria do you use to decide to invoke your disaster recovery plan?
    - A. When your engineering manager says to invoke the disaster recovery plan
    - B. When the business owner of the service says to invoke the disaster recovery plan
    - C. **When the disaster plan criteria for invoking the disaster recovery plan are met** ✓
    - D. When the engineer on call says to invoke the disaster recovery plan
