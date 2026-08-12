---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVE OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **4.2 Managing Google Kubernetes Engine resources**

---

This chapter describes how to perform basic Kubernetes management tasks, including the following:

- Viewing the status of Kubernetes clusters
- Viewing image repositories and image details
- Adding, modifying, and removing nodes
- Adding, modifying, and removing pods
- Adding, modifying, and removing services

You'll see how to perform each of these tasks using Google Cloud Console and Cloud SDK, which you can use locally on your development machines, on Google Cloud virtual machines, and by using Cloud Shell.

## Viewing the Status of a Kubernetes Cluster

Assuming you have created a cluster using the steps outlined in [Chapter 7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c07.xhtml), “Computing with Kubernetes,” you can view the status of a Kubernetes cluster using either Google Cloud Console or the `gcloud` commands.

### Viewing the Status of Kubernetes Clusters Using Cloud Console

Starting from the Cloud Console home page, open the navigation menu by clicking the three stacked lines icon in the upper-left corner. This displays the list of Google Cloud services, as shown in [Figure 8.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0001).

![Snapshot of navigation menu in Google Cloud Console](../images/c08f001.png)


[**FIGURE 8.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0001) Navigation menu in Google Cloud Console

Select Kubernetes Engine from the lists of services to open the submenu shown in [Figure 8.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0002).

![Snapshot of selecting Kubernetes Engine from the navigation menu](../images/c08f002.png)


[**FIGURE 8.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0002) Selecting Kubernetes Engine from the navigation menu

### Pinning Services to the Top of the Navigation Menu

In [Figure 8.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0002), Kubernetes Engine has been *pinned* so it is displayed at the top. You can pin any service in the navigation menu by mousing over the product and clicking the pin icon that appears, as shown in [Figure 8.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0003). In that figure, Compute Engine and Kubernetes Engine are already pinned, and Cloud Functions can be pinned by clicking the gray pin icon.

![Snapshot of pinning a service to the top of the navigation menu](../images/c08f003.png)


[**FIGURE 8.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0003) Pinning a service to the top of the navigation menu

After clicking Kubernetes Engine in the navigation menu, you will see a list of running clusters, as shown in [Figure 8.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0004), which shows a single cluster called `standard-cluster-1`.

![Snapshot of example list of clusters in Kubernetes Engine](../images/c08f004.png)


[**FIGURE 8.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0004) Example list of clusters in Kubernetes Engine

Hover over the name of the cluster to highlight it, as in [Figure 8.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0005), and click the name to display details of the cluster, as shown in [Figure 8.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0006).

![Snapshot of click the name of a cluster to display its details.](../images/c08f005.png)


[**FIGURE 8.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0005) Click the name of a cluster to display its details.

![Snapshot of the first part of the cluster Details page describes the configuration of the cluster.](../images/c08f006.png)


[**FIGURE 8.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0006) The first part of the cluster Details page describes the configuration of the cluster.

Clicking the Nodes option shows details of node pools and replicas (see [Figure 8.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0007)). In the Node Pools section, you will see the number of nodes, machine type, image type and other attributes. In the Nodes section, you will see nodes and their status, requested and allocatable CPUs, memory, and storage.

![Snapshot of add-on and permission details for a cluster](../images/c08f007.png)


[**FIGURE 8.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0007) Add-on and permission details for a cluster

[Figure 8.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0008) shows example details of node pools, which are separate instance groups running in a Kubernetes cluster. The details in this section include the node image running on the nodes, the machine type, the total number of vCPUs (listed as Total Cores), the disk type, and whether the nodes are preemptible.

Below the name of the cluster is a horizontal list of several options: Details, Nodes, Storage, Observability and Logs. So far, we have described the contents of the Details page. Click Storage to display information like that shown in [Figure 8.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0009), which displays persistent volumes and the storage classes used by the cluster.

This cluster does not have persistent volumes but uses standard storage. Persistent volumes are durable disks that are managed by Kubernetes and implemented using Compute Engine persistent disks. A storage class is a type of storage with a set of policies specifying quality of service, backup policy, and a provisioner (which is a service that implements the storage).

![Snapshot of details about node pools in the cluster](../images/c08f008.png)


[**FIGURE 8.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0008) Details about node pools in the cluster

