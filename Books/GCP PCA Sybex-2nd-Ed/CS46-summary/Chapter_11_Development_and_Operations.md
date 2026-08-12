# Chapter 11: Development and Operations

---

![note](../images/note_24.png) **PROFESSIONAL CLOUD ARCHITECT CERTIFICATION EXAM OBJECTIVES COVERED IN THIS CHAPTER INCLUDE THE FOLLOWING:**

- **5.1 Advising development/operation team(s) to ensure successful deployment of the solution**
- **5.2 Interacting with Google Cloud programmatically**

---

## Application Development Methodologies

*Application development methodologies* are principles for organizing and managing software development projects. *Methodologies* provide a set of practices that developers and stakeholders follow in order to produce operational software.

When a problem is well understood and the deliverable functionality is known in detail, a linear process from requirements through design to coding may work well. However, for complex, evolving projects—such as a multi-platform mobile game with leaderboards—a strictly linear methodology is unlikely to succeed.

Three main paradigms or models of software development exist:

- Waterfall
- Spiral
- Agile

Waterfall methodologies are the oldest. Spiral and agile methodologies are designed to address waterfall's drawbacks.

### Waterfall

The *waterfall model* is aptly named because once a phase is completed, there is no going back. Typical phases:

- Requirements
- Design
- Implementation
- Testing and verification
- Maintenance

**Advantages:** Spending time in early stages should reduce overall costs. All requirements captured before design; detailed design reduces coding time.

**Drawbacks:** Does not work well when requirements cannot be completely known early or may change over time (e.g., user interface requirements, changing business requirements).

One way to allow for changing requirements is to revisit phases multiple times—leading to spiral methodologies.

### Spiral

*Spiral methodologies* drop the strict requirement of not returning to an earlier stage. They use similar phases to waterfall but work on a limited set of functionalities at a time. After completing all stages for one set, stakeholders determine what to work on next.

Each cycle in a spiral model includes:

- Understanding stakeholders' objectives
- Reviewing product and process alternatives
- Identifying risks and how to mitigate them
- Securing stakeholder commitment to the next iteration

**Advantages:** Learnings from each iteration apply to later iterations. Adaptive to changing business requirements—a component can be changed in a later iteration without disrupting the development flow.

### Agile

*Agile methodologies* are distinguished by close collaboration between developers and stakeholders and frequent code deployments. Core principles from the Agile Manifesto (`agilemanifesto.org`):

- Individuals and interactions over processes and tools
- Working software over comprehensive documentation
- Customer collaboration over contract negotiation
- Responding to change over following a plan

Like spiral, agile is iterative, but with shorter cycles and smaller deliverables. Each iteration includes planning, design, development, testing, and deployment.

**Key characteristics:**
- Focus on quality, including meeting business requirements and producing functional, maintainable code
- Testing is part of the development stage (not a separate post-development phase)
- Transparent processes with close collaboration between developers and business stakeholders

**When to use which methodology:**

| Methodology | Best suited for |
|---|---|
| Agile | Projects requiring close collaboration, rapid adaptation to changing business and technical requirements |
| Spiral | Complex processes that change slowly, many stakeholders and domain experts, requiring detailed analysis and documentation |
| Waterfall | Critical safety software with narrow, fixed requirements; extensive testing and verification required |

---

## Technical Debt

Application development involves trade-offs. When developers choose a design or coding method for expedience rather than quality, the application accumulates *technical debt*—code or design features that should be changed in the future.

Ward Cunningham (co-author of the Agile Manifesto) coined the term *technical debt*. Like monetary debt, technical debt incurs something analogous to interest: the loss of future productivity. Ideally, technical debt is paid down by refactoring code.

**Common causes of technical debt:**

- Insufficient understanding of requirements
- Need to deliver functional code by a set time or within a fixed budget
- Poor collaboration between teams developing in parallel
- Lack of coding standards
- Insufficient testing

**Types of technical debt:**

