---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- ****4.1 Managing Compute Engine resources****

---

After creating virtual machines, you will need to work with both single instances of virtual machines (VMs) and groups of VMs that run the same configuration. The latter are called *instance groups* and are introduced in this chapter.

This chapter begins with a description of common management tasks and how to complete them in the console, followed by a description of how to complete them in Cloud Shell or with the Cloud SDK command line. Next, you will learn how to configure and manage instance groups. The chapter concludes with a discussion of guidelines for managing VMs.

## Managing Single Virtual Machine Instances

We begin by discussing how to manage a single instance of a VM. By single instance, we mean one created by itself and not in an instance group or other type of cluster. Recall from previous chapters that there are three ways to work with instances: in Cloud Console, in Cloud Shell, and with the Cloud SDK command line. Both Cloud Shell and the Cloud SDK command line make use of `gcloud` commands, so we will describe Cloud Shell and Cloud SDK together in this section.

### Managing Single Virtual Machine Instances in the Console

The basic VM management tasks that you should be familiar with are creating, stopping, and deleting instances. We covered creating instances in the previous chapter, so we'll focus on the other tasks here. You should also be familiar with listing VMs, attaching graphics processing units (GPUs) to VMs, and working with snapshots and images.

#### Starting, Stopping, and Deleting Instances

To start working, open the console and select Compute Engine. Then select VM instances. This will display a window like the one in [Figure 6.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0001), but with different VMs listed. In this example, there are three VMs.

![Snapshot of the VM Instance panel in the Compute Engine section of Cloud ConsoleSource: Google LLC](../images/c06f001.png)


[**FIGURE 6.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0001) The VM Instance panel in the Compute Engine section of Cloud Console

*Source:* Google LLC

The three instances in [Figure 6.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0001) are all running. You can stop the instances by clicking the three-dot icon on the right side of the line listing the VM attributes. This action displays a list of commands. [Figure 6.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0002) shows the list of commands available for `instance-1`.

![Snapshot of the list of commands available from the console for changing the state of a VMSource: Google LLC](../images/c06f002.png)


[**FIGURE 6.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0002) The list of commands available from the console for changing the state of a VM

*Source:* Google LLC

If you select Stop from the command menu, the instance will be stopped. When an instance is stopped, it is not consuming compute resources, so you will not be charged. The instance still exists and can be started again when you need it. [Figure 6.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0003) shows a warning form that indicates you are about to stop a VM. You can click the dialog box in the lower left to suppress this message.

![Snapshot of a warning message that may appear about stopping a VMSource: Google LLC](../images/c06f003.png)


[**FIGURE 6.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0003) A warning message that may appear about stopping a VM

*Source:* Google LLC

When you stop a VM, the green check mark on the left changes to a gray circle with a white square, and the SSH option is disabled, as shown in [Figure 6.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0004).

![Snapshot of when VMs are stopped, the icon on the left changes and SSH is no longer available.Source: Google LLC](../images/c06f004.png)


[**FIGURE 6.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0004) When VMs are stopped, the icon on the left changes and SSH is no longer available.

*Source:* Google LLC

To start a stopped VM, click the three-dot icon on the right to display the menu of available commands. Notice in [Figure 6.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0005) that Start is now available but Stop and Reset are not.

The Reset command restarts a VM. The properties of the VM will not change, but data in memory will be lost.

---

![](../images/note_13.png) When a VM is restarted, the contents of memory are lost. If you need to preserve data between reboots or for use on other VMs, save the data to a persistent disk or Cloud Storage.

---

When you are done with an instance and no longer need it, you can delete it. Deleting a VM removes it from Cloud Console and releases resources, like the storage used to keep the VM image when stopped. Deleting an instance from Cloud Console will display a warning message, shown in [Figure 6.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0006).

![Snapshot of when VMs are stopped, Stop and Reset are no longer available, but Start / Resume is available as a command.Source: Google LLC](../images/c06f005.png)


