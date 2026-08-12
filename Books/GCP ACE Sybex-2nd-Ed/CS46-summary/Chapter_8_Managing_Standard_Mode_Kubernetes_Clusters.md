# Chapter 8: Managing Standard Mode Kubernetes Clusters

## Exam Objective Covered

- **4.2 Managing Google Kubernetes Engine resources**

---

## Introduction

This chapter covers basic Kubernetes management tasks:

- Viewing the status of Kubernetes clusters
- Viewing image repositories and image details
- Adding, modifying, and removing nodes
- Adding, modifying, and removing pods
- Adding, modifying, and removing services

Tasks can be performed via Google Cloud Console, Cloud SDK (locally or on a GCP VM), or Cloud Shell.

---

## Viewing the Status of a Kubernetes Cluster

### Viewing the Status of Kubernetes Clusters Using Cloud Console

Navigate to **Kubernetes Engine** from the Cloud Console navigation menu to see a list of running clusters.

![Navigation menu in Google Cloud Console](../images/c08f001.png)

**Figure 8.1** Navigation menu in Google Cloud Console

![Selecting Kubernetes Engine from the navigation menu](../images/c08f002.png)

**Figure 8.2** Selecting Kubernetes Engine from the navigation menu

#### Pinning Services to the Top of the Navigation Menu

Any service in the navigation menu can be pinned to the top by mousing over the product and clicking the pin icon. Pinned services appear at the top of the navigation menu for quick access.

![Pinning a service to the top of the navigation menu](../images/c08f003.png)

**Figure 8.3** Pinning a service to the top of the navigation menu

After clicking Kubernetes Engine, a list of running clusters is displayed.

![Example list of clusters in Kubernetes Engine](../images/c08f004.png)

**Figure 8.4** Example list of clusters in Kubernetes Engine

Click the name of a cluster to display its details. The cluster Details page has several tabs: **Details**, **Nodes**, **Storage**, **Observability**, and **Logs**.

![Click the name of a cluster to display its details](../images/c08f005.png)

**Figure 8.5** Click the name of a cluster to display its details.

![The first part of the cluster Details page describes the configuration of the cluster](../images/c08f006.png)

**Figure 8.6** The first part of the cluster Details page describes the configuration of the cluster.

**Nodes tab** — Shows node pools and individual nodes. Node Pools section shows: number of nodes, machine type, image type, and other attributes. Nodes section shows: status, requested and allocatable CPUs, memory, and storage.

![Add-on and permission details for a cluster](../images/c08f007.png)

**Figure 8.7** Add-on and permission details for a cluster

**Node Pool details** — Includes node image, machine type, total vCPUs (Total Cores), disk type, and whether nodes are preemptible.

![Details about node pools in the cluster](../images/c08f008.png)

**Figure 8.8** Details about node pools in the cluster

**Storage tab** — Shows persistent volumes and storage classes used by the cluster. A *storage class* is a type of storage with policies specifying quality of service, backup policy, and a provisioner.

![Storage information about a cluster](../images/c08f009.png)

**Figure 8.9** Storage information about a cluster

**Observability tab** — Shows metrics about cluster performance.

**Logs tab** — Shows a log of messages from the cluster.

![Log of nodes in the cluster](../images/c08f010.png)

**Figure 8.10** Log of nodes in the cluster

**Node details** — Click a node name to see CPU utilization, memory consumption, disk I/O, and a list of pods running on the node.

![Example details of a node running in a Kubernetes cluster](../images/c08f011.png)

**Figure 8.11** Example details of a node running in a Kubernetes cluster

**Pod status** — Click a pod name to see CPU, memory, and disk statistics, plus configuration details (creation time, labels, log links, and status).

| Pod Status | Meaning |
|---|---|
| **Running** | Pod is actively running |
| **Pending** | Pod is downloading images |
| **Succeeded** | Pod terminated successfully |
| **Failed** | At least one container failed |
| **Unknown** | Control plane cannot reach the node |

![Pod status display, with the status Running](../images/c08f012.png)

**Figure 8.12** Pod status display, with the status Running

**Container details** — Click a container name within a pod to see its status, start time, running command, and mounted volumes.

![Details of a pod running on a node](../images/c08f013.png)

**Figure 8.13** Details of a pod running on a node

---

### Viewing the Status of Kubernetes Clusters Using Cloud SDK and Cloud Shell