- **Code technical debt:** Suboptimal code choices made for expedience (e.g., minimal error handling, cursory code reviews)
- **Architecture design debt:** Architecture choices made for expedience that require rework later (e.g., designing for vertical scaling only, when the application eventually needs distributed architecture)
- **Environment debt:** Expedient choices around tooling (e.g., performing manual builds and test runs instead of implementing a CI/CD platform)

**Key points:**
- Incurring technical debt is not necessarily negative—it can enable a project to move forward and realize benefits
- *Not* paying down technical debt is the problem; it can lead to reliability issues, bugs in production, and adverse impacts on users
- Architects should be aware of the level of technical debt in a project and plan to pay it down

---

## API Best Practices

APIs provide programmatic access to services. APIs are often:

- **REST APIs:** Resource-oriented, use HTTP
- **RPC APIs:** Function-oriented, use sockets, designed for high efficiency

See the Google Cloud API Design Guide (`cloud.google.com/apis/design`) for design principles for both types.

### Resources and Standard Methods

APIs should be designed around resources and operations that can be performed on those resources. Resources have a resource name and a set of methods.

**Common HTTP methods for REST APIs:**

- GET
- POST
- PUT
- DELETE

*Custom methods* are used for functionality not available in standard methods. Standard methods are preferred over custom methods.

**Resource types:**
- **Simple resources:** A single entity
- **Collections:** Lists of resources of the same type; often support pagination, sort ordering, and filtering

**Resource naming:** Use a hierarchical model. Example resource name:

```
customers.example.com/contacts/somename@example.com/outgoing/message1
```

REST URL (includes API version number):

```
customers.example.com/v2/contacts/somename@example.com/outgoing/message1
```

**Standard HTTP error codes:**

| Code | Meaning |
|---|---|
| 200 | Successful call |
| 400 | Bad request (invalid argument) |
| 401 | Request not authenticated |
| 403 | Permission denied |
| 404 | Resource not found |
| 429 | Too many requests (throttling) |
| 500 | Unknown server error |
| 501 | Method not implemented by the API |
| 503 | Server unavailable |

**Additional best practices:**
- Restrict error message text to standard text (extra detail could be a security risk)
- Version APIs to improve stability and reliability; communicate deprecation and migration paths

### `API` Security

APIs should enforce controls to protect confidentiality, integrity, and availability.

- Confidentiality and integrity in transit: HTTPS-provided encryption
- Persistently stored data is encrypted by default in all Google Cloud storage systems
- Application designers are responsible for protecting data in use

#### Authentication

API functions execute operations on behalf of an identity (user or service account). Identities should be managed by Cloud Identity and IAM. Predefined roles in IAM accommodate common requirements.

One way to authenticate users: require an **API key**—a string of alphanumeric characters that uniquely identifies an app or device to a service.

#### Authorization

*JSON Web Tokens (JWT)* are commonly used for authorization. When users log in, they receive a JWT that is passed to subsequent API calls. A JWT is a JSON structure with three parts:

| Part | Description |
|---|---|
| **Header** | Type attribute (JWT) and signing algorithm |
| **Payload** | Set of claims about issuer, subject, or token; may include expiration time, subject name, or private application-specific claims |
| **Signature** | Output of the signature algorithm using header, payload, and a secret; validates the token has not been altered |

The JWT is encoded as three Base64-encoded strings separated by periods. A service should validate the signature before using the claims in the payload.

#### Resource Limiting

To prevent exhaustion of resources from excessive API calls (intentional or unintentional), APIs should include resource-limiting mechanisms.

- **Threshold limiting:** Set a maximum number of requests per user per time period (e.g., 100 API calls per minute). After the threshold is reached, no requests are executed until the next period.
- **Rate limiting:** Set a maximum rate (e.g., 100 requests per minute = one every 0.6 seconds). Requests exceeding the rate are dropped.
- **Overall limits:** Set higher limits on total requests regardless of individual users.

