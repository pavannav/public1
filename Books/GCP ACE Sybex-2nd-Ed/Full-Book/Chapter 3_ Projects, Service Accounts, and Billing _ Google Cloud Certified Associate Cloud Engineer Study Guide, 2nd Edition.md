---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- ![](../images/tick_5.png) **1.1 Setting up cloud projects and accounts**
- ![](../images/tick_5.png) **1.2 Managing billing configuration**

---

Before delving into computing, storage, and networking services, we need to discuss how Google Cloud organizes resources and links the use of those resources to a billing system. This chapter introduces the Google Cloud organizational hierarchy, which consists of organizations, folders, and projects. It also discusses service accounts, which are ways of assigning roles to compute resources so they can carry out functions on your behalf. Finally, the chapter briefly discusses billing.

## How Google Cloud Organizes Projects and Accounts

When you use Google Cloud, you probably launch virtual machines or clusters, maybe create buckets to storage objects, and make use of serverless computing services such as Cloud Run and Cloud Functions. The list of resources you use can grow quickly and can also change in dynamic, unpredictable ways as autoscaling services respond to workload.

If you run a single application or a few services for your department, you might be able to track all resources by viewing lists of resources in use. As the scope of your Google Cloud use grows, you will probably have multiple departments, each with its own administrators who need different privileges. Google Cloud provides a way to group resources and manage them as a single unit. This is called the *resource hierarchy*. The access to resources in the resource hierarchy is controlled by a set of policies that you can define.

### Google Cloud Resource Hierarchy

The central abstraction for managing Google Cloud resources is the resource hierarchy. It consists of three levels:

- Organization
- Folder
- Project

Let's describe how these three components relate to each other.

#### Organization

An organization is the root of the resource hierarchy and typically corresponds to a company or organization. Google Workspace domains and Cloud Identity accounts map to Google Cloud organizations. Google Workspace is Google's office productivity suite, which includes Gmail, Docs, Drive, Calendar, and other services. If your company uses Google Workspace, you can create an organization in your Google Cloud hierarchy. If your company does not use Google Workspace, you can use Cloud Identity, Google's identity as a service (IDaaS) offering ([Figure 3.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0001)).

![Snapshot of you can create Cloud Identity accounts and manage Google Workspace users from the Identity & Organization console.](../images/c03f001.png)


[**FIGURE 3.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0001) You can create Cloud Identity accounts and manage Google Workspace users from the Identity & Organization console.

A single cloud identity is associated with at most one organization. Cloud identities have super admins, and those super admins assign the role of Organization Administrator Identity and Access Management (IAM) to users who manage the organization. In addition, Google Cloud will automatically grant Project Creator and Billing Account Creator IAM roles to all users in the domain. This allows any user to create projects and enable billing for the cost of resources used.

The users with the Organization Administrator IAM role are responsible for the following:

- Defining the structure of the resource hierarchy
- Defining identity and access management policies over the resource hierarchy
- Delegating other management roles to other users

When a member of a Google Workspace organization/Cloud Identity account creates a billing account or project, Google Cloud will automatically create an organization resource. All projects and billing accounts will be children of the organization resource. In addition, when the organization is created, all users in that organization are granted Project Creator and Billing Account Creator roles. From that point on, Google Workspace users will have access to Google Cloud resources.

#### Folder

Folders are the building blocks of multilayer organizational hierarchies. Organizations contain folders. Folders can contain other folders or projects. Folders, however, are optional and do not have to be used. A single folder may contain both folders and projects (see [Figure 3.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0002)). Folder organization is usually built around the kinds of services provided by resources in the contained projects and the policies governing folders and projects.

![Schematic illustration of generic organization folder project](../images/c03f002.png)


[**FIGURE 3.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0002) Generic organization folder project

