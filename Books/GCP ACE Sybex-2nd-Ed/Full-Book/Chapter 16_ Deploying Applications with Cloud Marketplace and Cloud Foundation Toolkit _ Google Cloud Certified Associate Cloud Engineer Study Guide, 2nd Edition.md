---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **3.6 Deploying a solution using Cloud Marketplace**
- **3.7 Implementing resources via infrastructure as code**

---

Throughout this study guide, you have learned how to deploy computing, storage, and networking resources, and now you will turn your attention to deploying applications. Cloud Marketplace is a Google Cloud service for finding and deploying preconfigured applications that are ready to run the Google Cloud. Cloud Marketplace lets users deploy applications and necessary compute, storage, and network resources without having to configure those resources themselves. Cloud Foundation Toolkit is a suite of tools used to streamline deploying infrastructure as code.

## Deploying a Solution Using Cloud Marketplace

Cloud Marketplace is a central repository of applications and data sets that can be deployed to your Google Cloud environment. Working with the Cloud Marketplace is a two-step process: browsing for a solution that fits your needs and then deploying the solution.

### Browsing Cloud Marketplace and Viewing Solutions

To view the solutions available in Cloud Marketplace, navigate to the Marketplace section. This will display a page like that shown in [Figure 16.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0001).

The main page of Cloud Marketplace shows some featured solutions. The solutions shown in [Figure 16.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0001) include Elastic Cloud (Elasticsearch Service), Apache Kafka on Confluent Cloud, MongoDB Atlas, as well as APIs for geocoding and directions.

You can either search or browse by filter to see the list of solutions. [Figure 16.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0002) shows the list of categories of available solutions.

You can narrow the set of solutions displayed on the main page by choosing a particular category. For example, if you filter to see Big Data only, you will see a list of options, as shown in [Figure 16.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0003). You can see a list of available operating systems in [Figure 16.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0004).

![Snapshot of cloud Marketplace main page](../images/c16f001.png)


[**FIGURE 16.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0001) Cloud Marketplace main page

Notice that you can further filter the list of operating systems by license type. The license types are free, flat hourly rate, usage fees, and bring your own license (BYOL). Free operating systems include Linux and FreeBSD options. The operating systems available for a fee include Windows and enterprise-supported Linux. You will be charged a fee based on your usage, and that charge will be included in your Google Cloud billing. The BYOL option includes two supported Linux operating systems that require you to have a valid license to run the software. You are responsible for acquiring the license before running the software.

[Figure 16.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0005) shows a sample of developer tools available in Cloud Marketplace. These include WordPress, Joomla, and Alfresco.

Let's take a look at the kind of information provided along with the solutions listed in Cloud Marketplace. [Figure 16.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0006) shows the bulk of the information available. It includes an overview, pricing information, and details about the contents of the package. There is also information on where the solution will run within Google Cloud.

![Snapshot of filtering by category](../images/c16f002.png)


[**FIGURE 16.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0002) Filtering by category

Pricing information (see [Figure 16.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0007)) is also shown on the overview page. These are estimated costs for running the solution, as configured, for one month, which includes the costs of VMs, persistent disks, and any other resources. The price estimate also includes discounts for sustained usage of Google Cloud resources, which are applied as you reach a threshold based on the amount of time a resource is used.

The last sections of the product overview page provide information and links to documentation and tutorials as well as support information.

![Snapshot of big Data options available in Cloud Marketplace](../images/c16f003.png)


[**FIGURE 16.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0003) Big Data options available in Cloud Marketplace

### Deploying Cloud Marketplace Solutions

After you identify a solution that meets your needs, you can launch it from Cloud Marketplace.

Go to the overview page of the product you would like to launch, as shown in [Figure 16.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0009), and select Launch.

This will open the page shown in [Figure 16.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0010). You may see a message stating that additional APIs must be enabled to deploy a solution. In that case, enable the additional APIs, and once you do, the page in [Figure 16.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0010) will appear.

![Snapshot of operating systems available in Cloud Marketplace](../images/c16f004.png)


[**FIGURE 16.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0004) Operating systems available in Cloud Marketplace

The contents of this page will vary by application, but many parameters are common across solutions. On this page, you specify a name for the deployment, a zone, and the machine type.

