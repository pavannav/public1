# 9

# Configuring and Implementing Networking Components

This chapter will explore how to build a network and configure network services for your workloads in Google Cloud. We are going to cover the following topics:

- Virtual Private Cloud
- Hybrid networking
- Securing cloud networks with firewall rules
- Cloud DNS
- Network load balancing

Networking is the foundation of every system architecture. However, connecting internal cloud workloads across projects, exposing services to the internet, or building a hybrid network between an on-premises location and Google Cloud can be challenging. Therefore, it is worth understanding how Google Cloud’s network services portfolio could be used to build secure and reliable architectures.

Throughout this chapter, we will explore the concept of a **Virtual Private Cloud** (**VPC**) and its application in securing and connecting networks. Additionally, we will gain insight into the functioning of the DNS service in Google Cloud and identify the appropriate network load balancers for different types of workloads.

# Virtual Private Cloud

A VPC is a networking service for your Google Cloud workloads, such as Compute Engine VMs or GKE. It is commonly referred to as a logical representation of a network in a cloud. Unlike a physical network in a data center, all its complex networking aspects are abstracted, allowing users to focus solely on consumption rather than configuration.

A VPC is a global service that consists of one or more subnets that can be created in the same or different Google Cloud regions. Google Cloud uses subnets to organize and manage resources in a VPC by dividing it into regional segments. A subnet is identified by a region and an IP range defined in **Classless Inter-Domain Routing** (**CIDR**) notation. CIDR can be described as a group of IP addresses used by a network (a subnet, in this case). It looks like a regular IP address but ends with a slash and a number. The number after the slash tells you how many addresses are within the range. For example, a CIDR IP address in IPv4 of **10.0.1.0**/**24** can be used by a subnet that needs 256 IP addresses (from **10.0.1.0** to **10.0.1.255**).

Regardless of their region, subnets in the same VPC are seamlessly connected without requiring any extra setup, such as VPN. Communication between workloads in the same VPC is internal and does not travel over the internet.

Please note that it is possible to create multiple VPCs for each project. However, they will be separated from each other by default.

The communication between workloads in the same VPC, but also to different VPCs or external environments, is always controlled by the firewall rules of a VPC. For example, even if VMs in different subnets of the same VPC should be able to communicate with each other, firewall rules that explicitly allow this communication must exist. We will cover firewall rules later in this chapter.

The following diagram shows an example of a project with two VPCs: VPC A and VPC B. Each VPC has three subnets configured in different regions, including Subnet1, Subnet2, and Subnet3 in VPC A, and SubnetA, SubnetB, and SubnetC in VPC B. Subnets within the same VPC are already connected and do not require any additional configuration. However, communication between workloads in different VPCs will require a VPN connection or VPC peering. In both cases, firewall rules must be in place to enable traffic between workloads:

![Figure 9.1 – Subnets in the same VPC can communicate with each other. Firewall rules control this communication. Subnets in different VPCs require additional setup to connect](../images/B18851_09_01.jpg)

Figure 9.1 – Subnets in the same VPC can communicate with each other. Firewall rules control this communication. Subnets in different VPCs require additional setup to connect

You can create a VPC network, subnets, and firewall rules in Google Cloud Console or using **gcloud compute** commands. For example, to create **my-vpc-network** in the **my-demo-project** project, the following command could be used:

```
gcloud compute networks create my-vpc-network --project=my-demo-project --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
```

To create a **10.0.0.0/24** subnet called **my-first-subnet** in **my-vpc-network** in **europe-central2** region, you could use this command:

```
gcloud compute networks subnets create my-first-subnet --project=my-demo-project --range=10.0.0.0/24 --stack-type=IPV4_ONLY --network=my-vpc-network --region=europe-central2
```

To create a new VPC in Google Cloud Console, go to the **VPC networks** menu and select *Create VPC network* (shown in *Figures 9.2* and *9.3*). You can also add additional subnets to an existing VPC by editing an existing subnet.

![Figure 9.2 – Creating a VPC network in Google Cloud Console](../images/B18851_09_02.jpg)

Figure 9.2 – Creating a VPC network in Google Cloud Console

It is important to note that subnets can be created either during the initial creation of a VPC network or at any point thereafter.

To connect to workloads in **my-first-subnet** or other subnets in **my-vpc-network**, firewall rules that allow this communication must exist. To create a firewall rule called **ssh-rdp-ping** that allows all users (from the default source range, **0.0.0.0/0**) to access all instances in **my-vpc-network** on TCP ports **22 (SSH)** and **3389 (RDP)** and to send a ping (ICMP), the following command could be used:

```
gcloud compute firewall-rules create ssh-rdp-ping  --network my-vpc-network --allow tcp:22,tcp:3389,icmp
```

With the command from the preceding example, we created a subnet in **my-vpc-network** with an assigned IP address range in CIDR notation (**10.0.0.0/24**). The mode where you manually assign IP address ranges to subnets is called **Custom mode**. Alternatively, **Automatic mode** could be used.

![Figure 9.3 – Automatic subnet creation mode in VPC](../images/B18851_09_03.jpg)

Figure 9.3 – Automatic subnet creation mode in VPC

Here are the differences between these modes:

- **Automatic mode**: This is where subnets are pre-populated for every region in a VPC network. There is a dedicated CIDR of **10.128.0.0/9** that is used for this purpose. Every region has a **/20** subnet, which allows up to 4,094 addresses to be created, excluding network, gateway, second-to-last, and broadcast addresses. In the preceding screenshot, you can see that **10.160.0.0/20** will be used by a subnet in the **asia-south1** region. When a new region is created, additional subnets are automatically added to a VPC in **auto mode**. Using auto mode doesn’t prevent you from adding more subnets manually later. A VPC network configured with auto mode can transition to custom mode, but this action can’t be reversed.
- **Custom mode**: This is where no subnets are automatically created. You control which regions you want subnets to be created in and what their IP ranges and mask length will be. The minimal range that can be configured is **/29**. You are responsible for planning ranges with custom mode, so there is no CIDR overlap. Custom mode can’t be switched to **auto mode**. Also, you can expand a custom mode subnet, but a shrink operation is not allowed. The **10.0.0.0/24** subnet, **my-first-subnet**, from our example, can be expanded to **/23** with the following command:

  ```
  $ gcloud compute networks subnets expand-ip-range my-first-subnet --region=europe-central2 --prefix-length=23 The IP range of subnetwork [my-first-subnet] will be expanded from 10.0.0.0/24 to 10.0.0.0/23. This operation may take several minutes to complete and cannot be undone.
  ```

In the following example, there are two VPCs – **global-vpc**, with three subnets deployed in three regions across the globe, and **regional**, with two subnets deployed in one region only. VPC is a global service, but with **custom mode**, you can choose where to create networks:

![Figure 9.4 – Custom mode subnets in VPC](../images/B18851_09_04.jpg)

Figure 9.4 – Custom mode subnets in VPC

