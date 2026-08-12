---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **1.3 Installing and configuring the command line interface (CLI), specifically Cloud SDK (e.g., setting the default project)**
- **2.2 Planning and configuring compute resources. Considerations include:**
  - Selecting appropriate compute choices for a given workload (e.g., Compute Engine, Google Kubernetes Engine, Cloud Run, Cloud Functions)
  - Using preemptible VMs and custom machine types as appropriate

---

In this chapter, you will learn about Google Cloud Console, a graphical user interface for working with Google Cloud. You will learn how to install Google Cloud SDK and use it to create virtual machine instances and how to use Cloud Shell as an alternative to installing Google Cloud SDK locally.

## Creating and Configuring Virtual Machines with the Console

Let's create a VM in Compute Engine. We have three options for doing this: we can use Google Cloud Console, the Google Cloud Software Development Kit (SDK), or Google Cloud Shell. Let's start with the console.

Google Cloud Console is a web-based graphical user interface (GUI) for creating, configuring, and managing resources in Google Cloud. In this chapter, we will use it to create a VM.

To open the console, navigate in your browser to `https://console.cloud.google.com` and log in. [Figure 5.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0001) shows an example of the main form in the console.

In the console, Select A Project option to display the existing projects. You can also create a new project from this form, as shown in [Figure 5.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0002).

After you select an existing project or create a new project, you can return to the main console panel. The first time you try to work with a VM you will have to create a billing account if one has not already been created.

Click Enable Billing if prompted and fill in the billing information, such as name, address, and credit card. Once billing is enabled, you can navigate to the Compute Engine console page (see [Figure 5.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0003)).

![Snapshot of the main starting form of Google Cloud Console](../images/c05f001.png)


[**FIGURE 5.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0001) The main starting form of Google Cloud Console

![Snapshot of the Project form lets you choose the project you want to work with when creating VMs. You can also create a new project here.](../images/c05f002.png)


[**FIGURE 5.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0002) The Project form lets you choose the project you want to work with when creating VMs. You can also create a new project here.

![Snapshot of the starting panel for creating a VM](../images/c05f003.png)


[**FIGURE 5.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0003) The starting panel for creating a VM

Click the Create Instance button at the top of the panel to bring up a VM configuration, as shown in [Figure 5.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0004).

### Main Virtual Machine Configuration Details

Within the console, you can specify all the needed details about the configuration of the VM that you are creating, including the following:

- Name of the VM
- Region and zone where the VM will run
- Machine type, which determines the number of CPUs and the amount of memory in the VM
- Boot disk, which includes the operating system the VM will run

You can choose the name of your VM. This is primarily for your use. Google Cloud uses other identifiers internally to manage VMs.

You will need to specify a region. Regions are major geographical areas. A partial list of regions is shown in [Figure 5.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0005).

After you select a region, you can select a zone. Remember, a zone is a data center–like facility within a region. [Figure 5.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0006) shows an example list of zones available in the us-east-1 region.

![Snapshot of part of the main configuration form for creating VMs in Compute Engine](../images/c05f004.png)


[**FIGURE 5.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0004) Part of the main configuration form for creating VMs in Compute Engine

![Snapshot of a partial list of regions providing Compute Engine services](../images/c05f005.png)


[**FIGURE 5.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0005) A partial list of regions providing Compute Engine services

![Snapshot of a list of zones within the us-east1 region](../images/c05f006.png)


[**FIGURE 5.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0006) A list of zones within the us-east1 region

After you specify a region and a zone, Google Cloud can determine the VMs available in that zone. Not all zones have the same availability. [Figure 5.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0007) shows an example listing of machine types available for the E2 series in the us-east1-b zone.

Google Cloud organizes virtual machines into machine families, series, and machine type. A machine family is a set of processor and hardware configurations designed for particular workloads, such as general purpose, compute optimized, and memory optimized. Within a family, machines are organized into series and generation, as shown in [Figure 5.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0008).

Within a series, you will have the option of one or more machine types, which vary based on the number of virtual CPUs and the amount of memory.

For applications and services requiring high security, you can enable Confidential VM Service, which keeps data in memory encrypted using encryption keys that Google does not have access to.

![Snapshot of a partial list of machine types available in the us-east1-b zone](../images/c05f007.png)


[**FIGURE 5.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0007) A partial list of machine types available in the us-east1-b zone