The Observability section shows metrics about cluster performance. Under the Logs option of the cluster status menu, you can see a log of messages, as shown in [Figure 8.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0010).

Click the name of one of the nodes to see detailed status information, as shown in [Figure 8.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0011). The node details include CPU utilization, memory consumption, and disk I/O. There is also a list of pods running on the node.

Click the name of a pod to see its details. The pod display is similar to the node display, with CPU, memory, and disk statistics. Configuration details include when the pod was created, the labels assigned, links to logs, and the status (which is shown as Running in [Figure 8.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0012)).

Other possible statuses are Pending, which indicates the pod is downloading images; Succeeded, which indicates the pod terminated successfully; Failed, which indicates at least one container failed; and Unknown, which means the control plane cannot reach the node and status cannot be determined.

At the bottom of the pod display is a list of containers running. Click the name of a container to see its details. [Figure 8.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0013) shows the details of a Pod. Information includes the status, the start time, the command that is running, and the volumes mounted.

![Snapshot of storage information about a cluster](../images/c08f009.png)


[**FIGURE 8.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0009) Storage information about a cluster

![Snapshot of log of nodes in the cluster](../images/c08f010.png)


[**FIGURE 8.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0010) Log of nodes in the cluster

![Snapshot of example details of a node running in a Kubernetes cluster](../images/c08f011.png)


[**FIGURE 8.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0011) Example details of a node running in a Kubernetes cluster

![Snapshot of pod status display, with the status Running](../images/c08f012.png)


[**FIGURE 8.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0012) Pod status display, with the status Running

![Snapshot of details of a container running in a pod](../images/c08f013.png)


[**FIGURE 8.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0013) Details of a pod running on a node

Using Cloud Console, you can list all clusters and view details of their configuration and status. You can then drill down into each node, pod, and container to view their details.

### Viewing the Status of Kubernetes Clusters Using Cloud SDK and Cloud Shell

You can also use the command line to view the status of a cluster. The `gcloud container clusters list` command is used to show those details.

To list the names and basic information of all clusters, use this command:

```
gcloud container clusters list
```

This produces the output shown in [Figure 8.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0014).

---

### Why Don't Commands Start with *gcloud kubernetes*?

`gcloud` commands start with the word `gcloud` followed by the name of the service, for example, `gcloud compute` for Compute Engine commands and `gcloud sql` for Cloud SQL commands. You might expect the Kubernetes Engine commands to start with `gcloud kubernetes`, but the service was originally called Google Container Engine. In November 2017, Google renamed the service Kubernetes Engine, but the `gcloud` commands remained the same.

---

![Snapshot of example output from the gcloud container clusters list command](../images/c08f014.png)


[**FIGURE 8.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0014) Example output from the `gcloud container clusters list` command

To view the details of a cluster, use the `gcloud container clusters describe` command. You will need to pass in the name of a zone or region using the `--zone` or `--region` parameter. For example, to describe a cluster named `standard-cluster-1` located in the `us-central1-a` zone, you would use this command:

```
gcloud container clusters describe --zone us-central1-a standard-cluster-1
```

This command will display details like those shown in [Figure 8.15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0015) and [Figure 8.16](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0016). Note that the `describe` command also displays authentication information such as client certificate, username, and password. That information is not shown in the figures.

![Snapshot of part 1 of the information displayed by the gcloud container clusters describe command](../images/c08f015.png)


[**FIGURE 8.15**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0015) Part 1 of the information displayed by the `gcloud container clusters describe` command

![Snapshot of part 2 of the information displayed by the gcloud container clusters describe command](../images/c08f016.png)


[**FIGURE 8.16**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0016) Part 2 of the information displayed by the `gcloud container clusters describe` command

To list information about nodes and pods, use the `kubectl` command.

First, you need to ensure you have a properly configured `kubeconfig` file, which contains information on how to communicate with the cluster API. Run the command `gcloud scontainer clusters get-credentials` with the name of a zone or region and the name of a cluster. Here's an example:

```
gcloud container clusters get-credentials \--zone us-central1-a  standard-cluster-1
```

This command will configure the `kubeconfig` file on a cluster named `standard-cluster-1` in the `us-central1-a` zone. [Figure 8.17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0017) shows an example output of that command, which includes the status of fetching and setting authentication data.

![Snapshot of example output of the get-credentials command](../images/c08f017.png)


