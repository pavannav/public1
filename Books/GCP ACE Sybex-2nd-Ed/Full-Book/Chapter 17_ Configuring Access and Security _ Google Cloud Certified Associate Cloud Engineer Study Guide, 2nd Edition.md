---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **5.1 Managing Identity and Access Management (IAM)**
- **5.2 Managing service accounts**
- **5.3 Viewing audit logs**

---

Google Cloud engineers can expect to spend a significant amount of time working with access controls. This chapter provides instruction on how to perform several common tasks, including managing identity and access management (IAM) assignments, creating custom roles, managing service accounts, and viewing audit logs.

It is important to know that the preferred way of assigning permissions to users, groups, and service accounts is through the IAM system. However, Google Cloud did not always have IAM. Before that, permissions were granted using what are now known as basic roles, which are fairly coarse-grained. Basic roles, may have more permissions than you want an identity to have. You can constrain permissions using scopes. In this chapter, we will describe how to use basic roles and scopes as well as IAM. Going forward, it is a best practice to use IAM for access control.

## Managing Identity and Access Management

When you work with IAM, there are a few common tasks you need to perform:

- Viewing account IAM assignments
- Assigning IAM roles
- Defining custom roles

Let's look at how to perform each of these tasks.

### Viewing Account IAM Assignments

You can view account IAM assignments in Cloud Console by navigating to the IAM & Admin section. In that section, select IAM from the navigation menu to display the page shown in [Figure 17.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0001). The example in the figure shows a list of identities filtered by member name.

In this example, the user `dan@sullivanlearninggroup.com` has three roles: Compute Organization Resource Admin, Organization Administrator, and Owner. App Engine Admin and BigQuery Admin are predefined IAM roles. Owner is a basic role.

![Snapshot of permissions listing filtered by member](../images/c17f001.png)


[**FIGURE 17.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0001) Permissions listing filtered by member

Basic roles were used prior to IAM. There are three basic roles: Owner, Editor, and Viewer. Viewers have permission to perform read-only operations. Editors have viewer permissions and permission to modify an entity. Owners have editor permissions and can manage roles and permission on an entity. Owners can also set up billing for a project.

IAM roles are collections of permissions. They are tailored to provide identities with just the permissions they need to perform a task and no more. To see a list of users assigned a role (see [Figure 17.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0002)), click the Roles tab on the IAM page.

![Snapshot of list of identities assigned to Cloud Build Service Account and Cloud Data Fusion Runner roles](../images/c17f002.png)


[**FIGURE 17.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0002) List of identities assigned to Cloud Build Service Account and Cloud Data Fusion Runner roles

This page shows a list of roles with the number of identities assigned to that role in parentheses. Click the arrow next to the name of a role to display a list of identities with that role.

You can also see a list of users and roles assigned across a project by using the command `gcloud projects get-iam-policy`. For example, to list roles assigned to users in a project with the project ID `ace-exam-project`, use this:

```
gcloud projects get-iam-policy ace-exam-project
```

Predefined roles are grouped by service. For example, App Engine has five roles:

- App Engine Admin, which grants read, write, and modify permission to application and configuration settings. The role name used in `gcloud` commands is `roles/appengine.appAdmin`.
- App Engine Service Admin, which grants read-only access to configuration settings and write access to module-level and version-level settings. The role name used in `gcloud` commands is `roles/appengine.serviceAdmin`.
- App Engine Deployer, which grants read-only access to application configuration and settings and write access to create new versions. Users with only the App Engine Deployer role cannot modify or delete existing versions. The role name used in `gcloud` commands is `roles/appengine.deployer`.
- App Engine Viewer, which grants read-only access to application configuration and settings. The role name used in `gcloud` commands is `roles/appengine.appViewer`.
- App Engine Code Viewer, which grants read-only access to all application configurations, settings, and deployed source code. The role name used in `gcloud` commands is `roles/appengine.codeViewer`.

---

![](../images/note_13.png) Although you do not have to know all of them, it helps to review predefined roles to understand patterns of how they are defined. For more details, see the Google Cloud documentation at `https://cloud.google.com/iam/docs/understanding-roles`.

---

### Assigning IAM Roles to Accounts and Groups

To add IAM roles to accounts and groups, navigate to the IAM & Admin section of the console. Select IAM from the menu. Click the Add link at the top to display a page like that shown in [Figure 17.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0003).

