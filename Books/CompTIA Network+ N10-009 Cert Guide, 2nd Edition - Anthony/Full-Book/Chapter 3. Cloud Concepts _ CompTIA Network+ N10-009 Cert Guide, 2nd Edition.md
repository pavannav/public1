## Chapter 3

## Cloud Concepts

This chapter covers the following topics related to Objective 1.3 (Summarize cloud concepts and connectivity options) of the CompTIA Network+ N10-009 certification exam:

- [Network functions virtualization (NFV)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03lev1sec2)
- [Virtual private cloud (VPC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03lev2sec1)
- [Network security groups](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03lev2sec2)
- [Network security lists](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03lev2sec3)
- [Cloud gateways](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03lev2sec4)

  - Internet gateway
  - Network address translation (NAT) gateway
- [Cloud connectivity options](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03lev2sec5)

  - VPN
  - Direct Connect
- [Deployment models](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03lev1sec4)

  - Public
  - Private
  - Hybrid
- [Service models](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03lev1sec5)

  - Software as a service (SaaS)
  - Infrastructure as a service (IaaS)
  - Platform as a service (PaaS)
- [Scalability](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03lev2sec8)
- [Elasticity](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03lev2sec7)
- [Multitenancy](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03lev2sec6)

It is not just a fad. It is not just marketing hype. Cloud computing is the future, and it is exploding in usage and usefulness. In this chapter, you will learn about some of the most foundational and critical topics in the vast field of cloud computing today.

### Foundation Topics

### Network Functions Virtualization (NFV)

One of the technologies that has helped cloud computing become a very popular reality is virtualization. While virtualization of servers was the initial push, these days we are seeing virtualization move into all aspects of Information Technology (IT). [***Network functions virtualization (NFV)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_442) is a great example of this. NFV abstracts and virtualizes important network functions that would traditionally be implemented by physical network appliances. Examples of network functions that can be virtualized with NFV are numerous and include

- Routing
- Switching
- Firewalling
- Load balancing
- Content delivery networking (CDN)
- Network monitoring

Thanks to NFV, the complex functionalities of the preceding network functions are decoupled from proprietary hardware and implemented as software applications. While this fact alone presents many advantages, IT administrators love the fact that they can run these applications on standard commercial off-the-shelf (COTS) servers. This decoupling of the network functions from specific hardware enables network operators to dynamically deploy, manage, and orchestrate network services with greater agility and efficiency, while also facilitating the optimization of resource utilization and operational costs. Specifically, just some of the advantages of NFV include

- **Doing more with less:** NFV typically permits dramatic increases in workload capacity with less power consumption, a smaller data center footprint, and reduced cooling requirements.
- **Reduced vendor lock-in:** Because NFV fosters the use of COTS servers, organizations can avoid being locked into proprietary hardware solutions from a single vendor.
- **Increased flexibility:** NFV tends to increase the agility of network operations because NFV facilitates quick changes to the network infrastructure, especially when compared to the traditional, nonvirtualized environments.

### Cloud Networking Components

If an organization is interested in building IT solutions in the cloud, it is going to need key networking components and is also going to want to easily secure these resources. In this section, let’s examine how an organization can accomplish both of these requirements with the cloud services of a leader in cloud technology—Amazon Web Services (AWS).

Note

While this section focuses on AWS-specific examples, it is important to realize that other major cloud providers offer similar services. The specific names just vary.

#### Virtual Private Cloud (VPC)

The AWS [***virtual private cloud (VPC)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_745) lets you provision a logically isolated section of the AWS Cloud where you can launch AWS resources in a virtual network that you define. You have complete control over your virtual networking environment, including the selection of your IP address range, creation of subnets, and configuration of route tables and network gateways. You can use both IPv4 and IPv6 in VPCs for secure and easy access to resources and applications. [Figure 3-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03fig01) shows elements inside a VPC.

![](../images/03fig01.jpg)


**Figure 3-1** Some Components of an AWS VPC


Note

AWS is not the only public cloud vendor to offer virtual private cloud functionality. Other major public cloud providers like Google Cloud Platform (GCP) and Microsoft Azure allow VPC functionality. Be aware that in Microsoft Azure, the VPC-like service is named Virtual Networks.

#### Network Security Groups

Because the security of resources in the cloud is a prime concern for both cloud customers and cloud providers, it is no big surprise that AWS provides built-in firewalls for use with its virtual compute resources. These [***network security groups***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_447) help you easily control the accessibility of your virtual machines and their resources. [Figure 3-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03fig02) shows an example of a network security group (named sg-f76c8d80) assigned to a virtual network interface in AWS.

![](../images/03fig02.jpg)


**Figure 3-2** A Security Group Assigned to a vNIC


Note

AWS refers to network security groups as simply security groups and often abbreviates them as SGs.

Consider the case of a web tier available in the AWS VPC. The AWS customer can configure the security group for this tier to permit HTTP and HTTPS traffic from customers using the web tier, and at the same time they can permit their team of support engineers to access the web tier using SSH and RDP. All other protocol attempts at accessing the web tier are denied by the security group.

Note that AWS applies a security group by attaching the security group to the virtual network interface (vNIC) of a virtual machine. This allows the security group to easily control (firewall) the traffic entering and exiting the virtual machine instance.

#### Network Security Lists

To further enhance cloud security, AWS also implements a [***network security list***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_448) functionality (like other cloud vendors). AWS specifically terms its solution *network access control lists (NACLs)*. NACLs allow cloud customers to control access to their VPC subnets. NACLs are stateless constructs, which means customers must configure inbound and outbound rules, as there is no automatic recognition of state with traffic flows, and there are no automated access entries.

Students are often puzzled about why these “firewalls” exist when there are already security groups inside AWS. Remember that security groups are attached to virtual network interfaces of virtual machine instances and can control traffic to and from the virtual machines. NACLs are attached to subnets in a VPC to control traffic into and out of the entire subnet. Having multiple levels of built-in firewalls within the AWS network infrastructure permits fine-grained control of security.

[Figure 3-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03fig03) shows an example of a NACL inside AWS.

![](../images/03fig03.jpg)


**Figure 3-3** A NACL in AWS

#### Cloud Gateways

A [***cloud gateway***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_149) is network infrastructure component or service that provides secure and efficient connectivity between on-premises networks or devices and cloud-based resources, applications, or services. Cloud gateways act as intermediaries or bridges, facilitating communication, data exchange, and access control between the local network and cloud environments, such as public cloud platforms, software as a service (SaaS) applications, or hybrid cloud deployments.

There are several different types of specific cloud gateways commonly seen in cloud environments. These include the following:

- [***Internet gateway***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_331): An Internet gateway serves as a pivotal entry and exit point for network traffic between the cloud environment and the broader Internet. As a virtualized component within the AWS infrastructure, the internet gateway seamlessly connects resources hosted in virtual private clouds to external networks. This connectivity enables bidirectional communication while ensuring security and scalability. By facilitating the flow of data between AWS services and the Internet, the Internet gateway allows organizations to build, deploy, and manage cloud-based applications with flexibility and efficiency, while also providing robust access control mechanisms and integration options for establishing secure connections with on-premises infrastructure.
- [***Network address translation (NAT) gateway***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_438): While an Internet gateway in AWS seamlessly facilitates Internet connectivity, it does not provide fine-grained control over the network address translations required to translate private-use-only IP addresses with publicly routable IP addresses. Should a customer want to control these NAT translations, AWS (and its competitors) offers a NAT gateway. Acting as a managed service, the NAT gateway translates outgoing traffic from private IP addresses of instances within the VPC into public IP addresses, allowing them to communicate with external networks while concealing their internal addresses.

### Deployment Models

How do we implement (or deploy) cloud services most often today? In this section, we examine several different deployment models for cloud. Virtualized services and solutions are often offered by service providers as *cloud computing*. A company purchasing cloud computing services has several options to choose from:

![](../images/key_topic_icon_158.jpg)

- [***Private cloud***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_523): With this model, the cloud infrastructure is provisioned for exclusive use by a single organization comprising multiple consumers, which might be business units. It might be owned, managed, and operated by the organization, a third party, or some combination of both, and it might exist on or off premises. The key is that this cloud is not for use by multiple organizations.
- [***Public cloud***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_531): With this model, the cloud infrastructure is provisioned for open use by the general public. It might be owned, managed, and operated by a business, an academic institution, a government organization, or some combination of the three. It exists on the premises of the cloud provider, and these premises are typically located all over the globe to facilitate reduced latency from any location. This is the model presented by AWS and its main competitors, Microsoft Azure and Google Cloud Platform.
- [***Hybrid cloud***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_306): With this model, the cloud infrastructure is a composition of two or more distinct cloud infrastructures (private or public) that remain unique entities but are bound together by standardized or proprietary technology that enables data and application portability. This is a widespread deployment model today. For example, an organization might build a private cloud for operational financial transactions while relying on a public cloud model for encrypted archiving of legacy transactions that must be maintained for compliance reasons.

Note

While the main cloud deployment models are private, public, and hybrid, there is also the [***community cloud***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_157) model. Community cloud services are used by individuals, companies, or entities with similar interests. A community cloud is typically a partnership between many different cloud vendors or organizations. An excellent example of a community cloud is [cloud.gov](http://cloud.gov/) in the United States. This community cloud provides a wide variety of services to employees of the U.S. government. These services are offered in the community cloud by several different public cloud vendors.

When an organization requires scalability, wants reduced costs, lacks in-house administrative personnel trained in cloud technologies, and has a complex network, a public cloud is the best deployment model to use. The advantages of using a public cloud include the following:

- Lower infrastructure, maintenance, and administrative costs
- Greater hardware efficiency
- Reduced implementation times
- Availability of short-term usage

When an organization needs to maintain strict control of business-critical data or is in a highly regulated businesses, such as the financial industry, a private cloud is typically the best choice.

A hybrid cloud environment is the best choice when an organization offers services that need to be configured for diverse vertical markets or has varying needs. Hybrid clouds are also ideal for organizations migrating to public clouds because they can ensure interoperability and efficiencies across the different environments.

### Service Models

Cloud services are typically offered using one of several “as a service” models, which are usually offered on a pay-as-you-go basis. This is similar to the model used with utilities in the home (for example, electricity, Internet).

The following are a few of the service models that are available as part of cloud computing:

![](../images/key_topic_icon_158.jpg)

- [***Infrastructure as a service (IaaS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_321): With IaaS, the company rents virtualized servers (which are hosted by a service provider) and runs specific applications on those servers. IaaS is made simple thanks to public cloud providers like AWS, Microsoft Azure, and Google Cloud Platform.
- [***Software as a service (SaaS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_638): With SaaS, the details of the servers are hidden from the customer, and the customer’s experience is similar to the experience of using a web-based application. Examples of SaaS in use today include Gmail, Microsoft 365, and Google Docs.
- [***Platform as a service (PaaS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_496): PaaS provides a development platform for companies that are developing applications and want to focus on creating the software without having to worry about the servers and infrastructure that are being used for that development. AWS Elastic Beanstalk and Google App Engine are examples of public cloud PaaS offerings.

Note

Countless “as a service” designations have been established. For example, [***desktop as a service (DaaS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_202) refers to cloud-hosted OS desktops made available to cloud clients. The term *everything as a service (XaaS)* is often used to describe the vast array of cloud services available now that the use of cloud approaches has exploded in popularity.

### Key Cloud Concepts

We could easily fill a book this size with details of cloud technology, but for the CompTIA Network+ exam, you need to know the following key aspects:

![](../images/key_topic_icon_158.jpg)

- Cloud connectivity options
- Multitenancy
- Elasticity
- Scalability

#### Cloud Connectivity Options

As more and more technology has appeared in the cloud (both public and private), secured connectivity has become crucial. Secure protocols such as HTTPS, TLS, and SSH are necessary when accessing most cloud resources. Fortunately, massive cloud providers such as AWS make it simple to securely connect using a wide variety of methods, including hardware [***virtual private network (VPN)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_746) appliances located at your corporate or home office. Although your applications and servers might be sharing physical equipment with other customers of AWS, great pains are taken to ensure that this multitenancy (described in the next section) does not come at the cost of security.

AWS and other large public cloud providers go a step further, allowing customers to purchase AWS [***Direct Connect***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_213) circuits. These circuits are private, dedicated leased lines directly into the AWS infrastructure. When you use AWS Direct Connect, your traffic does not commingle with that of other AWS customers or other Internet users at all. Of course, these types of connections are more expensive than other options.

Note

The first thought most network engineers have when thinking about a service like AWS Direct Connect is the added security. Another huge benefit, however, is the predictable, low-latency performance such a private connection can offer.

#### Multitenancy

If you ask engineers why they are hesitant to move to the public cloud, they are likely to say that they are worried about security. When they react this way, it is almost always because they are thinking about [***multitenancy***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_426). This is a fancy term for the fact that the physical servers in the public cloud infrastructure are hosting workloads for many different customers. Your virtual machines (VMs) might be located on the same physical server as the VMs of your biggest competitor. Multitenancy requires you to have great faith that the cloud provider has done excellent setup of security work to ensure that the VMs of one customer are completely hidden from other customers.

Note

When you have the money to spend and need the certainty, you can purchase a fully dedicated hosting solution. In such a situation, the cloud provider leases to you your own dedicated hardware in its cloud—and this hardware is not shared with other customers.

#### Elasticity

![](../images/key_topic_icon_158.jpg)

[***Elasticity***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_244) is another extremely compelling reason to move to the cloud. Elasticity means that a cloud solution can scale (up or down or in or out) as needed based on demand. Scaling up or down means adding or subtracting resources to provide larger or smaller systems. Scaling in or out refers to allowing systems to clone themselves or terminate themselves, as needed.

Note

The National Institute of Standards and Technology (NIST) includes rapid elasticity as one of the five key characteristics that define what *cloud* truly means. The other four characteristics are on-demand self-service, broad network access, resource pooling, and measured service. If you are interested in reading this important document for yourself, check out NIST SP 800-145.

Elasticity is truly incredible. When your cloud offers you rapid elasticity (and it should!), your network infrastructure and services offered can grow and shrink along with demand. This is incredibly exciting for many reasons, but perhaps the two biggest reasons are the fact that you do not have to worry (as much) about your infrastructure failing under a large load, and you do not have to worry about overprovisioned resources when demand is low.

#### Scalability

It should be no surprise that if your cloud solution can grow and shrink as needed (elasticity), it has no problem demonstrating great scalability. [***Scalability***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_587) refers to a solution’s ability to grow with need or demand. Cloud technology today can do even better than this: It can grow or shrink as needed.

### Real-World Case Study

Acme, Inc. is considering a move to the cloud with some key services it is having problems scaling from its on-prem, local data center. Specifically, Acme, Inc. is considering a public cloud implementation for the streaming of new training videos globally. Acme, Inc. needs these movies to be delivered in a format that is based on the bandwidth of the access device.

To facilitate this new public cloud initiative, IT personnel from Acme, Inc. have created a virtual private cloud in AWS and constructed the necessary infrastructure to support the deployment and conversion of video content globally. Acme is thrilled to be taking advantage of a hybrid cloud deployment model. It is utilizing its on-premises resources right alongside its cloud resources to facilitate a much-improved global delivery network.

Acme, Inc. is also investigating the changes in the security posture of the organization with this move. Specifically, Acme is exploring its security responsibilities in this new solution compared to the security responsibilities of the cloud provider. Acme personnel are carefully constructing security groups and network access control lists to accommodate careful, secured access of cloud resources.

### Summary

Here are the main topics covered in this chapter:

- This chapter covered network functions virtualization and described this emerging trend in detail.
- This chapter described some of the key cloud networking components found today, including virtual private clouds, network security groups, network security lists, and cloud gateways.
- This chapter covered the deployment models often seen with cloud in networking today. These include private, public, hybrid, and community clouds.
- This chapter also covered the service models seen today with cloud, including SaaS, IaaS, and PaaS.
- Finally, this chapter covered key cloud concepts you should be aware of, including connectivity options, multitenancy, elasticity, and scalability.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 3-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03tab01) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 3-1** Key Topics for [Chapter 3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| List | Deployment models | 71 |
| List | “As a service” models | 72 |
| List | Key cloud concepts | 73 |
| Section | Elasticity | 74 |

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[cloud gateway](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_01)

[community cloud](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_02)

[desktop as a service (DaaS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_03)

[Direct Connect](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_04)

[elasticity](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_05)

[hybrid cloud](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_06)

[infrastructure as a service (IaaS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_07)

[Internet gateway](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_08)

[multitenancy](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_09)

[network address translation (NAT) gateway](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_010)

[network functions virtualization (NFV)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_011)

[network security group](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_012)

[network security list](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_013)

[platform as a service (PaaS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_014)

[private cloud](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_015)

[public cloud](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_016)

[scalability](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_017)

[software as a service (SaaS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_018)

[virtual private cloud (VPC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_019)

[virtual private network (VPN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#key_020)

### Additional Resources

**Google Cloud Platform: Deploying Cloud Marketplace Solutions to Google Kubernetes Engine (GKE):** <https://www.ajsnetworking.com/gcp-compute/>

**Cloud Versus Outsourcing:** <https://www.ajsnetworking.com/comptia-cloud-essentials-cloud-vs-outsourcing/>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz3_1) What cloud component is assigned to a virtual machine and acts as a firewall, controlling traffic into and out of the VM?

1. Virtual private cloud
2. Network security list
3. Network security group
4. Internet gateway

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz3_2) What type of cloud deployment model features many customers consuming resources from a single provider?

1. Public
2. Private
3. Community
4. Hybrid

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz3_3) What type of “as a service” model features a powerful cloud environment targeted at developers who need to test and deploy updates to their applications?

1. IaaS
2. SaaS
3. PaaS
4. DaaS

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz3_4) Which cloud characteristic refers to the ability to dynamically scale resources as needed during times of great demand as well as in times of low demand?

1. Scalability
2. Elasticity
3. On-demand
4. Centralized

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz3_5) Which of the following are popular options when it comes to ensuring security of cloud-based data in transit? (Choose two.)

1. Public Internet
2. VPN
3. Direct private connection
4. RDP

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz3_6) Which term refers to your company’s data being stored on shared physical servers in the public cloud infrastructure?

1. Hybrid
2. Multitenancy
3. Elasticity
4. Orchestration

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz3_7) Which of the following enables you to provision a logically isolated section of the AWS Cloud where you can launch AWS resources in a virtual network?

1. VPC
2. NFV
3. Internet gateway
4. NAT gateway

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz3_8) Which of the following are the best examples of SaaS?

1. AWS, Microsoft Azure, and Google Cloud Platform
2. AWS Elastic Beanstalk, Google App Engine, and IBM Cloud
3. AWS S3 and Azure Virtual Networks
4. Gmail and Microsoft 365