[**FIGURE 8.17**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0017) Example output of the `get-credentials` command

You can list the nodes in a cluster using the following:

```
 kubectl get nodes
```

This command produces output like that shown in [Figure 8.18](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0018), which shows the status of three nodes.

![Snapshot of example output of the kubectl get nodes command](../images/c08f018.png)


[**FIGURE 8.18**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0018) Example output of the `kubectl get nodes` command

Similarly, to list pods, use the following command:

```
kubectl get pods
```

This command produces output like that shown in [Figure 8.19](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0019), which lists pods and their status.

![Snapshot of example output of the kubectl get pods command](../images/c08f019.png)


[**FIGURE 8.19**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0019) Example output of the `kubectl get pods` command

For more details about nodes and pods, use these commands:

```
kubectl describe nodes kubectl describe pods
```

[Figure 8.20](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0020) and [Figure 8.21](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0021) show partial listings of the results. Note that the `kubectl describe pods` command also includes information about containers, names, labels, conditions, network addresses, and system information.

![Snapshot of partial listing of the details shown by the kubectl describe nodes command](../images/c08f020.png)


[**FIGURE 8.20**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0020) Partial listing of the details shown by the `kubectl describe nodes` command

![Snapshot of partial listing of the details shown by the kubectl describe pods command](../images/c08f021.png)


[**FIGURE 8.21**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0021) Partial listing of the details shown by the `kubectl describe pods` command

To view the status of clusters from the command line, use the `gcloud container` commands, but to get information about Kubernetes managed objects, like nodes, pods, and containers, use the `kubectl` command.

## Adding, Modifying, and Removing Nodes

You can add, modify, and remove nodes from a cluster using either Cloud Console or Cloud SDK in your local environment, on a Google Cloud virtual machine, or in Cloud Shell.

### Adding, Modifying, and Removing Nodes with Cloud Console

From Cloud Console, navigate to the Kubernetes Engine page and display a list of clusters. Click the name of a cluster to display its details, as shown in [Figure 8.22](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0022).

![Snapshot of details of a cluster in Cloud Console](../images/c08f022.png)


[**FIGURE 8.22**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0022) Details of a cluster in Cloud Console

Select the Nodes tab to display the Node Pools and Nodes sections. The Node Pools section lists the name, status, GKE version, number of nodes, machine type, and image type. It also indicates whether Autoscaling is enabled on the node pool. Select the Edit option to change the number of nodes in the node pool. [Figure 8.23](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0023) shows details of a node pool.

![Snapshot of details of a node pool in Cloud Console](../images/c08f023.png)


[**FIGURE 8.23**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0023) Details of a node pool in Cloud Console

To add nodes, increase the size to the number of nodes you would like. To remove nodes, decrease the size to the number of nodes you'd like to have.

### Adding, Modifying, and Removing Nodes with Cloud SDK and Cloud Shell

The command to add or modify nodes is `gcloud container clusters resize`. The command takes three parameters:

- `cluster name`
- `node pool name`
- `cluster size`

For example, assume you have a cluster named `standard-cluster-1` running a node pool called `default-pool`. To increase the size of the node pool from 3 to 5, use this command:

```
gcloud container clusters resize standard-cluster-1 \--node-pool default- pool –num-nodes 5 --region=us-central1
```

The number of nodes you specify in the command will be the number of nodes in the pool if you are using a zonal cluster. If you are using a regional cluster, the number of nodes will be the number of nodes for each zone the node pool is in.

Once a cluster has been created, you can modify it using the `gcloud container clusters update` command. For example, to enable Autoscaling, use the `update` command to specify the maximum and minimum number of nodes. The command to update a cluster named `standard-cluster-1` running in a node pool called `default-pool` is as follows:

```
gcloud container clusters update standard-cluster-1 \  
--enable-autoscaling --min-nodes 1 \  
--max-nodes 5 --zone us-central1-a \  
--node-pool default-pool
```

---

### Real World Scenario

### Keeping Up with Demand with Autoscaling

