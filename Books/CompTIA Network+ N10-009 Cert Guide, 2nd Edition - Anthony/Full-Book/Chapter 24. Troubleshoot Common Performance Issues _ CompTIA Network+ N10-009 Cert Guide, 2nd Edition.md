## Chapter 24

## Troubleshoot Common Performance Issues

This chapter covers the following topics related to Objective 5.4 (Given a scenario, troubleshoot common performance issues) of the CompTIA Network+ N10-009 certification exam:

- Congestion/contention
- Bottlenecking
- Bandwidth

  - Throughput capacity
- Latency
- Packet loss
- Jitter
- Wireless

  - Interference

    - Channel overlap
  - Signal degradation or loss
  - Insufficient wireless coverage
  - Client disassociation issues
  - Roaming misconfiguration

Our networks today are so important to the organization that poor performance is considered almost as big an issue as a lack of network functionality. In this chapter, we take a close look at the some of the major factors in this important networking aspect. You will quickly notice that this chapter has a definite bias toward wireless networking performance. Troubleshooting wireless might be a close second to supporting local network printers—although typically it is not as labor intensive. Wireless has become an expected part of the enterprise network that is a fairly consistent source of troubleshooting for you and your department.

### Foundation Topics

### Network Performance Considerations

What are the enemies of a highly performant network? There are many. Let’s begin this chapter by tackling some of the most important issues when it comes to your network’s performance. By the way, you might recognize some of these issues as they have been mentioned in previous chapters.

![](../images/key_topic_icon_158.jpg)

- [***Bandwidth*:**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_082) Bandwidth refers to the maximum amount of data that can be transmitted over the network in a given amount of time, usually measured in bits per second (bps). Think of it as the width of a highway: the wider the highway, the more cars can travel on it at once. Similarly, higher bandwidth allows more data to flow through the network quickly and efficiently. If a network has low bandwidth, it can lead to slow Internet speeds and long loading times for websites and applications, affecting overall network performance.

Note

Later in this chapter, we discuss network throughput capacity. This is often confused with the concept of bandwidth. Remember, bandwidth refers to the maximum amount of data that can be transmitted over a network in a given amount of time, whereas throughput is the actual amount of data successfully transmitted and received over the network during a specific time period, often affected by various factors such as network congestion, latency, and packet loss.

- ***[Congestion](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_165)/[contention](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_172)*:** Congestion and contention are important factors that affect how well a network performs. Congestion happens when there is too much traffic on the network, causing delays and data loss because the network can’t handle all the data at once. Contention occurs when multiple devices or applications try to use the same network resources at the same time, leading to competition for bandwidth and slower performance. Both congestion and contention can make a network less efficient and slower, which is why managing them is crucial for maintaining a fast and reliable network.
- [***Bottlenecks*:**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_098) A network bottleneck is a point in the network where the flow of data is slowed down or restricted, much like a narrow section of a road that causes traffic to back up. This restriction can occur because of limited bandwidth, outdated hardware, or excessive network traffic. When a bottleneck happens, it can cause delays, slow down data transfer, and reduce the overall performance of the network.
- [***Latency*:**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_358) Latency is the time it takes for a data packet to travel from its source to its destination across a network and is one of the components that leads to network delays that frustrate users. Wireless networks may experience more delay than their wired counterparts. One reason for the increased delay is the use of carrier-sense multiple access with collision avoidance (CSMA/CA) in WLANs; in an attempt to avoid collisions, CSMA/CA introduces a random delay before data is transmitted. Another reason for the increased delay is the fact that all wireless devices associated with a single wireless AP are in the same collision domain, introducing the possibility of collisions (retransmissions), which can increase delay.
- [***Packet loss*:**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_476) Packet loss occurs when data packets traveling across a network fail to reach their destination, causing parts of the transmitted information to be missing. This can happen due to network congestion, faulty hardware, or poor signal quality. When packet loss occurs, it can lead to slow Internet speeds, disrupted voice or video calls, and incomplete data transfers.
- [***Jitter*:**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_351) Jitter refers to the variation in the time it takes for data packets to travel across a network. Instead of arriving at a consistent pace, packets can arrive irregularly, causing delays and disruptions. This can be especially problematic for activities that require a steady stream of data, like video calls or online gaming, where jitter can result in poor video quality, lag, and choppy audio. Notice that jitter can be far worse than simple latency. If there is a large latency in the network that is predictable, various mechanisms can be used to deal with this. On the other hand, when there is high jitter, it can be very problematic.

