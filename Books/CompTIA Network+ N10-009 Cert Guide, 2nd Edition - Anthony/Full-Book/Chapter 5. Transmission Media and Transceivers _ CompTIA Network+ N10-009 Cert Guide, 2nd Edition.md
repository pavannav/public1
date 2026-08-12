## Chapter 5

## Transmission Media and Transceivers

This chapter covers the following topics related to Objective 1.5 (Compare and contrast transmission media and transceivers) of the CompTIA Network+ N10-009 certification exam:

- [Wireless](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05lev1sec2)

  - [802.11 standards](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05lev3sec7)
  - [Cellular](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05lev2sec3)
  - [Satellite](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05lev2sec4)
- Wired

  - 802.3 standards
  - Single-mode vs. multimode fiber
  - Direct attach copper (DAC) cable

    - Twinaxial cable
  - Coaxial cable
  - Cable speeds
  - Plenum vs. non-plenum cable
- [Transceivers](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05lev2sec11)

  - Protocol

    - Ethernet
    - Fibre Channel (FC)
  - Form factors

    - Small form-factor pluggable (SFP)
    - Quad small form-factor pluggable (QSFP)
- Connector types

  - Subscriber connector (SC)
  - Local connector (LC)
  - Straight tip (ST)
  - Multi-fiber push on (MPO)
  - Registered jack (RJ) 11
  - RJ45
  - F-type
  - Bayonet Neill–Concelman (BNC)

Many modern networks have a daunting number of devices, and it is your job to understand the function of each device and how it works with the others. To create a network, these devices need some sort of interconnection. An interconnection uses one of a variety of media types. This chapter dives into the world of physical media, both media you can see (wired) and media that you cannot see (wireless). You will learn about classic media technologies that set the stage for the modern, high-speed media used in networks today. You will also learn about the connectors used for this media.

### Foundation Topics

### Wireless

Later in this chapter, you will learn about a variety of wireless standards, which are all variants of the IEEE [***802.11 standards***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_024). As you contrast one standard with another, a characteristic to watch out for is the frequencies at which these standards operate. Although there are some country-specific variations, certain frequency ranges (or *frequency bands*) have been reserved internationally for industrial, scientific, and medical purposes. These frequency bands are called the *ISM bands*, where ISM derives from *i*ndustrial, *s*cientific, and *m*edical.

Two of these bands are commonly used for WLANs. Specifically, WLANs use the range of frequencies in the 2.4GHz–2.5GHz range (commonly referred to as the *2.4GHz band*) or in the 5.725GHz–5.875GHz range (commonly referred to as the *5GHz band*). In fact, some WLANs support a mixed environment, where 2.4GHz devices run alongside 5GHz devices.

Note

The latest wireless standard, 802.11ax (Wi-Fi 6), takes Wi-Fi operation to the 6GHz frequency. Wi-Fi 6 uses up to 14 additional 80MHz channels or 7 additional super-wide 160MHz channels in the 6GHz band. This new technology is ideal for applications such as high-definition video streaming and virtual reality.

