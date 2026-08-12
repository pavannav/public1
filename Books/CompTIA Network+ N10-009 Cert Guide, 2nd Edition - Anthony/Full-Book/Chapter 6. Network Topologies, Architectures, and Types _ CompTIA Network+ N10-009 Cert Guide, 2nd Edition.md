## Chapter 6

## Network Topologies, Architectures, and Types

This chapter covers the following topics related to Objective 1.6 (Compare and contrast network topologies, architectures, and types) of the CompTIA Network+ N10-009 certification exam:

- Mesh
- Hybrid
- Star/hub and spoke
- [Spine and leaf](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06lev2sec19)
- [Point to point](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06lev2sec11)
- [Three-tier hierarchical model](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06lev1sec6)

  - [Core](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06lev2sec18)
  - [Distribution](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06lev2sec17)
  - Access
- Collapsed core
- [Traffic flows](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06lev2sec20)

  - North-south
  - East-west

What comes to mind when you think of a computer network? Is it the Internet? Is it email? Is it the wireless connection that lets you print to your printer from your laptop? Is it the smart thermostat and lights in your home?

Whatever your current perception of a computer network, this chapter just might help you expand your thought process in this regard. Be aware that although you think of computer networks as interconnecting computers, today’s computer networks interconnect a variety of devices in addition to just computers. Examples include game consoles, video-surveillance devices, IP-based telephones, tablets, and smartphones. Therefore, throughout this book, think of the term *computer network* as being synonymous with the more generic term *network*, because these terms are used interchangeably.

The goal of this chapter is to acquaint you with the purpose of a network and help you categorize a given network based on criteria such as geography, topology, and the location of the network’s resources.

### Foundation Topics

### Defining a Network

The movie *Field of Dreams* featured the statement “If you build it, he will come.” This statement most certainly applies to the evolution of network-based services in modern-day networks. Computer networks are no longer relegated to allowing a group of computers to access a common set of files stored on a computer chosen as a *file server*. Instead, with the building of high-speed, highly redundant networks, network architects are seeing the wisdom of placing a variety of traffic types on a single network. Examples include voice and video, in addition to data. As you will learn in this chapter, the Internet of Things (IoT) means that just about everything wants to join your network, from the lights in your home to many of your household appliances.

One could argue that a network is the sum of its parts. So, as you begin your study of networking, you should start to gain a basic understanding of fundamental networking components, including such entities as the client, server, hub, switch, and router, as well as the media used to interconnect these devices.

#### The Purpose of Networks

The basic purpose of a network is to make connections. These connections might be between a PC and a printer or between a laptop and the Internet, as just a couple of examples. However, the true value of a network comes from the traffic flowing over those connections. Consider a sampling of applications that can travel over a network’s connections:

- File sharing between two computers
- Video chatting between computers located in different parts of the world
- Surfing the Web (for example, to use social media sites, watch streaming video, listen to an Internet radio station, or do research for a school term paper)
- Instant messaging (IM) between computers with IM software installed
- Email
- Voice over IP (VoIP), to replace traditional telephony systems

A term given to a network transporting multiple types of traffic (for example, voice, video, and data) is a *converged network*. A converged network might offer significant cost savings to organizations that previously supported separate network infrastructures for voice, data, and video traffic. This convergence also potentially reduces staffing costs because only a single network needs to be supported, rather than separate networks for separate traffic types.

### Network Types and Characteristics

As you might be sensing at this point, not all networks look the same. They vary in many ways. One criterion by which networks are classified is how geographically dispersed the network’s components are. For example, a network might interconnect devices within an office, or a network might interconnect a database at a corporate headquarters location with a remote sales office on the opposite side of the globe.

Based on the geographic dispersion of network components, you can classify networks into various categories, including the following:

- Local area network (LAN)
- Wide area network (WAN)
- Wireless local area network (WLAN)
- Storage area network (SAN)
- Campus area network (CAN)
- Metropolitan area network (MAN)
- Personal area network (PAN)

#### LAN

A LAN interconnects network components within a local area (for example, within a building). Examples of common LAN technologies you are likely to meet include Ethernet (that is, IEEE 802.3) and wireless networks (that is, IEEE 802.11). [Figure 6-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig01) illustrates an example of a LAN.

![](../images/06fig01.jpg)


