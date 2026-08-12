# Chapter 7: Designing for Security and Legal Compliance

**Exam Objectives Covered:**
- 3.1 Designing for security
- 3.2 Designing for compliance

---

## Identity and Access Management and Related Access Control Services

The *Identity and Access Management (IAM)* service specifies what operations specific users can perform on particular resources — "who gets to do what on which resources." IAM is the recommended way to control access in most cases. In limited cases (e.g., development environments), the older basic roles system may be used.

The primary elements of IAM are:

- Identities and groups
- Resources
- Permissions
- Roles
- Policies

### Identities and Groups

#### Identities

An *identity* represents a person or agent that performs actions on a GCP resource. Identities are sometimes called *members*. There are three kinds:

| Identity Type | Description |
|---|---|
| Google account | Used by people (developers, admins). Designated by an email linked to a Google account (e.g., `jane.doe@gmail.com`). |
| Service account | Used by applications running in GCP. Designated by an email (e.g., `gcp-arch-exam@gcp-certs-1.iam.gserviceaccount.com`). App Engine service accounts use the `appspot.gserviceaccount.com` domain. |
| Cloud Identity | An IDaaS offering for users without Google or G Suite accounts. Can delegate authentication to other providers using OIDC or SAML. |

#### Groups

*Google Groups* are sets of Google accounts and service accounts, with an associated email address. They are useful for assigning permissions to sets of users — users added to the group acquire the group's permissions; removed users lose them. Google Groups do not have login credentials and cannot be used as an identity.

*G Suite domains* group all users of a G Suite account. Like Google Groups, they can specify sets of users but are not identities.

### Resources

*Resources* are entities in Google Cloud that can be accessed by users. The category includes virtually everything that can be created in GCP:

- Projects
- Virtual machines
- App Engine applications
- Cloud Storage buckets
- Pub/Sub topics

Each resource type has a defined set of associated permissions.

### Permissions

A *permission* is a grant to perform some action on a resource. Permissions are fine-grained and there is essentially a one-to-one relationship between things you can do in GCP and the permission to do them.

**Compute Engine permission examples:**
- `compute.instances.get`
- `compute.networks.use`
- `compute.securityPolicies.list`

**Cloud Storage permission examples:**
- `resourcemanager.projects.get`
- `resourcemanager.projects.list`
- `storage.objects.create`

**BigQuery permission example:**
- `bigquery.tables.create`

**Cloud Pub/Sub permission example:**
- `pubsub.subscriptions.consume`

Administrators do not work directly with permissions; instead they work with *roles*, which are collections of permissions.

### Roles

*Roles* are sets of permissions. Administrators grant roles (not permissions) to identities. You cannot grant a permission directly to a user — it must be done through a role.

Roles can be granted to identities for projects, folders, or organizations, and they apply to all resources under those entities. There are three types of roles:

#### Predefined Roles

*Predefined roles* are created and managed by GCP. They are organized around common IT tasks.

**Naming convention:** `roles/<service>.<function>`

Examples:
- `roles/bigquery.admin`
- `roles/bigquery.dataEditor`
- `roles/cloudfunction.developer`
- `roles/cloudsql.viewer`

Common function names: `viewer`, `admin`, `editor`.

#### Basic Roles

*Basic roles* (formerly *primitive roles*) predate IAM. There are three:

| Role | Capabilities |
|---|---|
| Viewer | Read-only access to a resource |
| Editor | All Viewer capabilities + ability to modify resource state |
| Owner | All Editor capabilities + manage roles/permissions + set up billing |

**Best practice:** Favor predefined roles over basic roles. Basic roles are acceptable only for small, trusted teams (e.g., a DevOps team in a development environment).

#### Custom Roles

*Custom roles* let administrators specify a precise set of permissions when predefined roles do not fit. This supports the principle of least privilege.

**Example:** If a developer needs all permissions of `roles/cloudfunctions.developer` except `cloudfunctions.functions.sourceCodeSet`, create a custom role that includes all permissions of that predefined role minus the unwanted one.

### Policies

A *policy* is a set of statements that define a combination of users (members) and roles. The combination of users and a role is called a *binding*. Policies are specified in JSON.

**Example policy:**