Specify the name of a user or group in the field labeled New Principals. Click Select A Role to add a role. You can add multiple roles. When you click the down arrow in the Select A Role field, you will see a list of services and their associated roles. You can choose the roles from that list. See [Figure 17.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0004) for an example of a subset of the list, showing the roles for BigQuery.

![Snapshot of the Add option in IAM opens this page, where you can assign one or more roles to users or groups.](../images/c17f003.png)


[**FIGURE 17.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0003) The Add option in IAM opens this page, where you can assign one or more roles to users or groups.

![Snapshot of the drop-down list in the Select A Role field shows available roles grouped by service.](../images/c17f004.png)


[**FIGURE 17.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0004) The drop-down list in the Select A Role field shows available roles grouped by service.

If you want to know which of the fine-grained permissions are granted when you assign a role, you can list those permissions at the command line or in the console. You can also see what permissions are assigned to a role by using the command `gcloud iam roles describe`. For example, [Figure 17.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0005) shows the list of permissions in the Spanner Database Admin role.

![Snapshot of a partial listing of permissions using the gcloud iam roles describe command](../images/c17f005.png)


[**FIGURE 17.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0005) A partial listing of permissions using the `gcloud iam roles describe` command

You can also use Cloud Console to view permissions. Navigate to the IAM & Admin section and select Roles from the menu. This displays a list of roles. Click the check box next to a role name to display a list of permissions on the right, as shown in [Figure 17.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0006) for Cloud SQL Admin.

You can assign roles to a member in a project using the following command:

```
gcloud projects add-iam-policy-binding [RESOURCE-NAME] \
--member= user:[USER-EMAIL] --role= [ROLE-ID]
```

For example, to grant the Editor basic role to a user identified by `jane@acexam.com`, you could use this:

```
gcloud projects add-iam-policy-binding ace-exam-project \
-member=user:jane@aceexam.com  --role='roles/editor'
```

![Snapshot of using Cloud Console to view a partial listing of permissions available for Cloud SQL Admin](../images/c17f006.png)


[**FIGURE 17.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0006) Using Cloud Console to view a partial listing of permissions available for Cloud SQL Admin


---

### Real World Scenario

### IAM Roles Support Least Privilege and Separation of Duties

Two security best practices are assigning least privileges and maintaining a separation of duties. The principle of least privileges says you grant only the smallest set of permissions that is required for a user or service account to perform their required tasks. For example, if users can do everything they need to do with only read permission to a database, then they should not have write permission.

In the case of separation of duties, the idea is that a single user should not be able to perform multiple sensitive operations that together could present a risk. In high-risk domains, such as finance or defense, you would not want a developer to be able to modify an application and deploy that change to production without review. A malicious engineer, for example, could modify code in a finance application to suppress application logging when funds are transferred to a bank account controlled by the malicious engineer. If that engineer were to put that code in production, it could be some time before auditors discover that logging has been suppressed and there may have been fraudulent transactions.

IAM roles support least privilege by assigning minimal permissions to predefined roles. It also supports separation of duties by allowing some users to have the ability to change code and others to deploy code.

---

Another common security practice is defense in depth, which applies multiple, overlapping security controls. That is also a practice that should be adopted. IAM can be applied as one of the layers of defense.

### Defining Custom IAM Roles

If the set of predefined IAM roles does not meet your needs, you can define a custom role.

To define a custom role in Cloud Console, navigate to the Roles option in the IAM & Admin section of the console. Click the Create Role link at the top of the page. This will display a page like that shown in [Figure 17.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0007).

On this page you can specify a name for the custom role, a description, an identifier, a launch stage, and a set of permissions. The launch stage options are as follows: Alpha, Beta, General Availability, and Disabled.

You can click Add Permissions to display a list of permissions. The list in [Figure 17.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0008) is filtered to include only permissions in the Cloud SQL Admin role.

![Snapshot of creating a role in Cloud Console](../images/c17f007.png)


[**FIGURE 17.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0007) Creating a role in Cloud Console

Although the list includes all permissions in the role, not all permissions are available for use in a custom role. When a permission is not available, its status is listed as Not Supported. Permissions that are available for use are listed as Supported, so in the example all other permissions are available. Check the boxes next to the permissions you want to include in your custom role. Click Add to return to the Create Role page, where the list of permissions will now include the permissions you selected (see [Figure 17.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0009)).

![Snapshot of list of available permissions filtered by role](../images/c17f008.png)


[**FIGURE 17.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0008) List of available permissions filtered by role

You can also define a custom role using the `gcloud iam roles create` command. The structure of that command is as follows:

