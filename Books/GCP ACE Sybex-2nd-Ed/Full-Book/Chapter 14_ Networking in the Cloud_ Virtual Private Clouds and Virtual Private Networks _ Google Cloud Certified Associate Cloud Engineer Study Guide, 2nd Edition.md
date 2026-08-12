---

**THIS CHAPTER COVERS THE FOLLOWING OBJECTIVES OF THE GOOGLE ASSOCIATE CLOUD ENGINEER CERTIFICATION EXAM:**

- **2.4 Planning and configuring network resources**
- **4.5 Managing networking resources**

---

In this chapter we turn our attention to networking, starting with virtual private clouds (VPCs). You will learn how to create VPCs with default and custom subnets. You’ll learn about creating custom network configurations in Compute Engine for cases when default network configurations do not meet your needs. Finally, we will show you how to configure firewall rules and create virtual private networks (VPNs).

## Creating a Virtual Private Cloud with Subnets

VPCs are software versions of physical networks that link resources in a project. Google Cloud automatically creates a VPC when you create a project. You can create additional VPCs and modify the VPCs created by Google Cloud.

VPCs are global resources, so they are not tied to a specific region or zone. Resources, such as Compute Engine virtual machines (VMs) and Kubernetes Engine clusters, can communicate with each other, assuming traffic is not blocked by a firewall rule.

VPCs contain subnetworks, called *subnets*, which are regional resources. Subnets have a range of IP addresses associated with them. Subnets provide private internal addresses. Resources use these addresses to communicate with each other and with Google APIs and services.

In addition to VPCs associated with projects, you can create a shared VPC within an organization. The shared VPC is hosted in a common project. Users in other projects who have sufficient permissions can create and use resources in the shared VPC. You can also use VPC network peering for interproject connectivity, even if an organization is not defined.

In this section, you will create a VPC with subnets using Cloud Console and `gcloud`, and then turn your attention to creating a shared VPC.

### Creating a Virtual Private Cloud with Cloud Console

To create a VPC in Cloud Console, navigate to the VPC Networks page, as shown in [Figure 14.1](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0001).

Clicking Create VPC Network opens the page shown in [Figure 14.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0002). [Figure 14.2](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0002) shows that you can assign a name and description to a new VPC. It also shows a list of subnets that will be created in the VPC. When an automatic mode VPC is created, subnets are created in each region. Google Cloud chooses a range of IP addresses for each subnet when creating an auto mode network.

![Snapshot of the VPC Network page of Cloud Console](../images/c14f001.png)


[**FIGURE 14.1**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0001) The VPC Network page of Cloud Console

![Snapshot of creating a VPC in Cloud Console, part 1](../images/c14f002.png)


[**FIGURE 14.2**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0002) Creating a VPC in Cloud Console, part 1

Alternatively, you can create one or more custom subnets by selecting the Custom tab in the Subnet section ([Figure 14.3](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0003)). This displays another page that allows you to specify a region and an IP address range. The IP range is specified in classless interdomain routing (CIDR) notation. (See the upcoming sidebar “Understanding CIDR Notation” for details on how to specify IP addresses using that notation.) You can turn on Private Google Access. That allows VMs on the subnet to access Google services without assigning an external IP address to the VM. You can also turn on logging of network traffic by setting the Flow Logs option to On.

![Snapshot of creating a custom subnet](../images/c14f003.png)


[**FIGURE 14.3**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0003) Creating a custom subnet

[Figure 14.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0004) shows the second part of the VPC page, which includes firewall rules, dynamic routing setting, and a DNS server policy. The Firewall Rules section lists rules that can be applied to the VPC. In the example in [Figure 14.4](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0004), one of the rules allows ingress, which is incoming TCP traffic on port 22, to allow for SSH access. The IP range of 0.0.0.0/0 allows traffic from all source IP addresses.

![Snapshot of creating a VPC in Cloud Console, part 2](../images/c14f004.png)


[**FIGURE 14.4**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0004) Creating a VPC in Cloud Console, part 2

The dynamic routing option determines what routes are learned. Regional routing will have Google Cloud Routers learn routes within the region. Global routing will enable Google Cloud Routers to learn routes on all subnetworks in the VPC.

The optional DNS server policy lets you choose a DNS policy that enables DNS name resolution provided by Google Cloud or makes changes to name resolution order. (See [Chapter 15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c15.xhtml), “Networking in the Cloud: DNS, Load Balancing, Google Private Access, and IP Addressing,” for more details.)