[**FIGURE 6.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0005) When VMs are stopped, Stop and Reset are no longer available, but Start / Resume is available as a command.

*Source:* Google LLC

![Snapshot of deleting an instance from the console will display a warning message such as this.Source: Google LLC](../images/c06f006.png)


[**FIGURE 6.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0006) Deleting an instance from the console will display a warning message such as this.

*Source:* Google LLC

#### Viewing Virtual Machine Inventory

The VM Instances page of Cloud Console will show a list of VMs, if any exist in the current project. If you have a large number of instances, it can help to filter the list to see only instances of interest. Do this by using the Filter VM Instances box above the list of VMs, as shown in [Figure 6.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0007).

![Snapshot of list of instances filtered by search criteriaSource: Google LLC](../images/c06f007.png)


[**FIGURE 6.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0007) List of instances filtered by search criteria

*Source:* Google LLC

In this example, we have specified that we want to see only the instance named `instance-2`. In addition to specifying instance names, you can also filter by the following:

- Labels
- Internal IP
- External IP
- Status
- Zone
- Network
- Deletion protection

If you set multiple filter conditions, then all must be true for a VM to be listed unless you explicitly state the `OR` operator.

#### Attaching GPUs to an Instance

GPUs are used for math-intensive applications such as visualizations and machine learning. GPUs perform math calculations and allow some work to be offloaded from the CPU to the GPU. Compute Engine has a machine family specifically designed for VMs with GPUs. To use GPUs, you will also need to install GPU drivers or use an image that has GPU drivers already installed.

When creating an instance in the console, you can choose the GPU machine family to see the options for working with GPUs. (See [Figure 6.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0008).)

![Snapshot of gPU machine family supports a variety of GPU types, and a number of GPUs and CPU platforms. Source: Google LLC](../images/c06f008.png)


[**FIGURE 6.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0008) GPU machine family supports a variety of GPU types, and a number of GPUs and CPU platforms.

*Source:* Google LLC

To add a GPU to an instance, you must start an instance in which GPU libraries have been installed or will be installed. For example, you can use one of the Google Cloud images that has GPU libraries installed, including the Deep Learning images, as shown in [Figure 6.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0008). You must also verify that the instance will run in a zone that has GPUs available.

The parameters you can configure include GPU Type and Number Of GPUs. [Figure 6.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0009) shows some GPU options. The type of GPU will determine the number of GPUs available. For example, currently the NVIDIA Tesla A100 can be used in 1, 2, 4, 8, or 16 GPU configurations whereas the NVIDIA Tesla T4 can be used in 1, 2, or 4 GPU configurations.

![Snapshot of some GPU options available in Compute Engine Source: Google LLC](../images/c06f009.png)


[**FIGURE 6.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0009) Some GPU options available in Compute Engine

*Source:* Google LLC

As with other machine families, you can specify a machine type. You can also specify a CPU platform, such as Intel Skylake or later or Intel Ivy Bridge or later. These are microarchitecture options. Compute Engine will automatically choose a CPU platform by default.

There are some restrictions on the use of GPUs; for example, GPUs cannot be attached to shared memory machines. For the latest documentation on GPU restrictions and a list of zones with GPUs, see `https://cloud.google.com/compute/docs/gpus`.

#### Working with Snapshots

Snapshots are copies of data on a persistent disk. You use snapshots to save data on a disk so that you can restore it. This is a convenient way to make multiple persistent disks with the same data or to back up a disk so that you can recover the state of the disk at a particular point in time.

When you first create a snapshot, Google Cloud will make a full copy of the data on the persistent disk. The next time you create a snapshot from that disk, Google Cloud will copy only the data that has changed since the last snapshot. This optimizes storage while keeping the snapshot up-to-date with the data that was on the disk the last time a snapshot operation occurred.

If you are running a database or other application that may buffer data in memory before writing to disk, be sure to flush disk buffers before you create the snapshot; otherwise, data in memory that should be written to disk may be lost. The way to flush the disk buffers will vary by application. For example, MySQL has a `FLUSH` statement.