When limits are exceeded, return HTTP status code **429 (Too Many Requests)**. This is called *throttling*.

---

![note](../images/note_24.png) For more on API security, see the Open Web Application Security Project's (OWASP's) API Security project at `www.owasp.org/index.php/OWASP_API_Security_Project`.

---

## Testing Frameworks

Testing is an important activity in all software development methodologies. Automated testing enables efficient CI/CD.

### Testing Framework Models

| Framework | Description |
|---|---|
| **Data-driven testing** | Uses structured data sets (conditions/inputs and expected outputs) to drive tests; appropriate for APIs or command-line functions |
| **Modularity-driven testing** | Uses small scripts for limited functionalities, combined into higher-order test scripts |
| **Keyword-driven testing** | Separates test data from test instructions; each test identified by a keyword; steps are defined separately from data; well-suited to manual and automated UI testing |
| **Model-based testing** | Uses a simulation program (built in parallel with the system under test) to generate test data; uses finite state machine models or logical predicates |
| **Test-driven development** | Requirements mapped to tests; tests are narrow and specific; encourages small code units and frequent testing; code integrated once it passes its tests |
| **Hybrid testing** | Incorporates two or more distinct frameworks |

### Automated Testing Tools

- **pytest** (`docs.pytest.org/en/latest`): Python testing framework for unit tests
- **JUnit** (`junit.org/junit5`): Java testing framework for unit tests
- **Selenium** (`www.seleniumhq.org`): Open source browser automation tool; WebDriver API enables tests to simulate user browser interaction; scripts can be written in a programming language or with the Selenium IDE
- **Katalon Studio** (`www.katalon.com`): Open source interactive testing platform built on Selenium; supports web, mobile, and API testing
- **Fuzzers:** Tools that subject a program to semi-random inputs for an extended period to find bugs and security vulnerabilities at runtime (see `owasp.org/www-community/Fuzzing`)

---

## Data and System Migration Tooling

*Data and system migration tools* support the transition from on-premises or other clouds to GCP.

### Types of Cloud Migrations

| Strategy | Description |
|---|---|
| **Lift and shift** (re-hosting) | Infrastructure and data moved to the cloud with minimal changes |
| **Move and improve** | Infrastructure and architecture modified to take advantage of cloud (e.g., containers on Kubernetes Engine) |
| **Rebuild in the cloud** (rip and replace) | Legacy application replaced by a new, native cloud application |

**Additional migration strategy variations:**

- **Replatforming:** Application is not changed, but the platform it runs on is not available in the cloud; uses additional software to simulate the existing environment with minor code changes
- **Repurchasing:** Alternative to rebuild in the cloud
- **Retirement:** When applications do similar things, retire one and migrate the other
- **Retaining:** Required when there is an old application no one fully understands and lift-and-shift is not an option

**Key considerations for lift-and-shift migrations:**
- Inventory all applications, data sources, and infrastructure
- Identify dependencies between applications (influences migration order)
- Review software license agreements (site licenses may need revision for cloud deployment)

When migrating and changing applications, a detailed plan is needed identifying what systems will change, impacts on other systems, and migration order. Include training if there will be any user experience impact.

### Migration Services and Tools

Data transfer method is determined by:

- Volume of data
- Network bandwidth
- Workflow time constraints on data transfer
- Location of data

**Transfer time examples:**

| Data Volume | 100 Gbps | 1 Gbps |
|---|---|---|
| 1 GB | ~0.1 seconds | ~8 seconds |
| 1 PB | ~30 hours | >120 days |

**Transfer options:**