```
gcloud iam roles create [ROLE-ID] --project [PROJECT-ID] \ --title=[ROLE-TITLE] --description= [ROLE -DESCRIPTION] \--permissions= [PERMISIONS-LIST] --stage=[LAUNCH-STAGE]
```

For example, to create a role that has only App Engine application update permission, you could use the following command:

```
gcloud iam roles create customAppEngine1 --project ace-exam-project \--title='Custom Update App Engine' \
--description='Custom update' --permissions=appengine.applications.update \--stage=alpha
```

![Snapshot of the permissions section of the Create Role page with permissions added](../images/c17f009.png)


[**FIGURE 17.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0009) The permissions section of the Create Role page with permissions added

## Managing Service Accounts

Service accounts are used to provide identities independent of human users. Service accounts are identities that can be granted roles. Service accounts are assigned to VMs, which then use the permissions available to the service accounts to carry out tasks.

Three things cloud engineers are expected to know how to do are working with scopes, assigning service accounts to VMs, and granting access to a service account to another project.

### Managing Service Accounts with Scopes

Scopes are permissions granted to a VM to perform some operation. Scopes authorize the access to API methods. The service account assigned to a VM has roles associated with it. To configure access controls for a VM, you will need to configure both IAM roles and scopes. We have discussed how to manage IAM roles, so now we will turn our attention to scopes.

A scope is specified using a URL that starts with `www.googleapis.com/auth` and is then followed by permission on a resource. For example, the scope allowing a VM to insert data into BigQuery is as follows:

`www.googleapis.com/auth/bigquery.insertdata`

The scope that allows viewing data in Cloud Storage is as follows:

`www.googleapis.com/auth/devstorage.read_only`

And to write to Compute Engine logs, use this:

`www.googleapis.com/auth/logging.write`

An instance can only perform operations allowed by both IAM roles assigned to the service account and scopes defined on the instance. For example, if a role grants only read-only access to Cloud Storage but a scope allows write access, then the instance will not be able to write to Cloud Storage.

To set scopes in an instance, navigate to the VM instance page in Cloud Console. Stop the instance if it is running. On the Instance Detail page, click the Edit link. In the middle of the Edit page, you will see the Access Scopes section, as shown in [Figure 17.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0010).

The options are Allow Default Access, Allow Full Access To All Cloud APIs, and Set Access For Each API. Default access is usually sufficient. If you are not sure what to set, you can choose Allow Full Access, but be sure to assign IAM roles to limit what the instance can do. If you want to choose scopes individually, choose Set Access For Each API. This will display a list of services and scopes like that shown in [Figure 17.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0011).

![Snapshot of access Scopes section in VM instance detail edit page](../images/c17f010.png)


[**FIGURE 17.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0010) Access Scopes section in VM instance detail edit page

![Snapshot of a partial list of services and scopes that can be individually configured](../images/c17f011.png)


[**FIGURE 17.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0011) A partial list of services and scopes that can be individually configured

You can also set scopes using the `gcloud compute instances set-service-account` command. The structure of the command is as follows:

```
gcloud compute instances set-service-account [INSTANCE_NAME] \
     [--service-account [SERVICE_ACCOUNT_EMAIL] | [--no-service-account] \
     [--no-scopes | --scopes [SCOPES,…]]
```

An example scope assignment using `gcloud` is as follows:

```
gcloud compute instances set-service-account ace-instance \
     --service-account examadmin@ace-exam-project.iam.gserviceaccount.com \
     --scopes compute-rw,storage-ro
```

### Assigning a Service Account to a VM Instance

You can assign a service account to a VM instance. First, create a service account by navigating to the Service Accounts section of the IAM & Admin section of the console. Click Create Service Account to display a page like that shown in [Figure 17.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0012).

![Snapshot of creating a service account in the console](../images/c17f012.png)


[**FIGURE 17.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0012) Creating a service account in the console

After specifying a name, identifier, and description, click Create and continue. Next, you can assign roles as described earlier, using the console or `gcloud` commands. Once you have assigned the roles you want the service account to have, you can assign it to a VM instance.

Navigate to the VM Instances page in the Compute Engine section of the console. Select a VM instance and click Edit. This will display a page with a parameter for the instance. Scroll down to see the parameter labeled Service Account (see [Figure 17.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0013)).

![Snapshot of section of Edit Instance page showing the Service Account parameter](../images/c17f013.png)


[**FIGURE 17.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0013) Section of Edit Instance page showing the Service Account parameter

From the drop-down list, select the service account you want assigned to that instance, as shown in [Figure 17.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0014).