**Figure 6-1** Sample LAN Topology

Note

IEEE stands for *Institute of Electrical and Electronics Engineers*, which is an internationally recognized standards body.

#### WAN

A WAN interconnects network components that are geographically separated. For example, a corporate headquarters might have multiple WAN connections to remote office sites. Multiprotocol Label Switching (MPLS) and Asynchronous Transfer Mode (ATM) are examples of WAN technologies. [Figure 6-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig02) depicts a simple WAN topology, which interconnects two geographically distant locations.

![](../images/06fig02.jpg)


**Figure 6-2** Sample WAN Topology

#### WLAN

A local area network made up of wireless networking devices is a wireless local area network (WLAN).

#### SAN

You can construct a high-speed, highly reliable network for the express purpose of transmitting stored data. This network is called a storage area network (SAN).

#### Other Categories of Networks

Although LAN and WAN are the most common terms used to categorize computer networks based on geography, other categories include campus area network (CAN), metropolitan area network (MAN), and personal area network (PAN).

##### CAN

The first time I discovered a CAN-type topology was at a major university. The university covered several square miles and had several dozen buildings. Many of these buildings were running individual LANs, and these building-centric LANs were interconnected. The interconnection of these LANs created another network type: a campus area network (CAN). Besides being common on university campuses, CANs are often used in industrial parks and business parks.

##### MAN

More widespread than a CAN and less widespread than a WAN, a metropolitan area network (MAN) is a network that spans a defined geographic location, such as a city or suburb. It interconnects locations scattered throughout a metropolitan area. Imagine, for example, that a business in Chicago has a location near O’Hare Airport, another location near the Navy Pier, and another location in the Willis Tower (previously known as the Sears Tower). If a service provider could interconnect those locations using a high-speed network, such as a 10Gbps (that is, 10 billion bits per second) network, the interconnection of those locations would form a MAN. One example of a MAN technology is Metro Ethernet, which features much higher speeds than the traditional WAN technologies that were used in the past to connect such locations.

##### PAN

A personal area network (PAN) is a network whose scale is even smaller than a LAN. For example, a connection between a PC and a digital camera via a universal serial bus (USB) cable could be considered a PAN. Another example is a PC connected to an external hard drive via a USB 3.0 or Thunderbolt connection. A PAN, however, is not necessarily a wired connection. A Bluetooth connection between your cell phone and your car’s audio system is considered a wireless PAN (WPAN). The main distinction of a PAN is that its range is typically limited to just a few meters.

### Networks Defined Based on Resource Location

Another way to categorize networks is based on where the network resources reside. For example, a *client/server network* is a collection of PCs all sharing files stored on a centralized server. However, if those PCs had their operating system (for example, Microsoft Windows 11 or macOS) configured for file sharing, they could share files from one another’s hard drives. This is referred to as a *peer-to-peer network* because the peers (the PCs in this example) make resources available to other peers. The following sections describe client/server and peer-to-peer networks in more detail.

#### Client/Server Networks

[Figure 6-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig03) illustrates an example of a *client/server network*, where a dedicated file server gives shared access to files, and a networked printer is available as a resource to the network’s clients. Client/server networks are commonly used by businesses. Because resources are found on one or more servers, administration is simpler than administration of network resources on multiple peer devices.

![](../images/06fig03.jpg)


**Figure 6-3** Client/Server Network Example

The performance of a client/server network can be better than that of a peer-to-peer network because resources can be located on dedicated servers rather than on a PC running a variety of end-user applications. You can simplify backups because fewer locations must be backed up. However, client/server networks come with the extra expense of dedicated server resources. [Table 6-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06tab01) lists the benefits and drawbacks of client/server networks.


**Table 6-1** Characteristics, Benefits, and Drawbacks of Client/Server Networks

| Characteristics | Benefits | Drawbacks |
| --- | --- | --- |
| Client devices (for example, PCs) share a common set of resources (for example, file or print resources) located on one or more dedicated servers. | Client/server networks can easily scale, which might require the purchase of additional client licenses. | Because multiple clients might rely on a single server for their resources, the single server can become a single point of failure in the network. |
| Resource sharing is made possible via dedicated server hardware and network operating systems. | Administration is simplified because parameters such as file-sharing permissions and other security settings can be administered on a server as opposed to on multiple clients. | Client/server networks can cost more than peer-to-peer networks. For example, client/server networks might require the purchase of dedicated server hardware and a network OS with an appropriate number of licenses. |