| Tool/Service | Best used for |
|---|---|
| **Storage Transfer Service** | Transfer from HTTP/S location, AWS S3 bucket, or another Cloud Storage bucket to Cloud Storage; recommended for AWS/other cloud-to-GCP transfers |
| **`gsutil` command-line utility** | Recommended for on-premises to Google Cloud transfers; multithreaded, supports parallel chunk loading, restarts after failures, tunable via parameters |
| **Google Transfer Appliance** | Large data volumes where network transfer would take too long; 40 TB (TA40) and 300 TB (TA400) appliances shipped to your site, filled, then returned to Google |
| **Third-party vendors** | Services from Zadara, Iron Mountain, Prime Focus Technologies |
| **Database Migration Service** | Migrates MySQL and PostgreSQL databases from on-premises, Compute Engine, or other clouds to Cloud SQL; supports continuous change data capture for minimal downtime |

---

![note](../images/note_24.png) Google has a table of transfer times by network bandwidth and data size at `cloud.google.com/solutions/transferring-big-data-sets-to-gcp`.

---

The GCP SDK is a set of command-line tools for managing Google Cloud resources. These commands allow management of infrastructure and operations from the command line instead of the console and are especially useful for automating routine tasks and viewing infrastructure state.

---

## Interacting with Google Cloud Programmatically

Developers, engineers, and others who work with Google Cloud have options for programmatic interaction: Google Cloud SDK, Google Cloud Shell, and emulators.

### Google Cloud `SDK`

The Cloud SDK includes:

| Tool | Purpose |
|---|---|
| **gcloud** | Command-line tool for interacting with most GCP services |
| **gsutil** | Command-line tool for working with Cloud Storage |
| **bq** | Command-line tool for working with BigQuery |

`gcloud`, `gsutil`, and `bq` are installed by default. Additional components can be installed with:

```bash
gcloud components install <component>
```

**Additional installable components:**

| Component | Purpose |
|---|---|
| **cbt** | Command-line tool for Bigtable (note: current `gcloud` versions include `gcloud bigtable`) |
| **kubectl** | Command-line tool for managing Kubernetes clusters |
| **pubsub emulator** | Cloud Pub/Sub emulator |

To list available components:

```bash
gcloud components list
```

Output includes: component name, ID, size, and status (not installed / installed / update available).

- Alpha/beta commands: `gcloud alpha` and `gcloud beta`
- Client libraries are available for: Java, Python, Ruby, PHP, C#, Node.js, and Go

---

![note](../images/note_24.png) Additional libraries may be developed in the future. The `gcloud alpha` and `gcloud beta` commands may change over time. See the Google Cloud documentation for the current list of available GCP SDK utilities, commands, and client libraries.

---

**Authorization:**

| Authorization type | Command |
|---|---|
| User account authorization | `gcloud init` |
| Service account authorization | `gcloud auth activate-service-account` |

### Google Cloud Shell

Google Cloud Shell is a managed service providing an online development environment with:

- Features of a Linux shell
- Pre-installed tools including Google Cloud SDK and kubectl
- Cloud Shell Editor
- Access from a web browser
- 5 GB of persistent storage

### Cloud Emulators

Google Cloud provides emulators for local development before running code in the cloud. This can help reduce cloud charges. Emulators are available for:

- Cloud Bigtable
- Cloud Datastore
- Cloud Firestore
- Cloud Pub/Sub
- Cloud Spanner

Emulators are installed using `gcloud` commands.

---

## Summary

Architects support application development and operations. Key areas include:

- Choosing an appropriate application development methodology (waterfall, spiral, or agile). Agile works well in many cases due to collaboration and rapid, incremental development.
- Planning to pay down technical debt, including code debt, architecture design debt, and environment debt.
- Following established API best practices: design around entities/resources, include security (authorization, rate limiting), and return standard HTTP error codes.
- Automating testing using frameworks such as data-driven, modularity-driven, keyword-driven, model-based, test-driven, and hybrid testing.
- Considering data volumes and bandwidth when choosing a migration method (Storage Transfer Service, gsutil, Transfer Appliance, Database Migration Service).
- Using the GCP SDK (`gcloud`, `gsutil`, `bq`) for automating and managing GCP resources from the command line.

---

## Exam Essentials

