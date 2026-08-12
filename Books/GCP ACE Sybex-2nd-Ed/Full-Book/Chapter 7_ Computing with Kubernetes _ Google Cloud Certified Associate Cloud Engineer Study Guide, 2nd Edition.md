---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **3.2 Deploying and implementing Google Kubernetes Engine resources**

---

This chapter introduces Kubernetes, a container orchestration system created and open sourced by Google. You will learn about the architecture of Kubernetes and the ways it manages workloads across nodes in a cluster. You will also learn how to manage Kubernetes resources with Cloud Console, Cloud Shell, and Cloud SDK. The chapter also covers how to deploy application pods (a Kubernetes structure) and monitor and log Kubernetes resources.

## Introduction to Kubernetes Engine

Kubernetes Engine is a Google Cloud–managed Kubernetes service. With this service, Google Cloud customers can create and maintain their own Kubernetes clusters without having to manage the Kubernetes platform. Google Kubernetes Engine is sometimes abbreviated as GKE.

Kubernetes runs containers on a cluster of virtual machines (VMs). It determines where to run containers, monitors the health of containers, and manages the full life cycle of VM instances. This collection of tasks is known as *container orchestration*.

It may sound as if a Kubernetes cluster is like an instance group, which was discussed in [Chapter 6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c06.xhtml), “Managing Virtual Machines.” There are some similarities, and in fact, GKE uses instance groups to manage the underlying VMs in a GKE cluster.

Containers offer a highly portable, lightweight means of distributing and scaling your applications or workloads, like VMs, without replicating the guest OS. They can start and stop much faster (usually in seconds) and use fewer resources. You can think of a container as similar to shipping containers for applications and workloads. Like shipping containers that can ride on ships, trains, and trucks without reconfiguration, application containers can be moved from development laptops to testing and production servers without reconfiguration. Instance groups have configurable monitoring and can restart instances that fail, but Kubernetes has much more flexibility with regard to maintaining a cluster of servers.

Let's look at Kubernetes architecture, which consists of several objects and a set of controllers.

Keep in mind that when you use Kubernetes Engine, you will manage Kubernetes and your applications and workloads running in containers on the Kubernetes platform.

### Kubernetes Cluster Architecture

A Kubernetes cluster consists of a control plane and one or more worker machines called nodes. The control plane manages the cluster and can be replicated and distributed for high availability and fault tolerance.

The control plane manages services provided by Kubernetes, such as the Kubernetes API, controllers, and schedulers. All interactions with the cluster are done through the control plane using the Kubernetes API. The control plane issues the command that performs an action on a node. Users can also interact with a cluster using the `kubectl` command.

The basic components of Kubernetes are:

- API Server, which is a component of the control plane that exposes the Kubernetes API
- Scheduler, a control plane component that assigns pods to nodes
- Controller Manager, a control plane component that manages resource controllers, such as node controller, job controller, and service account controller
- etcd, a highly available key-value store
- Kubelet, an agent that runs on each node in a cluster
- Container Runtime, the software responsible for running containers
- Kube-proxy, a network proxy that runs on each node in the cluster

Nodes execute the workloads run on the cluster. Nodes are VMs that run containers configured to run an application. Nodes are primarily controlled by the control plane, but some commands can be run manually. The nodes run an agent called *kubelet*, which is the service that communicates with the control plane.

When you create a GKE cluster, you can specify a machine type. These VMs run specialized operating systems optimized to run containers. Some of the memory and CPU is reserved for Kubernetes and so is not available to applications running on the node.

Kubernetes organizes processing into workloads. There are several organizing objects that make up the core functionality of how Kubernetes processes workloads.

### Kubernetes Objects

Workloads are distributed across nodes in a Kubernetes cluster. To understand how work is distributed, it is important to understand some basic concepts, in particular the following:

- Pods
- Services
- Deployments
- ReplicaSets
- StatefulSets
- Job
- Volumes
- Namespaces
- Node pools

Each of these objects contributes to the logical organization of workloads.

#### Pods

Pods are single instances of a running process in a cluster. Pods contain at least one container. They often run a single container but can run multiple containers. Multiple containers are used when two or more containers must share resources or are tightly coupled. Pods also use shared networking and storage across containers. Each pod gets a unique IP address and a set of ports. Containers connect to a port. Multiple containers in a pod connect to different ports and can talk to each other on localhost. This structure is designed to support running one instance of an application within the cluster as a pod. A pod allows its containers to behave as if they are running on an isolated VM, sharing common storage, one IP address, and a set of ports. By doing this, you can deploy multiple instances of the same application, or different instances of different applications on the same node or different nodes, without having to change their configuration.

