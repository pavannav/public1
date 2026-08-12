## Chapter 11

## Configure Wireless Devices and Technologies

This chapter covers the following topics related to Objective 2.3 (Given a scenario, select and configure wireless devices and technologies) of the CompTIA Network+ N10-009 certification exam:

- [Channels](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11lev2sec6)

  - Channel width
  - Non-overlapping channels
  - Regulatory impacts
  - 802.11h
- [Frequency options](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11lev2sec6)

  - 2.4GHz
  - 5GHz
  - 6GHz
  - Band steering
- Service set identifier (SSID)

  - Basic service set identifier (BSSID)
  - Extended service set identifier (ESSID)
- Network types

  - Mesh networks
  - Ad hoc
  - Point to point
  - Infrastructure
- Encryption

  - [Wi-Fi Protected Access 2 (WPA2)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11lev3sec5)
  - [WPA3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11lev3sec6)
- [Guest networks](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11lev2sec4)

  - Captive portals
- Authentication

  - Pre-shared key (PSK) vs. Enterprise
- [Antennas](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11lev2sec5)

  - Omnidirectional vs. directional
- Autonomous vs. lightweight access point

The popularity of wireless LANs (WLANs) has exploded over the past decade, allowing users to roam within a WLAN coverage area, take their laptops and tablets with them, and maintain network connectivity as they move throughout a building or campus environment. Many other devices can also take advantage of wireless networks, such as gaming consoles, smartphones, and printers.

This chapter introduces WLAN technology, along with various wireless concepts, components, and standards. It also presents WLAN design considerations, followed by a discussion of WLAN security.

### Foundation Topics

### Introducing Wireless LANs

This section introduces the basic building blocks of WLANs and discusses how WLANs connect to a wired local area network (LAN). Various design options, including antenna design, frequencies, and communications *channels*, are discussed, along with a comparison of today’s major wireless standards, which are all some variant of IEEE 802.11.

#### WLAN Concepts and Components

Wireless devices, such as laptops, tablets, and smartphones, often have built-in wireless cards that allow those devices to communicate on a WLAN. But what is the device to which they communicate? It could be another laptop or device with a wireless card. This would be an example of an [***ad hoc***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_039) WLAN. However, enterprise-class WLANs, and even most WLANs in homes, are configured in such a way that a wireless client connects to some sort of wireless base station, such as a wireless access point (AP) or a wireless router. Many companies offer Wi-Fi as a service, and users in range of an AP can use the AP as a *hotspot*, indicating that Wi-Fi is available through the AP.

Note

A much fancier term for an ad hoc network that you should be aware of is *independent basic service set (IBSS) WLAN*.

This communication might be done using a variety of antenna types, frequencies, and communication channels. The following sections consider some of these elements in more detail.

#### Wireless Routers

Consider the basic WLAN topology shown in [Figure 11-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig01). Such a WLAN might be found in a residence whose Internet access is provided by a high-speed cable modem. In this topology, a wireless router and switch are shown as separate components. However, in many residential networks, a wireless router integrates switch ports and wireless routing functionality into a single device.

![](../images/key_topic_icon_158.jpg)

![](../images/11fig01.jpg)


**Figure 11-1** Basic WLAN Topology with a Wireless Router

In [Figure 11-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig01), the cable modem obtains an IP address via DHCP from the Internet service provider (ISP). The wireless router behind the modem also uses DHCP to provide IP addresses to LAN devices attaching to it wirelessly or through a wired connection. The process through which a wireless client (for example, a laptop or a smartphone) attaches with a wireless router (or wireless AP) is called *association*. All wireless devices associating with a single AP share a collision domain. Therefore, for scalability and performance reasons, WLANs might include multiple APs. The router then uses port address translation to allow packets to leave the LAN and head to the Internet.

#### Wireless Access Point

Although a wireless access point (AP) interconnects a wired LAN with a WLAN, it does not interconnect two networks (for example, the service provider’s network and an internal network). [Figure 11-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig02) shows a typical deployment of an AP.

![](../images/11fig02.jpg)


**Figure 11-2** Basic WLAN Topology with a Wireless AP

In [Figure 11-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig02), the AP connects to the wired LAN, and the wireless devices that connect to the wired LAN via the AP are on the same subnet as the AP. Notice that no NAT or PAT is being performed. The access point is acting as a wireless bridge between the wireless clients connected to the AP and the wired devices connected to the switch in the same Layer 2 domain.

![](../images/key_topic_icon_158.jpg)

Note

