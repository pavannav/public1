## Chapter 13

## Organizational Processes and Procedures

This chapter covers the following topics related to Objective 3.1 (Explain the purpose of organizational processes and procedures) of the CompTIA Network+ N10-009 certification exam:

- [Documentation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13lev1sec2)

  - Physical vs. logical diagrams
  - Rack diagrams
  - Cable maps and diagrams
  - Network diagrams

    - Layer 1
    - Layer 2
    - Layer 3
  - Asset inventory

    - Hardware
    - Software
    - Licensing
    - Warranty support
  - IP address management (IPAM)
  - Service-level agreement (SLA)
  - Wireless survey/heat map
- [Life-cycle management](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13lev2sec1)

  - End-of-life (EOL)
  - End-of-support (EOS)
  - Software management

    - Patches and bug fixes
    - Operating system (OS)
    - Firmware
  - Decommissioning
- [Change management](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13lev2sec2)

  - Request process tracking/service request
- [Configuration management](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13lev2sec3)

  - Production configuration
  - Backup configuration
  - Baseline/golden configuration

If you are reading this text start to finish, you might have a newfound appreciation for how complex networking is today. Fortunately, there are many established processes and best practices you can use to help take much of the guesswork out of implementing and maintaining your network. This is especially beneficial in the complex and challenging area of network security.

This chapter begins by presenting many of the different forms of documentation you should consider maintaining as you design and operate modern networks. This documentation includes such items as network documentation, asset inventories, and service-level agreements (SLAs).

This chapter also discusses critical processes such as life-cycle management, change management, and configuration management. These practices are considered by many to be an absolute must when working with networks today.

### Foundation Topics

### Documentation

I cannot stress enough the importance of up-to-date and accurate network documentation. Documentation is useful for proper network management tasks, and it is also critical in troubleshooting, security, optimization, and other key areas of networking today. Consider these important examples of network documentation:

![](../images/key_topic_icon_158.jpg)