![Snapshot of virtual machines within a machine family are further organized into series and generations based on the type of processor.](../images/c05f008.png)


[**FIGURE 5.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0008) Virtual machines within a machine family are further organized into series and generations based on the type of processor.

You have the option of choosing to run a container in your virtual machine. If you decide to do that, you must specify a container that is in a public repository or Google Container Registry. This can be useful if you want to run a container with specialized software or some custom configuration.

The Boot Disk section lists a default configuration. Clicking the Change button brings up the Boot Disk form, as shown in [Figure 5.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0009).

![Snapshot of form for configuring the boot disk of the VM](../images/c05f009.png)


[**FIGURE 5.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0009) Form for configuring the boot disk of the VM

Here you can choose the operating system you want to use. You can also choose the boot disk type: Balanced Persistent Disk, Extreme Persistent Disk, SSD Persistent Disk, or Standard Persistent Disk. You can also specify the size of the disk.

- Balanced persistent disks use solid-state drives (SSDs) and balance cost and performance.
- Extreme persistent disks use SSDs but provide high performance and allow you to provision your desired level of input-output operations per second (IOPS).
- SSD persistent disks use solid-state drives.
- Standard persistent disks use standard hard disk drives (HDDs).

Following the Boot Disk section is the Identity And API Access section (see [Figure 5.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0010)). Here you can specify a service account for the VM and set the scope of API access. If you want the processes running on this VM to use only some APIs, you can use these options to limit the VM's access to specific APIs.

![Snapshot of Identity And API Access and Firewall configurations](../images/c05f010.png)


[**FIGURE 5.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0010) Identity And API Access and Firewall configurations

In the next section, you can select whether you want the VM to accept HTTP or HTTPS traffic.

### Advanced Configuration Details

Click Management, Security, Disks, Networking, and Sole Tenancy to display advanced configuration options. This will expand a list of advanced configuration options.

#### Management Tab

The Management tab of the form ([Figure 5.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0011)) provides a space where you can describe the VM and its use. You can also create labels, which are key-value pairs. You can assign any label you like. Labels and a general description are often used to help manage your VMs and illustrate how they are being used. Labels are particularly important when your number of servers grows. It is a best practice to include a description and labels for all VMs.

![Snapshot of the first part of the Management tab of the VM creation form](../images/c05f011.png)


[**FIGURE 5.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0011) The first part of the Management tab of the VM creation form

If you want to force an extra confirmation before deleting an instance, you can select the Deletion Protection option. If someone tries to delete the instance, the operation will fail.

If you have reserved Compute Engine instance resources, they will be automatically used, but you can indicate that reservations should not be used for a particular instance.

You can specify a startup script to run when the instance starts. Copy the contents of the startup script to the Automation text box. For example, you could paste a Bash or Python script directly into the text box.

The Metadata section allows you to specify key-value pairs associated with the instance. These values are stored in a metadata server, which is available for querying using the Compute Engine API. Metadata tags are especially useful if you have a common script you want to run on startup or shutdown but want the behavior of the script to vary according to some metadata values.

Under Availability Policy are three drop-down menus:

- VM Provisioning Model, which is standard or spot. Spot allows Google to shut down the server with a 30-second notice. In return, the cost of a preemptible server is much lower than that of a nonpreemptible server.
- On Host Maintenance, which indicates whether the virtual server should be migrated to another physical server when a maintenance event occurs.
- Automatic Restart, which indicates if the server stops because of a hardware failure, maintenance event, or some other non-user-controlled event.

#### Security Tab

On the Security tab, you can specify whether you want to use Shielded VMs and Secure Shell (SSH) keys.

Shielded VMs are configured to have additional security mechanisms that you can choose to run (see [Figure 5.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0012)). These include the following:

- Secure Boot, which ensures that only authenticated operating system software runs on the VM. It does this by checking the digital signatures of the software. If a signature check fails, the boot process will halt.
- Virtual Trusted Platform Module (vTPM), which is a virtualized version of a Trusted Platform Module (TPM). A TPM is a specialized computer chip designed to protect security resources, like keys and certificates.
- Integrity Monitoring, which uses a known good baseline of boot measurements to compare to recent boot measurements. If the check fails, that means some difference exists between the baseline measurement and the current measurements.

Goolge Cloud supports the concept of project-wide SSH keys, which are used to give users project-wide access to VMs. You can block that behavior at the VM if you use project-wide SSH keys and do not want all project users to have access to this machine.