> **Note:** `gcloud` Kubernetes Engine commands use `gcloud container` (not `gcloud kubernetes`) because the service was originally called **Google Container Engine** before being renamed Kubernetes Engine in November 2017.

**List all clusters:**

```bash
gcloud container clusters list
```

![Example output from the gcloud container clusters list command](../images/c08f014.png)

**Figure 8.14** Example output from the `gcloud container clusters list` command

**Describe a specific cluster:**

```bash
gcloud container clusters describe --zone us-central1-a standard-cluster-1
```

Displays detailed configuration including node pools, networking, authentication information (client certificate, username, password).

![Part 1 of the information displayed by gcloud container clusters describe](../images/c08f015.png)

**Figure 8.15** Part 1 of the information displayed by the `gcloud container clusters describe` command

![Part 2 of the information displayed by gcloud container clusters describe](../images/c08f016.png)

**Figure 8.16** Part 2 of the information displayed by the `gcloud container clusters describe` command

**Configure kubeconfig for kubectl access:**

Before using `kubectl`, configure the `kubeconfig` file (which contains cluster API connection info):

```bash
gcloud container clusters get-credentials --zone us-central1-a standard-cluster-1
```

![Example output of the get-credentials command](../images/c08f017.png)

**Figure 8.17** Example output of the `get-credentials` command

**List nodes:**

```bash
kubectl get nodes
```

![Example output of the kubectl get nodes command](../images/c08f018.png)

**Figure 8.18** Example output of the `kubectl get nodes` command

**List pods:**

```bash
kubectl get pods
```

![Example output of the kubectl get pods command](../images/c08f019.png)

**Figure 8.19** Example output of the `kubectl get pods` command

**Detailed node and pod descriptions:**

```bash
kubectl describe nodes
kubectl describe pods
```

`kubectl describe pods` also includes container names, labels, conditions, network addresses, and system information.

![Partial listing of the details shown by kubectl describe nodes](../images/c08f020.png)

**Figure 8.20** Partial listing of the details shown by the `kubectl describe nodes` command

![Partial listing of the details shown by kubectl describe pods](../images/c08f021.png)

**Figure 8.21** Partial listing of the details shown by the `kubectl describe pods` command

> **Summary:** Use `gcloud container` commands to view cluster status; use `kubectl` to inspect Kubernetes-managed objects (nodes, pods, containers).

---

## Adding, Modifying, and Removing Nodes

### Adding, Modifying, and Removing Nodes with Cloud Console

Navigate to **Kubernetes Engine → Clusters**, click a cluster name, then select the **Nodes** tab.

The **Node Pools** section shows: name, status, GKE version, number of nodes, machine type, image type, and autoscaling status.

Click **Edit** on a node pool to change the number of nodes.

- To **add** nodes: increase the size.
- To **remove** nodes: decrease the size.

![Details of a cluster in Cloud Console](../images/c08f022.png)

**Figure 8.22** Details of a cluster in Cloud Console

![Details of a node pool in Cloud Console](../images/c08f023.png)

**Figure 8.23** Details of a node pool in Cloud Console

---

### Adding, Modifying, and Removing Nodes with Cloud SDK and Cloud Shell

**Resize a node pool:**

```bash
gcloud container clusters resize standard-cluster-1 \
  --node-pool default-pool \
  --num-nodes 5 \
  --region=us-central1
```

- For a **zonal cluster**: `--num-nodes` is the total number of nodes in the pool.
- For a **regional cluster**: `--num-nodes` is the number of nodes *per zone* the node pool spans.

**Enable Autoscaling on an existing cluster:**

```bash
gcloud container clusters update standard-cluster-1 \
  --enable-autoscaling \
  --min-nodes 1 \
  --max-nodes 5 \
  --zone us-central1-a \
  --node-pool default-pool
```

---

> ### Real World Scenario: Keeping Up with Demand with Autoscaling
>
> It is often difficult to predict demand on a service. Rather than manually changing the number of vCPUs, enable **Autoscaling** to automatically add or remove nodes based on demand. Autoscaling can be enabled at cluster creation time via Cloud Console or `gcloud`. Benefits:
> - More resilient to unexpected spikes and long-term peak shifts
> - Optimizes cost by not running excess servers when demand is low
> - Maintains performance by ensuring sufficient nodes are available

---

## Adding, Modifying, and Removing Pods

> **Best Practice:** Do not manipulate pods directly. Kubernetes maintains the number of pods specified in a deployment. To change pod count, change the **deployment configuration**.