Consider an example resource hierarchy. An organization has four departments: finance, marketing, software development, and legal. The finance department has to keep its accounts receivable and accounts payable resources separate, so the administrator creates two folders within the Finance folder: Accounts Receivable and Accounts Payable. Software development uses multiple environments, including Dev, Test, Staging, and Production. Access to each of the environments is controlled by policies specific to that environment, so it makes sense to organize each environment into its own folder. Marketing and legal can have all their resources shared across members of the department, so a single folder is sufficient for both of those departments. [Figure 3.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0003) shows the organization hierarchy for this organization.

Now that we have an organization defined and have set up folders that correspond to our departments and how different groups of resources will be accessed, we can create projects.

#### Project

Projects are in some ways the most important part of the hierarchy. It is in projects that we create resources, use Google Cloud services, manage permissions, and manage billing options.

![Schematic illustration of example organization folder project](../images/c03f003.png)


[**FIGURE 3.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0003) Example organization folder project

The first step in working with a project is to create one. Anyone with the `resourcemanager.projects.create` IAM permission can create a project. By default, when an organization is created, every user in the domain is granted that permission.

Your organization will have a quota of projects it can create. The quota can vary between organizations. Google makes decisions about project quotas based on typical use, the customer's usage history, and other factors. If you reach your limit of projects and try to create another, you will be prompted to request an increase in the quota. You'll have to provide information such as the number of additional projects you need and what they will be used for.

After you have created your resource hierarchy, you can define policies that govern it.

### Organization Policies

Google Cloud provides an Organization Policy Service. This service controls access to an organization's resources. The Organization Policy Service complements the IAM service.

IAM lets you assign permissions so that users or roles can perform specific operations in the cloud. The Organization Policy Service lets you specify limits on the ways resources can be used. One way to think of the difference is that IAM specifies who can do things, and the Organization Policy Service specifies what can be done with resources.

The organization policies are defined in terms of constraints on a resource.

#### Constraints on Resources

Constraints are restrictions on services. Google Cloud has list constraints and Boolean constraints.

List constraints are lists of values that are allowed or denied for a resource. The following are some types of list constraints:

- Allow a specific set of values.
- Deny a specific set of values.
- Deny a value and all its child values.
- Allow all allowed values.
- Deny all values.

Boolean constrains evaluate to true or false and determine whether or not the constraint is applied. For example, if you want to deny access to serial ports on VMs, you can set `constraints/compute.disableSerialPortAccess` to `TRUE`.

See organization policy constraints documentation at `https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints` for more details.

#### Policy Evaluation

Organizations may have standing policies to protect data and resources in the cloud. For example, there may be rules dictating who in the organization can enable a service API or create a service account. Your InfoSec department may require that all VMs disable serial port access. You could implement controls on each individual VM, but that is inefficient and prone to error. A better approach is to define a policy that constrains what can be done and attach that policy to an object in the resource hierarchy.

For example, since InfoSec wants all VMs to disable serial port access, you could specify a policy that constrains serial port access and then attach it to the organization. All folders and projects below the organization will inherit that policy. Since policies are inherited and cannot be disabled or overridden by objects lower in the hierarchy, this is an effective way to apply a policy across all organizational resources. There is, however, a way to disable inheriting from parents by setting the `inheritFromParent` parameter to `false`.

Policies are managed through the Organization Policies form in the IAM & Admin console. [Figure 3.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0004) shows an example set of policies.

Multiple policies can be in effect for a folder or project. For example, if the organization had a policy on serial port access and a folder containing a project had a policy limiting who can create service accounts, then the project would inherit both policies and both would constrain what could be done with resources in that project.

### Managing Projects

One of the first tasks you will perform when starting a new cloud initiative is to set up a project. This can be done with the Google Cloud Console. Assuming you have created an account with Google Cloud, navigate to the Google Cloud Console at `https://console.cloud.google.com` and log in. You will see the home page, which looks something like [Figure 3.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0005).

![Snapshot of organizational policies are managed in the IAM & Admin console.](../images/c03f004.png)


[**FIGURE 3.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0004) Organizational policies are managed in the IAM & Admin console.

![Snapshot of home page console](../images/c03f005.png)


