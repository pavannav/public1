# 4

# Implementing Compute Solutions – Google Compute Engine

The aim of this chapter is to familiarize ourselves with the implementation of various compute solutions.

We will cover the **Google Compute** **Engine** (**GCE**).

We will try to create each computing solution, in this and the upcoming chapters, by using the Cloud console and the command line with the **gcloud** CLI. We will learn how to edit and manage each specific resource. In our experience, which we gained by clearing the Associate Cloud Engineer exam twice, the compute solutions from the Google Cloud portfolio are some of the most important ones.

Let’s dive into the different compute solutions.

# Computing options

In the previous chapter, we had an overview of which compute solutions should be used and when. For the exam itself, we need to remember which solutions can be easily implemented based on the scenario, how much time we might need to do it, and how to estimate the total cost and choose the best solution accordingly.

# GCE

Let’s start with GCE, one of the core Google Cloud products.

The base resources for **virtual machines** (**VMs**) are a processor, memory, storage, and a network. We have many ways to configure VMs, based on our requirements and how to implement them, be it through the Cloud console, command line, or code implementation.

It might not come as a surprise to you that Google Cloud utilizes a hypervisor that is responsible for virtualization – hosting many virtual servers on one or more significant servers. Google Cloud uses a KVM-based hypervisor secured and hardened by Google itself: <https://cloud.google.com/blog/products/gcp/7-ways-we-harden-our-kvm-hypervisor-at-google-cloud-security-in-plaintext>.

Throughout the chapter, we will refer to a *VM* as an *instance*, so please do not be confused when we switch between the two phrases. Similarly, we will refer to **Google Compute Engine** as **GCE**.

## GCE machine families

Before we actually create our first GCE instance, it is important to learn about the different types of machines – so-called machine families.

Generally speaking, Google Cloud offers machine families for different types of workloads.

Here is the general summary of different machine families:

- **General-purpose**: This offers the best balance between price and performance for a wide range of tasks.
- **Compute-optimized**: This delivers the highest performance per core on Compute Engine and is specifically designed for compute-intensive workloads.
- **Memory-optimized**: This is perfect for tasks that require a large amount of memory, providing more memory per core compared to other machine families, with a maximum capacity of 12 TB of RAM.
- **Accelerator-optimized**: This is specifically tailored to massively parallelized **Compute Unified Device Architecture** (**CUDA**) compute workloads, such as **machine learning** (**ML**) and **high-performance computing** (**HPC**). This machine family is the optimal choice for workloads that require GPUs.

GCE machines are further classified by series and generation. For example, the N1 series is the older version of the N2 series. Typically, a higher generation or series indicates newer CPU platforms or technologies.

Every machine series has predefined machine types with a set of resources available for the VM. If that predefined machine type doesn’t meet your requirements, you can create a custom machine type.

Google Cloud offers several workload-based machine families:

- General-purpose workloads:
  - **E2**: Day-to-day computing at a lower cost. Typical use cases for E2 machine types can be low-traffic web servers, back office apps, containerized microservices, virtual desktops, and development and test environments.
  - **N2, N2D, and N1**: A balanced between price and performance. Typical use cases can be low- to medium-traffic web and application servers, containerized microservices, CRM applications, and data pipelines.
  - **C3**: Consistently high performance for a variety of workloads – high-traffic web and application servers, databases, in-memory caches, ad servers, game servers, data analytics, media streaming and transcoding, and CPU-based ML training.
  - **Tau T2D and Tau T2A**: Best per-core performance/cost for scale-out workloads. Typical use cases include scale-out workloads, web servers, media transcoding, large-scale Java applications, and containerized microservices.
- Compute-optimized:
  - **C2, C2D,** Ultra-high performance for compute-intensive workloads. Typical workloads include compute-bound workloads, high-performance web servers, game servers, ad servers, HPC, media transcoding, and AI/ML workloads.
- Memory-optimized:
  - **M3, M2,** and **M1**: The highest memory-to-compute ratios for memory-intensive workloads. Typical applications deployed include medium-to-extra-large SAP HANA databases, in-memory data stores such as Redis, simulations, high-performance databases such as Microsoft SQL Server or MySQL, and electronic design automation.
- Accelerator-optimized:
  - Optimized for accelerated HPC workloads. Typical workloads include CUDA-enabled ML training and inference, HPC, massively parallelized computation, natural language processing, the **deep learning recommendation model** (**DLRM**), video transcoding, and a remote visualization workstation.

To learn more details about each machine family, including a detailed description and the recommended settings for each type, visit the following URL: <https://cloud.google.com/compute/docs/machine-resource>.

Having learned about different machine families, we are now ready to start with our first GCE machine creation.

## Creating GCE

Let’s create a VM running Ubuntu Linux as the operating system.

### Console

1. In the Cloud console, open **Compute Engine** and click **CREATE INSTANCE**:

![Figure 4.1 – Creating an instance in the Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_01.jpg)

Figure 4.1 – Creating an instance in the Cloud console

1. We can now specify multiple options for the VM. Pick the instance name, and then choose the desired region and zone:

![Figure 4.2 – The first part of instance creation – an instance name and instance region with a zone__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_02.jpg)

Figure 4.2 – The first part of instance creation – an instance name and instance region with a zone

1. We have several options under **Machine family** in the **Machine configuration** section. We selected the **GENERAL-PURPOSE** type of the VM, and for the **Series** option, we selected **E2**:

![Figure 4.3 – The Machine configuration section with several machine family options to choose from__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_03.jpg)

Figure 4.3 – The Machine configuration section with several machine family options to choose from

1. Some more options from the **Machine family** section include **CPU platform**, **vCPUs to core ratio**, and **Visible** **core count**:

![Figure 4.4 – Optional configurations for the VM__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_04.jpg)

Figure 4.4 – Optional configurations for the VM

1. If the application on the VM instance requires a display device, you can enable this when creating the instance:

![Figure 4.5 – The Display device option when creating the VM__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_05.jpg)

Figure 4.5 – The Display device option when creating the VM

1. In the following sections, we can enable a confidential VM service, which allows us to encrypt VM memory by leveraging a **Virtual Trusted Platform Module** (**vTPM**). This feature is available only in a specific type of the VM – the N2D series type of VMs. You can deploy a container image to the VM instance if you wish:

![Figure 4.6 – Confidential VM service and container deployment options when creating the VM__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_06.jpg)

Figure 4.6 – Confidential VM service and container deployment options when creating the VM

1. In the **Boot disk** section, we have the freedom to choose any operating system available:

![Figure 4.7 – The Boot disk section from the new VM creation wizard__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_07.jpg)

Figure 4.7 – The Boot disk section from the new VM creation wizard

1. We changed the operating system to Ubuntu 20.04 LTS, and we selected the boot disk type as **SSD persistent disk**, with a size of **50** GB:

![Figure 4.8 – The boot disk, operating system selection, and boot disk type option with its size__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_08.jpg)

Figure 4.8 – The boot disk, operating system selection, and boot disk type option with its size

1. In the advanced configuration section, we can configure a deletion rule, encryption, a snapshot schedule, and custom device naming, as shown in the following screenshot:

![Figure 4.9 – Disk deletion rule and VM encryption options during VM creation__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_09.jpg)

Figure 4.9 – Disk deletion rule and VM encryption options during VM creation

1. On the **Identity and API access** screen, we can choose a service account and configure access scopes to Cloud APIs:

![Figure 4.10 – The Identity and API access configuration screen__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_10.jpg)

Figure 4.10 – The Identity and API access configuration screen

1. In the last section, **Firewall**, we can allow HTTP and HTTPS traffic in our newly created VM instance:

![Figure 4.11 – Allow HTTP/HTTPS firewall rules configuration screen__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_11.jpg)

Figure 4.11 – Allow HTTP/HTTPS firewall rules configuration screen

1. Further options, such as networking, disks, security, and sole tenancy, will be discussed later in this chapter. By clicking the **Create** button, we can create the VM. Next to the **Cancel** button, the **Equivalent Command-Line** button can help us learn the **gcloud** commands.
2. After a short period, **instance-1** will be successfully created, and it is reachable via the **Secure Shell** (**SSH**) protocol, as shown in the following screenshot:

![Figure 4.12 – A successful login to the instance via the SSH protocol__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_12.jpg)

Figure 4.12 – A successful login to the instance via the SSH protocol

### Command line

VM creation can be achieved using command-line tools. The equivalent of the previously described instance creation using Cloud Shell can be achieved using the following command line:

```
gcloud compute instances create instance-1 --project=wmarusiak-book-351718 --zone=europe-west1-b --machine-type=e2-medium --network-interface=network-tier=PREMIUM,subnet=default --maintenance-policy=MIGRATE --provisioning-model=STANDARD --create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20220419,mode=rw,size=50,type=projects/wmarusiak-book-351718/zones/europe-west1-b/diskTypes/pd-ssd
```

The preceding command specifies the following options:

- **--project**: The project in which we want to create the instance.
- **--zone**: The exact zone from the desired region.
- **--machine-type**: This can either be one of the pre-defined machine sizes (vCPU and RAM) or a custom one.
- **--network-interface**: This specifies the network tier and subnet.
- **--maintenance-policy**: This specifies what should happen with the VM if a maintenance event happens. **Migrate** causes live migration of a VM. **Terminate** stops a VM instead of migrating it.
- **--provisioning-model**: If you wish to use spot VMs, you should choose spot instead of a standard.
- **--create-disk**: This specifies what should happen with the instance disk when the instance deletion occurs. In this example, we can see the size of the disk as well as its type (HDD, SSD, or a balanced one).

The aforementioned options have multiple switches and allow for precise VM specification and configuration.

In the next section, we will edit the Google Compute instance to familiarize ourselves with options and command-line options.

## GCE management

Once an instance is created, we can start using it, install any application, and configure it to our needs. However, sometimes, we need to change some settings, add disks, or change the network to which our instance is attached.

For example, let’s start with some information about a running instance.

### The running VM inventory

The easiest way to find out the details of an instance is to navigate to the Cloud console and view its details.

#### Console

In the Cloud console, we can click on the desired instance and view various details about the instance.

We have visible four sections on the instance details page, which are listed as follows:

- **Details**: The screen that displays the main information. We can see basic information (name, instance ID, creation time, and so on) as well as machine configuration, disks, and networking information.
- **Observability**: Initial monitoring information about the instance, which is live-updated. By default, we see metrics such as CPU utilization and network traffic. It is possible to collect and visualize even more metrics by installing the **Ops Agent**.
- **Os Info**: This is a part of VM Manager, a suite of tools that can be used to manage operating systems at scale. It requires **OS Config Agent** and **VM Manager API** enablement to be installed on the instances. Once enabled, it displays information about available patches, vulnerabilities, and installed packages.
- **Screenshot**: This can be used to see a screenshot of the instance in the Cloud console, provided that the display device setting is enabled on the instance.

By viewing this information in the Cloud console, we can easily find details about the instance, its configuration, and possible issues.

#### Command line

Similar, if not even more, detailed information about an instance can be retrieved by executing the following command:

```
gcloud compute instances describe INSTANCE_NAME --zone=INSTANCE_ZONE
```

The output of this command is long and detailed, so we encourage you to run the command yourself and try to find information about the boot disk, image, instance type, and networking.

### Starting and stopping a VM

Let’s now focus on start and stop activities, which are a great introduction to working with the Cloud console and the **gcloud** command line. You might ask yourself, why do we need to stop an instance? If resources aren’t consumed, you don’t need to pay for them. Running instances that you don’t need might increase your bill significantly. This might not be the case if you have only two or three instances, but it might make a difference if you have hundreds or thousands of instances. Enterprises can stop development and acceptance instances that are needed only during working hours to save thousands of dollars.

#### Console

Once logged in to the Cloud console, in the **Compute Engine** section, select the desired GCE instance and click the **STOP** button:

![Figure 4.13 – Stopping the GCE instance using the Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_13.jpg)

Figure 4.13 – Stopping the GCE instance using the Cloud console

Similar to stopping the instance, we can start it by clicking on the **START / RESUME** button when it is selected:

![Figure 4.14 – Starting the GCE instance using the Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_14.jpg)

Figure 4.14 – Starting the GCE instance using the Cloud console

#### Command line

An instance can also be started by using the command line:

```
 gcloud compute instances start INSTANCE-NAME --zone=ZONE-NAME
```

Here’s an example – **gcloud compute instances start** **instance-1 --zone=europe-west1-b**.

To stop the instance, we need to execute the following command-line commandlet:

```
gcloud compute instances stop INSTANCE-NAME --zone=ZONE-NAME
```

Here’s an example – **gcloud compute instances stop** **instance-1 --zone=europe-west1-b**.

### Adding a public SSH key to a VM

GCE allows us to add SSH keys to Linux VMs during VM creation or to an existing VM. SSH keys are a popular way to administer Linux servers because they are more secure than passwords. Passwords can be easily guessed or stolen, but SSH keys are much more difficult to compromise. This makes SSH keys a more secure way to access Linux servers.

In addition, if the organization policy allows or configures it, it is possible to add a public SSH to project metadata to access all VMs in a project. This setting can be overridden during VM creation.

To learn more about creating SSH keys, visit the following link: <https://cloud.google.com/compute/docs/connect/create-ssh-keys#linux-and-macos>.

#### Console

To add an SSH key to a VM when it is created, we need to add it in the **NETWORKING, DISKS, SECURITY, MANAGEMENT,** **SOLE-TENANCY** section.

![Figure 4.15 – Advanced options available when creating the VM__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_15.jpg)

Figure 4.15 – Advanced options available when creating the VM

Once we open this menu and navigate to the **Security** option, we can click the **+ ADD ITEM** button and add the public SSH key:

![Figure 4.16 – The Security part of the advanced VM configuration](../images/B18851_04_16.jpg)

Figure 4.16 – The Security part of the advanced VM configuration

Once added, we can continue configuring VMs and creating them:

![Figure 4.17 – The SSH key added to the VM configuration during the creation process__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_17.jpg)

Figure 4.17 – The SSH key added to the VM configuration during the creation process

We could also add it later if the VM were created without SSH keys during the creation process.

Click on the instance name and use the edit button to add the SSH key:

![Figure 4.18 – The SSH key added to the running VM configuration__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_18.jpg)

Figure 4.18 – The SSH key added to the running VM configuration

Once the SSH key has been added, confirm the change by clicking the **Save** button.

The SSH key will be visible in the **DETAILS** section of the VM:

![Figure 4.19 – The SSH key added to running VM configuration visible in the instance details page__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_19.jpg)

Figure 4.19 – The SSH key added to running VM configuration visible in the instance details page

Now, let’s add the SSH keys using the command-line interface.

#### Command line

To create a VM and add the public SSH key to the instance metadata during the creation process, use the following command:

```
gcloud compute instances create VM_NAME --metadata=ssh-keys=PUBLIC_KEY
```

Once the VM has been created, we can update its metadata with the public SSH key using the following set of instructions:

1. First, we need to get the VM metadata. To do so, we need to use the following command:

   ```
   gcloud compute instances describe VM_NAME
   ```
2. Create an empty file, and add a username and key using the following format:

   ```
   USERNAME: KEY_VALUE
   ```
3. Save the file.
4. Use the following command line to update the instance metadata:

   ```
   gcloud compute instances add-metadata VM_NAME --metadata-from-file ssh-keys=KEY_FILE
   ```

The VM metadata will then be updated:

![Figure 4.20 – The SSH key added to the running VM configuration using the command line__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_20.jpg)

Figure 4.20 – The SSH key added to the running VM configuration using the command line

Once the changes are done, we can log in to the VM using SSH keys.

The next section focuses on deleting instances by using both the Cloud console and the **gcloud** command.

### Deleting a VM

Deleting a VM is a very straightforward process. Let’s try first to delete the VM in the Cloud console. In order to do that, you don’t have to stop the VM in advance; the deletion can be done while it is running.

#### Console

Select the VM from the list and then click on the three dots:

![Figure 4.21 – The three dots menu with the option to delete the VM__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_21.jpg)

Figure 4.21 – The three dots menu with the option to delete the VM

Choose **Delete** as an action, and then confirm the deletion process:

![Figure 4.22 – Confirmation of the VM deletion__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_22.jpg)

