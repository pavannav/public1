## Appendix A

## Answers to Review Questions

### Chapter 1

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#rquiz1_1) **d.** The data link layer of the OSI model is the only layer of the famous model that is typically divided into sublayers (the MAC and LLC sublayers).

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#rquiz1_2) **b.** Baseband technology uses the entire medium to transmit. In contrast, broadband technology can divide the medium into different channels. A great example of broadband is the use of the coaxial cable you might have in your home, which carries cable television signals as well as high-speed Internet.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#rquiz1_3) **c.** The transport layer offers TCP and UDP. With TCP, a connection-oriented protocol, windowing can be used to dictate how much data is sent at one time.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#rquiz1_4) **a.** An IP address is a typical ingredient at the network layer (Layer 3) of the OSI model. Routers use these addresses to route traffic through an internetwork.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#rquiz1_5) **c.** User Datagram Protocol (UDP) sacrifices reliability for speed and efficiency in the transport of data.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#rquiz1_6) **b.** The maximum transmission unit (MTU) is the network interface setting that defines the largest packet that may be sent onto the network.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#rquiz1_7) **b.** The well-known port numbers are all below 1024. An example would be HTTP (WWW) at port 80.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#rquiz1_8) **b.** HTTPS uses TCP port 443 in its operation. Contrast this to HTTP (that offers no security) and uses port 80.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#rquiz1_9) **c.** The Time-to-Live (TTL) value of the IP packet is decremented for each router hop. This is a loop prevention mechanism.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#rquiz1_10) **d.** The connection-oriented TCP uses several techniques to ensure reliability in the communications. Windowing is one of those.

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#rquiz1_11) **b.** As data moves down through the OSI model layers (on a host), it is encapsulated with a header added to the beginning and a trailer to the end. When the data arrives at the receiving host, it moves up the model and is decapsulated in that the header and trailer are stripped off as it moves up though the OSI layers.

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#rquiz1_12) **d.** The data link layer is concerned with packaging data into frames and ensuring that frames do not exceed the maximum transmission unit (MTU) of the physical media.

### Chapter 2

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_1) **c.** Routers operate at the network layer (Layer 3) of the OSI model.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_2) **b.** The best answer here is switch because, unlike a multilayer switch, this device must use MAC addressing for frame forwarding.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_3) **d.** Routers make their forwarding decisions using IP addresses at Layer 3 of the OSI model. Specifically, the destination IP address is the key piece of information used by default.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_4) **a.** When a switch receives a frame destined for an unknown MAC address, the switch floods the frame out of all the ports on the device, except for the port that received the frame.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_5) **d.** A router creates a broadcast domain on each of the router (Layer 3) ports.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_6) **d.** A switch creates a collision domain on each port by default.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_7) **d.** An access point allows wireless clients to connect to the wireless (and potentially) wired network.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_8) **d.** An intrusion prevention system (IPS) typically uses signatures to identify common network attacks.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_9) **c.** A proxy server caches content and improves performance. It can also include permit and deny lists for Internet locations.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_10) **b.** A stateful firewall has the ability to examine outbound connections and dynamically permit the appropriate inbound responses.

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_11) **b.** An intrusion prevention system (IPS) is a network device that can continually scan the network looking for attack activity. An IPS can stop potential threats. Note that an IDS can identify potential attacks, but it responds by notifying administrators of the attack activity.

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_12) **a.** Network-attached storage (NAS) is a specialized type of storage device that is designed to provide centralized storage and file sharing capabilities to multiple users and devices within a network. Unlike traditional storage solutions that are directly attached to individual computers, NAS devices connect to a local area network or wide area network, allowing them to be accessed by any device connected to the network.

