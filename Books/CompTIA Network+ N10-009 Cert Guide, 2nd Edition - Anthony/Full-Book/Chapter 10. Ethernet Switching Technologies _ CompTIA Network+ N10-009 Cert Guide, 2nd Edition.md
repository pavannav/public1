## Chapter 10

## Ethernet Switching Technologies

This chapter covers the following topics related to Objective 2.2 (Given a scenario, configure switching technologies and features) of the CompTIA Network+ N10-009 certification exam:

- Virtual Local Area Network (VLAN)

  - VLAN database
  - Switch Virtual Interface (SVI)
- Interface configuration

  - Native VLAN
  - Voice VLAN
  - 802.1Q tagging
  - Link aggregation
  - Speed
  - Duplex
- Spanning tree
- Maximum transmission unit (MTU)

  - Jumbo frames

Odds are, when you are working with local area networks (LANs), you are working with Ethernet as the Layer 1 technology. Back in the mid-1990s, there was tremendous competition between technologies such as Ethernet, Token Ring, and Fiber Distributed Data Interface (FDDI). Today, however, you can see that Ethernet is the clear winner of those Layer 1 wars.

Of course, over the years, Ethernet has evolved. Several Ethernet standards exist in modern LANs, with a variety of distance and speed limitations. This chapter begins by reviewing the fundamentals of Ethernet networks, including a collection of Ethernet speeds and feeds. This chapter also delves into many of the features available with some Ethernet switches.

### Foundation Topics

### Principles of Ethernet

Xerox Corporation developed Ethernet in 1973, with the goal of creating a technology to allow computers to connect with laser printers. A quick survey of almost any corporate network reveals that Ethernet rose well beyond its humble beginnings; today it is used to interconnect devices such as computers, printers, wireless access points, servers, switches, routers, video game systems, and more. This section discusses early Ethernet implementations and limitations as well as modern Ethernet throughput and distance specifications.

Note

Don’t worry, your CompTIA Network+ exam will not focus on the legacy equipment described in this early history. The exam focuses on current technologies covered in detail later in this chapter.

In the network industry literature, you might come upon the term *IEEE 802.3* (where IEEE refers to the Institute of Electrical and Electronics Engineers standards body). In general, you can use the term *IEEE 802.3* interchangeably with the term *Ethernet*. However, be aware that these technologies have some subtle distinctions. For example, an Ethernet frame is a fixed-length frame, whereas the 802.3 frame length can vary.

#### Carrier-Sense Multiple Access with Collision Detection

Ethernet was based on the philosophy that all networked devices should be eligible, at any time, to transmit on a network. In contrast, Token Ring used a deterministic media access approach. Specifically, Token Ring networks passed a token around a network in a circular fashion, from one networked device to the next. Only when a networked device was in possession of that token was it eligible to send on the network.

[Figure 10-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig01) depicts an Ethernet network using a legacy shared bus topology.

![](../images/10fig01.jpg)


**Figure 10-1** Ethernet Network Using a Shared Bus Topology

In this topology, all devices are directly connected to the network and are free to transmit at any time, if they have reason to believe no other transmission currently exists on the wire. Ethernet permits only a single frame to be on a network segment at any one time. So, before a device in this network transmits, it listens to the wire to see if there is currently any traffic being transmitted. If no traffic is detected, the networked device transmits its data. However, what if two devices simultaneously have data to send? If they both listen to the wire at the same time, they could simultaneously, and erroneously, conclude that it is safe to send their data. However, when both devices simultaneously send their data, a *collision* occurs (see [Figure 10-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig02)), and data corruption results.

![](../images/10fig02.jpg)


**Figure 10-2** Collision on an Ethernet Segment

Fortunately, Ethernet was designed with a mechanism to detect collisions and allow the devices whose transmissions collided to retransmit their data at different times. Specifically, after the devices notice that a collision occurred, they independently set a random back-off timer. Each device waits for this random amount of time to elapse before again trying to transmit. Here is the logic: Because each device certainly picked a different amount of time to back off from transmitting, their transmissions should not collide the next time these devices transmit, as illustrated in [Figure 10-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig03).

![](../images/10fig03.jpg)


**Figure 10-3** Recovering from a Collision with Random Back-off Timers

The procedure used by Ethernet to decide whether it is safe to transmit, detect collisions, and retransmit if necessary is called *carrier-sense multiple access with collision detection (CSMA/CD)*.

Let’s break down CSMA/CD into its constituent components:

![](../images/key_topic_icon_158.jpg)

- **Carrier sense:** A device attached to an Ethernet network can listen to the wire, prior to transmitting, to make sure a frame is not being transmitted on the network segment.
- **Multiple access:** Unlike with a deterministic method of network access (for example, the method used by Token Ring), all Ethernet devices simultaneously have access to an Ethernet segment.
- **Collision detection:** If a collision occurs (perhaps because two devices were simultaneously listening to the network and simultaneously concluded that it was safe to send), Ethernet devices can detect that collision and set random back-off timers. After each device’s random timer expires, the device again tries to transmit its data.