Within each band are specific frequencies (or *channels*) at which wireless devices operate. To avoid interference, nearby wireless APs should use frequencies that do not overlap with one another. You can use wireless survey tools to analyze what is currently in use so you can set up a new wireless system that does not compete for the frequencies that are already in use. Those same tools can also help you identify *wireless channel* utilization in existing and new wireless networks. Regarding channel selection, merely selecting different channels is not sufficient because transmissions on one channel spill over into nearby channels. Site survey tools can collect data to show the relative strength of signals in the areas being serviced by the APs. This output can be color-coded and overlaid on top of the floor plan and is often referred to as a *heat map* of the wireless signals. Heat maps are further covered in [Chapter 13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13), “[Organizational Processes and Procedures](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch13.xhtml#ch13),” as part of the critical documentation that an organization should maintain regarding its networks.

Consider, for example, the 2.4GHz band. Here, channel frequencies are separated by 5MHz (with the exception of channel 14, which has 12MHz of separation from channel 13). However, a single channel’s transmission can spread over a frequency range of 22MHz. As a result, channels must have five channels of separation (5 × 5MHz = 25MHz, which is greater than 22MHz). You can see from [Figure 5-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig01) that, in the United States, you could select the non-overlapping channels 1, 6, and 11.

![](../images/key_topic_icon_158.jpg)

![](../images/05fig01.jpg)


**Figure 5-1** Non-overlapping Channels in the 2.4GHz Band

Note

Remember that non-overlapping channels are a set of wireless frequency channels that do not interfere with each other. For example, in the 2.4GHz band, channels 1, 6, and 11 are non-overlapping channels for Wi-Fi networks. Even though some countries use channel 14 as a non-overlapping channel, it is not supported in the United States.

As a reference, [Table 5-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05tab01) shows the specific frequencies for each of the channels in the 2.4GHz band.

**Table 5-1** Channel Frequencies in the 2.4GHz Band

| Channel | Frequency (GHz) | Recommended as a Non-overlapping Channel |
| --- | --- | --- |
| 1 | 2.412 | Yes |
| 2 | 2.417 | No |
| 3 | 2.422 | No |
| 4 | 2.427 | No |
| 5 | 2.432 | No |
| 6 | 2.437 | Yes |
| 7 | 2.442 | No |
| 8 | 2.447 | No |
| 9 | 2.452 | No |
| 10 | 2.457 | No |
| 11 | 2.462 | Yes |
| 12 | 2.467 | No |
| 13 | 2.472 | No |
| 14 | 2.484 | Yes (not supported in the United States) |

The 5GHz band has more channels than the 2.4GHz band. [Table 5-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05tab02) lists the recommended non-overlapping channels for the 5GHz band in the United States. Note that additional channels are supported in some countries.

**Table 5-2** Non-overlapping Channels in the 5GHz Band Recommended for Use in the United States

| Channel | Frequency (GHz) |
| --- | --- |
| 36 | 5.180 |
| 40 | 5.200 |
| 44 | 5.220 |
| 48 | 5.240 |
| 52 | 5.260\* |
| 56 | 5.280\* |
| 60 | 5.300\* |
| 64 | 5.320\* |
| 100 | 5.500\*\* |
| 104 | 5.520\*\* |
| 108 | 5.540\*\* |
| 112 | 5.560\*\* |
| 116 | 5.580\*\* |
| 136 | 5.680\*\* |
| 140 | 5.700\*\* |
| 149 | 5.745 |
| 153 | 5.765 |
| 157 | 5.785 |
| 161 | 5.805 |
| 165 | 5.825 |

\*Must support dynamic frequency selection to prevent interference with RADAR.

\*\*Must be professionally installed.

#### Transmission Methods

In the previous section, you learned about the frequencies used for various wireless channels. However, you need to be aware that each of those frequencies is considered to be the *center frequency* of a channel. In actual operation, a channel uses more than one frequency, which is a transmission method called *spread spectrum*. These frequencies are, however, very close to one another, which results in a *narrowband transmission*.

Here are the three variations of spread-spectrum technology to be aware of for your study of wireless:

![](../images/key_topic_icon_158.jpg)

- **Direct-sequence spread spectrum (DSSS):** DSSS modulates data over an entire range of frequencies by using a series of symbols called *chips*. A chip is shorter in duration than a bit, meaning that chips are transmitted at a higher rate than is the actual data. These chips encode not only the data to be transmitted but also what appears to be random data. Although both parties involved in a DSSS communication know which chips represent actual data and which chips do not, if a third party intercepted a DSSS transmission, it would be difficult for that party to eavesdrop on the data because they would not easily know which chips represented valid bits. DSSS is more subject to environmental factors than FHSS and OFDM because of its use of an entire frequency spectrum.
- **Frequency-hopping spread spectrum (FHSS):** FHSS allows the participants in a communication to hop between predetermined frequencies. Security is enhanced because the participants can predict the next frequency to be used but a third party cannot easily predict the next frequency. FHSS can also provision extra bandwidth by simultaneously using more than one frequency.
- **Orthogonal frequency-division multiplexing (OFDM):** Whereas DSSS uses a high modulation rate for the symbols it sends, OFDM uses a relatively slow modulation rate for symbols. This slower modulation rate, combined with the simultaneous transmission of data over 52 data streams, helps OFDM support high data rates while resisting interference between the various data streams.

Note

Wi-Fi 6 features the latest enhancements in technology and uses the latest spread-spectrum technology, called *orthogonal frequency-division multiple access* (*OFDMA*). OFDMA provides sophisticated scheduling techniques to provide better performance in highly congested Wi-Fi environments.

#### WLAN Standards (802.11)

Most modern WLAN standards are variations of the original IEEE 802.11 standard, which was developed in 1997. This original standard supported a DSSS implementation and an FHSS implementation, both of which operated in the 2.4GHz band. However, with supported speeds of 1Mbps or 2Mbps, the original 802.11 standard lacks sufficient bandwidth to meet the needs of today’s WLANs. The most popular variants of the 802.11 standard in use today are 802.11n, 802.11ac, and 802.11ax, as described in detail in the following sections.

##### 802.11a

The *802.11a* WLAN standard, which was ratified in 1999, supported speeds as high as 54Mbps. Other supported data rates (which could be used if conditions were not suitable for the 54Mbps rate) included 6Mbps, 9Mbps, 12Mbps, 18Mbps, 24Mbps, 36Mbps, and 48Mbps. The 802.11a standard used the 5GHz band and used the OFDM transmission method. Interestingly, 802.11a never gained widespread adoption because it was not backward compatible with 802.11b, whereas 802.11g was backward compatible. However, it is worth noting that 802.11a was a possible alternative to 802.11b/g, as the 2.4GHz band was often far more crowded than the 5GHz band.

##### 802.11b

The *802.11b* WLAN standard, which was ratified in 1999, supported speeds as high as 11Mbps. However, 5.5Mbps was another supported data rate. The 802.11b standard used the 2.4GHz band and used the DSSS transmission method.

##### 802.11g

The *802.11g* WLAN standard, which was ratified in 2003, supported speeds as high as 54Mbps. Like 802.11a, 802.11g also supported data rates of 6Mbps, 9Mbps, 12Mbps, 18Mbps, 24Mbps, 36Mbps, and 48Mbps. However, like 802.11b, 802.11g operated in the 2.4GHz band, which allowed it to offer backward compatibility to 802.11b devices. 802.11g used either the OFDM or the DSSS transmission method.

##### 802.11n (Wi-Fi 4)

The *802.11n* WLAN standard, which was ratified in 2009, supports a wide variety of speeds, depending on its implementation. Although the speed of an 802.11n network could exceed 300Mbps (through the use of channel bonding, which is discussed shortly), many 802.11n devices on the market have speed ratings in the 130Mbps–150Mbps range. An 802.11n WLAN can operate in the 2.4GHz band, the 5GHz band, or both simultaneously. 802.11n uses the OFDM transmission method.

One way 802.11n achieves superior throughput compared to earlier Wi-Fi standards is through the use of a technology called *multiple input, multiple output (MIMO)*. MIMO uses multiple antennas for transmission and reception. These antennas do not interfere with one another, thanks to MIMO’s use of *spatial multiplexing*, which encodes data based on the antenna from which the data will be transmitted. Both reliability and throughput are increased by MIMO’s simultaneous use of multiple antennas. [Chapter 11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11), “[Configure Wireless Devices and Technologies](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11),” will have lots more to say on the important subject of wireless antennas.

Yet another technology implemented by 802.11n is *channel bonding*. With channel bonding, two *wireless bands* are logically bonded together, forming a band with twice the bandwidth of an individual band. Some literature refers to channel bonding as *40MHz mode*, which is the bonding of two adjacent 20MHz bands into a 40MHz band.

The 802.11n High Throughput (HT) standard defines modes for ensuring that older a/b/g devices and newer 802.11n devices avoid collisions with each other.

Note

The IEEE finally accepted the fact that using the standard identification codes for describing wireless to nontechnical end users makes no sense, and it is now using simpler names for recent standards. For example, 802.11n is called Wi-Fi 4, 802.11ac is Wi-Fi 5, and 802.11ax is Wi-Fi 6.

##### 802.11ac (Wi-Fi 5)

*802.11ac* is a 5GHz standard that uses more simultaneous streams than 802.11n and features *multi-user MIMO (MU-MIMO)*. MU-MIMO is a set of advanced MIMO technologies included with IEEE 802.11ac and 802.11ax that dramatically enhances wireless throughput. MU-MIMO is an enhancement over the original MIMO technology. It allows antennas to be spread over a multitude of independent access points. Thanks to 802.11ac technology, a single 80MHz stream supports 433Mbps.

##### 802.11ax (Wi-Fi 6)

*802.11ax* (Wi-Fi 6) is up to 30% faster than Wi-Fi 5 (802.11ac), but even more exciting are its lower latency, more simultaneously deliverable data, and improved power efficiency. Wi-Fi 6 is the first iteration of 802.11 to include OFDMA (which is an improvement on OFDM). OFDMA can transmit data to multiple devices at the same time. It does so by splitting traffic into smaller packets to eliminate queueing. Also, Wi-Fi 6 adds MU-MIMO capabilities to upstream connections. The net effect of this is to allow more devices on one network at the same time.

Note

What about Wi-Fi 7? Wi-Fi 7 is indeed being developed as I write this text. It is based on IEEE 802.11be technology and enhances Wi-Fi performance in the 2.4GHz, 5GHz, and 6GHz bands, bringing cutting-edge capabilities to enable innovations that require high throughput, lower latency, and greater reliability across home, enterprise, and industrial environments.

##### 802.11 Standards Summary

[Table 5-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05tab03) provides a reference to help you contrast the characteristics of the 802.11 standards.

![](../images/key_topic_icon_158.jpg)


**Table 5-3** Characteristics of 802.11 Standards

| Standard | Band | Maximum Bandwidth | Transmission Method | Maximum Range |
| --- | --- | --- | --- | --- |
| 802.11 | 2.4GHz | 1Mbps or 2Mbps | DSSS or FHSS | 20 m indoors/100 m outdoors |
| 802.11a | 5GHz | 54Mbps | OFDM | 35 m indoors/120 m outdoors |
| 802.11b | 2.4GHz | 11Mbps | DSSS | 32 m indoors/140 m outdoors |
| 802.11g | 2.4GHz | 54Mbps | OFDM or DSSS | 32 m indoors/140 m outdoors |
| 802.11n | 2.4GHz or 5GHz (or both) | > 300Mbps (with channel bonding) | OFDM | 70 m indoors/250 m outdoors |
| 802.11ac | 5GHz | > 3Gbps (with MU-MIMO and several antennas) | OFDM | 70 m indoors/250 m outdoors |
| 802.11ax | 2.4GHz, 5GHz, 6GHz | 9.6Gbps | OFDMA | 70 m indoors/250 m outdoors |

#### Cellular

Others forms of wireless technologies are in a group termed [***cellular***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_128) because the technology is used on cell phones (among other mobile devices). Some cellular phone technologies, such as *Long-Term Evolution (LTE)*, which supports a 100Mbps data rate for mobile devices and a 1Gbps data rate for stationary devices, can be used to connect a mobile device such as a smartphone to the Internet.

Other technologies for cellular phones include the older 2G (Edge), which offers slow data rates. 2G was improved upon with *3G*, in addition to the newer *4G*, *5G*, *LTE*, and *Evolved High-Speed Packet Access (HSPA+)*.

*Tethering* allows a smartphone’s data connection to be used by another device, such as a laptop. Also, mobile hotspots are growing in popularity because these devices connect to a cell phone company’s data network and make that data network available to nearby devices (typically, a maximum of five devices) via wireless networking technologies. For example, multiple passengers in a car can share a mobile hotspot and have Internet connectivity from their laptops or tablets while riding down the road.

*Code-division multiple access (CDMA)* and *Global System for Mobile Communications (GSM)* are the two major radio systems used in cell phones. GSM uses time-division multiple access (TDMA) in its operation.

#### Satellite

Many rural locations lack the option of connecting to an IP WAN or to the Internet via physical media (for example, a DSL modem or a broadband cable modem connection). For such locations, a [***satellite***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_586) WAN connection, as illustrated in [Figure 5-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig02), might be an option.

![](../images/key_topic_icon_158.jpg)

![](../images/05fig02.jpg)


**Figure 5-2** Satellite WAN Sample Topology

Most satellites used for WAN connectivity are in orbit above the earth’s equator, about 22,300 miles high. Therefore, a customer in North America, for example, with a clear view of the southern sky would be able to install a satellite dish and establish a line-of-sight communication path with the orbiting satellite. The satellite would then relay transmissions back and forth between the customer’s site and the service provider’s ground station. The ground station could then provide connectivity, via physical media, to an IP WAN or to the Internet.

Two significant design considerations need to be taken into account:

- **Delay:** Radio waves travel at the speed of light, which is 186,000 miles per second, or 3 × 108 meters per second. This speed is specifically the speed of light (and radio waves) in a vacuum; technically, the speed of light (and radio waves) is a bit slower when traveling through air than when traveling through a vacuum, but for purposes of the following calculations, the speed of light in a vacuum is used. Although these are fast speeds, consider the distance between a customer and the satellite. If a customer were located 2000 miles north of the equator, the approximate distance between the customer site and the satellite could be calculated using the Pythagorean theorem: *d*2 = 20002 + 22,3002. Solving the equation for *d*, which is the distance between the customer and the satellite, yields a result of approximately 22,390 miles.

  A transmission from a customer to a destination on the Internet (or an IP WAN) would have to travel from the customer to the satellite, from the satellite to the ground station, and then out to the Internet (or IP WAN). The propagation delay alone introduced by bouncing a signal off the satellite is approximately 241 ms—that is, (22,390 × 2) / 186,000 = .241 seconds = 241 ms). In addition, there are other delay components, such as processing delay (by the satellite and other networking devices), making the one-way delay greater than one-fourth of a second and, therefore, the round-trip delay greater than one-half of a second. Such delays are not conducive to latency-sensitive applications such as Voice over IP (VoIP).