Figure 4.22 – Confirmation of the VM deletion

Once confirmed, the VM deletion process executes. Remember that this action can’t be stopped.

#### Command line

The deletion process using the command line is straightforward. Use the following command to initiate the deletion process in the command-line interface:

```
gcloud compute instances delete VM_name
```

With each **gcloud** command, it might be necessary to add the zone where the VM runs. You can append the zone to each **gcloud** command. Otherwise, you might be asked to specify a zone.

To specify a zone, use **--zone=us-central1-a** in your **gcloud** command.

You will be asked whether you wish to proceed, and then the process will start:

![Figure 4.23 – VM deletion using the command-line interface__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_23.jpg)

Figure 4.23 – VM deletion using the command-line interface

You can confirm that the instance has been deleted by executing the following command:

```
gcloud compute instances list
```

Once the command executes, you shouldn’t see the instance you wanted to delete.

### Adding a GPU to a VM

**Graphical Processing Units** (**GPUs**) can be added to the instances of a VM. GPUs can help render graphics-intensive workloads such as 3D visualization, 3D rendering, virtual applications, and ML computations. It is possible to add them to VMs to support those workloads.

Google Cloud offers many GPU platforms. The details can be found on this website: <https://cloud.google.com/compute/docs/gpus>.

To locate GPU models available in a specific region or zone, use the following link: <https://cloud.google.com/compute/docs/gpus/gpu-regions-zones>.

#### Console

Adding a GPU when a VM is created isn’t any different from creating a *normal* VM.

To add a GPU to the VM, choose the **GPU VM under Machine family**. Once selected, you can specify the VM type and choose the desired amount of vCPUs, RAM, and GPUs:

![Figure 4.24 – A GPU added to the VM during the creation process](../images/B18851_04_24.jpg)

Figure 4.24 – A GPU added to the VM during the creation process

Once the VM is created, you can check in the VM settings that the GPU has been added, and then you can start using it:

![Figure 4.25 – The VM with GPU added__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_25.jpg)

Figure 4.25 – The VM with GPU added

It is recommended to check the GPU quota in the desired region and increase it to meet your demands.

#### Command line

The following commandlet allows us to create a GPU-based VM:

```
gcloud compute instances create VM_NAME \
    --project PROJECT_ID \
    --zone us-central1-c \
    --machine-type a2-highgpu-1g \
    --maintenance-policy TERMINATE --restart-on-failure \
    --image-family centos-7 \
    --image-project centos-cloud \
    --boot-disk-size 200GB \
    --boot-disk-type pd-ssd
```

After creating the VM instance, installing the NVIDIA and CUDA drivers might be necessary in order to allow us to fully use the GPU’s power.

### Creating an instance template

An instance template is a resource that can be used to create individual instances or used in managed instance groups. It defines lots of information such as the machine type, the boot disk image, labels, start-up scripts, and other properties.

#### Console

The creation of an instance template is very similar to the creation of a single instance.

Please refer to the *Creating GCE section* for the details. The only difference between a single instance and a template is that the template is free and can be used with managed instance groups.

#### Command line

The command used to create an instance template differs from the one used to create a single instance:

```
gcloud compute instance-templates create INSTANCE_TEMPLATE_NAME
```

The instance-templates namespace has many switches and configuration options, so we highly recommend reading through the Cloud SDK reference and trying to make a one-instance template by using a command-line interface.

The following link describes the **gcloud** command switches and allows us to choose appropriate options to create an instance template: <https://cloud.google.com/sdk/gcloud/reference/compute/instance-templates/create>.

### Connecting remotely to a VM

Remote management of instances is a critical topic. It is not only complex but also important from a security point of view. We have all heard about big companies having their clouds hacked, so we should try to ensure that we access instances securely.

We will connect to two types of instances – Linux and Windows. We will access Linux instances using SSH keys (no username and password access) and the SSH protocol, which uses network port **22**. Windows Server instances can be accessed using a native protocol called **Remote Desktop Protocol** (**RDP**), which uses network port **3389**.

We must allow the required network port in the firewall table to access instances remotely. Firewalls will be discussed in more detail in upcoming chapters, but we must remember to allow network traffic in the VPC Firewall table to connect.

#### Bastion hosts

Bastion hosts are VMs that provide secure access to other VMs in a GCP network. They should be hardened to be more secure than other VMs in the network. This includes using strong passwords and SSH keys, keeping the software up to date, and disabling unnecessary services. The idea is to restrict their access to your on-premises networks or specific narrowed-down network ranges.

Sometimes, bastion hosts are called jump boxes or jump servers. Regardless of the name, the idea is the same. They are secure and allow you to access your cloud infrastructure.

To learn more about bastion hosts and how to securely connect to the Google Cloud instances, visit the following link: <https://cloud.google.com/solutions/connecting-securely>.

#### Identity-Aware Proxy

Although **Identity-Aware Proxy** (**IAP**) isn’t a part of the Associate Cloud Engineer exam, I’d like to introduce this Google Cloud product as something that’ll be a significant security improvement to your infrastructure.