[**FIGURE 3.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0005) Home page console

From the Navigation menu in the upper-left corner, select IAM & Admin and then select Manage Resources (see [Figure 3.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0006) and [Figure 3.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0007)).

![Snapshot of navigation menu](../images/c03f006.png)


[**FIGURE 3.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0006) Navigation menu

![Snapshot of managing resources](../images/c03f007.png)


[**FIGURE 3.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0007) Managing resources

From there, you can click Create Project, which displays the New Project dialog box. Here, you can enter the name of a project and select an organization ([Figure 3.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0008) and [Figure 3.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0009)).

![Snapshot of click Create Project.](../images/c03f008.png)


[**FIGURE 3.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0008) Click Create Project.

![Snapshot of new Project dialog box](../images/c03f009.png)


[**FIGURE 3.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0009) New Project dialog box

Note that when you create a project, your remaining quota of projects is displayed. If you need additional projects, click the Manage Quotas link to request an increase in your quota.

## Roles and Identities

In addition to managing resources, as a cloud engineer you will have to manage access to those resources. This is done with the use of roles and identities.

### Roles in Google Cloud

A *role* is a collection of permissions. Roles are granted to users by binding a user to a role. When we talk of identities, we mean the object we use to represent a human user or service account in Google Cloud. For example, Alice is a software engineer developing applications in the cloud (the human user), and she has an identity with the name `alice@example.com`. Roles are assigned to `alice@example.com` within Google Cloud so that Alice can create, modify, delete, and use resources in Google Cloud.

There are three types of roles in Google Cloud:

- Basic roles
- Predefined roles
- Custom roles

Basic roles, formerly known as primitive roles, include Owner, Editor, and Viewer. These provide broad privileges that can be applied to most resources. It is a best practice to use predefined roles instead of basic roles when possible. Basic roles grant wide ranges of permissions that may not always be needed by a user. By using predefined roles, you can grant only the permissions a user needs to perform their function. This practice of only assigning permissions that are needed and no more is known as the *principle of least privilege*. It is one of the fundamental best practices in information security.

Predefined roles provide granular access to resources in Google Cloud, and they are specific to Google Cloud products and managed and updated by Google. (See [Figure 3.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0010).) For example, App Engine roles include the following:

- `appengine.appAdmin`, which grants identities the ability to read, write, and modify all application settings in App Engine
- `appengine.ServiceAdmin`, which grants read-only access to application settings and write-level access to module-level and version-level settings in App Engine
- `appengine.appViewer`, which grants read-only access to applications in App Engine

Custom roles allow cloud administrators to create and administer their own roles. Custom roles are assembled using permissions defined in IAM. While you can use most permissions in a custom role, some, such as `iam.ServiceAccounts.getAccessToken`, are not available in custom roles.

### Granting Roles to Identities

Once you have determined which roles you want to provide to users, you can assign roles to users through the IAM console. It is important to know that permissions cannot be assigned to users—they can be assigned only to roles. Roles are then assigned to users.

From the IAM console, you can select a project that will display a permission interface, such as in [Figure 3.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0011).

From there, select the Add option to display another dialog box that prompts for usernames and roles (see [Figure 3.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0012)).

![Snapshot of a sample list of roles in Google Cloud](../images/c03f010.png)


[**FIGURE 3.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0010) A sample list of roles in Google Cloud

![Snapshot of iAM permissions](../images/c03f011.png)


[**FIGURE 3.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0011) IAM permissions

![Snapshot of adding a user](../images/c03f012.png)


[**FIGURE 3.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0012) Adding a user

## Service Accounts

Identities are usually associated with individual users. Sometimes it is helpful to have applications or VMs act on behalf of a user or perform operations that the user does not have permission to perform.

For example, you may have an application that needs to access a database but you do not want to allow users of the application to access the database directly. Instead, all user requests to the database should go through the application. You can create a service account that has access to the database. You can then assign that service account to the application so that the application can execute queries on behalf of users without having to grant database access to those users.