### Adding, Modifying, and Removing Pods with Cloud Console

Pods are managed through **deployments**. The *replicas* parameter of a deployment controls the number of pods running.

Navigate to **Kubernetes Engine → Workloads** to see the deployment list.

![Deployment list of a cluster](../images/c08f024.png)

**Figure 8.24** Deployment list of a cluster

Click a deployment name to see its details, then click a pod name in the **Managed Pods** section to see pod details (a Delete button is available but direct pod deletion is not a best practice).

![Multiple forms contain details of a deployment and include a menu of actions](../images/c08f025.png)

**Figure 8.25** Multiple forms contain details of a deployment and include a menu of actions you can perform on the deployment.

![Details of a pod running in GKE](../images/c08f026.png)

**Figure 8.26** Details of a pod running in GKE

**Scale replicas:** Select **Actions → Scale** to set a new replica count.

![Set the number of replicas for a deployment](../images/c08f027.png)

**Figure 8.27** Set the number of replicas for a deployment.

**Autoscale:** Select **Actions → Autoscale** to specify a minimum and maximum number of replicas.

![Enable Autoscaling to automatically add and remove replicas as needed depending on load](../images/c08f028.png)

**Figure 8.28** Enable Autoscaling to automatically add and remove replicas as needed depending on load.

**Expose:** The Actions menu also allows exposing a service on a port.

![Form to expose services running on pods](../images/c08f029.png)

**Figure 8.29** Form to expose services running on pods

**Rolling Update:** Specify rolling update parameters: minimum seconds before considering a pod updated, maximum pods above target size, and maximum unavailable pods.

![Form to specify parameters for rolling updates of code running in pods](../images/c08f030.png)

**Figure 8.30** Form to specify parameters for rolling updates of code running in pods

---

### Adding, Modifying, and Removing Pods with Cloud SDK and Cloud Shell

> **Note:** "Service" (capital S) refers to the Kubernetes abstraction that exposes pods on a network. "service" (lowercase) refers generically to an application.

**List deployments:**

```bash
kubectl get deployments
```

**Scale pods (change replica count):**

```bash
kubectl scale deployment nginx-1 --replicas 5
```

**Enable Autoscaling for pods:**

```bash
kubectl autoscale deployment nginx-1 --max 10 --min 1 --cpu-percent 80
```

Adds or removes pods automatically when CPU utilization exceeds 80%, with a minimum of 1 and maximum of 10 pods.

**Delete a deployment:**

```bash
kubectl delete deployment nginx-1
```

---

## Adding, Modifying, and Removing Services

A **Service** is a Kubernetes abstraction that groups a set of pods as a single network-accessible resource.

### Adding, Modifying, and Removing Services with Cloud Console

Navigate to **Kubernetes Engine → Workloads** to see the deployment list. Click **Deploy** to create a new deployment/service.

![Deployment list along with a Deploy command to create new services](../images/c08f031.png)

**Figure 8.31** Deployment list along with a Deploy command to create new services

In the deployment form, specify:
- **Container Image** — image path (e.g., `gcr.io/google-samples/hello-app:2.0`) or select from Google Container Repository
- **Labels**
- **Initial command**
- **Application name**

![Form that lets you specify a new deployment for a service](../images/c08f032.png)

**Figure 8.32** Form that lets you specify a new deployment for a service

After creating a deployment, click its name to see a list of Services it exposes.

![Details of Services exposing a deployment](../images/c08f033.png)

**Figure 8.33** Details of Services exposing a deployment

To delete a Service, navigate to the Service Details page and use the **Delete** option in the horizontal menu.

![Navigate to the Service Details page to delete a service](../images/c08f034.png)

**Figure 8.34** Navigate to the Service Details page to delete a service using the Delete option in the horizontal menu.

---

### Adding, Modifying, and Removing Services with Cloud SDK and Cloud Shell

**List Services:**

```bash
kubectl get services
```

**Create a deployment (and start a Service):**

```bash
kubectl create deployment hello-server \
  --image=gcr.io/google/samples/hello-app:1.0 \
  --port 8080
```

Downloads and starts the image; accessible on port 8080 within the cluster.

**Expose a deployment (make accessible outside the cluster):**

```bash
kubectl expose deployment hello-server --type="LoadBalancer"
```

A load balancer acts as the external endpoint for outside resources.