Once you have specified the parameters and created a VPC, it will appear in the VPC listing and show information about the VPC and its subnets, as shown in [Figure 14.5](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0005).

![Snapshot of listing of VPCs and subnets](../images/c14f005.png)


[**FIGURE 14.5**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0005) Listing of VPCs and subnets

### Creating a Virtual Private Cloud with *gcloud*

The `gcloud` command to create a VPC is `gcloud compute networks create`. For example, to create a VPC in the default project with automatically generated subnets, you would use the following command:

```
gcloud compute networks create ace-exam-vpc1 --subnet-mode=auto
```

You can also configure custom subnets by creating a VPC network specifying the custom option and then creating subnets in that VPC. The first command to create a custom VPC called ace-exam-vpc1 is as follows:

```
gcloud compute networks create ace-exam-vpc1 --subnet-mode=custom
```

Next, you can create a subnet using the `gcloud compute networks subnet create` command. This command requires that you specify a VPC, the region, and the IP range. You can optionally turn on the Private Google Access and Flow Logs settings by adding the appropriate flags.

Here is an example command to create a subnet called `ace-exam-vpc-subnet1` in the ace-exam-vpc1 VPC. This subnet is created in the us-west2 region with an IP range of 10.10.0.0/16. The Private IP Access and Flow Logs settings are turned on.

```
gcloud compute networks subnets create ace-exam-vpc-subnet1 --
network=ace-exam-vpc1 --region=us-west2 --range=10.10.0.0/16 --
enable-private-ip-google-access --enable-flow-logs
```


---

### Understanding CIDR Notation

When you specify ranges of IP addresses, you use something called *classless interdomain routing* (CIDR). The name stems from early IP networks that were defined into three primary fixed classes: A, B, and C. A classless network address structure was created to overcome the limitations of a class-based routing structure, particularly the lack of flexibility in creating different-sized subnets.

CIDR uses variable-length subnet masking (VLSM) to allow network administrators to define networks with the number of addresses that they need, not the fixed numbers that were allocated to the older class model interdomain routine.

CIDR addresses consist of two sets of numbers: a network address for identifying a subnet and a host identifier. These numbers are written out using CIDR notation, which consists of a network address and a network mask. Example network addresses, according to the RFC1918 specification are:

- 10.0.0.0 - 10.255.255.255 (/8)
- 172.16.0.0 - 172.31.255.355 (/12)
- 192.168.0.0 - 192.168.255.255 (/16)

CIDR notation adds a slash (/) and a number indicating how many bits of an IP address to allocate to the network mask, which determines which addresses are within the block of the address and which are not.

For example, 192.168.0.0/16 means that 16 bits of the 32 bits of an IP address are used to specify the network, and 16 bits are used to specify the host address. With 16 bits, you can create 216–2, or 65,534 host addresses.

The CIDR block 172.16.0.0/12 indicates that 12 bits are used for specifying the network, and 20 bits are used to specify host addresses. With 20 bits, you can create up to 1,048,574 host addresses. In general, the smaller the number after the slash, the more host addresses are available. You can experiment with CIDR block options using a CIDR calculator such as the one at `www.subnet-calculator.com/cidr.php`.

---

### Creating a Shared Virtual Private Cloud Using *gcloud*

If you want to create a shared VPC, you can use the `gcloud` command `gcloud compute shared-vpc`.

Before executing commands to create a shared VPC, you will need to assign an org member the Shared VPC Admin role at the organization level or the folder level. To assign the Shared VPC Admin role, which uses the descriptor `roles/compute.xpnAdmin`, issue this command:

```
gcloud organizations add-iam-policy-binding [ORG_ID]
--member='user:[EMAIL_ADDRESS]'
--role="roles/compute.xpnAdmin"
```

*`[ORG_ID]`* is the organization identifier of the organization using the policy. You can find an organization ID with the command `gcloud organizations list`. If you prefer to assign the Shared VPC Admin role to a folder, you can use this command:

```
gcloud resource-manager folders add-iam-policy-binding [FOLDER_ID]
--member='user:[EMAIL_ADDRESS]'
--role="roles/compute.xpnAdmin"
```

*`[FOLDER_ID]`* is the identifier of the folder of the policy. You can get folder IDs by using this command:

```
gcloud resource-manager folders list --organization=[ORG_ID]
```

For more on roles and privileges, see [Chapter 17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c17.xhtml), “Configuring Access and Security.”

Once you have set the Shared VPC Admin role at the organization level, you can issue the `shared-vpc` command:

```
gcloud compute shared-vpc enable [HOST_PROJECT_ID]
```

If you are sharing the VPC at the folder level, use this command:

```
gcloud compute shared-vpc enable [HOST_PROJECT_ID]
```

Now that the shared VPC is created, you can associate projects using the `gcloud compute shared-vpc associate-projects` command. At the organization level, you can use this command:

```
gcloud compute shared-vpc associated-projects add [SERVICE_PROJECT_ID] \
    --host-project [HOST_PROJECT_ID]
```

At the folder level, the command to associate folders is as follows:

```
gcloud compute shared-vpc associated-projects add [SERVICE_PROJECT_ID] \
    --host-project [HOST_PROJECT_ID]
```

Alternatively, VPC network peering can be used for interproject traffic when an organization does not exist. VPC network peering is implemented using the `gcloud compute networks peerings create` command. For example, you peer two VPCs by specifying peerings on each network. Here’s an example:

```
gcloud compute networks peerings create peer-ace-exam-1 \
    --network ace-exam-network-A \
    --peer-project ace-exam-project-B \
    --peer-network ace-exam-network-B \
    --auto-create-routes
```

And then create a peering on the other network using:

```
gcloud compute networks peerings create peer-ace-exam-1 \
     --network ace-exam-network-B \
     --peer-project ace-exam-project-A \
     --peer-network ace-exam-network-A \
     --auto-create-routes
```

This peering will allow private traffic to flow between the two VPCs.

## Deploying Compute Engine with a Custom Network

You can deploy a VM with custom network configurations using the console and the command line.

Navigate to the Compute Engine section of the console and open the Create Instance page, shown in [Figure 14.6](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0006).

![Snapshot of preliminary options to create an instance in Cloud Console](../images/c14f006.png)


[**FIGURE 14.6**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0006) Preliminary options to create an instance in Cloud Console

In the horizontal menu toward the bottom of the page, click Management ➢ Security➢ Disks ➢ Networking ➢ Sole Tenancy to expand the optional forms and then click the Networking tab to display a page similar to [Figure 14.7](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0007).

Note that on this page, you can set network tags, which are used for defining firewall rules and routes. Click Add Network Interface to display a page like that shown in [Figure 14.8](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0008). Here you can choose a custom network. In this example, we are choosing ace-exam-vpc1, which we created earlier in the chapter. We also selected a subnet.

![Snapshot of networking configuration options](../images/c14f007.png)


[**FIGURE 14.7**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0007) Networking configuration options

Here, you can also specify a static IP address or choose a custom ephemeral address using the Primary Internal IP setting. The External IP drop-down menu allows you to have an ephemeral external IP or use a static external IP.

You can also create an instance to run in a particular subnet using the `gcloud compute instances create` command with `subnet` and `zone` parameters.

```
gcloud compute instances create [INSTANCE_NAME] --subnet [SUBNET_NAME] --zone [ZONE_NAME]
```

![Snapshot of options to add a custom network interface](../images/c14f008.png)


[**FIGURE 14.8**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0008) Options to add a custom network interface

## Creating Firewall Rules for a Virtual Private Cloud

Firewall rules are defined at the network level and used to control the flow of network traffic to VMs.

Firewall rules allow or deny a specified type of traffic on a port; for example, a rule may allow TCP traffic to port 22. They also are applied to traffic in one direction, either incoming (ingress) or outgoing (egress) traffic. It is important to note that the firewall is *stateful*, which means if traffic is allowed in one direction and a connection established, it is allowed in the other direction. Firewalls rulesets are stateful, so if a connection is allowed, like establishing an SSH connection on port 22, then all later traffic matching this rule is permitted as long as the connection is active. An active connection is one with at least one packet exchanged every 10 minutes.

### Structure of Firewall Rules

Firewall rules consist of several components:

- **Direction**   Either ingress or egress.
- **Priority**   Highest-priority rules are applied; any rule with a lower priority that matches are not applied. Priority is specified by an integer from 0 to 65535. 0 is the highest priority, and 65535 is the lowest.
- **Action**   Either allow or deny. Only one can be chosen.
- **Target**   An instance to which the rule applies. Targets can be all instances in a network, instances with particular network tags, or instances using a specific service account.
- **Source/Destination**   Source applies to ingress rules and specifies source IP ranges, instances with particular network tags, or instances using a particular service account. You can also use combinations of source IP ranges and network tags and combinations of source IP ranges and service accounts used by instances. The IP address 0.0.0.0/0 indicates any IP address. The Destination parameter uses only IP ranges.
- **Protocol and Port**   A network protocol such as TCP, UDP, or ICMP and a port number. If no protocol is specified, then the rule applies to all protocols.
- **Enforcement Status**   Firewall rules are either enabled or disabled. Disabled rules are not applied even if they match. Disabling is sometimes used to troubleshoot problems with traffic getting through when it should not or not getting through when it should.

All VPCs start with two implied rules: one allows egress traffic to all destinations (IP address 0.0.0.0/0), and one denies all incoming traffic from any source (IP address 0.0.0.0/0). Both implied rules have priority 65535, so you can create other rules with higher deny or allow traffic as you need. You cannot delete an implied rule.

When a VPC is automatically created, the default network is created with four network rules. These rules allow the following:

- Incoming traffic from any VM instance on the same network
- Incoming TCP traffic on port 22, allowing SSH
- Incoming TCP traffic on port 3389, allowing Microsoft Remote Desktop Protocol (RDP)
- Incoming Internet Control Message Protocol (ICMP) from any source on the network

The default rules all have priority 65534.

### Creating Firewall Rules Using Cloud Console

To create or edit firewall rules, navigate to the VPC section of the console and select the Firewall option from the VPC menu. [Figure 14.9](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0009) shows a list of firewall rules.

![Snapshot of list of firewall rules in the VPC section of Cloud Console](../images/c14f009.png)


[**FIGURE 14.9**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0009) List of firewall rules in the VPC section of Cloud Console

Click Create Firewall Rule at the top of the page to create a new firewall rule. This opens the page shown in [Figure 14.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0010).

Here, you specify a name and description of the firewall rule. You can choose to turn logging on or off. If it is on, logging information will be captured in Cloud Logging. (See [Chapter 18](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c18.xhtml), “Monitoring, Logging, and Cost Estimating,” for more on Cloud Logging.) You also need to specify the network in the VPC to apply the rule to.

Next, you will need to specify a priority, direction, action, targets, and sources. Priority can be integers in the range from 0 to 65535. Direction can be Ingress or Egress. Action can be Allow or Deny. Choose targets are the drop-down list; the options are shown in [Figure 14.11](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0011).

If you choose tags or service accounts, you will be able to specify the tags or the name of the service account. You can also specify source filters as either IP ranges, subnets, source tags, or service accounts. Google Cloud allows a second source filter if you’d like to use a combination of conditions. A list of source filters is shown in [Figure 14.12](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0012).

Finally, you specify protocol and ports by choosing between the Allow All and Specified Protocols and Ports options. If you choose the latter, you can specify protocols and ports.

[Figure 14.13](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0013) shows the listing of the firewall rule created using the parameters specified in [Figure 14.10](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0010).

![Snapshot of creating a firewall rule](../images/c14f010.png)


[**FIGURE 14.10**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0010) Creating a firewall rule

![Snapshot of list of target types](../images/c14f011.png)


[**FIGURE 14.11**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0011) List of target types

![Snapshot of list of source filter types](../images/c14f012.png)


[**FIGURE 14.12**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0012) List of source filter types

![Snapshot of listing of the firewall rule created using the earlier configuration](../images/c14f013.png)


[**FIGURE 14.13**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0013) Listing of the firewall rule created using the earlier configuration

### Creating Firewall Rules Using *gcloud*

The command for working with firewall rules from the command line is `gcloud compute firewall-rules`. With this command, you can create, delete, describe, update, and list firewall rules.

A number of parameters are used with `gcloud compute firewall-rules create`:

- `--action`
- `--allow`
- `--description`
- `--destination-ranges`
- `--direction`
- `--network`
- `--priority`
- `--source-ranges`
- `--source-service-accounts`
- `--source-tags`
- `--target-service-accounts`
- `--target-tags`

For example, to allow all TCP traffic on ports 20000 to 25000, use this:

```
gcloud compute firewall-rules create ace-exam-fwr2 \--network ace-exam-vpc1 --allow tcp:20000-25000
```

## Creating a Virtual Private Network

VPNs allow you to securely send network traffic from the Google network to your own network. You can create a VPN using Cloud Console or the command line.

### Creating a Virtual Private Network Using Cloud Console

To create a VPN using Cloud Console, navigate to the Hybrid Connectivity section of the console, as shown in [Figure 14.14](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0014).

Click Create VPN Connection to display the page shown in [Figure 14.15](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0015).

You have the option of creating either a High-availability (HA) VPN or a Classic VPN. HA VPNs support dynamic routing using the Border Gateway Protocol (BGP) as well as a high availability 99.99 SLA within a region. High availability is provided by using two tunnels instead of just one. You can use either IPv4 or IPv6 addresses in an HA VPN.

![Snapshot of hybrid Connectivity section of Cloud Console](../images/c14f014.png)


[**FIGURE 14.14**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0014) Hybrid Connectivity section of Cloud Console

![Snapshot of creating a VPN connection, part 1](../images/c14f015.png)


[**FIGURE 14.15**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0015) Creating a VPN connection, part 1

In the past, Google Cloud has offered a Classic VPN that supported both dynamic and static routing but only IPv4 addresses, and it did not provide for high availability. Classic VPN has been partially deprecated. You can continue to use Classic VPN tunnels that use dynamic routing when connecting to a Compute Engine VM running a VPN gateway. You cannot use Classic VPN tunnels for connections outside of Google Cloud. (See `https://cloud.google.com/network-connectivity/docs/vpn/deprecations/classic-vpn-deprecation` `for additional details`.)

[Figure 14.16](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0016) shows the first part of the page for creating an HA VPN. You specify a VPN gateway name, a network, and a region.

![Snapshot of creating a high availability VPN](../images/c14f016.png)


[**FIGURE 14.16**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0016) Creating a high availability VPN