Despite Ethernet’s CSMA/CD feature, Ethernet segments still suffer from scalability limitations. Specifically, the likelihood of collisions increases as the number of devices on a shared Ethernet segment increases.

An alternate approach is CSMA/CA, where CA refers to *collision avoidance*. This technology is common in wireless networks and was made famous by Token Ring in early LANs.

With wired Ethernet, devices on a shared Ethernet segment belong to the same *collision domain*. One example of a shared Ethernet segment is a 10BASE5 or 10BASE2 network with multiple devices attaching to the same cable. On that cable, only one device can send at any one time. Therefore, all devices attached to the thicknet or thinnet cable are in the same collision domain.

Similarly, devices connected to a legacy Ethernet hub are in the same collision domain (see [Figure 10-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig04)). A hub is a Layer 1 device and does not make forwarding decisions. Instead, a hub takes bits in on one port and sends them out all the other hub ports except the one on which the bits were received.

![](../images/10fig04.jpg)


**Figure 10-4** Shared Ethernet Hub: One Collision Domain

Ethernet switches dramatically increase the scalability of Ethernet networks by creating multiple collision domains (see [Figure 10-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig05)). In fact, every port on an Ethernet switch is in its own collision domain.

![](../images/10fig05.jpg)


**Figure 10-5** Ethernet Switch: One Collision Domain per Port


Note

Do switches seem familiar to you? They should. Because they are so important in today’s networks, we also covered them in [Chapter 2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02), “[Networking Appliances, Applications, and Functions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02).”

Ethernet switches have a less obvious but powerful benefit: Because a switch port connects to a single device, there is no chance of collision. With no chance of collision, collision detection is no longer needed, and with collision detection disabled, network devices can run in [***full-duplex***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_278) mode rather than [***half-duplex***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_291) mode. In full-duplex mode, a device can simultaneously send and receive at the same time.

When multiple devices are connected to the same shared Ethernet segment, such as a Layer 1 hub, CSMA/CD must be enabled. As a result, the network must work in half-duplex mode, which means that only a single networked device can transmit or receive at any one time. In half-duplex mode, a networked device cannot simultaneously send and receive, so the device makes inefficient use of the network’s bandwidth.

Another important mechanism in an Ethernet network is flow control. *Flow control* is a mechanism for temporarily stopping the transmission of data on Ethernet-based networks. The goal of this mechanism is to avoid packet loss in the presence of network congestion.

#### Distance and Speed Limitations

Remember, as we covered in [Chapter 5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05), “[Transmission Media and Transceivers](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05),” the bandwidth of a network ([***speed***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_646)) is measured in terms of how many bits the network can transmit during a 1-second period of time. In fact, let’s revisit the Ethernet bandwidth capabilities using [Table 10-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10tab01). This table defines the common bandwidths supported on distinct types of Ethernet networks.

![](../images/key_topic_icon_158.jpg)


**Table 10-1** Ethernet Bandwidth Capacities

| Ethernet Type | Bandwidth Capacity |
| --- | --- |
| Standard Ethernet | 10Mbps: 10 million bits per second (that is, 10 megabits per second) |
| Fast Ethernet | 100Mbps: 100 million bits per second (that is, 100 megabits per second) |
| Gigabit Ethernet | 1Gbps: 1 billion bits per second (that is, 1 gigabit per second) |
| 10-Gigabit Ethernet | 10Gbps: 10 billion bits per second (that is, 10 gigabits per second) |
| 40-Gigabit Ethernet | 40 Gbps: 40 billion bits per second (that is, 40 gigabits per second) |
| 100-Gigabit Ethernet | 100Gbps: 100 billion bits per second (that is, 100 gigabits per second) |

Remember, the key here is that the type of cabling used in an Ethernet network influences the bandwidth capacity and the distance limitation of the network. For example, fiber-optic cabling often has a higher bandwidth capacity and a longer distance limitation than twisted-pair cabling.

When it comes to the size of a frame the media can send, there is a [***maximum transmission unit (MTU)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_402) value the media can accommodate. You can even configure support for [***jumbo frames***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_352), which are Ethernet frames with more than 1500 bytes of payload (the limit set by the IEEE 802.3 standard).

### Ethernet Switch Features

Beyond basic frame forwarding, many Layer 2 Ethernet switches offer a variety of other features to enhance such things as network performance, redundancy, security, management, flexibility, and scalability. Although the specific features offered by a switch vary, this section introduces you to some of the most common features of switches.

#### Virtual LANs

In a basic switch configuration, all ports on a switch belong to the same *broadcast domain*. In such an arrangement, a broadcast received on one port gets forwarded out all other ports.