[**13.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#rquiz2_13) **b.** Quality of service (QoS) includes strategies used to manage and increase the flow of network traffic. QoS features enable administrators to predict bandwidth use, monitor that use, and control it to ensure that bandwidth is available to the applications that need it.

### Chapter 3

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#rquiz3_1) **c.** A network security group (or simply security group) seeks to control traffic into and out of virtual machines in the cloud. These security groups are assigned to virtual network interfaces of virtual machines and function as simple, yet powerful, firewalls.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#rquiz3_2) **a.** A public cloud provider services many clients from a single large infrastructure.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#rquiz3_3) **c.** Platform as a service (PaaS) is targeted at developers. This cloud service seeks to provide everything the developers need to test and deploy applications.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#rquiz3_4) **b.** Elasticity refers to the ability to scale resources based on demand. For example, virtual machines might be dynamically added to a pool of servers or removed, based on demand at different times.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#rquiz3_5) **b, c.** Companies that are concerned about data security as they send and receive data from the cloud often use a VPN or a direct private connection to provide strong security for the transfer of this data.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#rquiz3_6) **b.** Multitenancy refers to physical servers in the public cloud infrastructure hosting workloads for multiple customers.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#rquiz3_7) **a.** The AWS Virtual Private Cloud (VPC) lets you provision a logically isolated section of the AWS Cloud where you can launch AWS resources in a virtual network that you define. You have complete control over your virtual networking environment, including the selection of your IP address range, creation of subnets, and configuration of route tables and network gateways.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch03.xhtml#rquiz3_8) **d.** With software as a service (SaaS), the details of the servers are hidden from the customer, and the customer’s experience is similar to the experience of using a web-based application. Examples of SaaS include Gmail and Microsoft 365.

### Chapter 4

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#rquiz4_1) **b.** The Secure Shell (SSH) protocol allows you to make secure remote connections to network systems. This protocol is specialized for terminal connections. For graphical user interface connections, you can use technologies such as Remote Desktop Protocol (RDP) and VNC Viewer.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#rquiz4_2) **d.** Dynamic Host Configuration Protocol (DHCP) is used to dynamically assign IP address information to network systems (typically end-user devices).

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#rquiz4_3) **d.** Domain Name System (DNS) is a global hierarchy system that resolves domain names to IP addresses.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#rquiz4_4) **a, c.** Hypertext Transfer Protocol Secure (HTTPS) uses TCP port 443 in its operation.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#rquiz4_5) **b, d.** Syslog produces machine data that you can use to monitor and understand the state of services on a device. Syslog runs on UDP port 514.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#rquiz4_6) **c.** Internet Control Message Protocol (ICMP) is used by many troubleshooting and monitoring tools. ping and traceroute are two such ICMP-based utilities.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#rquiz4_7) **c.** The port number typically used for SSH (Secure Shell) is 22.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#rquiz4_8) **c.** The Internet Key Exchange (IKE) protocol is used to negotiate cryptographic keys and security parameters for establishing secure IPsec connections, ensuring that both parties agree on the encryption and authentication methods before data transmission.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#rquiz4_9) **c.** In IPv4 networking, broadcast traffic is used to send data to all devices within a local network segment, using the special destination address 255.255.255.255. This address directs the packet to all devices on the network, ensuring that every node receives the information. However, in IPv6, broadcast traffic is no longer supported due to the inefficiency and security concerns associated with broadcasting.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#rquiz4_10) **d.** Remote Desktop Protocol (RDP) is a Microsoft protocol that allows a user to view and control the desktop of a remote computer. RDP uses TCP port 3389.

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch04.xhtml#rquiz4_11) **b.** Multicast is a mechanism by which groups of network devices can send and receive data between the members of the group at one time (one-to-many), instead of separately sending messages to each device in the group.

### Chapter 5

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_1) **b, c.** Cat 5e and Cat 6 are often used for Fast Ethernet networks.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_2) **b.** Plenum cable is a special type of cable for use in the plenum spaces.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_3) **b.** The RJ45 connector uses eight pins and is the most common connector used in Ethernet networks.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_4) **b, d.** The two major categories of fiber-optic media are single-mode and multimode.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_5) **b.** Fast Ethernet operates at 100Mbps.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_6) **d.** Fibre Channel is a network technology often found in storage area networks (SANs). Its focus is fast and reliable transfers of data in the SAN.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_7) **c.** Cat 5e is an enhanced version of Cat 5. Cat 5e was the first standard for 1Gbps Ethernet.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_8) **c.** The 802.11ax standard has also been named Wi-Fi 6 to help typical consumers better identify the latest Wi-Fi technologies. 802.11ac is also known as Wi-Fi 5.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_9) **b, d.** To define industry-standard pinouts and color coding for twisted-pair cabling, the TIA/EIA-568 standard was developed. The first iteration of the TIA/EIA-568 standard has come to be known as the TIA/EIA-568A standard, and since then, an updated standard called TIA/EIA-568B has been released. TIA/EIA-568B is the more commonly used standard in the United States today.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_10) **a.** 1000BASE-LX uses single-mode fiber (SMF), has a bandwidth capacity of 1Gbps, and has a distance limitation of 5 km.

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_11) **d.** Nonoverlapping channels are a set of wireless frequency channels that do not interfere with each other. For example, in the 2.4GHz band channels 1, 6, and 11 are commonly considered nonoverlapping channels for Wi-Fi networks.

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_12) **b.** MU-MIMO is a set of advanced MIMO technologies included with IEEE 802.11ac and 802.11ax that dramatically enhances wireless throughput.

[**13.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_13) **a.** Single-mode fiber (SMF) is a type of fiber that uses a single direct beam of light, thus allowing for greater distances and increased transfer speeds.

[**14.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#rquiz5_14) **d.** Cat 8 is capable of 40Gbps speeds. It supports distances of only 30 to 36 m, depending on the patch cables used. These short distances and very high speeds are ideal for connections in a data center between high-speed multilayer switches.

### Chapter 6

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_1) **d.** A local area network (LAN) most often consists of Ethernet connections as defined in IEEE 802.3.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_2) **c.** Actual traffic flows dictate the logical topology that is in use within a network.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_3) **d.** The core layer is most concerned with raw speed.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_4) **b.** Each leaf device connects to each and every spine device to provide a full mesh of all the leaves for every spine.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_5) **d.** A metropolitan area network is superb for connecting various buildings in a citywide area. Metro Ethernet is one example of connectivity technology for this design.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_6) **c.** A personal area network features fewer nodes than are typically found in a LAN. This design also features a small geographic area, such as a car or a single-room office.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_7) **c.** The star topology is common today in switched LANs. However, it does feature quite a bit of cabling, as the switches require media to each and every node (wired) that needs to communicate. There are also typically trunk connections between the switches for an extended star topology, and this means even more cabling.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_8) **a.** The full-mesh topology might be complex and expensive to implement, but it does provide excellent levels of redundancy. In the event that one or more links fail, it is often possible to reroute traffic around the failures.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_9) **b.** The formula for the number of connections required for the full-mesh topology is *n*(*n* – 1) / 2, where *n* is the number of nodes. So, in this case, 5 (5 – 1) / 2 is 10.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_10) **a, c.** The hub-and-spoke topology is actually a form of a partial-mesh topology. This topology has the advantage of being less complex, less costly, and, overall, more scalable than a full-mesh design.

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_11) **c.** A peer-to-peer network features clients sharing information directly with each other.

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_12) **b.** Peer-to-peer networks are often celebrated for their simplicity and low cost. Unfortunately, these networks are not scalable and can actually cause administrative nightmares when scaling is required.

[**13.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_13) **d.** The storage area network (SAN) assists when large amounts of data must be stored in the network and transferred efficiently from various nodes to other nodes.

[**14.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_14) **a.** East–west traffic flows occur primarily between servers or services deployed within the same data center or cloud environment. North–south traffic flows involve traffic moving between clients or end users and servers or services hosted in the data center or cloud.