```json
{
  "bindings": [
    {
      "role": "roles/storage.objectAdmin",
      "members": [
        "user:alice@example.com",
        "serviceAccount:my-other-app@appspot.gserviceaccount.com",
        "group:admins@example.com",
        "domain:google.com"
      ]
    },
    {
      "role": "roles/storage.objectViewer",
      "members": ["user:bob@example.com"]
    }
  ]
}
```
*Source: cloud.google.com/iam/docs/overview*

The Cloud IAM API provides three functions:

| Function | Description |
|---|---|
| `setIamPolicy` | Set policies on resources |
| `getIamPolicy` | Read policies on resources |
| `testIamPermissions` | Test whether an identity has a permission on a resource |

Policies can be set at the organization, folder, project, or individual resource level. Policies assigned to higher levels are inherited by lower levels in the hierarchy.

![Snapshot of Google Cloud Platform resource hierarchy](../images/c07f001.png)

**FIGURE 7.1** Google Cloud Platform resource hierarchy

### Cloud IAM Conditions

Cloud IAM Conditions allows you to specify and enforce conditional access controls based on resource attributes. Conditions are defined in resource role bindings and expressed using the **Common Expression Language (CEL)**.

CEL supports:
- **Resource attributes:** type, name, tags
- **Request attributes:** access level, date/time, destination IP address and port

GCP services that support conditional role bindings: Bigtable, Cloud KMS, Cloud SQL, Cloud Storage, Compute Engine, Identity-Aware Proxy, Resource Manager, and Secret Manager.

> **Note:** IAM Conditions are available only for Cloud Storage buckets using uniform bucket-level access.

### IAM Best Practices

Reference: `cloud.google.com/iam/docs/using-iam-securely`

- **Favor predefined roles over basic roles.** Use basic roles only for small teams or dev/test environments. Assign the most restricted set of predefined roles needed.
- **Use trust boundaries.** For each service in an application, use a separate service account with only the required roles. This limits blast radius if a service is compromised.
- **Review policy placement in the resource hierarchy.** Folders inherit from organizations; projects inherit from organizations and their containing folders. Policies assigned to a child entity cannot affect its parent.
- **Restrict access to IAM admin roles.** The `Project IAM Admin` and `Folder IAM Admin` roles allow policy modification but do not grant resource-level permissions. The effective policy for a resource is the union of the policy set at that resource and the policy inherited from its parent.
- **Use groups for multiple-role assignments.** Grant roles to a group and add users to the group, so changing permissions only requires updating the group.
- **Review Cloud Audit Logs for IAM policy changes.** Limit access to audit logs using roles like `roles/logging.viewer` and `roles/logging.privateLogViewer`. Restrict `roles/logging.admin`.

### Identity-Aware Proxy

Identity-Aware Proxy (IAP) is an application layer (layer 7) access control for HTTPS applications. It allows you to define access control policies for applications and resources.

- Applications using IAP provide access to users with proper IAM roles.
- When IAP is enabled, the IAP authentication server checks browser credentials; if absent, the user is redirected to sign in via OAuth 2.0.
- **Important:** When using IAP, implement network controls to prevent traffic that does not come through the IAP serving infrastructure.
- **IAP for On-Premises Apps** allows protection of applications running outside GCP.

### Workload Identity Federation

Workload Identity Federation allows you to use IAM to grant external identities IAM roles.

- Workload identities are organized into **workload identity pools**. Google recommends separate pools for each external environment.
- Supported identity providers: AWS, Azure Active Directory, on-premises Active Directory, Okta, Kubernetes clusters.
- Implemented using **SAML** or **OAuth 2.0 token exchange**.
- Credentials include attributes mapped to equivalent attributes in a Google Cloud token. Attribute conditions using CEL are supported.
- Supports **service account impersonation** by granting `roles/iam.workloadIdentityUser` on the target service account.

---

## Organization Constraints

In addition to IAM, organization policy constraints can limit what users and service accounts can do. A **constraint** is a rule preventing certain actions or configurations.

**Multi-service constraints:**
- **Resource Location Restriction** — defines where location-based resources can be created
- **Restrict Allowed Google Cloud APIs and services** — limits which APIs can be enabled

**Service-specific constraint examples:**