Note

A server in a client/server network could be a computer running a network operating system (NOS) such as Linux Server or one of the Microsoft Windows Server operating systems. Alternatively, a server might be a host making its file system available to remote clients via the Network File System (NFS) service, which was originally developed by Sun Microsystems.

Note

A variant of the traditional server in a client/server network, where the server provides shared file access, is network-attached storage (NAS). A NAS device is a mass storage device that attaches directly to a network. It typically has an array of disks providing network storage capacity to the users on the network. It is a specialized file-level computer storage device connected to a network. Rather than running an advanced NOS, a NAS device usually makes files available to network clients via a service such as NFS. If the NAS sounds familiar, it is because you learned about it back in [Chapter 2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02), “[Networking Appliances, Applications, and Functions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02).”

#### Peer-to-Peer Networks

*Peer-to-peer networks* allow interconnected devices (for example, PCs) to share their resources with one another. Those resources could be, for example, files or printers. As an example of a peer-to-peer network, consider [Figure 6-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig04), where each of the peers can share files on its own hard drive, and one of the peers has a directly attached printer that can be shared with the other peers in the network.

![](../images/06fig04.jpg)


**Figure 6-4** Peer-to-Peer Network Example

Peer-to-peer networks tend to be used in smaller businesses and in homes. The popularity of peer-to-peer networks is fueled in part by client operating systems that support file and print sharing. Scalability for peer-to-peer networks is a concern, however. Specifically, as the number of devices (that is, peers) increases, the administration burden increases. For example, a network administrator might have to manage file permissions on multiple devices, as opposed to on a single server. [Table 6-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06tab02) lists the characteristics, benefits, and drawbacks of peer-to-peer networks.

**Table 6-2** Characteristics, Benefits, and Drawbacks of a Peer-to-Peer Network

| Characteristics | Benefits | Drawbacks |
| --- | --- | --- |
| Client devices (for example, PCs) share their resources (for example, file and printer resources) with other client devices. | Peer-to-peer networks can be installed easily because resource sharing is made possible by the clients’ operating systems, and knowledge of advanced networking operating systems is not required. | Scalability is limited because of the increased administration burden of managing multiple clients. |
| Resource sharing is made available through the clients’ operating systems. | Peer-to-peer networks usually cost less than client/server networks because there is no requirement for dedicated server resources or advanced NOS software. | Performance might not be as strong as in a client/server network because the devices providing network resources might be performing other tasks not related to resource sharing (for example, word processing). |


Note

Some networks have characteristics of both peer-to-peer and client/server networks. For example, all PCs in a company might point to a centralized server for accessing a shared database in a client/server topology. However, these PCs might simultaneously share files and printers with one another in a peer-to-peer topology.

#### Cloud Networking

