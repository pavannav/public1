# 12

# Implementing Identity and Security in Google Cloud

In the previous chapters, topics such as roles, users, and service accounts often appeared in the context of what permissions are needed to access or configure a specific Google Cloud service. This chapter will provide more visibility on identity and access in Google Cloud. In addition, we will focus on the security aspter and learn about preventing unauthorized access and auditing user actions on Google Cloud resources.

Furthermore, the *Google Cloud setup checklist* section in [*Chapter 3*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_03.xhtml#_idTextAnchor058) briefly mentioned a checklist that guided users through the initial setup of Google Cloud foundation in order to run enterprise ready workloads.The first points on this list were Cloud Identity users and groups, and administrative access. As those topics are important from the identity and security perspective, we will cover them in detail.

In this chapter, we will explore the following main topics:

- Creating a cloud identity for an organization
- Providing access to Google Cloud resources
- Managing service accounts
- Using Cloud Audit Logs for security and compliance

# Creating a Cloud Identity

Suppose you use a Google Cloud free trial, as described in the *Billing and budgets* section in [*Chapter 3*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_03.xhtml#_idTextAnchor058), to learn about the platform or use Google Cloud for small personal projects. To keep things simple, as you are the only user, you probably use your **@gmail** account, assigning it a **Project Owner** role for every project you create. The following figure shows an example of such a configuration:

![Figure 12.1 – Multiple personal projects owned by a single user](../images/B18851_12_01.jpg)

Figure 12.1 – Multiple personal projects owned by a single user

This approach is a good fit for small projects owned by a single user or just a few users, but a more scalable solution is needed for an enterprise. First, to manage access for multiple users and groups, and second, to provide a hierarchy of resources to match a large organization’s structure – departments, teams, or applications. This is where Google’s identity service comes into play as an alternative to using individual **@****gmail.com** accounts.

Google’s Identity as a Service platform allows for centralized management of users and groups. The platform includes security features such as password management, two-step verification, and single sign-on for SAML applications or third-party identity providers. Additionally, there is an option to synchronize identities from Active Directory or OpenLDAP to a Google directory.

There are two ways to configure an identity:

- Cloud Identity, which is available in both free and premium versions
- Workspace, which includes extra services such as Gmail, Google Drive, Docs, and Sheets

A company using a different identity provider still needs an identity account in Cloud Identity or Workspace. However, they can federate their provider to their Google identity account to access Google Cloud with existing credentials.

Let’s look at the example process of creating a free Cloud Identity account. To start the configuration, a company needs a domain. If it doesn’t own a domain, one can be purchased at [https://domains.google.com](https://domains.google.com/), as presented in the following figure:

![Figure 12.2 – Google Domains portal, where you can purchase and manage domains](../images/B18851_12_02.jpg)

Figure 12.2 – Google Domains portal, where you can purchase and manage domains

Note that a domain doesn’t necessarily have to come from the Google Domains platform. Next, a domain will be used to set up Cloud Identity. One domain can be associated with only one Cloud Identity

If logged in to the Google Cloud console as a @gmail user, you can set up your organization and Cloud Identity in the **Identity & Organization** section of **IAM & Admin**, as shown in the following screenshot:

![Figure 12.3 – Set up a Google Cloud organization in the console](../images/B18851_12_03.jpg)

Figure 12.3 – Set up a Google Cloud organization in the console

If you select **GO TO THE CHECKLIST**, you will directly access the Cloud Identity setup from the Google Cloud console:

![Figure 12.4 – Setup of Cloud Identity in the Google Cloud console](../images/B18851_12_04.jpg)

Figure 12.4 – Setup of Cloud Identity in the Google Cloud console

Alternatively, if you haven’t logged in to the Google Cloud console before but you own a domain, you can start setting up Cloud Identity using the following link: <https://workspace.google.com/gcpidentity/signup/welcome?sku=identitybasic>.

During the Cloud Identity setup, you provide a company name, contact info with an email from a different domain that will be used as a recovery email, a new or existing domain, and login details. A user created during the identity setup will have a **Super Admin** role, which is an administrator seed role with all permissions:

![Figure 12.5 – Selected screenshots from initializing Cloud Identity for a domain](../images/B18851_12_05.jpg)

Figure 12.5 – Selected screenshots from initializing Cloud Identity for a domain

Once the setup is done, you can further configure your Cloud Identity in the Google Admin console at [https://admin.google.com](https://admin.google.com/) using a new administrator account. Note that this is a different portal from the Google Cloud console.

Before you start creating users, Google must verify your domain ownership. For that reason, you will be asked to add a new TXT record to your domain on your host’s website:

![Figure 12.6 – Domain verification for Cloud Identity](../images/B18851_12_06.jpg)

Figure 12.6 – Domain verification for Cloud Identity

Google recommends using a **super admin** account only when necessary; for example, for account recovery scenarios. For day-to-day activities, separate accounts with fewer permissions should be created. Once your domain is configured and verified, you can proceed with creating users that will access Google Cloud resources.

## Users and groups

You can create accounts for each user to be managed by Cloud Identity manually in the **Users** tab in the **Directory** section of the Google Admin console by selecting **Add new user** as shown in *Figure 12**.7*. Alternatively, you can upload user accounts via a CSV file, sync users with your existing LDAP directory, such as Active Directory, or use the Admin SDK Directory API to create and manage users programmatically.

![Figure 12.7 – Adding users in the Google Admin console](../images/B18851_12_07.jpg)

Figure 12.7 – Adding users in the Google Admin console

Next, you can create groups and add users to groups in the **Groups** section. For example, as presented in the following screenshot, one of the first groups that should be created is the **gcp-organization-admins** group (the name is only a suggestion), which consists of users that, in the next step, obtain permissions to create and manage a Google Cloud **organization**, a root node in the Google Cloud resource hierarchy:

![Figure 12.8 – Groups in the Google Admin console](../images/B18851_12_08.jpg)

Figure 12.8 – Groups in the Google Admin console

The necessary permissions to manage an organization in Google Cloud are not set in the Google Admin console but in the Google Cloud console. Users with Cloud Identity accounts will be able to log in to the Google Cloud console and create and access resources according to their assigned roles and permissions. The following section will provide more details on managing an organization, users, and resources.

Note that although in Google Console, you can’t create individual users, there is still an option to create service accounts and Google groups. Permissions in Google Cloud can be granted to a Cloud Identity user, a Cloud Identity group, a Google Cloud service account, and a Google group. Find out more about Google [Groups at https://cloud.google.com/iam/docs/groups-in-c](https://cloud.google.com/iam/docs/groups-in-cloud-console)loud-console.

# Identity and Access Management (IAM)

When you log in to the Google Cloud console with a newly created **super admin** user, right after its Cloud Identity is configured, a Google Cloud **organization** resource will be automatically created once you accept the terms and conditions. In addition, the organization will be linked to your billing.

As a first step after logging in as a **super admin**, you should go to the **IAM** section of **IAM & Admin** and assign the **Organization Administrator** role to the previously created **gcp-organization-admins** group, as shown in the following screenshot. Next, you can log in as a member of this group, start configuring resources, and provide other users with permissions. This way, you will avoid using a **super admin** account to manage Google Cloud resources. The role and permissions assignment process will be explained in detail in the following sections.

![Figure 12.9 – Assigning the Organization Administrator role to the gcp-organization-admins group](../images/B18851_12_09.jpg)

Figure 12.9 – Assigning the Organization Administrator role to the gcp-organization-admins group

**Identity and Access Management** (**IAM**) is where you centrally control who can do what type of activities on which Google Cloud resources. Note that *resources* are not only Google Cloud services such as Compute Engine VMs or Google Cloud Storage. IAM can control access to a project, folder, or even organizational level. It helps to adopt the security principle of least privilege as it allows building fine-grained access to resources. Let’s investigate a hierarchy of Google Cloud resources to better understand how permissions are applied across all levels.

## Building a resource hierarchy

In the Google Cloud resource hierarchy, an organization is provisioned automatically and it is the top-level node above all other folders, projects, and resources. Any policies or restrictions set at the organization level will apply to the folders, projects, and resources that fall under it.

The hierarchy helps to manage access to resources, so there is no need to work with resource owners individually. For example, if a resource owner leaves an organization, the resource can be assigned to another user or team.

Following the **Cloud Identity and organisation** setup wizard introduced earlier in this chapter, you will be presented with various examples of how a resource hierarchy can be configured in the **Hierarchy and** **access** section:

![Figure 12.10 – “Hierarchy and access” step of the “Cloud Identity and organization setup” checklist](../images/B18851_12_10.jpg)

Figure 12.10 – “Hierarchy and access” step of the “Cloud Identity and organization setup” checklist

Folders will help you to organize a hierarchy so it matches the structure of your company. For example, you can create folders for each department, nest additional folders for each team in a department, and set up permissions so that users can only access their team’s resources. The folder structure will also provide security isolation and separate workload types such as production and development.

Google Cloud **projects**, which are containers where you run workloads, can be attached directly to an organization or placed in folders or nested folders.

The following diagram presents an example of a simple resource hierarchy. Under **Organization: example.com**, there are two folders: **test** and **production**. In the **test** folder, there are two projects: **test-1** and **test-2**, with various Google Cloud services. There is one project in the **production** folder: **production**, also with various Google Cloud services:

![Figure 12.11 – Example of an organization hierarchy](../images/B18851_12_11.jpg)

Figure 12.11 – Example of an organization hierarchy

IAM controls access to resources at different levels of a resource hierarchy. Permission to create, modify, or view a resource can have various attachment points – organization, folder, or project. For example, if a Compute Admin role was assigned to users at the organization level, it would be inherited by all projects. If a Compute Admin role was assigned at the folder level, as shown in *Figure 12**.11*, where the Compute Admin role is assigned to users at the **test** folder level, it would be propagated only to projects **test-1** and **test-2** in the **test** folder. If a Compute Admin role was assigned to users at the project level (the **production** project in this example), it would be propagated only in this one project. In some cases, permissions can even be assigned to an individual resource in a project.

Note that a policy for a resource is a union of what is set on a resource directly and what is inherited as a project, a folder, and an organization policy. But if access is allowed higher in a hierarchy, it can’t be restricted at a lower level.

## IAM roles

In Google Cloud, permissions are not assigned to users and groups directly. Instead, users have roles assigned to them. Roles are a collection of permissions. Permissions usually match API methods that describe which operations are allowed on a resource and have the following form: **<service>.<resource>.<action>**.

![Figure 12.12 – Example of a role, which is a set of permissions](../images/B18851_12_12.jpg)

Figure 12.12 – Example of a role, which is a set of permissions

For example, as the preceding screenshot illustrates, the **Storage Object Admin** role is a collection of permissions such as **storage.objects.create** or **storage.objects.delete**.

There are three types of IAM roles:

- **Basic** roles, with very broad access that spans multiple Google services:
  - **Viewer**, a role that allows viewing all resources.
  - **Editor**, a role that allows viewing, creating, and deleting all resources.
  - **Owner**, a role that allows viewing, creating, and deleting all resources and managing roles and permissions. Also, it allows setting up billing for a project.

![Figure 12.13 – Basic IAM roles in the Google Cloud console](../images/B18851_12_13.jpg)

Figure 12.13 – Basic IAM roles in the Google Cloud console

- **Predefined** roles, that offer finer-grained access to resources. Those roles have permissions bundled together and usually have sufficient scope for working with a specific service. Administrators can choose from multiple options such as an admin of a service, a user of a service, or a viewer of a service. Multiple roles can be combined to provide necessary access. For example, the **Compute Engine Instance Admin** role has a set of permissions to manage Compute Engine VMs. Still, a user will need the **compute.networks.create** permission, which belongs to the **Compute Network Admin** role, to create a subnet for a VM:

![Figure 12.14 – Predefined IAM roles in the Google Cloud console](../images/B18851_12_14.jpg)

Figure 12.14 – Predefined IAM roles in the Google Cloud console

- **Custom** roles can be created from scratch by manually putting the required permissions together. Also, a custom role can be created out of an existing role or from existing roles. Custom roles require more administrative work to keep them up to date than predefined roles, as Google can introduce modifications to Google Cloud permissions from time to time.

To create a custom role, go to the **Roles** section in **IAM & Admin** and select **CREATE ROLE**. Next, you need to provide a descriptive name and set of permissions you want to be included in this role:

![Figure 12.15 – Predefined IAM roles in the Google Cloud console](../images/B18851_12_15.jpg)

Figure 12.15 – Predefined IAM roles in the Google Cloud console

Building a role from scratch could be a trial-and-error process before completing the list of permissions. Creating a new role by cloning and modifying existing ones that best match the desired permissions would be easier.

Suppose you want to create a role with almost all Cloud Storage administrative permissions except the one for deleting objects. To achieve it, you should select the **Storage Admin** role in the **Roles** section and choose **CREATE FROM ROLE** option as presented in the following screenshot:

![Figure 12.16 – Creating a new role from an existing one](../images/B18851_12_16.jpg)

Figure 12.16 – Creating a new role from an existing one

Next, you need to select a name (**Custom Storage Admin – Can't Delete Objects** in this case) and a description and remove permissions you don’t need for this role from the list. In our case, it will be **storage.objects.delete**:

![Figure 12.17 – Selecting permissions for a custom role](../images/B18851_12_17.jpg)

Figure 12.17 – Selecting permissions for a custom role

Once the role is created, it will be available for assignment, as presented in the following screenshot:

![Figure 12.18 – Custom role assignment for a user](../images/B18851_12_18.jpg)

Figure 12.18 – Custom role assignment for a user

It is advised to test a role before assigning it to users. In this case, a role was assigned to the **app-owner** user. When trying to delete an object in a Google Cloud Storage bucket, this user was presented with an error that permission was missing for deleting an object, as can be seen in the following screenshot. Errors often describe what permission is missing for the task to be completed, simplifying troubleshooting:

![Figure 12.19 – A user needs the storage.object.delete permission to delete Google Cloud Stroage objects](../images/B18851_12_19.jpg)

Figure 12.19 – A user needs the storage.object.delete permission to delete Google Cloud Stroage objects

Note that it is possible to copy custom roles between projects. The **gcloud** command can be used to copy a role created as in the preceding example (where we used **CustomStorageAdmin** as the source role ID, as shown in *Figure 12**.17*) to another project:

```
gcloud iam roles copy --source=CustomStorageAdmin --source-project=<source-project> --destination=CustomStorageAdmin --dest-project=<destination-project>
```

## IAM policies

Now that we have learned how to create accounts, build a resource hierarchy, and set up roles, we will look into IAM policies that connect all of those items to allow users to access resources in a fine-grained way within a hierarchy.

In IAM, Cloud Identity users, Cloud Identity groups, service accounts, and, for some services, a Cloud Identity organization or all (authenticated) users are called **principals**. **Principals** are granted roles on resources via IAM policy binding.

Note that a recommended practice for IAM policies is not to grant roles to individual users but to groups. Groups help manage users at scale because each member inherits roles assigned at the group level.

The following figure presents how IAM access to resources is set up. It is the result of assigning a principal (such as a group or a user) an IAM role (a set of permissions) on a resource (such as a project, folder, or – in some cases – a particular service). Note that the higher a resource in a hierarchy, the broader the access scope. For example, all projects under a folder will inherit permissions assigned at the folder level.

![Figure 12.20 – An IAM policy consists of a principal, a role, and a resource](../images/B18851_12_20.jpg)

Figure 12.20 – An IAM policy consists of a principal, a role, and a resource

Now, let’s take a look at how IAM access can be assigned to resources in the Google Cloud console:

1. To grant access to resources, select **GRANT ACCESS** in the **IAM** section in **IAM and admin**. In the **IAM** section, you can also find a list of existing permissions at the project level or, if a folder or organization was selected, at higher levels in a hierarchy:

![Figure 12.21 – Granting access to resources in IAM in the Google Cloud console](../images/B18851_12_21.jpg)

Figure 12.21 – Granting access to resources in IAM in the Google Cloud console

1. In the next step, you provide a principal and a role. A principal can have multiple roles assigned. The following screenshot presents the **GRANT ACCESS** view for different scenarios. On the left-hand side, an organization is a resource on which a basic role, **Viewer**, is assigned to a single user. On the right-hand side, a folder is a resource on which a predefined role, **Storage Admin**, is assigned to a group of users:

![Figure 12.22 – Comparing different IAM policies at an organization and a folder level](../images/B18851_12_22.jpg)

Figure 12.22 – Comparing different IAM policies at an organization and a folder level

The following is another example where two roles are assigned to a single user at the project level. To add more roles, as in this case, select **ADD ANOTHER ROLE** in the **GRANT ACCESS** view of the **IAM** section:

![Figure 12.23 – Adding multiple roles to a principal](../images/B18851_12_23.jpg)

Figure 12.23 – Adding multiple roles to a principal

Note that in the **IAM** section, you can view permissions for each principal and modify them as presented in the following screenshot:

![Figure 12.24 – Viewing and editing IAM permissions](../images/B18851_12_24.jpg)

Figure 12.24 – Viewing and editing IAM permissions

When permissions are assigned higher in a hierarchy, such as at the folder level, you can’t modify them at a lower (project) level. In such cases, the edit option is grayed out.

## Organization policies

One of the additional benefits of building a resource hierarchy is the ability to centrally set constraints on what users can configure on a Google Cloud service. Applying organization policies to a resource hierarchy at the root level helps to comply with a company’s security policies across all projects.

Let’s look at the following example. Suppose one of the outcomes of a security audit in your company is a request to limit external access to Compute Engine VMs. It was discovered that users create VMs with a public IP, and firewall rules allow access from the internet to VMs on certain ports. As your company has multiple projects, controlling how VMs are configured would be challenging. Although organization policies don’t enforce policies retrospectively, they can control how new resources are configured. To help the company to improve its security posture, you can configure the **Define allowed external IPs for VM instances** policy at your organization level.

You can set this policy up by selecting your organization as the scope and editing the policy in **Organization Policies** in **IAM & Admin**, as presented in the following screenshot:

![Figure 12.25 – Listing policies for an organization](../images/B18851_12_25.jpg)

Figure 12.25 – Listing policies for an organization

In the **Rules** section of the **Edit policy** view, you can define on which resources a policy will be enforced (for example, a specific VM name or a tag). In our example, it will be denied for all VMs:

![Figure 12.26 – Customizing a policy that limits assigning a public IP to VMs](../images/B18851_12_26.jpg)

Figure 12.26 – Customizing a policy that limits assigning a public IP to VMs

Once the policy is modified, you can verify whether it works as expected. The following screenshot shows the **Create an instance** view, where a user is presented with a warning that a specific organization policy is in place and that it is not allowed to add an external address to a VM:

![Figure 12.27 – Verifying that an organization policy takes effect, and a user cannot assign a public IP to a VM](../images/B18851_12_27.jpg)

Figure 12.27 – Verifying that an organization policy takes effect, and a user cannot assign a public IP to a VM

Suppose another audit revealed that users create resources outside of their home country. As your company has a regulatory obligation to keep workloads and data within a country, you need to prevent this from happening. In this case, you can use the **Google Cloud Platform – Resource Location Restriction** policy at the organization level to enforce all new resources only to be created in a specific Google Cloud region, for example, only in **europe-central2** (Warsaw). You can define the scope of the policy in the **Rules** section, creating an **allow** entry with the following condition: **in:europe-central2-locations** (all zones in the **europe-central2** region), as presented in the following screenshot:

![Figure 12.28 – Creating an organization policy rule to allow creating resources only in europe-central2 zones](../images/B18851_12_28.jpg)

Figure 12.28 – Creating an organization policy rule to allow creating resources only in europe-central2 zones

Now, if users want to create resources, depending on the service, either only the **europe-central2** region will be available for selection or an attempt to create a resource in another region will fail. The following figure shows that a user wants to create a Google Cloud Storage bucket and Warsaw is the only region available. This proves that the policy is working as expected.

![Figure 12.29 – A location policy allows creating resources only in the selected region](../images/B18851_12_29.jpg)

Figure 12.29 – A location policy allows creating resources only in the selected region

Check the list of all avail[able policies that you can apply to your organization at](https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints) .

Up to this point, we have focused on providing access or restricting it for users or groups at the organization, folder, or project level. A similar approach can also be applied to service accounts, the special accounts that are used not by humans but by applications. In the next section, we will provide more insights into this topic.

# Managing service accounts

A service account is an identity that an application or a Compute Engine VM uses to run authorized API calls to Google Cloud services such as Google Cloud Storage, BigQuery, and so on. Contrary to a user account, this account type is not created in the Google Admin console as a Cloud Identity, but in a Google Cloud project. It doesn’t have a password and can’t be used for interactive login to a console. Service accounts can be used by applications running in Google Cloud and on-premises. Also, users can use service accounts in certain scenarios.

There are the following types of service accounts:

- **Google-managed service accounts** (service agents) are created automatically so that Google Cloud services that you enable can interact with your resources. You can find the complete list of service agents at <https://cloud.google.com/iam/docs/service-agents>.
- **User-managed default service accounts** are created automatically when an API for a service is enabled. They help to get started with a service but can be modified or replaced later. For example, Compute Engine comes with a default service account: **<project-number>-compute@developer.gserviceaccount.com**.
- **User-managed service accounts** are created in IAM by a user with permissions: **iam.serviceAccounts.create**. A predefined role, **Service Account Admin**, or **Create Service Accounts** can be used for this task. User-defined accounts use the following format: **<service-account-name>@project-id.iam.gserviceaccount.com**.

Service accounts authenticate via short-lived credentials or associated public/private RSA key pairs.

![Figure 12.30 – Users, groups, and service accounts listed in the IAM section](../images/B18851_12_30.jpg)

Figure 12.30 – Users, groups, and service accounts listed in the IAM section

You can view the list of service accounts in the **IAM** section, as shown in the preceding screenshot. Alternatively, you can use the **gcloud** command:

```
gcloud iam service-accounts list
```

Now, having introduced the concept of a service account, in the next section, we will look into how to create and manage permissions for this type of account.

## Creating and granting permissions

As service accounts are not a part of Cloud Identity, there is a dedicated section, **Service accounts** in the **IAM & Admin** view, where you can create and configure them. For example, the following screenshot presents a service account created in the console:

![Figure 12.31 – Creating a service account in the Google Cloud console](../images/B18851_12_31.jpg)

Figure 12.31 – Creating a service account in the Google Cloud console

After selecting **CREATE SERVICE ACCOUNT** in the **Service accounts** section, you need to provide a descriptive name, such as **bucket-access** in this example, and either add roles and users that can impersonate the account or skip this step and assign them later. The **gcloud** command equivalent would be the following:

```
gcloud iam service-accounts create bucket-access --description="account used to access google cloud storage" --display-name="bucket-access"
```

For the role assignments for a service account, go to the **IAM** section and select **GRANT ACCESS**, as presented in the following figure. Provide your service account in the **Add principals** section and select required roles in the **Assign roles** section. Role assignment for service accounts is similar to user role assignment. Using service accounts with minimum permissions is recommended, so even though it is possible to assign basic roles to a service account, it would be better to use predefined or customized roles.

In the example that follows, a **bucket-access** service account is granted the **Storage Admin** role. This means that whoever has access to this account (a user, a Compute Engine VM, or a service) can use it to interact with Google Cloud Storage to create or delete buckets and objects:

![Figure 12.32 – Assigning a role to a service account](../images/B18851_12_32.jpg)

Figure 12.32 – Assigning a role to a service account

Users that use **basic roles** have access to service accounts by default. If you don’t use basic roles, you need to explicitly grant a user access to a service account in the **Service Accounts** view by selecting a service account and then selecting **GRANT ACCESS** in the **PERMISSIONS** tab:

![Figure 12.33 – Granting access to a service account for a user](../images/B18851_12_33.jpg)

Figure 12.33 – Granting access to a service account for a user

By granting access, you use a service account not as an *account* anymore. It becomes a resource, meaning you grant a user a specific role on a service account. For example, when you create a Compute Engine VM, you can provide a service account that this VM will use to access services such as Google Cloud Storage.

Note that if you don’t have a **Service Account User** role on this service account, you won’t be able to create a VM with this service account assigned.

## Attaching service accounts to resources

As mentioned in the previous section, a resource such as a Compute Engine VM can use a service account to interact with a Google Cloud API. Note that it is also possible to attach a service account to a resource that is deployed in a different project.

When a VM is created, it uses a default service account that you can replace with a new one assuming you have at least a **Service Account User** role on this new account:

![Figure 12.34 – Adding a service account to a Compute Engine VM](../images/B18851_12_34.jpg)

Figure 12.34 – Adding a service account to a Compute Engine VM

Once a VM is created, you can access it via ssh and check what credentials it uses to authenticate to Google Cloud services with the following command: **gcloud** **auth list**.

In the following figure, a **vm-a** Compute Engine VM uses the **bucket-access** service account. This service account has a **Storage Admin** role in this project. This means a VM using this service account can access and interact with Google Cloud Storage. For example, it can create and list buckets as shown in the following screenshot:

![Figure 12.35 – Using a service account to interact with Google Cloud Storage from a Compute Engine VM directly](../images/B18851_12_35.jpg)

Figure 12.35 – Using a service account to interact with Google Cloud Storage from a Compute Engine VM directly

To confirm what type of account was actually used for a **my-new-bucket-to-test-service-account** creation (shown in *Figure 12**.35*), we can look into the Cloud Logging log entry for the **GCS Bucket** type and confirm that the **bucket-access** user account was used:

![Figure 12.36 – Cloud Logging log entry showing the account used for a bucket creation](../images/B18851_12_36.jpg)

Figure 12.36 – Cloud Logging log entry showing the account used for a bucket creation

Check the following link to see what other Google Cloud services besides Compute Engine VMs use service accounts: <https://cloud.google.com/iam/docs/attach-service-accounts>.

## Impersonating a service account

Because a service account can also act as a resource, you can grant access to it to users or groups. The ability to temporarily act as another identity in a controlled way helps administrators to limit the scope of permissions assigned to users. For example, users can have permissions necessary for day-to-day activities, and occasionally, for a limited time, can impersonate a service account for some extra activities.

Let’s look at the example in the following figure. The **app-owner** user has the following roles: **Viewer**, to browse the resources in this project, **Compute Instance Admin,** to manage compute instances, and the **Service Account Token Creator** role (on the **bucket-access** service account), which allows impersonating a service account.

![Figure 12.37 – Impersonating a service account by a user](../images/B18851_12_37.jpg)

Figure 12.37 – Impersonating a service account by a user

In the CLOUD SHELL section of the screenshot, you can see the **app\_owner** user trying to create a storage bucket. This task fails, as the user doesn’t have the required permissions. However, once the same command is issued with **--impersonate-service-account=bucket-access@**, the command succeeds and the bucket is created because **bucket-access** is a service account with a **Storage** **Admin** role.

## Short-lived service account credentials

If you are building an application outside Google Cloud, a service account will be used to interact with Google Cloud services. You will need a way to authenticate with this account. It doesn’t come with a password, so an alternative could be to generate an RSA public/private key pair. The following screenshot shows how to achieve this in the Google Cloud console:

![Figure 12.38 – Creating a key pair for a service account](../images/B18851_12_38.jpg)

Figure 12.38 – Creating a key pair for a service account

Service account key details are presented in the **KEYS** tab when selecting a service account. You can create a new pair by selecting **ADD KEY**. Note that you can download a private key only during the key pair’s creation.

Access to a file with a key is sufficient to authenticate as a service account that owns the key. In the example that follows, the **gcloud auth activate-service-account <service account> --key-file=<path/key> --project=PROJECT\_ID** command is used in **vm-a** that could even be running on-premises, followed by a command that creates a storage bucket. The service account – **bucket-access** – is the one that interacts with the Google Cloud Storage service from outside of a project:

![Figure 12.39 – Using a service account with a key](../images/B18851_12_39.jpg)

Figure 12.39 – Using a service account with a key

As a downloaded key could be easily shared between users and possibly exposed, it is recommended to consider alternative options. When there is no other option, rotating keys frequently is highly recommended. One of the alternatives would be to use workload identity federation and give external identities permission to impersonate a service account and generate short-lived credentials for [the application. You can find more information on workload ide](https://cloud.google.com/iam/docs/workload-identity-federation)ntity federation at <https://cloud.google.com/iam/docs/workload-identity-federation>.

Let’s examine the other alternative, the token generation process, to better understand the benefits of short-lived credentials.

The **gcloud auth print-access-token** command returns a short-lived OAuth 2.0 access token that can be used for API calls on behalf of this user. In particular, the **gcloud auth print-access-token –impersonate-service-account=<service\_acount>** command (assuming the **Service Account Token Creator** role is granted for the requester on a privilege-bearing service account) will return a short-lived (one hour by default) access token for a service account. Like a **bucket-access** account, a service account can have fine-grained permissions required for controlled interaction with a single service only, like Google Cloud Storage. In addition, the limited lifetime of a token minimizes the threat of it falling into the wrong hands, as could happen to a key.

Look at the following example. Details of a token generated by **gcloud auth print-access-token** can be validated using an HTTPS POST request: **https://oauth2.googleapis.com/tokeninfo?access\_token=<ACCESS\_TOKEN>**.

![Figure 12.40 – Checking details about a token via HTTPS POST](../images/B18851_12_40.jpg)

Figure 12.40 – Checking details about a token via HTTPS POST

An application can use a new token for an hour to interact with Google Cloud Storage as the token generated for a **bucket-access** service account, the one with the **Storage Admin** role assigned:

![Figure 12.41 – Creating a bucket via API using an access token](../images/B18851_12_41.jpg)

Figure 12.41 – Creating a bucket via API using an access token

The logic described is usually implemented programmatically and embedded into the code of an application. Client libraries handle token management.

Note that the number of service accounts for a project is limited by quotas. By default, you can create up to 100 service accounts. A good security practice is to remove any unused accounts. Since the number of service accounts can increase over time, it can become challenging to manage them, especially when multiple applications use them only occasionally. In case you are unsure if an application still uses a service account that you are about to delete, disable it first and ensure it is not used before deleting it.

Now that we have learned how to create users, groups, and service accounts and control their access to various Google Cloud resources, it is important to highlight that those tasks are just the first step in securing your environment. The next step is to find a way to make sure all permissions are assigned correctly and the desired setup is preserved. Also, if certain permissions are assigned, it is still important to know whether they were used with good and justified intentions. The next section will introduce the audit logging concept, which helps to track access and changes to your Google Cloud environments.

# Using Cloud Audit Logs

In [*Chapter 11*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_11.xhtml#_idTextAnchor237), in the *Cloud Logging* section, we explored various types of Google Cloud logs and learned how to view, filter, and store them. The concept of Cloud Audit Logs was briefly introduced as well. This section aims to provide more visibility into the Cloud Audit Logs topic.

Cloud Audit Logs are a part of Cloud Logging. Still, contrary to logs generated by workloads, they record user actions providing details on who did what activity (for example, created or deleted a resource) from where (such as from a local computer, browser etc.)and when this happened. This type of log is mainly collected for auditing, troubleshooting, and compliance.

There are the following audit log types:

- **Admin Activity** logs that log users’ creation and deletion of Google Cloud resources. The log collection is enabled by default and can’t be disabled. We also can’t delete such logs. Google will store them for 400 days in the **\_Required** log bucket for free. You can retain them longer by creating a parallel log sink to another destination. Refer to the *Configuring log routers* section in [*Chapter 11*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_11.xhtml#_idTextAnchor237) to review how this can be achieved.

A simplified view of Admin Activity logs can can be found (at the time of writing this chapter) on the Google Cloud console home page in the **ACTIVITY** tab.

The following screenshot presents example log entries generated when the **app-owner** user created and deleted buckets:

![Figure 12.42 – The ACTIVITY tab presenting a simplified version of Admin Activity logs](../images/B18851_12_42.jpg)

Figure 12.42 – The ACTIVITY tab presenting a simplified version of Admin Activity logs

**Logs Explorer** in the **Cloud Logging** section provides detailed insight into Cloud Audit Logs. If you select **CLOUD AUDIT: activity** for **Log name**, you will see all the Admin Activity entries, as presented in the following screenshot:

![Figure 12.43 – Admin activity audit log in Log Explorer generated during a Google Cloud Storage bucket creation](../images/B18851_12_43.jpg)

Figure 12.43 – Admin activity audit log in Log Explorer generated during a Google Cloud Storage bucket creation

- **Data Access** logs are generated when users read or write to Google Cloud resources or read metadata information. For example, when a user creates a Google Cloud Storage bucket, an Admin Activity log is generated. When users upload or access objects in this bucket, this activity generates Data Access logs. Multiple users or applications could access those objects, generating a high volume of logs, which is why Data Access logs are disabled by default. You can enable log generation per service in the **Audit log** view of the **IAM & admin** section. The following figure presents how Data Access logs can be enabled for a selected service.

Three types of Data Access logs can be enabled separately (see *Figure 12**.44*): **Admin Reads** (for reading metadata and configuration information), **Data Read** (for reading user data), and **Data Write** (for writing user data). By default, those logs are chargeable, have 30 days of retention, and are stored in the **\_Default** log bucket.

To limit the number of generated logs, you can “exempt principals,” meaning logs will not be generated for selected user or service accounts, even if the log collection is enabled. For example, suppose you have an application that constantly reads from a Google Cloud Storage bucket using a service account. This service account could be added as an exempted principal, so its actions won’t generate Data Access logs. On the other hand, you can set up an organization policy to disallow Audit Logging exemptions to enforce logging for all accounts.

![Figure 12.44 – Enabling audit logs for data access to Google Cloud Storage](../images/B18851_12_44.jpg)

Figure 12.44 – Enabling audit logs for data access to Google Cloud Storage

- **System Event** logs are automatically generated by Google systems and stored for free in the **\_Required** log bucket. You can’t disable or delete them. They record actions driven by the Google Cloud platform and can be viewed in the Logs Explorer. For instance, the following screenshot shows **system\_event** logs generated during a server maintenance action when a Compute Engine VM was migrated to another server. System Event logs could be a good source of information for troubleshooting. For example, if you want to understand why a VM was rebooted, you can check whether a host error caused this by verifying System Event log entries:

![Figure 12.45 – System Event log entry generated during a host maintenance event](../images/B18851_12_45.jpg)

Figure 12.45 – System Event log entry generated during a host maintenance event

- **Policy Denied** logs are generated when a user or service account is denied access to a Google Cloud service because of a security policy violation. The logs are generated and stored in the **\_Default** log bucket and can’t be disabled. Policy Denied logs are chargeable, but you can exclude them from ingestion.

For security reasons, only certain users should have access to audit logs, which may contain sensitive data. The **Logs Viewer** role grants access to Admin Activity and System Event logs, but to view Data Access audit logs, a separate **Private Log Viewer** role is required.

# Summary

This chapter explored setting up an organization and building a resource hierarchy to match a company’s structure. We learned how to control access to Google Cloud resources on a project, folder, and organizational level. One of the most important topics we investigated was working with service accounts used by Google Cloud services and external applications. Lastly, we looked into Cloud Audit Logs that need to be collected to meet an enterprise’s security and compliance needs.

# Questions

Answer the following questions to test your knowledge of this chapter:

1. Suppose you have just created a new Google Cloud project and want to follow the best practices for granting access to its resources. How can you provide view permissions to all resources in the project for your team members?
   1. Grant each user a basic Viewer role.
   2. Create a group and add all team members to this group. Assign a basic Viewer role to this group.
   3. Create a group and add all team members to this group. Assign a basic Editor role to this group.
   4. Grant each user a basic Editor role.
2. What would be a good use case for basic roles?
   1. Basic roles could be used in a test environment only, or if, a project has just one owner.
   2. Basic roles can’t be used as they are being deprecated.
   3. You should always use basic roles because they are easy to manage and kept up to date by Google.
   4. Basic roles should only b[e used with service acco](https://admin.google.com/)unts.
3. How can a user create a service account?
   1. In the Google Admin console at https://admin.google.com.
   2. In the Cloud Identity console.
   3. There is no need to create service accounts. They are created automatically when an API for a service is enabled.
   4. Service accounts can be created in IAM in the Google Cloud console.
4. What is the difference between the following roles: Service Account User and Service Account Token Creator?
   1. Service Account User role allows to attach a service account to a resource and Service Token Creator role allows to create access tokens for a service account.
   2. You need a Service Account User role to be able to assign a Service Token Creator role to a service account.
   3. There is no difference. You can use them interchangeably.
   4. You need a Service Account User role to be able to create tokens.
5. What is a recommended approach to granting an application outside Google Cloud administrative access to Google Cloud Storage?
   1. Create RSA keys for a service account with a Storage Admin role assigned. Store the private key on-premises. The application can leverage **gcloud auth activate-service-account <service account> --key-file=<path/key> --project=PROJECT\_ID** for authentication.
   2. You can’t grant an application outside Google Cloud access to Google Cloud Storage.
   3. Use Service Token Creator permissions to generate access tokens for a service account with a Storage Admin role assigned.
   4. Impersonate a service account in the application with **--impersonate-service-account=bucket-access**, where **bucket-access** is a service account with a Storage Admin role assigned.
6. You made a mistake and accidentally deleted a Cloud Storage bucket with rarely accessed archive data. You managed to restore the bucket and objects from a backup. Is there a way to hide this embarrassing accident from your team?
   1. There is no way to hide it. Deleting and creating a resource will be logged in Admin Activity.
   2. Deleting and creating a resource will be logged in Admin Activity and retained for 400 days. If no one checks the logs within that time, the log entry will eventually be deleted.
   3. Deleting and creating a resource will not be logged at all without an additional setup.
   4. Deleting and creating a resource will be logged. You can delete the log entry in Cloud Logging, having the Logging Admin role, so no one discovers what happened.
7. During a team meeting, you discuss simplifying permissions management for multiple projects your team created. All projects are configured directly under your organization, and all users have Editor roles on projects. What approach would you recommend to improve management and security?
   1. Create a folder resource under the organization and move all your team’s projects under this folder. Use organization policies to enforce better security, such as disallowing public IP usage and creating RSA keys for service accounts.
   2. Create a folder resource under the organization and move all your team’s projects under this folder. Create one group account for your team and add users to the group. Assign predefined roles to the group on a folder level. Use organization policies to enforce better security, such as disallowing public IP usage and creating RSA keys for service accounts.
   3. Create a folder resource under the organization and move all your team’s projects under this folder. Create group accounts for your team and add users to the groups according to their needs. Assign predefined roles to the groups at the folder level. If needed, assign additional predefined roles on a project level. Delete permissions assigned to individual users in projects.
   4. Once the projects are created under an organization, you can’t introduce any changes to the hierarchy.

# Answers

The answers to the preceding questions are provided here:

1B, 2A, 3D, 4A, 5C, 6B, 7C