To work with snapshots, a user must be assigned the Compute Storage Admin role. Go to the Identity Access Management (IAM) page, select Roles, and then specify the email address of a user to be assigned the role.

To create a snapshot from Cloud Console, display the Compute Engine options and select Snapshots from the left panel, as shown in [Figure 6.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0010).

Then, click Create Snapshot to display the form in [Figure 6.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0011). Specify a name and, optionally, a description. You can add labels to the snapshot as well. It is a good practice to label all resources with a consistent labeling convention. In the case of snapshots, the labels may indicate the type of data on the disk and the application that uses the data.

You have the option of storing the snapshot regionally or multiregionally.

#### Working with Images

Images are similar to snapshots in that they are copies of disk contents. The difference is that snapshots are used to make data available on a disk, whereas images are used to create VMs. VMs can also be created from snapshots, as long as that snapshot is made from a boot disk. The main storage difference between images and snapshots is that snapshots offer incremental backups, while images are a single complete backup. Images can be created from the following:

- Disk
- Snapshot
- Image
- Cloud storage file
- Virtual disk

![Snapshot of creating a snapshot using Cloud ConsoleSource: Google LLC](../images/c06f010.png)


[**FIGURE 6.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0010) Creating a snapshot using Cloud Console

*Source:* Google LLC

To create an image, choose the Image option from the Compute Engine page in Cloud Console, as shown in [Figure 6.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0012). This lists available images.

Select Create Image to show the form in [Figure 6.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0013). This form allows you to create a new image by specifying a name, description, and labels. Images have an optional attribute called Family, which allows you to group images. When a family is specified, the latest, nondeprecated image in the family is used.

The form provides a drop-down list of options for the source of the image, as shown in [Figure 6.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0014).

![Snapshot of form for creating a snapshotSource: Google LLC](../images/c06f011.png)


[**FIGURE 6.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0011) Form for creating a snapshot

*Source:* Google LLC

When you choose Image as the source type, you can choose an image from the current project or other projects (see [Figure 6.15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0015)).

If you choose a Cloud Storage file as a source, you can browse your Cloud Storage bucket to find a file to use as the source (see [Figure 6.16](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0016)).

After you have created an image, you can delete it or deprecate it by checking the box next to the image name and selecting Delete or Deprecate from the line of commands above the list. You can delete and deprecate only custom images, not Google Cloud-supplied images.

![Snapshot of images available. From here, you can create additional images.Source: Google LLC](../images/c06f012.png)


[**FIGURE 6.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0012) Images available. From here, you can create additional images.

*Source:* Google LLC

Delete removes the image, and Deprecated marks the image as no longer supported and allows you to specify a replacement image to use going forward. Google's deprecated images are available for use but may not be patched for security flaws or other updates. Deprecation is a useful way of informing users of the image that it is no longer supported and that they should plan to test their applications with the newer, supported versions of the image. Eventually, deprecated images will no longer be available, and users of the deprecated images will need to use different versions.

After you have created an image, you can create an instance using that image by selecting the Create Instance option in the line of commands above the image listing.

### Managing a Single Virtual Machine Instance with Cloud Shell and the Command Line

In addition to managing VMs through the console, you can manage compute resources using the command line. The same commands can be used in Cloud Shell or in your local environment after you have installed Google Cloud SDK, which was covered in [Chapter 5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c05.xhtml), “Computing with Compute Engine Virtual Machines.”

![Snapshot of cloud Console form for creating an imageSource: Google LLC](../images/c06f013.png)


[**FIGURE 6.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0013) Cloud Console form for creating an image

*Source:* Google LLC

![Snapshot of options for the source of an imageSource: Google LLC](../images/c06f014.png)


[**FIGURE 6.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0014) Options for the source of an image

*Source:* Google LLC

