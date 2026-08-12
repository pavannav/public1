## Chapter 15

## Disaster Recovery

This chapter covers the following topics related to Objective 3.3 (Explain disaster recovery (DR) concepts) of the CompTIA Network+ N10-009 certification exam:

- [DR metrics](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15lev2sec2)

  - Recovery point objective (RPO)
  - Recovery time objective (RTO)
  - Mean time to repair (MTTR)
  - Mean time between failures (MTBF)
- DR sites

  - Cold site
  - Warm site
  - Hot site
- High-availability approaches

  - Active-active
  - Active-passive
- [Testing](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15lev2sec10)

  - Tabletop exercises
  - Validation tests

As we have alluded to elsewhere in this text, more and more traffic is flocking to our network infrastructures today. Networks were once relegated to the domain of data but now routinely carry voice and video traffic as well. These additional media types, as well as mission-critical data applications, need a network to be up and available for users.

It is likely that your telephone service has been unavailable much less often than your data network. Unfortunately, data networks have traditionally been less reliable than voice networks; however, today’s data networks often *are* voice networks, and this convergence has contributed to the increased demand for uptime. Unified voice services such as call control and communication gateways can be integrated into one or more network devices, leveraging the bandwidth available on the LAN and WAN.

In this chapter, we take a tour of key disaster recovery techniques and concepts. We also examine high availability and tools that can help ensure high availability in networks today.

### Foundation Topics

### High Availability

If a network switch or router stops operating correctly (meaning that a *network fault* occurs), communication through the network could be disrupted, resulting in the network becoming unavailable to its users. Therefore, network availability, called *uptime*, is a major design consideration. This consideration might, for example, lead you to add fault-tolerant devices and fault-tolerant links between those devices. This section discusses the measurement of high availability (HA) along with a number of high-availability design considerations.

#### High-Availability Measurement

The availability of a network is measured by its uptime during a year. For example, if a network has *five nines* availability, it is up 99.999% of the time, which translates to a maximum of 5 minutes of downtime per year. If a network has *six nines* availability (meaning it is up 99.9999% of the time), it is down less than 30 seconds per year.

As a designer, one of your goals is to select components, topologies, and features that maximize network *availability* within certain parameters (for example, a budget). Be careful not to confuse *availability* with *reliability*. A *reliable* network, for example, does not drop many packets, whereas an *available* network is up and operational.

#### DR Metrics

The [***mean time to repair (MTTR)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_404) is the average time required to fix a failed component and return it to production status. This is also sometimes called mean time to recovery.

[***Mean time between failures (MTBF)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_403) is the average amount of time that passes between hardware component failures, excluding time spent repairing components or waiting for repairs.

Another goal in your design might be to meet the requirements set forth in a service-level agreement (SLA). An SLA is an official commitment that exists between a service provider and a client. Aspects of the IT services provided—quality, availability, specific responsibilities—are agreed upon between the service provider and the service user. Strict SLAs are becoming increasingly common in networking today as more and more cloud services find their way into the IT landscape. A cloud provider is a specialized service provider, and a cloud consumer is the client.

Two other measures that an organization should consider are the [***recovery time objective (RTO)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_543) and the [***recovery point objective (RPO)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_542). These two measurements might sound the same, but they are very different measures:

- **RTO:** The RTO is the time in the future when you expect to restore availability after some failure (or even a disaster) has rendered your IT services unavailable. The RTO value is a very important measure of how long you expect the network to be down.
- **RPO:** As important as the RTO is the RPO, which is the point in time to which you can recover the network. For example, say that your network system failed at 4 p.m. last Monday. Your RPO might be for that very point in time. Sometimes, unfortunately, the RPO will not be the exact point of failure. This is often the case with database systems. For example, a failure might occur at 4 p.m. on a Monday, but you might only be able to recover to 11 a.m. that Monday. This gap in your data might be a result of your disaster recovery plans. Perhaps your backup design can only restore your systems to that 11 a.m. point. An organization must ensure it can accept a particular amount of potential data and service loss.

