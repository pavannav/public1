# 5

# Implementing Compute Solutions – Google Kubernetes Engine (Part 1)

This chapter aims to cover various compute solutions’ implementation.

We are going to cover the following main topics:

- Traditional application deployment versus containerized deployment
- Kubernetes architecture
- **Google Kubernetes Engine** (**GKE**) architecture

We are very excited to introduce the concept of container orchestration as I’m seeing an everyday increase in traction toward containers. Kubernetes and its native Google Cloud implementation GKE is a very sophisticated and innovative product on the market. We hope you will enjoy the journey with me.

# GKE

Kubernetes is an open source platform for managing containerized workloads declaratively for configuration and automation. The name *Kubernetes* originates from Greek and means helmsman or pilot.

Kubernetes is well known for its abbreviation—**K8s**. K8s stands for *K* in Kubernetes, 8 is the count between the letters *K* and *s*, and *s* is the last letter from the word *Kubernetes*.

Google open sourced Kubernetes in 2014, combining more than 15 years of Google experience running containerized workloads. Kubernetes originates from Borg, an internal tool for orchestrating containers at Google.

To learn more about the history of Borg and Kubernetes, visit the following link: <https://kubernetes.io/blog/2015/04/borg-predecessor-to-kubernetes/>.

GKE is a container orchestration platform. It is a managed service offered by Google Cloud that offers autoscaling and multi-cluster support.

The following section will talk about the differences between traditional, virtualized, and containerized deployments.

# Traditional versus virtualized versus container deployment

This section is dedicated to understanding fundamental containerization concepts and how they differ from the previous deployment options:

![Figure 5.1 – Various application deployment types__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_01.jpg)

Figure 5.1 – Various application deployment types

Let’s do a short review of different deployment types.

## Traditional deployment

For forever, we used servers to deploy various types of applications. We could deploy multiple applications on a single server or spread them out to utilize only one dedicated server. Unfortunately, this led to two situations:

- A single server with just one application was most of the time underutilized, and resources such as the server itself, power, cooling, and storage were wasted and not utilized properly.
- A single server with multiple applications installed could be utilized much better, but overall server performance was quite often slow due to resource contention. Numerous applications had to fight over the CPU cycle, RAM allocation, or network bandwidth.

These issues increased the number of servers we needed to deploy, manage, and operate.

## Virtualized deployment

Virtualization introduced many improvements in comparison to traditional deployment. It allowed the running of multiple **virtual machines** (**VMs**) on a single server with their operating system, securely isolating and deploying them faster than on the physical servers. Virtualization increased servers’ utilization and ease of management and reduced hardware costs.

## Container deployment

Containers are similar to VMs, but there is one significant difference. Containers don’t require an entire operating system and all libraries to run even the smallest application.

Containers are lightweight packages of the application packed with all necessary libraries, are portable, and are easy to update and manage.

In the next section, we will focus on the GKE architecture, which containers are a part of.

# GKE architecture

As we mentioned before, GKE is based on Kubernetes itself. We will briefly explain the core Kubernetes components and how they relate to GKE.

Because this book is aimed toward helping you ace the **Associate Cloud Engineer** (**ACE**) exam, we won’t explain how to build a CI/CD pipeline and deploy it to GKE. If you wish to learn about Kubernetes in much more detail, there are many fantastic books on the market.

## Kubernetes components

The central concept of Kubernetes is a cluster. As Kubernetes consists of multiple components, a diagram of Kubernetes architecture will allow us to understand its components and dependencies:

![Figure 5.2 – Kubernetes architecture__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_02.jpg)

Figure 5.2 – Kubernetes architecture

A cluster consists of a few elements, as outlined here:

- **Nodes**—Worker machines where we deploy containerized applications. A node has multiple components that interact with each other, as follows:
  - **kubelet**—This is an agent that runs on each node and makes sure that containers are running in a Pod.
  - **kube-proxy**—This is a network proxy that runs on each node in the cluster. It maintains network rules on nodes that allow network communication to Pods.
  - **Container runtime**—Kubernetes supports multiple runtimes such as containers, CRI-O, or any other Kubernetes **Container Runtime** **Interface** (**CRI**).