Service accounts are somewhat unusual in that we sometimes treat them as resources and sometime as identities. When we assign a role to a service account, we are treating it as an identity. When we give users permission to access a service account, we are treating it as a resource.

There are two types of service accounts: user-managed service accounts and Google-managed service accounts. Users can create up to 100 service accounts per project. When you create a project that has the Compute Engine API enabled, a Compute Engine service account is created automatically. Similarly, if you have an App Engine application in your project, Google Cloud will automatically create an App Engine service account. Both the Compute Engine and App Engine service accounts are granted editor roles on the projects in which they are created. You can also create custom service accounts in your projects.

Google may also create service accounts that it manages. These accounts are used with various Google Cloud services.

Service accounts can be managed as a group of accounts at the project level or at the individual service account level. For example, if you grant `iam.serviceAccountUser` to a user for a specific project, then that user can manage all service accounts in the project. If you prefer to limit users to manage only specific service accounts, you could grant `iam.serviceAccountUser` for a specific service account.

Service accounts are created automatically when resources are created. For example, a service account will be created for a VM when the VM is created. There may be situations in which you would like to create a service account for one of your applications. In that case, you can navigate to the IAM & Admin console and select Service Accounts. From there you can click Create Service Account at the top, as shown in [Figure 3.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0013).

![Snapshot of service accounts listing in the IAM & Admin console](../images/c03f013.png)


[**FIGURE 3.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0013) Service accounts’ listing in the IAM & Admin console

This brings up a form that prompts for the information needed to create a service account.

## Billing

Using resources such as VMs, object storage, and specialized services usually incurs charges. The Google Cloud Billing API provides a way for you to manage how you pay for resources used.

### Billing Accounts

Billing accounts store information about how to pay charges for resources used. A billing account is associated with one or more projects. All projects must have a billing account unless they use only free services.

Billing accounts can follow a similar structure to the resource hierarchy. If you are working with a small company, you may have only a single billing account. In that case, all resource costs are charged to that one account. If your company is similar to the example from earlier in the chapter, with finance, marketing, legal, and software development departments, then you may want to have multiple billing accounts. You could have one billing account for each department, but that may not be necessary. If finance, marketing, and legal all pay for their cloud services from the same part of your company's budget, then they could use a single billing account. If software development services are paid from a different part of your company's budget, then it could use a different billing account.

From the main Google Cloud Console, you can navigate to the Billing console (see [Figure 3.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0014)), which lists existing billing accounts.

![Snapshot of the main Billing form listing existing billing accounts](../images/c03f014.png)


[**FIGURE 3.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0014) The main Billing form listing existing billing accounts

From here, you can create a new billing account, as shown in [Figure 3.15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0015).

From the Billing overview page, you can view and modify projects linked to billing accounts.

There are two types of billing accounts: self-serve and invoiced. Self-serve accounts are paid by credit card or direct debit from a bank account. The costs are charged automatically. The other type is an invoiced billing account, in which bills or invoices are sent to customers. This type of account is commonly used by enterprises and other large customers.

![Snapshot of the form to create a new billing account](../images/c03f015.png)


[**FIGURE 3.15**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0015) The form to create a new billing account

Several roles are associated with billing. It is important to know them for the exam. The billing roles are as follows:

- Billing Account Creator, which can create new self-service billing accounts
- Billing Account Administrator, which manages billing accounts but cannot create them
- Billing Account User, which enables a user to link projects to billing accounts
- Billing Account Viewer, which enables a user to view billing account cost and transactions

Few users will likely have Billing Account Creator, and those who do will likely have a financial role in the organization. Cloud admins may have Billing Account Administrator to manage the accounts. Any user who can create a project should have Billing Account User so that new projects can be linked to the appropriate billing account. Billing Account Viewer is useful for some, like an auditor who needs to be able to read billing account information but not change it.

### Billing Budgets and Alerts