### Wireless Performance Considerations

[Chapter 5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05), “[Transmission Media and Transceivers](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05),” examines wireless standards. As you should recall from that chapter, there are big differences in the 802.11 standards when it comes to the specifications and limitations of each standard.

This section reviews just some of the key values and concepts that you need to be concerned about when troubleshooting WLAN deployments:

![](../images/key_topic_icon_158.jpg)

- **Speed:** Typically, when the speed of the wireless technology is described, it is actually the theoretical maximum speed that is actually being described. For example, the speed of 802.11n is typically said to be 300Mbps. But is this true? In short, the answer is no. A more accurate way to describe how a WLAN is actually performing is to look at throughput, described next.
- [***Throughput*:**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_695) Throughput (or *throughput capacity*) is typically used to indicate the amount of data you are able to send on the network media. In this case, of course, the media is the radio frequencies that power wireless. Although the stated speed of 802.11n is 300Mbps, when you actually test the throughput, you might discover that the network is averaging 225Mbps. This actual throughput measurement provides a much more accurate picture of the capabilities of the network segment.
- **Distance:** Attenuation is a fact of life with network media. As the signal gets farther and farther away from the source, the signal weakens, and speed (and throughput) suffer. We often call this [***signal degradation***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_620) or *loss*. Notice that in a wired infrastructure, the effect of distance can be much easier to predict. When you are troubleshooting wireless environments, it’s important to keep in mind that all distances are not created equal. For example, there might be only half the distance between your access point (AP) and your client as between your AP and another client in your network. If there is a large source of WLAN interference in the shorter path, this might be the much more problematic client system.

Note