You can choose the type and size of the persistent disk. In this example, the solution will deploy to a 2 vCPU server with 8 GB of memory and a 10 GB boot disk using standard persistent disks. If you wanted, you could opt for an SSD disk for the boot disk. You can also change the size of the boot disk.

![Snapshot of developer tools available in Cloud Marketplace](../images/c16f005.png)


[**FIGURE 16.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0005) Developer tools available in Cloud Marketplace

In the Networking section, you can specify the network and subnet to launch the VM. You can also configure firewall rules to allow HTTP and HTTPS traffic. In addition, you can specify source IP ranges for HTTP and HTTPS traffic. If you expand the Networking section, you will see additional parameters for specifying network, subnetwork, and external IP addresses. (See [Figure 16.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0011).)

![Snapshot of overview page of a WordPress solution](../images/c16f006.png)


[**FIGURE 16.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0006) Overview page of a WordPress solution

![Snapshot of pricing estimates for the WordPress solution](../images/c16f007.png)


[**FIGURE 16.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0007) Pricing estimates for the WordPress solution

![Snapshot of tutorial and support information](../images/c16f008.png)


**FIGURE 16.8** Tutorial and support information

In addition to the parameters described earlier, the launch page will also display links to related documentation, as shown in [Figure 16.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0012).

Click the Deploy button to launch the deployment. That will open Deployment Manager and show the progress of the deployment (see [Figure 16.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0013)).

When the launch process completes, you will see a summary about the deployment and a button to launch the admin panel, as shown in [Figure 16.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fig-0014).

![Snapshot of launch a Cloud Marketplace solution from the overview page of the product.](../images/c16f009.png)


[**FIGURE 16.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0009) Launch a Cloud Marketplace solution from the overview page of the product.

![Snapshot of the launch page for a WordPress solution in Cloud Marketplace](../images/c16f010.png)


[**FIGURE 16.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0010) The launch page for a WordPress solution in Cloud Marketplace

![Snapshot of additional network parameters](../images/c16f011.png)


[**FIGURE 16.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0011) Additional network parameters

![Snapshot of links to related documentation are available on the deployment page.](../images/c16f012.png)


[**FIGURE 16.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0012) Links to related documentation are available on the deployment page.

![Snapshot of cloud Deployment Manager launching WordPress](../images/c16f013.png)


[**FIGURE 16.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0013) Cloud Deployment Manager launching WordPress

![Snapshot of information about the deployed WordPress instance](../images/c16f014.png)


[**FIGURE 16.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fig-0014) Information about the deployed WordPress instance

## Building Infrastructure Using the Cloud Foundation Toolkit

In addition to launching the solutions listed in Cloud Marketplace, you can create your own solution configuration files so that users can launch preconfigured solutions using Deployment Manager configuration files as well as Terraform-based specifications using the Cloud Foundation Toolkit. Terraform is an open source tool for specifying infrastructure as code. A third option, Config Connector, is available to those who want to manage Google Cloud resources using Kubernetes.

### Deployment Manager Configuration Files

Deployment Manager configuration files are written in YAML syntax. The configuration files start with the word resources, followed by resource entities, which are defined using three fields:

- `name`, which is the name of the resource.
- `type`, which is the type of the resource, such as compute.v1.instance.
- `properties`, which are key-value pairs that specify configuration parameters for the resource. For example, a VM has properties for specifying machine type, disks, and network interfaces.

---

![](../images/note_16.png) For information on YAML syntax, see the official documentation at `yaml.org`.

---

A simple example defining a virtual machine called `ace-exam-deployment-vm` starts with the following:

```
resources:
- type: compute.v1.instance name: ace-exam-deployment-vm
```

Next, you can add properties, such as the machine type, disk configuration, and network interfaces.

The properties section of the configuration file starts with the word `properties`. For each property, there is a single key-value pair or a list of key-value pairs. The machine type property has a single key-value pair, with the key being `machineType`. Disks have multiple properties, so following the word `disks`, there is a list of key-value pairs. Continuing the example of `ace-exam-deployment-vm`, the structure is as follows:

```
resources:
- type: compute.v1.instance name: ace-exam-deployment-vm
  properties:
     machineType: [MACHINE_TYPE_URL]
```

In this example, `machineType` would be a URL to a Google API resource specification, such as the following:

```
www.googleapis.com/compute/v1/projects/[PROJECT_ID]/zones/us-
central1-f/machineTypes/f1-micro
```

