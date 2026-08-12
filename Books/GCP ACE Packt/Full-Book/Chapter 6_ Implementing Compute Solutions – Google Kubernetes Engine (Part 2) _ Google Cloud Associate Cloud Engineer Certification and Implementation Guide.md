# 6

# Implementing Compute Solutions – Google Kubernetes Engine (Part 2)

The second part of the chapter about implementing compute solutions using **Google Kubernetes Engine** (**GKE**) focuses on operations such as cluster, node pool, Pod, and Service management.

The following topics are covered:

- Cluster operations
- Node pool operations
- Pod management
- Service management
- GKE logging and monitoring

In the previous chapter about GKE, we learned how to create clusters in **Standard** and **Autopilot** modes. In this chapter, we will focus on the operational tasks of GKE.

# Cluster operations

After the first containerized application deployment, we will focus on Google Kubernetes management. Not only will we modify our clusters, but we will view resources and delete them as well. By performing those operations, we learn and memorize the steps needed to perform those activities and prepare for future use of GKE and containers.

## Viewing cluster resources

Before we can perform any operation on a GKE cluster, we need to gather information about the existing cluster state, its configuration, and the resources available to us. This information will help us to understand the cluster and ensure that our operations are successful.

There are a number of ways to gather information about a GKE cluster. One way is to use the **kubectl** command-line tool. The **kubectl get nodes** command will list all nodes in the cluster, and the **kubectl get pods** command will list all Pods in the cluster.

Another way to gather information about a GKE cluster is to use the Kubernetes Dashboard. The Kubernetes Dashboard is a web-based user interface that allows us to view and manage our GKE cluster.

Once we have gathered information about the existing cluster state, we can then begin to perform operations on the cluster. For example, we could add or remove nodes, change the Kubernetes version, or allocate more resources to certain Pods.

### Cloud console

The initial Cloud console view of a cluster shows the following information located on the first tab, **OVERVIEW**:

- Cluster status
- Name
- Location
- Mode
- Number of nodes
- Total vCPUs
- Total memory
- Notifications
- Labels

More detailed information about the cluster is available when we click on a particular tab.

The second tab, **OBSERVABILITY**, contains summarized information about all clusters, and there is a possibility to drill down into a specific cluster if needed:

![Figure 6.1 – OBSERVABILITY tab from the main GKE page__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_01.jpg)

Figure 6.1 – OBSERVABILITY tab from the main GKE page

Finally, the third tab, **COST OPTIMIZATION**, lets us view cost optimization recommendations from Google Cloud:

![Figure 6.2 – COST OPTIMIZATION tab from the main GKE page__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_02.jpg)

Figure 6.2 – COST OPTIMIZATION tab from the main GKE page

Having overall information, we can dig into existing clusters. To view detailed information, we need to click on the desired cluster. The information is split into four sections, as follows:

- **Details**
- **Nodes**
- **Storage**
- **Logs**

The **Details** section is dedicated to the whole cluster, where we can see information divided into the following sections:

- **Cluster basics**
- **Automation**
- **Networking**
- **Security**
- **Metadata**
- **Features**

We encourage you to check each section as the information is very detailed.

In the **NODES** tab of a specific cluster, we can drill down into **Node Pools** and **Nodes**. We see details about node performance metrics and a summary of node pools:

![Figure 6.3 – Node pool summary overview__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_03.jpg)

Figure 6.3 – Node pool summary overview

### Command line

To list GKE clusters in use, we can use the **gcloud container clusters list** command in either Cloud Shell or your local computer, resulting in the following output:

![Figure 6.4 – Output of the gcloud container clusters list command with clusters listed__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_04.jpg)

Figure 6.4 – Output of the gcloud container clusters list command with clusters listed

To drill down into a specific cluster, we can use the following command:

```
gcloud container clusters describe --zone=ZONE_NAME CLUSTER_NAME
```

The command’s output is extensive, so you might consider filtering to shorten the output.

## Adding clusters

In the previous section of the chapter, we deployed GKE in both Standard and Autopilot modes by using both Cloud console and the CLI. In this section, we will move directly onto modifying the cluster part.

## Modifying clusters

Every person can perceive cluster modifications differently. For someone, it can be adding a node pool or modifying cluster settings; for another person, an upgrade is a cluster modification. Both can be correct, and it would be challenging to describe every possible modification of a GKE cluster.

One very important cluster modification is the GKE cluster version upgrade.

Note

By default, automatic upgrades are enabled for both GKE Standard and GKE Autopilot. There is the possibility to upgrade a GKE Standard cluster manually, but this option doesn’t exist for GKE Autopilot.

Let’s upgrade a GKE Standard cluster to a newer version.

### Cloud console

To upgrade a GKE cluster in Cloud console, we need to click on the desired cluster. Then, proceed as follows:

1. If a cluster upgrade is available, it will be visible in the **Cluster basics** section of Cloud console.
2. Click **UPGRADE AVAILABLE** and detailed information about possible upgrades will be displayed:

![Figure 6.5 – Cluster basics section with available upgrade__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_05.jpg)

Figure 6.5 – Cluster basics section with available upgrade

1. You can choose the static version or a release channel from the available options. The release channel has three options—**Stable channel**, **Regular channel**, and **Rapid channel**. You can choose the desired version depending on which channel you need:

![Figure 6.6 – Cluster basics section with available upgrade (continued)__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_06.jpg)

Figure 6.6 – Cluster basics section with available upgrade (continued)

1. After selecting the desired version, we need to click **SAVE CHANGES**, and the control upgrade starts. It might take a few minutes as all management components must be updated:

![Figure 6.7 – Release channel version selection__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_07.jpg)

Figure 6.7 – Release channel version selection

1. After the control plane upgrade, you can proceed with the node pool upgrade to have the same version of GKE components.

With the upgrade in Cloud console complete, we move to the upgrade procedure using a CLI.

### Command line

The procedure doesn’t differ from the Cloud console procedure. The step we didn’t have in Cloud console is retrieving available versions. Proceed as follows:

1. To retrieve available GKE versions, we need to run the following command:

   ```
   gcloud container get-server-config --zone=zone_name
   ```

This results in the following output:

![Figure 6.8 – Available GKE versions from different release channels__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_08.jpg)

Figure 6.8 – Available GKE versions from different release channels