Note

The RPO is the amount of data that will be lost or will have to be re-entered because of network downtime. The RTO is the amount of time that can pass before the disruption begins to seriously impede normal business operations.

#### Fault-Tolerant Network Design

![](../images/key_topic_icon_158.jpg)

Fault tolerance is the capability of a component, system, or network to endure a failure. It is the capability to withstand a fault (failure) without losing data. This can be accomplished through the use of Redundant Array of Independent Disks (RAID), backups, and similar technologies.

Two important concepts to know when designing a fault-tolerant network are as follows:

- **Single points of failure:** If the failure of a single network device or link (for example, a switch, router, or WAN connection) would result in a network becoming unavailable, that single device or link is a potential single point of failure. To eliminate single points of failure from your design, you might include redundant links and redundant hardware. For example, some high-end Ethernet switches support two power supplies, and if one power supply fails, the switch continues to operate by using the backup power supply. Link redundancy, as shown in [Figure 15-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15fig01), can be achieved by using more than one physical link. If a single link between a switch and a router fails, the network would not go down because of the link redundancy that is in place.

![](../images/15fig01.jpg)


**Figure 15-1** Redundant Network with Single Points of Failure

- **No single points of failure:** A network without a single point of failure contains redundant network infrastructure components (for example, switches and routers). In addition, these redundant devices are interconnected with redundant links. Although a network host could have two network interface cards (NICs), each connecting to a different switch, such a design is rarely implemented because of the increased costs. Instead, as shown in [Figure 15-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15fig02), a network with no single points of failure in the backbone allows any single switch or router in the backbone to fail or any single link in the backbone to fail while maintaining end-to-end network connectivity.

![](../images/15fig02.jpg)


**Figure 15-2** Redundant Network with No Single Point of Failure

Approaches to fault-tolerant network design can be used together to increase a network’s availability even further.

Note

Creating multiple paths that data can take in a network is often simply termed *multipathing*. Routing protocols can make multiple paths very valuable to use since they can engage in equal-cost multipathing (ECMP). In fact, Enhanced Interior Gateway Routing Protocol (EIGRP) even provides the unique capability of load sharing between paths of unequal cost.

#### Hardware Redundancy

Having redundant route processors in a switch or router chassis improves the reliability of the chassis. If a multilayer switch has two route processors, for example, one of the route processors could be active, and the other route processor could be standing by to take over in the event that the active processor became unavailable.

An end system can have redundant NICs. There are two modes of NIC redundancy:

- [***Active-active***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_037): Both NICs are active at the same time, and each has its own MAC address. This makes troubleshooting more complex, while giving you slightly better performance than the active-passive approach.
- [***Active-passive***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_038): Only one NIC is active at a time. This approach allows the client to appear to have a single MAC address and IP address, even in the event of a NIC failure.

NIC redundancy is most often used in strategic network hosts, rather than in end-user client computers, because of the expense and administrative overhead incurred with redundant NIC configuration.

Note

Different vendors use different terms to refer to combining NICs for hardware redundancy. The two most commonly used terms are *network interface card (NIC) teaming* and *NIC bonding*.

Today, network engineers use the active-active and active-passive high-availability approaches with many other networking functions and components in addition to NICs. In fact, entire network sites might function in an active-active or active-passive type capacity. Generally, an active-active configuration is always preferable, but, again, the expense and administrative overhead of this configuration often make it infeasible to implement for your networking functions and components.

Another powerful method of hardware redundancy comes in the form of computer clustering. A computer cluster consists of a set of tightly connected computers that work together. In many respects, clients view them as a single system.

The servers in a cluster are usually connected to each other through fast local area networks, with each node running its own instance of an operating system. In most circumstances, all of the nodes use the same hardware and the same operating system, although in some setups, different operating systems—or even different hardware—can be used on each computer.

Computer clusters emerged as a result of the convergence of a number of computing trends, including the availability of low-cost microprocessors, high-speed networks, and software for high-performance distributed computing. Computer clusters have a wide range of applicability and deployment, ranging from small business clusters with a handful of nodes to some of the fastest supercomputers in the world.