Note that there is a reference to *`[PROJECT_ID]`*, which you'd replace with an actual project ID in a configuration file. Disks have properties such as a `deviceName` and `type`, and Booleans indicating whether the disk is a boot disk or should be autodeleted. Let's continue the previous example by adding the machine type specification and some disk properties:

```
resources:
- type: compute.v1.instance name: ace-exam-deployment-vm
  properties:
     machineType: www.googleapis.com/compute/v1/projects/[PROJECT_ID]/zones/us-
central1-f/machineTypes/f1-micro disks:
     - deviceName: boot type: PERSISTENT
       boot: true autoDelete: true
```

[Listing 16.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fea-0001) shows the full configuration file from the Google Deployment Manager documentation. The following code is available at `https://cloud.google.com/deployment-manager/docs/quickstart` (source: `https://github.com/GoogleCloudPlatform/deploymentmanager-samples/blob/master/examples/v2/quick_start/vm.yaml`).

---

**[Listing 16.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fea-0001)**: examples/v2/quick\_start/vm.yaml

```
 # Copyright 2016 Google Inc. All rights reserved.#
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at
 #
 #     www.apache.org/licenses/LICENSE-2.0
 #
  # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
  
  
 # Put all your resources under 'resources:'. For each resource, you need:
 # - The type of resource. In this example, the type is a Compute VM instance.
 # - An internal name for the resource.
 # - The properties for the resource. In this example, for VM instances, you add
 #   the machine type, a boot disk, network information, and so on.
 #
 # For a list of supported resources,
 # see https://cloud.google.com/deployment-manager/docs/configuration/supported-resource-types
  
 resources:
 - type: compute.v1.instance name: quickstart-deployment-vm
   properties:
     # The properties of the resource depend on the type of resource. For a list of properties, see the API reference for the resource.
    zone: us-central1-f
    # Replace [MY_PROJECT] with your project ID machineType: www.googleapis.com/compute/v1/projects/[MY_PROJECT]/zones/us-central1-f/machineTypes/f1-micro
    disks:
    - deviceName: boot type: PERSISTENT
      boot: true autoDelete: true
      initializeParams:
        # Replace [FAMILY_NAME] with the image family name.
        # See a full list of image families at
        # https://cloud.google.com/compute/docs/images#os-compute-support sourceImage: www.googleapis.com/compute/v1/projects/debian-cloud/global/images/family/[FAMILY_NAME]
    # Replace [MY_PROJECT] with your project ID networkInterfaces:
    - network: www.googleapis.com/compute/v1/projects/[MY_PROJECT]/global/networks/default
      # Access Config required to give the instance a public IP address accessConfigs:
      - name: External NAT type: ONE_TO_ONE_NAT
```

---

This configuration specifies a deployment named `quickstart-deployment-vm`, which will run in the us-central1-f zone. The deployment will use a f1-micro virtual machine running a Debian distribution of Linux. An external IP address will be assigned.

Before executing this template, you would need to replace *`[MY_PROJECT]`* with your project ID and *[FAMILY\_NAME]* with the name of a Debian image family, such as debian-9. You can find a list of images in the Compute Engine section of Cloud Console on the Images tab. You can also list images using the `gcloud compute images list` command.

### Deployment Manager Template Files

If your deployment configurations are becoming complicated, you can use deployment templates. Templates are another text file you use to define resources and import those resources into configuration files. This allows you to reuse resource definitions in multiple places. Templates can be written in Python or Jinja2, a templating language.

---

![](../images/note_16.png) For information on Jinja2 syntax, see the official documentation at `http://jinja.pocoo.org/docs/2.10`.

---

As an Associate Cloud Engineer, you should know that Google recommends using Python to create template files unless the templates are relatively simple, in which case it is appropriate to use Jinja2.

### Launching a Deployment Manager Template

You can launch a deployment template using the `gcloud deployment-manager deployments create` command. For example, to deploy the template from the Google documentation, use the following:

```
gcloud deployment-manager deployments create quickstart-deployment -config=vm.yaml
```

You can also describe the state of a deployment with the `describe` command, as follows:

```
gloud deployment-manager deployments describe quickstart-deployment
```


---

### Providing a Deployable Service