- **Pods**—Pods are hosted on worker nodes. They are the smallest deployable units of computing that can be created and managed in Kubernetes. A Pod can be a single container or a group of containers with shared storage and network resources. The control plane has multiple components that interact with each other, as follows:
  - **kube-apiserver**—This is an API server that is the frontend for the Kubernetes control plane.
  - **etcd**—A highly available, strongly consistent, distributed key-value store where all configuration, data, or state is stored.
  - **kube-scheduler**—This is a component used to schedule containers to run on a node.
  - **kube-controller-manager**—This is a control plane component that runs controller processes. It has several controllers included: a node controller (responsible for node unavailability), job controller (creates Pods), endpoint controller (populates endpoint objects), service account and token controllers (create default accounts and API access tokens for new namespaces).
  - **cloud-controller-manager**—The cloud controller manager component allows us to link clusters into the cloud provider API and separate the components that interact with the cloud platform from those that only interact with your cluster. On-premises Kubernetes doesn’t have this component.

To learn more about the Kubernetes concepts, please visit the following URL: <https://kubernetes.io/docs/concepts/overview/components/>.

## Google Kubernetes components

Google Kubernetes components are based on Kubernetes, but Google Cloud fully manages the control plane for us. Essentially, GKE consumers must deploy applications and configure GKE according to their needs.

## Storage in GKE

GKE offers several storage options for containerized applications running on GKE. On-disk files in containers are the simplest place for an application to write data, but it doesn’t solve the main problem. When the container stops or crashes, the files and data are lost. Besides that, some applications might require shared storage or even need to access the data from different containers running in the same Pod.

Kubernetes abstract block-based storage to Pods by introducing volumes, **persistent volumes** (**PVs**), and storage classes.

Before we dive into different storage components, we need to understand dependencies and how they construct GKE storage:

![Figure 5.3 – Kubernetes storage architecture__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_03.jpg)

Figure 5.3 – Kubernetes storage architecture

On the right side of the diagram, we have persistent disks, which we know from **Google Compute Engine** (**GCE**), and they are used as block storage for instances. Filestore, a managed Google Cloud **Network File System** (**NFS**) service, can be used as well as a storage option in GKE.

### Volumes

Volumes serve as storage units that containers within a Pod can access. Certain volume types rely on ephemeral storage, meaning they do not persist once the Pod is terminated. Examples of such ephemeral storage types include **emptyDir**, which can be used as temporary storage for applications. Similar to CPU and memory resources, we can manage local ephemeral storage resources. On the other hand, other volume types are supported as durable storage, providing long-term data persistence.

In essence, a volume can be understood as a directory that is available to every container within a Pod. A Pod defines the volumes it includes and the specific location where containers can access and utilize those volumes.

Let’s look at the different types of volumes:

- **emptyDir**—An **emptyDir** volume grants containers within a Pod access to an empty directory for reading and writing. It’s important to remember that when the Pod is removed from a node, regardless of the cause, the data stored within the **emptyDir** volume is permanently deleted. The medium on which the **emptyDir** volume resides is determined by the underlying infrastructure of the node, which could be a disk, SSD, or network storage, depending on the configuration. Utilizing emptyDir volumes proves beneficial when temporary storage space is needed or when data needs to be shared among multiple containers within a Pod.
- **ConfigMap**—A ConfigMap resource is used to inject configuration data into Pods. This data, stored within a ConfigMap object, can be accessed through a volume of type ConfigMap and subsequently utilized by files running within a Pod. The files contained within a ConfigMap volume are defined by a corresponding ConfigMap resource.
- **Secret**—A Secret volume is used to securely expose confidential information—including passwords, OAuth tokens, and SSH keys—to applications. The data stored within a Secret object can be accessed via a volume of type Secret and utilized by files executing within a Pod.
- **downwardAPI**—A downwardAPI volume, in simple words, is information about the Pod and container in which an application is running. By utilizing the downwardAPI, our application can retrieve valuable information about the Pod without requiring any knowledge of Kubernetes. This is made possible through the utilization of environment variables and files, which are sources of information that any software can reuse.
- **PersistentVolumeClaim** (**PVC**)—Cluster operators have the ability to utilize a PVC volume to allocate long-lasting storage for applications. By employing a PVC, a Pod can mount a volume that is supported by this durable storage.

### PVs

PV resources are used to manage durable storage in a cluster. In GKE, a PV is typically backed by a **persistent disk**. As an option, we can choose a managed NFS called Filestore.

Kubernetes manages the life cycle of a PV, and it can be dynamically provisioned; as resources, they exist independently of Pods.

### PVC