[**15.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch06.xhtml#rquiz6_15) **b, c, d.** The three-tier hierarchical model is built with three layers: the access layer (which is the layer closest to the end users), the distribution layer, and the core layer, which is responsible for moving massive amounts of data in an enterprise network—often between a data center (or even data centers) and the main employee locations. There is no intermediate layer in the three-tier hierarchical model.

### Chapter 7

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#rquiz7_1) **b.** The binary representation of 117 is 01110101 (based on 117 = 64 + 32 + 16 + 4 + 1).

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#rquiz7_2) **d.** 10110100 is the equivalent of 180 because 128 + 32 + 16 + 4 = 180.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#rquiz7_3) **a.** Because the decimal value 10 appears in the first octet, this is a Class A address.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#rquiz7_4) **a.** The classful subnet mask for a Class B IPv4 address features 16 bits and is represented as 255.255.0.0 in dotted-decimal notation.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#rquiz7_5) **d.** The Dynamic Host Configuration Protocol (DHCP) is a dynamic method of IP address assignment.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#rquiz7_6) **a.** There are 5 bits left here for host address assignment, and 2 raised to the fifth power is 32. You then subtract 2 for the network ID and broadcast address. That is, 25 – 2 = 30.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#rquiz7_7) **c.** /28 is the prefix notation for 255.255.255.240. Notice that the mask consists of 8 bits + 8 bits + 8 bits + 4 bits.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#rquiz7_8) **c.** Using a /27 mask gives you 3 bits for subnetting. This permits the creation of eight subnets and satisfies your requirement of seven subnets and gives you the most possible host addresses per subnet.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#rquiz7_9) **a.** The host address and subnet mask combination of 172.16.18.5/18 references the 172.16.0.0/18 subnet. The usable host IP range is 172.16.0.1–172.16.63.254.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#rquiz7_10) **c.** Classless inter-domain routing (CIDR) shortens a classful subnet mask by removing 1s from the mask.

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#rquiz7_11) **a.** The 127.x.x.x network range is reserved for the loopback function. It is not one of the recognized private address ranges. The private address ranges as defined in RFC1918 are 10.x.x.x, 172.16.x.x to 172.31.x.x, and 192.168.x.x.

### Chapter 8

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#rquiz8_1) **b.** Border Gateway Protocol (BGP) is an exterior gateway protocol used to share prefixes across the Internet. It can also be used to route internally for very large organizations, and it is an example of a control plane technology in the SDN design.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#rquiz8_2) **d.** Transport agnostic refers to the capability of the network to seamlessly route and manage traffic over diverse transport media such as MPLS, broadband, LTE, and satellite, without dependency on the underlying physical connections.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#rquiz8_3) **a.** User Datagram Protocol (UDP) plays a crucial role in Virtual Extensible LAN (VXLAN) environments by serving as the transport protocol for encapsulating Layer 2 Ethernet frames within Layer 3 IP packets, enabling the creation of scalable and flexible virtual networks over existing IP infrastructure.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#rquiz8_4) **b.** Configuration drift occurs when the actual state of the infrastructure deviates from the desired state defined in the IaC. This can happen due to manual changes, system updates, or environmental factors. Automation in IaC helps mitigate configuration drift by regularly applying the desired state to the infrastructure. Tools like Terraform and Ansible can perform periodic checks and reapply configurations to ensure consistency.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#rquiz8_5) **c.** Remember, you can drop the leading zeros in any field, and one time within an address, you can use the shorthand symbol :: to represent continuous sections of zeros.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#rquiz8_6) **b.** EUI-64 in IPv6 permits the automatic generation of host portions of addresses.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#rquiz8_7) **a.** IPv6 networks use stateless address autoconfiguration (SLAAC) to assign IP addresses. With SLAAC, a device sends the router a request for the network prefix, and then the device uses the prefix along with its own MAC address to create an IP address.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#rquiz8_8) **d.** Secure Access Secure Edge (SASE) is a network architecture that integrates wide area networking (WAN) capabilities with comprehensive network security functions such as Secure Web Gateway (SWG), Cloud Access Security Broker (CASB), Firewall as a Service (FWaaS), and Zero Trust Network Access (ZTNA) into a unified, cloud-native service model to securely connect users, systems, and endpoints to applications and services.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#rquiz8_9) **c.** One of the primary applications of VXLAN is in data center interconnect (DCI). DCI involves connecting multiple data centers to provide a unified infrastructure, allowing for efficient resource sharing, workload mobility, and disaster recovery. VXLAN is particularly suited for DCI because it enables the extension of Layer 2 networks over Layer 3 distances, thus facilitating the seamless migration of VMs and applications between data centers.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch08.xhtml#rquiz8_10) **a.** NAT64 (Network Address Translation from IPv6 to IPv4) is a technology that facilitates communication between IPv6-only clients and IPv4-only servers, bridging the gap between the two distinct IP address families. It is yet another component in the transition from the older IPv4 protocol to the newer IPv6 protocol, allowing IPv6 networks to access resources on IPv4 networks without requiring the end systems to support both protocols.

### Chapter 9

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#rquiz9_1) **b.** Note that the destination IP address does not change in the packet. However, as the router sends the frame out the exit interface heading toward the destination, it will update the destination MAC address to the next hop/device.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#rquiz9_2) **d.** Address Resolution Protocol (ARP) is one of the many name resolution protocols we deal with. In this case, the names are Layer 2 and Layer 3 addresses.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#rquiz9_3) **d.** The default route is 0.0.0.0/0.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#rquiz9_4) **c.** The better the administrative distance, the more believable the protocol. Lower is better for the AD score.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#rquiz9_5) **b, c.** Split horizon and poison reverse are critical loop prevention techniques for early routing protocols.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#rquiz9_6) **c.** Routing Information Protocol (RIP) cannot be used in large networks due to a maximum hop count of 15.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#rquiz9_7) **a.** Border Gateway Protocol (BGP) is the exterior gateway protocol (EGP) that makes the Internet a reality.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#rquiz9_8) **a.** The IP address assigned to the physical outside interface is the IP address that is often the basis for the port address translation (PAT) configuration. Many different internal IP addresses (inside) can be translated into this single address.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#rquiz9_9) **b.** Network address translation (NAT) allows private IP addresses (as defined in RFC1918) to be translated into Internet-routable IP addresses (public IP addresses).

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#rquiz9_10) **c.** The Hot Standby Router Protocol (HSRP) is a Cisco-proprietary approach to first hop redundancy. This technology permits the identification of an active and standby router or routers that all respond to a virtual IP address on the network used as the default gateway.

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#rquiz9_11) **d.** Administrative distance (AD) is a value used by routers to determine the trustworthiness or reliability of routing information received from various sources. It is a numerical value assigned to routing protocols or static routes, where a lower administrative distance indicates higher preference or priority.

### Chapter 10

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#rquiz10_1) **a.** A 1000BASE-T Ethernet network has a distance limitation of 100 m.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#rquiz10_2) **d.** A random back-off timer is used in a CSMA/CD network when a collision is detected.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#rquiz10_3) **a, b.** Virtual LANs (VLANs) are also IP subnets. A router must route between these subnets. The VLAN is also a broadcast domain.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#rquiz10_4) **a.** The 802.1Q native VLAN is the only VLAN in a Layer 2 domain that is not tagged.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#rquiz10_5) **b.** The designated port is forwarding, and there must be one on every network segment. Remember that all root ports are designated by default.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#rquiz10_6) **b.** 802.3ad is the open-standard version of link aggregation.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#rquiz10_7) **b.** The IEEE 802.3af standard specifies 15.4W as the maximum amount of power a switch is allowed to provide per port.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#rquiz10_8) **b.** The Link Aggregation and Control Protocol (LACP) permits administrators to bundle interfaces on the switch together, adding to the redundant capabilities of modern switches.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#rquiz10_9) **d.** Full-duplex is a system in which data simultaneously transmits in two directions. In half-duplex, data is transmitted in both directions but not simultaneously.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#rquiz10_10) **a.** A Switch Virtual Interface (SVI), also known as a VLAN interface, is a virtual interface configured on a Layer 2 switch to enable routing between VLANs.

### Chapter 11

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_1) **d.** The key to this question is the fact that power is being radiated in all directions relatively equally.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_2) **b, d, f.** The non-overlapping channels in the United States are 1, 6, and 11.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_3) **a.** The 802.11h amendment enhances wireless networking by introducing mechanisms for dynamic frequency selection (DFS) and transmit power control (TPC).

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_4) **d.** Lightweight access points are used in conjunction with wireless LAN controllers by offloading their management functions to the WLCs, allowing the APs to handle only the transmission and reception of wireless signals, while the WLCs centrally manage tasks such as security policies, configuration, and network management, leading to simplified deployment and maintenance of large-scale wireless networks.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_5) **b.** A captive portal on a guest Wi-Fi network is a web page that users are automatically redirected to upon connecting, where they must authenticate or accept terms of service before gaining access to the Internet.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_6) **b.** An independent basic service set (IBSS) is formed directly between wireless clients.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_7) **b.** The recommended amount of overlap is 10% to 15%.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_8) **c.** Open authentication permits the use of the wireless LAN with no credentials. This is useful in a public, free Wi-Fi hotspot or in a guest area in an enterprise.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_9) **a.** Band steering is a feature in Wi-Fi networks that directs dual-band-capable devices to connect to the less congested 5GHz band instead of the more crowded 2.4GHz band, enhancing overall network performance and reducing interference.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_10) **d.** The IEEE 802.11i requirements are found in WPA2.

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_11) **d.** Geofencing permits the creation of a boundary for administrative alerts and actions.

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_12) **a, b, d.** Two versions of WPA2 exist: WPA2 Personal and WPA2 Enterprise. WPA2 Personal protects unauthorized network access via a password. WPA2 Enterprise verifies network users through a server. WPA2 Personal uses pre-shared keys. WPA3 also includes both a Personal and Enterprise version. WPA3 maintains equivalent cryptographic strength through the required use of 192-bit AES for the Enterprise version, and optional 192-bit AES for the Personal version.