In large enterprises, different groups often want to use the same service, such as a data science application, to understand customer purchasing patterns. Product managers across the organization may want to use this. Software developers could create a single instance of the application's resources and have multiple users work with that one instance. This is a co-hosted structure, which has some advantages if you have a single DevOps team supporting all users.

Alternatively, you could allow each user or small group of users to have their own application instance. This approach has several advantages. Users could run the application in their own projects, simplifying allocating charges for resources, since the project would be linked to the users' billing accounts. Also, users could scale the resources up or down as needed for their use case.

A potential disadvantage is that users may not be comfortable configuring Google Cloud resources. Deployment Manager addresses that problem by making it relatively simple to deploy an application and resources in a repeatable process. Someone who can run a `gcloud deployment-manager` command could deploy application resources similar to the way users deploy applications from Cloud Marketplace.

---

### Cloud Foundation Toolkit

The Cloud Foundation Toolkit is an open source project that provides infrastructure as code templates using Deployment Manager and Terraform templates.

The Cloud Foundation Toolkit includes blueprints, which are packages of deployable configuration specification as well as policies for implementing a solution to a particular class of problems. These blueprints encapsulate best practices for configuring infrastructure and granting access to resources. Blueprints are available for Terraform and Kubernetes. The Kubernetes blueprints are used with the Config Connector. For examples of blueprints, see `https://cloud.google.com/docs/terraform/blueprints/terraform-blueprints`.