![Snapshot of you can place additional security controls on VMs.](../images/c05f012.png)


[**FIGURE 5.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0012) You can place additional security controls on VMs.

#### Boot Disks and Additional Disks

In the Boot Disk tab of the Create Instance page, you can specify advanced configuration options, as shown in [Figure 5.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0013). Under Deletion Rule, you can specify whether the boot disk should be deleted when the instance is deleted. You can also select how you would like to manage encryption keys for the boot disk. By default, Google manages those keys.

On the Disk configuration tab, you also have the option of adding a new disk or attaching an existing disk. [Figure 5.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0014) shows the tab for adding a new disk.

When adding a new disk, the form in [Figure 5.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0014) appears. Here, you specify a name and description and source information. The source specifies if you want to use a blank disk or create one using a snapshot or image. You also specify the disk size and type. If you want to automatically back up your disk, you can specify a snapshot schedule. By default, Google will manage encryption keys for the disk, but you can also specify customer-managed encryption keys (CMEKs) or customer-supplied encryption keys (CSEKs).

Adding an existing disk displays the form shown in [Figure 5.15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0015). Here you choose a disk from a list of existing disks and specify whether the disk should be attached as Read/Write or Read-Only. You can also specify whether the disk should be deleted when the VM is deleted. The default is to keep the disk. Finally, you can provide a custom disk name.

![Snapshot of boot disk advanced configuration](../images/c05f013.png)


[**FIGURE 5.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0013) Boot disk advanced configuration

![Snapshot of adding a new disk to a Compute Engine instance](../images/c05f014.png)


[**FIGURE 5.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0014) Adding a new disk to a Compute Engine instance

![Snapshot of form for adding an existing disk to a VM](../images/c05f015.png)


[**FIGURE 5.15**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0015) Form for adding an existing disk to a VM

#### Networking Tab

On the Networking tab, you can see the network interface information, including the IP address of the VM. If you have two networks, you have the option of adding another network interface to that other network. This use of dual network interfaces can be useful if you are running some type of proxy or server that acts as a control for the flow of some traffic between the networks. In addition, you can add network tags on this tab (see [Figure 5.16](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0016)).

#### Sole-Tenancy Tab

If you need to ensure that your VMs run on a server only with your other VMs, then you can specify *sole tenancy*. The Sole-Tenancy tab allows you to specify labels regarding sole tenancy for the server (see [Figure 5.17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0017)).

![Snapshot of options for network configuration of a VM](../images/c05f016.png)


[**FIGURE 5.16**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0016) Options for network configuration of a VM

Sole-tenant nodes can be configured to allow overcommitting CPU resources, but this is permitted only on machines with four or more CPUs. Node affinity labels are used to determine where a VM can run.

![Snapshot of sole tenancy configuration options](../images/c05f017.png)


[**FIGURE 5.17**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0017) Sole tenancy configuration options

## Creating and Configuring Virtual Machines with Cloud SDK

A second way to create and configure VMs is with Google Cloud SDK, which provides a command-line interface. (CLI) To use the Cloud SDK, you will first need to install it on your local device.

### Installing Cloud SDK

You have three options for interacting with Google Cloud resources:

- Using a command-line interface
- Using a RESTful interface
- Using the Cloud Shell

Before using either of the first two options from your local system, you will need to install Cloud SDK on your machine. Cloud Console is a GUI you can access through a browser at `https://console.cloud.google.com`.

Cloud SDK can be installed on Linux, Windows, or Mac computers.

#### Installing Cloud SDK on Linux

If you are using Linux, you can install Cloud SDK using your operating system's package manager. Ubuntu and other Debian distributions use `apt-get` to install packages. Red Hat Enterprise, CentOS, and other Linux distributions use `yum`. For instructions on using `apt-get`, see `https://cloud.google.com/sdk/docs/install-sdk#deb`. For instructions on installing on Red Hat Enterprise or CentOS, see `https://cloud.google.com/sdk/docs/install-sdk#rpm`.

#### Cloud SDK on macOS

Instructions for installing on a Mac and the installation file for Cloud SDK are available at `https://cloud.google.com/sdk/docs/install-sdk#mac`. The first step is to verify that you have Python 3 installed. There are three versions of Cloud SDK, one for 32-bit macOS; one for 64-bit macOS running on x86 processors; and one for 64-bit macOS running on arm64, the Apple M1 processor.

