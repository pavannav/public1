# Chapter 3: Projects, Service Accounts, and Billing

> **Exam Objectives Covered:**
> - 1.1 Setting up cloud projects and accounts
> - 1.2 Managing billing configuration

---

This chapter covers how Google Cloud organizes resources using a resource hierarchy (organizations, folders, and projects), how service accounts enable applications to act on behalf of users, and how billing is managed.

---

## How Google Cloud Organizes Projects and Accounts

As cloud usage grows, organizations need a structured way to group and manage resources across multiple departments, teams, and administrators. Google Cloud provides the **resource hierarchy** to address this, with access controlled by **policies**.

### Google Cloud Resource Hierarchy

The resource hierarchy has three levels:

```
Organization
  └── Folder(s)
        └── Project(s)
              └── Resources (VMs, buckets, databases, etc.)
```

![You can create Cloud Identity accounts and manage Google Workspace users from the Identity & Organization console.](../images/c03f001.png)

**Figure 3.1** — Identity & Organization console for Cloud Identity and Google Workspace

---

#### Organization

- The **root** of the resource hierarchy.
- Typically corresponds to a **company or organization**.
- Created from a **Google Workspace domain** or a **Cloud Identity** account.
  - **Google Workspace** — Google's office productivity suite (Gmail, Docs, Drive, Calendar).
  - **Cloud Identity** — Google's Identity as a Service (IDaaS) offering for organizations that don't use Google Workspace.
- A single cloud identity is associated with **at most one organization**.

**Organization Administrator IAM Role responsibilities:**
- Define the structure of the resource hierarchy
- Define IAM policies over the resource hierarchy
- Delegate other management roles to users

**Automatic grants when an organization is created:**
- All users in the domain receive **Project Creator** and **Billing Account Creator** IAM roles.
- These allow any user to create projects and enable billing.

---

#### Folder

- **Building blocks of multilayer hierarchies** — optional but useful.
- An organization contains folders; folders can contain **other folders or projects**.
- Organized around the kinds of services and policies needed for contained projects.

![Generic organization folder project](../images/c03f002.png)

**Figure 3.2** — Generic organization → folder → project hierarchy

**Example hierarchy for a company with four departments:**

| Department | Folder Structure |
|---|---|
| Finance | Finance folder → Accounts Receivable subfolder + Accounts Payable subfolder |
| Software Development | Dev folder, Test folder, Staging folder, Production folder (separate policy per environment) |
| Marketing | Single Marketing folder (all resources shared across department) |
| Legal | Single Legal folder (all resources shared across department) |

![Example organization folder project](../images/c03f003.png)

**Figure 3.3** — Example organization folder project hierarchy

---

#### Project

- **Most important part** of the hierarchy — resources are created, services used, permissions managed, and billing configured at the **project level**.
- Anyone with the `resourcemanager.projects.create` IAM permission can create a project (granted to all users by default when an organization is created).
- Organizations have a **quota** on the number of projects they can create; increase requests require justification.

**Creating a project via Console:**
- Navigate to: **IAM & Admin → Manage Resources → Create Project**

![Navigation menu](../images/c03f006.png)

**Figure 3.6** — Navigation menu

![Managing resources](../images/c03f007.png)

**Figure 3.7** — Managing resources

![Click Create Project](../images/c03f008.png)

**Figure 3.8** — Click Create Project

![New Project dialog box](../images/c03f009.png)

**Figure 3.9** — New Project dialog box — enter project name and select organization

> The remaining project quota is shown when creating a project. Click **Manage Quotas** to request an increase.

---

### Organization Policies

The **Organization Policy Service** complements IAM by specifying **what can be done** with resources (vs. IAM which specifies **who can do** things).

| | IAM | Organization Policy Service |
|---|---|---|
| **Controls** | Who can perform operations | What can be done with resources |
| **Mechanism** | Permissions, Roles, Identities | Constraints on resources |

Policies are defined as **constraints** on resources and managed in the **IAM & Admin → Organization Policies** console.

![Organizational policies are managed in the IAM & Admin console.](../images/c03f004.png)

**Figure 3.4** — Organizational policies in the IAM & Admin console

#### Constraints on Resources

Two types of constraints:

**List Constraints** — lists of allowed or denied values for a resource:
- Allow a specific set of values
- Deny a specific set of values
- Deny a value and all its child values
- Allow all allowed values
- Deny all values

**Boolean Constraints** — evaluate to `true` or `false`:
- Example: `constraints/compute.disableSerialPortAccess = TRUE` → disables serial port access on all VMs in scope

Full list: `https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints`

#### Policy Evaluation