In addition to blueprints that are designed for solving broad needs, such as deploying a data warehouse, templates are also available for configuring specific Google Cloud service resources. For example, [Listing 16.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#c16-fea-0003) shows a template for creating a virtual machine.

---

[**Listing 16.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c16.xhtml#R_c16-fea-0003) `https://github.com/terraform-google-modules/terraform-google-vm/blob/master/modules/compute_instance/main.tf`

```
 /**
  * Copyright 2018 Google LLC
  *
   * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  *
  *      www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */
 
 locals { hostname      = var.hostname == "" ? "default" : var.hostname
   num_instances = length(var.static_ips) == 0 ? var.num_instances : length(var.static_ips)
 
   # local.static_ips is the same as var.static_ips with a dummy element # appended
   # at the end of the list to work around "list does not have any elements # so cannot
   # determine type" error when var.static_ips is empty static_ips = concat(var.static_ips, ["NOT_AN_IP"])
   project_id = length(regexall("/projects/([^/]*)", var.instance:template))> 0 ? flatten(regexall("/projects/([^/]*)", var.instance:template))[0] : null
 
   # When no network or subnetwork has been defined, we want to use the # settings from
   # the template instead.
   network_interface = length(format("%s%s", var.network, var.subnetwork)) == 0 ? [] : [1]
 }
 
 ###############
 # Data Sources
 ###############
 
 data "google_compute_zones" "available" { project = local.project_id
   region  = var.region }
 
 #############
 # Instances
  #############
 
 resource "google_compute_instance:from_template" "compute_instance" { provider            = google
   count               = local.num_instances name                = var.add_hostname_suffix ? format("%s%s%s", local.hostname, var.hostname_suffix_separator, format("%03d", count.index + 1)) : local.hostname
   project             = local.project_id zone                = var.zone == null ? data.google_compute_zones.available.names[count.index % length(data.google_compute_zones.available.names)] : var.zone
   deletion_protection = var.deletion_protection
 
 
   dynamic "network_interface" { for_each = local.network_interface
 
     content { network            = var.network
       subnetwork         = var.subnetwork subnetwork_project = var.subnetwork_project
       network_ip         = length(var.static_ips) == 0 ? "" : element(local.static_ips, count.index)
       dynamic "access_config" { for_each = var.access_config
         content { nat_ip       = access_config.value.nat_ip
           network_tier = access_config.value.network_tier }
       }
 
       dynamic "alias_ip_range" { for_each = var.alias_ip_ranges
         content { ip_cidr_range         = alias_ip_range.value.ip_cidr_range
           subnetwork_range_name = alias_ip_range.value.subnetwork_range_name }
       }
     }
   }
 
   source:instance:template = var.instance:template }
```

---

### Config Connector

Config Connector is a Kubernetes add-on that allows you to manage Google Cloud resources through Kubernetes. This is useful for those who have already managed Kubernetes resources using Kubernetes configurations and want to extend the scope of those tools to include Google Cloud resources. Config Connector provides a collection of Kubernetes custom resource definitions (CRDs) and controllers for managing Google Cloud resources.

To install the Config Connector, you pass a parameter to the `gcloud container clusters create` command specifying the ConfigConnector add-on. For example:

```
gcloud container cluster create  ace-gke-cluster1 \
   --addons ConfigConnector
   --workload-pool=ace-project-dw1
   --logging=SYSTEM
   --monitoring=SYSTEM
```

To use Config Connector, you will have to enable Workload Identity, a way to link IAM identities to Kubernetes identities. You will also need to enable Kubernetes Engine monitoring and use a supported version of Kubernetes. Configurations of Config Connector are applied using `kubectl`.

For more on Config Connector solutions, see `https://github.com/GoogleCloudPlatform/cloud-foundation-toolkit/tree/master/config-connector/solutions`.

## Summary

Cloud Marketplace and Cloud Deployment Manager are designed to make it easy to deploy resources in Google Cloud. Cloud Marketplace is where third-party vendors can offer deployable applications based on proprietary or open source software. When an application is deployed from Cloud Marketplace, resources such as VMs, storage buckets, and persistent disks are created automatically without additional human intervention. Deployment Manager gives cloud engineers the ability to define configuration files that describe the resources they would like to deploy. Cloud engineers can then use `gcloud` commands to deploy the resources and list their status. Deployment Manager is especially useful in organizations where you want to easily deploy resources without requiring users of those resources to understand the details of how to configure Google Cloud resources.

The Cloud Foundation Toolkit provides templates and blueprints that encode best practices for deploying solutions and individual resources to Google Cloud. The Config Connector add-on to Kubernetes allows you to manage Google Cloud resources using Kubernetes.

## Exam Essentials

- **Understand how to browse for solutions using the Cloud Marketplace section of Cloud Console.**   You can use filters to narrow your search to specific kinds of solutions, such as operating systems and developer tools. There may be multiple options for a single application, such as WordPress. This is because multiple vendors provide configurations. Review the description of each to understand which best fits your needs.
- **Know how to deploy a solution in Cloud Marketplace.**   Understand how to configure a Cloud Marketplace deployment in Cloud Console. Understand that when you launch a solution, you may be prompted for application-specific configurations. For example, with WordPress you may be prompted to install phpMyAdmin. You may also have the opportunity to configure common configuration attributes, such as the machine type and boot disk type.
- **Understand how to use the Deployment Manager section of the console to monitor deployment.**   It may be a few minutes from the time you launch a configuration to the time it is ready to use. Note that once the application is ready, you may be prompted for additional information, such as a username and password to log in.
- **Know that Deployment Manager is a Google Cloud service for creating configuration files that define resources to use with an application.**   These configuration files use YAML syntax. They are made up of resource specifications that use key-value pairs to define properties of the resource.
- **Know that resources in a configuration file are defined using a name, type, and set of properties.**   The properties vary by type. The machine type can be defined using just a URL that points to a type of machine available in a region. Disks have multiple properties, including a device name, a type, and whether the disk is a boot disk.
- **Know that you can use templates with configuration files.**   If your configuration files are getting long or complicated, you can modularize them using templates. Templates define resources and can be imported into other templates. Templates are text files written in Jinja2 or Python.
- **Know how to launch a deployment configuration file using `gcloud deployment-manager deployment create.`**   You can review the status of a deployment using `gcloud deployment-manager deployments-describe`.
- **Know the purpose of Cloud Foundation Toolkit and Config Connector.**   Cloud Foundation Toolkit is an open source project with blueprints and example configurations that capture Google Cloud–recommended best practices for deploying solutions. Config Connector is a Kubernetes add-on for managing Google Cloud resources from Kubernetes.

## Review Questions

You can find the answers in the Appendix.

1. What are the categories of Cloud Marketplace solutions?
   1. Data sets only
   2. Operating systems only
   3. Developer tools and operating systems only
   4. Data sets, operating systems, and developer tools
2. You want to use Terraform for managing infrastructure as code and you would also like to follow Google Cloud–recommended best practices. What would you use to start implementing such a solution?
   1. Cloud Deployment Manager
   2. Cloud Foundation Toolkit
   3. Config Connector
   4. Cloud Build
3. Where do you navigate to launch a Cloud Marketplace solution?
   1. Overview page of the solution
   2. Main Cloud Marketplace page
   3. Network Services
   4. None of the above
4. You want to quickly identify the set of operating systems available in Cloud Marketplace. Which of these steps would help with that?
   1. Use Google Search to search the web for a listing.
   2. Use filters in Cloud Marketplace.
   3. Scroll through the list of solutions displayed on the start page of Cloud Marketplace.
   4. It is not possible to filter to operating systems.
5. You want to use Cloud Marketplace to deploy a WordPress site. You notice there is more than one WordPress option. Why is that?
   1. It's a mistake. Submit a ticket to Google support.
   2. Multiple vendors may offer the same application.
   3. It's a mistake. Submit a ticket to the vendors.
   4. You will never see such an option.
6. You have used Cloud Marketplace to deploy a WordPress site and would now like to deploy a database. You notice that the configuration page for the databases is different from the one used with WordPress. Why is that?
   1. It's a mistake. Submit a ticket to Google support.
   2. You've navigated to a different subform of Cloud Marketplace.
   3. Configuration properties are based on the application you are deploying and will be different depending on what application you are deploying.
   4. This cannot happen.
7. You have been asked by your manager to deploy a WordPress site. You expect heavy traffic, and your manager wants to make sure the VM hosting the WordPress site has enough resources. Which resources can you configure when launching a WordPress site using Cloud Marketplace?
   1. Machine type
   2. Disk type
   3. Disk size
   4. All of the above
8. You would like to define as code the configuration of a set of application resources. What is the Google Cloud service for creating resources using a configuration file made up of resource specifications defined in YAML syntax?
   1. Compute Engine
   2. Deployment Manager
   3. Marketplace Manager
   4. Marketplace Deployer
9. What file format is used to define Deployment Manager configuration files?
   1. XML
   2. JSON
   3. CSV
   4. YAML
10. A Deployment Manager configuration file starts with what word?
    1. `deploy`
    2. `resources`
    3. `properties`
    4. `YAML`
11. Which of the following are used to define a resource in a Cloud Deployment Manager configuration file?
    1. Type only
    2. Properties only
    3. Name and type only
    4. Type, properties, and name
12. What properties may be set when defining a disk on a VM?
    1. A device name only
    2. A Boolean indicating a boot disk and a Boolean indicating autodelete
    3. A Boolean indicating autodelete only
    4. A device name, a Boolean indicating a boot disk, and a Boolean indicating autodelete
13. You need to look up what images are available in the zone in which you want to deploy a VM. What command would you use?
    1. `gcloud compute images list`
    2. `gcloud images list`
    3. `gsutil compute images list`
    4. `gcloud compute list images`
14. You want to use a template file with Deployment Manager. You expect the file to be complicated. What language would you use?
    1. Jinja2
    2. Ruby
    3. Go
    4. Python
15. What command launches a deployment?
    1. `gcloud deployment-manager deployments create`
    2. `gcloud cloud-launcher deployments create`
    3. `gcloud deployment-manager deployments launch`
    4. `gcloud cloud-launcher deployments launch`
16. A DevOps engineer is noticing a spike in CPU utilization on your servers. You explain that you have just launched a deployment. You'd like to show the DevOps engineer the details of a deployment you just launched. What command would you use?
    1. `gcloud cloud-launcher deployments describe`
    2. `gcloud deployment-manage deployments list`
    3. `gcloud deployment-manager deployments describe`
    4. `gcloud cloud-launcher deployments list`
17. If you expand the More link in the Networking section when deploying a Cloud Marketplace solution, what will you be able to configure?
    1. IP addresses
    2. Billing
    3. Access controls
    4. Custom machine type
18. What are the license types referenced in Cloud Marketplace?
    1. Free only
    2. Free and flat hourly only
    3. Free and bring your own license (BYOL) only
    4. Free, flat hourly, usage fees, and bring your own license (BYOL)
19. Which license type will add charges to your Google Cloud bill when using Cloud Marketplace with this type of license?
    1. Free
    2. Flat hourly and usage fees
    3. BYOL
    4. Chargeback
20. You are deploying a Cloud Marketplace application that includes an LAMP stack. What software will this deploy?
    1. Apache server and Linux only
    2. Linux only
    3. MySQL and Apache only
    4. Apache, MySQL, Linux, and PHP