While we covered cloud networking in [Chapter 3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03), “[Cloud Concepts](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#ch03),” it is worth a reminder here in this chapter. Remember that it is quite common for businesses today to be engaged in cloud computing for some or all of their networking needs. Virtual private clouds (VPCs) are logical topologies made available to these businesses in the public cloud. The IT staff can use these VPCs to host their own cloud-based networking solutions.

### Networks Defined by Topology

In addition to classifying networks based on the geographic placement of their components, another approach to classifying a network is to use the network’s topology. Looks can be deceiving, however. You need to be able to distinguish between a physical topology and a logical topology.

#### Physical Versus Logical Topology

Even if a network appears to be a star topology (that is, where the network components all connect to a centralized device, such as a switch), the traffic might be flowing in a circular pattern through all the network components attached to the centralized device. The actual traffic flow determines the *logical topology*, whereas the way components are physically interconnected determines the *physical topology*.

For example, consider [Figure 6-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig05), which shows a collection of computers connected to a legacy Token Ring media access unit (MAU). From a quick inspection of [Figure 6-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig05), you can conclude that the devices are physically connected in a star topology, where the connected devices radiate out from a centralized aggregation point (the MAU in this example).

![](../images/06fig05.jpg)


**Figure 6-5** Physical Star Topology

Now contrast the physical topology in [Figure 6-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig05) with the logical topology illustrated in [Figure 6-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig06). Although you can see that the computers physically connect to a centralized MAU, when you examine the flow of traffic through (or in this case, around) the network, you see that the traffic flow actually loops around and around the network. The traffic flow dictates how to classify a network’s logical topology. In this instance, the logical topology is a *ring topology* because the traffic circulates around the network as if circulating around a ring.

![](../images/06fig06.jpg)


**Figure 6-6** Logical Ring Topology

Note

Before you run out and try to purchase a Token Ring network for your LAN, keep in mind that you’ll only see this technology in networking museums now!

#### Point-to-Point Topology

Let’s begin with the simplest of all network topologies, it’s the point-to-point network. A [***point-to-point network topology***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_500) involves a direct connection between two network nodes, facilitating exclusive communication between them. This simple and straightforward setup is commonly used for dedicated communications where security and speed are paramount, such as in leased lines or private network connections. In this topology, the communication link is dedicated to the two connected devices, minimizing latency and maximizing data transfer speeds.

Point-to-point connections are ideal for scenarios requiring reliable, high-speed, and secure data transmission, such as in data center interconnects or between network devices that handle sensitive information. However, they can be less scalable and more expensive compared to other topologies, as each new connection requires additional hardware and infrastructure.

#### Star Topology

[Figure 6-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig07) shows a sample [***star topology***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_653) with a hub at the center of the topology and a collection of clients individually connected to the hub. Notice that a star topology has a central point from which all attached devices radiate. In LANs in the early 1990s, that centralized device was typically a hub. Modern networks, however, usually have a switch located at the center of the star.

![](../images/06fig07.jpg)


**Figure 6-7** Star Topology

The star topology is the most popular physical LAN topology in use today, with an Ethernet switch at the center of the star and unshielded twisted-pair (UTP) cable used to connect from the switch ports to clients.

[Table 6-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06tab03) identifies some of the primary characteristics, benefits, and drawbacks of a star topology.

![](../images/key_topic_icon_158.jpg)


**Table 6-3** Characteristics, Benefits, and Drawbacks of a Star Topology

| Characteristics | Benefits | Drawbacks |
| --- | --- | --- |
| Devices have independent connections to a central device (for example, a hub or a switch). | A cable break impacts only the device connected via the broken cable and not the entire topology. | More cable is required for a star topology because each device requires its own cable to connect back to the central device. |
| Star topologies are commonly used with Ethernet technologies (described in [Chapter 5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05), “[Transmission Media and Transceivers](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05)”). | Troubleshooting is relatively simple because a central device in the star topology acts as the aggregation point for all the connected devices. | Installation can take longer for a star topology because more cable runs must be installed. |

#### Hub-and-Spoke Topology

When interconnecting multiple sites (for example, multiple corporate locations) via WAN links, a [***hub-and-spoke topology***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_302) may be used, with a WAN link from each remote site (that is, a *spoke site*) to the main site (that is, the *hub site*). This approach, an example of which is shown in [Figure 6-8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig08), is similar to the star topology used in LANs.

![](../images/06fig08.jpg)


**Figure 6-8** Hub-and-Spoke Topology

With WAN links, a service provider is paid a recurring fee for each link. Therefore, a hub-and-spoke topology helps minimize WAN expenses by not directly connecting any two spoke locations. If two spoke locations need to communicate with each other, their communication is sent via the hub location. [Table 6-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06tab04) describes the characteristics, benefits, and drawbacks of a hub-and-spoke WAN topology.

![](../images/key_topic_icon_158.jpg)


**Table 6-4** Characteristics, Benefits, and Drawbacks of a Hub-and-Spoke WAN Topology

| Characteristics | Benefits | Drawbacks |
| --- | --- | --- |
| Each remote site (that is, a spoke) connects to a main site (that is, the hub) via a WAN link. | Costs are reduced (as compared to a full-mesh or partial-mesh topology) because a minimal number of links is used. | Suboptimal routes must be used between remote sites because all intersite communication must travel via the main site. |
| Communication between two remote sites travels through the hub site. | Adding one or more additional sites is easy (compared to a full-mesh or partial-mesh topology) because only one link needs to be added per site. | Because all remote sites converge on the main site, this hub site is potentially a single point of failure. |
| — | — | Because each remote site is reachable by only a single WAN link, the hub-and-spoke topology lacks redundancy. |

#### Full-Mesh Topology

Whereas a hub-and-spoke WAN topology lacks redundancy and suffers from suboptimal routes, a [***full-mesh topology***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_279) (sometimes just termed *mesh*), as shown in [Figure 6-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig09), directly connects every site to every other site.

![](../images/06fig09.jpg)


**Figure 6-9** Full-Mesh Topology

Because each site connects directly to every other site, an optimal path can be selected, as opposed to relaying traffic via another site. Also, a full-mesh topology is highly fault tolerant. By inspecting [Figure 6-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig09), you can see that multiple links in the topology could be lost, and every site might still be able to connect to every other site. [Table 6-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06tab05) summarizes the characteristics, benefits, and drawbacks of a full-mesh topology.

![](../images/key_topic_icon_158.jpg)


**Table 6-5** Characteristics, Benefits, and Drawbacks of a Full-Mesh WAN Topology

| Characteristics | Benefits | Drawbacks |
| --- | --- | --- |
| Every site has a direct WAN connection to every other site. | An optimal route exists between any two sites. | A full-mesh network can be difficult and expensive to scale because the addition of one new site requires a new WAN link between the new site and every other existing site. |
| The number of required WAN connections can be calculated with the formula *w* = *n* × (*n* – 1) / 2, where *w* = the number of WAN links and *n* = the number of sites. For example, a network with 10 sites would require 45 WAN connections to form a fully meshed network: 45 = 10 × (10 – 1) / 2. | A full-mesh network is fault tolerant because one or more links can be lost, and reachability between all sites might still be maintained. | — |
| — | Troubleshooting a full-mesh network is relatively easy because each link is independent of the other links. | — |

#### Partial-Mesh Topology

A partial-mesh WAN topology, as depicted in [Figure 6-10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig10), is a [***hybrid***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_305) of the previously described hub-and-spoke topology and full-mesh topology. Specifically, a [***partial-mesh topology***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_477) can be designed to offer an optimal route between selected sites while avoiding the expense of interconnecting every site to every other site.

![](../images/06fig10.jpg)


**Figure 6-10** Partial-Mesh Topology

When designing a partial-mesh topology, a network designer must consider network traffic patterns and strategically add links interconnecting sites that have higher volumes of traffic between themselves. [Table 6-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06tab06) highlights the characteristics, benefits, and drawbacks of a partial-mesh topology.

![](../images/key_topic_icon_158.jpg)


**Table 6-6** Characteristics, Benefits, and Drawbacks of a Partial-Mesh Topology

| Characteristics | Benefits | Drawbacks |
| --- | --- | --- |
| Selected sites (that is, sites with frequent intersite communication) are interconnected via direct links, whereas sites that have less-frequent communication can communicate via another site. | A partial-mesh topology provides optimal routes between selected sites with higher intersite traffic volumes while avoiding the expense of interconnecting every site to every other site. | A partial-mesh topology is less fault tolerant than a full-mesh topology. |
| A partial-mesh topology uses fewer links than a full-mesh topology and more links than a hub-and-spoke topology for interconnecting the same number of sites. | A partial-mesh topology is more redundant than a hub-and-spoke topology. | A partial-mesh topology is more expensive than a hub-and-spoke topology. |


Note

There are plenty of network topologies today that use a variety of different design approaches. This often results in several approaches being used in one solution. We often term this a *hybrid* approach.

### The Three-Tier Hierarchical Model

![](../images/key_topic_icon_158.jpg)

For a very long time now in networking, we have had the concept of building a network in tiers. Doing so allows you to separate the logical functions of the network and target the appropriate hardware and software at the correct areas. For example, you do not want to consider a switch that is designed to permit users to access the network in the same way that you would consider a switch for moving traffic through the core of the network. We begin this section by examining one of the most classic (and still used) models for network architecture: the classic three-tier design.

Perhaps the very first thing you need to understand about the [***three-tier hierarchical model***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_694) (shown in [Figure 6-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig11)) is that in addition to being called the classic or classical model, it is also referred to as the hierarchical network model. Whatever you call it, notice that it is built with three layers: the [***access layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_035) (which is the layer closest to the end users), the distribution layer, and the [***core layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_175).

![](../images/06fig11.jpg)


**Figure 6-11** The “Classic” Three-Tier Network Architecture

Different names are often used for these layers. For example, the core layer might be called the backbone layer, and the distribution layer is often referred to as the aggregation layer. Finally, the access layer might be called the workstation or edge layer. You can clearly see what is happening here: Engineers often use names that say more about what is happening at the various layers of the model.

#### The Access/Edge Layer

The access/edge layer ensures that authorized users can access the network with ease and in a high-bandwidth fashion. In addition to providing a guide for what equipment is appropriate at the access layer, the classic three-tier model gives you a sense of what technologies are needed at certain layers.

Devices commonly found at the access layer include the following:

- End-user devices such as laptops, desktops, tablets, and smartphones
- Relatively inexpensive Layer 2 (data link layer) switches; notice that vendors will often refer to these devices as access layer switches
- Wireless access points (APs)

Common technologies found at the access layer include the following:

- Layer 2 switching
- Spanning Tree Protocol (STP)
- Power over Ethernet (PoE)
- Voice virtual local area network (VLAN) technologies
- Quality of service (QoS) functions
- Port security
- VLAN access control lists (VACLs)

#### The Distribution/Aggregation Layer

A consistent trend in networking decade after decade has been the fact that more and more of the data that users need to access is located remotely. More and more traffic is being sent outside the local network infrastructure. As cloud technology continues to take hold, remote data access will become even more common.

The [***distribution/aggregation layer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_219) is critical in the design of a network. This layer is responsible for connecting the access layer and the many devices inside it to the rest of the world and the valuable data that must be accessed.

At this layer, you typically find the following network devices:

- High-speed routers
- High-speed multilayer switches
- Firewalls
- Intrusion prevention devices
- Proxy servers

Note

Network engineers often try to remove overhead from the access and core layers and add it to the distribution layer.

The distribution layer is famous for its use of the following technologies:

- Security
- Policy
- Routing
- Load balancing
- Redundancy
- Summarization

#### The Core Layer

You’ve no doubt heard that three things are important in real estate: location, location, and location. Well, when it comes to the core layer of the classic design, three things are important as well: speed, speed, and speed. The core layer is responsible for moving massive amounts of data in an enterprise network—often between a data center (or even data centers) and the main employee locations.

Even in today’s remote work environment, there are still core network devices that are crucial to a properly operating IT organization. The core layer is home to very high-speed routers and multilayer switches (or even high-speed Layer 2 switches). (Remember, it is all about speed.)

The following types of technologies exist at the core layer:

- Redundancy
- Bandwidth aggregation
- Traffic policing and/or shaping

Note

Many organizations are just too small to really need a three-tier model. Such organizations can often successfully implement a classic two-tier model, which is often referred to as a [***collapsed core design***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_154). In this approach, the core and distribution layers are merged together for the sake of simplicity (as well as cost savings).

#### Spine and Leaf

The classic hierarchical model for building an enterprise network is excellent for building an enterprise network. But what about for different kinds of network locations in an organization, such as a data center? Certainly, different models might be more appropriate in a data center, where traffic is different and traffic patterns are not always as expected. Different models are used for different network locations. One that has become quite famous is called the [***spine and leaf***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_648) topology or network model.

One of the reasons the spine and leaf topology has gained popularity in the data center is that vendors such as Cisco Systems rely on it for new technologies they are rolling out. Cisco created the Application Centric Infrastructure (ACI) for Software Defined Networking (SDN) in the data center. As its name directly communicates, ACI takes a very application-centric (software as a service [SaaS]) approach to the control and management of network design, bringing automation and orchestration to the SaaS engine of the private data center.

Note

[Chapter 8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08), “[Evolving Use Cases](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#ch08),” covers software-defined networking in detail for you.

[Figure 6-12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig12) shows a simple spine and leaf network design.

![](../images/key_topic_icon_158.jpg)

![](../images/06fig12.jpg)


**Figure 6-12** The Cisco ACI Spine and Leaf Design

Notice that this model consists of just two layers: the spine and the leaf layers.

Note

Some engineers call the spine layer the core layer or the *backbone* layer.

One thing that can really surprise long-time Cisco fans is just how inflexible Cisco is when it comes to the spine and leaf topology that powers the Cisco ACI solution. Cisco makes it very clear exactly which devices must be used at each layer of the model. [Figure 6-12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig12) shows Cisco Nexus 9600s at the spine layer and Cisco Nexus 9300s at the leaf layer. Cisco will continue to produce different classes of devices that will fit in these layers, but you can expect that the ACI solution will always require particular Cisco devices.

There is also no flexibility in how you connect the spine and leaf topology. Each leaf node *must* connect to each spine node—and that is it. The spine nodes do not directly connect to each other, and the leaf nodes do not directly connect to each other. Rather, each leaf must connect to each spine. This inflexibility brings several benefits:

- There is no doubt about how you should connect the equipment. It is actually refreshing to be told exactly how the Gigabit Ethernet segments must be constructed, leaving no room for doubt or experimentation.
- There is completely predictable data pathing in the system. VMs (or containers) are hosted on systems that connect to leaf nodes. When a VM that connects to the leaf layer needs to communicate with another VM on the same leaf device, it does not need to transit to the spine layer; when a VM on one leaf needs to communicate to a VM on another leaf device, it is *always* one hop away; there is exactly one spine device that must be transited.
- The latency is predictable, due in large part to the predictability of the data pathing.
- Monitoring and expanding the topology is simple. If you need to connect more hosts (hardware) to connect more containers and VMs, you can just add a leaf device; if you need more overall bandwidth and processing power for the solution, you can just add a new spine.

Note

The Cisco ACI approach is actually a variation of an earlier technological approach called top-of-rack switching, or end-of-rack switching. In this design, multiple physical components act as one network device. For example, with the end-of-rack switching design, there are physical switches in each data center rack for connectivity, but the control layer (or plane) intelligence and the “real” switching engine are located at the end of a row of racks in the data center. This larger physical device is controlling the behavior of the distributed switches in the racks. They function logically as one big device. Specifically, the smaller switches in the racks act like line cards inserted in the chassis of a bigger and more powerful switch. ACI functions similarly, with leaf nodes appearing to the solution as part of the spine devices.

#### Traffic Flows

When working with the various network architectures that are possible (such as three-tier versus spine and leaf), engineers will often study how the majority of traffic flows in the model. This helps them ensure they have provisioned adequate bandwidth and other resources. You should be familiar with two overall patterns:

- [***North–south traffic flows***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_459): In the classic three-tier model, most traffic flows are north to south (and also south to north). This describes traffic moving from the core to the access layer and vice versa.
- [***East–west traffic flows***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_242): In the newer spine and leaf type architecture, most traffic flows tend to be east to west (and vice versa). In this architecture (along with other data center type designs), virtual machines and/or containers communicate with each other over east–west flows.

### Real-World Case Study

The headquarters for Acme, Inc. is located on a single floor of a downtown building. Acme also has two branch offices, Branch1 and Branch2, that are in remote locations. The company wants to do file sharing, instant messaging, email, and voice on its own private networks when possible. It also wants connectivity to the Internet.

At the headquarters location, Acme sets up a LAN with UTP (Cat 6a) cabling, with the clients and servers connected to a central switch. This forms a physical star topology. For connectivity between HQ and its two branch offices, the company uses a service provider (SP) for WAN connectivity.

The SP provides logical, point-to-point connections between the headquarters office and both of the branch locations. Physically, the path between the headquarters and each branch office is going through several routers in the SP’s network. For the time being, Branch1 and Branch2 do not have direct connectivity to each other, so branch-to-branch traffic must pass through the headquarters site (hub and spoke).

Next year, as more funds are available, the company can add WAN connectivity directly between Branch1 and Branch2. This will change the WAN topology from hub and spoke to full mesh.

### Summary

Here are the main topics covered in this chapter:

- One way to classify networks is by their geographic dispersion. Examples include LAN, WAN, CAN, MAN, and PAN. This chapter covered these major network classifications in use today.
- Another approach to classifying networks is based on a network’s topology. Examples of network types, based on topology, include star, hybrid (partial mesh), full mesh, and hub and spoke. This chapter also covered these topologies.
- This chapter contrasted client/server and peer-to-peer networks.
- This chapter covered the three-tier hierarchical model and the collapsed core design.
- This chapter also covered the spine and leaf network topology and discussed north to south versus east to west traffic flows.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 6-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06tab07) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 6-7** Key Topics for [Chapter 6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| [Table 6-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06tab03) | Characteristics, Benefits, and Drawbacks of a Star Topology | 146 |
| [Table 6-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06tab04) | Characteristics, Benefits, and Drawbacks of a Hub-and-Spoke WAN Topology | 147 |
| [Table 6-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06tab05) | Characteristics, Benefits, and Drawbacks of a Full-Mesh WAN Topology | 148 |
| [Table 6-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06tab06) | Characteristics, Benefits, and Drawbacks of a Partial-Mesh Topology | 149 |
| Section | The Three-Tier Hierarchical Model | 150 |
| [Figure 6-12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#ch06fig12) | The Cisco ACI Spine and Leaf Design | 153 |

### Complete Tables and Lists from Memory

Print a copy of [Appendix C](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc), “[Memory Tables](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc),” or at least the section for this chapter and complete as many of the tables as possible from memory. [Appendix D](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appd.xhtml#appd), “[Memory Tables Answer Key](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appd.xhtml#appd),” includes the completed tables and lists so you can check your work.

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[access layer](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_01)

[collapsed core design](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_02)

[core layer](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_03)

[distribution/aggregation layer](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_04)

[east–west traffic flows](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_05)

[full-mesh topology](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_06)

[hub-and-spoke topology](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_07)

[hybrid](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_08)

[north–south traffic flows](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_09)

[partial-mesh topology](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_010)

[point-to-point network topology](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_011)

[spine and leaf](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_012)

[star topology](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_013)

[three-tier hierarchical model](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#key_014)

### Additional Resources

**Wide Area Network (WAN) Topologies:** <https://www.youtube.com/watch?v=9WkZT0YMZ70>

**Leaf Spine DC Architectures:** <https://www.youtube.com/watch?v=WzwpKVx9Tb0>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_1) What type of network is most likely to incorporate IEEE 802.3 technologies?

1. PAN
2. SAN
3. WLAN
4. LAN

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_2) A physical topology is dictated by the way in which components are physically interconnected. What type of topology is dictated by the way in which traffic actually flows?

1. Overlay
2. Underlay
3. Logical
4. Access

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_3) Which layer of the three-tier hierarchical model is most concerned with speed?

1. Access
2. Distribution
3. Policy
4. Core

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_4) How is connectivity for the spine and leaf topology implemented?

1. Each spine device connects to every other device.
2. Each leaf device connects to each spine device.
3. Each spine device connects to every other spine device.
4. Each leaf device must connect to each other leaf device.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_5) A company has various locations in a city interconnected using Metro Ethernet connections. This is an example of what type of network?

1. WAN
2. CAN
3. PAN
4. MAN

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_6) A network formed by interconnecting a PC to a digital camera via a USB cable is considered what type of network?