| Constraint | Description |
|---|---|
| App Engine Disable Source Code Download | Prevents download of code uploaded to App Engine |
| Cloud Run Allowed Binary Authorization Policies | Defines allowed Binary Authorization policy names for Cloud Run |
| Cloud SQL Restrict Public IP Access | Restricts public IP use on Cloud SQL instances |
| Cloud Storage Enforce Public Access Prevention | Prevents public access to Cloud Storage data |
| Compute Engine Shielded VMs | Requires all new VMs to use Shielded disk images |
| IAM Disable Cross-Project Service Account Usage | Prevents service accounts from being used outside the project they were created in |

Full list: `cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints`

---

## Data Security

GCP provides multiple mechanisms for securing data beyond IAM, including encryption and key management.

### Encryption

*Encryption* is the process of encoding data so that it cannot be practically converted back to the original form without a key.

#### Encryption at Rest

Google encrypts data at rest **by default** — no configuration is needed. This applies to all Google data storage services (Cloud Storage, Cloud SQL, Cloud Bigtable, etc.).

Encryption occurs at multiple levels:

| Level | Method |
|---|---|
| Platform | Database and file data protected using AES256 and AES128 |
| Infrastructure | Data grouped into chunks; each chunk encrypted with AES256 |
| Hardware | Storage devices apply AES256 (some older persistent disks use AES128) |

**Chunk-level encryption details:**
- Data is stored in subfile chunks (up to several gigabytes).
- Each chunk is encrypted with its own **data encryption key (DEK)**.
- If a chunk is updated, a new key is used — keys are never reused.
- Each chunk has a unique identifier referenced by ACLs.
- DEKs are themselves encrypted using a **key encryption key (KEK)** — this is called **envelope encryption**.

**Summary of encryption at rest:**
- Data at rest is encrypted by default.
- Encryption occurs at application, infrastructure, and device levels.
- Each data chunk has its own DEK.
- DEKs are encrypted using a KEK.

#### Encryption in Transit

*Encryption in transit* (also called *encryption in motion*) protects data confidentiality and integrity when data is intercepted in transit.

| Scope | Behavior |
|---|---|
| Within Google network | Data is authenticated but may not be encrypted |
| Outside Google network (internet) | Data is always encrypted |

- Incoming user traffic is routed to the **Google Front End** — a globally distributed proxy service that terminates HTTP/HTTPS traffic, routes it over the Google network, and protects against DDoS attacks. It also implements global load balancers.
- Traffic to all Google Cloud services is encrypted by default using **TLS** or **QUIC** (Google-developed protocol).
- Within Google Cloud infrastructure, **Application Layer Transport Security (ALTS)** is used for authentication and encryption at layer 7 of the OSI model.

### Key Management

#### Default Encryption

Google manages encryption keys by default. Customers have no access to keys or control over key rotation.

- DEKs are stored near the data chunks they encrypt.
- One KEK can encrypt multiple DEKs.
- KEKs are stored in a centralized key management service.
- When data is retrieved, the storage system sends the DEK to the key management service for decryption and authentication.

#### Cloud KMS Key Management

*Cloud KMS* is a hosted key management service in Google Cloud. Customers generate and store keys in GCP while retaining control over key management.

- Supports AES256, RSA 2048, RSA 3072, RSA 4096, EC P256, EC P384 cryptographic keys.
- Provides automatic key rotation and DEK encryption with KEKs.
- Keys can be destroyed with a **24-hour delay** (safety window for accidental or malicious deletion).
- Can be used for application-level encryption in Compute Engine, BigQuery, Cloud Storage, and Cloud Dataproc.
- Allows import of externally managed keys.

#### Cloud HSM

*Cloud HSM* provides support for using keys only on **FIPS 140-2 level 3** hardware security modules (HSMs).

- FIPS 140-2 is a U.S. government standard for cryptographic modules.
- Level 3 requires tamper-evident physical security and protections against tampering attempts.

#### Customer-Supplied Keys

*Customer-supplied keys* give organizations complete control over key management, including storage.

- Keys are generated and kept **on-premises**.
- Keys are passed with arguments to API function calls.
- When sent to GCP, keys are stored in memory while in use — **not written to persistent storage**.

#### Customer-Managed Encryption Keys (CMEKs)

CMEKs are managed by customers using Cloud KMS.

- Customers have more control over the key lifecycle.
- Customers can limit Google Cloud's ability to decrypt data by disabling keys.
- Keys can be rotated automatically or manually.

#### Cloud External Key Manager (Cloud EKM)

Cloud EKM allows customers to manage keys outside of Google Cloud and configure Cloud KMS to use those externally managed keys.