A PVC is a user’s request for storage, comparable to a Pod. While Pods consume resources on nodes, PVCs consume resources from PVs. Just as Pods can specify their desired resource levels, such as CPU and memory, PVCs can request specific sizes and access modes. Access modes determine whether the storage can be mounted as **ReadWriteOnce**, **ReadOnlyMany**, or **ReadWriteMany**.

### Access modes

PV resources support the following access modes:

- **ReadWriteOnce**—The volume can be mounted as read-write by a single Kubernetes node.
- **ReadOnlyMany**—The volume can be mounted as read-only by many Kubernetes nodes.
- **ReadWriteMany**—The volume can be mounted as read-write by many Kubernetes nodes. PV resources that are backed by GCE persistent disks don’t support this access mode.

### Reclaim policies

PVs can have various reclaim policies, including **Retain**, **Recycle**, and **Delete**. For all dynamically provisioned PVs, the default reclaim policy is **Delete**.

Let’s look at some reclaim policies and their actions:

- **Retain**—Manual reclamation
- **Recycle**—Data can be resorted after getting scrubbed
- **Delete**—Associated storage asset is deleted

We can take advantage of the reclaim policy and control how and when PVs are deleted.

### Storage classes

Configuration of volume implementations, such as the Compute Engine persistent disk or **Container Storage Interface** (**CSI**) driver, is accomplished using StorageClass resources.

By default, GKE generates a StorageClass that utilizes the balanced persistent disk type (**ext4**). This default StorageClass is applied when a PVC does not explicitly mention a StorageClassName. However, we have the flexibility to substitute the default StorageClass with our own customized version. For instance, these custom classes can be associated with different **quality-of-service** (**QoS**) levels or backup policies. In other storage systems, this concept is occasionally referred to as “profiles.”

Next, we will describe two GKE modes we can use—**GKE Standard** and **GKE Autopilot**.

## GKE Standard

As with a pure Kubernetes architecture, a cluster is the foundation of GKE.

GKE clusters consist of one or more **control planes** and multiple worker machines where the workload runs, called **nodes**. The control plane and nodes are the main components of the container orchestration system:

![Figure 5.4 – GKE standard architecture__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_04.jpg)

Figure 5.4 – GKE standard architecture

### Control plane

The control plane has many roles, such as Kubernetes API server, scheduler, and resource controller. Its life cycle is managed by GKE when the cluster is created, deleted, or upgraded.

### Nodes

Cluster nodes are called worker machines because the containers we schedule to run are deployed on worker nodes. Those worker nodes are Compute Engine VM instances managed by the GKE control plane.

Each worker node is managed by the control plane, receives updates, and reports its status to the control plane. Each node runs services that make up the whole cluster. For example, runtime and Kubernetes node agent **Kubelet**, which communicates with the control plane, starts and stops containers on the node.

The default node machine type is **e2-medium**, a cost-optimized machine type with shared cores that supports up to 32 vCPUs and 128 GB of memory. The default node type can be changed during the cluster creation process.

Each node runs a specialized operating system image to run the containers. At the time of writing, the following operating system images are available:

- Container-optimized OS with containerd (**cos\_containerd**)
- Ubuntu with containerd (**ubuntu\_containerd**)
- Windows **Long-Term Servicing Channel** (**LTSC**) with containerd (**windows\_ltsc\_containerd**)
- Container-Optimized OS with Docker (**cos**)—will be unsupported as of v1.24 of GKE
- Ubuntu with Docker (**ubuntu**)—will be deprecated as of v1.24 of GKE
- Windows LTSC with Docker (**windows\_ltsc**)

To view the most current list of available images, please visit the following URL: <https://cloud.google.com/kubernetes-engine/docs/concepts/node-images#available_node_images>.

Starting from GKE version 1.24, Docker-based images aren’t supported, and Google Cloud advises not to use them.

As the nodes themselves require CPU and RAM resources, it might be beneficial to check the available resources for the containers. The larger the node is, the more containers it can run. From the containers themselves, you can configure or limit their resource usage. To check available resources to run containers, we need to initiate the following command:

```
kubectl describe node NODE_NAME| grep Allocatable -B 7 -A 6
```

First, we need to get available nodes. This can be done by using the following command:

```
kubectl get nodes
```

The next screenshot shows the output of the previous command with details about the cluster, its version, and its age:

![Figure 5.5 – Output of the kubectl get nodes command__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_05.jpg)

Figure 5.5 – Output of the kubectl get nodes command

Once we have a node name, we can check the resources available to run containers, as follows:

![Figure 5.6 – Output of the command to check available resources to run containers on a node__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_06.jpg)

Figure 5.6 – Output of the command to check available resources to run containers on a node

This estimation doesn’t take into account the eviction threshold. Kubernetes allows the triggering of eviction if the available memory falls below a certain point. It can be defined as **memory.available<threshold** in %, or as a quantity—for example, **memory.available<10%** or **memory.available<1Gi**.

More details about eviction can be found on the Kubernetes website at the following URL: <https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/#eviction-thresholds>.

Tip

The total available memory for Pods can be calculated by using the following formula:

*ALLOCATABLE = CAPACITY - RESERVED -* *EVICTION-THRESHOLD*

Details about GKE reservations can be found at the following URL: <https://cloud.google.com/kubernetes-engine/docs/concepts/plan-node-sizes#memory_and_cpu_reservations>.

Now, let’s learn how GKE Standard differs from GKE in Autopilot mode.

## GKE Autopilot

Autopilot is a relatively new product from Google Cloud—it was released in February 2021.

Following this announcement, GKE now offers two modes of usage: Standard and Autopilot. We just discussed Standard mode, where we can configure multiple GKE options and fine-tune it to our liking. Autopilot mode, however, aims at delivering industry best practices and eliminates all node management operations, allowing a focus on application deployment:

![Figure 5.7 – GKE Autopilot architecture overview__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_07.jpg)

Figure 5.7 – GKE Autopilot architecture overview

In GKE Autopilot, there is no need to monitor the health of nodes or calculate the compute capacity of your cluster to accommodate workloads. You have the same Kubernetes experience as in Standard mode but with less operational overhead.

Google created a fantastic overview of features comparison between the two modes, and we highly encourage you to review the significant differences: <https://cloud.google.com/kubernetes-engine/docs/resources/autopilot-standard-feature-comparison>.

One big difference between the two modes is that Autopilot has a **service-level agreement** (**SLA**) that covers the GKE control plane (99.95%) and your Pods (99.9%), whereas GKE Standard has an SLA only for the control plane—99.5% SLA for zonal clusters and 99.95% for regional clusters. To gain insights into the GKE SLA, how various GKE deployment types influence the SLA, and which components it encompasses, please refer to the following URL: <https://cloud.google.com/kubernetes-engine/sla>.

While GKE Autopilot solves many operational burdens (monitoring, best practices, autoscaling, and many others), it has limitations that need to be considered when running workloads.

Some of GKE Autopilot’s limitations are listed as follows:

- Hardened configuration of Pods that provides enhanced security isolation. This means that Pods cannot run with elevated privileges, such as root access.
- Revokes permissions for utilizing highly privileged Kubernetes primitives such as privileged Pods, thereby restricting the ability to access, modify, or directly control the underlying node VM.
- Most external monitoring tools will not work due to removing necessary access. Native Google Cloud monitoring must be used in that case.
- We cannot create custom subnets. Subnets are used to divide our cluster’s network into smaller segments. In GKE Autopilot, subnets are created automatically based on the number of nodes in our cluster.
- We cannot use some Kubernetes networking features. Some Kubernetes networking features, such as NetworkPolicy and Ingress, are not supported in GKE Autopilot.

Those are just a few major limitations, and for production usage, we encourage you to visit the following link to read more: https://cloud.google.com/kubernetes-engine/docs/concepts/autopilot-overview#security-limitations.

# GKE management interfaces

GKE offers multiple management interfaces we can interact with. Google Cloud offers full capabilities in each of the interfaces. Upcoming parts of the chapter will guide us through both the CLI and the Cloud console experience of cluster management and configuration.

## Cloud Console

We already know Cloud Console from the previous chapter, where we worked heavily with Compute Engine and we worked with instances. The following screenshot shows two GKE clusters running in our project. The console looks familiar to GCE:

![Figure 5.8 – GKE in Cloud Console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_08.jpg)

Figure 5.8 – GKE in Cloud Console

We will show you how to deploy GKE Standard and GKE Autopilot in the upcoming section.

## Cloud Shell

Cloud Shell and its **gcloud** set of commands can be used to manage GKE together with Cloud Console. The **gcloud** command can be handy when you want to script and automate GKE-related tasks.

## Cloud SDK

Cloud SDK provides Cloud Client Libraries, allowing you to interact with GKE resources. SDK libraries are available in the following programming languages: Java, Go, Python, Ruby, PHP, C#, C++, and Node.js.