Often it is difficult to predict demand on a service. Even if there are regular patterns, such as large batch jobs run during nonbusiness hours, there can be variation in when those peak loads run. Rather than keep manually changing the number of vCPUs in a cluster, enable Autoscaling to automatically add or remove nodes as needed based on demand. Autoscaling can be enabled when creating clusters with either Cloud Console or `gcloud`. This approach is more resilient to unexpected spikes and shifts in long-term patterns of peak use. It will also help optimize the cost of your cluster by not running too many servers when not needed. It will also help maintain performance by having sufficient nodes to meet demand.

---

## Adding, Modifying, and Removing Pods

You can add, modify, and remove pods from a cluster using either Cloud Console or Cloud SDK in your local environment, on a Google Cloud VM, or in Cloud Shell.

It is considered a best practice to not manipulate pods directly. Kubernetes will maintain the number of pods specified for a deployment. If you would like to change the number of pods, you should change the deployment configuration.

### Adding, Modifying, and Removing Pods with Cloud Console

Pods are managed through deployments. A deployment includes a configuration parameter called *replicas*, which are the number of pods running the application specified in the deployment. This section describes how to use Cloud Console to change the number of replicas, which will in turn change the number of pods.

From Cloud Console, select the Workloads options from the navigation menu on the left. This displays a list of deployments, as shown in [Figure 8.24](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0024).

![Snapshot of deployment list of a cluster](../images/c08f024.png)


[**FIGURE 8.24**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0024) Deployment list of a cluster

Click the name of the deployment you want to modify; a form is displayed with details (see [Figure 8.25](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0025)).

Click the name of a pod in the Managed Pods section (see [Figure 8.26](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0026)) to display details of the pod. Note there is a button that allows you to delete the pod in the horizontal menu bar at the top of the page. Again, this is not a best practice in general and pods should be managed by Kubernetes.

Select the Actions option from the three vertical dot icon to display Actions, then select Scale to display a dialog box that allows you to set a new size for the workload, as shown in [Figure 8.27](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0027). In this example, the number of replicas has been changed to 2.

You can also have Kubernetes automatically add and remove replicas (and pods) depending on need by specifying Autoscaling. You can choose Autoscale from the Actions menu, which is shown in [Figure 8.28](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0028). In the resulting form, you can specify a minimum and maximum number of replicas to run.

The Actions menu also provides options for exposing a service on a port, as shown in [Figure 8.29](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0029), and to specify parameters to control rolling updates to deployed code, as shown in [Figure 8.30](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0030). The parameters include the minimum seconds to wait before considering the pod updated, the maximum number of pods above target size allowed, and the maximum number of unavailable pods.

![Snapshot of multiple forms contain details of a deployment and include a menu of actions you can perform on the deployment.](../images/c08f025.png)


[**FIGURE 8.25**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0025) Multiple forms contain details of a deployment and include a menu of actions you can perform on the deployment.

![Snapshot of details of a pod running in GKE](../images/c08f026.png)


[**FIGURE 8.26**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0026) Details of a pod running in GKE

![Snapshot of set the number of replicas for a deployment.](../images/c08f027.png)


[**FIGURE 8.27**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0027) Set the number of replicas for a deployment.

![Snapshot of enable Autoscaling to automatically add and remove replicas as needed depending on load.](../images/c08f028.png)


[**FIGURE 8.28**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0028) Enable Autoscaling to automatically add and remove replicas as needed depending on load.

### Adding, Modifying, and Removing Pods with Cloud SDK and Cloud Shell

Working with pods in Cloud SDK and Cloud Shell is done by working with deployments; deployments were explained earlier in the section “Adding, Modifying, and Removing Pods with Cloud Console.” You can use the `kubectl` command to work with deployments.

![Snapshot of form to expose services running on pods](../images/c08f029.png)


[**FIGURE 8.29**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0029) Form to expose services running on pods

To list deployments, use the following command:

```
kubectl get deployments
```

To add and remove pods, change the configuration of deployments using the `kubectl scale deployment` command. For this command, you have to specify the deployment name and number of replicas. For example, to set the number of replicas to 5 for a deployment named nginx-1, use this:

```
kubectl scale deployment nginx-1 --replicas 5
```

![Snapshot of form to specify parameters for rolling updates of code running in pods](../images/c08f030.png)


[**FIGURE 8.30**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0030) Form to specify parameters for rolling updates of code running in pods

To have Kubernetes manage the number of pods based on load, use the `autoscale` command. The following command will add or remove pods as needed to meet demand based on CPU utilization. If CPU usage exceeds 80 percent, up to 10 additional pods or replicas will be added. The deployment will always have at least one pod or replica.