- **Sensitivity to weather conditions:** Because communication between a customer’s satellite dish and an orbiting satellite must travel through the earth’s atmosphere, weather conditions can impede communications. For example, if a thunderstorm is near the customer location, that customer might temporarily lose connectivity with their satellite.

Based on these design considerations, even though satellite WAN technology offers tremendous flexibility in terms of geographic location, more terrestrial-based solutions are preferred.

Note

Remember, wireless technologies receive more coverage in [Chapter 11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11).

### Copper and Fiber Media and Connectors

A network is an interconnection of devices. Those interconnections occur over some type of media. The media might be physical, such as a copper or fiber-optic cable. Alternatively, the media might be the air, through which radio waves propagate (as is the case with wireless networking technologies).

This section examines copper and fiber physical media types and the connectors they commonly use.

#### Coaxial Cable

[***Coaxial cable***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_151) (referred to as *coax*) consists of two conductors. As illustrated in [Figure 5-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig03), one of the conductors is an inner insulated conductor. This inner conductor is surrounded by another conductor that is sometimes made of a metallic foil or woven wire.

![](../images/05fig03.jpg)


**Figure 5-3** Coaxial Cable

Because the inner conductor is shielded by the metallic outer conductor, coaxial cable is resistant to electromagnetic interference (EMI). For example, EMI occurs when an external signal is received on a wire and might result in a corrupted data transmission. As another example, EMI occurs when a wire acts as an antenna and radiates electromagnetic waves, which might interfere with data transmission on another cable. Coaxial cables have an associated characteristic impedance that needs to be balanced with the device (or terminator) with which the cable connects.

Note

The term *electromagnetic interference* (*EMI*) is sometimes used interchangeably with the term *radio frequency interference* (*RFI*).

There are three common types of coaxial cables:

- **RG-59:** Typically used for short-distance applications, such as carrying composite video between two nearby devices. This cable type has loss characteristics such that it is not right for long-distance applications. RG-59 cable has a characteristic impedance of 75 ohms.
- **RG-6:** Used by local cable companies to connect individual homes to the cable company’s distribution network. Like RG-59 cable, RG-6 cable has a characteristic impedance of 75 ohms.
- **RG-58:** Has loss characteristics and distance limitations like those of RG-59. However, the characteristic impedance of RG-58 is 50 ohms, and this type of coax was popular with early 10BASE2 Ethernet networks.

Although RG-58 coaxial cable was commonplace in early computer networks (that is, 10BASE2 networks), coaxial cable’s role in modern computer networks is as the media used by cable modems. Cable modems are commonly installed in residences to provide high-speed Internet access over the same connection used to receive multiple television stations.

Note

Far less popular is [***twinaxial cable***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_722), commonly called *twinax*. This is very similar to coaxial cable, but it uses two inner conductors instead of one.

Common connectors used on coaxial cables include the following:

![](../images/key_topic_icon_158.jpg)

- **BNC:** A [***Bayonet Neill-Concelman (BNC)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_090) connector (*British Naval Connector* in some literature) can be used for a variety of applications, including as a connector in a 10BASE2 Ethernet network. A BNC coupler could be used to connect two coaxial cables together back-to-back.
- **F-connector:** An F-connector is often used for cable TV (including cable modem) connections. Notice that some, including CompTIA, refer to it as [***F-type connector***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_264). F-type connectors are used with coaxial cable, most commonly to connect cable modems and TVs. F-type connectors are screw-type connectors.

[Figure 5-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig04) shows what both of these connectors look like.

![](../images/05fig04.jpg)


**Figure 5-4** Coaxial Cable Connectors

One type of twinax copper cable you might encounter in the data center is a [***direct attach copper (DAC) cable***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_212). This cable is used to connect ports of data center network equipment over short distances (think 1 to 2 meters). These cables feature pluggable connectors on each end. As you might expect, the type of connector varies for the equipment used. DAC cables typically consist of copper conductors enclosed in a protective jacket and are terminated with standard connectors, such as small form-factor pluggable (SFP) or quad small form-factor pluggable (QSFP) connectors, discussed later in this chapter.

#### Twisted-Pair Cable

Today’s most popular LAN media type is [***twisted-pair cable***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_723), in which individually insulated copper strands are intertwined. Two categories of twisted-pair cable are shielded twisted pair (STP) and unshielded twisted pair (UTP). A UTP coupler could be used to connect two UTP cables, back-to-back. Also, for adherence to fire codes, you might need to select plenum-rated cable versus nonplenum cable as discussed later in this chapter.

To define industry-standard pinouts and color coding for twisted-pair cabling, the TIA/EIA-568 standard was developed. The first iteration of the TIA/EIA-568 standard, which was released in 1991, has come to be known as the *TIA/EIA-568A* standard.

Note

The TIA/EIA acronym comes from Telecommunications Industry Association/Electronic Industries Alliance. The TIA is an organization that develops standards for telecommunications technologies. The EIA is now defunct.

In 2001, an updated standard was released, which became known as *TIA/EIA-568B*. Interestingly, the pinout of these two standards is the same. However, the color coding of the wiring is different. 568B is the more commonly used standard in the United States.

##### Shielded Twisted Pair

If wires in a cable are not twisted or shielded, the cable can act as an antenna, which might receive or transmit EMI. To help prevent this type of behavior, the wires (which are individually insulated) can be twisted together in pairs.

If the distance between the twists is less than a quarter of the wavelength of an electromagnetic waveform, the twisted pair of wires will not radiate that wavelength or receive EMI from that wavelength (in theory, if the wires were perfect conductors). However, as frequencies increase, wavelengths decrease.

One option for supporting higher frequencies is to surround a twisted pair in a metallic shielding, similar to the outer conductor in a coaxial cable. This type of cable is referred to as a *shielded twisted-pair* (*STP*) *cable*.

[Figure 5-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig05) shows an example of STP cable. The outer conductors shield the copper strands from EMI; however, the drawback of STP is that the addition of the metallic shielding adds to the expense of the cable.

![](../images/05fig05.jpg)


**Figure 5-5** Shielded Twisted Pair

##### Unshielded Twisted Pair

Another way to block EMI from the copper strands making up a twisted-pair cable is to twist the strands more tightly (that is, more twists per centimeter). With the strands wrapped tightly around each other, the wires insulate each other from EMI.

[Figure 5-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig06) illustrates an example of UTP cable. Because UTP is less expensive than STP, it has grown in popularity since the mid-1990s to become the media of choice for most LANs.

![](../images/05fig06.jpg)


**Figure 5-6** Unshielded Twisted Pair

UTP cable types vary in their data-carrying capacity, more commonly known as [***cable speeds***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_114). Common categories of UTP cabling include the following:

![](../images/key_topic_icon_158.jpg)

- **Category 5:** Category 5 (Cat 5) cable is commonly used in [***Ethernet***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_254) 100BASE-TX networks, which carry data at a rate of 100Mbps. However, Cat 5 cable can carry Asynchronous Transfer Mode (ATM) traffic at a rate of 155Mbps. ATM traffic is a data transmission method that uses fixed-size cells to carry diverse types of network traffic, including voice, video, and data, over a single network infrastructure. Most Cat 5 cables consist of four pairs of 24-gauge wires. Each pair is twisted, with a different number of twists per meter. However, on average, one pair of wires has a twist every 5 cm.
- **Category 5e:** Category 5e (Cat 5e) cable is an updated version of Cat 5 that is commonly used for 1000BASE-T networks, which carry data at a rate of 1Gbps. Cat 5e cable offers reduced crosstalk compared to Cat 5 cable. Crosstalk is electronic interference caused when two wires are too close to each other, and the adjacent cable creates interference.
- **Category 6:** Like Cat 5e cable, Category 6 (Cat 6) cable is commonly used for 1000BASE-T Ethernet networks. Some Cat 6 cable is made of thicker conductors (for example, 22-gauge or 23-gauge wire), although some Cat 6 cable is made from the same 24-gauge wire used by Cat 5 and Cat 5e. Cat 6 cable has thicker insulation and offers reduced crosstalk compared with Cat 5e.
- **Category 6a:** Category 6a (Cat 6a), or augmented Cat 6, supports twice as many frequencies as Cat 6 and can be used for 10GBASE-T networks, which can transmit data at a rate of 10 billion bits per second (10Gbps).
- **Category 7:** Cat 7 is not an IEEE standard, and it is not very popular as a result. This very strict specification supports 10Gbps over 100 m using copper media.
- **Category 8:** Cat 8 is capable of 40Gbps speeds. As you might guess, however, this speed comes at a cost. Cat 8 supports distances of only 30 to 36 m, depending on the patch cables used. These short distances and very high speeds are ideal for connections in a data center between high-speed multilayer switches.