**Key management comparison summary:**

| Method | Key Storage | Customer Control |
|---|---|---|
| Default encryption | Google-managed (centralized KMS) | None |
| Cloud KMS | Cloud (GCP) | Manages generation, rotation, destruction |
| Cloud HSM | FIPS 140-2 level 3 HSM (cloud) | High, hardware-backed |
| Customer-supplied keys | On-premises | Complete |
| CMEKs | Cloud KMS | Lifecycle control, can disable keys |
| Cloud EKM | External (outside GCP) | Complete, externally managed |

### Cloud Storage Data Access

When creating a Cloud Storage bucket, you choose between:

| Access Type | Description |
|---|---|
| **Uniform bucket-level access** | Uses only IAM for permissions (Google recommended) |
| **Fine-grained access** | Enables ACLs along with IAM; legacy method for S3 interoperability |

Additional Cloud Storage access controls:

- **Signed URLs** — provide access to specific objects for a short period of time; useful for granting limited access to objects in an otherwise restricted bucket.
- **Public access** — buckets can be made publicly accessible; administrators can prevent this by enabling the public access prevention resource constraint.
- **Signed policy documents** — restrict what can be uploaded (object size, content type, other characteristics).

**Data integrity validation:** Use CRC32C (Google-recommended, supports composite objects) or MD5 checksums to validate uploads and downloads.

---

## Security Evaluation

### Penetration Testing

*Penetration testing* simulates an attack on an information system to find potential vulnerabilities. Tests are authorized by system owners.

**The five phases of penetration testing:**

| Phase | Description |
|---|---|
| **Reconnaissance** | Gathering information about the target system, people, and software. May include phishing attacks. |
| **Scanning** | Automated probing of ports and checking for known/unpatched vulnerabilities. |
| **Gaining access** | Exploiting information from the first two phases to access the target system. |
| **Maintaining access** | Hiding presence by manipulating logs or concealing attack processes. |
| **Removing footprints** | Eliminating indications of intrusion — manipulating audit logs, deleting attack data/code. |

> **Note:** You do not have to notify Google when conducting a penetration test, but you must still comply with GCP terms of service.

**Resources for penetration testing:**
- Highly Adaptive Cybersecurity Services: `www.gsa.gov/technology/technology-products-services/it-security/highly-adaptive-cybersecurity-services-hacs`
- Penetration Testing Execution Standard: `www.pentest-standard.org/index.php/Main_Page`
- OWASP: `owasp.org/www-project-penetration-testing-kit`

### Auditing

*Auditing* is reviewing what has happened on your system.

- Applications should generate logs for significant and security-related events (e.g., granting administrator rights).
- The **Cloud Logging agent** collects logs for widely used services: syslog, Jenkins, Memcached, MySQL, PostgreSQL, Redis, ZooKeeper. Full list: `cloud.google.com/logging/docs/agent/default-logs`
- Managed services (Compute Engine, Cloud SQL, App Engine) log information to Cloud Logging.

**Cloud Audit Logs** records:

| Log Type | Description |
|---|---|
| Admin Activity | Administrative actions that modify configurations or metadata of resources (always logged) |
| Data Access | Creates, modifies, or reads data; can be configured per GCP service due to volume |
| System Event | Generated by Google Cloud systems; records resource configuration modification actions |
| Policy Denied | Records when Google Cloud denies access due to a security policy |

Logs are retained for a limited period. Export logs to meet longer retention requirements.

**Export methods from Cloud Logging:**

| Method | Destination |
|---|---|
| JSON files | Cloud Storage |
| Logging tables | BigQuery datasets |
| JSON messages | Cloud Pub/Sub |

Use Cloud Storage lifecycle management policies to move logs to Nearline/Coldline storage or delete them at a specified age.

---

## Security Design Principles

### Separation of Duties

*Separation of duties (SoD)* is the practice of limiting a single individual's responsibilities to prevent the person from acting alone in a way that is detrimental to the organization.

**IT example:** If a developer can deploy code to production, a different developer must perform the final code review before deployment.

**Enterprise example:** A senior manager approves granting root privileges; a different system administrator actually creates the account.

**Limitations:** In small organizations, insufficient staff may make full SoD impractical. Third-party audits can help mitigate this risk.

### Least Privilege