```
kubectl autoscale deployment nginx-1 --max 10 --min 1 --cpu-percent 80
```

To remove a deployment, use the `delete deployment` command like so:

```
kubectl delete deployment nginx-1
```

---

### Services vs services

In the next section we discuss a Kubernetes abstraction known as Services. A Kubernetes Service is a way to expose an application on a set of pods to other applications and users on a network. The term services is also used in a more generic sense as a synonym for an application. For example, an application that provides an API that returns information about weather might be called a “weather service” and an application that computes tax on a sale might be called a “tax service.” To minimize potential confusion, in the following section we use the term “Service” with a capital S to refer to the Kubernetes abstraction and “service” with a lower-case s to refer to the synonym for applications.

---

## Adding, Modifying, and Removing Services

You can add, modify, and remove Services from a cluster using either Cloud Console or Cloud SDK in your local environment, on a Google Cloud VM, or in Cloud Shell.

A service is an abstraction that groups a set of pods as a single resource.

### Adding, Modifying, and Removing Services with Cloud Console

Kubernetes Services are added through deployments. In Cloud Console, select the Workloads option from the navigation menu to display a deployment list, as shown in [Figure 8.31](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0031). Note the Deploy option in the horizontal menu at the top of the page.

![Snapshot of deployment list along with a Deploy command to create new services](../images/c08f031.png)


[**FIGURE 8.31**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0031) Deployment list along with a Deploy command to create new services

Click Deploy to display the deployment form, shown in [Figure 8.32](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0032).

![Snapshot of form that lets you specify a new deployment for a service](../images/c08f032.png)


[**FIGURE 8.32**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0032) Form that lets you specify a new deployment for a service

In the Container Image parameter, you can specify the name of an image or select one from the Google Container Repository. To specify a name directly, specify a path to the image using a URL such as this:

```
gcr.io/google-samples/hello-app:2.0
```

You can specify labels, the initial command to run, and a name for your application.

When you click the name of a deployment you will see details of that deployment, including a list of Services, like that shown in [Figure 8.33](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0033).

![Snapshot of details of a service running in a deployment](../images/c08f033.png)


[**FIGURE 8.33**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0033) Details of Services exposing a deployment

Clicking the name of a Service opens the Detail form of the Service, which includes a Delete option in the horizontal menu. [Figure 8.34 shows the delete dialog](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0034).

### Adding, Modifying, and Removing Services with Cloud SDK and Cloud Shell

Use the `kubectl get services` command to list Services.

To add a Service, use the `kubectl create deployment` command to start a Service. For example, to add a Service called `hello-server` using the sample application by the same name provided by Google, use the following command:

```
kubectl create deployment hello-server --image=gcr.io/google/samples/hello-app:1.0 \  
--port 8080
```

![Snapshot of navigate to the Service Details page to delete a service using the Delete option in the horizontal menu.](../images/c08f034.png)


[**FIGURE 8.34**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0034) Navigate to the Service Details page to delete a service using the Delete option in the horizontal menu.

This command will download and start running the image found at the path `gcr.io/google-samples/` called `hello-app`, version 1. It will be accessible on port 8080. Deployments need to be exposed to be accessible to resources outside the cluster. This can be set using the `expose` command, as shown here:

```
kubectl expose deployment hello-server --type="LoadBalancer"
```

This command exposes the Service by having a load balancer act as the endpoint for outside resources to contact the service.

To remove a Service, use the `delete service` command, as shown here:

```
kubectl delete service hello-server
```

## Creating Repositories in the Artifact Registry

Artifact Registry is a Google Cloud service for storing container images. Container Registry is a service used in the past to manage images, but Artifact Registry is now the recommended service for managing images. Once you have created a registry and pushed images to it, you can view the contents of the registry and image details using Cloud Console and Cloud SDK and Cloud Shell.

### Viewing the Image Repository and Image Details with Cloud Console

In Cloud Console, select Artifact Registry from the navigation menu to display example registries (see [Figure 8.35](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0035)).

![Snapshot of a listing of repositories in Artifact Registry](../images/c08f035.png)


[**FIGURE 8.35**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0035) A listing of repositories in Artifact Registry