There are actually many places in the wireless infrastructure where attenuation can be an issue. A careful analysis of the Wi-Fi design might find attenuation/*signal loss* resulting from the antenna cable in use. This might add to the existing and known problems of RF attenuation and signal loss.

- **Received signal strength indication (RSSI) signal strength:** When you are performing site surveys or just performing typical wireless troubleshooting, it is important to use metric information that you can trust and interpret accurately. The RSSI might be presented in different formats, depending on the software you are working with, but comparing your internal testing results can make this measurement extremely valuable. No matter how exactly you see the value, the RSSI is a measure of the power level being received by the local client you are testing with. In most software packages, the greater the RSSI value, the stronger the signal, and the better the chances for higher throughput.
- **Effective isotropic radiated power (EIRP)/power settings:** Another very valuable metric used with wireless today, EIRP, measures the maximum amount of power that could be radiated from an antenna. Of course, this value must incorporate the antenna gain and the transmitter power of the RF system. You most often see EIRP presented as decibels over isotropic, or dBi.

### Other Wireless Considerations

Troubleshooting wireless networks might seem overwhelming compared with troubleshooting wired infrastructures. As described in the following sections, there are certainly many unique considerations when troubleshooting Wi-Fi networks. However, through study and practice, you will soon be as efficient at troubleshooting Wi-Fi as you are at troubleshooting a pesky network printer.

#### Antennas

As discussed in [Chapter 11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11), antenna choices are often critical for the proper functioning of a wireless LAN. These choices will often directly impact the challenge of *insufficient wireless coverage*. You need to ensure that the most critical design goals were met:

- Double-check distances from the clients and APs.
- Test the coverage area of the antenna type and form factor selected.
- Test both the indoor and outdoor coverages.
- Test for interference with other APs.

Recall from [Chapter 11](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch11.xhtml#ch11) that there are multiple types of wireless antennas, and they fall into two broad categories, based on coverage area:

- **Omnidirectional:** The signal is spread in nearly a 360-degree radius around the antenna.
- **Unidirectional:** The signal is projected in a single, relatively precise direction.

Note

The direction in which an antenna emits signal is termed *polarization*.

#### Frequencies and Channels

Keep in mind these key facts regarding frequencies and channels when troubleshooting wireless networks:

![](../images/key_topic_icon_158.jpg)

- WLANs use frequencies in the 2.4GHz–2.5GHz range or in the 5.725GHz–5.875GHz range.
- Within each band are specific frequencies (or *channels*) at which wireless devices operate.
- In the 2.4GHz band, channel frequencies are separated by 5MHz (with the exception of channel 14, which has 12MHz of separation from channel 13).
- A single channel’s transmission can spread over a frequency range of 22MHz. As a result, five consecutive channels tend to overlap one another. We refer to this challenge as [***channel overlap***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_134). Remember, in the United States, the non-overlapping channels are 1, 6, and 11. To avoid [***interference***](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_326), nearby wireless APs should use frequencies that do not overlap with one another.
- More and more 802.11ax (Wi-Fi 6) devices are currently available. This technology extends Wi-Fi into the 6GHz band.

#### More Considerations

An exhaustive list of WLAN considerations is beyond the scope of this book, but there are a few more you might encounter in a network and on the Network+ exam:

- **AP association time:** In larger enterprise environments, wireless LAN controllers (WLCs) often provide the control plane intelligence that APs lack. Key metrics to consider in this environment are how long it takes for a typical client to properly associate with an AP and how long it takes an AP to associate with a WLC. These are both points of latency as well as potential failures.
- **Site survey:** There is no substitute for a thorough, well-planned, well-documented site survey when it comes to planning and deploying wireless successfully. When implementing a production WLAN, planning is a much better option than simply trying and failing. A proper site survey can set you up for great success. It will help you determine where to place antennas and what types of antennas you need, and it will help you learn about potential sources of interference and other enemies of the WLAN. Fortunately, there are many options to choose from when it comes to site survey blueprints and software packages.

  In a site survey, you use Wi-Fi and other wireless analyzers to understand and map out the wireless infrastructure. One output is a wireless heat map, which provides a visual method for understanding coverage and signal strength.

### Common Wireless Issues

Network engineers are consistently thinking about what can go wrong. Fortunately, this type of doomsday thinking can be very valuable in networking. The following are some of the common issues you need to be aware of when it comes to wireless networking:

![](../images/key_topic_icon_158.jpg)

- **Interference:** Wireless communication can be interrupted due to radio frequency interference (RFI). Common RFI sources that impact wireless networks include 2.4GHz cordless phones, microwave ovens, baby monitors, and gaming consoles.
- **Signal strength:** The RSSI value measures the power of a wireless signal. RSSI values vary based on distance from a wireless antenna and physical objects interfering with line-of-sight communication with a wireless antenna (for example, drywall, metal filing cabinets, elevator shafts). Some wireless networks automatically drop their wireless transmission rate when an RSSI value drops below a certain value.
- **Misconfiguration of wireless parameters:** For communication to occur, a variety of wireless parameters must match between a wireless client and a wireless AP. For example, the client needs to be using a wireless standard supported by the wireless AP (for example, IEEE 802.11g/n/ac/ax). Wireless channels must also match. However, a wireless client usually automatically sets its channel based on the wireless AP’s channel. Encryption standards must match. In addition, the service set identifier (SSID) of a wireless AP must be selected by the wireless client. In many cases, a wireless AP broadcasts its SSID, and a wireless client can select that SSID from a list of visible SSIDs. In other cases, a wireless AP does not broadcast its SSID, and a wireless client must have a matching SSID manually configured.
- **Multiple paths of propagation:** An electromagnetic waveform cannot pass through a perfect conductor. Admittedly, perfect conductors do not exist in most office environments. However, very good conductors, such as metal filing cabinets, are commonplace in offices. As a result, if the waveform of a wireless transmission encounters one of these conductive objects, most of the signal bounces off the object, creating multiple paths (modes) of propagation. These multiple modes of propagation can cause data (specifically, bits) to arrive at uneven intervals, possibly corrupting data. This problem is similar to multimode delay distortion, which occurs in multimode fiber-optic cabling.
- **Incorrect AP placement:** Wireless APs should be strategically located in a building to provide sufficient coverage to all desired coverage areas. However, the coverage areas of wireless APs using overlapping channels should not overlap. To maintain coverage between coverage areas, you should have overlapping coverage areas among wireless APs using non-overlapping channels (for example, channels 1, 6, and 11 for wireless networks using the 2.4GHz band of frequencies). A common design recommendation is that overlapping coverage areas (using non-overlapping channels) should have an overlap of approximately 10% to 15%. Keep in mind that the 5GHz band and the 6 GHz band of Wi-Fi 6e offer many more non-overlapping channels.
- **Captive portal issues:** Many wireless network environments make use of a captive portal. A captive portal is a web page that often presents an acceptable use policy (AUP) that the user must accept in order to access the Internet via a wireless connection. The web page also typically collects profile information from end users. It might even market products to wireless users. The captive portal is a key element of the wireless association process, and so it must perform as expected. Most wireless networks fail closed, which means if the captive portal or any other step of the process is not functioning, the wireless network remains inaccessible to new clients.
- **[*Client disassociation*](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_145) issues:** Clients appreciate a wireless network much more if they are able to remain connected. While you might be able to immediately rule out many categories of issues that could cause disassociation, there are plenty that might require additional inspection and analysis. Remember that there is an entire category of attacks that target client disassociation, and these attacks are often initial steps in much larger attacks; an attacker may disassociate a client and then associate it to a rogue device.
- **[*Roaming*](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/gloss.xhtml#gloss_564) misconfiguration:** Roaming misconfigurations happen when devices like smartphones or laptops have trouble smoothly switching from one Wi-Fi access point to another as they move around. Instead of seamlessly staying connected, these devices might drop the connection or experience interruptions. This can lead to slow Internet speeds, dropped calls, and delays in data transfer. Ensuring proper configuration of roaming settings is crucial for maintaining consistent and reliable network performance, especially in environments like offices or campuses where users frequently move between different network areas.

### Wireless Network Troubleshooting

As a practice troubleshooting scenario for wireless networks, consider [Figure 24-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#ch24fig01). Based on this topology, can you spot a design issue with the wireless network?

![](../images/key_topic_icon_158.jpg)

![](../images/24fig01.jpg)


**Figure 24-1** Wireless Network Troubleshooting: Sample Topology

#### Wireless Network Troubleshooting Solution

The wireless network presented in [Figure 24-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#ch24fig01) includes two wireless APs. Although these wireless APs have a matching wireless standard, encryption type, and SSID, the channels being used (channels 1 and 5) interfere with one another. Recall from [Chapter 5](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch05.xhtml#ch05) that channels in the 2.4GHz band need at least five channels of separation (for overlapping coverage areas), but the channels used in this example have only four channels of separation. A fix for this *channel overlap* issue is to assign AP-2 to channel 6, thus providing five channels of separation between AP-1 and AP-2.

A wireless analyzer may be needed to identify problems such as signal loss, overlapping or mismatched channels, unacceptable signal-to-noise ratios, rogue APs, and power levels. Breaking down a problem into smaller pieces allows you to identify the fault domain or the area that is causing the problem. For example, if a user cannot access the wireless network, the pieces involved may be the user connecting to an incorrect SSID or problems with the AP, the switch, the WLC, the RADIUS server, the Active Directory (AD) server, or the user account and password. By testing the individual components, where possible, you can isolate the problem and then correct it.

### Real-World Case Study

Acme, Inc. has been troubleshooting poor performance issues that have been reported throughout the infrastructure of the main campus HQ. The networking team has been hard at work improving the wireless performance in the main Enterprise campus. As part of these improvements, the IT team is performing an analysis of the existing Wi-Fi signals. A big metric in this study is the RSSI and EIRP values throughout the location. The team has improved its heat map creation and has been studying the data collected through the use of a Wi-Fi analyzer.

Another big aspect of the improvements is the replacement of several access points and the introduction of a new and improved wireless LAN controller (WLC). Networking is also ensuring its new IT team members are properly trained in supporting and understanding the Wi-Fi infrastructure. This includes training on channel overlap, signal degradation, and interference issues.

### Summary

Here are the main topics covered in this chapter:

- This chapter described some of the important metrics associated with specifications and limitations in wired and wireless networking, including such topics as congestion, contention, and bottlenecks.
- This chapter examined several important considerations that are critical in wireless troubleshooting.
- This chapter concluded by examining some of the most common issues in wireless networks today, including such topics as channel overlap, signal degradation, and roaming misconfigurations.

### Exam Preparation Tasks

### Review All the Key Topics

Review the most important topics from this chapter, noted with the Key Topic icon in the outer margin of the page. [Table 24-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#ch24tab1) lists these key topics and the page number where each is found.

![](../images/key_topic_icon_158.jpg)


**Table 24-1** Key Topics for [Chapter 24](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#ch24)

| Key Topic Element | Description | Page Number |
| --- | --- | --- |
| List | Network performance considerations | 530 |
| List | Wireless specifications and limitations | 531 |
| List | Key facts for frequencies and channels | 533 |
| List | Common issues for wireless networking | 535 |
| [Figure 24-1](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#ch24fig01) | Wireless Network Troubleshooting: Sample Topology | 537 |

### Define Key Terms

Define the following key terms from this chapter and check your answers in the Glossary:

[bandwidth](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_082)

[bottleneck](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_098)

[channel overlap](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_134)

[client disassociation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_145)

[congestion](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_165)

[contention](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_172)

[interference](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_326)

[jitter](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_351)

[latency](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_358)

[packet loss](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_476)

[roaming](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_564)

[signal degradation](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_620)

[throughput](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/ch24.xhtml#key_695)

### Review Questions

The answers to these review questions appear in [Appendix A](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa), “[Answers to Review Questions](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#appa).”

[**1.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz24_1) Which of the following is a value measuring the power of a wireless signal?

1. RSSI
2. SSID
3. RFI
4. CSMA/CA

[**2.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz24_2) Which of the following are the most common sources of radio frequency interference (RFI) in a wireless network? (Choose three.)

1. Gaming consoles
2. Fax machines
3. Microwave ovens
4. Baby monitors
5. Bluetooth

[**3.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz24_3) Which metric provides the best idea of how a wireless network is actually performing?

1. Throughput
2. Speed
3. Relative jitter
4. Availability

[**4.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz24_4) A satellite dish antenna is an example of what type of wireless antenna?

1. Omnidirectional
2. Integrated
3. Beam-formed
4. Unidirectional

[**5.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz24_5) What is the name for a web page that is presented to wireless clients seeking access to a network?

1. Authentication server
2. Captive portal
3. Self-registration gateway
4. Supplicant client

[**6.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz24_6) Which of the following should you consider conducting before designing and deploying a high-performance WLAN infrastructure?

1. Site survey
2. Reconnaissance
3. Nmapping
4. Port scan

[**7.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz24_7) A target wireless client has been disconnected from the company AP and associated with a rogue device. What has most likely occurred?

1. Disassociation
2. Propagation
3. Incorrect AP placement
4. Misconfigured parameter

[**8.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz24_8) To maintain coverage between areas, you need to have overlapped coverage areas among wireless APs using non-overlapping channels. In the United States, what channels in the 2.4GHz band of frequencies should you use?

1. CSMA/CA channels
2. 1, 6, and 11
3. EIRP channels
4. 2, 7, and 12

[**9.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz24_9) Which of the following refers to the maximum amount of data that can be transmitted over the network in a given amount of time?

1. Latency
2. Jitter
3. Throughput
4. Bandwidth

[**10.**](https://learning.oreilly.com/library/view/comptia-network-n10-009/9780135367919/appa.xhtml#quiz24_10) What term best describes multiple devices or applications simultaneously competing for the same network resources, leading to potential delays and reduced performance?

1. Congestion
2. Bottleneck
3. Contention
4. Packet loss