IAP allows you to securely connect to your instances without a public IP address to both Linux and Windows operating systems. IAP provides a single point of control for managing users and access to systems with just HTTPS access, as can be seen in the following diagram (for more details, refer to <https://cloud.google.com/iap/images/iap-load-balancer.png>):

![Figure 4.26 – Access to VMs with IAP__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_26.jpg)

Figure 4.26 – Access to VMs with IAP

To learn more about IAP, visit the Google Cloud documentation: <https://cloud.google.com/iap/docs/concepts-overview>.

#### Linux instances

For our purposes, we will not use IAP or OS login, which is available to connect to Linux instances. Still, we encourage you to try to connect to both possibilities using both options.

#### **Console**

Instances can be accessed from within the Cloud console itself by using Cloud Shell or any other software of your preference available on your operating system.

The following screenshot shows the different ways to connect to a Linux instance:

![Figure 4.27 – A Linux instance with options to connect via SSH__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_27.jpg)

Figure 4.27 – A Linux instance with options to connect via SSH

We have many options on how we can connect to the instance. They are as follows:

- Open an SSH connection in the browser window
- Open an SSH connection in the browser window on a custom port
- Open SSH connection in the browser window using a provided private SSH key

The most straightforward connection can be achieved by clicking on the SSH button, and a new window will open where we have full access to the instance:

![Figure 4.28 – In the browser, an SSH connection to the instance__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_28.jpg)

Figure 4.28 – In the browser, an SSH connection to the instance

This connectivity is effortless to establish and use.

#### **Command line**

To access an instance from the Cloud Shell, we need to execute the following command:

```
gcloud compute ssh --zone "zone_name" "instance_name" --project "project_name"
```

The following screenshot shows that the connection to Cloud Shell using the **gcloud** command is very easy to establish.

![Figure 4.29 – An SSH connection to the instance from Cloud Shell__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_29.jpg)

Figure 4.29 – An SSH connection to the instance from Cloud Shell

As many SSH clients are available for many operating systems, it is impossible to cover them all in this book.

The following screenshot shows the SSH session established with the instance, using its public IP address and the PuTTY SSH client from the Windows operating system:

![Figure 4.30 – An SSH connection to the instance from Cloud Shell__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_30.jpg)

Figure 4.30 – An SSH connection to the instance from Cloud Shell

Connecting to instances is quite an important topic, and we strongly advise trying out connectivity via the SSH protocol.

#### Windows Server instances

Google Cloud allows us to use Windows Server images alongside Linux ones. Before initiating the RDP connection to the Windows Server-based instance, we need to change our initial password.

To do this, click on your Windows Server instance and choose **Set** **Windows password**:

![Figure 4.31 – Setting the Windows instance password__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_31.jpg)

Figure 4.31 – Setting the Windows instance password

You can either reset a password for the existing user or create a new user by typing a new username in the **Username** field:

![Figure 4.32 – The Set new Windows password screen__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_32.jpg)

Figure 4.32 – The Set new Windows password screen

After a moment, a new password for the specified user will be displayed:

![Figure 4.33 – The password for the user displayed in the console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_33.jpg)

Figure 4.33 – The password for the user displayed in the console

If the port TCP **3389** is open and the firewall rule is created, we can connect using the RDP client of our choice:

![Figure 4.34 – Connecting to the Windows Server instance__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_34.jpg)

Figure 4.34 – Connecting to the Windows Server instance

After a moment, we are connected to the instance:

![Figure 4.35 – Successful connection to the Windows Server instance via the RDP protocol__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_35.jpg)

Figure 4.35 – Successful connection to the Windows Server instance via the RDP protocol

Having Windows Server with a public IP and the RDP protocol exposed on the internet is a bad idea. This also applies to Linux servers and open SSH ports exposed on the internet.

The best solution is to restrict connectivity to your company, or use network IP ranges to minimize security breaches.

The best and most secure way to connect to our instances is to use IAP or bastion hosts, as described earlier in the chapter.

## GCE storage

An essential part of using Compute Engine is storage-related operations. It is impossible to cover all combinations of tasks, so we will list the most important ones that will help you gain practical knowledge and confidence when taking the Associate Cloud Engineer exam.

### GCE Storage options

Compute Engine offers several storage options for VM instances. Each of the following storage options has unique price and performance characteristics:

- Persistent Disk volumes provide high-performance and redundant network storage. Each Persistent Disk volume is striped across hundreds of physical disks:
  - By default, VMs use zonal persistent disks and store data on volumes located within a single zone, such as **us-west1-c**
  - It is also possible to create regional persistent disks, which synchronously replicate data between disks located in two zones and provide protection if a zone becomes unavailable
- Hyperdisk volumes offer the fastest redundant network storage for Compute Engine, with configurable performance and volumes that can be dynamically resized.
- Local SSDs are physical drives attached directly to the same server as your VM. They can offer better performance but are ephemeral.

Google Cloud has prepared a great overview of each storage option with information about minimum and maximum capacity, the scope of access, and maximum capacity per instance. To read in detail about each disk type, visit the following URL: <https://cloud.google.com/compute/docs/disks#introduction>.

### Adding a disk to a VM

We will start with one of the most straightforward tasks – adding an additional disk to an instance.

#### Console

In the Cloud console, we will start by adding an additional disk:

1. To add a disk to the existing instance, click on its name in the Cloud console.
2. Once the instance is selected, click **EDIT**:

![Figure 4.36 – Editing the instance in the Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_36.jpg)

Figure 4.36 – Editing the instance in the Cloud console

1. Navigate to the **Additional disks** section and choose to add a new disk. This will open a new window where we can create and attach a disk to the instance:

![Figure 4.37 – The Additional disks section in the EDIT section of the instance__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_37.jpg)

Figure 4.37 – The Additional disks section in the EDIT section of the instance

1. In the new window, we have many options to choose from:
   - **Name**: The name of the disk.
   - **Description**: We can describe what the purpose of the disk is or why we want to add it.
   - **Source**: This can be a blank disk, image, or snapshot.
   - **Disk type**: We have the following options: a balanced persistent disk, an extreme persistent disk, an SSD persistent disk, and a standard persistent disk. If you click the **Compare disk types** button, a comparison will help you choose the best disk based on the workload:

![Figure 4.38 – A table with a comparison of all available disk types in Google Cloud__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_38.jpg)

Figure 4.38 – A table with a comparison of all available disk types in Google Cloud

- **Size**: We can enter disk sizes between 10 and 65,536 GB.
- **Snapshot schedule**: If a snapshot schedule was previously created, we can use it to enable automatic snapshots on the disk we create.
- **Encryption**: Google Cloud allows us to pick from three encryption options – a Google-managed encryption key, a **customer-managed encryption key** (**CMEK**) where we leverage Google’s Cloud Key Management Service, and a **customer-supplied encryption key** (**CSEK**) where encryption keys are managed outside of Google Cloud.
- **Labels**: This allows us to organize projects and resources easily by adding key-value pairs to the resources – for example, we could label a newly added disk with a key and its value (e.g., key = department and value = infrastructure). Labels allow us to easily organize resources and use filters.
- **Disk attachment mode**: We can attach disks in read/write or read-only mode.
- **Deletion rule**: We can decide to keep the disk or delete it when we delete the instance that the disk is attached to
- **Device name**

1. Once all parameters are selected, click the **Save** button to attach the disk to the instance. This doesn’t mean that we can put files on it right away. There’s another step that involves formatting and mounting the disk in the operating system itself:

![Figure 4.39 – A new disk is added to the instance__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_39.jpg)

Figure 4.39 – A new disk is added to the instance

1. After a moment in the storage section of the VM, both disks (the boot disk) and the newly added disk are visible:

![Figure 4.40 – A new disk is visible in the instance configuration section__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_40.jpg)

Figure 4.40 – A new disk is visible in the instance configuration section

We will perform the same operation in the next section using the command-line interface.

#### Command line

The command-line interface consists of two steps. The first step is to create a disk, and the second is to attach it to the instance.

To create a disk, we will initiate the following command:

```
gcloud compute disks create additional-disk \
      --zone=europe-west1-b\
      --size=200GB \
      --type=pd-balanced
```

The next step is to attach the newly created disk to the instance:

```
gcloud compute instances attach-disk instance-1 \
  --disk additional-disk \
  --zone=europe-west1-b
```

The commands were executed successfully, and we can check whether the disk was attached by running the following command:

```
gcloud compute instances describe instance-1 --zone=europe-west1-b
```

The output of the **gcloud** command shows the disk attached to the instance, as shown here:

![Figure 4.41 – A new disk is visible in the instance by using the command line__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_41.jpg)

Figure 4.41 – A new disk is visible in the instance by using the command line

After learning how to add the additional disks to the instance, we will move on to the next section, which involves deleting the disk from the instances.

### Deleting a disk from a VM

We will now demonstrate how to remove a 10-GB disk from an instance using the Cloud console and command-line tools. We want to mention one crucial piece of information here – we can’t delete a disk attached to an instance.

#### Console

In the console, navigate to **Compute Engine**, click on the desired instance, and choose **Edit**.

Once the instance details load, scroll to the storage section and remove the additional disk from the instance by clicking the **X** button.

![Figure 4.42 – Removal of the additional disk from the instance by clicking the X button__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_42.jpg)

Figure 4.42 – Removal of the additional disk from the instance by clicking the X button

After clicking the **Save** button, the disk deletion is in progress. The deletion process depends on the setting in the deletion rule. When the disk is added, it can either be kept or deleted instantly.

#### Command line

Like adding a disk to the instance by using the command line, deleting the disk from the instance is a two-way process.

First, we need to edit the instance and detach the disk from it, and then we need to delete the detached disk.

In the command-line interface, we need to find the name of the disk device that we want to remove. Use the following command to find it out:

```
gcloud compute instances describe instance-1 --zone=europe-west1-b
```

The following screenshot shows the output of the preceding command:

![Figure 4.43 – The additional disk with its deviceName information__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_43.jpg)

Figure 4.43 – The additional disk with its deviceName information

With the information about the **deviceName** flag, we can initiate a command to detach it from the instance:

```
gcloud compute instances detach-disk instance-1 --zone=europe-west1-b --device-name=disk-3
```

After a short period, removing the disk from the instance is finished.

To completely delete the detached disk, we need to execute the following command:

```
gcloud compute disks delete deviceName
```

The following figure shows the output of the command:

![Figure 4.44 – The additional disk with its deviceName information__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_44.jpg)

Figure 4.44 – The additional disk with its deviceName information

Disk deletion was completed.

### Resizing a disk

A typical operation when working with instances is resizing a disk. We do it mainly when the disk is full and needs more capacity.

#### Console

To increase the disk size, we need to go to the storage section of the Cloud console and click **Disks**. Choose the desired disk you want to increase by clicking its name and then clicking on the three dots. Choose **EDIT** to increase the disk size:

![Figure 4.45 – Detailed information about the existing disk attached to the VM__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_45.jpg)

Figure 4.45 – Detailed information about the existing disk attached to the VM

Enter a new disk size and click **SAVE**:

![Figure 4.46 – Change of disk size in cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_46.jpg)

Figure 4.46 – Change of disk size in cloud console

After a moment, the disk size will be increased to the desired size. Remember that increasing the disk size in the Cloud console doesn’t update the filesystem in the instance itself. You must extend the filesystem itself to use increase the capacity.

#### Command line

To increase the disk size, we need to get its name first. Utilize the command from the task, Deleting a disk from a VM .

Once you have the disk name, use the following command to resize it:

```
gcloud compute disks resize DISK_NAME --zone=ZONE_NAME --size=XXXGB
```

One thing to remember is the disk size limit for instances. The size limit for a single disk is 65,536 GB, and the maximum capacity for a local SSD is 375 GB. The maximum storage capacity per instance is 257 TB and 9 TB for local SSDs.

### Creating an instance snapshot

An instance snapshot allows us to capture the state of a disk at a snapshot creation point in time. Snapshots can be used to go back in time to when a snapshot was created. Snapshots are the easiest feature to utilize if you want to revert to a different state quickly.

Snapshots use cases are as follows:

- Quickly reverting to the previous state of the disk
- Operating system patching
- Application patching
- Operating system changes

One important thing to remember is that snapshots aren’t a backup. Although they provide similar functionality, snapshots aren’t backups for the following reasons:

- Backups should be independent of the source VM
- Snapshots don’t provide a capability for granular restore options such as file restoration

Let’s create our first snapshot of the disk.

#### Console

In the Cloud console, navigate to **Snapshots** and click **Create** **a snapshot**.

We need to provide a name for the snapshot, (optionally) add a snapshot description, and choose a source disk:

![Figure 4.47 – The initial snapshot configuration section__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_47.jpg)

Figure 4.47 – The initial snapshot configuration section

We can use multi-regional or regional snapshot locations, add labels, choose encryption, and use application-consistent snapshots:

![Figure 4.48 – Section two of the snapshot creation__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_48.jpg)

Figure 4.48 – Section two of the snapshot creation

An application-consistent snapshot allows us to preserve application consistency and uses operating system features such as the **Volume Shadow Copy** (**VSS**) Service in Windows.

If you want a 100% consistent snapshot without any application or data corruption, we highly suggest powering off the instance before taking a snapshot.

In the last step, click **CREATE** to initiate snapshot creation. Remember that when creating a snapshot, we do so for just one selected disk:

![Figure 4.49 – Newly created snapshot visible on the Snapshots page__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_49.jpg)

Figure 4.49 – Newly created snapshot visible on the Snapshots page

After a moment, the snapshot of the disk is created and can be used. Snapshot creation can take from several seconds up to a few minutes. It depends on the size of the application, how large the disk is, and how **busy** the application is.

#### Command line

To perform a disk snapshot, we can run the following command:

```
gcloud compute snapshots create SNAPSHOT_NAME --source-disk=SOURCE_DISK_NAME --source-disk-zone=DISK_ZONE
```

![Figure 4.50 – A command-line snapshot is created__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_50.jpg)

Figure 4.50 – A command-line snapshot is created

Snapshot creation takes a moment.

After successfully creating the snapshot, we can proceed to delete snapshots.

### Deleting an instance snapshot

Deletion of the snapshot is a straightforward process.

#### Console

In the Cloud console, navigate to the **Snapshots** section of **Storage**. Select the desired snapshot and click **DELETE**:

![Figure 4.51 – Snapshot deletion in the Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_51.jpg)

Figure 4.51 – Snapshot deletion in the Cloud console

After clicking **DELETE SNAPSHOT**, the deletion takes place.

#### Command line

Before we can delete a snapshot, we need to know its name and refer to it in the command-line interface.

To list existing snapshots, we need to execute the following command:

```
gcloud compute snapshots list
```

Once we have a list of existing snapshots, we can delete them by executing the following command:

```
gcloud compute snapshots delete SNAPSHOT_NAME
```

The following screenshot shows the deletion of the snapshot:

![Figure 4.52 – A screenshot of the snapshot deletion__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_52.jpg)

Figure 4.52 – A screenshot of the snapshot deletion

As we see in the previous screenshot, the snapshot has been deleted and is no longer present.

### Creating an instance snapshot schedule

As we saw, manual snapshot creation works and can be done in the Cloud console and by using command-line tools. There is another possible method, which is to create a snapshot scheduler. This allows us to configure certain things, similar to when we use snapshots:

- The schedule location
- The snapshot location
- Frequency
- The deletion rule
- Application consistency
- Labels

Having the necessary information about the requirements, we can now proceed to create a snapshot schedule in the Cloud console.

#### Console

In the Cloud console, we need to add details to all the aforementioned necessary fields, and once the snapshot schedule is created, we need to add the disk that to the schedule:

![Figure 4.53 – Attaching a snapshot schedule to the disk__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_53.jpg)

Figure 4.53 – Attaching a snapshot schedule to the disk

Once the disk is added, the snapshot will be executed as per our configuration.

#### Command line

Similar to the Cloud console, we need to first create a snapshot schedule:

```
gcloud compute resource-policies create snapshot-schedule SCHEDULE_NAME --project=PROJECT_NAME --region=REGION_NAME --max-retention-days=XX --on-source-disk-delete=keep-auto-snapshots --daily-schedule --start-time=08:00 --storage-location=REGION_NAME
```

After creating the snapshot schedule, we need to attach it to the instance disk to utilize the feature. Use the following command to do so:

```
gcloud compute disks add-resource-policies DISK_NAME  --resourcepolicies=SCHEDULE_NAME --zone=ZONE_NAME
```

After initiating the command, the disk will be attached to a snapshot schedule.

### Creating an instance image

Custom images are the best solution if you want to reuse the fully preconfigured operating system with custom applications and settings. It is possible to create custom instance images from source disks, images, snapshots, or images stored in Cloud Storage and use these images to create VM instances.

#### Console

Let’s create a custom instance image based on the existing disk. We encourage you to test other image sources as well.

In the Cloud console, navigate to the **Disks** section in Compute Engine. Select the desired disk image used as the source image:

![Figure 4.54 – Choosing a disk as a base for a new custom image__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_54.jpg)

Figure 4.54 – Choosing a disk as a base for a new custom image

Before clicking **Create image**, it is recommended to stop the instance to guarantee that filesystem consistency is preserved. You can force image creation while the instance runs, but you must be aware of the possible consequences.

We need to provide the following information to create an image:

- **Name**
- **Source**: This can be a disk, snapshot, image, cloud storage file, or virtual disk in the VMDK or VHD format
- **Source Disk**
- **Location**: Multi-regional or regional
- **Family**
- **Labels**
- **Encryption**: This can be a Google-managed encryption key, a CMEK, or a CSEK

After a moment, the image is created, and then we can utilize this image to create new instances.

![Figure 4.55 – A newly created custom image, visible in the Images section of the Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_55.jpg)

Figure 4.55 – A newly created custom image, visible in the Images section of the Cloud console

Images can be imported and exported – both operations are available in the **Images** section.

#### Command line

We can run the following command snippet to create an image from the existing disk:

```
gcloud compute images create IMAGE_NAME --project=PROJECT_NAME --family=IMAGE_FAMILY_NAME --source-disk=SOURCE_DISK_NAME --source-disk-zone=SOURCE_DISK_ZONE --storage-location=STORAGE_LOCATION
```

Similar to the actions performed in the Cloud console, an image created from the disk is made after initiating the commands.

### Deleting an instance image

Deleting an instance image involves a few steps in the Cloud console and two stages in the command line.

#### Console

To delete an instance image in the **Images** section of Compute Engine, we need to select the desired image. Remember that it isn’t possible to delete the images provided by Google Cloud. We can only delete the images that we created.

To delete an image, select it and click **DELETE**:

![Figure 4.56 – Deletion of an image in the Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_56.jpg)

Figure 4.56 – Deletion of an image in the Cloud console

Image deletion takes a moment and cannot be reversed.

#### Command line

Before we can delete an image, we need to know its name. To list all images and omit the ones from Google Cloud, run the following command:

```
gcloud compute images list --no-standard-images
```

If we don’t use the –**no-standard-images** switch, we will receive a list of all images available.

To delete the image, execute the following command:

```
gcloud compute images delete IMAGE_NAME
```

On the command line, we will receive confirmation that the image is deleted. You can execute the previous command to list all the images again and check whether it is listed.

In the next section, we will perform network-related activities.

## The GCE network

Network-related activities are as important as overall management and storage activities – not only in real life when working with Google Cloud but also for the exam.

The following tasks represent Compute Engine networking activities. The upcoming chapter is dedicated to covering VPC, VPN, and Load Balancer networking resources.

### Configuring an instance with a static internal IP address

Reserving a static internal IP address before creating a VM is possible. Alternatively, we can create an instance with an ephemeral internal IP address and convert it in to a static internal IP address.

#### Console

To reserve a static internal IP address in the Cloud console, follow these steps:

1. Go to the VPC networks.
2. Choose the desired VPC network where you want to reserve a static internal IP address.
3. Click **STATIC INTERNAL IP ADDRESSES** and then **RESERVE** **STATIC ADDRESS**.
4. We need to enter the details for the following fields in the form:
   - **Name**
   - **Description**
   - **Subnet**: The subnet where we want to reserve the static IP address
   - **Static IP address**: Select to assign it automatically or manually
   - **Purpose**: Shared or non-shared

![Figure 4.57 – Reserving a static internal IP address__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_57.jpg)

Figure 4.57 – Reserving a static internal IP address

You have the option to choose a static IP address automatically, or you can enter it manually, and if you select the **Shared** option for the purpose, it can be shared by 50 frontends:

![Figure 4.58 – An example of reserved static IP addresses assigned automatically and manually__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_58.jpg)

Figure 4.58 – An example of reserved static IP addresses assigned automatically and manually

In Google Cloud, part of the network IP ranges is reserved. These reservations are essential for management.

The following is the list of used IPs from the network range:

- **Network**: The first address in the primary IP range for the subnet – for example, **10.11.12.0** in **10.11.12.0**/**24**
- **Default gateway**: The second IP address from the IP range – for example, **10.11.12.1** in **10.11.12.0**/**24**
- **Second-to-last-address**: the IP address reserved by Google Cloud for potential future use – for example, **10.11.12.254** in **10.11.12.0**/**24**
- **Broadcast**: The last address from the IP range – for example, **10.11.12.255** in **10.11.12.0**/**24**

To learn more about IP ranges in Google Cloud, visit the following link: <https://cloud.google.com/vpc/docs/subnets#ip-ranges>.

Reserving the static IP address is just the first part of configuring the instance with this IP. We need to go to the end of instance settings and change the IP address from **Ephemeral** to a previously created one:

![Figure 4.59 – Adding a static IP address to the running instance__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_59.jpg)

Figure 4.59 – Adding a static IP address to the running instance

Once this task is done, your instance will have the static internal IP you previously configured.

### Configuring the instance with the static external IP address

External IP address configuration is an essential piece of instance configuration. If you host a website or application or point it to the external domain name, it is desired to have a configured static IP address.

Once the instance is created with an external IP address, it is ephemeral. When your instance runs, it might have an IP address of **35.210.248.81**, but it might be different after stopping it and starting again.

Therefore, for such use cases, we should reserve external IP addresses.

#### Console

In the **VPC** section of the Cloud console, we can reserve an external static IP address:

![Figure 4.60 – The VPC section where the static external IP address can be configured__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_60.jpg)

Figure 4.60 – The VPC section where the static external IP address can be configured

Once we click the **RESERVE EXTERNAL STATIC ADDRESS** button, we are navigated to a new page where we can provide information about the IP address.

![Figure 4.61 – The external static IP address reservation page__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_61.jpg)

Figure 4.61 – The external static IP address reservation page

Once the **RESERVE** button is clicked, the IP address starts creating.

To attach the newly created external IP address to the running instance in the IP addresses section, we need to click the **Attach to** dropdown and select the desired instance:

![Figure 4.62 – The external static IP address attached to an instance__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_62.jpg)

Figure 4.62 – The external static IP address attached to an instance

After a moment, IP address assignment to the running instance is completed.

#### Command line

To make the external static IP address reservation, we will use the **gcloud** command:

```
gcloud compute addresses create ADDRESS_NAME --region=REGION_NAME --subnet=SUBNET --addresses=IP_ADDRESS
```

Once the IP address is created, we can change the instance’s configuration to use the newly created IP address.

The process requires us to get the instance details, remove the **accessConfigs** section of the instance, and then update the config with the new IP address.

To retrieve accessConfigs, we run the **gcloud** command:

```
gcloud compute instances describe VM_NAME
```

![Figure 4.63 – The output of gcloud compute instances describes VM_NAME, with a focus on the accessConfigs section where the IP address is defined__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_63.jpg)

Figure 4.63 – The output of gcloud compute instances describes VM\_NAME, with a focus on the accessConfigs section where the IP address is defined

Before we can add a new accessConfigs section, we need to delete the existing one using the following command:

```
gcloud compute instances delete-access-config VM_NAME --access-config-name="ACCESS_CONFIG_NAME"
```

The following screenshot shows the removal of the accessConfigs section from the instance:

![Figure 4.64 – accessConfig has been removed from the instance__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_64.jpg)

Figure 4.64 – accessConfig has been removed from the instance

Once the accessConfigs section is deleted, the previously associated IP address is removed. To attach the IP address, we need to use the following command:

```
gcloud compute instances add-access-config INSTANCE_NAME --access-config-name="ACCESS_CONFIG_NAME" --address=ADDRESS_IP
```

Replace **ADDRESS\_IP** with the actual IP address and not its name. We used the following command to attach the external IP to our instance:

```
gcloud compute instances add-access-config instance-1 --access-config-name="External Static IP" --address=35.210.248.80
```

After a moment, the instance gets a new external IP address:

![Figure 4.65 – The instance with a new external static IP__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_65.jpg)

Figure 4.65 – The instance with a new external static IP

IP addresses in Google Cloud have the following essential characteristics:

- Used IPs can be version 4 and version 6
- There are two network tiers – a premium and a standard one
- IPs can be global and regional

We will discuss the networking section in upcoming chapters, but if you wish to learn more about network tiers, you can visit the Google Cloud documentation: <https://cloud.google.com/network-tiers/docs/overview>.

### Changing an instance network

Google Cloud allows changes to the networking configuration of instances. Possible permitted modifications are as follows:

- From a legacy network to a VPC network in the same project
- From one VPC network to another VPC network in the same project
- From one subnet of a VPC network to another subnet of the same network
- From a service project network to the shared network of a shared VPC host project

All those actions must be performed when the instance is powered off, and it cannot be a part of a **managed instance group** (**MIG**) or **network endpoint** **group** (**NEG**).

#### Console

After stopping the VM instance, we need to edit its configuration. In the networking section, we need to perform network adjustments, as shown in the following screenshot:

![Figure 4.66 – Changing the VM instance network settings__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_66.jpg)

Figure 4.66 – Changing the VM instance network settings

In our case, we switched the instance to a different VPC in the same project.

#### Command line

The changes made through the console can also be done via the command line.

We need to stop the VM instance first:

```
gcloud compute instances stop INSTANCE_NAME --zone=ZONE_NAME
```

Once the instance is stopped, we can update its configuration:

```
gcloud compute instances network-interfaces update INSTANCE_NAME --zone=ZONE_NAME --network-interface=NIC --network=NETWORK_NAME --subnetwork=SUBNET_NAME
```

After a moment, the instance configuration is changed to the desired network.

This last activity concludes the networking-related activities. Those activities are vital to successfully managing Google Cloud and passing the ACE exam.

## MIGs

An MIG is a group of VM instances treated as a single entity.

There are two kinds of instance groups to choose from:

- MIGs, which allow us to use applications on identical VM instances automatically
- Unmanaged instance groups, which allow us to load balance applications across instances managed by ourselves

There are many scenarios where an MIG can be used:

- Stateful applications or batch workloads
- Stateless batch or high-performance compute workloads
- Stateless workloads such as hosting a website

The following diagram illustrates the concept of an MIG with a Load Balancer:

![Figure 4.67 – A simplified view of Load Balancing with an MIG__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_67.jpg)

Figure 4.67 – A simplified view of Load Balancing with an MIG

The previous diagram shows simplified load balancing where an MIG receives network traffic from the Internet

There are several advantages of using MIGs:

- **High availability**: An MIG supports regional/multi-zone deployment. If there is zone failure, the application can still be served from the unaffected zone. One essential aspect is the load-balancing option for the application. Various load-balancing options with Cloud Load Balancing are supported with MIGs.
- **Scalability**: An MIG supports automatic scaling based on various metrics, so you no longer need to add servers manually. When the load on the servers is increased, more instances are added. When the load decreases, instances are automatically deleted.
- **Automated patching**: Whenever an application or configuration is changed, we have the option to update the underlying infrastructure. This allows for faster application shipment and updates.
- **Auto healing**: Instances in a group are monitored, and whenever an instance crashes, stops responding, or is deleted, it will be automatically replaced by a new instance from the template. Various health checks are available in the MIG and can be combined with Cloud Load Balancing health checks.

If your application or workload is stateless, you can benefit from using preemptible/spot instance VMs and lower your bill significantly.

### Console

Let’s create an MIG. To do so, we need the following items:

- **An instance template**: We created one in this chapter. Create a new one or reuse a previously created one. We also need an application that is configured.
- **A firewall rule** to allow access to the application.

In the Cloud console, navigate to Compute Engine and the **Instance** **groups** section:

1. Click **Create** **Instance Group**.
2. We need to provide details about our MIG:
   - **Name**
   - **Description** (optional)
   - **Instance template**

![Figure 4.68 – The initial configuration section of the MIG__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_68.jpg)

Figure 4.68 – The initial configuration section of the MIG

In the location section, we can choose single or multiple zones. If a single zone is selected, a target distribution shape is not possible. We have the option of **Even**, **Balanced**, and **Any**. Choose the desired configuration option:

![Figure 4.69 – The MIG in a multiple-zone configuration__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_69.jpg)

Figure 4.69 – The MIG in a multiple-zone configuration

1. In the **Autoscaling** section, we can use autoscaling mode. We can choose from **On**, **Scale out**, and **Off**:

![Figure 4.70 – Autoscaling options__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_70.jpg)

Figure 4.70 – Autoscaling options

1. There is also an option to define the minimum and maximum number of instances:

![Figure 4.71 – Autoscaling mode with possibility to configure minimum and maximum amount of instances__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_71.jpg)

Figure 4.71 – Autoscaling mode with possibility to configure minimum and maximum amount of instances

In the **Autoscaling metrics** section, we can choose when the autoscaling event happens. As the metric type, we can choose from either **HTTP load balancing utilization** or **Cloud Monitoring metric** under**CPU utilization**:

![Figure 4.72 – Autoscaling metrics__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_72.jpg)

Figure 4.72 – Autoscaling metrics

1. In the cool-down section, we can specify how long it takes for the application to initialize from boot time until it is ready to serve. This is a critical section, as some applications take a moment to start. If the application start exceeds the cool-down period, your monitoring metrics might detect that the application doesn’t work and initiate an autoscaling event, deleting the monitored instance. We want to avoid this situation, and it is a general best practice to measure the application startup.
2. To better define scale-in controls, we can enable additional settings, as shown in the following screenshot:

![Figure 4.73 – Autoscaling metrics__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_73.jpg)

Figure 4.73 – Autoscaling metrics

1. In the **Autohealing** section, we can create detailed health checks for our application:

![Figure 4.74 – The Health Check configuration__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_74.jpg)

Figure 4.74 – The Health Check configuration

1. The last section of the MIG is the **Port mapping** section. It is used to map the incoming traffic to a specific port number, together with HTTP load balancing:

![Figure 4.75 – The Port mapping options__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_75.jpg)

Figure 4.75 – The Port mapping options

It might take a moment to create all instances, depending on the number of instances configured. You can check how many of them have been made in the **Number of** **instances** section:

![Figure 4.76 – Managed instance group created and ready for usage__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_76.jpg)

Figure 4.76 – Managed instance group created and ready for usage

In the **DETAILS** section, we can see the template information, update the parameters, and configure many options.

### Command line

We need three steps to achieve the same configuration we did using the Cloud console.

The first section creates an MIG based on a pre-configured template:

```
gcloud beta compute instance-groups managed create INSTANCE_GROUP_NAME --project=PROJECT_NAME --base-instance-name=INSTANCE_GROUP_NAME --size=MINIMUM_SIZE --template=TEMPLATE_NAME --zones=ZONE_NAME_X,ZONE_NAME_Y,ZONE_NAME_z --target-distribution-shape=EVEN
```

To create a named port, we need to execute the following command:

```
gcloud compute instance-groups managed set-named-ports INSTANCE_GROUP_NAME --project=PROJECT_NAME --region=REGION_NAME named-ports=port:80
```

In the last section, we configure the autoscaling policy for our MIG:

```
gcloud beta compute instance-groups managed set-autoscaling INSTANCE_GROUP_NAME --project=PROJECT_NAME --region=REGION_NAME --cool-down-period=COOL-DOWN-PERIOD-IN-MIN --max-num-replicas=MAX_REPLICAS --min-num-replicas=MIN_REPLICAS --mode=on --target-cpu-utilization=0.6 --scale-in-control=max-scaled-in-replicas-percent=10,time-window=600
```

In the next section, we will cover the autoscaling options for the existing running MIG.

### Autoscaling

Autoscaling settings are visible in the **Details** section of the MIG:

![Figure 4.77 – Autoscaling information in the MIG__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_77.jpg)

Figure 4.77 – Autoscaling information in the MIG

To change the autoscaling setting, we need to click the **EDIT** button, and then we will be redirected to the configuration window. It looks the same as when we created the MIG. If you wish, you can change the settings and confirm so by clicking the **SAVE** button:

![Figure 4.78 – The autoscaling changes for the MIG in the Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_78.jpg)

Figure 4.78 – The autoscaling changes for the MIG in the Cloud console

After clicking the **SAVE** button, the changes will be applied immediately to the MIG:

![Figure 4.79 – A new instance is created after updating the autoscaling settings__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_79.jpg)

Figure 4.79 – A new instance is created after updating the autoscaling settings

The preceding screenshot shows the newly added example after changing the autoscaling settings.

In this section, we covered many topics about VM instances. We learned how to create a new instance, update its configuration, create snapshots, and create MIGs. The following section will focus on logging and monitoring agents and how to install them, and viewing base monitoring metrics.

## Cloud logging and monitoring agents

Google Cloud’s operations suite offers two monitoring agents:

- **Ops Agent**: The primary and preferred agent to collect metrics and logs
- **Legacy Monitoring agent**: Like Ops Agent, this can gather metrics from the supported operating systems but shouldn’t be used for new deployments

Google’s Ops Agent is a unified telemetry agent that uses Fluent Bit to collect logs and OpenTelemetry to collect metrics.

Fluent Bit is an open source log collector that is used to collect and process logs from a variety of sources. OpenTelemetry is an open source project that provides a unified way to collect telemetry data from applications and services.

By using Fluent Bit and OpenTelemetry, the Ops Agent can collect both logs and metrics from your applications and services. This data can then be used to monitor the health and performance of your applications, troubleshoot problems, and identify performance bottlenecks.

### Installing the Ops Agent

The Ops Agent can be installed on many Linux- and Windows-based operating systems.

A complete and up-to-date list is available on the website, and installation will differ depending on the operating system: <https://cloud.google.com/stackdriver/docs/solutions/agents/ops-agent#linux_operating_systems>.

In this example, we will focus on installing Ubuntu Server 20.04.4 LTS:

1. To install the latest version of the Ops Agent, we need to run the following command:

   ```
   curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh sudo bash add-google-cloud-ops-agent-repo.sh --also-install
   ```

Installation takes a moment, and after a while, in the monitoring section of the Cloud console, the Ops Agent will be detected:

![Figure 4.80 – The monitoring and logging Ops Agent installation was successful__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_80.jpg)

Figure 4.80 – The monitoring and logging Ops Agent installation was successful

To view the detailed metrics and logs from the instance, we need to click on its name:

![Figure 4.81 – The logging view of an instance with the Ops Agent installed__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/B18851_04_81.jpg)

Figure 4.81 – The logging view of an instance with the Ops Agent installed

This concludes the installation of the Ops Agent on a Linux server. In the upcoming chapters, we will learn much more about logging and monitoring in Google Cloud.

# Summary

Understanding GCE takes some time. We covered many topics, from the simplest one, VM creation, to the creation of an MIG. In between, we added and removed disk to instances and created snapshots, which aren’t a backup solution but can be used if something happens and we need to roll back to the previous state of the instance quickly. We briefly touched on the networking of Compute Engine, which will have a dedicated chapter. We ended the chapter by installing cloud logging and monitoring agents, which is important in conjunction with MIGs and autoscaling.

In the next chapter, we will abstract VMs and move up the logical layers, where Kubernetes and Google Kubernetes Engine will play a leading role.

# Questions

Answer the following questions to test your knowledge of this chapter:

1. You are deploying a production application on GCE and want to prevent anyone from deleting the data stored on its disk. How can you achieve this?
   1. Disable automatic restart on the instance.
   2. Disable perceptibility on the instance.
   3. Enable the **Delete boot disk when the instance is** **deleted** flag.
   4. Enable delete protection on the instance.
2. You are tasked to create a GCE instance using a command-line interface. What is the next step after creating a Google Cloud project?
   1. Create a VPC in the project.
   2. B. Grant yourself the Compute Admin IAM role.
   3. Configure an organizational policy.
   4. Enable the Google Compute API.
3. Your project and all its resources are deployed in the **europe-west4** region. You want to set the europe-west4 region as the default region for the **gcloud** command-line tool. How can you achieve this?
   1. It is not possible to set the default value of a region.
   2. B. Use the **gcloud** config set compute/region europe-west4.
   3. Use the **gcloud** config set compute/zone europe-west4.
   4. Use Cloud Shell where the region is predefined.
4. You were tasked to create a VM named **cloud-server-1** with four CPUs. Which of the following commands would you use to create the VM **cloud-server-1**?
   1. **gcloud compute instances create --****machine-type=n1-standard-4 cloud-server-1**
   2. **gcloud compute instances create --****cpus=4 cloud-server-1**
   3. **gcloud compute instances create --****machine-type=n1-4-cpu cloud-server-1**
   4. **gcloud compute instances create --machine-type=n1-standard-4 –****instancename cloud-server-1**
5. You created a new Linux instance on GCE. It is up and running, its status in the Cloud console is green, and it has assigned both internal and external IPs, but you still can’t access it via the SSH protocol. What might be the possible issue? (Choose two answers):
   1. Check whether an SSH key has been added to the instance.
   2. Check whether the firewall rule has been created with port **22** and the TCP protocol has been created and assigned to the instance.
   3. Check whether the firewall rule has been created with port **22** and the UDP protocol has been created and assigned to the instance.
   4. Check whether the VPC network has been created.
6. You have deployed multiple Linux and Windows VM instances, and you have been tasked by your company’s security team to access those instances using RDP and the SSH protocol. The security team forbids you to use publicly available IP addresses. Which solution can you use?
   1. Create a self-signed certificate and attach it to both Linux and Windows instances.
   2. Configure a Cloud IAP for HTTPS resources.
   3. Create an SSH key pair and add the public key to all instances.
   4. Configure a Cloud IAP for SSH and TCP resources.
7. As a cloud engineer, you have been tasked to deploy an application that must scale easily, be highly available, and be deployed as a VM. Which Google Cloud Engine feature will help you achieve those requirements?
   1. An instance image
   2. An MIG
   3. An instance with an internal load balancer
   4. An instance snapshot
8. Your manager asks you to prepare a list of all instances created in Google Cloud. Which **gcloud** command would you use to perform this task?
   1. The **gcloud** compute instance list
   2. The **gcloud** instances list
   3. The **gcloud** compute instances list
   4. The **gcloud** instance describe
9. An application owner contacts you to say that his server is running out of disk space. Which command will you use to increase the VM disk size by 50 GB?
   1. **gcloud compute disks resize server1-disk1 --****zone=europe-west1a --size=50GB**
   2. **gcloud compute disk upgrade server1-disk1 --****zone=europe-west1a --size=50GB**
   3. **gcloud disks resize server1-disk1 --****zone=europe-west1a --size=50GB**
   4. **gcloud computes disks server1-disk1 --zone=europe-west1a --****size=50GB upgrade**
10. A new team member is responsible for creating snapshots of VMs. Which role do you need to assign to his account following the principle of least privilege?
    1. Storage instance admin
    2. Compute snapshot admin
    3. Compute storage admin
    4. Compute admin
11. Your manager asks you to optimize cloud expenditure by shutting down development and test environment VMs that only used 8x5. How can you simply achieve this task?
    1. Create a snapshot of VMs and start and stop them manually.
    2. Write a script that automates the start and stops of the VMs.
    3. Attach a startup and shutdown script to all VMs.
    4. Create an instance schedule and attach it to desired VMs.
12. Which parameters can be used to scale an instance group up and down?
    1. Average CPU utilization
    2. An HTTP load balancing serving capacity, which can be based on either utilization or requests per second
    3. Cloud Monitoring metrics
    4. All of the preceding
13. The **cloud-server1** VM that you use daily is slow and sluggish. Which **gcloud** command would you use to reboot it?
    1. **gcloud computes instance** **reset cloud-server1**
    2. **gcloud instances reset cloud-server1 –****region europe-west4**
    3. **gcloud instance compute** **reset cloud-server1**
    4. **gcloud compute instances** **reset cloud-server1**
14. Which Google Compute resource can be the source of an image?
    1. Snapshots and disks only
    2. Disks only
    3. Disk, snapshots, or other images
    4. Disks and instance templates
15. You work for a genomics company planning to conduct data analysis on around 100 TB of data. The data analysis would require 360 vCPUs and 240 GB of RAM. You need to recommend the cheapest option to conduct the research. Which of the following Google Cloud resources would you use?
    1. Preemptible instances
    2. Cloud Functions
    3. A committed use discount
    4. Sustained use discounts
16. Your colleague has been asked to increase the disk size on one of the servers by 200 GB. Accidentally, he increased it by 2,000 GB. He tried to downgrade the disk size but claimed he could not do it. What is the reason why?
    1. A VM disk can only be downgraded when the VM is powered off.
    2. A disk downgrade can be done only via a **gcloud** command or API request.
    3. You need to delete the VM snapshot first.
    4. It is not possible to downgrade the disk.
17. Which command would you use to delete an instance and preserve its disk boot?
    1. **gcloud compute instances delete** **cloud-server1 –keep-disks=boot**
    2. **gcloud disks delete** **cloud-server1 -keep-disks=boot**
    3. **gcloud compute instances delete** **cloud-server1 -keep-disks=boot**
    4. **gcloud delete compute instance** **cloud-server1 –keep-disks=boot**
    5. **gcloud compute instances delete** **cloud-server1 -keep-disks=all**
18. An application server runs on Compute Engine in the europe-west4-a zone. You must replicate the server to the europe-west6-c zone using the fewest steps possible. What should you do?
    1. Create a snapshot from the disk. Create a disk from the snapshot in the europe-west6-c zone and create a new VM from that disk.
    2. Copy the disk by using the **gcloud** command to the europe-west6-c zone. Create a new VM with that disk.
    3. Use the **gcloud compute instances disk clone server1-disk europe-west6-c** command to clone the disk.
    4. Create a template from the disk. Create a new disk from the template in the europe-west6-c zone, and then create a new VM from that disk.
19. Which command would you use to connect to the Compute Engine instance with a publicly available IP address, **30.40.50.60**, from Cloud Shell?
    1. **gcloud connect** **ssh username@30.40.50.60**
    2. **gcloud compute** **ssh username@30.40.50.60**
    3. **gsutil compute connect** **ssh username@30.40.50.60**
    4. **gcloud connect compute** **ssh username@30.40.50.60**
    5. None of the preceding
20. Which permissions are needed to manage SSH keys on a project when setting project-wide metadata to access an instance if the OS login doesn’t work? (Choose two):
    1. **iam.configuresshMetadata.allInstances**
    2. **iam.serviceAccounts.actAs**
    3. **compute.instance.configureMetadata**
    4. **compute.projects.setCommonInstanceMetadata**

# Answers

The answers to the preceding questions are provided here:

1C, 2D, 3B, 4A, 5AB, 6D, 7B, 8C, 9A, 10C, 11D, 12D, 13D, 14C, 15A, 16D, 17A, 18A, 19B, 20BD