Although other wiring categories exist, the ones presented in this list are the categories most commonly seen in modern networks.

Most UTP cabling used in today’s networks is considered to be *straight-through*, meaning that the RJ45 jacks at each end of a cable have matching pinouts. For example, pin 1 in an RJ45 jack at one end of a cable uses the same copper conductor as pin 1 in the RJ45 jack at the other end of a cable.

Note

RJ45 connectors are covered in detail later in this chapter.

However, some network devices cannot be interconnected with a straight-through cable. For example, consider two PCs interconnected with a straight-through cable. Because the network interface cards (NICs) in these PCs use the same pair of wires for transmission and reception, when one PC sends data to the other PC, the receiving PC would receive the data on its transmission wires rather than its reception wires. For such a scenario, you can use a crossover cable, which swaps the transmit and receive wire pairs between the two ends of a cable.

Note

A crossover cable for Ethernet devices is different from a crossover cable used for a digital T1 circuit. Specifically, an Ethernet crossover cable has a pin mapping of 1 [rfa] 3, 2 [rfa] 6, 3 [rfa] 1, and 6 [rfa] 2, whereas a T1 crossover cable has a pin mapping of 1 [rfa] 4, 2 [rfa] 5, 4 [rfa] 1, and 5 [rfa] 2. Another type of cable is the rollover cable, which is used to connect to a console port to manage a device such as a router or switch. The pin mapping for a rollover cable is 1 [bda] 8, 2 [bda] 7, 3 [bda] 6, 4 [bda] 5. The end of the cable looks like an RJ45 eight-pin connector.

Note

A traditional port found in a PC’s NIC is called a *media-dependent interface* (*MDI*). If a straight-through cable connects a PC’s MDI port to an Ethernet switch port, the Ethernet switch port needs to swap the transmit pair of wires (that is, the wires connected to pins 1 and 2) with the receive pair of wires (that is, the wires connected to pins 3 and 6).

Therefore, a traditional port found on an Ethernet switch is called a *media-dependent interface crossover* (*MDIX*), and it reverses the transmit and receive pairs. However, if you want to interconnect two switches, where both switch ports used for the interconnection are MDIX ports, the cable needs to be a crossover cable.

Fortunately, most modern Ethernet switches have ports that can automatically detect whether they need to act as MDI ports or MDIX ports and make the appropriate adjustments. This eliminates the necessity of using straight-through cables for some Ethernet switch connections and crossover cables for other connections. With this *Auto-MDIX* feature, you can use either straight-through cables or crossover cables.

##### Twisted-Pair Cable Connectors

Common connectors used on twisted-pair cables are as follows:

![](../images/key_topic_icon_158.jpg)

- [***RJ45***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_563): A type 45 registered jack (RJ45) is an eight-pin connector found in most Ethernet networks. However, most Ethernet implementations only use four of the eight pins.
- [***RJ11***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_562): A type 11 registered jack (RJ11) has the capacity to be a six-pin connector. However, most RJ11 connectors have only two or four conductors. An RJ11 connector is found in most home telephone networks. However, most home phones use only two of the six pins.
- **DB-9 (RS-232):** A nine-pin D-subminiature (DB-9) connector is an older connector used for low-speed asynchronous serial communications, such as a PC to a serial printer, a PC to a console port of a router or switch, or a PC to an external modem. Do not confuse the DB-9 with a DB-25. The DB-25 connector was also used for the serial or parallel ports of early personal computers.

[Figure 5-7](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig07) shows what these connectors look like.

![](../images/05fig07.jpg)


**Figure 5-7** Twisted-Pair Cable Connectors

#### Plenum Versus Non-plenum Cable

If a twisted-pair cable is to be installed under raised flooring or in an open-air return, fire codes must be considered. For example, imagine that there was a fire in a building. If the outer insulation of a twisted-pair cable caught on fire or started to melt, it could release toxic fumes. If those toxic fumes were released in a location such as an open-air return, those fumes could be spread throughout a building, posing a huge health risk.

To mitigate the concern of pumping poisonous gas throughout a building’s HVAC system, [***plenum cable***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_498) can be used. The outer insulator of a plenum twisted-pair cable is not only fire retardant; in addition, some plenum cabling uses a fluorinated ethylene polymer (FEP) or a low-smoke polyvinyl chloride (PVC) to minimize dangerous fumes.

Note

Check with your local fire codes before installing network cabling.

#### Fiber-Optic Cable

An alternative to copper cabling is fiber-optic cabling, which sends light (instead of electricity) through an optical fiber (typically made of glass). Using light instead of electricity makes fiber optics immune to EMI. Also, depending on the Layer 1 (physical layer) technology being used, fiber-optic cables typically have greater range (that is, a greater maximum distance between networked devices) and greater data-carrying capacity.

Lasers are often used to inject light pulses into a fiber-optic cable. However, lower-cost light-emitting diodes (LEDs) are also available. Fiber-optic cables are generally classified according to their diameter and fall into one of two categories: [***multimode fiber (MMF)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_420) and [***single-mode fiber (SMF)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_625).

The wavelengths of light also vary between MMF and SMF cables. Usually, wavelengths of light in an MMF cable are in the range 850–1300 nm, where nm stands for nanometers. (A nanometer is one-billionth of a meter.) Conversely, the wavelengths of light in an SMF cable are usually in the range 1310–1550 nm. A fiber coupler could be used to connect two fiber cables, back-to-back.

##### Multimode Fiber

When a light source, such as a laser, sends light pulses into a fiber-optic cable, what keeps the light from simply passing through the glass and being dispersed into the surrounding air? The trick is that fiber-optic cables use two different types of glass. There is an inner strand of glass (that is, a *core*) surrounded by an outer *cladding* of glass, similar to the construction of the previously mentioned coaxial cable.

The light injected by a laser (or LED) enters the core, and the light is prevented from leaving that inner strand and going into the outer cladding of glass. Specifically, the indexes of refraction of these two different types of glass are so different that if the light attempts to leave the inner strand, it hits the outer cladding and bends back on itself.

To better understand this concept, consider a straw in a glass of water, as shown in [Figure 5-8](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig08). Because air and water have different indexes of refraction (that is, light travels at slightly different speeds in air and water), the light that bounces off the straw and travels to our eyes is bent by the water’s index of refraction. When a fiber-optic cable is manufactured, dopants are injected into the two types of glasses, making up the core and cladding to give them significantly different indexes of refraction, thus causing any light attempting to escape to be bent back into the core.