[**13.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_13) **a.** To improve the security of your network, change the service set identifiers (SSIDs) on your access points (APs). Using the default SSID poses a security risk even if the AP is not broadcasting it. When changing default SSIDs, do not change the SSID to reflect your company’s main names, divisions, products, or address. This simply makes you an easy target for attacks such as war driving, war chalking, and war flying.

[**14.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#rquiz11_14) **b.** 802.1X is an Institute of Electrical and Electronics Engineers (IEEE) standard for port-based access control and provides a method for authenticating a device to another system via an authentication server. 802.1X specifically provides for the encapsulation of Extensible Authentication Protocol (EAP) over the IEEE family of standards for packet-based networks. The standard essentially facilitates the use of various authentication methods such as RADIUS and digital certificates.

### Chapter 12

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#rquiz12_1) **d.** A patch panel is a hardware device that provides a central point for organizing and connecting incoming and outgoing network cables, allowing for easy management and reconfiguration of network connections.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#rquiz12_2) **b.** Equipment rack sizes are typically expressed in units, where one unit is 1.75 inches.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#rquiz12_3) **c.** When it comes to the distribution of power, power distribution units (PDUs) are devices that distribute electrical power to networking equipment within a rack or a network room.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#rquiz12_4) **a.** Power load refers to the total electrical power consumed by networking equipment in a physical installation.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#rquiz12_5) **d.** Uninterruptible power supplies are crucial for maintaining network reliability and continuity in the event of power disruptions. UPS systems provide backup power to critical networking equipment, such as servers, switches, and routers, allowing them to continue functioning during power outages.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch12.xhtml#rquiz12_6) **b.** The main distribution frame (MDF) is the primary wiring closet for a network that typically holds the majority of the network gear, including routers, switches, wiring, servers, and more. This is also typically the wiring closet where outside lines run into the network.

### Chapter 13

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#rquiz13_1) **c.** The Layer 3 network diagram focuses on details associated with the network layer of the OSI model. This layer would include such details as IP addresses and IP connectivity.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#rquiz13_2) **b.** IP address management (IPAM) refers to the systematic administration of IP addresses, ensuring efficient allocation, tracking, and maintenance within a network environment.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#rquiz13_3) **a.** A service-level agreement (SLA) is a formal contract between a service provider and a customer that outlines the agreed-upon level of service, including performance metrics and responsibilities.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#rquiz13_4) **d.** EOL (end-of-life) and EOS (end-of-support) dates are often critical components in life-cycle management, as they provide clear timelines for when products or systems will no longer receive updates, security patches, or vendor support, prompting organizations to plan for replacements or upgrades to maintain operational efficiency and security compliance.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#rquiz13_5) **b.** Disposal is often the last stage of a system life cycle, where outdated or decommissioned hardware and software are securely and responsibly discarded or recycled to ensure data protection and environmental compliance.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#rquiz13_6) **d.** A baseline/golden configuration is a predefined and standardized template or ideal state of configuration settings for hardware, software, or network devices, used as a reference to ensure consistency, security, and compliance across an organization’s IT environment.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#rquiz13_7) **a, d.** Wireless surveys and heat maps are often integral components of the IT documentation in modern organizations, providing a detailed visual representation and analysis of wireless network coverage and performance across various locations. A wireless survey involves assessing the physical environment to identify optimal placement of wireless access points, detect signal interference, and measure signal strength and quality. The resulting heat maps visually depict these findings, using color gradients to represent signal strength, coverage areas, and potential dead zones, enabling IT professionals to pinpoint areas with weak or no signal and optimize the network layout accordingly.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#rquiz13_8) **b.** An asset inventory in an IT department’s documentation is a comprehensive catalog of the organization’s technology assets, encompassing hardware, software, licensing, and warranty support.

### Chapter 14

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#rquiz14_1) **b.** The management information base (MIB) is a database filled with variables that represent the metrics of the managed network devices.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#rquiz14_2) **b.** The Critical syslog level is Level 2, the most severe level.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#rquiz14_3) **a, c, d.** The put method is used with HTTP. SNMP uses get, set, and trap messages—among others.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#rquiz14_4) **d.** Jitter, which is variation in delay, can be a large problem for VoIP networks.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#rquiz14_5) **a.** The noAuthNoPriv security level of SNMPv3 is like the community string approach of SNMPv2c.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#rquiz14_6) **d.** Syslog level 6 is for informational messages. Note that the lowest level, level 7, is used for debugging messages.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#rquiz14_7) **a.** NetFlow often uses a flow collector, which can be a single-purpose device on a network for storing, backing up, and making logs available to the authorized staff.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#rquiz14_8) **d.** SNMPv3 introduced significant improvements in security, offering authentication, encryption, and access control mechanisms to protect SNMP communications. SNMPv3 is the latest and most secure version of SNMP and allows for the use of strong cryptographic algorithms, such as HMAC-SHA, HMAC-MD5, and AES, to ensure data integrity and confidentiality.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#rquiz14_9) **a.** When a network device sends packets, there will be serialization delay, propagation delay, processing delay, and probably even more types of delay. You need to take baseline measurements so you can understand the latency in your network.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#rquiz14_10) **c.** Some switches support a port mirroring feature, which makes a copy of traffic seen on one port and sends that duplicated traffic out another port (to which a network sniffer could be attached). This allows a network sniffer to capture the packets that need to be analyzed.

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#rquiz14_11) **d.** Performance monitoring solutions are designed to continuously track and evaluate the efficiency and effectiveness of various components within an IT infrastructure, including servers, applications, networks, and databases. These solutions collect and analyze data on key performance indicators (KPIs) such as response time, throughput, and resource utilization, providing real-time insights and historical trends.

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch14.xhtml#rquiz14_12) **c.** Log aggregation is the process by which security information and event management (SIEM) systems combine similar events to reduce event volume. SIEMs can aggregate data into log format from many network sources and consolidate the data so that crucial events are not missed.

### Chapter 15

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#rquiz15_1) **b.** Five nines availability means 99.999% uptime and translates into about 5 minutes of downtime per year.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#rquiz15_2) **c.** The active-passive design uses one NIC that is actually active and able to pass traffic. The other NIC is in a passive (often called standby) state.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#rquiz15_3) **a.** A content engine permits the caching of key data to which clients need low-latency access.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#rquiz15_4) **c.** A snapshot is typically a complete point-in-time, read-only copy of data.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#rquiz15_5) **c.** A hot site is often the ultimate goal of a disaster recovery design. A hot site would be able to provide full-service levels with virtually no downtime after a disaster occurs.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#rquiz15_6) **a.** Equal-cost multipathing (ECMP) enables routing protocols to distribute traffic among different available paths in the network. This is very advantageous, especially compared to classic Layer 2 designs that feature STP, which blocks redundant paths in order to prevent loops.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#rquiz15_7) **d.** The mean time between failures (MTBF) is the average amount of time that passes between hardware component failures, excluding time spent repairing components or waiting for repairs.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#rquiz15_8) **b.** A cold site is the weakest of the recovery sites but also the least costly. However, although a cold site may be the least costly when you’re planning for disaster, after a disaster occurs, equipment purchased for a cold site might be expensive or difficult to obtain.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#rquiz15_9) **b, c, d.** The difference between incremental and differential backups is that differential backups include all data that has changed since the full backup. Therefore, answer a is the only false statement.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#rquiz15_10) **d.** In an active-active, high-availability disaster recovery setup, multiple redundant systems are simultaneously active and operational, serving incoming requests or processing tasks. In this configuration, each system is capable of independently handling the workload, providing load balancing and fault tolerance.

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch15.xhtml#rquiz15_11) **b.** Tabletop exercises are simulated, discussion-based sessions used to test and evaluate an organization’s disaster recovery plans. During these exercises, key stakeholders and team members gather to walk through hypothetical disaster scenarios, such as cyberattacks, natural disasters, or system failures, and discuss their roles, responsibilities, and responses.

### Chapter 16

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#rquiz16_1) **c.** The DHCP DISCOVER message is the first step in the four-step DHCP process (aka DORA). A client broadcasts these messages on the local subnet in an attempt to find a DHCP server.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#rquiz16_2) **b.** You often use the scope options in DHCP to set things like lease duration, as well as other pieces of IP configuration information that the client might need.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#rquiz16_3) **a.** A pointer record in DNS points to a canonical name. This record type is typically used to perform reverse lookups when required.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#rquiz16_4) **d.** The DNS TTL (time to live) dictates how long devices can cache the results of name resolutions.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#rquiz16_5) **b, e.** NTP relies on UDP port 123 in its operation.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#rquiz16_6) **b.** The stratum is a value used in NTP to provide an indicator of how many hops a client is from the NTP server.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#rquiz16_7) **d.** A DHCP scope is a range of IP addresses and configuration parameters that a DHCP server is responsible for assigning to client devices on a network.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#rquiz16_8) **b.** Stateless address autoconfiguration (SLAAC) is a method that allows devices to automatically configure their own IPv6 addresses and network settings without the need for a central DHCP server.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#rquiz16_9) **b.** AAAA is a DNS record that maps a hostname to an IPv6 address.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch16.xhtml#rquiz16_10) **a.** DNS over HTTPS (DoH) is a protocol that encrypts Domain Name System (DNS) queries and responses using the HTTPS protocol, providing privacy and security enhancements for DNS resolution and helping to prevent DNS-related attacks, such as DNS spoofing or DNS hijacking.

### Chapter 17

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#rquiz17_1) **b.** The client-to-site VPN type often features the use of a client system and its web browser and SSL/TLS to make a VPN connection. This is often considered “clientless” because the web browser is built in to the operating system, and there is no need for any separate client software installation.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#rquiz17_2) **a.** Split tunneling is a VPN configuration that enables a user to access a public network (like the Internet) and a local private network (such as a corporate network) simultaneously, directing some traffic through the VPN and other traffic directly to the Internet.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#rquiz17_3) **c.** The Secure Shell (SSH) protocol is the secure replacement technology for Telnet. Unlike Telnet, SSH offers strong security mechanisms that are in wide use today.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#rquiz17_4) **c.** A console port is a physical interface on a network device, such as a router or switch, used for direct local management and configuration via a terminal or computer, typically connected using a console cable.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#rquiz17_5) **d.** Captive portals are common in public places such as airports and coffee shops. The user simply clicks Accept, views an advertisement, provides an email address, or performs some other required action, and the network then grants access to the user and no longer holds the user captive to that portal.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#rquiz17_6) **b.** Data at rest is data that is stored or retained in a persistent storage medium, such as a hard disk drive (HDD), solid-state drive (SSD), tape drive, or optical disc, and is not actively being accessed or transmitted.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#rquiz17_7) **d.** Transport Layer Security (TLS) has largely replaced SSL as the VPN protocol of choice for providing cryptography and reliability to upper layers of the OSI model. For example, when you securely connect to a website using HTTPS, you are probably using TLS.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#rquiz17_8) **b.** In-band management is a method of managing and monitoring network devices, such as routers, switches, firewalls, and servers, using the same communication path or network infrastructure that carries user data traffic.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch17.xhtml#rquiz17_9) **a.** A jump box, also known as a jump host or bastion host, is a secure, isolated server used to provide controlled access to devices or networks in a different security zone.

### Chapter 18

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_1) **c.** Advanced Encryption Standard (AES) permits the configuration of various strength levels, including 128-, 192-, and 256-bit key versions.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_2) **a.** Integrity involves ensuring that data has not been manipulated in transit.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_3) **b.** The principle of least privilege involves giving a user account the fewest possible permissions required to do a job.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_4) **d.** A honeypot is a network device that tries to attract security attacks, allowing a network administrator to analyze the attackers and their strategies.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_5) **b.** A BYOD policy permits employees to bring their own devices like smartphones and tablets in order to make them more productive.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_6) **d.** The Common Vulnerabilities and Exposures (CVE) system is a free online resource that provides excellent search tools to leverage a large database of publicly known information security vulnerabilities and exposures.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_7) **a.** A security information and event management (SIEM) system provides real-time analysis of security alerts generated by applications and network hardware. SIEM systems can log security data and generate reports for compliance purposes.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_8) **c.** Kerberos is a client/server authentication protocol that supports mutual authentication between a client and a server. With Kerberos, a trusted third party (a key distribution center) hands out tickets that are used instead of username and password combinations.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_9) **b, c.** An automated teller machine (ATM) provides a common example of a multifactor authentication system. It requires both a “something you have” physical key (your ATM card) and a “something you know” personal identification number (PIN).

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_10) **d.** It is important to include separation of duties when planning for security policy compliance. Without this separation, all areas of control and compliance could end up in the hands of a single individual.

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_11) **a.** Motion detection can certainly help with physical security, but it is a technique used in detection, not prevention.

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_12) **d.** Biometrics is an excellent form of a physical security control; however, this control is considered a prevention method and not a detection method.