NAT and PAT were covered in [Chapter 9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09), “[Routing Technologies](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch09.xhtml#ch09).”

When it comes to managing access points, there are two approaches based upon the access points in use by an organization:

- [***Autonomous access points***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_075): These APs are self-contained network devices that manage all wireless network functions independently, without the need for a central controller. They are equipped with built-in capabilities to handle tasks such as service set identifier (SSID) broadcasting, client authentication, security enforcement, and traffic routing. Each autonomous access point operates as a standalone unit, making them suitable for smaller networks or environments where centralized management is not required. They offer flexibility and simplicity, as each device can be individually configured and managed, but this can lead to challenges in large-scale deployments due to the lack of centralized control and increased administrative overhead.
- [***Lightweight access points (LWAPs)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_371): These APs are designed to work in conjunction with a central wireless LAN controller (WLC). Unlike autonomous access points that operate independently, LWAPs delegate most of their functionality, such as security policies, SSID configuration, and client authentication, to the controller, simplifying network management and enhancing scalability. They primarily handle the transmission and reception of wireless signals and rely on the controller for complex processing tasks. This architecture allows for centralized management, easier updates, and improved security across the network, making LWAPs ideal for environments with large-scale or dynamic wireless deployments.

Most wireless vendors offer both autonomous and lightweight access points. In fact, some models even allow you to switch between the modes on a single device. A Cisco model Catalyst CW9800M is an example of a wireless LAN controller for multiple APs. The protocols used to communicate between an AP and a WLC could be the older Lightweight Access Point Protocol (LWAPP) or the more current Control and Provisioning of Wireless Access Points (CAPWAP). With a WLC, VLAN pooling can be used to assign IP addresses to wireless clients from a pool of IP subnets and their associated VLANs.

#### Guest Networks

Today, enterprise and even home wireless networks might choose to provide [***guest network***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_290) services. Guest networks provide a separate and secure Wi-Fi connection for visitors, isolating their traffic from the internal network to safeguard sensitive data and resources. These networks are typically designed to offer Internet access without compromising the security of the host network.

To manage and authenticate users, many guest networks employ [***captive portals***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_120), which are web pages that users must interact with before gaining network access. When a guest connects to the Wi-Fi, they are redirected to a captive portal, where they might need to provide credentials, accept terms of service, or enter a voucher code. This process not only enhances security by controlling and monitoring access but also allows network administrators to collect user information and enforce usage policies. Captive portals can also present opportunities for branding and communication with guests, making them a valuable tool for businesses and organizations aiming to provide a secure and user-friendly Wi-Fi experience.

#### Antennas

The coverage area of a WLAN is largely determined by the type of [***antenna***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_049) used on a wireless AP or a wireless router. Although some lower-end, consumer-grade wireless APs have fixed antennas, higher-end, enterprise-class wireless APs often support various antenna types.

Design goals to keep in mind when selecting an antenna include the following:

![](../images/key_topic_icon_158.jpg)

- The required distance between an AP and a wireless client
- The coverage area pattern (For example, the coverage area might radiate out in all directions, forming a spherical coverage area around an antenna, or an antenna might provide increased coverage in only one or two directions.)
- The type of environment—either indoor or outdoor
- The need to avoid interference with other APs

The strength of the electromagnetic waves being radiated from an antenna is referred to as *gain*, and it involves a measurement of both direction and efficiency of a transmission. For example, the gain measurement for a wireless AP’s antenna transmitting a signal is a measurement of how efficiently the power being applied to the antenna is converted into electromagnetic waves being broadcast in a specific direction. Conversely, the gain measurement for a wireless AP’s antenna receiving a signal is a measurement of how efficiently the received electromagnetic waves arriving from a specific direction are converted back into electricity leaving the antenna.

Gain is commonly measured using the dBi unit of measure, where *dB* stands for *decibels*, and *i* stands for *isotropic*. A decibel, in this context, is a ratio of radiated power to a reference value. In the case of dBi, the reference value is the signal strength (power) radiated from an isotropic antenna, which represents a theoretical antenna that radiates an equal amount of power in all directions (in a spherical pattern). An isotropic antenna is considered to have gain of 0 dBi.

Here is the most common formula used for antenna gain:

GdBi = 10 × log10 (*G*)

Based on this formula, an antenna with a peak power gain of 4 (*G*) would have a gain of 6.02 dBi. Antenna theory can become mathematical, heavily relying on the use of Maxwell’s equations. However, generally speaking, if one antenna has 3 dB more gain than another antenna, it has approximately twice the effective power.

Antennas are classified not just by their gain but also by their coverage area. There are two broad categories of antennas, based on coverage area:

- **Omnidirectional:** An [***omnidirectional antenna***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_464) (sometimes simply called an *omni*) radiates power at relatively equal power levels in all directions; it is somewhat similar to a theoretical isotropic antenna. Omnidirectional antennas, an example of which is depicted in [Figure 11-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig03), are popular in residential WLANs and small office/home office (SOHO) locations.

![](../images/key_topic_icon_158.jpg)

![](../images/11fig03.jpg)


**Figure 11-3** Omnidirectional Antenna Coverage

- **Unidirectional:** A *unidirectional antenna* (sometimes just termed a [***directional antenna***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_214)) can focus its power in a specific direction, thus avoiding potential interference with other wireless devices and perhaps reaching greater distances than are possible with omnidirectional antennas. A Yagi antenna is a popular example of a directional antenna. One application for directional antennas is interconnecting two nearby buildings, as shown in [Figure 11-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig04).

![](../images/key_topic_icon_158.jpg)

![](../images/11fig04.jpg)


**Figure 11-4** Unidirectional Antenna Coverage

Another consideration for antenna installation is the horizontal or vertical orientation of the antenna. For best performance, if two wireless APs communicate with one another, they need to have matching antenna orientations (that is, their *polarity* needs to be the same).

#### Channel and Frequency Options

In [Chapter 5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05), “[Transmission Media and Transceivers](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05),” you learned the details of the channels and frequencies used in wireless networking today. In this section, we provide a targeted review of this information along with some additional information made popular in today’s enterprise networks.

Be sure to remember these key points:

- [***Channel width***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_135) refers to the size of the frequency band used to transmit data between wireless devices, directly influencing the network’s data throughput and performance. Standard channel widths for Wi-Fi networks include 20MHz, 40MHz, 80MHz, and even 160MHz, with wider channels generally offering higher data rates by allowing more data to be transmitted simultaneously. However, increasing channel width can also raise the potential for interference, especially in environments with multiple Wi-Fi networks or other sources of radio frequency interference (RFI). Wider channels are more susceptible to overlap with adjacent networks, which can degrade performance. Therefore, while 80MHz and 160MHz channels are favored for their capacity to deliver faster speeds in newer Wi-Fi standards like Wi-Fi 6 (802.11ax) and Wi-Fi 6E (802.11ax operating in the 6GHz band), careful consideration must be given to network planning and environmental factors to optimize performance and minimize interference.
- As referenced in [Chapter 5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05), [***non-overlapping channels***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_458) are critical for optimizing performance and minimizing interference. In the [***2.4GHz***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_001) band, which is more congested and prone to interference due to its limited spectrum, only three non-overlapping channels (typically channels 1, 6, and 11) can be used effectively without overlapping adjacent channels, thus reducing the risk of cross-channel interference. In contrast, the [***5GHz***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_005) and [***6GHz***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_006) bands offer a broader spectrum, allowing for more non-overlapping channels that can support wider channel widths, such as 20MHz, 40MHz, 80MHz, and 160MHz. This greater availability of non-overlapping channels facilitates higher data rates and more robust connections, as devices can operate in a cleaner spectrum with reduced likelihood of co-channel interference.
- Regulatory impacts have certainly made their mark on the field of wireless. For example, IEEE [***802.11h***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_022) is an amendment to the 802.11 standard that enhances wireless networking by introducing mechanisms for dynamic frequency selection (DFS) and transmit power control (TPC). Developed to comply with regulatory requirements, particularly in Europe, 802.11h addresses the need to coexist with radar systems and other incumbent services in the 5GHz frequency band. DFS allows wireless access points to detect radar signals and dynamically switch to a different channel if interference is detected, thereby preventing disruption to critical radar operations. TPC helps in managing the power levels of transmissions to avoid interference with other devices and to optimize energy usage.
- [***Band steering***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_081) is a technique used by modern Wi-Fi access points to manage and direct client devices to the most appropriate frequency band—typically between the 2.4GHz and 5GHz bands. When a dual-band access point detects a client device that can operate on both the 2.4GHz and 5GHz bands, it can “steer” the device to the 5GHz band to alleviate congestion on the 2.4GHz band, which is more prone to interference and crowding due to its limited number of channels and higher usage by various devices. Band steering helps balance the load across both frequency bands, improving overall network performance and user experience by reducing interference and maximizing the available bandwidth.

### Deploying Wireless LANs

A variety of installation options and design considerations are involved in designing and deploying WLANs. This section delves into the available options and provides you with some best-practice recommendations.

#### Types of WLANs

WLANs can be categorized based on their use of wireless APs. The three main categories are *independent basic service set* (*IBSS*; aka *ad hoc*), *basic service set (BSS)*, and *extended service set (ESS)*. An IBSS WLAN operates in an ad hoc fashion, whereas BSS and ESS WLANs operate in [***infrastructure mode***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_320). The following sections describe these three types of WLANs in detail.

##### IBSS

As shown in [Figure 11-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig05), a WLAN can be created without the use of an AP. Such a configuration, called an independent basic service set (IBSS), is said to work in an ad hoc fashion. An ad hoc WLAN is useful for temporary connections between wireless devices. For example, you might temporarily interconnect two laptop computers to transfer a few files.

![](../images/key_topic_icon_158.jpg)

![](../images/11fig05.jpg)


**Figure 11-5** Independent Basic Service Set (IBSS) WLAN

##### BSS

[Figure 11-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig06) depicts a WLAN using a single AP. A WLAN that has just one AP is called a basic service set (BSS) WLAN. BSS WLANs are said to run in *infrastructure mode* because wireless clients connect to an AP, which is typically connected to a wired network infrastructure. BSS networks are often used in residential and SOHO locations, where the signal strength provided by a single AP is sufficient to service all the WLAN’s wireless clients.

![](../images/key_topic_icon_158.jpg)

![](../images/11fig06.jpg)


**Figure 11-6** Basic Service Set (BSS) WLAN

##### ESS

[Figure 11-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig07) illustrates a WLAN using two APs. A WLAN containing more than one AP is called an extended service set (ESS) WLAN. Like BSS WLANs, ESS WLANs operate in infrastructure mode. When you have more than one AP, it is important to prevent one AP from interfering with another. Specifically, the previously discussed non-overlapping channels (channels 1, 6, and 11 for the 2.4GHz band) should be selected for adjacent wireless coverage areas.

![](../images/key_topic_icon_158.jpg)

![](../images/11fig07.jpg)


**Figure 11-7** Extended Service Set (ESS) WLAN

##### Mesh Topology

A [***mesh***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_409) wireless network is a collection of wireless devices that may not use centralized control (but instead features decentralized management). The combined wireless coverage range defines the range of the network. This could also be referred to as a *mesh cloud*. Additional wireless technologies (besides Wi-Fi) could be used to build a mesh wireless topology. This type of network could be used for hosts to communicate with other devices in the mesh, or the network could provide a gateway to the Internet or other networks.

Note

You might also encounter an opposite type of topology to the mesh network when you are working with wireless technologies. This would be the [***point-to-point***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_499) network type. A point-to-point wireless topology connects two distinct locations using a direct wireless link, effectively functioning as a wireless bridge. This setup allows for high-speed data transmission between the two points without the need for physical cabling, making it ideal for connecting buildings, campuses, or remote sites. The topology typically uses directional antennas that focus the signal in a narrow beam, ensuring a reliable and efficient connection over distances that can range from a few hundred meters to several kilometers.

#### Sources of Interference

A major issue for WLANs is radio frequency interference (RFI) caused by other devices using frequencies similar to those of the WLAN devices. Also, physical obstacles can impede or reflect WLAN transmissions. The following are some of the most common sources of interference:

![](../images/key_topic_icon_158.jpg)

- **Other WLAN devices:** Earlier in this chapter, you read about non-overlapping channels for both the 2.4GHz and 5GHz bands. If two or more WLAN devices are in close proximity and use overlapping channels, those devices could interfere with one another.
- **Cordless phones:** Several models of cordless phones operate in the 2.4GHz band and can interfere with WLAN devices. However, if you need cordless phones to coexist in an environment with WLAN devices using the 2.4GHz band, consider the use of Digital Enhanced Cordless Telecommunications (DECT) cordless phones. Although the exact frequencies used by DECT cordless phones vary based on country, DECT cordless phones do not use the 2.4GHz band. For example, in the United States, DECT cordless phones use frequencies in the range 1.92GHz–1.93GHz.
- **Microwave ovens:** Older microwave ovens, which might not have sufficient shielding, can emit relatively high-powered signals in the 2.4GHz band, resulting in significant interference with WLAN devices operating in the 2.4GHz band.
- **Wireless security system devices:** Most wireless security cameras operate in the 2.4GHz frequency range, which can cause potential issues with WLAN devices.
- **Physical obstacles:** In electromagnetic theory, radio waves cannot propagate through a perfect conductor. So, although metal filing cabinets and large appliances are not perfect conductors, they are sufficient to cause degradation of a WLAN signal. For example, a WLAN signal might hit a large air conditioning unit, causing the radio waves to be reflected and scattered in multiple directions. Not only does this limit the range of the WLAN signal, but also radio waves carrying data might travel over different paths. This *multipath issue* can cause data corruption. Concrete walls, metal studs, and even window film can reduce the quality of the wireless network signals.
- **Signal strength:** The range of a WLAN device is a function of the device’s signal strength. Lower-cost consumer-grade APs do not typically allow administrative adjustment of signal strength. However, enterprise-class APs often allow signal strength to be adjusted to ensure sufficient coverage of a specific area, while avoiding interference with other APs using the same channel.

As you can see from this list, most RFI occurs in the 2.4GHz band rather than the 5GHz band. Therefore, depending on the wireless clients you need to support, you might consider using the 5GHz band, which is an option with the newer wireless standards. With the increased use of wireless, both coverage and capacity-based planning should be done to provide acceptable goodput. *Goodput* refers to the number of useful information bits that the network can deliver (not including overhead for the protocols being used). Another factor is the density (that is, the ratio of users to APs), which, if too high, could harm performance of the network. Areas expecting high density include classrooms, hotels, and hospitals. Device or bandwidth saturation could impact performance.

#### Wireless AP Placement

A WLAN using more than one AP (that is, an ESS WLAN) requires careful planning to prevent the APs from interfering with one another while still servicing a desired coverage area. Specifically, an overlap of coverage between APs should exist to allow uninterrupted *roaming* from one WLAN *cell* (which is the coverage area provided by an AP) to another. However, those overlapping coverage areas should not use overlapping frequencies.

[Figure 11-8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig08) shows how non-overlapping channels in the 2.4GHz band can have overlapping coverage areas to provide seamless roaming between AP coverage areas. A common WLAN design recommendation is to have 10% to 15% overlap of coverage between adjoining cells.

![](../images/key_topic_icon_158.jpg)

![](../images/11fig08.jpg)


**Figure 11-8** Coverage Overlap in Coverage Areas for Non-overlapping Channels

If a WLAN has more than three APs, the APs are deployed in a honeycomb fashion to allow an overlap of AP coverage areas while avoiding an overlap of identical channels. The example in [Figure 11-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig09) shows an approach to channel selection for adjoining cells in the 2.4GHz band. Notice that cells using the same non-overlapping channels (channels 1, 6, and 11) are separated by another cell. For example, notice that none of the cells using channel 11 overlap another cell using channel 11.

![](../images/key_topic_icon_158.jpg)

![](../images/11fig09.jpg)


**Figure 11-9** Non-overlapping Coverage Cells for the 2.4GHz Band

Note

Although a honeycomb channel assignment scheme can be used for the 5GHz band, identical channels should be separated by at least two cells rather than by a single cell, as shown in [Figure 11-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig09) for the 2.4GHz band.

### Securing Wireless LANs

WLANs introduce some unique concerns to a network. For example, improperly installing wireless APs is roughly equivalent to putting an Ethernet port in a building’s parking lot, where someone can drive up and access your network. Fortunately, various features are available to harden the security of your WLAN, as discussed in this section.

#### Security Issues

In the days when dial-up modems were popular, malicious users could run a program on a computer to call all phone numbers in a certain number range. Phone numbers that answered with a modem tone became targets for later attacks. This type of reconnaissance was known as *war dialing*. A modern-day variant of war dialing is *war driving*, where potentially malicious users drive around looking for unsecured WLANs. These users might be identifying unsecured WLANs for nefarious purposes or simply looking for free Internet access. Devices such as cell phones, laptops, tablets, and gaming and media devices could act as wireless clients as well as be used in a wireless attack because they have potential Wi-Fi access to the network.

Other WLAN security threats include the following:

![](../images/key_topic_icon_158.jpg)

- **War chalking:** Once an open WLAN (that is, a WLAN whose SSID and authentication credentials are known) is found in a public place, a user might write a symbol on a wall (or some other nearby structure) to let others know the characteristics of the discovered network. This practice, which is a variant of the decades-old practice of hobos leaving symbols as messages to fellow hobos, is called *war chalking*. [Figure 11-10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig10) shows common war-chalking symbols.

![](../images/11fig10.jpg)


**Figure 11-10** War-Chalking Symbols


Note

Just as technologies evolve, so do computer criminals. War flying features the use of mobile devices in conjunction with drones or other aircraft to find wireless networks.

- **WEP and WPA security cracking:** As discussed later in this chapter, various security standards are available for encrypting and authenticating a WLAN client with an AP. Two of the less secure standards are Wired Equivalent Privacy (WEP) and *Wi-Fi Protected Access (WPA)*. Although WPA is considered more secure than WEP, utilities are available on the Internet for cracking each of these approaches to wireless security. By collecting enough packets transmitted by a secure AP, these cracking utilities can use mathematical algorithms to determine the *pre-shared key (PSK)* configured on a wireless AP with which an associating wireless client must also be configured. Pre-shared keys are covered in more detail in the next section.
- **Rogue access point:** A malicious user may set up an AP called a *rogue access point* to which legitimate users can connect. The malicious user might then use a packet sniffer (which displays information about unencrypted traffic, including the traffic’s data and header information) to eavesdrop on communications flowing through the rogue AP. To cause unsuspecting users to connect to the rogue AP, the malicious user could configure the AP with the same [***service set identifier (SSID)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_607) used by a legitimate AP. When a rogue AP is configured with the SSID of a legitimate AP, the rogue AP is commonly referred to as an *evil twin*. Rogue access points are just one reason it is wise to change default SSIDs on wireless equipment. And remember, do not use company information (brand names, divisions, etc.) when creating the unique SSID.

Note

An SSID is a string of characters identifying a WLAN. APs participating in the same WLAN (that is, in an ESS) can be configured with identical SSIDs. An SSID shared among multiple APs is called an [***extended service set identifier (ESSID)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_259). Sure enough, the basic service set (BSS) wireless network uses an SSID called a [***basic service set identifier (BSSID)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_088). While the SSID is often a “friendly name” that is relatively easy to identify, the BSSID is the MAC address of the access point.

#### Approaches to WLAN Security

A WLAN that does not require [***authentication***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_067) or provide encryption for wireless devices (for example, a publicly available WLAN, such as the ones in many airports) is said to be using *open authentication*. To protect such a WLAN’s traffic from eavesdroppers, a variety of security standards and practices have been developed, including the following:

- **MAC address filtering:** An AP can be configured with a list of MAC addresses that are permitted to associate with the AP. If a malicious user attempts to connect via a laptop whose MAC address is not on the list of trusted MAC addresses, that user is denied access. One drawback to MAC address filtering is the administrative overhead required to keep an approved list of MAC addresses up to date. Another issue with MAC address filtering is that a knowledgeable user could falsify the MAC address of a wireless network card, making a device appear to be approved.
- **Disabling SSID broadcast:** An SSID can be broadcast by an AP to let users know the name of the WLAN. For security purposes, an AP might be configured not to broadcast its SSID. However, knowledgeable users could still determine the SSID of an AP by examining captured packets.
- [***Pre-shared key (PSK)*:**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_521) To encrypt transmission between a wireless client and an AP (in addition to authenticating a wireless client with an AP), both the wireless client and the AP could be preconfigured with a matching string of characters (a PSK, as previously described). The PSK could be used as part of a mathematical algorithm to encrypt traffic, such that if an eavesdropper intercepted the encrypted traffic, they would not be able to decrypt the traffic without knowing the PSK. Although using a PSK can be effective in providing security for a small network (such as a SOHO network), it lacks scalability. For example, in a large corporate environment, the compromise of a PSK would necessitate the reconfiguration of all devices configured with that PSK. WLAN security based on PSK technology is called *Personal mode* (specifically [***WPA Personal mode***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_775)).

Note

The latest WPA security approach (WPA3) running in Personal mode replaces the PSK approach with a more secure method of authentication called Simultaneous Authentication of Equals (SAE).

- **IEEE 802.1X:** Rather than having all devices in a WLAN configured with the same PSK, a more scalable approach is to require all wireless users to authenticate using their own credentials (for example, a username and password). Allowing users to have their own credentials prevents the compromising of one password from impacting the configuration of all wireless devices. IEEE 802.1X is a technology that allows wireless clients to authenticate with an authentication server—typically, a Remote Authentication Dial-In User Service (RADIUS) server. [Figure 11-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig11) shows a wireless implementation of IEEE 802.1X.

![](../images/11fig11.jpg)


**Figure 11-11** IEEE 802.1X Security for a WLAN

Note

WLAN security based on IEEE 802.1X and a centralized authentication server such as RADIUS is called *Enterprise mode* (or more specifically, [***WPA Enterprise mode***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_774)).

![](../images/key_topic_icon_158.jpg)

Note

IEEE 802.1X works with Extensible Authentication Protocol (EAP) to perform its job of authentication. A variety of EAP types exist, including Lightweight Extensible Authentication Protocol (LEAP), EAP-Flexible Authentication via Secure Tunneling (EAP-FAST), EAP-Transport Layer Security (EAP-TLS), EAP-Tunneled Transport Layer Security (EAP-TTLS), Protected EAP–Generic Token Card (PEAP-GTC), and Protected EAP–Microsoft Challenge Handshake Authentication Protocol Version 2 (PEAP-MSCHAPv2). Although these EAP types differ in their procedures, the overriding goal for all the EAP types is to securely authenticate a supplicant and provide the supplicant and the authenticator a session key that can be used during a single session in the calculation of security algorithms (for example, encryption algorithms).

#### Security Standards

When you’re configuring a wireless client for security, the most common security standards from which you can select are as follows:

![](../images/key_topic_icon_158.jpg)

- [***Wi-Fi Protected Access 2 (WPA2)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_764)
- [***Wi-Fi Protected Access 3 (WPA3)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_765)

The sections that follow describe these standards in detail.

##### WPA2

The IEEE 802.11i standard, which was approved in 2004, requires stronger algorithms for encryption and integrity checking than those used with previous WLAN security protocols, such as WEP and WPA. The requirements set forth in the IEEE 802.11i standard are implemented in the Wi-Fi Alliance’s WPA Version 2 (WPA2) security standard. WPA2 uses Counter Mode with Cipher Block Chaining Message Authentication Code Protocol (CCMP) for integrity checking and *Advanced Encryption Standard (AES)* for encryption. You might find this referenced as simply CCMP-AES. Remember, as covered earlier, any version of WPA that uses a centralized server for authenticating users is referred to as WPA Enterprise mode. Any version of WPA that uses a configured password or PSK instead of a centralized server is referred to as WPA Personal mode.

##### WPA3

Wi-Fi Protected Access 3 (WPA3) is the latest security protocol for wireless networks, designed to enhance security and simplify connectivity compared to its predecessor, WPA2. Introduced by the Wi-Fi Alliance in 2018, WPA3 provides stronger encryption through the adoption of Simultaneous Authentication of Equals (SAE), a more secure key exchange method that mitigates the risks associated with dictionary attacks. It also offers individualized data encryption for each device on the network, ensuring that data remains protected even on open or public networks. WPA3 enhances the end-user experience with easier setup processes, especially for devices without displays, by supporting features like Wi-Fi Easy Connect. Additionally, it includes improved protections for Internet of Things (IoT) devices and ensures better overall security for modern wireless networks.

#### Additional Wireless Options

Other wireless technologies, such as Bluetooth, infrared (IR), and Near Field Communication (NFC), which are often integrated into smartphones, can also provide connectivity for a personal area network (PAN) or other short-range networking applications. Many of these technologies help facilitate the IoT.

Another interesting wireless technology is *geofencing*, which often uses the Global Positioning System (GPS) or radio frequency identification (RFID) to define geographic boundaries. Geofencing allows you to define triggers so that when a device enters (or exits) the boundaries defined by the administrator, an alert is issued.

Geofence virtual barriers can be active or passive. Active geofences require an end user to opt in to location services and require a mobile app to be open. Passive geofences are always on; they rely on Wi-Fi and/or cellular data instead of GPS or RFID and can work in the background.

A practical application of geofencing might be a hospital with patient information on tablets that the hospital distributes to staff. If these tablets travel beyond the geofence, an administrative alert can trigger.

### Real-World Case Study

Acme, Inc. hired an outside contractor that specializes in Wi-Fi. The consultants came in and did a needs assessment and performed a wireless site survey. Recommendations were then made about the need for 15 access points in the headquarters office spaces and 3 access points at each of the remote branch offices. Three wireless LAN controllers, one for each office, will be used to manage the respective access points. The management of the access points through the wireless LAN controllers will be done primarily through the headquarters office, using the WAN that is connecting the branch offices to the headquarters office.

Because of the high number of other Wi-Fi access points being used in the same building as the headquarters office, Acme, Inc. decided to use the 5GHz range (because of the reduced competition in that space) and to use 802.11ax.

For security, Acme, Inc. will use WPA3 in conjunction with a RADIUS server. Acme, Inc. will use Enterprise mode for authentication of each user before allowing users access on the wireless network(s). The RADIUS server is integrated with Microsoft Active Directory so that Acme, Inc. will not have to re-create every user account; the RADIUS server can check with the Active Directory server to verify user credentials and passwords.

Separate SSIDs were set up that map to the various VLANs and departments currently on the wired network. Also, a separate SSID was set up as a wireless guest network that has limited access but does provide Internet access for guest users.

Once all this was in place, a site survey was done again to verify the signal strengths and to identify any interference related to the wireless implementation. A heat map was provided to visually represent the signal strengths in the coverage areas in the respective office spaces.

### Summary

Here are the main topics covered in this chapter:

- This chapter identified various components, technologies, and terms used in WLANs. This included such content as frequencies, SSIDs, network types, guest networks, and access points.
- This chapter presented WLAN design considerations, such as the selection of WLAN standards, bands, and non-overlapping channels. Potential sources of interference were also discussed.
- This chapter described some of the security risks posed by a WLAN and the technologies available for mitigating those risks.
- This chapter also presented information about the different types of antennas found in wireless networks today.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 11-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11tab01) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 11-1** Key Topics for [Chapter 11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| [Figure 11-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig01) | Basic WLAN Topology with a Wireless Router | 287 |
| [Figure 11-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig02) | Basic WLAN Topology with a Wireless AP | 288 |
| List | Antenna selection criteria | 290 |
| [Figure 11-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig03) | Omnidirectional Antenna Coverage | 291 |
| [Figure 11-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig04) | Unidirectional Antenna Coverage | 291 |
| [Figure 11-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig05) | Independent Basic Service Set (IBSS) WLAN | 294 |
| [Figure 11-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig06) | Basic Service Set (BSS) WLAN | 294 |
| [Figure 11-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig07) | Extended Service Set (ESS) WLAN | 295 |
| List | Sources of interference | 296 |
| [Figure 11-8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig08) | Coverage Overlap in Coverage Areas for Non-overlapping Channels | 298 |
| [Figure 11-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig09) | Non-overlapping Coverage Cells for the 2.4GHz Band | 298 |
| List | Wireless security threats | 299 |
| [Figure 11-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11fig11) | IEEE 802.1X Security for a WLAN | 302 |
| List | WLAN security standards and best practices | 303 |

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[2.4GHz](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_01)

[5GHz](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_02)

[6GHz](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_03)

[802.11h](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_04)

[ad hoc](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_05)

[antenna](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_06)

[authentication](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_07)

[autonomous access point](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_08)

[band steering](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_09)

[basic service set identifier (BSSID)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_010)

[captive portals](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_011)

[channel width](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_012)

[directional antenna](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_013)

[extended service set identifier (ESSID)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_014)

[guest network](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_015)

[infrastructure mode](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_016)

[lightweight access point (LWAP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_017)

[mesh](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_018)

[non-overlapping channels](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_019)

[omnidirectional antenna](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_020)

[point to point](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_021)

[pre-shared key (PSK)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_022)

[service set identifier (SSID)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_023)

[Wi-Fi Protected Access 2 (WPA2)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_024)

[Wi-Fi Protected Access 3 (WPA3)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_025)

[WPA Enterprise mode](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_026)

[WPA Personal mode](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#key_027)

### Additional Resources

**Wi-Fi Standards:** <https://youtu.be/q64AZjPfa0Y>

**Fundamentals of Wi-Fi 6**: <https://www.youtube.com/watch?v=V5qLv0BtBcM>

### Review Questions

The answers to these review questions are in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_1) What type of antenna, used in wireless APs and wireless routers in SOHO locations, radiates power equally in all directions?

1. Unidirectional
2. Yagi
3. Parabolic
4. Omnidirectional

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_2) When you’re using the 2.4GHz band for multiple access points in a WLAN in the United States, which non-overlapping channels should you select? (Choose three.)

1. 0
2. 1
3. 5
4. 6
5. 10
6. 11
7. 14

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_3) What is an amendment to the 802.11 standard that enhances wireless networking by introducing mechanisms for dynamic frequency selection and transmit power control?

