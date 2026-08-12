## Chapter 2

## Networking Appliances, Applications, and Functions

This chapter covers the following topics related to Objective 1.2 (Compare and contrast networking appliances, applications, and functions) of the CompTIA Network+ N10-009 certification exam:

- [Physical and virtual appliances](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev1sec2)

  - [Router](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec1)
  - [Switch](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec2)
  - [Firewall](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec3)
  - [Intrusion detection system (IDS)/intrusion prevention system (IPS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec4)
  - [Load balancer](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec5)
  - [Proxy](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec6)
  - [Network-attached storage (NAS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec7)
  - [Storage area network (SAN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec8)
  - Wireless

    - [Access point (AP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec9)
    - [Controller](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec10)
- [Applications](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev1sec3)

  - [Content delivery network (CDN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec12)
- [Functions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev1sec3)

  - [Virtual private network (VPN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec13)
  - [Quality of service (QoS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec14)
  - [Time to live (TTL)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02lev2sec15)

Modern networks can include a daunting number of devices, and it is your job to understand the function of each device and how it works with the others. To create a network, these devices need some sort of interconnection, using one of a variety of media types. This chapter begins by delving into the many networking devices that make up a typical enterprise (or even small home office) network.

Next, this chapter explores some typical applications and functions that the network can perform. This includes a discussion of such popular features like virtual private networks (VPNs) and content delivery networks (CDNs).

### Foundation Topics

### Physical and Virtual Appliances

This chapter begins with a fairly detailed look at the networking devices that work together to determine the success or failure of your IT infrastructure. You might not have every one of these devices in your network, but knowledge of each helps set the stage for some of the more advanced networking technologies discussed in later chapters.

#### Routers

A [***router***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_577) is a Layer 3 device, which means it makes forwarding decisions based on logical network address (for example, IP address) information. Although a router is considered to be a Layer 3 device it has the capability to consider high-layer traffic parameters, such as quality of service (QoS) settings, in making forwarding decisions.

Routers help us dramatically when designing networks. This is because they are so efficient at segmenting larger networks. Specifically, routers do not forward broadcast packets by default. This means that each port on a router automatically creates a separate broadcast domain.

If this were not enough, each port also creates a separate collision domain. What is a collision domain? A collision domain represents an area on a LAN on which there can be only one transmission at a time. Thanks to the elimination of legacy hubs and bridges in the modern network, our networks today feature microsegmentation. This means we eliminate the possibility of frame collisions by automatically creating tiny collision domains for each port.

[Figure 2-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig01) shows how each port on a router is a separate collision domain and a separate broadcast domain. Notice this figure also shows two Layer 2 switches (covered next in this chapter). These devices do not automatically create broadcast domains by default, but they do help microsegment the network. Each port on the switch represents a collision domain just like a router.

![](../images/02fig01.jpg)


**Figure 2-1** Router Broadcast and Collision Domains

#### Switches

There are actually many different types of [***switches***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_671) found in networks today. Let’s begin with the most basic type, a [***Layer 2 Ethernet switch***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_362).

![](../images/key_topic_icon_158.jpg)

Note

Why do we call the device a Layer 2 switch? If you read [Chapter 1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01) of this text you probably guessed it. Layer 2 switches operate at Layer 2 of the OSI model—the data link layer.

Layer 2 switches dynamically learn the MAC addresses attached to various ports by looking at the source MAC addresses on frames coming into a port. For example, if switch port Gigabit Ethernet 1/1 received a frame with source MAC address DDDD.DDDD.DDDD, the switch could conclude that MAC address DDDD.DDDD.DDDD resides off port Gigabit Ethernet 1/1. In the future, if the switch receives a frame destined for MAC address DDDD.DDDD.DDDD, the switch would only send that frame out port Gigabit Ethernet 1/1.

Initially, however, a switch is unaware of what MAC addresses reside off which ports (unless MAC addresses have been statically configured). Therefore, when a switch receives a frame destined for a MAC address not yet present in the switch’s MAC address table, the switch floods that frame out all the switch ports except the port on which the frame was received. Similarly, broadcast frames (that is, frames with destination MAC address FFFF.FFFF.FFFF) are always flooded out all switch ports except the port on which the frame was received. The reason broadcast frames are always flooded is that no endpoint will have MAC address FFFF.FFFF.FFFF, which means that the FFFF.FFFF.FFFF MAC address will never be learned in a switch’s MAC address table.

To illustrate how a switch’s MAC address table becomes populated, consider an endpoint named PC1 that wants to form an SSH connection with a server. Also, assume that PC1 and its server both reside on the same subnet (that is, no routing is required to get traffic between PC1 and its server). Before PC1 can establish an SSH session to its server, PC1 needs to know the IP address (that is, the Layer 3 address) and the MAC address (Layer 2 address) of the server. The IP address of the server is typically known or is resolved via a Domain Name System (DNS) lookup. In this example, assume that the server’s IP address is known. To properly form an SSH segment, however, PC1 needs to know the server’s Layer 2 MAC address. If PC1 does not already have the server’s MAC address in its Address Resolution Protocol (ARP) cache, PC1 can send an ARP request in an attempt to learn the server’s MAC address, as shown in [Figure 2-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig02).

![](../images/02fig02.jpg)


**Figure 2-2** Endpoint Sending an ARP Request

When switch SW1 sees PC1’s ARP request enter port Gigabit 0/1, PC1’s MAC address AAAA.AAAA.AAAA is added to switch SW1’s MAC address table. Also, because the ARP request is a broadcast, its destination MAC address is FFFF.FFFF.FFFF. Because the MAC address FFFF.FFFF.FFFF is not known to switch SW1’s MAC address table, switch SW1 floods a copy of the incoming frame out all switch ports other than the port on which the frame was received, as shown in [Figure 2-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig03).

![](../images/02fig03.jpg)


**Figure 2-3** Switch SW1 Flooding the ARP Request

When switch SW2 receives the ARP request over its Gig 0/1 trunk port, the source MAC address AAAA.AAAA.AAAA is added to switch SW2’s MAC address table, as illustrated in [Figure 2-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig04). Also, using behavior similar to that of switch SW1, switch SW2 floods the broadcast.

![](../images/02fig04.jpg)


**Figure 2-4** Switch SW2 Flooding the ARP Request

The server receives the ARP request and responds with an ARP reply, as shown in [Figure 2-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig05). Unlike the ARP request, however, the ARP reply frame is not a broadcast frame. The ARP reply, in this example, has a destination MAC address AAAA.AAAA.AAAA, which makes the ARP reply a unicast frame.

![](../images/02fig05.jpg)


**Figure 2-5** ARP Reply Sent from a Server

Upon receiving the ARP reply from the server, switch SW2 adds the server’s MAC address BBBB.BBBB.BBBB to its MAC address table, as shown in [Figure 2-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig06). Also, the ARP reply is only sent out port Gig 0/1 because switch SW1 knows that the destination MAC address AAAA.AAAA.AAAA is available off port Gig 0/1.

![](../images/02fig06.jpg)


**Figure 2-6** Switch SW2 Forwarding the ARP Reply

When receiving the ARP reply in its Gig 0/2 port, switch SW1 adds the server’s MAC address BBBB.BBBB.BBBB to its MAC address table. Also, like switch SW2, switch SW1 now has an entry in its MAC address table for the frame’s destination MAC address AAAA.AAAA.AAAA. Therefore, switch SW1 forwards the ARP reply out port Gig 0/1 to the endpoint of PC1, as illustrated in [Figure 2-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig07).

![](../images/02fig07.jpg)


**Figure 2-7** Switch SW1 Forwarding the ARP Reply

After receiving the server’s ARP reply, PC1 knows the MAC address of the server. Therefore, PC1 can now properly construct an SSH segment destined for the server, as depicted in [Figure 2-8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig08).

![](../images/02fig08.jpg)


**Figure 2-8** PC1 Sending an SSH Segment

Switch SW1 has the server’s MAC address BBBB.BBBB.BBBB in its MAC address table. Therefore, when switch SW1 receives the SSH segment from PC1, that segment is forwarded out of switch SW1’s Gig 0/2 port, as shown in [Figure 2-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig09).

![](../images/02fig09.jpg)


**Figure 2-9** Switch SW1 Forwarding the SSH Segment

With behavior similar to that of switch SW1, switch SW2 forwards the SSH segment out of its Gig 0/2 port. This forwarding, shown in [Figure 2-10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig10), is possible because switch SW2 has an entry for the segment’s destination MAC address BBBB.BBBB.BBBB in its MAC address table.

![](../images/02fig10.jpg)


**Figure 2-10** Switch SW2 Forwarding the SSH Segment

Finally, the server responds to PC1, and a bidirectional SSH session is established between PC1 and the server, as illustrated in [Figure 2-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig11). Because PC1 learned the server’s MAC address as a result of its earlier ARP request and stored that result in its local ARP cache, the transmission of subsequent Telnet segments does not require additional ARP requests. However, if unused for a period of time, entries in a PC’s ARP cache can time out. Therefore, the PC would have to broadcast another ARP frame if it needed to send traffic to the same destination IP address. The sending of the additional ARP frames adds a small amount of delay when reestablishing a session with that destination IP address.

![](../images/02fig11.jpg)


**Figure 2-11** Bidirectional SSH Session Between PC1 and the Server

As shown in [Figure 2-12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig12), each port on a switch represents a separate collision domain. Also, all ports on a switch belong to the same broadcast domain, with one exception: when the ports on a switch have been divided into separate virtual LANs (VLANs). Remember that each VLAN represents a separate broadcast domain, and for traffic to travel from one VLAN to another, that traffic must be routed by a Layer 3 device.

![](../images/02fig12.jpg)


**Figure 2-12** Switch Collision and Broadcast Domains

Whereas a Layer 2 switch makes forwarding decisions based on MAC address information, a [***multilayer switch***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_418) can make forwarding decisions based on upper-layer information. For example, a multilayer switch could function as a router and make forwarding decisions based on destination IP address information. Some literature refers to a multilayer switch as a [***Layer 3 capable switch***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_363) because of the switch’s capability to make forwarding decisions like a router. The term *multilayer switch* is more accurate, however, because many multilayer switches have policy-based routing features that allow upper-layer information (for example, application port numbers) to be used in making forwarding decisions.

![](../images/key_topic_icon_158.jpg)

[Figure 2-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig13) makes the point that a multilayer switch can be used to interconnect not just network segments but also entire networks. Remember that logical Layer 3 IP addresses are used to assign network devices to different logical networks. For traffic to travel between two networked devices that belong to different networks, that traffic must be *routed*. (That is, a device, such as a multilayer switch, has to make a forwarding decision based on Layer 3 information.)

![](../images/key_topic_icon_158.jpg)

![](../images/02fig13.jpg)


**Figure 2-13** Multilayer Ethernet Switch

As on a Layer 2 switch, each port on a multilayer switch represents a separate collision domain; however, a characteristic of a multilayer switch (and a router) is that it can become a boundary of a broadcast domain. Although all ports on a Layer 2 switch belong to the same broadcast domain, if configured as such, all ports on a multilayer switch can belong to different broadcast domains.

#### Firewalls

A network [***firewall***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_271) is most often implemented as a network security appliance, but this is certainly not the only “form factor” a firewall can take on. If you are a Windows Operating System (OS) user, you have probably noticed the software firewall included by default in your OS. As depicted in [Figure 2-14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig14), a firewall appliance stands guard at the door of your network, protecting it from malicious Internet traffic.

![](../images/key_topic_icon_158.jpg)

![](../images/02fig14.jpg)


**Figure 2-14** Firewall

For example, a *stateful firewall* allows traffic to originate from an inside network (that is, a trusted network) and go out to the Internet (an untrusted network). Likewise, return traffic coming back from the Internet to the inside network is allowed by the firewall. However, if traffic originates from a device on the Internet (that is, not returning traffic), the firewall blocks that traffic.

#### Intrusion Detection System (IDS)/Intrusion Prevention System (IPS)

When an attacker launches an attack against a network, [***intrusion detection system (IDS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_338) and [***intrusion prevention system (IPS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_339) technologies are often able to recognize the attack and respond appropriately. Attacks might be recognizable by comparing incoming data streams against a database of well-known attack signatures. Other mechanisms for detecting attacks include policy-based and anomaly-based approaches.

Note

Be sure you understand the difference between an IDS and an IPS. An IDS is a software application or hardware device that monitors a network or system for malicious or non-policy-related activity and reports violations to a centralized management system. Notice its key function is *detection*. An IPS is a network device that continually scans the network, looking for inappropriate activity. It can stop potential threats. Notice its key function is *prevention*.

In addition to dedicated network-based intrusion prevention system (NIPS) sensors, IPS software can be installed on a host to provide a host-based intrusion prevention system (HIPS) or host-based intrusion detection system (HIDS) solution.

##### IDS Versus IPS

Both IDS and IPS devices can recognize network attacks; they differ primarily in their network placement. Specifically, whereas an IDS device receives a copy of traffic to be analyzed, an IPS device resides inline with the traffic, as illustrated in [Figure 2-15](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig15).

Because the analyzed traffic does not flow through the IDS device, the IDS device is considered to be *passive*, and the IPS device is considered to be *active*. Both the IDS and the IPS devices can send alerts to, for example, a management station. Although an IDS device can also communicate with a security appliance or a router to prevent subsequent attack packets, the initially offending traffic reaches its destination. Conversely, an IPS device can drop the traffic inline, thus preventing even the first malicious packet from reaching its intended target.

The previous discussion of IDS versus IPS devices might seem to suggest that IPS devices should always be used instead of IDS devices. However, in some network environments, these two solutions complement one another. For example, an IDS device can add value to a network that already employs an IPS device by verifying that the IPS device is still operational. The IDS device might also identify suspicious traffic and send alerts about that traffic without having the IPS device drop the traffic.

![](../images/key_topic_icon_158.jpg)

![](../images/02fig15.jpg)


**Figure 2-15** IDS and IPS Network Placement

##### IDS and IPS Device Categories

IDS and IPS devices can be categorized based on how they detect malicious traffic. Alternatively, IPS devices can be categorized based on whether they run on a network device or on a host.

Consider the following approaches to detecting malicious traffic:

![](../images/key_topic_icon_158.jpg)

- Signature-based detection
- Policy-based detection
- Anomaly-based detection

The following sections describe these methods in detail.

###### Signature-Based Detection

The primary method used to detect and prevent attacks using IDS or IPS technologies is signature based. A signature could be a string of bytes that, in a certain context, triggers detection. For example, attacks against a web server typically take the form of URLs. Therefore, URLs could be searched for a certain string that would identify an attack against a web server.

As another example, the IDS or IPS device could search for a pattern in the MIME header of an email message. However, because signature-based IDS/IPS is, as its name suggests, based on signatures, the administrator needs to routinely update the signature files.

###### Policy-Based Detection

Another approach to IDS/IPS detection is policy based. With a policy-based approach, the IDS/IPS device needs a specific declaration of the security policy. For example, you could write a network access policy that identifies which networks can communicate with other networks. The IDS/IPS device could then recognize out-of-profile traffic that does not conform to the policy and report that activity. Policy-based detection could also identify unencrypted channels and plaintext credentials and insecure protocols such as Telnet, SNMPv1, SNMPv2, HTTP, FTP, SLIP, and TFTP. Secure protocols such as SSH, SNMPv3, TLS/SSL, HTTPS, SFTP, and IPsec should be used when possible to protect the confidentiality of the data flows on the network.

###### Anomaly-Based Detection

A third approach to detecting or preventing malicious traffic is anomaly based. This approach is prone to false positives because a *normal* condition is difficult to measurably define. However, there are a couple of options for detecting anomalies:

- **Statistical anomaly detection:** This approach involves watching network traffic patterns over a period of time and dynamically building a baseline. Then, if traffic patterns significantly vary from the baseline, an alarm can be triggered.
- **Nonstatistical anomaly detection:** This approach allows an administrator to define what traffic patterns are supposed to look like. However, imagine that Microsoft releases a large update for its Windows 10 OS, and your company has hundreds of computers that are configured to automatically download that service pack. If multiple employees turn on their computers at approximately the same time tomorrow morning, and multiple copies of the service pack simultaneously start to download from [https://www.microsoft.com](https://www.microsoft.com/), the IDS/IPS device might consider that traffic pattern to be significantly outside the baseline. As a result, the nonstatistical anomaly detection approach could lead to a false positive (that is, an alarm being triggered in the absence of malicious traffic). However, an anomaly-based IPS may be able to indicate abnormal behavior, compared to the baseline of normal activity, which could assist you in discovering a new type of attack that is being used against your network. A zero-day attack is an attack that exploits a previously unknown vulnerability.

Note

Anomaly-based detection is also known as *behavior-based detection.*

#### Load Balancer

A [***load balancer***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_379) is a network device or software component that distributes incoming network traffic across multiple servers, systems, or resources in a network, ensuring optimal utilization of resources, high availability, and improved performance. Load balancers operate at the application layer (Layer 7) or transport layer (Layer 4) of the OSI model and use various algorithms, such as round-robin, least connections, or weighted distribution, to evenly distribute incoming requests or connections among the backend servers.

Notice how load balancers are important specialized network devices that can assist with performance and high availability of key network devices and services. For example, a load balancer can sit in front of a fleet of web servers in a data center. When a large volume of requests comes in from clients for the content of those web servers, the load balancer can ensure that the requests are intelligently distributed to the web servers. Often this intelligent distribution can be based on the resources available for each web server. More requests can be sent to those web servers that have the most available resources of the group. As you might expect, the load balancer can also check the health of the nodes periodically and intelligently prevent the forwarding of web requests to servers that are sickly.

#### Proxy Servers

Some clients are configured to forward their packets, which are seemingly destined for the Internet, to a [***proxy server***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_530). The proxy server receives the client’s request, and on behalf of that client (that is, as that client’s proxy), the proxy server sends the request out to the Internet. When a reply is received from the Internet, the proxy server forwards the response on to the client. [Figure 2-16](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig16) illustrates the operation of a proxy server.

![](../images/key_topic_icon_158.jpg)

![](../images/02fig16.jpg)


**Figure 2-16** Proxy Server Operation

What possible benefit could come from such an arrangement? Security is one benefit. Specifically, because all requests going out to the Internet are sourced from the proxy server, the IP addresses of network devices inside the trusted network are hidden from the Internet.

Yet another benefit could come in the form of bandwidth savings because many proxy servers perform content caching. For example, without a proxy server, if multiple clients all visited the same website, the same graphics from the home page of the website would be downloaded multiple times (one time for each client visiting the website). However, with a proxy server performing content caching, when the first client navigates to a website on the Internet, and the Internet-based web server returns its content, the proxy server not only forwards this content to the client requesting the web page but also stores a copy of the content on its hard drive. Then, when a subsequent client points its web browser to the same website, after the proxy server determines that the page has not changed, the proxy server can locally serve up the content to the client, without having to once again consume Internet bandwidth to download all the graphic elements from the Internet-based website.

As a final example of a proxy server benefit, some proxy servers can perform content filtering to restrict clients from accessing certain URLs. For example, many companies use content filtering to prevent their employees from accessing popular social networking sites and promote productivity.

Note

A reverse proxy receives requests on behalf of a server or servers and replies back to the clients on behalf of those servers. Reverse proxies can also be used with load-balancing and caching to better utilize a group of servers providing scalability and high availability.

#### Network-attached Storage (NAS)

In networks today, there is a greater need than ever for digital storage capabilities. Think about your own numerous personal files that need to be stored. It is no surprise, therefore, that many different technologies exist today to make storing files on the network simple and seamless.

One option today is to use [***network-attached storage (NAS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_439). A NAS device is a specialized type of storage device that is designed to provide centralized storage and file sharing capabilities to multiple users and devices within a network. Unlike traditional storage solutions that are directly attached to individual computers, NAS devices connect to a local area network or wide area network, allowing them to be accessed by any device connected to the network. NAS devices typically consist of one or more hard drives configured in a Redundant Array of Independent Disks (RAID) array for data redundancy and increased reliability.

NAS devices can range from simple single-drive enclosures suitable for home use to enterprise-grade systems capable of storing petabytes of data. They can also support various protocols and services, including file sharing protocols like Server Message Block (SMB) and Network File System (NFS), as well as backup and synchronization services. Additionally, many NAS devices offer other features such as media streaming, remote access, and even hosting applications like email servers or web servers, making them versatile solutions for both home and business environments.

#### Storage Area Networks (SANs)

![](../images/key_topic_icon_158.jpg)

As described earlier, networks will often use a NAS where disk storage can be delivered as a service over the network. As this approach evolved to include more efficiency and more features, the idea for a network dedicated to storing data was born.

A [***storage area network (SAN)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_659) is a high-speed, very specialized network that is designed to store massive amounts of data and make that data available quickly when clients and/or servers request it.

Originally, Fibre Channel was the technology that ruled the SAN space. Unlike Ethernet, Fibre Channel is designed for very low-latency, guaranteed lossless connectivity. In contrast, with UDP in an Ethernet environment, it is easy to contend with packet loss and delays. This is not the case in a SAN environment.

To make SANs even more accessible and flexible, they began to be created to support Internet Small Computer System Interface (iSCSI). With iSCSI, which is an IP-based technology for network storage, a client using the storage is referred to as an *initiator*, and the system providing the iSCSI storage is called the iSCSI *target*. Networks supporting iSCSI are often configured to support larger-than-normal frame sizes, referred to as *jumbo frames*.

Note

Less commonly encountered these days in SANs is InfiniBand (IB), a communication technology that permits high-speed, low-latency communications between supercomputers.

Network convergence is often the goal today. For example, voice and video and data networks are successfully combined today. These very different types of communications can all be sent over the same network. Converging different forms of traffic on a network extended to SAN and LAN traffic is thanks to a remarkable invention: Fibre Channel over Ethernet (FCoE). Just like it sounds, this technology allows Ethernet to encapsulate Fibre Channel frames and carry them over a high-speed Ethernet infrastructure. Modifications were made to the Ethernet standards for FCoE to provide the level of service required in the SAN for Fibre Channel.

Note

As you might guess, Ethernet needs to be truly high speed in order to have a chance at providing FCoE services. In the Cisco implementation, 10-Gbps Ethernet is required for FCoE! This might sound crazy and too difficult to accommodate, but keep in mind that FCoE is mostly used with data centers, where 10-Gbps and even 40-Gbps Ethernet links have become common.

#### Access Points (APs)

If you examine the sample wireless network topology shown in [Figure 2-17](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig17), you will notice that wireless clients gain access to a wired network by communicating via radio waves with a wireless [***access point (AP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_036). The AP can then be hardwired to a LAN.

![](../images/02fig17.jpg)


**Figure 2-17** A Wireless Access Point in a Network

Wireless LANs include multiple standards that support various transmission speeds and security features. However, you need to understand, at this point, that all wireless devices connecting to the same AP are considered to be on the same *shared network segment*, which means that only one device can send data to and receive data from an AP at any one time.

#### Controllers

Access points tend to come in two major types: autonomous and lightweight. Lightweight access points do not have the control plane intelligence built in to perform their functions for the network. These devices are controlled by controllers, or more formally known as [***wireless LAN controllers (WLCs)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_770). WLCs are specialized network devices that permit the central control and management of large numbers of lightweight access points. WLCs simplify the administration of your access points, and they can also assist you dramatically in the monitoring and ongoing maintenance of the wireless infrastructure.

#### Networking Device Summary

[Table 2-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02tab01) provides a summary of the networking devices discussed in this chapter.

![](../images/key_topic_icon_158.jpg)


**Table 2-1** Networking Device Summary

| Device | Description | Key Points |
| --- | --- | --- |
| Router | Connects networks | A router uses the software-configured network address to make forwarding decisions. |
| Switch | Connects devices on a twisted-pair network | A switch forwards data to its destination by using the MAC address embedded in each packet. It forwards data only to nodes that need to receive it. |
| Multilayer switch | Functions as a switch or router | Operates on Layers 2 and 3 of the OSI model as a switch and can perform router functionality. |
| Firewall | Provides controlled data access between networks | Firewalls can be hardware or software based. They are an essential part of a network’s security strategy. |
| IDS/IPS | Detects and prevents intrusions | Monitors the network and attempts to detect/prevent intrusion attempts. |
| Load balancer | Distributes network load | Load balancing increases redundancy and performance by distributing the load to multiple servers. |
| Proxy | Sends resource requests on behalf of network clients | Can add to the security and bandwidth efficiency of the network. |
| Network-attached storage (NAS) | Centralized storage device that connects to a network | Provides scalability and flexibility for the large amounts of storage today. |
| Storage area network (SAN) | A high-speed network that connects storage devices to servers | Allows multiple servers to easily and efficiently access large amounts of storage. |
| Access point (AP) | Enables wireless devices to connect to wireless and wired networks | Should provide the latest in security standards to help reduce security breaches. |
| Controller | Used with branch/remote office deployments for wireless authentication | When an AP boots, it authenticates with a controller before it can start working as an AP. |

### Applications and Functions

Now that we have examined just some of the physical and virtual appliances we might encounter in our home and business networks, let’s discuss just a few of the many applications and functions you might encounter in modern networks.

#### Content Delivery Network (CDN)

A [***content delivery network (CDN)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_170) is a sophisticated infrastructure comprised of multiple servers distributed across various geographic locations, strategically positioned to deliver web content and digital media to users with optimal speed and reliability. For example, when a user requests access to content hosted on a web server, the CDN automatically identifies the user’s location and routes the request to the nearest server within its network. By serving content from servers near the user, CDNs can significantly reduce latency and minimize the time it takes for content to reach the end-user device, enhancing the overall user experience.

CDNs can also help mitigate the risk of server overload and improve scalability by distributing the load of content delivery across multiple servers. This distributed architecture enables CDNs to handle high volumes of traffic efficiently, particularly during peak usage periods or sudden spikes in demand. CDNs can also offer advanced caching mechanisms that store copies of frequently accessed content on edge servers, further optimizing performance and reducing the strain on the servers of origin.

#### Virtual Private Network (VPN)

Companies with locations spread across multiple sites often require secure communications between those sites. One option is to purchase multiple WAN connections to interconnect those sites. Sometimes, however, a more cost-effective option is to create secure connections through an untrusted network, such as the Internet. Such a secure tunnel is called a [***virtual private network (VPN)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_746).

VPNs provide a layer of privacy and security by encrypting data transmitted between the user’s device and the VPN server, protecting it from potential eavesdropping or interception by third parties. This encryption ensures that even if data is intercepted, it remains unreadable and secure. Today, VPNs are commonly used by businesses to provide remote workers with secure access to the organization’s internal network resources, such as files, applications, and databases, while ensuring data confidentiality and integrity. You will learn a lot more about VPNs in [Chapter 17](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17), “[Network Access and Management Methods.](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#ch17)”

#### Quality of Service (QoS)

While the main concern of your network is to ensure that data packets reach their rightful destinations, it is the job of [***quality of service (QoS)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_536) to ensure that packets do not suffer from long delays (latency) or, worse, dropped packets.

QoS is actually a suite of technologies that allows you to strategically optimize network performance for select traffic types. For example, in today’s converged networks (that is, networks simultaneously transporting voice, video, and data), some applications (for example, voice) might be more intolerant of delay (or *latency*) than other applications; for example, an FTP file transfer is less latency sensitive than a VoIP call. Fortunately, through the use of QoS technologies, you can identify which traffic types need to be sent first, how much bandwidth to allocate to various traffic types, which traffic types should be dropped first in the event of congestion, and how to make the most efficient use of the relatively limited bandwidth of an IP WAN.

Note

Do not get confused by the many uses we have for the word *converged* in networking. It all depends on the context. For example, when speaking about the network in general and what data it can carry, a converged network is one that includes multiple forms of traffic—for example, VoIP and data traffic. When we are speaking of a single routing protocol, converged means the device has learned of all the updates that have been in the routing protocol’s information.

A lack of bandwidth is the overshadowing issue for most network quality problems. Specifically, when there is a lack of bandwidth, packets might suffer from one or more of the symptoms listed in [Table 2-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02tab02).

![](../images/key_topic_icon_158.jpg)


**Table 2-2** Three Categories of Quality Issues

| Issue | Description |
| --- | --- |
| Delay | Delay is the time required for a packet to travel from source to destination. You might have witnessed delay on the evening news when the news anchor is talking via satellite to a foreign news correspondent. Because of the satellite delay, the conversation begins to feel unnatural. |
| Jitter | Jitter is the uneven arrival of packets. For example, imagine a VoIP conversation where packet 1 arrives at a destination router. Then, 20 ms later, packet 2 arrives. After another 70 ms, packet 3 arrives, and then packet 4 arrives 20 ms behind packet 3. This variation in arrival times (that is, *variable delay*) is not due to dropped packets, but the jitter might be interpreted by the listener as dropped packets. |
| Drops | Packet drops occur when a link is congested and a router’s interface queue overflows. Some types of traffic, such as UDP traffic carrying voice packets, are not retransmitted if packets are dropped. |

Fortunately, QoS features available on many routers and switches can recognize important traffic and then treat that traffic in a special way. For example, you might want to allocate 128 Kbps of bandwidth for your VoIP traffic and give that traffic priority treatment.

Consider water flowing through a series of pipes with varying diameters. The water’s flow rate through those pipes is limited to the water’s flow rate through the pipe with the smallest diameter. Similarly, as a packet travels from source to destination, its effective bandwidth is the bandwidth of the slowest link along that path. For example, in [Figure 2-18](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig18), notice that the slowest link speed is 256 Kbps. This weakest link becomes the effective bandwidth between client and server.

![](../images/02fig18.jpg)


**Figure 2-18** Effective Bandwidth of 256 Kbps

Because the primary challenge of QoS is a lack of bandwidth, the logical question is, “How do we increase available bandwidth?” A knee-jerk response to that question is often “Add more bandwidth.” However, more bandwidth often comes at a relatively high cost.

Think of your network as a highway system in a large city. During rush hour, the lanes of the highway are congested; during other periods of the day, the lanes might be underutilized. Instead of just building more lanes to accommodate peak traffic rates, the highway engineers might add a carpool lane to give higher priority to cars with two or more occupants. Similarly, you can use QoS features to give your mission-critical applications higher-priority treatment in times of network congestion.

#### Time to Live (TTL)

![](../images/key_topic_icon_158.jpg)

As you will learn more about in [Chapter 9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09), “[Routing Technologies](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09),” a key function in the modern network is to provide a [***time to live (TTL)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_701) for communication packets. The TTL function plays a crucial role in preventing packets from circulating endlessly and potentially congesting the network. TTL is a field in the header of IP packets that indicates the maximum number of hops, or network devices, that a packet can pass through before being discarded. As a packet travels through a network, each router it encounters decrements the TTL value by one. If the TTL reaches zero before the packet reaches its destination, the router discards the packet and sends an Internet Control Message Protocol (ICMP) message back to the sender, notifying them of the packet’s expiration. This is just one of the many functions our networks simply could not live without.

### Real-World Case Study

Acme, Inc. is growing dramatically and has decided to build a new headquarters from scratch. This has presented Acme with the opportunity to implement a modernized infrastructure with some of the latest physical and virtual appliances.

Acme, Inc. plans to deploy high-performance routers and switches throughout the facility to facilitate fast and reliable data transmission. These devices form the backbone of Acme’s network, ensuring seamless connectivity between different departments and locations.

Security of the HQ network has become a growing concern. As such, next-generation firewalls (NGFWs) will be deployed to protect Acme’s network from cyber threats such as malware, ransomware, and unauthorized access. Advanced intrusion detection and prevention systems will also be implemented to monitor network traffic in real time and mitigate potential security breaches.

Inside the new HQ building, a few of the users will have corporate-issued mobile devices designed to help facilitate work tasks. To accommodate network access for these mobile users, wireless APs, which are physically connected through cabling to the switches on each floor, will be used. To consolidate hardware, multilayer switches will be used to provide not only Layer 2 forwarding of frames based on MAC addresses but also Layer 3 forwarding of packets based on IP addresses (routing).

Acme, Inc. also plans to support a dedicated storage area network to provide centralized storage for Acme’s critical data and applications. This should allow for efficient data management, backup, and recovery while ensuring high availability and scalability.

Finally, a robust VPN will also be installed in the new headquarters facility to allow users who are connected to the Internet from their home or other locations to build a secure VPN remote access connection to the corporate headquarters. Instead of buying a dedicated VPN device, Acme, Inc. is going to use a firewall that has this VPN capability integrated as part of its services.

### Summary

Here are the main topics covered in this chapter:

- This chapter contrasted the roles of various networking device infrastructure components, including switches, routers, and wireless LAN controllers.
- This chapter provided examples of specialized network devices and explained how they can enhance a network. These devices included firewalls, proxy servers, and IPS and IDS devices.
- This chapter presented some of the popular applications and functions found in modern networks today, such as content delivery networks (CDNs), virtual private networks (VPNs), and quality of service (QoS).

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 2-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02tab03) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 2-3** Key Topics for [Chapter 2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| [Figure 2-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig01) | Router Broadcast and Collision Domains | 37 |
| [Figure 2-12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig12) | Switch Collision and Broadcast Domains | 44 |
| [Figure 2-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig13) | Multilayer Ethernet Switch | 44 |
| [Figure 2-14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig14) | Firewall | 45 |
| [Figure 2-15](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig15) | IDS/IPS Network Placement | 47 |
| List | Approaches to detecting malicious traffic | 47 |
| [Figure 2-16](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02fig16) | Proxy Server Operation | 50 |
| Section | Storage Area Networks (SANs) | 51 |
| [Table 2-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02tab01) | Networking Device Summary | 53 |
| [Table 2-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02tab02) | Three Categories of Quality Issues | 56 |
| Section | Time to Live (TTL) | 57 |

### Complete Tables and Lists from Memory

Print a copy of [Appendix B](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb), “[Memory Tables](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb),” or at least the section for this chapter, and complete as many of the tables as possible from memory. [Appendix C](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc), “[Memory Tables Answer Key](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc),” includes the completed tables and lists so you can check your work.

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[access point (AP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_01)

[content delivery network (CDN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_02)

[firewall](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_03)

[intrusion detection system (IDS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_04)

[intrusion prevention system (IPS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_05)

[Layer 2 Ethernet switch](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_06)

[Layer 3 capable switch](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_07)

[load balancer](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_08)

[multilayer switch](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_09)

[network-attached storage (NAS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_010)

[proxy server](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_011)

[quality of service (QoS)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_012)

[router](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_013)

[storage area network (SAN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_014)

[switch](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_015)

[time to live (TTL)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_016)

[virtual private network (VPN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_017)

[wireless LAN controller (WLC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#key_018)

### Additional Resources

**What a Switch in Networking:** <https://youtu.be/NDVImep5UBI?si=KfJYEgAwZuh1023g>

**Hub, Switch, & Router Explained:** <https://youtu.be/1z0ULvg_pW8?si=7PUV83vMuy8AWqsr>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_1) A router operates at what layer of the OSI model?

1. Layer 1
2. Layer 2
3. Layer 3
4. Layer 4

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_2) Which network infrastructure device primarily makes forwarding decisions based on Layer 2 MAC addresses?

1. Router
2. Switch
3. Hub
4. Multilayer switch

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_3) A router primarily makes its forwarding decisions based on what address?

1. Destination MAC address
2. Source IP address
3. Source MAC address
4. Destination IP address

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_4) What does a switch do by default when it receives a frame that possesses an unknown destination MAC address?

1. The switch floods the frame out all ports, except the port on which it was received.
2. The switch drops the frame.
3. The switch buffers the frame.
4. The switch returns the frame to the device that originated it.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_5) In a router that has 12 ports, how many broadcast domains does the router have?

1. None
2. 1
3. 2
4. 12

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_6) In a switch that has 12 ports, how many collision domains does the switch have?

1. None
2. 1
3. 2
4. 12

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_7) What device is used to connect wireless clients to the wireless and wired networks within an organization?

1. Firewall
2. Controller
3. Load balancer
4. Access point

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_8) What networking device often uses signatures to help protect a network from known malicious attacks?

1. Wireless LAN controller
2. Switch
3. Proxy server
4. IPS

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_9) What device can act as both a content cache and a URL filter and is typically configured in the client browser of an end-user system?

1. Wireless LAN controller
2. Access point
3. Proxy server
4. IPS

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_10) You are using a network firewall in your enterprise infrastructure. This firewall requires you to define which connections are permitted outbound. Once you do so, the appropriate and expected return data flows are dynamically allowed through the firewall. What firewall characteristic does this scenario describe?

1. Stateless
2. Stateful
3. Deterministic
4. Zone-based

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_11) Which of the following is a network device that continually scans the network looking for attack activity and can actually stop potential threats?

1. IDS
2. IPS
3. Load balancer
4. FCoE

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_12) Which of the following is a specialized type of storage device that is designed to provide centralized storage and file sharing capabilities to multiple users and devices within a network?

1. NAS
2. Access point
3. Controller
4. WLC

[**13.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz2_13) Which of the following network functions enables administrators to better predict bandwidth use, monitor that usage, and control the usage to ensure that bandwidth is available to the applications that need it?

1. Firewall
2. QoS
3. CDN
4. TTL