- Policies attached to a node in the hierarchy are **inherited by all child nodes** (folders and projects below it).
- Inherited policies **cannot be overridden** by default by objects lower in the hierarchy.
- To **disable inheritance** from a parent, set `inheritFromParent = false`.
- Multiple policies can be in effect simultaneously for a folder or project (all are applied cumulatively).

**Example:** InfoSec requires all VMs to disable serial port access → attach a boolean constraint at the organization level → all folders and projects inherit it automatically.

---

### Managing Projects

- Console URL: `https://console.cloud.google.com`
- Navigation: **IAM & Admin → Manage Resources → Create Project**

![Home page console](../images/c03f005.png)

**Figure 3.5** — Google Cloud Console home page

---

## Roles and Identities

### Roles in Google Cloud

- A **role** is a collection of permissions.
- **Identities** represent human users or service accounts (e.g., `alice@example.com`).
- Roles are assigned to identities (not permissions directly).

**Three types of roles:**

| Role Type | Description | Best Practice |
|---|---|---|
| **Basic (Primitive)** | Broad roles: Owner, Editor, Viewer. Apply across most resources. | Avoid when possible; too broad |
| **Predefined** | Granular, resource-specific roles managed and updated by Google | Preferred — follows least privilege |
| **Custom** | User-defined roles assembled from individual IAM permissions | Use when predefined roles don't fit |

> **Principle of Least Privilege** — assign only the permissions a user needs to perform their function, and nothing more. This is a fundamental information security best practice.

**Example predefined App Engine roles:**

| Role | Permissions |
|---|---|
| `appengine.appAdmin` | Read, write, and modify all App Engine application settings |
| `appengine.ServiceAdmin` | Read-only access to app settings; write access to module/version-level settings |
| `appengine.appViewer` | Read-only access to App Engine applications |

> **Note:** Some permissions cannot be used in custom roles, e.g., `iam.ServiceAccounts.getAccessToken`.

---

### Granting Roles to Identities

- Permissions are assigned **only to roles**, not directly to users.
- Roles are then **assigned (bound) to users** via the IAM console.

**Console path:** IAM & Admin → select project → Add user → assign role

![A sample list of roles in Google Cloud](../images/c03f010.png)

**Figure 3.10** — Sample list of roles in Google Cloud

![IAM permissions](../images/c03f011.png)

**Figure 3.11** — IAM permissions view

![Adding a user](../images/c03f012.png)

**Figure 3.12** — Adding a user and assigning a role

---

## Service Accounts

- **Service accounts** are identities not associated with a specific human user — they represent **applications or VMs** acting on behalf of a user or performing operations with specific permissions.
- Treated as both a **resource** (when users are given permission to access it) and an **identity** (when a role is assigned to it).

**Example use case:** An application needs database access but users should not have direct access. Create a service account with database permissions, assign it to the application — the app queries the database on behalf of users without granting users direct database access.

**Types of service accounts:**

| Type | Description |
|---|---|
| **User-managed** | Created and managed by users; up to **100 per project** |
| **Google-managed** | Automatically created by Google for specific services (e.g., Compute Engine SA, App Engine SA) |

**Automatic service account creation:**
- When **Compute Engine API** is enabled in a project → **Compute Engine service account** created automatically (granted Editor role on the project).
- When an **App Engine application** exists in a project → **App Engine service account** created automatically (granted Editor role on the project).

**Managing service accounts at different scopes:**

| Grant Level | Effect |
|---|---|
| `iam.serviceAccountUser` at **project level** | User can manage **all** service accounts in the project |
| `iam.serviceAccountUser` at **service account level** | User can manage **only that specific** service account |

**Authentication mechanism:** Service accounts authenticate using **encryption keys** (not username/password).

**Creating a service account via Console:**
- Navigate to: **IAM & Admin → Service Accounts → Create Service Account**

![Service accounts listing in the IAM & Admin console](../images/c03f013.png)

**Figure 3.13** — Service accounts listing in the IAM & Admin console

---

## Billing

Using resources such as VMs, object storage, and specialized services incurs charges. The **Google Cloud Billing API** manages how you pay for resources used.

### Billing Accounts

- **Billing accounts** store payment information for resources used.
- A billing account is associated with **one or more projects**.
- All projects must have a billing account unless they use **only free services**.

**Two types of billing accounts:**

| Type | Payment Method | Typical Users |
|---|---|---|
| **Self-serve** | Credit card or bank direct debit (charged automatically) | Individuals, small businesses |
| **Invoiced** | Bills/invoices sent to customer | Large enterprises |

**Billing roles:**

| Role | Permissions |
|---|---|
| **Billing Account Creator** | Can create new self-service billing accounts |
| **Billing Account Administrator** | Manages billing accounts but cannot create them |
| **Billing Account User** | Can link projects to billing accounts |
| **Billing Account Viewer** | Can view billing account costs and transactions (read-only) |