Pods treat the multiple containers as a single entity for management purposes.

Pods are generally created in groups. Replicas are copies of pods and constitute a group of pods that are managed as a unit. Pods support autoscaling as well. Pods are considered ephemeral; that is, they are expected to terminate. If a pod is unhealthy—for example, if it is stuck in a waiting mode or crashing repeatedly—it is terminated. The mechanism that manages scaling and health monitoring is known as a *controller*.

#### Services

Since pods are ephemeral and can be terminated by a controller, other services that depend on pods should not be tightly coupled to particular pods. For example, even though pods have unique IP addresses, applications should not depend on that IP address to reach an application. If the pod with that address is terminated and another is created, it may have another IP address. The IP address may be reassigned to another pod running a different container.

Kubernetes provides a level of indirection between applications running in pods and other applications that call them: it is called a *service*. A service, in Kubernetes terminology, is an object that provides API endpoints with a stable IP address that allow applications to discover pods running a particular application. Services update when changes are made to pods, so they maintain an up-to-date list of pods running an application.

#### Deployments

Another important concept in Kubernetes is the deployment. Deployments are sets of identical pods. The members of the set may change as some pods are terminated and others are started, but they are all running the same application. The pods all run the same application because they are created using the same pod template.

A *pod template* is a definition of how to run a pod. The description of how to define the pod is a *pod specification*. Kubernetes uses this definition to keep a pod in the state specified in the template. That is, if the specification has a minimum number of pods that should be in the deployment and the number falls below that, then additional pods will be added to the deployment by calling on a ReplicaSet.

#### ReplicaSets

A ReplicaSet is a controller used by a deployment that ensures the correct number of identical pods are running. For example, if a pod is determined to be unhealthy, a controller will terminate that pod. The ReplicaSet will detect that not enough pods for that application or workload are running and will create another. ReplicaSets are also used to update and delete pods. In general, it is a good practice to use deployment rather than ReplicaSets unless you require custom update orchestration or do not require any updates at all.

#### StatefulSets

Deployments are well suited to stateless applications. Those are applications that do not need to keep track of their state. For example, an application that calls an API to perform a calculation on the input values does not need to keep track of previous calls or calculations. An application that calls that API may reach a different pod each time it makes a call. There are times, however, when it is advantageous to have a single pod respond to all calls for a client during a single session.

StatefulSets are like deployments, but they assign unique identifiers to pods. This enables Kubernetes to track which pod is used by which client and keep them together. StatefulSets are used when an application needs a unique network identifier or stable persistent storage.

#### Jobs

A job is an abstraction about a workload. Jobs create pods and run them until the application completes a workload. Job specifications are specified in a configuration file and include specifications about the container to use and what command to run.

#### Volumes

Volumes are a storage mechanism provided by Kubernetes. Volumes store data independently of the life of a pod. If a pod fails and is restarted, the contents of a volume attached to the failed pod will continue to exist after the pod is restarted, and that volume will be attached to the new instance of the pod. This ensures that if a pod crashes or restarts, data saved to a volume will be available for the replacement pod. Volumes are also used to share files across containers running in a pod.

#### Namespaces

A namespace is a logical abstraction for separating groups of resources in a cluster. Namespaces are used when clusters host a variety of projects, teams, or other groups that may have different policies or requirements for using cluster resources. Kubernetes creates a default namespace, which is used for objects with no other namespace defined. Kubernetes also creates namespaces for administering the cluster.

#### Node Pools

A node pool is a set of nodes in a cluster that have the same configuration. When the cluster is first created, all nodes are in the same node pool. You can add other nodes and node pools after the cluster is created. Node pools are useful if you want to group nodes with similar features, such as nodes that run on preemptible virtual machines. A node pool of preemptible VMs would allow you to assign some workloads to nodes on those preemptible while preventing other workloads from running on them.

Now that you're familiar with how Kubernetes is organized and how workloads are run, we'll cover how to deploy a Kubernetes cluster using Kubernetes Engine.

## Deploying Kubernetes Clusters