- [***Physical diagrams***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_490) **vs.** [***logical diagrams***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_389): A physical diagram represents the tangible, hardware aspects of a network, such as cables, switches, routers, and their physical connections and locations within a facility. It shows how the components are physically interconnected and where they are positioned. In contrast, a logical diagram focuses on the abstract, conceptual layout of the network, illustrating the flow of data, network segmentation, IP addressing schemes, and how devices and services are logically organized and interact with each other. While a physical diagram provides a map for setting up and maintaining the actual hardware, a logical diagram is essential for understanding the network’s data flow, design, and the relationships between different network entities.
- [***Rack diagrams***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_537): These days, thanks to the very small form factors of many network devices, we have more devices than ever before coexisting in a single rack in a data center. Therefore, rack diagrams are needed to assist in the management of all the various devices in the racks. [Figure 13-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13fig01) shows an example of a rack diagram. This diagram was made with the free version of Lucidchart ([https://www.lucidchart.com](https://www.lucidchart.com/)).

![](../images/13fig01.jpg)


**Figure 13-1** A Rack Diagram

- [***Cable maps***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_112) **and diagrams:** Another key set of documentation includes diagrams showing cabling and port locations. This documentation allows you to track cable runs from switches and map them to actual wall jacks where users connect to your network; these connections might also represent trunks to additional network devices such as wireless access points.
- [***Network diagrams***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_440): Network diagrams are visual representations that illustrate the structure, components, and connections within a network. They serve as essential tools for designing, analyzing, and managing network infrastructure. [***Layer 1 diagrams***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_359), or physical diagrams, depict the actual hardware components, such as cables, switches, and routers, highlighting how these devices are physically interconnected. [***Layer 2 diagrams***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_360), often referred to as data link layer diagrams, focus on how devices such as switches and bridges manage data frames within a local network, detailing MAC addresses and VLAN configurations. [***Layer 3 diagrams***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_364), or network layer diagrams, emphasize the logical flow of data across networks, showcasing IP addressing, routing protocols, and the interactions between routers and other Layer 3 devices.
- [***Asset inventory***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_060): An asset inventory in an IT department’s documentation is a comprehensive catalog of the organization’s technology assets, encompassing hardware, software, licensing, and warranty support. A [***hardware asset inventory***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_292) typically lists all physical devices such as servers, desktops, laptops, network equipment, and peripherals. Such an inventory often details specifications, purchase dates, locations, and unique identifiers. A [***software asset inventory***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_639) typically includes applications and operating systems, specifying versions, installations, usage metrics, and compliance with organizational policies. The [***licensing asset inventory***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_369) tracks software licenses, ensuring compliance with vendor agreements, detailing license types, quantities, expiration dates, and renewal requirements. The [***warranty support asset inventory***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_760) typically records warranty coverage for hardware and software, including start and end dates, support levels, and vendor contact information, to manage maintenance and support effectively.
- [***IP address management (IPAM)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_341): Another important aspect of documentation is IP address management. IPAM is a means of planning, tracking, and managing the Internet Protocol address space used in a network. IPAM typically integrates with DNS and DHCP so that each is aware of changes in the other (for instance, DNS knowing of the IP address taken by a client via DHCP and updating itself accordingly).

Note

Stressed out about how you are going to build your own IPAM documentation system? While you can certainly create your own using something like spreadsheet software, there are many IPAM tools available standalone and as part of broader network management systems.

- [***Service-level agreements (SLAs)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_605): Service-level agreements are often a critical component of an IT department’s documentation, as they define the expected service quality and performance metrics between the IT service provider and its clients or internal stakeholders. SLAs typically outline key aspects such as service availability, response times, resolution times, and performance benchmarks, ensuring that both parties have a clear understanding of the service expectations and responsibilities. Including SLAs in IT documentation is essential for setting measurable standards for service delivery, which helps in managing and meeting client expectations, identifying areas for improvement, and maintaining accountability. SLAs also serve as a reference point for resolving disputes and managing service-related issues, ensuring that services are delivered consistently and in alignment with business goals. Furthermore, SLAs provide a framework for regular performance reviews and enable continuous improvement by highlighting areas where service levels may need to be adjusted to meet changing requirements or to enhance overall service quality.
- [***Wireless survey***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_772)/[***heat map***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_293): Wireless surveys and heat maps are often integral components of the IT documentation in modern organizations, providing a detailed visual representation and analysis of wireless network coverage and performance across various locations. A wireless survey involves assessing the physical environment to identify optimal placement of wireless access points, detect signal interference, and measure signal strength and quality. The resulting heat maps visually depict these findings, using color gradients to represent signal strength, coverage areas, and potential dead zones, enabling IT professionals to pinpoint areas with weak or no signal and optimize the network layout accordingly. This documentation ensures that wireless networks are robust, providing reliable connectivity and bandwidth to meet the needs of users across different locations. It also serves as a critical tool for troubleshooting, network planning, and ensuring compliance with organizational policies and standards, helping to maintain a high-quality wireless infrastructure that supports efficient and uninterrupted business operations.

### Processes and Procedures

Thankfully, many important processes and procedures have become commonplace in networks today. While no one likes it when processes are overly complex due to “red tape,” well-defined and targeted initiatives can be revolutionary for organizations and their success. This section describes some of the most critical processes and procedures for your review.

#### Life-cycle Management

Your IT networking personnel should consider adhering to a well-planned [***life-cycle management***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_370) process for the equipment and software in use. The life cycle should provide valuable guidance on best practices throughout the organization concerning the network components.

Here are some examples of phases in a system life cycle:

- Conceptual design
- Preliminary system design
- Detail design and development
- Production and construction
- Utilization and support
- Phase-out ([***decommissioning***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_192))
- Disposal

Another important aspect of life-cycle management is understanding and adhering to the support announcements of vendors regarding their systems.

These announcements will often include (at the least) the following:

![](../images/key_topic_icon_158.jpg)

- [***End-of-life (EOL)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_248): The end-of-life status declared by a networking vendor for a product signifies that the product will no longer receive updates, support, or maintenance from the vendor. This status typically includes a timeline outlining the phases of discontinuation, such as the end of sales, end of new feature development, and the final date for support and security updates. EOL status alerts users to the necessity of planning for the transition to newer products or solutions, as continued use of EOL products may lead to increased security risks, lack of compatibility with new technologies, and potential operational disruptions. The vendor may also provide recommendations or pathways for upgrading to supported alternatives, ensuring continuity and improved performance within the network infrastructure.
- [***End-of-support (EOS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_249): The end-of-support status assigned by a networking vendor to a product indicates that the vendor will no longer provide technical support, updates, patches, or maintenance services for that product. Once a product reaches EOS, users will not receive security patches, bug fixes, or assistance with troubleshooting issues, which may lead to vulnerabilities and operational risks over time. EOS status prompts organizations to consider upgrading to newer, supported products to maintain security, compatibility, and optimal performance.

Networking personnel often consider the life cycle of software as part of their overall [***software management***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_642) processes and procedures. Considerations in this area typically include the following:

- [***Patches***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_481) and [***bug fixes***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_106): Patches and bug fixes are often essential components of software management, ensuring that applications and systems remain secure, stable, and efficient over time. Patches typically address security vulnerabilities, performance issues, or feature updates, protecting systems from potential threats and improving functionality. Bug fixes specifically resolve defects or malfunctions in the software, preventing errors and enhancing user experience. Regularly applying patches and bug fixes helps maintain software integrity, compliance with industry standards, and compatibility with other systems.
- [***Operating system (OS) updates***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_470): Operating system updates are another critical aspect of software management, providing essential enhancements, security improvements, and new features that ensure the overall health and functionality of the IT environment. These updates address vulnerabilities that could be exploited by malicious entities, fix bugs that may affect system performance or user experience, and offer compatibility updates to support new hardware and software. [Figure 13-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13fig02) shows the OS updates page of a Windows 11 system.

![](../images/13fig02.jpg)


**Figure 13-2** Operating System (OS) Updates

- [***Firmware updates***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_272): Firmware updates are another important element of software management, focusing on the underlying code that controls the hardware devices within a system. These updates are essential for enhancing device functionality, improving performance, and addressing security vulnerabilities that could otherwise compromise the hardware and the system as a whole. By keeping firmware up to date, organizations can ensure that their hardware operates efficiently, remains compatible with newer software, and supports the latest features and security protocols. [Figure 13-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13fig03) shows an example of updating the firmware on a network access point.


![](../images/13fig03.jpg)


**Figure 13-3** Firmware Updates

#### Change Management

Have you ever made a simple little change to a system and been horrified to see the entire solution self-destruct? It can happen, and because of this, you should ensure that there is a well-thought-out [***change management***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_132) program in place. This change management program should include a change control policy. You should also have a plan that includes the appropriate change management documentation. Often, it is necessary to make updates to existing documentation as part of the overall change management process.

[***Service requests***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_606) and [***request process tracking***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_552) are integral to modern networking change management systems, facilitating structured and transparent management of changes to network infrastructure. Service requests, initiated by users or IT staff, encompass a range of activities, from simple troubleshooting to significant network modifications. Request process tracking ensures that each request is logged, prioritized, and systematically managed through various stages, including approval, implementation, and post-implementation review. This systematic approach helps maintain clear communication, ensures accountability, and minimizes disruptions by assessing potential impacts and risks before changes are made. By providing a comprehensive audit trail and status updates, these systems enhance efficiency, reduce the likelihood of errors, and support the smooth and secure evolution of the network environment.

In short, change management can help ensure that your network keeps running in good health. It can also ensure that your documentation reflects the true and current state of the objects it is describing. This is very important for many aspects of your operations, including security responses and troubleshooting operations. Change management documentation often includes the following:

- A documented reason for a change
- The actual change request
- The approval process
- The required maintenance window
- The change notification process

#### Configuration Management

Today, [***configuration management***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_162) plays a crucial role in ensuring the stability, security, and scalability of network infrastructures. It involves the systematic management of configuration changes and settings across network devices, such as routers, switches, firewalls, and servers. This process is essential for maintaining consistency, reducing errors, and facilitating efficient troubleshooting and deployment.

When working with configuration management in the modern enterprise, we are often dealing with several different types of configurations, as follows:

![](../images/key_topic_icon_158.jpg)

- [***Production configurations***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_527): Production configurations refer to the current operational settings and parameters of network devices that are actively serving traffic and fulfilling their intended roles within the network. These configurations are carefully crafted to meet specific performance, security, and operational requirements. Network administrators use configuration management tools to deploy, monitor, and update production configurations while minimizing downtime and disruptions. Automated tools often play a crucial role here, ensuring that changes are applied consistently and according to established policies.
- [***Backup configurations***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_079): Backup configurations are copies of production configurations stored securely to facilitate disaster recovery, rollback procedures, and historical reference. These backups are typically scheduled regularly to capture changes and updates made to production configurations over time. Having reliable backups is essential for restoring network services in case of failures, human errors, or security incidents. Configuration management systems ensure that backups are current, complete, and easily accessible to authorized personnel.
- [***Baseline/golden configurations***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_086): A baseline or golden configuration represents standardized templates or ideal states of network device configurations that serve as benchmarks for comparison and consistency. These configurations are meticulously designed and documented to reflect best practices, security guidelines, and operational requirements. They are used as reference points for validating and aligning production configurations. When deviations occur or when updates are needed, network administrators can refer to these baseline configurations to ensure that changes are made in a controlled and compliant manner.

In practice, configuration management involves several key processes:

- **Configuration deployment:** New configurations or updates are deployed to network devices using automated tools to ensure consistency and minimize manual errors.
- **Configuration monitoring:** Continuous monitoring of configurations helps detect unauthorized changes, performance issues, or deviations from baseline configurations.
- **Change management:** Formalized processes govern how changes are proposed, reviewed, approved, and implemented to maintain stability and compliance.
- **Version control:** Keeping track of configuration versions enables rollback to previous states if changes lead to unexpected issues or failures.
- **Auditing and compliance:** Regular audits verify that configurations align with security policies, regulatory requirements, and operational standards.

### Real-World Case Study

Acme, Inc. has implemented several key improvements in its IT management practices, focusing on IP address management, service-level agreements, wireless surveys, and a more robust approach to life-cycle management for the hardware and software in use at Acme.

Acme recognizes the critical importance of efficient IP address management to streamline network operations and avoid IP conflicts. By adopting IPAM tools and processes, Acme now ensures the systematic allocation, tracking, and management of IP addresses across its network infrastructure. This approach not only enhances network reliability and scalability but also simplifies troubleshooting and enhances security by maintaining accurate IP address inventories.

Acme is now formalizing service-level agreements to define clear expectations and commitments between its IT department and internal stakeholders or external service providers. These SLAs establish benchmarks for performance, uptime, response times, and resolution targets for IT services. By aligning SLAs with business objectives, Acme aims to improve service delivery, accountability, and customer satisfaction while effectively managing expectations across the organization.

Recognizing the growing reliance on wireless connectivity, Acme has begun conducting thorough wireless surveys to optimize its Wi-Fi networks. These surveys assess signal strength, coverage areas, interference sources, and user experience metrics to ensure robust and reliable wireless connectivity throughout its facilities. By proactively addressing coverage gaps and performance issues identified through surveys, Acme enhances productivity and user satisfaction across its workforce.

Finally, Acme is adopting life-cycle management principles to systematically plan, procure, deploy, maintain, and retire IT assets and services. This approach ensures that IT resources are aligned with business needs throughout their lifespans, optimizing investments and minimizing disruptions. By proactively managing life cycles, Acme enhances cost-effectiveness, operational continuity, and technological agility in adapting to evolving business requirements.

### Summary

Here are the main topics covered in this chapter:

- This chapter described some of the most important elements of documentation related to modern networking. Examples of documentation included rack diagrams, physical diagrams, logical diagrams, and much more. Not only is it important to create such documentation, but it is also critical to ensure the documentation is periodically updated.
- This chapter also discussed life-cycle management and some of the important hardware and software milestones associated with such management. These milestones included end-of-life (EOL) and end-of-support (EOS).
- Finally, this chapter examined two related topics—change management and configuration management. The chapter defined each of these related disciplines and provided example components of each.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 13-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13tab01) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 13-1** Key Topics for [Chapter 13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| List | Typical types of network documentation | 326 |
| List | Vendor life-cycle announcement types | 330 |
| List | Types of configurations in configuration management | 333 |

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[asset inventory](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_01)

[backup configurations](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_02)

[baseline/golden configurations](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_03)

[bug fixes](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_04)

[cable maps](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_05)

[change management](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_06)

[configuration management](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_07)

[decommissioning](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_08)

[end-of-life (EOL)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_09)

[end-of-support (EOS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_010)

[firmware updates](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_011)

[hardware asset inventory](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_012)

[heat map](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_013)

[IP address management (IPAM)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_014)

[Layer 1 diagrams](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_015)

[Layer 2 diagrams](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_016)

[Layer 3 diagrams](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_017)

[licensing asset inventory](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_018)

[life-cycle management](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_019)

[logical diagrams](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_020)

[network diagrams](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_021)

[operating system (OS) updates](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_022)

[patches](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_023)

[physical diagrams](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_024)

[production configurations](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_025)

[rack diagrams](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_026)

[request process tracking](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_027)

[service-level agreement (SLA)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_028)

[service request](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_029)

[software asset inventory](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_030)

[software management](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_031)

[warranty support asset inventory](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_032)

[wireless survey](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#key_033)

### Additional Resources

**Redefine Your I.T. Strategy with Proper Hardware Lifecycle Management:** <https://www.youtube.com/watch?v=LhDJBtaEuR8>

**What Is Configuration Management?:** <https://www.redhat.com/en/topics/automation/what-is-configuration-management>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz13_1) What type of network diagram would focus on IP addresses and other network layer details?

1. Layer 1 network diagram
2. Layer 2 network diagram
3. Layer 3 network diagram
4. Layer 4 network diagram

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz13_2) What is the best definition of IPAM?

1. IPAM refers to the process of optimizing Internet Protocol usage through advanced monitoring.
2. IPAM refers to the systematic administration of IP addresses, ensuring efficient allocation, tracking, and maintenance within a network environment.
3. IPAM involves the physical management of network cables and their connections within a data center.
4. IPAM involves the automatic optimization of traffic flows based on specific quality of service (QoS) values.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz13_3) Which of the following is the best definition of a service-level agreement?

1. A formal contract between a service provider and a customer that outlines the agreed-upon level of performance.
2. A software tool that is used to monitor network performance.
3. The process of negotiating software updates and maintenance.
4. A popular hardware specification used in network design and configuration.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz13_4) EOS and EOL dates are often critical and are found primarily in what process discipline within IT?

1. Service-level agreements
2. Change management
3. Configuration management
4. Life-cycle management

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz13_5) What is often the last stage of a system life cycle used in a network?

1. Phase-out
2. Disposal
3. Support
4. Development

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz13_6) Which of the following is a predefined and standardized template or ideal state of configuration settings for hardware, software, or network devices?

1. Configuration deployment
2. Configuration monitoring
3. Version control
4. Baseline/golden configuration

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz13_7) Which are often integral components of the IT documentation in modern organizations, providing a detailed visual representation and analysis of wireless network coverage and performance across various locations? (Choose two.)

1. Wireless survey
2. IPAM
3. Layer 2 diagram
4. Heat map

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz13_8) Which of the following best describes a comprehensive record or database containing detailed information about all hardware, software, and resources within an organization’s IT infrastructure?

1. Request process tracking
2. Asset inventory
3. IPAM
4. Service requests