[**13.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_13) **a, b.** PKI uses digital certificates and a certificate authority (CA) for authentication and encryption services.

[**14.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_14) **c.** A zero-day attack or threat is a computer threat that tries to exploit computer application vulnerabilities that are unknown to others—even the software developer. Those weaknesses are also called zero-day vulnerabilities. Zero-day exploits involve using software to exploit security holes to carry out attacks; attackers carry out these exploits or share information about them before the developer of the target software knows about the vulnerability.

[**15.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_15) **b.** An access control vestibule (formerly known as a mantrap) is a small entry area with two interlocking doors that provides assurance that tailgating and piggybacking forms of social engineering cannot take place.

[**16.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch18.xhtml#rquiz18_16) **d.** The General Data Protection Regulation (GDPR) is a set of rules created to protect the privacy and personal data of individuals in the European Union. It gives people more control over their personal information and requires organizations to be transparent about how they collect, store, and use this data. GDPR applies to any business, regardless of location in the world, that processes the data of EU citizens.

### Chapter 19

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch19.xhtml#rquiz19_1) **d.** A VLAN hopping attack leverages two technologies in its operation: Q-in-Q tunneling and the native VLAN feature.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch19.xhtml#rquiz19_2) **d.** A distributed denial-of-service (DDoS) attack involves leveraging many systems to compromise the availability of a system.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch19.xhtml#rquiz19_3) **c.** Tailgating is a social engineering attack in which an authorized user permits an unauthorized user to access an area or systems. The unauthorized user may follow closely behind the authorized user through some type of security checkpoint.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch19.xhtml#rquiz19_4) **d.** In a brute-force password attack, the attacker tries all possible password combinations until a match is made. For example, a brute-force attack might start with the letter a and go through the letter z, and then the attacker might attempt the letters aa through zz, continuing to try combinations until the password is determined. Using complicated passwords—with a mixture of upper- and lowercase letters as well as special characters and numbers—can help prevent brute-force attacks.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch19.xhtml#rquiz19_5) **c.** Ransomware is an attack that locks access to a system or files (often using encryption) and demands payment of a ransom (often in cryptocurrency) for access to files or systems to be restored.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch19.xhtml#rquiz19_6) **b.** A DoS attack originates from a single system, whereas a DDoS attack originates from multiple systems simultaneously and the attacker distributes zombie software or infects multiple (even into the thousands) hosts, providing the attacker partial or full control of the infected computer system through one or more command and control servers.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch19.xhtml#rquiz19_7) **d.** An evil twin is a special type of rogue access point attack. This attack is designed to capture authentication information from an unsuspecting network user. This attack is so named because a rogue AP is configured in this scenario to appear just like the legitimate AP that the client should be connecting with.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch19.xhtml#rquiz19_8) **d.** Password spraying is a type of password attack that attempts to access a large number of user accounts with a very few number of commonly used passwords.

### Chapter 20

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch20.xhtml#rquiz20_1) **a.** Control plane policing (CoPP) can help in this situation. Because your IGP and EGP routing protocols are part of the control plane, you can use CoPP to watch the amount of traffic that is permitted to your CPU. In this way, you can prevent many different types of DoS attacks that target the control plane.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch20.xhtml#rquiz20_2) **d.** Extensible Authentication Protocol (EAP) is a flexible solution that is used in many network environments to support a wide variety of authentication and authorization scenarios. EAP is the featured technology of 802.1X.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch20.xhtml#rquiz20_3) **c.** Private VLANs add segmentation capabilities beyond what is typical for VLAN communication. You can create segmentation within an IP subnet by using this technology.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch20.xhtml#rquiz20_4) **d.** Network hardening best practices include using SNMPv3 instead of earlier versions, disabling unneeded ports and unneeded services, and changing default passwords to something other than the known default passwords.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch20.xhtml#rquiz20_5) **a.** An implicit deny clause (in a firewall rule) means that if the proviso in question has not been explicitly granted, then access is denied.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch20.xhtml#rquiz20_6) **d.** A public network or a Wi-Fi hotspot may use a captive portal, which requires users to agree to some condition before they can use the network or Internet.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch20.xhtml#rquiz20_7) **b.** An untrusted zone is a network segment with higher risk, such as external networks, where security threats are more likely, requiring stringent controls to protect internal systems.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch20.xhtml#rquiz20_8) **d.** Key management involves the processes and systems for generating, distributing, rotating, storing, and handling cryptographic keys to ensure secure encryption and decryption of data.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch20.xhtml#rquiz20_9) **a, d.** Use secure protocols over unsecure protocols whenever possible. For example, use Secure Shell (SSH) rather than the insecure Telnet for remote management using terminals, and use SNMPv3 over previous versions if possible.

### Chapter 21

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#rquiz21_1) **d.** Identifying or defining the problem is often the first step in a troubleshooting methodology.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#rquiz21_2) **a, c, d.** Identifying, fixing, and reporting the problem are often the three steps in a simplified troubleshooting flow.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#rquiz21_3) **a.** One of the final steps in a structured troubleshooting methodology would be to implement the solution. If you and your team are unable to implement a solution, you should escalate the problem.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#rquiz21_4) **d.** Step 3 is “Test the theory to determine the cause.” This step includes two substeps: If the theory is confirmed, determine the next steps to resolve the problem. If the theory is not confirmed, establish a new theory or escalate. If you answered this question correctly, you have a solid grasp of the CompTIA network troubleshooting methodology!

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#rquiz21_5) **c.** After you have verified full system functionality and implemented preventive measures (Step 6), you should complete the final step (Step 7) by documenting findings, actions, outcomes, and lessons learned.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch21.xhtml#rquiz21_6) **a, b.** Substeps include top-to-bottom/bottom-to-top OSI model and divide and conquer.

### Chapter 22

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#rquiz22_1) **a.** To use Power over Ethernet (PoE), your physical media must be Cat 5e or higher.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#rquiz22_2) **b.** You must ensure that you do not allow dirt to enter fiber-optic cable or cable connectors.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#rquiz22_3) **b.** Using a loopback plug is a simple method of testing a network device’s capability to send and receive traffic.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#rquiz22_4) **c, d.** To mitigate the concern of pumping poisonous gas throughout a building’s heating, ventilation, and air-conditioning (HVAC) system, you can use plenum-rated cabling. The outer insulation of a plenum twisted-pair cable is fire retardant; in addition, some plenum cabling uses a fluorinated ethylene polymer (FEP) or a low-smoke polyvinyl chloride (PVC) to minimize dangerous fumes. Cables that run through risers should also be fireproof to prevent flames from traveling up the cable.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#rquiz22_5) **a, e.** Attenuation is the weakening of a signal with greater distance between two devices on network media. Attenuation is measured in decibels (dB). dB loss is also more prone to happen as the signal needs to go farther and farther in the media.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#rquiz22_6) **b.** An error disabled state is often the result of a violation of some protection mechanism on the network device. For example, the BPDU Guard feature of Spanning Tree Protocol would produce an error disabled state if there were to be a violation of this protection mechanism.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#rquiz22_7) **c.** Duplex mismatches can cause links between devices to run inefficiently. A common scenario is one device operating in half-duplex while the other operates in full-duplex. You can check this setting in Windows 11 for a NIC, for example. Open Device Manager and right-click the suspect network adapter. Select Properties and then Speed & Duplex and look at the Value setting.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#rquiz22_8) **a, d.** Fiber-optic cabling is immune to electromagnetic interference (EMI) and radio frequency interference (RFI) and it is more difficult to install and troubleshoot than unshielded twisted pair (UTP).

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#rquiz22_9) **c.** Interface drop errors occur when a network interface discards incoming or outgoing packets due to congestion, buffer overflows, or other issues. These drops most often result from excessive network traffic, insufficient bandwidth, or hardware limitations.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch22.xhtml#rquiz22_10) **b.** Crosstalk occurs when a signal transmitted on one circuit or channel creates an undesired effect on another circuit or channel. It can be caused by physical proximity of the wires, electromagnetic interference, or poor shielding and insulation.

### Chapter 23

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#rquiz23_1) **c.** This problem sounds like it could be related to DNS-based name resolution.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#rquiz23_2) **a.** A misconfigured default gateway address can lead to issues with reaching remote destinations.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#rquiz23_3) **b, c.** Spanning Tree Protocol (STP) protects against three main issues: MAC address table corruption, broadcast storms, and loops at Layer 2.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#rquiz23_4) **b.** Being able to successfully ping another host is a simple method of confirming that Layers 1 through 3 of the OSI model are working.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#rquiz23_5) **d.** The configuration of virtual LANs (VLANs) permits the creation of additional broadcast domains.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#rquiz23_6) **c.** This IP address and subnet mask combination means that this host lives on the 172.16.128.0 subnet.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#rquiz23_7) **a, d.** If STP is not running correctly—or not running at all—it will not be long before you have broadcast storms and switching loops. These are the enemies that STP is engineered to protect you from.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#rquiz23_8) **b.** DHCP scope exhaustion refers to the scope being completely out of IP addresses that can be leased to clients.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#rquiz23_9) **a.** Failure to exclude statically assigned IP addresses in the network can lead to duplicate IP address issues. When systems have duplicate IP addresses, their ability to communicate successfully on the network can be compromised.

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch23.xhtml#rquiz23_10) **c.** The root bridge in Spanning Tree Protocol (STP) is the central reference point of the network topology, selected based on the lowest bridge ID, to which all other network switches determine their best path to ensure a loop-free network.

### Chapter 24

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#rquiz24_1) **a.** Received signal strength indication (RSSI) is an excellent metric for measuring the strength of the received wireless signal.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#rquiz24_2) **a, c, d.** Fax machines and Bluetooth are the technologies in this list that are least likely to cause interference with wireless networks. Gaming consoles, microwaves, and baby monitors are the most common sources of RFI in wireless networks.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#rquiz24_3) **a.** Throughput is a measure of the actual data that can be sent through the network. Speed is the theoretical maximum data rate for wireless.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#rquiz24_4) **d.** A unidirectional antenna directs the bulk of its signal in a specific direction. In contrast, an omnidirectional antenna sends the signal in a 360-degree coverage area around the antenna.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#rquiz24_5) **b.** A captive portal is a web page that asks clients seeking access to agree to organizational policies and typically captures information from clients.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#rquiz24_6) **a.** A site survey can be a critical aid in implementing wireless network infrastructure. During a site survey, key issues can be tested for, such as excessive interference in certain areas.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#rquiz24_7) **a.** Disassociation is often an initial step in a much larger attack. Once the client is disassociated, it can be associated to a rogue device.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#rquiz24_8) **b.** The coverage areas of wireless APs using overlapping channels should not overlap. To maintain coverage between coverage areas, you should have overlapping coverage areas among wireless APs using non-overlapping channels (for example, channels 1, 6, and 11 for wireless networks using the 2.4GHz band of frequencies).

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#rquiz24_9) **d.** Bandwidth refers to the maximum amount of data that can be transmitted over the network in a given amount of time, usually measured in bits per second (bps).

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#rquiz24_10) **c.** Contention occurs when multiple devices or applications simultaneously compete for the same network resources, leading to potential delays and reduced performance.

### Chapter 25

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#rquiz25_1) **b.** The **arp** command permits you to see the IP address to MAC address mappings. You can read them from left to right.

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#rquiz25_2) **d.** You can use the **/all** switch to learn many additional details about the IP configuration, including DNS details.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#rquiz25_3) **c.** The **ping** command uses Internet Control Message Protocol (ICMP) in its operation. If you issue a **ping** command from your PC, your PC sends an ICMP echo message to the specified destination host. If the destination host is reachable, the host responds with an ICMP echo reply message.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#rquiz25_4) **d.** You use **traceroute** in Linux to follow the hop-by-hop path that a packet takes.

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#rquiz25_5) **a, c, d.** You can use the Linux commands **nslookup**, **dig**, and **host** to verify DNS operations.

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#rquiz25_6) **b.** This output is an example of output from the **dig** command.

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#rquiz25_7) **b.** A Wi-Fi analyzer is a tool that would be used as part of a wireless site survey after Wi-Fi has been implemented to create a heat map of the wireless airspace.

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#rquiz25_8) **c.** The **show route** command is used to view the routing table configuration of a network device.

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch25.xhtml#rquiz25_9) **c, d.** Link Layer Discovery Protocol (LLDP) and Cisco Discovery Protocol (CDP) are protocols used by devices to identify and share information about themselves within a local area network. While LLDP is an open standard defined by the IEEE, CDP is an invention by Cisco Systems.