1. 802.11h
2. 802.11f
3. 802.11p
4. 802.11a

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_4) What type of wireless access point is used with a wireless LAN controller?

1. Standalone access point
2. Rugged access point
3. Autonomous access point
4. Lightweight access point

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_5) What feature is often found in use with guest Wi-Fi networks in order to help enhance security?

1. WEP
2. Captive portal
3. Band steering
4. 802.11h

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_6) A WLAN formed directly between wireless clients (without the use of a wireless AP) is referred to as what type of WLAN?

1. Enterprise mode
2. IBSS
3. Personal mode
4. BSS

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_7) When extending the range for a 2.4GHz WLAN, you can use non-overlapping channels for adjacent coverage cells. However, there should be some overlap in coverage between those cells (using non-overlapping channels) to prevent a connection from dropping as a user roams from one coverage cell to another. What percentage of coverage overlap is recommended for these adjacent cells?

1. 5% to 10%
2. 10% to 15%
3. 15% to 20%
4. 20% to 25%

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_8) If a WLAN does not need a user to provide credentials to associate with a wireless AP and access the WLAN, what type of authentication is in use?

1. WEP
2. SSID
3. Open
4. IV

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_9) Your access point has the ability to direct client devices into the most appropriate frequency band. What is this capability called?

1. Band steering
2. Transmit power control
3. Dynamic frequency selection
4. Simultaneous selection of equals

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_10) Which standard developed by the Wi-Fi Alliance implements the requirements of IEEE 802.11i?

1. TKIP
2. MIC
3. WEP
4. WPA2

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_11) Which security technique uses wireless technologies to create an invisible boundary around some point?

1. WPA3
2. LTE
3. War driving
4. Geofencing

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_12) Which of the following statements are true regarding the features of WPA2 and WPA3? (Select three.)

1. The two versions of WPA2 are WPA2-Personal and WPA2-Enterprise.
2. WPA2 Personal uses pre-shared keys.
3. WPA3 prevents offline password attacks using 802.1X.
4. WPA3 uses 192-bit AES for the Enterprise version.

[**13.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_13) An administrator wants to avoid attacks such as war driving, war chalking, and war flying. What should the admin do to improve the security of the wireless network from such attacks?

1. Change the AP SSID
2. Enable SSID broadcast
3. Blocklist all MAC addresses
4. Allow list all MAC addresses

[**14.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz11_14) You are studying an IEEE standard for port-based access control. This standard specifically provides for the encapsulation of EAP over the IEEE family of standards for packet-based networks and facilitates the use of various authentication methods such as RADIUS and digital certificates. What standard are you studying?

1. 802.11
2. 802.1X
3. PSK
4. 802.11h