![Snapshot of when using an image as a source, you can choose a source image from another project.Source: Google LLC](../images/c06f015.png)


[**FIGURE 6.15**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0015) When using an image as a source, you can choose a source image from another project.

*Source:* Google LLC

![Snapshot of when using a Cloud Storage file as a source, you browse your storage buckets for a file.Source: Google LLC](../images/c06f016.png)


[**FIGURE 6.16**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0016) When using a Cloud Storage file as a source, you browse your storage buckets for a file.

*Source:* Google LLC

This section describes the most important commands for working with instances. Commands have their own specific sets of parameters; however, all `gcloud` commands support sets of flags. These are referred to as `gcloud`-wide flags, also known as `gcloud` global flags, and include the following:

- `--account` specifies a Google Cloud account to use overriding the default account.
- `--configuration` uses a named configuration file that contains key-value pairs.
- `--flatten` generates separate key-value records when a key has multiple values.
- `--format` specifies an output format, such as default (human-readable) CSV, JSON, YAML, text, or other possible options.
- `--help` displays a detailed help message.
- `--project` specifies a Google Cloud project to use, overriding the default project.
- `--quiet` disables interactive prompts and uses defaults.
- `--verbosity` specifies the level of detailed output messages. Options are `debug`, `info`, `warning`, and `error`.

Throughout this section, commands can take an optional `--zone` parameter. We assume a default zone was set when you ran `gcloud init`.

#### Starting Instances

To start an instance, use the `gcloud` command, specifying that you are working with a compute service and instances specifically. You also need to indicate that you will be starting an instance by specifying `start`, followed by the name of one or more instances.

The command syntax is as follows:

```
gcloud compute instances start  INSTANCE_NAMES
```

An example is as follows:

```
gcloud compute instances start  instance-1 instance-2
```

The `instance start` command also takes optional parameters. The `--async` parameter returns immediately without waiting for the operations to complete. The `--verbose` option in many Linux commands provides similar functionality. Here's an example:

```
gcloud compute instances start  instance-1 instance-2 --async
```

Google Cloud needs to know in which zone to create an instance. This can be specified with the `--zone` parameter as follows:

```
gcloud compute instances start  ch06-instance-1 ch06-instance-2\ ––zone=us-central1-c
```

You can get a list of zones with the following command:

```
gcloud compute zones list
```

If no zone is specified, the command will prompt for one.

#### Stopping Instances

To stop an instance, use `gcloud compute instances` and specify `stop` followed by the name of one or more instances.

The command syntax is as follows:

```
gcloud compute instances stop  INSTANCE_NAMES
```

Here's an example:

```
gcloud compute instances stop  instance-3 instance-4
```

Like the `instance start` command, the `stop` command takes optional parameters:

```
gcloud compute instances stop  ch06-instance-1 ch06-instance-2 --async
```

Google Cloud needs to know which zone contains the instance to stop. This can be specified with the `--zone` parameter as follows:

```
gcloud compute instances stop ch06-instance-1 ch06-instance-2\ ––zone=us-central1-c
```

You can get a list of zones with the following command:

```
gcloud compute zones list
```

#### Deleting Instances

When you are finished working with a VM, you can delete it with the `delete` command. Here's an example:

```
gcloud compute instances delete instance-1
```

The `delete` command takes the `--zone` parameter to specify where the VM to delete is located. Here's an example:

```
gcloud compute instances delete ch06-instance-1 ––zone=us-central1-b
```

When an instance is deleted, the disks on the VM may be deleted or saved by using the `--delete-disks` and `--keep-disks` parameters, respectively. You can specify `all` to keep all disks, `boot` to specify the partition of the root filesystem, and `data` to specify nonboot disks.

For example, the following command keeps all disks:

```
gcloud compute instances delete ch06-instance-1 --zone=us-central2-b\ --keep-disks=all
```

while the following deletes all nonboot disks:

```
gcloud compute instances delete ch06-instance-1 ––zone=us-central2-b\ --delete-disks=data
```