![](../images/05fig08.jpg)


**Figure 5-8** Example: Refractive Index

The path that light takes through a fiber-optic cable is called a *mode of propagation*. The diameter of the core in a multimode fiber is large enough to permit light to enter the core at different angles, as depicted in [Figure 5-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig09). If light enters at a steep angle, it bounces back and forth much more frequently on its way to the far end of the cable than does light that enters the cable perpendicularly. If pulses of light representing different bits travel down the cable using different modes of propagation, it is possible that the bits (that is, the pulses of light representing the bits) will arrive out of order at the far end (where the pulses of light, or absence of light, are interpreted as binary data by photoelectronic sensors).

![](../images/key_topic_icon_158.jpg)

![](../images/05fig09.jpg)


**Figure 5-9** Light Propagation in Multimode Fiber

For example, say that the pulse of light representing the first bit intersects the core at a steep angle and bounces back and forth many times on its way to the far end of the cable, while the light pulse representing the second bit intersects the core perpendicularly and does not bounce back and forth very much. With all of its bouncing, the first bit has to travel further than the second bit, and so the bits might arrive out of order. This condition is known as *multimode delay distortion*. To mitigate multimode delay distortion, multimode fiber (MMF) is typically limited to shorter distances than SMF.

##### Single-Mode Fiber

Single-mode fiber (SMF) eliminates the issue of multimode delay distortion by having a core with a diameter so small that it permits only one mode (that is, one path) of propagation, as shown in [Figure 5-10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig10). With the issue of multimode delay distortion mitigated, SMF typically can be run for longer distances than MMF.

![](../images/key_topic_icon_158.jpg)

![](../images/05fig10.jpg)


**Figure 5-10** Light Propagation in Single-Mode Fiber

A potential downside to SMF, however, is cost. Because SMF has to be manufactured to very exacting tolerances, you usually pay more for a given length of single-mode fiber-optic cabling. However, for some implementations where greater distances are required, the cost is an acceptable trade-off for reaching greater distances.

##### Fiber-Optic Cable Connectors

Some common connectors used on fiber-optic cables are as follows:

- **ST:** A [***straight tip (ST) connector***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_660) is sometimes referred to as a *bayonet connector*, because of the long tip extending from the connector. ST connectors are most commonly used with MMF. You connect an ST connector to a terminating device by pushing the connector into the terminating equipment and then twisting the connector housing to lock it in place.
- **SC:** Different literature defines an SC connector as [***subscriber connector (SC)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_667), *standard connector*, or *square connector*. You connect an SC connector by pushing it into the terminating device; you can remove it by pulling the connector from the terminating device. This connector type has slight variants within the industry, with the major types being APC, UPC, and MTRJ. Always consult with the vendor or an IT staff member regarding the exact requirements.
- **LC:** You connect a *Lucent connector*, *little connector*, or [***local connector (LC)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_383) to a terminating device by pushing the connector into the terminating device. You can remove it by pressing the tab on the connector and pulling it out of the terminating device.
- **MTRJ:** The most unique characteristic of a *media termination recommended jack* (*MTRJ*) or mechanical transfer (MT) [***registered jack (RJ)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_545) connector is that two fiber strands (a transmit strand and a receive strand) are included in a single connector. You connect an MTRJ connector by pushing it into the terminating device; you can remove it by pulling the connector from the terminating device.

[Figure 5-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig11) shows what these connectors look like.

![](../images/05fig11.jpg)


**Figure 5-11** Common Fiber-Optic Connectors

Note

Yet another connector type you might encounter in a data center is the [***multi-fiber push on (MPO) connector***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_417) type. It is a high-density fiber-optic connector sometimes used for its ability to streamline cabling and support high-bandwidth applications. MPO connectors can house multiple fibers—typically 12, 24, or more—in a single interface, significantly increasing the amount of data transmitted through a single connection. This design reduces physical space requirements and simplifies network scalability and maintenance.

##### Fiber Connector Polishing Styles

Fiber-optic cables have different types of mechanical connections. The type of connection impacts the quality of the fiber-optic transmission. Listed from basic to better, the options include physical contact (PC), ultra physical contact (UPC), and angled physical contact (APC), which refer to the polishing styles of fiber-optic connectors. The different polish of the fiber-optic connectors results in different performance of the connector. The less back reflection, the better the transmission. The PC back reflection is –40 dB, the UPC back reflection is around –55 dB, and the APC back reflection is about –70 dB.

![](../images/key_topic_icon_158.jpg)

#### Ethernet and Fiber Standards (802.3)

It is time to tackle some of the most important [***802.3 standards***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_027) that define our Ethernet networks of the past and those that we rely on today. A popular implementation of Ethernet, in the early days, was called 10BASE5. The 10 in 10BASE5 referred to network throughput, specifically 10Mbps (that is, 10 million [mega] bits per second). The BASE in 10BASE5 referred to baseband, as opposed to broadband. Finally, the 5 in 10BASE5 indicated the distance limitation of 500 m. The cable used in 10BASE5 networks, illustrated in [Figure 5-12](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig12), was a larger diameter than most types of media. In fact, this network type became known as thicknet.

![](../images/05fig12.jpg)


**Figure 5-12** 10BASE5 Cable

Another early Ethernet implementation was 10BASE2. From the previous analysis of 10BASE5, you might conclude that 10BASE2 was a 10Mbps baseband technology with a distance limitation of 200 meters. That is almost correct. However, 10BASE2’s actual distance limitation was 185 m. The cabling used in 10BASE2 networks was significantly thinner and therefore less expensive than 10BASE5 cabling. As a result, 10BASE2 cabling, illustrated in [Figure 5-13](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig13), was known as thinnet or cheapernet.

![](../images/05fig13.jpg)


**Figure 5-13** Coaxial Cable Used for 10BASE2

10BASE5 and 10BASE2 networks are rarely, if ever, seen today. The cabling used by these legacy technologies quickly faded in popularity with the advent of UTP cabling. The 10Mbps version of Ethernet that relied on UTP cabling, an example of which is provided in [Figure 5-14](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig14), is known as 10BASE-T. Notice that the “T” in 10BASE-T refers to twisted-pair cabling.

![](../images/05fig14.jpg)


**Figure 5-14** UTP Cable Used for 10BASE-T

#### Distance and Speed Limitations

To understand the bandwidth available on networks, you need to understand a few terms. You should already know that a *bit* refers to one of two values. These values are represented using binary math, which uses only the numbers 0 and 1. On a cable such as twisted-pair cable, a bit could be represented by the absence or presence of voltage. Fiber-optic cables, however, might represent a bit with the absence or presence of light.