1. We can upgrade the cluster to the standard version per our previously selected channel using the following command:

   ```
   gcloud container clusters upgrade CLUSTER_NAME --zone=zone_name--master
   ```
2. If we want to upgrade to a specific version, we can use the following command:

   ```
   gcloud container clusters upgrade CLUSTER_NAME --zone=zone_name--master --cluster-version VERSION
   ```
3. In this case, we have a GKE cluster called **gke-cluster-4** using a stable release channel. We will upgrade it from version **1.22.12-gke.2300** to the latest available—**1.23.11-gke.300**—and we will specify the cluster zone. If you want to upgrade to the latest version, it is possible to use the **latest** flag instead of the exact cluster version:

   ```
   gcloud container clusters upgrade gke-cluster-4 --zone=europe-west4-c --master --cluster-version 1.23.11-gke.300
   ```

This results in the following output:

![Figure 6.9 – Command to upgrade the GKE cluster to a specific version__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_09.jpg)

Figure 6.9 – Command to upgrade the GKE cluster to a specific version

1. After a few minutes, the cluster upgrade is finished. We can check the cluster version by running the **gcloud container clusters list --zone=europe-west4-c** command, which results in the following output:

![Figure 6.10 – The gke-cluster-4 cluster has been upgraded to a newer version__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_10.jpg)

Figure 6.10 – The gke-cluster-4 cluster has been upgraded to a newer version

After successfully upgrading the cluster, our master GKE nodes have a new version, and the next step to complete the upgrade is to upgrade the node pool.

Now that we have a successful upgrade using the command line and Cloud console, we are ready to proceed with the next step in our learning—cluster removal.

## Removing clusters

A cluster removal operation is irreversible, and all the resources within the cluster will be removed. This includes the following:

- Control plane resources
- All node instances in the cluster
- Any Pods that are running on those instances
- Any firewalls and routes created by GKE at the time of cluster creation
- Data stored in the **hostPath** host and **emptyDir** volumes

### Cloud console

In Cloud console, choose the to-be-deleted cluster by selecting the three dots, as shown in the following screenshot:

![Figure 6.11 – GKE cluster deletion in Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_11.jpg)

Figure 6.11 – GKE cluster deletion in Cloud console

We need to confirm cluster deletion by typing the name of the cluster, as follows:

![Figure 6.12 – Cluster deletion confirmation](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_12.jpg)

Figure 6.12 – Cluster deletion confirmation

Once the **DELETE** button is pressed, the cluster will no longer be accessible. After a moment, deletion completes, and the cluster with its resources no longer exists.

### Command line

To delete a GKE cluster, we need to use the following command:

```
gcloud container clusters delete CLUSTER_NAME –-zone=zone_name
```

In the next screenshot, we see the progress and output of the command that leads to cluster deletion:

![Figure 6.13 – Cluster deletion using CLI__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_13.jpg)

Figure 6.13 – Cluster deletion using CLI

By performing cluster operations, we have delved deeper into GKE management. Let’s move on to node pool management.

# Node pool operations