#### Viewing VM Inventory

The command to view the set of VMs in your inventory is as follows:

```
gcloud compute instances list
```

This command takes an optional name of an instance. To list VMs in a particular zone, you can use the following:

```
gcloud compute instances list --filter="zone:ZONE"
```

where *ZONE* is the name of a zone. You can list multiple zones using a comma-separated list.

The `--limit` parameter is used to limit the number of VMs listed, and the `--sort-by` parameter is used to reorder the list of VMs by specifying a resource field. You can see the resource fields for a VM by running the following:

```
gcloud compute instances describe
```

#### Working with Snapshots

You can create a snapshot of a disk using the following command:

```
gcloud compute disks snapshot DISK_NAME --snapshot-names=NAME
```

where *`DISK_NAME`* is the name of a disk and *`NAME`* is the name of the snapshot. To view a list of snapshots, use the following:

```
gcloud compute snapshots list
```

For detailed information about a snapshot, use the following:

```
gcloud compute snapshots describe SNAPSHOT_NAME
```

where *`SNAPSHOT_NAME`* is the name of the snapshot to describe. To create a disk, use this:

```
gcloud compute disks create DISK_NAME --source-snapshot=SNAPSHOT_NAME
```

You can also specify the size of the disk and disk type using the `--size` and `--parameters`. Here's an example:

```
gcloud compute disks create disk-1 --source-snapshot=ch06-snapshot --size=100\ --type=pd-standard
```

This will create a 100 GB disk using the `ch06-snapshot` using a standard persistent disk.

#### Working with Images

Google Cloud provides a wide range of images to use when creating a VM; however, you may need to create a specialized image of your own. This can be done with the following command:

```
gcloud compute images create IMAGE_NAME
```

where *`IMAGE_NAME`* is the name given to the images. The source for the images is specified using one of the source parameters, which are as follows:

- `--source-disk`
- `--source-image`
- `--source-image-family`
- `--source-snapshot`
- `--source-uri`

The `source-disk`, `source-image`, and `source-snapshot` parameters are used to create an image using a disk, image, and snapshot, respectively. The `source-image-family` parameter uses the latest version of an image in the family. Families are groups of related images, which are usually different versions of the same underlying image. The `source-uri` parameter allows you to specify an image using a web address.

An image can have a description and a set of labels. These are assigned using the `--description` and `--labels` parameters.

Here is an example of creating a new image from a disk:

```
gcloud compute images create image-1 ––source-disk=disk-1
```

You can also delete images when they are no longer needed using this:

```
gcloud compute images delete IMAGE_NAME
```

It is often helpful to store images on Cloud Storage. You can export an image to Cloud Storage with the following command:

```
gcloud compute images export --destination-uri=DESTINATION_URI\ ––image=IMAGE_NAME
```

where *`DESTINATION_URI`* is the address of a Cloud Storage bucket where you want to store the image.

## Introduction to Instance Groups

Instance groups are sets of VMs that are managed as a single entity. Any `gcloud` or console command applied to an instance group is applied to all members of the instance group. Google provides two types of instance groups: managed and unmanaged.

Managed groups consist of groups of identical VMs. They are created using an instance template, which is a specification of a VM configuration, including machine type, boot disk image, zone, labels, and other properties of an instance. Managed instance groups can automatically scale the number of instances in a group and be used with load balancing to distribute workloads across the instance group. If an instance in a group crashes, it will be re-created automatically. Managed groups are the preferred type of instance group.

Unmanaged groups should be used only when you need to work with different configurations within different VMs in the group.

### Creating and Removing Instance Groups and Templates

To create an instance group, you must first create an instance group template. To create an instance template, use the following command:

```
gcloud compute instance-templates create INSTANCE
```

You can specify an existing VM as the source of the instance template by using the `--source-instance` parameter. Here's an example:

```
gcloud compute instance-templates create instance-template-1\ --source-instance=instance-1
```