**Delete a Service:**

```bash
kubectl delete service hello-server
```

---

## Creating Repositories in the Artifact Registry

**Artifact Registry** is the recommended Google Cloud service for storing container images. (Container Registry was used previously but Artifact Registry is now preferred.)

### Viewing the Image Repository and Image Details with Cloud Console

Navigate to **Artifact Registry** from the navigation menu to see a list of repositories.

![A listing of repositories in Artifact Registry](../images/c08f035.png)

**Figure 8.35** A listing of repositories in Artifact Registry

Click **+** to create a new repository. Artifact Registry supports multiple repository types:

| Repository Type | Use Case |
|---|---|
| Docker | Container images for Kubernetes/Cloud Run |
| Maven | Java framework packages |
| Python | Python packages |
| Others | npm, apt, yum, etc. |

![Creating a repository in Artifact Registry](../images/c08f036.png)

**Figure 8.36** Creating a repository in Artifact Registry

After creation, Artifact Registry provides detailed configuration commands for each repository type.

![Example instructions for configuring a Docker repository](../images/c08f037.png)

**Figure 8.37** Example instructions for configuring a Docker repository

---

## Summary

| Task | Cloud Console | Cloud SDK / Cloud Shell |
|---|---|---|
| View cluster status | Navigate to Kubernetes Engine, click cluster name | `gcloud container clusters list` / `describe` |
| View nodes | Cluster Details → Nodes tab | `kubectl get nodes` / `kubectl describe nodes` |
| View pods | Cluster Details → click node → click pod | `kubectl get pods` / `kubectl describe pods` |
| Configure kubectl | N/A | `gcloud container clusters get-credentials` |
| Resize nodes | Nodes tab → Edit node pool | `gcloud container clusters resize` |
| Enable node autoscaling | Node pool settings | `gcloud container clusters update --enable-autoscaling` |
| Scale pods | Workloads → Actions → Scale | `kubectl scale deployment` |
| Enable pod autoscaling | Workloads → Actions → Autoscale | `kubectl autoscale deployment` |
| Create a Service | Workloads → Deploy | `kubectl create deployment` |
| Expose a Service | Actions → Expose | `kubectl expose deployment` |
| Delete a Service | Service Details → Delete | `kubectl delete service` |
| View images | Artifact Registry | `gcloud container images list` / `describe` |

---

## Exam Essentials

- **Know how to view the status of a Kubernetes cluster.** Use Cloud Console to list clusters and drill down to see node, pod, and container details. Use `gcloud container clusters list` and `gcloud container clusters describe`.

- **Understand how to add, modify, and remove nodes.** Use Cloud Console (Nodes tab → Edit node pool) or `gcloud container clusters resize`. Enable Autoscaling with `gcloud container clusters update --enable-autoscaling`.

- **Understand how to add, modify, and remove pods.** Best practice is to manage pods through deployments, not directly. Use `kubectl get deployments`, `kubectl scale deployment`, and `kubectl autoscale deployment`.

- **Understand how to add, modify, and remove Services.** Use Cloud Console (Workloads → Deploy / Actions → Expose) or `kubectl create deployment`, `kubectl expose deployment`, and `kubectl delete service`.

---

## Review Questions

1. You are running several microservices in a Kubernetes cluster. You've noticed some performance degradation. After reviewing some logs, you begin to think the cluster may be improperly configured, and you open Cloud Console to investigate. How do you see the details of a specific cluster?
   - A. Type the cluster name into the search bar.
   - **B. Click the cluster name.**
   - C. Use the `gcloud cluster details` command.
   - D. None of the above.

2. You are viewing the details of a cluster in Cloud Console and want to see how many vCPUs are available in the cluster. Where would you look for that information?
   - **A. Node Pools section of the Nodes Details page**
   - B. Labels section of the Cluster Details page
   - C. Summary line of the Cluster Listing page
   - D. None of the above

3. You have been assigned to help diagnose performance problems with applications running on several Kubernetes clusters. The first thing you want to do is understand, at a high level, the characteristics of the clusters. Which command should you use?
   - A. `gcloud container list`
   - **B. `gcloud container clusters list`**
   - C. `gcloud clusters list`
   - D. None of the above

4. When you first try to use the `kubectl` command, you get an error message indicating that the resource cannot be found or you cannot connect to the cluster. What command would you use to try to eliminate the error?
   - A. `gcloud container clusters access`
   - **B. `gcloud container clusters get-credentials`**
   - C. `gcloud auth container`
   - D. `gcloud auth container clusters`