**Typical role assignments:**
- **Billing Account Creator** → financial staff only
- **Billing Account Administrator** → cloud admins
- **Billing Account User** → any user who can create projects
- **Billing Account Viewer** → auditors and finance reviewers

**Console path:** Main menu → Billing

![The main Billing form listing existing billing accounts](../images/c03f014.png)

**Figure 3.14** — Main Billing form listing existing billing accounts

![The form to create a new billing account](../images/c03f015.png)

**Figure 3.15** — Form to create a new billing account

---

### Billing Budgets and Alerts

- Navigate to: **Billing → Budgets & Alerts**
- A **budget** is associated with a **billing account** (not a project directly).
- Budget covers costs for **all projects** linked to that billing account.

**Budget configuration options:**
- Set a specific amount, or use the **previous month's spend** as the budget.
- Set multiple **alert thresholds** — default: **50%, 90%, and 100%**.
- Add additional thresholds using the **Add Item** button.

**Notification options when alert threshold is reached:**
- Email sent to **Billing Administrators** and **Billing Account Users**.
- Programmatic response: publish notifications to a **Pub/Sub topic**.

![The budget form enables you to have notices sent to you when certain percentages of your budget have been spent in a particular month.](../images/c03f016.png)

**Figure 3.16** — Budget and alert configuration form

---

### Exporting Billing Data

- Billing data can be exported for **analysis or compliance** purposes.
- Supported export destination: **BigQuery** (recommended).

**Export to BigQuery steps:**
1. Navigate to **Billing → Billing Export**.
2. Select the billing account to export.
3. Click **Edit Setting** → select projects → click **Go To BigQuery**.
4. A **Billing export dataset** is created in BigQuery to hold the exported data.

![Billing export form](../images/c03f017.png)

**Figure 3.17** — Billing export form

![Exporting to BigQuery](../images/c03f018.png)

**Figure 3.18** — Exporting billing data to BigQuery

> **Deprecated:** File export to Cloud Storage is **no longer supported**. The File Export option still appears in the UI but no longer functions.

![Exporting billing data to a file is now deprecated.](../images/c03f019.png)

**Figure 3.19** — File export deprecated

**Exam note:** When asked about available billing export file formats (for the now-deprecated file export), remember: **CSV** and **JSON**.

---

## Enabling APIs

- Google Cloud services are accessible programmatically via **APIs**.
- Most service APIs are **not enabled by default** in a project.
- Behind the scenes, all console operations (creating VMs, Cloud Storage buckets, etc.) call APIs.

**Enabling APIs:**
- Navigate to: **APIs & Services → Enable APIs And Services**
- Browse and enable the APIs you need.
- If you attempt an operation requiring a disabled API, you may be **prompted to enable it**.
- Enabled APIs show a **Disable** option; click an API name to view **usage details**.

![An example API services dashboard](../images/c03f020.png)

**Figure 3.20** — API services dashboard

![Example services for Big Data operations](../images/c03f021.png)

**Figure 3.21** — API library showing Big Data services

---

## Summary

| Topic | Key Points |
|---|---|
| **Resource Hierarchy** | Three levels: Organization → Folder(s) → Project(s). Policies are inherited downward. |
| **Organization Policy Service** | Complements IAM; defines *what can be done* with resources via constraints. |
| **IAM** | Defines *who can do* things; permissions assigned to roles, roles assigned to identities. |
| **Service Accounts** | Identities for applications/VMs; authenticate with encryption keys; up to 100 user-managed per project. |
| **Billing Accounts** | Associated with one or more projects; self-serve or invoiced; managed via Billing API. |
| **Budgets & Alerts** | Per billing account; configurable alert thresholds; email or Pub/Sub notifications. |
| **Billing Export** | Export to BigQuery for analysis and compliance. File export is deprecated. |
| **APIs** | Most service APIs are disabled by default; enable via APIs & Services console. |

---

## Exam Essentials

- **Google Cloud resource hierarchy:** Organization → Folders (optional, multilevel) → Projects → Resources. Policies defined at higher levels are inherited by all nodes below. Projects must have billing accounts to use paid services.

- **Organization policies:** Restrict what can be done with resources using **constraints** (list or boolean). Applied to the hierarchy and inherited downward. Inheritance can be disabled with `inheritFromParent = false`.

- **Service accounts:** Non-human identities assigned to resources (VMs, apps). Allow applications to perform operations without granting those permissions to end users. Authenticate using **encryption keys**. Can be managed at project level or individual account level.