#### Installing Cloud SDK on Windows

To install Cloud SDK on a Windows platform, you will need to download the appropriate installer. You can find instructions at `https://cloud.google.com/sdk/docs/install-sdk#windows`.

### Example Installation on Ubuntu Linux

The first step in installing Cloud SDK is to get the appropriate version of the package for your operating system. The following commands are for installing Cloud SDK on Ubuntu. See `https://cloud.google.com/sdk/docs/install-sdk#deb` for any updates to this procedure.

The first step is adding the gcloud CLI URI as a source for packages:

```
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] 
https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
```

You also need to import the Google Cloud public key, which you do with this command:

```
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-
key --keyring /usr/share/keyrings/cloud.google.gpg add -
```

Finally, you need to update the `apt-get` package list and then use `apt-get` to install Cloud SDK:

```
sudo apt-get update && sudo apt-get install google-cloud-cli
```

Now that Cloud SDK is installed, you can execute commands using it. The first step is to initialize Cloud SDK using the `gcloud init` command, as shown here:

```
gcloud init
```

When you receive an authentication link, copy it into your browser. You are prompted to authenticate with Google when you go to that URL. Next, a response code appears in your browser. Copy that to your terminal window and paste it in response to the prompt that should appear.

Next, you are prompted to enter a project. If projects already exist in your account, they will be listed. You also have the option of creating a new project at this point. The project you select or create will be the default project used when issuing commands through Cloud SDK.

### Creating a Virtual Machine with Cloud SDK

To create a VM from the command line, you will use the `gcloud` command. You use this command for many cloud management tasks, including working with the following services:

- Compute Engine
- Cloud SQL instances
- Kubernetes Engine
- Cloud Dataproc
- Cloud DNS
- Cloud Deployment Manager

The `gcloud` command is organized into a hierarchy of groups, such as the compute group for Compute Engine commands. We'll discuss other groups in later chapters; the focus here is on Compute Engine.

A typical `gcloud` command starts with the group, as shown here:

```
gcloud compute
```

A subgroup is used in Compute Engine commands to indicate what type of compute resource you are working with. To create an instance, you use this command:

```
gcloud compute instances
```

And the action you want to take is to create an instance, so you use this:

```
gcloud compute instances create ace-instance-1 ace-instance-2
```

If you do not specify additional parameters, such as a zone, Google Cloud will use your information from your default project. You can view your project information using the following `gcloud` command:

```
gcloud compute project-info describe
```

To create a VM in the us-central1-a zone, add the `zone` parameter like this:

```
gcloud compute instances create ace-instance-1 ace-instance-2 -zone=us-central1-a
```

You can list the VMs you've created using this:

```
gcloud compute instances list
```

The following are parameters commonly used with the `create instance` command:

- `--boot-disk-size` is the size of the boot disk for a new disk. Disk size may be between 10 GB and 2 TB.
- `--boot-disk-type` is the type of disk. Use `gcloud compute disk-types list` for a list of disk types available in the zone the VM is created in.
- `--labels` is the list of key-value pairs in the format of `KEY=VALUE`.
- `--machine-type` is the type of machine to use. If not specified, it uses n1-standard-1. Use `gcloud compute machine-types list` to view a list of machine types available in the zone you are using.
- `--preemptible`, if included, specifies that the VM will be preemptible.

For additional parameters, see the `glcoud compute instance create` documentation at `https://cloud.google.com/sdk/gcloud/reference/compute/instances/create`.

To create a standard VM with 8 CPUs and 30 GB of memory, you can specify `n1s8-standard-2` as the machine type:

```
gcloud compute instances create ace-instance-n1s8 --machine-type=e2-standard-2
```

If you want to make this instance preemptible, you add the `preemptible` parameter:

```
gcloud compute instances create --machine-type=n1\-standard-8 --preemptible ace-instance-1
```

### Creating a Virtual Machine with Cloud Shell

An alternative to running `gcloud` commands locally is to run them in a cloud instance. Cloud Shell provides this capability. To use Cloud Shell, start it from Cloud Console by clicking the shell icon in the upper-right corner of the browser, as shown in [Figure 5.18](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0018).

![Snapshot of cloud Shell is activated through Cloud Console.](../images/c05f018.png)


[**FIGURE 5.18**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0018) Cloud Shell is activated through Cloud Console.