The clustering approach has also made its way to networking devices themselves. For example, today it is not uncommon for large enterprises and data centers to feature clustered solutions for switches, routers, and firewalls.

#### Design Considerations for High-Availability Networks

When designing networks for high availability, it is important to consider the following questions:

![](../images/key_topic_icon_158.jpg)

- Where will module and chassis redundancy be used? Module redundancy provides redundancy within a chassis by allowing one module to take over in the event that a primary module fails. Chassis redundancy means having more than one chassis, thus providing a path from the source to the destination even in the event of a chassis or link failure.
- What software redundancy features are appropriate?
- What protocol characteristics affect design requirements?
- What redundancy features should be used to provide power to an infrastructure device—for example, using an *uninterruptible power supply (UPS)*, a *generator*, or dual power supplies?
- What redundancy features should be used to maintain environmental conditions (for example, dual air-conditioning units)?
- Will dual circuits be provided in the event of a loss of connection with one of the circuits?
- What backup strategy exists for infrastructure and user data? The main backup strategies are as follows:

  - **Full:** A full backup is a backup of all of the data set. Although this is the safest and most comprehensive way to ensure data availability, it can be time-consuming and costly.
  - **Incremental:** An incremental backup backs up only data that has changed since the previous incremental backup. An incremental backup is incomplete for full recovery without a valid full backup and all incremental backups since the last full backup.
  - **Differential:** A differential backup is similar to an incremental backup in that it starts with a full backup, and then subsequent backups contain only data that has changed. The difference is that whereas an incremental backup only includes the data that has changed since the previous backup, a differential backup contains all of the data that has changed since the last full backup.
  - **Snapshots:** A snapshot is a read-only copy of a data set that is frozen in a point in time. This type of backup is often used with virtual machines and file system objects.
- What backup strategy exists for your network devices (both software images and configurations)? Are you backing up the system state information and configuration information from these devices?

#### High-Availability Best Practices

The following are the five best practices for designing high-availability networks:

![](../images/key_topic_icon_158.jpg)

- Examine technical goals.
- Identify the budget for funding high-availability features.
- Categorize business applications into profiles, each of which requires a certain level of availability.
- Establish performance standards for high-availability solutions.
- Define how to manage and measure the high-availability solution.

Although existing networks can be retrofitted to make them highly available, network designers can often reduce expenses by integrating high-availability best practices and technologies into the initial design of a network.

#### Content Caching

A *content engine* is a network appliance that can receive a copy of content stored elsewhere (for example, a video presentation located on a server at a corporate headquarters) and serve that content to local clients, thus reducing the bandwidth burden on an IP WAN. [Figure 15-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15fig03) shows a sample topology using a content engine as a network optimization technology.

![](../images/15fig03.jpg)


**Figure 15-3** Content Engine Sample Topology

#### Load Balancing

*Content switching* allows a request coming into a server farm to be distributed across multiple servers containing identical content. This approach to *load balancing* lightens the load on individual servers in a server farm and allows servers to be taken out of the farm for maintenance without disrupting access to the server farm’s data. [Figure 15-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15fig04) illustrates a sample content-switching topology that performs load balancing across five servers (containing identical content) in a server farm.

![](../images/15fig04.jpg)


**Figure 15-4** Content-Switching Sample Topology

#### Hardware Redundancy

It is possible to design site redundancy into your network infrastructure. Doing so requires redundant data and equipment located in geographically distant areas. How fast can your IT infrastructure be back up and running in the event that issues arise in your primary site? The following disaster recovery (DR) site options are possible:

- [***Cold site***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_153): A cold site is a disaster recovery location equipped with basic infrastructure but without the necessary hardware and data. Recovery is possible but is difficult and time-consuming. A cold site is the weakest of the recovery site options but also the least costly. However, keep in mind that although a cold site may be the least costly when you’re planning for disaster, after a disaster occurs, equipment purchased for a cold site might be expensive or difficult to obtain.
- [***Warm site***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_759): A warm site is a backup location that is partially equipped with infrastructure and systems, allowing for a quicker recovery than a cold site but requiring some additional setup before becoming fully operational. Recovery is possible fairly quickly, but the site might not have the resources and responsiveness of the original site. A warm site is a scaled-down version of a hot site. The recovery site is often only configured with power, phone, and network jacks. It may have computers and other resources, but they are not configured and ready to go.
- [***Hot site***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_300): This type of site is most expensive, and it functions like the original site and is equipped with all necessary hardware, software, network, and Internet connectivity fully installed, configured, and ready to go. Downtime is minimal, with a service level nearly identical to that of the organization’s main site.

Note

Today, thanks to advancements in public cloud computing, *cloud sites* are also possible. You can configure cloud sites as cold, warm, or hot sites, typically with ease. This is due to the lowered costs and technological requirements made possible by cloud.

#### Testing

When designing high-availability and disaster recovery solutions, you should always consider a thorough *testing* phase. Common types of testing include:

- [***Tabletop exercises***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_677): Tabletop exercises are simulated, discussion-based sessions used to test and evaluate an organization’s disaster recovery plans. During these exercises, key stakeholders and team members gather to walk through hypothetical disaster scenarios, such as cyberattacks, natural disasters, or system failures, and discuss their roles, responsibilities, and responses. The goal is to identify strengths and weaknesses in the DR plan, ensuring that everyone understands the procedures and can effectively communicate and collaborate during an actual disaster. These exercises provide a safe environment to practice decision-making, improve preparedness, and refine the DR strategies, ultimately enhancing the organization’s resilience and ability to recover swiftly from disruptive events.
- [***Validation tests***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_735): Validation tests are crucial steps in the testing process of a new disaster recovery solution, designed to ensure that the solution meets all specified requirements and functions as intended. These tests involve systematically verifying each component of the DR plan, including data backup and restoration processes, failover procedures, and system recovery capabilities. By simulating various disaster scenarios and operational conditions, validation tests help identify any gaps, inefficiencies, or potential points of failure in the DR solution. The insights gained from these tests allow organizations to fine-tune their DR strategies, ensuring robust performance and reliability. Ultimately, validation tests provide confidence that the new DR solution can effectively protect and recover critical data and systems in the event of an actual disaster.

### Real-World Case Study: Network Design

If you have read all the chapters before this one, you have learned to design an amazingly powerful network that includes redundancy and DR features. While this book does not focus on network design specifically, this case study allows you to practice with this valuable skill. Because network design is part science and part art, multiple designs can meet the specified requirements. However, as a reference, this section presents one solution, against which you can contrast your solution.

While working through your design, consider the following:

- Meeting all requirements
- Media distance limitations
- Network device selection
- Environmental factors
- Compatibility with existing and future equipment

#### Case Study Scenario

The following are the design scenario and criteria for this case study:

- Company ABC leases two buildings (building A and building B) in a large office park, as shown in [Figure 15-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15fig05). The office park has a conduit system that allows physical media to run between buildings. The distance (via the conduit system) between building A and building B is 1 km.
- Company ABC will use the Class B address 172.16.0.0/16 for its sites. You should subnet this classful network not only to support the two buildings (one subnet per building) but also to allow as many as five total sites in the future, as Company ABC continues to grow.
- Company ABC needs to connect to the Internet, supporting a speed of at least 30Mbps, and this connection should come into building A.
- Cost is a primary design consideration, and performance is a secondary design consideration.
- Each building contains various Wi-Fi client devices (for example, smartphones, tablets, and laptops).

[Table 15-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15tab01) identifies the number of hosts contained in each building and the number of floors in each building.

**Table 15-1** Case Study Information for Buildings A and B

| Building | Number of Hosts | Floors (and Wireless Coverage) |
| --- | --- | --- |
| A | 200 | Three floors, each of which can be serviced by a single wireless access point |
| B | 100 | One floor, which can be serviced by a single wireless access point |