- **Know the defining characteristics of different application development methodologies.** Waterfall is a linear process that does not repeat a phase once completed. Spiral repeats the main phases iteratively; at the beginning of each iteration, stakeholders define scope and identify risks. Agile is highly collaborative, transparent, and focused on frequent code releases.

- **Understand technical debt.** Coding and design decisions made in a broad business context (e.g., to hit a release date) can result in suboptimal code—technical debt. It is repaid by refactoring. Architects and developers should treat paying down technical debt as a necessary part of the software development process.

- **Know API best practices.** APIs should be designed around resources and operations on those resources. Standard methods are list, get, create, update, and delete. When an API call results in an error, a standard HTTP error should be returned; additional detail can be provided in the message payload.

- **Understand ways of securing APIs.** Confidentiality and integrity in motion are protected by HTTPS. One authentication mechanism is requiring an API key. JWTs are commonly used for authorization. APIs should include resource-limiting mechanisms to prevent unauthorized use of system resources. Resource limiting is often implemented by API gateways (GCP offers API Gateway for basic needs and Apigee for feature-rich needs).

- **Understand that there are a variety of testing frameworks and test automation tools.** Testing frameworks include data-driven, modularity-driven, keyword-driven, model-based, test-driven, and hybrid testing. Tools range from language-specific frameworks to general-purpose testing platforms.

- **Know the different kinds of migrations.** Cloud migrations are categorized as lift and shift, move and improve, and rebuild in the cloud. When deciding on a transfer method, consider volume of data, network bandwidth, workflow time constraints, and location of data.

- **Understand how and when to use the GCP SDK.** The GCP SDK (`gcloud`, `gsutil`, `bq`) allows management of infrastructure and operations from the command line. It is especially useful for automating routine tasks and viewing infrastructure state.

---

## Review Questions

1. A team of developers is tasked with developing an enterprise application. They have interviewed stakeholders and collected requirements. They are now designing the system and plan to begin implementation next. After implementation, they will verify that the application meets specifications. They will not revise the design once coding starts. What application development methodology is this team using?
   1. Extreme programming
   2. Agile methodology
   3. **Waterfall methodology**
   4. Spiral methodology

2. A team of developers is tasked with developing an enterprise application. They have interviewed stakeholders and set a scope of work that will deliver a subset of the functionality needed. Developers and stakeholders have identified risks and ways of mitigating them. They then proceed to gather requirements for the subset of functionalities to be implemented. That is followed by design, implementation, and testing. There is no collaboration between developers and stakeholders until after testing, when developers review results with stakeholders and plan the next iteration of development. What application development methodology is this team using?
   1. Extreme programming
   2. Agile methodology
   3. Waterfall methodology
   4. **Spiral methodology**

3. A team of developers is tasked with developing an enterprise application. They meet daily with stakeholders to discuss the state of the project. The developers and stakeholders have identified a set of functionalities to be implemented over the next two weeks. After some design work, coding begins. A new requirement is discovered, and developers and stakeholders agree to prioritize implementing a feature to address this newly discovered requirement. As developers complete small functional units of code, they test it. If the code passes the tests, the code unit is integrated with the version-controlled codebase. What application development methodology is this team using?
   1. Continuous integration
   2. **Agile methodology**
   3. Waterfall methodology
   4. Spiral methodology

4. You are a developer at a startup company that is planning to release its first version of a new mobile service. You have discovered a design flaw that generates and sends more data to mobile devices than is needed. This is increasing the latency of messages between mobile devices and backend services running in the cloud. Correcting the design flaw will delay the release of the service by at least two weeks. You decide to address the long latency problem by coding a workaround that does not send the unnecessary data. The design flaw is still there and is generating unnecessary data, but the service can ship under these conditions. This is an example of what?
   1. **Incurring technical debt**
   2. Paying down technical debt
   3. Shifting risk
   4. Improving security