*Least privilege* is the practice of granting only the minimal set of permissions needed to perform a duty. GCP's fine-grained IAM roles enable this.

**App Engine role examples:**

| Role | Permissions |
|---|---|
| `roles/appengine.appAdmin` | Read, write, and modify access to all application configuration and settings |
| `roles/appengine.appViewer` | Read-only access to all application configuration and settings |
| `roles/appengine.codeViewer` | Read-only access to configuration, settings, and deployed source code |
| `roles/appengine.deployer` | Read-only access to configuration/settings; write access to create new versions; cannot modify existing versions |
| `roles/appengine.serviceAdmin` | Read-only access to configuration/settings; write access to module-level and version-level settings; cannot deploy new versions |

Basic roles (viewer, editor, owner) grant broad permissions and are **not suitable** for implementing least privilege in most production scenarios.

### Defense in Depth

*Defense in depth* is the practice of using more than one security control to protect resources and data. It prevents an attacker from gaining access by exploiting a single vulnerability.

**Example:** A database requires both authentication AND firewall rules. Stealing credentials alone is insufficient if the attacker cannot reach the database from an untrusted IP.

**Historical examples of single-control failures:**
- 2014: **Heartbleed** vulnerability in OpenSSL allowed attackers to read server/client memory. (`heartbleed.com`)
- 2021: **Log4j** vulnerability allowed unauthenticated remote actors to execute arbitrary code. (`security.googleblog.com/2021/12/understanding-impact-of-apache-log4j.html`)

Defense in depth assumes that any security control can be compromised.

---

## Major Regulations

> ![note](../images/note_24.png) Compliance is a **shared responsibility** of Google and GCP customers. Google protects the physical infrastructure and lower platform levels. Customers are responsible for application-level security, access controls, and proper resource configuration.

### HIPAA/HITECH

**HIPAA** (Health Insurance Portability and Accountability Act) is a U.S. federal law (1996, updated 2003 and 2005) protecting individuals' healthcare information.

| Rule | Description |
|---|---|
| **HIPAA Privacy Rule** | Sets limits on data sharing by healthcare providers/insurers; grants patients rights to review records. Reference: `www.hhs.gov/hipaa/for-professionals/privacy/index.html` |
| **HIPAA Security Rule** | Defines standards for protecting electronic healthcare records — requires confidentiality, integrity, availability; security management; access controls; incident response; contingency planning. Reference: `www.hhs.gov/hipaa/for-professionals/security/index.html` |

**HITECH** (Health Information Technology for Economic and Clinical Health Act, 2009) extended HIPAA to business associates of healthcare providers and insurers.

All Google Cloud infrastructure is covered under Google's **Business Associate Agreement (BAA)**. Many GCP services are covered, including Compute Engine, App Engine, Kubernetes Engine, BigQuery, and Cloud SQL. Full list: `cloud.google.com/security/compliance/hipaa`

More on HITECH: `www.hhs.gov/hipaa/for-professionals/special-topics/hitech-act-enforcement-interim-final-rule/index.html`

### General Data Protection Regulation

**GDPR** (passed 2016, enforcement began 2018) standardizes privacy protections across the EU and grants individuals control over their private information.

| Role | Responsibility |
|---|---|
| **Controller** | Determines purpose and means of processing personal data; manages consent; directs processors |
| **Processor** | Processes data on behalf of a controller; secures data; conducts audits |

In the event of a data breach: processors notify the controller → controllers notify the supervising authority and affected individuals.

More information: `gdpr-info.eu`

### Sarbanes-Oxley Act

**SOX** is a U.S. federal law (2002) protecting the public from fraudulent accounting practices in publicly traded companies.

SOX has three rules covering:
1. Destruction and falsification of records
2. Retention period of records
3. Types of records that must be kept

Requirements in practice:
- Encryption and key management to protect data confidentiality
- Access controls to protect data integrity
- Annual audits

More information: `www.soxlaw.com`

### Children's Online Privacy Protection Act

**COPPA** is a U.S. federal law (1998) requiring the FTC to define and enforce regulations on children's online privacy. It applies to websites and online services that collect information about children **under age 13**.

Required actions for online service operators:

- Post clear and comprehensive privacy policies
- Provide direct notice to parents before collecting a child's personal information
- Give parents a choice about how a child's data is used
- Give parents access to data collected about a child
- Give parents the opportunity to block collection of a child's data
- Retain data only as long as needed to fulfill the purpose for which it was created
- Maintain confidentiality, integrity, and availability of collected data