Next, you will add VPN tunnels (see [Figure 14.17](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#c14-fig-0017)). Tunnels connect the VPN gateway to a peer gateway that exists on premises, in another cloud, or in Google Cloud.

![Snapshot of configuring tunnels in an HA VPN](../images/c14f017.png)


[**FIGURE 14.17**](https://learning.oreilly.com/library/view/google-cloud-certified/9781119871446/c14.xhtml#R_c14-fig-0017) Configuring tunnels in an HA VPN

In the Tunnels section, you configure the other network endpoint in the VPN. You specify a name, description, and IP address of the VPN gateway on your network. You will have the option to choose an existing peer VPN gateway or to create one. If you choose to create a peer VPN gateway, you will need to provide a name for it; specify 1, 2 or 4 interfaces; and provide the external IP address.

---

### Real World Scenario

### Analytics in the Cloud

Data science and data analysis are increasingly important to businesses. To derive insights from these practices, you need both the data and the tools. Data about customers, sales, and other kinds of transactions are often stored in a database in a company’s data center. The tools analysts want to use, such as Spark and machine learning services, are readily available in the cloud. Many organizations have security practices to protect data and would not allow an analyst, for example, to download some data and then copy it over an unsecure Internet connection to the cloud. Instead, network and cloud engineers would create a VPN between the company’s data center and Google Cloud. This would ensure that network traffic between the data center and the cloud is encrypted. Analysts get access to the data and tools they need, and the information security professionals in the organization are able to protect the confidentiality and integrity of the data.

---

### Creating a Virtual Private Network Using *gcloud*

To create a VPN at the command line, you can use these three commands:

- `gcloud compute target-vpn-gateways`
- `gcloud compute forwarding-rule`
- `gcloud compute vpn-tunnels`

The format of the `gcloud compute target-vpn-gateways` command for creating a Classic VPN is as follows:

```
gcloud compute vpn-tunnels create NAME --peer-address=PEER_ADDRESS \--shared-secret=SHARED_SECRET --target-vpn-gateway=TARGET_VPN_GATEWAY
```

*`NAME`* is the name of the tunnel. *`PEER_ADDRESS`* is the IPv4 address of the remote tunnel endpoint. *`SHARED_SECRET`* is a secret string. *`TARGET_VPN_GATEWAY`* is a reference to the target VPN gateway IP.

When creating an HA VPN, you will need to specify either the `--peer-gcp-gateway` or the `--peer-external-gateway` parameter as well.

The format of `gcloud compute forwarding-rule` is as follows:

```
gcloud compute forwarding-rules create NAME --TARGET_SPECIFICATION=VPN_GATEWAY
```

*`NAME`* is the name of the forwarding rule. *`TARGET_SPECIFICATION`* is one of several target types, including `target-instance`, `target-http-proxy`, and `--target-vpn-gateway`. For additional details, see the documentation at `https://cloud.google.com/sdk/gcloud/reference/compute/forwarding-rules/create`.

The format of the `gcloud compute vpn-tunnels` command is as follows:

```
gcloud compute vpn-tunnels create NAME --peer-address=PEER_ADDRESS \--shared-secret=SHARED_SECRET --target-vpn-gateway=TARGET_VPN_GATEWAY
```

*`NAME`* is the name of the VPN tunnel, *`PEER_ADDRESS`* is the IPv4 address of the remote tunnel, *`SHARED_SECRET`* is a secret string, and *`TARGET_VPN_GATEWAY`* is a reference to a VPN gateway.

## Summary

This chapter reviewed how to create VPCs and VPNs. VPCs define networks in the Google Cloud to link your Google Cloud resources. VPNs in Google Cloud are used to link your Google Cloud networks to your internal networks. We discussed how to create VPCs, shared VPCs, and subnets, and we described CIDR notation. You also learned how to configure VMs with custom network connections. Next, we reviewed firewall rules and how to create them. The chapter concluded with discussing the steps required to create a VPN.

## Exam Essentials

- **Know that VPCs are logical data centers in the cloud and that VPNs are secure connections between your VPC subnets and your internal network.**   Your cloud resources are in a VPC. VPCs have subnets and routing rules for routing traffic between subnets. You control the flow of traffic using firewall rules.
- **Know that VPCs create subnets in each region when in auto mode.**   You can create additional subnets. Each subnet has a range of IP addresses. Firewall rules are applied to subnets, also called networks. Routers can be configured to learn just regional routes or global routes.
- **Understand how to read and calculate CIDR notation.**   CIDR notation represents a subnet mask and the size of available IP address in the IP range. The smaller the subnet mask size, which is the number after the slash in a CIDR block, the more IP addresses are available. The format of the CIDR address is an IP address followed by a slash, followed by the size of the subnet mask, such as 10.0.0.0/8.
- **Know that VPCs can be created using `gcloud` commands.**   A VPC can be created with `gcloud compute networks create`. A shared VPC can be created using `gcloud beta compute shared-vpc`. Shared VPCs can be shared at the network or the folder level. You will need to bind identity and access management (IAM) policies at the organizational or folder level to enable Shared VPC Admin roles. VPC peering can be used for interproject connectivity.
- **Understand that you can add network interfaces to a VM.**   You can configure these interfaces to use a particular subnet. You can assign ephemeral or static IP addresses.
- **Know that firewall rules control the flow of network traffic.**   Firewall rules consist of direction, priority, action, target, source/destination, protocols and port, and enforcement status. Firewall rules are applied to a subnet.
- **Know how to create a VPN with Cloud Console.**   VPNs route traffic between your cloud resources and your internal network. VPNs include gateways, forwarding rules, and tunnels. Both Classic and High Availability (HA) VPNs are available.

## Review Questions

You can find the answers in the Appendix.

1. What kinds of a resource are virtual private clouds in Google Cloud?
   1. Zonal
   2. Regional
   3. Super-regional
   4. Global
2. You have been tasked with defining CIDR ranges to use with a project. The project includes two VPCs with several subnets in each VPC. How many CIDR ranges will you need to define?
   1. One for each VPC
   2. One for each subnet
   3. One for each region
   4. One for each zone
3. The legal department needs to isolate its resources on its own VPC. You want to have the network provide routing to any other service available on the global network. The VPC network has not learned global routes. What parameter may have been missed when creating the VPC subnets?
   1. DNS server policy
   2. Dynamic routing
   3. Static routing policy
   4. Systemic routing policy
4. The command used to create a VPC from the command line is:
   1. `gcloud compute networks create`
   2. `gcloud networks vpc create`
   3. `gsutil networks vpc create`
   4. `gcloud compute create networks`
5. You have created several subnets. Most of them are sending logs to Cloud Logging. One subnet is not sending logs. What option may have been misconfigured when creating the subnet that is not forwarding logs?
   1. Flow Logs
   2. Private IP Access
   3. Cloud Logging
   4. Variable-length subnet masking
6. At what levels of the resource hierarchy can a shared VPC be created?
   1. Folders and resources
   2. Organizations and project
   3. Organizations and folders
   4. Folders and subnets
7. You are using Cloud Console to create a VM that you want to exist in a custom subnet you just created. What section of the Create Instance page would you use to specify the custom subnet?
   1. Networking tab of the Management, Security, Disks, Networking, Sole Tenancy section
   2. Management tab of the Management, Security, Disks, Networking, Sole Tenancy section
   3. Sole Tenancy tab of Management, Security, Disks, Networking, Sole Tenancy
   4. Sole Tenancy tab of Management, Security, Disks, Networking
8. You want to implement interproject communication between VPCs. Which feature of VPCs would you use to implement this?
   1. VPC network peering
   2. Interproject peering
   3. VPN
   4. Interconnect
9. You want to limit traffic to a set of instances. You decide to set a specific network tag on each instance. What part of a firewall rule can reference the network tag to determine the set of instances affected by the rule?
   1. Action
   2. Target
   3. Priority
   4. Direction
10. What part of a firewall rule determines whether a rule applies to incoming or outgoing traffic?
    1. Action
    2. Target
    3. Priority
    4. Direction
11. You want to define a CIDR range that applies to all destination addresses. What IP address would you specify?
    1. 0.0.0.0/0
    2. 10.0.0.0/8
    3. 172.16.0.0/12
    4. 192.168.0.0/16
12. You are using `gcloud` to create a firewall rule. Which command would you use?
    1. `gcloud network firewall-rules create`
    2. `gcloud compute firewall-rules create`
    3. `gcloud network rules create`
    4. `gcloud compute rules create`
13. You are using `gcloud` to create a firewall rule. Which parameter would you use to specify the subnet it should apply to?
    1. `––subnet`
    2. `––network`
    3. `––destination`
    4. `––source-ranges`
14. An application development team is deploying a set of specialized service endpoints and wants to limit traffic so that only traffic going to one of the endpoints is allowed through by firewall rules. The service endpoints will accept any UDP traffic, and each endpoint will use a port in the range of 20000–30000. Which of the following commands would you use?
    1. `gcloud compute firewall-rules create fwr1 \--allow=udp:20000-30000 --direction=ingress`
    2. `gcloud network firewall-rules create fwr1 \--allow=udp:20000-30000 --direction=ingress`
    3. `gcloud compute firewall-rules create fwr1 --allow=udp`
    4. `gcloud compute firewall-rules create fwr1 --direction=ingress`
15. You have a rule to allow inbound traffic to a VM. You want it to apply only if there is not another rule that would deny that traffic. What priority should you give this rule?
    1. 0
    2. 1
    3. 1000
    4. 65535
16. You want to create a VPN using Cloud Console. What section of Cloud Console should you use?
    1. Compute Engine
    2. App Engine
    3. Hybrid Connectivity
    4. IAM & Admin
17. Your company needs to ensure they have at least a 99.99 percent availability SLA for networking between on-premises networks and a VPC in Google Cloud. What should you use to ensure you have this level of availability?
    1. Classic VPN
    2. HA VPN
    3. Shared VPC
    4. VPC network peering
18. You want the router on a tunnel you are creating to learn routes from all Google Cloud regions on the network. What feature of Google Cloud routing would you enable?
    1. Global dynamic routing
    2. Regional routing
    3. VPC
    4. Firewall rules
19. What `gcloud` command would you use to create tunnels for a VPN?
    1. `gcloud network vpn-tunnels create`
    2. `gcloud compute vpn-tunnels create`
    3. `gcloud newtwork create vpn-tunnels`
    4. `gcloud compute create vpn-tunnels`
20. You are using `gcloud` to create a VPN. Which command(s) would you use?
    1. `gcloud compute target-vpn-gateways only`
    2. `gcloud compute forwarding-rule and gcloud compute target-vpn-gateways only`
    3. `gcloud compute vpn-tunnels only`
    4. `gcloud compute forwarding-rule`, `gcloud compute target-vpn-gateways`, and `gcloud compute vpn-tunnels`