Cloud SDK is installed and Cloud Shell provides a Linux command line, as shown in [Figure 5.19](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0019). All `glcoud` commands that you can enter on your local device with Cloud SDK installed can be used in Cloud Shell.

![Snapshot of cloud Shell opens a command-line window in the browser.](../images/c05f019.png)


[**FIGURE 5.19**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0019) Cloud Shell opens a command-line window in the browser.

## Basic Virtual Machine Management

When VMs are running, you can perform basic management tasks by using the console or by using `gcloud` commands.

### Starting and Stopping Instances

In the console you view a list of instances by selecting Compute Engine and then VM Instances from the left-side panel of the console. You can then select a VM to operate on and list command options by clicking the ellipsis icons on the right. [Figure 5.20](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0020) shows an example.

Note that you can start a stopped instance using the `start` command that is enabled in the pop-up for stopped instances.

You can also use `gcloud` to stop an instance with the following command, where *`INSTANCE-NAME`* is the name of the instance:

```
gcloud compute instances stop INSTANCE-NAME
```

### Network Access to Virtual Machines

As a cloud engineer, you will sometimes need to log into a VM to perform some administration tasks. The most common way is to use SSH when logging into a Linux server or use Remote Desktop Protocol (RDP) when logging into a Windows server.

![Snapshot of basic operations on VMs can be performed using a pop-up menu in the console.](../images/c05f020.png)


[**FIGURE 5.20**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0020) Basic operations on VMs can be performed using a pop-up menu in the console.

[Figure 5.21](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0021) shows the set of options for using SSH from the console. This list of options appears when you click the SSH button associated with a VM.

![Snapshot of from the console, you can start an SSH session to log into a Linux server.](../images/c05f021.png)


[**FIGURE 5.21**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0021) From the console, you can start an SSH session to log into a Linux server.

Choosing the Open In Browser Window option will open a new browser window and display a terminal window for accessing the command line on the server, as shown in [Figure 5.22](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0022).

![Snapshot of a terminal window opens in a new browser window when using Cloud Shell.](../images/c05f022.png)


[**FIGURE 5.22**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0022) A terminal window opens in a new browser window when using SSH-in-browser.

### Monitoring a Virtual Machine

While your VM is running, you can monitor CPU, disk, and network load by viewing the Monitoring tab on the VM Instance Details page.

To access monitoring information in the console, select a VM instance from the VM Instance page by clicking the name of the VM you want to monitor. This will display the Details page of the VM. Select the Monitoring option near the top of the page to view monitoring details.