The bandwidth of a network is measured in terms of how many bits the network can transmit during a 1-second period of time. For example, if a network has the capacity to send 10,000,000 (that is, 10 million) bits in a 1-second period of time, the bandwidth capacity is said to be 10 megabits (that is, millions of bits) per second (or *Mbps*). [Table 5-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05tab04) defines common bandwidths supported on distinct types of Ethernet networks.

![](../images/key_topic_icon_158.jpg)


**Table 5-4** Ethernet Bandwidth Capacities

| Ethernet Type | Bandwidth Capacity |
| --- | --- |
| Standard Ethernet | 10Mbps: 10 million bits per second (that is, 10 megabits per second) |
| Fast Ethernet | 100Mbps: 100 million bits per second (that is, 100 megabits per second) |
| Gigabit Ethernet | 1Gbps: 1 billion bits per second (that is, 1 gigabit per second) |
| 10-Gigabit Ethernet | 10Gbps: 10 billion bits per second (that is, 10 gigabits per second) |
| 40-Gigabit Ethernet | 40Gbps: 40 billion bits per second (that is, 40 gigabits per second) |
| 100-Gigabit Ethernet | 100Gbps: 100 billion bits per second (that is, 100 gigabits per second) |

The type of cabling used in an Ethernet network influences the bandwidth capacity and the distance limitation of the network. For example, fiber-optic cabling often has a higher bandwidth capacity and can be run longer distances than twisted-pair cabling.

As mentioned earlier in this chapter, because of the issue of multimode delay distortion, SMF usually has a longer distance limitation than MMF.

Although not comprehensive, [Table 5-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05tab05) lists a number of Ethernet standards, along with the media type, bandwidth capacity, and distance limitation for each.

![](../images/key_topic_icon_158.jpg)


**Table 5-5** Types of Ethernet

| Ethernet Standard | Media Type | Bandwidth Capacity | Distance Limitation |
| --- | --- | --- | --- |
| 10BASE5 | Coax (thicknet) | 10Mbps | 500 m |
| 10BASE2 | Coax (thinnet) | 10Mbps | 185 m |
| 10BASE-T | Cat 3 (or higher) UTP | 10Mbps | 100 m |
| 100BASE-TX | Cat 5 (or higher) UTP | 100Mbps | 100 m |
| 100BASE-FX | MMF | 100Mbps | 2 km |
| 100BASE-SX | MMF | 100Mbps | 300 m |
| 1000BASE-T | Cat 5e (or higher) UTP | 1Gbps | 100 m |
| 1000BASE-TX | Cat 6 (or higher) UTP | 1Gbps | 100 m |
| 1000BASE-SX | MMF | 1Gbps | 550 m |
| 1000BASE-LX | SMF | 1Gbps | 5 km |
| 1000BASE-LH | SMF | 1Gbps | 10 km |
| 1000BASE-ZX | SMF | 1Gbps | 70 km |
| 10GBASE-SR | MMF | 10Gbps | 26–400 m |
| 10GBASE-LR | SMF | 10Gbps | 10–25 km |
| 10GBASE-ER | SMF | 10Gbps | 40 km |
| 10GBASE-SW | MMF | 10Gbps | 300 m |
| 10GBASE-LW | SMF | 10Gbps | 10 km |
| 10GBASE-EW | SMF | 10Gbps | 40 km |
| 10GBASE-T | Cat 6a (or higher) | 10Gbps | 100 m |
| 40GBASE-T | Cat 8 | 40Gbps | 30 m |
| 100GBASE-SR10 | MMF | 100Gbps | 125 m |
| 100GBASE-LR4 | SMF | 100Gbps | 10 km |
| 100GBASE-ER4 | SMF | 100Gbps | 40 km |

Note

Two often-confused terms are 100BASE-T and 100BASE-TX. 100BASE-T is not a specific standard. Rather, 100BASE-T is a category of standards and includes 100BASE-T2 (which uses two pairs of wires in a Cat 3 cable), 100BASE-T4 (which uses four pairs of wires in a Cat 3 cable), and 100BASE-TX. 100BASE-T2 and 100BASE-T4 were early implementations of 100Mbps Ethernet and are no longer used. Therefore, you can generally use the terms 100BASE-T and 100BASE-TX interchangeably.

Similarly, the term 1000BASE-X is not a specific standard. Rather, 1000BASE-X refers to all Ethernet technologies that transmit data at a rate of 1Gbps over fiber-optic cabling. Additional and creative ways of using Ethernet technology include IEEE 1901-2013, which could be used for Ethernet over HDMI cables and Ethernet over existing power lines to avoid having to run a separate cabling just for networking.

#### Transceivers

We like to think of a [***transceiver***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_711) as a connector for our cable to our networking device. But where does this fancy term come from? The term *transceiver* means that the connector combines both a transmitter and a receiver in the single, efficient unit.

When you want to uplink one Ethernet switch to another, you might need different connectors (for example, for MMF, SMF, or UTP) for different installations. Fortunately, some Ethernet switches have one or more empty slots in which you can insert a gigabit interface converter (GBIC). GBICs are interfaces that have a bandwidth capacity of 1Gbps and are available with MMF, SMF, and UTP connectors. This allows you to have flexibility in the uplink technology you use in an Ethernet switch.