The Google Cloud Billing service includes an option for defining a budget and setting billing alerts. You can navigate to the budget form from the main console menu, select Billing, and then select Budgets & Alerts (see [Figure 3.16](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0016)).

![Snapshot of the budget form enables you to have notices sent to you when certain percentages of your budget have been spent in a particular month.](../images/c03f016.png)


[**FIGURE 3.16**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0016) The budget form enables you to have notices sent to you when certain percentages of your budget have been spent in a particular month.

In the budget form, you can name your budget and specify a billing account to monitor. Note that a budget is associated with a billing account, not a project. One or more projects can be linked to a billing account, so the budget and alerts you specify should be based on what you expect to spend for all projects linked to the billing account.

You can specify a particular amount or specify that your budget is the amount spent in the previous month.

With a budget, you can set multiple alert percentages. By default, three percentages are set: 50 percent, 90 percent, and 100 percent. You can change those to percentages that work best for you. If you'd like more than three alerts, you can click Add Item in the Set Budget Alerts section to add additional alert thresholds.

When that percentage of a budget has been spent, it will notify billing administrators and billing account users by email. If you would like to respond to alerts programmatically, you can have notifications sent to a Pub/Sub topic by checking the appropriate box in the Manage Notification sections.

### Exporting Billing Data

You can export billing data for later analysis or for compliance reasons. Billing data can be exported to BigQuery.

To export billing data to BigQuery, navigate to the Billing section of the console and select Billing Export from the menu. In the form that appears, select the billing account you would like to export (see [Figure 3.17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0017)).

![Snapshot of billing export form](../images/c03f017.png)


[**FIGURE 3.17**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0017) Billing export form

For BigQuery, click Edit Setting. Select the projects you want to include. You will need to create a BigQuery data set to hold the data. Click Go To BigQuery to open a BigQuery form. This will create a Billing export data set, which will be used to hold exported data. (See [Figure 3.18](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0018).) For additional information on using BigQuery, see [Chapter 12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c12.xhtml), “Deploying Storage in Google Cloud.”

![Snapshot of exporting to BigQuery](../images/c03f018.png)


[**FIGURE 3.18**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0018) Exporting to BigQuery

Alternatively, in the past you could export billing data to a file stored in Cloud Storage but that is no longer supported. A File Export option is available, but it no longer functions, as shown in [Figure 3.19](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0019). By the time you read this, the File Export option may have been removed.

![Snapshot of exporting billing data to a file is now deprecated.](../images/c03f019.png)


[**FIGURE 3.19**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0019) Exporting billing data to a file is now deprecated.

When exporting to a file, you will need to specify a bucket name and a report prefix. You have the option of choosing either the CSV or JSON file format. There may be questions on the exam about available file format options, so remember these two options.

## Enabling APIs

Google Cloud uses APIs to make services programmatically accessible. For example, when you use a form to create a VM or a Cloud Storage bucket, behind the scenes, API functions are executed to create the VM or bucket. All Google Cloud services have APIs associated with them. Most, however, are not enabled by default in a project.

To enable service APIs, you can select APIs & Services from the main console menu. This will display a dashboard, as shown in [Figure 3.20](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0020).

![Snapshot of an example API services dashboard](../images/c03f020.png)


[**FIGURE 3.20**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0020) An example API services dashboard