[Figure 5.23](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#c05-fig-0023) show the information displayed about CPU, network utilization, and disk operations.

### Cost of Virtual Machines

Part of the basic management of a VM is tracking the costs of the instances you are running. If you want to track costs automatically, you can enable Cloud billing and set up Billing Export. This will produce daily reports on the usage and cost of VMs.

The following are the most important things to remember about VM costs:

- VMs are billed in 1-second increments.
- The cost is based on machine type. The more CPUs and memory used, the higher the cost.
- Google offers discounts for sustained usage, but discounts are not offered on all instance types.
- VMs are charged for a minimum of 1 minute of use.
- Spot VMs can save you up to 80 percent of the cost of a VM.

For additional information on pricing, see `https://cloud.google.com/compute/vm-instance-pricing`.

![Snapshot of the Observability tab of the VM Instance Details page](../images/c05f023.png)


[**FIGURE 5.23**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml#R_c05-fig-0023) The Observability tab of the VM Instance Details page

## Guidelines for Planning, Deploying, and Managing Virtual Machines

Consider the following guidelines to help with streamlining your work with VMs. These guidelines apply to working with a small number of VMs. Later chapters will provide additional guidelines for working with clusters and instance groups, which are sets of similarly configured VMs.

- Choose a machine type with the fewest CPUs and the smallest amount of memory that still meets your requirements, including peak capacity. This will minimize the cost of the VM.
- Use the console for ad hoc administration of VMs. Use scripts with `gcloud` commands for tasks that will be repeated.
- Use startup scripts to perform software updates and other tasks that should be performed on startup.
- If you make several modifications to a machine image, consider saving it and using it with new instances rather than running the same set of modifications on every new instance.
- If you can tolerate unplanned disruptions, use spot VMs to reduce cost.
- Use SSH or RDP to access a VM to perform operating system–level tasks.
- Use Cloud Console, Cloud Shell, or Cloud SDK to perform VM-level tasks.

## Summary

Google Cloud Console is a web-based graphical user interface for managing Google Cloud resources. Cloud SDK is a command-line package that allows engineers to manage cloud resources from the command line of their local device. Cloud Shell is a web-based terminal interface to VMs. Cloud SDK is installed in Cloud Shell.

When creating a VM, you must specify a number of parameters, including a name for the VM, a region and zone where the VM will run, a machine type that specifies the number of vCPUs and the amount of memory, and a boot disk that includes an operating system.

`gcloud` is the top-level command of the hierarchical command structure in Cloud SDK.

Common tasks when managing VMs are starting and stopping instances, using SSH to access a terminal on the VM, monitoring, and tracking the cost of the VM.

## Exam Essentials

- **Understand how to use Cloud Console and Cloud SDK to create, start, and stop VMs.**   Parameters that you will need to provide when creating a VM include name, machine type, region, zone, and boot disk. Understand the need to create a VM in a project.
- **Know how to configure a spot VM using Cloud Console and the `gcloud` commands.**   Know when to use a spot VM and when not to. Know that spot VMs cost up to 80 percent less than standard VMs.
- **Know the purpose of advanced options, including Shielded VMs and advanced boot disk configurations.**   Know that advanced options provide additional security. Understand the kinds of protections provided.
- **Know how to use `gcloud` compute instance commands to list, start, and stop VMs.**   Know the structure of `gcloud` commands. `gcloud` commands start with `gcloud` followed by a service, such as `compute`, followed by a resource type, such as `instances`, followed by a command or verb, like `create`, `list`, or `describe`.
- **Understand how to monitor a VM.**   Know where to find CPU utilization, network monitoring, and disk monitoring in the VM Instances pages of the console. Know the difference between listing and describing instances with a `gcloud` command.
- **Know the factors that determine the cost of a VM.**   Know that Google charges by the second with a 1-minute minimum. Understand that the costs of a machine type may be different in different locations. Know that cost is based on the number of vCPUs and memory.

## Review Questions

You can find the answers in the Appendix.

1. You have just opened the Google Cloud console at `http://console.google.com`. You have authenticated with the user you want to use. What is one of the first things you should do before performing tasks on VMs?
   1. Open Cloud Shell.
   2. Verify you can log into a VM using SSH.
   3. Verify that the selected project is the one you want to work with.
   4. Review the list of running VMs.
2. What is a one-time task you will need to complete before using the console?
   1. Set up billing.
   2. Create a project.
   3. Create a storage bucket.
   4. Specify a default zone.
3. A colleague has asked for your assistance setting up a test environment in Google Cloud. They have never worked in Google Cloud. You suggest starting with a single VM. Which of the following is the minimal set of information you will need?
   1. A name for the VM and a machine type
   2. A name for the VM, a machine type, a region, and a zone
   3. A name for the VM, a machine type, a region, a zone, and a CIDR block
   4. A name for the VM, a machine type, a region, a zone, and an IP address
4. An architect has suggested a particular machine type for your workload. You are in the console creating a VM and you don't see the machine type in the list of available machine types. What could be the reason for this?
   1. You have selected the incorrect subnet.
   2. That machine type is not available in the zone you specified.
   3. You have chosen an incompatible operating system.
   4. You have not specified a correct memory configuration.
5. Your manager asks for your help with understanding cloud computing costs. Your team runs dozens of VMs for three different applications. Two of the applications are for use by the marketing department and one is used by the finance department. Your manager wants a way to bill each department for the cost of the VMs used for their applications. What would you suggest to help solve this problem?
   1. Access controls
   2. Persistent disks
   3. Labels and descriptions
   4. Descriptions only
6. If you wanted to set the preemptible property using Cloud Console, in which section of the Create An Instance page would you find the option?
   1. Availability Policy
   2. Identity And API Access
   3. Sole Tenancy
   4. Networking
7. You need to set up a server with a high level of security. You want to be prepared in case of attacks on your server by someone trying to inject a rootkit (a kind of malware that can alter the operating system). Which option should you select when creating a VM?
   1. Firewall
   2. Shielded VM
   3. Project-wide SSH keys
   4. Boot disk integrity control service
8. All of the following parameters can be set when adding an additional disk through Google Cloud Console, except:
   1. Disk type
   2. Encryption key management
   3. Block size
   4. Source image for the disk
9. You lead a team of cloud engineers who maintain cloud resources for several departments in your company. You've noticed a problem with configuration drift. Some machine configurations are no longer in the same state as they were when created. You can't find notes or documentation on how the changes were made or why. What practice would you implement to solve this problem?
   1. Have all cloud engineers use only command-line interface in Cloud Shell.
   2. Write scripts using `gcloud` commands to change configuration and store those scripts in a version control system.
   3. Take notes when making changes to configuration and store them in Google Drive.
   4. Limit privileges so only you can make changes, and you will always know when and why configurations were changed.
10. When you're using the Cloud SDK command-line interface, which of the following is part of commands for administering resources in Compute Engine?
    1. `gcloud compute instances`
    2. `gcloud instances`
    3. `gcloud instances compute`
    4. None of the above
11. A newly hired cloud engineer is trying to understand what VMs are running in a particular project. How could the engineer get summary information on each VM running in a project?
    1. Execute the command `gcloud compute list.`
    2. Execute the command `gcloud compute instances list.`
    3. Execute the command `gcloud instances list.`
    4. Execute the command `gcloud list instances.`
12. When creating a VM using the command line, how should you specify labels for the VM?
    1. Use the `--labels` option with labels in the format of KEYS:VALUES.
    2. Use the `--labels` option with labels in the format of KEYS=VALUE.
    3. Use the `--labels` option with labels in the format of KEYS,VALUES.
    4. This is not possible in the command line.
13. In the boot disk advanced configuration, which operations can you specify when creating a new VM?
    1. Add a new disk, reformat an existing disk, attach an existing disk.
    2. Add a new disk and reformat an existing disk.
    3. Add a new disk and attach an existing disk.
    4. Reformat an existing disk and attach an existing disk.
14. You have acquired a 10 GB data set from a third-party research firm. A group of data scientists would like to access this data from their statistics programs written in R. R works well with Linux and Windows filesystems, and the data scientists are familiar with file operations in R. The data scientists would each like to have their own dedicated VM with the data available in the VM's filesystem. What is a way to make this data readily available on a VM and minimize the steps the data scientists will have to take?
    1. Store the data in Cloud Storage.
    2. Create VMs using a source image created from a disk with the data on it.
    3. Store the data in Google Drive.
    4. Load the data into BigQuery.
15. The Networking tab of the Create VM form is where you would perform which of the following operations?
    1. Set the IP address of the VM.
    2. Add a network interface to the VM.
    3. Specify a default router.
    4. Change firewall configuration rules.
16. You want to create a VM using the `gcloud` command. What parameter would you include to specify the type of boot disk?
    1. `boot-disk-type`
    2. `boot-disk`
    3. `disk-type`
    4. `type-boot-disk`
17. Which of the following commands will create a VM with four CPUs that is named web-server-1?
    1. `gcloud compute instances create --machine-type=n1-standard-4\ web-server-1`
    2. `gcloud compute instances create --cpus=4 web-server-1`
    3. `gcloud compute instances create --machine-type=n1-standard-4\ –instance-name=web-server-1`
    4. `gcloud compute instances create --machine-type=n1-4-cpu\ web-server-1`
18. Which of the following commands will stop a VM named web-server-1?
    1. `gcloud compute instances halt web-server-1`
    2. `gcloud compute instances --terminate web-server1`
    3. `gcloud compute instances stop web-server-1`
    4. `gcloud compute stop web-server-1`
19. You have just created an Ubuntu VM and want to log into the VM to install some software packages. Which network service would you use to access the VM?
    1. FTP
    2. SSH
    3. RDP
    4. ipconfig
20. Your management team is considering three different cloud providers. You have been asked to summarize billing and cost information to help the management team compare cost structures between clouds. Which of the following would you mention about the cost of VMs in Google Cloud?
    1. VMs are billed in 1-second increments, cost varies with the number of CPUs and amount of memory in a machine type, you can create custom machine types, preemptible VMs cost up to 80 percent less than standard VMs, and Google offers discounts for sustained usage.
    2. VMs are billed in 1-second increments and VMs can run up to 24 hours before they will be shut down.
    3. Google offers discounts for sustained usage in only some regions, cost varies with the number of CPUs and amount of memory in a machine type, you can create custom machine types, preemptible VMs cost up to 80 percent less than standard VMs.
    4. VMs are charged for a minimum of 1 hour of use, and cost varies with the number of CPUs and amount of memory in a machine type.