To create a registry, click the + icon to display a dialog box like the one shown in [Figure 8.36](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0036). You can see, Artifact Registry can have multiple types of registries, including one for Docker, Maven (a Java framework), and Python, among others.

![Snapshot of creating a repository in Artifact Registry](../images/c08f036.png)


[**FIGURE 8.36**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0036) Creating a repository in Artifact Registry

Depending on the type of repository you create, you must take additional steps to set up the repository. Artifact Registry provides detailed commands for configuring the repository. [Figure 8.37](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#c08-fig-0037), for example, shows a command for configuring a Docker repository.

![Snapshot of example instructions for configuring a Docker repository](../images/c08f037.png)


[**FIGURE 8.37**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c08.xhtml#R_c08-fig-0037) Example instructions for configuring a Docker repository

Kubernetes Engine makes use of container images stored in a Docker Repository. The contents of the Docker Repository can be viewed in summary and in detail using both Cloud Console and the command-line Cloud SDK, including in Cloud Shell.

## Summary

In this chapter, you learned how to perform basic management tasks for working with Kubernetes clusters, nodes, pods, and services. The chapter also described how to list the contents of container image repositories. You learned how to pin services in the Cloud Console menu, view the status of Kubernetes clusters, and view image repository and image details using `gcloud` commands. This chapter also described how to modify and remove nodes and pods. You also saw the benefits of autoscaling in a real-world scenario.

Both Cloud Console and Cloud SDK, including Cloud Shell, can be used to add, remove, and modify nodes, pods, and services. They both can be used to review the contents of an image repository. Some of the most useful commands include `gcloud container clusters create` and `gcloud container clusters resize`. The `kubectl` command is used to modify Kubernetes resources such as deployments and pods.

## Exam Essentials

- **Know how to view the status of a Kubernetes cluster.**   Use Cloud Console to list clusters and drill down into clusters to see details of the cluster, including node, pod, and container details. Know the `gcloud container clusters` command and its options.
- **Understand how to add, modify, and remove nodes.**   Use Cloud Console to modify nodes and know how to add and remove nodes by changing deployments. Use the `gcloud container clusters resize` command to add and remove nodes.
- **Understand how to add, modify, and remove pods.**   Use Cloud Console to modify pods and to add and remove pods by changing deployments. Use `kubectl get deployments` to list deployments, `kubectl scale deployment` to modify the number of deployments, and `kubectl autoscale deployment` to enable Autoscaling.
- **Understand how to add, modify, and remove Services.**   Use Cloud Console to modify Services and add and remove Services by changing deployments. Use `kubectl create deployment` to start Services and `kubectl expose deployment` to make a Service accessible outside the cluster. Delete a service using the `kubectl delete service` command.

## Review Questions

You can find the answers in the Appendix.

1. You are running several microservices in a Kubernetes cluster. You've noticed some performance degradation. After reviewing some logs, you begin to think the cluster may be improperly configured, and you open Cloud Console to investigate. How do you see the details of a specific cluster?
   1. Type the cluster name into the search bar.
   2. Click the cluster name.
   3. Use the `gcloud cluster details` command.
   4. None of the above.
2. You are viewing the details of a cluster in Cloud Console and want to see how many vCPUs are available in the cluster. Where would you look for that information?
   1. Node Pools section of the Nodes Details page
   2. Labels section of the Cluster Details page
   3. Summary line of the Cluster Listing page
   4. None of the above
3. You have been assigned to help diagnose performance problems with applications running on several Kubernetes clusters. The first thing you want to do is understand, at a high level, the characteristics of the clusters. Which command should you use?
   1. `gcloud container list`
   2. `gcloud container clusters list`
   3. `gcloud clusters list`
   4. None of the above
4. When you first try to use the `kubectl` command, you get an error message indicating that the resource cannot be found or you cannot connect to the cluster. What command would you use to try to eliminate the error?
   1. `gcloud container clusters access`
   2. `gdcloud container clusters get-credentials`
   3. `gcloud auth container`
   4. `gcloud auth container clusters`
5. An engineer recently joined your team and is not aware of your team's standards for creating clusters and other Kubernetes objects. In particular, the engineer has not properly labeled several clusters. You want to modify the labels on the cluster from Cloud Console. How would you do it?
   1. Click the Connect button.
   2. Click the Deploy menu option.
   3. Click the Edit menu option.
   4. Type the new labels in the Labels section.
6. You receive a page in the middle of the night informing you that several services running on a Kubernetes cluster have high latency when responding to API requests. You review monitoring data and determine that there are not enough resources in the cluster to keep up with the load. You decide to add six more VMs to the cluster. What parameters will you need to specify when you issue the `cluster resize` command?
   1. Cluster size
   2. Cluster name
   3. Node pool name
   4. All of the above
7. You want to modify the number of pods in a cluster. What is the best way to do that?
   1. Modify pods directly
   2. Modify deployments
   3. Modify node pools directly
   4. Modify nodes
8. You want to see a list of deployments. Which option from the Kubernetes Engine navigation menu would you select?
   1. Clusters
   2. Storage
   3. Workloads
   4. Deployments
9. What actions are available from the Actions menu when viewing deployment details?
   1. Scale and Autoscale only
   2. Autoscale, Expose, and Rolling Update
   3. Add, Modify, and Delete
   4. None of the above
10. What is the command to list deployments from the command line?
    1. `gcloud container clusters list-deployments`
    2. `gcloud container clusters list`
    3. `kubectl get deployments`
    4. `kubectl deployments list`
11. What parameters of a deployment can be set in the Create Deployment page in Cloud Console?
    1. Container image
    2. Cluster name
    3. Application name
    4. All of the above
12. Where can you view a list of applications when using Cloud Console?
    1. In the Deployment Details page
    2. In the Container Details page
    3. In the Cluster Details page
    4. None of the above
13. What `kubectl` command is used to create a deployment?
    1. `run`
    2. `start`
    3. `initiate`
    4. `deploy`
14. You are supporting machine learning engineers who are testing a series of classifiers. They have five classifiers, called `ml-classifier-1`, `ml-classifier-2`, etc. They have found that `ml-classifier-3` is not functioning as expected, and they would like it removed from the cluster. What would you do to delete a service called `ml-classifier-3`?
    1. Run the command `kubectl delete service ml-classifier-3`.
    2. Run the command `kubectl delete ml-classifier-3`.
    3. Run the command `gcloud service delete ml-classifier-3`.
    4. Run the command `gcloud container service delete ml-classifier-3`.
15. What service is responsible for managing container images?
    1. Kubernetes Engine
    2. Compute Engine
    3. Artifact Registry
    4. Container Engine
16. What command is used to list container images in the command line?
    1. `gcloud container images list`
    2. `gcloud container list images`
    3. `kubectl list container images`
    4. `kubectl container list images`
17. A data warehouse designer wants to deploy an extract, transform, and load process to Kubernetes. The designer provided you with a list of libraries that should be installed, including drivers for GPUs. You have a number of container images that you think may meet the requirements. How could you get a detailed description of each of those containers?
    1. Run the command `gcloud container images list details`.
    2. Run the command `gcloud container images describe`.
    3. Run the command `gcloud image describe`.
    4. Run the command `gcloud container describe`.
18. You have just created a deployment and want applications outside the cluster to have access to the pods provided by the deployment. What do you need to do to the deployment?
    1. Give it a public IP address.
    2. Issue a `kubectl expose deployment` command.
    3. Issue a `gcloud expose deployment` command.
    4. Nothing; making it accessible must be done at the cluster level.
19. You have deployed an application to a Kubernetes cluster that processes sensor data from a fleet of delivery vehicles. The volume of incoming data depends on the number of vehicles making deliveries. The number of vehicles making deliveries is dependent on the number of customer orders. Customer orders are high during daytime hours, holiday seasons, and when major advertising campaigns are run. You want to make sure you have enough nodes running to handle the load, but you want to keep your costs down. How should you configure your Kubernetes cluster?
    1. Deploy as many nodes as your budget allows.
    2. Enable Autoscaling.
    3. Monitor CPU, disk, and network utilization and add nodes as necessary.
    4. Write a script to run `gcloud` commands to add and remove nodes when peaks usually start and end, respectively.
20. When using Kubernetes Engine, which of the following might a cloud engineer need to configure?
    1. Nodes, pods, services, and clusters only
    2. Nodes, pods, services, clusters, and container images
    3. Nodes, pods, clusters, and container images only
    4. Pods, services, clusters, and container images only