If you click the Enable APIs And Services link, you will see a list of services that you can enable, as shown in [Figure 3.21](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#c03-fig-0021).

![Snapshot of example services for Big Data operations](../images/c03f021.png)


[**FIGURE 3.21**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c03.xhtml#R_c03-fig-0021) Example services for Big Data operations

This form is a convenient way to enable APIs you know you will need. If you attempt an operation that requires an API that is not enabled, you may be prompted to decide if you want to enable the API.

Enabled APIs will have a Disable option. You can click that to disable the API. You can also click the name of an API in the list to drill down into details about API usage.

## Summary

The central abstraction for managing Google Cloud resources is the resource hierarchy. It consists of three levels: organization, folder, and project. The Organization Policy Service and IAM together control access to an organization's resources. Billing accounts store information about how to pay charges for resources used. A billing account is associated with one or more projects. Google Cloud uses APIs to make services programmatically accessible and most are not enabled by default.

## Exam Essentials

- **Understand the Google Cloud resource hierarchy.**   All resources are organized within your resource hierarchy. You can define the resource hierarchy using one organization and multiple folders and projects. Folders are useful for grouping departments, and other groups manage their projects separately. Projects contain resources such as VMs and cloud storage buckets. Projects must have billing accounts associated with them to use services that aren't free.
- **Understand organization policies.**   Organization policies restrict resources in the resource hierarchy. Policies include constraints, which are rules that define what can or cannot be done with a resource. For example, a constraint can be set to block access to the serial port on all VMs in a project. Also, understand the policy evaluation process and how to override inherited policies.
- **Understand service accounts and how they are used.**   Service accounts are identities that are not associated with a specific user but can be assigned to a resource, like a VM. Resources that are assigned a service account can perform operations that the service account has permission to perform. Understand service accounts and how to create them.
- **Understand Google Cloud Billing.**   Billing must be enabled to use services and resources beyond free services. Billing associates a billing method, such as a credit card or invoicing information, with a project. All costs associated with resources in a project are billed to the project's billing account. A billing account can be associated with more than one project. You manage your billing through the Billing API.

## Review Questions

You can find the answers in the Appendix.

1. You are designing cloud applications for a healthcare provider. The records management application will manage medical information for patients. Access to this data is limited to a small number of employees. The billing department application will have insurance and payment information. Another group of employees will have access to billing information. In addition, the billing system will have two components: a private insurance billing system and a government payer billing system. Government regulations require that software used to bill the government must be isolated from other software systems. Which of the following resource hierarchies would meet these requirements and provide the most flexibility to adapt to changing requirements?
   1. One organization, with folders for records management and billing. The billing folder would have private insurer and government payer folders within it. Common constraints would be specified in organization-level policies. Other policies would be defined at the appropriate folder.
   2. One folder for records management, one for billing, and no organization. Policies defined at the folder level.
   3. One organization, with folders for records management, private insurer, and government payer below the organization. All constraints would be specified in organization-level policies. All folders would have the same policy constraints.
   4. None of the above.
2. When you create a hierarchy, you can have more than one of which structure?
   1. Organization only
   2. Folder only
   3. Folder and project
   4. Project only
3. You are designing an application that uses a series of services to transform data from its original form into a format suitable for use in a data warehouse. Your transformation application will write to the message queue as it processes each input file. You don't want to give users permission to write to the message queue. You could allow the application to write to the message queue by using which of the following?
   1. Billing account
   2. Service account
   3. Messaging account
   4. Folder
4. Your company has several policies that need to be enforced for all projects. You decide to apply policies to the resource hierarchy. Not long after you apply the policies, an engineer finds that an application that had worked prior to implementing policies is no longer working. The engineer would like you to create an exception for the application. How can you override a policy inherited from another entity in the resource hierarchy?
   1. Inherited policies can be overridden by defining a policy at a folder or project level.
   2. Inherited policies cannot be overridden.
   3. Policies can be overridden by linking them to service accounts.
   4. Policies can be overridden by linking them to billing accounts.
5. Constraints are used in resource hierarchy policies. Which of the following are types of constraints allowed?
   1. Allow a specific set of values.
   2. Deny a specific set of values.
   3. Deny a value and all its child values.
   4. Allow all allowed values.
   5. All of the above.
6. A team with four members wants you to set up a project that needs only general permissions for all resources. You are granting each person a basic role for different levels of access, depending on their responsibilities in the project. Which of the following are not included as basic roles in Google Cloud?
   1. Owner
   2. Publisher
   3. Editor
   4. Viewer
7. You are deploying a new custom application and want to delegate some administration tasks to DevOps engineers. They do not need all the privileges of a full application administrator, but they do need a subset of those privileges. What kind of role should you use to grant those privileges?
   1. Basic
   2. Predefined
   3. Advanced
   4. Custom
8. An app for a finance company needs access to a database and a Cloud Storage bucket. There is no predefined role that grants all the needed permissions without granting some permissions that are not needed. You decide to create a custom role. When defining custom roles, you should follow which of the following principles?
   1. Rotation of duties
   2. Least principle
   3. Defense in depth
   4. Least privilege
9. How many organizations can you create in a resource hierarchy?
   1. 1
   2. 2
   3. 3
   4. Unlimited
10. You are contacted by the finance department of your company for advice on how to automate payments for Google Cloud services. What kind of account would you recommend setting up?
    1. Service account
    2. Billing account
    3. Resource account
    4. Credit account
11. You are experimenting with Google Cloud for your company. You do not have permission to incur costs. How can you experiment with Google Cloud without incurring charges?
    1. You can't; all services incur charges.
    2. You can use a personal credit card to pay for charges.
    3. You can use only free services in Google Cloud.
    4. You can use only serverless products, which are free to use.
12. The CFO of your company is concerned that they will learn of unusually high cloud computing bills only after charges have been incurred. What mechanism in Google Cloud could be used to address the CFO's concern?
    1. Cloud Monitoring
    2. Cloud Logging
    3. Budgeting and Alerting
    4. Policy Constraints
13. A large enterprise is planning to use Google Cloud across several subdivisions. Each subdivision is managed independently and has its own budget. Most subdivisions plan to spend tens of thousands of dollars per month. How would you recommend they set up their billing account(s)?
    1. Use a single self-service billing account.
    2. Use multiple self-service billing accounts.
    3. Use a single invoiced billing account.
    4. Use multiple invoiced billing accounts.
14. An application administrator is responsible for managing all resources in a project. They want to delegate responsibility for several service accounts to another administrator. If additional service accounts are created, the other administrator should manage those as well. What is the best way to delegate privileges needed to manage the service accounts?
    1. Grant `iam.serviceAccountUser` to the administrator at the project level.
    2. Grant `iam.serviceAccountUser` to the administrator at the service account level.
    3. Grant `iam.serviceProjectAccountUser` to the administrator at the project level.
    4. Grant `iam.serviceProjectAccountUser` to the administrator at the service account level.
15. You work for a retailer with a large number of stores. Every night the stores upload daily sales data. You have been tasked with creating a service that verifies the uploads every night. You decide to use a service account. Your manager questions the security of your proposed solution, particularly about authenticating the service account. You explain the authentication mechanism used by service accounts. What authentication mechanism is used?
    1. Username and password
    2. Two-factor authentication
    3. Encryption keys
    4. Biometrics
16. What objects in Google Cloud are sometimes treated as resources and sometimes as identities?
    1. Billing accounts
    2. Service accounts
    3. Projects
    4. Roles
17. You plan to develop a web application using products from the Google Cloud that already include established roles for managing permissions such as read-only access or the ability to delete old versions. Which of the following roles offers these capabilities?
    1. Basic roles
    2. Predefined roles
    3. Custom roles
    4. Application roles
18. You are reviewing a new Google Cloud account created for use by the finance department. An auditor has questions about who can create projects by default. You explain who has privileges to create projects by default. Who is included?
    1. Only project administrators
    2. All users
    3. Only users without the role `resourcemanager.projects.create`
    4. Only billing account users
19. How many projects can be created in an account?
    1. 10.
    2. 25.
    3. There is no limit.
    4. Each account has a limit determined by Google.
20. You are planning how to grant privileges to users of your company's Google Cloud account. You need to document what each user will be able to do. Auditors are most concerned about a role called Organization Administrator. You explain that users with that role can perform a number of tasks, which include all of the following except which one?
    1. Defining the structure of the resource hierarchy
    2. Determining what permissions a user should be assigned
    3. Defining IAM policies over the resource hierarchy
    4. Delegating other management roles to other users