From the GKE architecture, we know that the node pool is the default place we host applications. As mentioned in the *GKE architecture* section in [*Chapter 5*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_05.xhtml#_idTextAnchor095), you can’t directly migrate applications from one node pool to another. What we need to do is to redeploy applications from one node pool to another.

As with every operation, we need to first know how many and what kind of node pools we currently have. In the next section, we start by listing existing node pools.

## Viewing node pools

Before we start any pool activities, it is good to know how to list existing node pools.

### Cloud console

To view existing node pools, we can view them in Cloud console by clicking on our cluster and then **NODES**:

![Figure 6.14 – Node pool details in Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_14.jpg)

Figure 6.14 – Node pool details in Cloud console

### Command line

To list existing pools using the command line, we need to execute the following command:

```
gcloud container node-pools list --cluster CLUSTER_NAME
```

The next screenshot shows the output of the command with two available node pools— **default-pool** and **high-performance-pool**:

![Figure 6.15 – Node pool details in Cloud Shell__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_15.jpg)

Figure 6.15 – Node pool details in Cloud Shell

Once we have information about existing pools, let’s add a new node pool to the GKE cluster.

## Adding node pools

We will also add a node pool in Cloud console using the CLI.

### Cloud console

We start by adding an extra node pool in Cloud console, as follows:

1. Click the **ADD NODE** **POOL** button:

![Figure 6.16 – ADD NODE POOL button in Cloud Shell__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_16.jpg)

Figure 6.16 – ADD NODE POOL button in Cloud Shell

1. We need to provide details such as node pool name, size, or upgrade configuration:

![Figure 6.17 – New node pool details](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_17.jpg)

Figure 6.17 – New node pool details

1. Select **Nodes** from the menu on the left, and let’s choose a high-performance machine family:

![Figure 6.18 – New node pool machine specification__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_18.jpg)

Figure 6.18 – New node pool machine specification

1. We can change node security access scopes or enable shielded options:

![Figure 6.19 – New node pool security specification__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_19.jpg)

Figure 6.19 – New node pool security specification

1. Similar to **Security**, we can add Kubernetes labels in the **Metadata** section:

![Figure 6.20 – New node pool metadata specification__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_20.jpg)

Figure 6.20 – New node pool metadata specification

1. Finally, when we click the **Create** button, the deployment will start.
2. After a moment, a new node pool is created and can be used to deploy workloads.

### Command line

The creation of a minimalistic deployment pool (bare minimum without any extra settings) can be achieved by executing the following command:

```
gcloud container node-pools create POOL_NAME --cluster CLUSTER_NAME --region=REGION_NAME
```

Execution of this command results in default settings configured for the node pool—three nodes with **e2-medium** as the machine type:

![Figure 6.21 – Default and newly created node pool with default settings__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_21.jpg)

Figure 6.21 – Default and newly created node pool with default settings

In the next section, we will modify node pools.

## Modifying node pools

After node pool creation, available operations that can be performed on the node pool are limited.

We can do the following:

- Change the number of nodes
- Enable the cluster autoscaler
- Change zones
- Choose a different image type
- Enable/disable surge upgrade
- Modify Kubernetes labels
- Modify node taints
- Modify network tags

As usual, we can modify the node pool using Cloud console, the CLI, or Cloud SDK.

### Cloud console

Click on the desired cluster, navigate to **Nodes**, and choose and click the node pool you wish to edit.

Once you click **Edit**, make the desired changes and click **Save**:

![Figure 6.22 – Changes in node pool in Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_22.jpg)

Figure 6.22 – Changes in node pool in Cloud console

Once the changes are done, the node pool will be updated with the desired settings.

### Command line

We can also edit node pool details by utilizing the CLI. For example, if we want to resize the node pool, we can use the following command:

```
gcloud container clusters resize CLUSTER_NAME --node-pool NODE_POOL_NAME --num-nodes NUM_NODES
```

In the **gcloud container clusters** namespace, other commands can be performed on clusters, as follows:

- **create**
- **create-auto**
- **delete**
- **describe**
- **get-credentials**
- **list**
- **resize**
- **update**
- **upgrade**

We encourage you to try other namespaces and play with your Kubernetes clusters while learning.

## Deleting node pools

One of the final tasks that can be performed on a node pool is its deletion.

### Cloud console

In Cloud console, we need to click on the desired GKE cluster, and then in the **Node Pools** section, we need to click on the “trash” icon to delete the desired node pool:

![Figure 6.23 – Deleting a node pool in Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_23.jpg)

Figure 6.23 – Deleting a node pool in Cloud console

After a few moments, node pool deletion will be finished. We must remember that any node pool operation or changes will block other node pool changes. Only after the initial node pool activity change will we be able to conduct other changes.

### Command line

We will finish our node pool activities with command-line deletion. To delete the node pool using the command line, we need to execute the following command:

```
gcloud container node-pools delete NODE_POOL_NAME --cluster CLUSTER_NAME –zone=ZONE_NAME
```

After a moment, node pool deletion is successful.

After familiarizing ourselves with operations on node pools, we can proceed with learning about Pods, operations we can perform, and how to create, delete, and update Pods.

# Pod management

Before we start managing Pods, we must learn what they are and how to deploy them.

Essentially, Pods are the smallest deployable units of computing that can be created and managed in Kubernetes. A Pod is a group of one or more containers, such as Docker containers. Pods share network and storage resources and represent an instance of a running process in the Kubernetes cluster.

Once clusters and node pools are ready, we will mainly work with Pods, and in the next sections, we will learn in detail about their lifecycle and possible operations.

## Pod lifecycle

Pods go through a specific sequence of stages throughout their lifecycle. It begins with the **Pending** phase, progresses to the **Running** phase if at least one of its primary containers starts successfully, and ultimately transitions to either the **Succeeded** or **Failed** phase based on whether any container within the Pod terminates with a failure.

Pods can have the following statuses:

- **Pending**—The Kubernetes cluster has accepted the Pod but is not ready to be run yet. For example, an image is being downloaded.
- **Running**—The Pod is bound to a node, and all containers have been created.
- **Succeeded**—All containers in the Pod have been successfully terminated.
- **Failed**—All containers in the Pod have terminated, and at least one has terminated in failure.
- **Unknown**—The status of the Pod cannot be obtained.

## Pod deployment

There are many ways in which Pods can be deployed. It depends on how the application is built and how we want to run it in Kubernetes.

Here are some of the most common methods:

- **Using the kubectl command-line tool**—This is the most common way to deploy Pods. You can use the **kubectl create** command to create a new Pod or the **kubectl apply** command to apply a YAML file that defines a Pod.
- **Using the Kubernetes Dashboard**—The Kubernetes Dashboard is a graphical user interface that you can use to deploy Pods. You can create new Pods or edit existing Pods from the dashboard.
- **Using a third-party tool**—There are a number of third-party tools that you can use to deploy Pods. These tools typically make it easier to deploy Pods, and they often provide additional features, such as automatic scaling and monitoring.

Here are some of the most popular third-party tools for deploying Pods:

- **Helm**—Helm is a package manager for Kubernetes. It makes it easy to deploy and manage complex applications on Kubernetes.
- **Argo CD**—Argo CD is a **continuous delivery** (**CD**) tool for Kubernetes. It can be used to automate the deployment of Pods, as well as the rollout of new versions of Pods.
- **Flux**—Flux is a CD tool for Kubernetes. It is similar to Argo CD, but it is designed to be more lightweight and easy to use.

### Pod creation

The simplest Pod creation can be done by applying the following code example, where we name the Pod **nginx-deployment** and we use an image of **nginx 1.14.2** on port **80**:

```
apiVersion: apps/v1 kind: Deployment
metadata:
  name: nginx-deployment spec:
  selector:
    matchLabels:
      app: nginx replicas: 2
  template:
    metadata:
      labels:
        app: nginx spec:
      containers:
      - name: nginx image: nginx:1.14.2
        ports:
        - containerPort: 80
```

We can also deploy this simple Pod by using the CLI. We saved the previous code into the **nginx.yaml** file:

```
kubectl apply -f nginx.yaml
```

This is the output after executing the command:

![Figure 6.24 – Successful deployment of nginx deployment__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_24.jpg)

Figure 6.24 – Successful deployment of nginx deployment

We can check the status of the Pod by using the **kubectl get pods** or **kubectl describe pod nginx** command from the CLI. The status of the Pod is also visible in Cloud console:

![Figure 6.25 – Successful deployment of nginx deployment (continued)__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_25.jpg)

Figure 6.25 – Successful deployment of nginx deployment (continued)

Basic information about the Pods is displayed in both cases—Cloud Shell and the CLI.

In the next screenshot, we deployed multiple Pods into different GKE clusters and namespaces with the same Pod name:

![Figure 6.26 – Workloads overview in Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_26.jpg)

Figure 6.26 – Workloads overview in Cloud console

We will now move to more advanced Pod deployment types such as ReplicaSet, StatefulSets, and others.

### Namespace

By default, GKE creates several namespaces such as **kube-node-lease**, **kube-public**, and **kube-system**. When creating a GKE Autopilot cluster, the default namespace is created for our workloads. GKE Standard mode allows us to specify a node pool’s newly created namespace manually.

Namespaces are used to isolate groups of resources within a single cluster. The name of the resources within a namespace must be unique but can be the same across all namespaces. Namespaces are primarily used in environments with many users, teams, or projects.

A namespace can be created with the **kubectl create namespace** **YOUR\_NAMESPACE** command.

We can use the **kubectl** command to to view namespaces in a particular cluster.

Lastly, to delete a namespace, we need to use the **kubectl delete namespaces** **YOUR\_NAMESPACE** command.

### ReplicaSet

The ReplicaSet deployment type is used to maintain the desired set of Pods. It defines which image and how many Pods must be up and running.

In this sample Pod ReplicaSet deployment, we specify various information such as Pod name, labels, and how many replicas of the Pod we wish to have:

```
apiVersion: apps/v1 kind: ReplicaSet
metadata:
  name: frontend labels:
    app: guestbook tier: frontend
spec:
  replicas: 3 selector:
    matchLabels:
      tier: frontend template:
    metadata:
      labels:
        tier: frontend spec:
      containers:
      - name: php-redis image: gcr.io/google_samples/gb-frontend:v3
```

The preceding code is available here: <https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/controllers/frontend.yaml>.

To test it out, we can deploy it using the **kubectl apply -f Filename** command or the preceding URL.

The preceding source code contains two important sections—the first is **kind: ReplicaSet** and the second is the **spec** section: **replicas** with value **3**.

We can check ReplicaSets by running the **kubectl get ReplicaSet** command or viewing them in Cloud console.

### Deployments

Deployment is the next possibility of how we can run the applications. We should use it to manage stateless applications where any Pod from the Deployment can be replaced if needed.

A Deployment provides declarative updates for Pods and ReplicaSets. It allows for a more sophisticated way to manage Pods.

We should use Deployments in the following cases:

- We want to have a rolling update where we phase out an old version of the application, and it will be replaced with a new version of the application.
- In Blue/Green deployments, where we can serve one version to a set of users, and once we are happy or unhappy with the results, it is possible to switch to the desired version of the application.
- When scaling up the deployment to accept more load.

To learn more about other deployment types, visit the Kubernetes documentation at <https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#use-case>.

### StatefulSets

Similar to Deployments, a StatefulSet creates Pods based on the container specification. One major difference is that a StatefulSet creates and tracks the identity of each Pod. Because Pods aren’t interchangeable, the identifier will be persisted even if the Pod is rescheduled.

You might consider using StatefulSets in the following cases:

- You need to have stable and unique network identifiers.
- You require stable, persistent storage.
- Graceful and ordered deployment or scaling is needed.
- Ordered and automated rolling updates are needed.

### DaemonSet

If we need to ensure that Pods will be scheduled on all or some GKE nodes, we can use the DaemonSet deployment type. When a new node is added to the cluster, Pods are scheduled on them.

The most typical use cases of a DaemonSet are outlined here:

- Using cluster storage daemon on nodes
- Using log collection daemon on nodes
- Using monitoring daemon on nodes

### Jobs

A Job deployment type is used to track the successful completion of Pods. Once the specified number of completions is achieved, the job is complete, and it cleans created Pods.

One example of a Job deployment type can be *π* number computation up to the desired number of places, which in this case is 2000:

```
ApiVersion: batch/v1 kind: Job
metadata:
  name: pi spec:
  template:
    spec:
      containers:
      - name: pi image: perl:5.34.0
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never backoffLimit: 4
```

Once a Job is created, we can check the Job status by using the **kubectl describe job pi** command, and to see the Job results, we need to check logs. The command to do that is **kubectl** **logs jobs/pi**.

The preceding code can be found at <https://kubernetes.io/examples/controllers/job.yaml>.

### CronJob

A CronJob deployment type is useful when we execute a job based on a schedule written in Cron format.

After learning about different Pod deployment types, we will focus on the different operations we can do with Pods. Let’s start with how to view Pods.

## Viewing Pods

Depending on how the application is deployed, it is important to view details of the Pod, how it is configured, and how to troubleshoot some issues.

### Cloud console

We have some Pods deployed into the GKE cluster, and we can see the status of workloads in Cloud console. Cloudconsole has a general overview of deployed workloads. The main screen allows us to view workloads by selecting a desired cluster or namespace:

![Figure 6.27 – Workloads overview in Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_27.jpg)

Figure 6.27 – Workloads overview in Cloud console

Further on in the bottom section of the screen, we can apply more detailed filtering such as the following:

- **Name**
- **Status**
- **Type**
- **Pods**
- **Namespace**
- **Location**
- **Pods running**
- **Pods desired**
- **Is** **system object**

A detailed view of a workload is possible by selecting it from the main workload screen:

![Figure 6.28 – Selected workload general overview__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_28.jpg)

Figure 6.28 – Selected workload general overview

The top section of the workload allows us to see workload details, any events that might have occurred, container logs, and your workload represented in YAML format.

It is possible to go one level deeper and view the details of each of the Pods, which are part of the workload itself:

![Figure 6.29 – Detailed view of Pods from the workload__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_29.jpg)

Figure 6.29 – Detailed view of Pods from the workload

After clicking on the Pod, similar to the general overview of the workload, we can check the Pod’s details and see events, logs, and its YAML representation.

### Command line

Now, after switching to the CLI, we will view the Pods’ details using the **kubectl** utility.

To view all Pods in all namespaces, we need to use the following command:

```
kubectl get pods -A
```

However, the command output will show us all cluster resources alongside our deployed Pods.

To view Pods deployed into the default namespace, we need to use the following command:

```
kubectl get pods
```

If Pods were deployed into a dedicated namespace, we must append a **--namespace****YOUR\_NAMESPACE** parameter.

If we want to see the details of a specific Pod, we need to use the **kubectl describe pods MY\_POD\_NAME** command. This command is handy for seeing Pod events, especially if the Pod creation fails to troubleshoot the issue.

To list deployments, we can use the **kubectl get deployment** **MY\_DEPLOYMENT** command.

It is possible to retrieve existing Pod or deployment configuration and save it as a file in YAML format using the **kubectl get pod my-pod -o** **yaml** command.

As you might have already seen, **kubectl** has multiple switches, each with multiple namespaces. To view the most common Kubernetes operations, it might be helpful to look at the following **kubectl** cheat sheet: <https://kubernetes.io/docs/reference/kubectl/cheatsheet/>.

In the next section, we will focus on adding Pods to the GKE cluster.

## Adding Pods

Pod creation can be done by using Cloud console and the CLI. We will start with Cloud console.

### Cloud console

In Cloud console, we need to select **Workloads** and click the **DEPLOY** button:

![Figure 6.30 – Container deployment using Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_30.jpg)

Figure 6.30 – Container deployment using Cloud console

We have the following options to choose from:

- **Existing container image**—The source of the image can be either a container registry or an artifact registry.
- **New container image**—The source image can be pulled from Cloud Source Repositories, GitHub, or Bitbucket:

![Figure 6.31 – Container selection for a new deployment__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_31.jpg)

Figure 6.31 – Container selection for a new deployment

If needed, we can add multiple containers into one deployment. After clicking **CONTINUE**, we have the possibility to provide an application name, choose or create a namespace, add labels, view the configuration in YAML, and select which GKE cluster we want to deploy:

![Figure 6.32 – Final step to deploy the container using Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_32.jpg)

Figure 6.32 – Final step to deploy the container using Cloud console

Note

If your target GKE cluster uses Standard mode, the application should be available within seconds (depending on the application size). If the target GKE cluster uses Autopilot mode, Pod scheduling might take a bit longer than in Standard clusters due to the necessity of node provisioning.

After the application is up and running, we can add extra Pods to the application. This can be done in the **ACTIONS** menu:

![Figure 6.33 – Edit replicas menu in Deployment details__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_33.jpg)

Figure 6.33 – Edit replicas menu in Deployment details

After changing the desired number of Pods, deployments of the additional Pods start immediately if there are enough resources in the node pool:

![Figure 6.34 – Successful increase in Pods in deployment__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_34.jpg)

Figure 6.34 – Successful increase in Pods in deployment

In the next section, we will add a simple image to a GKE cluster.

### Command line

The most popular option to create Pods using the command line is to use two main commands.

The first option is to use the **kubectl apply -f filename.yaml** command, where the YAML file contains all details of the Pod.

If you don’t know how to create a Pod YAML file, you can use an example from the *Pod deployment* section of this chapter or use the following command:

```
kubectl create deployment dry_run_deployment --image=busybox --dry-run=client --output=yaml
```

The output of the previous command shows ready-to-be-used YAML code:

![Figure 6.35 – Output of kubectl --dry-run command in YAML format__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_35.jpg)

Figure 6.35 – Output of kubectl --dry-run command in YAML format

This generates a base deployment based on the selected image, which can be saved as a YAML file on a computer and edited to make changes. The most important section of that command is the **--dry-run=client --output=yaml** part, which previews the object that would be sent to the cluster without submitting it.

Now we’ve learned how to create deployments using saved YAML files on a computer, we can move on to creating Pods using **kubectl** to create deployment parameters. Simple Pod creation needs **name** and **image** parameters, as follows:

```
kubectl create deployment pod_name --image=image_name
```

A sample command to create a deployment with the name **nginx-gke-autopilot**, which uses nginx as a source image, is shown as follows:

```
kubectl create deployment nginx-gke-autopilot --image=nginx
```

This section concludes by adding both Cloud console and the CLI.

In the next section, we learn how to modify Pods.

## Modifying Pods

Modification of Pods is possible by using different methods. Those methods may vary due to the different application deployment possibilities. Suppose we have an application deployed as a ReplicaSet and want to modify the number of usable Pods. In that case, we can edit the YAML deployment file, modify it, and redeploy it. We could get the existing workload YAML configuration file, save it as a local file, and redeploy it with changes.

### Cloud console

Modifying running Pods in Cloud console is possible via the **Workloads** section in Cloud console. Our sample application, named **frontend**, is deployed as a ReplicaSet with three Pods as the desired state. To change the number of Pods, we need to click on the name of the workload:

![Figure 6.36 – ReplicaSet deployment visible in the Workloads section of Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_36.jpg)

Figure 6.36 – ReplicaSet deployment visible in the Workloads section of Cloud console

After selection, we are redirected to the workload details, where we can see the workload details and edit them.

When we click the **EDIT** button, the browser-based code editor allows us to edit the workload. In our case, we will replace the number of desired Pods from three to five:

![Figure 6.37 – Web-based editor that allows editing of the workload__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_37.jpg)

Figure 6.37 – Web-based editor that allows editing of the workload

If your GKE cluster has enough resources to run the desired number of Pods, they will be scheduled and available. After a moment, new Pods are created and ready to be used:

![Figure 6.38 – Two new Pods added to the ReplicaSet__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_38.jpg)

Figure 6.38 – Two new Pods added to the ReplicaSet

Of course, those aren’t the only possible settings we can adjust, and we encourage you to experiment with them.

### Command line

To modify deployed Pods, we have several possibilities, but it will depend on how the Pods are deployed. Let’s try to modify the ReplicaSet deployment used in the previous section of the chapter.

We have a deployment with the name **frontend** with three replicas and we would like to change the number of replicas to seven. We can change the amount of the Pods in two different ways.

The first one is to simply use the **kubectl scale --replicas=7 -f https://kubernetes.io/examples/controllers/frontend.yaml** command, which results in the following output:

![Figure 6.39 – Modification of the ReplicaSet from three to seven replicas__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_39.jpg)

Figure 6.39 – Modification of the ReplicaSet from three to seven replicas

We are using the **watch kubectl get pods** command, which allows me to see changes live. We can also use the **kubectl get pods -w** command, which doesn’t require additional packages to be installed. After a few seconds, additional Pods are ready to be used:

![Figure 6.40 – Modification of the ReplicaSet from three to seven replicas finished__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_40.jpg)

Figure 6.40 – Modification of the ReplicaSet from three to seven replicas finished

We can also modify the code used to deploy Pods.

In our case, we will use a command-line file editor to change the value of replicas from 3 to 20:

```
apiVersion: apps/v1 kind: ReplicaSet
metadata:
  name: frontend labels:
    app: guestbook tier: frontend
spec:
  # modify replicas according to your case replicas: 20
  selector:
    matchLabels:
      tier: frontend template:
    metadata:
      labels:
        tier: frontend spec:
      containers:
      - name: php-redis image: gcr.io/google_samples/gb-frontend:v3
```

You can use your favorite file editor or web-based editor available in Cloud console:

![Figure 6.41 – YAML deployment definition file editing in the Cloud console web-based editor__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_41.jpg)

Figure 6.41 – YAML deployment definition file editing in the Cloud console web-based editor

Once the file is saved, we can use the YAML file to update the ReplicaSet from three to six Pods:

![Figure 6.42 – YAML deployment definition file update from three to six Pods was successful__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_42.jpg)

Figure 6.42 – YAML deployment definition file update from three to six Pods was successful

Now we’ve learned how to modify existing Pods, it is crucial to learn how to remove Pods from GKE clusters.

## Removing Pods

Removal of Pods will depend on how you deployed them. If a single Pod has been deployed, then the removal of the Pod is a straightforward operation.

If the Pod is part of a ReplicaSet, then removal of the Pod itself will succeed, but the GKE control plane will run the desired number of Pods and create a new one. To remove Pods in such a case, we need to remove the deployment itself.

### Cloud console

We have a ReplicaSet deployed and visible in the **Workloads** section of the GKE part of the Cloud console:

![Figure 6.43 – Frontend ReplicaSet workload in Cloud console to be removed__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_43.jpg)

Figure 6.43 – Frontend ReplicaSet workload in Cloud console to be removed

To remove a single Pod or Pods from the GKE cluster, we need to click on the workload itself and scroll to the **Pods** section:

![Figure 6.44 – Pods part of the ReplicaSet deployment__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_44.jpg)

Figure 6.44 – Pods part of the ReplicaSet deployment

To remove a Pod from the ReplicaSet, click on the desired Pod and click the **DELETE** button:

![Figure 6.45 – Removal of a single Pod from the deployment__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_45.jpg)

Figure 6.45 – Removal of a single Pod from the deployment

After clicking the **DELETE** button, we need to confirm the removal of the Pod:

![Figure 6.46 – Confirmation of Pod deletion in Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_46.jpg)

Figure 6.46 – Confirmation of Pod deletion in Cloud console

After a second, the old Pod is removed and a new one is created as part of the ReplicaSet deployment with the frontend.

Now, we will move on to complete deployment removal.

To remove a deployment, choose it from the **Workloads** section and click the **DELETE** button:

![Figure 6.47 – Confirmation of Pod deletion in Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_47.jpg)

Figure 6.47 – Confirmation of Pod deletion in Cloud console

We need to confirm the deletion, and without any issues, the desired workload deletion starts:

![Figure 6.48 – Confirmation of workload deletion in Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_48.jpg)

Figure 6.48 – Confirmation of workload deletion in Cloud console

In just a few seconds, the deletion process starts, and we can briefly observe all Pods’ termination:

![Figure 6.49 – Confirmation of workload deletion in Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_49.jpg)

Figure 6.49 – Confirmation of workload deletion in Cloud console

If we hit **Refresh** in the browser, it will confirm the resource deletion.

Now, let’s move on to command-line application removal.

### Command line

Removal of Pods utilizes the **kubectl** command. Before we start with the removal of a single Pod, we need to list existing Pods. To list all Pods, we can use the **kubectl get** **pods** command:

![Figure 6.50 – Listing of existing Pods with kubectl command__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_50.jpg)

Figure 6.50 – Listing of existing Pods with kubectl command

To delete a single Pod, we can issue the **kubectl delete pod frontend-4rk4w** command. The Pod is deleted immediately, but we might ask ourselves the following: *How do I know if the Pod is part of the deployment or otherwise?* *How was the Pod deployed in the* *first place?*

To find this out, we can review the Pod configuration by using the **kubectl describe pod** **frontend-dc4n4** command.

The command output contains a lot of information, and we need to scroll to the **Controlled** **By:** section:

![Figure 6.51 – Detailed information about the Pod__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_51.jpg)

Figure 6.51 – Detailed information about the Pod

The **Controlled By:** section allow us to identify how a Pod or set of Pods deployment has been done. Once we know that the Pod is part of a ReplicaSet, we need to find the name of the ReplicaSet. To find this out, we can use the **kubectl get** **replicaset** command:

![Figure 6.52 – Existing ReplicaSet deployments__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_52.jpg)

Figure 6.52 – Existing ReplicaSet deployments

So, we discovered that the ReplicaSet with the name **frontend** contains six replicas and Pods associated with it:

![Figure 6.53 – Detailed information about the frontend ReplicaSet__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_53.jpg)

Figure 6.53 – Detailed information about the frontend ReplicaSet

Finally, to delete it, we need to run the **kubectl delete replicaset frontend** command. After a moment, deletion completes.

We learned a lot about Pods, including how to deploy, manage and remove them. Our journey doesn’t stop here. We will now move to the services section, where we will learn about different types of services and how we can use them in GKE.

# Service management

Services are a crucial part of GKE. GKE uses services to group Pods into a single resource that is going to be accessed from outside of the GKE cluster. After the deployment of the application, we can choose different ways to access applications running in GKE.

## Types of services

We have a handful selection of services to choose from, as follows:

- **ClusterIP**—This is a default service where clients’ requests are sent to an internal IP address.
- **NodePort**—Clients send requests to the IP address of a node with a specific, configurable port value.
- **LoadBalancer**—Clients access the application by using the IP address of the load balancer.
- **ExternalName**—Clients access the application by using the DNS address.
- **Headless**—A headless service that can be used to group Pods without an IP address.

Both the Kubernetes and GKE documentation describe in detail services with all their options, and we recommend diving deep if you want to learn more beyond the scope of the book:

- <https://kubernetes.io/docs/concepts/services-networking/service/>
- <https://cloud.google.com/kubernetes-engine/docs/concepts/service>

## Viewing services

By default, GKE creates services that are used by GKE itself. Those default services are set out here:

- **default-http-backend**
- **kube-dns**
- **kubernetes**
- **metrics-server**

The next screenshot shows these services in Cloud console, but as those are GKE core services, we should avoid interaction with them unless there is a clear reason to do so. Changing them might result in GKE cluster and workload downtime:

![Figure 6.54 – Internal GKE services__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_54.jpg)

Figure 6.54 – Internal GKE services

Let’s find out how to interact with services in GKE.

### Cloud console

In Cloud console, we can view existing services deployed by clicking on the **Services & Ingress** menu. Once a service is created, we can view it in Cloud console:

![Figure 6.55 – Service visible in Services & Ingress section of GKE__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_55.jpg)

Figure 6.55 – Service visible in Services & Ingress section of GKE

To view service details, you need to click on the service name. In the **OVERVIEW** section, we can see service details with monitoring.

If we click on the **DETAILS** tab, we can see trimmed but still helpful information about the service:

![Figure 6.56 – Service visible in the Services & Ingress section of GKE__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_56.jpg)

Figure 6.56 – Service visible in the Services & Ingress section of GKE

We can see service events, logs, and YAML configuration by clicking on the next tabs.

### Command line

Once again, we utilize the **kubectl** command. This time, we will use the **kubectl get services** command to display available services:

![Figure 6.57 – Listing of services in the existing GKE cluster__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_57.jpg)

Figure 6.57 – Listing of services in the existing GKE cluster

To get details of a service, we can use the **kubectl describe service YOUR\_SERVICENAME** command. This results in the following output:

![Figure 6.58 – Details of the frontend-5kd5f service by using the kubectl command__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_58.jpg)

Figure 6.58 – Details of the frontend-5kd5f service by using the kubectl command

The same approach can be used to get details of other service types supported by GKE.

After learning how to view services, we can start creating and utilizing our own services.

## Adding services

As mentioned at the beginning of the *Service management* section, we can define our services and control how applications can be accessed outside the GKE cluster.

We will combine the command line and Cloud console to add services to the GKE cluster.

### Cloud console

First, we need to have the existing application deployed into the GKE cluster. We have the application named **frontend** prepared to be exposed outside the GKE cluster. Then, proceed as follows:

1. To create a service for an existing application, go to **Workloads** and select your workload.
2. From the workload detail, click the **ACTIONS** button and then **Expose**:

![Figure 6.59 – Internal GKE services__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_59.jpg)

Figure 6.59 – Internal GKE services

1. We can choose the service type from **Cluster IP**, **Node port**, or **Load balancer**:

![Figure 6.60 – Service type selection menu__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_60.jpg)

Figure 6.60 – Service type selection menu

1. We will choose the **Cluster IP** default from the selection.
2. Immediately after creation, we can see service metrics, the Cluster IP, and serving Pods:

![Figure 6.61 – Cluster IP service details__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_61.jpg)

Figure 6.61 – Cluster IP service details

### Command line

We have an application called **my-nginx** running as a deployment with two Pods. We want to create a service of type **ClusterIP** for the workload running under the name **my-nginx**.

To create a service of type **ClusterIP**, we can use the following code:

```
apiVersion: v1 kind: Service
metadata:
  name: my-nginx labels:
    run: my-nginx spec:
  ports:
  - port: 80 protocol: TCP
  selector:
    run: my-nginx
```

The preceding code can be downloaded from the following GitHub page: <https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/service/networking/nginx-svc.yaml>.

We recommend saving the file’s content to the local disk so that we can use it as input for the **kubectl** command.

To create a service using the **kubectl** command-line tool, we need to run the following command: **kubectl apply -****f YOUR\_FILENAME.yaml**.

After applying the YAML file, a service of type **ClusterIP** is created. We can check if it is created by running the **kubectl get services** command and then **kubectl describe** **service SERVICE\_NAME**:

![Figure 6.62 – Newly created ClusterIP service details__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_62.jpg)

Figure 6.62 – Newly created ClusterIP service details

Now, let’s learn how to modify services running on the GKE cluster.

## Modifying services

Modifying services used in GKE will be similar to other parts of the GKE modification.

### Cloud console

Modifying a service in Cloud console will rely on editing existing services available for us in GKE.

We have a **nginx-service** service from the previous section of the book available. To edit it, we will go to the **Services & Ingress** section, click on it, and then click the **EDIT** button:

![Figure 6.63 – Modification of a service in Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_63.jpg)

Figure 6.63 – Modification of a service in Cloud console

Depending on the service, your edit might look different than ours. In our case, we will change the port from **80** to **8080**. **Port** and **targetPort** are different ports where we must distinguish how we access the application. **Port** is the actual port on the Pod, and **targetPort** is the open port on the node or cluster level open to the requests:

![Figure 6.64 – Modification of the service by using Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_64.jpg)

Figure 6.64 – Modification of the service by using Cloud console

After saving the file in the Cloud console editor, the service description is updated and reflects our changes:

![Figure 6.65 – Service update finalized by using Cloud console from target port 80 to 8080__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_65.jpg)

Figure 6.65 – Service update finalized by using Cloud console from target port 80 to 8080

After successfully modifying the service in Cloud console, we move on to the same task using the **kubectl** command-line tool.

### Command line

Modification of the service by using the **kubectl** command-line tool allows us to change the service configuration easily.

We need to list services, get the service’s configuration, modify it, and apply the new values to modify the service. Here’s how we can do that:

1. To list all existing services, we can use the **kubectl get** **services** command:

![Figure 6.66 – Listing of existing services__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_66.jpg)

Figure 6.66 – Listing of existing services

1. Once we have the name of the service, we can get its configuration by using the **kubectl describe service** **SERVICE\_NAME** command:

![Figure 6.67 – Detailed description of running the GKE service__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_67.jpg)

Figure 6.67 – Detailed description of running the GKE service

1. To edit the configuration itself, we need to use the **kubectl edit service SERVICE\_NAME** command, resulting in the following information:

![Figure 6.68 – Editing GKE service in a preferred text editor__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_68.jpg)

Figure 6.68 – Editing GKE service in a preferred text editor

1. After saving the file, the changes are applied immediately.
2. Execution of the **kubectl describe service YOUR\_SERVICE\_NAME** command shows the changes applied:

![Figure 6.69 – Editing GKE service in a preferred text editor__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_69.jpg)

Figure 6.69 – Editing GKE service in a preferred text editor

1. The description of the service has changed—**TargetPort** has changed from port **8080** to **8089**.

Now that we have learned how to modify services, we need to learn how to remove them.

## Removing services

Removal of services can be performed in Cloud console and by using the **kubectl** command-line tool.

### Cloud console

In Cloud console, we need to navigate to **Services & Ingress**, select the desired service to be removed, and click the **DELETE** button:

![Figure 6.70 – Deleting services in Cloud console__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_70.jpg)

Figure 6.70 – Deleting services in Cloud console

After a moment, the service is deleted.

### Command line

To remove a service in GKE, we need first to identify services running in the GKE cluster. To list all services, we can use the **kubectl get** **services** command:

![Figure 6.71 – List of existing GKE services__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_71.jpg)

Figure 6.71 – List of existing GKE services

To delete a service, we need to use the **kubectl delete service** **YOUR\_SERVICE\_NAME** command:

![Figure 6.72 – Successful deletion of the service__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_72.jpg)

Figure 6.72 – Successful deletion of the service

After completing the section on services, we will move on to another important section of GKE—logging and monitoring.

# GKE logging and monitoring

GKE includes, by default, native integration with Google Cloud Logging and Cloud Monitoring. If desired, you can use Managed Service for Prometheus as well.

When the GKE cluster is created, Cloud Monitoring and Cloud Logging are enabled by default and can be used to observe logs and view monitoring metrics:

![Figure 6.73 – OBSERVABILITY section in cluster details__HTML_DOM_PARSER_CARRIAGE_RETURN_PLACEHOLDER_1769228160010__](../images/Chapter 6_ Implementing Compute Solutions – Google Kubernetes Engine (Part 2) _ Google Cloud Associate Cloud Engineer Certification and Implementation Guide_files/B18851_06_73.jpg)

Figure 6.73 – OBSERVABILITY section in cluster details

As we will describe Cloud Logging and Cloud Monitoring in [*Chapter 10*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_10.xhtml#_idTextAnchor224), we won’t focus on those topics here.

# Summary

Containerization of applications isn’t something new; it is a fact. We need it not only to be successful when passing the **Associate Cloud Engineer** (**ACE**) certification but also to understand the future of the application deployment. Microservices, containerization, and micro-segmentation are “the now,” and we can’t avoid them. we hope the concept of containers, accompanying services, and various deployment types described in this chapter will help you not only scratch the surface but practically use them in real life as well.

Although we would have liked to dig deeper into some GKE sections, we had to focus on the overall target—passing the ACE cert. Kubernetes and GKE are such exciting topics that many books, blog articles, and videos have been created about them. Topics covered in this chapter are aligned with ACE requirements, but if you wish to dive deeper into GKE, we encourage you to follow up with detailed publications about it.

In the next chapter, we switch gears and move abstraction layers above, where we will learn and deploy containers in Cloud Run, create and run Cloud Functions, and familiarize ourselves with **Infrastructure as Code** (**IaC**) by using Terraform.

# Questions

Answer the following questions to test your knowledge of this chapter:

1. Which of the following commands can be used to create a node pool?
   1. **gcloud container node-pools create POOL\_NAME --cluster** **CLUSTER\_NAME --region=REGION\_NAME**
   2. **gcloud node-pools create POOL\_NAME --cluster** **CLUSTER\_NAME --region=REGION\_NAME**
   3. **gcloud container node-pools add POOL\_NAME --cluster** **CLUSTER\_NAME --region=REGION\_NAME**
   4. **kubectl node-pools add POOL\_NAME --cluster** **CLUSTER\_NAME --region=REGION\_NAME**
   5. **kubectl container node-pool create POOL\_NAME --cluster** **CLUSTER\_NAME --region=REGION\_NAME**
2. What are the main components of a GKE cluster
   1. **kube-apiserver**
   2. **etcd**
   3. **kube-scheduler**
   4. **kube-controller-manager**
   5. **cloud-controller-manager**
   6. All of these
3. You have received a task to maintain a GKE cluster named **test-before-prod**. To save time, you would like to configure this cluster as your default GKE cluster. What should you do?
   1. Create a file called **gke.default** in the **~/.gcloud** folder that contains the cluster name.
   2. Use the **gcloud container cluster update** **test-before-prod** command.
   3. Use the **gcloud config set container/cluster** **test-before-prod** command.
   4. Create a file called **defaults.json** in the **~/gcloud** folder that contains the cluster name.
4. You have created an application and packaged it into a Docker image. You would like to deploy this Docker image as a workload on GKE. What do you need to do?
   1. Upload the image to Container Registry and create a Kubernetes image.
   2. Upload the image to Cloud Storage and create a Kubernetes image.
   3. Upload the image to Container Registry and create a Kubernetes Deployment from the image.
   4. Upload the image to Cloud Storage and create a Kubernetes Deployment from the image.
5. You have an application definition saved in a file called **application.yaml**. How can you run it on the GKE cluster?
   1. Use the **kubectl apply -f** **application.yaml** command.
   2. Use the **kubectl containers apply -f** **application.yaml** command.
   3. Use the **gcloud containers apply -f** **application.yaml** command.
   4. Use the **kubectl apply -e** **application.yaml** command.
6. What could be the reason that the Autopilot GKE cluster doesn’t have any vCPU or memory used in the cluster overview?
   1. The cluster is broken and needs to be recreated.
   2. The cluster is healthy, but there are no applications running.
   3. You don’t have permission to view this information.
   4. Autopilot GKE clusters don’t display this information.
7. You have developed a new application with many microservices. The application will run on GKE, and you want to be sure that the cluster scales as more applications are deployed in the future. You want to avoid manual configuration as each new application is deployed. How can you ensure that the cluster will scale with new applications?
   1. Create a GKE cluster with autoscaling enabled on the node pool.
   2. Create a separate node pool for each new application and deploy it on the node pool.
   3. Deploy the application into GKE and enable **Vertical Pod Autoscaling** (**VPA**) to the deployment.
   4. Deploy the application into GKE and enable **Horizontal Pod Autoscaling** (**HPA**) to the deployment.
8. You want to create a sample Pod configuration file and save it in YAML format. How can you do this without writing the code yourself?
   1. Use the **gcloud containers describe application APPLICATION\_NAME --dry-run=client -o** **yaml** command.
   2. Use the **kubectl APPLICATION\_NAME --image=IMAGE\_NAME --dry-run=client -o** **yaml** command.
   3. Use the **kubectl APPLICATION\_NAME --image=IMAGE\_NAME --run-dry=client -o** **yaml** command.
   4. Use the **kubectl APPLICATION\_NAME --image=IMAGE\_NAME -o** **yaml** command.
9. What are the default visible metrics in the deployment details located in the workload overview section?
   1. CPU and memory
   2. CPU, memory, and IOPS
   3. CPU, memory, and disk
   4. CPU, disk, and requests
10. You are being tasked with managing an application that runs on GKE. You need to find out which service is used with the application. Which command will you use?
    1. **kubectl describe** **service YOUR\_SERVICENAME**
    2. **kubectl list** **service YOUR\_SERVICENAME**
    3. **gcloud describe** **service YOUR\_SERVICENAME**
    4. **gcloud list** **service YOUR\_SERVICENAME**

# Answers

The answers to the preceding questions are provided here:

1A, 2A, 3B, 4C, 5A, 6B, 7A, 8B, 9C, 10A