1. WAN
2. CAN
3. PAN
4. MAN

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_7) Which of the following physical LAN topologies requires the most cabling?

1. Point-to-point
2. Ring
3. Star
4. WLAN

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_8) Which of the following topologies offers the highest level of redundancy?

1. Full mesh
2. Hub and spoke
3. Bus
4. Partial mesh

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_9) How many WAN links are required to create a full mesh of connections between five remote sites?

1. 5
2. 10
3. 15
4. 20

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_10) Which of the following are advantages of a hub-and-spoke WAN topology as compared to a full-mesh WAN topology? (Choose two.)

1. Lower cost
2. Optimal routes
3. More scalable
4. More redundancy

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_11) Which type of network is based on network clients sharing resources with one another?

1. Client/server
2. Client/peer
3. Peer-to-peer
4. Peer-to-server

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_12) Which of the following is an advantage of a peer-to-peer network as compared with a client/server network?

1. More scalable
2. Less expensive
3. Better performance
4. Simplified administration

[**13.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_13) What network type would help facilitate communications when large video or audio files need to be housed and transferred through the network?

1. WLAN
2. CAN
3. PAN
4. SAN

[**14.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_14) Which of the following traffic flows occurs primarily between servers or services deployed within the same data center or cloud environment?

1. East–west
2. North–south
3. Point to point
4. NAS

[**15.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz6_15) What are the three layers in the three-tier hierarchical model? (Choose three.)

1. Intermediate
2. Core
3. Distribution
4. Access