![](../images/15fig05.jpg)


**Figure 15-5** Case Study Topology

Your design should include the following information:

- Network address and subnet mask for building A
- Network address and subnet mask for building B
- Layer 1 media selection
- Layer 2 device selection
- Layer 3 device selection
- Wireless design
- Any design elements based on environmental considerations
- An explanation of where cost savings were created from performance trade-offs
- A topological diagram of the proposed design

Use multiple sheets of paper to create your network design. After your design is complete, perform a sanity check by contrasting the listed criteria against your design. Finally, while keeping in mind that multiple designs could meet the design criteria, you can review the following suggested solution. In the real world, reviewing the logic behind other designs can often give you a fresh perspective for future designs.

#### Suggested Solution

This suggested solution begins with IP address allocation. Then, consideration is given to the Layer 1 media, followed by Layer 2 and Layer 3 devices. Wireless design decisions are presented. Design elements based on environmental factors are discussed. The suggested solution also addresses how cost savings were achieved through performance trade-offs. Finally, a topological diagram of the suggested solution is presented.

#### IP Addressing

Questions you might need to consider when designing the IP addressing of a network include the following:

- How many hosts do you need to support (now and in the future)?
- How many subnets do you need to support (now and in the future)?

From the scenario, you know that each subnet must accommodate at least 200 hosts. Also, you know that you must accommodate at least 5 subnets. In this solution, the subnet mask is based on the number of required subnets. Eight subnets are supported with 3 borrowed bits, and 2 borrowed bits support only 4 subnets, based on this formula:

Number of subnets = 2*s*

where *s* is the number of borrowed bits.

With 3 borrowed bits, you have 13 bits left for host IP addressing, which is much more than needed to accommodate 200 host IP addresses. These 3 borrowed bits yield the subnet mask 255.255.224.0. Because the third octet is the last octet to contain a binary 1 in the subnet mask, the third octet is the *interesting octet*.

The block size can be calculated by subtracting the subnet decimal value in the interesting octet from 256 (that is, 256 – 224 = 32). Because the block size is 32 and the interesting octet is the third octet, the following subnets are created with the 255.255.224.0 (that is, /19) subnet mask:

172.16.0.0 /19

172.16.32.0 /19

172.16.64.0 /19

172.16.96.0 /19

172.16.128.0 /19

172.16.160.0 /19

172.16.192.0 /19

172.16.224.0 /19

The first two subnets are selected for the building A and building B subnets, as shown in [Table 15-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15tab02).

**Table 15-2** Case Study Suggested Solution: Network Addresses

| Building | Subnet |
| --- | --- |
| A | 172.16.0.0 /19 |
| B | 172.16.32.0 /19 |

#### Layer 1 Media

Questions you might need to ask when selecting the Layer 1 media types of a network include the following:

- What speeds need to be supported (now and in the future)?
- What distances between devices need to be supported (now and in the future)?

Within each building, Category 6a (Cat 6a) unshielded twisted-pair (UTP) cabling is selected to interconnect network components. The installation is based on Gigabit Ethernet. However, 10-Gigabit Ethernet devices may be installed in the future, as Cat 6a is rated for 10GBASE-T for distances as long as 100 m.

The 1 km distance between building A and building B is too great for UTP cabling. Therefore, multimode fiber (MMF) is selected. The speed of the fiber link will be 1Gbps. [Table 15-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15tab03) summarizes these media selections.

**Table 15-3** Case Study Suggested Solution: Layer 1 Media

| Connection Type | Media Type |
| --- | --- |
| LAN links within buildings | Cat 6a UTP |
| Link between building A and building B | MMF |

#### Layer 2 Devices

Questions you might need to consider when selecting Layer 2 devices in a network include the following:

- Where will the switches be located?
- What port densities are required on the switches (now and in the future)?
- What switch features need to be supported (for example, STP or LACP)?
- What media types are used to connect to the switches?