5. You are a developer at a startup company that has just released a new service. During development, you made suboptimal coding choices to keep the project on schedule. You are now planning your next two weeks of work, which you decide will include implementing a feature the product manager wanted in the initial release but was postponed to a release occurring soon after the initial release. You also include time to refactor code that was introduced to correct a bug found immediately before the planned release date. That code blocks the worst impact of the bug, but it does not correct the flaw. Revising that suboptimal code is an example of what?
   1. Incurring technical debt
   2. **Paying down technical debt**
   3. Shifting risk
   4. Improving security

6. As a developer of a backend service for managing inventory, your manager has asked you to include a basic API for the inventory service. You plan to follow best-practice recommendations. What is the minimal set of API functions that you would include?
   1. Create, read, update, and delete
   2. **List, get, create, update, and delete**
   3. Create, delete, and list
   4. Create and delete

7. A junior developer asks your advice about handling errors in API functions. The developer wants to know what kind of data and information should be in an API error message. What would you recommend?
   1. Return HTTP status 200 with additional error details in the payload.
   2. **Return a status code form with the standard 400s and 500s HTTP status codes with no additional error details in the response body.**
   3. Return error details in the payload, and do not return a code.
   4. Define your own set of application-specific error codes.

8. A junior developer asks your advice about verifying authorizations in API functions. The developer wants to know how they can allow users of the API to make assertions about what they are authorized to do. What would you recommend?
   1. **Use JSON Web Tokens (JWTs)**
   2. Use API keys
   3. Use encryption
   4. Use HTTPS instead of HTTP

9. Your startup has released a new online game that includes features that allow users to accumulate points by playing the game. Points can be used to make in-game purchases. You have discovered that some users are using bots to play the game programmatically much faster than humans can play the game. The use of bots is unauthorized in the game. You modify the game API to prevent more than 10 function calls per user, per minute. This is an example of what practice?
   1. Encryption
   2. Defense in depth
   3. Least privileges
   4. **Resource limiting**

10. A team of developers is creating a set of tests for a new service. The tests are defined using a set of conditions or input values and expected output values. The tests are then executed by reading the test data source, and for each test the software being tested is executed, and the output is compared to the expected value. What kind of testing framework is this?
    1. **Data-driven testing**
    2. Hybrid testing
    3. Keyword-driven testing
    4. Model-based testing

11. Your company is moving an enterprise application to Google Cloud. The application runs on a cluster of virtual machines, and workloads are distributed by a load balancer. Your team considered revising the application to use containers and the Kubernetes Engine, but they decide not to make any unnecessary changes before moving the application to the cloud. This is an example of what migration strategy?
    1. **Lift and shift**
    2. Move and improve
    3. Rebuild in the cloud
    4. End of life

12. As a consultant to an insurance company migrating to the Google Cloud, you have been asked to lead the effort to migrate data from AWS S3 to Cloud Storage. Which transfer method would you consider first?
    1. **Google Transfer Service**
    2. `gsutil` command line
    3. Google Transfer Appliance
    4. Cloud Dataproc

13. You are a consultant to an insurance company migrating to GCP. Five petabytes of business-sensitive data need to be transferred from the on-premises data center to Cloud Storage. You have a 10 GB network between the on-premises data center and Google Cloud. What transfer option would you recommend?
    1. `gsutil`
    2. `gcloud`
    3. **Cloud Transfer Appliance**
    4. Cloud Transfer Service

14. You are migrating a data warehouse from an on-premises database to BigQuery. You would like to write a script to perform some of the migration steps. What component of the GCP SDK will you likely need to use to create the new data warehouse in BigQuery?
    1. `cbt`
    2. **`bq`**
    3. `gsutil`
    4. `kubectl`

15. You are setting up a new laptop that is configured with a standard set of tools for developers and architects, including some GCP SDK components. You will be working extensively with the GCP SDK and want to know specifically which components are installed and up-to-date. What command would you run on the laptop?
    1. `gsutil component list`
    2. `cbt component list`
    3. **`gcloud component list`**
    4. `bq component list`