Also, from a Layer 3 perspective, all devices connected in a broadcast domain have the same *network address*. [Chapter 7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07), “[IPv4 Addressing](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch07.xhtml#ch07),” gets into the binary math involved in assigning IP addresses (that is, logical Layer 3 addresses) to networked devices. A portion of that address is the address of the network to which that device is attached. The remainder of that address is the address of the device itself. Devices that have the same network address belong to the same network, or *subnet*.

Say that you decide to place PCs from different departments within your company into their own subnet. One reason you might want to do this is for security purposes. For example, by having the Accounting department in a separate subnet (that is, a separate broadcast domain) from the Sales department, devices in one subnet will not see the broadcasts being sent on the other subnet.

Another reason that you might want to do this is to make the overall network segment more efficient. Remember that excessive broadcast frames can cause a network to suffer, and there are plenty of operations that rely on broadcasts to function properly. *Address Resolution Protocol* (*ARP*) is a great example of such an operation. ARP is a broadcast-based solution that permits a system to discover the MAC address that coordinates to a particular IP address. IPv6 eliminates this challenge altogether with the introduction and use of *Neighbor Discovery Protocol* (*NDP*). As you might guess, NDP is not broadcast based. This is fortunate, as broadcasts are not supported in IPv6.

The PCs belonging to the different departments in your company are scattered across multiple floors in a building (see [Figure 10-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig06)). The Accounting and Sales departments each have a PC on each floor of the building. Because the wiring for each floor runs back to a wiring closet on that floor, to support these two subnets using a switch’s default configuration, you need to install two switches on each floor. For traffic to travel from one subnet to another subnet, that traffic has to be routed, meaning that a device such as a multilayer switch or a router forwards traffic based on a packet’s destination network addresses. So, in this example, the Accounting department switches are interconnected and then connect to a router, and the Sales department switches are connected similarly.

![](../images/10fig06.jpg)


**Figure 10-6** Example: All Ports on a Switch Belonging to the Same Subnet

The design described here lacks efficiency because you must install at least one switch per subnet. A more efficient design would be to logically separate a switch’s ports into different broadcast domains. Then, an Accounting department PC and a Sales department PC could connect to the same switch, even though those PCs belong to different subnets. Fortunately, [***virtual LANs (VLANs)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_742) make such a design possible.

As the administrator of the network, you can easily assign VLANs to interfaces on the switch. In fact, if you need to address all the interfaces on a device that are part of a particular VLAN, you can use a [***switch virtual interface (SVI)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_672). This interface “represents” all of the member interfaces for the specific VLAN. This special, virtual interface has an up or down status based on whether there are physical interfaces enabled and healthy in the VLAN specified.

With VLANs, as illustrated in [Figure 10-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig07), a switch can have its ports logically divided into more than one broadcast domain (that is, more than one subnet or VLAN). Then, devices that need to connect to those VLANs can connect to the same physical switch, but they remain logically separate from one another.

![](../images/10fig07.jpg)


**Figure 10-7** Example: Ports on a Switch Belonging to Different VLANs

Note

You will often hear engineers speaking of the [***VLAN database***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_749) on a switch as the place where the VLANs that have been configured are stored. Interestingly, some switches do use a separate storage structure to store this “database.”

VLANs are very handy with another popular configuration requirement in many modern network environments: You can use a special-purpose VLAN termed a [***voice VLAN***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_753) to segment and provide network access for VoIP packets. These packets need access to the data network for transport, and they also need special priority treatment to ensure that the voice call quality always remains excellent. Using a voice VLAN is an ideal segmentation strategy for all these needs.

One challenge with VLAN configuration in large environments is the need to configure identical VLAN information on all switches. Manually performing this configuration is time-consuming and error prone. However, switches from Cisco Systems support VLAN Trunking Protocol (VTP), which allows a VLAN created on one switch to be propagated to other switches in a group of switches (that is, a VTP domain). VTP information is carried over a *trunk connection*, as discussed in the next section.

#### Switch Configuration for an Access Port

Configurations used on a switch port may vary, based on the manufacturer of the switch. [Example 10-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#exa10_1) shows a sample configuration on an access port (without trunking) on a Cisco Catalyst switch. A line with a leading ! is a comment used to document the next line(s) of the configuration.

Notice in this configuration the use of port security, which is a small but useful step in securing a network. In this configuration example, the port can learn only two MAC addresses—perhaps the MAC address of a VoIP phone and the computer that connects to that phone.

**Example 10-1** Switch Access Port Configuration

[Click here to view code image](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10_images.xhtml#p0266-01)

```
! Move into configuration mode for interface gig 0/21 SW1(config)# interface GigabitEthernet0/21

! Add a text description of what the port is used for SW1(config-if)# description Access port in Sales VLAN 21

! Define the port as an access port, and not a trunk port SW1(config-if)# switchport mode access

! Assign the port to VLAN 21 SW1(config-if)# switchport access vlan 21

! Enable port security SW1(config-if)# switchport port-security

! Control the number of MAC addresses the switch may learn
! from device(s) connected to this switch port SW1(config-if)# switchport port-security maximum 2

! Restrict any frames from MAC addresses above the 2 allowed SW1(config-if)# switchport port-security violation restrict

! Set the speed to 1,000 Mbps (1 Gigabit per second)
SW1(config-if)# speed 1000

! Set the duplex to full SW1(config-if)# duplex full

! Configure the port to begin forwarding without waiting the
! standard amount of time normally set by Spanning Tree Protocol SW1(config-if)# spanning-tree portfast
```

#### Trunks

One challenge with carving up a switch into multiple VLANs is that several switch ports (that is, one port per VLAN) could be consumed by connecting a switch to a switch or a switch to a router. A more efficient approach is to allow traffic for multiple VLANs to travel over a single connection, as shown in [Figure 10-8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig08). This type of connection is called a *trunk*.

![](../images/10fig08.jpg)


**Figure 10-8** Example: Trunking Between Switches

The most popular trunking standard today is IEEE 802.1Q, which is often referred to as *dot1q*. One of the VLANs traveling over an 802.1Q trunk is called a [***native VLAN***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_431). Frames belonging to the native VLAN are sent unaltered over the trunk (untagged/no tag). However, to distinguish other VLANs from one another, the remaining VLANs are tagged.

Note

IEEE 802.1Q is often called [***802.1Q tagging***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_025) or *port tagging*.

Specifically, a nonnative VLAN has 4 tag bytes (where a *byte* is a collection of 8 bits) added to the Ethernet frame (that is, tagged frame). [Figure 10-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig09) shows the format of an IEEE 802.1Q header with these 4 bytes.

![](../images/key_topic_icon_158.jpg)

![](../images/10fig09.jpg)


**Figure 10-9** IEEE 802.1Q Header

One of these bytes contains a VLAN field, which indicates to which VLAN a frame belongs. The devices (for example, switch, multilayer switch, router) at each end of a trunk interrogate that field to determine to which VLAN an incoming frame is associated. As you can see by comparing [Figures 10-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig06), [10-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig07), and [10-8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig08), VLAN and trunking features allow switch ports to be used far more efficiently than merely relying on a default switch configuration.

Note

What type of Ethernet media do you use for a trunk link? Well, it used to be that you needed a special Ethernet cable called a *crossover cable* for a trunk link. This is no longer the case in most networks, as switches now support *auto-medium-dependent interface crossover (MDI-X)* technology. This technology essentially permits a switch to detect the type of Ethernet cable used (straight-through versus crossover) and adjust accordingly so that communication between the two network devices (switches in this case) is successful.

#### Switch Configuration for a Trunk Port

[Example 10-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#exa10_2) shows a sample configuration on a trunk port on a Cisco Catalyst switch. A line with a leading ! is a comment used to document the next line(s) of the configuration.

**Example 10-2** Sample Trunk Port Configuration

[Click here to view code image](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10_images.xhtml#p0268-01)

```
! Go to interface config mode for interface Gig 0/22 SW1(config)# interface GigabitEthernet0/22

! Add a text description SW1(config-if)# description Trunk to another switch

! Specify that this is a trunk port SW1(config-if)# switchport mode trunk

! Specify the trunking protocol to use SW1(config-if)# switchport trunk encapsulation dot1q

! Specify the native VLAN to use for un-tagged frames SW1(config-if)# switchport trunk native vlan 5

! Specify which VLANs are allowed to go on the trunk SW1(config-if)# switchport trunk allowed vlan 1-50
```

#### Spanning Tree Protocol

Administrators of traditional corporate telephone networks often used to boast about their telephone systems—that is, private branch exchange (PBX) systems—having *five nines* availability. Five nines availability means that a system is up and functioning 99.999% of the time, which translates to only about 5 minutes of downtime per year.

Traditionally, corporate data networks struggled to compete with corporate voice networks in terms of availability. Today, however, many networks that traditionally carried only data now carry voice, video, and data. Therefore, availability is an especially important design consideration.

To improve network availability at Layer 2, many networks have redundant links between switches. However, unlike Layer 3 packets, Layer 2 frames lack a Time-to-Live (TTL) field. As a result, a Layer 2 frame can circulate endlessly through a looped Layer 2 topology. Fortunately, IEEE 802.1D [***Spanning Tree Protocol (STP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_644) enables a network to physically have Layer 2 loops while strategically blocking data from flowing over one or more switch ports to prevent the looping of traffic.

In the absence of STP, if a network has parallel paths, two significant symptoms include corruption of a switch’s MAC address table and broadcast storms, where frames loop over and over throughout the switched network. An enhancement to the original STP is *802.1w*, which is also called *Rapid Spanning Tree Protocol (RSTP)* because it does a quicker job of adjusting to network conditions, such as the addition or removal of Layer 2 links in the network. RSTP is covered in more detail later in this chapter in the section “[Modern Enhancements to STP](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10lev2sec11).”

Shortest Path Bridging (SPB; IEEE 802.1aq) is a protocol that is more scalable than STP in larger environments (with hundreds of switches interconnected).

#### Corruption of a Switch’s MAC Address Table

A switch’s MAC address table can dynamically learn what MAC addresses are available off its ports. However, in the case of an STP failure, a switch’s MAC address table can become corrupted (see [Figure 10-10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig10)).

![](../images/10fig10.jpg)


**Figure 10-10** MAC Address Table Corruption

In [Figure 10-10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig10), PC1 is transmitting traffic to PC2. When the frame sent from PC1 is transmitted on segment A, the frame is seen on the Gig 0/1 ports of switches SW1 and SW2, causing both switches to add an entry to their MAC address tables, associating MAC address AAAA.AAAA.AAAA with port Gig 0/1. Because STP is not functioning, both switches then forward the frame out on segment B. As a result, PC2 receives two copies of the frame. Also, switch SW1 sees the frame forwarded out of switch SW2’s Gig 0/2 port. Because the frame has source MAC address AAAA.AAAA.AAAA, switch SW1 incorrectly updates its MAC address table, indicating that MAC address AAAA.AAAA.AAAA resides off port Gig 0/2. Similarly, switch SW2 sees the frame forwarded on to segment B by switch SW1 on its Gig 0/2 port. Therefore, switch SW2 also incorrectly updates its MAC address table.

#### Broadcast Storms

As previously mentioned, when a switch receives a broadcast frame (that is, a frame destined for MAC address FFFF.FFFF.FFFF), the switch floods the frame out all switch ports other than the port on which the frame was received. Because a Layer 2 frame does not have a TTL field, a broadcast frame endlessly circulates through the Layer 2 topology, consuming resources on both switches and attached devices (for example, user PCs).

[Figure 10-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig11) and the following list illustrate how a broadcast storm can form in a Layer 2 topology when STP is not functioning correctly:

![](../images/10fig11.jpg)


**Figure 10-11** Broadcast Storm

**Step 1.** PC1 sends a broadcast frame on to segment A, and the frame enters each switch on port Gig 0/1.

![](../images/key_topic_icon_158.jpg)

**Step 2.** Both switches flood a copy of the broadcast frame out their Gig 0/2 ports (that is, on to segment B), causing PC2 to receive two copies of the broadcast frame.

**Step 3.** Both switches receive a copy of the broadcast frame on their Gig 0/2 ports (that is, from segment B) and flood the frame out their Gig 0/1 ports (that is, on to segment A), causing PC1 to receive two copies of the broadcast frame.

This behavior continues as the broadcast frame copies continue to loop through the network. The performance of PC1 and PC2 is affected because they also continue to receive copies of the broadcast frame.

#### STP Operation

STP prevents Layer 2 loops—which might result in a broadcast storm or corruption of a switch’s MAC address table—from occurring in a network. Switches in an STP topology are classified as one of the following:

![](../images/key_topic_icon_158.jpg)

- **Root bridge:** A root bridge is a switch elected to act as a reference point for a spanning tree. The switch with the lowest bridge ID (BID) is elected as the root bridge. The BID is made up of a priority value and a MAC address.
- **Nonroot bridge:** All other switches in the STP topology are nonroot bridges.

[Figure 10-12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig12) illustrates root bridge election in a network. Notice that in this case, the bridge priorities are both 32768; therefore, the switch with the lowest MAC address (that is, SW1) is elected as the root bridge.

![](../images/10fig12.jpg)


**Figure 10-12** Root Bridge Election

Ports that interconnect switches in an STP topology are categorized as one of the port types described in [Table 10-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10tab02).

![](../images/key_topic_icon_158.jpg)


**Table 10-2** STP Port Types

| Port Type | Description |
| --- | --- |
| **Root port** | Every nonroot bridge has a single root port, which is the port on that switch that is closest to the root bridge in terms of cost. |
| **Designated port** | Every network segment has a single designated port, which is the port on that segment that is closest to the root bridge in terms of cost. Therefore, all ports on a root bridge are designated ports. |
| **Nondesignated port** | Nondesignated ports block traffic to create a loop-free topology. |

[Figure 10-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig13) illustrates these port types. Notice that both links are equal in this case, with a cost of 19, because both links are Fast Ethernet links; therefore, the root port for switch SW2 is selected because it has the lowest port ID.

![](../images/10fig13.jpg)


**Figure 10-13** Identifying STP Port Roles

[Figure 10-14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig14) shows a similar topology to [Figure 10-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig13). In [Figure 10-14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig14), however, the top link is running at a speed of 10Mbps, whereas the bottom link is running at a speed of 100Mbps. Because switch SW2 seeks to get back to the root bridge (that is, switch SW1) with the least cost, port Gig 0/2 on switch SW2 is selected as the root port.

![](../images/10fig14.jpg)


**Figure 10-14** STP with Different Port Costs

Specifically, port Gig 0/1 has a cost of 100, and Gig 0/2 has a cost of 19. [Table 10-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10tab03) shows the port costs for various link speeds.

![](../images/key_topic_icon_158.jpg)


**Table 10-3** STP Port Cost

| Link Speed | STP Port Cost |
| --- | --- |
| 10Mbps (Ethernet) | 100 |
| 100Mbps (Fast Ethernet) | 19 |
| 1Gbps (Gigabit Ethernet) | 4 |
| 10Gbps (10-Gigabit Ethernet) | 2 |
| 40Gbps (40-Gigabit Ethernet) | 2 |

Note

To make things obvious in our illustration, we used the old legacy 10Mbps Ethernet against Fast Ethernet. Remember that in many networks today, it can be hard to find connections under 1Gbps in speed.

Nondesignated ports do not forward traffic during normal operation but do receive bridge protocol data units (BPDUs). Switches exchange STP information in the form of BPDUs, which contain useful information for STP elections, path cost calculation, link suppression, and loop detection. If a link in the topology goes down, the nondesignated port detects the link failure and determines whether it needs to transition to the forwarding state.

If a nondesignated port needs to transition to the forwarding state, it does not do so immediately. Rather, it transitions through the following states:

![](../images/key_topic_icon_158.jpg)

- **Blocking:** The port remains in the blocking state for 20 seconds by default. During this time, the nondesignated port evaluates BPDUs in an attempt to determine its role in the spanning tree.
- **Listening:** The port moves from the blocking state to the listening state and remains in this state for 15 seconds by default. During this time, the port sources BPDUs, which inform adjacent switches of the port’s intent to forward data.
- **Learning:** The port moves from the listening state to the learning state and remains in this state for 15 seconds by default. During this time, the port begins to add entries to its MAC address table.
- **Forwarding:** The port moves from the learning state to the forwarding state and begins to forward frames.

#### Modern Enhancements to STP

Rapid Spanning Tree Protocol (RSTP), defined in IEEE 802.1w, is an evolution of the original STP designed to provide faster convergence in our Ethernet networks. RSTP enhances the original protocol by introducing new port roles and states that allow for rapid transition to the forwarding state, thereby significantly reducing the time it takes for network topology changes to be recognized and for traffic to be rerouted. Unlike STP, which can take up to 50 seconds to respond to a topology change, RSTP can achieve convergence in a few seconds, improving the efficiency and reliability of network operations.

RSTP introduces the concept of edge ports, which are ports directly connected to end devices and can immediately transition to the forwarding state without going through the traditional listening and learning states. Additionally, RSTP defines alternative and backup ports to handle topology changes more efficiently. An alternative port provides a backup path to the root bridge in case the current path fails, while a backup port offers a redundant connection on a shared LAN segment. These enhancements enable RSTP to quickly adapt to network changes, ensuring minimal disruption to data traffic.

Multiple Spanning Tree Protocol (MSTP), specified in IEEE 802.1s, builds on RSTP to address the scalability issues associated with managing multiple VLANs in large networks. MSTP allows multiple VLANs to be mapped to a single spanning tree instance, reducing the number of spanning tree instances that need to be maintained and managed. This approach simplifies the network design and optimizes resource utilization, as the same spanning tree can handle multiple VLANs with similar traffic patterns and requirements. By grouping VLANs into regions, MSTP enhances network efficiency and simplifies the implementation of VLAN-based network policies.

#### Link Aggregation

If all ports on a switch are operating at the same speed (for example, 1Gbps), the ports most likely to experience congestion are ports connecting to another switch or router. For example, imagine a wiring closet switch connected (via Fast Ethernet ports) to multiple PCs. That wiring closet switch has an uplink to the main switch for a building. Because this uplink port aggregates multiple 100Mbps connections and the uplink port is also operating at 100Mbps, it can quickly become congested if multiple PCs are transmitting traffic that needs to be sent over that uplink, as shown in [Figure 10-15](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig15).

![](../images/10fig15.jpg)


**Figure 10-15** Uplink Congestion

To help alleviate congested links between switches, you can (on some) switch models logically combine multiple physical connections into a single logical connection over which traffic can be sent. This feature, which is illustrated in [Figure 10-16](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig16), is called [***link aggregation***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_374).

![](../images/10fig16.jpg)


**Figure 10-16** Link Aggregation

Although vendor-proprietary solutions for link aggregation have existed for some time, some solutions faced a couple of common issues:

- Each link in the logical bundle was a potential single point of failure.
- Each end of the logical bundle had to be manually configured.

In 2000, the IEEE ratified the 802.3ad standard for link aggregation. This standard supports *Link Aggregation Control Protocol* (*LACP*). Unlike some of the older vendor-proprietary solutions, LACP supports automatic configuration and prevents an individual link from becoming a single point of failure. Specifically, with LACP, if a link fails, that link’s traffic is forwarded over a different link. The Cisco Systems implementation of LACP is called *EtherChannel*. Groups of interfaces that make up an EtherChannel bundle are often referred to as a *link aggregation group* (*LAG*). An EtherChannel group can be configured to act as a Layer 2 access port and support only a single VLAN, or it can be configured to act as a Layer 2 802.1Q trunk and support multiple VLANs of the LAG. A LAG can also be configured as a Layer 3 routed interface if the switch supports that feature. In the case of a Layer 3 EtherChannel, an IP address would be applied to the logical interface that represents the LAG. Another term related to LACP and LAGs is *port bonding*, which also refers to the same concept of grouping multiple ports and using them as a single logical interface.

#### LACP Configuration

[Example 10-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#exa10_3) shows a sample configuration of LACP on a Cisco switch. A line with a leading ! is a comment used to document the next line(s) of the configuration.

**Example 10-3** LACP Configuration

[Click here to view code image](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10_images.xhtml#p0276-01)

```
! Move to interface that will be part of the LACP group SW1(config)# interface GigabitEthernet0/16

! Assign this interface to the LACP group 1 SW1(config-if)# channel-group 1 mode active

! Move to the other interface(s) that will be part of
! the same group SW1(config-if)# interface GigabitEthernet0/17
SW1(config-if)# channel-group 1 mode active

! Configure the group of interfaces as a logical group
! Configuration here will also apply the individual
! interfaces that are part of the group SW1(config-if)# interface Port-channel 1

! Apply the configuration desired for the group
! LACP groups can be access or trunk ports depending
! on how the configuration of the logical port-channel interface
! In this example the LAG will be acting as a trunk SW1(config-if)# switchport mode trunk
SW1(config-if)# switchport trunk encapsulation dot1q
```

#### Power over Ethernet

Some switches not only transmit data over a connected UTP cable but also use that cable to provide power to an attached device. For example, say that you want to mount a wireless access point (AP) on the ceiling. Although no electrical outlet is available near the AP’s location, you can, as an example, run a Cat 6 UTP plenum cable above the drop ceiling and connect it to the AP. Some APs allow the switch at the other end of the UTP cable to provide power over the same wires that carry data. Examples of other devices that might benefit from receiving power from an Ethernet switch include security cameras and IP phones.

The switch feature that gives power to attached devices is called *Power over Ethernet (PoE)*, and it is defined by the IEEE 802.3af standard. As shown in [Figure 10-17](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig17), the PoE feature of a switch checks for 25,000 ohms of resistance in the attached device. To check the resistance, the switch applies as much as 10V of direct current (DC) across specific pairs of wires (that is, pins 1 and 2 combine to form one side of the circuit, and pins 3 and 6 combine to form the other side of the circuit) connecting back to the attached device and checks to see how much current flows over those wires. For example, if the switch applies 10V DC across those wires and notices 0.4 mA (milliamps) of current, the switch concludes that the attached device has 25,000 ohms of resistance across those wires (based on the formula *E* = *IR*, where *E* represents voltage, *I* represents current, and *R* represents resistance). The switch could then apply power across those wires.

![](../images/key_topic_icon_158.jpg)

![](../images/10fig17.jpg)


**Figure 10-17** PoE

Next, the switch must determine how much power the attached device needs. The switch makes this determination by applying 15.5V–20.5V DC (making sure that the current never exceeds 100 mA) to the attached device for a brief period of time (less than one-tenth of a second). The amount of current flowing to the attached device tells the switch the *power class* of the attached device. The switch then knows how much power should be made available on the port connecting to the device requiring power, and it begins supplying an appropriate amount of voltage (in the range 44V–57V) to the attached device.

The IEEE 802.3af standard can supply a maximum of 15.4W (watts) of power. However, the later standard IEEE 802.3at offers as much as 32.4W of power, enabling PoE to support a wider range of devices, such as power-hungry IP video cameras. This newer standard for PoE is often referred to as *Power over Ethernet Plus (PoE+)*.

#### Other Switch Features

Switch features, such as those previously described, vary widely by manufacturer, and some switches offer a variety of security features. For example, MAC filtering might be supported, which allows traffic to be permitted or denied based on a device’s MAC address. Other types of traffic filtering might also be supported, based on criteria such as IP address information (for multilayer switches).

For monitoring and troubleshooting purposes, interface *diagnostics* might be accessible. This diagnostic information might include various error conditions, such as late collisions or cyclic redundancy check (CRC) errors, which might indicate a duplex mismatch.

Some switches also support *quality of service* (*QoS*) settings, which make it possible to forward traffic based on the traffic’s priority markings. Also, some switches have the ability to perform marking and remarking of traffic priority values.

### Real-World Case Study

Acme, Inc. has made some decisions regarding the setup of its LAN. For connections from the client machines to the switches in the wiring closets (the intermediate distribution frames), it will use unshielded twisted-pair Category 6a cabling with the switch ports configured as access ports and set to 1000Mbps to match the Gigabit Ethernet capabilities of the client computers that will be connecting to the switches.

Multiple VLANs will be used. The computers that are being used by the Sales department will be connected to ports on a switch that are configured as access ports for the specific VLAN for Sales. Computers used by Human Resources will connect to switch ports that are configured as access ports for the Human Resources VLAN. There will be separate IP subnetworks associated with each of the VLANs.

The fiber connections that will go vertically through the building and connect the switches in the intermediate distribution frames (IDFs) to the main distribution frame (MDF) in the basement will be running at 1Gbps each, and multiple fiber cables will be used. LACP will be used for these vertical connections to make the multiple fiber links work together as part of one logical EtherChannel interface. For the LACP connections between the IDFs and MDF to support multiple VLANs, the LAG will be configured as a trunk using 802.1Q tagging. Routing between the VLANs will be done by multilayer switches that are located near the MDF.

Spanning tree will be enabled on the switches so that in the event of parallel paths between switches, a Layer 2 loop can be prevented.

To support IP-based telephones in the offices, the switches will also provide PoE+, which can supply power to the IP phones over the Ethernet cables that run between the switch in the IDF and the IP phones.

### Summary

Here are the main topics covered in this chapter:

- This chapter described the origins of Ethernet, including a discussion of Ethernet’s CSMA/CD features.
- This chapter compared a variety of Ethernet standards in terms of media type, network bandwidth, and distance limitation.
- This chapter covered various features that might be available on modern Ethernet switches, including VLANs, trunking, link aggregation, PoE, and PoE+.
- This chapter also detailed Spanning Tree Protocol (STP) as it exists on modern Ethernet switches as a loop prevention mechanism.
- Finally, this chapter described the maximum transmission unit (MTU) and jumbo frames.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 10-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10tab04) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 10-4** Key Topics for [Chapter 10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| List | Components of CSMA/CD | 260 |
| [Table 10-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10tab01) | Ethernet Bandwidth Capacities | 262 |
| [Figure 10-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig09) | IEEE 802.1Q Header Tag | 267 |
| [Figure 10-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig11) | Broadcast Storm | 271 |
| List | STP operation | 271 |
| [Table 10-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10tab02) | STP port types | 272 |
| [Table 10-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10tab03) | STP port cost | 273 |
| List | STP port states | 274 |
| [Figure 10-17](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#ch10fig17) | PoE | 278 |

### Complete Tables and Lists from Memory

Print a copy of [Appendix B](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb), “[Memory Tables](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb),” or at least the section for this chapter and complete as many of the tables as possible from memory. [Appendix C](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc), “[Memory Tables Answer Key](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc),” includes the completed tables and lists so you can check your work.

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[802.1Q tagging](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_01)

[full-duplex](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_02)

[half-duplex](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_03)

[jumbo frames](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_04)

[link aggregation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_05)

[maximum transmission unit (MTU)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_06)

[native VLAN](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_07)

[Spanning Tree Protocol (STP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_08)

[speed](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_09)

[Switch Virtual Interface (SVI)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_010)

[virtual LAN (VLAN)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_011)

[VLAN database](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_012)

[voice VLAN](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch10.xhtml#key_013)

### Additional Resources

**Migrating from STP to RSTP:** <https://www.ajsnetworking.com/cisco-migrating-from-stp-to-rstp/>

**VLAN Trunking Protocol Version 3:** <https://www.ajsnetworking.com/vlan-trunking-protocol-vtp-version-3/>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz10_1) What is the distance limitation of a 1000BASE-T Ethernet network?

1. 100 m
2. 185 m
3. 500 m
4. 2 km

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz10_2) If two devices simultaneously transmit data on an Ethernet network and a collision occurs, what does each station do in an attempt to resend the data and avoid another collision?

1. Each device compares the other device’s priority value (determined by IP address) with its own, and the device with the highest priority value transmits first.
2. Each device waits for a clear-to-send (CTS) signal from the switch.
3. Each device randomly picks a priority value, and the device with the highest value transmits first.
4. Each device sets a random back-off timer, and a device attempts retransmission after the timer expires.

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz10_3) Which of the following statements are true regarding VLANs? (Choose two.)

1. A VLAN has a single broadcast domain.
2. For traffic to pass between two VLANs, that traffic must be routed.
3. Because of a switch’s MAC address table, traffic does not need to be routed to pass between two VLANs.
4. A VLAN has a single collision domain.

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz10_4) What name is given to a VLAN on an IEEE 802.1Q trunk whose frames are not tagged?

1. Native VLAN
2. Default VLAN
3. Management VLAN
4. VLAN 0

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz10_5) In a topology running STP, every network segment has a single \_\_\_\_\_\_\_\_\_\_\_\_\_\_ port, which is the port on that segment that is closest to the root bridge in terms of cost.

1. Root
2. Designated
3. Nondesignated
4. Nonroot

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz10_6) What is the IEEE standard for link aggregation?

1. 802.1Q
2. 802.3ad
3. 802.1d
4. 802.3af

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz10_7) What is the maximum amount of power a switch is allowed to provide per port, according to the IEEE 802.3af standard?

1. 7.7W
2. 15.4W
3. 26.4W
4. 32.4W

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz10_8) What is the purpose of LACP in a modern network?

1. To provide a backup copy of the VLAN database
2. To bundle interfaces together to act as a single interface
3. To provide additional NVRAM for modern switches
4. To provide additional interface buffer space

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz10_9) Which of the following represents a system in which data simultaneously transmits in two directions?

1. Half-duplex
2. MTU
3. Jumbo frame
4. Full-duplex

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz10_10) Which is a virtual interface configured on a Layer 2 switch to enable routing between VLANs?

1. SVI
2. 802.1Q
3. Native VLAN
4. VLAN tag