A collection of Ethernet switches interconnects network devices within each building. Assume that the 200 hosts in building A are distributed relatively evenly across the three floors (with each floor containing approximately 67 hosts). Therefore, each floor will have a wiring closet containing two Ethernet switches: a 48-port switch and a 24-port switch. Each switch is connected to a multilayer switch located in building A using four connections logically bundled together using LACP.

Note

Link aggregation is also known as *port aggregation*.

Within building B, two Ethernet switches with 48 ports each and one Ethernet switch with 24 ports are installed in a wiring closet. These switches are interconnected in a stacked configuration, using four connections logically bundled together with LACP. One of the switches has an MMF port, which allows it to connect via fiber to building A’s multilayer switch.

[Table 15-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15tab04) summarizes the switch selections.

**Table 15-4** Case Study Suggested Solution: Layer 2 Devices

| Building | Quantity of 48-Port Switches | Quantity of 24-Port Switches |
| --- | --- | --- |
| A | 3 | 3 |
| B | 2 | 1 |

#### Layer 3 Devices

Questions you might need to consider when selecting Layer 3 devices for a network include the following:

- How many interfaces are needed (now and in the future)?
- What types of interfaces need to be supported (now and in the future)?
- What routing protocol (or protocols) needs to be supported?
- What router features (for example, HSRP or security features) need to be supported?

One Layer 3 device is used: a multilayer switch located in building A. All switches within building A home back to the multilayer switch using four LACP-bundled links. The multilayer switch is equipped with at least one MMF port, which allows a connection with one of the Ethernet switches in building B. The multilayer switch connects to a router via a 10Gbps Ethernet connection. This router contains a serial interface, which connects to the Internet via a T3 connection.

#### Wireless Design

Questions you might need to consider when designing the wireless portion of a network include the following:

- What wireless speeds need to be supported (now and in the future)?
- What distances need to be supported between wireless devices and wireless access points (now and in the future)?
- What IEEE wireless standards need to be supported?
- What channels should be used?
- Where should wireless access points be located?

Because the network needs to support various Wi-Fi clients, the 2.4GHz band is chosen. Within building A, a wireless access point (AP) is placed on each floor of the building. To avoid interference, the non-overlapping channels 1, 6, and 11 are chosen. The 2.4GHz band also allows compatibility with IEEE 802.11ac/ax.

Within building B, a single wireless AP accommodates Wi-Fi clients. [Table 15-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15tab05) summarizes the wireless AP selection.

**Table 15-5** Case Study Suggested Solution: Wireless AP Selection

| AP Identifier | Building | Band | Channel |
| --- | --- | --- | --- |
| 1 | A (1st floor) | 2.4GHz | 1 |
| 2 | A (2nd floor) | 2.4GHz | 6 |
| 3 | A (3rd floor) | 2.4GHz | 11 |
| 4 | B | 2.4GHz | 1 |

#### Environmental Factors

Questions you might need to consider when considering environmental factors of a network design include the following:

- What temperature or humidity controls exist in the rooms containing network equipment?
- What power redundancy systems are needed to provide power to network equipment in the event of a power outage?

Because the multilayer switch in building A could be a single point of failure for the entire network, the multilayer switch is placed in a well-ventilated room, which can help dissipate heat in the event of an air-conditioning failure. To further enhance the availability of the multilayer switch, the switch is connected to a UPS, which can help the multilayer switch continue to run for a brief time in the event of a power outage. Protection against an extended power outage could be achieved with the addition of a generator. However, no generator is included in this design for budgetary reasons.

Note

Other common considerations in this area include the use of *power distribution units (PDUs)*, which are devices fitted with multiple outputs designed to distribute electric power. *Heating, ventilation, and air-conditioning (HVAC)* and *fire suppression systems* should also be analyzed to determine their power needs.

#### Cost Savings Versus Performance

When assimilating all the previously gathered design elements, you need to weigh budgetary constraints against network performance metrics. In this example, Gigabit Ethernet was chosen over 10-Gigabit Ethernet. In addition, the link between building A and building B could become a bottleneck because it runs at a speed of 1Gbps, although it transports an aggregation of multiple 1Gbps links. However, cost savings are achieved by using 1Gbps switch interfaces as opposed to 10Gbps interfaces or a bundle of multiple 1Gbps fiber links.