A smaller variant of a regular GBIC is the [***small form-factor pluggable (SFP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_631), which is sometimes called a *mini-GBIC*. And to show the variety of transceivers you might encounter today, even this SFP has many variations, including the following:

- Enhanced form-factor pluggable (SFP+)
- [***Quad small form-factor pluggable (QSFP)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_535)
- Enhanced quad small form-factor pluggable (QSFP+)

Note

Ethernet networks are not the only networks that rely on transceivers. We also use them in [***Fibre Channel (FC)***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_268) networks. You might recall from [Chapter 2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02), “[Networking Appliances, Applications, and Functions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch02.xhtml#ch02),” that FC is often found in storage area networks (SANs). These SANs dedicate themselves to the fast storage and fast retrieval of the data companies rely on.

### Multiplexing in Fiber-Optic Networks

Remember, as mentioned in [Chapter 1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01), “[The OSI Model and Encapsulation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch01.xhtml#ch01),” that multiplexing allows multiple communications sessions to share the same physical medium. At this point, you need to be familiar with three different approaches common with fiber networking:

- **Dense wavelength-division multiplexing (DWDM):** DWDM uses as many as 32 light wavelengths on a single fiber, where each wavelength can support as many as 160 simultaneous transmissions using more than eight active wavelengths per fiber.
- **Coarse wavelength-division multiplexing (CWDM):** CWDM uses fewer than eight active wavelengths per fiber.
- **Bidirectional wavelength-division multiplexing (WDM):** This approach multiplexes a number of optical carrier signals onto a single optical fiber by using different wavelengths. Using this technique enables bidirectional communications over one strand of fiber and increases the overall capacity.

#### Media Converters

Due to the wide variety of copper and fiber cabling used by different network devices, you might need one or more [***media converters***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_407). Examples of media converters include the following:

- MMF to Ethernet
- SMF to Ethernet
- Fiber to coaxial
- SMF to MMF

### Real-World Case Study

The network engineers at Acme, Inc. are analyzing their physical media implementations and the performance they are achieving in their Ethernet-based LAN. The decision has been made to retain portions of the Cat 5e-based media, which is capable of 1Gbps speeds. Other areas of the network, particularly those that must deal with aggregate bandwidth demands, are being upgraded to Cat 8. Remember, Category 8 is capable of 40Gbps speeds. Cat 8 supports distances of only 30 to 36 m, depending on the patch cables used.

For Acme, these short distances and very high speeds are ideal for connections between high-speed multilayer switches that make up a good part of the distribution and core layers of the LAN.

The engineers are also examining the wireless technologies in use, focusing on evaluating the efficiency of the current Wi-Fi standards, identifying potential interference sources, and considering the implementation of advanced protocols such as Wi-Fi 6 to enhance network performance, coverage, and security in the environment.

### Summary

Here are the main topics covered in this chapter:

- This chapter began by exploring key concepts about wireless networking.
- There are many different options today when it comes to copper and fiber media and connectors. This chapter explored transmission media, connector types, and transceivers in great detail.
- This chapter also covered the different options for multiplexing in fiber-optic environments.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 5-6](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05tab06) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 5-6** Key Topics for [Chapter 5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| [Figure 5-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig01) | Non-overlapping Channels in the 2.4GHz Band | 103 |
| List | Variations of spread-spectrum technology | 105 |
| [Table 5-3](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05tab03) | Characteristics of 802.11 Standards | 108 |
| [Figure 5-2](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig02) | Satellite WAN Sample Topology | 109 |
| List | Common connectors used with coaxial cables | 112 |
| List | Common categories of UTP cabling | 115 |
| List | Common connectors used with twisted-pair cables | 116 |
| [Figure 5-9](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig09) | Light Propagation in Multimode Fiber | 119 |
| [Figure 5-10](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig10) | Light Propagation in Single-Mode Fiber | 120 |
| [Figure 5-11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05fig11) | Common Fiber-Optic Connectors | 122 |
| [Table 5-4](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05tab04) | Ethernet Bandwidth Capacities | 124 |
| [Table 5-5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05tab05) | Types of Ethernet | 125 |

### Complete Tables and Lists from Memory

Print a copy of [Appendix B](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb), “[Memory Tables](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appb.xhtml#appb),” or at least the section for this chapter and complete as many of the tables as possible from memory. [Appendix C](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc), “[Memory Tables Answer Key](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appc.xhtml#appc),” includes the completed tables and lists so you can check your work.

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[802.3 standards](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_01)

[802.11 standards](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_02)

[Bayonet Neill-Concelman (BNC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_03)

[cable speeds](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_04)

[cellular](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_05)

[coaxial cable](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_06)

[direct attach copper (DAC) cable](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_07)

[Ethernet](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_08)

[F-type connector](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_09)

[Fibre Channel (FC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_010)

[local connector (LC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_011)

[media converter](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_012)

[multi-fiber push on (MPO) connector](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_013)

[multimode fiber (MMF)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_014)

[plenum cable](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_015)

[quad small form-factor pluggable (QSFP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_016)

[registered jack (RJ)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_017)

[RJ11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_018)

[RJ45](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_019)

[satellite](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_020)

[single-mode fiber (SMF)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_021)

[small form-factor pluggable (SFP)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_022)

[straight tip (ST) connector](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_023)

[subscriber connector (SC)](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_024)

[transceiver](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_025)

[twinaxial cable](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_026)

[twisted pair](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#key_027)

### Additional Resources

**Wi-Fi Standards (and how they work):** <https://youtu.be/q64AZjPfa0Y>

**Fundamentals of Fiber Optic Cabling:** <https://youtu.be/-VYhfR8Fv2I>

**What is 5G?** <https://www.cisco.com/c/en/us/solutions/what-is-5g.html>

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_1) Which of the following categories of UTP cabling are commonly used for 1000BASE-T networks? (Choose two.)

1. Cat 5
2. Cat 5e
3. Cat 6
4. Cat 6f

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_2) Which type of cable might be required for installation in a drop ceiling that is used as an open-air return duct?

1. Riser
2. Plenum
3. Multimode
4. Twinaxial

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_3) Which of the following is the eight-pin connector found in most Ethernet networks?

1. RJ11
2. RJ45
3. DB-9
4. ST

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_4) What are the two major categories of fiber-optic media? (Choose two.)

1. Straight-through
2. Single-mode
3. Unshielded
4. Multimode

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_5) What is the speed of Fast Ethernet?

1. 1Mbps
2. 100Mbps
3. 1Gbps
4. 10Gbps

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_6) In what networking use case do we often find Fibre Channel (FC)?

1. A wide area network
2. A local area network
3. Satellite topologies
4. A storage area network

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_7) What Ethernet UTP cable was the first standard cable to carry data at speeds of 1Gbps?

1. Cat 4
2. Cat 5
3. Cat 5e
4. Cat 6

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_8) What 802.11 standard is also known as Wi-Fi 6?

1. 802.11g
2. 802.11n
3. 802.11ax
4. 802.11ac

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_9) Which standards were developed to define industry-standard pinouts and color coding for twisted-pair cabling? (Choose two.)

1. CWDM
2. TIA/EIA-568A
3. DWDM
4. TIA/EIA-568B

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_10) What fiber type would you use if the requirements to be met included an SMF media type, 1Gbps bandwidth capacity, and a distance limitation of 5 km?

1. 1000BASE-LX
2. 1000BASE-SX
3. 1000BASE-TX
4. Thicknet

[**11.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_11) In the 2.4GHz frequency band, which are considered non-overlapping channels?

1. 36, 40, 44
2. 48, 52
3. 56, 60
4. 1, 6, 11

[**12.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_12) Which of the following is a set of advanced technologies included with IEEE 802.11ac and 802.11ax that dramatically enhances wireless throughput?

1. MIMO
2. MU-MIMO
3. CDMA
4. GSM

[**13.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_13) Which type of fiber-optic cable is used for longer distances?

1. SMF
2. MMF
3. MPO
4. ST

[**14.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz5_14) Which category of Ethernet cable is capable of 40Gbps speeds and ideal for connections in a data center between high-speed multilayer switches?

1. Cat 5e
2. Cat 6a
3. Cat 7
4. Cat 8