## kubectl

The primary tool for managing Kubernetes clusters is a tool called **kubectl**. It can be used on Windows, Linux, or macOS operating systems.

To install it on those operating systems, follow this guide: <https://kubernetes.io/docs/tasks/tools/>.

We are a big fan of Cloud Shell, which can be used directly from the browser, so we will show you how to use **kubectl** from Cloud Shell.

Here is the command we need to run to install it via the Google Cloud CLI component manager:

```
gcloud components install kubectl sudo apt-get install kubectl
```

Once installed, we can interact with Kubernetes clusters.

## Cluster management access configuration

As described in the *Kubernetes components* section, we interact with clusters using a YAML file called **kubeconfig** in the **$****HOME/.kube/config** directory.

You can create a cluster using the following command:

```
gcloud container clusters create my-cluster
```

Then, **kubeconfig** is added automatically to the **kubeconfig** file. Similar to the **gcloud** commands in [*Chapter 4*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_04.xhtml#_idTextAnchor080)*,* about GCE, **gcloud** might require a zone parameter —for example, **--zone=us-central1-a**.

If you operate more than one Kubernetes cluster, you can check which cluster is currently in context and switch between them, like so:

```
kubectl config current-context
```

In this case, the current context is empty, so we need to configure it, as follows:

![Figure 5.9 – Current kubectl context is not configured__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_09.jpg)

Figure 5.9 – Current kubectl context is not configured

To manage the Kubernetes cluster, we need to retrieve credentials. To receive them, we need to run the following **gcloud** command to list existing clusters:

```
gcloud container clusters list
```

The following screenshot shows us the output of the previous command:

![Figure 5.10 – List of existing GKE clusters__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_10.jpg)

Figure 5.10 – List of existing GKE clusters

We need to retrieve the credentials if we want to manage the cluster.

Run the following command:

```
gcloud container clusters get-credentials --zone=europe-west4-a CLUSTER_NAME
```

Once executed, we can finally list cluster components, as follows:

![Figure 5.11 – kubectl command output with a listing of cluster resources__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_11.jpg)

Figure 5.11 – kubectl command output with a listing of cluster resources

To view the current **kubectl** context, we run the command again:

```
kubectl config current-context
```

In this case, the current context was as follows:

```
gke_wmarusiak-book_europe-west6-a_gke-cluster-2
```

To switch context to another cluster, we need to run the following command:

```
kubectl config set-context CONTEXT_NAME
```

In our case, we ran the following:

```
kubectl config set-context gke-cluster-1
```

If we would like to rename the context, we can do this by executing the following command:

```
kubectl config rename-context OLD_CONTEXT_NAME NEW_CONTEXT_NAME
```

We used the following command:

```
kubectl config rename-context gke_wmarusiak-book_europe-west4-a gke-cluster-1 gke-cluster-1
```

In the next section, we will learn how to create our first GKE cluster using Cloud Shell and the command line.

# GKE Standard deployment

As with any other service in Google Cloud, the Kubernetes Engine API must be enabled before using the service. Once the API is enabled, we can proceed with our Kubernetes cluster creation. As mentioned, a GKE deployment can be created with two modes—Autopilot and Standard. We will choose the Standard mode, but we encourage you to try both ways during the learning phase.

## Cloud Console

We start with Cloud Console in GKE:

![Figure 5.12 – Initial GKE cluster creation selection popup__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_12.jpg)

Figure 5.12 – Initial GKE cluster creation selection popup

If you are still unsure which GKE cluster mode you should choose, the following screenshot will help you decide:

![Figure 5.13 – Shortened GKE cluster comparison__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_13.jpg)

Figure 5.13 – Shortened GKE cluster comparison

Both architectures were described in the previous section about GKE architecture. Now, proceed as follows:

1. In Cloud Console, we need to provide the name of the cluster.
2. A quite important decision is whether the GKE cluster deployment is zonal or regional, as described in the *GKE architecture* section. We will proceed with the zonal deployment:

![Figure 5.14 – GKE cluster basics (name and location type)__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_14.jpg)

Figure 5.14 – GKE cluster basics (name and location type)

1. In regional Standard GKE, we can specify default node locations. By selecting that field, we know where the control plane zone is:

![Figure 5.15 – GKE cluster basics (default node locations setting)__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_15.jpg)

Figure 5.15 – GKE cluster basics (default node locations setting)

1. In the **Control plane version** section, we can choose either the static or release channel control plane version:

![Figure 5.16 – GKE cluster basics (control plane version section)__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_16.jpg)

Figure 5.16 – GKE cluster basics (control plane version section)

1. Once we provide all cluster basics values, we can proceed with the node pools section.
2. As described in the *GKE architecture* section, the pool is the actual part of our GKE where containers will be running. There are many options to choose from when creating a default node pool.
3. GKE allows us to pick many operating system images to run on cluster nodes:

![Figure 5.17 – GKE node pool (image type selection)__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_17.jpg)

Figure 5.17 – GKE node pool (image type selection)

1. Machine configuration is an integral part of node pool creation. Once created, changing the node pool machine type is impossible. Creating a new node pool and migrating workloads is necessary to change the machine type:

![Figure 5.18 – GKE node pool (Machine configuration section)__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_18.jpg)

Figure 5.18 – GKE node pool (Machine configuration section)

1. In the **Networking** section, we can specify the **Maximum Pods per node** setting, network tags, and a range of node pool Pod addresses:

![Figure 5.19 – GKE node pool (Networking section settings)__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_19.jpg)

Figure 5.19 – GKE node pool (Networking section settings)

1. In the **Node security** section, we can specify the service account used by applications running on node pool VMs:

![Figure 5.20 – GKE node pool (security settings)__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_20.jpg)

Figure 5.20 – GKE node pool (security settings)

1. We can add labels and node taints in the **Node metadata** part of node pool creation:

![Figure 5.21 – GKE node pool (node metadata settings)__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_21.jpg)

Figure 5.21 – GKE node pool (node metadata settings)

1. After a few minutes, the Standard GKE cluster is operational and ready to receive containerized workloads:

![Figure 5.22 – GKE cluster successfully created__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_22.jpg)

Figure 5.22 – GKE cluster successfully created

In the next section, we’ll create GKE clusters using a CLI.

## Command line

The simplest command to create a GKE cluster is shown here:

```
gcloud container clusters create-auto second-gke-cluster --region=europe-west4
```

To use this command, you need a VPC with the default name, and the GKE cluster created using this command needs to be regional, not zonal, and be created in Autopilot mode.

The GKE cluster created with that simple yet effective command will have many default settings that can be changed later.

In the next section, we will learn how to deploy GKE using Autopilot mode.

# GKE Autopilot deployment

We already know what differentiates GKE Standard and Autopilot, and we will focus on GKE deployment in Autopilot mode.

## Cloud Console

Similar to standard GKE deployment, we need to click the **Create** button to start. As you will see in the screenshots and overall deployment flow, the deployment is much more simplified than with **Standard** mode, and this is a very good thing. We want an automated and simplified experience of running containerized applications in this mode. Follow these steps:

1. The first two pieces of information we need to provide are the cluster name and desired region:

![Figure 5.23 – GKE Autopilot initial configuration screen__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_23.jpg)

Figure 5.23 – GKE Autopilot initial configuration screen

1. We can choose a network access option in the Networking section. It can be either a public or private cluster, and we already know the implications from the architecture overview. We will select a public cluster for this deployment:

![Figure 5.24 – GKE Autopilot networking configuration screen__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_24.jpg)

Figure 5.24 – GKE Autopilot networking configuration screen

1. In the **Automation** section, we can enable the maintenance window. If not selected, cluster maintenance might run at any time:

![Figure 5.25 – GKE Autopilot automation configuration screen__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_25.jpg)

Figure 5.25 – GKE Autopilot automation configuration screen

1. We have options to enable Anthos Service Mesh, which is Google’s implementation of the powerful Istio open source project, and enable additional security options:

![Figure 5.26 – GKE Autopilot automation configuration screen (continued)__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_26.jpg)

Figure 5.26 – GKE Autopilot automation configuration screen (continued)

1. After a moment, GKE in Autopilot mode creation completes, and we can consume resources:

![Figure 5.27 – GKE Autopilot successful deployment__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_27.jpg)

Figure 5.27 – GKE Autopilot successful deployment

Let’s try deploying GKE in Autopilot mode using the CLI.

## Command line

As the Autopilot clusters are, by default, regional clusters, we need to provide the region and not the zone in the command itself.

The simplest command to create a GKE Autopilot cluster would be this:

```
gcloud container clusters create-auto CLUSTER_NAME --region REGION NAME --project=PROJECT_NAME
```

The command to create a cluster in the **europe-west4** region in the **wmarusiak-book** project looks like this:

```
gcloud container clusters create-auto gke-cluster-autopilot-2 --region europe-west4 --project=wmarusiak-book
```

Cluster creation takes a few minutes to deploy, and then we can immediately deploy an application.

We can run the following command to check whether the cluster was created:

```
gcloud container clusters list
```

After running the command, we receive information about the GKE cluster—its location, master version, master IP address, and much more:

![Figure 5.28 – GKE Autopilot successful deployment by using the CLI__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_28.jpg)

Figure 5.28 – GKE Autopilot successful deployment by using the CLI

The previous command provides more detailed information about the cluster itself. We know the GKE master, node version, machine type, and status.

To connect to the cluster, we need to use the following command:

```
gcloud container clusters get-credentials --region=REGION_NAME CLUSTER_NAME
```

Once run, the **kubectl** configuration file will be updated with newly created cluster credentials. The Cloud Shell configuration file is located in the following path: **.kube/config**.

Naturally, it can be viewed or edited with your preferable command-line file editor.

The configuration file contains the cluster certificate, name, and more information:

![Figure 5.29 – Fragment of the kubectl configuration file with cluster details__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_29.jpg)

Figure 5.29 – Fragment of the kubectl configuration file with cluster details

Once the cluster is created, it is ready to host new applications. In the next section, we will create and deploy a new application to the cluster.

# Working with applications

The beauty of Kubernetes is that applications developed, tested, and run on-premises can be moved to other Kubernetes environments without major refactoring. Of course, if you use a specific load balancer or storage type that isn’t available in GKE, you will need to adjust those settings.

In the next section, we will learn what Artifact Registry is, its features, and how it can make our life easier.

## Artifact Registry

Artifact Registry is a new product from Google Cloud that inherited features from **Google Container Registry** (**GCR**) and got some new features.

A container registry is a product that stores and manages Docker images and performs vulnerability analysis with fine-grained access control. You could easily integrate your CI/CD pipelines with it and store the images securely in a private repository.

Artifact Registry goes beyond GCR. Not only does it have the features of a container registry but also many others:

- Artifact storage from Google Cloud Build
- Artifact deployment to Google Cloud runtimes such as GKE, Cloud Run, Compute Engine, and App Engine flexible environments
- Software Delivery Shield offers end-to-end software supply chain security solutions

We have learned where we can store Docker images, so now it is time to deploy a sample application into our Google Kubernetes cluster.

## Deploying applications

We will guide you through a sample application deployment from the Google Cloud samples Docker repository. The Artifact Registry URL is the URL that you use to access Artifact Registry repositories. The URL is of the following form: **https://<REGION>-docker.pkg.dev/<PROJECT\_ID>/<REPOSITORY\_NAME>**

For example, the Artifact Registry URL for the **my-repository** repository in the **my-project** project in the **us-central1** region would be this: <https://us-central1-docker.pkg.dev/my-project/my-repository>.

You can use the Artifact Registry URL to push and pull images from Artifact Registry repositories. You can also use the URL to browse the contents of a repository.

We will run the **hello-app** Docker image from the **us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0** repository.

To run this application, we can use the following command:

```
kubectl create deployment hello-server --image=us-docker.pkg.dev/google-samples/containers/gke/hello-app:1.0
```

In the next screenshot, we can see the output of the previous command:

![Figure 5.30 – hello-app application deployed to GKE Autopilot cluster__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_30.jpg)

Figure 5.30 – hello-app application deployed to GKE Autopilot cluster

The application is deployed, and to use it, we need to expose it to the internet so that we can access it. We can do this by using the following command:

```
kubectl expose deployment hello-server --type LoadBalancer --port 80 --target-port 8080
```

We can check running Pods by using this command:

```
kubectl get pods
```

After running the command, we receive information about running Pods and their name, status, and age:

![Figure 5.31 – Pods running in the hello-app application__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_31.jpg)

Figure 5.31 – Pods running in the hello-app application

The last step is to find out the publicly accessible IP address of our application. To find this out, we should run the following command:

```
kubectl get service hello-server
```

In the next screenshot, we can see the output of the command with an external IP address that can be used to access the application:

![Figure 5.32 – Publicly available IP address of the hello-app application__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_32.jpg)

Figure 5.32 – Publicly available IP address of the hello-app application

The last step to access the **hello-app** application is to insert an external IP address into the browser:

![Figure 5.33 – hello-app application exposed on the internet__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 5_ Implementing Compute Solutions – Google Kubernetes Engine (Part 1) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_05_33.jpg)

Figure 5.33 – hello-app application exposed on the internet

After confirmation that the **hello-app** application works as expected, the final step is to delete it. To do so, we can use the following command:

```
kubectl delete service hello-server && kubectl delete deployment hello-server
```

After deleting the **hello-app** application with all its services, let’s focus on the different types of deployments we can use.

## Deployment

This is one of the easiest deployment types for an application, and it is mainly used for stateless applications or when we need a single Pod.

## ReplicaSet

A ReplicaSet deployment type is used when we want multiple instances of a Pod with a specified number of running Pods.

## StatefulSets

A StatefulSets deployment type is similar to Deployment because it uses a single image for Pods. StatefulSets, however, guarantees that when the application is scaled and when we add more Pods, each pod will be unique and have a unique identifier.

## DaemonSet

Similar to other deployment types, Daemons manage a group of replicated Pods. A DaemonSet is mainly used for application deployment with ongoing background tasks that must be run on certain nodes.

To learn more and get sample deployment types, we recommend visiting the Kubernetes website for a more detailed overview: <https://kubernetes.io/docs/concepts/workloads/controllers/>.

# Summary

The first chapter about GKE focused on the architecture, the main components, and how they work with each other. We learned about different types of GKE offerings in Google Cloud—GKE Standard and GKE Autopilot. Another important part of the chapter was about storage in GKE, which is very important to secure our data stored in Pods. An important lesson in this chapter was about the deployment of the two types of GKE clusters themselves and application deployment.

After learning which deployment types GKE and Kubernetes offer, we will learn how to view and manage GKE resources—clusters, node pools, Pods, and services in the next chapter.

# Questions

Answer the following questions to test your knowledge of this chapter:

1. What are the primary components of GKE?
   1. Master nodes and worker nodes
   2. Master nodes
   3. Worker nodes
   4. Dedicated nodes, worker nodes, and master nodes
2. Which of the following statements about Kubernetes is true?
   1. A node is used to monitor GKE clusters
   2. A node is used to host the GKE API
   3. A node cannot be scheduled on demand
   4. A node is the smallest unit of computing hardware in Kubernetes
3. Which of the following statements describes a Pod in Kubernetes?
   1. Pods can only run one container
   2. Pods are static
   3. Pods can be run on VMs
   4. A Pod is a group of one or more containers
4. Which operating system image can you run on a node in GKE based on version 1.23 and upward?
   1. Container-Optimized OS with containerd (**cos\_containerd**)
   2. Ubuntu with containerd (**ubuntu\_containderd**)
   3. Windows LTSC with containerd (**windows\_ltsc\_containerd**)
   4. All of these
5. Which **gcloud** namespace can be used to create a GKE cluster?
   1. **gcloud container** **clusters create**
   2. **gcloud clusters** **container create**
   3. **gcloud gke** **cluster create**
   4. **gke** **cluster create**
6. You have been tasked with the creation of a GKE cluster that delivers industry best practices and eliminates all node management operations, allowing you to focus on application deployment. Which GKE mode will you choose?
   1. GKE Standard
   2. GKE Autopilot
7. Which command would you use to connect to a GKE cluster?
   1. **gcloud clusters container get-credentials GKE\_CLUSTER\_NAME --region REGION\_NAME --****project PROJECT\_NAME**
   2. **gcloud connect gke get-credentials GKE\_CLUSTER\_NAME --region REGION\_NAME --****project PROJECT\_NAME**
   3. **gcloud container clusters get-credentials GKE\_CLUSTER\_NAME --region REGION\_NAME --****project PROJECT\_NAME**
   4. **kubectl** **connect GKE\_CLUSTER\_NAME**
8. Which product from Google Cloud can be used to store Docker images?
   1. Cloud Run
   2. Container Registry
   3. Cloud Shield
   4. Cloud Images
9. You have been tasked with deploying an application on GKE. You need to ensure that once the application is working, it will scale automatically, and the Pods will have unique identifiers. Which deployment type will you use?
   1. DaemonSet
   2. StatefulSet
   3. ReplicaSet
   4. Single Pod
10. Is it possible to change the node size from the node pool without recreating it?
    1. Yes
    2. No

# Answers

The answers to the preceding questions are provided here:

1A, 2D, 3D, 4D, 5A, 6B, 7C, 8B, 9B, 10B