**Personal information covered:** name, address, online contact information, telephone number, geolocation data, photographs.

More information: `www.ftc.gov/tips-advice/business-center/guidance/complying-coppa-frequently-asked-questions`

---

## ITIL Framework

*ITIL* (formerly *Information Technology Infrastructure Library*) is a set of IT service management practices for aligning IT activities with business goals. ITIL specifies **34 practices** grouped into three areas:

| Area | Practices Include |
|---|---|
| **General management practices** | Strategy, architecture, risk management, security management, project management |
| **Service management practices** | Business analysis, service design, capacity and performance management, incident management, IT asset management |
| **Technical management practices** | Deployment management, infrastructure management, software development management |

Reason to adopt ITIL: Establish repeatable good practices that span business and technical domains.

More information: `www.tsoshop.co.uk/product/9789401804394/Business-and-Management/ITIL-4-pocket-guide`

---

## Summary

Designing for security and compliance is multifaceted:

- **IAM** manages identities, groups, roles, permissions, and policies. Predefined roles are preferred over basic roles in most situations. Policies associate sets of roles and permissions with resources.
- **Encryption** protects data in transit and at rest. Google Cloud encrypts data at rest by default. Customers can manage their own keys.
- **Security best practices** include separation of duties and defense in depth.

---

## Exam Essentials

- **Know the key components of the IAM service.** Identities and groups, resources, permissions, roles, and policies. Identities: Google account, service account, or Cloud Identity account. Can be collected into Google Groups or G Suite groups.
- **Understand roles are sets of permissions.** IAM permissions are granted to roles; roles are granted to identities. You cannot grant a permission directly to an identity. Predefined roles map to common organizational roles. Custom roles can be created when predefined roles do not fit.
- **Basic roles should be used in limited situations.** Owner, editor, viewer. These grant coarse-grained permissions. Use only when broad access is needed (e.g., developers in a dev environment). Favor predefined roles.
- **Resources are entities in GCP controlled by IAM.** Includes projects, VMs, storage buckets, Pub/Sub topics. Permissions vary by resource type. Role patterns like admin and viewer are used across entity types.
- **Policies associate sets of roles and permissions with resources.** A policy is a set of bindings (user + role combinations) specified in JSON. Used in addition to IAM identity-based controls.
- **Understand the resource hierarchy.** Organizations → Folders → Projects → Resources. Access controls at higher levels are inherited by lower levels. Access assigned to a child entity does not affect its parent.
- **Know that Google encrypts data at rest by default.** At the platform level (AES256/AES128), infrastructure level (AES256 per chunk), and hardware level (AES256 or AES128).
- **Data at rest is encrypted with a DEK, which is encrypted with a KEK.** Data is encrypted in chunks; DEK kept near data. The service's KEK encrypts the DEK. Google manages rotating KEKs.
- **Understand how Google encrypts data in transit.** Within the Google network: authenticated but may not be encrypted. Outside the Google network: always encrypted.
- **Know the three types of key management.** (1) Default (Google manages all); (2) Cloud KMS (customer manages, keys stored in cloud); (3) Customer-supplied keys (managed and stored on-premises).
- **Understand penetration testing and auditing.** Penetration testing finds vulnerabilities by simulating attacks. No need to notify Google. Auditing ensures security controls are in place and functioning.
- **Know security best practices.** Separation of duties, least privilege, defense in depth.
- **Understand how security controls support regulatory compliance.** Common requirements: confidentiality, integrity, availability. Architects should understand broad requirements of regulations like HIPAA/HITECH, GDPR, SOX, and COPPA.

---

## Review Questions

1. A company is migrating an enterprise application to Google Cloud. When running on-premises, application administrators created user accounts to run background jobs — no actual user was associated with the account. What kind of identity would you recommend using when running that application in GCP?
   - A. Google-associated account
   - B. Cloud Identity account
   - C. **Service account** ✓
   - D. Batch account

2. You are tasked with managing roles and privileges for developers, QA testers, and site reliability engineers. Individuals frequently move between groups. Each group requires a different set of permissions. What is the best way to grant access?
   - A. **Create a Google Group for each group; add user identities to their respective group; assign predefined roles to each group.** ✓
   - B. Create a Google Group for each group; assign permissions to each user, then add identities to the group.
   - C. Assign each user a Cloud Identity and grant permissions directly to those identities.
   - D. Create a G Suite group for each group; assign permissions to each user, then add identities to the group.