Instance group templates can also be created in the console using the Instance Groups Template page, as shown in [Figure 6.17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#c06-fig-0017).

![Snapshot of instance group templates can be created in the console using a form similar to the create instance form.Source: Google LLC](../images/c06f017.png)


[**FIGURE 6.17**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml#R_c06-fig-0017) Instance group templates can be created in the console using a form similar to the create instance form.

*Source:* Google LLC

Instance groups can contain instances in a single zone or across a region. The first is called a *zonal* managed instance group, and the second is called a *regional* managed instance group. Regional managed instance groups are recommended because that configuration spreads the workload across zones, increasing resiliency.

You can specify a distribution policy. Even distribution will evenly distribute across zones. Balanced distribution will distribute as evenly as possible across zones based on available resources. The Any distribution will deploy managed instances to zones based on availability and reservations.

You can remove instance templates by deleting them from the Instance Group Template page in the console. Select the instance group template by selecting the check box in the list of templates and then delete it by clicking the delete icon.

You can also delete an instance group template using the following command:

```
gcloud compute instance-templates delete INSTANCE-TEMPLATE-NAME
```

where *`INSTANCE-TEMPLATE-NAME`* is the name of the template you want to delete.

To list templates and instance groups, use the following:

```
gcloud compute instance-templates list gcloud compute instance-groups managed list-instances
```

To list the instances in an instance group, use the following:

```
gcloud compute instance-groups managed list-instances INSTANCE-GROUP-NAME
```

### Instance Groups Load Balancing and Autoscaling

To deploy a scalable, highly available application, you can run that application on a load-balanced set of instances. Google Cloud offers several types of load balancing, and they all require use of an instance group.

In addition to load balancing, managed instance groups can be configured to autoscale. You can configure an autoscaling policy to trigger adding or removing instances based on CPU utilization, monitoring metric, load-balancing capacity, or queue-based workloads.

---

### No More Peak Capacity Planning

Prior to the advent of the cloud, IT organizations often had to plan their hardware purchases around the maximum expected load. This is called *peak capacity planning*. If there is little variation in load, peak capacity planning is a sound approach. Businesses with highly variable workloads, such as retailers in the United States that have high demand during the last two months of the year, would have to support idle capacity for months out of the year. Cloud computing and autoscaling have eliminated the need for peak capacity planning. Additional servers are acquired in minutes, not weeks or months. When capacity is not needed, it is dropped. Instance groups automate the process of adding and removing VMs, allowing cloud engineers to fine-tune when to add and when to remove VMs.

---


---

![](../images/note_13.png) When autoscaling, ensure you leave enough time for VMs to boot up or shut down before triggering another change in the cluster configuration. If the time between checks is too small, you may find that a recently added VM is not fully started before another is added. This can lead to more VMs being added than are actually needed.

---

## Guidelines for Managing Virtual Machines

Here are some guidelines for managing VMs:

- Use labels and descriptions. This will help you identify the purpose of an instance and help when filtering lists of instances.
- Use managed instance groups to enable autoscaling and load balancing. These are key to deploying scalable and highly available services.
- Use GPUs for numeric-intensive processing, such as machine learning and high-performance computing. For some applications, GPUs can give a greater performance benefit than adding another CPU.
- Use snapshots to save the state of a disk or to make copies. These can be saved in Cloud Storage and act as backups.
- Use preemptible instances for workloads that can tolerate disruption. Spot VMs are lower-cost VMs that are suitable for 60%–91% less than standard priced VMs. They are preemptible instances but are not limited to maximum runtimes of 24 hours like the original preemptible VMs are.

## Summary

In this chapter, you learned how to manage a single VM instances and instance groups. Single VM instances can be created, configured, stopped, started, and deleted using Cloud Console or `gcloud` commands from Cloud Shell or your local machine if you have SDK installed.

Snapshots are copies of disks and are useful as backups and for copying data to other instances. Images are complete backups of a boot disk, so are used to create VMs. Snapshots made from a boot disk can also be used to create a VM.

The main command used to manage VMs is the `gcloud compute instances` command. `gcloud` uses a hierarchical structure to order the command elements. The command begins with `gcloud`, followed by a Google Cloud component, such as `compute` for Compute Engine, followed by an entity type such as `instances` or `snapshots`. An operation is then specified, such as `create`, `delete`, `list`, or `describe`.

GPUs can be attached to instances that have GPU libraries installed in the operating system. GPUs are used for compute-intensive tasks, such as building machine learning models.

Instance groups are groups of instances that are managed together. Managed instance groups have instances that are the same. These groups support load balancing and autoscaling.

## Exam Essentials

- **Understand how to navigate Cloud Console.**   Cloud Console is the graphical interface for working with Google Cloud. You can create, configure, delete, and list VM instances from the Compute Engine area of the console.
- **Understand how to install Cloud SDK.**   Cloud SDK allows you to configure default environment variables, such as a preferred zone, and issue commands from the command line. If you use Cloud Shell, Cloud SDK is already installed.
- **Know how to create a VM in the console and at the command line.**   You can specify machine type, choose an image, and configure disks with the console. You can use commands at the command line to list and describe, and you can find the same information in the console. Understand when to use customized images and how to deprecate them. Images are copies of contents of a disk, and they are used to create VMs. Deprecated marks an image as no longer supported.
- **Understand why GPUs are used and how to attach them to a VM.**   GPUs are used for compute-intensive operations; a common use case for using GPUs is machine learning. It is best to use an image that has GPU libraries installed. Understand how to determine which locations have GPUs available, because there are some restrictions. The CPU must be compatible with the GPU selected, and GPUs cannot be attached to shared memory machines. Know how GPU costs are charged.
- **Understand images and snapshots.**   Snapshots save the contents of disks for backup and data-sharing purposes. Images save the operating system and related configurations so that you can create identical copies of the instance.
- **Understand instance groups and instance group templates.**   Instance groups are sets of instances managed as a single entity. Instance group templates specify the configuration of an instance group and the instances in it. Managed instance groups support autoscaling and load balancing.

## Review Questions

You can find the answers in the Appendix.

1. Which page in Google Cloud Console would you use to create a single instance of a VM?
   1. Compute Engine
   2. App Engine
   3. Kubernetes Engine
   4. Cloud Functions
2. You view a list of Linux VM instances in the console. All have public IP addresses assigned. You notice that the SSH option is disabled for one of the instances. Why might that be the case?
   1. The instance is preemptible and therefore does not support SSH.
   2. The instance is stopped.
   3. The instance was configured with the No SSH option.
   4. The SSH option is never disabled.
3. You have noticed unusually slow response time when issuing commands to a Linux server, and you decide to reboot the machine. Which command would you use in the console to reboot?
   1. Reboot
   2. Reset
   3. Restart
   4. Shutdown followed by Startup
4. In the console, you can filter the list of VM instances by which of the following?
   1. Labels only
   2. Member of managed instance group only
   3. Labels, status, or deletion prevention
   4. Labels and status only
5. You will be building several machine learning models on an instance and attaching GPU to the instance. When you run your machine learning models they take an unusually long time to run. It appears that GPU is not being used. What could be the cause of this?
   1. GPU libraries are not installed.
   2. The operating system is based on Ubuntu.
   3. You do not have at least eight CPUs in the instance.
   4. There isn't enough persistent disk space available.
6. When you add a GPU to an instance, you must ensure that:
   1. The GPU and CPU choices are compatible.
   2. The instance is preemptible.
   3. The instance does not have nonboot disks attached.
   4. The instance is running Ubuntu 18.02 or later.
7. You are using snapshots to save copies of a 100 GB disk. You make a snapshot and then add 10 GB of data. You create a second snapshot. How much storage is used in total for the two snapshots (assume no compression)?
   1. 210 GB, with 100 GB for the first and 110 GB for the second
   2. 110 GB, with 100 GB for the first and 10 GB for the second
   3. 110 GB, with 110 GB for the second (the first snapshot is deleted automatically)
   4. 221 GB, with 100 GB for the first, 110 GB for the second, plus 10 percent of the second snapshot (11 GB) for metadata overhead
8. You have decided to delegate the task of making backup snapshots to a member of your team. What role would you need to grant to your team member to create snapshots?
   1. Compute Image Admin
   2. Storage Admin
   3. Compute Snapshot Admin
   4. Compute Storage Admin
9. The source of an image may be:
   1. Only disks
   2. Snapshots or disks only
   3. Disks, snapshots, or another image
   4. Disks, snapshots, or any database export file
10. You have built images using Ubuntu 18.04 and now want users to start using Ubuntu 20.04. You don't want to just delete images based on Ubuntu 18.04, but you want users to know they should start using Ubuntu 20.04. What feature of images would you use to accomplish this?
    1. Redirection
    2. Deprecated
    3. Unsupported
    4. Migration
11. You want to generate a list of VMs in your inventory and have the results in JSON format. What command would you use?
    1. `gcloud compute instances list`
    2. `gcloud compute instances describe`
    3. `gcloud compute instances list --format=json`
    4. `gcloud compute instances list --output=json`
12. You would like to understand details of how Google Cloud starts a virtual instance. Which optional parameter would you use when starting an instance to display those details?
    1. `--verbose`
    2. `--async`
    3. `--describe`
    4. `--details`
13. Which command will delete an instance named ch06-instance-3?
    1. `gcloud compute instances delete instance=ch06-instance-3`
    2. `gcloud compute instance stop ch06-instance-3`
    3. `gcloud compute instances delete ch06-instance-3`
    4. `gcloud compute delete ch06-instance-3`
14. You are about to delete an instance named `ch06-instance-1` but want to keep its boot disk. You do not want to keep other attached disks. What `gcloud` command would you use?
    1. `gcloud compute instances delete ch06-instance-1\ ––keep-disks=boot`
    2. `gcloud compute instances delete ch06-instance-1\ ––save-disks=boot`
    3. `gcloud compute instances delete ch06-instance-1\ ––keep-disks=filesystem`
    4. `gcloud compute delete ch06-instance-1 ––keep-disks=filesystem`
15. You want to view a list of fields you can use to sort a list of instances. What command would you use to see the field names?
    1. `gcloud compute instances list`
    2. `gcloud compute instances describe`
    3. `gcloud compute instances list --detailed`
    4. `gcloud compute instances describe –detailed`
16. You are deploying an application that will need to scale and be highly available. Which of these Compute Engine components will help achieve scalability and high availability?
    1. Preemptible instances
    2. Instance groups
    3. Cloud Storage
    4. GPUs
17. Before creating an instance group, what do you need to create?
    1. Instances in the instance group
    2. Instance template
    3. Boot disk image
    4. Source snapshot
18. How would you delete an instance group using the command line?
    1. `gcloud compute instances instance-template delete`
    2. `glcoud compute instance-templates delete`
    3. `gcloud compute delete instance-template`
    4. `gcloud compute delete instance-templates`
19. What can be the basis for scaling up an instance group?
    1. CPU utilization and operating system updates
    2. Disk usage and CPU utilization only
    3. Network latency, load balancing capacity, and CPU utilization
    4. Disk usage and operating system updates only
20. An architect is moving a legacy application to Google Cloud and wants to minimize the changes to the existing architecture while administering the cluster as a single entity. The legacy application runs on a load-balanced cluster that runs nodes with two different configurations. The two configurations are required because of design decisions made several years ago. The load on the application is consistent, so there is rarely a need to scale up or down. What Google Cloud Compute Engine resource would you recommended using?
    1. Preemptible instances
    2. Unmanaged instance groups
    3. Managed instance groups
    4. GPUs