When managing a VPC, it is crucial to understand which roles are required to create networking resources and which roles allow you to assign resources to workloads. For example, a predefined IAM **Compute Network Admin** role provides full control over all network resources except firewall rules and SSL certificates. On the other hand, **Compute Security Admins** role can only manage firewall rules and SSL certificates. A **Compute Network User** role allows you to assign subnets from a **Shared VPC** to local workloads.

## Networking for Compute Engine VMs

The *GCE network* section in [*Chapter 4*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_04.xhtml#_idTextAnchor080) describes what a Compute Engine VM creation task looks like. One of the demonstrated steps was assigning a VM to a VPC subnet and selecting a static/ephemeral public/private IP address for a VM. Once a VM has been created, it can communicate with other VMs in a VPC if firewall rules allow it. Note that a Compute Engine VM can only be deployed in a region where a local subnet exists.

In *Figure 9**.4*, there are three VMs named **warsaw**, **vegas**, and **sydney** that have been deployed in different regions of **global-vpc**. The following screenshot provides a Google Cloud Console view of their deployment:

![Figure 9.5 – Compute Engine VMs in global-vpc](../images/B18851_09_05.jpg)

Figure 9.5 – Compute Engine VMs in global-vpc

Once a firewall rule has been set up to accept ICMP and TCP traffic within VMs with a **global-network** tag (network tags will be described later in this chapter in the *Securing cloud networks* *with* *firewall rules* section), we can open an SSH session to one of the VMs and ping the other two. The following screenshot shows a console view for the **sydney** VM. The output of a **traceroute** command to the **vegas** VM and the **warsaw** VM shows that they are just a single hop away. Although traffic crosses the globe (latency values are a good indicator of the distance between VMs), the network structure for subnets in regions in the same VPC is simple:

![Figure 9.6 – Compute Engine VMs that belong to the same VPC are just one hop away from each other, despite being deployed across the globe](../images/B18851_09_06.jpg)

Figure 9.6 – Compute Engine VMs that belong to the same VPC are just one hop away from each other, despite being deployed across the globe

To better understand the behavior of Compute Engine VMs, you can enable **VPC Flow Logs** on the subnets in which they are deployed. The **VPC Flow Logs** feature is configured at the subnet level. It takes samples of network flows that can be used for further security analysis or troubleshooting. For example, the following screenshot shows a sample flow that’s been captured between the **warsaw** and **sydney** VMs when viewed in **Logs Explorer**:

![Figure 9.7 – The VPC flow logs of the “warsaw” subnet in Logs Explorer showing the “warsaw” VM communicating with the “sydney” VM](../images/B18851_09_07.jpg)

Figure 9.7 – The VPC flow logs of the “warsaw” subnet in Logs Explorer showing the “warsaw” VM communicating with the “sydney” VM

Another useful feature that can be used to analyze and troubleshoot connectivity between VMs is **Connectivity Test** from the **Network** **Intelligence** section:

![Figure 9.8 – The Connectivity Test view with a test that verifies if the ping sent from the “sydney” VM can reach the “warsaw” VM](../images/B18851_09_08.jpg)

Figure 9.8 – The Connectivity Test view with a test that verifies if the ping sent from the “sydney” VM can reach the “warsaw” VM

When creating a **Connectivity Test** view, you must define the protocol that you want to test, such as ICMP, TCP, or UDP. The source endpoint can be, among others, an IP address, a VM, App Engine, Cloud SQL, a GKE cluster control plane or Cloud Run, a destination endpoint, or a port number. Then, **Connectivity Test** checks the configuration between endpoints and sends packets to check if the communication is working. As a result, you either get a confirmation that the test was successful or a possible reason for failing. For example, the following screenshot presents a failed ping test, where traffic was dropped because of a **block-traffic** firewall rule:

![Figure 9.9 – The result of Connectivity Test shows it is a firewall rule that blocks communication between VMs](../images/B18851_09_09.jpg)

Figure 9.9 – The result of Connectivity Test shows it is a firewall rule that blocks communication between VMs

Setting up connectivity for Compute Engine VMs can seem to be difficult, especially if you’re just starting. With different subnets and multiple firewall rules to deal with, it’s easy to feel overwhelmed. Thankfully, there are tools such as VPC Flow Logs and Connectivity Center that can provide valuable insights into any potential issues. This makes it much easier to troubleshoot any problems you may encounter.

## Shared VPCs

Managing networking can be challenging when an organization owns multiple projects with multiple VPCs and subnets. For example, someone will have to track if users that create subnets don’t use IP ranges that overlap (if some VPCs need to be connected in the future). In addition, someone will have to ensure that all projects have unified security settings and firewall rules. Also, if projects need access to an on-premises environment, each one will come with an additional dedicated VPN gateway or Interconnect and Cloud Router to manage.

To simplify network architectures, you can leverage a Shared VPC, where a **host project** shares a VPC with multiple **service projects** within the same organization. It is a centralized approach to multi-project networking. As a result, you get fewer networking components to manage, but you can still keep separate budgets for different projects. Service projects can continue to use their standalone VPC subnets. Still, the idea is only to use networking services such as subnets, routers, VPN gateways, and Interconnect links defined centrally in a host project. A single service project can only be attached to one host project. Usually, host projects are managed by networking and security admins, who prepare all network configurations and enforce firewall and security policies. Owners of service projects can then focus on their workloads.

The following diagram shows a host project that has a VPC and Interconnect to on-premises and regional subnets set up by a networking team with firewall rules created by a security team.

There are three service projects – **production**, **test**, and **analytics** – that have Compute Engine VMs with assigned subnets from the host project. With Shared VPC, users in these service projects don’t have to worry about setting up or managing the network themselves; they can simply use it:

![Figure 9.10 – Shared VPC concept where VPC subnets deployed in a host project are used by Compute Engine VMs in a service project](../images/B18851_09_10.jpg)

Figure 9.10 – Shared VPC concept where VPC subnets deployed in a host project are used by Compute Engine VMs in a service project

To get a better understanding of how to set up a Shared VPC, let’s take a closer look at the necessary configuration steps:

1. To provision a Shared VPC, you need to go to the **Shared VPC** page in the **VPC network** section. In addition to selecting a host project, you can choose to share all subnets in a VPC or select individual ones. Note that you need a **Shared VPC Admin** role (at the organizational level) to set up a host project:

![Figure 9.11 – Setting up a Shared VPC where three individual subnets will be shared with service projects](../images/B18851_09_11.jpg)

Figure 9.11 – Setting up a Shared VPC where three individual subnets will be shared with service projects

1. In the next step, in the same **Shared VPC** view, with a **Shared VPC Admin** role, you can add projects from your organization that will be allowed to use subnets from a Shared VPC. Next, you must delegate access to selected or all subnets of the Shared VPC to Service Project Admins by assigning them a **Network User** role on selected subnets. Service Project Admins are usually owners of their projects, which allows them to create resources in service projects such as Compute Engine VMs.
2. Once the project becomes a service project, its VM instances, instance templates, or load balancers can have networks from a host project assigned to them. For example, the following screenshot demonstrates a VM instance creation view with the option to select a shared subnet:

![Figure 9.12 – Creating a Compute Engine VM with an interface in a shared subnet](../images/B18851_09_12.jpg)

Figure 9.12 – Creating a Compute Engine VM with an interface in a shared subnet

In the next section, we will investigate another approach to multi-project networking: VPC network peering.

## VPC network peering

**VPC network peering** allows private connectivity across two VPCs while keeping them administratively separated. Peered VPCs can either be in the same or different projects; they may even belong to different organizations. As opposed to a Shared VPC, managing VPC peering is decentralized. Network and security admins at both ends manage their routing and firewall tables without having access to a peer VPC.

VPC peering provides several advantages. First, it prevents VPC traffic from being exposed to the internet, resulting in increased security and reduced latency. It also offers cost savings compared to using public IP addresses for communication.

To configure VPC peering, you can use a predefined **Compute Network Admin** role. In the **VPC network** menu, there is a section for **VPC network peering**, as shown in *Figure 9**.13*.

This is where a peering connection can be initiated. It’s important to note that when you create a peering, unique IP ranges for subnets in both VPCs are required for the connection to be successfully established. A reminder of this requirement is given during the process:

![Figure 9.13 – Creating a peering connection between two VPCs](../images/B18851_09_13.jpg)

Figure 9.13 – Creating a peering connection between two VPCs

To establish a peering connection, you must indicate the VPC in your project that will be used for peering and the location of the destination VPC. Peering can occur within the same project or a different one. *Figure 9**.14* is a follow-up to the peering connection setup depicted in *Figure 9**.13*, where you can choose the network you wish to peer.

When the peering is ready, it will be in an **inactive** state because a peering needs to be configured at both ends. This means that once one side is done, a network administrator that manages the other side will have to go through similar steps for both ends to communicate. Either side can also remove the peering to stop communication.

Note that VPC peering is not transitive, and only directly peered VPCs can communicate. So, for example, if we have three VPCs called **VPC-A**, **VPC-B**, and **VPC-C**, and if **VPC-A** peers with **VPC-B**, and **VPC-B** peers with **VPC-C**, **VPC-A** won’t be able to communicate with **VPC-C**.

![Figure 9.14 – Creating a peering connection between two VPCs in the same project](../images/B18851_09_14.jpg)

Figure 9.14 – Creating a peering connection between two VPCs in the same project

The following screenshot presents how routes are exchanged between VPCs. Take a look at the **my-vpc-peering** details of the **local-vpc** network. The **local-vpc** network peers with **global-vpc**. Both belong to the same project. On the right is a **global-vpc** view that lists subnets in this VPC. The peering connection details for **my-vpc-peering** on the left list all the routes imported from **global-vpc**. You can see that the subnets match those from the **global-vpc** subnet view. When a VPC peering finalizes, both sides exchange information about their local subnets so that the opposite side can use this information and route traffic toward these subnets:

![Figure 9.15 – Creating a Compute Engine VM with an interface in a shared subnet](../images/B18851_09_15.jpg)

Figure 9.15 – Creating a Compute Engine VM with an interface in a shared subnet

VPC peers export all their subnet routes. There is no option to advertise routes selectively. If a VPC also has custom routes (such as a route to an on-premises subnet via a VPN tunnel or a static route), you can import/export such static and dynamic routes via a VPC peering connection. Similar to subnet routes, you can’t select individual custom routes.

The following screenshot presents an example of a VPC peering between two VPCs under a single project. **global-vpc** has three subnets: in **Warsaw** (**10.0.1.0/24**) in **europe-central2**, in **Sydney** (**10.0.2.0/24**) in **australia-southeast1**, and in **Vegas** (**10.0.3.0/24**) in **us-west4** region. There is also the custom route to the on-premises site in **Zurich** in the **europe-west6** (**10.99.99.0/24**) region. **local-vpc** has one subnet in **Zurich** (**172.16.0.0/24**) in the **europe-west6** region. When **local-vpc** peers with **global-vpc**, it exports its route, **172.16.0.0/24**, and imports routes from **global-vpc**: **10.0.1.0/24**, **10.0.2.0/24**, and **10.0.3.0/24**. Also, because importing custom routes is enabled, it receives a route to the on-premises site: **10.99.99.0/24**. A Compute Engine VM located in **Zurich** in the **europe-west6** region can communicate with VMs in the **global-vpc** region and on-premises subnet, assuming firewall rules allow it.

Note that although we cannot select which subnet routes are imported/exported over peering, we can leverage firewall rules to control this traffic.

![Figure 9.16 – Example of VPC peering between two VPCs](../images/B18851_09_16.jpg)

Figure 9.16 – Example of VPC peering between two VPCs

VPC peering and Shared VPC approach multi-project networking differently. Shared VPC is a centralized approach where network and security admins consolidate networking resources in a host project. Both host and service projects need to belong to the same organization. Shared VPC is often considered a concept that introduces less administrative work. But it cannot be used in scenarios where we want to connect two VPCs in the same project. Alternatively, VPC peering is a decentralized approach where administrators can only manage resources at their end. Connected VPCs can belong to the same project or a different one, even to a different organization.

Ultimately, the choice between Shared VPC and VPC peering will depend on your specific needs and goals for your network.

Now that we’ve explored how to establish a network connection between Google Cloud networks in different VPCs, let’s look at how Google Cloud networks can be linked with on-premises networks.

# Hybrid networking

This section will investigate how you can create a hybrid cloud by connecting your on-premises environment to Google. Note that similar mechanisms will allow you to build multi-cloud architectures by connecting your resources in another cloud with Google Cloud.

## Cloud Router

When two networking environments are connected, they need a way to inform their peers about their local subnets. Furthermore, route propagation should be automatic, as new subnets can be added or old ones can be deleted at any time. Google Cloud uses the **Border Gateway Protocol** (**BGP**) protocol to exchange routing information with on-premises (or another cloud) devices.

**Cloud Router** is the service that speaks the BGP protocol in Google Cloud. It is a Google-managed, highly available service that advertises routes to VPC subnets via either Interconnect or VPN connection toward an on-premises site (or to other clouds). Cloud Router is a regional resource and belongs to a VPC. It uses a unique private or public **Autonomous System Number** (**ASN**) for BGP identification.

In the **Hybrid connectivity** section, there is a **Cloud routers** creation page. To create a new Cloud Router instance, you must provide its name, ASN number, the region where it will be configured, and the VPC where it will reside. Additionally, you need to select how it will advertise the routes of its VPC. See the following figure for reference:

![Figure 9.17 – Creating a Cloud Router instance that advertises all visible VPC subnets](../images/B18851_09_17.jpg)

Figure 9.17 – Creating a Cloud Router instance that advertises all visible VPC subnets

There are two types of routes that Cloud Router can advertise:

- **Default route advertisement**: This is where Cloud Router dynamically advertises all subnet routes created in a VPC. If a VPC uses regional routing mode, Cloud Router will advertise only subnets from its region. Alternatively, if a VPC uses global routing mode, Cloud Router will advertise subnets from all regions.
- **Custom route advertisement**: This is where you can select which routes Cloud Router advertises. For example, this option can be used to advertise only a subset of local subnets or subnets outside a VPC.

In addition to being a BGP speaker, Cloud Router is also used as a control plane for a **Cloud NAT** service. Cloud NAT is a managed, regional service that allows workloads such as Compute Engine VMs and GKE to create outbound internet connections without the need for a public IP.

## High availability VPN

VPN is often considered the fastest way to connect to Google Cloud. It uses a public network and doesn’t require additional physical connection setup. Two types of Cloud VPN gateways at Google Cloud are **high availability** (**HA**) **VPN** and **Classic VPN**. Classic VPN doesn’t offer high availability and BGP support. It only supports static routing. Google recommends using HA VPN whenever possible and Classic VPN only in cases where on-premises VPN devices don’t support BGP. This section will focus on the HA VPN type of gateway.

A VPN gateway is a regional resource that uses IPSec tunnels with IKE encryption to establish a secure connection over the internet. It uses a pre-shared key to encrypt the traffic, so both sides of the connection need to know the key. Cloud VPN comes with external IP addresses that will be used to create tunnels over a public network. Although it is possible to set up only one tunnel, two or four (to another cloud provider) are required for 99.99% availability. Each Cloud VPN tunnel supports up to 3 Gbps together for ingress and egress traffic.

The following screenshot presents an example of a VPN tunnel configuration between the Google Cloud VPC **global-vpc** and **on-premises** devices. Although VPC is global and has subnets in the **europe-cental2** (**10.0.1.0/24**), **australia-southeast** (**10.0.2.0/24**), and **us-west4** (**10.0.3.0/24**) regions, VPN Gateway and Cloud Router are regional resources, which in this case are deployed in the **europe-central2** region only. The VPN gateway has two interfaces, each with a Public IP, that are used to set up two tunnels to the **on-premises** site. On the **on-premises** site, there are two VPN gateways, each with one interface with a public IP address. Behind the VPN gateways is a router that has a route to an **on-premises** subnet (**10.99.0.0/24**). Both sides are connected with two VPN tunnels. Two BGP sessions are established between Cloud Router (**ASN 64512**) and the **on-premises** router (**ASN 64513**). Assuming Cloud Router uses default route advertisement and the VPC uses global routing, routes to all VPC subnets are advertised by Cloud Router and visible to the **on-premises** router. Also, the **on-premises** route, **10.99.99.0/24**, is visible to all subnets in **global-vpc**. Note that even if routes are visible, end-to-end communication between workloads in the cloud and **on-premises** is still controlled by firewalls that need to allow this external traffic:

![Figure 9.18 – Example of a VPN setup between a Google Cloud VPC and an on-premises environment](../images/B18851_09_18.jpg)

Figure 9.18 – Example of a VPN setup between a Google Cloud VPC and an on-premises environment

The following steps are required on the Google Cloud side to set up a VPN between Google Cloud and on-premises or another cloud:

1. Create a Cloud Router in a selected region, as presented in *Figure 9**.17*.
2. Create a Cloud VPN gateway for the same region and VPC where the Cloud Router was configured. When a gateway is created, public IP addresses of its interfaces are generated and published so that they can be used to configure the tunnels on the other side.
3. Add a peer VPN gateway (on-premises/other cloud side) by providing a name and number of VPN interfaces, along with their public IP addresses.
4. It is also possible to create a VPN connection between two VPCs in the same or a different Google Cloud project. In this case, you need to have access to peer resources. Also, a Cloud VPN gateway and a Cloud Router in this project need to exist before this setup.
5. Add VPN tunnels between both ends. Each tunnel needs to have a unique name. In this step, you must also set up IKE encryption and generate a pre-shared key.
6. Configure peer tunnel endpoints on the on-premises/another cloud side.
7. Configure a BGP session for each tunnel, where you provide the name and ASN of a peer router. You can decide to set up BGP IP and peer BGP IP addresses manually or automatically. During the BGP session setup, you can choose to either advertise all routes visible to the Cloud Router or create custom routes.
8. The same BGP session setup needs to be created on the on-premises/other cloud side. It is recommended that you aggregate routes on-premises and ensure they don’t overlap with the VPC subnet ranges.

Now that we’ve covered the steps to establish a VPN connection between on-premises and Google Cloud networks in a VPC, we can consider another option: creating Cloud Interconnect. We will also examine the differences between these two approaches

## Interconnect

While VPN is considered the fastest way to connect to Google Cloud, **Cloud Interconnect** is the fastest connection to Google Cloud.

Like VPN, Cloud Interconnect enables communication based on internal IP addresses between workloads that are on-premises (or in another cloud) and created via a VPC. The difference between VPN and Interconnect is that Interconnect uses a dedicated physical connection and offers higher throughput. At the same time, VPN traverses the public network and offers from 1.5 to 3 Gbps per tunnel.

There are two types of Cloud Interconnect:

- **Dedicated Interconnect**: This is a direct physical connection between your data center and Google Cloud network in a common colocation facility. The following capacities are supported: **1x 10** Gbps up to **8x 10** Gbps, **1x 100** Gbps up **to 2x 100** Gbps. Exchanging routes between two sites requires a BGP session to be set up.

Note

Check the following link to find a list of Google’s collocation facilities where your network can meet Google’s edge point of presence: <https://cloud.google.com/network-connectivity/docs/interconnect/concepts/choosing-colocation-facilities>.

- **Partner Interconnect**: This is a direct physical connection between your data center and an authorized service provider’s facility. It is then a partner’s responsibility to establish connectivity to Google Cloud. The available capacity per link is smaller compared to Dedicated Interconnect; it starts from 50 Mbps up to 10 Gbps per connection. Partner Interconnect is used when Google’s colocation facility is too far from a data center, or your workload’s bandwidth needs are below 10 Gbps. Also, connecting to a partner’s facility is preferred if you want to use a single physical connection to reach multiple cloud providers.

With **Partner Interconnect**, you can either use a **Layer 2** connection, where you are responsible for establishing the BGP session between a Cloud Router and your router on-premises, or a **Layer 3** connection, where your service provider establishes a BGP session between a router in the service provider network and your Cloud Router:

![Figure 9.19 – Two types of connection – Dedicated and Partner Interconnect](../images/B18851_09_19.jpg)

Figure 9.19 – Two types of connection – Dedicated and Partner Interconnect

Note

Check the following link to find a list of supported service providers that offer Layer 2 and Layer 3 connectivity to Google Cloud: <https://cloud.google.com/network-connectivity/docs/interconnect/concepts/service-providers>.

# Securing cloud networks with firewall rules

As mentioned earlier in this chapter, even though subnets that belong to the same VPC are connected, it is the firewall’s role to control communication between Compute Engine VM workloads. The same applies to networks connected via Interconnect/VPN or VPC peering. When routing information is exchanged, and connectivity is established, the next step is configuring firewall rules to allow a specific type of traffic to flow between Compute Engine instances.

By definition, a VPC is an isolated domain where almost every traffic type must be implicitly allowed. Firewall rules are applied at the VPC level. Because VPC is a global service, firewall rules are also global. With a single firewall rule, you can allow or block a specific communication that crosses regions or comes from an external network to instances in various zones.

Although firewall rules are defined at the VPC level, they are executed per VM instance. This is because firewalling in Google Cloud is distributed. As a result, there is no risk that a single firewall device could become a bottleneck when traffic increases. The following screenshot presents a section of the **VPC network** view while creating a new VPC network. The proposed initial firewall rules list is presented in the **Firewall** **rules** section:

![Figure 9.20 – The pre-populated list of firewall rules when creating a VPC](../images/B18851_09_20.jpg)

Figure 9.20 – The pre-populated list of firewall rules when creating a VPC

Note that two firewall rules on this list cannot be removed. Both have the lowest priority of **65535**. The implied **deny-all-ingress** rule blocks all incoming connections to every VM instance in this VPC. The implied **allow-all-egress** rule allows all VM instances in this VPC to send traffic to any destination. Firewall rules are stateful, so the matching response can also be received by the source VM when a connection is allowed.

The following screenshot depicts an example situation where only two implied firewall rules were configured for the **my-vpc-network** VPC. When **vm-a** sends a ping to **vm-b**, even though they belong to the same subnet, **warsaw-subnet**, in the same **europe-central2** region, the firewall rules are evaluated for both individually. The ping message is allowed to egress a **vm-a** interface because of the **allow-all-egress** rule. And **vm-a** is allowed to receive a reply to the ping message because firewall rules are stateful in Google Cloud. On the other hand, **vm-b** is not allowed to receive any traffic because of the **deny-all-ingress** rule, so it will not receive the ping message. So, even though **vm-a** could receive a reply, it won’t be sent. But if **vm-a** pings a responsive resource outside the VPC, such as on the public internet (via Cloud NAT), it should be able to get a reply:

![Figure 9.21 – The pre-populated list of firewall rules when creating a VPC](../images/B18851_09_21.jpg)

Figure 9.21 – The pre-populated list of firewall rules when creating a VPC

The following screenshot presents one of the possible solutions for the ping message to be received by **vm-b**. In addition to implied firewall rules, there is a new ingress rule with a higher priority of **65534** (the lower the number, the higher the priority) that takes precedence over the **deny-all-ingress** rule, and it allows all the instances in the VPC to receive ICMP messages when a sender IP address belongs to **10.0.1.0/24**. This way, all VMs in the VPC will be able to receive ping messages from VMs in **warsaw-subnet**:

![Figure 9.22 – A new firewall rule was added to allow vm-b to receive a ping message from vm-a](../images/B18851_09_22.jpg)

Figure 9.22 – A new firewall rule was added to allow vm-b to receive a ping message from vm-a

If instead of **10.0.1.0/24** (the whole **warsaw-subnet** IP address range), **0.0.0.0/0** was selected as a source, every source that can reach this VPC could ping all instances in **my-vpc-network**.

We can narrow down or broaden the possible sources that can access our workloads. However, a good practice is to follow the principle of least privilege and assign the minimum access required for an application to work. It is also recommended to keep the number of firewall rules to a minimum by combining similar flows and grouping VMs and port ranges.

Let’s look at the possible options to adjust firewall rules so that only the necessary traffic can pass through.

Firewall rules can be added to a VPC at any time. The predefined **Compute Security Admin** role allows you to create, edit, and delete rules. **Compute Network Viewer** can be used to view rule details. When a new firewall rule is added, you need to give it a name and priority from **0** to **65535**. Next, the source and target are defined based on the direction of the flow. Each rule applies to either ingress or egress traffic from the perspective of a target (the instance that receives packets). Also, each rule can either allow or deny access when matched.

A firewall rule can apply to the following targets:

- **All instances in a VPC network**: All Compute Engine VMs deployed in a VPC. GKE clusters and App Engine-flexible environments are also considered targets.
- **Specified target tag**: This allows you to make firewall rules applicable to specific VM instances. Look at *Figure 9**.5*. It shows a list of VMs that have a network tag of **global-network**. This tag can be used if you want to create a firewall rule that applies to those VMs only.
- **Specified service account**: The rule applies only to instances with a specified service account.

The following source filters can be used for ingress rules:

- An IP address range, such as **0.0.0.0/0**, which would mean any IP address.
- A source tag, where you can group VMs from which incoming traffic is either allowed or denied to your target.
- A service account (one or more), so the source would be all VMs with a specified associated service account.
- You can also specify a second source filter to build a more accurate firewall rule. Note that you cannot build a filter by combining source tags and service accounts as first and second source filters.

In the **VPC network** menu, there is a **Firewall** section; this is where you can create firewall rules. The following figure shows the available options for rule creation, such as **Direction of traffic**, **Action on match**, and **Targets**. Take a look to see how you can customize your firewall settings:

![Figure 9.23 – Selecting a target during firewall rule creation](../images/B18851_09_23.jpg)

Figure 9.23 – Selecting a target during firewall rule creation

An IP address range, such as **0.0.0.0/0**, which would mean any IP address, can be used as a destination filter for egress traffic.

All traffic rules can apply to the following ports and protocols:

- **Allow/Deny all**: All ports and protocols are allowed or denied
- **TCP**: All for all TCP traffic or selected ports, such as **443**, or port ranges, such as **20-22**
- **UDP**: All for all UDP traffic or selected ports, such as **53**, or port ranges, such as **67-69**
- **Other**: A protocol name, such as **icmp** or **sctp**, or a protocol number

Please take a moment to review the following figure, which shows the next step in creating a firewall rule. Here, you can select a source filter and specify the appropriate ports and protocols for your firewall rule:

![Figure 9.24 – Building a source filter for an ingress firewall rule](../images/B18851_09_24.jpg)

Figure 9.24 – Building a source filter for an ingress firewall rule

If you need to troubleshoot connectivity issues, you can temporarily disable a suspected firewall rule. Alternatively, you can enable firewall logs on a per-firewall rule basis and monitor the logs in **Logs Explorer**:

![Figure 9.25 – When a rule has firewall logs enabled, it shows the rule hit count](../images/B18851_09_25.jpg)

Figure 9.25 – When a rule has firewall logs enabled, it shows the rule hit count

One of the benefits of enabling firewall logs is that you can view the overall hit count, as presented in the preceding screenshot. Also, a hit count time graph is available when viewing firewall rule details. The following screenshot shows how firewall logs can be viewed in **Logs Explorer**:

![Figure 9.26 – Monitoring logs from a firewall rule that allows SSH between VMs in Logs Explorer](../images/B18851_09_26.jpg)

Figure 9.26 – Monitoring logs from a firewall rule that allows SSH between VMs in Logs Explorer

Firewall logs can generate large numbers of logs, so they should be enabled with care, such as during troubleshooting or traffic flow analysis.

# Cloud DNS

Compute Engine VM instances use their **metadata servers** as internal DNSs to resolve the IP addresses of other VMs in the same network. A metadata server communicates with Google’s public DNS for queries outside a local network. For example, the following figure shows an SSH session to a Compute Engine VM, **vm-a**, during which it resolves the external address, **google.com**, even though, as in this case, it doesn’t have access to the internet. Also, it can resolve an address of another VM, **vm-b**, because it is in the same network and, in this case, the same subnet and zone. The **fully qualified domain name** (**FQDN**) of VMs is **vm\_name.zone.c.project\_id.internal** internally:

![Figure 9.27 – Local metadata server acting as a DNS for a Compute Engine VM](../images/B18851_09_27.jpg)

Figure 9.27 – Local metadata server acting as a DNS for a Compute Engine VM

As a metadata server can only resolve addresses for VMs in the same network and users can’t edit their configuration, for more advanced architectures that scale outside a VPC network, Cloud DNS should be used.

Cloud DNS is a Google-managed DNS service that translates domain names into IP addresses with 100% availability. It is a global service that is defined at the project level. Cloud DNS is a database where you store the zone’s DNS names of your systems and their IP addresses.

Cloud DNS supports two types of zones (where you store records for the same DNS name suffix):

- **Public zone**: This can be accessed from the internet. For example, if you want your application to be accessible by external users, a public zone such as **my-external-app.com** could be used. An existing domain can be transferred, and a new one can be registered in the **Cloud Domain** view of the **Network** **services** section.
- **Private zone**: This is accessible within private networks (in a VPC) and can be used in hybrid environments – for example, when a DNS on-premises is configured to forward queries for that zone to Cloud DNS.

Take a look at the following figure. It presents the **Cloud Domain** section of the **Networking services** menu on Google Cloud Console. If you want to configure a public zone for your Cloud DNS, you can use this section to search for an available public domain, check its price, and use Cloud DNS to publish it:

![Figure 9.28 – Public domain registration in Google Cloud Console](../images/B18851_09_28.jpg)

Figure 9.28 – Public domain registration in Google Cloud Console

Let’s examine the necessary steps for creating a private DNS zone in Cloud DNS with an example.

## Creating a zone in practice

Suppose you received a request to create a new zone called **my-zone.com** so that the **vm-a** (**10.0.1.2**) and **vm-b** (**10.0.0.3**) Compute Engine VMs that are deployed in **my-vpc-network** can communicate with each other using the **vm-a.my-zone.com** and **vm-b.my-zone.com** FQDNs. Follow these steps:

1. To create a new DNS zone, go to the **Cloud DNS** view in the **Network services** section. First, you need to specify **Zone type**, either **Private** or **Public**, and a zone name – that is, **my-zone.com**. In this case, it will be a private zone. Also, you need to specify which VPC is allowed to see **my-zone.com**. Both VMs use **my-vpc-network**, so this one should be selected:

![Figure 9.29 – Creating a private zone my-zone.com](../images/B18851_09_29.jpg)

Figure 9.29 – Creating a private zone my-zone.com

1. Once the zone has been created, you need to add the **vm-a** and **vm-b** Compute Engine VMs to **RECORD SETS**. A record set is a collection of DNS records in a zone that share the same DNS name and type:

![Figure 9.30 – Zone details view for Cloud DNS](../images/B18851_09_30.jpg)

Figure 9.30 – Zone details view for Cloud DNS

1. When you create a record set for a Compute Engine VM, you only need to provide its name and IP address. As shown in the following screenshot, for **vm-b**, it will be **10.0.1.3**. The DNS name for **vm-b** will be **vm-b.my-zone.com**:

![Figure 9.31 – Creating a record set for vm-b](../images/B18851_09_31.jpg)

Figure 9.31 – Creating a record set for vm-b

1. When a record set is created, it is visible in the **Zone** **details** view:

![Figure 9.32 – Creating a record set for a Compute Engine VM](../images/B18851_09_32.jpg)

Figure 9.32 – Creating a record set for a Compute Engine VM

1. Once a zone has been set up, you can SSH to **vm-a** and check if **vm-b.my-zone.com** is resolved to **10.0.1.3**, as presented in the preceding figure.

Now that we know how to set up a DNS zone for Google Cloud workloads, it’s worth exploring the possibilities of using DNS services in hybrid cloud environments.

## DNS forwarding for hybrid environments

In architectures where workloads that are on-premises and in Google Cloud need to communicate, along with VPN or Interconnect setup, DNS servers need to be configured so that on-premises sites can resolve Google Cloud zones and vice versa. A process where DNS queries are not handled by an initial server but are forwarded to another one is called **DNS forwarding**.

With Cloud DNS, you can configure the following:

- **Outbound forwarding**: This is where queries are forwarded from Cloud DNS to a DNS on-premises for a specified private zone and a VPC.
- **Inbound forwarding**: This is where queries are forwarded from a DNS on-premises to Cloud DNS for a specified private zone.
- **Alternative DNS Server** **as a DNS policy**: This is where no zone is defined. All queries from a specified VPC are forwarded to an external DNS server.

Note that you cannot configure forwarding to another VPC. However, if you want VPC-A to forward queries for a specific zone defined in VPC-B, you can achieve this by setting up **DNS peering**. At this point, Cloud DNS in VPC-B can either resolve the address locally or have a forwarding set for this zone to send queries, for example, to a DNS on-premises. Also, **VPC peering** is not required for **DNS peering** to work.

Let’s investigate the most popular case for hybrid environments: outbound forwarding. The following figure presents a Google Cloud project with a VPC called **my-vpc-network**:

![Figure 9.33 – Cloud DNS outbound forwarding for a zone, on-prem.com, for on-premises DNS](../images/B18851_09_33.jpg)

Figure 9.33 – Cloud DNS outbound forwarding for a zone, on-prem.com, for on-premises DNS

The VPC uses a Cloud DNS zone called **on-prem.com** that’s been configured to forward queries outside Google Cloud to on-premises DNS **10.99.99.2**. This VPC is connected to an on-premises environment via a VPN connection. Both sides exchange routing information via BGP. When a VM, **vm-a**, in the **my-vpc-network** VPC queries **on-prem.com**, Cloud DNS forwards this query to DNS on-premises. For the DNS to respond to the query on-premises, Cloud Router needs to advertise a Cloud DNS IP range of **35.199.192.0/19**. Addresses from this range are used by Cloud DNS for communication. Although it is from a public IP space, it is not routable over the internet. Therefore, this communication is private and this range needs to be specifically allowed by a firewall on-premises. Once the DNS on-premises sends a reply to Cloud DNS, it will be forwarded to **vm-a**.

So far, we have covered creating and connecting VPCs, setting up firewall rules for workload protection, and ensuring cloud-to-on-premises connectivity. We’ve also explored the DNS service. However, to achieve optimal network efficiency, there is one important service remaining that we need to discuss – the load balancing service.

# Network load balancing

When an application outgrows a single Compute Engine VM size, even of the largest type, it is time to use **managed instance groups** and load balancers to handle larger amounts of traffic.

Refer to *Figure 4**.67* in [*Chapter 4*](https://learning.oreilly.com/library/view/google-cloud-associate/9781803232713/B18851_04.xhtml#_idTextAnchor080), where this concept was initially introduced. A managed instance group is a set of identical Compute Engine instances deployed from a template in a zone or zones in a region. Thanks to the autoscaling feature, the group can dynamically grow or shrink depending on the load. When a health check detects that one of the instances has failed, it is recreated. When combined with a load balancer, a managed instance group can work as the backend of an application. The load balancer’s role is, in this case, to distribute traffic to instances based on conditions such as CPU utilization or the number of requests.

A managed instance group is just one of the supported backend types for a load balancer in Google Cloud. Other possible backend workloads, depending on the load balancer’s type, are, among others, unmanaged instance groups (instances configured individually and managed by a user) or serverless backends such as App Engine, Cloud Run, or Cloud Functions. Also, Google Cloud Storage can function as a backend that serves static content to users. This section will look into the selected load balancer types for managed instance groups. Note that all load balancer types are managed by Google and don’t require installation, patching, and maintenance.

## Global external HTTP(S) load balancer

A **global external HTTP(S) load balancer** distributes Layer 7 traffic from the internet to VMs or serverless services. It offers a single public anycast IP address that can be used across multiple backend instances in multiple regions. Requests that come from users are sent to the closest backend instances that can process them. This significantly improves the response time for globally available applications.

Because this type of load balancer faces the internet, it is often configured with **Cloud Armor**. Cloud Armor offers a **Distributed Denial of Service** (**DDoS)** defense service and **Web Application Firewall** (**WAF**) services. It can restrict access to an HTTP(S) load balancer closer to a source at the edge of the Google Cloud network to stop the unwanted traffic from flowing to a backend. In addition, with Cloud Armor, you can configure security policies to allow or deny traffic to a backend based on a source IP, an IP range, or the geographical location of a source client.

Also, an HTTP(S) load balancer is often paired with **Cloud Content Delivery Network** (**Cloud CDN**). Cloud CDN uses Google’s globally distributed points of presence to cache HTTPS content, providing faster delivery to users. When there is a request for specific content in a region and this content is not in a cache, it is forwarded to a load balancer and beyond for backend instances to retrieve it. Once retrieved, it is stored for future requests in the same location.

The following screenshot shows an example of a global external HTTP(S) load balancer serving content to users worldwide. It leverages Cloud Armour to deny traffic from unauthorized users and Cloud CDN to cache frequently requested content. Authorized users can access backend services via a single global public IP address. It is the load balancer’s role to direct traffic to the closest backend that can process the request. On the backend side, there are regional managed instance groups with autoscaling enabled. Once the volume of the requests reaches a certain level, another instance is deployed up to a specified maximum value. In this example, users from Warsaw will be served by the backend in **europe-central2**, and the backend in **australia-southeast1** will receive traffic from users in Sydney:

![Figure 9.34 – Global external HTTP(S) load balancer example with Cloud CDN and Cloud Armor](../images/B18851_09_34.jpg)

Figure 9.34 – Global external HTTP(S) load balancer example with Cloud CDN and Cloud Armor

If a managed instance group is full or inaccessible, the load balancer will forward traffic to another group with free capacity. Here, the following question may arise: What about users outside of those two regions? For example, what instance group would serve traffic coming from America?

To find an answer, let’s look at the following screenshot. It presents an HTTP(s) load balancer configuration for **my-load-balancer** in the **Load balancing** view in the **Networking services** section of Google Cloud Console. The load balancer has been configured as an HTTP load balancer with a static global IP address:

![Figure 9.35 – Global external HTTP(S) load balancer view](../images/B18851_09_35.jpg)

Figure 9.35 – Global external HTTP(S) load balancer view

On the backend side, there is a single backend service, **my-backend-service**; there are also two managed instance groups – **sydney-mig** with instances in **australia-southeast1** and **waw-mig** with instances in **europe-central2**. During the load balancer setup, a health check service called **hc2** is configured to monitor the instance’s ability to receive new connections:

![Figure 9.36 – The Backend section of the global external HTTP(S) load balancer view](../images/B18851_09_36.jpg)

Figure 9.36 – The Backend section of the global external HTTP(S) load balancer view

Assuming the service is public and accessible from all over the globe, we can verify how the traffic flows to our backend in the **MONITORING** tab:

![Figure 9.37 – The MONITORING tab of the global external HTTP(S) load balancer view](../images/B18851_09_37.jpg)

Figure 9.37 – The MONITORING tab of the global external HTTP(S) load balancer view

We can see it originates from America, Asia, and Europe. The stream from Asia lands in **sydney-mig**, the stream from Europe lands in **waw-mig**, and the stream from America also lands in **waw-mig**. In this case, **waw-mig** was selected as the closest instance group to users in America:

![Figure 9.38 – The MONITORING tab of the global external HTTP(S) load balancer view showing traffic flowing to backend instances](../images/B18851_09_38.jpg)

Figure 9.38 – The MONITORING tab of the global external HTTP(S) load balancer view showing traffic flowing to backend instances

There are other global services available besides the global external HTTP(S) load balancer. The next section will give more details about the two remaining global load balancers: SSL and TCP proxies.

## Global external TCP/SSL proxies

A global external HTTP(S) load balancer works on Layer 7, balancing workloads across regions on ports **80** and **8080** for HTTP and port **443** for HTTPS. But in cases where an application uses TCP/SSL and runs on other ports, a TCP or SSL proxy could be used. Those load balancers also use a single public IP address to access backends globally, which minimizes latency between a user and a backend. Both support a multi-regional distribution of traffic and integrate with Cloud Armor to protect their backends. The difference is that they don’t preserve a user’s IP address. Instead, SSL or TCP connections are terminated by a load balancer and then proxied to an available backend in the closest region. A TCP proxy should be used when an application uses a TCP protocol and doesn’t need SSL offloading. Alternatively, an SSL proxy offers SSL offloading so that instances on the backend don’t have to decrypt SSL traffic, saving CPU cycles that can be used to serve more users.

## External network TCP/UDP load balancers

With this load balancer configuration, you set up a regional public IP address that is still available from the internet but always points to a regional backend. Users (or Compute Engine VMs with access to the internet) from any location can access such services. Still, a load balancer can only distribute traffic between instances in the same region. For high availability, instances can be deployed in multiple zones of a region.

An external network TCP/UDP load balancer distributes traffic at the TCP/UDP (Layer 4) level on any port. It works in passthrough mode, which means it preserves the client’s IP address, and the backend responses go directly to clients bypassing a load balancer:

![Figure 9.39 – External network TCP/UDP load balancer examples](../images/B18851_09_39.jpg)

Figure 9.39 – External network TCP/UDP load balancer examples

The preceding figure presents an example with two load balancers, one used by **Service A** in **europe-central2** backed by an instance group in the same region and the second used by **Service B** in **australia-southeast1** backed by an instance group in the same region. Both represent different services that are globally accessible, just served from one region. As a result, users in different locations can access both services. Users who are closer to a configured load balancer will experience lower latency.

## Internal TCP/UDP load balancing

The previous sections described load balancers that balance traffic that originates from the internet. Internal TCP/UDP (Layer 4) load balancers distribute traffic originating from internal clients or internal Compute Engine instances in internal networks. It protects an internal architecture from exposure as it hides behind a load balancer’s internal IP address. It preserves the client IP (as a passthrough load balancer) and can balance on any TCP or UDP port.

You can access this load balancer from the same VPC network where it is running or from another VPC network via VPC peering or VPN. Also, it can be accessed from an on-premises location via VPN or Interconnect.

Although we call it a load balancer, there is no single box processing traffic. Instead, it is a service that’s distributed at the lower layers of Google’s software-defined networking. This provides scalability, high throughput, and low latency for balanced workloads. The following figure presents one of the use cases of an internal TCP/UDP load balancer:

![Figure 9.40 – Internal TCP/UDP load balancers used behind a global external HTTP(S) load balancer](../images/B18851_09_40.jpg)

Figure 9.40 – Internal TCP/UDP load balancers used behind a global external HTTP(S) load balancer

In this tiered architecture, external users connect to an application available globally via a public IP address, served by a global external HTTP(S) load balancer. Behind it, we have a web server tier that’s served from two regions. Users are directed to the closest available region. In every region, another load balancer – an internal TCP/UDP load balancer – distributes internal regional traffic from a web server tier to a database tier. The database tier is not accessible externally and consists of multiple instances deployed across zones in a region. In case of a failure in a zone, traffic is redirected to instances in another zone in the same region.

## Selecting a load balancer

Selecting a particular load balancer depends mostly on your application architecture. Here are some examples:

- A global external HTTP (s) load balancer will be the best fit when a web-based application should be available from the internet and is expected to provide a good user experience (minimizing latency) and high availability by redirecting traffic to the closest operational regional backend
- A global external TCP/SSL load balancer should be used to allow access to an application from the internet on ports other than HTTP(S)
- An external network TCP/UDP load balancer will be a good choice for your internet-facing application if you need a client IP to be preserved or your service needs to load balance UDP traffic
- Use an internal TCP/UDP load balancer to distribute workloads in the same VPC and keep your backplane architecture hidden

Note

Check out the following link to the Google Cloud documentation on choosing the best load balancer for your workloads: <https://cloud.google.com/load-balancing/docs/choosing-load-balancer>.

# Summary

In this chapter, we learned how to create global VPC networks for workloads that span multiple Google Cloud projects. We also explored how to connect Google Cloud with on-premises data centers. One of the most important topics we covered was how to protect workloads using firewall rules and Cloud Armor. Additionally, we delved into Google Cloud networking services such as Cloud DNS and different types of load balancers. We also learned how to use load balancers to improve the security and availability of globally available applications.

As we wrap up our discussion on networking, let’s look ahead to the next chapter, where we’ll continue to expand our knowledge by looking into the essential topic of data processing services.

# Questions

Answer the following questions to check your knowledge of this chapter:

1. You are working on integrating Compute Engine workloads in a VPC with your on-premises data center. You have already configured and verified the VPN connectivity between the two environments. Also, Cloud DNS outbound forwarding was set for queries from the VPC to **my-on-prem-domain.com** to be sent to a DNS on-premises. However, while checking if the forwarding is working, you noticed that Compute Engine VMs in this VPC cannot resolve the **vm-1.my-on-prem-domain.com** address of **vm-1** on-premises. What could be the reason?
   1. The on-premises router is not advertising a **vm-1** subnet via BGP.
   2. Cloud DNS can only be configured to forward to zones in Google Cloud.
   3. Cloud Router needs to advertise the Cloud DNS IP range of **35.199.192.0/19** via BGP, which DNS on-premises uses to send a reply to Google Cloud.
   4. Firewall rules in the VPC block DNS queries on **port 53**.
2. You are meeting with a backup administrator to discuss how to set up backups of your Compute Engine VMs. The company has a separate project where a backup system is running (**backup project**). While preparing for the meeting, you investigate possible options for connecting those two existing projects. You are looking for a solution that doesn’t require much administrative work. Also, your budget is limited. What would be the best approach?
   1. You should consider peering between a VPC in your project and a VPC in the backup project. This is an efficient way to connect two VPCs in different projects and exchange routing information.
   2. A Shared VPC is the best approach as it doesn’t require any networking configuration on your end. Your project should be configured as a service project, with the backup project being a host project. This way, it can use the same networking that is used in the backup project.
   3. You should consider configuring a VPN between a VPC in your project and the backup project. This is an efficient way to connect two VPCs in different projects and exchange routing information.
3. Your team is investigating connectivity issues between Compute Engine VMs in VPC A in Project A and VPC B in Project B. VPC A and VPC B are peered, and the peering’s state is Active. What could be the reason for the problem?
   1. Subnet routes are not exported by default. Therefore, you must enable the subnet routes to be imported/exported at both ends of the peering.
   2. Firewall rules block communication between Compute Engine VMs.
   3. Peering needs to be configured for both VPCs. Most likely, peering was set at the VPC A side but has yet to be configured at the VPC B side.
4. As the first step of its multi-cloud strategy, your company has decided to move some of its workloads to Google Cloud. They also plan to move selected workloads to another cloud provider in the future. Your manager is asking you to investigate a cost-effective, forward-looking approach to connecting the on-premises site to the cloud, assuming the minimum required bandwidth at this moment is 2 Gbps. What would you recommend?
   1. Partner Interconnect, because a single physical connection to a partner site can be used to reach multiple cloud providers.
   2. VPN, as it can be configured on demand without the need for third parties.
   3. Dedicated Interconnect, because the more workloads they migrate, the higher the demand for bandwidth will be. With this option, they can scale up to 200 Gbps.
5. You plan to deploy workloads in two regions: **europe-central2** (**Warsaw**) and **europe-west3** (**Frankfurt**). What would be the simplest way to provide connectivity between subnets in those two regions?
   1. Use one VPC with two subnets, one in **europe-central2** and the second in **europe-west3**. Then, use firewall rules to enable communication on selected ports.
   2. Use VPC peering between a VPC with a subnet in **europe-west3** and a VPC with a subnet in **europe-central2**. Then, use firewall rules to enable communication on selected ports.
   3. Use VPN between a VPC with a subnet in **europe-west3** and a VPC with a subnet in **europe-central2**. Then, use firewall rules to enable communication on selected ports.
6. Would two Compute Engine VMs deployed in the same subnet be able to communicate with each other when only deny-all-ingress and allow-all-egress implied rules are configured?
   1. Yes, because both are in the same subnet, and firewall rules are executed at the VPC level.
   2. No, as firewall rules are executed at the VM level.
7. Which load balancer should offer the best user experience for a web application that requires high availability and will be accessed by users around the globe?
   1. One external network TCP/UDP load balancer as it is accessible globally and distributes traffic to a backend in the same region, which guarantees the lowest latency.
   2. Multiple external network TCP/UDP load balancers in multiple regions that are accessible globally and that distribute traffic to the backend in the same region, guaranteeing the lowest latency.
   3. One global external HTTP(S) load balancer as it is accessible globally and can distribute traffic to the available backends in regions close to users.

# Answers

Here are the answers to this chapter’s questions:

1C, 2A, 3B, 4A, 5A, 6B, 7C