5. An engineer recently joined your team and has not properly labeled several clusters. You want to modify the labels on the cluster from Cloud Console. How would you do it?
   - A. Click the Connect button.
   - B. Click the Deploy menu option.
   - **C. Click the Edit menu option.**
   - D. Type the new labels in the Labels section.

6. You receive a page in the middle of the night informing you that several services running on a Kubernetes cluster have high latency. You decide to add six more VMs to the cluster. What parameters will you need to specify when you issue the `cluster resize` command?
   - A. Cluster size
   - B. Cluster name
   - C. Node pool name
   - **D. All of the above**

7. You want to modify the number of pods in a cluster. What is the best way to do that?
   - A. Modify pods directly
   - **B. Modify deployments**
   - C. Modify node pools directly
   - D. Modify nodes

8. You want to see a list of deployments. Which option from the Kubernetes Engine navigation menu would you select?
   - A. Clusters
   - B. Storage
   - **C. Workloads**
   - D. Deployments

9. What actions are available from the Actions menu when viewing deployment details?
   - A. Scale and Autoscale only
   - **B. Autoscale, Expose, and Rolling Update**
   - C. Add, Modify, and Delete
   - D. None of the above

10. What is the command to list deployments from the command line?
    - A. `gcloud container clusters list-deployments`
    - B. `gcloud container clusters list`
    - **C. `kubectl get deployments`**
    - D. `kubectl deployments list`

11. What parameters of a deployment can be set in the Create Deployment page in Cloud Console?
    - A. Container image
    - B. Cluster name
    - C. Application name
    - **D. All of the above**

12. Where can you view a list of applications when using Cloud Console?
    - **A. In the Deployment Details page**
    - B. In the Container Details page
    - C. In the Cluster Details page
    - D. None of the above

13. What `kubectl` command is used to create a deployment?
    - A. `run`
    - B. `start`
    - C. `initiate`
    - D. `deploy`

    > **Note:** The correct answer is `kubectl create deployment` — none of the listed options match. **D. None of the above** (the command is `create deployment`).

14. You are supporting machine learning engineers who want `ml-classifier-3` removed from the cluster. What would you do to delete a service called `ml-classifier-3`?
    - **A. Run the command `kubectl delete service ml-classifier-3`.**
    - B. Run the command `kubectl delete ml-classifier-3`.
    - C. Run the command `gcloud service delete ml-classifier-3`.
    - D. Run the command `gcloud container service delete ml-classifier-3`.

15. What service is responsible for managing container images?
    - A. Kubernetes Engine
    - B. Compute Engine
    - **C. Artifact Registry**
    - D. Container Engine

16. What command is used to list container images in the command line?
    - **A. `gcloud container images list`**
    - B. `gcloud container list images`
    - C. `kubectl list container images`
    - D. `kubectl container list images`

17. A data warehouse designer wants to deploy an ETL process to Kubernetes and has provided a list of required libraries. You want to get a detailed description of candidate container images. How would you do this?
    - A. Run the command `gcloud container images list details`.
    - **B. Run the command `gcloud container images describe`.**
    - C. Run the command `gcloud image describe`.
    - D. Run the command `gcloud container describe`.

18. You have just created a deployment and want applications outside the cluster to have access to the pods. What do you need to do?
    - A. Give it a public IP address.
    - **B. Issue a `kubectl expose deployment` command.**
    - C. Issue a `gcloud expose deployment` command.
    - D. Nothing; making it accessible must be done at the cluster level.

19. You have deployed an application to a Kubernetes cluster that processes sensor data from a fleet of delivery vehicles. Customer orders fluctuate based on time of day, season, and advertising campaigns. You want to ensure sufficient nodes while minimizing costs. How should you configure the cluster?
    - A. Deploy as many nodes as your budget allows.
    - **B. Enable Autoscaling.**
    - C. Monitor CPU, disk, and network utilization and add nodes as necessary.
    - D. Write a script to run `gcloud` commands to add and remove nodes when peaks usually start and end.

20. When using Kubernetes Engine, which of the following might a cloud engineer need to configure?
    - A. Nodes, pods, services, and clusters only
    - **B. Nodes, pods, services, clusters, and container images**
    - C. Nodes, pods, clusters, and container images only
    - D. Pods, services, clusters, and container images only