Kubernetes clusters can be deployed using either Cloud Console or the command line in Cloud Shell, or your local environment if Cloud SDK is installed.

### Deploying Kubernetes Clusters Using Cloud Console

To use Kubernetes Engine, you will need to enable the Kubernetes Engine API. Once you have enabled the API, you can navigate to the Kubernetes Engine page in Cloud Console. [Figure 7.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#c07-fig-0001) shows the Overview page.

When you create a cluster, you will have the option to create the cluster in standard mode or autopilot mode. In standard mode you pay for the cluster resources you provision, manage the node infrastructure, and determine the configuration of the nodes. In autopilot mode, GKE manages the cluster and node infrastructure and you pay only for the resources used when your applications are running. Autopilot mode clusters use preconfigured and optimized cluster configurations (see [Figure 7.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#c07-fig-0002)). Autopilot is the recommended mode for using GKE.

![Snapshot of the Overview page of the Kubernetes Engine section of Cloud Console](../images/c07f001.png)


[**FIGURE 7.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#R_c07-fig-0001) The Overview page of the Kubernetes Engine section of Cloud Console

![Snapshot of when creating a GKE, you specify standard mode or autopilot mode.](../images/c07f002.png)


[**FIGURE 7.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#R_c07-fig-0002) When creating a GKE, you specify standard mode or autopilot mode.

When you click an autopilot cluster, GKE will automatically manage and configure node infrastructure, VPC-native traffic routing for public and private clusters, use Shielded GKE nodes, as well as logging and monitoring. You will specify a cluster name, cluster description, and a region. You also specify if the cluster is private or public. In private clusters, nodes only have private IP addresses and all communication between the control plane and node are via private addresses only. See [Figure 7.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#c07-fig-0003).

![Snapshot of creating an autopilot GKE cluster](../images/c07f003.png)


[**FIGURE 7.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#R_c07-fig-0003) Creating an autopilot GKE cluster

Expanding the Networking Options area in the Create An Autopilot Cluster page shows additional network configurations, as you can see in [Figure 7.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#c07-fig-0004). You can enable control plane–authorized networks to block nontrusted non–Google Cloud source IP addresses from accessing the control plane using HTTPS. You can also specify a network, node subnet, and address ranges for pods and services. When specifying address ranges, you use CIDR notation; for example, 192.168.0.0/16.

![Snapshot of networking options in autopilot mode](../images/c07f004.png)


[**FIGURE 7.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#R_c07-fig-0004) Networking options in autopilot mode

In the Advanced Options area in the Create An Autopilot Cluster page, you can specify a maintenance window to specify a time for running routine Kubernetes maintenance operations. By default, these operations can run at any time. You can also enable security features, including Google Groups for RBAC, to grant roles to members of a Google Workspace Group, application-layer secrets encryption to encrypt secrets stored in etcd (part of the control plane), and enable the use of a customer-managed key to encrypt the boot disk of nodes. You can add labels and a description to the cluster. See [Figure 7.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#c07-fig-0005).

From the listing of clusters, you can edit, delete, and connect to a cluster. When you click Connect, you receive a `gcloud` command to connect to the cluster from the command line. You also have the option of viewing the Workloads page, as shown in [Figure 7.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#c07-fig-0006).

When you choose to configure a standard mode cluster using the cloud console, you will see a form like that shown in [Figure 7.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#c07-fig-0007). You will specify a name and location of the cluster. If you choose to create a zonal cluster, the location will be a zone. If you choose to create a regional cluster, the location will be a region. Regional clusters by default have nodes in three zones, but you can specify default node locations if you want to specify specific zones to run nodes.

By default, clusters are created with a release channel configuration, which enables automatic upgrading of the cluster software. If you want more control over the upgrade process, you can choose to configure a static channel. See [Figure 7.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#c07-fig-0007).

![Snapshot of advanced options in autopilot mode](../images/c07f005.png)


[**FIGURE 7.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#R_c07-fig-0005) Advanced options in autopilot mode

![Snapshot of once the autopilot clusters are deployed, it will be listed on the GKE page of the console.](../images/c07f006.png)


[**FIGURE 7.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#R_c07-fig-0006) Once the autopilot clusters are deployed, it will be listed on the GKE page of the console.

![Snapshot of initial steps to configure a standard cluster](../images/c07f007.png)


[**FIGURE 7.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#R_c07-fig-0007) Initial steps to configure a standard cluster

### Deploying Kubernetes Clusters Using Cloud Shell and Cloud SDK

Like other Google Cloud services, Kubernetes Engine can be managed using the command line. The basic command for working with Kubernetes Engine is the following `gcloud` command:

```
gcloud container
```

This `gcloud` command has many parameters, including the following:

- Project
- Zone
- Machine type
- Image type
- Disk type
- Disk size
- Number of nodes

A basic command for creating a standard mode cluster looks like this:

```
gcloud container clusters create cluster1 --num-nodes=3 --region=us-central1
```

There are a large number of parameters for the `gcloud container clusters create` command that allow you to specify many different configurations for a cluster. For details on the parameters, visit `https://cloud.google.com/sdk/gcloud/reference/container/clusters/create`.

The command `gcloud container clusters create-auto` is used to create autopilot mode GKE clusters.

## Deploying Application Pods

Now that you have created a cluster, let's deploy an application.

From the Clusters page of Kubernetes Engine on Cloud Console, select Create Deployment. A form such as the one in [Figure 7.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#c07-fig-0008) appears. Use this form to specify the following:

- Container image
- Environment variables
- Initial command

After specifying the initial parameters, you can continue to add configuration parameters (see [Figure 7.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#c07-fig-0009)):

- Application name
- Namespace
- Labels
- Cluster

![Snapshot of the Create Deployment option provides a form to specify a container to run and an initial command to start the application running.](../images/c07f008.png)


[**FIGURE 7.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#R_c07-fig-0008) The Create Deployment option provides a form to specify a container to run and an initial command to start the application running.

![Snapshot of configuring a deployment](../images/c07f009.png)


[**FIGURE 7.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#R_c07-fig-0009) Configuring a deployment

Once you have specified a deployment, you can display the corresponding YAML specification, which can be saved and used to create deployments from the command line. The core elements of the Kubernetes template include `apiVersion`, `kind`, `metadata`, and `spec`. [Listing 7.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#c07-fea-0001) shows an example deployment YAML file. The output is always displayed in YAML format.


---

**[Listing 7.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml#R_c07-fea-0001)** Sample YAML configuration specification for a deployment

```
apiVersion: "apps/v1" kind: "Deployment"
 metadata:
   name: "nginx-1" namespace: "default"
   labels:
     app: "nginx-1" spec:
   replicas: 3 selector:
     matchLabels:
       app: "nginx-1" template:
     metadata:
       labels:
         app: "nginx-1" spec:
       containers:
       - name: "nginx-1" image: "nginx:latest"
 ---
 apiVersion: "autoscaling/v2beta1" kind: "HorizontalPodAutoscaler"
 metadata:
   name: "nginx-1-hpa-5fkn" namespace: "default"
   labels:
     app: "nginx-1" spec:
   scaleTargetRef:
     kind: "Deployment" name: "nginx-1"
     apiVersion: "apps/v1" minReplicas: 1
   maxReplicas: 5 metrics:
    - type: "Resource" resource:
       name: "cpu" targetAverageUtilization: 80
```

---

In addition to installing Cloud SDK, you will need to install the Kubernetes command-line tool kubectl to work with clusters from the command line. You can do this with the following command:

```
gcloud components install kubectl
```

You can then use kubectl to run a Docker image on a cluster by using the `kubectl run` command. To run a container within a deployment, use the create deployment command. Here's an example:

```
kubectl create deployment app-deploy1 --image=app1 --port=8080
```

This will run a Docker image called `app1` and make its network accessible on port 8080. If after some time you'd like to scale up the number of replicas in the deployment, you can use the `kubectl scale` command:

```
kubectl scale deployment app-deploy1 --replicas=5
```

This example would create five replicas.

## Monitoring Kubernetes

Cloud Operations Suite is Google Cloud's comprehensive monitoring, logging, and alerting product and includes Cloud Monitoring and Cloud Logging services, which can be used to monitor Kubernetes clusters.

GKE provides for multiple sources of application and system performance metrics, including System metrics, Managed Service for Prometheus, and Workload metrics. System metrics describe low-level cluster resources such as CPUs, memory, and storage. Prometheus is a widely used open source system for collecting performance metrics. The Managed Service for Prometheus is a service provided by Google Cloud for customers who want to use Prometheus but who do not want to manage the infrastructure and applications that make up Prometheus. Workload metrics are a set of deprecated metrics exposed by GKE workloads.

When you create a cluster, you can indicate that metrics be sent to Cloud Monitoring and logs be sent to Cloud Logging. Both are enabled by default.

## Summary

Kubernetes Engine is a container orchestration system for deploying applications to run in clusters. Kubernetes is architected with a single cluster manager and worker nodes.

Kubernetes uses the concept of pods, or instances running a container. It is possible to run multiple containers in a pod, but this is usually only done when the two containers are tightly coupled. ReplicaSets are controllers for ensuring that the correct number of pods are running. Deployments are sets of identical pods. StatefulSets are a type of deployment used for stateful applications.

Kubernetes clusters can be deployed through Cloud Console or by using `gcloud` commands. You deploy applications by bundling the application in a container and using the console or the `kubectl` command to create a deployment that runs the application on the cluster.

Cloud Operations Suite includes Cloud Monitoring and Cloud Logging, which is used to monitor instances in clusters.

## Exam Essentials

- **Understand that Kubernetes is a container orchestration system.**   Kubernetes Engine is a Google Cloud product that provides Kubernetes to Google Cloud customers. Kubernetes manages containers that run in a set of VM instances.
- **Understand that Kubernetes uses a control plane to manage nodes and workloads.**   Kubernetes uses the control plane to coordinate execution and monitor the health of pods. If there is a problem with a pod, the control plane can correct the problem and reschedule the disrupted job.
- **Be able to describe pods.**   Pods are single instances of a running process, services provide a level of indirection between pods and clients calling services in the pods, a ReplicaSet is a kind of controller that ensures that the right number of pods are running, and a deployment is a set of identical pods.
- **Kubernetes can be deployed using Cloud Console or using `gcloud` commands.**   `gcloud` commands manipulate the Kubernetes Engine service, whereas `kubectl` commands are used to manage the internal state of clusters from the command line. The base command for working with Kubernetes Engine is `gcloud container`. Note that `gcloud` and `kubectl` have different command syntaxes. `kubectl` commands specify a verb and then a resource, as in `kubectl scale deployment …`, whereas `gcloud` specifies a resource before the verb, as in `gcloud container clusters create`. Deployments are created using Cloud Console or at the command line using a YAML specification.
- **Be able to define Kubernetes objects.**   Deployments are sets of identical pods. StatefulSets are a type of deployment used for stateful applications. Kubernetes is monitored using Cloud Operations. Cloud Operations can be configured to generate alerts and notify you on a variety of channels. To monitor the state of a cluster, you can create a policy that monitors a metric, like CPU utilization, and have notifications sent to email or other channels.

## Review Questions

You can find the answers in the Appendix.

1. A new engineer is asking for clarification about when it is best to use Kubernetes and when to use instance groups. You point out that Kubernetes uses instance groups. What purpose do instance groups play in a Kubernetes cluster?
   1. They monitor the health of instances.
   2. They create pods and deployments.
   3. They create sets of VMs that can be managed as a unit.
   4. They create alerts and notification channels.
2. What components are required in a Kubernetes cluster?
   1. A control plane and nodes to execute workloads.
   2. A control plane, nodes to execute workloads, and monitoring nodes to monitor node health.
   3. Kubernetes nodes; all instances are the same.
   4. Instances with at least six vCPUs.
3. What is a pod in Kubernetes?
   1. A set of containers
   2. Application code deployed in a Kubernetes cluster
   3. A single instance of a running application in a cluster
   4. A controller that manages communication between clients and Kubernetes services
4. You have developed an application that calls a service running in a Kubernetes cluster. The service runs in pods that can be terminated if they are unhealthy and replaced with other pods that might have a different IP address. How should you code your application to ensure it functions properly in this situation?
   1. Query Kubernetes for a list of IP addresses of pods running the service you use.
   2. Communicate with Kubernetes Services so that applications do not have to be coupled to specific pods.
   3. Query Kubernetes for a list of pods running the service you use.
   4. Use a `gcloud` command to get the IP addresses needed.
5. You have noticed that an application's performance has degraded significantly. You have recently made some configuration changes to resources in your Kubernetes cluster and suspect that those changes have altered the number of pods running in the cluster. Where would you look for details on the number of pods that should be running?
   1. Deployment config
   2. Cloud Operations Suite
   3. Container Runtime
   4. Jobs
6. You are deploying a high-availability application in Kubernetes Engine. You want to maintain availability even if there is a major network outage in a data center. What feature of Kubernetes Engine would you employ?
   1. Multiple instance groups
   2. Regional cluster
   3. Regional deployments
   4. Load balancing
7. You want to write a script to deploy a Kubernetes cluster with GPUs. You have deployed clusters before, but you are not sure about all the required parameters. You need to deploy this script as quickly as possible. What is one way to develop this script quickly?
   1. Use the GPU template in the Kubernetes Engine cloud console to generate the `gcloud` command to create the cluster.
   2. Search the web for a script.
   3. Review the documentation on `gcloud` parameters for adding GPUs.
   4. Use an existing script and add parameters for attaching GPUs.
8. What `gcloud` command will create a cluster named `ch07-cluster-1` with four nodes?
   1. `gcloud container clusters create ch07-cluster-1 --num-nodes=4`
   2. `gcloud container clusters create ch07-cluster-1 --size=4`
   3. `gcloud container clusters create ch07-cluster-1 --region-nodes=4`
   4. `gcloud beta container clusters create ch07-cluster-1 4`
9. When using Create Deployment from Cloud Console, which of the following cannot be specified for a deployment?
   1. Container image
   2. Application name
   3. Time to Live (TTL)
   4. Initial command
10. Deployment configuration files created in Cloud Console use what type of file format?
    1. CSV
    2. YAML
    3. TSV
    4. JSON
11. What command is used to run a Docker image on a cluster?
    1. `gcloud container run`
    2. `gcloud container clusters run`
    3. `kubectl run`
    4. `kubectl container run`
12. What command would you use to have 10 replicas of a deployment named `ch07-app-deploy`?
    1. `kubectl upgrade deployment ch07-app-deploy --replicas=5`
    2. `gcloud containers deployment ch07-app-deploy --replicas=5`
    3. `kubectl scale deployment ch07-app-deploy --replicas=10`
    4. `kubectl scale deployment ch07-app-deploy --pods=5`
13. Cloud Operations Suite is used for what operations on Kubernetes clusters?
    1. Notifications only
    2. Monitoring and notifications only
    3. Logging only
    4. Notifications, monitoring, and logging
14. You want to use Cloud Logging and Cloud Monitoring with your GKE clusters. What must you do to enable this when creating a cluster?
    1. Specify the --`monitoring=True` and `--logging=True` parameters in the `gcloud container create cluster` command.
    2. Create a node pool and configure it for monitoring and logging.
    3. Create a namespace and configure it for monitoring and logging.
    4. Nothing; metrics and logs are sent to Cloud Logging and Cloud Monitoring by default.
15. What popular open source monitoring tool is available in Google Cloud as a managed service?
    1. Prometheus
    2. Apache Flink
    3. MongoDB
    4. Spark
16. You want to create a Kubernetes Engine cluster and want to minimize the amount of configuring and infrastructure management. What kind of cluster would you create?
    1. Standard mode cluster
    2. Autopilot mode cluster
    3. Minimal mode cluster
    4. Template mode cluster
17. You want the greatest degree of control over your Kubernetes cluster. What kind of cluster would you create?
    1. Standard mode cluster
    2. Autopilot mode cluster
    3. Minimal mode cluster
    4. Template mode cluster
18. You want to create a Kubernetes cluster, but you do not want GKE to automatically upgrade the cluster. How would you configure the cluster?
    1. With a release channel
    2. With a static channel
    3. With multiple node pools
    4. With a ReplicaSet
19. You are attempting to execute commands to initiate a deployment on a Kubernetes cluster. The commands are not having any effect. You suspect that a Kubernetes component is not functioning correctly. What component could be the problem?
    1. The Kubernetes API
    2. A StatefulSet
    3. Cloud SDK `gcloud` commands
    4. ReplicaSet
20. You have deployed an application to a Kubernetes cluster. You have noticed that several pods are starved for resources for a period of time and the pods are shut down. When resources are available, new instantiations of those pods are created. Clients are still able to connect to pods even though the new pods have different IP addresses from the pods that were terminated. What Kubernetes component makes this possible?
    1. Services
    2. ReplicaSet
    3. Alerts
    4. StatefulSet