3. You are presenting on GCP security and someone asks how GCP supports least privilege. What would you say?
   - A. GCP provides three broad roles: owner, editor, viewer.
   - B. **GCP provides fine-grained permissions and predefined roles assigned those permissions, based on commonly grouped responsibilities. Users are assigned only the predefined roles they need.** ✓
   - C. GCP provides several types of identities, and users are assigned the most suitable type.
   - D. GCP provides fine-grained permissions and custom roles created and managed by cloud users.

4. An online application has a front-end service, a back-end business logic service, and a Cloud SQL PostgreSQL database. How many trust domains should be used?
   - A. 1
   - B. 2
   - C. **3** ✓
   - D. None — these services do not need trust domains.

5. In the interest of separating duties, one team member will have all permissions on logs, rotating every 90 days. How would you grant the necessary permissions?
   - A. **Create a Google Group, assign `roles/logging.admin` to the group, add the identity of the current log admin at the start of the 90-day period, and remove the identity of the previous admin.** ✓
   - B. Assign `roles/logging.admin` directly to the identity at the start of the period and revoke from the previous admin.
   - C. Create a Google Group, assign `roles/logging.privateLogViewer` to the group, and rotate identities every 90 days.
   - D. Assign `roles/logging.privateLogViewer` directly to each identity and rotate every 90 days.

6. Your company must comply with regulations requiring all personal healthcare data to be encrypted when persistently stored. What must you do to ensure applications processing this data encrypt it when stored on disk or SSD?
   - A. Configure a database to use database encryption.
   - B. Configure persistent disks to use disk encryption.
   - C. Configure the application to use application encryption.
   - D. **Nothing. Data is encrypted at rest by default.** ✓

7. At the device level, how is data encrypted in GCP?
   - A. **AES256 or AES128 encryption** ✓
   - B. Elliptic curve cryptography
   - C. Data Encryption Standard (DES)
   - D. Blowfish

8. In GCP, each data chunk is encrypted with a DEK stored close to the data. How does GCP protect the DEK so an attacker with access to the storage system cannot use it?
   - A. Writes the DEK to a hidden location on disk
   - B. **Encrypts the DEK with a key encryption key (KEK)** ✓
   - C. Stores the DEK in a secure Cloud SQL database
   - D. Applies an elliptic curve encryption algorithm to each DEK

9. What protocol does Google Cloud use at layer 7 of the OSI network stack for encryption?
   - A. IPSec
   - B. TLS
   - C. **ALTS** ✓
   - D. ARP

10. Your company will need to manage its own encryption keys but may store them in the cloud. What GCP service would you recommend?
    - A. Cloud Datastore
    - B. Cloud Firestore
    - C. **Cloud KMS** ✓
    - D. Bigtable

11. Finance application logs must be stored for five years; likely rarely accessed but available within three days if needed. How would you store that data?
    - A. Keep it in Cloud Logging.
    - B. **Export it to Cloud Storage and store it in Archive class storage.** ✓
    - C. Export it to BigQuery and partition it by year.
    - D. Export it to Cloud Pub/Sub using a different topic for each year.

12. The legal department says that if a developer can deploy to production, that developer cannot perform the final code review before deployment. This is an example of which security best practice?
    - A. Defense in depth
    - B. **Separation of duties** ✓
    - C. Least privilege
    - D. Encryption at rest

13. A startup offers an online game for children ages 10–14, collecting name, age, and address. Initially targeting U.S. customers. With which regulation would you advise them to comply?
    - A. HIPAA/HITECH
    - B. SOX
    - C. **COPPA** ✓
    - D. GDPR

14. Your company is expanding from North America to Germany and the Netherlands and offers online services that collect user data. What regulation must your company comply with?
    - A. HIPAA/HITECH
    - B. SOX
    - C. COPPA
    - D. **GDPR** ✓

15. Enterprise Self-Storage Systems acquired a startup software company. The company is concerned that the acquiring company's business strategy is not aligned with the software development practices of the acquired company's teams. What IT framework would you recommend?
    - A. **ITIL** ✓
    - B. TOGAF
    - C. Porter's Five Forces Model
    - D. Ansoff Matrix
