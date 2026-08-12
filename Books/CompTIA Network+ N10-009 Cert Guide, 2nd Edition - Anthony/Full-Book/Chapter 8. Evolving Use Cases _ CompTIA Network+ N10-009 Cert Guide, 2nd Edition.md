## Chapter 8

## Evolving Use Cases

This chapter covers the following topics related to Objective 1.8 (Summarize evolving use cases for modern network environments) of the CompTIA Network+ N10-009 certification exam:

- [Software-defined network (SDN) and software-defined wide area network (SD-WAN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08lev2sec1)

  - Application aware
  - Zero-touch provisioning
  - Transport agnostic
  - Central policy management
- [Virtual Extensible Local Area Network (VXLAN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08lev1sec3)

  - Data center interconnect (DCI)
  - Layer 2 encapsulation
- [Zero trust architecture (ZTA)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08lev1sec4)

  - Policy-based authentication
  - Authorization
  - Least privilege access
- [Secure Access Secure Edge (SASE)/Security Service Edge (SSE)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08lev1sec5)
- [Infrastructure as code (IaC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08lev1sec6)

  - Automation

    - Playbooks/templates/reusable tasks
    - Configuration drift/compliance
    - Upgrades
  - Dynamic inventories
- Source control

  - Version control
  - Central repository
  - Conflict identification
  - Branching
- [IPv6 addressing](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08lev2sec5)

  - Mitigating address exhaustion
  - Compatibility requirements

    - Tunneling
    - Dual stack
    - NAT64

Are you excited to learn about some of the newer technologies featured in this version of the CompTIA Network+ exam? As the title of this chapter suggests, here we are going to focus on some of the latest evolving technologies taking the networking world by storm (and no, not a broadcast storm).

This chapter begins with a look at software-defined networking (SDN) and a very specific implementation called the software-defined wide area network (SD-WAN). As you will learn, these technologies make it much simpler to operate modern networks with all their sophisticated capabilities and features.

Next, this chapter explores the latest evolution in virtual local area networks. It is called virtual extensible local area network, or VXLAN. As you will learn, VXLAN is a network virtualization technology that encapsulates Ethernet frames in UDP packets to create a scalable Layer 2 overlay network across Layer 3 infrastructures. It enables the extension of VLANs beyond traditional boundaries, supporting large-scale cloud and data center environments by allowing for more flexible and dynamic network segmentation.

As one would guess, another important area of evolving technologies for networking is in the space of security. In this part of the chapter, we examine some of the latest advancements in network security. These include zero trust architecture (ZTA), Secure Access Secure Edge (SASE), and Security Service Edge (SSE).

Next, this chapter describes many aspects and benefits of infrastructure as code (IaC). Infrastructure as code is a method of managing and provisioning computing infrastructure through machine-readable configuration files, enabling automation and consistency across environments. Treating infrastructure configurations as code allows for version control, collaborative development, and efficient scaling of IT resources.

Although IPv4 is the most widely deployed Layer 3 addressing scheme in today’s networks, its scalability limitations are causing available IPv4 addresses to quickly become depleted. Fortunately, a newer version of IP, IPv6, is scalable beyond anything you will need in your lifetime. This chapter concludes by introducing you to the fundamental characteristics of IPv6 addressing.

### Foundation Topics

### SDN and SD-WAN

Never before in my decades of studying and teaching computer networking have I seen more fear from students regarding the elimination of their jobs due to automation and cutting-edge technologies. In this author’s opinion, artificial intelligence (AI) and computers are not going to be eliminating the need for you (a human) in the network any time soon. While [***software-defined networking (SDN)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_640) allows you to add more and more automation and orchestration to a network, there will still be a need for you and your skills.

#### Software-Defined Networking (SDN)

![](../images/key_topic_icon_158.jpg)

Software-defined networking, which has been around for a very long time, is making a huge resurgence and being implemented in many parts of large and small networks today. For example, consider your wireless LAN. Perhaps you are using lightweight access points and wireless LAN controllers (WLCs). If so, you are seeing a very strict separation of the data, management, and control planes. The WLC is the primary control plane intelligence of the solution. (The specific SDN planes of operation are covered in more detail later in this chapter.)

SDN is changing the landscape of traditional networks. A well-implemented software-defined network allows the administrator to implement features, functions, and configurations without the need to do command-line configuration on the individual network devices. The front end that the administrator interfaces with can alert the administrator to what the network is currently doing, and then, through that same graphical user interface, the administrator can indicate what he or she wants done; behind the scenes, the software-defined network implements the detailed configurations across multiple network devices.

A key component in most software-defined networking solutions is an SDN controller. This appliance-based device is responsible for distributing control plane instructions to network devices downstream for configuration and management.

While many different approaches can be taken to SDN, almost everyone agrees that the best strategy is to separate the network into different discrete planes or layers of operation:

- **Application plane:** This is where all the technology that involves the applications resides. Today, it is not uncommon for an application to be powered by tiny microservices running as containers in a heavily virtualized cloud environment. But of course, there are plenty of other options for powering this layer. Many of them can even be much more traditional.
- **Control plane:** Although this layer of operation is often described as the “brains” of the operation, you are still the true brains of the operation. In fact, you are likely to use a “single pane of glass” solution that provides the correct application programming interface (API) calls to the controller. The controller turns these API commands into calls to the network devices in order to monitor or configure them properly. The API calls from you to the controller are referred to as *northbound* operations, and the commands from the controller to the network devices are referred to as *southbound operations*. The controller is always considered to be in the middle. Examples of control layer functions include routing and switching intelligence, and common control layer protocols include Open Shortest Path First (OSPF), Border Gateway Protocol (BGP), and Rapid Spanning Tree Protocol (RSTP).
- **Data plane:** The data plane (sometimes called the infrastructure plane) contains the hardware and software that power the enterprise. In it, you often find legacy and dated technologies. This infrastructure is now being controlled in a new and exciting way.
- **Management plane:** It is necessary to perform a lot of routine maintenance in a network, and the management plane is for these “boring” tasks. The management plane allows administrators to see their devices and traffic flows and react as needed to manage data plane behavior. This can be done automatically through configuration apps that can, for example, add more bandwidth if it looks as if edge components are getting congested. Note that the management plane manages and monitors processes across all layers of the network stack.

All the layers of operation are critically important, and each plays an important role. The layers of operation work seamlessly together as one to get the various jobs done. [Figure 8-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08fig01) shows these commonly defined planes of operations with software-defined networking.

![](../images/08fig01.jpg)


**Figure 8-1** Software-Defined Networking

#### Software-Defined Wide Area Network (SD-WAN)

For many years, new technologies and improvements have been made in local area networks (LANs). Sadly, there were not many innovations in a very important part of the network—the wide area network (WAN). Thanks to software-defined networking improvements, we now have a celebrated and popular new improvement called the [***software-defined wide area network (SD-WAN)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_641).

The SD-WAN is a transformative approach to managing and optimizing wide area networks. Unlike traditional WANs, which rely on proprietary hardware and inflexible connectivity options, SD-WAN utilizes software-defined networking principles to create a more adaptable and efficient network infrastructure. SD-WAN abstracts the network layer from the hardware, enabling centralized control and dynamic management of network traffic across multiple connection types, such as broadband, Multiprotocol Label Switching (MPLS), Long-Term Evolution (LTE), and more. This abstraction enhances performance, reduces costs, and improves overall agility, making it particularly valuable for enterprises with distributed branch locations.

One of the key features of SD-WAN is its [***application awareness***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_052). This capability allows the network to identify and prioritize traffic based on the application, ensuring that critical applications, such as video conferencing and VoIP, receive the necessary bandwidth and low latency for optimal performance. Application awareness in SD-WAN is achieved through deep packet inspection and real-time analytics, which categorize and manage traffic flows according to predefined policies. This feature not only improves the quality of experience for end users but also enhances overall network efficiency by intelligently routing traffic based on application requirements and current network conditions.

[***Zero-touch provisioning (ZTP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_779) is another significant feature of SD-WAN, simplifying the deployment and management of network devices. With ZTP, network administrators can configure and deploy new branch devices without manual intervention. This process typically involves shipping a preconfigured device to a location, where it automatically connects to the SD-WAN controller, downloads its configuration, and becomes operational with minimal human involvement. ZTP significantly reduces deployment time and operational costs, enabling rapid scaling of the network to meet the needs of growing businesses and facilitating easier maintenance and updates.

SD-WAN is designed to be [***transport agnostic***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_713), meaning it can leverage any available connectivity option, such as broadband, MPLS, LTE, or even satellite links. This flexibility allows organizations to choose the most cost-effective and efficient connectivity for each location, without being tied to a specific provider or technology. Transport agnosticism enhances the resilience and redundancy of the network, as SD-WAN can dynamically route traffic across multiple links to maintain performance and availability, even in the event of a link failure or degradation.

[***Central policy management***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_129) is a cornerstone of SD-WAN architecture, providing a unified platform for defining and enforcing network policies across all connected devices and locations. Through a centralized management console, administrators can easily set rules for traffic prioritization, security, and compliance, ensuring consistent policy application throughout the network. This centralized approach simplifies network management, improves security by standardizing configurations, and enables quick adjustments to network policies in response to changing business needs or threats. Central policy management also allows for real-time monitoring and analytics, providing valuable insights into network performance and usage.

### Virtual Extensible Local Area Network (VXLAN)

![](../images/key_topic_icon_158.jpg)

[***Virtual Extensible Local Area Network (VXLAN)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_740) is a network virtualization technology designed to address the limitations of traditional VLANs in large-scale data center environments and the cloud. It operates by encapsulating Layer 2 Ethernet frames within Layer 3 UDP packets, enabling the extension of Layer 2 networks over a Layer 3 infrastructure. This encapsulation allows for the creation of large-scale, logical Layer 2 networks across geographically dispersed data centers, which facilitates the movement of virtual machines (VMs) and workloads without reconfiguring the underlying physical network.

At its core, VXLAN provides a way to overcome the scalability limitations of traditional VLANs, which are restricted to a maximum of 4096 segments due to the 12-bit VLAN ID field. By using a 24-bit segment identifier known as a VXLAN Network Identifier (VNI), VXLAN can support up to 16 million distinct segments. This significant increase in segmentation capacity is crucial for modern cloud environments and large enterprise data centers, where thousands of tenants and millions of isolated networks might coexist.

The key mechanism that makes VXLAN powerful is its ability to perform [***Layer 2 encapsulation***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_361). In VXLAN, a Layer 2 Ethernet frame from a VM or host is encapsulated into a Layer 3 UDP packet. This packet includes an outer IP header, which can route across a Layer 3 network, and an outer UDP header, which facilitates the tunneling mechanism. The encapsulated packet is then transmitted over the existing Layer 3 infrastructure. This process allows for Layer 2 segments to be extended across different Layer 3 networks, creating a seamless and scalable virtual network that behaves as if all connected hosts are on the same local network. [Figure 8-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08fig02) shows the Layer 2 encapsulation used with VXLAN technology.

![](../images/08fig02.jpg)


**Figure 8-2** VXLAN Encapsulation

One of the primary applications of VXLAN is in [***data center interconnect (DCI)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_184). DCI involves connecting multiple data centers to provide a unified infrastructure, allowing for efficient resource sharing, workload mobility, and disaster recovery. VXLAN is particularly suited for DCI because it enables the extension of Layer 2 networks over Layer 3 distances, thus facilitating the seamless migration of VMs and applications between data centers. This capability is crucial for businesses that need to maintain high availability and disaster resilience by distributing workloads across multiple locations.

VXLAN also integrates well with modern network management and automation tools, supporting dynamic and programmable networking. The VXLAN gateways or Virtual Tunnel Endpoints (VTEPs) play a critical role in encapsulating and decapsulating traffic and can be implemented in both hardware (switches) and software (hypervisors). This flexibility makes VXLAN an essential component in the architecture of software-defined networks (SDNs) and network functions virtualization (NFV), where it provides the necessary overlay networks that decouple virtual network management from physical network hardware.

### Zero Trust Architecture (ZTA)

![](../images/key_topic_icon_158.jpg)

[***Zero trust architecture (ZTA)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_780) is a security model centered on the principle that no entity, whether inside or outside the network, should be trusted by default. Instead, verification is required from everyone trying to access resources within the network, ensuring robust and granular security. Unlike traditional security models that rely on a trusted internal network and a less trusted external network, ZTA treats all network traffic as untrusted, continuously validating users and devices before granting access to sensitive data and systems. This model significantly mitigates the risk of cyber threats by ensuring that access is granted only to those who genuinely need it and are properly authenticated.

In zero trust architecture, [***policy-based authentication***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_504) is a crucial component. This approach ensures that all access requests are dynamically authenticated using predefined security policies that consider a variety of factors. These factors include the identity of the user, the device being used, the location of the access request, and the nature of the resource being accessed. Each access attempt is subjected to rigorous authentication checks, which may include multifactor authentication (MFA) and contextual data analysis. For instance, a user attempting to access a corporate resource from an unfamiliar location or device might be required to provide additional verification to ensure they are who they claim to be. By implementing policy-based authentication, ZTA enhances security by dynamically adjusting access requirements based on the context and potential risks associated with each request.

Once authentication is successfully achieved, ZTA moves to policy-based [***authorization***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_072), which governs what authenticated users are permitted to do within the network. Authorization policies are designed to be granular and specific, ensuring that users have access only to the resources necessary for their roles and tasks. These policies are enforced in real time, continually reassessing user permissions based on their current context and behavior. For example, if a user’s behavior deviates from their usual patterns, such as accessing sensitive data they don’t typically handle, the system may prompt for additional verification or deny access altogether. This dynamic and context-aware approach to authorization helps prevent unauthorized access and reduces the risk of data breaches by ensuring that permissions are strictly aligned with business needs and security requirements.

Central to the ZTA model is the concept of [***least privilege access***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_367). This principle dictates that users and devices should be granted the minimum level of access required to perform their functions and no more. By limiting access rights, ZTA minimizes the potential damage that could be caused by compromised credentials or malicious actors. Implementing least privilege access involves meticulously defining user roles, responsibilities, and the associated access permissions. For instance, a financial analyst may need access to financial records but not to customer personal information, while an IT administrator might need access to system logs but not to employee payroll data. Regular reviews and adjustments of access levels are also essential to accommodate changes in roles and responsibilities, ensuring that access permissions remain tightly controlled and aligned with the principle of least privilege access.

### SASE and SSE

[***Secure Access Secure Edge (SASE)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_593) is a transformative architectural framework designed to meet the demands of modern networking and security. It is a cloud-native service model that converges wide area networking and network security services like Secure Web Gateway (SWG), Cloud Access Security Broker (CASB), Zero Trust Network Access (ZTNA), and Firewall as a Service (FWaaS) into a single cloud-based service. This convergence allows organizations to securely connect users, devices, and applications over a global network. The SASE framework was first conceptualized by Gartner in 2019 as a response to the evolving IT landscape, where traditional network and security models were becoming increasingly insufficient for the dynamic, distributed, and cloud-centric environments.

At its core, SASE provides secure and optimized access to applications and resources regardless of the user’s location. This is crucial in the current era where remote work and cloud adoption have surged, making traditional perimeter-based security models obsolete. SASE combines networking and security functionalities in a unified platform, delivered as a service from the cloud. This integration simplifies the complexity of managing multiple standalone solutions, reduces costs, and provides consistent security policies across all edges of the network, including data centers, branches, mobile users, and Internet of Things (IoT) devices.

A key aspect of SASE is its emphasis on zero trust security principles. Unlike traditional network security models that focus on defending a defined perimeter, zero trust assumes that threats can originate from both outside and inside the network. SASE implements zero trust by verifying the identity and integrity of users and devices before granting access to applications and data. This ensures that only authenticated and authorized entities can access sensitive resources, mitigating risks associated with internal and external threats. Furthermore, SASE continuously monitors and enforces security policies based on user behavior, device status, and network context to dynamically adapt to changing threat landscapes.

SASE also addresses the need for optimized network performance by integrating SD-WAN capabilities. By leveraging the global presence of SASE providers, organizations can benefit from reduced latency, improved application performance, and enhanced user experience, regardless of the user’s geographical location.

SASE also supports a holistic approach to data protection and compliance. By consolidating security functions into a single framework, SASE provides comprehensive visibility and control over data flows across the network. This enables organizations to enforce data loss prevention (DLP) policies, detect and respond to threats in real time, and ensure compliance with regulatory requirements. The centralized management of security policies also simplifies the auditing process and facilitates the rapid implementation of policy changes to adapt to evolving compliance demands.

[***Security Service Edge (SSE)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_600) is a cloud-native cybersecurity framework that provides a comprehensive suite of security services to protect data, applications, and users in a distributed, cloud-centric environment. Introduced by Gartner as a distinct subset of the broader Secure Access Service Edge (SASE) model, SSE focuses specifically on delivering security services without encompassing the networking components such as SD-WAN. It is designed to address the challenges of modern IT architectures, where traditional perimeter-based security is inadequate for safeguarding against sophisticated cyber threats targeting a dispersed workforce and cloud-hosted resources.

SSE is particularly relevant in the context of today’s hybrid and remote work environments, where employees access corporate resources from various locations and devices. Traditional security solutions that rely on a fixed perimeter are insufficient in such scenarios, as they cannot effectively protect against threats targeting remote users or cloud-hosted data. SSE addresses this challenge by extending security controls to the edge, ensuring that all users, regardless of their location, are subject to the same rigorous security policies. This approach not only improves security but also simplifies the management of security infrastructure by consolidating it into a single cloud-based service.

Another significant aspect of SSE is its focus on data protection and regulatory compliance. With the increasing volume of sensitive data being stored and processed in the cloud, organizations face greater risks of data breaches and regulatory fines. SSE helps mitigate these risks by providing advanced data protection capabilities such as encryption, data loss prevention, and threat detection. These features ensure that sensitive data is safeguarded against unauthorized access and exfiltration, and that organizations can maintain compliance with data privacy regulations like GDPR, CCPA, and HIPAA.

### Infrastructure as Code (IaC)

One of the most exciting developments in technology today is [***infrastructure as code (IaC)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_322). When your infrastructure (often in the cloud) is all virtualized, it can be easily created (and destroyed) as well as maintained by using scripts (code). This makes it possible for you to “spin up” test environments or pilot tests with ease. Think about how much easier it is to create a duplicate site for high availability (HA) needs when using IaaS and IaC than when using physical devices.

The large public cloud providers make it simple for you to implement IaC. They provide tools (such as CloudFormation from AWS) that permit you to easily generate the code required to script the creation of useful (and even complex) infrastructures. Thanks to this capability, you can easily automate—and even orchestrate—common networking tasks that used to take weeks or months to carry out. For example, say that you need to spin up 50 servers for a test project. Thanks to IaC, you can now do this with a few clicks of the mouse instead of using a massive (and often) expensive deployment of physical servers.

There is a difference between automation and orchestration:

- [***Automation***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_074) refers to the automated completion of a task or tasks.
- *Orchestration* refers to the scheduling and monitoring of many different automations. It is, basically, automating the automation.

Note

IaC is also known as *programmable infrastructure* to indicate that the infrastructure configuration can be incorporated into application code. IaC enables DevOps teams to test applications in production-like environments from the beginning of the development cycle.

Key components of automation in IaC include playbooks, templates, and reusable tasks, which facilitate the creation, maintenance, and scaling of infrastructure in a consistent manner. Additionally, automation helps address challenges such as configuration drift, compliance, and upgrades, and supports dynamic inventories for flexible resource management. Here are more details on the key components and advantages of automation with IaC:

![](../images/key_topic_icon_158.jpg)

- [***Playbooks***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_497): Playbooks are a fundamental tool in IaC automation, particularly in tools like Ansible. They provide a structured way to define a series of tasks that automate the provisioning, configuration, and management of infrastructure. Playbooks are written in YAML and describe the desired state of the infrastructure in a declarative manner. This allows for complex workflows to be automated, such as deploying applications, configuring servers, and managing network devices.

Note

Ansible is a software tool that enables infrastructure as code. It is open source and includes modules for software provisioning, configuration management, and application deployment functionality. YAML is a human-readable data serialization language. It is commonly used for configuration files and in applications where data is being stored or transmitted.

- [***Templates***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_687): Templates in IaC are used to define infrastructure resources in a reusable and consistent manner. Tools like Terraform and AWS CloudFormation utilize templates to describe cloud resources and their relationships. These templates can include variables, allowing for parameterization and flexibility in resource configurations. For example, a template might define a virtual machine with specific attributes like instance type, security groups, and attached storage. By using templates, organizations can ensure that infrastructure components are created with a consistent configuration across different environments, reducing the risk of configuration errors and making it easier to replicate and scale infrastructure.
- [***Reusable tasks***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_553): Reusable tasks are a key aspect of IaC automation that promote efficiency and maintainability. In tools like Ansible, reusable tasks can be defined in roles, which are collections of tasks, variables, and templates organized in a structured format. Roles can be shared across multiple playbooks and projects, allowing for the reuse of common configurations and deployment steps. For example, a role might encapsulate the tasks required to set up a web server, including installing packages, configuring services, and managing firewall rules.
- [***Configuration drift***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_161): Configuration drift occurs when the actual state of the infrastructure deviates from the desired state defined in the IaC. This can happen due to manual changes, system updates, or environmental factors. Automation in IaC helps mitigate configuration drift by regularly applying the desired state to the infrastructure. Tools like Terraform and Ansible can perform periodic checks and reapply configurations to ensure consistency. This not only helps maintain the reliability and predictability of the infrastructure but also reduces the time and effort required to troubleshoot and resolve issues caused by drift. Automation ensures that the infrastructure remains aligned with the defined state, minimizing the risks associated with unintended changes.
- [***Compliance***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_159): Compliance with industry standards and regulatory requirements is a critical aspect of infrastructure management. Automation in IaC enables organizations to enforce compliance by embedding policies and controls directly into the infrastructure code. For example, security configurations, access controls, and data protection measures can be defined in the IaC templates and playbooks. Automated tools can continuously monitor the infrastructure for compliance with these policies, generating reports and alerts when deviations occur.
- [***Upgrades***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_732): Upgrading infrastructure components, such as software versions, operating systems, and hardware configurations, can be a complex and error-prone process. IaC automation simplifies upgrades by allowing organizations to define the desired state of the infrastructure, including the required versions and configurations. Upgrades can be tested in a staging environment using the same IaC definitions before being applied to production, reducing the risk of disruptions.
- [***Dynamic inventories***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_240): Dynamic inventories are a feature of IaC automation that allows the infrastructure to be dynamically discovered and managed based on current configurations and states. This is particularly useful in cloud environments, where resources can be created and terminated frequently. Tools like Ansible support dynamic inventories, which can query cloud providers or other data sources to generate an up-to-date list of resources for configuration management tasks.

Because the C in IaC stands for code, it is of no surprise that IaC systems tend to take advantage of [***source control***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_643) systems. These systems tend to feature the following:

- [***Version control***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_738): Version control is at the heart of source control systems and is vital for managing IaC. It enables teams to track changes to infrastructure code over time, maintaining a history of modifications, additions, and deletions. Each change is recorded with a unique identifier, often called a *commit*, along with metadata such as the author, timestamp, and a message describing the change.
- [***Central repository***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_130): A central repository in a source control system acts as the single source of truth for all infrastructure code. This repository stores the master copies of the code and provides a central location where all team members can access, contribute to, and collaborate on the infrastructure codebase.
- [***Conflict identification***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_164): Conflict identification is an essential feature of source control systems, especially in collaborative IaC environments, where multiple team members may work on the same code simultaneously. Conflicts occur when changes made by different users overlap or are incompatible with each other.
- [***Branching***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_100): Branching is a powerful feature of source control systems that allows teams to create isolated copies of the codebase for different purposes. This is particularly useful in IaC environments for managing multiple streams of development and experimentation without affecting the main codebase.

### IP Version 6

With the global proliferation of IP-based networks, available IPv4 addresses are rapidly becoming exhausted. Fortunately, IPv6 provides enough IP addresses for many generations to come. This section introduces [***IPv6 addressing***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_349) with a deep dive into IPv6’s address structure and a discussion of some of its unique characteristics.

#### Need for IPv6

With the worldwide depletion of IP version 4 (IPv4) addresses, many organizations have migrated, are in the process of migrating, or are considering migrating their IPv4 addresses to IPv6 addresses. IPv6 dramatically increases the number of available IP addresses. In fact, IPv6 offers approximately 5 × 1028 IP addresses for each person on the planet.

Beyond the increased address space, IPv6 offers many other features:

- Simplified header:

  - The IPv4 header uses 12 fields.
  - The IPv6 header uses 5 fields.
- No broadcasts
- No fragmentation (performs MTU discovery for each session)
- Can coexist with IPv4 during a transition:

  - [***Dual stack***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_235) (running IPv4 and IPv6 simultaneously on a network interface or device)
  - IPv6 over IPv4 (tunneling IPv6 over an IPv4 tunnel)

Even if you are designing a network based on IPv4 addressing, it is a good practice to consider how readily an IPv6 addressing scheme could be overlaid on that network at some point in the future. Using Teredo [***tunneling***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_721), an IPv6 host could provide IPv6 connectivity even when the host is directly connected to an IPv4-only network. Miredo is a client that can be used to implement the Teredo protocol and is included in many versions of Linux. IPv6/IPv4 tunneling is often referred to as 6to4 or 4to6 tunneling, depending on which protocol is being tunneled (IPv4 or IPv6). These are just some of the many tunneling mechanisms devised to ensure a smooth transition from IPv4 to IPv6. In fact, thanks to dual stack and tunneling features, it is very unlikely that you will see IPv4 ever completely go away in your lifetime.

Since there are so many available IPv6 addresses, network address translation (NAT) is not nearly as required in IPv6. One way it can be useful is in transition between the two versions, however. Network address translation from IPv6 to IPv4 ([***NAT64***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_430)) is a technology that facilitates communication between IPv6-only clients and IPv4-only servers, bridging the gap between the two distinct IP address families. It is yet another component in the transition from the older IPv4 protocol to the newer IPv6 protocol, allowing IPv6 networks to access resources on IPv4 networks without requiring the end systems to support both protocols. NAT64 works by translating IPv6 packets to IPv4 packets and vice versa, using a predefined prefix to generate an IPv6 address that maps to an IPv4 address.

#### IPv6 Address Structure

An IPv6 address has the following address format, where *X* is a hexadecimal digit in the range of 0 to F:

*XXXX*:*XXXX*:*XXXX*:*XXXX*:*XXXX*:*XXXX*:*XXXX*:*XXXX*

A hexadecimal digit is 4 bits in size (4 binary bits can represent 16 values). Notice that an IPv6 address has eight fields, and each field contains four hexadecimal digits. The following formula reveals why an IPv6 address is a 128-bit address:

4 bits per digit × 4 digits per field × 8 fields = 128 bits in an IPv6 address

IPv6 addresses can be difficult to work with because of their size. Fortunately, the following rules (often collectively referred to as *shorthand notation*) exist for abbreviating these addresses:

![](../images/key_topic_icon_158.jpg)

- Leading 0s in a field can be omitted.
- Contiguous fields containing all 0s can be represented with a double colon. (Note that this can be done only once for a single IPv6 address.)

For example, consider the following IPv6 address:

ABCD:0123:4040:0000:0000:0000:000A:000B

Using the rules for abbreviation, the IPv6 address can be rewritten as follows:

ABCD:123:4040::A:B

An exciting feature of IPv6 is the Extended Unique Identifier (EUI-64) format, which permits a device to automatically populate the low-order 64 bits of an IPv6 address based on an interface’s MAC address. You will read more about this capability later in this chapter.

#### IPv6 Address Types

The following are some of the many unique aspects of IPv6 addressing and interesting address types:

- IPv6 globally routable unicast addresses start with the first four hex characters in the range 2000 to 3999.
- An IPv6 link-local address is also used on each IPv6 interface. The link-local address begins with FE80.
- Multicast addresses begin with FF as the first two hex characters.
- IPv6 can use autoconfiguration to discover the current network and select a host ID that is unique on that network. Automatic generation of a unique host ID is made possible through a process known as *EUI-64*, which uses the 48-bit MAC address on the device to aid in the generation of the unique 64-bit host ID. Notice that the autoconfiguration capabilities described here permit you to create an IPv6 network free of DHCP-type services. The ability of IPv6 to replace the need for DHCP services like this is known as stateless address autoconfiguration (SLAAC). You will learn more about SLAAC in [Chapter 16](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16), “[IPv4 and IPv6 Network Services](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#ch16).”
- IPv6 can also use a special version of DHCP for IPv6. Not surprisingly, this version is called *DHCPv6*.
- The protocol that is used for *network discovery*—that is, to discover the network address and learn the Layer 2 addresses of neighbors on the same network—is Neighbor Discovery Protocol (NDP).

NDP is hugely important in IPv6. It defines five ICMPv6 packet types for important jobs:

![](../images/key_topic_icon_158.jpg)

- **Router Solicitation:** Hosts inquire with Router Solicitation messages to locate routers on an attached link.
- **Router Advertisement:** Routers advertise their presence together with various link and Internet parameters, either periodically or in response to a Router Solicitation message.
- **Neighbor Solicitation:** Neighbor solicitation messages are used by nodes to determine the link layer address of a neighbor or to verify that a neighbor is still reachable via a cached link layer address.
- **Neighbor Advertisement:** Neighbor advertisement messages are used by nodes to respond to a Neighbor Solicitation message.
- **Redirect:** Routers may inform hosts of a better first-hop router for a destination.

#### IPv6 Data Flows

You might recall from our discussion of IPv4 traffic flows in [Chapter 4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#ch04) that there are unicast, broadcast, multicast, and anycast methods of communication possible with IP version 4. IPv6 uses just three of the four types of data flows:

![](../images/key_topic_icon_158.jpg)

- Unicast
- Multicast
- Anycast

Just like in IPv4, IPv6 uses special address types for these data flows. The following sections summarize the characteristics of each address type.

##### Unicast

With unicast, a single IPv6 address is applied to a single interface, as illustrated in [Figure 8-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08fig03). The communication flow can be thought of as a one-to-one communication flow.

![](../images/08fig03.jpg)


**Figure 8-3** IPv6 Unicast Example

In [Figure 8-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08fig03), a server (AAAA::1) is sending traffic to a single client (AAAA::2).

##### Multicast

With multicast, a single IPv6 address (a multicast group) can represent multiple devices on a network, as shown in [Figure 8-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08fig04). The communication flow is a one-to-many communication flow.

In [Figure 8-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08fig04), a server (AAAA::1) is sending traffic to a multicast group (FF00::A). Two clients (AAAA::2 and AAAA::3) have joined this group. Those clients receive the traffic from the server, and any client that did not join the group (for example, AAAA::4) does not receive the traffic.

![](../images/08fig04.jpg)


**Figure 8-4** IPv6 Multicast Example

IPv6 replaces broadcast behavior with multicast, thanks to the “all nodes” multicast group. This reserved address is FF01:0:0:0:0:0:0:1 (FF01::1). All IPv6 nodes join this group. This is a simple and efficient method for sending traffic to all nodes.

##### Anycast

With *anycast*, a single IPv6 address is assigned to multiple devices, as illustrated in [Figure 8-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08fig05). It is a one-to-nearest (from the perspective of a router’s routing table) communication flow.

![](../images/08fig05.jpg)


**Figure 8-5** IPv6 Anycast Example

In [Figure 8-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08fig05), a client with IPv6 address AAAA::1 wants to send traffic to destination IPv6 address AAAA::2. Notice that two servers (Server A and Server B) have the IPv6 address AAAA::2. In the figure, the traffic destined for AAAA::2 is sent to Server A, via router R2, because the network on which Server A resides appears to be closer than the network on which Server B resides, from the perspective of router R1’s IPv6 routing table.

Note

Remember that the dreaded broadcast frames and packets from IPv4 do not exist in an IPv6-only network. IPv6 uses only unicasts, multicasts, and anycasts, as described in this section. With IPv6, if you want to send a frame or packet to all nodes in the local network, you use the all-nodes IPv6 multicast address.

### Real-World Case Study

Acme, Inc. is currently investigating the use of a software-defined wide area network (SD-WAN) to help revolutionize the legacy WAN infrastructure. Specifically, Acme is very interested in the enhanced network performance that this solution can bring. Acme would like the SD-WAN solution to dynamically route traffic over the best available path based on real-time network conditions, such as latency, jitter, and packet loss. This would ensure that critical applications, like video conferencing and cloud services, receive the bandwidth and low-latency routes they need, resulting in a better user experience.

Acme, Inc. is also actively exploring the implementation of a new zero trust architecture to enhance its cybersecurity posture and mitigate the risks associated with modern cyber threats. Unlike traditional security models that rely on a defined network perimeter, zero trust operates on the principle that no user or device, whether inside or outside the network, should be trusted by default. This approach aligns with Acme’s goal of protecting sensitive data and resources in an increasingly complex and distributed IT environment. By adopting zero trust, Acme can ensure that all access requests are continuously verified and authenticated, regardless of the user’s location or network. This is particularly important as Acme’s workforce becomes more mobile and remote, accessing company resources from various devices and locations. Zero trust will enable Acme to enforce strict access controls and minimize the attack surface, thereby reducing the likelihood of unauthorized access and data breaches.

The move toward zero trust is also driven by Acme’s desire to streamline compliance with regulatory requirements and enhance the overall resilience of its IT infrastructure. Zero trust architecture provides a comprehensive framework for implementing security policies that are consistent and enforceable across all endpoints and applications. This allows Acme to achieve greater visibility into user activities and data flows, ensuring that any suspicious behavior is promptly detected and addressed. Additionally, the granular control afforded by zero trust helps Acme to safeguard sensitive information and comply with regulations such as GDPR and HIPAA, which mandate stringent data protection measures. By integrating zero trust principles into its security strategy, Acme aims to build a robust and adaptable security model that not only protects against current threats but also evolves to address future challenges, ultimately supporting the company’s growth and operational excellence.

### Summary

Here are the main topics covered in this chapter:

- This chapter first provided a description of software-defined networking (SDN) and software-defined wide area networks (SD-WAN).
- This chapter next covered emerging technology of Virtual Extensible Local Area Networks (VXLAN). After describing the Layer 2 encapsulation that makes this technology function, this section described the common use case of the data center interconnect (DCI) functionality.
- This chapter then examined the emerging technology of the zero trust architecture (ZTA), including its major components of policy-based authentication, authorization, and least privilege access.
- This chapter defined the Secure Access Secure Edge (SASE) and Security Service Edge (SSE) solutions.
- This chapter covered the concept of infrastructure as code (IaC) and emphasized the features of IaC that rely on automation. This section of the chapter also discussed how source control can be critical to the IaC environment.
- The characteristics of IPv6 were highlighted, including the IPv6 address format and IPv6 data flows (unicast, multicast, and anycast).

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 8-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08tab01) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 8-1** Key Topics for [Chapter 8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| Section | Software-Defined Networking (SDN) | 205 |
| Section | Virtual Extensible Local Area Network (VXLAN) | 208 |
| Section | Zero Trust Architecture (ZTA) | 209 |
| List | Key components for IaC | 213 |
| List | Steps for shorthand with IPv6 addresses | 217 |
| List | Functions of NDP | 218 |
| List | Types of IPv6 data flows | 219 |

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[application awareness](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_01)

[authorization](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_02)

[automation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_03)

[branching](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_04)

[central policy management](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_05)

[central repository](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_06)

[compliance](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_07)

[configuration drift](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_08)

[conflict identification](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_09)

[data center interconnect (DCI)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_010)

[dual stack](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_011)

[dynamic inventories](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_012)

[infrastructure as code (IaC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_013)

[IPv6 addressing](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_014)

[Layer 2 encapsulation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_015)

[least privilege access](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_016)

[NAT64](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_017)

[playbooks](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_018)

[policy-based authentication](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_019)

[reusable tasks](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_020)

[Secure Access Secure Edge (SASE)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_021)

[Security Service Edge (SSE)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_022)

[source control](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_023)

[software-defined networking (SDN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_024)

[software-defined wide area network (SD-WAN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_025)

[templates](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_026)

[transport agnostic](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_027)

[tunneling](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_028)

[upgrades](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_029)

[version control](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_030)

[Virtual Extensible Local Area Network (VXLAN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_031)

[zero-touch provisioning (ZTP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_032)

[zero trust architecture (ZTA)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#key_033)

### Additional Resources

**Software Defined Networking (SDN) Demystified:** <https://www.youtube.com/watch?v=lVcUZCVvBjw>

**VXLAN Simple Explanation:** <https://www.youtube.com/watch?v=7Shfu9BrJP8>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz8_1) BGP is an example of a technology found in what layer/plane of operation in a software-defined network?

1. Management
2. Control
3. Data
4. Application

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz8_2) What feature of the SD-WAN allows the network to seamlessly route and manage traffic over diverse transport media without dependency on the underlying physical connections?

1. Central policy management
2. Application awareness
3. Zero-touch provisioning
4. Transport agnostic

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz8_3) What protocol serves as the transport protocol for encapsulating Layer 2 Ethernet frames with Layer 3 packets in the VXLAN solution?

1. UDP
2. TCP
3. ARP
4. FHRP

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz8_4) What is the term given to the difference in the actual state of your infrastructure compared to the state defined in an IaC implementation?

1. Version control
2. Configuration drift
3. Source control
4. Conflict identification

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz8_5) How can the following IPv6 address be condensed? 2009:0123:4040:0000:0000:000:000A:100B

1. 2009::123:404:A:100B
2. 2009::123:404:A:1B
3. 2009:123:4040::A:100B
4. 2009:0123:4040::0::000A:100B

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz8_6) What technology allows for the automatic assignment of the host portion of an IPv6 address?

1. Dual stack
2. EUI-64
3. Neighbor discovery
4. Anycast

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz8_7) What can IPv6 networks use to assign IP addresses?

1. SLAAC
2. CIDR
3. Port address translation
4. Classless inter-domain routing notation

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz8_8) Which of the following is a network architecture that integrates wide area networking (WAN) capabilities with comprehensive network security functions such as Secure Web Gateway (SWG), Cloud Access Security Broker (CASB), Firewall as a Service (FWaaS), and Zero Trust Network Access (ZTNA)?

1. SD-WAN
2. VXLAN
3. SSE
4. SASE

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz8_9) Which of the following involves connecting multiple data centers to provide a unified infrastructure, allowing for efficient resource sharing, workload mobility, and disaster recovery?

1. NAT64
2. SASE
3. DCI
4. SSE

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz8_10) Which of the following is a technology that facilitates communication between IPv6-only clients and IPv4-only servers, bridging the gap between the two distinct IP address families?

1. NAT64
2. Dual stack
3. Conflict identification
4. Branching