![Snapshot of list of service accounts that can be assigned to the instance](../images/c17f014.png)


[**FIGURE 17.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0014) List of service accounts that can be assigned to the instance

You can also specify a service instance at the command line when you create an instance by using the `gcloud compute instances create` command. It has the following structure:

```
gcloud compute instances create [INSTANCE_NAME] \ --service-account [SERVICE_ACCOUNT_EMAIL]
```

To grant access to a project, navigate to the IAM page of the console and add a member. Use the service accounts email as the entity to add.

### Viewing Audit Logs

To view audit logs, navigate to the Cloud Logging page in Cloud Console. This will show a listing like that in [Figure 17.15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#c17-fig-0015).

![Snapshot of default listing of the Cloud Logging page](../images/c17f015.png)


[**FIGURE 17.15**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml#R_c17-fig-0015) Default listing of the Cloud Logging page

Notice you can select the resource, types of logs to display, the log level, and the period of time from which to display entities. Using the Log Name, search for **activity** to see Activity audit logs, **data\_access** to see Data Access audit logs, **system\_event** to see System Event audit logs, and **policy** to see Policy Denied audit logs.

For additional information on logging, see [Chapter 18](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml), “Monitoring, Logging, and Cost Estimating.”

## Summary

Access controls in Google Cloud are managed using IAM, basic roles, and scopes. The three basic roles are Owner, Editor, and Viewer. They provide coarse-grained access controls to resources. Scopes are access controls that apply to instances of VMs. They are used to limit operations that can be performed by an instance. The set of operations that an instance can perform is determined by the scopes assigned and the roles assigned to a service account used by the instance. IAM provides predefined roles. These roles are grouped by service. The roles are designed to provide the minimal set of permissions needed to carry out a logical task, such as writing to a bucket or deploying an App Engine application. When predefined roles do not meet your needs, you can define custom roles.

Service accounts are used to enable VMs to perform operations with a set of permissions. The permissions are granted to service accounts through the roles assigned to the service account. You can use the default service account provided by Google Cloud for an instance or you can assign your own.

## Exam Essentials

- **Know the three types of roles: basic, predefined, and custom.**   Basic roles include Owner, Editor, and Viewer. These were developed prior to the release of IAM. Predefined roles are IAM roles. Permissions are assigned to these roles, and then the roles are assigned to users, groups, and service accounts. Custom roles include permissions selected by the user creating the custom role.
- **Understand that scopes are a type of access control applied to VM instances.**   The VM can only perform operations allowed by scopes and IAM roles assigned to the service account of the instance. You can use IAM roles to constrain scopes and use scopes to constrain IAM roles.
- **Know how to view roles assigned to identities.**   You can use the Roles tab in the IAM & Admin section of the console to list the identities assigned particular roles. You can also use the `gcloud projects get-iam-policy` command to list roles assigned to users in a project.
- **Understand that IAM roles support separation of duties and the principle of least privilege.**   Basic roles did not support least privilege and separation of duties because they are too coarse-grained. Separation of duties ensures that two or more people are required to complete a sensitive task.
- **Know how to use `gcloud iam roles describe` to view details of a role, including permissions assigned to a role.**   You can also view roles users have been granted by drilling down into a role in the Roles page of the IAM & Admin section of the console. When working with IAM, you will be using the `gcloud` command when working from the command line.
- **Understand the different options for accessing scopes when creating an instance.**   The options are Default Access, Full Access, and Set Access For Each API. If you aren't sure which to use, you can grant full access, but be sure to limit what the instance can do by assigning roles that constrain allowed operations.
- **Know that Cloud Logging collects logging events.**   They can be filtered and displayed in the Logging section of Cloud Console. You can filter by resource, type of log, log level, and period of time to display.

## Review Questions

You can find the answers in the Appendix.

1. What does IAM stand for?
   1. Identity and authorization management
   2. Identity and access management
   3. Identity and auditing management
   4. Individual access management
2. When you navigate to IAM & Admin in Cloud Console, what appears in the main body of the page?
   1. Members and roles assigned
   2. Roles only
   3. Members only
   4. Roles and permissions assigned
3. Why are basic roles classified in a category in addition to IAM?
   1. They are part of IAM.
   2. They were created before IAM.
   3. They were created after IAM.
   4. They are not related to access control.
4. A developer intern is confused about what roles are used for. You describe IAM roles as a collection of what?
   1. Identities
   2. Permissions
   3. Access control lists
   4. Audit logs
5. You want to list roles assigned to users in a project called ace-exam-project. What `gcloud` command would you use?
   1. `gcloud iam get-iam-policy ace-exam-project`
   2. `gcloud projects list ace-exam-project`
   3. `gcloud projects get-iam-policy ace-exam-project`
   4. `gcloud iam list ace-exam-project`
6. You are working in the form displayed after clicking the Add link on the IAM page of IAM & Admin in Cloud Console. There is a field called New Members. What items would you enter in that parameter?
   1. Individual users only
   2. Individual users or groups
   3. Roles or individual users
   4. Roles or groups
7. You have been assigned the App Engine Deployer role. What operations can you perform?
   1. Write new versions of an application only.
   2. Read application configuration and settings only.
   3. Read application configuration and settings and write new configurations.
   4. Read application configuration and settings and write new versions.
8. You want to list permissions in a role using Cloud Console. Where would you go to see that?
   1. IAM & Admin; select Roles. All permissions will be displayed.
   2. IAM & Admin; select Roles. Check the box next to a role to display the permissions in that role.
   3. IAM & Admin; select Audit Logs.
   4. IAM & Admin; select Service Accounts and then Roles.
9. You are meeting with an auditor to discuss security practices in the cloud. The auditor asks how you implement several best practices. You describe how IAM predefined roles help to implement which security best practice(s)?
   1. Least privilege
   2. Separation of duties
   3. Defense in depth
   4. Options A and B
10. What launch stages are available when creating custom roles?
    1. Alpha and beta only
    2. General availability only
    3. Disabled only
    4. Alpha, beta, general availability, and disabled
11. What is the `gcloud` command used to create a custom role?
    1. `gcloud project roles create`
    2. `gcloud iam roles create`
    3. `gcloud project create roles`
    4. `gcloud iam create roles`
12. A DevOps engineer is confused about the purpose of scopes. Scopes are access controls that are applied to what kind of resources?
    1. Storage buckets
    2. VM instances
    3. Persistent disks
    4. Subnets
13. A scope is identified using what kind of identifier?
    1. A randomly generated ID
    2. A URL beginning with `www.googleserviceaccounts`
    3. A URL beginning with `www.googleapis.com/auth`
    4. A URL beginning with `www.googleapis.com/auth/PROJECT_ID`
14. A VM instance is trying to read from a Cloud Storage bucket. Reading the bucket is allowed by IAM roles granted to the service account of the VM. Reading buckets is denied by the scopes assigned to the VM. What will happen if the VM tries to read from the bucket?
    1. The application performing the read will skip over the read operation.
    2. The read will execute because the most permissive permission is allowed.
    3. The read will not execute because both scopes and IAM roles are applied to determine what operations can be performed.
    4. The read operation will succeed, but a message will be logged to Cloud Logging.
15. What are the options for setting scopes in a VM?
    1. Allow Default Access and Allow Full Access only.
    2. Allow Default Access, Allow Full Access, and Set Access For Each API.
    3. Allow Full Access or Set Access For Each API Only.
    4. Allow Default Access and Set Access For Each API Only.
16. What `gcloud` command would you use to set scopes?
    1. `gcloud compute instances set-scopes`
    2. `gcloud compute instances set-service-account`
    3. `gcloud compute service-accounts set-scopes`
    4. `gcloud compute service-accounts define-scopes`
17. What `gcloud` command would you use to assign a service account when creating a VM?
    1. `gcloud compute instances create [INSTANCE_NAME] \--service-account [SERVICE_ACCOUNT_EMAIL]`
    2. `gcloud compute instances create-service-account [INSTANCE_NAME]\[SERVICE_ACCOUNT_EMAIL]`
    3. `gcloud compute instances define-service-account [INSTANCE_NAME]\[SERVICE_ACCOUNT_EMAIL]`
    4. `gcloud compute create instances-service-account [INSTANCE_NAME]\[SERVICE_ACCOUNT_EMAIL]`
18. What Google Cloud service is used to view audit logs?
    1. Compute Engine
    2. Cloud Storage
    3. Cloud Logging
    4. Custom logging
19. What options are available for filtering log messages when viewing audit logs?
    1. Period time and log level only
    2. Resource, type of log, log level, and period of time only
    3. Resource and period of time only
    4. Type of log only
20. An auditor needs to review audit logs. You assign read-only permission to a custom role you create for auditors. What security best practice are you following?
    1. Defense in depth
    2. Least privilege
    3. Separation of duties
    4. Vulnerability scanning