- **Google Cloud Billing:** Billing account required for paid services. Self-serve (credit card/bank) or invoiced (enterprise). Budget alerts notify via email or Pub/Sub. Billing export to BigQuery for analysis. Key billing roles: Creator, Administrator, User, Viewer.

---

## Review Questions

1. Which resource hierarchy meets the healthcare provider's need to isolate government payer software from other systems while remaining flexible?
   - A. **One organization, with folders for records management and billing; billing folder has private insurer and government payer subfolders; common constraints at organization level; specific policies at folder level**
   - B. One folder for records management, one for billing, no organization
   - C. One organization with records management, private insurer, government payer directly under it; all folders share same policy constraints
   - D. None of the above

2. When creating a hierarchy, you can have more than one of which structure?
   - A. Organization only
   - B. Folder only
   - C. **Folder and project**
   - D. Project only

3. You need an application to write to a message queue without giving users that permission. Which would you use?
   - A. Billing account
   - B. **Service account**
   - C. Messaging account
   - D. Folder

4. How can you override a policy inherited from a parent entity in the resource hierarchy?
   - A. **Inherited policies can be overridden by defining a policy at a folder or project level**
   - B. Inherited policies cannot be overridden
   - C. Policies can be overridden by linking them to service accounts
   - D. Policies can be overridden by linking them to billing accounts

5. Which types of constraints are allowed in resource hierarchy policies?
   - A. Allow a specific set of values
   - B. Deny a specific set of values
   - C. Deny a value and all its child values
   - D. Allow all allowed values
   - E. **All of the above**

6. Which of the following is NOT included as a basic role in Google Cloud?
   - A. Owner
   - B. **Publisher**
   - C. Editor
   - D. Viewer

7. DevOps engineers need a subset of admin privileges for a new custom application. What type of role should you use?
   - A. Basic
   - B. Predefined
   - C. Advanced
   - D. **Custom**

8. When defining custom roles, which principle should you follow?
   - A. Rotation of duties
   - B. Least principle
   - C. Defense in depth
   - D. **Least privilege**

9. How many organizations can you create in a resource hierarchy?
   - A. **1**
   - B. 2
   - C. 3
   - D. Unlimited

10. Finance department wants to automate payments for Google Cloud services. What account should you recommend setting up?
    - A. Service account
    - B. **Billing account**
    - C. Resource account
    - D. Credit account

11. You cannot incur costs while experimenting with Google Cloud. How can you proceed?
    - A. You can't; all services incur charges
    - B. Use a personal credit card
    - C. **Use only free services in Google Cloud**
    - D. Use only serverless products, which are free

12. The CFO wants to be alerted about unusually high cloud bills before they get out of hand. Which mechanism addresses this?
    - A. Cloud Monitoring
    - B. Cloud Logging
    - C. **Budgeting and Alerting**
    - D. Policy Constraints

13. A large enterprise with independent subdivisions, each spending tens of thousands per month, needs billing accounts. What is the recommended setup?
    - A. Use a single self-service billing account
    - B. Use multiple self-service billing accounts
    - C. Use a single invoiced billing account
    - D. **Use multiple invoiced billing accounts**

14. An admin wants to delegate management of all service accounts in a project (including future ones) to another administrator. What is the best approach?
    - A. **Grant `iam.serviceAccountUser` to the administrator at the project level**
    - B. Grant `iam.serviceAccountUser` to the administrator at the service account level
    - C. Grant `iam.serviceProjectAccountUser` to the administrator at the project level
    - D. Grant `iam.serviceProjectAccountUser` to the administrator at the service account level

15. You propose using a service account for nightly file verification. Your manager asks about the authentication mechanism. What do service accounts use?
    - A. Username and password
    - B. Two-factor authentication
    - C. **Encryption keys**
    - D. Biometrics

16. What objects in Google Cloud are sometimes treated as resources and sometimes as identities?
    - A. Billing accounts
    - B. **Service accounts**
    - C. Projects
    - D. Roles

17. You plan to develop a web application using Google Cloud products that already include established roles for managing permissions (e.g., read-only or version deletion). Which role type offers this?
    - A. Basic roles
    - B. **Predefined roles**
    - C. Custom roles
    - D. Application roles

18. By default, who has privileges to create projects in a new Google Cloud account?
    - A. Only project administrators
    - B. **All users**
    - C. Only users without `resourcemanager.projects.create`
    - D. Only billing account users

19. How many projects can be created in an account?
    - A. 10
    - B. 25
    - C. There is no limit
    - D. **Each account has a limit determined by Google**

20. Which of the following is NOT a responsibility of the Organization Administrator role?
    - A. Defining the structure of the resource hierarchy
    - B. **Determining what permissions a user should be assigned**
    - C. Defining IAM policies over the resource hierarchy
    - D. Delegating other management roles to other users