#### Topology

[Figure 15-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15fig06) shows the topology of the proposed design based on design decisions described in this section.

![](../images/15fig06.jpg)


**Figure 15-6** Case Study Proposed Topology

### Summary

Here are the main topics covered in this chapter:

- This chapter discussed network availability, including how availability is measured and can be achieved through redundant designs.
- This chapter discussed performance optimization strategies, including the use of content caching, link aggregation, and load balancing.
- This chapter included a case study that challenged you to design a network to meet a collection of criteria.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 15-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15tab06) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 15-6** Key Topics for [Chapter 15](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#ch15)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| Section | Fault-Tolerant Network Design | 365 |
| List | Design considerations for high-availability networks | 368 |
| List | High-availability best practices | 369 |

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[active-active](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#key_01)

[active-passive](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#key_02)

[cold site](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#key_03)

[hot site](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#key_04)

[mean time between failures (MTBF)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#key_05)

[mean time to repair (MTTR)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#key_06)

[recovery point objective (RPO)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#key_07)

[recovery time objective (RTO)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#key_08)

[tabletop exercises](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#key_09)

[validation tests](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#key_010)

[warm site](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#key_011)

### Additional Resources

**High Availability/Disaster Recovery (HA/DR) Basics:** <https://www.youtube.com/watch?v=cIPunZYEZHU>

**What’s the Difference Between RTO and RPO?:** <https://www.rubrik.com/insights/rto-rpo-whats-the-difference>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz15_1) If a network has five nines availability, how much downtime does it experience per year?

1. 30 seconds
2. 5 minutes
3. 12 minutes
4. 26 minutes

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz15_2) What mode of NIC redundancy has only one NIC active at a time?

1. Publisher-subscriber
2. Client-server
3. Active-passive
4. Active-subscriber

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz15_3) What performance optimization technology involves a network appliance that can receive a copy of content stored elsewhere (for example, a video presentation located on a server at a corporate headquarters) and serves that content to local clients, thus reducing the bandwidth burden on an IP WAN?

1. Content engine
2. Load balancer
3. LACP
4. CARP

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz15_4) What type of backup solution is a point-in-time, read-only copy of data?

1. Differential
2. Incremental
3. Snapshot
4. Virtual

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz15_5) What type of site provides a nearly identical level of service to the organization’s main site, with virtually no downtime?

1. Warm
2. Cold
3. Hot
4. Remote

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz15_6) What capability of routing protocols allows them to help you use the bandwidth that you might have available in a multipathing design?

1. ECMP
2. Distance vector
3. Link state
4. Dual stack

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz15_7) In order to measure high availability, you need to know the average amount of time that passes between hardware component failures. What is this called?

1. MTTR
2. RPO
3. RTO
4. MTBF

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz15_8) You are tasked with locating a backup facility for your organization to use in the event of a disaster. You have a slim budget, and the facility needs to include electricity, bathrooms, and space. Which type of recovery site suits your requirements?

1. Hot site
2. Cold site
3. Warm site
4. Cloud site

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz15_9) Which of the following statements are true regarding backups? (Select three.)

1. The difference between incremental and differential backups is that a differential backup includes all data that has changed since the last incremental backup.
2. A differential backup includes all data that has changed since the last full backup.
3. An incremental backup is incomplete for full recovery without a full backup and all incremental backups since the last full backup.
4. A full backup is the safest and most comprehensive way to ensure data availability, but it can be time-consuming and costly.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz15_10) In which disaster recovery setup are multiple redundant systems simultaneously active and operational and able to serve incoming requests?

1. Active-passive
2. Clustering mode
3. Load balancer mode
4. Active-active

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz15_11) Which of the following are simulated, discussion-based sessions used to test and evaluate an organization’s disaster recovery plans?

1. Validation tests
2. Tabletop exercises
3. RPO testing
4. RTO testing